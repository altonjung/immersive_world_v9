Scriptname mf_GiantSacrifice_PlayerHitDetector extends ReferenceAlias  

Quest Property GiantSacrifice  Auto  
ReferenceAlias Property Farmer  Auto  
mf_GiantSacrifice_Variables Property Variables  Auto  
Race Property GiantRace  Auto  
Actor act
Faction Property WEPlayerEnemy  Auto  

Event OnInit()
	RegisterForCrosshairRef()
endEvent

Event OnCrosshairRefChange(ObjectReference ref)

	if(!GiantSacrifice.isRunning())
		UnregisterForCrosshairRef()
	endIf
	If ref ;Used to determine if it's none or not.
		act =  ref as Actor
		if(act)
			Debug.Trace("act"+ act)
			if(GiantRace  ==  act.getRace() )
				Debug.Trace("act Race "+ act.getRace())
				act.AllowPCDialogue(true)
			endIf	
		endIf
	EndIf
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if(Farmer.getActorRef() == akAggressor)
		Actor me = getActorRef()
		float healPercent = me.GetActorValuePercentage("health")
		if(healPercent <= 0.5)
			Farmer.getActorRef().RemoveFromFaction(WEPlayerEnemy)
			Game.GetPlayer().AddToFaction(GiantFaction)
			Farmer.getActorRef().StopCombat()
			Debug.SendAnimationEvent(me, "BleedoutStart")
			Variables.FightEnded = 1
			Variables.Defeated = 1
			Farmer.getActorRef().evaluatePackage()
		endIf
	endIf
EndEvent








Faction Property GiantFaction  Auto  
