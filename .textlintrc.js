module.exports = {
  plugins: {
    "@textlint/markdown": {
      extensions: [".mdx"],
    },
  },
  filters: {
    // NEED: textlint-filter-rule-comments
    // <!-- textlint-disable -->
    // <!-- textlint-enable -->
    comments: true,
    // NEED: textlint-filter-rule-allowlist
    allowlist: {
      allow: [
        "ってるよ。",
        "分報",
        "おすすめ",
        "参考",
        "アイスブレイク",
        // mdx用 {/* textlint-disable */} ～ {/* textlint-enable */}を無視
        "/\\{/\\* textlint-disable \\*/\\}[^]*?\\{/\\* textlint-enable \\*/\\}/m",
        // mdx用 {/* hoge */}を無視
        "/\\{/\\*[^]*?\\*/\\}/",
        "/<Icon.*/",
      ],
    },
  },
  rules: {
    // NEED: textlint-rule-preset-ja-technical-writing
    "preset-ja-technical-writing": {
      "sentence-length": {
        skipPatterns: [
          // mdx用 {/* hoge */}を無視
          "/\\{/\\*[^]*?\\*/\\}/m",
          "/import.*/",
        ],
      },
      "max-kanji-continuous-len": {
        allow: [
          "高解像度画像検索機",
          "自動背景除去",
          "人類補完計画",
          "倍精度浮動小数点数",
          "自己署名証明書",
          "証明書署名要求",
          "第三者配信広告",
          "広告配信事業者",
          "引用許可範囲",
        ],
      },
      "ja-no-successive-word": {
        // オノマトペを許可する
        // 制限: オノマトペを判定する方法がないため、同じカタカナの語が連続したものをオノマトペとして扱う
        allowOnomatopee: true,
        // 許可する単語
        // RegExp-like Stringを使用可能
        allow: ["ほど", "一つ", "〇", "…", "など", "ある"],
      },
      "ja-no-mixed-period": {
        allowEmojiAtEnd: true,
        // 句点文字として許可する文字列の配列
        allowPeriodMarks: ["w", "]", "："],
      },
      "ja-no-weak-phrase": false,
      "no-exclamation-question-mark": false,
      "no-doubled-joshi": {
        allow: ["ても", "も", "に"],
      },
    },
    "preset-jtf-style": {
      "4.3.7.山かっこ<>": false,
    },
    prh: {
      rulePaths: ["~/dotfiles/etc/textlint/prh.yaml"],
    },
  },
};
