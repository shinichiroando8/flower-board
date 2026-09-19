-- メール認証を使うための追加設定。Supabase の SQL Editor で実行してください
-- (supabase.sql を実行したあとに、1回だけ実行します)

-- 投稿・返信に「書いた人」を記録する(ログインしていればサーバー側で自動入力)
alter table public.posts   add column if not exists user_id uuid references auth.users(id) on delete set null default auth.uid();
alter table public.replies add column if not exists user_id uuid references auth.users(id) on delete set null default auth.uid();

-- 書き込みはログイン済みの人だけ。読むのは今まで通り誰でも可
drop policy if exists "posts insert"   on public.posts;
drop policy if exists "replies insert" on public.replies;

create policy "posts insert"   on public.posts   for insert to authenticated with check (user_id = auth.uid());
create policy "replies insert" on public.replies for insert to authenticated with check (user_id = auth.uid());

-- 自分の投稿・返信だけ削除できる
create policy "posts delete own"   on public.posts   for delete to authenticated using (user_id = auth.uid());
create policy "replies delete own" on public.replies for delete to authenticated using (user_id = auth.uid());
