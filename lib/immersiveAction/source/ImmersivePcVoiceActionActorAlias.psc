scriptname ImmersivePcVoiceActionActorAlias extends ReferenceAlias

Actor  controlActor
ObjectReference overHairRef
ObjectReference lastOverHairContainerRef

float[] coolTimeSoundMap
float[] coolTimeActionMap

int    underWaterSoundId
float  underWaterSoundVolume

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

; dependency
bool   isImmersiveInteractionsInstalled

bool   isDialogueMode
bool   isControlling
bool   isAnimalPlaying
bool   shouldDoingPassiveDialogueEnd

Event OnInit()
EndEvent

event OnLoad()
	registerAction()	
	init()
endEvent

; save -> load 시 호출
Event OnPlayerLoadGame()
	init()
EndEvent

function registerAction ()	
	regAnimation()
endFunction

function init ()		
	UnregisterForMenu("Dialogue Menu")
	UnregisterForMenu("Journal Menu")
	UnregisterForMenu("Sleep/Wait Menu")
	UnregisterForMenu("Crafting Menu")
	
	RegisterForMenu("Dialogue Menu")
	RegisterForMenu("Journal Menu")
	RegisterForMenu("Sleep/Wait Menu")
	RegisterForMenu("Crafting Menu")
	
	underWaterSoundId = 0
	underWaterSoundVolume = 0.0

	overHairRef = None	
	controlActor = None

	isControlling = false
	isDialogueMode = false	
	isAnimalPlaying = false
	shouldDoingPassiveDialogueEnd = false

	runningCoolTimeExpress = "happy"
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	coolTimeSoundMap = new float[10]				; 0 ~ 8: normal, 9: battle
	coolTimeActionMap = new float[20]			

	; dependency 
	pcVoiceMCM.playerGender = pcVoiceMCM.GetGender(playerRef)

	If Game.GetModByName("ImmersiveInteractions.esp") != 255
		pcVoiceMCM.log("ImmersiveInteractions.esp installed")
        isImmersiveInteractionsInstalled = true
	else 
		pcVoiceMCM.log("ImmersiveInteractions.esp not installed")
		isImmersiveInteractionsInstalled = false
    EndIf
endFunction

function regAnimation ()
	; key
	RegisterForControl("Activate")

	; ride
	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseMount")
	RegisterForAnimationEvent(playerRef, "SoundPlay.NPCHorseDismount")	
	RegisterForAnimationEvent(playerRef, "DragonMountEnter")
	RegisterForAnimationEvent(playerRef, "DragonMountExitOut")

	; sprint
	; RegisterForAnimationEvent(playerRef, "tailSprint")
	RegisterForAnimationEvent(playerRef, "EndAnimatedCameraDelta")	; end sprint
	
	; sneak
	; RegisterForAnimationEvent(playerRef, "tailSneakIdle") 		; start in standing
	RegisterForAnimationEvent(playerRef, "tailMTIdle") 				; end sneaking while standing	

	; swimming
	RegisterForAnimationEvent(playerRef, "SoundPlay.FSTSwimSwim")	; start
	RegisterForAnimationEvent(playerRef, "MTState") 				; end
endFunction

