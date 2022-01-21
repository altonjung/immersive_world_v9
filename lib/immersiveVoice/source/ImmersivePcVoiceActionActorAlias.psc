scriptname ImmersivePcVoiceActionActorAlias extends ReferenceAlias

string prevMenuAction

Actor  overHeadDialogActor

int    LockPickBgSoundId
int    playerCrimeGold

float  drunkenStartTime
Faction possibleCrimeFaction	
int    possibleCrimeGold
float[] coolTimeMap

Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume

Event OnInit()
	initMenu()	
EndEvent

event OnLoad()
	LOG("Action load..")
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
	RegisterForMenu("Dialogue Menu")	
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
endFunction

function init ()		
	overHeadDialogActor = None
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	possibleCrimeGold = 0	
	LockPickBgSoundId = 0
	coolTimeMap = new float[15] 
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")	
	
	; weapon/bow
	RegisterForAnimationEvent(playerRef, "weaponSwing")
	RegisterForAnimationEvent(playerRef, "weaponLeftSwing")

	; weapon
	RegisterForAnimationEvent(playerRef, "weaponDraw")
	; RegisterForAnimationEvent(playerRef, "weaponSheathe")	

	; ride
	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseMount") 	
	RegisterForAnimationEvent(playerRef, "DragonMountEnter") 		

	; jump
	RegisterForAnimationEvent(playerRef, "JumpUp")	
	
endFunction

