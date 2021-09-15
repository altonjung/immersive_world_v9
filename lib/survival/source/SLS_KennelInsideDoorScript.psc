Scriptname SLS_KennelInsideDoorScript extends ObjectReference  

Event OnActivate(ObjectReference akActionRef)
	If !Self.IsLocked() && akActionRef == Game.GetPlayer() && Menu.KennelFollowerToggle
		Utility.Wait(3.0) ; Give time to animate door and transition
		Int i = 0
		ReferenceAlias FollowerAlias
		While i < _SLS_FollowerSearch.GetNumAliases()
			FollowerAlias = (_SLS_FollowerSearch.GetNthAlias(i) as ReferenceAlias)
			If FollowerAlias.GetReference() == None
				i = _SLS_FollowerSearch.GetNumAliases()
			Else
				(FollowerAlias as SLS_KennelFollowerDisable).EnableFollower()
				If (Utility.GetCurrentGameTime() * 24.0) - (StorageUtil.GetFloatValue(None, "_SLS_KennelEnterTime") * 24.0) >= 6.0
					Util.RestoreDeviousFollowerLives()
					Debug.Notification((FollowerAlias.GetReference() as Actor).GetBaseObject().GetName() + ": Wow. You look like hell")
				EndIf
			EndIf
			i += 1
		EndWhile
		_SLS_FollowerSearch.Stop()
	EndIf
EndEvent

Event OnLoad()
	Utility.Wait(5.0) ; Wait for slave to be placed etc
	_SLS_KennelSlavesQuest.Start()
EndEvent

Event OnUnload()
	_SLS_KennelSlavesQuest.Stop()
EndEvent

Quest Property _SLS_FollowerSearch Auto
Quest Property _SLS_KennelSlavesQuest Auto

SLS_Utility Property Util Auto
SLS_Mcm Property Menu Auto
