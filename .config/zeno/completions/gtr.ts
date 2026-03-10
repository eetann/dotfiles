// deno-lint-ignore no-unversioned-import
import type { UserCompletionSource } from "jsr:@yuki-yano/zeno";

export const gtrCompletions: UserCompletionSource[] = [
  {
    name: "gtr rm --delete-branch",
    patterns: ["^gtr rm --delete-branch $", "^gtr rm $"],
    sourceCommand: "git gtr list --porcelain | awk '!/detached/{print $2}'",
    options: {
      "--header-lines": 1,
      "--tmux": "80%",
      "--prompt": "'Delete branch> '",
      "--no-select-1": true,
      "--preview": "git log --color=always --oneline -20 {} 2>/dev/null",
      "--preview-window": "right,55%,wrap",
    },
  },
];
