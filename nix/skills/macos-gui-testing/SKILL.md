---
name: macos-gui-testing
description: |
  macOSのデスクトップアプリ（GUI）をAIが起動・キー操作・スクリーンショットで動作確認するノウハウ。
  トリガー: デスクトップアプリの動作確認、GUIのE2E的な検証、「アプリを起動して確認して」
---

macOSのGUIアプリをosascript（System Events）とscreencaptureで操作・検証するときの手順と落とし穴集。

## 起動と監視

GUIアプリは `run_in_background` で起動し、出力ファイルを読んで状態を確認する：

```bash
# 起動（フォアグラウンドで起動するとブロックする）
bun run start  # run_in_background: true で

# 終了はバンドル名でpkill
pkill -f 'myapp-dev.app'
```

## キー操作の前に必ずフォーカスを明示する

ウィンドウが見えていてもキーイベントは届かないことがある。**操作前に必ずfrontmostを設定**：

```applescript
tell application "System Events"
  set frontmost of (first process whose name is "bun") to true
  delay 0.5
  keystroke "abc"
end tell
```

注意点：

- **プロセス名はアプリ名と違うことがある**（例: Electrobunアプリは "bun"）。`osascript -e 'tell application "System Events" to get name of every process whose visible is true'` で確認
- アプリ側にもフォーカス処理が必要な場合がある（webviewベースのアプリはDOM要素に `tabIndex` + `focus()` がないとkeydownが発火しない）

## 同名プロセスが複数存在する場合の絞り込み

同じ種類の自作アプリ（例: Electrobunアプリ）を複数同時に起動していると、System Events上ではどれもプロセス名が同じ（例: "bun"）になり、名前だけでは区別できない。区別を誤ると、意図しない別アプリのウィンドウを操作してしまう（他アプリを勝手にリサイズする等の事故につながる）。

**`first process whose unix id is X` は同名プロセスが複数あると不安定**で、タイミングによって別プロセスに解決されることがある。`every process whose name is "..."` でリスト化し、repeatループの中で `unix id` を明示比較して絞り込むのが確実：

```applescript
tell application "System Events"
  set targetProc to missing value
  repeat with p in every process whose name is "bun"
    if (unix id of p) is 46697 then
      set targetProc to p
      exit repeat
    end if
  end repeat
end tell
```

さらに、1プロセスが複数ウィンドウを持つことがある（名前の付かない小さいヘルパーウィンドウ等）。**PIDが合っていてもウィンドウを取り違える**ことがあるので、操作前に必ずウィンドウ名でもチェックする：

```applescript
repeat with w in windows of targetProc
  if (name of w) contains "対象アプリ名の一部" then
    -- ここでsize/positionの取得・変更を完結させる（下記参照）
  end if
end repeat
```

**ウィンドウ参照を後で再利用すると失敗する**: `set w to item 1 of (windows of targetProc)` のように一度リストから取り出した参照を、別の行や別のブロックで使い回すと「window "..." を取り出すことはできません (-1728)」で失敗することがある（ウィンドウ名に特殊文字が含まれると特に起きやすい）。取得から操作（サイズ取得・変更など）まで、同じrepeatループのスコープ内で完結させること。

## 日本語IMEの罠

### 原因: 複数単語をまとめて`keystroke`に渡すと日本語IMEが未確定入力として扱う

日本語入力ソース（特にGoogle日本語入力）が有効な状態で、スペースを含む複数単語の文字列を**1回の`keystroke`にまとめて渡す**と、IMEがそれを未確定入力として扱い、ローマ字→かな変換してしまうことがある。症状は「スペースが消える」だけでなく、**単語全体が文字化けする**場合もある（例: `keystroke "echo hello"` → `ecほへっぉ` のようになる）。

**確実な回避策: 単語ごとに`keystroke`を分割し、間に`key code 49`（スペース）を挟む**：

```applescript
keystroke "echo"
key code 49  -- スペース
keystroke "splittest"
key code 36  -- Enter
```

これで安定して動く。**1単語（スペースを含まない文字列）なら1回の`keystroke`でも問題ない**。文字化けを見たら、まず「`keystroke`に複数単語を一度に渡していないか」を疑うこと。

よく使うkey code: `36`=Enter, `49`=Space, `51`=Backspace, `53`=Escape, `102`=英数(JIS)

### 確実な回避策その2: `pbcopy` + Cmd+Vでペーストする

長い文章や記号を含むテキストなど、単語分割が面倒な場合はクリップボード経由でペーストする方法も確実：

```bash
echo -n "your text here" | pbcopy
osascript -e 'tell application "System Events" to keystroke "v" using {command down}'
```

多くのアプリ（特にターミナルエミュレータ）はペーストされたテキストをIMEの合成を経由せず直接受け取るため、これも信頼できる方法。

### それでも足りない場合

- 修飾キー付きショートカット（Cmd+D等）やcliclickでのクリック操作はそもそもIME変換の対象にならない。文字入力を伴わない検証はこちらを優先する
- 上記の分割・ペーストを試しても解決しない、文字単位のkeydownやIME合成表示そのものを検証したい場合など、キーボードでの文字入力がどうしても必要なケースでは、その入力操作だけユーザーに手動でお願いする方が早い場合がある

## `click at` は使えないことが多い

System Eventsの `click at {x, y}` はaccessibility権限の関係でエラー（-25208）になりやすい。クリックに頼らず、キーボード操作かアプリ側の仕組みで検証する。

## スクリーンショットで確認

```bash
screencapture -x /path/to/scratchpad/shot.png  # -x でシャッター音なし
```

撮ったらReadツールで画像を見る。`set frontmost` の直後はMission Control風の画面になっていることがあるので、スクショで実際の状態を確認してから操作する。

## スクショだけに頼らず、ログで検証する

ピクセルの目視より**イベントフローのログ**が確実。アプリのstdoutにログが出ない構成（webviewのconsole.logが親プロセスに出ない等）なら、アプリ内にログ転送チャネル（RPC/IPCで `log` メッセージをメインプロセスへ送る等）を一時的に仕込む。

キー入力の検証例: 「keydownが発火したか」「メインプロセスに届いたか」を別々にログして、どこで途切れたか切り分ける。

## 終了時のクリーンアップ検証

子プロセス（シェル等）のリークは、終了前に子PIDを控えてから確認する：

```bash
APP_PID=$(pgrep -f 'Resources/main.js' | head -1)
CHILD_PIDS=$(pgrep -P $APP_PID)
pkill -f 'myapp-dev.app'; sleep 2
for p in $CHILD_PIDS; do ps -p $p >/dev/null && echo "LEAK: $p" || echo "cleaned: $p"; done
```
