Scriptname SLApproachBaseQuestScript extends Quest

Actor Property PlayerRef Auto
Int Property index = -1 Auto Hidden
Int Property maxTime = 60 Auto Hidden
bool Property approachEnding = false Auto Hidden
bool Property isSkipMode = false Auto Hidden
Globalvariable Property SLAFactorScore Auto
slapp_util Property slappUtil Auto

ObjectReference Property SLAPMiscReferences Auto
Package Property DoNothing Auto
Bool Isplaying = false

bool Property dhlpSuspendStatus Auto Hidden Conditional

Function register()
	index = -1
	while(index == -1)
		Utility.Wait(1.0)
		index = SLApproachMain.RegisterQuest(ApproachQuest, self, ApproachName)
	endwhile
EndFunction

Event OnUpdate()
if SLApproachMain.debugLogFlag
	Debug.notification("Parent: Onupdate")
endif
	endApproach()
endEvent

Function ready()
	self.Reset()
	self.SetStage(10)
EndFunction

Function startApproach(Actor akRef)
	;Debug.notification("Start Approach Base")
	RegisterForSingleUpdate(maxTime)
EndFunction

;#########################
;##########Motion#########
;#########################

Idle Property SLAPForcedKiss01_A1_S01 Auto
Idle Property SLAPForcedKiss01_A2_S01 Auto
Idle Property SLAPForcedKiss01_A1_Loop Auto
Idle Property SLAPForcedKiss01_A2_Loop Auto
Idle Property SLAPForcedKiss01_A1_Resist Auto
Idle Property SLAPForcedKiss01_A2_Resist Auto
Idle Property SLAPForcedKiss01_A1_Stop Auto
Idle Property SLAPForcedKiss01_A2_Stop Auto

Idle Property SLA_Flirt_A01 Auto
Idle Property SLA_Flirt_A02 Auto
Idle Property SLA_FlirtFace_A01 Auto
Idle Property SLA_FlirtFaceEnd_A01 Auto
Idle Property SLA_FlirtFace_A02 Auto
Idle Property SLA_FlirtFaceEnd_A02 Auto
Idle Property SLA_Flirt_A02D Auto
Idle Property SLA_FlirtBreast_A01 Auto
Idle Property SLA_FlirtBreast_A02 Auto
Idle Property SLA_FlirtPussy_A01 Auto
Idle Property SLA_FlirtPussy_A02 Auto

Faction Property slapp_AnimatingFaction Auto

Bool Function PreparePairedmotion(Actor akactor, int angle)

if !akactor.isinfaction(slapp_AnimatingFaction)
 	ActorUtil.AddPackageOverride(akactor, DoNothing, 100, 1)
	akactor.EvaluatePackage()
	akactor.SetRestrained()
	akactor.SetDontMove(True)
	Game.DisablePlayerControls(true, true, true, false, true, true, false, false)
	Game.SetPlayerAIDriven(); 
	if Game.GetCameraState() == 0
		Game.ForceThirdPerson()
	endIf
	SLApproachMain.RemoveHeelEffect(PlayerRef)
	SLAPMiscReferences.MoveTo(PlayerRef)
	Float AngleZ = PlayerRef.GetAngleZ()
		
	PlayerRef.SetVehicle(SLAPMiscReferences) ; PosRef
	akactor.SetVehicle(SLAPMiscReferences) ; PosRef
	akactor.MoveTo(PlayerRef)
	Utility.Wait(1.0)
	akactor.setangle(0, 0, AngleZ + angle)
	Utility.Wait(1.0)
	
	PlayerRef.addtofaction(slapp_AnimatingFaction)
	akactor.addtofaction(slapp_AnimatingFaction)
	
	Game.EnablePlayerControls(true, false, false, false, false, false, false, false) ; To display the hud
	Return true
else
	Return true
endif
EndFunction

