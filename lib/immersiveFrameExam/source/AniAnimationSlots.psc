scriptname AniAnimationSlots extends Quest

import PapyrusUtil

Alias[] Objects
string[] Registry
int property Slotted auto hidden
AniHumanScene[] property Animations hidden
	AniHumanScene[] function get()
		return GetSlots(1, 128)
	endFunction
endProperty

Actor property PlayerRef auto
; sslSystemConfig property Config auto
; sslActorLibrary property ActorLib auto

; ------------------------------------------------------- ;
; --- Animation Filtering                             --- ;
; ------------------------------------------------------- ;

AniHumanScene[] function GetByTags(int ActorCount, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	; Log("GetByTags(ActorCount="+ActorCount+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	; Making the tags lists and optimize for CACHE
	string[] Suppress = StringSplit(TagsSuppressed)
	Suppress = ClearEmpty(Suppress)
	SortStringArray(Suppress)
	string[] Search   = StringSplit(Tags)
	Search = ClearEmpty(Search)
	SortStringArray(Search)
	; Check Cache
	; string CacheName = ActorCount+":"+Search+":"+Suppress+":"+RequireAll
	; AniHumanScene[] Output = CheckCache(CacheName)
	; if Output
	; 	return Output
	; endIf
	; Search
	bool[] Valid      = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		if Objects[i]
			AniHumanScene Slot = Objects[i] as AniHumanScene
			Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && Slot.TagSearch(Search, Suppress, RequireAll)
		endIf
	endWhile
	AniHumanScene[] Output = GetList(Valid)
	; CacheAnims(CacheName, Output)
	return Output
endFunction

AniHumanScene[] function GetByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	Log("GetByType(ActorCount="+ActorCount+", Males="+Males+", Females="+Females+")")
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	int i = Slotted
	while i
		i -= 1
		if Objects[i]
			AniHumanScene Slot = Objects[i] as AniHumanScene
			Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount && (Aggressive == Slot.HasTag("Aggressive")) \
			&& (((Males == -1 || Males == Slot.Males) && (Females == -1 || Females == Slot.Females))) && (StageCount == -1 || StageCount == Slot.StageCount) \
			&& Sexual != Slot.HasTag("LeadIn")
		endIf
	endWhile
	AniHumanScene[] Output = GetList(Valid)
	; CacheAnims(CacheName, Output)
	return Output
endFunction

AniHumanScene[] function PickByActors(Actor[] Positions, int Limit = 64, bool Aggressive = false)
	Log("PickByActors(Positions="+Positions+", Limit="+Limit+", Aggressive="+Aggressive+")")
	int[] Genders = AniUtility.GenderCount(Positions)
	AniHumanScene[] Matches = GetByDefault(Genders[0], Genders[1], Aggressive)
	if Matches.Length <= Limit
		return Matches
	endIf
	; Select random from within limit
	AniHumanScene[] Picked = AniUtility.AnimationArray(Limit)
	int i = Matches.Length
	while i && Limit
		i -= 1
		Limit -= 1
		; Check random index between 0 and before current
		int r = Utility.RandomInt(0, (i - 1))
		if Picked.Find(Matches[r]) == -1
			Picked[Limit] = Matches[r] ; Use random index
		else
			Picked[Limit] = Matches[i] ; Random index was used, use current index
		endIf
	endWhile
	return Matches
endFunction

AniHumanScene[] function GetByDefault(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true)
	Log("GetByDefault(Males="+Males+", Females="+Females+", IsAggressive="+IsAggressive+", UsingBed="+UsingBed+", RestrictAggressive="+RestrictAggressive+")")
	if Males == 0 && Females == 0
		return none ; No actors passed or creatures present
	endIf
	; Info
	int ActorCount = (Males + Females)
	bool SameSex = (Females == 2 && Males == 0) || (Males == 2 && Females == 0)	

	; Search
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	string GenderTag = AniUtility.GetGenderTag(Females, Males)
	int i = Slotted
	while i
		i -= 1
		if Objects[i]
			AniHumanScene Slot = Objects[i] as AniHumanScene 
			; Check for appropiate enabled aniamtion
			Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount
			if Valid[i]
				string[] RawTags = Slot.GetTags()
				int[] Genders = Slot.Genders
				; Suppress standing animations if on a bed
				Valid[i] = Valid[i] && ((!UsingBed && RawTags.Find("BedOnly") == -1) || (UsingBed && RawTags.Find("Furniture") == -1 && (RawTags.Find("Standing") == -1)))
				; Suppress or ignore aggressive animation tags
				Valid[i] = Valid[i] && (!RestrictAggressive || IsAggressive == (RawTags.Find("Aggressive") != -1))
				; Get SameSex + Non-SameSex
				if SameSex
					Valid[i] = Valid[i] && (RawTags.Find("FM") != -1 || (((Males == -1 || Males == Genders[0]) && (Females == -1 || Females == Genders[1])) || Slot.HasTag(GenderTag)))
				; Ignore genders for 3P+
				elseIf ActorCount < 3
					Valid[i] = Valid[i] && (((Males == -1 || Males == Genders[0]) && (Females == -1 || Females == Genders[1])) || Slot.HasTag(GenderTag))
				endIf
			endIf
		endIf
	endWhile
	AniHumanScene[] Output = GetList(Valid)
	; CacheAnims(CacheName, Output)
	return Output
endFunction

AniHumanScene[] function GetByDefaultTags(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	Log("GetByDefaultTags(Males="+Males+", Females="+Females+", IsAggressive="+IsAggressive+", UsingBed="+UsingBed+", RestrictAggressive="+RestrictAggressive+", Tags="+Tags+", TagsSuppressed="+TagsSuppressed+", RequireAll="+RequireAll+")")
	if Males == 0 && Females == 0
		return none ; No actors passed or creatures present
	endIf
	; Info
	int ActorCount = (Males + Females)
	bool SameSex = (Females == 2 && Males == 0) || (Males == 2 && Females == 0)
	
	; Making the tags lists and optimize for CACHE
	string[] Suppress = StringSplit(TagsSuppressed)
	Suppress = ClearEmpty(Suppress)
	SortStringArray(Suppress)
	string[] Search   = StringSplit(Tags)
	Search = ClearEmpty(Search)
	SortStringArray(Search)
	; Cleaning the tags
	if UsingBed
		Search = RemoveString(Search, "Furniture")	
	else
		Search = RemoveString(Search, "BedOnly")
	endIf
	if RestrictAggressive
		Search = RemoveString(Search, "Aggressive")
		Suppress = RemoveString(Suppress, "Aggressive")
	endIf
	Suppress = RemoveString(Suppress, GenderTag)
	; Check Cache
	; string CacheName = Males+":"+Females+":"+IsAggressive+":"+UsingBed+":"+BedRemoveStanding+":"+RestrictAggressive+":"+Search+":"+Suppress+":"+RequireAll
	; AniHumanScene[] Output = CheckCache(CacheName)
	; if Output
	; 	return Output
	; endIf
	; Search
	bool[] Valid = Utility.CreateBoolArray(Slotted)
	string GenderTag = AniUtility.GetGenderTag(Females, Males)

	int i = Slotted
	while i
		i -= 1
		if Objects[i]
			AniHumanScene Slot = Objects[i] as AniHumanScene
			; Check for appropiate enabled aniamtion
			Valid[i] = Slot.Enabled && ActorCount == Slot.PositionCount
			if Valid[i]
				string[] RawTags = Slot.GetTags()
				int[] Genders = Slot.Genders
				; Suppress standing animations if on a bed
				Valid[i] = Valid[i] && ((!UsingBed && RawTags.Find("BedOnly") == -1) || (UsingBed && RawTags.Find("Furniture") == -1 && (RawTags.Find("Standing") == -1)))
				; Suppress or ignore animation tags
				Valid[i] = Valid[i] && Slot.TagSearch(Search, Suppress, RequireAll) && (!RestrictAggressive || IsAggressive == (RawTags.Find("Aggressive") != -1))
				; Get SameSex + Non-SameSex
				if SameSex
					Valid[i] = Valid[i] && (RawTags.Find("FM") != -1 || (((Males == -1 || Males == Genders[0]) && (Females == -1 || Females == Genders[1])) || Slot.HasTag(GenderTag)))
				; Ignore genders for 3P+
				elseIf ActorCount < 3
					Valid[i] = Valid[i] && (((Males == -1 || Males == Genders[0]) && (Females == -1 || Females == Genders[1])) || Slot.HasTag(GenderTag))
				endIf
			endIf
		endIf
	endWhile
	AniHumanScene[] Output = GetList(Valid)
	; CacheAnims(CacheName, Output)
	return Output
endFunction

; ------------------------------------------------------- ;
; --- Registry Access                                     ;
; ------------------------------------------------------- ;

AniHumanScene function GetBySlot(int index)
	if index >= 0 && index < Slotted && Objects[index]
		return Objects[index] as AniHumanScene
	endIf
	return none
endFunction

AniHumanScene function GetByName(string FindName)
	return GetBySlot(FindByName(FindName))
endFunction

AniHumanScene function GetbyRegistrar(string Registrar)
	return GetBySlot(FindByRegistrar(Registrar))
endFunction

int function FindByRegistrar(string Registrar)
	if Registrar != ""
		return Registry.Find(Registrar)
	endIf
	return -1
endFunction

int function FindByName(string FindName)
	int i = Slotted
	while i
		i -= 1
		if GetBySlot(i) && GetBySlot(i).Name == FindName
			return i
		endIf
	endWhile
	return -1
endFunction

bool function IsRegistered(string Registrar)
	return FindByRegistrar(Registrar) != -1
endFunction

; ------------------------------------------------------- ;
; --- Object Utilities                                --- ;
; ------------------------------------------------------- ;

AniHumanScene[] function GetList(bool[] Valid)
	; Debug.Trace("GetList() - "+Valid)
	AniHumanScene[] Output
	if Valid && Valid.Length > 0 && Valid.Find(true) != -1
		int n = Valid.Find(true)
		int i = CountBool(Valid, true)
		; Trim over 100 to random selection
		if i > 125
			int end = Valid.RFind(true) - 1
			while i > 125
				int rand = Valid.Find(true, Utility.RandomInt(n, end))
				if rand != -1 && Valid[rand]
					Valid[rand] = false
					i -= 1
				endIf
				if i == 126 ; To be sure only 125 stay
					i = CountBool(Valid, true)
					n = Valid.Find(true)
					end = Valid.RFind(true) - 1
				endIf
			endWhile
		endIf
		; Get list
		Output = AniUtility.AnimationArray(i)
		while n != -1 && i > 0
			i -= 1
			Output[i] = Objects[n] as AniHumanScene
			n += 1
			if n < Slotted
				n = Valid.Find(true, n)
			else
				n = -1
			endIf
		endWhile
		; Only bother with logging the selected animation names if debug mode enabled.
		;/ string List = "Found Animations("+Output.Length+")"
		if Config.DebugMode
			List +=  " "
			i = Output.Length
			while i
				i -= 1
				List += "["+Output[i].Name+"]"
			endWhile
		endIf
		Log(List) /;
	else
		; Log("No Animations Found")
	endIf
	return Output
endFunction

string[] function GetNames(AniHumanScene[] SlotList)
	int i = SlotList.Length
	string[] Names = Utility.CreateStringArray(i)
	while i
		i -= 1
		if SlotList[i]
			Names[i] = SlotList[i].Name
		endIf
	endWhile
	if Names.Find("") != -1
		Names = RemoveString(Names, "")
	endIf
	return Names
endFunction

int function CountTag(AniHumanScene[] Anims, string Tags)
	string[] Checking = StringSplit(Tags)
	Checking = ClearEmpty(Checking)
	if Tags == "" || Checking.Length == 0
		return 0
	endIf
	int count
	int i = Anims.Length
	while i
		i -= 1
		count += Anims[i].HasOneTag(Checking) as int
	endWhile
	return count
endFunction

int function GetCount(bool IgnoreDisabled = true)
	if !IgnoreDisabled
		return Slotted
	endIf
	int Count
	int i = Slotted
	while i
		i -= 1
		Count += ((GetBySlot(i) && GetBySlot(i).Enabled) as int)
	endWhile
	return Count
endFunction

int function FindFirstTagged(string Tags, bool IgnoreDisabled = true, bool Reverse = false)
	string[] Checking = StringSplit(Tags)
	Checking = ClearEmpty(Checking)
	if Tags == "" || Checking.Length == 0
		return -1
	endIf
	int count
	int i = 0
	if !Reverse 
		i = Slotted
	endIf
	while (i && !Reverse) || (i < Slotted && Reverse)
		if !Reverse 
			i -= 1
		endIf
		if Objects[i]
			AniHumanScene Slot = Objects[i] as AniHumanScene
			if ((Slot.Enabled || !IgnoreDisabled) && Slot.HasAllTag(Checking))
				return i
			endIf
		endIf
		if Reverse 
			i += 1
		endIf
	endWhile
	return -1
endFunction

int function CountTagUsage(string Tags, bool IgnoreDisabled = true)
	string[] Checking = StringSplit(Tags)
	Checking = ClearEmpty(Checking)
	if Tags == "" || Checking.Length == 0
		return 0
	endIf
	int count
	int i = Slotted
	while i
		i -= 1
		if Objects[i]
			AniHumanScene Slot = Objects[i] as AniHumanScene
			count += ((Slot.Enabled || !IgnoreDisabled) && Slot.HasAllTag(Checking)) as int
		endIf
	endWhile
	return count
endfunction

string[] function GetAllTags(int ActorCount = -1, bool IgnoreDisabled = true)
	IgnoreDisabled = !IgnoreDisabled
	string[] Output
	int i = Slotted
	while i
		i -= 1
		if Objects[i]
			AniHumanScene Anim = Objects[i] as AniHumanScene
			if Anim && (IgnoreDisabled || Anim.Enabled) && (ActorCount == -1 || Anim.PositionCount == ActorCount)
				Output = MergeStringArray(Output, Anim.GetTags(), true)
			endif
		endIf
	endwhile
	SortStringArray(Output)
	return RemoveString(Output, "")
endFunction

; ------------------------------------------------------- ;
; --- Object MCM Pagination                               ;
; ------------------------------------------------------- ;

int function PageCount(int perpage = 125)
	return ((Slotted as float / perpage as float) as int) + 1
endFunction

int function FindPage(string Registrar, int perpage = 125)
	int i = Registry.Find(Registrar)
	if i != -1
		return ((i as float / perpage as float) as int) + 1
	endIf
	return -1
endFunction

string[] function GetSlotNames(int page = 1, int perpage = 125)
	return GetNames(GetSlots(page, perpage))
endfunction

AniHumanScene[] function GetSlots(int page = 1, int perpage = 125)
	perpage = ClampInt(perpage, 1, 128)
	if page > PageCount(perpage) || page < 1
		return AniUtility.AnimationArray(0)
	endIf
	int n
	AniHumanScene[] PageSlots
	if page == PageCount(perpage)
		n = Slotted
		PageSlots = AniUtility.AnimationArray((Slotted - ((page - 1) * perpage)))
	else
		n = page * perpage
		PageSlots = AniUtility.AnimationArray(perpage)
	endIf
	int i = PageSlots.Length
	while i
		i -= 1
		n -= 1
		if Objects[n]
			PageSlots[i] = Objects[n] as AniHumanScene
		endIf
	endWhile
	return PageSlots
endFunction

; ------------------------------------------------------- ;
; --- Object Registration                                 ;
; ------------------------------------------------------- ;
function RegisterSlots()
	; ClearAnimCache()
	; ClearTagCache()
	; Register default animation
	; PreloadCategoryLoaders()
	; (Game.GetFormFromFile(0x639DF, "SexLab.esm") as sslAnimationDefaults).LoadAnimations()
	; Send mod event for 3rd party animation
	ModEvent.Send(ModEvent.Create("SexLabSlotAnimations"))
	Debug.Notification("$SSL_NotifyAnimationInstall")
endFunction

bool RegisterLock
int function Register(string Registrar)
	if Registrar == "" || !Registry || Registry.Length < 1
		return -1
	elseIf Registry.Find(Registrar) != -1 || Slotted >= GetNumAliases()
		return -1
	endIf

	; Thread lock registration
	float failsafe = Utility.GetCurrentRealTime() + 6.0
	while RegisterLock && failsafe < Utility.GetCurrentRealTime()
		Utility.WaitMenuMode(0.5)
		Log("Register("+Registrar+") - Lock wait...")
	endWhile
	RegisterLock = true

	int i = Slotted
	Slotted += 1
	if i >= Registry.Length
		int n = Registry.Length + 32
		if n > GetNumAliases()
			n = GetNumAliases()
		endIf
		Log("Resizing animation registry slots: "+Registry.Length+" -> "+n)
		Registry = Utility.ResizeStringArray(Registry, n)
		Objects  = Utility.ResizeAliasArray(Objects, n, GetNthAlias(0))
		while n
			n -= 1
			if Registry[n] == ""
				Objects[n] = none
			endIf
		endWhile
		i = Registry.Find("")
	endIf
	Registry[i] = Registrar
	Objects[i]  = GetNthAlias(i)

	; Release lock
	RegisterLock = false
	return i
endFunction

; bool function IsSuppressed(string Registrar)
; 	return JsonUtil.StringListHas("../SexLab/SuppressedAnimations.json", "suppress", Registrar)
; endFunction

; function NeverRegister(string Registrar)
; 	if !IsSuppressed(Registrar)
; 		JsonUtil.StringListAdd("../SexLab/SuppressedAnimations.json", "suppress", Registrar, false)
; 		JsonUtil.Save("../SexLab/SuppressedAnimations.json", true)
; 	endIf
; endFunction

; function AllowRegister(string Registrar)
; 	if IsSuppressed(Registrar)
; 		JsonUtil.StringListRemove("../SexLab/SuppressedAnimations.json", "suppress", Registrar, true)
; 		JsonUtil.Save("../SexLab/SuppressedAnimations.json", true)
; 	endIf
; endFunction

; int function ClearSuppressed()
; 	int i = JsonUtil.StringListClear("../SexLab/SuppressedAnimations.json", "suppress")
; 	JsonUtil.Save("../SexLab/SuppressedAnimations.json", true)
; 	return i
; endFunction

; int function GetDisabledCount()
; 	int count
; 	int i = Slotted
; 	while i
; 		i -= 1
; 		if Objects[i]
; 			AniHumanScene Slot = Objects[i] as AniHumanScene
; 			if Slot.Registered && !Slot.Enabled
; 				count += 1
; 			endIf
; 		endIf
; 	endWhile
; 	return count
; endFunction

; int function GetSuppressedCount()
; 	return JsonUtil.StringListCount("../SexLab/SuppressedAnimations.json", "suppress")
; endFunction

; int function SuppressDisabled()
; 	int count
; 	int i = Slotted
; 	while i
; 		i -= 1
; 		if Objects[i]
; 			AniHumanScene Slot = Objects[i] as AniHumanScene
; 			if Slot.Registered && !Slot.Enabled
; 				NeverRegister(Slot.Registry)
; 				count += 1
; 			endIf
; 		endIf
; 	endWhile
; 	return count
; endFunction

; string[] function GetSuppressedList()
; 	return JsonUtil.StringListToArray("../SexLab/SuppressedAnimations.json", "suppress")
; endFunction

; function PreloadCategoryLoaders()
; 	string[] Files = JsonUtil.JsonInFolder(JLoaders)
; 	if !Files
; 		return ; No JSON Animation Loaders
; 	endIf

; 	; Clear existing lists
; 	StorageUtil.StringListClear(self, "categories")
; 	StorageUtil.ClearObjStringListPrefix(self, "cat.")

; 	; Load files into categories
; 	int i = Files.Length
; 	while i
; 		i -= 1
; 		; Ignore the 2 example files.
; 		if Files[i] != "ArrokReverseCowgirl.json" && Files[i] != "TrollGrabbing.json"
; 			string Category = JsonUtil.GetPathStringValue(JLoaders+Files[i], ".category", "Misc")
; 			StorageUtil.StringListAdd(self, "categories", Category, false)
; 			StorageUtil.StringListAdd(self, "cat."+Category, Files[i], false)
; 		endIf
; 	endWhile
; endFunction


; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

string property JLoaders auto hidden

function Setup()
	GoToState("Locked")
	Slotted  = 0
	Registry = new string[128] ; Utility.CreateStringArray(164)
	Objects  = new Alias[128] ; Utility.CreateAliasArray(164, GetNthAlias(0))
	PlayerRef = Game.GetPlayer()
	; if !Config || !ActorLib
	; 	Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm")
	; 	if SexLabQuestFramework
	; 		Config    = SexLabQuestFramework as sslSystemConfig			
	; 		ActorLib  = SexLabQuestFramework as sslActorLibrary
	; 	endIf
	; endIf

	JLoaders = "../SexLab/Animations/"

	RegisterLock = false
	RegisterSlots()
	GoToState("")
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction

state Locked
	function Setup()
	endFunction
endState
