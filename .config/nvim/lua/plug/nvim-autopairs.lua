local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({})

npairs.add_rules({
	Rule("```", "```", { "mdx" }),
})
