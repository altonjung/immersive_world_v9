Scriptname _SLS_LicTownCheck extends ReferenceAlias  

Event OnLoad()
	Utility.Wait(1.0)
	LicUtil.SetIsPlayerAiDriven()
	RandomizeEnforcers()
	_SLS_LicTownCheckPlayerAliasQuest.Start()
	LicUtil.SetIsSlaverunFreeTown(TownLoc)
	TownCheckPlayerAliasRelay.DoorLoaded(TownLoc)
EndEvent

Event OnUnload()
	;Debug.Messagebox("Unload")
	_SLS_LicTownCheckPlayerAliasQuest.Stop()
	_SLS_LicTownViolation.SetValueInt(0)
EndEvent

Function RandomizeEnforcers()
	Formlist FlSelect = GetEnforcerList()
	
	; Copy Formlist
	_SLS_LicTownBlank.Revert()
	Int i = FlSelect.GetSize()
	Actor Enforcer
	While i > 0
		i -= 1
		Enforcer = FlSelect.GetAt(i) as Actor
		Enforcer.Enable()
		_SLS_LicTownBlank.AddForm(Enforcer)
	EndWhile
	
	Int EnforcerCount = Utility.RandomInt(Menu.EnforcersMin, Menu.EnforcersMax)
	;Debug.Messagebox("Enforcer Count: " + EnforcerCount)
	While _SLS_LicTownBlank.GetSize() > EnforcerCount
		Enforcer = _SLS_LicTownBlank.GetAt(Utility.RandomInt(0, _SLS_LicTownBlank.GetSize() - 1)) as Actor
		Enforcer.Disable()
		_SLS_LicTownBlank.RemoveAddedForm(Enforcer)
	EndWhile
EndFunction

Formlist Function GetEnforcerList()
	If TownLoc == 5
		Return _SLS_LicTownEnforcersRiverwood
	ElseIf TownLoc == 6
		Return _SLS_LicTownEnforcersFalkreath
	ElseIf TownLoc == 7
		Return _SLS_LicTownEnforcersDawnstar
	ElseIf TownLoc == 8
		Return _SLS_LicTownEnforcersWinterhold
	ElseIf TownLoc == 9
		Return _SLS_LicTownEnforcersRorikstead
	ElseIf TownLoc == 10
		Return _SLS_LicTownEnforcersShorsStone
	ElseIf TownLoc == 11
		Return _SLS_LicTownEnforcersIvarstead
	ElseIf TownLoc == 12
		Return _SLS_LicTownEnforcersDragonBridge
	ElseIf TownLoc == 13
		Return _SLS_LicTownEnforcersMorthal
	ElseIf TownLoc == 14
		Return _SLS_LicTownEnforcersKynesGrove
	EndIf
EndFunction

Int Property TownLoc Auto	; 5- Riverwood, 6 - Falkreath, 7 - Dawnstar, 8 - Winterhold, 9 - Rorikstead
							; 10 - Shors Stone, 11 - Ivarstead, 12 - Dragon Bridge, 13 - Morthal, 14 - Kynesgrove

GlobalVariable Property _SLS_LicTownViolation Auto

Formlist Property _SLS_LicTownEnforcersRiverwood Auto
Formlist Property _SLS_LicTownEnforcersFalkreath Auto
Formlist Property _SLS_LicTownEnforcersDawnstar Auto
Formlist Property _SLS_LicTownEnforcersWinterhold Auto
Formlist Property _SLS_LicTownEnforcersRorikstead Auto
Formlist Property _SLS_LicTownEnforcersShorsStone Auto
Formlist Property _SLS_LicTownEnforcersIvarstead Auto
Formlist Property _SLS_LicTownEnforcersDragonBridge Auto
Formlist Property _SLS_LicTownEnforcersMorthal Auto
Formlist Property _SLS_LicTownEnforcersKynesGrove Auto
Formlist Property _SLS_LicTownBlank Auto

Quest Property _SLS_LicTownCheckPlayerAliasQuest Auto

_SLS_LicTownCheckPlayerAliasRelay Property TownCheckPlayerAliasRelay Auto
_SLS_LicenceUtil Property LicUtil Auto
SLS_Mcm Property Menu Auto
