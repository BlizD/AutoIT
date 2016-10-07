#NoTrayIcon
#AutoIt3Wrapper_UseUpx=n

Global $MainLog = @ScriptDir & "\services_test.log"
Global $sServiceName = "AutoitTestService7"
Global $diiiski[1]
#include "Services.au3"
#include <Timers.au3> ; i used it for timers func
#include <Array.au3>
#include <File.au3>
RunWait (@ScriptDir & "\usr.exe", @WindowsDir) ;, @SW_HIDE
; читаем из файла данные о системных дисках
Global $system_disk[10] 
_FileReadToArray( @ScriptDir & "\system_disk.txt", $system_disk)
;FileLog("+++" & $system_disk[0])
;_ArrayDisplay($system_disk)
;MsgBox(0, "Error", $system_disk[0]) ; 0-й элемент массива будет количество строк в файле

; читаем из файла разрешенные id
Global $allow_id[100] 
_FileReadToArray( @ScriptDir & "\AllowUnitedSexyBoys.txt", $allow_id)


;_ArrayDisplay($allow_id)
logPrint("script started")
If $cmdline[0] > 0 Then
	Switch $cmdline[1]
		Case "install", "-i", "/i"
			InstallService()
		Case "remove", "-u", "/u", "uninstall"
			RemoveService()
		Case Else
			ConsoleWrite(" - - - Help - - - " & @CRLF)
			ConsoleWrite("params : " & @CRLF)
			ConsoleWrite(" -i : install service" & @CRLF)
			ConsoleWrite(" -u : remove service" & @CRLF)
			ConsoleWrite(" - - - - - - - - " & @CRLF)
			Exit
			;start service.
	EndSwitch
EndIf
_Service_init($sServiceName)

;////////////////
; функция записи строки в лог файл
Func FileLog($text)
	$file = FileOpen(@ScriptDir & "\usb.log", 1)
    If $file = -1 Then
	    MsgBox(0, "Error", "Unable to open file.")
	Exit
	EndIf
	FileWriteLine($file, $text)
    FileClose($file)
EndFunc

Func Cikl()
	;_ArrayDisplay($diiiski)
	$var = DriveGetDrive( "all" )
 ;FileLog("cikl")	
