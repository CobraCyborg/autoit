#include <Array.au3>
#include <GUIConstants.au3>

Dim $result = 0;
Dim $status=" Disconnected "

$gui = GuiCreate("ODBC Query", 704, 488, 490,360 ,BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
; --- Menu for future use ----
$filemenu = GUICtrlCreateMenu ("&File")
$fileitem = GUICtrlCreateMenuitem ("Open",$filemenu)
GUICtrlSetState(-1,$GUI_DEFBUTTON)
$helpmenu = GUICtrlCreateMenu ("?")
$saveitem = GUICtrlCreateMenuitem ("Save",$filemenu)
GUICtrlSetState(-1,$GUI_DISABLE)
$infoitem = GUICtrlCreateMenuitem ("Info",$helpmenu)
$exititem = GUICtrlCreateMenuitem ("Exit",$filemenu)
$recentfilesmenu = GUICtrlCreateMenu ("Recent Files",$filemenu,1)

$separator1 = GUICtrlCreateMenuitem ("",$filemenu,2); create a separator line
$viewmenu = GUICtrlCreateMenu("View",-1,1); is created before "?" menu
$viewstatusitem = GUICtrlCreateMenuitem ("Statusbar",$viewmenu)
GUICtrlSetState(-1,$GUI_CHECKED)
$l_statusbar = GUICtrlCreateLabel ($status,1,450,700,18,BitOr($SS_SIMPLE,$SS_SUNKEN))

$tab=GUICtrlCreateTab (1,1, 700,440)

$tab_conn=GUICtrlCreateTabitem (" Connection ")
;   GUICtrlSetState(-1,$GUI_SHOW)  ; will be display first
    $dsn_list = GUICtrlCreateListView("DSN|Type|Description", 20, 50, 550, 350)
    ODBCsources($dsn_list,"HKEY_CURRENT_USER\Software\ODBC\ODBC.INI\ODBC Data Sources" , "USER"  )
    ODBCsources($dsn_list,"HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources", "SYSTEM")
    $bt_conn   = GUICtrlCreateButton("Connect"   , 600,  70, 70, 20)
    $bt_discon = GUICtrlCreateButton("Disconnect", 600, 110, 70, 20)
    GUICtrlSetState($bt_discon, $GUI_DISABLE )

$tab_query=GUICtrlCreateTabitem (" Query ")
    $ed_qry = GUICtrlCreateEdit("", 20, 50, 550, 350)
    $bt_run = GUICtrlCreateButton("Run"  , 600,  70, 70, 20)
    $bt_clr = GUICtrlCreateButton("Clear", 600, 110, 70, 20)

$tab_result=GUICtrlCreateTabitem (" Result ")
    $result = GUICtrlCreateListView("Result", 20, 50, 550, 350)
    $bt_new = GUICtrlCreateButton("New query"  , 600,  70, 80, 20)
GUICtrlCreateTabitem ("")

GUISetState ()

While 1
    $msg = GUIGetMsg()
    if $msg <> 0 then
        Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
          Case $msg = $fileitem
            $file = FileOpenDialog("Choose file...",@TempDir,"SQLfiles (*.sql)|All (*.*)")
            If @error <> 1 Then GUICtrlCreateMenuitem ($file,$recentfilesmenu)
        Case $msg = $viewstatusitem
            If BitAnd(GUICtrlRead($viewstatusitem),$GUI_CHECKED) = $GUI_CHECKED Then
                GUICtrlSetState($viewstatusitem,$GUI_UNCHECKED)
                GUICtrlSetState($l_statusbar,$GUI_HIDE)
            Else
                GUICtrlSetState($viewstatusitem,$GUI_CHECKED)
                GUICtrlSetState($l_statusbar,$GUI_SHOW)
            EndIf
        Case $msg = $infoitem
            Msgbox(0,"Info","ODBC Query version 0.1")
        Case $msg = $bt_conn
            $dsnarray = StringSplit((GUICtrlRead(GUICtrlRead($dsn_list), 2)), "|")
			_ArrayDisplay($dsnarray)
            if $dsnarray[1] <> "" Then
                $dsn = "DSN=" & $dsnarray [1]
;~ 				ClipPut($dsn)
                $adoCon = ObjCreate ("ADODB.Connection")
                $adoCon.Open ($DSN)

                GUICtrlSetState($bt_conn  , $GUI_DISABLE )
                GUICtrlSetState($bt_discon, $GUI_ENABLE  )
                GUICtrlSetData($l_statusbar,"Connected to "&$dsn)
                GUICtrlSetState($tab_query, $GUI_SHOW )     ; show query tab
                GUICtrlSetState($ed_qry, $GUI_FOCUS )       ; select edit field
            Endif
        Case $msg = $bt_discon
            $adoCon.Close
            GUICtrlSetState($bt_conn  , $GUI_ENABLE )
            GUICtrlSetState($bt_discon, $GUI_DISABLE  )
            GUICtrlSetData($l_statusbar,"Disconnected")
        Case $msg = $bt_run
            GUICtrlSetState($tab_result, $GUI_SHOW )        ; show result tab
            GuiSwitch($gui,$tab_result)
            GuiCtrlDelete($result)
            ODBCquery(GUICtrlRead($ed_qry))
            GUICtrlCreateTabItem("")
            GUICtrlSetState($result,$GUI_FOCUS)
            GUISetState (@SW_SHOW,$gui)
        Case $msg = $bt_clr
            GUICtrlSetData($ed_qry, "" )                ; clear data
            GUICtrlSetState($result,$GUI_FOCUS)
        Case $msg = $bt_new
            GUICtrlSetState($tab_query, $GUI_SHOW )     ; show query tab
            GUICtrlSetState($ed_qry, $GUI_FOCUS )       ; select edit field
        Case $msg = $tab_query
            GUICtrlSetState($tab_query, $GUI_SHOW )     ; show query tab
            GUICtrlSetState($ed_qry, $GUI_FOCUS )       ; select edit field
      EndSelect
    EndIf
WEnd
GUIDelete()
Exit

Func ODBCsources($h_controlID, $s_RegEntry, $s_Type)
    Local $s_List, $i_dsncount, $s_VarNm, $s_Value
    $i_dsncount = 1
    $s_VarNm = RegEnumVal($s_RegEntry,  $i_dsncount)
    $s_Value = RegRead($s_RegEntry, $s_Varnm)
    While $s_VarNm <> ""
        $s_VarNm = RegEnumVal($s_RegEntry,  $i_dsncount)
        $s_Value = RegRead($s_RegEntry, $s_Varnm)
        If $s_Varnm <> "" Then
            GUICtrlCreateListViewItem($s_VarNm & "|" & $s_Type & "|" & $s_Value, $h_controlID)
            $i_dsncount += 1
        EndIf
    Wend
EndFunc

Func ODBCquery($s_Qry)
    $adoSQL = $s_Qry
    $adoRs = ObjCreate ("ADODB.Recordset")
    $adoRs.CursorType = 2
    $adoRs.LockType = 3
    $adoRs.Open ($adoSql, $adoCon)
    $cmboVal = ""

    With $adoRs
      $cols=""                              ; Get information about Fields collection
      For $n = 0 To .Fields.Count - 1
         $cols = $cols & .Fields ($n).Name & "|"
      Next
      $result = GUICtrlCreateListView($cols, 20, 50, 550, 350, $LVS_REPORT, $LVS_EX_GRIDLINES)

      If .RecordCount Then
         $count = 0
         While Not .EOF
            $count = $count + 1
            For $colum = 0 To .Fields.Count - 1
               $cmboVal = $cmboVal & "" & .Fields ($colum).Value & "|"
            Next
            $cmboVal = StringTrimRight($cmboVal, 1) & @CR
            GUICtrlCreateListViewItem($cmboVal, $result)
            $cmboVal = ""
            .MoveNext
         WEnd
      EndIf
   EndWith
EndFunc
