Scriptname IdlePlayLuteStartMEScript extends activemagiceffect  



actor property playerref auto

sound property IdlePlayLute01 auto
sound property IdlePlayLute02 auto
sound property IdlePlayLute03 auto
sound property IdlePlayLute04 auto


GlobalVariable property Druminstance auto
GlobalVariable property Drumplaying auto
GlobalVariable property luteinstance auto
GlobalVariable property luteplaying auto
GlobalVariable property fluteinstance auto
GlobalVariable property fluteplaying auto



int lute01instance
int lute02instance
int lute03instance
int lute04instance

message property lutesong01mes auto
message property lutesong02mes auto
message property lutesong03mes auto
message property lutesong04mes auto
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
		Debug.SendAnimationEvent(playerref, "IdleLuteStart")
		
		if Drumplaying.getvalue() == 0 && luteplaying.getvalue() == 0 && fluteplaying.getvalue() == 0
			int lutesound = Utility.RandomInt(1, 4)
			if lutesound == 1
				lute01instance = IdlePlayLute01.play(playerref)
				lutesong01mes.show()
				luteinstance.setvalue(lute01instance)
				luteplaying.setvalue(1.0)
			elseif lutesound == 2
				lute02instance = IdlePlayLute02.play(playerref)
				lutesong02mes.show()
				luteinstance.setvalue(lute02instance)
				luteplaying.setvalue(1.0)	
			elseif lutesound == 3	
				lute03instance = IdlePlayLute03.play(playerref)
				lutesong03mes.show()
				luteinstance.setvalue(lute03instance)
				luteplaying.setvalue(1.0)	
			elseif lutesound == 4	
				lute04instance = IdlePlayLute04.play(playerref)
				lutesong04mes.show()
				luteinstance.setvalue(lute04instance)
				luteplaying.setvalue(1.0)	
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
	Debug.SendAnimationEvent(playerref, "IdleLuteStart")
	
		if Drumplaying.getvalue() == 0 && luteplaying.getvalue() == 0 && fluteplaying.getvalue() == 0
			int lutesound = Utility.RandomInt(1, 4)
			if lutesound == 1
				lute01instance = IdlePlayLute01.play(playerref)
				lutesong01mes.show()
				luteinstance.setvalue(lute01instance)
				luteplaying.setvalue(1.0)
			elseif lutesound == 2
				lute02instance = IdlePlayLute02.play(playerref)
				lutesong02mes.show()
				luteinstance.setvalue(lute02instance)
				luteplaying.setvalue(1.0)	
			elseif lutesound == 3	
				lute03instance = IdlePlayLute03.play(playerref)
				lutesong03mes.show()
				luteinstance.setvalue(lute03instance)
				luteplaying.setvalue(1.0)	
			elseif lutesound == 4	
				lute04instance = IdlePlayLute04.play(playerref)
				lutesong04mes.show()
				luteinstance.setvalue(lute04instance)
				luteplaying.setvalue(1.0)	
			endif	
		else	
			idlesongplayingmes.show()		
		endif	
		
	game.EnablePlayerControls()
	
EndEvent		