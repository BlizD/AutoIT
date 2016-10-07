#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon="C:\Tasks.ico"
#AutoIt3Wrapper_Res_Icon_Add=C:\Plus3.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Edit.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Answer.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Del.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Update.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Voskl.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Clock.ico
#AutoIt3Wrapper_Res_Icon_Add=C:\Calend.ico
;~ #AutoIt3Wrapper_Res_File_Add=C:\Voskl.bmp, 2, 222
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
#include  <Constants.au3>
;~ #include <ScreenCapture.au3>
;~ #include <mysql.au3>

;~ #Include <Icons.au3>
;~ _SQLite_Open ( [ $sDatabase_Filename = ":memory:" [,$iAccessMode [,$iEncoding ]]] )
;~ Opt("GUICoordMode", 2)
;~ Opt("GUIOnEventMode", 1)
Local $hQuery,$aRow,$aNames

Global $hListView,$hListView_WorkCourse,$GUI,$GUI_Work,$Button_Handle,$Button_AddTask,$Button_EditTask, $Form_AddTask,$TaskNew_Edit,$Worker_Combo,$Add_Button,$Button_AnswerTask,$ImageList,$KolVoWorkers
Global $Button_DelTask,$Status_Combo,$Worker_Combo_Otbor,$TaskComplete_Checkbox, $CurrentTask_Label,$Button_Update,$NewCourse_Checkbox,$Label_Who,$Label_Status
Global $CurrentRow, $CurseOpen=False,$Diff,$AddTaskOpen=False,$Array_Workers[1][2], $TypeProcess="",$CurTypeProcess="", $CurrentIDTask=0,$CurrentUser,$OnlyUpdate,$Last_Worker,$Last_Status,$Last_Name
Global $Height_Form_AddTask,$Width_Form_AddTask,$Top_hListView_WorkCourse,$Top_FormAddTask,$Left_FormCourse,$Top_FormCourse,$Height_FormCourse,$Left_FormAddTask,$Width_FormCourse,$id_Chief=1,$Width_Form
Global $Form_Events,$Events_ListView,$Read_Button, $NewEvents=False,$SQL_TaskDB, $SQLOpen=False,$CountCourse=0,$Desc=false, $Form_Show=False,$TimeCheckUpdate,$Button_Turn, $TekRazmerpachki=500
Global $Remind_Combo,$Button_Remind,$Button_Calend,$Date_Calend,$Form_Calend,$Edit_Like

Global $sUsername="taskadmin", $sPassword="bdksat",  $sServer="192.168.0.6", $Version=" v0.2.8"
Global $sDatabase="TaskDB"
;~ Global $sDatabase="TaskDBPlanB"
Global $Sort=True
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

CheckUpdate()

_Main()
Func _Main()
	;Установка значений пользователя
	$CurrentUser=""
	$CurrentUser=GetCurrentUser()
;~ 	ConsoleWrite("-" & $CurrentUser)
;~ 	Exit
;~ 	Switch @UserName
;~ 		Case "Sanek"
;~ 			$CurrentUser="Лахнов Александр"
;~ 		Case "ivanov"
;~ 			$CurrentUser="Иванов Антон"
;~ 			$CurrentUser="Рябинина Татьяна"
;~ 			$CurrentUser="Кучеренко Александр"
;~ 			$CurrentUser="Пащенко Александр"
;~ 			$CurrentUser="Омельчук Сергей"
;~ 			$CurrentUser="Чубукин Денис"
;~ 			$CurrentUser="Лахнов Александр"
;~ 		Case "tanka"
;~ 			$CurrentUser="Рябинина Татьяна"
;~ 		Case "Chubukin_DV"
;~ 			$CurrentUser="Чубукин Денис"
;~ 		Case "point212"
;~ 			$CurrentUser="Пащенко Александр"
;~ 		Case "Somel"
;~ 			$CurrentUser="Омельчук Сергей"
;~ 		Case "Kucherenko"
;~ 			$CurrentUser="Кучеренко Александр"
;~ 	EndSwitch
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
	$Left_Form=@DesktopWidth-569
	$Width_Form=557
	$KolVoWorkers=LoadWorkers()
;~ 	_ArrayDisplay($Array_Workers)
;~ 	Exit


	$Height_Form_AddTask=112
	$Top_FormAddTask=375
	$Left_FormAddTask=0
	$TopLabel_AddAnswer=90

	$Top_hListView_WorkCourse=2

	$Height_FormCourse=0
	$Width_FormCourse=440
	$Height_WorkCourse=339
	$Left_FormCourse=$Width_FormCourse
	$Width_Form_AddTask=$Width_Form+7
	$Width_hListView_WorkCourse=$Width_FormCourse-10
	$Top_FormCourse=0
	$IconSize=1
	if @OSVersion="WIN_7" Then
		$Height_Form_AddTask=$Height_Form_AddTask+3
;~ 		$Width_Form_AddTask=$Width_Form_AddTask + 2
		$Top_FormAddTask=$Top_FormAddTask+7+4
;~ 		$Left_FormAddTask=5+3

		$Top_hListView_WorkCourse=2
		$Width_hListView_WorkCourse=$Width_hListView_WorkCourse-1

		$Top_FormCourse=4
		$Height_FormCourse=11
		$Width_FormCourse=$Width_FormCourse+15
;~ 		$Height_WorkCourse=$Height_WorkCours
		$Left_FormCourse=$Left_FormCourse+15
		$IconSize=0
;~ 		$TopLabel_AddAnswer=$TopLabel_AddAnswer+4
	EndIf

	;############ Инициализация Трея #########################
	$RestoreItem = TrayCreateItem("Восстановить.",-1,-1,0)
	TrayItemSetOnEvent($RestoreItem, "_RestoreFromTray_Proc")
	$ExitItem = TrayCreateItem("Выход")
	TrayItemSetOnEvent($ExitItem, "_ExitFromTray_Proc")
;~ 	TraySetState (4)
	TraySetOnEvent(-7, "_RestoreFromTray_Proc")
	TraySetClick(8)

	;############ Конец Инициализации Трея #########################

	;############ Инициализация Формы Задачи #########################
	$GUI = GUICreate("Задачи " & @UserName & " - " & $CurrentUser & " - " & $sDatabase & $Version, $Width_Form, 350,$Left_Form,10)
;~ 	GUISetBkColor($CLR_CREAM)
;~ 	GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
	GUISetOnEvent($GUI_EVENT_CLOSE, "Minimize")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Minimize")
;~ 	$Button_Handle=_GUICtrlButton_Create($GUI,"<- Ход работы", 2, 2,80, 20)
	$Button_Handle=GUICtrlCreateButton("<- Ход работы", 2, 2,80, 20)

	GUICtrlSetOnEvent($Button_Handle, "OpenCurse")
;~ 	GUICtrlSetBkColor($Button_Handle,0xfffbf0)
;~ 	GUISetBkColor($CLR_CREAM)
;~ 	GUICtrlSetBkColor ( $Button_Handle, $CLR_CREAM)


	$TopButtons=296 +30
	$Button_AddTask=GUICtrlCreateButton("", 2, $TopButtons,25,25,$BS_ICON)
	GUICtrlSetImage($Button_AddTask, @ScriptFullPath, 201,$IconSize)
	GUICtrlSetOnEvent($Button_AddTask, "FuncAddTask")
	GUICtrlSetTip ($Button_AddTask, "Добавить задачу")

	$Button_EditTask=GUICtrlCreateButton("", 29, $TopButtons,25,25,$BS_ICON)
	GUICtrlSetImage($Button_EditTask, @ScriptFullPath, 202,$IconSize)
	GUICtrlSetOnEvent($Button_EditTask, "FuncEditTask")
	GUICtrlSetTip ($Button_EditTask, "Изменить задачу")
	$Button_AnswerTask=GUICtrlCreateButton("", 55, $TopButtons,35,25,$BS_ICON)
	GUICtrlSetImage($Button_AnswerTask, @ScriptFullPath, 203,$IconSize)
	GUICtrlSetOnEvent($Button_AnswerTask, "FuncAnswerTask")
	GUICtrlSetTip ($Button_AnswerTask, "Добавить ход работы")
	$Button_DelTask=GUICtrlCreateButton("", 91, $TopButtons,25,25,$BS_ICON)
	GUICtrlSetImage($Button_DelTask, @ScriptFullPath, 204,$IconSize)
	GUICtrlSetOnEvent($Button_DelTask, "FuncDelTask")
	GUICtrlSetTip ($Button_DelTask, "Удалить задачу")
	$Button_Update=GUICtrlCreateButton("", 117, $TopButtons,25,25,$BS_ICON)
	GUICtrlSetImage($Button_Update, @ScriptFullPath, 205,$IconSize)
	GUICtrlSetOnEvent($Button_Update, "FuncUpdate")
	GUICtrlSetTip ($Button_Update, "Обновить")

	$Button_Turn=GUICtrlCreateButton("<>", 143, $TopButtons,25,25)
;~ 	GUICtrlSetImage($Button_Turn, @ScriptFullPath, 207,0)
	GUICtrlSetFont ($Button_Turn, 11,1200)
	GUICtrlSetOnEvent($Button_Turn, "TurnUpdate")
	GUICtrlSetTip ($Button_Turn, "Раскукожить")

	$Button_Remind=GUICtrlCreateButton("", 169, $TopButtons,25,25,$BS_ICON)
	GUICtrlSetImage($Button_Remind, @ScriptFullPath, 207,$IconSize)
	GUICtrlSetOnEvent($Button_Remind, "FuncRemind")
	GUICtrlSetTip ($Button_Remind, "Напомнить")


	$Edit_Like=GUICtrlCreateEdit("", 200, $TopButtons,200,25,$ES_AUTOVSCROLL)
