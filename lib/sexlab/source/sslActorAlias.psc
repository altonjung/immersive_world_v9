scriptname sslActorAlias extends ReferenceAlias

; Framework access
sslSystemConfig Config
sslActorLibrary ActorLib
sslActorStats Stats
Actor PlayerRef

; Actor Info
Actor property ActorRef auto hidden
ActorBase BaseRef
string ActorName
string RaceEditorID
String ActorRaceKey
int BaseSex
int Gender
bool isRealFemale
bool IsMale
bool IsFemale
bool IsCreature
bool IsVictim
bool IsAggressor
bool IsPlayer
bool IsTracked
bool IsSkilled
Faction AnimatingFaction

; Current Thread state
sslThreadController Thread
int Position
bool LeadIn

float StartWait
string StartAnimEvent
string EndAnimEvent
string ActorKey
bool NoOrgasm

; Voice
sslBaseVoice Voice
VoiceType ActorVoice
float BaseDelay
float VoiceDelay
float ExpressionDelay
bool IsForcedSilent
bool UseLipSync

; Expression
sslBaseExpression Expression
sslBaseExpression[] Expressions

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
float[] OwnSkills

bool UseScale
float StartedAt
float ActorScale
float AnimScale
float NioScale
float LastOrgasm
int BestRelation
int BaseEnjoyment
int QuitEnjoyment
int FullEnjoyment
int Orgasms
int NthTranslation

; alton added
bool property kPrepareActor = false auto hidden
bool property kStartup = false auto hidden
bool property kSyncActor    = false auto hidden
bool property kResetActor   = false auto hidden
bool property kRefreshActor = false auto hidden
int  property KAnimateReady = 0 auto hidden

string   sfxPlayStatus

String   sfxAction

string   sfxSound
string[] sfxSoundBlocks
int 	 sfxSoundBlockIdx
string   sfxVoice

string   sfxExpression

string   sfxExpressionStrength
string[] sfxExpressionStrengthBlocks
int 	 sfxExpressionStrengthIdx

float    sfxMoanOffset
float    sfxExpressionStrengthOffset

float    actorVolume
bool 	 IsOrgasming
bool 	 IsVirgin
bool 	 isStripped


int sfxSoundId
int sfxVoiceId
int moanSoundId

Form Strapon
Form HadStrapon

Sound OrgasmFX

Spell HDTHeelSpell
Form HadBoots

; Animation Position/Stage flags
bool property ForceOpenMouth auto hidden
bool property OpenMouth hidden
	bool function get()
		return Flags[1] == 1 || ForceOpenMouth == true ; This is for compatibility reasons because mods like DDi realy need it.
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

function RegisterEvents()
	string e = Thread.Key("")
	; Quick Events
	RegisterForModEvent(e+"PrepareAnimate", "PrepareAnimation")
	RegisterForModEvent(e+"StartAnimate", "StartAnimation")
	RegisterForModEvent(e+"Orgasm", "OrgasmEffect")
	RegisterForModEvent(e+"Strip", "Strip")
	; Sync Events
	RegisterForModEvent(e+"Prepare", "PrepareActor")
	RegisterForModEvent(e+"Sync", "SyncActor")
	RegisterForModEvent(e+"Reset", "ResetActor")
	RegisterForModEvent(e+"Refresh", "RefreshActor")
	RegisterForModEvent(e+"Startup", "StartAnimating")
endFunction

; ------------------------------------------------------- ;
; --- Load/Clear Alias For Use                        --- ;
; ------------------------------------------------------- ;

bool function SetActor(Actor ProspectRef)
	if !ProspectRef || ProspectRef != GetReference()
		Log("ERROR: SetActor("+ProspectRef+") on State:'Ready' is not allowed")
		return false ; Failed to set prospective actor into alias
	endIf
	; Init actor alias information
	ActorRef   = ProspectRef
	BaseRef    = ActorRef.GetLeveledActorBase()
	ActorName  = BaseRef.GetName()
	; ActorVoice = BaseRef.GetVoiceType()
	BaseSex    = BaseRef.GetSex()
	isRealFemale = BaseSex == 1
	Gender     = ActorLib.GetGender(ActorRef)
	IsMale     = Gender == 0
	IsFemale   = Gender == 1
	IsCreature = Gender >= 2
	IsTracked  = Config.ThreadLib.IsActorTracked(ActorRef)
	IsPlayer   = ActorRef == PlayerRef
	RaceEditorID = MiscUtil.GetRaceEditorID(BaseRef.GetRace())
	; Player and creature specific
	if IsPlayer
		Thread.HasPlayer = true
	endIf
	if IsCreature
		Thread.CreatureRef = BaseRef.GetRace()
		if sslCreatureAnimationSlots.HasRaceKey("Canines") && sslCreatureAnimationSlots.HasRaceID("Canines", RaceEditorID)
			ActorRaceKey = "Canines"
		else
			ActorRaceKey = sslCreatureAnimationSlots.GetRaceKeyByID(RaceEditorID)
		endIf
	elseIf !IsPlayer
		Stats.SeedActor(ActorRef)
	endIf
	; Actor's Adjustment Key
	ActorKey = RaceEditorID
	if !Config.RaceAdjustments
		if IsCreature
			if ActorRaceKey
				ActorKey = ActorRaceKey
			endIf
		else
			ActorKey = "Humanoid"
		endIf
	endIf
	if IsCreature
		ActorKey += "C"
	endIf
	if !IsCreature || Config.UseCreatureGender
		If isRealFemale
			ActorKey += "F"
		else
			ActorKey += "M"
		endIf
	endIf
	float TempScale
	String Node = "NPC"
	if NetImmerse.HasNode(ActorRef, Node, False)
		TempScale = NetImmerse.GetNodeScale(ActorRef, Node, False)
		if TempScale > 0
			NioScale = NioScale * TempScale
		endIf
	endIf
	Node = "NPC Root [Root]"
	if NetImmerse.HasNode(ActorRef, Node, False)
		TempScale = NetImmerse.GetNodeScale(ActorRef, Node, False)
		if TempScale > 0
			NioScale = NioScale * TempScale
		endIf
	endIf
	
	if Config.HasNiOverride && !IsCreature
		NioScale = 1.0
		string[] MOD_OVERRIDE_KEY = NiOverride.GetNodeTransformKeys(ActorRef, False, isRealFemale, "NPC")
		int idx = 0
		While idx < MOD_OVERRIDE_KEY.Length
			if MOD_OVERRIDE_KEY[idx] != "SexLab.esm"
				TempScale = NiOverride.GetNodeTransformScale(ActorRef, False, isRealFemale, "NPC", MOD_OVERRIDE_KEY[idx])
				if TempScale > 0
					NioScale = NioScale * TempScale
				endIf
			else ; Remove SexLab Node if present by error
				if NiOverride.RemoveNodeTransformScale(ActorRef, False, isRealFemale, "NPC", MOD_OVERRIDE_KEY[idx])
					NiOverride.UpdateNodeTransform(ActorRef, False, isRealFemale, "NPC")
				endIf
			endIf
			idx += 1
		endWhile
	;	Log(self, "NioScale("+NioScale+")")
	endIf

	if !Config.ScaleActors
		float ActorScalePlus
		if Config.RaceAdjustments
			ActorScalePlus = BaseRef.GetHeight()
		;	Log(self, "GetRaceScale("+ActorScalePlus+")")
		else
			ActorScalePlus = ActorRef.GetScale()
		;	Log(self, "GetScale("+ActorScalePlus+")")
		endIf
		if NioScale > 0.0 && NioScale != 1.0
			ActorScalePlus = ActorScalePlus * NioScale
		endIf
	;	Log(self, "ActorScalePlus("+ActorScalePlus+")")
		ActorScalePlus = ((ActorScalePlus * 25) + 0.5) as int
	;	Log(self, "ActorScalePlus("+ActorScalePlus+")")
		if ActorScalePlus != 25.0
			ActorKey += ActorScalePlus as int
		endIf
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
	ExpressionDelay = Config.ExpressionDelay * BaseDelay
	; Init some needed arrays
	Flags   = new int[5]
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
	log("clearAlias")

	; Maybe got here prematurely, give it 10 seconds before forcing the clear
	if GetState() == "Resetting"
		float Failsafe = Utility.GetCurrentRealTime() + 10.0
		while GetState() == "Resetting" && Utility.GetCurrentRealTime() < Failsafe
			Utility.WaitMenuMode(0.2)
		endWhile
	endIf
	; Make sure actor is reset
	if GetReference() && GetReference() as Actor != none
		; Init variables needed for reset
		ActorRef   = GetReference() as Actor
		BaseRef    = ActorRef.GetLeveledActorBase()
		ActorName  = BaseRef.GetName()
		BaseSex    = BaseRef.GetSex()
		isRealFemale = BaseSex == 1
		Gender     = ActorLib.GetGender(ActorRef)
		IsMale     = Gender == 0
		IsFemale   = Gender == 1
		IsCreature = Gender >= 2
		if !RaceEditorID || RaceEditorID == ""
			RaceEditorID = MiscUtil.GetRaceEditorID(BaseRef.GetRace())
		endIf
		if IsCreature
			ActorRaceKey = sslCreatureAnimationSlots.GetRaceKeyByID(RaceEditorID)
		endIf
		IsPlayer   = ActorRef == PlayerRef
		Log("Actor present during alias clear! This is usually harmless as the alias and actor will correct itself, but is usually a sign that a thread did not close cleanly.", "ClearAlias("+ActorRef+" / "+self+")")
		; Reset actor back to default
		ClearEvents()
		ClearEffects()
		StopAnimating(true)
		UnlockActor()
		RestoreActorDefaults()
		Unstrip()
	endIf
	Initialize()
	GoToState("")
