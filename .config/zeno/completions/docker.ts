// deno-lint-ignore no-unversioned-import
import type { UserCompletionSource } from "jsr:@yuki-yano/zeno";

export const dockerCompletions: UserCompletionSource[] = [
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
];
