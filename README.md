# 香川県高校説明会 2026 — そらのほしグループ

## 公開サイト
GitHub Pages で `index.html` を公開してください。

## Supabase接続
専用プロジェクト `kagawa-highschool-briefing` の URL と publishable key は `index.html` に設定済みです。ブラウザ用の公開キーのみ使用し、service_role / secret key はHTMLに置かないでください。

## 管理者設定（必須）
1. Supabase Dashboard の Authentication → Users で管理者アカウントを作成します。
2. 作成したユーザーの UUID をコピーします。
3. Supabase SQL Editor で次を実行し、UUIDを置き換えます。
   ```sql
   insert into public.survey_admins(user_id)
   values ('ADMIN_USER_UUID')
   on conflict do nothing;
   ```
4. 公開サイトの「主催者用管理画面」で、そのメールアドレスとパスワードを使ってログインします。

## データベース
`supabase_setup.sql` のテーブルと権限設定は、専用プロジェクトに適用済みです。別環境で再構築するときは Supabase SQL Editor で実行してください。

## 機能
- アンケート送信とSupabaseへの保存
- 回答者の立場・満足度・役立ち度・役立った内容の自動集計
- 管理者ログイン、回答一覧、CSV出力
- 回答の読み取りは管理者として登録したアカウントに限定

公開前にテスト回答・管理者ログイン・CSV出力を確認してください。