scriptname sslActorAlias extends ReferenceAlias

; 0: missionary, 1: cowgirl, 2: aggressive, 3: rape, 4:doggy, 5: blowjob, 6:kiss

; Framework access
sslSystemConfig Config
sslActorLibrary ActorLib
sslActorStats Stats
Actor PlayerRef

; Actor Info
Actor property ActorRef auto hidden
ActorBase BaseRef
string ActorName
int BaseSex
int Gender
bool IsMale
bool IsFemale
bool IsCreature
bool IsVictim
bool IsAggressor
bool IsPlayer
bool IsTracked
bool IsSkilled
bool IsVirgin
bool isStripped

int sfxSoundId
int sfxVoiceId
int actorSoundId
int Position

; Current Thread state
sslThreadController Thread

float StartWait
string StartAnimEvent
string EndAnimEvent
string ActorKey
bool NoOrgasm

; Voice
sslBaseVoice Voice
float BaseDelay
float VoiceDelay 
bool IsForcedSilent
bool UseLipSync
bool isOrgasming

; Expression
sslBaseExpression Expression

; Positioning
ObjectReference MarkerRef
float[] Offsets
float[] Center
float[] Loc

; Storage
int[] Flags
Form[] Equipment
bool[] StripOverride
float[] Skills

bool UseScale
float StartedAt
float ActorScale
float AnimScale
float LastOrgasm
int BestRelation
int BaseEnjoyment
int Enjoyment
int Orgasms
int NthTranslation

bool property kPrepareActor = false auto hidden
bool property kSyncActor    = false auto hidden
bool property kResetActor   = false auto hidden
bool property kRefreshActor = false auto hidden
bool property kStartup      = false auto hidden
int  property KAnimateReady = 0 auto hidden

string[] sfxSoundBlocks
int 	 sfxSoundBlockIdx
string   sfxPlayStatus
string   sfxVoice
string   sfxSound
float    moanSoundOffset
float    sfxVoiceOffset
float    actorVolume

Form Strapon
Form HadStrapon

Spell HDTHeelSpell

; Animation Position/Stage flags
bool property OpenMouth hidden
	bool function get()
		return Flags[1] == 1
	endFunction
endProperty
bool property IsSilent hidden
	bool function get()
		return !Voice || IsForcedSilent || Flags[0] == 1 || Flags[1] == 1
	endFunction
endProperty
bool property UseStrapon hidden
	bool function get()
		return Flags[2] == 1 && Flags[4] == 0
	endFunction
endProperty
int property Schlong hidden
	int function get()
		return Flags[3]
	endFunction
endProperty
bool property MalePosition hidden
	bool function get()
		return Flags[4] == 0
	endFunction
endProperty


; ------------------------------------------------------- ;
; --- Load/Clear Alias For Use                        --- ;
; ------------------------------------------------------- ;

bool function SetActor(Actor ProspectRef)
	log("setActor")
	kPrepareActor = false
	kSyncActor    = false
	kResetActor   = false
	kRefreshActor = false
	kStartup      = false
	KAnimateReady = 0

	if !ProspectRef || ProspectRef != GetReference()
		return false ; Failed to set prospective actor into alias
	endIf
	; Init actor alias information
	ActorRef   = ProspectRef
	BaseRef    = ActorRef.GetLeveledActorBase()
	ActorName  = BaseRef.GetName()
	BaseSex    = BaseRef.GetSex()
	Gender     = ActorLib.GetGender(ActorRef)
	IsMale     = Gender == 0
	IsFemale   = Gender == 1
	IsCreature = Gender >= 2
	IsTracked  = Config.ThreadLib.IsActorTracked(ActorRef)
	IsPlayer   = ActorRef == PlayerRef
	IsAggressor = !IsVictim
	; Player and creature specific
	if IsPlayer
		Thread.HasPlayer = true
	endIf
	if IsCreature
		Thread.CreatureRef = BaseRef.GetRace()
	elseIf !IsPlayer
		Stats.SeedActor(ActorRef)
	endIf
	; Actor's Adjustment Key
	ActorKey = MiscUtil.GetRaceEditorID(BaseRef.GetRace())
	if IsCreature
		ActorKey += "C"
	elseIf BaseSex == 1
		ActorKey += "F"
	else
		ActorKey += "M"
	endIf
	; Set base voice/loop delay
	if IsCreature
		BaseDelay  = 3.0
	elseIf IsFemale
		BaseDelay  = Config.FemaleVoiceDelay
	else
		BaseDelay  = Config.MaleVoiceDelay
	endIf
	VoiceDelay = BaseDelay
	; Init some needed arrays
	Flags   = new int[7]
	Offsets = new float[4]
	Loc     = new float[6]
	; Ready
	RegisterEvents()
	TrackedEvent("Added")
	GoToState("Ready")
	Log(self, "SetActor("+ActorRef+")")
	return true
endFunction

function ClearAlias()		
	log("ClearAlias")
	; Maybe got here prematurely, give it 10 seconds before forcing the clear
	if GetState() == "Resetting"
		float Failsafe = Utility.GetCurrentRealTime() + 10.0
		while GetState() == "Resetting" && Utility.GetCurrentRealTime() < Failsafe
			Utility.WaitMenuMode(0.2)
		endWhile
	endIf

	if !isPlayer
		ActorRef.SetUnconscious(false)
	endif

	; Make sure actor is reset
	if GetReference()
		; Init variables needed for reset
		ActorRef   = GetReference() as Actor
		BaseRef    = ActorRef.GetLeveledActorBase()
		ActorName  = BaseRef.GetName()
		BaseSex    = BaseRef.GetSex()
		Gender     = ActorLib.GetGender(ActorRef)
		IsMale     = Gender == 0
		IsFemale   = Gender == 1
		IsCreature = Gender >= 2
		IsPlayer   = ActorRef == PlayerRef
		Log("Actor present during alias clear! This is usually harmless as the alias and actor will correct itself, but is usually a sign that a thread did not close cleanly.", "ClearAlias("+ActorRef+" / "+self+")")
		; Reset actor back to default
		ClearEffects()
		RestoreActorDefaults()
		StopAnimating(true)

		UnlockActor()
		Unstrip()
	endIf
	Initialize()
	GoToState("")
endFunction

; Thread/alias shares
bool DebugMode
; bool SeparateOrgasms
int[] BedStatus
; float[] RealTime
float[] SkillBonus
string AdjustKey
bool[] IsType

sslBaseAnimation Animation

function LoadShares()

	UseLipSync = Config.UseLipSync && !IsCreature

	Center     = Thread.CenterLocation
	BedStatus  = Thread.BedStatus
	SkillBonus = Thread.SkillBonus
	AdjustKey  = Thread.AdjustKey
	IsType     = Thread.IsType
	Position = Thread.Positions.Find(ActorRef)
endFunction

function GetPositionInfo()
	if ActorRef
		if !AdjustKey
			SetAdjustKey(Thread.AdjustKey)
		endIf
		
		Animation  = Thread.Animation
		Flags      = Animation.PositionFlags(Flags, AdjustKey, Position, Thread.Stage)
		Offsets    = Animation.PositionOffsets(Offsets, AdjustKey, Position, Thread.Stage, BedStatus[1])
		CurrentSA  = Animation.Registry		
	endIf
endFunction
; ------------------------------------------------------- ;
; --- Actor Prepartion                                --- ;
; ------------------------------------------------------- ;

