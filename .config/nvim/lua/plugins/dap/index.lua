return {
	"rcarriga/nvim-dap-ui",
	cond = not vim.g.vscode,
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
	},
	keys = require("plugins.dap.mappings"),
	-- opts経由で渡さないとmissing-fieldsが面倒くさい
	opts = {
		controls = {
			icons = {
				disconnect = "⏻",
			},
		},
	},
	config = function(_, opts)
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup(opts)

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", {
			text = "󰉥",
			texthl = "",
			linehl = "",
			numhl = "",
		})
		vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "", texthl = "", linehl = "", numhl = "" })

		-- adapters
		require("plugins.dap.cpp")
	end,
}
