//%attributes = {}
/* PM: launch
----------------------------------------------------------------
Prepares and launches the monitor view controller and its view.
---------------------------------------------------------------- */

var $backendBinary : Text
var $pathToBackend : 4D:C1709.File
var $pathToWatchedDir : 4D:C1709.Folder

$backendBinary:=Is Windows:C1573 ? "filewatcher_backend.exe" : "filewatcher_backend"
$pathToWatchedDir:=Folder:C1567(Convert path POSIX to system:C1107("."); fk platform path:K87:2)
$pathToBackend:=Folder:C1567(Convert path system to POSIX:C1106(Folder:C1567(fk resources folder:K87:11).platformPath))\
.folder("bin")\
.file($backendBinary)

var $config : cs:C1710.WatcherConfig
$config:=cs:C1710.WatcherConfig.new()\
.withWatchedDir($pathToWatchedDir)\
.withBackend($pathToBackend)

cs:C1710.MonitorViewController.new($config).openView()
