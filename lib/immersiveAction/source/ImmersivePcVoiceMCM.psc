Scriptname ImmersivePcVoiceMCM extends SKI_ConfigBase
{MCM Menu}

GlobalVariable Property hasHairStyle Auto			; 006CE2F3
GlobalVariable Property hasAnimalStyle Auto			; 006CE2EC
GlobalVariable Property isWornDress Auto			; 00663DB4
GlobalVariable Property isWornHeel Auto				; 006CE2EA
GlobalVariable Property isWornSexy Auto				; 006CE2ED
GlobalVariable Property isWornSlutty Auto			; 006CE2EE
GlobalVariable Property isWornBeauty Auto			; 006CE2F1
; GlobalVariable Property isWornSlave Auto			; 006CE2EF
GlobalVariable Property isWornHeavy Auto			; 006CE2F0
GlobalVariable Property isWornNothingHelmet Auto	; 006CE2F2
GlobalVariable Property isWornNothingClothes Auto	; 006CE2EB
GlobalVariable Property isFeelAshamed Auto			; 007CB81B

Faction property PreyFaction Auto
Faction property CreatureFriendFaction Auto
Faction property BanditFriendFaction Auto
Faction property OrcFriendFaction Auto

; Race
Race property ElderRace Auto
Race property OrcRace Auto

VoiceType property MaleOldGrumpy auto
VoiceType property MaleYoungVoice auto

VoiceType property FemaleOldGrumpy auto
VoiceType property FemaleYoungVoice auto

; int  property playerStyleType Auto			; 0: normal, 1: slutty, 2: sexy, 3: beauty, 4: slave
; int  property playerYoungType Auto			; 0: child, 1: young, 2: mature

bool[] property playerWornMap Auto	
	; 00~09 : hair style
	;	- 0: bold, 1, long, 2: short, 3: bang, 4:Tail, 5: curly
	;
	; 10~28 : cloth(mask) style
	;	- 10: slutty, 11: sexy, 12: beauty, 13: cute, 14: skirt, 15: dress, 16: swimSuit, 17: lingerie, 18: rich, 19: begger
	;   - 20: cat
	;   - 25: stocking, 26: mask, 27: veinMask
	;
	; 29~29: shoe style
	;   - 29: highHeel 

int property playerGender = 1 Auto

bool property isNaked Auto

Armor property wornHelmet auto
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
Armor property wornEar auto
Armor property wornTail auto
Armor property ClothesPrisonerTunic Auto 

float property soundCoolTime Auto

; menu option
bool Property enableActionSound = true Auto
bool Property enableDressMotion = true Auto

Quest property pcVoiceAction Auto

int optionIDs = 0

int optionActionSoundId
; int optionIdleSoundId
int optionDressMotionId

int function GetVersion()
  return 20220102
endFunction

event OnLoad()
	if playerWornMap == none 
		playerWornMap =  new bool[35]
	endif
endEvent

event OnConfigOpen()
  ; Reload the JSON data automatically each time the MCM is opened
  	optionIDs = JValue.retain(JMap.object())
endEvent

event OnConfigClose() 
  	JValue.release(optionIDs)
endEvent

Event OnGameReload()
	parent.OnGameReload()
	Debug.notification("playerActionVer " + GetVersion())
EndEvent

event OnPageReset(string page)
	; SetCursorFillMode(LEFT_TO_RIGHT)
	SetCursorFillMode(TOP_TO_BOTTOM)

	UnloadCustomContent()
	; AddEmptyOption()
	AddHeaderOption("Player Voice Settings")

	optionActionSoundId = AddToggleOption("Action", enableActionSound)
	; optionIdleSoundId = AddToggleOption("Idle", enableIdleSound)

	AddHeaderOption("Player Motion Settings")

	optionDressMotionId = AddToggleOption("Dress", enableDressMotion)
	;   optionStatusId = AddToggleOption("Status", enableStatusSound)
	;   optionActionId = AddToggleOption("Action", enableActionSound)

	JMap.clear(optionIDs)
		; endIf
	endEvent

event OnOptionSelect(int option)
	if optionActionSoundId == option
		enableActionSound = !enableActionSound
		SetToggleOptionValue(optionActionSoundId, enableActionSound)

		if pcVoiceAction.IsRunning()
		pcVoiceAction.setActive(enableActionSound)
		endif	
	; elseif optionIdleSoundId == option 
	; 	enableIdleSound = !enableIdleSound
	; 	SetToggleOptionValue(optionIdleSoundId, enableIdleSound)

	; 	if pcVoiceAction.IsRunning()
	; 	pcVoiceAction.setActive(enableIdleSound)
	; 	endif	
	elseif optionDressMotionId == option 
		enableDressMotion = !enableDressMotion
		SetToggleOptionValue(optionDressMotionId, enableDressMotion)

		if pcVoiceAction.IsRunning()
		pcVoiceAction.setActive(enableDressMotion)
		endif	
	endif
