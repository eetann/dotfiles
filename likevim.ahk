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
#IfWinActive

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

<!vk1D::
	Send !{vk1D}
	Sleep 100
	IME_SET(0)
	Return

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
#IfWinActive


; #IfWinActive, ahk_class CabinetWClass
; h::
; getIMEGC := IME_GetConverting()
; if (getIMEGC!=0){
; 	Send h
; 	Return
; } else {
; 	Send,!{up}
; 	Return
; }
; #IfWinActive
