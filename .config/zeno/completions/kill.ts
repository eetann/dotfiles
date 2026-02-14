// deno-lint-ignore no-unversioned-import
import type { UserCompletionSource } from "jsr:@yuki-yano/zeno";

export const killCompletions: UserCompletionSource[] = [
  {
    name: "kill signal",
    patterns: ["^kill -s $"],
    sourceCommand: "kill -l | tr ' ' '\\n'",
    options: {
      "--prompt": "'Kill Signal> '",
      "--tmux": "80%",
      "--no-select-1": true,
    },
  },
  {
    name: "kill pid",
    patterns: ["^kill( .*)? $"],
    excludePatterns: [" -[lns] $"],
    sourceCommand: "LANG=C ps -ef",
    options: {
      "--header-lines": 1,
      "--multi": true,
      "--prompt": "'Kill Process> '",
      "--tmux": "80%",
      "--no-select-1": true,
    },
    callback: "awk '{print $2}'",
  },
];
