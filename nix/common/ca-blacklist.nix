# nix-darwin / NixOS 共通: 信頼しないルートCA証明書の設定
#
# eMudhraの中間CA証明書の秘密鍵が漏洩した件への回避策
# (https://emudhra.we-have-a-problem.com/)。
# 漏洩した中間CAが連なるルートを、Nixが生成するCAバンドル
# (/etc/ssl/certs/ca-certificates.crt) から除外する。
# NIX_SSL_CERT_FILE を参照するツール(Nixで入れたcurl/git/python等)にだけ効く。
# macOSのKeychainや /etc/ssl/cert.pem (Apple純正のcurl等が参照)には影響しない。
#
# 一時的な回避策のため、nixpkgsのcacert側で対応されたら削除してよい
{
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
  ];
}
