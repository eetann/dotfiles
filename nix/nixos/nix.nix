# Nix自体の設定（nix/darwin/nix.nixのNixOS向け移植）
{ ... }:
{
  # Nixストアの最適化（ハードリンクで重複排除）
  nix.optimise.automatic = true;

  # ガベージコレクション（古い世代の自動削除）
  nix.gc = {
    automatic = true;
    dates = "09:00"; # 毎日9:00に実行（systemd calendar形式）
    options = "--delete-older-than 10d"; # 10日以上前を削除
  };

  # 実験的機能の有効化（flakesを使うために必要）
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # ビルドの並列数
  nix.settings.max-jobs = 8;
}
