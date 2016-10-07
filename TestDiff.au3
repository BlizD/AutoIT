#include <Date.au3>
$TimeBefore=_NowCalc()
Sleep(10000)
$UploadTime = _DateDiff( 's',$TimeBefore,_NowCalc())
MsgBox(-1,"",Round($UploadTime/60,2))