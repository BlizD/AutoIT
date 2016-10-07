#Include <Array.au3>
#include <Date.au3>
;~ #include <ServiceControl.au3>
#Include <file.au3>
#include <GUIConstants.au3>
#include <FTPEx.au3>
#include <WinNet.au3>

Global $Path=@ScriptDir & "\"
Global $ArraySizeParametrs=0

$FirstStart=false
If not FileExists($Path & "config.ini") Then
	;Создать файл config.ini с параметрами по умолчанию
;~ 	"C:\Program Files (x86)\1cv82\common\1cestart.exe" enterprise /S a10-s1c\reg063 /RunModeOrdinaryApplication
	$file = FileOpen($Path & "config.ini", 1)
;~ 	FileWriteLine($file, "PathProgramm=c:\Program Files (x86)\1cv82\common\1cestart.exe")
	FileWriteLine($file, "ServerRef=ИмяСервера\ИмяБазы")	
	FileWriteLine($file, "User=DumpIB")
	FileWriteLine($file, "Pasw=123")
	FileWriteLine($file, "NameEpf=OnStart.epf")
	FileClose($file)
	$FirstStart=true
EndIf
If $FirstStart Then
	Exit
EndIf

;Считываем параметры из файла
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
	$ArraySizeParametrs=$ArraySizeParametrs+1
Wend
FileClose($file)

;~ _ArrayDisplay($aArray)
;~ ConsoleWrite(GetValue("PathProgramm",$aArray))
$PathProgramm="c:\Program Files\1cv82\common\1cestart.exe"
If not FileExists($PathProgramm) Then
	$PathProgramm="C:\Program Files (x86)\1cv82\common\1cestart.exe"
	If not FileExists($PathProgramm) Then
;~ 		WriteLog("Не удалось запустить 1с, не удалось получить путь до 1cestart.exe" & $BaseName ,"logStart.txt",1)
;~ 		SendMail($CurrentUser & " Не удалось запустить 1с, не удалось получить путь до 1cestart.exe" & $ServerBase & "  " & $BaseName & "  см. подробности в log файле ","BlizzardAnton@mail.ru")
		Exit
	EndIf
EndIf

$StrokaZapuska=chr(34) & $PathProgramm & chr(34) & " ENTERPRISE /S "& GetValue("ServerRef",$aArray) &" /N "& GetValue("User",$aArray) &" /P "& GetValue("Pasw",$aArray) &" /RunModeOrdinaryApplication /Execute "& GetValue("NameEpf",$aArray) & chr(34)
ConsoleWrite($StrokaZapuska)

if Run($StrokaZapuska)=0 Then
;~ 	SendMail("Не удалось восстановить последовательность","BlizzardAnton@mail.ru")
	ConsoleWrite($StrokaZapuska)
	Exit
EndIf	


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
;~ 	ConsoleWrite("1")
	For $iIndex = 0 to $ArraySizeParametrs-1
;~ 		ConsoleWrite("1")
		if $aArray[$iIndex][0] = $Parametr Then
;~ 			ConsoleWrite("2")
			Return $aArray[$iIndex][1]
		EndIf
	Next
EndFunc