scriptname AniHumanScene extends AniBase

bool property GenderedCreatures auto hidden

; Config
int Actors
int Stages

string[] Animations
string[] RaceTypes
string[] LastKeys
string LastKeyReg

int[]   Positions   ; = gender
float[] Timers
float[] CenterAdjust

; ------------------------------------------------------- ;
; --- Array Indexers                                  --- ;
; ------------------------------------------------------- ;
int function StageIndex(int Position, int Stage)
	return ((Position * Stages) + (PapyrusUtil.ClampInt(Stage, 1, Stages) - 1))
endFunction

int function AdjIndex(int Stage, int Slot = 0, int Slots = 4)
	return ((PapyrusUtil.ClampInt(Stage, 1, Stages) - 1) * Slots) + Slot
endfunction

int function OffsetIndex(int Stage, int Slot)
	return ((PapyrusUtil.ClampInt(Stage, 1, Stages) - 1) * 4) + Slot
endfunction

int function FlagIndex(int Stage, int Slot)
	return ((PapyrusUtil.ClampInt(Stage, 1, Stages) - 1) * 6) + Slot
endfunction

; ------------------------------------------------------- ;
; --- Animation Events                                --- ;
; ------------------------------------------------------- ;

string[] function FetchPosition(int Position)
	if Position >= Actors || Position < 0
		Log("Unknown Position, '"+Position+"' given", "FetchPosition")
		return none
	endIf
	int Stage
	string[] Anims = Utility.CreateStringArray(Stages)
	while Stage <= Stages
		Stage += 1
		Anims[Stage] = Animations[StageIndex(Position, Stage)]
	endWhile
	return Anims
endFunction

string function FetchPositionStage(int Position, int Stage)
	return Animations[StageIndex(Position, Stage)]
endFunction

function GetAnimEvents(string[] AnimEvents, int Stage)
	if AnimEvents.Length != 5 || Stage > Stages
		Log("Invalid Call("+AnimEvents+", "+Stage+"/"+Stages+")", "GetAnimEvents")
	else
		int Position
		while Position < Actors
			AnimEvents[Position] = Animations[StageIndex(Position, Stage)]
			Position += 1
		endWhile
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Stage Timer                                     --- ;
; ------------------------------------------------------- ;

bool function HasTimer(int Stage)
	return Timers && Stage > 0 && Stage <= Timers.Length && Timers[(Stage - 1)] != 0.0
endFunction

float function GetTimer(int Stage)
	if !HasTimer(Stage)
		return 0.0 ; Stage has no timer
	endIf
	return Timers[(Stage - 1)]
endFunction

function SetStageTimer(int Stage, float Timer)
	; Validate stage
	if Stage > Stages || Stage < 1
		Log("Unknown animation stage, '"+Stage+"' given.", "SetStageTimer")
		return
	endIf
	; Initialize timer array if needed
	if Timers.Length != Stages
		Timers = Utility.CreateFloatArray(Stages)
	endIf
	; Set timer
	Timers[(Stage - 1)] = Timer
endFunction

float function GetTimersRunTime(float[] StageTimers)
	if StageTimers.Length < 2
		return -1.0
	endIf
	float seconds  = 0.0
	int LastTimer  = (StageTimers.Length - 1)
	int LastStage  = (Stages - 1)
	int Stage = Stages
	while Stage > 0
 		Stage -= 1
 		if HasTimer(Stage)
 			seconds += GetTimer(Stage)
 		elseIf Stage < LastStage
 			seconds += StageTimers[PapyrusUtil.ClampInt(Stage, 0, (LastTimer - 1))]
 		elseIf Stage >= LastStage
 			seconds += StageTimers[LastTimer]
 		endIf
	endWhile
	return seconds
endFunction

; ------------------------------------------------------- ;
; --- Offsets                                         --- ;
; ------------------------------------------------------- ;
float[] function GetRawOffsets(int Position, int Stage)
	float[] Output = new float[4]
	return RawOffsets(Output, Position, Stage)
endFunction

float[] function _GetAllAdjustments(string Registrar, string AdjustKey) global native
float[] function GetAllAdjustments(string AdjustKey)
	return _GetAllAdjustments(Registry, Adjustkey)
endFunction

