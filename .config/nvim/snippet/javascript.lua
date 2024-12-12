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
		"ret",
		fmt(
			[[
        return {};
      ]],
			{ i(1) }
		)
	),
}
