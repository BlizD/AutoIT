#include <GUIConstants.au3>
#include <Misc.au3>
AutoItSetOption("WinTitleMatchMode", 1)
$l2 = WinList("Asterios")
ControlSend ( $l2[1][1], "", 0, "{F1}");
;$l2 = ProcessList("Lineage II.exe")
;MsgBox(0, "Details", $l2[1][0])
;MsgBox(0, "Details", $l2[1][1])
;ControlSend ( $l2[1][1], "", 0, "{F3}");

HotKeySet("^!x","QuitProg")
HotKeySet("^!s","StartProg")
HotKeySet("^!p","StopProg")

;HotKeySet("{F2}","SendF3")

Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 
$mainwindow = GUICreate("Use", 250, 230)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

GUICtrlCreateLabel("Нижний", 10, 10)
$lowlvl = GUICtrlCreateInput("100", 90, 10, 50)
GUICtrlCreateLabel("Верхний", 10, 40)
$uplvl = GUICtrlCreateInput("100", 90, 40, 50)
GUICtrlCreateLabel("Кол-во ", 10, 70)
$kolvo = GUICtrlCreateInput("5555", 90, 70, 50)

$flRecharge=GUICtrlCreateCheckbox("Речардж",150,10)

GUICtrlCreateLabel("Каждые ", 150, 30)
$TimeToRecharge = GUICtrlCreateInput("5000", 150, 50, 50)
GUICtrlCreateLabel("Hotkey ", 150, 80)
$HotKey = GUICtrlCreateInput("{F3}", 150, 100, 50)


GUICtrlCreateLabel("на шаге ", 10, 100)
$posle = GUICtrlCreateInput("125", 90, 100, 50)

GUICtrlCreateLabel("Засыпать на ", 10, 130)
$zasupat = GUICtrlCreateInput("3000", 90, 130, 50)


;$okbutton = GUICtrlCreateButton("OK", 50, 150, 60)
;GUICtrlSetOnEvent($okbutton, "OKButton")
GUICtrlCreateLabel("Ctrl+Alt+x - выход из программы", 5, 160)
GUICtrlCreateLabel("Ctrl+Alt+s - запуск программы", 5, 180)
GUICtrlCreateLabel("Ctrl+Alt+p - остановка программы", 5, 200)


GUISetState(@SW_SHOW)

While 1
  Sleep(1000)  ; Idle around
WEnd
Func QuitProg()
	Exit
EndFunc
Func StopProg()
	GUICtrlSetData($kolvo,"0")
	;$kolvo="0";
EndFunc

Func StartProg()
  ;Note: at this point @GUI_CTRLID would equal $okbutton,
  ;and @GUI_WINHANDLE would equal $mainwindow
  ;MsgBox(0, "GUI Event", "You pressed OK!")
  
	
	;$Qclix = InputBox("Кол-во кликов", "Введите колличество кликов. Используйте цифры только на основной клавиатуре.Отрицательные значения буквы и пробелы недопустимы", "")
	;$MaxKlik=GUICtrlRead($kolvo)
	;GUICtrlRead
	;ControlSend ( $l2[2][1], "", 0, "{F1}");
	$pos = MouseGetPos()
	$tik=1
	if GUICtrlRead($kolvo)=0 then 
		GUICtrlSetData($kolvo,"5555")
	EndIf
	For $i=1 To GUICtrlRead($kolvo)
		If GUICtrlRead($kolvo) = "0" Then ExitLoop
		MouseClick("left", $pos[0], $pos[1])		
		;ControlSend ( $l2[1][1], "", 0, "{F1}");
		$son=Random(GUICtrlRead($lowlvl), GUICtrlRead($uplvl))
		;MsgBox(0, "Кол", $son)
		Sleep ($son)
		If $i=GUICtrlRead($posle) then 			
			Sleep(3000);
			ControlSend ( $l2[1][1], "", 0, "{F1}");
			ControlSend ( $l2[1][1], "", 0, "{F1}");
			ControlSend ( $l2[1][1], "", 0, "{F1}");
			ControlSend ( $l2[1][1], "", 0, "{F1}");			
			ControlSend ( $l2[1][1], "", 0, "{F1}");			
			;Sleep(1000);
			ControlSend ( $l2[1][1], "", 0, "{F1}");			
			Sleep(GUICtrlRead($zasupat))				
			$i=1
		EndIf
		if ($tik =  GUICtrlRead($TimeToRecharge)) and (GUICtrlRead($flRecharge)=1) Then
			;$HotKey="{" & GUICtrlRead($HotKey) & "}"
			ControlSend ( $l2[2][1], "", 0, "{F3}");
			$tik=1;
		endif
		$tik=$tik+1
	Next   	
EndFunc
Func Click()

EndFunc

Func CLOSEClicked()
  ;Note: at this point @GUI_CTRLID would equal $GUI_EVENT_CLOSE, 
  ;and @GUI_WINHANDLE would equal $mainwindow 
  ;MsgBox(0, "GUI Event", "You clicked CLOSE! Exiting...")
  Exit
EndFunc

