scriptname ImmersivePcVoiceClothesActorAlias extends ReferenceAlias

int    undressCount

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

Event OnInit()
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

function init ()
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeExpress = "happy"
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	undressCount = 0
	UnregisterForUpdate()
endFunction

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
		
		int _slotMask = _armor.GetSlotMask()

		if _slotMask == 0x00000002
			if _armor.HasKeyWordString("HairStyleLong")
				; _speechBonus = -3.0
			elseif _armor.HasKeyWordString("HairStyleShort")
				; _speechBonus = -1.0
			elseif _armor.HasKeyWordString("HairStylePony")
				; _speechBonus = -1.0
			endif
		endif 

		if _slotMask == 0x00000080 || _slotMask == 0x00800000
			if _armor.HasKeyWordString("ArmorHeels")
				; _speechBonus = -3.0
				; _speedBonus = -5.0
			elseif  _armor.HasKeyWordString("ArmorStocking")
			else 
				; _speedBonus = -15.0
			endif
		endif

		if _slotMask == 0x00000004 || _slotMask == 0x00400000
			if _armor.HasKeyWordString("ClothingDress") || _armor.HasKeyWordString("ClothingRobe") || _armor.HasKeyWordString("ClothingWedding") || _armor.HasKeyWordString("ClothingShortSkirt") || _armor.HasKeyWordString("ClothingLongSkirt")
				wornDress.setValue(0)
			endif
			
			if _armor.HasKeyWordString("ClothingSlutty") 
				; _speechBonus = 3.0
			elseif _armor.HasKeyWordString("ClothingSexy") 
				; _speechBonus = -3.0
			elseif _armor.HasKeyWordString("ClothingBeauty")
				; _speechBonus = -5.0
			endif
		endif

		; playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechBonus)
		; playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + _speedBonus)

		pcVoiceMCM.updateActorArmorStatus(playerRef)

		if !playerRef.IsInCombat()
			if pcVoiceMCM.isNaked
				; naked 출력
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
			endif

			if _playSound 
				SoundCoolTimePlay(_playSound, _express=_playExpress)
			endif
		endif
	endif	
EndEvent

