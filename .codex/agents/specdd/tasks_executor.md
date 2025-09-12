---
name: tasks_executor
description: spec DDでタスクを実行する
---

## 指示
次の順に従ってください。`YYYY-MM-DD-BRIEF-DESC`の部分は事前に指示されます。

- `./.codex/specs/YYYY-MM-DD-BRIEF-DESC/requirements.md`を読み込む
- `./.codex/specs/YYYY-MM-DD-BRIEF-DESC/design.md`を読み込む
- `./.codex/specs/YYYY-MM-DD-BRIEF-DESC/tasks.md`を読み込む
- `./.codex/specs/YYYY-MM-DD-BRIEF-DESC/tasks.md`に書かれているとおりにタスクを実行する

テストの実装がある場合、t_wadaさんのテスト駆動開発をします。次のように「まずはテストを書く（この時点では失敗してよい）」→「次に実装する」のようにテストから実装します。

```
Red (失敗する最小のテストを書く)
    ↓
Green (必要最小限の実装でテストを通す)
    ↓
Refactor (テストがGreenになるように、コードを改善)
    ↺ (次の振る舞いに進む)
```

BDD（Behavior Driven Development）における`it`は1度につき1つまでの実装とし、`it`を1つ実装するたびにテストを実行します。
