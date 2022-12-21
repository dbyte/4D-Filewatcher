/* cs.MonitorViewController

View controller for MonitorView.
----------------------------------------------------
*/

Class constructor($config : cs:C1710.WatcherConfig)
	This:C1470._FORM_NAME:="MonitorView"
	This:C1470._WORKER_ID:="filewatcher"
	This:C1470._config:=OB Copy:C1225($config; ck shared:K85:29)
	This:C1470._watcher:=cs:C1710.Watcher.new(This:C1470._config)
	
	
Function openView()
	var $winRef : Integer
	var $watcher : cs:C1710.Watcher
	$watcher:=This:C1470._watcher  // to get some code completion
	
	$winRef:=Open form window:C675(String:C10(This:C1470._FORM_NAME); Plain form window:K39:10)
	SHOW WINDOW:C435($winRef)
	DIALOG:C40(This:C1470._FORM_NAME; New object:C1471("controller"; This:C1470))
	
	$watcher.terminate()
	
	
Function startWatcher() : Boolean
	var $watcher : cs:C1710.Watcher
	$watcher:=This:C1470._watcher  // to get some code completion
	
	If ($watcher.isRunning())
		// Do not start a 2nd worker. Instead, terminate worker thread 
		// and (implicitly) its SystemWorker child.
		$watcher.terminate()
	Else 
		$watcher.run()
	End if 
	
	return $watcher.isRunning()
	
	
Function clearAllEvents()
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config
	
	var $events : Collection
	$events:=$config.events
	Use ($events)
		$events.clear()
	End use 
	
	
Function refreshEventsListbox() : Collection
	// Refresh listbox collection nearly as suggested at
	// https://discuss.4d.com/t/redrawing-a-collection-in-a-listbox/14455/2
	// This is a workaround.
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config
	
	var $events : Collection
	$events:=$config.events
	Use ($events)
		$events.push("")
		$events.pop()
	End use 
	
	
Function get events() : Collection
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config
	return $config.events
	
	
Function get watchedDirPlatformPath() : Text
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config
	return $config.getWatchedDir().path
	