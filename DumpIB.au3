;~ #NoTrayIcon
#Include <Array.au3>
#include <Date.au3>
#include <ServiceControl.au3>
#Include <file.au3>
#include <GUIConstants.au3>
#include <FTPEx.au3>
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Global $Path=@ScriptDir & "\"
$PSD="dumpday"
$FirstStart=false
DeleteBigLog ()


;��������� �� ����� ����������� ����������
If not FileExists($Path & "config.ini") Then
	;������� ���� config.ini � ����������� �� ���������
	$file = FileOpen($Path & "config.ini", 1)
	FileWriteLine($file, "PathProgramm=c:\Program Files\1cv82\common\1cestart.exe")
	FileWriteLine($file, "PathServer= ���������� ������� ��������")
	FileWriteLine($file, "PathServerBase= ���������� ������� ����������")
	FileWriteLine($file, "FileServer=server")
	FileWriteLine($file, "PathDump=" & $Path)
	FileWriteLine($file, "user=DumpIB")
	FileWriteLine($file, "CloseAll_1c=false")
	FileWriteLine($file, "BaseName=������� �������� �������")
	FileWriteLine($file, "mailto=���� �� ������� ���������� ������, � ������ �������")
	FileWriteLine($file, "CountOfDT=7")
	FileWriteLine($file, "FTP_IP=10.0.0.234")
	FileWriteLine($file, "PathDumpDB2=C:\Temp")
	FileWriteLine($file, "Scheduler=2,6")
	FileWriteLine($file, "RestartService=true")
	FileClose($file)
	$FirstStart=true
EndIf
If $FirstStart Then
	Exit
EndIf
;��������� ��������� �� �����
$file = FileOpen($Path & "config.ini", 0)
If $file = -1 Then
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
	$poz=StringInStr($Line, "=")
	$Parametr = StringLeft($Line, $poz-1)
	$Value=StringMid($Line,$poz+1)
	$aArray[$NS][0]=$Parametr
	$aArray[$NS][1]=$Value
	$NS=$NS+1;
Wend
FileClose($file)




$ParametrsLoad=false
$ParametrsLoad=CheckParametr ($aArray,$Size)
;~ Msgbox(0,"",DriveSpaceFree(GetValue("PathDump",$aArray)))
If DriveSpaceFree(GetValue("PathDump",$aArray)) <3000 then
	WriteLog("������������� ����� " & GetValue("PathDump",$aArray),"logDumpIB.txt",1)
	SendMail("������������� ����� � - " & GetValue("BaseName",$aArray) & "  ��. ����������� � log ����� ",GetValue("mailto",$aArray))
