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
