-- Forge Phase 4 — progress & motivation.
-- Badges, bookmarks/notes, and server-side streak + badge-award logic so
-- the client only ever calls one RPC when a section is completed.

-- ── Badges ───────────────────────────────────────────────────────────────

create table public.badges (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique,
  name text not null,
  description text not null,
  created_at timestamptz not null default now()
);

alter table public.badges enable row level security;
create policy "badges_public_read" on public.badges for select using (true);
create policy "badges_instructor_write" on public.badges
  for all using (public.is_instructor()) with check (public.is_instructor());

insert into public.badges (slug, name, description) values
  ('first-lesson', 'First Lesson', 'Completed your first lesson.'),
  ('track-complete', 'Track Complete', 'Finished an entire track.'),
  ('streak-3', '3-Day Streak', 'Showed up three days in a row.'),
  ('streak-7', 'Week Streak', 'Showed up seven days in a row.'),
  ('streak-30', 'Month Streak', 'Showed up thirty days in a row.');

create table public.user_badges (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  badge_id uuid not null references public.badges (id) on delete cascade,
  track_id uuid references public.tracks (id) on delete cascade,
  earned_at timestamptz not null default now()
);

alter table public.user_badges enable row level security;
create policy "user_badges_owner_read" on public.user_badges
  for select using (user_id = auth.uid() or public.is_instructor());

-- ── Bookmarks / notes ────────────────────────────────────────────────────

create table public.section_bookmarks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  section_id uuid not null references public.sections (id) on delete cascade,
  note text,
  created_at timestamptz not null default now(),
  unique (user_id, section_id)
);

alter table public.section_bookmarks enable row level security;
create policy "section_bookmarks_owner_all" on public.section_bookmarks
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ── Track completion helper ──────────────────────────────────────────────

create or replace function public.is_track_completed(p_user_id uuid, p_track_id uuid)
returns boolean
language sql
stable
security definer set search_path = public
as $$
  select
    exists (select 1 from public.lessons l join public.modules m on m.id = l.module_id where m.track_id = p_track_id)
    and not exists (
      select 1
      from public.sections s
      join public.lessons l on l.id = s.lesson_id
      join public.modules m on m.id = l.module_id
      where m.track_id = p_track_id
        and not exists (
          select 1 from public.user_progress up
          where up.section_id = s.id and up.user_id = p_user_id and up.status = 'completed'
        )
    );
$$;

-- ── Streak bump (1-day grace/freeze for a missed day) ───────────────────

create or replace function public.bump_streak(p_user_id uuid)
returns void
language plpgsql
security definer set search_path = public
as $$
declare
  v_last date;
  v_current int;
  v_longest int;
begin
  select last_active_date, current_streak, longest_streak
    into v_last, v_current, v_longest
  from public.streaks where user_id = p_user_id;

  if not found then
    insert into public.streaks (user_id, current_streak, longest_streak, last_active_date)
    values (p_user_id, 1, 1, current_date);
    return;
  end if;

  if v_last = current_date then
    return; -- already counted today
  elsif v_last = current_date - 1 then
    v_current := v_current + 1;
  elsif v_last = current_date - 2 then
    v_current := v_current + 1; -- one missed day: freeze, don't reset
  else
    v_current := 1;
  end if;

  update public.streaks
  set current_streak = v_current,
      longest_streak = greatest(v_longest, v_current),
      last_active_date = current_date,
      updated_at = now()
  where user_id = p_user_id;
end;
$$;

-- ── One RPC the client calls per completed section ──────────────────────
-- Marks progress, bumps the streak, and awards any newly-earned badges.

create or replace function public.complete_section(p_section_id uuid)
returns void
language plpgsql
security definer set search_path = public
as $$
declare
  v_user uuid := auth.uid();
  v_track_id uuid;
  v_streak int;
begin
  insert into public.user_progress (user_id, section_id, status, completed_at)
  values (v_user, p_section_id, 'completed', now())
  on conflict (user_id, section_id)
  do update set status = 'completed', completed_at = now();

  perform public.bump_streak(v_user);

  if not exists (select 1 from public.user_badges where user_id = v_user and badge_id = (select id from public.badges where slug = 'first-lesson')) then
    insert into public.user_badges (user_id, badge_id)
    values (v_user, (select id from public.badges where slug = 'first-lesson'));
  end if;

  select m.track_id into v_track_id
  from public.sections s
  join public.lessons l on l.id = s.lesson_id
  join public.modules m on m.id = l.module_id
  where s.id = p_section_id;

  if v_track_id is not null and public.is_track_completed(v_user, v_track_id) then
    if not exists (select 1 from public.user_badges where user_id = v_user and track_id = v_track_id and badge_id = (select id from public.badges where slug = 'track-complete')) then
      insert into public.user_badges (user_id, badge_id, track_id)
      values (v_user, (select id from public.badges where slug = 'track-complete'), v_track_id);
    end if;
  end if;

  select current_streak into v_streak from public.streaks where user_id = v_user;
  if v_streak in (3, 7, 30) then
    declare
      v_slug text := 'streak-' || v_streak;
    begin
      if not exists (select 1 from public.user_badges where user_id = v_user and badge_id = (select id from public.badges where slug = v_slug)) then
        insert into public.user_badges (user_id, badge_id)
        values (v_user, (select id from public.badges where slug = v_slug));
      end if;
    end;
  end if;
end;
$$;
