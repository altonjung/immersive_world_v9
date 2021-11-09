Scriptname mf_FanJobFanScript extends ReferenceAlias  

ReferenceAlias[] Property Goon Auto
Quest Property thisQuest Auto

Event OnDeath(Actor akKiller)
	Actor Goon0 = Goon[0].GetRef() as Actor
	Actor Goon1 = Goon[1].GetRef() as Actor
	Actor Goon2 = Goon[2].GetRef() as Actor

	if(GetRef() == Goon0)
		(thisQuest as mf_FanJobQuestScript).MoveItemToTarget(Goon0)
	endif

	if(Goon0.IsDead() && Goon1.IsDead() && Goon2.IsDead())
		thisQuest.SetStage(100)
	endif

	if(thisQuest.GetStage() <=10)
		Debug.Notification("The person you were supposed to meet died and the quest cannot be completed")
		thisQuest.SetObjectiveFailed(0)
		Utility.Wait(2.0)
		;thisQuest.Stop()   ;this doesn't reset the madame properly and causes issues, use Handler.GetRandomJobReward() instead
		Handler.GetRandomJobReward()
	endif
endEvent
mf_handler Property Handler  Auto  