endFunction

; Thread/alias shares
bool DebugMode
bool SeparateOrgasms
int[] BedStatus
float[] RealTime
float[] SkillBonus
string AdjustKey
bool[] IsType

int Stage
int StageCount
string[] AnimEvents
sslBaseAnimation Animation

function LoadShares()
	DebugMode  = Config.DebugMode
	UseLipSync = Config.UseLipSync && !IsCreature
	UseScale   = !Config.DisableScale

	Center     = Thread.CenterLocation
	Position   = Thread.Positions.Find(ActorRef)
	BedStatus  = Thread.BedStatus
	RealTime   = Thread.RealTime
	SkillBonus = Thread.SkillBonus
	AdjustKey  = Thread.AdjustKey
	IsType     = Thread.IsType
	LeadIn     = Thread.LeadIn
	AnimEvents = Thread.AnimEvents

	SeparateOrgasms = Config.SeparateOrgasms
	; AnimatingFaction = Config.AnimatingFaction ; TEMP
endFunction

; ------------------------------------------------------- ;
; --- Actor Prepartion                                --- ;
; ------------------------------------------------------- ;


state Ready
	event OnUpdate()
		if StartWait < 0.1
			StartWait = 0.1
		endIf
		string CurrentState = Thread.GetState()
		if CurrentState == "Ready"
			Log("WARNING: OnUpdate Event ON State:'Ready' FOR State:'"+CurrentState+"'")
			GoToState("Prepare")
			RegisterForSingleUpdate(StartWait)
		else
			Log("ERROR: OnUpdate Event ON State:'Ready' FOR State:'"+CurrentState+"'")
			RegisterForSingleUpdate(StartWait)
		endIf
	endEvent

	bool function SetActor(Actor ProspectRef)
		Log("ERROR: SetActor("+ActorRef.GetLeveledActorBase().GetName()+") on State:'Ready' is not allowed")
		return false
	endFunction

	function PrepareActor()
		; Remove any unwanted combat effects
		ClearEffects()
		if IsPlayer
			sslThreadController Control = Config.GetThreadControlled()
			if Control && Control != none
				Config.DisableThreadControl(Control)
			endIf
			Game.SetPlayerAIDriven()
		endIf
		ActorRef.SetFactionRank(AnimatingFaction, 1)
		ActorRef.EvaluatePackage()
		; Starting Information
		LoadShares()
		GetPositionInfo()
		IsAggressor = Thread.VictimRef && Thread.Victims.Find(ActorRef) == -1
		string LogInfo
		; Calculate scales
		if UseScale
			Thread.ApplyFade()
			float display = ActorRef.GetScale()
			ActorRef.SetScale(1.0)
			float base = ActorRef.GetScale()
			ActorScale = ( display / base )
			AnimScale  = ActorScale
			if ActorScale > 0.0 && ActorScale != 1.0
				ActorRef.SetScale(ActorScale)
			endIf
			float FixNioScale = 1.0
			if (Thread.ActorCount > 1 || BedStatus[1] >= 4) && Config.ScaleActors
				if Config.HasNiOverride && !IsCreature && NioScale > 0.0 && NioScale != 1.0
					FixNioScale = (FixNioScale / NioScale)
					NiOverride.AddNodeTransformScale(ActorRef, False, isRealFemale, "NPC", "SexLab.esm",FixNioScale)
					NiOverride.UpdateNodeTransform(ActorRef, False, isRealFemale, "NPC")
				endIf
				AnimScale = (1.0 / base)
			endIf
			LogInfo = "Scales["+display+"/"+base+"/"+ActorScale+"/"+AnimScale+"/"+NioScale+"] "
		else
			AnimScale = 1.0
			LogInfo = "Scales["+ActorRef.GetScale()+"/DISABLED/DISABLED/DISABLED/DISABLED/"+NioScale+"] "
		endIf
		; Stop other movements
		if DoPathToCenter
			PathToCenter()
		endIf
		LockActor()
		
		if BedStatus[1] <= 1
			; pre-move to starting position near other actors
			Offsets[0] = 0.0
			Offsets[1] = 0.0
			Offsets[2] = 5.0
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
		endIf

		; Player specific actions
		if IsPlayer
			Thread.RemoveFade()
			FormList FrostExceptions = Config.FrostExceptions
			if FrostExceptions
				FrostExceptions.AddForm(Config.BaseMarker)
			endIf
		endIf

		; Pick a voice if needed
		if !Voice && !IsForcedSilent
			if IsCreature
				SetVoice(Config.VoiceSlots.PickByRaceKey(sslCreatureAnimationSlots.GetRaceKey(BaseRef.GetRace())), IsForcedSilent)
			else
				SetVoice(Config.VoiceSlots.PickVoice(ActorRef), IsForcedSilent)
			endIf
		endIf
		if Voice
			LogInfo += "Voice["+Voice.Name+"] "
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
			; Strip actor
			; Strip()
			; ResolveStrapon()
			; Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
			; Remove HDT High Heels
			if Config.RemoveHeelEffect && ActorRef.GetWornForm(0x00000080)
				HDTHeelSpell = Config.GetHDTSpell(ActorRef)
				if HDTHeelSpell
					Log(HDTHeelSpell, "RemoveHeelEffect (HDTHeelSpell)")
					ActorRef.RemoveSpell(HDTHeelSpell)
				endIf
			endIf
			; Pick an expression if needed
			if !Expression && Config.UseExpressions
				Expressions = Config.ExpressionSlots.GetByStatus(ActorRef, IsVictim, IsType[0] && !IsVictim)
				if Expressions && Expressions.Length > 0
					Expression = Expressions[Utility.RandomInt(0, (Expressions.Length - 1))]
				endIf
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
			OwnSkills    = Stats.GetSkillLevels(ActorRef)
			; Try to prevent orgasms on fist stage resting enjoyment
			float FirsStageTime
			if LeadIn
				FirsStageTime = Config.StageTimerLeadIn[0]
			elseIf IsType[0]
				FirsStageTime = Config.StageTimerAggr[0]
			else
				FirsStageTime = Config.StageTimer[0]
			endIf
			BaseEnjoyment -= Math.Abs(CalcEnjoyment(SkillBonus, Skills, LeadIn, IsFemale, FirsStageTime, 1, StageCount)) as int
			; Add Bonus Enjoyment
			if IsVictim
				BestRelation = Thread.GetLowestPresentRelationshipRank(ActorRef)
				BaseEnjoyment += ((BestRelation - 3) + PapyrusUtil.ClampInt((OwnSkills[Stats.kLewd]-OwnSkills[Stats.kPure]) as int,-6,6)) * Utility.RandomInt(1, 10)
			else
				BestRelation = Thread.GetHighestPresentRelationshipRank(ActorRef)
				if IsAggressor
					BaseEnjoyment += (-1*((BestRelation - 4) + PapyrusUtil.ClampInt(((Skills[Stats.kLewd]-Skills[Stats.kPure])-(OwnSkills[Stats.kLewd]-OwnSkills[Stats.kPure])) as int,-6,6))) * Utility.RandomInt(1, 10)
				else
					BaseEnjoyment += (BestRelation + PapyrusUtil.ClampInt((((Skills[Stats.kLewd]+OwnSkills[Stats.kLewd])*0.5)-((Skills[Stats.kPure]+OwnSkills[Stats.kPure])*0.5)) as int,0,6)) * Utility.RandomInt(1, 10)
				endIf
			endIf
		else
			if IsVictim
				BestRelation = Thread.GetLowestPresentRelationshipRank(ActorRef)
				BaseEnjoyment += (BestRelation - 3) * Utility.RandomInt(1, 10)
			else
				BestRelation = Thread.GetHighestPresentRelationshipRank(ActorRef)
				if IsAggressor
					BaseEnjoyment += (-1*(BestRelation - 4)) * Utility.RandomInt(1, 10)
				else
					BaseEnjoyment += (BestRelation + 3) * Utility.RandomInt(1, 10)
				endIf
			endIf
		endIf
		LogInfo += "BaseEnjoyment["+BaseEnjoyment+"]"
		Log(LogInfo)
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
					ActorRef.SetFactionRank(AnimatingFaction, 2)
					ActorRef.EvaluatePackage()
				endIf
				ActorRef.SetLookAt(WaitRef, false)
				if IsPlayer
					Thread.RemoveFade()
				endIf
				
				; Start wait loop for actor pathing.
				int StuckCheck  = 0
				float Failsafe  = Utility.GetCurrentRealTime() + 30.0
				while Distance > 100.0 && Utility.GetCurrentRealTime() < Failsafe
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
					ActorRef.SetFactionRank(AnimatingFaction, 1)
					ActorRef.EvaluatePackage()
				endIf
			endIf
		endIf
	endFunction

endState