bool function _HasAdjustments(string Registrar, string AdjustKey, int Stage) global native
bool function HasAdjustments(string AdjustKey, int Stage)
	return _HasAdjustments(Registry, AdjustKey, Stage)
endFunction

function _PositionOffsets(string Registrar, string AdjustKey, string LastKey, int Stage, float[] RawOffsets) global native
float[] function PositionOffsets(float[] Output, string AdjustKey, int Position, int Stage, int BedTypeID = 0)
	if !Output || Output.Length < 4
		Output = new float[4]
	endIf
	int i = OffsetIndex(Stage, 0)
	float[] Offsets = OffsetsArray(Position)
	Output[0] = Offsets[i] + CenterAdjust[(Stage - 1)] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot - no offset
	
	_PositionOffsets(Registry, AdjustKey+"."+Position, LastKeys[Position], Stage, Output)
	
	float Forward = Output[0]
	float Side = Output[1]

	if Output[3] >= 360.0
		Output[3] = Output[3] - 360.0
	elseIf Output[3] < 0.0
		Output[3] = Output[3] + 360.0
	endIf
	
	Log("PositionOffsets()[Forward:"+Output[0]+",Sideward:"+Output[1]+",Upward:"+Output[2]+",Rotation:"+Output[3]+"]")
	return Output
endFunction

float[] function RawOffsets(float[] Output, int Position, int Stage)
	if !Output || Output.Length < 4
		Output = new float[4]
	endIf
	int i = OffsetIndex(Stage, 0)
	float[] Offsets = OffsetsArray(Position)
	Output[0] = Offsets[i] ; Forward
	Output[1] = Offsets[(i + 1)] ; Side
	Output[2] = Offsets[(i + 2)] ; Up
	Output[3] = Offsets[(i + 3)] ; Rot
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Adjustments                                     --- ;
; ------------------------------------------------------- ;

function _SetAdjustment(string Registrar, string AdjustKey, int Stage, int Slot, float Adjustment) global native
function SetAdjustment(string AdjustKey, int Position, int Stage, int Slot, float Adjustment)
	if Position < Actors
		; LastKeys[Position] = InitAdjustments(AdjustKey, Position)
		AniHumanScene._SetAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot, Adjustment)
	endIf
endFunction

float function _GetAdjustment(string Registrar, string AdjustKey, int Stage, int nth) global native
float function GetAdjustment(string AdjustKey, int Position, int Stage, int Slot)
	return AniHumanScene._GetAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot)
endFunction

float function _UpdateAdjustment(string Registrar, string AdjustKey, int Stage, int nth, float by) global native
function UpdateAdjustment(string AdjustKey, int Position, int Stage, int Slot, float AdjustBy)
	if Position < Actors
		; LastKeys[Position] = InitAdjustments(AdjustKey, Position)
		AniHumanScene._UpdateAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot, AdjustBy)
	endIf
endFunction
function UpdateAdjustmentAll(string AdjustKey, int Position, int Slot, float AdjustBy)
	if Position < Actors
		; LastKeys[Position] = InitAdjustments(AdjustKey, Position)
		int Stage = Stages
		while Stage
		AniHumanScene._UpdateAdjustment(Registry, AdjustKey+"."+Position, Stage, Slot, AdjustBy)
			Stage -= 1
		endWhile
	endIf
endFunction

function AdjustForward(string AdjustKey, int Position, int Stage, float AdjustBy, bool AdjustStage = false)
	if AdjustStage
		UpdateAdjustment(AdjustKey, Position, Stage, 0, AdjustBy)
	else
		UpdateAdjustmentAll(AdjustKey, Position, 0, AdjustBy)
	endIf
endFunction

function AdjustSideways(string AdjustKey, int Position, int Stage, float AdjustBy, bool AdjustStage = false)
	if AdjustStage
		UpdateAdjustment(AdjustKey, Position, Stage, 1, AdjustBy)
	else
		UpdateAdjustmentAll(AdjustKey, Position, 1, AdjustBy)
	endIf
endFunction

function AdjustUpward(string AdjustKey, int Position, int Stage, float AdjustBy, bool AdjustStage = false)
	if AdjustStage
		UpdateAdjustment(AdjustKey, Position, Stage, 2, AdjustBy)
	else
		UpdateAdjustmentAll(AdjustKey, Position, 2, AdjustBy)
	endIf
endFunction

