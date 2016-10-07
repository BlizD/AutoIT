#Include <file.au3>
#Include <Array.au3>
#include <Date.au3>

Global $PathDWND
Dim $arrayTorrents[1][5]
Global $Path=@ScriptDir & "\"
Dim $OnlyLog=False
Dim $CurrentIndex=0
;~ 	$PathDropBox="D:\Dropbox\DWND\"
;~ 	$PathDWND="C:\DWND\"
;~ 	$TimeUpdate=3000



If not FileExists($Path & "config.ini") Then
	$file = FileOpen($Path & "config.ini", 1)
	FileWriteLine($file, "[options]")
	FileWriteLine($file, "PathDWND=")
	FileWriteLine($file, "PathDropBox=")
	FileWriteLine($file, "TimeUpdate=3000")
	FileClose($file)
	Exit
Else
	$PathDropBox=IniRead($Path & "config.ini", "options", "PathDropBox", "NotFound")
	$PathDWND=IniRead($Path & "config.ini", "options", "PathDWND","NotFound")
	$TimeUpdate=IniRead($Path & "config.ini", "options", "TimeUpdate","NotFound")*1000
	Select
		Case $PathDropBox="NotFound"
			_MsgBox("Необходимо указать параметры PathDropBox в " & $Path & "config.ini")
			Exit
		case $PathDWND="NotFound"
			_MsgBox("Необходимо указать параметры PathDWND в " & $Path & "config.ini")
			Exit
		case $TimeUpdate="NotFound"
			_MsgBox("Необходимо указать параметры в " & $Path & "config.ini")
			Exit
	EndSelect
EndIf

;~ _ArrayDisplay($ArrayFolders)


;Если запуск происходит из командной строки обработка параметров
For $id = 1 to $CmdLine[0]
	if  StringLower(StringLeft($CmdLine[$id],4))="dbx-" then
		$PathDropBox= StringMid($CmdLine[$id],5)
	EndIf
	if  StringLower(StringLeft($CmdLine[$id],5))="dwnd-" then
		$PathDWND=StringMid($CmdLine[$id],6);
	EndIf
	if  StringLower(StringLeft($CmdLine[$id],2))="t-" then
		$TimeUpdate=StringMid($CmdLine[$id],3)*1000
	EndIf
Next


;Проверка не входит ли папка DropBox в Папку куда скачиваются фильмы. Если входит будет зацикливание.

If StringInStr(StringLower($PathDropBox),StringLower($PathDWND))>0 Then
	_MsgBox("Папка DropBox не может входить в папку куда скачиваются Файлы.")
	Exit
EndIf



$TorrentName=""
$PozOnly=StringInStr(StringLower($CmdLineRaw),"onlylog")
if $PozOnly>0 Then
	$OnlyLog=True
	$TorrentName=StringLeft($CmdLineRaw,$PozOnly-2)
EndIf

if $OnlyLog Then
	WriteLog("Закачка завершена - " & $TorrentName,"logTorrentBot.txt",33)
EndIf


While 1 and $OnlyLog=False
	Sleep ($TimeUpdate)
	SynhroniseFolders($PathDWND,$PathDropBox)
;~ 	Exit
;~ 	GetFiles($PathDropBox,$arrayTorrents,1,$CurrentIndex)
	$GoNext=true
	GetFiles($PathDropBox,$arrayTorrents,1,$CurrentIndex,$GoNext,"")
;~ 	_ArrayDisplay($arrayTorrents)
;~ 	Exit
	For $id = 0 to $CurrentIndex-1
		if $arrayTorrents[$id][1] <> "" then
;~ 			$StrokaZapuska="C:\Program Files\uTorrent\uTorrent.exe /DIRECTORY " & chr(34) & $arrayTorrents[$id][1] & chr(34) & " " & chr(34) & $arrayTorrents[$id][2] & chr(34)
			$StrokaZapuska="C:\Program Files\uTorrent\uTorrent.exe " & chr(34) & $arrayTorrents[$id][2] & chr(34)
			if Run($StrokaZapuska)=0 Then
				;$arrayTorrents[$id][1] путь до
				WriteLog("Не удалось поставить торрент на закачку - " & $arrayTorrents[$id][2],"logTorrentBot.txt",33)
			Else
				$NameTorrent=SetNameTorrent($arrayTorrents[$id][0],$arrayTorrents[$id][3])
