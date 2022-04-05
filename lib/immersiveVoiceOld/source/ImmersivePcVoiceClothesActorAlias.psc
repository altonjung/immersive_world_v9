scriptname ImmersivePcVoiceClothesActorAlias extends ReferenceAlias

int    undressCount

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

; Sound  _dressSound
; String _checkExpress
; String playClotheCheckAnimation
; float  _dressAnimationDelay
; float  _dressSoundDelay
; bool   isDoingUnequipProcess
; bool   isDoingEquipProcess
bool   isDressPlay
bool   isInventoryMode
bool   shouldPlayNakeSound
bool   isPlayingCheckAnimation

Armor  lastEquipedArmor

Event OnInit()
	; initMenu()	
EndEvent

event OnLoad()
	setup()
	init()
endEvent

; save -> load 시 호출
Event OnPlayerLoadGame()
	init()
EndEvent

function setup()
	pcVoiceMCM.updateActorArmorStatus(playerRef)

	; 맨발이면
	; if pcVoiceMCM.wornBoots == none
	; 	; playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") - 15.0)
	; endif
endFunction

; function initMenu()	
; 	; UnregisterForAllMenus()
; 	; RegisterForMenu("InventoryMenu")
; endFunction

function init ()
	UnregisterForMenu("InventoryMenu")
	RegisterForMenu("InventoryMenu")

	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeExpress = "happy"
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0
	
	isInventoryMode = false
	shouldPlayNakeSound = false

    isPlayingCheckAnimation = false
	lastEquipedArmor = none

	undressCount = 0
	UnregisterForUpdate()
	pcVoiceMCM.playerWornMap =  new bool[30]
	pcVoiceMCM.updateActorArmorStatus(playerRef)
endFunction

;
;	Menu
;
Event OnMenuOpen(string menuName)
	if menuName == "InventoryMenu"
		isInventoryMode = true
	endif
endEvent