Event OnControlDown(string control)
	if control == "Activate"
		overHairRef = Game.GetCurrentCrosshairRef()
		If overHairRef != none
			int _type = overHairRef.getType()
			if _type == 61  ; reference
				Activator akActivator= overHairRef.GetBaseObject() as Activator
				if akActivator 
					if akActivator.hasKeywordString("ActivatorPillar") || akActivator.hasKeywordString("ActivatorLever") || akActivator.hasKeywordString("ActivatorChain") || akActivator.hasKeywordString("DoorKeyHole")
						SoundPlay(SayActionMoveHeavySound)
						return
					endif
				endif

				Furniture akFurniture = overHairRef.GetBaseObject() as Furniture
				if akFurniture 
					if akFurniture.hasKeywordString("ActivatorLever") || akFurniture.hasKeywordString("ActivatorPillar")
						SoundPlay(SayActionMoveHeavySound)
						return
					elseif akFurniture.hasKeywordString("ActivatorChain")
						SoundPlay(SayActionMoveLightSound)
						return 
					endif 
				endif
			elseif _type == 43 || _type == 62
				controlActor = None				
				Actor _akActor = overHairRef as Actor
				if _akActor 
					if !playerRef.IsHostileToActor(_akActor)
						if _akActor.isDead()
							if _akActor.HasKeyWordString("ActorTypeNPC")
								float _curTime = Utility.GetCurrentRealTime()
								if _curTime > coolTimeSoundMap[3]
									if _akActor.GetKiller() != playerRef									
										SoundCoolTimePlay(SayActionFoundDeadBodySound, _volume=0.4, _delay=0.0, _coolTime=2.0, _mapIdx=6, _mapCoolTime=10.0, _express="sad")
									else 
										SoundCoolTimePlay(SayActionSearchBodySound, _delay=0.2, _volume=0.5, _coolTime=2.0, _mapIdx=6, _mapCoolTime=10.0, _express="happy")									
									endif
								endif
							elseif _akActor.HasKeyWordString("ActorTypeAnimal") || _akActor.HasKeyWordString("ActorTypeCreature")
								SoundCoolTimePlay(SayActionSearchBodySound, _delay=0.3, _volume=0.5, _coolTime=2.0, _express="happy")
							endif
						else 
							; not dead
							float _currentTime = Utility.GetCurrentRealTime()
							if _akActor.HasKeyWordString("ActorTypeNPC")
								; playerRef.PlayIdleWithTarget(PaTestIdle, _akActor)

								if !isAnimalPlaying && !playerRef.IsOnMount() && !playerRef.IsInCombat() && !playerRef.IsSwimming()
									isAnimalPlaying = true
									controlActor = _akActor
									isControlling = true

									if pcVoiceMCM.playerGender == 1
										; not sleep, not hostile
										if _akActor.GetSleepState() == 3
											SoundCoolTimePlay(SayDialogueActiveSleepSound,  _volume=0.4, _coolTime=2.0, _mapIdx=1, _mapCoolTime=3.0, _express="happy")
										else
											Game.DisablePlayerControls(false, false, true, false, false, false, false)
											int _dialogueActorRelationShip = playerRef.GetRelationshipRank(_akActor)
											; isHugWithSpouse.setValue(0)
											int _npcGender =  pcVoiceMCM.GetGender(_akActor)

											if _akActor.isChild() ; 아이
												if !isImmersiveInteractionsInstalled
													Debug.SendAnimationEvent(playerRef, "ImmWatchAnimalStart_Middle_" + utility.randomInt(1,2))
												endif
												SoundCoolTimePlay(SayDialogueActiveChildSound, _delay=0.3, _volume=0.4, _mapIdx=1, _mapCoolTime=3.0)						
												Debug.SendAnimationEvent(_akActor, "IdleWave")
											elseif _dialogueActorRelationShip == 4; 배우자
												if _currentTime > coolTimeActionMap[14]
													SoundCoolTimePlay(SayActionKissSound, _delay=0.3, _volume=0.4, _mapIdx=1, _mapCoolTime=3.0)
													coolTimeActionMap[14] = _currentTime + 300.0
													; isHugWithSpouse.setValue(1)
													; playerRef.PlayIdleWithTarget(PaTestIdle, _akActor)
												endif
											elseif _akActor.getFactionRank(CompanionFaction) == -2 && _akActor.IsGuard() ; 경비병
												SoundCoolTimePlay(SayDialogueActiveGuardSound, _delay=0.3, _volume=0.4, _mapIdx=1, _mapCoolTime=3.0)
											elseif _akActor.getFactionRank(BardSingerFaction) >= 0 && _akActor.GetCurrentPackage() as Package == BardSongTravelPackage	; 가수
												SoundCoolTimePlay(SayDialogueActiveBardSound, _volume = 0.6, _coolTime=3.0, _mapIdx=1, _mapCoolTime=3.0)											
											elseif _akActor.GetActorBase().getRace() == ElderRace ; 노인																						
												ObjectReference _objRef = _akActor.GetFurnitureReference()
												if _objRef || _npcGender == 0
													SoundCoolTimePlay(SayDialogueActiveElderSound,  _coolTime=2.0, _mapIdx=1, _mapCoolTime=3.0)
												else
													SoundCoolTimePlay(SayDialogueActiveFemaleElderSound, _delay=0.3, _coolTime=2.0, _mapIdx=1, _mapCoolTime=3.0)	
													playerRef.PlayIdleWithTarget(PaHuaIdle, _akActor)
												endif								
											else
												if _npcGender == 0 && _dialogueActorRelationShip > -1 && pcVoiceMCM.hasAnimalStyle.getValue() != -4
													SoundCoolTimePlay(SayDialogueActiveMaleSound, _delay=0.3, _volume=0.4)
													;  주인공(여성)인 경우 남성 npc 에 애교 수행
													bool _isAttractivePlayer = pcVoiceMCM.isAttractiveForFemalePlayer(playerRef, _akActor)
													bool _playerHasHelmet = pcVoiceMCM.hasHelmet(playerRef)
		
													if !_playerHasHelmet && _isAttractivePlayer
														SoundCoolTimePlay(SayEmotionPrettyLaughSound, _delay=0.3, _volume=0.4, _mapIdx=3, _mapCoolTime=3.0)
														Debug.SendAnimationEvent(playerRef, "ImmGestureEarCrossStart_" + Utility.randomInt(1,2))
														Utility.Wait(2.5)
														Debug.SendAnimationEvent(playerRef, "ImmGestureEarCrossEnd")
														if !isDialogueMode										
															Utility.Wait(1.5)
															Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")
														endif
													endif
												else 
													SoundCoolTimePlay(SayDialogueActiveFemaleSound, _delay=0.3, _volume=0.4, _mapIdx=1, _mapCoolTime=3.0)
												endif
											endif
											Game.EnablePlayerControls()
										endif								
									endif
									isControlling = false 	
									isAnimalPlaying = false						
								endif												
							elseif _akActor.HasKeyWordString("ActorTypeAnimal") || _akActor.HasKeyWordString("ActorTypeCreature")
								if !isAnimalPlaying && !playerRef.IsOnMount() && !playerRef.IsInCombat() && !playerRef.IsSwimming()
									isAnimalPlaying = true								
									Game.DisablePlayerControls(false, false, true, false, false, false, false)															
									int _playType = -1  		; 0: low, 1: middle, 2: high, 3: wave
									int  _coolTimeSoundMapIdx = 1
									int  _coolTimeActionMapIdx = 0
									int _randomInt = Utility.randomInt(1,2)
									float _coolTimeSoundMap = 3.0
									float _coolTimeForAciton = 5.0
									Sound _playSound = SayDefaultSound
									Race _actorRace = _akActor.GetActorBase().getRace()

									if _actorRace == DogRace 						
										_playSound = SayDialogueActiveAnimalDogSound
										if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]																								
											if !isImmersiveInteractionsInstalled													
												_playType = 1												
											endif
										endif
									elseif _actorRace == HorseRace
										if isImmersiveInteractionsInstalled
											_akActor.SetUnconscious(true)
											_coolTimeActionMapIdx = 1
											_playSound = none
											SoundCoolTimePlay(SayDialogueActiveAnimalHorseSound, _volume=0.5, _coolTime = 2.5, _mapIdx=_coolTimeSoundMapIdx, _mapCoolTime=_coolTimeSoundMap, _express="happy")																										
											if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]
												_coolTimeForAciton = 30.0
												ModEvent.Send(ModEvent.Create("ImpInTouchHorse"))
											endif
											_akActor.SetUnconscious(false)											
										endif
									elseif _actorRace == CowRace
										_coolTimeActionMapIdx = 2
										_playSound = SayDialogueActiveAnimalCowSound
										if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]
											_playType = 1
											ModEvent.Send(ModEvent.Create("ImpInTouchCow"))
										endif				
									elseif _actorRace == ChickenRace
										_coolTimeActionMapIdx = 3
										_playSound = SayDialogueActiveAnimalChickenSound
										if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]
											_playType = 0
											ModEvent.Send(ModEvent.Create("ImpInTouchChicken"))
										endif
									elseif _akActor.getVoiceType() == DLC2RiekingVoice	; race는 foxRace 와 rieklingRace 두가지가 존재하여, voiceType으로 식별
										_coolTimeActionMapIdx = 4
										_playSound = SayDialogueActiveAnimalRiklingSound
										if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]
											_playType = 1
											ModEvent.Send(ModEvent.Create("ImpInTouchRikling"))
										endif																																							
									elseif _actorRace == GoatRace
										_coolTimeActionMapIdx = 5
										_playSound = SayDialogueActiveAnimalGoatSound											
										if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]
											_playType = 0
											ModEvent.Send(ModEvent.Create("ImpInTouchGoat"))
										endif											
									elseif _actorRace == MammothRace || _actorRace == GiantRace || _actorRace == DragonRace
										_coolTimeActionMapIdx = 6
										_playSound = SayDialogueActiveAnimalGiantSound
										if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]				
											_playType = 2
											ModEvent.Send(ModEvent.Create("ImpInTouchGiant"))
										endif																					
									elseif _actorRace == HareRace
										_coolTimeActionMapIdx = 7
										_playSound = SayDialogueActiveAnimalRabbitSound
										if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]
											_playType = 3
											ModEvent.Send(ModEvent.Create("ImpInTouchHare"))
										endif																					
									else												
										_coolTimeActionMapIdx = 8
										if _currentTime >= coolTimeActionMap[_coolTimeActionMapIdx]
											_playSound = SayDialogueActiveAnimalOthersSound
											_playType = 1
										endif
									endif
									
									if _playSound
										SoundCoolTimePlay(_playSound, _delay=0.3, _volume=0.5, _coolTime = 2.5, _mapIdx=_coolTimeSoundMapIdx, _mapCoolTime=_coolTimeSoundMap, _express="happy")
									endif									
									if _playType > -1 && pcVoiceMCM.isPossibleFemaleAnimation(playerRef) && pcVoiceMCM.hasAnimalStyle.getValue() != -4									
										if _playType == 0
											Debug.SendAnimationEvent(playerRef, "ImmGestureWatchLowStart_" + _randomInt)
											Utility.Wait(3.0)
											Debug.SendAnimationEvent(playerRef, "ImmGestureWatchLowEnd")
										elseif _playType == 1												
											Debug.SendAnimationEvent(playerRef, "ImmGestureWatchMiddlePlay_" + _randomInt)
										elseif _playType == 2
											Debug.SendAnimationEvent(playerRef, "ImmGestureWatchHighPlay_" + _randomInt)
										elseif _playType == 3
											Debug.SendAnimationEvent(playerRef, "ImmGestureHarePlay")
										endif						
										coolTimeActionMap[_coolTimeActionMapIdx] = _currentTime + _coolTimeForAciton
									endif
								endif
								Game.EnablePlayerControls()
								isAnimalPlaying = false
							endif 
						endif
					endif
				endif						
			endif	
		endif
	endif
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)	
	; if asEventName == "tailSneakIdle"
	; 	if !playerRef.IsInCombat() && !pcVoiceMCM.isWeaponDraw
	; 		if sneakStepCount == 0
	; 			sneakStepCount += 1
	; 			SoundCoolTimePlay(SayActionSneakSound, _delay=0.5, _volume=0.3, _coolTime = 5.5)
	; 		else 
	; 			SoundCoolTimePlay(SayActionSneakStepBySound, _volume=0.3, _coolTime = 4.0)
	; 		endif 
	; 	endif
	if asEventName == "EndAnimatedCameraDelta" ;"tailMTIdle"

		float _currentTime = Utility.GetCurrentRealTime()
		if _currentTime >= coolTimeActionMap[15]
			int _handle = 0
			if playerRef.IsInCombat()
				if playerRef.GetActorValuePercentage("Stamina") <= 0.70
					_handle = ModEvent.Create("ImpPairMotionForStruggle")
				endif
			else
				_handle = ModEvent.Create("ImpPairMotionForPrank")
			endif
			
			ModEvent.PushFloat(_handle, 4.0)
			ModEvent.Send(_handle)
			coolTimeActionMap[15] = _currentTime + 5.0
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
		SoundCoolTimePlay(SayActiveMountSound, _delay=0.2, _coolTime=1.5)
	elseif asEventName == "SoundPlay.NPCHorseDismount"	|| asEventName == "DragonMountExitOut"
		SoundCoolTimePlay(SayActiveDisMountSound, _delay=0.2, _coolTime=1.5)
	endif
