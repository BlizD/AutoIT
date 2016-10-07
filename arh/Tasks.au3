#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon="C:\Tasks.ico"
#AutoIt3Wrapper_Res_Icon_Add=C:\Plus3.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Edit.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Answer.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Del.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Update.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon
#include <sqlite.au3>
#include <sqlite.dll.au3>
#include <GuiConstantsEx.au3>
#include <GuiListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
#include <GuiButton.au3>
#include <GUIConstants.au3>
#include <Misc.au3>
#Include <GuiComboBox.au3>
#include <GuiEdit.au3>
#Include <WinAPI.au3>
#include <Date.au3>
#include <StaticConstants.au3>
#include <FontConstants.au3>

;~ #Include <Icons.au3>
;~ _SQLite_Open ( [ $sDatabase_Filename = ":memory:" [,$iAccessMode [,$iEncoding ]]] )
;~ Opt("GUICoordMode", 2)
;~ Opt("GUIOnEventMode", 1)
Local $hQuery,$aRow,$aNames

Global $hListView,$hListView_WorkCourse,$GUI,$GUI_Work,$Button_Handle,$Button_AddTask,$Button_EditTask, $Form_AddTask,$TaskNew_Edit,$Worker_Combo,$Add_Button,$Button_AnswerTask
Global $Button_DelTask,$Status_Combo,$Worker_Combo_Otbor,$TaskComplete_Checkbox, $CurrentTask_Label,$Button_Update
Global $CurrentRow, $CurseOpen=False,$Diff,$AddTaskOpen=False,$Array_Workers[1][2], $TypeProcess="",$CurTypeProcess="", $CurrentIDTask=0,$CurrentUser,$OnlyUpdate,$Last_Worker,$Last_Status,$Last_Name
Global $Height_Form_AddTask,$Width_Form_AddTask,$Top_hListView_WorkCourse,$Top_FormAddTask,$Left_FormCourse,$Top_FormCourse,$Height_FormCourse,$Left_FormAddTask,$Width_FormCourse,$id_Chief=1
Global $Form_Events,$Events_ListView,$Read_Button, $NewEvents=False,$SQL_TaskDB, $SQLOpen=False,$CountCourse=0
;~ $sDatabase_Filename="D:\Ivanov A.B\1c\autoit\TaskDB.db"
$sDatabase_Filename="\\192.168.0.6\folders_otdel\������ �������� ��������\����� ������������� � �����������\TaskDB.db"
;~ $sDatabase_Filename="\\192.168.0.111\DWND\TaskDB.db"

;~ #Region
;~ #AutoIt3Wrapper_Res_File_Add="C:\Plus.bmp", 2, 200
;~ #EndRegion
$Debug_LV = False ; Check ClassName being passed to ListView functions, set to True and use a handle to another control to see it work
Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
_Main()
Func _Main()
	;��������� �������� ������������
	$CurrentUser=""
	Switch @UserName
		Case "Sanek"
			$CurrentUser="������ ���������"
		Case "ivanov"
			$CurrentUser="������ �����"
;~ 			$CurrentUser="�������� �������"
;~ 			$CurrentUser="��������� ���������"
;~ 			$CurrentUser="������� ���������"
;~ 			$CurrentUser="�������� ������"
;~ 			$CurrentUser="������� �����"
;~ 			$CurrentUser="������ ���������"
		Case "tanka"
			$CurrentUser="�������� �������"
		Case "Chubukin_DV"
			$CurrentUser="������� �����"
		Case "point212"
			$CurrentUser="������� ���������"
		Case "Somel"
			$CurrentUser="�������� ������"
		Case "Kucherenko"
			$CurrentUser="��������� ���������"
	EndSwitch
;~ 	ConsoleWrite(@OSVersion)
;~  	MsgBox(-1,"",@OSVersion)
	if $CurrentUser = "" then
		MsgBox(-1,"","������������ �� ���������, ����������� �� ��������")
		Exit
	EndIf
;~ 	ConsoleWrite("" & @UserName & " - " & $CurrentUser & @CR)
	$Diff=-400
	Local $hImage
;~ 	_SQLite_Startup()
;~ 	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)

	$Top_Form=@DesktopHeight
	$Left_Form=@DesktopWidth-470

	$KolVoWorkers=LoadWorkers()
;~ 	_ArrayDisplay($Array_Workers)
;~ 	Exit
	$Width_Form_AddTask=455
	$Height_Form_AddTask=92
	$Top_FormAddTask=345
	$Left_FormAddTask=0
	$Top_hListView_WorkCourse=25
	$Left_FormCourse=400
	$Top_FormCourse=0
	$Height_FormCourse=0
	$Width_FormCourse=400
	$Height_WorkCourse=240
	$IconSize=1
	if @OSVersion="WIN_7" Then
		$Height_Form_AddTask=110
		$Width_Form_AddTask=467
		$Top_FormAddTask=352
		$Left_FormAddTask=5

		$Top_hListView_WorkCourse=2

		$Left_FormCourse=415
		$Top_FormCourse=4
		$Height_FormCourse=11
		$Width_FormCourse=410
		$Height_WorkCourse=270
		$IconSize=0
	EndIf

	;############ ������������� ���� #########################
	$RestoreItem = TrayCreateItem("������������.",-1,-1,0)
	TrayItemSetOnEvent($RestoreItem, "_RestoreFromTray_Proc")
	$ExitItem = TrayCreateItem("�����")
	TrayItemSetOnEvent($ExitItem, "_ExitFromTray_Proc")
;~ 	TraySetState (4)
	TraySetOnEvent(-13, "_RestoreFromTray_Proc")
	TraySetClick(8)

	;############ ����� ������������� ���� #########################

	;############ ������������� ����� ������ #########################
	$GUI = GUICreate("������ " & @UserName & " - " & $CurrentUser, 450, 320,$Left_Form,10)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Minimize")
	$Button_Handle=_GUICtrlButton_Create($GUI,"<- ��� ������", 2, 2,80, 20)


	$Button_AddTask=GUICtrlCreateButton("", 2, 296,25,25,$BS_ICON)
	GUICtrlSetImage($Button_AddTask, @ScriptFullPath, 201,$IconSize)
	GUICtrlSetOnEvent($Button_AddTask, "FuncAddTask")
	GUICtrlSetTip ($Button_AddTask, "�������� ������")
	$Button_EditTask=GUICtrlCreateButton("", 29, 296,25,25,$BS_ICON)
	GUICtrlSetImage($Button_EditTask, @ScriptFullPath, 202,$IconSize)
	GUICtrlSetOnEvent($Button_EditTask, "FuncEditTask")
	GUICtrlSetTip ($Button_EditTask, "�������� ������")
	$Button_AnswerTask=GUICtrlCreateButton("", 55, 296,35,25,$BS_ICON)
	GUICtrlSetImage($Button_AnswerTask, @ScriptFullPath, 203,$IconSize)
	GUICtrlSetOnEvent($Button_AnswerTask, "FuncAnswerTask")
	GUICtrlSetTip ($Button_AnswerTask, "�������� ��� ������")
	$Button_DelTask=GUICtrlCreateButton("", 91, 296,25,25,$BS_ICON)
	GUICtrlSetImage($Button_DelTask, @ScriptFullPath, 204,$IconSize)
	GUICtrlSetOnEvent($Button_DelTask, "FuncDelTask")
	GUICtrlSetTip ($Button_DelTask, "������� ������")
	$Button_Update=GUICtrlCreateButton("", 117, 296,25,25,$BS_ICON)
	GUICtrlSetImage($Button_Update, @ScriptFullPath, 205,$IconSize)
	GUICtrlSetOnEvent($Button_Update, "FuncUpdate")
	GUICtrlSetTip ($Button_Update, "��������")
	$CurrentTask_Label=GUICtrlCreateLabel("", 2, 266,450,28)
	GUICtrlSetFont ($CurrentTask_Label, 9)

;~ 	$MyTask_Checkbox=GUICtrlCreateCheckbox ("��� ������", 90, 2 )
;~ 	GUICtrlSetState ($MyTask_Checkbox,$GUI_CHECKED)
;~ 	GUICtrlSetOnEvent($MyTask_Checkbox,"LoadTasks")
    $Worker_Combo_Otbor=GUICtrlCreateCombo("���", 90, 2,130) ; create first item
	GUICtrlSetOnEvent($Worker_Combo_Otbor,"LoadTasks")

	$TaskComplete_Checkbox=GUICtrlCreateCheckbox ("����� �����������", 230, 2 )
	GUICtrlSetOnEvent($TaskComplete_Checkbox,"LoadTasks")
	GUICtrlSetState ($TaskComplete_Checkbox,$GUI_CHECKED)

