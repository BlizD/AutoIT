#Include <Constants.au3>
#Include <GUIConstants.au3>
#Include <WinAPI.au3>
#Include <WindowsConstants.au3>

;~ $hForm = GUICreate('', 400, 400)
;~ $hHook = DllCallbackRegister('_WinProc', 'ptr', 'hwnd;uint;long;ptr')
;~ $pHook = DllCallbackGetPtr($hHook)
;~ $hProc = _WinAPI_SetWindowLong($hForm, $GWL_WNDPROC, $pHook)
GUISetState()
GUIRegisterMsg ( $WM_COPY, "MyUserFunction" )
Do
Until GUIGetMsg() = $GUI_EVENT_CLOSE

;~ _WinAPI_SetWindowLong($hForm, $GWL_WNDPROC, $hProc)
;~ DllCallBackFree($hProc)

;~ Func _WinProc($hWnd, $iMsg, $wParam, $lParam)

;~     Local $Res = _WinAPI_CallWindowProc($hProc, $hWnd, $iMsg, $wParam, $lParam)
;~     Local $hDC, $hSv, $oldMsg

;~     Select
;~         Case $iMsg = $WM_LBUTTONDOWN
;~             ToolTip($WM_LBUTTONDOWN)
;~         Case $iMsg = $WM_MOUSEMOVE
;~             ToolTip($WM_MOUSEMOVE)
;~         Case $iMsg = $WM_COPY
;~             ToolTip($WM_MOUSEMOVE)
;~ 			MsgBox(-1,"","asfd")
;~     EndSelect
;~     Return $Res
;~ EndFunc   ;==>_WinProc
Func MyUserFunction($hWndGUI, $MsgID, $WParam, $LParam)
 	MsgBox(-1,"","asfd")
EndFunc
