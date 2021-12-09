Scriptname SLApproachConfigScript extends SKI_ConfigBase  

SLApproachBaseQuestScript Property xscript Auto


String Property ResistType = "$Strafe" Auto Hidden
Int ResistTypeOID

Faction Property SLAX_BoobsTinyFaction Auto
Faction Property SLAX_BoobsNiceFaction Auto
Faction Property SLAX_BoobsAmazingFaction Auto
Faction Property SLAX_BoobsBigFaction Auto
Faction Property SLAX_BoobsFullFaction Auto
Faction Property SLAX_BoobsEnormousFaction Auto

Faction Property SLAX_FaceUglyFaction Auto
Faction Property SLAX_FacePlainFaction Auto
Faction Property SLAX_FaceAverageFaction Auto
Faction Property SLAX_FacePrettyFaction Auto
Faction Property SLAX_FaceBeautifulFaction Auto
Faction Property SLAX_FaceScarredFaction Auto

Faction Property SLAX_AssTinyFaction Auto
Faction Property SLAX_AssNiceFaction Auto
Faction Property SLAX_AssAmazingFaction Auto
Faction Property SLAX_AssBigFaction Auto

GlobalVariable Property sla_slsurvival Auto
GlobalVariable Property SLA_DDI Auto
GlobalVariable Property SLA_BaboDialogue Auto
GlobalVariable Property SLA_SLHH Auto

GlobalVariable Property SLApproachStayingTime Auto
GlobalVariable Property SLANakedArmorToggle Auto
GlobalVariable Property SLAAppearanceSlide Auto
GlobalVariable Property SLABreastsSlide Auto
GlobalVariable Property SLAButtsSlide Auto

GlobalVariable Property SLApproachDialogArousal auto
GlobalVariable Property SLApproachMultiplayPercent  Auto 

GlobalVariable Property SLAStandardLevelMaximumNPCGlobal  Auto 
GlobalVariable Property SLAStandardLevelMinimumNPCGlobal  Auto 

GlobalVariable Property SLApproachMoralGlobal  Auto 
GlobalVariable Property SLApproachRelationGlobal  Auto 

GlobalVariable Property SLApproachUniqueActorGlobal  Auto 

GlobalVariable Property SLApproachProstitutionMin  Auto 
GlobalVariable Property SLApproachProstitutionMax  Auto 
GlobalVariable Property SLApproachRapedTimes Auto
GlobalVariable Property SLApproachAskNameTimes Auto
GlobalVariable Property SLApproachAskSexTimes Auto
GlobalVariable Property SLApproachNormalSexTimes Auto
GlobalVariable Property SLApproachProstitutionTimes Auto
GlobalVariable Property SLApproachGiftTimes Auto
GlobalVariable Property SLADetectOutofSight Auto

GlobalVariable Property sla_Appearance Auto
GlobalVariable Property sla_BreastsScale Auto
GlobalVariable Property sla_ButtocksScale Auto


float property moral = 0.0 auto
float property moralmin = 0.0 auto
float property moralmax = 0.0 auto
float property Relation = 4.0 auto

Bool BaboDialogue_Installed
Bool SLHHExpansion_Installed
Bool SexlabSurvival_Installed
Bool DeviousDevicesIntegration_Installed

int SLAUniqueActorOID
int SLALocktheDoorOID
int SLARemoveHeelEffectOID
int SexlabSurvivalIntegrationOID
int SexlabDDIIntegrationOID

int SLHHIntegrationOID
int BDIntegrationOID

int SLAmoralOID
int SLAmoralMinOID
int SLAmoralMaxOID
int SLARelationOID
int SLADeviationLevelOID

int cloakFrequencyOID
int cloakRangeOID 
int cloakSightOID 
int baseChanceMultiplierOID 
int totalAwarnessRangeOID

int debugLogFlagOID
int enableRapeFlagOID

int enableForceThirdPersonHugOID
int enableRelationChangeFlagOID ; no longer used
int enableElderRaceFlagOID
int enableGuardFlagOID
int enableHirelingFlagOID
int enableFollowerFlagOID
int enableThalmorFlagOID
int enableChildFlagOID
int enableDremoraFlagOID
int enableVisitorFlagOID
int enablePetsFlagOID
int enablePlayerHorseFlagOID

int SLALowerLevelNPCOID
int SLAHigherLevelNPCOID
int SLAStandardLevelNPCOID

int PCAppearanceOID
int PCBreastsOID
int PCButtsOID

int NakedArmorOID

int lowestArousalPCOID
int lowestArousalNPCOID

int dialogueArousalOID

int userAddingPointPcOID
int userAddingPointNpcOID

int userAddingRapePointPcOID
int userAddingRapePointNpcOID

int userAddingAskingNamePointPcOID

int SLARelationshipChanceOID
int SLADislikeChanceOID

int SLAAquaintanceChanceOID
int SLAHouseVisitChanceOID
int SLAHouseStayDaysOID

int SLApproachProstitutionMinOID
int SLApproachProstitutionMaxOID

int SLApproachAskNameTimesOID
int SLApproachAskSexTimesOID 
int SLApproachGiftTimesOID
int SLApproachRapedTimesOID 
int SLApproachNormalSexTimesOID 
int SLApproachProstitutionTimesOID 

int multiplayPercentOID

int SLAppQuestScriptsOIDS
;int[] SLAppQuestScriptsOIDS

Perk Property SLAPPDoorLockKeyPerk Auto

int SLAUniqueBullyRiverwoodOID
Bool SLAUniqueBullyRiverwood = false

Quest Property SLApproachNPCManagement Auto

int SLAPPResetOID

Bool SLAPPResetToggle = false
SLAPPResetScript Property SLAPPReset Auto
SLApproachMainScript Property SLApproachMain Auto

Faction BaboAggressiveBoyFriend

Quest Property SLApproach_ExternalMods Auto

String[] Property SLAppHouseVisitListString Auto
int SLAppHouseVisitListInt
int SLAPPHouseVisitListOID

Event OnConfigClose()
	If SLAPPResetToggle
		SLAPPResetToggle = false
		SetToggleOptionValue(SLAPPResetOID, 0)
		SLAPPReset.ResetQuest()
	EndIf
EndEvent

int Function GetVersion()
	return 1; 1.0 Version
EndFunction

int Function GetVersionDecimal()
	return 0; 1.0 Version
EndFunction


Event OnVersionUpdate(int a_version)
	OnConfigInit()
EndEvent

Event OnGameReload()
	parent.OnGameReload()
	PageReset()
	VerifyMods()
	SLAPPForexternalmods()
	Debug.notification("$SLAppVersion")
EndEvent

Event OnConfigInit()
	PageReset()
EndEvent

