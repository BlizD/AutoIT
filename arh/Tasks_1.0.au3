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
;~ #include <mysql.au3>

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

Global $sUsername="taskadmin", $sPassword="bdksat", $sDatabase="TaskDBPlanB", $sServer="A07-gw"

;~ $sDatabase_Filename="D:\Ivanov A.B\1c\autoit\TaskDB.db"
;~ $sDatabase_Filename="\\192.168.0.6\folders_otdel\Службы главного инженера\Отдел автоматизации и информатики\TaskDB.db"
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
	;Установка значений пользователя
	$CurrentUser=""
	Switch @UserName
		Case "Sanek"
			$CurrentUser="Лахнов Александр"
		Case "Bliz"
			$CurrentUser="Иванов Антон"
			$CurrentUser="Рябинина Татьяна"
;~ 			$CurrentUser="Кучеренко Александр"
;~ 			$CurrentUser="Пащенко Александр"
;~ 			$CurrentUser="Омельчук Сергей"
;~ 			$CurrentUser="Чубукин Денис"
;~ 			$CurrentUser="Лахнов Александр"
		Case "tanka"
			$CurrentUser="Рябинина Татьяна"
		Case "Chubukin_DV"
			$CurrentUser="Чубукин Денис"
		Case "point212"
			$CurrentUser="Пащенко Александр"
		Case "Somel"
			$CurrentUser="Омельчук Сергей"
		Case "Kucherenko"
			$CurrentUser="Кучеренко Александр"
	EndSwitch
;~ 	ConsoleWrite(@OSVersion)
;~  	MsgBox(-1,"",@OSVersion)
	if $CurrentUser = "" then
		MsgBox(-1,"","Пользователь не определен, продолжение не возможно")
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

	;############ Инициализация Трея #########################
	$RestoreItem = TrayCreateItem("Восстановить.",-1,-1,0)
	TrayItemSetOnEvent($RestoreItem, "_RestoreFromTray_Proc")
	$ExitItem = TrayCreateItem("Выход")
	TrayItemSetOnEvent($ExitItem, "_ExitFromTray_Proc")
