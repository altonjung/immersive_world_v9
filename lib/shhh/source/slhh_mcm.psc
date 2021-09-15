Scriptname SLHH_MCM extends SKI_ConfigBase conditional

SLHH_Upkeep Property SLHHUpkeep Auto
slhh_Monitor Property SLHHMonitor Auto

;OIDs
int MonologueOID
int YellingOID
int RunningOID
int AbortForceGreetIntervalOID
int ScaleSettingOID
int YesClothesOID
int WomanAttackOID
int EscapeChanceOID
int CommentChanceOID
int StageChanceOID
int dangerousConditionOID
int MotionresetOID
int resetOID
int enableOID
int AnimOID
int RelationOID
int moralOID
int threesomeOID
int NighttimeOID
int TimeoutOID
int CompanionOID
int BaboDialogueOID
int StripCountCriterionOID
int StripPossibilityOID
int ResistMethodOID
int DamageActorValueOID
int NegoArmorStripintOID

int[] ToggleSlotID
int[] SlotValue
bool[] bToggleSlot
String[] ResistMethod
String[] DamageActorValue

;Properties
GlobalVariable Property SLHH_Monologue auto
GlobalVariable Property SLHH_Yelling auto
GlobalVariable Property SLHH_Running auto
GlobalVariable Property SLHH_AbortForceGreetInterval auto
GlobalVariable Property SLHH_ScaleSetting auto
GlobalVariable Property SLHH_Switch auto
GlobalVariable Property SLHH_YesClothes auto
GlobalVariable Property SLHH_WomanAttack auto
GlobalVariable Property SLHH_EscapeChance auto
GlobalVariable Property SLHH_Chance auto
GlobalVariable Property SLHH_relation auto
GlobalVariable Property SLHH_moral auto
GlobalVariable Property SLHH_timeout auto
GlobalVariable Property SLHH_nighttime auto
GlobalVariable Property GameHour auto
GlobalVariable Property SLHHSlotMask auto
GlobalVariable Property SLHHSlotMaskB auto
GlobalVariable Property SLHH_ResistMethodGlobal Auto
GlobalVariable Property SLHH_DamageActorValueGlobal Auto
Quest Property SLHH auto
Quest Property SLHHMonitorScript auto
SLHHResetQuestScript Property SLHHRQS auto
Quest Property SLHHResetQuest auto
bool property enable = true auto conditional
float property EscapeChance = 10.0 auto	
float property StripCountCriterion = 12.0 auto	
float property StripPossibility = 80.0 auto	
float property CommentChance = 80.0 auto	
float property StageChance = 50.0 auto
bool property dangerousCondition = false auto conditional
bool property scalesetting = false auto conditional
bool property reset = false auto
bool property Motionreset = false auto
string property anim = "Aggressive" auto
float property moral = 0.0 auto
float property relation = 4.0 auto
float property threesome = 50.0 auto
bool property nighttime = false auto
bool property companion = true auto
bool property BaboDialogueCheck = false auto
float property timeout = 1.0 auto
bool property Clothes = false auto
float property Abort = 3.0 auto
bool property Monologue = false auto
bool property Yell = false auto
bool property Run = false auto
bool property Woman = false auto
Bool ResetSwitch = false
Bool property BaboDialogue_Installed = false auto

Function CompatibilitySwitch(Bool Button)
If Button
	SLHH_Switch.setvalue(1)
Else
	SLHH_Switch.setvalue(0)
EndIf

EndFunction

Function VerifyMods()
	BaboDialogue_Installed = false
	
	If Quest.Getquest("BaboDialogueMCM")
		BaboDialogue_Installed = true
	Endif
EndFunction

