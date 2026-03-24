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
    {
      "<Space>pN",
      function()
        require("editprompt").press("/new")
        vim.cmd("sleep 200ms")
        require("editprompt").press("<CR>")
      end,
    },
    { "<Space><Space>", "<Cmd>Editprompt press_mode<CR>" },
    {
      "1",
      function()
        require("editprompt").press("1")
      end,
    },
    {
      "2",
      function()
        require("editprompt").press("2")
      end,
    },
    {
      "3",
      function()
        require("editprompt").press("3")
      end,
    },
    {
      "4",
      function()
        require("editprompt").press("4")
      end,
    },
    {
      "<CR>",
      function()
        require("editprompt").press("<CR>")
      end,
    },
    {
      "<C-o>",
      function()
        require("editprompt").press("ok")
        vim.cmd("sleep 100ms")
        require("editprompt").press("<CR>")
      end,
    },
  },
  cmd = "Editprompt",
  opts = {
    cmd = { vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js") },
    picker = "snacks",
  },
}
