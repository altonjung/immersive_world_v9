Scriptname slalLoader extends slalAnimationFactory

function debugMsg(string msg)
  slalData.debugMsg(msg)
endFunction

function warningMsg(string msg)
  slalData.warningMsg(msg)
endFunction

function OnLoad()
  debugMsg("SLAL: OnLoad")
  RegisterForModEvent("SexLabSlotAnimations", "registerAnimations")

  ; After any game load, make sure we re-read JSON data the next time it is
  ; needed.  (Don't bother re-reading it now, since we won't actually need it
  ; unless the MCM menu is opened.)
  slalData.unloadData()
endFunction

; Register all enabled animations
int function registerAnimations()
  debugMsg("SLAL: registering animations")
  PrepareFactory()

  int enableState = slalData.getEnableState()
  int anims = slalData.getAnimations()
  string animID = JMap.nextKey(anims)
  int numRegistered = 0
  while animID
    int animInfo = slalData.getAnimInfo(animID)
    bool skip = JMap.getInt(animInfo, "skip")  as bool
    if skip != true
      if registerAnimIfEnabled(animID, anims, enableState)
        numRegistered += 1
      endIf
    endif
    
    animID = JMap.nextKey(anims, animID)
  endWhile

  debugMsg("SLAL: finished registering " + numRegistered + " animations")
  return numRegistered
endFunction

; Register the enabled animations from a specific category
; Other categories are ignored, even if they have enabled but not yet
; registered animations.
int function registerCategoryAnimations(string catName)
  debugMsg("SLAL: registering " + catName + " animations")
  PrepareFactory()

  int enableState = slalData.getEnableState()
  int anims = slalData.getAnimations()
  int catAnims = slalData.getCategoryAnims(catName)
  int numAnims = JArray.count(catAnims)

  int n = 0
  int numRegistered = 0
  while n < numAnims
    string animID = JArray.getStr(catAnims, n)
    
    int animInfo = slalData.getAnimInfo(animID)
    bool skip = JMap.getInt(animInfo, "skip")  as bool
    if skip != true
      if registerAnimIfEnabled(animID, anims, enableState)
        numRegistered += 1
      endIf
    endif

    n += 1
  endWhile

  debugMsg("SLAL: finished registering " + numRegistered + " animations")
  return numRegistered
endFunction

function updateJsonSettings()
  int anims = slalData.getAnimations()  
  string animID = JMap.nextKey(anims)
  while animID
    int animInfo = slalData.getAnimInfo(animID)
    bool skip = JMap.getInt(animInfo, "skip")  as bool
    if skip != true
      sslAnimationSlots animSlots = getSlotsByAnimID(animID)
      int sexlabID = animSlots.FindByRegistrar(animID)
      if sexlabID != -1
        sslBaseAnimation anim = animSlots.GetBySlot(sexlabID)
        anim.Initialize()
        anim.Registry = animId
        anim.Enabled  = true
  
        InitAnimSlot(animSlots, sexlabID, animId, "OnRegisterAnim")
      endIf
    endif 

    animID = JMap.nextKey(anims, animID)
  endWhile
endFunction

bool function registerAnimIfEnabled(string animID, int anims, int enableState)
  bool enabled = JMap.getInt(enableState, animID) as bool
  if !enabled
    return false
  endIf

  int animInfo = JMap.getObj(anims, animID)
  sslAnimationSlots animSlots = getSlots(animInfo)
  return RegisterAnimationCB(animSlots, animID, "OnRegisterAnim")
endFunction

; Get the correct sslAnimationSlots to use for the specified animation
sslAnimationSlots function getSlots(int animInfo)
  bool isCreature = JMap.hasKey(animInfo, "creature_race")
  if isCreature
    return CreatureSlots
  endIf
  return Slots
endFunction

sslAnimationSlots function getSlotsByAnimID(string animID)
  int animInfo = slalData.getAnimInfo(animID)
  return getSlots(animInfo)
endFunction

bool function isRegistered(string animID)
  sslAnimationSlots animSlots = getSlotsByAnimID(animID)
  return animSlots.IsRegistered(animID)
endFunction

function OnRegisterAnim(int id, string animID)
  int animInfo = slalData.getAnimInfo(animID)

   sslBaseAnimation anim = CreateInSlots(getSlots(animInfo), id)
   anim.Name = JMap.getStr(animInfo, "name")
   anim.SoundFX = getSound(animInfo)
  
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
   anim.SetTags(tags)
  
   anim.Save(id)
endFunction

function addActorInfo(sslBaseAnimation anim, int animInfo, int actorInfo)
  int actorID = addActorPosition(anim, animInfo, actorInfo)

  int stages = JMap.getObj(actorInfo, "stages")
  int numStages = JArray.count(stages)
  int n = 0
  while n < numStages
    int stageInfo = JArray.getObj(stages, n)
    addActorStage(anim, actorID, stageInfo)
    n += 1
  endWhile
