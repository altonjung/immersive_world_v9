Scriptname SLAppPCSexQuestScript extends SLApproachBaseQuestScript Conditional 

Scene selectedScene
bool property willRape Auto Hidden Conditional
bool property SLHHwillRape Auto Hidden Conditional
bool property PCApproachOngoing Auto Hidden Conditional
bool property PCVisitingBefore Auto Hidden Conditional
bool property PCVisitingOn Auto Hidden Conditional
bool property PCVisitingAfter Auto Hidden Conditional
bool Property HasDoorKey Auto Hidden conditional
bool Property DoorKeyexist Auto Hidden conditional
float Property ProstitutionAcceptChance = 0.0 Auto Hidden Conditional

keyword property ClothingPoor Auto
keyword property ClothingRich Auto

Miscobject property gold001 Auto
WorldSpace AkWorld
WorldSpace Property Whiterunworld Auto
WorldSpace Property Solitudeworld Auto

Function startApproach(Actor akRef)
	ImportPlayerStatus()
	SetPlayerLevel()
	PCApproachOngoing = True
	maxTime = SLApproachMain.SLApproachTimelimit
	ProstitutionChance(akref)
	SetCharacter(akRef)
	if akref == StayingActor.GetReference() as Actor
		if selectedScene == SLApproachHouseStayScene
			akref.addtofaction(slapp_VisitingScenePlayFaction)
			slappUtil.log("Selected scene is stayingguestevent, roll rape chance.")
		endif
	else
		talkingActor.ForceRefTo(akRef)
		if (selectedScene == SLApproachAskForSexQuestScene) || (selectedScene == SLAppAskingNameToPCScene)
			slappUtil.log("Selected scene is sex to pc, roll rape chance.")
		endif
	endif
	self.rollRapeChance(akRef)
	SLApproachRapeToggle.setvalue(willRape as int)
	if SLA_BaboDialogue.getvalue() == 1
		;AkWorld = akref.getworldspace() ; haven't decided whether to add it or not.
		;if Akworld == Whiterunworld
		;	if PlayerRef.isinfaction(WhiterunOrcFuckToyTitleRank)
		;		SLApproachPlayerHouseWhiterun.addform(akref)
		;	endif			
		;elseif Akworld == Solitudeworld
		;endif
	endif
	selectedScene.Start()
	;approachEnding = True
	parent.startApproach(akRef)
	if SLApproachMain.debugLogFlag
		Debug.notification("StartApproach," + (selectedScene.getname() as string) + "starts from " + (akRef.GetBaseObject().GetName() as string))
	endif
EndFunction

Function SetPlayerLevel()
	int DLevel = SLApproachMain.SLADeviationLevel
	SLAStandardLevelMaximumNPCGlobal.value = PlayerRef.getlevel() + DLevel
	SLAStandardLevelMinimumNPCGlobal.value = PlayerRef.getlevel() - DLevel
EndFunction

Function SetCharacter(actor akRef)

Int Character

if !akRef.isinfaction(slapp_Characterfaction)
	actorbase akRefbase = akRef.getbaseobject() as actorbase
	
	if akRefbase.isunique()
		Character = Utility.randomint(SLApproachMain.SLANPCUniqueCharacterMin, SLApproachMain.SLANPCUniqueCharacterMax);0Mild,1Timid,2Confident,3Aggressive,4Rapist
	else
		if akRef.getactorvalue("Morality") <= SLApproachMoralGlobal.getvalue() || akRef.isinfaction(slapp_ThugFaction)
			Character = Utility.randomint(3,4);0Mild,1Timid,2Confident,3Aggressive,4Rapist
		else
			Character = Utility.randomint(SLApproachMain.SLANPCCharacterMin, SLApproachMain.SLANPCCharacterMax);0Mild,1Timid,2Confident,3Aggressive,4Rapist	
		endif
	endif

	akRef.addtofaction(slapp_Characterfaction)
	akRef.addtofaction(SLAX_AggressiveFaction)
	akRef.setfactionrank(slapp_Characterfaction, Character)
	akRef.setfactionrank(SLAX_AggressiveFaction, Character)
endif

EndFunction


Function approachEndingSwitch(Bool Switch)
	approachEnding = Switch
EndFunction

int Function ProstitutionNPCMoney(Actor akRef) ; How much NPC has money.

 
Armor HeadArmor = akRef.GetWornForm(0x00000001) as Armor
Armor BodyArmor = akRef.GetWornForm(0x00000004) as Armor
Armor HandsArmor = akRef.GetWornForm(0x00000008) as Armor
Armor AmuletArmor = akRef.GetWornForm(0x00000020) as Armor
Armor RingArmor = akRef.GetWornForm(0x00000040) as Armor
Armor FeetArmor = akRef.GetWornForm(0x00000080) as Armor

int ArmorValue = 0
int RichValue = 0

if HeadArmor
	ArmorValue += HeadArmor.GetGoldValue() as int
endif

if BodyArmor
	ArmorValue += BodyArmor.GetGoldValue() as int
endif

if HandsArmor
	ArmorValue += HandsArmor.GetGoldValue() as int
endif

if AmuletArmor
	ArmorValue += AmuletArmor.GetGoldValue() as int
endif

if RingArmor
	ArmorValue += RingArmor.GetGoldValue() as int
endif

if FeetArmor
	ArmorValue += FeetArmor.GetGoldValue() as int
endif

int LevelValue = akref.getlevel() * 10

if akref.wornhaskeyword(ClothingPoor)
	Richvalue = 5
elseif akref.wornhaskeyword(ClothingRich)
	Richvalue = 1500
else
	Richvalue = 500
endif

Int Totalvalue = Armorvalue + LevelValue + RichValue

Return Totalvalue

EndFunction


int Function ProstitutionPlayerValue(); How much will you offer

int ValueMax = SLApproachProstitutionMax.getvalue() as int
int ValueMin = SLApproachProstitutionMin.getvalue() as int
int extravalue
	extravalue += slappUtil.NudeCalc(PlayerRef);from0~70
	extravalue += slappUtil.AppearanceCalc();from0~75
int PValue = Utility.randomint(ValueMin, ValueMax)
	extravalue += Pvalue 
SLApproachProstitutionValue.setvalue(extravalue)
UpdateCurrentInstanceGlobal(SLApproachProstitutionValue)
if SLApproachMain.debugLogFlag
	Debug.notification("Your prostitution value is: " + extravalue)
endif
Return Pvalue

EndFunction

Function ProstitutionChance(Actor akref)

int NPCMoney = ProstitutionNPCMoney(akref)
int PlayerValue = ProstitutionPlayerValue()

float AcceptChance = ((NPCMoney / PlayerValue) * 100) as float

if AcceptChance >= 100
	ProstitutionAcceptChance = 100
Else
	ProstitutionAcceptChance = AcceptChance
EndIf

If PlayerValue >= NPCMoney
	SLApproachMain.SLAProstitution = false
;	SLApproachProstitutionFraudChance.setvalue();WIP
else
	SLApproachMain.SLAProstitution = true
endif

Endfunction

Function rollRapeChance(Actor akRef)
	if (SLApproachMain.enableRapeFlag)
		if (SLApproachMain.enableSLHHFlag)
			SLHHwillRape = true
		else
			SLHHwillRape = false
		endif
		if (akRef.IsEquipped(SLAppRingBeast))
			willRape = true
			return
		endif
		
		int chance = akRef.GetFactionRank(arousalFaction)
		chance += slappUtil.HomeAlone();from-50~50
		chance += slappUtil.CharacterCalc(akRef);from-25~25
		chance += slappUtil.LightLevelCalc(akRef);from-50~25
		chance += slappUtil.TimeCalc();from-25~25
		chance += slappUtil.NudeCalc(PlayerRef);from0~70
		chance += slappUtil.AppearanceCalc();from0~75
