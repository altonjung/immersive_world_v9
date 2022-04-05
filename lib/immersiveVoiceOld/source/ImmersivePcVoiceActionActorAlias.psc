scriptname ImmersivePcVoiceActionActorAlias extends ReferenceAlias

Actor  controlActor
ObjectReference overHairRef
ObjectReference lastOverHairContainerRef

float[] coolTimeMap

; int    SneakSoundId
; int	   SneakStepById
; int    SneakBgSoundId
; float  sneakingBgSoundVolume

int    sneakStepCount

int    underWaterSoundId
float  underWaterSoundVolume

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

bool   isharvest
bool   isLockingMode

int    footstepCount
Event OnInit()
	; initMenu()	
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

; function initMenu()	
; 	; UnregisterForAllMenus()
; 	RegisterForMenu("MapMenu")
; 	RegisterForMenu("Journal Menu")
; 	RegisterForMenu("ContainerMenu")
; 	RegisterForMenu("Lockpicking Menu")
; 	RegisterForMenu("Sleep/Wait Menu")
; 	RegisterForMenu("BarterMenu")
; 	RegisterForMenu("Crafting Menu")
; 	RegisterForMenu("Training Menu")
; 	RegisterForMenu("Book Menu")
; 	RegisterForMenu("StatsMenu")
; endFunction

function registerAction ()	
	regAnimation()
endFunction

function setup()
	lockPickForm		   = Game.GetFormFromFile(0x000000A, "Skyrim.esm") as Form
endFunction

