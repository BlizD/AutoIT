#include <ServiceControl.au3>
#NoTrayIcon
$sServiceName="MSSQL$SQLEXPRESS"
_StopService("", $sServiceName)
Sleep(60000)
_StartService("", $sServiceName)