;		chance += 5;50+145+5 = 200
		chance = chance / 10
		chance = slappUtil.ValidateChance(chance);From 0 to 150
		chance += SLApproachMain.userAddingRapePointPc;Range(-100, 100)

		int roll = Utility.RandomInt(0, 150)
		SLAFactorScore.value = chance; Why did I do this? Never know.. Perhaps I'll need this to sort npcs some other time.
		if (roll < chance)
			willRape  = true
		else
			willRape  = false
		endif
	else
		willRape = false
	endif
EndFunction

bool Function chanceRoll(Actor akRef, Actor akActor, float baseChanceMultiplier);triggered directly from SLApproachApplyEffect
	string akRefName = akRef.GetActorBase().GetName()

	if SLApproachMain.debugLogFlag
		Debug.notification("ChanceRoll started")
	endif

	if !(self.isPrecheckValid(akRef, akActor, true))
		return false
	elseif !(akActor.GetPlayerControls())
		return false
	endif

	int chance = SexUtil.GetArousal(akRef, akActor); get the value of NPC's arousal.
	if (chance < SLApproachMain.lowestArousalNPC)
		slappUtil.log(ApproachName + ": " + akRefName + " :Canceled by NPC's Arousal: " + chance)
		return false
	elseif (SexUtil.GetArousal(akActor, akRef) < SLApproachMain.lowestArousalPC)
		slappUtil.log(ApproachName + ": " + akRefName + " :Canceled by PC's Arousal: ---")
		return false
	endif

	int StandardlevelRangeminimum = (akActor.getlevel() - SLApproachMain.SLADeviationLevel)
	int StandardlevelRangemaximum = (akActor.getlevel() + SLApproachMain.SLADeviationLevel)

	If akref.getlevel() < StandardlevelRangeminimum
		if SLApproachMain.SLALowerLevelNPC == false
			Return false
		endif
	Elseif akref.getlevel() > StandardlevelRangemaximum
		if SLApproachMain.SLAhigherLevelNPC == false
			Return false
		endif
	Elseif (akref.getlevel() >= StandardlevelRangeminimum) && (akref.getlevel() <= StandardlevelRangemaximum)
		if SLApproachMain.SLAStandardLevelNPC == false
			Return false
		endif
	EndIf
	
	int pt_gll = slappUtil.LightLevelCalc(akRef)
	int pt_time = slappUtil.TimeCalc()
	int pt_nude = slappUtil.NudeCalc(akActor)
	int pt_Appearance = slappUtil.AppearanceCalc()
	int pt_bed = slappUtil.BedCalc(akActor) / 2

	; Chance Calculation ---------------------------------
	chance += slappUtil.RelationCalc(akRef, akActor);(-60~50)
	chance += pt_gll;from-50~25
	chance += pt_time;from-25~25
	chance += pt_nude;from0~70
	chance += pt_Appearance;from0~75
	chance += pt_bed;-30or20
	chance -= 15

	int roll = self.GetDiceRoll()
	int result

	If SLApproachMain.enableBDFlag
		if (akRef.isinfaction(SLApproachMain.BaboViceGuardCaptainFaction))
			selectedScene = SLAppViceGuardCaptainScene
			return true
		elseIf (akRef.isinfaction(SLApproachMain.BaboAggressiveBoyFriend))
			selectedScene = SLAppAggressiveBFPCScene
			;debug.notification("Boyfriend Event")
			return true
		EndIf
	EndIf

	if SLA_DDI.getvalue() == 1
		(SLApproach_ExternalMods as SLApproachExternalScript).CheckDD(akActor)
	endif
	if sla_slsurvival.getvalue() == 1
		(SLApproach_ExternalMods as SLApproachExternalScript).SLSurvivalLicenseCheck()
	endif

	If (roll < 50)
		; for asking name ---------------------------------
		roll = self.GetDiceRoll()

		if akRef.isinfaction(slapp_VisitingFaction)
			result = self.GetResult(chance, SLApproachMain.userAddingVisitorPointPc, baseChanceMultiplier)
			slappUtil.log(ApproachName + ": " + akRefName + " :Kiss: " + roll + " < " + result)
			SLAFactorScore.value = result

			if (roll < result)
				int randomi = Utility.randomint(1, 2);1 common, 2 Ask for Drink
				akRef.Setactorvalue("Variable06", randomi)
				selectedScene = SLApproachHouseStayScene
				if SLApproachMain.debugLogFlag
					debug.notification("SLAPP House Visitor Start")
				endif
				return true ; for asking name
			endif
		else
			result = self.GetResult(chance, SLApproachMain.userAddingAskingNamePointPc, baseChanceMultiplier)
			slappUtil.log(ApproachName + ": " + akRefName + " :Kiss: " + roll + " < " + result)
			SLAFactorScore.value = result

			if (roll < result)
				selectedScene = SLAppAskingNameToPCScene
				if SLApproachMain.debugLogFlag
					debug.notification("SLAPP Asking name Start")
				endif
				return true ; for asking name
			endif
		endif
	Else
		; for asking Sex ---------------------------------

		if SLA_DDI.getvalue() == 1
			if akActor.IsEquipped(SLApproachDDIYokeList)
				return false
			endif
		endif

		roll = self.GetDiceRoll()
		
		if akRef.isinfaction(slapp_VisitingFaction)
			result = self.GetResult(chance, SLApproachMain.userAddingVisitorPointPc, baseChanceMultiplier)
			slappUtil.log(ApproachName + ": " + akRefName + " :Kiss: " + roll + " < " + result)
			SLAFactorScore.value = result

			if (roll < result)
				int randomi = Utility.randomint(3, 4);3Flirt, 4ask for Sex
				akRef.Setactorvalue("Variable06", randomi)
				selectedScene = SLApproachHouseStayScene
				if SLApproachMain.debugLogFlag
					debug.notification("SLAPP House Visitor Sex Start")
				endif
				return true ; for asking sex
			endif
		else
			result = self.GetResult(chance, SLApproachMain.userAddingPointPc, baseChanceMultiplier)

			slappUtil.log(ApproachName + ": " + akRefName + " :Sex: " + roll + " < " + result)
			SLAFactorScore.value = result
			if (roll < result)
				selectedScene = SLApproachAskForSexQuestScene
				if SLApproachMain.debugLogFlag
					debug.notification("SLAPP Asking Sex Start")
				endif
				return true ; for sex
			endif
		endif
	EndIf
	return false
EndFunction

Function CheckEndApproach()
	Actor akRef = talkingActor.GetReference() as Actor
	if SLApproachMain.debugLogFlag
		Debug.notification("Child: CheckEndApproach")
	endif
	
	if akRef
		if akRef.isindialoguewithplayer() == false
			endApproachForce()
		endif
	else
		endApproachForce()
	endif
EndFunction

Function endApproach(bool force = false)
	if SLApproachMain.debugLogFlag
		Debug.notification("Child: EndApproach")
	endif
	int retryTime = 30
	Actor akRef = talkingActor.GetReference() as Actor
	Actor akstayingRef
	if stayingActor
		akstayingRef = stayingActor.GetReference() as Actor
	endif
	
	
	if (!force && SLApproachAskForSexQuestFollowPlayerScene.isPlaying())
		slappUtil.log(ApproachName + ": Now following scene is playing, retry.")
		parent.RegisterForSingleUpdate(retryTime)
	elseif (!force && SLAppHousevisitScene.isPlaying())
		slappUtil.log(ApproachName + ": Now following scene is playing, retry.")
		RegisterForSingleUpdate(retryTime)
	elseif (!force && akRef && akRef.IsInDialogueWithPlayer())
		slappUtil.log(ApproachName + ": Now IsInDialogueWithPlayer, retry.")
		RegisterForSingleUpdate(retryTime)
	else
		SLApproachKissResist.setvalue(0)
		PCApproachOngoing = false
		approachEnding = false
		selectedScene.Stop()
		SLApproachAskForSexQuestFollowPlayerScene.Stop()
		SLAppHousevisitScene.Stop()
		SLApproachHouseStayScene.stop()
		if akstayingRef.isinfaction(slapp_VisitingScenePlayFaction)
			akstayingRef.removefromfaction(slapp_VisitingScenePlayFaction)
		endif		
		HelperQuest.Stop()
		talkingActor.clear()
		SLApproachAskForSexQuest.SetStage(100)
	endif
