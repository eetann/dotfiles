// deno-lint-ignore no-unversioned-import
import type { UserCompletionSource } from "jsr:@yuki-yano/zeno";

export const completions: UserCompletionSource[] = [
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
  // Docker
  {
    name: "docker stop",
    patterns: ["^docker stop $"],
    sourceCommand: "docker ps",
    options: {
      "--header-lines": 1,
      "--tmux": "80%",
      "--prompt": "'Docker Stop> '",
      "--no-select-1": true,
    },
    callback: "awk '{print $1}'",
  },
  {
    name: "docker rm(コンテナ)",
    patterns: ["^docker rm $"],
    sourceCommand: "docker ps -a",
    options: {
      "--header-lines": 1,
      "--tmux": "80%",
      "--multi": true,
      "--prompt": "'Docker Remove Container> '",
      "--no-select-1": true,
    },
    callback: "awk '{print $1}'",
  },
  {
    name: "docker rmi(イメージ)",
    patterns: ["^docker rmi $"],
    sourceCommand: "docker images",
    options: {
      "--header-lines": 1,
      "--tmux": "80%",
      "--multi": true,
      "--prompt": "'Docker Remove Image> '",
      "--no-select-1": true,
    },
    callback: "awk '{print $3}'",
  },
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
