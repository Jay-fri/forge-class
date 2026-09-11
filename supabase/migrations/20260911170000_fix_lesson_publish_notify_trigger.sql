-- notify_lesson_published() still referenced the dropped
-- profiles.assigned_bundle_id column from before the multi-bundle
-- migration (20260911090000), breaking every publish of a lesson whose
-- module belongs to a bundle-gated track. Same class of bug as the
-- log_profile_audit() fix (20260911100000) — rewritten to check
-- student_bundles instead of the single dropped column.

create or replace function public.notify_lesson_published()
returns trigger
language plpgsql
security definer
set search_path to 'public'
as $function$
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
          join public.student_bundles sb on sb.bundle_id = bt.bundle_id
          where bt.track_id = v_track_id and sb.student_id = p.id
        )
      );
  end if;
  return new;
end;
$function$;
