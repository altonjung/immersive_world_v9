Scriptname _SLS_AnimalFriend extends Quest  

Event OnAnimationEnd(int tid, bool HasPlayer)
EndEvent

Event OnOrgasmStart(int tid, bool HasPlayer)
EndEvent

Event OnSexLabOrgasmSeparate(Form ActorRef, Int tid)
EndEvent

Event On_SLS_PlayerSwallowedCum(Form akSource, Bool Swallowed, Float LoadSize, Float LoadSizeBase)
EndEvent

State TrackOrgasms
	Event OnBeginState()
		RegForEvents()
		DidSwallow = false
		DidOrgasm = false
	EndEvent
	
	Event OnEndState()
		UnregisterForAllModEvents()
	EndEvent
	
	Event OnAnimationEnd(int tid, bool HasPlayer)
		If HasPlayer
			GoToState("")
			If !DidOrgasm
				(GetAliasRef(SexPartner) as _SLS_AnimalFriendAlias).SetUpdate(0.5)
			EndIf
		EndIf
	EndEvent

	Event OnOrgasmStart(int tid, bool HasPlayer);(string eventName, string argString, float argNum, form sender)
		OrgasmEvent(ActorRef = None, tid = tid, HasPlayer = HasPlayer)
	EndEvent

	Event OnSexLabOrgasmSeparate(Form ActorRef, Int tid)
		;Bool HasPlayer = Sexlab.FindPlayerController() == tid
		OrgasmEvent(ActorRef = ActorRef as Actor, tid = tid, HasPlayer = Sexlab.FindPlayerController() == tid)
	EndEvent
	
	Event On_SLS_PlayerSwallowedCum(Form akSource, Bool Swallowed, Float LoadSize, Float LoadSizeBase)
		If akSource == SexPartner
			DidSwallow = Swallowed
		EndIf
		;Debug.Messagebox("Swallow: " + DidSwallow)
	EndEvent
EndState

Function RegForEvents()
	RegisterForModEvent("HookAnimationEnd", "OnAnimationEnd")
	RegisterForModEvent("_SLS_PlayerSwallowedCum", "On_SLS_PlayerSwallowedCum")
	If Game.GetModByName("SLSO.esp") != 255
		RegisterForModEvent("SexLabOrgasmSeparate", "OnSexLabOrgasmSeparate")
	Else
		RegisterForModEvent("HookOrgasmStart", "OnOrgasmStart")
	EndIf
EndFunction

Function OrgasmEvent(Actor ActorRef = None, Int tid, Bool HasPlayer)
	;Debug.Messagebox("Orgasm\nActorRef: " + ActorRef + "\nSexPartner: " + SexPartner)
	If HasPlayer && (ActorRef == None || ActorRef == SexPartner)
		If _SLS_AnimalBreedVoices.HasForm(SexPartner.GetVoiceType())
			DidOrgasm = true
			ReferenceAlias AliasSelect = GetAliasRef(SexPartner)
			;/
			If ActorRef != PlayerRef && ActorRef != None
				AliasSelect = GetAliasRef(ActorRef)
			Else
				Int i = 0
				Actor[] actorList = SexLab.HookActors(tid as string)
				While i < actorList.Length
					ActorRef = actorList[i]
					If ActorRef != PlayerRef
						AliasSelect = GetAliasRef(ActorRef)
					EndIf
					i += 1
				EndWhile
			EndIf
			/;
			
			If AliasSelect != None
				If AliasSelect.GetReference() == SexPartner ; Existing friend
					Utility.Wait(3.0) ; Wait for cum effects to be applied, Gems to be added, Cum to be added to holes etc
					(AliasSelect as _SLS_AnimalFriendAlias).SetUpdate(GetNextBreedingSession())
					
				Else ; New friend
					Debug.Notification("You've made a new friend")
					SexPartner.AddToFaction(_SLS_AnimalFriendFaction)
					AliasSelect.ForceRefTo(SexPartner)
					ObjectReference HomeMarker = GetHomeMarker(SexPartner)
					HomeMarker.MoveTo(SexPartner)
					;(AliasSelect as _SLS_AnimalFriendAlias).SetupFriend()

					SexPartner.EvaluatePackage()
					Utility.Wait(3.0) ; Wait for cum effects to be applied, Gems to be added, Cum to be added to holes etc
					(AliasSelect as _SLS_AnimalFriendAlias).SetUpdate(GetNextBreedingSession())
				EndIf
			EndIf
		EndIf
	EndIf
EndFunction

Function FondleStart(Actor akSpeaker)
	GoToState("TrackOrgasms")
	DoSound(akSpeaker, "Neigh")
	SexPartner = akSpeaker
EndFunction

ReferenceAlias Function GetAliasRef(Actor ActorRef)
	Int i = _SLS_AnimalFriendAliases.GetNumAliases()
	ReferenceAlias FreeAlias
	ReferenceAlias AliasSelect
	Bool FoundFreeAlias = false
	While i > 0
		i -= 1
		AliasSelect = _SLS_AnimalFriendAliases.GetNthAlias(i) as ReferenceAlias
		If AliasSelect.GetReference() as Actor == ActorRef
			Return AliasSelect
		ElseIf AliasSelect.GetReference() == None
			FoundFreeAlias = true
			FreeAlias = AliasSelect
		EndIf
	EndWhile
	If FoundFreeAlias
		Return FreeAlias
	Else
		Debug.Notification("No free animal friend slots remaining")
	EndIf
	Return None
EndFunction

Int Function GetAliasIndex(Actor ActorRef)
	Int i = _SLS_AnimalFriendAliases.GetNumAliases()
	ReferenceAlias AliasSelect
	Bool FoundFreeAlias = false
	While i > 0
		i -= 1
		AliasSelect = _SLS_AnimalFriendAliases.GetNthAlias(i) as ReferenceAlias
		If AliasSelect.GetReference() as Actor == ActorRef
			Return i
		EndIf
	EndWhile
	Return -1
EndFunction

ObjectReference Function GetHomeMarker(Actor Friend)
	Int AliasIndex = GetAliasIndex(Friend)
	If AliasIndex == 0
		Return _SLS_AnimalFriendHomeMarkerOne
	EndIf
EndFunction

Function DismissFriend(Actor akSpeaker, Bool MoveHome = false)
	_SLS_AnimalFriendFgQuest.Stop()
	DoSound(akSpeaker, "Agitated")
	ReferenceAlias AliasSelect = GetAliasRef(akSpeaker)
	ObjectReference HomeMarker = GetHomeMarker(akSpeaker)
	If AliasSelect.GetReference() != None
		AliasSelect.Clear()
		akSpeaker.RemoveFromFaction(_SLS_AnimalFriendFaction)
		akSpeaker.EvaluatePackage()
		If MoveHome
			ObjectReference LinkedRef = akSpeaker.GetLinkedRef()
			If LinkedRef
				akSpeaker.MoveTo(LinkedRef)
			Else
				akSpeaker.MoveTo(HomeMarker)
			EndIf
		EndIf
	Else
		Debug.Trace("_SLS_: DismissFriend: Actor not found in aliases: " + akSpeaker)
	EndIf
EndFunction

Function BeginHornyFg(Actor HornyFriend)
	Util.SetupCreatureSex(HornyFriend)
	DoSound(HornyFriend, "Agitated")
	_SLS_AnimalFriendApproachCount.SetValueInt(StorageUtil.GetIntValue(HornyFriend, "_SLS_AnimalFriendApproachCount", missing = 0))
	_SLS_AnimalFriendFgQuest.Start()
	(_SLS_AnimalFriendFgQuest.GetNthAlias(0) as ReferenceAlias).ForceRefTo(HornyFriend)
	HornyFriend.EvaluatePackage()
EndFunction

Function PostponeAnimalFriendSex(Actor HornyFriend)
	_SLS_AnimalFriendFgQuest.Stop()
	DoSound(HornyFriend, "Agitated")
	StorageUtil.SetIntValue(HornyFriend, "_SLS_AnimalFriendApproachCount", (StorageUtil.GetIntValue(HornyFriend, "_SLS_AnimalFriendApproachCount", missing = 0) + 1))
	ReferenceAlias AliasSelect = GetAliasRef(HornyFriend)
	If AliasSelect.GetReference() != None
		(AliasSelect as _SLS_AnimalFriendAlias).SetUpdate(0.5)
	Else
		Debug.Trace("_SLS_: PostponeAnimalFriendSex: Got None alias for: " + HornyFriend)
	EndIf
EndFunction

Function WalkAway(Actor akSpeaker)
	_SLS_AnimalFriendFgQuest.Stop()
	DoSound(akSpeaker, "Agitated")
	If _SLS_AnimalFriendApproachCount.GetValueInt() <= 1
		PostponeAnimalFriendSex(akSpeaker)
	Else
		DismissFriend(akSpeaker, MoveHome = false)
		If Utility.RandomFloat(0.0, 100.0) > 50.0 ; rape that dismissive bitch
			
			AnimalFriendSex(akSpeaker, GetRandomSexType(), Victim = PlayerRef)
			
			Utility.Wait(5.0)
			Debug.Notification("Fed up with your cock teasing, " + akSpeaker.GetBaseObject().GetName() + " mounts you aggressively")
		EndIf
	EndIf
EndFunction

Function AnimalFriendSex(Actor AnimalFriend, String SexType, Actor Victim = None)
	_SLS_AnimalFriendFgQuest.Stop()
	SexPartner = AnimalFriend
	DoSound(AnimalFriend, "Neigh")
	sslBaseAnimation[] Animations = Sexlab.GetCreatureAnimationsByRaceTags(2, AnimalFriend.GetRace(), SexType, TagSuppress = "", RequireAll = true)
	
	If SexType == "Blowjob" && Animations.Length == 0 ; Stupid tags
		Animations = Sexlab.GetCreatureAnimationsByRaceTags(2, AnimalFriend.GetRace(), "Oral", TagSuppress = "", RequireAll = true)
	EndIf
	
	If Animations.Length > 0
		;StorageUtil.SetFloatValue(AnimalFriend, "SLAroused.ActorExposure", 100.0)
		If Victim == None; Don't track if event is breeding session postponement dismissal
			Util.FondleArousalIncrease(AnimalFriend, IncFondleCount = true)
			GoToState("TrackOrgasms")
		EndIf
		actor[] sexActors =  new actor[2]
		SexActors[0] = PlayerRef
		SexActors[1] = AnimalFriend
		Sexlab.StartSex(sexActors, animations, Victim)
		Utility.Wait(0.5)
		AnimalFriend.MoveTo(PlayerRef)
	Else
		Debug.Trace("_SLS_: AnimalFriendSex: No animations found for race: " + AnimalFriend.GetRace() + " of type: " + SexType)
	EndIf
EndFunction

