-- Forge Phase 8 — search, discovery, and home.
--
-- Track catalog needs to show a locked track's syllabus (lesson titles) so a
-- student can see what they'd get before enrolling, but lessons_gated_read
-- correctly hides the full lesson row (including title) for tracks they
-- can't access. Same narrow-RPC pattern as get_public_profiles: expose only
-- the metadata needed for a syllabus preview, never section content.

create or replace function public.get_catalog_lessons(p_track_ids uuid[])
returns table (id uuid, module_id uuid, title text, slug text, order_index int, is_free_preview boolean)
language sql
stable
security definer set search_path = public
as $$
  select l.id, l.module_id, l.title, l.slug, l.order_index, l.is_free_preview
  from public.lessons l
  join public.modules m on m.id = l.module_id
  where m.track_id = any(p_track_ids) and l.status = 'published'
  order by l.order_index;
$$;

grant execute on function public.get_catalog_lessons(uuid[]) to authenticated;
