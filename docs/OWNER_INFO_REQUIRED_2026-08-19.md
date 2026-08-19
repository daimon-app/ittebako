# P02 一手箱 — OWNER_INFO_REQUIRED

Date: 2026-08-19
Status: OWNER INPUT GATE

架空情報は禁止。以下だけが販売開始前の本人入力・本人承認対象。

## Required

1. **販売事業者名 / 代表責任者名**
2. **所在地**
3. **購入者向け問い合わせ窓口**
   - メールまたは問い合わせフォーム
   - 必要に応じて電話番号
4. **決済事業者 / 決済方法**
5. **提供時期 / 購入後の利用開始方法**
6. **返金・キャンセル条件**
   - 可否
   - 対象条件
   - 申請期限
   - 申請方法
   - 不具合時の扱い
7. **利用規約の販売主体・準拠法・管轄・変更通知方法**

## Already Decided

- Product: 一手箱
- Price: 500円（税込）買切り
- Initial sales method: Web販売 → PWA利用
- Main product promise: 思いつきを、明日の一手へ
- Data model explanation: browser localStorage中心 / 運営独自サーバーへメモ本文を保存しない設計
- Automatic cross-device sync: なし

## Do Not Put In GitHub

- パスワード
- API key
- 決済秘密鍵
- 管理画面ログイン情報
- 本人確認書類
- 非公開にすべき個人情報

公開が必要な販売者情報だけを、本人が販売開始を承認した段階で公開ページへ反映する。

## Approval Gate

上記Requiredが確定し、本人が内容を確認するまで以下は禁止:
- main merge
- 本番公開
- 販売開始
- 決済リンク有効化
- SNS公開投稿
- 広告出稿