Function FlirtAnim(Actor akactor, Bool FirstTrigger, int Animnum)

if FirstTrigger == true
	if PreparePairedmotion(akactor, 0)
		FlirtAnimPlay(akactor, Animnum)
	endif
else	
	FlirtAnimPlay(akactor, Animnum)
endif

EndFunction

Function FlirtAnimPlay(Actor akactor, int Animnum)
	if Animnum == 1
		PlayerRef.Playidle(SLA_Flirt_A01)
		akactor.Playidle(SLA_Flirt_A02)
	elseif Animnum == 2
		PlayerRef.Playidle(SLA_FlirtBreast_A01)
		akactor.Playidle(SLA_FlirtBreast_A02)
	elseif Animnum == 3
		PlayerRef.Playidle(SLA_FlirtPussy_A01)
		akactor.Playidle(SLA_FlirtPussy_A02)
	elseif Animnum == 4
		PlayerRef.Playidle(SLA_FlirtFace_A01)
		akactor.Playidle(SLA_FlirtFace_A02)
	elseif Animnum == 5
		PlayerRef.Playidle(SLA_FlirtFaceEnd_A01)
		akactor.Playidle(SLA_FlirtFaceEnd_A02)
	else
		akactor.Playidle(SLA_Flirt_A02D)
	endif
EndFunction

Function KissAnim(Actor akactor)
	If PreparePairedmotion(akactor, 180)
		PlayerRef.Playidle(SLAPForcedKiss01_A1_S01)
		akactor.Playidle(SLAPForcedKiss01_A2_S01)
	endif
	PlayKissSound()
EndFunction

Function KissAnimResist(Actor akactor)
	PlayerRef.Playidle(SLAPForcedKiss01_A1_Resist)
	akactor.Playidle(SLAPForcedKiss01_A2_Resist)
	Utility.Wait(3.0)
	RestoreControl(akactor)
EndFunction

Function PlayKissSound()
	SLAPPMarker_DeepKiss.play(PlayerRef)
EndFunction

Function KissAnimStop(Actor akactor)
	PlayerRef.Playidle(SLAPForcedKiss01_A1_Stop)
	akactor.Playidle(SLAPForcedKiss01_A2_Stop)
	Utility.Wait(3.0)
	RestoreControl(akactor)
EndFunction

Function RestoreControl(actor akactor)
	PlayerRef.SetVehicle(None)
	akactor.SetVehicle(None)
	Game.EnablePlayerControls()
	Game.SetPlayerAIDriven(false)
	Game.ForceThirdPerson()
	PlayerRef.SetRestrained(False)
	PlayerRef.SetDontMove(False)
	akactor.SetRestrained(False)
	akactor.SetDontMove(False)
	ActorUtil.RemovePackageOverride(akactor, DoNothing)
	Debug.SendAnimationEvent(akactor, "IdleForceDefaultState")
	Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	SLApproachMain.ResetHeelEffect(PlayerRef)
	PlayerRef.RemoveFromfaction(slapp_AnimatingFaction)
	akactor.RemoveFromfaction(slapp_AnimatingFaction)
EndFunction

bool Function isSituationValid(Actor akRef);Check if the situation is valid for a npc approach
	ActorBase akRefbase = akRef.GetLeveledActorBase()

