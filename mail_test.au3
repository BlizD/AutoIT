Opt('TrayIconDebug', 1)
GUICreate('CheckMail', 300, 200)
$status = GUICtrlCreateEdit('Initiating...', 5, 5, 290, 190)
GUISetState()

TCPStartup()

$ip = TCPNameToIP('mail.razdolie.ru')
;~ $user = InputBox('Username', 'Username (don''t forget @domain):', '', '', 200, 150)
;~ $pass = InputBox('Password', 'Password for ' & $user & ':', '', '*', 200, 150)
$user = 'a.ivanov'
$pass = 'RFJ168TUs08hd'

$socket = TCPConnect($ip, 110)
If $socket = -1 Then
    GUICtrlSetData($status, 'Error: Bad connection' & @CRLF)
Else
    $step = 'login'
    Do
        $recv = TCPRecv($socket, 512)
        If @error Then
            GUICtrlSetData($status, 'Notice: Disconnected!' & @CRLF, 1)
            $socket = -1
        ElseIf StringInStr($recv, '+OK') = 1 Then
            GUICtrlSetData($status, $recv & @CRLF, 1)
            Switch $step
                Case 'login'
                    GUICtrlSetData($status, 'Login: Username...' & @CRLF, 1)
                    _TCPSend($socket, 'user ' & $user & @CRLF)
                    $step = 'pass'
                Case 'pass'
                    GUICtrlSetData($status, 'Login: Password...' & @CRLF, 1)
                    _TCPSend($socket, 'pass ' & $pass & @CRLF)
                    $step = 'stat'
                Case 'stat'
                    GUICtrlSetData($status, 'Logged In: Check for mail...' & @CRLF, 1)
                    _TCPSend($socket, 'stat' & @CRLF)
                    $step = 'check'
                Case 'check'
                    $match = StringRegExp($recv, '\+OK ([0-9]+)', 2)
                    If Not @error Then
                        GUICtrlSetData($status, 'Success: There are ' & $match[1] & ' email(s) in the inbox' & @CRLF, 1)
                        If $match[1] > 0 Then
                            _TCPSend($socket, 'retr 1' & @CRLF)
                            $step = 'read'
                        Else
                            GUICtrlSetData($status, 'Disconnecting', 1)
                            TCPCloseSocket($socket)
                            $socket = -1
                        EndIf
                    Else
                        GUICtrlSetData($status, 'Error: Improper format:' & $recv & @CRLF, 1)
                        GUICtrlSetData($status, 'Disconnecting', 1)
                        TCPCloseSocket($socket)
                        $socket = -1
                    EndIf
                Case 'read'
                    $recv = TCPRecv($socket, 1000000)
                    GUICtrlSetData($status, 'Email #1 content:' & @CRLF & '----------' & @CRLF & $recv & @CRLF & '----------' & @CRLF, 1)
                    GUICtrlSetData($status, 'Disconnecting', 1)
                    TCPCloseSocket($socket)
                    $socket = -1
            EndSwitch
        ElseIf StringInStr($recv, '-ERR') = 1 Then
            GUICtrlSetData($status, 'Error: ' & $recv & @CRLF, 1)
            GUICtrlSetData($status, 'Disconnecting', 1)
            TCPCloseSocket($socket)
            $socket = -1
        EndIf
    Until $socket = -1
EndIf

Do
Until GUIGetMsg() = -3

Func _TCPSend($socket, $data)
    TCPSend($socket, $data)
    GUICtrlSetData($status, '> ' & $data, 1)
EndFunc