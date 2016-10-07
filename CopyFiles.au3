#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icons\copy.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <File.au3>
#Include <Array.au3>
Opt("TrayMenuMode", 1)
#NoTrayIcon
TraySetState (4)
;~ _ArrayDisplay($CmdLine)
;~ Exit
;~ $PathTasks="\\oai-03\DWND\Tasks.exe"
$PathTasks="\\oai-03\autoit\Tasks.exe"
$PathScript=$CmdLine[1]
Sleep(5000)
if FileCopy ($PathTasks, $PathScript,1) =1 Then
Else
	MsgBox(-1,"","Не удалось обновить программу")
EndIf
Run($CmdLine[1])
