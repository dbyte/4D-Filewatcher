/* FL: MonitorView

Form listener for MonitorView.
----------------------------------------------------
*/

Case of 
	: (Form event code=On Load)
		var $controller : cs.MonitorViewController
		$controller:=Form.controller  // Feed 4D parser bastard with a type-hint
		// Prepare refreshing listbox collection every 1 seconds or slower.
		SET TIMER(60*($controller.throttleSecs<1 ? 1 : $controller.throttleSecs))
		
	: (Form event code=On Timer)
		// Workaround to force refresh listbox view and other props of
		// the shared object of cs.WatcherConfig.
		var $controller : cs.MonitorViewController
		$controller:=Form.controller  // Feed 4D parser bastard with a type-hint
		$controller.refreshView()
End case 
