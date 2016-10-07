;~ #Region ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #AutoIt3Wrapper_Icon="C:\1cestart.ico"

#Include <Array.au3>
#include <Date.au3>
#include <ServiceControl.au3>
#Include <file.au3>
#include <GUIConstants.au3>
#include <FTPEx.au3>
#include <WinNet.au3>
Global $Path=@ScriptDir & "\"
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Global $ArraySizeParametrs=0
Global $CurrentUser = "Comp: " & @ComputerName & " User: " &  @UserName

CheckUpdate()


$FirstStart=false
If not FileExists($Path & "config.ini") Then
	;Создать файл config.ini с параметрами по умолчанию
;~ 	"C:\Program Files (x86)\1cv82\common\1cestart.exe" enterprise /S a10-s1c\reg063 /RunModeOrdinaryApplication
	$file = FileOpen($Path & "config.ini", 1)
	FileWriteLine($file, "UPP82= необходимо указать СерверБД в формате ИмяСервера\ИмяБазы")
	FileWriteLine($file, "ИмяБазы=ИмяСервера\ИмяБазы")
	FileClose($file)
	$FirstStart=true
EndIf
If $FirstStart Then
	Exit
EndIf




;Считываем параметры из файла
$file = FileOpen($Path & "config.ini", 0)
If $file = -1 Then
	WriteLog("Unable to open file config.ini","logStart.txt",1)
	SendMail($CurrentUser & " Не удалось запустить 1с -  Unable to open file config.ini ","BlizzardAnton@mail.ru")
	Exit
EndIf

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
	$ArraySizeParametrs=$ArraySizeParametrs+1
Wend
FileClose($file)
;~ _ArrayDisplay($aArray)

;~ $StrokaZapuska=chr(34) & GetValue("PathProgramm",$aArray) & chr(34) &  " DESIGNER /S " & GetValue("PathServer",$aArray) & "\" & GetValue("PathServerBase",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $NameDump &".dt" & " /DumpResult " & GetValue("PathDump",$aArray) & "result" & $NomerPoputki&".txt"

$BaseName=""
For $id = 1 to $CmdLine[0]
	$Line=$CmdLine[$id]
	$poz=StringInStr($Line, "-")
	$Parametr = StringLeft($Line, $poz-1)
	$Value=StringMid($Line,$poz+1)
	if $Parametr = "b" then
		$BaseName=$Value
		$CurrentUser = "Comp: " & @ComputerName & " User: " &  @UserName & " $BaseName " & $BaseName
	EndIf
Next
;~ _ArrayDisplay($CmdLine)
;~ exit

;~ $ServerBase="a10-s1c\reg063"

$ServerBase = GetValue($BaseName,$aArray)


If $ServerBase = "" Then
	WriteLog("Не удалось запустить 1с, не удалось получить имя базы, путь до базы " & $BaseName ,"logStart.txt",1)
	SendMail($CurrentUser & " Не удалось запустить 1с - " & $ServerBase & "  " & $BaseName & "  см. подробности в log файле ","BlizzardAnton@mail.ru")
	Exit
EndIf

$PathProgramm="c:\Program Files\1cv82\common\1cestart.exe"
If not FileExists($PathProgramm) Then
	$PathProgramm="C:\Program Files (x86)\1cv82\common\1cestart.exe"
	If not FileExists($PathProgramm) Then
		WriteLog("Не удалось запустить 1с, не удалось получить путь до 1cestart.exe" & $BaseName ,"logStart.txt",1)
		SendMail($CurrentUser & " Не удалось запустить 1с, не удалось получить путь до 1cestart.exe" & $ServerBase & "  " & $BaseName & "  см. подробности в log файле ","BlizzardAnton@mail.ru")
		Exit
	EndIf
EndIf
;~ $PathProgramm = GetValue("PathProgramm",$aArray)
;~ ConsoleWrite($PathProgramm)

if $BaseName="ldkg_unf" Then
	$StrokaZapuska= chr(34) & $PathProgramm & chr(34) & " enterprise /S " & $ServerBase
Else
	$StrokaZapuska= chr(34) & $PathProgramm & chr(34) & " enterprise /S " & $ServerBase &" /RunModeOrdinaryApplication"
EndIf



if Run($StrokaZapuska)=0 Then
	WriteLog("Не удалось запустить 1с, проверьте правильность значения параметров в файле config.ini","logStart.txt",1)
	SendMail($CurrentUser & " Не удалось запустить 1с - " & $ServerBase& "  см. подробности в log файле ","BlizzardAnton@mail.ru")
	Exit
EndIf

Func CheckUpdate()
	$PathConfigCurrent = $Path & "config.ini"
	$PathConfigDomain = "\\a1-dc\SYSVOL\alm.local\1c Refs\config.ini"
	if FileExists ($PathConfigDomain)=1 Then
		if FileGetTime ($PathConfigCurrent,0,1)=FileGetTime ($PathConfigDomain,0,1)	AND FileGetSize ($PathConfigCurrent)=FileGetSize ($PathConfigDomain) Then
		Else
			If FileCopy ($PathConfigDomain, $PathConfigCurrent,1) = 0 Then
;~ 			ConsoleWrite(@ComSpec & ' /c ' & 'xcopy /E /C /G /H /K /O /X /Y "' & $PathConfigDomain & '" "' & $PathConfigCurrent & '"')
;~ 			RunWait(@ComSpec & ' /c ' & 'xcopy /E /C /G /H /K /O /X /Y "' & $PathConfigDomain & '" "' & $PathConfigCurrent & '"')
;~ 			Sleep(2000)
;~ 			if FileGetTime ($PathConfigCurrent,0,1)=FileGetTime ($PathConfigDomain,0,1)	AND FileGetSize ($PathConfigCurrent)=FileGetSize ($PathConfigDomain) then
;~ 			Else
				WriteLog("Не удалось обновить " & $PathConfigDomain,"logStart.txt",1)
				SendMail($CurrentUser & " Не удалось обновить " & $PathConfigDomain,"BlizzardAnton@mail.ru")
			EndIf
		EndIf
	Else
		WriteLog("Недоступен " & $PathConfigDomain,"logStart.txt",1)
		SendMail($CurrentUser & " Недоступен " & $PathConfigDomain,"BlizzardAnton@mail.ru")
	EndIf
EndFunc

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
;~ 	ConsoleWrite($Parametr & @CRLF)
;~ 	$iIndex = _ArraySearch($aArray, $Parametr, 0, 0, 0, 1, 1, 1)
;~ 	if @error <> 0 Then
;~ 		if @error=6 then
;~ 			MsgBox(0, "Error", "Параметр-" & $Parametr & " не найден в массиве")
;~ 			WriteLog("Параметр-" & $Parametr & " не найден в массиве","logStart.txt",1)
;~ 			Return ""
;~ 		EndIf
;~ 	else
;~ 		Return $aArray[$iIndex][1]
;~ 	EndIf
	For $iIndex = 0 to $ArraySizeParametrs-1
		if $aArray[$iIndex][0] = $Parametr Then
			Return $aArray[$iIndex][1]
		EndIf
	Next
EndFunc

Func WriteLog($Text,$NameLog,$Mode)
	$Time=_Date_Time_GetLocalTime()
	$Time=_Date_Time_SystemTimeToDateTimeStr($Time)
	$logfile = FileOpen($Path & $NameLog, $Mode)
	FileWriteLine($logfile,$Time & "-" & $Text)
	FileClose($logfile)
EndFunc


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