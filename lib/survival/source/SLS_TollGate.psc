Scriptname SLS_TollGate extends ReferenceAlias  

Bool Property IsInteriorDoor Auto

_SLS_TollUtil Property TollUtil Auto

Event OnCellAttach()
	TollUtil.OnTollDoorAttach(IsInteriorDoor, Self)
	;Debug.Messagebox("Attach: " + Self.GetReference())
EndEvent
;/
Event OnLoad()
	TollUtil.TollDoorLoad(IsInteriorDoor, Self)
EndEvent
/;
Event OnLockStateChanged()
	TollUtil.TollDoorLockStateChange(Self.GetReference(), IsInteriorDoor)
EndEvent