;#########################
;##########Add-on#########
;#########################
	If (dhlpSuspendStatus)	;lg added to respect scenes
		slappUtil.log("isSituationValid: false - dhlpSuspendStatus")
		return false
	endif

	if SLApproachMain.enableSexlabSurvivalFlag
		(SLApproach_ExternalMods as SLApproachExternalScript).SLSurvivalLicenseCheck()
		if  (akRef.isinfaction((SLApproach_ExternalMods as SLApproachExternalScript).SLTollCollectorFaction) || akRef.isinfaction((SLApproach_ExternalMods as SLApproachExternalScript).SLKennelKeeperFaction) || akRef.isinfaction((SLApproach_ExternalMods as SLApproachExternalScript).SLLicenseQuarterMasterFaction))
			return false
		endif
	endif

	if SLApproachMain.enableBDFlag
		if (SLApproachMain.enableHirelingFlag == false)
			if  (akRef.isinfaction(SLApproachMain.BaboPotentialHireling))
				return false
			endif
		endif

		if akRef.isinfaction(SLApproachMain.BaboWasHireling)
			akRef.addtofaction(slapp_washiringfaction)
			BaboDialogueMercenaryCall(akRef)
			return false
		elseif !akRef.isinfaction(SLApproachMain.BaboWasHireling) && akRef.isinfaction(slapp_washiringfaction)
			akRef.removefromfaction(slapp_washiringfaction)
			return false
		endif

		if akRef.isinfaction(SLApproachMain.BaboDialogueFaction)
			if (akRef.isinfaction(SLApproachMain.BaboViceGuardCaptainFaction)) && (akRef.getactorvalue("Variable06") == 5)
				return true
			else
				return false
			endif
		endif

		if SLApproachMain.enableFollowerFlag == false
			if (akRef.isinfaction(SLApproachMain.BaboCurrentHireling))
				return false
			endif
		endif
	endif

	if (SLApproachMain.enableHirelingFlag == false)
		if (akRef.isinfaction(CurrentHireling)) || (akRef.isinfaction(PotentialHireling))
			return false
		endif
	endif
	if SLApproachMain.enableFollowerFlag == false
		if (akref.isinfaction(CurrentFollowerFaction)) || (akRef.isinfaction(CurrentHireling)) || (akref.IsPlayerTeammate())
			return false
		endif
	endif

;#########################
;######Unique Actor#######
;#########################
	if (SLApproachMain.SLAUniqueActor == true) && (akRefbase.isUnique());Check if an actor happens to be unique.
		if SLApproachMain.enableBDFlag
			if (akref.isinfaction(SLApproachMain.BaboViceGuardCaptainFaction))
				return true
			endif
		endif
	elseif (SLApproachMain.SLAUniqueActor == false) && (akRefbase.isUnique())
		return false
	EndIf

;#########################
;#Humanoid identification#
;#########################
;	if (SLApproachMain.enableVisitorFlag == false) && (akRef.isinfaction(slapp_VisitingFaction))
;		return false
;	endif

;#########################
;########Creature######### WIP
;#########################
;		if (SLApproachMain.enablePetsFlag && akRef.IsPlayerTeammate()) ; WIP disabled
;			return true
;		elseif (akRace == HorseRace)
;			if (SLApproachMain.enablePlayerHorseFlag && slappUtil.ValidateHorse(akRef))
;				return true
;			else
;				return false
;			endif
;		endif

	return true
EndFunction

bool Function chanceRoll(Actor akRef, Actor akActor, float baseChanceMultiplier)
	return false
EndFunction

bool Function isPrecheckValid(Actor akRef, Actor akRef2, bool isplayer = false)
	if (!slappUtil.ValidatePromise(akRef, akRef2) || !slappUtil.ValidateShyness(akRef, akRef2))
		string debugstr = akRef.GetActorBase().GetName() + " => " + akRef2.GetActorBase().GetName()
		slappUtil.log(ApproachName + " blocked by Promise or Shyness: " + debugstr)
		return false
	elseif !(slappUtil.ValidateGender(akRef, akRef2, isplayer))
		string debugstr = akRef.GetActorBase().GetName() + " => " + akRef2.GetActorBase().GetName()
		slappUtil.log(ApproachName + " blocked by Gender check: " + debugstr)
		return false
	endif
	
	return true
EndFunction

bool Function isSceneValid(Actor akRef)
	Scene aks = akRef.GetCurrentScene()
	
	if (aks)
		string akscene = aks.GetOwningQuest().GetId()
		string log = ApproachName + ": blocked by another Scene: "
		slappUtil.log(log + akRef.GetActorBase().GetName() + " : " + akscene)
		return false
	endif
	
	return true
