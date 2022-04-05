Scriptname ImmersivePcVoiceMCM extends SKI_ConfigBase
{MCM Menu}
Faction property FactionBanditFriend Auto
Faction property FactionOrcFriend Auto
Location property prevLocation Auto

; int  property playerStyleType Auto			; 0: normal, 1: slutty, 2: sexy, 3: beauty, 4: slave
; int  property playerYoungType Auto			; 0: child, 1: young, 2: mature

bool[] property playerWornMap Auto	
	; 00~09 : hair style
	;	- 0: long, 1: short, 2: bang, 3:ponyTail, 4: pigTail, 5: bold
	;
	; 10~28 : cloth(mask) style
	;	- 10: slutty, 11: sexy, 12: beauty, ,13: cute, 14: shortSkirt, 15: longSkirt, 16: swimSuit, 17: lingerie, 18: rich, 19: begger
	;   - 21: stocking, 22: mask, 23: veinMask, 24: sexyBelt
	;
	; 29~29 : shoe style
	;   - 29: highheel

bool property isPlayerFemale = true Auto
bool property isGameRunning Auto
bool property isWeaponDraw Auto

bool property isNaked Auto
bool property isBareFoot Auto
bool property isWornPanty Auto
bool property isDrunken Auto

int  property weatherType Auto

bool property isInPrevField Auto
bool property isInField Auto

bool property isSit Auto

bool property isInTown Auto
bool property isInMotel Auto
bool property isInCastle Auto
bool property isInStore Auto
bool property isInTemple Auto
bool property isInHome Auto
bool property isInJail Auto
bool property isInBarrack Auto
bool property isInGuild Auto
bool property isInHouse Auto
bool property isInFalmerHive Auto
bool property isInBanditCamp Auto
bool property isInForswornCamp Auto
bool property isInAnimalDen Auto
bool property isInDraugrCrypt Auto
bool property isInHagravenNest Auto
bool property isInVampireLair Auto
bool property isInWarlockLair Auto
bool property isInOrcHoldAuto Auto

bool property isInCampsite Auto
bool property isInRiverwood Auto
bool property isInSolitude Auto
bool property isInWhiterun Auto
bool property isInWinterhold Auto
bool property isInRiften Auto

bool property isLocationClearable Auto 

Armor property wornHair auto
Armor property wornLongHair auto
Armor property wornMask auto
Armor property wornMask2 auto
Armor property wornArmor auto
Armor property wornBoots auto
Armor property wornGlove auto
Armor property wornStocking auto
Armor property wornCloak auto
Armor property wornPanties auto
Armor property wornBelt auto
Armor property ClothesPrisonerTunic Auto 

float property soundCoolTime Auto

; menu option
bool Property enableStatusSound = true Auto
bool Property enableActionSound = true Auto
bool Property enableCombatSound = true Auto
bool Property enableCombatMotion = true Auto
bool Property enableDressMotion = true Auto

Quest property pcVoiceMonologue Auto

int optionIDs = 0

int optionCombatSoundId
int optionStatusSoundId
int optionActionSoundId
int optionCombatMotionId
int optionDressMotionId

int function GetVersion()
  return 20220101
endFunction

event OnConfigOpen()
  ; Reload the JSON data automatically each time the MCM is opened
  	optionIDs = JValue.retain(JMap.object())
endEvent

event OnConfigClose() 
  	JValue.release(optionIDs)
endEvent

Event OnGameReload()
	parent.OnGameReload()
	Debug.notification("monologueVer " + GetVersion())
EndEvent

event OnPageReset(string page)
	; SetCursorFillMode(LEFT_TO_RIGHT)
	SetCursorFillMode(TOP_TO_BOTTOM)

	UnloadCustomContent()
	; AddEmptyOption()
	AddHeaderOption("Player Voice Settings")

	optionCombatSoundId = AddToggleOption("Combat", enableCombatSound)
	optionStatusSoundId = AddToggleOption("Status", enableStatusSound)
	optionActionSoundId = AddToggleOption("Action", enableActionSound)


	AddHeaderOption("Player Motion Settings")

	optionCombatMotionId = AddToggleOption("Combat", enableCombatMotion)
	optionDressMotionId = AddToggleOption("Dress", enableDressMotion)
	;   optionStatusId = AddToggleOption("Status", enableStatusSound)
	;   optionActionId = AddToggleOption("Action", enableActionSound)

	JMap.clear(optionIDs)
		; endIf
	endEvent

