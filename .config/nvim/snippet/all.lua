local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
return {
	s(
		"qpp",
		fmt(
			[[
        あなたは、プロの{}です。
        以下の制約条件と入力文をもとに、{}を出力してください。
        
        ### 制約条件：
        {}
        
        ### 入力文：
        {}
      ]],
			{ i(1), i(2), i(3), i(0) }
		)
	),
	s(
		"qpyouyaku",
		fmt(
			[[
        以下のテキストを要約し、最も重要なポイントを箇条書きにまとめてください。

        テキスト: """
        {}
        """
      ]],
			{ i(0) }
		)
	),
}