function init ()		
	UnregisterForMenu("MapMenu")
	UnregisterForMenu("Journal Menu")
	UnregisterForMenu("ContainerMenu")
	UnregisterForMenu("Lockpicking Menu")
	UnregisterForMenu("Sleep/Wait Menu")
	UnregisterForMenu("BarterMenu")
	UnregisterForMenu("Crafting Menu")
	UnregisterForMenu("Training Menu")
	UnregisterForMenu("Book Menu")
	UnregisterForMenu("StatsMenu")

	RegisterForMenu("MapMenu")
	RegisterForMenu("Journal Menu")
	RegisterForMenu("ContainerMenu")
	RegisterForMenu("Lockpicking Menu")
	RegisterForMenu("Sleep/Wait Menu")
	RegisterForMenu("BarterMenu")
	RegisterForMenu("Crafting Menu")
	RegisterForMenu("Training Menu")
	RegisterForMenu("Book Menu")
	RegisterForMenu("StatsMenu")

	underWaterSoundId = 0
	underWaterSoundVolume = 0.0

	sneakStepCount = 0

	overHairRef = None	
	controlActor = None

	runningCoolTimeExpress = "happy"
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	footstepCount = 0
	isharvest = false
	isLockingMode = false

	coolTimeMap = new float[10] 
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")
	; RegisterForControl("Forward")
	; RegisterForControl("Backward")

	; sprint
	RegisterForAnimationEvent(playerRef, "FootSprintLeft")	; foot left
	; RegisterForAnimationEvent(playerRef, "FootSprintRight")	; foot right	

	; voice cast
	RegisterForAnimationEvent(playerRef, "BeginCastVoice")

	; ride
	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseMount")
	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseDismount")	
	RegisterForAnimationEvent(playerRef, "DragonMountEnter")
	RegisterForAnimationEvent(playerRef, "DragonMountExitOut")

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

	if control == "Activate"
		overHairRef = Game.GetCurrentCrosshairRef()
		If overHairRef != none
			int _type = overHairRef.getType()
			; pcVoiceMCM.Log("activator " + _type)

			if _type == 61  ; reference
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
				if akFurniture 
					if akFurniture.hasKeywordString("ActivatorLever") || akFurniture.hasKeywordString("ActivatorPillar")
						SoundPlay(SayActionMoveLeverSound)
						return
					elseif akFurniture.hasKeywordString("ActivatorChain")
						SoundPlay(SayActionMoveChainSound)
						return 
					endif 
				endif
			elseif _type == 43 || _type == 62
				Actor _akActor = overHairRef as Actor
				if _akActor && _akActor.isDead()
					float _curTime = Utility.GetCurrentRealTime()
					if _curTime > coolTimeMap[3]
						if _akActor.GetKiller() != playerRef
							if _akActor.HasKeyWordString("ActorTypeNPC")
								SoundCoolTimePlay(SayActionFoundDeadBodySound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=30.0, _express="sad")
							else 
								SoundCoolTimePlay(SayActionCheckDeadBodySound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=30.0, _express="sad")
								; PlayerRef.MoveTo(_akActor, 5.0 * Math.Sin(_akActor.GetAngleZ()), 5.0 * Math.Cos(_akActor.GetAngleZ()), 0)
								; SoundCoolTimePlay(SayActionCheckDeadBodySound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=30.0, _express="sad")

								; if _randomValue == 0
								;  	Debug.SendanimationEvent(playerRef, "ImmCheckBodyByFoot")
								; 	Utility.Wait(3.0)
								; 	Debug.SendanimationEvent(PlayerRef, "IdleForceDefaultState")
								; endif
							endif
						else
							; check dead body reaction
							if _akActor.HasKeyWordString("ActorTypeNPC")
								SoundCoolTimePlay(SayActionSearchDeadBodySound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=30.0, _express="happy")
							else
								SoundCoolTimePlay(SayActionSearchDeadCreatureSound, _volume=0.5, _delay=0.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=30.0, _express="angry")
							endif
						endif
					endif
				endif		
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
		if !playerRef.IsInCombat() && !pcVoiceMCM.isWeaponDraw
			if sneakStepCount == 0
				sneakStepCount += 1
				SoundCoolTimePlay(SayActionSneakSound, _delay=0.5, _volume=0.3, _coolTime = 5.5)
			else 
				SoundCoolTimePlay(SayActionSneakStepBySound, _volume=0.3, _coolTime = 4.0)
			endif 
		endif
	elseif asEventName == "tailMTIdle"
		; sneak -> stand idle
		sneakStepCount = 0			
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
		isGlobalMounted.setValue(1)
		SoundCoolTimePlay(SayActionRidingSound, _delay=0.2, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5)
	elseif asEventName == "SoundPlay.NPCHorseDismount"	|| asEventName == "DragonMountExitOut"
		isGlobalMounted.setValue(0)
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
		if akEffect.HasKeyWordString("StoneDoomEffect")		; doom
			if akEffect.HasKeyWordString("StoneDoomMaraEffect")		; doom
				SoundCoolTimePlay(SayActionRitualMaraSound,_delay=0.2, _coolTime=3.0)
			elseif akEffect.HasKeyWordString("StoneDoomTalosEffect")		; doom
				SoundCoolTimePlay(SayActionRitualMaraSound,_delay=0.2, _coolTime=3.0)
			elseif akEffect.HasKeyWordString("StoneDoomDebellaEffect")		; doom
				SoundCoolTimePlay(SayActionRitualDebellaSound,_delay=0.2, _coolTime=3.0)
			else 
				SoundCoolTimePlay(SayActionRitualSound, _delay=0.5, _coolTime=3.0)

				; int _cameraMode = Game.GetCameraState()
				; Game.ForceThirdPerson()

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

				; if _cameraMode == 0 ; firstPerson
				; 	Game.ForceFirstPerson()
				; endif
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

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if isharvest == false && akBaseItem.hasKeywordString("ValuableItem")
		SoundCoolTimePlay(SayActionHarvestedPreciousSound, _delay=0.5, _coolTime=3.0, _mapIdx=6, _mapCoolTime=2.0)		
	endif
	isharvest = false
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	if isLockingMode
		if akBaseItem == lockPickForm && aiItemCount == 1
			utility.waitMenuMode(0.5)
			SoundCoolTimePlay(SayActionSneakTrySound, _coolTime=2.0, _mapIdx=7, _mapCoolTime=2.0)
		endif
	endif 