event OnOptionSelect(int option)
	if optionCombatSoundId == option 
		enableCombatSound = !enableCombatSound
		SetToggleOptionValue(optionCombatSoundId, enableCombatSound)

		if pcVoiceMonologue.IsRunning()
		pcVoiceMonologue.setActive(enableCombatSound)
		endif
	elseif optionStatusSoundId == option
		enableStatusSound = !enableStatusSound
		SetToggleOptionValue(optionStatusSoundId, enableStatusSound)

		if pcVoiceMonologue.IsRunning()
		pcVoiceMonologue.setActive(enableStatusSound)
		endif
	elseif optionActionSoundId == option
		enableActionSound = !enableActionSound
		SetToggleOptionValue(optionActionSoundId, enableActionSound)

		if pcVoiceMonologue.IsRunning()
		pcVoiceMonologue.setActive(enableActionSound)
		endif
	elseif optionCombatMotionId == option 
		enableCombatMotion = !enableCombatMotion
		SetToggleOptionValue(optionCombatMotionId, enableCombatMotion)

		if pcVoiceMonologue.IsRunning()
		pcVoiceMonologue.setActive(enableCombatMotion)
		endif
	elseif optionDressMotionId == option 
		enableDressMotion = !enableDressMotion
		SetToggleOptionValue(optionDressMotionId, enableDressMotion)

		if pcVoiceMonologue.IsRunning()
		pcVoiceMonologue.setActive(enableDressMotion)
		endif	
	endif
endEvent

function disableOption()
	enableCombatSound = false
	pcVoiceMonologue.setActive(enableCombatSound)

	enableStatusSound = false
	pcVoiceMonologue.setActive(enableStatusSound)

	enableActionSound = false
	pcVoiceMonologue.setActive(enableActionSound)

	enableCombatMotion = false
	pcVoiceMonologue.setActive(enableCombatMotion)

	enableDressMotion = false
	pcVoiceMonologue.setActive(enableDressMotion)	
endfunction

;
;	Utility
;
function updateField(actor _actor)
	int _wt = Weather.GetSkyMode()

	isInPrevField = isInField

	if _wt == 3
		isInField = true
	else
		isInField = false
	endif
endfunction

function updateWeather(actor _actor)
	Weather _curWeather = Weather.GetCurrentWeather()
	if _curWeather
		weatherType = _curWeather.GetClassification()
	endif 
endfunction

function setWeather(int _type)
	weatherType = _type
endfunction

