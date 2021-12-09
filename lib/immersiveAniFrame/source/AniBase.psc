scriptname AniBase extends ReferenceAlias hidden

int property SlotID auto hidden
string property Name auto hidden
string property Registry auto hidden
bool property Enabled auto hidden
bool property Registered hidden
	bool function get()
		return Registry != "" && Storage == none
	endFunction
endProperty

; ------------------------------------------------------- ;
; --- Tagging System                                  --- ;
; ------------------------------------------------------- ;
string[] Tags
string[] function GetTags()
	return PapyrusUtil.ClearEmpty(Tags)
endFunction

bool function HasTag(string _Tag)
	return _Tag != "" && Tags.Find(_Tag) != -1
endFunction

bool function AddTag(string _Tag)
	if _Tag != "" && Tags.Find(_Tag) == -1
		int i = Tags.Find("")
		if i != -1
			Tags[i] = _Tag
		else
			Tags = PapyrusUtil.PushString(Tags, _Tag)
		endIf
		return true
	endIf
	return false
endFunction

bool function RemoveTag(string _Tag)
	if _Tag != "" && Tags.Find(_Tag) != -1
		Tags = PapyrusUtil.RemoveString(Tags, _Tag)
		return true
	endIf
	return false
endFunction

function AddTags(string[] _Tags)
	int i = _Tags.Length
	while i
		i -= 1
		AddTag(_Tags[i])
	endWhile
endFunction

function SetTags(string _Tags)
	AddTags(PapyrusUtil.StringSplit(_Tags))
endFunction

bool function ParseTags(string[] _Tags, bool RequireAll = true)
	return (RequireAll && HasAllTag(_Tags)) || (!RequireAll && HasOneTag(_Tags))
endFunction

bool function TagSearch(string[] TagList, string[] Suppress, bool RequireAll)
	return ((RequireAll && HasAllTag(TagList)) || (!RequireAll && HasOneTag(TagList))) \ 
		&& (!Suppress || !HasOneTag(Suppress))
endFunction

bool function HasOneTag(string[] _Tags)
	int i = _Tags.Length
	while i
		i -= 1
		if _Tags[i] != "" && Tags.Find(_Tags[i]) != -1
			return true
		endIf
	endWhile
	return false
endFunction

bool function HasAllTag(string[] _Tags)
	int i = _Tags.Length
	while i
		i -= 1
		if _Tags[i] != "" && Tags.Find(_Tags[i]) == -1
			return false
		endIf
	endWhile
	return true
endFunction

; ------------------------------------------------------- ;
; --- Phantom Slots                                   --- ;
; ------------------------------------------------------- ;
Form property Storage auto hidden
bool property Ephemeral hidden
	bool function get()
		return Storage != none
	endFunction
endProperty

function MakeEphemeral(string _Token, Form _OwnerForm)
	Initialize()
	Enabled   = true
	Registry  = _Token
	Storage   = _OwnerForm	
endFunction

; ------------------------------------------------------- ;
; --- System Use                                      --- ;
; ------------------------------------------------------- ;
string function Key(string type = "")
	return Registry+"."+type
endFunction

function Log(string Log, string Type = "BaseObject")
	Log = Type+" "+Registry+" - "+Log
	MiscUtil.PrintConsole(Log)	
endFunction

bool bSaved = false
bool property Saved hidden
	bool function get()
		return bSaved
	endFunction
endProperty
function Save(int id = -1)
	bSaved = true
	SlotID = id
	; Trim tags
	int i = Tags.Find("")
	if i != -1
		Tags = Utility.ResizeStringArray(Tags, (i + 1))
	endIf
endFunction

function Initialize()
	Name     = ""
	Registry = ""
	SlotID   = -1
	Enabled  = false
	bSaved   = false
	Storage  = none
	Tags     = new string[20]
endFunction
