#include <Date.au3>
#Include <Array.au3>
#Include <file.au3>
; Add 5 days to today

;~ $sNewDate = _DateAdd( 'd',5, _NowCalcDate())

;~ $TimeStr =  _NowDate()
;~ $sNewDate = _DateAdd( 'd',1,_NowCalcDate())
;~ $sNewDate = StringReplace($TimeStr, ".", "")
;~ MsgBox( 4096, "", $sNewDate)	
;~ $t=FileGetTime("C:\Temp\log.txt", 1)

;~ If Not @error Then
;~     $yyyymd = $t[0] & "/" & $t[1] & "/" & $t[2]
;~     MsgBox(0, "Creation date of notepad.exe", $yyyymd)
;~ EndIf

;~ Exit

$DateStart=_DateAdd( 'd',-36,_NowCalcDate())
For $i =1 to 36 
	$Testfile = FileOpen("C:\Temp\PlanB_" & StringReplace($DateStart, "/", "") & ".001", 1)
	FileClose($Testfile)	
	$var = FileSetTime("C:\Temp\PlanB_" & StringReplace($DateStart, "/", "") & ".001", StringReplace($DateStart, "/", "") ,1)	
	$DateStart=_DateAdd( 'd',1,$DateStart)
Next
Exit
;~ $var = FileSetTime("file.au3", "20031101",1)
$SizeDT=GetCountFilesDT("C:\Temp\samara*.dt")
Dim $arrayDT[$SizeDT][3]

$search = FileFindFirstFile("C:\Temp\samara*.dt")  
If $search = -1 Then
;~     MsgBox(0, "Error", "No files/directories matched the search pattern")
    Exit
EndIf
$NS=0;
While 1
    $file = FileFindNextFile($search) 
    If @error Then ExitLoop    
;~ *  	MsgBox(4096, "File:", $file)    	
	$t=FileGetTime("C:\Temp\" & $file, 1)
	If Not @error Then
		$yyyymd = $t[0] & "/" & $t[1] & "/" & $t[2]
;~ 		MsgBox(0, "Creation date of notepad.exe", $yyyymd)
	EndIf
	$arrayDT[$NS][0]=$yyyymd
	$arrayDT[$NS][1]="C:\Temp\" & $file
;~ 	MsgBox(0,"",$yyyymd)
;~ 	MsgBox(0,"",_DateToDayOfWeek ($t[0] , $t[1], $t[2]))
;~ 	Exit
	if _DateToDayOfWeek ($t[0] , $t[1], $t[2]) =1 then 
		$arrayDT[$NS][2]=True
	Else
		$arrayDT[$NS][2]=false
	EndIf
	$NS=$NS+1
WEnd
;~ Exit
; Close the search handle
FileClose($search)
_ArraySort($arrayDT, 1 ,  0, 0, 0)
;~ _ArrayDisplay($arrayDT, "$avArray as a list classes in window")
;~ Exit
$MaxKolvoVoskr=4
$NVoskr=0
$SevenDayEarly=_DateAdd( 'd',-7,_NowCalcDate())
For $i = 0 to $SizeDT -1
;~ 	MsgBox(0,"",$arrayDT[$i][0])
;~ 	MsgBox(0,"",$SevenDayEarly)
;~ 	Exit
	$FileDelete=False
	if $SevenDayEarly > $arrayDT[$i][0] Then		
		if $arrayDT[$i][2] Then			
			$NVoskr=$NVoskr+1
;~ 			MsgBox(0,"",$NVoskr & "-" & $arrayDT[$i][1])			
			If $NVoskr>4 Then
				$FileDelete=True
			EndIf	
		Else
			$FileDelete=True
		EndIf
	EndIf
	if $FileDelete Then
		FileDelete($arrayDT[$i][1])
	EndIf
Next

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
