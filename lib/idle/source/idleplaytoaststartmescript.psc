Scriptname IdlePlayToastStartMEScript extends activemagiceffect  


actor property playerref auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If playerref.IsSneaking() == true
		playerref.StartSneaking()
	Endif	
	Debug.SendAnimationEvent(playerref,"IdleStop")	
	if playerref.IsWeaponDrawn() == false
		Debug.SendAnimationEvent(playerref, "IdleMQ201ToastStart")
		Utility.Wait(1.5)
		self.Dispel()
	elseif ( playerref.GetSitState() != 0)	
		Debug.Notification("$IAWM Sitting Warn")
	else
		Debug.SendAnimationEvent(playerref, "unequip")
		RegisterForSingleUpdate(1.5)
		game.DisablePlayerControls(true, true, false, false, true, true, true, false, 0)
	endif	
EndEvent

Event OnUpdate()
	Debug.SendAnimationEvent(playerref, "IdleMQ201ToastStart")
	game.EnablePlayerControls()
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)	
	 debug.SendAnimationEvent(playerref, "IdleMQ201Drink")
EndEvent	
