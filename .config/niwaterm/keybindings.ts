import type { KeybindingsFn } from "@niwaterm/config";

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
export const keybindings: KeybindingsFn = (niwa) => {
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
  // BoardがtmuxのWindowに対応するので、デフォルトの"c"(new-tab)を上書きする。
  // niwa.board.createはtab.createと違いcwd省略時にフォーカス中タブのcwdを引き継がない
  // （OS標準になる）ため、明示的に渡す
  niwa.keybind("c", () => {
    niwa.board.create(niwa.tile.current()?.cwd);
  });

  // .tmux.conf: Vimキーバインドでペイン移動
  // (if-shellでの端チェックはniwa.tile.focus側が境界で何もしないため不要)
  niwa.keybind("h", "focus-left");
  niwa.keybind("j", "focus-down");
  niwa.keybind("k", "focus-up");
  niwa.keybind("l", "focus-right");

  // .tmux.conf: bind-key -r H/J/K/L resize-pane -L/-D/-U/-R
  niwa.keybind("shift+h", "resize-left", { repeat: true });
  niwa.keybind("shift+j", "resize-up", { repeat: true });
  niwa.keybind("shift+k", "resize-down", { repeat: true });
  niwa.keybind("shift+l", "resize-right", { repeat: true });

  // .tmux.conf: bind-key -N "ペインIDの表示" P (xsel/pbcopyでpane_idをコピー)
  niwa.keybind("shift+p", () => {
    const tile = niwa.tile.current();
    if (tile) niwa.clipboard.write(tile.id);
  });

  // .tmux.conf: bind-key w {
  //   display-popup -E -w 80% -h 80% -d '#{pane_current_path}' "tmux-ghq '#{pane_id}'"
  //   if-shell -F '#{@ghq_cd}' { run-shell 'tmux send-keys "cd #{@ghq_cd}" Enter'; set-option -gu @ghq_cd }
  // }
  // tmux版はpopup内のスクリプト（tmux-ghq）からtmuxコマンドを叩いていたが、niwaterm版は
  // fzfでの選択そのもの（bin/ghq-select。tmux版と共通）をpopupで動かして選択結果だけを
  // 標準出力で受け取り、実際の操作はこのハンドラ側で行う。@ghq_cd変数を経由した
  // 「popupを閉じてからsend-keys」の二段構えは、niwa.popup.runがpopupを閉じた後に解決する
  // ためそのまま素直に書ける
  niwa.keybind("w", async () => {
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
  niwa.keybind("r", async () => {
    await niwa.reloadConfig();
    niwa.notify({ title: "設定をリロードしました" });
  });

  // .tmux.conf: bind-key -n M-n next-window / bind-key -n M-p previous-window
  // tmuxのWindowはniwatermのBoardに対応する（ADR 0006）ため、同じワークスペース内の
  // Board切替になる。next-board/prev-boardは既定キーを持たないアクションなので、
  // ここでdirect（noPrefix）へ割り当てる
  niwa.keybind("alt+n", "next-board", { noPrefix: true });
  niwa.keybind("alt+p", "prev-board", { noPrefix: true });

  // .tmux.conf: bind-key -n M-j { switch-client -n; refresh-client -S }
  //             bind-key -n M-k { switch-client -p; refresh-client -S }
  // tmuxのsession = niwatermのワークスペース。tmux側で切替のたびにrefresh-client -Sを
  // 呼んでいたのはステータスバーの再描画が遅れるためだが、niwatermは切替結果をbun側が
  // renderブロードキャストしてサイドバー・ウィンドウタイトルまで一括更新するため不要
  niwa.keybind("alt+j", "next-workspace", { noPrefix: true });
  niwa.keybind("alt+k", "prev-workspace", { noPrefix: true });

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
};