bool Prepared ; TODO: Find better Solution
bool StartedUp ; TODO: Find better Solution
state Prepare
	event OnUpdate()
		; Check if still among the living and able.
		if !ActorRef || ActorRef == none || ActorRef.IsDisabled() || (ActorRef.IsDead() && ActorRef.GetActorValue("Health") < 1.0)
			Log("Actor is undefined, disabled, or has no health - Unable to continue animating")
			Thread.EndAnimation(true)
		else
			ClearEffects()
			if IsPlayer
				Thread.ApplyFade()
			endIf
			Offsets = new float[4]
			GetPositionInfo()
			; Starting position
			OffsetCoords(Loc, Center, Offsets)
			MarkerRef.SetPosition(Loc[0], Loc[1], Loc[2])
			MarkerRef.SetAngle(Loc[3], Loc[4], Loc[5])
			ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
			ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
			AttachMarker()

			kPrepareActor = true
			StartAnimating()
		endIf
	endEvent

	function StartAnimating()
		Log("StartAnimating")
		TrackedEvent("Start")
		; Remove from bard audience if in one
		Config.CheckBardAudience(ActorRef, true)
		; Prepare for loop
		StopAnimating(true)
		StartedAt  = Utility.GetCurrentRealTime()
		LastOrgasm = StartedAt
		GoToState("Animating")
		SyncAll(true)		
		; PlayingSA = Animation.Registry
		if ActorRef.GetActorValue("Paralysis") != 0.0
			Debug.SendAnimationEvent(ActorRef, "Ragdoll")
			Utility.Wait(0.1)
			SendDefaultAnimEvent()
			ActorRef.SetActorValue("Paralysis", 0.0)
			Utility.WaitMenuMode(0.2)
		endIf
		SendDefaultAnimEvent()
		; If enabled, start Auto TFC for player
		if IsPlayer && Config.AutoTFC
			MiscUtil.SetFreeCameraState(true)
			MiscUtil.SetFreeCameraSpeed(Config.AutoSUCSM)
		endIf

		kStartup = true
	endFunction
	
	event ResetActor()
		Log("ResetActor")
		ClearEvents()
		GoToState("Resetting")		
		; Clear TFC
		if IsPlayer
			Thread.ApplyFade()
			MiscUtil.SetFreeCameraState(false)
		endIf
		StopAnimating(true)
		UnlockActor()
		RestoreActorDefaults()
		; Tracked events
		TrackedEvent("End")
		; Unstrip items in storage, if any
		if !IsCreature && !ActorRef.IsDead()
			Unstrip()
			; Add back high heel effects
			if Config.RemoveHeelEffect
				; HDT High Heel
				if HDTHeelSpell && ActorRef.GetWornForm(0x00000080) && !ActorRef.HasSpell(HDTHeelSpell)
					ActorRef.AddSpell(HDTHeelSpell)
				endIf
				; NiOverride High Heels move out to prevent isues and add NiOverride Scale for race menu compatibility
			endIf
			if Config.HasNiOverride
				bool UpdateNiOPosition = NiOverride.RemoveNodeTransformPosition(ActorRef, false, isRealFemale, "NPC", "SexLab.esm")
				bool UpdateNiOScale = NiOverride.RemoveNodeTransformScale(ActorRef, false, isRealFemale, "NPC", "SexLab.esm")
				if UpdateNiOPosition || UpdateNiOScale ; I make the variables because not sure if execute both funtion in OR condition.
					NiOverride.UpdateNodeTransform(ActorRef, false, isRealFemale, "NPC")
				endIf
			endIf
		endIf
		; Free alias slot
		TryToClear()
		GoToState("")
		kResetActor = true
	endEvent
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

function PrepareAnimation()
endFunction

function StartAnimation()
	log("si bal here???")
endFunction

function onUpdateVolume(float volume)
endFunction

function onMenuModeEnter()
endFunction 

function onMenuModeExit()
endFunction 

function playSfxSound(float onUpdateStartTime, String blockType)
endFunction

function playSfxMoan(float onUpdateStartTime)	
endFunction

function playSfxExpression(float onUpdateStartTime)
endFunction

function GetPositionInfo()
	if ActorRef
		if AdjustKey != Thread.AdjustKey
			SetAdjustKey(Thread.AdjustKey)
		endIf
		LeadIn     = Thread.LeadIn
		Stage      = Thread.Stage
		Animation  = Thread.Animation
		StageCount = Animation.StageCount
		if Stage > StageCount
			return
		endIf
	;	Log("Animation:"+Animation.Name+" AdjustKey:"+AdjustKey+" Position:"+Position+" Stage:"+Stage)
		Flags      = Animation.PositionFlags(Flags, AdjustKey, Position, Stage)
		Offsets    = Animation.PositionOffsets(Offsets, AdjustKey, Position, Stage, BedStatus[1])
		; CurrentSA  = Animation.Registry
		; AnimEvents[Position] = Animation.FetchPositionStage(Position, Stage)
	endIf
endFunction

; string PlayingSA
; string CurrentSA
; string PlayingAE
; string CurrentAE
float LoopDelay
float LoopExpressionDelay

float aniPlayTime
float aniExpectPlayTime
float aniStartTime
string backupSfxPlayStatus

