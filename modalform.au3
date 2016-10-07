#include <GUIConstants.au3>
#include <Misc.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
$GUI = GUICreate("Задачи", 450, 290,-1,-1,$WS_EX_TOPMOST)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
;~ Sleep(5000)
GUISetState(@SW_SHOW,$GUI)
While 1
	Sleep(1000)
	if Not WinActive( "Задачи" ) then
		WinActivate ( "Задачи" )
	EndIf
;~ 	WinSetOnTop("Задачи","text",1)
WEnd
func Close()
	exit
EndFunc