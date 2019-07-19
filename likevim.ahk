﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Auto execute section is the region before any return/hotkey

; For Terminal/Vim
GroupAdd Terminal, ahk_class PuTTY
GroupAdd Terminal, ahk_class mintty ; cygwin
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

^[::
	Send {Esc}
	Return


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

vk1D::
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

;; 無変換+hjklでカーソル移動、Blindをつけると修飾キー組み合わせ（Shift、Ctrなど）も可能
vk1D & h::
	if(MuhenShort("h")){
		return
	}
	Send,{Blind}{left}
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
;;無変換+w,b,でword移動
vk1D & w::
	if(MuhenShort("w")){
		return
	}
	Send,{Blind}^{right}
return
vk1D & b::
	if(MuhenShort("b")){
		return
	}
	Send,{Blind}^{left}
return

;; 無変換+a,eでhome,end
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

; 変換+hでバックスペース
vk1C & h::
	if(HenkanShort("h")){
		return
	}
	Send,{BS}
return

;;変換+wでword消し
vk1C & w::
	if(HenkanShort("w")){
		return
	}
	Send,^{BS}
return

;;変換+uで手前全消し
vk1C & u::
	if(HenkanShort("u")){
		return
	}
	Send,{Blind}+{Home}{BS}
return

;;変換+yで一行コピー
vk1C & y::
	if(HenkanShort("y")){
		return
	}
	Send,{Blind}{End}+{Home}^{c}
return

; 変換+dで一行消し
vk1C & d::
	if(HenkanShort("y")){
		return
	}
	Send,{Blind}{End}+{Home}{BS}
return

; wox起動時はIMEオフに。
<!vk1D::
	Send !{vk1D}
	Sleep 100
	IME_SET(0)
	Return

#IfWInActive, ahk_group TerminalVim
Esc::
getIMEMode := IME_GET()
if (getIMEMode = 1) {
	IME_SET(0)
	Send {Esc}
	Return
} else {
	Send {Esc}
	Return
}
^[::
getIMEMode := IME_GET()
if (getIMEMode = 1) {
	Send {Esc}
	Sleep 1 ; wait 1 ms (Need to stop converting)
	IME_SET(0)
	Send {Esc}
	Return
} else {
	Send {Esc}
	Return
}
^o:: ; 挿入ノーマルモードに入るときもIMEオフ
getIMEMode := IME_GET()
if (getIMEMode = 1) {
	Sleep 1 ; wait 1 ms (Need to stop converting)
	IME_SET(0)
	Send ^o
	Return
} else {
	Send ^o
	Return
}
^y:: ; emmetで次の入力をするためにIMEオフ
getIMEMode := IME_GET()
if (getIMEMode = 1) {
	Sleep 1 ; wait 1 ms (Need to stop converting)
	IME_SET(0)
	Send ^y
	Return
} else {
	Send ^y
	Return
}
#IfWinActive

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
; それぞれのウェブパネルに割り振ったショートカットキーを通して、ウェブパネルを開く
~,::
	Input,MyCommands,I T0.5 L2,{Esc},ta,tw,an,tr,gc,gk,gt
	If MyCommands = ta
		Send, !1
	Else If MyCommands = tw
		Send, !2
	Else If MyCommands = an
		Send, !3
	Else If MyCommands = tr
		Send, !4
	Else If MyCommands = gc
		Send, !5
	Else If MyCommands = gk
		Send, !6
	Else If MyCommands = gt
		Send, !7
	Return
#IfWinActive

IsAltTabMenu := false
!Tab::
	Send !^{Tab}
	IsAltTabMenu := true
Return
vk1C & m::
	if(HenkanShort("m")){
		return
	}
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
