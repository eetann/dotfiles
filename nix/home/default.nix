# home-managerによるdotfiles管理
#
# mkOutOfStoreSymlinkを使用することで、設定ファイルの編集が即座に反映される。
# （通常のhome.fileだとhome-manager switchを実行するまで反映されない）
#
# シンボリックリンクは3段階になる:
#   ~/.config/nvim
#     → /nix/store/.../home-manager-files/.config/nvim
#       → /nix/store/.../hm_nvim
#         → ~/dotfiles/.config/nvim  ← 最終的にここを指す
#
{
  config,
  pkgs,
  lib,
  ...
}:

let
  # mkOutOfStoreSymlinkを使うため、絶対パス文字列が必要
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";

  # home.file用ヘルパー: リストから { "name".source = mkOutOfStoreSymlink ... } を生成
  mkHomeFile = name: {
    name = name;
    value = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${name}";
    };
  };
  mkHomeFiles = files: builtins.listToAttrs (map mkHomeFile files);

  # xdg.configFile用ヘルパー: リストから { "name".source = mkOutOfStoreSymlink .config/... } を生成
  mkConfigFile = name: {
    name = name;
    value = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/.config/${name}";
    };
  };
  mkConfigFiles = files: builtins.listToAttrs (map mkConfigFile files);

in
{
  imports = [
    ./packages.nix
    ./tmux.nix
    ./zsh.nix
    ./git-worktree-runner.nix
    ./dictionary.nix
    ./pnpm.nix
    ../skills
  ];

  home.username = "eetann";
  # macOSは/Users/eetann、NixOS-WSL(Linux)は/home/eetannを使う
  home.homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/eetann" else "/home/eetann";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # ホームディレクトリ直下のdotfiles
  # 注意: .npmrcは実際のnpm認証トークンを含み、本リポジトリはpublicなためここに含めない
  # (min-release-ageはzsh側のNPM_CONFIG_MIN_RELEASE_AGE環境変数で設定する)
  home.file = mkHomeFiles [
    ".bunfig.toml"
    ".clang-format"
    ".claude/agents"
    ".claude/commands"
    ".claude/settings.json"
    ".latexmkrc"
    ".yarnrc.yml"
    ".zshrc"
  ];

  # ~/.config 配下のファイル
  xdg.configFile = mkConfigFiles [
    "alacritty"
    "ccstatusline"
    "efm-langserver"
    "git"
    "ghostty"
    "i3/config"
    "karabiner/karabiner.json"
    "lazygit/config.yml"
    "niwaterm/bun.lock"
    "niwaterm/layouts.ts"
    "niwaterm/niwaterm.config.ts"
    "niwaterm/package.json"
    "niwaterm/tsconfig.json"
    "nvim"
    "opencode/opencode.jsonc"
    "opencode/instructions"
    "opencode/tui.jsonc"
    "rofi"
    "vde"
    "wezterm"
    "zeno"
  ];

  # NixOS-WSL環境では、niwatermの実体がWindows側アプリのため、
  # WSL側の~/.config/niwatermとは別にWindows側の設定ファイルにも
  # 同じdotfilesへのシンボリックリンクを張る。
  #
  # WSL(Linux)側のln -sでDrvFs(/mnt/c/...)上に作るシンボリックリンクは、
  # Windows専用のreparse point（IO_REPARSE_TAG_LX_SYMLINK）になり、
  # Windowsネイティブアプリ（niwaterm実機のbun.exe）からは実体を読めない
  # （PowerShellから見るとLength:0の壊れたファイルに見える）。そのため
  # cmd.exeのmklinkでWindows形式のシンボリックリンクを作る。
  # 要件: Windows側で開発者モードを有効化しておくこと（設定 > プライバシーと
  # セキュリティ > 開発者向け）。管理者権限なしでのシンボリックリンク作成に必要。
  # PowerShellのNew-Item -ItemType SymbolicLinkは開発者モードの緩和を認識しない
  # 実装上の制限があるため、cmd.exeのmklinkを使う。
  # cmd.exeはフルパスで呼ぶ。`sudo nixos-rebuild switch`はsystemd-run経由の
  # systemdサービスとしてactivationを実行するため、対話シェルと違いWSL
  # interopのWindows PATH（/mnt/c/Windows/System32等）が通っておらず、
  # コマンド名だけだと `cmd.exe: command not found` (exit 127) で失敗する。
  #
  # 引数にダブルクォートを含めるとWSL interop経由でcmd.exeへ渡す際に
  # エスケープが壊れ「ファイル名、ディレクトリ名、またはボリューム ラベルの
  # 構文が間違っています」になるため、クォートなしで呼ぶ（対象パスに
  # スペースを含まない前提）。またactivation実行時のカレントディレクトリが
  # UNCパス（\\wsl.localhost\...）だとcmd.exeが警告を出すため、
  # `env -C /mnt/c` でcmd.exe起動時の作業ディレクトリをCドライブ直下にする。
  home.activation.niwatermWindowsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    windowsNiwatermDir="/mnt/c/Users/eetann/.config/niwaterm"
    cmdExe="/mnt/c/Windows/System32/cmd.exe"
    if [ -d "$windowsNiwatermDir" ] && [ -x "$cmdExe" ]; then
      winTarget='C:\Users\eetann\.config\niwaterm'
      uncSrc='\\wsl.localhost\NixOS\home\eetann\dotfiles\.config\niwaterm'
      for f in layouts.ts niwaterm.config.ts tsconfig.json package.json bun.lock; do
        run env -C /mnt/c "$cmdExe" /c "del $winTarget\\$f 2>nul & mklink $winTarget\\$f $uncSrc\\$f"
      done
    fi
  '';
}
