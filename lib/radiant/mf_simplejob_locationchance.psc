Scriptname MF_SimpleJob_LocationChance extends ReferenceAlias  

Keyword Property Habitation  Auto  

mf_handler Property Handler  Auto  
mf_handler_config Property config  Auto  

Location StartLocation = none

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	if(!StartLocation)
		StartLocation = akOldLoc
	endIf

	if(Config.RestrictToTown && (akNewLoc == none || !StartLocation.HasCommonParent(akNewLoc) ))
		Handler.GetSingleJobReward(2)
	endIf
endEvent