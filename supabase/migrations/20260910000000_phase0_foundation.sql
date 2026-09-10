-- Forge Phase 0 — foundation schema
-- users(role+approval+bundle), bundles, cohorts (+ membership), tracks, lessons,
-- sections, user_progress, streaks.

create extension if not exists "pgcrypto";

-- ── Enums ──────────────────────────────────────────────────────────────────

create type user_role as enum ('student', 'instructor');
create type approval_status as enum ('pending', 'approved', 'rejected');
create type content_drop_mode as enum ('weekly', 'all_at_once');
create type cohort_status as enum ('upcoming', 'active', 'completed');
create type late_join_decision as enum ('waitlist', 'allow', 'allow_with_fee');
create type track_level as enum ('beginner', 'intermediate', 'advanced');
create type progress_status as enum ('not_started', 'in_progress', 'completed');

-- ── updated_at helper ────────────────────────────────────────────────────

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ── Bundles ──────────────────────────────────────────────────────────────
-- Frontend / Backend / Full Stack / Python / JavaScript / PHP. Price is
-- editable anytime by the instructor from the admin dashboard.

create table public.bundles (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  description text,
  price numeric(10, 2) not null default 0,
  currency text not null default 'NGN',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_updated_at before update on public.bundles
  for each row execute function public.set_updated_at();

-- ── Profiles ─────────────────────────────────────────────────────────────
-- Extends auth.users with role, approval status, and assigned bundle.
-- Row is created automatically on signup via the trigger below.

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null,
  full_name text,
  role user_role not null default 'student',
  approval_status approval_status not null default 'pending',
  assigned_bundle_id uuid references public.bundles (id) on delete set null,
  whatsapp_group_invited_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_updated_at before update on public.profiles
  for each row execute function public.set_updated_at();

-- Only an instructor may change role / approval_status / assigned_bundle_id —
-- approval is a manual, instructor-only action (see Phase 1 access model).
create or replace function public.protect_privileged_profile_fields()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if (new.role is distinct from old.role
      or new.approval_status is distinct from old.approval_status
      or new.assigned_bundle_id is distinct from old.assigned_bundle_id)
     and not exists (
       select 1 from public.profiles where id = auth.uid() and role = 'instructor'
     )
  then
    raise exception 'Only an instructor can change role, approval_status, or assigned_bundle_id';
  end if;
  return new;
end;
$$;

create trigger protect_privileged_profile_fields
  before update on public.profiles
  for each row execute function public.protect_privileged_profile_fields();

-- Auto-create a profile row when a new auth user signs up.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data ->> 'full_name');
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Instructor check used throughout RLS policies below.
create or replace function public.is_instructor()
returns boolean
language sql
stable
security definer set search_path = public
as $$
  select exists (
    select 1 from public.profiles where id = auth.uid() and role = 'instructor'
  );
$$;

-- ── Cohorts ──────────────────────────────────────────────────────────────
-- A cohort belongs to one bundle; weekly-drip vs all-at-once is set per cohort.

