//%attributes = {}
/* PM: launch
----------------------------------------------------------------
Main method. Prepares and launches the monitor view controller and
its view with some defaults.
---------------------------------------------------------------- */

// Do a clean "install"
var $backend : cs.Backend
$backend:=cs.Backend.new()
$backend.validatePackage()
$backend.uninstall()
$backend.install()
$backend.validateInstallation()

// Configure
var $pathToWatchedDir : 4D.Folder
$pathToWatchedDir:=Is Windows ? (Folder("C:"; fk platform path)) : (Folder("/"; fk posix path))

var $config : cs.WatcherConfig
$config:=cs.WatcherConfig.new()\
.withWatchedDir($pathToWatchedDir)\
.withBackend($backend.getPlatformBinary())\
.withThrottleSecs(1)

// Run
cs.MonitorViewController.new($config).showView()
