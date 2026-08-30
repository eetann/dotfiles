import { defaultAppearance, defineConfig } from "@niwaterm/config";
import { keybindings } from "./keybindings.ts";
import { layouts } from "./layouts.ts";

// このconfigはniwatermアプリのプロセス（Mac: ローカル / WSL運用時: Windows側のBun）で
// 評価されるため、process.platformで実行中のOSを判定できる
const isWindows = process.platform === "win32";

export default defineConfig({
  keybindings,
  appearance: {
    ...defaultAppearance,
  },
  customView: {
    name: "Notes",
    path: "./notes.html",
  },
  shell: {
    // WindowsはNixOS(WSL)、Macはdefaultを未指定にしてOS標準の/bin/zsh -ilへフォールバックさせる
    default: isWindows ? "wsl.exe -d NixOS" : undefined,
  },
  layouts,
});
