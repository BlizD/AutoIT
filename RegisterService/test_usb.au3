#Include <WinAPIEx.au3>

Opt('MustDeclareVars', 1)
Opt('TrayAutoPause', 0)

Global Const $DBT_DEVICEARRIVAL = 0x00008000
Global Const $DBT_DEVICEREMOVECOMPLETE = 0x00008004
Global Const $DBT_DEVTYP_VOLUME = 0x00000002
Global $hVolume[26] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global Const $WM_DEVICECHANGE = 0x0219

Global $hForm = GUICreate('')
Global $Drives, $Volume = _WinAPI_GetLogicalDrives()
Global $Device = 1

GUIRegisterMsg($WM_DEVICECHANGE, 'WM_DEVICECHANGE')

While 1
    Sleep(100)
    If $Device Then
        $Drives = _GetDriveLetter($Volume)
        $Device = 0
        $Volume = 0
        For $j = 1 To $Drives[0]
			;MsgBox(0, "Error", $Drives[$j]) ; 
            _USBLock($Drives[$j], $j)
        Next
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
    ReDim $Drive[$Drive[0] + 1]
    Return $Drive
EndFunc   ;==>_GetDriveLetter

Func _USBLock($sVolume, $fRelease)

	Local $Index = Asc(StringUpper(StringLeft($sVolume, 1))) - 65
   MsgBox(0, $sVolum, $Index) 
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

Func _USBCheck($sVolume)

    Local $hDrive, $tData, $iBus, $iRes, $Fs

    $iBus = _WinAPI_GetDriveBusType($sVolume)
    Switch $iBus
        Case $DRIVE_BUS_TYPE_USB
            $hDrive = _WinAPI_CreateFileEx('\\.\' & $sVolume, 3, 0, 0)
            If Not $hDrive Then
                Return
            EndIf
            $tData = DllStructCreate('dword DeviceType;ulong DeviceNumber;ulong PartitionNumber')
            $iRes = _WinAPI_DeviceIoControl($hDrive, $IOCTL_STORAGE_GET_DEVICE_NUMBER, 0, 0, DllStructGetPtr($tData), DllStructGetSize($tData))
            _WinAPI_CloseHandle($hDrive)
            If (Not $iRes) Or (Not (DllStructGetData($tData, 'DeviceType') = 7)) Then
                Return
            EndIf
;~          $Fs = DriveGetFileSystem($sVolume)
;~          Switch $Fs
;~              Case 'FAT32', 'NTFS'
;~
;~              Case Else
;~                  Return
;~          EndSwitch
        Case Else
            Return
    EndSwitch
    ConsoleWrite('USB device found: ' & $sVolume & @CR)
EndFunc   ;==>_USBCheck

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
                                        $Volume = BitOR($Volume, DllStructGetData($tDBV, 'Mask'))
                                        $Device = 1
                                    Case Else

                                EndSwitch
                            EndIf
                        Case Else

                    EndSwitch
            EndSwitch
    EndSwitch
    Return 'GUI_RUNDEFMSG'
EndFunc   ;==>WM_DEVICECHANGE