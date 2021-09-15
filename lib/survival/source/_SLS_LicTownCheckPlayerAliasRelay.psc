Scriptname _SLS_LicTownCheckPlayerAliasRelay extends Quest  
; This script is just to stop property errors when referencing an alias script from another alias script.

Function DoorLoaded(Int TownLoc)
	TownCheckPlayerAlias.TownLoc = TownLoc
	TownCheckPlayerAlias.GetShouldApproach()
EndFunction

_SLS_LicTownCheckPlayerAlias Property TownCheckPlayerAlias Auto