EndIf
If DriveSpaceFree("C:\") <3000 then
	WriteLog("�� ������� " & GetValue("BaseName",$aArray) &  " ������������� ����� �� ����� " & "C:\" ,"logDumpIB.txt",1)
	SendMail("�� ������� " & GetValue("BaseName",$aArray) &  " ������������� ����� �� ����� " & "C:\" ,GetValue("mailto",$aArray))
EndIf
WriteLog("������ ���������� ","logDumpIB.txt",1)

if $ParametrsLoad then
	$TimeStr=_NowDate()
	; ��������� ��� ������ 1�
	$TimeStr = StringReplace($TimeStr, ".", "")
	$NameDump=GetValue("BaseName",$aArray) & "_" & $TimeStr;
	;�������� � DT
	$NomerPoputki=1
	While $NomerPoputki<=3 And Not FileExists(GetValue("PathDump",$aArray) & $NameDump &".dt")
		if GetValue("FileServer",$aArray) = "server" then
			$StrokaZapuska=chr(34) & GetValue("PathProgramm",$aArray) & chr(34) &  " DESIGNER /S " & GetValue("PathServer",$aArray) & "\" & GetValue("PathServerBase",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $NameDump &".dt" & " /DumpResult " & GetValue("PathDump",$aArray) & "result" & $NomerPoputki&".txt"
		Else
			$StrokaZapuska=chr(34) & GetValue("PathProgramm",$aArray) & chr(34) &  " DESIGNER /F " & GetValue("PathServer",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $NameDump &".dt" & " /DumpResult " & GetValue("PathDump",$aArray) & "result" & $NomerPoputki&".txt"
		EndIf
;~  		WriteLog($StrokaZapuska,"logDumpIB.txt",1)
;~ 		exit
;~ 		WriteLog("�� ������","logDumpIB.txt",1)
		if StringLower(GetValue("CloseAll_1c",$aArray)) = "true" then
			ClosseAll_1c($aArray)
		endif
		if StringLower(GetValue("RestartService",$aArray)) = "true" then
			$sServiceName="MSSQL$SQLEXPRESS"
			_StopService("", $sServiceName)
			WriteLog("��������� ������ - " & $sServiceName,"logDumpIB.txt",1)
			Sleep(60000)
			_StartService("", $sServiceName)
			WriteLog("������ ������ - " & $sServiceName,"logDumpIB.txt",1)
			Sleep(60000)

			$sServiceName1c="1C:Enterprise 8.2 Server Agent"
			_StopService("", $sServiceName1c)
			WriteLog("��������� ������ - " & $sServiceName1c,"logDumpIB.txt",1)
			Sleep(60000)
			_StartService("", $sServiceName1c)
			WriteLog("������ ������ - " & $sServiceName1c,"logDumpIB.txt",1)
			Sleep(60000)
		EndIf
		WriteLog("�������� � DT ����, ������� - " & $NomerPoputki,"logDumpIB.txt",1)
		If FileExists(GetValue("PathDump",$aArray) & "result"& $NomerPoputki &".txt") Then
			if FileDelete(GetValue("PathDump",$aArray) & "result"& $NomerPoputki &".txt") = 0 then
				WriteLog("�� ������� ������� ����, result.txt","logDumpIB.txt",1)
			EndIf
		endif
		if Run($StrokaZapuska)=0 Then
			WriteLog("�� ������� ��������� � DT, ��������� ������������ �������� ���������� � ����� config.ini","logDumpIB.txt",1)
	 		SendMail("�� ������� ������� ����� ���� - " & GetValue("BaseName",$aArray) & "  ��. ����������� � log ����� ",GetValue("mailto",$aArray))
			Exit
		EndIf
		$MaksTimeCheck=7200000 ;�� 2-� ����� ��������� ������� ����� result.txt
		$TekTimeCheck=0;
		While not FileExists(GetValue("PathDump",$aArray) & "result"& $NomerPoputki &".txt") and $TekTimeCheck <= $MaksTimeCheck
			sleep(5000)
			$TekTimeCheck=$TekTimeCheck+5000
		Wend
		if FileExists(GetValue("PathDump",$aArray) & "result"& $NomerPoputki &".txt") and $TekTimeCheck <= $MaksTimeCheck	Then
			if not ReadResult(GetValue("PathDump",$aArray) & "result"& $NomerPoputki &".txt") then
				WriteLog("�� ������� ��������� � DT","logDumpIB.txt",1)
		;~ 		SendMail("�� ������� ������� ����� ���� - " & GetValue("BaseName",$aArray) & "  ��. ����������� � log ����� ",GetValue("mailto",$aArray))
			Else
				WriteLog("�������� � DT ���� ���������","logDumpIB.txt",1)
				ExitLoop
			EndIf
		Else
			WriteLog("�� ������� ��������� � DT, result.txt ���, TekTime-" & $TekTimeCheck,"logDumpIB.txt",1)
		EndIf
		;�������� ����� ���������. 5 �����
		sleep(300000)
		$NomerPoputki=$NomerPoputki+1
	WEnd
Else
	WriteLog("��������� �������� �� ���������.","logDumpIB.txt",1)
	SendMail("�� ������� ������� ����� ���� - " & GetValue("BaseName",$aArray) & "  ��. ����������� � log ����� ",GetValue("mailto",$aArray))
endif
if Not FileExists(GetValue("PathDump",$aArray) & $NameDump &".dt") then
	SendMail("�� ������� ������� ����� ���� - " & GetValue("BaseName",$aArray) & "  ��. ����������� � log ����� ",GetValue("mailto",$aArray))
Else
	If FileExists(GetValue("PathDump",$aArray) & "log.txt") then
		WriteLog("Ok",$NameDump & ".txt",1)
		$Poz=StringInStr(GetValue("Scheduler",$aArray), _DateToDayOfWeek (@YEAR, @MON, @MDAY))
		$fl_DTUpload=True
		$TimeBefore=_NowCalc()
		if $Poz<>0 then
			$fl_DTUpload=FtpUpload($NameDump & ".dt",$aArray,"\backup\DT\",false)
			$UploadTime = _DateDiff( 's',$TimeBefore,_NowCalc())
			$UploadTime=Round($UploadTime/60,2)
			WriteLog("����� �������� �� FTP " & $UploadTime & " �����","logDumpIB.txt",1)
			WriteLog("����� �������� �� FTP " & $UploadTime & " �����",$NameDump & ".txt",1)
		EndIf
		if $fl_DTUpload Then
			FtpUpload($NameDump & ".txt",$aArray,"\backup\",true)
		EndIf
	EndIf
EndIf
if FileExists(GetValue("PathDump",$aArray) & $NameDump &".dt") then
	DeleteOldDT($aArray)
EndIf
WriteLog("����� ���������� ","logDumpIB.txt",1)
;~ DeleteOld_DB2_BAP($aArray)


func GetCountOfLines()
	$fileSize = FileOpen($Path & "config.ini", 0)
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
;~ 	MsgBox(0, "Error", @error)
	$iIndex = _ArraySearch($aArray, $Parametr, 0, 0, 0, 1, 1, 0)
	if @error <> 0 Then
		if @error=6 then
			MsgBox(0, "Error", "��������-" & $Parametr & " �� ������ � �������")
		EndIf
	else
		Return $aArray[$iIndex][1]
	EndIf
EndFunc

Func CheckParametr ($aArray,$Size)
	For $i = 0 to $Size-1
		$Parametr=$aArray[$i][0]
		$Value=$aArray[$i][1]
;~ 		if $Parametr="FileServer" Then
;~ 			$Value=StringLower($Value)
;~ 			if $Value<>"server" And $Value<>"file" Then
;~ 				WriteLog("�� ��������� ������ ��� ��, ���������� ������� file/server, � ����� config.ini","logConfig.txt",2)
;~ 				return false
;~ 			endif
;~ 		endif
		if $Parametr="PathProgramm" or $Parametr="PathDump"	or $Parametr="user"	or $Parametr="BaseName"	Then
			$Value=StringReplace($Value, " ", "")
			if $Value="" Then
				WriteLog("��������� PathProgramm/PathDump/user/BaseName, � ����� config.ini","logConfig.txt",2)
				return false
			endif
		endif
		if $Parametr="PathServer" or $Parametr="PathServerBase" then
			$Value=StringReplace($Value, " ", "")
			if $Value="" Then
				WriteLog("��������� PathServer/PathServerBase, � ����� config.ini","logConfig.txt",2)
				return false
			endif
		endif
		if $Parametr="CloseAll_1c" Then
			$Value=StringLower($Value)
			if  $Value<> "false" and $Value<> "true"then
				WriteLog("����������� �������� CloseAll_1c,���������� ������� true/false, � ����� config.ini","logConfig.txt",2)
				return false
			endif
		EndIf
;~ 		if $Parametr="SQLService" Then
;~ 			$Value=StringLower($Value)
;~ 			if  $Value<> "db2" and $Value<> "mssqlserver"then
;~ 				WriteLog("����������� �������� SQLService,���������� ������� db2/mssqlserver, � ����� config.ini","logConfig.txt",2)
;~ 				return false
;~ 			endif
;~ 		EndIf
;~ 		if $Parametr="1cAgent" Then
;~ 			$Value=StringLower($Value)
;~ 			if  $Value<> "1c:enterprise 8.2 server agent" then
;~ 				WriteLog("����������� �������� 1cAgent,���������� ������� 1c:enterprise 8.2 server agent, � ����� config.ini","logConfig.txt",2)
;~ 				return false
;~ 			endif
;~ 		EndIf
	Next
	If FileExists($Path & "logConfig.txt") Then
		FileDelete($Path & "logConfig.txt")
	endif
	return true
EndFunc
Func WriteLog($Text,$NameLog,$Mode)
	$Time=_Date_Time_GetLocalTime()
	$Time=_Date_Time_SystemTimeToDateTimeStr($Time)
	$logfile = FileOpen($Path & $NameLog, $Mode)
	FileWriteLine($logfile,$Time & "-" & $Text)
	FileClose($logfile)
EndFunc
Func DeleteBigLog ()
	If FileExists($Path & "logDumpIB.txt") Then
		$sizelog = FileGetSize($Path & "logDumpIB.txt")
		$sizelog=$sizelog/1000000
		if $sizelog >=2 then
			FileDelete($Path & "logDumpIB.txt")
		EndIf
	endif
endfunc

Func ReadResult($FileResult)
	$fileRes = FileOpen($FileResult, 0)
	; Check if file opened for reading OK
	If $fileRes = -1 Then
;~ 		MsgBox(0, "Error", "Unable to open file.")
		WriteLog("Unable to open file result.txt","logDumpIB.txt",1)
		return false
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
;~ 	WriteLog("�������� v82.COMConnector" ,"logDumpIB.txt",1)
	$oShell = ObjCreate("v82.COMConnector")
;~ 	WriteLog("$oShell.ConnectAgent" ,"logDumpIB.txt",1)
;~ 	WriteLog(GetValue("PathServer",$aArray) ,"logDumpIB.txt",1)
	$Agent=$oShell.ConnectAgent(GetValue("PathServer",$aArray));
;~ 	WriteLog("$Agent.GetClusters()" ,"logDumpIB.txt",1)
	$Klasters=$Agent.GetClusters();
	$BaseName=GetValue("PathServerBase",$aArray)
	WriteLog("���������� ������� �� ���� - " & $BaseName ,"logDumpIB.txt",1)
	For $Klaster In $Klasters
		$Name=GetValue("user",$aArray)
;~ 		$Agent.AuthenticateAgent("", "")
 		$Agent.Authenticate($Klaster,"", "")
;~ 		$Agent.Authenticate($Klaster,$Name, "")
		$Proceses=$Agent.GetWorkingProcesses($Klaster)
		For $Process In $Proceses
			$Port=$Process.MainPort
			$WorkingProcess= $oShell.ConnectWorkingProcess(GetValue("PathServer",$aArray) & ":" & $Port)
			$WorkingProcess.AddAuthentication($Name,$PSD)
			$InfoBase=""
			$Bases=$Agent.GetInfoBases($Klaster)
			For $Base in $Bases
				if $Base.Name=$BaseName Then
					$InfoBase=$Base
;~   				$Base.DeniedFrom=StringReplace(_NowCalcDate(),"/","")
;~ 					$Base.DeniedFrom=_NowCalc()
;~ 					$Base.DeniedTo=_DateAdd( 'n',30,_NowCalc())
;~ 					$Base.DeniedMessage="���� � " & $Base.DeniedFrom & " �� " & $Base.DeniedTo & " �������� �� �����"
;~ 					$Base.PermissionCode="77"
;~  				$Base.SessionsDenied=0
;~ 					$Base.ScheduledJobsDenied=
;~  				MsgBox(0,"", $Base.SessionsDenied)
;~ 					MsgBox(0,"","����-" & $Base.DeniedTo)
;~ 					$Base.Descr="adsf"
;~ 					Exit
					ExitLoop
				EndIf
			Next
			if $InfoBase="" Then
				WriteLog("���� �� ���������� - " & $BaseName ,"logDumpIB.txt",1)
			else
				$Sessions=$Agent.GetInfoBaseSessions($Klaster, $InfoBase)
				For $Session in $Sessions
					$Agent.TerminateSession($Klaster, $Session)
				Next
				$Connections=$Agent.GetInfoBaseConnections($Klaster, $InfoBase)
				For $Connection in $Connections
					$WorkingProcess.Disconnect($Connection)
				Next
			EndIf
		Next
	Next
	WriteLog("������ ��������� �� ���� - " & $BaseName ,"logDumpIB.txt",1)
EndFunc

;~ �������������

Func SendMail($Text,$ToAddress)
	$SmtpServer = "smtp.mail.ru"              ; address for the smtp-server to use - REQUIRED
	$FromName = "Dump"                      ; name from who the email was sent
	$FromAddress = "BlizzardAnton@mail.ru" ; address from where the mail should come
;~ 	$ToAddress = "BlizzardAnton@mail.ru"   ; destination address of the email - REQUIRED
	$Subject = $Text                   ; subject from the email - can be anything you want it to be
	$Body = $Text ; the messagebody from the mail - can be left blank but then you get a blank mail
	$AttachFiles = ""                       ; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
	if $ToAddress <> "BlizzardAnton@mail.ru" then
		$CcAddress = "BlizzardAnton@mail.ru"       ; address for cc - leave blank if not needed
	Else
		$CcAddress = ""
	EndIf
	$BccAddress = ""     ; address for bcc - leave blank if not needed
	$Importance = "Normal"                  ; Send message priority: "High", "Normal", "Low"
	$Username = "BlizzardAnton"                    ; username for the account used from where the mail gets sent - REQUIRED
	$Password = "ghtptyn ajh . 31"                  ; password for the account used from where the mail gets sent - REQUIRED
	$IPPort = 25                            ; port used for sending the mail
	$ssl = 0                                ; enables/disables secure socket layer sending - put to 1 if using httpS
	$IPPort=465                          ; GMAIL port used for sending the mail
	$ssl=1                               ; GMAILenables/disables secure socket layer sending - put to 1 if using httpS
	_SendMail ($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
EndFunc
Func _SendMail ($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
	$rc = _INetSmtpMailCom($SmtpServer, $FromName, $FromAddress, $ToAddress, $Subject, $Body, $AttachFiles, $CcAddress, $BccAddress, $Importance, $Username, $Password, $IPPort, $ssl)
	If @error Then
;~ 		MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
		WriteLog("�� ������� ��������� ��������� �� �����","logDumpIB.txt",1)
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

Func DeleteOld_DB2_BAP($aArray)
	$SizeDT=GetCountFilesDT(GetValue("PathDumpDB2",$aArray) & "*.001")
	if $SizeDT <= 5 then
		return 0
	EndIf
	Dim $arrayDB2[$SizeDT][3]
	$search = FileFindFirstFile(GetValue("PathDumpDB2",$aArray) & "*.001")
	If $search = -1 Then
		WriteLog("No files/directories matched the search pattern","logDumpIB.txt",1)
		Exit
	EndIf
	$NS=0;

	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		$t=FileGetTime(GetValue("PathDumpDB2",$aArray) & $file, 1)
		If Not @error Then
			$yyyymd = $t[0] & "/" & $t[1] & "/" & $t[2]
		EndIf
		$arrayDB2[$NS][0]=$yyyymd
		$arrayDB2[$NS][1]=GetValue("PathDumpDB2",$aArray) & $file
		if _DateToDayOfWeek ($t[0] , $t[1], $t[2]) =1 then
			$arrayDB2[$NS][2]=True
		Else
			$arrayDB2[$NS][2]=false
		EndIf
		$NS=$NS+1
	WEnd

	FileClose($search)
;~ 	_ArrayDisplay($arrayDB2)
	$FiveDayEarly=_DateAdd( 'd',-5,_NowCalcDate())
	For $i = 0 to $SizeDT -1
		$FileDelete=False
		if $FiveDayEarly > $arrayDB2[$i][0] Then
			$FileDelete=True
		EndIf
		if $FileDelete Then
			WriteLog("������ ������ ����� - " & $arrayDB2[$i][1],"logDumpIB.txt",1)
			FileDelete($arrayDB2[$i][1])
		EndIf
	Next
EndFunc

Func DeleteOldDT($aArray)
;~ 	$SizeDT=GetCountFilesDT("C:\Temp\samara*.dt")
	$SizeDT=GetCountFilesDT(GetValue("PathDump",$aArray) & GetValue("BaseName",$aArray) & "*.dt")
	if $SizeDT <= GetValue("CountOfDT",$aArray) then
		return 0
	EndIf
	Dim $arrayDT[$SizeDT][3]

	$search = FileFindFirstFile(GetValue("PathDump",$aArray) & GetValue("BaseName",$aArray) & "*.dt")
	If $search = -1 Then
		WriteLog("No files/directories matched the search pattern","logDumpIB.txt",1)
		Exit
	EndIf
	$NS=0;
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		$t=FileGetTime(GetValue("PathDump",$aArray) & $file, 1)
		If Not @error Then
			$yyyymd = $t[0] & "/" & $t[1] & "/" & $t[2]
		EndIf
		$arrayDT[$NS][0]=$yyyymd
		$arrayDT[$NS][1]=GetValue("PathDump",$aArray) & $file
		if _DateToDayOfWeek ($t[0] , $t[1], $t[2]) =1 then
			$arrayDT[$NS][2]=True
		Else
			$arrayDT[$NS][2]=false
		EndIf
		$NS=$NS+1
	WEnd
	FileClose($search)
	_ArraySort($arrayDT, 1 ,  0, 0, 0)
	$MaxKolvoVoskr=4
	$NVoskr=0
	$SevenDayEarly=_DateAdd( 'd',-7,_NowCalcDate())
	For $i = 0 to $SizeDT -1
		$FileDelete=False
		if $SevenDayEarly > $arrayDT[$i][0] Then
;~ 			MsgBox(-1,"",StringRight($arrayDT[$i][0],2))
			if StringRight($arrayDT[$i][0],2)<>"01" AND StringRight($arrayDT[$i][0],2)<>"02" then
				if $arrayDT[$i][2] Then
					$NVoskr=$NVoskr+1
					If $NVoskr>4 Then
						$FileDelete=True
					EndIf
				Else
					$FileDelete=True
				EndIf
			EndIf
		EndIf
		if $FileDelete Then
			WriteLog("������ ������ ����� - " & $arrayDT[$i][1],"logDumpIB.txt",1)
			FileDelete($arrayDT[$i][1])
		EndIf
	Next
EndFunc
Func GetCountFilesDT($StrSearch)
	$CountOfDT=0;
	$search = FileFindFirstFile($StrSearch)
	If $search = -1 Then
;~ 		MsgBox(0, "Error", "No files/directories matched the search pattern")
		Exit
	EndIf
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
;~ 		MsgBox(4096, "File:", $file)
		$CountOfDT=$CountOfDT+1
	WEnd
	Return $CountOfDT
EndFunc
Func FtpUpload($NameFile,$aArray,$FolderFTP,$flDeleteFile)
	;~ $server = '80.254.106.235'
	$server = GetValue("FTP_IP",$aArray)
	$username = "ftp_almaz"
	$pass = "qw12ftp061"
	$Open = _FTP_Open("almazFTP")
	$Conn = _FTP_Connect($Open, $server, $username, $pass,1)
	if  $Conn=0 Then
		WriteLog("�� ���������� ����������� � FTP.","logDumpIB.txt",1)
	endIf
	$CurrentDir="backup/"
	if $FolderFTP = "\backup\DT\" then
		$CurrentDir="backup/DT/"
	EndIf
	if _FTP_DirSetCurrent($Conn, $CurrentDir)=0 Then
		WriteLog("�� ���������� ���������� ������� ������� FTP.","logDumpIB.txt",1)
	EndIf
	$s_LocalFile=$Path & $NameFile
	$s_RemoteFile=$FolderFTP & $NameFile
	if _FTP_FilePut($Conn, $s_LocalFile, $s_RemoteFile) =0  Then
;~ 		MsgBox(-1,"",@ERROR)
		if $FolderFTP = "\backup\DT\" then
			$Ftpc = _FTP_Close($Open)
			WriteLog("�� ������� ����������� "& $NameFile &" �� FTP.","logDumpIB.txt",1)
			Return False
		EndIf
	Else
		WriteLog("���������� " & $NameFile & " �� FTP.","logDumpIB.txt",1)
	EndIf
	$Ftpc = _FTP_Close($Open)
	if $flDeleteFile then
		FileDelete($Path & $NameFile)
	endif
	Return true
EndFunc