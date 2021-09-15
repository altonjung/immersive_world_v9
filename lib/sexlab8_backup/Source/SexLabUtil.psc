scriptname SexLabUtil hidden

; ------------------------------------------------------- ;
; --- SexLab Accessors                                --- ;
; ------------------------------------------------------- ;

int function GetVersion() global
	return 16208
endFunction

string function GetStringVer() global
	return "New Sexlab 1.0"
endFunction

bool function SexLabIsActive() global
	return GetAPI() != none
endFunction

bool function SexLabIsReady() global
	SexLabFramework SexLab = GetAPI()
	return SexLab != none && SexLab.Enabled
endFunction

SexLabFramework function GetAPI() global
	return Game.GetFormFromFile(0xD62, "SexLab.esm") as SexLabFramework
endFunction

sslSystemConfig function GetConfig() global
	return Game.GetFormFromFile(0xD62, "SexLab.esm") as sslSystemConfig
endFunction

; ------------------------------------------------------- ;
; --- Animation Starters                              --- ;
; ------------------------------------------------------- ;

int function StartSex(actor[] sexActors, sslBaseAnimation[] anims, actor victim = none, ObjectReference centerOn = none, bool allowBed = true, string hook = "") global
	SexLabFramework SexLab = GetAPI()
	if !SexLab
		return -1
	endIf
	return SexLab.StartSex(sexActors, anims, victim, centerOn, allowBed, hook)
endFunction

sslThreadModel function NewThread(float timeout = 30.0) global
	SexLabFramework SexLab = GetAPI()
	if !SexLab
		return none
	endIf
	return SexLab.NewThread(timeout)
endFunction

sslThreadController function QuickStart(actor a1, actor a2 = none, actor a3 = none, actor a4 = none, actor a5 = none, actor victim = none, string hook = "", string animationTags = "") global
	SexLabFramework SexLab = GetAPI()
	if !SexLab
		return none
	endIf
	return SexLab.QuickStart(a1, a2, a3, a4, a5, victim, hook, animationTags)
endFunction

; ------------------------------------------------------- ;
; --- Common Utilities                                --- ;
; ------------------------------------------------------- ;

string function ActorName(Actor ActorRef) global
	return ActorRef.GetLeveledActorBase().GetName()
endFunction

int function GetGender(Actor ActorRef) global
	return GetAPI().ActorLib.GetGender(ActorRef)
endFunction

bool function IsActorActive(Actor ActorRef) global
	return ActorRef.IsInFaction(GetConfig().AnimatingFaction)
endFunction

bool function IsValidActor(Actor ActorRef) global
	return GetAPI().ActorLib.IsValidActor(ActorRef)
endFunction

string function MakeGenderTag(Actor[] Positions) global
	int[] Genders = GetAPI().ActorLib.GenderCount(Positions)
	return GetGenderTag(Genders[1], Genders[0], Genders[2])
endFunction

string function GetGenderTag(int Females = 0, int Males = 0, int Creatures = 0) global
	string Tag
	while Females > 0
		Females -= 1
		Tag += "F"
	endWhile
	while Males > 0
		Males -= 1
		Tag += "M"
	endWhile
	while Creatures > 0
		Creatures -= 1
		Tag += "C"
	endWhile
	return Tag
endFunction

bool function IsActor(Form FormRef) global
	if FormRef
		int Type = FormRef.GetType()
		return Type == 43 || Type == 44 || Type == 62 ; kNPC = 43 kLeveledCharacter = 44 kCharacter = 62
	endIf
	return false
endFunction

bool function IsEssential(Actor ActorRef, bool Strict = false) global
	if ActorRef == Game.GetPlayer()
		return true
	elseIf !ActorRef || ActorRef.IsDead() || ActorRef.IsDeleted() || ActorRef.IsChild()
		return false
	elseIf !Strict
		return true
	endIf
	; Strict check
	ActorBase BaseRef = ActorRef.GetLeveledActorBase()
	return BaseRef.IsUnique() || BaseRef.IsEssential() || BaseRef.IsInvulnerable() || BaseRef.IsProtected() || ActorRef.IsGuard() || ActorRef.IsPlayerTeammate() || ActorRef.Is3DLoaded()
endFunction

; ------------------------------------------------------- ;
; --- Developer Utilities                             --- ;
; ------------------------------------------------------- ;

int function GetPluginVersion() global native
bool function HasKeywordSub(form ObjRef, string LookFor) global native
string function RemoveSubString(string InputString, string RemoveString) global native
function PrintConsole(string output) global native
function VehicleFixMode(int mode) global native

; Inline true/false return - pseudo papyrus ternary
float function FloatIfElse(bool isTrue, float returnTrue, float returnFalse = 0.0) global native
int function IntIfElse(bool isTrue, int returnTrue, int returnFalse = 0) global native
string function StringIfElse(bool isTrue, string returnTrue, string returnFalse = "") global native
Form function FormIfElse(bool isTrue, Form returnTrue, Form returnFalse = none) global native
Actor function ActorIfElse(bool isTrue, Actor returnTrue, Actor returnFalse = none) global native
ObjectReference function ObjectIfElse(bool isTrue, ObjectReference returnTrue, ObjectReference returnFalse = none) global native
ReferenceAlias function AliasIfElse(bool isTrue, ReferenceAlias returnTrue, ReferenceAlias returnFalse = none) global native
Actor[] function MakeActorArray(Actor Actor1 = none, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none) global native

int function IntMinMaxValue(int[] searchArray, bool findHighestValue = true) global native
int function IntMinMaxIndex(int[] searchArray, bool findHighestValue = true) global native

float function FloatMinMaxValue(float[] searchArray, bool findHighestValue = true) global native
int function FloatMinMaxIndex(float[] searchArray, bool findHighestValue = true) global native

function Wait(float seconds) global
	float timer = Utility.GetCurrentRealTime() + seconds
	while Utility.GetCurrentRealTime() < timer
		Utility.Wait(0.50)
	endWhile
endFunction

float function Timer(float Timestamp, string Log) global
	float i = Utility.GetCurrentRealTime()
	return i
endFunction
