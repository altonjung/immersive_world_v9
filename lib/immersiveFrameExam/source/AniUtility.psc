scriptname AniUtility hidden

;/-----------------------------------------------\;
;|	Actor Utility Functions
;\-----------------------------------------------/;

int function MaleCount(Actor[] Positions)
	return AniUtility.GenderCount(Positions)[0]
endFunction

int function FemaleCount(Actor[] Positions)
	return AniUtility.GenderCount(Positions)[1]
endFunction

int function CreatureCount(Actor[] Positions)
	int[] Genders = AniUtility.GenderCount(Positions)
	return Genders[2] + Genders[3]
endFunction

int function CreatureMaleCount(Actor[] Positions)
	return AniUtility.GenderCount(Positions)[2]
endFunction

int function CreatureFemaleCount(Actor[] Positions)
	return AniUtility.GenderCount(Positions)[3]
endFunction

int function GetGender(Actor ActorRef) global
	if ActorRef
		ActorBase BaseRef = ActorRef.GetLeveledActorBase()
		if AniCreatureSceneSlots.HasRaceType(BaseRef.GetRace())
			return 2 + BaseRef.GetSex() ; CreatureGenders:		
		else
			return BaseRef.GetSex() ; Default
		endIf
	endIf
	return 0 ; Invalid actor - default to male for compatibility
endFunction

int[] function GetGendersAll(Actor[] Positions)
	int i = Positions.Length
	int[] Genders = Utility.CreateIntArray(i)
	while i > 0
		i -= 1
		Genders[i] = AniUtility.GetGender(Positions[i])
	endWhile
	return Genders
endFunction

int[] function GenderCount(Actor[] Positions) global
	int[] Genders = new int[4]
	int i = Positions.Length
	while i > 0
		i -= 1
		int g = AniUtility.GetGender(Positions[i])
		Genders[g] = Genders[g] + 1
	endWhile
	return Genders
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

string function GetReverseGenderTag(int Females = 0, int Males = 0, int Creatures = 0) global
	string Tag
	while Creatures > 0
		Creatures -= 1
		Tag += "C"
	endWhile
	while Males > 0
		Males -= 1
		Tag += "M"
	endWhile
	while Females > 0
		Females -= 1
		Tag += "F"
	endWhile
	return Tag
endFunction

;/-----------------------------------------------\;
;|	Misc Utility Functions
;\-----------------------------------------------/;

AniHumanScene[] function PushAnimation(AniHumanScene var, AniHumanScene[] Array) global
	int len = Array.Length
	if len >= 128
		return Array
	elseIf len == 0
		Array = new AniHumanScene[1]
		Array[0] = var
		return Array
	endIf
	AniHumanScene[] Pushed = AnimationArray(len+1)
	Pushed[len] = var
	while len
		len -=1
		Pushed[len] = Array[len]
	endWhile
	return Pushed
endFunction

AniHumanScene[] function IncreaseAnimation(int by, AniHumanScene[] Array) global
	int len = Array.Length
	if by < 1 || (len+by > 128)
		return Array
	elseIf len == 0
		return AnimationArray(by)
	endIf
	AniHumanScene[] Output = AnimationArray(len+by)
	while len
		len -= 1
		Output[len] = Array[len]
	endWhile
	return Output
endFunction

AniHumanScene[] function EmptyAnimationArray() global
	AniHumanScene[] empty
	return empty
endFunction

AniHumanScene[] function MergeAnimationLists(AniHumanScene[] List1, AniHumanScene[] List2) global
	int Count = List2.Length
	int i = List2.Length
	while i
		i -= 1
		Count -= ((List1.Find(List2[i]) != -1) as int)
	endWhile
	AniHumanScene[] Output = IncreaseAnimation(Count, List1)
	i = List2.Length
	while i && Count
		i -= 1
		if List1.Find(List2[i]) == -1
			Count -= 1
			Output[Count] = List2[i]
		endIf
	endWhile
	return Output
endFunction

AniHumanScene[] function FilterTaggedAnimations(AniHumanScene[] Anims, string[] Tags, bool HasTag = true) global
	if !Anims || Anims.Length < 1
		return Anims
	elseIf !Tags || Tags.Length < 1
		if HasTag
			return AnimationArray(0)
		endIf
		return Anims
	endIf
	int i = Anims.Length
	bool[] Valid = Utility.CreateBoolArray(i)
	while i
		i -= 1
		Valid[i] = Anims[i].HasOneTag(Tags) == HasTag
	endWhile
	; Check results
	if Valid.Find(true) == -1
		return AnimationArray(0) ; No valid animations
	elseIf Valid.Find(false) == -1
		return Anims ; All valid animations
	endIf
	; Filter output
	i = Anims.Length
	int n = PapyrusUtil.CountBool(Valid, true)
	AniHumanScene[] Output = AnimationArray(n)
	while i && n
		i -= 1
		if Valid[i]
			n -= 1
			Output[n] = Anims[i]
		endIf
	endWhile
	return Output
endFunction

AniHumanScene[] function RemoveTaggedAnimations(AniHumanScene[] Anims, string[] Tags) global
	return FilterTaggedAnimations(Anims, Tags, false)
endFunction

bool[] function FindTaggedAnimations(AniHumanScene[] Anims, string[] Tags) global
	if Anims.Length < 1 || Tags.Length < 0
		return Utility.CreateBoolArray(0)
	endIf
	int i = Anims.Length
	bool[] Output = Utility.CreateBoolArray(i)
	while i
		i -= 1
		Output[i] = Anims[i].HasOneTag(Tags)
	endWhile
	return Output
endFunction

AniHumanScene function AnimationIfElse(bool isTrue, AniHumanScene returnTrue, AniHumanScene returnFalse) global
	if isTrue
		return returnTrue
	endIf
	return returnFalse
endfunction

AniHumanScene[] function AnimationArrayIfElse(bool isTrue, AniHumanScene[] returnTrue, AniHumanScene[] returnFalse) global
	if isTrue
		return returnTrue
	endIf
	return returnFalse
endfunction

AniHumanScene[] function ShuffleAnimations(AniHumanScene[] Anims) global
	if !Anims || Anims.Length < 3
		return Anims
	endIf
	AniHumanScene[] Output = AnimationArray(Anims.Length)
	int n = Anims.Length
	int max = n - 1
	while n > 0
		n -= 1
		int i = Utility.RandomInt(0, max)
		if Output[i]
			if i != max
				i = Output.Find(none, i)
				if i == -1
					i = Output.Find(none)
				endIf
			else
				i = Output.RFind(none)
			endIf
		endIf
		if i == -1 || Output[i] != none
			debug.trace("SHUFFLE ANIMATIONS GOT -1 "+Output)
			debug.traceuser("SexLabDebug", "SHUFFLE ANIMATIONS GOT -1 "+Output)
			i = Output.Find(none)
		endIf
		Output[i] = Anims[n]
	endWhile
	return Output
endFunction