Event OnControlDown(string control)
	overHeadDialogActor = None
	ObjectReference akObj = Game.GetCurrentCrosshairRef()
	Actor akActor = akObj as Actor

	; player와 대화 대상 찾기
	If akActor != none					
		if akActor.isDead() || akActor.IsUnconscious()
			if !akActor.HasKeyWordString("ActorTypeCreature")
				SoundCoolTimePlay(SayActionSearchDeadBodySound, _volume=0.3, _delay=0.0, _coolTime=1.5, _mapIdx=0, _mapCoolTime=1.5)
			endif			
			expression("sad")
		else
			if akActor.HasKeyWordString("ActorTypeNPC")
				overHeadDialogActor = akActor
				if PlayerRef.IsInCombat()				
					if playerRef.IsHostileToActor(akActor)
						SoundCoolTimePlay(SayActionDialogueAggressiveSound, _coolTime=2.0, _mapIdx=3, _mapCoolTime=5.0)
					else 
						if akActor.isChild()
							SoundCoolTimePlay(SayActionDialogueWarnBattleChildSound, _coolTime=2.0, _mapIdx=2, _mapCoolTime=5.0)
							expression("sad")
						else
							SoundCoolTimePlay(SayActionDialogueWarnBattleSound,  _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
							expression("sad")
						endif
					endif
				else

					int dialogueActorRelationShip = playerRef.GetRelationshipRank(akActor)
					Armor _ActorArmor = akActor.GetWornForm(0x00000004) as Armor
					; 강제로 hostile 대상으로 만들기
					if playerRef.IsHostileToActor(akActor) && dialogueActorRelationShip >= 0
						dialogueActorRelationShip = -1
					endif

					if akActor.isChild() 	; 아이
						SoundCoolTimePlay(SayActionDialogueNormalChildSound, _coolTime=2.0, _mapIdx=3, _mapCoolTime=15.0)
						expression("happy")
					elseif akActor.IsGhost(); 귀신
						SoundCoolTimePlay(SayActionDialogueNormalGhostSound, _coolTime=2.0, _mapIdx=8, _mapCoolTime=15.0)
						expression("happy")
					elseif 	_ActorArmor == None ; 타인이 벗은 상태
						SoundCoolTimePlay(SayActionDialogueWarnNakedSound, _coolTime=2.0, _mapIdx=10, _mapCoolTime=15.0)			
						akActor.SendAssaultAlarm()
					elseif akActor.IsGuard() || akActor.getFactionRank(CWDialogueSoldierFaction) > -1 ; 병사
						SoundCoolTimePlay(SayActionDialogueNormalSoldierSound, _coolTime=2.0, _mapIdx=7, _mapCoolTime=15.0)
						expression("reset")					
					elseif PlayerNakeState.getValue() == 1.0 ; 주인공이 벗은상태
						if akActor.getFactionRank(BanditFaction) > -1
							SoundCoolTimePlay(SayActionDialogueShyNakeOnBanditSound,  _coolTime=2.0, _mapIdx=4, _mapCoolTime=15.0)
						else 
							SoundCoolTimePlay(SayActionDialogueShyNakeSound,  _coolTime=2.0, _mapIdx=4, _mapCoolTime=15.0)
						endif
						expression("sad")	
					elseif dialogueActorRelationShip < 0 ; 적
						SoundCoolTimePlay(SayActionDialogueNormalEnemySound,  _coolTime=2.0, _mapIdx=4, _mapCoolTime=15.0)
						expression("angry")										
					elseif dialogueActorRelationShip == 0 ; 모르는 대상과 인사 주고 받기
						if _ActorArmor.IsClothingRich()
							if GetGender(akActor) == 1 ; female
								SoundCoolTimePlay(SayActionDialogueEnvyBeautySound, _coolTime=2.0, _mapIdx=9, _mapCoolTime=15.0)
							else 
								SoundCoolTimePlay(SayActionDialogueNormalNobleSound, _coolTime=2.0, _mapIdx=9, _mapCoolTime=15.0)
							endif
							expression("reset")								
						elseif _ActorArmor.IsClothingPoor()
							SoundCoolTimePlay(SayActionDialogueShyNakeSound, _coolTime=2.0, _mapIdx=10, _mapCoolTime=15.0)
							expression("angry")
						else 
							SoundCoolTimePlay(SayActionDialogueNormalSound,  _coolTime=2.0, _mapIdx=2, _mapCoolTime=15.0)
							expression("reset")
						endif												
					elseif dialogueActorRelationShip ==  2 ; friend
						SoundCoolTimePlay(SayActionDialogueNormalFriendSound, _coolTime=2.0, _mapIdx=6, _mapCoolTime=15.0)
						expression("happy")
					elseif dialogueActorRelationShip ==  3 ; ally (follower)
						SoundCoolTimePlay(SayActionDialogueNormalFollowerSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=15.0)
						expression("happy")						
					elseif dialogueActorRelationShip == 4 ; lover
						float currentHour = Utility.GetCurrentGameTime() * 24.0
						if currentHour < 6 || currentHour > 21
							SoundCoolTimePlay(SayActionDialogueNormalLoverLoveSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=15.0)
						else 
							SoundCoolTimePlay(SayActionDialogueNormalLoverSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=15.0)
						endif
						expression("happy")
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
	if playerRef.IsInCombat()
		return
	endif 

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
		if PlayerNakeState.getValue() == 1.0
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
	; log("OnMenuOpen " + menuName)
	
	prevMenuAction = ""

	if menuName == "MapMenu"		
		SoundPlay(SayActionTravelSound, _volume=0.5)
	elseif menuName == "Dialogue Menu"
		; passive dialogue
		Actor akActor  = playerRef.GetDialogueTarget()		

		if akActor
			if overHeadDialogActor != akActor
				; log("passive dialogue")
				if playerRef.IsHostileToActor(akActor)
					SoundCoolTimePlay(SayActionDialogueAggressiveSound, _delay=0.5, _coolTime=2.0, _mapIdx=3, _mapCoolTime=10.0)
					expression("angry")
				else 
					if akActor.IsGuard() || akActor.getFactionRank(CWDialogueSoldierFaction) > -1 ; guard or soldier
						SoundCoolTimePlay(SayActionDialogueNormalSoldierSound, _delay=0.5, _coolTime=2.0, _mapIdx=7, _mapCoolTime=15.0)
						expression("reset")
					elseif PlayerNakeState.GetValue() == 1.0		
						SoundCoolTimePlay(SayActionDialoguePassiveNakedSound, _delay=0.5, _coolTime=2.0, _mapIdx=2, _mapCoolTime=10.0)
						expression("sad")
					elseif PlayerDrunkState.GetValue() == 1.0						
						SoundCoolTimePlay(SayActionDialoguePassiveDrunkSound, _delay=0.5, _coolTime=2.0, _mapIdx=2, _mapCoolTime=10.0)
						expression("happy")
					else 
						SoundCoolTimePlay(SayActionDialoguePassiveSound,_delay=0.5, _coolTime=2.0, _mapIdx=2, _mapCoolTime=10.0)	
						expression("happy")
					endif					
				endif
			endif
		endif
		
		overHeadDialogActor = None
	elseif menuName == "ContainerMenu"
		; lockpick -> container
		if prevMenuAction == "lockpick"
			SoundPlay(SayActionSuccessSound,  _volume=0.7)
		endif
	elseif menuName == "Lockpicking Menu"
		Sound.StopInstance(LockPickBgSoundId)		
		LockPickBgSoundId = SoundBGPlay(SayBgSneakModeSound, 0.7)
		prevMenuAction = "lockpick"
		log("try lockpick")
	elseif menuName == "Sleep/Wait Menu"		
		if playerRef.GetSleepState() == 3
			SoundPlay(SayActionSleepSound, _volume=0.7)
		else 
			SoundPlay(SayActionWaitSound, _volume=0.7)	
		endif
	endif
endEvent

Event OnMenuClose(string menuName)
	; log("OnMenuClose")

	if menuName == "Lockpicking Menu"
		Sound.StopInstance(LockPickBgSoundId)
		LockPickBgSoundId = 0		
	elseif menuName == "Sleep/Wait Menu"
		Game.FadeOutGame(false, true, 0.5, 3.0)
	endif	
endEvent

;
;	Doom Stone touch
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	if playerRef.IsInCombat()
		return
	endif 

	; log("OnMagicEffectApply")
	if akEffect.HasKeyWordString("StoneDoomEffect")		; doom
		Log("doom")		
		if akEffect.HasKeyWordString("StoneDoomMaraEffect")		; doom
			SoundCoolTimePlay(SayActionRitualMaraSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		elseif akEffect.HasKeyWordString("StoneDoomTalosEffect")		; doom
			SoundCoolTimePlay(SayActionRitualMaraSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		elseif akEffect.HasKeyWordString("StoneDoomDebellaEffect")		; doom
			SoundCoolTimePlay(SayActionRitualDebellaSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		else 
			SoundCoolTimePlay(SayActionRitualSound,_delay=0.2, _coolTime=3.0, _mapIdx=0, _mapCoolTime=3.0)
		endif
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
function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
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

int function GetGender(Actor ActorRef) global
	if ActorRef
		ActorBase BaseRef = ActorRef.GetLeveledActorBase()
		return BaseRef.GetSex() ; Default
	endIf
	return 0 ; Invalid actor - default to male for compatibility
endFunction

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
Sound property SayActionRitualMaraSound Auto
Sound property SayActionRitualTalosSound Auto
Sound property SayActionRitualDebellaSound Auto

Sound property SayActionDialogueAggressiveSound Auto

Sound property SayActionDialoguePassiveSound Auto
Sound property SayActionDialoguePassiveNakedSound Auto
Sound property SayActionDialoguePassiveDrunkSound Auto

Sound property SayActionDialogueEnvyBeautySound Auto

Sound property SayActionDialogueWarnNakedSound Auto

Sound property SayActionDialogueWarnBattleSound Auto
Sound property SayActionDialogueWarnBattleChildSound Auto

Sound property SayActionDialogueShyNakeSound Auto

Sound property SayActionDialogueShyNakeOnBanditSound Auto

Sound property SayActionDialogueNormalSound Auto		
Sound property SayActionDialogueNormalChildSound Auto
Sound property SayActionDialogueNormalGhostSound Auto
Sound property SayActionDialogueNormalEnemySound Auto			
Sound property SayActionDialogueNormalLoverSound Auto
Sound property SayActionDialogueNormalLoverLoveSound Auto
Sound property SayActionDialogueNormalFriendSound Auto
Sound property SayActionDialogueNormalFollowerSound Auto
Sound property SayActionDialogueNormalSoldierSound Auto
Sound property SayActionDialogueNormalNobleSound Auto

; sneak background
Sound property SayBgSneakModeSound Auto

; etc
Sound property SayDefaultSound Auto

; Faction
Faction property CWDialogueSoldierFaction Auto
Faction property BanditFaction Auto