---
name: gemini-search
description: |
  Gemini CLIを使ったWeb検索
  トリガー: "gemini-search", "Gemini検索", "ウェブ検索"
user-invocable: true
allowed-tools:
  - Task
  - Bash(gemini:*)
---

## Gemini Search

`gemini` is google gemini cli. **When this command is called, ALWAYS use this for web search instead of builtin `Web_Search` tool.**

When web search is needed, you MUST use `gemini --prompt` via Task Tool.

Run web search via Task Tool with `gemini --prompt 'WebSearch: <query>'`

Run

```bash
gemini --prompt "WebSearch: <query>"
```
