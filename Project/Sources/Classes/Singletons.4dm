/* PM: Singletons

xxxxx
----------------------------------------------------
*/

Class constructor()
	// noop
	
	
Function _getRootObject() : Object
	Use (Storage:C1525)
		If (Undefined:C82(Storage:C1525._filewatcher))
			Storage:C1525._filewatcher:=New shared object:C1526()
		End if 
	End use 
	return Storage:C1525._filewatcher
	
	
Function getSharedConfig() : cs:C1710.WatcherConfig
	var $root : Object
	$root:=This:C1470._getRootObject()
	
	Use ($root)
		
		If (Undefined:C82($root.config))
			var $pathToBackend : 4D:C1709.File
			var $pathToWatchedDir : 4D:C1709.Folder
			
			$pathToWatchedDir:=Folder:C1567("/Users/tammo/Development/Projects/4D/VM/VM-Sources/VM-Current")
			$pathToBackend:=Folder:C1567(Convert path system to POSIX:C1106(Folder:C1567(fk resources folder:K87:11).platformPath))\
				.folder("bin")\
				.file("filewatcher")
			
			var $config : cs:C1710.WatcherConfig
			$config:=cs:C1710.WatcherConfig.new()\
				.withWatchedDir($pathToWatchedDir)\
				.withBackend($pathToBackend)
			
			$root.config:=OB Copy:C1225($config; ck shared:K85:29; $root)
		End if 
		
	End use 
	return $root.config
	
	
Function getSharedWatcher() : cs:C1710.Watcher
	var $root : Object
	$root:=This:C1470._getRootObject()
	
	Use ($root)
		If (Undefined:C82($root.watcher))
			$root.watcher:=OB Copy:C1225(cs:C1710.Watcher.new(); ck shared:K85:29; $root)
			
			// Warning: Injecting $config as a shared instance at construction-time
			// does not work as of 4Dv19.R6HF2.283927 (but no RTE is thrown):
			// $root.watcher:=OB Copy(cs.Watcher.new(This.getSharedConfig()); ck shared; $root)
		End if 
	End use 
	return $root.watcher
	