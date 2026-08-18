import { defaultAppearance, defaultKeybindings, defineConfig } from "@niwaterm/config";
import { layouts } from "./layouts.ts";

export default defineConfig({
  keybindings: {
    ...defaultKeybindings,
  },
  appearance: {
    ...defaultAppearance,
  },
  customView: {
    name: "Notes",
    path: "./notes.html",
  },
  shell: {
    default: "wsl.exe -d NixOS",
  },
  layouts,
});
