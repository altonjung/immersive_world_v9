Scriptname ImmersiveBreakArmor extends Quest

Import Utility

Actor Property Player  Auto

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

bool function handleArmorBroken(actor _victim, actor _aggressor, form _akSource, int _hitCount)

	;화염 데미지라면..
	if _akSource as Spell
		Spell magicSpell = _akSource as spell
		MagicEffect[] magicEffects = magicSpell.GetMagicEffects()
	
		int idxx=0
		while idxx < magicEffects.length
			; 불 데미지라면 옷이 불에탐
			if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
				Armor[] actorArmorList = new Armor[7]						
				actorArmorList[0]	= _victim.GetWornForm(0x00000008) As Armor	; actorHand
				actorArmorList[1]	= _victim.GetWornForm(0x00000080) As Armor	; actorFeet
				actorArmorList[2]	= _victim.GetWornForm(0x00000010) As Armor	; actorArm					
				actorArmorList[3] 	= _victim.GetWornForm(0x00200000) as Armor	; actorChest
				actorArmorList[4]	= _victim.GetWornForm(0x00000004) as Armor	; actorArmor
				actorArmorList[5] 	= _victim.GetWornForm(0x00400000) as Armor	; actorPanty
				actorArmorList[6] 	= _victim.GetWornForm(0x00004000) as Armor	; actorFace
				
				int idx = Utility.RandomInt(0, 3)
				
				while idx < actorArmorList.length 												
						if actorArmorList[idx]					
							float torePercentage =  _getBurnPercentage(_victim, _aggressor, actorArmorList[idx], _hitCount)
							if torePercentage > 90.0
								Debug.Notification("burn cloth")
								_handleArmorDropped(_victim, actorArmorList[idx])
								return true
							endif 	
							return false
						endif			
						idx += 1
				endwhile
				return false
			endif
			idxx += 1
		endwhile
	elseif _akSource as Weapon 		

		Weapon _weapon = _akSource as Weapon

		Armor[] actorArmorList = new Armor[6]
		; 근접 데미지라면..
		if !isHuman(_aggressor)
			; 짐승타입 Npc 공격은 하체 위주 방어구에 영향을 받음			
			actorArmorList[0]	= _victim.GetWornForm(0x00000008) As Armor	; actorHand
			actorArmorList[1]	= _victim.GetWornForm(0x00000080) As Armor	; actorFeet
			actorArmorList[2]	= _victim.GetWornForm(0x00000010) As Armor	; actorArm					
			actorArmorList[3] 	= _victim.GetWornForm(0x00200000) as Armor	; actorChest
			actorArmorList[4]	= _victim.GetWornForm(0x00000004) as Armor	; actorArmor
			actorArmorList[5] 	= _victim.GetWornForm(0x00400000) as Armor	; actorPanty

			int idx = Utility.RandomInt(0, 4)
			while idx < actorArmorList.length 
													
					if actorArmorList[idx]
						float torePercentage =  _getWornPercentage(_victim, _aggressor, actorArmorList[idx], _hitCount)
						if torePercentage > 90.0
							Debug.Notification("worn cloth")
							_handleArmorTaken(_victim, _aggressor, actorArmorList[idx])
							return true
						endif 	
						return false
					endif
		
					idx += 1
			endwhile
		else 
			if _isMeleeWeapon(_weapon)			
				; 인간타입 Npc 공격은 상체 위주 방어구에 영향을 받음			
				actorArmorList[0] 	= _victim.GetWornForm(0x00000020) as Armor	; actorAmulet
				actorArmorList[1] 	= _victim.GetWornForm(0x00004000) as Armor	; actorFace
				actorArmorList[2]	= _victim.GetWornForm(0x00000001) As Armor 	; actorHelmet
				actorArmorList[3] 	= _victim.GetWornForm(0x08000000) as Armor	; actorShoulder
				actorArmorList[4] 	= _victim.GetWornForm(0x00200000) as Armor	; actorChest
				actorArmorList[5]	= _victim.GetWornForm(0x00000004) as Armor	; actorArmor

				int idx = Utility.RandomInt(0, 4)
				while idx < actorArmorList.length 									
						if actorArmorList[idx]
							float torePercentage =  _getBrokenPercentage(_victim, _aggressor, actorArmorList[idx], _hitCount)

							if torePercentage > 90.0
								Debug.Notification("broken armor")
								_handleArmorBroken(_victim, actorArmorList[idx])
								return true
							endif 	
							return false
						endif
			
						idx += 1
				endwhile
			endif
		endif
	endif

	return false
endfunction

; 대상 공격에 대한 방어시 방패나 무기에 대해 대해 일정 확률로 바닥에 drop
bool function handleWeaponDrop(actor _victim, actor _aggressor, form _akSource, int _hitCount)

	Weapon _weapon = _akSource as Weapon

	if _isMeleeWeapon(_weapon)
			; -1 - None
			; 0 - Male
			; 1 - Female
			float dropPercentage = _getDropPercentage(_victim, _aggressor, _hitCount)
					
			if 3 > _victim.GetActorValue("Stamina") && dropPercentage > 90.0
				if _victim.GetEquippedShield()
					_handleArmorDropped(_victim, _victim.GetEquippedShield())
				elseif _victim.GetEquippedWeapon(true) ; left weapon				
					_handleWeaponDropped(_victim, _victim.GetEquippedWeapon(true))				
				elseif _victim.GetEquippedWeapon(false) ; right weapon
					_handleWeaponDropped(_victim, _victim.GetEquippedWeapon(false))
				else 
					; fist
					Armor[] actorArmorList = new Armor[2]

					actorArmorList[0]	= _victim.GetWornForm(0x00000008) As Armor	; actorHand
					actorArmorList[1]	= _victim.GetWornForm(0x00000010) As Armor	; actorArm	
						
					int idx = 0
						
					; armor
					while idx < actorArmorList.length 
	
						if actorArmorList[idx]
							Debug.Notification("broken weapon")
							_handleArmorDropped(_victim, actorArmorList[idx])						
							return true
						endif						
	
						idx += 1
					endwhile
				endif				
			endif
		endif

		return false