endEvent

function disableOption()
	enableActionSound = false
	pcVoiceAction.setActive(enableActionSound)

	; enableIdleSound = false
	; pcVoiceAction.setActive(enableIdleSound)	

	enableDressMotion = false
	pcVoiceAction.setActive(enableDressMotion)	
endfunction

;
;	Utility
;
function setNaked(actor _actor,bool _set)
	if _set
		isNaked = true
		isWornNothingClothes.setValue(-1)
		; Debug.Notification("bandit like you")
		_actor.AddToFaction(BanditFriendFaction)
		_actor.AddToFaction(OrcFriendFaction)
		expression(_actor, "sad")		
	else 
		isNaked = false
		isWornNothingClothes.setValue(0)
		_actor.RemoveFromFaction(BanditFriendFaction)
		_actor.RemoveFromFaction(OrcFriendFaction)
		expression(_actor, "happy")
	endif
endfunction

function updateActorArmorStatus(actor _actor)
	
	wornHelmet  	= _actor.GetWornForm(0x00000001) as Armor		; helmet
	wornHair  		= _actor.GetWornForm(0x00000002) as Armor		; hair
	wornArmor       = _actor.GetWornForm(0x00000004) as Armor		; armor/clothes
	wornBoots       = _actor.GetWornForm(0x00000080) as Armor		; boots
	wornTail		= _actor.GetWornForm(0x00000400) as Armor		; tail
	wornLongHair    = _actor.GetWornForm(0x00000800) as Armor		; longHair	
	wornEar			= _actor.GetWornForm(0x00002000) as Armor		; ear
	wornMask        = _actor.GetWornForm(0x00004000) as Armor		; mask
	wornCloak       = _actor.GetWornForm(0x00010000) as Armor		; cloak
	wornPanties     = _actor.GetWornForm(0x00080000) as Armor		; panties		
	wornStocking    = _actor.GetWornForm(0x00800000) as Armor		; stocking		
	wornMask2       = _actor.GetWornForm(0x01000000) as Armor		; mask
	wornBelt        = _actor.GetWornForm(0x04000000) as Armor		; belt

	playerWornMap = new bool[35]

	if wornHelmet
		isWornNothingHelmet.setValue(0)
	else 		
		isWornNothingHelmet.setValue(-1)
	endif

	if wornHair 	; hair/longHair
		if wornHair.HasKeyWordString("HairStyleBold")
			playerWornMap[0]=true
			hasHairStyle.setValue(0)
		elseif wornHair.HasKeyWordString("HairStyleLong")
			playerWornMap[1]=true
			hasHairStyle.setValue(-1)
		elseif wornHair.HasKeyWordString("HairStyleShort")
			playerWornMap[2]=true
			hasHairStyle.setValue(-2)
		elseif wornHair.HasKeyWordString("HairStyleBang")
			playerWornMap[3]=true
			hasHairStyle.setValue(-3)
		elseif wornHair.HasKeyWordString("HairStylePonyTail") || wornHair.HasKeyWordString("HairStylePigTail")
			playerWornMap[4]=true
			hasHairStyle.setValue(-4)
		elseif wornHair.HasKeyWordString("HairStyleCurly")
			playerWornMap[5]=true
			hasHairStyle.setValue(-5)
		else 
			playerWornMap[2]=true
			hasHairStyle.setValue(-2)
		endif
	else 
		playerWornMap[0]=true
		hasHairStyle.setValue(0)
	endif 

	if  wornLongHair	; hair/longHair
		if wornHair.HasKeyWordString("HairStyleBold")
			playerWornMap[0]=true
			hasHairStyle.setValue(0)
		elseif wornHair.HasKeyWordString("WigLongHair")
			playerWornMap[1]=true
			hasHairStyle.setValue(-1)
		elseif wornHair.HasKeyWordString("WigShortHair")
			playerWornMap[2]=true
			hasHairStyle.setValue(-2)
		elseif wornHair.HasKeyWordString("WigBangHair")
			playerWornMap[3]=true
			hasHairStyle.setValue(-3)
		elseif wornHair.HasKeyWordString("WigPonyTailHair") || wornHair.HasKeyWordString("WigPigTailHair")
			playerWornMap[4]=true
			hasHairStyle.setValue(-4)
		elseif wornHair.HasKeyWordString("HairStyleCurly")
			playerWornMap[5]=true	
			hasHairStyle.setValue(-5)		
		else 
			playerWornMap[1]=true
			hasHairStyle.setValue(-1)
		endif	
	endif 

	if wornMask || wornMask2 ; mask
		if wornMask
			if wornMask.HasKeyWordString("ClothingVeinMask")
				playerWornMap[27]=true
			else 
				playerWornMap[26]=true
			endif			
		elseif wornMask2
			if wornMask2.HasKeyWordString("ClothingVeinMask")
				playerWornMap[27]=true
			else 
				playerWornMap[26]=true
			endif
		endif 
	else 
		playerWornMap[26]=false
		playerWornMap[27]=false
	endif 

	if wornBoots
		if wornBoots.HasKeyWordString("ClothingHeels") || wornBoots.HasKeyWordString("ArmorHeels")
			isWornHeel.setValue(-1)
			playerWornMap[29]=true
		else 
			isWornHeel.setValue(0)
			playerWornMap[29]=false
		endif
	else 
		isWornHeel.setValue(0)
		playerWornMap[29]=false
	endif 

	if wornStocking 		; stocking
		playerWornMap[25]=true
	else 
		playerWornMap[25]=false
	endif 

	if wornPanties		; panties
		if wornPanties.HasKeyWordString("ClothingStocking") 
			playerWornMap[25]=false
		endif 
	endif

	if wornArmor	
		if wornArmor.HasKeyWordString("ClothingSlutty")
			playerWornMap[10]=true
		elseif wornArmor.HasKeyWordString("ClothingSexy")
			playerWornMap[11]=true
		elseif wornArmor.HasKeyWordString("ClothingBeauty")				 					
			playerWornMap[12]=true
		elseif wornArmor.HasKeyWordString("ClothingCute") 					
			playerWornMap[13]=true
		elseif wornArmor.HasKeyWordString("ClothingRich")				
			playerWornMap[18]=true
		elseif wornArmor.HasKeyWordString("ClothingPoor")
			playerWornMap[19]=true					
		endif 
		
		if wornArmor.HasKeyWordString("ClothingSkirt")
			playerWornMap[14]=true
		endif
		if wornArmor.HasKeyWordString("ClothingDress") || wornArmor.HasKeyWordString("ClothingRobe")
			playerWornMap[15]=true
		endif
		if wornArmor.HasKeyWordString("ClothingSwimSuit")					
			playerWornMap[16]=true
		endif
		if wornArmor.HasKeyWordString("ClothingLingerie")
			playerWornMap[17]=true
		endif
		if wornArmor.HasKeyWordString("ClothingAnimal")
			playerWornMap[20]=true		
		endif

		; Logs(wornArmor.GetKeywords()) ; check log

		if playerWornMap[10]			; slutty
			isWornSlutty.setValue(-1)
		else 
			isWornSlutty.setValue(0)
		endif

		if playerWornMap[11] ; sexy
			isWornSexy.setValue(-1)		; clothes
		elseif playerWornMap[16]		
			isWornSexy.setValue(-2)		; swimsuit
		elseif playerWornMap[17]			
			isWornSexy.setValue(-3)		; lingerie
		elseif playerWornMap[27]
			isWornSexy.setValue(-4)  	; vein mask
		else 
			isWornSexy.setValue(0)
		endif
		
		if playerWornMap[12] ; beauty
			isWornBeauty.setValue(-1)	; clothes
		elseif playerWornMap[14] 
			isWornBeauty.setValue(-2)	; skirt
		elseif playerWornMap[15] 
			isWornBeauty.setValue(-3)	; dress
		else 
			isWornBeauty.setValue(0)
		endif
		
		if playerWornMap[14] || playerWornMap[15] || playerWornMap[18]	; dress
			isWornDress.setValue(-1)
		else 
			isWornDress.setValue(0)
		endif
		
		setNaked(_actor, false)
		if wornArmor == ClothesPrisonerTunic
			_actor.AddToFaction(BanditFriendFaction)
			_actor.AddToFaction(OrcFriendFaction)
			expression(_actor, "sad")
		elseif _actor.getFactionRank(BanditFriendFaction) > -2
			_actor.RemoveFromFaction(BanditFriendFaction)
			_actor.RemoveFromFaction(OrcFriendFaction)
		endif
	else 
		setNaked(_actor, true)		
	endif

	hasAnimalStyle.setValue(0)
	if  wornEar
		if wornTail
			if playerWornMap[20]
				hasAnimalStyle.setValue(-4)
			else 
				hasAnimalStyle.setValue(-3)
			endif 
		else 
			hasAnimalStyle.setValue(-1)
		endif 
	elseif wornTail
		hasAnimalStyle.setValue(-2)
	else 
		hasAnimalStyle.setValue(0)
	endif

	if hasAnimalStyle.getValue() == -4
		_actor.AddToFaction(CreatureFriendFaction)
		_actor.AddToFaction(PreyFaction)
	else 
		_actor.RemoveFromFaction(CreatureFriendFaction)
		_actor.RemoveFromFaction(PreyFaction)
	endif

	if wornBelt
		playerWornMap[24]=false		
		if  wornBelt.HasKeyWordString("ClothingBelt")	
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
bool function hasHelmet(actor _actorRef)
	Armor _armor = _actorRef.GetWornForm(0x00000001) as Armor		; head
	if _armor		
		return true
	endif

	return false
