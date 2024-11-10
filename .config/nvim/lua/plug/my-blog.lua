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

_G.set_aspect_ratio = function()
	-- カーソル位置の行を取得
	local line_num = vim.api.nvim_win_get_cursor(0)[1]
	local line_content = vim.api.nvim_get_current_line()

	-- src属性の値を抽出
	local src = line_content:match('src="([^"]+)"')
	if not src then
		print("src属性が見つかりませんでした")
		return
	end

	-- @をsrc/assets/imagesに置換し、拡張子を除去してfilePrefixを生成
	local file_prefix = src:gsub("@", "src/assets/images"):gsub("%.%w+$", "")

	-- 対応するファイル拡張子のリスト
	local extensions = { "jpg", "png", "webp", "mp4" }
	local target_file = nil

	-- ファイルが存在するか確認
	for _, ext in ipairs(extensions) do
		local file_path = file_prefix .. "." .. ext
		if vim.loop.fs_stat(file_path) then
			target_file = file_path
			break
		end
	end

	-- ファイルが見つからない場合のエラーハンドリング
	if not target_file then
		print("対応するファイルが見つかりませんでした")
		return
	end

	-- ffprobeで幅と高さを取得してaspectRatioを計算
	local width, height = get_file_size(target_file)
	if not width or not height then
		print("画像または動画のサイズが取得できませんでした")
		return
	end
	local aspect_ratio = string.format("%.2f", width / height)

	-- 新しい行内容を生成
	vim.cmd("normal! k")
	line_content = vim.api.nvim_get_current_line()
	local new_line = line_content .. ' aspectRatio="' .. aspect_ratio .. '"'

	-- 行を置き換え
	-- line-rangeは0ベースインデックスで、startとstart同じなら新規行、別なら入れ替えとなる
	vim.api.nvim_buf_set_lines(0, line_num - 2, line_num - 1, false, { new_line })
end

vim.api.nvim_set_keymap("n", "<Space>gi", ":lua set_aspect_ratio()<CR>", { noremap = true, silent = true })