endFunction

function addActorStage(sslBaseAnimation anim, int actorID, int stageInfo)
  string eventID = JMap.getStr(stageInfo, "id")
  float forward = JMap.getFlt(stageInfo, "forward")
  float side = JMap.getFlt(stageInfo, "side")
  float up = JMap.getFlt(stageInfo, "up")
  float rotate = JMap.getFlt(stageInfo, "rotate")
  bool silent = JMap.getInt(stageInfo, "silent") as bool
  bool openMouth = JMap.getInt(stageInfo, "open_mouth") as bool
  bool strapOn = JMap.getInt(stageInfo, "strap_on") as bool
  int sos = JMap.getInt(stageInfo, "sos")
  String sfxAction = JMap.getStr(stageInfo, "sfxAction")
  String sfxVoiceType = JMap.getStr(stageInfo, "sfxVoiceType")
  String sfxSounds = JMap.getStr(stageInfo, "sfxSounds")
  String sfxExpressionType = JMap.getStr(stageInfo, "sfxExpressionType")
  bool   sfxOrgasm = JMap.getInt(stageInfo, "sfxOrgasm") as bool
  String sfxMoanType = JMap.getStr(stageInfo, "sfxMoanType")

  anim.AddPositionStage(actorID, eventID, forward=forward, side=side, up=up, rotate=rotate, silent=silent, openmouth=openmouth, strapon=strapOn, sos=sos, sfxAction=sfxAction, sfxVoiceType=sfxVoiceType, sfxSounds=sfxSounds, sfxExpressionType=sfxExpressionType, sfxOrgasm=sfxOrgasm, sfxMoanType=sfxMoanType)

  ; TODO: SetStageCumID(int Position, int Stage, int CumID, int CumSource = -1)
endFunction

function addStageInfo(sslBaseAnimation anim, int stageInfo)
  int stageNum = JMap.getInt(stageInfo, "number")

  if JMap.hasKey(stageInfo, "sound")
    string soundName = JMap.getStr(stageInfo, "sound")    
    anim.SetStageSoundFX(stageNum, getSoundByName(soundName))
  endIf
  if JMap.hasKey(stageInfo, "timer")
    float timer = JMap.getFlt(stageInfo, "timer")    
    anim.SetStageTimer(stageNum, timer)
  endIf
endFunction

Sound function getSound(int animInfo)
  string soundName = JMap.getStr(animInfo, "sound")
  return getSoundByName(soundName)
endFunction

Sound function getSoundByName(string soundName)
  if !soundName || soundName == "none"
    return none
  elseIf soundName == "Squishing"
    return Squishing
  elseIf soundName == "Sucking"
    return Sucking
  elseIf soundName == "SexMix"
    return SexMix
  elseIf soundName == "Squirting"
    return Squirting
  endIf

  warningMsg("unrecognized sound '" + soundName + "'")
  return none
endFunction

int function addActorPosition(sslBaseAnimation anim, int animInfo, int actorInfo)
  string type = JMap.getStr(actorInfo, "type")
  string creatureRace
  int cum

  if type == "Male"    
    return anim.AddPosition(Male)
  elseIf type == "Female"
    cum = getActorCum(actorInfo)
    return anim.AddPosition(Female, addCum=cum)
  elseIf type == "Creature"
    creatureRace = JMap.getStr(actorInfo, "race")
    return anim.AddCreaturePosition(creatureRace, Creature)
  elseIf type == "CreatureMale"
    creatureRace = JMap.getStr(actorInfo, "race")
    anim.GenderedCreatures = true
    return anim.AddCreaturePosition(creatureRace, CreatureMale)
  elseIf type == "CreatureFemale"
    creatureRace = JMap.getStr(actorInfo, "race")
    anim.GenderedCreatures = true
    cum = getActorCum(actorInfo)
    return anim.AddCreaturePosition(creatureRace, CreatureFemale, AddCum=cum)
  endIf

  warningMsg("unrecognized actor type '" + type + "'")
  return anim.AddPosition(Male)
endFunction

int function getActorCum(int actorInfo)
  string name = JMap.getStr(actorInfo, "add_cum")
  if name == "" || name == "none"
    return -1
  elseIf name == "Vaginal"
    return Vaginal
  elseIf name == "Oral"
    return Oral
  elseIf name == "Anal"
    return Anal
  elseIf name == "VaginalOral"
    return VaginalOral
  elseIf name == "VaginalAnal"
    return VaginalAnal
  elseIf name == "OralAnal"
    return OralAnal
  elseIf name == "VaginalOralAnal"
    return VaginalOralAnal
  else 
      ; Try the field as an integer first
     int cum = JMap.getInt(actorInfo, "add_cum", -99)
    if cum != -99
       return cum
    endIf
  endIf


  warningMsg("unrecognized add_cum value '" + name + "'")
  return -1
endFunction
