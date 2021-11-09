Scriptname mf_SimplerQuestPlayerScript extends ReferenceAlias 

mf_Handler Property Handler Auto
LocationAlias Property akInnRef Auto

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	Location akInn = akInnRef.GetLocation()
	if(akOldLoc == akInn)
		if(akNewLoc != akInn)
			Handler.SimplerJobLeave()
		endif
	endif
endEvent