EndFunction


Function endApproachForce(ReferenceAlias akRef = None)
;	PCApproachOngoing = false
	UnregisterForUpdate()
	parent.endApproachForce(talkingActor)
	endApproach(true)
EndFunction


Function StartSex(Actor akActor, Actor akSpeaker, bool rape = false)
	If rape
		SLApproachRapedTimes.setvalue(SLApproachRapedTimes.getvalue() + 1)
	else
		SLApproachNormalSexTimes.setvalue(SLApproachNormalSexTimes.getvalue() + 1)
	endif
	SexUtil.StartSexActors(akSpeaker, akActor, rape)
	;Debug.notification(akSpeaker + "StartSex")
EndFunction


Function ProstitutionStartSex(Actor akActor, Actor akSpeaker)
	SLApproachProstitutionTimes.setvalue(SLApproachProstitutionTimes.getvalue() + 1)
;	ProstitutionPaid(); This will be changed
	SexUtil.StartSexActorsHook(akSpeaker, akActor, false, true, "AfterProst", "AfterProstitute")
EndFunction



Function StartSexMulti(Actor akActor, Actor akSpeaker, Actor Helper, bool rape = false)
	If rape
		SLApproachRapedTimes.setvalue(SLApproachRapedTimes.getvalue() + 1)
	else
		SLApproachNormalSexTimes.setvalue(SLApproachNormalSexTimes.getvalue() + 1)
	endif
	SexUtil.StartSexMultiActors(akSpeaker, akActor, Helper, rape)
EndFunction

Function StopScene()
	self.followSceneStop()
	self.endApproach()
;	PCApproachOngoing = false
EndFunction

Function enjoy()
	Actor NPCtalkingActor = talkingActor.GetReference() as Actor
	if SLApproachMain.SLAProstitutionFollow
		self.ProstitutionStartSex(PlayerRef, NPCtalkingActor)
		self.ProstitutionPlus(NPCtalkingActor)
	else
		self.StartSex(PlayerRef, NPCtalkingActor)
		self.AcquaintancePlus(NPCtalkingActor, false)
	endif
	Utility.wait(1.0)
	Self.StopScene()
EndFunction

Function enjoyStayingActor()
	Actor NPCtalkingActor = stayingActor.GetReference() as Actor

	self.StartSex(PlayerRef, NPCtalkingActor)
	self.AcquaintancePlus(NPCtalkingActor, false)
	Utility.wait(1.0)
	Self.StopScene()
EndFunction

Function Sexforreconciliation(Actor akSpeaker, int Possibility)
	int roll = Utility.RandomInt(0, 100)
	If Possibility <= roll
		Self.CoolDown(akSpeaker)
	EndIf
	SLApproachNormalSexTimes.setvalue(SLApproachNormalSexTimes.getvalue() + 1)
	self.StartSex(PlayerRef, akSpeaker)
EndFunction

Function enjoyMulti(Actor akSpeaker)
	SLApproachNormalSexTimes.setvalue(SLApproachNormalSexTimes.getvalue() + 1)
	self.StartSexMulti(talkingActor.GetReference() as Actor, PlayerRef, akSpeaker)
	Self.StopScene()
EndFunction

Function NothingEnd()
	Self.StopScene()
EndFunction

Function Ignore(Actor akSpeaker)
int Chance = SLApproachMain.SLADislikeChance + 20
	Parent.AddtoDislikeFaction(akSpeaker, Chance, false)
	Parent.sexRelationshipDown(akSpeaker, PlayerRef, SLApproachMain.SLARelationshipChance)
	Self.StopScene()
EndFunction

Function Disappointed(Actor akSpeaker)
	Parent.AddtoDisappointedFaction(akSpeaker, 100, 0)
	Self.StopScene()
EndFunction

Function DisappointedPlus(Actor akSpeaker)
	Parent.AddtoDisappointedFaction(akSpeaker, 100, 1)
	Self.StopScene()
EndFunction

Topic Property SLApproachTalkAboutWearingsNPCComplainWearingNormal Auto

Function ComplainAboutWearings(Actor akSpeaker)
	Self.Disagree(akSpeaker, false)
	akspeaker.say(SLApproachTalkAboutWearingsNPCComplainWearingNormal)
EndFunction

Function GiftGive(Actor akSpeaker)
int Number = Utility.randomint(1, 3)

	PlayerRef.additem(SLAPPAffectionMiscLVL, Number)
	Parent.GiftFaction(akSpeaker)
	Utility.wait(1.0)
	SLApproachGiftTimes.setvalue(SLApproachGiftTimes.getvalue() + 1)
	Self.AcquaintancePlus(akSpeaker, true, false)
EndFunction

Function Acquaintance(Actor akSpeaker)
	Parent.AddtoAquaintanceFaction(akSpeaker, SLApproachMain.SLAAquaintanceChance)
	Parent.sexRelationshipUp(akSpeaker, PlayerRef, SLApproachMain.SLARelationshipChance)
	Self.StopScene()
EndFunction

Function AcquaintancePlus(Actor akSpeaker, Bool StopQuest = True, Bool HadSex = True)
Int AcquaintanceChance = SLApproachMain.SLAAquaintanceChance + 20
Int RelationshipChance = SLApproachMain.SLARelationshipChance + 20
	Parent.AddtoAquaintanceFaction(akSpeaker, AcquaintanceChance, Hadsex)
	Parent.sexRelationshipUp(akSpeaker, PlayerRef, RelationshipChance)
	if StopQuest == true
		Self.StopScene()
	endif	 
EndFunction

Function KissEnd(Actor akSpeaker)
	Parent.AddtoKissFaction(akSpeaker, 0)
	Self.Acquaintance(akSpeaker)
EndFunction

Function ProstitutionPlus(Actor akSpeaker)
	Parent.AddtoProstitutionFaction(akSpeaker)
	Self.StopScene()
EndFunction


Function CoolDown(Actor akSpeaker)
Int RelationshipChance = SLApproachMain.SLARelationshipChance + 20
	Parent.AddtoReconciliationFaction(PlayerRef)
	Parent.RankDownDislikeFaction(PlayerRef)
	Parent.sexRelationshipUp(akSpeaker, PlayerRef, RelationshipChance)
	Self.StopScene()	 
EndFunction

Function Visited()
	PCVisitingBefore = false
	PCVisitingon = false
	PCVisitingafter = false
	Parent.AddtoVisitiedFaction(VisitorRef)
	Self.StopScene() ;Why?
EndFunction

Function Stayed()
	PCVisitingBefore = false
	PCVisitingon = false
	PCVisitingafter = false
	Parent.AddtoStayedFaction(VisitorRef)
	stayingactor.clear()
	Self.StopScene()
EndFunction

Function VisitedbutFailed()
	PCVisitingBefore = false
	PCVisitingon = false
	PCVisitingafter = false
	If VisitorRef
		Parent.AddtoVisitiedFailedFaction(VisitorRef)
	EndIf
	Self.StopScene() 
EndFunction

