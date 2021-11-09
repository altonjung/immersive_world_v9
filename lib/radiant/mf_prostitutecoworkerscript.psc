Scriptname mf_ProstituteCoworkerScript extends ReferenceAlias  

Quest Property thisQuest Auto

Event OnDeath(Actor akKiller)
	Debug.Notification("Your coworker is dead. The innkeeper won't be too pleased")
	(thisQuest as mf_CampJobVariables).CoworkerAlive = 0

	if(thisQuest.GetStage() == 2) ; arrived at the camp
		thisQuest.SetStage(5)
	endif
endEvent
