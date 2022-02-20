scriptname ImmersivePcVoiceActionActorAlias extends ReferenceAlias

Actor  controlActor
ObjectReference overHairRef
ObjectReference lastOverHairContainerRef

int    playerCrimeGold

float  drunkenStartTime
Faction possibleCrimeFaction	
float[] coolTimeMap

int    SneakBgSoundId
float  sneakingBgSoundVolume

int    underWaterSoundId
float  underWaterSoundVolume

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

int    footstepCount
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

	runningCoolTimeExpress = "happy"
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	footstepCount = 0

	coolTimeMap = new float[10] 
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")	

	; sprint
	RegisterForAnimationEvent(playerRef, "FootSprintLeft")	; foot left
	; RegisterForAnimationEvent(playerRef, "FootSprintRight")	; foot right	

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
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	overHairRef = Game.GetCurrentCrosshairRef()
	If overHairRef != none
		int _type = overHairRef.getType()
		; pcVoiceMCM.Log("activator " + _type)

		if _type == 61  ; activator/furniture
			Activator akActivator= overHairRef.GetBaseObject() as Activator
			if akActivator 
				if akActivator.hasKeywordString("ActivatorPillar") || akActivator.hasKeywordString("ActivatorLever") || akActivator.hasKeywordString("ActivatorChain") || akActivator.hasKeywordString("DoorKeyHole")
					SoundPlay(SayActionMoveLeverSound)
					return
				elseif akActivator.hasKeywordString("ActivatorTorch")
					SoundPlay(SayActionTorchSound)
					return
				endif
			endif

			Furniture akFurniture = overHairRef.GetBaseObject() as Furniture
			if akFurniture && (akFurniture.hasKeywordString("ActivatorLever") || akFurniture.hasKeywordString("ActivatorPillar") || akFurniture.hasKeywordString("ActivatorChain"))
				SoundPlay(SayActionMoveLeverSound)
				return
			endif
		elseif _type == 43 || _type == 62
			Actor _akActor = overHairRef as Actor
			if _akActor && _akActor.isDead()
				if _akActor.HasKeyWordString("ActorTypeNPC")				
					if _akActor.GetKiller() != playerRef
						SoundCoolTimePlay(SayActionFoundDeadBodySound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=2.0, _express="happy")
					else 
						SoundCoolTimePlay(SayActionSearchDeadBodySound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=2.0, _express="happy")
					endif
				elseif _akActor.HasKeyWordString("ActorTypeAnimal")
					SoundCoolTimePlay(SayActionSearchDeadCreatureSound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=2.0, _express="happy")
				else
					SoundCoolTimePlay(SayActionSearchDeadCreatureSound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=2.0, _express="angry")
				endif
				return
			endif		
		endif	
	endif
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	if pcVoiceMCM.wornArmor
		if pcVoiceMCM.wornArmor.IsHeavyArmor()
			if  asEventName == "FootSprintLeft"
				if footstepCount % 2 == 0
					SoundPlay(SoundActionHeavyArmorLeftStep, 0.1)
				else
					SoundPlay(SoundActionHeavyArmorRightStep, 0.1)
				endif
				footstepCount += 1
				return
			; elseif  asEventName == "FootSprintRight"
			; 	SoundPlay(SoundActionHeavyArmorRightStep, 0.1)
			; 	return
			elseif asEventName == "JumpDown"
				SoundPlay(SoundActionHeavyArmorRightStep, 0.3)
				return
			endif
		elseif pcVoiceMCM.wornArmor.IsClothingBody()
			if  asEventName == "FootSprintLeft"
				SoundPlay(SoundActionRobeLeftStep, 0.1)
				return
			; elseif  asEventName == "FootSprintRight"
			; 	SoundPlay(SoundActionRobeRightStep, 0.1)
			; 	return
			elseif asEventName == "JumpDown"
				SoundPlay(SoundActionRobeLeftStep, 0.3)
				return
			endif	
		endif		
	elseif pcVoiceMCM.wornCloak
		if  asEventName == "FootSprintLeft"
			SoundPlay(SoundActionCloak, 0.2)
			return
		; elseif  asEventName == "FootSprintRight"
		; 	return
		elseif asEventName == "JumpDown"
			SoundPlay(SoundActionCloak, 0.3)
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
		; log("SoundPlay.NPCHorseMount")
		SoundCoolTimePlay(SayActionRidingSound, _delay=0.2, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5)				
	endif
	; Log("OnAnimationEvent " + asEventName)
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
		if akEffect.HasKeyWordString("StoneDoomEffect")		; doom
			if akEffect.HasKeyWordString("StoneDoomMaraEffect")		; doom
				SoundCoolTimePlay(SayActionRitualMaraSound,_delay=0.2, _coolTime=3.0)
			elseif akEffect.HasKeyWordString("StoneDoomTalosEffect")		; doom
				SoundCoolTimePlay(SayActionRitualMaraSound,_delay=0.2, _coolTime=3.0)
			elseif akEffect.HasKeyWordString("StoneDoomDebellaEffect")		; doom
				SoundCoolTimePlay(SayActionRitualDebellaSound,_delay=0.2, _coolTime=3.0)
			else 
				SoundCoolTimePlay(SayActionRitualSound, _delay=0.5, _coolTime=3.0)

				int _cameraMode = Game.GetCameraState()
				if _cameraMode == 0 ; firstPerson
					Game.ForceThirdPerson()
				endif

				bool _isWeaponDraw = false
				if playerRef.IsWeaponDrawn()						
					_isWeaponDraw = true
					playerRef.SheatheWeapon()
				endif 

				Game.DisablePlayerControls(false, false, true, false, false, false, false)
				Debug.SendAnimationEvent(playerRef, "IdleGreybeardMeditateEnter")
				Utility.Wait(3.0)
				Debug.SendAnimationEvent(playerRef, "IdleGreybeardMeditateExit")
				Utility.Wait(2.0)
				Debug.SendanimationEvent(PlayerRef, "IdleForceDefaultState")
				Game.EnablePlayerControls()

				if _isWeaponDraw
					playerRef.DrawWeapon()
				endif

				if _cameraMode == 0 ; firstPerson
					Game.ForceFirstPerson()
				endif
			endif
			
		elseif akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
			SoundCoolTimePlay(SayDrinkAlcoholSound, _coolTime=3.0, _mapIdx=5, _mapCoolTime=3.0)	
		elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& (akEffect.HasKeyWordString("MagicAlchRestoreHealth") || akEffect.HasKeyWordString("MagicAlchRestoreMagicka") || akEffect.HasKeyWordString("MagicAlchRestoreStamina"))
			SoundCoolTimePlay(SayDrinkPotionSound, _coolTime=3.0, _mapIdx=5, _mapCoolTime=3.0)
		elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure
			SoundCoolTimePlay(SayDrinkPotionSound, _coolTime=3.0, _mapIdx=5, _mapCoolTime=3.0)				
		endif
	; elseif akEffect.HasKeyWordString("DragonSoulAbsorb")
	; 	SoundCoolTimePlay(SayActionDragonSoulSound, _delay=0.2, _coolTime=5.0, _mapIdx=6, _mapCoolTime=5.0)

	; 	playerRef.SetRestrained(true)
	; 	Debug.SendAnimationEvent(playerRef, "BleedoutStart")
	; 	Utility.Wait(3.0)
	; 	Debug.SendAnimationEvent(playerRef, "BleedoutStop")
	; 	playerRef.SetRestrained(false)	
	; 	; pcVoiceMCM.Log("OnDragonSoulGained")
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
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	SoundCoolTimePlay(SayActionBookReadSound, _delay=0.2, _coolTime=2.0, _mapIdx=5, _mapCoolTime=2.0)
EndEvent

