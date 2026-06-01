// #!/usr/bin/env -S deno run
// karabiner-elements の complex_modifications を TypeScript で管理する。
//
// 実行方法:
//   deno run --allow-env --allow-read --allow-write .config/karabiner/karabiner.config.ts
//
// 同じディレクトリの karabiner.json を読み込み、complex_modifications だけを
// 差し替えて書き戻す。virtual_hid_keyboard などのフィールドは保持される。
// Nix側でこの karabiner.json を ~/.config/karabiner/karabiner.json へ
// シンボリックリンクする。

import {
  ifKeyboardType,
  map,
  rule,
  writeToProfile,
} from "https://deno.land/x/karabinerts@1.37.0/deno.ts";

const karabinerJsonPath = `${import.meta.dirname}/karabiner.json`;

writeToProfile(
  {
    name: "Default profile",
    karabinerJsonPath,
  },
  [
    rule("Ctrl+[を押したときに、英数キーも送信する（vim用）").manipulators([
      // ANSI/ISOキーボード: Ctrl+[ → Ctrl+[ + 英数キー
      map("[", "control")
        .to("[", "control")
        .to("japanese_eisuu")
        .condition(ifKeyboardType(["ansi", "iso"])),
      // JISキーボード: Ctrl+] → Ctrl+] + 英数キー
      map("]", "control")
        .to("]", "control")
        .to("japanese_eisuu")
        .condition(ifKeyboardType("jis")),
    ]),

    rule("escキーを押したときに、英数キーも送信する（vim用）").manipulators([
      map("escape").to("escape").to("japanese_eisuu"),
    ]),
  ],
);
