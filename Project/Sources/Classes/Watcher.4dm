/* cs.Watcher
----------------------------------------------------------------
Launches and maintains 4D.SystemWorker which itself calls a OS-native file watcher backend.
---------------------------------------------------------------- */

Class constructor($config : cs:C1710.WatcherConfig)
	This:C1470._WORKER_ID:="filewatcher"
	This:C1470._config:=$config
	This:C1470._sysWorker:=Null:C1517
	
	
Function run()
/*
Launch worker thread with backend program.
	
Warning! We must use a predefined $watcher variable here, being
captured by Formula().
Formula(This._launchBackend.run()) will result in a RTE!
*/
	var $this : cs:C1710.Watcher
	$this:=This:C1470
	
	CALL WORKER:C1389(This:C1470._WORKER_ID; Formula:C1597($this._launchBackend()))
	// Block and wait until process ready.
	While (Not:C34(This:C1470.isRunning()))
	End while 
	
	
Function _launchBackend()
	// At the end we'll have one new thread which spawns a new 4D.Systemworker
	// on the same thread but async.
	
	If (Not:C34(Asserted:C1132(OB Is shared:C1759(This:C1470._config); \
		"This._config (injected in constructor) must be a shared instance, otherwise "+\
		"you won't be able to use its generated data in other processes but this one - "+\
		"if this one was constructed with a CALL WORKER statement.")))
		
		return 
	End if 
	
	// Get some code completion by casting:
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config
	
	// Run external program; async with callback strategy, but same process.
	Use (This:C1470)
		This:C1470._sysWorker:=OB Copy:C1225(\
			4D:C1709.SystemWorker.new($config.getBackend().path+\
			" --watched-item="+$config.getWatchedDir().path+\
			" --throttle-secs="+String:C10($config.getThrottleSecs()); \
			$config); \
			ck shared:K85:29)
	End use 
	// $sysWorker.closeInput()
	
	
Function terminate()
	This:C1470._terminateBackend()
	KILL WORKER:C1390(This:C1470._WORKER_ID)
	// Block and wait for termination.
	While (This:C1470.isRunning())
	End while 
	
	
Function _terminateBackend()
	var $sysWorker : 4D:C1709.SystemWorker
	$sysWorker:=This:C1470._sysWorker
	
	If ($sysWorker#Null:C1517)
		$sysWorker.terminate()
		$sysWorker.wait(2)
		This:C1470._sysWorker:=Null:C1517
	End if 
	
	
Function isRunning() : Boolean
	var $state : Integer
	$state:=Process state:C330(Process number:C372(This:C1470._WORKER_ID))
	return (($state=Executing:K13:4) || ($state=Waiting for user event:K13:9))
	