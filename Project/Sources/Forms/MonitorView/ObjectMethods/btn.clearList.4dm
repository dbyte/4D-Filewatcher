/* CL: MonitorView.btn.clearList

View component listener for Button "Clear".
----------------------------------------------------
*/

If (Form event code=On Clicked)
	var $controller : cs.MonitorViewController
	$controller:=Form.controller
	$controller.clearAllEvents()
End if 
