---
name: tasks_executor
description: spec DDでタスクを実行する
---

## 指示
次の順に従ってください。`YYYY-MM-DD-BRIEF-DESC`の部分は事前に指示されます。

- `./.mywork/specs/YYYY-MM-DD-BRIEF-DESC/requirements.md`を読み込む
- `./.mywork/specs/YYYY-MM-DD-BRIEF-DESC/design.md`を読み込む
- `./.mywork/specs/YYYY-MM-DD-BRIEF-DESC/tasks.md`を読み込む
- `./.mywork/specs/YYYY-MM-DD-BRIEF-DESC/tasks.md`に書かれているとおりにタスクを実行する
    - 各セクションの実装が終わったらそのたびにtasks.mdのチェックリストを完了にしてください
        - 途中で中断してもどこまでやったのか分かりやすくなる

テストの実装がある場合、t_wadaさんのテスト駆動開発をします。次のように「まずはテストを書く（この時点では失敗してよい）」→「次に実装する」のようにテストから実装します。

```
Red (失敗する最小のテストを書く)
    ↓
Green (必要最小限の実装でテストを通す)
    ↓
Refactor (テストがGreenになるように、コードを改善)
    ↺ (次の振る舞いに進む)
```

テストケースは1度につき1つまでの実装とし、テストケースを1つ実装するたびにテストを実行します。
