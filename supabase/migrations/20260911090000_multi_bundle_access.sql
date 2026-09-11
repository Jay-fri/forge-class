-- Students can now hold more than one bundle at once (e.g. buying both
-- Python and Frontend separately), and an instructor can grant access to
-- one specific track outside of any bundle. Both replace the old single
-- profiles.assigned_bundle_id column with proper many-to-many tables.

create table public.student_bundles (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles (id) on delete cascade,
  bundle_id uuid not null references public.bundles (id) on delete cascade,
  granted_at timestamptz not null default now(),
  unique (student_id, bundle_id)
);

alter table public.student_bundles enable row level security;
create policy "student_bundles_owner_read" on public.student_bundles
  for select using (student_id = auth.uid() or public.is_instructor());
create policy "student_bundles_instructor_write" on public.student_bundles
  for all using (public.is_instructor()) with check (public.is_instructor());

create table public.student_track_grants (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles (id) on delete cascade,
  track_id uuid not null references public.tracks (id) on delete cascade,
  granted_at timestamptz not null default now(),
  unique (student_id, track_id)
);

alter table public.student_track_grants enable row level security;
create policy "student_track_grants_owner_read" on public.student_track_grants
  for select using (student_id = auth.uid() or public.is_instructor());
create policy "student_track_grants_instructor_write" on public.student_track_grants
  for all using (public.is_instructor()) with check (public.is_instructor());

-- Carry forward every existing single-bundle assignment.
insert into public.student_bundles (student_id, bundle_id)
select id, assigned_bundle_id from public.profiles where assigned_bundle_id is not null
on conflict do nothing;

-- ── Access gating updated for many bundles + direct track grants ────────

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
          or exists (
            select 1 from public.student_track_grants g
            where g.student_id = p.id and g.track_id = p_track_id
          )
          or (
            p.approval_status = 'approved'
            and exists (
              select 1
              from public.bundle_tracks bt
              join public.student_bundles sb on sb.bundle_id = bt.bundle_id and sb.student_id = p.id
              where bt.track_id = p_track_id
                and (
                  not exists (
                    select 1 from public.cohort_memberships cm
                    where cm.student_id = p.id and cm.bundle_id = bt.bundle_id
                  )
                  or exists (
                    select 1
                    from public.cohort_memberships cm
                    join public.cohorts c on c.id = cm.cohort_id
                    where cm.student_id = p.id and cm.bundle_id = bt.bundle_id and c.end_date >= current_date
                  )
                )
            )
          )
        )
    );
$$;

-- ── Signup now carries a list of bundle ids, not a single one ───────────

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  chosen_bundle_ids uuid[];
begin
  begin
    select array_agg(value::uuid) into chosen_bundle_ids
    from jsonb_array_elements_text(new.raw_user_meta_data -> 'bundle_ids');
  exception when others then
    chosen_bundle_ids := null;
  end;

  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data ->> 'full_name');

  if chosen_bundle_ids is not null then
    insert into public.student_bundles (student_id, bundle_id)
    select new.id, b.id
    from public.bundles b
    where b.id = any(chosen_bundle_ids) and b.is_active
    on conflict do nothing;
  end if;

  return new;
end;
$$;

-- ── Drop the now-unused single-bundle column and its guard clause ───────

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

  return new;
end;
$$;

alter table public.profiles drop column assigned_bundle_id;
