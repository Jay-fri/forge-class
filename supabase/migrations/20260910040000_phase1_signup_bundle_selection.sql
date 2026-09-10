-- Carry the bundle chosen at signup through as auth user metadata, so it's
-- applied at profile-creation time — this works whether or not email
-- confirmation is required (a session may not exist yet to run an UPDATE).

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  chosen_bundle_id uuid;
begin
  begin
    chosen_bundle_id := (new.raw_user_meta_data ->> 'assigned_bundle_id')::uuid;
  exception when others then
    chosen_bundle_id := null;
  end;

  if chosen_bundle_id is not null and not exists (
    select 1 from public.bundles where id = chosen_bundle_id and is_active
  ) then
    chosen_bundle_id := null;
  end if;

  insert into public.profiles (id, email, full_name, assigned_bundle_id)
  values (
    new.id,
    new.email,
    new.raw_user_meta_data ->> 'full_name',
    chosen_bundle_id
  );
  return new;
end;
$$;