Event OnMenuClose(string menuName)
	if menuName == "InventoryMenu"
		; if isDoingUnequipProcess
		; 	while isDoingUnequipProcess
		; 		Utility.WaitMenuMode(0.1)
		; 	endWhile
		; endif 
	
		; if isDoingEquipProcess
		; 	while isDoingEquipProcess
		; 		Utility.WaitMenuMode(0.1)
		; 	endWhile
		; endif
		pcVoiceMCM.updateActorArmorStatus(playerRef)			
		if !playerRef.IsInCombat()
			if pcVoiceMCM.isNaked && shouldPlayNakeSound
				; naked 출력
				Sound _playSound = none
				if !pcVoiceMCM.isInHome
					undressCount += 1
					if undressCount >= 10
						_playSound = SayStateNakedIrritateSound
						undressCount = 0
					else
						_playSound = SayStateNakedShockSound					
					endif
				else 
					_playSound = SayStateNakedComfortSound
				endif
				
				if _playSound 
					SoundCoolTimePlay(_playSound, _delay=0.2, _express="sad")
					shouldPlayNakeSound = false
					Debug.SendAnimationEvent(playerRef, "immNakeCover_" + Utility.randomInt(1,3))
				endif
			else
				; 옷 체크
				if lastEquipedArmor && isPlayingCheckAnimation == false
					isPlayingCheckAnimation = true					
					Sound  _dressSound = none
    				string _checkExpress = ""
					string _checkAnimation = ""
    				float  _dressAnimationDelay = 3.0
    				float  _dressSoundDelay = 0.3
					bool   _isSayingSpecialWord = false
					bool   _isHaireAnimation = false
					bool   _isNeedIntroAnimation = false
					Armor _armor = lastEquipedArmor
					lastEquipedArmor = none
					int    _slotMask = _armor.GetSlotMask()
					if Math.LogicalAnd(_slotMask, 0x00000002) == 0x00000002			; hair/longHair		
						_isHaireAnimation = true
						if pcVoiceMCM.playerWornMap[0]
							_dressSound = SayReactionLongHairSound
							_checkExpress = "beauty"
						elseif pcVoiceMCM.playerWornMap[1]
							_checkExpress = "cute"
							_dressSound = SayReactionBangHairSound				
						elseif pcVoiceMCM.playerWornMap[2]
							_checkExpress = "cute"
							_dressSound = SayReactionPonyHairSound
						elseif pcVoiceMCM.playerWornMap[3]
							_checkExpress = "cute"
							_dressSound = SayReactionPigHairSound
						elseif pcVoiceMCM.playerWornMap[4]
							_checkExpress = "hate"
							_dressSound = SayReactionBoldHairSound									
						else
							_checkExpress = "cute"
							_dressSound = SayReactionShortHairSound
						endif

						if _checkExpress == "beauty" && Utility.randomInt(1,4) == 1
							_checkAnimation = "ImmCheckHair"
						else 
							_checkAnimation = "ImmCheckHairLong"
						endif					
					elseif Math.LogicalAnd(_slotMask, 0x00000800) == 0x00000800		; longHair
						_isHaireAnimation = true
						_checkExpress = "beauty"
						if pcVoiceMCM.playerWornMap[1]
							_checkExpress = "cute"
							_dressSound = SayReactionShortHairSound
						elseif pcVoiceMCM.playerWornMap[2]
							_checkExpress = "cute"
							_dressSound = SayReactionBangHairSound
						elseif pcVoiceMCM.playerWornMap[3]
							_checkExpress = "cute"
							_dressSound = SayReactionPonyHairSound
						elseif pcVoiceMCM.playerWornMap[4]
							_checkExpress = "cute"
							_dressSound = SayReactionPigHairSound
						elseif pcVoiceMCM.playerWornMap[5]
							_checkExpress = "hate"
							_dressSound = SayReactionBoldHairSound		
						else
							_dressSound = SayReactionLongHairSound							
						endif

						if _checkExpress == "beauty" && Utility.randomInt(1,4) == 1
							_checkAnimation = "ImmCheckHair"
						else 
							_checkAnimation = "ImmCheckHairLong"
						endif
					elseif _slotMask ==	0x01000000 || _slotMask == 0x00004000       ; mask
						_checkAnimation = "ImmCheckMask"
						_dressSound = SayReactionMaskSound
						if _armor.HasKeyWordString("ClothingVeinMask")
							_dressSound = SayReactionVeinMaskSound
							_checkExpress = "sexy"
						endif
					elseif _slotMask == 0x00000020									; necklace
						_checkAnimation = "ImmCheckNecklace"
						_checkExpress = "beauty"
						_dressSound = SayDefaultSound			
					elseif _slotMask == 0x00000080									; boots
						_dressAnimationDelay = 4.5			
						_checkAnimation = "ImmCheckBoots"
						_dressSound = SayDefaultSound
						if _armor.HasKeyWordString("ClothingHeels")
							_checkExpress = "beauty"
							_dressSound = SayReactionHeelsSound
						endif			
					elseif _slotMask == 0x00800000 									; stocking
						_dressAnimationDelay = 4.5
						_checkAnimation = "ImmCheckStocking"
						_dressSound = SayReactionStockingSound
						_checkExpress = "beauty"
					elseif _slotMask == 0x00080000									; panties
						_dressSound = SayReactionPantyClothSound
						_checkAnimation = "ImmCheckPanties"
						if  _armor.HasKeyWordString("ClothingStocking") 
							_dressAnimationDelay = 4.5
							_checkAnimation = "ImmCheckStocking"
							_dressSound = SayReactionStockingSound	
						endif 
					elseif Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004 || Math.LogicalAnd(_slotMask, 0x00400000) == 0x00400000
						_checkAnimation = "ImmCheckClothes"
						_dressSound = SayDefaultSound
						if checkDressClothes(_armor)
							isWornDress.setValue(1)
						else
							isWornDress.setValue(0)
						endif

						if Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004		; clothes
							shouldPlayNakeSound = false
							clearRunnintSoundRes()
							_checkExpress = "happy"
							if pcVoiceMCM.playerWornMap[10]
								_dressSound = SayReactionSluttyClothSound
								_checkExpress = "hate"
							elseif pcVoiceMCM.playerWornMap[11]
								_dressSound = SayReactionSexyClothSound
								_checkExpress = "sexy"
							elseif pcVoiceMCM.playerWornMap[12]
								_dressSound = SayReactionBeautyClothSound
								_checkExpress = "beauty"
							elseif pcVoiceMCM.playerWornMap[13]
								_checkExpress = "cute"
								_dressSound = SayReactionCuteClothSound
							elseif pcVoiceMCM.playerWornMap[14]
								_dressSound = SayReactionBeautyClothSound
								_checkExpress = "beauty"
							elseif pcVoiceMCM.playerWornMap[15]
								_dressSound = SayReactionBeautyClothSound
								_checkExpress = "beauty"
							elseif pcVoiceMCM.playerWornMap[16]
								_dressSound = SayReactionSexyClothSound
								_checkExpress = "sexy"
							elseif pcVoiceMCM.playerWornMap[17]
								_dressSound = SayReactionSexyClothSound
								_checkExpress = "sexy"					
							elseif pcVoiceMCM.playerWornMap[18]
								_dressSound = SayReactionFancyClothSound
							elseif _armor.HasKeyWordString("ClothingPoor")
								_dressSound = SayReactionPoorClothSound
								_checkExpress = "hate"
							elseif _armor.HasKeyWordString("ClothingPanties")
								_dressSound = SayReactionPantyClothSound
								_checkAnimation = "ImmCheckPanties"
							elseif _armor.HasKeyWordString("ClothingSexyPanties")
								_dressSound = SayReactionSexyClothSound
								_checkAnimation = "ImmCheckPanties"
								_checkExpress = "sexy"
							else
								_dressSound = SayReactionNormalClothSound
							endif
						elseif Math.LogicalAnd(_slotMask, 0x00400000) == 0x00400000	; checkpanty
							_dressSound = SayReactionPantyClothSound
							_checkAnimation = "ImmCheckPanties"
						endif
					elseif _slotMask == 0x00400000 									; panty
						_dressAnimationDelay = 3.0
						_dressSound = SayReactionPantyClothSound
						_checkAnimation = "ImmCheckPanties"
					elseif _slotMask == 0x00000008 || _slotMask == 0x00000040		; glove or ring
						_dressAnimationDelay = 3.0
						_dressSound = SayDefaultSound
						_checkAnimation = "ImmCheckGlove"
						_checkExpress = ""
						if _armor.HasKeyWordString("ClothingRingSayEng")
							_isSayingSpecialWord = true
							_dressSound = SayDefaultSpecialEngSound
						elseif _armor.HasKeyWordString("ClothingRingSayKor")
							_dressSound = SayDefaultSpecialKorSound
							_isSayingSpecialWord = true
						elseif _armor.HasKeyWordString("ClothingRingSayBugFix")
							_isSayingSpecialWord = true
							_isNeedIntroAnimation = true
							_dressSound = SayDefaultSpecialBugFixSound
						endif
					elseif _slotMask ==	0x02000000  								; tongue
						_dressAnimationDelay = 3.0
						_dressSound = SayDefaultSound
					else
						_checkAnimation = "ImmCheckDefault"
						if _armor.HasKeyWordString("ClothingSexyBelt")
							_dressSound = SayReactionSexyClothSound			
						endif
					endif

					; 10% 확률로 감탄사 제공
					if !_isSayingSpecialWord					
						if _dressSound && Utility.randomInt(1,10) == 5
							if  _checkExpress == "hate"
								_dressSound = SayReactionDisappointSound
							else 
								_dressSound = SayReactionSatisfactionSound						
							endif
						endif
							
						SoundCoolTimePlay(_dressSound, _delay = _dressSoundDelay, _express=_checkExpress)

						if _checkAnimation != ""
							if pcVoiceMCM.enableDressMotion && !playerRef.isSwimming() && !playerRef.IsSprinting()
								; 카메라 기능 오류 있음
								; int _cameraMode = Game.GetCameraState()
								; Game.ForceThirdPerson()
								Debug.SendAnimationEvent(playerRef, _checkAnimation + "Start")
								Utility.Wait(_dressAnimationDelay)
								Debug.SendAnimationEvent(playerRef, _checkAnimation + "End")
								
								if !_isHaireAnimation && _checkExpress != ""									
									_dressAnimationDelay = 3.5
									if _checkExpress == "happy" || _checkExpress == "beauty" || _checkExpress == "cute"
										SoundCoolTimePlay(SayEmotionPrettyLaughSound, _delay=0.3, _express=_checkExpress)
									elseif _checkExpress == "sexy"
										SoundCoolTimePlay(SayEmotionSexyLaughSound, _delay=0.3, _express=_checkExpress)
									elseif _checkExpress == "hate"
										SoundCoolTimePlay(SayEmotionSighSound, _delay=0.2, _express=_checkExpress)
									endif

									Debug.SendAnimationEvent(playerRef, "Imm" + _checkExpress + "Start_" + Utility.randomInt(1,3))
									Utility.Wait(_dressAnimationDelay)
								else 
									Utility.Wait(1.0)
								endif
								Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")			
								; if _cameraMode == 0 ; firstPerson
								; 	Game.ForceFirstPerson()
								; endif
							endif
						endif					
					else
						SoundCoolTimePlay(_dressSound, _delay = _dressSoundDelay, _express=_checkExpress)						
						if _isNeedIntroAnimation	
							Debug.SendAnimationEvent(playerRef, "ImmRitualKneelStart")
							Utility.Wait(20.0)
							Debug.SendAnimationEvent(playerRef, "ImmRitualKneelEnd")
						endif

						Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")		
					ENDIF

					isPlayingCheckAnimation = false					
				endif
			ENDIF
		endif
		isInventoryMode = false
	endif
