---@type LazyPluginSpec
return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		{ "theHamsta/nvim-dap-virtual-text", opts = {} },
	},
	keys = {
		{
			"<space>du",
			function()
				require("dapui").toggle()
			end,
			desc = "toggle dap-ui",
		},
		{
			"<space>dd",
			function()
				require("dap").continue()
			end,
			desc = "Debug: start/continue",
		},
		{
			"<space>dm",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: toggle break(mark)",
		},
		{
			"<space>dM",
			function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
			desc = "Debug: set break(mark) with message",
		},
		{
			"<space>de",
			function()
				require("dapui").eval()
			end,
			desc = "Debug: eval at cursor",
		},
		{
			"<space>dE",
			function()
				require("dapui").eval(vim.fn.input("[Expression] > "))
			end,
			desc = "Debug: eval expression",
		},
		{
			"<space>d[[",
			function()
				require("dap").step_back()
			end,
			desc = "Debug: step back (1ステップ戻る)",
		},
		{
			"<space>d]]",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: step over (次のステップまで進める)",
		},
		{
			"<space>d}}",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: step into (関数の中へ)",
		},
		{
			"<space>d{{",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: step out (関数から外へ)",
		},
		{
			"<space>dh",
			function()
				require("dap.ui.widgets").hover()
			end,
			desc = "Debug: hover",
		},
		{
			"<space>dq",
			function()
				require("dap").close()
			end,
			desc = "Debug: quit session (デバッグの終了)",
		},
	},
	config = function()
		local dapui = require("dapui")
		dapui.setup()
		local dap = require("dap")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
		)
		vim.fn.sign_define("DapBreakpointRejected", {
			text = "󰉥",
			texthl = "DapBreakpointRejected",
			linehl = "DapBreakpointRejected",
			numhl = "DapBreakpointRejected",
		})
		vim.fn.sign_define(
			"DapLogPoint",
			{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
		)
		vim.fn.sign_define(
			"DapStopped",
			{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
		)
		require("plugins.dap.cpp")
	end,
}
