-- Students can't read other students'/instructors' profile rows (by
-- design — profiles RLS is "own row or instructor"), which meant every
-- discussion reply showed as "Someone" with no instructor badge. Postgres
-- RLS can't restrict by column, only by row, so the fix is a narrow
-- security-definer function that exposes only the safe fields (name, role)
-- needed to attribute a post — never email or approval/bundle data.

create or replace function public.get_public_profiles(p_ids uuid[])
returns table (id uuid, full_name text, role user_role)
language sql
stable
security definer set search_path = public
as $$
  select p.id, p.full_name, p.role from public.profiles p where p.id = any(p_ids);
$$;

grant execute on function public.get_public_profiles(uuid[]) to authenticated;
