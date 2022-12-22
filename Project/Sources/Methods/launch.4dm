//%attributes = {}
/* PM: launch
----------------------------------------------------------------
A worker process launcher which spawns a thread for a 4D.SystemWorker.
So at the end we have 2 running workers
---------------------------------------------------------------- */

var $backendBinary : Text
var $pathToBackend : 4D:C1709.File
var $pathToWatchedDir : 4D:C1709.Folder

$backendBinary:=Is Windows:C1573 ? "filewatcher.exe" : "filewatcher"
$pathToWatchedDir:=Folder:C1567("/Users/tammo/Development/Projects/4D/VM/VM-Sources/VM-Current")
$pathToBackend:=Folder:C1567(Convert path system to POSIX:C1106(Folder:C1567(fk resources folder:K87:11).platformPath))\
.folder("bin")\
.file($backendBinary)

var $config : cs:C1710.WatcherConfig
$config:=cs:C1710.WatcherConfig.new()\
.withWatchedDir($pathToWatchedDir)\
.withBackend($pathToBackend)

cs:C1710.MonitorViewController.new($config).openView()