function AdjustSchlong(string AdjustKey, int Position, int Stage, int AdjustBy)
	UpdateAdjustment(AdjustKey, Position, Stage, 3, AdjustBy as float)
endFunction

function _ClearAdjustments(string Registrar, string AdjustKey) global native
function RestoreOffsets(string AdjustKey)
	_ClearAdjustments(Registry, AdjustKey+".0")
	_ClearAdjustments(Registry, AdjustKey+".1")
	_ClearAdjustments(Registry, AdjustKey+".2")
	_ClearAdjustments(Registry, AdjustKey+".3")
	_ClearAdjustments(Registry, AdjustKey+".4")
endFunction

bool function _CopyAdjustments(string Registrar, string AdjustKey, float[] Array) global native

function CopyAdjustmentsFrom(string AdjustKey, string CopyKey, int Position)
	CopyKey   = CopyKey+"."+Position
	AdjustKey = AdjustKey+"."+Position
	float[] List
	if _HasAdjustments(Registry, CopyKey, Stages)
		List = _GetAllAdjustments(Registry, CopyKey)
	else
		List = GetEmptyAdjustments(Position)
	endIf
	_ClearAdjustments(Registry, AdjustKey)
	_CopyAdjustments(Registry, AdjustKey, List)
endFunction

string function GetLastKey(int Position)
	string LastKey = LastKeys[Position]
	if LastKey != "" && LastKey != "Global."+Position && _HasAdjustments(Registry, LastKey, Stages)
		return LastKey
	endIf
	return "Global."+Position
endFunction

string function InitAdjustments(string AdjustKey, int Position)
	if !AdjustKey || Position >= Actors || Position < 0
		Log("Unknown Position, '"+Position+"' given", "InitAdjustments")
		return LastKeys[Position]
	endIf
	
	AdjustKey += "."+Position
	if !_HasAdjustments(Registry, AdjustKey, Stages)
		; Pick key to copy from
		string CopyKey = LastKeys[Position]
		if AdjustKey == "Global."+Position || CopyKey == "" || CopyKey == "Global."+Position || !_HasAdjustments(Registry, CopyKey, Stages)
			CopyKey = "Global."+Position
		endIf
		if CopyKey != "Global."+Position
			string[] RaceIDs = PapyrusUtil.StringSplit(AdjustKey, ".")
			string[] LastRaceIDs = PapyrusUtil.StringSplit(LastKeys[Position], ".")
			if RaceIDs && RaceIDs.length > Position && (!LastRaceIDs || LastRaceIDs.length < Actors || RaceIDs[Position] != LastRaceIDs[Position])
				string id = RaceIDs[Position]
				Race RaceRef = Race.GetRace(id)
				string Gender = ""
				; 향후 추가
				; if !(RaceRef || id == "Humanoid" || AniCreatureSceneSlots.HasRaceKey(id))
				; 	int i = 0
				; 	while i < 6
				; 		i += 1
				; 		id = StringUtil.Substring(RaceIDs[Position], 0, (StringUtil.GetLength(RaceIDs[Position]) - i))
				; 		RaceRef = Race.GetRace(id)
				; 		if RaceRef || id == "Humanoid" || AniCreatureSceneSlots.HasRaceKey(id)
				; 			Gender = StringUtil.GetNthChar(RaceIDs[Position], (StringUtil.GetLength(RaceIDs[Position]) - i))
				; 			i = 6
				; 		endIf
				; 	endWhile
				; endIf
				if Gender && (Gender != "M") && (Gender != "F") && (Gender != "C")
					Gender = ""
				endIf
				if id+Gender == RaceIDs[Position] || id+Gender+"M" == RaceIDs[Position] || id+Gender+"F" == RaceIDs[Position]
					CopyKey = "Global."+Position
				endIf
			endIf
		endIf
		if AdjustKey != "Global."+Position && CopyKey == "Global."+Position && !_HasAdjustments(Registry, CopyKey, Stages)
			; Initialize Global profile
			_CopyAdjustments(Registry, "Global."+Position, GetEmptyAdjustments(Position))
		endIf
		; Get adjustments from lastkey or default global
		float[] List = _GetAllAdjustments(Registry, CopyKey)
		if List.Length != (Stages * 4)
			List = GetEmptyAdjustments(Position)
			Log(List, "InitAdjustments("+AdjustKey+")")
		else
			Log(List, "CopyAdjustments("+CopyKey+", "+AdjustKey+")")
		endIf
		; Copy list to profile
		_CopyAdjustments(Registry, AdjustKey, List)
	endIf
	return AdjustKey
