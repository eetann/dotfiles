# Conventional Commit Helper

Conventional Commitsに基づいてgit commitしてください

## 実行内容

1. 現在の変更状況を整理
2. 適切なファイルをステージング
3. Conventional Commit形式のgitコミット

### コミットタイプ一覧：
- **feat** - 新機能の追加
- **fix** - バグ修正
- **docs** - ドキュメントのみの変更
- **style** - コードの動作に影響しない変更（空白、フォーマットなど）
- **refactor** - バグ修正でも機能追加でもないコード変更
- **test** - テストの追加や既存テストの修正
- **chore** - ビルドプロセスやツール、ライブラリに関する変更
- **build** - ビルドシステムや外部依存関係に影響する変更
- **ci** - CI設定ファイルやスクリプトの変更
- **perf** - パフォーマンス改善

### スコープ選択肢：
./codex/commit-scope.md があればそのファイルに書いてあります。ファイルがない場合はスコープ不要です。


### フォーマット：
```
<type>[scope]: <description>

[実際に行った作業の詳細]

Comment: [optional 作業に対する所感や補足情報]
```
descriptionは日本語で書いてください。

Breaking changeの場合は、タイプの後に"!"を付けるか、フッターに`BREAKING CHANGE:`を記載してください。

コミットに共著者フッターを追加しないでください。

```commit
feat: 電話キャンセルボタンを追加

packages/mobile/app/call.tsx にキャンセルボタンを実装。
それに伴って余白を微調整
```
