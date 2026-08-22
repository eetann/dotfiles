# ローカル開発ツールが生成する追加のCA証明書を信頼する設定
# NixOSにはDebian系の update-ca-certificates コマンドがないため、
# security.pki.certificateFiles で宣言的に登録する。
# 文字列で絶対パス(/usr/local/...)を渡すとビルドサンドボックスから見えず失敗するため、
# リポジトリ内にコピーしたファイルをpath literal(相対パス)で参照する
{ ... }:
{
  security.pki.certificateFiles = [
    # portless (ローカルhttps開発プロキシ) が `portless trust` で生成するルートCA。
    # 秘密鍵(~/.portless/配下)は含まない公開鍵のみのファイルのため、
    # publicリポジトリであるこのdotfilesにコミットして問題ない
    # (GitHub上の他のNixOS設定でもmkcert等のローカルCA公開鍵をリポジトリ管理下に
    # 置くのは一般的なプラクティス)。
    # CAがローテーションされた場合は下記コマンドで再コピーしてからrebuildすること
    #   cp /usr/local/share/ca-certificates/portless-ca.crt nix/nixos/portless-ca.crt
    ./portless-ca.crt
  ];
}
