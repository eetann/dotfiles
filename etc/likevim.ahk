SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

; Auto execute section is the region before any return/hotkey
GroupAdd("browser", "ahk_exe chrome.exe")
GroupAdd("browser", "ahk_exe vivaldi.exe")

;-----------------------------------------------------------
; ターミナル以外でもエスケープ設定
^[:: {
  Send("{Esc}")
  Return
}

IsOpenChrome() {
    ErrorLevel := ProcessExist("chrome.exe")
    if (ErrorLevel != 0)
        WinActivate("ahk_exe chrome.exe")
    Else {
        Run("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe")
        Sleep(3000)
    }
}

; 無変換キー + Noe, r, e
vk1D::Send("{Blind}{vk1D}")
vk1D & r::Reload()

; ChangeKey
; CapsLock - > F13 （キー割当画面右上のScan Codeより"0x0064"を割り当てる）
; CTRL_L -> WIN
; WIN -> CTRL_L

; CapsLock + a,e,h,d,f,b,b,p,n,k,tab,shift-tab
F13 & a::Send("{Home}")
F13 & e::Send("{End}")
F13 & d::Send("{Del}")
F13 & h::Send("{BS}")
F13 & f::Send("{Right}")
F13 & b::Send("{Left}")
F13 & p::Send("{Up}")
F13 & n::Send("{Down}")
F13 & k::Send("+{End}{Del}")
F13 & Tab::
{
  if GetKeyState("Shift") {
    Send("^+{Tab}")
    return
  }
  Send("^{Tab}")
  return
}

;-----------------------------------------------------------
; ターミナルでvimのためのIME
#HotIf WinActive("ahk_exe mintty.exe", )
Esc::
{
    Send("{vk1D}{Esc}")
    return
}
^[::
{
    Send("{vk1D}{Esc}")
    return
}
^o:: ; 挿入ノーマルモードに入るときもIMEオフ
{
    Send("{vk1D}^o")
    return
}
^y:: ; emmetで次の入力をするためにIMEオフ
{
    Send("{vk1D}^y")
    return
}
^k:: ; snippetで次の入力をするためにIMEオフ
{
    Send("{vk1D}^k")
    return
}
^Tab:: ; CTRL Tab でバッファの切り替え
{
    Send("{Space}{Tab}")
    return
}
^+Tab:: ; CTRL Shift Tab でバッファの切り替え
{
    Send("{Space}+{Tab}")
    return
}
#HotIf

;-----------------------------------------------------------
; Chrome
; アドレスバーのショートカットキーを押したら
; IMEはオフの状態で起動するように設定
#HotIf WinActive("ahk_group browser", )
^l::
{
    Send("^l")
    Sleep(100)
    Send("{vk1D}")
    Return
}
^t::
{
    Send("^t")
    Sleep(100)
    Send("{vk1D}")
    Return
}
^j::
{
    Send("^j")
    Sleep(100)
    Send("{vk1D}")
    Return
}
F2::
{
    Send("{F2}")
    Sleep(100)
    Send("{vk1D}")
    Return
}
#HotIf


;-----------------------------------------------------------
; AltTab
IsAltTabMenu := false
!Tab::
{
    Send("!^{Tab}")
    IsAltTabMenu := true
    return
; カタカナひらがなローマ字キー2連打でAltTabMenuキーとして割当
}
vkF2::
{
    If (A_PriorHotKey == A_ThisHotKey and A_TimeSincePriorHotkey < 1000){
        Send("!^{Tab}")
        IsAltTabMenu := true
    }
    return
}
#HotIf (IsAltTabMenu)
    h::    Send("{Left}")
    j::    Send("{Down}")
    k::    Send("{Up}")
    l::    Send("{Right}")
    Enter::
    {
        Send("{Enter}")
        IsAltTabMenu := false
        Return
    }
    Space::
    {
        Send("{Space}")
        IsAltTabMenu := false
        Return
    }
#HotIf