Function PageReset()
	Pages = new string[5]
	Pages[0] = "$SLAppGeneral"
	Pages[1] = "$SLAppQuests"
	Pages[2] = "$SLAppCompatibility"
	Pages[3] = "$SLAppStatistics"
	Pages[4] = "$SLAppDebug"
	
	SLAppHouseVisitListString = new String[8]
	SLAppHouseVisitListString[0] = "$SLAppHouseVisitList00"
	SLAppHouseVisitListString[1] = "$SLAppHouseVisitList01"
	SLAppHouseVisitListString[2] = "$SLAppHouseVisitList02"
	SLAppHouseVisitListString[3] = "$SLAppHouseVisitList03"
	SLAppHouseVisitListString[4] = "$SLAppHouseVisitList04"
	SLAppHouseVisitListString[5] = "$SLAppHouseVisitList05"
	SLAppHouseVisitListString[6] = "$SLAppHouseVisitList06"
	SLAppHouseVisitListString[7] = "$SLAppHouseVisitList07"
EndFunction

Function VerifyMods()
	BaboDialogue_Installed = false
	SLHHExpansion_Installed = false
	SexlabSurvival_Installed = false
	DeviousDevicesIntegration_Installed = false
	
	If Quest.Getquest("BaboDialogueMCM")
		BaboDialogue_Installed = true
	Endif
	
	If Quest.GetQuest("SLHH")
		SLHHExpansion_Installed = true
	Endif

	If Quest.Getquest("_SLS_Main")
		SexlabSurvival_Installed = true
	Endif
	
	If Game.GetModByName("Devious Devices - Integration.esm") != 255
		DeviousDevicesIntegration_Installed = true
	Endif
EndFunction

Function SLAPPForexternalmods()
	if BaboDialogue_Installed
		SLA_BaboDialogue.setvalue(1)
		sla_Appearance = Game.GetFormFromFile(0x303B1D, "BaboInteractiveDia.esp") as GlobalVariable
		sla_BreastsScale = Game.GetFormFromFile(0x303B1E, "BaboInteractiveDia.esp") as GlobalVariable
		sla_ButtocksScale = Game.GetFormFromFile(0x303B1F, "BaboInteractiveDia.esp") as GlobalVariable
		
		SLAAppearanceSlide.setvalue(sla_Appearance.getvalue())
		SLABreastsSlide.setvalue(sla_BreastsScale.getvalue())
		SLAButtsSlide.setvalue(sla_ButtocksScale.getvalue())
		
		
		SLApproachMain.BaboAggressiveBoyFriend = Game.GetFormFromFile(0x00BA9DDA, "BabointeractiveDia.esp") as Faction
		SLApproachMain.BaboViceGuardCaptainFaction = Game.GetFormFromFile(0x00B71E3E, "BabointeractiveDia.esp") as Faction
		SLApproachMain.BaboDialogueFaction = Game.GetFormFromFile(0x00D58522, "BabointeractiveDia.esp") as Faction;BaboDialogueFaction
		SLApproachMain.BaboViceGuardCaptainFaction = Game.GetFormFromFile(0x00B71E3E, "BabointeractiveDia.esp") as Faction;BaboViceGuardCaptainFaction
		SLApproachMain.BaboWasHireling = Game.GetFormFromFile(0x00D6272A, "BabointeractiveDia.esp") as Faction;BaboWasHireling
		SLApproachMain.BaboPotentialHireling = Game.GetFormFromFile(0x00D62725, "BabointeractiveDia.esp") as Faction;BaboPotentialHireling
		SLApproachMain.BaboCurrentHireling = Game.GetFormFromFile(0x00C92D9D, "BabointeractiveDia.esp") as Faction;BaboCurrentHireling
		SLApproachMain.BaboChestWhiterunRef = Game.GetFormFromFile(0x00e46567, "BabointeractiveDia.esp") as objectreference
	endif
EndFunction

Function DisplayBaboPage()
	UnloadCustomContent()
	LoadCustomContent("SLAPP/SLAPPCover.dds",120,0)
EndFunction

event OnPageReset(string page)

	If Page == ("")
	
		DisplayBaboPage()
	
	ElseIf (page == "$SLAppGeneral")
	UnloadCustomContent()
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$SLAAppearanceSetting")
		
		PCAppearanceOID =  AddSliderOption("$SLAAppearance", SLAAppearanceSlide.getvalue(), "{0}")
		PCBreastsOID =  AddSliderOption("$SLABreasts", SLABreastsSlide.getvalue(), "{0}")
		PCButtsOID =  AddSliderOption("$SLAButts", SLAButtsSlide.getvalue(), "{0}")
		
		AddHeaderOption("$SLAppGeneral")
		
		cloakFrequencyOID =  AddSliderOption("$CloakFrequency", SLApproachMain.cloakFrequency, "$per0sec")
		cloakSightOID =  AddToggleOption("$CloakSight", SLADetectOutofSight.getvalue())
		baseChanceMultiplierOID =  AddSliderOption("$BaseChanceMultiplier", SLApproachMain.baseChanceMultiplier, "{1}")

		AddHeaderOption("$SLAppONOFF")

		enableRapeFlagOID = AddToggleOption("$EnableRape", SLApproachMain.enableRapeFlag)
		enableElderRaceFlagOID = AddToggleOption("$EnableElderRace", SLApproachMain.enableElderRaceFlag)
		enableFollowerFlagOID = AddToggleOption("$EnableFollower", SLApproachMain.enableFollowerFlag)
		enableHirelingFlagOID = AddToggleOption("$EnableHireling", SLApproachMain.enableHirelingFlag)
		enableGuardFlagOID = AddToggleOption("$EnableGuard", SLApproachMain.enableGuardFlag)
		enableChildFlagOID = AddToggleOption("$EnableChild", SLApproachMain.enableChildFlag)
		enableDremoraFlagOID = AddToggleOption("$EnableDremora", SLApproachMain.enableDremoraFlag)
;		enableThalmorFlagOID = AddToggleOption("$EnableThalmor", SLApproachMain.enableThalmorFlag) WIP
		
		NakedArmorOID = AddToggleOption("$SLANakedArmor", SLApproachMain.SLANakedArmor)

		SetCursorPosition(1)

		AddHeaderOption("$SLAppArousal")
		
		lowestArousalPCOID = AddSliderOption("$LowestArousalPC", SLApproachMain.lowestArousalPC)
		lowestArousalNPCOID = AddSliderOption("$LowestArousalNPC", SLApproachMain.lowestArousalNPC)
		dialogueArousalOID = AddSliderOption("$DialogueArousal", SLApproachDialogArousal.GetValue())
		
		AddHeaderOption("$SLAppMorality")
		
		SLAmoralOID =  addslideroption("Morality:", moral, "{0.0}")
		SLAmoralMinOID =  addslideroption("CharacterMin:", SLApproachMain.SLANPCCharacterMin, "{0.0}")
		SLAmoralMaxOID =  addslideroption("CharacterMax:", SLApproachMain.SLANPCCharacterMax, "{0.0}")
		SLARelationOID =  addslideroption("Relation:", Relation, "{0.0}")
		
		AddHeaderOption("$SLAppETC")
		
		SLAUniqueActorOID = AddToggleOption("$SLAUniqueActor", SLApproachMain.SLAUniqueActor)

