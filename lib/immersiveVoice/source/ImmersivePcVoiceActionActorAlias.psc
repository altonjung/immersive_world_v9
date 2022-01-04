scriptname ImmersivePcVoiceActionActorAlias extends ReferenceAlias

string prevMenuAction
bool   isMenu

float  sneakingBgSoundVolume
int    SneakSoundId

int    LockPickBgSoundId
int    SneakBgSoundId
int    playerCrimeGold

float  drunkenStartTime
float  soundCoolTime
Faction playerCrimeFaction	
float[] coolTimeMap

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
	prevMenuAction = ""
	isMenu = false
endFunction

function init ()		
	SneakBgSoundId = 0
	SneakSoundId = 0
	LockPickBgSoundId = 0
	sneakingBgSoundVolume = 0.0
	soundCoolTime = 0.0	
	coolTimeMap = new float[10] ; 0: normal, 1: dialog(child), 2: dialog(enemy), 3: dialog(lover), 4: dialog(friend), 5: dialog(soldier), 9: harvest
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")	

	; ride
	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseMount") 	
	RegisterForAnimationEvent(playerRef, "DragonMountEnter") 		

	; jump
	RegisterForAnimationEvent(playerRef, "JumpUp")	
	
	; sneak
	RegisterForAnimationEvent(playerRef, "tailSneakIdle") 			; start in standing
	RegisterForAnimationEvent(playerRef, "tailMTIdle") 				; end in sprint or sneak
	RegisterForAnimationEvent(playerRef, "tailCombatIdle") 			; end
	RegisterForAnimationEvent(playerRef, "tailCombatLocomotion") 	; end
endFunction

