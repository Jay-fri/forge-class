-- Forge Phase 3 — lesson experience.
-- Sandpack starter code on sections, embedded quiz checks, per-section
-- "confusing/typo" feedback, and daily Ask AI usage tracking.

-- ── Sandpack starter code (optional, per section) ───────────────────────

alter table public.sections add column sandbox_template text;
alter table public.sections add column sandbox_files jsonb;

-- ── Embedded quiz checks ─────────────────────────────────────────────────

create table public.section_quizzes (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.sections (id) on delete cascade,
  question text not null,
  options jsonb not null,
  correct_index int not null,
  explanation text,
  order_index int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_updated_at before update on public.section_quizzes
  for each row execute function public.set_updated_at();

alter table public.section_quizzes enable row level security;

create policy "section_quizzes_gated_read" on public.section_quizzes
  for select using (
    exists (
      select 1 from public.sections s
      where s.id = section_id and public.can_access_lesson(s.lesson_id)
    )
  );
create policy "section_quizzes_instructor_write" on public.section_quizzes
  for all using (public.is_instructor()) with check (public.is_instructor());

-- ── Content feedback ("this was confusing" / "found a typo") ────────────

create type content_feedback_type as enum ('confusing', 'typo');
create type content_feedback_status as enum ('open', 'resolved');

create table public.content_feedback (
  id uuid primary key default gen_random_uuid(),
  section_id uuid not null references public.sections (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  feedback_type content_feedback_type not null,
  note text,
  status content_feedback_status not null default 'open',
  created_at timestamptz not null default now()
);

alter table public.content_feedback enable row level security;

create policy "content_feedback_owner_insert" on public.content_feedback
  for insert with check (user_id = auth.uid());
create policy "content_feedback_read" on public.content_feedback
  for select using (user_id = auth.uid() or public.is_instructor());
create policy "content_feedback_instructor_update" on public.content_feedback
  for update using (public.is_instructor()) with check (public.is_instructor());

-- ── Ask AI daily usage cap ───────────────────────────────────────────────

create table public.ai_usage (
  user_id uuid not null references public.profiles (id) on delete cascade,
  usage_date date not null default current_date,
  count int not null default 0,
  primary key (user_id, usage_date)
);

alter table public.ai_usage enable row level security;

create policy "ai_usage_owner_read" on public.ai_usage
  for select using (user_id = auth.uid() or public.is_instructor());