;		enableForceThirdPersonHugOID = AddToggleOption("$EnableForceThirdPersonHug", SLApproachMain.enableForceThirdPersonHug)
		SLApproachProstitutionMinOID = AddSliderOption("$SLApproachProstitutionMin", SLApproachProstitutionMin.getvalue() as int, "{1}")
		SLApproachProstitutionMaxOID = AddSliderOption("$SLApproachProstitutionMax", SLApproachProstitutionMax.getvalue() as int, "{1}")
		
		SLARemoveHeelEffectOID = AddToggleOption("$SLARemoveHeelEffect", SLApproachMain.SLARemoveHeelEffect)
		SLALocktheDoorOID = AddToggleOption("$SLALocktheDoor", SLApproachMain.SLALocktheDoor)
		
		debugLogFlagOID = AddToggleOption("$OutputPapyrusLog", SLApproachMain.debugLogFlag)

	elseif (page == "$SLAppQuests")
	UnloadCustomContent()
		SetCursorFillMode(TOP_TO_BOTTOM)

		SetCursorPosition(0)
		AddHeaderOption("$RegisteredApproachQuests")
		
		SLAppQuestScriptsOIDS = AddToggleOption("$SLAPCQuest", !xscript.isSkipMode)
		
;		int indexCounter = 0 ; Not gonna use it until the NPC sex is complete
;		int amount = SLApproachMain.getRegisteredAmount()
;		SLAppQuestScriptsOIDS = new int[8]
		
;		while (indexCounter != amount)
;			SLApproachBaseQuestScript xscript = SLApproachMain.getApproachQuestScript(indexCounter)
;			SLAppQuestScriptsOIDS[indexCounter] = AddToggleOption(xscript.ApproachName, !xscript.isSkipMode)
;			indexCounter += 1
;		endwhile

		AddEmptyOption()
		AddHeaderOption("$RegisteredQuestsCommonOptions")

		multiplayPercentOID =  AddSliderOption("$SLAppMultiplayPercent", SLApproachMultiplayPercent.GetValue())

		SetCursorPosition(1)
		AddHeaderOption("$RegisteredQuestsOptions")
				
		SLAHigherLevelNPCOID = AddToggleOption("$SLAHigherLevelNPC", SLApproachMain.SLAHigherLevelNPC)
		SLALowerLevelNPCOID = AddToggleOption("$SLALowerLevelNPC", SLApproachMain.SLALowerLevelNPC)
		SLAStandardLevelNPCOID = AddToggleOption("$SLAStandardLevelNPC", SLApproachMain.SLAStandardLevelNPC)
		SLADeviationLevelOID =  AddSliderOption("$SLADeviationLevel", SLApproachMain.SLADeviationLevel, "{0}")
		
		userAddingPointPcOID =  AddSliderOption("$AddingPointsNPCPC", SLApproachMain.userAddingPointPc, "{0}")
		userAddingRapePointPcOID =  AddSliderOption("$AddingRapePointsNPCPC", SLApproachMain.userAddingRapePointPc, "{0}")
		userAddingAskingNamePointPcOID =  AddSliderOption("$AddingAskingNamePointsNPCPC", SLApproachMain.userAddingAskingNamePointPc, "{0}")
		
		SLARelationshipChanceOID =  AddSliderOption("$SLARelationshipChance", SLApproachMain.SLARelationshipChance, "{0}")
		SLAAquaintanceChanceOID =  AddSliderOption("$SLAAquaintanceChance", SLApproachMain.SLAAquaintanceChance, "{0}")
		SLADislikeChanceOID =  AddSliderOption("$SLADislikeChance", SLApproachMain.SLADislikeChance, "{0}")
		
		SetCursorPosition(2)
		
		AddHeaderOption("$SLAppUniqueNPC")
		;SLAUniqueBullyRiverwoodOID = AddToggleOption("$SLAUniqueBullyRiverwood", SLAUniqueBullyRiverwood) Experimental
		
		AddHeaderOption("$SLAppHouseVisit")
		
		SLAHouseVisitChanceOID =  AddSliderOption("$SLAHouseVisitChance", SLApproachMain.SLAHouseVisitChance, "{0}")
		SLAHouseStayDaysOID =  AddSliderOption("$SLAHouseStayDays", SLApproachStayingTime.getvalue(), "{0}")
		enableVisitorFlagOID = AddToggleOption("$EnableVisitor", SLApproachMain.enableVisitorFlag)
		
		AddHeaderOption("$SLAppResistKey")
		
		ResistTypeOID = AddTextOption("$ResistHotkey", ResistType)
	
;		userAddingPointNpcOID =  AddSliderOption("$AddingPointsNPCNPC", SLApproachMain.userAddingPointNpc, "{0}")
;		userAddingRapePointNpcOID =  AddSliderOption("$AddingRapePointsNPCNPC", SLApproachMain.userAddingRapePointNpc, "{0}")


	elseif (page == "$SLAppCompatibility")
	UnloadCustomContent()
		SetCursorFillMode(TOP_TO_BOTTOM)

		SetCursorPosition(0)
		AddHeaderOption("$SexlabmodsCompatibility")

		If SLHHExpansion_Installed
			SLHHIntegrationOID = AddToggleOption("$SLHHIntegration", SLApproachMain.enableSLHHFlag)
		Else
			SLApproachMain.enableSLHHFlag = false
			SetToggleOptionValue(SLHHIntegrationOID, SLApproachMain.enableSLHHFlag)
			SLA_SLHH.setvalue(0)
			SLHHIntegrationOID = AddToggleOption("$SLHHIntegration", SLApproachMain.enableSLHHFlag, OPTION_FLAG_DISABLED)
		Endif
		
		If BaboDialogue_Installed
			BDIntegrationOID = AddToggleOption("$BDIntegration", SLApproachMain.enableBDFlag)
		Else
			SLApproachMain.enableBDFlag = false
			SetToggleOptionValue(BDIntegrationOID, SLApproachMain.enableBDFlag)
			SLA_BaboDialogue.setvalue(0)
			BDIntegrationOID = AddToggleOption("$BDIntegration", SLApproachMain.enableBDFlag, OPTION_FLAG_DISABLED)
		Endif

		If SexlabSurvival_Installed
			SexlabSurvivalIntegrationOID = AddToggleOption("$SexlabSurvivalIntegration", SLApproachMain.enableSexlabSurvivalFlag)
		Else
			SLApproachMain.enableSexlabSurvivalFlag = false
			SetToggleOptionValue(SexlabSurvivalIntegrationOID, SLApproachMain.enableSexlabSurvivalFlag)
			sla_slsurvival.setvalue(0)
			SexlabSurvivalIntegrationOID = AddToggleOption("$SexlabSurvivalIntegration", SLApproachMain.enableSexlabSurvivalFlag, OPTION_FLAG_DISABLED)
		Endif
		
		If DeviousDevicesIntegration_Installed
			SexlabDDIIntegrationOID = AddToggleOption("$SexlabDDIIntegration", SLApproachMain.enableDDIFlag)
		Else
			SLApproachMain.enableDDIFlag = false
			SetToggleOptionValue(SexlabDDIIntegrationOID, SLApproachMain.enableDDIFlag)
			SLA_DDI.setvalue(0)
			SexlabDDIIntegrationOID = AddToggleOption("$SexlabDDIIntegration", SLApproachMain.enableDDIFlag, OPTION_FLAG_DISABLED)
		Endif
		
		
	elseif (page == "$SLAppStatistics")
		SetCursorFillMode(TOP_TO_BOTTOM)

		SetCursorPosition(0)
		AddHeaderOption("$SLAPPApproachStatistics")
		SLApproachAskNameTimesOID = Addtextoption("$SLApproachAskNameTimes", (SLApproachAskNameTimes.getvalue() as int) as string)
		SLApproachAskSexTimesOID = Addtextoption("$SLApproachAskSexTimes", (SLApproachAskSexTimes.getvalue() as int) as string)
		SLApproachGiftTimesOID = Addtextoption("$SLApproachGiftTimes", (SLApproachGiftTimes.getvalue() as int) as string)
		AddHeaderOption("$SLAPPSexStatistics")
		SLApproachRapedTimesOID = Addtextoption("$SLApproachRapedTimes", (SLApproachRapedTimes.getvalue() as int) as string)
		SLApproachNormalSexTimesOID = Addtextoption("$SLApproachNormalSexTimes", (SLApproachNormalSexTimes.getvalue() as int) as string)
		AddHeaderOption("$SLAPPProstitutionStatistics")
		SLApproachProstitutionTimesOID = Addtextoption("$SLApproachProstitutionTimes", (SLApproachProstitutionTimes.getvalue() as int) as string)
	elseif (page == "$SLAppDebug")
	UnloadCustomContent()
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		SetCursorPosition(0)
		AddHeaderOption("$SLAPPEmergency")
		;SLAPPHouseVisitListOID = AddMenuOption("$SLAppHouseVisitList", SLAppHouseVisitListString[SLAppHouseVisitListInt]) Experimental
		SLAPPResetOID = AddToggleOption("$SLAPPReset", SLAPPResetToggle)
		AddTextOption("Current scene: " + Game.getplayer().GetCurrentScene(), "", OPTION_FLAG_DISABLED)
	endif
endevent

formlist Property SLApproachPlayerHouseBYOH01 Auto
formlist Property SLApproachPlayerHouseWhiterun Auto

Event OnOptionMenuAccept(Int OptionID, Int MenuItemIndex)
	If OptionID == SLAPPHouseVisitListOID
		If MenuItemIndex >= 0 && MenuItemIndex < SLAppHouseVisitListString.Length
			SetMenuOptionValue(OptionID, SLAppHouseVisitListString[MenuItemIndex])
			SLAppHouseVisitListInt = MenuItemIndex
			
			if MenuItemIndex == 0
				SLApproachPlayerHouseWhiterun.getsize()
			elseif MenuItemIndex == 1
				actor House0 = SLApproachPlayerHouseBYOH01.getat(0) as actor
				actor House1 = SLApproachPlayerHouseBYOH01.getat(1) as actor
				actor House2 = SLApproachPlayerHouseBYOH01.getat(2) as actor
				String House0String = House0.GetBaseObject().GetName()
				String House1String = House1.GetBaseObject().GetName()
				String House2String = House2.GetBaseObject().GetName()
				String msg = House0 + ", " + House1 + ", " + House2 + ", "
				ShowMessage(msg, true, "Yes", "No")
			endif
			
		EndIf
	Endif
Endevent

Event OnOptionMenuOpen(Int OptionID)
	if OptionID == SLAPPHouseVisitListOID
		SetMenuDialogOptions(SLAppHouseVisitListString)
		SetMenuDialogStartIndex(SLAppHouseVisitListInt)
		SetMenuDialogDefaultIndex(0)
	Endif
EndEvent

