scriptname ImmersivePcVoiceActionActorAlias extends ReferenceAlias

Actor  controlActor
ObjectReference overHairRef
ObjectReference lastOverHairContainerRef

int    playerCrimeGold

float  drunkenStartTime
Faction possibleCrimeFaction	
int    possibleCrimeGold
float[] coolTimeMap

int    SneakBgSoundId
float  sneakingBgSoundVolume

int    underWaterSoundId
float  underWaterSoundVolume

Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume

Event OnInit()
	initMenu()	
EndEvent

event OnLoad()
	registerAction()	
	setup()
	init()
endEvent

; save -> load 시 호출
Event OnPlayerLoadGame()		
	init()
EndEvent

function initMenu()	
	UnregisterForAllMenus()
	RegisterForMenu("MapMenu")		
	RegisterForMenu("Journal Menu")
	RegisterForMenu("ContainerMenu")
	RegisterForMenu("Lockpicking Menu")
	RegisterForMenu("Sleep/Wait Menu")
endFunction

function registerAction ()	
	regAnimation()
endFunction

function setup()
endFunction

function init ()		
	underWaterSoundId = 0
	underWaterSoundVolume = 0.0

	SneakBgSoundId = 0
	sneakingBgSoundVolume = 0.0

	overHairRef = None	
	controlActor = None
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	possibleCrimeGold = 0	

	coolTimeMap = new float[20] 
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")	

	; sprint
	RegisterForAnimationEvent(playerRef, "FootSprintLeft")	; foot left
	RegisterForAnimationEvent(playerRef, "FootSprintRight")	; foot right	

	; voice cast
	RegisterForAnimationEvent(playerRef, "BeginCastVoice")

	; ride
	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseMount") 	
	RegisterForAnimationEvent(playerRef, "DragonMountEnter") 		

	; jump
	RegisterForAnimationEvent(playerRef, "JumpUp")
	RegisterForAnimationEvent(playerRef, "JumpDown")
	
	; sneak
	RegisterForAnimationEvent(playerRef, "tailSneakIdle") 			; start in standing
	RegisterForAnimationEvent(playerRef, "tailMTIdle") 				; end in sprint or sneak

	; swimming
	RegisterForAnimationEvent(playerRef, "SoundPlay.FSTSwimSwim")	; start
	RegisterForAnimationEvent(playerRef, "MTState") 				; end
endFunction