state Ready

	bool function SetActor(Actor ProspectRef)
		return false
	endFunction

	function PrepareActor()
		; Remove any unwanted combat effects
		ClearEffects()
		if IsPlayer
			Game.SetPlayerAIDriven()
		endIf
		ActorRef.SetFactionRank(Config.AnimatingFaction, 1)
		ActorRef.EvaluatePackage()
		; Starting Information
		LoadShares()
		GetPositionInfo()		
		string LogInfo
		; Calculate scales
		if UseScale
			float display = ActorRef.GetScale()
			ActorRef.SetScale(1.0)
			float base = ActorRef.GetScale()
			ActorScale = ( display / base )
			AnimScale  = ActorScale
			ActorRef.SetScale(ActorScale)
			if Thread.ActorCount > 1 && Config.ScaleActors ; FIXME: || IsCreature?
				AnimScale = (1.0 / base)
			endIf
			LogInfo = "Scales["+display+"/"+base+"/"+AnimScale+"] "
		else
			AnimScale = 1.0
			LogInfo = "Scales["+ActorRef.GetScale()+"/ DISABLED] "
		endIf
		; Stop other movements
		if DoPathToCenter
			PathToCenter()
		endIf
		LockActor()
		; pre-move to starting position near other actors
		Offsets[0] = 0.0
		Offsets[1] = 0.0
		Offsets[2] = 5.0 ; hopefully prevents some users underground/teleport to giant camp problem?
		Offsets[3] = 0.0
		; Starting position
		if Position == 1
			Offsets[0] = 25.0
			Offsets[3] = 180.0

		elseif Position == 2
			Offsets[1] = -25.0
			Offsets[3] = 90.0

		elseif Position == 3
			Offsets[1] = 25.0
			Offsets[3] = -90.0

		elseif Position == 4
			Offsets[0] = -25.0

		endIf
		OffsetCoords(Loc, Center, Offsets)
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
		ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		AttachMarker()			

		if Voice
			LogInfo += "Voice["+Voice.Name+"] "
		endIf
		; Player specific actions
		if IsPlayer
			FormList FrostExceptions = Config.FrostExceptions
			if FrostExceptions
				FrostExceptions.AddForm(Config.BaseMarker)
			endIf
		endIf
		; Extras for non creatures
		if !IsCreature
			; Decide on strapon for female, default to worn, otherwise pick random.
			if IsFemale && Config.UseStrapons
				HadStrapon = Config.WornStrapon(ActorRef)
				Strapon    = HadStrapon
				if !HadStrapon
					Strapon = Config.GetStrapon()
				endIf
			endIf
			
			; ; Strip actor
			; Strip()
			; ResolveStrapon()
			; Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
			; Suppress High Heels
			if IsFemale && Config.RemoveHeelEffect && ActorRef.GetWornForm(0x00000080)
				; Remove NiOverride High Heels
				if Config.HasNiOverride && NiOverride.HasNodeTransformPosition(ActorRef, false, IsFemale, "NPC", "internal")
					float[] pos = NiOverride.GetNodeTransformPosition(ActorRef, false, IsFemale, "NPC", "internal")
					Log(pos, "RemoveHeelEffect (NiOverride)")
					pos[0] = -pos[0]
					pos[1] = -pos[1]
					pos[2] = -pos[2]
					NiOverride.AddNodeTransformPosition(ActorRef, false, IsFemale, "NPC", "SexLab.esm", pos)
					NiOverride.UpdateNodeTransform(ActorRef, false, IsFemale, "NPC")
				endIf
				; Remove HDT High Heels
				HDTHeelSpell = Config.GetHDTSpell(ActorRef)
				if HDTHeelSpell
					Log(HDTHeelSpell, "RemoveHeelEffect (HDTHeelSpell)")
					ActorRef.RemoveSpell(HDTHeelSpell)
				endIf
			endIf
			; Pick an expression if needed
			if !Expression && Config.UseExpressions
				Expression = Config.ExpressionSlots.PickByStatus(ActorRef, IsVictim, IsType[0] && !IsVictim)
			endIf
			if Expression
				LogInfo += "Expression["+Expression.Name+"] "
			endIf
		endIf
		IsSkilled = !IsCreature || sslActorStats.IsSkilled(ActorRef)
		if IsSkilled
			; Always use players stats for NPCS if present, so players stats mean something more
			Actor SkilledActor = ActorRef
			if !IsPlayer && Thread.HasPlayer 
				SkilledActor = PlayerRef
			; If a non-creature couple, base skills off partner
			elseIf Thread.ActorCount > 1 && !Thread.HasCreature
				SkilledActor = Thread.Positions[sslUtility.IndexTravel(Position, Thread.ActorCount)]
			endIf
			; Get sex skills of partner/player
			Skills       = Stats.GetSkillLevels(SkilledActor)
			BestRelation = Thread.GetHighestPresentRelationshipRank(ActorRef)
			if IsVictim
				BaseEnjoyment = Utility.RandomFloat(BestRelation, ((Skills[Stats.kLewd]*1.1) as int)) as int
			elseIf IsAggressor
				float OwnLewd = Stats.GetSkillLevel(ActorRef, "Lewd", 0.3)
				BaseEnjoyment = Utility.RandomFloat(OwnLewd, ((Skills[Stats.kLewd]*1.3) as int) + (OwnLewd*1.7)) as int
			else
				BaseEnjoyment = Utility.RandomFloat(BestRelation, ((Skills[Stats.kLewd]*1.5) as int) + (BestRelation*1.5)) as int
			endIf
			if BaseEnjoyment < 0
				BaseEnjoyment = 0
			elseIf BaseEnjoyment > 25
				BaseEnjoyment = 25
			endIf
		else
			BaseEnjoyment = Utility.RandomInt(0, 10)
		endIf

		; Play custom starting animation event
		if StartAnimEvent != ""
			Debug.SendAnimationEvent(ActorRef, StartAnimEvent)
		endIf
		if StartWait < 0.1
			StartWait = 0.1
		endIf
		GoToState("Prepare")
		RegisterForSingleUpdate(StartWait)
	endFunction

	function PathToCenter()
		ObjectReference CenterRef = Thread.CenterAlias.GetReference()
		if CenterRef && ActorRef && (Thread.ActorCount > 1 || CenterRef != ActorRef)
			ObjectReference WaitRef = CenterRef
			if CenterRef == ActorRef
				WaitRef = Thread.Positions[IntIfElse(Position != 0, 0, 1)]
			endIf
			float Distance = ActorRef.GetDistance(WaitRef)
			if WaitRef && Distance < 8000.0 && Distance > 135.0
				if CenterRef != ActorRef
					ActorRef.SetFactionRank(Config.AnimatingFaction, 2)
					ActorRef.EvaluatePackage()
				endIf
				ActorRef.SetLookAt(WaitRef, true)

				; Start wait loop for actor pathing.
				int StuckCheck  = 0
				float Failsafe  = Utility.GetCurrentRealTime() + 30.0
				while Distance > 80.0 && Utility.GetCurrentRealTime() < Failsafe
					Utility.Wait(1.0)
					float Previous = Distance
					Distance = ActorRef.GetDistance(WaitRef)
					Log("Current Distance From WaitRef["+WaitRef+"]: "+Distance+" // Moved: "+(Previous - Distance))
					; Check if same distance as last time.
					if Math.Abs(Previous - Distance) < 1.0
						if StuckCheck > 2 ; Stuck for 2nd time, end loop.
							Distance = 0.0
						endIf
						StuckCheck += 1 ; End loop on next iteration if still stuck.
						Log("StuckCheck("+StuckCheck+") No progress while waiting for ["+WaitRef+"]")
					else
						StuckCheck -= 1 ; Reset stuckcheck if progress was made.
					endIf
				endWhile

				ActorRef.ClearLookAt()
				if CenterRef != ActorRef
					ActorRef.SetFactionRank(Config.AnimatingFaction, 1)
					ActorRef.EvaluatePackage()
				endIf
			endIf
		endIf
	endFunction

endState

state Prepare
	event OnUpdate()
		; Utility.Wait(5.0) ; DEV TMP

		ClearEffects()
		; GetPositionInfo()
		; Starting position
		OffsetCoords(Loc, Center, Offsets)
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
		ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		AttachMarker()
		Debug.SendAnimationEvent(ActorRef, "SOSFastErect")

		kPrepareActor = true
		StartupActor()
	endEvent

	function StartupActor()		
		TrackedEvent("Start")
		; Remove from bard audience if in one
		Config.CheckBardAudience(ActorRef, true)
		
		; Prepare for loop
		StopAnimating(true)
		GoToState("Animating")
		SyncAll(true)
		CurrentSA = Animation.Registry
		; Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		; If enabled, start Auto TFC for player
		if IsPlayer && Config.AutoTFC
			MiscUtil.SetFreeCameraState(true)
			MiscUtil.SetFreeCameraSpeed(Config.AutoSUCSM)
		endIf

		kStartup = true
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;
function PrepareAnimate()
endFunction