endFunction

float[] function GetEmptyAdjustments(int Position)
	float[] Output = Utility.CreateFloatArray((Stages * 4))
	int[] Flags = FlagsArray(Position)
	int Stage = Stages
	while Stage > 0
		Output[AdjIndex(Stage, kSchlong)] = Flags[FlagIndex(Stage, kSchlong)]
		Stage -= 1
	endWhile
	return Output
endFunction

string[] function _GetAdjustKeys(string Registrar) global native
string[] function GetAdjustKeys()
	return _GetAdjustKeys(Registry)
endFunction

; ------------------------------------------------------- ;
; --- Flags                                           --- ;
; ------------------------------------------------------- ;

int[] function GetPositionFlags(string AdjustKey, int Position, int Stage)
	int[] Output = new int[5]
	return PositionFlags(Output, AdjustKey, Position, Stage)
endFunction

int[] function PositionFlags(int[] Output, string AdjustKey, int Position, int Stage)
	if !Output || Output.Length < 5
		Output = new int[5]
	endIf
	int i = FlagIndex(Stage, 0)
	int[] Flags = FlagsArray(Position)
	Output[0] = Flags[i]
	Output[1] = Flags[i + 1]
	Output[2] = Flags[i + 2]
	Output[3] = GetSchlong(AdjustKey, Position, Stage)
	Output[4] = GetGender(Position)
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Animation Info                                  --- ;
; ------------------------------------------------------- ;

bool function IsSilent(int Position, int Stage)
	return FlagsArray(Position)[FlagIndex(Stage, kSilent)] as bool
endFunction

bool function UseOpenMouth(int Position, int Stage)
	return FlagsArray(Position)[FlagIndex(Stage, kOpenMouth)] as bool
endFunction

bool function UseStrapon(int Position, int Stage)
	return FlagsArray(Position)[FlagIndex(Stage, kStrapon)] as bool
endFunction

int function _GetSchlong(string Registrar, string AdjustKey, string LastKey, int Stage) global native
int function GetSchlong(string AdjustKey, int Position, int Stage)
	int var = AniHumanScene._GetSchlong(Registry, AdjustKey+"."+Position, LastKeys[Position], Stage)
	if var == -99
		var = FlagsArray(Position)[FlagIndex(Stage, kSchlong)]
	endIf
	return var
endFunction

int function GetCumID(int Position, int Stage = 1)
	return FlagsArray(Position)[FlagIndex(Stage, kCumID)]
endFunction

int function GetCumSource(int Position, int Stage = 1)
	return FlagsArray(Position)[FlagIndex(Stage, kCumSrc)]
endFunction

bool function IsCumSource(int SourcePosition, int TargetPosition, int Stage = 1)
	int CumSrc = GetCumSource(TargetPosition, Stage)
	return CumSrc == -1 || CumSrc == SourcePosition 
endFunction

function SetStageCumID(int Position, int Stage, int CumID, int CumSource = -1)
	FlagsArray(Position)[FlagIndex(Stage, kCumID)]  = CumID
	FlagsArray(Position)[FlagIndex(Stage, kCumSrc)] = CumSource
endFunction

int function GetCum(int Position)
	return GetCumID(Position, Stages)
endFunction

int function ActorCount()
	return Actors
endFunction

int function StageCount()
	return Stages
endFunction

int function GetGender(int Position)
	return Positions[Position]
endFunction

bool function MalePosition(int Position)
	return Positions[Position] == 0
endFunction

bool function FemalePosition(int Position)
	return Positions[Position] == 1
endFunction

bool function CreaturePosition(int Position)
	return Positions[Position] >= 2
endFunction

int function FemaleCount()
	return Genders[1]
endFunction

int function MaleCount()
	return Genders[0]
endFunction

function SetContent(int contentType)
	; No longer used
endFunction

; ------------------------------------------------------- ;
; --- Creature Use                                    --- ;
; ------------------------------------------------------- ;
bool function HasActorRace(Actor ActorRef)
	return HasRaceID(MiscUtil.GetActorRaceEditorID(ActorRef))
