---
name: specdd
description: |
  spec-driven developmentを行う。要件→設計→実装計画→実装の4フェーズで開発を進める。
  トリガー: "specdd", "spec-driven", "スペック駆動"
allowed-tools: Bash(mkdir:*), Read
---

spec-driven developmentを行います。

## spec-driven development とは

spec-driven development は、次の4つのフェーズからなる開発手法です。

各フェーズの終了には成果物と必ずユーザーの承認が必要です。

### 1. 要件フェーズ

このフェーズになったら [requirements_creator.md](requirements_creator.md) の指示に従ってね

成果物：`./.mywork/changes/YYYY-MM-DD-BRIEF-DESC/requirements.md`

### 2. 設計フェーズ

このフェーズになったら [design_creator.md](design_creator.md) の指示に従ってね

成果物：`./.mywork/changes/YYYY-MM-DD-BRIEF-DESC/design.md`

### 3. 実装計画フェーズ

このフェーズになったら [tasks_creator.md](tasks_creator.md) の指示に従ってね

成果物：`./.mywork/changes/YYYY-MM-DD-BRIEF-DESC/tasks.md`

### 4. 実装フェーズ

このフェーズになったら [tasks_executor.md](tasks_executor.md) の指示に従ってね

成果物：実装ファイル

全フェーズが終わったら、`./.mywork/changes/YYYY-MM-DD-BRIEF-DESC`から`./.mywork/specs/YYYY-MM-DD-BRIEF-DESC`にディレクトリを移動してね