Event OnControlDown(string control)
	Actor akActor = Game.GetCurrentCrosshairRef() as Actor
	; player와 대화 대상 찾기
	If akActor != none	
		
		if akActor.isDead() || akActor.IsUnconscious()
			SoundPlay(SayActionSearchDeadBodySound, 0.4, 1.5)	
			expression("sad")		
			log ("found actor of dead")
		else 			
			if PlayerRef.IsInCombat()
				if !akActor.HasKeyWordString("ActorTypeCreature")
					if playerRef.IsHostileToActor(akActor)
						SoundCoolTimePlay(SayActionDialogueAggressiveSound, 0.6, 0.0, 2.0, 2, 30.0)
					else 
						if akActor.isChild()	
							SoundCoolTimePlay(SayActionDialogueWarnChildSound, 0.6, 0.0, 2.0, 1, 10.0)
							expression("sad")
						else
							SoundCoolTimePlay(SayActionDialogueWarnSound, 0.6, 0.0, 2.0, 0, 10.0)
							expression("sad")
						endif
					endif					
				endif
			else 
				if !akActor.HasKeyWordString("ActorTypeCreature")
					if PlayerDrunkState.getValue() > 0
						SoundCoolTimePlay(SayActionDialogueDrunkSound, 0.6, 0.0, 2.0, 8, 30.0)
						expression("happy")		
					else 						
						int dialogueActorRelationShip = playerRef.GetRelationshipRank(akActor)
						log ("found actor with relation " + dialogueActorRelationShip)
						if dialogueActorRelationShip < 0 ;적과 이야기 시 적대적 대화 주고받기
							SoundCoolTimePlay(SayActionDialogueNormalEnemySound, 0.6, 0.0, 2.0, 2, 30.0)
							expression("angry")		
						elseif dialogueActorRelationShip == 0 ; 모르는 대상과 인사 주고 받기														
							if akActor.IsGuard() || akActor.getFactionRank(CWDialogueSoldierFaction) > -1 ; guard or soldier
								SoundCoolTimePlay(SayActionDialogueNormalSoldierSound, 0.6, 0.0, 2.0, 5, 10.0)	
								expression("reset")
							elseif akActor.isChild() 	; 아이
								SoundCoolTimePlay(SayActionDialogueNormalChildSound, 0.6, 0.0, 2.0, 1, 10.0)
								expression("happy")
							elseif akActor.IsGhost()	; 귀신
								SoundCoolTimePlay(SayActionDialogueNormalGhostSound, 0.5, 0.0, 2.0, 1, 30.0)
								expression("happy")								
							else
								Armor _armor = akActor.GetWornForm(0x00000004) as Armor
								if _armor.IsClothingRich()
									SoundCoolTimePlay(SayActionDialogueNormalNobleSound, 0.6, 0.0, 2.0, 0, 15.0)	
									expression("reset")								
								elseif _armor.IsClothingPoor() || (akActor.GetRace() == OrcRace || akActor.GetRace() == FalmerRace)
									SoundCoolTimePlay(SayActionDialogueNormalUglySound, 0.6, 0.0, 2.0, 0, 15.0)									
									expression("angry")
								else
									SoundCoolTimePlay(SayActionDialogueNormalSound, 0.6, 0.0, 2.0, 0, 15.0)
									expression("reset")
								endif
							endif
						elseif dialogueActorRelationShip <= 3 ;
							SoundCoolTimePlay(SayActionDialogueNormalFriendSound, 0.6, 0.0, 2.0, 4, 15.0)
							expression("happy")
						elseif dialogueActorRelationShip == 4 ; lover
							SoundCoolTimePlay(SayActionDialogueNormalLoverSound, 0.6, 0.0, 2.0, 3, 30.0)
							expression("happy")
						endif
					endif
				endif
			endif			
		endif
	endif	
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "tailSneakIdle"
		; 만약 손에 활을 들고 있다면, sneak BG 출력 무시
		if  playerRef.GetEquippedItemType(0) != 7 && playerRef.GetEquippedItemType(1) != 7 	;bow		
			if SneakSoundId == 0
				SneakSoundId = SoundCoolTimePlay(SayActionSneakSound, 0.5, 1.0, 5.0)
			endif

			if Weather.GetSkyMode() < 3 	; 실내인 경우만 sneak BG 출력
				if SneakBgSoundId == 0
					SneakBgSoundId = SoundPlay(SayBgSneakModeSound, sneakingBgSoundVolume)				
				else 
					sneakingBgSoundVolume += 0.1
					SoundVolumeUp(SneakBgSoundId, sneakingBgSoundVolume)
					log("sneak play with volume " + sneakingBgSoundVolume)
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
		if SneakSoundId != 0
			Sound.StopInstance(SneakSoundId)
			SneakSoundId = 0
		endif
		prevMenuAction = ""
	elseif asEventNAme == "JumpUp"
		SoundPlay(SayActionJumpUpSound, 0.2)
	elseif asEventName == "SoundPlay.NPCHorseMount"	|| asEventName == "DragonMountEnter"
		log("SoundPlay.NPCHorseMount")
		SoundPlay(SayActionRidingSound, 0.5)		
	endif
	
	; Log("OnAnimationEvent " + asEventName)
endEvent

Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	log("OnMagicEffectApply")
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
	SoundCoolTimePlay(SayActionHarvestedSound, 0.5, 0.3, 2.0, 9, 10.0)
	Log("OnItemHarvested")
EndEvent

Event OnLevelIncrease(int aiLevel)
	SoundCoolTimePlay(SayActionLevelUpSound)
	Log("OnLevelIncrease")
EndEvent

; Event that is triggered when this actor sits in the furniture
Event OnSit(ObjectReference akFurniture)	
	bool isTable = false 		

	if akFurniture.GetKeywords().length > 0
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
			log("no sit")
		endif
	else 
		log("no sit")
	endif

	if isTable
		if PlayerNakeState.getValue() == 1
			SoundCoolTimePlay(SayActionSitNakedSound)
		else
			SoundCoolTimePlay(SayActionSitSound)
		endif
	else
		SoundCoolTimePlay(SayDefaultSound)
	endif

	Log("OnSit")
EndEvent

