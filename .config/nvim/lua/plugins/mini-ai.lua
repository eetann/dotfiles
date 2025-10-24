return {
  "nvim-mini/mini.ai",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "VeryLazy" },
  opts = function()
    local gen_spec = require("mini.ai").gen_spec
    local jpKakkoTable = {
      ["("] = gen_spec.pair("（", "）", { type = "non-balanced" }),
      [")"] = gen_spec.pair("（", "）", { type = "non-balanced" }),
      ["8"] = gen_spec.pair("（", "）", { type = "non-balanced" }),
      ["9"] = gen_spec.pair("（", "）", { type = "non-balanced" }),
      ["["] = gen_spec.pair("［", "］", { type = "non-balanced" }),
      ["]"] = gen_spec.pair("［", "］", { type = "non-balanced" }),
      ["B"] = gen_spec.pair("［", "］", { type = "non-balanced" }),
      ["}"] = gen_spec.pair("｛", "｝", { type = "non-balanced" }),
      ["{"] = gen_spec.pair("｛", "｝", { type = "non-balanced" }),
      ["<"] = gen_spec.pair("＜", "＞", { type = "non-balanced" }),
      [">"] = gen_spec.pair("＜", "＞", { type = "non-balanced" }),
      ["k"] = gen_spec.pair("「", "」", { type = "non-balanced" }),
      ["K"] = gen_spec.pair("『", "』", { type = "non-balanced" }),
      ["y"] = gen_spec.pair("〈", "〉", { type = "non-balanced" }),
      ["Y"] = gen_spec.pair("《", "》", { type = "non-balanced" }),
      ["r"] = gen_spec.pair("【", "】", { type = "non-balanced" }),
      ["s"] = gen_spec.pair("【", "】", { type = "non-balanced" }),
      ["t"] = gen_spec.pair("〔", "〕", { type = "non-balanced" }),
      ["a"] = gen_spec.pair("＜", "＞", { type = "non-balanced" }),
      ["A"] = gen_spec.pair("≪", "≫", { type = "non-balanced" }),
    }
    return {
      n_lines = 250,
      search_method = "cover",
      custom_textobjects = {
        ["j"] = function()
          local char = vim.fn.input("enter for KAKKO: ")
          local pair = jpKakkoTable[char]
          if pair == nil then
            error("j" .. char .. " is unsupported :(")
          end
          return pair
        end,
        c = gen_spec.treesitter({
          a = "@block.outer",
          i = "@block.inner",
        }),
      },
    }
  end,
}
