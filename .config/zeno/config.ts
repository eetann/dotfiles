#!/usr/bin/env -S deno run
// deno-lint-ignore no-unversioned-import
import { defineConfig } from "jsr:@yuki-yano/zeno";
import { commandSnippets } from "./snippets/commands.ts";
import { contextSnippets } from "./snippets/context.ts";
import { scriptSnippets } from "./snippets/scripts.ts";
import { completions } from "./completions.ts";

export default defineConfig((_context) => ({
  snippets: [...commandSnippets, ...contextSnippets, ...scriptSnippets],
  completions,
}));
