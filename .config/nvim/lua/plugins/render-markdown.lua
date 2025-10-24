return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  cond = not vim.g.vscode,
  ft = {
    "markdown",
    "md",
    "mdwn",
    "mkd",
    "mkdn",
    "mark",
    "mdx",
    "Avante",
    "senpai_chat_log",
    "senpai_chat_input",
  },
  keys = {
    { "<Space>sm", ":RenderMarkdown toggle<CR>" },
  },
  ---@module "render-markdown"
  ---@type render.md.UserConfig
  ---
  opts = {
    render_modes = true,
    file_types = {
      "markdown",
      "Avante",
      "codecompanion",
      "senpai_chat_log",
      "senpai_chat_input",
    },
    heading = {
      width = "block",
      left_pad = 0,
      right_pad = 4,
      icons = {},
    },
    html = {
      comment = {
        conceal = false,
      },
    },
    code = {
      width = "block",
      border = "thick",
    },
    checkbox = {
      checked = { scope_highlight = "@markup.strikethrough" },
      custom = {
        -- デフォルトの`[-]`であるtodoは削除
        todo = { raw = "", rendered = "", highlight = "" },
        canceled = {
          raw = "[-]",
          rendered = "󱘹",
          scope_highlight = "@markup.strikethrough",
        },
      },
    },
  },
}