;~ 	TraySetState (4)
	TraySetOnEvent(-13, "_RestoreFromTray_Proc")
	TraySetClick(8)

	;############ Конец Инициализации Трея #########################

	;############ Инициализация Формы Задачи #########################
	$GUI = GUICreate("Задачи " & @UserName & " - " & $CurrentUser, 450, 320,$Left_Form,10)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Minimize")
	$Button_Handle=_GUICtrlButton_Create($GUI,"<- Ход работы", 2, 2,80, 20)


	$Button_AddTask=GUICtrlCreateButton("", 2, 296,25,25,$BS_ICON)
	GUICtrlSetImage($Button_AddTask, @ScriptFullPath, 201,$IconSize)
	GUICtrlSetOnEvent($Button_AddTask, "FuncAddTask")
	GUICtrlSetTip ($Button_AddTask, "Добавить задачу")
	$Button_EditTask=GUICtrlCreateButton("", 29, 296,25,25,$BS_ICON)
	GUICtrlSetImage($Button_EditTask, @ScriptFullPath, 202,$IconSize)
	GUICtrlSetOnEvent($Button_EditTask, "FuncEditTask")
	GUICtrlSetTip ($Button_EditTask, "Изменить задачу")
	$Button_AnswerTask=GUICtrlCreateButton("", 55, 296,35,25,$BS_ICON)
	GUICtrlSetImage($Button_AnswerTask, @ScriptFullPath, 203,$IconSize)
	GUICtrlSetOnEvent($Button_AnswerTask, "FuncAnswerTask")
	GUICtrlSetTip ($Button_AnswerTask, "Добавить ход работы")
	$Button_DelTask=GUICtrlCreateButton("", 91, 296,25,25,$BS_ICON)
	GUICtrlSetImage($Button_DelTask, @ScriptFullPath, 204,$IconSize)
	GUICtrlSetOnEvent($Button_DelTask, "FuncDelTask")
	GUICtrlSetTip ($Button_DelTask, "Удалить задачу")
	$Button_Update=GUICtrlCreateButton("", 117, 296,25,25,$BS_ICON)
	GUICtrlSetImage($Button_Update, @ScriptFullPath, 205,$IconSize)
	GUICtrlSetOnEvent($Button_Update, "FuncUpdate")
	GUICtrlSetTip ($Button_Update, "Обновить")
	$CurrentTask_Label=GUICtrlCreateLabel("", 2, 266,450,28)
	GUICtrlSetFont ($CurrentTask_Label, 9)

    $Worker_Combo_Otbor=GUICtrlCreateCombo("Все", 90, 2,130) ; create first item
	GUICtrlSetOnEvent($Worker_Combo_Otbor,"LoadTasks")

	$TaskComplete_Checkbox=GUICtrlCreateCheckbox ("Кроме выполненных", 230, 2 )
	GUICtrlSetOnEvent($TaskComplete_Checkbox,"LoadTasks")
	GUICtrlSetState ($TaskComplete_Checkbox,$GUI_CHECKED)
	$hListView = _GUICtrlListView_Create($GUI, "", 2, 25, 450, 240)
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
	GUISetState(@SW_SHOW,$GUI)
    _GUICtrlListView_SetBkColor($hListView, $COLOR_SILVER)
    _GUICtrlListView_SetTextColor($hListView, $COLOR_BlACK)
    _GUICtrlListView_SetTextBkColor($hListView, $COLOR_SILVER)
	; Add columns
	_GUICtrlListView_InsertColumn($hListView, 0, "Статус", 67,3,-1,false)
	_GUICtrlListView_InsertColumn($hListView, 1, "Задача", 255)
	_GUICtrlListView_InsertColumn($hListView, 2, "Кто", 110)
	_GUICtrlListView_InsertColumn($hListView, 3, "id_Task", 0)
	_GUICtrlListView_SetOutlineColor($hListView, 0x0000FF)
	;############ Конец Инициализация Формы Задачи #########################


	;############ Инициализация Формы Ход работы #########################
	$GUI_Work = GUICreate("Ход работы", 400, 290,$Left_Form,10,$WS_SIZEBOX,-1,$GUI)
	GUISetOnEvent($GUI_EVENT_CLOSE, "OpenCurse")
	GUISetState(@SW_HIDE,$GUI_Work)
	$hListView_WorkCourse = _GUICtrlListView_Create($GUI_Work, "", 2, $Top_hListView_WorkCourse,390, $Height_WorkCourse)
	_GUICtrlListView_SetExtendedListViewStyle($hListView_WorkCourse, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
    _GUICtrlListView_SetBkColor($hListView_WorkCourse, $COLOR_SILVER)
    _GUICtrlListView_SetTextColor($hListView_WorkCourse, $COLOR_BlACK)
    _GUICtrlListView_SetTextBkColor($hListView_WorkCourse, $COLOR_SILVER)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 0, "№", 20)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 1, "Ход работы", 250)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 2, "Автор", 100)
	;############ Конец Инициализация Формы Ход работы #########################

	;############ Инициализация Формы Add/Answer #########################
	$Form_AddTask = GUICreate("Добавить задачу", 455, $Height_Form_AddTask,-1,-1,$WS_SIZEBOX)
	GUISetOnEvent($GUI_EVENT_CLOSE, "AddTask")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "AddTask")
