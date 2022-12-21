/* cs.Watcher
----------------------------------------------------------------
Maintains 4D.SystemWorker which itself calls a OS-native file watcher backend.
---------------------------------------------------------------- */

Class constructor()
	// Warning: Injecting $config as a shared instance at construction-time
	// does not work as of 4Dv19.R6HF2.283927 (but no RTE is thrown):
	// Class constructor($config : cs.WatcherConfig)
	// This._config:=Null  //$config
	
	This:C1470._sysWorker:=Null:C1517
	
	
Function run()
	// Note: However, injecting $config as a shared instance at
	// call-time WOULD work :
	// Function run($config : cs.WatcherConfig)
	// Use(This)
	//   This._config:=$config
	// End use
	
	var $config : cs:C1710.WatcherConfig
	// Cast for code completion and shorten calls
	$config:=cs:C1710.Shared.new().getConfig()
	
	Use (This:C1470)
		This:C1470._sysWorker:=OB Copy:C1225(4D:C1709.SystemWorker.new($config.getBackend().path+" "+$config.getWatchedDir().path; $config); ck shared:K85:29)
	End use 
	// This._getSysWorker().closeInput()
	
	
Function terminateBackend()
	var $sysWorker : 4D:C1709.SystemWorker
	$sysWorker:=This:C1470._getSysWorker()
	
	If ($sysWorker#Null:C1517)
		$sysWorker.terminate()
		$sysWorker.wait(2)
		Use (This:C1470)
			This:C1470._sysWorker:=Null:C1517
		End use 
	End if 
	
	
Function _getSysWorker() : 4D:C1709.SystemWorker
	// Get some code completion in callers.
	return This:C1470._sysWorker
	