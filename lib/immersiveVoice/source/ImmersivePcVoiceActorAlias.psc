scriptname ImmersivePcVoiceActorAlias extends ReferenceAlias

Actor actorRef 

int  BgPickingModeSoundId
int  BgSneakModeSoundId

int  nakedCount 

string menuAction
string visitAction
bool   loadingComplete
bool   isCombat
bool   isNaked
float[] lazyPlayTimeMap
int[]   soundIdMap

int   breathSoundId
int   breathLowSoundId
Event OnPlayerLoadGame()	
	init()
	; if loadingComplete == false
	; 	regAnimation()
	; else 		
	; 	actorRef = GetActorReference()
	; 	Sound.SetInstanceVolume(SayHelloSound.Play(actorRef), 0.8)	
	; endif
EndEvent

event OnInit() 
	Setup()
endEvent

function Setup ()
	init()
	
	UnregisterForMenu("BarterMenu")
	UnregisterForMenu("MapMenu")
	UnregisterForMenu("ContainerMenu")
	UnregisterForMenu("Lockpicking Menu")

	UnregisterForSleep()
	UnregisterForUpdate()
	UnregisterForUpdateGameTime()

	RegisterForMenu("BarterMenu")
	RegisterForMenu("MapMenu")
	RegisterForMenu("ContainerMenu")
	RegisterForMenu("Lockpicking Menu")
	RegisterForSleep()
	RegisterForSingleUpdateGameTime(1.0)	; 1시간 마다 onUpdate 이벤트 발생
endFunction

function init ()
	BgSneakModeSoundId = 0
	BgPickingModeSoundId = 0
	breathSoundId = 0
	breathLowSoundId = 0
	nakedCount = 0
	menuAction = ""
	visitAction = ""
	isCombat = false
	loadingComplete = false
	isNaked = false
	lazyPlayTimeMap = new float[50]
	soundIdMap = new int[50]
endFunction

function regAnimation ()
	LOG("regAnimation")
	actorRef = GetActorReference()

	loadingComplete = RegisterForAnimationEvent(actorRef, "SoundPlay.NPCHorseMount") 	

	RegisterForAnimationEvent(actorRef, "DragonMountEnter") 		

	RegisterForAnimationEvent(actorRef, "JumpUp")
	RegisterForAnimationEvent(actorRef, "JumpFall")
	
	; sneak
	RegisterForAnimationEvent(actorRef, "tailSneakIdle") 			; start in standing
	RegisterForAnimationEvent(actorRef, "tailSneakLocomotion") 		; start in moving
	RegisterForAnimationEvent(actorRef, "tailMTIdle") 				; end in sprint or sneak
	RegisterForAnimationEvent(actorRef, "tailCombatIdle") 			; end
	RegisterForAnimationEvent(actorRef, "tailCombatLocomotion") 	; end

	; sprint
	RegisterForAnimationEvent(actorRef, "FootSprintRight") 		; end

	; swimming	
	RegisterForAnimationEvent(actorRef, "SoundPlay.FSTSwimSwim")	; start
	RegisterForAnimationEvent(actorRef, "MTState") 				; end
		
	; magic 
	RegisterForAnimationEvent(actorRef, "BeginCastRight") 	
	RegisterForAnimationEvent(actorRef, "BeginCastLeft") 	

	; weapon/bow
	RegisterForAnimationEvent(actorRef, "weaponSwing") 	
	RegisterForAnimationEvent(actorRef, "weaponLeftSwing")	

	RegisterForAnimationEvent(actorRef, "bowDraw") 	
	RegisterForAnimationEvent(actorRef, "bowRelease")	

	; weapon
	RegisterForAnimationEvent(actorRef, "weaponDraw") 	
	RegisterForAnimationEvent(actorRef, "weaponSheathe")	

	; bow
	RegisterForAnimationEvent(actorRef, "BowDraw")	
	RegisterForAnimationEvent(actorRef, "BowRelease")

	actorRef = GetActorReference()
	Sound.SetInstanceVolume(SayHelloSound.Play(actorRef), 0.8)	
endFunction

