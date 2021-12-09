Scriptname SLAPPwiplayerscript extends ReferenceAlias  
Bool Property StopQuestOnLocationChange = false auto
{Default: false; If the player changes location, should this quest stop?}

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	if StopQuestOnLocationChange
		If (NewLocationRef.getlocation() == akNewLoc)
		Elseif Getowningquest().getstage() < 50
			SLAppPCSexQuest.VisitedbutFailed()
			GetOwningQuest().Stop()
		Elseif Getowningquest().getstage() >= 50
			SLAppPCSexQuest.Visited()
			;GetOwningQuest().Stop();Keep the quest going
		EndIf
	EndIf
EndEvent

LocationAlias Property NewLocationRef  Auto  
SLAppPCSexQuestScript Property SLAppPCSexQuest Auto