Event OnOptionHighlight(int option)
	if (option == baseChanceMultiplierOID)
		SetInfoText("$BaseChanceMultiplierInfo")
	elseif (option == cloakSightOID)
		SetInfoText("$CloakSightInfo")
	elseif (option == enableRapeFlagOID)
		SetInfoText("$EnableRapeInfo")
	elseif (option == SLHHIntegrationOID)
		SetInfoText("$SLHHIntegrationInfo")
	elseif (option == BDIntegrationOID)
		SetInfoText("$BDIntegrationInfo")
	elseif (option == SexlabSurvivalIntegrationOID)
		SetInfoText("$SexlabSurvivalIntegrationInfo")
	elseif (option == SexlabDDIIntegrationOID)
		SetInfoText("$SexlabDDIIntegrationInfo")
	elseif (option == enablePetsFlagOID)
		SetInfoText("$EnablePetsInfo")
	elseif (option == enablePlayerHorseFlagOID)
		SetInfoText("$EnablePlayerHorseInfo")
	elseif (option == enableForceThirdPersonHugOID)
		SetInfoText("$EnableForceThirdPersonHugInfo")
	elseif (option == enableGuardFlagOID)
		SetInfoText("$EnableGuardInfo")
	elseif (option == enableChildFlagOID)
		SetInfoText("$EnableChildInfo")
	elseif (option == enableDremoraFlagOID)
		SetInfoText("$EnableDremoraInfo")
	elseif (option == enableVisitorFlagOID)
		SetInfoText("$EnableVisitorInfo")	
	elseif (option == enableHirelingFlagOID)
		SetInfoText("$EnableHirelingInfo")
	elseif (option == enableFollowerFlagOID)
		SetInfoText("$EnableFollowerInfo")
	elseif (option == enableThalmorFlagOID)
		SetInfoText("$EnableThalmorInfo")
	elseif (option == userAddingPointPcOID)
		SetInfoText("$AddingPointsNPCPCInfo")
	elseif (option == SLALowerLevelNPCOID)
		SetInfoText("$SLALowerLevelNPCInfo")
	elseif (option == SLAHigherLevelNPCOID)
		SetInfoText("$SLAHigherLevelNPCInfo")
	elseif (option == SLAStandardLevelNPCOID)
		SetInfoText("$SLAStandardLevelNPCInfo")
	elseif (option == SLADeviationLevelOID)
		SetInfoText("$SLADeviationLevelInfo")
	elseif (option == userAddingPointNpcOID)
		SetInfoText("$AddingPointsNPCNPCInfo")
	elseif (option == userAddingRapePointPcOID)
		SetInfoText("$AddingRapePointsNPCPCInfo")
	elseif (option == userAddingRapePointNpcOID)
		SetInfoText("$AddingRapePointsNPCNPCInfo")
	elseif (option == SLARelationshipChanceOID)
		SetInfoText("$SLARelationshipChanceInfo")
	elseif (option == userAddingAskingNamePointPcOID)
		SetInfoText("$AddingAskingNamePointsNPCPCInfo")
	elseif (option == SLADislikeChanceOID)
		SetInfoText("$SLADislikeChanceInfo")
	elseif (option == SLAAquaintanceChanceOID)
		SetInfoText("$SLAAquaintanceChanceInfo")
	elseif (option == SLAHouseVisitChanceOID)
		SetInfoText("$SLAHouseVisitChanceInfo")
	elseif (option == SLAHouseStayDaysOID)
		SetInfoText("$SLAHouseStayDaysInfo")
	elseif (option == lowestArousalPCOID)
		SetInfoText("$LowestArousalPCInfo")
	elseif (option == lowestArousalNPCOID)
		SetInfoText("$LowestArousalNPCInfo")
	elseif (option == dialogueArousalOID)
		SetInfoText("$DialogueArousalInfo")
	elseif (option == multiplayPercentOID)
		SetInfoText("$SLAppMultiplayPercentInfo")
	elseif (option == PCAppearanceOID)
		SetInfoText("$SLAAppearanceInfo")
	elseif (option == PCBreastsOID)
		SetInfoText("$SLABreastsInfo")
	elseif (option == PCButtsOID)
		SetInfoText("$SLAButtsInfo")
	elseif (option == NakedArmorOID)
		SetInfoText("$SLANakedArmorInfo")
	elseif (option == SLAUniqueActorOID)
		SetInfoText("$SLAUniqueActorinfo")
	elseif (option == SLALocktheDoorOID)
		SetInfoText("$SLALocktheDoorinfo")
	elseif (option == SLARemoveHeelEffectOID)
		SetInfoText("$SLARemoveHeelEffectinfo")
	elseif (option == SLAmoralOID)
		SetInfoText("$SLAmoralInfo")
	elseif (option == SLAmoralMinOID)
		SetInfoText("$SLAmoralMinInfo")
	elseif (option == SLAmoralMaxOID)
		SetInfoText("$SLAmoralMaxInfo")
	elseif (option == SLARelationOID)
		SetInfoText("$SLARelationInfo")
	elseif (option == SLAppQuestScriptsOIDS)
		SetInfoText("$SLAPCQuestInfo")
	elseif (option == SLApproachAskNameTimesOID)
		SetInfoText("$SLApproachAskNameTimesInfo")
	elseif (option == SLApproachAskSexTimesOID)
		SetInfoText("$SLApproachAskSexTimesInfo")
	elseif (option == SLApproachGiftTimesOID)
		SetInfoText("$SLApproachGiftTimesInfo")
	elseif (option == SLApproachNormalSexTimesOID)
		SetInfoText("$SLApproachNormalSexTimesInfo")
	elseif (option == SLApproachRapedTimesOID)
		SetInfoText("$SLApproachRapedTimesInfo")
	elseif (option == SLApproachProstitutionTimesOID)
		SetInfoText("$SLApproachProstitutionTimesInfo")
	elseif (option == SLApproachProstitutionMinOID)
		SetInfoText("$SLApproachProstitutionMinInfo")
	elseif (option == SLApproachProstitutionMaxOID)
		SetInfoText("$SLApproachProstitutionMaxInfo")
	elseif (option == SLAUniqueBullyRiverwoodOID)
		SetInfoText("$SLAUniqueBullyRiverwoodInfo")
	endif
EndEvent