Function PageReset()
	Pages = new string[2]
	Pages[0] = "$SLHH_Setting"
	Pages[1] = "$SLHH_ClothingSetting"
	
    ToggleSlotID = new int[32]
    SlotValue = new int[32]
	bToggleSlot = new Bool[32]
		
	ResistMethod = new String[4]
	ResistMethod[0] = "$SLHH_ResistMethod_OnlyBaseChance"
	ResistMethod[1] = "$SLHH_ResistMethod_OnlyStamina"
	ResistMethod[2] = "$SLHH_ResistMethod_OnlyLevel"
	ResistMethod[3] = "$SLHH_ResistMethod_BothStaminaLevel"

	DamageActorValue = new String[4]
	DamageActorValue[0] = "$SLHH_DamageActorValue_None"
	DamageActorValue[1] = "$SLHH_DamageActorValue_OnlyStamina"
	DamageActorValue[2] = "$SLHH_DamageActorValue_OnlyMagicka"
	DamageActorValue[3] = "$SLHH_DamageActorValue_BothStaminaMagicka"
EndFunction

Event OnGameReload()
	parent.OnGameReload() ; Don't forget to call the parent!
	PageReset()
	VerifyMods()
EndEvent


event OnConfigInit()
	PageReset()
	VerifyMods()
endevent

Event OnConfigClose()
If !ResetSwitch
	;Do nothing
else
	SLHHRQS.ResetCurrentQuest()	;Debug.Notification("SLHH Quest resetted!")
	ResetSwitch = False
EndIf

If MotionReset
	SLHHUpkeep.EscapeSucess()
	Motionreset = False
	SetToggleOptionValue(MotionResetOID, Motionreset)
else
	;Do nothing
Endif

EndEvent

event OnPageReset(string Page)

SetCursorFillMode(TOP_TO_BOTTOM)

if page == "$SLHH_Setting"
	AddHeaderOption("$SLHH_SLHHTitle")
	AddEmptyOption()
	enableOID = AddToggleOption("Enabled", enable)
	commentChanceOID =  addslideroption("$SLHH_HarassmentChance", CommentChance, "{0.0}")
	EscapeChanceOID =  addslideroption("$SLHH_EscapeChance", Escapechance, "{0.0}")
	StripCountCriterionOID =  addslideroption("$SLHH_StripCountCriterion", StripCountCriterion, "{0.0}")
	StripPossibilityOID =  addslideroption("$SLHH_StripPossibility", StripPossibility, "{0.0}")
	StageChanceOID =  addslideroption("$SLHH_RepeatedStageChance", stageChance, "{0.0}")
	AddEmptyOption()
	ResistMethodOID = AddMenuOption("$SLHH_ResistMethod", ResistMethod[SLHH_ResistMethodGlobal.GetValue() As Int])
	DamageActorValueOID = AddMenuOption("$SLHH_DamageActorValue", DamageActorValue[SLHH_DamageActorValueGlobal.GetValue() As Int])
	AddHeaderOption("$SLHH2ndRepetitionChance" + (stagechance * 0.67), OPTION_FLAG_DISABLED)
	AddHeaderOption("$SLHH3rdRepetitionChance" + (stagechance * 0.34), OPTION_FLAG_DISABLED)
	ScaleSettingOID = AddToggleOption("$SLHH_ScaleSetting", scalesetting)
	animOID = AddTextOption("$SLHH_AnimationSetting", anim)
	AddEmptyOption()
	MotionResetOID = AddToggleOption("$SLHH_MotionReset", Motionreset)
	ResetOID = AddToggleOption("$SLHH_ResetQuest", reset)
	
	SetCursorPosition(3)
	
	relationOID =  addslideroption("$SLHH_RelationshipRank", relation, "{0.0}")
	moralOID =  addslideroption("$SLHH_Morality", moral, "{0.0}")
	threesomeOID =  addslideroption("$SLHH_Threesomechance", threesome, "{0.0}")
	companionOID = AddToggleOption("$SLHH_AttackFollower", companion)
	timeoutOID =  addslideroption("$SLHH_Timeout", timeout, "{0.0}")
	nighttimeOID = AddToggleOption("$SLHH_OnlyAtNight", nighttime)
	YesClothesOID = AddToggleOption("$SLHH_Nosexyclothes", Clothes)
	AbortForceGreetIntervalOID = addslideroption("$SLHH_AbortForceGreetInterval", Abort, "{0.0}")
	YellingOID = AddToggleOption("$SLHH_Arapistyell", Yell)
	RunningOID = AddToggleOption("$SLHH_Arapistruns", Run)
	MonologueOID = AddToggleOption("$SLHH_Playermonologue", Monologue)
	WomanAttackOID = AddToggleOption("$SLHH_WomenharassPC", Woman)
	NegoArmorStripintOID = addslideroption("$SLHH_NegoArmorStripint", SLHHUpkeep.NegoArmorStripint, "{0.0}")
	AddHeaderOption("$SLHH_SLHHCompatibility")
	if BaboDialogue_Installed
		BaboDialogueOID = AddToggleOption("$SLHH_BaboDialogue", BaboDialogueCheck)
	else
		BaboDialogueOID = AddToggleOption("$SLHH_BaboDialogue", BaboDialogueCheck, OPTION_FLAG_DISABLED)
	endif
	
