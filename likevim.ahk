#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Auto execute section is the region before any return/hotkey

; For Terminal/Vim
GroupAdd Terminal, ahk_class PuTTY
GroupAdd Terminal, ahk_class mintty
GroupAdd TerminalVim, ahk_group Terminal
GroupAdd TerminalVim, ahk_class Vim

;-----------------------------------------------------------
; IMEの状態の取得
;   WinTitle="A"    対象Window
;   戻り値          1:ON / 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="A")  {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Int, 0)      ;lParam  : 0
}

;-----------------------------------------------------------
; IMEの状態をセット
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")    {
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
		ptrSize := !A_PtrSize ? 4 : A_PtrSize
	    VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	    NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
		hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
	             ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
	}

    return DllCall("SendMessage"
          , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Int, SetSts) ;lParam  : 0 or 1
}
;===========================================================================
; IME 入力モード (どの IMEでも共通っぽい)
;   DEC  HEX    BIN
;     0 (0x00  0000 0000) かな    半英数
;     3 (0x03  0000 0011)         半ｶﾅ
;     8 (0x08  0000 1000)         全英数
;     9 (0x09  0000 1001)         ひらがな
;    11 (0x0B  0000 1011)         全カタカナ
;    16 (0x10  0001 0000) ローマ字半英数
;    19 (0x13  0001 0011)         半ｶﾅ
;    24 (0x18  0001 1000)         全英数
;    25 (0x19  0001 1001)         ひらがな
;    27 (0x1B  0001 1011)         全カタカナ

;  ※ 地域と言語のオプション - [詳細] - 詳細設定
;     - 詳細なテキストサービスのサポートをプログラムのすべてに拡張する
;    が ONになってると値が取れない模様
;    (Google日本語入力βはここをONにしないと駄目なので値が取れないっぽい)

;-------------------------------------------------------
; IME 入力モード取得
;   WinTitle="A"    対象Window
;   戻り値          入力モード
;--------------------------------------------------------
IME_GetConvMode(WinTitle="A")   {
    ControlGet,hwnd,HWND,,,%WinTitle%
        if  (WinActive(WinTitle))   {
ptrSize := !A_PtrSize ? 4 : A_PtrSize
             VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
             NumPut(cbSize, stGTI,  0, "UInt")  ;   DWORD   cbSize;
hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
          ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
        }
    return DllCall("SendMessage"
            , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
            , UInt, 0x0283 ;Message : WM_IME_CONTROL
            ,  Int, 0x001  ;wParam  : IMC_GETCONVERSIONMODE
            ,  Int, 0)     ;lParam  : 0
}

;-------------------------------------------------------
; IME 入力モードセット
;   ConvMode        入力モード
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;--------------------------------------------------------
IME_SetConvMode(ConvMode,WinTitle="A")   {
    ControlGet,hwnd,HWND,,,%WinTitle%
        if  (WinActive(WinTitle))   {
ptrSize := !A_PtrSize ? 4 : A_PtrSize
             VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
             NumPut(cbSize, stGTI,  0, "UInt")  ;   DWORD   cbSize;
hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
          ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
        }
    return DllCall("SendMessage"
            , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
            , UInt, 0x0283     ;Message : WM_IME_CONTROL
            ,  Int, 0x002      ;wParam  : IMC_SETCONVERSIONMODE
            ,  Int, ConvMode)  ;lParam  : CONVERSIONMODE
}

;===========================================================================
; IME 変換モード (ATOKはver.16で調査、バージョンで多少違うかも)

;   MS-IME  0:無変換 / 1:人名/地名                    / 8:一般    /16:話し言葉
;   ATOK系  0:固定   / 1:複合語              / 4:自動 / 8:連文節
;   WXG              / 1:複合語  / 2:無変換  / 4:自動 / 8:連文節
;   SKK系            / 1:ノーマル (他のモードは存在しない？)
;   Googleβ                                          / 8:ノーマル
;------------------------------------------------------------------
; IME 変換モード取得
;   WinTitle="A"    対象Window
;   戻り値 MS-IME  0:無変換 1:人名/地名               8:一般    16:話し言葉
;          ATOK系  0:固定   1:複合語           4:自動 8:連文節
;          WXG4             1:複合語  2:無変換 4:自動 8:連文節
;------------------------------------------------------------------
IME_GetSentenceMode(WinTitle="A")   {
    ControlGet,hwnd,HWND,,,%WinTitle%
        if  (WinActive(WinTitle))   {
ptrSize := !A_PtrSize ? 4 : A_PtrSize
             VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
             NumPut(cbSize, stGTI,  0, "UInt")  ;   DWORD   cbSize;
hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
          ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
        }
    return DllCall("SendMessage"
            , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
            , UInt, 0x0283 ;Message : WM_IME_CONTROL
            ,  Int, 0x003  ;wParam  : IMC_GETSENTENCEMODE
            ,  Int, 0)     ;lParam  : 0
}

