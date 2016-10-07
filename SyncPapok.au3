#Include <File.au3>
#Include <Array.au3>
;~ $PathInitial="E:\DWND\backup\7z\"
;~ $PathSync="E:\DWND\backup\7z2\"
$PathInitial="D:\mssql2008_backup\UPP82\"
$PathSync="\\A06-fs\bkp_1s\Current\"

$FileList_Initial=FileListToArray($PathInitial)
$FileList_Sync=FileListToArray($PathSync)
;~ MsgBox (0,"",$FileList_Initial[0])

$SizeArray=0
$SizeArray=	$FileList_Initial[0]+$FileList_Sync[0]
;~ MsgBox (0,"",$SizeArray)

Dim $Workarray[$SizeArray][6]
$IdInitial=0
While $IdInitial<=$FileList_Initial[0]-1
	$Workarray[$IdInitial][0]=$FileList_Initial[$IdInitial+1]
	$IdSync=0
	While $IdSync<=$FileList_Sync[0]-1
		if $Workarray[$IdInitial][0] = $FileList_Sync[$IdSync+1] Then
			$Workarray[$IdInitial][1]=$FileList_Sync[$IdSync+1]
			$FileList_Sync[$IdSync+1]=""
		EndIf
		$IdSync=$IdSync+1
	WEnd
	$IdInitial=$IdInitial+1
WEnd
;~ MsgBox (0,"",$IdInitial)
$IdSync=0
While $IdSync<=$FileList_Sync[0]-1
	if $FileList_Sync[$IdSync+1]<>"" Then
		$Workarray[$IdInitial][1]=$FileList_Sync[$IdSync+1]
		$IdInitial=$IdInitial+1
	EndIf
	$IdSync=$IdSync+1
WEnd

$Id=0
While $Id<=$SizeArray-1
	if $Workarray[$Id][0]="" then
		$Workarray[$Id][2] = False
		if $Workarray[$Id][1]<>"" then
			$Workarray[$Id][3] = True
		Else
			$Workarray[$Id][3] = False
		EndIf
	Else
		if $Workarray[$Id][0]=$Workarray[$Id][1] then
			$Workarray[$Id][2] = Not CheckFiles($PathInitial & $Workarray[$Id][0],$PathSync & $Workarray[$Id][0])
			$Workarray[$Id][3] = False
		Else
			$Workarray[$Id][2] = True
			$Workarray[$Id][3] = False
		EndIf
	EndIf
	$Id=$Id+1
WEnd

;~ _ArrayDisplay($Workarray,"$FileList")

$Id=0
While $Id<=$SizeArray-1
	if $Workarray[$Id][2]=true then
		FileCopy($PathInitial & $Workarray[$Id][0], $PathSync & $Workarray[$Id][0], 1)
	EndIf
	$Id=$Id+1
WEnd
$Id=0
While $Id<=$SizeArray-1
	if $Workarray[$Id][3]=True then
;~ 		MsgBox (0,"",$PathSync & $Workarray[$Id][1])
 		FileDelete($PathSync & $Workarray[$Id][1])
	EndIf
	$Id=$Id+1
WEnd




;~ WriteLog("Параметры выгрузки не загружены.","logDumpIB.txt",1)


Func CheckFiles($File_Initial,$File_Sync)
	$Size_Initial = FileGetSize($File_Initial)
	$Size_Sync = FileGetSize($File_Sync)
	if $Size_Initial=$Size_Sync Then
		$t =  FileGetTime($File_Initial)
		If Not @error Then
			$DateTime_Initial = $t[0] & "/" & $t[1] & "/" & $t[2]
		EndIf
		$t =  FileGetTime($File_Sync)
		If Not @error Then
			$DateTime_Sync = $t[0] & "/" & $t[1] & "/" & $t[2]
		EndIf
		if $DateTime_Initial=$DateTime_Sync Then
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf
EndFunc

Func FileListToArray($PathFolder)
	$FileList=_FileListToArray($PathFolder)
	If @Error=1 Then
		MsgBox (0,"","No Folders Found.")
		Exit
	EndIf
	If @Error=4 Then
;~ 		MsgBox (0,"","No Files Found.")
		Dim $Workarray[1]
		$Workarray[0]=0
		Return $Workarray
	EndIf
	Return $FileList
EndFunc
;~ Func WriteLog($Text,$NameLog,$Mode)
;~ 	$Time=_Date_Time_GetLocalTime()
;~ 	$Time=_Date_Time_SystemTimeToDateTimeStr($Time)
;~ 	$logfile = FileOpen($Path & $NameLog, $Mode)
;~ 	FileWriteLine($logfile,$Time & "-" & $Text)
;~ 	FileClose($logfile)
;~ EndFunc