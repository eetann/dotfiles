// deno-lint-ignore no-unversioned-import
import type { Snippet } from "jsr:@yuki-yano/zeno";

// 自作スクリプト
export const scriptSnippets: Snippet[] = [
  {
    name: "docker log to TSV",
    keyword: "docker-log-to-tsv",
    snippet: "bun run ~/dotfiles/bin/docker-log-to-tsv.ts",
  },
  {
    name: "nginx access log to TSV",
    keyword: "nginx-access-log-to-tsv",
    snippet: "bun run ~/dotfiles/bin/nginx_to_tsv.ts",
  },
  {
    name: "tmux-first-choose-session",
    keyword: "tf",
    snippet: "tmux-first-choose-session",
  },
  {
    name: "import sjis CSV from Downloads and convert to UTF-8 TSV",
    // 検索で引っ張る前提
    keyword: "sjis_csv_to_utf8_tsv",
    snippet: "sjis_csv_to_utf8_tsv",
  },
  {
    name: "wtman",
    keyword: "wtman",
    snippet: "~/ghq/github.com/eetann/wtman/dist/index.js",
  },
  {
    name: "ASCII padded",
    keyword: "ascii-padded",
    snippet: 'bun run ~/dotfiles/bin/ascii-padded.ts -d "{{cursor}}"',
  },
];
