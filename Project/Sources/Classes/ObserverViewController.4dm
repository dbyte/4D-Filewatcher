/* cs.ObserverViewController

----------------------------------------------------
*/

Class constructor($watcher : cs:C1710.Watcher)
	This:C1470._FORM_NAME:="ObserverView"
	This:C1470._WORKER_ID:="filewatcher"
	This:C1470._watcher:=$watcher
	
	
Function openView()
	var $winRef : Integer
	
	$winRef:=Open form window:C675(String:C10(This:C1470._FORM_NAME); Plain form window:K39:10)
	SHOW WINDOW:C435($winRef)
	DIALOG:C40(This:C1470._FORM_NAME; New object:C1471("controller"; This:C1470))
	
	This:C1470.stopWatcher()
	
	
Function startWatcher() : Boolean
	If (This:C1470.isWatcherRunning())
		// Terminate worker thread and (implicitly) its SystemWorker child.
		This:C1470.stopWatcher()
		
	Else 
/*
Launch worker thread. 
At the end we have one new thread which spawns a new 4D.Systemworker
on the same thread but async.
		
Warning! We must use a predefined $watcher variable here, being
captured by Formula().
Formula(This._watcher.run()) will result in a RTE!
*/
		var $watcher : cs:C1710.Watcher
		$watcher:=This:C1470._watcher
		CALL WORKER:C1389(This:C1470._WORKER_ID; Formula:C1597($watcher.run()))
	End if 
	
	return This:C1470.isWatcherRunning()
	
	
Function stopWatcher()
	var $watcher : cs:C1710.Watcher
	$watcher:=This:C1470._watcher  // to get some code completion
	
	$watcher.terminateBackend()
	KILL WORKER:C1390(This:C1470._WORKER_ID)
	While (This:C1470.isWatcherRunning())
		// Block and wait for termination.
	End while 
	
	
Function clearAllEvents()
	var $events : Collection
	$events:=This:C1470._shared().getConfig().events
	Use ($events)
		$events.clear()
	End use 
	
	
Function refreshEventsListbox() : Collection
	// Refresh listbox collection nearly as suggested at
	// https://discuss.4d.com/t/redrawing-a-collection-in-a-listbox/14455/2
	// This is a workaround.
	var $events : Collection
	$events:=This:C1470._shared().getConfig().events
	Use ($events)
		$events.push("")
		$events.pop()
	End use 
	
	
Function isWatcherRunning() : Boolean
	var $state : Integer
	$state:=Process state:C330(Process number:C372(This:C1470._WORKER_ID))
	return (($state=Executing:K13:4) || ($state=Waiting for user event:K13:9))
	
	
Function get events() : Collection
	return This:C1470._shared().getConfig().events
	
	
Function get watchedDirPlatformPath() : Text
	return This:C1470._shared().getConfig().getWatchedDir().path
	
	
Function _shared() : cs:C1710.Shared
	// Get some code completion in callers.
	return cs:C1710.Shared.new()
	