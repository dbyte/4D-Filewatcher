/* cs.MonitorViewController

View controller for MonitorView. Parts of it are also a kind of API to the
filewatcher backend which would even work if we dismissed the GUI calls.
----------------------------------------------------
*/

Class constructor($config : cs.WatcherConfig)
	This._VIEW_NAME:="MonitorView"
	
	This._viewRef:=Null
	This._config:=OB Copy($config; ck shared)
	This._watcher:=cs.Watcher.new(This._config)
	
	// mark: -
	
Function showView()
/* ----------------------------------------------------------------
Shows the filewatcher monitor.
---------------------------------------------------------------- */
	var $watcher : cs.Watcher
	$watcher:=This._watcher  // Feed 4D parser bastard with a type-hint
	
	SET MENU BAR("MonitorView.default")
	
	This._viewRef:=Open form window(String(This._VIEW_NAME); Plain form window)
	SHOW WINDOW(This._viewRef)
	DIALOG(This._VIEW_NAME; New object("controller"; This))
	
	$watcher.terminate()
	
	
Function startWatcher() : Boolean
/* ----------------------------------------------------------------
Starts filewatcher backend and its wrapping 4D worker.
---------------------------------------------------------------- */
	var $watcher : cs.Watcher
	$watcher:=This._watcher  // Feed 4D parser bastard with a type-hint
	
	If ($watcher.isRunning())
		// Do not start a 2nd SystemWorker. Instead, terminate worker thread 
		// and (implicitly) its SystemWorker child.
		$watcher.terminate()
	Else 
		$watcher.run()
	End if 
	
	return $watcher.isRunning()
	
	
Function clearAllEvents()
	var $config : cs.WatcherConfig
	$config:=This._config  // Feed 4D parser bastard with a type-hint
	
	var $events : Collection
	$events:=$config.events
	Use ($events)
		$events.clear()
	End use 
	
	
Function refreshView() : Collection
/* ----------------------------------------------------------------
Refreshes listbox collection and other view objects which reference
properties of This._config. This is a dumb workaround as suggested in lots of
4D forum threads. We'll have to mix up data for view purposes, which smells.
It is also needed to refresh the field view (Form.controller.watchedDirPath).
The field gets its data by calling computed prop This.watchedDirPath, which
then will request props of This._config.This._config is a shared object, so why do
we have to force a refresh?
---------------------------------------------------------------- */
	var $config : cs.WatcherConfig
	$config:=This._config
	
	Use ($config)
		This._config:=$config
	End use 
	
	// mark: - Getters and Setters
	
Function get events() : Collection
/* ----------------------------------------------------------------
Returns a collection of filewatcher events.
---------------------------------------------------------------- */
	var $config : cs.WatcherConfig
	$config:=This._config  // Feed 4D parser bastard with a type-hint
	return $config.events
	
	
Function get watchedDirPath() : Text
/* ----------------------------------------------------------------
Returns configured watched directory path as a platform-specific string.
---------------------------------------------------------------- */
	var $config : cs.WatcherConfig
	$config:=This._config
	return $config.getWatchedDirPlatformPath()
	
	
Function get throttleSecs() : Integer
/* ----------------------------------------------------------------
Returns configured backend throttling (a.k.a. bouncing) as seconds.
---------------------------------------------------------------- */
	var $config : cs.WatcherConfig
	$config:=This._config
	return $config.getThrottleSecs()
	
	
Function get workerPreemptiveMode() : Text
/* ----------------------------------------------------------------
Returns current 4D processing mode of the worker as string.
Possible values are: "inactive", "preemptive", "cooperative".
Note: Won't be preemptive when running interpreted.
---------------------------------------------------------------- */
	var $watcher : cs.Watcher
	$watcher:=This._watcher
	
	Case of 
		: ($watcher.getWorkerProcessMode()=0)
			return "inactive"
		: ($watcher.getWorkerProcessMode() ?? 1)
			return "preemptive"
		Else 
			return "cooperative"
	End case 
	
	// mark: - Single page settings view
	
Function showSettingsView()
/* ----------------------------------------------------------------
Returns configured backend throttling (a.k.a. bouncing) as seconds.
---------------------------------------------------------------- */
	var $watcher : cs.Watcher
	$watcher:=This._watcher  // Feed 4D parser bastard with a type-hint
	
	If $watcher.isRunning()
		BEEP
		ALERT("Stop the watcher before changing any settings.")
		return 
	End if 
	
	cs.SettingsViewController.new(This._config).showView()
	