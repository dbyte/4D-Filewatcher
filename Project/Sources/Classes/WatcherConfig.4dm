/* cs.WatcherConfig
----------------------------------------------------------------
Enriched wrapper around 4D system worker "options" constructor parameter.
Also handles the system worker's callbacks, which is not SOC - todo.
---------------------------------------------------------------- */

Class constructor()
	// 4D.SystemWorker args for constructor param "options". Note that the
	// args have fixed names.
	This:C1470.dataType:="text"
	This:C1470.data:=""
	This:C1470.dataError:=""
	This:C1470.encoding:="UTF-8"
	
	This:C1470.events:=New collection:C1472()
	
	// Enriched settings
	This:C1470._backend:=Null:C1517
	This:C1470._watchedDir:=Null:C1517
	This:C1470._throttleSecs:=1
	
	// mark: - Callbacks
	// The follwing methods have fixed callback signatures,
	// See also: https://doc4d.github.io/docs/19-R6/API/SystemWorkerClass
	
Function onResponse($worker : 4D:C1709.SystemWorker)
	This:C1470._collect("--\tWatcher backend: messages closed\t--")
	
	
Function onData($worker : 4D:C1709.SystemWorker; $info : Object)
	This:C1470._collect($info.data)
	
	
Function onDataError($worker : 4D:C1709.SystemWorker; $info : Object)
	This:C1470._collect($info.data)
	
	
Function onError($worker : 4D:C1709.SystemWorker; $info : Object)
	This:C1470._collect($info.data)
	
	
Function onTerminate($worker : 4D:C1709.SystemWorker)
	This:C1470._collect("--\tWatcher backend: terminated\t--")
	
	// mark: - Enriched settings builder
	
Function withWatchedDir($pathToDir : 4D:C1709.Folder) : cs:C1710.WatcherConfig
	This:C1470._watchedDir:=$pathToDir
	return This:C1470
	
	
Function withBackend($pathToBinary : 4D:C1709.File) : cs:C1710.WatcherConfig
	This:C1470._backend:=$pathToBinary
	return This:C1470
	
	
Function withThrottleSecs($seconds : Integer) : cs:C1710.WatcherConfig
	This:C1470._throttleSecs:=$seconds
	return This:C1470
	
	// mark: - Helpers
	
Function _collect($message : Text)
	var $events : Collection
	$events:=This:C1470.events
	
	var $parts : Collection
	$parts:=Split string:C1554($message; Char:C90(9); sk ignore empty strings:K86:1+sk trim spaces:K86:2)
	
	var $event : Object
	$event:=New object:C1471()
	
	If ($parts.count()>=3)
		$event.timestamp:=$parts[0]
		$event.kind:=$parts[1]
		$event.filesystemItem:=$parts[2]
	Else 
		$event.timestamp:="--"
		$event.kind:="Error "+cs:C1710.WatcherConfig.name+": Expected min. 3 data items, got "+String:C10($parts.count())
		$event.filesystemItem:="--"
	End if 
	
	$events.push(OB Copy:C1225($event; ck shared:K85:29))
	
	// mark: - Getters
	
Function getWatchedDir() : 4D:C1709.Folder
	return This:C1470._watchedDir
	
	
Function getBackend() : 4D:C1709.File
	return This:C1470._backend
	
	
Function getThrottleSecs() : Integer
	return This:C1470._throttleSecs
	