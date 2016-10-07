$SmtpServer = "smtp.bk.ru"            ; адрес SMTP сервера
$FromName = "Mail Sender"               ; имя отправителя
$FromAddress = "iab@bk.ru" ; адрес отправителя
$ToAddress = "iab@bk.ru"      ; адрес назначения
$Subject = "test_mail_8"              ; тема письма
$Body = "body_of_mail"            ; тело письма (сам текст письма)
;~ $AttachFiles = "D:\1.txt"; прикреплённые файлы к письму
$Username = "iab"            ; имя пользователя аккаунта, с которого отправляется
$Password = "ghtptyn ajh ."                     ; пароль аккаунта, с которого отправляется
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
			MsgBox(16,"Ошибка. Код ошибки " & $result[0], "Не могу открыть временный файл во временной папке")

		Case $result[0] = 12
			MsgBox(16, "Ошибка. Код ошибки " & $result[0], "Не указаны или не найдены в реестре аргументы -server или -f")

		Case $result[0] = 3
			MsgBox(16, "Ошибка. Код ошибки " & $result[0], "Не могу прочитать файл с текстом письма или приложенный файл")

		Case $result[0] = 2
			MsgBox(16, "Ошибка. Код ошибки " & $result[0], "Почтовому серверу не понравился адрес отправителя; или он отказал нам в подключении; или неверный пароль; или не найден файл с текстом письма")
		Case $result[0] = 1
			MsgBox(16, "Ошибка. Код ошибки " & $result[0], "Не могу открыть SMTP сокет. Проверьте подключение к Интернету; либо неверные аргументы")
		Case $result[0] <> 0
			MsgBox(16, "Ошибка. Код ошибки " & $result[0], "Неизвестная ошибка")
	EndSelect
;~     Until $result[0] = 0
;~     MsgBox(16, "нет ошибки.", "Письмо отправлено :-)" & @CRLF)
    DllClose ($BlatDLL)
EndFunc ;