endfunction

bool function _handleClothWorn (Actor _actor, Armor _armor)
	if _armor.IsClothing() && !_armor.IsHeavyArmor() && !_armor.IsLightArmor()
		return _handleArmorRemoved(_actor, _armor)
	endif 

	return false
endFunction

bool function _handleArmorBroken (Actor _actor, Armor _armor)
	return _handleArmorRemoved(_actor, _armor)
endFunction

bool function _handleArmorRemoved (Actor _actor, Armor _armor)
	_actor.RemoveItem(_armor)
	return true	
endFunction

bool function _handleArmorTaken (Actor _victim, Actor _aggressor, Armor _armor)
	_victim.RemoveItem(_armor)
	_aggressor.addItem(_armor)
	return true	
endFunction

bool function _handleArmorDropped (Actor _actor, Armor _armor)
	_actor.DropObject(_armor)
	return true	
endFunction

bool function _handleWeaponDropped (Actor _actor, Weapon _weapon)
	_actor.DropObject(_weapon)
	return true	
endFunction

bool Function _isMeleeWeapon(Weapon _weapon)
	return _weapon.IsMace() || _weapon.IsGreatsword() || _weapon.IsWarhammer() || _weapon.IsWarAxe() || _weapon.IsBattleaxe()
EndFunction 

float function _getDropPercentage(actor _victim, actor _aggressor, int _hitCount)
	; -1 - None
	; 0 - Male
	; 1 - Female
	float dropPercentage = Utility.RandomInt(30 + _hitCount, 70 + _hitCount)
		
	if  _victim.GetActorBase().GetSex() == 0 ; 공격자가 남자라면
		dropPercentage = dropPercentage * 1.2
	endif

	return dropPercentage

endfunction

float function _getBurnPercentage(actor _victim, actor _aggressor, armor _armor, int _hitCount)

	float dropPercentage = 0.0
	if _armor.IsClothing()		
		dropPercentage = Utility.RandomInt(30 + _hitCount, 70 + _hitCount)
	endif 

	if _armor.IsLightArmor()		
		dropPercentage = Utility.RandomInt(1 + _hitCount, 40 + _hitCount)
	endif 

	if _armor.IsHeavyArmor()		
		dropPercentage = Utility.RandomInt(1 + _hitCount, 20 + _hitCount)
	endif 

	return dropPercentage
endfunction

float function _getWornPercentage(actor _victim, actor _aggressor, armor _armor, int _hitCount)
	; -1 - None
	; 0 - Male
	; 1 - Female
	float dropPercentage = 0.0

	if _armor.IsLightArmor()	
		dropPercentage = Utility.RandomInt(1 + _hitCount, 30 + _hitCount)
	endif 

	if _armor.IsHeavyArmor()		
		dropPercentage = Utility.RandomInt(1 + _hitCount, 20 + _hitCount)
	endif 

	if _armor.IsClothing()
		dropPercentage = Utility.RandomInt(30 + _hitCount, 50 + _hitCount)
		if _victim.GetActorBase().GetSex() == 0 ; 공격자가 남자라면
			dropPercentage = dropPercentage * 1.2
		endif 
	endif 

	return dropPercentage
endfunction

float function _getBrokenPercentage(actor _victim, actor _aggressor, armor _armor, int _hitCount)
	; -1 - None
	; 0 - Male
	; 1 - Female
	float dropPercentage = 0.0
	bool isHeavyArmor = false

	if _armor.IsHeavyArmor()
		
		float aggressorHeight = _aggressor.GetHeight()
		float victimHeight = _victim.GetHeight()
		
		if (aggressorHeight - victimHeight > 5) 
			dropPercentage = Utility.RandomInt(10, 30)
		elseif (aggressorHeight - victimHeight > 10) 
			dropPercentage = Utility.RandomInt(30, 50)
		endif

		int aggressorGender = _victim.GetActorBase().GetSex()

		if  aggressorGender == 0
			dropPercentage = dropPercentage * 1.5
		endif		

		dropPercentage += Utility.RandomInt(0, 30)		
		
	endif

	return dropPercentage
endfunction

bool function _checkWornItem(Actor _actor, Armor _armor)
	bool returnValue = false
	if _armor.IsClothingBody() || _armor.IsHeavyArmor() || _armor.IsLightArmor() || _armor.IsCuirass()
		if _actor.GetWornForm(0x00000004)				
			returnValue = true
		endif
	elseif _armor.IsHelmet() || _armor.IsClothingHead()
		if _actor.GetWornForm(0x00000001)	
			returnValue = true
		endif 
	elseif _armor.IsBoots() || _armor.IsClothingFeet()
		if _actor.GetWornForm(0x00000080)			
			returnValue = true
		endif
	elseif _armor.IsGauntlets()
		if _actor.GetWornForm(0x00000010)		
			returnValue = true
		endif
	else 
		if _actor.GetWornForm(0x00004000)	
			returnValue = true
		endif
	endif

	return returnValue
endfunction

bool function isActorFemale(Actor _actor) 
	if _actor.GetActorBase().GetSex() == 1
		return true
	else 
		return false
	endif
endfunction

bool function isWornHalfNaked(Actor _actor) 	
	if !_actor.GetWornForm(0x00000004)
		return true
	else 
		return false
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
