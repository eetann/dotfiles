---
name: opensrc
description: |
  調査用にパッケージなどのソースコードをプロジェクト直下のopensrcディレクトリにDL
---

単に型定義やインターフェースを見るだけでなく、**パッケージの内部動作を理解したいとき** に使います

### 追加のソースコードを取得する

理解したいパッケージやリポジトリのソースコードを取得するには、以下を実行します：

```bash
opensrc --modify=false <package>           # npm パッケージ（例: opensrc --modify=false zod）
opensrc --modify=false pypi:<package>      # Python パッケージ（例: opensrc --modify=false pypi:requests）
opensrc --modify=false crates:<package>    # Rust クレート（例: opensrc --modify=false crates:serde）
opensrc --modify=false <owner>/<repo>      # GitHub リポジトリ（例: opensrc --modify=false vercel/ai）
```
必ず`--modify=false`オプションを指定します。

すでにDL済みのパッケージとそのバージョン一覧は `opensrc/sources.json` を参照してください
