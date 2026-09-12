-- Explicit display order for bundles on the landing page's "Pick a path"
-- section and the signup bundle picker (both driven by useActiveBundles),
-- so the multi-track bundles (Frontend, Full Stack, Backend) always show
-- before the single-course bundles, instead of ordering by price.

alter table public.bundles
  add column if not exists order_index integer not null default 0;

update public.bundles set order_index = 0 where slug = 'frontend';
update public.bundles set order_index = 1 where slug = 'full-stack';
update public.bundles set order_index = 2 where slug = 'backend';
update public.bundles set order_index = 3 where slug = 'javascript';
update public.bundles set order_index = 4 where slug = 'python';
update public.bundles set order_index = 5 where slug = 'php';
