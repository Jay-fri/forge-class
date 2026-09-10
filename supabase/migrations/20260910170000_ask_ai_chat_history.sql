-- Ask AI chat persistence: saved chats the student can revisit, plus
-- bounded conversation memory (the edge function only resends the last
-- few turns, not the whole history, to keep follow-up cost from growing
-- unbounded — see supabase/functions/ask-ai/index.ts).

create table public.ai_chats (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles (id) on delete cascade,
  title text not null default 'New chat',
  lesson_id uuid references public.lessons (id) on delete set null,
  section_id uuid references public.sections (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger set_updated_at before update on public.ai_chats
  for each row execute function public.set_updated_at();

alter table public.ai_chats enable row level security;
create policy "ai_chats_owner_all" on public.ai_chats
  for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create table public.ai_messages (
  id uuid primary key default gen_random_uuid(),
  chat_id uuid not null references public.ai_chats (id) on delete cascade,
  role text not null check (role in ('user', 'assistant')),
  content text not null,
  created_at timestamptz not null default now()
);

alter table public.ai_messages enable row level security;
create policy "ai_messages_owner_read" on public.ai_messages
  for select using (
    exists (select 1 from public.ai_chats c where c.id = chat_id and c.user_id = auth.uid())
  );
-- Inserts happen server-side (edge function, service role) — no insert
-- policy needed for the client.