Float Function GetNextBreedingSession()
	Float HoursToNextBreeding = BreedingCooloffBase
	Float CoveredInCum = Sexlab.CountCum(PlayerRef) / 6.0
	HoursToNextBreeding += CoveredInCum * BreedingCooloffCumCovered
	Float Pregnancy = 0.0
	If Game.GetModByName("dcc-soulgem-oven-000.esm") != 255
		Float GemCount = Sgo.ActorGemGetCount(PlayerRef) as Float
		Float GemsMax = Sgo.GetGemCapacityMax() as Float
		Pregnancy = GemCount / GemsMax
		;Debug.Messagebox("GemCount: " + GemCount + "\nGemsMax: " + GemsMax)
	EndIf
	HoursToNextBreeding += Pregnancy * BreedingCooloffPregnancy

	Float CumFilled = 0.0
	If Game.GetModByName("sr_FillHerUp.esp") != 255
		Float CumTotal = StorageUtil.GetFloatValue(PlayerRef, "sr.inflater.cum.anal", missing = 0.0) + StorageUtil.GetFloatValue(PlayerRef, "sr.inflater.cum.vaginal", missing = 0.0)
		Float CumMax = 1.0 ; Simple check that FHU is actually working first
		If CumTotal != 0.0
			CumMax = Fhu.GetCumCapacityMax()
		EndIf
		CumFilled = CumTotal / (CumMax * 2.0)
		If CumFilled > 1.0
			CumFilled = 1.0
		EndIf		
	EndIf
	HoursToNextBreeding += CumFilled * BreedingCooloffCumFilled

	If DidSwallow
		HoursToNextBreeding += SwallowBonus
	EndIf

	;Debug.Messagebox("HoursToNextBreeding: " + HoursToNextBreeding + "\nCoveredInCum: " + CoveredInCum + "\nPregnancy: " + Pregnancy + "\nCumFilled: " + CumFilled + ". Swallowed: " + DidSwallow + " - " + SwallowBonus)
	Debug.Trace("_SLS_: HoursToNextBreeding: " + HoursToNextBreeding + ". CoveredInCum: " + CoveredInCum + ". Pregnancy: " + Pregnancy + ". CumFilled: " + CumFilled + ". Swallowed: " + DidSwallow + " - " + SwallowBonus)
	Return HoursToNextBreeding
EndFunction

Function DoSound(Actor akSpeaker, String SoundType)
	If akSpeaker.Is3dLoaded()
		VoiceType Voice = akSpeaker.GetVoiceType()
		If Voice == CrHorseVoice
			If SoundType == "Sniffs"
				_SLS_HorseSniffs.Play(akSpeaker)
			ElseIf SoundType == "Neigh"
				_SLS_HorseNeigh.Play(akSpeaker)
			ElseIf SoundType == "Agitated"
				_SLS_HorseAgitated.Play(akSpeaker)
			EndIf
		EndIf
	EndIf
EndFunction

String Function GetRandomSexType()
	Float RanFloat = Utility.RandomFloat(0.0, 100.0)
	If RanFloat < 33.0
		Return "Blowjob"
	ElseIf RanFloat < 66.0
		Return "Vaginal"
	Else
		Return "Anal"
	EndIf
EndFunction

Bool DidSwallow= false
Bool DidOrgasm = false

Float Property BreedingCooloffBase = 3.0 Auto Hidden
Float Property BreedingCooloffPregnancy = 12.0 Auto Hidden
Float Property BreedingCooloffCumCovered = 6.0 Auto Hidden
Float Property BreedingCooloffCumFilled = 12.0 Auto Hidden
Float Property SwallowBonus = 12.0 Auto Hidden

Actor SexPartner

GlobalVariable Property _SLS_AnimalFriendApproachCount Auto

Quest Property _SLS_AnimalFriendFgQuest Auto

Actor Property PlayerRef Auto

Sound Property _SLS_HorseAgitated Auto
Sound Property _SLS_HorseSniffs Auto
Sound Property _SLS_HorseNeigh Auto

VoiceType Property CrHorseVoice Auto

Formlist Property _SLS_AnimalBreedVoices Auto ; A list of voices that can be your breeders

Faction Property _SLS_AnimalFriendFaction Auto

Quest Property _SLS_AnimalFriendAliases Auto

ObjectReference Property _SLS_AnimalFriendHomeMarkerOne Auto

SexlabFramework Property Sexlab Auto
SLS_Utility Property Util Auto
_SLS_InterfaceSgo Property Sgo Auto
_SLS_InterfaceFhu Property Fhu Auto
