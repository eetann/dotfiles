return {
  "delphinus/cellwidths.nvim",
  build = ":CellWidthsRemove",
  opts = {
    name = "user/default",
    ---@param cw cellwidths
    fallback = function(cw)
      ---@diagnostic disable-next-line: missing-return
      cw.load("default")
      -- https://guppy.eng.kagawa-u.ac.jp/OpenCampus/unicode.html
      -- cw.add({ 0x1f300, 0x1f0ff, 2 })
      -- cw.add(0x1f5bc, 1)
    end,
  },
}
