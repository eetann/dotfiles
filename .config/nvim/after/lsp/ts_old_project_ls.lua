---@type vim.lsp.Config
return {
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { "package.json" },
  -- プロジェクトのTypeScriptが古すぎてLSPが動かないとき用
  -- server-register.luaで 環境変数TS_LS_GLOBAL=1の時だけ動くように判定
  -- miseの場合は以下
  -- mise set TS_LS_GLOBAL=1
  -- mise trust
  init_options = {
    tsserver = {
      path = vim.fn.expand(
        "~/.local/share/pnpm/global/5/node_modules/typescript/lib"
      ),
    },
  },
}
