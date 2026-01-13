---@module "lazy"
---@type LazyPluginSpec
return {
  dir = "~/ghq/github.com/eetann/editprompt.nvim",
  cond = vim.env.EDITPROMPT == "1",
  keys = {
    {
      "<Space>x",
      function()
        require("editprompt").input()
      end,
      desc = "Send buffer content to editprompt",
    },
    {
      "<Space>sx",
      function()
        require("editprompt").input_auto_send()
      end,
      desc = "Send buffer content to editprompt (auto-send)",
    },
    {
      "<Space>X",
      function()
        require("editprompt").capture()
      end,
      desc = "Capture from editprompt quote mode",
    },
    {
      "<Space>ss",
      function()
        require("editprompt").stash_push()
      end,
      desc = "Stash buffer content",
    },
    {
      "<Space>sS",
      function()
        require("editprompt").stash_pop()
      end,
      desc = "Pop stashed prompt",
    },
  },
  opts = {
    cmd = { vim.fn.expand("~/ghq/github.com/eetann/editprompt/dist/index.js") },
  },
}
