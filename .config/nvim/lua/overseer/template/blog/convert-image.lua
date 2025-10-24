---@return string|nil
local function validate_r2_backup_path()
  local path = os.getenv("R2_BACKUP_PATH")
  if not path or path == "" then
    vim.print("環境変数R2_BACKUP_PATHが設定されていません")
    return nil
  end
  if not vim.uv.fs_stat(path) then
    vim.print(
      "R2_BACKUP_PATHが存在しないディレクトリを指しています: "
        .. path
    )
    return nil
  end
  return path
end

---@return table
local function create_tasks_convert_images()
  vim.print("画像・動画の処理を開始")
  local R2_BACKUP_PATH = validate_r2_backup_path()
  if not R2_BACKUP_PATH then
    return {}
  end

  local util = require("overseer.template.blog._utils")
  local slug = util.get_slug()
  local file_list = util.get_file_list()

  -- ディレクトリの作成
  local dst_dir = string.format("%s/%s/", R2_BACKUP_PATH, slug)
  if not vim.uv.fs_stat(dst_dir) then
    -- 493はパーミッション（8進数0755に対応）
    local _, err = vim.uv.fs_mkdir(dst_dir, 493)
    if err then
      vim.print("ディレクトリの作成に失敗しました。")
      return {}
    end
  end

  local dependencies = {}
  for _, media_filename in ipairs(file_list) do
    local src_path = string.format(
      "%s/src/assets/images/_ignore/%s",
      vim.fn.getcwd(),
      media_filename
    )
    local file_ext = media_filename:match("^.+(%..+)$")

    if file_ext ~= ".mp4" then
      local dst_file = string.format(
        "%s/%s/%s.avif",
        R2_BACKUP_PATH,
        slug,
        media_filename:match("(.+)%..+$")
      )
      table.insert(dependencies, {
        cmd = "ffmpeg",
        args = { "-y", "-i", src_path, dst_file },
        components = {
          { "on_exit_set_status" },
          { "on_output_quickfix", open_on_exit = "failure" },
        },
      })
    else
      local dst_file =
        string.format("%s/%s/%s", R2_BACKUP_PATH, slug, media_filename)
      table.insert(dependencies, {
        cmd = "cp",
        args = { src_path, dst_file },
        components = {
          { "on_exit_set_status" },
          { "on_output_quickfix", open_on_exit = "failure" },
        },
      })
    end
  end

  return dependencies
end

---@type overseer.TemplateDefinition
return {
  name = "convert blog images",
  builder = function()
    local dependencies = create_tasks_convert_images()
    if next(dependencies) == nil then
      return {
        cmd = "echo 'FAILED: convert blog images' && false",
      }
    end
    table.insert(dependencies, { "update mdx for blog images" })
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
