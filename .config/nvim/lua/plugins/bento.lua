return {
  "serhez/bento.nvim",
  cond = not vim.g.vscode and not vim.env.EDITPROMPT,
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>;",
      function()
        local ui = require("bento.ui")
        -- 現在のメニューを閉じる
        ui.close_menu()
        -- グローバル変数を書き換えてモードをトグル
        if BentoConfig.ui.mode == "floating" then
          BentoConfig.ui.mode = "tabline"
        else
          BentoConfig.ui.mode = "floating"
        end
        -- 新しいモードでメニューを開く
        ui.toggle_menu()
        vim.notify(
          "Bento: " .. BentoConfig.ui.mode .. " mode",
          vim.log.levels.INFO
        )
      end,
      desc = "Bento: toggle floating/tabline mode",
    },
  },
}