endEvent
;
;	Cloth status
;
Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)	
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	Armor _armor = akBaseObject as armor

	if _armor
		if lastEquipedArmor
			if lastEquipedArmor == _armor
				lastEquipedArmor = none
			endif			
		endif

		int _slotMask = _armor.GetSlotMask()
		if Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004		; clothes
			if isInventoryMode
				shouldPlayNakeSound = true
			else
				SoundCoolTimePlay(SayStateNakedShockSound, _delay=1.5, _express="sad")
			endif
		endif
	endif
EndEvent

; 옷투정은 첫 필드에 참여시 부터 적용
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)	
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	Armor _armor = akBaseObject as armor

	if _armor
		lastEquipedArmor = _armor
	endif
EndEvent

Event OnUpdate()
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	; sound play
	if runningCoolTimeSoundRes != None
		if runningCoolTimeSoundRes == SayStateNakedShockSound || runningCoolTimeSoundRes == SayStateNakedIrritateSound || runningCoolTimeSoundRes == SayStateNakedComfortSound
			; nake 상태 한번더 확인
			if !pcVoiceMCM.isNaked
				pcVoiceMCM.soundCoolTime = -3.0
				return						
			endif
		endif

		pcVoiceMCM.soundCoolTime = runningCoolTimeSoundCurtime + runningCoolTimeSoundCoolingTime
		Sound.SetInstanceVolume(runningCoolTimeSoundRes.Play(playerRef), runningCoolTimeSoundVolume)
		pcVoiceMCM.expression(playerRef, runningCoolTimeExpress)
		runningCoolTimeSoundRes = none
		runningCoolTimeSoundVolume = 0.0
		runningCoolTimeSoundCoolingTime = 0.0
		runningCoolTimeSoundCurtime = 0.0		
		runningCoolTimeExpress = ""
	endif