endfunction 

int function GetGender(Actor _ActorRef)	
	if _ActorRef
		ActorBase BaseRef = _ActorRef.GetLeveledActorBase()
		return BaseRef.GetSex() ; Default
	endIf
	return 0 ; Invalid actor - default to male for compatibility
endFunction

bool function isAttractiveForFemalePlayer(actor _srcActorRef, Actor _targetActorRef) 
	Armor _wornArmor       = _targetActorRef.GetWornForm(0x00000004) as Armor		; armor
	if _wornArmor == none || _wornArmor.HasKeyWordString("ClothingPoor")
		return false 
	elseif _srcActorRef.IsHostileToActor(_targetActorRef)
		return false
	elseif  _targetActorRef.GetActorBase().getRace() == ElderRace || _targetActorRef.GetActorBase().getRace() == OrcRace
		return false
	elseif _targetActorRef.getVoiceType() == MaleYoungVoice
		return true
	else 
		if Utility.RandomInt(0,1) == 0
			return true
		else
			return false
		endif
	endif
	return false
endFunction

bool function isAttractiveForMalePlayer(actor _srcActorRef, Actor _targetActorRef) 
	Armor _wornArmor       = _srcActorRef.GetWornForm(0x00000004) as Armor		; armor
	if _wornArmor == none || _wornArmor.HasKeyWordString("ClothingPoor")
		return false 
	elseif _srcActorRef.IsHostileToActor(_targetActorRef)
		return false
	elseif  _targetActorRef.GetActorBase().getRace() == ElderRace || _targetActorRef.GetActorBase().getRace() == OrcRace
		return false
	elseif _targetActorRef.getVoiceType() == FemaleYoungVoice
		return true
	else 
		if Utility.RandomInt(0,1) == 0
			return true
		else
			return false
		endif
	endif
	return false