elseif page == "$SLHH_ClothingSetting"
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$SLHH_SLHHClothingToggle")
	bToggleSlot = GetUnignoredArmorSlots(SLHHSlotMask, SLHHSlotMaskB)
	ToggleSlotID[0] = AddToggleOption("30 - Head", bToggleSlot[0])
	ToggleSlotID[1] = AddToggleOption("31 - Hair", bToggleSlot[1])
	;ToggleSlotID[2] = AddToggleOption("32 - Body", bToggleSlot[2])
	ToggleSlotID[3] = AddToggleOption("33 - Hands", bToggleSlot[3])
	ToggleSlotID[4] = AddToggleOption("34 - Forearms", bToggleSlot[4])
	ToggleSlotID[5] = AddToggleOption("35 - Amulet", bToggleSlot[5])
	ToggleSlotID[6] = AddToggleOption("36 - Ring", bToggleSlot[6])
	ToggleSlotID[7] = AddToggleOption("37 - Feet", bToggleSlot[7])
	ToggleSlotID[8] = AddToggleOption("38 - Calves", bToggleSlot[8])
	ToggleSlotID[9] = AddToggleOption("39 - Shield", bToggleSlot[9])
	ToggleSlotID[10] = AddToggleOption("40 - Tail", bToggleSlot[10])
	ToggleSlotID[11] = AddToggleOption("41 - Long Hair", bToggleSlot[11])
	ToggleSlotID[12] = AddToggleOption("42 - Circlet", bToggleSlot[12])
	ToggleSlotID[13] = AddToggleOption("43 - Ears", bToggleSlot[13])
	ToggleSlotID[14] = AddToggleOption("44 - Unnamed", bToggleSlot[14])
	ToggleSlotID[15] = AddToggleOption("45 - Unnamed", bToggleSlot[15])
	ToggleSlotID[16] = AddToggleOption("46 - Unnamed", bToggleSlot[16])
	ToggleSlotID[17] = AddToggleOption("47 - Unnamed", bToggleSlot[17])
	ToggleSlotID[18] = AddToggleOption("48 - Unnamed", bToggleSlot[18])
	ToggleSlotID[19] = AddToggleOption("49 - Unnamed", bToggleSlot[19])
	ToggleSlotID[20] = AddToggleOption("50 - Beheaded", bToggleSlot[20])
	ToggleSlotID[21] = AddToggleOption("51 - Beheaded", bToggleSlot[21])
	ToggleSlotID[22] = AddToggleOption("52 - Unnamed", bToggleSlot[22])
	ToggleSlotID[23] = AddToggleOption("53 - Unnamed", bToggleSlot[23])
	ToggleSlotID[24] = AddToggleOption("54 - Unnamed", bToggleSlot[24])
	ToggleSlotID[25] = AddToggleOption("55 - Unnamed", bToggleSlot[25])
	ToggleSlotID[26] = AddToggleOption("56 - Unnamed", bToggleSlot[26])
	ToggleSlotID[27] = AddToggleOption("57 - Unnamed", bToggleSlot[27])
	ToggleSlotID[28] = AddToggleOption("58 - Unnamed", bToggleSlot[28])
	ToggleSlotID[29] = AddToggleOption("59 - Unnamed", bToggleSlot[29])
	ToggleSlotID[30] = AddToggleOption("60 - Unnamed", bToggleSlot[30])
	ToggleSlotID[31] = AddToggleOption("61 - FX01", bToggleSlot[31])