function StartAnimate()
endFunction

function onUpdateVolume(float volume)
endFunction

function onMenuModeEnter()
endFunction 

function onMenuModeExit()
endFunction 

function playMoan(float onUpdateStartTime, float _actorVolume) 
endFunction	

function playSfxVoice(float onUpdateStartTime, float _actorVolume)  
endFunction

string CurrentSA
float LoopDelay
float aniPlayTime
float aniExpectPlayTime
float aniStartTime
string backupSfxPlayStatus

state Animating

	function onMenuModeEnter()
		backupSfxPlayStatus = sfxPlayStatus
		sfxPlayStatus = "ready"
		Sound.StopInstance(sfxVoiceId)
		Sound.StopInstance(sfxSoundId)
		Sound.StopInstance(actorSoundId)
		Debug.Notification("InMenu")
		UnregisterForUpdate()
	endFunction

	function onMenuModeExit()
		sfxPlayStatus = backupSfxPlayStatus
		aniPlayTime = 0
		aniExpectPlayTime = 0
		Debug.Notification("OutMenu")
		RegisterForSingleUpdate(0.0)
	endFunction

	function onUpdateVolume(float volume)
		actorVolume = volume
	endFunction

	function PrepareAnimate ()
		sfxPlayStatus = "ready"
		UnregisterForUpdate()
	
		float startAnimationTime =  Utility.GetCurrentRealTime()
		
		Sound.StopInstance(sfxSoundId)
		Sound.StopInstance(sfxVoiceId)
		Sound.StopInstance(actorSoundId)

		sfxSoundId = -999
		sfxVoiceId = -999
		actorSoundId = -999
		
		if Thread.Stage == 1
			isStripped = false
			kPrepareActor = false
			kResetActor   = false
			kRefreshActor = false
			kSyncActor    = false
			kStartup      = false
			KAnimateReady = 0

			isOrgasming = false
			LoadShares()
			StartedAt = Utility.GetCurrentRealTime()

			;팩션 랭크 업데이트
			ActorRef.SetFactionRank(Thread.SfxPositionFaction, position)
			ActorRef.SetFactionRank(Thread.SfxPlayRoleFaction, Thread.SfxPlayRoleType)
			ActorRef.SetFactionRank(Thread.SfxPlayTypeFaction, Thread.SfxPlayType)
			
			; 보이스는 속성에 따라 보이스 정보 요청
			if !Voice && !IsForcedSilent
				String _actorVoice = ""
				if IsFemale
					_actorVoice = "Female_"
				else 
					_actorVoice = "Male_"
				endif
	
				String _voiceType = Thread.getVoiceType(ActorRef)

				if _voiceType == "Player" || _voiceType == "Young" || _voiceType == "Teen"
					IsVirgin = !IsCreature || Stats.SexCount(ActorRef) == 0
				endif

				_actorVoice += _voiceType			
				SetVoice(Config.VoiceSlots.GetByName(_actorVoice), IsForcedSilent)
			endif			

			if !IsPlayer
				actorRef.SetUnconscious(true)
			endif 
		endIf

		if position == 0
			Debug.Notification("Animation " + animation.name + ", Stage " + Thread.Stage)
		endif

		; 옷 벗기
		bool dress = false
		dress = animation.PositionDress(dress,  Position, Thread.Stage)

		if dress == false && isStripped == false
			isStripped = true
			Strip()			
			ResolveStrapon()			
		endif		
		
		; 거리에 따른 대화 내용 출력
		if actorVolume >= 0.2	
			;팩션 랭크 업데이트
			if Thread.Stage == Animation.StageCount
				ActorRef.SetFactionRank(Thread.SfxStageFaction, 99)	
			else 
				ActorRef.SetFactionRank(Thread.SfxStageFaction, Thread.Stage)
			endif
			SayDialog()
		endif

		; 표정 설정
		RefreshExpression()

		; TransitUp(50, 20)
		
		; SFX 사운드 동기화 정보 요청
		sfxVoice = Animation.PositionSfxVoice(sfxVoice, Position, Thread.Stage)
		sfxSound = Animation.PositionSfxSound(sfxSound, Position, Thread.Stage)

		if sfxSound != ""
			sfxSoundBlocks = PapyrusUtil.StringSplit(sfxSound, ",")
			sfxSoundBlockIdx = 0
		endif
				
		moanSoundOffset = startAnimationTime
		sfxVoiceOffset = startAnimationTime - 9
		KAnimateReady = Thread.Stage

	endFunction

	function StartAnimate()
		if !ActorRef.Is3DLoaded() || ActorRef.IsDisabled() || ActorRef.IsDead()			
			Thread.EndAnimation(true)
			return
		endIf	

		sfxPlayStatus = "start"
		RegisterForSingleUpdate(0.1)
	endFunction	

	event OnUpdate()
		float onUpdateStartTime =  Utility.GetCurrentRealTime()
		float delayTime = 0.0
		bool  shouldAnimation = false
		bool  shouldSkip = false

		if sfxPlayStatus == "play"
			aniPlayTime = onUpdateStartTime - aniStartTime
			delayTime = aniExpectPlayTime - aniPlayTime

			if delayTime < -1.0
				shouldSkip = true
			endif
			
		elseif sfxPlayStatus == "start"
			aniPlayTime = 0
			aniExpectPlayTime = 0
			sfxPlayStatus = "play"
			shouldAnimation = true
		elseif sfxPlayStatus == "ready"
			return
		endif

		
		float updateTime = VoiceDelay * 0.35

		if sfxSound != ""
			bool squeakyPlay = false
			float opTime = 0.0
			float idleTime  = 0.0
			updateTime = 0.0
												
			if sfxSoundBlockIdx >= sfxSoundBlocks.length
				sfxSoundBlockIdx = 0
			endif

			; sfx type 분석
			String[] blocks = PapyrusUtil.StringSplit(sfxSoundBlocks[sfxSoundBlockIdx], ":")
			sfxSoundBlockIdx += 1				
			String blockType = blocks[0]

			; sfx sound 에 대해 미리 플레이시간:대기시간 분석
			String[] timeBlocks = PapyrusUtil.StringSplit(blocks[1], "|")
			if timeBlocks.length > 1																			
				idleTime = timeBlocks[0] as float + (timeBlocks[1] as float - 0.075) ; 0.075 millisecond 빨리감기
				; Log("time[0]:" + timeBlocks[0] as float + ", time[1]: " + timeBlocks[1] as float)
			endif 

			Log("bt:" + blockType + ", pt: " + aniPlayTime + ", et: " + aniExpectPlayTime + ", dt: " + delayTime + ", it: " + idleTime)
			
			; 애니메이션 플레이
			if shouldAnimation
				Debug.SendAnimationEvent(ActorRef, Animation.FetchPositionStage(Position, Thread.Stage))
				aniStartTime = onUpdateStartTime
			endif

			if blockType == "idle"
				idleTime = blocks[1] as float
				aniExpectPlayTime += idleTime
			elseif blockType == "jump"
				sfxSoundBlockIdx = blocks[1] as int
			else
				aniExpectPlayTime += idleTime		

				; 콘솔창같은 환경으로 인해, 시간 지연이 발생하는 경우, sfx 미출력
				if shouldSkip != true
					Utility.Wait(timeBlocks[0] as float + delayTime)  ; 1차 대기
						
					if actorVolume > 0.0
						float _actorVolume = actorVolume
						; play sfx sound
						Sound.StopInstance(sfxSoundId)

						if blockType == "fuck"			; fuck
							sfxSoundId = Thread.SfxFuckSound.Play(actorRef)
							_actorVolume -= 0.1
							squeakyPlay = true
						elseif blockType == "pusy"		; pussy
							sfxSoundId = Thread.SfxPussySound.Play(actorRef)
							_actorVolume -= 0.2
							squeakyPlay = true	
						elseif blockType == "weak"		; fuck weak
							sfxSoundId = Thread.SfxWeakSound.Play(actorRef)
							_actorVolume -= 0.3
							squeakyPlay = true
						elseif blockType == "squk"		; squeak
							sfxSoundId = -999
							squeakyPlay = true
						else
							if OpenMouth
								if blockType == "lick"
									if isFemale 
										sfxSoundId = Thread.Sfx_F_LickSound.Play(actorRef)
									else 
										sfxSoundId = Thread.Sfx_M_LickSound.Play(actorRef)
									endif
								elseif blockType == "moth"		; mouth
									if isFemale 
										sfxSoundId = Thread.Sfx_F_MouthSound.Play(actorRef)
									else 
										sfxSoundId = Thread.Sfx_M_MouthSound.Play(actorRef)
									endif
								elseif blockType == "dmth"		; deep mouth
									if isFemale 
										sfxSoundId = Thread.Sfx_F_DeepMouthSound.Play(actorRef)
									else 
										sfxSoundId = Thread.Sfx_M_DeepMouthSound.Play(actorRef)
									endif
								endif
							endif 
						endif 

						if Thread.hasFurnitureRole && squeakyPlay
							Sound.SetInstanceVolume(Thread.SfxBedSound.Play(actorRef), _actorVolume)
						endif
												
						if sfxSoundId != -999
							Sound.SetInstanceVolume(sfxSoundId, _actorVolume)
						endif

						; voice
						playSfxVoice(onUpdateStartTime, _actorVolume)
						; moan
						playMoan(onUpdateStartTime, _actorVolume)						
					endif
				endif
			endif

			opTime = Utility.GetCurrentRealTime() - onUpdateStartTime
			if idleTime >= opTime
				updateTime = idleTime - opTime
			endif

			updateTime += delayTime
		else
			; 애니메이션 플레이
			if shouldAnimation
				Debug.SendAnimationEvent(ActorRef, Animation.FetchPositionStage(Position, Thread.Stage)) 
				aniStartTime = onUpdateStartTime
			endif

			; voice
			playSfxVoice(onUpdateStartTime, actorVolume)						
			; moan
			playMoan(onUpdateStartTime, actorVolume) 
	
		endif
		

		if sfxPlayStatus != "ready"
			RegisterForSingleUpdate(updateTime)
		endif
	endEvent

	function playSfxVoice(float onUpdateStartTime, float _actorVolume)	
		; play sfxVoice
		; Log("playSfxVoice: " + sfxVoice + ", openMouth: " + OpenMouth + ", silent: " + IsSilent)
		if !OpenMouth && ((onUpdateStartTime - sfxVoiceOffset) > 10) && sfxVoice != ""
			
			Sound.StopInstance(sfxVoiceId)

			if !IsSilent
				if sfxVoice == "joy"		; joy
					sfxVoiceId = Voice.GetJoySound().Play(actorRef)
				elseif sfxVoice == "hapy"	; happy
					sfxVoiceId = Voice.GetHappySound().Play(actorRef)
				elseif sfxVoice == "afad"	; afraid
					sfxVoiceId = Voice.GetAfraidSound().Play(actorRef)
				elseif sfxVoice == "fear"	; fear
					sfxVoiceId = Voice.GetFearSound().Play(actorRef)
				elseif sfxVoice == "pain"	; pain
					sfxVoiceId = Voice.GetPainSound().Play(actorRef)
				elseif sfxVoice == "yell"	; yelling
					sfxVoiceId = Voice.GetYellSound().Play(actorRef)
				elseif sfxVoice == "ggle"	; gigle
					sfxVoiceId = Voice.GetGiggleSound().Play(actorRef)	
				elseif sfxVoice == "enjy"	; enjoy
					sfxVoiceId = Voice.GetEnjoySound().Play(actorRef)					
				elseif sfxVoice == "plse"	; please
					sfxVoiceId = Voice.GetPleaseSound().Play(actorRef)
				endif
			else 
				if sfxVoice == "kiss"
					if isFemale
						sfxVoiceId = Thread.Sfx_F_KissSound.Play(actorRef)
					else 
						sfxVoiceId = Thread.Sfx_M_KissSound.Play(actorRef)
					endif
				endif				
			endif

			if sfxVoiceId != -999
				Sound.SetInstanceVolume(sfxVoiceId, _actorVolume)
				sfxVoiceOffset = onUpdateStartTime		
			endif			
		endif
	endfunction

	function playMoan(float onUpdateStartTime, float _actorVolume)
		if !OpenMouth && !IsSilent && ((onUpdateStartTime - moanSoundOffset) > 3) && !isOrgasming && sfxVoice == ""
			Sound.StopInstance(actorSoundId)
			moanSoundOffset = onUpdateStartTime
			; 	TransitDown(50, 20)
			GetEnjoyment()
			actorSoundId = Voice.PlayMoanSound(ActorRef, Enjoyment, UseLipSync, _actorVolume)
		endIf
	endfunction	

	function SyncThread()		
		; Sync with thread info
		GetPositionInfo()
		VoiceDelay = BaseDelay
		if !IsSilent && Thread.Stage > 1
			VoiceDelay -= (Thread.Stage * 0.8) + Utility.RandomFloat(-0.2, 0.4)
		endIf
		if VoiceDelay < 0.8
			VoiceDelay = Utility.RandomFloat(0.8, 1.4) ; Can't have delay shorter than animation update loop
		endIf
		; Update alias info
		GetEnjoyment()
		; Sync status
		if !IsCreature
			ResolveStrapon()
			RefreshExpression()
		endIf		
		; SyncLocation(false)
		Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		Utility.Wait(0.1)
		Debug.SendAnimationEvent(ActorRef, "SOSBend" + Schlong)
	endFunction

	function SyncActor()
		log ("SyncActor")
		SyncThread()
		SyncLocation(false)
		kSyncActor = true
	endFunction

	function SyncAll(bool Force = false)
		SyncThread()
		SyncLocation(Force)
	endFunction

	function RefreshActor()
		log ("RefreshActor")
		UnregisterForUpdate()
		SyncThread()
		StopAnimating(true)
		SyncLocation(true)
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
		Utility.WaitMenuMode(0.1)
		Debug.SendAnimationEvent(ActorRef, Animation.FetchPositionStage(Position, 1))
		CurrentSA = Animation.Registry
		SyncLocation(true)

		PrepareAnimate()
		StartAnimate()
		RegisterForSingleUpdate(1.0)
		kRefreshActor = true		
	endFunction

	function RefreshLoc()
		Offsets = Animation.PositionOffsets(Offsets, AdjustKey, Position, Thread.Stage, BedStatus[1])
		SyncLocation(true)
	endFunction

	function SyncLocation(bool Force = false)
		OffsetCoords(Loc, Center, Offsets)
		MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
		MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
		; Avoid forcibly setting on player coords if avoidable - causes annoying graphical flickering
		if Force && IsPlayer && IsInPosition(ActorRef, MarkerRef, 40.0)
			AttachMarker()
			ActorRef.TranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 50000, 0)
			return ; OnTranslationComplete() will take over when in place
		elseIf Force
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		endIf
		AttachMarker()
		Snap()
	endFunction

	function Snap()
		; Quickly move into place and angle if actor is off by a lot
		float distance = ActorRef.GetDistance(MarkerRef)
		if distance > 125.0 || !IsInPosition(ActorRef, MarkerRef, 75.0)
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
			AttachMarker()
		elseIf distance > 2.0
			ActorRef.TranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5], 50000, 0.0)
			return ; OnTranslationComplete() will take over when in place
		endIf
		; Begin very slowly rotating a small amount to hold position
		ActorRef.TranslateTo(Loc[0], Loc[1], Loc[2], Loc[3], Loc[4], Loc[5]+0.01, 500.0, 0.0001)
	endFunction

	event OnTranslationComplete()		
		Snap()
	endEvent

	function OrgasmEffect()
		DoOrgasm()
	endFunction

	function DoOrgasm(bool Forced = false)		
		string orgasmType = ""
		orgasmType = animation.PositionOrgasmType(orgasmType,  Position, Thread.Stage)
		
		if (Thread.DisableOrgasms || NoOrgasm || orgasmType== "none")
			; Orgasm Disabled for actor or whole thread
			return 
		elseIf Math.Abs(Utility.GetCurrentRealTime() - LastOrgasm) < 5.0
			Log("Excessive OrgasmEffect Triggered")
			return
		endIf

		LastOrgasm = StartedAt
		Orgasms   += 1
		; Reset enjoyment build up, if using multiple orgasms
		int FullEnjoyment = Enjoyment
		if Config.SeparateOrgasms
			BaseEnjoyment -= Enjoyment
			BaseEnjoyment += Utility.RandomInt((BestRelation + 10), PapyrusUtil.ClampInt(((Skills[Stats.kLewd]*1.5) as int) + (BestRelation + 10), 10, 35))
			FullEnjoyment  = GetEnjoyment()
		endIf
		; Send an orgasm event hook with actor and orgasm count
		int eid = ModEvent.Create("SexLabOrgasm")
		ModEvent.PushForm(eid, ActorRef)
		ModEvent.PushInt(eid, FullEnjoyment)
		ModEvent.PushInt(eid, Orgasms)
		ModEvent.Send(eid)
		TrackedEvent("Orgasm")
		
		; Apply cum to female positions from male position orgasm
		int i = Thread.ActorCount
		if i > 1 && Config.UseCum && (MalePosition || IsCreature) && (IsMale || IsCreature || (Config.AllowFFCum && IsFemale))
			if i == 2
				Thread.PositionAlias(IntIfElse(Position == 1, 0, 1)).ApplyCum()
			else
				while i > 0
					i -= 1
					if Position != i && Animation.IsCumSource(Position, i, Thread.Stage)
						Thread.PositionAlias(i).ApplyCum()
					endIf
				endWhile
			endIf
		endIf

		; Shake camera for player
		if IsPlayer && Game.GetCameraState() >= 8
			Game.ShakeCamera(none, 1.00, 2.0)
		endIf
			
		; Play SFX/Voice
		if !IsSilent && position == 0
			isOrgasming = true
			Sound.StopInstance(actorSoundId)
			Sound.StopInstance(sfxSoundId)
			PlayLouder(Voice.GetOrgasmSound(), ActorRef, actorVolume)
		endIf					
	endFunction

	event ResetActor()		
		if !isPlayer
			actorRef.SetUnconscious(false)
		endif

		ClearEvents()
		GoToState("Resetting")
		; Clear TFC
		if IsPlayer
			MiscUtil.SetFreeCameraState(false)
		endIf
		; Update stats
		if IsSkilled
			Actor VictimRef = Thread.VictimRef
			if IsVictim
				VictimRef = ActorRef
			endIf
			sslActorStats.RecordThread(ActorRef, Gender, BestRelation, StartedAt, Utility.GetCurrentRealTime(), Utility.GetCurrentGameTime(), Thread.HasPlayer, VictimRef, Thread.Genders, Thread.SkillXP)
			Stats.AddPartners(ActorRef, Thread.Positions, Thread.Victims)
		endIf
		; Apply cum
		;/ int CumID = Animation.GetCum(Position)
		if CumID > 0 && !Thread.FastEnd && Config.UseCum && (Thread.Males > 0 || Config.AllowFFCum || Thread.HasCreature)
			ActorLib.ApplyCum(ActorRef, CumID)
		endIf /;
		; Tracked events
		TrackedEvent("End")
		StopAnimating(Thread.FastEnd, EndAnimEvent)
		
		if (!Thread.DisableOrgasms && !NoOrgasm) 
			string orgasmType = ""
			orgasmType = animation.PositionOrgasmType(orgasmType,  Position, Thread.Stage)
			if orgasmType != "" && orgasmType != "none"
				doOrgasmScene(orgasmType)
			endif
		endif

		Sound.StopInstance(sfxSoundId)
		Sound.StopInstance(sfxVoiceId)
		Sound.StopInstance(actorSoundId)		

		RestoreActorDefaults()
		UnlockActor()		
		
		if !IsCreature && !ActorRef.IsDead()
				Unstrip()
				; Add back high heel effects
				if Config.RemoveHeelEffect
					; HDT High Heel
					if HDTHeelSpell && ActorRef.GetWornForm(0x00000080) && !ActorRef.HasSpell(HDTHeelSpell)
						ActorRef.AddSpell(HDTHeelSpell)
					endIf
					; NiOverride High Heels
					if Config.HasNiOverride && NiOverride.RemoveNodeTransformPosition(ActorRef, false, IsFemale, "NPC", "SexLab.esm")
						NiOverride.UpdateNodeTransform(ActorRef, false, IsFemale, "NPC")
					endIf
				endIf
		endIf
		; Free alias slot
		Clear()
		GoToState("")
		kResetActor = true
		; Thread.SyncEventDone(kResetActor)
	endEvent
