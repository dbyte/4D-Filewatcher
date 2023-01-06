/* cs.MonitorViewController

View controller for MonitorView. This also is a kind of
API to the Filewatcher which would even work if you extracted the
window calls.
----------------------------------------------------
*/

Class constructor($config : cs.WatcherConfig)
	This._MAIN_VIEW_NAME:="MonitorView"
	This._SETTINGS_VIEW_NAME:="SettingsView"
	
	This._mainViewRef:=Null
	This._config:=OB Copy($config; ck shared)
	This._watcher:=cs.Watcher.new(This._config)
	
	// mark: -
	
Function openView()
	var $watcher : cs.Watcher
	$watcher:=This._watcher  // to get some code completion
	
	SET MENU BAR("MonitorView.default")
	
	This._mainViewRef:=Open form window(String(This._MAIN_VIEW_NAME); Plain form window)
	SHOW WINDOW(This._mainViewRef)
	DIALOG(This._MAIN_VIEW_NAME; New object("controller"; This))
	
	$watcher.terminate()
	
	
Function startWatcher() : Boolean
	var $watcher : cs.Watcher
	$watcher:=This._watcher  // to get some code completion
	
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
	$config:=This._config  // to get some code completion
	
	var $events : Collection
	$events:=$config.events
	Use ($events)
		$events.clear()
	End use 
	
	
Function refreshView() : Collection
	// Refresh listbox collection and other view objects which reference
	// properties of This._config. This is a dumb workaround as suggested in lots of
	// 4D forum threads. We'll have to mix up data for view purposes, which smells.
	// It is also needed to refresh the field view (Form.controller.watchedDirPath).
	// The field gets its data by calling computed prop This.watchedDirPath, which
	// then will request props of This._config.This._config is a shared object, so why do
	// we have to do that???
	var $config : cs.WatcherConfig
	$config:=This._config
	
	Use ($config)
		This._config:=$config
	End use 
	
	// mark: - Getters and Setters
	
Function get events() : Collection
	var $config : cs.WatcherConfig
	$config:=This._config
	return $config.events
	
	
Function get watchedDirPath() : Text
	var $config : cs.WatcherConfig
	$config:=This._config
	return $config.getWatchedDirPlatformPath()
	
	
Function get throttleSecs() : Integer
	var $config : cs.WatcherConfig
	$config:=This._config
	return $config.getThrottleSecs()
	
	
Function get workerPreemptiveMode() : Text
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
	
	// mark: - Settings view
	
Function openSettingsView()
	var $watcher : cs.Watcher
	var $config : cs.WatcherConfig
	var $formData : Object
	var $winRef : Integer
	
	$watcher:=This._watcher
	$config:=This._config
	
	If $watcher.isRunning()
		BEEP
		ALERT("Stop the watcher before changing any settings.")
		return 
	End if 
	
	$formData:=New object()
	
	$formData.watchedDirEntryField:=$config.getWatchedDirPlatformPath()
	$formData.throttleSecs:=$config.getThrottleSecs()
	
	$winRef:=Open form window(String(This._SETTINGS_VIEW_NAME); Sheet form window)
	DIALOG(This._SETTINGS_VIEW_NAME; $formData)
	
	If (OK=0)
		return 
	End if 
	
	If ($formData.watchedDirEntryField="")
		BEEP
		return 
	End if 
	
	var $abstractedPath : 4D.Folder
	If (Is Windows)
		$abstractedPath:=Folder($formData.watchedDirEntryField; fk platform path)
	Else 
		$abstractedPath:=Folder($formData.watchedDirEntryField; fk posix path)
	End if 
	
	If (Not($abstractedPath.exists))
		BEEP
		ALERT("Directory "+$formData.watchedDirEntryField+" does not exist.")
		return 
	End if 
	
	var $config : cs.WatcherConfig
	$config:=This._config  // to get some code completion
	
	Use ($config)
		$config.withWatchedDir($abstractedPath)
		$config.withThrottleSecs(Num($formData.throttleSecs))
	End use 
	