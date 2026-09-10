-- Forge Phase 6 — instructor dashboard.
-- Draft/publish for lessons, owner/grader team roles, and an audit log
-- driven by triggers (so it can't be forgotten at a call site).

-- ── Draft → publish for lessons ─────────────────────────────────────────

create type content_status as enum ('draft', 'published');

alter table public.lessons add column status content_status not null default 'draft';
update public.lessons set status = 'published'; -- backfill existing seeded content

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
        and l.status = 'published'
        and (l.is_free_preview or public.can_access_track(m.track_id))
    );
$$;

-- ── Team roles (owner vs grader) ────────────────────────────────────────

create type instructor_role as enum ('owner', 'grader');

alter table public.profiles add column instructor_role instructor_role;
update public.profiles set instructor_role = 'owner' where role = 'instructor';

create or replace function public.is_owner()
returns boolean
language sql
stable
security definer set search_path = public
as $$
  select exists (
    select 1 from public.profiles where id = auth.uid() and role = 'instructor' and instructor_role = 'owner'
  );
$$;

-- ── Audit log ────────────────────────────────────────────────────────────

create table public.audit_log (
  id uuid primary key default gen_random_uuid(),
  actor_id uuid references public.profiles (id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  detail jsonb,
  created_at timestamptz not null default now()
);

alter table public.audit_log enable row level security;
create policy "audit_log_instructor_read" on public.audit_log
  for select using (public.is_instructor());

create or replace function public.log_profile_audit()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if new.approval_status is distinct from old.approval_status then
    insert into public.audit_log (actor_id, action, entity_type, entity_id, detail)
    values (auth.uid(), 'approval_status_changed', 'profile', new.id,
      jsonb_build_object('from', old.approval_status, 'to', new.approval_status, 'student', new.email));
  end if;
  if new.assigned_bundle_id is distinct from old.assigned_bundle_id then
    insert into public.audit_log (actor_id, action, entity_type, entity_id, detail)
    values (auth.uid(), 'bundle_assignment_changed', 'profile', new.id,
      jsonb_build_object('from', old.assigned_bundle_id, 'to', new.assigned_bundle_id, 'student', new.email));
  end if;
  return new;
end;
$$;

create trigger audit_profile_changes after update on public.profiles
  for each row execute function public.log_profile_audit();

create or replace function public.log_bundle_audit()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.audit_log (actor_id, action, entity_type, entity_id, detail)
  values (
    auth.uid(),
    case tg_op when 'INSERT' then 'bundle_created' when 'UPDATE' then 'bundle_updated' else 'bundle_deleted' end,
    'bundle',
    coalesce(new.id, old.id),
    jsonb_build_object('name', coalesce(new.name, old.name))
  );
  return coalesce(new, old);
end;
$$;

create trigger audit_bundle_changes after insert or update or delete on public.bundles
  for each row execute function public.log_bundle_audit();

-- Generic content-edit logger, safe across tables with different shapes
-- (tracks/modules use `name`, lessons/sections use `title`).
create or replace function public.log_content_audit()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  v_row jsonb := to_jsonb(coalesce(new, old));
begin
  insert into public.audit_log (actor_id, action, entity_type, entity_id, detail)
  values (
    auth.uid(),
    case tg_op when 'INSERT' then 'content_created' when 'UPDATE' then 'content_updated' else 'content_deleted' end,
    tg_table_name,
    (v_row ->> 'id')::uuid,
    jsonb_build_object('label', coalesce(v_row ->> 'title', v_row ->> 'name'))
  );
  return coalesce(new, old);
end;
$$;

create trigger audit_tracks after insert or update or delete on public.tracks
  for each row execute function public.log_content_audit();
create trigger audit_modules after insert or update or delete on public.modules
  for each row execute function public.log_content_audit();
create trigger audit_lessons after insert or update or delete on public.lessons
  for each row execute function public.log_content_audit();
create trigger audit_sections after insert or update or delete on public.sections
  for each row execute function public.log_content_audit();
