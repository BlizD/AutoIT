#Include <GDIPlus.au3>
#Include <WinAPI.au3>

$var = FileSelectFolder("Укажите папку с фотографиями.", "")
MsgBox(0,"",$var)
Exit

$search = FileFindFirstFile($var & "\*.jpg")  
; Check if the search was successful
If $search = -1 Then
    MsgBox(0, "Error", "No files/directories matched the search pattern")
    Exit
EndIf
While 1
    $file = FileFindNextFile($search) 
    If @error Then ExitLoop
    MsgBox(4096, "File:", $file)
WEnd

; Close the search handle
FileClose($search)











Func ResizeIMG()
	_GDIPlus_Startup()
	$hOrigin = _GDIPlus_ImageLoadFromFile('C:\1.jpg')
	$W = _GDIPlus_ImageGetWidth($hOrigin)
	$H = _GDIPlus_ImageGetHeight($hOrigin)
	if $W> $H then 
		$Width = 1024
		$Height = 768
	else
		$Width = 768
		$Height = 1024
	EndIf	
	$K1 = $Width / $W
	$K2 = $Height / $H
	If $K1 > $K2 Then
		$K1 = $K2
	EndIf
	$W *= $K1
	$H *= $K1
	$hBitmap = _WinAPI_CreateSolidBitmap(0, 0xFFFFFF, $Width, $Height)
	$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
	_WinAPI_DeleteObject($hBitmap)
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hOrigin, ($Width - $W) / 2, ($Height - $H) / 2, $W, $H)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_ImageDispose($hOrigin)
	_GDIPlus_ImageSaveToFile($hImage, 'Resized.jpg')
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_Shutdown()
EndFunc