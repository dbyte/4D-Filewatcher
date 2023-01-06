/* CL: MonitorView.btn.settings

View component listener for "Settings" button.
----------------------------------------------------
*/

If (Form event code=On Clicked)
	var $controller : cs.MonitorViewController
	$controller:=Form.controller  // Feed 4D parser bastard with a type-hint
	$controller.showSettingsView()
End if 
