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
{ config, pkgs, lib, ... }:

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
    "niwaterm/niwaterm.config.ts"
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
  # 同じdotfilesへのシンボリックリンクを張る
  home.activation.niwatermWindowsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    windowsNiwatermDir="/mnt/c/Users/eetann/.config/niwaterm"
    if [ -d "$windowsNiwatermDir" ]; then
      run ln -sf "${dotfilesDir}/.config/niwaterm/niwaterm.config.ts" "$windowsNiwatermDir/niwaterm.config.ts"
      run ln -sf "${dotfilesDir}/.config/niwaterm/tsconfig.json" "$windowsNiwatermDir/tsconfig.json"
    fi
  '';
}