endEvent

;
;	Utility
;
bool function checkDressClothes(armor _armor)
	bool _isDress = false
	if _armor.HasKeyWordString("ClothingDress") || _armor.HasKeyWordString("ClothingRobe") || _armor.HasKeyWordString("ClothingWedding") || _armor.HasKeyWordString("ClothingShortSkirt") || _armor.HasKeyWordString("ClothingLongSkirt")
		_isDress = true
	endif

	return _isDress
endfunction 

function clearRunnintSoundRes()
	UnregisterForUpdate()
	runningCoolTimeSoundRes = none	
	pcVoiceMCM.soundCoolTime = 0.0
endFunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 2.0, float _delay = 0.3, String _express)
	if playerRef.IsSwimming() || (playerRef.IsInCombat() && _sound != SayStateNakedShockSound)
		return
	endif

	while Utility.IsInMenuMode()
		Utility.WaitMenuMode(0.1)
	endWhile

	float currentTime = Utility.GetCurrentRealTime()
	; pcVoiceMCM.log("currentTime " + currentTime + ", colTime " + pcVoiceMCM.soundCoolTime + " nake " + pcVoiceMCM.isNaked)
	if currentTime >= pcVoiceMCM.soundCoolTime
		if _delay == 0.0	
			pcVoiceMCM.soundCoolTime = currentTime + _coolTime + _delay
			runningCoolTimeSoundRes = none
			runningCoolTimeSoundVolume = 0.0
			Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
			pcVoiceMCM.expression(playerRef, _express)
		else
			runningCoolTimeExpress = _express
			runningCoolTimeSoundRes = _sound
			runningCoolTimeSoundVolume = _volume			
			runningCoolTimeSoundCurtime = currentTime
			runningCoolTimeSoundCoolingTime = _coolTime
			UnregisterForUpdate()
			RegisterForSingleUpdate(_delay)
		endif
	endif
