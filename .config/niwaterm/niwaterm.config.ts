import { defaultAppearance, defineConfig } from "@niwaterm/config";
import { keybindings } from "./keybindings.ts";
import { layouts } from "./layouts.ts";
import { worktreeHandlers } from "./custom-views/worktrees-handlers.ts";

// このconfigはniwatermアプリのプロセス（Mac: ローカル / WSL運用時: Windows側のBun）で
// 評価されるため、process.platformで実行中のOSを判定できる
const isWindows = process.platform === "win32";

export default defineConfig({
  keybindings,
  appearance: {
    ...defaultAppearance,
    // 夕方の海。水平線の残照（上）から夕凪の深い藍（下）へ落としていく
    background: "#0d2635",
    backgroundOpacity: 0.93,
    foreground: "#d6e2e7",
    backgroundImage: [
      "linear-gradient(to bottom,",
      "rgba(255, 158, 102, 0.18) 0%,",
      "rgba(226, 118, 128, 0.12) 14%,",
      "rgba(104, 92, 148, 0.10) 32%,",
      "rgba(13, 38, 53, 0) 62%)",
    ].join(" "),
    ansiColors: [
      "#2c4356", // 0 黒: 夕闇の海面
      "#e8836f", // 1 赤: 陽の名残
      "#7fc7a6", // 2 緑: 浅瀬
      "#f0c070", // 3 黄: 水面の照り返し
      "#6fa8dc", // 4 青: 沖
      "#b98cc4", // 5 マゼンタ: 薄暮の雲
      "#6fc6c9", // 6 シアン: 波間
      "#c3d3da", // 7 白: 白波
      "#3e5a70", // 8-15 bright: 水平線寄りの明るい側
      "#f59a84",
      "#97d9ba",
      "#ffd489",
      "#8cbeeb",
      "#cfa2d8",
      "#8adadd",
      "#e2ecf0",
    ],
    titleBar: "hidden",
  },
  board: {
    // 並行して動かしているワークツリーが今どの段階かをサイドバーのバッジで出す。
    // 色はappearance.ansiColorsと同じ海テーマの配色から選ぶ
    statuses: [
      { id: "plan", label: "プラン作成", color: "#6fa8dc" },
      { id: "plan-review", label: "プランレビュー", color: "#f0c070" },
      { id: "implement", label: "実装", color: "#7fc7a6" },
      { id: "ai-review", label: "AIレビュー", color: "#6fc6c9" },
      { id: "human-review", label: "人間レビュー", color: "#b98cc4" },
      { id: "pr-review", label: "PR自動レビュー", color: "#f59a84" },
    ],
  },
  mouse: {
    copyOnSelect: false,
    // 選択範囲を右クリックした時のメニュー項目
    selectionMenu: (selection, niwa) => {
      const path = selection.text.trim();
      return [
        {
          label: "開く",
          run: () =>
            niwa.shell.run(isWindows ? `explorer.exe '${path}'` : `open '${path}'`, {
              cwd: selection.cwd,
            }),
        },
      ];
    },
  },
  shell: {
    // WindowsはNixOS(WSL)、Macはdefaultを未指定にしてOS標準の/bin/zsh -ilへフォールバックさせる
    default: isWindows ? "wsl.exe -d NixOS" : undefined,
  },
  layouts,
});
