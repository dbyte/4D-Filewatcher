/* OM: MonitorView.btn.startstop

Object listener for Button Start/Stop.
----------------------------------------------------
*/

If (Form event code=On Clicked)
	var $controller : cs.MonitorViewController
	$controller:=Form.controller
	
	If ($controller.startWatcher())
		OBJECT SET TITLE(*; FORM Event.objectName; "Stop")
	Else 
		OBJECT SET TITLE(*; FORM Event.objectName; "Start")
	End if 
	
End if 