Function disagree(Actor akSpeaker, Bool Prostitution = false)
	Parent.AddtoDislikeFaction(akSpeaker, SLApproachMain.SLADislikeChance)
	if Prostitution
		SLApproachProstitutionTryTimes.setvalue(SLApproachProstitutionTryTimes.getvalue() + 1)
	endif
	Self.StopScene()
EndFunction

Function RefuseVisit(Actor akSpeaker, Bool Prostitution = false)
	disagree(akSpeaker, Prostitution)
	CleartheHouse()
EndFunction

Function disagreePlus(Actor akSpeaker, Bool Prostitution = false)
int Chance = SLApproachMain.SLADislikeChance + 20
	Parent.AddtoDislikeFaction(akSpeaker, Chance)
	Parent.sexRelationshipDown(akSpeaker, PlayerRef, SLApproachMain.SLARelationshipChance)
	if Prostitution
		SLApproachProstitutionTryTimes.setvalue(SLApproachProstitutionTryTimes.getvalue() + 1)
	endif
	Self.StopScene()
	 
EndFunction

Function rapedBy(Actor akSpeaker)

;Actor ActorRaper = talkingActor.GetReference() as Actor
int Chance = SLApproachMain.SLADislikeChance
	HelperQuest.Start()
	SLApproachRapedTimes.setvalue(SLApproachRapedTimes.getvalue() + 1)
	If (SLApproachMain.enableSLHHFlag)
		Self.followSceneStop()
		Utility.wait(1.0)
		SLHHActivate(akSpeaker, None)
		if SLApproachMain.debugLogFlag
			Debug.notification(akSpeaker + "SLHH Activated")
		endif

	Else
		Parent.AddtoDislikeFaction(akSpeaker, Chance, True)
		self.StartSexMulti(PlayerRef, akSpeaker, HelpRaperRef.GetReference() as Actor, true)
		Self.StopScene()
	EndIf
EndFunction

Function rapedPlusBy(Actor akSpeaker)
;Actor ActorRaper = talkingActor.GetReference() as Actor
int Chance = SLApproachMain.SLADislikeChance + 20
	Parent.sexRelationshipDown(akSpeaker, PlayerRef, SLApproachMain.SLARelationshipChance)
	HelperQuest.Start()
	SLApproachRapedTimes.setvalue(SLApproachRapedTimes.getvalue() + 1)
	If (SLApproachMain.enableSLHHFlag)
		Self.followSceneStop()
		Utility.wait(1.0)
		SLHHActivate(akSpeaker, None)
		if SLApproachMain.debugLogFlag
			Debug.notification(akSpeaker + "SLHH Activated")
		endif
	Else
		Parent.AddtoDislikeFaction(akSpeaker, Chance, True)
		self.StartSexMulti(PlayerRef, akSpeaker, HelpRaperRef.GetReference() as Actor, true)
		Self.StopScene()
	EndIf
EndFunction

Function Baborape(Actor akSpeaker)
;Actor ActorRaper = talkingActor.GetReference() as Actor
	HelperQuest.Start()
	SLApproachRapedTimes.setvalue(SLApproachRapedTimes.getvalue() + 1)
	If (SLApproachMain.enableSLHHFlag)
		Self.followSceneStop()
		Utility.wait(1.0)
		SLHHActivate(akSpeaker, None)
		if SLApproachMain.debugLogFlag
			Debug.notification(akSpeaker + "SLHH Activated")
		endif
	Else
		self.StartSex(PlayerRef, akSpeaker, true)
		BaboDialogueTrigger(akSpeaker, true)
		Self.StopScene()
	EndIf
EndFunction

Function BaboNothingEnd(Actor akSpeaker)
	BaboDialogueTrigger(akSpeaker, false)
	Self.StopScene()
EndFunction

Function PreDrinkEvent(Actor akSpeaker)
	if Parent.DrinkEvent(PlayerRef, willrape)
		SLAppAfterDrink.forcestart()
	else
		if akspeaker.isinfaction(slapp_DislikeFaction)
			Self.CoolDown(akSpeaker)
		else
			Self.Acquaintance(akSpeaker)
		endif
	endif
EndFunction


Function DrinkRapedby(Actor akSpeaker, int Sex)
;Actor ActorRaper = talkingActor.GetReference() as Actor
int Chance = SLApproachMain.SLADislikeChance
	HelperQuest.Start()
	SLApproachRapedTimes.setvalue(SLApproachRapedTimes.getvalue() + 1)
	If (SLApproachMain.enableSLHHFlag)
		Self.followSceneStop()
		Utility.wait(1.0)
		SLHHDrinkActivate(akSpeaker, None, Sex)
		if SLApproachMain.debugLogFlag
			Debug.notification(akSpeaker + "SLHHDrinkActivate")
		endif

	Else
		Parent.AddtoDislikeFaction(akSpeaker, Chance, True)
		self.StartSexMulti(PlayerRef, akSpeaker, HelpRaperRef.GetReference() as Actor, true)
		Self.StopScene()
	EndIf
EndFunction





Function SLHHConsequneceBad(Actor akSpeaker)

if SLApproachMain.enableBDFlag
	iF akSpeaker.isinfaction(SLApproachMain.BaboViceGuardCaptainFaction)
		;Nothing
	else
		int Chance = SLApproachMain.SLADislikeChance + 10
		Parent.AddtoDislikeFaction(akSpeaker, Chance, false)
		Parent.AddtoRapeFailFaction(akSpeaker, Chance, false)
	endif
else
	int Chance = SLApproachMain.SLADislikeChance + 10
	Parent.AddtoDislikeFaction(akSpeaker, Chance, false)
	Parent.AddtoRapeFailFaction(akSpeaker, Chance, false)
endif

	Self.StopScene()
EndFunction

Function SLHHConsequneceWorse(Actor akSpeaker)

if SLApproachMain.enableBDFlag
	iF akSpeaker.isinfaction(SLApproachMain.BaboViceGuardCaptainFaction)
		;Nothing
	else
		int Chance = SLApproachMain.SLADislikeChance + 20
		Parent.AddtoDislikeFaction(akSpeaker, Chance, True)
	endif
else
	int Chance = SLApproachMain.SLADislikeChance + 20
	Parent.AddtoDislikeFaction(akSpeaker, Chance, True)
endif

Self.StopScene()
EndFunction

Function PrePaid(Bool Prepaid)
if Prepaid
	SLApproachMain.SLAProstitutionpayway = 0 ;pre-paid
	ProstitutionPaid()
else
	SLApproachMain.SLAProstitutionpayway = 1 ;post-paid
endif
Endfunction

Function ProstitutionPaid()
	PlayerRef.additem(gold001, SLApproachProstitutionValue.getvalue() as int)
EndFunction

Function ProstitutionRefund()
	PlayerRef.removeitem(gold001, SLApproachProstitutionValue.getvalue() as int)
EndFunction

Function travelWith(Actor akSpeaker, Bool Prostitution = false)
	self.SetStage(15)
	SLApproachAskForSexQuestFollowPlayerScene.Start()
if Prostitution
	SLApproachMain.SLAProstitutionFollow = True
else
	SLApproachMain.SLAProstitutionFollow = false
endif
EndFunction

Function travelWithForMulti(Actor akSpeaker); Not available
	self.SetStage(20)
	SLApproachAskForSexQuestFollowPlayerScene.Start()
EndFunction

Function followSceneStop()

	if SLAppAfterKiss.isplaying()
		SLAppAfterKiss.Stop()
	endif

	if (SLAppAskingNameToPCScene.isplaying())
		SLAppAskingNameToPCScene.stop()
	endif

	if (SLApproachHouseStayScene.isplaying())
		SLApproachHouseStayScene.stop()
	endif
	
	if (SLApproachAskForSexQuestScene.isplaying())
		SLApproachAskForSexQuestScene.Stop()
	endif
	
	if (SLApproachAskForSexQuestFollowPlayerScene.isPlaying())
		SLApproachAskForSexQuestFollowPlayerScene.Stop()
	endif
