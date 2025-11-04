---
allowed-tools: Bash(mkdir:*), Read(~/dotfiles/etc/mydd/*)
description: "spec-driven development"
---

spec-driven developmentを行います。

## spec-driven development とは

spec-driven development は、次の4つのフェーズからなる開発手法です。

各フェーズの終了には成果物と必ずユーザーの承認が必要です。

### 1. 要件フェーズ

このフェーズになったら ~/dotfiles/etc/mydd/requirements_creator.md の指示に従ってね

成果物：`./.mywork/changes/YYYY-MM-DD-BRIEF-DESC/requirements.md`

### 2. 設計フェーズ

このフェーズになったら ~/dotfiles/etc/mydd/design_creator.md の指示に従ってね

成果物：`./.mywork/changes/YYYY-MM-DD-BRIEF-DESC/design.md`

### 3. 実装計画フェーズ

このフェーズになったら ~/dotfiles/etc/mydd/tasks_creator.md の指示に従ってね

成果物：`./.mywork/changes/YYYY-MM-DD-BRIEF-DESC/tasks.md`

### 4. 実装フェーズ

このフェーズになったら ~/dotfiles/etc/mydd/tasks_executor.md の指示に従ってね

成果物：実装ファイル

全フェーズが終わったら、`./.mywork/changes/YYYY-MM-DD-BRIEF-DESC`から`./.mywork/specs/YYYY-MM-DD-BRIEF-DESC`にディレクトリを移動してね
