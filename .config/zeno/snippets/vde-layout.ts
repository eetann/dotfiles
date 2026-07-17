// deno-lint-ignore no-unversioned-import
import type { Snippet } from "jsr:@yuki-yano/zeno";

export const vdeLayoutSnippets: Snippet[] = [
  {
    name: "create window for development",
    keyword: "v:m",
    snippet: "vde-layout my-dev",
  },
  {
    name: "create & rename window for development",
    keyword: "v:mm",
    snippet: 'vde-layout my-dev && tmux rename-window "{{}}"',
  },
  {
    name: "create window for work development",
    keyword: "v:w",
    snippet: "vde-layout work-dev",
  },
  {
    name: "create & rename window for work development",
    keyword: "v:ww",
    snippet: 'vde-layout work-dev && tmux rename-window "{{}}"',
  },
  {
    name: "close panes safety",
    keyword: "v:e",
    snippet: "vde-layout empty",
  },
  {
    name: "close window safety",
    keyword: "v:q",
    snippet: "vde-layout empty && exit",
  },
  {
    name: "vde-layout",
    keyword: "v:",
    snippet: "vde-layout",
  },
];
