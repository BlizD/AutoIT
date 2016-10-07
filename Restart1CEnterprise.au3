#include <ServiceControl.au3>



$sServiceName="1C:Enterprise 8.2 Server Agent (x86-64)"
$MSSQL="MSSQLSERVER"
$SQLSERVERAGENT="SQLSERVERAGENT"


_StopService("", $sServiceName)
Sleep(10000)
_StopService("", $SQLSERVERAGENT)
Sleep(10000)
_StopService("", $MSSQL)


Sleep(120000)
_StartService("", $MSSQL)
Sleep(10000)
_StartService("", $SQLSERVERAGENT)
Sleep(10000)
_StartService("", $sServiceName)

