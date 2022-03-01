Scriptname IdlePlayDrumStartME extends activemagiceffect  



actor property playerref auto

sound property IdlePlayDrum01 auto
sound property IdlePlayDrum02 auto
sound property IdlePlayDrum03 auto



GlobalVariable property Druminstance auto
GlobalVariable property Drumplaying auto
GlobalVariable property luteinstance auto
GlobalVariable property luteplaying auto
GlobalVariable property fluteinstance auto
GlobalVariable property fluteplaying auto


int Drum01instance
int Drum02instance
int Drum03instance
int Drum04instance

message property Drumsong01mes auto
message property Drumsong02mes auto
message property Drumsong03mes auto
message property idlesongplayingmes auto




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
		Debug.SendAnimationEvent(playerref, "IdleDrumStart")
		
		if Drumplaying.getvalue() == 0 && luteplaying.getvalue() == 0 && fluteplaying.getvalue() == 0
			int Drumsound = Utility.RandomInt(1, 3)
			if Drumsound == 1
				Drum01instance = IdlePlayDrum01.play(playerref)
				Drumsong01mes.show()
				Druminstance.setvalue(Drum01instance)
				Drumplaying.setvalue(1.0)
			elseif Drumsound == 2
				Drum02instance = IdlePlayDrum02.play(playerref)
				Drumsong02mes.show()
				Druminstance.setvalue(Drum02instance)
				Drumplaying.setvalue(1.0)	
			elseif Drumsound == 3	
				Drum03instance = IdlePlayDrum03.play(playerref)
				Drumsong03mes.show()
				Druminstance.setvalue(Drum03instance)
				Drumplaying.setvalue(1.0)		
			endif	
		else	
			idlesongplayingmes.show()		
		endif	
		
	elseif ( playerref.GetSitState() != 0)	
		Debug.Notification("$IAWM Sitting Warn")
	else
		Debug.SendAnimationEvent(playerref, "unequip")
		RegisterForSingleUpdate(1.5)
		game.DisablePlayerControls(true, true, false, false, true, true, true, false, 0)
	endif	
EndEvent

Event OnUpdate()
	Debug.SendAnimationEvent(playerref, "IdleDrumStart")
	
		if Drumplaying.getvalue() == 0 && luteplaying.getvalue() == 0 && fluteplaying.getvalue() == 0
			int Drumsound = Utility.RandomInt(1, 3)
			if Drumsound == 1
				Drum01instance = IdlePlayDrum01.play(playerref)
				Drumsong01mes.show()
				Druminstance.setvalue(Drum01instance)
				Drumplaying.setvalue(1.0)
			elseif Drumsound == 2
				Drum02instance = IdlePlayDrum02.play(playerref)
				Drumsong02mes.show()
				Druminstance.setvalue(Drum02instance)
				Drumplaying.setvalue(1.0)	
			elseif Drumsound == 3	
				Drum03instance = IdlePlayDrum03.play(playerref)
				Drumsong03mes.show()
				Druminstance.setvalue(Drum03instance)
				Drumplaying.setvalue(1.0)		
			endif	
		else	
			idlesongplayingmes.show()		
		endif	
		
	game.EnablePlayerControls()
	
EndEvent		