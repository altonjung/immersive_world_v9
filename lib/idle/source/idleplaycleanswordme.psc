Scriptname IdlePlayCleanSwordME extends activemagiceffect  


Message Property IdlePlayMesCleanSword auto
actor property playerref auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If playerref.IsSneaking() == true
		playerref.StartSneaking()
	Endif	
	Debug.SendAnimationEvent(playerref,"IdleStop")
	If playerref.GetEquippedItemType(1) != 1
		IdlePlayMesCleanSword.show()
	Else	
		if playerref.IsWeaponDrawn() == false
			Debug.SendAnimationEvent(playerref, "IdleCleanSword")
		elseif ( playerref.GetSitState() != 0)	
			Debug.Notification("$IAWM Sitting Warn")
		else
			Debug.SendAnimationEvent(playerref, "unequip")
			RegisterForSingleUpdate(2.0)
			game.DisablePlayerControls(true, true, false, false, true, true, true, false, 0)
		endif	
	endif	
EndEvent

Event OnUpdate()
	Debug.SendAnimationEvent(playerref, "IdleCleanSword")
	game.EnablePlayerControls()
EndEvent			