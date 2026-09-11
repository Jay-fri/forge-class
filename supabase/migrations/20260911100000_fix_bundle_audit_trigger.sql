-- Bug found via live testing after the multi-bundle migration: a separate
-- audit trigger (log_profile_audit, from phase 6) still referenced the
-- dropped profiles.assigned_bundle_id column, breaking every profile
-- update. Fixes that trigger, and adds a proper audit trail on
-- student_bundles insert/delete to replace the old single-column version.

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
  return new;
end;
$$;

create or replace function public.log_student_bundle_audit()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  v_bundle_name text;
  v_student_email text;
begin
  select name into v_bundle_name from public.bundles where id = coalesce(new.bundle_id, old.bundle_id);
  select email into v_student_email from public.profiles where id = coalesce(new.student_id, old.student_id);
  insert into public.audit_log (actor_id, action, entity_type, entity_id, detail)
  values (
    auth.uid(),
    case tg_op when 'INSERT' then 'bundle_granted' else 'bundle_revoked' end,
    'profile',
    coalesce(new.student_id, old.student_id),
    jsonb_build_object('bundle', v_bundle_name, 'student', v_student_email)
  );
  return coalesce(new, old);
end;
$$;

create trigger audit_student_bundle_changes after insert or delete on public.student_bundles
  for each row execute function public.log_student_bundle_audit();
