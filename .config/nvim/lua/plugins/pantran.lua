return {
  "potamides/pantran.nvim",
  cmd = "Pantran",
  keys = {
    { "<space>tr", "<CMD>Pantran<CR>" },
    {
      "<space>tr",
      function()
        return require("pantran").motion_translate()
      end,
      mode = { "v" },
      expr = true,
      desc = "translate",
    },
  },
  opts = {
    default_engine = "google",
    engines = {
      google = {
        fallback = {
          default_source = "en",
          default_target = "ja",
        },
      },
    },
    ui = {
      width_percentage = 0.95,
      height_percentage = 0.4,
    },
  },
}
