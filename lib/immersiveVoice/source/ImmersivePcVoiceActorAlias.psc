scriptname ImmersivePcVoiceActorAlias extends ReferenceAlias

string prevMenuAction
string visitLocation
bool   isNaked
bool   isDrunk
bool   isMenu
bool   isExpression
bool   isTradeDone
bool   isGameRunning

float  swimmingSoundVolume
float  sneakingBgSoundVolume

int    breathSoundId
int    SneakSoundId
int    breathLowSoundId
int    swimmingSoundId

int    LockPickBgSoundId
int    SneakBgSoundId

int    underAttackCountByAnimal
int    monologueDelay
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
	RegisterForMenu("MapMenu")
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("Journal Menu")
	RegisterForMenu("ContainerMenu")
	RegisterForMenu("Lockpicking Menu")
	RegisterForMenu("Sleep/Wait Menu")
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
	RegisterForActorAction(1) ; 1 - Spell Cast, 2 - Spell Fire
	RegisterForActorAction(5) ; bow draw
	RegisterForActorAction(6) ; bow release 

	RegisterForSleep()
	RegisterForSingleUpdateGameTime(1.0)	; 1시간 마다 onUpdate 이벤트 발생

	regAnimation()
endFunction

function RegisterModEvents()	
	; RegisterForModEvent("Strip", "Strip")
endFunction

function setup()
	isGameRunning = false
	
	prevMenuAction = ""
	visitLocation = ""
	isNaked = false
	isMenu = false
	isTradeDone = false
	isExpression = false

	visitLocation = checkLocation(playerRef.GetCurrentLocation())		

	Armor _armor = playerRef.GetWornForm(0x00000004) as Armor
	if _armor == none
		isNaked = true
	endif	

	coolTimeMap = new float[30]		; 0: normal, 1: monologue, 2: naked, 3: normal dialogue, 4: child dialogue, 5: enemy dialogue, 10: weather
endFunction

function init ()	
	monologueDelay = 1
	underAttackCountByAnimal = 0
	SneakBgSoundId = 0
	SneakSoundId = 0
	LockPickBgSoundId = 0
	breathSoundId = 0
	breathLowSoundId = 0
	sneakingBgSoundVolume = 0.0
	swimmingSoundId = 0
	swimmingSoundVolume = 0.0
	soundCoolTime = 0.0	
	coolTimeMap = new float[30]
endFunction

function regAnimation ()
	LOG("regAnimation")

	; key
	RegisterForKey(18)	; 'E'

	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseMount") 	
	; RegisterForAnimationEvent(playerRef, "DragonMountEnter") 		

	RegisterForAnimationEvent(playerRef, "JumpUp")
	; RegisterForAnimationEvent(playerRef, "JumpFall")
	
	; sneak
	RegisterForAnimationEvent(playerRef, "tailSneakIdle") 			; start in standing
	RegisterForAnimationEvent(playerRef, "tailMTIdle") 				; end in sprint or sneak
	RegisterForAnimationEvent(playerRef, "tailCombatIdle") 			; end
	RegisterForAnimationEvent(playerRef, "tailCombatLocomotion") 	; end

	; sprint
	RegisterForAnimationEvent(playerRef, "FootSprintRight") 		; end

	; swimming	
	RegisterForAnimationEvent(playerRef, "SoundPlay.FSTSwimSwim")	; start
	RegisterForAnimationEvent(playerRef, "MTState") 				; end
	
	; weapon/bow
	RegisterForAnimationEvent(playerRef, "weaponSwing") 	
	RegisterForAnimationEvent(playerRef, "weaponLeftSwing")	

	; weapon
	RegisterForAnimationEvent(playerRef, "weaponDraw")
	; RegisterForAnimationEvent(playerRef, "weaponSheathe")	
endFunction

