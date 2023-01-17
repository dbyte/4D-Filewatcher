/* cs.BackendInstallMac

macOS-bound implementation for cs.BackendInstall.
Handles "installation" and validation and holds backend paths.
-------------------------------------------------------------------
*/

Class extends BackendInstall


Class constructor()
	Super()
	
	
Function install()
/* ----------------------------------------------------------------
@override
	
Currently simply extracts the macOS executable from an existing archive.
Note that we also overwrite/extract the binary for Windows here for
convenience, but do not expect it to be valid.
	
We could also use ZIP Read archive() here, since 4D's implementation 
of zip for macOS currently seems to drop the macOS quarantine flag
(tested on 4Dv19R7.100256) -- in opposite to macOS Finder or the "zip"
command line tool coming with macOS.
	
But as noted here ...
https://discuss.4d.com/t/tip-configurable-4d-file-directory-watcher-with-native-backend/25996/4
... we should not rely on this 4D implementation being preserved.
	
Therefore, we're gaining back control, throwing overboard another
obviously (in-depth) undocumented, mysteeeerious 4D command, implementing the
macOS-specific standard tool "ditto". It provides explicit parameters to
discard the quarantine flag and is documented. It just does the same on macOS
but more explicitly.
	
See also: https://ss64.com/osx/ditto.html
---------------------------------------------------------------- */
	var $sysWorker : 4D.SystemWorker
	
	$sysWorker:=4D.SystemWorker.new("ditto -x -k --noqtn --sequesterRsrc"+\
		Char(Space)+\
		Char(Double quote)+This.getPackage().path+Char(Double quote)+\
		Char(Space)+\
		Char(Double quote)+This.getDir().path+Char(Double quote))\
		.wait(3)
	
	If (Not(Asserted($sysWorker.exitCode=0)))
		// Consider checking $sysWorker.errors at this point.
		// And yep... we do use ABORT outside an ERR HANDLER.
		// We want to break the call chain since we're unable to
		// recover at this point.
		ABORT
	End if 
	
	
Function getBinary() : 4D.File
/* ----------------------------------------------------------------
@override
	
Returns 4D.File object to the macOS binary executable.
---------------------------------------------------------------- */
	return This._BACKEND_DIR.file("filewatcher_backend")
	