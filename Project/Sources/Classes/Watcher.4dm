/* cs.Watcher
----------------------------------------------------------------
xxxxx
---------------------------------------------------------------- */

Class constructor()
	//Class constructor($config : cs.WatcherConfig)
	//This._config:=$config  //$config
	This:C1470._worker:=Null:C1517
	
	
Function run()
	var $config : cs:C1710.WatcherConfig
	$config:=cs:C1710.Singletons.new().getSharedConfig()
	//$config:=This._config  // cast for code completion
	
	Use (This:C1470)
		This:C1470._worker:=OB Copy:C1225(4D:C1709.SystemWorker.new($config.getBackend().path+" "+$config.getWatchedDir().path; $config); ck shared:K85:29)
	End use 
	This:C1470.getWorker().closeInput()
	
	
Function getWorker() : 4D:C1709.SystemWorker
	return This:C1470._worker
	