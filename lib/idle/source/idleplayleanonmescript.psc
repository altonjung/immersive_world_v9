Scriptname IdlePlayLeanonMEScript extends activemagiceffect  
  
form property RailLeanMarker auto 
form property WallLeanMarker auto
formlist property IdlePLayFormListCounters auto
formlist property IdlePLayFormListLeanTables auto
ObjectReference property rail auto hidden
ObjectReference property wall auto hidden
ObjectReference property leanTables auto hidden
ObjectReference property counter auto hidden
actor property playerref auto
Message Property IdlePlayMesLeanon auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	float forward = 135
	float multiplier = 1.0
	float xoff = (forward) * Math.sin(playerref.getAngleZ())
	float yoff = (forward) * Math.cos(playerref.getAngleZ())
	rail = Game.FindClosestReferenceOfType(RailLeanMarker, playerref.getPositionX()+xoff, playerref.getPositionY()+yoff, playerref.getPositionZ(), forward)
	wall = Game.FindClosestReferenceOftype(WallLeanMarker, playerref.getPositionX()+xoff, playerref.getPositionY()+yoff, playerref.getPositionZ(), forward)	
	counter = Game.FindClosestReferenceOfAnyTypeInList(IdlePLayFormListCounters, playerref.getPositionX()+xoff, playerref.getPositionY()+yoff, playerref.getPositionZ(), forward*multiplier)
	leanTables = Game.FindClosestReferenceOfAnyTypeInList(IdlePLayFormListLeanTables, playerref.getPositionX()+xoff/2, playerref.getPositionY()+yoff/2, playerref.getPositionZ(), forward*multiplier/2)

	If	(rail != None && !rail.isFurnitureInUse())
		gotostate("RailLean")
	elseIf (wall != None && !wall.isFurnitureInUse())
		gotostate("WallLean")
	elseIf (leanTables != None && !leanTables.isFurnitureInUse())	
		gotostate("Tables")
	elseIf (counter != None && !counter.isFurnitureInUse())
		gotostate("CounterLean")
	else
		IdlePlayMesLeanon.show()	
	endif	
EndEvent




State RailLean

Event OnBeginState()
If playerref.IsSneaking() == true
			playerref.StartSneaking()
		Endif	
		Debug.SendAnimationEvent(playerref,"IdleStop")	
		if playerref.IsWeaponDrawn() == false
			playerref.setPosition(rail.getPositionX(), rail.getPositionY(), rail.getPositionZ())
			playerref.setAngle(rail.getAngleX(), rail.getAngleY(), rail.getAngleZ() - 180)
			Debug.sendAnimationEvent(playerref, "IdleRailLeanEnter")
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
	playerref.setPosition(rail.getPositionX(), rail.getPositionY(), rail.getPositionZ())
	playerref.setAngle(rail.getAngleX(), rail.getAngleY(), rail.getAngleZ() - 180)
	Debug.sendAnimationEvent(playerref, "IdleRailLeanEnter")
	game.Enableplayercontrols()
	gotostate("")
EndEvent	

endstate

State WallLean

Event OnBeginState()
	If playerref.IsSneaking() == true
		playerref.StartSneaking()
	Endif	
	Debug.SendAnimationEvent(playerref,"IdleStop")	
	if playerref.IsWeaponDrawn() == false
		float forth = 0
		float newdeg = wall.getAngleZ() - 180
		playerref.setPosition(wall.getPositionX()+math.sin(newdeg)*forth, wall.getPositionY()+math.cos(newdeg)*forth, wall.getPositionZ())
		playerref.setAngle(wall.getAngleX(), wall.getAngleY(), wall.getAngleZ() - 180)
		Debug.sendAnimationEvent(playerref, "IdleWallLeanStart")
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
	float forth = 0
	float newdeg = wall.getAngleZ() - 180
	playerref.setPosition(wall.getPositionX()+math.sin(newdeg)*forth, wall.getPositionY()+math.cos(newdeg)*forth, wall.getPositionZ())
	playerref.setAngle(wall.getAngleX(), wall.getAngleY(), wall.getAngleZ() - 180)
	Debug.sendAnimationEvent(playerref, "IdleWallLeanStart")
	game.Enableplayercontrols()
	gotostate("")
EndEvent		
	
endstate	
		

State CounterLean
		
Event OnBeginState()
	If playerref.IsSneaking() == true
		playerref.StartSneaking()
	Endif	
	Debug.SendAnimationEvent(playerref,"IdleStop")	
	if playerref.IsWeaponDrawn() == false
		playerref.setPosition(counter.getPositionX(), counter.getPositionY(), counter.getPositionZ())
		playerref.setAngle(counter.getAngleX(), counter.getAngleY(), counter.getAngleZ())
		Debug.sendAnimationEvent(playerref, "IdleBarCounterEnter")		
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
	playerref.setPosition(counter.getPositionX(), counter.getPositionY(), counter.getPositionZ())
	playerref.setAngle(counter.getAngleX(), counter.getAngleY(), counter.getAngleZ())
	Debug.sendAnimationEvent(playerref, "IdleBarCounterEnter")		
	game.Enableplayercontrols()
	gotostate("")
EndEvent		
	
endstate	


State Tables

Event OnBeginState()
	If playerref.IsSneaking() == true
		playerref.StartSneaking()
	Endif	
	Debug.SendAnimationEvent(playerref,"IdleStop")	
	if playerref.IsWeaponDrawn() == false
		float forth = 10.0
		playerref.setPosition(leanTables.getPositionX() + math.sin(leanTables.getAngleZ())*forth, leanTables.getPositionY() + math.cos(leanTables.getAngleZ())*forth, leanTables.getPositionZ())
		playerref.setAngle(leanTables.getAngleX(), leanTables.getAngleY(), leanTables.getAngleZ())
		Debug.sendAnimationEvent(playerref, "IdleLeanTableEnter")
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
	float forth = 10.0
	playerref.setPosition(leanTables.getPositionX() + math.sin(leanTables.getAngleZ())*forth, leanTables.getPositionY() + math.cos(leanTables.getAngleZ())*forth, leanTables.getPositionZ())
	playerref.setAngle(leanTables.getAngleX(), leanTables.getAngleY(), leanTables.getAngleZ())
	Debug.sendAnimationEvent(playerref, "IdleLeanTableEnter")	
	game.Enableplayercontrols()
	gotostate("")
EndEvent		
	
endstate