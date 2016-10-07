#NoTrayIcon
#include <GUIConstantsEx.au3>

;

Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)

$hGUI = GUICreate("Пример в трей", 300, 200)

$RestoreItem = TrayCreateItem("Восстановить.")
TrayItemSetOnEvent(-1, "_RestoreFromTray_Proc")

TraySetOnEvent(-13, "_RestoreFromTray_Proc")
TraySetClick(1)

GUISetState()

While 1
    Switch GUIGetMsg()
        Case -3
            ExitLoop
        Case -4
            GUISetState(@SW_HIDE)
            TraySetState(1)
    EndSwitch
WEnd

Func _RestoreFromTray_Proc()
    If BitAND(WinGetState($hGUI), 2) = 2 Then Return
    TraySetState(2)
    GUISetState(@SW_SHOW)
    GUISetState(@SW_RESTORE)
EndFunc