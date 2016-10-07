#include "SMS.au3"

$server = "smtp.gmail.com"
$email = "BlizzardAnton@gmail.com"
$username = "BlizzardAnton@gmail.com"
$password = "ghtptyn ajh . 31"
$port = 465
$ssl = 1

;~ $number = xxxxxxxxxx
$number = 89281422052
$service = $T_MOBILE
$message = "Hello, This is an AutoIT SMS"
$message2 = "Yep..."

$sms = _SMS_Start($server,$email,$username,$password,$port,$ssl)
_SMS_Send($sms,$number,$service,$message)