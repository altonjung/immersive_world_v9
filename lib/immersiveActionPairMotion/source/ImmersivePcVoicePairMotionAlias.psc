scriptname ImmersiveAnimalPairMotionAlias extends ReferenceAlias

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
	RegisterForModEvent("ImpPairMotion", 	"processScene")
	RegisterForModEvent("ImpPairMotion", 	"processScene")	
endFunction

function init ()		
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	coolTimeActionMap = new float[15]	; 0: Wolf, 1: Giant, 2: Riekling, 3: Falmer
	isAniPlaying = false

	reloadData()
endFunction

function reloadData()    
    int data = JValue.readFromDirectory("Data/JsonAnims/json", ".json")
    JValue.retain(data)

    int categories = JValue.retain(JMap.object())
    int anims = JValue.retain(JMap.object())

    JDB.solveObjSetter(".SLAL.animations", anims, true)

    JValue.release(categories)
    JValue.release(anims)
    JValue.release(data)

    log("loaded " + JMap.count(categories) + " JSON files")
endFunction

function parseAnimationFromJson(int id, string animID)
	int animInfo = slalData.getAnimInfo(animID)
  
	 sslBaseAnimation anim = CreateInSlots(getSlots(animInfo), id)
	 String name = JMap.getStr(animInfo, "name")
	 String soundFX = getSound(animInfo)
	
	 int actors = JMap.getObj(animInfo, "actors")
	 int numActors = JArray.count(actors)
	 int n = 0
	 while n < numActors
	   int actorInfo = JArray.getObj(actors, n)
	   addActorInfo(anim, animInfo, actorInfo)
	   n += 1
	 endWhile
	
	 int stages = JMap.getObj(animInfo, "stages")
	 int numStages = JArray.count(stages)
	 n = 0
	 while n < numStages
	   int stageInfo = JArray.getObj(stages, n)
	   addStageInfo(anim, stageInfo)
	   n += 1
	 endWhile
	
	 ; TODO: SetBedOffsets(float forward, float sideward, float upward, float rotate)
   
	 string tags = JMap.getStr(animInfo, "tags")	 
endFunction

function getStages(int animInfo, int actorInfo)
	int actorID = addActorPosition(animInfo, actorInfo)
  
	int stages = JMap.getObj(actorInfo, "stages")
	int numStages = JArray.count(stages)
	int n = 0
	while n < numStages
	  int stageInfo = JArray.getObj(stages, n)
	  addActorStage(actorID, stageInfo)
	  n += 1
	endWhile
 endFunction
  
function getCurrentStage(int actorID, int stageInfo)
	string eventID = JMap.getStr(stageInfo, "id")
	bool openMouth = JMap.getInt(stageInfo, "openMouth") as bool
	bool strapOn = JMap.getInt(stageInfo, "strapOn") as bool
	int sos = JMap.getInt(stageInfo, "sos")
	String sfxAction = JMap.getStr(stageInfo, "ActionType")
	String sfxSounds = JMap.getStr(stageInfo, "soundType")
	String sfxExpressionType = JMap.getStr(stageInfo, "ExpressionType")
	bool   sfxOrgasm = JMap.getInt(stageInfo, "orgasm") as bool
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