create table public.cohorts (
  id uuid primary key default gen_random_uuid(),
  bundle_id uuid not null references public.bundles (id) on delete cascade,
  name text not null,
  start_date date not null,
  end_date date not null,
  content_drop_mode content_drop_mode not null default 'weekly',
  status cohort_status not null default 'upcoming',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_updated_at before update on public.cohorts
  for each row execute function public.set_updated_at();

-- A student belongs to (at most) one cohort per bundle. Late-join decisions
-- (waitlist / allow / allow with fee) are recorded per student.
create table public.cohort_memberships (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references public.profiles (id) on delete cascade,
  cohort_id uuid not null references public.cohorts (id) on delete cascade,
  bundle_id uuid not null references public.bundles (id) on delete cascade,
  is_late_join boolean not null default false,
  late_join_decision late_join_decision,
  late_fee numeric(10, 2),
  joined_at timestamptz not null default now(),
  unique (student_id, bundle_id)
);

-- ── Curriculum: Track → Lesson → Section ────────────────────────────────
-- (Module level is introduced in Phase 2.)

create table public.tracks (
  id uuid primary key default gen_random_uuid(),
  bundle_id uuid references public.bundles (id) on delete set null,
  name text not null,
  slug text not null unique,
  level track_level not null default 'beginner',
  description text,
  order_index int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_updated_at before update on public.tracks
  for each row execute function public.set_updated_at();

create table public.lessons (
  id uuid primary key default gen_random_uuid(),
  track_id uuid not null references public.tracks (id) on delete cascade,
  title text not null,
  slug text not null,
  order_index int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (track_id, slug)
);

create trigger set_updated_at before update on public.lessons
  for each row execute function public.set_updated_at();

create table public.sections (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons (id) on delete cascade,
  title text,
  content text,
  order_index int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_updated_at before update on public.sections
  for each row execute function public.set_updated_at();

-- ── Progress & streaks ───────────────────────────────────────────────────

create table public.user_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  section_id uuid not null references public.sections (id) on delete cascade,
  status progress_status not null default 'not_started',
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, section_id)
);

create trigger set_updated_at before update on public.user_progress
  for each row execute function public.set_updated_at();

create table public.streaks (
  user_id uuid primary key references public.profiles (id) on delete cascade,
  current_streak int not null default 0,
  longest_streak int not null default 0,
  last_active_date date,
  updated_at timestamptz not null default now()
);

create trigger set_updated_at before update on public.streaks
  for each row execute function public.set_updated_at();

-- ── Row Level Security ───────────────────────────────────────────────────

alter table public.bundles enable row level security;
alter table public.profiles enable row level security;
alter table public.cohorts enable row level security;
alter table public.cohort_memberships enable row level security;
alter table public.tracks enable row level security;
alter table public.lessons enable row level security;
alter table public.sections enable row level security;
alter table public.user_progress enable row level security;
alter table public.streaks enable row level security;

-- Bundles: publicly readable (active ones) so the landing page can show
-- pricing to signed-out visitors; only instructors manage them.
create policy "bundles_public_read" on public.bundles
  for select using (is_active or public.is_instructor());
create policy "bundles_instructor_write" on public.bundles
  for all using (public.is_instructor()) with check (public.is_instructor());

-- Profiles: a user reads/updates their own row; instructors see/manage all.
-- (Privileged-field protection is enforced by the trigger above, not RLS.)
create policy "profiles_self_read" on public.profiles
  for select using (id = auth.uid() or public.is_instructor());
create policy "profiles_self_update" on public.profiles
  for update using (id = auth.uid() or public.is_instructor());

-- Cohorts / curriculum: readable by any authenticated user for now; content-
-- level gating by bundle/cohort access arrives with Phase 1–2. Writes are
-- instructor-only.
create policy "cohorts_authenticated_read" on public.cohorts
  for select using (auth.role() = 'authenticated');
create policy "cohorts_instructor_write" on public.cohorts
  for all using (public.is_instructor()) with check (public.is_instructor());

create policy "cohort_memberships_self_read" on public.cohort_memberships
  for select using (student_id = auth.uid() or public.is_instructor());
create policy "cohort_memberships_instructor_write" on public.cohort_memberships
  for all using (public.is_instructor()) with check (public.is_instructor());

create policy "tracks_authenticated_read" on public.tracks
  for select using (auth.role() = 'authenticated');
create policy "tracks_instructor_write" on public.tracks
  for all using (public.is_instructor()) with check (public.is_instructor());

create policy "lessons_authenticated_read" on public.lessons
  for select using (auth.role() = 'authenticated');
create policy "lessons_instructor_write" on public.lessons
  for all using (public.is_instructor()) with check (public.is_instructor());

create policy "sections_authenticated_read" on public.sections
  for select using (auth.role() = 'authenticated');
create policy "sections_instructor_write" on public.sections
  for all using (public.is_instructor()) with check (public.is_instructor());

-- Progress & streaks: a student only ever touches their own rows;
-- instructors can read all (for the grading/analytics dashboard).
create policy "user_progress_owner_read" on public.user_progress
  for select using (user_id = auth.uid() or public.is_instructor());
create policy "user_progress_owner_write" on public.user_progress
  for insert with check (user_id = auth.uid());
create policy "user_progress_owner_update" on public.user_progress
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

create policy "streaks_owner_read" on public.streaks
  for select using (user_id = auth.uid() or public.is_instructor());
create policy "streaks_owner_write" on public.streaks
  for insert with check (user_id = auth.uid());
create policy "streaks_owner_update" on public.streaks
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());
