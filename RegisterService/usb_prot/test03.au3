#Include <Crypt.au3>
#Include <WindowsConstants.au3>
#Include <UDFs\WinAPIEx.au3>

Global Const $DBT_DEVICEARRIVAL = 0x00008000
Global Const $DBT_DEVICEREMOVECOMPLETE = 0x00008004
Global Const $DBT_DEVTYP_VOLUME = 0x00000002

Global Const $WM_DEVICECHANGE = 0x0219

;~Global Const $MSG_VOLUME_LOCK = 0x0018
;~Global Const $MSG_VOLUME_UNLOCK = 0x001C
Global Const $MSG_UNLOAD = 0xFFFF

Global $Compact = False



;~_ScriptProtect()

;Global $hForm = GUICreate($GUI_RECEIVER_NAME)
Global $hVolume[26] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $Data, $Drive, $Volume[2] = [_WinAPI_GetLogicalDrives(), 0]
Global $Device = 1, $Unload = 0
;DriveStatus('H:')
;MsgBox(0, "test",DriveStatus('g:'))
If $cmdline[0] > 0 Then
	        				Run (@ScriptDir & "\sunc.exe -r " & $cmdline[1], @WindowsDir, @SW_HIDE);
				;Sleep(30)
				Run(@ScriptDir & "\usr.exe forcedstop -d " & $cmdline[1], @WindowsDir) ;, @SW_HIDE    
	While 1
	    ;MsgBox(0, "test",$cmdline[1])
		;MsgBox(0, "test",DriveStatus($cmdline[1]))
		If (DriveStatus($cmdline[1])= 'READY' OR DriveStatus($cmdline[1])= 'UNKNOWN') Then
		    ;MsgBox(0, "test",DriveStatus('H:'))

			$a = _WinAPI_CreateFileEx('\\.\' & $cmdline[1], 3, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE))
	        _WinAPI_DeviceIoControl($a, $FSCTL_LOCK_VOLUME)
	    Else
		    Exit
		EndIf  
	WEnd	
EndIf