EndFunction

Function playKiss(Actor akRef)
	SexUtil.PlayKiss(akRef, PlayerRef)
EndFunction

Function playHug(Actor akRef)
	SexUtil.PlayHug(akRef, PlayerRef, SLApproachMain.enableForceThirdPersonHug)
EndFunction

;-------------------------SLHH Mod -----------------------

Function ExternalTrigger(Bool Worse)

Actor NPCtalkingActor

if talkingactor
	NPCtalkingActor = talkingActor.GetReference() as Actor
else
	NPCtalkingActor = stayingActor.GetReference() as Actor
endif

	If Worse
		SLHHConsequneceWorse(NPCtalkingActor)
	Else
		SLHHConsequnecebad(NPCtalkingActor)
	Endif
EndFunction

;-----------------Register HouseLocation-----------------
;variable 06 1~4
;1 - Normal Chat
;2 - eroticclothes
;3 - Drink
;4 - Asking Sex

;5 - Inviting Friends
;6 - Bandit Assualt
;7 - Begging Money;BaboDialogue
;8 - Underwear Thief



Bool Function iGetFormIndex()
	Location CurrentLocation = PlayerRef.GetCurrentLocation()
	Formlist CurrentFormlist
	VisitorRef = None

	if CurrentLocation && CurrentLocation.haskeyword(LocTypePlayerHouse)
		if CurrentLocation == WhiterunBreezehomelocation
			CurrentFormlist = SLApproachPlayerHouseWhiterun
			SLApproachCurrentPlayerHouse.setvalue(1)
		elseif CurrentLocation == BYOHHouse1LocationInterior
			CurrentFormlist = SLApproachPlayerHouseBYOH01
			SLApproachCurrentPlayerHouse.setvalue(2)
		elseif CurrentLocation == BYOHHouse2LocationInterior
			CurrentFormlist = SLApproachPlayerHouseBYOH02
			SLApproachCurrentPlayerHouse.setvalue(3)
		elseif CurrentLocation == BYOHHouse3LocationInterior
			CurrentFormlist = SLApproachPlayerHouseBYOH03
			SLApproachCurrentPlayerHouse.setvalue(4)
		elseif CurrentLocation == SolitudeProudspireManorLocation
			CurrentFormlist = SLApproachPlayerHouseSolitude
			SLApproachCurrentPlayerHouse.setvalue(5)
		elseif CurrentLocation == MarkarthVlindrelHallLocation
			CurrentFormlist = SLApproachPlayerHouseMarkarth
			SLApproachCurrentPlayerHouse.setvalue(6)
		elseif CurrentLocation == RiftenHoneysideLocation
			CurrentFormlist = SLApproachPlayerHouseRiften
			SLApproachCurrentPlayerHouse.setvalue(7)
		elseif CurrentLocation == WindhelmHjerimLocation
			CurrentFormlist = SLApproachPlayerHouseWindhelm
			SLApproachCurrentPlayerHouse.setvalue(8)
		else
			SLApproachCurrentPlayerHouse.setvalue(0)
			return false
		endif

		if SLApproachMain.debugLogFlag
			Debug.notification("PlayerHouse " + SLApproachCurrentPlayerHouse.getvalue() as int)
		endif

		int iindex = CurrentFormlist.getsize()
		If iindex > 0
			iindex -= 1
			VisitorRef = CurrentFormlist.getat(Utility.randomint(1, iindex)) as actor

			if VisitorRef && SLApproachMain.debugLogFlag
				String VisitorStringRef = VisitorRef.GetBaseObject().getname() as string
				Debug.notification("Visitor's name is " + VisitorStringRef + "in " + iindex)
			elseif SLApproachMain.debugLogFlag
				Debug.notification("Visitor is not present")
			endif
		else
			if SLApproachMain.debugLogFlag
				Debug.notification("No Index")
			endif
		EndIf

		If VisitorRef == None
			if SLApproachMain.debugLogFlag
				Debug.notification("There's silence in my home.")
			endif
		endif
	Else
		if SLApproachMain.debugLogFlag
			Debug.notification("No Player House")
		endif
	Endif

	Return VisitorRef as Bool
EndFunction



Bool Function KnockKnock()
	If Utility.RandomInt(1, 100) > SLApproachPC.SLAHouseVisitChance
		Return False
	EndIf

	If !SLApproachScanningPlayerHouse.isrunning()
		Return False
	EndIf

	PCApproachOngoing = True

VisitorRef.moveto(SLAPPTestZoneXmarker)

PlayerHouseCenterMarker.ForceRefto(ExternalPlayerHouseCenterMarker.getreference())
PlayerHouseDoor.ForceRefto(ExternalPlayerHouseDoor.getreference())
PlayerHouseCOC.ForceRefto(ExternalPlayerHouseCOC.getreference())
FollowerRef.ForceRefto(ExternalFollowerRef.getreference())

talkingActor.ForceRefTo(VisitorRef)

rollRapeChance(VisitorRef)
SLApproachRapeToggle.setvalue(willRape as int)
PCVisitingBefore = true
PCVisitingAfter = false
VisitorKnocking(VisitorRef)

Return True
EndFunction

Function VisitorKnocking(actor visitor)

Alias_VisitorRef.Clear()
Alias_VisitorRef.ForceRefTo(visitor)

SLApproachScanningPlayerHouse.setstage(10)
Self.setstage(50)

;Moving a visitor in front of a door
;Dialogues are required
if SLApproachCurrentPlayerHouse.getvalue() == 1
	visitor.moveto(SLApproachMain.SLAPPXmarkerFrontDoorWhiterunRef)
elseif SLApproachCurrentPlayerHouse.getvalue() == 2
	visitor.moveto(SLApproachMain.SLAPPXmarkerFrontDoorBYOH01Ref)
elseif SLApproachCurrentPlayerHouse.getvalue() == 3
	visitor.moveto(SLApproachMain.SLAPPXmarkerFrontDoorBYOH02Ref)
elseif SLApproachCurrentPlayerHouse.getvalue() == 4
	visitor.moveto(SLApproachMain.SLAPPXmarkerFrontDoorBYOH03Ref)
elseif SLApproachCurrentPlayerHouse.getvalue() == 5
	visitor.moveto(SLApproachMain.SLAPPXmarkerFrontDoorSolitudeRef)
elseif SLApproachCurrentPlayerHouse.getvalue() == 6
	visitor.moveto(SLApproachMain.SLAPPXmarkerFrontDoorMarkarthRef)
elseif SLApproachCurrentPlayerHouse.getvalue() == 7
	visitor.moveto(SLApproachMain.SLAPPXmarkerFrontDoorRiftenRef)
elseif SLApproachCurrentPlayerHouse.getvalue() == 8
	visitor.moveto(SLApproachMain.SLAPPXmarkerFrontDoorWindhelmRef)
else
;Nothing
endif

	PCVisitingBefore = false
	PCVisitingon = true
	PCVisitingafter = false

EndFunction

Function VisitorEntering(actor visitor, objectreference entrance)
	PCVisitingBefore = false
	PCVisitingon = false
	PCVisitingafter = true
	slappUtil.HomeAlone();Detect actors around Player
	SetCharacter(visitor);Double check
	
	visitor.moveto(entrance)
	selectedScene = SLAppHousevisitScene
	selectedScene.forcestart()
	maxTime = (SLApproachMain.SLApproachTimelimit) + 30
	parent.startApproach(visitor)
EndFunction

Function registerHouse(Location akLocation)
Actor NPCtalkingActor = talkingActor.GetReference() as Actor
If aklocation == WhiterunBreezehomeLocation
	SLApproachPlayerHouseWhiterun.addform(NPCtalkingActor)
