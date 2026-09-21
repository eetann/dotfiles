// deno-lint-ignore no-unversioned-import
import type { UserCompletionSource } from "jsr:@yuki-yano/zeno";

export const gtrCompletions: UserCompletionSource[] = [
  {
    name: "branch names",
    patterns: [
      "^gtr rm --delete-branch $",
      "^gtr rm $",
      "^tmux-open-worktree --layout \\S* -n \\S* $",
    ],
    sourceCommand: "gtr-branch-completion-source",
    callback: "cut -f2",
    options: {
      // gtr-branch-completion-sourceはヘッダ行を出さないため --header-lines は付けない
      // （付けると先頭のブランチが1件ヘッダとして食われて選べなくなる）
      "--tmux": "80%",
      "--prompt": "'Delete branch> '",
      "--no-select-1": true,
      "--delimiter": "$'\\t'",
      "--preview":
        "printf '%s\\n\\n' {1}; git log --color=always --oneline -20 {2} 2>/dev/null",
      "--preview-window": "right,55%,wrap",
    },
  },
];
