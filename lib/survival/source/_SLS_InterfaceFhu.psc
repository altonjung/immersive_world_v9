Scriptname _SLS_InterfaceFhu extends Quest  

Quest FhuConfigQuest
Quest FhuInflateQuest
ReferenceAlias DeflateAlias

Event OnInit()
	RegisterForModEvent("_SLS_Int_PlayerLoadsGame", "On_SLS_Int_PlayerLoadsGame")
EndEvent

Event On_SLS_Int_PlayerLoadsGame(string eventName, string strArg, float numArg, Form sender)
	PlayerLoadsGame()
EndEvent

Function PlayerLoadsGame()
	If Game.GetModByName("sr_FillHerUp.esp") != 255
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
	FhuConfigQuest = Game.GetFormFromFile(0x001D8C,"sr_FillHerUp.esp") as Quest
	FhuInflateQuest = Game.GetFormFromFile(0x000D63,"sr_FillHerUp.esp") as Quest
	DeflateAlias = FhuInflateQuest.GetNthAlias(0) as ReferenceAlias
EndEvent

Bool Function GetIsInterfaceActive()
	If GetState() == "Installed"
		Return true
	EndIf
	Return false
EndFunction

State Installed
	Float Function GetCumCapacityMax()
		Return _SLS_IntFhu.GetCumCapacityMax(FhuConfigQuest)
	EndFunction
	
	Function InflateTo(Actor akActor, int Hole, float time, float targetLevel = -1.0, String callback = "") ; Hole: 1 - Vaginal, 2 - Anal
		_SLS_IntFhu.InflateTo(FhuInflateQuest, akActor, Hole, time, targetLevel, callback)
	EndFunction
	
	Float Function GetCumAmountForActor(Actor a, Actor[] all) ; a: Receiving actor, all: All actors in thread
		Return _SLS_IntFhu.GetCumAmountForActor(FhuInflateQuest, a, all)
	EndFunction
	
	Function DrainCum()
		_SLS_IntFhu.DrainCum(DeflateAlias)
	EndFunction
EndState

Float Function GetCumCapacityMax()
	Return 0.0
EndFunction

Function InflateTo(Actor akActor, int Hole, float time, float targetLevel = -1.0, String callback = "")
EndFunction

Float Function GetCumAmountForActor(Actor a, Actor[] all)
	Return 0.0
EndFunction

Float Function GetCurrentCumAnal(Actor akTarget)
	;Debug.Messagebox("Current cum: " + StorageUtil.GetFloatValue(akTarget, "sr.inflater.cum.anal", Missing = 0.0))
	Return StorageUtil.GetFloatValue(akTarget, "sr.inflater.cum.anal", Missing = 0.0)
EndFunction

Float Function GetCurrentCumVaginal(Actor akTarget)
	Return StorageUtil.GetFloatValue(akTarget, "sr.inflater.cum.vaginal", Missing = 0.0)
EndFunction

Function DrainCum()

EndFunction
