/* cs.WatcherConfig
----------------------------------------------------------------
Enriched wrapper around 4D system worker "options" constructor parameter.
---------------------------------------------------------------- */

Class constructor()
	// 4D.SystemWorker args for constructor param "options". Note that the
	// args have fixed names.
	This:C1470.dataType:="text"
	This:C1470.data:=""
	This:C1470.dataError:=""
	This:C1470.encoding:="UTF-8"
	
	// Property must be shared for use in other processes!
	This:C1470.events:=New shared collection:C1527()
	
	// Enriched settings
	This:C1470._watchedDir:=Null:C1517
	This:C1470._backend:=Null:C1517
	
	// mark: - Callbacks
	// The follwing methods have fixed callback signatures,
	// See also: https://doc4d.github.io/docs/19-R6/API/SystemWorkerClass
	
Function onResponse($worker : 4D:C1709.SystemWorker)
	This:C1470._printNewLine("onResponse called")
	
	
Function onData($worker : 4D:C1709.SystemWorker; $info : Object)
	This:C1470._collect($info.data)
	This:C1470._printNewLine("onData called: "+$info.data)
	
	
Function onDataError($worker : 4D:C1709.SystemWorker; $info : Object)
	This:C1470._printNewLine("onDataError called: "+$info.data)
	
	
Function onError($worker : 4D:C1709.SystemWorker; $info : Object)
	// Not implemented.
	
	
Function onTerminate($worker : 4D:C1709.SystemWorker)
	This:C1470._printNewLine("onTerminate called, result code: "+String:C10($worker.exitCode))
	
	
	// mark: - Enriched settings builder
	
Function withWatchedDir($pathToDir : 4D:C1709.Folder) : cs:C1710.WatcherConfig
	This:C1470._watchedDir:=$pathToDir
	return This:C1470
	
	
Function withBackend($pathToBinary : 4D:C1709.File) : cs:C1710.WatcherConfig
	This:C1470._backend:=$pathToBinary
	return This:C1470
	
	// mark: - Helpers
	
Function _collect($message : Text)
	var $events : Collection
	$events:=This:C1470.events
	
	var $event : Object
	$event:=New object:C1471()
	
	$event.kind:="ToDo"
	$event.timestamp:="2023-12-20-todo"
	$event.filesystemItem:=$message
	
	$events.push(OB Copy:C1225($event; ck shared:K85:29))
	
Function _printNewLine($message : Text)
	// This.data:=$message+Char(Carriage return)
	// Open window(50; 50; 500; 250; 5; "Operation läuft")
	// MESSAGE(This.data)
	
	// mark: - Getters
	
Function getWatchedDir() : 4D:C1709.Folder
	return This:C1470._watchedDir
	
	
Function getBackend() : 4D:C1709.File
	return This:C1470._backend