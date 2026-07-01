---@module "lazy"
---@type LazyPluginSpec
return {
  dir = "~/ghq/github.com/eetann/feedback-notes.nvim",
  event = { "VeryLazy" },
  keys = {
    { "<Tab>", "<Cmd>FeedbackNotes add<CR>" },
    -- ':' (not '<Cmd>') so the visual range '<,'> is passed to the command.
    { "<Tab>", "<Cmd>FeedbackNotes add<CR>", mode = "x" },
    { "<Space>nl", "<Cmd>FeedbackNotes list<CR>" },
    { "<Space>ny", "<Cmd>FeedbackNotes export<CR>" },
    { "<Space>nt", "<Cmd>FeedbackNotes toggle<CR>" },
  },
  cmd = "FeedbackNotes",
  opts = {
    auto_restore = true,
    picker = "snacks",
    input = {
      height = 5,
      save_keys = { "<CR>", "<Tab>" },
    },
    highlight = {
      border = {
        link = "MatchWord",
      },
      -- virt = { link = "MatchWord" },
      marker = { link = "MatchWord" },
      input_border = { link = "MatchWord" },
      input_title = { link = "MatchWord" },
    },
  },
}
