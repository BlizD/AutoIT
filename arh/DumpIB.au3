#Include <Array.au3>
#include <Date.au3>
#include <ServiceControl.au3>

$PSD="dumpday"





;Dim $asArray[6][2] = [[1, "A"],[2, "B"],[3, "C"],[1, "a"],[2, "b"],[3, "c"]]
;_ArrayDisplay($aArray, "$aArray")


;��������� �� ����� ����������� ����������
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
	;������� ���� conf.cfg � ����������� �� ���������
	$file = FileOpen("config.ini", 1)
	FileWriteLine($file, "PathProgramm=" & """c:\Program Files\1cv82\common\1cestart.exe""")
	FileWriteLine($file, "FileServer=������� ��������/��������� ���� file/server")
	FileWriteLine($file, "PathFile=" & """D:\����������\""")
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
	; ��������� ��� ������ 1�, ���������/������ ����� ������1� � DB2/MSSQL
	if StringLower(GetValue("CloseAll_1c",$aArray)) = "true" then
		$sServiceName=GetValue("1cAgent",$aArray)
		_StopService("", $sServiceName)
		WriteLog("��������� ������ 1cAgent","logDumpIB.txt",1)
		$sSQLService=GetValue("SQLService",$aArray)		
		_StopService("", $sSQLService)
		WriteLog("��������� ������ SQLService","logDumpIB.txt",1)
		Sleep(120000) ;�������� ����� ��� ���������� ��������� ����� 2 ������
		While _ServiceRunning("", $sSQLService) = 0
			_StartService("", $sSQLService)
			WriteLog("����� ������ SQLService","logDumpIB.txt",1)
			Sleep(60000) ;1 ������ �������� ����� ��������� ������� SQL ������
		WEnd
		While _ServiceRunning("", $sServiceName) = 0
			_StartService("", $sServiceName)
			WriteLog("����� ������ 1cAgent","logDumpIB.txt",1)
			Sleep(60000) ;1 ������ �������� ����� ��������� ������� ������ 1�
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
	;�������� � DT 
	;MsgBox(0, "Error", GetValue("FileServer",$aArray)) 
	;MsgBox(0, "Error", GetValue("FileServer",$aArray)="Server") 
	if StringLower(GetValue("FileServer",$aArray))="server" Then		
		$StrokaZapuska=GetValue("PathProgramm",$aArray) & " DESIGNER /S " & GetValue("PathServer",$aArray) & "\" & GetValue("PathServerBase",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $TimeStr &".dt" &  " /DumpResult "  & GetValue("PathDump",$aArray) & "Result.txt" 
	Else
		$StrokaZapuska=GetValue("PathProgramm",$aArray) & " DESIGNER /F " & GetValue("PathFile",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $TimeStr &".dt" &  " /DumpResult "  & GetValue("PathDump",$aArray) & "Result.txt" 
		;MsgBox(0, "Error", $StrokaZapuska)
	EndIf
	;MsgBox(0, "Error", $StrokaZapuska)
	WriteLog("�������� � DT ����","logDumpIB.txt",1)
	if Run($StrokaZapuska)=0 Then
		WriteLog("�� ������� ��������� � DT, ��������� ������������ �������� ���������� � ����� config.ini","logDumpIB.txt",1)
;~ 		MsgBox(4096, "", "�� ������� ��������� � DT, ��������� ������������ �������� ���������� � ����� config.ini", 10)
	EndIf
Else
;~ 	MsgBox(4096, "", "� ����� config.ini, ���������/��������� ����������� ���������", 10)
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
				WriteLog("�� ��������� ������ ��� ��, ���������� ������� file/server, � ����� config.ini","logConfig.txt",2)
				return false
			endif
		endif	
		if $Parametr="PathProgramm" or $Parametr="PathDump"	or $Parametr="user"	or $Parametr="BaseName"	Then
			$Value=StringReplace($Value, " ", "")
			if $Value="" Then
				WriteLog("��������� PathProgramm/PathDump/user/BaseName, � ����� config.ini","logConfig.txt",2)
				return false
			endif
		endif				
		if $Parametr="PathFile" or $Parametr="PathServer" then
			if StringLower(GetValue("FileServer",$aArray)) = "file" then
				$Value=StringReplace($Value, " ", "")
				if $Value="" Then
					WriteLog("��������� PathFile/PathServer, � ����� config.ini","logConfig.txt",2)
					return false
				endif			
			endif						
		endif
		if $Parametr="PathServer" or $Parametr="PathServerBase" then
			if StringLower(GetValue("FileServer",$aArray)) = "server" then
				$Value=StringReplace($Value, " ", "")
				if $Value="" Then
					WriteLog("��������� PathServer/PathServerBase, � ����� config.ini","logConfig.txt",2)
					return false
				endif			
			endif						
		endif
		if $Parametr="CloseAll_1c" Then
			$Value=StringLower($Value)
			if  $Value<> "false" and $Value<> "true"then
				WriteLog("����������� �������� CloseAll_1c,���������� ������� true/false, � ����� config.ini","logConfig.txt",2)
				return false				
			endif
		EndIf			
		if $Parametr="SQLService" Then
			$Value=StringLower($Value)
			if  $Value<> "db2" and $Value<> "mssqlserver"then
				WriteLog("����������� �������� SQLService,���������� ������� db2/mssqlserver, � ����� config.ini","logConfig.txt",2)
				return false				
			endif
		EndIf
		if $Parametr="1cAgent" Then
			$Value=StringLower($Value)
			if  $Value<> "1c:enterprise 8.2 server agent" then
				WriteLog("����������� �������� SQLService,���������� ������� 1c:enterprise 8.2 server agent, � ����� config.ini","logConfig.txt",2)
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