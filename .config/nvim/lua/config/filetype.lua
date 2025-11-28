vim.g.tex_flavor = "latex"
local group_name = "my_nvim_rc"

vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

-- vim.filetype.add({
-- 	pattern = {
-- 		[".*%.blade%.php"] = "blade",
-- 	},
-- })

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "help", "man" },
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>quit<CR>", { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "make" },
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "cpp", "python", "php", "blade" },
  callback = function()
    vim.cmd([[
    setlocal sw=4 sts=4 ts=4
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "blade" },
  callback = function()
    vim.bo.commentstring = "{{-- %s --}}"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "vhs" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "css", "help" },
  callback = function()
    vim.cmd([[
    setlocal iskeyword+=-
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "text", "quickrun", "tex" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "json" },
  callback = function()
    vim.cmd([[
    syntax match Comment +\/\/.\+$+
    ]])
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "mdx" },
  callback = function()
    -- ref: https://zenn.dev/vim_jp/articles/4564e6e5c2866d
    vim.opt_local.comments = {
      "b:- [ ]",
      "b:- [x]",
      -- "b:1.",
      "b:*",
      "b:-",
      "b:+",
    }
    local fmt = vim.opt_local.formatoptions
    fmt:remove("c")
    fmt:append("jro")
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = group_name,
  pattern = { "json5" },
  callback = function()
    vim.bo.commentstring = [[// %s]]
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = group_name,
  pattern = { "*.tex" },
  callback = function()
    vim.opt_local.indentexpr = ""
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = group_name,
  pattern = { "*.csv" },
  callback = function()
    vim.opt_local.filetype = "csv"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = group_name,
  pattern = { ".envrc" },
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
})

vim.api.nvim_create_autocmd({ "BufRead" }, {
  group = group_name,
  pattern = { "/tmp/*" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group_name,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = {
    "term://*",
  },
  callback = function()
    vim.keymap.set("n", "q", "<Cmd>quit<CR>", { buffer = true, silent = true })
  end,
})