elseif aklocation == BYOHHouse1LocationInterior
	SLApproachPlayerHouseBYOH01.addform(NPCtalkingActor)
elseif aklocation == BYOHHouse2LocationInterior
	SLApproachPlayerHouseBYOH02.addform(NPCtalkingActor)
elseif aklocation == BYOHHouse3LocationInterior
	SLApproachPlayerHouseBYOH03.addform(NPCtalkingActor)
elseif aklocation == SolitudeProudspireManorLocation
	SLApproachPlayerHouseSolitude.addform(NPCtalkingActor)
elseif aklocation == MarkarthVlindrelHallLocation
	SLApproachPlayerHouseMarkarth.addform(NPCtalkingActor)
elseif aklocation == RiftenHoneysideLocation
	SLApproachPlayerHouseRiften.addform(NPCtalkingActor)
elseif aklocation == WindhelmHjerimLocation
	SLApproachPlayerHouseWindhelm.addform(NPCtalkingActor)
EndIf
NothingEnd()
EndFunction

Function UnregisterHouse(Actor akspeaker, int type)
	SLApproachPlayerHouseWhiterun.RemoveAddedForm(akspeaker)
	SLApproachPlayerHouseBYOH01.RemoveAddedForm(akspeaker)
	SLApproachPlayerHouseBYOH02.RemoveAddedForm(akspeaker)
	SLApproachPlayerHouseBYOH03.RemoveAddedForm(akspeaker)
	SLApproachPlayerHouseSolitude.RemoveAddedForm(akspeaker)
	SLApproachPlayerHouseMarkarth.RemoveAddedForm(akspeaker)
	SLApproachPlayerHouseRiften.RemoveAddedForm(akspeaker)
	SLApproachPlayerHouseWindhelm.RemoveAddedForm(akspeaker)
	if type == 1; No complain
		akspeaker.addtofaction(slapp_NoVisitFaction)
	elseif type == 2; complain
		akspeaker.addtofaction(slapp_NoVisitFaction)
		disagree(akspeaker, false)
	elseif type == 3; Rape
		akspeaker.addtofaction(slapp_NoVisitFaction)
		disagree(akspeaker, false)
		rapedPlusBy(akspeaker)
	endif
EndFunction

Function registerHouseTest(Location akLocation, Actor NPCtalkingActor)
If aklocation == WhiterunBreezehomeLocation
	SLApproachPlayerHouseWhiterun.addform(NPCtalkingActor)
elseif aklocation == BYOHHouse1LocationInterior
	SLApproachPlayerHouseBYOH01.addform(NPCtalkingActor)
elseif aklocation == BYOHHouse2LocationInterior
	SLApproachPlayerHouseBYOH02.addform(NPCtalkingActor)
elseif aklocation == BYOHHouse3LocationInterior
	SLApproachPlayerHouseBYOH03.addform(NPCtalkingActor)
elseif aklocation == SolitudeProudspireManorLocation
	SLApproachPlayerHouseSolitude.addform(NPCtalkingActor)
elseif aklocation == MarkarthVlindrelHallLocation
	SLApproachPlayerHouseMarkarth.addform(NPCtalkingActor)
elseif aklocation == RiftenHoneysideLocation
	SLApproachPlayerHouseRiften.addform(NPCtalkingActor)
elseif aklocation == WindhelmHjerimLocation
	SLApproachPlayerHouseWindhelm.addform(NPCtalkingActor)
EndIf
EndFunction

Function PreVisitorEntering()
;debug.notification("The visitor is entering.")
	ObjectReference PHCOC = PlayerHouseCOC.getreference()
	SLApproachScanningPlayerHouse.setstage(50)
	Self.setstage(60)
	if PHCOC
		VisitorEntering(VisitorRef, PHCOC)
	Else
		VisitorEntering(VisitorRef, PlayerRef)
	Endif
	SLAKnockCount.setvalue(0)

EndFunction

Function FirstVisit(Bool Rape)
	Actor akRef = talkingActor.GetReference() as Actor
	talkingactor.clear()
	stayingactor.forcerefto(akRef)
	SLAppHousevisitScene.stop()
	self.StayingTimeRegister(Rape)
EndFunction

Function StayingTimeRegister(Bool Rape)
	SLApproachScanningPlayerHouse.setstage(70); This indicates a visitor is gonna stay.
	SLApproachVisitorStaying.setvalue(1)
	(stayingactor.GetReference() as Actor).addtofaction(slapp_VisitingFaction)
	(stayingactor.GetReference() as Actor).Setactorvalue("Variable06", 0)
	if rape
		(stayingactor.GetReference() as Actor).addtofaction(slapp_VisitingRapistFaction)
	endif
	RegisterForSingleUpdateGameTime(SLApproachStayingTime.getvalue() as int)
EndFunction

Event OnUpdateGameTime()
;End of a visiting scenario.
if (stayingactor.GetReference() as Actor).isinfaction(slapp_VisitingEventFaction)
	(stayingactor.GetReference() as Actor).removefromfaction(slapp_VisitingEventFaction);Not used for now. It's gonna be used as Byebye contents
	;int randomi = Utility.randomint(5, 8); for future contents
	;(stayingactor.GetReference() as Actor).Setactorvalue("Variable06", randomi)
	RegisterForSingleUpdateGameTime(SLApproachStayingTime.getvalue() as int)
else
	CleartheHouse()
endif
EndEvent

Function CleartheHouse()
	SLApproachVisitorStaying.setvalue(0)
	(stayingactor.GetReference() as Actor).removefromfaction(slapp_VisitingFaction)
	(stayingactor.GetReference() as Actor).Setactorvalue("Variable06", 0)
	if (stayingactor.GetReference() as Actor).isinfaction(slapp_VisitingRapistFaction)
		(stayingactor.GetReference() as Actor).addtofaction(slapp_VisitedRapistFaction)
		(stayingactor.GetReference() as Actor).removefromfaction(slapp_VisitingRapistFaction)
	endif
	SLApproachScanningVisitor.stop()
	SLApproachScanningPlayerHouse.stop()
	Stayed()
EndFunction

;##########################
;########ResistBar#########
;##########################

SLAPQTEWidgetEx Property StruggleBar Auto
Quest Property SLApproach_Config Auto

Bool LeftRight = True
Int StrafeL
Int StrafeR
Float FillDifficulty = 0.0
Float FillThreshold = 0.0
Int ResistTime = 0
int Time = 0
Float DownedTime ; How much time the player will stay downed.
GlobalVariable property SLApproachHarassmentType Auto
GlobalVariable property SLApproachKissResist Auto
GlobalVariable property SLApproachFlirtType Auto
Scene Property SLAppAfterKiss Auto
Scene Property SLApproachTeasingHouseScene Auto

Function HugKissEnd(Actor akactor)
	Parent.FlirtAnim(akactor, False, 5)
	Utility.wait(12.0)
	Parent.RestoreControl(akactor)
	Self.Acquaintance(akactor)
EndFunction

Function StartFlirt(Actor akactor, int FlirtType, bool HouseVisit)
	SLApproachFlirtType.setvalue(FlirtType)
	Parent.FlirtAnim(akactor, True, FlirtType)
	if HouseVisit
		SLApproachTeasingHouseScene.forcestart()
	endif
EndFunction

Function StartHarassment(actor akactor, int HarassmentType)
	SLApproachHarassmentType.setvalue(HarassmentType)
	if HarassmentType == 1
		KissAnim(akactor)
	elseif HarassmentType == 2
	endif
	utility.wait(1.5)
	GotoState("Harassment")
EndFunction

