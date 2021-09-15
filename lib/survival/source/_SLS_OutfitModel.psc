Scriptname _SLS_OutfitModel extends Actor  

Event OnInit()
	Self.BlockActivation()
	;AddIventoryEventFilter(_SLS_EmptyAlways)
EndEvent

Event OnActivate(ObjectReference akActionRef)
	Self.OpenInventory(abForceOpen = true)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	If akBaseItem as Armor
		Self.EquipItem(akBaseItem)
	EndIf
EndEvent

;Formlist Property _SLS_EmptyAlways Auto