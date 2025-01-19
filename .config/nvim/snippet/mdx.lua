local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		{ trig = "qdis", name = "textlint disable" },
		fmt(
			[[

        {/* textlint-disable */}

        <>

        {/* textlint-enable */}

		  ]],
			{ i(1, "text") },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "qimg", name = "blog Image component" },
		fmt(
			[[
        <Image width="500"
          src="@:[]"
          alt="[]"
        />
      ]],
			{ i(1, "path"), i(2, "alt") },
			{ delimiters = "[]" }
		)
	),
	s(
		{ trig = "qvideo", name = "blog Video component" },
		fmt(
			[[
        <Video width="800"
          src="@:[]"
          alt="[]"
          muted={true}
          autoplay={true}
          loop={true}
        />
		  ]],
			{ i(1, "path"), i(2, "alt") },
			{ delimiters = "[]" }
		)
	),
	s(
		"sakini",
		fmt(
			[[
        先に実装の全体を載せます。**次の項目から小分けにして解説**します。{}
		  ]],
			{ i(1) }
		)
	),
}