int function SoundLazyPlay(Sound _sound, int _mapIdx, float _lazyTime = 2.0, float _volumn = 0.8)
	float currentTime = Utility.GetCurrentRealTime()
	float lazyPlayTime = lazyPlayTimeMap[_mapIdx]

	if currentTime - lazyPlayTime > _lazyTime
		soundIdMap[_mapIdx] = _sound.Play(actorRef)
		Sound.SetInstanceVolume(soundIdMap[_mapIdx], _volumn)
		lazyPlayTimeMap[_mapIdx] = currentTime
	endif
	return soundIdMap[_mapIdx]
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)

	if asEventName == "weaponDraw"
		isCombat = true
		SoundLazyPlay(SayCombatStartSound, 20)
		Log("weaponDraw ")
	elseif asEventName == "weaponSheathe"
		if isCombat == true
			SoundLazyPlay(SayCombatEndSound, 21)
			isCombat = false
		endif
		Log("weaponSheathe ")
		
	elseif asEventName == "weaponLeftSwing" || asEventName == "weaponSwing"
		bool pAttack = actorRef.GetAnimationVariableBool("bAllowRotation")

		if pAttack 
			Sound.SetInstanceVolume(SayCombatNormalAttackSound.Play(actorRef), 0.8)
		else 
			Sound.SetInstanceVolume(SayCombatPowerAttackSound.Play(actorRef), 0.8)
		endif		
		Log("Weapon Swing " + pAttack)
	elseif asEventName == "BeginCastRight" || asEventName == "BeginCastLeft"		
		Spell magicSpell = akSource.GetBaseObject() as spell
		MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

		int idxx=0
		while idxx < magicEffects.length
			int castingType = magicEffects[idxx].GetCastingType()
			int deliveryType = magicEffects[idxx].GetDeliveryType()

			if magicEffects[idxx].HasKeyWordString("RitualSpellEffect")
				if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
					Log("Magic Cast from RitualSpellEffect and MagicDamageFire")
					Sound.SetInstanceVolume(SayMagicFireRitualSound.Play(actorRef), 0.8)
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
					Log("Magic Cast from RitualSpellEffect and MagicDamageFrost")
					Sound.SetInstanceVolume(SayMagicFrostRitualSound.Play(actorRef), 0.8)
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
					Log("Magic Cast from RitualSpellEffect and MagicDamageLight")
					Sound.SetInstanceVolume(SayMagicLightRitualSound.Play(actorRef), 0.8)
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
					Log("Magic Cast from RitualSpellEffect and MagicDamageShock")
					Sound.SetInstanceVolume(SayMagicShockRitualSound.Play(actorRef), 0.8)
				elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
					Log("Magic Cast from RitualSpellEffect and MagicDamagePoison")
					Sound.SetInstanceVolume(SayMagicPoisonRitualSound.Play(actorRef), 0.8)
				else 
					Log("Magic Cast from RitualSpellEffect")
				endif 
				return 
			elseif magicEffects[idxx].HasKeyWordString("MagicDamageFire")
				Log("Magic Cast from MagicDamageFire")
				Sound.SetInstanceVolume(SayMagicFireCastSound.Play(actorRef), 0.8)
				return 
			elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
				Sound.SetInstanceVolume(SayMagicFrostCastSound.Play(actorRef), 0.8)
				Log("Magic Cast from MagicDamageFrost")
				return 
			elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
				Sound.SetInstanceVolume(SayMagicLightCastSound.Play(actorRef), 0.8)
				Log("Magic Cast from MagicDamageLight")
				return 	
			elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
				Sound.SetInstanceVolume(SayMagicShockCastSound.Play(actorRef), 0.8)
				Log("Magic Cast from MagicDamageShock")
				return 			
			elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
				Sound.SetInstanceVolume(SayMagicPoisonCastSound.Play(actorRef), 0.8)
				Log("Magic Cast from MagicDamagePoison")
				return 									
			elseif magicEffects[idxx].HasKeyWordString("MagicRestoreHealth")
				Log("Magic Cast from MagicRestoreHealth")
				if deliveryType == 0  ; self
					Sound.SetInstanceVolume(SayMagicHealConcentrationSound.Play(actorRef), 0.8)
				else 				  ; teammate
					Sound.SetInstanceVolume(SayMagicHealCastSound.Play(actorRef), 0.8)
				endif 
				return 					
			elseif magicEffects[idxx].HasKeyWordString("MagicTurnUndead")
				Sound.SetInstanceVolume(SayMagicUndeadSound.Play(actorRef), 0.8)
				Log("Magic Cast from MagicTurnUndead")
				return 									
			elseif magicEffects[idxx].HasKeyWordString("MagicSummonShock") || magicEffects[idxx].HasKeyWordString("MagicSummonFrost") || magicEffects[idxx].HasKeyWordString("MagicSummonLight")
				Sound.SetInstanceVolume(SayMagicSummonSound.Play(actorRef), 0.8)
				Log("Magic Cast from MagicSummon")
				return 												
			endif
			idxx += 1
		endwhile

	elseif asEventName == "FootSprintRight"
		float _stamina = ActorRef.GetActorValuePercentage("Stamina")
		if  0.2 < _stamina && _stamina < 0.4
			breathSoundId = SoundLazyPlay(SayActionBreathSound, 11, 22, 0.8)
		elseif  0.2 > _stamina	
			if breathSoundId != 0
				Sound.StopInstance(breathSoundId)
				breathSoundId = 0
			endif				
			breathLowSoundId = SoundLazyPlay(SayActionBreathLowSound, 12, 22, 0.8)			
		else 
			if breathSoundId != 0
				Sound.StopInstance(breathSoundId)
				breathSoundId = 0
			endif
			if breathLowSoundId != 0
				Sound.StopInstance(breathLowSoundId)
				breathLowSoundId = 0
			endif			
		endif
	elseif asEventName == "bowDraw"
		Sound.SetInstanceVolume(SayCombatBowDrawSound.Play(actorRef), 0.5)
	elseif asEventName == "bowRelease"
		Sound.SetInstanceVolume(SayCombatBowReleaseSound.Play(actorRef), 0.5)
	elseif asEventName == "tailSneakIdle"
		if BgSneakModeSoundId == 0
			BgSneakModeSoundId = SayBgSneakModeSound.Play(actorRef)
			Sound.SetInstanceVolume(BgSneakModeSoundId, 0.3)	
		endif
	elseif asEventName == "tailMTIdle"
		; sneak -> stand idle
		if BgSneakModeSoundId != 0
			Sound.StopInstance(BgSneakModeSoundId)
			BgSneakModeSoundId = 0
		endif
		menuAction = ""
	elseif asEventName == "SoundPlay.NPCHorseMount"	
		Sound.SetInstanceVolume(SayActionRidingSound.Play(actorRef), 0.6)
		Log("horseMount ")
	endif
	
	; Log("OnAnimationEvent " + asEventName)
