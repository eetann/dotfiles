local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cout",
		fmt(
			[[
        cout << {} << endl;
		  ]],
			{ i(0) }
		)
	),
	s(
		"cin",
		fmt(
			[[
        cin >> {};
		  ]],
			{ i(0) }
		)
	),
	s(
		"getline",
		fmt(
			[[
        getline(cin, {});
		  ]],
			{ i(0, "var_name") }
		)
	),
}
