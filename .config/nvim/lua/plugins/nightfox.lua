return {
  "EdenEast/nightfox.nvim",
  config = function()
    require("nightfox").setup({
      options = {
        transparent = true,
      },
      groups = {
        all = {
          ["@markup.raw"] = { style = "NONE" },
          -- ターミナル透過でも見やすいようにする
          Visual = { bg = "#1a2e30", style = "italic" },
          -- render-markdownのコードブロック用
          RenderMarkdownCodeBg = { bg = "#212e3f" },
        },
      },
    })
    vim.cmd("colorscheme terafox")
    vim.cmd("highlight! link WinSeparator GlyphPalette2")
  end,
}
