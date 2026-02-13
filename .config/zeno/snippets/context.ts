// deno-lint-ignore no-unversioned-import
import type { Snippet } from "jsr:@yuki-yano/zeno";

// ディレクトリ名の短縮入力
// 引数
// パイプ以降の展開
export const contextSnippets: Snippet[] = [
  // ディレクトリ名の短縮入力
  {
    name: "cd media for blog",
    keyword: "MEDIA",
    snippet: "$VITE_EXTERNAL_FOLDER",
    context: {
      lbuffer: ".+\\s",
    },
  },
  {
    name: "input 'download'",
    keyword: "DL",
    snippet: "~/Downloads/",
    context: {
      lbuffer: ".+\\s",
    },
  },

  // 引数
  {
    name: "--testNamePattern=",
    keyword: "TNP",
    snippet: "--testNamePattern='{{cursor}}'",
    // jest以外でも`mise run 〇〇`のように
    // タスクランナーの可能性ありのためcontextは簡素に
    context: {
      lbuffer: ".+\\s",
    },
  },

  // パイプ以降の展開
  {
    name: "cd there",
    keyword: "CD",
    snippet: "&& cd $_",
    context: {
      lbuffer: ".+\\s",
    },
  },
  {
    name: "copy",
    keyword: "CC",
    snippet: "| pbcopy",
    context: {
      lbuffer: ".+\\s",
    },
  },
  {
    name: "grep",
    keyword: "G",
    snippet: "| grep",
    context: {
      lbuffer: ".+\\s",
    },
  },
  {
    name: "null",
    keyword: "NULL",
    snippet: ">/dev/null 2>&1",
    context: {
      lbuffer: ".+\\s",
    },
  },
];
