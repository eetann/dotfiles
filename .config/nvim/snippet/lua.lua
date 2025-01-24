local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
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
	s(
		"class",
		f(function(_, _, _)
			local plugin_name = vim.fn.expand("%"):match("^lua/([^/]+)/")
			local filename = vim.fn.expand("%:t:r")
			local parts = vim.split(filename, "_")
			for j, part in ipairs(parts) do
				parts[j] = part:sub(1, 1):upper() .. part:sub(2)
			end
			local class_name = table.concat(parts, "")
			local text = ([[
---@class pluginname.classname
classname = {}
classname.__index = classname

function classname.new()
  return setmetatable({}, classname)
end

function classname:execute()
  --
end]]):gsub("classname", class_name):gsub("pluginname", plugin_name)
			return vim.split(text, "\n")
		end, {}, {})
	),
}
