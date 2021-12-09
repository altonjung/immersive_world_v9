Scriptname SLApproachApplyScript extends activemagiceffect

slapp_util Property slappUtil Auto

Event OnEffectStart(Actor akTarget, Actor playerActor)
	SLApproachMain.addActorEffectStarted()
	
	if (!akTarget.IsDead())
		bool init
		int indexCounter = SLApproachMain.getRegisteredAmount()
;		if SLApproachMain.debugLogFlag
;			Debug.notification("MagicCloack")
;		endif
		while (indexCounter > 0)
			indexCounter -= 1
			SLApproachBaseQuestScript xqscript = SLApproachMain.getApproachQuestScript(indexCounter)
			
			if (xqscript.isSituationValid(akTarget, playerActor))
			;if (SLAPPPCScript.isSituationValid(akTarget, playerActor))

				init = SLApproachMain.StartInitOfQuestByIndex(indexCounter)
				if SLApproachMain.debugLogFlag
					Debug.notification("SituationValid" + init as int)
				endif
				;if (init)
					if (SLAPPPCScript.chanceRoll(akTarget, playerActor, SLApproachMain.baseChanceMultiplier)) ; SLAppPCSexQuestScript has the proper function. need to figure it out
					;if (xqscript.chanceRoll(akTarget, playerActor, SLApproachMain.baseChanceMultiplier)) ; SLAppPCSexQuestScript has the proper function. need to figure it out
						SLAPPPCScript.ready()
						;xqscript.ready()
						slappUtil.log("INIT: " + indexCounter)
						
						indexCounter = 0 ; break while loop
						SLAPPPCScript.startApproach(akTarget)
						;xqscript.startApproach(akTarget)
						if SLApproachMain.debugLogFlag
							Debug.notification((akTarget.GetBaseObject().GetName() as string) + " is approaching")
						endif
					else
						SLApproachMain.EndtInitOfQuestByIndex(indexCounter)
					endif
				;endif
			endif
		endwhile
	endif
	
	SLApproachMain.addActorEffectFinished()
EndEvent

SexLabFramework Property SexLab  Auto
SLApproachMainScript Property SLApproachMain  Auto  
Faction Property ArousalFaction Auto
Faction  Property SLApproachMonitorAbility Auto
SLAppPCSexQuestScript Property SLAPPPCScript Auto