endFunction

ImmersivePcVoiceMCM property pcVoiceMCM Auto

Actor property playerRef Auto

Faction property FactionPreyFaction Auto

Sound property SayStateNakedComfortSound Auto
Sound property SayStateNakedShockSound Auto
Sound property SayStateNakedIrritateSound Auto

Sound property SayReactionSluttyClothSound Auto
Sound property SayReactionSexyClothSound Auto
Sound property SayReactionBeautyClothSound Auto
Sound property SayReactionCuteClothSound Auto
Sound property SayReactionPantyClothSound Auto
Sound property SayReactionPoorClothSound Auto
Sound property SayReactionFancyClothSound Auto
Sound property SayReactionStockingSound Auto
Sound property SayReactionSatisfactionSound Auto
Sound property SayReactionDisappointSound Auto
Sound property SayReactionHeelsSound Auto
Sound property SayReactionMaskSound Auto
Sound property SayReactionVeinMaskSound Auto
Sound property SayReactionNormalClothSound Auto

Sound property SayReactionBoldHairSound Auto	; HairStyleBold
Sound property SayReactionLongHairSound Auto	; HairStyleLong
Sound property SayReactionShortHairSound Auto	; HairStyleShort
Sound property SayReactionPonyHairSound Auto	; HairStylePonyTail
Sound property SayReactionPigHairSound Auto		; HairStylePigTail
Sound property SayReactionBangHairSound Auto	; HairStyleBang

Sound property SayEmotionSexyLaughSound Auto
Sound property SayEmotionPrettyLaughSound Auto
Sound property SayEmotionSighSound Auto
Sound property SayEmotionEmbarrasSound Auto

Sound property SayDefaultSound Auto
Sound property SayDefaultSpecialEngSound Auto
Sound property SayDefaultSpecialKorSound Auto
Sound property SayDefaultSpecialBugFixSound Auto

GlobalVariable Property isWornDress Auto			; 향후에 horse 탈때 활용 예정