$sProcess = "uTorrent.exe"

If ProcessExists($sProcess) Then
   ProcessClose($sProcess)
EndIf
