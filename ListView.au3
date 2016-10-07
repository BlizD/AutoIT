; example of tooltip for multiline text items
;   by GreenCan

#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>

Global $iLastItem = -1, $iLastsubitemNR = -1

$GUI = GUICreate("Listview ToolTip for multiline cells")

$hListView = GUICtrlCreateListView("Column 1", 10, 10, 380, 380, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))

; fill with example data
; Add columns
_GUICtrlListView_AddColumn($hListView, "Column 2", 100)
_GUICtrlListView_AddColumn($hListView, "Column 3", 150)

; Add some rows
_GUICtrlListView_AddItem($hListView, "A1", 0)
_GUICtrlListView_AddSubItem($hListView, 0, "A2" & "\n" & "Example of multiline text", 1)
_GUICtrlListView_AddSubItem($hListView, 0, "A3" & "\n" & "Example of multiline text" & "\n" & "3rd line", 2)

_GUICtrlListView_AddItem($hListView, "B1", 1)
_GUICtrlListView_AddSubItem($hListView, 1, "B2" & "\n" & "Line 2" & "\n" & "Line 3" & "\n" & "Line 4", 1)
_GUICtrlListView_AddSubItem($hListView, 1, "B3", 2)

_GUICtrlListView_AddItem($hListView, "C1")
_GUICtrlListView_AddSubItem($hListView, 2, "C2" & "\n" & "Another multiline text", 1)
_GUICtrlListView_AddSubItem($hListView, 2, "C3" & "\n" & "Another Example of multiline text", 2)
; done

GUISetState()
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            GUIDelete($GUI)
            Exit
    EndSwitch
WEnd

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView
    $hWndListView = $hListView
    If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

    $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")

    Switch $hWndFrom
        Case $hWndListView
            Switch $iCode
                ;Case $NM_CLICK ; when clicking on a cell that is multiline, a tooltip will display the content
                Case $LVN_HOTTRACK; Sent by a list-view control when the user moves the mouse over an item
                    Local $tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
                    Local $iItem = DllStructGetData($tInfo, "Item")
                    Local $subitemNR = DllStructGetData($tInfo, "SubItem")

                    ; if no cell change return without doing anything
                    If $iLastItem = $iItem And $iLastsubitemNR = $subitemNR Then Return 0
                    $iLastItem = $iItem
                    $iLastsubitemNR = $subitemNR

                    Local $sToolTipData = StringReplace(_GUICtrlListView_GetItemText($hListView, $iItem, $subitemNR), "\n", @CRLF)

                    If @extended Then
                        ToolTip($sToolTipData, MouseGetPos(0) + 20, MouseGetPos(1) + 20)
                    Else
                        ToolTip("")
                        ConsoleWrite("R" & $iItem & "C" & $iLastsubitemNR & " No tip" & @CR)
                    EndIf
            EndSwitch
    EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc