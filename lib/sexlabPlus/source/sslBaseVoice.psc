scriptname sslBaseVoice extends sslBaseObject

Sound property Mild auto
Sound property Medium auto
Sound property Hot auto

Sound property Feel1 auto
Sound property Feel2 auto
Sound property Feel3 auto

Sound property Enjoy1 auto
Sound property Enjoy2 auto
Sound property Enjoy3 auto

Sound property Happy1 auto
Sound property Happy2 auto
Sound property Happy3 auto

Sound property Horror1 auto
Sound property Horror2 auto
Sound property Horror3 auto

Sound property Pain1 auto
Sound property Pain2 auto
Sound property Pain3 auto

Sound property Hate1 auto
Sound property Hate2 auto
Sound property Hate3 auto

Sound property Giggle auto
Sound property Threaten auto

Sound property Orgasm auto
Sound property Moan auto

Sound property Kiss auto
Sound property Lick auto
Sound property SuckSlow auto
Sound property SuckFast auto
Sound property Deep auto

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

int function PlayMoan(Actor ActorRef, int Strength = 30, bool IsVictim = false, bool UseLipSync = false, float volume = 1.0)
	int soundId = -999
	if !ActorRef
		return soundId
	endIf
	
	Sound SoundRef = GetSound(Strength, IsVictim)
	if SoundRef
		soundId = SoundRef.Play(ActorRef)
	endIf
	return soundId
endFunction

function Moan(Actor ActorRef, int Strength = 30, bool IsVictim = false)
	PlayMoan(ActorRef, Strength, Isvictim, Config.UseLipSync)
endFunction

function MoanNoWait(Actor ActorRef, int Strength = 30, bool IsVictim = false, float Volume = 1.0)
	if !ActorRef
		return
	endIf
	
	if Volume > 0.0
		Sound SoundRef = GetSound(Strength, IsVictim)
		if SoundRef
			LipSync(ActorRef, Strength)
			Sound.SetInstanceVolume(SoundRef.Play(ActorRef), Volume)
		endIf
	endIf
endFunction

Sound function GetEnjoy1Sound()
	return Enjoy1
endFunction

Sound function GetEnjoy2Sound()
	return Enjoy2
endFunction

Sound function GetEnjoy3Sound()
	return Enjoy3
endFunction

Sound function GetHappy1Sound()
	return Happy1
endFunction

Sound function GetHappy2Sound()
	return Happy2
endFunction

Sound function GetHappy3Sound()
	return Happy3
endFunction

Sound function GetHorror1Sound()
	return Horror1
endFunction

Sound function GetHorror2Sound()
	return Horror2
endFunction

Sound function GetHorror3Sound()
	return Horror3
endFunction

Sound function GetPain1Sound()
	return Pain1
endFunction

Sound function GetPain2Sound()
	return Pain2
endFunction

Sound function GetPain3Sound()
	return Pain3
endFunction

Sound function GetHate1Sound()
	return Hate1
endFunction

Sound function GetHate2Sound()
	return Hate2
endFunction

Sound function GetHate3Sound()
	return Hate3
endFunction

Sound function GetFeel1Sound()
	return Feel1
endFunction

Sound function GetFeel2Sound()
	return Feel2
endFunction

Sound function GetFeel3Sound()
	return Feel3
endFunction

Sound function GetGiggleSound()
	return Giggle
endFunction

Sound function GetThreatenSound()
	return Threaten
endFunction

Sound function GetMoanSound()
	return Moan
endFunction

Sound function GetOrgasmSound()
	return Orgasm
endFunction

Sound function GetKissSound()
	return Kiss
endFunction

Sound function GetLickSound()
	return Lick
endFunction

Sound function GetSuckSlowSound()
	return SuckSlow
endFunction

Sound function GetSuckFastSound()
	return SuckFast
endFunction

Sound function GetDeepSound()
	return Deep
endFunction

Sound function GetSound(int Strength, bool IsVictim = false)
	if Strength > 75 && Hot
		return Hot
	elseIf IsVictim && Medium
		return Medium
	endIf
	return Mild
endFunction

function LipSync(Actor ActorRef, int Strength, bool ForceUse = false)
	if !ActorRef
		return
	endIf
	
	if (ForceUse || Config.UseLipSync) && Game.GetCameraState() != 3
		ActorRef.Say(LipSync)
	endIf
endFunction

bool function CheckGender(int CheckGender)
	return Gender == CheckGender || (Gender == -1 && (CheckGender == 1 || CheckGender == 0)) || (CheckGender >= 2 && Gender >= 2)
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
	Gender = -1
	Mild   = none
	Medium = none
	Hot    = none

	Enjoy1 = none
	Enjoy2 = none
	Enjoy3 = none

	Feel1  = none
	Feel2  = none
	Feel3  = none

	Happy1 = none
	Happy2 = none
	Happy3 = none

	Horror1 = none
	Horror2 = none
	Horror3 = none

	Pain1 = none
	Pain2 = none
	Pain3 = none

	Hate1 = none
	Hate2 = none
	Hate3 = none

	Orgasm = none
	Moan  = none
	
	Kiss = none
	Lick = none
	SuckSlow = none
	SuckFast = none
	Deep = none

	RaceKeys = Utility.CreateStringArray(0)
	parent.Initialize()
	LipSync = Config.LipSync
endFunction

