Scriptname SLS_CellDoorScript extends ObjectReference  

Event OnLoad()
	Self.BlockActivation()
EndEvent

Int DoorState = 0 ; 0 - Closed Locked, 1 - Closed Unlocked, 2 - Open, 

Event OnActivate(ObjectReference akActionRef)
	If akActionRef == PlayerRef
	
		If Self.GetOpenState() == 1
			Self.Activate(PlayerRef, true)
			DoorState = 1

		ElseIf Self.GetOpenState() == 3 && PlayerRef.GetItemCount(_SLS_CellKey) > 0 && !Self.IsLocked() && DoorState == 1
			Self.SetLockLevel(255)
			Self.Lock(true)
			_SLS_KennelGateUnlock.Play(Self)
			Debug.Notification("You lock the gate")
			DoorState = 0
			
		ElseIf Self.GetOpenState() == 3 && PlayerRef.GetItemCount(_SLS_CellKey) > 0 && Self.IsLocked() && DoorState == 0
			Self.Lock(false)
			Self.Activate(PlayerRef, true)
			DoorState = 2
		EndIf
	EndIf
EndEvent

Actor Property PlayerRef Auto
Key Property _SLS_CellKey Auto
Sound Property _SLS_KennelGateUnlock Auto