endif
endevent

Event OnOptionDefault(int option)
	if option == CommentChanceOID
		CommentChance = 80.0
		SetSliderOptionValue(CommentChanceOID, CommentChance, "{0.0}")
		SLHH_Chance.SetValue(CommentChance)
	elseIf Option == ResistMethodOID
		SLHH_ResistMethodGlobal.SetValue(1)
		SetMenuOptionValue(Option, ResistMethod[SLHH_ResistMethodGlobal.GetValue() As Int])
	elseIf Option == DamageActorValueOID
		SLHH_DamageActorValueGlobal.SetValue(1)
		SetMenuOptionValue(Option, DamageActorValue[SLHH_DamageActorValueGlobal.GetValue() As Int])
	else
		int idx = ToggleSlotID.Find(option)
		if (idx >= 0)
			if ( idx <= 13 ) ;slot 30-43
				IgnoreArmorSlot(SLHHSlotMask, SLHHSlotMaskB, idx + 30, True)
				SetToggleOptionValue(option, True)
			else
				IgnoreArmorSlot(SLHHSlotMask, SLHHSlotMaskB, idx + 30, False)
				SetToggleOptionValue(option, False)
			endif
		endif
	endif
EndEvent


Event OnOptionMenuAccept(Int OptionID, Int MenuItemIndex)
	If OptionID == ResistMethodOID
		If MenuItemIndex >= 0 && MenuItemIndex < ResistMethod.Length
			SetMenuOptionValue(OptionID, ResistMethod[MenuItemIndex])
			SLHH_ResistMethodGlobal.SetValue(MenuItemIndex)
		EndIf
	Elseif OptionID == DamageActorValueOID
		If MenuItemIndex >= 0 && MenuItemIndex < DamageActorValue.Length
			SetMenuOptionValue(OptionID, DamageActorValue[MenuItemIndex])
			SLHH_DamageActorValueGlobal.SetValue(MenuItemIndex)
		EndIf
	Endif
Endevent

Event OnOptionMenuOpen(Int OptionID)
	If OptionID == ResistMethodOID
		SetMenuDialogOptions(ResistMethod)
		SetMenuDialogStartIndex(SLHH_ResistMethodGlobal.GetValue() As Int)
		SetMenuDialogDefaultIndex(1)
	Elseif OptionID == DamageActorValueOID
		SetMenuDialogOptions(DamageActorValue)
		SetMenuDialogStartIndex(SLHH_DamageActorValueGlobal.GetValue() As Int)
		SetMenuDialogDefaultIndex(1)
	Endif
EndEvent

Event OnOptionSliderOpen(Int Option)
	if option == CommentChanceOID
		SetSliderDialogStartValue(CommentChance)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif option == AbortForceGreetIntervalOID
		SetSliderDialogStartValue(Abort)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(1.0, 72.0)
		SetSliderDialogInterval(1.0)
	elseif option == EscapeChanceOID
		SetSliderDialogStartValue(EscapeChance)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(-1.0, 101.0)
		SetSliderDialogInterval(1.0)
	elseif option == StripCountCriterionOID
		SetSliderDialogStartValue(StripCountCriterion)
		SetSliderDialogDefaultValue(12)
		SetSliderDialogRange(12.0, 36.0)
		SetSliderDialogInterval(1.0)
	elseif option == StripPossibilityOID
		SetSliderDialogStartValue(StripPossibility)
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(0.0, 80.0)
		SetSliderDialogInterval(1.0)
	elseif option == StageChanceOID
		SetSliderDialogStartValue(StageChance)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif option == relationOID
		SetSliderDialogStartValue(relation)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(-3.0, 5.0)
		SetSliderDialogInterval(1.0)
	elseif option == moralOID
		SetSliderDialogStartValue(moral)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 3.0)
		SetSliderDialogInterval(1.0)
	elseif option == threesomeOID
		SetSliderDialogStartValue(threesome)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif option == timeoutOID
		SetSliderDialogStartValue(timeout)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(1.0, 24.0)
		SetSliderDialogInterval(1.0)
	elseif option == NegoArmorStripintOID
		SetSliderDialogStartValue(SLHHUpkeep.NegoArmorStripint)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(1.0, 5.0)
		SetSliderDialogInterval(1.0)
	endif
