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
		float  _speechBonus = 0.0
		float  _speedBonus = 0.0 

		if _armor.IsHelmet()
			if _armor.HasKeyWordString("HairStyleLong")
				_speechBonus = -3.0
			elseif _armor.HasKeyWordString("HairStyleShort")
				_speechBonus = -1.0
			elseif _armor.HasKeyWordString("HairStylePony")
				_speechBonus = -1.0
			endif
		endif 

		if _armor.IsBoots()
			if _armor.HasKeyWordString("ArmorHeels")
				_speechBonus = -3.0
				; _speedBonus = -5.0
			else 
				; _speedBonus = -15.0
			endif
		endif

		if _armor.IsClothingBody() || _armor.IsLightArmor() || _armor.IsHeavyArmor()
			; naked 출력
			if !pcVoiceMCM.isInHome
				undressCount += 1
				_playExpress = "angry"
				if undressCount >= 10
					_playSound = SayStateNakedIrritateSound					
				else
					_playSound = SayStateNakedShockSound
					undressCount = 0
				endif
			else 
				_playSound = SayStateNakedComfortSound
			endif

			if _armor.HasKeyWordString("ClothingSlutty") || _armor.HasKeyWordString("SOS_Revealing") 
				_speechBonus = 3.0
			elseif _armor.HasKeyWordString("ClothingSexy") 
				_speechBonus = -3.0
			elseif _armor.HasKeyWordString("ClothingBeauty")
				_speechBonus = -5.0
			endif
		endif

		playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechBonus)
		playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + _speedBonus)

		pcVoiceMCM.updateActorArmorStatus(playerRef)

		if _playSound 
			SoundCoolTimePlay(_playSound, _express=_playExpress)
		endif
	endif	
EndEvent

; 옷투정은 실제 처음 필드에 참여시 부터 적용
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	Armor _armor = akBaseObject as armor

	if _armor		
		pcVoiceMCM.updateActorArmorStatus(playerRef)
		Sound _playSound = none
		String _playExpress = "happy"
		float  _speechBonus = 0.0
		float  _speedBonus = 0.0
		if _armor.IsHelmet()
			if _armor.HasKeyWordString("HairStyleLong")
				_speechBonus = 3.0
				_playSound = SayReactionLongHairSound			
			elseif _armor.HasKeyWordString("HairStyleShort")
				_speechBonus = 1.0
				_playSound = SayReactionShortHairSound
			elseif _armor.HasKeyWordString("HairStylePony")
				_speechBonus = 1.0
				_playSound = SayReactionPonyHairSound
			endif
			if pcVoiceMCM.enableDressMotion && !playerRef.IsInCombat() && !playerRef.isSwimming() && !playerRef.IsSprinting() && !playerRef.IsRunning()
				Debug.SendAnimationEvent(playerRef, "ImmCheckHair")
				Utility.Wait(3.0)
				Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")			
			endif
		elseif _armor.IsBoots()
			if _armor.HasKeyWordString("ArmorHeels")
				_speechBonus = 3.0
				; _speedBonus = 5.0
				_playSound = SayReactionHeelsSound
			else
				; _speedBonus = 15.0
			endif
			if  pcVoiceMCM.enableDressMotion && !playerRef.IsInCombat() && !playerRef.isSwimming() && !playerRef.IsSprinting() && !playerRef.IsRunning()
				Debug.SendAnimationEvent(playerRef, "ImmCheckBoots")
				Utility.Wait(1.5)
				Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")
			endif
		elseif _armor.IsClothingBody() || _armor.IsLightArmor() || _armor.IsHeavyArmor()
			if _armor == pcVoiceMCM.wornArmor
				if _armor.HasKeyWordString("ClothingSlutty") || _armor.HasKeyWordString("SOS_Revealing")
					_speechBonus = -3.0
					_playSound = SayReactionSluttyClothSound
					_playExpress = "angry"	
				elseif _armor.HasKeyWordString("ClothingSexy")
					_speechBonus = 3.0
					_playSound = SayReactionSexyClothSound
				elseif _armor.HasKeyWordString("ClothingBeauty")
					_speechBonus = 5.0
					_playSound = SayReactionBeautyClothSound
				elseif _armor.HasKeyWordString("ClothingPoor")
					_playSound = SayReactionPoorClothSound
				elseif _armor.HasKeyWordString("ClothingRich")
					_playSound = SayReactionFancyClothSound
				elseif _armor.HasKeyWordString("ClothingPanty")
					_playSound = SayReactionPantyClothSound
				else 
					_playSound = SayReactionNormalClothSound
				endif
				if pcVoiceMCM.enableDressMotion && !playerRef.IsInCombat() && !playerRef.isSwimming() && !playerRef.IsSprinting() && !playerRef.IsRunning()	
					Debug.SendAnimationEvent(playerRef,"ImmCheckClothes")
					Utility.Wait(4.0)
					Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")
				endif				
			else
				if _armor == pcVoiceMCM.wornPanty
					_playSound = SayReactionPantyClothSound
				endif
			endif
		endif

		playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechBonus)	
		playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + _speedBonus)

		if _playSound && (pcVoiceMCM.enterFirstTravel || pcVoiceMCM.isInventoryMenuMode)
			SoundCoolTimePlay(_playSound, _express=_playExpress)			
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
function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.5, float _delay = 1.0, String _express)
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

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
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

Sound property SayReactionHeelsSound Auto

Sound property SayReactionLongHairSound Auto	; HairStyleLong
Sound property SayReactionShortHairSound Auto	; HairStyleShort
Sound property SayReactionPonyHairSound Auto	; HairStylePony
Sound property SayReactionBangHairSound Auto	; HairStyleBang
Sound property SayReactionBoldHairSound Auto	; HairStyleBold