state Animating

	function onMenuModeEnter()
		backupSfxPlayStatus = sfxPlayStatus
		sfxPlayStatus = "ready"
		sfxSoundInit()
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

	function PrepareAnimation ()
		Log("PrepareAnimation!!!")
		UnregisterForUpdate()
		sfxPlayStatus = "ready"		
	
		float startAnimationTime =  Utility.GetCurrentRealTime()
		
		sfxSoundInit()
		GetPositionInfo()
		
		if Thread.Stage == 1
			isStripped = false
			kPrepareActor = false
			kResetActor   = false
			kRefreshActor = false
			kSyncActor    = false
			KAnimateReady = 0

			isOrgasming = false
			LoadShares()
			StartedAt = Utility.GetCurrentRealTime()

			;팩션 랭크 업데이트
			; ActorRef.SetFactionRank(Thread.SfxPositionFaction, position)
			; ActorRef.SetFactionRank(Thread.SfxPlayRoleFaction, Thread.SfxPlayRoleType)
			; ActorRef.SetFactionRank(Thread.SfxPlayTypeFaction, Thread.SfxPlayType)
			
			; 보이스는 속성에 따라 보이스 정보 요청
			if !Voice && !IsForcedSilent && position == 0
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
		
		; 거리에 따른 대화 내용 출력
		; if actorVolume >= 0.2	
		; 	;팩션 랭크 업데이트
		; 	if Thread.Stage == Animation.StageCount
		; 		ActorRef.SetFactionRank(Thread.SfxStageFaction, 99)	
		; 	else 
		; 		ActorRef.SetFactionRank(Thread.SfxStageFaction, Thread.Stage)
		; 	endif
		; 	SayDialog()
		; endif

		; SFX 사운드 동기화 정보 요청
		
		sfxAction = animation.PositionAction(sfxAction,  Position, Thread.Stage)		
		sfxVoice = Animation.PositionSfxVoice(sfxVoice, Position, Thread.Stage)
		sfxSound = Animation.PositionSfxSound(sfxSound, Position, Thread.Stage)	
		sfxExpression = Animation.PositionSfxExpression(sfxExpression, Position, Thread.Stage)
		sfxExpressionStrength = Animation.PositionsfxExpressionLevel(sfxExpressionStrength, Position, Thread.Stage)

		; 액션 처리
		string [] actions = PapyrusUtil.StringSplit(sfxAction, ",")
		int idx=0
		while idx < actions.length
			if actions[idx] == "undress"
				if isStripped == false
					Strip()
					ResolveStrapon()
					isStripped = true
				endif
			endif
			
			idx += 1
		endWhile	

		; 입모양 강약 처리
		if sfxExpressionStrength != ""
		   sfxExpressionStrengthBlocks = PapyrusUtil.StringSplit(sfxExpressionStrength, ",")
		   sfxExpressionStrengthIdx = 0
		endif

		; 사운드 타입 처리
		if sfxSound != ""
		   sfxSoundBlocks = PapyrusUtil.StringSplit(sfxSound, ",")
		   sfxSoundBlockIdx = 0
		endif
				
		sfxMoanOffset = startAnimationTime - 11
		sfxExpressionStrengthOffset = startAnimationTime - 4
		
		KAnimateReady = Thread.Stage

		if position == 0
			Debug.Notification("### Animation " + animation.name + ", Stage " + Thread.Stage + ", expression " + sfxExpression + ", actions " + sfxAction)
			log("### Animation " + animation.name + ", Stage " + Thread.Stage + ", expression " + sfxExpression + ", actions " + actions.length)
		endif		
	endFunction

	function StartAnimation()
		if !ActorRef.Is3DLoaded() || ActorRef.IsDisabled() || ActorRef.IsDead()
			Thread.EndAnimation(true)
			return
		endIf

		Log("StartAnimation!!!")

		aniPlayTime = 0
		aniExpectPlayTime = 0

		sfxPlayStatus = "start"
		RegisterForSingleUpdate(0.1)
	endFunction

	event OnUpdate()
		float onUpdateStartTime =  Utility.GetCurrentRealTime()
		float delayTime = 0.0
		bool  shouldSkip = false

		if sfxPlayStatus == "play"
			aniPlayTime = onUpdateStartTime - aniStartTime
			delayTime = aniExpectPlayTime - aniPlayTime

			if delayTime < -1.0
				shouldSkip = true
			endif
			
		elseif sfxPlayStatus == "start"			
			log("play animation " + position)
			aniStartTime = onUpdateStartTime
			Debug.SendAnimationEvent(ActorRef, Animation.FetchPositionStage(Position, Thread.Stage))

			sfxPlayStatus = "play"
		elseif sfxPlayStatus == "ready"
			return
		endif
		
		float updateTime = 0.0
		float opTime = 0.0
		float idleTime  = 0.0

		; animation
		; if shouldAnimation
		; 	log("play animation " + position)
		; 	Debug.SendAnimationEvent(ActorRef, Animation.FetchPositionStage(Position, Thread.Stage))
		; 	aniStartTime = onUpdateStartTime
		; endif
				
		; Sfx 플레이
		if shouldSkip != true		
			if sfxSound != ""

				if sfxSoundBlockIdx >= sfxSoundBlocks.length
					sfxSoundBlockIdx = 0
				endif

				; sfx type 분석
				String[] blocks = PapyrusUtil.StringSplit(sfxSoundBlocks[sfxSoundBlockIdx], ":")
				sfxSoundBlockIdx += 1		

				if blocks.length > 0
				String blockType = blocks[0]

				; sfx sound 에 대해 미리 플레이시간:대기시간 분석
				String[] timeBlocks = PapyrusUtil.StringSplit(blocks[1], "|")
				if timeBlocks.length > 1
					idleTime = timeBlocks[0] as float + (timeBlocks[1] as float - 0.075) ; 0.075 millisecond 빨리감기
					; Log("time[0]:" + timeBlocks[0] as float + ", time[1]: " + timeBlocks[1] as float)
					
					aniExpectPlayTime += idleTime
					Utility.Wait(timeBlocks[0] as float + delayTime)  ; sound play 전 대기 시간 처리
					endif 

					; Log("bt:" + blockType + ", pt: " + aniPlayTime + ", et: " + aniExpectPlayTime + ", dt: " + delayTime + ", it: " + idleTime)			
					playSfxSound(onUpdateStartTime, blockType)
				endif
			endif
		else 
			updateTime = VoiceDelay * 0.35
		endif

		; 목소리 플레이
		playSfxMoan(onUpdateStartTime)
			
		; 표정(입모양) 플레이		
		playSfxExpression(onUpdateStartTime)			
				
		; check delay time
		opTime = Utility.GetCurrentRealTime() - onUpdateStartTime
		if idleTime >= opTime
			updateTime = idleTime - opTime
		endif

		updateTime += delayTime	

		if sfxPlayStatus != "ready"
			RegisterForSingleUpdate(updateTime)
		endif
	endEvent

	function playSfxExpression(float onUpdateStartTime)
		; play sfxVoice
		if sfxExpression != "" && ((onUpdateStartTime - sfxExpressionStrengthOffset) > 3)
				;				  		    7 - Mood Neutral
				; 0 - Dialogue Anger		8 - Mood Anger		15 - Combat Anger
				; 1 - Dialogue Fear			9 - Mood Fear		16 - Combat Shout
				; 2 - Dialogue Happy		10 - Mood Happy
				; 3 - Dialogue Sad			11 - Mood Sad
				; 4 - Dialogue Surprise		12 - Mood Surprise
				; 5 - Dialogue Puzzled		13 - Mood Puzzled
				; 6 - Dialogue Disgusted	14 - Mood Disgusted
				; aiStrength is from 0 to 100 (percent)

			; 표정
			int expressionIdx = 7
			if sfxExpression == "Anger"
				expressionIdx = 8
			elseif sfxExpression == "Fear"
				expressionIdx = 9
			elseif sfxExpression == "Happy"
				expressionIdx = 10	
			elseif sfxExpression == "Sad"
				expressionIdx = 11
			elseif sfxExpression == "Surprise"
				expressionIdx = 12
			elseif sfxExpression == "Puzzled"
				expressionIdx = 13
			elseif sfxExpression == "Disgusted"
				expressionIdx = 14
			elseif sfxExpression == "Shout"
				expressionIdx = 16
			endif

			; 강약
			if sfxExpressionStrengthIdx >= sfxExpressionStrengthBlocks.length
				sfxExpressionStrengthIdx = 0
			endif

			int strength = sfxExpressionStrengthBlocks[sfxExpressionStrengthIdx] as int

			actorRef.SetExpressionOverride(expressionIdx, strength)

			; 입 작게 열림
			if !OpenMouth
				sslBaseExpression.OpenMouthWithSize(ActorRef, 10)	
			endif

			log("sfxExpression " + sfxExpression + ", strength " + strength)

			sfxExpressionStrengthOffset = onUpdateStartTime	
			sfxExpressionStrengthIdx += 1		
		endif
	endfunction

	function playSfxSound(float onUpdateStartTime, String blockType)

		; 콘솔창같은 환경으로 인해, 시간 지연이 발생하는 경우, sfx 미출력										
		Sound.StopInstance(sfxSoundId)
		; play sfx sound
		if actorVolume > 0.0 
			bool squeakyPlay = false			
			if blockType == "fuck"			; fuck
				sfxSoundId = Thread.SfxFuckSound.Play(actorRef)
				squeakyPlay = true
			elseif blockType == "pusy"		; pussy
				sfxSoundId = Thread.SfxPussySound.Play(actorRef)
				squeakyPlay = true
			elseif blockType == "squs"		; Squishing
				sfxSoundId = Thread.sfxSquishing.Play(actorRef)
				squeakyPlay = true
			else
				if OpenMouth
					if blockType == "lick"
						sfxSoundId = voice.getLickSound().Play(actorRef)
					elseif blockType == "suks"		; mouth
						sfxSoundId = voice.getSuckSlowSound().Play(actorRef)
					elseif blockType == "sukf"		; mouth
						sfxSoundId = voice.getSuckFastSound().Play(actorRef)							
					elseif blockType == "deep"		; deep mouth
						sfxSoundId = voice.getDeepSound().Play(actorRef)
					endif
				endif
			endif

			if Thread.hasFurnitureRole && squeakyPlay
				Sound.SetInstanceVolume(Thread.SfxBedSound.Play(actorRef), actorVolume)
			endif
												
			if sfxSoundId != 0
				Sound.SetInstanceVolume(sfxSoundId, actorVolume)				
			endif
		endif
	endfunction

	function playSfxMoan(float onUpdateStartTime)	
		
		; play sfxVoice
		if sfxVoice != "" && actorVolume > 0
				if !IsSilent && (onUpdateStartTime - sfxMoanOffset) > 10
					Sound.StopInstance(sfxVoiceId)
					if sfxVoice == "hor1"	; horror
						sfxVoiceId = Voice.GetHorror1Sound().Play(actorRef)
					elseif sfxVoice == "hor2"	; horror
						sfxVoiceId = Voice.GetHorror2Sound().Play(actorRef)
					elseif sfxVoice == "hor3"	; horror
						sfxVoiceId = Voice.GetHorror3Sound().Play(actorRef)
					elseif sfxVoice == "pan1"	; pain
						sfxVoiceId = Voice.GetPain1Sound().Play(actorRef)
					elseif sfxVoice == "pan2"	; pain
						sfxVoiceId = Voice.GetPain2Sound().Play(actorRef)
					elseif sfxVoice == "pan3"	; pain
						sfxVoiceId = Voice.GetPain3Sound().Play(actorRef)
					elseif sfxVoice == "ejy1"	; enjoy
						sfxVoiceId = Voice.GetEnjoy1Sound().Play(actorRef)
					elseif sfxVoice == "ejy2"	; enjoy
						sfxVoiceId = Voice.GetEnjoy2Sound().Play(actorRef)
					elseif sfxVoice == "ejy3"	; enjoy
						sfxVoiceId = Voice.GetEnjoy3Sound().Play(actorRef)
					elseif sfxVoice == "hpy1"	; happy
						sfxVoiceId = Voice.GetHappy1Sound().Play(actorRef)
					elseif sfxVoice == "hpy2"	; happy
						sfxVoiceId = Voice.GetHappy2Sound().Play(actorRef)
					elseif sfxVoice == "hpy3"	; happy
						sfxVoiceId = Voice.GetHappy3Sound().Play(actorRef)
					elseif sfxVoice == "lick"
						sfxVoiceId = voice.getLickSound().Play(actorRef)
					elseif sfxVoice == "suks"		; mouth
						sfxVoiceId = voice.getSuckSlowSound().Play(actorRef)
					elseif sfxVoice == "sukf"		; mouth
						sfxVoiceId = voice.getSuckFastSound().Play(actorRef)									
					elseif sfxVoice == "deep"		; deep mouth
						sfxVoiceId = voice.getDeepSound().Play(actorRef)
					elseif sfxVoice == "feel"	; feel
						sfxVoiceId = Voice.GetFeelSound().Play(actorRef)
					elseif sfxVoice == "kiss"
						sfxVoiceId = Voice.GetKissSound().Play(actorRef)	
					elseif sfxVoice == "moan"	; moan
						sfxVoiceId = Voice.GetMoanSound().Play(actorRef)
					elseif sfxVoice == "agsv"	; aggressive
						sfxVoiceId = Voice.GetAggressiveSound().Play(actorRef)
					endif

					if sfxVoiceId != 0
						log("playSfxVoice " + sfxVoice + ", actorVolume: " + actorVolume + ", sfxVoiceId: " + sfxVoiceId)
						Sound.SetInstanceVolume(sfxVoiceId, actorVolume)
						sfxMoanOffset = onUpdateStartTime		
					endif			
				endif
		else 
			if !OpenMouth && !IsSilent && ((onUpdateStartTime - sfxMoanOffset) > Utility.RandomInt(3, 5)) && !isOrgasming
				Sound.StopInstance(moanSoundId)
				sfxMoanOffset = onUpdateStartTime
				; 	TransitDown(50, 20)
				moanSoundId = Voice.PlayMoan(ActorRef, GetEnjoyment(), isVictim, UseLipSync, actorVolume)
			endif
		endif 
	endfunction

	function SyncThread()
		; Sync with thread info
		GetPositionInfo()
		VoiceDelay = BaseDelay
		ExpressionDelay = Config.ExpressionDelay * BaseDelay
		if !IsSilent && Stage > 1
			VoiceDelay -= (Stage * 0.8) + Utility.RandomFloat(-0.2, 0.4)
		endIf
		if VoiceDelay < 0.8
			VoiceDelay = Utility.RandomFloat(0.8, 1.4) ; Can't have delay shorter than animation update loop
		endIf
		
		; Sync status
		if !IsCreature
			ResolveStrapon()

			if sfxExpression == ""
				RefreshExpression()
			endif			
		endIf
		; 물건 크기 설정
		if isMale 	
			Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
			Utility.Wait(0.1)
			Debug.SendAnimationEvent(ActorRef, "SOSBend" + Schlong)
		endif
	endFunction

	function SyncActor()
		SyncThread()
		SyncLocation(false)

		kSyncActor = true
	endFunction

	function SyncAll(bool Force = false)
		SyncThread()
		SyncLocation(Force)
	endFunction

	function RefreshActor()
		log("refreshActor")
		UnregisterForUpdate()
		SyncThread()
		StopAnimating(true)
		SyncLocation(false)
		; CurrentSA = "SexLabSequenceExit1"
		; CurrentAE = PlayingSA
		Debug.SendAnimationEvent(ActorRef, "SexLabSequenceExit1")
		Utility.WaitMenuMode(0.2)
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")

		; CurrentSA = Animation.Registry
		; CurrentAE = Animation.FetchPositionStage(Position, 1)
		; Debug.SendAnimationEvent(ActorRef, CurrentAE)
		; PlayingSA = CurrentSA
		; PlayingAE = CurrentAE

		SyncLocation(true)
		StartAnimation()
		kRefreshActor = true	
		RegisterForSingleUpdate(1.0)
	endFunction

	function RefreshLoc()
		Offsets = Animation.PositionOffsets(Offsets, AdjustKey, Position, Stage, BedStatus[1])
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
		if !(ActorRef && ActorRef.Is3DLoaded())
			return
		endIf
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
		; Log("OnTranslationComplete")
		Snap()
	endEvent

	;/ event OnTranslationFailed()
		Log("OnTranslationFailed")
		; SyncLocation(false)
	endEvent /;

	function OrgasmEffect()
		DoOrgasm()
	endFunction

	function DoOrgasm(bool Forced = false)
		if !ActorRef
			return
		endIf
		int Enjoyment = GetEnjoyment()
		if !Forced && (NoOrgasm || Thread.DisableOrgasms)
			; Orgasm Disabled for actor or whole thread
			return 
		elseIf !Forced && Config.SeparateOrgasms && Enjoyment < 100 && (Enjoyment < 1 || Stage < StageCount || Orgasms > 0)
			; Someone need to do better job to make you happy
			return
		elseIf Math.Abs(Utility.GetCurrentRealTime() - LastOrgasm) < 5.0
			Log("Excessive OrgasmEffect Triggered")
			return
		endIf
		bool CanOrgasm = Forced || (Animation.HasTag("Lesbian") && Thread.ActorCount == Thread.Females && !Stats.IsStraight(ActorRef)) ; Lesbians have special treatment because the Lesbian Animations usually don't have CumId assigned.
		int i = Thread.ActorCount
		while !CanOrgasm && i > 0
			i -= 1
			CanOrgasm = Animation.GetCumID(i, Stage) > 0 || Animation.GetCum(i) > 0
		endWhile
		if !CanOrgasm
			; Orgasm Disabled for the animation
			return
		endIf
		if !Forced && Config.SeparateOrgasms
			bool IsCumSource = False
			i = Thread.ActorCount
			while !IsCumSource && i > 0
				i -= 1
				IsCumSource = Animation.GetCumSource(i, Stage) == Position
			endWhile
			if !IsCumSource
				if IsMale && !(Animation.HasTag("Anal") || Animation.HasTag("Vaginal") || Animation.HasTag("Handjob") || Animation.HasTag("Blowjob") || Animation.HasTag("Boobjob") || Animation.HasTag("Footjob") || Animation.HasTag("Penis"))
					return
				elseIf IsFemale && !(Animation.HasTag("Anal") || Animation.HasTag("Vaginal") || Animation.HasTag("Pussy") || Animation.HasTag("Cunnilingus") || Animation.HasTag("Fisting") || Animation.HasTag("Breast"))
					return
				endIf
			endIf
		endIf
		UnregisterForUpdate()
		LastOrgasm = StartedAt
		Orgasms   += 1
		; Send an orgasm event hook with actor and orgasm count
		int eid = ModEvent.Create("SexLabOrgasm")
		ModEvent.PushForm(eid, ActorRef)
		ModEvent.PushInt(eid, FullEnjoyment)
		ModEvent.PushInt(eid, Orgasms)
		ModEvent.Send(eid)
		TrackedEvent("Orgasm")
		Log(ActorName + ": Orgasms["+Orgasms+"] FullEnjoyment ["+FullEnjoyment+"] BaseEnjoyment["+BaseEnjoyment+"] Enjoyment["+Enjoyment+"]")
		if Config.OrgasmEffects
			; Shake camera for player
			if IsPlayer && Config.ShakeStrength > 0 && Game.GetCameraState() >= 8
				Game.ShakeCamera(none, Config.ShakeStrength, Config.ShakeStrength + 1.0)
			endIf
			; Play SFX/Voice
			if !IsSilent
				PlayLouder(Voice.GetSound(100, false), ActorRef, Config.VoiceVolume)
			endIf
			PlayLouder(OrgasmFX, ActorRef, Config.SFXVolume)
		endIf
		; Apply cum to female positions from male position orgasm
		i = Thread.ActorCount
		if i > 1 && Config.UseCum && (MalePosition || IsCreature) && (IsMale || IsCreature || (Config.AllowFFCum && IsFemale))
			if i == 2
				Thread.PositionAlias(IntIfElse(Position == 1, 0, 1)).ApplyCum()
			else
				while i > 0
					i -= 1
					if Position != i && Position < Animation.PositionCount && Animation.IsCumSource(Position, i, Stage)
						Thread.PositionAlias(i).ApplyCum()
					endIf
				endWhile
			endIf
		endIf
		Utility.WaitMenuMode(0.2)
		; Reset enjoyment build up, if using multiple orgasms
		QuitEnjoyment += Enjoyment
		if IsSkilled
			if IsVictim
				BaseEnjoyment += ((BestRelation - 3) + PapyrusUtil.ClampInt((OwnSkills[Stats.kLewd]-OwnSkills[Stats.kPure]) as int,-6,6)) * Utility.RandomInt(5, 10)
			else
				if IsAggressor
					BaseEnjoyment += (-1*((BestRelation - 4) + PapyrusUtil.ClampInt(((Skills[Stats.kLewd]-Skills[Stats.kPure])-(OwnSkills[Stats.kLewd]-OwnSkills[Stats.kPure])) as int,-6,6))) * Utility.RandomInt(5, 10)
				else
					BaseEnjoyment += (BestRelation + PapyrusUtil.ClampInt((((Skills[Stats.kLewd]+OwnSkills[Stats.kLewd])*0.5)-((Skills[Stats.kPure]+OwnSkills[Stats.kPure])*0.5)) as int,0,6)) * Utility.RandomInt(5, 10)
				endIf
			endIf
		else
			if IsVictim
				BaseEnjoyment += (BestRelation - 3) * Utility.RandomInt(5, 10)
			else
				if IsAggressor
					BaseEnjoyment += (-1*(BestRelation - 4)) * Utility.RandomInt(5, 10)
				else
					BaseEnjoyment += (BestRelation + 3) * Utility.RandomInt(5, 10)
				endIf
			endIf
		endIf

		if (!Thread.DisableOrgasms && !NoOrgasm) 			
			string sfxOrgasmType = animation.PositionOrgasmType(sfxOrgasmType,  Position, Thread.Stage)
			if sfxOrgasmType != ""
				doOrgasmScene(sfxOrgasmType)
			endif
		endif
		
		RegisterForSingleUpdate(0.8)
	endFunction

	event ResetActor()
		Log("ResetActor!")

		ClearEvents()
		GoToState("Resetting")

		; Clear TFC
		if IsPlayer
			Thread.ApplyFade()
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
			if IsType[6]
				Stats.AdjustSkill(ActorRef, "VaginalCount", 1)
			endIf
			if IsType[7]
				Stats.AdjustSkill(ActorRef, "AnalCount", 1)
			endIf
			if IsType[8]
				Stats.AdjustSkill(ActorRef, "OralCount", 1)
			endIf
		endIf
		; Apply cum
		;/ int CumID = Animation.GetCum(Position)
		if CumID > 0 && !Thread.FastEnd && Config.UseCum && (Thread.Males > 0 || Config.AllowFFCum || Thread.HasCreature)
			ActorLib.ApplyCum(ActorRef, CumID)
		endIf /;
		; Make sure of play the last animation stage to prevet AnimObject issues
		; CurrentAE = Animation.FetchPositionStage(Position, StageCount)
		; if PlayingAE != CurrentAE
		; 	Debug.SendAnimationEvent(ActorRef, CurrentAE)
		; 	PlayingAE = CurrentAE
		; endIf
		StopAnimating(Thread.FastEnd, EndAnimEvent)

		UnlockActor()
		RestoreActorDefaults()

		sfxSoundInit()
		; Tracked events
		TrackedEvent("End")
		; Unstrip items in storage, if any
		if !IsCreature && !ActorRef.IsDead()
			Unstrip()
			; Add back high heel effects
			if Config.RemoveHeelEffect
				; HDT High Heel
				if HDTHeelSpell && ActorRef.GetWornForm(0x00000080) && !ActorRef.HasSpell(HDTHeelSpell)
					ActorRef.AddSpell(HDTHeelSpell)
				endIf
				; NiOverride High Heels move out to prevent isues and add NiOverride Scale for race menu compatibility
			endIf
			if Config.HasNiOverride
				bool UpdateNiOPosition = NiOverride.RemoveNodeTransformPosition(ActorRef, false, isRealFemale, "NPC", "SexLab.esm")
				bool UpdateNiOScale = NiOverride.RemoveNodeTransformScale(ActorRef, false, isRealFemale, "NPC", "SexLab.esm")
				if UpdateNiOPosition || UpdateNiOScale ; I make the variables because not sure if execute both funtion in OR condition.
					NiOverride.UpdateNodeTransform(ActorRef, false, isRealFemale, "NPC")
				endIf
			endIf
		endIf

		; Free alias slot
		TryToClear()
		GoToState("")
		kResetActor = true
	endEvent
