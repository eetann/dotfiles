#!/usr/bin/env -S deno run
// deno-lint-ignore no-unversioned-import
import { defineConfig } from "jsr:@yuki-yano/zeno";
import { dockerCompletions } from "./completions/docker.ts";
import { gtrCompletions } from "./completions/gtr.ts";
import { killCompletions } from "./completions/kill.ts";
import { runCompletions } from "./completions/run.ts";
import { vdeLayoutCompletions } from "./completions/vde-layout.ts";
import { commandSnippets } from "./snippets/commands.ts";
import { contextSnippets } from "./snippets/context.ts";
import { scriptSnippets } from "./snippets/scripts.ts";
import { vdeLayoutSnippets } from "./snippets/vde-layout.ts";

export default defineConfig((_context) => ({
  snippets: [
    ...commandSnippets,
    ...contextSnippets,
    ...scriptSnippets,
    ...vdeLayoutSnippets,
  ],
  completions: [
    ...killCompletions,
    ...dockerCompletions,
    ...runCompletions,
    ...gtrCompletions,
    ...vdeLayoutCompletions,
  ],
}));
