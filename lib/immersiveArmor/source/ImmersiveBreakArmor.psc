Scriptname ImmersiveBreakArmor extends Quest

Actor Property Player  Auto
Faction property banditFriendFaction Auto
Faction property creartureFriendFaction Auto

Import Utility

int Version
int Function VersionCheck()
	Version = 2
	Return Version
EndFunction

bool function isHuman(Actor _actor) 
	if  _actor.HasKeyWordString("ActorTypeCreature")
		return false
	else 
		return true
	endif
endfunction

Faction function getBanditFriendFaction()
	return banditFriendFaction
endfunction 

Faction function getCreatureFriendFaction()
	return creartureFriendFaction
endfunction 

bool function isPlayer(actor _actorRef)
	if Player == _actorRef
		return true
	else 
		return false
	endif
endfunction

bool function handleArmorBurn(actor _victim, actor _aggressor, form _akSource)

	;화염 데미지라면..
	Armor[] actorArmorList = new Armor[7]						
	actorArmorList[0]	= _victim.GetWornForm(0x00000008) As Armor	; actorHand
	actorArmorList[1]	= _victim.GetWornForm(0x00000080) As Armor	; actorFeet
	actorArmorList[2]	= _victim.GetWornForm(0x00000010) As Armor	; actorArm					
	actorArmorList[3] 	= _victim.GetWornForm(0x00200000) as Armor	; actorChest
	actorArmorList[4]	= _victim.GetWornForm(0x00000004) as Armor	; actorArmor
	actorArmorList[5] 	= _victim.GetWornForm(0x00400000) as Armor	; actorPanty
	actorArmorList[6] 	= _victim.GetWornForm(0x00004000) as Armor	; actorFace

	int idx = 0
	while idx < actorArmorList.length
		if actorArmorList[idx] && isBurnableArmor(actorArmorList[idx])
			Debug.Notification(_victim.GetActorBase().GetName() + " cloth burned")
			return _handleArmorBurn(_victim, actorArmorList[idx])
		endif				
		idx += 1
	endwhile

	return false
endfunction

bool function handleArmorBroken(actor _victim, actor _aggressor, form _akSource)	

	Weapon _weapon = _akSource as Weapon

	Armor[] actorArmorList = new Armor[6]
	; 짐승타입 Npc 공격은 하체 위주 방어구에 영향을 받음			
	actorArmorList[0]	= _victim.GetWornForm(0x00000008) As Armor	; actorHand
	actorArmorList[1]	= _victim.GetWornForm(0x00000080) As Armor	; actorFeet
	actorArmorList[2]	= _victim.GetWornForm(0x00000010) As Armor	; actorArm					
	actorArmorList[3] 	= _victim.GetWornForm(0x00200000) as Armor	; actorChest
	actorArmorList[4]	= _victim.GetWornForm(0x00000004) as Armor	; actorArmor
	actorArmorList[5] 	= _victim.GetWornForm(0x00400000) as Armor	; actorPanty

	int idx = 0
	while idx < actorArmorList.length 													
		if actorArmorList[idx] && isWornableArmor(actorArmorList[idx])
			Debug.Notification(_victim.GetActorBase().GetName() + " cloth broken")
			return _handleClothWorn(_victim, actorArmorList[idx])
		endif 							
		idx += 1
	endwhile

	return false
endfunction

bool function handleArmorDrop(actor _victim, actor _aggressor, form _akSource)	

	Weapon _weapon = _akSource as Weapon

	Armor[] actorArmorList = new Armor[6]

	; 근접 데미지라면..
	actorArmorList[0] 	= _victim.GetWornForm(0x00000020) as Armor	; actorAmulet
	actorArmorList[1] 	= _victim.GetWornForm(0x00004000) as Armor	; actorFace
	actorArmorList[2]	= _victim.GetWornForm(0x00000001) As Armor 	; actorHelmet
	actorArmorList[3] 	= _victim.GetWornForm(0x08000000) as Armor	; actorShoulder
	actorArmorList[4] 	= _victim.GetWornForm(0x00200000) as Armor	; actorChest
	actorArmorList[5]	= _victim.GetWornForm(0x00000004) as Armor	; actorArmor
		
	int idx = 0
	while idx < actorArmorList.length 													
		if actorArmorList[idx] && isDropableArmor(actorArmorList[idx])
			Debug.Notification(_victim.GetActorBase().GetName() + " cloth dropped")
			return _handleClothDrop(_victim, actorArmorList[idx])
		endif 							
		idx += 1
	endwhile	
	return false
endfunction

bool function _handleClothWorn (Actor _actor, Armor _armor)
	return _handleArmorRemoved(_actor, _armor)
endFunction

bool function _handleArmorBurn(Actor _actor, Armor _armor)
	return _handleArmorRemoved(_actor, _armor)
endFunction

bool function _handleClothDrop (Actor _actor, Armor _armor)
	return _handleArmorDropped(_actor, _armor)
endFunction

bool function _handleArmorRemoved (Actor _actor, Armor _armor)
	_actor.RemoveItem(_armor)
	return true	
endFunction

bool function _handleArmorDropped (Actor _actor, Armor _armor)
	_actor.DropObject(_armor)
	return true	
endFunction

bool Function _isMeleeWeapon(Weapon _weapon)
	return _weapon.IsMace() || _weapon.IsGreatsword() || _weapon.IsWarhammer() || _weapon.IsWarAxe() || _weapon.IsBattleaxe()
EndFunction 

bool function isBurnableArmor(Armor _armor)

	if _armor.GetEnchantment() == none	; 마법옷이라면, burn 되지 않음
		if _armor.IsClothingBody()
			return true
		elseif _armor.IsClothingHead()
			return true
		elseif _armor.IsClothingFeet()
			return true
		elseif _armor.IsClothingHands()
			return true
		endif
	endif
	return false
endFunction 

bool function isWornableArmor(Armor _armor)

	if isBurnableArmor(_armor)
		return true
	elseif _armor.IsLightArmor()
		return true
	endif 

	return false
endFunction 

bool function isDropableArmor(Armor _armor)

	if isBurnableArmor(_armor)
		return true
	elseif _armor.IsHeavyArmor()
		return true
	endif 

	return false
endFunction 

bool function isActorFemale(Actor _actor) 
	if _actor.GetActorBase().GetSex() == 1
		return true
	else 
		return false
	endif
endfunction

bool function isWornHalfNaked(Actor _actor) 	
	if _actor.GetWornForm(0x00000004)
		return false
	else 
		return true
	endif 
endfunction

bool function isWornHalfNakedArmor(Actor _actor)
	Armor _armor =_actor.GetWornForm(0x00000004) as Armor 

	if _armor != none && (_armor.HasKeyWordString("SLA_ArmorTransparent") || _armor.HasKeyWordString("SLA_ArmorCurtain") || _armor.HasKeyWordString("SLA_ArmorHalfNaked") || _armor.HasKeyWordString("SLA_ArmorHalfNakedBikini") ||  _armor.HasKeyWordString("SLA_PastiesNipple"))
		return true
	else 
		return false
	endif 
endfunction


; float function getWornPercentage(Armor _armor)

; 	if !_armor.GetEnchantment()	; 마법옷이라면, burn 되지 않음
; 		if _armor.IsClothingBody()
; 			return 2.0
; 		elseif _armor.IsClothingHead()
; 			return 50.0
; 		elseif _armor.IsClothingFeet()
; 			return 80.0
; 		elseif _armor.IsClothingHands()
; 			return 80.0
; 		endif
; 	endif
; 	return 0.0
; endFunction