---@module "lazy"
---@type LazyPluginSpec
return {
  -- "yuki-yano/cmp-coding-agent",
  dir = "~/ghq/github.com/yuki-yano/cmp-coding-agent",
  cond = vim.env.EDITPROMPT == "1",
  opts = {
    agent = "both",
    max_items = 200,
    paths = {
      preserve_at_prefix = true,
      show_hidden = true,
      preview_lines = 20,
      deep_search = false,
      root = "git",
    },
    skills = {
      include = {
        repo_agents = true,
        repo_claude = true,
        repo_codex = true,
        user_agents = true,
        user_claude = true,
        user_codex = true,
      },
      include_non_user_invocable = false,
    },
    commands = {
      include_builtins = {
        claude = true,
        codex = true,
      },
      extra = {
        claude = {},
        codex = {},
      },
      disabled = {
        claude = {},
        codex = {},
      },
    },
    prompts = {
      codex = {
        enabled = true,
      },
    },
  },
}