Event OnKeyDown(int keyCode)
	Actor akActor = Game.GetCurrentCrosshairRef() as Actor
	; player와 대화 대상 찾기
	If akActor != none	
		
		if akActor.isDead()
			SoundPlay(SayActionSearchDeadBodySound, 0.4, 1.5)			
			log ("found actor of dead")
		else 
			if !akActor.HasKeyWordString("ActorTypeCreature")
				int dialogueActorRelationShip = -5	; nothing found
				dialogueActorRelationShip = playerRef.GetRelationshipRank(akActor)
				log ("found actor with relation " + dialogueActorRelationShip)
				if dialogueActorRelationShip < 0 ;적과 이야기 시 적대적 대화 주고받기
					SoundCoolTimePlay(SayActionDialogueEnemyStartSound, 0.5, 0.0, 2.0, 5, 30.0)
				elseif dialogueActorRelationShip == 0 ; 처음 보는 대상과 인사 주고 받기
					if akActor.isChild() 
						SoundCoolTimePlay(SayActionDialogueChildStartSound, 0.5, 0.0, 2.0, 4, 30.0)				
					else
						SoundCoolTimePlay(SayActionDialogueStartSound, 0.5, 0.0, 2.0, 3, 30.0)
					endif
				elseif dialogueActorRelationShip <= 3 ;
					SoundCoolTimePlay(SayActionDialogueFriendStartSound, 0.5, 0.0, 2.0, 6, 30.0)
				elseif dialogueActorRelationShip == 4 ; lover
					SoundCoolTimePlay(SayActionDialogueLoverStartSound, 0.5, 0.0, 2.0, 7, 30.0)
				endif
			endif
			LogKeywords(akActor.GetKeywords())
		endif
	endif	
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "weaponDraw"
		Log("weaponDraw ")
		SoundCoolTimePlay(SayCombatStartSound, 0.5, 1.0, 1.5)
	elseif asEventName == "weaponLeftSwing" || asEventName == "weaponSwing"
		if playerRef.GetAnimationVariableBool("bAllowRotation") 
			SoundPlay(SayCombatNormalAttackSound)
		else 
			SoundPlay(SayCombatPowerAttackSound)
		endif		
		Log("Weapon Swing ")
	elseif asEventName == "FootSprintRight"
		float _stamina = playerRef.GetActorValuePercentage("Stamina")
		if  0.15 < _stamina && _stamina < 0.35	
			if breathLowSoundId != 0
				Sound.StopInstance(breathLowSoundId)
				breathLowSoundId = 0
			endif
			breathSoundId = SoundCoolTimePlay(SayActionBreathSound, 0.3, 0.1, 5.0)
		elseif  0.15 > _stamina		
			if breathSoundId != 0
				Sound.StopInstance(breathSoundId)
				breathSoundId = 0	
			endif		
			breathLowSoundId = SoundCoolTimePlay(SayActionBreathLowSound, 0.4, 0.1, 5.0)
		else 
			if breathSoundId != 0 || breathLowSoundId != 0
				Sound.StopInstance(breathSoundId)
				Sound.StopInstance(breathLowSoundId)
				breathSoundId = 0
				breathLowSoundId = 0
			endif
		endif
	elseif asEventName == "tailSneakIdle"
		if SneakSoundId == 0
			SneakSoundId = SoundCoolTimePlay(SayActionSneakSound, 0.5, 1.0, 5.0)
		endif
		
		if Weather.GetSkyMode() < 3 	; 실내인 경우면 background sneak 사운드 출력
			if SneakBgSoundId == 0
				SneakBgSoundId = SoundPlay(SayBgSneakModeSound, sneakingBgSoundVolume)				
			else 
				sneakingBgSoundVolume += 0.1
				SoundVolumeUp(SneakBgSoundId, sneakingBgSoundVolume)
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
		if SneakSoundId != 0
			Sound.StopInstance(SneakSoundId)
			SneakSoundId = 0
		endif
		prevMenuAction = ""
	elseif asEventNAme == "JumpUp"
		SoundPlay(SayActionJumpUpSound, 0.2)
	elseif asEventName == "SoundPlay.FSTSwimSwim"				
		swimmingSoundId = SoundCoolTimePlay(SayActionSwimmingSound, swimmingSoundVolume, 0.2, 5.0)
		swimmingSoundVolume += 0.1
		if swimmingSoundVolume > 0.5
			swimmingSoundVolume = 0.5
		endif
	elseif asEventName == "MTState"
		Sound.StopInstance(swimmingSoundId)
		swimmingSoundId = 0
		swimmingSoundVolume = 0.0
	elseif asEventName == "SoundPlay.NPCHorseMount"	
		log("SoundPlay.NPCHorseMount")
		SoundPlay(SayActionRidingSound, 0.6)		
	endif
	
	; Log("OnAnimationEvent " + asEventName)
