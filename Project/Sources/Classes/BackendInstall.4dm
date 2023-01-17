/* cs.BackendInstall

Platform agnostic, base implementation for the installation of the
backend executables. Implementations should be able to handle backend
"installation" and validation.

Do not instantiate this class directly. Do not call its member functions
directly. Always use an instance of a concrete inherited class in consumers.
-------------------------------------------------------------------
*/

Class constructor()
	// We need a resolved path here, not 4D-internal relative placeholder
	// stuff, so convert!
	This._BACKEND_DIR:=Folder(\
		Convert path system to POSIX(Folder(fk resources folder).platformPath))\
		.folder("bin")
	
	This._PACKAGE:=This._BACKEND_DIR.file("backend.zip")
	
	// mark: - Installer API
	
Function validatePackage()
	var $isValid : Boolean
	$isValid:=Asserted(This.getDir().exists; \
		"Expected a backend directory, but it does not exist.") && \
		Asserted(This.getPackage().exists; \
		"Expected a backend package (zip), but it does not exist.")
	
	If (Not($isValid))
		// YEP, we do use ABORT outside an ERR HANDLER.
		// We want to break the call chain since we're unable to
		// recover when the backend package does not exist.
		ABORT
	End if 
	
	
Function validateInstallation()
/* ----------------------------------------------------------------
Currently simply checks if platform specific executable has
been extracted as expected.
---------------------------------------------------------------- */
	var $isValid : Boolean
	$isValid:=Asserted(This.getBinary().exists; \
		"Expected a backend binary, but it does not exist.")
	
	If (Not($isValid))
		// See comment in .validatePackage()
		ABORT
	End if 
	
	
Function install()
/* ----------------------------------------------------------------
@abstract
	
Currently simply extracts the executable from an existing archive.
Must be implemented in platform-bound inheritors.
---------------------------------------------------------------- */
	ASSERT(False; \
		"Not implemented. Use an inherited instance when calling this method.")
	
	
Function uninstall()
/* ----------------------------------------------------------------
Currently simply deletes the current platform's backend executable.
---------------------------------------------------------------- */
	This.getBinary().delete()
	
	
Function getPackage() : 4D.File
/* ----------------------------------------------------------------
Returns the property holding a resolved path to the "installer" package,
enclosing all needed backend items, as A TYPED 4D.File instance.
HELLO 4D, as A TYPED instance. HELLO 4D, as A TYPED instance.
HELLO 4D, as A TYPED instance.
---------------------------------------------------------------- */
	return This._PACKAGE
	
	
Function getDir() : 4D.Folder
/* ----------------------------------------------------------------
Returns the resolved path to the root directory of all the backend
items as A TYPED 4D.Folder instance.
HELLO 4D, as A TYPED instance. HELLO 4D, as A TYPED instance.
HELLO 4D, as A TYPED instance.
---------------------------------------------------------------- */
	return This._BACKEND_DIR
	
	
Function getBinary() : 4D.File
/* ----------------------------------------------------------------
@abstract
	
Returns 4D.File object to the binary executable.
Must be implemented in platform-bound inheritors.
---------------------------------------------------------------- */
	ASSERT(False; \
		"Not implemented. Use an inherited instance when calling this method.")
	