; 옷투정은 실제 처음 필드에 참여시 부터 적용
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)		
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	int _dressAniType = 0
	Armor _armor = akBaseObject as armor

	if _armor		
		pcVoiceMCM.updateActorArmorStatus(playerRef)
		Sound _playSound = none
		String _playExpress = "happy"
		; float  _speechBonus = 0.0
		; float  _speedBonus = 0.0
		bool   _isHate = false
		bool   _isHappy = false
		; bool   _isSexy = false

		int _slotMask = _armor.GetSlotMask()
		
		if _slotMask == 0x00000002
			_dressAniType = 1
			if _armor.HasKeyWordString("HairStyleLong")
				; _speechBonus = 3.0
				_playSound = SayReactionLongHairSound
			elseif _armor.HasKeyWordString("HairStyleShort")
				; _speechBonus = 1.0
				_playSound = SayReactionShortHairSound
			elseif _armor.HasKeyWordString("HairStylePony")
				; _speechBonus = 1.0
				_playSound = SayReactionPonyHairSound
			elseif _armor.HasKeyWordString("HairStylePig")
				; _speechBonus = 1.0
				_playSound = SayReactionPigHairSound
			elseif _armor.HasKeyWordString("HairStyleBold")
				; _speechBonus = 1.0
				_playSound = SayReactionBoldHairSound		
				_isHate = true		
			else 
				_dressAniType = 2
				_playSound = SayReactionNormalClothSound
			endif			
		elseif _slotMask == 0x00000080 
			if _armor.HasKeyWordString("ArmorHeels") || _armor.HasKeyWordString("ArmorShortBoots") || _armor.HasKeyWordString("ArmorLongBoots")
				; _speechBonus = 3.0
				_playSound = SayReactionHeelsSound			
			else
				_playSound = SayReactionNormalClothSound
			endif
			_dressAniType = 2
		elseif _slotMask == 0x00800000
			if _armor.HasKeyWordString("ArmorStocking")
				_playSound = SayReactionStockingSound
			else
				_playSound = SayReactionNormalClothSound
			endif
		elseif Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004
			if Math.LogicalAnd(_slotMask, 0x00400000) == 0x00400000	; checkpanty
				_playSound = SayReactionPantyClothSound
				_dressAniType = 5
			else 
				_dressAniType = 3
				if _armor.HasKeyWordString("ClothingDress") || _armor.HasKeyWordString("ClothingRobe") || _armor.HasKeyWordString("ClothingWedding") || _armor.HasKeyWordString("ClothingShortSkirt") || _armor.HasKeyWordString("ClothingLongSkirt")
					wornDress.setValue(1)
				endif

				if _armor.HasKeyWordString("ClothingSlutty") || _armor.HasKeyWordString("ClothingSlave")
					; _speechBonus = -3.0
					_playSound = SayReactionSluttyClothSound
					_playExpress = "sad"	
					_isHate = true
				elseif _armor.HasKeyWordString("ClothingSexy") || _armor.HasKeyWordString("ClothingLingerie") ||  _armor.HasKeyWordString("ClothingSwimming")
					; _speechBonus = 3.0
					_playSound = SayReactionSexyClothSound
					; _isSexy = true
				elseif _armor.HasKeyWordString("ClothingBeauty") || _armor.HasKeyWordString("ClothingWedding") || _armor.HasKeyWordString("ClothingShortSkirt") || _armor.HasKeyWordString("ClothingLongSkirt")
					; _speechBonus = 5.0
					_isHappy = true
					_playSound = SayReactionBeautyClothSound
				elseif _armor.HasKeyWordString("ClothingPoor")
					_playSound = SayReactionPoorClothSound
					_isHate = true
				elseif _armor.HasKeyWordString("ClothingRich") || _armor.HasKeyWordString("ClothingDress")
					_playSound = SayReactionFancyClothSound
					_isHappy = true
				elseif _armor.HasKeyWordString("ClothingPanty") || _armor.HasKeyWordString("ClothingSexyPanty") || _armor.HasKeyWordString("ClothingSluttyPanty")
					_playSound = SayReactionPantyClothSound
					_dressAniType = 5				
				else
					_playSound = SayReactionNormalClothSound
				endif
			endif 			
		elseif _slotMask == 0x00400000 ; panty
			_playSound = SayReactionPantyClothSound
			_dressAniType = 5
		elseif _slotMask == 0x00000008	; glove
			_playSound = SayDefaultSound
			_dressAniType = 4
		else 			
			if _armor.HasKeyWordString("ClothingSexyBelt")
				_playSound = SayDefaultSound
				_dressAniType = 3			
			endif
		endif

		; playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechBonus)	
		; playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + _speedBonus)

		if !playerRef.IsInCombat() && pcVoiceMCM.isInventoryMenuMode
				; 10% 확률로 감탄사 제공
				if _playSound && Utility.randomInt(1,10) > 9
					if _isHate 
						_playSound = SayReactionDisappointSound
						_playExpress = "sad"
					else 
						_playSound = SayReactionSatisfactionSound
						_playExpress = "happy"
					endif 
				endif

				SoundCoolTimePlay(_playSound, _express=_playExpress)				
				if _dressAniType > 0
					if pcVoiceMCM.enableDressMotion && !playerRef.isSwimming() && !playerRef.IsSprinting()
						int _cameraMode = Game.GetCameraState()
						if _cameraMode == 0 ; firstPerson
							Game.ForceThirdPerson()
						endif

						if _dressAniType == 1
							Debug.SendAnimationEvent(playerRef, "ImmCheckHair")
							Utility.Wait(3.0)
						elseif _dressAniType == 2
							Debug.SendAnimationEvent(playerRef, "ImmCheckBoots")
							Utility.Wait(2.5)
						elseif _dressAniType == 3
							Debug.SendAnimationEvent(playerRef,"ImmCheckClothes")
							Utility.Wait(3.0)
						elseif _dressAniType == 4
							Debug.SendAnimationEvent(playerRef,"ImmCheckGlove")
							Utility.Wait(3.0)
						elseif _dressAniType == 5
							Debug.SendAnimationEvent(playerRef,"ImmCheckPanty")
							Utility.Wait(3.0)
						endif 
	
						if _isHappy
							SoundCoolTimePlay(SayDefaultLaughSound, _delay=0.0, _express="happy")
							Debug.SendAnimationEvent(playerRef,"ImmHappy" + Utility.randomInt(1,3))
							Utility.Wait(5.0)
						; elseif _isSexy
						; 	SoundCoolTimePlay(SayDefaultFeelingSound, _delay=0.0, _express="sexy")
						; 	Debug.SendAnimationEvent(playerRef,"ImmSexy" + Utility.randomInt(1,3))
						; 	Utility.Wait(5.0)
						elseif _isHate
							; SoundCoolTimePlay(SayDefaultFeelingSound, _delay=0.0, _express="sad")
							Debug.SendAnimationEvent(playerRef,"ImmHate" + Utility.randomInt(1,2))
							Utility.Wait(3.0)
						endif
						
						if _cameraMode == 0 ; firstPerson
							Game.ForceFirstPerson()
						endif
	
						Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")
					endif
				endif
		endif

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
		if runningCoolTimeSoundRes == SayStateNakedShockSound || runningCoolTimeSoundRes == SayStateNakedIrritateSound
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
function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.5, float _delay = 0.5, String _express)
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
Sound property SayReactionPantyClothSound Auto
Sound property SayReactionPoorClothSound Auto
Sound property SayReactionFancyClothSound Auto
Sound property SayReactionStockingSound Auto
Sound property SayReactionSatisfactionSound Auto
Sound property SayReactionDisappointSound Auto
Sound property SayReactionHeelsSound Auto

Sound property SayReactionBoldHairSound Auto	; HairStyleBold
Sound property SayReactionLongHairSound Auto	; HairStyleLong
Sound property SayReactionShortHairSound Auto	; HairStyleShort
Sound property SayReactionPonyHairSound Auto	; HairStylePony
Sound property SayReactionPigHairSound Auto		; HairStylePony
Sound property SayReactionBangHairSound Auto	; HairStyleBang

Sound property SayDefaultLaughSound Auto
Sound property SayDefaultFeelingSound Auto
Sound property SayDefaultSound Auto

GlobalVariable Property wornDress Auto