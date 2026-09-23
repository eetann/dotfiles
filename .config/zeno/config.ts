#!/usr/bin/env -S deno run
// deno-lint-ignore no-unversioned-import
import { defineConfig } from "jsr:@yuki-yano/zeno";
import { dockerCompletions } from "./completions/docker.ts";
import { gitCompletions } from "./completions/git.ts";
import { killCompletions } from "./completions/kill.ts";
import { runCompletions } from "./completions/run.ts";
import { vdeLayoutCompletions } from "./completions/vde-layout.ts";
import { commandSnippets } from "./snippets/commands.ts";
import { contextSnippets } from "./snippets/context.ts";
import { gitSnippets } from "./snippets/git.ts";
import { scriptSnippets } from "./snippets/scripts.ts";
import { vdeLayoutSnippets } from "./snippets/vde-layout.ts";

export default defineConfig((_context) => ({
  snippets: [
    ...commandSnippets,
    ...contextSnippets,
    ...gitSnippets,
    ...scriptSnippets,
    ...vdeLayoutSnippets,
  ],
  completions: [
    ...killCompletions,
    ...dockerCompletions,
    ...runCompletions,
    ...gitCompletions,
    ...vdeLayoutCompletions,
  ],
}));
