// deno-lint-ignore no-unversioned-import
import type { UserCompletionSource } from "jsr:@yuki-yano/zeno";

export const vdeLayoutCompletions: UserCompletionSource[] = [
  {
    name: "vde-layout",
    patterns: ["^vde-layout\\s+"],
    sourceCommand:
      "yq -r '.presets[] | [.name, .description] | @tsv' ~/dotfiles/.config/vde/layout/config.yml",
    options: {
      "--tmux": "80%",
      "--prompt": "'Layout> '",
      "--no-select-1": true,
    },
    callback: "awk -F'\t' '{print $1}'",
  },
];
