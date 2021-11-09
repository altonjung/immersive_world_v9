Scriptname mf_OrcJobPlayerScript extends ReferenceAlias  

LocationAlias Property akOrcCampRef Auto
Keyword Property Habitation  Auto  

Quest Property thisQuest Auto
mf_OrcJobQuestScript Property QuestScript Auto
mf_Handler_Config Property Config Auto


Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	if(thisQuest.GetStage() >= 10 && thisQuest.GetStage() < 100)
		if(!akNewLoc || (!akOrcCampRef.GetLocation().HasCommonParent(akNewLoc , Habitation) && !akNewLoc.HasCommonParent(akOrcCampRef.GetLocation(), Habitation)))
			QuestScript.SetOrcHunter()
		endif
	endif
endEvent


