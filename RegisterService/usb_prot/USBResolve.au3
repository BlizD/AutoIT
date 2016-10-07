#cs ----------------------------------------------------------------------------

    AutoIt Version: 3.3.6.1
    Author:         Yashied

    Script Function:
	    (USBResolve v1.1) Allowing access to USB drives

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper
#AutoIt3Wrapper_Icon=Resources\USBResolve.ico
#AutoIt3Wrapper_OutFile=Output\USBResolve.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Language=1033
;~#AutoIt3Wrapper_Res_Description=Allowing access to USB devices
;~#AutoIt3Wrapper_Res_Fileversion=1.1.0.1
;~#AutoIt3Wrapper_Res_LegalCopyright=©2009-2010 Yashied
;~#AutoIt3Wrapper_Res_Field=Original Filename|USBResolve.exe
;~#AutoIt3Wrapper_Res_Field=Product Name|USBResolve
;~#AutoIt3Wrapper_Res_Field=Product Version|1.1
#AutoIt3Wrapper_Run_Au3Check=n
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -addoverwrite %out%, %out%, Resources\USBResolve.res, VersionInfo, 1,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Dialog, 1000,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Menu, 166,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Icon, 162,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Icon, 164,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Icon, 169,
#EndRegion AutoIt3Wrapper

#Region Initialization

#NoTrayIcon

#Include <ComboConstants.au3>
#Include <Crypt.au3>
#Include <EditConstants.au3>
#Include <GUIComboBox.au3>
#Include <GUIConstantsEx.au3>

#Include <UDFs\WinAPIEx.au3>

Opt('MustDeclareVars', 1)
Opt('WinTitleMatchMode', 3)
Opt('WinWaitDelay', 0)

Global Const $GUI_NAME = 'USBResolve'
Global Const $GUI_VERSION = '1.1'
;~Global Const $GUI_UNIQUE = $GUI_NAME & '_' & $GUI_VERSION & '_OwrXp'
Global Const $GUI_UNIQUE = $GUI_NAME & '_OwrXp'

Global Const $DBT_DEVICEARRIVAL = 0x00008000
Global Const $DBT_DEVICEREMOVECOMPLETE = 0x00008004
Global Const $DBT_DEVTYP_VOLUME = 0x00000002

Global Const $WM_DEVICECHANGE = 0x0219

Dim $Drive[1][6] = [[0, 0]]

#cs

$Drive[0][0]   - Number of items in array
      [0][1]   - Index (zero based) of current selected item in ComboBox control
      [0][2-5] - Don't used

