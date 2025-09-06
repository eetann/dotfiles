---
allowed-tools: Bash(mkdir:*)
description: "spec-driven development"
---

spec-driven developmentを行います。

## spec-driven development とは

spec-driven development は、次の4つのフェーズからなる開発手法です。各フェーズの終了には必ずユーザーの承認が必要です。

### 1. 要件フェーズ

このフェーズになったら sub-agent の requirements_creator を呼び出してね。

成果物：`./.claude/specs/YYYY-MM-DD-BRIEF-DESC/requirements.md`

### 2. 設計フェーズ

このフェーズになったら sub-agent の design_creator を呼び出してね。

成果物：`./.claude/specs/YYYY-MM-DD-BRIEF-DESC/design.md`

### 3. 実装計画フェーズ

このフェーズになったら sub-agent の tasks_creator を呼び出してね。

成果物：`./.claude/specs/YYYY-MM-DD-BRIEF-DESC/tasks.md`

### 4. 実装フェーズ

このフェーズになったら sub-agent の tasks_executor を呼び出してね。
