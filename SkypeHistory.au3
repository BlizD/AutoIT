;~ #include <SQLite.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#Include <File.au3>
#include <date.au3>
#include <Array.au3>

Local $aResult, $iRows, $iColumns, $iRval

If Not FileExists("SkypeChatHistory") Then
    DirCreate("SkypeChatHistory")
EndIf

_SQLite_Startup()
    $iSQLite = _SQLite_Open(@ScriptDir & "\main.db")

    $iRval = _SQLite_GetTable2d($iSQLite, "SELECT skypename FROM contacts", $aResult, $iRows, $iColumns)
    $aResultx = $aResult

For $a = 1 to UBound($aResultx)-1
    $tmpx = $aResultx[$a][0]
    
    $iRval = _SQLite_GetTable2d($iSQLite, "SELECT author, timestamp, body_xml FROM Messages WHERE dialog_partner = '" & $tmpx &"'", $aResult, $iRows, $iColumns)

    $Path = @ScriptDir & "\SkypeChatHistory\" & $tmpx & ".txt"
    $Razdelit = '|'

    $tmp = ''
For $i = 0 to UBound($aResult)-1
    $unixtimestamp = $aResult[$i][1]
    $iDateCalc = _DateAdd('s', $unixtimestamp, "1970/01/01 00:00:00")
    $tmp &= $aResult[$i][0] & $Razdelit & $iDateCalc & $Razdelit & $aResult[$i][2] & @CRLF
Next
    $file = FileOpen($Path,2)
    FileWrite($file, $tmp)
    FileClose($file)
Next

_SQLite_Close($iSQLite)
_SQLite_Shutdown()