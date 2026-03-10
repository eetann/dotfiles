---@module "lazy"
---@type LazyPluginSpec
return {
  dir = "~/ghq/github.com/eetann/editprompt.nvim",
  cond = vim.env.EDITPROMPT == "1",
  keys = {
    { "<Space>pi", "<Cmd>Editprompt input --auto-send<CR>" },
    {
      "<Space>pi",
      "<Cmd>Editprompt input --auto-send --visual<CR>",
      mode = "x",
    },
    { "<Space>pI", "<Cmd>Editprompt input<CR>" },
    { "<Space>pI", "<Cmd>Editprompt input --visual<CR>", mode = "x" },
    { "<Space>pd", "<Cmd>Editprompt dump<CR>" },
    { "<Space>ps", "<Cmd>Editprompt stash pop<CR>" },
    { "<Space>pS", "<Cmd>Editprompt stash push<CR>" },
    { "<Space>pp", "<Cmd>Editprompt history prev<CR>" },
    { "<Space>pn", "<Cmd>Editprompt history next<CR>" },
  },
  cmd = "Editprompt",
  opts = {
    cmd = { vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js") },
    picker = "snacks",
  },
}
