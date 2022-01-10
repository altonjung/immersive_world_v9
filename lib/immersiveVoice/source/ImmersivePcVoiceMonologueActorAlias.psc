scriptname ImmersivePcVoiceMonologueActorAlias extends ReferenceAlias

bool   isGameRunning

int    underWaterSoundId
float  underWaterSoundVolume

float  sneakingBgSoundVolume
int    SneakBgSoundId

bool   isLoadLocationChanged
string visitLocation
float  soundCoolTime
float[] coolTimeMap

Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume

Location prevVisitLocation
Event OnInit()
	initMenu()	
EndEvent

event OnLoad()
	registerAction()	
	setup()
	init()
endEvent

function initMenu()	
	UnregisterForAllMenus()
	RegisterForMenu("RaceSex Menu")
	RegisterForMenu("InventoryMenu")
endFunction

; save -> load 시 호출
Event OnPlayerLoadGame()	
	log("OnPlayerLoadGame!!")
	isGameRunning = false
	SoundHelloPlay(SayHelloSound)
	expression("happy")	
	utility.WaitMenuMode(3.0)
	isGameRunning = true
	init()
EndEvent

function registerAction ()	
	RegisterForSleep()	
	regAnimation()
endFunction

function setup()
	isGameRunning = false
		
	visitLocation = ""	
	visitLocation = checkLocation(playerRef.GetCurrentLocation())
endFunction

function init ()	
	prevVisitLocation = None
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	isLoadLocationChanged = false

	underWaterSoundId = 0
	underWaterSoundVolume = 0.0

	SneakBgSoundId = 0
	sneakingBgSoundVolume = 0.0

	soundCoolTime = 0.0	
	coolTimeMap = new float[20]
	;	0: normal, 1: drunk, 2: dialog(normal), 3: dialog(child), 4: dialog(enemy), 5: dialog(lover), 6: dialog(friend), 7: dialog(soldier) 8: dialogu(ghost), 9: dialogu(noble), 10: dialogu(ugly), 13: swimming
endFunction

function regAnimation ()
	; sneak
	RegisterForAnimationEvent(playerRef, "tailSneakIdle") 			; start in standing
	RegisterForAnimationEvent(playerRef, "tailMTIdle") 				; end in sprint or sneak
	RegisterForAnimationEvent(playerRef, "tailCombatIdle") 			; end
	RegisterForAnimationEvent(playerRef, "tailCombatLocomotion") 	; end

	; swimming
	RegisterForAnimationEvent(playerRef, "SoundPlay.FSTSwimSwim")	; start
	RegisterForAnimationEvent(playerRef, "MTState") 				; end
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "tailSneakIdle"
		; 만약 손에 활을 들고 있다면, sneak BG 출력 무시
		if  playerRef.GetEquippedItemType(0) != 7 && playerRef.GetEquippedItemType(1) != 7 	;bow			

			if SneakBgSoundId == 0
				SneakBgSoundId = SoundBGPlay(SayBgSneakModeSound, sneakingBgSoundVolume)			
			else 
				sneakingBgSoundVolume += 0.1
				SoundVolumeUp(SneakBgSoundId, sneakingBgSoundVolume)

				if sneakingBgSoundVolume == 0.1					
					SoundBGPlay(SayStateSneakSound, _volume=0.4)					
				endif

				log("sneak play with volume " + sneakingBgSoundVolume)
			endif
		endif
	elseif asEventName == "tailMTIdle"
		; sneak -> stand idle
		if SneakBgSoundId != 0
			Sound.StopInstance(SneakBgSoundId)			
			SneakBgSoundId = 0
			sneakingBgSoundVolume = 0.0
		endif		
	elseif asEventName == "SoundPlay.FSTSwimSwim"	
		underWaterSoundId = SoundSwimmingPlay(SayStateUnderWaterSound, underWaterSoundVolume)
		
		underWaterSoundVolume += 0.1
		if underWaterSoundVolume > 0.5
			underWaterSoundVolume = 0.5
		endif
	elseif asEventName == "MTState"
		underWaterSoundVolume = 0.0
		Sound.StopInstance(underWaterSoundId)
		underWaterSoundId = 0
	endif
	
	; Log("OnAnimationEvent " + asEventName)
