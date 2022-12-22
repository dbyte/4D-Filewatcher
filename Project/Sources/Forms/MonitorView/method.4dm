/* PFM: MonitorView

Form listener for MonitorView.
----------------------------------------------------
*/

Case of 
	: (Form event code:C388=On Load:K2:1)
		// Prepare refreshing listbox collection every 2 seconds.
		SET TIMER:C645(60*2)
		
	: (Form event code:C388=On Timer:K2:25)
		// Workaround to force refresh listbox view and other props of
		// the shared object of cs.WatcherConfig.
		var $controller : cs:C1710.MonitorViewController
		$controller:=Form:C1466.controller  // to get some code completion
		$controller.refreshView()
End case 
