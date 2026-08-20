# P02 A-01〜A-06 Decision Log

## 2026-08-18

1. Memo IDはidentityだけに使わない。semantic fingerprintが同じrecordは1回、内容が異なる同一IDはsuffix採番して両方保持する。
2. `genba_memos_v1` migrationはtop-levelの1経路だけで実行し、旧 `migrateItte()` は撤去する。
3. 旧keyは削除しない。商品keyが空の場合だけcopyし、auxiliary raw snapshotとmigration stateを残す。
4. Backup schemaはv3のみをcurrentとして受理する。異productと未知versionは書込前に拒否する。legacyとして受理するのは識別可能な旧 `genba_memos_v1` string形式だけ。
5. Importは全validation後に商品Storage全体をsnapshotし、書込失敗時はrollbackする。別product Storageへ触れない。
6. SWは `daimon-ittebako-` prefix cacheだけを所有し、他prefixを削除しない。
7. A-06の本人固有値は生成しない。到達可能なdraftを作成し、未確定値を販売blockとして明記する。
8. A-07はscope外。Android/AAB/Play設定を変更しない。
9. A-05再監査指摘により、schema v3の`createdAt`はexportと同一のUTCミリ秒付きISO形式だけを受理する。`Date.parse()`単独は使用せず、形式と暦上の日時を完全一致検証する。legacy backupにはこの要件を遡及しない。

## 2026-08-20 — P0: imported/migrated memo idのattribute breakout

10. 監査指摘: import/migration経由のmemo `id`が無検証のまま複数render箇所の`onclick="...('${m.id}')"`へ直接展開されており、悪意あるbackup JSONやlegacy localStorage値でattribute breakout／JS注入が可能だった（`itteLoadMemos`/`loadMemos`を経由する全render箇所が対象）。
11. 修正はid正規化の単一箇所（`normalizeMemo`）に集約した。全load/import/migration経路（`loadMemos`・`saveMemos`・`validateBackupPayload`・`migrateLegacyStorage`）は例外なくここを通るため、render側の個別修正は不要。
12. 新設`sanitizeId()`は`[A-Za-z0-9_.:-]`以外を除去する許可制charsetで、既存id（`Date.now().toString()`由来の数字のみ）とは完全互換。`memo.id`が空／全除去でid不成立の場合は`legacyId`（同じ許可charsetで生成、`createdAt`が不正な場合はさらに`Date.now()`へfallback）を用いる。
13. sanitize後にidが衝突しても既存の`mergeMemosExactlyOnce`が決定的suffixで両方保持するため、dedupe/idempotencyの挙動は変更していない。
14. 回帰テストを`tests/id-sanitize-qa.html`として追加（quote・angle bracket・script様id、importとmigration双方の経路、renderされたonclick属性の安全性、sanitize後衝突時のdedupe、決定性を検証）。localhost限定の実browser実行で12/12 PASS。既存`tests/qa.html`（15/15 PASS）・`tests/createdat-qa.html`（10/10 PASS）に回帰なし。
