-- Supabase の SQL Editor に貼り付けて実行してください

create table public.posts (
  id uuid primary key default gen_random_uuid(),
  name text not null default '匿名' check (char_length(name) <= 20),
  category text not null check (category in ('雑談', '質問', 'お知らせ', '募集')),
  title text not null check (char_length(title) between 1 and 60),
  content text not null check (char_length(content) between 1 and 1000),
  created_at timestamptz not null default now()
);

create table public.replies (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  name text not null default '匿名' check (char_length(name) <= 20),
  body text not null check (char_length(body) between 1 and 500),
  created_at timestamptz not null default now()
);

alter table public.posts enable row level security;
alter table public.replies enable row level security;

-- 誰でも読める・書き込める。更新と削除は許可しない(Supabaseの管理画面からだけ可能)
create policy "posts read"    on public.posts   for select to anon using (true);
create policy "posts insert"  on public.posts   for insert to anon with check (true);
create policy "replies read"   on public.replies for select to anon using (true);
create policy "replies insert" on public.replies for insert to anon with check (true);
