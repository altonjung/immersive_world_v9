scriptname ImmersivePcVoiceMonologueActorAlias extends ReferenceAlias

bool   isGameRunning

Actor  controlActor
ObjectReference overHairRef

bool   isControlling
bool   isLoadLocationChanged

string visitLocation
float[] coolTimeMap
float   collTimeForMonologue

Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume

Location prevVisitLocation

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
	RegisterForMenu("Dialogue Menu")
endFunction

; save -> load 시 호출
Event OnPlayerLoadGame()	
	isGameRunning = false
	SoundHelloPlay(SayHelloSound)	
	utility.WaitMenuMode(3.0)
	isGameRunning = true
	init()
EndEvent

function registerAction ()	
	RegisterForSleep()	
	regAnimation()
endFunction

function setup()
	isGameRunning = false
		
	visitLocation = ""	
	visitLocation = checkLocation(playerRef.GetCurrentLocation())

endFunction

function init ()	
	prevVisitLocation = None
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	isLoadLocationChanged = false

	overHairRef = None	
	controlActor = None
	isControlling = false

	collTimeForMonologue = 0.0

	soundCoolTime.SetValue(0.0)
	coolTimeMap = new float[30]	
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")	
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
endEvent

Event OnControlDown(string control)
		
	overHairRef = Game.GetCurrentCrosshairRef()
	Actor akActor = overHairRef as Actor

	; player와 대화 대상 찾기
	If akActor != none && !akActor.isDead() 
		isControlling = true
		controlActor = None
		
		if akActor.HasKeyWordString("ActorTypeNPC")	
			controlActor = akActor
			if PlayerRef.IsInCombat()				
				if playerRef.IsHostileToActor(akActor)
					SoundCoolTimePlay(SayDialogueWarnBatleEnemySound, _coolTime=2.0, _mapIdx=3, _mapCoolTime=5.0)
				else 
					if akActor.isChild()
						SoundCoolTimePlay(SayDialogueWarnBattleChildSound, _coolTime=2.0, _mapIdx=15, _mapCoolTime=5.0)
					else
						SoundCoolTimePlay(SayDialogueWarnBattleSound,  _coolTime=2.0, _mapIdx=15, _mapCoolTime=5.0)
					endif
				endif
				expression("angry")
			else
				int dialogueActorRelationShip = playerRef.GetRelationshipRank(akActor)
				; 강제로 hostile 대상으로 만들기
				if playerRef.IsHostileToActor(akActor) && dialogueActorRelationShip >= 0
					dialogueActorRelationShip = -1
				endif
				
				if akActor.isChild() 	; 아이
					if akActor.GetSleepState() == 3 ;sleeping
						; 자고있는 상태
						SoundCoolTimePlay(SayDialogueSleepChildSound,  _coolTime=2.0, _mapIdx=2, _mapCoolTime=7.0)
						expression("happy")							
					elseif  akActor.getFactionRank(WoundedFaction) > -2
						; 아픈 상태
						SoundCoolTimePlay(SayDialogueSickChildSound, _coolTime=2.0, _mapIdx=2, _mapCoolTime=7.0)
						expression("sad")				
					elseif PlayerNakeState.getValue() == 1 ; 주인공이 벗은상태
						SoundCoolTimePlay(SayDialogueShyNakeOnChildSound, _coolTime=2.0, _mapIdx=2, _mapCoolTime=7.0)
						expression("sad")
					else 							
						SoundCoolTimePlay(SayDialogueNormalChildSound,  _coolTime=2.0, _mapIdx=2, _mapCoolTime=7.0)
						expression("happy")					
					endif
				else 					; 어른						
					if akActor.IsGhost(); 귀신
						SoundCoolTimePlay(SayDialogueNormalGhostSound, _coolTime=2.0, _mapIdx=8, _mapCoolTime=7.0)
						expression("sad")						
					elseif  dialogueActorRelationShip == 4; 배우자
						if akActor.GetSleepState() == 3 ;sleeping
							SoundCoolTimePlay(SayDialogueSleepLoverSound,  _coolTime=2.0, _mapIdx=5, _mapCoolTime=7.0)
							expression("reset")													
						elseif akActor.GetActorValuePercentage("Health") <= 0.2
							SoundCoolTimePlay(SayDialogueSickLoverSound,  _coolTime=2.0, _mapIdx=5, _mapCoolTime=7.0)
							expression("sad")		
						else
							float currentHour = Utility.GetCurrentGameTime() * 24.0
							if currentHour < 3 || currentHour > 22
								SoundCoolTimePlay(SayDialogueNormalLoverLoveSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=7.0)
							else 
								SoundCoolTimePlay(SayDialogueNormalLoverSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=7.0)
							endif
							expression("happy")							
						endif
					elseif dialogueActorRelationShip < 0 ; 적
						SoundCoolTimePlay(SayDialogueNormalEnemySound,  _coolTime=2.0, _mapIdx=3, _mapCoolTime=7.0)
						expression("angry")	
					else
						if akActor.GetSleepState() == 3 ;sleeping
							SoundCoolTimePlay(SayDialogueSleepSound,  _coolTime=2.0, _mapIdx=14, _mapCoolTime=7.0)
							expression("reset")								
						elseif  akActor.getFactionRank(WoundedFaction) > -2
							SoundCoolTimePlay(SayDialogueSickSound,  _coolTime=2.0, _mapIdx=13, _mapCoolTime=7.0)
							expression("sad")
						else
							; LOG("isGuard " + akActor.IsGuard() + ", isJarl " + akActor.getFactionRank(JobJarlFaction) + ", isPostman " + akActor.getFactionRank(JobDeliveryFaction))
							if PlayerNakeState.getValue() == 1 ; 주인공이 벗은상태
								if akActor.getFactionRank(BanditFaction) > -2	; 산적들에게
									SoundCoolTimePlay(SayDialogueShyNakeOnBanditSound,  _coolTime=2.0, _mapIdx=10, _mapCoolTime=7.0)
								else 
									SoundCoolTimePlay(SayDialogueShyNakeSound,  _coolTime=2.0, _mapIdx=10, _mapCoolTime=7.0)
								endif
								expression("sad")
							elseif akActor.getFactionRank(CompanionFaction) == -2 && akActor.getFactionRank(CWDialogueSoldierFaction) > -2 ; 병사
								if Utility.RandomInt(0, 5) > 3
									SoundCoolTimePlay(SayDialogueNormalSound, _coolTime=2.0, _mapIdx=4, _mapCoolTime=7.0)
								else 
									SoundCoolTimePlay(SayDialogueNormalSoldierSound, _coolTime=2.0, _mapIdx=4, _mapCoolTime=7.0)
								endif 
								expression("reset")			
							elseif akActor.getFactionRank(CompanionFaction) == -2 && akActor.IsGuard() ; 경비병
								if Utility.RandomInt(0, 5) > 3
									SoundCoolTimePlay(SayDialogueNormalSound, _coolTime=2.0, _mapIdx=4, _mapCoolTime=7.0)
								else 
									SoundCoolTimePlay(SayDialogueNormalGuardSound, _coolTime=2.0, _mapIdx=4, _mapCoolTime=7.0)
								endif
								expression("reset")												
							elseif akActor.getFactionRank(DLC2RieklingFaction) > -2	; riekling
								elseif akActor.getFactionRank(JobJarlFaction) > -2	; jarl
								SoundCoolTimePlay(SayDialogueNormalJarlSound, _coolTime=2.0, _mapIdx=6, _mapCoolTime=7.0)
								expression("reset")
							elseif akActor.getFactionRank(JobPriestFaction) > -2 ; priest
								SoundCoolTimePlay(SayDialogueNormalPristSound, _coolTime=2.0, _mapIdx=6, _mapCoolTime=7.0)
								expression("reset")									
							elseif akActor.GetActorBase().getRace() == ElderRace ; elder
								SoundCoolTimePlay(SayDialogueNormalElderSound,  _coolTime=2.0, _mapIdx=6, _mapCoolTime=7.0)
								expression("reset")
							elseif dialogueActorRelationShip ==  2 ; friend
								SoundCoolTimePlay(SayDialogueNormalFriendSound, _coolTime=2.0, _mapIdx=7, _mapCoolTime=7.0)
								expression("happy")
							elseif dialogueActorRelationShip ==  3 ; follower
								SoundCoolTimePlay(SayDialogueNormalFollowerSound, _coolTime=2.0, _mapIdx=9, _mapCoolTime=7.0)
								expression("happy")														
							elseif dialogueActorRelationShip == 0 ; unknown								
								Armor _ActorArmor = akActor.GetWornForm(0x00000004) as Armor
								if _ActorArmor == None ; 타인이 벗은 상태
									if GetGender(akActor) == 1 ; female
										SoundCoolTimePlay(SayDialogueWarnNakedOnFemaleSound, _coolTime=2.0, _mapIdx=10, _mapCoolTime=7.0)
									else 
										SoundCoolTimePlay(SayDialogueWarnNakedOnMaleSound, _coolTime=2.0, _mapIdx=10, _mapCoolTime=7.0)
									endif
									; akActor.SendAssaultAlarm()																		
								else 																	
									if PlayerLocationInTown.getValue() == 1
										if akActor.getFactionRank(BeautyFaction) > -2 && Utility.RandomInt(0, 2) == 0
											if GetGender(akActor) == 1 ; female
												SoundCoolTimePlay(SayDialogueEnvyAppearanceBeautyOnFemaleSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=7.0)
											else 
												SoundCoolTimePlay(SayDialogueEnvyAppearanceBeautyOnMaleSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=7.0)
											endif
											expression("happy")
										elseif _ActorArmor.IsClothingRich() && Utility.RandomInt(0, 1) == 0
											if GetGender(akActor) == 1 ; female
												SoundCoolTimePlay(SayDialogueEnvyClothBeautyOnFemaleSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=7.0)
											else 
												SoundCoolTimePlay(SayDialogueEnvyClothBeautyOnMaleSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=7.0)
											endif
											expression("happy")
										else 
											SoundCoolTimePlay(SayDialogueNormalSound,  _coolTime=2.0, _mapIdx=10, _mapCoolTime=7.0)
											expression("reset")
										endif
									else 
										SoundCoolTimePlay(SayDialogueShySound, _coolTime=2.0, _mapIdx=10, _mapCoolTime=7.0)
										expression("reset")
									endif						
								endif
							else 
								SoundCoolTimePlay(SayDialogueShySound,  _coolTime=2.0, _mapIdx=10, _mapCoolTime=7.0)
								expression("reset")
							endif
						endif
					endif
				endif			
			endif
		elseif akActor.HasKeyWordString("ActorTypeAnimal")	
			if !playerRef.IsHostileToActor(akActor) 
				SoundCoolTimePlay(SayDefaultSound, _coolTime=2.0, _mapIdx=10, _mapCoolTime=5.0)
			endif
		endif
		isControlling = false
	endif	
