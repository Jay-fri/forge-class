-- Forge Phase 9 — notifications & engagement.
--
-- No domain yet means no reliable outbound email (see infra notes in the
-- master build prompt), so the real channels are WhatsApp and in-app. This
-- adds an in-app notification feed (populated by triggers, not client
-- calls, so nothing gets missed) plus cohort-expiry access locking.

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  type text not null check (type in ('submission_graded', 'lesson_published')),
  title text not null,
  body text,
  link text,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create index notifications_user_id_created_at_idx on public.notifications (user_id, created_at desc);

alter table public.notifications enable row level security;
create policy "notifications_owner_read" on public.notifications
  for select using (user_id = auth.uid());
create policy "notifications_owner_update" on public.notifications
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());
-- Inserts happen server-side via the triggers below — no insert policy
-- needed for the client.

-- ── Submission graded → notify the student ──────────────────────────────

create or replace function public.notify_submission_graded()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  v_assignment_title text;
begin
  if new.status = 'graded' and old.status is distinct from 'graded' then
    select title into v_assignment_title from public.assignments where id = new.assignment_id;
    insert into public.notifications (user_id, type, title, body, link)
    values (
      new.student_id,
      'submission_graded',
      'Your submission was graded',
      coalesce(v_assignment_title, 'Assignment') ||
        case
          when new.passed then ': passed'
          when new.passed is false then ': needs another look'
          else ''
        end,
      '/learn/assignment/' || new.assignment_id
    );
  end if;
  return new;
end;
$$;

create trigger notify_on_submission_graded after update on public.submissions
  for each row execute function public.notify_submission_graded();

-- ── Lesson published → notify every student who can reach that track ────

create or replace function public.notify_lesson_published()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  v_track_id uuid;
  v_track_slug text;
  v_module_slug text;
begin
  if new.status = 'published' and old.status is distinct from 'published' then
    select m.track_id, m.slug, t.slug
      into v_track_id, v_module_slug, v_track_slug
    from public.modules m
    join public.tracks t on t.id = m.track_id
    where m.id = new.module_id;

    insert into public.notifications (user_id, type, title, body, link)
    select p.id, 'lesson_published', 'New lesson added', new.title,
           '/learn/' || v_track_slug || '/' || v_module_slug || '/' || new.slug
    from public.profiles p
    where p.role = 'student'
      and p.approval_status = 'approved'
      and (
        not exists (select 1 from public.bundle_tracks bt where bt.track_id = v_track_id)
        or exists (
          select 1 from public.bundle_tracks bt
          where bt.track_id = v_track_id and bt.bundle_id = p.assigned_bundle_id
        )
      );
  end if;
  return new;
end;
$$;

create trigger notify_on_lesson_published after update on public.lessons
  for each row execute function public.notify_lesson_published();

-- ── Cohort-expiry access locking ─────────────────────────────────────────
-- A student with no cohort_membership yet keeps plain bundle-based access
-- (unchanged from before cohorts existed). A student enrolled in a cohort
-- for this bundle loses access once every such cohort's end_date has
-- passed — the in-app warning banner (client-side) covers the "nearing
-- the end" heads-up before this kicks in.

create or replace function public.can_access_track(p_track_id uuid)
returns boolean
language sql
stable
security definer set search_path = public
as $$
  select
    public.is_instructor()
    or exists (
      select 1 from public.profiles p
      where p.id = auth.uid()
        and (
          not exists (select 1 from public.bundle_tracks bt where bt.track_id = p_track_id)
          or (
            p.approval_status = 'approved'
            and exists (
              select 1 from public.bundle_tracks bt
              where bt.track_id = p_track_id and bt.bundle_id = p.assigned_bundle_id
            )
            and (
              not exists (
                select 1 from public.cohort_memberships cm
                where cm.student_id = p.id and cm.bundle_id = p.assigned_bundle_id
              )
              or exists (
                select 1
                from public.cohort_memberships cm
                join public.cohorts c on c.id = cm.cohort_id
                where cm.student_id = p.id
                  and cm.bundle_id = p.assigned_bundle_id
                  and c.end_date >= current_date
              )
            )
          )
        )
    );
$$;
