Scriptname IdlePlayKneelMEScript extends activemagiceffect  

actor property playerref auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If playerref.IsSneaking() == true
		playerref.StartSneaking()
	Endif	
	Debug.SendAnimationEvent(playerref,"IdleStop")	
	if playerref.IsWeaponDrawn() == false
		Game.ForceThirdPerson()
		Debug.SendAnimationEvent(playerref, "IdleKneelingEnter")
	elseif ( playerref.GetSitState() != 0)	
		Debug.Notification("$IAWM Sitting Warn")
	else
		Debug.SendAnimationEvent(playerref, "unequip")
		RegisterForSingleUpdate(1.5)
		game.DisablePlayerControls(true, true, false, false, true, true, true, false, 0)
	endif	
EndEvent

Event OnUpdate()
	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(playerref, "IdleKneelingEnter")
	game.EnablePlayerControls()
EndEvent		