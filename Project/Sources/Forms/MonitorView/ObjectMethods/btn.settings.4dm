/* OM: MonitorView.btn.settings

Object listener for "Settings" button.
----------------------------------------------------
*/

If (Form event code=On Clicked)
	var $controller : cs.MonitorViewController
	$controller:=Form.controller  // to get some code completion
	$controller.openSettingsView()
End if 
