Scriptname IdlePlayfluteStartME extends activemagiceffect  



actor property playerref auto



GlobalVariable property Druminstance auto
GlobalVariable property Drumplaying auto
GlobalVariable property luteinstance auto
GlobalVariable property luteplaying auto
GlobalVariable property fluteinstance auto
GlobalVariable property fluteplaying auto

sound property IdlePlayflute01 auto
sound property IdlePlayflute02 auto
sound property IdlePlayflute03 auto
sound property IdlePlayflute04 auto
sound property IdlePlayflute05 auto
sound property IdlePlayflute06 auto

int flute01instance
int flute02instance
int flute03instance
int flute04instance
int flute05instance
int flute06instance

message property flutesong01mes auto
message property flutesong02mes auto
message property flutesong03mes auto
message property flutesong04mes auto
message property flutesong05mes auto
message property flutesong06mes auto
message property idlesongplayingmes auto



Event OnEffectStart(Actor akTarget, Actor akCaster)

	sound[] IdlePlayFluteSound = new sound[5]
	IdlePlayFluteSound[0] = IdlePlayflute01
	IdlePlayFluteSound[1] = IdlePlayflute02
	IdlePlayFluteSound[2] = IdlePlayflute03
	IdlePlayFluteSound[3] = IdlePlayflute04
	IdlePlayFluteSound[4] = IdlePlayflute05
	IdlePlayFluteSound[5] = IdlePlayflute06
	
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
		Debug.SendAnimationEvent(playerref, "IdlefluteStart")
		
		if Drumplaying.getvalue() == 0 && luteplaying.getvalue() == 0 && fluteplaying.getvalue() == 0
			int fluteindex = Utility.RandomInt(0, 5)
			flute01instance = IdlePlayFluteSound[fluteindex].play(playerref)
			fluteinstance.setvalue(flute01instance)
			fluteplaying.setvalue(1.0)
				
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
	Debug.SendAnimationEvent(playerref, "IdlefluteStart")

			
		if Drumplaying.getvalue() == 0 && luteplaying.getvalue() == 0 && fluteplaying.getvalue() == 0
			int flutesound = Utility.RandomInt(1, 6)
			
			if flutesound == 1
				flute01instance = IdlePlayflute01.play(playerref)
				flutesong01mes.show()
				fluteinstance.setvalue(flute01instance)
				fluteplaying.setvalue(1.0)
			elseif flutesound == 2
				flute02instance = IdlePlayflute02.play(playerref)
				flutesong02mes.show()
				fluteinstance.setvalue(flute02instance)
				fluteplaying.setvalue(1.0)	
			elseif flutesound == 3	
				flute03instance = IdlePlayflute03.play(playerref)
				flutesong03mes.show()
				fluteinstance.setvalue(flute03instance)
				fluteplaying.setvalue(1.0)	
			elseif flutesound == 4	
				flute04instance = IdlePlayflute04.play(playerref)
				flutesong04mes.show()
				fluteinstance.setvalue(flute04instance)
				fluteplaying.setvalue(1.0)
			elseif flutesound == 5	
				flute05instance = IdlePlayflute05.play(playerref)
				flutesong05mes.show()
				fluteinstance.setvalue(flute05instance)
				fluteplaying.setvalue(1.0)				
			elseif flutesound == 6	
				flute06instance = IdlePlayflute06.play(playerref)
				flutesong06mes.show()
				fluteinstance.setvalue(flute06instance)
				fluteplaying.setvalue(1.0)	
			endif	
		else	
			idlesongplayingmes.show()		
		endif		
	
	game.EnablePlayerControls()
EndEvent		