endevent

Event OnOptionSliderAccept(Int Option, Float value)
	If Option == CommentChanceOID
		CommentChance = value
		SetSliderOptionValue(CommentChanceOID, CommentChance, "{0.0}")
		SLHH_Chance.SetValue(CommentChance)
	elseIf Option == AbortForceGreetIntervalOID
		Abort = value
		SetSliderOptionValue(AbortForceGreetIntervalOID, Abort, "{0.0}")
		SLHH_AbortForceGreetInterval.SetValue(Abort)
	elseIf Option == EscapeChanceOID
		EscapeChance = value
		SetSliderOptionValue(EscapeChanceOID, EscapeChance, "{0.0}")
		SLHH_EscapeChance.SetValue(EscapeChance)
	elseIf Option == StripCountCriterionOID
		StripCountCriterion = value
		SetSliderOptionValue(StripCountCriterionOID, StripCountCriterion, "{0.0}")
		SLHHUpkeep.EscapeCountCriterion = StripCountCriterion as int
	elseIf Option == StripPossibilityOID
		StripPossibility = value
		SetSliderOptionValue(StripPossibilityOID, StripPossibility, "{0.0}")
		SLHHUpkeep.SLHHStripPossibility = StripPossibility as int
	elseIf Option == StageChanceOID
		StageChance = value
		SetSliderOptionValue(StageChanceOID, StageChance, "{0.0}")
	elseIf Option == relationOID
		relation = value
		SetSliderOptionValue(relationOID, relation, "{0.0}")
		SLHH_relation.SetValue(relation)
	elseIf Option == MoralOID
		Moral = value
		SetSliderOptionValue(MoralOID, Moral, "{0.0}")
		SLHH_moral.SetValue(moral)
	elseIf Option == threesomeOID
		threesome = value
		SetSliderOptionValue(threesomeOID, threesome, "{0.0}")
	elseIf Option == timeoutOID
		timeout = value
		SetSliderOptionValue(timeoutOID, timeout, "{0.0}")
		SLHH_Timeout.SetValue(timeout)
	elseIf Option == NegoArmorStripintOID
		SLHHUpkeep.NegoArmorStripint = value as int
		SetSliderOptionValue(NegoArmorStripintOID, SLHHUpkeep.NegoArmorStripint, "{0.0}")
	endif
endevent

