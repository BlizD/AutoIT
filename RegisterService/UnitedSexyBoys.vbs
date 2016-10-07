On Error Resume Next
Set objShell = CreateObject("WScript.Shell")
'objShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Cdrom\AutoRun", "0", "REG_DWORD" 
'objShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer\NoDriveTypeAutoR un", "255", "REG_DWORD" 
'objShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping\Autorun.inf\", "@SYS:DoesNotExist" 
'objShell.RegWrite "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\CancelAutopl ay\Files\*.*", ""
'читаем разрешенные id
Set fso = CreateObject("Scripting.FileSystemObject")
Set tsLog = fso.OpenTextFile(".\AllowUnitedSexyBoys.txt", 1)'ForReading
Stroka = tsLog.ReadLine
'Do While Not tsLog.AtEndOfStream
'' allow_array=split(tsLog.ReadLine,";")
 'LineInFile = tsLog.ReadLine 
'Loop
'***************************************************************
' Функция записи в log файл
Function FileLog(text)
   Dim fso, f
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set f = fso.OpenTextFile(".\usb.log", 8, True)
   f.WriteBlankLines(1)
   f.Write Now&" - "&text&""
   f.Close
End Function
'***************************************************************
Set FSO = CreateObject("Scripting.FileSystemObject")
colDrives = Split("D E F G H I J K L M N O P Q R S T U V W X Y Z")
Set dictDrives = CreateObject("Scripting.Dictionary")
For Each Drive In colDrives
    Set Drv = FSO.GetDrive(Drive & ":")
    If Err.Number Then
        dictDrives.Add Drive & ":", False
    Else
        If Drv.DriveType = 1 And Drv.IsReady Then
            dictDrives.Add Drive & ":", True
            'WScript.Echo "Диск " & Drive & "." 
            'WScript.Echo "D:/usb/DevEject.exe -EjectDrive:"& Drive &"" 
            If InStr(Stroka, Drv.SerialNumber & ";") Then
            'If Drv.SerialNumber="2020035596" Then
                FileLog ("Диск " & Drive & " (разрешенный) был подключён (VolumeName = "& Drv.VolumeName &"; TotalSize = "& Drv.TotalSize &"; FreeSpace = "& Drv.FreeSpace &"; FileSystem = "& Drv.FileSystem &"; SerialNumber = "& Drv.SerialNumber &").")
                Else             
            FileLog ("Диск " & Drive & " был подключён (VolumeName = "& Drv.VolumeName &"; TotalSize = "& Drv.TotalSize &"; FreeSpace = "& Drv.FreeSpace &"; FileSystem = "& Drv.FileSystem &"; SerialNumber = "& Drv.SerialNumber &").")
            Set objShell = CreateObject("WScript.Shell")
            'Set objScriptExec = objShell.Exec("D:/usb/DevEject.exe -EjectDrive:"& Drive &":")
			'Set objScriptExec = objShell.Run("E:/DevEject.exe -EjectDrive:"& Drive &":",0)  
			WScript.Sleep 1000
			Set objScriptExec = objShell.Run(".\usr.exe stop -d "& Drive &"",0)
            End If      
        Else
            dictDrives.Add Drive & ":", False
        End If
    End If
    Err.Clear
Next
' Бесконечный цикл
While True
    For Each Drive In dictDrives.Keys
        Set Drv = FSO.GetDrive(Drive)
        'WScript.Echo "Диск " & Drive & "."
       
        If (Err.Number) Or (Drv.IsReady = False) Or (Drv.DriveType <> 1) Then 'And Drv.DriveType <> 4
            Flag = False
        Else
            Flag = True
        End If
        Err.Clear
        Current = dictDrives.Item(Drive)
        If Current <> Flag Then
            If Current = False And Flag = True Then
                If InStr(Stroka, Drv.SerialNumber & ";") Then
                'If Drv.SerialNumber="2020035596" Then
                FileLog ("Диск " & Drive & " (разрешенный) был подключён (VolumeName = "& Drv.VolumeName &"; TotalSize = "& Drv.TotalSize &"; FreeSpace = "& Drv.FreeSpace &"; FileSystem = "& Drv.FileSystem &"; SerialNumber = "& Drv.SerialNumber &").")
                Else 
                FileLog ("Диск " & Drive & " был подключён (VolumeName = "& Drv.VolumeName &"; TotalSize = "& Drv.TotalSize &"; FreeSpace = "& Drv.FreeSpace &"; FileSystem = "& Drv.FileSystem &"; SerialNumber = "& Drv.SerialNumber &").")
                Set objShell = CreateObject("WScript.Shell")
                'Set objScriptExec = objShell.Exec("D:/usb/DevEject.exe -EjectDrive:"& Drive &"")
                'FileLog ("E:/DevEject.exe -EjectDrive:"& Drive &"")
				'Set objScriptExec = objShell.Run("E:/DevEject.exe -EjectDrive:"& Drive &"",0)
				Set objScriptExec = objShell.Run(".\usr.exe stop -d "& Drive &"",0)
                WScript.Sleep 1000
				End If
            Else
                FileLog ("Диск " & Drive & " был отключён.")
            End If
            dictDrives.Item(Drive) = Flag
        End If
    Next
    WScript.Sleep 100
Wend