;~ 	GUICtrlSetImage($Button_Remind, @ScriptFullPath, 207,$IconSize)
	GUICtrlSetOnEvent($Edit_Like, "FuncLike")
	GUICtrlSetTip ($Edit_Like, "Поиск")


	if @UserName = "ivanov" then
		$Button_SendEvents=GUICtrlCreateButton("Send", $Width_Form-30, $TopButtons,30,25)
	;~ 	GUICtrlSetImage($Button_Turn, @ScriptFullPath, 207,0)
		GUICtrlSetOnEvent($Button_SendEvents, "SendEvents")
		GUICtrlSetTip ($Button_SendEvents, "Послать сообщение")
	EndIf
;~ 	$CurrentTask_Label=GUICtrlCreateLabel("", 2, 267,520,27)
;~ 	GUICtrlSetFont ($CurrentTask_Label, 8.5)
;~ 	GUICtrlSetColor ( $CurrentTask_Label, 0xfffbf0)

;~ 	GUICtrlSetBkColor($CurrentTask_Label,0xfffbf0)

;~ 	GUISetBkColor(0xfffbf0)

    $Worker_Combo_Otbor=GUICtrlCreateCombo("Все", 90, 2,130) ; create first item
	GUICtrlSetOnEvent($Worker_Combo_Otbor,"EventOtbor")

	$TaskComplete_Checkbox=GUICtrlCreateCheckbox ("Кроме выполненных", 222, 2 )
	GUICtrlSetOnEvent($TaskComplete_Checkbox,"EventOtbor")
	GUICtrlSetState ($TaskComplete_Checkbox,$GUI_CHECKED)

	$NewCourse_Checkbox=GUICtrlCreateCheckbox ("Только новые хода и задачи", 350, 2 )
	GUICtrlSetOnEvent($NewCourse_Checkbox,"NewCourseCheck")



;~ 	$hListView = _GUICtrlListView_Create($GUI, "", 2, 25, 517, 240)
	$hListView = _GUICtrlListView_Create($GUI, "", 2, 25, $Width_Form, 298)
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
	_GUICtrlListView_RegisterSortCallBack($hListView)
;~ 	$ImageList = _GUIImageList_Create(5,12,1)
	$ImageList=_GUIImageList_Create(4, 12)
	_GUIImageList_AddIcon($ImageList,@ScriptFullPath, -206)
	_GUICtrlListView_SetImageList($hListView, $ImageList, 1)
	GUISetState(@SW_SHOW,$GUI)
	For $id = 1 to $CmdLine[0]
		Minimize()
	Next

	$Form_Show=True
;~     _GUICtrlListView_SetBkColor($hListView, $COLOR_SILVER)
	_GUICtrlListView_SetBkColor($hListView, $CLR_CREAM	)

    _GUICtrlListView_SetTextColor($hListView, $COLOR_BlACK)
    _GUICtrlListView_SetTextBkColor($hListView, $CLR_CREAM)
	; Add columns
	_GUICtrlListView_InsertColumn($hListView, 0, "Дата", 55,3,-1,false)
	_GUICtrlListView_InsertColumn($hListView, 1, "Статус", 69,3,-1,false)
	_GUICtrlListView_InsertColumn($hListView, 2, "Задача", 317)
	_GUICtrlListView_InsertColumn($hListView, 3, "Кто", 95)
	_GUICtrlListView_InsertColumn($hListView, 4, "id_Task", 0)
	_GUICtrlListView_InsertColumn($hListView, 5, "Description", 0)
	_GUICtrlListView_InsertColumn($hListView, 6, "status", 0)
	_GUICtrlListView_InsertColumn($hListView, 7, "worker", 0)
	_GUICtrlListView_SetOutlineColor($hListView, 0x0000FF)
	;############ Конец Инициализация Формы Задачи #########################


	;############ Инициализация Формы Ход работы #########################
;~ 	$GUI_Work = GUICreate("Ход работы", $Width_FormCourse, 290,$Left_Form,10,$WS_SIZEBOX,-1,$GUI)
	$GUI_Work = GUICreate("Ход работы", $Width_FormCourse, 290,$Left_Form,10,$WS_SIZEBOX,-1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "OpenCurse")
	GUISetBkColor(0xfffbf0)
	GUISetState(@SW_HIDE,$GUI_Work)
	$hListView_WorkCourse = _GUICtrlListView_Create($GUI_Work, "", 2, $Top_hListView_WorkCourse,$Width_hListView_WorkCourse, $Height_WorkCourse)
	_GUICtrlListView_SetExtendedListViewStyle($hListView_WorkCourse, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
    _GUICtrlListView_SetBkColor($hListView_WorkCourse, $CLR_CREAM)
    _GUICtrlListView_SetTextColor($hListView_WorkCourse, $COLOR_BlACK)
    _GUICtrlListView_SetTextBkColor($hListView_WorkCourse, $CLR_CREAM)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 0, "Дата", 67)
;~ 	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 1, "№", 20)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 1, "Ход работы", 250)
	_GUICtrlListView_InsertColumn($hListView_WorkCourse, 2, "Автор", 95)
	;############ Конец Инициализация Формы Ход работы #########################

	;############ Инициализация Формы Add/Answer #########################
	$Form_AddTask = GUICreate("Добавить задачу", $Width_FormCourse, $Height_Form_AddTask,-1,-1)
;~ 	$Form_AddTask = GUICreate("Добавить задачу", $Width_FormCourse, $Height_Form_AddTask,-1,-1)
	GUISetBkColor(0xfffbf0)
	GUISetOnEvent($GUI_EVENT_CLOSE, "AddTask")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "AddTask")
;~ 	GUISetOnEvent($GUI_EVENT_MINIMIZE, $GUI_EVENT_CLOSE)
;~ 	$TaskNew_Edit = _GUICtrlEdit_Create($Form_AddTask, "", 2, 2, 440,40,$ES_MULTILINE+	)
	$TaskNew_Edit = _GUICtrlEdit_Create($Form_AddTask, "", 2, 2, $Width_Form-5,60,BitOr($ES_MULTILINE,$ES_WANTRETURN,$ES_AUTOVSCROLL))
	$TopButtons_AddAnswer=65
	_GUICtrlEdit_SetLimitText($TaskNew_Edit, 500)
	$Label_Who=GUICtrlCreateLabel("Кто:", 2, $TopLabel_AddAnswer)
 	$Worker_Combo=_GUICtrlComboBox_Create($Form_AddTask, "", 25,$TopButtons_AddAnswer, 130, 100)
	$Label_Status=GUICtrlCreateLabel("Статус:", 128, $TopLabel_AddAnswer)
	$Status_Combo=_GUICtrlComboBox_Create($Form_AddTask, "", 199,$TopButtons_AddAnswer, 100, 100)
	$Add_Button=_GUICtrlButton_Create($Form_AddTask,"", 300, $TopButtons_AddAnswer,209+40,20)
	For $id=0 to $KolVoWorkers-1
		_GUICtrlComboBox_AddString($Worker_Combo, $Array_Workers[$id][1])
		GUICtrlSetData($Worker_Combo_Otbor, $Array_Workers[$id][1],$CurrentUser)
	Next
	_GUICtrlComboBox_SetCurSel($Worker_Combo, 1)
	_GUICtrlComboBox_AddString($Status_Combo, "не начата")
	_GUICtrlComboBox_AddString($Status_Combo, "важно")
	_GUICtrlComboBox_AddString($Status_Combo, "в процессе")
	_GUICtrlComboBox_AddString($Status_Combo, "отменена")
	_GUICtrlComboBox_AddString($Status_Combo, "выполнена")
	_GUICtrlComboBox_SetCurSel($Status_Combo, 0)

	$Remind_Combo=GUICtrlCreateCombo("Через 5 минут",2,$TopLabel_AddAnswer,213,100)
	GUICtrlSetData($Remind_Combo,"Через 10 минут")
	GUICtrlSetData($Remind_Combo,"Через 30 минут")
	GUICtrlSetData($Remind_Combo,"Через 1 час")
	GUICtrlSetData($Remind_Combo,"Через 2 часа")
	GUICtrlSetData($Remind_Combo,"Через 4 часа")
	GUICtrlSetData($Remind_Combo,"Через 8 часов")
	GUICtrlSetData($Remind_Combo,"Через 1 день")
	GUICtrlSetData($Remind_Combo,"Через 2 дня")
	GUICtrlSetData($Remind_Combo,"Через 4 дня")
	GUICtrlSetData($Remind_Combo,"Через 1 неделю")
	GUICtrlSetData($Remind_Combo,"Через 1 месяц")


	$Button_Calend=GUICtrlCreateButton("", 215, $TopButtons_AddAnswer+24,25,20,$BS_ICON)
	GUICtrlSetImage($Button_Calend, @ScriptFullPath, 208,$IconSize)
	GUICtrlSetOnEvent($Button_Calend, "FuncCalend")
	GUICtrlSetTip ($Button_Calend, "Выбрать дату")
	GUICtrlSetState($Button_Calend, $GUI_HIDE)
;~ 	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
	GUISetState(@SW_HIDE, $Form_AddTask)

	;############ Конец Инициализация Формы Add/Answer #########################


	;############ Инициализация Формы Events #########################
	$Form_Events = GUICreate("Новые события", 530, 300,-1,-1,$WS_EX_TOPMOST)
;~ 	GUISetBkColor(0xfffbf0)
	$Events_ListView = _GUICtrlListView_Create($Form_Events, "", 2, 2,520, 240)
	_GUICtrlListView_SetExtendedListViewStyle($Events_ListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES,$LVS_EX_INFOTIP))
	_GUICtrlListView_SetBkColor($Events_ListView, $CLR_CREAM)
	_GUICtrlListView_SetTextBkColor($Events_ListView, $CLR_CREAM)
