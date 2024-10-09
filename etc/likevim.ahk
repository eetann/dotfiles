SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

; Auto execute section is the region before any return/hotkey
GroupAdd("browser", "ahk_exe chrome.exe")
GroupAdd("browser", "ahk_exe vivaldi.exe")

; Win + r に`shll:startup`を実行して作成されたフォルダに、
; このファイルのショートカットを入れる

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
; Kanji - > F14 （キー割当画面右上のScan Codeより"0x0065"を割り当てる）
; CTRL_L -> WIN
; WIN -> CTRL_L
; ref: https://github.com/matatabi3/autohotkey/blob/5b4948fdc0e7bf5aebb87780446efa24dc7167d3/AutoHotkey.ahk
F13 & Enter::Send "{Blind}^{Enter}"
F13 & Space::Send "{Blind}^{Space}"
F13 & Tab::Send "{Blind}^{Tab}"
F13 & BS::Send "{Blind}^{BS}"
F13 & Del::Send "{Blind}^{Del}"
F13 & Ins::Send "{Blind}^{Ins}"
F13 & Up::Send "{Blind}^{Up}"
F13 & Down::Send "{Blind}^{Down}"
F13 & Left::Send "{Blind}^{Left}"
F13 & Right::Send "{Blind}^{Right}"
F13 & Home::Send "{Blind}^{Home}"
F13 & End::Send "{Blind}^{End}"
F13 & PgUp::Send "{Blind}^{PgUp}"
F13 & PgDn::Send "{Blind}^{PgDn}"
F13 & AppsKey::Send "{Blind}^{AppsKey}"
F13 & PrintScreen::Send "{Blind}^{PrintScreen}"
F13 & CtrlBreak::Send "{Blind}^{CtrlBreak}"
F13 & Pause::Send "{Blind}^{Pause}"
F13 & Esc::Send "{Blind}^{Esc}"
F13 & F1::Send "{Blind}^F1"
F13 & F2::Send "{Blind}^F2"
F13 & F3::Send "{Blind}^F3"
F13 & F4::Send "{Blind}^F4"
F13 & F5::Send "{Blind}^F5"
F13 & F6::Send "{Blind}^F6"
F13 & F7::Send "{Blind}^F7"
F13 & F8::Send "{Blind}^F8"
F13 & F9::Send "{Blind}^F9"
F13 & F10::Send "{Blind}^F10"
F13 & F11::Send "{Blind}^F11"
F13 & F12::Send "{Blind}^F12"
F13 & sc029::Send "{Blind}^{sc029}"
F13 & 1::Send "{Blind}^1"
F13 & 2::Send "{Blind}^2"
F13 & 3::Send "{Blind}^3"
F13 & 4::Send "{Blind}^4"
F13 & 5::Send "{Blind}^5"
F13 & 6::Send "{Blind}^6"
F13 & 7::Send "{Blind}^7"
F13 & 8::Send "{Blind}^8"
F13 & 9::Send "{Blind}^9"
F13 & 0::Send "{Blind}^0"
F13 & -::Send "{Blind}^-"
F13 & q::Send "{Blind}^q"
F13 & w::Send "{Blind}^w"
F13 & r::Send "{Blind}^r"
F13 & t::Send "{Blind}^t"
F13 & y::Send "{Blind}^y"
F13 & u::Send "{Blind}^u"
F13 & i::Send "{Blind}^i"
F13 & o::Send "{Blind}^o"
F13 & {::Send "{Blind}^{[}"
F13 & }::Send "{Blind}^{]}"
F13 & \::Send "{Blind}^{\}"
F13 & s::Send "{Blind}^s"
F13 & g::Send "{Blind}^g"
F13 & j::Send "{Blind}^j"
F13 & l::Send "{Blind}^l"
F13 & sc027::Send "{Blind}^{sc027}"
F13 & '::Send "{Blind}^'"
F13 & z::Send "{Blind}^z"
F13 & x::Send "{Blind}^x"
F13 & c::Send "{Blind}^c"
F13 & v::Send "{Blind}^v"
F13 & m::Send "{Blind}{Enter}"
F13 & ,::Send "{Blind}^,"
F13 & .::Send "{Blind}^."
F13 & /::Send "{Blind}^/"

F13 & LButton::Send "{Blind}^{LButton}"
F13 & RButton::Send "{Blind}^{RButton}"
F13 & MButton::Send "{Blind}^{MButton}"
F13 & WheelDown::Send "{Blind}^{WheelDown}"
F13 & WheelUp::Send "{Blind}^{WheelUp}"
F13 & WheelLeft::Send "{Blind}^{WheelLeft}"
F13 & WheelRight::Send "{Blind}^{WheelRight}"
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
;-----------------------------------------------------------
#HotIf WinActive("ahk_exe wezterm-gui.exe")
F13 & a::Send("{Blind}^a")
F13 & e::Send("{Blind}^e")
F13 & d::Send("{Blind}^d")
F13 & h::Send("{Blind}^h")
F13 & f::Send("{Blind}^f")
F13 & b::Send("{Blind}^b")
F13 & p::Send("{Blind}^p")
F13 & n::Send("{Blind}^n")
F13 & k::Send("{Blind}^k")
; ターミナルでvimのためのIME
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