endState

state Resetting
	function ClearAlias()
	endFunction
	event OnUpdate()
	endEvent
	function Initialize()
	endFunction
endState

function SyncAll(bool Force = false)
endFunction

; ------------------------------------------------------- ;
; --- alton added                                     --- ;
; ------------------------------------------------------- ;
; 종료 액션
function doOrgasmScene (String type)
	; 애니메이션 종료 후 추가 액션 처리
	if Config.OrgasmEffects
		bool isEndPlay = false

		if position == 0
			if IsFemale
				if IsVictim
					if type == "doggy"
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Victim_AfterFuck_Back_01")
						Utility.wait(6.0)
			
						int _randomValue = Utility.RandomInt(2, 3)
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Victim_AfterFuck_Back_0" + _randomValue)
						Utility.wait(4.0)
						isEndPlay = true
					elseif type == "cowgirl" || type == "missionary"
						Offsets[3] = 180			
						OffsetCoords(Loc, Center, Offsets)
						ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
						ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])				
				
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Victim_AfterFuck_Front_01")			
						Utility.wait(6.0)
	
						int _randomValue = Utility.RandomInt(2, 3)
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Victim_AfterFuck_Front_0" + _randomValue)
						Utility.wait(4.0)
						isEndPlay = true
					elseif type == "blowjob"
						int _randomValue = Utility.RandomInt(1, 2)
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Victim_AfterFuck_Blow_0" + _randomValue)
						Utility.wait(7.0)
						isEndPlay = true
					endif 
	
					; 액션 이후 적대관계 관계 설정  
					if IsAggressor
						thread.positions[0].SetRelationshipRank(actorRef, -3)
					endif
				else ; normal
					if type == "loving"
						Offsets[0] = 0.0
						Offsets[1] = 0.0
						Offsets[2] = 0.0
						Offsets[3] = 0.0
						OffsetCoords(Loc, Center, Offsets)
						ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
						ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])

						Debug.SendAnimationEvent(ActorRef, "SP_Foreplay_A1_S1")
						Utility.wait(4.0)
						Debug.SendAnimationEvent(ActorRef, "SP_Foreplay_A1_S2")
						Utility.wait(4.0)
						isEndPlay = true
					else
						Offsets[0] = 0
						OffsetCoords(Loc, Center, Offsets)
						ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
						ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
	
						int _randomValue = Utility.RandomInt(1, 4)
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Normal_AfterFuck_0" + _randomValue)
						Utility.wait(7.0)										
						isEndPlay = true
					endif
				endif 
			else 
				; male
				if IsVictim
				else 
				endif
			endif 
		elseif position == 1
			if type == "loving"
				Offsets[0] = 0.0
				Offsets[1] = 0.0
				Offsets[2] = 0.0
				Offsets[3] = 0.0
				OffsetCoords(Loc, Center, Offsets)
				ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
				ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])

				Debug.SendAnimationEvent(ActorRef, "SP_Foreplay_A2_S1")
				Utility.wait(4.0)
				Debug.SendAnimationEvent(ActorRef, "SP_Foreplay_A2_S2")
				Utility.wait(6.0)
				isEndPlay = true
			else 
				if IsMale 
					if type == "doggy" || type == "cowgirl" || type == "missionary" || type == "blowjob"
						Debug.SendAnimationEvent(ActorRef, "Scene_M_Normal_AfterFuck_01")
						Utility.wait(5.0)
						isEndPlay = true
					endif
				endif 
			endif
		endif 

		if isEndPlay 
			Debug.SendAnimationEvent(ActorRef, "Scene_StandUp")
			Utility.wait(1.0)
			Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")	
		endif		
	endif
