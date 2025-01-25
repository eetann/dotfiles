local dap = require("dap")
-- dapへアダプタを登録
dap.adapters.codelldb = {
	type = "executable",
	command = "codelldb",
}
-- ファイルタイプ・アダプタ・設定の紐づけ
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			if vim.fn.getcwd():find("^" .. vim.fn.expand("~/ghq/github.com/eetann/myatcoder")) then
				return vim.fn.getcwd() .. "/main.out"
			end
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		-- overseer連携: .config/nvim/lua/overseer/template/cpp/gpp-debug-build.lua
		preLaunchTask = "g++ debug build",
	},
}
