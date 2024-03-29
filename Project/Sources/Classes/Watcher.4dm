/* cs.Watcher
----------------------------------------------------------------
Launches and maintains a 4D.SystemWorker which itself calls a OS-native file
watcher backend, specialized for 4D apps. The 4D.SystemWorker gets wrapped
into a regular 4D Worker.
---------------------------------------------------------------- */

Class constructor($config : cs.WatcherConfig)
	This._WORKER_ID:="filewatcher"
	This._config:=$config
	
	
Function run()
/* ----------------------------------------------------------------
Launches worker process, asynchronously wrapping the backend application.
Warning: We must use a predefined $this variable here, being
captured by Formula().
Formula(This._launchBackend.run()) would otherwise lead to
a RTE (as of 4Dv19.R6HF2).
---------------------------------------------------------------- */
	var $this : cs.Watcher
	$this:=This
	
	CALL WORKER(This._WORKER_ID; Formula($this._launchBackend()))
	// Block and wait until process ready.
	While (Not(This.isRunning()))
	End while 
	
	// TODO: Timing issue, we loose some callbacks at the next CALL WORKER command otherwise.
	DELAY PROCESS(Current process; 1)
	
	CALL WORKER(This._WORKER_ID; Formula($this._requestBackendVersion()))
	
	
Function _launchBackend()
/* ----------------------------------------------------------------
CALL WORKER target!
Creates and runs a new 4D.SystemWorker reposnsible for async backend handling.
At the end we'll have one new 4D process which spawns a new 4D.Systemworker
on the same 4D process but async.
---------------------------------------------------------------- */
	If (Not(Asserted(OB Is shared(This._config); \
		"This._config (injected into constructor) must be a shared instance, otherwise "+\
		"you won't be able to use its generated data in other processes but this one, "+\
		"since this one will be spawned with a CALL WORKER statement.")))
		
		return 
	End if 
	
	// Get some code completion by casting:
	var $config : cs.WatcherConfig
	$config:=This._config
	
	// Launch backend; async with callback strategy.
	// For some reason (memory layout?) we cannot use a class property here
	// to hold a reference to the SystemWorker.
	watcherBackendSysWorker:=4D.SystemWorker.new($config.getBackend().path+" "+\
		"-w="+$config.getWatchedDirPlatformPath()+" "+\
		"-t="+String($config.getThrottleSecs())+" "+\
		($config.getQuitOnDeadParentProc() ? "-q" : ""); \
		$config)
	
	// Note: Do not .wait() at this point. Just let it run async.
	
	
Function _requestBackendVersion()
/* ----------------------------------------------------------------
CALL WORKER target!
Instructs backend to spit out some version info.
---------------------------------------------------------------- */
	var $sysWorker : 4D.SystemWorker
	$sysWorker:=watcherBackendSysWorker
	
	If ($sysWorker#Null)
		$sysWorker.postMessage("version"+Char(Line feed))
	End if 
	
	
Function terminate()
/* ----------------------------------------------------------------
Terminates worker process together with the backend application.
Warning: We must use a predefined $this variable here, being
captured by Formula().
Formula(This._terminateBackend()) would otherwise lead to
a RTE (as of 4Dv19.R6HF2).
---------------------------------------------------------------- */
	var $this : cs.Watcher
	$this:=This
	
	CALL WORKER(This._WORKER_ID; Formula($this._terminateBackend()))
	// Block and wait for termination.
	While (This.isRunning())
	End while 
	
	
Function _terminateBackend()
/* ----------------------------------------------------------------
CALL WORKER target!
Core method terminating the filewatcher backend service.
---------------------------------------------------------------- */
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
/* ----------------------------------------------------------------
Returns True if the 4D worker, enclosing the backend app, is up,
else returns False.
---------------------------------------------------------------- */
	var $state : Integer
	$state:=Process state(Process number(This._WORKER_ID))
	return (($state=Executing) || ($state=Waiting for user event))
	
	
Function getWorkerProcessMode() : Integer
/* ----------------------------------------------------------------
Returns a bit value as Integer, where the two first bits are set.
- Bit 0 returns the visibility property: set to 1 if process is visible,
  and 0 if it is hidden.
- Bit 1 returns the preemptive mode property: set to 1 if process runs in
  preemptive mode, and 0 if it runs in cooperative mode.
	
Example: see https://doc.4d.com/4Dv19R7/4D/19-R7/PROCESS-PROPERTIES.301-5945371.en.html
---------------------------------------------------------------- */
	var $dummyStr : Text
	var $dummyInt; $mode : Integer
	
	PROCESS PROPERTIES(Process number(This._WORKER_ID); $dummyStr; $dummyInt; $dummyInt; $mode)
	return $mode
	