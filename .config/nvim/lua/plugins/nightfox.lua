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
        },
      },
    })
    vim.cmd("colorscheme terafox")
    vim.cmd("highlight! link WinSeparator GlyphPalette2")
  end,
}