;~     GUICtrlSetData(-1, "item2|item3", "item3") ; add other item snd set a new default


	$hListView = _GUICtrlListView_Create($GUI, "", 2, 25, 450, 240)
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
	GUISetState(@SW_SHOW,$GUI)
    _GUICtrlListView_SetBkColor($hListView, $COLOR_SILVER)
    _GUICtrlListView_SetTextColor($hListView, $COLOR_BlACK)
    _GUICtrlListView_SetTextBkColor($hListView, $COLOR_SILVER)
	; Add columns
	_GUICtrlListView_InsertColumn($hListView, 0, "������", 67,3,-1,false)
	_GUICtrlListView_InsertColumn($hListView, 1, "������", 255)
	_GUICtrlListView_InsertColumn($hListView, 2, "���", 110)
	_GUICtrlListView_InsertColumn($hListView, 3, "id_Task", 0)
	_GUICtrlListView_SetOutlineColor($hListView, 0x0000FF)
	;############ ����� ������������� ����� ������ #########################


	;############ ������������� ����� ��� ������ #########################
	$GUI_Work = GUICreate("��� ������", 400, 290,$Left_Form,10,$WS_SIZEBOX,-1,$GUI)
	GUISetOnEvent($GUI_EVENT_CLOSE, "OpenCurse")
	GUISetState(@SW_HIDE,$GUI_Work)
	$hListView_WorkCourse = _GUICtrlListView_Create($GUI_Work, "", 2, $Top_hListView_WorkCourse,390, $Height_WorkCourse)
	_GUICtrlListView_SetExtendedListViewStyle($hListView_WorkCourse, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
    _GUICtrlListView_SetBkColor($hListView_WorkCourse, $COLOR_SILVER)
    _GUICtrlListView_SetTextColor($hListView_WorkCourse, $COLOR_BlACK)
    _GUICtrlListView_SetTextBkColor($hListView_WorkCourse, $COLOR_SILVER)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 0, "�", 20)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 1, "��� ������", 250)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 2, "�����", 100)
	;############ ����� ������������� ����� ��� ������ #########################

	;############ ������������� ����� Add/Answer #########################
	$Form_AddTask = GUICreate("�������� ������", 455, $Height_Form_AddTask,-1,-1,$WS_SIZEBOX)
	GUISetOnEvent($GUI_EVENT_CLOSE, "AddTask")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "AddTask")
;~ 	$TaskNew_Edit = _GUICtrlEdit_Create($Form_AddTask, "", 2, 2, 440,40,$ES_MULTILINE+	)
	$TaskNew_Edit = _GUICtrlEdit_Create($Form_AddTask, "", 2, 2, 440,40,BitOr($ES_MULTILINE,$ES_WANTRETURN,$ES_AUTOVSCROLL))
	_GUICtrlEdit_SetLimitText($TaskNew_Edit, 500)
	GUICtrlCreateLabel("���:", 2, 55)
 	$Worker_Combo=_GUICtrlComboBox_Create($Form_AddTask, "", 25,45, 130, 100)
	GUICtrlCreateLabel("������:", 155, 55)
	$Status_Combo=_GUICtrlComboBox_Create($Form_AddTask, "", 195,45, 100, 100)
	$Add_Button=_GUICtrlButton_Create($Form_AddTask,"", 300, 45,141,20)
	For $id=0 to $KolVoWorkers-1
		_GUICtrlComboBox_AddString($Worker_Combo, $Array_Workers[$id][1])
		GUICtrlSetData($Worker_Combo_Otbor, $Array_Workers[$id][1],$CurrentUser)
	Next
	_GUICtrlComboBox_SetCurSel($Worker_Combo, 1)
	_GUICtrlComboBox_AddString($Status_Combo, "�� ������")
	_GUICtrlComboBox_AddString($Status_Combo, "� ��������")
	_GUICtrlComboBox_AddString($Status_Combo, "��������")
	_GUICtrlComboBox_AddString($Status_Combo, "���������")
	_GUICtrlComboBox_SetCurSel($Status_Combo, 0)
	GUISetState(@SW_HIDE, $Form_AddTask)
	;############ ����� ������������� ����� Add/Answer #########################

	;############ ������������� ����� Events #########################
	$Form_Events = GUICreate("����� �������", 500, 300,-1,-1,$WS_EX_TOPMOST)
	$Events_ListView = _GUICtrlListView_Create($Form_Events, "", 2, 2,490, 240)
	_GUICtrlListView_SetExtendedListViewStyle($Events_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
    _GUICtrlListView_SetBkColor($Events_ListView, $COLOR_SILVER)
    _GUICtrlListView_SetTextColor($Events_ListView, $COLOR_BlACK)
    _GUICtrlListView_SetTextBkColor($Events_ListView, $COLOR_SILVER)
	_GUICtrlListView_InsertColumn($Events_ListView, 0, "�� ����", 110)
	_GUICtrlListView_InsertColumn($Events_ListView, 1, "�������", 380)
	_GUICtrlListView_InsertColumn($Events_ListView, 2, "id_Event", 0)
	$Read_Button=GUICtrlCreateButton("���������",90, 247,150,25)
	GUICtrlSetOnEvent($Read_Button, "IsRead")
	GUICtrlSetFont ($Read_Button, 14,600)
	CheckEvents()
	GUISetState(@SW_HIDE, $Form_Events)
	;############ ����� ������������� ����� Events #########################

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_MOVE, 'WM_MOVE')
;~ 	DllCall('uxtheme.dll', 'uint', 'SetWindowTheme', 'hwnd', $GUI_Work, 'ptr', 0, 'wstr', '')
	LoadTasks()
	; Add items
;~ 	ConsoleWrite($GUI & @CR )
	$TimeUpdate=30000
	$TekTime=0
	LoadTasks()
	While 1
		Sleep(1000)
		$TekTime=$TekTime+1000
		if $TekTime>=$TimeUpdate Then
			CheckEvents()
;~ 			ConsoleWrite( _GUICtrlListView_GetItemCount($Events_ListView) & @CRLF)
			if _GUICtrlListView_GetItemCount($Events_ListView) >0  then
				GUISetState(@SW_SHOW, $Form_Events)
				GUISetState(@SW_RESTORE, $Form_Events)
				TraySetState (4)
			EndIf
			while _GUICtrlListView_GetItemCount($Events_ListView) >0
				Sleep(1000)
;~ 				GUISetState(@SW_SHOW, $Form_Events)
;~ 				GUISetState(@SW_RESTORE, $Form_Events)
				if Not WinActive("����� �������") then
					WinActivate ("����� �������")
				EndIf
			WEnd


			$TekTime=0
		EndIf
	WEnd


EndFunc   ;==>_Main

Func IsRead()
	$Events_Count=_GUICtrlListView_GetItemCount($Events_ListView)
	$TekRowEvent=0
	For $TekRowEvent=0 to $Events_Count-1
		if _GUICtrlListView_GetItemText($Events_ListView,$TekRowEvent, 0)<>"" Then
			$TextQuery=""
			$TextQuery="UPDATE Events  SET isRead=1 WHERE Events.id_Event=" & _GUICtrlListView_GetItemText($Events_ListView,$TekRowEvent, 2)
			ExecuteQuery($TextQuery)
	;~ 		ConsoleWrite($TextQuery & @CRLF)
		EndIf
	Next
	_GUICtrlListView_DeleteAllItems($Events_ListView)
	GUISetState(@SW_HIDE, $Form_Events)
	TraySetState (8)
	LoadTasks()
EndFunc

Func CheckEvents()
	_GUICtrlListView_DeleteAllItems($Events_ListView)
	_SQLite_Startup()
;~ 	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
	$SQLOpen=SQL_Open()
	if  $SQLOpen then
		$id_Worker=(_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1)
	;~ 	_SQlite_Query (-1, "SELECT Events.id_Event,Workers.Name,Events.ToWhom,Events.Description FROM Events LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Workers ON Workers.id_Worker=Events.ToFrom WHERE    Events.isRead=0    AND Events.ToWhom=" & $id_Worker , $hQuery)
		$TextQuery="SELECT Events.id_Event,Workers.Name,Events.ToWhom,Events.Description FROM Events LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Workers ON Workers.id_Worker=Events.ToFrom WHERE    Events.isRead=0    AND Events.ToWhom=" & $id_Worker
		$Result=SQLQueryOk($TextQuery,$hQuery)
		if $Result = $SQLITE_OK then
			_SQLite_FetchNames ($hQuery, $aNames)
			$CurRow=0
			While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
				$Text_Event=$aRow[3]
