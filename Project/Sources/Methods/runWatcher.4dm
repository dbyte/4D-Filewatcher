//%attributes = {}
/* PM: runWatcher
----------------------------------------------------------------
A worker process launcher which spawns a thread for a 4D.SystemWorker.
So at the end we have 2 running workers
---------------------------------------------------------------- */

var $singletons : cs:C1710.Singletons
$singletons:=cs:C1710.Singletons.new()

CALL WORKER:C1389("filewatcher"; Formula:C1597($singletons.getSharedWatcher().run()))

// mark: -

var $winRef : Integer
$winRef:=Open form window:C675("Observation"; Palette form window:K39:9)
SHOW WINDOW:C435($winRef)
DIALOG:C40("Observation"; $singletons.getSharedConfig())

$singletons.getSharedWatcher().getWorker().terminate()
KILL WORKER:C1390("filewatcher")
