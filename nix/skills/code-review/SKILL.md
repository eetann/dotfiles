---
name: code-review
description: |
  コード品質の分析、バグ検出、ベストプラクティスの遵守確認を行うコードレビュー
  トリガー: code review, コードレビュー
user-invocable: true
allowed-tools:
  - Read
  - Task
---

# コードレビュースキル

派生元ブランチとの差分に対して、サブエージェントを使ったコードレビューを実行する。

## 実行手順

[reviewer.md](reviewer.md) を読み込み、Taskツール（subagent_type: general-purpose）でサブエージェントを起動する。

サブエージェントに渡すプロンプト：
- reviewer.mdの内容全文
- ユーザーの指示: `$ARGUMENTS`

## 引数の解釈

`$ARGUMENTS` は自由記述。以下の情報が含まれうる：

- **派生元ブランチ**: 明示されなければ `development` をデフォルトとする
- **要件定義書・設計書などのファイルパス**: 指定があればサブエージェントに渡してレビューの文脈として使わせる
- **その他の指示**: レビュー観点の絞り込みなど
