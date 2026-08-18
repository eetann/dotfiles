import { defaultAppearance, defineConfig } from "@niwaterm/config";
import { layouts } from "./layouts.ts";

// ~/.tmux.confからの移植。デフォルトキーバインドは先に登録済みの状態でこの関数が呼ばれるため、
// 上書き・追加したい分だけniwa.keybindで書く。再現できなかった項目はdocs/planning/roadmap.md参照
export default defineConfig({
  keybindings: (niwa) => {
    // .tmux.conf: set-option -g prefix C-s
    niwa.prefix("ctrl+s");
    // .tmux.conf: set-option -g repeat-time 5000
    niwa.repeatTimeout(5000);

    // .tmux.conf: bind-key | / \ split-window -h -c '#{pane_current_path}'
    // tmuxの-h（左右分割）はniwatermのvertical splitに相当（CLAUDE.md参照）。
    // cwdはniwa.tile.splitがcwd省略時にフォーカス中タイルのcwdを自動継承するため明示不要
    niwa.keybind("|", "split-vertical");
    niwa.keybind("\\", "split-vertical");
    // .tmux.conf: bind-key - split-window -v -c '#{pane_current_path}'
    // デフォルトの"-"(decrease-font-size)を上書きする
    niwa.keybind("-", "split-horizontal");
    // .tmux.conf: bind-key c new-window -c "#{pane_current_path}"
    // デフォルトの"c"(new-tab)がcwd継承込みで同じ動作のため上書き不要

    // .tmux.conf: Vimキーバインドでペイン移動
    // (if-shellでの端チェックはniwa.tile.focus側が境界で何もしないため不要)
    niwa.keybind("h", "focus-left");
    niwa.keybind("j", "focus-down");
    niwa.keybind("k", "focus-up");
    niwa.keybind("l", "focus-right");

    // .tmux.conf: bind-key -r H/J/K/L resize-pane -L/-D/-U/-R
    niwa.keybind("shift+h", "resize-left", { repeat: true });
    niwa.keybind("shift+j", "resize-down", { repeat: true });
    niwa.keybind("shift+k", "resize-up", { repeat: true });
    niwa.keybind("shift+l", "resize-right", { repeat: true });

    // .tmux.conf: bind-key -N "ペインIDの表示" P (xsel/pbcopyでpane_idをコピー)
    niwa.keybind("shift+p", () => {
      const tile = niwa.tile.current();
      if (tile) niwa.clipboard.write(tile.id);
    });

    // .tmux.conf: bind-key g display-popup ... lazygit
    niwa.keybind("g", () => {
      const tile = niwa.tile.current();
      niwa.popup.open({
        width: 95,
        height: 90,
        cwd: tile?.cwd,
        command: "lazygit --use-config-dir=$HOME/.config/lazygit",
      });
    });

    // .tmux.conf: bind-key p (xsel/pbpaste -> paste-buffer)
    // デフォルトの"p"(prev-tab)を上書きする
    niwa.keybind("p", "paste-clipboard");
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