endFunction

bool function HasRace(Race RaceRef)
	return HasRaceID(MiscUtil.GetRaceEditorID(RaceRef)) ; FormListFind(Profile, Key("Creatures"), RaceRef) != -1
endFunction

function AddRace(Race RaceRef)
	AddRaceID(MiscUtil.GetRaceEditorID(RaceRef))
endFunction

bool function HasRaceID(string RaceID)
	return RaceType != "" && RaceID != "" && AniCreatureSceneSlots.HasRaceID(RaceType, RaceID)
endFunction

bool function HasValidRaceKey(string[] RaceKeys)
	int i = RaceKeys.Length
	while i
		i -= 1
		if RaceKeys[i] != "" && RaceTypes.Find(RaceKeys[i]) != -1
			return true
		endIf
	endWhile
	return false
endFunction

int function CountValidRaceKey(string[] RaceKeys)
	int i = RaceKeys.Length
	int out = 0
	while i
		i -= 1
		if RaceKeys[i] != "" && RaceTypes.Find(RaceKeys[i]) != -1
			out += PapyrusUtil.CountString(RaceTypes, RaceKeys[i])
		endIf
	endWhile
	return out
endFunction

bool function IsPositionRace(int Position, string RaceKey)
	return RaceTypes && RaceTypes[Position] == RaceKey
endFunction

bool function HasPostionRace(int Position, string[] RaceKeys)
	return RaceTypes && RaceKeys.Find(RaceTypes[Position]) != -1
endFunction

string[] function GetRaceTypes()
	int i = RaceTypes.Length
	string[] out = Utility.CreateStringArray(i)
	while i
		i -= 1
		out[i] = RaceTypes[i]
	endWhile
	return out
endFunction

function AddRaceID(string RaceID)
	if !HasRaceID(RaceID)
		AniCreatureSceneSlots.AddRaceID(RaceType, RaceID)
	endIf
endFunction

function SetRaceKey(string RaceKey)
	if AniCreatureSceneSlots.HasRaceKey(RaceKey)
		RaceType = RaceKey
	else
		Log("Unknown or empty RaceKey!", "SetRaceKey("+RaceKey+")")
	endIf
endFunction

function SetPositionRaceKey(int Position, string RaceKey)
	if GetGender(Position) >= 2
		if !RaceTypes || RaceTypes.Length
			RaceTypes = new string[5]
		endIf
		RaceTypes[Position] = RaceKey
		RaceType            = RaceKey
	endIf
endFunction

function SetRaceIDs(string[] RaceList)
	RaceType = ""
	int i = RaceList.Length
	while i
		i -= 1
		string RaceKey = AniCreatureSceneSlots.GetRaceKeyByID(RaceList[i])
		if RaceKey != "" && RaceType != RaceKey
			RaceType = RaceKey
			i = 0
		endIf
	endWhile
endFunction

string[] function GetRaceIDs()
	return AniCreatureSceneSlots.GetAllRaceIDs(RaceType)
endFunction

; ------------------------------------------------------- ;
; --- Animation Setup                                 --- ;
; ------------------------------------------------------- ;

int aid
int oid
int fid
string[] GenderTags

bool Locked
int function AddPosition(int Gender = 0, int AddCum = -1)
	if Actors >= 4
		return -1
	endIf
	while Locked
		Utility.WaitMenuMode(0.1)		
	endWhile
	Locked = true
	
	oid = 0
	fid = 0

	Genders[Gender]   = Genders[Gender] + 1
	Positions[Actors] = Gender

	InitArrays(Actors)
	FlagsArray(Actors)[kCumID] = AddCum

	string GenderString = GetGenderString(Gender)
	GenderTags[0] = GenderTags[0]+GenderString
	GenderTags[1] = GenderString+GenderTags[1]

	Actors += 1
	Locked = false
	return (Actors - 1)
endFunction

int function AddCreaturePosition(string RaceKey, int Gender = 2, int AddCum = -1)
	if Actors >= 5
		return -1
	elseIf Gender <= 0 || Gender > 3
		Gender = 2
	elseIf Gender == 1
		Gender = 3
	endIf
	
	int pid = AddPosition(Gender, AddCum)
	if pid != -1 && RaceKey != ""
		if !RaceTypes || RaceTypes.Length < 1
			RaceTypes = new string[5]
		endIf
		RaceType       = RaceKey
		RaceTypes[pid] = RaceKey
	endIf

	return pid
