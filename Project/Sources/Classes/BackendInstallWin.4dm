/* cs.BackendInstallWin

Windows-bound implementation for cs.BackendInstall.
Handles "installation" and validation and holds backend paths.
-------------------------------------------------------------------
*/

Class extends BackendInstall


Class constructor()
	Super()
	
	
Function install()
/* ----------------------------------------------------------------
@override
	
Currently simply extracts the Windows executable from an
existing archive.
---------------------------------------------------------------- */
	var $packageContent : Object
	var $packedBinaries : Collection
	var $packedBinary : 4D.File
	
	$packageContent:=ZIP Read archive(This.getPackage())
	$packedBinaries:=$packageContent.root.files()
	
	For each ($packedBinary; $packedBinaries)
		If ($packedBinary.fullName=This.getBinary().fullName)
			$packedBinary.copyTo(This.getDir(); fk overwrite)
		End if 
	End for each 
	
	
Function getBinary() : 4D.File
/* ----------------------------------------------------------------
@override
	
Returns 4D.File object to the Windows binary executable.
---------------------------------------------------------------- */
	return This._BACKEND_DIR.file("filewatcher_backend.exe")
	