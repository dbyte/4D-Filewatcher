/* cs.Watcher
----------------------------------------------------------------
Maintains 4D.SystemWorker which itself calls a OS-native file watcher backend.
---------------------------------------------------------------- */

Class constructor($config : cs:C1710.WatcherConfig)
	This:C1470._config:=$config
	This:C1470._sysWorker:=Null:C1517
	
	
Function run()
	// Get some code completion by casting.
	var $config : cs:C1710.WatcherConfig
	$config:=This:C1470._config
	
	If (Not:C34(Asserted:C1132(OB Is shared:C1759(This:C1470._config); \
		"This._config (injected in constructor) must be a shared instance, otherwise "+\
		"you won't be able to use its generated data in other processes but this one - "+\
		"if this one was constructed with a CALL WORKER statement.")))
		
		return 
	End if 
	
	// Run external program; async with callback strategy, but same process.
	Use (This:C1470)
		This:C1470._sysWorker:=OB Copy:C1225(4D:C1709.SystemWorker.new($config.getBackend().path+" "+$config.getWatchedDir().path; $config); ck shared:K85:29)
	End use 
	// $sysWorker.closeInput()
	
	
Function terminate()
	var $sysWorker : 4D:C1709.SystemWorker
	$sysWorker:=This:C1470._sysWorker
	
	If ($sysWorker#Null:C1517)
		$sysWorker.terminate()
		$sysWorker.wait(2)
		This:C1470._sysWorker:=Null:C1517
	End if 
	