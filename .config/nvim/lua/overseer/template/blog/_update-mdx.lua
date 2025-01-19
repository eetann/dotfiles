---@param file_path string
---@return nil|number
---@return nil|number
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

local function update_mdx()
	local util = require("overseer.template.blog._utils")
	local slug = util.get_slug()
	local file_list = util.get_file_list()

	local aspectRatioList = {}
	for _, media_filename in ipairs(file_list) do
		local src_path = string.format("%s/src/assets/images/_ignore/%s", vim.fn.getcwd(), media_filename)
		local width, height = get_file_size(src_path)
		if not width or not height then
			print("画像または動画のサイズが取得できませんでした")
			return
		end
		local aspect_ratio = width / height
		aspectRatioList[media_filename] = aspect_ratio
	end

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

---@type overseer.TemplateDefinition
return {
	name = "update mdx for blog images",
	builder = function()
		update_mdx()
		---@type overseer.TaskDefinition
		return {
			cmd = "echo 'update mdx for blog images'",
		}
	end,
	priority = 100,
	condition = {
		dir = "~/ghq/github.com/eetann/cyber-blog",
	},
}
