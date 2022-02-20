scriptname ImmersivePcVoiceStatusActorAlias extends ReferenceAlias

float  drunkenStartTime
float  rainStartTime
float  snowStartTime
float  wetStartTime
float  warmStartTime

int    drinkCount
bool   isClotheWet

float[] coolTimeMap

Event OnInit()
EndEvent

event OnLoad()
	setup()
	init()
	regAnimation()
endEvent

; save -> load 시 호출
Event OnPlayerLoadGame()		
	init()
EndEvent

function setup()
	pcVoiceMCM.soundCoolTime = 0.0
	pcVoiceMCM.isDrunken = false
	pcVoiceMCM.isLocationClearable = false
endFunction

function init ()	
	drunkenStartTime = 0.0	
	rainStartTime = 0.0
	snowStartTime = 0.0
	warmStartTime = 0.0
	wetStartTime = 0.0
	
	drinkCount = 0

	isClotheWet = false

	coolTimeMap = new float[6]

	UnregisterForUpdate()
	RegisterForSingleUpdate(80.0)
endFunction

function regAnimation ()
	RegisterForSleep()
	; swimming
	RegisterForAnimationEvent(playerRef, "SoundPlay.FSTSwimSwim")	; start
	; RegisterForAnimationEvent(playerRef, "MTState") 				; end
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	if asEventName == "SoundPlay.FSTSwimSwim"		
		warmStartTime = 0.0
		wetStartTime = Utility.GetCurrentGameTime() * 24.0
		isClotheWet = true		
		UnregisterForUpdate()
		RegisterForSingleUpdate(5.0)
	endif
endEvent

;
;	Drink
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)	
	if !pcVoiceMCM.isGameRunning
		return 
	endif
	
	actor akActor = akCaster as Actor 
	if akActor == playerRef
		if akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol		
			drinkCount += 1			
			drunkenStartTime = Utility.GetCurrentGameTime() * 24.0				
		endif
	endif
EndEvent

;
;	Sleep
;
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	if !pcVoiceMCM.isInField
		pcVoiceMCM.isDrunken = false 
		drinkCount = 0
		drunkenStartTime = 0.0	
		rainStartTime = 0.0
		snowStartTime = 0.0
		warmStartTime = 0.0
		wetStartTime = 0.0		
		isClotheWet = false
		playerRef.removeItem(WetClothes, playerRef.GetItemCount(WetClothes))
	endif
EndEvent

