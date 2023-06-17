//%attributes = {}
/* PM: launch
----------------------------------------------------------------
Main method. Prepares and launches the monitor view controller and
its view with some defaults.
---------------------------------------------------------------- */

// Run a clean "install" for the current platform
var $backend : cs.BackendInstall
$backend:=Is Windows ? cs.BackendInstallWin.new() : cs.BackendInstallMac.new()
$backend.validatePackage()
$backend.uninstall()
$backend.install()
$backend.validateInstallation()

// Configure
var $pathToWatchedDir : 4D.Folder
$pathToWatchedDir:=Is Windows ? Folder("C:"; fk platform path) : Folder("/"; fk posix path)

var $config : cs.WatcherConfig
$config:=cs.WatcherConfig.new()\
.withWatchedDir($pathToWatchedDir)\
.withBackend($backend.getBinary())\
.withThrottleSecs(1)\
.withQuitOnDeadParentProc(True)

// Run main app
cs.MonitorViewController.new($config).showView()