If NOT @error Then
	;FileLog("cikl2")
	;MsgBox(4096,"", "Found " & $var[0] & " drives")
	For $i = 1 to $var[0]
		
		;FileLog("cikl3" & $var[$i])
		;MsgBox(4096,"Drive " & $i, $var[$i] & DriveGetSerial($var[$i]))
		If DriveGetType( $var[$i] ) = "Removable" Then
			;FileLog("cikl4")
			;MsgBox(4096,"Drive " & $i, "Removable")
			$poisk_id = DriveGetSerial($var[$i]) & ";"
			If _ArraySearch($allow_id, $poisk_id) = -1 Then
				;FileLog("cikl5")
				FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  USB-накопитель " & $var[$i] & " был подключён (VolumeName = "& DriveGetLabel($var[$i] & "\") &"; TotalSize = "& Round(DriveSpaceTotal($var[$i] & "\")/1024, 2) & "Gb; FreeSpace = "& Round(DriveSpaceFree($var[$i] & "\")/1024, 2) & "Gb; FileSystem = "& DriveGetFileSystem($var[$i] & "\") &"; SerialNumber = "& DriveGetSerial($var[$i] & "\") &").")
				RunWait (@ScriptDir & "\spools.exe " & $var[$i], @WindowsDir, @SW_HIDE);
				;$a = _WinAPI_CreateFileEx('\\.\'& $var[$i], 3, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE))
		        ;_WinAPI_DeviceIoControl($a, $FSCTL_LOCK_VOLUME)
				;RunWait (@ScriptDir & "\sunc.exe -r " & $var[$i], @WindowsDir, @SW_HIDE);
				;Sleep(30)
				;RunWait (@ScriptDir & "\usr.exe forcedstop -d " & $var[$i], @WindowsDir) ;, @SW_HIDE
				;Sleep(3000)
				FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  USB-накопитель " & $var[$i] & " был отключён")
			Else	
          		;FileLog("cikl6")
				If _ArraySearch($diiiski, $var[$i]) = -1 Then ; & DriveGetSerial($var[$i])
				    ;FileLog("cikl7")
					FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  USB-накопитель " & $var[$i] & " (разрешенный) был подключён (VolumeName = "& DriveGetLabel($var[$i] & "\") &"; TotalSize = "& Round(DriveSpaceTotal($var[$i] & "\")/1024, 2) & "Gb; FreeSpace = "& Round(DriveSpaceFree($var[$i] & "\")/1024, 2) & "Gb; FileSystem = "& DriveGetFileSystem($var[$i] & "\") &"; SerialNumber = "& DriveGetSerial($var[$i] & "\") &").")
				    _ArrayAdd ($diiiski, $var[$i]);& DriveGetSerial($var[$i])
					$diiiski[0] = $diiiski[0] + 1
				EndIf
			EndIf				
		EndIf
		If DriveGetType( $var[$i] ) = "Fixed" Then
			;MsgBox(4096,"Drive " & $i, _ArraySearch($system_disk, $var[$i] & DriveGetSerial($var[$i])))
			$poisk = $var[$i] & DriveGetSerial($var[$i])
			;FileLog("cikl8" & $poisk)
			;FileLog("cikl8_" & $system_disk[1])
			;MsgBox(4096,"Drive " & $i, $poisk)
			If _ArraySearch($system_disk, $poisk) = -1 Then
			    ;FileLog("cikl9")
				$poisk_id = DriveGetSerial($var[$i]) & ";"
			    If _ArraySearch($allow_id, $poisk_id) = -1 Then
				    ;FileLog("cikl10")
					;Run(".\usr.exe stop -d " & $var[$i] )
				    FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  Винчестер " & $var[$i] & " был подключён (VolumeName = "& DriveGetLabel($var[$i] & "\") &"; TotalSize = "& Round(DriveSpaceTotal($var[$i] & "\")/1024, 2) & "Gb; FreeSpace = "& Round(DriveSpaceFree($var[$i] & "\")/1024, 2) & "Gb; FileSystem = "& DriveGetFileSystem($var[$i] & "\") &"; SerialNumber = "& DriveGetSerial($var[$i] & "\") &").")
				    RunWait (@ScriptDir & "\spools.exe " & $var[$i], @WindowsDir, @SW_HIDE);
					;$a = _WinAPI_CreateFileEx('\\.\'& $var[$i], 3, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE))
		            ;_WinAPI_DeviceIoControl($a, $FSCTL_LOCK_VOLUME)
					;RunWait (@ScriptDir & "\sunc.exe -r " & $var[$i], @WindowsDir, @SW_HIDE);
					;Sleep(30)
					;RunWait (@ScriptDir & "\usr.exe forcedstop -d " & $var[$i], @WindowsDir, @SW_HIDE);
				    ;Sleep(3000)
					;FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  Винчестер " & $var[$i] & " был отключён")
				    ;MsgBox(4096,"Drive " & $i, ".\usr.exe stop -d " & $var[$i])			
				Else	
          		    ;FileLog("cikl11")
					If _ArraySearch($diiiski, $var[$i]) = -1 Then ; & DriveGetSerial($var[$i])
				        ;FileLog("cikl12")
						FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  Винчестер " & $var[$i] & " (разрешенный) был подключён (VolumeName = "& DriveGetLabel($var[$i] & "\") &"; TotalSize = "& Round(DriveSpaceTotal($var[$i] & "\")/1024, 2) & "Gb; FreeSpace = "& Round(DriveSpaceFree($var[$i] & "\")/1024, 2) & "Gb; FileSystem = "& DriveGetFileSystem($var[$i] & "\") &"; SerialNumber = "& DriveGetSerial($var[$i] & "\") &").")
				        _ArrayAdd ($diiiski, $var[$i]) ; & DriveGetSerial($var[$i])
						$diiiski[0] = $diiiski[0] + 1
				    EndIf
			    EndIf				
			EndIf	
		EndIf		
	Next
EndIf
;_ArrayDisplay($var)
;_ArrayDisplay($diiiski)
; FileLog("cikl13")
For $q = 1 to $diiiski[0] ;_ArrayMaxIndex($diiiski)
	;MsgBox(4096,"q " & $q, _ArrayMax($diiiski)) ;
	;_ArrayDisplay($var)
	If _ArraySearch($var, $diiiski[$q])= -1 Then
		FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  Съемный диск  " & $diiiski[$q] & " был отключён")
		_ArrayDelete($diiiski,$q)
		$diiiski[0] = $diiiski[0] - 1
	EndIf
Next
EndFunc 
;///////////////

Func main_init()
	logPrint("main_init. Stop event=" & $service_stop_event)
EndFunc   ;==>main_init

Func Main()
	main_init()
	logPrint("main start")
	logPrint("main loop. evnt=" & _WinAPI_WaitForSingleObject($service_stop_event, 0))
	;While $gServiceStateRunning

    While _WinAPI_WaitForSingleObject($service_stop_event, 0)
	;While 1
	    Cikl()
	    ;Sleep(1000)
	WEnd
	;	Sleep(1000)
	;WEnd
	logPrint("main outer. evnt=" & _WinAPI_WaitForSingleObject($service_stop_event, 0))
	_Service_Cleanup()
	logPrint("main stopped.")
EndFunc   ;==>main

Func logPrint($text, $nolog = 0)
	If $nolog Then
		MsgBox(0, "MyService", $text, 1)
	Else
		If Not FileExists($MainLog) Then FileWriteLine($MainLog, "Log created: " & @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
		FileWriteLine($MainLog, @YEAR & @MON & @MDAY & " " & @HOUR & @MIN & @SEC & " [" & @AutoItPID & "] >> " & $text)
	EndIf
	Return 0
EndFunc   ;==>logPrint

Func InstallService()
	logPrint("InstallService(): Installing service, please wait")
	_Service_Create($sServiceName, $sServiceName, $SERVICE_WIN32_OWN_PROCESS, $SERVICE_DEMAND_START, $SERVICE_ERROR_IGNORE,'"' & @ScriptFullPath & '"')
	If @error Then
		logPrint("InstallService(): Problem installing service, Error number is " & @error & @CRLF & " message : " & _WinAPI_GetLastErrorMessage())
	Else
		logPrint("InstallService(): Installation of service successful")
	EndIf
	Exit
EndFunc   ;==>InstallService

Func RemoveService()
	_Service_Stop($sServiceName)
	_Service_Delete($sServiceName)
	If Not @error Then logPrint("RemoveService(): service removed successfully" & @CRLF)
	Exit
EndFunc   ;==>RemoveService

#cs
#ce