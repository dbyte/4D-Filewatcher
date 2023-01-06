/* OM: MonitorView.btn.clearList

Object listener for Button "Clear".
----------------------------------------------------
*/

If (Form event code=On Clicked)
	var $controller : cs.MonitorViewController
	$controller:=Form.controller
	$controller.clearAllEvents()
End if 