; TODO
AniHumanScene[] function RemoveDupesFromList(AniHumanScene[] List, AniHumanScene[] Removing, bool PreventAll = true) global
	if !Removing || Removing.Length < 1 || !List || List.Length < 1
		return List
	endIf
	int Dupes
	int i = Removing.Length
	while i
		i -= 1
		Dupes += (List.Find(Removing[i]) != -1) as int
	endWhile
	if Dupes == 0 || (PreventAll && List.Length == Dupes)
		return List
	elseIf !PreventAll && Dupes == List.Length
		return AnimationArray(0)
	endIf 
	AniHumanScene[] Output = AnimationArray(List.Length - Dupes)
	int n = Output.Length
	i = List.Length
	while i > 0 && n > 0
		i -= 1
		if Removing.Find(List[i]) == -1
			n -= 1
			Output[n] = List[i]
		endIf
	endwhile
	return Output
endFunction

string[] function GetAnimationNames(AniHumanScene[] List) global
	int i = List.Length 
	string[] Names = Utility.CreateStringArray(i)
	while i
		i -= 1
		if List[i]
			Names[i] = List[i].Name
		else
			Names[i] = "<empty>"
		endIf
	endWhile
	return Names
endFunction

string[] function GetAllAnimationTagsInArray(AniHumanScene[] List) global
	string[] Output
	if !List
		return Output
	endIf
	int i = List.Length
	while i
		i -= 1
		if List[i]
			Output = PapyrusUtil.MergeStringArray(Output, List[i].GetTags(), true)
		endIf
	endwhile
	PapyrusUtil.SortStringArray(Output)
	return PapyrusUtil.RemoveString(Output, "")
endFunction

;/-----------------------------------------------\;
;|	Utility Functions
;\-----------------------------------------------/;

int function IndexTravel(int CurrentIndex, int ArrayLength, bool Reverse = false) global
	if Reverse
		CurrentIndex -= 1
	else
		CurrentIndex += 1
	endIf
	if CurrentIndex >= ArrayLength
		return 0
	elseif CurrentIndex < 0
		return ArrayLength - 1
	endIf
	return CurrentIndex
endFunction

string function Trim(string var) global
	if StringUtil.GetNthChar(var, 0) == " "
		var = StringUtil.SubString(var, 1)
	endIf
	if StringUtil.GetNthChar(var, (StringUtil.GetLength(var) - 1)) == " "
		var = StringUtil.SubString(var, (StringUtil.GetLength(var) - 2))
	endIf
	return var
endFunction

string function RemoveString(string str, string toRemove, int startindex = 0) global
	int i = StringUtil.Find(str, toRemove, startindex)
	if i == -1
		return str
	elseIf i == 0
		return StringUtil.SubString(str, StringUtil.GetLength(toRemove))
	endIf
	string part1 = StringUtil.SubString(str, 0, i)
	string part2 = StringUtil.SubString(str, (i + StringUtil.GetLength(toRemove)))
	return part1 + part2
endFunction

string function MakeArgs(string delimiter, string arg1, string arg2 = "", string arg3 = "", string arg4 = "", string arg5 = "") global
	if arg2 != ""
		arg1 += delimiter+arg2
	endIf
	if arg3 != ""
		arg1 += delimiter+arg3
	endIf
	if arg4 != ""
		arg1 += delimiter+arg4
	endIf
	if arg5 != ""
		arg1 += delimiter+arg5
	endIf
	return arg1
endFunction

Actor[] function MakeActorArray(Actor Actor1 = none, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none) global
	return AniUtility.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
endFunction

;/-----------------------------------------------\;
;|	DEPRECATED Utility Functions -
;|     - See PapyrusUtil.psc
;\-----------------------------------------------/;


