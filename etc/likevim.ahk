#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Auto execute section is the region before any return/hotkey
GroupAdd, browser, ahk_exe chrome.exe
GroupAdd, browser, ahk_exe vivaldi.exe

;-----------------------------------------------------------
; ターミナル以外でもエスケープ設定
^[::
  Send {Esc}
  Return

IsOpenChrome() {
    Process, Exist, chrome.exe
    if ErrorLevel<>0
        WinActivate, ahk_exe chrome.exe
    Else {
        Run,C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
        Sleep 3000
    }
}

; 無変換キー + Noe, r, e
vk1D::Send, {Blind}{vk1D}
vk1D & r::Reload
vk1D & e::Run, D:\tablacusexplorer\TE64.exe

;-----------------------------------------------------------
; ターミナルでvimのためのIME
#IfWinActive, ahk_exe mintty.exe
Esc::
    Send {vk1D}{Esc}
    return
^[::
    Send {vk1D}{Esc}
    return
^o:: ; 挿入ノーマルモードに入るときもIMEオフ
    Send {vk1D}^o
    return
^y:: ; emmetで次の入力をするためにIMEオフ
    Send {vk1D}^y
    return
^Tab:: ; CTRL Tab でバッファの切り替え
    Send {Space}{Tab}
    return
^+Tab:: ; CTRL Shift Tab でバッファの切り替え
    Send {Space}+{Tab}
    return
#IfWinActive

-----------------------------------------------------------
; Chrome
; アドレスバーのショートカットキーを押したら
; IMEはオフの状態で起動するように設定
#IfWinActive ahk_group browser
^l::
    Send ^l
    Sleep 100
    Send {vk1D}
    Return
^t::
    Send ^t
    Sleep 100
    Send {vk1D}
    Return
^j::
    Send ^k
    Sleep 100
    Send {vk1D}
    Return
F2::
    Send {F2}
    Sleep 100
    Send {vk1D}
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
