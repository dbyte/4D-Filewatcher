/* OM: ObserverView.btn.startstop

Object listener for Button Start/Stop.
----------------------------------------------------
*/

If (Form event code:C388=On Clicked:K2:4)
	var $controller : cs:C1710.ObserverViewController
	$controller:=Form:C1466.controller
	
	If ($controller.startWatcher())
		OBJECT SET TITLE:C194(*; FORM Event:C1606.objectName; "Stop")
	Else 
		OBJECT SET TITLE:C194(*; FORM Event:C1606.objectName; "Start")
	End if 
	
End if 
