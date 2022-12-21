/* cs.Watcher
----------------------------------------------------------------
xxxxx
---------------------------------------------------------------- */

Class constructor()
	// Warning: Injecting $config as a shared instance at construction-time
	// does not work as of 4Dv19.R6HF2.283927 (but no RTE is thrown):
	// Class constructor($config : cs.WatcherConfig)
	// This._config:=Null  //$config
	
	This:C1470._worker:=Null:C1517
	
	
Function run()
	// Note: However, injecting $config as a shared instance at
	// call-time WOULD work :
	// Function run($config : cs.WatcherConfig)
	// Use(This)
	//   This._config:=$config
	// End use
	
	var $config : cs:C1710.WatcherConfig
	// Cast for code completion and shorten calls
	$config:=cs:C1710.Singletons.new().getSharedConfig()
	
	Use (This:C1470)
		This:C1470._worker:=OB Copy:C1225(4D:C1709.SystemWorker.new($config.getBackend().path+" "+$config.getWatchedDir().path; $config); ck shared:K85:29)
	End use 
	This:C1470.getWorker().closeInput()
	
	
Function getWorker() : 4D:C1709.SystemWorker
	return This:C1470._worker
	