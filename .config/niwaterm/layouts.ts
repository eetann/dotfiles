import type { LayoutsConfig } from "@niwaterm/config";

export const layouts: LayoutsConfig = {
  "my-dev": {
    description: "Editor/Server | AI/editprompt [個人用]",
    layout: {
      kind: "split",
      // vde-layoutのtype: horizontal（左右）はniwatermではvertical
      orientation: "vertical",
      ratio: 0.5,
      first: {
        kind: "split",
        // vde-layoutのtype: vertical（上下）はniwatermではhorizontal
        orientation: "horizontal",
        // vde-layoutの ratio: [1, "12c"] 相当。niwatermは固定行数指定が無いため比率で近似
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
        ratio: 0.8, // vde-layoutの ratio: [1, "10c"] 相当（近似）
        first: {
          kind: "tile",
          tabs: [
            {
              name: "claude",
              vars: { role: "claude" },
              command: "CLAUDE_CONFIG_DIR=~/.claude claude",
              // editprompt側のfocusを付け替え。理由は下のeditpromptタブのコメント参照
              focus: true,
            },
          ],
        },
        second: {
          kind: "tile",
          // editpromptは{{pane_id:claude}}のようなpane参照でtmuxのpaneへ文字列を送る作りのため、
          // pane-id参照テンプレートを持たないniwatermではそのままでは動かせない。
          // ひとまず空タブとして確保するのみ（起動は手動）
          tabs: [{ name: "editprompt", vars: { role: "editprompt" } }],
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
              vars: { role: "claude" },
              command: "CLAUDE_CONFIG_DIR=~/.claude_work CODEX_HOME=~/.codex_work claude",
              focus: true,
            },
          ],
        },
        second: {
          kind: "tile",
          tabs: [{ name: "editprompt", vars: { role: "editprompt" } }],
        },
      },
    },
  },
};
