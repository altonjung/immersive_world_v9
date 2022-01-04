scriptname ImmersivePcVoiceMonologueActorAlias extends ReferenceAlias

bool   isGameRunning

int    newSkyType
int    oldSkyType
int    weatherType
int    lowStaminaSoundId
int    veryLowStaminaSoundId
int    underWaterSoundId

float  underWaterSoundVolume

bool   isExpression
string visitLocation
float  drunkenStartTime
float  soundCoolTime
float[] coolTimeMap

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
	isGameRunning = false
	SoundHelloPlay(SayHelloSound)
	Utility.wait(3.0)
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
	isExpression = false

	visitLocation = checkLocation(playerRef.GetCurrentLocation())		

	Armor _armor = playerRef.GetWornForm(0x00000004) as Armor
	if _armor == none
		PlayerNakeState.setValue(1)		
	endif	
endFunction

function init ()	
	newSkyType = Weather.GetSkyMode()
	oldSkyType = newSkyType
	underWaterSoundId = 0
	underWaterSoundVolume = 0.0
	soundCoolTime = 0.0	
	coolTimeMap = new float[10]		; 0: normal, 1: location, 2: monologue, 3: weather, 4: naked, 5: state
endFunction

function regAnimation ()
	; sprint
	RegisterForAnimationEvent(playerRef, "FootSprintRight") 		; end

	; swimming
	RegisterForAnimationEvent(playerRef, "SoundPlay.FSTSwimSwim")	; start
	RegisterForAnimationEvent(playerRef, "MTState") 				; end
endFunction


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "FootSprintRight"
		float _stamina = playerRef.GetActorValuePercentage("Stamina")
		if  0.15 < _stamina && _stamina < 0.35	
			if veryLowStaminaSoundId != 0
				Sound.StopInstance(veryLowStaminaSoundId)
				veryLowStaminaSoundId = 0
			endif
			lowStaminaSoundId = SoundCoolTimePlay(SayStateLowStaminaSound, 0.3, 0.1, 5.0)
		elseif  0.15 > _stamina		
			if lowStaminaSoundId != 0
				Sound.StopInstance(lowStaminaSoundId)
				lowStaminaSoundId = 0	
			endif		
			veryLowStaminaSoundId = SoundCoolTimePlay(SayStateVeryLowStaminaSound, 0.4, 0.1, 5.0)
		else 
			if lowStaminaSoundId != 0 || veryLowStaminaSoundId != 0
				Sound.StopInstance(lowStaminaSoundId)
				Sound.StopInstance(veryLowStaminaSoundId)
				lowStaminaSoundId = 0
				veryLowStaminaSoundId = 0
			endif
		endif	
	elseif asEventName == "SoundPlay.FSTSwimSwim"				
		underWaterSoundId = SoundCoolTimePlay(SayStateUnderWaterSound, underWaterSoundVolume, 0.2, 5.0)
		underWaterSoundVolume += 0.1
		if underWaterSoundVolume > 0.5
			underWaterSoundVolume = 0.5
		endif	
	elseif asEventName == "MTState"
		underWaterSoundVolume = 0.0
		Sound.StopInstance(underWaterSoundId)
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
	elseif menuName == "InventoryMenu"
		UnregisterForUpdate()		
	endif
endEvent

Event OnMenuClose(string menuName)		
	log("OnMenuClose")

	if menuName == "RaceSex Menu"			
		isGameRunning = true
	elseif menuName == "InventoryMenu"
		if PlayerNakeState.getValue() == 1
			SoundCoolTimePlay(SayStateNakedSound, 0.5, 0.2, 5.0, 2, 60.0)
		endif
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

	oldSkyType = newSkyType 
	newSkyType = Weather.GetSkyMode()	

	if newSkyType == 3
		int oldWeatherType = akOldWeather.GetClassification()	
		int newWeatherType = akNewWeather.GetClassification()	
		; -1 - No classification
		;  0 - Pleasant
		;  1 - Cloudy
		;  2 - Rainy
		;  3 - Snow
		weatherType = newWeatherType
		if newWeatherType == 0 
			if oldWeatherType == 2 || oldWeatherType == 3
				SoundCoolTimePlay(SayWeatherWarmSound, 0.5, 0.1, 3.0, 3, 30.0)
			elseif oldWeatherType == -1 || oldWeatherType == 1
				SoundCoolTimePlay(SayWeatherSunnySound, 0.5, 0.1, 3.0, 3, 30.0)
			endif
		elseif newWeatherType == 2
			SoundCoolTimePlay(SayWeatherRainySound, 0.5, 0.1, 3.0, 3, 30.0)
		elseif newWeatherType == 3
			SoundCoolTimePlay(SayWeatherSnowSound, 0.5, 0.1, 3.0, 3, 30.0)
		endif
	endif

	Log("OnWeatherChange ")