endEvent

Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	if akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreHealth"); restore health
		SoundLazyPlay(SayDefaultSound, 49)
		Log("Restore Health potion")
	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreMagicka"); restore magicka
		SoundLazyPlay(SayDefaultSound, 49)
		Log("Restore Magicka potion")
	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreStamina"); restore stamina	
		SoundLazyPlay(SayDefaultSound, 49)
		Log("Restore Stamina potion")
	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure poison
		SoundLazyPlay(SayDefaultSound, 49)
		Log("Cure poison")
	elseif akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
		SoundLazyPlay(SayDefaultSound, 49)
		Log("Drink")
	endif
EndEvent

Event OnBookRead(Book akBook)
	SoundLazyPlay(SayActionBookReadSound, 2)
	Log("OnBookRead")
EndEvent

Event OnDragonSoulGained(float afSouls)
	SoundLazyPlay(SayActionDragonSoulSound, 3)
	Log("OnDragonSoulGained")
EndEvent

Event OnItemHarvested(Form akProduce)
	SoundLazyPlay(SayActionHarvestedSound, 1, 3.0, 0.5)
	Log("OnItemHarvested")
EndEvent

Event OnLevelIncrease(int aiLevel)
	Sound.SetInstanceVolume(SayLevelUpSound.Play(actorRef), 0.8)
	Log("OnLevelIncrease")
EndEvent

Event OnWeatherChange(Weather akOldWeather, Weather akNewWeather)
	if Weather.GetSkyMode() == 3
		int weatherType = akNewWeather.GetClassification()	
		; -1 - No classification
		;  0 - Pleasant
		;  1 - Cloudy
		;  2 - Rainy
		;  3 - Snow
		if weatherType == 0
			Sound.SetInstanceVolume(SayWeatherClearSound.Play(actorRef), 0.8)
		elseif weatherType == 1
			Sound.SetInstanceVolume(SayWeatherCloudySound.Play(actorRef), 0.8)
		elseif weatherType == 2
			Sound.SetInstanceVolume(SayWeatherRainySound.Play(actorRef), 0.8)
		elseif weatherType == 3
			Sound.SetInstanceVolume(SayWeatherSnowSound.Play(actorRef), 0.8)
		endif 		
	endif

	Log("OnWeatherChange ")
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if abHitBlocked
		SoundLazyPlay(SayCombatBlockSound, 24, 4.0)
	elseif abPowerAttack || abSneakAttack
		SoundLazyPlay(SayCombatCriticalHitSound, 23, 4.0)		
		if isNaked ; 30% 패널티
			actorRef.ForceActorValue("Health", actorRef.GetActorValue("Health") - actorRef.GetActorValue("Health") / 30.0)
		endif
	else
		SoundLazyPlay(SayCombatNormalHitSound, 22, 4.0)		
		if isNaked ; 15% 패널티						
			actorRef.ForceActorValue("Health", actorRef.GetActorValue("Health") - actorRef.GetActorValue("Health") / 15.0)
		endif 
	endif
