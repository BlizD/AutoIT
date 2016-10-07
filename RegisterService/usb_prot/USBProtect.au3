#cs ----------------------------------------------------------------------------

    AutoIt Version: 3.3.6.1
    Author:         Yashied

    Script Function:
	    (USBProtect v1.1) USB storages locker.

#ce ----------------------------------------------------------------------------

#Region AutoIt3Wrapper
;~#AutoIt3Wrapper_Icon=Resources\USBProtect.exe
#AutoIt3Wrapper_OutFile=Output\USBProtect.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Language=1033
;~#AutoIt3Wrapper_Res_Description=USB storages locker
;~#AutoIt3Wrapper_Res_Fileversion=1.1.0.1
;~#AutoIt3Wrapper_Res_LegalCopyright=©2009-2010 Yashied
;~#AutoIt3Wrapper_Res_Field=Original Filename|USBProtect.exe
;~#AutoIt3Wrapper_Res_Field=Product Name|USBProtect
;~#AutoIt3Wrapper_Res_Field=Product Version|1.1
#AutoIt3Wrapper_Run_Au3Check=n
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -addoverwrite %out%, %out%, Resources\USBProtect.res, VersionInfo, 1,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Dialog, 1000,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Menu, 166,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Icon, 162,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Icon, 164,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Icon, 169,
#AutoIt3Wrapper_Run_After=Utilities\ResHacker\ResHacker.exe -delete %out%, %out%, Icon, 99,
#EndRegion AutoIt3Wrapper

#Region Initialization

#NoTrayIcon

#Include <Crypt.au3>
#Include <WindowsConstants.au3>

#Include <UDFs\WinAPIEx.au3>

Opt('MustDeclareVars', 1)
Opt('WinTitleMatchMode', 3)
Opt('WinWaitDelay', 0)

Global Const $GUI_NAME = 'USBProtect'
Global Const $GUI_VERSION = '1.1'
;~Global Const $GUI_UNIQUE = $GUI_NAME & '_' & $GUI_VERSION & '_XupXp'
Global Const $GUI_UNIQUE = $GUI_NAME & '_XupXp'
Global Const $GUI_RECEIVER_NAME = $GUI_UNIQUE & '_#Receiver'

Global Const $DBT_DEVICEARRIVAL = 0x00008000
Global Const $DBT_DEVICEREMOVECOMPLETE = 0x00008004
Global Const $DBT_DEVTYP_VOLUME = 0x00000002

Global Const $WM_DEVICECHANGE = 0x0219

;~Global Const $MSG_VOLUME_LOCK = 0x0018
;~Global Const $MSG_VOLUME_UNLOCK = 0x001C
Global Const $MSG_UNLOAD = 0xFFFF

Global $Compact = False

_OSCheck()
;~_AdminPrivilegesCheck()
_CommandLineCheck()
_AutoItCheck()

;~_ScriptProtect()

Global $hForm = GUICreate($GUI_RECEIVER_NAME)
Global $hVolume[26] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $Data, $Drive, $Volume[2] = [_WinAPI_GetLogicalDrives(), 0]
Global $Device = 1, $Unload = 0

GUIRegisterMsg($WM_DEVICECHANGE, 'WM_DEVICECHANGE')
GUIRegisterMsg($WM_COPYDATA, 'WM_COPYDATA')

OnAutoItExitRegister('AutoItExit')

_WinAPI_EmptyWorkingSet()

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

#EndRegion Body

#Region Additional Functions

Func _AdminPrivilegesCheck()
	If Not IsAdmin() Then
		MsgBox(16, $GUI_NAME, 'You do not have administrator rights to run this program.')
		Exit
	EndIf
EndFunc   ;==>_AdminPrivilegesCheck

Func _AutoItCheck()

	Local $hWnd = WinGetHandle($GUI_UNIQUE)

	If Not $hWnd Then
		AutoItWinSetTitle($GUI_UNIQUE)
		Return
	EndIf
	Exit
EndFunc   ;==>_AutoItCheck

Func _CommandLineCheck()
	If $CmdLine[0] Then
		Switch $CmdLine[1]
			Case '-u', '/u', '-unload', '/unload'
				_SendMsg($MSG_UNLOAD)
				Exit
			Case '-c', '/c', '-cd', '/cd'
				$Compact = 1
			Case Else

		EndSwitch
	EndIf
