Scriptname IdlePlayWarmHandsCrouchedMEScript extends activemagiceffect  


actor property playerref auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	If playerref.IsSneaking() == true
		playerref.StartSneaking()
	Endif
	If playerref.GetEquippedItemType(0) == 10
		playerref.UnequipItem(playerref.GetEquippedShield(),false,true)
	elseif playerref.GetEquippedItemType(0) == 11
		playerref.UnequipItem(playerref.GetEquippedObject(0),false,true)
	endif	
	Debug.SendAnimationEvent(playerref,"IdleStop")	
	if playerref.IsWeaponDrawn() == false
		Debug.SendAnimationEvent(playerref, "IdleWarmHandsCrouched")
	elseif ( playerref.GetSitState() != 0)	
		Debug.Notification("$IAWM Sitting Warn")
	else
		Debug.SendAnimationEvent(playerref, "unequip")
		RegisterForSingleUpdate(1.5)
		game.DisablePlayerControls(true, true, false, false, true, true, true, false, 0)
	endif	
EndEvent

Event OnUpdate()
	Debug.SendAnimationEvent(playerref, "IdleWarmHandsCrouched")
	game.EnablePlayerControls()
EndEvent		