;~ 				Exit
				$arrayTorrents[$id][4]=True
				WriteLog("Торрент добавлен " & $NameTorrent,"logTorrentBot.txt",33)
				if FileDelete($arrayTorrents[$id][0]) = 0 then
					WriteLog("не удалось удалить " & $arrayTorrents[$id][0],"logTorrentBot.txt",33)
				EndIf
				Sleep (3000)
			EndIf
		EndIf
	Next

	$flDeleteItem=False
	For $id = 0 to $CurrentIndex-1
		if $flDeleteItem Then
			$id=0
		EndIf
;~ 		_MsgBox($id & " = "& $CurrentIndex)
		if $CurrentIndex <> 0 then
			If $arrayTorrents[$id][4] Then
				if $CurrentIndex = 1 then
					$arrayTorrents[0][0]=""
					$arrayTorrents[0][1]=""
					$arrayTorrents[0][2]=""
					$arrayTorrents[0][3]=""
					$arrayTorrents[0][4]=False
					$CurrentIndex=0
				Else
					_ArrayDelete($arrayTorrents, $id)
					$CurrentIndex=$CurrentIndex-1
					$flDeleteItem=True
	;~ 				_MsgBox($id & " = "& $CurrentIndex)
				EndIf
			Else
				$flDeleteItem=False
			EndIf
		Else
			$flDeleteItem=False
		EndIf
	Next
;~  	Exit
WEnd

Func SynhroniseFolders($FolderISX,$FolderSYNC)
	$CurrentIndex=0
	Dim $arrayCopy_Delete[1][3]
	$GoNext=True
	$Type=2

;~ 	ConsoleWrite("" & _NowTime() & @CRLF)
	GetFiles($FolderISX,$arrayCopy_Delete,$Type,$CurrentIndex,$GoNext,"copy")
	GetFiles($FolderSYNC,$arrayCopy_Delete,$Type,$CurrentIndex,$GoNext,"del")
;~ 	ConsoleWrite("" & _NowTime() & @CRLF)
;~ 	_ArrayDisplay($arrayCopy_Delete)
;~ 	Exit
;~ 	ConsoleWrite("" & $CurrentIndex & @CRLF)
	For $id=0 to $CurrentIndex-1
		if $arrayCopy_Delete[$id][1]="copy" Then
			if $arrayCopy_Delete[$id][2]="folder" Then
				DirCreate($arrayCopy_Delete[$id][0])
			Else
				$file = FileOpen($arrayCopy_Delete[$id][0], 1)
				FileClose($file)
			EndIf
		Else
			if $arrayCopy_Delete[$id][2]="folder" Then
				DirRemove($arrayCopy_Delete[$id][0],1)
			Else
				FileDelete($arrayCopy_Delete[$id][0])
			EndIf
		EndIf
;~ 		ConsoleWrite($arrayCopy_Delete[$id][1] &" " & $arrayCopy_Delete[$id][2] &" - " & $arrayCopy_Delete[$id][0] & @CRLF)
	Next
EndFunc