;~ 				ConsoleWrite($Text_Event & @CRLF)
				$RazmerPachki=60
				$Current_Razmer=StringLen($Text_Event)
				$Text_Row=$Text_Event
				if StringLen($Text_Event) > $RazmerPachki then
					$Text_Row=StringLeft($Text_Event,$RazmerPachki-1)
					$Current_Razmer=$RazmerPachki
				EndIf
				_GUICtrlListView_AddItem($Events_ListView, $aRow[1])
				_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, $Text_Row, 1)
				_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, $aRow[0], 2)
				$CurRow=$CurRow+1
				While $Current_Razmer <StringLen($Text_Event)
					$Text_Row=StringMid($Text_Event,$Current_Razmer,$RazmerPachki)
;~ 					ConsoleWrite($Text_Row & @CRLF)
					_GUICtrlListView_AddItem($Events_ListView, "")
					_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, $Text_Row, 1)
					_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, "", 2)
					$Current_Razmer=$Current_Razmer+$RazmerPachki
					$CurRow=$CurRow+1
				WEnd

			WEnd
		EndIf

		SQL_Close()
	EndIf
	_SQLite_Shutdown()
EndFunc
Func SQL_Open()
	$SQLOpen=False
	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
	$NomerPoputki=1
    While $SQL_TaskDB = 0 AND $NomerPoputki<3
		Sleep(3000)
		$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
		$NomerPoputki=$NomerPoputki+1
	WEnd
;~ 	ConsoleWrite("���� ������� :" & $SQL_TaskDB &@CRLF)
	if $SQL_TaskDB = 0 then
		Return False
	Else
		Return True
	EndIf
EndFunc
Func SQL_Close()
	$NomerPoputki=1
	$SQL_Close=_SQLite_Close($SQL_TaskDB)
;~ 	ConsoleWrite("���� ������� :" & $SQL_TaskDB &@CRLF)
	While $SQL_Close <>$SQLITE_OK AND $NomerPoputki<3
		Sleep(3000)
		$SQL_Close=_SQLite_Close($SQL_TaskDB)
		$NomerPoputki=$NomerPoputki+1
	WEnd
EndFunc
Func AddEvents($Event_Text,$ToFrom,$ToWhom)
	$TekTime =_NowDate()
	$TekTime = StringReplace($TekTime, ".", "")
	$MailTo=""
	$TextQuery="Insert into Events values (NULL,"& $ToFrom &","& $ToWhom &","& $TekTime &","&Chr(34) & $Event_Text &chr(34)&",0,"& chr(34) & $MailTo &chr(34)&",0)"
;~ 	ConsoleWrite($TextQuery & @CRLF)
	ExecuteQuery($TextQuery)
	;"Insert into Events values (NULL,1,2,'01.01.2011','����� ������: ������������ SQL',0,'BlizzardAnton@mail.ru',0)"
EndFunc
Func Minimize()
;~ 	ConsoleWrite("test")
	GUISetState(@SW_HIDE, $GUI)
	if $CurseOpen then
		GUISetState(@SW_HIDE, $GUI_Work)
	EndIf
	if $AddTaskOpen then
		GUISetState(@SW_HIDE, $Form_AddTask)
	EndIf
	TraySetState(1)
EndFunc
Func _ExitFromTray_Proc ()
	Exit
EndFunc
Func _RestoreFromTray_Proc()
    If BitAND(WinGetState($GUI), 2) = 2 Then Return
    TraySetState(2)
	GUISetState(@SW_SHOW, $GUI)
	GUISetState(@SW_RESTORE,$GUI)
	if $CurseOpen then
		GUISetState(@SW_SHOW, $GUI_Work)
		GUISetState(@SW_RESTORE,$GUI_Work)
	EndIf
	if $AddTaskOpen then
		GUISetState(@SW_SHOW, $Form_AddTask)
		GUISetState(@SW_RESTORE,$Form_AddTask)
	EndIf

EndFunc
Func FuncUpdate()
 	LoadTasks()
EndFunc
Func FuncDelTask()
	$TypeProcess="Del"
	AddTask()
EndFunc

Func FuncAnswerTask()
	$TypeProcess="Answer"
	AddTask()
EndFunc

Func FuncEditTask()
	$TypeProcess="Edit"
	AddTask()
EndFunc

Func FuncAddTask()
	$TypeProcess="Add"
	AddTask()
EndFunc
func Close()
;~ 	_SQLite_Close($SQL_TaskDB)
;~ 	_SQLite_Shutdown()
	exit
EndFunc
Func OpenCurse()
;~ 	$DiffWidth=-$DiffWidth
 	Local $aGUI_Pos = WinGetPos($GUI)
;~ 	MsgBox(-1,"",$aGUI_Pos[0]+ 500 & "-" & @DesktopWidth)
;~ 	ConsoleWrite($aGUI_Pos[0] & "-" & @DesktopWidth)
;~ 	if  $aGUI_Pos[0] + 850 > @DesktopWidth then
;~  		$aGUI_Pos[0] = $aGUI_Pos[0] - 400
;~ 	Else
;~ 		$aGUI_Pos[0] = $aGUI_Pos[0] + 458
;~  	EndIf
	WinMove($GUI_Work, "", $aGUI_Pos[0]-$Left_FormCourse, $aGUI_Pos[1]-$Top_FormCourse, $Width_FormCourse, $aGUI_Pos[3]+$Height_FormCourse)
	$CurseOpen=Not $CurseOpen
;~ 	ConsoleWrite("OpenCurse() $CurseOpen- "&$CurseOpen&" $AddTaskOpen- "& $AddTaskOpen & " $TypeProcess -" & $TypeProcess&@CRLF)
	if $CurseOpen then
		GUISetState(@SW_SHOW,$GUI_Work)
		if $CurrentRow=-1 then
			$CurrentRow=0
		EndIf
		$id_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 3)
;~ 		ConsoleWrite($CurrentRow)
		if $id_Task <> 0 then
			LoadWorkCourse($id_Task)
		else
			_GUICtrlListView_DeleteAllItems($hListView_WorkCourse)
		EndIf
	Else
		GUISetState(@SW_HIDE,$GUI_Work)
	EndIf
EndFunc

Func LoadWorkers()
	_GUICtrlListView_DeleteAllItems($hListView_WorkCourse)
	_SQLite_Startup()

;~ 	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
;~ 	_SQlite_Query (-1, "SELECT * FROM Workers", $hQuery)
	$CurRow=0
	$SQLOpen=SQL_Open()
	if  $SQLOpen then
		$TextQuery="SELECT * FROM Workers"
		$Result=SQLQueryOk($TextQuery,$hQuery)
		if $Result = $SQLITE_OK then
			_SQLite_FetchNames ($hQuery, $aNames)
			$CurRow=0
			While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
				ReDim $Array_Workers[$CurRow+1][2]
		;~ 		$idStatus=4
		;~ 		MsgBox(-1,"",$aRow[0] & $aRow[1] & $aRow[2])
				$Array_Workers[$CurRow][0]=$aRow[0]
				$Array_Workers[$CurRow][1]=$aRow[1]
		;~ 		_GUICtrlListView_AddSubItem($hListView, $CurRow, $aRow[0], 3)
				$CurRow=$CurRow+1
			WEnd
		EndIf
		SQL_Close()
	EndIf
	_SQLite_Shutdown()
	Return $CurRow
EndFunc

Func LoadTasks()
;~ 	CheckEvents()
;~ 	ConsoleWrite(GUICtrlRead ($MyTask_Checkbox))
	_GUICtrlListView_DeleteAllItems($hListView)
	_SQLite_Startup()