endEvent

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	if akActor == playerRef	
		if actionType == 1
			Spell magicSpell = source as spell
			MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

			int idxx=0
			while idxx < magicEffects.length
				int castingType = magicEffects[idxx].GetCastingType()
				int deliveryType = magicEffects[idxx].GetDeliveryType()

				if magicEffects[idxx].HasKeyWordString("RitualSpellEffect")
					if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
						Log("Magic Cast from RitualSpellEffect and MagicDamageFire")
						SoundCoolTimePlay(SayMagicFireRitualSound)
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
						Log("Magic Cast from RitualSpellEffect and MagicDamageFrost")
						SoundCoolTimePlay(SayMagicFrostRitualSound)
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
						Log("Magic Cast from RitualSpellEffect and MagicDamageShock")
						SoundCoolTimePlay(SayMagicShockRitualSound)
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
						Log("Magic Cast from RitualSpellEffect and MagicDamageLight")
						SoundCoolTimePlay(SayMagicLightRitualSound)
					elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
						Log("Magic Cast from RitualSpellEffect and MagicDamagePoison")
						SoundCoolTimePlay(SayMagicPoisonRitualSound)
					else 
						Log("Magic Cast from RitualSpellEffect")
					endif 
					return 
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageFire")
					Log("Magic Cast from MagicDamageFire")
					SoundCoolTimePlay(SayMagicFireCastSound)
					return 
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
					SoundCoolTimePlay(SayMagicFrostCastSound)
					Log("Magic Cast from MagicDamageFrost")
					return 
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
					SoundCoolTimePlay(SayMagicShockCastSound)
					Log("Magic Cast from MagicDamageShock")
					return 						
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
					SoundCoolTimePlay(SayMagicLightCastSound)
					Log("Magic Cast from MagicDamageLight")
					return 			
				elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
					SoundCoolTimePlay(SayMagicPoisonCastSound)
					Log("Magic Cast from MagicDamagePoison")
					return 									
				elseif magicEffects[idxx].HasKeyWordString("MagicRestoreHealth")
					Log("Magic Cast from MagicRestoreHealth")
					if deliveryType == 0  ; self
						SoundCoolTimePlay(SayMagicHealSelfSound)
					else 				  ; others
						SoundCoolTimePlay(SayMagicHealCastSound)
					endif 
					return 					
				elseif magicEffects[idxx].HasKeyWordString("MagicCandleLight")
					Log("Magic Cast from MagicCandleLight")
					SoundCoolTimePlay(SayMagicCandleLightSelfSound)					
					return 	
				elseif magicEffects[idxx].HasKeyWordString("MagicTurnUndead")
					SoundCoolTimePlay(SayMagicUndeadSound)
					Log("Magic Cast from MagicTurnUndead")
					return 									
				elseif magicEffects[idxx].HasKeyWordString("MagicSummonShock") || magicEffects[idxx].HasKeyWordString("MagicSummonFrost") || magicEffects[idxx].HasKeyWordString("MagicSummonLight")
					SoundCoolTimePlay(SayMagicSummonSound)
					Log("Magic Cast from MagicSummon")
					return 									
				else 
					SoundCoolTimePlay(SayMagicDefaultSound)
					Log("Magic Cast from MagicDefault")
				endif
				idxx += 1
			endwhile
		elseif actionType == 5 ; bow draw
			SoundCoolTimePlay(SayCombatBowDrawSound)
		elseif actionType == 6 ; bow release
			SoundCoolTimePlay(SayCombatBowReleaseSound)
		endif			
	endif
EndEvent

Event OnActorKilled(Actor akVictim, Actor akKiller)	
	if akKiller == playerRef && playerRef.IsInCombat() == false
		playerRef.SheatheWeapon()
		SoundCoolTimePlay(SayCombatEndSound, 0.6, 1.5)
	endif	