Event OnControlDown(string control)	
	overHairRef = Game.GetCurrentCrosshairRef()	

	If overHairRef != none
		Actor akActor = overHairRef as Actor
		if akActor.isDead()
			if akActor.HasKeyWordString("ActorTypeNPC")
				SoundCoolTimePlay(SayActionSearchDeadBodySound, _volume=0.3, _delay=0.0, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5, _express="happy")
			elseif akActor.HasKeyWordString("ActorTypeAnimal")
				SoundCoolTimePlay(SayActionSearchDeadCreatureSound, _volume=0.3, _delay=0.0, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5, _express="happy")
			else
				SoundCoolTimePlay(SayActionSearchDeadCreatureSound, _volume=0.3, _delay=0.0, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5, _express="angry")
			endif
			return 
		endif 

		Furniture akFurniture = overHairRef.GetBaseObject() as Furniture
		if akFurniture.hasKeywordString("ActivatorLever")
			SoundPlay(SayActionMoveLeverSound, 1.0)	
			return
		endif

		Activator akActivator= overHairRef.GetBaseObject() as Activator
		if akActivator.hasKeywordString("ActivatorPillar")
			SoundPlay(SayActionMoveLeverSound, 1.0)
			return	
		endif
	endif
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)

	if PlayerWornHeavyArmor.getValue() == 1
		if  asEventName == "FootSprintLeft"
			SoundPlay(SoundActionHeavyArmorLeftStep, 0.1)
			return
		elseif  asEventName == "FootSprintRight"
			SoundPlay(SoundActionHeavyArmorRightStep, 0.1)
			return
		elseif asEventName == "JumpDown"
			SoundPlay(SoundActionHeavyArmorRightStep, 0.3)
			return
		endif
	elseif PlayerWornCloak.getValue() == 1
		if  asEventName == "FootSprintLeft"
			SoundPlay(SoundActionCloak, 0.2)
			return
		elseif  asEventName == "FootSprintRight"
			return
		elseif asEventName == "JumpDown"
			SoundPlay(SoundActionCloak, 0.3)
			return
		endif
	elseif PlayerWornCloth.getValue() == 1
		if  asEventName == "FootSprintLeft"
			SoundPlay(SoundActionRobeLeftStep, 0.1)
			return
		elseif  asEventName == "FootSprintRight"
			SoundPlay(SoundActionRobeRightStep, 0.1)
			return
		elseif asEventName == "JumpDown"
			SoundPlay(SoundActionRobeLeftStep, 0.3)
			return
		endif		
	endif

	if asEventName == "JumpUp"		
		SoundPlay(SayActionJumpUpSound, 0.2)		
	elseif asEventName == "tailSneakIdle"
		; 만약 손에 활을 들고 있다면, sneak BG 출력 무시
		if  playerRef.GetEquippedItemType(0) != 7 && playerRef.GetEquippedItemType(1) != 7 	;bow			

			if SneakBgSoundId == 0
				SneakBgSoundId = SoundBGPlay(SayBgSneakModeSound, sneakingBgSoundVolume)			
			else 
				sneakingBgSoundVolume += 0.1
				SoundVolumeUp(SneakBgSoundId, sneakingBgSoundVolume)

				if sneakingBgSoundVolume == 0.1					
					SoundBGPlay(SayActionSneakSound, _volume=0.4)					
				endif
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
		int tempId = SoundSwimmingPlay(SayActionUnderWaterSound, underWaterSoundVolume)
		
		if tempId != 0
			underWaterSoundId = tempId
			underWaterSoundVolume += 0.1
			if underWaterSoundVolume > 0.4
				underWaterSoundVolume = 0.4
			endif			
		endif

	elseif asEventName == "MTState"		
		if underWaterSoundId != 0
			Sound.StopInstance(underWaterSoundId)
		endif
		underWaterSoundId = 0
		underWaterSoundVolume = 0.0			
	elseif asEventName == "SoundPlay.NPCHorseMount"	|| asEventName == "DragonMountEnter"
		log("SoundPlay.NPCHorseMount")
		SoundCoolTimePlay(SayActionRidingSound, _delay=0.2, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5)				
	endif
	; Log("OnAnimationEvent " + asEventName)
endEvent