EndFunc   ;==>_CommandLineCheck

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

Func _DriveIsValidate($sVolume)

	Local $ID

	If _DriveIsKnown($sVolume) Then
		$ID = _GetVolumeUniqueID($sVolume)
		If ($ID) And ($ID = _FileQueryVolumeID($sVolume & '\Volume.dat')) Then
			Return 1
		EndIf
	EndIf
	Return 0
EndFunc   ;==>_DriveIsValidate

Func _FileQueryVolumeID($sFile)

	Local $Mode = _WinAPI_SetErrorMode($SEM_FAILCRITICALERRORS)
	Local $ID = FileReadLine($sFile)

	_WinAPI_SetErrorMode($Mode)
	Return $ID
EndFunc   ;==>_FileQueryVolumeID

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

Func _OSCheck()
	If _WinAPI_GetVersion() < '6.0' Then
		MsgBox(16, $GUI_NAME, 'This program require Windows Vista or later.')
		Exit
	EndIf
EndFunc   ;==>_OSCheck

Func _SendMsg($iMsg, $sParam = '')

	Local $hWnd = WinGetHandle($GUI_RECEIVER_NAME)

	If Not $hWnd Then
		Return 0
	EndIf

	Local $tParam, $tData = DllStructCreate('ulong_ptr;dword;ptr')

	DllStructSetData($tData, 1, $iMsg)

	If $sParam Then
		$tParam = DllStructCreate('wchar[' & (StringLen($sParam) + 1) & ']')
		DllStructSetData($tData, 2, DllStructGetSize($tParam))
		DllStructSetData($tData, 3, DllStructGetPtr($tParam))
	Else
		DllStructSetData($tData, 2, 0)
		DllStructSetData($tData, 3, 0)
	EndIf

	Local $Ret = DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $hWnd, 'uint', $WM_COPYDATA, 'ptr', 0, 'ptr', DllStructGetPtr($tData))

	If (@error) Or (Not $Ret[0]) Then
		Return 0
	EndIf
	Return 1
EndFunc   ;==>_SendMsg

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
			If _DriveIsValidate($sVolume) Then
				Return 0
			EndIf
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

	Local $Timer = TimerInit()

	If $hVolume[$Index] Then
		_WinAPI_CloseHandle($hVolume[$Index])
	EndIf
	While 1
		$hVolume[$Index] = _WinAPI_CreateFileEx('\\.\' & $sVolume, 3, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE))
		If Not @error Then
			If Not _WinAPI_DeviceIoControl($hVolume[$Index], $FSCTL_LOCK_VOLUME) Then
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

#EndRegion Additional Functions

#Region Windows Message Functions

Func WM_COPYDATA($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $hForm

			Local $tData = DllStructCreate('ulong_ptr;dword;ptr', $lParam)
			Local $Msg = DllStructGetData($tData, 1)

			Switch $Msg
				Case $MSG_UNLOAD
					$Unload = 1
				Case Else

			EndSwitch
			Return 1
	EndSwitch
	Return 0
EndFunc   ;==>WM_COPYDATA

Func WM_DEVICECHANGE($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $hForm
			Switch $wParam
				Case $DBT_DEVICEARRIVAL, $DBT_DEVICEREMOVECOMPLETE

					Local $tDBV = DllStructCreate('dword Size;dword DeviceType;dword Reserved;dword Mask;ushort Flags', $lParam)
					Local $Type = DllStructGetData($tDBV, 'DeviceType')
					Local $Item

					Switch $Type
						Case $DBT_DEVTYP_VOLUME
							If Not DllStructGetData($tDBV, 'Flags') Then
								Switch $wParam
									Case $DBT_DEVICEARRIVAL
										$Item = 0
									Case Else
										$Item = 1
								EndSwitch
								$Volume[$Item] = BitOR($Volume[$Item], DllStructGetData($tDBV, 'Mask'))
								$Device = 1
							EndIf
						Case Else

					EndSwitch
			EndSwitch
	EndSwitch
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>WM_DEVICECHANGE

#EndRegion Windows Message Functions

#Region AutoIt Exit Functions

Func AutoItExit()
	For $i = 0 To 25
		If $hVolume[$i] Then
			_WinAPI_CloseHandle($hVolume[$i])
		EndIF
	Next
EndFunc   ;==>AutoItExit

#EndRegion AutoIt Exit Functions