;~ 	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
	$SQLOpen=SQL_Open()
	if  $SQLOpen then
		$TextIf=" WHERE"
	;~ 	if GUICtrlRead ($MyTask_Checkbox)=1 Then
	;~ 		$TextIf=$TextIf & " Tasks.id_Worker=" & (_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1) & " AND "
	;~ 	EndIf
		if GUICtrlRead ($Worker_Combo_Otbor)<>"���" Then
			$TextIf=$TextIf & " Tasks.id_Worker=" & (_GUICtrlComboBox_FindString($Worker_Combo, GUICtrlRead ($Worker_Combo_Otbor))+1) & " AND "
		EndIf
		if GUICtrlRead ($TaskComplete_Checkbox)=1 Then
			$TextIf=$TextIf & " Tasks.status<>" & Chr(34) &"���������"&Chr(34)  & " AND" & " Tasks.status<>" & Chr(34) &"��������"&Chr(34)  & " AND"
		EndIf
		if $TextIf=" WHERE" Then
			$TextIf=""
		Else
			$TextIf=StringLeft($TextIf,StringLen($TextIf)-4)
		EndIf
	;~ 	ConsoleWrite($TextIf)
	;~ 	_SQlite_Query (-1, "SELECT Tasks.id_Task,Tasks.Name,Tasks.id_Worker,Tasks.id_Chief,Workers.Name AS Worker,Chief.Name AS Chief,Tasks.Date,Tasks.status AS Status FROM Tasks LEFT JOIN (SELECT Workers.id_Worker,Workers.Name,Posts.Name AS Post FROM Workers LEFT JOIN (SELECT Posts.id_Post, Posts.Name FROM Posts) Posts ON Posts.id_Post=Workers.id_Post) Workers ON Workers.id_Worker=Tasks.id_Worker LEFT JOIN (SELECT Workers.id_Worker,Workers.Name,Posts.Name AS Post FROM Workers     LEFT JOIN (SELECT Posts.id_Post, Posts.Name FROM Posts WHERE Posts.id_Post=1) Posts ON Posts.id_Post=Workers.id_Post) Chief ON Chief.id_Worker=Tasks.id_Chief" & $TextIf, $hQuery)
		$TextQuery="SELECT Tasks.id_Task,Tasks.Name,Tasks.id_Worker,Tasks.id_Chief,Workers.Name AS Worker,Chief.Name AS Chief,Tasks.Date,Tasks.status AS Status FROM Tasks LEFT JOIN (SELECT Workers.id_Worker,Workers.Name,Posts.Name AS Post FROM Workers LEFT JOIN (SELECT Posts.id_Post, Posts.Name FROM Posts) Posts ON Posts.id_Post=Workers.id_Post) Workers ON Workers.id_Worker=Tasks.id_Worker LEFT JOIN (SELECT Workers.id_Worker,Workers.Name,Posts.Name AS Post FROM Workers     LEFT JOIN (SELECT Posts.id_Post, Posts.Name FROM Posts WHERE Posts.id_Post=1) Posts ON Posts.id_Post=Workers.id_Post) Chief ON Chief.id_Worker=Tasks.id_Chief" & $TextIf
		$Result=SQLQueryOk($TextQuery,$hQuery)
		if $Result = $SQLITE_OK then
			_SQLite_FetchNames ($hQuery, $aNames)
			$CurRow=0
			While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
				$idStatus=4
				if $aRow[7]="�� ������" then
					$idStatus=0
				EndIf
				if $aRow[7]="���������" then
					$idStatus=2
				EndIf
				_GUICtrlListView_AddItem($hListView, $aRow[7])
				_GUICtrlListView_AddSubItem($hListView, $CurRow, $aRow[1], 1)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, $aRow[4], 2)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, $aRow[0], 3)
				$CurRow=$CurRow+1
			WEnd
		EndIf
		SQL_Close()
	EndIf
	_SQLite_Shutdown()
EndFunc
Func AddTask($OnlyUpdate=False)
;~ 	_GUICtrlListView_DeleteAllItems($hListView)
	if $CurrentIDTask =0 or $CurrentIDTask = "" AND $TypeProcess<>"Add" then
;~ 		_DrawText('������� ������ �����', 80, 'Verdana', 0x000000, 3000)
		GUICtrlSetData ( $CurrentTask_Label, "������� ������ �����")
;~ 		MsgBox(-1,"","������� ������ �����")
		$TypeProcess=""
		return 0
	EndIf

	;~ 	ConsoleWrite("Cur- "& $CurTypeProcess & "  Type-"&$TypeProcess & "   Open-" &$AddTaskOpen & @CR)
	Local $aGUI_Pos = WinGetPos($GUI)
	WinMove($Form_AddTask, "", $aGUI_Pos[0]-$Left_FormAddTask, $aGUI_Pos[1]+$Top_FormAddTask,$Width_Form_AddTask,$Height_Form_AddTask)

	if $OnlyUpdate then
	Else
		if Not $AddTaskOpen then
			$CurTypeProcess=$TypeProcess
		EndIf
		if $CurTypeProcess=$TypeProcess or $CurTypeProcess="" then
			if $AddTaskOpen then
				GUISetState(@SW_HIDE, $Form_AddTask)
				if $CurseOpen and $TypeProcess= "Answer" then
					OpenCurse()
				EndIf
				$TypeProcess=""
			Else
				GUISetCursor (-1,-1,$Form_AddTask)
				GUISetState(@SW_SHOW, $Form_AddTask)
			EndIf
			$AddTaskOpen=Not $AddTaskOpen
		Else
			GUISetCursor (-1,-1,$Form_AddTask)
			GUISetState(@SW_SHOW, $Form_AddTask)
	;~ 		$AddTaskOpen=Not $AddTaskOpen
		EndIf
	EndIf
;~ 	GUICtrlSetPos ($Add_Button, 300, 45,141,20)
;~ 	GUICtrlSetState ( $TaskNew_Edit, $GUI_SHOW )
;~ 	ConsoleWrite("AddTask $CurseOpen- "&$CurseOpen&" $AddTaskOpen- "& $AddTaskOpen & " $TypeProcess -" & $TypeProcess&@CRLF)
	if $TypeProcess= "Add" then
		_WinAPI_SetWindowText($Form_AddTask, "�������� ������")
		_GUICtrlButton_SetText($Add_Button, "��������")
		_GUICtrlEdit_SetText($TaskNew_Edit,"")
		_GUICtrlComboBox_SetCurSel($Status_Combo,0)
 		_GUICtrlComboBox_SetCurSel($Worker_Combo,_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser))
	ElseIf $TypeProcess= "Edit" Then
		$Text_Task=""
		$Text_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
		$Worker=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2)
		_GUICtrlComboBox_SetCurSel($Worker_Combo, _GUICtrlComboBox_FindString($Worker_Combo, $Worker))
		_GUICtrlButton_SetText($Add_Button, "��������")
		_WinAPI_SetWindowText($Form_AddTask, "�������� ������   ")
		_GUICtrlEdit_SetText($TaskNew_Edit,$Text_Task)
		$Status=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 0)
		_GUICtrlComboBox_SetCurSel($Status_Combo,_GUICtrlComboBox_FindString($Status_Combo, $Status))
	ElseIf $TypeProcess= "Answer" Then

		if Not $AddTaskOpen And $CurseOpen then
;~ 			$CurseOpen=False
		EndIf
 		if  $CurseOpen then
			LoadWorkCourse($CurrentIDTask)
		Else
			OpenCurse()
 		EndIf


		$Text_Task=""
		$Text_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
		_WinAPI_SetWindowText($Form_AddTask, "�������� �� ������ - "  & $Text_Task)
		_GUICtrlButton_SetText($Add_Button, "��������")
		_GUICtrlEdit_SetText($TaskNew_Edit,"")
		$Status=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 0)
		_GUICtrlComboBox_SetCurSel($Status_Combo,_GUICtrlComboBox_FindString($Status_Combo, $Status))
		_GUICtrlComboBox_SetCurSel($Worker_Combo, _GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser))
	Elseif $TypeProcess= "Del" then
		$Text_Task=""
		$Text_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
		_WinAPI_SetWindowText($Form_AddTask, "������� ������ - "& $Text_Task)
		_GUICtrlButton_SetText($Add_Button, "�������")
		_GUICtrlEdit_SetText($TaskNew_Edit,$Text_Task)
		$Status=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 0)
		_GUICtrlComboBox_SetCurSel($Status_Combo,_GUICtrlComboBox_FindString($Status_Combo, $Status))
		$Worker=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2)
		_GUICtrlComboBox_SetCurSel($Worker_Combo, _GUICtrlComboBox_FindString($Worker_Combo, $Worker))
;~ 		GUICtrlSetPos ($Add_Button, 1, 1,449,66)
;~ 		GUICtrlSetState ( $Add_Button, $GUI_FOCUS )
;~ 		GUICtrlSetState ( $TaskNew_Edit, $GUI_HIDE )
	EndIf
	$CurTypeProcess=$TypeProcess

	$Last_Worker=_GUICtrlComboBox_GetCurSel($Worker_Combo)+1
	$Last_Status=_GUICtrlComboBox_GetEditText($Status_Combo)
	$Last_Name=_GUICtrlEdit_GetText($TaskNew_Edit)
;~ 	ConsoleWrite($AddTaskOpen)

;~ 	$Form_AddTask = GUICreate("�������� ������", 455, 100,$aGUI_Pos[0],$aGUI_Pos[1]+310,$WS_OVERLAPPED)