function updateLocation(actor _actor)
		
	clearVisitLocation()

	; 방문한 지역 업데이트	
	Location _curLocation = _actor.GetCurrentLocation()	
	
	if _curLocation != None			
		; in -> field or field -> field
		if isInField
			; field -> field
			if isInPrevField
				isInTown = false
			endif
				
			if _curLocation.HasKeyWordString("LocTypeTown") || _curLocation.HasKeyWordString("LocTypeCity") || _curLocation.HasKeyWordString("LocTypeSettlement")
				isInTown = true

				if _curLocation.HasKeyWordString("LocAreaRiverwood")
					isInRiverwood = true
				elseif _curLocation.HasKeyWordString("LocAreaSolitude")
					isInSolitude = true
				elseif _curLocation.HasKeyWordString("LocAreaWhiterun")
					isInWhiterun = true
				elseif _curLocation.HasKeyWordString("LocAreaWinterhold")
					isInWinterhold = true
				elseif _curLocation.HasKeyWordString("LocAreaRiften")
					isInRiften = true
				endif				
			endif

			if _curLocation.HasKeyWordString("CWCampsite")
				isInCampsite = true			
			endif

			if _curLocation.HasKeyWordString("LocTypeClearable") && !_curLocation.IsCleared()
				isLocationClearable = true
			else 
				isLocationClearable = false
			endif
		endif 

		if isLocationClearable			
			if _curLocation.HasKeyWordString("LocTypeFalmerHive")
				isInFalmerHive = true
			elseif _curLocation.HasKeyWordString("LocTypeBanditCamp") || _curLocation.HasKeyWordString("LocTypeDungeon")
				isInBanditCamp = true
			elseif _curLocation.HasKeyWordString("LocTypeAnimalDen")
				isInAnimalDen = true
			elseif _curLocation.HasKeyWordString("LocTypeForswornCamp")
				isInForswornCamp = true
			elseif _curLocation.HasKeyWordString("LocTypeDraugrCrypt")
				isInDraugrCrypt = true		
			elseif _curLocation.HasKeyWordString("LocTypeOrcStronghold")
				isInOrcHoldAuto = true
			elseif _curLocation.HasKeyWordString("LocTypeHagravenNest")
				isInHagravenNest = true
			elseif _curLocation.HasKeyWordString("LocTypeVampireLair")
				isInVampireLair = true
			elseif _curLocation.HasKeyWordString("LocTypeWarlockLair")
				isInWarlockLair = true
			endif		
		else
			if _curLocation.HasKeyWordString("LocTypeDwelling")
				isLocationClearable = false
				if _curLocation.HasKeyWordString("LocTypeInn")	
					isInMotel = true
				elseif _curLocation.HasKeyWordString("LocTypeStore")
					isInStore = true			
				elseif _curLocation.HasKeyWordString("LocTypeTemple") || _curLocation.HasKeyWordString("LocTypeCemetery")
					isInTemple = true
				elseif _curLocation.HasKeyWordString("LocTypeCastle") 
					isInCastle = true
				elseif _curLocation.HasKeyWordString("LocTypeJail") 
					isInJail = true
				elseif _curLocation.HasKeyWordString("LocTypeBarracks") 
					isInBarrack = true
				elseif _curLocation.HasKeyWordString("LocTypeGuild") 
					isInGuild = true
				elseif _curLocation.HasKeyWordString("LocTypeHouse")					
					if _curLocation.HasKeyWordString("LocTypePlayerHouse")
						; player house		
						isInHome = true
						isInHouse = false
					else 
						; other house	
						isInHome = false			
						isInHouse = true
					endif				
				endif	
			endif		
		endif	
	endif
endFunction 

function clearVisitLocation()
	isInMotel = false
	isInCastle = false
	isInTemple = false
	isInStore = false
	isInHome = false
	isInJail = false
	isInBarrack = false
	isInGuild = false
	isInHouse = false		
	isInFalmerHive = false
	isInBanditCamp = false
	isInForswornCamp = false
	isInAnimalDen = false
	isInDraugrCrypt = false
	isInHagravenNest = false
	isInVampireLair = false
	isInWarlockLair = false
	isInOrcHoldAuto = false

	isInCampsite = false
	isInRiverwood = false
	isInSolitude = false
	isInWhiterun = false
	isInWinterhold = false
	isInRiften = false
endfunction

function setBareFoot(actor _actor,bool _set)
	if _set
		isBareFoot = true
		expression(_actor, "sad")
	else 
		isBareFoot = false
		expression(_actor, "happy")
	endif
endfunction

function setPanty(actor _actor,bool _set)	
	if _set
		isWornPanty = true
	else 
		isWornPanty = false
	endif
endfunction

function setNaked(actor _actor,bool _set)
	if _set
		isNaked = true
		; Debug.Notification("bandit like you")
		_actor.AddToFaction(FactionBanditFriend)
		_actor.AddToFaction(FactionOrcFriend)
		expression(_actor, "sad")
	else 
		isNaked = false
		_actor.RemoveFromFaction(FactionBanditFriend)
		_actor.RemoveFromFaction(FactionOrcFriend)
		expression(_actor, "happy")
	endif
