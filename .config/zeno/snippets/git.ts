// deno-lint-ignore no-unversioned-import
import type { Snippet } from "jsr:@yuki-yano/zeno";

// Git系コマンドの展開
export const gitSnippets: Snippet[] = [
  {
    name: "git switch",
    keyword: "gs",
    snippet: "git switch",
  },
  {
    name: "gtr new local",
    keyword: "gnew",
    snippet: "gtr new feature/{{}}",
  },
  {
    name: "gtr new --track remote",
    keyword: "gremote",
    snippet: "gtr new --track remote",
  },
  {
    // `gtr new ブランチ名`の次のコマンドで、`toww ^]Enter`すれば
    // 作ったワークツリーに移動できる
    name: "tmux-open-worktree work-dev",
    keyword: "toww",
    snippet: "tmux-open-worktree --layout work-dev -n",
  },
  {
    // `gtr new ブランチ名`の次のコマンドで、`towm ^]Enter`すれば
    // 作ったワークツリーに移動できる
    name: "tmux-open-worktree my-dev",
    keyword: "towm",
    snippet: "tmux-open-worktree --layout my-dev -n",
  },
  {
    name: "gtr rm --delete-branch",
    keyword: "grm",
    snippet: "gtr rm --delete-branch",
  },
  {
    keyword: "nneww",
    snippet:
      "niwaterm worktree new --open board-switch --layout work-dev --trust feature/",
  },
  {
    keyword: "nnewm",
    snippet:
      "niwaterm worktree new --open board-switch --layout my-dev --trust feature/",
  },
  {
    keyword: "nrm",
    snippet: "niwaterm worktree remove --delete-branch",
  },
  {
    name: "niwaterm worktree open --layout work-dev",
    keyword: "nwow",
    snippet: "niwaterm worktree open --layout work-dev",
  },
];