EndEvent

Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	if akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreHealth"); restore health
		SoundCoolTimePlay(SayDrinkHealthPotionSound)
		Log("Health potion")
	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreMagicka"); restore magicka
		SoundCoolTimePlay(SayDrinkMagicPotionSound)
		Log("Magicka potion")
	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreStamina"); restore stamina	
		SoundCoolTimePlay(SayDrinkStaminaPotionSound)
		Log("Stamina potion")
	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure
		SoundCoolTimePlay(SayDrinkEtcPotionSound)
		Log("Cure poison")
	elseif akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
		SoundCoolTimePlay(SayDrinkAlcoholSound)
		Log("Drink acholol")
		isDrunk = true
		RegisterForSingleUpdate(30.0) ; 20초 뒤
		drunkenStartTime = Utility.GetCurrentRealTime()
	Else
		LogKeywords(akEffect.GetKeywords())
	endif
EndEvent

Event OnBookRead(Book akBook)
	SoundCoolTimePlay(SayActionBookReadSound, 0.6, 1.0, 5.0)
	Log("OnBookRead")
EndEvent

Event OnDragonSoulGained(float afSouls)
	SoundCoolTimePlay(SayActionDragonSoulSound, 0.6, 1.0, 7.0)
	Log("OnDragonSoulGained")
EndEvent

Event OnItemHarvested(Form akProduce)
	SoundCoolTimePlay(SayActionHarvestedSound, 0.5, 0.3, 2.0)
	Log("OnItemHarvested")
EndEvent

Event OnLevelIncrease(int aiLevel)
	SoundCoolTimePlay(SayActionLevelUpSound)
	Log("OnLevelIncrease")
EndEvent

Event OnWeatherChange(Weather akOldWeather, Weather akNewWeather)
	if Weather.GetSkyMode() == 3
		int oldWeatherType = akOldWeather.GetClassification()	
		int newWeatherType = akNewWeather.GetClassification()	
		; -1 - No classification
		;  0 - Pleasant
		;  1 - Cloudy
		;  2 - Rainy
		;  3 - Snow
		if newWeatherType == 0 
			if oldWeatherType == 2 || oldWeatherType == 3
				SoundCoolTimePlay(SayWeatherWarmSound, 0.5, 0.1, 3.0, 10, 30.0)
			elseif oldWeatherType == -1 || oldWeatherType == 1
				SoundCoolTimePlay(SayWeatherSunnySound, 0.5, 0.1, 3.0, 10, 30.0)
			endif
		elseif newWeatherType == 2
			SoundCoolTimePlay(SayWeatherRainySound, 0.5, 0.1, 3.0, 10, 30.0)
		elseif newWeatherType == 3
			SoundCoolTimePlay(SayWeatherSnowSound, 0.5, 0.1, 3.0, 10, 30.0)
		endif 		
	endif

	Log("OnWeatherChange ")
EndEvent

; Event that is triggered when this actor sits in the furniture
Event OnSit(ObjectReference akFurniture)	
	bool isTable = false 		

	if akFurniture.HasKeyWordString("CraftingCookpot")		
		log("cooking")		
	elseif akFurniture.HasKeyWordString("CraftingSmithingForge")
		log("forge")
	elseif akFurniture.HasKeyWordString("CraftingTanningRack")
		log("TanningRack")		
	elseif akFurniture.HasKeyWordString("CraftingSmithingArmorTable")
		log("Smithing ArmorTable")		
	elseif akFurniture.HasKeyWordString("CraftingSmithingSharpeningWheel")
		log("Smithing Sharpen")		
	elseif akFurniture.HasKeyWordString("BYOHCarpenterTable")
		log("carpenter")
	elseif akFurniture.HasKeyWordString("isGrainMill")
		log("grainMill")
	elseif akFurniture.HasKeyWordString("CraftingSmelter")
		log("smelter")		
	elseif akFurniture.HasKeyWordString("WICraftingAlchemy")		
		log("alchemy")		
	elseif akFurniture.HasKeyWordString("WICraftingEnchanting")		
		log("enchanting")				
	elseif akFurniture.HasKeyWordString("FurnitureWoodChoppingBlock")		
		log("woodChopping")		
	elseif akFurniture.HasKeyWordString("isPickaxeFloor") || akFurniture.HasKeyWordString("isPickaxeWall")
		log("pickaxe")
	elseif akFurniture.HasKeyWordString("isBench") || akFurniture.HasKeyWordString("isTable") || akFurniture.HasKeyWordString("isChair")
		isTable = true		
		log("chair or table")
	elseif akFurniture.HasKeyWordString("isCart")
		isTable = true
		log("cart")
	else
		isTable = true
		log("sit")
	endif

	if isTable
		SoundCoolTimePlay(SayActionSitSound)
	else
		SoundCoolTimePlay(SayCommonSound)
	endif

	LogKeywords(akFurniture.GetKeywords())

	Log("OnSit")
