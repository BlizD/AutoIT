#Include <File.au3>
#Include <Array.au3>


$PathTasks="\\oai-03\DWND\Tasks.exe"
;~ $PathScript=@ScriptFullPath
$PathScript="C:\Documents and Settings\ivanov\Рабочий стол\Tasks.exe"

if FileExists ($PathTasks)=1 Then
	if FileGetTime ($PathTasks,0,1)=FileGetTime ($PathScript,0,1) AND FileGetSize ($PathTasks)=FileGetSize ($PathScript) Then
	Else
		if Run("\\oai-03\DWND\CopyFiles.exe "& Chr(34) & $PathScript &Chr(34))=0 Then
			MsgBox(-1,"","Не удалось обновить программу")
		Else
			Exit
		EndIf
	EndIf
EndIf