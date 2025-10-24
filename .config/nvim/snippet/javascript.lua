local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "const",
    fmt(
      [[
        const {} = {};
      ]],
      { i(1, "name"), i(2, "value") }
    )
  ),
  s(
    "let",
    fmt(
      [[
        let {}: {} = {};
      ]],
      { i(1, "name"), i(2, "type"), i(3, "value") }
    )
  ),
  s(
    "ret",
    fmt(
      [[
        return {};
      ]],
      { i(1) }
    )
  ),
  s(
    "afb",
    fmt(
      [[
        ([]) => {[]}
      ]],
      { i(1), i(2) },
      { delimiters = "[]" }
    )
  ),
  s(
    "fun",
    fmt(
      [[
        function []([]:[]) {
          []
        }
      ]],
      { i(1, "name"), i(2, "param"), i(3, "type"), i(0) },
      { delimiters = "[]" }
    )
  ),
}
