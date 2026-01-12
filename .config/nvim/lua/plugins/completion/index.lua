---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    "saghen/blink.compat",
    -- use v2.* for blink.cmp v1.*
    version = "2.*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdLineEnter" },
    cond = not vim.g.vscode,
    dependencies = {
      { import = "plugins.completion.luasnip" },
      "disrupted/blink-cmp-conventional-commits",
      "Kaiser-Yang/blink-cmp-dictionary",
      { import = "plugins.completion.cmp-prompt-abbr" },
      -- { import = "plugins.completion.minuet-ai" },
      -- { import = "plugins.copilot" },
    },
    -- use a release tag to download pre-built binaries
    version = "*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = require("plugins.completion.mappings"),
      cmdline = {
        keymap = {
          preset = "super-tab",
          ["<CR>"] = {
            -- 検索時には<CR>での補完を確定させない
            function(cmp)
              if not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype()) then
                return cmp.accept_and_enter()
              end
              return false
            end,
            "fallback",
          },
        },
        completion = {
          ghost_text = { enabled = false },
          menu = {
            auto_show = true,
          },
        },
      },

      snippets = { preset = "luasnip" },
      sources = require("plugins.completion.sources"),

      -- 見た目
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = { border = "double" },
        },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= "cmdline"
              or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
        },
        ghost_text = { enabled = false },
        list = {
          selection = {
            auto_insert = false,
          },
        },
      },
      signature = { window = { border = "single" } },
    },
    opts_extend = { "sources.default" },
  },
}
