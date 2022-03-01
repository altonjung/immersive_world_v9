Scriptname IdlePlayWriteMEScript extends activemagiceffect  

actor property playerref auto
idle property IdleWriteLedgerenter auto
idle property IdleWriteLedgerwrite auto
string SitIdle
String StandIdle
String StandIdle2


Event OnEffectStart(Actor akTarget, Actor akCaster)
	GetIdleName()
	If	playerref.GetSitState() == 3 || playerref.GetSitState() == 4
		Debug.SendAnimationEvent(playerref, SitIdle)
		Return
	endif	
	If playerref.IsSneaking() == true
		playerref.StartSneaking()
	Endif	
	Debug.SendAnimationEvent(playerref,"IdleStop")	
	if playerref.IsWeaponDrawn() == false
		Debug.SendAnimationEvent(playerref, "IdleWriteLedgerenter")
		Utility.Wait(0.5)
		Debug.SendAnimationEvent(playerref, "IdleWriteLedgerwrite")
	else
		Debug.SendAnimationEvent(playerref, "unequip")
		RegisterForSingleUpdate(1.5)
		game.DisablePlayerControls(true, true, false, false, true, true, true, false, 0)
	endif	
EndEvent

Event OnUpdate()
	Debug.SendAnimationEvent(playerref, "IdleWriteLedgerenter")
	Utility.Wait(0.5)
	Debug.SendAnimationEvent(playerref, "IdleWriteLedgerwrite")
	game.EnablePlayerControls()
EndEvent		

Function GetIdleName()

	SitIdle = "IdleChairWrite"
	StandIdle = "IdleWriteLedgerwrite"

EndFunction	