# ローカル開発ツールが生成する追加のCA証明書を信頼する設定
# NixOSにはDebian系の update-ca-certificates コマンドがないため、
# security.pki.certificateFiles で宣言的に登録する。
# 文字列で絶対パス(/usr/local/...)を渡すとビルドサンドボックスから見えず失敗するため、
# リポジトリ内にコピーしたファイルをpath literal(相対パス)で参照する
{ pkgs, ... }:
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

  # portless の `portless trust` は内部で
  # 1. /usr/local/share/ca-certificates/ にCAをコピー
  # 2. update-ca-certificates を実行
  # 3. (WSLの場合) 続けて certutil.exe でWindows側の証明書ストアにも登録
  # 4. trust済みマーカーを書き込む
  # という順で処理するが、NixOSには2のコマンドが無いためENOENTで例外が飛び、
  # 3のWindows側登録と4のマーカー書き込みまで到達できず、
  # 次回起動時にも「未trust」と判定されて毎回同じ処理が繰り返され、
  # 起動のたびに `Failed to trust CA: spawnSync update-ca-certificates ENOENT`
  # が表示され続けていた。
  # 何もせず成功するだけのダミーコマンドを用意して2を通すことで、
  # 3・4まで一度だけ完走させ、以降はtrust処理自体が発生しなくなる。
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "update-ca-certificates" "exit 0")
  ];
}