EndFunction

int Function GetResult(int chance, int extpoint, float baseChanceMultiplier)
	int result = slappUtil.ValidateChance((chance + baseChanceMultiplier) as Int)
	result += extpoint
	return result
EndFunction

int Function GetDiceRoll()
	return Utility.RandomInt(0, 100)
EndFunction

Function endApproach(bool force = false)
	if SLApproachMain.debugLogFlag
		Debug.notification("Parent: endApproach")
	endif
	;approachEnding = false;deleted because it's duplicated.
	;ApproachQuest.SetStage(100)
	;UnregisterForUpdate()
	SLApproachMain.EndtInitOfQuestByIndex(index)
EndFunction

Function endApproachForce(ReferenceAlias akRef = None) ; for debug and Sex To PC's follow Scene
	slappUtil.log(ApproachName + ": endApproachForce!!")
	if (akRef)
		Actor fordebugact = akRef.GetReference() as Actor
		if (fordebugact)
			ActorBase fordebugname = fordebugact.GetActorBase()
			if (fordebugname)
				slappUtil.log(ApproachName + " Force Stop: " + fordebugname.GetName())
			endif
		endif
	endif
	
	self.endApproach(true)
EndFunction

Function sexRelationshipDown(Actor akRef, Actor akActor, int Possibility)
int relationship = akRef.GetRelationshipRank(akActor) - 1
Int DiceRoll = Self.GetDiceRoll()
; debug.notification("[slapp] " + relationship)
	If DiceRoll <= possibility
		if (relationship < -2)
			relationship = -2
		endif
		akRef.SetRelationshipRank(akActor, relationship)
	EndIf
EndFunction

Function sexRelationshipUp(Actor akRef, Actor akActor, int Possibility)
int relationship = akRef.GetRelationshipRank(akActor) + 1
Int DiceRoll = Self.GetDiceRoll()
	If DiceRoll <= possibility
		if (relationship > 4)
			relationship = 4
		endif
		akRef.SetRelationshipRank(akActor, relationship)
	endif
EndFunction

Function AddtoReconciliationFaction(actor akRef)
bool infaction = akRef.isinfaction(slapp_ReconciliationFaction)
Int DiceRoll = Self.GetDiceRoll()
Int Rank = akRef.GetfactionRank(slapp_ReconciliationFaction)
		If infaction == false
			akRef.addtofaction(slapp_ReconciliationFaction)
			akRef.setfactionrank(slapp_ReconciliationFaction, 0)
		Elseif (Rank == 0)
			akRef.setfactionrank(slapp_ReconciliationFaction, 1)
		ElseIf (Rank == 1)
			akRef.setfactionrank(slapp_ReconciliationFaction, 2)
		Elseif (Rank == 2)
			akRef.setfactionrank(slapp_ReconciliationFaction, 3)
		;Elseif (Rank == 3)
			;akRef.setfactionrank(slapp_ReconciliationFaction, 4)
		Endif
EndFunction

Function RankDownDislikeFaction(actor akRef)
;It will remove the faction from player for now. It needs to be improved.
akRef.removefromfaction(slapp_DislikeFaction)
EndFunction

Function AddtoVisitiedFaction(actor akRef)

bool infaction = akRef.isinfaction(slapp_VisitedFaction)
Int Rank = akRef.GetfactionRank(slapp_VisitedFaction)
	If infaction == false
		akRef.addtofaction(slapp_VisitedFaction)
		akRef.setfactionrank(slapp_VisitedFaction, 0);DislikeFaction
	Else
		akRef.setfactionrank(slapp_VisitedFaction, Rank + 1)
	Endif
EndFunction

Function AddtoStayedFaction(actor akRef)

