---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    "vim-denops/denops.vim",
    -- プラグイン側でclone・setupしているが
    -- ヘルプを見たいのでプラグインマネージャー側でも追加
    cmd = "DenopsHelp",
    init = function()
      -- vim.g.denops_server_addr = "127.0.0.1:32123"
    end,
    config = function()
      -- プラグインとしては使わないのでsetupはしない
      vim.api.nvim_create_user_command(
        "DenopsHelp",
        ":belowright vertical help denops",
        {}
      )
    end,
  },
  {
    "vim-denops/denops-shared-server.vim",
    dependencies = { "vim-denops/denops.vim" },
    cmd = "DenopsSharedServerInstall",
    config = function()
      vim.api.nvim_create_user_command("DenopsSharedServerInstall", function()
        vim.fn["denops_shared_server#install"]()
      end, {})
    end,
  },
}
