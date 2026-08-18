# P02 一手箱 販売READY QA

確認日: 2026-08-18  
Branch: `product/p02-sales-ready`  
Writer: Codex  
Reviewer: Claude Code（差分限定レビューを2.1.233で試行、180秒タイムアウトのため結果取得不可）

## 施工内容

- 固定個人表示「鉄兵専用」を `DAIMON SERIES` へ汎用化
- 他アプリと衝突していた `hirameki_memos_v1` から商品専用 `daimon_ittebako_memos_v2` へ分離
- 旧データを削除せず、新領域への初回移行前に生JSONを `daimon_ittebako_migration_raw_v1` へ退避
- 旧ひらめき／現場メモのスキーマを販売版スキーマへ正規化
- 旧アプリ間で同一IDが存在しても両方を保持
- エクスポートへ商品ID・スキーマ版・出力日時を追加
- 新形式と旧「明日の一手」バックアップの双方をインポート可能に維持
- Service Workerキャッシュを `ittebako-v9` へ更新

## QA結果

| 検査 | 結果 |
|---|---|
| 空データ初期化 | PASS |
| 旧ひらめき箱データ移行 | PASS |
| 現行統合データ移行 | PASS |
| ひらめき＋現場メモ混在移行 | PASS |
| 壊れた旧JSONの非破壊退避 | PASS |
| 旧アプリ間ID衝突時の全件保持 | PASS |
| 旧キーの非削除 | PASS |
| ローカルChrome起動・商品名／汎用バッジ | PASS |
| ページ由来のブラウザエラー | PASS（0件。拡張機能由来の警告のみ） |
| `manifest.json` 構文 | PASS |
| HTMLローカル参照 | PASS（欠落0件） |
| `git diff --check` | PASS |
| 個人名・秘密情報文字列走査 | PASS（該当0件） |

## 判定

技術施工部分は `REVIEW`。Claudeの独立レビュー結果を取得できていないため、最終販売監査前の条件付き状態とする。本番公開・販売開始は未実施。
