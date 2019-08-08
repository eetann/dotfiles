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
		Input,MyCommands,I T1 L2,{Esc},vi,ws,re,ta,tw,an,tr,gc,gk,gt,ex
		If MyCommands = vi
            IsOpenVivaldi()
		Else If MyCommands = ws
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
#IfWinActive

;-----------------------------------------------------------
; vivaldiのクイックコマンドのショートカットキーを押したら
; IMEはオフの状態で起動するように設定
#IfWInActive, ahk_exe vivaldi.exe
q::
	Send q
	Sleep 100
	IME_SET(0)
	Return
^q::
	Send ^q
	Sleep 100
	IME_SET(0)
	Return
^h::
	Send {BS}
	Return
^+l::
	Send ^+l
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
	Send !^{Tab}
	IsAltTabMenu := true
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
#IfWinActive ahk_class CabinetWClass 
	j::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, {Down}
		else
			Send, j
		return
	k::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, {Up}
		else
			Send, k
		return
	h::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, !{Up}
		else
			Send, h
		return
	l::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, {Enter}
		else
			Send, l
		return
	Space::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, {AppsKey}
		else
			Send, {Space}
		return
	y::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, ^c
		else
			Send, y
		return
	p::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, ^v
		else
			Send, p
		return
	r::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, {F2}
		else
			Send, r
		return
	f::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, {F5}
		else
			Send, f
		return
	^l::
		Send, !d
		return
	^n::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, +!n
		else
			Send, ^n
		return
	^p::
		if GetClassNameOnWindow(WinExist("A")) <> "Edit"
			Send, +!p
		else
			Send, ^p
		return
#IfWinActive

; #IfWinActive ahk_class AcrobatSDIWindow
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
; 			Send, !{Left}
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
; #IfWinActive

GetClassNameOnWindow(hWindow)
{
	max := VarSetCapacity(s, 256)
	ActiveThreadID := DllCall("GetWindowThreadProcessId", "UInt", hWindow, "UIntP",0)
	if(DllCall("AttachThreadInput", "UInt", DllCall("GetCurrentThreadId"), "UInt", ActiveThreadID, "Int", 1))
	{
		hFocus := DllCall("GetFocus")
		DllCall("GetClassName", "UInt", hFocus, "Str", s, "Int", max)
		DllCall("AttachThreadInput", "UInt", DllCall("GetCurrentThreadId"), "UInt", ActiveThreadID, "Int", 0)
	} 
    else
    {
		s := "Error"
    }
	return s
}