bool infaction = akRef.isinfaction(slapp_StayedFaction)
Int Rank = akRef.GetfactionRank(slapp_StayedFaction)
	If infaction == false
		akRef.addtofaction(slapp_StayedFaction)
		akRef.setfactionrank(slapp_StayedFaction, 0);DislikeFaction
	Else
		akRef.setfactionrank(slapp_StayedFaction, Rank + 1)
	Endif
EndFunction

Function AddtoVisitiedFailedFaction(actor akRef)

bool infaction = akRef.isinfaction(slapp_VisitedFailedFaction)
Int Rank = akRef.GetfactionRank(slapp_VisitedFailedFaction)
	If infaction == false
		akRef.addtofaction(slapp_VisitedFailedFaction)
		akRef.setfactionrank(slapp_VisitedFailedFaction, 0);DislikeFaction
	Else
		akRef.setfactionrank(slapp_VisitedFailedFaction, Rank + 1)
	Endif
EndFunction

Function AddtoDislikeFaction(actor akRef, int possibility, bool Uprank = false)

bool infaction = akRef.isinfaction(slapp_DislikeFaction)
Int DiceRoll = Self.GetDiceRoll()
Int Rank = akRef.GetfactionRank(slapp_DislikeFaction)

	If DiceRoll <= possibility
	
		If infaction == false
			akRef.addtofaction(slapp_DislikeFaction)
			akRef.setfactionrank(slapp_DislikeFaction, 0);DislikeFaction
		Elseif (Rank >= 0) && (Rank < 2)
			akRef.setfactionrank(slapp_DislikeFaction, 1);HateFaction
		EndIf
		
		If (Rank < 2) && (Uprank == True)
			akRef.setfactionrank(slapp_DislikeFaction, 2);RaperFaction
		Elseif (Rank == 2) && (Uprank == True)
			akRef.setfactionrank(slapp_DislikeFaction, 3);ConstantRaperFaction
		;Elseif (Rank == 3) && (Uprank == True)
			;akRef.setfactionrank(slapp_DislikeFaction, 4);SlaveMasterFaction not yet
		Endif

	EndIf
EndFunction

Function AddtoDisappointedFaction(actor akRef, int possibility, int Uprank)

bool infaction = akRef.isinfaction(slapp_DisappointedFaction)
Int DiceRoll = Self.GetDiceRoll()
Int Rank = akRef.GetfactionRank(slapp_DisappointedFaction)

	If DiceRoll <= possibility
	
		If infaction == false && (Uprank == 0)
			akRef.addtofaction(slapp_DisappointedFaction)
			akRef.setfactionrank(slapp_DisappointedFaction, 0);Player No honor
		Elseif (Rank >= 0) && (Rank < 2)
			akRef.setfactionrank(slapp_DisappointedFaction, 1);Player Exhibitionist
		EndIf
		
		If infaction == true && Uprank == 1
			akRef.setfactionrank(slapp_DisappointedFaction, 2);Player Raped
		Elseif (Rank == 2) || (Uprank == 2)
			akRef.setfactionrank(slapp_DisappointedFaction, 3);Player Slut
		Elseif (Rank == 3) || (Uprank == 2)
			akRef.setfactionrank(slapp_DisappointedFaction, 4);Player Public Toilet
		Endif

	EndIf
EndFunction

Function AddtoProstitutionFaction(actor akRef)

bool infaction = akRef.isinfaction(slapp_ProstitutionFaction)

	If infaction == false
		akRef.addtofaction(slapp_ProstitutionFaction)
	else
		akRef.SetfactionRank(slapp_ProstitutionFaction, akRef.Getfactionrank(slapp_ProstitutionFaction) + 1)
	EndIf
	
EndFunction

Function AddtoAquaintanceFactionSimple(actor akRef, int possibility)