;~ 	_SQLite_Startup()
;~ 	_SQLite_Open($sDatabase_Filename)
;~ 	$TxtQuery="Insert into Tasks values (NULL,'������ �1','������� ����������','2','1','01.01.2011')"
;~ 	_SQlite_Query (-1, "SELECT Tasks.id_Task,Tasks.Name,Tasks.Description,Tasks.id_Worker,Tasks.id_Chief,Workers.Name AS Worker,Chief.Name AS Chief,Tasks.Date,CASE WHEN Tasks.id_status  = 0  THEN '�� ������'    WHEN Tasks.id_status  = 1  THEN '������'    WHEN Tasks.id_status  = 5  THEN '���������'  END Status FROM Tasks LEFT JOIN (SELECT Workers.id_Worker,Workers.Name,Posts.Name AS Post FROM Workers LEFT JOIN (SELECT Posts.id_Post, Posts.Name FROM Posts) Posts ON Posts.id_Post=Workers.id_Post) Workers ON Workers.id_Worker=Tasks.id_Worker LEFT JOIN (SELECT Workers.id_Worker,Workers.Name,Posts.Name AS Post FROM Workers     LEFT JOIN (SELECT Posts.id_Post, Posts.Name FROM Posts WHERE Posts.id_Post=1) Posts ON Posts.id_Post=Workers.id_Post) Chief ON Chief.id_Worker=Tasks.id_Chief", $hQuery)
;~ 	_SQLite_Close()
;~ 	_SQLite_Shutdown()
EndFunc

Func ExecuteQuery($TextQuery)
 	_SQLite_Startup()
;~   	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
;~ ~ 	$TxtQuery="Insert into Tasks values (NULL,'������ �1','������� ����������','2','1','01.01.2011')"
;~ 	$TextQuery="SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	"
	$SQLOpen=SQL_Open()
	if  $SQLOpen then
		$Result=SQLQueryOk($TextQuery,$hQuery)
		if $Result = $SQLITE_OK then
	;~ 		_SQlite_Query ($SQL_TaskDB, $TextQuery, $hQuery)
			_SQLite_FetchNames ($hQuery, $aNames)
			$CurRow=0
			While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
				$CurRow=$CurRow+1
			WEnd
		EndIf
		SQL_Close()
	EndIf
 	_SQLite_Shutdown()
EndFunc

Func LoadWorkCourse($idTask)
	_GUICtrlListView_DeleteAllItems($hListView_WorkCourse)
	_SQLite_Startup()
;~ 	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
;~ 	_SQlite_Query (-1, "SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	", $hQuery)
	$SQLOpen=SQL_Open()
	if  $SQLOpen then
		$TextQuery="SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	"
		$Result=SQLQueryOk($TextQuery,$hQuery)
		if $Result = $SQLITE_OK then
			_SQLite_FetchNames ($hQuery, $aNames)
			$CurRow=0
			$CountCourse=0
			While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
				$Text_Course=$aRow[1]
;~ 				ConsoleWrite($Text_Event & @CRLF)
				$RazmerPachki=42
				$Current_Razmer=StringLen($Text_Course)
				if StringLen($Text_Course) > $RazmerPachki then
					$Text_Row=StringLeft($Text_Course,$RazmerPachki-1)
					$Current_Razmer=$RazmerPachki
				Else
					$Text_Row=$Text_Course
				EndIf
				_GUICtrlListView_AddItem($hListView_WorkCourse, $aRow[0])
				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $Text_Row,1)
				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $aRow[2],2)
				$CurRow=$CurRow+1
				$CountCourse=$CountCourse+1
				While $Current_Razmer <StringLen($Text_Course)
					$Text_Row=StringMid($Text_Course,$Current_Razmer,$RazmerPachki)
					_GUICtrlListView_AddItem($hListView_WorkCourse, "")
					_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $Text_Row,1)
					_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, "",2)
					$Current_Razmer=$Current_Razmer+$RazmerPachki
					$CurRow=$CurRow+1
				WEnd
;~ 				_GUICtrlListView_AddItem($hListView_WorkCourse, $aRow[0])
;~ 				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $aRow[1],1)
;~ 				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $aRow[2],2)
;~ 				$CurRow=$CurRow+1
			WEnd
		EndIf
		SQL_Close()
	EndIf
	_SQLite_Shutdown()
EndFunc

Func SQLQueryOk($TextQuery,ByRef $hQuery)
	$NomerPoputki=1
	$Result=_SQlite_Query ($SQL_TaskDB, $TextQuery, $hQuery)
	While $Result<>$SQLITE_OK AND $NomerPoputki<3
		Sleep(3000)
		$Result=_SQlite_Query ($SQL_TaskDB, $TextQuery, $hQuery)
		$NomerPoputki=$NomerPoputki+1
	WEnd
	return $Result
EndFunc

Func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)

	#forceref $hWnd, $Msg
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	Local $sText = ""
;~ 	ConsoleWrite($Button_Handle & "  -  "& $MyTask_Checkbox & @CR )
;~ 	_ArrayDisplay(GUIGetMsg (1))

	Switch $hCtrl
		Case $Button_Handle
			Switch $nNotifyCode
				Case $BN_CLICKED
					$sText = "$BN_CLICKED" & @CRLF
;~ 					If _GUICtrlButton_GetText($hCtrl)="<- ��� ������" then
;~ 					If _GUICtrlButton_GetText($hCtrl)="<- ��� ������" then
					OpenCurse()
;~ 					EndIf
;~ 					If _GUICtrlButton_GetText($hCtrl)="�������� ������" then

;~ 					EndIf
				Case $BN_PAINT
					$sText = "$BN_PAINT" & @CRLF
				Case $BN_PUSHED, $BN_HILITE
					$sText = "$BN_PUSHED, $BN_HILITE" & @CRLF
				Case $BN_UNPUSHED, $BN_UNHILITE
					$sText = "$BN_UNPUSHED" & @CRLF
				Case $BN_DISABLE
					$sText = "$BN_DISABLE" & @CRLF
				Case $BN_DBLCLK, $BN_DOUBLECLICKED
					$sText = "$BN_DBLCLK, $BN_DOUBLECLICKED" & @CRLF
				Case $BN_SETFOCUS
					$sText = "$BN_SETFOCUS" & @CRLF
				Case $BN_KILLFOCUS
					$sText = "$BN_KILLFOCUS" & @CRLF
			EndSwitch
;~ 		Case $Button_AddTask
;~ 			Switch $nNotifyCode
;~ 				Case $BN_CLICKED
;~ 					$TypeProcess="Add"
;~ 					AddTask()
;~ 			EndSwitch
		case $Button_EditTask
			Switch $nNotifyCode
				Case $BN_CLICKED
					$TypeProcess= "Edit"
					if $CurrentRow = -1 then
						$CurrentRow=0
					EndIf
					AddTask()
				EndSwitch
		case $Button_AnswerTask
			Switch $nNotifyCode
				Case $BN_CLICKED
					$TypeProcess= "Answer"
					AddTask()
			EndSwitch
		case $Button_DelTask
			Switch $nNotifyCode
				Case $BN_CLICKED
					$TypeProcess= "Del"
					AddTask()
			EndSwitch
;~ 		case $MyTask_Checkbox
;~ 			ConsoleWrite($hCtrl & @CR)
;~ 			Switch $nNotifyCode
;~ 				Case $BN_CLICKED

;~ 			EndSwitch
		case $Add_Button
			Switch $nNotifyCode
				Case $BN_CLICKED
					$TextQuery=""
;~ 					_GUICtrlEdit_GetText($TaskNew_Edit)
;~ 					$Worker=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2)
;~ 					_GUICtrlComboBox_SetCurSel($Worker_Combo, _GUICtrlComboBox_FindString($Worker_Combo, $Worker))
;~ 					$TextQuery="UPDATE Tasks  SET name=" & _GUICtrlEdit_GetText($TaskNew_Edit) & ",id_worker="& _GUICtrlComboBox_GetCurSel($Worker_Combo) &",status="& _GUICtrlComboBox_GetCurSel($Status_Combo) &", WHERE Tasks.id_Task=" & $CurrentIDTask
					$TekTime =_NowDate()
					$TekTime = StringReplace($TekTime, ".", "")
					$Event_Text=""
					$id_Worker=(_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1)
					$new_id_Worker=(_GUICtrlComboBox_GetCurSel($Worker_Combo)+1)
