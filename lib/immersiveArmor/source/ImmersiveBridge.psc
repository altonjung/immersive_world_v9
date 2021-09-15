Scriptname ImmersiveBridge extends Quest

Import Utility

Actor Property Player  Auto

int Version
int Function VersionCheck()
	Version = 2
	Return Version
EndFunction

ImmersiveBreakArmor 		imsBreakArmorQuest =  none

event OnInit()
	Debug.Notification("ImmersiveArmor Load..")		
	init()
endEvent

function init()
	if imsBreakArmorQuest == none
		imsBreakArmorQuest =  Game.GetFormFromFile(0x05005900, "AltonArmorBreak.esp") As ImmersiveBreakArmor
	endif
endfunction

bool function handleWeaponDrop (actor _victim, actor _aggressor, form _akSource, int hitCount)
	 return imsBreakArmorQuest.handleWeaponDrop(_victim, _aggressor, _akSource, hitCount)
endfunction

bool function handleArmorBroken (actor _victim, actor _aggressor, form _akSource, int hitCount)
	return imsBreakArmorQuest.handleArmorBroken(_victim, _aggressor, _akSource, hitCount)
endfunction

bool function isActorFemale(Actor _actor) 
	return imsBreakArmorQuest.isActorFemale(_actor)
endfunction

bool function isWornHalfNaked(Actor _actor) 	
	return imsBreakArmorQuest.isWornHalfNaked(_actor)
endfunction

bool function isWornHalfNakedArmor(Actor _actor)
	return imsBreakArmorQuest.isWornHalfNakedArmor(_actor)
endfunction
