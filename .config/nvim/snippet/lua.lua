local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"snippet",
		fmt(
			[=[
        s(
          "<trigger>",
          fmt(
            [[
              <text>
            ]],
            { i(1, "<placeholder>") }
          )
        ),

		  ]=],
			{ trigger = i(1, "trigger"), text = i(2, "text"), placeholder = i(0, "placeholder") },
			{ delimiters = "<>" }
		)
	),
	s(
		"snippet-require",
		fmt(
			[[
        local ls = require("luasnip")
        local s = ls.snippet
        local i = ls.insert_node
        local fmt = require("luasnip.extras.fmt").fmt
        return {
          <>
        }
		  ]],
			{ i(0, "snipet") },
			{ delimiters = "<>" }
		)
	),
}