;~ 					if $CurrentIDTask <>0 then
;~ 					ConsoleWrite("TypeProcess-" & $TypeProcess & " ��������������-" & $id_Worker & " ������������������-" & $new_id_Worker &@CR)
;~ 					ConsoleWrite("������������?-"&((_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1)=1) & @CR)
;~ 					ConsoleWrite("������������?-"& (1=1) & @CR)
;~ 					ConsoleWrite(_GUICtrlComboBox_GetEditText($Status_Combo))
					$TaskTextEdit=_GUICtrlEdit_GetText($TaskNew_Edit)
					$TaskTextEdit=StringReplace($TaskTextEdit,@CR,"")
					$TaskTextEdit=StringReplace($TaskTextEdit,@CRLF,"")
					$TaskTextEdit=StringReplace($TaskTextEdit,chr(34),"")
					$TaskTextEdit=StringStripWS($TaskTextEdit, 7)
					$TaskTextEdit=StringStripCR ($TaskTextEdit)



;~ 					ConsoleWrite($TaskTextEdit)
;~ 					Exit
					if StringLen($TaskTextEdit) >0 then
						if $TypeProcess="Add" then
							$TextQuery="Insert into Tasks values (NULL,"& Chr(34)& $TaskTextEdit & Chr(34)  &"," & $new_id_Worker &",1,"& $TekTime &","& Chr(34) &_GUICtrlComboBox_GetEditText($Status_Combo) &Chr(34)&")"
							$Event_Text="����� ������: " & _GUICtrlEdit_GetText($TaskNew_Edit)
							$Koef=Ceiling(StringLen($Event_Text)/60)
							While StringLen($Event_Text)<60*$Koef-1
								$Event_Text=$Event_Text &" "
							WEnd
							$Event_Text=$Event_Text & "�����������: " &  _GUICtrlComboBox_GetEditText($Worker_Combo)
;~ 							ConsoleWrite($Event_Text)
;~ 							Exit
							if $id_Worker=$id_Chief then ; ��� ���������
								AddEvents($Event_Text,$id_Chief,$new_id_Worker)
							Elseif $id_Worker=$new_id_Worker Then
								AddEvents($Event_Text,$id_Worker,$id_Chief)
							Else
								AddEvents($Event_Text,$id_Worker,$new_id_Worker)
								if $new_id_Worker <> $id_Chief then
									AddEvents($Event_Text,$id_Worker,$id_Chief)
								EndIf
							EndIf
						elseif $TypeProcess="Edit" then
							if $Last_Status=_GUICtrlComboBox_GetEditText($Status_Combo) And _
							   $Last_Worker=$new_id_Worker And _
							   $Last_Name=$TaskTextEdit Then ;��������� �� ���������

							Else
								if ($id_Worker<>$id_Chief)  AND	($id_Worker <>$Last_Worker)  then
									MsgBox(-1,"","�������� ����� ������ ���� ������")
	;~ 								$TypeProcess="Edit"
									return 0
								Elseif _GUICtrlComboBox_GetEditText($Status_Combo)="���������" AND $id_Worker<>$id_Chief  then
									MsgBox(-1,"","������� � ���������� ������ ����� ��������� ������ ���������")
	;~ 								$TypeProcess="Edit"
									return 0
								Else
									$TextQuery="UPDATE Tasks  SET name=" &  Chr(34) & $TaskTextEdit & Chr(34) & ",id_worker="& (_GUICtrlComboBox_GetCurSel($Worker_Combo)+1) & ",status="& Chr(34) &_GUICtrlComboBox_GetEditText($Status_Combo) & Chr(34) &" WHERE Tasks.id_Task=" & $CurrentIDTask
			;~ 						$TypeProcess= "Edit"
									if $Last_Worker=$new_id_Worker then ; �������� � ������ �� ���������
										if $Last_Status <> _GUICtrlComboBox_GetEditText($Status_Combo) then ;��������� ������ � ������
											$Event_Text="������ �������:"& _GUICtrlComboBox_GetEditText($Status_Combo) &" ������: " & $TaskTextEdit
										Else
											$Event_Text="�������� ������: " & $TaskTextEdit
										EndIf
										if $id_Worker=$id_Chief then ; ��� ��������� ������� ������
											AddEvents($Event_Text,$id_Chief,$new_id_Worker)
										Elseif $id_Worker=$new_id_Worker Then ; ��� ����������� ������ ������� ��
											AddEvents($Event_Text,$id_Worker,$id_Chief)
										Else ; ��� �� ����������� � �� ��������� ������� ������
	;~ 										AddEvents($Event_Text,$id_Worker,$new_id_Worker)
	;~ 										AddEvents($Event_Text,$id_Worker,$id_Chief)
										EndIf
									Else ;����� ����������� � ������
										if $id_Worker=$id_Chief then ; ��� ��������� ������� �����������
											$Event_Text="���� ������: " & $TaskTextEdit & " �������� �������"
											AddEvents($Event_Text,$id_Chief,$Last_Worker)
											$Event_Text="����� ������: " & $TaskTextEdit
											AddEvents($Event_Text,$id_Chief,$new_id_Worker)
										Elseif $id_Worker=$Last_Worker Then ; ������� �������� ������ ������� �����������
											$Event_Text="������: " & $TaskTextEdit & " �������� �������"
											AddEvents($Event_Text,$Last_Worker,$id_Chief)
											$Event_Text="����� ������: " & $TaskTextEdit
											AddEvents($Event_Text,$Last_Worker,$new_id_Worker)
										Else ; ������ �������� ������� ����������� ������
	;~ 										$Event_Text="����� ������: " & $TaskTextEdit
	;~ 										AddEvents($Event_Text,$id_Worker,$new_id_Worker)
	;~ 										AddEvents($Event_Text,$id_Worker,$id_Chief)
										EndIf
									EndIf
								EndIf
							EndIf
						elseif $TypeProcess="Answer" then
							$TextQuery="Insert into WorkCourse values (NULL,"& $CurrentIDTask &","& ($CountCourse+1)&"," & $TekTime &","& Chr(34) & $TaskTextEdit & Chr(34) &"," & (_GUICtrlComboBox_GetCurSel($Worker_Combo)+1) &")"
;~ 							$Event_Text="���: " &  $TaskTextEdit & " ��� ������: " &  _GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
							$Event_Text="������: " &  _GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
							$Koef=Ceiling(StringLen($Event_Text)/60)
;~ 							ConsoleWrite($Koef)
							While StringLen($Event_Text)<60*$Koef-1
								$Event_Text=$Event_Text &" "
							WEnd
							$Event_Text=$Event_Text & "�����������: " &  _GUICtrlListView_GetItemText($hListView,$CurrentRow, 2)
							While StringLen($Event_Text)<60*$Koef +59
								$Event_Text=$Event_Text &" "
							WEnd
							$Event_Text=$Event_Text & "����� ���: " &  $TaskTextEdit

;~ 							Exit
							$id_Ispolnitel=(_GUICtrlComboBox_FindString($Worker_Combo,_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2))+1)
							if $id_Worker=$id_Chief then ; ��� ��������� ������� ����� ���
								AddEvents($Event_Text,$id_Chief,$id_Ispolnitel)
							Elseif $id_Worker=$id_Ispolnitel Then ; ��� ����������� ������� ����� ���
								AddEvents($Event_Text,$id_Worker,$id_Chief)
							Else ; ��� �� ����������� � �� ��������� ������� ����� ���
								AddEvents($Event_Text,$id_Worker,$id_Ispolnitel)
								AddEvents($Event_Text,$id_Worker,$id_Chief)
							EndIf
							_GUICtrlEdit_SetText($TaskNew_Edit,"")
						elseif $TypeProcess="Ok" then
							$TextQuery="UPDATE Tasks  SET status='���������' WHERE Tasks.id_Task=" & $CurrentIDTask
						elseif $TypeProcess="Del" then
;~ 							$id_Ispolnitel=(_GUICtrlComboBox_FindString($Worker_Combo,_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2))+1)
							if $id_Worker<>$id_Chief then
								MsgBox(-1,"","������� ������ ����� ������ ���������")
;~ 								$TypeProcess="Edit"
								return 0
							Else
								$TextQuery="DELETE FROM WorkCourse WHERE WorkCourse.id_Task=" & $CurrentIDTask
								ExecuteQuery($TextQuery)
								$TextQuery=""
								$TextQuery="DELETE FROM Tasks WHERE Tasks.id_Task=" & $CurrentIDTask & ";"
		;~ 						$TypeProcess= "Edit"
								$Event_Text="������� ������: " &  _GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
;~ 								if $id_Worker=$id_Chief then ; ��� ��������� ������� ����� ���
								AddEvents($Event_Text,$id_Chief,$new_id_Worker)
