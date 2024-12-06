if vim.b.my_plugin_mdx ~= nil then
	return
end
vim.b.my_plugin_mdx = true

vim.cmd.runtime({ "after/ftplugin/markdown.lua", bang = true })

vim.opt_local.wrap = true

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

local function get_file_size(file_path)
	-- ffprobeコマンドで画像や動画の幅と高さを取得
	local handle =
		io.popen("ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 " .. file_path)
	if not handle then
		print("ffprobeコマンドの実行に失敗しました")
		return nil, nil
	end
	local result = handle:read("*a")
	handle:close()

	-- 幅と高さを分割して返す
	local width, height = result:match("(%d+)x(%d+)")
	return tonumber(width), tonumber(height)
end

_G.process_mdx_file = function()
	vim.print("画像・動画の処理を開始")
	local R2_BACKUP_PATH, err = validate_r2_backup_path()
	if not R2_BACKUP_PATH then
		vim.print(err)
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
			return
		end
	end

	vim.cmd("sleep 100m")
	vim.print("変換中")
	-- aspectRatioListを作成
	local aspectRatioList = {}
	for _, media_filename in ipairs(file_list) do
		local src_path = string.format("%s/src/assets/images/_ignore/%s", vim.fn.getcwd(), media_filename)
		local file_ext = media_filename:match("^.+(%..+)$")

		if file_ext ~= ".mp4" then
			local dst_file = string.format("%s/%s/%s.avif", R2_BACKUP_PATH, slug, media_filename:match("(.+)%..+$"))
			vim.print("dst_file" .. dst_file)
			vim.fn.system({ "ffmpeg", "-i", src_path, dst_file })
		else
			local dst_file = string.format("%s/%s/%s", R2_BACKUP_PATH, slug, media_filename)
			vim.print("dst_file" .. dst_file)
			vim.fn.system({ "cp", src_path, dst_file })
		end

		-- アスペクト比を計算
		local width, height = get_file_size(src_path)
		if not width or not height then
			print("画像または動画のサイズが取得できませんでした")
			return
		end
		local aspect_ratio = width / height
		aspectRatioList[media_filename] = aspect_ratio
	end
	vim.print("変換終了")

	-- mdxファイルを更新
	for key, aspect_ratio in pairs(aspectRatioList) do
		vim.fn.setreg("/", "src=[\"']@:" .. key .. "[\"']")
		vim.cmd("normal! n")

		-- srcのパスの置換
		local new_filename = "@/" .. slug .. "/" .. key:match("^(.-)%.")
		if key:match("mp4") then
			new_filename = new_filename .. ".mp4"
		else
			new_filename = new_filename .. ".avif"
		end
		vim.cmd("substitute=@:" .. key .. "=" .. new_filename)

		-- アスペクト比の追記
		vim.cmd("normal! k")
		local line_content = vim.api.nvim_get_current_line()
		local new_line = line_content .. ' aspectRatio="' .. string.format("%.2f", aspect_ratio) .. '"'
		vim.api.nvim_set_current_line(new_line)
	end
	vim.print("処理が終わりました！")
end

vim.api.nvim_set_keymap("n", "<Space>gi", ":lua process_mdx_file()<CR>", { noremap = true, silent = true })