;
;	Menu
;
Event OnMenuOpen(string menuName)
	log("OnMenuOpen")

	isMenu = true	
	prevMenuAction = ""

	if menuName == "MapMenu"		
		SoundPlay(SayActionTravelSound, 0.5)		
	elseif menuName == "BarterMenu"
		prevMenuAction = "barter"
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

	if menuName == "Lockpicking Menu"
		Sound.StopInstance(LockPickBgSoundId)
		LockPickBgSoundId = 0		
	elseif menuName == "Sleep/Wait Menu"
		Game.FadeOutGame(false, true, 0.5, 3.0)
	endif
	isMenu = false
endEvent

;
;	Trade
;
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	
	log("faction owner " + akItemReference.GetFactionOwner())	; 추가확인
	; get it	
	; SoundCoolTimePlay(SayEtcMistakeSound)
	; log("mistake")
EndEvent

; Event received when an item is removed from this object's inventory. If the item is a persistant reference, akItemReference
; will point at it - otherwise the parameter will be None
Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
EndEvent

event OnUpdateGameTime()
	float Time = Utility.GetCurrentGameTime()
	Log("gameTime " + time)
endEvent

;
;	Utility
;

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

int function SoundCoolTimePlay(Sound _sound, float _volume = 0.6, float _sleep = 0.2,float _gCoolTime = 2.0, int _mapIdx = 0, float _mapCoolTime = 0.5)
	float currentTime = Utility.GetCurrentRealTime()
	int _soundId = 0

	if currentTime >= soundCoolTime && currentTime > coolTimeMap[_mapIdx]
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
	
	utility.WaitMenuMode(_sleep)
	soundId = _sound.Play(playerRef)
	Sound.SetInstanceVolume(soundId, _volumn)
	return soundId
endFunction

function SoundVolumeUp(int _soundId, float _volume = 0.1)	
	if _volume > 0.5 
		_volume = 0.5
	endif
	Sound.SetInstanceVolume(_soundId, _volume)
endFunction

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

; action
Sound property SayActionHarvestedSound Auto			
Sound property SayActionBookReadSound Auto			
Sound property SayActionDragonSoulSound Auto
Sound property SayActionJumpUpSound Auto
Sound property SayActionLevelUpSound Auto
Sound property SayActionSitSound Auto
Sound property SayActionSitNakedSound Auto
Sound property SayActionSleepSound Auto
Sound property SayActionWaitSound Auto
Sound property SayActionTravelSound Auto
Sound property SayActionRidingSound Auto
Sound property SayActionSearchDeadBodySound Auto
Sound property SayActionSneakSound Auto
Sound property SayActionSuccessSound Auto

Sound property SayActionDialogueDrunkSound Auto		

Sound property SayActionDialogueAggressiveSound Auto

Sound property SayActionDialogueWarnSound Auto		
Sound property SayActionDialogueWarnChildSound Auto

Sound property SayActionDialogueNormalSound Auto		
Sound property SayActionDialogueNormalChildSound Auto
Sound property SayActionDialogueNormalGhostSound Auto
Sound property SayActionDialogueNormalEnemySound Auto			
Sound property SayActionDialogueNormalLoverSound Auto
Sound property SayActionDialogueNormalFriendSound Auto
Sound property SayActionDialogueNormalSoldierSound Auto
Sound property SayActionDialogueNormalUglySound Auto
Sound property SayActionDialogueNormalNobleSound Auto

Sound property SayDrinkHealthPotionSound Auto
Sound property SayDrinkMagicPotionSound Auto
Sound property SayDrinkStaminaPotionSound Auto
Sound property SayDrinkEtcPotionSound Auto

; etc
Sound property SayDefaultSound Auto
Sound property SayEtcMistakeSound Auto

; background
Sound property SayBgSneakModeSound Auto

; Faction
Faction property CWDialogueSoldierFaction Auto
Race    property OrcRace Auto
Race    property FalmerRace Auto