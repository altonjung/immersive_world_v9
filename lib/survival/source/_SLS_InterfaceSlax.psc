Scriptname _SLS_InterfaceSlax extends Quest  

Int Property SlaVersion = -1 Auto Hidden

Quest SlaConfigQuest

Keyword Property SlaBikiniKeyword Auto Hidden
Keyword Property _SLS_UnusedDummyKw Auto

Event OnInit()
	RegisterForModEvent("_SLS_Int_PlayerLoadsGame", "On_SLS_Int_PlayerLoadsGame")
EndEvent

Event On_SLS_Int_PlayerLoadsGame(string eventName, string strArg, float numArg, Form sender)
	PlayerLoadsGame()
EndEvent

Function PlayerLoadsGame()
	If Game.GetModByName("SexLabAroused.esm") != 255
		If GetState() != "Installed"
			GoToState("Installed")
		EndIf
	
	Else
		If GetState() != ""
			GoToState("")
		EndIf
	EndIf
	If GetState() == "Installed"
		SlaVersion = GetVersion()
	Else
		SlaVersion = -1
	EndIf
EndFunction

Event OnEndState()	
	Utility.Wait(5.0) ; Wait before entering active state to help avoid making function calls to scripts that may not have initialized yet.
	SlaConfigQuest = Game.GetFormFromFile(0x01C6E0, "SexLabAroused.esm") as Quest
	If GetVersion() >= 29
		SlaBikiniKeyword = Game.GetFormFromFile(0x08E854, "SexLabAroused.esm") as Keyword
	Else
		SlaBikiniKeyword = _SLS_UnusedDummyKw
	EndIf
EndEvent

Bool Function GetIsInterfaceActive()
	If GetState() == "Installed"
		Return true
	EndIf
	Return false
EndFunction

State Installed
	Int Function GetVersion()
		Return _SLS_IntSlax.GetVersion(SlaConfigQuest)
	EndFunction
	
	Bool Function WornHasBikiniKeyword(Actor akTarget)
		If SlaVersion >= 29
			Return akTarget.WornHasKeyword(SlaBikiniKeyword)
		EndIf
		Return false
	EndFunction
EndState

Int Function GetVersion()
	Return -1
EndFunction

Bool Function WornHasBikiniKeyword(Actor akTarget)
	Return false
EndFunction
	