EndEvent

;
;	Drink
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	if akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
		SoundCoolTimePlay(SayDrinkAlcoholSound)				
		Log("Drink acholol")
		PlayerDrunkState.setValue(1 + PlayerDrunkState.getValue())

		if PlayerDrunkState.getValue() == 3			
			RegisterForSingleUpdate(8.0) ; 8초 뒤
		endif
		drunkenStartTime = Utility.GetCurrentGameTime() * 24.0
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
	
	visitLocation = ""	
	
	if isGameRunning
		if newSkyType == 3
			; 모노로그 출력
			if PlayerNakeState.getValue() == 1
				SoundCoolTimePlay(SayStateNakedSound, 0.5, 0.0, 5.0, 4, 60.0)
			elseif PlayerDrunkState.getValue() == 1				
				SoundCoolTimePlay(SayDrinkAlcoholToxicSound, 0.5, 0.0, 3.0, 7, 60.0)
				Game.ShakeCamera(afDuration = 1.0)
			elseif playerRef.GetActorValue("Health") <= 0.3		; low health
				SoundCoolTimePlay(SayStateLowHealthSound, 0.5, 0.0, 3.0, 5, 60.0)
			elseif playerRef.GetWornForm(0x00000080) == none && weatherType == 3	; no shoes in snow
				SoundCoolTimePlay(SayStateBareFeetSound, 0.5, 0.0, 3.0, 6, 60.0)
			else
				SoundCoolTimePlay(SayMonologueSound, 0.6, 0.0, 10.0, 2, 300.0 * Utility.RandomInt(1, 3)) ; 5분 ~ 15분
			endif
		else 
			visitLocation = checkLocation(playerRef.GetCurrentLocation())
			; 0 - No sky (SM_NONE)
			; 1 - Interior (SM_INTERIOR)
			; 2 - Skydome only (SM_SKYDOME_ONLY)
			; 3 - Full sky (SM_FULL)					
			Log("location " + visitLocation + ", skyMode " + newSkyType)

			if newSkyType < 3; interior
				if PlayerNakeState.getValue() == 1
					SoundCoolTimePlay(SayStateNakedSound, 0.4, 0.7, 5.0, 4, 60.0)
				elseif visitLocation == "home"
					log("home")
					SoundCoolTimePlay(SayLocationHomeSound, 0.4, 0.7, 5.0, 1, 30.0)
				elseif visitLocation == "house"
					log("house")
					SoundCoolTimePlay(SayLocationHouseSound, 0.4, 0.7, 5.0, 1, 30.0)
				elseif visitLocation == "inn"
					log("inn")
					if PlayerDrunkState.getValue() > 2
						SoundCoolTimePlay(SayLocationInnDrunkSound, 0.7, 0.7, 5.0, 1, 30.0)
					else 
						SoundCoolTimePlay(SayLocationInnSound, 0.4, 0.7, 5.0, 1, 30.0)
					endif
				elseif visitLocation == "store"
					log("store")
					if PlayerDrunkState.getValue() > 2
						SoundCoolTimePlay(SayLocationStoreDrunkSound, 0.7, 0.7, 5.0, 1, 30.0)
					else 
						SoundCoolTimePlay(SayLocationStoreSound, 0.4, 0.7, 5.0, 1, 30.0)
					endif
				elseif visitLocation == "temple"
					log("temple")
					SoundCoolTimePlay(SayLocationTempleSound, 0.4, 0.7, 5.0, 1, 30.0)
				elseif visitLocation == "barrack"
					log("barrack")
					SoundCoolTimePlay(SayLocationBarrackSound, 0.4, 0.7, 5.0, 1, 30.0)
				elseif visitLocation == "castle"
					log("castle")
					SoundCoolTimePlay(SayLocationCastleSound, 0.4, 0.7, 5.0, 1, 30.0)
				elseif visitLocation == "jail"
					log("jail")
					SoundCoolTimePlay(SayLocationJailSound, 0.4, 0.7, 5.0, 1, 30.0)
				elseif visitLocation == "dungeon"
					log("dungeon")
					if PlayerDrunkState.getValue() > 2
						SoundCoolTimePlay(SayLocationDungeonDrunkSound, 0.7, 0.7, 5.0, 1, 30.0)
					else  
						SoundCoolTimePlay(SayLocationDungeonSound, 0.4, 0.7, 5.0, 1, 30.0)
					endif
				endif
			endif
		endif
	endif	

	updateState()
EndEvent

Event OnCellLoad()
	Log("OnCellLoad")
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
					if _location.HasKeyWordString("TGWealthyHome")	; 잘 사는 집
					endif
				endif				
			endif		
		elseif _location.HasKeyWordString("LocTypeTown")
			_visitLocation = "town"			
		elseif _location.HasKeyWordString("LocTypeDungeon")
			_visitLocation = "dungeon"
		endif
	endif

	LogKeywords(_location.GetKeywords())

	return _visitLocation
