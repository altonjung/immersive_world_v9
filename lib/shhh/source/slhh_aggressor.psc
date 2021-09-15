Scriptname SLHH_Aggressor extends ReferenceAlias  

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
If (Self.GetOwningQuest().GetStage() == 150) && (akAggressor == Game.GetPlayer()) && Self.getActorRef().GetAVPercentage("health") < 100
	Self.GetOwningQuest().Reset()
	Self.GetOwningQuest().SetStage(125)
	(Self.getRef() as Actor).StopCombat()
endif
endEvent

Event OnDeath(Actor akKiller)
	Self.GetOwningQuest().SetStage(160)
EndEvent