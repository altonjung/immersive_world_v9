scriptname ImmersivePcVoiceClothesActorAlias extends ReferenceAlias

int    undressCount

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

Sound  playDressSound
String playDressExpress
String playClotheCheckAnimation
float  playDressAnimationDelay
float  playDressSoundDelay
bool   isDressPlay
bool   isInventoryMode
bool   shouldPlayNaked

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
	
    playDressSound = none
    playDressExpress = ""
	playClotheCheckAnimation = ""
    playDressAnimationDelay = 2.0
    playDressSoundDelay = 0.3
	isDressPlay = false
	isInventoryMode = false
	shouldPlayNaked = false

	undressCount = 0
	UnregisterForUpdate()
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
		if !playerRef.IsInCombat() && isDressPlay == false
			isDressPlay = true
			if player.isNaked && shouldPlayNaked
				; naked 출력
				Sound _playSound = none
				if !pcVoiceMCM.isInHome
					undressCount += 1
					_playExpress = "angry"
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
					SoundCoolTimePlay(_playSound, _delay=2.5, _express="sad")
					shouldPlayNaked = false
				endif				
			else
				; 10% 확률로 감탄사 제공
				if playDressSound && Utility.randomInt(1,10) == 5
					if  playDressExpress == "hate"
						playDressSound = SayReactionDisappointSound
					else 
						playDressSound = SayReactionSatisfactionSound						
					endif
				endif
				
				SoundCoolTimePlay(playDressSound, _delay = playDressAnimationDelay, _express=playDressExpress)

				if playClotheCheckAnimation != ""
					if pcVoiceMCM.enableDressMotion && !playerRef.isSwimming() && !playerRef.IsSprinting()
						; 카메라 기능 오류 있음
						; int _cameraMode = Game.GetCameraState()
						; Game.ForceThirdPerson()
						Debug.SendAnimationEvent(playerRef, playClotheCheckAnimation + "Start")
						Utility.Wait(playDressAnimationDelay)
						Debug.SendAnimationEvent(playerRef, playClotheCheckAnimation + "End")
						Utility.Wait(0.2)

						if playDressExpress != ""					
							if playDressExpress == "happy"
								playDressAnimationDelay = 3.0
								SoundCoolTimePlay(SayEmotionPrettyLaughSound, _delay=0.7, _express=playDressExpress)
							elseif playDressExpress == "sexy"
								playDressAnimationDelay = 4.5
								SoundCoolTimePlay(SayEmotionSexyLaughSound, _delay=0.7, _express=playDressExpress)
							elseif playDressExpress == "hate"
								SoundCoolTimePlay(SayEmotionSighSound, _delay=0.2, _express=playDressExpress)
								playDressAnimationDelay = 1.5
							elseif playDressExpress == "cute"
								SoundCoolTimePlay(SayEmotionSighSound, _delay=0.7, _express=playDressExpress)
								playDressAnimationDelay = 3.0
							endif

							Debug.SendAnimationEvent(playerRef, "Imm" + playDressExpress + "Start_"+ Utility.randomInt(1,3))
							Utility.Wait(playDressAnimationDelay)
						endif
						Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")						
						; if _cameraMode == 0 ; firstPerson
						; 	Game.ForceFirstPerson()
						; endif
					endif
					clearRunningPlayDress()
				endif
			endif
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
		Sound _playSound = none
		String _playExpress = "happy"
		; float  _speechBonus = 0.0
		; float  _speedBonus = 0.0 
		
		; int _slotMask = _armor.GetSlotMask()

		; if _slotMask == 0x00000002
		; 	if _armor.HasKeyWordString("HairStyleLong")
		; 		; _speechBonus = -3.0
		; 	elseif _armor.HasKeyWordString("HairStyleShort")
		; 		; _speechBonus = -1.0
		; 	elseif _armor.HasKeyWordString("HairStylePony")
		; 		; _speechBonus = -1.0
		; 	endif
		; endif 

		; if _slotMask == 0x00000080 || _slotMask == 0x00800000
		; 	if _armor.HasKeyWordString("ArmorHeels")
		; 		; _speechBonus = -3.0
		; 		; _speedBonus = -5.0
		; 	elseif  _armor.HasKeyWordString("ArmorStocking")
		; 	else 
		; 		; _speedBonus = -15.0
		; 	endif
		; endif

		pcVoiceMCM.updateActorArmorStatus(playerRef)

		if Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004	; clothes
			if checkDressClothes(_armor)
				wornDress.setValue(1)
			endif
			
			if _armor.HasKeyWordString("ClothingSlutty") 
				; _speechBonus = 3.0
			elseif _armor.HasKeyWordString("ClothingSexy") 
				; _speechBonus = -3.0
			elseif _armor.HasKeyWordString("ClothingBeauty")
				; _speechBonus = -5.0
			endif
			shouldPlayNaked = true

			if !isInventoryMode
				SoundCoolTimePlay(SayStateNakedShockSound, _delay=2.5, _express="sad")
			endif 
		endif

		; playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechBonus)
		; playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + _speedBonus)
	endif	
