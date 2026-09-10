-- Forge Phase 2 — curriculum structure.
-- Introduces Track → Module → Lesson → Section (adding Module), and moves
-- bundle↔track association from a single FK to a many-to-many join table
-- (a track like "HTML/CSS/JS Fundamentals" can belong to more than one
-- bundle, e.g. both Frontend and Full Stack).

-- ── Modules ──────────────────────────────────────────────────────────────

create table public.modules (
  id uuid primary key default gen_random_uuid(),
  track_id uuid not null references public.tracks (id) on delete cascade,
  name text not null,
  slug text not null,
  order_index int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (track_id, slug)
);

create trigger set_updated_at before update on public.modules
  for each row execute function public.set_updated_at();

alter table public.modules enable row level security;

create policy "modules_authenticated_read" on public.modules
  for select using (auth.role() = 'authenticated');
create policy "modules_instructor_write" on public.modules
  for all using (public.is_instructor()) with check (public.is_instructor());

-- ── Lessons move from track_id to module_id ─────────────────────────────

alter table public.lessons add column module_id uuid references public.modules (id) on delete cascade;

insert into public.modules (track_id, name, slug, order_index)
select id, 'Getting Started', 'getting-started', 0
from public.tracks where slug = 'web-fundamentals';

update public.lessons l
set module_id = m.id
from public.modules m
where l.track_id = m.track_id and m.slug = 'getting-started';

alter table public.lessons alter column module_id set not null;
alter table public.lessons drop constraint if exists lessons_track_id_slug_key;
alter table public.lessons add constraint lessons_module_id_slug_key unique (module_id, slug);
alter table public.lessons drop column track_id;

-- ── Bundles ↔ tracks (many-to-many) ──────────────────────────────────────

create table public.bundle_tracks (
  bundle_id uuid not null references public.bundles (id) on delete cascade,
  track_id uuid not null references public.tracks (id) on delete cascade,
  primary key (bundle_id, track_id)
);

alter table public.bundle_tracks enable row level security;

create policy "bundle_tracks_public_read" on public.bundle_tracks
  for select using (true);
create policy "bundle_tracks_instructor_write" on public.bundle_tracks
  for all using (public.is_instructor()) with check (public.is_instructor());

insert into public.bundle_tracks (bundle_id, track_id)
select bundle_id, id from public.tracks where bundle_id is not null;

alter table public.tracks drop column bundle_id;

-- ── Access-gating functions updated for the new shape ───────────────────

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
          )
        )
    );
$$;

create or replace function public.can_access_lesson(p_lesson_id uuid)
returns boolean
language sql
stable
security definer set search_path = public
as $$
  select
    public.is_instructor()
    or exists (
      select 1
      from public.lessons l
      join public.modules m on m.id = l.module_id
      where l.id = p_lesson_id
        and (l.is_free_preview or public.can_access_track(m.track_id))
    );
$$;
