local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

return {
	s(
		{ trig = "(tdis|qdis)", name = "textlint disable", trigEngine = "vim" },
		fmt(
			[=[

        {/* textlint-disable */}

        <>

        {/* textlint-enable */}

		  ]=],
			{ i(1, "text") },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "(img|qimg|image|Image)", name = "blog Image component", trigEngine = "vim" },
		fmt(
			[=[
        <Image width="500"
          src="@:[]"
          alt="[]"
        />
      ]=],
			{ i(1, "path"), i(2, "alt") },
			{ delimiters = "[]" }
		)
	),
	s(
		{ trig = "(video|qvideo|Video)", name = "blog Video component", trigEngine = "vim" },
		fmt(
			[=[
        <Video width="800"
          src="@:[]"
          alt="[]"
          muted={true}
          autoplay={true}
          loop={true}
        />
		  ]=],
			{ i(1, "path"), i(2, "alt") },
			{ delimiters = "[]" }
		)
	),
}
