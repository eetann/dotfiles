local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"snote",
		fmt(
			[[
<!--
{}
-->
		  ]],
			{ i(1) }
		)
	),
	s(
		"details",
		fmt(
			[[
<details>
  <summary>{}</summary>

{}

</details>
      ]],
			{ i(1), i(0) }
		)
	),
}
