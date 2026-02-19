#!/usr/bin/env -S deno run
// deno-lint-ignore no-unversioned-import
import { defineConfig } from "jsr:@yuki-yano/zeno";
import { commandSnippets } from "./snippets/commands.ts";
import { contextSnippets } from "./snippets/context.ts";
import { scriptSnippets } from "./snippets/scripts.ts";
import { killCompletions } from "./completions/kill.ts";
import { dockerCompletions } from "./completions/docker.ts";
import { runCompletions } from "./completions/run.ts";
import { gtrCompletions } from "./completions/gtr.ts";

export default defineConfig((_context) => ({
  snippets: [...commandSnippets, ...contextSnippets, ...scriptSnippets],
  completions: [
    ...killCompletions,
    ...dockerCompletions,
    ...runCompletions,
    ...gtrCompletions,
  ],
}));