endState

function sfxSoundInit ()
	Sound.StopInstance(sfxSoundId)
	Sound.StopInstance(moanSoundId)
	Sound.StopInstance(sfxVoiceId)

	sfxSoundId = 0
	sfxVoiceId = 0
	moanSoundId = 0
endFunction

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
; 표정 선택

sslBaseExpression function GetExpressionByTag(string Tag, bool ForFemale = true)

	int i = 8	; expression slot 갯수 총 8개
	while i
		bool isFound = false
		i -= 1

		sslBaseExpression Slot = Config.ExpressionSlots.expressions[i] as sslBaseExpression		
		isFound = Slot.HasTag(Tag) != -1  && ((ForFemale && Slot.PhasesFemale > 0) || (!ForFemale && Slot.PhasesMale > 0))

		if isFound == true
			return Slot
		endif
	endWhile	
	return none
endFunction


; 종료 액션
function doOrgasmScene (String type)

	log("doOrgasmScene")
	; 애니메이션 종료 후 추가 액션 처리
	if Config.OrgasmEffects
		bool isEndPlay = false

		if position == 0
			if IsFemale
				if IsVictim
					if type == "doggy"
						int _randomValue = Utility.RandomInt(1, 3)
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Victim_AfterFuck_Back_0" + _randomValue)
						Utility.wait(7.0)
						isEndPlay = true
					else
						Offsets[3] = 180			
						OffsetCoords(Loc, Center, Offsets)
						ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
						ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])				
				
						int _randomValue = Utility.RandomInt(1, 3)
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Victim_AfterFuck_Front_0" + _randomValue)
						Utility.wait(7.0)
						isEndPlay = true
					endif 
				else
					if type == "doggy"
						int _randomValue = Utility.RandomInt(1, 3)
						Debug.SendAnimationEvent(ActorRef, "Scene_F_Victim_AfterFuck_Back_0" + _randomValue)
						Utility.wait(7.0)
						isEndPlay = true
					else 					
						if type == "loving"
							Offsets[0] = 0
							OffsetCoords(Loc, Center, Offsets)
							ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
							ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		
							int _randomValue = Utility.RandomInt(1, 5)
							Debug.SendAnimationEvent(ActorRef, "Scene_F_Loving_AfterFuck_0" + _randomValue)
							Utility.wait(7.0)										
							isEndPlay = true
						else
							Offsets[0] = 0
							OffsetCoords(Loc, Center, Offsets)
							ActorRef.SetPosition(Loc[0], Loc[1], Loc[2])
							ActorRef.SetAngle(Loc[3], Loc[4], Loc[5])
		
							int _randomValue = Utility.RandomInt(1, 5)
							Debug.SendAnimationEvent(ActorRef, "Scene_F_Prostitute_AfterFuck_0" + _randomValue)
							Utility.wait(7.0)										
							isEndPlay = true
						endif
					endif
				endif 
			else 
				; male
				if IsVictim
				else 
				endif
			endif 
		endif 

		if isEndPlay 
			Debug.SendAnimationEvent(ActorRef, "Scene_F_Stand")
			Utility.wait(3.0)
			Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")	
		endif
	endif