;~ 	$TaskNew_Edit = _GUICtrlEdit_Create($Form_AddTask, "", 2, 2, 440,40,$ES_MULTILINE+	)
	$TaskNew_Edit = _GUICtrlEdit_Create($Form_AddTask, "", 2, 2, 440,40,BitOr($ES_MULTILINE,$ES_WANTRETURN,$ES_AUTOVSCROLL))
	_GUICtrlEdit_SetLimitText($TaskNew_Edit, 500)
	GUICtrlCreateLabel("Кто:", 2, 55)
 	$Worker_Combo=_GUICtrlComboBox_Create($Form_AddTask, "", 25,45, 130, 100)
	GUICtrlCreateLabel("Статус:", 155, 55)
	$Status_Combo=_GUICtrlComboBox_Create($Form_AddTask, "", 195,45, 100, 100)
	$Add_Button=_GUICtrlButton_Create($Form_AddTask,"", 300, 45,141,20)
	For $id=0 to $KolVoWorkers-1
		_GUICtrlComboBox_AddString($Worker_Combo, $Array_Workers[$id][1])
		GUICtrlSetData($Worker_Combo_Otbor, $Array_Workers[$id][1],$CurrentUser)
	Next
	_GUICtrlComboBox_SetCurSel($Worker_Combo, 1)
	_GUICtrlComboBox_AddString($Status_Combo, "не начата")
	_GUICtrlComboBox_AddString($Status_Combo, "в процессе")
	_GUICtrlComboBox_AddString($Status_Combo, "отменена")
	_GUICtrlComboBox_AddString($Status_Combo, "выполнена")
	_GUICtrlComboBox_SetCurSel($Status_Combo, 0)
	GUISetState(@SW_HIDE, $Form_AddTask)
	;############ Конец Инициализация Формы Add/Answer #########################

	;############ Инициализация Формы Events #########################
	$Form_Events = GUICreate("Новые события", 500, 300,-1,-1,$WS_EX_TOPMOST)
	$Events_ListView = _GUICtrlListView_Create($Form_Events, "", 2, 2,490, 240)
	_GUICtrlListView_SetExtendedListViewStyle($Events_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
    _GUICtrlListView_SetBkColor($Events_ListView, $COLOR_SILVER)
    _GUICtrlListView_SetTextColor($Events_ListView, $COLOR_BlACK)
    _GUICtrlListView_SetTextBkColor($Events_ListView, $COLOR_SILVER)
	_GUICtrlListView_InsertColumn($Events_ListView, 0, "От кого", 110)
	_GUICtrlListView_InsertColumn($Events_ListView, 1, "Событие", 380)
	_GUICtrlListView_InsertColumn($Events_ListView, 2, "id_Event", 0)
	$Read_Button=GUICtrlCreateButton("Прочитано",90, 247,150,25)
	GUICtrlSetOnEvent($Read_Button, "IsRead")
	GUICtrlSetFont ($Read_Button, 14,600)

;~ 	CheckEvents()

	GUISetState(@SW_HIDE, $Form_Events)
	;############ Конец Инициализация Формы Events #########################

	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_MOVE, 'WM_MOVE')
;~ 	DllCall('uxtheme.dll', 'uint', 'SetWindowTheme', 'hwnd', $GUI_Work, 'ptr', 0, 'wstr', '')

	LoadTasks()


	; Add items
;~ 	ConsoleWrite($GUI & @CR )
	$TimeUpdate=3000
	$TekTime=0
;~ 	LoadTasks()
	While 1
		Sleep(1000)
		$TekTime=$TekTime+1000
		if $TekTime>=$TimeUpdate Then
			CheckEvents()
			if _GUICtrlListView_GetItemCount($Events_ListView) >0  then
				GUISetState(@SW_SHOW, $Form_Events)
				GUISetState(@SW_RESTORE, $Form_Events)
				TraySetState (4)
			EndIf
			while _GUICtrlListView_GetItemCount($Events_ListView) >0
				Sleep(1000)
				if Not WinActive("Новые события") then
					WinActivate ("Новые события")
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
;~ 	################ MySQL
	$SQLOpen=_MySQLConnect($sUsername, $sPassword, $sDatabase, $sServer)
