Scriptname _SLS_LicFolContrabandCheck extends Quest  

Bool Function GateLicenceCheckFollowers(Bool MustBeLoaded, Int LocationInt)
	GoToState("InProc")
	ObjectReference Follower
	If Game.GetModByName("EFFCore.esm") != 255
		Formlist FollowerList = Game.GetFormFromFile(0x000F53, "EFFCore.esm") as Formlist
		Int i = FollowerList.GetSize()
		While i > 0
			i -= 1
			Follower = FollowerList.GetAt(i) as ObjectReference
			If !MustBeLoaded || (MustBeLoaded && Follower.Is3dLoaded())
				If LicUtil.HasAnyContraband(Follower, LocationInt)
					;Debug.Messagebox("True")
					GoToState("")
					Return true
				EndIf
				
				
				;LicUtil.ConfiscateFollowerAllLics(Follower)
				ObjectReference EffInv = Eff.GetEffInv(Follower)
				If EffInv
					If LicUtil.HasAnyContraband(EffInv, LocationInt)
						GoToState("")
						Return true
					EndIf
				EndIf
			EndIf
		EndWhile
		;Debug.Messagebox("False")
		GoToState("")
		Return false
		
	Else
		Int i = DialogueFollower.GetNumAliases()
		While i > 0
			i -= 1
			Follower = (DialogueFollower.GetNthAlias(i) as ReferenceAlias).GetReference() as ObjectReference
			If Follower
				If !MustBeLoaded || (MustBeLoaded && Follower.Is3dLoaded())
					If LicUtil.HasAnyContraband(Follower, LocationInt)
						GoToState("")
						Return true
					EndIf
				EndIf
			EndIf
		EndWhile
		GoToState("")
		Return false
	EndIf
EndFunction

State InProc
	Bool Function GateLicenceCheckFollowers(Bool MustBeLoaded, Int LocationInt)
		Return false
	EndFunction
EndState

Quest Property DialogueFollower Auto

_SLS_LicenceUtil Property LicUtil Auto
_SLS_InterfaceEff Property Eff Auto