endFunction

; ------------------------------------------------------- ;
; --- Actor Manipulation                              --- ;
; ------------------------------------------------------- ;

function StopAnimating(bool Quick = false, string ResetAnim = "IdleForceDefaultState")
	log("StopAnimating " + resetAnim)
	if !ActorRef
		Log(ActorName +"- WARNING: ActorRef if Missing or Invalid", "StopAnimating("+Quick+")")
		return
	endIf

	if !isPlayer
		ActorRef.SetUnconscious(false)
	endif

	; Disable free camera, if in it
	; if IsPlayer
	; 	MiscUtil.SetFreeCameraState(false)
	; endIf
	; Clear possibly troublesome effects
	ActorRef.StopTranslation()
	bool Resetting = GetState() == "Resetting" || !Quick
	if Resetting
		int StageOffset = Stage
		if StageOffset > StageCount
			StageOffset = StageCount
		endIf
		if AdjustKey && AdjustKey != ""
			Offsets    = Animation.PositionOffsets(Offsets, AdjustKey, Position, StageOffset, BedStatus[1])
		endIf
		float OffsetZ = 10.0
		if Offsets[2] < 1.0 ; Fix for animation default missaligned 
			Offsets[2] = OffsetZ ; hopefully prevents some users underground/teleport to giant camp problem?
		endIf
		OffsetCoords(Loc, Center, Offsets)
		float PositionX = ActorRef.GetPositionX()
		float PositionY = ActorRef.GetPositionY()
		float AngleZ = ActorRef.GetAngleZ()
		float Rotate = AngleZ
		String Node = "NPC Root [Root]"
		if !IsCreature
			Node = "MagicEffectsNode"
		endIf
		if NetImmerse.HasNode(ActorRef, Node, False)
			PositionX = NetImmerse.GetNodeWorldPositionX(ActorRef, Node, False)
			PositionY = NetImmerse.GetNodeWorldPositionY(ActorRef, Node, False)
			float[] Rotation = new float[3]
			if NetImmerse.GetNodeLocalRotationEuler(ActorRef, Node, Rotation, False)
				Rotate = AngleZ + Rotation[2]
				if Rotate >= 360.0
					Rotate = Rotate - 360.0
				elseIf Rotate < 0.0
					Rotate = Rotate + 360.0
				endIf
				Log(Node +" Rotation:"+Rotation+" AngleZ:"+AngleZ+" Rotate:"+Rotate)
			endIf
		endIf
		ActorRef.SetVehicle(none)
		if AngleZ != Rotate
			ActorRef.SetAngle(Loc[3], Loc[4], Rotate)
		endIf
		ActorRef.SetPosition(PositionX, PositionY, Loc[2])
	;	Utility.WaitMenuMode(0.1)
	else
		ActorRef.SetVehicle(none)
	endIf
	; Stop animevent
	if IsCreature
		; Reset creature idle
		SendDefaultAnimEvent(Resetting)
		Utility.Wait(0.1)
		if ResetAnim != "IdleForceDefaultState" && ResetAnim != "" && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			ActorRef.PushActorAway(ActorRef, 0.001)
		elseIf !Quick && ResetAnim == "IdleForceDefaultState" && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			if ActorRef.IsDead() || ActorRef.IsUnconscious()
				Debug.SendAnimationEvent(ActorRef, "DeathAnimation")
			elseIf ActorRef.GetActorValuePercentage("Health") < 0.1
				ActorRef.KillSilent()
			elseIf (ActorRaceKey == "Spiders" || ActorRaceKey == "LargeSpiders" || ActorRaceKey == "GiantSpiders")
				ActorRef.PushActorAway(ActorRef, 0.001) ; Temporal Fix TODO:
			endIf
		endIf
	else
		; Reset NPC/PC Idle Quickly
		if ResetAnim != "IdleForceDefaultState" && ResetAnim != ""
			Debug.SendAnimationEvent(ActorRef, ResetAnim)
			Utility.Wait(0.1)
			; Ragdoll NPC/PC if enabled and not in TFC
			if !Quick && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
				ActorRef.PushActorAway(ActorRef, 0.001)
			endIf
		elseIf Quick
			Debug.SendAnimationEvent(ActorRef, ResetAnim)
		elseIf !Quick && ResetAnim == "IdleForceDefaultState" && DoRagdoll && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3))
			;TODO: Detect the real actor position based on Node property intead of the Animation Tags
			if ActorRef.IsDead() || ActorRef.IsUnconscious()
				Debug.SendAnimationEvent(ActorRef, ResetAnim)
				Utility.Wait(0.1)
				Debug.SendAnimationEvent(ActorRef, "IdleSoupDeath")
			elseIf ActorRef.GetActorValuePercentage("Health") < 0.1
				ActorRef.KillSilent()
			elseIf Animation && (Animation.HasTag("Furniture") || (Animation.HasTag("Standing") && !IsType[0]))
				Debug.SendAnimationEvent(ActorRef, ResetAnim)
			elseIf IsType[0] && IsVictim && Animation && Animation.HasTag("Rape") && !Animation.HasTag("Standing") && (!IsPlayer || (IsPlayer && Game.GetCameraState() != 3)) \
			&& (Animation.HasTag("DoggyStyle") || Animation.HasTag("Missionary") || Animation.HasTag("Laying"))
				ActorRef.PushActorAway(ActorRef, 0.001)
			else
				Debug.SendAnimationEvent(ActorRef, ResetAnim)
			endIf
		else
			Debug.SendAnimationEvent(ActorRef, ResetAnim)
		endIf
	endIf
;	Log(ActorName +"- Angle:[X:"+ActorRef.GetAngleX()+"Y:"+ActorRef.GetAngleY()+"Z:"+ActorRef.GetAngleZ()+"] Position:[X:"+ActorRef.GetPositionX()+"Y:"+ActorRef.GetPositionY()+"Z:"+ActorRef.GetPositionZ()+"]", "StopAnimating("+Quick+")")
	; PlayingSA = "SexLabSequenceExit1"
	; PlayingAE = "SexLabSequenceExit1"
endFunction