endEvent

;
;	Drink
;
Event OnItemHarvested(Form akProduce)
	if !playerRef.IsInCombat()
		SoundCoolTimePlay(SayActionHarvestedSound, _delay=0.5, _coolTime=2.0)
	endif	
EndEvent

;
;	Drink
;
Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)	
	actor akActor = akCaster as Actor
	if akActor == playerRef
		if akEffect.HasKeyWordString("StoneDoomEffect")		; doom
			SoundCoolTimePlay(SayActionRitualSound, _delay=0.5, _coolTime=3.0)

			; stone 대상으로 ritual 수행
			if !playerRef.IsInCombat()
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
			endif		
		elseif akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol
			SoundCoolTimePlay(SayActionDrinkAlcoholSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=3.0)	
		elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& (akEffect.HasKeyWordString("MagicAlchRestoreHealth") || akEffect.HasKeyWordString("MagicAlchRestoreMagicka") || akEffect.HasKeyWordString("MagicAlchRestoreStamina"))
			SoundCoolTimePlay(SayActionDrinkPotionSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=3.0)
		elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure
			SoundCoolTimePlay(SayActionDrinkPotionSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=3.0)				
		endif
	else
		if akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure
			SoundCoolTimePlay(SayActionDrinkPotionSound, _coolTime=3.0, _mapIdx=3, _mapCoolTime=3.0)	
		endif	
	endif 
