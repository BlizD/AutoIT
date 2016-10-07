#Include <Security.au3>

$list = ProcessList()
For $i = 1 to $list[0][0]
  ConsoleWrite($list[$i][0] &" : "&  _GetProcessUser($list[$i][1]) & @CRLF)
Next

Func _GetProcessUser($PID)

$WTS_PROCESS_INFO= "DWORD SessionId; DWORD ProcessId; PTR pProcessName; PTR pUserSid"
$aDllRet=DllCall("WTSApi32.dll", "bool", "WTSEnumerateProcesses", "Dword", 0, "Dword", 0, _
                        "Dword", 1, "ptr*", DllStructGetPtr($WTS_PROCESS_INFO), "Dword*", 0)
Local $mem, $aProc[$aDllRet[5]][4]

For $i=0 To $aDllRet[5]-1
     $mem=DllStructCreate($WTS_PROCESS_INFO, $aDllRet[4]+($i*DllStructGetSize($mem)))
     $aProc[$i][1]=DllStructGetData($mem, "ProcessId")
     $aSid = _Security__LookupAccountSid(DllStructGetData($mem, "pUserSid"))
     If IsArray($aSid) Then $aProc[$i][3] = $aSid[0]
Next

For $i=0 to UBound($aProc) - 1
     if $aProc[$i][1] = $PID Then
       Return $aProc[$i][3]
     EndIf
Next

DllCall("WTSApi32.dll", "int", "WTSFreeMemory", "int", $aDllRet[4])
EndFunc