EndEvent
	
; Event that is triggered when this actor finishes dying
Event OnDeath(Actor akKiller)
	SoundCoolTimePlay(SayCombatDeathEndSound)
	Log("OnDeath")
EndEvent

;
;	Location
;
Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	int skyMode = Weather.GetSkyMode() 
	visitLocation = ""
	log("OnLocationChange " + ", skyMode " + skyMode + ", isNaked " + isNaked)
	
	; 평야지대 + 평화적상태 + 옷을 입고 있는 상태
	if isGameRunning && !playerRef.IsInCombat()		
		if skyMode == 3
			if !isNaked 
				; string _newLocation = checkLocation(akNewLoc)							
				; if _newLocation == "town"
				SoundCoolTimePlay(SayActionMonologueSound, 0.6, 0.0, 10.0, 1, 180.0 * monologueDelay) ;
				monologueDelay += 1
				if monologueDelay > 5
					monologueDelay = 1
				endif
				; endif
			elseif playerRef.GetActorValue("Health") <= 0.3		; low health
				SoundCoolTimePlay(SayStateHealthSound, 0.5, 0.0, 3.0, 2, 30.0)
			elseif playerRef.GetWornForm(0x00000080) == none	; no shoes
				SoundCoolTimePlay(SayStateFeetSound, 0.5, 0.0, 3.0, 2, 30.0)
			else
				SoundCoolTimePlay(SayStateNakedSound, 0.5, 0.0, 5.0, 2, 30.0)
			endif
		endif
	endif	
EndEvent

Event OnCellAttach()
	Log("OnCellAttach")
EndEvent

Event OnCellLoad()
	Log("OnCellLoad")
	if prevMenuAction == "lockpick"
		; lockpick -> interior
		Sound.SetInstanceVolume(SayActionSuccessSound.Play(playerRef), 0.5)
		prevMenuAction = ""
	else
		visitLocation = checkLocation(playerRef.GetCurrentLocation())
		; 0 - No sky (SM_NONE)
		; 1 - Interior (SM_INTERIOR)
		; 2 - Skydome only (SM_SKYDOME_ONLY)
		; 3 - Full sky (SM_FULL)		
		int skyMode = Weather.GetSkyMode()
		Log("location " + visitLocation + ", skyMode " + skyMode) 

		if skyMode < 3; interior
			if isNaked
				SoundCoolTimePlay(SayStateNakedSound, 0.4, 0.7, 5.0, 2, 60.0)
			elseif visitLocation == "home"
				log("home")
				SoundCoolTimePlay(SayLocationHomeSound, 0.4, 0.7, 5.0)
			elseif visitLocation == "house"
				log("house")
				SoundCoolTimePlay(SayLocationHouseSound, 0.4, 0.7, 5.0)
			elseif visitLocation == "inn"
				log("inn")
				if isDrunk
					SoundCoolTimePlay(SayLocationInnDrunkSound, 0.7, 0.7, 5.0)
				else 
					SoundCoolTimePlay(SayLocationInnSound, 0.4, 0.7, 5.0)
				endif
			elseif visitLocation == "store"
				log("store")
				if isDrunk
					SoundCoolTimePlay(SayLocationStoreDrunkSound, 0.7, 0.7, 5.0)
				else 
					SoundCoolTimePlay(SayLocationStoreSound, 0.4, 0.7, 5.0)
				endif
			elseif visitLocation == "temple"
				log("temple")
				SoundCoolTimePlay(SayLocationTempleSound, 0.4, 0.7, 5.0)
			elseif visitLocation == "castle"
				log("castle")
				SoundCoolTimePlay(SayLocationCastleSound, 0.4, 0.7, 5.0)
			elseif visitLocation == "jail"
				log("jail")
				SoundCoolTimePlay(SayLocationJailSound, 0.4, 0.7, 5.0)
			elseif visitLocation == "dungeon"
				log("dungeonEnter")
				if isDrunk
					SoundCoolTimePlay(SayLocationDungeonDrunkSound, 0.7, 0.7, 5.0)
				else  
					SoundCoolTimePlay(SayLocationDungeonSound, 0.4, 0.7, 5.0)
				endif
			endif
		endif
	endif