endfunction

function updateActorArmorStatus(actor _actor)

	wornHair  		= _actor.GetWornForm(0x00000002) as Armor		; hair	
	wornLongHair    = _actor.GetWornForm(0x00000800) as Armor		; longHair	
	wornMask        = _actor.GetWornForm(0x00004000) as Armor		; mask
	wornMask2       = _actor.GetWornForm(0x01000000) as Armor		; mask
	wornStocking    = _actor.GetWornForm(0x00800000) as Armor		; stocking	
	wornPanties     = _actor.GetWornForm(0x00080000) as Armor		; panties	
	wornArmor       = _actor.GetWornForm(0x00000004) as Armor		; armor	
	wornCloak       = _actor.GetWornForm(0x00010000) as Armor		; cloak
	wornBoots       = _actor.GetWornForm(0x00000080) as Armor		; boots
	wornBelt        = _actor.GetWornForm(0x04000000) as Armor		; belt
	; wornRing        = _actor.GetWornForm(0x00000040) as Armor		; ring

	playerWornMap = new bool[30]

	if wornHair 	; hair/longHair
		if wornHair.HasKeyWordString("HairStyleLong")
			playerWornMap[0]=true
		elseif wornHair.HasKeyWordString("HairStyleShort")
			playerWornMap[1]=true
		elseif wornHair.HasKeyWordString("HairStyleBang")
			playerWornMap[2]=true
		elseif wornHair.HasKeyWordString("HairStylePonyTail")
			playerWornMap[3]=true
		elseif wornHair.HasKeyWordString("HairStylePigTail")
			playerWornMap[4]=true
		elseif wornHair.HasKeyWordString("HairStyleBold")
			playerWornMap[5]=true
		elseif wornHair.HasKeyWordString("HairStyleCurly")
			playerWornMap[6]=true			
		else 
			playerWornMap[1]=true
		endif	
	endif 

	if  wornLongHair	; hair/longHair
		if wornHair.HasKeyWordString("HairStyleLong")
			playerWornMap[0]=true
		elseif wornHair.HasKeyWordString("HairStyleShort")
			playerWornMap[1]=true
		elseif wornHair.HasKeyWordString("HairStyleBang")
			playerWornMap[2]=true
		elseif wornHair.HasKeyWordString("HairStylePonyTail")
			playerWornMap[3]=true
		elseif wornHair.HasKeyWordString("HairStylePigTail")
			playerWornMap[4]=true
		elseif wornHair.HasKeyWordString("HairStyleBold")
			playerWornMap[5]=true
		else 
			playerWornMap[0]=true
		endif	
	endif 

	if wornMask || wornMask2 ; mask
		if wornMask
			if wornMask.HasKeyWordString("ClothingVeinMask")
				playerWornMap[23]=true
			else 
				playerWornMap[22]=true
			endif			
		elseif wornMask2
			if wornMask2.HasKeyWordString("ClothingVeinMask")
				playerWornMap[23]=true
			else 
				playerWornMap[22]=true
			endif
		endif 
	endif 

	if wornBoots
		if wornBoots.HasKeyWordString("ClothingHeels") || wornBoots.HasKeyWordString("ArmorLongBoots")
			playerWornMap[29]=true
		else 
			playerWornMap[29]=false
		endif	
		setBareFoot(_actor, false)
	else 
		setBareFoot(_actor, true)
	endif 

	if wornStocking 		; stocking
		playerWornMap[21]=true
	else 
		playerWornMap[21]=false
	endif 

	if wornPanties		; panties
		if wornPanties.HasKeyWordString("ClothingStocking") 
			playerWornMap[21]=false
		endif 
	endif

	if wornArmor
		if wornArmor.HasKeyWordString("ClothingSlutty") || wornArmor.HasKeyWordString("ClothingSlave")
			playerWornMap[10]=true
		elseif wornArmor.HasKeyWordString("ClothingSexy")
			playerWornMap[11]=true
		elseif wornArmor.HasKeyWordString("ClothingBeauty")				 					
			playerWornMap[12]=true
		elseif wornArmor.HasKeyWordString("ClothingCute") 					
			playerWornMap[13]=true
		elseif wornArmor.HasKeyWordString("ClothingShortSkirt")
			playerWornMap[14]=true													
		elseif wornArmor.HasKeyWordString("ClothingLongSkirt")	|| wornArmor.HasKeyWordString("ClothingDress") || wornArmor.HasKeyWordString("ClothingWeddingDress")
			playerWornMap[15]=true
		elseif wornArmor.HasKeyWordString("ClothingSwimSuit")					
			playerWornMap[16]=true
		elseif wornArmor.HasKeyWordString("ClothingLingerie")
			playerWornMap[17]=true
		elseif wornArmor.HasKeyWordString("ClothingRich")				
			playerWornMap[18]=true
		elseif wornArmor.HasKeyWordString("ClothingPoor")
			playerWornMap[19]=true			
		endif

		setNaked(_actor, false)
		if wornArmor == ClothesPrisonerTunic
			; Debug.Notification("bandit like you")
			_actor.AddToFaction(FactionBanditFriend)
			_actor.AddToFaction(FactionOrcFriend)
			expression(_actor, "sad")
		elseif _actor.getFactionRank(FactionBanditFriend) > -2
			_actor.RemoveFromFaction(FactionBanditFriend)
			_actor.RemoveFromFaction(FactionOrcFriend)
		endif
	else 
		setNaked(_actor, true)		
	endif 
	
	if wornBelt
		playerWornMap[24]=false		
		if  wornBelt.HasKeyWordString("ClothingSexyBelt")	
			playerWornMap[24]=true	
		endif 
	endif		
