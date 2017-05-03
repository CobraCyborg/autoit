#include <Array.au3>
#include <FireBird.au3>

Global $h_fbDll = DllOpen(@ScriptDir & "\fbdll4vb20.dll")
Global $servername = "127.0.0.1"
Global $sDBName = @ScriptDir & "\BP.FDB"
Local $sUsername = "SYSDBA"
Local $sPassword = "masterkey"
Local $rv, $result

$rv = _FireBird_ConnectDatabase($h_fbDll, $servername, $sDBName, $sUsername, $sPassword)

If $rv Then
	$rcount = _FireBird_ExecuteSelect($h_fbDll, 'SELECT "fName" FROM "tGroup"', $result)
	_FireBird_DisConnectDatabase($h_fbDll)
EndIf