EndEvent

Event OnItemHarvested(Form akProduce)
	if !pcVoiceMCM.isGameRunning || playerRef.IsInCombat()
		return 
	endif	

	isharvest = true
	if akProduce.hasKeywordString("ValuableItem")
		SoundCoolTimePlay(SayActionHarvestedPreciousSound, _delay=0.5, _coolTime=2.0, _mapIdx=7, _mapCoolTime=2.0)				
	else 
		SoundCoolTimePlay(SayActionHarvestedSound, _delay=0.5, _coolTime=2.0, _mapIdx=7, _mapCoolTime=2.0)
	endif
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
		if akFurniture.HasKeyWordString("FurnitureWoodChoppingBlock") || akFurniture.HasKeyWordString("isPickaxeFloor") || akFurniture.HasKeyWordString("isPickaxeWall")	
			SoundCoolTimePlay(SayActionChoppingSound, _delay=0.2, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
		endif
	elseif furnitureType == 0 || furnitureType == 2  ; sit
		if pcVoiceMCM.isNaked 
			SoundCoolTimePlay(SayStateNakedSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=15)
		elseif pcVoiceMCM.isDrunken
			SoundCoolTimePlay(SayStateNakedSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=15)
		else
			if pcVoiceMCM.wornArmor && pcVoiceMCM.wornArmor.HasKeyWordString("ClothingSlave")								
				SoundCoolTimePlay(SayStatePoorClothesSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=15)
			elseif pcVoiceMCM.wornArmor && (pcVoiceMCM.wornArmor.HasKeyWordString("ClothingSlutty") || pcVoiceMCM.wornArmor.HasKeyWordString("ClothingSexy"))
				SoundCoolTimePlay(SayStateUncomfortClothesSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=15)
			elseif pcVoiceMCM.wornBoots && pcVoiceMCM.wornBoots.HasKeyWordString("ArmorHeels")
				SoundCoolTimePlay(SayStateUncomfortBootsSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=15)
			elseif pcVoiceMCM.isBareFoot
				SoundCoolTimePlay(SayStateBareFeetSound, _delay=0.5, _coolTime=5.0, _mapIdx=2, _mapCoolTime=15)
			else
				if Utility.randomInt(1, 5) == 1
					SoundCoolTimePlay(SayMonologueSound, _delay=0.5, _coolTime=7.0, _mapIdx=2, _mapCoolTime=15)					
				else 
					if akFurniture.HasKeyWordString("isThroneSit")
						SoundCoolTimePlay(SayActionSitThroneSound, _delay=0.5, _coolTime=3.0, _mapIdx=2, _mapCoolTime=15)
					else 
						SoundCoolTimePlay(SayActionSitSound, _delay=0.5, _coolTime=3.0, _mapIdx=2, _mapCoolTime=15)
					endif
				endif
			endif	
		endif
	elseif  furnitureType == 3 ; sleep
		if pcVoiceMCM.isInField 
			SoundCoolTimePlay(SayActionGoToRollBedSound, _delay=0.5, _coolTime=3.0, _mapIdx=1, _mapCoolTime=3.0)
		else 
			SoundCoolTimePlay(SayActionGoToBedSound, _delay=0.5, _coolTime=3.0, _mapIdx=1, _mapCoolTime=3.0)
		endif
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
	; pcVoiceMCM.log("menu " + menuName)
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
		isLockingMode = true
	elseif menuName == "Sleep/Wait Menu"
		utility.waitMenuMode(0.2)
		if playerRef.GetSleepState() == 3
			SoundPlay(SayActionSleepSound, _volume=0.7)
		else 
			SoundPlay(SayActionWaitSound, _volume=0.7)
		endif	
	elseif menuName == "BarterMenu"
		utility.waitMenuMode(0.5)
		SoundCoolTimePlay(SayActionBarterSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=2.0)
	elseif menuName == "Crafting Menu"
		ObjectReference _furniture = playerRef.GetFurnitureReference()
		if _furniture
			utility.waitMenuMode(0.2)
			Furniture _akFurniture = _furniture.GetBaseObject() as Furniture		
			if _akFurniture.HasKeywordString("CraftingCookpot")				
				SoundCoolTimePlay(SayActionCookingSound, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
			elseif _akFurniture.HasKeywordString("CraftingTanningRack")
				SoundCoolTimePlay(SayActionTanningSound, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
			elseif _akFurniture.HasKeywordString("CraftingSmithingSharpeningWheel")
				SoundCoolTimePlay(SayActionSharpingSound, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
			elseif _akFurniture.HasKeywordString("CraftingSmithingForge") || _akFurniture.HasKeyWordString("CraftingSmelter")
				SoundCoolTimePlay(SayActionSmithingSound, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
			elseif _akFurniture.HasKeywordString("CraftingSmithingArmorTable") ||  _akFurniture.HasKeyWordString("WICraftingAlchemy") || _akFurniture.HasKeyWordString("WICraftingEnchanting") || _akFurniture.HasKeywordString("BYOHCarpenterTable")
				SoundCoolTimePlay(SayActionSmithingSound, _coolTime=3.0, _mapIdx=8, _mapCoolTime=3.0)
			endif
		endif
	elseif menuName == "Training Menu"
		utility.waitMenuMode(0.5)
		SoundCoolTimePlay(SayActionTrainingSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=2.0)
	elseif menuName == "Book Menu"
		utility.waitMenuMode(0.5)
		SoundCoolTimePlay(SayActionBookReadSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=2.0)
	elseif menuName == "StatsMenu"
		utility.waitMenuMode(0.5)
		SoundCoolTimePlay(SayActionStatSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=2.0)
	endif
endEvent

Event OnMenuClose(string menuName)
	if menuName == "Sleep/Wait Menu"
		Game.FadeOutGame(false, true, 0.5, 3.0)
	elseif menuName == "Lockpicking Menu"
		isLockingMode = false		
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
	if pcVoiceMCM.enableActionSound == false || playerRef.IsSwimming() || playerRef.IsInCombat()
		return
	endif 
	
	Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
endFunction

function SoundVolumeUp(int _soundId, float _volume = 0.1)	
	if pcVoiceMCM.enableActionSound == false || playerRef.IsSwimming() || playerRef.IsInCombat()
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
Sound property SayActionMoveChainSound Auto
Sound property SayActionHarvestedSound Auto
Sound property SayActionHarvestedPreciousSound Auto
Sound property SayActionBookReadSound Auto			
Sound property SayActionDragonSoulSound Auto
Sound property SayActionJumpUpSound Auto
; Sound property SayActionLevelUpSound Auto
Sound property SayActionSitSound Auto
Sound property SayActionSitThroneSound Auto
Sound property SayActionSitDefaultSound Auto
Sound property SayActionSleepSound Auto
Sound property SayActionGoToBedSound Auto
Sound property SayActionGoToRollBedSound Auto
Sound property SayActionWaitSound Auto
Sound property SayActionTravelSound Auto
Sound property SayActionRidingSound Auto
Sound property SayActionSneakSound Auto
Sound property SayActionSneakStepBySound Auto
; Sound property SayActionSneakBgSound Auto
Sound property SayActionSneakTrySound Auto
Sound property SayActionSuccessSound Auto
Sound property SayActionCheckDeadBodySound Auto
Sound property SayActionFoundDeadBodySound Auto
Sound property SayActionSearchDeadBodySound Auto
Sound property SayActionSearchDeadCreatureSound Auto

Sound property SayActionCookingSound Auto
Sound property SayActionSmithingSound Auto
Sound property SayActionChoppingSound Auto
Sound property SayActionTanningSound Auto
Sound property SayActionSharpingSound Auto
Sound property SayActionTrainingSound Auto
Sound property SayActionBarterSound Auto
Sound property SayActionStatSound Auto

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
Sound property SayDefaultSound Auto

FORM property  lockPickForm auto hidden

GlobalVariable Property isGlobalMounted Auto