;~ 								EndIf
							EndIf
						EndIf
;~ 	 					ConsoleWrite($TextQuery)
						if 	$TextQuery <> "" Then
							ExecuteQuery($TextQuery)
							If $TypeProcess="Del" AND $CurseOpen then
								OpenCurse()
							EndIf
							if $TypeProcess= "Answer" Then
								LoadWorkCourse($CurrentIDTask)
		;~ 						AddTask()
							Else
								AddTask()
								LoadTasks()
							EndIf
						EndIf
					EndIf
			EndSwitch
;~ 			_DebugPrint($sText & _
;~ 					"-----------------------------" & @CRLF & _
;~ 					"WM_COMMAND - Infos:" & @CRLF & _
;~ 					"-----------------------------" & @CRLF & _
;~ 					"Code" & @TAB & ":" & $nNotifyCode & @CRLF & _
;~ 					"CtrlID" & @TAB & ":" & $nID & @CRLF & _
;~ 					"CtrlHWnd:" & $hCtrl & @CRLF & _
;~ 					_GUICtrlButton_GetText($hCtrl) & @CRLF)
			Return 0 ; Only workout clicking on the button
	EndSwitch
	; Proceed the default Autoit3 internal message commands.
	; You also can complete let the line out.
	; !!! But only 'Return' (without any value) will not proceed
	; the default Autoit3-message in the future !!!
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
;~ 	Local $tBuffer
	$hWndListView = $hListView
	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
;~ 			ConsoleWrite($iCode & @CR)
			Switch $iCode
