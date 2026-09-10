-- Forge Phase 5 — assignments & submissions.

create type submission_type as enum ('code', 'file', 'link');
create type submission_status as enum ('submitted', 'in_review', 'graded');

-- ── Assignments ──────────────────────────────────────────────────────────
-- Attaches to a lesson OR a module (never neither, never both).

create table public.assignments (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid references public.lessons (id) on delete cascade,
  module_id uuid references public.modules (id) on delete cascade,
  title text not null,
  spec text not null,
  starter_code jsonb,
  starter_template text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint assignments_one_parent check (
    (lesson_id is not null and module_id is null) or
    (lesson_id is null and module_id is not null)
  )
);

create trigger set_updated_at before update on public.assignments
  for each row execute function public.set_updated_at();

alter table public.assignments enable row level security;

create policy "assignments_gated_read" on public.assignments
  for select using (
    public.is_instructor()
    or (lesson_id is not null and public.can_access_lesson(lesson_id))
    or (module_id is not null and exists (
      select 1 from public.modules m where m.id = module_id and public.can_access_track(m.track_id)
    ))
  );
create policy "assignments_instructor_write" on public.assignments
  for all using (public.is_instructor()) with check (public.is_instructor());

-- ── Submissions ──────────────────────────────────────────────────────────

create table public.submissions (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.assignments (id) on delete cascade,
  student_id uuid not null references public.profiles (id) on delete cascade,
  submission_type submission_type not null,
  code_content text,
  file_path text,
  link_url text,
  explanation text,
  status submission_status not null default 'submitted',
  score numeric,
  passed boolean,
  feedback text,
  submitted_at timestamptz not null default now(),
  graded_at timestamptz,
  graded_by uuid references public.profiles (id) on delete set null
);

alter table public.submissions enable row level security;

create policy "submissions_owner_read" on public.submissions
  for select using (student_id = auth.uid() or public.is_instructor());
create policy "submissions_owner_insert" on public.submissions
  for insert with check (student_id = auth.uid());
create policy "submissions_owner_update" on public.submissions
  for update using (student_id = auth.uid() and status = 'submitted')
  with check (student_id = auth.uid());
create policy "submissions_instructor_grade" on public.submissions
  for update using (public.is_instructor()) with check (public.is_instructor());

-- ── Storage bucket for file-upload submissions ──────────────────────────

insert into storage.buckets (id, name, public)
values ('submissions', 'submissions', false)
on conflict (id) do nothing;

create policy "submission_files_owner_write" on storage.objects
  for insert to authenticated
  with check (bucket_id = 'submissions' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "submission_files_owner_read" on storage.objects
  for select to authenticated
  using (
    bucket_id = 'submissions'
    and ((storage.foldername(name))[1] = auth.uid()::text or public.is_instructor())
  );