;----------------------------------------------------------------
; IME 変換モードセット
;   SentenceMode
;       MS-IME  0:無変換 1:人名/地名               8:一般    16:話し言葉
;       ATOK系  0:固定   1:複合語           4:自動 8:連文節
;       WXG              1:複合語  2:無変換 4:自動 8:連文節
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;-----------------------------------------------------------------
IME_SetSentenceMode(SentenceMode,WinTitle="A")  {
    ControlGet,hwnd,HWND,,,%WinTitle%
        if  (WinActive(WinTitle))   {
ptrSize := !A_PtrSize ? 4 : A_PtrSize
             VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
             NumPut(cbSize, stGTI,  0, "UInt")  ;   DWORD   cbSize;
hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
          ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
        }
    return DllCall("SendMessage"
            , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
            , UInt, 0x0283         ;Message : WM_IME_CONTROL
            ,  Int, 0x004          ;wParam  : IMC_SETSENTENCEMODE
            ,  Int, SentenceMode)  ;lParam  : SentenceMode
}


;---------------------------------------------------------------------------
;  IMEの種類を選ぶかもしれない関数

;==========================================================================
;  IME 文字入力の状態を返す
;  (パクリ元 : http://sites.google.com/site/agkh6mze/scripts#TOC-IME- )
;    標準対応IME : ATOK系 / MS-IME2002 2007 / WXG / SKKIME
;    その他のIMEは 入力窓/変換窓を追加指定することで対応可能
;
;       WinTitle="A"   対象Window
;       ConvCls=""     入力窓のクラス名 (正規表現表記)
;       CandCls=""     候補窓のクラス名 (正規表現表記)
;       戻り値      1 : 文字入力中 or 変換中
;                   2 : 変換候補窓が出ている
;                   0 : その他の状態
;
;   ※ MS-Office系で 入力窓のクラス名 を正しく取得するにはIMEのシームレス表示を
;      OFFにする必要がある
;      オプション-編集と日本語入力-編集中の文字列を文書に挿入モードで入力する
;      のチェックを外す
;==========================================================================
IME_GetConverting(WinTitle="A",ConvCls="",CandCls="") {

    ;IME毎の 入力窓/候補窓Class一覧 ("|" 区切りで適当に足してけばOK)
        ConvCls .= (ConvCls ? "|" : "")                ;--- 入力窓 ---
        .  "ATOK\d+CompStr"                    ; ATOK系
        .  "|imejpstcnv\d+"                    ; MS-IME系
        .  "|WXGIMEConv"                       ; WXG
        .  "|SKKIME\d+\.*\d+UCompStr"          ; SKKIME Unicode
        .  "|MSCTFIME Composition"             ; Google日本語入力

        CandCls .= (CandCls ? "|" : "")                ;--- 候補窓 ---
        .  "ATOK\d+Cand"                       ; ATOK系
        .  "|imejpstCandList\d+|imejpstcand\d+" ; MS-IME 2002(8.1)XP付属
        .  "|mscandui\d+\.candidate"           ; MS Office IME-2007
        .  "|WXGIMECand"                       ; WXG
        .  "|SKKIME\d+\.*\d+UCand"             ; SKKIME Unicode
        CandGCls := "GoogleJapaneseInputCandidateWindow" ;Google日本語入力

        ControlGet,hwnd,HWND,,,%WinTitle%
        if  (WinActive(WinTitle))   {
ptrSize := !A_PtrSize ? 4 : A_PtrSize
             VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
             NumPut(cbSize, stGTI,  0, "UInt")  ;   DWORD   cbSize;
hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
          ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
        }

    WinGet, pid, PID,% "ahk_id " hwnd
        tmm:=A_TitleMatchMode
        SetTitleMatchMode, RegEx
        ret := WinExist("ahk_class " . CandCls . " ahk_pid " pid) ? 2
        :  WinExist("ahk_class " . CandGCls                 ) ? 2
        :  WinExist("ahk_class " . ConvCls . " ahk_pid " pid) ? 1
        :  0
        SetTitleMatchMode, %tmm%
        return ret
}
;-----------------------------------------------------------

;-----------------------------------------------------------
; ターミナル以外でもエスケープ設定
^[::
	Send {Esc}
	Return


;-----------------------------------------------------------
; 無変換→IMEOFF、変換→IMEONにする
; 単独キーも有効にするためにタイマーを設定する
SetTimer, HenMuhenChecker, 100
HenMuhenChecker:
	ListLines,Off	;実行履歴の邪魔なので記録しない
	if(GetKeyState("vk1C","P") or GetKeyState("vk1D","P")){
		HenMuhenTime++
	} else {
		HenMuhenTime:=0
	}
	return

MuhenShort(k){
	global HenMuhenTime
	if(HenMuhenTime<3){
		Input,kb,T0.1
		if(GetKeyState("vk1D","P")){
			return 0
		} else {
			Gosub,vk1D
			Send,{Blind}%k%{Blind}%kb%
			return 1
		}
	} else {
		return 0
	}
}

HenkanShort(k){
	global HenMuhenTime
	if(HenMuhenTime<3){
		Input,kb,T0.1
		if(GetKeyState("vk1C","P")){
			return 0
		} else {
			Gosub,vk1C
			Send,{Blind}%k%{Blind}%kb%
			return 1
		}
	} else {
		return 0
	}
}

IsOpenVivaldi() {
    Process, Exist, vivaldi.exe
    if ErrorLevel<>0
        WinActivate, ahk_exe vivaldi.exe
    Else {
        Run,C:\Program Files (x86)\Vivaldi\Application\vivaldi.exe
        Sleep 3000
    }
}

vk1D::
	If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 1000){
		Input,MyCommands,I T1 L2,{Esc},v,w,re,ta,tw,an,tr,gc,gk,gt,ex
		If MyCommands = v
            IsOpenVivaldi()
		Else If MyCommands = w
			WinActivate, ahk_group TerminalVim
		Else If MyCommands = re
			Reload
		Else If MyCommands = ta
		{
			IsOpenVivaldi()
			Send, !1
		}
		Else If MyCommands = tw
		{
			IsOpenVivaldi()
			Send, !2
		}
		Else If MyCommands = an
		{
			IsOpenVivaldi()
			Send, !3
		}
		Else If MyCommands = tr
		{
			IsOpenVivaldi()
			Send, !4
		}
		Else If MyCommands = gc
		{
			IsOpenVivaldi()
			Send, !5
		}
		Else If MyCommands = gk
		{
			IsOpenVivaldi()
			Send, !6
		}
		Else If MyCommands = gt
		{
			IsOpenVivaldi()
			Send, !7
		}
		Else If MyCommands = ex
		{
            ; explorer.exeは常に存在するため、Process, Exist, explorer.exeは使えない
            IfWinExist, ahk_class CabinetWClass
            {
                WinActivate ahk_class CabinetWClass
            } else {
                Run, explorer.exe
            }
		}
		return
	}
	if(HenMuhenTime<3){
		IME_SET(0)
	}
	return

vk1C::
	if(HenMuhenTime<3){
		IME_SET(1)
	}
	return

!vk1D::Send,{Blind}!{vk1D}


;-----------------------------------------------------------
; 無変換+hjklでカーソル移動
; Blindをつけると修飾キー組み合わせ(Shift、Ctrなど)も可能
; 無変換+Ctrl+hでバックスペース
vk1D & h::
	if(MuhenShort("h")){
		return
	}
	if (GetKeyState("Ctrl" ,"h")){
		Send,{BS}
	} else {
		Send,{Blind}{left}
	}
	return

vk1D & j::
	if(MuhenShort("j")){
		return
	}
	Send,{Blind}{down}
	return

vk1D & k::
	if(MuhenShort("k")){
		return
	}
	Send,{Blind}{up}
	return

vk1D & l::
	if(MuhenShort("l")){
		return
	}
	Send,{Blind}{right}
	return

; 無変換+wでword移動、無変換+CTRL+wでword消し
vk1D & w::
	if(MuhenShort("w")){
		return
	}
	if (GetKeyState("Ctrl" ,"w")){
		Send,^{BS}
	} else {
		Send,{Blind}^{right}
	}
	return

; 無変換+bでwordバック移動
vk1D & b::
	if(MuhenShort("b")){
		return
	}
	Send,{Blind}^{left}
	return

; 無変換+a,eでhome,end
vk1D & a::
	if(MuhenShort("a")){
		return
	}
	Send,{Blind}{Home}
	return
vk1D & e::
	if(MuhenShort("e")){
		return
	}
	Send,{Blind}{End}
	return

; 無変換+uでページアップ、無変換+Ctrl+uで手前全消し
vk1D & u::
	if(MuhenShort("u")){
		return
	}
	if (GetKeyState("Ctrl" ,"u")){
		Send,{Blind}+{Home}{BS}
	} else {
		Send,{PgUp}
	}
	return

; 無変換+dでページダウン、無変換+Ctrl+dで一行消し
vk1D & d::
	if(MuhenShort("d")){
		return
	}
	if (GetKeyState("Ctrl" ,"d")){
		Send,{Blind}{End}+{Home}{BS}
	} else {
		Send,{PgDn}
	}
	return

; 無変換+yで一行コピー
vk1D & y::
	if(MuhenShort("y")){
		return
	}
	Send,{Blind}{End}+{Home}^{c}
	return

;-----------------------------------------------------------
; wox起動時はIMEオフに。
<!vk1D::
	Send !{vk1D}
	Sleep 100
	IME_SET(0)
	Return

;-----------------------------------------------------------
; ターミナルでvimのためのIME
#IfWInActive, ahk_group TerminalVim
Esc::
	getIMEMode := IME_GET()
	if (getIMEMode = 1) {
		IME_SET(0)
		Send {Esc}
	} else {
		Send {Esc}
	}
	return
^[::
	getIMEMode := IME_GET()
	if (getIMEMode = 1) {
		Send {Esc}
		Sleep 1 ; wait 1 ms (Need to stop converting)
		IME_SET(0)
		Send {Esc}
	} else {
		Send {Esc}
	}
	return
^o:: ; 挿入ノーマルモードに入るときもIMEオフ
	getIMEMode := IME_GET()
	if (getIMEMode = 1) {
		Sleep 1 ; wait 1 ms (Need to stop converting)
		IME_SET(0)
		Send ^o
	} else {
		Send ^o
	}
	return
^y:: ; emmetで次の入力をするためにIMEオフ
	getIMEMode := IME_GET()
	if (getIMEMode = 1) {
		Sleep 1 ; wait 1 ms (Need to stop converting)
		IME_SET(0)
		Send ^y
	} else {
		Send ^y
	}
	return
^+Tab:: ; CTRL Shift Tab でバッファの切り替え
    Send {Space}{Tab}
    return
#IfWinActive

;-----------------------------------------------------------
; Chrome
; アドレスバーのショートカットキーを押したら
; IMEはオフの状態で起動するように設定
#IfWInActive, ahk_exe chrome.exe
^h::
	Send {BS}
	Return
^l::
	Send ^l
	Sleep 100
	IME_SET(0)
	Return
#IfWinActive


;-----------------------------------------------------------
; AltTab
IsAltTabMenu := false
!Tab::
	Send !^{Tab}
	IsAltTabMenu := true
	return
; カタカナひらがなローマ字キーでAltTabMenuキーとして割当
vkF2::
    If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 1000){
        Send !^{Tab}
        IsAltTabMenu := true
    }
    return
#If (IsAltTabMenu)
	h::Send {Left}
	j::Send {Down}
	k::Send {Up}
	l::Send {Right}
	Enter::
		Send {Enter}
		IsAltTabMenu := false
	Return
	Space::
		Send {Space}
		IsAltTabMenu := false
	Return
#If

;-----------------------------------------------------------
; explorer
; #IfWinActive ahk_class CabinetWClass 
; 	j::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, {Down}
; 		else
; 			Send, j
; 		return
; 	k::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, {Up}
; 		else
; 			Send, k
; 		return
; 	h::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, !{Up}
; 		else
; 			Send, h
; 		return
; 	l::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, {Enter}
; 		else
; 			Send, l
; 		return
; 	Space::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, {AppsKey}
; 		else
; 			Send, {Space}
; 		return
; 	y::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, ^c
; 		else
; 			Send, y
; 		return
; 	p::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, ^v
; 		else
; 			Send, p
; 		return
; 	r::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, {F2}
; 		else
; 			Send, r
; 		return
; 	f::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, {F5}
; 		else
; 			Send, f
; 		return
; 	^l::
; 		Send, !d
; 		return
; 	^n::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, +!n
; 		else
; 			Send, ^n
; 		return
; 	^p::
; 		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
; 			Send, +!p
; 		else
; 			Send, ^p
; 		return
; #IfWinActive
;
; GetClassNameOnWindow(hWindow)
; {
; 	max := VarSetCapacity(s, 256)
; 	ActiveThreadID := DllCall("GetWindowThreadProcessId", "UInt", hWindow, "UIntP",0)
; 	if(DllCall("AttachThreadInput", "UInt", DllCall("GetCurrentThreadId"), "UInt", ActiveThreadID, "Int", 1))
; 	{
; 		hFocus := DllCall("GetFocus")
; 		DllCall("GetClassName", "UInt", hFocus, "Str", s, "Int", max)
; 		DllCall("AttachThreadInput", "UInt", DllCall("GetCurrentThreadId"), "UInt", ActiveThreadID, "Int", 0)
; 	} 
;     else
;     {
; 		s := "Error"
;     }
; 	return s
; }