endEvent

;
;	Menu
;
Event OnMenuOpen(string menuName)
	log("OnMenuOpen")
	if menuName == "RaceSex Menu"			
		isGameRunning = false
		SoundHelloPlay(SayHelloSound)	
		expression("happy")
	elseif menuName == "InventoryMenu"
		UnregisterForUpdate()
	endif
endEvent

Event OnMenuClose(string menuName)		
	log("OnMenuClose")

	if menuName == "RaceSex Menu"			
		isGameRunning = true
	endif	
endEvent

;
;	Weather
;
Event OnWeatherChange(Weather akOldWeather, Weather akNewWeather)
	log("OnWeatherChange ")
	if playerRef.IsInCombat()
		return
	endif
	
	int _skyType = Weather.GetSkyMode()	

	if _skyType == 3
		int oldWeatherType = akOldWeather.GetClassification()	
		int newWeatherType = akNewWeather.GetClassification()	
		; -1 - No classification
		;  0 - Pleasant
		;  1 - Cloudy
		;  2 - Rainy
		;  3 - Snow
		if newWeatherType == 0				
			if oldWeatherType == 3
				SoundCoolTimePlay(SayWeatherWarmSound, _delay=3.0, _coolTime=2.0, _mapIdx=2, _mapCoolTime=30.0)
			else
				SoundCoolTimePlay(SayWeatherSunnySound, _delay=3.0, _coolTime=2.0, _mapIdx=2, _mapCoolTime=30.0)
			endif
		elseif newWeatherType == 2
			SoundCoolTimePlay(SayWeatherRainySound, _delay=3.0, _coolTime=2.0, _mapIdx=2, _mapCoolTime=30.0)
		elseif newWeatherType == 3
			SoundCoolTimePlay(SayWeatherSnowSound, _delay=3.0, _coolTime=2.0, _mapIdx=2, _mapCoolTime=30.0)
		endif
	endif
EndEvent

;
;	Drink
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	log("OnMagicEffectApply")
	if akEffect.HasKeyWordString("MagicAlchBeneficial")	&& (akEffect.HasKeyWordString("MagicAlchRestoreHealth") || akEffect.HasKeyWordString("MagicAlchRestoreMagicka") || akEffect.HasKeyWordString("MagicAlchRestoreStamina"))
		SoundCoolTimePlay(SayDrinkPotionSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=3.0)
		; Log("Drink H/M/S potion")
	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure
		SoundCoolTimePlay(SayDrinkPotionSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=3.0)
		; Log("Drink cure potion")	
	elseif akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
		SoundCoolTimePlay(SayDrinkAlcoholSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=3.0)		
	endif
EndEvent

