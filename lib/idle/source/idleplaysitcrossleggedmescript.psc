Scriptname IdlePlaySitCrossLeggedMEScript extends activemagiceffect  


actor property playerref auto
form property SitLedgeMarker auto
ObjectReference property Ledge auto hidden

Event OnEffectStart(Actor akTarget, Actor akCaster)
	float forward = 135
	float multiplier = 1.0
	float xoff = (forward) * Math.sin(playerref.getAngleZ())
	float yoff = (forward) * Math.cos(playerref.getAngleZ())
	ledge = Game.FindClosestReferenceOftype(SitLedgeMarker, playerref.getPositionX()+xoff, playerref.getPositionY()+yoff, playerref.getPositionZ(), forward)
	If	(game.GetCameraState() == 0 || game.GetCameraState() == 8 || game.GetCameraState() == 9)
		If (ledge != None && !ledge.isFurnitureInUse())
			gotostate("LedgeState")
		endif	
		If playerref.IsSneaking() == true
			playerref.StartSneaking()
		Endif	
		Debug.SendAnimationEvent(playerref,"IdleStop")	
		if playerref.IsWeaponDrawn() == false
			Game.ForceThirdPerson()
			Debug.SendAnimationEvent(playerref, "IdleSitCrossLeggedEnter")
		elseif ( playerref.GetSitState() != 0)	
			Debug.Notification("$IAWM Sitting Warn")
		else
			Debug.SendAnimationEvent(playerref, "unequip")
			RegisterForSingleUpdate(1.5)
			game.DisablePlayerControls(true, true, false, false, true, true, true, false, 0)
		endif	
	endif	
EndEvent

Event OnUpdate()
	Game.ForceThirdPerson()
	Debug.SendAnimationEvent(playerref, "IdleSitCrossLeggedEnter")
	game.EnablePlayerControls()
EndEvent		

State LedgeState

Event OnBeginState()
If playerref.IsSneaking() == true
			playerref.StartSneaking()
		Endif	
		Debug.SendAnimationEvent(playerref,"IdleStop")	
		if playerref.IsWeaponDrawn() == false
			float newdeg = ledge.getAngleZ()
			playerref.setPosition(ledge.getPositionX(), ledge.getPositionY(), ledge.getPositionZ())
			playerref.setAngle(ledge.getAngleX(), ledge.getAngleY(), ledge.getAngleZ())
			Game.ForceThirdPerson()
			Debug.sendAnimationEvent(playerref, "IdleSitLedgeEnter")
			gotostate("")
		elseif ( playerref.GetSitState() != 0)	
			Debug.Notification("$IAWM Sitting Warn")
			gotostate("")
		else
			Debug.SendAnimationEvent(playerref, "unequip")
			RegisterForSingleUpdate(1.5)
			game.Disableplayercontrols(true, true, false, false, true, true, true, false, 0)
		endif
EndEvent	

Event OnUpdate()
	float newdeg = ledge.getAngleZ()
	playerref.setPosition(ledge.getPositionX(), ledge.getPositionY(), ledge.getPositionZ())
	playerref.setAngle(ledge.getAngleX(), ledge.getAngleY(), ledge.getAngleZ())
	Game.ForceThirdPerson()
	Debug.sendAnimationEvent(playerref, "IdleSitLedgeEnter")
	game.Enableplayercontrols()
	gotostate("")
EndEvent

endState