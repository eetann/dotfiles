local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

---@param text string
---@return string
local function dashsnake_to_pascal(text)
	local parts = vim.split(text, "[_-]", { plain = false })
	for j, part in ipairs(parts) do
		parts[j] = part:sub(1, 1):upper() .. part:sub(2)
	end
	return table.concat(parts, "")
end

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
	s(
		"class",
		f(function(_, _, _)
			local plugin_name = dashsnake_to_pascal(vim.fn.expand("%"):match("^lua/([^/]+)/"))
			local class_name = dashsnake_to_pascal(vim.fn.expand("%:t:r"))
			local text = ([[
---@class pluginname.classname
local classname = {}
classname.__index = classname

function classname:new()
  return setmetatable({}, classname)
end

function classname:execute()
  --
end

return classname]]):gsub("classname", class_name):gsub("pluginname", plugin_name)
			return vim.split(text, "\n")
		end, {}, {})
	),
	s(
		"desc",
		fmt(
			[[
        describe("{}", function ()
          {}
        end)
    ]],
			{ i(1), i(2) }
		)
	),
	s(
		"it",
		fmt(
			[[
        it("{}", function ()
          {}
        end)
    ]],
			{ i(1), i(2) }
		)
	),
}