$Drive[i][0]   - Drive letter ("X:")
      [i][1]   - Label
      [i][2]   - Size, in bytes
      [i][3]   - Unique ID ("XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
      [i][4]   - Status (0 - Deny; 1 - Allow)
      [i][5]   - Reserved
#ce

_AutoItCheck()

Global $hForm, $Msg, $Combo, $hCombo, $Label1, $Label2, $Button
Global $Device = False, $Select = True, $Start = True, $Update = True
Global $Error, $Label, $List, $Data, $Prev

GUIRegisterMsg($WM_DEVICECHANGE, 'WM_DEVICECHANGE')

#EndRegion Initialization

#Region Body

_GUICreate()

While 1
	If $Device Then
		If WinExists('USBProtect_XupXp') Then
			Sleep(1000)
		EndIf
		$Device = 0
		$Update = 1
	EndIf
	If $Update Then
		_GUICtrlComboBox_BeginUpdate($Combo)
		_GUICtrlComboBox_GetLBText($hCombo, $Drive[0][1], $Prev)
		_GUICtrlComboBox_ResetContent($Combo)
		ReDim $Drive[1][UBound($Drive, 2)]
		$Drive[0][0] = 0
		$Drive[0][1] = 0
		$List = DriveGetDrive('ALL')
		If IsArray($List) Then
			For $i = 1 To $List[0]
				$List[$i] = StringUpper($List[$i])
				Switch _WinAPI_GetDriveBusType($List[$i])
					Case $DRIVE_BUS_TYPE_1394, $DRIVE_BUS_TYPE_USB
						If (_DriveIsAccessible($List[$i])) And (_DriveIsKnown($List[$i])) Then
							$Data = _GetVolumeInfo($List[$i])
							If Not IsArray($Data) Then
								ContinueLoop
							Endif
							If Not $Data[0] Then
								$Label = 'Removable Disk'
							Else
								$Label = $Data[0]
							EndIf
							_GUICtrlComboBox_AddString($Combo, $Label & ' (' & $List[$i] & '), ' & _Size($Data[1]))
							$Drive[0][0] += 1
							ReDim $Drive[$Drive[0][0] + 1][UBound($Drive, 2)]
							$Drive[$Drive[0][0]][0] = $List[$i]
							For $j = 1 To 4
								$Drive[$Drive[0][0]][$j] = $Data[$j - 1]
							Next
						EndIf
				EndSwitch
			Next
		EndIf
		$Data = _GUICtrlComboBox_FindString($Combo, $Prev)
		If $Data > -1 Then
			$Drive[0][1] = $Data
		EndIf
		_GUICtrlComboBox_EndUpdate($Combo)
		_GUICtrlComboBox_SetCurSel($Combo, $Drive[0][1])
		_WinAPI_InvalidateRect($hCombo)
		$Select = 1
		$Device = 0
		$Update = 0
	EndIf
	If $Select Then
		If Not $Drive[0][0] Then
			GUICtrlSetState($Button, $GUI_DISABLE)
			GUICtrlSetState($Combo, $GUI_DISABLE)
			GUICtrlSetData($Label1, '-')
			GUICtrlSetData($Label2, '-')
			GUICtrlSetColor($Label2, 0)
		Else
			GUICtrlSetState($Button, $GUI_ENABLE)
			GUICtrlSetState($Combo, $GUI_ENABLE)
			GUICtrlSetData($Label1, $Drive[$Drive[0][1] + 1][3])
			If $Drive[$Drive[0][1] + 1][4] Then
				GUICtrlSetData($Label2, 'ALLOW')
				GUICtrlSetColor($Label2, 0x00AF00)
			Else
				GUICtrlSetData($Label2, 'DENY')
				GUICtrlSetColor($Label2, 0xEA0000)
			EndIf
		EndIf
		$Select = 0
	EndIf
	If $Start Then
		GUISetState(@SW_SHOW, $hForm)
		$Start = 0
	EndIf
	$Msg = GUIGetMsg()
	Switch $Msg
		Case 0
			ContinueLoop
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Combo
			$Drive[0][1] = _GUICtrlComboBox_GetCurSel($Combo)
			$Select = 1
		Case $Button
			If Not _DriveIsAccessible($Drive[$Drive[0][1] + 1][0]) Then
				MsgBox(16, $GUI_NAME, 'Access to drive ' & $Drive[$Drive[0][1] + 1][0] & '\ is denied.', 0, $hForm)
				$Update = 1
				ContinueLoop
			EndIf
			$Error = 0
			$Data = _GetVolumeInfo($Drive[$Drive[0][1] + 1][0])
			If Not IsArray($Data) Then
				$Error = 1
			Else
				For $i = 1 To 4
					If $Drive[$Drive[0][1] + 1][$i] <> $Data[$i - 1] Then
						$Error = 1
						ExitLoop
					EndIf
				Next
			EndIf
			If $Error Then
				MsgBox(16, $GUI_NAME, 'Drive ' & $Drive[$Drive[0][1] + 1][0] & '\ or some its parameters has been changed. Try again to select it from the list.', 0, $hForm)
				$Update = 1
				ContinueLoop
			EndIf
			$Drive[$Drive[0][1] + 1][4] = Not $Drive[$Drive[0][1] + 1][4]
			If _USBResolve($Drive[$Drive[0][1] + 1][0], $Drive[$Drive[0][1] + 1][4]) Then
				$Select = 1
			Else
				Switch @error
					Case 1
						MsgBox(16, $GUI_NAME, 'Unable to change status for drive ' & $Drive[$Drive[0][1] + 1][0] & '\.', 0, $hForm)
						$Update = 1
					Case 2
						MsgBox(16, $GUI_NAME, 'Access to drive ' & $Drive[$Drive[0][1] + 1][0] & '\ is denied.', 0, $hForm)
						$Update = 1
					Case Else

				EndSwitch
			EndIf
	EndSwitch
WEnd

#EndRegion Body

#Region Additional Functions

Func _AutoItCheck()

	Local $hWnd = WinGetHandle($GUI_UNIQUE)

	If Not $hWnd Then
		AutoItWinSetTitle($GUI_UNIQUE)
		Return
	EndIf

	Local $PID, $List

	$PID = WinGetProcess($hWnd)
	If $PID > -1 Then
		$List = _WinAPI_EnumProcessWindows($PID, 0)
		If IsArray($List) Then
			For $i = 1 To $List[0][0]
				If WinGetTitle($List[$i][0]) = $GUI_NAME Then
					WinActivate($List[$i][0])
					ExitLoop
				EndIf
			Next
		EndIf
	EndIf
	Exit
EndFunc   ;==>_AutoItCheck

Func _DriveIsAccessible($sVolume)

	Local $hFile = _WinAPI_CreateFileEx('\\.\' & $sVolume, 3, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE))

	If $hFile Then
		_WinAPI_CloseHandle($hFile)
		Return 1
	EndIf
	Return 0
EndFunc   ;==>_DriveIsAccessible

Func _DriveIsKnown($sVolume)

	Local $hDrive = _WinAPI_CreateFileEx('\\.\' & $sVolume, 3, 0, 0)

	If Not $hDrive Then
		Return 0
	EndIf

	Local $tData = DllStructCreate('dword DeviceType;ulong DeviceNumber;ulong PartitionNumber')
	Local $iRes = _WinAPI_DeviceIoControl($hDrive, $IOCTL_STORAGE_GET_DEVICE_NUMBER, 0, 0, DllStructGetPtr($tData), DllStructGetSize($tData))

	_WinAPI_CloseHandle($hDrive)

	If (Not $iRes) Or (Not (DllStructGetData($tData, 'DeviceType') = 7)) Then
		Return 0
	EndIf

	Local $FS = DriveGetFileSystem($sVolume)

	Switch $FS
		Case 'FAT32', 'NTFS'
			Return 1
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>_DriveIsKnown

Func _FileQueryVolumeID($sFile)

	Local $Mode = _WinAPI_SetErrorMode($SEM_FAILCRITICALERRORS)
	Local $ID = FileReadLine($sFile)

	_WinAPI_SetErrorMode($Mode)
	Return $ID
EndFunc   ;==>_FileQueryVolumeID

Func _GetVolumeInfo($sVolume)

	Local $Data, $Info[4]

	$Info[0] = DriveGetLabel($sVolume)
	If @error Then
		Return 0
	EndIf
	$Data = _WinAPI_GetDiskFreeSpaceEx($sVolume)
	If @error Then
		Return 0
	EndIf
	$Info[1] = $Data[1]
	$Info[2] = _GetVolumeUniqueID($sVolume)
	If Not $Info[2] Then
		Return 0
	EndIf
	$Data = _FileQueryVolumeID($sVolume & '\Volume.dat')
	If $Info[2] = $Data Then
		$Info[3] = 1
	Else
		$Info[3] = 0
	EndIf
	Return $Info
EndFunc   ;==>_GetVolumeInfo

Func _GetVolumeUniqueID($sVolume)

	Local $Serial = DriveGetSerial($sVolume)

	If @error Then
		Return ''
	EndIf

	Local $Hash = StringTrimLeft(_Crypt_HashData($Serial, $CALG_MD5), 2)

    If $Hash Then
		Return StringMid($Hash, 1, 8) & '-' & StringMid($Hash, 9, 4) & '-' & StringMid($Hash, 13, 4) & '-' & StringMid($Hash, 17, 4) & '-' & StringMid($Hash, 21, 12)
    Else
        Return ''
    EndIf
EndFunc   ;==>_GetVolumeUniqueID

Func _GUICreate()

	$hForm = GUICreate($GUI_NAME, 342, 146)

	GUISetFont(8.5, 400, 0, 'Tahoma')
	GUICtrlCreateLabel('Volume:', 20, 24, 40, 14)
	GUICtrlCreateLabel('ID:', 20, 58, 40, 14)
	$Label1 = GUICtrlCreateInput('', 62, 58, 230, 14, BitOR($ES_AUTOHSCROLL, $ES_LEFT, $ES_READONLY), 0)
	GUICtrlCreateLabel('Status:', 20, 80, 40, 14)
	$Label2 = GUICtrlCreateLabel('', 62+2, 80, 50, 14)
	GUICtrlSetFont(-1, 8.5, 800)
	$Combo = GUICtrlCreateCombo('', 62, 20, 260, 160, $CBS_DROPDOWNLIST)
	$hCombo = GUICtrlGetHandle(-1)
	GUICtrlSetState(-1, $GUI_FOCUS)
	_GUICtrlComboBox_SetCueBanner($Combo, 'None')
	$Button = GUICtrlCreateButton('Change Status', 223, 110, 100, 23)
;~	GUICtrlSetFont(-1, 8.5, 800)

;~	GUISetState()

EndFunc   ;==>_GUICreate

Func _Size($iSize)

	Local $Unit[4] = [' KB', ' MB', ' GB', ' TB']
	Local $Div = -1

	Do
		$iSize /= 1024
		$Div += 1
	Until ($iSize < 1) Or ($Div > 3)
	If $Div Then
		Return Round($iSize * 1024, 1) & $Unit[$Div - 1]
	Else
		Return Round($iSize, 2) & ' KB'
	EndIf
EndFunc   ;==>_Size

Func _USBResolve($sVolume, $fAllow)

;~	If Not _DriveIsAccessible($sVolume) Then
;~		Return SetError(2, 0, 0)
;~	EndIf

	Local $ID

	If $fAllow Then
		$ID = _GetVolumeUniqueID($sVolume)
		If Not $ID Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $tData = DllStructCreate('wchar[' & StringLen($ID) & ']')
	Local $iMode = _WinAPI_SetErrorMode($SEM_FAILCRITICALERRORS)
	Local $hFile = 0, $ID, $Bytes, $Error = 1
	Local $sFile = $sVolume & '\Volume.dat'

	Do
		If FileExists($sFile) Then
			If Not _WinAPI_SetFileAttributes($sFile, BitOR($FILE_ATTRIBUTE_ARCHIVE, $FILE_ATTRIBUTE_HIDDEN)) Then
				ExitLoop
			EndIf
			If Not _WinAPI_DeleteFile($sFile) Then
				ExitLoop
			EndIf
		EndIf
		If $fAllow Then
			$hFile = _WinAPI_CreateFileEx($sFile, $CREATE_ALWAYS, BitOR($GENERIC_READ, $GENERIC_WRITE), 0, BitOR($FILE_ATTRIBUTE_ARCHIVE, $FILE_ATTRIBUTE_HIDDEN, $FILE_ATTRIBUTE_READONLY, $FILE_ATTRIBUTE_SYSTEM, $FILE_FLAG_WRITE_THROUGH))
			If Not $hFile Then
				ExitLoop
			EndIf
			DllStructSetData($tData, 1, $ID)
			If Not _WinAPI_WriteFile($hFile, DllStructGetPtr($tData), DllStructGetSize($tData), $Bytes) Then
				ExitLoop
			EndIf
		EndIf
		$Error = 0
	Until 1
	If $Error Then
		Switch _WinAPI_GetLastError()
			Case 5 ; ERROR_ACCESS_DENIED
				$Error = 2
			Case Else
				$Error = 1
		EndSwitch
	EndIf
	If $hFile Then
		_WinAPI_CloseHandle($hFile)
	EndIf
	_WinAPI_SetErrorMode($iMode)
	If $Error Then
		Return SetError($Error, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_USBResolve

#EndRegion Additional Functions

#Region Windows Message Functions

Func WM_DEVICECHANGE($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $hForm
			Switch $wParam
				Case $DBT_DEVICEARRIVAL, $DBT_DEVICEREMOVECOMPLETE

					Local $tDBV = DllStructCreate('dword Size;dword DeviceType;dword Reserved;dword Mask;ushort Flags', $lParam)
					Local $Type = DllStructGetData($tDBV, 'DeviceType')

					Switch $Type
						Case $DBT_DEVTYP_VOLUME
							If (DllStructGetData($tDBV, 'Mask')) And (Not DllStructGetData($tDBV, 'Flags')) Then
								Switch $wParam
									Case $DBT_DEVICEARRIVAL
										$Device = 1
									Case Else
										$Update = 1
								EndSwitch
							EndIf
						Case Else

					EndSwitch
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_DEVICECHANGE

#EndRegion Windows Message Functions