endEvent

;
;	Menu
;
Event OnMenuOpen(string menuName)
	if menuName == "RaceSex Menu"			
		isGameRunning = false
		SoundHelloPlay(SayHelloSound)	
	elseif menuName == "Dialogue Menu"
		while isControlling
			Utility.WaitMenuMode(0.1)
		endWhile
	
		if controlActor == None || Game.GetCurrentCrosshairRef() == None
			Actor akActor  = Game.GetDialogueTarget() as Actor
		
			if akActor
				if playerRef.IsHostileToActor(akActor)
					SoundCoolTimePlay(SayDialogueWarnBatleEnemySound, _delay=0.5, _coolTime=2.0, _mapIdx=3, _mapCoolTime=10.0)
					expression("angry")
				else 
					if PlayerNakeState.GetValue() == 1		
						SoundCoolTimePlay(SayDialoguePassiveShySound, _delay=0.5, _coolTime=2.0, _mapIdx=12, _mapCoolTime=10.0)
						expression("sad")
					elseif akActor.getFactionRank(CompanionFaction) == -2 && akActor.IsGuard() ; guard
						SoundCoolTimePlay(SayDialoguePassiveGuardSound, _delay=0.5, _coolTime=2.0, _mapIdx=12, _mapCoolTime=10.0)
						expression("reset")
					elseif akActor.getFactionRank(JobDeliveryFaction) > -2	; postman
						SoundCoolTimePlay(SayDialoguePassivePostmanSound,_delay=0.5, _coolTime=2.0, _mapIdx=12, _mapCoolTime=10.0)
						expression("happy")
					elseif akActor.getFactionRank(JobJarlFaction) > -2	; jarl
						SoundCoolTimePlay(SayDialoguePassiveJarlSound,_delay=0.5, _coolTime=2.0, _mapIdx=12, _mapCoolTime=10.0)
						expression("reset")
					elseif PlayerDrunkState.GetValue() == 1
						SoundCoolTimePlay(SayDialoguePassiveSexySound, _delay=0.5, _coolTime=2.0, _mapIdx=12, _mapCoolTime=10.0)
						expression("happy")
					else 
						SoundCoolTimePlay(SayDialoguePassiveSound,_delay=0.5, _coolTime=2.0, _mapIdx=12, _mapCoolTime=10.0)	
						expression("happy")
					endif					
				endif
			endif
		endif
		
		controlActor = None		
	endif
