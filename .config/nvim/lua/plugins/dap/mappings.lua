---@module "lazy"
---@type LazyKeysSpec[]
return {
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
}
