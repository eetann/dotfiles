import { defaultAppearance, defineConfig } from "@niwaterm/config";
import { layouts } from "./layouts.ts";

// .tmux.conf: set-option -g @editprompt-cmd "node ~/ghq/github.com/eetann/editprompt/dist/index.js"
// niwatermアプリ本体は`mise run start`でWSLからWindows実機側へ同期して起動される
// （実プロセスはWindows側のBunランタイム）。キーバインドの関数ハンドラもそのプロセスで
// 実行されるため、node:osのhomedir()はWindows側のユーザープロファイルを返してしまい
// WSL側の/home/eetannとは一致しない。editprompt本体はWSL側にしか実体が無いため、
// パスはWSL側の絶対パスを直書きする
const EDITPROMPT_ENTRY = "/home/eetann/ghq/github.com/eetann/editprompt/dist/index.js";
const EDITPROMPT_LOG_FILE = "/tmp/editprompt.log";

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
    niwa.keybind("q", "restart-tab");
    niwa.keybind("r", "reload-config");

    // .tmux.conf: bind-key -n M-q run-shell '
    //   #{@editprompt-cmd} resume --target-pane #{pane_id} || \
    //   tmux-focus-pane editprompt || \
    //     tmux split-window -v -l 10 -c "#{pane_current_path}" \
    //     "tmux set-option -p -t \$TMUX_PANE @role editprompt \
    //       && #{@editprompt-cmd} open --editor nvim --target-pane #{pane_id} --always-copy" \
    // '
    // editprompt側がniwatermのmuxに対応済み（tab varで状態管理、tab showでフォーカス移動）なので、
    // resumeが成功すればそれだけで完結する。失敗時のみ新規にeditorタブを割ってopenする。
    // tmuxの"-l 10"（固定10行）に相当するオプションがniwa.tile.splitに無いためratioで近似する。
    // tmux-focus-pane（@role頼りの汎用フォールバック探索）に相当する処理は未移植（コピーモード関連と合わせて一旦スコープ外）。
    // resumeの成否判定はniwa.shell.run（tmuxのrun-shell相当）に任せる。現在のshellプロファイル
    // （wsl.exe -d NixOS）に従ってログイン・インタラクティブシェル経由で実行してくれるため、
    // WSLENVの手動追記やwsl.exeの直接呼び出しは不要
    niwa.keybind(
      "alt+q",
      async () => {
        const tab = niwa.tab.current();
        if (!tab) return;

        const resume = await niwa.shell.run(
          `node ${EDITPROMPT_ENTRY} resume --target-pane ${tab.tabId} --log-file ${EDITPROMPT_LOG_FILE}`,
          { env: { NIWATERM_TAB_ID: tab.tabId } },
        );
        if (resume.exitCode === 0) return;

        const tile = niwa.tile.current();
        const split = niwa.tile.split({ orientation: "horizontal", ratio: 0.8, cwd: tile?.cwd });
        if (!split) return;
        niwa.tab.respawn(split.tabId, {
          command: `node ${EDITPROMPT_ENTRY} open --editor nvim --target-pane ${tab.tabId} --always-copy --log-file ${EDITPROMPT_LOG_FILE}`,
        });
      },
      { noPrefix: true },
    );

    // .tmux.conf: bind-key -n M-o run-shell '
    //     tmux split-window -v -l 10 -c "#{pane_current_path}" \
    //     "tmux set-option -p -t \$TMUX_PANE @role editprompt \
    //       && #{@editprompt-cmd} open --editor nvim --target-pane #{pane_id} --always-copy" \
    // '
    // resumeを試さず常に新規editorタブを割る版（M-qのfallback分岐と同じ処理）
    niwa.keybind(
      "alt+o",
      () => {
        const tab = niwa.tab.current();
        if (!tab) return;

        const tile = niwa.tile.current();
        const split = niwa.tile.split({ orientation: "horizontal", ratio: 0.8, cwd: tile?.cwd });
        if (!split) return;
        niwa.tab.respawn(split.tabId, {
          command: `node ${EDITPROMPT_ENTRY} open --editor nvim --target-pane ${tab.tabId} --always-copy --log-file ${EDITPROMPT_LOG_FILE}`,
        });
      },
      { noPrefix: true },
    );
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
