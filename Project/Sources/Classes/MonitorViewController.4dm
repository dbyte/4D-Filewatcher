/* cs.MonitorViewController

View controller for MonitorView.
----------------------------------------------------
*/

Class constructor($config : cs:C1710.WatcherConfig)
	This:C1470._MAIN_VIEW_NAME:="MonitorView"
	This:C1470._SETTINGS_VIEW_NAME:="SettingsView"
	
	This:C1470._mainViewRef:=Null:C1517
	This:C1470._config:=OB Copy:C1225($config; ck shared:K85:29)
	This:C1470._watcher:=cs:C1710.Watcher.new(This:C1470._config)
	
	// mark: -
	
Function openView()
	var $watcher : cs:C1710.Watcher
	$watcher:=This:C1470._watcher  // to get some code completion
	
	SET MENU BAR:C67("MonitorView.default")
	
	This:C1470._mainViewRef:=Open form window:C675(String:C10(This:C1470._MAIN_VIEW_NAME); Plain form window:K39:10)
	SHOW WINDOW:C435(This:C1470._mainViewRef)
	DIALOG:C40(This:C1470._MAIN_VIEW_NAME; New object:C1471("controller"; This:C1470))
	
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
	$config:=This:C1470._config  // to get some code completion
	
	var $events : Collection
	$events:=$config.events
	Use ($events)
		$events.clear()
	End use 
	
	
Function refreshView() : Collection
	// Refresh listbox collection and other view objects which reference
	// properties of This._config. This is a dumb workaround as suggested in lots of
	// 4D forum threads. We'll have to mix up data for view purposes, which smells.
	// It is also needed to refresh the field view (Form.controller.watchedDirPlatformPath).
	// The field gets its data by calling computed prop This.watchedDirPlatformPath, which
	// then will request props of This._config.This._config is a shared object, so why do
	// we have to do that???
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config
	
	Use ($config)
		This:C1470._config:=$config
	End use 
	
	// mark: - Getters and Setters
	
Function get events() : Collection
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config
	return $config.events
	
	
Function get watchedDirPlatformPath() : Text
	var $config : cs:C1710.WatcherConfig
	var $pathAsPosixString : Text
	$config:=This:C1470._config
	$pathAsPosixString:=$config.getWatchedDir().path
	return $pathAsPosixString
	
	// mark: - Settings view
	
Function openSettingsView()
	var $watcher : cs:C1710.Watcher
	var $config : cs:C1710.WatcherConfig
	var $formData : Object
	var $winRef : Integer
	
	$watcher:=This:C1470._watcher
	$config:=This:C1470._config
	
	If $watcher.isRunning()
		BEEP:C151
		ALERT:C41("Stop the watcher before changing any settings.")
		return 
	End if 
	
	$formData:=New object:C1471()
	$formData.watchedDirEntryField:=$config.getWatchedDir().path
	
	$winRef:=Open form window:C675(String:C10(This:C1470._SETTINGS_VIEW_NAME); Sheet form window:K39:12)
	DIALOG:C40(This:C1470._SETTINGS_VIEW_NAME; $formData)
	
	If (OK=0)
		return 
	End if 
	
	If ($formData.watchedDirEntryField="")
		BEEP:C151
		return 
	End if 
	
	If (Not:C34(Folder:C1567($formData.watchedDirEntryField).exists))
		BEEP:C151
		ALERT:C41("Directory "+$formData.watchedDirEntryField+" does not exist.")
		return 
	End if 
	
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config  // to get some code completion
	
	Use ($config)
		$config.withWatchedDir(Folder:C1567($formData.watchedDirEntryField))
	End use 
	