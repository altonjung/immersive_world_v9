Scriptname slapproachplayeraliasVisitscript extends ReferenceAlias  

SLAppPCSexQuestScript Property SLApproachPC Auto
SLApproachMainScript Property SLApproachMain Auto
SLApproachBaseQuestScript Property SLApproachBase Auto
Quest Property SLApproachAskForSexQuest Auto
Actor player

Event OnPlayerLoadGame()
	UnregisterForUpdate()
	player = Game.GetPlayer()
	RegisterForSingleUpdate(3)
EndEvent

Event OnInit()
	player = Game.GetPlayer()
	RegisterForSingleUpdate(3)
EndEvent


Event OnUpdate()
;	if !SLApproachPC.PCApproachOngoing
;		if (SLApproachAskForSexQuest as SLAppPCSexQuestScript).iGetFormIndex() == true
;		if SLApproachPC.iGetFormIndex() == true
;			Bool ModActivate = SLApproachPC.KnockKnock()
;			if ModActivate
;				Debug.notification("Knock Knock...")
;			Endif
;		endif
;	endif
;	RegisterForSingleUpdate(SLApproachMain.cloakFrequency+3)
Endevent