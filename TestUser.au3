Global $Bufer
For $s = 0 To 100
$DllFunc = DllCall("Wtsapi32.dll", "Bool","WTSQuerySessionInformation","Dword",0 ,"Dword",$s,"Dword",5, "str*", $Bufer, "Dword*",1024)
;~ $DllFunc = DllCall("Wtsapi32.dll", "Bool","WTSQueryUserConfig","Dword",0 ,"Dword",$s,"Dword",5, "str*", $Bufer, "Dword*",1024)

	For $i = 0 To UBound($DllFunc) - 1
		If StringIsAlpha ( $DllFunc[$i] )  Then
		;~   ConsoleWrite($DllFunc[$i] & @CRLF)
			MsgBox(-1,"",$DllFunc[$i] & @CRLF)
		EndIf
	Next

Next