Func GetFiles($PathFolder,ByRef $array,$Type,Byref $CurrentIndex,$GoNext,$Action)
;~ 	ConsoleWrite($PathFolder & @CRLF)
 	$FileList=_FileListToArray($PathFolder)
	If @Error=1 or @Error=4  Then
	Else
		For $id = 1 to $FileList[0]
			$FileAtr=FileGetAttrib ($PathFolder & $FileList[$id])
			if StringInStr($FileAtr,"D") then
				if $Type = 2 then
					$FileName=$PathFolder & $FileList[$id]
					if $Action="copy" then
						$FileName=StringReplace($FileName,$PathDWND,$PathDropBox)
					Else
						$FileName=StringReplace($FileName,$PathDropBox,$PathDWND)
					EndIf
					if FileExists($FileName)=0 Then
						ReDim $array[$CurrentIndex+1][3]
						if $Action="del" then
							$FileName=StringReplace($FileName,$PathDWND,$PathDropBox)
						EndIf
						$array[$CurrentIndex][0]=$FileName
						$array[$CurrentIndex][1]=$Action
						$array[$CurrentIndex][2]="folder"
						$CurrentIndex=$CurrentIndex+1
						if $Action="del" then
							$GoNext=False
						EndIf
					EndIf
				EndIf
				if $GoNext then
					GetFiles($PathFolder & $FileList[$id] & "\",$array,$Type,$CurrentIndex,$GoNext,$Action)
				EndIf
			Else
				if $Type = 2  then
					if StringInStr($FileList[$id],".torrent")=0 then
						$FileName=$PathFolder & $FileList[$id]
						if $Action="copy" then
							$FileName=StringReplace($FileName,$PathDWND,$PathDropBox)
						Else
							$FileName=StringReplace($FileName,$PathDropBox,$PathDWND)
						EndIf
						if FileExists($FileName)=0 Then
	;~ 						ConsoleWrite($FileName & @CRLF)
							ReDim $array[$CurrentIndex+1][3]
							if $Action="del" then
								$FileName=StringReplace($FileName,$PathDWND,$PathDropBox)
							EndIf
							$array[$CurrentIndex][0]=$FileName
							$array[$CurrentIndex][1]=$Action
							$array[$CurrentIndex][2]="file"
							$CurrentIndex=$CurrentIndex+1
						EndIf
					EndIf
				Else
					if StringInStr($FileList[$id],".torrent")>0  then
						ConsoleWrite("1")
						ReDim $array[$CurrentIndex+1][5]
						$array[$CurrentIndex][0]=$PathFolder & $FileList[$id]
						$PathTorrent=StringReplace($PathFolder,$PathDropBox,"")
						$array[$CurrentIndex][1]=$PathDWND & $PathTorrent
						$array[$CurrentIndex][2]=$PathDWND & "torrents\" & $FileList[$id]
						$array[$CurrentIndex][3]=$PathDWND & $PathTorrent & $FileList[$id]
						$array[$CurrentIndex][4]=false
						if FileCopy($array[$CurrentIndex][0], $array[$CurrentIndex][2], 9) =0 then
							WriteLog("Не удалось скопировать торрент " & $array[$CurrentIndex][2],"logTorrentBot.txt",33)
						Else
	;~ 						WriteLog("Скопирован торрент " & $arrayTorrents[$CurrentIndex][2],"logTorrentBot.txt",1)
						EndIf
						$CurrentIndex=$CurrentIndex+1
					EndIf
				EndIf
			EndIf
		Next
	EndIf
EndFunc


Func SetNameTorrent($FileTorrent,$NameTorrent)
	$PozTorrent=StringInStr($NameTorrent,".torrent")
	$NameTorrent=StringLeft($NameTorrent,$PozTorrent-1)
	$file = FileOpen($FileTorrent,128)
	$Multi=False
	While 1
		$line = FileReadLine($file)
;~ 		MsgBox(-1,"",$line)
		$PozName=StringInStr($line,"name")
		$PozPath=StringInStr($line,"path")
		$line=StringMid($line,$PozName)
		if $PozPath>0 Then
			$Multi=True
		EndIf
		if $PozName>0 then
			$PozDV=StringInStr($line,":")
			$line=StringMid($line,$PozDV+1)
			$PozDV=StringInStr($line,":")
			$Name=StringLeft($line,$PozDV-3)
			ExitLoop
		EndIf
	WEnd
	FileClose($file)

	$PozT=StringInStr($Name,".",0,-1)
	$rashirenie=StringMid($Name,$PozT)

	$DostupnueRashieniya=".3gp .avi .dat .flv .ifo .m4v .mkv .mov .mp4 .rm .vob .wmv"
	if StringLen($rashirenie)>4 or $Multi then
		$rashirenie=""
	EndIf


	$Name=$Name & " - Добавить новый торрент"
	Sleep(1000)
	ControlSetText($Name, "", "ComboBox1", $NameTorrent & $rashirenie)
	Sleep(1000)
	ControlClick ( $Name, "", "Button7")
	Sleep(1000)
	Return $NameTorrent & $rashirenie
EndFunc

Func WriteLog($Text,$NameLog,$Mode)
	$Time=_Date_Time_GetLocalTime()
	$Time=_Date_Time_SystemTimeToDateTimeStr($Time)
	$logfile = FileOpen($PathDropBox & $NameLog, $Mode)
	FileWriteLine($logfile,$Time & "-" & $Text)
	FileClose($logfile)
EndFunc

Func _MsgBox($Text)
	MsgBox(-1,"",$Text)
EndFunc