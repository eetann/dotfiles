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
            },
          ],
        },
        second: {
          kind: "tile",
          // editpromptはniwaterm対応済み（--mux niwatermはNIWATERM_TAB_IDから自動判定）。
          // ただしvde-layoutの{{pane_id:claude}}のようなプリセット定義時点でのpane-id参照は
          // niwatermに無い（tabIdは適用のたびに再採番されるため）。代わりに`niwaterm tab var find`で
          // 実行時にroleからclaudeタブのtabIdを検索する（詳細: docs/guide/config.md「レイアウト」節）
          tabs: [
            {
              name: "editprompt",
              vars: { role: "editprompt" },
              // zshは変数展開の結果に単語分割もチルダ展開もかけないため、コマンド行全体を
              // 変数へ入れて`$editprompt`で起動する書き方は動かない（コマンド名まるごと1語として
              // 扱われ`no such file or directory`になる）。関数にまとめ、パスは$HOMEで書く
              command:
                'ep() { node "$HOME/ghq/github.com/eetann/editprompt/dist/index.js" open --editor nvim --always-copy --log-file /tmp/editprompt.log "$@"; }; ' +
                'target=$(niwaterm tab var find role claude | head -n1); ' +
                '[ -n "$target" ] && ep --target-pane "$target" || ep',
              focus: true,
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
              // zshは変数展開の結果に単語分割もチルダ展開もかけないため、コマンド行全体を
              // 変数へ入れて`$editprompt`で起動する書き方は動かない（コマンド名まるごと1語として
              // 扱われ`no such file or directory`になる）。関数にまとめ、パスは$HOMEで書く
              command:
                'ep() { node "$HOME/ghq/github.com/eetann/editprompt/dist/index.js" open --editor nvim --always-copy --log-file /tmp/editprompt.log "$@"; }; ' +
                'target=$(niwaterm tab var find role claude | head -n1); ' +
                '[ -n "$target" ] && ep --target-pane "$target" || ep',
              focus: true,
            },
          ],
        },
      },
    },
  },
};
