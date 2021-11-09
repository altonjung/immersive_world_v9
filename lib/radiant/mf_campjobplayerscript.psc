Scriptname mf_CampJobPlayerScript extends ReferenceAlias  

LocationAlias Property akCampRef Auto
ReferenceAlias Property akCoworkerRef Auto
Quest Property thisQuest Auto
mf_Handler_Config Property Config Auto

float StartTime

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	if(thisQuest.GetStage() <= 1)
		if(akNewLoc ==  akCampRef.GetLocation())
			if((thisQuest as mf_CampJobVariables).CoworkerAlive == 1)
				ObjectReference akCoworker = akCoworkerRef.GetRef()
				ObjectReference akPlayer = GetRef()
				if(akPlayer.GetDistance(akCoworker) > 1024.0)
					float dir = akPlayer.GetAngleZ()
					akCoworker.SetPosition(akPlayer.GetPositionX() + 512.0 * Math.sin(dir + 180), akPlayer.GetPositionY() + 512.0 * Math.cos(dir + 180), akPlayer.GetPositionZ()) ; 512 units behind player
				endif
				thisQuest.SetStage(2)
			else
				thisQuest.SetStage(5)
			endif

			StartTime = Utility.GetCurrentGameTime()
			RegisterForUpdateGameTime(0.5)
		endif
	endif

	if(thisQuest.GetStage() >= 5 && thisQuest.GetStage() < 100)
		if(akNewLoc != akCampRef.GetLocation())
			thisQuest.SetStage(100)  ;left the camp
		endif
	endif
endEvent


Event OnUpdateGameTime()
  if(thisQuest.GetStage() >= 5 && thisQuest.GetStage() < 100)
   
	if(Utility.GetCurrentGameTime() >= startTime + Config.CampJobExpireTime)
		thisQuest.SetStage(100)
		UnregisterForUpdateGameTime() ; when we're done with it, make sure to unregister
	 endif
 endIf
endEvent