;~ 				Case $LVN_BEGINDRAG ; A drag-and-drop operation involving the left mouse button is being initiated
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_BEGINDRAG" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value
;~ 				Case $LVN_BEGINLABELEDIT ; Start of label editing for an item
;~ 					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
;~ 					_DebugPrint("$LVN_BEGINLABELEDIT" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @LF & _
;~ 							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @LF & _
;~ 							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @LF & _
;~ 							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
;~ 							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @LF & _
;~ 							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @LF & _
;~ 							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					Return False ; Allow the user to edit the label
;~ 					;Return True  ; Prevent the user from editing the label
;~ 				Case $LVN_BEGINRDRAG ; A drag-and-drop operation involving the right mouse button is being initiated
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_BEGINRDRAG" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value
;~ 				Case $LVN_BEGINSCROLL ; A scrolling operation starts, Minium OS WinXP
;~ 					$tInfo = DllStructCreate($tagNMLVSCROLL, $ilParam)
;~ 					_DebugPrint("$LVN_BEGINSCROLL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->DX:" & @TAB & DllStructGetData($tInfo, "DX") & @LF & _
;~ 							"-->DY:" & @TAB & DllStructGetData($tInfo, "DY"))
;~ 					; No return value
				Case $LVN_COLUMNCLICK ; A column was clicked
					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_COLUMNCLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
					$Sort=True
					 _GUICtrlListView_SimpleSort($hListView,$Sort , DllStructGetData($tInfo, "SubItem"))


					; No return value
;~ 				Case $LVN_DELETEALLITEMS ; All items in the control are about to be deleted
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_DELETEALLITEMS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					Return True ; To suppress subsequent $LVN_DELETEITEM messages
;~ 					;Return False ; To receive subsequent $LVN_DELETEITEM messages
;~ 				Case $LVN_DELETEITEM ; An item is about to be deleted
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_DELETEITEM" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value
;~ 				Case $LVN_ENDLABELEDIT ; The end of label editing for an item
;~ 					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
;~ 					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
;~ 					_DebugPrint("$LVN_ENDLABELEDIT" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @LF & _
;~ 							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @LF & _
;~ 							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
;~ 							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
;~ 							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @LF & _
;~ 							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
;~ 							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @LF & _
;~ 							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @LF & _
;~ 							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; If Text is not empty, return True to set the item's label to the edited text, return false to reject it
;~ 					; If Text is empty the return value is ignored
;~ 					Return True
;~ 				Case $LVN_ENDSCROLL ; A scrolling operation ends, Minium OS WinXP
;~ 					$tInfo = DllStructCreate($tagNMLVSCROLL, $ilParam)
;~ 					_DebugPrint("$LVN_ENDSCROLL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->DX:" & @TAB & DllStructGetData($tInfo, "DX") & @LF & _
;~ 							"-->DY:" & @TAB & DllStructGetData($tInfo, "DY"))
;~ 					; No return value
;~ 				Case $LVN_GETDISPINFO ; Provide information needed to display or sort a list-view item
;~ 					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
;~ 					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
;~ 					_DebugPrint("$LVN_GETDISPINFO" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @LF & _
;~ 							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @LF & _
;~ 							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
;~ 							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
;~ 							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @LF & _
;~ 							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
;~ 							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @LF & _
;~ 							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @LF & _
;~ 							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; No return value
;~ 				Case $LVN_GETINFOTIP ; Sent by a large icon view list-view control that has the $LVS_EX_INFOTIP extended style
;~ 					$tInfo = DllStructCreate($tagNMLVGETINFOTIP, $ilParam)
;~ 					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
;~ 					_DebugPrint("$LVN_GETINFOTIP" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Flags:" & @TAB & DllStructGetData($tInfo, "Flags") & @LF & _
;~ 							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
;~ 							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam"))
;~ 					; No return value
;~ 				Case $LVN_HOTTRACK ; Sent by a list-view control when the user moves the mouse over an item
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~                     Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~                     Local $iItem = DllStructGetData($tInfo, "Item")
;~                     Local $subitemNR = DllStructGetData($tInfo, "SubItem")

;~                     ; if no cell change return without doing anything
;~                     If $iLastItem = $iItem And $iLastsubitemNR = $subitemNR Then Return 0
;~                     $iLastItem = $iItem
;~                     $iLastsubitemNR = $subitemNR

;~                     Local $sToolTipData = StringReplace(_GUICtrlListView_GetItemText($hListView, $iItem, $subitemNR), "\n", @CRLF)

;~                     If @extended Then
;~                         ToolTip($sToolTipData, MouseGetPos(0) + 20, MouseGetPos(1) + 20)
;~                     Else
;~                         ToolTip("")
;~                         ConsoleWrite("R" & $iItem & "C" & $iLastsubitemNR & " No tip" & @CR)
;~                     EndIf
;~ 					_DebugPrint("$LVN_HOTTRACK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					Return 0 ; allow the list view to perform its normal track select processing.
					;Return 1 ; the item will not be selected.
;~ 				Case $LVN_INSERTITEM ; A new item was inserted
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_INSERTITEM" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value
;~ 				Case $LVN_ITEMACTIVATE ; Sent by a list-view control when the user activates an item
;~ 					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
;~ 					_DebugPrint("$LVN_ITEMACTIVATE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
;~ 							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
;~ 					Return 0
;~ 				Case $LVN_ITEMCHANGED ; An item has changed
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_ITEMCHANGED" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					; No return value
;~ 				Case $LVN_ITEMCHANGING ; An item is changing
;~ 					$tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
;~ 					_DebugPrint("$LVN_ITEMCHANGING" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param"))
;~ 					Return True ; prevent the change
;~ 					;Return False ; allow the change
				Case $LVN_KEYDOWN ; A key has been pressed
					$tInfo = DllStructCreate($tagNMLVKEYDOWN, $ilParam)
					if DllStructGetData($tInfo, "VKey")=40 then
						if $CurrentRow <=_GUICtrlListView_GetItemCount($hListView)-2 then
							$CurrentRow=$CurrentRow+1
						EndIf
					ElseIf DllStructGetData($tInfo, "VKey")=38 then
						if $CurrentRow>0 then
							$CurrentRow=$CurrentRow-1
						EndIf
					EndIf
;~ 					_DebugPrint("$LVN_KEYDOWN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->VKey:" & @TAB & DllStructGetData($tInfo, "VKey") & @LF & _
;~ 							"-->CurrentRow:" & @TAB & $CurrentRow & @LF & _
;~ 							"-->Count:" & @TAB & _GUICtrlListView_GetItemCount($hListView)-2 & @LF & _
;~ 							"-->Flags:" & @TAB & DllStructGetData($tInfo, "Flags"))
;~ 					$CurrentRow=_GUICtrlListView_GetSelectedIndices($hListView)+1
					$id_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 3)
					$CurrentIDTask=$id_Task
					$TekTask=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
;~ 				    if StringLen($TekTask)=50 then
;~ 						$TekTask=$TekTask & "..."
;~ 					EndIf
					GUICtrlSetData ( $CurrentTask_Label,$TekTask)
					if $id_Task >0 then
						if $AddTaskOpen or $CurseOpen then
							LoadWorkCourse($id_Task)
						EndIf
						AddTask(True)
					EndIf
					; No return value
;~ 				Case $LVN_MARQUEEBEGIN ; A bounding box (marquee) selection has begun
;~ 					_DebugPrint("$LVN_MARQUEEBEGIN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode)
;~ 					Return 0 ; accept the message
;~ 					;Return 1 ; quit the bounding box selection
;~ 				Case $LVN_SETDISPINFO ; Update the information it maintains for an item
;~ 					$tInfo = DllStructCreate($tagNMLVDISPINFO, $ilParam)
;~ 					$tBuffer = DllStructCreate("char Text[" & DllStructGetData($tInfo, "TextMax") & "]", DllStructGetData($tInfo, "Text"))
;~ 					_DebugPrint("$LVN_SETDISPINFO" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Mask:" & @TAB & DllStructGetData($tInfo, "Mask") & @LF & _
;~ 							"-->Item:" & @TAB & DllStructGetData($tInfo, "Item") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->State:" & @TAB & DllStructGetData($tInfo, "State") & @LF & _
;~ 							"-->StateMask:" & @TAB & DllStructGetData($tInfo, "StateMask") & @LF & _
;~ 							"-->Text:" & @TAB & DllStructGetData($tBuffer, "Text") & @LF & _
;~ 							"-->TextMax:" & @TAB & DllStructGetData($tInfo, "TextMax") & @LF & _
;~ 							"-->Image:" & @TAB & DllStructGetData($tInfo, "Image") & @LF & _
;~ 							"-->Param:" & @TAB & DllStructGetData($tInfo, "Param") & @LF & _
;~ 							"-->Indent:" & @TAB & DllStructGetData($tInfo, "Indent") & @LF & _
;~ 							"-->GroupID:" & @TAB & DllStructGetData($tInfo, "GroupID") & @LF & _
;~ 							"-->Columns:" & @TAB & DllStructGetData($tInfo, "Columns") & @LF & _
;~ 							"-->pColumns:" & @TAB & DllStructGetData($tInfo, "pColumns"))
;~ 					; No return value
				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
;~ 					_DebugPrint("$NM_CLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
;~ 							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))

					$CurrentRow=DllStructGetData($tInfo, "Index")
					$id_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 3)
					$CurrentIDTask=$id_Task
;~ 					$TekTask=StringLeft(_GUICtrlListView_GetItemText($hListView,$CurrentRow, 1),45)
					$TekTask=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
;~ 				    if StringLen($TekTask)=45 then
;~ 						$TekTask=$TekTask & "..."
;~ 					EndIf
					GUICtrlSetData ( $CurrentTask_Label,$TekTask)
;~ 					$CurrentTask_Label=GUICtrlCreateLabel("������� ������  - ", 120, 266)
;~ 					MsgBox(-1,"",$id_task)
					if $id_Task >0 then
;~ 						if $CurseOpen then
;~ 							$CurseOpen=False
;~ 						EndIf
;~ 						ConsoleWrite("$NM_CLICK $CurseOpen- "& $CurseOpen&" $AddTaskOpen- "& $AddTaskOpen & " $TypeProcess -" & $TypeProcess&@CRLF)
;~ 						ConsoleWrite("$AddTaskOpen-"&$AddTaskOpen)
						if $AddTaskOpen or $CurseOpen then
							LoadWorkCourse($id_Task)
						EndIf
						AddTask(True)
					EndIf
;~ 					if $AddTaskOpen then

;~ 					EndIf
;~
;~ 					MsgBox(-1,"",_GUICtrlListView_GetItemText($hListView,DllStructGetData($tInfo, "Index"), 3))
					; No return value
				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
;~ 					_DebugPrint("$NM_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
;~ 							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					$CurrentRow=DllStructGetData($tInfo, "Index")
					$TypeProcess= "Edit"
					if $CurrentRow = -1 then
						$CurrentRow=0
					EndIf
					AddTask()
					; No return value
;~ 				Case $NM_HOVER ; Sent by a list-view control when the mouse hovers over an item
;~ 					_DebugPrint("$NM_HOVER" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode)
;~ 					Return 0 ; process the hover normally
;~ 					;Return 1 ; prevent the hover from being processed
				Case $NM_KILLFOCUS ; The control has lost the input focus
;~ 					_DebugPrint("$NM_KILLFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode)
					; No return value
				Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
;~ 					_DebugPrint("$NM_RCLICK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
;~ 							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					;Return 1 ; not to allow the default processing
					Return 0 ; allow the default processing
				Case $NM_RDBLCLK ; Sent by a list-view control when the user double-clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
;~ 					_DebugPrint("$NM_RDBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode & @LF & _
;~ 							"-->Index:" & @TAB & DllStructGetData($tInfo, "Index") & @LF & _
;~ 							"-->SubItem:" & @TAB & DllStructGetData($tInfo, "SubItem") & @LF & _
;~ 							"-->NewState:" & @TAB & DllStructGetData($tInfo, "NewState") & @LF & _
;~ 							"-->OldState:" & @TAB & DllStructGetData($tInfo, "OldState") & @LF & _
;~ 							"-->Changed:" & @TAB & DllStructGetData($tInfo, "Changed") & @LF & _
;~ 							"-->ActionX:" & @TAB & DllStructGetData($tInfo, "ActionX") & @LF & _
;~ 							"-->ActionY:" & @TAB & DllStructGetData($tInfo, "ActionY") & @LF & _
;~ 							"-->lParam:" & @TAB & DllStructGetData($tInfo, "lParam") & @LF & _
;~ 							"-->KeyFlags:" & @TAB & DllStructGetData($tInfo, "KeyFlags"))
					; No return value
				Case $NM_RETURN ; The control has the input focus and that the user has pressed the ENTER key
;~ 					_DebugPrint("$NM_RETURN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode)
					; No return value
				Case $NM_SETFOCUS ; The control has received the input focus
;~ 					_DebugPrint("$NM_SETFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
;~ 							"-->Code:" & @TAB & $iCode)
					; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
Func WM_MOVE($hWnd, $iMsg, $wParam, $lParam)
;~ 	#forceref $hWnd, $iMsg, $iwParam

    Switch $hWnd
		Case $GUI=$hWnd
            Local $aGUI_Pos = WinGetPos($GUI)
			$Right=False
;~ 			$Diff=400
;~ 			ConsoleWrite($aGUI_Pos[0] & "<400" & " - " & $aGUI_Pos[0] + 450 +400 & ">1440" & @CR)
			if $aGUI_Pos[0] + 450 +400 > @DesktopWidth AND $aGUI_Pos[0]<400  Then
			Else
				if  $aGUI_Pos[0]<400 Then
					$Right=True
					$Diff= 458
				EndIf
				if $aGUI_Pos[0] + 450 +400 > @DesktopWidth then
					$Right=False
					$Diff= -400
				EndIf
			EndIf
;~ 			$aGUI_Pos[0] = $aGUI_Pos[0] + $Diff
            If IsArray($aGUI_Pos) Then
;~                 WinMove($GUI_Work, "", $aGUI_Pos[0]+ $Diff, $aGUI_Pos[1], 400, $aGUI_Pos[3])
				WinMove($GUI_Work, "", $aGUI_Pos[0]-$Left_FormCourse, $aGUI_Pos[1]-$Top_FormCourse, $Width_FormCourse, $aGUI_Pos[3]+$Height_FormCourse)
				WinMove($Form_AddTask, "", $aGUI_Pos[0]-$Left_FormAddTask, $aGUI_Pos[1]+$Top_FormAddTask,$Width_Form_AddTask,$Height_Form_AddTask)
;~ 				WinMove($Form_AddTask, "", $aGUI_Pos[0], $aGUI_Pos[1]+315,455,100)
            EndIf
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_MOVE


Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc

;===================================================
; ���������:    $Text   - �����.
;               $Size   - ������ ������.
;               $Font   - ����� ������.
;               $Color  - ���� ������.
;               $Time   - ����� ����������� ������.
;===================================================
Func _DrawText($Text, $Size, $Font, $Color, $Time)
    $tRECT = DllStructCreate($tagRect)
    DllStructSetData($tRECT, "Left", 0)
    DllStructSetData($tRECT, "Top", (@DesktopHeight / 2) - ($Size / 2))
    DllStructSetData($tRECT, "Right", @DesktopWidth)
    DllStructSetData($tRECT, "Bottom", @DesktopHeight)

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