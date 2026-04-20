---
name: opensrc
description: |
  調査用にパッケージなどのソースコードをグローバルキャッシュ（~/.opensrc/）へDLして参照する
---

単に型定義やインターフェースを見るだけでなく、**パッケージの内部動作を理解したいとき** に使います

### ソースコードのパスを取得する

理解したいパッケージやリポジトリのソースコードのパスを取得するには、以下を実行します：

```bash
opensrc path <package>           # npm パッケージ（例: opensrc path zod）
opensrc path pypi:<package>      # Python パッケージ（例: opensrc path pypi:requests）
opensrc path crates:<package>    # Rust クレート（例: opensrc path crates:serde）
opensrc path <owner>/<repo>      # GitHub リポジトリ（例: opensrc path vercel/ai）
```

未取得の場合は自動で fetch され、以降はキャッシュされたパスが即座に返ります。進捗は stderr、パスは stdout に出るので、subshell で組み合わせて使えます：

```bash
rg "parse" $(opensrc path zod)
cat $(opensrc path zod)/src/types.ts
```

バージョン指定や複数取得もできます：

```bash
opensrc path zod@3.22.0
opensrc path <owner>/<repo>@v1.0.0
opensrc path zod react next
```

### キャッシュの確認

DL済みのパッケージ一覧は以下で確認できます：

```bash
opensrc list           # 人間が読める形式
opensrc list --json    # JSON 出力
```

キャッシュは `~/.opensrc/` に保存されます
