Scriptname SLS_TollGuard extends ObjectReference

ReferenceAlias Property AssociatedDoor Auto

Function PaidGuard()
	;SLS_TollGate TDoor = AssociatedDoor as SLS_TollGate
	TollUtil.TollPaid(AssociatedDoor.GetReference(), false)
EndFunction

Event OnActivate(ObjectReference akActionRef)
;/
	TollUtil.IsCurfewTime()
	TollUtil.IsGrounded(-1, Self)
	TollUtil.TollHasEnoughFollowers()
	/;
	TollUtil.GuardActivate(Self)
EndEvent

_SLS_TollUtil Property TollUtil Auto