endFunction

function AddPositionStage(int Position, string AnimationEvent, float forward = 0.0, float side = 0.0, float up = 0.0, float rotate = 0.0, bool silent = false, bool openmouth = false, bool strapon = true, int sos = 0)
	; Out of range position or empty animation event
	if Position == -1 || Position >= 5 || AnimationEvent == ""
		Log("FATAL: Invalid arguments!", "AddPositionStage("+Position+", "+AnimationEvent+")")
		return
	endIf

	; First position dictates stage count and sizes
	if Position == 0
		Stages += 1
		; Flag stage overflow
		if (fid + kFlagEnd) >= Flags0.Length
			Log("WARNING: Flags position overflow, resizing! - Current flags: "+Flags0, "AddPositionStage("+Position+", "+AnimationEvent+")")
			Flags0 = PapyrusUtil.ResizeIntArray(Flags0, (Flags0.Length + 32))
		endIf
		; Offset stage overflow
		if (oid + kOffsetEnd) >= Offsets0.Length
			Log("WARNING: Offsets position overflow, resizing! - Current offsets: "+Offsets0, "AddPositionStage("+Position+", "+AnimationEvent+")")
			Offsets0 = PapyrusUtil.ResizeFloatArray(Offsets0, (Offsets0.Length + 32))
		endIf
	endIf

	; Save stage animation event
	if aid < 128
		Animations[aid] = AnimationEvent
	else
		if aid == 128
			Log("WARNING: Animation stage overflow, resorting to push! - Current events: "+Animations, "AddPositionStage("+Position+", "+AnimationEvent+")")
		endIf
		Animations = PapyrusUtil.PushString(Animations, AnimationEvent)
	endIf
	aid += 1

	; Save position flags
	int[] Flags = FlagsArray(Position)
	Flags[fid + 0] = silent as int
	Flags[fid + 1] = openmouth as int
	Flags[fid + 2] = strapon as int
	Flags[fid + 3] = sos
	Flags[fid + 4] = Flags[kCumID]
	Flags[fid + 5] = -1
	fid += kFlagEnd

	; Save position offsets
	float[] Offsets = OffsetsArray(Position)
	Offsets[oid + 0] = forward
	Offsets[oid + 1] = side
	Offsets[oid + 2] = up
	Offsets[oid + 3] = rotate
	oid += kOffsetEnd
endFunction

function Save(int id = -1)
	; Add gender tags
	AddTag(GenderTags[0])
	if GenderTags[0] != GenderTags[1]
		AddTag(GenderTags[1])
	endIf
	; Compensate for custom 3P+ animations that mix gender order, such as FMF
	if PositionCount > 2
		AddTag(GetGenderTag(false))
		AddTag(GetGenderTag(true))
	endIf

	; Finalize config data
	Flags0     = Utility.ResizeIntArray(Flags0, (Stages * kFlagEnd))
	Offsets0   = Utility.ResizeFloatArray(Offsets0, (Stages * kOffsetEnd))
	Animations = Utility.ResizeStringArray(Animations, aid)
	; Positions  = Utility.ResizeIntArray(Positions, Actors)
	; LastKeys   = Utility.ResizeStringArray(LastKeys, Actors)
	; Init forward offset list
	CenterAdjust = Utility.CreateFloatArray(Stages)
	if Actors > 1
		int Stage = Stages
		while Stage
			CenterAdjust[(Stage - 1)] = CalcCenterAdjuster(Stage)
			Stage -= 1
		endWhile
	endIf

	; Reset saved keys if they no longer match
	if LastKeyReg != Registry
		LastKeys = new string[5]
	endIf
	LastKeyReg = Registry
	; Log the new animation
	if IsCreature
		if IsInterspecies()
			AddTag("Interspecies")
		else
			RemoveTag("Interspecies")
		endIf
		Log(Name, "Creatures["+id+"]")
	else
		Log(Name, "Animations["+id+"]")
	endIf
	; Finalize tags and registry slot id
	parent.Save(id)
endFunction