EndEvent

String function checkLocation(Location _location)
	log("checkLocation ")
	LogKeywords(_location.GetKeywords())
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

	return _visitLocation
endFunction 

;
;	Menu
;
Event OnMenuOpen(string menuName)
	log("OnMenuOpen")

	isMenu = true	
	prevMenuAction = ""

	if menuName == "Journal Menu"
	elseif menuName == "MapMenu"
	elseif menuName == "RaceSex Menu"			
		isGameRunning = false
		SoundHelloPlay(SayHelloSound) 		
	elseif menuName == "BarterMenu"
		isTradeDone = false
		prevMenuAction = "barter"
	elseif menuName == "InventoryMenu"
		UnregisterForUpdate()
	elseif menuName == "ContainerMenu"
		; lockpick -> container
		if prevMenuAction == "lockpick"
			SoundPlay(SayActionSuccessSound, 0.5)
		endif
	elseif menuName == "Lockpicking Menu"
		Sound.StopInstance(LockPickBgSoundId)		
		LockPickBgSoundId = SoundPlay(SayBgSneakModeSound, 0.5)
		prevMenuAction = "lockpick"
		log("try lockpick")
	elseif menuName == "Sleep/Wait Menu"		
		if playerRef.GetSleepState() == 3
			SoundPlay(SayActionSleepSound)	
			prevMenuAction = "sleep"
		else 
			SoundPlay(SayActionWaitSound)	
		endif
	endif
endEvent

Event OnMenuClose(string menuName)		
	log("OnMenuClose")

	if menuName == "RaceSex Menu"			
		isGameRunning = true		
	elseif menuName == "Lockpicking Menu"
		Sound.StopInstance(LockPickBgSoundId)
		LockPickBgSoundId = 0		
	elseif menuName == "Sleep/Wait Menu"
		Game.FadeOutGame(false, true, 0.5, 3.0)
	elseif menuName == "InventoryMenu"
		if isNaked
			SoundCoolTimePlay(SayStateNakedSound, 0.5, 0.2, 5.0, 2, 60.0)
		endif
	endif
	isMenu = false
endEvent

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

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if isMenu
		isTradeDone = true
	endif
EndEvent

; Event received when an item is removed from this object's inventory. If the item is a persistant reference, akItemReference
; will point at it - otherwise the parameter will be None
Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	if isMenu
		isTradeDone = true
	endif
EndEvent