Event OnUpdate()
	if !pcVoiceMCM.isGameRunning
		RegisterForSingleUpdate(80.0)
		return
	endif
	
	; 지역/날씨 업데이트
	pcVoiceMCM.updateField(playerRef)
	pcVoiceMCM.updateWeather(playerRef)
	pcVoiceMCM.updateLocation(playerRef)

	; 옷상태 업데이트
	pcVoiceMCM.updateActorArmorStatus(playerRef)

	; 술취한상태 업데이트
	if drinkCount > 0
		if currentHour >= drunkenStartTime + 3.0; 3 시간이 지나면 hang over
			drinkCount = 0
			pcVoiceMCM.isDrunken = false
		else			
			if drinkCount >= 3
				pcVoiceMCM.isDrunken = true
			endif
		endif
	endif

	; 젖은/마른 상태 업데이트
	float currentHour = Utility.GetCurrentGameTime() * 24.0
	if Weather.GetCurrentWeather().GetClassification() == 2	; rain
		warmStartTime = 0.0
		if rainStartTime == 0.0
			rainStartTime = Utility.GetCurrentGameTime() * 24.0			
		endif
		if wetStartTime == 0.0
			wetStartTime = Utility.GetCurrentGameTime() * 24.0			
		endif

		if pcVoiceMCM.isInField && currentHour >= rainStartTime + 0.5
			isClotheWet = true
		endif

	elseif Weather.GetCurrentWeather().GetClassification() == 3	; snow
		warmStartTime = 0.0
		if snowStartTime == 0.0
			snowStartTime = Utility.GetCurrentGameTime() * 24.0			
		endif	
	else
		if warmStartTime == 0.0
			warmStartTime =  Utility.GetCurrentGameTime() * 24.0
		endif
		snowStartTime = 0.0
		rainStartTime = 0.0
	endif
	
	if !pcVoiceMCM.isInField
		if warmStartTime == 0.0
			warmStartTime =  Utility.GetCurrentGameTime() * 24.0
		endif
	endif

	if pcVoiceMCM.isGameRunning && pcVoiceMCM.enterFirstTravel
		; 젖은/마른 옷상태에 따른 음성 출력
		if isClotheWet
			if pcVoiceMCM.wornArmor && playerRef.GetItemCount(WetClothes) == 0
				WetClothes.SetWeight(pcVoiceMCM.wornArmor.GetWeight() * 1.5)
				playerRef.additem(WetClothes, 1)
				SoundCoolTimePlay(SayEffectWetClothSound, _coolTime=3.0)	
				Debug.Notification("wet blanket")
			endif

			if warmStartTime > 0.0
				if currentHour >= warmStartTime + 0.5; 30분이 지나면 dry 상태
					isClotheWet = false
					wetStartTime = 0.0
					playerRef.removeItem(WetClothes, playerRef.GetItemCount(WetClothes))
					SoundCoolTimePlay(SayEffectDryClothSound, _coolTime=3.0)
					Debug.Notification("dried blanket out")
				endif
			endif
		endif

		if pcVoiceMCM.isInField && !playerRef.IsInCombat()
			float _currentTime = Utility.GetCurrentRealTime()
			bool isSprint = playerRef.IsSprinting()
			bool isRun = playerRef.IsRunning()
			if !isSprint && !isRun
				; player 상태에 따른 음성 출력
				if playerRef.GetActorValuePercentage("Health") <= 0.3 && _currentTime >= coolTimeMap[3]
					Debug.Notification("you low health")
					SoundCoolTimePlay(SayStateLowHealthSound, _coolTime=5.0, _mapIdx=3, _mapCoolTime=180.0 * Utility.RandomInt(1, 2))
				elseif pcVoiceMCM.isDrunken && _currentTime >= coolTimeMap[1]
					Debug.Notification("you drunken")
					Game.ShakeCamera(afDuration = 2.0)
					SoundCoolTimePlay(SayStateDrunkenSound, _coolTime=5.0, _mapIdx=1, _mapCoolTime=450.0 * Utility.RandomInt(1, 2))
				elseif pcVoiceMCM.isNaked && _currentTime >= coolTimeMap[2]
					Debug.Notification("you naked")
					Game.ShakeCamera(afDuration = 0.5)
					SoundCoolTimePlay(SayStateNakedSound, _coolTime=5.0, _mapIdx=2, _mapCoolTime=300.0 * Utility.RandomInt(1, 2))
				else 
					if pcVoiceMCM.isBareFoot && _currentTime >= coolTimeMap[4]
						SoundCoolTimePlay(SayStateBareFeetSound, _coolTime=5.0, _mapIdx=4, _mapCoolTime=180.0 * Utility.RandomInt(1, 2))			
					elseif pcVoiceMCM.weatherType == 2 && currentHour > rainStartTime + 0.5 && _currentTime > coolTimeMap[5]
						SoundCoolTimePlay(SayWeatherRainySound, _coolTime=5.0, _mapIdx=5, _mapCoolTime=300.0)
					elseif pcVoiceMCM.weatherType == 3  && currentHour > snowStartTime + 0.5 && _currentTime > coolTimeMap[5]
						SoundCoolTimePlay(SayWeatherSnowSound, _coolTime=5.0, _mapIdx=5, _mapCoolTime=300.0)
					else 
						if pcVoiceMCM.isInTown && !pcVoiceMCM.isNaked
							SoundCoolTimePlay(SayStateComfortClothesSound, _coolTime=7.0, _mapIdx=0, _mapCoolTime=500.0 * Utility.RandomInt(1, 2))
						endif						
					endif
				endif
			else
				; ; slipping
				; bool _shouldStagger = false
				; int _randomMax = 5
				; if pcVoiceMCM.wornBoots == none
				; 	_shouldStagger = true
				; 	if pcVoiceMCM.weatherType == 2
				; 		_randomMax = 2
				; 	elseif pcVoiceMCM.weatherType == 3
				; 		_randomMax = 1
				; 	endif
				; else
				; 	if pcVoiceMCM.wornBoots.HasKeyWordString("ArmorHeels")
				; 		_shouldStagger = true
				; 		if pcVoiceMCM.weatherType == 2
				; 			_randomMax = 2
				; 		elseif pcVoiceMCM.weatherType == 3
				; 			_randomMax = 1
				; 		endif 				
				; 	endif
				; endif

				; if _shouldStagger
				; 	Debug.Notification("you slipped down")
				; 	bool _shouldRoll = false
				; 	if isSprint
				; 		if Utility.randomInt(0,1) == 0
				; 			_shouldRoll = true
				; 			Debug.SendAnimationEvent(playerRef, "Immstaggerforwardlargest")							
				; 		else 
				; 			Debug.SendAnimationEvent(playerRef, "Immstaggerforwardlarge")
				; 		endif
				; 	else 
				; 		if Utility.randomInt(0,1) == 0
				; 			Debug.SendAnimationEvent(playerRef, "Immstaggerforwardmedium")
				; 		else 
				; 			Debug.SendAnimationEvent(playerRef, "Immstaggerforwardsmall")
				; 		endif
				; 	endif
				; 	SoundPlay(SayActionSlippingSound, _volume=0.6)					
				; 	if _shouldRoll
				; 		Utility.Wait(1.7)
				; 		Debug.SendAnimationEvent(playerRef, "Immforwardroll")
				; 		Utility.Wait(0.5)
				; 	else 
				; 		Utility.Wait(2.0)
				; 	endif
				; 	Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")					
				; endif
			endif
		endif
		; pcVoiceMCM.log("weather " + pcVoiceMCM.weatherType + ", wet " + isClotheWet + ", inTown " + pcVoiceMCM.isInTown + ", curHour " + currentHour)
	endif
	RegisterForSingleUpdate(80.0)
