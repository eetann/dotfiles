---@module "lazy"
---@type LazyPluginSpec
return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanion",
    "CodeCompanionActions",
    "CodeCompanionChat",
    "CodeCompanionCmd",
    "CodeCompanionLoad",
  },
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { import = "plugins.copilot" },
  },
  keys = {
    { "<Space>cc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "n" } },
    { "<Space>cc", "<Cmd>CodeCompanionChat<CR>", mode = { "v" } },
    { "<Space>ca", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "x" } },
    { "<Space>cA", "<Cmd>CodeCompanionChat Add<CR>", mode = { "x" } },
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccc CodeCompanionChat]])
    -- vim.g.codecompanion_auto_tool_mode = true
  end,
  config = function()
    local my_adapter = "copilot"
    if vim.env.OPENROUTER_API_KEY then
      my_adapter = "openrouter_claude"
    elseif vim.env.OPENAI_API_KEY then
      my_adapter = "openai"
    end
    require("codecompanion").setup({
      opts = {
        language = "Japanese",
      },
      adapters = {
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = { api_key = vim.env.OPENAI_API_KEY },
          })
        end,
        openrouter_claude = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = vim.env.OPENROUTER_API_KEY,
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "anthropic/claude-3.7-sonnet",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = my_adapter,
          keymaps = {
            send = {
              modes = {
                n = { "<CR><CR>" },
              },
            },
          },
          slash_commands = {
            ["buffer"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["file"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["help"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["symbols"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["workspace"] = {
              opts = {
                provider = "snacks",
              },
            },
          },
        },
        inline = {
          adapter = my_adapter,
        },
        agent = {
          adapter = my_adapter,
        },
      },
      prompt_library = {
        ["Add memo tag"] = require("plugins.codecompanion.prompt.memo-tag"),
        ["Blog composition"] = require(
          "plugins.codecompanion.prompt.blog-composition"
        ),
        ["Generate English Commit Message"] = require(
          "plugins.codecompanion.prompt.commit-message-english"
        ),
        ["Generate Japanese Commit Message"] = require(
          "plugins.codecompanion.prompt.commit-message-japanese"
        ),
      },
      display = {
        chat = {
          show_header_separator = true,
        },
      },
    })
    require("plugins.codecompanion.history")
    vim.api.nvim_create_autocmd({ "FileType" }, {
      group = "my_nvim_rc",
      pattern = "codecompanion",
      callback = function()
        vim.keymap.set(
          "n",
          "qq",
          "<Cmd>quit<CR>",
          { buffer = true, silent = true }
        )
      end,
    })
  end,
}
