#include <FTPEx.au3>
#Include <Array.au3>
#Include <File.au3>

Global $oMyError,$oMyRet[5]
;~ $server = '80.254.106.235'
$server = "192.168.0.7"
$username = "ftp_almaz"
$pass = "qw12ftp061"
$Open = _FTP_Open("almazFTP")
$Conn = _FTP_Connect($Open, $server, $username, $pass,0)
if _FTP_DirSetCurrent($Conn, "backup/")=0 Then
;~ 	MsgBox(0, "Error",  @error)
EndIf
$aFiles = _FTP_ListToArray($Conn, 2)

;~ MsgBox(-1,"",$aFiles)
;~ _ArrayDisplay($aFiles)
;~ ConsoleWrite('$NbFound = ' & $aFile[0] & '  -> Error code: ' & @error & @crlf)
;~ ConsoleWrite('$Filename = ' & $aFile[1] & @crlf)
$SizeCheckBases=7
Dim $CheckBases[$SizeCheckBases][3]
$CheckBases[0][0]="cimlyansk"
$CheckBases[1][0]="ural"
$CheckBases[2][0]="kursk"
$CheckBases[3][0]="foratex"
$CheckBases[4][0]="tver"
$CheckBases[5][0]="moscow"
;~ $CheckBases[6][0]="samara"
;~ $CheckBases[6][0]="LDVS"
;~ $CheckBases[7][0]="LDNN"
;~ $CheckBases[8][0]="LDS"
;~ $CheckBases[6][0]="ldv"
;~ $CheckBases[10][0]="ldkz"
$CheckBases[6][0]="kiev"