endEvent

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, int _mapIdx = 0, float _mapCoolTime = 1.0, string _express = "happy")
	if pcVoiceMCM.enableStatusSound == false || PlayerRef.isSwimming() || PlayerRef.IsInCombat() || pcVoiceMCM.isSit
		return
	endif

	while Utility.IsInMenuMode()
		Utility.WaitMenuMode(0.1)
	endWhile	

	float currentTime = Utility.GetCurrentRealTime()
	if currentTime >= pcVoiceMCM.soundCoolTime && currentTime >= coolTimeMap[_mapIdx]		
		pcVoiceMCM.soundCoolTime = currentTime + _coolTime
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime

		Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
		pcVoiceMCM.expression(playerRef, _express)
	endif
endFunction

function SoundPlay(Sound _sound, float _volume = 0.8)	
	if pcVoiceMCM.enableStatusSound == false || playerRef.IsSwimming() || PlayerRef.IsInCombat()
		return
	endif 
	
	Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
endFunction


ImmersivePcVoiceMCM property pcVoiceMCM Auto

Actor property playerRef Auto

; action
Sound property SayActionSlippingSound Auto

; state	
Sound property SayStateDrunkenSound Auto
Sound property SayStateNakedSound Auto
Sound property SayStateComfortClothesSound Auto
Sound property SayStateLowHealthSound Auto
Sound property SayStateBareFeetSound Auto

Sound property SayEffectWetClothSound Auto	;
Sound property SayEffectDryClothSound Auto	; 

Sound property SayWeatherRainySound Auto
Sound property SayWeatherSnowSound Auto

Armor property WetClothes Auto