endEvent

Event OnMenuClose(string menuName)		
	if menuName == "RaceSex Menu"			
		isGameRunning = true
	endif	
endEvent

;
;	Weather
;
Event OnWeatherChange(Weather akOldWeather, Weather akNewWeather)
	log("OnWeatherChange ")
	if !isGameRunning || playerRef.IsInCombat()
		return
	endif
	
	int _skyType = Weather.GetSkyMode()	

	if _skyType == 3
		int _weatherType = akNewWeather.GetClassification()	
		; -1 - No classification
		;  0 - Pleasant
		;  1 - Cloudy
		;  2 - Rainy
		;  3 - Snow
		if _weatherType == 0				
			if akOldWeather.GetClassification() == 3
				SoundCoolTimePlay(SayWeatherWarmSound, _delay=3.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=5.0)
			else
				SoundCoolTimePlay(SayWeatherSunnySound, _delay=3.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=5.0)
			endif
		elseif _weatherType == 2
			log("Rain ")
			SoundCoolTimePlay(SayWeatherRainySound, _delay=3.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=5.0)
		elseif _weatherType == 3
			log("Snow ")
			SoundCoolTimePlay(SayWeatherSnowSound, _delay=3.0, _coolTime=2.0, _mapIdx=3, _mapCoolTime=5.0)
		endif
	endif
