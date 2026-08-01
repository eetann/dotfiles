# CLIパッケージ定義
# Brewfileから移行したパッケージをここで管理
{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      # CLIツール
      awscli2
      ssm-session-manager-plugin
      bat
      bun
      delta
      direnv
      dust
      fd
      ffmpeg
      figlet
      findutils
      fzf
      gawk
      gh
      ghq
      git # NixOS側にはシステムgitがないため明示的に追加
      git-lfs
      gnused # gnu-sed
      go
      gomi
      jq
      lazygit
      luarocks
      mise
      nb
      neovim
      nvd # Nixプロファイルのdiff表示
      opencode
      pinact
      ripgrep
      shellcheck
      shfmt
      tmux
      tree
      vhs
      yq

      # rclone - macOS向けにサービス含むパッケージを使用
      rclone

      # フォーマッタ
      nixfmt

      # go install で入れていたツール
      mmv
    ]
    ++ lib.optionals pkgs.stdenv.isDarwin [
      macism
      orbstack
      terminal-notifier # macOS固有
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      xsel # クリップボード操作。macOSはpbcopy/pbpasteが標準搭載のため不要
    ]
    ++ [
      # AI時代のcurl (github:yusukebe/ax)
      inputs.ax.packages.${pkgs.system}.default
    ];
}