;~     _GUICtrlListView_SetBkColor($Events_ListView, $COLOR_SILVER)
;~     _GUICtrlListView_SetTextColor($Events_ListView, $COLOR_BlACK)
;~     _GUICtrlListView_SetTextBkColor($Events_ListView, $COLOR_SILVER)
	_GUICtrlListView_InsertColumn($Events_ListView, 0, "От кого", 110)
	_GUICtrlListView_InsertColumn($Events_ListView, 1, "Событие", 390)
	_GUICtrlListView_InsertColumn($Events_ListView, 2, "id_Event", 0)
	$Read_Button=GUICtrlCreateButton("Прочитано",90, 247,150,25)
	GUICtrlSetOnEvent($Read_Button, "IsRead")
	GUICtrlSetFont ($Read_Button, 14,600)

;~ 	CheckEvents()

	GUISetState(@SW_HIDE, $Form_Events)
	;############ Конец Инициализация Формы Events #########################


	;############ Инициализация Формы Calend #########################
	$Form_Calend = GUICreate("Календарь", 180, 200,-1,-1,$WS_EX_TOPMOST+$DS_MODALFRAME)
	$Date_Calend = GUICtrlCreateMonthCal(_NowDate(), 2, 2, 170, 170)
	GUICtrlSetOnEvent($Date_Calend, "ClickCalend")
	GUISetState(@SW_HIDE, $Form_Calend)
	;############ Конец Инициализация Формы Calend #########################


	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_MOVE, 'WM_MOVE')
;~ 	DllCall('uxtheme.dll', 'uint', 'SetWindowTheme', 'hwnd', $GUI_Work, 'ptr', 0, 'wstr', '')

	LoadTasks()


	; Add items
;~ 	ConsoleWrite($GUI & @CR )
	$TimeUpdate=7000
	$TimeCheckUpdate=$TimeUpdate
	$TekTime=0
	$TekTimeCheckUpdate=0
;~ 	LoadTasks()
;~     $sTempFileScreen = _TempFile(@TempDir, 'Имя', '.jpg')
;~     _ScreenCapture_CaptureWnd($sTempFileScreen, $GUI, 0, 0, -1, -1, False)
;~     ShellExecute($sTempFileScreen,'', '', 'print', @SW_HIDE )
	While 1
		Sleep(1000)
		$TekTime=$TekTime+1000
		$TekTimeCheckUpdate=$TekTimeCheckUpdate+1000
		if $TekTime>=$TimeUpdate Then
			CheckEvents()
			if _GUICtrlListView_GetItemCount($Events_ListView) >0  then
;~ 				if $Form_Show then
					GUISetState(@SW_SHOW, $Form_Events)
					GUISetState(@SW_RESTORE, $Form_Events)
;~ 				EndIf
				TraySetState (4)
			EndIf
			while _GUICtrlListView_GetItemCount($Events_ListView) >0
				Sleep(1000)
;~ 				if Not WinActive("Новые события") then
;~ 					WinActivate ("Новые события")
;~ 				EndIf
			WEnd


			$TekTime=0
		EndIf
		if $TekTimeCheckUpdate>$TimeCheckUpdate Then
			CheckUpdate()
			$TekTimeCheckUpdate=0
		EndIf
	WEnd


EndFunc   ;==>_Main

Func FuncLike()
;~ 	LoadTasks()
EndFunc