event OnOptionSelect(int option)
	if (option == enableOID)
		enable = !enable
		SetToggleOptionValue(enableOID, enable)
	elseif (option == DangerousConditionOID)
		DangerousCondition = !DangerousCondition
		SetToggleOptionValue(DangerousConditionOID, DangerousCondition)
	elseif (option == MonologueOID)
		Monologue = !Monologue
		SetToggleOptionValue(MonologueOID, Monologue)
		If Monologue == True
			SLHH_Monologue.SetValue(1)
		Else
			SLHH_Monologue.SetValue(0)
		EndIf
	elseif (option == YellingOID)
		Yell = !Yell
		SetToggleOptionValue(YellingOID, Yell)
		If Yell == True
			SLHH_Yelling.SetValue(1)
		Else
			SLHH_Yelling.SetValue(0)
		EndIf
	elseif (option == RunningOID)
		Run = !Run
		SetToggleOptionValue(RunningOID, Run)
		If Run == True
			SLHH_Running.SetValue(1)
		Else
			SLHH_Running.SetValue(0)
		EndIf
	elseif (option == ScaleSettingOID)
		scalesetting = !scalesetting
		SetToggleOptionValue(scalesettingOID, scalesetting)
		SLHH_scalesetting.setvalue(scalesetting as int)
	elseif (option == resetOID)
		If reset
			Reset = False
			ResetSwitch = False
		Else
			Reset = True
			ResetSwitch = True
		EndIf
		SetToggleOptionValue(resetOID, reset)
	elseif (option == MotionResetOID)
		If Motionreset
			Motionreset = False
		Else
			Motionreset = True
		EndIf
		SetToggleOptionValue(MotionResetOID, Motionreset)
	elseif (option == animOID)
		if anim == "Aggressive"
			anim = "Sleeping/Faint"
		elseIf anim == "Sleeping/Faint"
			anim = "Bound/Forced"
		elseIf anim == "Bound/Forced"
			anim = "Aggressive"
		endif
		SetTextOptionValue(animOID, anim)
	elseif (option == nighttimeOID)
		nighttime = !nighttime
		SetToggleOptionValue(nighttimeOID, nighttime)
		if nighttime == true
			If GameHour.GetValue() >= 18 || GameHour.GetValue() < 6
				SLHH_Nighttime.SetValue(1)
			else
				SLHH_Nighttime.SetValue(0)
			endif
		else
			SLHH_Nighttime.SetValue(1)
		endif
	elseif (option == YesClothesOID)
		Clothes = !Clothes
		SetToggleOptionValue(YesClothesOID, Clothes)
		if Clothes == true
			SLHH_YesClothes.SetValue(1)
		else
			SLHH_YesClothes.SetValue(0)
		endif
	elseif (option == BaboDialogueOID)
		BaboDialogueCheck = !BaboDialogueCheck
		SetToggleOptionValue(BaboDialogueOID, BaboDialogueCheck)
		
		If BaboDialogueOID
			SLHHMonitor.BaboDialogueActive = True
			SLHHMonitor.BaboViceGuardCaptainFaction = Game.GetFormFromFile(0x00B71E3E, "BabointeractiveDia.esp") as Faction
			SLHHUpkeep.SLHHActorRegisterForexternalmods()
		Else
			SLHHMonitor.BaboDialogueActive = false
		Endif
	elseif (option == WomanAttackOID)
		Woman = !Woman
		SetToggleOptionValue(WomanAttackOID, Woman)
		if Woman == true
			SLHH_WomanAttack.SetValue(1)
		else
			SLHH_WomanAttack.SetValue(0)
		endif
	elseif (option == companionOID)
		companion = !companion
		SetToggleOptionValue(companionOID, companion)
	else 
		int idx = ToggleSlotID.Find(option)
		if (idx >= 0)
			bToggleSlot[idx] = !bToggleSlot[idx]
			IgnoreArmorSlot(SLHHSlotMask, SLHHSlotMaskB, idx + 30, !bToggleSlot[idx])
			SetToggleOptionValue(option, bToggleSlot[idx])
		endif
	endif
endevent

