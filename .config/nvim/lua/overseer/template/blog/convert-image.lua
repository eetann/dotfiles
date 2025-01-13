local function validate_r2_backup_path()
	local path = os.getenv("R2_BACKUP_PATH")
	if not path or path == "" then
		return nil, "環境変数R2_BACKUP_PATHが設定されていません"
	end
	if not vim.uv.fs_stat(path) then
		return nil, "R2_BACKUP_PATHが存在しないディレクトリを指しています: " .. path
	end
	return path
end

---@return table
---@return string
---@return table
local function create_tasks_convert_images()
	vim.print("画像・動画の処理を開始")
	local R2_BACKUP_PATH, err_msg = validate_r2_backup_path()
	if not R2_BACKUP_PATH then
		vim.print(err_msg)
		---@diagnostic disable-next-line: missing-return-value
		return
	end

	local filename = vim.fn.expand("%:t")
	local slug = vim.fn.fnamemodify(filename, ":t:r")

	local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)

	-- 画像と動画のファイル名リストを作成
	local file_list = {}
	for _, line in ipairs(content) do
		local media_filename = line:match("src=[\"']@:([%w-_%.]+)")
		if media_filename then
			table.insert(file_list, media_filename)
		end
	end

	-- ディレクトリの作成
	local dst_dir = string.format("%s/%s/", R2_BACKUP_PATH, slug)
	if not vim.uv.fs_stat(dst_dir) then
		-- 493はパーミッション（8進数0755に対応）
		local _, err = vim.uv.fs_mkdir(dst_dir, 493)
		if err then
			vim.print("ディレクトリの作成に失敗しました。")
			---@diagnostic disable-next-line: missing-return-value
			return
		end
	end

	local dependencies = {}
	for _, media_filename in ipairs(file_list) do
		local src_path = string.format("%s/src/assets/images/_ignore/%s", vim.fn.getcwd(), media_filename)
		local file_ext = media_filename:match("^.+(%..+)$")

		if file_ext ~= ".mp4" then
			local dst_file = string.format("%s/%s/%s.avif", R2_BACKUP_PATH, slug, media_filename:match("(.+)%..+$"))
			table.insert(dependencies, {
				cmd = "ffmpeg",
				args = { "-i", src_path, dst_file },
				components = {
					{ "on_exit_set_status", success_codes = { 0 } },
					{ "on_output_quickfix", open_on_exit = "failure" },
				},
			})
		else
			local dst_file = string.format("%s/%s/%s", R2_BACKUP_PATH, slug, media_filename)
			table.insert(dependencies, {
				cmd = "cp",
				args = { src_path, dst_file },
				components = {
					{ "on_exit_set_status", success_codes = { 0 } },
					{ "on_output_quickfix", open_on_exit = "failure" },
				},
			})
		end
	end

	return dependencies, slug, file_list
end

---@type overseer.TemplateDefinition
return {
	name = "convert blog images",
	builder = function()
		local dependencies, slug, file_list = create_tasks_convert_images()
		table.insert(dependencies, { "(internal) update mdx", slug = slug, file_list = file_list })
		---@type overseer.TaskDefinition
		return {
			cmd = "echo 'convert blog images'",
			components = {
				{
					"dependencies",
					task_names = dependencies,
					sequential = true,
				},
				"default",
			},
		}
	end,
	condition = {
		dir = "~/ghq/github.com/eetann/cyber-blog",
	},
}
