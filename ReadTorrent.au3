#Include <file.au3>
Global $Path=@ScriptDir & "\"
$file = FileOpen("C:\√Ћј¬Ќќ≈ Ќ≈ Ѕќя“№—я.avi.torrent", 0)
While 1
	$line = FileReadLine($file)
	$PozName=StringInStr($line,"name")
	$line=StringMid($line,$PozName)
	if $PozName>0 then
		$PozDV=StringInStr($line,":")
		$line=StringMid($line,$PozDV+1)
		$PozDV=StringInStr($line,":")
		$Name=StringLeft($line,$PozDV-3)
;~ 		MsgBox(-1,"",$Name)
		ExitLoop
	EndIf
WEnd
FileClose($file)
;~ MsgBox(-1,"",$Name)
$PozT=StringInStr($Name,".",0,-1)
;~ MsgBox(-1,"",$PozT)
$rashirenie=StringMid($Name,$PozT)
;~ MsgBox(-1,"",$rashirenie)
;~ Exit
$Name=$Name & " - ƒобавить новый торрент"
;~ MsgBox(-1,"",$Name)
$var = ControlGetText($Name, "", "ComboBox1")
ControlSetText($Name, "", "ComboBox1","C:\√Ћј¬Ќќ≈ Ќ≈ Ѕќя“№—я" & $rashirenie)
ControlClick ( $Name, "", "Button7")


 


;~ MsgBox(-1,"",$var)
