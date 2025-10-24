return {
  "mattn/emmet-vim",
  ft = {
    "astro",
    "blade",
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "markdown",
    "mdx",
    "php",
    "react",
    "typescript",
    "typescriptreact",
    "vue",
    "xml",
    "svelte",
  },
  init = function()
    vim.g.user_emmet_leader_key = "<C-g>e"
    vim.g.user_emmet_settings = {
      variables = {
        lang = "ja",
      },
    }
  end,
}
