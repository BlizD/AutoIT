#Include <Array.au3>
#include <Date.au3>

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
	$ParametrsLoad=True
Else	
	;Создать файл conf.cfg с параметрами по умолчанию
	$file = FileOpen("config.ini", 1)
	FileWriteLine($file, "PathProgramm=" & """c:\Program Files\1cv82\common\1cestart.exe""")
	FileWriteLine($file, "FileServer=Укажите Файловая/серверная база file/server")
	FileWriteLine($file, "PathFile=" & """D:\Ivanov A.B\1c\Docs\Фарит\Продвинутый курс База\""")
	FileWriteLine($file, "PathServer=")
	FileWriteLine($file, "PathServerBase=")
	FileWriteLine($file, "PathDump="& "C:\Temp\")
	FileWriteLine($file, "user=DumpIB")
	FileWriteLine($file, "CloseAll_1c=false")
	FileWriteLine($file, "BaseName=Test")
	FileClose($file)
EndIf    




;MemoWrite("Current system date/time .: " & _Date_Time_SystemTimeToDateTimeStr($tCur))
;_ArrayDisplay($aArray, "$aArray")
;MsgBox(0, "Error", $aArray[0])
;MsgBox(0, "Error", $aArray[1])
;MsgBox(0, "Error", $aArray[2])

if $ParametrsLoad then
	; Завершаем все сеансы 1с
	if StringLower(GetValue("CloseAll_1c",$aArray)) = "true" then
		$list = ProcessList("1cv8.exe")
		for $i = 1 to $list[0][0]	
		  ;msgbox(0, $list[$i][0], $list[$i][1])
		  ProcessClose($list[$i][1])
		next
	endif	
	
	$TimeStr=_Date_Time_GetSystemTime()
	$TimeStr=_Date_Time_SystemTimeToDateTimeStr($TimeStr)
	$TimeStr = StringReplace($TimeStr, "/", "")
	$poz=StringInStr($TimeStr, " ")
	$TimeStr =StringLeft($TimeStr, $poz-1)
	$TimeStr=GetValue("BaseName",$aArray) & "_" & $TimeStr; 	
	;Выгрузка в DT 
	;$StrokaZapuska="""C:\Program Files\1cv82\8.2.12.92\bin\1cv8.exe""" & " DESIGNER /F " & """D:\Ivanov A.B\1c\Docs\Фарит\Продвинутый курс База""" & " /N Администратор /Out " & """C:\Temp\log.txt""" & " /DumpIB " & """C:\Temp\Test1.dt"""  &  " /DumpResult "  & """C:\Temp\Result.txt"""
	;MsgBox(0, "Error", GetValue("FileServer",$aArray)) 
	;MsgBox(0, "Error", GetValue("FileServer",$aArray)="Server") 
	if GetValue("FileServer",$aArray)="server" Then
		;$StrokaZapuska=$aArray["PathProgramm"] & " DESIGNER /S " & """D:\Ivanov A.B\1c\Docs\Фарит\Продвинутый курс База""" & " /N Администратор /Out " & """C:\Temp\log.txt""" & "/DumpIB" & """C:\Temp\Test.dt"""  &  " /DumpResult"  & """C:\Temp\Result.txt"""
		$StrokaZapuska=GetValue("PathProgramm",$aArray) & " DESIGNER /S " & GetValue("PathServer",$aArray) & "\" & GetValue("PathServerBase",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $TimeStr &".dt" &  " /DumpResult "  & GetValue("PathDump",$aArray) & "Result.txt" 
	Else
		$StrokaZapuska=GetValue("PathProgramm",$aArray) & " DESIGNER /F " & GetValue("PathFile",$aArray) & " /N " & GetValue("user",$aArray) & " /P "& $PSD &" /Out "  & GetValue("PathDump",$aArray) & "log.txt"  & " /DumpIB " & GetValue("PathDump",$aArray) & $TimeStr &".dt" &  " /DumpResult "  & GetValue("PathDump",$aArray) & "Result.txt" 
		;MsgBox(0, "Error", $StrokaZapuska)
	EndIf
	if Run($StrokaZapuska)=0 Then
		MsgBox(4096, "", "Не удалось выгрузить в DT, проверьте правильность значения параметров в файле config.ini", 10)
	EndIf
Else
	MsgBox(4096, "", "В файле config.ini, заполните необходимые параметры", 10)
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
	