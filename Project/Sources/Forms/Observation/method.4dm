/* FM: Observation

xxxxx
----------------------------------------------------
*/

If (Form event code:C388=On Load:K2:1)
	// Prepare refreshing listbox collection
	SET TIMER:C645(60*2)
End if 

If (Form event code:C388=On Timer:K2:25)
	// Refresh listbox collection as suggested at
	// https://discuss.4d.com/t/redrawing-a-collection-in-a-listbox/14455/2
	// Bad design but... 4D
	Use (Form:C1466.events)
		Form:C1466.events:=Form:C1466.events
	End use 
End if 