event OnOptionSelect(int option)
	if(option == debugLogFlagOID)
		SLApproachMain.debugLogFlag = !SLApproachMain.debugLogFlag
		SetToggleOptionValue(debugLogFlagOID, SLApproachMain.debugLogFlag)

	elseif(option == enableGuardFlagOID)
		SLApproachMain.enableGuardFlag = !SLApproachMain.enableGuardFlag
		SetToggleOptionValue(enableGuardFlagOID, SLApproachMain.enableGuardFlag)
	elseif(option == enableChildFlagOID)
		SLApproachMain.enableChildFlag = !SLApproachMain.enableChildFlag
		SetToggleOptionValue(enableChildFlagOID, SLApproachMain.enableChildFlag)
	elseif(option == enableDremoraFlagOID)
		SLApproachMain.enableDremoraFlag = !SLApproachMain.enableDremoraFlag
		SetToggleOptionValue(enableDremoraFlagOID, SLApproachMain.enableDremoraFlag)
	elseif(option == enableVisitorFlagOID)
		SLApproachMain.enableVisitorFlag = !SLApproachMain.enableVisitorFlag
		SetToggleOptionValue(enableVisitorFlagOID, SLApproachMain.enableVisitorFlag)
	elseif(option == enableHirelingFlagOID)
		SLApproachMain.enableHirelingFlag = !SLApproachMain.enableHirelingFlag
		SetToggleOptionValue(enableHirelingFlagOID, SLApproachMain.enableHirelingFlag)
	elseif(option == enableFollowerFlagOID)
		SLApproachMain.enableFollowerFlag = !SLApproachMain.enableFollowerFlag
		SetToggleOptionValue(enableFollowerFlagOID, SLApproachMain.enableFollowerFlag)
	elseif(option == enableThalmorFlagOID)
		SLApproachMain.enableThalmorFlag = !SLApproachMain.enableThalmorFlag
		SetToggleOptionValue(enableThalmorFlagOID, SLApproachMain.enableThalmorFlag)
	elseif(option == enableRapeFlagOID)
		SLApproachMain.enableRapeFlag = !SLApproachMain.enableRapeFlag
		SetToggleOptionValue(enableRapeFlagOID, SLApproachMain.enableRapeFlag)
	elseif(option == cloakSightOID)
		if SLADetectOutofSight.getvalue() == 0
			SLADetectOutofSight.setvalue(1)
		else
			SLADetectOutofSight.setvalue(0)
		endif
		SetToggleOptionValue(cloakSightOID, SLADetectOutofSight.getvalue())
	elseif(option == SLHHIntegrationOID)
		SLApproachMain.enableSLHHFlag = !SLApproachMain.enableSLHHFlag
		SetToggleOptionValue(SLHHIntegrationOID, SLApproachMain.enableSLHHFlag)
		If SLApproachMain.enableSLHHFlag && SLHHExpansion_Installed
			SLA_SLHH.setvalue(1)
			SLApproachMain.SLHHScriptEventKeyword = Game.GetFormFromFile(0x0000C510, "SexLabHorribleHarassment.esp") as Keyword
		Else
			SLA_SLHH.setvalue(0)
		Endif
	elseif(option == BDIntegrationOID)
		SLApproachMain.enableBDFlag = !SLApproachMain.enableBDFlag
		SetToggleOptionValue(BDIntegrationOID, SLApproachMain.enableBDFlag)
		If SLApproachMain.enableBDFlag && BaboDialogue_Installed
			SLA_BaboDialogue.setvalue(1)
			SLApproachMain.BaboAggressiveBoyFriend = Game.GetFormFromFile(0x00BA9DDA, "BabointeractiveDia.esp") as Faction
			SLApproachMain.BaboViceGuardCaptainFaction = Game.GetFormFromFile(0x00B71E3E, "BabointeractiveDia.esp") as Faction
			SLApproachMain.BaboDialogueFaction = Game.GetFormFromFile(0x00D58522, "BabointeractiveDia.esp") as Faction;BaboDialogueFaction
			SLApproachMain.BaboViceGuardCaptainFaction = Game.GetFormFromFile(0x00B71E3E, "BabointeractiveDia.esp") as Faction;BaboViceGuardCaptainFaction
			SLApproachMain.BaboWasHireling = Game.GetFormFromFile(0x00D6272A, "BabointeractiveDia.esp") as Faction;BaboWasHireling
			SLApproachMain.BaboPotentialHireling = Game.GetFormFromFile(0x00D62725, "BabointeractiveDia.esp") as Faction;BaboPotentialHireling
			SLApproachMain.BaboCurrentHireling = Game.GetFormFromFile(0x00C92D9D, "BabointeractiveDia.esp") as Faction;BaboCurrentHireling
			SLApproachMain.BaboChestWhiterunRef = Game.GetFormFromFile(0x00e46567, "BabointeractiveDia.esp") as objectreference
		Else
			SLA_BaboDialogue.setvalue(0)
		EndIf

	elseif(option == SexlabSurvivalIntegrationOID)
		SLApproachMain.enableSexlabSurvivalFlag = !SLApproachMain.enableSexlabSurvivalFlag
		SetToggleOptionValue(SexlabSurvivalIntegrationOID, SLApproachMain.enableSexlabSurvivalFlag)
		If SLApproachMain.enableSexlabSurvivalFlag && SexlabSurvival_Installed
			sla_slsurvival.setvalue(1)

			(SLApproach_ExternalMods as SLApproachExternalScript).SetFormIDSLS()
		else
			sla_slsurvival.setvalue(0)
		EndIf
		
	elseif(option == SexlabDDIIntegrationOID)
		SLApproachMain.enableDDIFlag = !SLApproachMain.enableDDIFlag
		SetToggleOptionValue(SexlabDDIIntegrationOID, SLApproachMain.enableDDIFlag)
		If SLApproachMain.enableDDIFlag && DeviousDevicesIntegration_Installed
			SLA_DDI.setvalue(1)
			(SLApproach_ExternalMods as SLApproachExternalScript).SetFormIDDDI()
		Else
			SLA_DDI.setvalue(0)
		Endif
		
	elseif(option == SLAUniqueBullyRiverwoodOID)
		SLAUniqueBullyRiverwood = !SLAUniqueBullyRiverwood
		SetToggleOptionValue(SLAUniqueBullyRiverwoodOID, SLAUniqueBullyRiverwood)
		if !SLApproachNPCManagement.isrunning()
			SLApproachNPCManagement.start()
		endif
		if SLAUniqueBullyRiverwood
			(SLApproachNPCManagement as SLAppSpawnNPCs).spawnBullyNPCRiverwood()
		else
			(SLApproachNPCManagement as SLAppSpawnNPCs).DespawnBullyNPCRiverwood()
		endif
		
	elseif(option == SLAPPResetOID)
		SLAPPResetToggle = !SLAPPResetToggle
		SetToggleOptionValue(SLAPPResetOID, SLAPPResetToggle)
	elseif(option == SLALowerLevelNPCOID)
		SLApproachMain.SLALowerLevelNPC = !SLApproachMain.SLALowerLevelNPC
		SetToggleOptionValue(SLALowerLevelNPCOID, SLApproachMain.SLALowerLevelNPC)
	elseif(option == SLAHigherLevelNPCOID)
		SLApproachMain.SLAHigherLevelNPC = !SLApproachMain.SLAHigherLevelNPC
		SetToggleOptionValue(SLAHigherLevelNPCOID, SLApproachMain.SLAHigherLevelNPC)
	elseif(option == SLAStandardLevelNPCOID)
		SLApproachMain.SLAStandardLevelNPC = !SLApproachMain.SLAStandardLevelNPC
		SetToggleOptionValue(SLAStandardLevelNPCOID, SLApproachMain.SLAStandardLevelNPC)
	elseif(option == enablePetsFlagOID)
		SLApproachMain.enablePetsFlag = !SLApproachMain.enablePetsFlag
		SetToggleOptionValue(enablePetsFlagOID, SLApproachMain.enablePetsFlag)
	elseif(option == enablePlayerHorseFlagOID)
		SLApproachMain.enablePlayerHorseFlag = !SLApproachMain.enablePlayerHorseFlag
		SetToggleOptionValue(enablePlayerHorseFlagOID, SLApproachMain.enablePlayerHorseFlag)
	elseif(option == enableForceThirdPersonHugOID)
		SLApproachMain.enableForceThirdPersonHug = !SLApproachMain.enableForceThirdPersonHug
		SetToggleOptionValue(option, SLApproachMain.enableForceThirdPersonHug)
	elseif(option == enableElderRaceFlagOID)
		SLApproachMain.enableElderRaceFlag = !SLApproachMain.enableElderRaceFlag
		SetToggleOptionValue(enableElderRaceFlagOID, SLApproachMain.enableElderRaceFlag)

	elseif(option == NakedArmorOID)
		SLApproachMain.SLANakedArmor = !SLApproachMain.SLANakedArmor
		SetToggleOptionValue(NakedArmorOID, SLApproachMain.SLANakedArmor)
		SLANakedArmorToggle.setvalue(SLApproachMain.SLANakedArmor as int)
		
	elseif(option == SLAUniqueActorOID)
		SLApproachMain.SLAUniqueActor = !SLApproachMain.SLAUniqueActor
		SetToggleOptionValue(SLAUniqueActorOID, SLApproachMain.SLAUniqueActor)
		SLApproachUniqueActorGlobal.setvalue(SLApproachMain.SLAUniqueActor as int)
	elseif(option == SLALocktheDoorOID)
		SLApproachMain.SLALocktheDoor = !SLApproachMain.SLALocktheDoor
		SetToggleOptionValue(SLALocktheDoorOID, SLApproachMain.SLALocktheDoor)
		if SLApproachMain.SLALocktheDoor
			Game.getplayer().addperk(SLAPPDoorLockKeyPerk)
		else
			Game.getplayer().removeperk(SLAPPDoorLockKeyPerk)
		endif
	elseif(option == SLARemoveHeelEffectOID)
		SLApproachMain.SLARemoveHeelEffect = !SLApproachMain.SLARemoveHeelEffect
		SetToggleOptionValue(SLARemoveHeelEffectOID, SLApproachMain.SLARemoveHeelEffect)
	elseif(option == SLAppQuestScriptsOIDS)
		bool opt = xscript.isSkipMode
		xscript.isSkipMode = !opt
		SetToggleOptionValue(SLAppQuestScriptsOIDS, opt)
	elseif (option == ResistTypeOID)
		If ResistType == "$Strafe"
			ResistType = "$Attack"
		Else
			ResistType = "$Strafe"
		Endif
		SetTextOptionValue(Option, ResistType)