endFunction

; 표정
function TransitUp(int from, int to)
	if OpenMouth == false
		while from < to
			from += 2			
			ActorRef.SetExpressionPhoneme(1, (from as float / 100.0)) ; SKYRIM SE
		endWhile
	endif
endFunction

function TransitDown( int from, int to)
	if OpenMouth == false
		while from > to
			from -= 2
			ActorRef.SetExpressionPhoneme(1, (from as float / 100.0)) ; SKYRIM SE
		endWhile
	endif
endFunction

; 대화
function SayDialog()
	
	; if Thread.SfxDialogScene && isPlayer && isVictim
	if Thread.SfxDialogScene && isPlayer
		Thread.SfxDialogScene.start()
	endif
	
;	if Thread.SfxDialogTopic
;		if isPlayer
;			ActorRef.say(Thread.SfxDialogTopic, ActorRef, true)
;		endif
		; if !isPlayer
		; 	ActorRef.SetUnconscious(false)
		; endif
		; ActorRef.say(Thread.SfxDialogTopic)
		; if !isPlayer
		; 	ActorRef.SetUnconscious(true)
		; endif
;	endif
endFunction

; alton add
; 액션중 공격을 받으면, 진행중인 액션은 종료
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	Debug.Notification("under attacked")
	Thread.EndAnimation()
