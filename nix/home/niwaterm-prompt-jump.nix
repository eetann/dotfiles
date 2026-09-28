# niwatermのプロンプト目次（Claude Codeのタブの端に出す目次と、選んだプロンプトへのジャンプ）。
# 手順の原本はniwaterm本体の
# contrib/agent-integration/claude-code/prompt-jump/README.md。
#
# ここで置くのはClaude Code側のmodだけ。niwaterm側の目次は@niwaterm/configの
# claudePromptJumpをniwaterm.config.tsからimportするので、ファイルを置く必要はない。
# modはniwaterm本体（daily）のリポジトリを直接参照し、@niwaterm/configと同じリビジョンを
# 読ませる（両者はタブ変数名・送るキーの取り決めを共有する対なので、片方だけ古くならないように）。
#   - mod/: ~/.claude/settings.jsonのCLAUDE_CODE_PLUGIN_DIRSから
#     ~/.config/claude-mods/niwaterm-prompt-jumpとして読ませる
{
  config,
  ...
}:
let
  promptJumpDir = "${config.home.homeDirectory}/ghq/github.com/eetann/niwaterm/contrib/agent-integration/claude-code/prompt-jump";
in
{
  xdg.configFile."claude-mods/niwaterm-prompt-jump".source =
    config.lib.file.mkOutOfStoreSymlink "${promptJumpDir}/mod";
}