EndEvent

; Event that is triggered when this actor sits in the furniture
Event OnSit(ObjectReference akFurniture)	
	if playerRef.IsInCombat()
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
	if  furnitureType == 3 ; sleep
		SoundCoolTimePlay(SayActionGoToBedSound, _delay=0.5, _coolTime=3.0)
	elseif furnitureType == 2 ; sit
		float _currentHour = (Utility.GetCurrentGameTime() * 24.0) as Int % 24
		if _currentHour <= 4 || _currentHour >= 23 
			SoundCoolTimePlay(SayActionBoreSound, _delay=1.0, _coolTime=3.0, _mapIdx=4, _mapCoolTime=10.0)
		endif
	endif
EndEvent

;
;	Menu
;
Event OnMenuOpen(string menuName)
	if menuName == "Dialogue Menu"
		while isControlling
			Utility.WaitMenuMode(0.1)
		endWhile

		isDialogueMode = true

		Actor _akActor  = Game.GetDialogueTarget() as Actor
		
		; 수동적 대화 처리
		if controlActor == None ; || Game.GetCurrentCrosshairRef() == None			
			if _akActor
				SoundCoolTimePlay(SayDialoguePassiveSound,_delay=0.5, _coolTime=2.0, _mapIdx=2, _mapCoolTime=5.0)				
				if playerRef.IsHostileToActor(_akActor) || _akActor.getFactionRank(CompanionFaction) == -2 && _akActor.IsGuard()  
					shouldDoingPassiveDialogueEnd = false
				else 
					shouldDoingPassiveDialogueEnd = true
				endif
			endif
		else 
		; 능동적 대화 처리
			if pcVoiceMCM.playerGender == 0
				if _akActor.GetSleepState() != 3  && !_akActor.IsHostileToActor(playerRef)
					;  주인공 남성인 경우 여성 npc 가 남성 주인공에 애교 수행
					int _npcGenderType = pcVoiceMCM.GetGender(_akActor)
					bool _isAttractiveActor = pcVoiceMCM.isAttractiveForMalePlayer(playerRef, _akActor)
					bool _actorHasHelmet = pcVoiceMCM.hasHelmet(_akActor)
					if !_actorHasHelmet && _npcGenderType == 1  && _isAttractiveActor					
						Debug.SendAnimationEvent(playerRef, "ImmEmotionBeautyStart_" + Utility.randomInt(1,3))
						Utility.Wait(2.5)
						Debug.SendAnimationEvent(playerRef, "ImmGestureEarCrossEnd")
						if !isDialogueMode										
							Utility.Wait(1.5)
							Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")
						endif
					endif
				endif
			endif
		endif

		controlActor = None	
	elseif menuName == "Sleep/Wait Menu"
		utility.waitMenuMode(0.2)
		if playerRef.GetSleepState() == 3
			SoundPlay(SayActionSleepSound, _volume=0.7)
		endif	
	elseif menuName == "Crafting Menu"
		ObjectReference _furniture = playerRef.GetFurnitureReference()
		if _furniture
			utility.waitMenuMode(0.2)
			SoundPlay(SayDefaultSound, _volume=0.7)
		endif
	endif
