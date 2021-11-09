Scriptname mf_GiantSacrifice_FarmerHitDetector extends ReferenceAlias  

mf_GiantSacrifice_Variables Property Variables  Auto  

Event OnEnterBleedout()
	Farmer.getActorRef().RemoveFromFaction(WEPlayerEnemy)
	Game.GetPlayer().AddToFaction(GiantFaction)
	getActorRef().StopCombat()
	Variables.FightEnded = 1
	Variables.Defeated = 0
	getActorRef().evaluatePackage()
EndEvent
Faction Property GiantFaction  Auto  

Faction Property WEPlayerEnemy  Auto  

ReferenceAlias Property Farmer  Auto  