$TimeStr=_NowDate()
$TimeStr = StringReplace($TimeStr, ".", "")
$flNetBackup=false
If $aFiles <> 0 and true	then
	For $File in $aFiles
		$FileName=StringLower($File)
		$NS=0
		While $NS <= $SizeCheckBases-1
	;~ 		MsgBox(0, "",$NS)
			$CheckBase=$CheckBases[$NS][0]
			$PozStart=StringInStr($FileName,"_")
			$NameDT=StringLeft($FileName,$PozStart-1)
			$NameDT=StringReplace($NameDT, "\", "")
			$NameDT=StringReplace($NameDT, "backup", "")
;~ 			ConsoleWrite($NameDT & @CRLF)
			$Poz = StringInStr($FileName, $CheckBase)
			If $NameDT <> $CheckBase Then
	;~ 			$TextMail=$TextMail & $CheckBase & ","
			Else
				$PozStart=0
;~ 				$PozStart=$Poz + StringLen($CheckBase) + 1
				$PozStart=StringInStr($FileName,"_")+1
				$TimeBackup=StringMid($FileName,$PozStart, 8)

				if $TimeStr =$TimeBackup Then
					$CheckBases[$NS][1]=true
					$CheckBases[$NS][2]=$FileName
				Else
					if _FTP_FileDelete($Conn, $File) = 0 Then
						if _FTP_FileDelete($Conn,"\backup\" & $File) = 0 Then
	 						;MsgBox(0, "","\backup\" & $FileName)
						EndIf
					EndIf
				EndIf
	;~ 			MsgBox(0, ""," Base " & $CheckBase & " time - " & $TimeBackup)
			EndIf
			$NS=$NS+1
		WEnd
	Next
Else
	$flNetBackup=True
EndIf
;~ _ArrayDisplay($CheckBases)
;~ Exit
$TextMail="Для филиала(-ов): "
$NS=0
While $NS <= $SizeCheckBases-1
	If $aFiles <> 0 then
		if $CheckBases[$NS][1]<>True Then
			$flNetBackup=true
			$TextMail=$TextMail & $CheckBases[$NS][0] & ","
		EndIf
	Else
		$TextMail=$TextMail & $CheckBases[$NS][0] & ","
	EndIf
	$NS=$NS+1
WEnd
$TextMail=StringLeft($TextMail,StringLen($TextMail)-1)
$TextMail=$TextMail & " не созданы бекапы"
;~ MsgBox(-1,"",$TextMail)
;~ Exit
If $flNetBackup and  True  Then
	SendMail($TextMail,"s_omel@list.ru")
;~ 	SendMail($TextMail,"Bliz@mailsms.megafonkavkaz.ru")
	SendMail($TextMail,"BlizzardAnton@mail.ru")
EndIf


If True then
	;Оставить по 3 Бекапа на ФТП для каждого филиала
	if _FTP_DirSetCurrent($Conn, "DT/")=0 Then
	;~ 	MsgBox(0, "Error",  @error)
	EndIf
	$aFilesDT = _FTP_ListToArrayEx($Conn, 2,0,0)
	$TekFilial=""
	$idDt=1
	Dim $DT_filiala[1][2]
	Dim $Array_DTFilial[11]
	Dim $Del_Array[1]
	$idDelDT=1
;~ 	_ArrayDisplay($aFilesDT)
	For $id=1 to $aFilesDT[0][0]
		$PozPod4=StringInStr(StringLower($aFilesDT[$id][0]),"_")
		$ObrFilial=StringLeft($aFilesDT[$id][0],$PozPod4-2)

		if $TekFilial = "" or $TekFilial<>$ObrFilial Then
			if $TekFilial <> "" then
				_ArraySort($DT_filiala,1,0,0,1)
				if $idDt > 3 then
					For $idFiliala=0 to $idDt-1
						if $idFiliala>2 then
;~ 							ConsoleWrite($idDt)
							$Del_Array[$idDelDT-1]=$DT_filiala[$idFiliala][0]
							$idDelDT=$idDelDT+1
							ReDim $Del_Array[$idDelDT]
						EndIf
					Next
				EndIf
			EndIf
			$TekFilial=$ObrFilial
			Dim $DT_filiala[1][2]
			$idDt=1
			$DT_filiala[0][0]=$aFilesDT[$id][0]
			$DT_filiala[0][1]=$aFilesDT[$id][3]

		Else
			$idDt=$idDt+1
			ReDim $DT_filiala[$idDt][2]
			$DT_filiala[$idDt-1][0]=$aFilesDT[$id][0]
			$DT_filiala[$idDt-1][1]=$aFilesDT[$id][3]
		EndIf
	Next
	if $TekFilial <> "" then
		_ArraySort($DT_filiala,1,0,0,1)
		if $idDt > 3 then
			For $idFiliala=0 to $idDt-1
				if $idFiliala>2 then
;~ 					ConsoleWrite($idDt)
					$Del_Array[$idDelDT-1]=$DT_filiala[$idFiliala][0]
				EndIf
			Next
		EndIf
	EndIf
;~ 	_ArrayDisplay($Del_Array)
;~ 	Exit
;~ 	_ArraySort( $aFilesDT,0,1,0,3)
;~ 	_ArraySort( $aFilesDT,0,1,0,0)
;~ 	_ArrayDisplay($aFilesDT)
;~ 	Exit


;~ 	_ArrayDisplay($aFilesDT)
;~ 	Dim $Del_Array[$aFilesDT[0]]
;~ 	$TekFilial=""
;~ 	$MaxKolVoDT=3
;~ 	$KolVoDT=0
;~ 	$idDel=0
;~ 	For $id=1 to $aFilesDT[0]
;~ 		$PozPod4=StringInStr(StringLower($aFilesDT[$id]),"_")
;~ 		$ObrFilial=StringLeft($aFilesDT[$id],$PozPod4-2)
;~ 		if $TekFilial = "" or $TekFilial<>$ObrFilial Then
;~ 			$KolVoDT=1
;~ 			$TekFilial=$ObrFilial
;~ 		Else
;~ 			$KolVoDT=$KolVoDT+1
;~ 			if $KolVoDT>$MaxKolVoDT then
;~ 	;~ 			MsgBox(-1,"",$aFilesDT[$id])
;~ 				$Del_Array[$idDel]=$aFilesDT[$id]
;~ 				$idDel=$idDel+1
;~ 			EndIf
;~ 		EndIf
;~ 	Next
;~ 	_ArrayDisplay($Del_Array)
;~ 	Exit
	For $id=0 to $idDelDT-1
		if $Del_Array[$id]<>"" then
;~ 			MsgBox(-1,"",$Del_Array[$id])
			if _FTP_FileDelete($Conn, $Del_Array[$id]) = 0 Then
				if _FTP_FileDelete($Conn,"\backup\" & $Del_Array[$id]) = 0 Then
				EndIf
			EndIf
		EndIf
	Next
;~ 	Exit
EndIf

;~ $s_LocalFile="C:\1.jpg"
;~ $s_RemoteFile="backup\1.jpg"
;~ if _FTP_FilePut($Conn, $s_LocalFile, $s_RemoteFile) =0  Then
;~ 	MsgBox(0, "Error",  @error)
;~ EndIf


$Ftpc = _FTP_Close($Open)




Func SendMail($Text,$ToAddress)
	$SmtpServer = "smtp.mail.ru"              ; address for the smtp-server to use - REQUIRED
	$FromName = "Dump"                      ; name from who the email was sent
	$FromAddress = "BlizzardAnton@mail.ru" ; address from where the mail should come
;~ 	$ToAddress = "BlizzardAnton@mail.ru"   ; destination address of the email - REQUIRED
	$Subject = $Text                   ; subject from the email - can be anything you want it to be
	$Body = $Text ; the messagebody from the mail - can be left blank but then you get a blank mail
	$AttachFiles = ""
	$CcAddress = ""
;~ 	if $ToAddress <> "BlizzardAnton@mail.ru" then
;~ 		$CcAddress = "BlizzardAnton@mail.ru"       ; address for cc - leave blank if not needed
;~ 	Else
;~ 		$CcAddress = ""
;~ 	EndIf
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
;~ 		WriteLog("Не удалось отправить сообщение на почту","logDumpIB.txt",1)
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
;~ 		Return 0
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