bool[] function BoolArray(int size) global
	; Debug.Trace("SEXLAB -- sslUtility.BoolArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateBoolArray(size)
endFunction
float[] function FloatArray(int size) global
	; Debug.Trace("SEXLAB -- sslUtility.FloatArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateFloatArray(size)
endFunction
int[] function IntArray(int size) global
	; Debug.Trace("-- sslUtility.IntArray SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateIntArray(size)
endFunction
string[] function StringArray(int size) global
	; Debug.Trace("SEXLAB -- sslUtility.StringArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateStringArray(size)
endFunction
Form[] function FormArray(int size) global
	; Debug.Trace("SEXLAB -- sslUtility.FormArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateFormArray(size)
endFunction
Actor[] function ActorArray(int size) global
	; Debug.Trace("SEXLAB -- sslUtility.ActorArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ActorArray(size)
endFunction


; string function MakeArgs(string delimiter, string arg1, string arg2 = "", string arg3 = "", string arg4 = "", string arg5 = "") global
	; Debug.Trace("SEXLAB -- sslUtility.MakeArgs -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
; 	return PapyrusUtil.MakeArgs(delimiter, arg1, arg2, arg3, arg4, arg5)
; endFunction

string[] function ArgString(string args, string delimiter = ",") global
	; Debug.Trace("SEXLAB -- sslUtility.ArgString -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.StringSplit(args, delimiter)
endFunction

Actor[] function PushActor(Actor var, Actor[] Array) global
	return PapyrusUtil.PushActor(Array, var)
endFunction

int function CountNone(form[] Array) global
	; Debug.Trace("-- sslUtility.CountNone SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.CountForm(Array, none)
endFunction
int function CountTrue(bool[] Array) global
	; Debug.Trace("-- sslUtility.CountTrue SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.CountBool(Array, true)
endFunction
int function CountEmpty(string[] Array) global
	; Debug.Trace("-- sslUtility.CountEmpty SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.CountString(Array, "")
endFunction

; function FormCopyTo(form[] Array, form[] Output, bool AllowNone) global
; 	; Debug.Trace("-- sslUtility.FormCopyTo SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
; 	PapyrusUtil.FormCopyTo(Array, Output, 0, -1, !AllowNone)
; endFunction
; function BoolCopyTo(bool[] Array, bool[] Output, int StartIndex = 0, int EndIndex = -1) global
; 	; Debug.Trace("-- sslUtility.BoolCopyTo SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
; 	PapyrusUtil.BoolCopyTo(Array, Output, StartIndex, Endindex)
; endFunction
; function StringCopyTo(string[] Array, string[] Output, int StartIndex = 0, int EndIndex = -1, bool AllowEmpty = true) global
; 	; Debug.Trace("-- sslUtility.StringCopyTo SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
; 	PapyrusUtil.StringCopyTo(Array, Output, StartIndex, Endindex, !AllowEmpty)
; endFunction
; function FloatCopyTo(float[] Array, float[] Output, int StartIndex = 0, int EndIndex = -1) global
; 	; Debug.Trace("-- sslUtility.FloatCopyTo SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
; 	PapyrusUtil.FloatCopyTo(Array, Output, StartIndex, Endindex)
; endFunction
; function IntCopyTo(int[] Array, int[] Output, int StartIndex = 0, int EndIndex = -1) global
	; Debug.Trace("SEXLAB -- sslUtility.IntCopyTo -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
; 	PapyrusUtil.IntCopyTo(Array, Output, StartIndex, Endindex)
; endFunction

int[] function SliceIntArray(int[] Array, int startindex = 0, int endindex = -1) global
	; Debug.Trace("SEXLAB -- sslUtility.SliceIntArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.SliceIntArray(Array, startindex, endindex)
endFunction

float function AddFloatValues(float[] Array) global
	; Debug.Trace("-- sslUtility.AddFloatValues SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.AddFloatValues(Array)
endFunction
int function AddIntValues(int[] Array) global
	; Debug.Trace("-- sslUtility.AddIntValues SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.AddIntValues(Array)
endFunction

int[] function IncreaseInt(int by, int[] Array) global
	; Debug.Trace("-- sslUtility.IncreaseInt SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeIntArray(Array, (Array.Length + by))
endFunction

int[] function TrimIntArray(int[] Array, int len) global
	; Debug.Trace("-- sslUtility.TrimIntArray SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeIntArray(Array, len)
endFunction

int[] function PushInt(int var, int[] Array) global
	; Debug.Trace("-- sslUtility.PushInt SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.PushInt(Array, var)
endFunction

int[] function MergeIntArray(int[] Push, int[] Array) global
	; Debug.Trace("-- sslUtility.MergeIntArray SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.MergeIntArray(Array, Push)
endFunction

int function ClampInt(int value, int min, int max) global
	; Debug.Trace("-- sslUtility.ClampInt SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ClampInt(value, min, max)
endFunction

; int function SignInt(bool sign, int value) global
; 	; Debug.Trace("-- sslUtility.ignInt SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
; 	return PapyrusUtil.SignInt(sign, value)
; endFunction

int[] function EmptyIntArray() global
	; Debug.Trace("-- sslUtility.EmptyIntArray SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateIntArray(0)
endFunction

int function WrapIndex(int index, int len) global
	; Debug.Trace("-- sslUtility.WrapIndex SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.WrapInt(index, len, 0)
endFunction

float[] function IncreaseFloat(int by, float[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.IncreaseFloat -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeFloatArray(Array, (Array.Length + by))
endFunction

float[] function TrimFloatArray(float[] Array, int len) global
	; Debug.Trace("SEXLAB -- sslUtility.TrimFloatArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeFloatArray(Array, len)
endFunction

float[] function PushFloat(float var, float[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.PushFloat -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.PushFloat(Array, var)
endFunction

float[] function MergeFloatArray(float[] Push, float[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.MergeFloatArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.MergeFloatArray(Array, Push)
endFunction

float function ClampFloat(float value, float min, float max) global
	; Debug.Trace("-- sslUtility.ClampFloat SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ClampFloat(value, min, max)
endFunction

; float function SignFloat(bool sign, float value) global
; 	; Debug.Trace("-- sslUtility.SignFloat SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
; 	return PapyrusUtil.SignFloat(sign, value)
; endFunction

float[] function EmptyFloatArray() global
	; Debug.Trace("SEXLAB -- sslUtility.EmptyFloatArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateFloatArray(0)
endFunction

string[] function IncreaseString(int by, string[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.IncreaseString -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeStringArray(Array, (Array.Length + by))
endFunction
string[] function TrimStringArray(string[] Array, int len) global
	; Debug.Trace("SEXLAB -- sslUtility.TrimStringArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeStringArray(Array, len)
endFunction
string[] function PushString(string var, string[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.PushString -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.PushString(Array, var)
endFunction
string[] function MergeStringArray(string[] Push, string[] Array) global
	return PapyrusUtil.MergeStringArray(Array, Push)
	; Debug.Trace("-- sslUtility.PapyrusUtil SEXLAB -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
endFunction
string[] function ClearEmpty(string[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.ClearEmpty -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.RemoveString(Array, "")
endFunction
string[] function EmptyStringArray() global
	; Debug.Trace("SEXLAB -- sslUtility.EmptyStringArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateStringArray(0)
endFunction

bool[] function IncreaseBool(int by, bool[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.IncreaseBool -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeBoolArray(Array, (Array.Length + by))
endFunction

bool[] function TrimBoolArray(bool[] Array, int len) global
	; Debug.Trace("SEXLAB -- sslUtility.TrimBoolArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeBoolArray(Array, len)
endFunction

bool[] function PushBool(bool var, bool[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.PushBool -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.PushBool(Array, var)
endFunction

bool[] function MergeBoolArray(bool[] Push, bool[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.MergeBoolArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.MergeBoolArray(Array, Push)
endFunction

bool[] function EmptyBoolArray() global
	; Debug.Trace("SEXLAB -- sslUtility.EmptyBoolArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateBoolArray(0)
endFunction

form[] function IncreaseForm(int by, form[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.IncreaseForm -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.ResizeFormArray(Array, (Array.Length + by))
endFunction

form[] function PushForm(form var, form[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.PushForm -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.PushForm(Array, var)
endFunction

form[] function MergeFormArray(form[] Push, form[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.MergeFormArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.MergeFormArray(Array, Push)
endFunction

Form[] function ClearNone(Form[] Array) global
	; Debug.Trace("SEXLAB -- sslUtility.ClearNone -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return PapyrusUtil.RemoveForm(Array, none)
endFunction

form[] function EmptyFormArray() global
	; Debug.Trace("SEXLAB -- sslUtility.EmptyFormArray -- DEVELOPMENT DEPRECATION, MOTHER FUCKER - Check PapyrusUtil.psc alternative.")
	return Utility.CreateFormArray(0)
endFunction

;/-----------------------------------------------\;
;|	SexLab Object Contstructors
;\-----------------------------------------------/;

AniHumanScene[] function AnimationArray(int size) global
	if size < 8
		if size <= 0
			AniHumanScene[] Empty
			return Empty
		elseIf size == 1
			return new AniHumanScene[1]
		elseIf size == 2
			return new AniHumanScene[2]
		elseIf size == 3
			return new AniHumanScene[3]
		elseIf size == 4
			return new AniHumanScene[4]
		elseIf size == 5
			return new AniHumanScene[5]
		elseIf size == 6
			return new AniHumanScene[6]
		else
			return new AniHumanScene[7]
		endIf
	elseIf size < 16
		if size == 8
			return new AniHumanScene[8]
		elseIf size == 9
			return new AniHumanScene[9]
		elseIf size == 10
			return new AniHumanScene[10]
		elseIf size == 11
			return new AniHumanScene[11]
		elseIf size == 12
			return new AniHumanScene[12]
		elseIf size == 13
			return new AniHumanScene[13]
		elseIf size == 14
			return new AniHumanScene[14]
		else
			return new AniHumanScene[15]
		endIf
	elseIf size < 24
		if size == 16
			return new AniHumanScene[16]
		elseIf size == 17
			return new AniHumanScene[17]
		elseIf size == 18
			return new AniHumanScene[18]
		elseIf size == 19
			return new AniHumanScene[19]
		elseIf size == 20
			return new AniHumanScene[20]
		elseIf size == 21
			return new AniHumanScene[21]
		elseIf size == 22
			return new AniHumanScene[22]
		else
			return new AniHumanScene[23]
		endIf
	elseIf size < 32
		if size == 24
			return new AniHumanScene[24]
		elseIf size == 25
			return new AniHumanScene[25]
		elseIf size == 26
			return new AniHumanScene[26]
		elseIf size == 27
			return new AniHumanScene[27]
		elseIf size == 28
			return new AniHumanScene[28]
		elseIf size == 29
			return new AniHumanScene[29]
		elseIf size == 30
			return new AniHumanScene[30]
		else
			return new AniHumanScene[31]
		endIf
	elseIf size < 40
		if size == 32
			return new AniHumanScene[32]
		elseIf size == 33
			return new AniHumanScene[33]
		elseIf size == 34
			return new AniHumanScene[34]
		elseIf size == 35
			return new AniHumanScene[35]
		elseIf size == 36
			return new AniHumanScene[36]
		elseIf size == 37
			return new AniHumanScene[37]
		elseIf size == 38
			return new AniHumanScene[38]
		else
			return new AniHumanScene[39]
		endIf
	elseIf size < 48
		if size == 40
			return new AniHumanScene[40]
		elseIf size == 41
			return new AniHumanScene[41]
		elseIf size == 42
			return new AniHumanScene[42]
		elseIf size == 43
			return new AniHumanScene[43]
		elseIf size == 44
			return new AniHumanScene[44]
		elseIf size == 45
			return new AniHumanScene[45]
		elseIf size == 46
			return new AniHumanScene[46]
		else
			return new AniHumanScene[47]
		endIf
	elseIf size < 56
		if size == 48
			return new AniHumanScene[48]
		elseIf size == 49
			return new AniHumanScene[49]
		elseIf size == 50
			return new AniHumanScene[50]
		elseIf size == 51
			return new AniHumanScene[51]
		elseIf size == 52
			return new AniHumanScene[52]
		elseIf size == 53
			return new AniHumanScene[53]
		elseIf size == 54
			return new AniHumanScene[54]
		else
			return new AniHumanScene[55]
		endif
	elseIf size < 64
		if size == 56
			return new AniHumanScene[56]
		elseIf size == 57
			return new AniHumanScene[57]
		elseIf size == 58
			return new AniHumanScene[58]
		elseIf size == 59
			return new AniHumanScene[59]
		elseIf size == 60
			return new AniHumanScene[60]
		elseIf size == 61
			return new AniHumanScene[61]
		elseIf size == 62
			return new AniHumanScene[62]
		else
			return new AniHumanScene[63]
		endIf
	elseIf size < 72
		if size == 64
			return new AniHumanScene[64]
		elseIf size == 65
			return new AniHumanScene[65]
		elseIf size == 66
			return new AniHumanScene[66]
		elseIf size == 67
			return new AniHumanScene[67]
		elseIf size == 68
			return new AniHumanScene[68]
		elseIf size == 69
			return new AniHumanScene[69]
		elseIf size == 70
			return new AniHumanScene[70]
		else
			return new AniHumanScene[71]
		endif
	elseIf size < 80
		if size == 72
			return new AniHumanScene[72]
		elseIf size == 73
			return new AniHumanScene[73]
		elseIf size == 74
			return new AniHumanScene[74]
		elseIf size == 75
			return new AniHumanScene[75]
		elseIf size == 76
			return new AniHumanScene[76]
		elseIf size == 77
			return new AniHumanScene[77]
		elseIf size == 78
			return new AniHumanScene[78]
		else
			return new AniHumanScene[79]
		endIf
	elseIf size < 88
		if size == 80
			return new AniHumanScene[80]
		elseIf size == 81
			return new AniHumanScene[81]
		elseIf size == 82
			return new AniHumanScene[82]
		elseIf size == 83
			return new AniHumanScene[83]
		elseIf size == 84
			return new AniHumanScene[84]
		elseIf size == 85
			return new AniHumanScene[85]
		elseIf size == 86
			return new AniHumanScene[86]
		else
			return new AniHumanScene[87]
		endif
	elseIf size < 96
		if size == 88
			return new AniHumanScene[88]
		elseIf size == 89
			return new AniHumanScene[89]
		elseIf size == 90
			return new AniHumanScene[90]
		elseIf size == 91
			return new AniHumanScene[91]
		elseIf size == 92
			return new AniHumanScene[92]
		elseIf size == 93
			return new AniHumanScene[93]
		elseIf size == 94
			return new AniHumanScene[94]
		else
			return new AniHumanScene[95]
		endIf
	elseIf size < 104
		if size == 96
			return new AniHumanScene[96]
		elseIf size == 97
			return new AniHumanScene[97]
		elseIf size == 98
			return new AniHumanScene[98]
		elseIf size == 99
			return new AniHumanScene[99]
		elseIf size == 100
			return new AniHumanScene[100]
		elseIf size == 101
			return new AniHumanScene[101]
		elseIf size == 102
			return new AniHumanScene[102]
		else
			return new AniHumanScene[103]
		endif
	elseIf size < 112
		if size == 104
			return new AniHumanScene[104]
		elseIf size == 105
			return new AniHumanScene[105]
		elseIf size == 106
			return new AniHumanScene[106]
		elseIf size == 107
			return new AniHumanScene[107]
		elseIf size == 108
			return new AniHumanScene[108]
		elseIf size == 109
			return new AniHumanScene[109]
		elseIf size == 110
			return new AniHumanScene[110]
		else
			return new AniHumanScene[111]
		endif
	elseIf size < 120
		if size == 112
			return new AniHumanScene[112]
		elseIf size == 113
			return new AniHumanScene[113]
		elseIf size == 114
			return new AniHumanScene[114]
		elseIf size == 115
			return new AniHumanScene[115]
		elseIf size == 116
			return new AniHumanScene[116]
		elseIf size == 117
			return new AniHumanScene[117]
		elseIf size == 118
			return new AniHumanScene[118]
		else
			return new AniHumanScene[119]
		endif
	else
		if size == 120
			return new AniHumanScene[120]
		elseIf size == 121
			return new AniHumanScene[121]
		elseIf size == 122
			return new AniHumanScene[122]
		elseIf size == 123
			return new AniHumanScene[123]
		elseIf size == 124
			return new AniHumanScene[124]
		elseIf size == 125
			return new AniHumanScene[125]
		elseIf size == 126
			return new AniHumanScene[126]
		elseIf size == 127
			return new AniHumanScene[127]
		else
			return new AniHumanScene[128]
		endIf
	endIf
endFunction
; sslBaseVoice[] function VoiceArray(int size) global
; 	if size < 8
; 		if size <= 0
; 			sslBaseVoice[] Empty
; 			return Empty
; 		elseIf size == 1
; 			return new sslBaseVoice[1]
; 		elseIf size == 2
; 			return new sslBaseVoice[2]
; 		elseIf size == 3
; 			return new sslBaseVoice[3]
; 		elseIf size == 4
; 			return new sslBaseVoice[4]
; 		elseIf size == 5
; 			return new sslBaseVoice[5]
; 		elseIf size == 6
; 			return new sslBaseVoice[6]
; 		else
; 			return new sslBaseVoice[7]
; 		endIf
; 	elseIf size < 16
; 		if size == 8
; 			return new sslBaseVoice[8]
; 		elseIf size == 9
; 			return new sslBaseVoice[9]
; 		elseIf size == 10
; 			return new sslBaseVoice[10]
; 		elseIf size == 11
; 			return new sslBaseVoice[11]
; 		elseIf size == 12
; 			return new sslBaseVoice[12]
; 		elseIf size == 13
; 			return new sslBaseVoice[13]
; 		elseIf size == 14
; 			return new sslBaseVoice[14]
; 		else
; 			return new sslBaseVoice[15]
; 		endIf
; 	elseIf size < 24
; 		if size == 16
; 			return new sslBaseVoice[16]
; 		elseIf size == 17
; 			return new sslBaseVoice[17]
; 		elseIf size == 18
; 			return new sslBaseVoice[18]
; 		elseIf size == 19
; 			return new sslBaseVoice[19]
; 		elseIf size == 20
; 			return new sslBaseVoice[20]
; 		elseIf size == 21
; 			return new sslBaseVoice[21]
; 		elseIf size == 22
; 			return new sslBaseVoice[22]
; 		else
; 			return new sslBaseVoice[23]
; 		endIf
; 	elseIf size < 32
; 		if size == 24
; 			return new sslBaseVoice[24]
; 		elseIf size == 25
; 			return new sslBaseVoice[25]
; 		elseIf size == 26
; 			return new sslBaseVoice[26]
; 		elseIf size == 27
; 			return new sslBaseVoice[27]
; 		elseIf size == 28
; 			return new sslBaseVoice[28]
; 		elseIf size == 29
; 			return new sslBaseVoice[29]
; 		elseIf size == 30
; 			return new sslBaseVoice[30]
; 		else
; 			return new sslBaseVoice[31]
; 		endIf
; 	elseIf size < 40
; 		if size == 32
; 			return new sslBaseVoice[32]
; 		elseIf size == 33
; 			return new sslBaseVoice[33]
; 		elseIf size == 34
; 			return new sslBaseVoice[34]
; 		elseIf size == 35
; 			return new sslBaseVoice[35]
; 		elseIf size == 36
; 			return new sslBaseVoice[36]
; 		elseIf size == 37
; 			return new sslBaseVoice[37]
; 		elseIf size == 38
; 			return new sslBaseVoice[38]
; 		else
; 			return new sslBaseVoice[39]
; 		endIf
; 	elseIf size < 48
; 		if size == 40
; 			return new sslBaseVoice[40]
; 		elseIf size == 41
; 			return new sslBaseVoice[41]
; 		elseIf size == 42
; 			return new sslBaseVoice[42]
; 		elseIf size == 43
; 			return new sslBaseVoice[43]
; 		elseIf size == 44
; 			return new sslBaseVoice[44]
; 		elseIf size == 45
; 			return new sslBaseVoice[45]
; 		elseIf size == 46
; 			return new sslBaseVoice[46]
; 		else
; 			return new sslBaseVoice[47]
; 		endIf
; 	elseIf size < 56
; 		if size == 48
; 			return new sslBaseVoice[48]
; 		elseIf size == 49
; 			return new sslBaseVoice[49]
; 		elseIf size == 50
; 			return new sslBaseVoice[50]
; 		elseIf size == 51
; 			return new sslBaseVoice[51]
; 		elseIf size == 52
; 			return new sslBaseVoice[52]
; 		elseIf size == 53
; 			return new sslBaseVoice[53]
; 		elseIf size == 54
; 			return new sslBaseVoice[54]
; 		else
; 			return new sslBaseVoice[55]
; 		endif
; 	elseIf size < 64
; 		if size == 56
; 			return new sslBaseVoice[56]
; 		elseIf size == 57
; 			return new sslBaseVoice[57]
; 		elseIf size == 58
; 			return new sslBaseVoice[58]
; 		elseIf size == 59
; 			return new sslBaseVoice[59]
; 		elseIf size == 60
; 			return new sslBaseVoice[60]
; 		elseIf size == 61
; 			return new sslBaseVoice[61]
; 		elseIf size == 62
; 			return new sslBaseVoice[62]
; 		else
; 			return new sslBaseVoice[63]
; 		endIf
; 	elseIf size < 72
; 		if size == 64
; 			return new sslBaseVoice[64]
; 		elseIf size == 65
; 			return new sslBaseVoice[65]
; 		elseIf size == 66
; 			return new sslBaseVoice[66]
; 		elseIf size == 67
; 			return new sslBaseVoice[67]
; 		elseIf size == 68
; 			return new sslBaseVoice[68]
; 		elseIf size == 69
; 			return new sslBaseVoice[69]
; 		elseIf size == 70
; 			return new sslBaseVoice[70]
; 		else
; 			return new sslBaseVoice[71]
; 		endif
; 	elseIf size < 80
; 		if size == 72
; 			return new sslBaseVoice[72]
; 		elseIf size == 73
; 			return new sslBaseVoice[73]
; 		elseIf size == 74
; 			return new sslBaseVoice[74]
; 		elseIf size == 75
; 			return new sslBaseVoice[75]
; 		elseIf size == 76
; 			return new sslBaseVoice[76]
; 		elseIf size == 77
; 			return new sslBaseVoice[77]
; 		elseIf size == 78
; 			return new sslBaseVoice[78]
; 		else
; 			return new sslBaseVoice[79]
; 		endIf
; 	elseIf size < 88
; 		if size == 80
; 			return new sslBaseVoice[80]
; 		elseIf size == 81
; 			return new sslBaseVoice[81]
; 		elseIf size == 82
; 			return new sslBaseVoice[82]
; 		elseIf size == 83
; 			return new sslBaseVoice[83]
; 		elseIf size == 84
; 			return new sslBaseVoice[84]
; 		elseIf size == 85
; 			return new sslBaseVoice[85]
; 		elseIf size == 86
; 			return new sslBaseVoice[86]
; 		else
; 			return new sslBaseVoice[87]
; 		endif
; 	elseIf size < 96
; 		if size == 88
; 			return new sslBaseVoice[88]
; 		elseIf size == 89
; 			return new sslBaseVoice[89]
; 		elseIf size == 90
; 			return new sslBaseVoice[90]
; 		elseIf size == 91
; 			return new sslBaseVoice[91]
; 		elseIf size == 92
; 			return new sslBaseVoice[92]
; 		elseIf size == 93
; 			return new sslBaseVoice[93]
; 		elseIf size == 94
; 			return new sslBaseVoice[94]
; 		else
; 			return new sslBaseVoice[95]
; 		endIf
; 	elseIf size < 104
; 		if size == 96
; 			return new sslBaseVoice[96]
; 		elseIf size == 97
; 			return new sslBaseVoice[97]
; 		elseIf size == 98
; 			return new sslBaseVoice[98]
; 		elseIf size == 99
; 			return new sslBaseVoice[99]
; 		elseIf size == 100
; 			return new sslBaseVoice[100]
; 		elseIf size == 101
; 			return new sslBaseVoice[101]
; 		elseIf size == 102
; 			return new sslBaseVoice[102]
; 		else
; 			return new sslBaseVoice[103]
; 		endif
; 	elseIf size < 112
; 		if size == 104
; 			return new sslBaseVoice[104]
; 		elseIf size == 105
; 			return new sslBaseVoice[105]
; 		elseIf size == 106
; 			return new sslBaseVoice[106]
; 		elseIf size == 107
; 			return new sslBaseVoice[107]
; 		elseIf size == 108
; 			return new sslBaseVoice[108]
; 		elseIf size == 109
; 			return new sslBaseVoice[109]
; 		elseIf size == 110
; 			return new sslBaseVoice[110]
; 		else
; 			return new sslBaseVoice[111]
; 		endif
; 	elseIf size < 120
; 		if size == 112
; 			return new sslBaseVoice[112]
; 		elseIf size == 113
; 			return new sslBaseVoice[113]
; 		elseIf size == 114
; 			return new sslBaseVoice[114]
; 		elseIf size == 115
; 			return new sslBaseVoice[115]
; 		elseIf size == 116
; 			return new sslBaseVoice[116]
; 		elseIf size == 117
; 			return new sslBaseVoice[117]
; 		elseIf size == 118
; 			return new sslBaseVoice[118]
; 		else
; 			return new sslBaseVoice[119]
; 		endif
; 	else
; 		if size == 120
; 			return new sslBaseVoice[120]
; 		elseIf size == 121
; 			return new sslBaseVoice[121]
; 		elseIf size == 122
; 			return new sslBaseVoice[122]
; 		elseIf size == 123
; 			return new sslBaseVoice[123]
; 		elseIf size == 124
; 			return new sslBaseVoice[124]
; 		elseIf size == 125
; 			return new sslBaseVoice[125]
; 		elseIf size == 126
; 			return new sslBaseVoice[126]
; 		elseIf size == 127
; 			return new sslBaseVoice[127]
; 		else
; 			return new sslBaseVoice[128]
; 		endIf
; 	endIf
; endFunction

; sslBaseObject[] function BaseObjectArray(int size) global
; 	if size < 8
; 		if size <= 0
; 			sslBaseObject[] Empty
; 			return Empty
; 		elseIf size == 1
; 			return new sslBaseObject[1]
; 		elseIf size == 2
; 			return new sslBaseObject[2]
; 		elseIf size == 3
; 			return new sslBaseObject[3]
; 		elseIf size == 4
; 			return new sslBaseObject[4]
; 		elseIf size == 5
; 			return new sslBaseObject[5]
; 		elseIf size == 6
; 			return new sslBaseObject[6]
; 		else
; 			return new sslBaseObject[7]
; 		endIf
; 	elseIf size < 16
; 		if size == 8
; 			return new sslBaseObject[8]
; 		elseIf size == 9
; 			return new sslBaseObject[9]
; 		elseIf size == 10
; 			return new sslBaseObject[10]
; 		elseIf size == 11
; 			return new sslBaseObject[11]
; 		elseIf size == 12
; 			return new sslBaseObject[12]
; 		elseIf size == 13
; 			return new sslBaseObject[13]
; 		elseIf size == 14
; 			return new sslBaseObject[14]
; 		else
; 			return new sslBaseObject[15]
; 		endIf
; 	elseIf size < 24
; 		if size == 16
; 			return new sslBaseObject[16]
; 		elseIf size == 17
; 			return new sslBaseObject[17]
; 		elseIf size == 18
; 			return new sslBaseObject[18]
; 		elseIf size == 19
; 			return new sslBaseObject[19]
; 		elseIf size == 20
; 			return new sslBaseObject[20]
; 		elseIf size == 21
; 			return new sslBaseObject[21]
; 		elseIf size == 22
; 			return new sslBaseObject[22]
; 		else
; 			return new sslBaseObject[23]
; 		endIf
; 	elseIf size < 32
; 		if size == 24
; 			return new sslBaseObject[24]
; 		elseIf size == 25
; 			return new sslBaseObject[25]
; 		elseIf size == 26
; 			return new sslBaseObject[26]
; 		elseIf size == 27
; 			return new sslBaseObject[27]
; 		elseIf size == 28
; 			return new sslBaseObject[28]
; 		elseIf size == 29
; 			return new sslBaseObject[29]
; 		elseIf size == 30
; 			return new sslBaseObject[30]
; 		else
; 			return new sslBaseObject[31]
; 		endIf
; 	elseIf size < 40
; 		if size == 32
; 			return new sslBaseObject[32]
; 		elseIf size == 33
; 			return new sslBaseObject[33]
; 		elseIf size == 34
; 			return new sslBaseObject[34]
; 		elseIf size == 35
; 			return new sslBaseObject[35]
; 		elseIf size == 36
; 			return new sslBaseObject[36]
; 		elseIf size == 37
; 			return new sslBaseObject[37]
; 		elseIf size == 38
; 			return new sslBaseObject[38]
; 		else
; 			return new sslBaseObject[39]
; 		endIf
; 	elseIf size < 48
; 		if size == 40
; 			return new sslBaseObject[40]
; 		elseIf size == 41
; 			return new sslBaseObject[41]
; 		elseIf size == 42
; 			return new sslBaseObject[42]
; 		elseIf size == 43
; 			return new sslBaseObject[43]
; 		elseIf size == 44
; 			return new sslBaseObject[44]
; 		elseIf size == 45
; 			return new sslBaseObject[45]
; 		elseIf size == 46
; 			return new sslBaseObject[46]
; 		else
; 			return new sslBaseObject[47]
; 		endIf
; 	elseIf size < 56
; 		if size == 48
; 			return new sslBaseObject[48]
; 		elseIf size == 49
; 			return new sslBaseObject[49]
; 		elseIf size == 50
; 			return new sslBaseObject[50]
; 		elseIf size == 51
; 			return new sslBaseObject[51]
; 		elseIf size == 52
; 			return new sslBaseObject[52]
; 		elseIf size == 53
; 			return new sslBaseObject[53]
; 		elseIf size == 54
; 			return new sslBaseObject[54]
; 		else
; 			return new sslBaseObject[55]
; 		endif
; 	elseIf size < 64
; 		if size == 56
; 			return new sslBaseObject[56]
; 		elseIf size == 57
; 			return new sslBaseObject[57]
; 		elseIf size == 58
; 			return new sslBaseObject[58]
; 		elseIf size == 59
; 			return new sslBaseObject[59]
; 		elseIf size == 60
; 			return new sslBaseObject[60]
; 		elseIf size == 61
; 			return new sslBaseObject[61]
; 		elseIf size == 62
; 			return new sslBaseObject[62]
; 		else
; 			return new sslBaseObject[63]
; 		endIf
; 	elseIf size < 72
; 		if size == 64
; 			return new sslBaseObject[64]
; 		elseIf size == 65
; 			return new sslBaseObject[65]
; 		elseIf size == 66
; 			return new sslBaseObject[66]
; 		elseIf size == 67
; 			return new sslBaseObject[67]
; 		elseIf size == 68
; 			return new sslBaseObject[68]
; 		elseIf size == 69
; 			return new sslBaseObject[69]
; 		elseIf size == 70
; 			return new sslBaseObject[70]
; 		else
; 			return new sslBaseObject[71]
; 		endif
; 	elseIf size < 80
; 		if size == 72
; 			return new sslBaseObject[72]
; 		elseIf size == 73
; 			return new sslBaseObject[73]
; 		elseIf size == 74
; 			return new sslBaseObject[74]
; 		elseIf size == 75
; 			return new sslBaseObject[75]
; 		elseIf size == 76
; 			return new sslBaseObject[76]
; 		elseIf size == 77
; 			return new sslBaseObject[77]
; 		elseIf size == 78
; 			return new sslBaseObject[78]
; 		else
; 			return new sslBaseObject[79]
; 		endIf
; 	elseIf size < 88
; 		if size == 80
; 			return new sslBaseObject[80]
; 		elseIf size == 81
; 			return new sslBaseObject[81]
; 		elseIf size == 82
; 			return new sslBaseObject[82]
; 		elseIf size == 83
; 			return new sslBaseObject[83]
; 		elseIf size == 84
; 			return new sslBaseObject[84]
; 		elseIf size == 85
; 			return new sslBaseObject[85]
; 		elseIf size == 86
; 			return new sslBaseObject[86]
; 		else
; 			return new sslBaseObject[87]
; 		endif
; 	elseIf size < 96
; 		if size == 88
; 			return new sslBaseObject[88]
; 		elseIf size == 89
; 			return new sslBaseObject[89]
; 		elseIf size == 90
; 			return new sslBaseObject[90]
; 		elseIf size == 91
; 			return new sslBaseObject[91]
; 		elseIf size == 92
; 			return new sslBaseObject[92]
; 		elseIf size == 93
; 			return new sslBaseObject[93]
; 		elseIf size == 94
; 			return new sslBaseObject[94]
; 		else
; 			return new sslBaseObject[95]
; 		endIf
; 	elseIf size < 104
; 		if size == 96
; 			return new sslBaseObject[96]
; 		elseIf size == 97
; 			return new sslBaseObject[97]
; 		elseIf size == 98
; 			return new sslBaseObject[98]
; 		elseIf size == 99
; 			return new sslBaseObject[99]
; 		elseIf size == 100
; 			return new sslBaseObject[100]
; 		elseIf size == 101
; 			return new sslBaseObject[101]
; 		elseIf size == 102
; 			return new sslBaseObject[102]
; 		else
; 			return new sslBaseObject[103]
; 		endif
; 	elseIf size < 112
; 		if size == 104
; 			return new sslBaseObject[104]
; 		elseIf size == 105
; 			return new sslBaseObject[105]
; 		elseIf size == 106
; 			return new sslBaseObject[106]
; 		elseIf size == 107
; 			return new sslBaseObject[107]
; 		elseIf size == 108
; 			return new sslBaseObject[108]
; 		elseIf size == 109
; 			return new sslBaseObject[109]
; 		elseIf size == 110
; 			return new sslBaseObject[110]
; 		else
; 			return new sslBaseObject[111]
; 		endif
; 	elseIf size < 120
; 		if size == 112
; 			return new sslBaseObject[112]
; 		elseIf size == 113
; 			return new sslBaseObject[113]
; 		elseIf size == 114
; 			return new sslBaseObject[114]
; 		elseIf size == 115
; 			return new sslBaseObject[115]
; 		elseIf size == 116
; 			return new sslBaseObject[116]
; 		elseIf size == 117
; 			return new sslBaseObject[117]
; 		elseIf size == 118
; 			return new sslBaseObject[118]
; 		else
; 			return new sslBaseObject[119]
; 		endif
; 	else
; 		if size == 120
; 			return new sslBaseObject[120]
; 		elseIf size == 121
; 			return new sslBaseObject[121]
; 		elseIf size == 122
; 			return new sslBaseObject[122]
; 		elseIf size == 123
; 			return new sslBaseObject[123]
; 		elseIf size == 124
; 			return new sslBaseObject[124]
; 		elseIf size == 125
; 			return new sslBaseObject[125]
; 		elseIf size == 126
; 			return new sslBaseObject[126]
; 		elseIf size == 127
; 			return new sslBaseObject[127]
; 		else
; 			return new sslBaseObject[128]
; 		endIf
; 	endIf
; endFunction


; ;/-----------------------------------------------\;
; ;|	Animation Utility Functions
; ;\-----------------------------------------------/;

; function AnimationCopyTo(AniHumanScene[] SourceArray, AniHumanScene[] ToArray, int StartIndex = 0, int EndIndex = -1, bool SkipEmpty = false) global native
; int function CountAnimation(AniHumanScene[] Values, AniHumanScene EqualTo = none) global native

; AniHumanScene[] function ResizeAnimationArray(AniHumanScene[] Array, int ToSize) global
; 	if ToSize == Array.Length
; 		return Array
; 	elseIf ToSize < 1
; 		return AnimationArray(0)
; 	elseIf ToSize > 128
; 		ToSize = 128
; 	endIf
; 	AniHumanScene[] Output = AnimationArray(ToSize)
; 	AnimationCopyTo(Array, Output)
; 	return Output
; endFunction

; AniHumanScene[] function PushAnimation(AniHumanScene[] Array, AniHumanScene var) global
; 	int end = Array.Length
; 	if end >= 128
; 		return Array
; 	endIf
; 	AniHumanScene[] Output = AnimationArray(end+1)
; 	AnimationCopyTo(Array, Output)
; 	Output[end] = var
; 	return Output
; endFunction

; AniHumanScene[] function MergeAnimationArray(AniHumanScene[] Output, AniHumanScene[] Append) global
; 	int OutputLength = Output.length
; 	int AppendLength = Append.Length
; 	if OutputLength == 0 && AppendLength == 0
; 		return AnimationArray(0)
; 	elseIf OutputLength == 0 && AppendLength > 0
; 		return Append
; 	elseIf AppendLength == 0 && OutputLength > 0
; 		return Output
; 	endIf
; 	Output = ResizeAnimationArray(Output, (OutputLength+AppendLength))
; 	AnimationCopyTo(Append, Output, OutputLength)
; 	return Output
; endFunction

; AniHumanScene[] function ClearNoneAnimation(AniHumanScene[] Array) global
; 	int Count = (Array.Length - CountAnimation(Array, none))
; 	if Count < 1
; 		return AnimationArray(0)
; 	elseif Count == Array.Length
; 		return Array
; 	endIf
; 	AniHumanScene[] Output = AnimationArray(Count)
; 	AnimationCopyTo(Array, Output, 0, -1, true)
; 	return Output
; endFunction

; AniHumanScene[] function IncreaseAnimation(int by, AniHumanScene[] Array) global
; 	return ResizeAnimationArray(Array, (Array.Length + by))
; endFunction

; AniHumanScene[] function EmptyAnimationArray() global
; 	return AnimationArray(0)
; endFunction


; ;/-----------------------------------------------\;
; ;|	Expression Utility Functions
; ;\-----------------------------------------------/;

; function ExpressionCopyTo(sslBaseExpression[] SourceArray, sslBaseExpression[] ToArray, int StartIndex = 0, int EndIndex = -1, bool SkipEmpty = false) global native
; int function CountExpression(sslBaseExpression[] Values, sslBaseExpression EqualTo = none) global native

; sslBaseExpression[] function ResizeExpressionArray(sslBaseExpression[] Array, int ToSize) global
; 	if ToSize == Array.Length
; 		return Array
; 	elseIf ToSize < 1
; 		return ExpressionArray(0)
; 	elseIf ToSize > 128
; 		ToSize = 128
; 	endIf
; 	sslBaseExpression[] Output = ExpressionArray(ToSize)
; 	ExpressionCopyTo(Array, Output)
; 	return Output
; endFunction

; sslBaseExpression[] function PushExpression(sslBaseExpression[] Array, sslBaseExpression var) global
; 	int end = Array.Length
; 	if end >= 128
; 		return Array
; 	endIf
; 	sslBaseExpression[] Output = ExpressionArray(end+1)
; 	ExpressionCopyTo(Array, Output)
; 	Output[end] = var
; 	return Output
; endFunction

; sslBaseExpression[] function MergeExpressionArray(sslBaseExpression[] Output, sslBaseExpression[] Append) global
; 	int OutputLength = Output.length
; 	int AppendLength = Append.Length
; 	if OutputLength == 0 && AppendLength == 0
; 		return ExpressionArray(0)
; 	elseIf OutputLength == 0 && AppendLength > 0
; 		return Append
; 	elseIf AppendLength == 0 && OutputLength > 0
; 		return Output
; 	endIf
; 	Output = ResizeExpressionArray(Output, (OutputLength+AppendLength))
; 	ExpressionCopyTo(Append, Output, OutputLength)
; 	return Output
; endFunction

; sslBaseExpression[] function ClearNoneExpression(sslBaseExpression[] Array) global
; 	int Count = (Array.Length - CountExpression(Array, none))
; 	if Count < 1
; 		return ExpressionArray(0)
; 	elseif Count == Array.Length
; 		return Array
; 	endIf
; 	sslBaseExpression[] Output = ExpressionArray(Count)
; 	ExpressionCopyTo(Array, Output, 0, -1, true)
; 	return Output
; endFunction

; sslBaseExpression[] function IncreaseExpression(sslBaseExpression[] Array, int by) global
; 	return ResizeExpressionArray(Array, (Array.Length + by))
; endFunction

; sslBaseExpression[] function EmptyExpressionArray() global
; 	return ExpressionArray(0)
; endFunction

; ;/-----------------------------------------------\;
; ;|	Voice Utility Functions
; ;\-----------------------------------------------/;

; function VoiceCopyTo(sslBaseVoice[] SourceArray, sslBaseVoice[] ToArray, int StartIndex = 0, int EndIndex = -1, bool SkipEmpty = false) global native
; int function CountVoice(sslBaseVoice[] Values, sslBaseVoice EqualTo = none) global native

; sslBaseVoice[] function ResizeVoiceArray(sslBaseVoice[] Array, int ToSize) global
; 	if ToSize == Array.Length
; 		return Array
; 	elseIf ToSize < 1
; 		return VoiceArray(0)
; 	elseIf ToSize > 128
; 		ToSize = 128
; 	endIf
; 	sslBaseVoice[] Output = VoiceArray(ToSize)
; 	VoiceCopyTo(Array, Output)
; 	return Output
; endFunction

; sslBaseVoice[] function PushVoice(sslBaseVoice[] Array, sslBaseVoice var) global
; 	int end = Array.Length
; 	if end >= 128
; 		return Array
; 	endIf
; 	sslBaseVoice[] Output = VoiceArray(end+1)
; 	VoiceCopyTo(Array, Output)
; 	Output[end] = var
; 	return Output
; endFunction

; sslBaseVoice[] function MergeVoiceArray(sslBaseVoice[] Output, sslBaseVoice[] Append) global
; 	int OutputLength = Output.length
; 	int AppendLength = Append.Length
; 	if OutputLength == 0 && AppendLength == 0
; 		return VoiceArray(0)
; 	elseIf OutputLength == 0 && AppendLength > 0
; 		return Append
; 	elseIf AppendLength == 0 && OutputLength > 0
; 		return Output
; 	endIf
; 	Output = ResizeVoiceArray(Output, (OutputLength+AppendLength))
; 	VoiceCopyTo(Append, Output, OutputLength)
; 	return Output
; endFunction

; sslBaseVoice[] function ClearNoneVoice(sslBaseVoice[] Array) global
; 	int Count = (Array.Length - CountVoice(Array, none))
; 	if Count < 1
; 		return VoiceArray(0)
; 	elseif Count == Array.Length
; 		return Array
; 	endIf
; 	sslBaseVoice[] Output = VoiceArray(Count)
; 	VoiceCopyTo(Array, Output, 0, -1, true)
; 	return Output
; endFunction

; sslBaseVoice[] function IncreaseVoice(sslBaseVoice[] Array, int by) global
; 	return ResizeVoiceArray(Array, (Array.Length + by))
; endFunction

; sslBaseVoice[] function EmptyVoiceArray() global
; 	return VoiceArray(0)
; endFunction

; ;/-----------------------------------------------\;
; ;|	Voice Utility Functions
; ;\-----------------------------------------------/;

; function BaseObjectCopyTo(sslBaseObject[] SourceArray, sslBaseObject[] ToArray, int StartIndex = 0, int EndIndex = -1, bool SkipEmpty = false) global native
; int function CountBaseObject(sslBaseObject[] Values, sslBaseObject EqualTo = none) global native

; sslBaseObject[] function ResizeBaseObject(sslBaseObject[] Array, int ToSize) global
; 	if ToSize == Array.Length
; 		return Array
; 	elseIf ToSize < 1
; 		return BaseObjectArray(0)
; 	elseIf ToSize > 128
; 		ToSize = 128
; 	endIf
; 	sslBaseObject[] Output = BaseObjectArray(ToSize)
; 	BaseObjectCopyTo(Array, Output)
; 	return Output
; endFunction

; sslBaseObject[] function PushBaseObject(sslBaseObject[] Array, sslBaseObject var) global
; 	int end = Array.Length
; 	if end >= 128
; 		return Array
; 	endIf
; 	sslBaseObject[] Output = BaseObjectArray(end+1)
; 	BaseObjectCopyTo(Array, Output)
; 	Output[end] = var
; 	return Output
; endFunction

; sslBaseObject[] function MergeBaseObject(sslBaseObject[] Output, sslBaseObject[] Append) global
; 	int OutputLength = Output.length
; 	int AppendLength = Append.Length
; 	if OutputLength == 0 && AppendLength == 0
; 		return BaseObjectArray(0)
; 	elseIf OutputLength == 0 && AppendLength > 0
; 		return Append
; 	elseIf AppendLength == 0 && OutputLength > 0
; 		return Output
; 	endIf
; 	Output = ResizeBaseObject(Output, (OutputLength+AppendLength))
; 	BaseObjectCopyTo(Append, Output, OutputLength)
; 	return Output
; endFunction

; sslBaseObject[] function ClearNoneBaseObject(sslBaseObject[] Array) global
; 	int Count = (Array.Length - CountBaseObject(Array, none))
; 	if Count < 1
; 		return BaseObjectArray(0)
; 	elseif Count == Array.Length
; 		return Array
; 	endIf
; 	sslBaseObject[] Output = BaseObjectArray(Count)
; 	BaseObjectCopyTo(Array, Output, 0, -1, true)
; 	return Output
; endFunction

; sslBaseObject[] function IncreaseBaseObject(sslBaseObject[] Array, int by) global
; 	return ResizeBaseObject(Array, (Array.Length + by))
; endFunction

; sslBaseObject[] function EmptyBaseObject() global
; 	return BaseObjectArray(0)
; endFunction
