#include <GUIConstantsEx.au3>
#Include <Array.au3>
#include <Date.au3>
;~ #include <ServiceControl.au3>
#Include <file.au3>
#include <GUIConstants.au3>
#include <FTPEx.au3>
#include <EditConstants.au3>

;~ Opt('MustDeclareVars', 1)
Global $TextSMS,$Button_1,$Label_1

Example()


Func Example()
	Local $msg,$ToAddress
	GUICreate("������ �������",220,100) ; will create a dialog box that when displayed is centered
	GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
	Opt("GUIOnEventMode", 1)
	Opt("GUICoordMode", 1)

	$TextSMS = GUICtrlCreateEdit("", 10, 10, 200,55)
;~ 	GUICtrlSetOnEvent ($TextSMS, "ChangeLabel")
	GUICtrlSetLimit ($TextSMS, 500)



	$Button_1 = GUICtrlCreateButton("��������� ", 10, 70, 185,22)
	GUICtrlSetOnEvent ($Button_1, "SendSMS")

	$Label_1=GUICtrlCreateLabel("70", 200, 75)


	GUISetState(@SW_SHOW)      ; will display an  dialog box with 2 button
;~ 	MsgBox(-1,"","ds")
	; Run the GUI until the dialog is closed
	While 1
		Sleep(100)
		$Text=GUICtrlRead($TextSMS)
		GUICtrlSetData ($Label_1, 500-StringLen($Text))
	WEnd
EndFunc   ;==>Example

Func SendSMS()
	$ToAddress="Bliz@mailsms.megafonkavkaz.ru"
	$Text=GUICtrlRead($TextSMS)
	if StringLen($Text)>0 Then
		GUICtrlSetState($Button_1, $GUI_DISABLE) 	; the focus is on this button
		GUICtrlSetState ($TextSMS, $GUI_HIDE)
		GUICtrlSetState ($Label_1, $GUI_HIDE)
		GUICtrlSetPos ($Button_1, 10, 8 , 200, 85)
		GUICtrlSetData ($Button_1, "�������� ...")
		SendMail($Text,$ToAddress)
		GUICtrlSetData ($Button_1, "��������� ������� ����������")
		Sleep(2000)
 		Close()
	EndIf
EndFunc
;~ Func ChangeLabel()
;~ 	$Text=GUICtrlRead($TextSMS)
;~ 	GUICtrlSetData ($Label_1, 70-StringLen($Text))
;~ EndFunc

Func Close()
	Exit
EndFunc

Func SendMail($Text,$ToAddress)
	$SmtpServer = "smtp.mail.ru"              ; address for the smtp-server to use - REQUIRED
	$FromName = "Dump"                      ; name from who the email was sent
;~ 	$FromAddress = "BlizzardAnton@mail.ru" ; address from where the mail should come
	$FromAddress = "BlizzardAnton@mail.ru" ; address from where the mail should come
;~ 	$ToAddress = "BlizzardAnton@mail.ru"   ; destination address of the email - REQUIRED
	$Subject = $Text                   ; subject from the email - can be anything you want it to be
	$Body = $Text ; the messagebody from the mail - can be left blank but then you get a blank mail
	$AttachFiles = ""                       ; the file(s) you want to attach seperated with a ; (Semicolon) - leave blank if not needed
	$CcAddress = ""
;~ 	if $ToAddress <> "BlizzardAnton@mail.ru" then
;~ 		$CcAddress = "BlizzardAnton@mail.ru"       ; address for cc - leave blank if not needed
;~ 	Else

;~ 	EndIf
	$BccAddress = ""     ; address for bcc - leave blank if not needed
	$Importance = "Normal"                  ; Send message priority: "High", "Normal", "Low"
	$Username = "BlizzardAnton"                    ; username for the account used from where the mail gets sent - REQUIRED
	$Password = "kfqa bp uel 31"                  ; password for the account used from where the mail gets sent - REQUIRED
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
;~ 		WriteLog("�� ������� ��������� ��������� �� �����","logDumpIB.txt",1)
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
        Return ""
    EndIf
    $objEmail=""
EndFunc   ;==>_INetSmtpMailCom
;
;
; Com Error Handler
Func MyErrFunc()
;~     $HexNumber = Hex($oMyError.number, 8)
;~     $oMyRet[0] = $HexNumber
;~     $oMyRet[1] = StringStripWS($oMyError.description, 3)
;~     ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
;~     SetError(1); something to check for when this function returns
    Return ""
EndFunc   ;==>MyErrFunc
