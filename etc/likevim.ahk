#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Auto execute section is the region before any return/hotkey

;-----------------------------------------------------------
; IMEの状態の取得
;   WinTitle="A"    対象Window
;   戻り値          1:ON / 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="A")  {
    ControlGet,hwnd,HWND,,,%WinTitle%
    if  (WinActive(WinTitle))   {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;   DWORD   cbSize;
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
    if  (WinActive(WinTitle))   {
        ptrSize := !A_PtrSize ? 4 : A_PtrSize
        VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
        NumPut(cbSize, stGTI,  0, "UInt")   ;   DWORD   cbSize;
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
; ターミナル以外でもエスケープ設定
; ^[::
;   Send {Esc}
;   Return

IsOpenChrome() {
    Process, Exist, chrome.exe
    if ErrorLevel<>0
        WinActivate, ahk_exe chrome.exe
    Else {
        Run,C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
        Sleep 3000
    }
}

; 無変換キー + b, w, re, e, f
vk1D::
    Input,MyCommands,I T1 L2, {Esc},b,w,re,e,f
    If MyCommands = b
    {
        IsOpenChrome()
    } Else If MyCommands = w
    {
        WinActivate, ahk_exe mintty.exe
    } Else If MyCommands = re
    {
        Reload
    } Else If MyCommands = e
    {
        ; tablacusexplorer を開く
        Run, D:\tablacusexplorer\TE64.exe
    } Else If MyCommands = f
    {
        Run,D:\fitwin\fitwin.exe
        WinActivate, ahk_exe fitwin.exe
    }
return


;-----------------------------------------------------------
; ターミナルでvimのためのIME
#IfWInActive, ahk_exe mintty.exe
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
^Tab:: ; CTRL Tab でバッファの切り替え
    Send {Space}{Tab}
    return
^+Tab:: ; CTRL Shift Tab でバッファの切り替え
    Send {Space}+{Tab}
    return
#IfWinActive

;-----------------------------------------------------------
; Chrome
; アドレスバーのショートカットキーを押したら
; IMEはオフの状態で起動するように設定
#IfWInActive, ahk_exe chrome.exe
^l::
    Send ^l
    Sleep 100
    IME_SET(0)
    Return
^t::
    Send ^t
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
; カタカナひらがなローマ字キー2連打でAltTabMenuキーとして割当
vkF2::
    If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 1000){
        Send !^{Tab}
        IsAltTabMenu := true
    }
    return
; 変換キー2連打でAltTabMenuキーとして割当
vk1C::
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
