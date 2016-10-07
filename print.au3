    $sTempFileScreen = _TempFile(@TempDir, 'Èìÿ', '.jpg')
    _ScreenCapture_CaptureWnd($sTempFileScreen, $q, 0, 0, -1, -1, False)
    ShellExecute($sTempFileScreen,'', '', 'print', @SW_HIDE )