EndEvent

; Event that is triggered when this actor sits in the furniture
Event OnSit(ObjectReference akFurniture)	
	
	if akFurniture.HasKeyWordString("CraftingCookpot")		
		log("cooking")
		SoundLazyPlay(SayDefaultSound, 49)
	elseif akFurniture.HasKeyWordString("CraftingSmithingForge")
		SoundLazyPlay(SayDefaultSound, 49)
		log("forge")
	elseif akFurniture.HasKeyWordString("CraftingTanningRack")
		SoundLazyPlay(SayDefaultSound, 49)
		log("TanningRack")		
	elseif akFurniture.HasKeyWordString("CraftingSmithingArmorTable")
		SoundLazyPlay(SayDefaultSound, 49)
		log("Smithing ArmorTable")		
	elseif akFurniture.HasKeyWordString("CraftingSmithingSharpeningWheel")
		SoundLazyPlay(SayDefaultSound, 49)
		log("Smithing Sharpen")		
	elseif akFurniture.HasKeyWordString("BYOHCarpenterTable")
		SoundLazyPlay(SayDefaultSound, 49)
		log("carpenter")
	elseif akFurniture.HasKeyWordString("isGrainMill")
		SoundLazyPlay(SayDefaultSound, 49)
		log("grainMill")
	elseif akFurniture.HasKeyWordString("CraftingSmelter")
		SoundLazyPlay(SayDefaultSound, 49)
		log("smelter")		
	elseif akFurniture.HasKeyWordString("WICraftingAlchemy")		
		SoundLazyPlay(SayDefaultSound, 49)
		log("alchemy")		
	elseif akFurniture.HasKeyWordString("WICraftingEnchanting")		
		SoundLazyPlay(SayDefaultSound, 49)
		log("enchanting")				
	elseif akFurniture.HasKeyWordString("FurnitureWoodChoppingBlock")		
		SoundLazyPlay(SayDefaultSound, 49)
		log("woodChopping")		
	elseif akFurniture.HasKeyWordString("isPickaxeFloor") || akFurniture.HasKeyWordString("isPickaxeWall")
		SoundLazyPlay(SayDefaultSound, 49)
		log("pickaxe")
	else 
		SoundLazyPlay(SayActionSitSound, 0)
	endif

	Log("OnSit")
EndEvent
	
; Received when the player sleeps. Start and desired end time are in game time days (after registering)
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	Sound.SetInstanceVolume(SayActionSleepBeginSound.Play(actorRef), 0.8)
	Log("OnSleepStart")
EndEvent

Event OnSleepStop(bool abInterrupted)
	SoundLazyPlay(SayDefaultSound, 49)
EndEvent

