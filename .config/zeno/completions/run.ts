// deno-lint-ignore no-unversioned-import
import type { UserCompletionSource } from "jsr:@yuki-yano/zeno";

export const runCompletions: UserCompletionSource[] = [
  // zsh/myfunction/mise.zsh から呼び出す
  {
    name: "mise run",
    patterns: ["^mise run $"],
    sourceCommand: "mise tasks --no-header",
    options: {
      "--no-select-1": true,
    },
    callback: "awk '{print $1}'",
  },
  // zsh/myfunction/npm_scripts.zsh から呼び出す
  {
    name: "npm scripts",
    patterns: ["^(npm|pnpm|bun) run $"],
    sourceCommand: `jq -r '.scripts | to_entries | .[] | .key + " = " + .value' package.json`,
    options: {
      "--no-select-1": true,
    },
    callback: "awk '{print $1}'",
  },
];
