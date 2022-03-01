Scriptname IdlePlayMenuBaseMEScript extends activemagiceffect  

quest property IdlePlayWheelMenuBaseQuest auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	IdlePlayWheelMenuBaseQuest.start()
EndEvent	