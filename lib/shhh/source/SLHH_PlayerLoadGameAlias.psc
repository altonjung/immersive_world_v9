Scriptname SLHH_PlayerLoadGameAlias extends ReferenceAlias  

 ; EVENTS -----------------------------------------------------------------------------------------

event OnPlayerLoadGame()
	(GetOwningQuest() as SKI_QuestBase).OnGameReload()
	(GetOwningQuest() as SLHH_Upkeep).SLHHRegisterAnimationEvent()
	(GetOwningQuest() as SLHH_Upkeep).SLHHRegisterForModEvent()
	(GetOwningQuest() as SLHH_Upkeep).SLHHActorRegisterForexternalmods()
	Updategametime()
endEvent

Event OnUpdateGameTime()
Actor AggressorActor = (Aggressor.getref() as actor)
If Aggressor
	If (SLHH.getstage() >= 10) && (SLHH.getstage() < 130)
		If (AggressorActor.GetDialogueTarget() == Game.GetPlayer())
			;Do nothing
		Else
			Debug.notification("SLHH Quest Reset...")
			SLHH.setstage(160) ; Stop the questline and reset.
		EndIf
	EndIf
EndIf
	UpdateSwitch = true
	Updategametime()
EndEvent

Function Updategametime()
If UpdateSwitch == true	
Float UpdateInterval
UpdateInterval = SLHH_AbortForceGreetInterval.getvalue() + 1.0
	RegisterForSingleUpdateGameTime(UpdateInterval)
	;Debug.notification("SLHH_Alias Updatetime..." + UpdateInterval)
	UpdateSwitch = False
EndIf
EndFunction

;SLHH_Upkeep Property SLHH Auto
GlobalVariable property SLHH_AbortForceGreetInterval Auto
ReferenceAlias Property aggressor  Auto  
Bool UpdateSwitch = True
Quest Property SLHH Auto