; Event that is triggered when this actor finishes dying
Event OnDeath(Actor akKiller)
	Sound.SetInstanceVolume(SayCombatDeathEndSound.Play(actorRef), 0.8)
	Log("OnDeath")
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	Log("OnLocationChange")

	if menuAction == "locking"
		Sound.SetInstanceVolume(SayActionSuccessSound.Play(actorRef), 0.5)
		menuAction = ""
	else 		

	; 0 - No sky (SM_NONE)
	; 1 - Interior (SM_INTERIOR)
	; 2 - Skydome only (SM_SKYDOME_ONLY)
	; 3 - Full sky (SM_FULL)
		
		int skyMode = Weather.GetSkyMode()

		if skyMode < 3; interior
			if akNewLoc.HasKeyWordString("LocTypeDwelling")
				if akNewLoc.HasKeyWordString("LocTypeHouse")
					if akNewLoc.HasKeyWordString("LocTypePlayerHouse")
						; player house
						Sound.SetInstanceVolume(SayLocationPlayerHomeSound.Play(actorRef), 0.8)
						Log("Home Visit")
					else 
						; other house
						Sound.SetInstanceVolume(SayLocationNormalHomeSound.Play(actorRef), 0.8)
						Log("other Home Visit")
					endif
				endif
			elseif akNewLoc.HasKeyWordString("LocTypeInn")
				Sound.SetInstanceVolume(SayLocationInnSound.Play(actorRef), 0.8)
				Log("Inn Visit")
			elseif akNewLoc.HasKeyWordString("LocTypeStore")
				Sound.SetInstanceVolume(SayLocationStoreSound.Play(actorRef), 0.8)
			elseif akNewLoc.HasKeyWordString("LocTypeTemple") || akNewLoc.HasKeyWordString("LocTypeCemetery") 
				Sound.SetInstanceVolume(SayLocationTempleSound.Play(actorRef), 0.8)
				Log("Temple Visit")
			elseif akNewLoc.HasKeyWordString("LocTypeCastle") || akNewLoc.HasKeyWordString("LocTypeGuild")
				Sound.SetInstanceVolume(SayLocationCastleSound.Play(actorRef), 0.8)
				Log("Castle Visit")
			elseif akNewLoc.HasKeyWordString("LocTypeJail") || akNewLoc.HasKeyWordString("LocTypeMine")
				Sound.SetInstanceVolume(SayLocationJailSound.Play(actorRef), 0.8)
				Log("Jail Visit")							
			elseif akNewLoc.HasKeyWordString("LocTypeDungeon")
				if !akOldLoc.HasKeyWordString("LocTypeDungeon")
					Sound.SetInstanceVolume(SayLocationDungeonEnterSound.Play(actorRef), 0.8)
					visitAction = "dungeonEnter"
					Log("Dungeon Enter")
				endif
			endif
		else 
			if akOldLoc.HasKeyWordString("LocTypeDungeon") && visitAction == "dungeonEnter"
				Sound.SetInstanceVolume(SayLocationDungeonExitSound.Play(actorRef), 0.8)
				visitAction = ""
				Log("Dungeon Exit")
			endif
		endif
	endif 

	if loadingComplete == false
		regAnimation()
	endif
endEvent
	
; Event received when an actor enters bleedout.
Event OnEnterBleedout()
	Sound.SetInstanceVolume(SayCombatBleedOutSound.Play(actorRef), 0.8)
	Log("OnEnterBleedout")
EndEvent

Event OnMenuOpen(string menuName)

	if menuName == "MapMenu"
		SoundLazyPlay(SayActionTravelSound, 5)
		menuAction = "traveling"
	elseif menuName == "ContainerMenu"
		if menuAction == "locking"
			Sound.SetInstanceVolume(SayActionSuccessSound.Play(actorRef), 0.5)
			menuAction = ""
		Else
			menuAction = "watching"
		endif
	elseif menuName == "Lockpicking Menu"
		if BgPickingModeSoundId == 0
			BgPickingModeSoundId = SayBgPickingModeSound.Play(actorRef)
			Sound.SetInstanceVolume(BgPickingModeSoundId, 0.2)
		endif

		menuAction = "locking"
	elseif menuName == "BarterMenu"
		menuAction = "bargaining"
	endif
endEvent

Event OnMenuClose(string menuName)

	if menuName == "MapMenu"
	elseif menuName == "Lockpicking Menu"
		if BgPickingModeSoundId != 0
			Sound.StopInstance(BgPickingModeSoundId)
			BgPickingModeSoundId = 0
		endif 
	elseif menuName == "BarterMenu"
		Sound.SetInstanceVolume(SayGoodByeSound.Play(actorRef), 0.8)		
	endif
	Sound.SetInstanceVolume(BgPickingModeSoundId, 0.3)
endEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)	
	Armor _armor = akBaseObject as armor

	Log("OnObjectUnequipped ")
	if _armor.IsClothingBody() || _armor.IsCuirass() || _armor.IsLightArmor() || _armor.IsHeavyArmor() || _armor.IsClothing()
		Log("check naked")
		UnregisterForUpdate()
		RegisterForSingleUpdate(3.0) ; 3초 뒤
		isNaked = true
		nakedCount = 0
	endif
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	Armor _armor = akBaseObject as armor

	if _armor.IsClothingBody() || _armor.IsCuirass() || _armor.IsLightArmor() || _armor.IsHeavyArmor() || _armor.IsClothing()
		Log("dressed clothes")
		UnregisterForUpdate()
		isNaked = false
		nakedCount = 0
	endif
EndEvent