;
;	Location
;
Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	
	bool isCombat = playerRef.IsInCombat()
	log("OnLocationChange " + isCombat)

	if isCombat
		return
	endif 

	prevVisitLocation = akOldLoc
	isLoadLocationChanged = true

	visitLocation = ""
	int _skyMode = Weather.GetSkyMode()
	int _weatherType = Weather.GetCurrentWeather().GetClassification()

	if isGameRunning
		if 30.0 <= playerRef.GetActorValue("Stamina") 
			if PlayerNakeState.getValue() == 1
				SoundCoolTimePlay(SayStateNakedSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=60.0)
			elseif PlayerDrunkState.getValue() == 1
				Game.ShakeCamera(afDuration = 1.0)
				SoundCoolTimePlay(SayDrinkAlcoholToxicSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=60.0)
			elseif playerRef.GetActorValue("Health") <= 0.3		; low health
				SoundCoolTimePlay(SayStateLowHealthSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=60.0)
			elseif !playerRef.GetWornForm(0x00000080) 			; no shoes
				SoundCoolTimePlay(SayStateBareFeetSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=60.0)		
			elseif _skyMode == 3				
				if _weatherType == 2
					SoundCoolTimePlay(SayWeatherRainySound, _delay=1.0, _coolTime=2.0, _mapIdx=2, _mapCoolTime=60.0)
				elseif _weatherType == 3
					SoundCoolTimePlay(SayWeatherSnowSound,  _delay=1.0, _coolTime=2.0, _mapIdx=2, _mapCoolTime=60.0)
				else
					; 모노로그 출력
					SoundCoolTimePlay(SayMonologueSound, _delay=1.0, _coolTime=2.0, _mapIdx=2,  _mapCoolTime=300.0 * Utility.RandomInt(1, 3)) ; 5분 ~ 15분
				endif			
			else 
				playLocationSound(_skyMode)
			endif
		endif
	endif	 

	isLoadLocationChanged = false
EndEvent

Event OnCellLoad()
	Log("OnCellLoad")	

	bool _skip = false
	while isLoadLocationChanged == true
		utility.WaitMenuMode(0.1)
		_skip = true
	endWhile

	if !_skip
		playLocationSound(Weather.GetSkyMode())
	endif
EndEvent

String function checkLocation(Location _location)
	log("checkLocation ")	
	String _visitLocation = ""
	if _location		
		if _location.HasKeyWordString("LocTypeDwelling")
			if _location.HasKeyWordString("LocTypeInn")	
				_visitLocation = "inn"	
			elseif _location.HasKeyWordString("LocTypeStore")
				_visitLocation = "store"				
			elseif _location.HasKeyWordString("LocTypeTemple") || _location.HasKeyWordString("LocTypeCemetery")
				_visitLocation = "temple"
			elseif _location.HasKeyWordString("LocTypeCastle") 
				_visitLocation = "castle"
			elseif _location.HasKeyWordString("LocTypeJail") 
				_visitLocation = "jail"
			elseif _location.HasKeyWordString("LocTypeBarracks") 
				_visitLocation = "barrack"
			elseif _location.HasKeyWordString("LocTypeGuild") 
				_visitLocation = "guild"
			elseif _location.HasKeyWordString("LocTypeHouse")					
				if _location.HasKeyWordString("LocTypePlayerHouse")
					; player house		
					_visitLocation = "home"
				else 
					; other house				
					_visitLocation = "house"
				endif				
			endif
		elseif _location.HasKeyWordString("LocTypeTown")
			_visitLocation = "town"										
		elseif _location.HasKeyWordString("LocTypeFalmerHive")
			_visitLocation = "falmerHive"
		elseif _location.HasKeyWordString("LocTypeBanditCamp")
			_visitLocation = "banditCamp"
		elseif _location.HasKeyWordString("LocTypeAnimalDen")
			_visitLocation = "animalDen"
		elseif _location.HasKeyWordString("LocTypeForswornCamp")
			_visitLocation = "forswornCamp"
		elseif _location.HasKeyWordString("LocTypeDraugrCrypt")
			_visitLocation = "draugrCrypt"			
		elseif _location.HasKeyWordString("LocTypeOrcStronghold")
			_visitLocation = "orcHold"
		elseif _location.HasKeyWordString("LocTypeHagravenNest")
			_visitLocation = "hagravenNest"
		elseif _location.HasKeyWordString("LocTypeVampireLair")
			_visitLocation = "vampireLair"	
		elseif _location.HasKeyWordString("LocTypeWarlockLair")
			_visitLocation = "warlockLair"	
		elseif _location.HasKeyWordString("LocTypeDungeon")
			_visitLocation = "dungeon"			
		else 				
			_visitLocation = "unknown"	
		endif
	endif

	LogKeywords(_location.GetKeywords())

	return _visitLocation
endFunction 

