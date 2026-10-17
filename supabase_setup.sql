-- 香川県高校説明会アンケートの保存・権限設定
create table if not exists public.survey_responses (
 id bigint generated always as identity primary key,
 created_at timestamptz not null default now(),
 role text not null check(role in ('中学生','保護者','その他')),
 satisfaction text not null check(satisfaction in ('とても満足','満足','ふつう','やや不満','不満')),
 useful text not null check(useful in ('とても役立った','役立った','どちらともいえない','あまり役立たなかった')),
 helpful text[] not null default '{}',
 comments text not null default '' check(char_length(comments)<=3000)
);
create table if not exists public.survey_admins(user_id uuid primary key references auth.users(id) on delete cascade,created_at timestamptz not null default now());
alter table public.survey_responses enable row level security;
alter table public.survey_admins enable row level security;
drop policy if exists "Anyone can submit survey" on public.survey_responses;
create policy "Anyone can submit survey" on public.survey_responses for insert to anon,authenticated with check(role in ('中学生','保護者','その他') and satisfaction in ('とても満足','満足','ふつう','やや不満','不満') and useful in ('とても役立った','役立った','どちらともいえない','あまり役立たなかった') and coalesce(array_length(helpful,1),0)<=20 and char_length(coalesce(comments,''))<=3000);
create or replace function public.is_survey_admin() returns boolean language sql stable security definer set search_path='' as $$ select exists(select 1 from public.survey_admins a where a.user_id=(select auth.uid())); $$;
drop policy if exists "Admins can read survey responses" on public.survey_responses;
create policy "Admins can read survey responses" on public.survey_responses for select to authenticated using(public.is_survey_admin());
revoke all on public.survey_admins from anon,authenticated;
revoke all on function public.is_survey_admin() from public;
revoke execute on function public.is_survey_admin() from anon;
grant execute on function public.is_survey_admin() to authenticated;
revoke all on public.survey_responses from anon,authenticated;
grant insert on public.survey_responses to anon,authenticated;
grant select on public.survey_responses to authenticated;
grant usage,select on sequence public.survey_responses_id_seq to anon,authenticated;