;~ 	$TextQuery="SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	"
	$id_Worker=(_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1)
	$TextQuery="SELECT Events.id_Event,Workers.Name,Events.ToWhom,Events.Description FROM Events LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Workers ON Workers.id_Worker=Events.ToFrom WHERE    Events.isRead=0    AND Events.ToWhom=" & $id_Worker
;~ 	ConsoleWrite($TextQuery)
	$Result=_Query($SQLOpen, $TextQuery)

	if $Result <> 0 then
		$CurRow=0
		With $Result
			While NOT .EOF
				$Text_Event=.Fields("Description").value
				$RazmerPachki=60
				$Current_Razmer=StringLen($Text_Event)
				$Text_Row=$Text_Event
				if StringLen($Text_Event) > $RazmerPachki then
					$Text_Row=StringLeft($Text_Event,$RazmerPachki-1)
					$Current_Razmer=$RazmerPachki
				EndIf
				_GUICtrlListView_AddItem($Events_ListView, .Fields("Name").value)
				_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, $Text_Row, 1)
				_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, .Fields("id_Event").value, 2)
				$CurRow=$CurRow+1
				While $Current_Razmer <StringLen($Text_Event)
					$Text_Row=StringMid($Text_Event,$Current_Razmer,$RazmerPachki)
					_GUICtrlListView_AddItem($Events_ListView, "")
					_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, $Text_Row, 1)
					_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, "", 2)
					$Current_Razmer=$Current_Razmer+$RazmerPachki
					$CurRow=$CurRow+1
				WEnd
				.MoveNext
			WEnd
		EndWith
	EndIf
	_MySQLEnd($SQLOpen)
;~ 	################ MySQL


;~ 	_SQLite_Startup()
;~ 	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
;~ 	$SQLOpen=SQL_Open()
;~ 	if  $SQLOpen then
;~ 		$id_Worker=(_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1)
;~ 	;~ 	_SQlite_Query (-1, "SELECT Events.id_Event,Workers.Name,Events.ToWhom,Events.Description FROM Events LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Workers ON Workers.id_Worker=Events.ToFrom WHERE    Events.isRead=0    AND Events.ToWhom=" & $id_Worker , $hQuery)
;~ 		$TextQuery="SELECT Events.id_Event,Workers.Name,Events.ToWhom,Events.Description FROM Events LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Workers ON Workers.id_Worker=Events.ToFrom WHERE    Events.isRead=0    AND Events.ToWhom=" & $id_Worker
;~ 		$Result=SQLQueryOk($TextQuery,$hQuery)
;~ 		if $Result = $SQLITE_OK then
;~ 			_SQLite_FetchNames ($hQuery, $aNames)
;~ 			$CurRow=0
;~ 			While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
;~ 				$Text_Event=$aRow[3]
;~ 				ConsoleWrite($Text_Event & @CRLF)
;~ 				$RazmerPachki=60
;~ 				$Current_Razmer=StringLen($Text_Event)
;~ 				$Text_Row=$Text_Event
;~ 				if StringLen($Text_Event) > $RazmerPachki then
;~ 					$Text_Row=StringLeft($Text_Event,$RazmerPachki-1)
;~ 					$Current_Razmer=$RazmerPachki
;~ 				EndIf
;~ 				_GUICtrlListView_AddItem($Events_ListView, $aRow[1])
;~ 				_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, $Text_Row, 1)
;~ 				_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, $aRow[0], 2)
;~ 				$CurRow=$CurRow+1
;~ 				While $Current_Razmer <StringLen($Text_Event)
;~ 					$Text_Row=StringMid($Text_Event,$Current_Razmer,$RazmerPachki)
;~ 					ConsoleWrite($Text_Row & @CRLF)
;~ 					_GUICtrlListView_AddItem($Events_ListView, "")
;~ 					_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, $Text_Row, 1)
;~ 					_GUICtrlListView_AddSubItem($Events_ListView, $CurRow, "", 2)
;~ 					$Current_Razmer=$Current_Razmer+$RazmerPachki