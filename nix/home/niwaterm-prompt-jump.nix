# niwatermのプロンプト目次（Claude Codeのタブの端に出す目次と、選んだプロンプトへのジャンプ）。
# 手順の原本はniwaterm本体の
# contrib/agent-integration/claude-code/prompt-jump/README.md。
#
# 置くものは2つで、どちらもniwaterm本体（daily）のリポジトリを直接参照する。
# 両者はタブ変数名・送るキーの取り決めを共有する対なので、同じリビジョンを
# 読ませて片方だけ古くならないようにする。
#   - mod/: Claude Code側のmod。~/.claude/settings.jsonの
#     CLAUDE_CODE_PLUGIN_DIRSから~/.config/claude-mods/niwaterm-prompt-jumpとして読ませる
#   - hover-buttons.ts: niwaterm側の目次。niwaterm.config.tsから相対パスでimportする
{
  config,
  lib,
  ...
}:
let
  promptJumpDir = "${config.home.homeDirectory}/ghq/github.com/eetann/niwaterm/contrib/agent-integration/claude-code/prompt-jump";
in
{
  xdg.configFile = {
    "claude-mods/niwaterm-prompt-jump".source =
      config.lib.file.mkOutOfStoreSymlink "${promptJumpDir}/mod";
    "niwaterm/hover-buttons/claude-prompt-jump.ts".source =
      config.lib.file.mkOutOfStoreSymlink "${promptJumpDir}/hover-buttons.ts";
  };

  # NixOS-WSL環境ではniwatermアプリがWindows側で動くため、目次もWindows側の設定
  # ディレクトリへ置く。custom-views/と同じく、リンクではなく実ファイルとしてコピーする。
  # WSL側のcpでDrvFs上に作る通常ファイルはWindowsネイティブアプリからもそのまま読める
  # （リンクの場合の事情はdefault.nixのniwatermWindowsConfigを参照）。
  # コピーなので、niwaterm本体を更新したらnixos-rebuild switchで取り込み直す。
  # niwatermWindowsConfigがリンクを張り直すとniwatermが設定を読み直すことがあるため、
  # その時点でimport先が揃っているよう先にコピーする
  home.activation.niwatermPromptJumpWindows =
    lib.hm.dag.entryBetween [ "niwatermWindowsConfig" ] [ "writeBoundary" ]
      ''
        windowsNiwatermDir="/mnt/c/Users/eetann/.config/niwaterm"
        promptJumpSrc="${promptJumpDir}/hover-buttons.ts"
        if [ -d "$windowsNiwatermDir" ]; then
          if [ -f "$promptJumpSrc" ]; then
            run mkdir -p "$windowsNiwatermDir/hover-buttons"
            run cp -f "$promptJumpSrc" "$windowsNiwatermDir/hover-buttons/claude-prompt-jump.ts"
          else
            warnEcho "niwatermのプロンプト目次が無いためWindows側へのコピーを飛ばします: $promptJumpSrc"
          fi
        fi
      '';
}