EndEvent

;
;	Location
;
Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	if !isGameRunning || playerRef.IsInCombat()
		return
	endif

	prevVisitLocation = akOldLoc
	isLoadLocationChanged = true

	visitLocation = ""
	bool playMonologue = false
	int _skyMode = Weather.GetSkyMode()
	int _weatherType = Weather.GetCurrentWeather().GetClassification()

	float _currentTime = Utility.GetCurrentRealTime()	
	if _currentTime > collTimeForMonologue
		collTimeForMonologue = _currentTime + 30.0	; 30초간은 monologue 용 cooltime
		if 0.4 <= playerRef.GetActorValuePercentage("Stamina") && 0.5 <= playerRef.GetActorValuePercentage("Health")
			if _skyMode == 3
			; 야외
				if Utility.RandomInt(0, 1) == 0
					if playerRef.GetActorValuePercentage("Health") <= 0.3	&& _currentTime > coolTimeMap[27]
						SoundCoolTimePlay(SayStateLowHealthSound, _coolTime=3.0, _mapIdx=27, _mapCoolTime=60.0)					
					elseif PlayerNakeState.getValue() == 1 && _currentTime > coolTimeMap[20]
						SoundCoolTimePlay(SayStateNakedSound, _coolTime=3.0, _mapIdx=20, _mapCoolTime=300.0)
					elseif _weatherType == 2 && _currentTime > coolTimeMap[21]
						SoundCoolTimePlay(SayWeatherRainySound, _coolTime=3.0, _mapIdx=21, _mapCoolTime=300.0)
					elseif _weatherType == 3 && _currentTime > coolTimeMap[21]
						SoundCoolTimePlay(SayWeatherSnowSound, _coolTime=3.0, _mapIdx=21, _mapCoolTime=300.0)
					else
						Armor _boots = playerRef.GetWornForm(0x00000080) as Armor
						Armor _armor = playerRef.GetWornForm(0x00000004) as Armor

						if _boots == none && _currentTime > coolTimeMap[22]
							coolTimeMap[25] = 0.0
							SoundCoolTimePlay(SayStateBareFeetSound, _coolTime=10.0, _mapIdx=22, _mapCoolTime=600.0)							
						else
							if _armor 
								if _armor.IsClothingPoor() && _currentTime > coolTimeMap[23]									
									SoundCoolTimePlay(SayStatePoorClothesSound, _coolTime=10.0, _mapIdx=23, _mapCoolTime=300.0 * Utility.RandomInt(1, 2)) ; 5분 ~ 10분
								elseif (_armor.HasKeyWordString("ClothingSlutty") || _armor.HasKeyWordString("SOS_Revealing") || _armor.HasKeyWordString("ClothingSexy") || _armor.HasKeyWordString("ClothingBeauty")) && soundCoolTime.getValue() > coolTimeMap[24]
									SoundCoolTimePlay(SayStateUncomfortClothesSound, _coolTime=10.0, _mapIdx=24, _mapCoolTime=300.0 * Utility.RandomInt(1, 2)) ; 5분 ~ 10분
								else
									coolTimeMap[23] = 0.0
									coolTimeMap[24] = 0.0
									if _currentTime > coolTimeMap[25]
										SoundCoolTimePlay(SayStateComfortClothesSound, _coolTime=10.0, _mapIdx=25, _mapCoolTime=600.0) ; 10분
									else 
										playMonologue = true										
									endif
								endif
							elseif _boots && _boots.HasKeyWordString("ArmorHeels") && _currentTime > coolTimeMap[26]
								coolTimeMap[22] = 0.0
								SoundCoolTimePlay(SayStateUncomfortBootsSound, _coolTime=10.0, _mapIdx=26, _mapCoolTime=180.0)
							else 
								playMonologue = true								
							endif
						endif
					endif
				else
					playMonologue = true					
				endif

				if playMonologue
					; 모노로그 출력
					SoundCoolTimePlay(SayMonologueSound, _coolTime=10.0, _mapIdx=4,  _mapCoolTime=300.0 * Utility.RandomInt(2, 3)) ; 10분 ~ 15분
				endif				
			else 
			; 실내		
				playLocationSound(_skyMode)
			endif
		endif
	endif	 

	isLoadLocationChanged = false