;	elseif (SLAppQuestScriptsOIDS.Find(option) > -1)
;		int idx = SLAppQuestScriptsOIDS.Find(option)
;		SLApproachBaseQuestScript xscript = SLApproachMain.getApproachQuestScript(idx)
;		bool opt = xscript.isSkipMode
;		xscript.isSkipMode = !opt
;		SetToggleOptionValue(option, opt)
	endif
endevent

event OnOptionSliderOpen(int option)
	if (option == cloakFrequencyOID)
		SetSliderDialogStartValue(SLApproachMain.cloakFrequency)
		SetSliderDialogDefaultValue(70)
		SetSliderDialogRange(10, 240)
		SetSliderDialogInterval(1)
	elseif (option == baseChanceMultiplierOID)
		SetSliderDialogStartValue(SLApproachMain.baseChanceMultiplier)
		SetSliderDialogDefaultValue(0.8)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	elseif (option == PCAppearanceOID)
		SetSliderDialogStartValue(SLAAppearanceSlide.getvalue())
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)
	elseif (option == PCBreastsOID)
		SetSliderDialogStartValue(SLABreastsSlide.getvalue())
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0.0, 120.0)
		SetSliderDialogInterval(1)	
	elseif (option == PCButtsOID)
		SetSliderDialogStartValue(SLAButtsSlide.getvalue())
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1)		
	elseif (option == userAddingPointPcOID)
		SetSliderDialogStartValue(SLApproachMain.userAddingPointPc)
		SetSliderDialogDefaultValue(-20)
		SetSliderDialogRange(-150, 100)
		SetSliderDialogInterval(1)
	elseif (option == SLADeviationLevelOID)
		SetSliderDialogStartValue(SLApproachMain.SLADeviationLevel)
		SetSliderDialogDefaultValue(5)
		SetSliderDialogRange(1, 15)
		SetSliderDialogInterval(1)
	elseif (option == userAddingPointNpcOID)
		SetSliderDialogStartValue(SLApproachMain.userAddingPointNpc)
		SetSliderDialogDefaultValue(-10)
		SetSliderDialogRange(-100, 100)
		SetSliderDialogInterval(1)

	elseif option == SLAmoralOID
		SetSliderDialogStartValue(moral)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 3.0)
		SetSliderDialogInterval(1.0)

	elseif option == SLAmoralMinOID
		SetSliderDialogStartValue(SLApproachMain.SLANPCCharacterMin)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 4.0)
		SetSliderDialogInterval(1.0)
	elseif option == SLAmoralMaxOID
		SetSliderDialogStartValue(SLApproachMain.SLANPCCharacterMax)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 4.0)
		SetSliderDialogInterval(1.0)
		
	elseif option == SLARelationOID
		SetSliderDialogStartValue(Relation)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(-3.0, 5.0)
		SetSliderDialogInterval(1.0)
		
	elseif (option == userAddingRapePointPcOID)
		SetSliderDialogStartValue(SLApproachMain.userAddingRapePointPc)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(-150, 100)
		SetSliderDialogInterval(1)
	elseif (option == userAddingRapePointNpcOID)
		SetSliderDialogStartValue(SLApproachMain.userAddingRapePointNpc)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(-150, 100)
		SetSliderDialogInterval(1)

	elseif (option == userAddingAskingNamePointPcOID)
		SetSliderDialogStartValue(SLApproachMain.userAddingAskingNamePointPc)
		SetSliderDialogDefaultValue(-20)
		SetSliderDialogRange(-150, 100)
		SetSliderDialogInterval(1)

	elseif (option == SLApproachProstitutionMinOID)
		SetSliderDialogStartValue(SLApproachProstitutionMin.getvalue() as int)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 2000)
		SetSliderDialogInterval(1)
	elseif (option == SLApproachProstitutionMaxOID)
		SetSliderDialogStartValue(SLApproachProstitutionMax.getvalue() as int)
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 2000)
		SetSliderDialogInterval(1)
		
	elseif (option == SLARelationshipChanceOID)
		SetSliderDialogStartValue(SLApproachMain.SLARelationshipChance)
		SetSliderDialogDefaultValue(40)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)	
	elseif (option == SLADislikeChanceOID)
		SetSliderDialogStartValue(SLApproachMain.SLADislikeChance)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)

	elseif (option == SLAAquaintanceChanceOID)
		SetSliderDialogStartValue(SLApproachMain.SLAAquaintanceChance)
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	elseif (option == SLAHouseVisitChanceOID)
		SetSliderDialogStartValue(SLApproachMain.SLAHouseVisitChance)
		SetSliderDialogDefaultValue(5)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)

	elseif (option == SLAHouseStayDaysOID)
		SetSliderDialogStartValue(SLApproachStayingTime.getvalue())
		SetSliderDialogDefaultValue(24)
		SetSliderDialogRange(0, 96)
		SetSliderDialogInterval(1)

	elseif (option == lowestArousalPCOID)
		SetSliderDialogStartValue(SLApproachMain.lowestArousalPC)
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	elseif (option == lowestArousalNPCOID)
		SetSliderDialogStartValue(SLApproachMain.lowestArousalNPC)
		SetSliderDialogDefaultValue(10)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)

	elseif (option == dialogueArousalOID)
		SetSliderDialogStartValue(SLApproachDialogArousal.GetValue())
		SetSliderDialogDefaultValue(90)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	elseif (option == multiplayPercentOID)
		SetSliderDialogStartValue(SLApproachMultiplayPercent.GetValue())
		SetSliderDialogDefaultValue(10)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1)
	endif
endevent