event OnUpdate()
	; Armor _armor = actorRef.GetWornForm(0x00000004) as Armor
	Log("OnUpdate")
	if isNaked
		SoundLazyPlay(SayActionNakedSound, 6)
		nakedCount += 1
		RegisterForSingleUpdate(30.0 * nakedCount)
		if nakedCount > 3
			SoundLazyPlay(SayActionAngrySound, 10)
		endif 
		Log("naked")
	endif
endEvent

event OnUpdateGameTime()
	float Time = Utility.GetCurrentGameTime()
	Log("gameTime " + time)
endEvent

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction

; hello
Sound property SayHelloSound Auto
Sound property SayGoodByeSound Auto

; levelup
Sound property SayLevelUpSound Auto

; weather
Sound property SayWeatherCloudySound Auto
Sound property SayWeatherRainySound Auto
Sound property SayWeatherClearSound Auto
Sound property SayWeatherSnowSound Auto

; action
Sound property SayActionSitSound Auto					; idx 0
Sound property SayActionHarvestedSound Auto				; idx 1
Sound property SayActionBookReadSound Auto				; idx 2
Sound property SayActionDragonSoulSound Auto			; idx 3
Sound property SayActionSleepBeginSound Auto			; idx 4
Sound property SayActionTravelSound Auto				; idx 5
Sound property SayActionNakedSound Auto					; idx 6
Sound property SayActionRidingSound Auto				; idx 7
Sound property SayActionSuccessSound Auto				; idx 8
Sound property SayActionFailSound Auto					; idx 9
Sound property SayActionAngrySound Auto					; idx 10
Sound property SayActionBreathSound Auto				; idx 11
Sound property SayActionBreathLowSound Auto				; idx 12

; location
Sound property SayLocationInnSound Auto
Sound property SayLocationStoreSound Auto
Sound property SayLocationPlayerHomeSound Auto
Sound property SayLocationNormalHomeSound Auto
Sound property SayLocationCastleSound Auto
Sound property SayLocationJailSound Auto
Sound property SayLocationTempleSound Auto

Sound property SayLocationDungeonEnterSound Auto
Sound property SayLocationDungeonExitSound Auto

; Combat
	; start/end
Sound property SayCombatStartSound Auto					; idx 20
Sound property SayCombatEndSound Auto					; idx 21

	; under attack
Sound property SayCombatNormalHitSound Auto				; idx 22
Sound property SayCombatCriticalHitSound Auto			; idx 23

	; shield
Sound property SayCombatBlockSound Auto					; idx 24

	; bow
Sound property SayCombatBowDrawSound Auto
Sound property SayCombatBowReleaseSound Auto

	; weapon | unarm
Sound property SayCombatNormalAttackSound Auto
Sound property SayCombatPowerAttackSound Auto

	; health
Sound property SayCombatDeathEndSound Auto
Sound property SayCombatBleedOutSound Auto

; Magic
	; fire
Sound property SayMagicFireCastSound Auto				; idx 30
Sound property SayMagicFireConcentrationSound Auto
Sound property SayMagicFireRitualSound Auto

	; frost
Sound property SayMagicFrostCastSound Auto
Sound property SayMagicFrostConcentrationSound Auto
Sound property SayMagicFrostRitualSound Auto

	; shock
Sound property SayMagicShockCastSound Auto
Sound property SayMagicShockConcentrationSound Auto
Sound property SayMagicShockRitualSound Auto
	
	; light
Sound property SayMagicLightCastSound Auto
Sound property SayMagicLightConcentrationSound Auto
Sound property SayMagicLightRitualSound Auto

	; poison
Sound property SayMagicPoisonCastSound Auto
Sound property SayMagicPoisonConcentrationSound Auto
Sound property SayMagicPoisonRitualSound Auto

	; voice
Sound property SayMagicVoiceCastSound Auto
Sound property SayMagicVoiceConcentrationSound Auto
Sound property SayMagicVoiceRitualSound Auto

	; heal
Sound property SayMagicHealCastSound Auto
Sound property SayMagicHealConcentrationSound Auto

	; change sky
Sound property SayMagicClearSkySound Auto

	; candle light
Sound property SayMagicCandleLightSound Auto

	; summon
Sound property SayMagicSummonSound Auto
Sound property SayMagicUndeadSound Auto

	; background
Sound property SayBgPickingModeSound Auto
Sound property SayBgSneakModeSound Auto

; etc
Sound property SayMagicEtcSound Auto
Sound property SayDefaultSound Auto						; idx 49