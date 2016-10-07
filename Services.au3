#include <ServiceControl.au3>
$sServiceName="1C:Enterprise 8.2 Server Agent (x86-64)"
_StopService("", $sServiceName)
Sleep(120000)
_StartService("", $sServiceName)