function SendDefaultAnimEvent(bool Exit = False)
	Debug.SendAnimationEvent(ActorRef, "AnimObjectUnequip")
	if !IsCreature
		Debug.SendAnimationEvent(ActorRef, "IdleForceDefaultState")
	elseIf ActorRaceKey != ""
		if ActorRaceKey == "Dragons"
			Debug.SendAnimationEvent(ActorRef, "FlyStopDefault") ; for Dragons only
			Utility.Wait(0.1)
			Debug.SendAnimationEvent(ActorRef, "Reset") ; for Dragons only
		elseIf ActorRaceKey == "Hagravens"
			Debug.SendAnimationEvent(ActorRef, "ReturnToDefault") ; for Dragons only
			if Exit
				Utility.Wait(0.1)
				Debug.SendAnimationEvent(ActorRef, "Reset") ; for Dragons only
			endIf
		elseIf ActorRaceKey == "Chaurus" || ActorRaceKey == "ChaurusReapers"
			Debug.SendAnimationEvent(ActorRef, "FNISDefault") ; for dwarvenspider and chaurus without time bettwen.
			if Exit
		;		Utility.Wait(0.1)
		;		Debug.SendAnimationEvent(ActorRef, "ReturnToDefault")
			endIf
		elseIf ActorRaceKey == "DwarvenSpiders"
			Debug.SendAnimationEvent(ActorRef, "ReturnToDefault")
			if Exit
		;		Utility.Wait(0.1)
		;		Debug.SendAnimationEvent(ActorRef, "FNISDefault") ; for dwarvenspider and chaurus
			endIf
		elseIf ActorRaceKey == "Draugrs" || ActorRaceKey == "Seekers" || ActorRaceKey == "DwarvenBallistas" || ActorRaceKey == "DwarvenSpheres" || ActorRaceKey == "DwarvenCenturions"
			Debug.SendAnimationEvent(ActorRef, "ForceFurnExit") ; for draugr, trolls daedras and all dwarven exept spiders
		elseIf ActorRaceKey == "Trolls"
			Debug.SendAnimationEvent(ActorRef, "ReturnToDefault")
			if Exit
				Utility.Wait(0.1)
				Debug.SendAnimationEvent(ActorRef, "ForceFurnExit") ; the troll need this afther "ReturnToDefault" to allow the attack idles
			endIf
		elseIf ActorRaceKey == "Chickens" || ActorRaceKey == "Rabbits" || ActorRaceKey == "Slaughterfishes"
			Debug.SendAnimationEvent(ActorRef, "ReturnDefaultState") ; for chicken, hare and slaughterfish
			if Exit
				Utility.Wait(0.1)
				Debug.SendAnimationEvent(ActorRef, "ReturnToDefault")
			endIf
		elseIf ActorRaceKey == "Werewolves" || ActorRaceKey == "VampireLords"
			Debug.SendAnimationEvent(ActorRef, "IdleReturnToDefault") ; for Werewolves and VampirwLords
		else
			Debug.SendAnimationEvent(ActorRef, "ReturnToDefault") ; the rest creature-animal
		endIf
	elseIf Exit
		Debug.SendAnimationEvent(ActorRef, "ReturnDefaultState") ; for chicken, hare and slaughterfish before the "ReturnToDefault"
		Debug.SendAnimationEvent(ActorRef, "ReturnToDefault") ; the rest creature-animal
		Debug.SendAnimationEvent(ActorRef, "FNISDefault") ; for dwarvenspider and chaurus
		Debug.SendAnimationEvent(ActorRef, "IdleReturnToDefault") ; for Werewolves and VampirwLords
		Debug.SendAnimationEvent(ActorRef, "ForceFurnExit") ; for Trolls afther the "ReturnToDefault" and draugr, daedras and all dwarven exept spiders
		Debug.SendAnimationEvent(ActorRef, "Reset") ; for Hagravens afther the "ReturnToDefault" and Dragons
	endIf
	Utility.Wait(0.2)
endFunction

function AttachMarker()
	ActorRef.SetVehicle(MarkerRef)
	if UseScale && AnimScale > 0.1 && AnimScale != 1.0
		ActorRef.SetScale(AnimScale)
	endIf
endFunction

function LockActor()
	if !ActorRef
		Log(ActorName +"- WARNING: ActorRef if Missing or Invalid", "LockActor()")
		return
	endIf
	; Move if actor out of cell
	ObjectReference CenterRef = Thread.CenterAlias.GetReference()
	if CenterRef && CenterRef != none && CenterRef != ActorRef as ObjectReference && ActorRef.GetDistance(CenterRef) > 3000
		ActorRef.MoveTo(CenterRef)
	endIf
	; Remove any unwanted combat effects
	ClearEffects()
	; Stop whatever they are doing
	; SendDefaultAnimEvent()
	; Start DoNothing package
	ActorUtil.AddPackageOverride(ActorRef, Config.DoNothing, 100, 1)
	ActorRef.SetFactionRank(AnimatingFaction, 1)
	ActorRef.EvaluatePackage()
	; Disable movement
	ActorRef.StopTranslation()
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
		int cycle
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
		Log(ActorName +"- WARNING: ActorRef if Missing or Invalid", "UnlockActor()")
		return
	endIf
	; Detach positioning marker
	ActorRef.StopTranslation()
	ActorRef.SetVehicle(none)
	; Remove from animation faction
	ActorRef.RemoveFromFaction(AnimatingFaction)
	ActorUtil.RemovePackageOverride(ActorRef, Config.DoNothing)
	ActorRef.SetFactionRank(AnimatingFaction, 0)
	ActorRef.EvaluatePackage()
	; Enable movement
	if IsPlayer
		Thread.RemoveFade()
		Thread.DisableHotkeys()
		MiscUtil.SetFreeCameraState(false)
		Game.EnablePlayerControls(true, true, false, false, false, false, false, false, 0)
		Game.SetPlayerAIDriven(false)
	else
		ActorRef.SetRestrained(false)
		ActorRef.SetDontMove(false)
	endIf
;	Log(ActorName +"- Angle:[X:"+ActorRef.GetAngleX()+"Y:"+ActorRef.GetAngleY()+"Z:"+ActorRef.GetAngleZ()+"] Position:[X:"+ActorRef.GetPositionX()+"Y:"+ActorRef.GetPositionY()+"Z:"+ActorRef.GetPositionZ()+"]", "UnlockActor()")
endFunction

function RestoreActorDefaults()
	log("RestoreActorDefaults")

	; Make sure  have actor, can't afford to miss this block
	if !ActorRef
		ActorRef = GetReference() as Actor
		if !ActorRef
			Log(ActorName +"- WARNING: ActorRef if Missing or Invalid", "RestoreActorDefaults()")
			return ; No actor, reset prematurely or bad call to alias
		endIf
	endIf	
	; Reset to starting scale
	if UseScale && ActorScale > 0.0 && (ActorScale != 1.0 || AnimScale != 1.0)
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
		if ActorRef.Is3DLoaded() && !(ActorRef.IsDisabled() || ActorRef.IsDead() || ActorRef.GetActorValue("Health") < 1.0)
			if Expression
				sslBaseExpression.CloseMouth(ActorRef)
			elseIf sslBaseExpression.IsMouthOpen(ActorRef)
				sslBaseExpression.CloseMouth(ActorRef)			
			endIf
			ActorRef.ClearExpressionOverride()
			ActorRef.ResetExpressionOverrides()
			sslBaseExpression.ClearMFG(ActorRef)
		endIf
	endIf
	; Player specific actions
	if IsPlayer
		; Remove player from frostfall exposure exception
		FormList FrostExceptions = Config.FrostExceptions
		if FrostExceptions
			FrostExceptions.RemoveAddedForm(Config.BaseMarker)
		endIf
		Thread.RemoveFade()
	endIf

	; reset expression
	if Expression
		sslBaseExpression.CloseMouth(ActorRef)
	elseIf sslBaseExpression.IsMouthOpen(ActorRef)
		sslBaseExpression.CloseMouth(ActorRef)			
	endIf

	; Remove SOS erection
	Debug.SendAnimationEvent(ActorRef, "SOSFlaccid")
	; Clear from animating faction
	; ActorRef.SetFactionRank(AnimatingFaction, -1)
	; ActorRef.RemoveFromFaction(AnimatingFaction)
	ActorUtil.RemovePackageOverride(ActorRef, Config.DoNothing)
	ActorRef.EvaluatePackage()
;	Log(ActorName +"- Angle:[X:"+ActorRef.GetAngleX()+"Y:"+ActorRef.GetAngleY()+"Z:"+ActorRef.GetAngleZ()+"] Position:[X:"+ActorRef.GetPositionX()+"Y:"+ActorRef.GetPositionY()+"Z:"+ActorRef.GetPositionZ()+"]", "RestoreActorDefaults()")
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

bool function IsVictim()
	return IsVictim
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
		Log(ActorName +"- WARNING: ActorRef if Missing or Invalid", "GetEnjoyment()")
		FullEnjoyment = 0
		return 0
	elseif !IsSkilled
			FullEnjoyment = BaseEnjoyment + (PapyrusUtil.ClampFloat(((RealTime[0] - StartedAt) + 1.0) / 5.0, 0.0, 40.0) + ((Stage as float / StageCount as float) * 60.0)) as int
	else
		if Position == 0
			Thread.RecordSkills()
			Thread.SetBonuses()
		endIf
		FullEnjoyment = BaseEnjoyment + CalcEnjoyment(SkillBonus, Skills, LeadIn, IsFemale, (RealTime[0] - StartedAt), Stage, StageCount)
		; Log("FullEnjoyment["+FullEnjoyment+"] / BaseEnjoyment["+BaseEnjoyment+"] / Enjoyment["+(FullEnjoyment - BaseEnjoyment)+"]")
	endIf

	int Enjoyment = FullEnjoyment - QuitEnjoyment
	if Enjoyment > 0
		return Enjoyment
	endIf
	return 0
