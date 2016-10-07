#Include <GUIConstantsEx.au3>
#Include <WindowsConstants.au3>

$my_gui2 = GUICreate("MyGUI", 392, 323)
WinSetTrans($my_gui2, '', 128)
DllCall('uxtheme.dll', 'uint', 'SetWindowTheme', 'hwnd', $my_gui2, 'ptr', 0, 'wstr', '')
$my_gui = GUICreate("MyGUI", 392, 323, -1, -1, -1, -1, $my_gui2)
_GuiHole($my_gui, 0, 0, 100)
GUIRegisterMsg($WM_MOVE, 'WM_MOVE')
GUISetState(@SW_SHOW, $my_gui2)
GUISetState(@SW_SHOW, $my_gui)

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case Else
            ;;;
    EndSelect
WEnd
Exit

Func _GuiHole($h_win, $i_x, $i_y, $i_size)
    Dim $pos, $outer_rgn, $inner_rgn, $wh, $combined_rgn, $ret
    $pos = WinGetPos($h_win)

    $outer_rgn = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", $pos[2], "long", $pos[3])
    If IsArray($outer_rgn) Then
        $inner_rgn = DllCall("gdi32.dll", "long", "CreateEllipticRgn", "long", $i_x, "long", $i_y, "long", $i_x + $i_size, "long", $i_y + $i_size)
        If IsArray($inner_rgn) Then
            $combined_rgn = DllCall("gdi32.dll", "long", "CreateRectRgn", "long", 0, "long", 0, "long", 0, "long", 0)
            If IsArray($combined_rgn) Then
                DllCall("gdi32.dll", "long", "CombineRgn", "long", $combined_rgn[0], "long", $outer_rgn[0], "long", $inner_rgn[0], "int", 4)
                $ret = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $combined_rgn[0], "int", 9)
                If $ret[0] Then
                    Return 1
                Else
                    Return 0
                EndIf
            Else
                Return 0
            EndIf
        Else
            Return 0
        EndIf
    Else
        Return 0
    EndIf
EndFunc   ;==>_GuiHole

Func WM_MOVE($hWnd, $iMsg, $wParam, $lParam)
    Switch $hWnd
        Case $my_gui
            Local $Pos = WinGetPos($my_gui)
            If IsArray($Pos) Then
                WinMove($my_gui2, '', $Pos[0], $Pos[1], $Pos[2], $Pos[3])
            EndIf
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOVE