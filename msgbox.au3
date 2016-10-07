#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <FontConstants.au3>

;~ Sleep(3000)
Do
   Sleep(100)
   _DrawText('Х', 20, 'Verdana', 0x0000FF, 3)
Until False
;===================================================
; Параметры:    $Text   - Текст.
;               $Size   - Размер текста.
;               $Font   - Шрифт текста.
;               $Color  - Цвет текста.
;               $Time   - Время отображения текста.
;===================================================
Func _DrawText($Text, $Size, $Font, $Color, $Time)
	$DeskHight = @DesktopHeight
    $tRECT = DllStructCreate($tagRect)
    DllStructSetData($tRECT, "Left", 0)
    DllStructSetData($tRECT, "Top", ($DeskHight / 2) - ($Size / 2))
    DllStructSetData($tRECT, "Right", @DesktopWidth)
    DllStructSetData($tRECT, "Bottom", $DeskHight)

    $hDC = _WinAPI_GetDC(0)
    $hFont = _WinAPI_CreateFont($Size, 0, 0, 0, 800, False, False, False, $DEFAULT_CHARSET, _
            $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, $Font)
    $hOldFont = _WinAPI_SelectObject($hDC, $hFont)

    _WinAPI_SetTextColor($hDC, $Color)
    _WinAPI_SetBkColor($hDC, 0x000000)
    _WinAPI_SetBkMode($hDC, $TRANSPARENT)

    $init = TimerInit()
    Do
        _WinAPI_DrawText($hDC, $Text, $tRECT, $DT_CENTER)
        Sleep(100)
    Until TimerDiff($init) > $Time

    _WinAPI_SelectObject($hDC, $hOldFont)
    _WinAPI_DeleteObject($hFont)
    _WinAPI_ReleaseDC(0, $hDC)
    _WinAPI_InvalidateRect(0, 0)
    $tRECT = 0
EndFunc