bool infaction = akRef.isinfaction(slapp_AquaintedFaction)
Int DiceRoll = Self.GetDiceRoll()
Int Rank = akRef.GetfactionRank(slapp_AquaintedFaction)

	If DiceRoll <= possibility
		If infaction == false
			akRef.addtofaction(slapp_AquaintedFaction)
			akRef.setfactionrank(slapp_AquaintedFaction, 0);Aquaintance
		EndIf
	EndIf
	
EndFunction

Function AddtoAquaintanceFaction(actor akRef, int possibility, bool Uprank = false)

bool infaction = akRef.isinfaction(slapp_AquaintedFaction)
Int DiceRoll = Self.GetDiceRoll()
Int Rank = akRef.GetfactionRank(slapp_AquaintedFaction)

	If DiceRoll <= possibility
		If infaction == false
			akRef.addtofaction(slapp_AquaintedFaction)
			akRef.setfactionrank(slapp_AquaintedFaction, 0);Aquaintance
		Elseif (Rank == 0)
			akRef.setfactionrank(slapp_AquaintedFaction, 1);AleFriend
		Elseif (Rank == 1)
			akRef.setfactionrank(slapp_AquaintedFaction, 2);Affectionate
		EndIf
		
		If (Rank < 3) && (Uprank == True)
			akRef.setfactionrank(slapp_AquaintedFaction, 3);SexFriend
		Elseif (Rank == 3) && (Uprank == True)
			akRef.setfactionrank(slapp_AquaintedFaction, 4);SexPartner
		;Elseif (Rank == 4) && (Uprank == True)
			;akRef.setfactionrank(slapp_AquaintedFaction, 5);Lover Not Yet
		Endif
		
	Else
	EndIf
EndFunction

Function AddtoKissFaction(actor akRef, int rank)
bool infaction = akRef.isinfaction(slapp_KissFaction)
	If infaction == false
		akRef.addtofaction(slapp_KissFaction)
	endif
EndFunction

Function AddtoRapeFailFaction(actor akRef, int possibility, bool Uprank = false)

bool infaction = akRef.isinfaction(slapp_RapeFailFaction)
Int DiceRoll = Self.GetDiceRoll()
Int Rank = akRef.GetfactionRank(slapp_RapeFailFaction)

	If DiceRoll <= possibility
		If infaction == false
			akRef.addtofaction(slapp_RapeFailFaction)
			akRef.setfactionrank(slapp_RapeFailFaction, 0);RapeFail Once

;			Elseif (Rank >= 0) && (Rank < 2)
;			akRef.setfactionrank(slapp_AquaintedFaction, 1);AleFriend
		EndIf
;		
;		If (Rank < 2) && (Uprank == True)
;			akRef.setfactionrank(slapp_AquaintedFaction, 2);SexFriend
;		Elseif (Rank == 2) && (Uprank == True)
;			akRef.setfactionrank(slapp_AquaintedFaction, 3);SexPartner
;		Elseif (Rank == 3) && (Uprank == True)
;			akRef.setfactionrank(slapp_AquaintedFaction, 4);Lover Not Yet
;		Endif
;		
	Else
	EndIf
EndFunction

Function GiftFaction(actor akRef)
Int Rank = akRef.GetfactionRank(slapp_GiftGiverFaction)
	if (Rank == 0)
		akRef.setfactionrank(slapp_GiftGiverFaction, 1)
	Elseif (Rank >= 1)
		akRef.setfactionrank(slapp_GiftGiverFaction, (Rank + 1))
	EndIf
EndFunction

Bool Function DrinkEvent(Actor Woman, Bool Rape)

if SLApproachMain.enableConsumeAlcholFlag
	Woman.equipitem(ale)
endif

	if Rape
		Woman.playidle(BaboDrinkBlackOut)
		Return True
	else
		Woman.Playidle(BaboDrinkNormal)
		Return False
	endif
EndFunction



Event OnInit() ; RegisteringModEvent
	RegisterExternalModEvent()