bool function IsInterspecies()
	if IsCreature
		int Position = PositionCount
		while Position > 1
			Position -= 1
			if RaceTypes[(Position - 1)] != "" && RaceTypes[Position] != ""
				string[] Keys1 = AniCreatureSceneSlots.GetAllRaceIDs(RaceTypes[(Position - 1)])
				string[] Keys2 = AniCreatureSceneSlots.GetAllRaceIDs(RaceTypes[Position])
				if Keys1 && Keys2 && Keys1.Length > 0 && Keys2.Length > 0 && Keys1 != Keys2
					int k1 = Keys1.Length
					int k2 = Keys2.Length
					if k1 == 1 && k2 == 1 && Keys1[0] != Keys2[0] 
						return true ; Simple single key mismatch
					elseIf (k1 == 1 && k2 > 1 && Keys2.Find(Keys1[0]) < 0) && \
						   (k2 == 1 && k1 > 1 && Keys1.Find(Keys2[0]) < 0)
					   return true ; Single key to multikey mismatch
					endIf
					bool Matched = false
					while k1
						k1 -= 1
						if Keys2.Find(Keys1[k1]) != -1
							Matched = true ; Matched between multikey arrays
						endIf
					endWhile
					if !Matched
					   return true ; Mismatch between multikey arrays
					endIf
				endIf
			endIf
		endWhile
	endIf
	return false
endFunction

float function CalcCenterAdjuster(int Stage)
	; Get forward Offsets of all Positions + find highest/lowest position
	float Adjuster
	int Position = Actors
	while Position
		Position -= 1
		float Forward = OffsetsArray(Position)[OffsetIndex(Stage, 0)]
		if Math.Abs(Forward) > Math.Abs(Adjuster)
			Adjuster = Forward
		endIf
	endWhile
	; Get signed half of highest/lowest offset
	return Adjuster * -0.5
endFunction

string function GenderTag(int count, string gender)
	if count == 0
		return ""
	elseIf count == 1
		return gender
	elseIf count == 2
		return gender+gender
	elseIf count == 3
		return gender+gender+gender
	elseIf count == 4
		return gender+gender+gender+gender
	elseIf count == 5
		return gender+gender+gender+gender+gender
	endIf
	return ""
endFunction

string function GetGenderString(int Gender)
	if Gender == 0
		return "M"
	elseIf Gender == 1
		return "F"
	elseIf Gender >= 2
		return "C"
	endIf
	return ""
endFunction

string function GetGenderTag(bool Reverse = false)
	if Reverse
		return GenderTag(Creatures, "C")+GenderTag(Males, "M")+GenderTag(Females, "F")
	endIf
	return GenderTag(Females, "F")+GenderTag(Males, "M")+GenderTag(Creatures, "C")
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;

function Initialize()
	aid       = 0
	oid       = 0
	fid       = 0
	Actors    = 0
	Stages    = 0
	RaceType  = ""
	GenderedCreatures = false

	Genders      = new int[4]
	Positions    = new int[4]
	GenderTags   = new string[2]

	; Only init if needed to keep between registry resets.
	if LastKeys.Length != 5
		LastKeys  = new string[5]
	endIf

	RaceTypes  = Utility.CreateStringArray(0)
	Animations = Utility.CreateStringArray(0)	
	Timers     = Utility.CreateFloatArray(0)

	Flags0 = Utility.CreateIntArray(0)
	Flags1 = Utility.CreateIntArray(0)
	Flags2 = Utility.CreateIntArray(0)
	Flags3 = Utility.CreateIntArray(0)	

	Offsets0 = Utility.CreateFloatArray(0)
	Offsets1 = Utility.CreateFloatArray(0)
	Offsets2 = Utility.CreateFloatArray(0)
	Offsets3 = Utility.CreateFloatArray(0)

	Locked = false

	parent.Initialize()
endFunction

; ------------------------------------------------------- ;
; --- Properties                                      --- ;
; ------------------------------------------------------- ;

; Creature Use
string property RaceType auto hidden
Form[] property CreatureRaces hidden
	form[] function get()
		string[] Races = AniCreatureSceneSlots.GetAllRaceIDs(RaceType)
		int i = Races.Length
		Form[] RaceRefs = Utility.CreateFormArray(i)
		while i
			i -= 1
			RaceRefs[i] = Race.GetRace(Races[i])
		endWhile
		return PapyrusUtil.ClearNone(RaceRefs)
	endFunction
endProperty

