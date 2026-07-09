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
        target = "/codex:adversarial-review @.agents/skills/local-review/SKILL.md と次のタスクログに基づいて、このブランチをレビューして",
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
    },
    matching = "prefix",
    case_sensitive = false,
    keyword_length = 2,
  },
}
