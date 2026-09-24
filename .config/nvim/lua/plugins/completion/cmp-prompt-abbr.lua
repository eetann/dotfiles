---@module "lazy"
---@type LazyPluginSpec
return {
  "yuki-yano/cmp-prompt-abbr",
  cond = vim.env.EDITPROMPT == "1",
  opts = {
    mappings = {
      {
        source = "pcommit_staging",
        target = "/commit ステージングのやつをコミットして",
      },
      {
        source = "pcommit_staging_en",
        target = "/commit ステージングのやつを英語でコミットして",
      },
      {
        source = "pn",
        target = "次へ",
      },
      {
        source = "pcodex",
        target = "Codexにレビューしてもらおう",
      },
      {
        source = "pcodex:local-review",
        target = [[
Codexプラグインのコマンド結果が返ってきたら、そのままの形式ではなく読みやすくして解説+推奨案の提案をしてほしい

/codex:adversarial-review --background @.agents/skills/local-review/SKILL.md と次のタスクログに基づいて、このブランチをレビューして
@]],
      },
      {
        source = "ppen",
        target = "Pencil MCPを使って",
      },
      {
        source = "pask",
        target = "適宜AskUserQuestionを使ってね",
      },
      {
        source = "presult",
        target = "結果が返ってきたら、そのままの形式ではなく読みやすくして解説してほしい",
      },
      {
        source = "pnotmain",
        target = "メインツリーを見る必要は無いのでは？",
      },
      {
        source = "eli5",
        target = [[
eli5 で解説してほしい。
具体的にはローカルの .mywork/work-logs/ にHTMLで解説を書いてほしい。
Claude Codeのアーティファクト機能でクラウドにアップロードはやらなくてOK。あくまでローカルでのみ。
また、既存のwork-logのフォーマットとかは無視してOK。
        ]],
      },
    },
    matching = "prefix",
    case_sensitive = false,
    keyword_length = 2,
  },
}