;
;	equip
;
; InventoryMenu가 아닌 npc나 console 을 통해, 임의적으로 clothes가 off된 경우 처리
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	Armor _armor = akBaseObject as armor
	
	Armor _wornArmor = playerRef.GetWornForm(0x00000004) as Armor		; armor
	Armor _wornPanty = playerRef.GetWornForm(0x00400000) as Armor		; panty
	Armor _wornShoes = playerRef.GetWornForm(0x00000080) as Armor		; shoes
	Armor _wornShortHair = playerRef.GetWornForm(0x00000002) as Armor	; hair short
	Armor _wornLongHair = playerRef.GetWornForm(0x00000800) as Armor	; hair long

	if _armor == _wornArmor || _armor == _wornPanty
		clearNaked()
		if _wornPanty
			SoundCoolTimePlay(SayReactionPantyClothSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
			expression("happy")
		else 
			if _armor.HasKeyWordString("ClothingSlutty")
				SoundCoolTimePlay(SayReactionSluttyClothSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("angry")
			elseif _armor.HasKeyWordString("ClothingSexy")
				SoundCoolTimePlay(SayReactionSexyClothSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			elseif _armor.HasKeyWordString("ClothingPoor")
				SoundCoolTimePlay(SayReactionPoorClothSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("angry")
			elseif _armor.HasKeyWordString("ClothingRich")
				SoundCoolTimePlay(SayReactionFancyClothSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			elseif _armor.HasKeyWordString("ClothingPanty")
				SoundCoolTimePlay(SayReactionPantyClothSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			endif
		endif		
	elseif _armor == _wornShoes
		if _armor.HasKeyWordString("ArmorHeels")
			SoundCoolTimePlay(SayReactionHeelsSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
			expression("happy")
		endif
	elseif _armor == _wornShortHair || _armor == _wornLongHair
		if _armor.HasKeyWordString("HairStyleBold")
			SoundCoolTimePlay(SayReactionBoldHairSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
			expression("angry")
		elseif _armor.HasKeyWordString("HairStyleLong")
			SoundCoolTimePlay(SayReactionLongHairSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
			expression("happy")
		elseif _armor.HasKeyWordString("HairStyleShort")
			SoundCoolTimePlay(SayReactionShortHairSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
			expression("happy")
		elseif _armor.HasKeyWordString("HairStyleBang")
			SoundCoolTimePlay(SayReactionBangHairSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
			expression("happy")
		elseif _armor.HasKeyWordString("HairStylePony")
			SoundCoolTimePlay(SayReactionPonyHairSound, _delay=1.0, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
			expression("happy")
		endif
	endif
EndEvent

;
;	Trade
;
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)	
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
EndEvent

Event OnUpdate()
	; sound play
	if runningCoolTimeSoundRes != None		
		Sound.SetInstanceVolume(runningCoolTimeSoundRes.Play(playerRef), runningCoolTimeSoundVolume)
		runningCoolTimeSoundRes = none 
		runningCoolTimeSoundVolume = 0.0
	endif
endEvent
;
;	Utility
;
function playLocationSound(int skyMode)
	Location currentLocation = playerRef.GetCurrentLocation()
	visitLocation = checkLocation(currentLocation)
	; 0 - No sky (SM_NONE)
	; 1 - Interior (SM_INTERIOR)
	; 2 - Skydome only (SM_SKYDOME_ONLY)
	; 3 - Full sky (SM_FULL)					
	Log("location " + visitLocation + ", skyMode " + skyMode)

	if skyMode <= 2; interior
		if currentLocation.HasKeyWordString("LocTypeClearable")
			if visitLocation == "falmerHive"
				log("falmerHive location(c)")
				SoundCoolTimePlay(SayLocationFalmerHiveSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "animalDen"
				log("animalDen location(c)")
				SoundCoolTimePlay(SayLocationAnimalDenSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "forswornCamp"
				log("forswornCamp location(c)")
				SoundCoolTimePlay(SayLocationBanditCampSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "dungeon"
				log("dungeon location(c)")
				SoundCoolTimePlay(SayLocationDungeonSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "banditCamp"
				log("banditCamp location(c)")
				SoundCoolTimePlay(SayLocationBanditCampSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "draugrCrypt"
				log("draugrCrypt location(c)")
				SoundCoolTimePlay(SayLocationDraugrCryptSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "vampireLair"
				log("vampireLair location(c)")
				SoundCoolTimePlay(SayLocationVampireLairSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			else 
				SoundCoolTimePlay(SayLocationDungeonSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
				log("unknown location(c)")
			endif
		else 
			if visitLocation == "home"
				log("home location")
				SoundCoolTimePlay(SayLocationHomeSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "house"
				log("house location")
				SoundCoolTimePlay(SayLocationHouseSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "inn"
				log("inn location")
				SoundCoolTimePlay(SayLocationInnSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "store"
				log("store location")
				SoundCoolTimePlay(SayLocationStoreSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "temple"
				log("temple location")
				SoundCoolTimePlay(SayLocationTempleSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "barrack"
				log("barrack location")
				SoundCoolTimePlay(SayLocationBarrackSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "castle"
				log("castle location")
				SoundCoolTimePlay(SayLocationCastleSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "jail"
				log("jail location")
				SoundCoolTimePlay(SayLocationJailSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)		
			elseif visitLocation == "orcHold"
				log("orcHold location")
				SoundCoolTimePlay(SayLocationOrcHoldSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			else 						
				log("unknown location")
				SoundCoolTimePlay(SayLocationUnknownSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			endif
		endif
	else 
		if prevVisitLocation.HasKeyWordString("LocTypeDungeon")		; dungeon 탈출
			SoundCoolTimePlay(SayLocationEscapeDungeonSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)			
		endif
	endif
endFunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.5, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
	float currentTime = Utility.GetCurrentRealTime()
	if !playerRef.IsSwimming() && isGameRunning && currentTime >= soundCoolTime && currentTime >= coolTimeMap[_mapIdx]	 
		soundCoolTime = currentTime + _coolTime
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime
		if _delay != 0			
			UnregisterForUpdate()
			runningCoolTimeSoundRes = _sound
			runningCoolTimeSoundVolume = _volume			
			RegisterForSingleUpdate(_delay)
		else 
			runningCoolTimeSoundRes = none
			runningCoolTimeSoundVolume = 0.0
			int _soundId = _sound.Play(playerRef)
			Sound.SetInstanceVolume(_soundId, _volume)
		endif
	endif
endFunction

int function SoundSwimmingPlay(Sound _sound, float _volumn = 0.6, int _mapIdx = 15, float _mapCoolTime = 3.0)
	float currentTime = Utility.GetCurrentRealTime()
	int soundId = 0
	if isGameRunning && currentTime >= coolTimeMap[_mapIdx]
		soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(soundId, _volumn)
	endif
	return soundId
endFunction

function SoundHelloPlay(Sound _sound, float _volumn = 0.8)
	if !playerRef.IsSwimming()
		Sound.SetInstanceVolume(_sound.Play(playerRef), _volumn)	
	endif
endFunction

int function SoundBGPlay(Sound _sound, float _volume = 0.8)
	int soundId = 0
	
	if !playerRef.IsSwimming()
		soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(soundId, _volume)
	endif
	return soundId
endFunction

function SoundVolumeUp(int _soundId, float _volume = 0.1)	
	if _volume > 0.5 
		_volume = 0.5
	endif
	Sound.SetInstanceVolume(_soundId, _volume)
endFunction

function clearNaked()
	PlayerNakeState.setValue(0)	
	Game.SetPlayerReportCrime(true)
	coolTimeMap[4] = 0.0
	expression("normal")
endfunction

function expression(string _type)
	if _type == "disgust"
		playerRef.SetExpressionOverride(6, 100)				; disgust
		MfgConsoleFunc.SetPhoneme(playerRef,13,30)			; mouth
		MfgConsoleFunc.SetModifier(playerRef, 0, 10)		; eye left
		MfgConsoleFunc.SetModifier(playerRef, 1, 25)		; eye right
		; playerRef.SetExpressionPhoneme(14, 20)  ; mouth	
	elseif 	_type == "angry"
		playerRef.SetExpressionOverride(0, 100)				; angry
		MfgConsoleFunc.SetPhoneme(playerRef,13,20)			; mouth
		MfgConsoleFunc.SetModifier(playerRef, 0, 10)		; eye left
		MfgConsoleFunc.SetModifier(playerRef, 1, 25)		; eye right
		; playerRef.SetExpressionPhoneme(14, 20)  ; mouth		
	elseif 	_type == "happy"
		playerRef.SetExpressionOverride(2, 100)				; happy
		MfgConsoleFunc.SetPhoneme(playerRef,13,10)			; mouth
		; playerRef.SetExpressionPhoneme(14, 20)  ; mouth		
	else		
		playerRef.ResetExpressionOverrides()
		MfgConsoleFunc.ResetPhonemeModifier(playerRef) 		
	endif	
endfunction 

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

function LogKeywords(Keyword[] _keywords)	
	string _buf = ""
	int idx=0
	while idx < _keywords.length
		_buf = _buf + "," + _keywords[idx].GetString()
		idx += 1
	endWhile
	log("keywords " + _buf)
endFunction

GlobalVariable property PlayerNakeState Auto
GlobalVariable property PlayerDrunkState Auto

Actor property playerRef Auto

; hello
Sound property SayHelloSound Auto

; monologue
Sound property SayMonologueSound Auto			

; location
Sound property SayLocationInnSound Auto
Sound property SayLocationStoreSound Auto
Sound property SayLocationHomeSound Auto
Sound property SayLocationHouseSound Auto
Sound property SayLocationCastleSound Auto
Sound property SayLocationJailSound Auto
Sound property SayLocationTempleSound Auto
Sound property SayLocationBarrackSound Auto
Sound property SayLocationOrcHoldSound Auto

Sound property SayLocationDungeonSound Auto
Sound property SayLocationFalmerHiveSound Auto
Sound property SayLocationBanditCampSound Auto
Sound property SayLocationAnimalDenSound Auto
Sound property SayLocationDraugrCryptSound Auto
Sound property SayLocationVampireLairSound Auto
Sound property SayLocationEscapeDungeonSound Auto
Sound property SayLocationUnknownSound Auto

; state	
Sound property SayStateUnderWaterSound Auto	
Sound property SayStateSneakSound Auto
Sound property SayStateNakedSound Auto
Sound property SayStateBareFeetSound Auto
Sound property SayStateLowHealthSound Auto

; weather
Sound property SayWeatherSunnySound Auto
Sound property SayWeatherWarmSound Auto
Sound property SayWeatherRainySound Auto
Sound property SayWeatherSnowSound Auto

; drink
Sound property SayDrinkAlcoholSound Auto
Sound property SayDrinkPotionSound Auto
Sound property SayDrinkAlcoholToxicSound Auto

; etc
Sound property SayReactionSluttyClothSound Auto
Sound property SayReactionSexyClothSound Auto
Sound property SayReactionPantyClothSound Auto
Sound property SayReactionPoorClothSound Auto
Sound property SayReactionFancyClothSound Auto

Sound property SayReactionLongHairSound Auto	; HairStyleLong
Sound property SayReactionShortHairSound Auto	; HairStyleShort
Sound property SayReactionPonyHairSound Auto	; HairStylePony
Sound property SayReactionBangHairSound Auto	; HairStyleBang
Sound property SayReactionBoldHairSound Auto	; HairStyleBold

Sound property SayReactionHeelsSound Auto


; sneak background
Sound property SayBgSneakModeSound Auto
