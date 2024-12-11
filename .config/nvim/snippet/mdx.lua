local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		{ trig = "(tdis|qdis)", name = "textlint disable", trigEngine = "vim" },
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
		{ trig = "(img|qimg|image|Image)", name = "blog Image component", trigEngine = "vim" },
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
		{ trig = "(video|qvideo|Video)", name = "blog Video component", trigEngine = "vim" },
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
}