endEvent	

; ------------------------------------------------------- ;
; --- Actor Manipulation                              --- ;
; ------------------------------------------------------- ;

function StopAnimating(bool Quick = false, string ResetAnim = "IdleForceDefaultState")
	if !ActorRef
		return
	endIf

	if !isPlayer
		ActorRef.SetUnconscious(false)
	endif

	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
	; Stop animevent
	if IsCreature
		; Reset creature idle
		Debug.SendAnimationEvent(ActorRef, "Reset")
		Debug.SendAnimationEvent(ActorRef, "ReturnToDefault")
		Debug.SendAnimationEvent(ActorRef, "ReturnDefaultState")
		Debug.SendAnimationEvent(ActorRef, "FNISDefault")
		Debug.SendAnimationEvent(ActorRef, "IdleReturnToDefault")
		Debug.SendAnimationEvent(ActorRef, "ForceFurnExit")
		if ResetAnim != "IdleForceDefaultState" && ResetAnim != ""
			ActorRef.Moveto(ActorRef)
			ActorRef.PushActorAway(ActorRef, 0.75)
		endIf
	else
		; Reset NPC/PC Idle Quickly
		Debug.SendAnimationEvent(ActorRef, ResetAnim)
		Utility.Wait(0.1)
		; Ragdoll NPC/PC if enabled and not in TFC
		if !Quick && ResetAnim != "" && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			ActorRef.Moveto(ActorRef)
			ActorRef.PushActorAway(ActorRef, 0.1)
		endIf
	endIf
endFunction

function AttachMarker()
	ActorRef.SetVehicle(MarkerRef)
	if UseScale
		ActorRef.SetScale(AnimScale)
	endIf
endFunction

