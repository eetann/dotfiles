#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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
#IfWinActive

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

; 変換+hでバックスペース
vk1C & h::
	if(HenkanShort("h")){
		return
	}
	Send,{BS}
return

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
; vk1D & h::Send, {Blind}{left}
; vk1D & j::Send, {Blind}{down}
; vk1D & k::Send, {Blind}{up}
; vk1D & l::Send, {Blind}{right}

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