event OnOptionSliderAccept(int option, float value)
	if (option == cloakFrequencyOID)
		SLApproachMain.cloakFrequency= value as Int
		SetSliderOptionValue(cloakFrequencyOID, SLApproachMain.cloakFrequency, "$per0sec")
	elseif (option == baseChanceMultiplierOID )
		SLApproachMain.baseChanceMultiplier= value
		SetSliderOptionValue(baseChanceMultiplierOID , SLApproachMain.baseChanceMultiplier, "{1}")
	elseif (option == PCAppearanceOID)
		SLApproachMain.SLAPCAppearance = value as Int
		SLAAppearanceSlide.SetValue(Value)
		SetSliderOptionValue(option, value as Int, "{0}")
	elseif (option == PCBreastsOID)
		SLApproachMain.SLAPCBreasts = value as Int
		SLABreastsSlide.SetValue(Value)
		SetSliderOptionValue(option, value as Int, "{0}")
	elseif (option == PCButtsOID)
		SLApproachMain.SLAPCButts = value as Int
		SLAButtsSlide.SetValue(Value)
		SetSliderOptionValue(option, value as Int, "{0}")

	elseIf Option == SLAmoralOID
		Moral = value
		SetSliderOptionValue(SLAmoralOID, Moral, "{0.0}")
		SLApproachMoralGlobal.SetValue(moral)
	elseIf Option == SLAmoralMinOID
		SetSliderOptionValue(SLAmoralMinOID, value, "{0.0}")
		SLApproachMain.SLANPCCharacterMin = value as int
		if SLApproachMain.SLANPCCharacterMax < SLApproachMain.SLANPCCharacterMin
			SLApproachMain.SLANPCCharacterMax = (value + 1) as int
		endif
	elseIf Option == SLAmoralMaxOID
		SetSliderOptionValue(SLAmoralMaxOID, value, "{0.0}")
		SLApproachMain.SLANPCCharacterMax = value as int
		if SLApproachMain.SLANPCCharacterMin > SLApproachMain.SLANPCCharacterMax
			SLApproachMain.SLANPCCharacterMin = (value - 1) as int
		endif
		
	elseIf Option == SLARelationOID
		Relation = value
		SetSliderOptionValue(SLARelationOID, Relation, "{0.0}")
		SLApproachRelationGlobal.SetValue(Relation)

	elseif (option == SLApproachProstitutionMinOID)
		SLApproachProstitutionMin.setvalue(value as Int)
		SetSliderOptionValue(SLApproachProstitutionMinOID , SLApproachProstitutionMin.getvalue() as int, "{0.0}")
		if SLApproachProstitutionMin.getvalue() >= SLApproachProstitutionMax.getvalue()
			SLApproachProstitutionMax.setvalue(SLApproachProstitutionMin.getvalue() + 1)
			SetSliderOptionValue(SLApproachProstitutionMaxOID , SLApproachProstitutionMax.getvalue() as int, "{0.0}")
		endif
	elseif (option == SLApproachProstitutionMaxOID)
		SLApproachProstitutionMax.setvalue(value as Int)
		SetSliderOptionValue(SLApproachProstitutionMaxOID , SLApproachProstitutionMax.getvalue() as int, "{0.0}")
		if SLApproachProstitutionMax.getvalue() <= SLApproachProstitutionMin.getvalue()
			SLApproachProstitutionMin.setvalue(SLApproachProstitutionMax.getvalue() - 1)
			SetSliderOptionValue(SLApproachProstitutionMinOID , SLApproachProstitutionMin.getvalue() as int, "{0.0}")
		endif
		
	elseif (option == SLADeviationLevelOID)
		SLApproachMain.SLADeviationLevel = value as Int
		SetSliderOptionValue(SLADeviationLevelOID , SLApproachMain.SLADeviationLevel)
		SLAStandardLevelMaximumNPCGlobal.value = (Game.getplayer().getlevel()) + value
		SLAStandardLevelMinimumNPCGlobal.value = (Game.getplayer().getlevel()) - value
	elseif (option == userAddingPointPcOID)
		SLApproachMain.userAddingPointPc = value as Int
		SetSliderOptionValue(userAddingPointPcOID , SLApproachMain.userAddingPointPc)
	elseif (option == userAddingPointNpcOID)
		SLApproachMain.userAddingPointNpc = value as Int
		SetSliderOptionValue(userAddingPointNpcOID , SLApproachMain.userAddingPointNpc)
		
	elseif (option == userAddingRapePointPcOID)
		SLApproachMain.userAddingRapePointPc = value as Int
		SetSliderOptionValue(userAddingRapePointPcOID , SLApproachMain.userAddingRapePointPc)
	elseif (option == userAddingRapePointNpcOID)
		SLApproachMain.userAddingRapePointNpc = value as Int
		SetSliderOptionValue(userAddingRapePointNpcOID , SLApproachMain.userAddingRapePointNpc)

	elseif (option == userAddingAskingNamePointPcOID)
		SLApproachMain.userAddingAskingNamePointPc = value as Int
		SetSliderOptionValue(userAddingAskingNamePointPcOID, SLApproachMain.userAddingAskingNamePointPc)
		
	elseif (option == SLARelationshipChanceOID)
		SLApproachMain.SLARelationshipChance = value as Int
		SetSliderOptionValue(SLARelationshipChanceOID, SLApproachMain.SLARelationshipChance)
	elseif (option == SLADislikeChanceOID)
		SLApproachMain.SLADislikeChance = value as Int
		SetSliderOptionValue(SLADislikeChanceOID, SLApproachMain.SLADislikeChance)
		
	elseif (option == SLAAquaintanceChanceOID)
		SLApproachMain.SLAAquaintanceChance = value as Int
		SetSliderOptionValue(SLAAquaintanceChanceOID, SLApproachMain.SLAAquaintanceChance)
		
	elseif (option == SLAHouseVisitChanceOID)
		SLApproachMain.SLAHouseVisitChance = value as Int
		SetSliderOptionValue(SLAHouseVisitChanceOID, SLApproachMain.SLAHouseVisitChance)
	
	elseif (option == SLAHouseStayDaysOID)
		SLApproachStayingTime.setvalue(value as int)
		SetSliderOptionValue(SLAHouseStayDaysOID, SLApproachStayingTime.getvalue())
		
	elseif (option == lowestArousalPCOID)
		SLApproachMain.lowestArousalPC = value as Int
		SetSliderOptionValue(lowestArousalPCOID, SLApproachMain.lowestArousalPC)
	elseif (option == lowestArousalNPCOID)
		SLApproachMain.lowestArousalNPC = value as Int
		SetSliderOptionValue(lowestArousalNPCOID, SLApproachMain.lowestArousalNPC)

	elseif (option == dialogueArousalOID)
		SLApproachDialogArousal.SetValue(value as Int)
		SetSliderOptionValue(dialogueArousalOID, SLApproachDialogArousal.GetValue())
	elseif (option == multiplayPercentOID)
		SLApproachMultiplayPercent.SetValue(value as Int)
		SetSliderOptionValue(multiplayPercentOID, SLApproachMultiplayPercent.GetValue())

	endif
endevent


