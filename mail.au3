$SmtpServer = "smtp.bk.ru"            ; ����� SMTP �������
$FromName = "Mail Sender"               ; ��� �����������
$FromAddress = "iab@bk.ru" ; ����� �����������
$ToAddress = "iab@bk.ru"      ; ����� ����������
$Subject = "test_mail_8"              ; ���� ������
$Body = "body_of_mail"            ; ���� ������ (��� ����� ������)
;~ $AttachFiles = "D:\1.txt"; ������������ ����� � ������
$Username = "iab"            ; ��� ������������ ��������, � �������� ������������
$Password = "ghtptyn ajh ."                     ; ������ ��������, � �������� ������������
$Port=25
;~ $BlatArgs = "-t "&$ToAddress&" -f "&$FromAddress&" -s "&$Subject&" -body "&$Body&" -server "&$SmtpServer&" -u "&$Username&" -pw "&$Password&" -attach "&$AttachFiles
$BlatArgs = "-to "&$ToAddress&" -f "&$FromAddress&" -s "&$Subject&" -body "&$Body&" -server "&$SmtpServer &" -port "& $Port & " -u "&$Username&" -pw "&$Password  ;&"-attach "&$AttachFiles
;~ $BlatArgs = "-server " & $SmtpServer & "-f " & $FromAddress & "-u "&$Username&" -pw "&$Password  & "-to" $ToAddress &" -s "& $Subject & " -body " & $Body 
;Run (@scriptdir & "\blat. " & $BlatArgs, @ScriptDir, @SW_HIDE )
_SendMail($BlatArgs)

Func _SendMail($CMDstring)
    $BlatDLL = DllOpen ("blat.dll")
;~     Do
	$result=DllCall($BlatDLL,"int","Send","str",$CMDstring)
	Select
		Case $result[0] = 13
			MsgBox(16,"������. ��� ������ " & $result[0], "�� ���� ������� ��������� ���� �� ��������� �����")

		Case $result[0] = 12
			MsgBox(16, "������. ��� ������ " & $result[0], "�� ������� ��� �� ������� � ������� ��������� -server ��� -f")

		Case $result[0] = 3
			MsgBox(16, "������. ��� ������ " & $result[0], "�� ���� ��������� ���� � ������� ������ ��� ����������� ����")

		Case $result[0] = 2
			MsgBox(16, "������. ��� ������ " & $result[0], "��������� ������� �� ���������� ����� �����������; ��� �� ������� ��� � �����������; ��� �������� ������; ��� �� ������ ���� � ������� ������")
		Case $result[0] = 1
			MsgBox(16, "������. ��� ������ " & $result[0], "�� ���� ������� SMTP �����. ��������� ����������� � ���������; ���� �������� ���������")
		Case $result[0] <> 0
			MsgBox(16, "������. ��� ������ " & $result[0], "����������� ������")
	EndSelect
;~     Until $result[0] = 0
;~     MsgBox(16, "��� ������.", "������ ���������� :-)" & @CRLF)
    DllClose ($BlatDLL)
EndFunc ;