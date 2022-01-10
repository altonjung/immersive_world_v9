scriptname ImmersivePcVoiceActionActorAlias extends ReferenceAlias

string prevMenuAction
bool   isMenu

int    LockPickBgSoundId
int    playerCrimeGold

float  drunkenStartTime
float  soundCoolTime
Faction possibleCrimeFaction	
int    possibleCrimeGold
float[] coolTimeMap

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
	prevMenuAction = ""
	isMenu = false
endFunction

function init ()		
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	possibleCrimeGold = 0	
	LockPickBgSoundId = 0
	soundCoolTime = 0.0	
	coolTimeMap = new float[15] ; 0: normal, 1: dialog(child), 2: dialog(enemy), 3: dialog(lover), 4: dialog(friend), 5: dialog(soldier), 9: harvest
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")	

	; ride
	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseMount") 	
	RegisterForAnimationEvent(playerRef, "DragonMountEnter") 		

	; jump
	RegisterForAnimationEvent(playerRef, "JumpUp")	
	
endFunction

Event OnControlDown(string control)
	ObjectReference akObj = Game.GetCurrentCrosshairRef() 
	Actor akActor = akObj as Actor
	; player와 대화 대상 찾기
	If akActor != none			
		if akActor.isDead() || akActor.IsUnconscious()
			if !akActor.HasKeyWordString("ActorTypeCreature")
				SoundCoolTimePlay(SayActionSearchDeadBodySound, _volume=0.3, _delay=0.2, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5)
			endif			
			expression("sad")			
		else 			
			if PlayerRef.IsInCombat()
				if !akActor.HasKeyWordString("ActorTypeCreature")
					if playerRef.IsHostileToActor(akActor)
						SoundCoolTimePlay(SayActionDialogueAggressiveSound, _delay=0.2, _coolTime=3.0, _mapIdx=3, _mapCoolTime=5.0)
					else 
						if akActor.isChild()	
							SoundCoolTimePlay(SayActionDialogueWarnChildSound, _delay=0.2, _coolTime=3.0, _mapIdx=2, _mapCoolTime=5.0)
							expression("sad")
						else
							SoundCoolTimePlay(SayActionDialogueWarnSound, _delay=0.2, _coolTime=3.0, _mapIdx=5, _mapCoolTime=5.0)
							expression("sad")
						endif
					endif					
				endif
			else 
				if !akActor.HasKeyWordString("ActorTypeCreature")
					if PlayerDrunkState.getValue() > 0
						SoundCoolTimePlay(SayActionDialogueDrunkSound, _delay=0.2, _coolTime=3.0, _mapIdx=1, _mapCoolTime=10.0)
						expression("happy")		
					else 						
						int dialogueActorRelationShip = playerRef.GetRelationshipRank(akActor)
						log ("found actor with relation " + dialogueActorRelationShip)
						if dialogueActorRelationShip < 0 ;적과 이야기 시 적대적 대화 주고받기
							SoundCoolTimePlay(SayActionDialogueNormalEnemySound, _delay=0.2, _coolTime=3.0, _mapIdx=4, _mapCoolTime=30.0)
							expression("angry")		
						elseif dialogueActorRelationShip == 0 ; 모르는 대상과 인사 주고 받기														
							if akActor.IsGuard() || akActor.getFactionRank(CWDialogueSoldierFaction) > -1 ; guard or soldier
								SoundCoolTimePlay(SayActionDialogueNormalSoldierSound, _delay=0.2, _coolTime=3.0, _mapIdx=7, _mapCoolTime=15.0)
								expression("reset")
							elseif akActor.isChild() 	; 아이
								SoundCoolTimePlay(SayActionDialogueNormalChildSound, _delay=0.2, _coolTime=3.0, _mapIdx=3, _mapCoolTime=15.0)
								expression("happy")
							elseif akActor.IsGhost()	; 귀신
								SoundCoolTimePlay(SayActionDialogueNormalGhostSound, _delay=0.2, _coolTime=3.0, _mapIdx=8, _mapCoolTime=30.0)
								expression("happy")								
							else
								Armor _armor = akActor.GetWornForm(0x00000004) as Armor
								if _armor.IsClothingRich()
									SoundCoolTimePlay(SayActionDialogueNormalNobleSound, _delay=0.2, _coolTime=3.0, _mapIdx=9, _mapCoolTime=30.0)	
									expression("reset")								
								elseif _armor.IsClothingPoor() || (akActor.GetRace() == OrcRace || akActor.GetRace() == FalmerRace)
									SoundCoolTimePlay(SayActionDialogueNormalUglySound, _delay=0.2, _coolTime=3.0, _mapIdx=10, _mapCoolTime=30.0)								
									expression("angry")
								else
									SoundCoolTimePlay(SayActionDialogueNormalSound, _delay=0.2, _coolTime=3.0, _mapIdx=2, _mapCoolTime=30.0)	
									expression("reset")
								endif
							endif
						elseif dialogueActorRelationShip <= 3 ; friend
							SoundCoolTimePlay(SayActionDialogueNormalFriendSound, _delay=0.2, _coolTime=3.0, _mapIdx=6, _mapCoolTime=30.0)	
							expression("happy")
						elseif dialogueActorRelationShip == 4 ; lover
							SoundCoolTimePlay(SayActionDialogueNormalLoverSound, _delay=0.2, _coolTime=3.0, _mapIdx=5, _mapCoolTime=30.0)	
							expression("happy")
						endif
					endif
				endif
			endif			
		endif
	else 
		; 물건
	endif	
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventNAme == "JumpUp"
		SoundPlay(SayActionJumpUpSound, 0.2)
	elseif asEventName == "SoundPlay.NPCHorseMount"	|| asEventName == "DragonMountEnter"
		log("SoundPlay.NPCHorseMount")
		SoundCoolTimePlay(SayActionRidingSound, _delay=0.2, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5)		
	endif	
	; Log("OnAnimationEvent " + asEventName)
