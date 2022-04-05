scriptname ImmersiveAnimalPairMotionPrankAlias extends ReferenceAlias

Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime
bool   isAniPlaying

float[] coolTimeActionMap

Event OnInit()
EndEvent

Event OnLoad()
    registerAction()	
	init()
EndEvent

; save -> load 시 호출
Event OnPlayerLoadGame()
	init()
EndEvent

function registerAction ()	
	regAnimation()
endFunction

function regAnimation ()
	RegisterForModEvent("ImpPairMotionForPrank", 		"processPrankScene")	
endFunction

function init ()		
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	coolTimeActionMap = new float[15]	; 0: Wolf, 1: Giant, 2: Riekling, 3: Falmer
	isAniPlaying = false
endFunction

event processPrankScene(float _aniPlayTime)
	Actor _AggressorActor = PO3_SKSEFunctions.GetClosestActorFromRef(playerRef as ObjectReference, true)	
	; log("_AggressorActor " + _AggressorActor + ", distance " + _AggressorActor.getDistance(playerRef))
	if _AggressorActor && !_AggressorActor.isDead() && !_AggressorActor.IsSwimming() && _AggressorActor.GetSleepState() != 3  && _AggressorActor.getDistance(playerRef) <= 150.0
		if  isAniPlaying == false
			String _actorType = ""
			Race _race = _AggressorActor.getRace()
			Sound _sound = none
			int  _idx = -1
			if _race == wolfRace
				_actorType = "Wolf"
				_sound = SayAnimalWolfAttackSound
				_idx = 0
			elseif _race == giantRace
				_actorType = "Giant"
				_sound = SayAnimalGiantAttackSound
				_idx = 1
			elseif _race == rieklingRace
				_actorType = "Riekling"
				_sound = SayAnimalRieklingAttackSound
				_idx = 2
			elseif _race == falmerRace
				_actorType = "Falmer"
				_sound = SayAnimalFalmerAttackSound
				_idx = 3
			endif

			float _currentTime = Utility.GetCurrentRealTime()

			if  _idx >= 0 && _currentTime >= coolTimeActionMap[_idx]
				isAniPlaying = true
				beginScene(playerRef, _AggressorActor)
				playSceneOfPrank(playerRef, _AggressorActor, _sound, _actorType, _aniPlayTime)
				endScene(playerRef, _AggressorActor)
				coolTimeActionMap[_idx] = _currentTime + 30.0
				isAniPlaying = false
			endif
		endif
	endif
endevent

event processStruggleScene(float _aniPlayTime)    
	Actor _AggressorActor = PO3_SKSEFunctions.GetClosestActorFromRef(playerRef as ObjectReference, true)	
	; log("_AggressorActor " + _AggressorActor + ", distance " + _AggressorActor.getDistance(playerRef))
	if _AggressorActor && !_AggressorActor.isDead() && !_AggressorActor.IsSwimming() && _AggressorActor.GetSleepState() != 3  && _AggressorActor.getDistance(playerRef) < 150.0
		if  isAniPlaying == false
			String _actorType = ""
			Race _race = _AggressorActor.getRace()
			Sound _sound = none
			int  _idx = -1
			if _race == wolfRace
				_actorType = "Wolf"
				_sound = SayAnimalWolfAttackSound
				_idx = 0
			elseif _race == giantRace
				_actorType = "Giant"
				_sound = SayAnimalGiantAttackSound
				_idx = 1
			elseif _race == rieklingRace
				_actorType = "Riekling"
				_sound = SayAnimalRieklingAttackSound
				_idx = 2
			elseif _race == falmerRace
				_actorType = "Falmer"
				_sound = SayAnimalFalmerAttackSound
				_idx = 3
			endif

			float _currentTime = Utility.GetCurrentRealTime()
			log("_currentTime " + _currentTime + ", cooltime " + coolTimeActionMap[_idx])
			if  _idx >= 0 && _currentTime >= coolTimeActionMap[_idx]
				isAniPlaying = true
				beginScene(playerRef, _AggressorActor)
				playSceneOfStruggle(playerRef, _AggressorActor, _sound, _actorType, _aniPlayTime)
				endScene(playerRef, _AggressorActor)					
				coolTimeActionMap[_idx] = _currentTime + 5.0
				isAniPlaying = false
			endif
		endif
	endif
endevent 

function playSceneOfPrank(actor _victim, actor _aggressor, Sound _aggressorSnd, string _actorType, float _aniPlayTime)
	_victim.PlayIdleWithTarget(PaHuaIdle, _aggressor)	; 애니메이션 동기화
	; play sound
	Sound.SetInstanceVolume(_aggressorSnd.Play(_aggressor), 0.8)
	ModEvent.Send(ModEvent.Create("ImpInStruggle"))

	Debug.SendAnimationEvent(_victim, _actorType + "Struggle_A1_Start")
	Debug.SendAnimationEvent(_aggressor, _actorType + "Struggle_A2_Start")

	; wait animation
	Utility.wait(_aniPlayTime)

	Debug.SendAnimationEvent(_victim, _actorType + "Struggle_A1_Stop")
	Debug.SendAnimationEvent(_aggressor, _actorType + "Struggle_A2_Stop")

	postScene(_actorType, _victim, _aggressor)
endFunction