event OnOptionHighlight(int option)
	if (option == CommentChanceOID)
		SetInfoText("$SLHH_HarassmentChanceinfo")
	elseif (option == EscapeChanceOID)
		SetInfoText("$SLHH_EscapeChanceinfo")
	elseif (option == StripCountCriterionOID)
		SetInfoText("$SLHH_StripCountCriterioninfo")
	elseif (option == StripPossibilityOID)
		SetInfoText("$SLHH_StripPossibilityinfo")
	elseif (option == dangerousConditionOID)
		SetInfoText("$SLHH_DangerousConditioninfo")
	elseif (option == StageChanceOID)
		SetInfoText("$SLHH_RepeatedStageChanceinfo")
	elseif (option == moralOID)
		SetInfoText("$SLHH_MoralityInfo")
	elseIf (option == relationOID)
		SetInfoText("$SLHH_RelationshipRankInfo")
	elseIf (option == timeoutOID)
		SetInfoText("$SLHH_Timeoutinfo")
	elseIf (option == nighttimeOID)
		SetInfoText("$SLHH_OnlyAtNightinfo")
	elseIf (option == companionOID)
		SetInfoText("$SLHH_AttackFollowerinfo")
	elseIf (option == scalesettingOID)
		SetInfoText("$SLHH_ScaleSettinginfo")
	elseIf (option == YesClothesOID)
		SetInfoText("$SLHH_Nosexyclothesinfo")
	elseIf (option == WomanAttackOID)
		SetInfoText("$SLHH_WomenharassPCinfo")
	elseIf (option == MonologueOID)
		SetInfoText("$SLHH_Playermonologueinfo")
	elseIf (option == YellingOID)
		SetInfoText("$SLHH_Arapistyellsinfo")
	elseIf (option == RunningOID)
		SetInfoText("$SLHH_Arapistrunsinfo")
	elseIf (option == AbortForceGreetIntervalOID)
		SetInfoText("$SLHH_AbortForceGreetIntervalinfo")
	elseIf (option >= ToggleSlotID[0])
		SetInfoText("$SLHH_ToggleSlotIDinfo")
	elseIf (option == ResistMethodOID)
		SetInfoText("$SLHH_ResistMethodInfo")
	elseIf (option == DamageActorValueOID)
		SetInfoText("$SLHH_DamageActorValueInfo")
	elseIf (option == NegoArmorStripintOID)
		SetInfoText("$SLHH_NegoArmorStripintinfo")
	elseIf (option == BaboDialogueOID)
		SetInfoText("$SLHH_BaboDialogueInfo")
	endif
endevent

Bool[] Function GetUnignoredArmorSlots(GlobalVariable IgnoredArmorSlotsMask, GlobalVariable IgnoredArmorSlotsMaskB)
	Bool[] ArmorSlots = new Bool[32]

    Int CurrentArmorSlotsMaskB = Math.LeftShift(IgnoredArmorSlotsMaskB.GetValue() As Int, 24)
	Int CurrentArmorSlotsMaskA = IgnoredArmorSlotsMask.GetValue() As Int
	Int CurrentIgnoredArmorSlotsMask = Math.LogicalOr(CurrentArmorSlotsMaskA, CurrentArmorSlotsMaskB)
	
	Int Index = ArmorSlots.Length
	While Index
		Index -= 1
		Int ArmorSlotMask = Armor.GetMaskForSlot(Index + 30)
		If Math.LogicalAnd(ArmorSlotMask, CurrentIgnoredArmorSlotsMask) == ArmorSlotMask
			ArmorSlots[Index] = True
		Else
			ArmorSlots[Index] = False
		EndIf
	EndWhile
	
	Return ArmorSlots
EndFunction
Function IgnoreArmorSlot(GlobalVariable IgnoredArmorSlotsMask, GlobalVariable IgnoredArmorSlotsMaskB, Int ArmorSlot, Bool Ignore)
	Int ArmorSlotMask = Armor.GetMaskForSlot(ArmorSlot)
    Int CurrentArmorSlotsMaskB = Math.LeftShift(IgnoredArmorSlotsMaskB.GetValue() As Int, 24)
	Int CurrentArmorSlotsMaskA = IgnoredArmorSlotsMask.GetValue() As Int
	Int CurrentIgnoredArmorSlotsMask = Math.LogicalOr(CurrentArmorSlotsMaskA, CurrentArmorSlotsMaskB)
	
	Int NewIgnoredArmorSlotsMask
	If Ignore == False
		NewIgnoredArmorSlotsMask = Math.LogicalOr(ArmorSlotMask, CurrentIgnoredArmorSlotsMask)
	Else
		NewIgnoredArmorSlotsMask = Math.LogicalXor(ArmorSlotMask, CurrentIgnoredArmorSlotsMask)
	EndIf
	
	IgnoredArmorSlotsMask.SetValue(Math.LogicalAnd(NewIgnoredArmorSlotsMask, 0x00ffffff))
	IgnoredArmorSlotsMaskB.SetValue(Math.RightShift(NewIgnoredArmorSlotsMask, 24))
EndFunction