EndEvent

Event OnCellLoad()
	Log("OnCellLoad")	

	location currentLocation = playerRef.GetCurrentLocation()
	if currentLocation.GetParent()
		prevVisitLocation = currentLocation.GetParent()
	endif 
	
	bool _skip = false
	while isLoadLocationChanged == true
		utility.WaitMenuMode(0.1)
		_skip = true
	endWhile

	if !_skip
		playLocationSound(Weather.GetSkyMode())
	endif
EndEvent

String function checkLocation(Location _location)	
	String _visitLocation = ""

	if _location				
		Location _pLocation = _location.GetParent() 
		if _pLocation			
			if _pLocation.HasKeyWordString("LocTypeTown") || _pLocation.HasKeyWordString("LocTypeCity") || _pLocation.HasKeyWordString("LocTypeSettlement") || _location.HasKeyWordString("LocTypeDwelling")
				PlayerLocationInTown.setValue(1)
			else 
				PlayerLocationInTown.setValue(0)
			endif
		else 
			if _pLocation.HasKeyWordString("LocTypeTown") || _pLocation.HasKeyWordString("LocTypeCity") || _pLocation.HasKeyWordString("LocTypeSettlement") || _location.HasKeyWordString("LocTypeDwelling")
				PlayerLocationInTown.setValue(1)
			else 
				PlayerLocationInTown.setValue(0)
			endif
		endif

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
				endif				
			endif									
		elseif _location.HasKeyWordString("LocTypeFalmerHive")
			_visitLocation = "falmerHive"
		elseif _location.HasKeyWordString("LocTypeBanditCamp")
			_visitLocation = "banditCamp"
		elseif _location.HasKeyWordString("LocTypeAnimalDen")
			_visitLocation = "animalDen"
		elseif _location.HasKeyWordString("LocTypeForswornCamp")
			_visitLocation = "forswornCamp"
		elseif _location.HasKeyWordString("LocTypeDraugrCrypt")
			_visitLocation = "draugrCrypt"			
		elseif _location.HasKeyWordString("LocTypeOrcStronghold")
			_visitLocation = "orcHold"
		elseif _location.HasKeyWordString("LocTypeHagravenNest")
			_visitLocation = "hagravenNest"
		elseif _location.HasKeyWordString("LocTypeVampireLair")
			_visitLocation = "vampireLair"	
		elseif _location.HasKeyWordString("LocTypeWarlockLair")
			_visitLocation = "warlockLair"	
		elseif _location.HasKeyWordString("LocTypeDungeon")
			_visitLocation = "dungeon"			
		else 				
			_visitLocation = "unknown"	
		endif
	endif
	
	; log("checkLocation " + _visitLocation)
	return _visitLocation
