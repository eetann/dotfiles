import { homedir } from "node:os";
import type { KeybindingsFn } from "@niwaterm/config";

// .tmux.conf: set-option -g @editprompt-cmd "node ~/ghq/github.com/eetann/editprompt/dist/index.js"
// Windowsのniwatermアプリ本体は`mise run start`でWSLからWindows実機側へ同期して起動される
// （実プロセスはWindows側のBunランタイム）。キーバインドの関数ハンドラもそのプロセスで
// 実行されるため、node:osのhomedir()はWindows側のユーザープロファイルを返してしまい
// WSL側の/home/eetannとは一致しない。editprompt本体はWSL側にしか実体が無いため、
// Windowsのときだけパスを直書きする
const EDITPROMPT_ENTRY =
  process.platform === "win32"
    ? "/home/eetann/ghq/github.com/eetann/editprompt/dist/index.js"
    : `${homedir()}/ghq/github.com/eetann/editprompt/dist/index.js`;
// const EDITPROMPT_LOG_FILE = "/tmp/editprompt.log";

export const keybindings: KeybindingsFn = (niwa) => {
  niwa.prefix("ctrl+s");
  niwa.repeatTimeout(5000);

  niwa.keybind("|", "split-vertical");
  niwa.keybind("\\", "split-vertical");
  niwa.keybind("-", "split-horizontal");
  niwa.keybind(
    "c",
    () => {
      niwa.board.create(niwa.tile.current()?.cwd);
    },
    { description: "現在のディレクトリで新規Boardを作る" },
  );

  niwa.keybind("h", "focus-left");
  niwa.keybind("j", "focus-down");
  niwa.keybind("k", "focus-up");
  niwa.keybind("l", "focus-right");

  niwa.keybind("shift+h", "resize-left", { repeat: true });
  niwa.keybind("shift+j", "resize-up", { repeat: true });
  niwa.keybind("shift+k", "resize-down", { repeat: true });
  niwa.keybind("shift+l", "resize-right", { repeat: true });

  niwa.keybind(
    "shift+p",
    () => {
      const tile = niwa.tile.current();
      if (tile) niwa.clipboard.write(tile.id);
    },
    { description: "タイルIDをクリップボードへコピーする" },
  );

  niwa.keybind(
    "w",
    async () => {
      const tab = niwa.tab.current();
      const tile = niwa.tile.current();
      // ghq-selectは「1行目: 押されたキー（fzfの--expect形式。Enterなら空行）」
      // 「2行目: 絶対パス」を標準出力へ返す
      const output = await niwa.popup.run("ghq-select", {
        width: 80,
        height: 80,
        cwd: tile?.cwd,
      });
      // null（既にpopupが開いている）・空文字列（fzfをキャンセル）
      if (!output) return;
      const [key, targetPath] = output.split("\n");
      if (!targetPath) return;
      if (key === "ctrl-o") {
        // .tmux.confの@ghq_cd経由のsend-keys相当（呼び出し元タブでcdする）
        if (tab) niwa.tab.sendKeys(tab.tabId, `cd "${targetPath}"`, "Enter");
        return;
      }
      // Enter: tmuxのnew-window相当（niwatermではBoardがtmuxのWindowに対応する）
      niwa.board.create(targetPath);
    },
    { description: "ghqのリポジトリをfzfで選んでBoard作成（ctrl-oで現在のタブをcd）" },
  );

  // zenoのnneww/nnewm相当。テンプレートはcommand-templates.ts。
  // デフォルトの"n"(next-tab)を上書きする
  niwa.keybind("n", () => niwa.commandTemplate.open("worktree-new"), {
    description: "ワークツリーを作る（テンプレート）",
  });

  // .tmux.conf: bind-key g display-popup ... lazygit
  niwa.keybind(
    "g",
    () => {
      const tile = niwa.tile.current();
      niwa.popup.open({
        width: 95,
        height: 90,
        cwd: tile?.cwd,
        command: "lazygit --use-config-dir=$HOME/.config/lazygit",
      });
    },
    { description: "lazygitをポップアップで開く" },
  );

  niwa.keybind("p", "paste-clipboard");
  niwa.keybind("q", "restart-tab");
  niwa.keybind(
    "r",
    async () => {
      await niwa.reloadConfig();
      niwa.notify({ title: "設定をリロードしました" });
    },
    { description: "設定をリロードして通知する" },
  );

  niwa.keybind("alt+n", "next-board", { noPrefix: true });
  niwa.keybind("alt+p", "prev-board", { noPrefix: true });

  niwa.keybind("alt+j", "next-workspace", { noPrefix: true });
  niwa.keybind("alt+k", "prev-workspace", { noPrefix: true });

  // ワークスペース切替はalt+j/alt+kに寄せるので、デフォルトのprefix+[ / prefix+]
  // （prev-workspace/next-workspace）は解除する。解除したキーはprefix待ちを
  // キャンセルするだけで、ターミナルへも送られない
  niwa.unbind("[");
  niwa.unbind("]");

  // デフォルトのprefix+z（toggle-zoom）はそのまま残しつつ、prefix無しでも切り替えられるようにする
  niwa.keybind("alt+z", "toggle-zoom", { noPrefix: true });

  niwa.keybind(
    "alt+q",
    async () => {
      const tab = niwa.tab.current();
      if (!tab) return;

      const resume = await niwa.shell.run(
        `node ${EDITPROMPT_ENTRY} resume --target-pane ${tab.tabId}`,
        { env: { NIWATERM_TAB_ID: tab.tabId } },
      );
      if (resume.exitCode === 0) return;

      const tile = niwa.tile.current();
      const split = niwa.tile.split({ orientation: "horizontal", ratio: 0.8, cwd: tile?.cwd });
      if (!split) return;
      niwa.tab.respawn(split.tabId, {
        command: `node ${EDITPROMPT_ENTRY} open --editor nvim --target-pane ${tab.tabId} --always-copy`,
      });
    },
    { noPrefix: true, description: "editpromptを再開する（無ければ新規タブで開く）" },
  );

  // resumeを試さず常に新規editorタブ
  niwa.keybind(
    "alt+o",
    () => {
      const tab = niwa.tab.current();
      if (!tab) return;

      const tile = niwa.tile.current();
      const split = niwa.tile.split({ orientation: "horizontal", ratio: 0.8, cwd: tile?.cwd });
      if (!split) return;
      niwa.tab.respawn(split.tabId, {
        command: `node ${EDITPROMPT_ENTRY} open --editor nvim --target-pane ${tab.tabId} --always-copy`,
      });
    },
    { noPrefix: true, description: "editpromptを新規タブで開く" },
  );
};