function LockActor()

	log("lockActor")
	if !ActorRef
		return
	endIf

	; Remove any unwanted combat effects
	ClearEffects()
	; Stop whatever they are doing
	; Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
	; Start DoNothing package
	ActorUtil.AddPackageOverride(ActorRef, Config.DoNothing, 100, 1)
	ActorRef.SetFactionRank(Config.AnimatingFaction, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	
	if IsPlayer
		if Game.GetCameraState() == 0
			Game.ForceThirdPerson()
		endIf
		; abMovement = true, abFighting = true, abCamSwitch = false, abLooking = false, abSneaking = false, abMenu = true, abActivate = true, abJournalTabs = false, aiDisablePOVType = 0
		Game.DisablePlayerControls(true, true, false, false, false, false, false, false, 0)
		Game.SetPlayerAIDriven()
		; Enable hotkeys if needed, and disable autoadvance if not needed
		if IsVictim && Config.DisablePlayer
			Thread.AutoAdvance = true
		else
			Thread.AutoAdvance = Config.AutoAdvance
			Thread.EnableHotkeys()
		endIf
	else
		ActorRef.SetRestrained(true)
		ActorRef.SetDontMove(true)
	endIf
	; Attach positioning marker
	if !MarkerRef
		MarkerRef = ActorRef.PlaceAtMe(Config.BaseMarker)
		int cycle = 0
		while !MarkerRef.Is3DLoaded() && cycle < 50
			Utility.Wait(0.1)
			cycle += 1
		endWhile
		if cycle
			Log("Waited ["+cycle+"] cycles for MarkerRef["+MarkerRef+"]")
		endIf
	endIf
	MarkerRef.Enable()
	ActorRef.StopTranslation()
	MarkerRef.MoveTo(ActorRef)
	AttachMarker()
endFunction

function UnlockActor()
	if !ActorRef
		return
	endIf
		
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)	

	ActorUtil.RemovePackageOverride(ActorRef, Config.DoNothing)	
	ActorRef.EvaluatePackage()

	Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")

	; Enable movement
	if IsPlayer
		Thread.DisableHotkeys()
		MiscUtil.SetFreeCameraState(false)
		; Game.EnablePlayerControls(true, true, false, false, false, false, false, false, 0)
		Game.EnablePlayerControls()
		Game.SetPlayerAIDriven(false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
	endIf

endFunction

function RestoreActorDefaults()
	; Make sure  have actor, can't afford to miss this block
	if !ActorRef
		ActorRef = GetReference() as Actor
		if !ActorRef
			return ; No actor, reset prematurely or bad call to alias
		endIf
	endIf	
	; Reset to starting scale
	if UseScale && ActorScale > 0.0
		ActorRef.SetScale(ActorScale)
	endIf
	if !IsCreature
		; Reset voicetype
		; if ActorVoice && ActorVoice != BaseRef.GetVoiceType()
		; 	BaseRef.SetVoiceType(ActorVoice)
		; endIf
		; Remove strapon
		if Strapon && !HadStrapon; && Strapon != HadStrapon
			ActorRef.RemoveItem(Strapon, 1, true)
		endIf
		; Reset expression
		ActorRef.ClearExpressionOverride()
		sslBaseExpression.ClearMFG(ActorRef)
	endIf
	; Player specific actions
	if IsPlayer
		; Remove player from frostfall exposure exception
		FormList FrostExceptions = Config.FrostExceptions
		if FrostExceptions
			FrostExceptions.RemoveAddedForm(Config.BaseMarker)
		endIf
	endIf	
endFunction

function RefreshActor()
endFunction

; ------------------------------------------------------- ;
; --- Data Accessors                                  --- ;
; ------------------------------------------------------- ;

int function GetGender()
	return Gender
endFunction

function SetVictim(bool Victimize)
	Actor[] Victims = Thread.Victims
	; Make victim
	if Victimize && (!Victims || Victims.Find(ActorRef) == -1)
		Victims = PapyrusUtil.PushActor(Victims, ActorRef)
		Thread.Victims = Victims
		Thread.IsAggressive = true
	; Was victim but now isn't, update thread
	elseIf IsVictim && !Victimize
		Victims = PapyrusUtil.RemoveActor(Victims, ActorRef)
		Thread.Victims = Victims
		if !Victims || Victims.Length < 1
			Thread.IsAggressive = false
		endIf
	endIf
	IsVictim = Victimize
endFunction

string function GetActorKey()
	return ActorKey
endFunction

function SetAdjustKey(string KeyVar)
	if ActorRef
		AdjustKey = KeyVar
		Position  = Thread.Positions.Find(ActorRef)
	endIf
endfunction

int function GetEnjoyment()
	if !ActorRef
		Enjoyment = 0
	elseif !IsSkilled
		Enjoyment = (PapyrusUtil.ClampFloat(1.0 / 5.0, 0.0, 40.0) + ((Thread.Stage as float / Animation.StageCount as float) * 60.0)) as int
	else
		if Position == 0
			Thread.RecordSkills()
			Thread.SetBonuses()
		endIf		

		; Debug.Notification("gameTime " + Utility.GetCurrentGameTime())	; 1.916

		float perStage = 0.0
		if Thread.Stage == 1
			Enjoyment = BaseEnjoyment
		else
			perStage =  ((Thread.Stage - 1.0) / Animation.StageCount) * 100
			Enjoyment = BaseEnjoyment + perStage as int
		endif

		; Enjoyment = BaseEnjoyment + CalcEnjoyment(SkillBonus, Skills, Thread.LeadIn, IsFemale, 0, Thread.Stage, Animation.StageCount)
		
		if Enjoyment < 0
			Enjoyment = 0
		elseIf Enjoyment > 100
			Enjoyment = 100
		endIf
		; Log("Enjoyment["+Enjoyment+"] / BaseEnjoyment["+BaseEnjoyment+"] / FullEnjoyment["+(Enjoyment - BaseEnjoyment)+"]")
	endIf
	return Enjoyment - BaseEnjoyment
endFunction

function ApplyCum()
	if ActorRef
		int CumID = Animation.GetCumID(Position, Thread.Stage)
		if CumID > 0
			ActorLib.ApplyCum(ActorRef, CumID)
		endIf
	endIf
endFunction

function DisableOrgasm(bool bNoOrgasm)
	if ActorRef
		NoOrgasm = bNoOrgasm
	endIf
endFunction

bool function IsOrgasmAllowed()
	return !NoOrgasm && !Thread.DisableOrgasms
endFunction

bool function NeedsOrgasm()
	return GetEnjoyment() >= 100 && Enjoyment >= 100
endFunction

int function GetPain()
	if !ActorRef
		return 0
	endIf
	float Pain = Math.Abs(100.0 - PapyrusUtil.ClampFloat(GetEnjoyment() as float, 1.0, 99.0))
	if IsVictim
		Pain *= 1.5
	elseIf Animation.HasTag("Aggressive") || Animation.HasTag("Rough")
		Pain *= 0.8
	else
		Pain *= 0.3
	endIf
	return PapyrusUtil.ClampInt(Pain as int, 0, 100)
endFunction

function SetVoice(sslBaseVoice ToVoice = none, bool ForceSilence = false)
	IsForcedSilent = ForceSilence
	if ToVoice && IsCreature == ToVoice.Creature
		Voice = ToVoice
	endIf
endFunction

sslBaseVoice function GetVoice()
	return Voice
endFunction

function SetExpression(sslBaseExpression ToExpression)
	if ToExpression
		Expression = ToExpression
	endIf
endFunction

sslBaseExpression function GetExpression()
	return Expression
endFunction

function SetStartAnimationEvent(string EventName, float PlayTime)
	StartAnimEvent = EventName
	StartWait = PapyrusUtil.ClampFloat(PlayTime, 0.1, 10.0)
endFunction

function SetEndAnimationEvent(string EventName)
	EndAnimEvent = EventName
endFunction

bool function IsUsingStrapon()
	return Strapon && ActorRef.IsEquipped(Strapon)
endFunction

function ResolveStrapon(bool force = false)
	if Strapon
		if UseStrapon && !ActorRef.IsEquipped(Strapon)
			ActorRef.EquipItem(Strapon, true, true)
		elseIf !UseStrapon && ActorRef.IsEquipped(Strapon)
			ActorRef.UnequipItem(Strapon, true, true)
		endIf
	endIf
endFunction

function EquipStrapon()
	if Strapon && !ActorRef.IsEquipped(Strapon)
		ActorRef.EquipItem(Strapon, true, true)
	endIf
endFunction

function UnequipStrapon()
	if Strapon && ActorRef.IsEquipped(Strapon)
		ActorRef.UnequipItem(Strapon, true, true)
	endIf
endFunction

function SetStrapon(Form ToStrapon)
	if Strapon && !HadStrapon
		ActorRef.RemoveItem(Strapon, 1, true)
	endIf
	Strapon = ToStrapon
	if GetState() == "Animating"
		SyncThread()
	endIf
endFunction

Form function GetStrapon()
	return Strapon
endFunction

bool function PregnancyRisk()
	int cumID = Animation.GetCumID(Position, Thread.Stage)
	return cumID > 0 && (cumID == 1 || cumID == 4 || cumID == 5 || cumID == 7) && IsFemale && !MalePosition && Thread.IsVaginal
endFunction

function OverrideStrip(bool[] SetStrip)
	if SetStrip.Length != 33
		Thread.Log("Invalid strip override bool[] - Must be length 33 - was "+SetStrip.Length, "OverrideStrip()")
	else
		StripOverride = SetStrip
	endIf
endFunction

bool function ContinueStrip(Form ItemRef, bool DoStrip = true)
	return ItemRef && ((StorageUtil.FormListHas(none, "AlwaysStrip", ItemRef) || SexLabUtil.HasKeywordSub(ItemRef, "AlwaysStrip")) \
		|| (DoStrip && !(StorageUtil.FormListHas(none, "NoStrip", ItemRef) || SexLabUtil.HasKeywordSub(ItemRef, "NoStrip")))) 
endFunction

function Strip()
	if !ActorRef || IsCreature
		return
	endIf
	; Start stripping animation	
	if DoUndress && Thread.stage == 1 && position < 2
		if !actorRef.GetWornForm(0x00000004)
			Debug.SendAnimationEvent(ActorRef, "Scene_" + BaseSex + "_Undress")
			Utility.Wait(5.0)
		endif
		NoUndress = true
	endIf
	; Select stripping array
	bool[] Strip
	if StripOverride.Length == 33
		Strip = StripOverride
	else
		Strip = Config.GetStrip(IsFemale, Thread.UseLimitedStrip(), IsType[0], IsVictim)
	endIf
	; Log("Strip: "+Strip)
	; Stripped storage
	Form ItemRef
	Form[] Stripped = new Form[34]
	; Right hand
	ItemRef = ActorRef.GetEquippedObject(1)
	if ContinueStrip(ItemRef, Strip[32])
		Stripped[33] = ItemRef
		ActorRef.UnequipItemEX(ItemRef, 1, false)
		StorageUtil.SetIntValue(ItemRef, "Hand", 1)
	endIf
	; Left hand
	ItemRef = ActorRef.GetEquippedObject(0)
	if ContinueStrip(ItemRef, Strip[32])
		Stripped[32] = ItemRef
		ActorRef.UnequipItemEX(ItemRef, 2, false)
		StorageUtil.SetIntValue(ItemRef, "Hand", 2) 
	endIf
	; Strip armor slots
	int i = 31
	while i >= 0
		; Grab item in slot
		ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
		if ContinueStrip(ItemRef, Strip[i])
			ActorRef.UnequipItemEX(ItemRef, 0, false)
			Stripped[i] = ItemRef
		endIf
		; Move to next slot
		i -= 1
	endWhile
	; Equip the nudesuit
	if Strip[2] && ((Gender == 0 && Config.UseMaleNudeSuit) || (Gender == 1 && Config.UseFemaleNudeSuit))
		ActorRef.EquipItem(Config.NudeSuit, true, true)
	endIf
	; Store stripped items
	Equipment = PapyrusUtil.MergeFormArray(Equipment, PapyrusUtil.ClearNone(Stripped), true)
	Log("Equipment: "+Equipment)

	; 물건 크기 설정
	if isMale 	
		Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		Utility.Wait(0.1)
		Debug.SendAnimationEvent(ActorRef, "SOSBend" + Schlong)

		log("SOSBend " + Schlong)
	endif
endFunction

function UnStrip()
 	if !ActorRef || IsCreature || Equipment.Length == 0
 		return
 	endIf
	; Remove nudesuit if present
	if ActorRef.GetItemCount(Config.NudeSuit) > 0
		ActorRef.RemoveItem(Config.NudeSuit, ActorRef.GetItemCount(Config.NudeSuit), true)
	endIf
	; Continue with undress, or am I disabled?
 	if !DoRedress
 		return ; Fuck clothes, bitch.
 	endIf
 	; Equip Stripped
 	int i = Equipment.Length
 	while i
 		i -= 1
 		if Equipment[i]
 			int hand = StorageUtil.GetIntValue(Equipment[i], "Hand", 0)
 			if hand != 0
	 			StorageUtil.UnsetIntValue(Equipment[i], "Hand")
	 		endIf
	 		ActorRef.EquipItemEx(Equipment[i], hand, false)
  		endIf
 	endWhile
endFunction

bool NoRagdoll
bool property DoRagdoll hidden
	bool function get()
		if NoRagdoll
			return false
		endIf
		return !NoRagdoll && Config.RagdollEnd
	endFunction
	function set(bool value)
		NoRagdoll = !value
	endFunction
endProperty

bool NoUndress
bool property DoUndress hidden
	bool function get()
		if NoUndress
			return false
		endIf
		return Config.UndressAnimation
	endFunction
	function set(bool value)
		NoUndress = !value
	endFunction
endProperty

bool NoRedress
bool property DoRedress hidden
	bool function get()
		if NoRedress || (IsVictim && !Config.RedressVictim)
			return false
		endIf
		return !IsVictim || (IsVictim && Config.RedressVictim)
	endFunction
	function set(bool value)
		NoRedress = !value
	endFunction
endProperty

int PathingFlag
function ForcePathToCenter(bool forced)
	PathingFlag = (forced as int)
endFunction
function DisablePathToCenter(bool disabling)
	PathingFlag = IntIfElse(disabling, -1, (PathingFlag == 1) as int)
endFunction
bool property DoPathToCenter
	bool function get()
		return (PathingFlag == 0 && Config.DisableTeleport) || PathingFlag == 1
	endFunction
endProperty

function RefreshExpression()
	if !ActorRef || IsCreature
		; Do nothing
	elseIf OpenMouth == true
		sslBaseExpression.OpenMouth(ActorRef)
	else
		if Expression
			sslBaseExpression.CloseMouth(ActorRef)
			Expression.Apply(ActorRef, Enjoyment, BaseSex)
		elseIf sslBaseExpression.IsMouthOpen(ActorRef)
			sslBaseExpression.CloseMouth(ActorRef)			
		endIf
	endIf
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function TrackedEvent(string EventName)
	if IsTracked
		Thread.SendTrackedEvent(ActorRef, EventName)
	endif
endFunction

function ClearEffects()
	if IsPlayer && GetState() != "Animating"
		; MiscUtil.SetFreeCameraState(false)
		if Game.GetCameraState() == 0
			Game.ForceThirdPerson()
		endIf
	endIf
	if ActorRef.IsInCombat()
		ActorRef.StopCombat()
	endIf
	if ActorRef.IsWeaponDrawn()
		ActorRef.SheatheWeapon()
	endIf
	if ActorRef.IsSneaking()
		ActorRef.StartSneaking()
	endIf
	ActorRef.ClearKeepOffsetFromActor()
endFunction

function RegisterEvents()
	string e = Thread.Key("")
	; Quick Events
	RegisterForModEvent(e+"PrepareAnimate", "PrepareAnimate")
	RegisterForModEvent(e+"StartAnimate", "StartAnimate")
	RegisterForModEvent(e+"Orgasm", "OrgasmEffect")
	RegisterForModEvent(e+"Strip", "Strip")
	; Sync Events
	RegisterForModEvent(e+"Prepare", "PrepareActor")
	RegisterForModEvent(e+"Sync", "SyncActor")
	RegisterForModEvent(e+"Reset", "ResetActor")
	RegisterForModEvent(e+"Refresh", "RefreshActor")
	RegisterForModEvent(e+"Startup", "StartupActor")
endFunction

function ClearEvents()	
	UnregisterForUpdate()
	string e = Thread.Key("")
	; Quick Events
	UnregisterForModEvent(e+"PrepareAnimate")
	UnregisterForModEvent(e+"StartAnimate")
	UnregisterForModEvent(e+"Orgasm")
	UnregisterForModEvent(e+"Strip")
	; Sync Events
	UnregisterForModEvent(e+"Prepare")
	UnregisterForModEvent(e+"Sync")
	UnregisterForModEvent(e+"Reset")
	UnregisterForModEvent(e+"Refresh")
	UnregisterForModEvent(e+"Startup")
endFunction

function Initialize()
	; Clear actor
	if ActorRef
		; Stop events
		ClearEvents()
		; RestoreActorDefaults()
		; Remove nudesuit if present
		if ActorRef.GetItemCount(Config.NudeSuit) > 0
			ActorRef.RemoveItem(Config.NudeSuit, ActorRef.GetItemCount(Config.NudeSuit), true)
		endIf
	endIf
	; Delete positioning marker
	if MarkerRef
		MarkerRef.Disable()
		MarkerRef.Delete()
	endIf
	; Forms
	ActorRef       = none
	MarkerRef      = none
	HadStrapon     = none
	Strapon        = none
	HDTHeelSpell   = none
	; Voice
	Voice          = none
	;ActorVoice     = none
	IsForcedSilent = false
	; Expression
	Expression     = none
	; Flags
	NoRagdoll      = false
	NoUndress      = false
	NoRedress      = false
	NoOrgasm       = false
	; Integers
	Orgasms        = 0
	BestRelation   = 0
	BaseEnjoyment  = 0
	Enjoyment      = 0
	PathingFlag    = 0
	; Floats
	LastOrgasm     = 0.0
	ActorScale     = 0.0
	AnimScale      = 0.0
	StartWait      = 0.1
	; Strings
	EndAnimEvent   = "IdleForceDefaultState"
	StartAnimEvent = ""
	ActorKey       = ""
	CurrentSA      = ""
	; Storage
	StripOverride  = Utility.CreateBoolArray(0)
	Equipment      = Utility.CreateFormArray(0)
	; Make sure alias is emptied
	TryToClear()

	if !isPlayer
		ActorRef.SetUnconscious(false)
	endif	

endFunction

function Setup()
	; Reset function Libraries - SexLabQuestFramework
	if !Config || !ActorLib || !Stats
		Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
		if SexLabQuestFramework
			Config   = SexLabQuestFramework as sslSystemConfig
			ActorLib = SexLabQuestFramework as sslActorLibrary
			Stats    = SexLabQuestFramework as sslActorStats
		endIf
	endIf
	DebugMode  = Config.DebugMode
	UseScale   = !Config.DisableScale
	PlayerRef = Game.GetPlayer()
	Thread    = GetOwningQuest() as sslThreadController
endFunction

function Log(string msg, string src = "")
	msg = "ActorAlias["+ActorName+"] "+src+" - "+msg
	Debug.Trace("SEXLAB - " + msg)
	if DebugMode
		SexLabUtil.PrintConsole(msg)
		Debug.TraceUser("SexLabDebug", msg)
	endIf
endFunction

function PlayLouder(Sound SFX, ObjectReference FromRef, float Volume)
	if SFX && FromRef && Volume > 0.0
		if Volume > 0.5
			Sound.SetInstanceVolume(SFX.Play(FromRef), 1.0)
		else
			Sound.SetInstanceVolume(SFX.Play(FromRef), Volume)
		endIf
	endIf
endFunction

; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

; Ready
function PrepareActor()
endFunction
function PathToCenter()
endFunction
; Animating
function StartupActor()
endFunction
function SyncActor()
endFunction
function SyncThread()
endFunction
function SyncLocation(bool Force = false)
endFunction
function RefreshLoc()
endFunction
function Snap()
endFunction
event OnTranslationComplete()
endEvent
function OrgasmEffect()
endFunction
function DoOrgasm(bool Forced = false)
endFunction
event ResetActor()
endEvent

event OnOrgasm()
	OrgasmEffect()
endEvent
event OrgasmStage()
	OrgasmEffect()
endEvent

function OffsetCoords(float[] Output, float[] CenterCoords, float[] OffsetBy) global native
bool function IsInPosition(Actor CheckActor, ObjectReference CheckMarker, float maxdistance = 30.0) global native
; int function CalcEnjoyment(float[] XP, float[] SkillsAmounts, bool IsLeadin, bool IsFemaleActor, float Timer, int OnStage, int MaxStage) global native

int function IntIfElse(bool check, int isTrue, int isFalse)
	if check
		return isTrue
	endIf
	return isFalse
endfunction