; Event received when an actor enters bleedout.
Event OnEnterBleedout()
	SoundPlay(SayCombatBleedOutSound)
	Log("OnEnterBleedout")
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)	
	if abHitBlocked
		SoundCoolTimePlay(SayCombatBlockSound, 0.7, 0.1, 1.5)
	Else
		bool  isPowerDamange = false
		float nakedDamagePenalty = 10.0
		float drunkDamagePenalty = 10.0		
		
		if abPowerAttack || abBashAttack
			; 옷 상태 처리
			Actor aggressor = akAggressor as Actor

			; 동물들 공격에 의해 옷이 벗겨질 수 있음
			if aggressor.HasKeyWordString("ActorTypeAnimal")
				underAttackCountByAnimal += 1

				if underAttackCountByAnimal > 5 && Utility.randomInt(1, 10) == 2
					Armor[] actorArmorList = new Armor[8]
					actorArmorList[0]	= playerRef.GetWornForm(0x00000008) As Armor	; actorHand
					actorArmorList[1]	= playerRef.GetWornForm(0x00000010) As Armor	; actorArm
					actorArmorList[2]	= playerRef.GetWornForm(0x00000080) As Armor	; actorBoot
					actorArmorList[3] 	= playerRef.GetWornForm(0x00800000) as Armor	; actorThigh				
					actorArmorList[4] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
					actorArmorList[5] 	= playerRef.GetWornForm(0x00008000) as Armor	; actorSkirts
					actorArmorList[6]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor		
					actorArmorList[7] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty
				
					int idx = 0
					while idx < actorArmorList.length 													
						if actorArmorList[idx] && isWeakArmor(actorArmorList[idx])
							playerRef.DropObject(actorArmorList[idx])
							idx = actorArmorList.length 
						endif
						idx += 1
					endwhile
				endif
			; 용 불길로 인해 옷이 타버릴 수 있음
			elseif aggressor.HasKeyWordString("ActorTypeDragon")
				if Utility.randomInt(1, 10) < 3
					if checkFireSpell(akSource)				
						Armor[] actorArmorList = new Armor[5]
						actorArmorList[0] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
						actorArmorList[1]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor
						actorArmorList[2] 	= playerRef.GetWornForm(0x00800000) as Armor	; actorThigh
						actorArmorList[3] 	= playerRef.GetWornForm(0x00008000) as Armor	; actorSkirts
						actorArmorList[4] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty

						int idx = 0
						while idx < actorArmorList.length 													
							if actorArmorList[idx] && isWeakArmor(actorArmorList[idx])
								playerRef.RemoveItem(actorArmorList[idx])
								idx = actorArmorList.length
							endif 							
							idx += 1
						endwhile
					endif
				endif
			endif

			nakedDamagePenalty = 20.0
			isPowerDamange = true
		endif

		; 데미지 처리
		if isPowerDamange
			SoundCoolTimePlay(SayCombatCriticalHitSound, 0.7, 0.1, 1.5)
		else 
			SoundCoolTimePlay(SayCombatNormalHitSound, 0.5, 0.1, 1.5)
		endif 
		float penaltyHealthValue = playerRef.GetActorValue("Health")
		bool  getPenalty = false
		if isNaked
			penaltyHealthValue = penaltyHealthValue / nakedDamagePenalty
			getPenalty = true
		endif

		if isDrunk
			penaltyHealthValue = penaltyHealthValue / drunkDamagePenalty
			getPenalty = true
		endif

		if getPenalty
			playerRef.DamageActorValue("Health", playerRef.GetActorValue("Health"))
		endif		
	endif

	Log("health " +  playerRef.GetActorValue("Health"))
EndEvent

event OnUpdate()
	; 취한 상태 업데이트
	if isDrunk 
		if Utility.GetCurrentRealTime() > drunkenStartTime + 300.0	; 5분간 유지
			isDrunk = false
		else 
			RegisterForSingleUpdate(30.0)					
		endif
	endif
	
	; 벗은 상태 업데이트
	if !isNaked
		Armor _armor = playerRef.GetWornForm(0x00000004) as Armor
		if _armor == none
			isNaked = true
			expression("undress")
			SoundCoolTimePlay(SayActionShockSound, 0.7, 0.1, 1.5)
			RegisterForSingleUpdate(2.0)
		endif
	endif

	if isExpression
		expression("normal")
	endif 
endEvent

event OnUpdateGameTime()
	float Time = Utility.GetCurrentGameTime()
	Log("gameTime " + time)
endEvent

;
;	Utility
;
int function SoundCoolTimePlay(Sound _sound, float _volume = 0.6, float _sleep = 0.2,float _gCoolTime = 2.0, int _mapIdx = 0, float _mapCoolTime = 0.5)
	float currentTime = Utility.GetCurrentRealTime()
	int _soundId = 0

	if isGameRunning && currentTime >= soundCoolTime && currentTime > coolTimeMap[_mapIdx]
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

function SoundVolumeUp(int _soundId, float _volume = 0.1)
	if isGameRunning
		if _volume > 0.5 
			_volume = 0.5
		endif
		Sound.SetInstanceVolume(_soundId, _volume)
	endif
endFunction

bool function isWeakArmor(Armor _armor)
	if _armor.GetEnchantment() == none	; 마법옷이라면, burn 되지 않음
		if _armor.IsClothingBody()
			return true
		elseif _armor.IsClothingHead()
			return true
		elseif _armor.IsClothingFeet()
			return true
		elseif _armor.IsClothingHands()
			return true
		endif
	endif
	return false
endFunction 

function clearNaked()
	isNaked = false
	coolTimeMap[2] = 0.0
endfunction