EndEvent

; 옷투정은 실제 처음 필드에 참여시 부터 적용
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)		
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	; if _dressAniType == 1
	; 	Debug.SendAnimationEvent(playerRef, "ImmCheckHair")
	; 	Utility.Wait(3.0)
	; elseif _dressAniType == 2
	; 	Debug.SendAnimationEvent(playerRef, "ImmCheckBoots")
	; 	Utility.Wait(2.5)
	; elseif _dressAniType == 3
	; 	Debug.SendAnimationEvent(playerRef,"ImmCheckClothes")
	; 	Utility.Wait(3.0)
	; elseif _dressAniType == 4
	; 	Debug.SendAnimationEvent(playerRef,"ImmCheckGlove")
	; 	Utility.Wait(3.0)
	; elseif _dressAniType == 5
	; 	Debug.SendAnimationEvent(playerRef,"ImmCheckPanty")
	; 	Utility.Wait(3.0)
	; endif 

	; string playClotheCheckAnimation = ""	; "ImmCheckHair", "ImmCheckBoots", "ImmCheckGlove", "ImmCheckPanty"
	Armor _armor = akBaseObject as armor

	if _armor				
		pcVoiceMCM.updateActorArmorStatus(playerRef)		

		int _slotMask = _armor.GetSlotMask()

		; pcVoiceMCM.log("slot " + _slotMask)
	
		if _slotMask == 0x00000002
			playDressAnimationDelay = 3.0
			playClotheCheckAnimation = "ImmCheckHair"
			playDressExpress = "happy"
			if _armor.HasKeyWordString("HairStyleLong")
				; _speechBonus = 3.0
				playDressSound = SayReactionLongHairSound				
			elseif _armor.HasKeyWordString("HairStyleShort")				
				; _speechBonus = 1.0
				playDressSound = SayReactionShortHairSound
			elseif _armor.HasKeyWordString("HairStyleBang")
				playDressExpress = "cute"
				; _speechBonus = 3.0
				playDressSound = SayReactionBangHairSound				
			elseif _armor.HasKeyWordString("HairStylePonyTail")
				playDressExpress = "cute"
				; _speechBonus = 1.0
				playDressSound = SayReactionPonyHairSound
			elseif _armor.HasKeyWordString("HairStylePigTail")
				; _speechBonus = 1.0
				playDressExpress = "cute"
				playDressSound = SayReactionPigHairSound
			elseif _armor.HasKeyWordString("HairStyleBold")
				; _speechBonus = 1.0
				playDressSound = SayReactionBoldHairSound		
				playDressExpress = "hate"
			endif			
		elseif _slotMask ==	0x01000000 || _slotMask == 0x00004000 || _slotMask == 0x00000020; mask or necklace
			playDressAnimationDelay = 3.0
			playClotheCheckAnimation = "ImmCheckNecklace"
			playDressSound = SayReactionMaskSound
			if _armor.HasKeyWordString("ClothingVeinMask")
				playDressSound = SayReactionVeinMaskSound
			endif
		elseif _slotMask == 0x00000080
			playDressAnimationDelay = 4.0			
			playClotheCheckAnimation = "ImmCheckBoots"
			playDressSound = SayDefaultSound
			if _armor.HasKeyWordString("ArmorHeels") || _armor.HasKeyWordString("ArmorLongBoots")
				; _speechBonus = 3.0
				playDressSound = SayReactionHeelsSound
			endif			
		elseif _slotMask == 0x00800000 		; stocking
			playDressAnimationDelay = 4.5
			playClotheCheckAnimation = "ImmCheckStocking"
			playDressSound = SayReactionStockingSound	
			; ArmorStocking
		elseif _slotMask == 0x00080000		; panties
			playDressAnimationDelay = 3.0
			playDressSound = SayReactionPantyClothSound
			playClotheCheckAnimation = "ImmCheckPanties"
			if _armor.HasKeyWordString("ClothingStocking") 
				playDressAnimationDelay = 4.5
				playClotheCheckAnimation = "ImmCheckStocking"
				playDressSound = SayReactionStockingSound	
			endif 
			; ArmorStocking
		elseif Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004
			playDressAnimationDelay = 3.0
			playClotheCheckAnimation = "ImmCheckClothes"
			playDressSound = SayDefaultSound
			if checkDressClothes(_armor)
				wornDress.setValue(1)
			endif

			if Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004	; clothes
				shouldPlayNaked = false
				clearRunnintSoundRes()
				if _armor.HasKeyWordString("ClothingSlutty") || _armor.HasKeyWordString("ClothingSlave")
					; _speechBonus = -3.0
					playDressSound = SayReactionSluttyClothSound
					playDressExpress = "hate"
				elseif _armor.HasKeyWordString("ClothingSexy") || _armor.HasKeyWordString("ClothingLingerie") ||  _armor.HasKeyWordString("ClothingSwimming")
					; _speechBonus = 3.0
					playDressSound = SayReactionSexyClothSound
					playDressExpress = "sexy"
				elseif _armor.HasKeyWordString("ClothingBeauty") || _armor.HasKeyWordString("ClothingWeddingDress") || _armor.HasKeyWordString("ClothingShortSkirt")
					; _speechBonus = 5.0
					playDressExpress = "happy"
					playDressSound = SayReactionBeautyClothSound
				elseif _armor.HasKeyWordString("ClothingCute") || _armor.HasKeyWordString("ClothingLongSkirt")
					playDressExpress = "cute"
					playDressSound = SayReactionCuteClothSound
				elseif _armor.HasKeyWordString("ClothingPoor")
					playDressSound = SayReactionPoorClothSound
					playDressExpress = "hate"
				elseif _armor.HasKeyWordString("ClothingRich") || _armor.HasKeyWordString("ClothingDress")
					playDressExpress = "happy"
					playDressSound = SayReactionFancyClothSound
				elseif _armor.HasKeyWordString("ClothingPanties")
					playDressSound = SayReactionPantyClothSound
					playClotheCheckAnimation = "ImmCheckPanties"
				elseif _armor.HasKeyWordString("ClothingSexyPanties")
					playDressSound = SayReactionSluttyClothSound
					playClotheCheckAnimation = "ImmCheckPanties"
					playDressExpress = "sexy"
				else
					playDressSound = SayReactionNormalClothSound
				endif
			elseif Math.LogicalAnd(_slotMask, 0x00400000) == 0x00400000	; checkpanty
				playDressSound = SayReactionPantyClothSound
				playClotheCheckAnimation = "ImmCheckPanties"
			endif
		elseif _slotMask == 0x00400000 ; panty
			playDressAnimationDelay = 3.0
			playDressSound = SayReactionPantyClothSound
			playClotheCheckAnimation = "ImmCheckPanties"
		elseif _slotMask == 0x00000008 || _slotMask == 0x00000040	; glove or ring
			playDressAnimationDelay = 3.0
			playDressSound = SayDefaultSound
			playClotheCheckAnimation = "ImmCheckGlove"
			if _armor.HasKeyWordString("ClothingRingSayEng")
				playDressExpress = "hate"
				playDressSound = SayDefaultSpecialEngSound
				pcVoiceMCM.log("SayDefaultSpecialEngSound")
			elseif _armor.HasKeyWordString("ClothingRingSayKor")
				playDressExpress = "hate"
				pcVoiceMCM.log("SayDefaultSpecialKorSound")
				playDressSound = SayDefaultSpecialKorSound
			endif
		elseif _slotMask ==	0x02000000  ; tongue
			playDressAnimationDelay = 3.0
			playDressSound = SayDefaultSound	
		else
			playClotheCheckAnimation = "ImmCheckDefault"
			if _armor.HasKeyWordString("ClothingSexyBelt")
				playDressSound = SayReactionSexyClothSound			
			endif
		endif

		; playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechBonus)	
		; playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + _speedBonus)

		; pcVoiceMCM.log("_speechBonus " + _speechBonus + ", _speedBonus " + _speedBonus)
		; pcVoiceMCM.log("Speechcraft " + playerRef.GetActorValue("Speechcraft"))
		; pcVoiceMCM.log("speedmult " + playerRef.GetActorValue("speedmult"))	
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
		runningCoolTimeExpress = "happy"
	endif
