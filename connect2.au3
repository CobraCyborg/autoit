;~ Func FB()
;~     DllOpen("C:\Program Files\Firebird\Firebird_2_5\bin\fbclient.dll")
;~     Local $obdc_drv2 = "Firebird/InterBase(r) driver"
;~     Local $key = "HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI\ODBC Drivers", $val = RegRead($key, $obdc_drv2)
;~ 	MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$val' & @CRLF & @CRLF & 'Return:' & @CRLF & $val) ;### Debug MSGBOX
;~     If @error or $val = "" Then
;~             MsgBox(64,"Внимание","Вероятно не установлен"& @CR & $obdc_drv2)
;~             Exit

;~     EndIf

;~     ; Подключаемся к Серверу
;~     Global $adoCon = ObjCreate("ADODB.Connection")
;~     $adoCon.Open("DRIVER={Firebird/InterBase(r) driver};UID=SYSDBA;PWD=masterkey; DBNAME=127.0.0.1:" & @scriptDir &"\BP.FDB")

;~         $fb = $adoCon.Execute('select * from "tGroup"')
;~ 		For $n = 0 To $fb.Fields.Count - 1
;~ 		 MsgBox(0,"",$fb.Fields ($n).value)
;~       Next

;~ EndFunc

;~ FB()


;~ $Connect =  "DRIVER=Firebird/InterBase(r) driver; UID=SYSDBA; PWD=masterkey; DBNAME=" & @scriptDir &"\BP.FDB"
;~ $query = 'select * from "tGroup"'
;~ $adoCon = ObjCreate("ADODB.Connection")
;~ $adoCon.Open($Connect)
;~ $adoRs = ObjCreate("ADODB.Recordset")
;~ $adoRs.Open($query , $adoCon)
;~ $cols=""                              ; Get information about Fields collection
;~ For $n = 0 To $adoRs.Fields.Count - 1
;~     $cols = $cols & $adoRs.Fields ($n).Value & "  "
;~ Next
;~ MsgBox(0, @ScriptName, $cols)

#include <Array.au3>

$dsn = "DSN=FireBird"
$adoCon = ObjCreate ("ADODB.Connection")
$adoCon.Open ($DSN)
$sGroup = "'0602000000Ff'"
$s_Qry = 'select "fName" from "tModel" where "fGroup" = ' & $sGroup &';'
ODBCquery($s_Qry)
$adoCon.Close

Func ODBCquery($s_Qry)
    $adoSQL = $s_Qry
    $adoRs = ObjCreate ("ADODB.Recordset")
    $adoRs.CursorType = 2
    $adoRs.LockType = 3
    $adoRs.Open ($adoSql, $adoCon)
    Local $cmboVal[0]
;~ 	_ArrayDisplay($cmboVal)
    With $adoRs
      $cols=""                              ; Get information about Fields collection
      For $n = 0 To .Fields.Count - 1
         $cols = $cols & .Fields ($n).Name & @CRLF
      Next
;~       MsgBox(0, @ScriptName, $cols)

      If .RecordCount Then
         $count = 0
         While Not .EOF
            $count = $count + 1
            For $colum = 0 To .Fields.Count - 1
				Local $sValue = .Fields ($colum).Value
				If $sValue <> "" Then _ArrayAdd($cmboVal, $sValue)
            Next
;~             $cmboVal = StringTrimRight($cmboVal, 1) & @CR
;~             MsgBox(0, @ScriptName, $cmboVal)
;~             $cmboVal = ""
            .MoveNext
         WEnd
	  EndIf
	EndWith
	_ArrayDisplay($cmboVal)
EndFunc