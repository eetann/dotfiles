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
      deno
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
      nodejs
      nvd # Nixプロファイルのdiff表示
      opencode
      pinact
      pnpm
      ripgrep
      shellcheck
      shfmt
      tmux
      tree
      tree-sitter # nvim-treesitterのparserビルドに必要 (:TSUpdate)
      uv
      vhs
      yarn-berry # Yarn Berry(4.x)。pkgs.yarnはYarn Classic(1.x)でnpmMinimalAgeGate(.yarnrc.yml)非対応のため使わない。bin名は同じ"yarn"
      yq

      # rclone - macOS向けにサービス含むパッケージを使用
      rclone

      # フォーマッタ
      nixfmt

      # go install で入れていたツール
      mmv
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      macism
      orbstack
      terminal-notifier # macOS固有
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      xsel # クリップボード操作。macOSはpbcopy/pbpasteが標準搭載のため不要
      gcc # tree-sitter buildなどCコンパイラが必要な処理向け。macOSはXcode Command Line Toolsのccを使うため不要
      claude-code # NixOSでは公式インストーラーが動かないためnixpkgs経由で導入。macOSは公式インストーラーで最新版を維持
    ]
    ++ [
      # AI時代のcurl (github:yusukebe/ax)
      inputs.ax.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
