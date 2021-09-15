scriptname sslBaseVoice extends sslBaseObject

; import MfgConsoleFunc ; OLDRIM
; TODO: switch back to mfgconsolefunc: https://www.nexusmods.com/skyrimspecialedition/mods/11669?tab=description
;  - NVM, not updated for current SKSE64, and buggy accoring to comments.
;  - Maybe https://www.nexusmods.com/skyrimspecialedition/mods/12919

Sound property Mild auto
Sound property Medium auto
Sound property Hot auto
Sound property Orgasm auto
Sound property Afraid auto
Sound property Fear auto
Sound property Pain auto
Sound property Joy auto
Sound property Happy auto
Sound property Yell auto
Sound property Giggle auto
Sound property Enjoy auto
Sound property Please auto

Topic property LipSync auto hidden

string[] property RaceKeys auto hidden

int property Gender auto hidden
bool property Male hidden
	bool function get()
		return (Gender == 0 || Gender == -1)
	endFunction
endProperty
bool property Female hidden
	bool function get()
		return (Gender == 1 || Gender == -1)
	endFunction
endProperty
bool property Creature hidden
	bool function get()
		return RaceKeys && RaceKeys.Length > 0
	endFunction
endProperty

int function PlayMoanSound(Actor ActorRef, int Strength = 30, bool UseLipSync = false, float volume = 1.0)
	Sound SoundRef = GetMoanSound(Strength)	
	int soundId = -999
	if SoundRef
		if SoundRef == Hot
			volume += 0.1
		endif

		soundId = SoundRef.Play(ActorRef)
		Sound.SetInstanceVolume(soundId, volume)
	endIf
	return soundId
endFunction

function Moan(Actor ActorRef, int Strength = 30, bool IsVictim = false, float volume = 0.5)
	PlayMoanSound(ActorRef, Strength, Config.UseLipSync, volume)
endFunction

Sound function GetMoanSound(int Strength)
	if Strength <= 30
		return Mild
	elseif Strength <= 75
		return Medium
	elseIf Strength <= 100
		return Hot
	endIf
endFunction

Sound function GetAfraidSound()
	return Afraid
endFunction

Sound function GetFearSound()
	return Fear
endFunction

Sound function GetPainSound()
	return Pain
endFunction

Sound function GetJoySound()
	return Joy
endFunction

Sound function GetHappySound()
	return Happy
endFunction

Sound function GetYellSound()
	return Yell
endFunction

Sound function GetGiggleSound()
	return Giggle
endFunction

Sound function GetEnjoySound()
	return Enjoy
endFunction

Sound function GetPleaseSound()
	return Please
endFunction

Sound function GetOrgasmSound()
	return Orgasm
endFunction

function SetRaceKeys(string RaceList)
	string[] KeyList = PapyrusUtil.StringSplit(RaceList)
	int i = KeyList.Length
	while i
		i -= 1
		if KeyList[i]
			AddRaceKey(KeyList[i])
		endIf
	endWhile
endFunction

function AddRaceKey(string RaceKey)
	if !RaceKey
		; Do nothing
	elseIf !RaceKeys || !RaceKeys.Length
		RaceKeys = new string[1]
		RaceKeys[0] = RaceKey
	elseIf RaceKeys.Find(RaceKey) == -1
		RaceKeys = PapyrusUtil.PushString(RaceKeys, RaceKey)
	endIf
endFunction

bool function HasRaceKey(string RaceKey)
	return RaceKey && RaceKeys && RaceKeys.Find(RaceKey) != -1
endFunction

bool function HasRaceKeyMatch(string[] RaceList)
	if RaceList && RaceKeys
		int i = RaceList.Length
		while i
			i -= 1
			if RaceKeys.Find(RaceList[i]) != -1
				return true
			endIf
		endWhile
	endIf
	return false
endFunction

function Save(int id = -1)
	AddTagConditional("Male",   (Gender == 0 || Gender == -1))
	AddTagConditional("Female", (Gender == 1 || Gender == -1))
	AddTagConditional("Creature", (Gender == 2 || Gender == 3))
	Log(Name, "Voices["+id+"]")
	parent.Save(id)
endFunction

function Initialize()
	Gender  = -1

	Orgasm  = none
	Afraid 	= none
	Fear 	= none
	Pain 	= none
	Joy 	= none
	Happy 	= none
	Yell 	= none
	Giggle  = none
	Enjoy   = none
	Please  = none	
	Mild    = none
	Medium  = none
	Hot     = none
	Orgasm  = none
	RaceKeys = Utility.CreateStringArray(0)
	parent.Initialize()
	LipSync = Config.LipSync
endFunction