endFunction

bool function checkOldMaleLovingIt()
	if playerWornMap[1] || playerWornMap[2] || playerWornMap[10] || playerWornMap[11] || playerWornMap[14] || playerWornMap[16] || playerWornMap[17] || playerWornMap[29]
		return true
	endif 
	return false
endfunction

bool function checkGuardLovingIt()
	if playerWornMap[5] || playerWornMap[14] || playerWornMap[15] || playerWornMap[18]
		return true
	endif
	return false
endfunction

bool function checkChildLovingIt()
	if playerWornMap[12] || playerWornMap[13] || playerWornMap[18]
		return true
	endif
	return false
endfunction

bool function checkMerchantLovingIt()
	if playerWornMap[12] || playerWornMap[15] || playerWornMap[18]
		return true
	endif
	return false
endfunction

bool function checkNormalFemaleLovingIt()
	if playerWornMap[1] || playerWornMap[2] || playerWornMap[12] || playerWornMap[15] || playerWornMap[18] || playerWornMap[29]
		return true
	endif
	return false
endfunction

bool function checkNormalMaleLovingIt()
	if isNaked || playerWornMap[1] || playerWornMap[11] || playerWornMap[12] || playerWornMap[14]|| playerWornMap[16] || playerWornMap[17] || playerWornMap[25] || playerWornMap[27] || playerWornMap[29]
		return true
	endif
	return false
endfunction

bool function checkNormalHumanHate()
	if playerWornMap[0] || playerWornMap[10] || playerWornMap[19]
		return true
	endif
	return false
endfunction

bool function checkNormalFemaleHate()
	if isNaked || playerWornMap[0] || playerWornMap[10] || playerWornMap[11] || playerWornMap[16] || playerWornMap[17] || playerWornMap[19]
		return true
	endif
	return false
endfunction

bool function isPossibleFemaleAnimation(actor _actorRef)
	if playerGender == 1 && !_actorRef.IsInCombat() && !_actorRef.IsOnMount() && !_actorRef.isSwimming()
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
