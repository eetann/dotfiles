# CLIパッケージ定義
# Brewfileから移行したパッケージをここで管理
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # CLIツール
    bat
    delta
    direnv
    fd
    ffmpeg
    findutils
    gawk
    gh
    ghq
    gnused # gnu-sed
    go
    gomi
    jq
    lazygit
    luarocks
    mise
    nb
    neovim
    ripgrep
    shellcheck
    shfmt
    terminal-notifier # macOS固有
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
  ];
}
