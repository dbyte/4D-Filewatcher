/* OM: ObserverView.btn.clearList

Object listener for Button "Clear".
----------------------------------------------------
*/

If (Form event code:C388=On Clicked:K2:4)
	var $controller : cs:C1710.ObserverViewController
	$controller:=Form:C1466.controller
	$controller.clearAllEvents()
End if 
