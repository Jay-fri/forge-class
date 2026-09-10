-- Forge Phase 7 — community / class group.
-- Per-lesson or per-track question threads, in-app. Complements (doesn't
-- replace) the WhatsApp group invite flow from Phase 1.

create table public.discussion_threads (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid references public.lessons (id) on delete cascade,
  track_id uuid references public.tracks (id) on delete cascade,
  author_id uuid not null references public.profiles (id) on delete cascade,
  title text not null,
  body text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint discussion_threads_one_parent check (
    (lesson_id is not null and track_id is null) or
    (lesson_id is null and track_id is not null)
  )
);

create trigger set_updated_at before update on public.discussion_threads
  for each row execute function public.set_updated_at();

create table public.discussion_replies (
  id uuid primary key default gen_random_uuid(),
  thread_id uuid not null references public.discussion_threads (id) on delete cascade,
  author_id uuid not null references public.profiles (id) on delete cascade,
  body text not null,
  created_at timestamptz not null default now()
);

-- A thread is visible to anyone who can access its lesson/track (same
-- gating as the content itself); instructors always see everything.
create or replace function public.can_access_thread(p_thread_id uuid)
returns boolean
language sql
stable
security definer set search_path = public
as $$
  select
    public.is_instructor()
    or exists (
      select 1 from public.discussion_threads t
      where t.id = p_thread_id
        and (
          (t.lesson_id is not null and public.can_access_lesson(t.lesson_id))
          or (t.track_id is not null and public.can_access_track(t.track_id))
        )
    );
$$;

alter table public.discussion_threads enable row level security;
alter table public.discussion_replies enable row level security;

create policy "discussion_threads_gated_read" on public.discussion_threads
  for select using (
    public.is_instructor()
    or (lesson_id is not null and public.can_access_lesson(lesson_id))
    or (track_id is not null and public.can_access_track(track_id))
  );
create policy "discussion_threads_authenticated_insert" on public.discussion_threads
  for insert with check (
    author_id = auth.uid()
    and (
      public.is_instructor()
      or (lesson_id is not null and public.can_access_lesson(lesson_id))
      or (track_id is not null and public.can_access_track(track_id))
    )
  );
create policy "discussion_threads_owner_or_instructor_write" on public.discussion_threads
  for update using (author_id = auth.uid() or public.is_instructor());
create policy "discussion_threads_owner_or_instructor_delete" on public.discussion_threads
  for delete using (author_id = auth.uid() or public.is_instructor());

create policy "discussion_replies_gated_read" on public.discussion_replies
  for select using (public.can_access_thread(thread_id));
create policy "discussion_replies_gated_insert" on public.discussion_replies
  for insert with check (author_id = auth.uid() and public.can_access_thread(thread_id));
create policy "discussion_replies_owner_or_instructor_delete" on public.discussion_replies
  for delete using (author_id = auth.uid() or public.is_instructor());
