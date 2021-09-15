Scriptname _SLS_SexCockSize extends Quest  

Function BeginBonusEnjoyment(Actor Creature, Int tid)
	CurrentTid = tid
	BonusEnj = Math.Ceiling((Util.GetLoadSize(Creature) as Int)) + 1
	RegisterForSingleUpdate(0.01)
EndFunction

Event OnUpdate()
	Slso.ModEnjoyment(CurrentTid, PlayerRef, BonusEnj)
	If Init.DebugMode
		Debug.Notification("Bonus enj: " + BonusEnj)
	EndIf
	If Menu.CockSizeBonusEnjFreq > 0.0
		RegisterForSingleUpdate(Menu.CockSizeBonusEnjFreq)
	EndIf
	;RegisterForSingleUpdate(3.0)
EndEvent

Int BonusEnj
Int CurrentTid

Actor Property PlayerRef Auto

SLS_Mcm Property Menu Auto
SLS_Init Property Init Auto
SLS_Utility Property Util Auto
_SLS_InterfaceSlso Property Slso Auto
