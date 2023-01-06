//%attributes = {}
/* PM: launch
----------------------------------------------------------------
Prepares and launches the monitor view controller and its view.
---------------------------------------------------------------- */

var $backendBinary : Text
var $pathToBackend : 4D.File
var $pathToWatchedDir : 4D.Folder

$backendBinary:=Is Windows ? "filewatcher_backend.exe" : "filewatcher_backend"
$pathToWatchedDir:=Is Windows ? (Folder("C:"; fk platform path)) : (Folder("/"; fk posix path))
$pathToBackend:=Folder(Convert path system to POSIX(Folder(fk resources folder).platformPath))\
.folder("bin")\
.file($backendBinary)

var $config : cs.WatcherConfig
$config:=cs.WatcherConfig.new()\
.withWatchedDir($pathToWatchedDir)\
.withBackend($pathToBackend)\
.withThrottleSecs(1)

cs.MonitorViewController.new($config).openView()