endEvent

Event OnBookRead(Book akBook)
	SoundCoolTimePlay(SayActionBookReadSound, _delay=0.2, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5)
	Log("OnBookRead")
EndEvent

Event OnDragonSoulGained(float afSouls)
	SoundCoolTimePlay(SayActionDragonSoulSound, _delay=0.2, _coolTime=5.0, _mapIdx=0, _mapCoolTime=5.0)
	Log("OnDragonSoulGained")
EndEvent

Event OnItemHarvested(Form akProduce)
	SoundCoolTimePlay(SayActionHarvestedSound, _delay=0.5, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
	Log("OnItemHarvested")
EndEvent

Event OnLevelIncrease(int aiLevel)
	SoundCoolTimePlay(SayActionLevelUpSound, _delay=0.2, _coolTime=2.0, _mapIdx=0, _mapCoolTime=2.0)
	Log("OnLevelIncrease")
EndEvent

; Event that is triggered when this actor sits in the furniture
Event OnSit(ObjectReference akFurniture)	
	bool isTable = false 		

	if akFurniture.HasKeywordString("CraftingCookpot")
		log("cooking")
	elseif akFurniture.HasKeywordString("CraftingSmithingForge")
		log("forge")
	elseif akFurniture.HasKeywordString("CraftingTanningRack")
		log("TanningRack")		
	elseif akFurniture.HasKeywordString("CraftingSmithingArmorTable")
		log("Smithing ArmorTable")		
	elseif akFurniture.HasKeywordString("CraftingSmithingSharpeningWheel")
		log("Smithing Sharpen")		
	elseif akFurniture.HasKeywordString("BYOHCarpenterTable")
		log("carpenter")
	elseif akFurniture.HasKeywordString("isGrainMill")
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
		log("unknown furniture ")
	endif

	if isTable
		if PlayerNakeState.getValue() == 1
			SoundCoolTimePlay(SayActionSitNakedSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		else
			SoundCoolTimePlay(SayActionSitSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		endif
	else 
		SoundCoolTimePlay(SayDefaultSound, _delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
	endif
	
	Log("OnSit")
EndEvent

; Event that is triggered when this actor leaves the furniture
Event OnGetUp(ObjectReference akFurniture)	
EndEvent

;
;	Menu
;
Event OnMenuOpen(string menuName)
	log("OnMenuOpen " + menuName)

	isMenu = true	
	prevMenuAction = ""

	if menuName == "MapMenu"		
		SoundPlay(SayActionTravelSound, _volume=0.5)		
	elseif menuName == "BarterMenu"
		prevMenuAction = "barter"
	elseif menuName == "ContainerMenu"
		; lockpick -> container
		if prevMenuAction == "lockpick"
			SoundPlay(SayActionSuccessSound,  _volume=0.5)
		endif
	elseif menuName == "Lockpicking Menu"
		Sound.StopInstance(LockPickBgSoundId)		
		LockPickBgSoundId = SoundBGPlay(SayBgSneakModeSound, 0.5)
		prevMenuAction = "lockpick"
		log("try lockpick")
	elseif menuName == "Sleep/Wait Menu"		
		if playerRef.GetSleepState() == 3
			SoundPlay(SayActionSleepSound, _volume=0.5)
			prevMenuAction = "sleep"
		else 
			SoundPlay(SayActionWaitSound, _volume=0.5)	
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
;	Doom Stone touch
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	log("OnMagicEffectApply")
	if akEffect.HasKeyWordString("StoneDoomEffect")		; doom
		SoundCoolTimePlay(SayActionRitualSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		Log("doom")		
	endif
EndEvent

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
function SoundCoolTimePlay(Sound _sound, float _volume = 0.5, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
	float currentTime = Utility.GetCurrentRealTime()
	if !playerRef.IsSwimming() && currentTime >= soundCoolTime && currentTime >= coolTimeMap[_mapIdx]	&& !playerRef.IsSwimming()		 
		soundCoolTime = currentTime + _coolTime
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
	endif
endFunction

function SoundPlay(Sound _sound, float _volume = 0.6)	
	if !playerRef.IsSwimming()		
		Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
	endif
endFunction

int function SoundBGPlay(Sound _sound, float _volume = 0.8)
	int soundId = 0
	
	if !playerRef.IsSwimming()
		soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(soundId, _volume)
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
Sound property SayActionRitualSound Auto

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

; sneak background
Sound property SayBgSneakModeSound Auto

; etc
Sound property SayDefaultSound Auto

; Faction
Faction property CWDialogueSoldierFaction Auto
Race    property OrcRace Auto
Race    property FalmerRace Auto


