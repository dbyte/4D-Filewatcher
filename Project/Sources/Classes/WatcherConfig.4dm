/* cs.WatcherConfig
----------------------------------------------------------------
Enriched wrapper around 4D system worker "options" constructor parameter.
Also handles the system worker's callbacks, which is not SOC - todo.
---------------------------------------------------------------- */

Class constructor()
	// 4D.SystemWorker args for constructor param "options". Note that the
	// args have fixed names.
	This.dataType:="text"
	This.data:=""
	This.dataError:=""
	This.encoding:="UTF-8"
	
	This.events:=New collection()
	
	// Enriched settings
	This._backend:=Null
	This._watchedDir:=Null
	This._throttleSecs:=1
	
	// mark: - Callbacks
	// The follwing methods have fixed callback signatures,
	// See also: https://doc4d.github.io/docs/19-R6/API/SystemWorkerClass
	
Function onResponse($worker : 4D.SystemWorker)
	This._collect("--\tWatcher closed.\t--")
	
	
Function onData($worker : 4D.SystemWorker; $info : Object)
	This._collect($info.data)
	
	
Function onDataError($worker : 4D.SystemWorker; $info : Object)
	This._collect($info.data)
	
	
Function onError($worker : 4D.SystemWorker; $info : Object)
	This._collect($info.data)
	
	
Function onTerminate($worker : 4D.SystemWorker)
	This._collect("--\tWatcher terminated.\t--")
	
	// mark: - Enriched settings builder
	
Function withWatchedDir($pathToDir : 4D.Folder) : cs.WatcherConfig
	This._watchedDir:=$pathToDir
	return This
	
	
Function withBackend($pathToBinary : 4D.File) : cs.WatcherConfig
	This._backend:=$pathToBinary
	return This
	
	
Function withThrottleSecs($seconds : Integer) : cs.WatcherConfig
	This._throttleSecs:=$seconds
	return This
	
	// mark: - Helpers
	
Function _collect($message : Text)
	var $events : Collection
	$events:=This.events
	
	var $parts : Collection
	$parts:=Split string($message; Char(9); sk ignore empty strings+sk trim spaces)
	
	var $event : Object
	$event:=New object()
	
	If ($parts.count()>=3)
		$event.timestamp:=$parts[0]
		$event.kind:=$parts[1]
		$event.filesystemItem:=$parts[2]
	Else 
		$event.timestamp:="--"
		$event.kind:="Error "+cs.WatcherConfig.name+": Expected min. 3 data items, got "+String($parts.count())
		$event.filesystemItem:="--"
	End if 
	
	$events.push(OB Copy($event; ck shared))
	
	// mark: - Getters
	
Function getWatchedDirPlatformPath()->$pathAsString : Text
	// This is the REAL platform path format (not the one abstracted
	// by 4D .platformPath): Backslashed for Windows, POSIX for macOS.
	var $watchedDir : 4D.Folder
	$watchedDir:=This._watchedDir
	
	If (Is Windows)
		$pathAsString:=$watchedDir.platformPath
	Else 
		$pathAsString:=$watchedDir.path
	End if 
	
	
Function getBackend() : 4D.File
	return This._backend
	
	
Function getThrottleSecs() : Integer
	return This._throttleSecs
	