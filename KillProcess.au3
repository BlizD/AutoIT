$sProcess = "Cloud.exe"

If ProcessExists($sProcess) Then
   ProcessClose($sProcess)
EndIf
