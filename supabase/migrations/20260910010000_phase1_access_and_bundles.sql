-- Forge Phase 1 — access model, bundle/whatsapp fields, content gating.

-- ── New columns ──────────────────────────────────────────────────────────

alter table public.bundles
  add column whatsapp_group_link text;

alter table public.lessons
  add column is_free_preview boolean not null default false;

alter table public.profiles
  add column welcome_video_watched_at timestamptz;

-- ── Allow first-time bundle self-selection at signup ────────────────────
-- A student picks their own bundle once, at signup (assigned_bundle_id is
-- still null). Any change after that — or a change to role/approval_status
-- — is instructor-only, same as before.

create or replace function public.protect_privileged_profile_fields()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if new.role is distinct from old.role
     and not exists (
       select 1 from public.profiles where id = auth.uid() and role = 'instructor'
     )
  then
    raise exception 'Only an instructor can change role';
  end if;

  if new.approval_status is distinct from old.approval_status
     and not exists (
       select 1 from public.profiles where id = auth.uid() and role = 'instructor'
     )
  then
    raise exception 'Only an instructor can change approval_status';
  end if;

  if new.assigned_bundle_id is distinct from old.assigned_bundle_id
     and old.assigned_bundle_id is not null
     and not exists (
       select 1 from public.profiles where id = auth.uid() and role = 'instructor'
     )
  then
    raise exception 'Only an instructor can reassign an already-assigned bundle';
  end if;

  return new;
end;
$$;

-- ── Content access gating ────────────────────────────────────────────────
-- A track is accessible once a student is approved on the bundle it
-- belongs to (or the track is unattached / a lesson is flagged as a free
-- preview). Instructors always have access.

create or replace function public.can_access_track(p_track_id uuid)
returns boolean
language sql
stable
security definer set search_path = public
as $$
  select
    public.is_instructor()
    or exists (
      select 1
      from public.tracks t
      join public.profiles p on p.id = auth.uid()
      where t.id = p_track_id
        and (
          t.bundle_id is null
          or (p.approval_status = 'approved' and p.assigned_bundle_id = t.bundle_id)
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
      where l.id = p_lesson_id
        and (l.is_free_preview or public.can_access_track(l.track_id))
    );
$$;

drop policy if exists "lessons_authenticated_read" on public.lessons;
create policy "lessons_gated_read" on public.lessons
  for select using (public.can_access_lesson(id));

drop policy if exists "sections_authenticated_read" on public.sections;
create policy "sections_gated_read" on public.sections
  for select using (
    exists (
      select 1 from public.lessons l
      where l.id = lesson_id and public.can_access_lesson(l.id)
    )
  );
