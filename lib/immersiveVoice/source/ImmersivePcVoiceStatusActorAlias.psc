scriptname ImmersivePcVoiceStatusActorAlias extends ReferenceAlias

float  PlayerAVSpeedBonus
float  PlayerAVSpeechBonus

float  drunkenStartTime
float  rainStartTime
float  wetStartTime
float  warmStartTime
float  nakedStartTime

bool   isWet
bool   isNakePenalty
bool   isBareFeetPanalty

float[] coolTimeMap

int    undressCount

Event OnInit()
EndEvent

event OnLoad()
	PlayerAVSpeedBonus = 0.0
	PlayerAVSpeechBonus = 0.0
	init()
	regAnimation()
endEvent

; save -> load 시 호출
Event OnPlayerLoadGame()		
	init()
EndEvent

function init ()	
	drunkenStartTime = 0.0	
	rainStartTime = 0.0
	warmStartTime = 0.0
	wetStartTime = 0.0
	nakedStartTime = 0.0

	undressCount = 0
	
	isWet = false 	
	isNakePenalty = false

	armor _wornArmor = playerRef.GetWornForm(0x00000004) as Armor
	if _wornArmor == none
		PlayerNakeState.setValue(1)
		playerRef.AddToFaction(FactionBanditFriend)
		playerRef.AddToFaction(FactionOrcFriend)
	else 
		clearNaked(_wornArmor, playerRef.GetWornForm(0x00000080) as Armor)
	endif

	PlayerDrunkState.setValue(0)

	coolTimeMap = new float[2]

	UnregisterForUpdate()
	RegisterForSingleUpdate(60.0)
endFunction

function regAnimation ()
	RegisterForSleep()
	; swimming
	RegisterForAnimationEvent(playerRef, "SoundPlay.FSTSwimSwim")	; start
	; RegisterForAnimationEvent(playerRef, "MTState") 				; end
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "SoundPlay.FSTSwimSwim"		
		warmStartTime = 0.0
		wetStartTime = Utility.GetCurrentGameTime() * 24.0
		isWet = true
	; elseif asEventName == "MTState"
	; 	RegisterForSingleUpdate(2.0)			
	endif
endEvent

;
;	Drink
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)	
	actor akActor = akCaster as Actor 
	if akActor == playerRef
		if akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
			Log("Drink acholol")
			PlayerDrunkState.setValue(PlayerDrunkState.getValue() + 1)
			drunkenStartTime = Utility.GetCurrentGameTime() * 24.0				
		endif
	endif
EndEvent

