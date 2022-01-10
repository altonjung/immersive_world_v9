scriptname ImmersivePcVoiceStatusActorAlias extends ReferenceAlias

float  drunkenStartTime
float  wetBodyStartTime
float  nakedStartTime

bool   isWet
bool   isInDrunken
bool   isNaked

float  soundCoolTime
float[] coolTimeMap

int    undressCount

Event OnInit()

EndEvent

event OnLoad()
	init()
	regAnimation()
endEvent

; save -> load 시 호출
Event OnPlayerLoadGame()		
	init()
EndEvent

function init ()	
	drunkenStartTime = 0.0	
	wetBodyStartTime = 0.0
	nakedStartTime = 0.0

	undressCount = 0

	isInDrunken = false
	
	isWet = false 

	Armor _armor = playerRef.GetWornForm(0x00000004) as Armor
	if _armor == none
		PlayerNakeState.setValue(1)	
		isNaked = true
	else 
		isNaked = false
	endif

	soundCoolTime = 0.0	
	coolTimeMap = new float[1]

	UnregisterForUpdate()
	RegisterForSingleUpdate(60.0)
endFunction

function regAnimation ()
	; swimming
	RegisterForAnimationEvent(playerRef, "SoundPlay.FSTSwimSwim")	; start
	RegisterForAnimationEvent(playerRef, "MTState") 				; end
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "SoundPlay.FSTSwimSwim"
		isWet = true
		wetBodyStartTime = Utility.GetCurrentGameTime() * 24.0	
	elseif asEventName == "MTState"
		RegisterForSingleUpdate(2.0)			
	endif
endEvent

;
;	Cloth status
;
Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	Armor _armor = akBaseObject as armor
	
	if _armor.IsClothing() || _armor.IsLightArmor() || _armor.IsHeavyArmor() || _armor.IsCuirass() || _armor.IsClothingBody()		
		UnregisterForUpdate()
		RegisterForSingleUpdate(2.0)
	endif
EndEvent

;
;	Drink
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	log("OnMagicEffectApply")

	if akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
		Log("Drink acholol")
		PlayerDrunkState.setValue(1 + PlayerDrunkState.getValue())
		drunkenStartTime = Utility.GetCurrentGameTime() * 24.0		
		isInDrunken = true
	endif
EndEvent

Event OnUpdate()	
	if isInDrunken
		float currentHour = Utility.GetCurrentGameTime() * 24.0
		if currentHour >= drunkenStartTime + 3.0; 3 시간이 지나면 hang over
			PlayerDrunkState.setValue(0)
			isInDrunken = false
		else 
			if PlayerDrunkState.getValue() == 3			
				PlayerDrunkState.setValue(4)			
				SoundCoolTimePlay(SayDrinkAlcoholToxicSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
				Game.ShakeCamera(afDuration = 1.0)				
			endif
		endif
	endif
	
	if playerRef.GetWornForm(0x00000004) == none
		Game.SetPlayerReportCrime(false)	; naked 상태에선 crime 행위를 하더라도, 무시될 수 있음

		if undressCount >= 5
			SoundCoolTimePlay(SayStateNakedIrritateSound,_coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		elseif PlayerNakeState.getValue() == 0
			SoundCoolTimePlay(SayStateNakedShockSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
			undressCount += 1
		endif

		PlayerNakeState.setValue(1)		
		isNaked = true
	else 
		PlayerNakeState.setValue(0)
		isNaked = false
	endif

	if Weather.GetCurrentWeather().GetClassification() == 2
		wetBodyStartTime = Utility.GetCurrentGameTime() * 24.0
		isWet = true
	endif

	if isWet
		if !isNaked && playerRef.GetItemCount(WetClothes) == 0
			playerRef.additem(WetClothes, 1)
			Debug.Notification("add wet cloth")
		endif		

		float currentHour = Utility.GetCurrentGameTime() * 24.0
		if currentHour >= wetBodyStartTime + 1.0; 1 시간이 지나면 hang over
			isWet = false
			playerRef.removeItem(WetClothes, playerRef.GetItemCount(WetClothes))
			Debug.Notification("remove wet cloth")			
		endif 
	endif

	RegisterForSingleUpdate(60.0)
endEvent

;
;	Sleep
;
Event OnSleepStop(bool abInterrupted)
	if isInDrunken
		float currentHour = Utility.GetCurrentGameTime() * 24.0
		if currentHour >= drunkenStartTime + 3.0; 3 시간이 지나면 hang over
			PlayerDrunkState.setValue(0)
			isInDrunken = false
		endif
	endif

	if isWet
		float currentHour = Utility.GetCurrentGameTime() * 24.0
		if currentHour >= wetBodyStartTime + 1.0; 1 시간이 지나면 hang over
			isWet = false
			playerRef.removeItem(WetClothes, playerRef.GetItemCount(WetClothes))
			Debug.Notification("return carryWeight to normal")			
		endif 
	endif
EndEvent

;
;	Utility
;
function SoundCoolTimePlay(Sound _sound, float _volume = 0.5, float _coolTime = 1.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
	float currentTime = Utility.GetCurrentRealTime()
	if !playerRef.IsSwimming() && currentTime >= soundCoolTime && currentTime >= coolTimeMap[_mapIdx]	 
		soundCoolTime = currentTime + _coolTime
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime

		int _soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(_soundId, _volume)
	endif
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

GlobalVariable property PlayerNakeState Auto
GlobalVariable property PlayerDrunkState Auto

Actor property playerRef Auto

Sound property SayDrinkAlcoholToxicSound Auto
Sound property SayStateNakedShockSound Auto
Sound property SayStateNakedIrritateSound Auto

Armor property WetClothes Auto