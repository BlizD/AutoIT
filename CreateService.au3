#include <ServiceControl.au3>
;===============================================================================
; Description:   Creates a service on a computer
; Parameters:    $sComputerName - name of the target computer. If empty, the local computer name is used
;                $sServiceName - name of the service to create
;                $sDisplayName - display name of the service
;                $sBinaryPath - fully qualified path to the service binary file
;                               The path can also include arguments for an auto-start service
;                $sServiceUser - [optional] default is LocalSystem
;                                name of the account under which the service should run
;                $sPassword - [optional] default is empty
;                             password to the account name specified by $sServiceUser
;                             Specify an empty string if the account has no password or if the service 
;                             runs in the LocalService, NetworkService, or LocalSystem account
;                 $nServiceType - [optional] default is $SERVICE_WIN32_OWN_PROCESS
;                 $nStartType - [optional] default is $SERVICE_AUTO_START
;                 $nErrorType - [optional] default is $SERVICE_ERROR_NORMAL
;                 $nDesiredAccess - [optional] default is $SERVICE_ALL_ACCESS
;                 $sLoadOrderGroup - [optional] default is empty
;                                    names the load ordering group of which this service is a member
; Requirements:  Administrative rights on the computer
; Return Values: On Success - 1
;                On Failure - 0 and @error is set to extended Windows error code
; Note:          Dependencies cannot be specified using this function
;                Refer to the CreateService page on MSDN for more information
;===============================================================================
;~ Func _CreateService($sComputerName, _
;~                     $sServiceName, _
;~                     $sDisplayName, _
;~                     $sBinaryPath, _
;~                     $sServiceUser = "LocalSystem", _
;~                     $sPassword = "", _
;~                     $nServiceType = 0x00000010, _
;~                     $nStartType = 0x00000002, _
;~                     $nErrorType = 0x00000001, _
;~                     $nDesiredAccess = 0x000f01ff, _
;~                     $sLoadOrderGroup = "")

$Result=_CreateService("oai-03","DumpIB","DumpIB","D:\Ivanov A.B\1c\autoit\DumpIB.exe", "LocalSystem", "" , 0x00000010 , 0x00000002, 0x00000001, 0x000f01ff, "" )
MsgBox(0,"",$Result)
;~ _CreateService("oai-03","DumpIB","D:\Ivanov A.B\1c\autoit\DumpIB.exe", "LocalSystem",,,, , ,  )