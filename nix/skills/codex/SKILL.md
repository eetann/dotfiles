---
name: codex
description: |
  Codex CLI（OpenAI）を使用してコードや相談・レビューを行う。
  トリガー: "codex", "codexと相談", "codexに聞いて"
---

# Codex

Codex CLIを使用してコードレビュー・分析を実行するスキル。

## 実行コマンド

```sh
codex exec --sandbox read-only --skip-git-repo-check --cd <project_directory> "<request>" 2>/dev/null
```

## プロンプトのルール

**重要**: codexに渡すリクエストには、以下の指示を必ず含めること：

> 「確認や質問は不要です。具体的な提案・修正案・コード例まで自主的に出力してください。」

SpecDDの設計書などの場合、「ファイル内容をプロンプト化」するのではなく、ファイルパスを渡す

## パラメータ

| パラメータ | 説明 |
|-----------|------|
| `--cd <dir>` | 対象プロジェクトのディレクトリ |
| `"<request>"` | 依頼内容（日本語可） |

## 使用例

**注意**: 各例では末尾に「確認不要、具体的な提案まで出力」の指示を含めている。

### コードレビュー
```
codex exec --sandbox read-only --skip-git-repo-check --cd /path/to/project "このプロジェクトのコードをレビューして、改善点を指摘してください。確認や質問は不要です。具体的な修正案とコード例まで自主的に出力してください。" 2>/dev/null
```

### バグ調査
```
codex exec --sandbox read-only --skip-git-repo-check --cd /path/to/project "認証処理でエラーが発生する原因を調査してください。確認や質問は不要です。原因の特定と具体的な修正案まで自主的に出力してください。" 2>/dev/null
```

## 実行手順

1. ユーザーから依頼内容を受け取る
2. `CLAUDE_CONFIG_DIR=~/.claude_work`かどうか確認
    `.claude_work`の場合、`CODEX_HOME=~/.codex_work codex ...`のように`CODEX_HOME`もwork用のディレクトリを指定する
2. 対象プロジェクトのディレクトリを特定する（現在のワーキングディレクトリまたはユーザー指定）
3. **プロンプトを作成する際、末尾に「確認や質問は不要です。具体的な提案まで自主的に出力してください。」を必ず追加する**
4. 上記コマンド形式でCodexを実行
5. 結果をユーザーに報告
