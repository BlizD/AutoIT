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

;_WinAPI_EmptyWorkingSet()

#EndRegion Initialization

#Region Body

While 1
    Sleep(100)
	If $Device Then
		$Device = 0
		$Data = $Volume
		For $i = 0 To 1
			$Volume[$i] = 0
		Next
		For $i = 0 To 1
			$Drive = _GetDriveLetter($Data[$i])
			For $j = 1 To $Drive[0]
				_USBLock($Drive[$j], $i)
			Next
		Next
	EndIf
	If $Unload Then
		Exit
	EndIf
WEnd


Func _GetDriveLetter($iMask)
	Local $Drive[27] = [0]
	If $iMask Then
		For $i = 0 To 25
			If BitAND(BitShift($iMask, $i), 1) Then
				$Drive[$Drive[0] + 1] = Chr(65 + $i) & ':'
				$Drive[0] += 1
			EndIf
		Next
	EndIf
	ReDim  $Drive[$Drive[0] + 1]
	Return $Drive
EndFunc   ;==>_GetDriveLetter




Func _USBLock($sVolume, $fRelease)

	Local $Index = Asc(StringUpper(StringLeft($sVolume, 1))) - 65

	If $fRelease Then
		If $hVolume[$Index] Then
			If _WinAPI_CloseHandle($hVolume[$Index]) Then
				$hVolume[$Index] = 0
			EndIf
		EndIf
		Return 1
	EndIf

	Switch _WinAPI_GetDriveBusType($sVolume)
		Case $DRIVE_BUS_TYPE_1394, $DRIVE_BUS_TYPE_USB
			;If _DriveIsValidate($sVolume) Then
			;	Return 0
			;EndIf
		Case Else
			Switch DriveGetType($sVolume)
				Case 'CDROM'
					If Not $Compact Then
						Return 0
					EndIf
				Case 'REMOVABLE'

				Case Else
					Return 0
			EndSwitch
	EndSwitch


	If $hVolume[$Index] Then
		_WinAPI_CloseHandle($hVolume[$Index])
	EndIf
	
	While 1
		$hVolume[$Index] = _WinAPI_CreateFileEx('\\.\' & $sVolume, 3, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE))
		;MsgBox(0, "Error", $sVolume)
		;RunWait (@ScriptDir & "\usr.exe stop -d " & $sVolume, @WindowsDir) 
		;MsgBox(0, "Error", @ScriptDir & "\usr.exe stop -d " & $sVolume)
		If Not @error Then
			If Not _WinAPI_DeviceIoControl($hVolume[$Index], $FSCTL_LOCK_VOLUME) Then
				MsgBox(0, "Error", $sVolume)
				If _WinAPI_CloseHandle($hVolume[$Index]) Then
					$hVolume[$Index] = 0
				EndIf
			Else
				Return 1
			EndIf
		EndIf
		If (Not $hVolume[$Index]) And (TimerDiff($Timer) > 5000) Then
			Return 0
		EndIf
		Sleep(100)
	WEnd
	
EndFunc   ;==>_USBLock

