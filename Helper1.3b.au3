#include <Misc.au3>
AutoItSetOption("WinTitleMatchMode", 1)
$l2 = WinList("Lineage II")
Dim $a
HotKeySet("{NUMPADADD}", "macronum")
HotKeySet("{NUMPADSUB}", "macroRenum")
HotKeySet("{NUMPAD1}", "macro1")
HotKeySet("{NUMPAD2}", "macro2")
HotKeySet("{NUMPAD3}", "macro3")
HotKeySet("{NUMPAD4}", "macro4")
HotKeySet("{NUMPAD5}", "macro5")
HotKeySet("{NUMPAD6}", "macro6")
HotKeySet("{NUMPAD7}", "macro7")
HotKeySet("{NUMPAD8}", "macro8")
HotKeySet("{NUMPAD9}", "macro9")
HotKeySet("{NUMPAD0}", "macro10")
HotKeySet("{NUMPADDIV}", "macro11")
HotKeySet("#{NUMPAD1}", "macro13")
HotKeySet("#{NUMPAD2}", "macro14")
HotKeySet("#{NUMPAD3}", "macro15")
HotKeySet("#{NUMPAD4}", "macro16")
HotKeySet("#{NUMPAD5}", "macro17")
HotKeySet("#{NUMPAD6}", "macro18")
HotKeySet("#{NUMPAD7}", "macro19")
HotKeySet("#{NUMPAD8}", "macro20")
HotKeySet("#{NUMPAD9}", "macro21")
HotKeySet("#{NUMPAD0}", "macro22")
HotKeySet("^!z", "macro23")
HotKeySet("^!x","QuitProg")
Func QuitProg()
Exit
EndFunc
Func macronum()
For $i = 1 to $l2[0][0]
WinSetTitle($l2[$i][1], "", "Lineage II#" & $i)
Next
EndFunc
Func macroRenum()
For $i = 1 to $l2[0][0]
WinSetTitle($l2[$i][1], "", "Lineage II")
Next
EndFunc
while 1
  sleep(100)
Wend
Func macro1()
    ControlSend ( $l2[2][1], "", 0, "{F1}");
EndFunc
Func macro2()
    ControlSend ( $l2[2][1], "", 0, "{F2}");
EndFunc
Func macro3()
    ControlSend ( $l2[2][1], "", 0, "{F3}");
EndFunc
Func macro4()
    ControlSend ( $l2[2][1], "", 0, "{F4}");
EndFunc
Func macro5()
    ControlSend ( $l2[2][1], "", 0, "{F5}");
EndFunc
Func macro6()
    ControlSend ( $l2[2][1], "", 0, "{F6}");
EndFunc
Func macro7()
    ControlSend ( $l2[2][1], "", 0, "{F7}");
EndFunc
Func macro8()
    ControlSend ( $l2[2][1], "", 0, "{F8}");
EndFunc
Func macro9()
    ControlSend ( $l2[2][1], "", 0, "{F9}");
EndFunc
Func macro10()
    ControlSend ( $l2[2][1], "", 0, "{F10}");
EndFunc

Func macro11()
$dll = DllOpen("user32.dll")
$ans = InputBox("Таймер для СВС/БД", "Введите время в секундах. Используйте цифры только на основной клавиатуре.Отрицательные значения буквы и пробелы недопустимы", "")
While 1
sleep(10)
If $ans <= 0 Or(_IsPressed("6A", $dll)) Then ExitLoop
ControlSend ( $l2[2][1], "", 0, "{F11}");
ControlSend ( $l2[3][1], "", 0, "{F11}")
Sleep ($ans*1000)
WEnd 
EndFunc
Func Key()
$dll = DllOpen("user32.dll")
While 1
    Sleep ( 250 )
    If _IsPressed("6E", $dll) Then
        MsgBox(0,"_IsPressed", "Multiply Key Pressed")
        ExitLoop
    EndIf
WEnd
DllClose($dll)
EndFunc
Func macro13()
    ControlSend ( $l2[3][1], "", 0, "{F1}");
EndFunc
Func macro14()
    ControlSend ( $l2[3][1], "", 0, "{F2}");
EndFunc
Func macro15()
    ControlSend ( $l2[3][1], "", 0, "{F3}");
EndFunc
Func macro16()
    ControlSend ( $l2[3][1], "", 0, "{F4}");
EndFunc
Func macro17()
    ControlSend ( $l2[3][1], "", 0, "{F5}");
EndFunc
Func macro18()
    ControlSend ( $l2[3][1], "", 0, "{F6}");
EndFunc
Func macro19()
    ControlSend ( $l2[3][1], "", 0, "{F7}");
EndFunc
Func macro20()
    ControlSend ( $l2[3][1], "", 0, "{F8}");
EndFunc
Func macro21()
    ControlSend ( $l2[3][1], "", 0, "{F9}");
EndFunc
Func macro22()
    ControlSend ( $l2[3][1], "", 0, "{F10}");
EndFunc

Func macro23()
$gno = InputBox("Таймер для крафта", "Введите промежуток в минутах через который будет повторяться крафт. Используйте цифры только на основной клавиатуре.Отрицательные значения буквы и пробелы недопустимы", "")
While 1
sleep(10)
If $gno = "0" Then ExitLoop
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep (400)
MouseClick("left")
Sleep ($gno*60000)
WEnd 
EndFunc