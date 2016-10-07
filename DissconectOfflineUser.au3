#include <Date.au3>
Global Const $tagWTS_SESSION_INFO = 'dword SessionId;ptr WinStationName;uint State'

$Ret = DllCall('wtsapi32.dll', 'int', 'WTSEnumerateSessionsW', 'ptr', 0, 'dword', 0, 'dword', 1, 'ptr*', 0, 'dword*', 0)
if @error <> 0 then
	WriteLog("@error "& @error & @CRLF & "- logoff: "& $Ret[0],"log1.txt",1)
EndIf

$Offset = 0
For $i = 1 To $Ret[5]
    $tInfo = DllStructCreate($tagWTS_SESSION_INFO, $Ret[4] + $Offset)
    $Offset += DllStructGetSize($tInfo)

;~     ConsoleWrite('SessionId:      ' & DllStructGetData($tInfo, 'SessionId') & @CR)
;~     ConsoleWrite('WinStationName: ' & DllStructGetData(DllStructCreate('wchar[1024]', DllStructGetData($tInfo, 'WinStationName')), 1) & @CR)
;~     ConsoleWrite('State:          ' & DllStructGetData($tInfo, 'State') & @CR)
;~     ConsoleWrite('--------------' & @CR)
	$WinStationName=DllStructGetData(DllStructCreate('wchar[1024]', DllStructGetData($tInfo, 'WinStationName')), 1)
	$SessionId=DllStructGetData($tInfo, 'SessionId')

	$State=DllStructGetData($tInfo, 'State')
;~  	if $WinStationName="RDP-Tcp" then
;~ 	if StringInStr($WinStationName,"RDP-Tcp")>0 AND StringInStr($WinStationName,"#")=0 then
	if StringLen($WinStationName)=0 AND StringInStr($State,"4")>0 then
;~ 		WriteLog( $SessionId & "  -   " & $WinStationName & " - " & DllStructGetData($tInfo, 'State'),"log1.txt",1)
;~ 		MsgBox(-1,"",DllStructGetData($tInfo, 'SessionId') & "  -   " & $WinStationName & " - " & DllStructGetData($tInfo, 'State'))
 		$RetSes = DllCall('wtsapi32.dll', 'int', 'WTSLogoffSession', "hwnd", 0, 'dword',DllStructGetData($tInfo, 'SessionId'),'bool', False)
;~ 		$RetSes = DllCall('wtsapi32.dll', 'int', 'WTSLogoffSession', "hwnd", 0, 'dword','3','bool', False)
;~ 		$RetSes = DllCall('wtsapi32.dll', 'int', 'WTSLogoffSession', "hwnd", 'WTS_CURRENT_SERVER_HANDLE', 'dword',DllStructGetData($tInfo, 'SessionId'),'bool', False)
		if @error <> 0 then
			WriteLog("@error "& @error & @CRLF & $SessionId & "- logoff: "& $RetSes[0],"log1.txt",1)
		EndIf
;~ 		WriteLog("@error "& @error & @CRLF & $SessionId & "- logoff: ","log1.txt",1)
;~ 		WriteLog(DllCall('wtsapi32.dll', 'DWORD', 'GetLastError'),"log1.txt",1)
;~ 		GetLastError
	endif


Next

DllCall('wtsapi32.dll', 'none', 'WTSFreeMemory', 'ptr', $Ret[4])

Func WriteLog($Text,$NameLog,$Mode)
	$Path="D:\"
	$Time=_Date_Time_GetLocalTime()
	$Time=_Date_Time_SystemTimeToDateTimeStr($Time)
	$logfile = FileOpen($Path & $NameLog, $Mode)
	FileWriteLine($logfile,$Time & "-" & $Text)
	FileClose($logfile)
EndFunc