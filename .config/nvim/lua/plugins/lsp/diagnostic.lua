vim.diagnostic.config({
  severity_sort = true,
  virtual_text = {
    prefix = "●",
    format = function(diagnostic)
      return string.format("%s <%s>", diagnostic.message, diagnostic.source)
    end,
  },
  float = {
    format = function(diagnostic)
      return string.format("%s <%s>", diagnostic.message, diagnostic.source)
    end,
    border = "rounded",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})
