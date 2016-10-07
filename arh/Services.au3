#Include <Array.au3>
#include <ServiceControl.au3>

Dim $aArray[1]
$aArray["Years"]="24"
;MsgBox(0, "Error", $aArray["Years"])

;$serv="1C:Enterprise 8.2 Server Agent"
;$serv="Spooler"
;IF Run("net stop" ,@SW_HIDE)=0 Then
;	MsgBox(4096, "", @error, 10)
;endif


$sServiceName="1C:Enterprise 8.2 Server Agent"
_StopService("", $sServiceName)
Sleep(120000)
While _ServiceRunning("", $sServiceName) = 0
	_StartService("", $sServiceName)
	Sleep(3000)
WEnd

