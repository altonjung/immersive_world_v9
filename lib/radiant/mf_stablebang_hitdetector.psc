Scriptname mf_StableBang_HitDetector extends ReferenceAlias  

Keyword Property ArmorCuirass  Auto  
Keyword Property ArmorCloth  Auto  
ReferenceAlias Property Horse  Auto  
mf_prostitute_StableBangQuest Property StableBangQuest  Auto  

bool raped= false

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if(Horse.getActorRef() == akAggressor && !raped)
		Debug.Trace("Attacked by the Jarls Horse")
		Actor me = getActorRef()
		Debug.Trace("Do i wear Armor? " +(me.WornHasKeyword(ArmorCuirass)))
		Debug.Trace("Do i wear Cloths? "+(me.WornHasKeyword(ArmorCloth)))
		if(!me.WornHasKeyword(ArmorCuirass) && !me.WornHasKeyword(ArmorCloth))
			raped= true
			StableBangQuest.setStage(6)
			Horse.getActorRef().stopCombat()
			Horse.getActorRef().evaluatePackage()
			StableBangQuest.startHorseRape()
		endIf
	endIf
EndEvent