endEvent

Event OnMenuClose(string menuName)
	if menuName == "Sleep/Wait Menu"
		Game.FadeOutGame(false, true, 0.5, 3.0)
	elseif menuName == "Dialogue Menu"

		if shouldDoingPassiveDialogueEnd == true
			SoundCoolTimePlay(SayDialoguePassiveEndSound, _delay=0.5, _volume = 0.4,_coolTime=2.0, _mapIdx=2, _mapCoolTime=5.0)
			shouldDoingPassiveDialogueEnd = false
		endif

		isDialogueMode = false
		Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")		 
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
function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0, string _express="happy", bool _ignoreCombat = false)
	if pcVoiceMCM.enableActionSound == false || pcVoiceMCM.playerGender == 0 || playerRef.IsSwimming()
		return
	endif 	

	if _ignoreCombat == false
	 	if playerRef.IsInCombat()
			return 
		endif
	endif 
	
	float currentTime = Utility.GetCurrentRealTime()	
	if currentTime > pcVoiceMCM.soundCoolTime && currentTime > coolTimeSoundMap[_mapIdx]		 			
		coolTimeSoundMap[_mapIdx] = currentTime + _mapCoolTime + _delay

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
	if pcVoiceMCM.enableActionSound == false || pcVoiceMCM.playerGender == 0 || playerRef.IsSwimming() || playerRef.IsInCombat() 
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