EndEvent


Bool Function KnockKnock()
Return False
EndFunction

Bool Function iGetFormIndex()
Return False
EndFunction


Potion Property Ale Auto

;-----------------External ModEvent---------------------



Function RegisterExternalModEvent()
	RegisterForModEvent("SLAPP_ConsequenceEvent", "SLAPPConsequenceEvent")
	RegisterForModEvent("SLAPP_AcquaintanceEvent", "SLAPPAcquaintanceEvent")
	RegisterForModEvent("SLAPP_HateEvent", "SLAPPHateEvent")
	RegisterForModEvent("dhlp-Suspend", "OnSuspend")	;lg added
	RegisterForModEvent("dhlp-Resume", "OnResume")
EndFunction

Event OnSuspend(string eventName, string strArg, float numArg, Form sender)
	dhlpSuspendStatus = true
EndEvent
Event OnResume(string eventName, string strArg, float numArg, Form sender)
	dhlpSuspendStatus = false
EndEvent

Event SLAPPHateEvent(form akSpeakerform, Bool HadSex = false, string results)
Actor akspeaker = akspeakerform as actor
int Chance = SLApproachMain.SLADislikeChance + 20
	AddtoDislikeFaction(akSpeaker, Chance, Hadsex)
	sexRelationshipDown(akSpeaker, PlayerRef, SLApproachMain.SLARelationshipChance)
EndEvent

Event SLAPPAcquaintanceEvent(Form akSpeakerform, Bool HadSex = false, string results)
Actor akspeaker = akspeakerform as actor
Int AcquaintanceChance = SLApproachMain.SLAAquaintanceChance + 20
Int RelationshipChance = SLApproachMain.SLARelationshipChance + 20
	AddtoAquaintanceFaction(akSpeaker, AcquaintanceChance, Hadsex)
	SexRelationshipUp(akSpeaker, PlayerRef, RelationshipChance)
EndEvent


Event SLAPPConsequenceEvent(Bool Worse, string results)
if SLApproachMain.debugLogFlag
	Debug.notification(results)
endif
	If Worse
		SLAppPCSex.ExternalTrigger(Worse)
	Else
		SLAppPCSex.ExternalTrigger(Worse)
	Endif
EndEvent

Function BaboDialogueMercenaryCall(actor MercenaryRef); Instead call the function from SLAPP, BaboDialogue will handle a mercenary.
	int handle = ModEvent.Create("Babo_SLAPPMercenaryEvent")
	form MercenaryRefFrom = MercenaryRef as form
	if (handle)
		ModEvent.PushForm(handle, MercenaryRef)
		ModEvent.Send(handle)
	endIf
EndFunction

Function TakeArmor(Actor Victim, Actor Pervert, Keyword ArmorKeyword)
	Armor ThisArmor = FindArmor(Victim, True, ArmorKeyword)
	;BaboPropertyRegister()
	Victim.removeitem(ThisArmor, 1, SLApproachMain.BaboChestWhiterunRef)
EndFunction

Armor Function FindArmor(Actor target, Bool Keywordswitch = False, Keyword TargetArmor)
	int slotsChecked
	slotsChecked += 0x00100000
	slotsChecked += 0x00200000 ;ignore reserved slots
	slotsChecked += 0x80000000

	int thisSlot = 0x01
	while (thisSlot < 0x80000000)
		if (Math.LogicalAnd(slotsChecked, thisSlot) != thisSlot)
			Armor thisArmor = target.GetWornForm(thisSlot) as Armor
			if (thisArmor && thisArmor.HasKeyword(TargetArmor))
				return thisarmor
			Else
				slotsChecked += thisSlot
			EndIf
		endif
		thisSlot *= 2 ;double the number to move on to the next slot
	endWhile
EndFunction

;Function BaboPropertyRegister()
;	BaboChestWhiterunRef = Game.GetFormFromFile(0x00e46567, "BabointeractiveDia.esp") as objectreference
;Endfunction


