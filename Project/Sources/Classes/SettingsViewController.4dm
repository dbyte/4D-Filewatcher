/* cs.SettingsViewController

View controller for SettingsView.
----------------------------------------------------
*/

Class constructor($config : cs.WatcherConfig)
	This._VIEW_NAME:="SettingsView"
	
	This._viewRef:=Null
	This._config:=$config
	This._formData:=New object()
	This._formData.watchedDirEntryField:=$config.getWatchedDirPlatformPath()
	This._formData.throttleSecs:=$config.getThrottleSecs()
	
	
Function showView()
/* ----------------------------------------------------------------
Shows the "Settings" view.
---------------------------------------------------------------- */
	
	// mark: - Will appear
	
	var $config : cs.WatcherConfig
	$config:=This._config
	
	This._viewRef:=Open form window(String(This._VIEW_NAME); Sheet form window)
	DIALOG(This._VIEW_NAME; This._formData)
	
	// mark: - Did disappear
	
	If (OK=0)
		// User cancelled dialogue.
		return 
	End if 
	
	// mark: - Validation
	
	var $errMsgOnInvalidInput : Text
	$errMsgOnInvalidInput:=This._validateInput()
	
	If ($errMsgOnInvalidInput="")
		This._modifySettings()
		return 
	End if 
	
	// Offers new attempt on invalid input. Not the most comfortable UX,
	// but straight forward and crisp (-;
	If (This._confirmRetry($errMsgOnInvalidInput))
		CLOSE WINDOW(This._viewRef)
		This.showView()
	End if 
	
	// mark: - Private helpers
	
Function _modifySettings()
/* ----------------------------------------------------------------
At the point calling this method, user input is expected to
have been validated successfully.
---------------------------------------------------------------- */
	var $config : cs.WatcherConfig
	$config:=This._config  // Feed 4D parser bastard with a type-hint
	
	Use ($config)
		$config.withWatchedDir(This._watchedDirToPlatformPath())
		$config.withThrottleSecs(Num(This._formData.throttleSecs))
	End use 
	
	
Function _validateInput() : Text
	If (This._formData.watchedDirEntryField="")
		BEEP
		return "You must specify a directory being watched."
	End if 
	
	If ((Position("."; This._formData.watchedDirEntryField)=1) || \
		(Position(".."; This._formData.watchedDirEntryField)>0))
		BEEP
		return "You have defined a relative POSIX path. Please define an absolute path."
	End if 
	
	If (Not(This._watchedDirToPlatformPath().exists))
		BEEP
		return "Directory '"+This._formData.watchedDirEntryField+"' does not exist."
	End if 
	
	// Input considered to be valid.
	return ""
	
	
Function _confirmRetry($errMsg : Text)->$isConfirmed : Boolean
/* ----------------------------------------------------------------
Displays confirmation dialogue with an error message and whether
the user wants to retry the input or not.
---------------------------------------------------------------- */
	CONFIRM($errMsg; "Retry"; "Cancel")
	$isConfirmed:=OK=1
	
	
Function _watchedDirToPlatformPath()->$platformPath : 4D.Folder
/* ----------------------------------------------------------------
Workaround for sloppy backwards 4D handling of macOS platform path.
macOS speaks POSIX paths for years.
---------------------------------------------------------------- */
	If (Is Windows)
		$platformPath:=Folder(This._formData.watchedDirEntryField; fk platform path)
	Else 
		$platformPath:=Folder(This._formData.watchedDirEntryField; fk posix path)
	End if 
	