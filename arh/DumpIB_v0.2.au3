#Include <Array.au3>
#include <Date.au3>
#include <ServiceControl.au3>
#Include <file.au3>

$PSD="dumpday"





;Dim $asArray[6][2] = [[1, "A"],[2, "B"],[3, "C"],[1, "a"],[2, "b"],[3, "c"]]
;_ArrayDisplay($aArray, "$aArray")

DeleteBigLog ()
;~ Exit
;Получение из файла необходимых параметров
$ParametrsLoad=False;
If FileExists("config.ini") Then
	$file = FileOpen("config.ini", 0)
	; Check if file opened for reading OK
	If $file = -1 Then
;~ 		MsgBox(0, "Error", "Unable to open file.")
		WriteLog("Unable to open file config.ini","logDumpIB.txt",1)
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
	$ParametrsLoad=false
	$ParametrsLoad=CheckParametr ($aArray,$Size)
Else	
	;Создать файл config.ini с параметрами по умолчанию
	$file = FileOpen("config.ini", 1)
	FileWriteLine($file, "PathProgramm=c:\Program Files\1cv82\common\1cestart.exe")
	FileWriteLine($file, "FileServer=Укажите Файловая/серверная база file/server")
	FileWriteLine($file, "PathFile=D:\ПутьДоБазы\ Если файловая")
	FileWriteLine($file, "PathServer= необходимо указать СерверБД")
	FileWriteLine($file, "PathServerBase= необходимо указать названиеБД")
	FileWriteLine($file, "PathDump=C:\Temp\")
	FileWriteLine($file, "user=DumpIB")
	FileWriteLine($file, "CloseAll_1c=false")
	FileWriteLine($file, "BaseName=указать название филиала")
;~ 	FileWriteLine($file, "SQLService=DB2")
;~ 	FileWriteLine($file, "1cAgent=1C:Enterprise 8.2 Server Agent")
	FileClose($file)
EndIf    

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
;~ 		$sServiceName=GetValue("1cAgent",$aArray)
;~ 		_StopService("", $sServiceName)
;~ 		WriteLog("Остановка службы 1cAgent","logDumpIB.txt",1)
;~ 		$sSQLService=GetValue("SQLService",$aArray)		
;~ 		_StopService("", $sSQLService)
;~ 		WriteLog("Остановка службы SQLService","logDumpIB.txt",1)
;~ 		Sleep(120000) ;Задержка нужна для корректной остановки служб 2 минуты
;~ 		While _ServiceRunning("", $sSQLService) = 0
;~ 			_StartService("", $sSQLService)
;~ 			WriteLog("Старт службы SQLService","logDumpIB.txt",1)
;~ 			Sleep(60000) ;1 минута задержки между попытками запуска SQL службы
;~ 		WEnd
;~ 		While _ServiceRunning("", $sServiceName) = 0
;~ 			_StartService("", $sServiceName)
;~ 			WriteLog("Старт службы 1cAgent","logDumpIB.txt",1)
;~ 			Sleep(60000) ;1 минута задержки между попытками запуска Агента 1с
;~ 		WEnd		
;~ 		$list = ProcessList("1cv8.exe")
;~ 		for $i = 1 to $list[0][0]	
;~ 		  ;msgbox(0, $list[$i][0], $list[$i][1])
;~ 		  ProcessClose($list[$i][1])
;~ 		next
		ClosseAll_1c($aArray)
	endif	
	
	$TimeStr = StringReplace($TimeStr, "/", "")
	$poz=StringInStr($TimeStr, " ")
	$TimeStr =StringLeft($TimeStr, $poz-1)
	$TimeStr=GetValue("BaseName",$aArray) & "_" & $TimeStr; 	
	;Выгрузка в DT 
	;MsgBox(0, "Error", GetValue("FileServer",$aArray)) 
	;MsgBox(0, "Error", GetValue("FileServer",$aArray)="Server") 
	if StringLower(GetValue("FileServer",$aArray))="server" Then		
		$StrokaZapuska=chr(34) & GetValue("PathProgramm",$aArray) & chr(34) &  " DESIGNER /S " & GetValue("PathServer",$aArray) & "\" & GetValue("PathServerBase",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $TimeStr &".dt" & " /DumpResult " & GetValue("PathDump",$aArray) & "result.txt"  
	Else
		$StrokaZapuska=chr(34) & GetValue("PathProgramm",$aArray) & chr(34) & " DESIGNER /F " & chr(34)  & GetValue("PathFile",$aArray) & chr(34) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $TimeStr &".dt"  & " /DumpResult " & GetValue("PathDump",$aArray) & "result.txt"  
		;MsgBox(0, "Error", $StrokaZapuska)
	EndIf
;~ 	MsgBox(0, "Error", $StrokaZapuska)
	WriteLog("Выгрузка в DT файл","logDumpIB.txt",1)
	If FileExists(GetValue("PathDump",$aArray) & "result.txt") Then
		FileDelete(GetValue("PathDump",$aArray) & "result.txt")
	endif
	if Run($StrokaZapuska)=0 Then
		WriteLog("Не удалось выгрузить в DT, проверьте правильность значения параметров в файле config.ini","logDumpIB.txt",1)
	EndIf	
	While not FileExists(GetValue("PathDump",$aArray) & "result.txt") 
		sleep(5000)
	Wend
	if not ReadResult(GetValue("PathDump",$aArray) & "result.txt")	Then
		WriteLog("Не удалось выгрузить в DT,","logDumpIB.txt",1)
		SendMail("Не удалось создать бекап базы - " & GetValue("BaseName",$aArray))
	Else
		WriteLog("Выгрузка в DT файл завершена","logDumpIB.txt",1)
	EndIf
Else
	WriteLog("Параметры выгрузки не загружены.","logDumpIB.txt",1)
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
				WriteLog("Неправильно заполнен 1cAgent,необходимо указать 1c:enterprise 8.2 server agent, в файле config.ini","logConfig.txt",2)
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
Func DeleteBigLog ()
	If FileExists("logDumpIB.txt") Then
		$sizelog = FileGetSize("logDumpIB.txt")
		$sizelog=$sizelog/1024
		if $sizelog >=2 then 
			FileDelete("logDumpIB.txt")
		EndIf
	endif
endfunc

Func ReadResult($FileResult)	
	$fileRes = FileOpen($FileResult, 0)
	; Check if file opened for reading OK
	If $fileRes = -1 Then
;~ 		MsgBox(0, "Error", "Unable to open file.")
		WriteLog("Unable to open file result.log","logDumpIB.txt",1)
		Exit
	EndIf	
	$lineResult = FileReadLine($fileRes)
	If @error = -1 Then 
		return false 
	EndIf
	if $lineResult=1 then 
		Return False 
	EndIf	
	return true
endfunc
Func ClosseAll_1c($aArray)
	$oShell = ObjCreate("v82.COMConnector")
	$Agent=$oShell.ConnectAgent("oai-03");
	$Klasters=$Agent.GetClusters();
	$BaseName="PlanB"
	For $Klaster In $Klasters
		$Name="DumpIB"
		$PSD="dumpday"
		$Agent.Authenticate($Klaster,"", "")
		$Proceses=$Agent.GetWorkingProcesses($Klaster)
		For $Process In $Proceses
			$Port=$Process.MainPort
			$WorkingProcess= $oShell.ConnectWorkingProcess("oai-03:" & $Port)
			$WorkingProcess.AddAuthentication($Name,$PSD)
			$InfoBase=""
			$Bases=$Agent.GetInfoBases($Klaster)
			For $Base in $Bases
				if $Base.Name=$BaseName Then
					$InfoBase=$Base
					ExitLoop
				EndIf
			Next
			if $InfoBase="" Then
				MsgBox(0, "Error", "База не обнаружена")
			EndIf
	;~ 		MsgBox(0, "Error", $InfoBase)
			$Sessions=$Agent.GetInfoBaseSessions($Klaster, $InfoBase)
			For $Session in $Sessions 
				$Agent.TerminateSession($Klaster, $Session)
			Next
	;~ 		$Connections=$Agent.GetInfoBaseConnections($Klaster, $InfoBase)
	;~ 		For $Connection in $Connections 
	;~ 			$WorkingProcess.Disconnect($Connection)
	;~ 		Next		
		Next	
	Next	
EndFunc


;~ ОтправкаПочты

Func SendMail($Text)
	$SmtpServer = "smtp.mail.ru"              ; address for the smtp-server to use - REQUIRED
	$FromName = "Name"                      ; name from who the email was sent
	$FromAddress = "BlizzardAnton@mail.ru" ; address from where the mail should come
	$ToAddress = "BlizzardAnton@mail.ru"   ; destination address of the email - REQUIRED
	$Subject = $Text                   ; subject from the email - can be anything you want it to be
	$Body = $Text ; the messagebody from the mail - can be left blank but then you get a blank mail
	$AttachFiles = ""                       ; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
;~ 	$CcAddress = "bliz@mailsms.megafonkavkaz.ru"       ; address for cc - leave blank if not needed
	$CcAddress = ""       ; address for cc - leave blank if not needed
	$BccAddress = ""     ; address for bcc - leave blank if not needed
	$Importance = "Normal"                  ; Send message priority: "High", "Normal", "Low"
	$Username = "BlizzardAnton"                    ; username for the account used from where the mail gets sent - REQUIRED
	$Password = "ghtptyn ajh . 31"                  ; password for the account used from where the mail gets sent - REQUIRED
	$IPPort = 25                            ; port used for sending the mail
	$ssl = 0                                ; enables/disables secure socket layer sending - put to 1 if using httpS
	$IPPort=465                          ; GMAIL port used for sending the mail
	$ssl=1                               ; GMAILenables/disables secure socket layer sending - put to 1 if using httpS
	_SednMail ($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
EndFunc
Func _SednMail ($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
	Global $oMyRet[2]
	Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
	If @error Then
;~ 		MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
		WriteLog("Не удалось отправить сообщение на почту","logDumpIB.txt",1)
	EndIf
endfunc
;
; The UDF
Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $as_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Importance="Normal", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
    Local $objEmail = ObjCreate("CDO.Message")
    $objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress
    Local $i_Error = 0
    Local $i_Error_desciption = ""
    If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
    If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
    $objEmail.Subject = $s_Subject
    If StringInStr($as_Body, "<") And StringInStr($as_Body, ">") Then
        $objEmail.HTMLBody = $as_Body
    Else
        $objEmail.Textbody = $as_Body & @CRLF
    EndIf
    If $s_AttachFiles <> "" Then
        Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
        For $x = 1 To $S_Files2Attach[0]
            $S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
;~          ConsoleWrite('@@ Debug : $S_Files2Attach[$x] = ' & $S_Files2Attach[$x] & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
            If FileExists($S_Files2Attach[$x]) Then
                ConsoleWrite('+> File attachment added: ' & $S_Files2Attach[$x] & @LF)
                $objEmail.AddAttachment($S_Files2Attach[$x])
            Else
                ConsoleWrite('!> File not found to attach: ' & $S_Files2Attach[$x] & @LF)
                SetError(1)
                Return 0
            EndIf
        Next
    EndIf
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    If Number($IPPort) = 0 then $IPPort = 25
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    ;Authenticated SMTP
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $ssl Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
    ;Update settings
    $objEmail.Configuration.Fields.Update
    ; Set Email Importance
    Switch $s_Importance
        Case "High"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "High"
        Case "Normal"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Normal"
        Case "Low"
            $objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Low"
    EndSwitch
    $objEmail.Fields.Update
    ; Sent the Message
    $objEmail.Send
    If @error Then
        SetError(2)
        Return $oMyRet[1]
    EndIf
    $objEmail=""
EndFunc   ;==>_INetSmtpMailCom
;
;
; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
EndFunc   ;==>MyErrFunc
