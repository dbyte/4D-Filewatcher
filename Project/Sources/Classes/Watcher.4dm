/* cs.Watcher
----------------------------------------------------------------
Launches and maintains 4D.SystemWorker which itself calls a OS-native file watcher backend.
---------------------------------------------------------------- */

Class constructor($config : cs.WatcherConfig)
	This._WORKER_ID:="filewatcher"
	This._config:=$config
	
	
Function run()
	// Launch worker thread with backend program.
	// Warning: We must use a predefined $watcher variable here, being
	// captured by Formula().
	// Formula(This._launchBackend.run()) will result in a RTE
	// as of 4Dv19.R6HF2.
	
	var $this : cs.Watcher
	$this:=This
	
	CALL WORKER(This._WORKER_ID; Formula($this._launchBackend()))
	// Block and wait until process ready.
	While (Not(This.isRunning()))
	End while 
	
	
Function _launchBackend()
	// CALL WORKER target!
	// At the end we'll have one new thread which spawns a new 4D.Systemworker
	// on the same thread but async.
	If (Not(Asserted(OB Is shared(This._config); \
		"This._config (injected in constructor) must be a shared instance, otherwise "+\
		"you won't be able to use its generated data in other processes but this one - "+\
		"if this one was constructed with a CALL WORKER statement.")))
		
		return 
	End if 
	
	// Get some code completion by casting:
	var $config : cs.WatcherConfig
	$config:=This._config
	
	// Run external program; async with callback strategy.
	// For some reason (memory layout?) we cannot use a class property here
	// to hold a reference to the SystemWorker.
	watcherBackendSysWorker:=4D.SystemWorker.new($config.getBackend().path+\
		" --watched-item="+$config.getWatchedDirPlatformPath()+\
		" --throttle-secs="+String($config.getThrottleSecs()); \
		$config)
	
	// Note: Do not .wait() here. Just let it run async.
	
	
Function terminate()
	// Terminates worker thread togehter with backend app.	
	// Warning: We must use a predefined $watcher variable here, being
	// captured by Formula().
	// Formula(This._terminateBackend.run()) will result in a RTE
	// as of 4Dv19.R6HF2.
	
	var $this : cs.Watcher
	$this:=This
	
	CALL WORKER(This._WORKER_ID; Formula($this._terminateBackend()))
	// Block and wait for termination.
	While (This.isRunning())
	End while 
	
	
Function _terminateBackend()
	var $sysWorker : 4D.SystemWorker
	$sysWorker:=watcherBackendSysWorker
	
	If ($sysWorker#Null)
		// We could also use $sysWorker.terminate() here, but the backend
		// also reacts on sending "teardown" to its stdin stream to shut
		// down gracefully.
		$sysWorker.postMessage("teardown"+Char(Line feed))
		$sysWorker.wait(5)
		watcherBackendSysWorker:=Null
	End if 
	
	// Terminate the sysWorker's wrapping 4D worker as well.
	KILL WORKER(This._WORKER_ID)
	
	
Function isRunning() : Boolean
	var $state : Integer
	$state:=Process state(Process number(This._WORKER_ID))
	return (($state=Executing) || ($state=Waiting for user event))
	
	
Function getWorkerProcessMode() : Integer
	var $str : Text
	var $int; $mode : Integer
	
	PROCESS PROPERTIES(Process number(This._WORKER_ID); $name; $int; $int; $mode)
	return $mode
	