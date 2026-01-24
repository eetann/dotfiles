---
description: "PRの説明文作成"
allowed-tools: Bash(git diff:*), Bash(git log:*), Bash(mkdir:*), List
---

PR説明文を作成します：

```markdown
# PRのタイトル

## 概要
<!-- PRの背景・目的・概要 -->

## 関連タスク

- GitHub: 
- API: 
- ダッシュボード: 
- アプリ: 
- 翻訳対応: 

## 動作確認
<!-- アプリやダッシュボードでの動作確認手順を書く -->

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

上記のテンプレを参考に派生元ブランチとのdiffやコミット履歴を見て、Pull Requestの説明文を「ですます調」で `.mywork/tmp/pr.md` に出力してください。

派生元ブランチ: `$1`（**空白なら`development`ブランチ**。masterやmainはありえない）

引数として`.mywork/specs/xxx/yyy.md`のような`.mywork/specs/xxx/`のファイルが渡されたら、diffを見る前に`.mywork/specs/xxx/`内にあるMarkdownファイルを読み込んでください。タスクの目的などが書いてあり、事前に読めば理解しやすくなります。

---

## まず最初に必ずやること

```sh
rm .mywork/tmp/pr.md
```
これをやらないと「差分のレビュー」になってしまって見づらいため。