Function StruggleBarDisplay(Bool Display = True)
	If Display
		StruggleBar.Alpha = 100.0
		If ((SLApproach_Config as SLApproachConfigScript).ResistType == "$Attack")
			StrafeL = Input.GetMappedKey("Left Attack/Block")
			StrafeR = Input.GetMappedKey("Right Attack/Block")
		Else
			StrafeL = Input.GetMappedKey("Strafe Left")
			StrafeR = Input.GetMappedKey("Strafe Right")
		Endif
		RegisterForKey(StrafeL)
		RegisterForKey(StrafeR)
	Else
		StruggleBar.Alpha = 0.0
		StruggleBar.Percent = 0.0
		FillDifficulty = 0.0
		UnregisterForKey(StrafeL)
		UnregisterForKey(StrafeR)
	EndIf
EndFunction

Function ResistSuccess(actor akactor)
	Restore()
	Parent.KissAnimResist(akactor)
	SLApproachKissResist.setvalue(1)
	SLAppAfterKiss.forcestart()
EndFunction

Function ResistFailed(actor akactor)
	Restore()
	Parent.KissAnimStop(akactor)
	SLApproachKissResist.setvalue(2)
	SLAppAfterKiss.forcestart()
;	Utility.wait(5.0)
;	NothingEnd()
EndFunction



Function Restore()
	Time = 0
	StruggleBarDisplay(False)
	GotoState("")
EndFunction

State Harassment

	Event OnBeginState()
		DownedTime = 15.0
		FillThreshold = 0.1
		StruggleBarDisplay(true)
		RegisterForSingleUpdate(1.0)
	EndEvent
	
	Event OnUpdate() ; Loop to check the situation every 1 second.
		Time += 1
		Actor akRef = talkingActor.GetReference() as Actor
		If StruggleBar.Percent >= 1.0
			ResistSuccess(akRef)
			Return
		Elseif Time > DownedTime
			ResistFailed(akRef)
			Return
		Endif
		if Time == 7.0
			Parent.PlayKissSound()
		endif
	StruggleBar.Alpha = 100.0
	RegisterForSingleUpdate(1.0)
	EndEvent
	
	Event OnKeyDown(Int KeyCode)
		If ((KeyCode == StrafeL) && LeftRight)
			LeftRight = False
			FillDifficulty += FillThreshold
			StruggleBar.Percent = (FillDifficulty)
		Elseif ((KeyCode == StrafeR) && !LeftRight)
			LeftRight = True
			FillDifficulty += FillThreshold
			StruggleBar.Percent = (FillDifficulty)
		Endif
	EndEvent
	
	Function StruggleBarDisplay(Bool Display = True)
	If Display
		StruggleBar.Alpha = 100.0
		If ((SLApproach_Config as SLApproachConfigScript).ResistType == "$Attack")
			StrafeL = Input.GetMappedKey("Left Attack/Block")
			StrafeR = Input.GetMappedKey("Right Attack/Block")
		Else
			StrafeL = Input.GetMappedKey("Strafe Left")
			StrafeR = Input.GetMappedKey("Strafe Right")
		Endif
		RegisterForKey(StrafeL)
		RegisterForKey(StrafeR)
	Else
		StruggleBar.Alpha = 0.0
		StruggleBar.Percent = 0.0
		FillDifficulty = 0.0
		UnregisterForKey(StrafeL)
		UnregisterForKey(StrafeR)
	EndIf
	
	EndFunction
	
	Function Restore()
		Time = 0
		StruggleBarDisplay(False)
		GotoState("")
	EndFunction
	
EndState

Function ForceAllocation(actor akactor)
	talkingActor.clear()
	talkingActor.ForceRefTo(akactor)
EndFunction

;####################################################
;################ JSON Import #######################
;####################################################

Function ImportPlayerStatus()

if SLA_BaboDialogue.getvalue() == 1

	String File = "../BaboDialogue/BaboDialoguePlayerStatus.json"
	String FileB = "../BaboDialogue/BaboDialogueConfig.json"
	
	WhiterunOrcFuckToyTitleRank = JsonUtil.GetintValue(File, "WhiterunOrcFuckToyTitleRank")
	RieklingThirskFuckToyTitleRank = JsonUtil.GetintValue(File, "RieklingThirskFuckToyTitleRank")
	NightgateInnVictoryTitleRank = JsonUtil.GetintValue(File, "NightgateInnVictoryTitleRank")
	NightgateInnFuckedTitleRank = JsonUtil.GetintValue(File, "NightgateInnFuckedTitleRank")
	InvestigationMarkarthTitleRank = JsonUtil.GetintValue(File, "InvestigationMarkarthTitleRank")
	DeviousNobleSonFuckToyTitleRank = JsonUtil.GetintValue(File, "DeviousNobleSonFuckToyTitleRank")
	ChallengerFucktoyTitleRank = JsonUtil.GetintValue(File, "ChallengerFucktoyTitleRank")
	ArgonianDisplayedFuckToyTitleRank = JsonUtil.GetintValue(File, "ArgonianDisplayedFuckToyTitleRank")
	ArgonianDefeatedTitleRank = JsonUtil.GetintValue(File, "ArgonianDefeatedTitleRank")
	LoanSharkSlaveTitleRank = JsonUtil.GetintValue(File, "LoanSharkSlaveTitleRank")
	PitifulHeroineTitleRank = JsonUtil.GetintValue(File, "PitifulHeroineTitleRank")
	
	BaboReputationint = JsonUtil.GetintValue(File, "BaboReputation")
	BaboPubicHairStyle = JsonUtil.GetintValue(FileB, "BaboPubicHairCheck")

	SLA_WhiterunOrcFuckToyTitleRank.setvalue(WhiterunOrcFuckToyTitleRank)
	SLA_RieklingThirskFuckToyTitleRank.setvalue(RieklingThirskFuckToyTitleRank)
	SLA_NightgateInnVictoryTitleRank.setvalue(NightgateInnVictoryTitleRank)
	SLA_NightgateInnFuckedTitleRank.setvalue(NightgateInnFuckedTitleRank)
	SLA_InvestigationMarkarthTitleRank.setvalue(InvestigationMarkarthTitleRank)
	SLA_DeviousNobleSonFuckToyTitleRank.setvalue(DeviousNobleSonFuckToyTitleRank)
	SLA_ChallengerFucktoyTitleRank.setvalue(ChallengerFucktoyTitleRank)
	SLA_ArgonianDisplayedFuckToyTitleRank.setvalue(ArgonianDisplayedFuckToyTitleRank)
	SLA_ArgonianDefeatedTitleRank.setvalue(ArgonianDefeatedTitleRank)
	SLA_LoanSharkSlaveTitleRank.setvalue(LoanSharkSlaveTitleRank)
	SLA_PitifulHeroineTitleRank.setvalue(PitifulHeroineTitleRank)

	SLA_BaboReputation.setvalue(BaboReputationint)
	SLA_BaboPubicHairStyle.setvalue(BaboPubicHairStyle)
endif
EndFunction


int WhiterunOrcFuckToyTitleRank
int RieklingThirskFuckToyTitleRank
int NightgateInnVictoryTitleRank
int NightgateInnFuckedTitleRank
int InvestigationMarkarthTitleRank
int DeviousNobleSonFuckToyTitleRank
int ChallengerFucktoyTitleRank
int ArgonianDisplayedFuckToyTitleRank
int ArgonianDefeatedTitleRank
int LoanSharkSlaveTitleRank
int PitifulHeroineTitleRank

int BaboPubicHairStyle
int BaboReputationint


