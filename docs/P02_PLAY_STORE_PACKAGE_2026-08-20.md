# 一手箱 — Google Play Preparation Package

Status: **COPY/ASSET SPEC READY / CONSOLE NOT SUBMITTED**

## Listing

- App name: 一手箱
- Category candidate: Productivity
- Short description: 思いつきを預けて、明日の一手を一つ決めるローカル保存アプリ。
- Long description:

> 一手箱は、思いついたことをすばやく預け、必要なものだけ整理し、明日動くための「一手」へ変えるアプリです。総合タスク管理のためのサービスではありません。Drop、明日の一手、買う物、ひらめき整理、保存先を短い導線で行き来できます。データは基本的に端末内へ保存され、アカウント登録やクラウド同期はありません。端末変更や削除に備え、バックアップを書き出してください。

- Release notes: 初回ベータ。ローカル保存、明日の一手、買う物、ひらめき整理、バックアップ／復元を提供。
- Privacy URL: public URL pending approved deployment
- Support URL: public URL pending approved deployment
- Data Safety draft: accountなし、広告SDKなし、analytics SDKなし、位置情報・連絡先・カメラ・マイク権限なし。WebViewが外部HTTPSページを開く場合は端末ブラウザへ渡す。
- Content rating preparation: productivity utility; user-generated local text; no social sharing inside the app; no gambling/violence/sexual content supplied by the app.

## Graphic specifications

- App icon: existing 512×512 icon; final Play upload should be lossless PNG without transparent rounded-corner mask.
- Feature graphic: 1024×500, black background, gold accent, product name「一手箱」and line「思いつきを、明日の一手へ。」
- Phone screenshots: 1080×1920 recommended set—Drop、明日の一手、買う物、ひらめき整理、保存先／バックアップ。
- Screenshot rule: use real app UI; no fabricated ratings, testimonials, synchronization, reminders, or AI automation claims.

## Testing track

1. locally built unsigned AAB verification
2. signed internal-test AAB
3. Android device batch
4. closed test if Console policy requires it
5. production only after evidence and required identity/contract steps

Console identity, terms acceptance, production signing and any registration charge remain outside the repository.

