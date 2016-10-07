#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

Global $iTimer = -1
Global $iTime_Expired = 2000

GUICreate("Input Changed GUI", 300, 140)

GUICtrlCreateLabel("You can set only numbers as 3 first characters:", 20, 40)
$Input = GUICtrlCreateInput("", 20, 70, 260, 20)

$Exit = GUICtrlCreateButton("Exit", 20, 100, 60, 20)

GUISetState()
;~ Opt("GUIOnEventMode", 1)
GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE, $Exit
            ExitLoop
    EndSwitch

    If $iTimer <> -1 And TimerDiff($iTimer) >= $iTime_Expired Then
        $iTimer = -1
        GUICtrlSetBkColor($Input, 0xFFFFFF)
    EndIf
WEnd

Func WM_COMMAND($hWnd, $nMsg, $wParam, $lParam)
    Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0xFFFF)
    Local $hCtrl = $lParam

    Switch $nID
        Case $Input
            Switch $nNotifyCode
                Case $EN_UPDATE
                    Local $sRead_Input = GUICtrlRead($Input)
                    Local $sFirstChars = StringLeft($sRead_Input, 3)
                    Local $sLastChars = ""
                    If StringLen($sRead_Input) > 3 Then $sLastChars = StringMid($sRead_Input, 4)

                    If Not StringIsDigit($sFirstChars) Then
                        ;Uncomment this line to set a "Beep Sound" on wrong set of characters
                        ;DllCall("User32.dll", "int", "MessageBeep", "int", -1)
                        $iTimer = TimerInit()

                        GUICtrlSetBkColor($Input, 0xFFCACA)
                        GUICtrlSetData($Input, StringRegExpReplace($sFirstChars, "[^\d]+", "") & $sLastChars)
                    Else
                        $iTimer = -1
                        GUICtrlSetBkColor($Input, 0xFFFFFF)
                    EndIf
                Case $EN_SETFOCUS

                Case $EN_KILLFOCUS

            EndSwitch
    EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc