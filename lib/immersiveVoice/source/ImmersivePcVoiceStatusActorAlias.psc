scriptname ImmersivePcVoiceStatusActorAlias extends ReferenceAlias

float  drunkenStartTime
float  wetBodyStartTime
float  nakedStartTime

bool   isWet

float[] coolTimeMap

int    undressCount

Event OnInit()
EndEvent

event OnLoad()
	LOG("Status load..")
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
	
	isWet = false 

	Armor _armor = playerRef.GetWornForm(0x00000004) as Armor
	if _armor == none
		PlayerNakeState.setValue(1)
		playerRef.AddToFaction(FactionBanditFriend)
	else 
		PlayerNakeState.setValue(0)
		playerRef.RemoveFromFaction(FactionBanditFriend)
	endif

	PlayerDrunkState.setValue(0)

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
	if akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
		Log("Drink acholol")
		PlayerDrunkState.setValue(PlayerDrunkState.getValue() + 1)
		drunkenStartTime = Utility.GetCurrentGameTime() * 24.0				
	endif
EndEvent

Event OnUpdate()	
	if PlayerDrunkState.getValue() > 0.0
		float currentHour = Utility.GetCurrentGameTime() * 24.0
		if currentHour >= drunkenStartTime + 3.0; 3 시간이 지나면 hang over
			PlayerDrunkState.setValue(0)			
		else 
			if PlayerDrunkState.getValue() == 3.0
				PlayerDrunkState.setValue(4)			
				SoundCoolTimePlay(SayDrinkAlcoholToxicSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
				Game.ShakeCamera(afDuration = 1.0)				
			endif
		endif
	endif
	
	if playerRef.GetWornForm(0x00000004) == none
		PlayerNakeState.setValue(1)		
		playerRef.AddToFaction(FactionBanditFriend)

		Location currentLocation = playerRef.GetCurrentLocation()
		if !currentLocation.HasKeyWordString("LocTypePlayerHouse")
			undressCount += 1
			if undressCount >= 5
				SoundCoolTimePlay(SayStateNakedIrritateSound,_coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
			else
				SoundCoolTimePlay(SayStateNakedShockSound, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)				
			endif
		endif
	else 
		PlayerNakeState.setValue(0)		
		playerRef.RemoveFromFaction(FactionBanditFriend)
	endif

	if Weather.GetCurrentWeather().GetClassification() == 2
		wetBodyStartTime = Utility.GetCurrentGameTime() * 24.0
		isWet = true
	endif

	if isWet
		if PlayerNakeState.setValue(0) && playerRef.GetItemCount(WetClothes) == 0			
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
;	equip
;
; InventoryMenu가 아닌 npc나 console 을 통해, 임의적으로 clothes가 off된 경우 처리
Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

	if playerRef.IsInCombat()
	 	return 
	endif 

	Armor _armor = akBaseObject as armor
		
	if akReference != None && (_armor.IsClothing() || _armor.IsLightArmor() || _armor.IsHeavyArmor() ||  _armor.IsCuirass() || _armor.IsBoots() || _armor.IsClothingBody())
		Armor _wornArmor = playerRef.GetWornForm(0x00000004) as Armor		; armor
		Armor _wornPanty = playerRef.GetWornForm(0x00400000) as Armor		; panty
		Armor _wornShoes = playerRef.GetWornForm(0x00000080) as Armor		; shoes
		Armor _wornShortHair = playerRef.GetWornForm(0x00000002) as Armor	; hair short
		Armor _wornLongHair = playerRef.GetWornForm(0x00000800) as Armor	; hair long

		if _armor == _wornArmor
			log("wornArmor")
			clearNaked()
			if _armor.HasKeyWordString("ClothingSlutty")
				SoundCoolTimePlay(SayReactionSluttyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("angry")
			elseif _armor.HasKeyWordString("ClothingSexy")
				SoundCoolTimePlay(SayReactionSexyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			elseif _armor.HasKeyWordString("ClothingPoor")
				SoundCoolTimePlay(SayReactionPoorClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("angry")
			elseif _armor.HasKeyWordString("ClothingRich")
				SoundCoolTimePlay(SayReactionFancyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			elseif _armor.HasKeyWordString("ClothingPanty")
				SoundCoolTimePlay(SayReactionPantyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
				log("wornPanty")
			endif	
		elseif _armor == _wornPanty
			log("wornPanty")
			clearNaked()
			SoundCoolTimePlay(SayReactionPantyClothSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
			expression("happy")		
		elseif _armor == _wornShoes
			if _armor.HasKeyWordString("ArmorHeels")
				SoundCoolTimePlay(SayReactionHeelsSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			endif
		elseif _armor == _wornShortHair || _armor == _wornLongHair
			if _armor.HasKeyWordString("HairStyleBold")
				SoundCoolTimePlay(SayReactionBoldHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("angry")
			elseif _armor.HasKeyWordString("HairStyleLong")
				SoundCoolTimePlay(SayReactionLongHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			elseif _armor.HasKeyWordString("HairStyleShort")
				SoundCoolTimePlay(SayReactionShortHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			elseif _armor.HasKeyWordString("HairStyleBang")
				SoundCoolTimePlay(SayReactionBangHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			elseif _armor.HasKeyWordString("HairStylePony")
				SoundCoolTimePlay(SayReactionPonyHairSound, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
				expression("happy")
			endif
		endif
	endif	
EndEvent

;
;	Sleep
;
Event OnSleepStop(bool abInterrupted)
	if PlayerDrunkState.getValue() > 0.0
		float currentHour = Utility.GetCurrentGameTime() * 24.0
		if currentHour >= drunkenStartTime + 3.0; 3 시간이 지나면 hang over
			PlayerDrunkState.setValue(0)			
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
function clearNaked()
	PlayerNakeState.setValue(0)	
	playerRef.RemoveFromFaction(FactionBanditFriend)
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


function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
	if pcVoiceMCM.enableStatusSound == false || PlayerRef.isSwimming()
		return
	endif

	float currentTime = Utility.GetCurrentRealTime()
	if currentTime >= soundCoolTime.getValue() && currentTime >= coolTimeMap[_mapIdx]	 
		soundCoolTime.setValue(currentTime + _coolTime)
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime

		int _soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(_soundId, _volume)
	endif
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

ImmersivePcVoiceMCM property pcVoiceMCM Auto

GlobalVariable property soundCoolTime Auto
GlobalVariable property PlayerNakeState Auto
GlobalVariable property PlayerDrunkState Auto

Actor property playerRef Auto

Sound property SayDrinkAlcoholToxicSound Auto
Sound property SayStateNakedShockSound Auto
Sound property SayStateNakedIrritateSound Auto

; etc
Sound property SayReactionSluttyClothSound Auto
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

Armor property WetClothes Auto

Faction property FactionBanditFriend Auto