#Include <Array.au3>
#include <Date.au3>
#include <ServiceControl.au3>

$PSD="dumpday"





;Dim $asArray[6][2] = [[1, "A"],[2, "B"],[3, "C"],[1, "a"],[2, "b"],[3, "c"]]
;_ArrayDisplay($aArray, "$aArray")


;Получение из файла необходимых параметров
$ParametrsLoad=False;
If FileExists("config.ini") Then
	$file = FileOpen("config.ini", 0)
	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file.")
		Exit
	EndIf
	; Read in lines of text until the EOF is reached	
	$Size=GetCountOfLines()
	Dim $aArray[$Size][2]	
	$NS=0;
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		;MsgBox(0, "Line read:", $line)
		$poz=StringInStr($Line, "=")
		$Parametr = StringLeft($Line, $poz-1)
		$Value=StringMid($Line,$poz+1)
		$aArray[$NS][0]=$Parametr
		$aArray[$NS][1]=$Value				
		;MsgBox(0, "Error", "Par=" & $Parametr & " Val=" & $aArray[$Parametr])
		$NS=$NS+1;
	Wend	
	FileClose($file)
	
Else	
	;Создать файл conf.cfg с параметрами по умолчанию
	$file = FileOpen("config.ini", 1)
	FileWriteLine($file, "PathProgramm=" & """c:\Program Files\1cv82\common\1cestart.exe""")
	FileWriteLine($file, "FileServer=Укажите Файловая/серверная база file/server")
	FileWriteLine($file, "PathFile=" & """D:\ПутьДоБазы\""")
	FileWriteLine($file, "PathServer=")
	FileWriteLine($file, "PathServerBase=")
	FileWriteLine($file, "PathDump=C:\Temp\")
	FileWriteLine($file, "user=DumpIB")
	FileWriteLine($file, "CloseAll_1c=false")
	FileWriteLine($file, "BaseName=Test")
	FileWriteLine($file, "SQLService=DB2")
	FileWriteLine($file, "1cAgent=1C:Enterprise 8.2 Server Agent")
	FileClose($file)
EndIf    
$ParametrsLoad=false
$ParametrsLoad=CheckParametr ($aArray,$Size)
$ParametrsLoad=false
;MemoWrite("Current system date/time .: " & _Date_Time_SystemTimeToDateTimeStr($tCur))
;~ _ArrayDisplay($aArray, "$aArray")
;MsgBox(0, "Error", $aArray[0])
;MsgBox(0, "Error", $aArray[1])
;MsgBox(0, "Error", $aArray[2])


if $ParametrsLoad then
	$TimeStr=_Date_Time_GetLocalTime()
	$TimeStr=_Date_Time_SystemTimeToDateTimeStr($TimeStr)	
	; Завершаем все сеансы 1с, остановка/запуск служб Агента1с и DB2/MSSQL
	if StringLower(GetValue("CloseAll_1c",$aArray)) = "true" then
		$sServiceName=GetValue("1cAgent",$aArray)
		_StopService("", $sServiceName)
		WriteLog("Остановка службы 1cAgent","logDumpIB.txt",1)
		$sSQLService=GetValue("SQLService",$aArray)		
		_StopService("", $sSQLService)
		WriteLog("Остановка службы SQLService","logDumpIB.txt",1)
		Sleep(120000) ;Задержка нужна для корректной остановки служб 2 минуты
		While _ServiceRunning("", $sSQLService) = 0
			_StartService("", $sSQLService)
			WriteLog("Старт службы SQLService","logDumpIB.txt",1)
			Sleep(60000) ;1 минута задержки между попытками запуска SQL службы
		WEnd
		While _ServiceRunning("", $sServiceName) = 0
			_StartService("", $sServiceName)
			WriteLog("Старт службы 1cAgent","logDumpIB.txt",1)
			Sleep(60000) ;1 минута задержки между попытками запуска Агента 1с
		WEnd		
;~ 		$list = ProcessList("1cv8.exe")
;~ 		for $i = 1 to $list[0][0]	
;~ 		  ;msgbox(0, $list[$i][0], $list[$i][1])
;~ 		  ProcessClose($list[$i][1])
;~ 		next
	endif	
	
	$TimeStr = StringReplace($TimeStr, "/", "")
	$poz=StringInStr($TimeStr, " ")
	$TimeStr =StringLeft($TimeStr, $poz-1)
	$TimeStr=GetValue("BaseName",$aArray) & "_" & $TimeStr; 	
	;Выгрузка в DT 
	;MsgBox(0, "Error", GetValue("FileServer",$aArray)) 
	;MsgBox(0, "Error", GetValue("FileServer",$aArray)="Server") 
	if StringLower(GetValue("FileServer",$aArray))="server" Then		
		$StrokaZapuska=GetValue("PathProgramm",$aArray) & " DESIGNER /S " & GetValue("PathServer",$aArray) & "\" & GetValue("PathServerBase",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $TimeStr &".dt" &  " /DumpResult "  & GetValue("PathDump",$aArray) & "Result.txt" 
	Else
		$StrokaZapuska=GetValue("PathProgramm",$aArray) & " DESIGNER /F " & GetValue("PathFile",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $TimeStr &".dt" &  " /DumpResult "  & GetValue("PathDump",$aArray) & "Result.txt" 
		;MsgBox(0, "Error", $StrokaZapuska)
	EndIf
	;MsgBox(0, "Error", $StrokaZapuska)
	WriteLog("Выгрузка в DT файл","logDumpIB.txt",1)
	if Run($StrokaZapuska)=0 Then
		WriteLog("Не удалось выгрузить в DT, проверьте правильность значения параметров в файле config.ini","logDumpIB.txt",1)
;~ 		MsgBox(4096, "", "Не удалось выгрузить в DT, проверьте правильность значения параметров в файле config.ini", 10)
	EndIf
Else
;~ 	MsgBox(4096, "", "В файле config.ini, проверьте/заполните необходимые параметры", 10)
endif	

func GetCountOfLines()
	$fileSize = FileOpen("config.ini", 0)
	$Size=0
	While 1
		$line = FileReadLine($fileSize)
		If @error = -1 Then ExitLoop
		$Size=$Size+1
	Wend		
	FileClose($fileSize)	
	Return $Size
EndFunc

Func GetValue($Parametr,$aArray) 
	$iIndex = _ArraySearch($aArray, $Parametr, 0, 0, 0, 1, 1, 0)
	Return $aArray[$iIndex][1]
EndFunc

Func CheckParametr ($aArray,$Size)	
	For $i = 0 to $Size-1
		$Parametr=$aArray[$i][0]
		$Value=$aArray[$i][1]
		if $Parametr="FileServer" Then
			$Value=StringLower($Value)
			if $Value<>"server" And $Value<>"file" Then
				WriteLog("Не правильно указан тип БД, необходимо указать file/server, в файле config.ini","logConfig.txt",2)
				return false
			endif
		endif	
		if $Parametr="PathProgramm" or $Parametr="PathDump"	or $Parametr="user"	or $Parametr="BaseName"	Then
			$Value=StringReplace($Value, " ", "")
			if $Value="" Then
				WriteLog("Заполните PathProgramm/PathDump/user/BaseName, в файле config.ini","logConfig.txt",2)
				return false
			endif
		endif				
		if $Parametr="PathFile" or $Parametr="PathServer" then
			if StringLower(GetValue("FileServer",$aArray)) = "file" then
				$Value=StringReplace($Value, " ", "")
				if $Value="" Then
					WriteLog("Заполните PathFile/PathServer, в файле config.ini","logConfig.txt",2)
					return false
				endif			
			endif						
		endif
		if $Parametr="PathServer" or $Parametr="PathServerBase" then
			if StringLower(GetValue("FileServer",$aArray)) = "server" then
				$Value=StringReplace($Value, " ", "")
				if $Value="" Then
					WriteLog("Заполните PathServer/PathServerBase, в файле config.ini","logConfig.txt",2)
					return false
				endif			
			endif						
		endif
		if $Parametr="CloseAll_1c" Then
			$Value=StringLower($Value)
			if  $Value<> "false" and $Value<> "true"then
				WriteLog("Неправильно заполнен CloseAll_1c,необходимо указать true/false, в файле config.ini","logConfig.txt",2)
				return false				
			endif
		EndIf			
		if $Parametr="SQLService" Then
			$Value=StringLower($Value)
			if  $Value<> "db2" and $Value<> "mssqlserver"then
				WriteLog("Неправильно заполнен SQLService,необходимо указать db2/mssqlserver, в файле config.ini","logConfig.txt",2)
				return false				
			endif
		EndIf
		if $Parametr="1cAgent" Then
			$Value=StringLower($Value)
			if  $Value<> "1c:enterprise 8.2 server agent" then
				WriteLog("Неправильно заполнен SQLService,необходимо указать 1c:enterprise 8.2 server agent, в файле config.ini","logConfig.txt",2)
				return false				
			endif
		EndIf		
	Next	
	If FileExists("logConfig.txt") Then
		FileDelete("logConfig.txt")
	endif
	return true
EndFunc
Func WriteLog($Text,$NameLog,$Mode)
	$Time=_Date_Time_GetLocalTime()
	$Time=_Date_Time_SystemTimeToDateTimeStr($Time)		
	$logfile = FileOpen($NameLog, $Mode)
	FileWriteLine($logfile,$Time & "-" & $Text)
	FileClose($logfile)	
EndFunc	