endfunction

function expression(actor _actor, string _type)
	if _type == "disgust"
		_actor.SetExpressionOverride(6, 100)			; disgust
		MfgConsoleFunc.SetPhoneme(_actor,13,30)			; mouth
		MfgConsoleFunc.SetModifier(_actor, 0, 10)		; eye left
		MfgConsoleFunc.SetModifier(_actor, 1, 25)		; eye right
	elseif 	_type == "pleasure"
		_actor.SetExpressionOverride(0, 100)			; angry
		MfgConsoleFunc.SetPhoneme(_actor,13,20)			; mouth
		MfgConsoleFunc.SetModifier(_actor, 0, 10)		; eye left
		MfgConsoleFunc.SetModifier(_actor, 1, 25)		; eye right		
	elseif 	_type == "sexy"		
		_actor.SetExpressionOverride(0, 100)			; sexy
		MfgConsoleFunc.SetPhoneme(_actor,13,20)			; mouth
		MfgConsoleFunc.SetModifier(_actor, 0, 10)		; eye left
		MfgConsoleFunc.SetModifier(_actor, 1, 25)		; eye right		
	elseif 	_type == "angry"
		_actor.SetExpressionOverride(0, 100)			; angry
		MfgConsoleFunc.SetPhoneme(_actor,13,20)			; mouth
		MfgConsoleFunc.SetModifier(_actor, 0, 10)		; eye left
		MfgConsoleFunc.SetModifier(_actor, 1, 25)		; eye right
	elseif 	_type == "hate"
		_actor.SetExpressionOverride(0, 100)			; angry
		MfgConsoleFunc.SetPhoneme(_actor,13,20)			; mouth
		MfgConsoleFunc.SetModifier(_actor, 0, 10)		; eye left
		MfgConsoleFunc.SetModifier(_actor, 1, 25)		; eye right		
	elseif 	_type == "happy"
		_actor.SetExpressionOverride(2, 100)			; happy
		MfgConsoleFunc.SetPhoneme(_actor,13,10)			; mouth	
	else		
		_actor.ResetExpressionOverrides()
		MfgConsoleFunc.ResetPhonemeModifier(_actor) 		
	endif	
endfunction 

