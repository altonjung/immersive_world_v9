Scriptname _SLS_AnimalFriendAlias extends ReferenceAlias  

Bool InGrace = false
Bool ApproachOnLoad = false

Float Property UpdateTime = 0.0 Auto Hidden

Event OnUpdateGameTime()
	Actor Friend = Self.GetReference() as Actor
	If Friend
		If Friend.Is3dLoaded()
			InGrace = false
			ApproachOnLoad = false
			_SLS_AnimalFriendApproachCount.SetValueInt(StorageUtil.GetIntValue(Friend, "_SLS_AnimalFriendApproachCount", missing = 0))
			AnimalFriend.BeginHornyFg(Friend)
		
		Else
			If InGrace
				AnimalFriend.DismissFriend(Self.GetReference() as Actor, MoveHome = true)
			Else
				InGrace = true
				ApproachOnLoad = true
				RegisterForSingleUpdateGameTime(1.0)
			EndIf
		EndIf
	EndIf
EndEvent

Event OnLoad()
	If ApproachOnLoad
		_SLS_AnimalFriendApproachCount.SetValueInt(StorageUtil.GetIntValue(Self.GetReference(), "_SLS_AnimalFriendApproachCount", missing = 0))
		AnimalFriend.BeginHornyFg(Self.GetReference() as Actor)
		ApproachOnLoad = false
		InGrace = false
	EndIf
EndEvent

Event OnDeath(Actor akKiller)
	If akKiller
		Debug.Notification(Self.GetReference().GetBaseObject().GetName() + " was killed by " + akKiller.GetBaseObject().GetName())
	Else
		Debug.Notification(Self.GetReference().GetBaseObject().GetName() + " died")
	EndIf
	InGrace = false
	ApproachOnLoad = false
	UnRegisterForUpdateGameTime()
	Self.Clear()
EndEvent

Function SetUpdate(Float TimeInHours)
	;Debug.Messagebox("TimeInHours: " + TimeInHours)
	UpdateTime = Utility.GetCurrentGameTime() + (TimeInHours / 24.0)
	RegisterForSingleUpdateGameTime(TimeInHours)
EndFunction

GlobalVariable Property _SLS_AnimalFriendApproachCount Auto

_SLS_AnimalFriend Property AnimalFriend Auto
