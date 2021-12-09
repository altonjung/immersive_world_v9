Scriptname ImmersiveArmor extends Quest

Actor Property Player  Auto
Armor Property ArmorPrisonerRags Auto
Armor Property ArmorBanditCuirass Auto
Armor Property ArmorBanditCuirass1 Auto
Armor Property ArmorBanditCuirass2 Auto
Armor Property ArmorBanditCuirass3 Auto
Armor Property ArmorBanditHelmet Auto
Armor Property ArmorForswornCuirass Auto
Armor Property ArmorForswornHelmet Auto

Faction property FactionBanditFriend Auto
Faction property FactionCreartureFriend Auto

Sound property IntroSound Auto

Import Utility

int Version
int Function VersionCheck()
	Version = 2
	Return Version
EndFunction

bool function isHuman(Actor _actor) 
	if  _actor.HasKeyWordString("ActorTypeCreature") || _actor.HasKeyWordString("ActorTypeAnimal")
		return false
	else 
		return true
	endif
endfunction

Sound function getIntroSound()
	return IntroSound
endfunction	

Faction function getFactionBanditFriend()
	return FactionBanditFriend
endfunction 

Faction function getFactionCreatureFriend()
	return FactionCreartureFriend
endfunction 

bool function isPlayer(actor _actorRef)
	if Player == _actorRef
		return true
	else 
		return false
	endif
endfunction

; 옷이 타는 경우(화염 데미지라면..)
bool function handleArmorBurn(actor _victim, actor _aggressor, form _akSource)
	
	Armor[] actorArmorList = new Armor[8]
	actorArmorList[0]	= _victim.GetWornForm(0x00000008) As Armor	; actorHand	
	actorArmorList[1]	= _victim.GetWornForm(0x00000080) As Armor	; actorBoot
	actorArmorList[2] 	= _victim.GetWornForm(0x00800000) as Armor	; actorThigh	
	actorArmorList[3]	= _victim.GetWornForm(0x00000010) As Armor	; actorArm
	actorArmorList[4] 	= _victim.GetWornForm(0x00004000) as Armor	; actorFace						
	actorArmorList[5] 	= _victim.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
	actorArmorList[6]	= _victim.GetWornForm(0x00000004) as Armor	; actorArmor
	actorArmorList[7] 	= _victim.GetWornForm(0x00400000) as Armor	; actorPanty

	int idx = 0
	while idx < actorArmorList.length
		if actorArmorList[idx] && isBurnableArmor(actorArmorList[idx])			
			return _handleArmorBurn(_victim, actorArmorList[idx])
		endif				
		idx += 1
	endwhile

	return false
endfunction

; 옷이 찢어지는 경우
bool function handleArmorTear(actor _victim, actor _aggressor, form _akSource)	
	
	Armor[] actorArmorList = new Armor[9]	
	actorArmorList[0]	= _victim.GetWornForm(0x00000008) As Armor	; actorHand
	actorArmorList[1]	= _victim.GetWornForm(0x00000080) As Armor	; actorBoot
	actorArmorList[3] 	= _victim.GetWornForm(0x00800000) as Armor	; actorThigh	
	actorArmorList[4]	= _victim.GetWornForm(0x00000010) As Armor	; actorArm
	actorArmorList[5] 	= _victim.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
	actorArmorList[6] 	= _victim.GetWornForm(0x00008000) as Armor	; actorSkirts
	actorArmorList[7]	= _victim.GetWornForm(0x00000004) as Armor	; actorArmor		
	actorArmorList[8] 	= _victim.GetWornForm(0x00400000) as Armor	; actorPanty

	int idx = 0
	while idx < actorArmorList.length 													
		if actorArmorList[idx] && isTornableArmor(actorArmorList[idx])
			return _handleClothTear(_victim, actorArmorList[idx])
		endif 							
		idx += 1
	endwhile

	return false
endfunction

; 옷이 벗겨져 땅에 떨어지는 경우
bool function handleArmorDrop(actor _victim, actor _aggressor, form _akSource)	

	Armor[] actorArmorList = new Armor[4]	
	actorArmorList[0] 	= _victim.GetWornForm(0x00000020) as Armor	; actorAmulet
	actorArmorList[1]	= _victim.GetWornForm(0x00000008) As Armor	; actorHand	
	actorArmorList[2]	= _victim.GetWornForm(0x00001000) As Armor 	; actorHelmet
	actorArmorList[3] 	= _victim.GetWornForm(0x08000000) as Armor	; actorShoulder
		
	int idx = 0
	while idx < actorArmorList.length 													
		if actorArmorList[idx] && isDropableArmor(actorArmorList[idx])			
			return _handleClothDrop(_victim, actorArmorList[idx])
		endif 							
		idx += 1
	endwhile	
	return false
endfunction

bool function _handleClothTear (Actor _actor, Armor _armor)
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

; 불에 탈수 있는 옷
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

; 찢길수 있는 옷
bool function isTornableArmor(Armor _armor)
	if _armor.IsClothingBody()
		return true
	elseif _armor.IsClothingFeet()
		return true
	elseif _armor.IsClothingHands()
		return true
	endif
	return false
endFunction 

; 벗겨질수 있는 옷
bool function isDropableArmor(Armor _armor)
	if _armor.IsHelmet()
		return true
	elseif _armor.IsJewelry()
		return true		
	elseif _armor.IsShield()
		return true
	endif
	return false
endFunction 

; Bandit 친화 옷
bool function isBanditArmor(Armor _armor)
	if _armor == ArmorPrisonerRags
		return true
	elseif _armor == ArmorBanditCuirass
		return true		
	elseif _armor == ArmorBanditCuirass1
		return true	
	elseif _armor == ArmorBanditCuirass2
		return true	
	elseif _armor == ArmorBanditCuirass3
		return true		
	elseif _armor == ArmorBanditHelmet
		return true						
	endif
	return false
endFunction 

; Animal 친화 옷
bool function isForswornArmor(Armor _armor)
	if _armor == ArmorForswornCuirass
		return true
	elseif _armor == ArmorForswornHelmet
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