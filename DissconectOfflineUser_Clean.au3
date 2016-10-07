Global Const $tagWTS_SESSION_INFO = 'dword SessionId;ptr WinStationName;uint State'
$Ret = DllCall('wtsapi32.dll', 'int', 'WTSEnumerateSessionsW', 'ptr', 0, 'dword', 0, 'dword', 1, 'ptr*', 0, 'dword*', 0)
$Offset = 0
For $i = 1 To $Ret[5]
    $tInfo = DllStructCreate($tagWTS_SESSION_INFO, $Ret[4] + $Offset)
    $Offset += DllStructGetSize($tInfo)
	$WinStationName=DllStructGetData(DllStructCreate('wchar[1024]', DllStructGetData($tInfo, 'WinStationName')), 1)
	$SessionId=DllStructGetData($tInfo, 'SessionId')
	$State=DllStructGetData($tInfo, 'State')
	if StringLen($WinStationName)=0 AND StringInStr($State,"4")>0 then
 		$RetSes = DllCall('wtsapi32.dll', 'int', 'WTSLogoffSession', "hwnd", 0, 'dword',DllStructGetData($tInfo, 'SessionId'),'bool', False)
	endif
Next
DllCall('wtsapi32.dll', 'none', 'WTSFreeMemory', 'ptr', $Ret[4])