endEvent

;
;	Utility
;
bool function checkDressClothes()
	bool _isDress = false
	if _armor.HasKeyWordString("ClothingDress") || _armor.HasKeyWordString("ClothingRobe") || _armor.HasKeyWordString("ClothingWedding") || _armor.HasKeyWordString("ClothingShortSkirt") || _armor.HasKeyWordString("ClothingLongSkirt")
		_isDress = true
	endif

	return _isDress
endfunction 

function clearRunningPlayDress()
	playDressSound = none
	playDressExpress = ""
	playClotheCheckAnimation = ""
	playDressAnimationDelay = 2.0
	playDressSoundDelay = 0.3
	isDressPlay = false
endFunction

function clearRunnintSoundRes()
	UnregisterForUpdate()
	runningCoolTimeSoundRes = none	
	pcVoiceMCM.soundCoolTime = 0.0
endFunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 2.0, float _delay = 0.5, String _express)
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

Sound property SayStateNakedComfortSound Auto
Sound property SayStateNakedShockSound Auto
Sound property SayStateNakedIrritateSound Auto

Sound property SayReactionSluttyClothSound Auto
Sound property SayReactionBeautyClothSound Auto
Sound property SayReactionSexyClothSound Auto
Sound property SayReactionNormalClothSound Auto
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

GlobalVariable Property wornDress Auto