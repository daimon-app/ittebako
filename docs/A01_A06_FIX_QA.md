# P02 A-01〜A-06 修正QA

確認日: 2026-08-18
基準commit: `7a8f6db`
Writer: Codex
Branch: `product/p02-sales-ready`

## 修正

- A-01: legacy `genba_memos_v1` backupを明示識別し、`tomorrow`として復元。
- A-02: migrationを単一経路へ収束。semantic fingerprintで同一recordを一度だけ保持し、異内容の同一IDは決定的suffixで併存。
- A-03: memo、mode、routine、onboarding、夜task/done/log/dateをP02 namespaceへ分離。旧keyは移行時だけ読み、raw退避後も削除しない。
- A-04: cache削除を `daimon-ittebako-` prefix内の旧versionだけへ限定。
- A-05: schema v3の全量backupへmemo、設定、夜module、安全移行data、product ID、createdAtを収録。validation後に復元前snapshotを保存し、失敗時rollback。
- A-06: app設定画面からprivacy、terms、販売者/特商法/返金、supportへ到達可能にした。架空情報を入れず、販売者固有情報は本人入力待ちとして販売blockを維持。

## 自動QA

localhost限定 `tests/qa.html` を実Chromeで実行し15/15 PASS。

| # | Case | 結果 |
|---|---|---|
| 1 | 新規user初回起動 | PASS |
| 2 | 現行data保存・再読込 | PASS |
| 3 | 旧単独data migration | PASS |
| 4 | 旧backup import | PASS |
| 5 | 同一ID混在 | PASS（2入力=2出力、ID一意） |
| 6 | 同一backup複数回 | PASS（1件のまま） |
| 7 | 不正JSON | PASS（拒否・既存data不変） |
| 8 | 未知schema version | PASS（拒否・既存data不変） |
| 9 | sibling Storage | PASS（保持） |
| 10 | auxiliary namespace | PASS（新keyへcopy、旧key保持） |
| 11 | 全量backup round-trip | PASS |
| 12 | runtime個人marker | PASS（0件） |
| 13 | 法務4導線 | PASS（HTTP 200） |
| 14 | SW cache境界 | PASS（`daimon-ittebako-v10` と `sibling-product-v1` を同時保持） |
| 15 | backup metadata | PASS（product ID、schema 3、createdAt） |

## その他

- manifest JSON: PASS
- HTML local reference: 欠落0
- `git diff --check`: PASS
- browser page error: 0（Chrome拡張由来warningを除外）
- offline shell: Service Worker `daimon-ittebako-v10` cache生成を確認
- mobile: 変更前のManus 390×844実査は横overflowなし。今回追加した設定内法務link 4件のDOM到達を確認
- main / Pages / 本番: 未変更
- A-07: 未変更

## 未確定本人情報

販売者名、所在地、電話/メール、価格、決済、提供時期、返金条件、問い合わせ窓口、規約の準拠事項は実販売方式の本人入力待ち。架空値は入れていない。これらが埋まるまで販売開始は不可だが、技術再監査は可能。
