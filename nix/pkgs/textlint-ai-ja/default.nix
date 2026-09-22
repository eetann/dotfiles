# textlint + textlint-rule-preset-ai-words-ja をまとめた単体コマンド
#
# AIが書きがちな日本語の語彙（「効く」「踏み込む」「照合」など約50語）を
# 形態素解析で検出する textlint プリセットを、設定ごと固定して配布する。
# https://github.com/p1ass/textlint-rule-preset-ai-words-ja
#
# バージョンを上げるときの手順:
#   1. package.json の依存を書き換える
#   2. cd nix/pkgs/textlint-ai-ja && npm install --package-lock-only --ignore-scripts
#   3. nix run nixpkgs#prefetch-npm-deps -- package-lock.json で出た値を npmDepsHash に書く
{
  lib,
  buildNpmPackage,
  nodejs,
  makeWrapper,
}:
buildNpmPackage {
  pname = "textlint-ai-ja";
  # textlint-rule-preset-ai-words-ja のバージョンに合わせる
  version = "1.2.1";

  src = ./.;

  npmDepsHash = "sha256-Mlzu7AtxdAd3sgchebekSd2W1sjWV927IEnOdnxGGVM=";

  # ビルドスクリプトを持たない依存収集専用のpackage.jsonなのでビルドは不要
  dontNpmBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  # node_modulesと設定ファイルをstoreへ置き、常に同じ設定で走るラッパーを作る。
  # --rules-base-directory を渡すのは、カレントディレクトリではなくstore内の
  # node_modulesからプリセットを解決させるため（任意のディレクトリで動かせる）。
  # この値はモジュールを探すディレクトリそのもの（＝node_modules）を指す必要がある。
  installPhase = ''
    runHook preInstall

    libdir="$out/lib/textlint-ai-ja"
    mkdir -p "$libdir"
    cp -r node_modules "$libdir/"
    cp textlintrc.json "$libdir/textlintrc.json"

    makeWrapper ${nodejs}/bin/node "$out/bin/textlint-ai-ja" \
      --add-flags "$libdir/node_modules/textlint/bin/textlint.js" \
      --add-flags "--config" --add-flags "$libdir/textlintrc.json" \
      --add-flags "--rules-base-directory" --add-flags "$libdir/node_modules"

    runHook postInstall
  '';

  meta = {
    description = "AI語彙検出プリセット入りのtextlint（設定込みラッパー）";
    homepage = "https://github.com/p1ass/textlint-rule-preset-ai-words-ja";
    license = lib.licenses.mit;
    mainProgram = "textlint-ai-ja";
    platforms = lib.platforms.unix;
  };
}