endFunction 


;
;	Sleep
;
Event OnSleepStop(bool abInterrupted)
	updateState()
EndEvent

;
;	Unequip
;
; InventoryMenu가 아닌 npc나 console 을 통해, 임의적으로 clothes가 off된 경우 처리
Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	Armor _armor = akBaseObject as armor
	
	if _armor.IsClothingBody() || _armor.IsCuirass() || _armor.IsLightArmor() || _armor.IsHeavyArmor()					
		RegisterForSingleUpdate(0.5) ; 옷을 아예 안입는 경우 검출
	endif
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	Armor _armor = playerRef.GetWornForm(0x00000004) as Armor
	if _armor
		clearNaked()
	endif
EndEvent

Event OnUpdate()	
	; 술을 마신 상태 업데이트
	if PlayerDrunkState.getValue() > 0
		if PlayerDrunkState.getValue() == 3
			SoundPlay(SayDrinkAlcoholToxicSound)
			PlayerDrunkState.setValue(4)
		endif
	endif
	
	; 벗은 상태 업데이트
	if PlayerNakeState.getValue() == 0
		Armor _armor = playerRef.GetWornForm(0x00000004) as Armor
		if _armor == none			
			Game.SetPlayerReportCrime(false)	; naked 상태에선 crime 행위를 하더라도, 무시될 수 있음
			PlayerNakeState.setValue(1)
			expression("undress")
			SoundPlay(SayStateNakedShockSound)
			Utility.WaitMenuMode(2.0)
			expression("normal")
		endif
	endif	
endEvent

Event updateState()
	log("updateState")

	float currentHour = Utility.GetCurrentGameTime() * 24.0
	if currentHour >= drunkenStartTime + 3.0; 3 시간이 지나면 hang over
		PlayerDrunkState.setValue(0)
	endif
EndEvent


;	Utility
;
int function SoundCoolTimePlay(Sound _sound, float _volume = 0.6, float _sleep = 0.2,float _gCoolTime = 2.0, int _mapIdx = 0, float _mapCoolTime = 0.5)
	float currentTime = Utility.GetCurrentRealTime()
	int _soundId = 0	

	if isGameRunning && currentTime >= soundCoolTime && currentTime >= coolTimeMap[_mapIdx]		
		soundCoolTime = currentTime + _gCoolTime
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime
		
		utility.WaitMenuMode(_sleep)		
		_soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(_soundId, _volume)
	endif
	return _soundId
endFunction

int function SoundPlay(Sound _sound, float _volumn = 0.8, float _sleep = 0.2)
	int soundId = 0
	if isGameRunning
		utility.WaitMenuMode(_sleep)
		soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(soundId, _volumn)
	endif
	return soundId
endFunction

function SoundHelloPlay(Sound _sound, float _volumn = 0.8)
	Sound.SetInstanceVolume(_sound.Play(playerRef), _volumn)	
endFunction

function clearNaked()
	PlayerNakeState.setValue(0)	
	Game.SetPlayerReportCrime(true)
	coolTimeMap[4] = 0.0
	expression("normal")
endfunction

function expression(string _type)
	if _type == "undress"
		isExpression = true
		playerRef.SetExpressionOverride(4, 100)				; suprise
		MfgConsoleFunc.SetPhoneme(playerRef,13,45)			; mouth
		MfgConsoleFunc.SetModifier(playerRef, 0, 30)		; eye left
		MfgConsoleFunc.SetModifier(playerRef, 1, 45)		; eye right
		; playerRef.SetExpressionPhoneme(14, 20)  ; mouth		
	else
		isExpression = false
		playerRef.ResetExpressionOverrides()
		MfgConsoleFunc.ResetPhonemeModifier(playerRef) 		
	endif	
endfunction 

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

function LogKeywords(Keyword[] _keywords)
	int idx=0
	string _buf = ""
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
Sound property SayLocationInnDrunkSound Auto
Sound property SayLocationStoreSound Auto
Sound property SayLocationStoreDrunkSound Auto
Sound property SayLocationHomeSound Auto
Sound property SayLocationHouseSound Auto
Sound property SayLocationCastleSound Auto
Sound property SayLocationJailSound Auto
Sound property SayLocationTempleSound Auto
Sound property SayLocationBarrackSound Auto
Sound property SayLocationDungeonSound Auto
Sound property SayLocationDungeonDrunkSound Auto

; state
Sound property SayStateLowStaminaSound Auto			
Sound property SayStateVeryLowStaminaSound Auto			
Sound property SayStateUnderWaterSound Auto			
Sound property SayStateNakedShockSound Auto
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
Sound property SayDrinkAlcoholToxicSound Auto