function playSceneOfStruggle(actor _victim, actor _aggressor, Sound _aggressorSnd, string _actorType, float _aniPlayTime)
	_victim.PlayIdleWithTarget(PaHuaIdle, _aggressor)	; 애니메이션 동기화
	; play sound
	Sound.SetInstanceVolume(_aggressorSnd.Play(_aggressor), 0.8)
	ModEvent.Send(ModEvent.Create("ImpInStruggle"))

	Debug.SendAnimationEvent(_victim, _actorType + "Struggle_A1_Start")
	Debug.SendAnimationEvent(_aggressor, _actorType + "Struggle_A2_Start")

	; wait animation
	Utility.wait(2.0)
	; take off
	dressOff(_victim)
	Utility.wait(_aniPlayTime/2.0)

	Debug.SendAnimationEvent(_victim, _actorType + "Struggle_A1_Stop")
	Debug.SendAnimationEvent(_aggressor, _actorType + "Struggle_A2_Stop")

	postScene(_actorType, _victim, _aggressor)
endFunction

function postScene(String _actorType, actor _victim, actor _aggressor)
	_aggressor.MoveTo(_victim)
	if _actorType == "Wolf"
		Utility.wait(2.3)
		_aggressor.MoveTo(_victim, 220.0 * Math.Sin(_victim.GetAngleZ()), 220.0 * Math.Cos(_victim.GetAngleZ()))
		float _healthValue = _aggressor.GetActorValuePercentage("Health")
		_healthValue = (_healthValue * 100) / 5.0				
		_aggressor.DamageActorValue("Health", _healthValue)
	endif
endFunction

function beginScene(actor _victim, actor _aggressor)	
	ActorUtil.AddPackageOverride(_victim, doNothingPackage, 100, 1)
	_victim.EvaluatePackage()
	_victim.SetDontMove(true)
	; _victim.SetRestrained()	

	ActorUtil.AddPackageOverride(_aggressor, doNothingPackage, 100, 1)
	_aggressor.EvaluatePackage()
	_aggressor.SetDontMove(true)
	; _aggressor.SetRestrained()

	; move aggressor to victim
	_aggressor.moveto(_victim)
	_aggressor.SetPosition(_victim.GetPositionX(), _victim.GetPositionY(), _victim.GetPositionZ())	

	Game.DisablePlayerControls(true, true, true, false, true, true, false, false)
	Game.SetPlayerAIDriven()	
	Game.ForceThirdPerson()
	; wait animation
	Utility.wait(1.0)
endFunction

function endScene(actor _victim, actor _aggressor)
	; _victim.SetUnconscious(false)			
	ActorUtil.RemovePackageOverride(_victim, doNothingPackage)
	_victim.EvaluatePackage()	
	_victim.SetDontMove(false)	
	; _victim.SetRestrained(false)

	; _aggressor.SetUnconscious(false)
	ActorUtil.RemovePackageOverride(_aggressor, doNothingPackage)
	_aggressor.EvaluatePackage()	
	_aggressor.SetDontMove(false)
	; _aggressor.SetRestrained(false)

	Game.EnablePlayerControls()
	Game.SetPlayerAIDriven(false)
endFunction

function dressOff(actor _actor)
	armor _wornGlove    = _actor.GetWornForm(0x00000008) as armor       ; glove
	armor _wornBoots    = _actor.GetWornForm(0x00000080) as Armor		; boots		
	armor _wornArmor    = _actor.GetWornForm(0x00000004) as Armor		; armor	
	armor _wornStocking = _actor.GetWornForm(0x00800000) as Armor		; stocking	
	armor _wornPanties  = _actor.GetWornForm(0x00080000) as Armor		; panties	

	if _wornArmor == none 
		; 10% health 감소
		float _healthValue = _actor.GetActorValuePercentage("Health")
		_healthValue = (_healthValue * 100) / 10.0				
		_actor.DamageActorValue("Health", _healthValue)
	endif

	if _wornGlove
		_actor.DropObject(_wornGlove)
		if utility.randomInt(0,1) == 0
			return 
		endif
	endif 
	
	if _wornBoots
		_actor.DropObject(_wornBoots)
		if utility.randomInt(0,1) == 0
			return 
		endif
	endif 
		
	if _wornStocking
		_actor.DropObject(_wornStocking)
		if utility.randomInt(0,1) == 0
			return 
		endif
	endif 

	if _wornArmor
		_actor.DropObject(_wornArmor)
		if utility.randomInt(0,1) == 0
			return 
		endif
	endif 

	if _wornPanties
		_actor.DropObject(_wornPanties)
		if utility.randomInt(0,1) == 0
			return 
		endif
	endif 	
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

Actor property playerRef Auto

Idle property PaHuaIdle Auto
Package property doNothingPackage Auto

Race  property rieklingRace Auto
Race  property wolfRace Auto
Race  property giantRace Auto
Race  property falmerRace Auto
Race  property dogRace Auto

Sound property SayAnimalRieklingAttackSound Auto
Sound property SayAnimalRieklingPrankSound Auto
Sound property SayAnimalGiantAttackSound Auto
Sound property SayAnimalGiantPrankSound Auto
Sound property SayAnimalWolfAttackSound Auto
Sound property SayAnimalWolfPrankSound Auto
Sound property SayAnimalFalmerAttackSound Auto
Sound property SayAnimalFalmerPrankSound Auto