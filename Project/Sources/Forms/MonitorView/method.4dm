/* PFM: MonitorView

Form listener for MonitorView.
----------------------------------------------------
*/

Case of 
	: (Form event code:C388=On Load:K2:1)
		// Prepare refreshing listbox collection every 2 seconds.
		SET TIMER:C645(60*2)
		
	: (Form event code:C388=On Timer:K2:25)
		// Force refresh listbox collection view
		Form:C1466.controller.refreshEventsListbox()
End case 
