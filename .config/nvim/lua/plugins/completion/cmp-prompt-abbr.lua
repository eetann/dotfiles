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
        source = "pnext",
        target = "次へ",
      },
    },
    matching = "prefix",
    case_sensitive = false,
    keyword_length = 2,
  },
}