Func FormatText($TaskTextEdit)
	$TaskTextEdit=StringReplace($TaskTextEdit,@CR,"")
	$TaskTextEdit=StringReplace($TaskTextEdit,@CRLF,"")
	$TaskTextEdit=StringReplace($TaskTextEdit,Chr(0),"")
	$TaskTextEdit=StringReplace($TaskTextEdit,Chr(10),"")
	$TaskTextEdit=StringReplace($TaskTextEdit,"\","/")
	$TaskTextEdit=StringReplace($TaskTextEdit,chr(34),chr(34)&chr(34))
	$TaskTextEdit=StringReplace($TaskTextEdit,chr(34),chr(34)&chr(34))
;~ 	$TaskTextEdit=StringReplace($TaskTextEdit,""","'")
	$TaskTextEdit=StringStripWS($TaskTextEdit, 7)
	$TaskTextEdit=StringStripCR ($TaskTextEdit)
	$TaskTextEdit=$TaskTextEdit &" "
;~ 	For $i=0 to StringLen($TaskTextEdit)
;~ 		$chr=Stringmid($TaskTextEdit,$i,1)
;~ 		if $chr="" then
;~ 			ConsoleWrite($chr & "-" & Asc($chr) & @CRLF)
;~ 		EndIf
;~ 	Next
	Return $TaskTextEdit
EndFunc
Func SendEvents()
	$Event_Text = InputBox("Question", "Сообщение всем", "", "",300, 200)
	if $Event_Text <> "" Then
		For $id=0 to $KolVoWorkers-1
			if $Array_Workers[$id][0]<>2 Then
				AddEvents($Event_Text,2,$Array_Workers[$id][0],"NULL")
			EndIf
		Next
	EndIf
EndFunc
Func ClickCalend()
;~ 	ConsoleWrite(GUICtrlRead($Date_Calend) & @CRLF)
;~ 	$Date_Time=_DateTimeFormat(GUICtrlRead($Date_Calend), 2)
	$Date_Time=GUICtrlRead($Date_Calend)
	$Date_Time=StringReplace($Date_Time,"/","-")
;~ 	$Date_Time=$Date_Time & " " & _NowTime()
	$Date_Time=$Date_Time & " 09:00:00"
	_GUICtrlComboBox_SetEditText($Remind_Combo, $Date_Time)
	GUISetState(@SW_HIDE, $Form_Calend)
EndFunc
Func FuncCalend()
	Local $aGUI_Pos = WinGetPos($GUI)
	WinMove($Form_Calend, "", $aGUI_Pos[0]+200, $aGUI_Pos[1]+400,180,200)
	GUISetState(@SW_SHOW, $Form_Calend)
EndFunc
Func FuncRemind()
	$TypeProcess="Remind"
	AddTask()
EndFunc
Func NewCourseCheck()
	LoadTasks()
EndFunc
Func EventOtbor()
	LoadTasks()
EndFunc
Func TurnUpdate()
	if $TekRazmerpachki = 53 then
		$TekRazmerpachki=500
		GUICtrlSetTip ($Button_Turn, "Раскукожить")
		GUICtrlSetData ( $Button_Turn, "<>")
	Else
		$TekRazmerpachki=53
		GUICtrlSetTip ($Button_Turn, "Скукожить")
		GUICtrlSetData ( $Button_Turn, "><")
	EndIf
	LoadTasks(True,"")
EndFunc
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
	LoadTasks(True)
EndFunc

Func CheckEvents()
	_GUICtrlListView_DeleteAllItems($Events_ListView)
;~ 	################ MySQL
	$SQLOpen=_MySQLConnect($sUsername, $sPassword, $sDatabase, $sServer)
;~ 	$TextQuery="SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	"
	$id_Worker=(_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1)
	$TekTime=_NowCalc()
	$TekTime = Chr(34) & StringReplace($TekTime, "/", "-") & Chr(34)
	$TextQuery="SELECT Events.id_Event,Workers.Name,Events.ToWhom,Events.Description FROM Events LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Workers ON Workers.id_Worker=Events.ToFrom WHERE    Events.isRead=0    AND Events.ToWhom=" & $id_Worker  & " AND Events.date<=" & $TekTime
;~ 	ConsoleWrite($TextQuery)
	$Result=_Query($SQLOpen, $TextQuery)

	if $Result <> 0 then
		$CurRow=0
		With $Result
			While NOT .EOF
				$Text_Event=.Fields("Description").value
				$RazmerPachki=65
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
EndFunc


Func AddEvents($Event_Text,$ToFrom,$ToWhom,$IDTask,$TimeEvent="")
;~ 	ConsoleWrite($TimeEvent & @CRLF)
	if $TimeEvent <> "" then
		$TekTime=Chr(34) & $TimeEvent & Chr(34)
	Else
		$TekTime=_NowCalc()
		$TekTime = Chr(34) & StringReplace($TekTime, "/", "-") & Chr(34)
	EndIf
	$MailTo=""
;~ 	ConsoleWrite($Event_Text & @CRLF)
	if $ToFrom=$ToWhom and $TimeEvent="" Then
		$TextQuery="Insert into Events values (NULL,"& $ToFrom &","& $ToWhom &","& $TekTime &","&Chr(34) & $Event_Text &chr(34)&",1,1," & $IDTask &")"
	Else
		$TextQuery="Insert into Events values (NULL,"& $ToFrom &","& $ToWhom &","& $TekTime &","&Chr(34) & $Event_Text &chr(34)&",0,1," & $IDTask &")"
	EndIf
;~ 	MsgBox(-1,"",$TextQuery)
;~ 	ConsoleWrite($TextQuery & @CRLF)
	ExecuteQuery($TextQuery)
EndFunc
Func Minimize()
;~ 	ConsoleWrite("test")
	GUISetState(@SW_HIDE, $GUI)
	if _GUICtrlListView_GetItemCount($Events_ListView) >0  then
		GUISetState(@SW_HIDE, $Form_Events)
	EndIf
	$Form_Show=False
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
	if _GUICtrlListView_GetItemCount($Events_ListView) >0  then
		GUISetState(@SW_SHOW, $Form_Events)
		GUISetState(@SW_RESTORE, $Form_Events)
	EndIf
	if $CurseOpen then
		GUISetState(@SW_SHOW, $GUI_Work)
		GUISetState(@SW_RESTORE,$GUI_Work)
	EndIf
	if $AddTaskOpen then
		GUISetState(@SW_SHOW, $Form_AddTask)
		GUISetState(@SW_RESTORE,$Form_AddTask)
	EndIf
	$Form_Show=True
EndFunc
Func FuncUpdate()
 	LoadTasks(True)
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
		$id_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 4)
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
	;~ 	############ MySQL
	_GUICtrlListView_DeleteAllItems($hListView_WorkCourse)
	$CurRow=0
	$SQLOpen=_MySQLConnect($sUsername, $sPassword, $sDatabase, $sServer)
	$TextQuery="SELECT * FROM Workers"
	$Result=_Query($SQLOpen, $TextQuery)
	With $Result
		While NOT .EOF
			ReDim $Array_Workers[$CurRow+1][2]
			$Array_Workers[$CurRow][0]=.Fields("id_Worker").value
			$Array_Workers[$CurRow][1]=.Fields("Name").value
			$CurRow=$CurRow+1
			.MoveNext
		WEnd
	EndWith
	_MySQLEnd($SQLOpen)
	Return $CurRow
EndFunc

Func LoadTasks($SetFocus=False,$Column="")
	$id_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 4)

;~ 	############ MySQL
;~ 	_GUICtrlListView_SetSelectionMark($hListView, $CurrentRow)

;~ 	$CurSelected=_GUICtrlListView_GetItemFocused ($hListView,1)
;~ 	ConsoleWrite($CurrentRow & "-" & $SetFocus & @CRLF)
	_GUICtrlListView_DeleteAllItems($hListView)
	$SQLOpen=_MySQLConnect($sUsername, $sPassword, $sDatabase, $sServer)
	if $SQLOpen <>0 then
		$TextIf=" WHERE"
		if GUICtrlRead ($Worker_Combo_Otbor)<>"Все" Then
			$TextIf=$TextIf & " Tasks.id_Worker=" & (_GUICtrlComboBox_FindString($Worker_Combo, GUICtrlRead ($Worker_Combo_Otbor))+1) & " AND "
		EndIf
		if GUICtrlRead ($TaskComplete_Checkbox)=1 Then
			$TextIf=$TextIf & " Tasks.status<>" & Chr(34) &"выполнена"&Chr(34)  & " AND" & " Tasks.status<>" & Chr(34) &"отменена"&Chr(34)  & " AND"
		EndIf
		$TextFind=GUICtrlRead ($Edit_Like)
		if $TextFind<>"" Then
			$TextIf=$TextIf & " Tasks.Name  LIKE " & Chr(34) &"%"& $TextFind &"%"&Chr(34)  & " AND"
		EndIf
;~ 		AND Tasks.Name LIKE "%онсо%"
		if $TextIf=" WHERE" Then
			$TextIf=""
		Else
			$TextIf=StringLeft($TextIf,StringLen($TextIf)-4)
		EndIf
		$NewCourse_LeftJoin=""
		if GUICtrlRead ($NewCourse_Checkbox)=1 Then
			$TekTime=_NowCalc()
			$TekTime = Chr(34) & StringLeft(StringReplace($TekTime, "/", "-"),10) & " 00:00:00" & Chr(34)
;~ 			$NewCourse_LeftJoin=" LEFT JOIN (SELECT DISTINCT WorkCourse.id_Task,WorkCourse.Date FROM WorkCourse WHERE WorkCourse.Date>"& $TekTime &") WorkCourse ON WorkCourse.id_Task=Tasks.id_Task "
			$NewCourse_LeftJoin="LEFT JOIN (SELECT DISTINCT Events.id_Task FROM Events WHERE Events.Date > "& $TekTime &" AND Events.id_Task is not NULL)Events ON Events.id_Task = Tasks.id_Task"
			if $TextIf="" then
				$TextIf=" WHERE (Tasks.Date > "& $TekTime &" OR Events.id_Task IS NOT NULL) "
			Else
				$TextIf=$TextIf &  " AND (Tasks.Date > "& $TekTime &" OR Events.id_Task IS NOT NULL)"
			EndIf
		EndIf

		$TextOrder=" ORDER BY 1"
		If $Column<>"" Then
;~ 			$Arraytest=_GUICtrlListView_GetColumn($hListView, $Column)
			$Desc=Not $Desc
			if $Desc then
				$TextOrder=" ORDER BY " & $Column+1 & " DESC"
			Else
				$TextOrder=" ORDER BY " & $Column+1 & " ASC"
			EndIf
;~ 			_ArrayDisplay($Arraytest)
		EndIf
		$TextQuery="SELECT DISTINCT Tasks.Date,Tasks.status AS Status,Tasks.Name,Workers.Name AS Worker,Tasks.id_Task,Tasks.id_Worker,Tasks.id_Chief,Chief.Name AS Chief FROM Tasks LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Workers ON Workers.id_Worker=Tasks.id_Worker LEFT JOIN (SELECT Workers.id_Worker,Workers.Name FROM Workers) Chief ON Chief.id_Worker=Tasks.id_Chief " & $NewCourse_LeftJoin & $TextIf & $TextOrder
		ConsoleWrite($TextQuery & @CRLF)
;~ 		Exit
		$Result=_Query($SQLOpen, $TextQuery)
		$CurRow=0
		With $Result
			While NOT .EOF
;~ 				ConsoleWrite(.Fields("Name").value)
				$Date=.Fields("Date").value
				$gg=StringMid($Date,3,2)
				$mm=StringMid($Date,5,2)
				$dd=StringMid($Date,7,2)
				$IndexImage=1
				$Status =StringLeft(.Fields("Status").value,30)
;~ 				ConsoleWrite($Status & @CRLF)
				if $Status ="важно" then
					$IndexImage=0
				EndIf
;~ 				_GUICtrlListView_AddItem($hListView, $dd &"."& $mm &"."& $gg,$IndexImage)
;~ 				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Status").value, 1)
;~ 				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Name").value, 2)
;~ 				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Worker").value, 3)
;~ 				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("id_Task").value, 4)
;~ 				$CurRow=$CurRow+1
				$Text_Course=.Fields("Name").value
	;~ 			ConsoleWrite($Text_Course & @CRLF)
				$RazmerPachki=$TekRazmerpachki
;~ 				$RazmerPachki=500
				$Current_Razmer=StringLen($Text_Course)
				if StringLen($Text_Course) > $RazmerPachki then
					$Text_Row=StringLeft($Text_Course,$RazmerPachki-1)
					$Current_Razmer=$RazmerPachki
				Else
					$Text_Row=$Text_Course
				EndIf
	;~ 			ConsoleWrite($Text_Row & @CRLF)
				_GUICtrlListView_AddItem($hListView, $dd &"."& $mm &"."& $gg,$IndexImage)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Status").value,1)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, $Text_Row,2)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Worker").value,3)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("id_Task").value, 4)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, $Text_Course, 5)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Status").value, 6)
				_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Worker").value, 7)
				$CurRow=$CurRow+1
				$CountCourse=$CountCourse+1
				While $Current_Razmer <StringLen($Text_Course)
					$Text_Row=StringMid($Text_Course,$Current_Razmer,$RazmerPachki)
					_GUICtrlListView_AddItem($hListView, "",1)
					_GUICtrlListView_AddSubItem($hListView, $CurRow, "",1)
					_GUICtrlListView_AddSubItem($hListView, $CurRow, $Text_Row,2)
					_GUICtrlListView_AddSubItem($hListView, $CurRow, "",3)
					_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("id_Task").value,4)
					_GUICtrlListView_AddSubItem($hListView, $CurRow, $Text_Course, 5)
					_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Status").value, 6)
					_GUICtrlListView_AddSubItem($hListView, $CurRow, .Fields("Worker").value, 7)
					$Current_Razmer=$Current_Razmer+$RazmerPachki
					$CurRow=$CurRow+1
				WEnd
				.MoveNext
			WEnd
		EndWith
		_MySQLEnd($SQLOpen)

;~ 		Получим текущую строку
		$CurrentRow=0
		$find_id_Task=false
		if Not $SetFocus then
			$id_Task=""
		Else
			For $id_hListView = 0 to $CurRow
				if _GUICtrlListView_GetItemText($hListView,$id_hListView, 4) = $id_Task Then
;~ 					ConsoleWrite("" & _GUICtrlListView_GetItemText($hListView,$id_hListView, 4) & "-" & $id_Task & @CRLF)
					$CurrentRow=$id_hListView
					$find_id_Task=True
					ExitLoop
				EndIf
			Next
		EndIf
		if Not $find_id_Task Then
			$id_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 4)
		EndIf
		$CurrentIDTask=$id_Task
		if $id_Task <> "" then
			_GUICtrlListView_DeleteAllItems($hListView_WorkCourse)
			LoadWorkCourse($id_Task)
;~ 			ConsoleWrite("CurRow-"& $CurrentRow &" $id_Task-" & $id_Task & "Worker-" & (_GUICtrlComboBox_FindString($Worker_Combo, GUICtrlRead ($Worker_Combo_Otbor))+1) & @CRLF)
		Else
			_GUICtrlListView_DeleteAllItems($hListView_WorkCourse)
		EndIf
		_GUICtrlListView_SetItemSelected($hListView, $CurrentRow,True,True)
		_GUICtrlListView_Scroll($hListView, -1, $CurrentRow*11)
;~ 		$TekTask=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2)
;~ 		GUICtrlSetData ( $CurrentTask_Label,$TekTask)
;~ 		_GUICtrlListView_SetItemFocused ($hListView, $CurrentRow)
	EndIf
EndFunc
Func AddTask($OnlyUpdate=False)
;~ 	_GUICtrlListView_DeleteAllItems($hListView)
	if $CurrentIDTask =0 or $CurrentIDTask = "" AND $TypeProcess<>"Add" then
;~ 		_DrawText('Укажить строку задач', 80, 'Verdana', 0x000000, 3000)
;~ 		GUICtrlSetData ( $CurrentTask_Label, "Укажите строку задач")
;~ 		MsgBox(-1,"","Укажить строку задач")
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
				GUISetState(@SW_RESTORE, $Form_AddTask)
;~ 				WinActive (_WinAPI_GetWindowText($Form_AddTask))
;~ 				ConsoleWrite(WinActive (_WinAPI_GetWindowText($Form_AddTask)))


;~ 				_WinAPI_ShowWindow($Form_AddTask,@SW_SHOW)
			EndIf
			$AddTaskOpen=Not $AddTaskOpen
		Else
			GUISetCursor (-1,-1,$Form_AddTask)
			GUISetState(@SW_SHOW, $Form_AddTask)
			GUISetState(@SW_RESTORE, $Form_AddTask)
	;~ 		$AddTaskOpen=Not $AddTaskOpen
		EndIf
	EndIf
;~ 	GUICtrlSetPos ($Add_Button, 300, 45,141,20)
;~ 	GUICtrlSetState ( $TaskNew_Edit, $GUI_SHOW )
;~ 	ConsoleWrite("AddTask $CurseOpen- "&$CurseOpen&" $AddTaskOpen- "& $AddTaskOpen & " $TypeProcess -" & $TypeProcess&@CRLF)
	GUICtrlSetState($Button_Calend, $GUI_HIDE)
	GUICtrlSetState($Remind_Combo, $GUI_HIDE)
;~ $Button_Calend
;~ 	_WinAPI_ShowWindow($Button_Calend , @SW_HIDE)
;~ 	_WinAPI_ShowWindow($Remind_Combo , @SW_HIDE)
	_WinAPI_ShowWindow($Label_Status , @SW_SHOW)
	_WinAPI_ShowWindow($Label_Who , @SW_SHOW)
	_WinAPI_ShowWindow($Status_Combo , @SW_SHOW)
	_WinAPI_ShowWindow($Worker_Combo , @SW_SHOW)
;~ 	_WinAPI_ShowWindow($Worker_Combo , @SW_HIDE)
	_WinAPI_EnableWindow($Status_Combo , True)
	_WinAPI_EnableWindow($Worker_Combo , True)
	_WinAPI_EnableWindow($TaskNew_Edit , True)
	_WinAPI_SetWindowPos($TaskNew_Edit, $HWND_BOTTOM , 2, 2, $Width_Form-5, 60,$SWP_NOACTIVATE )
	if $TypeProcess= "Add" then
		_WinAPI_SetWindowText($Form_AddTask, "Добавить задачу")
		_GUICtrlButton_SetText($Add_Button, "Добавить")
		_GUICtrlEdit_SetText($TaskNew_Edit,"")
		_GUICtrlComboBox_SetCurSel($Status_Combo,0)
		if GUICtrlRead ($Worker_Combo_Otbor) <> "Все" And GUICtrlRead ($Worker_Combo_Otbor) <> $CurrentUser Then
			_GUICtrlComboBox_SetCurSel($Worker_Combo,_GUICtrlComboBox_FindString($Worker_Combo, GUICtrlRead ($Worker_Combo_Otbor)))
		Else
			_GUICtrlComboBox_SetCurSel($Worker_Combo,_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser))
		EndIf

	ElseIf $TypeProcess= "Edit" Then
		$Text_Task=""
		$Text_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 5)
		$Worker=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 7)
		_GUICtrlComboBox_SetCurSel($Worker_Combo, _GUICtrlComboBox_FindString($Worker_Combo, $Worker))
		_GUICtrlButton_SetText($Add_Button, "Изменить")
		_WinAPI_SetWindowText($Form_AddTask, "Изменить задачу   ")
		_GUICtrlEdit_SetText($TaskNew_Edit,$Text_Task)
		$Status=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 6)
		_GUICtrlComboBox_SetCurSel($Status_Combo,_GUICtrlComboBox_FindString($Status_Combo, $Status))
	ElseIf $TypeProcess= "Answer" Then
		_WinAPI_EnableWindow($Status_Combo , False)
		_WinAPI_EnableWindow($Worker_Combo , False)
;~ 		_WinAPI_SetWindowPos($TaskNew_Edit, $HWND_BOTTOM , 2, 2, $Width_Form-200, 60,$SWP_NOACTIVATE )

		if Not $AddTaskOpen And $CurseOpen then
;~ 			$CurseOpen=False
		EndIf
 		if  $CurseOpen then
			LoadWorkCourse($CurrentIDTask)
		Else
			OpenCurse()
 		EndIf


		$Text_Task=""
		$Text_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 5)
		_WinAPI_SetWindowText($Form_AddTask, "Ответить на задачу - "  & $Text_Task)
		_GUICtrlButton_SetText($Add_Button, "Ответить")
		_GUICtrlEdit_SetText($TaskNew_Edit,"")
		$Status=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 6)
		_GUICtrlComboBox_SetCurSel($Status_Combo,_GUICtrlComboBox_FindString($Status_Combo, $Status))
		_GUICtrlComboBox_SetCurSel($Worker_Combo, _GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser))
	Elseif $TypeProcess= "Del" then
		_WinAPI_EnableWindow($Status_Combo , False)
		_WinAPI_EnableWindow($Worker_Combo , False)
		_WinAPI_EnableWindow($TaskNew_Edit , False)

		$Text_Task=""
		$Text_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 5)
		_WinAPI_SetWindowText($Form_AddTask, "Удалить задачу - "& $Text_Task)
		_GUICtrlButton_SetText($Add_Button, "Удалить")
		_GUICtrlEdit_SetText($TaskNew_Edit,$Text_Task)
		$Status=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 6)
		_GUICtrlComboBox_SetCurSel($Status_Combo,_GUICtrlComboBox_FindString($Status_Combo, $Status))
		$Worker=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 7)
		_GUICtrlComboBox_SetCurSel($Worker_Combo, _GUICtrlComboBox_FindString($Worker_Combo, $Worker))

;~ 		GUICtrlSetPos ($Add_Button, 1, 1,449,66)
;~ 		GUICtrlSetState ( $Add_Button, $GUI_FOCUS )
;~ 		GUICtrlSetState ( $TaskNew_Edit, $GUI_HIDE )
	ElseIf $TypeProcess= "Remind" Then
		_GUICtrlComboBox_SetCurSel($Remind_Combo, 3)
		GUICtrlSetState($Button_Calend, $GUI_SHOW)
		GUICtrlSetState($Remind_Combo, $GUI_SHOW)
;~ 		_WinAPI_ShowWindow($Remind_Combo , @SW_SHOW)
		_WinAPI_ShowWindow($Status_Combo , @SW_HIDE)
		_WinAPI_ShowWindow($Worker_Combo , @SW_HIDE)
	;~ 	_WinAPI_ShowWindow($Worker_Combo , @SW_HIDE)
		_WinAPI_EnableWindow($Status_Combo , True)
		_WinAPI_EnableWindow($Worker_Combo , True)
		_WinAPI_EnableWindow($TaskNew_Edit , True)
		$Text_Task=""
		$Text_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 5)
		_WinAPI_SetWindowText($Form_AddTask, "Напомнить о задаче - "  & $Text_Task)
		_GUICtrlEdit_SetText($TaskNew_Edit,$Text_Task)
		_GUICtrlButton_SetText($Add_Button, "Напомнить")
	EndIf
	$CurTypeProcess=$TypeProcess

	$Last_Worker=_GUICtrlComboBox_GetCurSel($Worker_Combo)+1
	$Last_Status=_GUICtrlComboBox_GetEditText($Status_Combo)
	$Last_Name=_GUICtrlEdit_GetText($TaskNew_Edit)
;~ 	ConsoleWrite($AddTaskOpen)

;~ 	$Form_AddTask = GUICreate("Добавить задачу", 455, 100,$aGUI_Pos[0],$aGUI_Pos[1]+310,$WS_OVERLAPPED)

;~ 	_SQLite_Startup()
;~ 	_SQLite_Open($sDatabase_Filename)
;~ 	$TxtQuery="Insert into Tasks values (NULL,'Задача №1','Сделать трататаата','2','1','01.01.2011')"
;~ 	_SQlite_Query (-1, "SELECT Tasks.id_Task,Tasks.Name,Tasks.Description,Tasks.id_Worker,Tasks.id_Chief,Workers.Name AS Worker,Chief.Name AS Chief,Tasks.Date,CASE WHEN Tasks.id_status  = 0  THEN 'не начата'    WHEN Tasks.id_status  = 1  THEN 'начата'    WHEN Tasks.id_status  = 5  THEN 'завершена'  END Status FROM Tasks LEFT JOIN (SELECT Workers.id_Worker,Workers.Name,Posts.Name AS Post FROM Workers LEFT JOIN (SELECT Posts.id_Post, Posts.Name FROM Posts) Posts ON Posts.id_Post=Workers.id_Post) Workers ON Workers.id_Worker=Tasks.id_Worker LEFT JOIN (SELECT Workers.id_Worker,Workers.Name,Posts.Name AS Post FROM Workers     LEFT JOIN (SELECT Posts.id_Post, Posts.Name FROM Posts WHERE Posts.id_Post=1) Posts ON Posts.id_Post=Workers.id_Post) Chief ON Chief.id_Worker=Tasks.id_Chief", $hQuery)
;~ 	_SQLite_Close()
;~ 	_SQLite_Shutdown()
EndFunc

Func ExecuteQuery($TextQuery)
	;~ 	############ MySQL
;~ 	ConsoleWrite($TextQuery & @CRLF)
;~ 	Return True

	$SQLOpen=_MySQLConnect($sUsername, $sPassword, $sDatabase, $sServer)
;~ 	$TextQuery="SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	"
	$Result=_Query($SQLOpen, $TextQuery)
	_MySQLEnd($SQLOpen)
	if $Result = 0 then
		Return False
	Else

	EndIf
	Return True
	;~ 	############ MySQL
;~ 	старое
;~  	_SQLite_Startup()
;~   	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
;~ ~ 	$TxtQuery="Insert into Tasks values (NULL,'Задача №1','Сделать трататаата','2','1','01.01.2011')"
;~ 	$TextQuery="SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	"
;~ 	$SQLOpen=SQL_Open()
;~ 	if  $SQLOpen then
;~ 		$Result=SQLQueryOk($TextQuery,$hQuery)
;~ 		if $Result = $SQLITE_OK then
;~ 	;~ 		_SQlite_Query ($SQL_TaskDB, $TextQuery, $hQuery)
;~ 			_SQLite_FetchNames ($hQuery, $aNames)
;~ 			$CurRow=0
;~ 			While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
;~ 				$CurRow=$CurRow+1
;~ 			WEnd
;~ 		EndIf
;~ 		SQL_Close()
;~ 	EndIf
;~  	_SQLite_Shutdown()
EndFunc

Func LoadWorkCourse($idTask)
	_GUICtrlListView_DeleteAllItems($hListView_WorkCourse)
	;~ 	############ MySQL
	$CurRow=0
	$SQLOpen=_MySQLConnect($sUsername, $sPassword, $sDatabase, $sServer)
	$TextQuery="SELECT WorkCourse.date,WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	"
	$Result=_Query($SQLOpen, $TextQuery)
;~ 	ConsoleWrite($TextQuery & @CRLF)
	$CurRow=0
	$CountCourse=0
	With $Result
		While NOT .EOF
			$Text_Course=.Fields("Description").value
;~ 			ConsoleWrite($Text_Course & @CRLF)
			$RazmerPachki=42
			$Current_Razmer=StringLen($Text_Course)
			if StringLen($Text_Course) > $RazmerPachki then
				$Text_Row=StringLeft($Text_Course,$RazmerPachki-1)
				$Current_Razmer=$RazmerPachki
			Else
				$Text_Row=$Text_Course
			EndIf
;~ 			ConsoleWrite($Text_Row & @CRLF)
			$Date=.Fields("date").value
			$gg=StringLeft($Date,4)
			$mm=StringMid($Date,5,2)
			$dd=StringMid($Date,7,2)
			_GUICtrlListView_AddItem($hListView_WorkCourse, $dd &"."& $mm &"."& $gg)
;~ 			_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, .Fields("LineNumber").value,1)
			_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $Text_Row,1)
			_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, .Fields("Author").value,2)
			$CurRow=$CurRow+1
			$CountCourse=$CountCourse+1
			While $Current_Razmer <StringLen($Text_Course)
				$Text_Row=StringMid($Text_Course,$Current_Razmer,$RazmerPachki)
				_GUICtrlListView_AddItem($hListView_WorkCourse, "")
;~ 				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, "",1)
				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $Text_Row,1)
				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, "",2)
				$Current_Razmer=$Current_Razmer+$RazmerPachki
				$CurRow=$CurRow+1
			WEnd
			.MoveNext
		WEnd
	EndWith
	_MySQLEnd($SQLOpen)
;~ 	Return $CurRow
	;~ 	############ MySQL

;~ 	_SQLite_Startup()
;~ 	$SQL_TaskDB=_SQLite_Open($sDatabase_Filename)
;~ 	_SQlite_Query (-1, "SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	", $hQuery)
;~ 	$SQLOpen=SQL_Open()
;~ 	if  $SQLOpen then
;~ 		$TextQuery="SELECT WorkCourse.LineNumber,WorkCourse.Description,Workers .Name as Author FROM WorkCourse LEFT JOIN (SELECT Workers.id_Worker,Workers.Name  FROM Workers) Workers ON Workers.id_Worker=WorkCourse.id_Worker WHERE id_Task =  " & $idTask &" ORDER BY LineNumber	"
;~ 		$Result=SQLQueryOk($TextQuery,$hQuery)
;~ 		if $Result = $SQLITE_OK then
;~ 			_SQLite_FetchNames ($hQuery, $aNames)
;~ 			$CurRow=0
;~ 			$CountCourse=0
;~ 			While _SQLite_FetchData ($hQuery, $aRow, False, False) = $SQLITE_OK ; Read Out the next Row
;~ 				$Text_Course=$aRow[1]
;~ 				ConsoleWrite($Text_Event & @CRLF)
;~ 				$RazmerPachki=42
;~ 				$Current_Razmer=StringLen($Text_Course)
;~ 				if StringLen($Text_Course) > $RazmerPachki then
;~ 					$Text_Row=StringLeft($Text_Course,$RazmerPachki-1)
;~ 					$Current_Razmer=$RazmerPachki
;~ 				Else
;~ 					$Text_Row=$Text_Course
;~ 				EndIf
;~ 				_GUICtrlListView_AddItem($hListView_WorkCourse, $aRow[0])
;~ 				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $Text_Row,1)
;~ 				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $aRow[2],2)
;~ 				$CurRow=$CurRow+1
;~ 				$CountCourse=$CountCourse+1
;~ 				While $Current_Razmer <StringLen($Text_Course)
;~ 					$Text_Row=StringMid($Text_Course,$Current_Razmer,$RazmerPachki)
;~ 					_GUICtrlListView_AddItem($hListView_WorkCourse, "")
;~ 					_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $Text_Row,1)
;~ 					_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, "",2)
;~ 					$Current_Razmer=$Current_Razmer+$RazmerPachki
;~ 					$CurRow=$CurRow+1
;~ 				WEnd
;~ 				_GUICtrlListView_AddItem($hListView_WorkCourse, $aRow[0])
;~ 				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $aRow[1],1)
;~ 				_GUICtrlListView_AddSubItem($hListView_WorkCourse, $CurRow, $aRow[2],2)
;~ 				$CurRow=$CurRow+1
;~ 			WEnd
;~ 		EndIf
;~ 		SQL_Close()
;~ 	EndIf
;~ 	_SQLite_Shutdown()
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
;~ 					If _GUICtrlButton_GetText($hCtrl)="<- Ход работы" then
;~ 					If _GUICtrlButton_GetText($hCtrl)="<- Ход работы" then
					OpenCurse()
;~ 					EndIf
;~ 					If _GUICtrlButton_GetText($hCtrl)="Добавить задачу" then

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
;~ 					$TekTime =_NowDate()
					$TekTime=_NowCalc()
;~ 					ConsoleWrite($TekTime)
					$TekTime = Chr(34) & StringReplace($TekTime, "/", "-") & Chr(34)
;~ 					2011-10-01 00:00:00
					$Event_Text=""
					$TextQueryInProccess=""
					$id_Worker=(_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1)
					$new_id_Worker=(_GUICtrlComboBox_GetCurSel($Worker_Combo)+1)
					$NewStatus=_GUICtrlComboBox_GetEditText($Status_Combo)
;~ 					if $CurrentIDTask <>0 then
;~ 					ConsoleWrite("TypeProcess-" & $TypeProcess & " $id_Worker-" & $id_Worker & " $new_id_Worker-" & $new_id_Worker & " $id_Chief-" &$id_Chief  &@CR)
;~ 					ConsoleWrite("ЭтоНачальник?-"&((_GUICtrlComboBox_FindString($Worker_Combo, $CurrentUser)+1)=1) & @CR)
;~ 					ConsoleWrite("ЭтоНачальник?-"& (1=1) & @CR)
;~ 					ConsoleWrite(_GUICtrlComboBox_GetEditText($Status_Combo))
					$TaskTextEdit=_GUICtrlEdit_GetText($TaskNew_Edit)
					$TaskTextEdit=FormatText($TaskTextEdit)

;~ 					$TaskTextEdit=StringReplace($TaskTextEdit,@CR,"")
;~ 					$TaskTextEdit=StringReplace($TaskTextEdit,@CRLF,"")
;~ 					$TaskTextEdit=StringReplace($TaskTextEdit,chr(34),"")
;~ 					$TaskTextEdit=StringStripWS($TaskTextEdit, 7)
;~ 					$TaskTextEdit=StringStripCR ($TaskTextEdit)



;~ 					ConsoleWrite($TaskTextEdit)
;~ 					Exit
					if StringLen($TaskTextEdit) >0 then
						if $TypeProcess="Add" then
							$TextQuery="Insert into Tasks values (NULL,"& Chr(34)& $TaskTextEdit & Chr(34)  &"," & $new_id_Worker &",1,"& $TekTime &","& Chr(34) &_GUICtrlComboBox_GetEditText($Status_Combo) &Chr(34)&")"
;~ 							ConsoleWrite($TextQuery)
							$Event_Text="Новая задача: " & $TaskTextEdit
							$RazmerPachki=65
							$Koef=Ceiling(StringLen($Event_Text)/$RazmerPachki)
							While StringLen($Event_Text)<$RazmerPachki*$Koef-1
								$Event_Text=$Event_Text &" "
							WEnd
							$Event_Text=$Event_Text & "Исполнитель: " &  _GUICtrlComboBox_GetEditText($Worker_Combo)
							$CurrentRow=_GUICtrlListView_GetItemCount($hListView)
;~ 							ConsoleWrite($CurrentRow)
;~ 							Exit
							if $id_Worker=$id_Chief then ; это начальник
								AddEvents($Event_Text,$id_Chief,$new_id_Worker,"NULL")
							Elseif $id_Worker=$new_id_Worker Then
;~ 								ConsoleWrite("mu tyt 1" & @CRLF)
;~ 								if $new_id_Worker <> $id_Chief then
									AddEvents($Event_Text,$id_Worker,$id_Chief,"NULL")
;~ 								endif
							Else
;~ 								ConsoleWrite("mu tyt 2"& @CRLF)
								AddEvents($Event_Text,$id_Worker,$new_id_Worker,"NULL")
								if $new_id_Worker <> $id_Chief then
									AddEvents($Event_Text,$id_Worker,$id_Chief,"NULL")
								EndIf
							EndIf
						elseif $TypeProcess="Edit" then
							$Text_Combo=_GUICtrlComboBox_GetEditText($Status_Combo)
;~ 							ConsoleWrite($Text_Combo & " - "& StringLen($Text_Combo) & @CRLF)
							$Text_Combo=StringRegExpReplace($Text_Combo,"[^а-я ]","")
;~ 							ConsoleWrite($Text_Combo & " - "& StringLen($Text_Combo) & @CRLF)
;~ 							For $i=0 to StringLen($Text_Combo)
;~ 								$chr=Stringmid($Text_Combo,$i,1)
;~ 								if $chr="" then
;~ 									ConsoleWrite($chr & "-" & Asc($chr) & @CRLF)
;~ 								EndIf
;~ 							Next



							if $Last_Status=$Text_Combo And _
							   $Last_Worker=$new_id_Worker And _
							   $Last_Name=$TaskTextEdit Then ;Изменений не произошло

							Else
								if ($id_Worker<>$id_Chief)  AND	($id_Worker <>$Last_Worker)  then
									MsgBox(-1,"","Изменять можно только свои задачи")
	;~ 								$TypeProcess="Edit"
									return 0
;~ 								Elseif (_GUICtrlComboBox_GetEditText($Status_Combo)="выполнена" or $Last_Status="выполнена") AND $id_Worker<>$id_Chief  then
;~ 									MsgBox(-1,"","Отметку о выполнении задачи может поставить только Начальник")
;~ 	;~ 								$TypeProcess="Edit"
;~ 									return 0
;~ 								Elseif (_GUICtrlComboBox_GetEditText($Status_Combo)="отменена") AND $id_Worker<>$id_Chief  then
;~ 									MsgBox(-1,"","Отменить задачу может только Начальник")
;~ 	;~ 								$TypeProcess="Edit"
;~ 									return 0
								Else
									$TextQuery="UPDATE Tasks  SET name=" &  Chr(34) & $TaskTextEdit & Chr(34) & ",id_worker="& (_GUICtrlComboBox_GetCurSel($Worker_Combo)+1) & ",status="& Chr(34) &$Text_Combo & Chr(34) &" WHERE Tasks.id_Task=" & $CurrentIDTask
			;~ 						$TypeProcess= "Edit"
									if $Last_Worker=$new_id_Worker then ; работник у задачи не изменился
										if $Last_Status <> $NewStatus then ;изменился статус у задачи
											$Event_Text="Статус изменен:"& $NewStatus &" задача: " & $TaskTextEdit
										Else
											$Event_Text="Изменена задача: " & $TaskTextEdit
										EndIf
										if $id_Worker=$id_Chief then ; это начальник изменил задачу
											AddEvents($Event_Text,$id_Chief,$new_id_Worker,$CurrentIDTask)

										Elseif $id_Worker=$new_id_Worker Then ; это исполнитель задачи изменил ее
											AddEvents($Event_Text,$id_Worker,$id_Chief,$CurrentIDTask)
										Else ; это не исполнитель и не начальник изменил задачу
	;~ 										AddEvents($Event_Text,$id_Worker,$new_id_Worker)
	;~ 										AddEvents($Event_Text,$id_Worker,$id_Chief)
										EndIf
									Else ;новый исполнитель у задачи
										if $id_Worker=$id_Chief then ; это начальник изменил исполнителя
											$Event_Text="Ваша задача: " & $TaskTextEdit & " передана другому"
											AddEvents($Event_Text,$id_Chief,$Last_Worker,$CurrentIDTask)
;~ 											if $id_Chief<>$new_id_Worker Then
												$Event_Text="Новая задача: " & $TaskTextEdit
												AddEvents($Event_Text,$id_Chief,$new_id_Worker,$CurrentIDTask)
;~ 											EndIf
										Elseif $id_Worker=$Last_Worker Then ; текущий владелец задачи изменил исполнителя
											$Event_Text="Задача: " & $TaskTextEdit & " передана другому"
											AddEvents($Event_Text,$Last_Worker,$id_Chief,$CurrentIDTask)
											$Event_Text="Новая задача: " & $TaskTextEdit
											AddEvents($Event_Text,$Last_Worker,$new_id_Worker,$CurrentIDTask)
										Else ; другой работник изменил исполнителя задачи
	;~ 										$Event_Text="Новая задача: " & $TaskTextEdit
	;~ 										AddEvents($Event_Text,$id_Worker,$new_id_Worker)
	;~ 										AddEvents($Event_Text,$id_Worker,$id_Chief)
										EndIf
									EndIf
								EndIf
							EndIf
						elseif $TypeProcess="Answer" then
							If $CountCourse=0 and $Last_Status <>"важно" then
								$TextQueryInProccess="UPDATE Tasks SET status="& Chr(34) & "в процессе" & Chr(34) &" WHERE Tasks.id_Task=" & $CurrentIDTask
;~ 								ConsoleWrite($TextQueryInProccess & @CRLF)
								ExecuteQuery($TextQueryInProccess)
							EndIf
							$TextQuery="Insert into WorkCourse values (NULL,"& $CurrentIDTask &","& ($CountCourse+1)&"," & $TekTime &","& Chr(34) & $TaskTextEdit & Chr(34) &"," & (_GUICtrlComboBox_GetCurSel($Worker_Combo)+1) &")"
;~ 							$Event_Text="Ход: " &  $TaskTextEdit & " для задачи: " &  _GUICtrlListView_GetItemText($hListView,$CurrentRow, 1)
							$Event_Text="Задача: " &  _GUICtrlListView_GetItemText($hListView,$CurrentRow, 5)
							$RazmerPachki=65
							$Koef=Ceiling(StringLen($Event_Text)/$RazmerPachki)
;~ 							ConsoleWrite($Koef)
							While StringLen($Event_Text)<$RazmerPachki*$Koef-1
								$Event_Text=$Event_Text &" "
							WEnd
							$Event_Text=$Event_Text & "Исполнитель: " &  _GUICtrlListView_GetItemText($hListView,$CurrentRow, 7)
							While StringLen($Event_Text)<$RazmerPachki*$Koef +$RazmerPachki-1
								$Event_Text=$Event_Text &" "
							WEnd
							$Event_Text=$Event_Text & "Новый ход: " &  $TaskTextEdit

;~ 							Exit
							$id_Ispolnitel=(_GUICtrlComboBox_FindString($Worker_Combo,_GUICtrlListView_GetItemText($hListView,$CurrentRow, 7))+1)
							if $id_Worker=$id_Chief then ; это начальник добавил новый ход
;~ 								if $id_Ispolnitel<>$id_Worker then
									AddEvents($Event_Text,$id_Chief,$id_Ispolnitel,$CurrentIDTask)
;~ 								EndIf
							Elseif $id_Worker=$id_Ispolnitel Then ; это исполнитель добавил новый ход
								AddEvents($Event_Text,$id_Worker,$id_Chief,$CurrentIDTask)
							Else ; это не исполнитель и не начальник добавил новый ход
								if $id_Ispolnitel <> $id_Chief then
									AddEvents($Event_Text,$id_Worker,$id_Ispolnitel,$CurrentIDTask)
								EndIf
								AddEvents($Event_Text,$id_Worker,$id_Chief,$CurrentIDTask)
							EndIf
							_GUICtrlEdit_SetText($TaskNew_Edit,"")
						elseif $TypeProcess="Ok" then
							$TextQuery="UPDATE Tasks  SET status='выполнена' WHERE Tasks.id_Task=" & $CurrentIDTask
						elseif $TypeProcess="Del" then
;~ 							$id_Ispolnitel=(_GUICtrlComboBox_FindString($Worker_Combo,_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2))+1)
							if $id_Worker<>$id_Chief then
								MsgBox(-1,"","Удалять задачу может только Начальник")
;~ 								$TypeProcess="Edit"
								return 0
							Else
								$TextQuery="DELETE FROM WorkCourse WHERE WorkCourse.id_Task=" & $CurrentIDTask
								ExecuteQuery($TextQuery)
								$TextQuery=""
								$TextQuery="DELETE FROM Tasks WHERE Tasks.id_Task=" & $CurrentIDTask & ";"
		;~ 						$TypeProcess= "Edit"
								$Event_Text="Удалена задача: " &  _GUICtrlListView_GetItemText($hListView,$CurrentRow, 2)
								if $id_Worker=$id_Chief  then ; это начальник удалил задачу
									AddEvents($Event_Text,$id_Chief,$new_id_Worker,$CurrentIDTask)
								EndIf
							EndIf
						elseif $TypeProcess="Remind" then
							$TextQuery=""
							$fl_DateIsOk=True
							$TextRemindCombo=GUICtrlRead ($Remind_Combo)
							$NewDate=GetTimeRemind($TextRemindCombo)
							if $NewDate <> "" Then
								$Event_Text="Напоминание от "& $NewDate
								$RazmerPachki=65
								$Koef=Ceiling(StringLen($Event_Text)/$RazmerPachki)
								While StringLen($Event_Text)<$RazmerPachki*$Koef-1
									$Event_Text=$Event_Text &" "
								WEnd
								$Event_Text=$Event_Text & $TaskTextEdit
								$id_Ispolnitel=(_GUICtrlComboBox_FindString($Worker_Combo,_GUICtrlListView_GetItemText($hListView,$CurrentRow, 7))+1)
								if $id_Ispolnitel <> $id_Worker then
									AddEvents($Event_Text,$id_Worker,$id_Ispolnitel,$CurrentIDTask,$NewDate)
								EndIf
								AddEvents($Event_Text,$id_Worker,$id_Worker,$CurrentIDTask,$NewDate)
								AddTask()
							EndIf
						EndIf
;~ 	 					ConsoleWrite($TextQuery & @CRLF)
;~ 						if $TextQueryInProccess<>"" then
;~ 							ExecuteQuery($TextQuery)
;~ 						EndIf

						if 	$TextQuery <> "" Then
							ExecuteQuery($TextQuery)
							If $TypeProcess="Del" AND $CurseOpen then
								OpenCurse()
							EndIf
							if $TypeProcess= "Answer" Then
								if $TextQueryInProccess<>"" then
									LoadTasks(True)
								EndIf
								LoadWorkCourse($CurrentIDTask)
							Else
								AddTask()
								LoadTasks(True)
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

Func GetTimeRemind($TextRemindCombo)
	$fl_DateIsOk=True
	If StringLeft($TextRemindCombo,5) = "Через" Then
;~ 		ConsoleWrite("tyt")
		$DateAdd=StringRegExpReplace($TextRemindCombo, "[^0-9]", "")
		$sType=""
		if StringInStr($TextRemindCombo,"мин")>0 then
			$sType="n"
		ElseIf StringInStr($TextRemindCombo,"час")>0 then
			$sType="h"
		ElseIf StringInStr($TextRemindCombo,"ден")>0 or StringInStr($TextRemindCombo,"дн")>0 then
			$sType="D"
		ElseIf StringInStr($TextRemindCombo,"недел")>0 then
			$sType="w"
		ElseIf StringInStr($TextRemindCombo,"месяц")>0 then
			$sType="M"
		EndIf
		$NewDate = _DateAdd($sType,$DateAdd, _NowCalc())
		$NewDate=StringReplace($NewDate,"/","-")
;~ 		ConsoleWrite($NewDate & " $sType-"& $sType & " $DateAdd-" & $DateAdd & @CRLF )
	Else
		if StringLen($TextRemindCombo)<>19 Then
			$fl_DateIsOk=False
		EndIf
		if StringLen(StringRegExpReplace($TextRemindCombo, "[0-9:-\s]", ""))>0 Then
			$fl_DateIsOk=False
		EndIf
		$id=1
		While $id <= StringLen($TextRemindCombo) and $fl_DateIsOk
			$Element=StringMid($TextRemindCombo,$id,1)
			if ($id=5 or $id=8) Then
				if $Element<>"-" Then
					$fl_DateIsOk=False
				EndIf
			ElseIf $id=14 or $id=17 Then
				if $Element<>":" Then
					$fl_DateIsOk=False
				EndIf
			ElseIf $id=11 or $id=17 Then
				if $Element<>" " Then
					$fl_DateIsOk=False
				EndIf
			Else
				if StringRegExp ($Element, "[0-9]",0)=0 Then
					$fl_DateIsOk=False
				EndIf
			EndIf
;~ 			ConsoleWrite("" & $Element & " ASC: " &  Asc($Element) & " ok-" & $fl_DateIsOk & @CRLF)
			$id=$id+1
		WEnd
;~ 		проверим правильно ли указаны даты
		if $fl_DateIsOk Then
			if StringLeft($TextRemindCombo,4)<2011 then
				$fl_DateIsOk=False
			EndIf
			if StringMid($TextRemindCombo,6,2)>12 then
				$fl_DateIsOk=False
			EndIf
			if StringMid($TextRemindCombo,9,2)>31 then
				$fl_DateIsOk=False
			EndIf
			if StringMid($TextRemindCombo,12,2)>23 then
				$fl_DateIsOk=False
			EndIf
			if StringMid($TextRemindCombo,15,2)>59 then
				$fl_DateIsOk=False
			EndIf
			if StringMid($TextRemindCombo,18,2)>59 then
				$fl_DateIsOk=False
			EndIf
		EndIf
		if $fl_DateIsOk Then
			if _DateToDayValue(StringLeft($TextRemindCombo,4), StringMid($TextRemindCombo,6,2), StringMid($TextRemindCombo,9,2)) = 0 Then
				$fl_DateIsOk=False
			EndIf
		EndIf
		if $fl_DateIsOk Then
			$NewDate=$TextRemindCombo
		Else
			MsgBox(-1,"","Не правильный формат, даты")
			$NewDate=""
		EndIf
	EndIf
;~ 	ConsoleWrite($NewDate & @CRLF)
	Return $NewDate
EndFunc

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
;~ 	ConsoleWrite(1 & @CRLF)
	Switch $hWndFrom
;~ 		Case $Remind_Combo
;~ 			ConsoleWrite(1)
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
;~ 					ConsoleWrite($Sort)
;~ 					if $Sort Then
;~ 						$Sort = False
;~ 					else
;~ 						$Sort = True
;~ 					EndIf
;~ 					$Sort = True
;~ 					ConsoleWrite(DllStructGetData($tInfo, "SubItem"))
;~ 					 _GUICtrlListView_SimpleSort($hListView,$Sort , DllStructGetData($tInfo, "SubItem"))
					_GUICtrlListView_SortItems($hListView, DllStructGetData($tInfo, "SubItem"))
					LoadTasks(False,DllStructGetData($tInfo, "SubItem"))
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
					$id_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 4)
					$CurrentIDTask=$id_Task
;~ 					$TekTask=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2)
;~ 					GUICtrlSetData ( $CurrentTask_Label,$TekTask)
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
					$id_Task=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 4)
					$CurrentIDTask=$id_Task
;~ 					$TekTask=StringLeft(_GUICtrlListView_GetItemText($hListView,$CurrentRow, 1),45)
					$TekTask=_GUICtrlListView_GetItemText($hListView,$CurrentRow, 2)
;~ 				    if StringLen($TekTask)=45 then
;~ 						$TekTask=$TekTask & "..."
;~ 					EndIf
					GUICtrlSetData ( $CurrentTask_Label,$TekTask)
;~ 					$CurrentTask_Label=GUICtrlCreateLabel("Текущая задача  - ", 120, 266)
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


Func _MySQLConnect($sUsername, $sPassword, $sDatabase, $sServer, $sDriver = "{MySQL ODBC 5.1 Driver}", $iPort=3306)
;~ 	$sServer="192.168.0.7"
;~ 	$MySQLConn = ObjCreate("ADODB.Connection")
;~ 	ConsoleWrite("DRIVER={MySQL ODBC 5.1 Driver};SERVER=" & $sServer & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";PORT=3306" & @CRLF)
;~ 	$MySQLConn.Open("DRIVER={MySQL ODBC 5.1 Driver};SERVER=" & $sServer & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";PORT=3306")
;~ 	$MySQLConn.Execute("CREATE DATABASE `" & $sDatabase & "`")
;~ 	$MySQLConn.Close
	Local $v = StringMid($sDriver, 2, StringLen($sDriver) - 2)
	Local $key = "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers", $val = RegRead($key, $v)
	If @error or $val = "" Then
		SetError(2)

		Return 0
	EndIf
	$ObjConn = ObjCreate("ADODB.Connection")
	$Objconn.open ("DRIVER=" & $sDriver & ";SERVER=" & $sServer & ";DATABASE=" & $sDatabase & ";UID=" & $sUsername & ";PWD=" & $sPassword & ";PORT="&$iPort)
	If @error Then
		SetError(1)
		ConsoleWrite("мы тут")
		Return 0
	Else
		Return $ObjConn
	EndIf
EndFunc   ;==>_MySQLConnect
Func _Query($oConnectionObj, $sQuery)
;~ 	ConsoleWrite($sQuery & @CRLF)
	If IsObj($oConnectionObj) Then
		Return $oConnectionobj.execute ($sQuery)
	EndIf
	If @error Then
		SetError(1)
		Return 0
	EndIf

EndFunc   ;==>_Query
Func _MySQLEnd($oConnectionObj)
	If IsObj($oConnectionObj) Then
		$oConnectionObj.close
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_MySQLEnd

Func CheckUpdate()
;~ 	$PathTasks="\\192.168.0.111\DWND\Tasks.exe"

	$PathTasks="\\oai-03\DWND\"
	if $sDatabase="TaskDBPlanB" Then
		$PathTasks="\\oai-03\autoit\"
	EndIf
;~ 	MsgBox(-1,"",$PathTasks)
	$PathScript=@ScriptFullPath
	;~ $PathScript="C:\Documents and Settings\ivanov\Рабочий стол\Tasks.exe"
	if StringInStr($PathScript,"exe")=0 then
;~ 		MsgBox(-1,"","Это не ехе")
		Return ""
	EndIf
	if FileExists ($PathTasks & "Tasks.exe")=1 Then
		if FileGetTime ($PathTasks & "Tasks.exe",0,1)=FileGetTime ($PathScript,0,1) AND FileGetSize ($PathTasks & "Tasks.exe")=FileGetSize ($PathScript) Then
;~ 			MsgBox(-1,"","Все совпадает")
		Else
			if MsgBox (1, "Обновление задач", "Появилось обновление программы Tasks.exe, желаете обновить?") = 1 then
				if Run($PathTasks & "CopyFiles.exe "& Chr(34) & $PathScript &Chr(34))=0 Then
					MsgBox(-1,"","Не удалось обновить программу")
				Else
					Exit
				EndIf
			Else
				$TimeCheckUpdate=43200000 ;12 часов следующее обновление
;~ 				$TimeCheckUpdate=3000 ;12 часов следующее обновление
			EndIf
		EndIf
	Else
;~ 		MsgBox(-1,"","не доступен обновляемый файл")
	EndIf
EndFunc
Func GetCurrentUser()
	$SQLOpen=_MySQLConnect($sUsername, $sPassword, $sDatabase, $sServer)
	$TextQuery="SELECT Name FROM Workers WHERE UserWindows = " & chr(34) & @UserName & chr(34)
;~ 	ConsoleWrite($TextQuery)
;~ 	Exit
	$Result=_Query($SQLOpen, $TextQuery)
	$CurrentUser=""
	With $Result
		While NOT .EOF
;~ 			ConsoleWrite(.Fields("Name").value)
			$CurrentUser=.Fields("Name").value
			.MoveNext
		WEnd
	EndWith
	Return $CurrentUser
	_MySQLEnd($SQLOpen)
EndFunc
