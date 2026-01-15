---@module "lazy"
---@type LazyPluginSpec
return {
  dir = "~/ghq/github.com/eetann/editprompt.nvim",
  cond = vim.env.EDITPROMPT == "1",
  keys = {
    { "<Space>pi", "<Cmd>Editprompt input --auto-send<CR>" },
    { "<Space>pI", "<Cmd>Editprompt input<CR>" },
    { "<Space>pc", "<Cmd>Editprompt capture<CR>" },
    { "<Space>ps", "<Cmd>Editprompt stash pop<CR>" },
    { "<Space>pS", "<Cmd>Editprompt stash push<CR>" },
  },
  cmd = "Editprompt",
  opts = {
    cmd = { vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js") },
    picker = "snacks",
  },
}