Event OnItemHarvested(Form akProduce)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	SoundCoolTimePlay(SayActionHarvestedSound, _delay=0.5, _coolTime=2.0, _mapIdx=7, _mapCoolTime=2.0)
EndEvent

; Event OnLevelIncrease(int aiLevel)
; 	SoundCoolTimePlay(SayActionLevelUpSound, _delay=0.2, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
; 	Log("OnLevelIncrease")
; EndEvent

; Event that is triggered when this actor sits in the furniture
Event OnSit(ObjectReference akFurniture)	
	pcVoiceMCM.isSit = true

	if !pcVoiceMCM.isGameRunning || playerRef.IsInCombat()
		return 
	endif
	;/	FURNITURE TYPES	
		Perch = 0
		Lean = 1
		Sit = 2
		Sleep = 3
	/;
	Furniture _akFurniture = akFurniture.GetBaseObject() as Furniture
	int furnitureType = PO3_SKSEFunctions.GetFurnitureType(_akFurniture)

	if furnitureType == 1  ; lean
		if akFurniture.HasKeywordString("CraftingCookpot")
			SoundCoolTimePlay(SayActionCookingSound, _delay=0.2, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
		elseif akFurniture.HasKeywordString("CraftingTanningRack")
			SoundCoolTimePlay(SayActionTanningSound, _delay=0.2, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
		elseif akFurniture.HasKeywordString("CraftingSmithingForge") || akFurniture.HasKeywordString("CraftingTanningRack") || akFurniture.HasKeyWordString("CraftingSmelter") || akFurniture.HasKeywordString("CraftingSmithingSharpeningWheel")		
			SoundCoolTimePlay(SayActionSmithingSound, _delay=0.2, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
		elseif akFurniture.HasKeywordString("CraftingSmithingArmorTable") ||  akFurniture.HasKeyWordString("WICraftingAlchemy") || akFurniture.HasKeyWordString("WICraftingEnchanting") || akFurniture.HasKeywordString("BYOHCarpenterTable")
			SoundCoolTimePlay(SayActionSmithingSound, _delay=0.2, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
		elseif akFurniture.HasKeyWordString("FurnitureWoodChoppingBlock") || akFurniture.HasKeyWordString("isPickaxeFloor") || akFurniture.HasKeyWordString("isPickaxeWall")	
			SoundCoolTimePlay(SayActionChoppingSound, _delay=0.2, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
		elseif akFurniture.hasKeywordString("ActivatorLever") || akFurniture.hasKeywordString("ActivatorPillar") || akFurniture.hasKeywordString("ActivatorChain")
			SoundCoolTimePlay(SayActionChoppingSound, _delay=0.2, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
		else
			SoundCoolTimePlay(SayActionSitDefaultSound, _delay=0.5, _coolTime=3.0, _mapIdx=1, _mapCoolTime=3.0)		
		endif
	elseif furnitureType == 0 || furnitureType == 2  ; sit
		if pcVoiceMCM.isNaked
			SoundCoolTimePlay(SayStateNakedSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=30)
		elseif pcVoiceMCM.isDrunken
			SoundCoolTimePlay(SayStateNakedSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=30)
		else
			if pcVoiceMCM.wornArmor && pcVoiceMCM.wornArmor.HasKeyWordString("ClothingSlave")								
				SoundCoolTimePlay(SayStatePoorClothesSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=30)
			elseif pcVoiceMCM.wornArmor && (pcVoiceMCM.wornArmor.HasKeyWordString("ClothingSlutty") || pcVoiceMCM.wornArmor.HasKeyWordString("SOS_Revealing") || pcVoiceMCM.wornArmor.HasKeyWordString("ClothingSexy") || pcVoiceMCM.wornArmor.HasKeyWordString("ClothingBeauty"))
				SoundCoolTimePlay(SayStateUncomfortClothesSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=30)
			elseif pcVoiceMCM.wornBoots && pcVoiceMCM.wornBoots.HasKeyWordString("ArmorHeels")
				SoundCoolTimePlay(SayStateUncomfortBootsSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=30)
			elseif pcVoiceMCM.isBareFoot
				SoundCoolTimePlay(SayStateBareFeetSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=30)
			else
				if Utility.randomInt(0, 3) >= 1
					SoundCoolTimePlay(SayActionSitSound, _delay=0.5, _coolTime=3.0, _mapIdx=2, _mapCoolTime=15)
				else 
					SoundCoolTimePlay(SayMonologueSound, _delay=0.5, _coolTime=7.0, _mapIdx=2, _mapCoolTime=15)
				endif
			endif	
		endif
	elseif  furnitureType == 3 ; sleep
		SoundCoolTimePlay(SayActionSitDefaultSound, _delay=0.5, _coolTime=3.0, _mapIdx=1, _mapCoolTime=3.0)
	endif
EndEvent

; Event that is triggered when this actor leaves the furniture
Event OnGetUp(ObjectReference akFurniture)	
	pcVoiceMCM.isSit = false
EndEvent

;
;	Menu
;
Event OnMenuOpen(string menuName)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	if menuName == "MapMenu"		
		SoundPlay(SayActionTravelSound, _volume=0.7)
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
			SoundPlay(SayActionSleepSound, _volume=0.7)
		else 
			SoundPlay(SayActionWaitSound, _volume=0.7)
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
function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0, string _express="happy")
	if pcVoiceMCM.enableActionSound == false || playerRef.IsSwimming() || playerRef.IsInCombat()
		return
	endif 	
	
	float currentTime = Utility.GetCurrentRealTime()
	; pcVoiceMCM.log("currentTime " + currentTime + ", colTime " + pcVoiceMCM.soundCoolTime + " in action")
	if currentTime > pcVoiceMCM.soundCoolTime && currentTime > coolTimeMap[_mapIdx]		 			
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime + _delay

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

ImmersivePcVoiceMCM property pcVoiceMCM Auto

Actor property playerRef Auto

; action
Sound property SayActionTorchSound Auto
Sound property SayActionUnderWaterSound Auto
Sound property SayActionLockDoorSound Auto
Sound property SayActionMoveLeverSound Auto
Sound property SayActionHarvestedSound Auto			
Sound property SayActionBookReadSound Auto			
Sound property SayActionDragonSoulSound Auto
Sound property SayActionJumpUpSound Auto
; Sound property SayActionLevelUpSound Auto
Sound property SayActionSitSound Auto
Sound property SayActionSitDefaultSound Auto
Sound property SayActionSleepSound Auto
Sound property SayActionGoToBedSound Auto
Sound property SayActionWaitSound Auto
Sound property SayActionTravelSound Auto
Sound property SayActionRidingSound Auto
Sound property SayActionSneakSound Auto
Sound property SayActionSuccessSound Auto
Sound property SayActionFoundDeadBodySound Auto
Sound property SayActionSearchDeadBodySound Auto
Sound property SayActionSearchDeadCreatureSound Auto

Sound property SayActionCookingSound Auto
Sound property SayActionSmithingSound Auto
Sound property SayActionChoppingSound Auto
Sound property SayActionTanningSound Auto

Sound property SayActionRitualSound Auto
Sound property SayActionRitualMaraSound Auto
Sound property SayActionRitualTalosSound Auto
Sound property SayActionRitualDebellaSound Auto

; state
Sound property SayStateDrunkenSound Auto
Sound property SayStateNakedSound Auto
Sound property SayStateBareFeetSound Auto
Sound property SayStatePoorClothesSound Auto
Sound property SayStateUncomfortClothesSound Auto
Sound property SayStateUncomfortBootsSound Auto

; drink
Sound property SayDrinkAlcoholSound Auto
Sound property SayDrinkPotionSound Auto

; monologue
Sound property SayMonologueSound Auto		

; heavy weight armor sound
Sound property SoundActionHeavyArmorLeftStep Auto
Sound property SoundActionHeavyArmorRightStep Auto

Sound property SoundActionRobeLeftStep Auto
Sound property SoundActionRobeRightStep Auto

Sound property SoundActionCloak Auto

; etc
Sound property SayBgSneakModeSound Auto
Sound property SayDefaultSound Auto