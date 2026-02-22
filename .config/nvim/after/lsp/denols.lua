vim.g.markdown_fenced_languages = {
  "ts=typescript",
}
---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock", ".git" })
    if root then
      on_dir(root)
    end
  end,
  init_options = {
    lint = true,
    unstable = false,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
        },
      },
    },
  },
}
