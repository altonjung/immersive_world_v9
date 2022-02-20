scriptname ImmersivePcVoiceMonologueActorAlias extends ReferenceAlias

Actor  controlActor
ObjectReference overHairRef

bool   isControlling
bool   isLoadLocationChanged

float[] coolTimeMap

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

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
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("RaceSex Menu")
	RegisterForMenu("Dialogue Menu")
endFunction

; save -> load 시 호출
Event OnPlayerLoadGame()
	if pcVoiceMCM.isPlayerFemale
		pcVoiceMCM.isGameRunning = false
		SoundHelloPlay(SayHelloSound)	
		utility.WaitMenuMode(3.0)
		pcVoiceMCM.isGameRunning = true
		init()	
	endif
EndEvent

function registerAction ()	
	RegisterForSleep()	
	regAnimation()
endFunction

function setup()
endFunction

function init ()
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeExpress = "happy"
	runningCoolTimeSoundCoolingTime = 0.0
	runningCoolTimeSoundCurtime = 0.0

	isLoadLocationChanged = false

	overHairRef = None	
	controlActor = None
	isControlling = false
	
	coolTimeMap = new float[30]
	; 1: location, 2: monologue, 3: weather
	; 5: npc
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")	
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
endEvent

Event OnControlDown(string control)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	overHairRef = Game.GetCurrentCrosshairRef()
	
	; 대화 대상 찾기
	If overHairRef != none
		int _type = overHairRef.getType()

		if _type == 43 || _type == 62
			Actor _akActor = overHairRef as Actor
			if _akActor && !_akActor.isDead()

				isControlling = true
				controlActor = None
				
				if _akActor.HasKeyWordString("ActorTypeNPC")	
					controlActor = _akActor
					int dialogueActorRelationShip = playerRef.GetRelationshipRank(_akActor)

					; 강제로 hostile 대상으로 만들기
					if playerRef.IsHostileToActor(_akActor) && dialogueActorRelationShip >= 0
						dialogueActorRelationShip = -1
					endif

					if PlayerRef.IsInCombat()		
						if _akActor.isChild()
							SoundCoolTimePlay(SayDialogueWarnBattleChildSound, _coolTime=2.0, _mapIdx=8, _mapCoolTime=5.0, _express="angry")
						else
							if dialogueActorRelationShip < -1 ; 적
								SoundCoolTimePlay(SayDialogueWarnBatleEnemySound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _express="angry")
							else 
								SoundCoolTimePlay(SayDialogueWarnBattleSound,  _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _express="angry")
							endif
						endif
					else				
						; Bard 가 노래를 부르고 있는 상태
					    if _akActor.getFactionRank(BardSingerFaction) >= 0 && _akActor.GetCurrentPackage() as Package == BardSongTravelPackage
							SoundCoolTimePlay(SayDialogueNormalHummingSound, _volume = 0.6, _coolTime=13.0, _mapIdx=5, _mapCoolTime=13.0)
						else 
							if _akActor.isChild() 	; 아이
								if  _akActor.getFactionRank(WoundedFaction) > -2  ; 아픈 상태						
									SoundCoolTimePlay(SayDialogueSickChildSound, _coolTime=2.0, _mapIdx=4, _mapCoolTime=5.0, _express="sad")					
								elseif _akActor.GetSleepState() == 3  ; 자고있는 상태						
									SoundCoolTimePlay(SayDialogueSleepChildSound,  _coolTime=2.0, _mapIdx=4, _mapCoolTime=5.0, _express="happy")			
								elseif pcVoiceMCM.isNaked ; 주인공이 벗은상태
									SoundCoolTimePlay(SayDialogueShyNakeOnChildSound, _coolTime=2.0, _mapIdx=4, _mapCoolTime=5.0, _express="sad")
								else 							
									SoundCoolTimePlay(SayDialogueNormalChildSound,  _coolTime=2.0, _mapIdx=4, _mapCoolTime=5.0)
								endif
							elseif dialogueActorRelationShip == 4; 배우자 			
								if  _akActor.getFactionRank(WoundedFaction) > -2 ; 아픈 상태	
									SoundCoolTimePlay(SayDialogueSickSound,  _coolTime=2.0, _mapIdx=6, _mapCoolTime=5.0, _express="sad")						
								elseif _akActor.GetSleepState() == 3 ; 자고있는 상태
									SoundCoolTimePlay(SayDialogueSleepLoverSound,  _coolTime=2.0, _mapIdx=6, _mapCoolTime=5.0)
								elseif _akActor.GetActorValuePercentage("Health") <= 0.2
									SoundCoolTimePlay(SayDialogueSickLoverSound,  _coolTime=2.0, _mapIdx=6, _mapCoolTime=5.0, _express="sad")
								else
									float currentHour = Utility.GetCurrentGameTime() * 24.0
									if  currentHour >= 23 || currentHour <= 5
										SoundCoolTimePlay(SayDialogueNormalLoverLoveSound, _coolTime=2.0, _mapIdx=6, _mapCoolTime=5.0)
									else 
										SoundCoolTimePlay(SayDialogueNormalLoverSound, _coolTime=2.0, _mapIdx=6, _mapCoolTime=5.0, _useDefaultSound=true)
									endif
								endif	
							else
								Armor _akActorArmor = _akActor.GetWornForm(0x00000004) as Armor
								if  _akActor.getFactionRank(WoundedFaction) > -2 ; 아픈 상태	
									SoundCoolTimePlay(SayDialogueSickSound,  _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _express="sad")						
								elseif _akActor.GetSleepState() == 3; 자고있는 상태
									SoundCoolTimePlay(SayDialogueSleepSound,  _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
								elseif _akActorArmor == None	; 나체있는 상태
									if pcVoiceMCM.GetGender(_akActor) == 1 ; female
										SoundCoolTimePlay(SayDialogueNormalNakedOnFemaleSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
									else
										SoundCoolTimePlay(SayDialogueNormalNakedOnMaleSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
									endif
								elseif pcVoiceMCM.isDrunken	; 주인공이 술취한 상태
									SoundCoolTimePlay(SayDialogueDrunkSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
								elseif _akActor.getFactionRank(BardSingerFaction) >= 0 ; 노래를 부를 수 있는 bard
									SoundCoolTimePlay(SayDialogueNormalSingSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)		
								elseif _akActor.getFactionRank(JobJarlFaction) > -2	; jarl
									SoundCoolTimePlay(SayDialogueNormalJarlSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=5.0)	
								elseif _akActor.getFactionRank(CurrentFollowerFaction) > -1; follower
									if _akActor.getFactionRank(PlayerHousecarlFaction) > -1; housecarl
										SoundCoolTimePlay(SayDialogueNormalHouseCarlSound, _coolTime=2.0, _mapIdx=7, _mapCoolTime=5.0, _useDefaultSound=true)						
									else
										SoundCoolTimePlay(SayDialogueNormalFollowerSound, _coolTime=2.0, _mapIdx=7, _mapCoolTime=5.0, _useDefaultSound=true)
									endif									
								elseif dialogueActorRelationShip == 3 || dialogueActorRelationShip ==  2 ; ally
									SoundCoolTimePlay(SayDialogueNormalAllySound, _coolTime=2.0, _mapIdx=12, _mapCoolTime=5.0, _useDefaultSound=true)
								elseif dialogueActorRelationShip == 1 ; Friend
									SoundCoolTimePlay(SayDialogueNormalFriendSound, _coolTime=2.0, _mapIdx=12, _mapCoolTime=5.0, _useDefaultSound=true)
								elseif dialogueActorRelationShip == -1 ; rival
									SoundCoolTimePlay(SayDialogueNormalRivalSound, _coolTime=2.0, _mapIdx=12, _mapCoolTime=5.0)
								elseif dialogueActorRelationShip < -2 ; enemy
									SoundCoolTimePlay(SayDialogueNormalEnemySound,  _coolTime=2.0, _mapIdx=8, _mapCoolTime=5.0, _express="sad")								
								else
									if _akActor.getFactionRank(BeautyFaction) > -2 && Utility.RandomInt(0, 2) == 0
										if pcVoiceMCM.GetGender(_akActor) == 1 ; female
											SoundCoolTimePlay(SayDialogueNormalFaceBeautyOnFemaleSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _useDefaultSound=true)
										else 
											SoundCoolTimePlay(SayDialogueNormalFaceBeautyOnMaleSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _useDefaultSound=true)
										endif
									else		
										if _akActor.getFactionRank(CompanionFaction) == -2 && _akActor.IsGuard() ; 경비병
											if Utility.RandomInt(0, 2) == 2
												SoundCoolTimePlay(SayDialogueNormalSound, _coolTime=2.0, _mapIdx=10, _mapCoolTime=5.0)
											else 
												SoundCoolTimePlay(SayDialogueNormalGuardSound, _coolTime=2.0, _mapIdx=10, _mapCoolTime=5.0)
											endif																														
										elseif _akActor.getFactionRank(CompanionFaction) == -2 && _akActor.getFactionRank(CWDialogueSoldierFaction) > -2 ; 병사
											if Utility.RandomInt(0, 2) == 2
												SoundCoolTimePlay(SayDialogueNormalSound, _coolTime=2.0, _mapIdx=9, _mapCoolTime=5.0)
											else 
												SoundCoolTimePlay(SayDialogueNormalSoldierSound, _coolTime=2.0, _mapIdx=9, _mapCoolTime=5.0)
											endif
										elseif _akActor.getFactionRank(JobBlackSmithFaction) > -2 || _akActor.getFactionRank(JobMerchantFaction) > -2 || _akActor.getFactionRank(JobInnKeeperFaction) > -2
											SoundCoolTimePlay(SayDialogueNormalSellerSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=5.0, _useDefaultSound=true)
										elseif _akActor.GetActorBase().getRace() == ElderRace ; elder
											SoundCoolTimePlay(SayDialogueNormalElderSound,  _coolTime=2.0, _mapIdx=11, _mapCoolTime=5.0)											
										elseif _akActor.getFactionRank(JobBardFaction) > -2 ; bard
											SoundCoolTimePlay(SayDialogueNormalBardSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=5.0, _useDefaultSound=true)
										elseif _akActor.getFactionRank(JobPriestFaction) > -2 ; priest
											SoundCoolTimePlay(SayDialogueNormalPristSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=5.0)
										elseif _akActor.getFactionRank(JobDeliveryFaction) > -2	; postman
											SoundCoolTimePlay(SayDialogueNormalPostmanSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=5.0)						
										elseif _akActor.getFactionRank(jobBeggerFaction) > -2 ; begger
											SoundCoolTimePlay(SayDialogueNormalBeggerSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=5.0)												 
										elseif _akActor.getFactionRank(BanditFaction) > -2	; 우호적인 산적
											if pcVoiceMCM.isNaked ; 주인공이 벗은상태
												if _akActor.HasKeyWordString("BanditChief")
													SoundCoolTimePlay(SayDialogueShyNakeOnBanditChiefSound,  _coolTime=2.0, _mapIdx=8, _mapCoolTime=5.0, _express="sad")
												else
													SoundCoolTimePlay(SayDialogueShyNakeOnBanditSound,  _coolTime=2.0, _mapIdx=8, _mapCoolTime=5.0, _express="sad")
												endif
											else 
												SoundCoolTimePlay(SayDialogueShySound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _express="shy")
											endif									
										elseif _akActor.getFactionRank(DLC2RieklingFaction) > -2	; riekling
										elseif _akActor.IsGhost()	; ghost
											SoundCoolTimePlay(SayDialogueNormalGhostSound, _coolTime=2.0, _mapIdx=11, _mapCoolTime=5.0, _express="sad")									
										else
											if pcVoiceMCM.isInTown
												SoundCoolTimePlay(SayDialogueNormalSound,  _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
											else 
												SoundCoolTimePlay(SayDialogueShySound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _express="shy")
											endif
										endif								
									endif
								endif
							endif
						endif
					endif
				elseif _akActor.HasKeyWordString("ActorTypeAnimal")	
					if !playerRef.IsHostileToActor(_akActor) 
						SoundCoolTimePlay(SayDefaultSound, _delay = 1.0, _coolTime=2.0, _mapIdx=13, _mapCoolTime=5.0)
					endif
				endif
				isControlling = false
			endif
		endif
	endif	
endEvent

;
;	Menu
;
Event OnMenuOpen(string menuName)	
	; log("menu " + menuName)
	if menuName == "RaceSex Menu"			
	elseif menuName == "InventoryMenu"
		pcVoiceMCM.isInventoryMenuMode = true
	elseif menuName == "Dialogue Menu"
		while isControlling
			Utility.WaitMenuMode(0.1)
		endWhile
	
		if controlActor == None || Game.GetCurrentCrosshairRef() == None
			Actor akActor  = Game.GetDialogueTarget() as Actor
		
			if akActor
				if playerRef.IsHostileToActor(akActor)
					SoundCoolTimePlay(SayDialogueWarnBatleEnemySound, _delay=0.5, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _express="angry")
				else 
					if pcVoiceMCM.isNaked		
						SoundCoolTimePlay(SayDialoguePassiveShySound, _delay=0.5, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _express="sad")
					elseif akActor.GetWornForm(0x00000004) as Armor	== None  ; naked
						SoundCoolTimePlay(SayDialoguePassiveScunSound, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
					elseif akActor.getFactionRank(CompanionFaction) == -2 && akActor.IsGuard() ; guard
						SoundCoolTimePlay(SayDialoguePassiveGuardSound, _delay=0.5, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
					elseif akActor.getFactionRank(JobDeliveryFaction) > -2	; postman
						SoundCoolTimePlay(SayDialoguePassivePostmanSound,_delay=0.5, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
					elseif akActor.getFactionRank(JobJarlFaction) > -2	; jarl
						SoundCoolTimePlay(SayDialoguePassiveJarlSound,_delay=0.5, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
					elseif akActor.isChild() 
						SoundCoolTimePlay(SayDialoguePassiveChildSound,_delay=0.5, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)

					elseif pcVoiceMCM.isDrunken
						SoundCoolTimePlay(SayDialoguePassiveDrunkSound, _delay=0.5, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0, _useDefaultSound=true)
					else 
						SoundCoolTimePlay(SayDialoguePassiveSound,_delay=0.5, _coolTime=2.0, _mapIdx=5, _mapCoolTime=5.0)
					endif					
				endif
			endif
		endif
		controlActor = None
	endif
endEvent

Event OnMenuClose(string menuName)
	if menuName == "RaceSex Menu"
		if pcVoiceMCM.isGameRunning == false
			
			pcVoiceMCM.isPlayerFemale = pcVoiceMCM.getGender(playerRef)
			if pcVoiceMCM.isPlayerFemale
				SoundWelcomePlay(SayWelcomeSound)
				pcVoiceMCM.isGameRunning = true					
			else 
				SoundWelcomePlay(SayNotSupportSound)
				pcVoiceMCM.disableOption()
			endif
		endif
	elseif menuName == "InventoryMenu"
		pcVoiceMCM.isInventoryMenuMode = false
	endif
endEvent

;
;	Weather
;
Event OnWeatherChange(Weather akOldWeather, Weather akNewWeather)
	log("OnWeatherChange ")

	pcVoiceMCM.updateField(playerRef)	
	int _weatherType = akNewWeather.GetClassification()	
	pcVoiceMCM.setWeather(_weatherType)	

	if pcVoiceMCM.isGameRunning && pcVoiceMCM.isInField && pcVoiceMCM.isInPrevField
		; -1 - No classification
		;  0 - Pleasant
		;  1 - Cloudy
		;  2 - Rainy
		;  3 - Snow
		if akOldWeather && akOldWeather.GetClassification() == 3
			if _weatherType == 0
				SoundCoolTimePlay(SayWeatherWarmSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=7.0)			
			endif
		elseif akOldWeather && akOldWeather.GetClassification() == 2
			if _weatherType == 0
				SoundCoolTimePlay(SayWeatherSunnySound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=7.0)			
			endif
		endif
	endif
EndEvent

;
;	Location
;
Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	log("OnLocationChange")	

	pcVoiceMCM.prevLocation = akNewLoc
	isLoadLocationChanged = true
	
	pcVoiceMCM.updateField(playerRef)	
	pcVoiceMCM.updateLocation(playerRef)
	pcVoiceMCM.updateWeather(playerRef)

	if pcVoiceMCM.isInField 
	   pcVoiceMCM.enterFirstTravel = true
	endif

	if pcVoiceMCM.isGameRunning	
		if 0.15 <= playerRef.GetActorValuePercentage("Stamina") && 0.3 <= playerRef.GetActorValuePercentage("Health")
			playLocationSound()
		endif
	endif

	isLoadLocationChanged = false
EndEvent

Event OnCellLoad()
	; Log("OnCellLoad")

	bool _skip = false
	while isLoadLocationChanged == true
		utility.WaitMenuMode(0.1)
		_skip = true
	endWhile

	if !_skip
		pcVoiceMCM.updateField(playerRef)
		pcVoiceMCM.updateLocation(playerRef)
		pcVoiceMCM.updateWeather(playerRef)
		if pcVoiceMCM.isGameRunning
			playLocationSound()
		endif
	endif
EndEvent

;
;	Sleep
;
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	init()
EndEvent

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
function playMonologueSound(bool _shortCoolTime)

	; log("playMonologueSound")

	bool _shouldPlayEtc = false

	float _currentHour = (Utility.GetCurrentGameTime() * 24.0) as Int % 24
	float _currentTime = Utility.GetCurrentRealTime()

	if (_currentHour >= 23 || _currentHour <= 3) && _currentTime > coolTimeMap[24]
		SoundCoolTimePlay(SayDayNightSound, _coolTime=10.0, _mapIdx=24,  _mapCoolTime=300.0)
	; elseif _currentHour > 6 || _currentHour <= 8
	; 	SoundCoolTimePlay(SayDayMorningSound, _coolTime=10.0, _mapIdx=20,  _mapCoolTime=7.0)
	else
		_shouldPlayEtc = true
		if pcVoiceMCM.isInRiften
			if Utility.RandomInt(0, 2) > 0
				SoundCoolTimePlay(SayAreaRiftenSound, _coolTime=10.0, _mapIdx=20,  _mapCoolTime=30.0)
				_shouldPlayEtc = false
			endif	
		elseif pcVoiceMCM.isInRiverwood
			if Utility.RandomInt(0, 2) > 0
				SoundCoolTimePlay(SayAreaRiverWoodSound, _coolTime=10.0, _mapIdx=20,  _mapCoolTime=30.0)
				_shouldPlayEtc = false
			endif
		elseif pcVoiceMCM.isInWhiterun
			if Utility.RandomInt(0, 2) > 0
				SoundCoolTimePlay(SayAreaWhiteRunSound, _coolTime=10.0, _mapIdx=20,  _mapCoolTime=30.0)
				_shouldPlayEtc = false
			endif
		elseif pcVoiceMCM.isInSolitude
			if Utility.RandomInt(0, 2) > 0
				SoundCoolTimePlay(SayAreaSolitudeRunSound, _coolTime=10.0, _mapIdx=20,  _mapCoolTime=30.0)
				_shouldPlayEtc = false
			endif		
		elseif pcVoiceMCM.isInCampsite
			SoundCoolTimePlay(SayAreaCampSiteSound, _coolTime=10.0, _mapIdx=20,  _mapCoolTime=30.0)
			_shouldPlayEtc = false
		endif

		if _shouldPlayEtc
			if _shortCoolTime
				SoundCoolTimePlay(SayMonologueSound, _coolTime=10.0)
			else 
				SoundCoolTimePlay(SayMonologueSound, _coolTime=10.0, _mapIdx=2, _mapCoolTime=300 * Utility.RandomInt(2, 3))
			endif
		endif
	endif
endfunction 

function playLocationSound()

	; log("playLocationSound")

	if pcVoiceMCM.isInField
		; cave -> field
		float _currentTime = Utility.GetCurrentRealTime()
		if !pcVoiceMCM.isInPrevField		
			if pcVoiceMCM.prevLocation && pcVoiceMCM.prevLocation.HasKeyWordString("LocTypeClearable")
				SoundCoolTimePlay(SayLocationEscapeDungeonSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.weatherType == 2 && _currentTime > coolTimeMap[3]
				SoundCoolTimePlay(SayWeatherRainySound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=300.0)
			elseif pcVoiceMCM.weatherType == 3 && _currentTime > coolTimeMap[3]
				SoundCoolTimePlay(SayWeatherSnowSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=300.0)
			else 
				playMonologueSound(true)
			endif
		else 		
			; field -> field
			if pcVoiceMCM.isLocationClearable
				SoundCoolTimePlay(SayLocationClearanceSound, _coolTime=10.0, _mapIdx=23, _mapCoolTime=30.0)
			elseif pcVoiceMCM.weatherType == 2 && _currentTime > coolTimeMap[3]
				SoundCoolTimePlay(SayWeatherRainySound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=300.0)
			elseif pcVoiceMCM.weatherType == 3 && _currentTime > coolTimeMap[3]
				SoundCoolTimePlay(SayWeatherSnowSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=300.0)				
			else
				playMonologueSound(false)
			endif
		endif
	else
		if pcVoiceMCM.isLocationClearable
			if pcVoiceMCM.isInFalmerHive
				; log("falmerHive location(c)")
				SoundCoolTimePlay(SayLocationFalmerHiveSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInAnimalDen
				; log("animalDen location(c)")
				SoundCoolTimePlay(SayLocationAnimalDenSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInForswornCamp
				; log("forswornCamp location(c)")
				SoundCoolTimePlay(SayLocationBanditCampSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInBanditCamp
				; log("banditCamp location(c)")
				SoundCoolTimePlay(SayLocationBanditCampSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInDraugrCrypt
				; log("draugrCrypt location(c)")
				SoundCoolTimePlay(SayLocationDraugrCryptSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInVampireLair
				; log("vampireLair location(c)")
				SoundCoolTimePlay(SayLocationVampireLairSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInOrcHoldAuto
				; log("orcHold location")
				SoundCoolTimePlay(SayLocationOrcHoldSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)				
			else
				SoundCoolTimePlay(SayLocationDungeonSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
				; log("unknown location(c)")
			endif
		else 
			if pcVoiceMCM.isInHome
				; log("home location")
				SoundCoolTimePlay(SayLocationHomeSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInHouse
				; log("house location")
				SoundCoolTimePlay(SayLocationHouseSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInMotel
				; log("inn location")
				SoundCoolTimePlay(SayLocationInnSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInStore
				; log("store location")
				SoundCoolTimePlay(SayLocationStoreSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInTemple
				; log("temple location")
				SoundCoolTimePlay(SayLocationTempleSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInBarrack
				; log("barrack location")
				SoundCoolTimePlay(SayLocationBarrackSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInCastle
				; log("castle location")
				SoundCoolTimePlay(SayLocationCastleSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			elseif pcVoiceMCM.isInJail
				; log("jail location")
				SoundCoolTimePlay(SayLocationJailSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)		
			elseif pcVoiceMCM.isInOrcHoldAuto
				; log("orcHold location")
				SoundCoolTimePlay(SayLocationOrcHoldSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			else 						
				; log("unknown location")
				SoundCoolTimePlay(SayLocationUnknownSound, _delay=1.0, _coolTime=10.0, _mapIdx=1, _mapCoolTime=7.0)
			endif
		endif
	endif
endFunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0, string _express = "happy", bool _useDefaultSound = false)
	if playerRef.IsInCombat() || playerRef.IsSwimming() || pcVoiceMCM.isSit
		return
	endif

	if _useDefaultSound 
		if Utility.randomInt(0,3) == 0
			_sound = SayDefaultSound
		endif
	endif

	float currentTime = Utility.GetCurrentRealTime()
	; log("currentTime " + currentTime + ", colTime " + pcVoiceMCM.soundCoolTime + ", mapColTime " + coolTimeMap[_mapIdx])
	if currentTime >= pcVoiceMCM.soundCoolTime && currentTime >= coolTimeMap[_mapIdx]	 
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

function SoundWelcomePlay(Sound _sound, float _volumn = 0.4, float _coolTime = 2.0)	
	pcVoiceMCM.soundCoolTime = Utility.GetCurrentRealTime() + _coolTime
	Sound.SetInstanceVolume(_sound.Play(playerRef), _volumn)
endFunction


function SoundHelloPlay(Sound _sound, float _volumn = 0.4, float _coolTime = 2.0)
	if pcVoiceMCM.isPlayerFemale
		pcVoiceMCM.expression(playerRef, "happy")
		pcVoiceMCM.soundCoolTime = Utility.GetCurrentRealTime() + _coolTime
		Sound.SetInstanceVolume(_sound.Play(playerRef), _volumn)
	endif
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

ImmersivePcVoiceMCM property pcVoiceMCM Auto

Actor property playerRef Auto

; hello
Sound property SayHelloSound Auto
Sound property SayWelcomeSound Auto
Sound property SayNotSupportSound Auto

; monologue
Sound property SayMonologueSound Auto	

; day
Sound property SayDayNightSound Auto
Sound property SayDayMorningSound Auto

; Area
Sound property SayAreaRiftenSound Auto
Sound property SayAreaRiverWoodSound Auto
Sound property SayAreaWhiteRunSound Auto
Sound property SayAreaSolitudeRunSound Auto
Sound property SayAreaCampSiteSound Auto

; location
Sound property SayLocationClearanceSound Auto

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

; weather
Sound property SayWeatherSunnySound Auto
Sound property SayWeatherWarmSound Auto
Sound property SayWeatherRainySound Auto
Sound property SayWeatherSnowSound Auto

; dialogue
Sound property SayDialogueNormalSound Auto
Sound property SayDialogueNormalSellerSound Auto
Sound property SayDialogueNormalBeggerSound Auto
Sound property SayDialogueNormalSingSound  Auto
Sound property SayDialogueNormalHummingSound  Auto
Sound property SayDialogueNormalBardSound  Auto
Sound property SayDialogueNormalChildSound Auto
Sound property SayDialogueNormalGhostSound Auto
Sound property SayDialogueNormalEnemySound Auto
Sound property SayDialogueNormalPostmanSound Auto
Sound property SayDialogueNormalLoverSound Auto
Sound property SayDialogueNormalLoverLoveSound Auto
Sound property SayDialogueNormalFriendSound Auto
Sound property SayDialogueNormalFollowerSound Auto
Sound property SayDialogueNormalRivalSound  Auto
Sound property SayDialogueNormalAllySound Auto
Sound property SayDialogueNormalHouseCarlSound Auto
Sound property SayDialogueNormalSoldierSound Auto
Sound property SayDialogueNormalGuardSound Auto
Sound property SayDialogueNormalJarlSound Auto
Sound property SayDialogueNormalPristSound Auto
Sound property SayDialogueNormalElderSound Auto
Sound property SayDialogueNormalNakedOnFemaleSound Auto
Sound property SayDialogueNormalNakedOnMaleSound Auto
Sound property SayDialogueNormalFaceBeautyOnFemaleSound Auto
Sound property SayDialogueNormalFaceBeautyOnMaleSound Auto

Sound property SayDialoguePassiveSound Auto
Sound property SayDialoguePassiveGuardSound Auto
Sound property SayDialoguePassiveJarlSound Auto
Sound property SayDialoguePassivePostmanSound Auto
Sound property SayDialoguePassiveLoverSound Auto
Sound property SayDialoguePassiveChildSound  Auto
Sound property SayDialoguePassiveShySound Auto
Sound property SayDialoguePassiveDrunkSound Auto
Sound property SayDialoguePassiveScunSound Auto

Sound property SayDialogueWarnBattleSound Auto
Sound property SayDialogueWarnBattleChildSound Auto
Sound property SayDialogueWarnBatleEnemySound Auto

Sound property SayDialogueShySound Auto
Sound property SayDialogueShyNakeSound Auto
Sound property SayDialogueShyNakeOnChildSound Auto
Sound property SayDialogueShyNakeOnBanditSound Auto
Sound property SayDialogueShyNakeOnBanditChiefSound Auto

Sound property SayDialogueSleepSound Auto		
Sound property SayDialogueSleepChildSound Auto
Sound property SayDialogueSleepLoverSound Auto

Sound property SayDialogueSickSound Auto
Sound property SayDialogueSickChildSound Auto
Sound property SayDialogueSickLoverSound Auto

Sound property SayDialogueDrunkSound Auto

Sound property SayDefaultSound Auto

; Race
Race property ElderRace Auto

; Faction
Faction property BeautyFaction Auto
Faction property CompanionFaction Auto

Faction property CWDialogueSoldierFaction Auto
Faction property BanditFaction Auto
Faction property jobBeggerFaction Auto
Faction property JobPriestFaction Auto
Faction property JobJarlFaction Auto
Faction property JobBlackSmithFaction Auto
Faction property JobMerchantFaction Auto
Faction property JobInnKeeperFaction Auto
Faction property JobDeliveryFaction Auto
Faction property WoundedFaction Auto
Faction property JobBardFaction Auto
Faction property DLC2RieklingFaction Auto
Faction property PlayerHousecarlFaction Auto	;  0 default
Faction property BardSingerFaction Auto			; -1 default
Faction property CurrentFollowerFaction Auto	; -1 default
Faction property PotentialMarriageFaction Auto	; -1 default

Package property BardSongTravelPackage Auto