;
;	0: male, 1: female
;
int function GetGender(Actor _ActorRef)	
	if _ActorRef
		ActorBase BaseRef = _ActorRef.GetLeveledActorBase()
		return BaseRef.GetSex() ; Default
	endIf
	return 0 ; Invalid actor - default to male for compatibility
endFunction


;0=Fists
;1=Swords
;2=Daggers
;3=War Axes
;4=Maces
;5=Greatswords
;6=Battleaxes AND Warhammers
;7=Bows
;8=Staff
;9=Crossbows
bool function isBowWeapon(Weapon _weapon)
	bool _return = false
	int _weaponType = _weapon.GetWeaponType()

	if _weaponType == 7 || _weaponType == 9
		_return = true
	endif

	return _return
endFunction

bool function isUnarmWeapon(Weapon _weapon)
	bool _return = false
	int _weaponType = _weapon.GetWeaponType()

	if _weaponType == 0
		_return = true
	endif

	return _return
endFunction

bool function isStrongWeapon(Weapon _weapon)
	bool _return = false
	int _weaponType = _weapon.GetWeaponType()

	if _weaponType > 2 && _weaponType < 7
		_return = true
	endif

	return _return
endFunction

bool function isStrongArmor(Armor _armor)	
	if _armor.IsHeavyArmor()
		return true
	elseif _armor.IsLightArmor()
		return true
	elseif _armor.IsCuirass()
		return true
	elseif _armor.IsHelmet()
		return true
	endif
	
	return false
endFunction 

bool function isWeakArmor(Armor _armor)
	if _armor.IsClothingBody()
		return true
	elseif _armor.IsClothingFeet()
		return true
	endif
	return false
endFunction 

bool function isBurnArmor(Armor _armor)
	if _armor.GetEnchantment() == none	; 마법옷이라면, burn 되지 않음
		if _armor.IsClothingBody()
			return true
		endif
	endif
	return false
endFunction 

bool function checkFireSpell(form _akSource)
	Spell magicSpell = _akSource as spell

	if magicSpell
		MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

		int idxx=0
		while idxx < magicEffects.length
			; 불 데미지라면 옷이 불에탐
			if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
				return true
			endif
			idxx += 1
		endwhile
	endif

	return false
endfunction

bool function checkOldMaleLovingIt()
	if playerWornMap[1] || playerWornMap[2] || playerWornMap[3] || playerWornMap[10] || playerWornMap[11] || playerWornMap[14] || playerWornMap[16] || playerWornMap[17] || playerWornMap[29]		
		return true
	endif 
	return false
endfunction

bool function checkGuardLovingIt()
	if playerWornMap[4] || playerWornMap[5] || playerWornMap[14] || playerWornMap[15] || playerWornMap[18]
		return true
	endif
	return false
endfunction

bool function checkChildLovingIt()
	if playerWornMap[0] || playerWornMap[2] || playerWornMap[13] || playerWornMap[18]
		return true
	endif
	return false
endfunction

bool function checkMerchantLovingIt()
	if playerWornMap[1] || playerWornMap[12] || playerWornMap[15] || playerWornMap[18]
		return true
	endif
	return false
endfunction

bool function checkNormalFemaleLovingIt()
	if playerWornMap[0] || playerWornMap[12] || playerWornMap[15] || playerWornMap[18] || playerWornMap[29]
		return true
	endif
	return false
endfunction

bool function checkNormalFemaleHate()
	if isNaked || playerWornMap[5] || playerWornMap[10] || playerWornMap[15] || playerWornMap[16] || playerWornMap[17] || playerWornMap[19] || playerWornMap[24]
		return true
	endif
	return false
endfunction

bool function checkNormalMaleLovingIt()
	if playerWornMap[0] || playerWornMap[11] || playerWornMap[14] || playerWornMap[16] || playerWornMap[17] || playerWornMap[21] || playerWornMap[23] || playerWornMap[24] || playerWornMap[29]
		return true
	endif
	return false
endfunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

function Logs(Keyword[] _keywords)
	int len = 0
	while len < _keywords.length
		MiscUtil.PrintConsole(_keywords[len].GetString())
		len += 1
	endwhile
endFunction
