# CLAUDE.md

## リポジトリ概要

eetannのdotfilesリポジトリ。macOS（Apple Silicon）の開発環境を **Nix Flakes + nix-darwin + home-manager** で宣言的に管理している。

## アーキテクチャ

```
flake.nix                    ← エントリポイント
├── nix/darwin/              ← nix-darwin（macOSシステム設定）
│   ├── default.nix          ← ホスト名、PATH、home-manager統合
│   ├── nix.nix              ← Nix自体の設定（GC、最適化）
│   └── system.nix           ← macOS defaults（Dock、Finder、キーボード等）
└── nix/home/                ← home-manager（dotfiles管理）
    ├── default.nix          ← シンボリックリンク管理（mkOutOfStoreSymlink）
    ├── packages.nix         ← CLIパッケージ一覧
    └── tmux.nix             ← tmuxプラグイン管理
```

### シンボリックリンクの仕組み

`mkOutOfStoreSymlink` を使い、設定ファイルの変更が **即座に反映** される（`home-manager switch` 不要）。リンクは3段階:

```
~/.config/nvim → /nix/store/.../home-manager-files/.config/nvim → /nix/store/.../hm_nvim → ~/dotfiles/.config/nvim
```

## ディレクトリ構成

| パス | 内容 |
|------|------|
| `.config/nvim/` | Neovim設定（lazy.nvimベース） |
| `.config/git/` | Git設定 |
| `.config/wezterm/` | WezTerm設定 |
| `.config/alacritty/` | Alacritty設定 |
| `.config/efm-langserver/` | EFM LSP設定 |
| `.config/lazygit/` | lazygit設定 |
| `zsh/` | Zsh設定（番号付きファイルで読み込み順を制御） |
| `bin/` | カスタムスクリプト群 |
| `etc/init/` | セットアップスクリプト |
| `nix/` | Nix設定モジュール |

## 主要コマンド

```bash
# macOSシステム設定 + dotfiles を一括適用。sudoが必要なのでユーザーに実行してもらう
sudo darwin-rebuild switch --flake .

# dotfilesのみ適用
make deploy  # = home-manager switch --flake ~/dotfiles

# セットアップスクリプト実行
make init
```

## 新しい設定ファイルの追加方法

### ホームディレクトリ直下のファイル

`nix/home/default.nix` の `mkHomeFiles` リストにファイル名を追加:

```nix
home.file = mkHomeFiles [
  ".zshrc"
  ".新しいファイル"  # ← 追加
];
```

### ~/.config 配下のファイル

`nix/home/default.nix` の `mkConfigFiles` リストに追加:

```nix
xdg.configFile = mkConfigFiles [
  "nvim"
  "新しいディレクトリ"  # ← 追加
];
```

### CLIパッケージの追加

`nix/home/packages.nix` の `home.packages` に追加。

## コーディング規約

- **Nixファイル**: `nixfmt` で自動フォーマット（PostToolUseフックで実行される）
- **コメント**: 日本語で書く
- **シェルスクリプト**: `shellcheck` / `shfmt` でチェック
- **コミットメッセージ**: `feat(スコープ):` / `fix(スコープ):` / `refactor:` 等のConventional Commits形式。日本語で記述

## 注意事項

- Nixファイル編集後、パッケージやモジュール構成の変更は `darwin-rebuild switch` が必要
- `.config/` 配下の設定変更は `mkOutOfStoreSymlink` により即時反映（rebuildは不要）
- tmuxプラグインはtpmではなくhome-managerで管理（`nix/home/tmux.nix`）
- macOSシステム設定の変更後、Finderの反映には `killall Finder` が必要な場合がある
