#include <GUIConstantsEx.au3>
#include <Date.au3>

Example()

Func Example()
    Local $Date, $msg
    GUICreate("Get date", 190, 230)
    $Date = GUICtrlCreateMonthCal(_NowDate(), 10, 10, 170, 170)
    $Input = GUICtrlCreateInput('', 10, 190, 170, 18)
    GUISetState()
    Do
        $msg = GUIGetMsg()
        If $msg = $Date Then
            $sDate = _DateTimeFormat(GUICtrlRead($Date), 2)
;~ 			ConsoleWrite("" & $sDate)
            GUICtrlSetData($Input, $sDate & " 00:00:00")
        EndIf
    Until $msg = $GUI_EVENT_CLOSE
EndFunc   ;==>Example