int function SoundSwimmingPlay(Sound _sound, float _volumn = 0.8, int _mapIdx = 1, float _mapCoolTime = 4.0)
	float currentTime = Utility.GetCurrentRealTime()
	int soundId = 0
	if currentTime >= coolTimeSoundMap[_mapIdx]
		soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(soundId, _volumn)
	else 
		return 0
	endif
	return soundId
endFunction

ImmersivePcVoiceMCM property pcVoiceMCM Auto

; GlobalVariable Property isHugWithSpouse Auto	; 00724413
GlobalVariable Property hasAnimalStyle Auto	

Idle property PaHuaIdle Auto
Idle property PaTestIdle Auto
Idle property PaKissFMIdle Auto
Idle property PaKissMFIdle Auto
Idle property PaKissMMIdle Auto
Idle property PaKissFFIdle Auto

Actor property playerRef Auto

Race property ElderRace Auto
Race property DogRace Auto
Race property GoatRace Auto
Race property HorseRace Auto
Race property CowRace Auto
Race property ChickenRace Auto
Race property HareRace Auto
Race property GiantRace Auto
Race property DragonRace Auto
Race property MammothRace Auto
VoiceType property DLC2RiekingVoice auto

Faction property BardSingerFaction Auto			; -1 default
Faction property CompanionFaction Auto
Package property BardSongTravelPackage Auto

; action
Sound property SayActionKissSound Auto
Sound property SayActionHarvestedSound Auto
Sound property SayActionUnderWaterSound Auto
Sound property SayActionMoveHeavySound Auto
Sound property SayActionMoveLightSound Auto
Sound property SayActionGoToBedSound Auto
Sound property SayActionSleepSound Auto
Sound property SayActionSearchBodySound Auto
Sound property SayActionFoundDeadBodySound Auto
Sound property SayActionTauntSound Auto
Sound property SayActionBoreSound Auto

Sound property SayActiveMountSound Auto
Sound property SayActiveDisMountSound Auto

Sound property SayActionRitualSound Auto

; drink
Sound property SayActionDrinkAlcoholSound Auto
Sound property SayActionDrinkPotionSound Auto

; dialogue
Sound property SayDialoguePassiveSound Auto
Sound property SayDialoguePassiveEndSound Auto

Sound property SayDialogueActiveChildSound Auto
Sound property SayDialogueActiveBardSound Auto
Sound property SayDialogueActiveElderSound Auto
Sound property SayDialogueActiveFemaleElderSound Auto
Sound property SayDialogueActiveGuardSound Auto
Sound property SayDialogueActiveFemaleSound Auto
Sound property SayDialogueActiveMaleSound Auto
Sound property SayDialogueActiveSleepSound Auto

Sound property SayDialogueActiveAnimalCowSound Auto
Sound property SayDialogueActiveAnimalDogSound Auto
Sound property SayDialogueActiveAnimalHorseSound Auto
Sound property SayDialogueActiveAnimalHostileSound Auto
Sound property SayDialogueActiveAnimalGiantSound Auto
Sound property SayDialogueActiveAnimalChickenSound Auto
Sound property SayDialogueActiveAnimalGoatSound Auto
Sound property SayDialogueActiveAnimalRabbitSound Auto

Sound property SayDialogueActiveAnimalRiklingSound Auto
Sound property SayDialogueActiveAnimalOthersSound Auto

; emotion
Sound property SayEmotionPrettyLaughSound Auto

; etc
Sound property SayDefaultSound Auto
