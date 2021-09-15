Scriptname _SLS_InterfaceSlso extends Quest

Event OnInit()
	RegisterForModEvent("_SLS_Int_PlayerLoadsGame", "On_SLS_Int_PlayerLoadsGame")
EndEvent

Event On_SLS_Int_PlayerLoadsGame(string eventName, string strArg, float numArg, Form sender)
	PlayerLoadsGame()
EndEvent

Function PlayerLoadsGame()
	If Game.GetModByName("SLSO.esp") != 255
		If GetState() != "Installed"
			GoToState("Installed")
		EndIf
	
	Else
		If GetState() != ""
			GoToState("")
		EndIf
	EndIf
EndFunction

Event OnEndState()
	Utility.Wait(5.0) ; Wait before entering active state to help avoid making function calls to scripts that may not have initialized yet.
EndEvent

Bool Function GetIsInterfaceActive()
	If GetState() == "Installed"
		Return true
	EndIf
	Return false
EndFunction

State Installed
	Function ModEnjoyment(Int tid, Actor akTarget, Int Enjoyment)
		_SLS_IntSlso.ModEnjoyment(Sexlab, tid, akTarget, Enjoyment) 
	EndFunction
EndState

Function ModEnjoyment(Int tid, Actor akTarget, Int Enjoyment)
EndFunction

SexlabFramework Property Sexlab Auto
