/* OM: MonitorView.btn.settings

Object listener for "Settings" button.
----------------------------------------------------
*/

If (Form event code:C388=On Clicked:K2:4)
	var $controller : cs:C1710.MonitorViewController
	$controller:=Form:C1466.controller  // to get some code completion
	$controller.openSettingsView()
End if 
