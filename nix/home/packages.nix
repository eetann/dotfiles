# CLIパッケージ定義
# Brewfileから移行したパッケージをここで管理
{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  # nixpkgs stable/unstableがbun 1.4系に追従するまでの暫定固定。
  # 追従したら通常の pkgs.bun に戻すこと
  bun_1_4_0 = pkgs.bun.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "1.4.0";
      __intentionallyOverridingVersion = true;
      passthru = previousAttrs.passthru // {
        sources = {
          aarch64-darwin = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-darwin-aarch64.zip";
            hash = "sha256-xmnpf2Fk4cluBwF0jbmN+ndJKQjL2DlMdVcTSnNd44E=";
          };
          aarch64-linux = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-aarch64.zip";
            hash = "sha256-SxozLuhhmD65O8/m93D/+U4+MbLDiL2uo8jtNeWO7Q4=";
          };
          x86_64-linux = pkgs.fetchurl {
            url = "https://github.com/oven-sh/bun/releases/download/bun-v${finalAttrs.version}/bun-linux-x64-baseline.zip";
            hash = "sha256-GE+0WV8NQBohfPfHjBvEMLqDMU2reouUgFurv3+nCX8=";
          };
        };
      };
    }
  );
in
{
  home.packages =
    with pkgs;
    [
      # CLIツール
      awscli2
      ssm-session-manager-plugin
      bat
      bun_1_4_0
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
      openssl # portlessがTLS証明書生成に使用。macOSは標準搭載のため不要
    ]
    ++ [
      # AI時代のcurl (github:yusukebe/ax)
      inputs.ax.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
