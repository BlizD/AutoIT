#include <Array.au3>
#include <File.au3>

;#Include <usb_prot\Crypt.au3>
;#Include <usb_prot\WindowsConstants.au3>
#Include <usb_prot\UDFs\WinAPIEx.au3>
; читаем из файла данные о системных дисках
Local $system_disk[10] 
_FileReadToArray("system_disk.txt", $system_disk)
;_ArrayDisplay($system_disk)
;MsgBox(0, "Error", $system_disk[0]) ; 0-й элемент массива будет количество строк в файле

; читаем из файла разрешенные id
Local $allow_id[100] 
_FileReadToArray("AllowUnitedSexyBoys.txt", $allow_id)
;_ArrayDisplay($allow_id)


; функция записи строки в лог файл
Func FileLog($text)
	$file = FileOpen("usb.log", 1)
    If $file = -1 Then
	    MsgBox(0, "Error", "Unable to open file.")
	Exit
	EndIf
	FileWriteLine($file, $text)
    FileClose($file)
EndFunc
;FileLog("12345")
 
Global $diiiski[1]

Func Cikl()
	;_ArrayDisplay($diiiski)
	$var = DriveGetDrive( "all" )
If NOT @error Then
	;MsgBox(4096,"", "Found " & $var[0] & " drives")
	For $i = 1 to $var[0]
		;MsgBox(4096,"Drive " & $i, $var[$i] & DriveGetSerial($var[$i]))
		If DriveGetType( $var[$i] ) = "Removable" Then
			;MsgBox(4096,"Drive " & $i, "Removable")
			$poisk_id = DriveGetSerial($var[$i]) & ";"
			If _ArraySearch($allow_id, $poisk_id) = -1 Then
				FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  USB-накопитель " & $var[$i] & " был подключён (VolumeName = "& DriveGetLabel($var[$i] & "\") &"; TotalSize = "& Round(DriveSpaceTotal($var[$i] & "\")/1024, 2) & "Gb; FreeSpace = "& Round(DriveSpaceFree($var[$i] & "\")/1024, 2) & "Gb; FileSystem = "& DriveGetFileSystem($var[$i] & "\") &"; SerialNumber = "& DriveGetSerial($var[$i] & "\") &").")
				$a = _WinAPI_CreateFileEx('\\.\'& $var[$i], 3, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE))
		        _WinAPI_DeviceIoControl($a, $FSCTL_LOCK_VOLUME)
				$a=0
				RunWait (".\usr.exe stop -d " & $var[$i], @WindowsDir, @SW_HIDE)
				;Sleep(3000)
				FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  USB-накопитель " & $var[$i] & " был отключён")
			Else	
          		If _ArraySearch($diiiski, $var[$i]) = -1 Then ; & DriveGetSerial($var[$i])
				    FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  USB-накопитель " & $var[$i] & " (разрешенный) был подключён (VolumeName = "& DriveGetLabel($var[$i] & "\") &"; TotalSize = "& Round(DriveSpaceTotal($var[$i] & "\")/1024, 2) & "Gb; FreeSpace = "& Round(DriveSpaceFree($var[$i] & "\")/1024, 2) & "Gb; FileSystem = "& DriveGetFileSystem($var[$i] & "\") &"; SerialNumber = "& DriveGetSerial($var[$i] & "\") &").")
				    _ArrayAdd ($diiiski, $var[$i]);& DriveGetSerial($var[$i])
					$diiiski[0] = $diiiski[0] + 1
				EndIf
			EndIf				
		EndIf
		If DriveGetType( $var[$i] ) = "Fixed" Then
			;MsgBox(4096,"Drive " & $i, _ArraySearch($system_disk, $var[$i] & DriveGetSerial($var[$i])))
			$poisk = $var[$i] & DriveGetSerial($var[$i])
			;MsgBox(4096,"Drive " & $i, $poisk)
			If _ArraySearch($system_disk, $poisk) = -1 Then
			    $poisk_id = DriveGetSerial($var[$i]) & ";"
			    If _ArraySearch($allow_id, $poisk_id) = -1 Then
				    ;Run(".\usr.exe stop -d " & $var[$i] )
				    FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  Винчестер " & $var[$i] & " был подключён (VolumeName = "& DriveGetLabel($var[$i] & "\") &"; TotalSize = "& Round(DriveSpaceTotal($var[$i] & "\")/1024, 2) & "Gb; FreeSpace = "& Round(DriveSpaceFree($var[$i] & "\")/1024, 2) & "Gb; FileSystem = "& DriveGetFileSystem($var[$i] & "\") &"; SerialNumber = "& DriveGetSerial($var[$i] & "\") &").")
				    $a = _WinAPI_CreateFileEx('\\.\'& $var[$i], 3, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE))
		           _WinAPI_DeviceIoControl($a, $FSCTL_LOCK_VOLUME)
				    $a=0
					RunWait (".\usr.exe stop -d " & $var[$i], @WindowsDir, @SW_HIDE)
				    ;Sleep(3000)
					FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  Винчестер " & $var[$i] & " был отключён")
				    ;MsgBox(4096,"Drive " & $i, ".\usr.exe stop -d " & $var[$i])			
				Else	
          		    If _ArraySearch($diiiski, $var[$i]) = -1 Then ; & DriveGetSerial($var[$i])
				        FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  Винчестер " & $var[$i] & " (разрешенный) был подключён (VolumeName = "& DriveGetLabel($var[$i] & "\") &"; TotalSize = "& Round(DriveSpaceTotal($var[$i] & "\")/1024, 2) & "Gb; FreeSpace = "& Round(DriveSpaceFree($var[$i] & "\")/1024, 2) & "Gb; FileSystem = "& DriveGetFileSystem($var[$i] & "\") &"; SerialNumber = "& DriveGetSerial($var[$i] & "\") &").")
				        _ArrayAdd ($diiiski, $var[$i]) ; & DriveGetSerial($var[$i])
						$diiiski[0] = $diiiski[0] + 1
				    EndIf
			    EndIf				
			EndIf	
		EndIf		
	Next
EndIf
;_ArrayDisplay($var)
;_ArrayDisplay($diiiski)

For $q = 1 to $diiiski[0] ;_ArrayMaxIndex($diiiski)
	;MsgBox(4096,"q " & $q, _ArrayMax($diiiski)) ;
	;_ArrayDisplay($var)
	If _ArraySearch($var, $diiiski[$q])= -1 Then
		FileLog (@YEAR & "-" & @MON & "-" & @MDAY  & " " &  @HOUR & ":" & @MIN &  "  Съемный диск  " & $diiiski[$q] & " был отключён")
		_ArrayDelete($diiiski,$q)
		$diiiski[0] = $diiiski[0] - 1
	EndIf
Next
EndFunc 

    While 1
        Cikl()
        Sleep (1000)
    WEnd 
	