bool function checkFireSpell(form _akSource)
	Spell magicSpell = _akSource as spell
	MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

	int idxx=0
	while idxx < magicEffects.length
		; 불 데미지라면 옷이 불에탐
		if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
			return true
		endif
		idxx += 1
	endwhile

	return false
endfunction

function expression(string _type)
	if _type == "undress"
		isExpression = true
		playerRef.SetExpressionOverride(3, Utility.RandomInt(70, 100))	; eyebrush
		; playerRef.SetExpressionModifier(0, 10)	;blink L
		; playerRef.SetExpressionModifier(0, 20)	;blink L
		playerRef.SetExpressionPhoneme(14, 20)  ; mouth		
	else
		isExpression = false
		playerRef.ResetExpressionOverrides()
		playerRef.SetExpressionPhoneme(14, 1)  ; mouth		
		log("expression reset")
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

Actor property playerRef Auto

; hello
Sound property SayHelloSound Auto

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
Sound property SayLocationDungeonSound Auto
Sound property SayLocationDungeonDrunkSound Auto

; action
Sound property SayActionShockSound Auto
Sound property SayActionMonologueSound Auto			
Sound property SayActionHarvestedSound Auto			
Sound property SayActionBookReadSound Auto			
Sound property SayActionBreathSound Auto			
Sound property SayActionBreathLowSound Auto			
Sound property SayActionSwimmingSound Auto			
Sound property SayActionDragonSoulSound Auto
Sound property SayActionJumpUpSound Auto
Sound property SayActionLevelUpSound Auto
Sound property SayActionSitSound Auto
Sound property SayActionSleepSound Auto
Sound property SayActionWaitSound Auto
Sound property SayActionTravelSound Auto
Sound property SayActionRidingSound Auto
Sound property SayActionSearchDeadBodySound Auto
Sound property SayActionSneakSound Auto
Sound property SayActionSuccessSound Auto

Sound property SayActionDialogueStartSound Auto		
Sound property SayActionDialogueChildStartSound Auto
Sound property SayActionDialogueEnemyStartSound Auto			
Sound property SayActionDialogueLoverStartSound Auto
Sound property SayActionDialogueFriendStartSound Auto

; State
Sound property SayStateNakedSound Auto
Sound property SayStateFeetSound Auto
Sound property SayStateHealthSound Auto

; Combat
	; start/end
Sound property SayCombatStartSound Auto				
Sound property SayCombatEndSound Auto				

	; under attack
Sound property SayCombatNormalHitSound Auto			
Sound property SayCombatCriticalHitSound Auto		

	; shield
Sound property SayCombatBlockSound Auto				

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
Sound property SayMagicFireCastSound Auto					
Sound property SayMagicFireRitualSound Auto				

	; frost
Sound property SayMagicFrostCastSound Auto				
Sound property SayMagicFrostRitualSound Auto			

	; shock
Sound property SayMagicShockCastSound Auto				
Sound property SayMagicShockRitualSound Auto			
	
	; light
Sound property SayMagicLightCastSound Auto				
Sound property SayMagicLightRitualSound Auto			

	; poison
Sound property SayMagicPoisonCastSound Auto				
Sound property SayMagicPoisonRitualSound Auto			

	; voice
Sound property SayMagicVoiceCastSound Auto
Sound property SayMagicVoiceRitualSound Auto

	; heal
Sound property SayMagicHealCastSound Auto			
Sound property SayMagicHealSelfSound Auto		

	; weapon strong
Sound property SayMagicWeaponSelfSound Auto

	; candle light
Sound property SayMagicCandleLightSelfSound Auto	

	; summon
Sound property SayMagicUndeadSound Auto					
Sound property SayMagicSummonSound Auto					

Sound property SayDrinkAlcoholSound Auto
Sound property SayDrinkHealthPotionSound Auto
Sound property SayDrinkMagicPotionSound Auto
Sound property SayDrinkStaminaPotionSound Auto
Sound property SayDrinkEtcPotionSound Auto

; weather
Sound property SayWeatherSunnySound Auto
Sound property SayWeatherWarmSound Auto
Sound property SayWeatherRainySound Auto
Sound property SayWeatherSnowSound Auto

; background
Sound property SayBgSneakModeSound Auto
Sound property SayMagicDefaultSound Auto
Sound property SayCommonSound Auto
