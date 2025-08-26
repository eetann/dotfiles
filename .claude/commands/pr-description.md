---
description: "PRの説明文作成"
allowed-tools: ["Bash(git:diff)","Bash(git:log)","Bash(mkdir:*)"]
---

```markdown
## 概要
<!-- PRの背景・目的・概要 -->

## 関連タスク

<!-- 他のリポジトリでも変更があるか確認し、あれば次のようにTODOを書いておく -->
**TODO: API側のPRを貼る**
<!-- csv更新など「手動の変更」があるか確認し、あれば次のようにTODOを書いておく -->
- 翻訳csvも更新する


## やったこと
<!-- このPRで何をしたのか？ -->

### 変更対象ファイル
<!-- リストで書く -->

- `foo/bar/buz.ts`

### 変更の詳細
<!-- 変更が多い場合は書く -->

## やらないこと
<!-- 別タスクでやりますとかが明示的になっていればその旨を書く -->
```

上記のテンプレを参考にPull Requestの説明文を `.claude/tmp/pr.md` に出力してください。

引数として`.claude/specs/xxx/yyy.md`のような`.claude/specs/xxx/`のファイルが渡されたら、diffを見る前に`.claude/specs/xxx/`内にあるMarkdownファイルを読み込んでください。タスクの目的などが書いてあり、事前に読めば理解しやすくなります。