GlobalVariable Property SLA_WhiterunOrcFuckToyTitleRank Auto
GlobalVariable Property SLA_RieklingThirskFuckToyTitleRank Auto
GlobalVariable Property SLA_NightgateInnVictoryTitleRank Auto
GlobalVariable Property SLA_NightgateInnFuckedTitleRank Auto
GlobalVariable Property SLA_InvestigationMarkarthTitleRank Auto
GlobalVariable Property SLA_DeviousNobleSonFuckToyTitleRank Auto
GlobalVariable Property SLA_ChallengerFucktoyTitleRank Auto
GlobalVariable Property SLA_ArgonianDisplayedFuckToyTitleRank Auto
GlobalVariable Property SLA_ArgonianDefeatedTitleRank Auto
GlobalVariable Property SLA_LoanSharkSlaveTitleRank Auto
GlobalVariable Property SLA_PitifulHeroineTitleRank Auto

GlobalVariable Property SLA_BaboReputation Auto
GlobalVariable Property SLA_BaboPubicHairStyle Auto

GlobalVariable Property SLA_BaboDialogue Auto

;####################################################
;################### SLHH MOD #######################
;####################################################

Function SLHHActivate(Actor pTarget, Actor pTargetFriend = None); Basically you don't need pTargetFriend. pTarget will become a criminal, who will try to rape you.
If SLApproachMain.enableSLHHFlag
	Keyword SLHHScriptEventKeyword = Game.GetFormFromFile(0x0000C510, "SexLabHorribleHarassment.esp") as Keyword
    SLHHScriptEventKeyword.SendStoryEvent(None, pTarget, pTargetFriend)
    ;SLHHScriptEventKeyword.SendStoryEvent(akLoc = None, akRef1 = pTarget, akRef2 = None, aiValue1 = 0, aiValue2 = 0)
EndIf
endFunction

Function SLHHChokeActivate(Actor pTarget, Actor pTargetFriend = None, int Sex)
If SLApproachMain.enableSLHHFlag
    Keyword SLHHScriptEventBCKeyword = Game.GetFormFromFile(0x0233C6, "SexLabHorribleHarassment.esp") as Keyword
	SLHHScriptEventBCKeyword.SendStoryEvent(None, pTarget, pTargetFriend, Sex, 0)
EndIf
endFunction 

Function SLHHDrinkActivate(Actor pTarget, Actor pTargetFriend = None, int Sex);When escape fail -> 0 = Sex 1 = NoSex, only knockout animation
If SLApproachMain.enableSLHHFlag
    Keyword SLHHScriptEventDrinkKeyword = Game.GetFormFromFile(0x02495B, "SexLabHorribleHarassment.esp") as Keyword
	SLHHScriptEventDrinkKeyword.SendStoryEvent(None, pTarget, pTargetFriend, Sex, 0)
EndIf
endFunction 


;####################################################
;################# BABODIALOGUE #####################
;####################################################


;Faction Function BDBaboAggressiveBoyFriend()
;	Faction BaboAggressiveBoyFriend = Game.GetFormFromFile(0x00BA9DDA, "BabointeractiveDia.esp") as Faction
;Return BaboAggressiveBoyFriend
;EndFunction


;Faction Function BDBaboViceGuardCaptainFaction()
;	Faction BaboViceGuardCaptainFaction = Game.GetFormFromFile(0x00B71E3E, "BabointeractiveDia.esp") as Faction
;Return BaboViceGuardCaptainFaction
;EndFunction


Function BaboAggressiveBoyFriendStack(Actor pTarget)
If !(pTarget.isinfaction(slapp_AggressiveBFFaction))
	pTarget.addtofaction(slapp_AggressiveBFFaction)
Endif
EndFunction

Actor VisitorRef


Function BaboDialogueTrigger(Actor Raper, Bool Worse = false)
	If Worse
		BaboDialogueEventRegister(Raper, True); SLHHConsequneceWorse, Rape
	Else
		BaboDialogueEventRegister(Raper, False); SLHHConsequneceBad, No Rape
	EndIf
EndFunction

Function BaboDialogueEventRegister(Actor Raper, Bool Worse)
	int handle = ModEvent.Create("BaboDialogue_ConsequenceEvent")
	if (handle)
		ModEvent.Pushform(handle, Raper)
		ModEvent.PushBool(handle, Worse)
		ModEvent.PushString(handle, "SLAPP activated BaboDialogueConsequence")
		ModEvent.Send(handle)
	endIf
EndFunction



;----------------------------Properties----------------------------

SLApproachMainScript Property SLApproachPC auto
Quest property SLApproachScanningPlayerHouse auto
Quest property SLApproachScanningVisitor auto
Quest Property SLApproachAskForSexQuest auto

SLAppSexUtil Property SexUtil Auto

Formlist Property SLApproachDDIList Auto
Formlist Property SLApproachDDIYokeList Auto

GlobalVariable Property SLA_DDI Auto
GlobalVariable Property sla_slsurvival Auto

GlobalVariable Property SLAKnockCount Auto
GlobalVariable Property SLApproachRapeToggle Auto

GlobalVariable Property SLApproachStayingTime Auto
GlobalVariable Property SLApproachRapedTimes Auto
GlobalVariable Property SLApproachAskNameTimes Auto
GlobalVariable Property SLApproachAskSexTimes Auto
GlobalVariable Property SLApproachNormalSexTimes Auto
GlobalVariable Property SLApproachProstitutionTimes Auto
GlobalVariable Property SLApproachProstitutionTryTimes Auto
GlobalVariable Property SLApproachGiftTimes Auto

GlobalVariable Property SLApproachProstitutionMin Auto
GlobalVariable Property SLApproachProstitutionMax Auto
GlobalVariable Property SLApproachProstitutionValue Auto
GlobalVariable Property SLApproachProstitutionFraudChance Auto

GlobalVariable Property SLApproachCurrentPlayerHouse Auto
GlobalVariable Property SLApproachVisitorStaying Auto

Faction Property ArousalFaction  Auto
Faction Property slapp_AggressiveBFFaction  Auto
Faction Property slapp_VisitedRapistFaction  Auto
Faction Property slapp_VisitingRapistFaction  Auto
Faction Property slapp_NoVisitFaction  Auto
Faction Property slapp_ThugFaction  Auto

ReferenceAlias Property Alias_VisitorRef  Auto  ; SLApproachScanningPlayerHouse
ReferenceAlias Property TalkingActor  Auto
ReferenceAlias Property StayingActor  Auto  

ReferenceAlias Property FollowerRef  Auto  
ReferenceAlias Property ExternalFollowerRef  Auto  

ReferenceAlias Property PlayerHouseCenterMarker Auto
ReferenceAlias Property ExternalPlayerHouseCenterMarker Auto

ReferenceAlias Property PlayerHouseDoor Auto
ReferenceAlias Property ExternalPlayerHouseDoor Auto

ReferenceAlias Property PlayerHouseCOC Auto
ReferenceAlias Property ExternalPlayerHouseCOC Auto

Scene Property SLAppHousevisitScene  Auto  
Scene Property SLAppAggressiveBFPCScene  Auto  
Scene Property SLAppViceGuardCaptainScene  Auto  
Scene Property SLAppAskingNameToPCScene  Auto  
Scene Property SLApproachHouseStayScene  Auto  
Scene Property SLApproachAskForSexQuestScene  Auto  
Scene Property SLApproachAskForSexQuestFollowPlayerScene Auto
Scene Property SLAppAfterDrink Auto
;Scene Property SLAppHugToPCScene  Auto
;Scene Property SLAppKissToPCScene  Auto  

Armor Property SLAppRingBeast  Auto  

Keyword Property ActorTypeNPC  Auto  
TalkingActivator Property SLAPP_MaleVisitorTalkingActivator  Auto  

Sound Property SLAPPMarker_DoorClose  Auto  
Sound Property SLAPPMarker_DoorKnob  Auto  
Sound Property SLAPPMarker_DoorKnock  Auto  

Message Property SLAPP_KnockingDoorMsg  Auto  


actorbase Property VisitorRefBase Auto
ObjectReference Property SLAPPTestZoneXmarker Auto