SexLabFramework Property SexLab  Auto  
SLApproachMainScript Property SLApproachMain auto
SLAppPCSexQuestScript Property SLAppPCSex auto

; overwrite by real approach quests
Quest Property ApproachQuest  Auto
string Property ApproachName Auto
Quest Property HelperQuest  Auto
Quest Property SLApproach_ExternalMods auto
ReferenceAlias Property HelperRef  Auto  
ReferenceAlias Property HelpRaperRef  Auto  
;------


Location Property BYOHHouse1LocationInterior Auto
Location Property BYOHHouse2LocationInterior Auto
Location Property BYOHHouse3LocationInterior Auto
Location Property WhiterunBreezehomelocation Auto
Location Property SolitudeProudspireManorLocation Auto
Location Property MarkarthVlindrelHallLocation Auto
Location Property RiftenHoneysideLocation Auto
Location Property WindhelmHjerimLocation Auto

Keyword Property LocTypePlayerHouse Auto
Formlist Property SLApproachPlayerHouse Auto
Formlist Property SLApproachPlayerHouseBYOH01 Auto
Formlist Property SLApproachPlayerHouseBYOH02 Auto
Formlist Property SLApproachPlayerHouseBYOH03 Auto
Formlist Property SLApproachPlayerHouseWhiterun Auto
Formlist Property SLApproachPlayerHouseMarkarth Auto
Formlist Property SLApproachPlayerHouseRiften Auto
Formlist Property SLApproachPlayerHouseSolitude Auto
Formlist Property SLApproachPlayerHouseWindhelm Auto
Formlist Property SLApproachPotentialHouseVisitors Auto

Faction Property isguardfaction  Auto  
Race Property ElderRace  Auto  
Race Property HorseRace  Auto  
Race Property ManakinRace  Auto  
Race Property DremoraRace  Auto  

Armor Property SLAppRingShame  Auto  
Armor Property SLAppRingFamily  Auto  

Faction Property JobJarlFaction  Auto
Faction Property Banditfaction  Auto
Faction Property WINeverFillAliasesFaction  Auto

Faction Property slapp_ProstitutionFaction Auto
Faction Property slapp_Characterfaction Auto
Faction Property SLAX_AggressiveFaction Auto
Faction Property slapp_washiringfaction Auto
Faction Property slapp_AquaintedFaction Auto
Faction Property slapp_DislikeFaction Auto
Faction property slapp_DisappointedFaction auto
Faction Property slapp_RapeFailFaction Auto
Faction Property slapp_ReconciliationFaction Auto
Faction Property slapp_GiftGiverFaction Auto
Faction Property slapp_VisitedFaction Auto
Faction Property slapp_StayedFaction Auto
Faction Property slapp_VisitedFailedFaction Auto
Faction Property SexLabAnimatingFaction Auto
Faction Property ThalmorFaction Auto
Faction Property CurrentFollowerFaction Auto
Faction Property PlayerFaction Auto
Faction Property PlayerMarriedFaction Auto
Faction Property CurrentHireling Auto
Faction Property PotentialHireling Auto
Faction Property slapp_VisitingFaction Auto
Faction Property slapp_VisitingEventFaction Auto
Faction Property slapp_VisitingScenePlayFaction Auto
Faction property slapp_KissFaction Auto

LeveledItem Property SLAPPAffectionMiscLVL Auto

GlobalVariable Property SLAStandardLevelMaximumNPCGlobal Auto
GlobalVariable Property SLAStandardLevelMinimumNPCGlobal Auto
GlobalVariable Property SLApproachMoralGlobal Auto

Idle property BaboDrinkNormal auto
Idle property BaboDrinkBlackOut auto
Idle property BaboDrinkBlackOutLoop auto
Sound Property SLAPPMarker_DeepKiss  Auto  
