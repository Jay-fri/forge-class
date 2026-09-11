-- Frontend and Full Stack both include the JavaScript Fundamentals track
-- per forge-curriculum.md (Frontend's module 3 reuses it in full, Full
-- Stack is Frontend + Backend combined). Full Stack also needs direct
-- access to Frontend and Backend's own tracks, not just JS.

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id from public.bundles b, public.tracks t
where b.slug = 'frontend' and t.slug = 'javascript-fundamentals'
on conflict do nothing;

insert into public.bundle_tracks (bundle_id, track_id)
select b.id, t.id from public.bundles b, public.tracks t
where b.slug = 'full-stack' and t.slug in ('javascript-fundamentals', 'frontend', 'backend')
on conflict do nothing;