;
;	Drink
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)		
	actor akActor = akCaster as Actor
	if akActor == playerRef
		if akEffect.HasKeyWordString("StoneDoomEffect")		; doom
			if akEffect.HasKeyWordString("StoneDoomMaraEffect")		; doom
				SoundCoolTimePlay(SayActionRitualMaraSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
			elseif akEffect.HasKeyWordString("StoneDoomTalosEffect")		; doom
				SoundCoolTimePlay(SayActionRitualMaraSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
			elseif akEffect.HasKeyWordString("StoneDoomDebellaEffect")		; doom
				SoundCoolTimePlay(SayActionRitualDebellaSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
			else 
				Debug.SendAnimationEvent(playerRef, "IdleGreybeardMeditateEnter")
				SoundCoolTimePlay(SayActionRitualSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
				Utility.Wait(3.0)
				Debug.SendAnimationEvent(playerRef, "idleGreybeardMeditateExit")
				Utility.Wait(2.0)		
			endif				
		elseif akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
			SoundCoolTimePlay(SayDrinkAlcoholSound, _coolTime=3.0, _mapIdx=5, _mapCoolTime=3.0)	
		elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& (akEffect.HasKeyWordString("MagicAlchRestoreHealth") || akEffect.HasKeyWordString("MagicAlchRestoreMagicka") || akEffect.HasKeyWordString("MagicAlchRestoreStamina"))
			SoundCoolTimePlay(SayDrinkPotionSound, _coolTime=3.0, _mapIdx=5, _mapCoolTime=3.0)
		elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure
			SoundCoolTimePlay(SayDrinkPotionSound, _coolTime=3.0, _mapIdx=5, _mapCoolTime=3.0)				
		endif
	else
		if akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure
			SoundCoolTimePlay(SayDrinkPotionSound, _coolTime=3.0, _mapIdx=5, _mapCoolTime=3.0)									
		elseif akEffect.HasKeyWordString("OffensiveWordHarmful")		; 나중에 추가
	
		elseif akEffect.HasKeyWordString("OffensiveActionHarmful")		; 나중에 추가
	
		elseif akEffect.HasKeyWordString("IrritatingActionHarmful")		; 나중에 추가
	
		endif	
	endif 
EndEvent

Event OnBookRead(Book akBook)
	SoundCoolTimePlay(SayActionBookReadSound, _delay=0.2, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5)
EndEvent

Event OnDragonSoulGained(float afSouls)
	SoundCoolTimePlay(SayActionDragonSoulSound, _delay=0.2, _coolTime=5.0, _mapIdx=0, _mapCoolTime=5.0)

	playerRef.SetRestrained(true)
	Debug.SendAnimationEvent(playerRef, "BleedoutStart")
	Utility.Wait(5.0)
	Debug.SendAnimationEvent(playerRef, "BleedoutStop")
	playerRef.SetRestrained(false)

	Log("OnDragonSoulGained")
EndEvent

Event OnItemHarvested(Form akProduce)
	SoundCoolTimePlay(SayActionHarvestedSound, _delay=0.5, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
EndEvent

; Event OnLevelIncrease(int aiLevel)
; 	SoundCoolTimePlay(SayActionLevelUpSound, _delay=0.2, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
; 	Log("OnLevelIncrease")
; EndEvent

; Event that is triggered when this actor sits in the furniture
Event OnSit(ObjectReference akFurniture)	
	if playerRef.IsInCombat()
		return
	endif 

	if akFurniture.HasKeywordString("CraftingCookpot")
		SoundCoolTimePlay(SayActionCookingSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
	elseif akFurniture.HasKeywordString("CraftingSmithingForge")
		SoundCoolTimePlay(SayActionSmithingSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		log("forge")
	elseif akFurniture.HasKeywordString("CraftingTanningRack")
		SoundCoolTimePlay(SayActionSmithingSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		log("TanningRack")		
	elseif akFurniture.HasKeywordString("CraftingSmithingArmorTable")
		SoundCoolTimePlay(SayActionSmithingSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		log("Smithing ArmorTable")		
	; elseif akFurniture.HasKeywordString("CraftingSmithingSharpeningWheel")
	; 	log("Smithing Sharpen")
	; elseif akFurniture.HasKeywordString("BYOHCarpenterTable")
	; 	log("carpenter")
	; elseif akFurniture.HasKeywordString("isGrainMill")
	; 	log("grainMill")
	; elseif akFurniture.HasKeyWordString("CraftingSmelter")
	; 	log("smelter")		
	; elseif akFurniture.HasKeyWordString("WICraftingAlchemy")		
	; 	log("alchemy")		
	; elseif akFurniture.HasKeyWordString("WICraftingEnchanting")		
	; 	log("enchanting")				
	; elseif akFurniture.HasKeyWordString("FurnitureWoodChoppingBlock")
	; 	log("woodChopping")		
	; elseif akFurniture.HasKeyWordString("isPickaxeFloor") || akFurniture.HasKeyWordString("isPickaxeWall")
	; 	log("pickaxe")
	elseif akFurniture.HasKeyWordString("isBench") || akFurniture.HasKeyWordString("isTable") || akFurniture.HasKeyWordString("isChair") || akFurniture.HasKeyWordString("isCart")
		if PlayerNakeState.getValue() == 1
			SoundCoolTimePlay(SayActionSitNakedSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		else
			SoundCoolTimePlay(SayActionSitSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		endif
	else
		SoundCoolTimePlay(SayActionSitDefaultSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		log("unknown furniture ")
	endif

	expression("happy")
EndEvent

; Event that is triggered when this actor leaves the furniture
Event OnGetUp(ObjectReference akFurniture)	
EndEvent

;
;	Menu
;
Event OnMenuOpen(string menuName)
	if menuName == "MapMenu"		
		SoundCoolTimePlay(SayActionTravelSound, _delay=0.5, _coolTime=2.0, _mapIdx=2, _mapCoolTime=10.0)
	elseif menuName == "ContainerMenu"
		if lastOverHairContainerRef != none && (lastOverHairContainerRef == overHairRef)
			if lastOverHairContainerRef.IsLocked() == false
				SoundPlay(SayActionSuccessSound,  _volume=0.7)
			endif
		endif		
	elseif menuName == "Lockpicking Menu"
		lastOverHairContainerRef = Game.GetCurrentCrosshairRef()		
	elseif menuName == "Sleep/Wait Menu"
		if playerRef.GetSleepState() == 3
			SoundCoolTimePlay(SayActionSleepSound, _delay=0.5, _coolTime=2.0, _mapIdx=3, _mapCoolTime=10.0)
		else 
			SoundCoolTimePlay(SayActionWaitSound, _delay=0.5, _coolTime=2.0, _mapIdx=3, _mapCoolTime=10.0)
		endif
	endif
endEvent

Event OnMenuClose(string menuName)
	if menuName == "Sleep/Wait Menu"
		Game.FadeOutGame(false, true, 0.5, 3.0)
	endif	
endEvent

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
function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0, string _express="happy")
	if pcVoiceMCM.enableActionSound == false || playerRef.IsSwimming()
		return
	endif 	
	
	float currentTime = Utility.GetCurrentRealTime()
	if currentTime >= soundCoolTime.GetValue() && currentTime >= coolTimeMap[_mapIdx]		 	
		soundCoolTime.setValue(currentTime + _coolTime)
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
		expression(_express)
	endif
endFunction

function SoundPlay(Sound _sound, float _volume = 0.8)	
	if pcVoiceMCM.enableActionSound == false || playerRef.IsSwimming()
		return
	endif 
	
	Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
endFunction

int function SoundBGPlay(Sound _sound, float _volume = 0.8)	
	int soundId = 0
	if pcVoiceMCM.enableActionSound == false || playerRef.IsSwimming()
		return soundId
	endif 
	soundId = _sound.Play(playerRef)	
	Sound.SetInstanceVolume(soundId, _volume)
	return soundId
endFunction

function SoundVolumeUp(int _soundId, float _volume = 0.1)	
	if playerRef.IsSwimming()
		return
	endif 

	if _volume > 0.5 
		_volume = 0.5
	endif
	Sound.SetInstanceVolume(_soundId, _volume)
endFunction

int function SoundSwimmingPlay(Sound _sound, float _volumn = 0.8, int _mapIdx = 15, float _mapCoolTime = 4.0)
	float currentTime = Utility.GetCurrentRealTime()
	int soundId = 0
	if currentTime >= coolTimeMap[_mapIdx]
		soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(soundId, _volumn)
	else 
		return 0
	endif
	return soundId
endFunction

function expression(string _type)
	if _type == "happy"
		playerRef.SetExpressionOverride(2, 70)				; happy
	elseif _type == "sad"
		playerRef.SetExpressionOverride(3, 70)				; sad
	elseif _type == "angry"
		playerRef.SetExpressionOverride(6, 70)				; angry
	else
		MfgConsoleFunc.ResetPhonemeModifier(playerRef)		; reset		
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

ImmersivePcVoiceMCM property pcVoiceMCM Auto

GlobalVariable property soundCoolTime Auto
GlobalVariable property PlayerNakeState Auto
GlobalVariable property PlayerDrunkState Auto
GlobalVariable property PlayerWornHeavyArmor Auto
GlobalVariable property PlayerWornCloth Auto
GlobalVariable property PlayerWornCloak Auto
GlobalVariable property PlayerLocationInTown Auto

Actor property playerRef Auto

; action
Sound property SayActionUnderWaterSound Auto	
Sound property SayActionMoveLeverSound Auto
Sound property SayActionHarvestedSound Auto			
Sound property SayActionBookReadSound Auto			
Sound property SayActionDragonSoulSound Auto
Sound property SayActionJumpUpSound Auto
; Sound property SayActionLevelUpSound Auto
Sound property SayActionSitSound Auto
Sound property SayActionSitNakedSound Auto
Sound property SayActionSitDefaultSound Auto
Sound property SayActionSleepSound Auto
Sound property SayActionWaitSound Auto
Sound property SayActionTravelSound Auto
Sound property SayActionRidingSound Auto
Sound property SayActionSneakSound Auto
Sound property SayActionSuccessSound Auto
Sound property SayActionSearchDeadBodySound Auto
Sound property SayActionSearchDeadCreatureSound Auto

Sound property SayActionCookingSound Auto
Sound property SayActionSmithingSound Auto

Sound property SayActionRitualSound Auto
Sound property SayActionRitualMaraSound Auto
Sound property SayActionRitualTalosSound Auto
Sound property SayActionRitualDebellaSound Auto

; drink
Sound property SayDrinkAlcoholSound Auto
Sound property SayDrinkPotionSound Auto

; heavy weight armor sound
Sound property SoundActionHeavyArmorLeftStep Auto
Sound property SoundActionHeavyArmorRightStep Auto

Sound property SoundActionRobeLeftStep Auto
Sound property SoundActionRobeRightStep Auto

Sound property SoundActionCloak Auto

; etc
Sound property SayBgSneakModeSound Auto
Sound property SayDefaultSound Auto