endFunction

int function GetPain()
	if !ActorRef
		Log(ActorName +"- WARNING: ActorRef if Missing or Invalid", "GetPain()")
		return 0
	endIf
	GetEnjoyment()
	if FullEnjoyment < 0
		return Math.Abs(FullEnjoyment) as int
	endIf
	return 0	
endFunction

int function CalcReaction()
	if !ActorRef
		Log(ActorName +"- WARNING: ActorRef if Missing or Invalid", "CalcReaction()")
		return 0
	endIf
	int Strength = GetEnjoyment()
	; Check if the actor is in pain or too excited to care about pain
	if FullEnjoyment < 0 && Strength < Math.Abs(FullEnjoyment)
		Strength = FullEnjoyment
	endIf
	return PapyrusUtil.ClampInt(Math.Abs(Strength) as int, 0, 100)
endFunction

function ApplyCum()
	if ActorRef && ActorRef.Is3DLoaded()
		Cell ParentCell = ActorRef.GetParentCell()
		int CumID = Animation.GetCumID(Position, Stage)
		if CumID > 0 && ParentCell && ParentCell.IsAttached() ; Error treatment for Spells out of Cell
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
	return GetEnjoyment() >= 100 && FullEnjoyment >= 100
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
	if Strapon && !HadStrapon && Strapon != ToStrapon
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
	int cumID = Animation.GetCumID(Position, Stage)
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
	if !ItemRef
		return False
	endIf
	if StorageUtil.FormListHas(none, "AlwaysStrip", ItemRef) || SexLabUtil.HasKeywordSub(ItemRef, "AlwaysStrip")
		if StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100) < 100
			if !DoStrip
				return (StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100) >= Utility.RandomInt(76, 100))
			endIf
			return (StorageUtil.GetIntValue(ItemRef, "SometimesStrip", 100) >= Utility.RandomInt(1, 100))
		endIf
		return True
	endIf
	return (DoStrip && !(StorageUtil.FormListHas(none, "NoStrip", ItemRef) || SexLabUtil.HasKeywordSub(ItemRef, "NoStrip")))
endFunction

function Strip()
	if !ActorRef || IsCreature
		return
	endIf
	; Start stripping animation
	;if DoUndress
	;	Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+BaseSex)
	;	NoUndress = true
	;endIf
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
	if ActorRef.IsWeaponDrawn() || IsPlayer
		ActorRef.SheatheWeapon()
	endIf
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
	Form BodyRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(32))
	int i = 31
	while i >= 0
		; Grab item in slot
		ItemRef = ActorRef.GetWornForm(Armor.GetMaskForSlot(i + 30))
		if ContinueStrip(ItemRef, Strip[i])
			; Start stripping animation
			if DoUndress && ItemRef == BodyRef ;Body
				Debug.SendAnimationEvent(ActorRef, "Arrok_Undress_G"+BaseSex)
				Utility.Wait(1.0)
				NoUndress = true
			endIf
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
	; Suppress NiOverride High Heels
	if Config.RemoveHeelEffect && ActorRef.GetWornForm(0x00000080)
		if Config.HasNiOverride
			; Remove NiOverride SexLab High Heels
			bool UpdateNiOPosition = NiOverride.RemoveNodeTransformPosition(ActorRef, false, isRealFemale, "NPC", "SexLab.esm")
			; Remove NiOverride High Heels
			if NiOverride.HasNodeTransformPosition(ActorRef, false, isRealFemale, "NPC", "internal")
				float[] pos = NiOverride.GetNodeTransformPosition(ActorRef, false, isRealFemale, "NPC", "internal")
				Log(pos, "RemoveHeelEffect (NiOverride)")
				pos[0] = -pos[0]
				pos[1] = -pos[1]
				pos[2] = -pos[2]
				NiOverride.AddNodeTransformPosition(ActorRef, false, isRealFemale, "NPC", "SexLab.esm", pos)
				NiOverride.UpdateNodeTransform(ActorRef, false, isRealFemale, "NPC")
			elseIf UpdateNiOPosition
				NiOverride.UpdateNodeTransform(ActorRef, false, isRealFemale, "NPC")
			endIf
		endIf
	endIf

	; 물건 크기 설정
	if isMale 	
		Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
		Utility.Wait(0.1)
		Debug.SendAnimationEvent(ActorRef, "SOSBend" + Schlong)
	endif
endFunction

function UnStrip()
 	if !ActorRef || IsCreature || Equipment.Length == 0
 		return
 	endIf
	; Remove nudesuit if present
	int n = ActorRef.GetItemCount(Config.NudeSuit)
	if n > 0
		ActorRef.RemoveItem(Config.NudeSuit, n, true)
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
		if NoUndress || GetState() == "Animating"
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

float RefreshExpressionDelay
function RefreshExpression()
	if !ActorRef || IsCreature || !ActorRef.Is3DLoaded() || ActorRef.IsDisabled()
		; Do nothing
	elseIf OpenMouth
		sslBaseExpression.OpenMouth(ActorRef)
		Utility.Wait(1.0)
		if Config.RefreshExpressions && Expression && Expression != none && !ActorRef.IsDead() && !ActorRef.IsUnconscious() && ActorRef.GetActorValue("Health") > 1.0
			int Strength = CalcReaction()
			Expression.Apply(ActorRef, Strength, BaseSex)
			Log("Expression.Applied("+Expression.Name+") Strength:"+Strength+"; OpenMouth:"+OpenMouth)
		endIf
	else
		if Expression && Expression != none && !ActorRef.IsDead() && !ActorRef.IsUnconscious() && ActorRef.GetActorValue("Health") > 1.0
			int Strength = CalcReaction()
			sslBaseExpression.CloseMouth(ActorRef)
			Expression.Apply(ActorRef, Strength, BaseSex)
			Log("Expression.Applied("+Expression.Name+") Strength:"+Strength+"; OpenMouth:"+OpenMouth)
		elseIf sslBaseExpression.IsMouthOpen(ActorRef)
			sslBaseExpression.CloseMouth(ActorRef)			
		endIf
	endIf
	RefreshExpressionDelay = 0.0
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

function ClearEvents()
	UnregisterForUpdate()
	string e = Thread.Key("")
	; Quick Events
	UnregisterForModEvent(e+"PrepareAnimate")
	UnregisterForModEvent(e+"Animate")
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
	if ActorRef && ActorRef != none
		; Stop events
		ClearEvents()
		; RestoreActorDefaults()
		; Remove nudesuit if present
		int n = ActorRef.GetItemCount(Config.NudeSuit)
		if n > 0
			ActorRef.RemoveItem(Config.NudeSuit, n, true)
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
	ActorVoice     = none
	IsForcedSilent = false
	; Expression
	Expression     = none
	Expressions    = sslUtility.ExpressionArray(0)
	; Flags
	NoRagdoll      = false
	NoUndress      = false
	NoRedress      = false
	NoOrgasm       = false
	ForceOpenMouth = false
	Prepared       = false
	StartedUp      = false
	; Integers
	Orgasms        = 0
	BestRelation   = 0
	BaseEnjoyment  = 0
	QuitEnjoyment  = 0
	FullEnjoyment  = 0
	PathingFlag    = 0
	; Floats
	LastOrgasm     = 0.0
	ActorScale     = 1.0
	AnimScale      = 1.0
	NioScale       = 1.0
	StartWait      = 0.1
	; Strings
	EndAnimEvent   = "IdleForceDefaultState"
	StartAnimEvent = ""
	ActorKey       = ""
	; PlayingSA      = ""
	; CurrentSA      = ""
	; PlayingAE      = ""
	; CurrentAE      = ""
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
	PlayerRef = Game.GetPlayer()
	Thread    = GetOwningQuest() as sslThreadController
	OrgasmFX  = Config.OrgasmFX
	DebugMode = Config.DebugMode
	AnimatingFaction = Config.AnimatingFaction
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
	if SFX && FromRef && FromRef.Is3DLoaded() && Volume > 0.0
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
function StartAnimating()
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
;/ function RefreshActor()
endFunction /;
event OnOrgasm()
	OrgasmEffect()
endEvent
event OrgasmStage()
	OrgasmEffect()
endEvent

function OffsetCoords(float[] Output, float[] CenterCoords, float[] OffsetBy) global native
bool function IsInPosition(Actor CheckActor, ObjectReference CheckMarker, float maxdistance = 30.0) global native
int function CalcEnjoyment(float[] XP, float[] SkillsAmounts, bool IsLeadin, bool IsFemaleActor, float Timer, int OnStage, int MaxStage) global native

int function IntIfElse(bool check, int isTrue, int isFalse)
	if check
		return isTrue
	endIf
	return isFalse
endfunction

; function AdjustCoords(float[] Output, float[] CenterCoords, ) global native
; function AdjustOffset(int i, float amount, bool backwards, bool adjustStage)
; 	Animation.
; endFunction

; function OffsetBed(float[] Output, float[] BedOffsets, float CenterRot) global native

; bool function _SetActor(Actor ProspectRef) native
; function _ApplyExpression(Actor ProspectRef, int[] Presets) global native


; function GetVars()
; 	IntShare = Thread.IntShare
; 	FloatShare = Thread.FloatS1hare
; 	StringShare = Thread.StringShare
; 	BoolShare
; endFunction

; int[] property IntShare auto hidden ; Stage, ActorCount, BedStatus[1]
; float[] property FloatShare auto hidden ; RealTime, StartedAt
; string[] property StringShare auto hidden ; AdjustKey
; bool[] property BoolShare auto hidden ; 
; sslBaseAnimation[] property _Animation auto hidden ; Animation
