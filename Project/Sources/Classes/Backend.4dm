/* cs.Backend

Handles backend "installation" and validation and holds backend paths.
----------------------------------------------------
*/

Class constructor()
	// We need a resolved path here, not 4D-internal relative placeholder stuff, so convert!
	This._BACKEND_DIR:=Folder(\
		Convert path system to POSIX(Folder(fk resources folder).platformPath))\
		.folder("bin")
	
	This._PACKAGE:=This._BACKEND_DIR.file("backend.zip")
	This._BINARY_WIN:=This._BACKEND_DIR.file("filewatcher_backend.exe")
	This._BINARY_MAC:=This._BACKEND_DIR.file("filewatcher_backend")
	
	
Function validatePackage()
	var $isValid : Boolean
	$isValid:=Asserted(This.getDir().exists; "Expected a backend directory, but it does not exist.") && \
		Asserted(This._PACKAGE.exists; "Expected a backend package (zip), but it does not exist.")
	
	If (Not($isValid))
		// YEP, we do use ABORT outside an ERR HANDLER.
		// We want to break the call chain since we're unable to
		// recover when the backend package does not exist.
		ABORT
	End if 
	
	
Function validateInstallation()
	var $isValid : Boolean
	$isValid:=Asserted(This.getPlatformBinary().exists; "Expected a backend binary, but it does not exist.")
	
	If (Not($isValid))
		// See comment in .validatePackage()
		ABORT
	End if 
	
	
Function install()
	var $packageContent : Object
	var $binaries : Collection
	var $binary : 4D.File
	
	$packageContent:=ZIP Read archive(This._PACKAGE)
	$binaries:=$packageContent.root.files()
	
	For each ($binary; $binaries)
		$binary.copyTo(This.getDir())
	End for each 
	
	
Function uninstall()
	var $binary : 4D.File
	$binary:=This._BINARY_WIN  // Feed 4D parser bastard with a type-hint
	$binary.delete()
	$binary:=This._BINARY_MAC  // dito
	$binary.delete()
	
	
Function getDir() : 4D.Folder
	return This._BACKEND_DIR
	
	
Function getPlatformBinary() : 4D.File
	return Is Windows ? This._BINARY_WIN : This._BINARY_MAC
	