endFunction 

;
;	Trade
;
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)	
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
EndEvent

;
;	Sleep
;
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	init()
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
function playLocationSound(int skyMode)
	Location currentLocation = playerRef.GetCurrentLocation()
	visitLocation = checkLocation(currentLocation)
	; 0 - No sky (SM_NONE)
	; 1 - Interior (SM_INTERIOR)
	; 2 - Skydome only (SM_SKYDOME_ONLY)
	; 3 - Full sky (SM_FULL)					

	if skyMode <= 2; interior
		if currentLocation.HasKeyWordString("LocTypeClearable")
			if visitLocation == "falmerHive"
				; log("falmerHive location(c)")
				SoundCoolTimePlay(SayLocationFalmerHiveSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "animalDen"
				; log("animalDen location(c)")
				SoundCoolTimePlay(SayLocationAnimalDenSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "forswornCamp"
				; log("forswornCamp location(c)")
				SoundCoolTimePlay(SayLocationBanditCampSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "dungeon"
				; log("dungeon location(c)")
				SoundCoolTimePlay(SayLocationDungeonSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "banditCamp"
				; log("banditCamp location(c)")
				SoundCoolTimePlay(SayLocationBanditCampSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "draugrCrypt"
				; log("draugrCrypt location(c)")
				SoundCoolTimePlay(SayLocationDraugrCryptSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "vampireLair"
				; log("vampireLair location(c)")
				SoundCoolTimePlay(SayLocationVampireLairSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			else 
				SoundCoolTimePlay(SayLocationDungeonSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
				; log("unknown location(c)")
			endif
		else 
			if visitLocation == "home"
				; log("home location")
				SoundCoolTimePlay(SayLocationHomeSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "house"
				; log("house location")
				SoundCoolTimePlay(SayLocationHouseSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "inn"
				; log("inn location")
				SoundCoolTimePlay(SayLocationInnSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "store"
				; log("store location")
				SoundCoolTimePlay(SayLocationStoreSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "temple"
				; log("temple location")
				SoundCoolTimePlay(SayLocationTempleSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "barrack"
				; log("barrack location")
				SoundCoolTimePlay(SayLocationBarrackSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "castle"
				; log("castle location")
				SoundCoolTimePlay(SayLocationCastleSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			elseif visitLocation == "jail"
				; log("jail location")
				SoundCoolTimePlay(SayLocationJailSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)		
			elseif visitLocation == "orcHold"
				; log("orcHold location")
				SoundCoolTimePlay(SayLocationOrcHoldSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			else 						
				; log("unknown location")
				SoundCoolTimePlay(SayLocationUnknownSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)
			endif
		endif
	else 
		if prevVisitLocation.HasKeyWordString("LocTypeDungeon")		; dungeon 탈출
			SoundCoolTimePlay(SayLocationEscapeDungeonSound, _delay=1.0, _coolTime=5.0, _mapIdx=1, _mapCoolTime=30.0)			
		endif
	endif
endFunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
	if !isGameRunning || playerRef.IsInCombat() || playerRef.IsSwimming() 
		return
	endif 	

	float currentTime = Utility.GetCurrentRealTime()
	if isGameRunning && currentTime >= soundCoolTime.getValue() && currentTime >= coolTimeMap[_mapIdx]	 
		soundCoolTime.setValue(currentTime + _coolTime)
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime

		UnregisterForUpdate()
		if _delay != 0.0						
			runningCoolTimeSoundRes = _sound
			runningCoolTimeSoundVolume = _volume			
			RegisterForSingleUpdate(_delay)
		else 
			runningCoolTimeSoundRes = none
			runningCoolTimeSoundVolume = 0.0
			Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
		endif
	endif
endFunction

function SoundHelloPlay(Sound _sound, float _volumn = 0.8, float _coolTime = 3.0)
	soundCoolTime.setValue(Utility.GetCurrentRealTime() + _coolTime)
	Sound.SetInstanceVolume(_sound.Play(playerRef), _volumn)		
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
GlobalVariable property PlayerLocationInTown Auto

Actor property playerRef Auto

; hello
Sound property SayHelloSound Auto

; monologue
Sound property SayMonologueSound Auto			

; location
Sound property SayLocationInnSound Auto
Sound property SayLocationStoreSound Auto
Sound property SayLocationHomeSound Auto
Sound property SayLocationHouseSound Auto
Sound property SayLocationCastleSound Auto
Sound property SayLocationJailSound Auto
Sound property SayLocationTempleSound Auto
Sound property SayLocationBarrackSound Auto
Sound property SayLocationOrcHoldSound Auto

Sound property SayLocationDungeonSound Auto
Sound property SayLocationFalmerHiveSound Auto
Sound property SayLocationBanditCampSound Auto
Sound property SayLocationAnimalDenSound Auto
Sound property SayLocationDraugrCryptSound Auto
Sound property SayLocationVampireLairSound Auto
Sound property SayLocationEscapeDungeonSound Auto
Sound property SayLocationUnknownSound Auto

; state	
Sound property SayStateNakedSound Auto
Sound property SayStateBareFeetSound Auto
Sound property SayStateLowHealthSound Auto
Sound property SayStatePoorClothesSound Auto
Sound property SayStateComfortClothesSound Auto
Sound property SayStateUncomfortClothesSound Auto
Sound property SayStateUncomfortBootsSound Auto

; weather
Sound property SayWeatherSunnySound Auto
Sound property SayWeatherWarmSound Auto
Sound property SayWeatherRainySound Auto
Sound property SayWeatherSnowSound Auto

; dialogue
Sound property SayDialogueNormalSound Auto		
Sound property SayDialogueNormalChildSound Auto
Sound property SayDialogueNormalGhostSound Auto
Sound property SayDialogueNormalEnemySound Auto			
Sound property SayDialogueNormalLoverSound Auto
Sound property SayDialogueNormalLoverLoveSound Auto
Sound property SayDialogueNormalFriendSound Auto
Sound property SayDialogueNormalFollowerSound Auto
Sound property SayDialogueNormalSoldierSound Auto
Sound property SayDialogueNormalGuardSound Auto
Sound property SayDialogueNormalJarlSound Auto
Sound property SayDialogueNormalPristSound Auto
Sound property SayDialogueNormalElderSound Auto	
Sound property SayDialogueShySound Auto

Sound property SayDialoguePassiveSound Auto
Sound property SayDialoguePassiveGuardSound Auto
Sound property SayDialoguePassiveJarlSound Auto
Sound property SayDialoguePassivePostmanSound Auto
Sound property SayDialoguePassiveLoverSound Auto
Sound property SayDialoguePassiveShySound Auto
Sound property SayDialoguePassiveSexySound Auto
Sound property SayDialoguePassiveIrritatedSound Auto

Sound property SayDialogueEnvyAppearanceBeautyOnFemaleSound Auto
Sound property SayDialogueEnvyAppearanceBeautyOnMaleSound Auto

Sound property SayDialogueEnvyClothBeautyOnFemaleSound Auto
Sound property SayDialogueEnvyClothBeautyOnMaleSound Auto

Sound property SayDialogueWarnNakedOnFemaleSound Auto
Sound property SayDialogueWarnNakedOnMaleSound Auto

Sound property SayDialogueWarnBattleSound Auto
Sound property SayDialogueWarnBattleChildSound Auto
Sound property SayDialogueWarnBatleEnemySound Auto


Sound property SayDialogueShyNakeSound Auto
Sound property SayDialogueShyNakeOnChildSound Auto
Sound property SayDialogueShyNakeOnBanditSound Auto

Sound property SayDialogueSleepSound Auto		
Sound property SayDialogueSleepChildSound Auto
Sound property SayDialogueSleepLoverSound Auto

Sound property SayDialogueSickSound Auto		
Sound property SayDialogueSickChildSound Auto
Sound property SayDialogueSickLoverSound Auto

Sound property SayDefaultSound Auto

; Race
Race property ElderRace Auto

; Faction
Faction property BeautyFaction Auto
Faction property CompanionFaction Auto

Faction property CWDialogueSoldierFaction Auto
Faction property BanditFaction Auto
Faction property JobPriestFaction Auto
Faction property JobJarlFaction Auto
Faction property JobDeliveryFaction Auto
Faction property DLC2RieklingFaction Auto
Faction property HunterFaction Auto

Faction property WoundedFaction Auto