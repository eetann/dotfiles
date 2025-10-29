local function is_file_too_large(bufnr)
  local size = vim.api.nvim_buf_line_count(bufnr)
  return size > 10000
end
local function is_minified_file(bufnr)
  -- is likely minified if one of the first 5 lines is longer than 1000 characters
  for i = 0, 5 do
    local lines = vim.api.nvim_buf_get_lines(bufnr, i, i + 1, false)
    if #lines == 0 then
      return false
    end
    if #lines[1] > 300 then
      return true
    end
  end
  return false
end

---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- need tree-sitter-cli
    -- https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local languages = {
        "astro",
        "bash",
        "c",
        "cpp",
        "css",
        "go",
        "graphql",
        "html",
        "javascript",
        "json",
        "json5",
        "lua",
        "markdown",
        "php",
        "python",
        "regex",
        "rust",
        "sql",
        "toml",
        "tmux",
        "tsx",
        "typescript",
        "vim",
        "vhs",
        "vue",
        "yaml",
      }
      require("nvim-treesitter").install(languages)

      vim.treesitter.language.register("markdown", { "mdx" })

      local filetypes = {}
      for _, lang in ipairs(require("nvim-treesitter").get_available(2)) do
        for _, filetype in ipairs(vim.treesitter.language.get_filetypes(lang)) do
          table.insert(filetypes, filetype)
        end
      end

      -- ハイライトとインデント有効化
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetypes,
        group = vim.api.nvim_create_augroup("vim-treesitter-start", {}),
        callback = function(ctx)
          local bufnr = ctx.buf
          if is_minified_file(bufnr) or is_file_too_large(bufnr) then
            return
          end
          pcall(vim.treesitter.start)
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufNewFile", "BufRead" },
    keys = {
      { "<space>tc", ":TSContextToggle<CR>" },
    },
    opts = {
      max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 30,
      on_attach = function(bufnr)
        -- quickerではオフにする
        return vim.bo[bufnr].filetype ~= "qf"
      end,
    },
  },
}