;
;	Cloth status
;
Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	Armor _armor = akBaseObject as armor
	if _armor.IsClothing() || _armor.IsClothingBody() || _armor.IsLightArmor() || _armor.IsHeavyArmor() ||  _armor.IsCuirass() || _armor.IsBoots()

		UnregisterForUpdate()
		RegisterForSingleUpdate(1.0)

		float _speechPenalty = 0.0
		float _speedPenalty = 0.0

		if _armor.HasKeyWordString("HairStyleLong")
			if PlayerAVSpeechBonus >= 7.0
				_speechPenalty = -7.0				
			endif
		elseif _armor.HasKeyWordString("HairStyleShort")
			if PlayerAVSpeechBonus >= 3.0
				_speechPenalty = -3.0
			endif
		elseif _armor.HasKeyWordString("HairStyleBang") 
			if PlayerAVSpeechBonus >= 3.0			
				_speechPenalty = -3.0
			endif
		elseif _armor.HasKeyWordString("HairStylePony")
			if PlayerAVSpeechBonus >= 3.0			
				_speechPenalty = -3.0
			endif
		elseif _armor.HasKeyWordString("ArmorHeels")
			if PlayerAVSpeechBonus >=3.0			
				_speechPenalty = -3.0
			endif

			if PlayerAVSpeedBonus <= 0
				_speedPenalty = 10.0
			endif
		elseif _armor.HasKeyWordString("ClothingSlutty") || _armor.HasKeyWordString("SOS_Revealing") 
			if PlayerAVSpeechBonus >= 10.0			
				_speechPenalty = -10.0
			endif

			if PlayerAVSpeedBonus <= 0
				_speedPenalty = 10.0				
			endif			
		elseif _armor.HasKeyWordString("ClothingSexy") 
			if PlayerAVSpeechBonus >= 7.0
				_speechPenalty = -7.0
			endif

			if PlayerAVSpeedBonus <= 0
				_speedPenalty = 5.0
			endif			
		elseif _armor.HasKeyWordString("ClothingBeauty") 
			if PlayerAVSpeechBonus >= 5.0			
				_speechPenalty = -5.0
			endif
		endif

		PlayerAVSpeechBonus = PlayerAVSpeechBonus + _speechPenalty
		playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechPenalty)

		PlayerAVSpeedBonus = PlayerAVSpeedBonus + _speedPenalty
		playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + _speedPenalty)
	endif
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	armor _wornArmor = playerRef.GetWornForm(0x00000004) as Armor		; armor	
	armor _wornCloak = playerRef.GetWornForm(0x00010000) as Armor		; cloak
	armor _wornPanty = playerRef.GetWornForm(0x00400000) as Armor		; panty

	if _wornArmor
		clearNaked(_wornArmor, playerRef.GetWornForm(0x00000080) as Armor)
		if _wornArmor.IsHeavyArmor() && _armor.GetWeight() >= 30
			PlayerWornHeavyArmor.setValue(1)
			PlayerWornCloth.setValue(1)			
		else 
			if _wornArmor.IsClothingBody()
				PlayerWornCloth.setValue(1)
			else 			
				PlayerWornCloth.setValue(0)
			endif
			PlayerWornHeavyArmor.setValue(0)
		endif
	endif

	if _wornCloak
		PlayerWornCloak.setValue(1)
	else
		PlayerWornCloak.setValue(0)
	endif	

	Armor _armor = akBaseObject as armor
	if _armor.IsClothing() || _armor.IsClothingBody() || _armor.IsLightArmor() || _armor.IsHeavyArmor() ||  _armor.IsCuirass() || _armor.IsBoots()
		Armor _wornBoots = playerRef.GetWornForm(0x00000080) as Armor		; boots
		Armor _wornShortHair = playerRef.GetWornForm(0x00000002) as Armor	; hair short
		Armor _wornLongHair = playerRef.GetWornForm(0x00000800) as Armor	; hair long

		float _speechPenalty = 0.0
		float _speedPenalty = 0.0

		if _armor == _wornArmor
			if _armor.HasKeyWordString("ClothingSlutty") || _armor.HasKeyWordString("SOS_Revealing")
				_speechPenalty = 10.0
				_speedPenalty = -10.0
				SoundCoolTimePlay(SayReactionSluttyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="angry")
			elseif _armor.HasKeyWordString("ClothingSexy")
				_speechPenalty = 7.0
				_speedPenalty = -5.0
				SoundCoolTimePlay(SayReactionSexyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")				
			elseif _armor.HasKeyWordString("ClothingBeauty")
				_speechPenalty = 5.0
				SoundCoolTimePlay(SayReactionBeautyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
			elseif _armor.HasKeyWordString("ClothingPoor")
				SoundCoolTimePlay(SayReactionPoorClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="angry")
			elseif _armor.HasKeyWordString("ClothingRich")
				SoundCoolTimePlay(SayReactionFancyClothSound,_coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
			elseif _armor.HasKeyWordString("ClothingPanty")
				SoundCoolTimePlay(SayReactionPantyClothSound,_coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
			endif
		elseif _armor == _wornBoots
			if _armor.HasKeyWordString("ArmorHeels")
				_speechPenalty = 5.0
				_speedPenalty = -10.0				
				SoundCoolTimePlay(SayReactionHeelsSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
			endif			
			PlayerAVSpeechBonus = PlayerAVSpeechBonus + _speechPenalty
			playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechPenalty)
		elseif _armor == _wornPanty
			SoundCoolTimePlay(SayReactionPantyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
		elseif _armor == _wornShortHair || _armor == _wornLongHair		
			if _armor.HasKeyWordString("HairStyleBold")								
				SoundCoolTimePlay(SayReactionBoldHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="angry")
			elseif _armor.HasKeyWordString("HairStyleLong")
				_speechPenalty = 7.0
				SoundCoolTimePlay(SayReactionLongHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
			elseif _armor.HasKeyWordString("HairStyleShort")
				_speechPenalty = 3.0
				SoundCoolTimePlay(SayReactionShortHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
			elseif _armor.HasKeyWordString("HairStyleBang")
				_speechPenalty = 3.0
				SoundCoolTimePlay(SayReactionBangHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
			elseif _armor.HasKeyWordString("HairStylePony")
				_speechPenalty = 3.0
				SoundCoolTimePlay(SayReactionPonyHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0, _express="happy")
			endif
		endif	
		
		PlayerAVSpeechBonus = PlayerAVSpeechBonus + _speechPenalty
		playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + _speechPenalty)

		PlayerAVSpeedBonus = PlayerAVSpeedBonus + _speedPenalty
		playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + _speedPenalty)

		; log("Speechcraft " + playerRef.getActorValue("Speechcraft"))
		; log("speedmult " + playerRef.getActorValue("speedmult"))
	endif	
EndEvent

;
;	Sleep
;
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	if PlayerDrunkState.getValue() > 0		
		if afDesiredSleepEndTime - afSleepStartTime >= 0.5
			PlayerDrunkState.setValue(0)
		endif
	endif
EndEvent


Event OnUpdate()	

	Location _curLocation = playerRef.GetCurrentLocation()
	Location _pLocation = _curLocation.GetParent()

	if _pLocation			
		if _pLocation.HasKeyWordString("LocTypeTown") || _pLocation.HasKeyWordString("LocTypeCity") || _pLocation.HasKeyWordString("LocTypeSettlement") || _pLocation.HasKeyWordString("LocTypeDwelling")
			PlayerLocationInTown.setValue(1)
		else 
			PlayerLocationInTown.setValue(0)
		endif
	else 
		if _curLocation.HasKeyWordString("LocTypeTown") || _curLocation.HasKeyWordString("LocTypeCity") || _curLocation.HasKeyWordString("LocTypeSettlement") || _curLocation.HasKeyWordString("LocTypeDwelling")
			PlayerLocationInTown.setValue(1)
		else 
			PlayerLocationInTown.setValue(0)
		endif
	endif 

	if PlayerDrunkState.getValue() > 0
		float currentHour = Utility.GetCurrentGameTime() * 24.0
		if currentHour >= drunkenStartTime + 3.0; 3 시간이 지나면 hang over
			PlayerDrunkState.setValue(0)			
		else 
			if PlayerDrunkState.getValue() >= 3
				SoundCoolTimePlay(SayDrinkAlcoholToxicSound, _coolTime=3.0, _mapIdx=1, _mapCoolTime=300.0)
				Game.ShakeCamera(afDuration = 1.0)
			endif
		endif
	endif
	
	armor _wornArmor = playerRef.GetWornForm(0x00000004) as Armor
	if _wornArmor == none
		PlayerNakeState.setValue(1)
		playerRef.AddToFaction(FactionBanditFriend)
		playerRef.AddToFaction(FactionOrcFriend)

		; penalty 부여..
		if isNakePenalty == false
			isNakePenalty = true

			playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") - 20.0)
			playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") - 20.0)
		endif

		if !_curLocation.HasKeyWordString("LocTypePlayerHouse")
			undressCount += 1
			if undressCount >= 10
				SoundCoolTimePlay(SayStateNakedIrritateSound,_coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0, _express="angry")
			else
				SoundCoolTimePlay(SayStateNakedShockSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0, _express="sad")
			endif
		endif				
	else
		clearNaked(_wornArmor,  playerRef.GetWornForm(0x00000080) as Armor)
	endif

	armor _wornBoots = playerRef.GetWornForm(0x00000080) as Armor
	if _wornBoots == none
		; penalty 부여..
		if isBareFeetPanalty == false
			isBareFeetPanalty = true
			playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") - 15.0)
			Debug.Notification("you are barefoot")
		endif			
	else
		clearBareFeet(_wornBoots)
	endif

	if Weather.GetSkyMode()	<= 2	
		if warmStartTime == 0.0
			warmStartTime =  Utility.GetCurrentGameTime() * 24.0
		endif		
	endif

	float currentHour = Utility.GetCurrentGameTime() * 24.0
	if Weather.GetCurrentWeather().GetClassification() == 2
		if rainStartTime == 0.0
			rainStartTime = Utility.GetCurrentGameTime() * 24.0
			warmStartTime = 0.0
		endif

		if currentHour >= rainStartTime + 0.5 && wetStartTime == 0.0
			wetStartTime = Utility.GetCurrentGameTime() * 24.0
			isWet = true
		endif
	else
		if warmStartTime == 0.0
			warmStartTime =  Utility.GetCurrentGameTime() * 24.0
		endif
		rainStartTime = 0.0
	endif

	if isWet	
		; 옷을 입고 있으나, heavy armor 가 아닌 경우..
		if PlayerNakeState.getValue() == 0 && PlayerWornHeavyArmor.getValue() == 0 && playerRef.GetItemCount(WetClothes) == 0
			WetClothes.SetWeight(_wornArmor.GetWeight() * 1.5)
			playerRef.additem(WetClothes, 1)
			SoundCoolTimePlay(SayReactionWetClothSound, _coolTime=5.0, _mapIdx=0, _mapCoolTime=5.0)	
			Debug.Notification("clothes wet")
		else
			if warmStartTime != 0.0
				if playerRef.GetItemCount(WetClothes) > 0 && currentHour >= warmStartTime + 0.5; 30분이 지나면 dry 상태
					isWet = false
					wetStartTime = 0.0
					playerRef.removeItem(WetClothes, playerRef.GetItemCount(WetClothes))
					SoundCoolTimePlay(SayReactionWetClothSound, _coolTime=5.0, _mapIdx=0, _mapCoolTime=5.0)						
					Debug.Notification("clothes dried out")
				endif 
			endif
		endif
	endif

	; log("updateState hour " + currentHour + ", isWet " + isWet + ", warmTime " + warmStartTime + ", curHour " + currentHour)
	RegisterForSingleUpdate(60.0)
endEvent

;
;	Utility
;
function clearBareFeet(armor _boots)
	if isBareFeetPanalty
		isBareFeetPanalty = false
		
		playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + 15.0)
	endif
endfunction

function clearNaked(armor _armor, armor _boots)
	PlayerNakeState.setValue(0)
	playerRef.RemoveFromFaction(FactionBanditFriend)
	playerRef.RemoveFromFaction(FactionOrcFriend)
	expression("reset")

	if isNakePenalty
		isNakePenalty = false

		playerRef.SetActorValue("Speechcraft", playerRef.GetActorValue("Speechcraft") + 20.0)
		playerRef.SetActorValue("speedmult", playerRef.GetActorValue("speedmult") + 20.0)
	endif

	; 무거운 갑옷인 경우만..
	float maxWeight = 0.0
	
	if _boots
		maxWeight += _boots.GetWeight()	
	endif

	if _armor
		maxWeight = _armor.GetWeight()

		if _armor.IsHeavyArmor() && maxWeight >= 30.0
			PlayerWornHeavyArmor.setValue(1)
		else 
			PlayerWornHeavyArmor.setValue(0)
		endif		
	else 
		PlayerWornHeavyArmor.setValue(0)
	endif 
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

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, int _mapIdx = 0, float _mapCoolTime = 1.0, string _express = "reset")
	if pcVoiceMCM.enableStatusSound == false || PlayerRef.isSwimming() || PlayerRef.IsInCombat()
		return
	endif

	while Utility.IsInMenuMode()
		Utility.WaitMenuMode(0.1)
	endWhile	

	float currentTime = Utility.GetCurrentRealTime()
	if currentTime >= soundCoolTime.getValue() && currentTime >= coolTimeMap[_mapIdx]		
		soundCoolTime.setValue(currentTime + _coolTime)
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime

		Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
		expression(_express)
	endif
endFunction

function SoundPlay(Sound _sound, float _volume = 0.8)	
	if pcVoiceMCM.enableStatusSound == false || playerRef.IsSwimming() || PlayerRef.IsInCombat()
		return
	endif 
	
	Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

ImmersivePcVoiceMCM property pcVoiceMCM Auto

GlobalVariable property soundCoolTime Auto
GlobalVariable property PlayerNakeState Auto
GlobalVariable property PlayerDrunkState Auto
GlobalVariable property PlayerLocationInTown Auto
GlobalVariable property PlayerWornHeavyArmor Auto
GlobalVariable property PlayerWornCloth Auto
GlobalVariable property PlayerWornCloak Auto

Actor property playerRef Auto

Sound property SayDrinkAlcoholToxicSound Auto
Sound property SayStateNakedShockSound Auto
Sound property SayStateNakedIrritateSound Auto

; etc
Sound property SayReactionSluttyClothSound Auto
Sound property SayReactionBeautyClothSound Auto
Sound property SayReactionSexyClothSound Auto
Sound property SayReactionPantyClothSound Auto
Sound property SayReactionPoorClothSound Auto
Sound property SayReactionFancyClothSound Auto

Sound property SayReactionHeelsSound Auto

Sound property SayReactionLongHairSound Auto	; HairStyleLong
Sound property SayReactionShortHairSound Auto	; HairStyleShort
Sound property SayReactionPonyHairSound Auto	; HairStylePony
Sound property SayReactionBangHairSound Auto	; HairStyleBang
Sound property SayReactionBoldHairSound Auto	; HairStyleBold

Sound property SayReactionWetClothSound Auto	;
Sound property SayReactionDryClothSound Auto	; 

Armor property WetClothes Auto

Faction property FactionBanditFriend Auto
Faction property FactionOrcFriend Auto


; ArmorMaterialDaedric, ArmorMaterialDragonScale, ArmorMaterialDwarven, ArmorMaterialEbony, ArmorMaterialEleven, ArmorMaterialGlass, ArmorMaterialOrcish, ArmorMaterialPenitus
; ArmorMaterialSteel, ArmorMaterialIron, ArmorMaterialLeather, 