import type { LayoutsConfig } from "@niwaterm/config";

export const layouts: LayoutsConfig = {
  "my-dev": {
    description: "Editor/Server | AI/editprompt [個人用]",
    layout: {
      kind: "split",
      orientation: "vertical",
      ratio: 0.5,
      first: {
        kind: "split",
        orientation: "horizontal",
        ratio: 0.75,
        first: {
          kind: "tile",
          tabs: [
            {
              name: "other",
              vars: { role: "other" },
              command: `s=$(git status -s); [ -n "$s" ] && echo "$s" || echo '変更なし'; figlet -f larry3d "my-dev"`,
            },
          ],
        },
        second: {
          kind: "tile",
          tabs: [{ name: "server", vars: { role: "server" } }],
        },
      },
      second: {
        kind: "split",
        orientation: "horizontal",
        ratio: 0.8,
        first: {
          kind: "tile",
          tabs: [
            {
              name: "claude",
              ref: "claude",
              vars: { role: "claude" },
              command: "CLAUDE_CONFIG_DIR=~/.claude claude",
            },
          ],
        },
        second: {
          kind: "tile",
          tabs: [
            {
              name: "editprompt",
              vars: { role: "editprompt" },
              command:
                'node "$HOME/ghq/github.com/eetann/editprompt/dist/index.js" open --editor nvim --always-copy --target-pane {{tab:claude}}',
              focus: true,
              closeOnExit: true,
            },
          ],
        },
      },
    },
  },
  "work-dev": {
    description: "Editor/Server | AI/editprompt [仕事用]",
    layout: {
      kind: "split",
      orientation: "vertical",
      ratio: 0.5,
      first: {
        kind: "split",
        orientation: "horizontal",
        ratio: 0.75,
        first: {
          kind: "tile",
          tabs: [
            {
              name: "other",
              vars: { role: "other" },
              command: `s=$(git status -s); [ -n "$s" ] && echo "$s" || echo '変更なし'; figlet -f larry3d "work"`,
            },
          ],
        },
        second: {
          kind: "tile",
          tabs: [{ name: "server", vars: { role: "server" } }],
        },
      },
      second: {
        kind: "split",
        orientation: "horizontal",
        ratio: 0.8,
        first: {
          kind: "tile",
          tabs: [
            {
              name: "claude",
              ref: "claude",
              vars: { role: "claude" },
              command: "CLAUDE_CONFIG_DIR=~/.claude_work CODEX_HOME=~/.codex_work claude",
            },
          ],
        },
        second: {
          kind: "tile",
          tabs: [
            {
              name: "editprompt",
              vars: { role: "editprompt" },
              command:
                'node "$HOME/ghq/github.com/eetann/editprompt/dist/index.js" open --editor nvim --always-copy --target-pane {{tab:claude}}',
              focus: true,
              closeOnExit: true,
            },
          ],
        },
      },
    },
  },
};
