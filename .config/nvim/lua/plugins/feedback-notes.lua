---@module "lazy"
---@type LazyPluginSpec
return {
  dir = "~/ghq/github.com/eetann/feedback-notes.nvim",
  keys = {
    { "<Space>na", "<Cmd>FeedbackNotes add<CR>" },
    { "<Space>na", "<Cmd>FeedbackNotes add --visual<CR>", mode = "x" },
    { "<Space>ne", "<Cmd>FeedbackNotes edit<CR>" },
    { "<Space>nd", "<Cmd>FeedbackNotes delete<CR>" },
    { "<Space>nl", "<Cmd>FeedbackNotes list<CR>" },
    { "<Space>ny", "<Cmd>FeedbackNotes export<CR>" },
    { "<Space>nt", "<Cmd>FeedbackNotes toggle<CR>" },
  },
  cmd = "FeedbackNotes",
  opts = {
    picker = "snacks",
  },
}
