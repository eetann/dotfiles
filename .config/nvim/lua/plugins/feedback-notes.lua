---@module "lazy"
---@type LazyPluginSpec
return {
  dir = "~/ghq/github.com/eetann/feedback-notes.nvim",
  keys = {
    { "<Tab>", "<Cmd>FeedbackNotes add<CR>" },
    -- ':' (not '<Cmd>') so the visual range '<,'> is passed to the command.
    { "<Tab>", ":FeedbackNotes add<CR>", mode = "x" },
    { "<Space>nd", "<Cmd>FeedbackNotes delete<CR>" },
    { "<Space>nl", "<Cmd>FeedbackNotes list<CR>" },
    { "<Space>ny", "<Cmd>FeedbackNotes export<CR>" },
    { "<Space>nt", "<Cmd>FeedbackNotes toggle<CR>" },
  },
  cmd = "FeedbackNotes",
  opts = {
    picker = "snacks",
    input = {
      height = 3,
      save_keys = { "<CR>", "<Tab>" },
    },
    highlight = {
      border = {
        link = "MatchWord",
      },
      virt = { link = "MatchWord" },
      marker = { link = "MatchWord" },
    },
  },
}