; Information
bool property IsCreature hidden
	bool function get()
		return Genders[2] > 0 || Genders[3] > 0
	endFunction
endProperty

bool property IsVaginal hidden
	bool function get()
		return HasTag("Vaginal")
	endFunction
endProperty
bool property IsAnal hidden
	bool function get()
		return HasTag("Anal")
	endFunction
endProperty
bool property IsOral hidden
	bool function get()
		return HasTag("Oral")
	endFunction
endProperty
bool property IsDirty hidden
	bool function get()
		return HasTag("Dirty")
	endFunction
endProperty
bool property IsLoving hidden
	bool function get()
		return HasTag("Loving")
	endFunction
endProperty

bool property IsBedOnly hidden
	bool function get()
		return HasTag("BedOnly")
	endFunction
endProperty

int property StageCount hidden
	int function get()
		return Stages
	endFunction
endProperty
int property PositionCount hidden
	int function get()
		return Actors
	endFunction
endProperty

; Position Genders
int[] property Genders auto hidden
int property Males hidden
	int function get()
		return Genders[0]
	endFunction
endProperty
int property Females hidden
	int function get()
		return Genders[1]
	endFunction
endProperty
int property Creatures hidden
	int function get()
		return Genders[2] + Genders[3]
	endFunction
endProperty
int property MaleCreatures hidden
	int function get()
		return Genders[2]
	endFunction
endProperty
int property FemaleCreatures hidden
	int function get()
		return Genders[3]
	endFunction
endProperty


int[] Flags0
int[] Flags1
int[] Flags2
int[] Flags3

int property kSilent    = 0 autoreadonly hidden
int property kOpenMouth = 1 autoreadonly hidden
int property kStrapon   = 2 autoreadonly hidden
int property kSchlong   = 3 autoreadonly hidden
int property kCumID     = 4 autoreadonly hidden
int property kCumSrc    = 5 autoreadonly hidden
int property kFlagEnd hidden
	int function get()
		return 6
	endFunction
endProperty

int[] function FlagsArray(int Position)
	if Position == 0
		return Flags0
	elseIf Position == 1
		return Flags1
	elseIf Position == 2
		return Flags2
	elseIf Position == 3
		return Flags3
	endIf
	return Utility.CreateIntArray(0)
endFunction

function FlagsSave(int Position, int[] Flags)
	if Position == 0
		Flags0 = Flags
	elseIf Position == 1
		Flags1 = Flags
	elseIf Position == 2
		Flags2 = Flags
	elseIf Position == 3
		Flags3 = Flags
	endIf
endFunction

float[] Offsets0
float[] Offsets1
float[] Offsets2
float[] Offsets3

int property kForward  = 0 autoreadonly hidden
int property kSideways = 1 autoreadonly hidden
int property kUpward   = 2 autoreadonly hidden
int property kRotate   = 3 autoreadonly hidden
int property kOffsetEnd hidden
	int function get()
		return 4
	endFunction
endProperty

float[] function OffsetsArray(int Position)
	if Position == 0
		return Offsets0
	elseIf Position == 1
		return Offsets1
	elseIf Position == 2
		return Offsets2
	elseIf Position == 3
		return Offsets3
	endIf
	return Utility.CreateFloatArray(0)
endFunction

function OffsetsSave(int Position, float[] Offsets)
	if Position == 0
		Offsets0 = Offsets
	elseIf Position == 1
		Offsets1 = Offsets
	elseIf Position == 2
		Offsets2 = Offsets
	elseIf Position == 3
		Offsets3 = Offsets
	endIf
endFunction

function InitArrays(int Position)
	if Position == 0
		Flags0     = new int[128]
		Offsets0   = new float[128]
		Animations = new string[128]
	elseIf Position == 1
		Flags1   = Utility.CreateIntArray((Stages * kFlagEnd))
		Offsets1 = Utility.CreateFloatArray((Stages * kOffsetEnd))
	elseIf Position == 2
		Flags2   = Utility.CreateIntArray((Stages * kFlagEnd))
		Offsets2 = Utility.CreateFloatArray((Stages * kOffsetEnd))
	elseIf Position == 3
		Flags3   = Utility.CreateIntArray((Stages * kFlagEnd))
		Offsets3 = Utility.CreateFloatArray((Stages * kOffsetEnd))
	endIf
endFunction
