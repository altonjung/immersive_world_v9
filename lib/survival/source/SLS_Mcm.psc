Scriptname SLS_Mcm extends SKI_ConfigBase

; MCM Config Begin =======================================================

Event OnConfigInit()
	BuildPages()

	SetupMenuArrays()
	
	;LoadSettings()
	AssSlappingEvents = true
	If Game.GetModByName("Spank That Ass.esp") != 255
		AssSlappingEvents = false
	EndIf
	ToggleAssSlapping()
	
	If Game.GetModByName("Devious Devices - Expansion.esm") != 255
		DeviousEffectsEnable = true
	Else
		PpLootKeysChance = 0.0
	EndIf
	
	If Game.GetModByName("Amputator.esm") == 255
		AmpType = 0
		ToggleDismemberment()
	EndIf
	
	PlayerRef.AddPerk(_SLS_InequalitySkillsPerk)
	PlayerRef.AddPerk(_SLS_InequalityBuySellPerk)
	PlayerRef.AddPerk(_SLS_BikiniExpPerk)
	PlayerRef.AddSpell(_SLS_BikiniExpSpell)
	PlayerRef.AddSpell(Game.GetFormFromFile(0x0CF9B0, "SL Survival.esp") as Spell) ; Jiggles
	
	ImportTradeRestrictMerchants()
	BuildPpLootList()
	ImportEscorts()
	AddQuestObjects()
	InitLocJurisdictions()
	ImportLicenceExceptions()
	AddWearableLanternExceptions()
	SetHorseCost(SurvivalHorseCost)
	ToggleProxSpank()
	ToggleCumAddiction()
	ToggleCoverMechanics()
	TogglePpSleepNpcPerk()
	Game.SetGameSettingFloat("fAIMinGreetingDistance", GreetDist)
	Game.SetGameSettingInt("iCrimeGoldPickpocket", PpCrimeGold)
	ToggleSexExp()
	ImportStrongFemales()
	ReplaceVanillaMaps(ReplaceMaps)
	AddRemoveChainCollars(LicMagicChainCollars)
	PapyrusUtilCheck()
EndEvent

Function PlayerLoadsGame()
	If Game.GetModByName(JsonUtil.GetStringValue("SL Survival/BikiniArmors.json", "bikinimodname", missing = "TheAmazingWorldOfBikiniArmor.esp")) != 255
		_SLS_BikiniArmorsEntryPointVendorCity.SetNthCount(0, BikiniDropsVendorCity)
		_SLS_BikiniArmorsEntryPointVendorTown.SetNthCount(0, BikiniDropsVendorTown)
		_SLS_BikiniArmorsEntryPointVendorKhajiit.SetNthCount(0, BikiniDropsVendorKhajiit)
		_SLS_BikiniArmorsEntryPointChest.SetNthCount(0, BikiniDropsChest)
		_SLS_BikiniArmorsEntryPointChestOrnate.SetNthCount(0, BikiniDropsChestOrnate)
	EndIf
	AddWearableLanternExceptions()
	Game.SetGameSettingFloat("fAIMinGreetingDistance", GreetDist)
	Game.SetGameSettingInt("iCrimeGoldPickpocket", PpCrimeGold)
	PapyrusUtilCheck()
EndFunction

Function PapyrusUtilCheck()
	While PapyrusUtil.GetVersion() < 33
		Debug.Messagebox("SL Survival: Your version of PapyrusUtil is outdated! \n\nThis issue is answered in the FAQ of the mod page. Please read the FAQ FIRST before posting on the forum as it's been asked a thousand times! If you're still stuck after reading then, by all means, ask for help\n\nYou should exit the game and fix this problem before proceeding! This message will repeat until it's fixed")
		Utility.Wait(3.0)
	EndWhile
EndFunction

Function BuildPages()
	Pages = new string[18]
	Pages[0] = "Settings "
	Pages[1] = "Sex & Effects"
	Pages[2] = "Misogyny & Inequality"
	Pages[3] = "Trauma "
	Pages[4] = "Needs "
	Pages[5] = "Cum "
	Pages[6] = "Frostfall & Simply Knock"
	Pages[7] = "Tolls, Eviction & Gates"
	Pages[8] = "Licences 1"
	Pages[9] = "Licences 2"
	Pages[10] = "Stashes "
	Pages[11] = "Begging & Kennel"
	Pages[12] = "Pickpocket & Dismemberment"
	Pages[13] = "Bikini Armors & Exp"
	Pages[14] = "Inn Room Prices"
	Pages[15] = "Interfaces "
	Pages[16] = "Stats & Info"
	Pages[17] = "Stats & Info 2"
EndFunction

Function SetupMenuArrays()
	SlotMasks = new Int[32]
	SlotMasks[0] = 1 ; kSlotMask30
	SlotMasks[1] = 2 ; kSlotMask31
	SlotMasks[2] = 4 ; kSlotMask32
	SlotMasks[3] = 8 ; kSlotMask33
	SlotMasks[4] = 16 ; kSlotMask34
	SlotMasks[5] = 32 ; kSlotMask35
	SlotMasks[6] = 64 ; kSlotMask36
	SlotMasks[7] = 128 ; kSlotMask37
	SlotMasks[8] = 256 ; kSlotMask38
	SlotMasks[9] = 512 ; kSlotMask39
	SlotMasks[10] = 1024 ; kSlotMask40
	SlotMasks[11] = 2048 ; kSlotMask41
	SlotMasks[12] = 4096 ; kSlotMask42
	SlotMasks[13] = 8192 ; kSlotMask43
	SlotMasks[14] = 16384 ; kSlotMask44
	SlotMasks[15] = 32768 ; kSlotMask45
	SlotMasks[16] = 65536 ; kSlotMask46
	SlotMasks[17] = 131072 ; kSlotMask47
	SlotMasks[18] = 262144 ; kSlotMask48
	SlotMasks[19] = 524288 ; kSlotMask49
	SlotMasks[20] = 1048576 ; kSlotMask50
	SlotMasks[21] = 2097152 ; kSlotMask51
	SlotMasks[22] = 4194304 ; kSlotMask52
	SlotMasks[23] = 8388608 ; kSlotMask53
	SlotMasks[24] = 16777216 ; kSlotMask54
	SlotMasks[25] = 33554432 ; kSlotMask55
	SlotMasks[26] = 67108864 ; kSlotMask56
	SlotMasks[27] = 134217728 ; kSlotMask57
	SlotMasks[28] = 268435456 ; kSlotMask58
	SlotMasks[29] = 536870912 ; kSlotMask59
	SlotMasks[30] = 1073741824 ; kSlotMask60
	SlotMasks[31] = 0x80000000 ; kSlotMask61 - Use hex otherwise number ends up being 1 short....?

	PushEventsType = new String[4]
	PushEventsType[0] = "Off "
	PushEventsType[1] = "Stagger Only"
	PushEventsType[2] = "Paralysis Only"
	PushEventsType[3] = "Stagger + Paralysis"
	
	ClothesLicenceMethod = new String[3]
	ClothesLicenceMethod[0] = "Never Required"
	ClothesLicenceMethod[1] = "Always Required"
	ClothesLicenceMethod[2] = "In Slaverun Towns"
	
	HeavyBondageDifficulty = new String[3]
	HeavyBondageDifficulty[0] = "Off "
	HeavyBondageDifficulty[1] = "Difficult "
	HeavyBondageDifficulty[2] = "Impossible "
	
	
	AmputationTypes = new String[4]
	AmputationTypes[0] = "Off "
	AmputationTypes[1] = "Random "
	AmputationTypes[2] = "Arms First"
	AmputationTypes[3] = "Legs First"

	AmputationDepth = new String[3]
	AmputationDepth[0] = "One Level At A Time"
	AmputationDepth[1] = "Max In One Chop"
	AmputationDepth[2] = "Random "

	MaxAmputationDepthArms = new String [3]
	MaxAmputationDepthArms[0] = "Everything "
	MaxAmputationDepthArms[1] = "Up To Forearms Only"
	MaxAmputationDepthArms[2] = "Hands Only"
	
	MaxAmputationDepthLegs = new String [3]
	MaxAmputationDepthLegs[0] = "Everything "
	MaxAmputationDepthLegs[1] = "Up To Lower Legs Only"
	MaxAmputationDepthLegs[2] = "Feet Only"

	;/
	AltHealingRequirements[0] = "Swallow Cum Immediate"
	AltHealingRequirements[1] = "Swallow Cum + Rest"
	AltHealingRequirements[2] = "Filled With Cum Immediate"
	AltHealingRequirements[3] = "Filled With Cum + Rest"
	AltHealingRequirements[4] = "Filled With Cum + Swallow Cum Immediate"
	AltHealingRequirements[5] = "Filled With Cum + Swallow Cum + Rest"
	/;

	DismemberWeapons = new String[3]
	DismemberWeapons[0] = "Two Handed Only"
	DismemberWeapons[1] = "Everything Except Daggers & Ranged"
	DismemberWeapons[2] = "Everything (Silly Mode)"
	
	OverlayAreas = new String[4]
	OverlayAreas[0] = "Body"
	OverlayAreas[1] = "Face"
	OverlayAreas[2] = "Hands"
	OverlayAreas[3] = "Feet"
	
	BuyBackPrices = new String [6]
	BuyBackPrices[5] = "100% Of Original"
	BuyBackPrices[4] = "75% Of Original"
	BuyBackPrices[3] = "50% Of Original"
	BuyBackPrices[2] = "25% Of Original"
	BuyBackPrices[1] = "10% Of Original"
	BuyBackPrices[0] = "5% Of Original"
	
	LicenceStyleList = new String[4]
	LicenceStyleList[0] = "Default "
	LicenceStyleList[1] = "Thaneship Choice"
	LicenceStyleList[2] = "Thaneship Random"
	LicenceStyleList[3] = "Unlock "
	
	ProxSpankNpcList = new String[6]
	ProxSpankNpcList[0] = "Guards Only"
	ProxSpankNpcList[1] = "Guards & Men"
	ProxSpankNpcList[2] = "Only Men"
	ProxSpankNpcList[3] = "Only Women"
	ProxSpankNpcList[4] = "Anything With Hands"
	ProxSpankNpcList[5] = "Off "
	
	ProxSpankRequiredCoverList = new String[4]
	ProxSpankRequiredCoverList[0] = "Naked "
	ProxSpankRequiredCoverList[1] = "Naked/Bikini/Slooty"
	ProxSpankRequiredCoverList[2] = "Anything "
	ProxSpankRequiredCoverList[3] = "Off "
	
	CumHungerStrings = new String[5]
	CumHungerStrings[0] = "Satisfied "
	CumHungerStrings[1] = "Peckish "
	CumHungerStrings[2] = "Hungry "
	CumHungerStrings[3] = "Starving "
	CumHungerStrings[4] = "Ravenous "
	
	SexExpCreatureCorruption = new String[2]
	SexExpCreatureCorruption[0] = "Off "
	SexExpCreatureCorruption[1] = "Gradual One-Way"
	
	FollowerLicStyles = new String[2]
	FollowerLicStyles[0] = "Player Centric"
	FollowerLicStyles[1] = "Party Wide"
	
	CompassHideMethods = new String[3]
	CompassHideMethods[0] = "Transparent "
	CompassHideMethods[1] = "Ini Disable"
	CompassHideMethods[2] = "Both "
	
	BuildSexOptionsArrays()
	
	BuildSplashArray()
EndFunction

Event OnConfigOpen()
	IsInMcm = true
	
	; Setup Equip lists for licence exceptions
	StorageUtil.FormListClear(Self, "_SLS_EquipSlots")
	StorageUtil.StringListClear(Self, "_SLS_EquipSlotStrings")
	StorageUtil.StringListAdd(Self, "_SLS_EquipSlotStrings", "None ")
	StorageUtil.FormListAdd(Self, "_SLS_EquipSlots", None, allowDuplicate = false)
	EquipSlots = new Form[1]
	EquipSlots[0] = None
	SelectedEquip = 0
	EquipSlotStrings = StorageUtil.StringListToArray(Self, "_SLS_EquipSlotStrings")
EndEvent

Event OnConfigClose()
	IsInMcm = false
	If DoSlaverunInitOnClose
		DoSlaverunInitOnClose = false
		DoSlaverunInit()
	EndIf
	If DoDeviousEffectsChange
		ToggleDeviousEffects()
		DoDeviousEffectsChange = false
	EndIf
	If DoTollDodgingToggle
		ToggleTollDodging()
		DoTollDodgingToggle = false
	EndIf
	If DoPpLvlListbuildOnClose
		DoPpLvlListbuildOnClose = false
		BuildPpLootList()
	EndIf
	If DoTogglePpFailHandle
		DoTogglePpFailHandle = false
		TogglePpFailHandle()
	EndIf
	If DoInequalityRefresh
		DoInequalityRefresh = false
		SetInequalityEffects()
		_SLS_InequalityRefreshQuest.Stop()
		_SLS_InequalityRefreshQuest.Start()
	EndIf
	If DoToggleBikiniExp
		DoToggleBikiniExp = false
		ToggleBikiniExp()
	EndIf
	If DoToggleCumEffects
		DoToggleCumEffects = false
		ToggleCumEffects()
	EndIf
	If DoToggleAnimalBreeding
		DoToggleAnimalBreeding = false
		ToggleAnimalBreeding()
	EndIf
	If DoTogglePushEvents
		DoTogglePushEvents = false
		TogglePushPlayer()
	EndIf
	If DoToggleHalfNakedCover
		DoToggleHalfNakedCover = false
		ToggleHalfNakedCover()
	EndIf
	If DoToggleHeelsRequired
		DoToggleHeelsRequired = false
		BikiniCurse.DoArmorCheck()
	EndIf
	If DoToggleBondFurn
		DoToggleBondFurn = false
		ToggleBondFurn()
	EndIf
	If DoToggleCatCalling
		DoToggleCatCalling = false
		ToggleCatCalling()
	EndIf
	If DoToggleLicenceStyle
		DoToggleLicenceStyle = false
		ToggleLicenceStyle()
	EndIf
	If DoToggleGuardBehavWeapDrawn
		DoToggleGuardBehavWeapDrawn = false
		ToggleGuardBehavWeapDrawn()
	EndIf
	If DoToggleGuardBehavWeapEquip
		DoToggleGuardBehavWeapEquip = false
		ToggleGuardBehavWeapEquip()
	EndIf
	If DoToggleGuardBehavArmorEquip
		DoToggleGuardBehavArmorEquip = false
		ToggleGuardBehavArmorEquip()
	EndIf
	If DoToggleGuardBehavDrugs
		DoToggleGuardBehavDrugs = false
		ToggleGuardBehavDrugs()
	EndIf
	If DoToggleGuardBehavLockpick
		DoToggleGuardBehavLockpick = false
		ToggleGuardBehavLockpick()
	EndIf
	If DoToggleGuardComments
		DoToggleGuardComments = false
		ToggleGuardComments()
	EndIf
	If DoToggleProxSpank
		DoToggleProxSpank = false
		ToggleProxSpank()
	EndIf
	If DoToggleBarefootSpeed
		DoToggleBarefootSpeed = false
		ToggleBarefootMag()
	EndIf
	If DoToggleCumAddiction
		DoToggleCumAddiction = false
		ToggleCumAddiction()
	EndIf
	If DoToggleCoverMechanics
		DoToggleCoverMechanics = false
		ToggleCoverMechanics()
	EndIf
	If DoToggleCumAddictAutoSuckCreature
		DoToggleCumAddictAutoSuckCreature = false
		ToggleCumAddictAutoSuckCreature()
	EndIf
	If DoToggleSexExp
		DoToggleSexExp = false
		ToggleSexExp()
	EndIf
	If DoToggleIneqStrongFemaleFollowers
		DoToggleIneqStrongFemaleFollowers = false
		ToggleIneqStrongFemaleFollowers()
	EndIf
	If DoStashAddRemoveException
		DoStashAddRemoveException = false
		_SLS_StashAddExceptionQuest.Start()
	EndIf
	If DoToggleStashTracking
		DoToggleStashTracking = false
		ToggleStashTracking()
	EndIf
	If SnowberryEnable
		_SLS_LicenceSnowberryQuest.Start()
	Else
		_SLS_LicenceSnowberryQuest.Stop()
	EndIf
	If DoToggleBellyInflation
		DoToggleBellyInflation = false
		ToggleBellyInflation()
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleDaydream", Missing = 0) == 1
		StorageUtil.SetIntValue(Self, "DoToggleDaydream", 0)
		CumAddict.ToggleDaydreaming(StorageUtil.GetIntValue(Self, "CumAddictDayDream", Missing = 1))
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleDaydreamButterflys", Missing = 0) == 1
		StorageUtil.SetIntValue(Self, "DoToggleDaydreamButterflys", 0)
		CumAddict.ToggleButterflys(StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflys", Missing = 1))
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleGrowth", Missing = 0) == 1
		StorageUtil.SetIntValue(Self, "DoToggleGrowth", 0)
		If MQ101.GetCurrentStageID() >= 240 && StorageUtil.GetFloatValue(Self, "WeightGainPerDay", Missing = 0.0) > 0.0
			(Game.GetFormFromFile(0x0DC7EE, "SL Survival.esp") as Quest).Start()
		Else
			(Game.GetFormFromFile(0x0DC7EE, "SL Survival.esp") as Quest).Stop()
		EndIf
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleNpcComments", Missing = 0) == 1
		StorageUtil.SetIntValue(Self, "DoToggleNpcComments", 0)
		ToggleNpcComments()
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleJiggles", Missing = 0) == 1
		StorageUtil.SetIntValue(Self, "DoToggleJiggles", 0)
		ToggleJiggles()
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleCompulsiveSex", Missing = 0) == 1
		StorageUtil.UnSetIntValue(Self, "DoToggleCompulsiveSex")
		ToggleCompulsiveSex()
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleOrgasmFatigue", Missing = 0) == 1
		StorageUtil.UnSetIntValue(Self, "DoToggleOrgasmFatigue")
		ToggleOrgasmFatigue()
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleCurfew", Missing = 0) == 1
		StorageUtil.UnSetIntValue(Self, "DoToggleCurfew")
		ToggleCurfew(LicUtil.LicCurfewEnable)
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleTrauma", Missing = 0) == 1
		StorageUtil.UnSetIntValue(Self, "DoToggleTrauma")
		Trauma.ToggleTrauma()
	EndIf
	If StorageUtil.GetIntValue(Self, "DoToggleDynamicTrauma", Missing = 0) == 1
		StorageUtil.UnSetIntValue(Self, "DoToggleDynamicTrauma")
		Trauma.ToggleDynamicTrauma()
	EndIf
EndEvent

event OnPageReset(string page)
	If Page == ""
		LoadCustomContent(SplashArray[Utility.RandomInt(0, SplashArray.Length - 1)])
		Return
	Else
		UnloadCustomContent()
	EndIf

	Int HardMode = OPTION_FLAG_DISABLED
	If !IsHardcoreLocked
		HardMode = OPTION_FLAG_NONE
	EndIf
	
	Int CreatureEventsFlag = OPTION_FLAG_DISABLED
	If Init.SlsCreatureEvents
		CreatureEventsFlag = OPTION_FLAG_NONE
	EndIf
	Int AnimalBreedFlag = OPTION_FLAG_DISABLED
	If Init.SlsCreatureEvents && AnimalBreedEnable
		AnimalBreedFlag = OPTION_FLAG_NONE
	EndIf
	
	String CrosshairRefString = GetActorCrosshairRef()
		
	If(page == "Settings ")
		Int SlaverunModFound = OPTION_FLAG_DISABLED
		Int SlaverunFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("Slaverun_Reloaded.esp") != 255
			If Slaverun.GetIsInterfaceActive()
				If Slaverun.IsFreeTownWhiterun() && !IsHardcoreLocked
					SlaverunModFound = OPTION_FLAG_NONE
					If SlaverunAutoStart
						SlaverunFlag = OPTION_FLAG_NONE
					EndIf
				EndIf
			EndIf
		EndIf
		
		Int HalfNakedCoverFlag = OPTION_FLAG_DISABLED
		If HalfNakedEnable
			HalfNakedCoverFlag = OPTION_FLAG_NONE
		EndIf
		
		Int MinAvFlag = OPTION_FLAG_DISABLED
		If MinAvToggleT
			MinAvFlag = OPTION_FLAG_NONE
		EndIf
		
		Int DeviousInstalledFlag = OPTION_FLAG_DISABLED
		Int DeviousFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("Devious Devices - Expansion.esm") != 255
			DeviousInstalledFlag = OPTION_FLAG_NONE
			If DeviousEffectsEnable && !IsHardcoreLocked
				DeviousFlag = OPTION_FLAG_NONE
			EndIf
		EndIf

		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Info")
		AddTextOption("Survival Script Version:", Main.Version, OPTION_FLAG_DISABLED)
		AddEmptyOption()
		
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Import/Export Settings")
		ImportSettingsOID_T = AddTextOption("Import Settings", "")
		ExportSettingsOID_T = AddTextOption("Export Settings", "")
		AddEmptyOption()
		
		AddHeaderOption("Keys ")
		AllInOneKeyOID = AddKeyMapOption("All In One Key", AllInOne.AioKey)
		StorageUtil.SetIntValue(Self, "OpenMouthKey", AddKeyMapOption("Open Mouth", CumSwallow.OpenMouthKey))
		AddEmptyOption()
		
		AddHeaderOption("General Settings ")
		DropItemsOID = AddToggleOption("Drop Items During Aggressive Events", DropItems)
		OrgasmRequiredOID = AddToggleOption("Must Orgasm", OrgasmRequired)
		BarefootMagOIS_S = AddSliderOption("Barefoot Speed Debuff:", BarefootMag, "{0}")
		HorseCostOIS_S = AddSliderOption("Horse Cost:", SurvivalHorseCost, "{0} Gold", HardMode)
		StorageUtil.SetIntValue(Self, "GrowthWeightGainOID_S", AddSliderOption("Growth Weight Gain", StorageUtil.GetFloatValue(Self, "WeightGainPerDay", Missing = 0.0), "{2}"))
		EasyBedTrapsOID = AddToggleOption("Trap Easy Beds", EasyBedTraps, HardMode)
		HardcoreModeOID = AddToggleOption("Hardcore Mode", HardcoreMode)
		DebugModeOID = AddToggleOption("Debug Mode", Init.DebugMode)
		AddEmptyOption()

		AddHeaderOption("Minimum Speed & Carry Weight ")
		MinAvToggleOID = AddToggleOption("Min AV Toggle ", MinAvToggleT)
		MinSpeedOID_S = AddSliderOption("Minimum Speed ", MinSpeedMult, "{0}", MinAvFlag)
		MinCarryWeightOID_S = AddSliderOption("Minimum Carry Weight ", MinCarryWeight, "{0}", MinAvFlag)
		AddEmptyOption()
		
		AddHeaderOption("Navigation Options ")
		CompassMechanicsOID = AddToggleOption("Map & Compass Mechanics", CompassMechanics, HardMode)
		CompassHideMethodDB = AddMenuOption("Compass Hide Method", CompassHideMethods[CompassHideMethod])
		FastTravelDisableOID = AddToggleOption("Disable Fast Travel In Cities", FastTravelDisable, HardMode)
		FtDisableIsNormalOID = AddToggleOption("Fast Travel Is Normally Disabled", FtDisableIsNormal)
		ReplaceMapsOID = AddToggleOption("Replace Vanilla Maps", ReplaceMaps)
		ReplaceMapsTimerOID_S = AddSliderOption("Lose Bearings After", ReplaceMapsTimer, "{0}")
		ConstructableMapAndCompassOID = AddToggleOption("Constructable Map & Compass", _SLS_MapAndCompassRecipeEnable.GetValueInt(), HardMode)
		AddEmptyOption()
		
		AddHeaderOption("Gold ")
		GoldWeightOID_S = AddSliderOption("Gold Weighs ", GoldWeight, "{3}")
		FollowersStealGoldOID = AddToggleOption("Followers Steal Gold ", FollowersStealGold, HardMode)
		FolGoldStealChanceOID_S = AddSliderOption("Chance For Follower To Steal ", FolGoldStealChance, "{0}%", HardMode)
		FolGoldSteamAmountOID_S = AddSliderOption("How Much Follower Steals ", FolGoldSteamAmount, "{0}%", HardMode)
		AddEmptyOption()

		AddHeaderOption("Slaverun ")
		SlaverunAutoStartOID = AddToggleOption("Auto Start Slaverun ", SlaverunAutoStart, SlaverunModFound)
		SlaverunAutoMinOID_S = AddSliderOption("Auto Start In Min", SlaverunAutoMin, "{0} Days", SlaverunFlag)
		SlaverunAutoMaxOID_S = AddSliderOption("Auto Start In Max", SlaverunAutoMax, "{0} Days", SlaverunFlag)
		AddEmptyOption()
		
		Int BondFurnFlag = OPTION_FLAG_DISABLED
		If BondFurnEnable && !IsHardcoreLocked
			BondFurnFlag = OPTION_FLAG_NONE
		EndIf
		
		Int DflowResistFlag = OPTION_FLAG_DISABLED
		If Dflow.GetDfVersion() >= 206.0
			DflowResistFlag = OPTION_FLAG_NONE
		EndIf

		SetCursorPosition(1)
		AddHeaderOption("Devious Followers")
		DflowResistLossOID_S = AddSliderOption("Resistance Loss", DflowResistLoss, "{1}", DflowResistFlag)
		AddEmptyOption()
		
		AddHeaderOption("Devious Options ")
		RunDevicePatchUpOID_T = AddTextOption("Run Device Patchup", "", DeviousInstalledFlag)
		LicMagicChainCollarsOID = AddToggleOption("Allow Chain Collars", LicMagicChainCollars, DeviousInstalledFlag)
		DeviousGagDebuffOID_S = AddSliderOption("Gag Speech Debuff", DeviousGagDebuff, "{0} Points", DeviousInstalledFlag)
		DeviousEffectsEnableOID = AddToggleOption("Devious Effects ", DeviousEffectsEnable, DeviousInstalledFlag)
		StorageUtil.SetIntValue(Self, "DeviousDrowningOID", AddToggleOption("Devious Drowning", DeviousEffects.DeviousDrowning, DeviousInstalledFlag))
		DevEffLockpickDiffDB = AddMenuOption("Lockpicking Is", HeavyBondageDifficulty[DevEffLockpickDiff], DeviousFlag)
		DevEffPickpocketDiffDB = AddMenuOption("Pickpocketing Is", HeavyBondageDifficulty[DevEffPickpocketDiff], DeviousFlag)
		DevEffNoGagTradingOID = AddToggleOption("No Trading When Gagged", DevEffNoGagTrading, DeviousFlag)
		BondFurnEnableOID = AddToggleOption("Bondage Furniture Effects ", BondFurnEnable)
		BondFurnMilkFreqOID_S = AddSliderOption("Milk Furn Update Freq", BondFurnMilkFreq, "{1} seconds", BondFurnFlag)
		BondFurnMilkFatigueMultOID_S = AddSliderOption("Milk Furn Fatigue Mult", BondFurnMilkFatigueMult, "{1}x", BondFurnFlag)
		BondFurnMilkWillOID_S = AddSliderOption("Milk Furn Willpower Ticks", BondFurnMilkWill, "{1}", BondFurnFlag)
		BondFurnFreqOID_S = AddSliderOption("Bondage Furn Update Freq", BondFurnFreq, "{1} seconds", BondFurnFlag)
		BondFurnFatigueMultOID_S = AddSliderOption("Bondage Furn Fatigue Mult", BondFurnFatigueMult, "{1}x", BondFurnFlag)
		BondFurnWillOID_S = AddSliderOption("Bondage Furn Willpower Ticks", BondFurnWill, "{1}", BondFurnFlag)
		AddEmptyOption()
		
		AddHeaderOption("Half Naked Cover ")
		HalfNakedEnableOID = AddToggleOption("Enable Half Naked Cover ", HalfNakedEnable)
		HalfNakedStripsOID = AddToggleOption("Strips Cuirass ", HalfNakedStrips)
		HalfNakedBraOID_S = AddSliderOption("My Bra Slot Is ", HalfNakedBra, "{0}", HalfNakedCoverFlag)
		HalfNakedPantyOID_S = AddSliderOption("My Panty Slot Is ", HalfNakedPanty, "{0}", HalfNakedCoverFlag)
		AddEmptyOption()
		
		AddHeaderOption("SLIF Max Scaling")
		StorageUtil.SetIntValue(Self, "SlifBreastScaleMaxOID_S", AddSliderOption("Breasts: ", Main.Slif.ScaleMaxBreasts, "{1}"))
		StorageUtil.SetIntValue(Self, "SlifBellyScaleMaxOID_S", AddSliderOption("Belly: ", Main.Slif.ScaleMaxBelly, "{1}"))
		StorageUtil.SetIntValue(Self, "SlifAssScaleMaxOID_S", AddSliderOption("Ass: ", Main.Slif.ScaleMaxAss, "{1}"))
		AddEmptyOption()
		
		AddHeaderOption("API ")
		LicShowApiBlockFormsOID_T = AddTextOption("Show Blocking Forms", "")
		LicClearApiBlockFormsOID_T = AddTextOption("Clear Blocking Forms", "")
		AddEmptyOption()
		
	ElseIf(page == "Sex & Effects")
		Int FashionFlag = OPTION_FLAG_DISABLED
		If StorageUtil.GetFloatValue(None, "YPS_TweakVersion", Missing = -1.0) >= 1.0
			FashionFlag = OPTION_FLAG_NONE
		EndIf
		
		Int SexExpEnFlag = OPTION_FLAG_DISABLED
		Int SexCorruptionEnFlag = OPTION_FLAG_DISABLED
		Int DebugCorruptionFlag = OPTION_FLAG_DISABLED
		Int MinStamMagFlag = OPTION_FLAG_DISABLED
		If SexExpEn
			SexExpEnFlag = OPTION_FLAG_NONE
			If SexExpCorruption == 1
				SexCorruptionEnFlag = OPTION_FLAG_NONE
				If Init.DebugMode
					DebugCorruptionFlag = OPTION_FLAG_NONE
				EndIf
			EndIf
			If SexMinStamMagRates
				MinStamMagFlag = OPTION_FLAG_NONE
			EndIf
		EndIf
		
		Int DrugLactacidFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("MilkModNEW.esp") != 255 && !IsHardcoreLocked
			DrugLactacidFlag = OPTION_FLAG_NONE
		EndIf
		Int DrugSkoomaFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("SexLabSkoomaWhore.esp") != 255 && !IsHardcoreLocked
			DrugSkoomaFlag = OPTION_FLAG_NONE
		EndIf
		Int DrugInflateFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("SexLab Inflation Framework.esp") != 255 && !IsHardcoreLocked
			DrugInflateFlag = OPTION_FLAG_NONE
		EndIf
		Int DrugFmFertilityFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("Fertility Mode.esm") != 255 && !IsHardcoreLocked
			DrugFmFertilityFlag = OPTION_FLAG_NONE
		EndIf
		Int DrugSlenFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("SexLab Eager NPCs.esp") != 255 && !IsHardcoreLocked
			DrugSlenFlag = OPTION_FLAG_NONE
		EndIf
		
		Int FondleAddFlag = OPTION_FLAG_DISABLED
		Int FondleRemoveFlag = OPTION_FLAG_DISABLED
		ObjectReference CrossHairRef = Game.GetCurrentCrosshairRef()
		VoiceType Voice
		If CrossHairRef as Actor && Init.SlsCreatureEvents
			If (CrossHairRef as Actor).GetRace().IsRaceFlagSet(0)
				Voice = CrossHairRef.GetVoiceType()
				If Voice
					If _SLS_FondleableVoices.HasForm(Voice)
						FondleRemoveFlag = OPTION_FLAG_NONE
					Else
						FondleAddFlag = OPTION_FLAG_NONE
					EndIf
				EndIf
			EndIf
		EndIf
		
		Int OrgasmFatigueFlag = OPTION_FLAG_DISABLED
		If StorageUtil.GetIntValue(Self, "OrgasmFatigue", Missing = 1) == 1
			OrgasmFatigueFlag = OPTION_FLAG_NONE
		EndIf
		
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		AddHeaderOption("Sex Experience & Effects")
		SexExpEnableOID = AddToggleOption("Enable Sex Experience", SexExpEn)
		SexExpCorruptionDB = AddMenuOption("Creature Corruption", SexExpCreatureCorruption[SexExpCorruption], SexExpEnFlag)
		DremoraCorruptionOID = AddToggleOption("Dremora Orgasms Corrupt", DremoraCorruption, SexExpEnFlag)
		SexExpCorruptionCurrentOID_S = AddSliderOption("Current Corruption", StorageUtil.GetIntValue(None, "_SLS_CreatureCorruption", Missing = 0), "{0} Points", DebugCorruptionFlag)
		CockSizeBonusEnjFreqOID_S = AddSliderOption("Cock Size Bonus Enjoyment Freq", CockSizeBonusEnjFreq, "{1} sec", SexCorruptionEnFlag)
		RapeForcedSkoomaChanceOID_S = AddSliderOption("Rape Forced Drug Chance", RapeForcedSkoomaChance, "{0}%", SexExpEnFlag)
		RapeMinArousalOID_S = AddSliderOption("Minimum Rapist Arousal", RapeMinArousal, "{0}", SexExpEnFlag)
		SexExpResetStatsOID_T = AddTextOption("Reset Sex Stats", "", SexExpEnFlag)
		AddEmptyOption()
		
		AddHeaderOption("Jiggles ")
		StorageUtil.SetIntValue(Self, "JigglesOID", AddToggleOption("Jiggles ", StorageUtil.GetIntValue(Self, "Jiggles", Missing = 1)))
		StorageUtil.SetIntValue(Self, "JigglesVisualsOID", AddToggleOption("Jiggles Visual Effects", (Game.GetFormFromFile(0x0CF9B1, "SL Survival.esp") as _SLS_BodyInflationTracking).DoImod))
		AddEmptyOption()
		
		AddHeaderOption("Compulsive Sex")
		StorageUtil.SetIntValue(Self, "CompulsiveSexOID", AddToggleOption("Compulsive Sex", StorageUtil.GetIntValue(Self, "CompulsiveSex", Missing = 0)))
		StorageUtil.SetIntValue(Self, "CompulsiveSexFuckTimeOID_S", AddSliderOption("Time Between Fucks", (Game.GetFormFromFile(0x0E7553, "SL Survival.esp") as _SLS_CompulsiveSex).TimeBetweenFucks, "{1}x"))
		AddEmptyOption()
		
		AddHeaderOption("Orgasm Fatigue")
		StorageUtil.SetIntValue(Self, "OrgasmFatigueOID", AddToggleOption("Orgasm Fatigue", StorageUtil.GetIntValue(Self, "OrgasmFatigue", Missing = 1)))
		StorageUtil.SetIntValue(Self, "OrgasmFatigueThresholdOID_S", AddSliderOption("Orgasm Threshold", (Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmThreshold, "{0}", OrgasmFatigueFlag))
		StorageUtil.SetIntValue(Self, "OrgasmFatigueRecoveryOID_S", AddSliderOption("Orgasm Recovery", (Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmRecoveryPerHour, "{1}", OrgasmFatigueFlag))
		AddEmptyOption()
		
		AddHeaderOption("Minimum Sex Stamina/Magicka")
		SexMinStamMagRatesOID = AddToggleOption("Enable Min Stamina/Magicka", SexMinStamMagRates, SexExpEnFlag)
		SexMinStaminaRateOID_S = AddSliderOption("Minimum Stamina Rate: ", SexMinStaminaRate, "{1}", MinStamMagFlag)
		SexMinStaminaMultOID_S = AddSliderOption("Minimum Stamina Rate Mult: ", SexMinStaminaMult, "{0}", MinStamMagFlag)
		SexMinMagickaRateOID_S = AddSliderOption("Minimum Magicka Rate: ", SexMinMagickaRate, "{1}", MinStamMagFlag)
		SexMinMagickaMultOID_S = AddSliderOption("Minimum Magicka Rate Mult: ", SexMinMagickaMult, "{0}", MinStamMagFlag)
		SexRapeDrainsAttributesOID = AddToggleOption("Drain Magicka & Stamina After Rape", RapeDrainsAttributes, SexExpEnFlag)
		AddEmptyOption()
		
		SetCursorPosition(1)
		AddHeaderOption("Creature Settings")
		SlsCreatureEventOID = AddToggleOption("Creature Content", Init.SlsCreatureEvents)
		AddFondleToListOID_T = AddTextOption("Add Fondle-able Creature: " + CrosshairRefString, "", FondleAddFlag)
		RemoveFondleFromListOID_T = AddTextOption("Remove Fondle-able Creature: " + CrosshairRefString, "", FondleRemoveFlag)
		FondleInfoOID_T = AddTextOption("Creature Breeder Experience: ", Util.CreatureFondleCount as Int)
		AddEmptyOption()
		
		AddHeaderOption("Animal Breeder ")
		AnimalBreedEnableOID = AddToggleOption("Enable Animal Breeding", AnimalBreedEnable)
		AfCooloffBaseOID_S = AddSliderOption("Cooloff Base", AnimalFriend.BreedingCooloffBase, "{1} Hours", AnimalBreedFlag)
		AfCooloffBodyCumOID_S = AddSliderOption("Cooloff Body Cum", AnimalFriend.BreedingCooloffCumCovered, "{1} Hours", AnimalBreedFlag)
		AfCooloffCumInflationOID_S = AddSliderOption("Cooloff Cum Inflation", AnimalFriend.BreedingCooloffCumFilled, "{1} Hours", AnimalBreedFlag)
		AfCooloffCumSwallowOID_S = AddSliderOption("Cooloff Cum Swallow", AnimalFriend.SwallowBonus, "{1} Hours", AnimalBreedFlag)
		AfCooloffPregnancyOID_S = AddSliderOption("Cooloff Pregnancy", AnimalFriend.BreedingCooloffPregnancy, "{1} Hours", AnimalBreedFlag)
		String FriendRef = "None "
		ObjectReference ObjRef = (_SLS_AnimalFriendAliases.GetNthAlias(0) as ReferenceAlias).GetReference()
		If ObjRef != None
			;Debug.Messagebox(ObjRef)
			FriendRef = ObjRef.GetBaseObject().GetName() + " - " + StringUtil.Substring(ObjRef, StringUtil.Find(ObjRef, "(", 0) + 1, len = 8)
		EndIf
		AddTextOption("Animal Friend 0: " + FriendRef, "", AnimalBreedFlag)
		AddEmptyOption()
		
		AddHeaderOption("Rape Drugs")
		StorageUtil.SetIntValue(Self, "RapeDrugLactacidOID", AddToggleOption("Lactacid ", ForceDrug.RapeDrugLactacid, DrugLactacidFlag))
		StorageUtil.SetIntValue(Self, "RapeDrugSkoomaOID", AddToggleOption("Skooma ", ForceDrug.RapeDrugSkooma, DrugSkoomaFlag))
		StorageUtil.SetIntValue(Self, "RapeDrugCumHumanOID", AddToggleOption("Cum - Human", ForceDrug.RapeDrugHumanCum, HardMode))
		StorageUtil.SetIntValue(Self, "RapeDrugCumCreatureOID", AddToggleOption("Cum - Creature", ForceDrug.RapeDrugCreatureCum, HardMode))
		StorageUtil.SetIntValue(Self, "RapeDrugInflateOID", AddToggleOption("Inflate Potion", ForceDrug.RapeDrugInflate, DrugInflateFlag))
		StorageUtil.SetIntValue(Self, "RapeDrugFmFertilityOID", AddToggleOption("FM Fertility Potion", ForceDrug.RapeDrugFmFertility, DrugFmFertilityFlag))
		StorageUtil.SetIntValue(Self, "RapeDrugSlenAphrodisiacOID", AddToggleOption("SLEN Aphrodisiac", ForceDrug.RapeDrugSlenAphrodisiac, DrugSlenFlag))
		AddEmptyOption()
		
		AddHeaderOption("Fashion Rape")
		StorageUtil.SetIntValue(Self, "FashionRapeHaircutChanceOID_S", AddSliderOption("Haircut Chance: ", FashionRape.HaircutChance, "{1}%", FashionFlag))
		StorageUtil.SetIntValue(Self, "FashionRapeHairCutMinOID_S", AddSliderOption("Haircut Min: ", FashionRape.HairCutMinLevel, "{0} Stages", FashionFlag))
		StorageUtil.SetIntValue(Self, "FashionRapeHairCutMaxOID_S", AddSliderOption("Haircut Max: ", FashionRape.HairCutMaxLevel, "{0} Stages", FashionFlag))
		StorageUtil.SetIntValue(Self, "FashionRapeHairCutFloorOID_S", AddSliderOption("Haircut Floor: ", FashionRape.HaircutFloor, "Stage {0}", FashionFlag))
		StorageUtil.SetIntValue(Self, "FashionRapeDyeHairChanceOID_S", AddSliderOption("Dye Hair Chance: ", FashionRape.DyeHairChance, "{1}%", FashionFlag))
		StorageUtil.SetIntValue(Self, "FashionRapeShavePussyChanceOID_S", AddSliderOption("Shave Pussy Chance: ", FashionRape.ShavePussyChance, "{1}%", FashionFlag))
		StorageUtil.SetIntValue(Self, "FashionRapeLipstickChanceOID_S", AddSliderOption("Smudge Lipstick Chance: ", FashionRape.SmudgeLipstickChance, "{1}%", FashionFlag))
		StorageUtil.SetIntValue(Self, "FashionRapeEyeshadowChanceOID_S", AddSliderOption("Smudge Eyeshadow Chance: ", FashionRape.SmudgeEyeshadowChance, "{1}%", FashionFlag))
		AddEmptyOption()
		
	ElseIf(page == "Misogyny & Inequality")
		Int StaInstalledFlag = OPTION_FLAG_DISABLED
		Int ProxSpankOptionsFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("Spank That Ass.esp") != 255
			StaInstalledFlag = OPTION_FLAG_NONE
			If ProxSpankNpcType != 5
				ProxSpankOptionsFlag = OPTION_FLAG_NONE
			EndIf
		EndIf

		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("General Settings")
		GreetDistOIS_S = AddSliderOption("Npc Greeting Distance:", Game.GetGameSettingFloat("fAIMinGreetingDistance"), "{0}")
		CoverMyselfMechanicsOID = AddToggleOption("Cover Mechanics", CoverMyselfMechanics)
		StorageUtil.SetIntValue(Self, "NpcCommentsOID", AddToggleOption("Npc Comments", (Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).GetValueInt())) ; _SLS_NpcComments
		PushEventsDB = AddMenuOption("Push Events", PushEventsType[PushEvents], 0)
		StorageUtil.SetIntValue(Self, "PushCooldownOID_S", AddSliderOption("Push Cooldown", (Game.GetFormFromFile(0x0E651A, "SL Survival.esp") as _SLS_PushPlayerCooloff).CooloffPeriod, "{1} Hours"))
		AddEmptyOption()
		
		AddHeaderOption("Cat Calling")
		CatCallVolOIS_S = AddSliderOption("Cat Call Volume:", CatCallVol, "{0}%")
		CatCallWillLossOIS_S = AddSliderOption("Cat Call Resistance Loss:", CatCallWillLoss, "{0}")
		AddEmptyOption()
		
		AddHeaderOption("Survival Ass Slapping")
		AssSlappingOID = AddToggleOption("Ass Slapping Events", AssSlappingEvents)
		AddEmptyOption()
		
		AddHeaderOption("Spank That Ass Slapping")
		AssSlapResistLossOID_S = AddSliderOption("Spank Resistance Loss", AssSlapResistLoss, "{0}")
		ProxSpankNpcDB = AddMenuOption("Proximity Spank Npcs", ProxSpankNpcList[ProxSpankNpcType], StaInstalledFlag)
		ProxSpankCoverDB = AddMenuOption("Proximity Spank Cover", ProxSpankRequiredCoverList[_SLS_ProxSpankRequiredCover.GetValueInt()], ProxSpankOptionsFlag)
		ProxSpankCooloffOID_S = AddSliderOption("Proximity Spank Cooloff", ProxSpankCooloff, "{0} seconds", ProxSpankOptionsFlag)
		ProxSpankCommentOID = AddToggleOption("Do Prox Spank Comment", Util.ProxSpankComment, ProxSpankOptionsFlag)
		AddEmptyOption()
		
		AddHeaderOption("Guard Behaviour")
		GuardCommentsOID = AddToggleOption("Guard Comments", GuardComments)
		GuardBehavLockpickingOID = AddToggleOption("Lockpicking ", GuardBehavLockpicking, HardMode)
		GuardBehavDrugsOID = AddToggleOption("Drugs ", GuardBehavDrugs, HardMode)
		GuardBehavShoutOID = AddToggleOption("Shouting ", _SLS_GuardBehavShoutEn.GetValueInt() as Bool, HardMode)
		GuardBehavWeapDropOID = AddToggleOption("Weapon Dropping", _SLS_GuardBehavWeapDropEn.GetValueInt() as Bool, HardMode)
		GuardBehavWeapDrawnOID = AddToggleOption("Weapons Drawn", GuardBehavWeapDrawn, HardMode)
		GuardBehavWeapEquipOID = AddToggleOption("Weapons Equipped", GuardBehavWeapEquip, HardMode)
		GuardBehavArmorEquipOID = AddToggleOption("Armor Equipped", GuardBehavArmorEquip, HardMode)
		StorageUtil.SetIntValue(Self, "GuardBehavArmorEquipAnyArmorOID", AddToggleOption("Any Armor", StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmor", Missing = 0), HardMode))
		AddEmptyOption()

		Int IneqStatsFlag = OPTION_FLAG_DISABLED
		If _SLS_IneqStat.GetValueInt() == 1 && !IsHardcoreLocked
			IneqStatsFlag = OPTION_FLAG_NONE
		EndIf
		
		Int IneqCarryFlag = OPTION_FLAG_DISABLED
		If _SLS_IneqCarry.GetValueInt() == 1 && !IsHardcoreLocked
			IneqCarryFlag = OPTION_FLAG_NONE
		EndIf
		
		Int IneqSpeedFlag = OPTION_FLAG_DISABLED
		If _SLS_IneqSpeed.GetValueInt() == 1 && !IsHardcoreLocked
			IneqSpeedFlag = OPTION_FLAG_NONE
		EndIf
		
		Int IneqDamageFlag = OPTION_FLAG_DISABLED
		If _SLS_IneqDamage.GetValueInt() == 1 && !IsHardcoreLocked
			IneqDamageFlag = OPTION_FLAG_NONE
		EndIf
		Int IneqDestFlag = OPTION_FLAG_DISABLED
		If _SLS_IneqDestruction.GetValueInt() == 1 && !IsHardcoreLocked
			IneqDestFlag = OPTION_FLAG_NONE
		EndIf
		
		String StrongFemString = "Remove "
		Int CrossHairRefFlag = OPTION_FLAG_DISABLED
		Actor CrossHairRef = Game.GetCurrentCrosshairRef() as Actor
		If CrossHairRef && CrossHairRef.GetActorBase().GetSex() == 1
			CrossHairRefFlag = OPTION_FLAG_NONE
			If !CrossHairRef.IsInFaction(_SLS_IneqStrongFemaleFact)
				StrongFemString = "Add "
			EndIf
		EndIf
		
		SetCursorPosition(1)
		AddHeaderOption("Inequality ")
		IneqStatsOID = AddToggleOption("Stats Change", _SLS_IneqStat.GetValueInt(), HardMode)
		IneqStatsValOID = AddSliderOption("Stats Value ", IneqStatsVal, "{0} Points", IneqStatsFlag)
		IneqHealthCushionOID = AddSliderOption("Health Cushion ", IneqHealthCushion, "{0} Points", IneqStatsFlag)
		IneqCarryOID = AddToggleOption("Carry Weight Change", _SLS_IneqCarry.GetValueInt(), HardMode)
		IneqCarryValOID = AddSliderOption("Carry Weight Value ", IneqCarryVal, "{0} Points", IneqCarryFlag)
		InqSpeedOID = AddToggleOption("Speed Change", _SLS_IneqSpeed.GetValueInt(), HardMode)
		IneqSpeedValOID = AddSliderOption("Speed Value ", IneqSpeedVal, "{0} Points", IneqSpeedFlag)
		IneqDamageOID = AddToggleOption("Damage Changes", _SLS_IneqDamage.GetValueInt(), HardMode)
		IneqDamageValOID = AddSliderOption("Damage Value ", IneqDamageVal, "{1}%", IneqDamageFlag)
		IneqDestOID = AddToggleOption("Destruction Changes", _SLS_IneqDestruction.GetValueInt(), HardMode)
		IneqDestValOID = AddSliderOption("Destruction Value ", IneqDestVal, "{1}%", IneqDestFlag)
		IneqSkillsOID = AddToggleOption("Skill Gain Change", InequalitySkills, HardMode)
		IneqBuySellOID = AddToggleOption("Buy/Sell Prices Change", InequalityBuySell, HardMode)
		IneqVendorGoldOID = AddSliderOption("Female Vendor Gold", IneqFemaleVendorGoldMult, "{2}x", HardMode)
		IneqStrongFemaleFollowersOID = AddToggleOption("Female Followers Are Strong", IneqStrongFemaleFollowers, HardMode)
		ModStrongFemaleOID_T = AddTextOption(StrongFemString + "Strong Female", "", CrossHairRefFlag)
		AddEmptyOption()
		
	ElseIf page == "Trauma "
		SetCursorFillMode(TOP_TO_BOTTOM)
		Int TraumaFlag = OPTION_FLAG_DISABLED
		If Trauma.TraumaEnable
			TraumaFlag = OPTION_FLAG_NONE
		EndIf
		Int DynamicTraumaFlag = OPTION_FLAG_DISABLED
		If Trauma.TraumaEnable && Trauma.DynamicTrauma
			DynamicTraumaFlag = OPTION_FLAG_NONE
		EndIf

		Actor akTarget = Game.GetCurrentCrosshairRef() as Actor
		Int ValidTargetFlag = OPTION_FLAG_DISABLED
		String AddRemoveString = "Track "
		String FollowerName = "No Target"
		String IsDynamicNpc = ""
		If Trauma.TraumaEnable && akTarget && akTarget.IsInFaction(Game.GetFormFromFile(0x05C84D, "Skyrim.esm") as Faction) ; PotentialFollowerFaction
			ValidTargetFlag = OPTION_FLAG_NONE
			FollowerName = akTarget.GetLeveledActorBase().GetName()
			If akTarget.IsInFaction(Trauma._SLS_TraumaFaction)
				AddRemoveString = "Untrack "
			EndIf
			If StorageUtil.FormListHas(Trauma._SLS_TraumaDynamicQuest, "_SLS_TraumaActors", akTarget)
				IsDynamicNpc = " - Dynamic"
			EndIf
		EndIf
		
		AddHeaderOption("General ")
		StorageUtil.SetIntValue(Self, "TraumaPainSoundVolOID_S", AddSliderOption("Pain Sound Volume", Util.PainSoundVol * 100.0, "{0}%"))
		StorageUtil.SetIntValue(Self, "TraumaHitSoundVolOID_S", AddSliderOption("Hit Sound Volume", Util.HitSoundVol * 100.0, "{0}%"))
		StorageUtil.SetIntValue(Self, "TraumaPlayerSqueaksOID", AddToggleOption("Player Squeaks", Trauma.PlayerSqueaks, TraumaFlag))
		AddEmptyOption()
		
		AddHeaderOption("Trauma ")
		StorageUtil.SetIntValue(Self, "TraumaEnableOID", AddToggleOption("Enable Trauma", Trauma.TraumaEnable))
		StorageUtil.SetIntValue(Self, "TraumaRebuildTexturesOID_T", AddTextOption("Reset Texture Lists", "", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaDynamicOID", AddToggleOption("Dynamic Npc Trauma", Trauma.DynamicTrauma, TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaDynamicCombatOID", AddToggleOption("Dynamic Combat Trauma", Trauma.DynamicCombat, DynamicTraumaFlag))
		AddEmptyOption()
		
		AddHeaderOption("Assign Followers")
		StorageUtil.SetIntValue(Self, "TraumaTrackFollowerOID_T", AddTextOption(FollowerName + IsDynamicNpc, AddRemoveString, ValidTargetFlag))
		AddEmptyOption()
		
		AddHeaderOption("Tracked Followers")
		Quest TraumaAssignedQuest = Game.GetFormFromFile(0x0F3D04, "SL Survival.esp") as Quest
		
		Int i = 0
		While i < TraumaAssignedQuest.GetNumAliases()
			akTarget = (TraumaAssignedQuest.GetNthAlias(i) as ReferenceAlias).GetReference() as Actor
			If akTarget
				AddTextOption(akTarget.GetLeveledActorBase().GetName(), "", TraumaFlag)
			Else
				AddTextOption("Empty ", "", TraumaFlag)
			EndIf
			i += 1
		EndWhile
		
		SetCursorPosition(1)
		AddHeaderOption("Max # Of Traumas")
		StorageUtil.SetIntValue(Self, "TraumaCountMaxPlayerOID_S", AddSliderOption("Player Max Traumas", Trauma.PlayerTraumaCountMax, "{0}", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaCountMaxFollowerOID_S", AddSliderOption("Follower Max Traumas", Trauma.FollowerTraumaCountMax, "{0}", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaCountMaxNpcOID_S", AddSliderOption("Npc Max Traumas", Trauma.NpcTraumaCountMax, "{0}", TraumaFlag))
		AddEmptyOption()
		
		AddHeaderOption("Opacity & Duration")
		StorageUtil.SetIntValue(Self, "TraumaStartingOpacityOID_S", AddSliderOption("Starting Opacity", Trauma.StartingAlpha * 100.0, "{0}%", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaMaximumOpacityOID_S", AddSliderOption("Maximum Opacity", Trauma.MaxAlpha * 100.0, "{0}%", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaHoursToFadeInOID_S", AddSliderOption("Hours To Fade In", Trauma.HoursToMaxAlpha, "{0} Hours", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaHoursToFadeOutOID_S", AddSliderOption("Hours To Fade Out", Trauma.HoursToFadeOut, "{0} Hours", TraumaFlag))
		AddEmptyOption()
		
		AddHeaderOption("Sex Trauma")
		StorageUtil.SetIntValue(Self, "TraumaSexChancePlayerOID_S", AddSliderOption("Player Trauma Chance", Trauma.SexChancePlayer, "{0}%", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaSexChanceFollowerOID_S", AddSliderOption("Follower Trauma Chance", Trauma.SexChanceFollower, "{0}%", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaSexChanceOID_S", AddSliderOption("Npc Trauma Chance", Trauma.SexChanceNpc, "{0}%", TraumaFlag))
		AddEmptyOption()
		StorageUtil.SetIntValue(Self, "TraumaSexHitsPlayerOID_S", AddSliderOption("Player Trauma Hits", Trauma.SexHitsPlayer, "{0} Hits", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaSexHitsFollowerOID_S", AddSliderOption("Follower Trauma Hits", Trauma.SexHitsFollower, "{0} Hits", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaSexHitsOID_S", AddSliderOption("Npc Trauma Hits", Trauma.SexHitsNpc, "{0} Hits", TraumaFlag))
		AddEmptyOption()
		
		AddHeaderOption("Combat Trauma")
		StorageUtil.SetIntValue(Self, "TraumaDamageThresholdOID_S", AddSliderOption("Damage Threshold", Trauma.CombatDamageThreshold, "{0} Points", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaCombatChancePlayerOID_S", AddSliderOption("Player Trauma Chance", Trauma.CombatChancePlayer, "{0}%", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaCombatChanceFollowerOID_S", AddSliderOption("Follower Trauma Chance", Trauma.CombatChanceFollower, "{0}%", TraumaFlag))
		StorageUtil.SetIntValue(Self, "TraumaCombatChanceOID_S", AddSliderOption("Npc Trauma Chance", Trauma.CombatChanceNpc, "{0}%", TraumaFlag))
		AddEmptyOption()
		
		AddHeaderOption("Push Traumas")
		StorageUtil.SetIntValue(Self, "TraumaPushChancePlayerOID_S", AddSliderOption("Push Trauma Chance", Trauma.PushChance, "{0}%", TraumaFlag))
		AddEmptyOption()

	ElseIf page == "Needs "
		
		; Flags
		Int RndFlag = OPTION_FLAG_DISABLED
		Int IneedFlag = OPTION_FLAG_DISABLED
		Int EatingSleepingDrinkingFlag = OPTION_FLAG_DISABLED
		Int BellyNeedsMod = OPTION_FLAG_DISABLED
		Int AnyNeedsMod = OPTION_FLAG_DISABLED
		Int BellyScaleRndFlag = OPTION_FLAG_DISABLED
		Int BellyScaleIneedFlag = OPTION_FLAG_DISABLED

		If Game.GetModByName("RealisticNeedsandDiseases.esp") != 255
			RndFlag = OPTION_FLAG_NONE
		EndIf
		If Game.GetModByName("iNeed.esp") != 255
			IneedFlag = OPTION_FLAG_NONE
		EndIf
		If Game.GetModByName("EatingSleepingDrinking.esp") != 255
			EatingSleepingDrinkingFlag = OPTION_FLAG_NONE
		EndIf
		If RndFlag == OPTION_FLAG_NONE || IneedFlag == OPTION_FLAG_NONE
			BellyNeedsMod = OPTION_FLAG_NONE
		EndIf
		If RndFlag == OPTION_FLAG_NONE || IneedFlag == OPTION_FLAG_NONE || EatingSleepingDrinkingFlag == OPTION_FLAG_NONE
			AnyNeedsMod = OPTION_FLAG_NONE
		EndIf
		
		If BellyScaleEnable && RndFlag == OPTION_FLAG_NONE
			BellyScaleRndFlag = OPTION_FLAG_NONE
		EndIf
		If BellyScaleEnable && IneedFlag == OPTION_FLAG_NONE
			BellyScaleIneedFlag = OPTION_FLAG_NONE
		EndIf
	
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Gluttony ")
		GluttedSpeedMultOID_S = AddSliderOption("Gluttony Speed Penalty ", GluttedSpeed, "{0}", RndFlag)
		AddEmptyOption()
		
		AddHeaderOption("Sleep Deprivation ")
		SleepDeprivOID = AddToggleOption("Sleep Deprivation", SleepDepriv)
		AddEmptyOption()
		
		AddHeaderOption("Belly Scaling ")
		BellyScaleEnableOID = AddToggleOption("Enable Belly Scaling ", BellyScaleEnable, BellyNeedsMod)
		BaseBellyScaleOID_S = AddSliderOption("My Base Belly Scale Is", Needs.BaseBellyScale, "{1}", BellyNeedsMod)
		AddEmptyOption()
		
		AddHeaderOption("Rnd Belly Scaling ")
		BellyScaleRnd00OID_S = AddSliderOption("Glutted: ", Rnd.BellyScaleRnd00, "{2}", BellyScaleRndFlag)
		BellyScaleRnd01OID_S = AddSliderOption("Satiated: ", Rnd.BellyScaleRnd01, "{2}", BellyScaleRndFlag)
		BellyScaleRnd02OID_S = AddSliderOption("Peckish: ", Rnd.BellyScaleRnd02, "{2}", BellyScaleRndFlag)
		BellyScaleRnd03OID_S = AddSliderOption("Hungry: ", Rnd.BellyScaleRnd03, "{2}", BellyScaleRndFlag)
		BellyScaleRnd04OID_S = AddSliderOption("Very Hungry: ", Rnd.BellyScaleRnd04, "{2}", BellyScaleRndFlag)
		BellyScaleRnd05OID_S = AddSliderOption("Starving: ", Rnd.BellyScaleRnd05, "{2}", BellyScaleRndFlag)
		
		SetCursorPosition(1)
		AddHeaderOption("Fatigue And Drugs ")
		SkoomaSleepOID_S = AddSliderOption("Skooma Reduces Fatigue By", SkoomaSleep, "{1}x More ", AnyNeedsMod)
		MilkSleepMultOID_S = AddSliderOption("Milk Reduces Fatigue By", MilkSleepMult, "{1}x More ", AnyNeedsMod)
		DrugEndFatigueIncOID_S = AddSliderOption("Effect End Fatigue Increase", DrugEndFatigueInc * 100.0, "{0}% ", AnyNeedsMod)
		AddEmptyOption()
		
		AddHeaderOption("Cum ")
		CumFoodMultOID_S = AddSliderOption("Cum Provides", Needs.CumFoodMult, "{2}x More 'Food'", AnyNeedsMod)
		CumDrinkMultOID_S = AddSliderOption("Cum Provides", Needs.CumDrinkMult, "{2}x More 'Water'", AnyNeedsMod)
		SaltyCumOID = AddToggleOption("Salty Cum", SaltyCum, AnyNeedsMod)
		AddEmptyOption()
		
		SetCursorPosition(21)
		AddHeaderOption("iNeed Belly Scaling ")
		BellyScaleIneed00OID_S = AddSliderOption("Satiated: ", Ineed.BellyScaleIneed00, "{2}", BellyScaleIneedFlag)
		BellyScaleIneed01OID_S = AddSliderOption("Mild: ", Ineed.BellyScaleIneed01, "{2}", BellyScaleIneedFlag)
		BellyScaleIneed02OID_S = AddSliderOption("Moderate: ", Ineed.BellyScaleIneed02, "{2}", BellyScaleIneedFlag)
		BellyScaleIneed03OID_S = AddSliderOption("Severe: ", Ineed.BellyScaleIneed03, "{2}", BellyScaleIneedFlag)
		AddEmptyOption()
		
	ElseIf(page == "Cum ")
		Int CumEffectsFlag = OPTION_FLAG_DISABLED
		If CumEffectsEnable
			CumEffectsFlag = OPTION_FLAG_NONE
		EndIf
		
		Int CumSwallowInflateFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("sr_FillHerUp.esp") != 255
			CumSwallowInflateFlag = OPTION_FLAG_NONE
		EndIf
		
		Int MmeInstalledFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("MilkModNEW.esp") != 255
			MmeInstalledFlag = OPTION_FLAG_NONE
		EndIf
		
		Int CumAddictionFlag = OPTION_FLAG_DISABLED
		Int CumAddictHungerEffectiveFlag = OPTION_FLAG_DISABLED
		Int CreatureContentFlag = OPTION_FLAG_DISABLED
		If CumAddictEn
			CumAddictionFlag = OPTION_FLAG_NONE
			If Init.SlsCreatureEvents
				CreatureContentFlag = OPTION_FLAG_NONE
				If CumAddictBeastLevels
					CumAddictHungerEffectiveFlag = OPTION_FLAG_NONE
				EndIf
			EndIf
		EndIf
		
		Int PsqFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("PSQ PlayerSuccubusQuest.esm") != 255
			PsqFlag = OPTION_FLAG_NONE
		EndIf
	
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Cum Options")
		CumBreathOID = AddToggleOption("Cum Breath", CumBreath)
		CumBreathNotifyOID = AddToggleOption("Cum Breath Notifications", CumBreathNotify)
		MilkDecCumBreathOID = AddToggleOption("Milk Decreases Cum Breath", MilkDecCumBreath)
		AproTwoTrollHealAmountOID = AddSliderOption("Troll Cum Heals Apropos2", AproTwoTrollHealAmount, "{0}")
		CumSwallowInflateOID = AddToggleOption("Swallowing Cum Inflates Belly", CumSwallowInflate, CumSwallowInflateFlag)
		CumSwallowInflateMultOID_S = AddSliderOption("Cum Inflation Mult", CumSwallowInflateMult, "{1}x", CumSwallowInflateFlag)
		CumEffectsEnableOID = AddToggleOption("Enable Cum Magic Effects", CumEffectsEnable)
		CumEffectsStackOID = AddToggleOption("Cum Magic Effects Stack", CumEffectsStack, CumEffectsFlag)
		CumEffectsMagMultOID_S = AddSliderOption("Cum Magic Magnitude Mult", CumEffectsMagMult, "{1}x", CumEffectsFlag)
		CumEffectsDurMultOID_S = AddSliderOption("Cum Magic Duration Mult", CumEffectsDurMult, "{1}x", CumEffectsFlag)
		CumpulsionChanceOID_S = AddSliderOption("Cumpulsion Chance", CumpulsionChance, "{0}%", CumEffectsFlag)
		CumRegenTimeOID_S = AddSliderOption("Cum Replenish Time", CumRegenTime, "{0} Hours")
		CumEffectVolThresOID_S = AddSliderOption("Magic Effect Threshold", CumEffectVolThres, "{0}%")
		AddEmptyOption()

		AddHeaderOption("Cum Addiction")
		CumAddictEnOID = AddToggleOption("Cum Addiction Enable", CumAddictEn)
		CumSatiationOID_S = AddSliderOption("Cum Satiation", CumSatiation, "{1}x", CumAddictionFlag)
		CumAddictClampHungerOID = AddToggleOption("Clamp Hunger", CumAddictClampHunger, CumAddictionFlag)
		CumAddictHungerRateOID_S = AddSliderOption("Hunger Rate", CumAddictionHungerRate, "{2} Points Per Hour", CumAddictionFlag)
		CumAddictHungerRateEffective = AddTextOption("Current Effective Hunger Rate: ", ((CumAddictBeastLevels as Float) * (CumAddict.GetAddictionState() * CumAddictionHungerRate)), CumAddictHungerEffectiveFlag)
		CumAddictBeastLevelsOID = AddToggleOption("Encourage Beastiality", CumAddictBeastLevels, CreatureContentFlag)
		CumAddictionSpeedOID_S = AddSliderOption("Cum Addiction Speed", CumAddictionSpeed, "{1}x", CumAddictionFlag)
		CumAddictionPerHourOID_S = AddSliderOption("Cum Addiction Decay", CumAddictionDecayPerHour, "{2} Points Per Hour", CumAddictionFlag)
		StorageUtil.SetIntValue(Self, "CumAddictBlockDecayOID", AddToggleOption("Cum Blocks Addiction Decay", CumAddict.CumBlocksAddictionDecay, CumAddictionFlag))
		StorageUtil.SetIntValue(Self, "CumAddictDayDreamOID", AddToggleOption("Daydreaming", StorageUtil.GetIntValue(Self, "CumAddictDayDream", Missing = 1), CumAddictionFlag))
		StorageUtil.SetIntValue(Self, "CumAddictDayDreamVolOID_S", AddSliderOption("Daydream Volume Modifier", StorageUtil.GetFloatValue(Self, "CumAddictDayDreamVol", Missing = 1.0) * 100.0, "{0}%", CumAddictionFlag))
		StorageUtil.SetIntValue(Self, "CumAddictDayDreamButterflysOID", AddToggleOption("Daydream Butterflys", StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflys", Missing = 1), CumAddictionFlag))
		AddEmptyOption()
		
		AddHeaderOption("Addict Actions")
		CumAddictBatheRefuseTimeOID_S = AddSliderOption("Refuse To Bathe For", CumAddictBatheRefuseTime, "{0} hours", CumAddictionFlag)
		CumAddictReflexSwallowOID_S = AddSliderOption("Instinctive Swallow Chance", CumAddictReflexSwallow, "{1}x", CumAddictionFlag)
		CumAddictAutoSuckCreatureOID_S = AddSliderOption("Auto Suck Creature Chance", CumAddictAutoSuckCreature, "{1}x", CreatureContentFlag)
		CumAddictAutoSuckStageDB = AddMenuOption("Auto Suck At", CumHungerStrings[CumHungerAutoSuck], CumAddictionFlag)
		CumAddictAutoSuckCooldownOID_S = AddSliderOption("Auto Suck Creature Cooldown", CumAddictAutoSuckCooldown, "{0} Hours", CreatureContentFlag)
		CumAddictAutoSuckCreatureArousalOID_S = AddSliderOption("Auto Suck Creature Arousal", CumAddictAutoSuckCreatureArousal, "{0}", CreatureContentFlag)
		StorageUtil.SetIntValue(Self, "CumAddictAutoSuckVictim", AddToggleOption("Auto Suck Victim", CumAddict.AutoSuckVictim, CreatureContentFlag))
		AddEmptyOption()
		
		If CumAddictEn
			AddHeaderOption("Current Stats")
			AddTextOption("Addiction Points:", _SLS_CumAddictionPool.GetValue() + " (" + CumAddict.GetCurrentAddictionString() + ")")
			AddTextOption("Hunger Points:", _SLS_CumAddictionHunger.GetValue() + " (" + CumAddict.GetCurrentHungerString() + ")")
			AddEmptyOption()
			
			AddHeaderOption("Current Hunger Range Values")
			AddTextOption("Hunger Points Satisfied: ", _SLS_CumHunger0.GetValue())
			AddTextOption("Hunger Points Peckish: ", _SLS_CumHunger1.GetValue())
			AddTextOption("Hunger Points Hungry: ", _SLS_CumHunger2.GetValue())
			AddTextOption("Hunger Points Starving: ", _SLS_CumHunger3.GetValue())
			AddTextOption("Hunger Points Ravenous: >=", _SLS_CumHunger3.GetValue())
			AddEmptyOption()
			
			AddHeaderOption("Current Addiction Gain Per Hour From")
			Float CumGainSkin = CumAddict.ProcSkinCumAddiction(DoProc = false, HoursPassed = 1.0)
			Float CumGainVag = CumAddict.ProcVagCumAddiction(DoProc = false, HoursPassed = 1.0)
			Float CumGainAnal = CumAddict.ProcAnalCumAddiction(DoProc = false, HoursPassed = 1.0)
			AddTextOption("Cum On Skin:", CumGainSkin)
			AddTextOption("Cum In Pussy:", CumGainVag)
			AddTextOption("Cum In Ass:", CumGainAnal)
			AddTextOption("Total Gain Per Hour:", CumGainAnal + CumGainVag + CumGainSkin)
			AddEmptyOption()
			
			AddHeaderOption("Satiation Provided By")
			AddTextOption("Small Loads:", Util.GetLoadSize(CumSource = None, LoadTier = 1) * CumSatiation)
			AddTextOption("Average Loads:", Util.GetLoadSize(CumSource = None, LoadTier = 2) * CumSatiation)
			AddTextOption("Big Loads:", Util.GetLoadSize(CumSource = None, LoadTier = 4) * CumSatiation)
			AddEmptyOption()
		EndIf
		
		Actor CrosshairRef = Game.GetCurrentCrosshairRef() as Actor
		String AddRemoveString = "No Crosshair Ref"
		Int CrosshairRefFlag = OPTION_FLAG_DISABLED
		If Init.MmeInstalled && CrossHairRef && !CumLactacidAll
			VoiceType Voice = CrossHairRef.GetVoiceType()
			If Voice
				String VoiceString = Voice as String
				VoiceString = StringUtil.Substring(VoiceString, startIndex = 12, len = 0)
				VoiceString = StringUtil.Substring(VoiceString, startIndex = 0, len = (StringUtil.GetLength(VoiceString) - 2))
				If _SLS_CumHasLactacidVoices.HasForm(CrosshairRef.GetVoiceType())
					AddRemoveString = "Remove " + VoiceString
				Else
					AddRemoveString = "Add " + VoiceString
				EndIf
				CrosshairRefFlag = OPTION_FLAG_NONE
			EndIf
		EndIf
		
		Int SpecificCumFlag = OPTION_FLAG_DISABLED
		If !CumLactacidAll
			SpecificCumFlag = OPTION_FLAG_NONE
		EndIf

		SetCursorPosition(1)
		AddHeaderOption("Succubus ")
		SuccubusCumSwallowEnergyMultOID_S = AddSliderOption("Succubus Cum Swallow Energy Mult", SuccubusCumSwallowEnergyMult, "{1}X", PsqFlag)
		SuccubusCumSwallowEnergyPerRankOID = AddToggleOption("Energy Per Succubus Rank", SuccubusCumSwallowEnergyPerRank, PsqFlag)
		AddEmptyOption()
		
		AddHeaderOption("Cum Has Lactacid")
		CumIsLactacidOID_S = AddSliderOption("Cum Provides X Lactacid", (CumIsLactacid * 100.0), "{0}%", MmeInstalledFlag)
		AddEmptyOption()
		CumLactacidAllOID = AddToggleOption("All Races", CumLactacidAll)
		CumLactacidAllPlayableOID = AddToggleOption("All Playable Races", CumLactacidAllPlayable, SpecificCumFlag)
		CumLactacidCustomOID_T = AddTextOption(AddRemoveString, "", CrosshairRefFlag)
		AddEmptyOption()
		
		StorageUtil.SetIntValue(Self, "CumLactacidBearOID", AddToggleOption("Bear ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(0)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidChaurusOID", AddToggleOption("Chaurus ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(1)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDeerOID", AddToggleOption("Deer ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(2)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDogOID", AddToggleOption("Dog ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(3)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDragonPriestOID", AddToggleOption("Dragon Priest", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(4)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDragonOID", AddToggleOption("Dragon ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(5)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDraugrOID", AddToggleOption("Draugr ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(6)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDremoraOID", AddToggleOption("Dremora ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(7)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDwarvenCenturionOID", AddToggleOption("Dwarven Centurion", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(8)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDwarvenSphereOID", AddToggleOption("Dwarven Sphere", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(9)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidDwarvenSpiderOID", AddToggleOption("Dwarven Spider", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(10)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidFalmerOID", AddToggleOption("Falmer ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(11)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidFoxOID", AddToggleOption("Fox ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(12)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidSpiderOID", AddToggleOption("Frostbite Spider", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(13)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidGiantOID", AddToggleOption("Giant ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(15)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidGoatOID", AddToggleOption("Goat ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(16)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidHorkerOID", AddToggleOption("Horker ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(17)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidHorseOID", AddToggleOption("Horse ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(18)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidMammothOID", AddToggleOption("Mammoth ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(19)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidSabrecatOID", AddToggleOption("Sabre Cat", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(20)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidSkeeverOID", AddToggleOption("Skeever ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(21)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidSprigganOID", AddToggleOption("Spriggan ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(22)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidTrollOID", AddToggleOption("Troll ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(23)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidWerewolfOID", AddToggleOption("Werewolf ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(24)), SpecificCumFlag))
		StorageUtil.SetIntValue(Self, "CumLactacidWolfOID", AddToggleOption("Wolf ", _SLS_CumHasLactacidVoices.HasForm(_SLS_CumLactacidVoicesList.GetAt(25)), SpecificCumFlag))
		AddEmptyOption()
		
	ElseIf page == "Frostfall & Simply Knock"
		Int FfRescueEventsFlag = OPTION_FLAG_DISABLED
		If FfRescueEvents && !IsHardcoreLocked
			FfRescueEventsFlag = OPTION_FLAG_NONE
		EndIf
		
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Frostfall ")
		WarmBodiesOID_S = AddSliderOption("Sex Reduces Exposure by ", WarmBodies, "{0} Per Tick")
		MilkLeakWetOID_S = AddSliderOption("Milk Leaking Adds ", MilkLeakWet, "{0} Wetness Per Tick")
		CumWetMultOID_S = AddSliderOption("Cum Gets You ", CumWetMult, "{1}x More Wet")
		CumExposureMultOID_S = AddSliderOption("Cum Recovers ", CumExposureMult, "{1}x More Exposure")
		SwimCumCleanOID_S = AddSliderOption("Swim naked for ", SwimCumClean, "{0} Sec Clears Cum")
		AddEmptyOption()
		
		AddHeaderOption("Frostfall Rescue")
		FfRescueEventsOID = AddToggleOption("Rescue Events ", FfRescueEvents, HardMode)
		SimpleSlaveryFFOID_S = AddSliderOption("Send to Simple Slavery On Rescue ", SimpleSlaveryFF, "{0}%", FfRescueEventsFlag)
		SdDreamFFOID_S = AddSliderOption("Send To SD Dreamworld On Rescue ", SdDreamFF, "{0}%", FfRescueEventsFlag)
		
		SetCursorPosition(1)
		AddHeaderOption("Simply Knock")
		NormalKnockDialogOID = AddToggleOption("Simply Knock Dialog", Init.SKdialog)
		KnockSlaveryChanceOID_S = AddSliderOption("Chance Of Slavery ", KnockSlaveryChance, "{0}%", HardMode)
		SimpleSlaveryWeightOID_S = AddSliderOption("Simple Slavery Weight ", SimpleSlaveryWeight, "{0}%", HardMode)
		SdWeightOID_S = AddSliderOption("SD Weight ", SdWeight, "{0}%", HardMode)

	ElseIf page == "Tolls, Eviction & Gates"
		
		Int AddLocationFlag = OPTION_FLAG_DISABLED
		Int RemoveLocationFlag = OPTION_FLAG_DISABLED
		Location Loc = PlayerRef.GetCurrentLocation()
		If Loc != None
			If GetLocationJurisdictionList(Loc) == None
				AddLocationFlag = OPTION_FLAG_NONE
			Else
				RemoveLocationFlag = OPTION_FLAG_NONE
			EndIf
		EndIf
		
		Int FollowersReqLocked = OPTION_FLAG_NONE
		If IsHardcoreLocked || TollFollowersHardcore
			FollowersReqLocked = OPTION_FLAG_DISABLED
		EndIf
		
		Int CurfewFlag = OPTION_FLAG_DISABLED
		If CurfewEnable && !IsHardcoreLocked
			CurfewFlag = OPTION_FLAG_NONE
		EndIf
		
		Int DrugLactacidFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("MilkModNEW.esp") != 255 && !IsHardcoreLocked
			DrugLactacidFlag = OPTION_FLAG_NONE
		EndIf
		Int DrugSkoomaFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("SexLabSkoomaWhore.esp") != 255 && !IsHardcoreLocked
			DrugSkoomaFlag = OPTION_FLAG_NONE
		EndIf
		Int DrugInflateFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("SexLab Inflation Framework.esp") != 255 && !IsHardcoreLocked
			DrugInflateFlag = OPTION_FLAG_NONE
		EndIf
		Int DrugFmFertilityFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("Fertility Mode.esm") != 255 && !IsHardcoreLocked
			DrugFmFertilityFlag = OPTION_FLAG_NONE
		EndIf
		Int DrugSlenFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("SexLab Eager NPCs.esp") != 255 && !IsHardcoreLocked
			DrugSlenFlag = OPTION_FLAG_NONE
		EndIf

		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Tolls - General")
		StorageUtil.SetIntValue(Self, "TollsEnableOID", AddToggleOption("Enable Tolls", Init.TollEnable, HardMode))
		DoorLockDownOID = AddToggleOption("Lockdown Toll Doors ", DoorLockDownT, HardMode)
		TollFollowersHardcoreOID = AddToggleOption("Lock Followers Required", TollFollowersHardcore, FollowersReqLocked)
		TollFollowersOID_S = AddSliderOption("Followers Needed To Leave ", _SLS_TollFollowersRequired.GetValueInt(), "{0}", FollowersReqLocked)
		TollSexAggDB = AddMenuOption("Aggression ", SexAggressiveness[TollSexAgg], 0)
		TollSexVictimDB = AddMenuOption("Victim ", SexPlayerIsVictim[TollSexVictim], 0)
		
		CurrentLocationOID_T = AddTextOption("My Location: ", GetLocationCurrentString())
		;AddTextOption("This Location Is In: ", GetLocationJurisdictionString(Loc))
		AddTownLocationOID_T = AddTextOption("Add Current Location", "", AddLocationFlag)
		RemoveTownLocationOID_T = AddTextOption("Remove Current Location", "", RemoveLocationFlag)
		AddEmptyOption()
		
		AddHeaderOption("Tolls - Costs")
		TollCostGoldOID_S = AddSliderOption("Gold ", TollUtil.TollCostGold, "{0} Gold", HardMode)
		GoldPerLevelOID = AddToggleOption("Per Player Level ", TollUtil.TollCostPerLevel, HardMode)
		SlaverunFactorOID = AddSliderOption("Enslaved Town Gold Factor ", TollUtil.SlaverunFactor, "{1}x ", HardMode)
		SlaverunJobFactorOID = AddSliderOption("Enslaved Town Job Factor ", TollUtil.SlaverunJobFactor, "{0}x ", HardMode)
		TollCostDevicesOID_S = AddSliderOption("Devious Devices ", TollUtil.TollCostDevices, "{0}", HardMode)
		TollCostTattoosOID_S = AddSliderOption("Tattoos ", TollUtil.TollCostTattoos, "{0}", HardMode)
		TollCostDrugsOID_S = AddSliderOption("Drugs ", TollUtil.TollCostDrugs, "{0}", HardMode)
		AddEmptyOption()
		
		AddHeaderOption("Max Tattoos On ")
		MaxTatsBodyOID_S = AddSliderOption("Body ", MaxTatsBody, "{0}")
		MaxTatsFaceOID_S = AddSliderOption("Head ", MaxTatsFace, "{0}")
		MaxTatsHandsOID_S = AddSliderOption("Hands ", MaxTatsHands, "{0}")
		MaxTatsFeetOID_S = AddSliderOption("Feet ", MaxTatsFeet, "{0}")		
		AddEmptyOption()
		
		AddHeaderOption("Toll Drugs")
		StorageUtil.SetIntValue(Self, "TollDrugLactacidOID", AddToggleOption("Lactacid ", ForceDrug.TollDrugLactacid, DrugLactacidFlag))
		StorageUtil.SetIntValue(Self, "TollDrugSkoomaOID", AddToggleOption("Skooma ", ForceDrug.TollDrugSkooma, DrugSkoomaFlag))
		StorageUtil.SetIntValue(Self, "TollDrugCumHumanOID", AddToggleOption("Cum - Human", ForceDrug.TollDrugHumanCum, HardMode))
		StorageUtil.SetIntValue(Self, "TollDrugCumCreatureOID", AddToggleOption("Cum - Creature", ForceDrug.TollDrugCreatureCum, HardMode))
		StorageUtil.SetIntValue(Self, "TollDrugInflateOID", AddToggleOption("Inflate Potion", ForceDrug.TollDrugInflate, DrugInflateFlag))
		StorageUtil.SetIntValue(Self, "TollDrugFmFertilityOID", AddToggleOption("FM Fertility Potion", ForceDrug.TollDrugFmFertility, DrugFmFertilityFlag))
		StorageUtil.SetIntValue(Self, "TollDrugSlenAphrodisiacOID", AddToggleOption("SLEN Aphrodisiac", ForceDrug.TollDrugSlenAphrodisiac, DrugSlenFlag))

		SetCursorPosition(1)
		Int TollDodgingFlag = OPTION_FLAG_DISABLED
		If TollDodging && !IsHardcoreLocked
			TollDodgingFlag =OPTION_FLAG_NONE
		EndIf
		AddHeaderOption("Eviction ")
		EvictionLimitOID_S = AddSliderOption("Eviction Bounty ", EvictionLimit, "{0} Gold", HardMode)
		SlaverunEvictionLimitOID_S = AddSliderOption("Slaverun Eviction Bounty ", SlaverunEvictionLimit, "{0} Gold", HardMode)
		ConfiscationFineOID_S = AddSliderOption("Release Fee ", ConfiscationFine, "{0} Gold", HardMode)
		ConfiscationFineSlaverunOID_S = AddSliderOption("Release Fee In Slaverun Towns", ConfiscationFineSlaverun, "{0} Gold", HardMode)
		AddEmptyOption()
		
		AddHeaderOption("Toll Evasion")
		TollDodgingOID = AddToggleOption("Enable Toll Evasion ", TollDodging, HardMode)
		TollDodgeGracePeriodOID_S = AddSliderOption("Grace Period ", TollDodgeGracePeriod, "{0} hours", TollDodgingFlag)
		TollDodgeHuntFreqOID_S = AddSliderOption("Polling Frequency ", TollDodgeHuntFreq, "{2} seconds", TollDodgingFlag)
		TollDodgeMaxGuardsOID_S = AddSliderOption("Max Guards ", TollDodgeMaxGuards, "{0}", TollDodgingFlag)
		TollDodgeGiftMenuOID = AddToggleOption("Gift Menu", Init.TollDodgeGiftMenu, TollDodgingFlag)
		TollDodgeItemValueModOID_S = AddSliderOption("Item Value Modifier", TollDodgeItemValueMod, "{2}", TollDodgingFlag)
		TollDodgeDetectDistMaxOID_S = AddSliderOption("Max Detection Distance City", GuardSpotDistNom, "{1} Units", TollDodgingFlag)
		TollDodgeDisguiseBodyPenaltyOID_S = AddSliderOption("Body Cover Penalty", TollDodgeDisguiseBodyPenalty * 100.0, "{0}%", TollDodgingFlag)
		TollDodgeDisguiseHeadPenaltyOID_S = AddSliderOption("Hood Cover Penalty", TollDodgeDisguiseHeadPenalty * 100.0, "{0}%", TollDodgingFlag)
		TollDodgeCurrentSpotDist = AddTextOption("Current Detection Distance City: " , (_SLS_TollDodgeHuntRadius.GetValue() as String), HardMode)
		AddEmptyOption()
		
		AddHeaderOption("Gate Curfew ")
		CurfewEnableOID = AddToggleOption("Enable Gate Curfew ", CurfewEnable)
		StorageUtil.SetIntValue(Self, "GateCurfewBeginOID_S", AddSliderOption("Begin Time", (Game.GetFormFromFile(0x0EAB5A, "SL Survival.esp") as GlobalVariable).GetValue(), "{0}:00 Hours", CurfewFlag)) ; _SLS_GateCurfewBegin
		StorageUtil.SetIntValue(Self, "GateCurfewEndOID_S", AddSliderOption("End Time ", (Game.GetFormFromFile(0x0EAB5B, "SL Survival.esp") as GlobalVariable).GetValue(), "{0}:00 Hours", CurfewFlag)) ; _SLS_GateCurfewEnd
		StorageUtil.SetIntValue(Self, "GateCurfewSlavetownBeginOID_S", AddSliderOption("Slavetown Begin Time", (Game.GetFormFromFile(0x0EE155, "SL Survival.esp") as GlobalVariable).GetValue(), "{0}:00 Hours", CurfewFlag)) ; _SLS_GateCurfewSlavetownBegin
		StorageUtil.SetIntValue(Self, "GateCurfewSlavetownEndOID_S", AddSliderOption("Slavetown End Time ", (Game.GetFormFromFile(0x0EE156, "SL Survival.esp") as GlobalVariable).GetValue(), "{0}:00 Hours", CurfewFlag)) ; _SLS_GateCurfewSlavetownEnd
		AddEmptyOption()
		
	ElseIf(page == "Licences 1")
		String BikCurseTrig = "None "
		If BikiniCurseTriggerArmor
			BikCurseTrig = BikiniCurseTriggerArmor.GetName()
		EndIf
	
		Int HardcoreFlag = OPTION_FLAG_NONE
		If IsHardcoreLocked
			HardcoreFlag = OPTION_FLAG_DISABLED
		EndIf
	
		Int LicFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && !IsHardcoreLocked
			LicFlag = OPTION_FLAG_NONE
		EndIf
		
		Int UnlockStyleFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && !IsHardcoreLocked && LicUtil.LicenceStyle == 3
			UnlockStyleFlag = OPTION_FLAG_NONE
		EndIf
		
		Int BikiniFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && LicUtil.LicBikiniEnable && !IsHardcoreLocked
			BikiniFlag = OPTION_FLAG_NONE
		EndIf
		
		Int ClothesFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && LicUtil.LicClothesEnable && !IsHardcoreLocked
			ClothesFlag = OPTION_FLAG_NONE
		EndIf
		
		Int MagicFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && LicUtil.LicMagicEnable && !IsHardcoreLocked
			MagicFlag = OPTION_FLAG_NONE
		EndIf
		
		Int EscortAddFlag = OPTION_FLAG_DISABLED
		Int EscortRemoveFlag = OPTION_FLAG_DISABLED
		
		Actor Escort = Game.GetCurrentCrosshairRef() as Actor
		If Escort
			If Escort.IsInFaction(PotentialFollowerFaction) && !Escort.IsInFaction(PotentialHireling)
				If _SLS_EscortsList.HasForm(Escort)
					EscortRemoveFlag = OPTION_FLAG_NONE
				Else
					EscortAddFlag = OPTION_FLAG_NONE
				EndIf
			EndIf
		EndIf

		Int OverlayFlag = OPTION_FLAG_DISABLED
		If LicUtil.CurseTats && Init.LicencesEnable
			OverlayFlag = OPTION_FLAG_NONE
		EndIf

		String S1 = "Remove"
		If !_SLS_LicExceptionsArmor.HasForm(EquipSlots[SelectedEquip]) && !_SLS_LicExceptionsWeapon.HasForm(EquipSlots[SelectedEquip])
			S1 = "Add"
		EndIf
	
		Int AddLicExceptionFlag = OPTION_FLAG_DISABLED
		If EquipSlots[SelectedEquip] != None && Init.LicencesEnable
			AddLicExceptionFlag = OPTION_FLAG_NONE
		EndIf
		
		Int OrdinatorInstalledFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("Ordinator - Perks of Skyrim.esp") != 255 && Init.LicencesEnable
			OrdinatorInstalledFlag = OPTION_FLAG_NONE
		EndIf

		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("General Settings")
		LicencesEnableOID = AddToggleOption("Enable/Disable", Init.LicencesEnable, HardcoreFlag)
		LicencesSnowberryOID = AddToggleOption("Snowberry Start", SnowberryEnable, LicFlag)
		LicenceStyleDB = AddMenuOption("Licence Style", LicenceStyleList[LicUtil.LicenceStyle], LicFlag)
		BikiniLicFirstOID = AddToggleOption("Bikini Licence First", LicUtil.AlwaysAwardBikiniLicFirst, LicFlag)
		FollowerLicStyleDB = AddMenuOption("Follower Licence Style", FollowerLicStyles[LicUtil.FollowerLicStyle], LicFlag)
		LicUnlockCostOID_S = AddSliderOption("Licence Unlock Cost", _SLS_LicUnlockCost.GetValueInt(), "{0} Gold", UnlockStyleFlag)
		LicBlockChanceOID_S = AddSliderOption("Purchase Block Chance", LicBlockChance, "{0}%", LicFlag)
		LicBuyBackOID = AddToggleOption("Confiscation Buy Back", LicUtil.BuyBack, LicFlag)
		LicBuyBackPriceDB = AddMenuOption("Buy Back Price", BuyBackPrices[BuyBackPrice], LicFlag)
		LicBountyMustBePaidOID = AddToggleOption("Bounty Must Be Clear", LicUtil.BountyMustBePaid, LicFlag)
		FolContraBlockOID = AddToggleOption("Followers Won't Carry Contraband", FolContraBlock, LicFlag)
		FolContraKeysOID = AddToggleOption("Followers Won't Carry Keys", LicUtil.FollowerWontCarryKeys, LicFlag)
		FolTakeClothesOID = AddToggleOption("Followers Take Clothes", LicUtil.FolTakeClothes, LicFlag)
		OrdinSupressOID = AddToggleOption("Supress Ordinator Perks", LicUtil.OrdinSupress, OrdinatorInstalledFlag)
		
		TollDodgeDetectDistTownMaxOID_S = AddSliderOption("Max Detection Distance Town", GuardSpotDistTown, "{1} Units", LicFlag)
		TollDodgeDisguiseBodyPenaltyOID_S = AddSliderOption("Body Cover Penalty", TollDodgeDisguiseBodyPenalty * 100.0, "{0}%", LicFlag)
		TollDodgeDisguiseHeadPenaltyOID_S = AddSliderOption("Hood Cover Penalty", TollDodgeDisguiseHeadPenalty * 100.0, "{0}%", LicFlag)
		TollDodgeCurrentSpotDistTown = AddTextOption("Current Detection Distance Town: " , (_SLS_TollDodgeHuntRadiusTown.GetValue() as String), HardMode)
		
		SearchEscortsOID_T = AddTextOption("Search Escorts", "Escort Count: " + _SLS_EscortsList.GetSize(), LicFlag)
		AddEscortToListOID_T = AddTextOption("Add Escort: " + CrosshairRefString, "", EscortAddFlag)
		RemoveEscortFromListOID_T = AddTextOption("Remove Escort: " + CrosshairRefString, "", EscortRemoveFlag)
		ClearAllEscortsOID_T = AddTextOption("Clear All Escorts", "", LicFlag)
		ImportEscortsFromJsonOID_T = AddTextOption("Import Escorts From Json", "", LicFlag)
		AddEmptyOption()
		LicGetEquipListOID_T = AddTextOption("Get Equipped Items", "")
		LicEquipListDB = AddMenuOption("Equipped Forms", EquipSlotStrings[SelectedEquip])
		AddLicExceptionOID_T = AddTextOption(S1 + " Exception: ", EquipSlotStrings[SelectedEquip], AddLicExceptionFlag)
		AddEmptyOption()
		
		AddHeaderOption("Faction Discounts")
		LicFactionDiscountOID_S = AddSliderOption("Licence Discount Max", LicUtil.LicFactionDiscount * 100.0, "{0}%", LicFlag)
		String DiscountString = (LicUtil.GetLicenceDiscountMagic() * 100.0)
		DiscountCollegeOID_T = AddTextOption("College Of Winterhold: " + GetMageRankString(), StringUtil.Substring(DiscountString, 0, StringUtil.Find(DiscountString, ".") + 2) + "%")
		
		DiscountString = (LicUtil.GetLicenceDiscountWeapons() * 100.0)
		DiscountCompanionsOID_T = AddTextOption("Companions: " + GetCompanionsRankString(), StringUtil.Substring(DiscountString, 0, StringUtil.Find(DiscountString, ".") + 2) + "%")
		
		DiscountString = (LicUtil.GetLicenceDiscountArmor() * 100.0)
		DiscountCwOID_T = AddTextOption(GetCwSide() + LicUtil.GetCwRankString(), StringUtil.Substring(DiscountString, 0, StringUtil.Find(DiscountString, ".") + 2) + "%")
		AddEmptyOption()
		
		AddHeaderOption("Licence Durations ")
		LicShortDurOID_S = AddSliderOption("Short Term Duration ", LicUtil.LicShortDur, "{0} Days", LicFlag)
		LicLongDurOID_S = AddSliderOption("Long Term Duration ", LicUtil.LicLongDur, "{0} Days", LicFlag)
		AddEmptyOption()
		
		AddHeaderOption("Magic Licence ")
		LicMagicEnableOID = AddToggleOption("Enable Magic Licence", LicUtil.LicMagicEnable, LicFlag)
		LicMagicCursedDevicesOID = AddToggleOption("Cursed Devices", LicUtil.LicMagicCursedDevices, MagicFlag)
		LicMagicShortCostOID_S = AddSliderOption("Short Term ", LicUtil.LicCostMagicShort, "{0} Gold", MagicFlag)
		LicMagicLongCostOID_S = AddSliderOption("Long Term ", LicUtil.LicCostMagicLong, "{0} Gold", MagicFlag)
		LicMagicPerCostOID_S = AddSliderOption("Perpetual ", LicUtil.LicCostMagicPer, "{0} Gold", MagicFlag)
		AddEmptyOption()
		
		SetCursorPosition(1)
		AddHeaderOption("Overlay Options")
		CurseTatsOID = AddToggleOption("Curses Come With Tats", LicUtil.CurseTats, LicFlag)
		BikiniCurseAreaDB = AddMenuOption("Bikini Curse Overlay:", OverlayAreas[BikiniCurseArea], OverlayFlag)
		MagicCurseAreaDB = AddMenuOption("Magic Curse Overlay:", OverlayAreas[MagicCurseArea], OverlayFlag)
		AddEmptyOption()
		
		AddHeaderOption("Merchant Trade ")
		RestrictTradeOID = AddToggleOption("Trade Restrictions", TradeRestrictions, LicFlag)
		TradeRestrictBribeOID_S = AddSliderOption("Bribe Cost ", TradeRestrictBribe, "{0} Gold", LicFlag)
		TradeRestrictAddMerchantOID_T = AddTextOption("Add Merchant: " + CrosshairRefString, "")
		TradeRestrictRemoveMerchantOID_T = AddTextOption("Remove Merchant: " + CrosshairRefString, "")
		TradeRestrictResetAllMerchantsOID_T = AddTextOption("Reset All Merchants", "")
		AddEmptyOption()
		
		AddHeaderOption("Enforcers ")
		EnforcersMinOID_S = AddSliderOption("Enforcers Minimum", EnforcersMin, "{0}", LicFlag)
		EnforcersMaxOID_S = AddSliderOption("Enforcers Maximum", EnforcersMax, "{0}", LicFlag)
		ResponsiveEnforcersOID = AddToggleOption("Responsive Enforcers", _SLS_ResponsiveEnforcers.GetValueInt(), LicFlag)
		PersistentEnforcersOID_S = AddSliderOption("Persistent Enforcers", _SLS_LicInspPersistence.GetValueInt(), "{0} seconds", LicFlag)
		EnforcerRespawnDurOID_S = AddSliderOption("Town Enforcer Respawn Time ", EnforcerRespawnDur, "{1} Days", LicFlag)
		AddEmptyOption()
		
		AddHeaderOption("Armor Licence ")
		LicArmorShortCostOID_S = AddSliderOption("Short Term ", LicUtil.LicCostArmorShort, "{0} Gold", LicFlag)
		LicArmorLongCostOID_S = AddSliderOption("Long Term ", LicUtil.LicCostArmorLong, "{0} Gold", LicFlag)
		LicArmorPerCostOID_S = AddSliderOption("Perpetual ", LicUtil.LicCostArmorPer, "{0} Gold", LicFlag)
		AddEmptyOption()

		AddHeaderOption("Bikini Licence ")
		LicBikiniEnableOID = AddToggleOption("Enable Bikini Licence", LicUtil.LicBikiniEnable, LicFlag)
		LicBikiniCurseEnableOID = AddToggleOption("Enable Bikini Curse", LicUtil.BikiniCurseEnable, BikiniFlag)
		StorageUtil.SetIntValue(Self, "LicBikiniBreathChanceOID_S", AddSliderOption("Out Of Breath Anim Chance", StorageUtil.GetFloatValue(None, "_SLS_LicBikOutOfBreathAnimChance", Missing = 60.0), "{0}%", BikiniFlag))
		LicBikiniTriggerOID_T = AddTextOption("Curse Triggered By:", BikCurseTrig + " - " + StringUtil.Substring(BikiniCurseTriggerArmor, StringUtil.Find(BikiniCurseTriggerArmor, "(", 0) + 1, len = 8), BikiniFlag)
		LicBikiniHeelsOID = AddToggleOption("Heels Are Required", BikiniCurse.HeelsRequired, BikiniFlag)
		LicBikiniHeelHeightOID_S = AddSliderOption("Heel Height Required", BikiniCurse.HeelHeightRequired, "{1}", BikiniFlag)
		StorageUtil.SetIntValue(Self, "LicBikiniArmorTestOID_T", AddTextOption("Test Bikini Armor", ""))
		LicBikiniShortCostOID_S = AddSliderOption("Short Term ", LicUtil.LicCostBikiniShort, "{0} Gold", BikiniFlag)
		LicBikiniLongCostOID_S = AddSliderOption("Long Term ", LicUtil.LicCostBikiniLong, "{0} Gold", BikiniFlag)
		LicBikiniPerCostOID_S = AddSliderOption("Perpetual ", LicUtil.LicCostBikiniPer, "{0} Gold", BikiniFlag)
		AddEmptyOption()

		AddHeaderOption("Clothes Licence ")
		LicClothesEnableDB = AddMenuOption("Licence Required", ClothesLicenceMethod[LicUtil.LicClothesEnable], LicFlag)
		LicClothesShortCostOID_S = AddSliderOption("Short Term ", LicUtil.LicCostClothesShort, "{0} Gold", ClothesFlag)
		LicClothesLongCostOID_S = AddSliderOption("Long Term ", LicUtil.LicCostClothesLong, "{0} Gold", ClothesFlag)
		LicClothesPerCostOID_S = AddSliderOption("Perpetual ", LicUtil.LicCostClothesPer, "{0} Gold", ClothesFlag)
		AddEmptyOption()
		
		AddHeaderOption("Weapon Licence ")
		LicWeapShortCostOID_S = AddSliderOption("Short Term ", LicUtil.LicCostWeaponShort, "{0} Gold", LicFlag)
		LicWeapLongCostOID_S = AddSliderOption("Long Term ", LicUtil.LicCostWeaponLong, "{0} Gold", LicFlag)
		LicWeapPerCostOID_S = AddSliderOption("Perpetual ", LicUtil.LicCostWeaponPer, "{0} Gold", LicFlag)
		AddEmptyOption()
		
	ElseIf(page == "Licences 2")
		Int LicFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && !IsHardcoreLocked
			LicFlag = OPTION_FLAG_NONE
		EndIf
		
		Int LicCurfewFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && LicUtil.LicCurfewEnable && !IsHardcoreLocked
			LicCurfewFlag = OPTION_FLAG_NONE
		EndIf
		
		Int LicWhoreFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && LicUtil.LicWhoreEnable && !IsHardcoreLocked
			LicWhoreFlag = OPTION_FLAG_NONE
		EndIf
		
		Int LicPropertyFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && LicUtil.LicPropertyEnable && !IsHardcoreLocked
			LicPropertyFlag = OPTION_FLAG_NONE
		EndIf
		
		Int LicFreedomFlag = OPTION_FLAG_DISABLED
		If Init.LicencesEnable && LicUtil.LicFreedomEnable && !IsHardcoreLocked
			LicFreedomFlag = OPTION_FLAG_NONE
		EndIf
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Curfew Licence ")
		StorageUtil.SetIntValue(Self, "CurfewLicenceEnableOID", AddToggleOption("Enable Curfew Licence", LicUtil.LicCurfewEnable, LicFlag))
		StorageUtil.SetIntValue(Self, "LicCurfewShortCostOID_S", AddSliderOption("Short Term ", LicUtil.LicCostCurfewShort, "{0} Gold", LicCurfewFlag))
		StorageUtil.SetIntValue(Self, "LicCurfewLongCostOID_S", AddSliderOption("Long Term ", LicUtil.LicCostCurfewLong, "{0} Gold", LicCurfewFlag))
		StorageUtil.SetIntValue(Self, "LicCurfewPerCostOID_S", AddSliderOption("Perpetual ", LicUtil.LicCostCurfewPer, "{0} Gold", LicCurfewFlag))
		AddEmptyOption()
		
		StorageUtil.SetIntValue(Self, "CurfewRestartDelayOID_S", AddSliderOption("Time To Clear Streets", (Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).TimeToClearStreets, "{0} Sec", LicCurfewFlag))
		StorageUtil.SetIntValue(Self, "CurfewBeginOID_S", AddSliderOption("Begin Time", (Game.GetFormFromFile(0x07B44C, "SL Survival.esp") as GlobalVariable).GetValue(), "{0}:00 Hours", LicCurfewFlag)) ; _SLS_CurfewBegin
		StorageUtil.SetIntValue(Self, "CurfewEndOID_S", AddSliderOption("End Time ", (Game.GetFormFromFile(0x07B44D, "SL Survival.esp") as GlobalVariable).GetValue(), "{0}:00 Hours", LicCurfewFlag)) ; _SLS_CurfewEnd
		StorageUtil.SetIntValue(Self, "CurfewSlavetownBeginOID_S", AddSliderOption("Slavetown Begin Time", (Game.GetFormFromFile(0x0ECBC0, "SL Survival.esp") as GlobalVariable).GetValue(), "{0}:00 Hours", LicCurfewFlag)) ; _SLS_CurfewSlavetownBegin
		StorageUtil.SetIntValue(Self, "CurfewSlavetownEndOID_S", AddSliderOption("Slavetown End Time ", (Game.GetFormFromFile(0x0ECBC1, "SL Survival.esp") as GlobalVariable).GetValue(), "{0}:00 Hours", LicCurfewFlag)) ; _SLS_CurfewSlavetownEnd
		AddEmptyOption()
		
		AddHeaderOption("Whore Licence ")
		StorageUtil.SetIntValue(Self, "WhoreLicenceEnableOID", AddToggleOption("Enable Whore Licence", LicUtil.LicWhoreEnable, LicFlag))
		StorageUtil.SetIntValue(Self, "LicWhoreShortCostOID_S", AddSliderOption("Short Term ", LicUtil.LicCostWhoreShort, "{0} Gold", LicWhoreFlag))
		StorageUtil.SetIntValue(Self, "LicWhoreLongCostOID_S", AddSliderOption("Long Term ", LicUtil.LicCostWhoreLong, "{0} Gold", LicWhoreFlag))
		StorageUtil.SetIntValue(Self, "LicWhorePerCostOID_S", AddSliderOption("Perpetual ", LicUtil.LicCostWhorePer, "{0} Gold", LicWhoreFlag))
		AddEmptyOption()
	
		SetCursorPosition(1)
		AddHeaderOption("Property Licence ")
		StorageUtil.SetIntValue(Self, "PropertyLicenceEnableOID", AddToggleOption("Enable Property Licence", LicUtil.LicPropertyEnable, LicFlag))
		StorageUtil.SetIntValue(Self, "LicPropertyShortCostOID_S", AddSliderOption("Short Term ", LicUtil.LicCostPropertyShort, "{0} Gold", LicPropertyFlag))
		StorageUtil.SetIntValue(Self, "LicPropertyLongCostOID_S", AddSliderOption("Long Term ", LicUtil.LicCostPropertyLong, "{0} Gold", LicPropertyFlag))
		StorageUtil.SetIntValue(Self, "LicPropertyPerCostOID_S", AddSliderOption("Perpetual ", LicUtil.LicCostPropertyPer, "{0} Gold", LicPropertyFlag))
		AddEmptyOption()
		
		AddHeaderOption("Freedom Licence ")
		;StorageUtil.SetIntValue(Self, "FreedomLicenceEnableOID", AddToggleOption("Enable Freedom Licence", LicUtil.LicFreedomEnable, LicFlag))

		StorageUtil.SetIntValue(Self, "FreedomLicenceEnableDB", AddMenuOption("Licence Required", ClothesLicenceMethod[LicUtil.LicFreedomEnable], LicFlag))
		
		StorageUtil.SetIntValue(Self, "LicFreedomShortCostOID_S", AddSliderOption("Short Term ", LicUtil.LicCostFreedomShort, "{0} Gold", LicFreedomFlag))
		StorageUtil.SetIntValue(Self, "LicFreedomLongCostOID_S", AddSliderOption("Long Term ", LicUtil.LicCostFreedomLong, "{0} Gold", LicFreedomFlag))
		StorageUtil.SetIntValue(Self, "LicFreedomPerCostOID_S", AddSliderOption("Perpetual ", LicUtil.LicCostFreedomPer, "{0} Gold", LicFreedomFlag))
		AddEmptyOption()
		
	
	ElseIf(page == "Stashes ")
		Int StashesEnabledFlag = OPTION_FLAG_DISABLED
		If StashTrackEn
			StashesEnabledFlag = OPTION_FLAG_NONE
		EndIf
	
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Options ")
		StashTrackEnOID = AddToggleOption("Enable Stash Tracking", StashTrackEn)
		ContTypeCountsOID = AddToggleOption("Container Type Counts ", ContTypeCountsT, StashesEnabledFlag)
		RoadDistOID_S = AddSliderOption("Max Road Distance ", RoadDist, "{0} Units", StashesEnabledFlag)
		StealXItemsOID_S = AddSliderOption("Npcs steal ", StealXItems, "{0} Items", StashesEnabledFlag)
		AddEmptyOption()
		
		AddHeaderOption("Exceptions ")
		StashAddRemoveExceptionOID_T = AddTextOption("Add/Remove Exception", "")
		StashAddRemoveJsonExceptionsOID_T = AddTextOption("Remove Json Exceptions", "")
		StashAddRemoveTempExceptionsOID_T = AddTextOption("Remove Temp Exceptions", "")
		StashAddRemoveAllExceptionsOID_T = AddTextOption("Remove All Exceptions", "")
		AddEmptyOption()
		
		SetCursorPosition(1)	
		AddHeaderOption("Exception List - Json")
		Int i = JsonUtil.FormListCount("SL Survival/StashExceptions.json", "StashExceptions")
		ObjectReference ObjRef
		While i > 0
			i -= 1
			ObjRef = JsonUtil.FormListGet("SL Survival/StashExceptions.json", "StashExceptions", i) as ObjectReference
			If ObjRef
				AddTextOption(i + ") " + StringUtil.Substring(ObjRef, StringUtil.Find(ObjRef, "(", 0) + 1, len = 8), "", OPTION_FLAG_DISABLED)
			EndIf
		EndWhile
		AddEmptyOption()
		
		AddHeaderOption("Exception List - Temporary Refs")
		i = StorageUtil.FormListCount(None, "_SLS_StashExceptionsTemp")
		While i > 0
			i -= 1
			ObjRef = StorageUtil.FormListGet(None, "_SLS_StashExceptionsTemp", i) as ObjectReference
			If ObjRef
				AddTextOption(i + ") " + StringUtil.Substring(ObjRef, StringUtil.Find(ObjRef, "(", 0) + 1, len = 8), "", OPTION_FLAG_DISABLED)
			EndIf
		EndWhile
		
	ElseIf(page == "Begging & Kennel")
		SetCursorFillMode(LEFT_TO_RIGHT)
		Int BeggingFlag = OPTION_FLAG_DISABLED
		If _SLS_BeggingDialogT.GetValueInt() == 1 && !IsHardcoreLocked
			BeggingFlag = OPTION_FLAG_NONE
		EndIf
		Int SlaveRapeFlag = OPTION_FLAG_DISABLED
		If KennelSlaveRapeTimeMin > -1
			SlaveRapeFlag = OPTION_FLAG_NONE
		EndIf
		Int MwaInstalled = OPTION_FLAG_DISABLED
		If Game.GetModByName("Mortal Weapons & Armor.esp") != 255
			MwaInstalled = OPTION_FLAG_NONE
		EndIf
		
		AddHeaderOption("Begging ")
		AddEmptyOption()
		BeggingTOID = AddToggleOption("Enable Begging Dialogue", _SLS_BeggingDialogT.GetValueInt())
		BegSelfDegEnableOID = AddToggleOption("Enable Self Degradation", _SLS_BegSelfDegradationEnable.GetValueInt())
		BegNumItemsOID_S = AddSliderOption("Beg Success Gives ", BegNumItems, "{0} Items", BeggingFlag)
		BegGoldOID_S = AddSliderOption("Beg Success Gives ", BegGold, "{1}x Gold", BeggingFlag)
		BegSexAggDB = AddMenuOption("Aggression ", SexAggressiveness[BegSexAgg], 0)
		BegSexVictimDB = AddMenuOption("Victim ", SexPlayerIsVictim[BegSexVictim], 0)
		BegMwaCurseChanceOID_S = AddSliderOption("MWA Curse Chance", BegMwaCurseChance, "{0}%", MwaInstalled)
		AddEmptyOption()
		
		AddEmptyOption()
		AddEmptyOption()
		
		AddHeaderOption("Kennel - Player Options")
		AddEmptyOption()
		KennelSafeCellCostOID_S = AddSliderOption("Cell Cost ", KennelSafeCellCost, "{0} Gold", HardMode)
		StorageUtil.SetIntValue(Self, "KennelSuitsOID", AddToggleOption("Suits ", StorageUtil.GetIntValue(Self, "KennelSuits", Missing = 0)))
		KennelRapeChancePerHourOID_S = AddSliderOption("Rape Chance Per Hour ", KennelRapeChancePerHour, "{0}%", HardMode)
		KennelCreatureChanceOID_S = AddSliderOption("Chance Of Creature Rape ", KennelCreatureChance, "{0}%", CreatureEventsFlag)
		KennelExtraDevicesOID = AddToggleOption("Extra Devious Devices", _SLS_KennelExtraDevices.GetValueInt())
		KennelFollowerToggleOID = AddToggleOption("Follower Won't Follow", KennelFollowerToggle)
		KennelSexAggDB = AddMenuOption("Aggression ", SexAggressiveness[KennelSexAgg], 0)
		KennelSexVictimDB = AddMenuOption("Victim ", SexPlayerIsVictim[KennelSexVictim], 0)
		AddEmptyOption()
		AddEmptyOption()
		
		AddHeaderOption("Kennel - Slave Options")
		AddEmptyOption()
		KennelSlaveRapeTimeMinOID_S = AddSliderOption("Slave Rape Interval Min", KennelSlaveRapeTimeMin, "{0} seconds")
		KennelSlaveRapeTimeMaxOID_S = AddSliderOption("Slave Rape Interval Max", KennelSlaveRapeTimeMax, "{0} seconds", SlaveRapeFlag)
		StorageUtil.SetIntValue(Self, "KennelSlaveDeviceCountMinOID_S", AddSliderOption("Slave Device Count Min", StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMin", Missing = 2), "{0} Devices"))
		StorageUtil.SetIntValue(Self, "KennelSlaveDeviceCountMaxOID_S", AddSliderOption("Slave Device Count Max", StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMax", Missing = 6), "{0} Devices"))

	ElseIf(page == "Pickpocket & Dismemberment")
		Int PpLootEnableFlag = OPTION_FLAG_DISABLED
		If PpLootEnable && !IsHardcoreLocked
			PpLootEnableFlag = OPTION_FLAG_NONE
		EndIf
		
		Int AmpInstalledFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName("Amputator.esm") != 255
			AmpInstalledFlag = OPTION_FLAG_NONE
		EndIf
		
		Int DismemberFlag = OPTION_FLAG_DISABLED
		If AmpType != 0
			DismemberFlag = OPTION_FLAG_NONE
		EndIf
		
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		AddHeaderOption("Pickpocket Settings")
		PpSleepNpcPerkOID = AddToggleOption("Sleeping Npcs Perk ", PpSleepNpcPerk)
		PpCrimeGoldOID_S = AddSliderOption("Pickpocket Fail Bounty", Game.GetGameSettingInt("iCrimeGoldPickpocket"), "{0} Gold")
		PpFailHandleOID = AddToggleOption("Pickpocket Fail Handling ", PpFailHandle)
		PpFailDevicesOID_S = AddSliderOption("Num Of Devices To Equip ", PpFailDevices, "{0}", PpLootEnableFlag)
		PpFailStealValueOID_S = AddSliderOption("Steal Items Worth", _SLS_PickPocketFailStealValue.GetValueInt(), "{0}", PpLootEnableFlag)
		PpFailDrugCountOID_S = AddSliderOption("Drugs To Equip ", PpFailDrugCount, "{0}", PpLootEnableFlag)
		PpLootEnableOID = AddToggleOption("Extra Pickpocket Loot Perk ", PpLootEnable)
		
		AddEmptyOption()
		
		AddHeaderOption("More Pickpocket Gold")
		PpGoldChanceOfNoneOID_T = AddTextOption("Chance For None: " , 100.0 - (PpGoldLowChance + PpGoldModerateChance + PpGoldHighChance) + "%", PpLootEnableFlag)
		PpGoldLowChanceOID_S = AddSliderOption("Chance Of Low Gold ", PpGoldLowChance, "{1}%", PpLootEnableFlag)
		PpGoldModerateChanceOID_S = AddSliderOption("Chance Of Moderate Gold ", PpGoldModerateChance, "{1}%", PpLootEnableFlag)
		PpGoldHighChanceOID_S = AddSliderOption("Chance Of High Gold ", PpGoldHighChance, "{1}%", PpLootEnableFlag)
		AddEmptyOption()
		
		AddHeaderOption("More Pickpocket Loot")
		PpLootMinOID_S = AddSliderOption("Min Extra Loot ", Util.PpLootLootMin, "{0}", PpLootEnableFlag)
		PpLootMaxOID_S = AddSliderOption("Max Extra Loot ", Util.PpLootLootMax, "{0}", PpLootEnableFlag)
		AddEmptyOption()
		PpLootChanceOfNoneOID_T = AddTextOption("Chance For None: " , 100.0 - (PpLootFoodChance + PpLootGemsChance + PpLootSoulgemsChance + PpLootJewelryChance + PpLootEnchJewelryChance + PpLootPotionsChance + PpLootKeysChance + PpLootTomesChance + PpLootCureChance) + "%", PpLootEnableFlag)
		PpLootFoodChanceOID_S = AddSliderOption("Chance For Food ", PpLootFoodChance, "{1}%", PpLootEnableFlag)
		PpLootGemsChanceOID_S = AddSliderOption("Chance For Gems ", PpLootGemsChance, "{1}%", PpLootEnableFlag)
		PpLootSoulgemsChanceOID_S = AddSliderOption("Chance For Soulgems ", PpLootSoulgemsChance, "{1}%", PpLootEnableFlag)
		PpLootJewelryChanceOID_S = AddSliderOption("Chance For Jewelry ", PpLootJewelryChance, "{1}%", PpLootEnableFlag)
		PpLootEnchJewelryChanceOID_S = AddSliderOption("Chance For Enchanted Jewelry ", PpLootEnchJewelryChance, "{1}%", PpLootEnableFlag)
		PpLootPotionsChanceOID_S = AddSliderOption("Chance For Potions ", PpLootPotionsChance, "{1}%", PpLootEnableFlag)
		PpLootKeysChanceOID_S = AddSliderOption("Chance For Devious Keys ", PpLootKeysChance, "{1}%", PpLootEnableFlag)
		PpLootTomesChanceOID_S = AddSliderOption("Chance For Spell Tomes ", PpLootTomesChance, "{1}%", PpLootEnableFlag)
		PpLootCureChanceOID_S = AddSliderOption("Chance For Cure Disease Potion ", PpLootCureChance, "{1}%", PpLootEnableFlag)
		AddEmptyOption()
		
		SetCursorPosition(1)
		Float DismemberActual
		Float PlayerArmor = PlayerRef.GetActorValue("DamageResist")
		If PlayerArmor > 0.0
			DismemberActual = DismemberChance - ((PlayerArmor / 10.0) * DismemberArmorBonus)
		Else
			DismemberActual = DismemberChance
		EndIf
		If DismemberActual < 0.0
			DismemberActual = 0.0
		EndIf
		AddHeaderOption("Player Dismemberment")
		SetCursorFillMode(TOP_TO_BOTTOM)
		DismembermentsDB = AddMenuOption("Style ", AmputationTypes[AmpType], 0)
		DismemberProgressionDB = AddMenuOption("Progression", AmputationDepth[AmpDepth], DismemberFlag)
		DismemberWeaponsDB = AddMenuOption("Weapons ", DismemberWeapons[DismemberWeapon], DismemberFlag)
		DismemberDepthMaxArmsDB = AddMenuOption("Arms Depth Max", MaxAmputationDepthArms[MaxAmpDepthArms], DismemberFlag)
		DismemberDepthMaxLegsDB = AddMenuOption("Legs Depth Max", MaxAmputationDepthLegs[MaxAmpDepthLegs], DismemberFlag)
		DismemberCooldownOID_S = AddSliderOption("Dismember Cooldown", DismemberCooldown, "{2} Hours", DismemberFlag)
		DismemberMaxAmpedLimbsOID_S = AddSliderOption("Dismember Limbs Max", MaxAmpedLimbs, "{0}", DismemberFlag)
		DismemberChanceOID_S = AddSliderOption("Base Dismember Chance ", DismemberChance, "{1}%", DismemberFlag)
		DismemberArmorBonusOID_S = AddSliderOption("Chance Reduction ", DismemberArmorBonus, "{2}% Per 10 Armor", DismemberFlag)
		DismemberChanceActualOID_T = AddTextOption("Chance Actual: " , DismemberActual + "%", DismemberFlag)
		DismemberDamageThresOID_S = AddSliderOption("Damage Threshold ", DismemberDamageThres, "{0}", DismemberFlag)
		DismemberHealthThresOID_S = AddSliderOption("Health Threshold ", DismemberHealthThres, "{0}", DismemberFlag)
		AmpPriestHealCostOID_S = AddSliderOption("Priest Heal Cost ", _SLS_AmpPriestHealCost.GetValueInt(), "{0} Gold", DismemberFlag)
		StorageUtil.SetIntValue(Self, "AmpBlockMagicOID", AddToggleOption("Block Magic", Amputation.BlockMagic))
		DismemberTrollCumOID = AddToggleOption("Troll Cum Heals", DismemberTrollCum)
		DismemberBathingOID = AddToggleOption("Disable Bathing ", DismemberBathing)
		DismemberPlayerSayOID = AddToggleOption("Use Say() ", DismemberPlayerSay)
		AddEmptyOption()
		
	ElseIf(page == "Bikini Armors & Exp")
		Int BikiniFlag = OPTION_FLAG_DISABLED
		If Game.GetModByName(JsonUtil.GetStringValue("SL Survival/BikiniArmors.json", "bikinimodname", missing = "TheAmazingWorldOfBikiniArmor.esp")) != 255
			BikiniFlag = OPTION_FLAG_NONE
		EndIf
		Int BikExpFlag = OPTION_FLAG_DISABLED
		If BikiniExpT && !IsHardcoreLocked
			BikExpFlag = OPTION_FLAG_NONE
		EndIf
		
		Float BikExp = 0.0
		Float BikExpNextLevel = 0.0
		Float ExpPerLevel = 0.0
		String BikRankString = "Untrained "
		If _SLS_BikiniExpTrainingQuest.IsRunning()
			ExpPerLevel = BikiniExp.ExpPerLevel
			BikExp = BikiniExp.BikExp
			BikExpNextLevel = BikiniExp.ExpPerLevel
			BikRankString = BikiniExp.GetBikRankString()
			
			Int i = 0
			While BikExpNextLevel < BikExp
				BikExpNextLevel += BikiniExp.ExpPerLevel
				If i == 1
					BikExpNextLevel += (BikiniExp.ExpPerLevel * 0.5)
				EndIf
				If i == 2
					BikExpNextLevel += (BikiniExp.ExpPerLevel)
				EndIf
				i += 1
				;Debug.Trace("_SLS_: Looping")
			EndWhile
		EndIf
		
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Bikini Experience")
		BikiniExpOID = AddToggleOption("Bikini Experience ", BikiniExpT)
		BikiniExpPerLevelOID_S = AddSliderOption("Base Exp Per Level ", ExpPerLevel, "{0} Hours", BikExpFlag)
		BikiniExpTrainOID_S = AddSliderOption("Training Speed ", BikTrainingSpeed, "{1}x", BikExpFlag)
		BikiniExpUntrainOID_S = AddSliderOption("Untraining Speed ", BikUntrainingSpeed, "{1}x", BikExpFlag)
		BikiniExpReflexesOID = AddToggleOption("Bikini Reflexes ", _SLS_BikiniExpReflexes.GetValueInt() as Bool, BikExpFlag)
		AddTextOption("Current Bikini Exp Rank", BikRankString, BikExpFlag)
		AddTextOption("Current Bikini Exp", BikExp, BikExpFlag)
		AddTextOption("Next Bikini Exp Level", BikExpNextLevel, BikExpFlag)
		AddEmptyOption()
		
		AddHeaderOption("Number Of Drops In: ")
		BikiniDropsVendorCityOID_S = AddSliderOption("City Vendors ", BikiniDropsVendorCity, "{0} drops", BikiniFlag)
		BikiniDropsVendorTownOID_S = AddSliderOption("Town Vendors ", BikiniDropsVendorTown, "{0} drops", BikiniFlag)
		BikiniDropsVendorKhajiitOID_S = AddSliderOption("Khajiit Vendors ", BikiniDropsVendorKhajiit, "{0} drops", BikiniFlag)
		AddEmptyOption()
		
		BikiniDropsChestOID_S = AddSliderOption("Chests ", BikiniDropsChest, "{0} drops", BikiniFlag)
		BikiniDropsChestOrnateOID_S = AddSliderOption("Ornate Chests ", BikiniDropsChestOrnate, "{0} drops", BikiniFlag)
		AddEmptyOption()
		
		SetCursorPosition(1)
		AddTextOption("Don't forget to build list!! ", "", BikiniFlag)
		AddEmptyOption()
		
		AddHeaderOption("Populate ")
		BikiniBuildListOID_T = AddTextOption("Build Bikini Lists ", "", BikiniFlag)
		BikiniClearListOID_T = AddTextOption("Clear Bikini Lists ", "", BikiniFlag)
		AddEmptyOption()
		
		;SetCursorPosition(7)
		AddHeaderOption("Chance Of: ")
		BikiniChanceNoneOID_S = AddTextOption("Chance For None: " , 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone) + "%", BikiniFlag)
		BikiniChanceHideOID_S = AddSliderOption("Hide Bikini ", BikiniChanceHide, "{1}%", BikiniFlag)
		BikiniChanceLeatherOID_S = AddSliderOption("Leather Bikini ", BikiniChanceLeather, "{1}%", BikiniFlag)
		BikiniChanceIronOID_S = AddSliderOption("Iron Bikini ", BikiniChanceIron, "{1}%", BikiniFlag)
		BikiniChanceSteelOID_S = AddSliderOption("Steel Bikini ", BikiniChanceSteel, "{1}%", BikiniFlag)
		BikiniChanceSteelPlateOID_S = AddSliderOption("Steel Plate Bikini ", BikiniChanceSteelPlate, "{1}%", BikiniFlag)
		BikiniChanceDwarvenOID_S = AddSliderOption("Dwarven Bikini ", BikiniChanceDwarven, "{1}%", BikiniFlag)
		BikiniChanceFalmerOID_S = AddSliderOption("Falmer Bikini ", BikiniChanceFalmer, "{1}%", BikiniFlag)
		BikiniChanceWolfOID_S = AddSliderOption("Wolf Bikini ", BikiniChanceWolf, "{1}%", BikiniFlag)
		BikiniChanceBladesOID_S = AddSliderOption("Blades Bikini ", BikiniChanceBlades, "{1}%", BikiniFlag)
		BikiniChanceEbonyOID_S = AddSliderOption("Ebony Bikini ", BikiniChanceEbony, "{1}%", BikiniFlag)
		BikiniChanceDragonboneOID_S = AddSliderOption("Dragonbone Bikini ", BikiniChanceDragonbone, "{1}%", BikiniFlag)
		
	ElseIf(page == "Inn Room Prices")	
		SetCursorFillMode(TOP_TO_BOTTOM)
		StorageUtil.SetIntValue(Self, "SetInnPricesOID", AddToggleOption("Set Inn Prices", LocTrack.SetInnPrices))
		AddEmptyOption()

		String InnLoc
		Int i = 0
		While i < LocTrack.InnCosts.Length
			InnLoc = StorageUtil.StringListGet(LocTrack, "_SLS_LocIndex", i)
			StorageUtil.SetIntValue(Self, "InnCost" + InnLoc + "OID_S", AddSliderOption(InnLoc, LocTrack.InnCosts[i], "{0} Gold"))
			i += 1
			If i == LocTrack.InnCosts.Length / 2
				SetCursorPosition(5)
			EndIf
		EndWhile
		
		
	ElseIf(page == "Interfaces ")
		AddHeaderOption("Interfaces ")
		AddEmptyOption()
		StorageUtil.SetIntValue(Self, "IntAproposTwoOID", AddToggleOption("Apropos Two ", AproposTwo.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntAmpOID", AddToggleOption("Amputator ", Amp.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntBisOID", AddToggleOption("Bathing In Skyrim", Bis.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntDdsOID", AddToggleOption("Devious Devices ", Devious.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntDfOID", AddToggleOption("Devious Followers ", Dflow.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntEsdOID", AddToggleOption("EatingSleepingDrinking ", EatSleepDrink.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntEffOID", AddToggleOption("EFF ", Eff.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntFhuOID", AddToggleOption("Fill Her Up 2.0 ", Fhu.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntFrostfallOID", AddToggleOption("Frostfall ", Frostfall.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntIneedOID", AddToggleOption("iNeed ", Ineed.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntMaOID", AddToggleOption("Milk Addict", MilkAddict.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntPscOID", AddToggleOption("PaySexCrime ", Psc.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntRndOID", AddToggleOption("Realistic Needs & Diseases", Rnd.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntSlaxOID", AddToggleOption("Sexlab Aroused", Sla.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntSlsoOID", AddToggleOption("Sexlab Separate Orgasms", Slso.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntSlsfOID", AddToggleOption("Sexlab Sexual Fame", Slsf.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntSexyMoveOID", AddToggleOption("Sexy Move", SexyMove.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntSlaverunOID", AddToggleOption("Slaverun 3.x", Slaverun.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntTatsOID", AddToggleOption("Slavetats ", Tats.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntSgoOID", AddToggleOption("Soulgem Oven 3.0 ", Sgo.GetIsInterfaceActive()))
		StorageUtil.SetIntValue(Self, "IntStaOID", AddToggleOption("Spank That Ass", Sta.GetIsInterfaceActive()))
		AddEmptyOption()
		
	ElseIf(page == "Stats & Info")
		SetCursorFillMode(TOP_TO_BOTTOM)
		Float CurrentTime = Utility.GetCurrentGameTime()
		
		AddHeaderOption("Cum ")
		AddTextOption("Loads Swallowed: ", Util.LoadsSwallowed)
		AddTextOption("Cum Units Swallowed: ", Util.CumUnitsSwallowed)
		AddTextOption("Loads Spat: ", Util.LoadsSpat)
		AddTextOption("Cum Units Spat: ", Util.CumUnitsSpat)
		AddTextOption("Last Load Unit Size: ", Util.LastLoadSize)
		AddEmptyOption()
		AddTextOption("Humanoid Loads (Units): ", Util.LoadsSwallowedHumanoid + " - (" + Util.CumUnitsSwallowedHumanoid + ")")
		AddTextOption("Dog Loads (Units): ", StorageUtil.GetIntValue(_SLS_CumLactacidVoicesList.GetAt(3), "_SLS_LoadsSwallowed", Missing = 0) + " - (" + StorageUtil.GetFloatValue(_SLS_CumLactacidVoicesList.GetAt(3), "_SLS_CumUnitsSwallowed", Missing = 0.0) + ")")
		AddTextOption("Wolf Loads (Units): ", StorageUtil.GetIntValue(_SLS_CumLactacidVoicesList.GetAt(25), "_SLS_LoadsSwallowed", Missing = 0) + " - (" + StorageUtil.GetFloatValue(_SLS_CumLactacidVoicesList.GetAt(25), "_SLS_CumUnitsSwallowed", Missing = 0.0) + ")")
		AddTextOption("Horse Loads (Units): ", StorageUtil.GetIntValue(_SLS_CumLactacidVoicesList.GetAt(18), "_SLS_LoadsSwallowed", Missing = 0) + " - (" + StorageUtil.GetFloatValue(_SLS_CumLactacidVoicesList.GetAt(18), "_SLS_CumUnitsSwallowed", Missing = 0.0) + ")")
		AddTextOption("Troll Loads (Units): ", StorageUtil.GetIntValue(_SLS_CumLactacidVoicesList.GetAt(23), "_SLS_LoadsSwallowed", Missing = 0) + " - (" + StorageUtil.GetFloatValue(_SLS_CumLactacidVoicesList.GetAt(23), "_SLS_CumUnitsSwallowed", Missing = 0.0) + ")")
		AddEmptyOption()
		
		AddHeaderOption("Fondling ")
		AddTextOption("Creatures Fondled: ", Util.CreatureFondleCount as Int)
		AddEmptyOption()
		
		AddHeaderOption("Animal Friends - Loyalty")
		Int i = 0
		ReferenceAlias AliasSelect
		While i < _SLS_AnimalFriendAliases.GetNumAliases()
			AliasSelect = _SLS_AnimalFriendAliases.GetNthAlias(i) as ReferenceAlias
			If AliasSelect.GetReference() != None
				;Debug.Messagebox("UpdateTime: " + (AliasSelect as _SLS_AnimalFriendAlias).UpdateTime)
				AddTextOption(i + ") " + AliasSelect.GetReference().GetBaseObject().GetName(),  (((AliasSelect as _SLS_AnimalFriendAlias).UpdateTime - CurrentTime) * 24.0) + " Hours")
			Else
				AddTextOption(i + ") None",  "0 Hours")
			EndIf
			i += 1
		EndWhile
		AddEmptyOption()
		
		AddHeaderOption("Whoring ")
		AddTextOption("Beg Sex Count: ", Util.BegSexCount)
		AddTextOption("Beg Blowjob Count: ", Util.BegBlowjobs)
		AddTextOption("Beg Lickings Count: ", Util.BegLickings)
		AddTextOption("Beg Vaginal Sex Count: ", Util.BegVagSex)
		AddTextOption("Beg Anal Sex Count: ", Util.BegAnalSex)
		AddTextOption("Beg Gangbang Count: ", Util.BegGangbangs)
		AddEmptyOption()
		AddTextOption("Beg Creature Sex Count: ", Util.BegCreatureSexCount)
		AddTextOption("Beg Dog Sex Count: ", Util.BegDogSex)
		AddTextOption("Beg Wolf Sex Count: ", Util.BegWolfSex)
		AddTextOption("Beg Horse Sex Count: ", Util.BegHorseSex)
		AddEmptyOption()
		
		AddHeaderOption("Thane Status")
		AddTextOption("You Are Thane Of Whiterun:", LicUtil.IsThaneWhiterun)
		AddTextOption("You Are Thane Of Solitude:", LicUtil.IsThaneSolitude)
		AddTextOption("You Are Thane Of Markarth:", LicUtil.IsThaneMarkarth)
		AddTextOption("You Are Thane Of Windhelm:", LicUtil.IsThaneWindhelm)
		AddTextOption("You Are Thane Of Riften:", LicUtil.IsThaneRiften)
		AddEmptyOption()
		
		AddHeaderOption("Bounties: Loc - Bounty (PSC Bounty)")
		AddTextOption("Whiterun", Eviction.CrimeFactionWhiterun.GetCrimeGold() + " - (" + Psc.GetPscBountyWhiterun() + ")")
		AddTextOption("Solitude", Eviction.CrimeFactionHaafingar.GetCrimeGold() + " - (" + Psc.GetPscBountySolitude() + ")")
		AddTextOption("Markarth", Eviction.CrimeFactionReach.GetCrimeGold() + " - (" + Psc.GetPscBountyMarkarth() + ")")
		AddTextOption("Windhelm", Eviction.CrimeFactionEastmarch.GetCrimeGold() + " - (" + Psc.GetPscBountyWindhelm() + ")")
		AddTextOption("Riften", Eviction.CrimeFactionRift.GetCrimeGold() + " - (" + Psc.GetPscBountyRiften() + ")")
		AddEmptyOption()
		
		AddHeaderOption("You Are Evicted In:")
		AddTextOption("Whiterun", (Eviction.OwnsWhiterun && Eviction.IsBarredWhiterun))
		AddTextOption("Solitude", (Eviction.OwnsSolitude && Eviction.IsBarredSolitude))
		AddTextOption("Markarth", (Eviction.OwnsMarkarth && Eviction.IsBarredMarkarth))
		AddTextOption("Windhelm", (Eviction.OwnsWindhelm && Eviction.IsBarredWindhelm))
		AddTextOption("Riften", (Eviction.OwnsRiften && Eviction.IsBarredRiften))
		AddEmptyOption()

		SetCursorPosition(1)
		AddHeaderOption("Valid Licences: ")
		AddTextOption("Armor Licence: ", LicUtil.HasValidArmorLicence)
		AddTextOption("Bikini Licence: ", LicUtil.HasValidBikiniLicence)
		AddTextOption("Weapon Licence: ", LicUtil.HasValidWeaponLicence)
		AddTextOption("Magic Licence: ", LicUtil.HasValidMagicLicence)
		AddTextOption("Clothes Licence: ", LicUtil.HasValidClothesLicence)
		AddTextOption("Curfew Licence: ", LicUtil.HasValidCurfewLicence)
		AddTextOption("Whore Licence: ", LicUtil.HasValidWhoreLicence)
		AddTextOption("Freedom Licence: ", LicUtil.HasValidFreedomLicence)
		AddTextOption("Property Licence: ", LicUtil.HasValidPropertyLicence)
		AddEmptyOption()
		
		AddHeaderOption("Valid Until: ")
		AddTextOption("Current Time", CurrentTime)
		AddTextOption("Armor Licence: ", LicUtil.NextArmorExpiry)
		AddTextOption("Bikini Licence: ", LicUtil.NextBikiniExpiry)
		AddTextOption("Weapon Licence: ", LicUtil.NextWeaponExpiry)
		AddTextOption("Magic Licence: ", LicUtil.NextMagicExpiry)
		AddTextOption("Clothes Licence: ", LicUtil.NextClothesExpiry)
		AddTextOption("Curfew Licence: ", LicUtil.NextCurfewExpiry)
		AddTextOption("Whore Licence: ", LicUtil.NextWhoreExpiry)
		AddTextOption("Freedom Licence: ", LicUtil.NextFreedomExpiry)
		AddTextOption("Property Licence: ", LicUtil.NextPropertyExpiry)
		AddEmptyOption()
		
		If TollDodging
			AddHeaderOption("Mandatory Restraints")
			AddTextOption("Current Time", CurrentTime)
			AddTextOption("Whiterun", "Level: " + TollDodge.RestraintLevelWhiterun + " Until: " + TollDodge.RestraintReqWhiterun)
			AddTextOption("Solitude", "Level: " + TollDodge.RestraintLevelSolitude + " Until: " + TollDodge.RestraintReqSolitude)
			AddTextOption("Markarth", "Level: " + TollDodge.RestraintLevelMarkarth + " Until: " + TollDodge.RestraintReqMarkarth)
			AddTextOption("Windhelm", "Level: " + TollDodge.RestraintLevelWindhelm + " Until: " + TollDodge.RestraintReqWindhelm)
			AddTextOption("Riften", "Level: " + TollDodge.RestraintLevelRiften + " Until: " + TollDodge.RestraintReqRiften)
			AddEmptyOption()
			
			AddHeaderOption("Dodged Toll In: ")
			TollDodgedWhiterunOID_T = AddTextOption("Whiterun", TollDodge.DodgedTollWhiterun)
			TollDodgedSolitudeOID_T = AddTextOption("Solitude", TollDodge.DodgedTollSolitude)
			TollDodgedMarkarthOID_T = AddTextOption("Markarth", TollDodge.DodgedTollMarkarth)
			TollDodgedWindhelmOID_T = AddTextOption("Windhelm", TollDodge.DodgedTollWindhelm)
			TollDodgedRiftenOID_T = AddTextOption("Riften", TollDodge.DodgedTollRiften)
			AddEmptyOption()
		EndIf
		
		AddHeaderOption("Grounded Until")
		AddTextOption("Current Time", CurrentTime)
		AddTextOption("Whiterun", TollUtil.GroundedUntilWhiterun)
		AddTextOption("Solitude", TollUtil.GroundedUntilSolitude)
		AddTextOption("Markarth", TollUtil.GroundedUntilMarkarth)
		AddTextOption("Windhelm", TollUtil.GroundedUntilWindhelm)
		AddTextOption("Riften", TollUtil.GroundedUntilRiften)
		AddEmptyOption()
		
		AddHeaderOption("Mandatory Gag Until")
		AddTextOption("Current Time", CurrentTime)
		AddTextOption("Whiterun", LicUtil.MandGagWhiterun)
		AddTextOption("Solitude", LicUtil.MandGagSolitude)
		AddTextOption("Markarth", LicUtil.MandGagMarkarth)
		AddTextOption("Windhelm", LicUtil.MandGagWindhelm)
		AddTextOption("Riften", LicUtil.MandGagRiften)
		AddEmptyOption()
		
	ElseIf(page == "Stats & Info 2")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddHeaderOption("Masturbation Stats")
		AddTextOption("Masturbation Count: ", StorageUtil.GetIntValue(PlayerRef, "_SLS_SexExperience", Missing = 0))
		AddTextOption("Masturbation Orgasms: ", StorageUtil.GetIntValue(PlayerRef, "_SLS_MasturbationOrgasmCount", Missing = 0))
		AddEmptyOption()
		
		AddHeaderOption("Sex Stats Humans")
		AddTextOption("Humanoid Sex Count Total: ", StorageUtil.GetIntValue(None, "_SLS_HumanSexCount", Missing = 0))
		AddTextOption("Player Orgasms With Humans: ", StorageUtil.GetIntValue(None, "_SLS_HumanSexOrgasmCount", Missing = 0))
		AddEmptyOption()
		
		AddHeaderOption("Human Race Sex Stats")
		AddTextOption("Generic Custom Female", StorageUtil.GetIntValue(None, "_SLS_SexExperienceGenericFemale", Missing = 0))
		AddTextOption("Generic Custom Male", StorageUtil.GetIntValue(None, "_SLS_SexExperienceGenericMale", Missing = 0))
		
		Int i = 0
		Form akForm
		String RaceString
		While i < StorageUtil.FormListCount(None, "_SLS_HumanSexForms")
			akForm = StorageUtil.FormListGet(None, "_SLS_HumanSexForms", i)
			RaceString = TidyFormString(akForm)
			AddTextOption(RaceString + " Female", StorageUtil.GetIntValue(akForm, "_SLS_SexExperienceFemale", Missing = 0))
			AddTextOption(RaceString + " Male", StorageUtil.GetIntValue(akForm, "_SLS_SexExperienceMale", Missing = 0))
			i += 1
		EndWhile
		
		SetCursorPosition(1)
		AddHeaderOption("Sex Stats Creatures")
		AddTextOption("Creature Sex Count Total: ", StorageUtil.GetIntValue(None, "_SLS_CreatureSexCount", Missing = 0))
		AddTextOption("Player Orgasms With Creatures: ", StorageUtil.GetIntValue(None, "_SLS_CreatureSexOrgasmCount", Missing = 0))
		AddTextOption("Effective Corruption Points: ", PapyrusUtil.ClampInt(StorageUtil.GetIntValue(None, "_SLS_CreatureCorruption", Missing = 0), 0, 100))
		AddEmptyOption()
		
		Race DremoraRace = Game.GetFormFromFile(0x131F0, "Skyrim.esm") as Race
		Int DremoraFemaleSexCount = StorageUtil.GetIntValue(DremoraRace, "_SLS_SexExperienceFemale", Missing = 0)
		Int DremoraMaleSexCount = StorageUtil.GetIntValue(DremoraRace, "_SLS_SexExperienceMale", Missing = 0)
		
		AddHeaderOption("Sex Stats Dremora")
		AddTextOption("Dremora Sex Count Female: ", DremoraFemaleSexCount)
		AddTextOption("Dremora Sex Count Male: ", DremoraMaleSexCount)
		AddTextOption("Dremora Sex Count Total: ", (DremoraMaleSexCount + DremoraFemaleSexCount))
		AddTextOption("Player Orgasms From Dremora: ", StorageUtil.GetIntValue(None, "_SLS_DremoraSexOrgasmCount", Missing = 0))
		AddEmptyOption()
		
		AddHeaderOption("Creature Race Sex Stats")
		i = 0
		While i < StorageUtil.FormListCount(None, "_SLS_CreatureSexForms")
			akForm = StorageUtil.FormListGet(None, "_SLS_CreatureSexForms", i)
			AddTextOption(TidyFormString(akForm), StorageUtil.GetIntValue(akForm, "_SLS_SexExperience", Missing = 0))
			i += 1
		EndWhile
	EndIf
EndEvent

event OnOptionHighlight(int option)
	; Settings
	If(option == ImportSettingsOID_T)
		SetInfoText("Import your saved settings from json file /SKSE/Plugins/StorageUtilData/SL Survival/Settings.json")
	ElseIf(option == ExportSettingsOID_T)
		SetInfoText("Export your settings to json file /SKSE/Plugins/StorageUtilData/SL Survival/Settings.json")
	ElseIf Option == AllInOneKeyOID
		SetInfoText("All In One Key. Access all of the mod actions, interactions and statuses through this one menu\nNote this has replaced the Cum notification, open mouth and cover myself keys")
	ElseIf Option == StorageUtil.GetIntValue(Self, "OpenMouthKey")
		SetInfoText("A shortcut to open your character's mouth. There's also a button to open your mouth in the 'All in one' menu so this is optional")
	ElseIf(option == DropItemsOID)
		SetInfoText("Enable/Disable dropping of armors/clothes/weapons during aggressive scenes or events\nIncludes amputation/dismemberment")
	ElseIf(option == SlsCreatureEventOID)
		SetInfoText("Enable/Disable the creature aspects of the mod - Disabled by default\nDisable this if you don't 'do' creatures\nDisabling this will also disable the 'Fondle' Creature popup should it be conflicting somehow\nThere will still be some dialog though during certain events")
	ElseIf(option == OrgasmRequiredOID)
		SetInfoText("For SLSO users. If checked you must make your 'client' orgasm to successfully beg\nSo you'll have to work for it ;)\nThis also includes tolls!")
	ElseIf Option == StorageUtil.GetIntValue(Self, "JigglesOID")
		SetInfoText("As your character's breasts, belly & ass grow towards your SLIF max scaling settings you gain 3/6/10% better buy & sell prices but you are 3/6/10% slower. Your sex partners get increasing bonus enjoyment on animation stage change as your body fills out because of all your jiggling")
	ElseIf Option == StorageUtil.GetIntValue(Self, "JigglesVisualsOID")
		SetInfoText("Apply a pink visual effect and a little camera shake whenever jiggles is applied during sex\nMight be annoying.")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CompulsiveSexOID")
		SetInfoText("For SLSO only. When your character loses control she will begin fucking herself without your input during sex\nYou'll lose control at 100 arousal or when high on skooma, skooma whore drugs or lactacid (Milk addict)\nDoesn't matter if the scene is consensual or not...\nThis really needs STA to make it more obvious with it's 'ass clapping' & sucking sounds\nNeed to add drunk to conditions")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CompulsiveSexFuckTimeOID_S")
		SetInfoText("How long between compulsive (automatic) fucks.")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "OrgasmFatigueOID")
		SetInfoText("The more your character orgasms the more fatigued she'll become once she passes the orgasm threshold\nHigher orgasm fatigue will reduce stamina & magicka pools, decrease speed and weapon & spell damage\nRecover by sleeping")
	ElseIf Option == StorageUtil.GetIntValue(Self, "OrgasmFatigueThresholdOID_S")
		SetInfoText("The number of orgasms your character must be at or above before fatigue starts setting in\nThis number drops when you sleep")
	ElseIf Option == StorageUtil.GetIntValue(Self, "OrgasmFatigueRecoveryOID_S")
		SetInfoText("How many orgasm points are recovered for each hour you sleep\nIf sleep deprivation is enabled then your recovery is affected by your sleeping conditions as:\nHours slept * Recovery points per hour * ((100 - Sleep penalty) / 100)")
	
	ElseIf Option == PushEventsDB
		SetInfoText("Enable/Disable push events - Male Npcs have a chance to push your character out of their way when you get too close. Paralysis can react badly when another animation is played during the get up sequence - Most notably automatic 'cover up' animations\nDefault is disabled because of this. Stagger should be safer\nIf both stagger and paralysis are enabled there's a 50% chance of either")
	ElseIf Option == StorageUtil.GetIntValue(Self, "PushCooldownOID_S")
		SetInfoText("Minimum time between possible push events in game hours")
	ElseIf(option == BarefootMagOIS_S)
		SetInfoText("The magnitude of the barefoot speed debuff. Set to zero to disable. Default 50\n50 might seem high but it's intended for use with Immersive Fashion's heel training with it's 'Speed Debuff Percentage' set to 75. This way speeds are: Barefoot - 50, Untrained heels - 55, High heel novice - 62 etc.\nThis way you might be tempted to equip Devious boots yourself instead of being barefoot\nRecommend turning off 'Boots slowdown effect' in Devious Devices if using IF.\nDon't forget that MinAv may override actual speed")
	ElseIf(option == HorseCostOIS_S)
		SetInfoText("How much it should cost to buy a horse\nVanilla default: 1000, Survival default: 6000")
	ElseIf Option == StorageUtil.GetIntValue(Self, "GrowthWeightGainOID_S")
		SetInfoText("Continue blossoming. Gain this much weight every day\nSet to zero to disable")
	ElseIf(option == CatCallVolOIS_S)
		SetInfoText("Volume of Npcs 'cat calling' the PC (Whistling at her under certain conditions). Set to zero to disable cat calling\nActive conditions: Naked or the body slot armor is: bikini armor, half-naked cover, is set as slooty in SLAX, is whoreish or slutty in milk addict")
	ElseIf(option == CatCallWillLossOIS_S)
		SetInfoText("You'll lose this much resistance in Devious Followers Continued when your character is whistled at")
	ElseIf(option == GreetDistOIS_S)
		SetInfoText("How close you'll have to get to an Npc before they'll play a 'hello' greeting\nFor Survival this affects things like cat calling, proximity spanks and general comments\nToo low and they'll never trigger unless you get all up in an Npcs face. Too high and everyone in town will pester you incessantly. So I leave it up to you\nNote that this is essentially the mod 'No/Reduced Npc Greetings' in slider form")
	ElseIf(option == EasyBedTrapsOID)
		SetInfoText("If enabled there's a chance you'll be sent on a bondage adventure or the DCL hogtie game when sleeping in 'easy' beds as guild members 'haze the new girl'\nBoth require Cursed loot. Easy beds only include the companions beds and your student bed at the college of Winterhold at the moment\nThis does not trigger rape while sleeping")
	ElseIf(option == HardcoreModeOID)
		SetInfoText("Disable access to certain MCM elements while your character doesn't have enough gold to afford a Slaverun toll or a short term licence - whichever is highest")
	ElseIf(option == DebugModeOID)
		SetInfoText("Enable/Disable debug mode\nAdds some spells for general debugging and displays extra information - Disables magicka curse while active to allow you to cast spells\nDoesn't do much right now - to be expanded")
	ElseIf(option == AssSlappingOID)
		SetInfoText("Enable/Disable ass slapping collision events - Npcs have a chance to slap your ass when you bump into them\nDisable this if you're using 'Spank That Ass'\nYou may need to exit the menu for changes to apply")
	ElseIf(option == CoverMyselfMechanicsOID)
		SetInfoText("Enable/Disable cover game mechanics\nNot covering yourself while naked has increased effect on Devious Followers resistance loss when the player is Cat Called or Spanked\nLosing DF resistance will lower your DF willpower which can lead to events in DF")
	ElseIf Option == StorageUtil.GetIntValue(Self, "NpcCommentsOID")
		SetInfoText("Enable/Disable SLS npc comments\nCurrently only has comments from MaleNord, FemaleNord, MaleNordCommander & MaleBrute")
	ElseIf(option == AssSlapResistLossOID_S)
		SetInfoText("How much DFC resistance is lost when spanked. This is mutliplied by your naked/covering yourself status. See the Cover Myself Key tooltip")
	ElseIf(option == GoldWeightOID_S)
		SetInfoText("Adds weight to gold. Set to 0 to disable")
	ElseIf(option == FollowersStealGoldOID)
		SetInfoText("Enable/Disable followers stealing a percentage of the gold you give to them to carry ")
	ElseIf(option == FolGoldStealChanceOID_S)
		SetInfoText("The chance a follower has of stealing from you when you give them gold to carry ")
	ElseIf(option == FolGoldSteamAmountOID_S)
		SetInfoText("How much gold a follower will steal when you give them gold to carry ")
	ElseIf(option == FastTravelDisableOID)
		SetInfoText("Enable/Disable fast travel being disabled when you enter a tolled city\nDisabling this will immediately enable fast travel\nEnabling again will not disable fast travel immediately - You'll need to reenter the city for that")
	ElseIf(option == FtDisableIsNormalOID)
		SetInfoText("Enable if fast travel is normally disabled in your game by other mods\nThis will prevent Survival turning fast travel back on when you leave a tolled city")
	ElseIf(option == CompassHideMethodDB)
		SetInfoText("The method the mod employs to hide your compass when you don't have one in your inventory\nTransparency: Makes the compass invisible. This is the old way the mod worked but the compass will be briefly visible on game load\nIni: Disable the compass in the Ini which stops it showing breifly on game load but some mods don't like this method")
	ElseIf(option == CompassMechanicsOID)
		SetInfoText("Enable/Disable map & compass mechanics - For people that aren't big on getting lost\nYou may need to exit the menu to apply changes")
	ElseIf(option == ReplaceMapsOID)
		SetInfoText("Replaces the civil war maps and some static maps you find around Skyrim with an interactive map you can use to temporarily get your bearings and find quest objects etc\nYou'll 'lose your bearings' again after the amount of time below")
	ElseIf(option == ReplaceMapsTimerOID_S)
		SetInfoText("How long before you lose access to map/compass after using a static map")
	ElseIf(option == ConstructableMapAndCompassOID)
		SetInfoText("Construct the 'Map & Compass' item at a forge\nRequires steel smithing, an inkwell, a paper roll, a Dwarven ingot and a Centurion Dynamo Core")
	ElseIf(option == MinAvToggleOID)
		SetInfoText("Enable/Disable minimum actor values tracking\nDisable if something goes horribly wrong\nCompensation effects are spells (and not direct AV manipulation) so disabling should remove all effects added by SLS")
	ElseIf(option == MinSpeedOID_S)
		SetInfoText("Minimum speed mult the mod will try to maintain\nBecause negative values aren't fun")
	ElseIf(option == MinCarryWeightOID_S)
		SetInfoText("Minimum carry weight the mod will try to maintain\nBecause negative values aren't fun")
	ElseIf(option == SlaverunAutoStartOID)
		SetInfoText("Sick of doing the Slaverun introduction quest? Me too!\nUse this to automatically start Slaverun with the enslavement of Whiterun\nThese options will be unavailable if Whiterun is enslaved.\nChanging the sliders will reset the count from the current day!")
	ElseIf(option == SlaverunAutoMinOID_S)
		SetInfoText("The Minimum number of days in which Slaverun can start. Starting will be random between Min and Max. If you want it to start on a particular day just set both sliders to the same\nSet the Min slider to zero to start Slaverun now.")
	ElseIf(option == SlaverunAutoMaxOID_S)
		SetInfoText("The Maximum number of days in which Slaverun can start. Starting will be random between Min and Max. If you want it to start on a particular day just set both sliders to the same\nSet the Min slider to zero to start Slaverun now.")
	ElseIf(option == HalfNakedEnableOID)
		SetInfoText("Enable half naked cover. Requires DDs Device Hider to be disabled to work. You may need to leave the menu to toggle.\nEquips an invisible armor when your bra and panty slots are equipped with an item that doesn't have the SexlabNoStrip keyword\nWhen wearing a bra and panty it will: stop you being considered as naked, stop cover up animations, make you less vulnerable in DEC, add frostfall warmth and coverage etc.")
	ElseIf(option == HalfNakedStripsOID)
		SetInfoText("If enabled having both a panty and bra slot item equipped will strip your cuirass. If disabled it won't strip your cuirass\nUseful if you have armors that have 'top' and 'bottom' pieces that when both equipped should act like a cuirass")
	ElseIf(option == HalfNakedBraOID_S)
		SetInfoText("The slotmask you use for bras\nDevious Devices chastity bra is slot 56")
	ElseIf(option == HalfNakedPantyOID_S)
		SetInfoText("The slotmask you use for pantys\nDevious Devices chastity belt is slot 49")
	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifBreastScaleMaxOID_S")
		SetInfoText("Your max SLIF breast scaling in SLS\nAffects things like the inflation potion & jiggles")
	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifBellyScaleMaxOID_S")
		SetInfoText("Your max SLIF belly scaling in SLS\nAffects things like the inflation potion & jiggles")
	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifAssScaleMaxOID_S")
		SetInfoText("Your max SLIF ass scaling in SLS\nAffects things like the inflation potion & jiggles")

	ElseIf(option == SexExpEnableOID)
		SetInfoText("Gain sex experience with a race every time you fuck which will make you more effective at making that race cum\nSex Exp grants increasingly large bonuses to stamina and stamina rate as you gain experience. Bonus stamina is only given during sex\nRequires SLSO. See the Info/Stats 2 page to view your sex stats")
	ElseIf(option == DremoraCorruptionOID)
		SetInfoText("When the player has a orgasm while fucking a Dremora (Sanguine) count it towards creature corruption")
	ElseIf(option == SexExpCorruptionDB)
		SetInfoText("Become more corrupted the more you orgasm while being fucked by creatures. As your corruption increases you'll find it harder to orgasm while being fucked by a humanoid (playable) race until eventually you can only cum while being fucked by creatures. Does not affect your ability to make your human partner cum - You can still service normal cocks and gain experience. But normal cocks just won't 'do it' for YOU anymore\nGradual One-Way - Slowly gain corruption with each creature sex orgasm. Priests can remove your corruption.")
	ElseIf(option == SexExpResetStatsOID_T)
		SetInfoText("Resets all your SLS sex experience stats back to zero")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugLactacidOID")
		SetInfoText("Enable/Disable the equipping of this drug type before rape begins. Certain drugs are auto disabled when already active or at maximum\nMME Lactacid. Makes you a milk maid. Increases milk generation. Increases addiction in Milk Addict")
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugSkoomaOID")
		SetInfoText("Enable/Disable the equipping of this drug type before rape begins. Certain drugs are auto disabled when already active or at maximum\nSkooma Whore drugs. Increases addiction")
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugCumHumanOID")
		SetInfoText("Enable/Disable the equipping of this drug type before rape begins. Certain drugs are auto disabled when already active or at maximum\nHuman cum. Increases cum addiction")
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugCumCreatureOID")
		SetInfoText("Enable/Disable the equipping of this drug type before rape begins. Certain drugs are auto disabled when already active or at maximum\nCreature cum. Increases cum addiction & creature corruption")
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugInflateOID")
		SetInfoText("Enable/Disable the equipping of this drug type before rape begins. Certain drugs are auto disabled when already active or at maximum\nA delayed action potion that provides explosive growth to your character's curves for a day or two. Fades in time")
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugFmFertilityOID")
		SetInfoText("Enable/Disable the equipping of this drug type before rape begins. Certain drugs are auto disabled when already active or at maximum\nFertility Mode fertility potion. Increases your fertility which increases the risk of getting pregnant")
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugSlenAphrodisiacOID")
		SetInfoText("Enable/Disable the equipping of this drug type before rape begins. Certain drugs are auto disabled when already active or at maximum\nSL Eager Npcs aphrodisiacs. Increases the arousal of Npcs around you which can have consequences for arousal based mods like DEC/Aroused Creatures")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHaircutChanceOID_S")
		SetInfoText("Immersive Fashion. The chance to have your hair cut on rape\nThe resulting haircut will be your default haircut for the resulting stage\nImmersive fashion needs to have at least one hair for the resulting hair stage length or hair might not change")
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutMinOID_S")
		SetInfoText("How many stages to cut your hair by. Actual will be random between min and max\nSo if you want rapes to only cut your hair by one stage use min and max of 1. If you want 'rapecuts' to take all your hair then set both high.\nMin can not be set higher than max")
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutMaxOID_S")
		SetInfoText("How many stages to cut your hair by. Actual will be random between min and max\nSo if you want rapes to only cut your hair by one stage use min and max of 1. If you want 'rapecuts' to take all your hair then set both high.\nMax can not be set lower than min")
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutFloorOID_S")
		SetInfoText("Hair cut floor stage. Hair won't be cut shorter than this when triggered")
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeDyeHairChanceOID_S")
		SetInfoText("Immersive Fashion. The chance to have your hair dyed on rape. Colors can be configured in ImmersiveFashion.json\nWarning: you can't change your hair color yourself for a long time after getting dyed. Unless raped again\nAlso pushes fashion addiction")
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeShavePussyChanceOID_S")
		SetInfoText("Immersive Fashion. The chance to have your pussy shaved on rape\nAlso pushes fashion addiction")
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeLipstickChanceOID_S")
		SetInfoText("Immersive Fashion. The chance a rapist will apply smudged lipstick making you look like a 10 septim whore\nAlso pushes fashion addiction")
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeEyeshadowChanceOID_S")
		SetInfoText("Immersive Fashion. The chance a rapist will apply smudged eyeshadow making you look like a 10 septim whore\nAlso pushes fashion addiction")
	
	ElseIf (option == SexMinStaminaRateOID_S)
		SetInfoText("Determines the stamina rate buff you'll receive during SLSO sex\nVanilla default is 5.0")	
	ElseIf (option == SexMinStaminaMultOID_S)
		SetInfoText("Determines the stamina rate mult buff you'll receive during SLSO sex\nVanilla default is 100")
	ElseIf (option == SexMinMagickaRateOID_S)
		SetInfoText("Determines the magicka rate buff you'll receive during SLSO sex\nVanilla default is 3.0")
	ElseIf (option == SexMinMagickaMultOID_S)
		SetInfoText("Determines the magicka rate mult buff you'll receive during SLSO sex\nVanilla default is 100")
	ElseIf (option == SexMinStamMagRatesOID)
		SetInfoText("Enable minimum stamina & magicka rates during sex\nIf your character is heavily debuffed during sex then scenes can go on forever. This will bring your rates up to a minimum level\nTurn off Min Stamina/Magicka in STA and use this instead as it takes effect before your 'Sex Experience' buffs are added on top")
	ElseIf (option == SexRapeDrainsAttributesOID)
		SetInfoText("Completely drain your magicka and stamina after rape events\nYou would probably have no stamina or magicka after rape if it wasn't for STA buffing your rates")
	ElseIf(option == SexExpCorruptionCurrentOID_S)
		SetInfoText("Your current creature corruption. Values over 100 are ignored\nThis slider is only for debugging purposes!")
	ElseIf(option == CockSizeBonusEnjFreqOID_S)
		SetInfoText("Larger cocks provide more SLSO enjoyment for the player. SLS will apply bonus enjoyment this often during sex. Actual enjoyment gained still relies heavily on the player's arousal\nIf the player is highly aroused then she'll have a very hard time trying not to orgasm while getting impaled on horse cock\nLarger cocks may make the player orgasm immediately/uncontrollably\nEncourages corruption. Set to zero to disable. Only applies to creature sex scenes")
	ElseIf(option == RapeForcedSkoomaChanceOID_S)
		SetInfoText("Chance of being forced to consume skooma on rape BEFORE sex begins. Giving you a stamina boost so you can hump like a rabbit. Most rape forced drugs in other mods occur after sex which only serves to give the player an advantage after sex\nSet to zero to disable")
	ElseIf(option == RapeMinArousalOID_S)
		SetInfoText("Bump up the arousal of rapists that have an arousal below this threshold. Why would they rape you if they're not horny?\nIf you're tired of rape scenes that go on forever because the rapist was never aroused enough to begin with then this is for you\nSet to zero to disable")
	ElseIf(option == ProxSpankNpcDB)
		SetInfoText("If enabled, Npcs that walk close by may run up and spank you if they are this type and your body slot item meets the required 'Cover' setting below\n'Guards' include both male and female")
	ElseIf(option == ProxSpankCoverDB)
		SetInfoText("Your current clothing/armor state must be this for Npcs to run up and spank you\nNaked - Self explanitory\nNaked/Bikini/Slooty - You are naked or wearing a bikini or the body slot item is flagged as 'Slooty' in SLAX or is 'Whoreish' or 'Slutty' in Milk Addict\nAnything - Doesn't matter what you're wearing, Npcs will try to spank you")		
	ElseIf(option == ProxSpankCooloffOID_S)
		SetInfoText("How long before you can be proximity spanked again")
	ElseIf(option == ProxSpankCommentOID)
		SetInfoText("Make STA attempt to do a comment like 'Nice ass' after successfully spanking your character\nProximity spanks are triggered off 'hello' events which try to make the Npc say something. Trying to make an Npc say another thing in a such a short space of time is unreliable and seems to sometimes lock the Npc out of further 'Hello' events until another interaction occurs or the actor is unloaded\nTherefore, the default is off and recommended")

	ElseIf(option == IneqStatsOID)
		SetInfoText("Men & women are not created equally. Men are stronger, faster and more cunning than women. Applies changes to all vanilla playable races\nThis option grants men more health, stamina and magicka and adds equal stat penalties to women")
	ElseIf(option == IneqStatsValOID)
		SetInfoText("How much of a bonus to give men and penalty to give women")
	ElseIf(option == IneqHealthCushionOID)
		SetInfoText("How much of a health cushion to give females\nFemale npcs must have a health greater than or equal to (the health stat debuff + this cushion) for the health debuff from inequality to apply\nThis is effectively a 'minimum health' slider which should stop Npcs with ridiculously low health from dropping dead")
	ElseIf(option == IneqCarryOID)
		SetInfoText("Men & women are not created equally. Men are stronger, faster and more cunning than women. Applies changes to all vanilla playable races\nThis option reduces the max carry weight for women only. No change applied to men")
	ElseIf(option == IneqCarryValOID)
		SetInfoText("How much of a penalty to apply to women only")
	ElseIf(option == InqSpeedOID)
		SetInfoText("Men & women are not created equally. Men are stronger, faster and more cunning than women. Applies changes to all vanilla playable races\nThis option gives men a speed bonus. Men only - has no effect on women")
	ElseIf(option == IneqSpeedValOID)
		SetInfoText("How much of a bonus to give men only")
	ElseIf(option == IneqDamageOID)
		SetInfoText("Men & women are not created equally. Men are stronger, faster and more cunning than women. Applies changes to all vanilla playable races\nThis option makes men do more damage and women do less damage with weapons\nBonus applied to men, penalty applied to women")
	ElseIf(option == IneqDamageValOID)
		SetInfoText("How much of a bonus to weapon damage to give men and penalty to give women")
	ElseIf(option == IneqDestOID)
		SetInfoText("Men & women are not created equally. Men are stronger, faster and more cunning than women. Applies changes to all vanilla playable races\nThis option makes men do more damage and women do less damage with destruction spells\nBonus applied to men, penalty applied to women")
	ElseIf(option == IneqDestValOID)
		SetInfoText("How much of a bonus to destruction spells to give men and penalty to give women")
	ElseIf(option == IneqSkillsOID)
		SetInfoText("Men & women are not created equally. Men are stronger, faster and more cunning than women. Applies changes to all vanilla playable races\nThis option slows your skill gain speed by 25% because of your inferior female brain that's incapable of grasping anything that isn't cooking, knitting or manual labor")
	ElseIf(option == IneqBuySellOID)
		SetInfoText("Men & women are not created equally. Men are stronger, faster and more cunning than women. Applies changes to all vanilla playable races\nThis option lowers your buying/selling prices by 15% because you have breasts")
	ElseIf(option == IneqVendorGoldOID)
		SetInfoText("Female vendors will have this much less gold available to trade than their male counterparts due to facing similar challenges in a misogynistic Skyrim as the player. Plus they're just bad at business of course or their husband only allows them a certain amount of gold they'd otherwise spend on frivolous things like shoes and silver buckles\nWon't take immediate effect if the vendor has already been loaded. Vendor stock will need to be refreshed first\nSet to 1.0 to disable the effect")
	ElseIf(option == IneqStrongFemaleFollowersOID)
		SetInfoText("Female followers are seasoned adventurers and have the same stats as male followers. Enable this if you prefer female followers but find them too weak to be useful with inequality penalties\nThis works for vanilla followers and any follower that has been added as a potential escort via the Licences page")
	ElseIf(option == ModStrongFemaleOID_T)
		SetInfoText("Make or unmake the current female under the crosshairs a strong female. Strong females don't suffer from inequality penalties\nStrong females are saved to a json and imported automatically on new games")
	ElseIf(option == LicShowApiBlockFormsOID_T)
		SetInfoText("Show forms that are currently blocking the purchase of licences from the quartermasters")
	ElseIf(option == LicClearApiBlockFormsOID_T)
		SetInfoText("Force clear all forms from blocking the purchase of licences from the quartermasters\nShould only be used if something goes wrong")
		
	ElseIf(option == AddFondleToListOID_T) || (option == RemoveFondleFromListOID_T)
		SetInfoText("Add/remove a creature from the allowable creature fondle list\nNote that it is the actors voice type that is used - so any other actor with the same voice will be included")
	ElseIf(option == FondleInfoOID_T)
		SetInfoText("How many times you've fondled a creature or accepted a breeding session from your animal companion\nYour creature sex partner will have their arousal increased by this amount when fondling animals or when getting bred\nThis will make it easier to make creatures cum (SLSO) the more experience you have. Does not count creature sex started in any other way except for fondling or breeding. You must make the creature orgasm for it to increase your experience\nFor your information only (Not an adjustable option)")
	ElseIf(option == AproTwoTrollHealAmountOID)
		SetInfoText("Swallowing a hot load of troll cum will heal Apropos2 wear & tear by this much")
		
	ElseIf(option == AnimalBreedEnableOID)
		SetInfoText("Enable animal breeding\nSucessfully making a creature cum will make them follow you for some time. How long depends on the settings below\nCurrently only works for horses - to be expanded later")
	ElseIf(option == AfCooloffBaseOID_S)
		SetInfoText("Cooldown added between breeding attempts per animal companion\nThis is the base cooloff. You'll gain this much time regardless of the rest of the conditions")
	ElseIf(option == AfCooloffBodyCumOID_S)
		SetInfoText("Cooldown added between breeding attempts per animal companion\nThis is the bonus time you'll gain for each layer of cum on your body shortly after the animal orgasms\nFor best results you should try to get full coverage on your face, ass and pussy and don't wash it off\nThe actual amount of time added is (number of cum layers / 6) * Hours")
	ElseIf(option == AfCooloffCumInflationOID_S)
		SetInfoText("Cooldown added between breeding attempts per animal companion\nThis is the bonus you'll get for being fully inflated with cum\nFor best results you should get both your ass and pussy filled to the maximum and try to hold it in - If you use devious devices you might consider finding some primitive plugs and plugging your holes to keep your precious cum in\nThe actual amount of time added is ((Ass Cum Pool + Pussy Cum Pool) / (Pool Max * 2)) * Hours")
	ElseIf(option == AfCooloffPregnancyOID_S)
		SetInfoText("Cooldown added between breeding attempts per animal companion\nThis is the bonus time you'll get for being impregnated to capacity\nThe actual amount of time added is (Number of gems / Maximum Gems) * Hours")
	ElseIf(option == AfCooloffCumSwallowOID_S)
		SetInfoText("Cooldown added between breeding attempts per animal companion\nThis is the bonus time you'll get for demonstrating your dedication and swallowing your animal companions cum")
	ElseIf(option == DflowResistLossOID_S)
		SetInfoText("How much Devious Followers resistance is lost during certain confidence-eroding events - Getting your ass spanked, picking up your bonus whore gold etc")

	ElseIf(option == CumBreathOID)
		SetInfoText("Enable/Disable the cum breath speech debuff you get for swallowing cum")
	ElseIf(option == CumBreathNotifyOID)
		SetInfoText("Enable/Disable cum breath notifications that pop up when the strength of the debuff changes")	
	ElseIf(option == CumSwallowInflateOID)
		SetInfoText("Swallowing cum will inflate your belly (applies to FHU 2.0 anal pool)")
	ElseIf(option == CumSwallowInflateMultOID_S)
		SetInfoText("The amount of inflation applied is based on your race settings in FHU\nThis slider multiplies that value for swallowed cum should you wish to add more/less inflation")
	ElseIf(option == CumEffectsEnableOID)
		SetInfoText("Enable/Disable beneficial magic effects gained from swallowing cum\nNote: The magic effect description window can not display fractions and so may display a magnitude of zero")
	ElseIf(option == CumEffectsStackOID)
		SetInfoText("If enabled the old cum effect (of the same type) will not be removed when you swallow another load from the same race")
	ElseIf(option == CumEffectsMagMultOID_S)
		SetInfoText("Multiplies the magnitude of all cum swallowing magic effects\nNote: The magic effect description window can not display fractions and so may display a magnitude of zero")
	ElseIf(option == CumEffectsDurMultOID_S)
		SetInfoText("Multiplies the duration of all cum swallowing magic effects")
	ElseIf(option == CumpulsionChanceOID_S)
		SetInfoText("The chance to catch a 'Cumpulsion' when swallowing cum. Cumpulsions are undesirable effects of swallowing cum\nHorse Cum - Pony Girl Cumpulsion: A desire to equip pony type devious devices\nMore to cum (hopefully)")
	ElseIf(option == CumRegenTimeOID_S)
		SetInfoText("How long it takes a male to fully recover their cum for you\nYou'll have to spread your mouth around to other males instead of sucking off the same actor over and over\nSet to zero to disable")
	ElseIf(option == CumEffectVolThresOID_S)
		SetInfoText("How much cum a male must have before it will successfully fire a magic effect\nThis includes healing dismemberments\nSet to zero to disable")
	ElseIf(option == SuccubusCumSwallowEnergyMultOID_S)
		SetInfoText("Swallowing cum as a PSQ succubus will provide this much more/less energy\nBigger balls will provide more cum. More cum = more energy\nCum Fullness also applies - see 'Cum Replenish Time'")
	ElseIf(option == SuccubusCumSwallowEnergyPerRankOID)
		SetInfoText("Multiply the PSQ succubus energy gained when you swallow cum by your succubus rank")
	ElseIf(option == CumAddictEnOID)
		SetInfoText("Enable cum addiction. Eating cum or being covered in cum increases your addiction to cum\nBeing addicted to cum creates a new need for cum. The higher your addiction the greater that need can get")
	ElseIf(option == CumAddictBeastLevelsOID)
		SetInfoText("As your addict level increases, so too does the hunger range values and hunger rate\nThis means that the more addicted you become the more cum it'll take to change your satiation levels\nBigger balls = more cum = more satiation = less time spent sucking cocks. As a rough guide:\nStarving at level 1 addiction - you'll need to suck off 2/3 guys to become satisfied\nStarving at level 4 addiction - you'll need to suck off 2 horses to become satisfied. Or about 12/13 guys to get the same amount of satiation")
	ElseIf(option == CumAddictHungerRateOID_S)
		SetInfoText("How many cum 'hunger points' are added every game hour\nIncrease to get more hunger more quickly and vice versa")
	ElseIf(option == CumAddictHungerRateEffective)
		SetInfoText("Your current effective hunger rate. Because 'Encourage Beastiality' is enabled it increases your hunger rate based on your current cum addiction level\nOnly FYI - Not configurable. Configure Hunger Rate instead")
	ElseIf(option == CumAddictClampHungerOID)
		SetInfoText("If enabled the your maximum hunger level is based on your current addiction level. IE:\nAt Addiction level 1: Max hunger is peckish. At addiction level 2: Max hunger is hungry\nAt addiction level 3: Max hunger is starving. At addiction level 4: Max hunger is ravenous\nIf disabled then maximum hunger level is always ravenous")
	ElseIf(option == CumAddictionSpeedOID_S)
		SetInfoText("How fast you gain addiction. Multiplies all addiction increases/decreases to either speed up or slow down the rate you gain addiction at")
	ElseIf(option == CumAddictionPerHourOID_S)
		SetInfoText("How many points of cum addiction are lost naturally every game hour\nAddiction won't decay if you have cum on your skin (Sexlab) or cum in your ass or pussy (FHU2.0)")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictBlockDecayOID")
		SetInfoText("If enabled then having any cum inside (FHU) or on your body will stop your cum addiction from decaying meaning you'll have to clean/deflate yourself before addiction starts decaying\nDisabled = cum addiction will always decay")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamOID")
		SetInfoText("When hungry for cum your character may begin to see the world in a different light. Spoilers:\nShe'll see mushrooms & butterflys differently. Imagine men naked and stare at their junk with her tongue hanging out. Imagine women moaning in pleasure and covered in cum\nAnd begin to see a lot of horny creatures (Needs creature framework)")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamVolOID_S")
		SetInfoText("Sets the volume of daydream moans when talking to a female")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflysOID")
		SetInfoText("Daydreaming will transform butterflys into sexy fairies")
		
	ElseIf(option == CumSatiationOID_S)
		SetInfoText("How much more/less hunger satiation is provided by eating cum\nSet lower if you want to have to eat more cum, set higher if you want to have to eat less cum")
	ElseIf(option == MilkDecCumBreathOID)
		SetInfoText("Drinking MME milk will decrease your cum breath debuff")
	
	ElseIf(option == CumAddictBatheRefuseTimeOID_S)
		SetInfoText("Your character will refuse to bathe for x hours after taking a fresh load on her body (Cum on her skin) when she is hungry or worse\nYou can satisfy her hunger or wait it out to be able to bathe again\nRequires BiS Tweaked")
	ElseIf(option == CumAddictReflexSwallowOID_S)
		SetInfoText("Your character has an increasing chance to instincively swallow cum without asking for your choice depending on how hungry she is or how addicted she is\nUse this slider to adjust the chance to be more or less\nBy default: At ravenous or cum junkie your character will always instinctively swallow")
	ElseIf(option == CumAddictAutoSuckCreatureOID_S)
		SetInfoText("Your character has an increasing chance to automatically suck off horny creatures she passes near by\nChance of stopping to suck depends on how hungry she is\nBy default: At ravenous she will always stop to suck if the creature is horny enough")
	ElseIf(option == CumAddictAutoSuckStageDB)
		SetInfoText("At what hunger stage does chance for Auto Sucking kick in")
	ElseIf(option == CumAddictAutoSuckCooldownOID_S)
		SetInfoText("Minimum time between automatically sucking a creatures cock")
	ElseIf(option == CumAddictAutoSuckCreatureArousalOID_S)
		SetInfoText("How aroused a creature needs to be before your character will even consider stopping to suck it's cock")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictAutoSuckVictim")
		SetInfoText("Player is a victim when automatically sucking a creature (A victim of her addiction)")

	ElseIf(option == CumIsLactacidOID_S)
		SetInfoText("Cum contains this much lactacid. Swallowing the cum of any enabled race provides this much lactacid. Lactacid = (Load Size X This slider)\nBascially, how much of the load content is lactacid")
	ElseIf(option == CumLactacidAllOID)
		SetInfoText("If enabled cum from any race will always provide lactacid when swallowed\nUse the 'Cum Provides X Lactacid' slider to scale the amount of lactacid provided")
	ElseIf(option == CumLactacidCustomOID_T)
		SetInfoText("Add/Remove the current voice type under the crosshairs as type whos cum provides lactacid\nUse the 'Cum Provides X Lactacid' slider to scale the amount of lactacid provided")
	ElseIf(option == CumLactacidAllPlayableOID)
		SetInfoText("Add/Remove all playable races as types whos cum provides lactacid\nPlayable race examples: Breton, Nord, Imperial etc\nUse the 'Cum Provides X Lactacid' slider to scale the amount of lactacid provided")
		
	ElseIf(option == GuardCommentsOID)
		SetInfoText("Enables/Disables obnoxious voiced guard 'hello' comments like 'I bet you've a beautiful body under those clothes'\nThere are comments for voice types: MaleGuard, MaleNordCommander & FemaleNord")
	ElseIf(option == GuardBehavWeapDropOID)
		SetInfoText("Guards will be watching your behaviour and give you warnings/punishments based on your actions\nThis makes guards react to dropping weapons")
	ElseIf(option == GuardBehavWeapDrawnOID)
		SetInfoText("Guards will be watching your behaviour and give you warnings/punishments based on your actions\nThis makes guards react when you have your weapons drawn outside of combat. Has a 1 second grace period\nNote that Guard Behaviour is not related to licences. It's just a set of rules for you to follow around guards. It does however, respect licence exceptions for equipped armors/weapons")
	ElseIf(option == GuardBehavWeapEquipOID)
		SetInfoText("Guards will be watching your behaviour and give you warnings/punishments based on your actions\nThis makes guards react when you have a weapon equipped\nToll Evasion needs to be enabled for this to be toggled on. Only applies to walled cities\nNote that Guard Behaviour is not related to licences. It's just a set of rules for you to follow around guards. It does however, respect licence exceptions for equipped armors/weapons")
	ElseIf(option == GuardBehavArmorEquipOID)
		SetInfoText("Guards will be watching your behaviour and give you warnings/punishments based on your actions\nThis makes guards react when you have armor equipped in the body/head/hands/feet slots. Disabled by default as it's a little unimmersive (lots of female npcs walking around in armor)\nToll Evasion needs to be enabled for this to be toggled on. Only applies to walled cities\nNote that Guard Behaviour is not related to licences. It's just a set of rules for you to follow around guards. It does however, respect licence exceptions for equipped armors/weapons")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmorOID")
		SetInfoText("If enabled armor in any slot will trigger a guard stop. This does not respect licence exceptions\nIf disabled then only armor in head/body/hands/feet is checked. This does respect licence exceptions")
	ElseIf(option == GuardBehavLockpickingOID)
		SetInfoText("Guards will be watching your behaviour and give you warnings/punishments based on your actions\nThis makes guards react when they see you picking locks")
	ElseIf(option == GuardBehavDrugsOID)
		SetInfoText("Guards will be watching your behaviour and give you warnings/punishments based on your actions\nThis makes guards react when the see you consuming drugs - skooma/lactacid")
	ElseIf(option == GuardBehavShoutOID)
		SetInfoText("Guards will be watching your behaviour and give you warnings/punishments based on your actions\nThis makes guards react when you shout around town")
	
	ElseIf(option == RunDevicePatchUpOID_T)
		SetInfoText("Run the Devious Devices patching routine. Use this after you make any modifications to the json file 'DeviceList.json'\nOtherwise any changes you make to the device list file may not take effect unless you do this first")
	ElseIf(option == DeviousGagDebuffOID_S)
		SetInfoText("Sets the speech debuff you get when talking to Npcs while gagged ('Speech debuff added')\nDefault DDi is 80 which is pretty extreme, especially when your Devious Follower, whom you have to pay for by selling stuff, might expect you to be gagged at all times\nDoesn't cover Cursed Loots gag talk because that doesn't have a debuff")
	ElseIf(option == DeviousEffectsEnableOID)
		SetInfoText("Enable/Disable pickpocketing/lockpicking devious effects")
	ElseIf Option == StorageUtil.GetIntValue(Self, "DeviousDrowningOID")
		SetInfoText("Requires Frostfall. When wearing heavy bondage you'll be unable to swim for long periods of time without 'drowning'\nDevious drowning will quickly drain your stamina. When your stamina is gone your health will drop fast\nProbably best to not risk swimming at all")
	ElseIf(option == DevEffLockpickDiffDB)
		SetInfoText("The difficulty of picking locks when equipped in heavy bondage (armbinders/yokes/strait jackets/mitts)\nOff - Guess?\nDifficult - Debuff to your lockpicking stat\nImpossible - Yup, not happening. Ever")
	ElseIf(option == DevEffPickpocketDiffDB)
		SetInfoText("The difficulty of picking pockets when equipped in heavy bondage (armbinders/yokes/strait jackets/mitts)\nOff - Guess?\nDifficult - Debuff to your pocket picking stat\nImpossible - Yup, not happening. Ever")
	ElseIf(option == DevEffNoGagTradingOID)
		SetInfoText("Enabled - You can not trade when gagged\nDisabled - Off")

	ElseIf(option == PpLootEnableOID)
		SetInfoText("Adds a perk to the player that adds a chance to find extra loot on Npcs making becoming a criminal a more tempting proposition for a struggling dragonborn\nLoot includes gold, gems, jewelry, spell tomes, potions, food, devious keys and enchanted jewelry\nExtra loot won't trigger on beggars, Zaz slaves or SBC slaves")
	ElseIf(option == PpGoldChanceOfNoneOID_T)
		SetInfoText("This is how much free % chance you have to play with to increase the chance of something for gold. You'll have to decrease the chance of something if chance of none is zero before increasing the chance of something else\nA bit confusing but just play with the sliders a bit and you'll get it")
	ElseIf(option == PpGoldLowChanceOID_S)
		SetInfoText("The chance for an Npc to have a low amount extra gold ~ 10 - 100 ish")
	ElseIf(option == PpGoldModerateChanceOID_S)
		SetInfoText("The chance for an Npc to have a moderate amount extra gold ~ 100 - 350 ish")
	ElseIf(option == PpGoldHighChanceOID_S)
		SetInfoText("The chance for an Npc to have a high amount extra gold ~ 400 - 700 ish")
	ElseIf(option == PpLootMinOID_S)
		SetInfoText("The minimum amount of extra loot drops to try to add to an npc\nActual will be random between min and max\nIf chance of none > 0% then there is a chance that nothing will be dropped per drop")
	ElseIf(option == PpLootMaxOID_S)
		SetInfoText("The maximum amount of extra loot drops to try to add to an npc\nActual will be random between min and max\nIf chance of none > 0% then there is a chance that nothing will be dropped per drop")

	ElseIf(option == PpLootChanceOfNoneOID_T)
		SetInfoText("This is how much free % chance you have to play with to increase the chance of something for loot. You'll have to decrease the chance of something if chance of none is zero before increasing the chance of something else\nA bit confusing but just play with the sliders a bit and you'll get it")
	ElseIf(option == PpLootFoodChanceOID_S)
		SetInfoText("The chance for an Npc to have extra food\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	ElseIf(option == PpLootGemsChanceOID_S)
		SetInfoText("The chance for an Npc to have extra gems\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	ElseIf(option == PpLootSoulgemsChanceOID_S)
		SetInfoText("The chance for an Npc to have extra soul gems\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	ElseIf(option == PpLootJewelryChanceOID_S)
		SetInfoText("The chance for an Npc to have extra jewelry\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	ElseIf(option == PpLootEnchJewelryChanceOID_S)
		SetInfoText("The chance for an Npc to have extra enchanted jewelry\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	ElseIf(option == PpLootPotionsChanceOID_S)
		SetInfoText("The chance for an Npc to have extra potions\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	ElseIf(option == PpLootKeysChanceOID_S)
		SetInfoText("The chance for an Npc to have extra devious keys (chastity & restraints only atm)\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	ElseIf(option == PpLootTomesChanceOID_S)
		SetInfoText("The chance for an Npc to have extra spell tomes\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	ElseIf(option == PpLootCureChanceOID_S)
		SetInfoText("The chance for an Npc to have extra cure disease potions\nCure disease potions are also included in the 'Potions' option but have much less chance to spawn due to the number of other potions in the list\nIf chance of none is zero then you'll have to decrease the chance of something else before increasing this")
	
	ElseIf(option == PpSleepNpcPerkOID)
		SetInfoText("Adds a perk to the player that makes it easier to pickpocket sleeping Npcs (+33%). It's mostly intended as a way for a fledgling thief to hone her skills. Might work best with other mods that add dangers/risks to being out at night")
	ElseIf(option == PpFailHandleOID)
		SetInfoText("Enable/Disable pick pocketing failure handling\nWhen caught picking pockets the mod will attempt to stop npcs from going beserk and will trigger some random consequences instead\nDoesn't work on Npcs in scenes as scenes take priority. So don't try it on npcs that are talking to other npcs. This includes the 'stupid dog' scene.")
	ElseIf(option == PpCrimeGoldOID_S)
		SetInfoText("How much of a bounty to get when caught picking pockets\nVanilla: 25 gold. Requiem: 250 gold. SLS: 100 gold.")
	ElseIf(option == PpFailDevicesOID_S)
		SetInfoText("The number of devious devices to equip when caught picking pockets\nActors in scenes are excluded from pickpocket failure mechanics")
	ElseIf(option == PpFailStealValueOID_S)
		SetInfoText("How much in value of items to take from you when caught picking pockets\nSet to zero to disable Npcs taking your stuff\nActors in scenes are excluded from pickpocket failure mechanics")
	ElseIf(option == PpFailDrugCountOID_S)
		SetInfoText("The number of drugs to force equip when caught picking pockets\nActors in scenes are excluded from pickpocket failure mechanics")
	
	ElseIf(option == DismembermentsDB)
		SetInfoText("Off - Player dismemberments off\nRandom - Always choose a random limb to dismember\nHands First - Dismember hands first up to Arm Depth Max. Then start on the legs\nYou can limit dismemberment to hands only if you dislike crawling by setting hands only here and set Max Limbs to 2")
	ElseIf(option == DismemberProgressionDB)
		SetInfoText("One At A Time - Dismember one section of a limb at a time. Eg. Hand, then forearm, then upper arm\nMax In One - Dismember to Depth Max in a single blow\nRandom - Dismember randomly up to Depth Max")
	ElseIf(option == DismemberWeaponsDB)
		SetInfoText("What kinds of weapons can dismember. Self explanatory")
	ElseIf(option == DismemberDepthMaxArmsDB)
		SetInfoText("How far up the arm to dismember. If you don't plan on having leg dismemberment you can dismember up to upper arms and still look ok running around on legs. If you do plan on having leg dismemberment I'd recommend no more than forearm as you'll still be able to crawl around without it looking weird")
	ElseIf(option == DismemberDepthMaxLegsDB)
		SetInfoText("How far up the leg to dismember. I don't recommend any more then lower leg as crawling will look weird without stumps (floating)")
	ElseIf(option == DismemberMaxAmpedLimbsOID_S)
		SetInfoText("The maximum number of limbs (Left arm/right arm/left leg/right leg) that can be dismembered at any one time")
	ElseIf(option == DismemberCooldownOID_S)
		SetInfoText("Minimum time before you can get dismembered again. Recommend setting this to something that isn't zero\nIf set to zero you can get absolutely butchered during bleedout events before enemies are pacified")
	ElseIf(option == DismemberChanceOID_S)
		SetInfoText("The base chance of getting dismembered on power attacks")
	ElseIf(option == DismemberArmorBonusOID_S)
		SetInfoText("The reduction in dismember chance per 10 points of armor you have\nEg If you have base chance set to 100% and Armor bonus set to 5.0 and have 100 armor then you'd have an actual chance of being dismembered of (100% - ((100 armor / 10.0) * 5.0)) = 50%")
	ElseIf(option == DismemberChanceActualOID_T)
		SetInfoText("Your current actual chance of getting dismembered based on your current armor value\nThis option is for your information only. Doesn't actually do anything.")
	ElseIf(option == DismemberDamageThresOID_S)
		SetInfoText("The base damage stat a weapon must have before it can dismember. This should stop whips etc from dismembering")
	ElseIf(option == DismemberHealthThresOID_S)
		SetInfoText("The health a creature must have to dismember you on power attacks. Should stop small animals (skeevers etc) from dismembering you")
	ElseIf(option == AmpPriestHealCostOID_S)
		SetInfoText("How much it costs for priests to restore your limbs\nYou can also swallow troll cum to restore your limbs\nPriests: Whiterun - Danica, Riften - Maramal, Windhelm - Lortheim, Solitude - Freir, Markarth - Anwen/Verulus")
	ElseIf Option == StorageUtil.GetIntValue(Self, "AmpBlockMagicOID")
		SetInfoText("When a hand is cut off you will not be able to equip spells to it\nDisable if using nipple magic")
	ElseIf(option == DismemberTrollCumOID)
		SetInfoText("Swallowing troll cum heals all amputations")
	ElseIf(option == DismemberBathingOID)
		SetInfoText("If enabled Survival will disable your ability to bathe when you have no hands (Requires Bathing in Skyrim Tweaked)")
	ElseIf(option == DismemberPlayerSayOID)
		SetInfoText("Use the function Say() to make the player speak hurt/pain sounds. Say() can cause CTDs under certain circumstances. \nIf disabled Play() will be used which just plays the sound effect on the player (players lips won't move)\nTry disabling this option if you CTD during dismember events")

	ElseIf(option == BondFurnEnableOID)
		SetInfoText("Enable bondage furniture effects")
	ElseIf(option == BondFurnMilkFreqOID_S)
		SetInfoText("How often to run the fatigue drain effect when in a MME milking machine\nThis counts as 1 tick for willpower loss")
	ElseIf(option == BondFurnMilkFatigueMultOID_S)
		SetInfoText("How much fatigue is lost every tick when sitting in a MME milking machine")
	ElseIf(option == BondFurnMilkWillOID_S)
		SetInfoText("How many ticks must pass before your Devious Followers willpower is reduced by 1 when sitting in a MME milking machine")
	ElseIf(option == BondFurnFreqOID_S)
		SetInfoText("How often to run the fatigue drain effect when in bondage furniture\nThis counts as 1 tick for willpower loss")
	ElseIf(option == BondFurnFatigueMultOID_S)
		SetInfoText("How much fatigue is lost every tick when sitting in bondage furniture")
	ElseIf(option == BondFurnWillOID_S)
		SetInfoText("How many ticks must pass before your Devious Followers willpower is reduced by 1 when sitting in bondage furniture")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntAproposTwoOID") || option == StorageUtil.GetIntValue(Self, "IntAmpOID") || option == StorageUtil.GetIntValue(Self, "IntDdsOID") || option == StorageUtil.GetIntValue(Self, "IntDfOID") || option == StorageUtil.GetIntValue(Self, "IntEsdOID") || option == StorageUtil.GetIntValue(Self, "IntEffOID") || option == StorageUtil.GetIntValue(Self, "IntFhuOID") || option == StorageUtil.GetIntValue(Self, "IntFrostfallOID") || option == StorageUtil.GetIntValue(Self, "IntIneedOID")|| option == StorageUtil.GetIntValue(Self, "IntMaOID") || option == StorageUtil.GetIntValue(Self, "IntPscOID") || option == StorageUtil.GetIntValue(Self, "IntRndOID") || option == StorageUtil.GetIntValue(Self, "IntSlaxOID") || option == StorageUtil.GetIntValue(Self, "IntSlsoOID") || option == StorageUtil.GetIntValue(Self, "IntSlsfOID") || option == StorageUtil.GetIntValue(Self, "IntSlaverunOID") || option == StorageUtil.GetIntValue(Self, "IntTatsOID") || option == StorageUtil.GetIntValue(Self, "IntSgoOID") || option == StorageUtil.GetIntValue(Self, "IntStaOID") || option == StorageUtil.GetIntValue(Self, "IntBisOID") || option == StorageUtil.GetIntValue(Self, "IntSexyMoveOID")
		SetInfoText("Whether or not this mods interface is active or not\nThe toggle should match your load order. Interfaces may take some time to start up on new games and when a soft dependency has been installed\nClicking this option will reinitialize the interface")
	
	; Simply Knock
	ElseIf(option == NormalKnockDialogOID)
		SetInfoText("Enable/Disable regular Simply Knock dialog")
	ElseIf(option == KnockSlaveryChanceOID_S)
		SetInfoText("Chance of being enslaved once the simply knock scenario ends")
	ElseIf(option == SimpleSlaveryWeightOID_S)
		SetInfoText("Weight of being sent to Simple Slavery (If installed)")
	ElseIf(option == SdWeightOID_S)
		SetInfoText("Weight of being sent to Sanguines Debauchery (If installed)")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPainSoundVolOID_S")
		SetInfoText("Female pain sound volume")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHitSoundVolOID_S")
		SetInfoText("Hit sound volume")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaEnableOID")
		SetInfoText("Characters will receive bruises/small cuts when taking hits during combat or on animation stage change during rape scenes or when pushed onto the ground\nDisable this and exit the MCM to remove all traumas from all actors")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaRebuildTexturesOID_T")
		SetInfoText("Rebuild the texture lists used for trauma. Use this if you add/remove textures from the Battle Wounds folders\nDoing this will remove all trauma from all actors")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaDynamicOID")
		SetInfoText("Random Npc's that are raped might be given traumas and added to the trauma tracking system\nIf dynamic slots are full then the oldest actor will be replaced with the new one")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaDynamicCombatOID")
		SetInfoText("Try to add traumas to random npcs in combat based on the combat hit chances and push chance\nIf this is disabled then the only way for random Npcs to enter the trauma system is via rape")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaTrackFollowerOID_T")
		SetInfoText("Add/Remove a follower from the trauma tracking system\nFollowers can be added dynamically if that option is enabled but they won't always be tracked unless added here. Adding them here gives them a permanent place in the tracking system\nYou can untrack a dynamcically added follower and then 're-track' them to add them to permanent tracking")

	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxPlayerOID_S")
		SetInfoText("The maximum number of traumas the player can have at one time. Older traumas will be removed before adding a new one if the cap is reached")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxFollowerOID_S")
		SetInfoText("The maximum number of traumas followers can have at one time. Older traumas will be removed before adding a new one if the cap is reached")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxNpcOID_S")
		SetInfoText("The maximum number of traumas Npcs can have at one time. Older traumas will be removed before adding a new one if the cap is reached")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaStartingOpacityOID_S")
		SetInfoText("At what opacity to start traumas. Traumas will gradually fade in up to max opacity from there")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaMaximumOpacityOID_S")
		SetInfoText("The maximum opacity of a trauma. Once a trauma hits this value it will begin to fade out")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHoursToFadeInOID_S")
		SetInfoText("How long it takes a trauma to reach opacity max in game hours")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHoursToFadeOutOID_S")
		SetInfoText("How long it takes a trauma to fade out in game hours. Traumas will be removed once they reach 20% (barely visible)")
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChancePlayerOID_S")
		SetInfoText("The chance for the player of receiving a single trauma on every animation stage change when raped. The longer the animation goes on the more messed up an actor can get")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChanceFollowerOID_S")
		SetInfoText("The chance for followers of receiving a single trauma on every animation stage change when raped. The longer the animation goes on the more messed up an actor can get")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChanceOID_S")
		SetInfoText("The chance for Npcs of receiving a single trauma on every animation stage change when raped. The longer the animation goes on the more messed up an actor can get")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsPlayerOID_S")
		SetInfoText("How many 'hits' the player might take per animation stage change during rape. For each hit a trauma will be added if it passes the chance check. Since rape mods mainly focus on the player this option allows skewing the chance of creating more abused Npcs on the rare occasion that an Npc gets raped")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsFollowerOID_S")
		SetInfoText("How many 'hits' followers might take per animation stage change during rape. For each hit a trauma will be added if it passes the chance check. Since rape mods mainly focus on the player this option allows skewing the chance of creating more abused Npcs on the rare occasion that an Npc gets raped")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsOID_S")
		SetInfoText("How many 'hits' Npcs might take per animation stage change during rape. For each hit a trauma will be added if it passes the chance check. Since rape mods mainly focus on the player this option allows skewing the chance of creating more abused Npcs on the rare occasion that an Npc gets raped")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPlayerSqueaksOID")
		SetInfoText("Play a pain sound on the player when a trauma is added during combat or sex")	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaDamageThresholdOID_S")
		SetInfoText("When hit by a weapon it's base damage must be equal or higher than this to add a trauma. Stops low damage items like whips etc adding traumas. Unarmed attacks automatically bypass this check")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChancePlayerOID_S")
		SetInfoText("The chance the player will take a trauma when hit with an unblocked attack with a greater damage than the damage threshold\nSet slider to zero to disable OnHit events for the player")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChanceFollowerOID_S")
		SetInfoText("The chance followers will take a trauma when hit with an unblocked attack with a greater damage than the damage threshold\nSet slider to zero to disable OnHit events for the followers")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChanceOID_S")
		SetInfoText("The chance Npcs will take a trauma when hit with an unblocked attack with a greater damage than the damage threshold\nSet slider to zero to disable OnHit events for the random Npcs")
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPushChancePlayerOID_S")
		SetInfoText("The chance for a character to take a trauma when knocked to the ground\nThis should include getting pushed around by men in SLS, getting FusRoDah'd by enemies and junkie tripping in Milk Addict or any mod that rag-dolls the actor")
		
	; Needs
	ElseIf(option == GluttedSpeedMultOID_S)
		SetInfoText("Set the speed of RNDs gluttony debuff\nRNDs default is 30 which is really high if other mods are also debuffing your speed\nChanges won't affect existing effects")
	ElseIf(option == SleepDeprivOID)
		SetInfoText("The maximum rest you can gain will be capped based on the conditions in which you sleep.\nWhat you're sleeping on (bed/bedroll/ground), sleeping outdoors, in the cold, in armor, in devious devices and being aroused all affect the penalties applied.\nOpen up the sleep menu and wait a second or two for the conditions summary to pop up. It will detail what your conditions are like and what kind of rest to expect.\nThe point of all this is to make homes/inns more desirable than sleeping on the ground in a snowstorm on a mountain.")
	ElseIf(option == CumFoodMultOID_S)
		SetInfoText("Multiples how much 'food' cum provides\nThis only applies to your needs mod. Does not apply to cum addiction")
	ElseIf(option == CumDrinkMultOID_S)
		SetInfoText("Multiples how much 'water' cum provides\nThis only applies to your needs mod. Does not apply to cum addiction")
	ElseIf(option == SaltyCumOID)
		SetInfoText("If enabled swallowing cum will instead make you more thirsty")
	ElseIf(option == SkoomaSleepOID_S)
		SetInfoText("Multiples how much rest skooma or skooma whore drugs provides")
	ElseIf(option == MilkSleepMultOID_S)
		SetInfoText("Multiples how much rest MMEs various milks provide\nBetter milks provide more rest")
	ElseIf(option == DrugEndFatigueIncOID_S)
		SetInfoText("When the drug effect ends your fatigue will return to it's previous value and additionally be increased by:\n(Fatigue lost by consuming drug * This slider)\nSet this slider to negative 5.0 to stop Survival adding any fatigue when the drug effect expires")
		
	ElseIf(option == BellyScaleEnableOID)
		SetInfoText("Enable/Disable SLIF belly scaling based on your hunger level\nNote that negative scaling doesn't seem to be possible so all I can do is make your belly bigger the fuller you are")
	ElseIf(option == BaseBellyScaleOID_S)
		SetInfoText("Your base belly scale. It's usually 1.0 in my experience but can sometimes be 0.0")
	ElseIf(option == BellyScaleRnd00OID_S)
		SetInfoText("How much belly scaling to apply when glutted")
	ElseIf(option == BellyScaleRnd01OID_S)
		SetInfoText("How much belly scaling to apply when satiated")
	ElseIf(option == BellyScaleRnd02OID_S)
		SetInfoText("How much belly scaling to apply when peckish")
	ElseIf(option == BellyScaleRnd03OID_S)
		SetInfoText("How much belly scaling to apply when hungry")
	ElseIf(option == BellyScaleRnd04OID_S)
		SetInfoText("How much belly scaling to apply when very hungry")
	ElseIf(option == BellyScaleRnd05OID_S)
		SetInfoText("How much belly scaling to apply when starving")
		
	ElseIf(option == BellyScaleIneed00OID_S)
		SetInfoText("How much belly scaling to apply when satiated")
	ElseIf(option == BellyScaleIneed01OID_S)
		SetInfoText("How much belly scaling to apply when mildly hungry")
	ElseIf(option == BellyScaleIneed02OID_S)
		SetInfoText("How much belly scaling to apply when moderately hungry")
	ElseIf(option == BellyScaleIneed03OID_S)
		SetInfoText("How much belly scaling to apply when severely hungry")
		
	; Frostfall
	ElseIf(option == WarmBodiesOID_S)
		SetInfoText("How much warmth is gained per tick during sex scenes")
	ElseIf(option == CumWetMultOID_S)
		SetInfoText("Multiples how wet cum makes you")
	ElseIf(option == CumExposureMultOID_S)
		SetInfoText("Multiples how much exposure is lost when someone cums in/on you")
	ElseIf(option == MilkLeakWetOID_S)
		SetInfoText("Multiples how much rest MMEs various milks provide\nBetter milks provide more rest")
	ElseIf(option == SwimCumCleanOID_S)
		SetInfoText("Swimming naked for this many seconds clears the cum from your body. Up for a little skinny-dipping?\nNeeds Frostfall to work. Set to 0 to disable the effect")
	
	ElseIf(option == FfRescueEventsOID)
		SetInfoText("Enable/Disable Simple Slavery/SD Dreamworld outcomes when exposure reaches maximum")
	
	ElseIf(option == SimpleSlaveryFFOID_S)
		SetInfoText("Weight for being sent to Simple Slavery on succumbing to exposure")
	ElseIf(option == SdDreamFFOID_S)
		SetInfoText("Weight for being sent to Sanguine Debaucherys Dreamworld on succumbing to exposure")
		
	; Tolls & Eviction
	ElseIf(option == CurrentLocationOID_T)
		SetInfoText("Your location right now\nIf the location is 'Nowhere' then it means that the cells location was not set and therefore can not be added to the system\nNone locations are usually wilderness but some mods might not set the location name = Nothing I can do in that case")
	ElseIf(option == AddTownLocationOID_T)
		SetInfoText("Associate your current location with a walled city. Use this to add custom mod locations to Survivals toll system\nA location can only be associated with one town. The location you add should be within the city walls - ie. you should need to leave through the toll gates (normally) to get outside the city")
	ElseIf(option == RemoveTownLocationOID_T)
		SetInfoText("Remove your current location from any associated town\nVanilla locations are hard-coded and can not be removed")
		
	ElseIf(option == EvictionLimitOID_S)
		SetInfoText("At what bounty you are evicted from your home")
	ElseIf(option == SlaverunEvictionLimitOID_S)
		SetInfoText("At what bounty you are evicted from your home in slaverun controlled towns")
	ElseIf(option == ConfiscationFineOID_S)
		SetInfoText("How much it will cost to get your stuff back\nSearch for the chest around where the 'Evidence' chests usually are")
	ElseIf(option == ConfiscationFineSlaverunOID_S)
		SetInfoText("How much it will cost to get your stuff back in Slaverun towns\nSearch for the chest around where the 'Evidence' chests usually are")
	ElseIf option == StorageUtil.GetIntValue(Self, "TollsEnableOID")
		SetInfoText("Enable/Disable gate tolls altogether")
	ElseIf(option == DoorLockDownOID)
		SetInfoText("Enable/Disable toll gate lockdown\nDisable this if door locks are getting in the way of quests etc")
	ElseIf(option == TollFollowersHardcoreOID)
		SetInfoText("Lock followers required to this value. You won't be able to change followers required once this is set\nIn the future this may be the 'base' followers required and certain events (like getting defeated) may automatically increase it")
	ElseIf(option == TollFollowersOID_S)
		SetInfoText("How many followers you'll need before they let you leave\nAlso controls how many followers are required by town enforcers")
	ElseIf(option == TollSexAggDB)
		SetInfoText("Sex to pay the toll is:\nAggressive/Not Aggressive - Self explanitory\nDon't care: Aggressive tag won't be filtered either way\nDF willpower fixed: High will (7-10) - Aggressive, Med will (4-6) - 50:50, Low will (0-3) - Unaggressive\nDF willpower % chance: % Chance of an unaggressive animation = (10 - Willpower)%\nFunction will fallback to not filtering the Aggressive tag if no animations were found")
	ElseIf(option == TollSexVictimDB)
		SetInfoText("Player is/is not a victim when using sex to pay the toll - Being a victim counts as rape")
	ElseIf(option == TollCostGoldOID_S)
		SetInfoText("Gold needed to leave town")
	ElseIf(option == GoldPerLevelOID)
		SetInfoText("Gold tolls are multiplied by the players level")
	ElseIf(option == SlaverunFactorOID)
		SetInfoText("Towns currently enslaved by Slaverun Reloaded have their tolls increased by this")
	ElseIf(option == SlaverunJobFactorOID)
		SetInfoText("Slaverun towns will need you to perform this many 'jobs' to reduce your toll to zero\nYour toll will be reduced by (Toll Total / Job Factor) per 'job'")
	ElseIf(option == TollCostDevicesOID_S)
		SetInfoText("How many devious devices will be equipped for tolls")
	ElseIf(option == TollCostTattoosOID_S)
		SetInfoText("How many tattoos are applied for tolls")
	ElseIf(option == TollCostDrugsOID_S)
		SetInfoText("How many lactacid/skooma you'll be forced to use for a toll")
		
	ElseIf(option == TollDodgingOID)
		SetInfoText("Enable toll evasion. If you leave town without paying the toll the guards will be on the lookout for you when you return. You will not like the consequences if they catch you. Be alert and try to avoid them")
	ElseIf(option == TollDodgeGracePeriodOID_S)
		SetInfoText("How long in game hours you can be outside a city before you are considered as having left without paying the toll")
	ElseIf(option == TollDodgeHuntFreqOID_S)
		SetInfoText("How often to check if guards can see you. Lower = faster more responsive guards but uses more CPU. Higher = Slower guards but less impact on CPU. Polling is active as little as possible - When you're in town and are trying to avoid the guards")
	ElseIf(option == TollDodgeMaxGuardsOID_S)
		SetInfoText("Maximum number of guard that can pursue you at any one time")
	ElseIf(option == TollDodgeDetectDistMaxOID_S)
		SetInfoText("Maximum distance at which a guard will spot you in walled cities.\nDoes not include penalties from not covering your body or head\nJust to give you an idea 128 'units' is approximately equal to the height of an Npc")
	ElseIf(option == TollDodgeDetectDistTownMaxOID_S)
		SetInfoText("Maximum distance at which an licence enforcer will spot you in small towns.\nDoes not include penalties from not covering your body or head\nJust to give you an idea 128 'units' is approximately equal to the height of an Npc")
	ElseIf(option == TollDodgeDisguiseBodyPenaltyOID_S)
		SetInfoText("The guards have studied your body extensively or you likely have unique markings on your characters body. Not wearing something in the body slot will make you more recognisable and increase the distance at which guards will spot you\nThis is the same setting for Toll Evasion and Licence enforcers. Provided here for convenience")
	ElseIf(option == TollDodgeDisguiseHeadPenaltyOID_S)
		SetInfoText("Not wearing something in the head slot will make you more recognisable and increase the distance at which guards will spot you\nThis is the same setting for Toll Evasion and Licence enforcers. Provided here for convenience")
	ElseIf(option == TollDodgeCurrentSpotDist)
		SetInfoText("The distance you'll be spotted at with your current settings and equipped body/head armor in cities\nGive it a second after changing equipment to update as the script is lazy to keep cpu usage low\nJust to give you an idea 128 'units' is approximately equal to the height of an Npc\nThis option is only for display purposes (doesn't actually do anything)")
		
	ElseIf(option == TollDodgeCurrentSpotDistTown)
		SetInfoText("The distance you'll be spotted at with your current settings and equipped body/head armor around small towns\nGive it a second after changing equipment to update as the script is lazy to keep cpu usage low\nJust to give you an idea 128 'units' is approximately equal to the height of an Npc\nThis option is only for display purposes (doesn't actually do anything)")
	
	
	ElseIf(option == TollDodgeGiftMenuOID)
		SetInfoText("When caught and you don't have the gold to pay the fine the guard will take items from your inventory as compensation. If enabled a gift menu will open and you can decide which items to give. If disabled then the guard will just take random items. NOTE!: These items aren't put in the confiscation chests. The only way to get them back is pickpocket or kill the guard that took them.")
	ElseIf(option == TollDodgeItemValueModOID_S)
		SetInfoText("Modify how much each item is worth towards your bounty when the guards takes things from your inventory")

	ElseIf(option == CurfewEnableOID)
		SetInfoText("Enable curfew. You won't be able to leave through toll gates during the hours specified")
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewBeginOID_S")
		SetInfoText("The time that gate curfew begins and you will not be allowed to leave until curfew ends")
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewEndOID_S")
		SetInfoText("The time that gate curfew ends and you are allowed to leave town again")
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewSlavetownBeginOID_S")
		SetInfoText("The time that gate curfew begins for towns enslaved by Slaverun and you will not be allowed to leave until curfew ends. Can be set the same as normal curfew if you wish")
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewSlavetownEndOID_S")
		SetInfoText("The time that gate curfew ends for towns enslaved by Slaverun and you are allowed to leave town again. Can be set the same as normal curfew if you wish")
		
	; Licences
	ElseIf(option == LicencesEnableOID)
		SetInfoText("Enable/Disable licence system\nYou may need to exit the menu for changes to take effect\nNote that licences do not affect 'Guard Behaviours' on the Misogyny & Inequality page")
	ElseIf(option == LicencesSnowberryOID)
		SetInfoText("For snowberries! Start the game with short duration licences to make things a bit easier\nMust be toggled on before leaving the Alternate Start cell\nDisabled licence types won't be given. Clothes licence only given when set to 'Always'")
	ElseIf(option == LicenceStyleDB)
		SetInfoText("Choose your style of licence system\nDefault: Access all licence types from the beginning if you have the coin and the licence guy doesn't have some small problem for you to resolve\nThaneship Choice: Upon becoming thane of one of the five walled cities be granted a choice of what licence you want access to. Talk to a quartermaster to make your choice\nThaneship Random: Upon becoming thane you will be granted access to a random licence\nUnlock: Licences must first be unlocked by paying a high fee")
	ElseIf(option == BikiniLicFirstOID)
		SetInfoText("If enabled and you use one of the 'Thaneship' style licence systems and the bikini licence is enabled then the bikini licence will always be awarded first before the full armor licence\nIf 'Choice' is enabled then you'll need have picked the bikini licence first before the full armor licence is available to be chosen\nIf 'Random' then the full armor licence will only be added to the pool of licences you can receive when you've already unlocked the bikini licence")
	ElseIf(option == FollowerLicStyleDB)
		SetInfoText("How licences apply to your followers\nPlayer Centric - Licences apply only to the player. You follower can carry any equipped weapons/armors without any licences\nParty wide - Licences apply to you and followers. Followers can not carry any items you don't have a licence for")
	ElseIf(option == LicUnlockCostOID_S)
		SetInfoText("How much it costs to unlock licences in the licence unlock style mode")
	ElseIf(option == LicBlockChanceOID_S)
		SetInfoText("The chance licence quartermasters will have some issue with you buying a licence\nScenarios are randomized every game day or after changing this slider\nWarning: Changing the slider may reset the scenarios if you have already 'passed' them\nDefault might seem high but some of the scenarios are easily overcome")
	ElseIf(option == LicBuyBackOID)
		SetInfoText("Disabled - Items are free to take once you have the right licence\nEnabled - In addition to needing the right licene, confiscated items must be bought back from quartermasters when recovering your items")
	ElseIf(option == LicBuyBackPriceDB)
		SetInfoText("Set a discount on the cost of buying back your confiscated stuff\nNote that anything less than 25% doesn't seem to work - Probably an overriding setting somewhere but I've tried modifying fBarterBuyMin & fBarterMin with no success")
	ElseIf(option == LicBountyMustBePaidOID)
		SetInfoText("Enabled - Your bounty must be clear in the hold before you'll be allowed to buy licences\nDisabled - Bounties don't matter")
	ElseIf(option == FolContraBlockOID)
		SetInfoText("Followers don't want any trouble and will return anything you give them that you don't have a licence for\nPossibly pretty hardcore. Disable if you like and followers will still be checked at the gates")
	ElseIf(option == FolContraKeysOID)
		SetInfoText("Followers won't carry any keys. Any keys. Don't think there's any point in filtering for devious keys only.\n'Followers Won't Carry Contraband' needs to be enabled")
	ElseIf(option == FolTakeClothesOID)
		SetInfoText("Followers may take your clothes if they end up naked during a confiscation event")
	ElseIf(option == OrdinSupressOID)
		SetInfoText("The magic curse will try to supress Ordinator perks that contradict the magic curse allowing you to cast magic while cursed\nPerks will be temporarily removed while the curse is active and should be added back afterwards\nPerks affected are: 'Intuitive Magic' (I & II) & 'Descending Light'")
	ElseIf(option == CurseTatsOID)
		SetInfoText("Curses come with a tattoo that visually identifies you as cursed")
	ElseIf(option == BikiniCurseAreaDB)
		SetInfoText("Which area of the body to apply the bikini curse overlay to. Allows the use of custom textures. The stock bikini curse texture is applied to the body\nBikini curse texture path: /Textures/SL Survival/bikini_curse_body.dds")
	ElseIf(option == MagicCurseAreaDB)
		SetInfoText("Which area of the body to apply the magic curse overlay to. Allows the use of custom textures. The stock magic curse texture is applied to the face\nMagic curse texture path: /Textures/SL Survival/magic_silence_collar.dds")
	ElseIf(option == SearchEscortsOID_T)
		SetInfoText("Run a search routine to automatically add escorts to the escort list\nThis will find any mod added followers and add them to the list\nDo this in a quiet cell as it is fairly heavy!")
	ElseIf(option == AddEscortToListOID_T)
		SetInfoText("Adds the current Npc under the crosshairs to your escort list. The Npc must be a member of the PotentialFollowerFaction. Won't work for hirelings like Jenassa. An escort will be assigned to you if caught by the enforcers in a town")
	ElseIf(option == RemoveEscortFromListOID_T)
		SetInfoText("Adds the current Npc under the crosshairs to your escort list. The Npc must be a member of the PotentialFollowerFaction. Won't work for hirelings like Jenassa. An escort will be assigned to you if caught by the enforcers in a town")
	ElseIf(option == ClearAllEscortsOID_T)
		SetInfoText("Clear all escorts from the mod and the Json file")
	ElseIf(option == ImportEscortsFromJsonOID_T)
		SetInfoText("Clear the escort list and re-add escorts from the Json file")
	ElseIf(option == LicGetEquipListOID_T)
		SetInfoText("Populate the equip list")
	ElseIf(option == LicEquipListDB)
		SetInfoText("A list of everything you're wearing. Use this to select an object to add/remove as an exception to licence and confiscation rules, then hit the button below\nYou must press 'Get Equipped Items' first!!")
	ElseIf(option == AddLicExceptionOID_T)
		SetInfoText("Add/Remove the currently selected object as an exception to the licence system. Excepted objects will not require a licence and will never be confiscated")
	ElseIf(option == LicFactionDiscountOID_S)
		SetInfoText("Gaining ranks in the various factions grants you a discount when buying licences based on your progress\nCompanions - Weapons, College - Magic, Imperials/Stormcloaks - Armor (Both bikini and normal)")
	ElseIf(option == DiscountCollegeOID_T)
		SetInfoText("Magic licence discount that increases based on your rank with the College Of Winterhold")
	ElseIf(option == DiscountCompanionsOID_T)
		SetInfoText("Weapon licence discount that increases based on your Companions rank")
	ElseIf(option == DiscountCwOID_T)
		SetInfoText("Armor licence discount that increases based on your rank with the Imperials/Stormcloaks\nNote that I had to 'make up' a couple of ranks so that each unique mission provides an increase. As a result, imperial/stormcloak ranks don't exactly match vanilla Skyrim ranks")
		
	ElseIf(option == EnforcersMinOID_S)
		SetInfoText("The minimum number of licence enforcers to find patrolling around small towns\nActual will be random between min and max and is randomized each time the town is loaded. Note that the town will need to be unloaded before being randomized again and unloading might not happen as often as you would think\nCertain towns may not have enough placed enforcers to cover max - Most towns have 4 max")
	ElseIf(option == EnforcersMaxOID_S)
		SetInfoText("The minimum number of licence enforcers to find patrolling around small towns\nActual will be random between min and max and is randomized each time the town is loaded. Note that the town will need to be unloaded before being randomized again and unloading might not happen as often as you would think\nCertain towns may not have enough placed enforcers to cover max - Most towns have 4 max")
	ElseIf(option == ResponsiveEnforcersOID)
		SetInfoText("Makes licence enforcers much more responsive to your presence. Probably too responsive for most people")
	ElseIf(option == PersistentEnforcersOID_S)
		SetInfoText("Persistent Enforcers will continue following you for this long after losing line of sight to give them some semblence of intelligence\nThey may follow you inside if this is set above zero. Best lose any pursuers before entering a house\nSet to zero to revert to the original dumber enforcers")
	ElseIf(option == EnforcerRespawnDurOID_S)
		SetInfoText("How long before licence enforcers in towns respawn\nCan not depend on Skyrim's built-in respawn flag as it relies on the cell being reset which is unlikely to happen in towns very often so this is done with a single update via script\nSet to zero to disable respawning via script")
		
	ElseIf(option == RestrictTradeOID)
		SetInfoText("Most law abiding traders won't trade items you don't have a licence for\nSome merchants don't care about licences\nYou can try to persuade them to trade forbidden items with you but at a hefty premium (+33% Buying prices, -33% selling prices)")
	ElseIf(option == TradeRestrictBribeOID_S)
		SetInfoText("This is how much it will cost you to bribe the merchant to trade forbidden items with you if you fail the speech check")
	ElseIf(option == TradeRestrictAddMerchantOID_T)
		SetInfoText("Set up the current Npc under the crosshairs as a trader\nYou can assign them a Slaverun region which will dictate if clothes trading is allowed when the clothes licence is set to Slaverun\nOr you can assign them as an exception which means they don't care about licences and will trade freely always\nMerchant statuses are saved to a json file and automatically imported on new games")
		
	ElseIf(option == TradeRestrictRemoveMerchantOID_T)
		SetInfoText("Reset a merchants assigned Slaverun region or exception status back to default")
	ElseIf(option == TradeRestrictResetAllMerchantsOID_T)
		SetInfoText("Reset all merchant assigned changes you've made. This will also reset the json file of saved merchant back to blank")

	ElseIf(option == LicShortDurOID_S)
		SetInfoText("How long in game days a short term licence will last for. Licence duration will only change when purchased - Changing this won't affect existing licences")
	ElseIf(option == LicLongDurOID_S)
		SetInfoText("How long in game days a long term licence will last for. Licence duration will only change when purchased - Changing this won't affect existing licences")
	ElseIf(option == LicWeapShortCostOID_S) || (option == LicMagicShortCostOID_S) || (option == LicArmorShortCostOID_S) || (option == LicBikiniShortCostOID_S) || (option == LicClothesShortCostOID_S) || Option == StorageUtil.GetIntValue(Self, "LicPropertyShortCostOID_S")
		SetInfoText("How much a short term licence of this type will cost")
	ElseIf(option == LicWeapLongCostOID_S) || (option == LicMagicLongCostOID_S) || (option == LicArmorLongCostOID_S) || (option == LicBikiniLongCostOID_S) || (option == LicClothesLongCostOID_S) || Option == StorageUtil.GetIntValue(Self, "LicPropertyLongCostOID_S")
		SetInfoText("How much a long term licence of this type will cost")
	ElseIf(option == LicWeapPerCostOID_S) || (option == LicMagicPerCostOID_S) || (option == LicArmorPerCostOID_S) || (option == LicBikiniPerCostOID_S) || (option == LicClothesPerCostOID_S) || Option == StorageUtil.GetIntValue(Self, "LicPropertyPerCostOID_S")
		SetInfoText("How much a perpetual term licence of this type will cost")
		
	ElseIf(option == LicBikiniEnableOID)
		SetInfoText("Enable bikini armor licences\nAn normal armor licence will cover bikini armors as well so there is no need to buy both")
	ElseIf(option == LicBikiniCurseEnableOID)
		SetInfoText("Enable/Disable the bikini curse. Only really intended to be disabled in emergencies if for some reason the curse is preventing progression")
	ElseIf(option == LicBikiniTriggerOID_T)
		SetInfoText("The Last item to trigger the bikini curse\nFor your information only - not a selectable option\nIf the item is boots: Is 'heels are required' enabled? Are the heels 'high' enough?")
	ElseIf(option == LicBikiniHeelsOID)
		SetInfoText("The bikini curse will require you to wear heels. Applies to both armor and clothing\nHeels are defined as anything that has the HDT heels magic effect or NiOverride heels offset")
	ElseIf(option == LicBikiniHeelHeightOID_S)
		SetInfoText("The minimum height your heels must be to satisfy the bikini curse\nThis only applies to NiO heels. Not HDT heels (a lot harder to get)\nObviously the units here are not 'in inches', so don't think that way")
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicBikiniArmorTestOID_T")
		SetInfoText("Test your currently equipped armor and heels as bikini armor\nThis will display what armor you're wearing and if they have the bikini keyword. This is a very simple test so if the keyword is missing then it's a problem with your setup. Use this if the bikini curse is triggering or your bikini armor is being confiscated even though you have a licence\nI recommend using the bikini keyword rather than SLAX flags because Bikini Experience buffs rely on a hard-coded keyword")
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicBikiniBreathChanceOID_S")
		SetInfoText("The chance of playing an out of breath animation when the bikini curse is active")
		
	ElseIf(option == LicMagicEnableOID)
		SetInfoText("Enable/Disable magic licences")
	ElseIf(option == LicMagicCursedDevicesOID)
		SetInfoText("If enabled the mod will first attempt to apply cursed devices to your character that drain her magicka\nIf disabled the mod will skip adding devices and instead apply a 'magic curse'. This is for people that don't want to be collared for not having a magic licence\nYou can disable this and leave 'Curses come with Tats' enabled and you'll get the tattoo but no devices. The downside is that there is no collar for you to 'cheat' your way out of the curse by unlocking the collar")
	ElseIf(option == LicMagicChainCollarsOID)
		SetInfoText("Allow physics chain collars to be selected for magic curse collars")
	ElseIf(option == LicClothesEnableDB)
		SetInfoText("Determine when clothes licences are required\Never - Never require a licence to have clothes\nAlways - Always require a licence to have clothes in every town\nSlaverun - Clothes licences only required in towns that are currently Slaverun enslaved\nNote that a clothes licence only allows you to carry clothes into slaverun towns. You still need to be naked")
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "PropertyLicenceEnableOID")
		SetInfoText("Enable/Disable the property licence. A property licence is required to buy vanilla homes (not hearthfires)\nLetting your licence expire or losing it will result in eviction from ALL your vanilla homes")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewLicenceEnableOID")
		SetInfoText("Women are not permitted to wander the streets after hours and should be indoors. When curfew comes into effect you'll be approached by a guard and told to clear the streets. In unwalled towns you'll be taken straight to the inn\nWomen caught breaking curfew will be punished. Continued infractions will mean you'll likely end up in the kennel (if the town has one nearby)\nBuy a curfew licence to be allowed outside at night. Or you can buy the cheaper whore licence instead.")
	
	ElseIf(option == MaxTatsBodyOID_S)
		SetInfoText("Max number of tattoos to apply to the players body\nWarning: There is currently no way to choose which body part rape tattoos are applied to\nSo If you've hit the limit of tattoos on the body but not the face then tattoos can still be applied to the body and vice versa")
	ElseIf(option == MaxTatsFaceOID_S)
		SetInfoText("Max number of tattoos to apply to the players face\nWarning: There is currently no way to choose which body part rape tattoos are applied to\nSo If you've hit the limit of tattoos on the body but not the face then tattoos can still be applied to the body and vice versa")
	ElseIf(option == MaxTatsHandsOID_S)
		SetInfoText("Max number of tattoos to apply to the players hands\nWarning: There is currently no way to choose which body part rape tattoos are applied to\nSo If you've hit the limit of tattoos on the body but not the face then tattoos can still be applied to the body and vice versa")
	ElseIf(option == MaxTatsFeetOID_S)
		SetInfoText("Max number of tattoos to apply to the players feet\nWarning: There is currently no way to choose which body part rape tattoos are applied to\nSo If you've hit the limit of tattoos on the body but not the face then tattoos can still be applied to the body and vice versa")
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugLactacidOID")
		SetInfoText("Enable/Disable the equipping of this type of drug. Certain drugs won't be equipped after reaching full effect (addiction etc)\nMME lactacid - Makes you a milk maid. Increases milk generation rate. Increases addiction in Milk Addict")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugSkoomaOID")
		SetInfoText("Enable/Disable the equipping of this type of drug. Certain drugs won't be equipped after reaching full effect (addiction etc)\nSkooma Whore drugs. Increases addiction")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugCumHumanOID")
		SetInfoText("Enable/Disable the equipping of this type of drug. Certain drugs won't be equipped after reaching full effect (addiction etc)\nHuman cum - Increases cum addiction")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugCumCreatureOID")
		SetInfoText("Enable/Disable the equipping of this type of drug. Certain drugs won't be equipped after reaching full effect (addiction etc)\nCreature cum - Increases cum addiction & creature corruption")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugInflateOID")
		SetInfoText("Enable/Disable the equipping of this type of drug. Certain drugs won't be equipped after reaching full effect (addiction etc)\nA delayed action potion that provides explosive growth to your character's curves for a day or two. Fades in time")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugFmFertilityOID")
		SetInfoText("Enable/Disable the equipping of this type of drug. Certain drugs won't be equipped after reaching full effect (addiction etc)\nFertility Mode fertility potion. Increases fertility which increases the risk of getting pregnant for some time")
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugSlenAphrodisiacOID")
		SetInfoText("Enable/Disable the equipping of this type of drug. Certain drugs won't be equipped after reaching full effect (addiction etc)\nSL Eager Npcs aphrodisiac potions. Increases the arousal of Npcs around you with possible consequences from arousal based mods like DEC/Aroused Creatures etc")

	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewRestartDelayOID_S")
		SetInfoText("The amount of time you're given between receiving your first warning to clear the streets and subsequent approaches\nThis only applies to walled cities! In unwalled towns you'll be sent straight to the inn on first approach")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewBeginOID_S")
		SetInfoText("The time that town curfew begins and you will not be allowed to wander the streets until curfew ends")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewEndOID_S")
		SetInfoText("The time that town curfew ends and you are allowed to be outside again")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewSlavetownBeginOID_S")
		SetInfoText("The time that town curfew begins for towns enslaved by Slaverun and you will not be allowed to wander the streets until curfew ends. Can be set the same as normal curfew if you wish")
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewSlavetownEndOID_S")
		SetInfoText("The time that town curfew ends for towns enslaved by Slaverun and you are allowed to be outside again. Can be set the same as normal curfew if you wish")

	; Stashes
	ElseIf(option == StashTrackEnOID)
		SetInfoText("Enable/Disable the stash tracking and stealing mechanics\nIf disabled then all current tracking data will be lost")
	ElseIf(option == StashAddRemoveExceptionOID_T)
		SetInfoText("Add or Remove a container from the stash tracking mechanics\nClick this, then open the target container and add an item to the container so the mod knows which container to add/remove\nExceptions are saved and automatically imported on new games")
	ElseIf(option == StashAddRemoveJsonExceptionsOID_T)
		SetInfoText("Remove all Json stash exceptions")
	ElseIf(option == StashAddRemoveTempExceptionsOID_T)
		SetInfoText("Remove all Temporary stash exceptions")
	ElseIf(option == StashAddRemoveAllExceptionsOID_T)
		SetInfoText("Removes all added stash exceptions.")
	ElseIf(option == ContTypeCountsOID)
		SetInfoText("Stash container types matter\nIf enabled only hunterborns 'hunters cache' provides the best chances of noone finding your stash\nIf disabled container type does not matter")
	ElseIf(option == RoadDistOID_S)
		SetInfoText("How far to the nearest road should be considered safe")
	ElseIf(option == StealXItemsOID_S)
		SetInfoText("Once NPCs discover your stash they will steal this many items each time they dip into your stash\nHow often they steal from you is determined by what type of location the container is in\nFrequency is highest in cities and lowest in the wilderness ")
	
	; Begging
	ElseIf(option == BeggingTOID)
		SetInfoText("Disable to globally disable the begging dialogue")
	ElseIf(option == BegSelfDegEnableOID)
		SetInfoText("Enable/Disable the self degradation mini job you can get from Npcs when begging for something")
	ElseIf(option == BegNumItemsOID_S)
		SetInfoText("How many items you're awarded with for successfully begging\nExcludes clothes")
	ElseIf(option == BegGoldOID_S)
		SetInfoText("Multiplies how much gold is given on successful beg actions")
	ElseIf(option == BegSexAggDB)
		SetInfoText("Begging sex is:\nAggressive/Not Aggressive - Self explanitory\nDon't care: Aggressive tag won't be filtered either way\nDF willpower fixed: High will (7-10) - Aggressive, Med will (4-6) - 50:50, Low will (0-3) - Unaggressive\nDF willpower % chance: % Chance of an unaggressive animation = (10 - Willpower)%\nFunction will fallback to not filtering the Aggressive tag if no animations were found")
	ElseIf(option == BegSexVictimDB)
		SetInfoText("Player is/is not a victim when using sex to beg - Being a victim counts as rape")
	ElseIf(option == BegMwaCurseChanceOID_S)
		SetInfoText("The chance for gifted boots/clothes to be cursed if Mortal Weapons and Armors is installed")

	ElseIf(option == KennelSafeCellCostOID_S)
		SetInfoText("How much the cell in the kennel costs per night\nDon't forget to lock the door")
	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSuitsOID")
		SetInfoText("Enable/Disable the adding of suits when entering the kennel (hobbleskirts, pet suits, strait jackets etc)\nSuits can cause some oddness when animations are filtered and changed during sex")
	ElseIf(option == KennelCreatureChanceOID_S)
		SetInfoText("This is the chance to be raped by a creature rather than the kennel keeper\nNote that the first time is always the kennel keeper as it's an introduction of sorts")
	ElseIf(option == KennelRapeChancePerHourOID_S)
		SetInfoText("Your chance of being raped per hour when sleeping outside of the cell\nYou chance of being raped increase by 5% per hour successfully slept and resets to this value on rape")
	ElseIf(option == KennelSlaveRapeTimeMinOID_S) || (option == KennelSlaveRapeTimeMaxOID_S)
		SetInfoText("Time in seconds between creatures raping the unfortunate women in the Whiterun kennel\nActual will be random between min and max\nSet Minimum to -1 to disable")

	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMinOID_S")
		SetInfoText("The minimum number of devious devices to equip on kennel slaves. Min 0, Max 10.\nAdding a lot of devices devices can cause some lag when entering the kennel on potato based PCs")
	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMaxOID_S")
		SetInfoText("The maximum number of devious devices to equip on kennel slaves. Min 0, Max 10.\nAdding a lot of devices devices can cause some lag when entering the kennel on potato based PCs")
	ElseIf(option == KennelExtraDevicesOID)
		SetInfoText("Each time you are 'visited' by the kennel keeper he will add another devious device. These added extras are not removed when you leave the kennel and are considered as part of the price for admission to the kennel")
	ElseIf(option == KennelFollowerToggleOID)
		SetInfoText("If enabled, when you enter the kennel your follower will be disgusted and leave\nIf disabled they will follow you inside the kennel - Note that there is no follower handling (sex) from this mod\nLeave enabled if you consider your follower to be of the dominant type")
	ElseIf(option == KennelSexAggDB)
		SetInfoText("Sex in the kennel is:\nAggressive/Not Aggressive - Self explanitory\nDon't care: Aggressive tag won't be filtered either way\nDF willpower fixed: High will (7-10) - Aggressive, Med will (4-6) - 50:50, Low will (0-3) - Unaggressive\nDF willpower % chance: % Chance of an unaggressive animation = (10 - Willpower)%\nFunction will fallback to not filtering the Aggressive tag if no animations were found")
	ElseIf(option == KennelSexVictimDB)
		SetInfoText("Player is/is not a victim during sex in the kennel - Being a victim counts as rape")

	; Bikini Armors
	ElseIf option == BikiniExpOID
		SetInfoText("Gain experience the more you wear bikini armor and don't wear full armor. As you gain 'bikini levels' bikini armors will provide more armor and you'll be faster and have more stamina when wearing them. Conversely, the higher your bikini level the less armor normal, full armors will provide.")
	ElseIf option == BikiniExpPerLevelOID_S
		SetInfoText("The base amount of experience needed (in game hours if training speed is 1.0) to level up your bikini skill\nLevel 1 = 1.0 x Base, Level 2 = 1.0 x Base, Level 3 = 1.5 x Base, Level 4 = 2.0 x Base")
	ElseIf option == BikiniExpReflexesOID
		SetInfoText("Your heightened bikini armor reflexes allow you to turn normal hits into 'grazes'\nAs your bikini skill increases you have an increasing chance to avoid a greater portion of the damage from normal attacks (not power attacks) and spells that do fire/frost/shock damage")
	ElseIf option == BikiniExpTrainOID_S
		SetInfoText("Modifies how quickly you will train your bikini armor skill. Bigger values decrease training time")
	ElseIf option == BikiniExpUntrainOID_S
		SetInfoText("Modifies how quickly you will untrain your bikini armor skill. Bigger values decrease training time\nAt default settings it'll take twice as long to untrain your bikini skill")
	ElseIf option == BikiniBuildListOID_T
		SetInfoText("Press this button to begin building the bikini leveled lists and distribute bikinis at traders and chests throughout Skyrim\nNote that this is not done automatically on new games etc. You need to do it manually\nChanges to any settings here will not be applied until you build the leveled lists with this button!")
	ElseIf option == BikiniClearListOID_T
		SetInfoText("Want to remove bikinis from containers and vendors? Hit this button\nWon't remove stuff that's already been added")
	ElseIf option == BikiniDropsVendorCityOID_S || option == BikiniDropsVendorTownOID_S || option == BikiniDropsVendorKhajiitOID_S || option == BikiniDropsChestOID_S || option == BikiniDropsChestOrnateOID_S 
		SetInfoText("How many drops will be added to this container/vendor. If 'chance of none' is greater than zero then nothing might drop for 1 drop\nChanges to any settings here will not be applied until you build the leveled lists!!!")
	
	ElseIf option == BikiniChanceNoneOID_S || option == BikiniChanceHideOID_S || option == BikiniChanceLeatherOID_S || option == BikiniChanceIronOID_S || option == BikiniChanceSteelOID_S || option == BikiniChanceSteelPlateOID_S || option == BikiniChanceDwarvenOID_S || option == BikiniChanceFalmerOID_S || option == BikiniChanceWolfOID_S || option == BikiniChanceBladesOID_S || option == BikiniChanceEbonyOID_S  || option == BikiniChanceDragonboneOID_S 
		SetInfoText("The chance of this item dropping for each count of the number of drops for a particular container/vendor\nIf chance of none is equal to zero then you'll have to reduce the chance of something dropping before you can increase the chance of another thing dropping\nIE. All chances added together must add up to 100\nChanges to any settings here will not be applied until you build the leveled lists!!!")
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "SetInnPricesOID")
		SetInfoText("Allow SLS to start setting the room costs at inns. Most people probably already have an inn price mod so this is disabled by default\nYou can still set the values when disabled. This allows SLS to determine if you can afford the inn at/near your location for curfew purposes")
	
	ElseIf option == TollDodgedWhiterunOID_T || option == TollDodgedSolitudeOID_T || option == TollDodgedMarkarthOID_T || option == TollDodgedWindhelmOID_T || option == TollDodgedRiftenOID_T
		SetInfoText("Whether or not you've skipped out on the toll in this town. If true the guards will be looking for you on your return\nThere are too many mods that teleport you out of town through no fault of your own. If that's the case then click the town name to toggle your evasion status\nEvaded status will only be true after the grace period has expired")
	EndIf
EndEvent

Event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	If Option == AllInOneKeyOID
		If conflictControl != ""
			If ShowMessage("Key is already bound to: " + conflictControl + "\nAre you sure you want to bind it?\nIt won't overwrite the control")
				SetKeyMapOptionValue(AllInOneKeyOID, keyCode)
				AllInOne.SetKey(keyCode)
			EndIf
		
		Else
			SetKeyMapOptionValue(Option, keyCode)
			AllInOne.SetKey(keyCode)
		EndIf
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "OpenMouthKey")
		If conflictControl != ""
			If ShowMessage("Key is already bound to: " + conflictControl + "\nAre you sure you want to bind it?\nIt won't overwrite the control")
				SetKeyMapOptionValue(Option, keyCode)
				CumSwallow.SetOpenMouthKey(KeyCode)
			EndIf
		
		Else
			SetKeyMapOptionValue(Option, keyCode)
			CumSwallow.SetOpenMouthKey(KeyCode)
		EndIf
	EndIf
	
	;/
	If option == CumAddictKeyOID
		If conflictControl != ""
			If ShowMessage("Key is already bound to: " + conflictControl + "\nAre you sure you want to bind it?\nIt won't overwrite the control")
				SetKeyMapOptionValue(CumAddictKeyOID, keyCode)
				CumAddict.SetNotifyKey(keyCode)
			EndIf
		
		Else
			SetKeyMapOptionValue(CumAddictKeyOID, keyCode)
			CumAddict.SetNotifyKey(keyCode)
		EndIf
		
	ElseIf option == CoverMyselfKeyOID
		If conflictControl != ""
			If ShowMessage("Key is already bound to: " + conflictControl + "\nAre you sure you want to bind it?\nIt won't overwrite the control")
				SetKeyMapOptionValue(CoverMyselfKeyOID, keyCode)
				CoverMyselfKey = keyCode
				CoverMyself.ChangeCoverKey(keyCode)
			EndIf
		
		Else
			SetKeyMapOptionValue(CoverMyselfKeyOID, keyCode)
			CoverMyselfKey = keyCode
			CoverMyself.ChangeCoverKey(keyCode)
		EndIf
		
	ElseIf option == OpenMouthKeyOID
		If conflictControl != ""
			If ShowMessage("Key is already bound to: " + conflictControl + "\nAre you sure you want to bind it?\nIt won't overwrite the control")
				SetKeyMapOptionValue(OpenMouthKeyOID, keyCode)
				OpenMouthKey = keyCode
				CumSwallow.SetOpenMouthKey()
			EndIf
		
		Else
			SetKeyMapOptionValue(OpenMouthKeyOID, keyCode)
			OpenMouthKey = keyCode
			CumSwallow.SetOpenMouthKey()
		EndIf
	EndIf
	/;
EndEvent

Event OnOptionMenuOpen(int option)
	If (option == PushEventsDB)
		SetMenuDialogStartIndex(PushEvents)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(PushEventsType)
	ElseIf (option == CompassHideMethodDB)
		SetMenuDialogStartIndex(CompassHideMethod)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(CompassHideMethods)
	ElseIf (option == ProxSpankNpcDB)
		SetMenuDialogStartIndex(ProxSpankNpcType)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(ProxSpankNpcList)
	ElseIf (option == ProxSpankCoverDB)
		SetMenuDialogStartIndex(_SLS_ProxSpankRequiredCover.GetValueInt())
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(ProxSpankRequiredCoverList)
		
	ElseIf (option == CumAddictAutoSuckStageDB)
		SetMenuDialogStartIndex(CumHungerAutoSuck)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(CumHungerStrings)
		
	ElseIf (option == DismembermentsDB)
		SetMenuDialogStartIndex(AmpType)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(AmputationTypes)
	ElseIf (option == DismemberProgressionDB)
		SetMenuDialogStartIndex(AmpDepth)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(AmputationDepth)
	ElseIf (option == DismemberWeaponsDB)
		SetMenuDialogStartIndex(DismemberWeapon)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(DismemberWeapons)
	ElseIf (option == DismemberDepthMaxArmsDB)
		SetMenuDialogStartIndex(MaxAmpDepthArms)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(MaxAmputationDepthArms)
	ElseIf (option == DismemberDepthMaxLegsDB)
		SetMenuDialogStartIndex(MaxAmpDepthLegs)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(MaxAmputationDepthLegs)
		
	ElseIf (option == LicenceStyleDB)
		SetMenuDialogStartIndex(LicUtil.LicenceStyle)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(LicenceStyleList)
	ElseIf (option == FollowerLicStyleDB)
		SetMenuDialogStartIndex(LicUtil.FollowerLicStyle)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(FollowerLicStyles)
	ElseIf (option == LicBuyBackPriceDB)
		SetMenuDialogStartIndex(BuyBackPrice)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(BuyBackPrices)
	ElseIf (option == LicEquipListDB)
		SetMenuDialogStartIndex(SelectedEquip)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(EquipSlotStrings)	
	ElseIf (option == LicClothesEnableDB)
		SetMenuDialogStartIndex(LicUtil.LicClothesEnable)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(ClothesLicenceMethod)
	ElseIf (option == BikiniCurseAreaDB)
		SetMenuDialogStartIndex(BikiniCurseArea)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(OverlayAreas)
	ElseIf (option == MagicCurseAreaDB)
		SetMenuDialogStartIndex(MagicCurseArea)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(OverlayAreas)
		
	ElseIf option == StorageUtil.GetIntValue(Self, "FreedomLicenceEnableDB")
		SetMenuDialogStartIndex(LicUtil.LicFreedomEnable)
		SetMenuDialogDefaultIndex(2)
		SetMenuDialogOptions(ClothesLicenceMethod)
		
	ElseIf (option == SexExpCorruptionDB)
		SetMenuDialogStartIndex(SexExpCorruption)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(SexExpCreatureCorruption)
		
	ElseIf (option == DevEffLockpickDiffDB)
		SetMenuDialogStartIndex(DevEffLockpickDiff)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(HeavyBondageDifficulty)
	ElseIf (option == DevEffPickpocketDiffDB)
		SetMenuDialogStartIndex(DevEffPickpocketDiff)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(HeavyBondageDifficulty)
		
	ElseIf (option == TollSexAggDB)
		SetMenuDialogStartIndex(TollSexAgg)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(SexAggressiveness)
	ElseIf (option == TollSexVictimDB)
		SetMenuDialogStartIndex(TollSexVictim)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(SexPlayerIsVictim)
		
	ElseIf (option == BegSexAggDB)
		SetMenuDialogStartIndex(BegSexAgg)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(SexAggressiveness)
	ElseIf (option == BegSexVictimDB)
		SetMenuDialogStartIndex(BegSexVictim)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(SexPlayerIsVictim)
	ElseIf (option == KennelSexAggDB)
		SetMenuDialogStartIndex(KennelSexAgg)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(SexAggressiveness)
	ElseIf (option == KennelSexVictimDB)
		SetMenuDialogStartIndex(KennelSexVictim)
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(SexPlayerIsVictim)
	EndIf
EndEvent

Event OnOptionMenuAccept(int option, int index)
	If (option == PushEventsDB)
		PushEvents = index
		SetMenuOptionValue(option, PushEventsType[PushEvents])
		DoTogglePushEvents = true
	ElseIf (option == CompassHideMethodDB)
		CompassHideMethod = index
		SetMenuOptionValue(option, CompassHideMethods[CompassHideMethod])
		MapAndCompass.ResetCompass()
	ElseIf (option == ProxSpankNpcDB)
		ProxSpankNpcType = index
		SetMenuOptionValue(option, ProxSpankNpcList[ProxSpankNpcType])
		DoToggleProxSpank = true
		;ForcePageReset()
	ElseIf (option == ProxSpankCoverDB)
		_SLS_ProxSpankRequiredCover.SetValueInt(index)
		SetMenuOptionValue(option, ProxSpankRequiredCoverList[_SLS_ProxSpankRequiredCover.GetValueInt()])
		
	ElseIf (option == CumAddictAutoSuckStageDB)
		CumHungerAutoSuck = index
		SetMenuOptionValue(option, CumHungerStrings[CumHungerAutoSuck])
		CumAddict.SetAutoSuckBeginStage()
		
	ElseIf (option == DismembermentsDB)
		If Game.GetModByName("Amputator.esm") != 255
			AmpType = index
			SetMenuOptionValue(option, AmputationTypes[AmpType])
			ToggleDismemberment()
		
		Else
			Debug.Messagebox("Amputator framework is not installed")
		EndIf
	ElseIf (option == DismemberProgressionDB)
		AmpDepth = index
		SetMenuOptionValue(option, AmputationDepth[AmpDepth])
	ElseIf (option == DismemberWeaponsDB)
		DismemberWeapon = index
		SetMenuOptionValue(option, DismemberWeapons[DismemberWeapon])
	ElseIf (option == DismemberDepthMaxArmsDB)
		Amputation.CheckAvailabilty()
		MaxAmpDepthArms = index
		SetMenuOptionValue(option, MaxAmputationDepthArms[MaxAmpDepthArms])
	ElseIf (option == DismemberDepthMaxLegsDB)
		Amputation.CheckAvailabilty()
		MaxAmpDepthLegs = index
		SetMenuOptionValue(option, MaxAmputationDepthLegs[MaxAmpDepthLegs])

	ElseIf (option == LicenceStyleDB)
		If ShowMessage("Warning: Changing licence style when you have already unlocked licences in the 'Thaneship' styles will reset and lock all licences again. If style is 'Choice' you'll need to choose your licences at a quartermaster again. If style is 'Random' then random licences will be unlocked\n\nAre you sure you want to change style?")
			LicUtil.LicenceStyle = index
			SetMenuOptionValue(option, LicenceStyleList[LicUtil.LicenceStyle])
			DoToggleLicenceStyle = true
		EndIf
	ElseIf (option == FollowerLicStyleDB)
		LicUtil.FollowerLicStyle = index
		SetMenuOptionValue(option, FollowerLicStyles[LicUtil.FollowerLicStyle])
	ElseIf (option == LicBuyBackPriceDB)
		BuyBackPrice = index
		SetMenuOptionValue(option, BuyBackPrices[BuyBackPrice])
	ElseIf (option == LicEquipListDB)
		SelectedEquip = index
		SetMenuOptionValue(option, EquipSlotStrings[SelectedEquip])
		SetTextOptionValue(AddLicExceptionOID_T, EquipSlotStrings[SelectedEquip])
	ElseIf (option == LicClothesEnableDB)
		LicUtil.LicClothesEnable = index
		LicenceToggleToggled()
		SetMenuOptionValue(option, ClothesLicenceMethod[LicUtil.LicClothesEnable])
	ElseIf (option == BikiniCurseAreaDB)
		RefreshBikiniCurseOverlay(index)
		BikiniCurseArea = index
		SetMenuOptionValue(option, OverlayAreas[BikiniCurseArea])
	ElseIf (option == MagicCurseAreaDB)
		RefreshMagicCurseOverlay(index)
		MagicCurseArea = index
		SetMenuOptionValue(option, OverlayAreas[MagicCurseArea])
		
	ElseIf option == StorageUtil.GetIntValue(Self, "FreedomLicenceEnableDB")
		LicUtil.LicFreedomEnable = index
		SetMenuOptionValue(option, ClothesLicenceMethod[LicUtil.LicFreedomEnable])
		LicenceToggleToggled()
		
	ElseIf (option == SexExpCorruptionDB)
		SexExpCorruption = index
		SetMenuOptionValue(option, SexExpCreatureCorruption[SexExpCorruption])

	ElseIf (option == DevEffLockpickDiffDB)
		DevEffLockpickDiff = index
		SetMenuOptionValue(option, HeavyBondageDifficulty[DevEffLockpickDiff])
		DoDeviousEffectsChange = true
	ElseIf (option == DevEffPickpocketDiffDB)
		DevEffPickpocketDiff = index
		SetMenuOptionValue(option, HeavyBondageDifficulty[DevEffPickpocketDiff])
		DoDeviousEffectsChange = true
		
	ElseIf (option == TollSexAggDB)
		TollSexAgg = index
		SetMenuOptionValue(option, SexAggressiveness[TollSexAgg])
	ElseIf (option == TollSexVictimDB)
		TollSexVictim = index
		SetMenuOptionValue(option, SexPlayerIsVictim[TollSexVictim])
		
	ElseIf (option == BegSexAggDB)
		BegSexAgg = index
		SetMenuOptionValue(option, SexAggressiveness[BegSexAgg])
	ElseIf (option == BegSexVictimDB)
		BegSexVictim = index
		SetMenuOptionValue(option, SexPlayerIsVictim[BegSexVictim])
	ElseIf (option == KennelSexAggDB)
		KennelSexAgg = index
		SetMenuOptionValue(option, SexAggressiveness[KennelSexAgg])
	ElseIf (option == KennelSexVictimDB)
		KennelSexVictim = index
		SetMenuOptionValue(option, SexPlayerIsVictim[KennelSexVictim])
	EndIf
	ForcePageReset()
EndEvent

Event OnOptionSelect(int option)
	If (option == ImportSettingsOID_T)
		LoadSettings()
	ElseIf (option == ExportSettingsOID_T)
		SaveSettings()
	ElseIf (option == FollowersStealGoldOID)
		FollowersStealGold = !FollowersStealGold
		SetToggleOptionValue(FollowersStealGoldOID, FollowersStealGold)
		Main.FilterGold(FollowersStealGold)
	ElseIf (option == SlaverunAutoStartOID)
		SlaverunAutoStart = !SlaverunAutoStart
		SetToggleOptionValue(SlaverunAutoStartOID, SlaverunAutoStart)
		DoSlaverunInitOnClose = true
		ForcePageReset()
	ElseIf (option == CoverMyselfMechanicsOID)
		CoverMyselfMechanics = !CoverMyselfMechanics
		SetToggleOptionValue(CoverMyselfMechanicsOID, CoverMyselfMechanics)
		;/
		If CoverMyselfMechanics
			If !IsCoverAnimationInstalled()
				CoverMyselfMechanics = false
				Debug.Messagebox("Cover mechanics can not be enabled because the cover animation was not found. Cursed Loot needs to be installed but doesn't need to be active")
			EndIf
		EndIf
		/;
		DoToggleCoverMechanics = true
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "NpcCommentsOID")
		If (Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).GetValueInt() == 0 ; _SLS_NpcComments
			(Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).SetValueInt(1)
		Else
			(Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).SetValueInt(0)
		EndIf
		SetToggleOptionValue(Option, (Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).GetValueInt())
		StorageUtil.SetIntValue(Self, "DoToggleNpcComments", 1)
	ElseIf (option == AssSlappingOID)
		AssSlappingEvents = !AssSlappingEvents
		SetToggleOptionValue(AssSlappingOID, AssSlappingEvents)
		ToggleAssSlapping()
	ElseIf (option == ProxSpankCommentOID)
		Util.ProxSpankComment = !Util.ProxSpankComment
		SetToggleOptionValue(ProxSpankCommentOID, Util.ProxSpankComment)
	ElseIf (option == EasyBedTrapsOID)
		EasyBedTraps = !EasyBedTraps
		SetToggleOptionValue(EasyBedTrapsOID, EasyBedTraps)
	ElseIf (option == CumBreathOID)
		CumBreath = !CumBreath
		SetToggleOptionValue(CumBreathOID, CumBreath)
	ElseIf (option == CumBreathNotifyOID)
		CumBreathNotify = !CumBreathNotify
		SetToggleOptionValue(CumBreathNotifyOID, CumBreathNotify)
	ElseIf (option == HardcoreModeOID)
		If !HardcoreMode
			If ShowMessage("Are you sure you want to enable hardcore mode?\nMany options will be disabled in hardcore mode and you can not disable hardcore mode unless you have enough gold")
				TryHardcoreToggle()
			EndIf
			
		Else
			TryHardcoreToggle()
		EndIf
		ForcePageReset()
		;Debug.Messagebox("IsHardcoreLocked: " + IsHardcoreLocked)
		
	ElseIf (option == DebugModeOID)
		Init.DebugMode = !Init.DebugMode
		SetToggleOptionValue(DebugModeOID, Init.DebugMode)
		ToggleDebugMode()
	ElseIf (option == MinAvToggleOID)
		MinAvToggleT = !MinAvToggleT
		SetToggleOptionValue(MinAvToggleOID, MinAvToggleT)
		ToggleMinAV()
	ElseIf (option == HalfNakedEnableOID)
		HalfNakedEnable = !HalfNakedEnable
		SetToggleOptionValue(HalfNakedEnableOID, HalfNakedEnable)
		DoToggleHalfNakedCover = true
		ForcePageReset()
		
	ElseIf (option == HalfNakedStripsOID)
		HalfNakedStrips = !HalfNakedStrips
		SetToggleOptionValue(HalfNakedStripsOID, HalfNakedStrips)
		ForcePageReset()
		ToggleHalfNakedStrips()
		
	ElseIf (option == SexExpEnableOID)
		SexExpEn = !SexExpEn
		If SexExpEn
			If !Init.SlsoInstalled
				Debug.Messagebox("Sexlab Separate Orgasms needs to be installed to enable Sex Experience")
				SexExpEn = false
			EndIf
		EndIf
		SetToggleOptionValue(SexExpEnableOID, SexExpEn)
		DoToggleSexExp = true
		ForcePageReset()
	ElseIf (option == DremoraCorruptionOID)
		DremoraCorruption = !DremoraCorruption
		SetToggleOptionValue(DremoraCorruptionOID, DremoraCorruption)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugLactacidOID")
		ForceDrug.RapeDrugLactacid = !ForceDrug.RapeDrugLactacid
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "RapeDrugLactacidOID"), ForceDrug.RapeDrugLactacid)
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugSkoomaOID")
		ForceDrug.RapeDrugSkooma = !ForceDrug.RapeDrugSkooma
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "RapeDrugSkoomaOID"), ForceDrug.RapeDrugSkooma)
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugCumHumanOID")
		ForceDrug.RapeDrugHumanCum = !ForceDrug.RapeDrugHumanCum
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "RapeDrugCumHumanOID"), ForceDrug.RapeDrugHumanCum)
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugCumCreatureOID")
		ForceDrug.RapeDrugCreatureCum = !ForceDrug.RapeDrugCreatureCum
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "RapeDrugCumCreatureOID"), ForceDrug.RapeDrugCreatureCum)
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugInflateOID")
		ForceDrug.RapeDrugInflate = !ForceDrug.RapeDrugInflate
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "RapeDrugInflateOID"), ForceDrug.RapeDrugInflate)
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugFmFertilityOID")
		ForceDrug.RapeDrugFmFertility = !ForceDrug.RapeDrugFmFertility
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "RapeDrugFmFertilityOID"), ForceDrug.RapeDrugFmFertility)
	ElseIf Option == StorageUtil.GetIntValue(Self, "RapeDrugSlenAphrodisiacOID")
		ForceDrug.RapeDrugSlenAphrodisiac = !ForceDrug.RapeDrugSlenAphrodisiac
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "RapeDrugSlenAphrodisiacOID"), ForceDrug.RapeDrugSlenAphrodisiac)

	ElseIf (option == SexExpResetStatsOID_T)
		If ShowMessage("Are you sure you want to reset all your SLS sex stats back to zero?")
			ResetSexExpStats()
		EndIf
	ElseIf (option == SexMinStamMagRatesOID)
		SexMinStamMagRates = !SexMinStamMagRates
		SetToggleOptionValue(SexMinStamMagRatesOID, SexMinStamMagRates)
		ForcePageReset()
	ElseIf (option == SexRapeDrainsAttributesOID)
		RapeDrainsAttributes = !RapeDrainsAttributes
		SetToggleOptionValue(SexRapeDrainsAttributesOID, RapeDrainsAttributes)
		
	ElseIf (option == IneqStatsOID)
		If _SLS_IneqStat.GetValueInt() == 0
			_SLS_IneqStat.SetValueInt(1)
		Else
			_SLS_IneqStat.SetValueInt(0)
		EndIf
		SetToggleOptionValue(IneqStatsOID, _SLS_IneqStat.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf (option == IneqCarryOID)
		If _SLS_IneqCarry.GetValueInt() == 0
			_SLS_IneqCarry.SetValueInt(1)
		Else
			_SLS_IneqCarry.SetValueInt(0)
		EndIf
		SetToggleOptionValue(IneqCarryOID, _SLS_IneqCarry.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf (option == InqSpeedOID)
		If _SLS_IneqSpeed.GetValueInt() == 0
			_SLS_IneqSpeed.SetValueInt(1)
		Else
			_SLS_IneqSpeed.SetValueInt(0)
		EndIf
		SetToggleOptionValue(InqSpeedOID, _SLS_IneqSpeed.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf (option == IneqDamageOID)
		If _SLS_IneqDamage.GetValueInt() == 0
			_SLS_IneqDamage.SetValueInt(1)
		Else
			_SLS_IneqDamage.SetValueInt(0)
		EndIf
		SetToggleOptionValue(IneqDamageOID, _SLS_IneqDamage.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf (option == IneqDestOID)
		If _SLS_IneqDestruction.GetValueInt() == 0
			_SLS_IneqDestruction.SetValueInt(1)
		Else
			_SLS_IneqDestruction.SetValueInt(0)
		EndIf
		SetToggleOptionValue(IneqDestOID, _SLS_IneqDestruction.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf (option == IneqSkillsOID)
		InequalitySkills = !InequalitySkills
		ToggleIneqSkills()
		SetToggleOptionValue(IneqSkillsOID, InequalitySkills)
	ElseIf (option == IneqBuySellOID)
		InequalityBuySell = !InequalityBuySell
		ToggleIneqBuySell()
		SetToggleOptionValue(IneqBuySellOID, InequalityBuySell)
	ElseIf (option == IneqStrongFemaleFollowersOID)
		IneqStrongFemaleFollowers = !IneqStrongFemaleFollowers
		SetToggleOptionValue(IneqStrongFemaleFollowersOID, IneqStrongFemaleFollowers)
		DoToggleIneqStrongFemaleFollowers = true
	ElseIf (option == ModStrongFemaleOID_T)
		SetStrongFemale()
		ForcePageReset()
	ElseIf (option == LicShowApiBlockFormsOID_T)
		LicShowApiBlockForms()
	ElseIf (option == LicClearApiBlockFormsOID_T)
		SetTextOptionValue(LicClearApiBlockFormsOID_T, "Clearing...")
		LicClearApiBlockForms()
		SetTextOptionValue(LicClearApiBlockFormsOID_T, "Done! ")
		
	ElseIf (option == PpLootEnableOID)
		PpLootEnable = !PpLootEnable
		SetToggleOptionValue(PpLootEnableOID, PpLootEnable)
		TogglePpLoot()

	ElseIf Option == StorageUtil.GetIntValue(Self, "AmpBlockMagicOID")
		Amputation.BlockMagic = !Amputation.BlockMagic
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "AmpBlockMagicOID"), Amputation.BlockMagic)
	ElseIf (option == DismemberTrollCumOID)
		DismemberTrollCum = !DismemberTrollCum
		SetToggleOptionValue(DismemberTrollCumOID, DismemberTrollCum)
	ElseIf (option == DismemberBathingOID)
		DismemberBathing = !DismemberBathing
		SetToggleOptionValue(DismemberBathingOID, DismemberBathing)
	ElseIf (option == DismemberPlayerSayOID)
		DismemberPlayerSay = !DismemberPlayerSay
		SetToggleOptionValue(DismemberPlayerSayOID, DismemberPlayerSay)
	ElseIf (option == CumSwallowInflateOID)
		CumSwallowInflate = !CumSwallowInflate
		SetToggleOptionValue(CumSwallowInflateOID, CumSwallowInflate)
		ForcePageReset()
	ElseIf (option == CumEffectsEnableOID)
		CumEffectsEnable = !CumEffectsEnable
		SetToggleOptionValue(CumEffectsEnableOID, CumEffectsEnable)
		DoToggleCumEffects = true
		ForcePageReset()
	ElseIf (option == CumEffectsStackOID)
		CumEffectsStack = !CumEffectsStack
		SetToggleOptionValue(CumEffectsStackOID, CumEffectsStack)
	ElseIf (option == SuccubusCumSwallowEnergyPerRankOID)
		SuccubusCumSwallowEnergyPerRank = !SuccubusCumSwallowEnergyPerRank
		SetToggleOptionValue(SuccubusCumSwallowEnergyPerRankOID, SuccubusCumSwallowEnergyPerRank)
	ElseIf (option == MilkDecCumBreathOID)
		MilkDecCumBreath = !MilkDecCumBreath
		SetToggleOptionValue(MilkDecCumBreathOID, MilkDecCumBreath)
	ElseIf (option == CumAddictEnOID)
		CumAddictEn = !CumAddictEn
		SetToggleOptionValue(CumAddictEnOID, CumAddictEn)
		DoToggleCumAddiction = true
		ForcePageReset()
	ElseIf (option == CumAddictClampHungerOID)
		CumAddictClampHunger = !CumAddictClampHunger
		SetToggleOptionValue(CumAddictClampHungerOID, CumAddictClampHunger)
		CumAddict.DoUpdate()
	ElseIf (option == CumAddictBeastLevelsOID)
		CumAddictBeastLevels = !CumAddictBeastLevels
		SetToggleOptionValue(CumAddictBeastLevelsOID, CumAddictBeastLevels)
		CumAddict.LoadNewHungerThresholds()
		CumAddict.DoUpdate()
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictBlockDecayOID")
		CumAddict.CumBlocksAddictionDecay = !CumAddict.CumBlocksAddictionDecay
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CumAddictBlockDecayOID"), CumAddict.CumBlocksAddictionDecay)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamOID")
		StorageUtil.SetIntValue(Self, "CumAddictDayDream", (!StorageUtil.GetIntValue(Self, "CumAddictDayDream", Missing = 1) as Bool) as Int)
		StorageUtil.SetIntValue(Self, "DoToggleDaydream", 1)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CumAddictDayDreamOID"), StorageUtil.GetIntValue(Self, "CumAddictDayDream", Missing = 1))
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflysOID")
		StorageUtil.SetIntValue(Self, "CumAddictDayDreamButterflys", (!StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflys", Missing = 1) as Bool) as Int)
		StorageUtil.SetIntValue(Self, "DoToggleDaydreamButterflys", 1)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflysOID"), StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflys", Missing = 1))
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictAutoSuckVictim")
		CumAddict.AutoSuckVictim = !CumAddict.AutoSuckVictim
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CumAddictAutoSuckVictim"), CumAddict.AutoSuckVictim)

	ElseIf (option == CumLactacidAllOID)
		CumLactacidAll = !CumLactacidAll
		SetToggleOptionValue(CumLactacidAllOID, CumLactacidAll)
		ToggleCumAsLactacid(Voice = None)
		ForcePageReset()
	ElseIf (option == CumLactacidCustomOID_T)
		ToggleCumAsLactacidCustom()
		ForcePageReset()
	ElseIf (option == CumLactacidAllPlayableOID)
		CumLactacidAllPlayable = !CumLactacidAllPlayable
		SetToggleOptionValue(CumLactacidAllPlayableOID, CumLactacidAllPlayable)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidBearOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(0) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidChaurusOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(1) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDeerOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(2) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDogOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(3) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDragonPriestOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(4) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDragonOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(5) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDraugrOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(6) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDremoraOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(7) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDwarvenCenturionOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(8) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDwarvenSphereOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(9) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidDwarvenSpiderOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(10) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidFalmerOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(11) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidFoxOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(12) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidSpiderOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(13) as VoiceType)
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(14) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidGiantOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(15) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidGoatOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(16) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidHorkerOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(17) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidHorseOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(18) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidMammothOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(19) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidSabrecatOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(20) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidSkeeverOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(21) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidSprigganOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(22) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidTrollOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(23) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidWerewolfOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(24) as VoiceType)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumLactacidWolfOID")
		ToggleCumAsLactacid(_SLS_CumLactacidVoicesList.GetAt(25) as VoiceType)
		
	ElseIf (option == FfRescueEventsOID)
		FfRescueEvents = !FfRescueEvents
		SetToggleOptionValue(FfRescueEventsOID, FfRescueEvents)
		ForcePageReset()
		
	ElseIf (option == PpSleepNpcPerkOID)
		PpSleepNpcPerk = !PpSleepNpcPerk
		SetToggleOptionValue(PpSleepNpcPerkOID, PpSleepNpcPerk)
		TogglePpSleepNpcPerk()
	ElseIf (option == PpFailHandleOID)
		PpFailHandle = !PpFailHandle
		SetToggleOptionValue(PpFailHandleOID, PpFailHandle)
		DoTogglePpFailHandle = true
	ElseIf (option == NormalKnockDialogOID)
		Init.SKdialog = !Init.SKdialog
		SetToggleOptionValue(NormalKnockDialogOID, Init.SKdialog)

	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaEnableOID")
		Trauma.TraumaEnable = !Trauma.TraumaEnable
		StorageUtil.SetIntValue(Self, "DoToggleTrauma", 1)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TraumaEnableOID"), Trauma.TraumaEnable)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaRebuildTexturesOID_T")
		If ShowMessage("Rebuilding the texture list will remove all existing traumas. Proceed?")
			SetTextOptionValue(StorageUtil.GetIntValue(Self, "TraumaRebuildTexturesOID_T"), "Working...")
			Trauma.SetupTextureArrays()
			SetTextOptionValue(StorageUtil.GetIntValue(Self, "TraumaRebuildTexturesOID_T"), "Done! ")
		EndIf		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaDynamicOID")
		Trauma.DynamicTrauma = !Trauma.DynamicTrauma
		StorageUtil.SetIntValue(Self, "DoToggleDynamicTrauma", 1)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TraumaDynamicOID"), Trauma.DynamicTrauma)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaDynamicCombatOID")
		Trauma.DynamicCombat = !Trauma.DynamicCombat
		Trauma.RegisterForCombat()
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TraumaDynamicCombatOID"), Trauma.DynamicCombat)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPlayerSqueaksOID")
		Trauma.PlayerSqueaks = !Trauma.PlayerSqueaks
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TraumaPlayerSqueaksOID"), Trauma.PlayerSqueaks)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaTrackFollowerOID_T")
		Trauma.ToggleFollowerTracking(Game.GetCurrentCrosshairRef() as Actor)
		ForcePageReset()
	ElseIf (option == SleepDeprivOID)
		SleepDepriv = !SleepDepriv
		SetToggleOptionValue(SleepDeprivOID, SleepDepriv)
		ToggleSleepDepriv()
	ElseIf (option == SaltyCumOID)
		SaltyCum = !SaltyCum
		SetToggleOptionValue(SaltyCumOID, SaltyCum)
		SetSaltyCum(SaltyCum)
	ElseIf (option == BellyScaleEnableOID)
		BellyScaleEnable = !BellyScaleEnable
		SetToggleOptionValue(BellyScaleEnableOID, BellyScaleEnable)
		DoToggleBellyInflation = true
		ForcePageReset()

	ElseIf (option == SlsCreatureEventOID)
		Init.SlsCreatureEvents = !Init.SlsCreatureEvents
		SetToggleOptionValue(SlsCreatureEventOID, Init.SlsCreatureEvents)
		ToggleCreatureEvents()
		ForcePageReset()
	ElseIf (option == AnimalBreedEnableOID)
		AnimalBreedEnable = !AnimalBreedEnable
		SetToggleOptionValue(AnimalBreedEnableOID, AnimalBreedEnable)
		DoToggleAnimalBreeding = true
		ForcePageReset()
	ElseIf (option == AddFondleToListOID_T)
		ModFondleVoice(AddToList = true)
		ForcePageReset()
	ElseIf (option == RemoveFondleFromListOID_T)
		ModFondleVoice(AddToList = false)
		ForcePageReset()
		
	ElseIf (option == AddTownLocationOID_T)
		ModLocationJurisdiction(true)
		ForcePageReset()
	ElseIf (option == RemoveTownLocationOID_T)
		ModLocationJurisdiction(false)
		ForcePageReset()
	
	ElseIf (option == FfRescueEventsOID)
		FfRescueEvents = !FfRescueEvents
		SetToggleOptionValue(FfRescueEventsOID, FfRescueEvents)
		ForcePageReset()
		
	ElseIf option == StorageUtil.GetIntValue(Self, "TollsEnableOID")
		Init.TollEnable = !Init.TollEnable
		ToggleTolls()
		ForcePageReset()
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TollsEnableOID"), Init.TollEnable)
	ElseIf (option == DoorLockDownOID)
		DoorLockDownT = !DoorLockDownT
		ToggleTollGateLocks()
		SetToggleOptionValue(DoorLockDownOID, DoorLockDownT)
	ElseIf (option == TollFollowersHardcoreOID)
		If ShowMessage("Are you sure you want to lock followers required?\nYou won't be able to change it again when set")
			TollFollowersHardcore = !TollFollowersHardcore
			SetToggleOptionValue(TollFollowersHardcoreOID, TollFollowersHardcore)
			ForcePageReset()
		EndIf
	ElseIf (option == DropItemsOID)
		DropItems = !DropItems
		SetToggleOptionValue(DropItemsOID, DropItems)
	ElseIf (option == FastTravelDisableOID)
		FastTravelDisable = !FastTravelDisable
		SetToggleOptionValue(FastTravelDisableOID, FastTravelDisable)
		ToggleFastTravelDisable()
	ElseIf (option == FtDisableIsNormalOID)
		FtDisableIsNormal = !FtDisableIsNormal
		SetToggleOptionValue(FtDisableIsNormalOID, FtDisableIsNormal)
	ElseIf (option == CompassMechanicsOID)
		CompassMechanics = !CompassMechanics
		SetToggleOptionValue(CompassMechanicsOID, CompassMechanics)
		ToggleCompassMechanics()
	ElseIf (option == ReplaceMapsOID)
		ReplaceMaps = !ReplaceMaps
		SetToggleOptionValue(ReplaceMapsOID, ReplaceMaps)
		ReplaceVanillaMaps(ReplaceMaps)		
	ElseIf (option == ConstructableMapAndCompassOID)
		If _SLS_MapAndCompassRecipeEnable.GetValueInt() == 0
			_SLS_MapAndCompassRecipeEnable.SetValueInt(1)
		Else
			_SLS_MapAndCompassRecipeEnable.SetValueInt(0)
		EndIf
		SetToggleOptionValue(ConstructableMapAndCompassOID, _SLS_MapAndCompassRecipeEnable.GetValueInt())

	ElseIf (option == GoldPerLevelOID)
		TollUtil.TollCostPerLevel = !TollUtil.TollCostPerLevel
		SetToggleOptionValue(GoldPerLevelOID, TollUtil.TollCostPerLevel)
		;SetTollCost()
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugLactacidOID")
		ForceDrug.TollDrugLactacid = !ForceDrug.TollDrugLactacid
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TollDrugLactacidOID"), ForceDrug.TollDrugLactacid)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugSkoomaOID")
		ForceDrug.TollDrugSkooma = !ForceDrug.TollDrugSkooma
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TollDrugSkoomaOID"), ForceDrug.TollDrugSkooma)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugCumHumanOID")
		ForceDrug.TollDrugHumanCum = !ForceDrug.TollDrugHumanCum
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TollDrugCumHumanOID"), ForceDrug.TollDrugHumanCum)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugCumCreatureOID")
		ForceDrug.TollDrugCreatureCum = !ForceDrug.TollDrugCreatureCum
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TollDrugCumCreatureOID"), ForceDrug.TollDrugCreatureCum)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugInflateOID")
		ForceDrug.TollDrugInflate = !ForceDrug.TollDrugInflate
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TollDrugInflateOID"), ForceDrug.TollDrugInflate)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugFmFertilityOID")
		ForceDrug.TollDrugFmFertility = !ForceDrug.TollDrugFmFertility
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TollDrugFmFertilityOID"), ForceDrug.TollDrugFmFertility)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TollDrugSlenAphrodisiacOID")
		ForceDrug.TollDrugSlenAphrodisiac = !ForceDrug.TollDrugSlenAphrodisiac
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TollDrugSlenAphrodisiacOID"), ForceDrug.TollDrugSlenAphrodisiac)
		
	ElseIf (option == TollDodgingOID)
		TollDodging = !TollDodging
		SetToggleOptionValue(TollDodgingOID, TollDodging)
		DoTollDodgingToggle = true
		ForcePageReset()
	ElseIf (option == TollDodgeGiftMenuOID)
		Init.TollDodgeGiftMenu = !Init.TollDodgeGiftMenu
		SetToggleOptionValue(TollDodgeGiftMenuOID, Init.TollDodgeGiftMenu)
	ElseIf (option == CurfewEnableOID)
		CurfewEnable = !CurfewEnable
		SetToggleOptionValue(CurfewEnableOID, CurfewEnable)
		TollUtil.IsCurfewTimeByLoc(PlayerRef.GetCurrentLocation())
		ForcePageReset()
	ElseIf (option == LicencesEnableOID)
		If ShowMessage("Are you sure you want to toggle the licence system?\nIf you are disabling the system any licences in your inventory will be removed!\n\nYou'll have to exit the menu and return to the game to complete the process")
			Init.LicencesEnable = !Init.LicencesEnable
			SetToggleOptionValue(LicencesEnableOID, Init.LicencesEnable)
			ForcePageReset()
			ToggleLicences(Init.LicencesEnable)
		EndIf
	ElseIf (option == LicencesSnowberryOID)
		If CanEnableSnowberry()
			SnowberryEnable = !SnowberryEnable
			SetToggleOptionValue(LicencesSnowberryOID, SnowberryEnable)
		Else
			Debug.Messagebox("Can not enable Snowberry after starting your game. You must enable it before leaving Helgen")
		EndIf
	ElseIf (option == BikiniLicFirstOID)
		LicUtil.AlwaysAwardBikiniLicFirst = !LicUtil.AlwaysAwardBikiniLicFirst
		SetToggleOptionValue(BikiniLicFirstOID, LicUtil.AlwaysAwardBikiniLicFirst)
	ElseIf (option == LicBuyBackOID)
		LicUtil.BuyBack = !LicUtil.BuyBack
		SetToggleOptionValue(LicBuyBackOID, LicUtil.BuyBack)
	ElseIf (option == LicBountyMustBePaidOID)
		LicUtil.BountyMustBePaid = !LicUtil.BountyMustBePaid
		SetToggleOptionValue(LicBountyMustBePaidOID, LicUtil.BountyMustBePaid)
	ElseIf (option == FolContraBlockOID)
		FolContraBlock = !FolContraBlock
		SetToggleOptionValue(FolContraBlockOID, FolContraBlock)
		ToggleFolContraBlock()
	ElseIf (option == FolContraKeysOID)
		LicUtil.FollowerWontCarryKeys = !LicUtil.FollowerWontCarryKeys
		SetToggleOptionValue(FolContraKeysOID, LicUtil.FollowerWontCarryKeys)
	ElseIf (option == FolTakeClothesOID)
		LicUtil.FolTakeClothes = !LicUtil.FolTakeClothes
		SetToggleOptionValue(FolTakeClothesOID, LicUtil.FolTakeClothes)
	ElseIf (option == OrdinSupressOID)
		LicUtil.OrdinSupress = !LicUtil.OrdinSupress
		SetToggleOptionValue(OrdinSupressOID, LicUtil.OrdinSupress)
		LicUtil.ToggleOrdinSuppression()
	ElseIf (option == CurseTatsOID)
		LicUtil.CurseTats = !LicUtil.CurseTats
		SetToggleOptionValue(CurseTatsOID, LicUtil.CurseTats)
		ToggleCurseTats()
		ForcePageReset()
	ElseIf (option == SearchEscortsOID_T)
		Debug.Messagebox("Please exit the menu to continue and wait for the process to complete. It can take some time depending on how many followers you have installed so please be patient\n\nIf you cancel the process then any followers added up to that point will stay in the list")
		SearchEscorts()
	ElseIf (option == AddEscortToListOID_T)
		AddEscort()
		ForcePageReset()
	ElseIf (option == RemoveEscortFromListOID_T)
		RemoveEscort()
		ForcePageReset()
	ElseIf (option == ClearAllEscortsOID_T)
		If ShowMessage("Are you sure you want to clear all escorts?\nThe Json file will be wiped clean!")
			SetTextOptionValue(ClearAllEscortsOID_T, "Clearing...")
			ClearAllEscorts()
			SetTextOptionValue(ClearAllEscortsOID_T, "Done! ")
			Utility.WaitMenuMode(0.6)
			ForcePageReset()
		EndIf
	ElseIf (option == ImportEscortsFromJsonOID_T)
		If ShowMessage("Are you sure you want to clear all escorts and read in escorts from the Json file?")
			SetTextOptionValue(ImportEscortsFromJsonOID_T, "Working...")
			ReImportEscorts()
			SetTextOptionValue(ImportEscortsFromJsonOID_T, "Done! ")
			Utility.WaitMenuMode(0.6)
			ForcePageReset()
		EndIf
	ElseIf (option == LicGetEquipListOID_T)
		GetEquippedList()
	ElseIf (option == AddLicExceptionOID_T)
		AddRemoveLicenceException()
		ForcePageReset()
	ElseIf (option == ResponsiveEnforcersOID)
		If _SLS_ResponsiveEnforcers.GetValueInt() == 0
			_SLS_ResponsiveEnforcers.SetValueInt(1)
		Else
			_SLS_ResponsiveEnforcers.SetValueInt(0)
		EndIf
		SetToggleOptionValue(RestrictTradeOID, _SLS_ResponsiveEnforcers.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf (option == RestrictTradeOID)
		TradeRestrictions = !TradeRestrictions
		SetToggleOptionValue(RestrictTradeOID, TradeRestrictions)
		ToggleTradeRestrictions()

	ElseIf (option == TradeRestrictAddMerchantOID_T)
		DoTradeRestrictAddMerchant()
	ElseIf (option == TradeRestrictRemoveMerchantOID_T)
		DoTradeRestrictRemoveMerchant()
	ElseIf (option == TradeRestrictResetAllMerchantsOID_T)
		DoTradeRestrictResetAllMerchants()
		
	ElseIf (option == LicBikiniEnableOID)
		LicUtil.LicBikiniEnable = !LicUtil.LicBikiniEnable
		LicenceToggleToggled()
		SetToggleOptionValue(LicBikiniEnableOID, LicUtil.LicBikiniEnable)
		ForcePageReset()
	ElseIf (option == LicBikiniCurseEnableOID)
		LicUtil.BikiniCurseEnable = !LicUtil.BikiniCurseEnable
		ToggleBikiniCurse()
		SetToggleOptionValue(LicBikiniCurseEnableOID, LicUtil.BikiniCurseEnable)
	ElseIf (option == LicBikiniHeelsOID)
		BikiniCurse.HeelsRequired = !BikiniCurse.HeelsRequired
		SetToggleOptionValue(LicBikiniHeelsOID, BikiniCurse.HeelsRequired)
		DoToggleHeelsRequired = true
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicBikiniArmorTestOID_T")
		TestBikiniArmor()

	ElseIf (option == LicMagicEnableOID)
		LicUtil.LicMagicEnable = !LicUtil.LicMagicEnable
		LicenceToggleToggled()
		SetToggleOptionValue(LicMagicEnableOID, LicUtil.LicMagicEnable)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewLicenceEnableOID")
		LicUtil.LicCurfewEnable = !LicUtil.LicCurfewEnable
		LicenceToggleToggled()
		StorageUtil.SetIntValue(Self, "DoToggleCurfew", 1)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CurfewLicenceEnableOID"), LicUtil.LicCurfewEnable)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "WhoreLicenceEnableOID")
		LicUtil.LicWhoreEnable = !LicUtil.LicWhoreEnable
		LicenceToggleToggled()
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "WhoreLicenceEnableOID"), LicUtil.LicWhoreEnable)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "PropertyLicenceEnableOID")
		LicUtil.LicPropertyEnable = !LicUtil.LicPropertyEnable
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "PropertyLicenceEnableOID"), LicUtil.LicPropertyEnable)
		Eviction.UpdateEvictions(DoImmediately = true)
		LicenceToggleToggled()
		ForcePageReset()

	ElseIf (option == LicMagicCursedDevicesOID)
		LicUtil.LicMagicCursedDevices = !LicUtil.LicMagicCursedDevices
		SetToggleOptionValue(LicMagicCursedDevicesOID, LicUtil.LicMagicCursedDevices)
		ToggleLicMagicCursedDevices()
	ElseIf (option == LicMagicChainCollarsOID)
		LicMagicChainCollars = !LicMagicChainCollars
		SetToggleOptionValue(LicMagicChainCollarsOID, LicMagicChainCollars)
		AddRemoveChainCollars(LicMagicChainCollars)

	ElseIf (option == StashTrackEnOID)
		StashTrackEn = !StashTrackEn
		SetToggleOptionValue(StashTrackEnOID, StashTrackEn)
		DoToggleStashTracking = true
		ForcePageReset()
	ElseIf (option == StashAddRemoveExceptionOID_T)
		DoStashAddRemoveException = !DoStashAddRemoveException
		If DoStashAddRemoveException
			Debug.Messagebox("Exit the menu, open the container and add an item to the container to remove the container from tracking")
			SetTextOptionValue(StashAddRemoveExceptionOID_T, "Armed! ")
		Else
			SetTextOptionValue(StashAddRemoveExceptionOID_T, "")
		EndIf
		
	ElseIf (option == StashAddRemoveJsonExceptionsOID_T)
		If ShowMessage("Are you certain you want to remove all added stash exceptions from the json file?")
			StashClearAllJsonExceptions()
			SetTextOptionValue(StashAddRemoveJsonExceptionsOID_T, "Done! ")
			Utility.WaitMenuMode(0.6)
			ForcePageReset()
		EndIf
	ElseIf (option == StashAddRemoveTempExceptionsOID_T)
		If ShowMessage("Are you certain you want to remove all added temporary stash exceptions?")
			StashClearAllTempExceptions()
			SetTextOptionValue(StashAddRemoveTempExceptionsOID_T, "Done! ")
			Utility.WaitMenuMode(0.6)
			ForcePageReset()
		EndIf
	ElseIf (option == StashAddRemoveAllExceptionsOID_T)
		If ShowMessage("Are you certain you want to remove all added stash exceptions?\nStashes saved to the json file will also be cleared in the process")
			StashClearAllStashExceptions()
			SetTextOptionValue(StashAddRemoveAllExceptionsOID_T, "Done! ")
			Utility.WaitMenuMode(0.6)
			ForcePageReset()
		EndIf
		
	ElseIf (option == ContTypeCountsOID)
		ContTypeCountsT = !ContTypeCountsT
		SetToggleOptionValue(ContTypeCountsOID, ContTypeCountsT)
	ElseIf (option == OrgasmRequiredOID)
		OrgasmRequired = !OrgasmRequired
		SetToggleOptionValue(OrgasmRequiredOID, OrgasmRequired)
	ElseIf Option == StorageUtil.GetIntValue(Self, "JigglesOID")
		StorageUtil.SetIntValue(Self, "Jiggles", (!StorageUtil.GetIntValue(Self, "Jiggles", Missing = 1) as Bool) as Int)
		StorageUtil.SetIntValue(Self, "DoToggleJiggles", 1)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CompulsiveSexOID")
		StorageUtil.SetIntValue(Self, "CompulsiveSex", (!StorageUtil.GetIntValue(Self, "CompulsiveSex", Missing = 0) as Bool) as Int)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CompulsiveSexOID"), StorageUtil.GetIntValue(Self, "CompulsiveSex", Missing = 0))
		StorageUtil.SetIntValue(Self, "DoToggleCompulsiveSex", 1)
		If StorageUtil.GetIntValue(Self, "CompulsiveSex", Missing = 0) == 1
			Debug.Messagebox("Warning!\n\nThere is a little known bug in the interaction between TapKey (which compulsive sex uses) and RegisterForKey(0) (Which other mods, usually with hotkeys, might use). If another mod Registers for key zero and compulsive sex does TapKey it can create hundreds of OnKeyDown() events in the registered mod. Potentially clogging up your papyrus VM with spammed script instances.\n\nOther mods should not register for key 0 but I can not determine if they have. If you enable this then keep an eye on your saves 'Active scripts' and 'Suspended stacks' in Falrim Tools especially after a compulsive sex scene. Ask the authors of affected mods to add a check before registering that the key is not 0")
		EndIf
	ElseIf Option == StorageUtil.GetIntValue(Self, "OrgasmFatigueOID")
		StorageUtil.SetIntValue(Self, "OrgasmFatigue", (!StorageUtil.GetIntValue(Self, "OrgasmFatigue", Missing = 1) as Bool) as Int)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "OrgasmFatigueOID"), StorageUtil.GetIntValue(Self, "OrgasmFatigue", Missing = 1))
		StorageUtil.SetIntValue(Self, "DoToggleOrgasmFatigue", 1)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "JigglesVisualsOID")
		(Game.GetFormFromFile(0x0CF9B1, "SL Survival.esp") as _SLS_BodyInflationTracking).DoImod = !(Game.GetFormFromFile(0x0CF9B1, "SL Survival.esp") as _SLS_BodyInflationTracking).DoImod
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "JigglesVisualsOID"), (Game.GetFormFromFile(0x0CF9B1, "SL Survival.esp") as _SLS_BodyInflationTracking).DoImod)
	ElseIf (option == BeggingTOID)
		If _SLS_BeggingDialogT.GetValueInt() == 0
			_SLS_BeggingDialogT.SetValueInt(1)
		Else
			_SLS_BeggingDialogT.SetValueInt(0)
		EndIf
		SetToggleOptionValue(BeggingTOID, _SLS_BeggingDialogT.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf (option == BegSelfDegEnableOID)
		If _SLS_BegSelfDegradationEnable.GetValueInt() == 0
			_SLS_BegSelfDegradationEnable.SetValueInt(1)
		Else
			_SLS_BegSelfDegradationEnable.SetValueInt(0)
		EndIf
		SetToggleOptionValue(BegSelfDegEnableOID, _SLS_BegSelfDegradationEnable.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSuitsOID")
		StorageUtil.SetIntValue(Self, "KennelSuits", (!(StorageUtil.GetIntValue(Self, "KennelSuits", Missing = 0)) as Bool) as Int)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "KennelSuitsOID"), StorageUtil.GetIntValue(Self, "KennelSuits", Missing = 0))
	ElseIf (option == KennelExtraDevicesOID)
		If _SLS_KennelExtraDevices.GetValueInt() == 0
			_SLS_KennelExtraDevices.SetValueInt(1)
		Else
			_SLS_KennelExtraDevices.SetValueInt(0)
		EndIf
		SetToggleOptionValue(KennelExtraDevicesOID, _SLS_KennelExtraDevices.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf (option == KennelFollowerToggleOID)
		ToggleKennelFollower()
	
	ElseIf (option == GuardCommentsOID)
		GuardComments = !GuardComments
		SetToggleOptionValue(GuardCommentsOID, GuardComments)
		DoToggleGuardComments = true
	ElseIf (option == GuardBehavWeapDropOID)
		If _SLS_GuardBehavWeapDropEn.GetValueInt() == 1
			_SLS_GuardBehavWeapDropEn.SetValueInt(0)
		Else
			_SLS_GuardBehavWeapDropEn.SetValueInt(1)
		EndIf
		SetToggleOptionValue(GuardBehavWeapDropOID, _SLS_GuardBehavWeapDropEn.GetValueInt() as Bool)
	ElseIf (option == GuardBehavShoutOID)
		If _SLS_GuardBehavShoutEn.GetValueInt() == 1
			_SLS_GuardBehavShoutEn.SetValueInt(0)
		Else
			_SLS_GuardBehavShoutEn.SetValueInt(1)
		EndIf
		SetToggleOptionValue(GuardBehavShoutOID, _SLS_GuardBehavShoutEn.GetValueInt() as Bool)
	
	ElseIf (option == GuardBehavWeapDrawnOID)
		GuardBehavWeapDrawn = !GuardBehavWeapDrawn
		SetToggleOptionValue(GuardBehavWeapDrawnOID, GuardBehavWeapDrawn)
		DoToggleGuardBehavWeapDrawn = true
	ElseIf (option == GuardBehavWeapEquipOID)
		GuardBehavWeapEquip = !GuardBehavWeapEquip
		SetToggleOptionValue(GuardBehavWeapEquipOID, GuardBehavWeapEquip)
		DoToggleGuardBehavWeapEquip = true
	ElseIf (option == GuardBehavArmorEquipOID)
		GuardBehavArmorEquip = !GuardBehavArmorEquip
		SetToggleOptionValue(GuardBehavArmorEquipOID, GuardBehavArmorEquip)
		DoToggleGuardBehavArmorEquip = true
	ElseIf option == StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmorOID")
		StorageUtil.SetIntValue(Self, "GuardBehavArmorEquipAnyArmor", (!StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmor", Missing = 0) as Bool) as Int)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmorOID"), StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmor", Missing = 0) as Bool)
	ElseIf (option == GuardBehavLockpickingOID)
		GuardBehavLockpicking = !GuardBehavLockpicking
		SetToggleOptionValue(GuardBehavLockpickingOID, GuardBehavLockpicking)
		DoToggleGuardBehavLockpick = true
	ElseIf (option == GuardBehavDrugsOID)
		GuardBehavDrugs = !GuardBehavDrugs
		SetToggleOptionValue(GuardBehavDrugsOID, GuardBehavDrugs)
		DoToggleGuardBehavDrugs = true
		
	ElseIf (option == RunDevicePatchUpOID_T)
		Devious.DoDevicePatchup()
	ElseIf (option == DeviousEffectsEnableOID)
		DeviousEffectsEnable = !DeviousEffectsEnable
		SetToggleOptionValue(DeviousEffectsEnableOID, DeviousEffectsEnable)
		DoDeviousEffectsChange = true
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "DeviousDrowningOID")
		DeviousEffects.DeviousDrowning = !DeviousEffects.DeviousDrowning
		DeviousEffects.ToggleDeviousDrowning()
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "DeviousDrowningOID"), DeviousEffects.DeviousDrowning)
	ElseIf (option == DevEffNoGagTradingOID)
		DevEffNoGagTrading = !DevEffNoGagTrading
		SetToggleOptionValue(DevEffNoGagTradingOID, DevEffNoGagTrading)
		GagTrade.ToggleActive()
		
	ElseIf (option == BondFurnEnableOID)
		BondFurnEnable = !BondFurnEnable
		SetToggleOptionValue(BondFurnEnableOID, BondFurnEnable)
		DoToggleBondFurn = true
		ForcePageReset()
	
	ElseIf (option == BikiniExpOID)
		If BikiniExpT
			If ShowMessage("Are you sure you want to toggle off Bikini Experience?\nAll bikini training experience will be lost!")
				BikiniExpT = !BikiniExpT
				DoToggleBikiniExp = true
			EndIf
		Else
			BikiniExpT = !BikiniExpT
			DoToggleBikiniExp = true
		EndIf
		SetToggleOptionValue(BikiniExpOID, BikiniExpT)
		ForcePageReset()
	ElseIf (option == BikiniExpReflexesOID)
		If _SLS_BikiniExpReflexes.GetValueInt() == 0
			_SLS_BikiniExpReflexes.SetValueInt(1)
		Else
			_SLS_BikiniExpReflexes.SetValueInt(0)
		EndIf
		SetToggleOptionValue(BikiniExpReflexesOID, _SLS_BikiniExpReflexes.GetValueInt() as Bool)
	ElseIf (option == BikiniBuildListOID_T)
		BuildBikiniLists()
	ElseIf (option == BikiniClearListOID_T)
		ClearBikiniLists()
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "SetInnPricesOID")
		LocTrack.SetInnPrices = !LocTrack.SetInnPrices
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "SetInnPricesOID"), LocTrack.SetInnPrices)
		If LocTrack.SetInnPrices
			LocTrack.SetInnCostByString(LocTrack.PlayerCurrentLocString)
		EndIf
	
	ElseIf option == StorageUtil.GetIntValue(Self, "IntRndOID")
		RestartInterfacePrompt("RealisticNeedsandDiseases.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntIneedOID")
		RestartInterfacePrompt("iNeed.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntESDOID")
		RestartInterfacePrompt("EatingSleepingDrinking.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntFrostfallOID")
		RestartInterfacePrompt("Frostfall.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntSlaverunOID")
		RestartInterfacePrompt("Slaverun_Reloaded.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntPscOID")
		RestartInterfacePrompt("SexLab_PaySexCrime.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntDdsOID")
		RestartInterfacePrompt("Devious Devices - Expansion.esm")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntDfOID")
		RestartInterfacePrompt("DeviousFollowers.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntEffOID")
		RestartInterfacePrompt("EFFCore.esm")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntSgoOID")
		RestartInterfacePrompt("dcc-soulgem-oven-000.esm")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntFhuOID")
		RestartInterfacePrompt("sr_FillHerUp.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntAmpOID")
		RestartInterfacePrompt("Amputator.esm")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntAproposTwoOID")
		RestartInterfacePrompt("Apropos2.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntTatsOID")
		RestartInterfacePrompt("SlaveTats.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntMaOID")
		RestartInterfacePrompt("Milk Addict.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntSlaxOID")
		RestartInterfacePrompt("SexLabAroused.esm")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntSlsfOID")
		RestartInterfacePrompt("SexLab - Sexual Fame [SLSF].esm")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntSlsoOID")
		RestartInterfacePrompt("Slso.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntStaOID")
		RestartInterfacePrompt("Spank That Ass.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntBisOID")
		RestartInterfacePrompt("Bathing in Skyrim - Main.esp")
	ElseIf option == StorageUtil.GetIntValue(Self, "IntSexyMoveOID")
		RestartInterfacePrompt("FNISSexyMove.esp")
		
	; Stats
	ElseIf (option == TollDodgedWhiterunOID_T)
		TollDodge.DodgedTollWhiterun = !TollDodge.DodgedTollWhiterun
		ForcePageReset()
	ElseIf (option == TollDodgedSolitudeOID_T)
		TollDodge.DodgedTollSolitude = !TollDodge.DodgedTollSolitude
		ForcePageReset()
	ElseIf (option == TollDodgedMarkarthOID_T)
		TollDodge.DodgedTollMarkarth = !TollDodge.DodgedTollMarkarth
		ForcePageReset()
	ElseIf (option == TollDodgedWindhelmOID_T)
		TollDodge.DodgedTollWindhelm = !TollDodge.DodgedTollWindhelm
		ForcePageReset()
	ElseIf (option == TollDodgedRiftenOID_T)
		TollDodge.DodgedTollRiften = !TollDodge.DodgedTollRiften
		ForcePageReset()
	EndIf
endEvent

event OnOptionDefault(int option)
	If(option == FollowersStealGoldOID)
		FollowersStealGold = true
		SetToggleOptionValue(FollowersStealGoldOID, FollowersStealGold)
		Main.FilterGold(FollowersStealGold)
	ElseIf(option == SlaverunAutoStartOID)
		SlaverunAutoStart = false
		SetToggleOptionValue(SlaverunAutoStartOID, SlaverunAutoStart)
	ElseIf(option == CoverMyselfMechanicsOID)
		CoverMyselfMechanics = true
		SetToggleOptionValue(CoverMyselfMechanicsOID, CoverMyselfMechanics)
		DoToggleCoverMechanics = true
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "NpcCommentsOID")
		(Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).SetValueInt(1)
		SetToggleOptionValue(Option, true)
		StorageUtil.SetIntValue(Self, "DoToggleNpcComments", 1)
	ElseIf(option == AssSlappingOID)
		AssSlappingEvents = true
		SetToggleOptionValue(AssSlappingOID, AssSlappingEvents)
		ToggleAssSlapping()
	ElseIf(option == ProxSpankCommentOID)
		Util.ProxSpankComment = false
		SetToggleOptionValue(ProxSpankCommentOID, Util.ProxSpankComment)	
	ElseIf(option == EasyBedTrapsOID)
		EasyBedTraps = true
		SetToggleOptionValue(EasyBedTrapsOID, EasyBedTraps)
	ElseIf(option == CumBreathOID)
		CumBreath = true
		SetToggleOptionValue(CumBreathOID, CumBreath)
	ElseIf(option == CumBreathNotifyOID)
		CumBreathNotify = true
		SetToggleOptionValue(CumBreathNotifyOID, CumBreathNotify)
	ElseIf(option == DebugModeOID)
		Init.DebugMode = false
		SetToggleOptionValue(DebugModeOID, Init.DebugMode)
		ToggleDebugMode()
	ElseIf(option == MinAvToggleOID)
		MinAvToggleT = true
		SetToggleOptionValue(MinAvToggleOID, MinAvToggleT)
		ToggleMinAV()
	ElseIf(option == HalfNakedEnableOID)
		HalfNakedEnable = false
		SetToggleOptionValue(HalfNakedEnableOID, HalfNakedEnable)
		DoToggleHalfNakedCover = true
		ForcePageReset()
	ElseIf(option == HalfNakedStripsOID)
		HalfNakedStrips = false
		SetToggleOptionValue(HalfNakedStripsOID, HalfNakedStrips)
		ForcePageReset()
		ToggleHalfNakedStrips()
	ElseIf(option == PpLootEnableOID)
		PpLootEnable = true
		SetToggleOptionValue(PpLootEnableOID, PpLootEnable)
		TogglePpLoot()
	ElseIf Option == StorageUtil.GetIntValue(Self, "AmpBlockMagicOID")
		Amputation.BlockMagic = true
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "AmpBlockMagicOID"), Amputation.BlockMagic)	
	ElseIf(option == DismemberTrollCumOID)
		DismemberTrollCum = true
		SetToggleOptionValue(DismemberTrollCumOID, DismemberTrollCum)
	ElseIf(option == DismemberBathingOID)
		DismemberBathing = true
		SetToggleOptionValue(DismemberBathingOID, DismemberBathing)
	ElseIf(option == DismemberPlayerSayOID)
		DismemberPlayerSay = true
		SetToggleOptionValue(DismemberPlayerSayOID, DismemberPlayerSay)
	ElseIf(option == CumSwallowInflateOID)
		CumSwallowInflate = true
		SetToggleOptionValue(CumSwallowInflateOID, CumSwallowInflate)
		ForcePageReset()
	ElseIf(option == CumEffectsEnableOID)
		CumEffectsEnable = true
		SetToggleOptionValue(CumEffectsEnableOID, CumEffectsEnable)
		DoToggleCumEffects = true
		ForcePageReset()
	ElseIf(option == CumEffectsStackOID)
		CumEffectsStack = true
		SetToggleOptionValue(CumEffectsStackOID, CumEffectsStack)
	ElseIf(option == SuccubusCumSwallowEnergyPerRankOID)
		SuccubusCumSwallowEnergyPerRank = true
		SetToggleOptionValue(SuccubusCumSwallowEnergyPerRankOID, SuccubusCumSwallowEnergyPerRank)
	ElseIf(option == CumAddictClampHungerOID)
		CumAddictClampHunger = true
		SetToggleOptionValue(CumAddictClampHungerOID, CumAddictClampHunger)
		CumAddict.DoUpdate()
	ElseIf(option == CumAddictBeastLevelsOID)
		CumAddictBeastLevels = false
		SetToggleOptionValue(CumAddictBeastLevelsOID, CumAddictBeastLevels)
		CumAddict.LoadNewHungerThresholds()
		CumAddict.DoUpdate()
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictBlockDecayOID")
		CumAddict.CumBlocksAddictionDecay = true
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CumAddictBlockDecayOID"), CumAddict.CumBlocksAddictionDecay)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamOID")
		StorageUtil.SetIntValue(Self, "CumAddictDayDream", 1)
		StorageUtil.SetIntValue(Self, "DoToggleDaydream", 1)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CumAddictDayDreamOID"), true)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflysOID")
		StorageUtil.SetIntValue(Self, "CumAddictDayDreamButterflys", 1)
		StorageUtil.SetIntValue(Self, "DoToggleDaydreamButterflys", 1)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflysOID"), true)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictAutoSuckVictim")
		CumAddict.AutoSuckVictim = true
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CumAddictAutoSuckVictim"), CumAddict.AutoSuckVictim)
		
	ElseIf(option == MilkDecCumBreathOID)
		MilkDecCumBreath = false
		SetToggleOptionValue(MilkDecCumBreathOID, MilkDecCumBreath)
	ElseIf(option == PpSleepNpcPerkOID)
		PpSleepNpcPerk = true
		SetToggleOptionValue(PpSleepNpcPerkOID, PpSleepNpcPerk)
		TogglePpSleepNpcPerk()
	ElseIf(option == PpFailHandleOID)
		PpFailHandle = true
		SetToggleOptionValue(PpFailHandleOID, PpFailHandle)
		DoTogglePpFailHandle = true		
	ElseIf(option == NormalKnockDialogOID)
		Init.SKdialog = true
		SetToggleOptionValue(NormalKnockDialogOID, Init.SKdialog)
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPlayerSqueaksOID")
		Trauma.PlayerSqueaks = true
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "TraumaPlayerSqueaksOID"), Trauma.PlayerSqueaks)
	
	ElseIf(option == SleepDeprivOID)
		SleepDepriv = false
		SetToggleOptionValue(SleepDeprivOID, SleepDepriv)
		ToggleSleepDepriv()
	ElseIf(option == SaltyCumOID)
		SaltyCum = false
		SetToggleOptionValue(SaltyCumOID, SaltyCum)
		SetSaltyCum(SaltyCum)
	ElseIf(option == BellyScaleEnableOID)
		BellyScaleEnable = false
		SetToggleOptionValue(BellyScaleEnableOID, BellyScaleEnable)
		DoToggleBellyInflation = true
		ForcePageReset()
	ElseIf(option == SlsCreatureEventOID)
		Init.SlsCreatureEvents = false
		SetToggleOptionValue(SlsCreatureEventOID, Init.SlsCreatureEvents)
		PlayerRef.RemovePerk(_SLS_CreatureTalk)
		ForcePageReset()
	ElseIf(option == AnimalBreedEnableOID)
		AnimalBreedEnable = true
		SetToggleOptionValue(AnimalBreedEnableOID, AnimalBreedEnable)
		DoToggleAnimalBreeding = true
		ForcePageReset()

	ElseIf(option == DoorLockDownOID)
		DoorLockDownT = true
		ToggleTollGateLocks()
		SetToggleOptionValue(DoorLockDownOID, DoorLockDownT)
	ElseIf(option == DropItemsOID)
		DropItems = true
		SetToggleOptionValue(DropItemsOID, DropItems)
	ElseIf(option == FastTravelDisableOID)
		FastTravelDisable = true
		SetToggleOptionValue(FastTravelDisableOID, FastTravelDisable)
	ElseIf(option == FtDisableIsNormalOID)
		FtDisableIsNormal = true
		SetToggleOptionValue(FtDisableIsNormalOID, FtDisableIsNormal)
	ElseIf(option == CompassMechanicsOID)
		CompassMechanics = true
		SetToggleOptionValue(CompassMechanicsOID, CompassMechanics)
		ToggleCompassMechanics()
	ElseIf(option == ReplaceMapsOID)
		ReplaceMaps = true
		SetToggleOptionValue(ReplaceMapsOID, ReplaceMaps)
		ReplaceVanillaMaps(ReplaceMaps)
	ElseIf(option == ConstructableMapAndCompassOID)
		_SLS_MapAndCompassRecipeEnable.SetValueInt(1)
		SetToggleOptionValue(ConstructableMapAndCompassOID, _SLS_MapAndCompassRecipeEnable.GetValueInt())
	ElseIf(option == GoldPerLevelOID)
		TollUtil.TollCostPerLevel = false
		SetToggleOptionValue(GoldPerLevelOID, TollUtil.TollCostPerLevel)
	ElseIf(option == TollDodgingOID)
		TollDodging = false
		SetToggleOptionValue(TollDodgingOID, TollDodging)
		DoTollDodgingToggle = true
		ForcePageReset()
	ElseIf(option == TollDodgeGiftMenuOID)
		Init.TollDodgeGiftMenu = true
		SetToggleOptionValue(TollDodgeGiftMenuOID, Init.TollDodgeGiftMenu)
	ElseIf(option == LicencesEnableOID)
		Init.LicencesEnable = true
		SetToggleOptionValue(LicencesEnableOID, Init.LicencesEnable)
		ToggleLicences(Init.LicencesEnable)
	ElseIf(option == BikiniLicFirstOID)
		LicUtil.AlwaysAwardBikiniLicFirst = true
		SetToggleOptionValue(BikiniLicFirstOID, LicUtil.AlwaysAwardBikiniLicFirst)
	ElseIf(option == LicBuyBackOID)
		LicUtil.BuyBack = false
		SetToggleOptionValue(LicBuyBackOID, LicUtil.BuyBack)
	ElseIf(option == LicBountyMustBePaidOID)
		LicUtil.BountyMustBePaid = true
		SetToggleOptionValue(LicBountyMustBePaidOID, LicUtil.BountyMustBePaid)
	ElseIf(option == FolContraBlockOID)
		FolContraBlock = true
		SetToggleOptionValue(FolContraBlockOID, FolContraBlock)
		ToggleFolContraBlock()
	ElseIf(option == FolContraKeysOID)
		LicUtil.FollowerWontCarryKeys = true
		SetToggleOptionValue(FolContraKeysOID, LicUtil.FollowerWontCarryKeys)
	ElseIf(option == FolTakeClothesOID)
		LicUtil.FolTakeClothes = true
		SetToggleOptionValue(FolTakeClothesOID, LicUtil.FolTakeClothes)	
	ElseIf(option == OrdinSupressOID)
		LicUtil.OrdinSupress = false
		SetToggleOptionValue(OrdinSupressOID, LicUtil.OrdinSupress)
		LicUtil.ToggleOrdinSuppression()
	ElseIf(option == CurseTatsOID)
		LicUtil.CurseTats = true
		SetToggleOptionValue(CurseTatsOID, LicUtil.CurseTats)
		ToggleCurseTats()
		ForcePageReset()
	ElseIf(option == ResponsiveEnforcersOID)
		_SLS_ResponsiveEnforcers.SetValueInt(0)
		SetToggleOptionValue(ResponsiveEnforcersOID, false)
		ForcePageReset()
	ElseIf(option == RestrictTradeOID)
		TradeRestrictions = true
		SetToggleOptionValue(RestrictTradeOID, TradeRestrictions)
		ToggleTradeRestrictions()
	ElseIf(option == LicBikiniCurseEnableOID)
		LicUtil.BikiniCurseEnable = true
		ToggleBikiniCurse()
		SetToggleOptionValue(LicBikiniCurseEnableOID, LicUtil.BikiniCurseEnable)
	ElseIf(option == LicBikiniHeelsOID)
		BikiniCurse.HeelsRequired = true
		SetToggleOptionValue(LicBikiniHeelsOID, BikiniCurse.HeelsRequired)
		DoToggleHeelsRequired = true
	ElseIf(option == LicBikiniEnableOID)
		LicUtil.LicBikiniEnable = true
		LicenceToggleToggled()
		SetToggleOptionValue(LicBikiniEnableOID, LicUtil.LicBikiniEnable)
		ForcePageReset()
	ElseIf(option == LicMagicEnableOID)
		LicUtil.LicMagicEnable = true
		LicenceToggleToggled()
		SetToggleOptionValue(LicMagicEnableOID, LicUtil.LicMagicEnable)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewLicenceEnableOID")
		LicUtil.LicCurfewEnable = true
		StorageUtil.SetIntValue(Self, "DoToggleCurfew", 1)
		LicenceToggleToggled()
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "CurfewLicenceEnableOID"), LicUtil.LicCurfewEnable)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "WhoreLicenceEnableOID")
		LicUtil.LicWhoreEnable = true
		LicenceToggleToggled()
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "WhoreLicenceEnableOID"), LicUtil.LicWhoreEnable)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "PropertyLicenceEnableOID")
		LicUtil.LicPropertyEnable = true
		Eviction.UpdateEvictions(DoImmediately = true)
		LicenceToggleToggled()
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "PropertyLicenceEnableOID"), LicUtil.LicPropertyEnable)
		ForcePageReset()

	ElseIf(option == LicMagicCursedDevicesOID)
		LicUtil.LicMagicCursedDevices = true
		SetToggleOptionValue(LicMagicCursedDevicesOID, LicUtil.LicMagicCursedDevices)
		PlayerRef.RemoveSpell(_SLS_MagicLicenceCurse)
	ElseIf(option == LicMagicChainCollarsOID)
		LicMagicChainCollars = false
		SetToggleOptionValue(LicMagicChainCollarsOID, LicMagicChainCollars)
		AddRemoveChainCollars(LicMagicChainCollars)
	ElseIf(option == StashTrackEnOID)
		StashTrackEn = true
		SetToggleOptionValue(StashTrackEnOID, StashTrackEn)
		DoToggleStashTracking = true
		ForcePageReset()	
	ElseIf(option == ContTypeCountsOID)
		ContTypeCountsT = true
		SetToggleOptionValue(ContTypeCountsOID, ContTypeCountsT)
	ElseIf(option == OrgasmRequiredOID)
		OrgasmRequired = true
		SetToggleOptionValue(OrgasmRequiredOID, OrgasmRequired)
	ElseIf Option == StorageUtil.GetIntValue(Self, "JigglesOID")
		StorageUtil.SetIntValue(Self, "Jiggles", 1)
		StorageUtil.SetIntValue(Self, "DoToggleJiggles", 1)
		SetToggleOptionValue(Option, true)
	ElseIf(option == BeggingTOID)
		_SLS_BeggingDialogT.SetValueInt(1)
		SetToggleOptionValue(BeggingTOID, _SLS_BeggingDialogT.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf(option == BegSelfDegEnableOID)
		_SLS_BegSelfDegradationEnable.SetValueInt(1)
		SetToggleOptionValue(BegSelfDegEnableOID, _SLS_BegSelfDegradationEnable.GetValueInt() as Bool)
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSuitsOID")
		StorageUtil.SetIntValue(Self, "KennelSuits", 0)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "KennelSuitsOID"), StorageUtil.GetIntValue(Self, "KennelSuits", Missing = 0))
	ElseIf(option == KennelExtraDevicesOID)
		_SLS_KennelExtraDevices.SetValueInt(1)
		SetToggleOptionValue(KennelExtraDevicesOID, _SLS_KennelExtraDevices.GetValueInt() as Bool)
		ForcePageReset()
		
	ElseIf(option == GuardCommentsOID)
		GuardComments = true
		SetToggleOptionValue(GuardCommentsOID, GuardComments)
		DoToggleGuardComments = true
	ElseIf(option == GuardBehavWeapDropOID)
		_SLS_GuardBehavWeapDropEn.SetValueInt(1)
		SetToggleOptionValue(GuardBehavWeapDropOID, DeviousEffectsEnable)
		ForcePageReset()
	ElseIf(option == GuardBehavShoutOID)
		_SLS_GuardBehavShoutEn.SetValueInt(1)
		SetToggleOptionValue(GuardBehavShoutOID, DeviousEffectsEnable)
		ForcePageReset()
	ElseIf(option == GuardBehavWeapDrawnOID)
		GuardBehavWeapDrawn = true
		SetToggleOptionValue(GuardBehavWeapDrawnOID, GuardBehavWeapDrawn)
		DoToggleGuardBehavWeapDrawn = true
	ElseIf(option == GuardBehavWeapEquipOID)
		GuardBehavWeapEquip = true
		DoToggleGuardBehavWeapEquip = true
		SetToggleOptionValue(GuardBehavWeapEquipOID, GuardBehavWeapEquip)
	ElseIf(option == GuardBehavArmorEquipOID)
		GuardBehavArmorEquip = false
		_SLS_GuardWarnArmorEquippedQuest.Stop()
		SetToggleOptionValue(GuardBehavArmorEquipOID, GuardBehavArmorEquip)
	ElseIf option == StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmorOID")
		StorageUtil.SetIntValue(Self, "GuardBehavArmorEquipAnyArmor", 0)
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmorOID"), StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmor", Missing = 0))
	ElseIf(option == GuardBehavLockpickingOID)
		GuardBehavLockpicking = true
		SetToggleOptionValue(GuardBehavLockpickingOID, GuardBehavLockpicking)
		DoToggleGuardBehavLockpick = true
	ElseIf(option == GuardBehavDrugsOID)
		GuardBehavDrugs = true
		SetToggleOptionValue(GuardBehavDrugsOID, GuardBehavDrugs)
		DoToggleGuardBehavDrugs = true
		
	ElseIf(option == DeviousEffectsEnableOID)
		DeviousEffectsEnable = true
		SetToggleOptionValue(DeviousEffectsEnableOID, DeviousEffectsEnable)
		DoDeviousEffectsChange = true
		ForcePageReset()
	ElseIf Option == StorageUtil.GetIntValue(Self, "DeviousDrowningOID")
		DeviousEffects.DeviousDrowning = true
		DeviousEffects.ToggleDeviousDrowning()
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "DeviousDrowningOID"), DeviousEffects.DeviousDrowning)
	ElseIf(option == DevEffNoGagTradingOID)
		DevEffNoGagTrading = false
		SetToggleOptionValue(DevEffNoGagTradingOID, DevEffNoGagTrading)
		GagTrade.ToggleActive()
	ElseIf(option == BondFurnEnableOID)
		BondFurnEnable = true
		SetToggleOptionValue(BondFurnEnableOID, BondFurnEnable)
		DoToggleBondFurn = true
		ForcePageReset()
	ElseIf(option == BikiniExpReflexesOID)
		_SLS_BikiniExpReflexes.SetValueInt(1)
		SetToggleOptionValue(BikiniExpReflexesOID, _SLS_BikiniExpReflexes.GetValueInt() as Bool)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "SetInnPricesOID")
		LocTrack.SetInnPrices = false
		SetToggleOptionValue(StorageUtil.GetIntValue(Self, "SetInnPricesOID"), LocTrack.SetInnPrices)
	EndIf
endEvent

event OnOptionSliderOpen(int option)
	; Settings
	If (option == BarefootMagOIS_S)
		SetSliderDialogStartValue(BarefootMag)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == HorseCostOIS_S)
		SetSliderDialogStartValue(SurvivalHorseCost)
		SetSliderDialogDefaultValue(6000.0)
		SetSliderDialogRange(1000.0, 50000.0)
		SetSliderDialogInterval(1000.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "GrowthWeightGainOID_S")
		SetSliderDialogStartValue(StorageUtil.GetFloatValue(Self, "WeightGainPerDay", Missing = 0.0))
		SetSliderDialogDefaultValue(0.1)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
	ElseIf Option == StorageUtil.GetIntValue(Self, "PushCooldownOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0E651A, "SL Survival.esp") as _SLS_PushPlayerCooloff).CooloffPeriod)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == CatCallVolOIS_S)
		SetSliderDialogStartValue(CatCallVol)
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	ElseIf (option == CatCallWillLossOIS_S)
		SetSliderDialogStartValue(CatCallWillLoss)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == GreetDistOIS_S)
		SetSliderDialogStartValue(GreetDist)
		SetSliderDialogDefaultValue(150.0)
		SetSliderDialogRange(0.0, 500.0)
		SetSliderDialogInterval(10.0)
	ElseIf (option == ReplaceMapsTimerOID_S)
		SetSliderDialogStartValue(ReplaceMapsTimer)
		SetSliderDialogDefaultValue(180.0)
		SetSliderDialogRange(10.0, 600.0)
		SetSliderDialogInterval(10.0)
	ElseIf (option == GoldWeightOID_S)
		SetSliderDialogStartValue(GoldWeight)
		SetSliderDialogDefaultValue(0.01)
		SetSliderDialogRange(0.000, 0.100)
		SetSliderDialogInterval(0.001)
	ElseIf (option == FolGoldStealChanceOID_S)
		SetSliderDialogStartValue(FolGoldStealChance)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == FolGoldSteamAmountOID_S)
		SetSliderDialogStartValue(FolGoldSteamAmount)
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == MinSpeedOID_S)
		SetSliderDialogStartValue(MinSpeedMult)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == MinCarryWeightOID_S)
		SetSliderDialogStartValue(MinCarryWeight)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 500.0)
		SetSliderDialogInterval(10.0)
	ElseIf (option == SlaverunAutoMinOID_S)
		SetSliderDialogStartValue(SlaverunAutoMin)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == SlaverunAutoMaxOID_S)
		SetSliderDialogStartValue(SlaverunAutoMax)
		SetSliderDialogDefaultValue(14.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == HalfNakedBraOID_S)
		SetSliderDialogStartValue(HalfNakedBra)
		SetSliderDialogDefaultValue(56.0)
		SetSliderDialogRange(30.0, 61.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == HalfNakedPantyOID_S)
		SetSliderDialogStartValue(HalfNakedPanty)
		SetSliderDialogDefaultValue(49.0)
		SetSliderDialogRange(30.0, 61.0)
		SetSliderDialogInterval(1.0)

	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifBreastScaleMaxOID_S")
		SetSliderDialogStartValue(Main.Slif.ScaleMaxBreasts)
		SetSliderDialogDefaultValue(3.3)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifBellyScaleMaxOID_S")
		SetSliderDialogStartValue(Main.Slif.ScaleMaxBelly)
		SetSliderDialogDefaultValue(5.5)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifAssScaleMaxOID_S")
		SetSliderDialogStartValue(Main.Slif.ScaleMaxAss)
		SetSliderDialogDefaultValue(2.3)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)

	ElseIf (option == AssSlapResistLossOID_S)
		SetSliderDialogStartValue(AssSlapResistLoss)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == ProxSpankCooloffOID_S)
		SetSliderDialogStartValue(ProxSpankCooloff)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 300.0)
		SetSliderDialogInterval(5.0)
	ElseIf (option == SexExpCorruptionCurrentOID_S)
		SetSliderDialogStartValue(StorageUtil.GetIntValue(None, "_SLS_CreatureCorruption", Missing = 0))
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == CockSizeBonusEnjFreqOID_S)
		SetSliderDialogStartValue(CockSizeBonusEnjFreq)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 30.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == RapeForcedSkoomaChanceOID_S)
		SetSliderDialogStartValue(RapeForcedSkoomaChance)
		SetSliderDialogDefaultValue(35.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == RapeMinArousalOID_S)
		SetSliderDialogStartValue(RapeMinArousal)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == SexMinStaminaRateOID_S)
		SetSliderDialogStartValue(SexMinStaminaRate)
		SetSliderDialogDefaultValue(2.5)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == SexMinStaminaMultOID_S)
		SetSliderDialogStartValue(SexMinStaminaMult)
		SetSliderDialogDefaultValue(60.0)
		SetSliderDialogRange(0.0, 200.0)
		SetSliderDialogInterval(10.0)
	ElseIf (option == SexMinMagickaRateOID_S)
		SetSliderDialogStartValue(SexMinMagickaRate)
		SetSliderDialogDefaultValue(1.5)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == SexMinMagickaMultOID_S)
		SetSliderDialogStartValue(SexMinMagickaMult)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 200.0)
		SetSliderDialogInterval(10.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutChanceOID_S")
		SetSliderDialogStartValue(FashionRape.HaircutChance)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutMinOID_S")
		SetSliderDialogStartValue(FashionRape.HaircutMinLevel)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, FashionRape.HaircutMaxLevel)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutMaxOID_S")
		SetSliderDialogStartValue(FashionRape.HaircutMaxLevel)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(FashionRape.HaircutMinLevel, 20.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutFloorOID_S")
		SetSliderDialogStartValue(FashionRape.HaircutFloor)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeDyeHairChanceOID_S")
		SetSliderDialogStartValue(FashionRape.DyeHairChance)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeShavePussyChanceOID_S")
		SetSliderDialogStartValue(FashionRape.ShavePussyChance)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeLipstickChanceOID_S")
		SetSliderDialogStartValue(FashionRape.SmudgeLipstickChance)
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeEyeshadowChanceOID_S")
		SetSliderDialogStartValue(FashionRape.SmudgeEyeshadowChance)
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)

	ElseIf (option == IneqStatsValOID)
		SetSliderDialogStartValue(IneqStatsVal)
		SetSliderDialogDefaultValue(40.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == IneqHealthCushionOID)
		SetSliderDialogStartValue(IneqHealthCushion)
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == IneqCarryValOID)
		SetSliderDialogStartValue(IneqCarryVal)
		SetSliderDialogDefaultValue(150.0)
		SetSliderDialogRange(0.0, 300.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == IneqSpeedValOID)
		SetSliderDialogStartValue(IneqSpeedVal)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == IneqDamageValOID)
		SetSliderDialogStartValue(IneqDamageVal)
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == IneqDestValOID)
		SetSliderDialogStartValue(IneqDestVal)
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == IneqVendorGoldOID)
		SetSliderDialogStartValue(IneqFemaleVendorGoldMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(0.01)
	
	
	ElseIf (option == CumIsLactacidOID_S)
		SetSliderDialogStartValue(CumIsLactacid * 100.0)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 200.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == AproTwoTrollHealAmountOID)
		SetSliderDialogStartValue(AproTwoTrollHealAmount)
		SetSliderDialogDefaultValue(200.0)
		SetSliderDialogRange(0.0, 1000.0)
		SetSliderDialogInterval(10.0)
	
	ElseIf (option == AfCooloffBaseOID_S)
		SetSliderDialogStartValue(AnimalFriend.BreedingCooloffBase)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 168.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == AfCooloffBodyCumOID_S)
		SetSliderDialogStartValue(AnimalFriend.BreedingCooloffCumCovered)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 168.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == AfCooloffCumInflationOID_S)
		SetSliderDialogStartValue(AnimalFriend.BreedingCooloffCumFilled)
		SetSliderDialogDefaultValue(12.0)
		SetSliderDialogRange(0.0, 168.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == AfCooloffPregnancyOID_S)
		SetSliderDialogStartValue(AnimalFriend.BreedingCooloffPregnancy)
		SetSliderDialogDefaultValue(12.0)
		SetSliderDialogRange(0.0, 168.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == AfCooloffCumSwallowOID_S)
		SetSliderDialogStartValue(AnimalFriend.SwallowBonus)
		SetSliderDialogDefaultValue(12.0)
		SetSliderDialogRange(0.0, 168.0)
		SetSliderDialogInterval(0.5)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "CompulsiveSexFuckTimeOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0E7553, "SL Survival.esp") as _SLS_CompulsiveSex).TimeBetweenFucks)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "OrgasmFatigueThresholdOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmThreshold)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(1.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "OrgasmFatigueRecoveryOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmRecoveryPerHour)
		SetSliderDialogDefaultValue(0.8)
		SetSliderDialogRange(0.0, 2.0)
		SetSliderDialogInterval(0.1)
		
	ElseIf (option == DflowResistLossOID_S)
		SetSliderDialogStartValue(DflowResistLoss)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.1)

	ElseIf (option == DeviousGagDebuffOID_S)
		SetSliderDialogStartValue(DeviousGagDebuff)
		SetSliderDialogDefaultValue(80.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == BondFurnMilkFreqOID_S)
		SetSliderDialogStartValue(BondFurnMilkFreq)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(-1.0, 30.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == BondFurnMilkFatigueMultOID_S)
		SetSliderDialogStartValue(BondFurnMilkFatigueMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == BondFurnMilkWillOID_S)
		SetSliderDialogStartValue(BondFurnMilkWill)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(-1.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == BondFurnFreqOID_S)
		SetSliderDialogStartValue(BondFurnFreq)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(-1.0, 30.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == BondFurnFatigueMultOID_S)
		SetSliderDialogStartValue(BondFurnFatigueMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == BondFurnWillOID_S)
		SetSliderDialogStartValue(BondFurnWill)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(-1.0, 10.0)
		SetSliderDialogInterval(1.0)

	ElseIf (option == CumSwallowInflateMultOID_S)
		SetSliderDialogStartValue(CumSwallowInflateMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == CumEffectsMagMultOID_S)
		SetSliderDialogStartValue(CumEffectsMagMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 4.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == CumEffectsDurMultOID_S)
		SetSliderDialogStartValue(CumEffectsDurMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 4.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == CumpulsionChanceOID_S)
		SetSliderDialogStartValue(CumpulsionChance)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == CumRegenTimeOID_S)
		SetSliderDialogStartValue(CumRegenTime)
		SetSliderDialogDefaultValue(24.0)
		SetSliderDialogRange(0.0, 48.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == CumEffectVolThresOID_S)
		SetSliderDialogStartValue(CumEffectVolThres)
		SetSliderDialogDefaultValue(85.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
	ElseIf (option == SuccubusCumSwallowEnergyMultOID_S)
		SetSliderDialogStartValue(SuccubusCumSwallowEnergyMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
		
	ElseIf (option == CumAddictHungerRateOID_S)
		SetSliderDialogStartValue(CumAddictionHungerRate)
		SetSliderDialogDefaultValue(0.1)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == CumAddictionSpeedOID_S)
		SetSliderDialogStartValue(CumAddictionSpeed)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == CumAddictionPerHourOID_S)
		SetSliderDialogStartValue(CumAddictionDecayPerHour)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.25)
	ElseIf (option == CumSatiationOID_S)
		SetSliderDialogStartValue(CumSatiation)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamVolOID_S")
		SetSliderDialogStartValue(StorageUtil.GetFloatValue(Self, "CumAddictDayDreamVol", Missing = 1.0) * 100.0)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(5.0)
		
	ElseIf (option == CumAddictBatheRefuseTimeOID_S)
		SetSliderDialogStartValue(CumAddictBatheRefuseTime)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 48.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == CumAddictReflexSwallowOID_S)
		SetSliderDialogStartValue(CumAddictReflexSwallow)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 2.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == CumAddictAutoSuckCreatureOID_S)
		SetSliderDialogStartValue(CumAddictAutoSuckCreature)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 2.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == CumAddictAutoSuckCooldownOID_S)
		SetSliderDialogStartValue(CumAddictAutoSuckCooldown)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 48.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == CumAddictAutoSuckCreatureArousalOID_S)
		SetSliderDialogStartValue(CumAddictAutoSuckCreatureArousal)
		SetSliderDialogDefaultValue(70.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)

	ElseIf (option == PpGoldLowChanceOID_S)
		SetSliderDialogStartValue(PpGoldLowChance)
		SetSliderDialogDefaultValue(60.0)
		SetSliderDialogRange(0.0, 100.0 - (PpGoldModerateChance + PpGoldHighChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpGoldModerateChanceOID_S)
		SetSliderDialogStartValue(PpGoldModerateChance)
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 100.0 - (PpGoldLowChance + PpGoldHighChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpGoldHighChanceOID_S)
		SetSliderDialogStartValue(PpGoldHighChance)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 100.0 - (PpGoldLowChance + PpGoldModerateChance))
		SetSliderDialogInterval(0.5)
		
	ElseIf (option == PpLootMinOID_S)
		SetSliderDialogStartValue(Util.PpLootLootMin)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == PpLootMaxOID_S)
		SetSliderDialogStartValue(Util.PpLootLootMax)
		SetSliderDialogDefaultValue(8.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)

	ElseIf (option == PpLootFoodChanceOID_S)
		SetSliderDialogStartValue(PpLootFoodChance)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootGemsChance + PpLootSoulgemsChance + PpLootJewelryChance + PpLootEnchJewelryChance + PpLootPotionsChance + PpLootKeysChance + PpLootTomesChance + PpLootCureChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpLootGemsChanceOID_S)
		SetSliderDialogStartValue(PpLootGemsChance)
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootFoodChance + PpLootSoulgemsChance + PpLootJewelryChance + PpLootEnchJewelryChance + PpLootPotionsChance + PpLootKeysChance + PpLootTomesChance + PpLootCureChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpLootSoulgemsChanceOID_S)
		SetSliderDialogStartValue(PpLootSoulgemsChance)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootFoodChance + PpLootGemsChance + PpLootJewelryChance + PpLootEnchJewelryChance + PpLootPotionsChance + PpLootKeysChance + PpLootTomesChance + PpLootCureChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpLootJewelryChanceOID_S)
		SetSliderDialogStartValue(PpLootJewelryChance)
		SetSliderDialogDefaultValue(15.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootFoodChance + PpLootGemsChance + PpLootSoulgemsChance + PpLootEnchJewelryChance + PpLootPotionsChance + PpLootKeysChance + PpLootTomesChance + PpLootCureChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpLootEnchJewelryChanceOID_S)
		SetSliderDialogStartValue(PpLootEnchJewelryChance)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootFoodChance + PpLootGemsChance + PpLootSoulgemsChance + PpLootJewelryChance + PpLootPotionsChance + PpLootKeysChance + PpLootTomesChance + PpLootCureChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpLootPotionsChanceOID_S)
		SetSliderDialogStartValue(PpLootPotionsChance)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootFoodChance + PpLootGemsChance + PpLootSoulgemsChance + PpLootJewelryChance + PpLootEnchJewelryChance + PpLootKeysChance + PpLootTomesChance + PpLootCureChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpLootKeysChanceOID_S)
		SetSliderDialogStartValue(PpLootKeysChance)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootFoodChance + PpLootGemsChance + PpLootSoulgemsChance + PpLootJewelryChance + PpLootEnchJewelryChance + PpLootPotionsChance + PpLootTomesChance + PpLootCureChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpLootTomesChanceOID_S)
		SetSliderDialogStartValue(PpLootTomesChance)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootFoodChance + PpLootGemsChance + PpLootSoulgemsChance + PpLootJewelryChance + PpLootEnchJewelryChance + PpLootPotionsChance + PpLootKeysChance + PpLootCureChance))
		SetSliderDialogInterval(0.5)
	ElseIf (option == PpLootCureChanceOID_S)
		SetSliderDialogStartValue(PpLootCureChance)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 100.0 - (PpLootFoodChance + PpLootGemsChance + PpLootSoulgemsChance + PpLootJewelryChance + PpLootEnchJewelryChance + PpLootPotionsChance + PpLootKeysChance + PpLootTomesChance))
		SetSliderDialogInterval(0.5)
		
	ElseIf (option == PpCrimeGoldOID_S)
		SetSliderDialogStartValue(Game.GetGameSettingInt("iCrimeGoldPickpocket"))
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 1000.0)
		SetSliderDialogInterval(25.0)
	ElseIf (option == PpFailDevicesOID_S)
		SetSliderDialogStartValue(PpFailDevices)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(1.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == PpFailStealValueOID_S)
		SetSliderDialogStartValue(_SLS_PickPocketFailStealValue.GetValueInt())
		SetSliderDialogDefaultValue(200.0)
		SetSliderDialogRange(0.0, 10000.0)
		SetSliderDialogInterval(10.0)
	ElseIf (option == PpFailDrugCountOID_S)
		SetSliderDialogStartValue(PpFailDrugCount)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(1.0, 10.0)
		SetSliderDialogInterval(1.0)

	ElseIf (option == DismemberCooldownOID_S)
		SetSliderDialogStartValue(DismemberCooldown)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.0, 168.0)
		SetSliderDialogInterval(0.05)
	ElseIf (option == DismemberMaxAmpedLimbsOID_S)
		SetSliderDialogStartValue(MaxAmpedLimbs)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(1.0, 4.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == DismemberChanceOID_S)
		SetSliderDialogStartValue(DismemberChance)
		SetSliderDialogDefaultValue(90.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == DismemberArmorBonusOID_S)
		SetSliderDialogStartValue(DismemberArmorBonus)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == DismemberDamageThresOID_S)
		SetSliderDialogStartValue(DismemberDamageThres)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 1000.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == DismemberHealthThresOID_S)
		SetSliderDialogStartValue(DismemberHealthThres)
		SetSliderDialogDefaultValue(110.0)
		SetSliderDialogRange(0.0, 1000.0)
		SetSliderDialogInterval(10.0)
	ElseIf (option == AmpPriestHealCostOID_S)
		SetSliderDialogStartValue(_SLS_AmpPriestHealCost.GetValueInt())
		SetSliderDialogDefaultValue(200.0)
		SetSliderDialogRange(0.0, 10000.0)
		SetSliderDialogInterval(50.0)

	; Simply Knock
	ElseIf (option == KnockSlaveryChanceOID_S)
		SetSliderDialogStartValue(KnockSlaveryChance)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == SimpleSlaveryWeightOID_S)
		SetSliderDialogStartValue(SimpleSlaveryWeight)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == SdWeightOID_S)
		SetSliderDialogStartValue(SdWeight)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPainSoundVolOID_S")
		SetSliderDialogStartValue(Util.PainSoundVol * 100.0)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHitSoundVolOID_S")
		SetSliderDialogStartValue(Util.HitSoundVol * 100.0)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxPlayerOID_S")
		SetSliderDialogStartValue(Trauma.PlayerTraumaCountMax)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 35.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxFollowerOID_S")
		SetSliderDialogStartValue(Trauma.FollowerTraumaCountMax)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 35.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxNpcOID_S")
		SetSliderDialogStartValue(Trauma.NpcTraumaCountMax)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 35.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaStartingOpacityOID_S")
		SetSliderDialogStartValue(Trauma.StartingAlpha)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(30.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaMaximumOpacityOID_S")
		SetSliderDialogStartValue(Trauma.MaxAlpha)
		SetSliderDialogDefaultValue(85.0)
		SetSliderDialogRange(60.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHoursToFadeInOID_S")
		SetSliderDialogStartValue(Trauma.HoursToMaxAlpha)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(1.0, 12.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHoursToFadeOutOID_S")
		SetSliderDialogStartValue(Trauma.HoursToFadeOut)
		SetSliderDialogDefaultValue(48.0)
		SetSliderDialogRange(6.0, 168.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChancePlayerOID_S")
		SetSliderDialogStartValue(Trauma.SexChancePlayer)
		SetSliderDialogDefaultValue(33.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChanceFollowerOID_S")
		SetSliderDialogStartValue(Trauma.SexChanceFollower)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChanceOID_S")
		SetSliderDialogStartValue(Trauma.SexChanceNpc)
		SetSliderDialogDefaultValue(75.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsPlayerOID_S")
		SetSliderDialogStartValue(Trauma.SexHitsPlayer)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsFollowerOID_S")
		SetSliderDialogStartValue(Trauma.SexHitsFollower)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsOID_S")
		SetSliderDialogStartValue(Trauma.SexHitsNpc)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaDamageThresholdOID_S")
		SetSliderDialogStartValue(Trauma.CombatDamageThreshold)
		SetSliderDialogDefaultValue(4.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChancePlayerOID_S")
		SetSliderDialogStartValue(Trauma.CombatChancePlayer)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChanceFollowerOID_S")
		SetSliderDialogStartValue(Trauma.CombatChanceFollower)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChanceOID_S")
		SetSliderDialogStartValue(Trauma.CombatChanceNpc)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPushChancePlayerOID_S")
		SetSliderDialogStartValue(Trauma.PushChance)
		SetSliderDialogDefaultValue(33.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)

	; Needs
	ElseIf (option == GluttedSpeedMultOID_S)
		SetSliderDialogStartValue(GluttedSpeed)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 50.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == CumFoodMultOID_S)
		SetSliderDialogStartValue(Needs.CumFoodMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == CumDrinkMultOID_S)
		SetSliderDialogStartValue(Needs.CumDrinkMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == SkoomaSleepOID_S)
		SetSliderDialogStartValue(SkoomaSleep)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == MilkSleepMultOID_S)
		SetSliderDialogStartValue(MilkSleepMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == DrugEndFatigueIncOID_S)
		SetSliderDialogStartValue(DrugEndFatigueInc * 100.0)
		SetSliderDialogDefaultValue(25.0)
		SetSliderDialogRange(-5.0, 200.0)
		SetSliderDialogInterval(5.0)
	
	ElseIf (option == BaseBellyScaleOID_S)
		SetSliderDialogStartValue(Needs.BaseBellyScale)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 1.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == BellyScaleRnd00OID_S)
		SetSliderDialogStartValue(Rnd.BellyScaleRnd00)
		SetSliderDialogDefaultValue(2.5)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == BellyScaleRnd01OID_S)
		SetSliderDialogStartValue(Rnd.BellyScaleRnd01)
		SetSliderDialogDefaultValue(1.4)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == BellyScaleRnd02OID_S)
		SetSliderDialogStartValue(Rnd.BellyScaleRnd02)
		SetSliderDialogDefaultValue(1.3)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == BellyScaleRnd03OID_S)
		SetSliderDialogStartValue(Rnd.BellyScaleRnd03)
		SetSliderDialogDefaultValue(1.2)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == BellyScaleRnd04OID_S)
		SetSliderDialogStartValue(Rnd.BellyScaleRnd04)
		SetSliderDialogDefaultValue(1.1)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == BellyScaleRnd05OID_S)
		SetSliderDialogStartValue(Rnd.BellyScaleRnd05)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
		
	ElseIf (option == BellyScaleIneed00OID_S)
		SetSliderDialogStartValue(Ineed.BellyScaleIneed00)
		SetSliderDialogDefaultValue(0.9)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == BellyScaleIneed01OID_S)
		SetSliderDialogStartValue(Ineed.BellyScaleIneed01)
		SetSliderDialogDefaultValue(0.6)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == BellyScaleIneed02OID_S)
		SetSliderDialogStartValue(Ineed.BellyScaleIneed02)
		SetSliderDialogDefaultValue(0.3)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf (option == BellyScaleIneed03OID_S)
		SetSliderDialogStartValue(Ineed.BellyScaleIneed03)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
		
	; Frostfall
	ElseIf (option == WarmBodiesOID_S)
		SetSliderDialogStartValue(WarmBodies)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == MilkLeakWetOID_S)
		SetSliderDialogStartValue(MilkLeakWet)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 200.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == CumWetMultOID_S)
		SetSliderDialogStartValue(CumWetMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == CumExposureMultOID_S)
		SetSliderDialogStartValue(CumExposureMult)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == SwimCumCleanOID_S)
		SetSliderDialogStartValue(SwimCumClean)
		SetSliderDialogDefaultValue(12.0)
		SetSliderDialogRange(0.0, 120.0)
		SetSliderDialogInterval(2.0)
	ElseIf (option == SimpleSlaveryFFOID_S)
		SetSliderDialogStartValue(SimpleSlaveryFF)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == SdDreamFFOID_S)
		SetSliderDialogStartValue(SdDreamFF)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
		
	; Tolls & Eviction
	ElseIf (option == EvictionLimitOID_S)
		SetSliderDialogStartValue(EvictionLimit)
		SetSliderDialogDefaultValue(500.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(100.0)
	ElseIf (option == SlaverunEvictionLimitOID_S)
		SetSliderDialogStartValue(SlaverunEvictionLimit)
		SetSliderDialogDefaultValue(200.0)
		SetSliderDialogRange(0.0, 5000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == ConfiscationFineOID_S)
		SetSliderDialogStartValue(ConfiscationFine)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 1000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == ConfiscationFineSlaverunOID_S)
		SetSliderDialogStartValue(ConfiscationFineSlaverun)
		SetSliderDialogDefaultValue(200.0)
		SetSliderDialogRange(0.0, 1000.0)
		SetSliderDialogInterval(50.0)
		
	ElseIf (option == TollCostGoldOID_S)
		SetSliderDialogStartValue(TollUtil.TollCostGold)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(0.0, 500.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == SlaverunFactorOID)
		SetSliderDialogStartValue(TollUtil.SlaverunFactor)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == SlaverunJobFactorOID)
		SetSliderDialogStartValue(TollUtil.SlaverunJobFactor)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == TollCostDevicesOID_S)
		SetSliderDialogStartValue(TollUtil.TollCostDevices)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == TollCostTattoosOID_S)
		SetSliderDialogStartValue(TollUtil.TollCostTattoos)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == TollCostDrugsOID_S)
		SetSliderDialogStartValue(TollUtil.TollCostDrugs)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == MaxTatsBodyOID_S)
		SetSliderDialogStartValue(MaxTatsBody)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == MaxTatsFaceOID_S)
		SetSliderDialogStartValue(MaxTatsFace)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == MaxTatsHandsOID_S)
		SetSliderDialogStartValue(MaxTatsHands)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == MaxTatsFeetOID_S)
		SetSliderDialogStartValue(MaxTatsFeet)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == TollFollowersOID_S)
		SetSliderDialogStartValue(_SLS_TollFollowersRequired.GetValueInt())
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == TollDodgeHuntFreqOID_S)
		SetSliderDialogStartValue(TollDodgeHuntFreq)
		SetSliderDialogDefaultValue(1.5)
		SetSliderDialogRange(0.25, 10.0)
		SetSliderDialogInterval(0.25)
	ElseIf (option == TollDodgeGracePeriodOID_S)
		SetSliderDialogStartValue(TollDodgeGracePeriod)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == TollDodgeMaxGuardsOID_S)
		SetSliderDialogStartValue(TollDodgeMaxGuards)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(1.0, 10.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == TollDodgeDetectDistMaxOID_S)
		SetSliderDialogStartValue(GuardSpotDistNom)
		SetSliderDialogDefaultValue(512.0)
		SetSliderDialogRange(0.0, 4096.0)
		SetSliderDialogInterval(64.0)
	ElseIf (option == TollDodgeDetectDistTownMaxOID_S)
		SetSliderDialogStartValue(GuardSpotDistTown)
		SetSliderDialogDefaultValue(1024.0)
		SetSliderDialogRange(0.0, 4096.0)
		SetSliderDialogInterval(64.0)
	ElseIf (option == TollDodgeDisguiseBodyPenaltyOID_S)
		SetSliderDialogStartValue(TollDodgeDisguiseBodyPenalty * 100.0)
		SetSliderDialogDefaultValue(75.0)
		SetSliderDialogRange(0.0, 300.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == TollDodgeDisguiseHeadPenaltyOID_S)
		SetSliderDialogStartValue(TollDodgeDisguiseHeadPenalty * 100.0)
		SetSliderDialogDefaultValue(75.0)
		SetSliderDialogRange(0.0, 300.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == TollDodgeItemValueModOID_S)
		SetSliderDialogStartValue(TollDodgeItemValueMod)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.01)
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewBeginOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0EAB5A, "SL Survival.esp") as GlobalVariable).GetValue())
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewEndOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0EAB5B, "SL Survival.esp") as GlobalVariable).GetValue())
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewSlavetownBeginOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0EE155, "SL Survival.esp") as GlobalVariable).GetValue())
		SetSliderDialogDefaultValue(18.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewSlavetownEndOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0EE156, "SL Survival.esp") as GlobalVariable).GetValue())
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)

	; Licences
	ElseIf (option == EnforcerRespawnDurOID_S)
		SetSliderDialogStartValue(EnforcerRespawnDur)
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(0.5)
	ElseIf (option == TradeRestrictBribeOID_S)
		SetSliderDialogStartValue(TradeRestrictBribe)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 1000.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == LicUnlockCostOID_S)
		SetSliderDialogStartValue(_SLS_LicUnlockCost.GetValueInt())
		SetSliderDialogDefaultValue(5000.0)
		SetSliderDialogRange(100.0, 100000.0)
		SetSliderDialogInterval(100.0)
	ElseIf (option == LicBlockChanceOID_S)
		SetSliderDialogStartValue(LicBlockChance)
		SetSliderDialogDefaultValue(70.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == LicFactionDiscountOID_S)
		SetSliderDialogStartValue(LicUtil.LicFactionDiscount * 100.0)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == EnforcersMinOID_S)
		SetSliderDialogStartValue(EnforcersMin)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, EnforcersMax)
		SetSliderDialogInterval(1.0)
	ElseIf (option == EnforcersMaxOID_S)
		SetSliderDialogStartValue(EnforcersMax)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(EnforcersMin, 5.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == PersistentEnforcersOID_S)
		SetSliderDialogStartValue(_SLS_LicInspPersistence.GetValueInt())
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
	
	ElseIf (option == LicShortDurOID_S)
		SetSliderDialogStartValue(LicUtil.LicShortDur)
		SetSliderDialogDefaultValue(7.0)
		SetSliderDialogRange(1.0, 1000.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == LicLongDurOID_S)
		SetSliderDialogStartValue(LicUtil.LicLongDur)
		SetSliderDialogDefaultValue(28.0)
		SetSliderDialogRange(1.0, 1000.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == LicWeapShortCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostWeaponShort)
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicWeapLongCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostWeaponLong)
		SetSliderDialogDefaultValue(3000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicWeapPerCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostWeaponPer)
		SetSliderDialogDefaultValue(15000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicCurfewShortCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostCurfewShort)
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicCurfewLongCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostCurfewLong)
		SetSliderDialogDefaultValue(3000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicCurfewPerCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostCurfewPer)
		SetSliderDialogDefaultValue(20000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicWhoreShortCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostWhoreShort)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicWhoreLongCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostWhoreLong)
		SetSliderDialogDefaultValue(300.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicWhorePerCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostWhorePer)
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)

	ElseIf Option == StorageUtil.GetIntValue(Self, "LicPropertyShortCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostPropertyShort)
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicPropertyLongCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostPropertyLong)
		SetSliderDialogDefaultValue(6000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicPropertyPerCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostPropertyPer)
		SetSliderDialogDefaultValue(100000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicFreedomShortCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostFreedomShort)
		SetSliderDialogDefaultValue(500.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicFreedomLongCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostFreedomLong)
		SetSliderDialogDefaultValue(5000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicFreedomPerCostOID_S")
		SetSliderDialogStartValue(LicUtil.LicCostFreedomPer)
		SetSliderDialogDefaultValue(250000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)

	ElseIf (option == LicMagicShortCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostMagicShort)
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicMagicLongCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostMagicLong)
		SetSliderDialogDefaultValue(3000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicMagicPerCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostMagicPer)
		SetSliderDialogDefaultValue(20000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
		
	ElseIf (option == LicArmorShortCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostArmorShort)
		SetSliderDialogDefaultValue(3000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicArmorLongCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostArmorLong)
		SetSliderDialogDefaultValue(9000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicArmorPerCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostArmorPer)
		SetSliderDialogDefaultValue(30000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
		
	ElseIf (option == LicBikiniHeelHeightOID_S)
		SetSliderDialogStartValue(BikiniCurse.HeelHeightRequired)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicBikiniBreathChanceOID_S")
		SetSliderDialogStartValue(StorageUtil.GetFloatValue(None, "_SLS_LicBikOutOfBreathAnimChance", Missing = 60.0))
		SetSliderDialogDefaultValue(60.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == LicBikiniShortCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostBikiniShort)
		SetSliderDialogDefaultValue(1000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicBikiniLongCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostBikiniLong)
		SetSliderDialogDefaultValue(3000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicBikiniPerCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostBikiniPer)
		SetSliderDialogDefaultValue(15000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
		
	ElseIf (option == LicClothesShortCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostClothesShort)
		SetSliderDialogDefaultValue(500.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicClothesLongCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostClothesLong)
		SetSliderDialogDefaultValue(1500.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
	ElseIf (option == LicClothesPerCostOID_S)
		SetSliderDialogStartValue(LicUtil.LicCostClothesPer)
		SetSliderDialogDefaultValue(10000.0)
		SetSliderDialogRange(50.0, 100000.0)
		SetSliderDialogInterval(50.0)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewRestartDelayOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).TimeToClearStreets)
		SetSliderDialogDefaultValue(60.0)
		SetSliderDialogRange(10.0, 300.0)
		SetSliderDialogInterval(10.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewBeginOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x07B44C, "SL Survival.esp") as GlobalVariable).GetValue())
		SetSliderDialogDefaultValue(21.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewEndOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x07B44D, "SL Survival.esp") as GlobalVariable).GetValue())
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewSlavetownBeginOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0ECBC0, "SL Survival.esp") as GlobalVariable).GetValue())
		SetSliderDialogDefaultValue(19.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewSlavetownEndOID_S")
		SetSliderDialogStartValue((Game.GetFormFromFile(0x0ECBC1, "SL Survival.esp") as GlobalVariable).GetValue())
		SetSliderDialogDefaultValue(9.0)
		SetSliderDialogRange(0.0, 24.0)
		SetSliderDialogInterval(1.0)

	; Stashes
	ElseIf (option == RoadDistOID_S)
		SetSliderDialogStartValue(RoadDist)
		SetSliderDialogDefaultValue(3072.0)
		SetSliderDialogRange(0.0, 5120.0)
		SetSliderDialogInterval(256.0)
	ElseIf (option == StealXItemsOID_S)
		SetSliderDialogStartValue(StealXItems)
		SetSliderDialogDefaultValue(3.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(1.0)
	
	; Begging
	ElseIf (option == BegNumItemsOID_S)
		SetSliderDialogStartValue(BegNumItems)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == BegGoldOID_S)
		SetSliderDialogStartValue(BegGold)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 3.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == BegMwaCurseChanceOID_S)
		SetSliderDialogStartValue(BegMwaCurseChance)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == KennelSafeCellCostOID_S)
		SetSliderDialogStartValue(KennelSafeCellCost)
		SetSliderDialogDefaultValue(40.0)
		SetSliderDialogRange(0.0, 200.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == KennelCreatureChanceOID_S)
		SetSliderDialogStartValue(KennelCreatureChance)
		SetSliderDialogDefaultValue(50.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == KennelRapeChancePerHourOID_S)
		SetSliderDialogStartValue(KennelRapeChancePerHour)
		SetSliderDialogDefaultValue(20.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == KennelSlaveRapeTimeMinOID_S)
		SetSliderDialogStartValue(KennelSlaveRapeTimeMin)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(-1.0, KennelSlaveRapeTimeMax)
		SetSliderDialogInterval(1.0)
	ElseIf (option == KennelSlaveRapeTimeMaxOID_S)
		SetSliderDialogStartValue(KennelSlaveRapeTimeMax)
		SetSliderDialogDefaultValue(40.0)
		SetSliderDialogRange(KennelSlaveRapeTimeMin, 600.0)
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMinOID_S")
		SetSliderDialogStartValue(StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMin", Missing = 2))
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0, StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMax", Missing = 6))
		SetSliderDialogInterval(1.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMaxOID_S")
		SetSliderDialogStartValue(StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMax", Missing = 2))
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMin", Missing = 2), 10)
		SetSliderDialogInterval(1.0)
	

	; Bikini Armors
	ElseIf (option == BikiniDropsVendorCityOID_S)
		SetSliderDialogStartValue(BikiniDropsVendorCity)
		SetSliderDialogDefaultValue(30.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == BikiniDropsVendorTownOID_S)
		SetSliderDialogStartValue(BikiniDropsVendorTown)
		SetSliderDialogDefaultValue(16.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == BikiniDropsVendorKhajiitOID_S)
		SetSliderDialogStartValue(BikiniDropsVendorKhajiit)
		SetSliderDialogDefaultValue(12.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == BikiniDropsChestOID_S)
		SetSliderDialogStartValue(BikiniDropsChest)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	ElseIf (option == BikiniDropsChestOrnateOID_S)
		SetSliderDialogStartValue(BikiniDropsChestOrnate)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
		
	ElseIf (option == BikiniExpPerLevelOID_S)
		SetSliderDialogStartValue(BikiniExp.ExpPerLevel)
		SetSliderDialogDefaultValue(100.0)
		SetSliderDialogRange(10.0, 1000.0)
		SetSliderDialogInterval(10.0)
	ElseIf (option == BikiniExpTrainOID_S)
		SetSliderDialogStartValue(BikTrainingSpeed)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	ElseIf (option == BikiniExpUntrainOID_S)
		SetSliderDialogStartValue(BikUntrainingSpeed)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.0, 10.0)
		SetSliderDialogInterval(0.1)
	
	ElseIf (option == BikiniChanceHideOID_S)
		SetSliderDialogStartValue(BikiniChanceHide)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceLeatherOID_S)
		SetSliderDialogStartValue(BikiniChanceLeather)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceIronOID_S)
		SetSliderDialogStartValue(BikiniChanceIron)
		SetSliderDialogDefaultValue(10.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceSteelOID_S)
		SetSliderDialogStartValue(BikiniChanceSteel)
		SetSliderDialogDefaultValue(11.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceSteelPlateOID_S)
		SetSliderDialogStartValue(BikiniChanceSteelPlate)
		SetSliderDialogDefaultValue(8.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceDwarvenOID_S)
		SetSliderDialogStartValue(BikiniChanceDwarven)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceFalmerOID_S)
		SetSliderDialogStartValue(BikiniChanceFalmer)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceWolfOID_S)
		SetSliderDialogStartValue(BikiniChanceWolf)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceBlades + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceBladesOID_S)
		SetSliderDialogStartValue(BikiniChanceBlades)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceEbony + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceEbonyOID_S)
		SetSliderDialogStartValue(BikiniChanceEbony)
		SetSliderDialogDefaultValue(1.0)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceDragonbone))
		SetSliderDialogInterval(0.5)
	ElseIf (option == BikiniChanceDragonboneOID_S)
		SetSliderDialogStartValue(BikiniChanceDragonbone)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.0, 100.0 - (BikiniChanceHide + BikiniChanceLeather + BikiniChanceIron + BikiniChanceSteel + BikiniChanceSteelPlate + BikiniChanceDwarven + BikiniChanceFalmer + BikiniChanceWolf + BikiniChanceBlades + BikiniChanceEbony))
		SetSliderDialogInterval(0.5)
		
	Else
		; Inn prices
		String InnLoc
		Int i = 0
		While i < LocTrack.InnCosts.Length
			InnLoc = StorageUtil.StringListGet(LocTrack, "_SLS_LocIndex", i)
			If Option == StorageUtil.GetIntValue(Self, "InnCost" + InnLoc + "OID_S")
				SetSliderDialogStartValue(LocTrack.InnCosts[i])
				SetSliderDialogDefaultValue(100.0)
				SetSliderDialogRange(5.0, 1000.0)
				SetSliderDialogInterval(5.0)
			EndIf
			i += 1
		EndWhile
	EndIf
endEvent

event OnOptionSliderAccept(int option, float value)
	; Settings
	
	If (option == BarefootMagOIS_S)
		BarefootMag = value
		SetSliderOptionValue(BarefootMagOIS_S, BarefootMag)
		DoToggleBarefootSpeed = true
	ElseIf (option == HorseCostOIS_S)
		SurvivalHorseCost = value as Int
		SetSliderOptionValue(HorseCostOIS_S, SurvivalHorseCost)
		SetHorseCost(SurvivalHorseCost)
	ElseIf Option == StorageUtil.GetIntValue(Self, "GrowthWeightGainOID_S")
		StorageUtil.SetFloatValue(Self, "WeightGainPerDay", value)
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "GrowthWeightGainOID_S"), value)
		StorageUtil.SetIntValue(Self, "DoToggleGrowth", 1)
	ElseIf Option == StorageUtil.GetIntValue(Self, "PushCooldownOID_S")
		(Game.GetFormFromFile(0x0E651A, "SL Survival.esp") as _SLS_PushPlayerCooloff).CooloffPeriod = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "PushCooldownOID_S"), (Game.GetFormFromFile(0x0E651A, "SL Survival.esp") as _SLS_PushPlayerCooloff).CooloffPeriod)
	ElseIf (option == CatCallVolOIS_S)
		CatCallVol = value
		SetSliderOptionValue(CatCallVolOIS_S, CatCallVol)
		DoToggleCatCalling = true
	ElseIf (option == CatCallWillLossOIS_S)
		CatCallWillLoss = value
		SetSliderOptionValue(CatCallWillLossOIS_S, CatCallWillLoss)
	ElseIf (option == GreetDistOIS_S)
		GreetDist = value
		SetSliderOptionValue(GreetDistOIS_S, GreetDist)
		Game.SetGameSettingFloat("fAIMinGreetingDistance", GreetDist)
	ElseIf (option == ReplaceMapsTimerOID_S)
		ReplaceMapsTimer = value
		SetSliderOptionValue(ReplaceMapsTimerOID_S, ReplaceMapsTimer)
	ElseIf (option == GoldWeightOID_S)
		GoldWeight = value
		SetSliderOptionValue(GoldWeightOID_S, GoldWeight)
		Gold001.SetWeight(GoldWeight)
	ElseIf (option == FolGoldStealChanceOID_S)
		FolGoldStealChance = value as Int
		SetSliderOptionValue(FolGoldStealChanceOID_S, FolGoldStealChance)
	ElseIf (option == FolGoldSteamAmountOID_S)
		FolGoldSteamAmount = value as int
		SetSliderOptionValue(FolGoldSteamAmountOID_S, FolGoldSteamAmount)
	ElseIf (option == SlaverunAutoMinOID_S)
		If value > 0.0
			If value > SlaverunAutoMax
				Debug.Messagebox("Min can not be greater than max")
			Else
				SlaverunAutoMin = value
				SetSliderOptionValue(SlaverunAutoMinOID_S, SlaverunAutoMin)
				DoSlaverunInitOnClose = true
			EndIf
		Else
			If ShowMessage("Are you sure you want to start Slaverun now?")
				SlaverunAutoMin = 0.0
				SlaverunAutoMax = 0.0
				DoSlaverunInitOnClose = true
			EndIf
		EndIf
	ElseIf (option == SlaverunAutoMaxOID_S)
		If value < SlaverunAutoMin
			Debug.Messagebox("Max can not be less than min")
		Else
			SlaverunAutoMax = value
			SetSliderOptionValue(SlaverunAutoMaxOID_S, SlaverunAutoMax)
			DoSlaverunInitOnClose = true
		EndIf
	
	ElseIf (option == HalfNakedBraOID_S)
		HalfNakedBra = value as Int
		SetSliderOptionValue(HalfNakedBraOID_S, value)
		CheckHalfNakedCover()
	ElseIf (option == HalfNakedPantyOID_S)
		HalfNakedPanty = value as Int
		SetSliderOptionValue(HalfNakedPantyOID_S, value)
		CheckHalfNakedCover()
	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifBreastScaleMaxOID_S")
		Main.Slif.ScaleMaxBreasts = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "SlifBreastScaleMaxOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifBellyScaleMaxOID_S")
		Main.Slif.ScaleMaxBelly = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "SlifBellyScaleMaxOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "SlifAssScaleMaxOID_S")
		Main.Slif.ScaleMaxAss = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "SlifAssScaleMaxOID_S"), value)
	ElseIf (option == AssSlapResistLossOID_S)
		AssSlapResistLoss = value
		SetSliderOptionValue(AssSlapResistLossOID_S, AssSlapResistLoss)
	ElseIf (option == ProxSpankCooloffOID_S)
		ProxSpankCooloff = value
		SetSliderOptionValue(ProxSpankCooloffOID_S, ProxSpankCooloff)
	ElseIf (option == SexExpCorruptionCurrentOID_S)
		StorageUtil.SetIntValue(None, "_SLS_CreatureCorruption", value as Int)
		SetSliderOptionValue(SexExpCorruptionCurrentOID_S, value)
	ElseIf (option == CockSizeBonusEnjFreqOID_S)
		CockSizeBonusEnjFreq = value
		SetSliderOptionValue(CockSizeBonusEnjFreqOID_S, value)
	ElseIf (option == RapeForcedSkoomaChanceOID_S)
		RapeForcedSkoomaChance = value
		SetSliderOptionValue(RapeForcedSkoomaChanceOID_S, value)
	ElseIf (option == RapeMinArousalOID_S)
		RapeMinArousal = value
		SetSliderOptionValue(RapeMinArousalOID_S, value)
	ElseIf (option == SexMinStaminaRateOID_S)
		SexMinStaminaRate = value
		SetSliderOptionValue(SexMinStaminaRateOID_S, SexMinStaminaRate)
	ElseIf (option == SexMinStaminaMultOID_S)
		SexMinStaminaMult = value
		SetSliderOptionValue(SexMinStaminaMultOID_S, SexMinStaminaMult)
	ElseIf (option == SexMinMagickaRateOID_S)
		SexMinMagickaRate = value
		SetSliderOptionValue(SexMinMagickaRateOID_S, SexMinMagickaRate)
	ElseIf (option == SexMinMagickaMultOID_S)
		SexMinMagickaMult = value
		SetSliderOptionValue(SexMinMagickaMultOID_S, SexMinMagickaMult)

	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutChanceOID_S")
		FashionRape.HaircutChance = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "FashionRapeHairCutChanceOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHaircutMinOID_S")
		FashionRape.HaircutMinLevel = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "FashionRapeHairCutMinOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHaircutMaxOID_S")
		FashionRape.HaircutMaxLevel = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "FashionRapeHairCutMaxOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeHairCutFloorOID_S")
		FashionRape.HaircutFloor = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "FashionRapeHairCutFloorOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeDyeHairChanceOID_S")
		FashionRape.DyeHairChance = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "FashionRapeDyeHairChanceOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeShavePussyChanceOID_S")
		FashionRape.ShavePussyChance = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "FashionRapeShavePussyChanceOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeLipstickChanceOID_S")
		FashionRape.SmudgeLipstickChance = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "FashionRapeLipstickChanceOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "FashionRapeEyeshadowChanceOID_S")
		FashionRape.SmudgeEyeshadowChance = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "FashionRapeEyeshadowChanceOID_S"), value)

	ElseIf (option == IneqStatsValOID)
		IneqStatsVal = value
		SetSliderOptionValue(IneqStatsValOID, value)
		_SLS_IneqDebuffPlusCushion.SetValue(IneqStatsVal + IneqHealthCushion)
		DoInequalityRefresh = true
	ElseIf (option == IneqHealthCushionOID)
		IneqHealthCushion = value
		SetSliderOptionValue(IneqHealthCushionOID, value)
		_SLS_IneqDebuffPlusCushion.SetValue(IneqStatsVal + IneqHealthCushion)
		DoInequalityRefresh = true
	ElseIf (option == IneqCarryValOID)
		IneqCarryVal = value
		SetSliderOptionValue(IneqCarryValOID, value)
		DoInequalityRefresh = true
	ElseIf (option == IneqSpeedValOID)
		IneqSpeedVal = value
		SetSliderOptionValue(IneqSpeedValOID, value)
		DoInequalityRefresh = true
	ElseIf (option == IneqDamageValOID)
		IneqDamageVal = value
		SetSliderOptionValue(IneqDamageValOID, value)
		DoInequalityRefresh = true
	ElseIf (option == IneqDestValOID)
		IneqDestVal = value
		SetSliderOptionValue(IneqDestValOID, value)
		DoInequalityRefresh = true
	ElseIf (option == IneqVendorGoldOID)
		IneqFemaleVendorGoldMult = value
		SetSliderOptionValue(IneqVendorGoldOID, value)
		Main.IneqVendorGoldUpdate()
		
	ElseIf (option == CumIsLactacidOID_S)
		CumIsLactacid = (value / 100.0)
		SetSliderOptionValue(CumIsLactacidOID_S, value)
	ElseIf (option == AproTwoTrollHealAmountOID)
		AproTwoTrollHealAmount = value as Int
		SetSliderOptionValue(AproTwoTrollHealAmountOID, AproTwoTrollHealAmount)
		
	ElseIf (option == AfCooloffBaseOID_S)
		AnimalFriend.BreedingCooloffBase = value
		SetSliderOptionValue(AfCooloffBaseOID_S, AnimalFriend.BreedingCooloffBase)
	ElseIf (option == AfCooloffBodyCumOID_S)
		AnimalFriend.BreedingCooloffCumCovered = value
		SetSliderOptionValue(AfCooloffBodyCumOID_S, AnimalFriend.BreedingCooloffCumCovered)
	ElseIf (option == AfCooloffCumInflationOID_S)
		AnimalFriend.BreedingCooloffCumFilled = value
		SetSliderOptionValue(AfCooloffCumInflationOID_S, AnimalFriend.BreedingCooloffCumFilled)
	ElseIf (option == AfCooloffPregnancyOID_S)
		AnimalFriend.BreedingCooloffPregnancy = value
		SetSliderOptionValue(AfCooloffPregnancyOID_S, AnimalFriend.BreedingCooloffPregnancy)
	ElseIf (option == AfCooloffCumSwallowOID_S)
		AnimalFriend.SwallowBonus = value
		SetSliderOptionValue(AfCooloffCumSwallowOID_S, AnimalFriend.SwallowBonus)

	ElseIf Option == StorageUtil.GetIntValue(Self, "CompulsiveSexFuckTimeOID_S")
		(Game.GetFormFromFile(0x0E7553, "SL Survival.esp") as _SLS_CompulsiveSex).TimeBetweenFucks = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "CompulsiveSexFuckTimeOID_S"), (Game.GetFormFromFile(0x0E7553, "SL Survival.esp") as _SLS_CompulsiveSex).TimeBetweenFucks)
	ElseIf Option == StorageUtil.GetIntValue(Self, "OrgasmFatigueThresholdOID_S")
		(Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmThreshold = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "OrgasmFatigueThresholdOID_S"), (Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmThreshold)
	ElseIf Option == StorageUtil.GetIntValue(Self, "OrgasmFatigueRecoveryOID_S")
		(Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmRecoveryPerHour = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "OrgasmFatigueRecoveryOID_S"), (Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmRecoveryPerHour)

	ElseIf (option == DflowResistLossOID_S)
		DflowResistLoss = value
		SetSliderOptionValue(DflowResistLossOID_S, DflowResistLoss)
		
	ElseIf (option == DeviousGagDebuffOID_S)
		DeviousGagDebuff = value
		SetSliderOptionValue(DeviousGagDebuffOID_S, DeviousGagDebuff)
		SetGagSpeechDebuff()
	ElseIf (option == BondFurnMilkFreqOID_S)
		BondFurnMilkFreq = value
		SetSliderOptionValue(BondFurnMilkFreqOID_S, BondFurnMilkFreq)
	ElseIf (option == BondFurnMilkFatigueMultOID_S)
		BondFurnMilkFatigueMult = value
		SetSliderOptionValue(BondFurnMilkFatigueMultOID_S, BondFurnMilkFatigueMult)
	ElseIf (option == BondFurnMilkWillOID_S)
		BondFurnMilkWill = value as Int
		SetSliderOptionValue(BondFurnMilkWillOID_S, BondFurnMilkWill)
	ElseIf (option == BondFurnFreqOID_S)
		BondFurnFreq = value
		SetSliderOptionValue(BondFurnFreqOID_S, BondFurnFreq)
	ElseIf (option == BondFurnFatigueMultOID_S)
		BondFurnFatigueMult = value
		SetSliderOptionValue(BondFurnFatigueMultOID_S, BondFurnFatigueMult)
	ElseIf (option == BondFurnWillOID_S)
		BondFurnWill = value as Int
		SetSliderOptionValue(BondFurnWillOID_S, BondFurnWill)

	ElseIf (option == CumSwallowInflateMultOID_S)
		CumSwallowInflateMult = value
		SetSliderOptionValue(CumSwallowInflateMultOID_S, CumSwallowInflateMult)
	ElseIf (option == CumEffectsMagMultOID_S)
		CumEffectsMagMult = value
		SetSliderOptionValue(CumEffectsMagMultOID_S, CumEffectsMagMult)
	ElseIf (option == CumEffectsDurMultOID_S)
		CumEffectsDurMult = value
		SetSliderOptionValue(CumEffectsDurMultOID_S, CumEffectsDurMult)
	ElseIf (option == CumpulsionChanceOID_S)
		CumpulsionChance = value
		SetSliderOptionValue(CumpulsionChanceOID_S, CumpulsionChance)
	ElseIf (option == CumRegenTimeOID_S)
		CumRegenTime = value
		SetSliderOptionValue(CumRegenTimeOID_S, CumRegenTime)
	ElseIf (option == CumEffectVolThresOID_S)
		CumEffectVolThres = value
		SetSliderOptionValue(CumEffectVolThresOID_S, CumEffectVolThres)
	ElseIf (option == SuccubusCumSwallowEnergyMultOID_S)
		SuccubusCumSwallowEnergyMult = value
		SetSliderOptionValue(SuccubusCumSwallowEnergyMultOID_S, SuccubusCumSwallowEnergyMult)
	ElseIf (option == CumAddictHungerRateOID_S)
		CumAddictionHungerRate = value
		SetSliderOptionValue(CumAddictHungerRateOID_S, CumAddictionHungerRate)
	ElseIf (option == CumAddictionSpeedOID_S)
		CumAddictionSpeed = value
		SetSliderOptionValue(CumAddictionSpeedOID_S, CumAddictionSpeed)
	ElseIf (option == CumAddictionPerHourOID_S)
		CumAddictionDecayPerHour = value
		SetSliderOptionValue(CumAddictionPerHourOID_S, CumAddictionDecayPerHour)
	ElseIf (option == CumSatiationOID_S)
		CumSatiation = value
		SetSliderOptionValue(CumSatiationOID_S, CumSatiation)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CumAddictDayDreamVolOID_S")
		StorageUtil.SetFloatValue(Self, "CumAddictDayDreamVol", (value / 100.0))
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "CumAddictDayDreamVolOID_S"), value)
		
	ElseIf (option == CumAddictBatheRefuseTimeOID_S)
		CumAddictBatheRefuseTime = value
		SetSliderOptionValue(CumAddictBatheRefuseTimeOID_S, CumAddictBatheRefuseTime)
	ElseIf (option == CumAddictReflexSwallowOID_S)
		CumAddictReflexSwallow = value
		SetSliderOptionValue(CumAddictReflexSwallowOID_S, CumAddictReflexSwallow)
	ElseIf (option == CumAddictAutoSuckCreatureOID_S)
		CumAddictAutoSuckCreature = value
		SetSliderOptionValue(CumAddictAutoSuckCreatureOID_S, CumAddictAutoSuckCreature)
		DoToggleCumAddictAutoSuckCreature = true
	ElseIf (option == CumAddictAutoSuckCooldownOID_S)
		CumAddictAutoSuckCooldown = value
		SetSliderOptionValue(CumAddictAutoSuckCooldownOID_S, CumAddictAutoSuckCooldown)
	ElseIf (option == CumAddictAutoSuckCreatureArousalOID_S)
		CumAddictAutoSuckCreatureArousal = value
		SetSliderOptionValue(CumAddictAutoSuckCreatureArousalOID_S, CumAddictAutoSuckCreatureArousal)
		
	ElseIf (option == MinSpeedOID_S)
		MinSpeedMult = value
		SetSliderOptionValue(MinSpeedOID_S, MinSpeedMult)
	ElseIf (option == MinCarryWeightOID_S)
		MinCarryWeight = value
		SetSliderOptionValue(MinCarryWeightOID_S, MinCarryWeight)
		
	ElseIf (option == PpGoldLowChanceOID_S)
		PpGoldLowChance = value
		SetSliderOptionValue(PpGoldLowChanceOID_S, PpGoldLowChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpGoldModerateChanceOID_S)
		PpGoldModerateChance = value
		SetSliderOptionValue(PpGoldModerateChanceOID_S, PpGoldModerateChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpGoldHighChanceOID_S)
		PpGoldHighChance = value
		SetSliderOptionValue(PpGoldHighChanceOID_S, PpGoldHighChance)
		DoPpLvlListbuildOnClose = true

	ElseIf (option == PpLootMinOID_S)
		Util.PpLootLootMin = value as Int
		SetSliderOptionValue(PpLootMinOID_S, Util.PpLootLootMin)
	ElseIf (option == PpLootMaxOID_S)
		Util.PpLootLootMax = value as Int
		SetSliderOptionValue(PpLootMaxOID_S, Util.PpLootLootMax)

	ElseIf (option == PpLootFoodChanceOID_S)
		PpLootFoodChance = value
		SetSliderOptionValue(PpLootFoodChanceOID_S, PpLootFoodChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpLootGemsChanceOID_S)
		PpLootGemsChance = value
		SetSliderOptionValue(PpLootGemsChanceOID_S, PpLootGemsChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpLootSoulgemsChanceOID_S)
		PpLootSoulgemsChance = value
		SetSliderOptionValue(PpLootSoulgemsChanceOID_S, PpLootSoulgemsChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpLootJewelryChanceOID_S)
		PpLootJewelryChance = value
		SetSliderOptionValue(PpLootJewelryChanceOID_S, PpLootJewelryChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpLootEnchJewelryChanceOID_S)
		PpLootEnchJewelryChance = value
		SetSliderOptionValue(PpLootEnchJewelryChanceOID_S, PpLootEnchJewelryChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpLootPotionsChanceOID_S)
		PpLootPotionsChance = value
		SetSliderOptionValue(PpLootPotionsChanceOID_S, PpLootPotionsChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpLootKeysChanceOID_S)
		PpLootKeysChance = value
		SetSliderOptionValue(PpLootKeysChanceOID_S, PpLootKeysChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpLootTomesChanceOID_S)
		PpLootTomesChance = value
		SetSliderOptionValue(PpLootTomesChanceOID_S, PpLootTomesChance)
		DoPpLvlListbuildOnClose = true
	ElseIf (option == PpLootCureChanceOID_S)
		PpLootCureChance = value
		SetSliderOptionValue(PpLootCureChanceOID_S, PpLootCureChance)
		DoPpLvlListbuildOnClose = true
	
	ElseIf (option == PpCrimeGoldOID_S)
		PpCrimeGold = value as Int
		SetSliderOptionValue(PpCrimeGoldOID_S, PpCrimeGold)
		Game.SetGameSettingInt("iCrimeGoldPickpocket", PpCrimeGold)
	ElseIf (option == PpFailDevicesOID_S)
		PpFailDevices = value as Int
		SetSliderOptionValue(PpFailDevicesOID_S, PpFailDevices)
	ElseIf (option == PpFailStealValueOID_S)
		_SLS_PickPocketFailStealValue.SetValueInt(value as Int)
		SetSliderOptionValue(PpFailStealValueOID_S, value)
	ElseIf (option == PpFailDrugCountOID_S)
		PpFailDrugCount = value as Int
		SetSliderOptionValue(PpFailDrugCountOID_S, PpFailDrugCount)
	
	ElseIf (option == DismemberCooldownOID_S)
		DismemberCooldown = value
		SetSliderOptionValue(DismemberCooldownOID_S, value)
	ElseIf (option == DismemberMaxAmpedLimbsOID_S)
		MaxAmpedLimbs = value as Int
		SetSliderOptionValue(DismemberMaxAmpedLimbsOID_S, value)
	ElseIf (option == DismemberArmorBonusOID_S)
		DismemberArmorBonus = value
		SetSliderOptionValue(DismemberArmorBonusOID_S, value)
	ElseIf (option == DismemberChanceOID_S)
		DismemberChance = value
		SetSliderOptionValue(DismemberChanceOID_S, value)
	ElseIf (option == DismemberDamageThresOID_S)
		DismemberDamageThres = value as Int
		SetSliderOptionValue(DismemberDamageThresOID_S, value)
	ElseIf (option == DismemberHealthThresOID_S)
		DismemberHealthThres = value
		SetSliderOptionValue(DismemberHealthThresOID_S, value)
	ElseIf (option == AmpPriestHealCostOID_S)
		_SLS_AmpPriestHealCost.SetValueInt(value as Int)
		SetSliderOptionValue(AmpPriestHealCostOID_S, value)
		_SLS_AmputationQuest.UpdateCurrentInstanceGlobal(_SLS_AmpPriestHealCost)
	
	; Simply Knock
	ElseIf (option == KnockSlaveryChanceOID_S)
		KnockSlaveryChance = value
		SetSliderOptionValue(KnockSlaveryChanceOID_S, KnockSlaveryChance)
	ElseIf (option == SimpleSlaveryWeightOID_S)
		SimpleSlaveryWeight = value
		SetSliderOptionValue(SimpleSlaveryWeightOID_S, SimpleSlaveryWeight)
		
		SdWeight = 100.0 - SimpleSlaveryWeight
		SetSliderOptionValue(SdWeightOID_S, SdWeight)
	ElseIf (option == SdWeightOID_S)
		SdWeight = value
		SetSliderOptionValue(SdWeightOID_S, SdWeight)
		SimpleSlaveryWeight = 100.0 - SdWeight
		SetSliderOptionValue(SimpleSlaveryWeightOID_S, SimpleSlaveryWeight)
		
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPainSoundVolOID_S")
		Util.PainSoundVol = value / 100.0
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaPainSoundVolOID_S"), Util.PainSoundVol * 100.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHitSoundVolOID_S")
		Util.HitSoundVol = value / 100.0
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaHitSoundVolOID_S"), Util.HitSoundVol * 100.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxPlayerOID_S")
		Trauma.PlayerTraumaCountMax = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaCountMaxPlayerOID_S"), Trauma.PlayerTraumaCountMax)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxFollowerOID_S")
		Trauma.FollowerTraumaCountMax = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaCountMaxFollowerOID_S"), Trauma.FollowerTraumaCountMax)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCountMaxNpcOID_S")
		Trauma.NpcTraumaCountMax = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaCountMaxNpcOID_S"), Trauma.NpcTraumaCountMax)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaStartingOpacityOID_S")
		Trauma.StartingAlpha = value / 100.0
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaStartingOpacityOID_S"), Trauma.StartingAlpha * 100.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaMaximumOpacityOID_S")
		Trauma.MaxAlpha = value / 100.0
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaMaximumOpacityOID_S"), Trauma.MaxAlpha * 100.0)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHoursToFadeInOID_S")
		Trauma.HoursToMaxAlpha = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaHoursToFadeInOID_S"), Trauma.HoursToMaxAlpha)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaHoursToFadeOutOID_S")
		Trauma.HoursToFadeOut = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaHoursToFadeOutOID_S"), Trauma.HoursToFadeOut)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChancePlayerOID_S")
		Trauma.SexChancePlayer = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaSexChancePlayerOID_S"), Trauma.SexChancePlayer)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChanceFollowerOID_S")
		Trauma.SexChanceFollower = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaSexChanceFollowerOID_S"), Trauma.SexChanceFollower)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexChanceOID_S")
		Trauma.SexChanceNpc = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaSexChanceOID_S"), Trauma.SexChanceNpc)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsPlayerOID_S")
		Trauma.SexHitsPlayer = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaSexHitsPlayerOID_S"), Trauma.SexHitsPlayer)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsFollowerOID_S")
		Trauma.SexHitsFollower = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaSexHitsFollowerOID_S"), Trauma.SexHitsFollower)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaSexHitsOID_S")
		Trauma.SexHitsNpc = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaSexHitsOID_S"), Trauma.SexHitsNpc)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaDamageThresholdOID_S")
		Trauma.CombatDamageThreshold = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaDamageThresholdOID_S"), Trauma.CombatDamageThreshold)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChancePlayerOID_S")
		If Trauma.CombatChancePlayer != value
			Trauma.CombatChancePlayer = value
			Trauma.ToggleCombatTrauma()
		EndIf
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaCombatChancePlayerOID_S"), Trauma.CombatChancePlayer)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChanceFollowerOID_S")
		If Trauma.CombatChanceFollower != Value
			Trauma.CombatChanceFollower = value
			Trauma.ToggleCombatTrauma()
		EndIf
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaCombatChanceFollowerOID_S"), Trauma.CombatChanceFollower)
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaCombatChanceOID_S")
		If Trauma.CombatChanceNpc != Value
			Trauma.CombatChanceNpc = value
			Trauma.ToggleCombatTrauma()
		EndIf
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaCombatChanceOID_S"), Trauma.CombatChanceNpc)
	
	ElseIf Option == StorageUtil.GetIntValue(Self, "TraumaPushChancePlayerOID_S")
		If Trauma.PushChance != value
			Trauma.SetPushChance()
		EndIf
		Trauma.PushChance = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "TraumaPushChancePlayerOID_S"), Trauma.PushChance)
	
	; RND
	ElseIf (option == GluttedSpeedMultOID_S)
		GluttedSpeed = value
		SetSliderOptionValue(GluttedSpeedMultOID_S, GluttedSpeed)
	ElseIf (option == CumFoodMultOID_S)
		Needs.CumFoodMult = value
		SetSliderOptionValue(CumFoodMultOID_S, Needs.CumFoodMult)
	ElseIf (option == CumDrinkMultOID_S)
		Needs.CumDrinkMult = value
		SetSliderOptionValue(CumDrinkMultOID_S, Needs.CumDrinkMult)
	ElseIf (option == SkoomaSleepOID_S)
		SkoomaSleep = value
		SetSliderOptionValue(SkoomaSleepOID_S, SkoomaSleep)
	ElseIf (option == MilkSleepMultOID_S)
		MilkSleepMult = value
		SetSliderOptionValue(MilkSleepMultOID_S, MilkSleepMult)
	ElseIf (option == DrugEndFatigueIncOID_S)
		DrugEndFatigueInc = value / 100.0
		SetSliderOptionValue(DrugEndFatigueIncOID_S, DrugEndFatigueInc * 100.0)
	
	ElseIf (option == BaseBellyScaleOID_S)
		Needs.BaseBellyScale = value
		SetSliderOptionValue(BaseBellyScaleOID_S, Needs.BaseBellyScale)
		UpdateBellyScale()
	ElseIf (option == BellyScaleRnd00OID_S)
		Rnd.BellyScaleRnd00 = value
		SetSliderOptionValue(BellyScaleRnd00OID_S, Rnd.BellyScaleRnd00)
		UpdateBellyScale()
	ElseIf (option == BellyScaleRnd01OID_S)
		Rnd.BellyScaleRnd01 = value
		SetSliderOptionValue(BellyScaleRnd01OID_S, Rnd.BellyScaleRnd01)
		UpdateBellyScale()
	ElseIf (option == BellyScaleRnd02OID_S)
		Rnd.BellyScaleRnd02 = value
		SetSliderOptionValue(BellyScaleRnd02OID_S, Rnd.BellyScaleRnd02)
		UpdateBellyScale()
	ElseIf (option == BellyScaleRnd03OID_S)
		Rnd.BellyScaleRnd03 = value
		SetSliderOptionValue(BellyScaleRnd03OID_S, Rnd.BellyScaleRnd03)
		UpdateBellyScale()
	ElseIf (option == BellyScaleRnd04OID_S)
		Rnd.BellyScaleRnd04 = value
		SetSliderOptionValue(BellyScaleRnd04OID_S, Rnd.BellyScaleRnd04)
		UpdateBellyScale()
	ElseIf (option == BellyScaleRnd05OID_S)
		Rnd.BellyScaleRnd05 = value
		SetSliderOptionValue(BellyScaleRnd05OID_S, Rnd.BellyScaleRnd05)
		UpdateBellyScale()
		
	ElseIf (option == BellyScaleIneed00OID_S)
		Ineed.BellyScaleIneed00 = value
		SetSliderOptionValue(BellyScaleIneed00OID_S, Ineed.BellyScaleIneed00)
		UpdateBellyScale()
	ElseIf (option == BellyScaleIneed01OID_S)
		Ineed.BellyScaleIneed01 = value
		SetSliderOptionValue(BellyScaleIneed01OID_S, Ineed.BellyScaleIneed01)
		UpdateBellyScale()
	ElseIf (option == BellyScaleIneed02OID_S)
		Ineed.BellyScaleIneed02 = value
		SetSliderOptionValue(BellyScaleIneed02OID_S, Ineed.BellyScaleIneed02)
		UpdateBellyScale()
	ElseIf (option == BellyScaleIneed03OID_S)
		Ineed.BellyScaleIneed03 = value
		SetSliderOptionValue(BellyScaleIneed03OID_S, Ineed.BellyScaleIneed03)
		UpdateBellyScale()

	; Frostfall
	ElseIf (option == WarmBodiesOID_S)
		WarmBodies = -value
		SetSliderOptionValue(WarmBodiesOID_S, -WarmBodies)
	ElseIf (option == MilkLeakWetOID_S)
		MilkLeakWet = value
		SetSliderOptionValue(MilkLeakWetOID_S, MilkLeakWet)
	ElseIf (option == CumWetMultOID_S)
		CumWetMult = value
		SetSliderOptionValue(CumWetMultOID_S, CumWetMult)
	ElseIf (option == CumExposureMultOID_S)
		CumExposureMult = value
		SetSliderOptionValue(CumExposureMultOID_S, CumExposureMult)
	ElseIf (option == SwimCumCleanOID_S)
		SwimCumClean = value as Int
		SetSliderOptionValue(SwimCumCleanOID_S, SwimCumClean)
		
	ElseIf (option == SimpleSlaveryFFOID_S)
		SimpleSlaveryFF = value
		SetSliderOptionValue(SimpleSlaveryFFOID_S, SimpleSlaveryFF)
		
		SdDreamFF = 100.0 - SimpleSlaveryFF
		SetSliderOptionValue(SdDreamFFOID_S, SdDreamFF)
	ElseIf (option == SdDreamFFOID_S)
		SdDreamFF = value
		SetSliderOptionValue(SdDreamFFOID_S, SdDreamFF)
		
		SimpleSlaveryFF = 100.0 - SdDreamFF
		SetSliderOptionValue(SimpleSlaveryFFOID_S, SimpleSlaveryFF)

	; Tolls & Eviction
	ElseIf (option == EvictionLimitOID_S)
		EvictionLimit = value as Int
		SetSliderOptionValue(EvictionLimitOID_S, EvictionLimit)
	ElseIf (option == SlaverunEvictionLimitOID_S)
		SlaverunEvictionLimit = value as Int
		SetSliderOptionValue(SlaverunEvictionLimitOID_S, SlaverunEvictionLimit)
	ElseIf (option == ConfiscationFineOID_S)
		ConfiscationFine = value as Int
		SetSliderOptionValue(ConfiscationFineOID_S, ConfiscationFine)
	ElseIf (option == ConfiscationFineSlaverunOID_S)
		ConfiscationFineSlaverun = value as Int
		SetSliderOptionValue(ConfiscationFineSlaverunOID_S, ConfiscationFineSlaverun)
		
	ElseIf (option == TollCostGoldOID_S)
		TollUtil.TollCostGold = value as Int
		SetSliderOptionValue(TollCostGoldOID_S, TollUtil.TollCostGold)
		;SetTollCost()
	ElseIf (option == SlaverunFactorOID)
		TollUtil.SlaverunFactor = value
		SetSliderOptionValue(SlaverunFactorOID, TollUtil.SlaverunFactor)
		;SetTollCost()
	ElseIf (option == SlaverunJobFactorOID)
		TollUtil.SlaverunJobFactor = value as Int
		SetSliderOptionValue(SlaverunJobFactorOID, TollUtil.SlaverunJobFactor)
	ElseIf (option == TollCostDevicesOID_S)
		TollUtil.TollCostDevices = value as Int
		SetSliderOptionValue(TollCostDevicesOID_S, TollUtil.TollCostDevices)
	ElseIf (option == TollCostTattoosOID_S)
		TollUtil.TollCostTattoos = value as Int
		SetSliderOptionValue(TollCostTattoosOID_S, TollUtil.TollCostTattoos)
	ElseIf (option == TollCostDrugsOID_S)
		TollUtil.TollCostDrugs = value as Int
		SetSliderOptionValue(TollCostDrugsOID_S, TollUtil.TollCostDrugs)
		
	ElseIf (option == MaxTatsBodyOID_S)
		MaxTatsBody = value as Int
		SetSliderOptionValue(MaxTatsBodyOID_S, MaxTatsBody)
	ElseIf (option == MaxTatsFaceOID_S)
		MaxTatsFace = value as Int
		SetSliderOptionValue(MaxTatsFaceOID_S, MaxTatsFace)
	ElseIf (option == MaxTatsHandsOID_S)
		MaxTatsHands = value as Int
		SetSliderOptionValue(MaxTatsHandsOID_S, MaxTatsHands)
	ElseIf (option == MaxTatsFeetOID_S)
		MaxTatsFeet = value as Int
		SetSliderOptionValue(MaxTatsFeetOID_S, MaxTatsFeet)

	ElseIf (option == TollDodgeHuntFreqOID_S)
		TollDodgeHuntFreq = value
		SetSliderOptionValue(TollDodgeHuntFreqOID_S, TollDodgeHuntFreq)
	ElseIf (option == TollDodgeGracePeriodOID_S)
		TollDodgeGracePeriod = value as Int
		SetSliderOptionValue(TollDodgeGracePeriodOID_S, TollDodgeGracePeriod)
	ElseIf (option == TollDodgeMaxGuardsOID_S)
		TollDodgeMaxGuards = value as int
		SetSliderOptionValue(TollDodgeMaxGuardsOID_S, TollDodgeMaxGuards)
	ElseIf (option == TollDodgeDetectDistMaxOID_S)
		GuardSpotDistNom = value
		SetSliderOptionValue(TollDodgeDetectDistMaxOID_S, GuardSpotDistNom)
		RefreshGuardSpotDistance()
	ElseIf (option == TollDodgeDetectDistTownMaxOID_S)
		GuardSpotDistTown = value
		SetSliderOptionValue(TollDodgeDetectDistTownMaxOID_S, GuardSpotDistTown)
		RefreshGuardSpotDistance()
	ElseIf (option == TollDodgeDisguiseBodyPenaltyOID_S)
		TollDodgeDisguiseBodyPenalty = value / 100.0
		SetSliderOptionValue(TollDodgeDisguiseBodyPenaltyOID_S, TollDodgeDisguiseBodyPenalty * 100.0)
		RefreshGuardSpotDistance()
	ElseIf (option == TollDodgeDisguiseHeadPenaltyOID_S)
		TollDodgeDisguiseHeadPenalty = value / 100.0
		SetSliderOptionValue(TollDodgeDisguiseHeadPenaltyOID_S, TollDodgeDisguiseHeadPenalty * 100.0)
		RefreshGuardSpotDistance()
	ElseIf (option == TollDodgeItemValueModOID_S)
		TollDodgeItemValueMod = value
		SetSliderOptionValue(TollDodgeItemValueModOID_S, TollDodgeItemValueMod)
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewBeginOID_S")
		If value > (Game.GetFormFromFile(0x0EAB5B, "SL Survival.esp") as GlobalVariable).GetValue() ; _SLS_GateCurfewEnd
			(Game.GetFormFromFile(0x0EAB5A, "SL Survival.esp") as GlobalVariable).SetValue(value) ; _SLS_GateCurfewBegin
			SetSliderOptionValue(StorageUtil.GetIntValue(Self, "GateCurfewBeginOID_S"), value)
			TollUtil.IsCurfewTimeByLoc(PlayerRef.GetCurrentLocation())
		Else
			Debug.Messagebox("Curfew can not begin before it ends")
		EndIf
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewEndOID_S")
		If value < (Game.GetFormFromFile(0x0EAB5A, "SL Survival.esp") as GlobalVariable).GetValue() ; _SLS_GateCurfewBegin
			(Game.GetFormFromFile(0x0EAB5B, "SL Survival.esp") as GlobalVariable).SetValue(value) ; _SLS_GateCurfewEnd
			SetSliderOptionValue(StorageUtil.GetIntValue(Self, "GateCurfewEndOID_S"), value)
			TollUtil.IsCurfewTimeByLoc(PlayerRef.GetCurrentLocation())
		Else
			Debug.Messagebox("Curfew can not end before it begins")
		EndIf
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewSlavetownBeginOID_S")
		If value > (Game.GetFormFromFile(0x0EE156, "SL Survival.esp") as GlobalVariable).GetValue() ; _SLS_GateCurfewSlavetownEnd
			(Game.GetFormFromFile(0x0EE155, "SL Survival.esp") as GlobalVariable).SetValue(value) ; _SLS_GateCurfewSlavetownBegin
			SetSliderOptionValue(StorageUtil.GetIntValue(Self, "GateCurfewSlavetownBeginOID_S"), value)
			TollUtil.IsCurfewTimeByLoc(PlayerRef.GetCurrentLocation())
		Else
			Debug.Messagebox("Slavetown curfew can not begin before it ends")
		EndIf
	ElseIf Option == StorageUtil.GetIntValue(Self, "GateCurfewSlavetownEndOID_S")
		If value < (Game.GetFormFromFile(0x0EE155, "SL Survival.esp") as GlobalVariable).GetValue() ; _SLS_GateCurfewSlavetownBegin
			(Game.GetFormFromFile(0x0EE156, "SL Survival.esp") as GlobalVariable).SetValue(value) ; _SLS_GateCurfewSlavetownEnd
			SetSliderOptionValue(StorageUtil.GetIntValue(Self, "GateCurfewSlavetownEndOID_S"), value)
			TollUtil.IsCurfewTimeByLoc(PlayerRef.GetCurrentLocation())
		Else
			Debug.Messagebox("Slavetown curfew can not end before it begins")
		EndIf		
	ElseIf (option == TollFollowersOID_S)
		_SLS_TollFollowersRequired.SetValueInt(value as Int)
		SetSliderOptionValue(TollFollowersOID_S, _SLS_TollFollowersRequired.GetValueInt())
		
	; Licences
	ElseIf (option == EnforcerRespawnDurOID_S)
		EnforcerRespawnDur = value
		SetSliderOptionValue(EnforcerRespawnDurOID_S, EnforcerRespawnDur)	
	ElseIf (option == TradeRestrictBribeOID_S)
		TradeRestrictBribe = value as Int
		SetSliderOptionValue(TradeRestrictBribeOID_S, TradeRestrictBribe)
		_SLS_RestrictTradeBribe.SetValueInt(TradeRestrictBribe)
		_SLS_LicenceTradersQuest.UpdateCurrentInstanceGlobal(_SLS_RestrictTradeBribe)
	ElseIf (option == LicUnlockCostOID_S)
		_SLS_LicUnlockCost.SetValueInt(value as Int)
		SetSliderOptionValue(LicUnlockCostOID_S, value)
		_SLS_LicenceQuest.UpdateCurrentInstanceGlobal(_SLS_LicUnlockCost)
	ElseIf (option == LicBlockChanceOID_S)
		LicBlockChance = value
		SetSliderOptionValue(LicBlockChanceOID_S, LicBlockChance)
		ModLicBuyBlock()
	ElseIf (option == LicFactionDiscountOID_S)
		LicUtil.LicFactionDiscount = value/100.0
		SetSliderOptionValue(LicFactionDiscountOID_S, value)

	ElseIf (option == EnforcersMinOID_S)
		EnforcersMin = value as Int
		SetSliderOptionValue(EnforcersMinOID_S, EnforcersMin)
	ElseIf (option == EnforcersMaxOID_S)
		EnforcersMax = value as Int
		SetSliderOptionValue(EnforcersMaxOID_S, EnforcersMax)
	ElseIf (option == PersistentEnforcersOID_S)
		_SLS_LicInspPersistence.SetValueInt(value as Int)
		SetSliderOptionValue(PersistentEnforcersOID_S, value)
		_SLS_LicInspLostSightSpell.SetNthEffectDuration(0, _SLS_LicInspPersistence.GetValueInt())
		
	ElseIf (option == LicShortDurOID_S)
		LicUtil.LicShortDur = value
		SetSliderOptionValue(LicShortDurOID_S, LicUtil.LicShortDur)
	ElseIf (option == LicLongDurOID_S)
		LicUtil.LicLongDur = value
		SetSliderOptionValue(LicLongDurOID_S, MaxTatsFeet)
		
	ElseIf (option == LicWeapShortCostOID_S)
		LicUtil.LicCostWeaponShort = value as Int
		SetSliderOptionValue(LicWeapShortCostOID_S, value)
	ElseIf (option == LicWeapLongCostOID_S)
		LicUtil.LicCostWeaponLong = value as Int
		SetSliderOptionValue(LicWeapLongCostOID_S, value)
	ElseIf (option == LicWeapPerCostOID_S)
		LicUtil.LicCostWeaponPer = value as Int
		SetSliderOptionValue(LicWeapPerCostOID_S, value)

	ElseIf Option == StorageUtil.GetIntValue(Self, "LicCurfewShortCostOID_S")
		LicUtil.LicCostCurfewShort = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicCurfewShortCostOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicCurfewLongCostOID_S")
		LicUtil.LicCostCurfewLong = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicCurfewLongCostOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicCurfewPerCostOID_S")
		LicUtil.LicCostCurfewPer = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicCurfewPerCostOID_S"), value)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicWhoreShortCostOID_S")
		LicUtil.LicCostWhoreShort = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicWhoreShortCostOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicWhoreLongCostOID_S")
		LicUtil.LicCostWhoreLong = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicWhoreLongCostOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicWhorePerCostOID_S")
		LicUtil.LicCostWhorePer = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicWhorePerCostOID_S"), value)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicPropertyShortCostOID_S")
		LicUtil.LicCostPropertyShort = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicPropertyShortCostOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicPropertyLongCostOID_S")
		LicUtil.LicCostPropertyLong = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicPropertyLongCostOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicPropertyPerCostOID_S")
		LicUtil.LicCostPropertyPer = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicPropertyPerCostOID_S"), value)
		
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicFreedomShortCostOID_S")
		LicUtil.LicCostFreedomShort = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicFreedomShortCostOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicFreedomLongCostOID_S")
		LicUtil.LicCostFreedomLong = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicFreedomLongCostOID_S"), value)
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicFreedomPerCostOID_S")
		LicUtil.LicCostFreedomPer = value as Int
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicFreedomPerCostOID_S"), value)

	ElseIf (option == LicMagicShortCostOID_S)
		LicUtil.LicCostMagicShort = value as Int
		SetSliderOptionValue(LicMagicShortCostOID_S, value)
	ElseIf (option == LicMagicLongCostOID_S)
		LicUtil.LicCostMagicLong = value as Int
		SetSliderOptionValue(LicMagicLongCostOID_S, value)
	ElseIf (option == LicMagicPerCostOID_S)
		LicUtil.LicCostMagicPer = value as Int
		SetSliderOptionValue(LicMagicPerCostOID_S, value)
		
	ElseIf (option == LicArmorShortCostOID_S)
		LicUtil.LicCostArmorShort = value as Int
		SetSliderOptionValue(LicArmorShortCostOID_S, value)
	ElseIf (option == LicArmorLongCostOID_S)
		LicUtil.LicCostArmorLong = value as Int
		SetSliderOptionValue(LicArmorLongCostOID_S, value)
	ElseIf (option == LicArmorPerCostOID_S)
		LicUtil.LicCostArmorPer = value as Int
		SetSliderOptionValue(LicArmorPerCostOID_S, value)

	ElseIf (option == LicBikiniHeelHeightOID_S)
		BikiniCurse.HeelHeightRequired = value
		SetSliderOptionValue(LicBikiniHeelHeightOID_S, value)
		DoToggleHeelsRequired = true
	ElseIf Option == StorageUtil.GetIntValue(Self, "LicBikiniBreathChanceOID_S")
		StorageUtil.SetFloatValue(None, "_SLS_LicBikOutOfBreathAnimChance", value)
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "LicBikiniBreathChanceOID_S"), value)
	ElseIf (option == LicBikiniShortCostOID_S)
		LicUtil.LicCostBikiniShort = value as Int
		SetSliderOptionValue(LicBikiniShortCostOID_S, value)
	ElseIf (option == LicBikiniLongCostOID_S)
		LicUtil.LicCostBikiniLong = value as Int
		SetSliderOptionValue(LicBikiniLongCostOID_S, value)
	ElseIf (option == LicBikiniPerCostOID_S)
		LicUtil.LicCostBikiniPer = value as Int
		SetSliderOptionValue(LicBikiniPerCostOID_S, value)
		
	ElseIf (option == LicClothesShortCostOID_S)
		LicUtil.LicCostClothesShort = value as Int
		SetSliderOptionValue(LicClothesShortCostOID_S, value)
	ElseIf (option == LicClothesLongCostOID_S)
		LicUtil.LicCostClothesLong = value as Int
		SetSliderOptionValue(LicClothesLongCostOID_S, value)
	ElseIf (option == LicClothesPerCostOID_S)
		LicUtil.LicCostClothesPer = value as Int
		SetSliderOptionValue(LicClothesPerCostOID_S, value)

	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewRestartDelayOID_S")
		(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).TimeToClearStreets = value
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "CurfewRestartDelayOID_S"), (Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).TimeToClearStreets)
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewBeginOID_S")
		If value > (Game.GetFormFromFile(0x07B44D, "SL Survival.esp") as GlobalVariable).GetValue() ; _SLS_CurfewEnd
			(Game.GetFormFromFile(0x07B44C, "SL Survival.esp") as GlobalVariable).SetValue(value) ; _SLS_CurfewBegin
			SetSliderOptionValue(StorageUtil.GetIntValue(Self, "CurfewBeginOID_S"), value)
			(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).CheckCurfewState()
		Else
			Debug.Messagebox("Curfew can not begin before it ends")
		EndIf
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewEndOID_S")
		If value < (Game.GetFormFromFile(0x07B44C, "SL Survival.esp") as GlobalVariable).GetValue() ; _SLS_CurfewBegin
			(Game.GetFormFromFile(0x07B44D, "SL Survival.esp") as GlobalVariable).SetValue(value) ; _SLS_CurfewEnd
			SetSliderOptionValue(StorageUtil.GetIntValue(Self, "CurfewEndOID_S"), value)
			(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).CheckCurfewState()
		Else
			Debug.Messagebox("Curfew can not end before it begins")
		EndIf
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewSlavetownBeginOID_S")
		If value > (Game.GetFormFromFile(0x0ECBC1, "SL Survival.esp") as GlobalVariable).GetValue() ; _SLS_CurfewSlavetownEnd
			(Game.GetFormFromFile(0x0ECBC0, "SL Survival.esp") as GlobalVariable).SetValue(value) ; _SLS_CurfewSlavetownBegin
			SetSliderOptionValue(StorageUtil.GetIntValue(Self, "CurfewSlavetownBeginOID_S"), value)
			(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).CheckCurfewState()
		Else
			Debug.Messagebox("Slavetown curfew can not begin before it ends")
		EndIf
	ElseIf Option == StorageUtil.GetIntValue(Self, "CurfewSlavetownEndOID_S")
		If value < (Game.GetFormFromFile(0x0ECBC0, "SL Survival.esp") as GlobalVariable).GetValue() ; _SLS_CurfewSlavetownBegin
			(Game.GetFormFromFile(0x0ECBC1, "SL Survival.esp") as GlobalVariable).SetValue(value) ; _SLS_CurfewSlavetownEnd
			SetSliderOptionValue(StorageUtil.GetIntValue(Self, "CurfewSlavetownEndOID_S"), value)
			(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).CheckCurfewState()
		Else
			Debug.Messagebox("Slavetown curfew can not end before it begins")
		EndIf
	
	; Stashes
	ElseIf (option == RoadDistOID_S)
		RoadDist = value
		SetSliderOptionValue(RoadDistOID_S, RoadDist)
	ElseIf (option == StealXItemsOID_S)
		StealXItems = value
		SetSliderOptionValue(StealXItemsOID_S, StealXItems)
		
	; Begging
	ElseIf (option == BegNumItemsOID_S)
		BegNumItems = value as Int
		SetSliderOptionValue(BegNumItemsOID_S, BegNumItems)
	ElseIf (option == BegGoldOID_S)
		BegGold = value
		SetSliderOptionValue(BegGoldOID_S, BegGold)
	ElseIf (option == BegMwaCurseChanceOID_S)
		BegMwaCurseChance = value
		SetSliderOptionValue(BegMwaCurseChanceOID_S, BegMwaCurseChance)
	ElseIf (option == KennelSafeCellCostOID_S)
		KennelSafeCellCost = value as Int
		SetSliderOptionValue(KennelSafeCellCostOID_S, KennelSafeCellCost)
		_SLS_KennelCellCost.SetValueInt(KennelSafeCellCost)
	ElseIf (option == KennelCreatureChanceOID_S)
		KennelCreatureChance = value
		SetSliderOptionValue(KennelCreatureChanceOID_S, KennelCreatureChance)
	ElseIf (option == KennelRapeChancePerHourOID_S)
		KennelRapeChancePerHour = value
		SetSliderOptionValue(KennelRapeChancePerHourOID_S, KennelRapeChancePerHour)
	ElseIf (option == KennelSlaveRapeTimeMinOID_S)
		KennelSlaveRapeTimeMin = value as Int
		SetSliderOptionValue(KennelSlaveRapeTimeMinOID_S, KennelSlaveRapeTimeMin)
	ElseIf (option == KennelSlaveRapeTimeMaxOID_S)
		KennelSlaveRapeTimeMax = value as Int
		SetSliderOptionValue(KennelSlaveRapeTimeMaxOID_S, KennelSlaveRapeTimeMax)
	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMinOID_S")
		StorageUtil.SetIntValue(Self, "KennelSlaveDeviceCountMin", value as Int)
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMinOID_S"), StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMin", Missing = 2))
	ElseIf Option == StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMaxOID_S")
		StorageUtil.SetIntValue(Self, "KennelSlaveDeviceCountMax", value as Int)
		SetSliderOptionValue(StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMaxOID_S"), StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMax", Missing = 6))
		
	; Bikini Armors
	ElseIf (option == BikiniDropsVendorCityOID_S)
		BikiniDropsVendorCity = value as Int
		SetSliderOptionValue(BikiniDropsVendorCityOID_S, BikiniDropsVendorCity)
	ElseIf (option == BikiniDropsVendorTownOID_S)
		BikiniDropsVendorTown = value as Int
		SetSliderOptionValue(BikiniDropsVendorTownOID_S, BikiniDropsVendorTown)
	ElseIf (option == BikiniDropsVendorKhajiitOID_S)
		BikiniDropsVendorKhajiit = value as Int
		SetSliderOptionValue(BikiniDropsVendorKhajiitOID_S, BikiniDropsVendorKhajiit)
	ElseIf (option == BikiniDropsChestOID_S)
		BikiniDropsChest = value as Int
		SetSliderOptionValue(BikiniDropsChestOID_S, BikiniDropsChest)
	ElseIf (option == BikiniDropsChestOrnateOID_S)
		BikiniDropsChestOrnate = value as Int
		SetSliderOptionValue(BikiniDropsChestOrnateOID_S, BikiniDropsChestOrnate)
		
	ElseIf (option == BikiniExpTrainOID_S)
		BikTrainingSpeed = value
		SetSliderOptionValue(BikiniExpTrainOID_S, BikTrainingSpeed)
	ElseIf (option == BikiniExpPerLevelOID_S)
		BikiniExp.ExpPerLevel = value
		SetSliderOptionValue(BikiniExpPerLevelOID_S, BikiniExp.ExpPerLevel)
	ElseIf (option == BikiniExpUntrainOID_S)
		BikUntrainingSpeed = value
		SetSliderOptionValue(BikiniExpUntrainOID_S, BikUntrainingSpeed)
		
	ElseIf (option == BikiniChanceHideOID_S)
		BikiniChanceHide = value
		SetSliderOptionValue(BikiniChanceHideOID_S, BikiniChanceHide)
	ElseIf (option == BikiniChanceLeatherOID_S)
		BikiniChanceLeather = value
		SetSliderOptionValue(BikiniChanceLeatherOID_S, BikiniChanceLeather)
	ElseIf (option == BikiniChanceIronOID_S)
		BikiniChanceIron = value
		SetSliderOptionValue(BikiniChanceIronOID_S, BikiniChanceIron)
	ElseIf (option == BikiniChanceSteelOID_S)
		BikiniChanceSteel = value
		SetSliderOptionValue(BikiniChanceSteelOID_S, BikiniChanceSteel)
	ElseIf (option == BikiniChanceSteelPlateOID_S)
		BikiniChanceSteelPlate = value
		SetSliderOptionValue(BikiniChanceSteelPlateOID_S, BikiniChanceSteelPlate)
	ElseIf (option == BikiniChanceDwarvenOID_S)
		BikiniChanceDwarven = value
		SetSliderOptionValue(BikiniChanceDwarvenOID_S, BikiniChanceDwarven)
	ElseIf (option == BikiniChanceFalmerOID_S)
		BikiniChanceFalmer = value
		SetSliderOptionValue(BikiniChanceFalmerOID_S, BikiniChanceFalmer)
	ElseIf (option == BikiniChanceWolfOID_S)
		BikiniChanceWolf = value
		SetSliderOptionValue(BikiniChanceWolfOID_S, BikiniChanceWolf)
	ElseIf (option == BikiniChanceBladesOID_S)
		BikiniChanceBlades = value
		SetSliderOptionValue(BikiniChanceBladesOID_S, BikiniChanceBlades)
	ElseIf (option == BikiniChanceEbonyOID_S)
		BikiniChanceEbony = value
		SetSliderOptionValue(BikiniChanceEbonyOID_S, BikiniChanceEbony)
	ElseIf (option == BikiniChanceDragonboneOID_S)
		BikiniChanceDragonbone = value
		SetSliderOptionValue(BikiniChanceDragonboneOID_S, BikiniChanceDragonbone)
		
		
	; Inn Prices
	Else
		String InnLoc
		Int i = 0
		While i < LocTrack.InnCosts.Length
			InnLoc = StorageUtil.StringListGet(LocTrack, "_SLS_LocIndex", i)
			If Option == StorageUtil.GetIntValue(Self, "InnCost" + InnLoc + "OID_S")
				LocTrack.InnCosts[i] = Value as Int
				SetSliderOptionValue(StorageUtil.GetIntValue(LocTrack, "InnCost" + InnLoc + "OID_S"), LocTrack.InnCosts[i])
				LocTrack.SetInnCostByString(LocTrack.PlayerCurrentLocString)
			EndIf
			i += 1
		EndWhile
	EndIf
	ForcePageReset()
EndEvent

; Functions Begin =======================================================

Function ToggleTollGateLocks() ; Lock: True - Lock, False - Unlock
;/
	(_SLS_TollGateWhiterunInside as SLS_TollGate).ToggleDoorLocks(DoorLockDownT)
	(_SLS_TollGateSolitudeInside as SLS_TollGate).ToggleDoorLocks(DoorLockDownT)
	(_SLS_TollGateRiftenMainInside as SLS_TollGate).ToggleDoorLocks(DoorLockDownT)
	(_SLS_TollGateWindhelmInterior as SLS_TollGate).ToggleDoorLocks(DoorLockDownT)
	(_SLS_TollGateMarkarthInterior as SLS_TollGate).ToggleDoorLocks(DoorLockDownT)
	/;
	
	TollUtil.ToggleDoorLocks(_SLS_TollGateWhiterunInside.GetReference(), (DoorLockDownT && Init.TollEnable))
	TollUtil.ToggleDoorLocks(_SLS_TollGateSolitudeInside.GetReference(), (DoorLockDownT && Init.TollEnable))
	TollUtil.ToggleDoorLocks(_SLS_TollGateRiftenMainInside.GetReference(), (DoorLockDownT && Init.TollEnable))
	TollUtil.ToggleDoorLocks(_SLS_TollGateWindhelmInterior.GetReference(), (DoorLockDownT && Init.TollEnable))
	TollUtil.ToggleDoorLocks(_SLS_TollGateMarkarthInterior.GetReference(), (DoorLockDownT && Init.TollEnable))
EndFunction

Function RestartInterfacePrompt(String IntSelect)
	If IntSelect == "RealisticNeedsandDiseases.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x03AA30, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
	
	ElseIf IntSelect == "iNeed.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x03EADE, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "Devious Devices - Expansion.esm"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x040068, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "Frostfall.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x03CA81, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "SexLab_PaySexCrime.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x040B2D, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
	
	ElseIf IntSelect == "Slaverun_Reloaded.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x03F041, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "EFFCore.esm"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x057C3C, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf

	ElseIf IntSelect == "dcc-soulgem-oven-000.esm"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x063A97, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "sr_FillHerUp.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x063A98, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "Amputator.esm"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x069BC0, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "Apropos2.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x0707CE, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "SlaveTats.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x0732E3, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "Milk Addict.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x07995C, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "SexLabAroused.esm"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x07DF73, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "DeviousFollowers.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x07EF9A, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf

	ElseIf IntSelect == "SexLab - Sexual Fame [SLSF].esm"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x0840A1, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "Slso.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x0A62A4, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
	
	ElseIf IntSelect == "EatingSleepingDrinking.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x0A8307, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "Spank That Ass.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x0A8DCD, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "FNISSexyMove.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x0BCB05, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	ElseIf IntSelect == "Bathing in Skyrim - Main.esp"
		If Game.GetModByName(IntSelect) != 255
			RestartInterface(Game.GetFormFromFile(0x0BC03D, "SL Survival.esp") as Quest)
		Else
			RestartIntErrorMsg(IntSelect)
		EndIf
		
	Else
		Debug.Trace("_SLS_: RestartInterfacePrompt: Unknown interface")
	EndIf
EndFunction

Function RestartIntErrorMsg(String ModName)
	Debug.Messagebox(ModName + " not found in load order")
EndFunction

Function RestartInterface(Quest IntSelect)
	If ShowMessage("Restart the interface?\nYou may need to exit the menu to apply changes.")
		IntSelect.Stop()
		Utility.WaitMenuMode(0.2)
		IntSelect.Start()
		Debug.Messagebox("Interface restarted:\n" + IntSelect + "\n\nPlease save your game, reload it and wait 5 seconds for the interface to start up")
	EndIf
EndFunction

Function SetSaltyCum(Bool SaltyCum)
	If SaltyCum
		Needs.SaltyCum = -1.0
	Else
		Needs.SaltyCum = 1.0
	EndIf
EndFunction

Function TogglePushPlayer()
	If PushEvents > 0
		(Game.GetFormFromFile(0x01C58E, "SL Survival.esp") as Quest).Start() ; _SLS_PushPlayer
		(Game.GetFormFromFile(0x0E651A, "SL Survival.esp") as Quest).Start() ; _SLS_PushPlayerProximity
		(Game.GetFormFromFile(0x0E6A8D, "SL Survival.esp") as GlobalVariable).SetValueInt(0)
	Else
		(Game.GetFormFromFile(0x01C58E, "SL Survival.esp") as Quest).Stop() ; _SLS_PushPlayer
		(Game.GetFormFromFile(0x0E651A, "SL Survival.esp") as Quest).Stop() ; _SLS_PushPlayerProximity
	EndIf
EndFunction

Function ToggleAssSlapping()
	If AssSlappingEvents
		_SLS_AssSlapQuest.Start()
	Else
		_SLS_AssSlapQuest.Stop()
	EndIf
EndFunction

Function ToggleMinAV()
	If MinAvToggleT
		MinAv.StartUp()
		PlayerRef.AddSpell(_SLS_WeaponReadySpell, false)
	Else
		MinAv.Shutdown()
		If !GuardBehavWeapDrawn ; If both MinAv and Guard behaviour weapons drawn is off remove weapon ready spell - not needed.
			PlayerRef.RemoveSpell(_SLS_WeaponReadySpell)
		EndIf
	EndIf
EndFunction

Function UpdateBellyScale()
	Gluttony.BellyScaleUpdate()
EndFunction

Function ToggleBellyInflation()
	If !CanEnableSnowberry() ; Has left the alternate start cell (game time updates can be registered)
		If BellyScaleEnable
			If IsInMcm
				Debug.Messagebox("Please exit the menu to apply changes")
			EndIf
			_SLS_BellyInflationQuest.Start()
		Else
			Gluttony.Shutdown()
			_SLS_BellyInflationQuest.Stop()
		EndIf
	EndIf
EndFunction

Function ToggleLicences(Bool Enabled)
	Int i = _SLS_LicenceGateActList.GetSize()
	ObjectReference ObjRef
	
	; Disable/Enable gate activators
	While i > 0
		i -= 1
		ObjRef = _SLS_LicenceGateActList.GetAt(i) as ObjectReference
		If ObjRef
			If Enabled
				ObjRef.Enable()
			Else
				ObjRef.Disable()
			EndIf
		EndIf
	EndWhile
	If Game.GetModByName("JKs Skyrim.esp") != 255 ; Enable/Disable the extra activator at the riften side door
		_SLS_LicenceGateActJkRef.Enable()
	Else
		_SLS_LicenceGateActJkRef.Disable()
	EndIf
	
	; Remove licences
	If !Enabled
		i = _SLS_LicenceAliases.GetNumAliases()
		While i > 0
			i -= 1
			ObjRef = (_SLS_LicenceAliases.GetNthAlias(i) as ReferenceAlias).GetReference()
			If ObjRef && ObjRef.GetBaseObject() as Book
				_SLS_LicenceDumpRef.AddItem(ObjRef)
			EndIf
		EndWhile
	EndIf
	
	ToggleCurfew(Enabled && LicUtil.LicCurfewEnable)
	
	; Disable/Enable enforcers + system
	If Enabled
		_SLS_LicTownCheckEnforcerAliases.Start()
		_SLS_LicTownCheckPlayerAliasQuest.Start()
		_SLS_LicTownCheckQuest.Start()
		Utility.Wait(2.0) ; Wait for quest aliases to fill just in case
		i = _SLS_LicTownCheckEnforcerAliases.GetNumAliases()
		Actor Enforcer
		While i > 0
			i -= 1
			Enforcer = (_SLS_LicTownCheckEnforcerAliases.GetNthAlias(i) as ReferenceAlias).GetReference() as Actor
			If Enforcer
				Enforcer.Enable()
			EndIf
		EndWhile
		
	Else
		i = _SLS_LicTownCheckEnforcerAliases.GetNumAliases()
		Actor Enforcer
		While i > 0
			i -= 1
			Enforcer = (_SLS_LicTownCheckEnforcerAliases.GetNthAlias(i) as ReferenceAlias).GetReference() as Actor
			If Enforcer
				Enforcer.Disable()
			EndIf
		EndWhile
		_SLS_LicTownCheckQuest.Stop()
		_SLS_LicTownCheckPlayerAliasQuest.Stop()
		_SLS_LicTownCheckEnforcerAliases.Stop()
	EndIf
	
	If !Enabled
		TradeRestrictions = false
	EndIf
	ToggleTradeRestrictions()
	ToggleFolContraBlock()
	
	
	If !Enabled
		LicUtil.LicCurfewEnable = false
		LicUtil.LicWhoreEnable = false
		LicUtil.LicPropertyEnable = false
		LicUtil.LicFreedomEnable = 0
	EndIf
	LicenceToggleToggled()
	
	ToggleCurfew(LicUtil.LicCurfewEnable)
	Eviction.UpdateEvictions(DoImmediately = true)
	Debug.Messagebox("Licence change complete")
EndFunction

Function ToggleCompassMechanics()
	If CompassMechanics
		_SLS_MapAndCompassQuest.Start()
	Else
		Compass.ToggleCompass(true)
		_SLS_MapAndCompassQuest.Stop()
	EndIf
EndFunction

Function ToggleSleepDepriv()
	If SleepDepriv
		_SLS_SleepDeprivationQuest.Start()
		Needs.ToggleSleepDepriv(SleepDepriv)
	Else
		_SLS_SleepDeprivationQuest.Stop()
		Needs.ToggleSleepDepriv(SleepDepriv)
	EndIf
EndFunction

Function DoSlaverunInit()
	_SLS_SlaverunKickerQuest.Stop()
	_SLS_SlaverunKickerQuest.Start()
EndFunction

Function ToggleHalfNakedCover()
	If HalfNakedEnable
		_SLS_HalfNakedCoverQuest.Start()
	Else
		PlayerRef.UnequipItem(HalfNakedCover._SLS_HalfNakedCoverArmor, abPreventEquip = false, abSilent = true)
		PlayerRef.Removeitem(HalfNakedCover._SLS_HalfNakedCoverArmor, aiCount = PlayerRef.GetItemCount(HalfNakedCover._SLS_HalfNakedCoverArmor), abSilent = true)
		_SLS_HalfNakedCoverQuest.Stop()
	EndIf
EndFunction

Function CheckHalfNakedCover()
	HalfNakedCover.BraSlot = HalfNakedBra
	HalfNakedCover.PantySlot = HalfNakedPanty
	If HalfNakedEnable
		HalfNakedCover.CheckCover()
	EndIf
EndFunction

Function ToggleHalfNakedStrips()
	HalfNakedCover.CoverStripsCuirass = HalfNakedStrips
EndFunction

Function ToggleDeviousEffects()
	DeviousEffects.Shutdown()
	If DeviousEffectsEnable
		_SLS_DeviousEffectsQuest.Start()
	EndIf
EndFunction

Function ToggleTollDodging()
	If TollDodging
		_SLS_TollDodgeHuntQuest.Stop()
		_SLS_TollDodgeQuest.Start()
	Else
		_SLS_TollDodgeHuntQuest.Stop()
		_SLS_TollDodgeQuest.Stop()
		
		If GuardBehavArmorEquip ; turn off guard warnings for having armor equipped as well - piggy backs off toll evasion cell detection
			GuardBehavArmorEquip = false
		EndIf
		If GuardBehavWeapEquip
			GuardBehavWeapEquip = false
		EndIf
	EndIf
EndFunction

Function RefreshGuardSpotDistance()
	DodgeDisguise.ProcArmorChange()
EndFunction
;/
Function SetTollCost()
	Bool IsFreeTown = true
	
	If TollDodge.LastTollLocation != ""
		If TollDodge.LastTollLocation == "Whiterun"
			IsFreeTown = Slaverun.IsFreeTownWhiterun()
		ElseIf TollDodge.LastTollLocation == "Riften"
			IsFreeTown = Slaverun.IsFreeTownRiften()
		ElseIf TollDodge.LastTollLocation == "Windhelm"
			IsFreeTown = Slaverun.IsFreeTownWindhelm()
		ElseIf TollDodge.LastTollLocation == "Markarth"
			IsFreeTown = Slaverun.IsFreeTownMarkarth()
		ElseIf TollDodge.LastTollLocation == "Solitude"
			IsFreeTown = Slaverun.IsFreeTownSolitude()
		EndIf
	EndIf

	Float EnslavedTownFactor 
	If IsFreeTown
		EnslavedTownFactor = 1.0
	Else
		EnslavedTownFactor = SlaverunFactor * ((!IsFreeTown) as Int)
	EndIf

	;Debug.Messagebox("EnslavedTownFactor: " + EnslavedTownFactor)

	If GoldPerLevelT
		_SLS_TollCost.SetValueInt((TollCostGold * PlayerRef.GetLevel() * EnslavedTownFactor) as Int)
	Else
		_SLS_TollCost.SetValueInt((TollCostGold * EnslavedTownFactor) as Int)
	EndIf
	;Debug.Messagebox("Toll cost: " + _SLS_TollCost.GetValueInt())
EndFunction
/;
Function TryHardcoreToggle()
	If HardcoreToggleAllowed()
		HardcoreMode = !HardcoreMode
	EndIf
	SetToggleOptionValue(HardcoreModeOID, HardcoreMode)

	If HardcoreMode
		IsHardcoreLocked = true
	Else
		IsHardcoreLocked = false
	EndIf
EndFunction

Bool Function HardcoreToggleAllowed()
	If HardcoreMode
		Int HighestCost = LicUtil.LicCostWeaponShort
		If LicUtil.LicCostArmorShort > HighestCost
			HighestCost = LicUtil.LicCostArmorShort
		EndIf
		If LicUtil.LicMagicEnable
			If LicUtil.LicCostMagicShort > HighestCost
				HighestCost = LicUtil.LicCostMagicShort
			EndIf
		EndIf
		If LicUtil.LicBikiniEnable
			If LicUtil.LicCostBikiniShort > HighestCost
				HighestCost = LicUtil.LicCostBikiniShort
			EndIf
		EndIf
		If LicUtil.LicClothesEnable != 0
			If LicUtil.LicCostClothesShort > HighestCost
				HighestCost = LicUtil.LicCostClothesShort
			EndIf
		EndIf
		
		Int TollCost = _SLS_TollCost.GetValueInt()
		If TollCost > HighestCost
			HighestCost = TollCost
		EndIf
		
		If PlayerRef.GetItemCount(Gold001) >= HighestCost
			Return true
		Else
			Debug.Messagebox("You do not have enough gold to toggle hardcore mode off.\nGold needed: " + HighestCost + " septims.")
			Return false
		EndIf

	Else
		Return true
	EndIf
EndFunction

Function ToggleTradeRestrictions()
	If TradeRestrictions
		_SLS_LicenceTradersQuest.Start()
	Else
		_SLS_LicenceTradersQuest.Stop()
	EndIf
EndFunction

String Function GetActorCrosshairRef()
	ObjectReference CrosshairRef = Game.GetCurrentCrosshairRef()
	If CrosshairRef != None
		If CrosshairRef as Actor
			Return (CrosshairRef.GetBaseObject().GetName() as String)
		
		Else
			Return ""
		EndIf
		
	Else
		Return ""
	EndIf
EndFunction

Function DoTradeRestrictAddMerchant()
	Actor akTarget = Game.GetCurrentCrosshairRef() as Actor
	If akTarget
		If ShowMessage("Set the current Npc as an exception? Exculded merchants will always trade items freely regardless of your licences\n\nIf you select no here you can assign them a Slaverun region next (if Slaverun is installed)")
			; Assign Npc as an exception to licence trading rules
			_SLS_TraderListExceptions.AddForm(akTarget)
			Debug.Messagebox("Done!\n" + akTarget.GetBaseObject().GetName() + " has been added as an exception")
		Else
		
			; Assign Npc a slaverun region
			If Game.GetModByName("Slaverun_Reloaded.esp") != 255
				
				UnAssignTradeRestrictMerchant(akTarget)
				Debug.Messagebox("Please exit the menu to continue")
				Int Button = _SLS_TradeRestrictSetMerchant.Show()
				AssignSlaverunMerchantRegion(akTarget, Button)
				Debug.Messagebox("Done!\n" + akTarget.GetBaseObject().GetName() + " has been assigned")
			EndIf
		EndIf
	
	Else
		Debug.Messagebox("Current crosshair ref is not a valid actor")
	EndIf
EndFunction

Function DoTradeRestrictRemoveMerchant()
	Actor akTarget = Game.GetCurrentCrosshairRef() as Actor
	If akTarget
		If ShowMessage("Are you sure you want to remove " + akTarget.GetBaseObject().GetName() + " from the system? \nThis will remove their assigned Slaverun region or their exception status if applicable")
			UnAssignTradeRestrictMerchant(akTarget)
			Debug.MessageBox("Done! ")
		EndIf
		
	Else
		Debug.Messagebox("Current crosshair ref is not a valid actor")
	EndIf
EndFunction

Function AssignSlaverunMerchantRegion(Actor akTarget, Int Button)
	; 0 - Whiterun
	; 1 - Riften
	; 2 - Windhelm
	; 3 - Markarth
	; 4 - Solitude
	; 5 - Riverwood
	; 6 - Falkreath
	; 7 - Dawnstar
	; 8 - Morthal
	; 9 - Winterhold

	If Button == 0
		_SLS_TraderListWhiterun.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsWhiterun", akTarget, allowDuplicate = false)
	ElseIf Button == 1
		_SLS_TraderListRiften.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsRiften", akTarget, allowDuplicate = false)
	ElseIf Button == 2
		_SLS_TraderListWindhelm.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsWindhelm", akTarget, allowDuplicate = false)
	ElseIf Button == 3
		_SLS_TraderListMarkarth.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsMarkarth", akTarget, allowDuplicate = false)
	ElseIf Button == 4
		_SLS_TraderListSolitude.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsSolitude", akTarget, allowDuplicate = false)
	ElseIf Button == 5
		_SLS_TraderListRiverwood.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsRiverwood", akTarget, allowDuplicate = false)
	ElseIf Button == 6
		_SLS_TraderListFalkreath.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsFalkreath", akTarget, allowDuplicate = false)
	ElseIf Button == 7
		_SLS_TraderListDawnstar.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsDawnstar", akTarget, allowDuplicate = false)
	ElseIf Button == 8
		_SLS_TraderListMorthal.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsMorthal", akTarget, allowDuplicate = false)
	ElseIf Button == 9
		_SLS_TraderListWinterhold.AddForm(akTarget)
		JsonUtil.FormListAdd("SL Survival/MerchantRestrictions.json", "LocsWinterhold", akTarget, allowDuplicate = false)
	EndIf
	_SLS_TraderListAll.AddForm(akTarget)
	_SLS_TraderBaseListAll.AddForm(akTarget.GetBaseObject())
	JsonUtil.Save("SL Survival/MerchantRestrictions.json")
EndFunction

Function UnAssignTradeRestrictMerchant(Actor akTarget)
	_SLS_TraderListExceptions.RemoveAddedForm(akTarget)
	
	_SLS_TraderListWhiterun.RemoveAddedForm(akTarget)
	_SLS_TraderListRiften.RemoveAddedForm(akTarget)
	_SLS_TraderListWindhelm.RemoveAddedForm(akTarget)
	_SLS_TraderListMarkarth.RemoveAddedForm(akTarget)
	_SLS_TraderListSolitude.RemoveAddedForm(akTarget)
	_SLS_TraderListRiverwood.RemoveAddedForm(akTarget)
	_SLS_TraderListFalkreath.RemoveAddedForm(akTarget)
	_SLS_TraderListMorthal.RemoveAddedForm(akTarget)
	_SLS_TraderListDawnstar.RemoveAddedForm(akTarget)
	_SLS_TraderListWinterhold.RemoveAddedForm(akTarget)
	
	_SLS_TraderListAll.RemoveAddedForm(akTarget)
	_SLS_TraderBaseListAll.RemoveAddedForm(akTarget.GetBaseObject())
	
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "Exceptions", akTarget)
	
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsWhiterun", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsRiften", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsWindhelm", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsMarkarth", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsSolitude", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsRiverwood", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsFalkreath", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsDawnstar", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsMorthal", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsWinterhold", akTarget)
	JsonUtil.FormListRemove("SL Survival/MerchantRestrictions.json", "LocsRavenRock", akTarget)
	JsonUtil.Save("SL Survival/MerchantRestrictions.json")
EndFunction

Function DoTradeRestrictResetAllMerchants()
	If ShowMessage("Are you sure you want to reset all merchant changes and clear the json file?")
		_SLS_TraderListExceptions.Revert()
		
		_SLS_TraderListWhiterun.Revert()
		_SLS_TraderListRiften.Revert()
		_SLS_TraderListWindhelm.Revert()
		_SLS_TraderListMarkarth.Revert()
		_SLS_TraderListSolitude.Revert()
		_SLS_TraderListRiverwood.Revert()
		_SLS_TraderListFalkreath.Revert()
		_SLS_TraderListMorthal.Revert()
		_SLS_TraderListDawnstar.Revert()
		_SLS_TraderListWinterhold.Revert()
		
		_SLS_TraderListAll.Revert()
		_SLS_TraderBaseListAll.Revert()
		
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "Exceptions")
		
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsWhiterun")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsRiften")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsWindhelm")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsMarkarth")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsSolitude")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsRiverwood")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsFalkreath")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsDawnstar")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsMorthal")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsWinterhold")
		JsonUtil.FormListClear("SL Survival/MerchantRestrictions.json", "LocsRavenRock")
		JsonUtil.Save("SL Survival/MerchantRestrictions.json")
		Debug.MessageBox("Done!")
	EndIf
EndFunction

Function ImportTradeRestrictMerchants()
	String[] LocList = new String[12]
	LocList[0] = "Exceptions"
	LocList[1] = "LocsWhiterun"
	LocList[2] = "LocsRiften"
	LocList[3] = "LocsWindhelm"
	LocList[4] = "LocsMarkarth"
	LocList[5] = "LocsSolitude"
	LocList[6] = "LocsRiverwood"
	LocList[7] = "LocsFalkreath"
	LocList[8] = "LocsDawnstar"
	LocList[9] = "LocsMorthal"
	LocList[10] = "LocsWinterhold"
	LocList[11] = "LocsRavenRock"
	
	Formlist[] FlArray = new Formlist[12]
	FlArray[0] = _SLS_TraderListExceptions
	FlArray[1] = _SLS_TraderListWhiterun
	FlArray[2] = _SLS_TraderListRiften
	FlArray[3] = _SLS_TraderListWindhelm
	FlArray[4] = _SLS_TraderListMarkarth
	FlArray[5] = _SLS_TraderListSolitude
	FlArray[6] = _SLS_TraderListRiverwood
	FlArray[7] = _SLS_TraderListFalkreath
	FlArray[8] = _SLS_TraderListDawnstar
	FlArray[9] = _SLS_TraderListMorthal
	FlArray[10] = _SLS_TraderListWinterhold
	FlArray[11] = _SLS_TraderListRavenRock
	
	Int i = 0
	Int j
	Formlist FlSelect
	Actor akTarget
	While i < LocList.Length
		FlSelect = FlArray[i]
		j = 0
		While j < JsonUtil.FormListCount("SL Survival/MerchantRestrictions.json", LocList[i])
			akTarget = JsonUtil.FormListGet("SL Survival/MerchantRestrictions.json", LocList[i], j) as Actor
			If akTarget
				If i > 0 ; Is not exception list
					FlSelect.AddForm(akTarget)
					_SLS_TraderListAll.AddForm(akTarget)
					_SLS_TraderBaseListAll.AddForm(akTarget.GetBaseObject())
				EndIf
			EndIf
			j += 1
		EndWhile
		i += 1
	EndWhile

	If Game.GetModByName("Mortal Weapons & Armor.esp") != 255
		ImportSupportedMerchant(_SLS_TraderListMarkarth, Game.GetFormFromFile(0x0012DF, "Mortal Weapons & Armor.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListSolitude, Game.GetFormFromFile(0x0012E0, "Mortal Weapons & Armor.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListFalkreath, Game.GetFormFromFile(0x0012DC, "Mortal Weapons & Armor.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListWinterhold, Game.GetFormFromFile(0x0012DB, "Mortal Weapons & Armor.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListWhiterun, Game.GetFormFromFile(0x0012DA, "Mortal Weapons & Armor.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListRiften, Game.GetFormFromFile(0x0012D9, "Mortal Weapons & Armor.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListWindhelm, Game.GetFormFromFile(0x0012DE, "Mortal Weapons & Armor.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListRiverwood, Game.GetFormFromFile(0x0012DD, "Mortal Weapons & Armor.esp") as Actor)

	ElseIf Game.GetModByName("Milk Addict.esp") != 255
		ImportSupportedMerchant(_SLS_TraderListMarkarth, Game.GetFormFromFile(0x016789, "Milk Addict.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListRiverwood, Game.GetFormFromFile(0x016783, "Milk Addict.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListWhiterun, Game.GetFormFromFile(0x016785, "Milk Addict.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListSolitude, Game.GetFormFromFile(0x016787, "Milk Addict.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListWindhelm, Game.GetFormFromFile(0x01678B, "Milk Addict.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListRiften, Game.GetFormFromFile(0x01678D, "Milk Addict.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListFalkreath, Game.GetFormFromFile(0x01678F, "Milk Addict.esp") as Actor)
		ImportSupportedMerchant(_SLS_TraderListWinterhold, Game.GetFormFromFile(0x016791, "Milk Addict.esp") as Actor)
	EndIf
EndFunction

Function ImportSupportedMerchant(Formlist FlSelect, Actor akTarget)
	FlSelect.AddForm(akTarget)
	_SLS_TraderListAll.AddForm(akTarget)
	_SLS_TraderBaseListAll.AddForm(akTarget.GetBaseObject())
EndFunction

Function TogglePpLoot()
	If PpLootEnable
		PlayerRef.AddPerk(_SLS_IncPickpocketLootPerk)
	Else
		PlayerRef.RemovePerk(_SLS_IncPickpocketLootPerk)
	EndIf
	ForcePageReset()
EndFunction

Function BuildPpLootList()
	Debug.Notification("SLS: Building pickpocket leveled list")
	
	; Build devious key list
	_SLS_PpLootKeysList.Revert()
	If Game.GetModByName("Devious Devices - Expansion.esm") != 255
		_SLS_PpLootKeysList.AddForm(Game.GetFormFromFile(0x01775F, "Devious Devices - Integration.esm"), 1, 1)
		_SLS_PpLootKeysList.AddForm(Game.GetFormFromFile(0x008A4F, "Devious Devices - Integration.esm"), 1, 1)
	EndIf
	
	; Build loot list
	_SLS_PpLootRootList.Revert()
	Form[] LvlItems = new Form[9]
	LvlItems[0] = _SLS_PpLootFoodList
	LvlItems[1] = _SLS_PpLootGemsList
	LvlItems[2] = _SLS_PpLootSoulgemsList
	LvlItems[3] = _SLS_PpLootJewelryList
	LvlItems[4] = _SLS_PpLootEnchJewelryList
	LvlItems[5] = _SLS_PpLootPotionsList
	LvlItems[6] = _SLS_PpLootKeysList
	LvlItems[7] = _SLS_PpLootTomesList
	LvlItems[8] = CureDisease
	
	Float[] Chances = new Float[9]
	Chances[0] = PpLootFoodChance
	Chances[1] = PpLootGemsChance
	Chances[2] = PpLootSoulgemsChance
	Chances[3] = PpLootJewelryChance
	Chances[4] = PpLootEnchJewelryChance
	Chances[5] = PpLootPotionsChance
	Chances[6] = PpLootKeysChance
	Chances[7] = PpLootTomesChance
	Chances[8] = PpLootCureChance
	
	Float j
	Int i = 0
	While i < LvlItems.Length
		j = Chances[i]
		While j > 0.0
			_SLS_PpLootRootList.AddForm(LvlItems[i], 1, 1)
			j -= 0.5
		EndWhile
		i += 1
	EndWhile
	
	; Fill remaining slots with empty lists to give accurate percentage chances
	i = _SLS_PpLootRootList.GetNumForms()
	If i < 200
		i = 200 - i
		While i > 0
			_SLS_PpLootRootList.AddForm(_SLS_PpLootEmptyList, 1, 1)
			i -= 1
		EndWhile
	EndIf
	
	; Build gold list
	_SLS_PpGoldRoot.Revert()
	
	LvlItems = new Form[3]
	LvlItems[0] = _SLS_PpGoldLow
	LvlItems[1] = _SLS_PpGoldModerate
	LvlItems[2] = _SLS_PpGoldHigh
	
	Chances = new Float[9]
	Chances[0] = PpGoldLowChance
	Chances[1] = PpGoldModerateChance
	Chances[2] = PpGoldHighChance
	
	i = 0
	While i < LvlItems.Length
		j = Chances[i]
		While j > 0
			_SLS_PpGoldRoot.AddForm(LvlItems[i], 1, 1)
			j -= 0.5
		EndWhile
		i += 1
	EndWhile
	
	; Fill remaining slots with empty lists to give accurate percentage chances
	i = _SLS_PpGoldRoot.GetNumForms()
	If i < 200
		i = 200 - i
		While i > 0
			_SLS_PpGoldRoot.AddForm(_SLS_PpLootEmptyList, 1, 1)
			i -= 1
		EndWhile
	EndIf
	
	Debug.Notification("SLS: Building pickpocket leveled list complete!")
EndFunction

Function ToggleFolContraBlock()
	If FolContraBlock && Init.LicencesEnable
		_SLS_LicFollowerEnforcementDumbQuest.Start()
	Else
		_SLS_LicFollowerEnforcementDumbQuest.Stop()
	EndIf
EndFunction

Function TogglePpSleepNpcPerk()
	If PpSleepNpcPerk
		PlayerRef.AddPerk(_SLS_PickpocketSleepBonusPerk)
	Else
		PlayerRef.RemovePerk(_SLS_PickpocketSleepBonusPerk)
	EndIf
EndFunction

Function TogglePpFailHandle()
	If PpFailHandle
		_SLS_PickPocketFailDetectQuest.Start()
	Else
		_SLS_PickPocketFailDetectQuest.Stop()
	EndIf
EndFunction

Function ImportEscorts()
	Int i = JsonUtil.FormListCount("SL Survival/EscortList.json", "Escorts")
	While i > 0
		i -= 1
		_SLS_EscortsList.AddForm(JsonUtil.FormListGet("SL Survival/EscortList.json", "Escorts", i) as ObjectReference)
	EndWhile
EndFunction

Function AddEscort()
	Actor Escort = Game.GetCurrentCrosshairRef() as Actor
	_SLS_EscortsList.AddForm(Escort)
	JsonUtil.FormListAdd("SL Survival/EscortList.json", "Escorts", Escort, allowDuplicate = false)
	JsonUtil.Save("SL Survival/EscortList.json")
	SetStrongFollower(Escort)	
EndFunction

Function RemoveEscort()
	Actor Escort = Game.GetCurrentCrosshairRef() as Actor
	_SLS_EscortsList.RemoveAddedForm(Escort)
	JsonUtil.FormListRemove("SL Survival/EscortList.json", "Escorts", Escort, allInstances = true)
	JsonUtil.Save("SL Survival/EscortList.json")
	SetStrongFollower(Escort)
EndFunction

String Function GetMageRankString()
	Int Rank = PlayerRef.GetFactionRank(CollegeofWinterholdFaction)
	If Rank < 0
		Return "Not A Member"
	ElseIf Rank == 0
		Return "0 - Student"
	ElseIf Rank == 1
		Return "1 - Apprentice"
	ElseIf Rank == 2
		Return "2 - Evoker"
	ElseIf Rank == 3
		Return "3 - Scholar"
	ElseIf Rank == 4
		Return "4 - Wizard"
	ElseIf Rank == 5
		Return "5 - Master-Wizard"
	ElseIf Rank == 6
		Return "6 - Arch-Mage"
	EndIf
EndFunction

String Function GetCompanionsRankString()
	Int Rank = PlayerRef.GetFactionRank(CompanionsFaction)
	If Rank < 0
		Return "Not A Member"
	ElseIf Rank == 0
		Return "0 - Cohort"
	ElseIf Rank == 1
		Return "1 - Companion"
	ElseIf Rank == 2
		Return "2 - Shield-Sister"
	ElseIf Rank == 3
		Return "3 - Harbinger"
	EndIf
EndFunction

String Function GetCwSide()
	String CwSide
	If CW01A.GetCurrentStageId() >= 200 || CW01B.GetCurrentStageId() >= 200
		If Cw.playerAllegiance == 1 ; Player is imperial
			Return "Imperials: "
		ElseIf Cw.playerAllegiance == 2 ; Player is stormcloak
			Return "Stormcloaks: "
		EndIf
	
	Else
		Return "Civil War: Undecided"
	EndIf
EndFunction

Function AddQuestObjects() ; Add quest objects to list so that they are not removed when items are stolen from your inventory (Toll evasion/Pickpocket fail)
	If Game.GetModByName("Dawnguard.esm") != 255
		_SLS_QuestItems.AddForm(Game.GetFormFromFile(0x0118F9, "Dawnguard.esm"))
		_SLS_QuestItems.AddForm(Game.GetFormFromFile(0x011A13, "Dawnguard.esm"))
	EndIf
	;If Game.GetModByName("Dragonborn.esm") != 255
	
	;EndIf
EndFunction

Function ToggleKennelFollower()
	If PlayerRef.GetCurrentLocation() == _SLS_KennelWhiterunLocation
		Debug.Messagebox("You can not toggle this while inside the kennel. Exit the kennel and wait for your follower to rejoin you and toggle the option again")
	
	Else
		KennelFollowerToggle = !KennelFollowerToggle
		SetToggleOptionValue(KennelFollowerToggleOID, KennelFollowerToggle)
	EndIf
EndFunction

Function BuildBikiniLists()
	If Game.GetModByName(JsonUtil.GetStringValue("SL Survival/BikiniArmors.json", "bikinimodname", missing = "TheAmazingWorldOfBikiniArmor.esp")) != 255
		Debug.Notification("SLS: Building bikini armor leveled list")
		
		; Build bikini type lists
		Form[] LvlItems = new Form[11]
		LvlItems[0] = _SLS_BikiniArmorsListHide
		LvlItems[1] = _SLS_BikiniArmorsListLeather
		LvlItems[2] = _SLS_BikiniArmorsListIron
		LvlItems[3] = _SLS_BikiniArmorsListSteel
		LvlItems[4] = _SLS_BikiniArmorsListSteelPlate
		LvlItems[5] = _SLS_BikiniArmorsListDwarven
		LvlItems[6] = _SLS_BikiniArmorsListFalmer
		LvlItems[7] = _SLS_BikiniArmorsListWolf
		LvlItems[8] = _SLS_BikiniArmorsListBlades
		LvlItems[9] = _SLS_BikiniArmorsListEbony
		LvlItems[10] = _SLS_BikiniArmorsListDragonbone

		String[] JsonKeys = new String[11]
		JsonKeys[0] = "hide"
		JsonKeys[1] = "leather"
		JsonKeys[2] = "iron"
		JsonKeys[3] = "steel"
		JsonKeys[4] = "steelplate"
		JsonKeys[5] = "dwarven"
		JsonKeys[6] = "falmer"
		JsonKeys[7] = "wolf"
		JsonKeys[8] = "blades"
		JsonKeys[9] = "ebony"
		JsonKeys[10] = "dragonbone"
		
		Int i = LvlItems.Length
		Int j
		Form akForm
		Int ResolveErrorCount = 0
		While i > 0
			i -= 1
			
			(LvlItems[i] as LeveledItem).Revert()
			j = JsonUtil.FormListCount("SL Survival/BikiniArmors.json", JsonKeys[i])
			If IsInMcm
				SetTextOptionValue(BikiniBuildListOID_T, "Building " + JsonKeys[i] + " bikinis")
			EndIf
			While j > 0
				j -= 1
				Debug.Trace("_SLS_: i: " + i + ". j: " + j)
				;Debug.Trace("_SLS_: LVLI: Adding " + JsonUtil.FormListGet("SL Survival/BikiniArmors.json", JsonKeys[i], j) + " to " + LvlItems[i])
				akForm = JsonUtil.FormListGet("SL Survival/BikiniArmors.json", JsonKeys[i], j)
				If akForm
					(LvlItems[i] as LeveledItem).AddForm(akForm, 1, 1)
				Else
					Debug.Trace("_SLS_: BuildBikinis(): Json form could not be resolved: " + JsonKeys[i] + " at index: " + j)
					ResolveErrorCount += 1
				EndIf
			EndWhile
		EndWhile
		
		; Set drop counts
		_SLS_BikiniArmorsEntryPointVendorCity.SetNthCount(0, BikiniDropsVendorCity)
		_SLS_BikiniArmorsEntryPointVendorTown.SetNthCount(0, BikiniDropsVendorTown)
		_SLS_BikiniArmorsEntryPointVendorKhajiit.SetNthCount(0, BikiniDropsVendorKhajiit)
		_SLS_BikiniArmorsEntryPointChest.SetNthCount(0, BikiniDropsChest)
		_SLS_BikiniArmorsEntryPointChestOrnate.SetNthCount(0, BikiniDropsChestOrnate)
		
		; Build distribution list
		Float[] Chances = new Float[11]
		Chances[0] = BikiniChanceHide
		Chances[1] = BikiniChanceLeather
		Chances[2] = BikiniChanceIron
		Chances[3] = BikiniChanceSteel
		Chances[4] = BikiniChanceSteelPlate
		Chances[5] = BikiniChanceDwarven
		Chances[6] = BikiniChanceFalmer
		Chances[7] = BikiniChanceWolf
		Chances[8] = BikiniChanceBlades
		Chances[9] = BikiniChanceEbony
		Chances[10] = BikiniChanceDragonbone

		_SLS_BikiniArmorsList.Revert()
		i = 0
		Float k
		While i < LvlItems.Length
			If IsInMcm
				SetTextOptionValue(BikiniBuildListOID_T, "Finalizing " + JsonKeys[i] + " bikinis")
			EndIf
			k = Chances[i]
			While k > 0.0
				;Debug.Trace("_SLS_: LVLI: Adding: " + LvlItems[i])
				_SLS_BikiniArmorsList.AddForm(LvlItems[i], 1, 1)
				k -= 0.5
			EndWhile
			i += 1
		EndWhile
		
		; Fill remaining slots with empty lists to give accurate percentage chances
		i = _SLS_BikiniArmorsList.GetNumForms()
		If i < 201
			i = 201 - i
			While i > 0
				_SLS_BikiniArmorsList.AddForm(_SLS_PpLootEmptyList, 1, 1)
				i -= 1
			EndWhile
		EndIf
		
		If IsInMcm
			SetTextOptionValue(BikiniBuildListOID_T, "Done!")
		EndIf
		
		If ResolveErrorCount
			Debug.Messagebox("Warning: " + ResolveErrorCount + " armors in your BikiniArmor.Json could not be found in game. \n\nSearch your papyrus log for 'BuildBikinis' to find out more\n\nThis is usually harmless enough if you're missing just a couple of armors due to all the different variations of TAWoBA available.")
		EndIf
		
		Debug.Notification("SLS: Building bikini armor leveled list complete!")
	EndIf
EndFunction

Function ClearBikiniLists()
	_SLS_BikiniArmorsList.Revert()
	Debug.Messagebox("List cleared")
EndFunction

Function ModFondleVoice(Bool AddToList)
	VoiceType Voice = Game.GetCurrentCrosshairRef().GetVoiceType()
	If AddToList
		If ShowMessage("Are you sure you want to add the following voice type from the fondleable list?\n" + Voice)
			_SLS_FondleableVoices.AddForm(Voice)
			JsonUtil.FormListAdd("SL Survival/FondleableVoices.json", "customvoices", Voice, allowDuplicate = false)
			JsonUtil.Save("SL Survival/FondleableVoices.json")
		EndIf
	
	Else
		If ShowMessage("Are you sure you want to remove the following voice type from the fondleable list?\n" + Voice)
			_SLS_FondleableVoices.RemoveAddedForm(Voice)
			JsonUtil.FormListAdd("SL Survival/FondleableVoices.json", "customvoices", Voice, allowDuplicate = false)
			JsonUtil.Save("SL Survival/FondleableVoices.json")			
		EndIf
	EndIf
EndFunction

Function InitLocJurisdictions()
	Int i = JsonUtil.FormListCount("SL Survival/CustomTownLocations.json", "whiterun")
	While i > 0
		i -= 1
		_SLS_LocsWhiterun.AddForm(JsonUtil.FormListGet("SL Survival/CustomTownLocations.json", "whiterun", i))
	EndWhile
	
	i = JsonUtil.FormListCount("SL Survival/CustomTownLocations.json", "solitude")
	While i > 0
		i -= 1
		_SLS_LocsSolitude.AddForm(JsonUtil.FormListGet("SL Survival/CustomTownLocations.json", "solitude", i))
	EndWhile
	
	i = JsonUtil.FormListCount("SL Survival/CustomTownLocations.json", "markarth")
	While i > 0
		i -= 1
		_SLS_LocsMarkarth.AddForm(JsonUtil.FormListGet("SL Survival/CustomTownLocations.json", "markarth", i))
	EndWhile
	
	i = JsonUtil.FormListCount("SL Survival/CustomTownLocations.json", "windhelm")
	While i > 0
		i -= 1
		_SLS_LocsWindhelm.AddForm(JsonUtil.FormListGet("SL Survival/CustomTownLocations.json", "windhelm", i))
	EndWhile
	
	i = JsonUtil.FormListCount("SL Survival/CustomTownLocations.json", "riften")
	While i > 0
		i -= 1
		_SLS_LocsRiften.AddForm(JsonUtil.FormListGet("SL Survival/CustomTownLocations.json", "riften", i))
	EndWhile
EndFunction

String Function GetLocationJurisdictionString(Location Loc)
	If _SLS_LocsWhiterun.HasForm(Loc)
		Return "Whiterun "
	ElseIf _SLS_LocsSolitude.HasForm(Loc)
		Return "Solitude "
	ElseIf _SLS_LocsMarkarth.HasForm(Loc)
		Return "Markarth "
	ElseIf _SLS_LocsWindhelm.HasForm(Loc)
		Return "Windhelm "
	ElseIf _SLS_LocsRiften.HasForm(Loc)
		Return "Riften "
	Else
		Return "Unknown "
	EndIf
EndFunction

Function ModLocationJurisdiction(Bool AddLocation)
	Location Loc = PlayerRef.GetCurrentLocation()
	
	If AddLocation
		If Loc != None
			Debug.Messagebox("You need to return to the game for the town selection menu to show")
			Int Button = _SLS_GetLocationJurisdiction.Show()
			If Button == 0 ; Whiterun
				_SLS_LocsWhiterun.AddForm(Loc)
				JsonUtil.FormListAdd("SL Survival/CustomTownLocations.json", "whiterun", Loc, allowDuplicate = false)
				
			ElseIf Button == 1 ; Riften
				_SLS_LocsRiften.AddForm(Loc)
				JsonUtil.FormListAdd("SL Survival/CustomTownLocations.json", "riften", Loc, allowDuplicate = false)
				
			ElseIf Button == 2 ; Windhelm
				_SLS_LocsWindhelm.AddForm(Loc)
				JsonUtil.FormListAdd("SL Survival/CustomTownLocations.json", "windhelm", Loc, allowDuplicate = false)
				
			ElseIf Button == 3 ; Markarth
				_SLS_LocsMarkarth.AddForm(Loc)
				JsonUtil.FormListAdd("SL Survival/CustomTownLocations.json", "markarth", Loc, allowDuplicate = false)
				
			ElseIf Button == 4 ; Solitude
				_SLS_LocsSolitude.AddForm(Loc)
				JsonUtil.FormListAdd("SL Survival/CustomTownLocations.json", "solitude", Loc, allowDuplicate = false)
				
			Else ; cancel
				Return
			EndIf
			JsonUtil.Save("SL Survival/CustomTownLocations.json")
		
		Else
			Debug.Messagebox("Can not add a None location")
		EndIf
	Else
		If ShowMessage("Are you sure you want to remove this location?")
			RemoveLocationJurisdiction(Loc)
		EndIf	
	EndIf
EndFunction

Formlist Function GetLocationJurisdictionList(Location Loc)
	If _SLS_LocsWhiterun.HasForm(Loc)
		Return _SLS_LocsWhiterun
	ElseIf _SLS_LocsSolitude.HasForm(Loc)
		Return _SLS_LocsSolitude
	ElseIf _SLS_LocsMarkarth.HasForm(Loc)
		Return _SLS_LocsMarkarth
	ElseIf _SLS_LocsWindhelm.HasForm(Loc)
		Return _SLS_LocsWindhelm
	ElseIf _SLS_LocsRiften.HasForm(Loc)
		Return _SLS_LocsRiften
	Else
		Return None
	EndIf
EndFunction

Function RemoveLocationJurisdiction(Location Loc)
	_SLS_LocsWhiterun.RemoveAddedForm(Loc)
	_SLS_LocsSolitude.RemoveAddedForm(Loc)
	_SLS_LocsMarkarth.RemoveAddedForm(Loc)
	_SLS_LocsWindhelm.RemoveAddedForm(Loc)
	_SLS_LocsRiften.RemoveAddedForm(Loc)
	JsonUtil.FormListRemove("SL Survival/CustomTownLocations.json", "whiterun", Loc, allInstances = true)
	JsonUtil.FormListRemove("SL Survival/CustomTownLocations.json", "solitude", Loc, allInstances = true)
	JsonUtil.FormListRemove("SL Survival/CustomTownLocations.json", "markarth", Loc, allInstances = true)
	JsonUtil.FormListRemove("SL Survival/CustomTownLocations.json", "windhelm", Loc, allInstances = true)
	JsonUtil.FormListRemove("SL Survival/CustomTownLocations.json", "riften", Loc, allInstances = true)
	JsonUtil.Save("SL Survival/CustomTownLocations.json")
EndFunction

String Function GetLocationCurrentString()
	;/
	String LocString
	Location MyLoc = PlayerRef.GetCurrentLocation()
	If MyLoc == None
		Return "Nowhere"
	Else
		LocString = MyLoc.GetName()
		If LocString == ""
			LocString = "Nowhere"
		EndIf
	EndIf
	Return LocString
	/;
	String LocString = LocTrack.PlayerCurrentLocString
	If LocString == ""
		Return "Untracked location"
	EndIf
	Return LocString
EndFunction

Function ToggleDismemberment()
	If AmpType == 0
		Amputation.Shutdown()
	Else
		_SLS_AmputationQuest.Start()
	EndIf
EndFunction

Function ToggleCurseTats()
	If LicUtil.CurseTats
		If PlayerRef.HasMagicEffect(_SLS_MagicLicenceCollarMgef)
			Util.BeginOverlay(PlayerRef, 0.9, "\\SL Survival\\magic_silence_collar.dds", OverlayAreas[MagicCurseArea])
		EndIf
		If PlayerRef.HasMagicEffect(_SLS_LicBikiniCurseInactiveMgef) || PlayerRef.HasMagicEffect(_SLS_LicBikiniCurseStamina) 
			Util.BeginOverlay(PlayerRef, 0.9, "\\SL Survival\\bikini_curse_body.dds", OverlayAreas[BikiniCurseArea])
		EndIf
	
	Else
		Util.RemoveOverlay(PlayerRef, "\\SL Survival\\magic_silence_collar.dds", OverlayAreas[MagicCurseArea])
		Util.RemoveOverlay(PlayerRef, "\\SL Survival\\bikini_curse_body.dds", OverlayAreas[BikiniCurseArea])
	EndIf
EndFunction

Function SetInequalityEffects()
	_SLS_InequalitySpell.SetNthEffectMagnitude(0, IneqStatsVal) ; Health male
	_SLS_InequalitySpell.SetNthEffectMagnitude(1, IneqStatsVal) ; Health female
	_SLS_InequalitySpell.SetNthEffectMagnitude(2, IneqStatsVal) ; Magicka/Stamina male
	_SLS_InequalitySpell.SetNthEffectMagnitude(3, IneqStatsVal) ; Magicka/Stamina female
	_SLS_InequalitySpell.SetNthEffectMagnitude(4, IneqSpeedVal) ; Speed male
	_SLS_InequalitySpell.SetNthEffectMagnitude(5, (IneqDamageVal/100.0)) ; Damage mult male
	_SLS_InequalitySpell.SetNthEffectMagnitude(6, (IneqDamageVal/100.0)) ; Damage mult female
	_SLS_InequalitySpell.SetNthEffectMagnitude(7, IneqCarryVal) ; Carryweight female
	_SLS_InequalitySpell.SetNthEffectMagnitude(8, IneqDestVal) ; Destruction power male
	_SLS_InequalitySpell.SetNthEffectMagnitude(9, IneqDestVal) ; Destruction power female
EndFunction

Function ToggleBikiniExp()
	_SLS_BikiniExpLevel.SetValueInt(0)
	If BikiniExpT
		PlayerRef.AddSpell(_SLS_BikiniExpSpell)
		PlayerRef.AddPerk(_SLS_BikiniExpPerk)
		_SLS_BikiniExpTrainingQuest.Start()
	Else
		_SLS_BikiniExpTrainingQuest.Stop()
		PlayerRef.RemoveSpell(_SLS_BikiniExpSpell)
		PlayerRef.RemovePerk(_SLS_BikiniExpPerk)
	EndIf
EndFunction

Function ImportLicenceExceptions()
	Form akForm
	Int i = JsonUtil.FormListCount("SL Survival/LicenceExceptions.json", "LicenceExceptions")
	While i > 0
		i -= 1
		akForm = JsonUtil.FormListGet("SL Survival/LicenceExceptions.json", "LicenceExceptions", i)
		If akForm
			If akForm as Weapon
				_SLS_LicExceptionsWeapon.AddForm(akForm)
			ElseIf akForm as Armor
				_SLS_LicExceptionsArmor.AddForm(akForm)
			Else
				Debug.Trace("_SLS_: ImportLicenceExceptions(): Uncategorized item: " + akForm)
			EndIf
		EndIf
	EndWhile
EndFunction

Function AddWearableLanternExceptions()
	; Filter wearable lanterns. Other lanterns are non-playable so should filter ok. 
	If Game.GetModByName("Chesko_WearableLantern.esp") != 255
		_SLS_LicExceptionsArmor.AddForm(Game.GetFormFromFile(0x0111C2, "Chesko_WearableLantern.esp"))
		_SLS_LicExceptionsArmor.AddForm(Game.GetFormFromFile(0x011726, "Chesko_WearableLantern.esp"))
		_SLS_LicExceptionsArmor.AddForm(Game.GetFormFromFile(0x011727, "Chesko_WearableLantern.esp"))
		_SLS_LicExceptionsArmor.AddForm(Game.GetFormFromFile(0x010C3E, "Chesko_WearableLantern.esp"))
		_SLS_LicExceptionsArmor.AddForm(Game.GetFormFromFile(0x010C3F, "Chesko_WearableLantern.esp"))
	EndIf
EndFunction

Function AddRemoveLicenceException()
	Form akForm = EquipSlots[SelectedEquip]
	If !_SLS_LicExceptionsWeapon.HasForm(akForm) && !_SLS_LicExceptionsArmor.HasForm(akForm) ; Add exception
		If akForm as Weapon
			_SLS_LicExceptionsWeapon.AddForm(akForm)
		Else
			_SLS_LicExceptionsArmor.AddForm(akForm)
		EndIf
		JsonUtil.FormListAdd("SL Survival/LicenceExceptions.json", "LicenceExceptions", akForm, allowDuplicate = false)
		
	Else ; Remove exception
		If akForm as Weapon
			_SLS_LicExceptionsWeapon.RemoveAddedForm(akForm)
		Else
			_SLS_LicExceptionsArmor.RemoveAddedForm(akForm)
		EndIf
		JsonUtil.FormListRemove("SL Survival/LicenceExceptions.json", "LicenceExceptions", akForm, allInstances = true)
	EndIf
	JsonUtil.Save("SL Survival/LicenceExceptions.json")
EndFunction

Function BuildSplashArray()
	SplashArray = new String[4]
	SplashArray[0] = "SL Survival/Mcm1.dds"
	SplashArray[1] = "SL Survival/Mcm2.dds"
	SplashArray[2] = "SL Survival/Mcm3.dds"
	SplashArray[3] = "SL Survival/Mcm4.dds"
EndFunction

Function ToggleCumEffects()
	If CumEffectsEnable
		_SLS_CumEffectsQuest.Start()
	Else
		_SLS_CumEffectsQuest.Stop()
	EndIf
EndFunction

Function ToggleAnimalBreeding()
	If AnimalBreedEnable
		_SLS_AnimalFriendAliases.Start()
		_SLS_AnimalFriendQuest.Start()
	Else
		_SLS_AnimalFriendAliases.Stop()
		_SLS_AnimalFriendQuest.Stop()
	EndIf
EndFunction

Function ToggleBondFurn()
	If BondFurnEnable
		_SLS_DeviousFurnitureQuest.Start()
	Else
		_SLS_DeviousFurnitureQuest.Stop()
	EndIf
EndFunction

Function RefreshBikiniExpEffects() ; Changes to bikini mgefs will require reloading the spells to take effect
	PlayerRef.RemoveSpell(_SLS_BikiniExpSpell)
	PlayerRef.RemovePerk(_SLS_BikiniExpPerk)
	If BikiniExpT
		Utility.Wait(5.0)
		PlayerRef.AddSpell(_SLS_BikiniExpSpell)
		PlayerRef.AddPerk(_SLS_BikiniExpPerk)
	EndIf
EndFunction

Function ToggleBikiniCurse()
		LicUtil.CheckForBikiniCurse()
EndFunction

Function SetHorseCost(Int Cost)
	HorseCost.SetValueInt(Cost)
	Stables.UpdateCurrentInstanceGlobal(HorseCost)
EndFunction

Function GetEquippedList()
	SetTextOptionValue(LicGetEquipListOID_T, "Working...")
	StorageUtil.FormListClear(Self, "_SLS_EquipSlots")
	StorageUtil.StringListClear(Self, "_SLS_EquipSlotStrings")
	
	StorageUtil.FormListAdd(Self, "_SLS_EquipSlots", None, allowDuplicate = false)
;/
	Int[] SlotMasks = new Int[32]
	SlotMasks[0] = 1 ; kSlotMask30
	SlotMasks[1] = 2 ; kSlotMask31
	SlotMasks[2] = 4 ; kSlotMask32
	SlotMasks[3] = 8 ; kSlotMask33
	SlotMasks[4] = 16 ; kSlotMask34
	SlotMasks[5] = 32 ; kSlotMask35
	SlotMasks[6] = 64 ; kSlotMask36
	SlotMasks[7] = 128 ; kSlotMask37
	SlotMasks[8] = 256 ; kSlotMask38
	SlotMasks[9] = 512 ; kSlotMask39
	SlotMasks[10] = 1024 ; kSlotMask40
	SlotMasks[11] = 2048 ; kSlotMask41
	SlotMasks[12] = 4096 ; kSlotMask42
	SlotMasks[13] = 8192 ; kSlotMask43
	SlotMasks[14] = 16384 ; kSlotMask44
	SlotMasks[15] = 32768 ; kSlotMask45
	SlotMasks[16] = 65536 ; kSlotMask46
	SlotMasks[17] = 131072 ; kSlotMask47
	SlotMasks[18] = 262144 ; kSlotMask48
	SlotMasks[19] = 524288 ; kSlotMask49
	SlotMasks[20] = 1048576 ; kSlotMask50
	SlotMasks[21] = 2097152 ; kSlotMask51
	SlotMasks[22] = 4194304 ; kSlotMask52
	SlotMasks[23] = 8388608 ; kSlotMask53
	SlotMasks[24] = 16777216 ; kSlotMask54
	SlotMasks[25] = 33554432 ; kSlotMask55
	SlotMasks[26] = 67108864 ; kSlotMask56
	SlotMasks[27] = 134217728 ; kSlotMask57
	SlotMasks[28] = 268435456 ; kSlotMask58
	SlotMasks[29] = 536870912 ; kSlotMask59
	SlotMasks[30] = 1073741824 ; kSlotMask60
	SlotMasks[31] = 2147483648 ; kSlotMask61
/;	
	;Int Index = 0
	Form akForm
	akForm = PlayerRef.GetEquippedWeapon(abLeftHand = false)
	If akForm
		StorageUtil.FormListAdd(Self, "_SLS_EquipSlots", akForm)
		;Index += 1
	EndIf
	akForm = PlayerRef.GetEquippedWeapon(abLeftHand = true)
	If akForm
		StorageUtil.FormListAdd(Self, "_SLS_EquipSlots", akForm)
		;Index += 1
	EndIf
	
	
	Int i = 0
	While i < SlotMasks.Length
		akForm = PlayerRef.GetWornForm(SlotMasks[i])
		If akForm
			If !akForm.HasKeyword(SexlabNoStrip) && (akForm as Armor).IsPlayable() && akForm.GetName() != ""
				StorageUtil.FormListAdd(Self, "_SLS_EquipSlots", akForm, allowDuplicate = false)
			EndIf
		EndIf
		i += 1
	EndWhile
	EquipSlots = StorageUtil.FormListToArray(Self, "_SLS_EquipSlots")
	
	If EquipSlots[SelectedEquip] == None
		SelectedEquip = 0
	EndIf		
	
	i = 0
	While i < EquipSlots.Length
		akForm = EquipSlots[i]
		If akForm == None
			StorageUtil.StringListAdd(Self, "_SLS_EquipSlotStrings", "None ")
		Else
			StorageUtil.StringListAdd(Self, "_SLS_EquipSlotStrings", akForm.GetName() + " - " + akForm)
		EndIf
		i += 1
	EndWhile
	EquipSlotStrings = StorageUtil.StringListToArray(Self, "_SLS_EquipSlotStrings")
	SetTextOptionValue(LicGetEquipListOID_T, "Done! ")
EndFunction

Function ModLicBuyBlock()
	If _SLS_LicenceBuyBlockerQuest.IsRunning()
		LicBuyBlocker.DoRandomize()
	EndIf
EndFunction

Function ToggleDebugMode()
	If Init.DebugMode
		PlayerRef.AddSpell(_SLS_DebugGetActorPackSpell)
		PlayerRef.AddSpell(_SLS_DebugGetActorVoiceTypeSpell)
	Else
		PlayerRef.RemoveSpell(_SLS_DebugGetActorPackSpell)
		PlayerRef.RemoveSpell(_SLS_DebugGetActorVoiceTypeSpell)
	EndIf
EndFunction

Function UpdateMenuText(Int MenuOption, String Text)
	If IsInMcm
		SetTextOptionValue(MenuOption, Text)
	EndIf
EndFunction

Function LicShowApiBlockForms()
	;Debug.Messagebox(StorageUtil.FormListCount(None, "_SLS_LicenceBlockingForms"))
	String Blockers = "Licences blocked: " + ((Game.GetFormFromFile(0x08666A, "SL Survival.esp") as GlobalVariable).GetValueInt() as Bool) + "\n\nBlocking Forms: "
	Int i = 0
	While i < StorageUtil.FormListCount(None, "_SLS_LicenceBlockingForms")
		Blockers += "\n" + StorageUtil.FormListGet(None, "_SLS_LicenceBlockingForms", i)
		i += 1
	EndWhile
	Debug.Messagebox(Blockers)
EndFunction

Function LicClearApiBlockForms()
	(Game.GetFormFromFile(0x08666A, "SL Survival.esp") as GlobalVariable).SetValueInt(0)
	StorageUtil.FormListClear(None, "_SLS_LicenceBlockingForms")
EndFunction

Function BuildSexOptionsArrays()
	Bool DflowInstalled = false
	If Game.GetModByName("") != 255
		DflowInstalled = true
		SexAggressiveness = new String[5]
	Else
		SexAggressiveness = new String[3]
	EndIf
	SexAggressiveness[0] = "Not Aggressive"
	SexAggressiveness[1] = "Don't Care"
	SexAggressiveness[2] = "Aggressive"
	If DflowInstalled
		SexAggressiveness[3] = "Use DF Willpower Fixed"
		SexAggressiveness[4] = "Use DF Willpower % Chance"
	EndIf
	
	SexPlayerIsVictim = new String[2]
	SexPlayerIsVictim[0] = "Player Is Not Victim"
	SexPlayerIsVictim[1] = "Player Is Victim"
EndFunction

Function RefreshBikiniCurseOverlay(Int index)
	Util.RemoveOverlay(PlayerRef, "\\SL Survival\\bikini_curse_body.dds", OverlayAreas[BikiniCurseArea])
	If PlayerRef.HasMagicEffect(_SLS_LicBikiniCurseInactiveMgef) || PlayerRef.HasMagicEffect(_SLS_LicBikiniCurseStamina)	
		Util.BeginOverlay(PlayerRef, 0.9, "\\SL Survival\\bikini_curse_body.dds", OverlayAreas[index])
	EndIf
EndFunction

Function RefreshMagicCurseOverlay(Int index)
	Util.RemoveOverlay(PlayerRef, "\\SL Survival\\magic_silence_collar.dds", OverlayAreas[MagicCurseArea])
	If PlayerRef.HasMagicEffect(_SLS_MagicLicenceCollarMgef)
		Util.BeginOverlay(PlayerRef, 0.9, "\\SL Survival\\magic_silence_collar.dds", OverlayAreas[index])
	EndIf
EndFunction

Function ToggleIneqSkills()
	If InequalitySkills
		PlayerRef.AddPerk(_SLS_InequalitySkillsPerk)
	Else
		PlayerRef.RemovePerk(_SLS_InequalitySkillsPerk)
	EndIf
EndFunction

Function ToggleIneqBuySell()
	If InequalityBuySell
		PlayerRef.AddPerk(_SLS_InequalityBuySellPerk)
	Else
		PlayerRef.RemovePerk(_SLS_InequalityBuySellPerk)
	EndIf
EndFunction

Function ToggleCreatureEvents()
	If Init.SlsCreatureEvents
		PlayerRef.AddPerk(_SLS_CreatureTalk)
	Else
		PlayerRef.RemovePerk(_SLS_CreatureTalk)
	EndIf
EndFunction

Function ToggleFastTravelDisable()
	If !FastTravelDisable
		Game.EnableFastTravel()
	EndIf
EndFunction

Function ToggleLicMagicCursedDevices()
	If LicUtil.LicMagicCursedDevices
		PlayerRef.RemoveSpell(_SLS_MagicLicenceCurse)
	EndIf
EndFunction

Function ToggleBarefootMag()
	PlayerRef.RemoveSpell(Main._SLS_BarefootSpeedSpell)
	If BarefootMag > 0.0
		Main.BarefootMaintenance()
		Utility.Wait(0.1)
		PlayerRef.AddSpell(Main._SLS_BarefootSpeedSpell, false)
	EndIf
EndFunction

Function ToggleCatCalling()
	If CatCallVol > 0.0
		_SLS_CatCallsQuest.Start()
	Else
		_SLS_CatCallsQuest.Stop()
	EndIf
EndFunction

Function ToggleLicenceStyle()
	LicUtil.ChangeLicenceStyle()
EndFunction

Function ToggleGuardBehavLockpick()
	If GuardBehavLockpicking
		_SLS_GuardWarnLockpickQuest.Start()
	Else
		_SLS_GuardWarnLockpickQuest.Stop()
	EndIf
EndFunction

Function ToggleGuardBehavDrugs()
	If GuardBehavDrugs
		_SLS_GuardWarnDrugsQuest.Start()
	Else
		_SLS_GuardWarnDrugsQuest.Stop()
	EndIf
EndFunction

Function ToggleGuardBehavWeapDrawn()
	If GuardBehavWeapDrawn
		PlayerRef.AddSpell(_SLS_WeaponReadySpell, false)
	Else
		If !MinAvToggleT
			PlayerRef.RemoveSpell(_SLS_WeaponReadySpell)
		EndIf
		_SLS_GuardWarnWeapDrawnQuest.Stop()
		;_SLS_GuardWarnWeapDrawnDetectionQuest.Stop()
	EndIf
EndFunction

Function ToggleGuardBehavWeapEquip()
	If GuardBehavWeapEquip && Init.IsPlayerInside
		_SLS_GuardWarnWeapEquippedQuest.Start()
	Else
		_SLS_GuardWarnWeapEquippedQuest.Stop()
		;_SLS_GuardWarnWeapEquippedDetectQuest.Stop()
	EndIf
EndFunction

Function ToggleGuardBehavArmorEquip()
	If GuardBehavArmorEquip && Init.IsPlayerInside
		_SLS_GuardWarnArmorEquippedQuest.Start()
	Else
		_SLS_GuardWarnArmorEquippedQuest.Stop()
		;_SLS_GuardWarnArmorEquippedDetectQuest.Stop()
	EndIf
EndFunction

Function ToggleGuardComments()
	If GuardComments
		_SLS_GuardHellosQuest.Start()
	Else
		_SLS_GuardHellosQuest.Stop()
	EndIf
EndFunction

Function ToggleCumAsLactacid(VoiceType Voice)
	; Send Voice = None to toggle all
	If Voice ; Add/Remove specific voice
		If _SLS_CumHasLactacidVoices.HasForm(Voice)
			_SLS_CumHasLactacidVoices.RemoveAddedForm(Voice)
		Else
			_SLS_CumHasLactacidVoices.AddForm(Voice)
		EndIf
		
	Else ; Toggle All
		If CumLactacidAll
			Form akForm
			Int i = 0
			While i < _SLS_CumLactacidVoicesList.GetSize()
				_SLS_CumHasLactacidVoices.AddForm(_SLS_CumLactacidVoicesList.GetAt(i))
				i += 1
			EndWhile
		Else
			_SLS_CumHasLactacidVoices.Revert()
		EndIf
	EndIf
EndFunction

Function ToggleCumAsLactacidCustom()
	Actor akActor = Game.GetCurrentCrosshairRef() as Actor
	If akActor
		VoiceType Voice = akActor.GetVoiceType()
		If Voice
			If _SLS_CumHasLactacidVoices.HasForm(Voice)
				_SLS_CumHasLactacidVoices.RemoveAddedForm(Voice)
			Else
				_SLS_CumHasLactacidVoices.AddForm(Voice)
			EndIf
		EndIf
	EndIf
EndFunction

Function ToggleProxSpank()
	_SLS_HelloSpankAnythingQuest.Stop()
	_SLS_HelloSpankGuardsQuest.Stop()
	_SLS_HelloSpankGuardsAndMenQuest.Stop()
	_SLS_HelloSpankMenQuest.Stop()
	_SLS_HelloSpankWomenQuest.Stop()
	
	If Game.GetModByName("Spank That Ass.esp") == 255
		ProxSpankNpcType = 5
	EndIf
	
	If ProxSpankNpcType == 0
		_SLS_HelloSpankGuardsQuest.Start()
	ElseIf ProxSpankNpcType == 1
		_SLS_HelloSpankGuardsAndMenQuest.Start()
	ElseIf ProxSpankNpcType == 2
		_SLS_HelloSpankMenQuest.Start()
	ElseIf ProxSpankNpcType == 3
		_SLS_HelloSpankWomenQuest.Start()
	ElseIf ProxSpankNpcType == 4
		_SLS_HelloSpankAnythingQuest.Start()		
	EndIf
EndFunction

Function ToggleCumAddiction()
	If CumAddictEn
		(Game.GetFormFromFile(0x097F8F, "SL Survival.esp")as Quest).Start() ; _SLS_CumAddictQuest
	Else
		PlayerRef.RemoveSpell(_SLS_CumAddictHungerSpell)
		CumAddict.ToggleDaydreaming(false)
		Utility.Wait(0.1)
		PlayerRef.RemoveSpell(_SLS_CumAddictStatusSpell)
		(Game.GetFormFromFile(0x097F8F, "SL Survival.esp") as Quest).Stop() ; _SLS_CumAddictQuest
		(Game.GetFormFromFile(0x0850D2, "SL Survival.esp") as _SLS_Api).SendCumHungerChangeEvent(HungerState = -1)
	EndIf
EndFunction

Function ToggleCoverMechanics()
	If CoverMyselfMechanics
		;If IsCoverAnimationInstalled()
			If _SLS_BodyCoverStatus.GetValueInt() == 0 ; Player is naked
				_SLS_CoverMySelfQuest.Start()
			Else
				_SLS_CoverMySelfQuest.Stop()
				;Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
				Debug.SendAnimationEvent(PlayerRef, "OffsetStop")
			EndIf
		;/Else
			CoverMyselfMechanics = false
			_SLS_CoverMySelfQuest.Stop()
			;Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
			Debug.SendAnimationEvent(PlayerRef, "OffsetStop")
			_SLS_CoveringNakedStatus.SetValueInt(1)
		EndIf/;
	Else
		_SLS_CoverMySelfQuest.Stop()
		;Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		Debug.SendAnimationEvent(PlayerRef, "OffsetStop")
		_SLS_CoveringNakedStatus.SetValueInt(1)
	EndIf
EndFunction
;/
Bool Function IsCoverAnimationInstalled()
	;If MiscUtil.FileExists("data/Meshes/actors/character/animations/ZaZAnimationPack/ZaZAPCSHFOFF.HKX")
	If MiscUtil.FileExists("data/Meshes/Actors/Character/Animations/Deviously Cursed Loot/DCLFTNudeCoverOff.HKX")
		Return true
	EndIf
	Return false
EndFunction
/;
Function ToggleCumAddictAutoSuckCreature()
	If CumAddictAutoSuckCreature == 0.0
		_SLS_CumAddictAutoSuckCreatureQuest.Stop()
	Else
		If CumAddict.GetHungerState() >= 1
			_SLS_CumAddictAutoSuckCreatureQuest.Start()
		EndIf
	EndIf
EndFunction

String Function TidyFormString(Form akForm)
	; Example: Returns 'ImperialRace' FROM '[Race <ImperialRace (00013744)>]'
	String S1 = StringUtil.Substring(akForm, StringUtil.Find(akForm, "<", 0) + 1)
	Return StringUtil.Substring(S1, 0, len = StringUtil.Find(S1, " (", 0))
EndFunction

Function ToggleSexExp()
	If SexExpEn
		If Game.GetModByName("SLSO.esp") != 255
			_SLS_SexExperienceQuest.Start()
		Else
			SexExpEn = false
			_SLS_SexExperienceQuest.Stop()
			_SLS_SexCockSizeQuest.Stop()
		EndIf
	Else
		_SLS_SexExperienceQuest.Stop()
		_SLS_SexCockSizeQuest.Stop()
	EndIf
EndFunction

Function ResetSexExpStats()
	Int i = 0
	Form akForm
	While i < StorageUtil.FormListCount(None, "_SLS_HumanSexForms")
		akForm = StorageUtil.FormListGet(None, "_SLS_HumanSexForms", i)
		StorageUtil.UnsetIntValue(akForm, "_SLS_SexExperienceFemale")
		StorageUtil.UnsetIntValue(akForm, "_SLS_SexExperienceMale")
		i += 1
	EndWhile
	StorageUtil.FormListClear(None, "_SLS_HumanSexForms")
	
	i = 0
	While i < StorageUtil.FormListCount(None, "_SLS_CreatureSexForms")
		akForm = StorageUtil.FormListGet(None, "_SLS_CreatureSexForms", i)
		StorageUtil.UnsetIntValue(akForm, "_SLS_SexExperience")
		i += 1
	EndWhile
	StorageUtil.FormListClear(None, "_SLS_CreatureSexForms")
	
	StorageUtil.UnSetIntValue(None, "_SLS_CreatureSexOrgasmCount")
	StorageUtil.UnSetIntValue(None, "_SLS_HumanSexOrgasmCount")
	StorageUtil.UnSetIntValue(None, "_SLS_CreatureSexCount")
	StorageUtil.UnSetIntValue(None, "_SLS_HumanSexCount")
	
	StorageUtil.UnSetIntValue(None, "_SLS_CreatureCorruption")
EndFunction

Function ToggleIneqStrongFemaleFollowers()
	; Do vanilla followers
	Actor Follower
	Actor[] FolList = new Actor[23]
	FolList[0] = Game.GetFormFromFile(0x01C1A4, "Skyrim.esm") as Actor ; Brelyna
	FolList[1] = Game.GetFormFromFile(0x01A697, "Skyrim.esm") as Actor ; Aela the Huntress
	FolList[2] = Game.GetFormFromFile(0x01A6DA, "Skyrim.esm") as Actor ; Njada Stonearm
	FolList[3] = Game.GetFormFromFile(0x01A6D8, "Skyrim.esm") as Actor ; Ria
	FolList[4] = Game.GetFormFromFile(0x015D09, "Skyrim.esm") as Actor ; Dark Brotherhood Initiate (female)
	FolList[5] = Game.GetFormFromFile(0x0E1BA9, "Skyrim.esm") as Actor ; Jenassa
	FolList[6] = Game.GetFormFromFile(0x0A2C93, "Skyrim.esm") as Actor ; Iona
	FolList[7] = Game.GetFormFromFile(0x0A2C95, "Skyrim.esm") as Actor ; Jordis the Sword-Maiden
	FolList[8] = Game.GetFormFromFile(0x0A2C94, "Skyrim.esm") as Actor ; Lydia
	FolList[9] = Game.GetFormFromFile(0x05B688, "Skyrim.esm") as Actor ; Borgakh the Steel Heart
	FolList[10] = Game.GetFormFromFile(0x019E1B, "Skyrim.esm") as Actor ; Ugor
	FolList[11] = Game.GetFormFromFile(0x01B13E, "Skyrim.esm") as Actor ; Adelaisa Vendicci
	FolList[12] = Game.GetFormFromFile(0x01B092, "Skyrim.esm") as Actor ; Annekke Crag-Jumper
	FolList[13] = Game.GetFormFromFile(0x028AD1, "Skyrim.esm") as Actor ; Aranea Ienith
	FolList[14] = Game.GetFormFromFile(0x01BB8E, "Skyrim.esm") as Actor ; Eola
	FolList[15] = Game.GetFormFromFile(0x019DF7, "Skyrim.esm") as Actor ; Mjoll the Lioness
	FolList[16] = Game.GetFormFromFile(0x091918, "Skyrim.esm") as Actor ; Uthgerd the Unbroken
	FolList[17] = Game.GetFormFromFile(0x013485, "Skyrim.esm") as Actor ; Delphine
	
	; Dawnguard
	FolList[18] = Game.GetFormFromFile(0x015C14, "Skyrim.esm") as Actor ; Beleval
	FolList[19] = Game.GetFormFromFile(0x015C17, "Skyrim.esm") as Actor ; Ingjard
	FolList[20] = Game.GetFormFromFile(0x002B74, "Skyrim.esm") as Actor ; Serana
	
	; Dragonborn
	FolList[21] = Game.GetFormFromFile(0x017A0D, "Skyrim.esm") as Actor ; Frea
	
	; Hearthfire
	FolList[22] = Game.GetFormFromFile(0x005216, "Skyrim.esm") as Actor ; Rayya
	
	Int i = FolList.Length
	While i > 0
		i -= 1
		Follower = FolList[i]
		SetStrongFollower(Follower)
	EndWhile
	
	; Do escorts
	i = JsonUtil.FormListCount("SL Survival/EscortList.json", "Escorts")
	While i > 0
		i -= 1
		Follower = JsonUtil.FormListGet("SL Survival/EscortList.json", "Escorts", i) as Actor
		SetStrongFollower(Follower)
	EndWhile
EndFunction

Function SetStrongFollower(Actor Follower)
	If Follower && Follower.GetActorBase().GetSex() == 1
		If IneqStrongFemaleFollowers
			Follower.AddToFaction(_SLS_IneqStrongFemaleFact)
		Else
			Follower.RemoveFromFaction(_SLS_IneqStrongFemaleFact)
		EndIf
	EndIf
EndFunction

Function SetStrongFemale()
	Actor CrossHairRef = Game.GetCurrentCrosshairRef() as Actor
	If CrossHairRef && CrossHairRef.GetActorBase().GetSex() == 1
		If !CrossHairRef.IsInFaction(_SLS_IneqStrongFemaleFact)
			CrossHairRef.AddToFaction(_SLS_IneqStrongFemaleFact)
			JsonUtil.FormListAdd("SL Survival/StrongFemales.json", "StrongFemales", CrossHairRef, allowDuplicate = false)
		Else
			CrossHairRef.RemoveFromFaction(_SLS_IneqStrongFemaleFact)
			JsonUtil.FormListRemove("SL Survival/StrongFemales.json", "StrongFemales", CrossHairRef, allInstances = true)
		EndIf
		JsonUtil.Save("SL Survival/StrongFemales.json")
	EndIf
EndFunction

Function ImportStrongFemales()
	Actor Female
	Int i = JsonUtil.FormListCount("SL Survival/StrongFemales.json", "StrongFemales")
	While i > 0
		i -= 1
		Female = JsonUtil.FormListGet("SL Survival/StrongFemales.json", "StrongFemales", i) as Actor
		If Female
			Female.AddToFaction(_SLS_IneqStrongFemaleFact)
		EndIf
	EndWhile
EndFunction

Function AddRemoveChainCollars(Bool AddToList)
	;Debug.MessageBox("AddRemoveChainCollars: " + AddToList + ". Count before: " + JsonUtil.FormListCount("SL Survival/DeviceList.json", "steelcollars"))
	If AddToList
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4DE, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4DF, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4DD, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4DC, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4E2, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4E3, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4E1, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4E0, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4DE, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4DF, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4DD, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4DC, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4E2, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4E3, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4E1, "Devious Devices - Expansion.esm"), allowDuplicate = false)
		JsonUtil.FormListAdd("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4E0, "Devious Devices - Expansion.esm"), allowDuplicate = false)
	Else
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4DE, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4DF, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4DD, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4DC, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4E2, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4E3, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4E1, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "steelcollars", Game.GetFormFromFile(0x02E4E0, "Devious Devices - Expansion.esm"), allInstances = true)
		
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4DE, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4DF, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4DD, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4DC, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4E2, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4E3, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4E1, "Devious Devices - Expansion.esm"), allInstances = true)
		JsonUtil.FormListRemove("SL Survival/DeviceList.json", "collars", Game.GetFormFromFile(0x02E4E0, "Devious Devices - Expansion.esm"), allInstances = true)
	EndIf
	JsonUtil.Save("SL Survival/DeviceList.json")
	;Debug.MessageBox("AddRemoveChainCollars: " + AddToList + ". Count After: " + JsonUtil.FormListCount("SL Survival/DeviceList.json", "steelcollars"))
EndFunction

Function ReplaceVanillaMaps(Bool AddMaps)
	Int i = _SLS_StaticMapList.GetSize()
	ObjectReference Map
	While i > 0
		i -= 1
		Map = _SLS_StaticMapList.GetAt(i) as ObjectReference
		If AddMaps
			Map.Disable()
		Else
			Map.Enable()
		EndIf
	EndWhile

	i = _SLS_ActivatableMapList.GetSize()
	While i > 0
		i -= 1
		Map = _SLS_ActivatableMapList.GetAt(i) as ObjectReference
		If AddMaps
			Map.Enable()
		Else
			Map.Disable()
		EndIf
	EndWhile
EndFunction

Function ToggleStashTracking()
	If StashTrackEn
		_SLS_StashTrack.Start()
	Else
		StashTrack.TerminateTracking()
	EndIf
EndFunction

Function StashClearAllStashExceptions()
	StashClearAllJsonExceptions()
	StashClearAllTempExceptions()
EndFunction

Function StashClearAllJsonExceptions()
	ObjectReference ObjRef
	Int i = JsonUtil.FormListCount("SL Survival/StashExceptions.json", "StashExceptions")
	While i > 0
		i -= 1
		ObjRef = JsonUtil.FormListGet("SL Survival/StashExceptions.json", "StashExceptions", i) as ObjectReference
		If ObjRef
			StorageUtil.UnSetIntValue(ObjRef, "_SLS_StashExceptionContainer")
			StorageUtil.FormListRemove(None, "_SLS_StashExceptionsAll", ObjRef, allInstances = true)
		EndIf
	EndWhile
	JsonUtil.FormListClear("SL Survival/StashExceptions.json", "StashExceptions")
	JsonUtil.Save("SL Survival/StashExceptions.json")
EndFunction

Function StashClearAllTempExceptions()
	ObjectReference ObjRef
	Int i = StorageUtil.FormListCount(None, "_SLS_StashExceptionsTemp")
	While i > 0
		i -= 1
		ObjRef = StorageUtil.FormListGet(None, "_SLS_StashExceptionsTemp", i) as ObjectReference
		If ObjRef
			StorageUtil.UnSetIntValue(ObjRef, "_SLS_StashExceptionContainer")
			StorageUtil.FormListRemove(None, "_SLS_StashExceptionsAll", ObjRef, allInstances = true)
		EndIf		
	EndWhile
	StorageUtil.FormListClear(None, "_SLS_StashExceptionsTemp")
EndFunction

Function SearchEscorts()
	; Populate forbidden escorts before scan
	Formlist ForbiddenEscorts = Game.GetFormFromFile(0x0E0928, "SL Survival.esp") as Formlist
	ForbiddenEscorts.Revert()
	Form akForm
	String CurModName
	Int i = 0
	While i < JsonUtil.StringListCount("SL Survival/ForbiddenEscorts.json", "modnames")
		CurModName = JsonUtil.StringListGet("SL Survival/ForbiddenEscorts.json", "modnames", i)
		If Game.GetModByName(CurModName) != 255
			Int j = 0
			;Debug.Messagebox("CurModName: " + CurModName + "\nCount: "  + JsonUtil.FormListCount("SL Survival/ForbiddenEscorts.json", CurModName))
			While j < JsonUtil.FormListCount("SL Survival/ForbiddenEscorts.json", CurModName)
				akForm = JsonUtil.FormListGet("SL Survival/ForbiddenEscorts.json", CurModName, j)
				If akForm
					ForbiddenEscorts.AddForm(akForm)
				EndIf
				j += 1
			EndWhile
		EndIf
		i += 1
	EndWhile
	
	If Game.GetModByName("Dawnguard.esm") != 255
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x00336E, "Dawnguard.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x01541C, "Dawnguard.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x01541E, "Dawnguard.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x01541D, "Dawnguard.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x01541B, "Dawnguard.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x002B6C, "Dawnguard.esm"))
	EndIf
	If Game.GetModByName("HearthFires.esm") != 255
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x00521E, "HearthFires.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x005215, "HearthFires.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x00521B, "HearthFires.esm"))		
	EndIf
	If Game.GetModByName("Dragonborn.esm") != 255
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x017934, "Dragonborn.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x017777, "Dragonborn.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x038560, "Dragonborn.esm"))
		_SLS_EscortsVanilla.AddForm(Game.GetFormFromFile(0x0179C7, "Dragonborn.esm"))
	EndIf

	Int FollowersAddedTotal = 0
	Int NewFolCount = 1
	Int Button = 1
	Actor Follower
	String[] EscortPlusModname = new String[15]
	While Button == 1 && NewFolCount > 0
		i = _SLS_EscortsList.GetSize()
		While i > 0
			i -= 1
			_SLS_EscortsBaseList.AddForm((_SLS_EscortsList.GetAt(i) as ObjectReference).GetBaseObject())
		EndWhile
	
		_SLS_FindEscortsQuest.Stop()
		_SLS_FindEscortsQuest.Start()
		Utility.Wait(1.0)
		NewFolCount = 0
		i = 0
		;Debug.Trace("_SLS_: Escorts: LOOP START ====================================")
		While i < _SLS_FindEscortsQuest.GetNumAliases()
			Follower = (_SLS_FindEscortsQuest.GetNthAlias(i) as ReferenceAlias).GetReference() as Actor
			If Follower
				EscortPlusModname[i] = "\n" + (i + 1) + ") " + Follower.GetBaseObject().GetName() + " | " + Game.GetModName(Math.RightShift(Math.LogicalAnd(Follower.GetFormID(), 0xFF000000), 24))
				;NewFols += "\n" + (i + 1) + ") " + Follower.GetBaseObject().GetName() + " - " + Game.GetModName(Math.RightShift(Math.LogicalAnd(Follower.GetFormID(), 0xFF000000), 24))
				;Debug.Trace("_SLS_: Escorts: " + (i + 1) + ") " + Follower.GetBaseObject().GetName())
				
				NewFolCount += 1
			Else
				;Debug.Trace("_SLS_: Escorts: " + (i + 1) + ") Nothing here apparently????")
				;EscortPlusModname[i] = "\n" + (i + 1) + ") Nothing here ???"
				EscortPlusModname[i] = ""
			EndIf
			i += 1
		EndWhile

		If NewFolCount > 0
			Debug.Messagebox("Found these followers:" + EscortPlusModname[0] + EscortPlusModname[1] + EscortPlusModname[2] + EscortPlusModname[3] + EscortPlusModname[4] + EscortPlusModname[5] + EscortPlusModname[6] + EscortPlusModname[7] + EscortPlusModname[8] + EscortPlusModname[9] + EscortPlusModname[10] + EscortPlusModname[11] + EscortPlusModname[12] + EscortPlusModname[13] + EscortPlusModname[14])
		Else
			Debug.Messagebox("No more followers found")
		EndIf
		
		If NewFolCount > 0
			Button = _SLS_AddEscortsMsg.Show()
			If Button == 1 
				i = 0
				While i < _SLS_FindEscortsQuest.GetNumAliases()
					Follower = (_SLS_FindEscortsQuest.GetNthAlias(i) as ReferenceAlias).GetReference() as Actor
					If Follower
						_SLS_EscortsList.AddForm(Follower)
						JsonUtil.FormListAdd("SL Survival/EscortList.json", "Escorts", Follower, allowDuplicate = false)
						SetStrongFollower(Follower)	
						FollowersAddedTotal += 1
					EndIf
					i += 1
				EndWhile
				
				JsonUtil.Save("SL Survival/EscortList.json")
			EndIf
		EndIf
		;Debug.Messagebox("_SLS_EscortsList.GetSize(): " + _SLS_EscortsList.GetSize() + "\nNewFolCount: " + NewFolCount + "\nButton: " + Button)
		_SLS_EscortsBaseList.Revert()
	EndWhile
	Debug.Messagebox("Done adding escorts!\nTotal escorts added: " + FollowersAddedTotal)
EndFunction

Function ReImportEscorts()
	_SLS_EscortsList.Revert()
	ImportEscorts()
EndFunction

Function ClearAllEscorts()
	_SLS_EscortsList.Revert()
	JsonUtil.FormListClear("SL Survival/EscortList.json", "Escorts")
	JsonUtil.Save("SL Survival/EscortList.json")
EndFunction

Bool Function CanEnableSnowberry()
	If Game.GetModByName("Skyrim Unbound.esp") != 255 ; Unbound
		If (Game.GetFormFromFile(0x000D62, "Skyrim Unbound.esp") as Quest).GetCurrentStageID() < 100
			Return true
		EndIf
	ElseIf MQ101.GetCurrentStageID() < 240 ; Alternate Start / Vanilla
		Return true
	EndIf
	Return false
EndFunction

Function SetGagSpeechDebuff()
	; ForceIt - Spell Mag changes don't persist through game loads anyway
	If (Game.GetModByName("Devious Devices - Integration.esm") != 255)
		Spell GagDebuff = Game.GetFormFromFile(0x04B63C, "Devious Devices - Integration.esm") as Spell
		GagDebuff.SetNthEffectMagnitude(0, DeviousGagDebuff)
	EndIf
EndFunction

Bool Function GetIsSleepDeprivationEnabled()
	Return SleepDepriv
EndFunction

Function ToggleNpcComments()
	If (Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).GetValueInt() == 0 ; _SLS_NpcComments
		(Game.GetFormFromFile(0x0DEDA7, "SL Survival.esp") as Quest).Stop() ; _SLS_NpcHellosQuest
	Else
		(Game.GetFormFromFile(0x0DEDA7, "SL Survival.esp") as Quest).Start() ; _SLS_NpcHellosQuest
	EndIf
EndFunction

Function ToggleJiggles()
	PlayerRef.RemoveSpell(Game.GetFormFromFile(0x0CF9B0, "SL Survival.esp") as Spell)
	If StorageUtil.GetIntValue(Self, "Jiggles", Missing = 1) == 1
		PlayerRef.AddSpell(Game.GetFormFromFile(0x0CF9B0, "SL Survival.esp") as Spell)
	EndIf
EndFunction

Function ToggleCompulsiveSex()
	If StorageUtil.GetIntValue(Self, "CompulsiveSex", Missing = 1) == 0
		(Game.GetFormFromFile(0x0E7553, "SL Survival.esp") as Quest).Stop()
	Else
		(Game.GetFormFromFile(0x0E7553, "SL Survival.esp") as Quest).Start()
	EndIf
EndFunction

Function ToggleOrgasmFatigue()
	If StorageUtil.GetIntValue(Self, "OrgasmFatigue", Missing = 1) == 0
		(Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).Shutdown()
	Else
		(Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as Quest).Start()
	EndIf
EndFunction

Function TestBikiniArmor()
	String OutStr = "Slot) Armor Name - HasKeyword - BikiniFlag\n\n"
	Form akForm
	Keyword BikiniKeyword = Game.GetFormFromFile(0x049867, "SL Survival.esp") as Keyword
	Int i = 0
	While i < SlotMasks.Length
		akForm = PlayerRef.GetWornForm(SlotMasks[i])
		If akForm && akForm.GetName() != ""
			OutStr += (i+30) + ") " + akForm.GetName() + " - " + TranslateBoolToYesNo(akForm.HasKeyword(BikiniKeyword)) + " - " + TranslateBoolToYesNo(StorageUtil.GetIntValue(akForm, "SLAroused.IsSlootyArmor", Missing = -1) > 0) + "\n"
		EndIf
		i += 1
	EndWhile
	
	OutStr += "\nHeels - NiO (Height) - HDT - KillerHeelsFlag\n"
	akForm = PlayerRef.GetWornForm(0x00000080)
	If akForm
		Bool IsHdtHeels
		MagicEffect HdtHeelsEffect
		If Game.GetModByName("") != 255
			HdtHeelsEffect = Game.GetFormFromFile(0x000800, "hdtHighHeel.esm") as MagicEffect
			IsHdtHeels = PlayerRef.HasMagicEffect(HdtHeelsEffect)
		EndIf
		OutStr += akForm.GetName() + " - " + TranslateBoolToYesNo(NiOverride.HasNodeTransformPosition(PlayerRef, False, true, "NPC", "internal")) + " (" + AllInOne.SnipToDecimalPlaces(NiOverride.GetNodeTransformPosition(PlayerRef, false, true, "NPC", "internal")[2] as String, 1) + ")" + " - " + TranslateBoolToYesNo(IsHdtHeels) + " - " + TranslateBoolToYesNo(StorageUtil.GetIntValue(akForm, "SLAroused.IsKillerHeels", Missing = -1) > 0)
	Else
		OutStr += "None "
	EndIf
	Debug.Messagebox(OutStr)
EndFunction

String Function TranslateBoolToYesNo(Bool Value)
	If Value
		Return "Yes"
	EndIf
	Return "No"
EndFunction

Function ToggleCurfew(Bool Enabled)
	If Enabled
		(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as Quest).Start() ; _SLS_CurfewQuest
	Else
		(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as Quest).Stop() ; _SLS_CurfewQuest
		(Game.GetFormFromFile(0x0E9049, "SL Survival.esp") as Quest).Stop() ; _SLS_CurfewGuardAliases
	EndIf
EndFunction

Function LicenceToggleToggled()
	LicUtil.GetIsAtLeastOneLicenceAvailable()
	LicUtil.UpdateGlobalLicVariables()
EndFunction

Function ToggleTolls()
	Debug.Messagebox("The menu may freeze for a moment...\nBe patient\n\nYou may need to enter/exit towns for changes to take effect")
	Formlist TollObjs = Game.GetFormFromFile(0x0F8868, "SL Survival.esp") as Formlist
	Int i = 0
	If !Init.TollEnable
		TollDodging = false
		DoTollDodgingToggle = true
		DoorLockDownT = false
		ToggleTollGateLocks()
		While i < TollObjs.GetSize()
			(TollObjs.GetAt(i) as ObjectReference).Disable()
			i += 1
		EndWhile
	Else
		DoorLockDownT = false
		TollDodging = false
		If ShowMessage("Do you want to lock the toll doors?")
			DoorLockDownT = true
		EndIf
		If ShowMessage("Do you want to enable toll evasion?\n\nToll Evasion - If you leave town without paying the toll and the grace period expires then guards will be on the look out for you when you return and punish you severely if they catch you.")
			TollDodging = true
		EndIf
		DoTollDodgingToggle = true
		ToggleTollGateLocks()
		While i < TollObjs.GetSize()
			(TollObjs.GetAt(i) as ObjectReference).Enable()
			i += 1
		EndWhile
	EndIf
EndFunction

Function LoadSettings()
	If ShowMessage("Are you sure you want to overwrite your current settings with the settings save in the json file?")
		If IsInMcm
			SetTextOptionValue(ImportSettingsOID_T, "Loading Bools")
		EndIf

		; Bools
		DropItems = JsonUtil.GetIntValue("SL Survival/Settings.json", "DropItems", missing = 1)
		OrgasmRequired = JsonUtil.GetIntValue("SL Survival/Settings.json", "OrgasmRequired", missing = 1)
		AssSlappingEvents = JsonUtil.GetIntValue("SL Survival/Settings.json", "AssSlappingEvents", missing = 1)
		EasyBedTraps = JsonUtil.GetIntValue("SL Survival/Settings.json", "EasyBedTraps", missing = 1)
		HardcoreMode = JsonUtil.GetIntValue("SL Survival/Settings.json", "HardcoreMode", missing = 0)
		MinAvToggleT = JsonUtil.GetIntValue("SL Survival/Settings.json", "MinAvToggleT", missing = 1)
		CompassMechanics = JsonUtil.GetIntValue("SL Survival/Settings.json", "CompassMechanics", missing = 1)
		FastTravelDisable = JsonUtil.GetIntValue("SL Survival/Settings.json", "FastTravelDisable", missing = 1)
		FtDisableIsNormal = JsonUtil.GetIntValue("SL Survival/Settings.json", "FtDisableIsNormal", missing = 1)
		ReplaceMaps = JsonUtil.GetIntValue("SL Survival/Settings.json", "ReplaceMaps", missing = 1)
		FollowersStealGold = JsonUtil.GetIntValue("SL Survival/Settings.json", "FollowersStealGold", missing = 1)
		SlaverunAutoStart = JsonUtil.GetIntValue("SL Survival/Settings.json", "SlaverunAutoStart", missing = 0)
		HalfNakedEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "HalfNakedEnable", missing = 0)
		CumBreath = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumBreath", missing = 1)
		CumBreathNotify = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumBreathNotify", missing = 1)
		MilkDecCumBreath = JsonUtil.GetIntValue("SL Survival/Settings.json", "MilkDecCumBreath", missing = 0)
		CumEffectsEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumEffectsEnable", missing = 1)
		CumEffectsStack = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumEffectsStack", missing = 1)
		CumAddictEn = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumAddictEn", missing = 1)
		CumSwallowInflate = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumSwallowInflate", missing = 1)
		Init.SlsCreatureEvents = JsonUtil.GetIntValue("SL Survival/Settings.json", "Init.SlsCreatureEvents", missing = 0)
		AnimalBreedEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "AnimalBreedEnable", missing = 0)
		DeviousEffectsEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "DeviousEffectsEnable", missing = 0)
		DevEffNoGagTradingOID = JsonUtil.GetIntValue("SL Survival/Settings.json", "DevEffNoGagTradingOID", missing = 0)
		BondFurnEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "BondFurnEnable", missing = 1)
		InequalitySkills = JsonUtil.GetIntValue("SL Survival/Settings.json", "InequalitySkills", missing = 1)
		InequalityBuySell = JsonUtil.GetIntValue("SL Survival/Settings.json", "InequalityBuySell", missing = 1)
		Init.SKdialog = JsonUtil.GetIntValue("SL Survival/Settings.json", "Init.SKdialog", missing = 1)
		SleepDepriv = JsonUtil.GetIntValue("SL Survival/Settings.json", "SleepDepriv", missing = 1)
		BellyScaleEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "BellyScaleEnable", missing = 1)
		SaltyCum = JsonUtil.GetIntValue("SL Survival/Settings.json", "SaltyCum", missing = 0)
		DoorLockDownT = JsonUtil.GetIntValue("SL Survival/Settings.json", "DoorLockDownT", missing = 1)
		TollUtil.TollCostPerLevel = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollCostPerLevel", missing = 0)
		TollDodging = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDodging", missing = 1)
		Init.TollDodgeGiftMenu = JsonUtil.GetIntValue("SL Survival/Settings.json", "Init.TollDodgeGiftMenu", missing = 1)
		CurfewEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "CurfewEnable", missing = 1)
		Init.LicencesEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "Init.LicencesEnable", missing = 1)
		LicUtil.BuyBack = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.BuyBack", missing = 0)
		LicUtil.BountyMustBePaid = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.BountyMustBePaid", missing = 1)
		FolContraBlock = JsonUtil.GetIntValue("SL Survival/Settings.json", "FolContraBlock", missing = 1)
		LicUtil.FollowerWontCarryKeys = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.FollowerWontCarryKeys", missing = 1)
		LicUtil.FolTakeClothes = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.FolTakeClothes", missing = 1)
		LicUtil.LicMagicEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicMagicEnable", missing = 1)
		LicUtil.LicMagicCursedDevices = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicMagicCursedDevices", missing = 1)
		LicUtil.CurseTats = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.CurseTats", missing = 1)
		TradeRestrictions = JsonUtil.GetIntValue("SL Survival/Settings.json", "TradeRestrictions", missing = 1)
		_SLS_ResponsiveEnforcers.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_ResponsiveEnforcers", missing = 0))
		LicUtil.LicBikiniEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicBikiniEnable", missing = 1)
		LicUtil.BikiniCurseEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.BikiniCurseEnable", missing = 1)
		BikiniCurse.HeelsRequired = JsonUtil.GetIntValue("SL Survival/Settings.json", "BikiniCurse.HeelsRequired", missing = 1)
		ContTypeCountsT = JsonUtil.GetIntValue("SL Survival/Settings.json", "ContTypeCountsT", missing = 1)
		_SLS_BeggingDialogT.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_BeggingDialogT", missing = 1))
		_SLS_BegSelfDegradationEnable.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_BegSelfDegradationEnable", missing = 1))
		StorageUtil.SetIntValue(Self, "KennelSuits", JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelSuits", missing = 0))
		_SLS_KennelExtraDevices.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_KennelExtraDevices", missing = 1))
		KennelFollowerToggle = JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelFollowerToggle", missing = 1)
		PpSleepNpcPerk = JsonUtil.GetIntValue("SL Survival/Settings.json", "PpSleepNpcPerk", missing = 1)
		PpFailHandle = JsonUtil.GetIntValue("SL Survival/Settings.json", "PpFailHandle", missing = 1)
		PpLootEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "PpLootEnable", missing = 1)
		DismemberTrollCum = JsonUtil.GetIntValue("SL Survival/Settings.json", "DismemberTrollCum", missing = 1)
		DismemberBathing = JsonUtil.GetIntValue("SL Survival/Settings.json", "DismemberBathing", missing = 1)
		DismemberPlayerSay = JsonUtil.GetIntValue("SL Survival/Settings.json", "DismemberPlayerSay", missing = 1)
		BikiniExpT = JsonUtil.GetIntValue("SL Survival/Settings.json", "BikiniExpT", missing = 1)
		_SLS_BikiniExpReflexes.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_BikiniExpReflexes", missing = 1))
		LicUtil.AlwaysAwardBikiniLicFirst = JsonUtil.GetIntValue("SL Survival/Settings.json", "AlwaysAwardBikiniLicFirst", missing = 1)
		_SLS_GuardBehavWeapDropEn.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_GuardBehavWeapDropEn", missing = 1))
		_SLS_GuardBehavShoutEn.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_GuardBehavShoutEn", missing = 1))
		GuardBehavWeapDrawn = JsonUtil.GetIntValue("SL Survival/Settings.json", "GuardBehavWeapDrawn", missing = 1)
		GuardBehavLockpicking = JsonUtil.GetIntValue("SL Survival/Settings.json", "GuardBehavLockpicking", missing = 1)
		GuardBehavDrugs = JsonUtil.GetIntValue("SL Survival/Settings.json", "GuardBehavDrugs", missing = 1)
		GuardBehavArmorEquip = JsonUtil.GetIntValue("SL Survival/Settings.json", "GuardBehavArmorEquip", missing = 0)
		GuardBehavWeapEquip = JsonUtil.GetIntValue("SL Survival/Settings.json", "GuardBehavWeapEquip", missing = 1)
		GuardComments = JsonUtil.GetIntValue("SL Survival/Settings.json", "GuardComments", missing = 1)
		CumLactacidAll = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumLactacidAll", missing = 0)
		CumLactacidAllPlayable = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumLactacidAllPlayable", missing = 0)
		LicUtil.OrdinSupress = JsonUtil.GetIntValue("SL Survival/Settings.json", "OrdinSupress", missing = 0)
		Util.ProxSpankComment = JsonUtil.GetIntValue("SL Survival/Settings.json", "ProxSpankComment", missing = 0)
		CoverMyselfMechanics = JsonUtil.GetIntValue("SL Survival/Settings.json", "CoverMyselfMechanics", missing = 0)
		StorageUtil.SetIntValue(Self, "CumAddictDayDream", JsonUtil.GetIntValue("SL Survival/Settings.json", "CumAddictDayDream", missing = 1))
		CumAddictClampHunger = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumAddictClampHunger", missing = 1)
		CumAddictBeastLevels = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumAddictBeastLevels", missing = 0)
		TollFollowersHardcore = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollFollowersHardcore", missing = 0)
		SexExpEn = JsonUtil.GetIntValue("SL Survival/Settings.json", "SexExpEn", missing = 1)
		IneqStrongFemaleFollowers = JsonUtil.GetIntValue("SL Survival/Settings.json", "IneqStrongFemaleFollowers", missing = 0)
		LicMagicChainCollars = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicMagicChainCollars", missing = 0)
		StashTrackEn = JsonUtil.GetIntValue("SL Survival/Settings.json", "StashTrackEn", missing = 1)
		_SLS_MapAndCompassRecipeEnable.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_MapAndCompassRecipeEnable", missing = 1))
		CumAddict.CumBlocksAddictionDecay = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumBlocksAddictionDecay", missing = 1)
		DeviousEffects.DeviousDrowning = JsonUtil.GetIntValue("SL Survival/Settings.json", "DeviousDrowning", missing = 1)
		StorageUtil.SetIntValue(Self, "CumAddictDayDreamButterflys", JsonUtil.GetIntValue("SL Survival/Settings.json", "CumAddictDayDreamButterflys", missing = 1))
		ForceDrug.RapeDrugLactacid = JsonUtil.GetIntValue("SL Survival/Settings.json", "RapeDrugLactacid", missing = (Game.GetModByName("MilkModNEW.esp") != 255) as Int)
		ForceDrug.RapeDrugSkooma = JsonUtil.GetIntValue("SL Survival/Settings.json", "RapeDrugSkooma", missing = (Game.GetModByName("SexLabSkoomaWhore.esp") != 255) as Int)
		ForceDrug.RapeDrugHumanCum = JsonUtil.GetIntValue("SL Survival/Settings.json", "RapeDrugHumanCum", missing = 1)
		ForceDrug.RapeDrugCreatureCum = JsonUtil.GetIntValue("SL Survival/Settings.json", "RapeDrugCreatureCum", missing = 0)
		ForceDrug.RapeDrugInflate = JsonUtil.GetIntValue("SL Survival/Settings.json", "RapeDrugInflate", missing = (Game.GetModByName("SexLab Inflation Framework.esp") != 255) as Int)
		ForceDrug.RapeDrugFmFertility = JsonUtil.GetIntValue("SL Survival/Settings.json", "RapeDrugFmFertility", missing = (Game.GetModByName("Fertility Mode.esm") != 255) as Int)
		ForceDrug.RapeDrugSlenAphrodisiac = JsonUtil.GetIntValue("SL Survival/Settings.json", "RapeDrugSlenAphrodisiac", missing = (Game.GetModByName("SexLab Eager NPCs.esp") != 255) as Int)
		ForceDrug.TollDrugLactacid = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDrugLactacid", missing = (Game.GetModByName("MilkModNEW.esp") != 255) as Int)
		ForceDrug.TollDrugSkooma = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDrugSkooma", missing = (Game.GetModByName("SexLabSkoomaWhore.esp") != 255) as Int)
		ForceDrug.TollDrugHumanCum = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDrugHumanCum", missing = 1)
		ForceDrug.TollDrugCreatureCum = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDrugCreatureCum", missing = 0)
		ForceDrug.TollDrugInflate = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDrugInflate", missing = (Game.GetModByName("SexLab Inflation Framework.esp") != 255) as Int)
		ForceDrug.TollDrugFmFertility = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDrugFmFertility", missing = (Game.GetModByName("Fertility Mode.esm") != 255) as Int)
		ForceDrug.TollDrugSlenAphrodisiac = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDrugSlenAphrodisiac", missing = (Game.GetModByName("SexLab Eager NPCs.esp") != 255) as Int)
		CumAddict.AutoSuckVictim = JsonUtil.GetIntValue("SL Survival/Settings.json", "AutoSuckVictim", missing = 1)
		(Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "NpcComments", missing = 1))
		(Game.GetFormFromFile(0x0CF9B1, "SL Survival.esp") as _SLS_BodyInflationTracking).DoImod = JsonUtil.GetIntValue("SL Survival/Settings.json", "JigglesVisuals", missing = 1)
		StorageUtil.SetIntValue(Self, "CompulsiveSex", JsonUtil.GetIntValue("SL Survival/Settings.json", "CompulsiveSex", missing = 1))
		StorageUtil.SetIntValue(Self, "OrgasmFatigue", JsonUtil.GetIntValue("SL Survival/Settings.json", "OrgasmFatigue", missing = 1))
		Amputation.BlockMagic = JsonUtil.GetIntValue("SL Survival/Settings.json", "AmpBlockMagic", missing = 1)
		Trauma.TraumaEnable =  JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.TraumaEnable", missing = 1)
		Trauma.DynamicTrauma = JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.DynamicTrauma", missing = 1)
		Trauma.DynamicCombat = JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.DynamicCombat", missing = 1)
		StorageUtil.SetIntValue(Self, "GuardBehavArmorEquipAnyArmor", JsonUtil.GetIntValue("SL Survival/Settings.json", "GuardBehavArmorEquipAnyArmor", missing = 0))
		Init.TollEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "Init.TollEnable", missing = 1)
		
		If IsInMcm
			SetTextOptionValue(ImportSettingsOID_T, "Loading Ints")
		EndIf
		
		; Ints
		PushEvents = JsonUtil.GetIntValue("SL Survival/Settings.json", "PushEvents", missing = 0)
		SurvivalHorseCost = JsonUtil.GetIntValue("SL Survival/Settings.json", "SurvivalHorseCost", missing = 6000)
		FolGoldStealChance = JsonUtil.GetIntValue("SL Survival/Settings.json", "FolGoldStealChance", missing = 50)
		FolGoldSteamAmount = JsonUtil.GetIntValue("SL Survival/Settings.json", "FolGoldSteamAmount", missing = 30)
		HalfNakedBra = JsonUtil.GetIntValue("SL Survival/Settings.json", "HalfNakedBra", missing = 56)
		HalfNakedPanty = JsonUtil.GetIntValue("SL Survival/Settings.json", "HalfNakedPanty", missing = 49)
		AproTwoTrollHealAmount = JsonUtil.GetIntValue("SL Survival/Settings.json", "AproTwoTrollHealAmount", missing = 200)
		DevEffLockpickDiff = JsonUtil.GetIntValue("SL Survival/Settings.json", "DevEffLockpickDiff", missing = 1)
		DevEffPickpocketDiff = JsonUtil.GetIntValue("SL Survival/Settings.json", "DevEffPickpocketDiff", missing = 1)
		BondFurnMilkWill = JsonUtil.GetIntValue("SL Survival/Settings.json", "BondFurnMilkWill", missing = 4)
		BondFurnWill = JsonUtil.GetIntValue("SL Survival/Settings.json", "BondFurnWill", missing = 2)
		_SLS_IneqStat.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_IneqStat", missing = 1))
		_SLS_IneqCarry.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_IneqCarry", missing = 1))
		_SLS_IneqSpeed.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_IneqSpeed", missing = 1))
		_SLS_IneqDamage.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_IneqDamage", missing = 1))
		_SLS_IneqDestruction.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_IneqDestruction", missing = 1))
		SwimCumClean = JsonUtil.GetIntValue("SL Survival/Settings.json", "SwimCumClean", missing = 12)
		TollSexAgg = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollSexAgg", missing = 0)
		TollSexVictim = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollSexVictim", missing = 0)
		TollUtil.TollCostGold = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollCostGold", missing = 100)
		TollUtil.SlaverunJobFactor = JsonUtil.GetIntValue("SL Survival/Settings.json", "SlaverunJobFactor", missing = 3)
		TollUtil.TollCostDevices = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollCostDevices", missing = 3)
		TollUtil.TollCostTattoos = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollCostTattoos", missing = 2)
		TollUtil.TollCostDrugs = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollCostDrugs", missing = 2)
		MaxTatsBody = JsonUtil.GetIntValue("SL Survival/Settings.json", "MaxTatsBody", missing = 6)
		MaxTatsFace = JsonUtil.GetIntValue("SL Survival/Settings.json", "MaxTatsFace", missing = 3)
		MaxTatsHands = JsonUtil.GetIntValue("SL Survival/Settings.json", "MaxTatsHands", missing = 0)
		MaxTatsFeet = JsonUtil.GetIntValue("SL Survival/Settings.json", "MaxTatsFeet", missing = 0)
		TollDodgeMaxGuards = JsonUtil.GetIntValue("SL Survival/Settings.json", "TollDodgeMaxGuards", missing = 6)
		BuyBackPrice = JsonUtil.GetIntValue("SL Survival/Settings.json", "BuyBackPrice", missing = 2)
		LicUtil.LicCostWeaponShort = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostWeaponShort", missing = 1000)
		LicUtil.LicCostWeaponLong = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostWeaponLong", missing = 3000)
		LicUtil.LicCostWeaponPer = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostWeaponPer", missing = 15000)
		LicUtil.LicCostMagicShort = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostMagicShort", missing = 1000)
		LicUtil.LicCostMagicLong = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostMagicLong", missing = 3000)
		LicUtil.LicCostMagicPer = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostMagicPer", missing = 20000)
		LicUtil.LicCostArmorShort = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostArmorShort", missing = 3000)
		LicUtil.LicCostArmorLong = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostArmorLong", missing = 9000)
		LicUtil.LicCostArmorPer = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostArmorPer", missing = 30000)
		LicUtil.LicCostBikiniShort = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostBikiniShort", missing = 1000)
		LicUtil.LicCostBikiniLong = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostBikiniLong", missing = 3000)
		LicUtil.LicCostBikiniPer = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostBikiniPer", missing = 15000)
		LicUtil.LicCostClothesShort = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostClothesShort", missing = 500)
		LicUtil.LicCostClothesLong = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostClothesLong", missing = 1500)
		LicUtil.LicCostClothesPer = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicCostClothesPer", missing = 10000)
		CumHungerAutoSuck = JsonUtil.GetIntValue("SL Survival/Settings.json", "CumHungerAutoSuck", missing = 2)
		SexExpCorruption = JsonUtil.GetIntValue("SL Survival/Settings.json", "SexExpCorruption", missing = 0)
		AllInOne.SetKey(JsonUtil.GetIntValue("SL Survival/Settings.json", "AioKey", missing = 34))
	
		Int NewSlot = JsonUtil.GetIntValue("SL Survival/Settings.json", "BikiniCurseArea", missing = 0)
		RefreshBikiniCurseOverlay(NewSlot)
		BikiniCurseArea = NewSlot
		NewSlot = JsonUtil.GetIntValue("SL Survival/Settings.json", "MagicCurseArea", missing = 1)
		RefreshMagicCurseOverlay(NewSlot)
		MagicCurseArea = NewSlot
		
		TradeRestrictBribe = JsonUtil.GetIntValue("SL Survival/Settings.json", "TradeRestrictBribe", missing = 50)
		EnforcersMin = JsonUtil.GetIntValue("SL Survival/Settings.json", "EnforcersMin", missing = 2)
		EnforcersMax = JsonUtil.GetIntValue("SL Survival/Settings.json", "EnforcersMax", missing = 4)
		LicUtil.LicClothesEnable = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicUtil.LicClothesEnable", missing = 2)
		BegNumItems = JsonUtil.GetIntValue("SL Survival/Settings.json", "BegNumItems", missing = 2)
		BegSexAgg = JsonUtil.GetIntValue("SL Survival/Settings.json", "BegSexAgg", missing = 0)
		BegSexVictim = JsonUtil.GetIntValue("SL Survival/Settings.json", "BegSexVictim", missing = 0)
		KennelSafeCellCost = JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelSafeCellCost", missing = 40)
		KennelSlaveRapeTimeMin = JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelSlaveRapeTimeMin", missing = 10)
		KennelSlaveRapeTimeMax = JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelSlaveRapeTimeMax", missing = 40)
		StorageUtil.SetIntValue(Self, "KennelSlaveDeviceCountMin", JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelSlaveDeviceCountMin", missing = 2))
		StorageUtil.SetIntValue(Self, "KennelSlaveDeviceCountMax", JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelSlaveDeviceCountMax", missing = 6))
		_SLS_KennelExtraDevices.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_KennelExtraDevices", missing = 1))
		KennelSexAgg = JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelSexAgg", missing = 2)
		KennelSexVictim = JsonUtil.GetIntValue("SL Survival/Settings.json", "KennelSexVictim", missing = 1)
		PpFailDevices = JsonUtil.GetIntValue("SL Survival/Settings.json", "PpFailDevices", missing = 4)
		_SLS_PickPocketFailStealValue.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_PickPocketFailStealValue", missing = 200))
		PpFailDrugCount = JsonUtil.GetIntValue("SL Survival/Settings.json", "PpFailDrugCount", missing = 2)
		Util.PpLootLootMin = JsonUtil.GetIntValue("SL Survival/Settings.json", "Util.PpLootLootMin", missing = 0)
		Util.PpLootLootMax = JsonUtil.GetIntValue("SL Survival/Settings.json", "Util.PpLootLootMax", missing = 8)
		AmpDepth = JsonUtil.GetIntValue("SL Survival/Settings.json", "AmpDepth", missing = 2)
		DismemberWeapon = JsonUtil.GetIntValue("SL Survival/Settings.json", "DismemberWeapon", missing = 0)
		MaxAmpDepthArms = JsonUtil.GetIntValue("SL Survival/Settings.json", "MaxAmpDepthArms", missing = 1)
		MaxAmpDepthLegs = JsonUtil.GetIntValue("SL Survival/Settings.json", "MaxAmpDepthLegs", missing = 1)
		MaxAmpedLimbs = JsonUtil.GetIntValue("SL Survival/Settings.json", "MaxAmpedLimbs", missing = 2)
		DismemberDamageThres = JsonUtil.GetIntValue("SL Survival/Settings.json", "DismemberDamageThres", missing = 3)
		_SLS_AmpPriestHealCost.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_AmpPriestHealCost", missing = 200))
		BikiniDropsVendorCity = JsonUtil.GetIntValue("SL Survival/Settings.json", "BikiniDropsVendorCity", missing = 30)
		BikiniDropsVendorTown = JsonUtil.GetIntValue("SL Survival/Settings.json", "BikiniDropsVendorTown", missing = 16)
		BikiniDropsVendorKhajiit = JsonUtil.GetIntValue("SL Survival/Settings.json", "BikiniDropsVendorKhajiit", missing = 12)
		BikiniDropsChest = JsonUtil.GetIntValue("SL Survival/Settings.json", "BikiniDropsChest", missing = 6)
		BikiniDropsChestOrnate = JsonUtil.GetIntValue("SL Survival/Settings.json", "BikiniDropsChestOrnate", missing = 10)
		_SLS_BikiniExpReflexes.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_BikiniExpReflexes", missing = 1))
		ProxSpankNpcType = JsonUtil.GetIntValue("SL Survival/Settings.json", "ProxSpankNpcType", missing = 1)
		_SLS_ProxSpankRequiredCover.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_ProxSpankRequiredCover", missing = 1))
		PpCrimeGold = JsonUtil.GetIntValue("SL Survival/Settings.json", "PpCrimeGold", missing = 100)
		LicUtil.FollowerLicStyle = JsonUtil.GetIntValue("SL Survival/Settings.json", "FollowerLicStyle", missing = 0)
		_SLS_TollFollowersRequired.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_TollFollowersRequired", missing = 1))
		LicUtil.LicenceStyle = JsonUtil.GetIntValue("SL Survival/Settings.json", "LicenceStyle", missing = 0)
		_SLS_LicUnlockCost.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_LicUnlockCost", missing = 5000))
		CompassHideMethod = JsonUtil.GetIntValue("SL Survival/Settings.json", "CompassHideMethod", missing = 0)
		_SLS_LicInspPersistence.SetValueInt(JsonUtil.GetIntValue("SL Survival/Settings.json", "_SLS_LicInspPersistence", missing = 0))
		FashionRape.HairCutMinLevel = JsonUtil.GetIntValue("SL Survival/Settings.json", "HairCutMinLevel", missing = 1)
		FashionRape.HairCutMaxLevel = JsonUtil.GetIntValue("SL Survival/Settings.json", "HairCutMaxLevel", missing = 3)
		FashionRape.HaircutFloor = JsonUtil.GetIntValue("SL Survival/Settings.json", "HaircutFloor", missing = 1)
		Trauma.PlayerTraumaCountMax =  JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.PlayerTraumaCountMax", missing = 15)
		Trauma.FollowerTraumaCountMax =  JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.FollowerTraumaCountMax", missing = 15)
		Trauma.NpcTraumaCountMax =  JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.NpcTraumaCountMax", missing = 10)
		Trauma.SexHitsPlayer =  JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.SexHitsPlayer", missing = 1)
		Trauma.SexHitsFollower =  JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.SexHitsFollower", missing = 1)
		Trauma.SexHitsNpc =  JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.SexHitsNpc", missing = 2)
		Trauma.CombatDamageThreshold =  JsonUtil.GetIntValue("SL Survival/Settings.json", "Trauma.CombatDamageThreshold", missing = 4)
		
		If IsInMcm
			SetTextOptionValue(ImportSettingsOID_T, "Loading Floats")
		EndIf
		
		; Floats
		BarefootMag = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BarefootMag", missing = 50.0)
		MinSpeedMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "MinSpeedMult", missing = 50.0)
		MinCarryWeight = JsonUtil.GetFloatValue("SL Survival/Settings.json", "MinCarryWeight", missing = 50.0)
		ReplaceMapsTimer = JsonUtil.GetFloatValue("SL Survival/Settings.json", "ReplaceMapsTimer", missing = 50.0)
		SlaverunAutoMin = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SlaverunAutoMin", missing = 2.0)
		SlaverunAutoMax = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SlaverunAutoMax", missing = 14.0)
		CumSwallowInflateMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumSwallowInflateMult", missing = 1.0)
		CumEffectsMagMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumEffectsMagMult", missing = 1.0)
		CumEffectsDurMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumEffectsDurMult", missing = 1.0)
		CumpulsionChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumpulsionChance", missing = 25.0)
		AnimalFriend.BreedingCooloffBase = JsonUtil.GetFloatValue("SL Survival/Settings.json", "AnimalFriend.BreedingCooloffBase", missing = 3.0)
		AnimalFriend.BreedingCooloffCumCovered = JsonUtil.GetFloatValue("SL Survival/Settings.json", "AnimalFriend.BreedingCooloffCumCovered", missing = 6.0)
		AnimalFriend.BreedingCooloffCumFilled = JsonUtil.GetFloatValue("SL Survival/Settings.json", "AnimalFriend.BreedingCooloffCumFilled", missing = 12.0)
		AnimalFriend.SwallowBonus = JsonUtil.GetFloatValue("SL Survival/Settings.json", "AnimalFriend.SwallowBonus", missing = 12.0)
		AnimalFriend.BreedingCooloffPregnancy = JsonUtil.GetFloatValue("SL Survival/Settings.json", "AnimalFriend.BreedingCooloffPregnancy", missing = 12.0)
		DflowResistLoss = JsonUtil.GetFloatValue("SL Survival/Settings.json", "DflowResistLoss", missing = 5.0)
		BondFurnMilkFreq = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BondFurnMilkFreq", missing = 6.0)
		BondFurnMilkFatigueMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BondFurnMilkFatigueMult", missing = 1.0)
		BondFurnFreq = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BondFurnFreq", missing = 3.0)
		BondFurnFatigueMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BondFurnFatigueMult", missing = 1.0)
		IneqStatsVal = JsonUtil.GetFloatValue("SL Survival/Settings.json", "IneqStatsVal", missing = 40.0)
		IneqHealthCushion = JsonUtil.GetFloatValue("SL Survival/Settings.json", "IneqHealthCushion", missing = 20.0)
		IneqCarryVal = JsonUtil.GetFloatValue("SL Survival/Settings.json", "IneqCarryVal", missing = 150.0)
		IneqSpeedVal = JsonUtil.GetFloatValue("SL Survival/Settings.json", "IneqSpeedVal", missing = 10.0)
		IneqDamageVal = JsonUtil.GetFloatValue("SL Survival/Settings.json", "IneqDamageVal", missing = 20.0)
		IneqDestVal = JsonUtil.GetFloatValue("SL Survival/Settings.json", "IneqDestVal", missing = 20.0)
		KnockSlaveryChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "KnockSlaveryChance", missing = 25.0)
		SimpleSlaveryWeight = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SimpleSlaveryWeight", missing = 50.0)
		SdWeight = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SdWeight", missing = 50.0)
		GluttedSpeed = JsonUtil.GetFloatValue("SL Survival/Settings.json", "GluttedSpeed", missing = 10.0)
		Needs.BaseBellyScale = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Needs.BaseBellyScale", missing = 1.0)
		Rnd.BellyScaleRnd00 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd00", missing = 1.5)
		Rnd.BellyScaleRnd01 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd01", missing = 0.4)
		Rnd.BellyScaleRnd02 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd02", missing = 0.3)
		Rnd.BellyScaleRnd03 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd03", missing = 0.2)
		Rnd.BellyScaleRnd04 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd04", missing = 0.1)
		Rnd.BellyScaleRnd05 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd05", missing = 0.0)
		SkoomaSleep = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SkoomaSleep", missing = 1.0)
		MilkSleepMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "MilkSleepMult", missing = 1.0)
		DrugEndFatigueInc = JsonUtil.GetFloatValue("SL Survival/Settings.json", "DrugEndFatigueInc", missing = 0.25)
		Needs.CumFoodMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Needs.CumFoodMult", missing = 1.0)
		Needs.CumDrinkMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Needs.CumDrinkMult", missing = 1.0)
		Ineed.BellyScaleIneed00 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Ineed.BellyScaleIneed00", missing = 0.9)
		Ineed.BellyScaleIneed01 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Ineed.BellyScaleIneed01", missing = 0.6)
		Ineed.BellyScaleIneed02 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Ineed.BellyScaleIneed02", missing = 0.3)
		Ineed.BellyScaleIneed03 = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Ineed.BellyScaleIneed03", missing = 0.0)
		WarmBodies = JsonUtil.GetFloatValue("SL Survival/Settings.json", "WarmBodies", missing = -3.0)
		MilkLeakWet = JsonUtil.GetFloatValue("SL Survival/Settings.json", "MilkLeakWet", missing = 50.0)
		CumWetMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumWetMult", missing = 1.0)
		CumExposureMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumExposureMult", missing = 1.0)
		SimpleSlaveryFF = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SimpleSlaveryFF", missing = 50.0)
		SdDreamFF = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SdDreamFF", missing = 50.0)
		TollUtil.SlaverunFactor = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SlaverunFactor", missing = 2.0)
		TollDodgeGracePeriod = JsonUtil.GetFloatValue("SL Survival/Settings.json", "TollDodgeGracePeriod", missing = 2.0)
		TollDodgeHuntFreq = JsonUtil.GetFloatValue("SL Survival/Settings.json", "TollDodgeHuntFreq", missing = 1.5)
		TollDodgeItemValueMod = JsonUtil.GetFloatValue("SL Survival/Settings.json", "TollDodgeItemValueMod", missing = 1.0)
		GuardSpotDistTown = JsonUtil.GetFloatValue("SL Survival/Settings.json", "GuardSpotDistTown", missing = 768.0)
		GuardSpotDistNom = JsonUtil.GetFloatValue("SL Survival/Settings.json", "GuardSpotDistNom", missing = 512.0)
		TollDodgeDisguiseBodyPenalty = JsonUtil.GetFloatValue("SL Survival/Settings.json", "TollDodgeDisguiseBodyPenalty", missing = 0.75)
		TollDodgeDisguiseHeadPenalty = JsonUtil.GetFloatValue("SL Survival/Settings.json", "TollDodgeDisguiseHeadPenalty", missing = 0.75)
		(Game.GetFormFromFile(0x0EAB5A, "SL Survival.esp") as GlobalVariable).SetValue(JsonUtil.GetFloatValue("SL Survival/Settings.json", "_SLS_GateCurfewBegin", missing = 20.0)) ; _SLS_GateCurfewBegin
		(Game.GetFormFromFile(0x0EAB5B, "SL Survival.esp") as GlobalVariable).SetValue(JsonUtil.GetFloatValue("SL Survival/Settings.json", "_SLS_GateCurfewEnd", missing = 7.0)) ; _SLS_GateCurfewEnd
		(Game.GetFormFromFile(0x0EE155, "SL Survival.esp") as GlobalVariable).SetValue(JsonUtil.GetFloatValue("SL Survival/Settings.json", "_SLS_GateCurfewSlavetownBegin", missing = 18.0)) ; _SLS_GateCurfewSlavetownBegin
		(Game.GetFormFromFile(0x0EE156, "SL Survival.esp") as GlobalVariable).SetValue(JsonUtil.GetFloatValue("SL Survival/Settings.json", "_SLS_GateCurfewSlavetownEnd", missing = 10.0)) ; _SLS_GateCurfewSlavetownEnd
		LicBlockChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "LicBlockChance", missing = 70.0)
		LicUtil.LicFactionDiscount = JsonUtil.GetFloatValue("SL Survival/Settings.json", "LicUtil.LicFactionDiscount", missing = 0.5)
		LicUtil.LicShortDur = JsonUtil.GetFloatValue("SL Survival/Settings.json", "LicUtil.LicShortDur", missing = 7.0)
		LicUtil.LicLongDur = JsonUtil.GetFloatValue("SL Survival/Settings.json", "LicUtil.LicLongDur", missing = 28.0)
		EnforcerRespawnDur = JsonUtil.GetFloatValue("SL Survival/Settings.json", "EnforcerRespawnDur", missing = 7.0)
		BikiniCurse.HeelHeightRequired = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniCurse.HeelHeightRequired", missing = 5.0)
		RoadDist = JsonUtil.GetFloatValue("SL Survival/Settings.json", "RoadDist", missing = 3072.0)
		StealXItems = JsonUtil.GetFloatValue("SL Survival/Settings.json", "StealXItems", missing = 3.0)
		BegGold = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BegGold", missing = 1.0)
		BegMwaCurseChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BegMwaCurseChance", missing = 50.0)
		KennelRapeChancePerHour = JsonUtil.GetFloatValue("SL Survival/Settings.json", "KennelRapeChancePerHour", missing = 20.0)
		KennelCreatureChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "KennelCreatureChance", missing = 50.0)
		PpGoldLowChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpGoldLowChance", missing = 60.0)
		PpGoldModerateChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpGoldModerateChance", missing = 20.0)
		PpGoldHighChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpGoldHighChance", missing = 2.0)
		PpLootFoodChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootFoodChance", missing = 25.0)
		PpLootGemsChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootGemsChance", missing = 15.0)
		PpLootSoulgemsChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootSoulgemsChance", missing = 10.0)
		PpLootJewelryChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootJewelryChance", missing = 15.0)
		PpLootEnchJewelryChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootEnchJewelryChance", missing = 5.0)
		PpLootPotionsChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootPotionsChance", missing = 10.0)
		PpLootKeysChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootKeysChance", missing = 10.0)
		PpLootTomesChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootTomesChance", missing = 5.0)
		PpLootCureChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PpLootCureChance", missing = 5.0)
		DismemberCooldown = JsonUtil.GetFloatValue("SL Survival/Settings.json", "DismemberCooldown", missing = 0.1)
		DismemberChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "DismemberChance", missing = 90.0)
		DismemberArmorBonus = JsonUtil.GetFloatValue("SL Survival/Settings.json", "DismemberArmorBonus", missing = 5.0)
		DismemberHealthThres = JsonUtil.GetFloatValue("SL Survival/Settings.json", "DismemberHealthThres", missing = 110.0)
		BikiniExp.ExpPerLevel = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniExp.ExpPerLevel", missing = 100.0)
		BikTrainingSpeed = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikTrainingSpeed", missing = 1.0)
		BikUntrainingSpeed = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikUntrainingSpeed", missing = 0.5)
		BikiniChanceHide = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceHide", missing = 10.0)
		BikiniChanceLeather = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceLeather", missing = 10.0)
		BikiniChanceIron = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceIron", missing = 10.0)
		BikiniChanceSteel = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceSteel", missing = 11.0)
		BikiniChanceSteelPlate = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceSteelPlate", missing = 8.0)
		BikiniChanceDwarven = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceDwarven", missing = 6.0)
		BikiniChanceFalmer = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceFalmer", missing = 6.0)
		BikiniChanceWolf = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceWolf", missing = 6.0)
		BikiniChanceBlades = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceBlades", missing = 2.0)
		BikiniChanceEbony = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceEbony", missing = 1.0)
		BikiniChanceDragonbone = JsonUtil.GetFloatValue("SL Survival/Settings.json", "BikiniChanceDragonbone", missing = 0.5)
		IneqFemaleVendorGoldMult = JsonUtil.GetFloatValue("SL Survival/Settings.json", "IneqFemaleVendorGoldMult", missing = 1.0)
		CatCallVol = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CatCallVol", missing = 20.0)
		CumIsLactacid = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumIsLactacid", missing = 0.0)
		ProxSpankCooloff = JsonUtil.GetFloatValue("SL Survival/Settings.json", "ProxSpankCooloff", missing = 10.0)
		CatCallWillLoss = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CatCallWillLoss", missing = 1.0)
		GreetDist = JsonUtil.GetFloatValue("SL Survival/Settings.json", "GreetDist", missing = 150.0)
		CumAddictBatheRefuseTime = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumAddictBatheRefuseTime", missing = 6.0)
		CumAddictReflexSwallow = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumAddictReflexSwallow", missing = 1.0)
		CumAddictAutoSuckCreature = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumAddictAutoSuckCreature", missing = 1.0)
		CumAddictAutoSuckCooldown = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumAddictAutoSuckCooldown", missing = 6.0)
		CumAddictAutoSuckCreatureArousal = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumAddictAutoSuckCreatureArousal", missing = 70.0)
		AssSlapResistLoss = JsonUtil.GetFloatValue("SL Survival/Settings.json", "AssSlapResistLoss", missing = 1.0)
		GoldWeight = JsonUtil.GetFloatValue("SL Survival/Settings.json", "GoldWeight", missing = 0.01)
		CumSatiation = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumSatiation", missing = 1.0)
		CumAddictionHungerRate = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumAddictionHungerRate", missing = 0.1)
		CumAddictionSpeed = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumAddictionSpeed", missing = 1.0)
		CumAddictionDecayPerHour = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CumAddictionDecayPerHour", missing = 1.0)
		CockSizeBonusEnjFreq = JsonUtil.GetFloatValue("SL Survival/Settings.json", "CockSizeBonusEnjFreq", missing = 3.0)
		RapeForcedSkoomaChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "RapeForcedSkoomaChance", missing = 35.0)
		RapeMinArousal = JsonUtil.GetFloatValue("SL Survival/Settings.json", "RapeMinArousal", missing = 50.0)
		DeviousGagDebuff = JsonUtil.GetFloatValue("SL Survival/Settings.json", "DeviousGagDebuff", missing = 80.0)
		StorageUtil.SetFloatValue(Self, "CumAddictDayDreamVol", StorageUtil.GetFloatValue(Self, "CumAddictDayDreamVol", Missing = 1.0))
		Main.Slif.ScaleMaxBreasts = JsonUtil.GetFloatValue("SL Survival/Settings.json", "ScaleMaxBreasts", missing = 3.3)
		Main.Slif.ScaleMaxBelly = JsonUtil.GetFloatValue("SL Survival/Settings.json", "ScaleMaxBelly", missing = 5.5)
		Main.Slif.ScaleMaxAss = JsonUtil.GetFloatValue("SL Survival/Settings.json", "ScaleMaxAss", missing = 2.3)
		FashionRape.HaircutChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "HaircutChance", missing = 4.0)
		FashionRape.DyeHairChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "DyeHairChance", missing = 2.0)
		FashionRape.ShavePussyChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "ShavePussyChance", missing = 10.0)
		FashionRape.SmudgeLipstickChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SmudgeLipstickChance", missing = 20.0)
		FashionRape.SmudgeEyeshadowChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "SmudgeEyeshadowChance", missing = 20.0)
		StorageUtil.SetFloatValue(Self, "WeightGainPerDay", JsonUtil.GetFloatValue("SL Survival/Settings.json", "WeightGainPerDay", missing = 0.0))
		(Game.GetFormFromFile(0x0E651A, "SL Survival.esp") as _SLS_PushPlayerCooloff).CooloffPeriod = JsonUtil.GetFloatValue("SL Survival/Settings.json", "PushCooldown", missing = 0.0)
		(Game.GetFormFromFile(0x0E7553, "SL Survival.esp") as _SLS_CompulsiveSex).TimeBetweenFucks = JsonUtil.GetFloatValue("SL Survival/Settings.json", "TimeBetweenFucks", missing = 1.0)
		(Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmThreshold = JsonUtil.GetFloatValue("SL Survival/Settings.json", "OrgasmFatigueThreshold", missing = 3.0)
		(Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmRecoveryPerHour = JsonUtil.GetFloatValue("SL Survival/Settings.json", "OrgasmFatigueRecovery", missing = 0.8)
		(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).TimeToClearStreets = JsonUtil.GetFloatValue("SL Survival/Settings.json", "TimeToClearStreets", missing = 60.0)
		(Game.GetFormFromFile(0x07B44C, "SL Survival.esp") as GlobalVariable).SetValue(JsonUtil.GetFloatValue("SL Survival/Settings.json", "_SLS_CurfewBegin", missing = 21.0)) ; _SLS_CurfewBegin
		(Game.GetFormFromFile(0x07B44D, "SL Survival.esp") as GlobalVariable).SetValue(JsonUtil.GetFloatValue("SL Survival/Settings.json", "_SLS_CurfewEnd", missing = 6.0)) ; _SLS_CurfewEnd
		(Game.GetFormFromFile(0x0ECBC0, "SL Survival.esp") as GlobalVariable).SetValue(JsonUtil.GetFloatValue("SL Survival/Settings.json", "_SLS_CurfewSlavetownBegin", missing = 19.0)) ; _SLS_CurfewSlavetownBegin
		(Game.GetFormFromFile(0x0ECBC1, "SL Survival.esp") as GlobalVariable).SetValue(JsonUtil.GetFloatValue("SL Survival/Settings.json", "_SLS_CurfewSlavetownEnd", missing = 9.0)) ; _SLS_CurfewSlavetownEnd
		Trauma.StartingAlpha = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.StartingAlpha", missing = 0.5)
		Trauma.MaxAlpha = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.MaxAlpha", missing = 0.85)
		Trauma.HoursToMaxAlpha = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.HoursToMaxAlpha", missing = 4.0)
		Trauma.HoursToFadeOut = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.HoursToFadeOut", missing = 48.0)
		Trauma.SexChancePlayer = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.SexChancePlayer", missing = 33.0)
		Trauma.SexChanceFollower = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.SexChanceFollower", missing = 50.0)
		Trauma.SexChanceNpc = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.SexChanceNpc", missing = 75.0)
		Trauma.CombatChancePlayer = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.CombatChancePlayer", missing = 25.0)
		Trauma.CombatChanceFollower = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.CombatChanceFollower", missing = 10.0)
		Trauma.CombatChanceNpc = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.CombatChanceNpc", missing = 25.0)
		Trauma.PushChance = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Trauma.PushChance", missing = 33.0)
		Util.PainSoundVol = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Util.PainSoundVol", missing = 0.5)
		Util.HitSoundVol = JsonUtil.GetFloatValue("SL Survival/Settings.json", "Util.HitSoundVol", missing = 0.5)
		
		; Int list
		JsonUtil.IntListToArray("SL Survival/Settings.json", "InnCosts")
		
		; Forms
		LoadJsonFormsToFormlist(_SLS_CumHasLactacidVoices, "SL Survival/Settings.json", "_SLS_CumHasLactacidVoices", RevertFl = true)
		
		If IsInMcm
			SetTextOptionValue(ImportSettingsOID_T, "Actioning Settings")
		EndIf
		
		DoTogglePushEvents = true
		ToggleDismemberment()
		Amputation.CheckAvailabilty()
		DoDeviousEffectsChange = true
		Main.FilterGold(FollowersStealGold)
		DoSlaverunInitOnClose = true
		ToggleAssSlapping()
		ToggleDebugMode()
		ToggleMinAV()
		DoToggleHalfNakedCover = true
		ToggleHalfNakedStrips()
		TogglePpLoot()
		DoToggleCumEffects = true
		TogglePpSleepNpcPerk()
		DoTogglePpFailHandle = true
		ToggleSleepDepriv()
		SetSaltyCum(SaltyCum)
		ToggleBellyInflation()
		DoToggleAnimalBreeding = true
		ToggleTollGateLocks()
		ToggleCompassMechanics()
		;SetTollCost()
		DoTollDodgingToggle = true
		TollUtil.IsCurfewTimeByLoc(PlayerRef.GetCurrentLocation())
		ToggleLicences(Init.LicencesEnable)
		ToggleFolContraBlock()
		ToggleCurseTats()
		ToggleTradeRestrictions()
		ToggleBikiniCurse()
		DoToggleHeelsRequired = true
		ToggleLicMagicCursedDevices()
		ToggleKennelFollower()
		Devious.DoDevicePatchup()
		DoToggleBondFurn = true
		DoToggleBikiniExp = true
		BuildBikiniLists()
		ToggleBarefootMag()
		SetHorseCost(SurvivalHorseCost)
		CheckHalfNakedCover()
		DoInequalityRefresh = true
		DoPpLvlListbuildOnClose = true
		_SLS_AmputationQuest.UpdateCurrentInstanceGlobal(_SLS_AmpPriestHealCost)
		UpdateBellyScale()
		RefreshGuardSpotDistance()
		_SLS_LicenceTradersQuest.UpdateCurrentInstanceGlobal(_SLS_RestrictTradeBribe)
		ModLicBuyBlock()
		_SLS_KennelCellCost.SetValueInt(KennelSafeCellCost)
		Main.IneqVendorGoldUpdate()
		GagTrade.ToggleActive()
		DoToggleCatCalling = true
		DoToggleLicenceStyle = true
		DoToggleGuardBehavDrugs = true
		DoToggleGuardBehavLockpick = true
		DoToggleGuardBehavWeapDrawn = true
		DoToggleGuardComments = true
		DoToggleProxSpank = true
		DoToggleBarefootSpeed = true
		Game.SetGameSettingFloat("fAIMinGreetingDistance", GreetDist)
		LicUtil.ToggleOrdinSuppression()
		DoToggleCumAddictAutoSuckCreature = true
		DoToggleCoverMechanics = true
		Gold001.SetWeight(GoldWeight)
		DoToggleCumAddiction = true
		CumAddict.LoadNewHungerThresholds()
		CumAddict.DoUpdate()
		DoToggleSexExp = true
		DoToggleIneqStrongFemaleFollowers = true
		ReplaceVanillaMaps(ReplaceMaps)
		DoToggleStashTracking = true
		_SLS_LicenceQuest.UpdateCurrentInstanceGlobal(_SLS_LicUnlockCost)
		MapAndCompass.ResetCompass()
		SetGagSpeechDebuff()
		AddRemoveChainCollars(LicMagicChainCollars)
		DoToggleBellyInflation = true
		StorageUtil.SetIntValue(Self, "DoToggleDaydream", 1)
		DeviousEffects.ToggleDeviousDrowning()
		StorageUtil.SetIntValue(Self, "DoToggleDaydreamButterflys", 1)
		StorageUtil.SetIntValue(Self, "DoToggleGrowth", 1)
		StorageUtil.SetIntValue(Self, "DoToggleNpcComments", 1)
		CumSwallow.SetOpenMouthKey(JsonUtil.GetIntValue("SL Survival/Settings.json", "OpenMouthKey", missing = 0))
		StorageUtil.SetIntValue(Self, "DoToggleCompulsiveSex", 1)
		StorageUtil.SetIntValue(Self, "DoToggleOrgasmFatigue", 1)
		(Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).CheckCurfewState()
		LocTrack.SetInnCostByString(LocTrack.PlayerCurrentLocString)
		StorageUtil.SetIntValue(Self, "DoToggleTrauma", 1)
		StorageUtil.SetIntValue(Self, "DoToggleDynamicTrauma", 1)
		Trauma.RegisterForCombat()
		Trauma.ToggleCombatTrauma()
		LicenceToggleToggled()
		
		; Do debug mode last to avoid messagebox spam
		Init.DebugMode = JsonUtil.GetIntValue("SL Survival/Settings.json", "Init.DebugMode")
		
		If IsInMcm
			SetTextOptionValue(ImportSettingsOID_T, "Load Complete!")
			Debug.Messagebox("SLS: Load settings complete. Please exit the menu to initialize settings")
		EndIf
		ForcePageReset()
	EndIf
EndFunction

Function SaveSettings()
	If ShowMessage("Are you sure you want to overwrite the settings saved in the json file with your current settings?")
		If IsInMcm
			SetTextOptionValue(ExportSettingsOID_T, "Saving...")
		EndIf

		; Bools
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DropItems", DropItems as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "OrgasmRequired", OrgasmRequired as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "AssSlappingEvents", AssSlappingEvents as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "EasyBedTraps", EasyBedTraps as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "HardcoreMode", HardcoreMode as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Init.DebugMode", Init.DebugMode as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MinAvToggleT", MinAvToggleT as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CompassMechanics", CompassMechanics as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "FastTravelDisable", FastTravelDisable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "FtDisableIsNormal", FtDisableIsNormal as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "ReplaceMaps", ReplaceMaps as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "FollowersStealGold", FollowersStealGold as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "SlaverunAutoStart", SlaverunAutoStart as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "HalfNakedEnable", HalfNakedEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumBreath", CumBreath as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumBreathNotify", CumBreathNotify as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MilkDecCumBreath", MilkDecCumBreath as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumEffectsEnable", CumEffectsEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumEffectsStack", CumEffectsStack as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumAddictEn", CumAddictEn as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumSwallowInflate", CumSwallowInflate as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Init.SlsCreatureEvents", Init.SlsCreatureEvents as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "AnimalBreedEnable", AnimalBreedEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DeviousEffectsEnable", DeviousEffectsEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DevEffNoGagTrading", DevEffNoGagTrading as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BondFurnEnable", BondFurnEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "InequalitySkills", InequalitySkills as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "InequalityBuySell", InequalityBuySell as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Init.SKdialog", Init.SKdialog as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "SleepDepriv", SleepDepriv as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BellyScaleEnable", BellyScaleEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "SaltyCum", SaltyCum as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DoorLockDownT", DoorLockDownT as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollCostPerLevel", TollUtil.TollCostPerLevel as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDodging", TollDodging as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Init.TollDodgeGiftMenu", Init.TollDodgeGiftMenu as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CurfewEnable", CurfewEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Init.LicencesEnable", Init.LicencesEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.BuyBack", LicUtil.BuyBack as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.BountyMustBePaid", LicUtil.BountyMustBePaid as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "FolContraBlock", FolContraBlock as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.FollowerWontCarryKeys", LicUtil.FollowerWontCarryKeys as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.FolTakeClothes", LicUtil.FolTakeClothes as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicMagicEnable", LicUtil.LicMagicEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicMagicCursedDevices", LicUtil.LicMagicCursedDevices as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.CurseTats", LicUtil.CurseTats as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TradeRestrictions", TradeRestrictions as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_ResponsiveEnforcers", _SLS_ResponsiveEnforcers.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicBikiniEnable", LicUtil.LicBikiniEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.BikiniCurseEnable", LicUtil.BikiniCurseEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BikiniCurse.HeelsRequired", BikiniCurse.HeelsRequired as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "ContTypeCountsT", ContTypeCountsT as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_BeggingDialogT", _SLS_BeggingDialogT.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_BegSelfDegradationEnable", _SLS_BegSelfDegradationEnable.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelSuits", StorageUtil.GetIntValue(Self, "KennelSuits", Missing = 0))
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_KennelExtraDevices", _SLS_KennelExtraDevices.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelFollowerToggle", KennelFollowerToggle as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "PpSleepNpcPerk", PpSleepNpcPerk as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "PpFailHandle", PpFailHandle as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "PpLootEnable", PpLootEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DismemberTrollCum", DismemberTrollCum as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DismemberBathing", DismemberBathing as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DismemberPlayerSay", DismemberPlayerSay as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BikiniExpT", BikiniExpT as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_BikiniExpReflexes", _SLS_BikiniExpReflexes.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "AlwaysAwardBikiniLicFirst", LicUtil.AlwaysAwardBikiniLicFirst as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_GuardBehavWeapDropEn", _SLS_GuardBehavWeapDropEn.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_GuardBehavShoutEn", _SLS_GuardBehavShoutEn.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "GuardBehavWeapDrawn", GuardBehavWeapDrawn as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "GuardBehavLockpicking", GuardBehavLockpicking as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "GuardBehavDrugs", GuardBehavDrugs as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "GuardBehavArmorEquip", GuardBehavArmorEquip as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "GuardBehavWeapEquip", GuardBehavWeapEquip as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "GuardComments", GuardComments as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumLactacidAll", CumLactacidAll as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumLactacidAllPlayable", CumLactacidAllPlayable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "OrdinSupress", LicUtil.OrdinSupress as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "ProxSpankComment", Util.ProxSpankComment as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CoverMyselfMechanics", CoverMyselfMechanics as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumAddictDayDream", StorageUtil.GetIntValue(Self, "CumAddictDayDream", Missing = 1))
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumAddictClampHunger", CumAddictClampHunger as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumAddictBeastLevels", CumAddictBeastLevels as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollFollowersHardcore", TollFollowersHardcore as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "SexExpEn", SexExpEn as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "IneqStrongFemaleFollowers", IneqStrongFemaleFollowers as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicMagicChainCollars", LicMagicChainCollars as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "StashTrackEn", StashTrackEn as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_MapAndCompassRecipeEnable", _SLS_MapAndCompassRecipeEnable.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumBlocksAddictionDecay", CumAddict.CumBlocksAddictionDecay as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DeviousDrowning", DeviousEffects.DeviousDrowning as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumAddictDayDreamButterflys", StorageUtil.GetIntValue(Self, "CumAddictDayDreamButterflys", Missing = 1))
		JsonUtil.SetIntValue("SL Survival/Settings.json", "RapeDrugLactacid", ForceDrug.RapeDrugLactacid as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "RapeDrugSkooma", ForceDrug.RapeDrugSkooma as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "RapeDrugHumanCum", ForceDrug.RapeDrugHumanCum as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "RapeDrugCreatureCum", ForceDrug.RapeDrugCreatureCum as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "RapeDrugInflate", ForceDrug.RapeDrugInflate as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "RapeDrugFmFertility", ForceDrug.RapeDrugFmFertility as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "RapeDrugSlenAphrodisiac", ForceDrug.RapeDrugSlenAphrodisiac as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDrugLactacid", ForceDrug.TollDrugLactacid as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDrugSkooma", ForceDrug.TollDrugSkooma as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDrugHumanCum", ForceDrug.TollDrugHumanCum as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDrugCreatureCum", ForceDrug.TollDrugCreatureCum as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDrugInflate", ForceDrug.TollDrugInflate as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDrugFmFertility", ForceDrug.TollDrugFmFertility as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDrugSlenAphrodisiac", ForceDrug.TollDrugSlenAphrodisiac as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "AutoSuckVictim", CumAddict.AutoSuckVictim as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "NpcComments", (Game.GetFormFromFile(0x0DF88F, "SL Survival.esp") as GlobalVariable).GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "JigglesVisuals", (Game.GetFormFromFile(0x0CF9B1, "SL Survival.esp") as _SLS_BodyInflationTracking).DoImod as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CompulsiveSex", StorageUtil.GetIntValue(Self, "CompulsiveSex", Missing = 1))
		JsonUtil.SetIntValue("SL Survival/Settings.json", "OrgasmFatigue", StorageUtil.GetIntValue(Self, "OrgasmFatigue", Missing = 1))
		JsonUtil.SetIntValue("SL Survival/Settings.json", "AmpBlockMagic", Amputation.BlockMagic as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.TraumaEnable", Trauma.TraumaEnable as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.DynamicTrauma", Trauma.DynamicTrauma as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.DynamicCombat", Trauma.DynamicCombat as Int)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "GuardBehavArmorEquipAnyArmor", StorageUtil.GetIntValue(Self, "GuardBehavArmorEquipAnyArmor", Missing = 0))
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Init.TollEnable", Init.TollEnable as Int)
		
		; Ints
		JsonUtil.SetIntValue("SL Survival/Settings.json", "PushEvents", PushEvents)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "SurvivalHorseCost", SurvivalHorseCost)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "FolGoldStealChance", FolGoldStealChance)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "FolGoldSteamAmount", FolGoldSteamAmount)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "HalfNakedBra", HalfNakedBra)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "HalfNakedPanty", HalfNakedPanty)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "AproTwoTrollHealAmount", AproTwoTrollHealAmount)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DevEffLockpickDiff", DevEffLockpickDiff)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DevEffPickpocketDiff", DevEffPickpocketDiff)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BondFurnMilkWill", BondFurnMilkWill)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BondFurnWill", BondFurnWill)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_IneqStat", _SLS_IneqStat.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_IneqCarry", _SLS_IneqCarry.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_IneqSpeed", _SLS_IneqSpeed.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_IneqDamage", _SLS_IneqDamage.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_IneqDestruction", _SLS_IneqDestruction.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "SwimCumClean", SwimCumClean)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollSexAgg", TollSexAgg)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollSexVictim", TollSexVictim)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollCostGold", TollUtil.TollCostGold)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "SlaverunJobFactor", TollUtil.SlaverunJobFactor)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollCostDevices", TollUtil.TollCostDevices)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollCostTattoos", TollUtil.TollCostTattoos)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollCostDrugs", TollUtil.TollCostDrugs)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MaxTatsBody", MaxTatsBody)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MaxTatsFace", MaxTatsFace)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MaxTatsHands", MaxTatsHands)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MaxTatsFeet", MaxTatsFeet)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TollDodgeMaxGuards", TollDodgeMaxGuards)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BuyBackPrice", BuyBackPrice)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostWeaponShort", LicUtil.LicCostWeaponShort)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostWeaponLong", LicUtil.LicCostWeaponLong)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostWeaponPer", LicUtil.LicCostWeaponPer)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostMagicShort", LicUtil.LicCostMagicShort)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostMagicLong", LicUtil.LicCostMagicLong)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostMagicPer", LicUtil.LicCostMagicPer)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostArmorShort", LicUtil.LicCostArmorShort)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostArmorLong", LicUtil.LicCostArmorLong)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostArmorPer", LicUtil.LicCostArmorPer)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostBikiniShort", LicUtil.LicCostBikiniShort)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostBikiniLong", LicUtil.LicCostBikiniLong)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostBikiniPer", LicUtil.LicCostBikiniPer)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostClothesShort", LicUtil.LicCostClothesShort)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostClothesLong", LicUtil.LicCostClothesLong)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicCostClothesPer", LicUtil.LicCostClothesPer)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BikiniCurseArea", BikiniCurseArea)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MagicCurseArea", MagicCurseArea)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "TradeRestrictBribe", TradeRestrictBribe)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "EnforcersMin", EnforcersMin)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "EnforcersMax", EnforcersMax)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicUtil.LicClothesEnable", LicUtil.LicClothesEnable)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BegNumItems", BegNumItems)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BegSexAgg", BegSexAgg)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BegSexVictim", BegSexVictim)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelSafeCellCost", KennelSafeCellCost)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelSlaveRapeTimeMin", KennelSlaveRapeTimeMin)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelSlaveRapeTimeMax", KennelSlaveRapeTimeMax)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelSlaveDeviceCountMin", StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMin", Missing = 2))
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelSlaveDeviceCountMax", StorageUtil.GetIntValue(Self, "KennelSlaveDeviceCountMax", Missing = 6))
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_KennelExtraDevices", _SLS_KennelExtraDevices.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelSexAgg", KennelSexAgg)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "KennelSexVictim", KennelSexVictim)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "PpFailDevices", PpFailDevices)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_PickPocketFailStealValue", _SLS_PickPocketFailStealValue.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "PpFailDrugCount", PpFailDrugCount)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Util.PpLootLootMin", Util.PpLootLootMin)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Util.PpLootLootMax", Util.PpLootLootMax)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "AmpDepth", AmpDepth)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DismemberWeapon", DismemberWeapon)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MaxAmpDepthArms", MaxAmpDepthArms)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MaxAmpDepthLegs", MaxAmpDepthLegs)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "MaxAmpedLimbs", MaxAmpedLimbs)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "DismemberDamageThres", DismemberDamageThres)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_AmpPriestHealCost", _SLS_AmpPriestHealCost.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BikiniDropsVendorCity", BikiniDropsVendorCity)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BikiniDropsVendorTown", BikiniDropsVendorTown)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BikiniDropsVendorKhajiit", BikiniDropsVendorKhajiit)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BikiniDropsChest", BikiniDropsChest)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "BikiniDropsChestOrnate", BikiniDropsChestOrnate)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_BikiniExpReflexes", _SLS_BikiniExpReflexes.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "ProxSpankNpcType", ProxSpankNpcType)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_ProxSpankRequiredCover", _SLS_ProxSpankRequiredCover.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CumHungerAutoSuck", CumHungerAutoSuck)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "PpCrimeGold", PpCrimeGold)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "SexExpCorruption", SexExpCorruption)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "FollowerLicStyle", LicUtil.FollowerLicStyle)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_TollFollowersRequired", _SLS_TollFollowersRequired.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_LicUnlockCost", _SLS_LicUnlockCost.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "LicenceStyle", LicUtil.LicenceStyle)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "CompassHideMethod", CompassHideMethod)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "_SLS_LicInspPersistence", _SLS_LicInspPersistence.GetValueInt())
		JsonUtil.SetIntValue("SL Survival/Settings.json", "AioKey", AllInOne.AioKey)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "HairCutMinLevel", FashionRape.HairCutMinLevel)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "HairCutMaxLevel", FashionRape.HairCutMaxLevel)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "HaircutFloor", FashionRape.HaircutFloor)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "OpenMouthKey", CumSwallow.OpenMouthKey)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.PlayerTraumaCountMax", Trauma.PlayerTraumaCountMax)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.FollowerTraumaCountMax", Trauma.FollowerTraumaCountMax)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.NpcTraumaCountMax", Trauma.NpcTraumaCountMax)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.SexHitsPlayer", Trauma.SexHitsPlayer)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.SexHitsFollower", Trauma.SexHitsFollower)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.SexHitsNpc", Trauma.SexHitsNpc)
		JsonUtil.SetIntValue("SL Survival/Settings.json", "Trauma.CombatDamageThreshold", Trauma.CombatDamageThreshold)
		
		; Floats
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BarefootMag", BarefootMag)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "MinSpeedMult", MinSpeedMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "MinCarryWeight", MinCarryWeight)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "ReplaceMapsTimer", ReplaceMapsTimer)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SlaverunAutoMin", SlaverunAutoMin)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SlaverunAutoMax", SlaverunAutoMax)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumSwallowInflateMult", CumSwallowInflateMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumEffectsMagMult", CumEffectsMagMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumEffectsDurMult", CumEffectsDurMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumpulsionChance", CumpulsionChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "AnimalFriend.BreedingCooloffBase", AnimalFriend.BreedingCooloffBase)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "AnimalFriend.BreedingCooloffCumCovered", AnimalFriend.BreedingCooloffCumCovered)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "AnimalFriend.BreedingCooloffCumFilled", AnimalFriend.BreedingCooloffCumFilled)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "AnimalFriend.SwallowBonus", AnimalFriend.SwallowBonus)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "AnimalFriend.BreedingCooloffPregnancy", AnimalFriend.BreedingCooloffPregnancy)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "DflowResistLoss", DflowResistLoss)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BondFurnMilkFreq", BondFurnMilkFreq)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BondFurnMilkFatigueMult", BondFurnMilkFatigueMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BondFurnFreq", BondFurnFreq)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BondFurnFatigueMult", BondFurnFatigueMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "IneqStatsVal", IneqStatsVal)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "IneqHealthCushion", IneqHealthCushion)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "IneqCarryVal", IneqCarryVal)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "IneqSpeedVal", IneqSpeedVal)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "IneqDamageVal", IneqDamageVal)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "IneqDestVal", IneqDestVal)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "KnockSlaveryChance", KnockSlaveryChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SimpleSlaveryWeight", SimpleSlaveryWeight)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SdWeight", SdWeight)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "GluttedSpeed", GluttedSpeed)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Needs.BaseBellyScale", Needs.BaseBellyScale)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd00", Rnd.BellyScaleRnd00)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd01", Rnd.BellyScaleRnd01)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd02", Rnd.BellyScaleRnd02)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd03", Rnd.BellyScaleRnd03)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd04", Rnd.BellyScaleRnd04)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Rnd.BellyScaleRnd05", Rnd.BellyScaleRnd05)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SkoomaSleep", SkoomaSleep)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "MilkSleepMult", MilkSleepMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "DrugEndFatigueInc", DrugEndFatigueInc)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Needs.CumFoodMult", Needs.CumFoodMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Needs.CumDrinkMult", Needs.CumDrinkMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Ineed.BellyScaleIneed00", Ineed.BellyScaleIneed00)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Ineed.BellyScaleIneed01", Ineed.BellyScaleIneed01)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Ineed.BellyScaleIneed02", Ineed.BellyScaleIneed02)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Ineed.BellyScaleIneed03", Ineed.BellyScaleIneed03)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "WarmBodies", WarmBodies)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "MilkLeakWet", MilkLeakWet)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumWetMult", CumWetMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumExposureMult", CumExposureMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SimpleSlaveryFF", SimpleSlaveryFF)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SdDreamFF", SdDreamFF)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SlaverunFactor", TollUtil.SlaverunFactor)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "TollDodgeGracePeriod", TollDodgeGracePeriod)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "TollDodgeHuntFreq", TollDodgeHuntFreq)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "TollDodgeItemValueMod", TollDodgeItemValueMod)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "GuardSpotDistNom", GuardSpotDistNom)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "GuardSpotDistTown", GuardSpotDistTown)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "TollDodgeDisguiseBodyPenalty", TollDodgeDisguiseBodyPenalty)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "TollDodgeDisguiseHeadPenalty", TollDodgeDisguiseHeadPenalty)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "_SLS_GateCurfewBegin", (Game.GetFormFromFile(0x0EAB5A, "SL Survival.esp") as GlobalVariable).GetValue()) ; _SLS_GateCurfewBegin
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "_SLS_GateCurfewEnd", (Game.GetFormFromFile(0x0EAB5B, "SL Survival.esp") as GlobalVariable).GetValue()) ; _SLS_GateCurfewEnd
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "_SLS_GateCurfewSlavetownBegin", (Game.GetFormFromFile(0x0EE155, "SL Survival.esp") as GlobalVariable).GetValue()) ; _SLS_GateCurfewSlavetownBegin
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "_SLS_GateCurfewSlavetownEnd", (Game.GetFormFromFile(0x0EE156, "SL Survival.esp") as GlobalVariable).GetValue()) ; _SLS_GateCurfewSlavetownEnd
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "LicBlockChance", LicBlockChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "LicUtil.LicFactionDiscount", LicUtil.LicFactionDiscount)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "LicUtil.LicShortDur", LicUtil.LicShortDur)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "LicUtil.LicLongDur", LicUtil.LicLongDur)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "EnforcerRespawnDur", EnforcerRespawnDur)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniCurse.HeelHeightRequired", BikiniCurse.HeelHeightRequired)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "RoadDist", RoadDist)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "StealXItems", StealXItems)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BegGold", BegGold)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BegMwaCurseChance", BegMwaCurseChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "KennelRapeChancePerHour", KennelRapeChancePerHour)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "KennelCreatureChance", KennelCreatureChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpGoldLowChance", PpGoldLowChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpGoldModerateChance", PpGoldModerateChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpGoldHighChance", PpGoldHighChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootFoodChance", PpLootFoodChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootGemsChance", PpLootGemsChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootSoulgemsChance", PpLootSoulgemsChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootJewelryChance", PpLootJewelryChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootEnchJewelryChance", PpLootEnchJewelryChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootPotionsChance", PpLootPotionsChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootKeysChance", PpLootKeysChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootTomesChance", PpLootTomesChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PpLootCureChance", PpLootCureChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "DismemberCooldown", DismemberCooldown)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "DismemberChance", DismemberChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "DismemberArmorBonus", DismemberArmorBonus)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "DismemberHealthThres", DismemberHealthThres)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniExp.ExpPerLevel", BikiniExp.ExpPerLevel)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikTrainingSpeed", BikTrainingSpeed)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikUntrainingSpeed", BikUntrainingSpeed)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceHide", BikiniChanceHide)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceLeather", BikiniChanceLeather)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceIron", BikiniChanceIron)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceSteel", BikiniChanceSteel)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceSteelPlate", BikiniChanceSteelPlate)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceDwarven", BikiniChanceDwarven)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceFalmer", BikiniChanceFalmer)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceWolf", BikiniChanceWolf)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceBlades", BikiniChanceBlades)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceEbony", BikiniChanceEbony)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "BikiniChanceDragonbone", BikiniChanceDragonbone)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "IneqFemaleVendorGoldMult", IneqFemaleVendorGoldMult)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CatCallVol", CatCallVol)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumIsLactacid", CumIsLactacid)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "ProxSpankCooloff", ProxSpankCooloff)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CatCallWillLoss", CatCallWillLoss)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "GreetDist", GreetDist)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictBatheRefuseTime", CumAddictBatheRefuseTime)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictReflexSwallow", CumAddictReflexSwallow)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictAutoSuckCreature", CumAddictAutoSuckCreature)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictAutoSuckCooldown", CumAddictAutoSuckCooldown)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictAutoSuckCreatureArousal", CumAddictAutoSuckCreatureArousal)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "AssSlapResistLoss", AssSlapResistLoss)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "GoldWeight", GoldWeight)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumSatiation", CumSatiation)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictionHungerRate", CumAddictionHungerRate)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictionSpeed", CumAddictionSpeed)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictionDecayPerHour", CumAddictionDecayPerHour)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CockSizeBonusEnjFreq", CockSizeBonusEnjFreq)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "RapeForcedSkoomaChance", RapeForcedSkoomaChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "RapeMinArousal", RapeMinArousal)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "DeviousGagDebuff", DeviousGagDebuff)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "CumAddictDayDreamVol", StorageUtil.GetFloatValue(Self, "CumAddictDayDreamVol", Missing = 1.0))
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "ScaleMaxBreasts", Main.Slif.ScaleMaxBreasts)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "ScaleMaxBelly", Main.Slif.ScaleMaxBelly)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "ScaleMaxAss", Main.Slif.ScaleMaxAss)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "HaircutChance", FashionRape.HaircutChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "DyeHairChance", FashionRape.DyeHairChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "ShavePussyChance", FashionRape.ShavePussyChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SmudgeLipstickChance", FashionRape.SmudgeLipstickChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "SmudgeEyeshadowChance", FashionRape.SmudgeEyeshadowChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "WeightGainPerDay", StorageUtil.GetFloatValue(Self, "WeightGainPerDay", Missing = 0.0))
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "PushCooldown", (Game.GetFormFromFile(0x0E651A, "SL Survival.esp") as _SLS_PushPlayerCooloff).CooloffPeriod)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "TimeBetweenFucks", (Game.GetFormFromFile(0x0E7553, "SL Survival.esp") as _SLS_CompulsiveSex).TimeBetweenFucks)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "OrgasmFatigueThreshold", (Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmThreshold)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "OrgasmFatigueRecovery", (Game.GetFormFromFile(0x0E857D, "SL Survival.esp") as _SLS_OrgasmFatigue).OrgasmRecoveryPerHour)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "TimeToClearStreets", (Game.GetFormFromFile(0x0E3F3D, "SL Survival.esp") as _SLS_Curfew).TimeToClearStreets)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "_SLS_CurfewBegin", (Game.GetFormFromFile(0x07B44C, "SL Survival.esp") as GlobalVariable).GetValue()) ; _SLS_CurfewBegin
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "_SLS_CurfewEnd", (Game.GetFormFromFile(0x07B44D, "SL Survival.esp") as GlobalVariable).GetValue()) ; _SLS_CurfewEnd
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "_SLS_CurfewSlavetownBegin", (Game.GetFormFromFile(0x0ECBC0, "SL Survival.esp") as GlobalVariable).GetValue()) ; _SLS_CurfewSlavetownBegin
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "_SLS_CurfewSlavetownEnd", (Game.GetFormFromFile(0x0ECBC1, "SL Survival.esp") as GlobalVariable).GetValue()) ; _SLS_CurfewSlavetownEnd
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.StartingAlpha", Trauma.StartingAlpha)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.MaxAlpha", Trauma.MaxAlpha)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.HoursToMaxAlpha", Trauma.HoursToMaxAlpha)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.HoursToFadeOut", Trauma.HoursToFadeOut)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.SexChancePlayer", Trauma.SexChancePlayer)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.SexChanceFollower", Trauma.SexChanceFollower)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.SexChanceNpc", Trauma.SexChanceNpc)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.CombatChancePlayer", Trauma.CombatChancePlayer)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.CombatChanceFollower", Trauma.CombatChanceFollower)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.CombatChanceNpc", Trauma.CombatChanceNpc)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Trauma.PushChance", Trauma.PushChance)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Util.PainSoundVol", Util.PainSoundVol)
		JsonUtil.SetFloatValue("SL Survival/Settings.json", "Util.HitSoundVol", Util.HitSoundVol)
		
		; Int list
		JsonUtil.IntListCopy("SL Survival/Settings.json", "InnCosts", LocTrack.InnCosts)
		
		; Forms
		SaveFormlistToJson(_SLS_CumHasLactacidVoices, "SL Survival/Settings.json", "_SLS_CumHasLactacidVoices", ClearJsonKey = true)

		JsonUtil.Save("SL Survival/Settings.json")
		If IsInMcm
			SetTextOptionValue(ExportSettingsOID_T, "Save Complete!")
		EndIf
		Utility.WaitMenuMode(0.7)
		If IsInMcm
			SetTextOptionValue(ExportSettingsOID_T, "")
		EndIf
	EndIf
EndFunction

Function SaveFormlistToJson(Formlist FlSelect, String FileName, String JsonKey, Bool ClearJsonKey = true)
	If ClearJsonKey
		JsonUtil.FormListClear(FileName, JsonKey)
	EndIf

	Form akForm
	Int i = 0
	While i < FlSelect.GetSize()
		akForm = FlSelect.GetAt(i)
		If akForm
			JsonUtil.FormListAdd(FileName, JsonKey, akForm, allowDuplicate = false)
			Debug.Trace("_SLS_: Saved " + akForm + " to key " + JsonKey + " in file: " + FileName + " to formlist: " + FlSelect)
		EndIf
		i += 1
	EndWhile
EndFunction

Function LoadJsonFormsToFormlist(Formlist FlSelect, String FileName, String JsonKey, Bool RevertFl = true)
	If RevertFl
		FlSelect.Revert()
	EndIf
	
	Form akForm
	Int i = 0
	While i < JsonUtil.FormListCount(FileName, JsonKey)
		akForm = JsonUtil.FormListGet(FileName, JsonKey, i)
		If akForm
			FlSelect.AddForm(akForm)
			Debug.Trace("_SLS_: Loaded " + akForm + " from key " + JsonKey + " in file: " + FileName + " to formlist: " + FlSelect)
		EndIf
		i += 1
	EndWhile
EndFunction

; MCM Begin ===================================================

; Keys
Int AllInOneKeyOID

; Text
Int ImportSettingsOID_T
Int ExportSettingsOID_T
Int SearchEscortsOID_T
Int AddEscortToListOID_T
Int RemoveEscortFromListOID_T
Int ClearAllEscortsOID_T
Int ImportEscortsFromJsonOID_T
Int LicGetEquipListOID_T
Int AddLicExceptionOID_T
Int TradeRestrictAddMerchantOID_T
Int TradeRestrictRemoveMerchantOID_T
Int TradeRestrictResetAllMerchantsOID_T
Int LicBikiniTriggerOID_T
Int StashAddRemoveExceptionOID_T
Int StashAddRemoveJsonExceptionsOID_T
Int StashAddRemoveTempExceptionsOID_T
Int StashAddRemoveAllExceptionsOID_T
Int LicBikiniHeelsOID
Int DiscountCollegeOID_T
Int DiscountCompanionsOID_T
Int DiscountCwOID_T
Int BikiniBuildListOID_T
Int BikiniClearListOID_T
Int BikiniChanceNoneOID_S
Int SexExpResetStatsOID_T
Int ModStrongFemaleOID_T
Int AddFondleToListOID_T
Int RemoveFondleFromListOID_T
Int FondleInfoOID_T
Int Property RunDevicePatchUpOID_T Auto Hidden
Int LicShowApiBlockFormsOID_T
Int LicClearApiBlockFormsOID_T
Int CurrentLocationOID_T
Int AddTownLocationOID_T
Int RemoveTownLocationOID_T
Int DismemberChanceActualOID_T
Int CumLactacidCustomOID_T
Int TollDodgedWhiterunOID_T
Int TollDodgedSolitudeOID_T
Int TollDodgedMarkarthOID_T
Int TollDodgedWindhelmOID_T
Int TollDodgedRiftenOID_T

; Toggles
Int CoverMyselfMechanicsOID
Int AssSlappingOID
Int ProxSpankCommentOID
Int EasyBedTrapsOID
Int CumBreathOID
Int CumBreathNotifyOID
Int DropItemsOID
Int SlsCreatureEventOID
Int AnimalBreedEnableOID
Int FollowersStealGoldOID
Int HardcoreModeOID
Int DebugModeOID
Int SlaverunAutoStartOID
Int MinAvToggleOID
Int FastTravelDisableOID
Int FtDisableIsNormalOID
Int ConstructableMapAndCompassOID
Int ReplaceMapsOID
Int CompassMechanicsOID
Int CumSwallowInflateOID
Int CumEffectsEnableOID
Int CumEffectsStackOID
Int CumAddictEnOID
Int CumAddictClampHungerOID
Int CumAddictBeastLevelsOID
Int SuccubusCumSwallowEnergyPerRankOID
Int CumLactacidAllOID
Int CumLactacidAllPlayableOID
;/
Int CumLactacidBearOID
Int CumLactacidChaurusOID
Int CumLactacidDeerOID
Int CumLactacidDogOID
Int CumLactacidDragonPriestOID
Int CumLactacidDragonOID
Int CumLactacidDraugrOID
Int CumLactacidDremoraOID
Int CumLactacidDwarvenCenturionOID
Int CumLactacidDwarvenSphereOID
Int CumLactacidDwarvenSpiderOID
Int CumLactacidFalmerOID
Int CumLactacidFoxOID
Int CumLactacidSpiderOID
Int CumLactacidGiantOID
Int CumLactacidGoatOID
Int CumLactacidHorkerOID
Int CumLactacidHorseOID
Int CumLactacidMammothOID
Int CumLactacidSabrecatOID
Int CumLactacidSkeeverOID
Int CumLactacidSprigganOID
Int CumLactacidTrollOID
Int CumLactacidWerewolfOID
Int CumLactacidWolfOID
/;
Int FfRescueEventsOID
Int MilkDecCumBreathOID
Int PpLootEnableOID
Int PpFailHandleOID
Int PpSleepNpcPerkOID
;/
Int IntRndOID
Int IntIneedOID
Int IntEsdOID
Int IntFrostfallOID
Int IntSlaverunOID
Int IntPscOID
Int IntDdsOID
Int IntDfOID
Int IntEffOID
Int IntSgoOID
Int IntStaOID
Int IntFhuOID
Int IntAmpOID
Int IntAproposTwoOID
Int IntTatsOID
Int IntMaOID
Int IntSlaxOID
Int IntSlsfOID
Int IntSlsoOID
/;
Int HalfNakedEnableOID
Int HalfNakedStripsOID
Int SexExpEnableOID
Int DremoraCorruptionOID
Int SexMinStamMagRatesOID
Int SexRapeDrainsAttributesOID
Int CurfewEnableOID

Int IneqStatsOID
Int IneqCarryOID
Int InqSpeedOID
Int IneqDamageOID
Int IneqDestOID
Int IneqSkillsOID
Int IneqBuySellOID
Int IneqStrongFemaleFollowersOID

Int NormalKnockDialogOID
Int SleepDeprivOID
Int SaltyCumOID
Int BellyScaleEnableOID
Int GoldPerLevelOID
Int DoorLockDownOID
Int TollFollowersHardcoreOID
Int TollDodgingOID
Int TollDodgeGiftMenuOID
Int StashTrackEnOID
Int ContTypeCountsOID
Int OrgasmRequiredOID
Int LicencesEnableOID
Int LicencesSnowberryOID
Int BikiniLicFirstOID
Int LicBuyBackOID
Int LicBountyMustBePaidOID
Int FolContraBlockOID
Int FolContraKeysOID
Int FolTakeClothesOID
Int OrdinSupressOID
Int CurseTatsOID
Int ResponsiveEnforcersOID
Int PersistentEnforcersOID_S
Int RestrictTradeOID
Int BeggingTOID
Int BegSelfDegEnableOID
Int KennelExtraDevicesOID
Int KennelFollowerToggleOID
Int GuardCommentsOID
Int GuardBehavWeapDropOID
Int GuardBehavWeapEquipOID
Int GuardBehavWeapDrawnOID
Int GuardBehavArmorEquipOID
Int GuardBehavLockpickingOID
Int GuardBehavDrugsOID
Int GuardBehavShoutOID
Int DeviousEffectsEnableOID
Int DevEffNoGagTradingOID
Int BondFurnEnableOID
Int BikiniExpOID
Int BikiniExpReflexesOID

; Sliders
Int ReplaceMapsTimerOID_S
Int GoldWeightOID_S
Int FolGoldStealChanceOID_S
Int FolGoldSteamAmountOID_S
Int SlaverunAutoMinOID_S
Int SlaverunAutoMaxOID_S
Int HalfNakedBraOID_S
Int HalfNakedPantyOID_S
Int SexExpCorruptionCurrentOID_S
Int CockSizeBonusEnjFreqOID_S
Int RapeForcedSkoomaChanceOID_S
Int RapeMinArousalOID_S
Int SexMinStaminaRateOID_S
Int SexMinStaminaMultOID_S
Int SexMinMagickaRateOID_S
Int SexMinMagickaMultOID_S
Int AssSlapResistLossOID_S
Int ProxSpankCooloffOID_S
Int CumIsLactacidOID_S
Int AproTwoTrollHealAmountOID
Int AfCooloffBaseOID_S
Int AfCooloffBodyCumOID_S
Int AfCooloffCumInflationOID_S
Int AfCooloffPregnancyOID_S
Int AfCooloffCumSwallowOID_S
Int DflowResistLossOID_S
Int CumSwallowInflateMultOID_S
Int CumEffectsMagMultOID_S
Int CumEffectsDurMultOID_S
Int CumpulsionChanceOID_S
Int CumRegenTimeOID_S
Int CumEffectVolThresOID_S
Int SuccubusCumSwallowEnergyMultOID_S
Int CumAddictionSpeedOID_S
Int CumAddictHungerRateOID_S
Int CumAddictHungerRateEffective
Int CumAddictionPerHourOID_S
Int CumSatiationOID_S
Int CumAddictBatheRefuseTimeOID_S
Int CumAddictReflexSwallowOID_S
Int CumAddictAutoSuckCreatureOID_S
Int CumAddictAutoSuckCooldownOID_S
Int CumAddictAutoSuckCreatureArousalOID_S
Int DeviousGagDebuffOID_S
Int BondFurnMilkFreqOID_S
Int BondFurnMilkFatigueMultOID_S
Int BondFurnMilkWillOID_S
Int BondFurnFreqOID_S
Int BondFurnFatigueMultOID_S
Int BondFurnWillOID_S
Int BarefootMagOIS_S
Int HorseCostOIS_S
Int CatCallVolOIS_S
Int CatCallWillLossOIS_S
Int GreetDistOIS_S
Int MinSpeedOID_S
Int MinCarryWeightOID_S

Int PpGoldChanceOfNoneOID_T
Int PpGoldLowChanceOID_S
Int PpGoldModerateChanceOID_S
Int PpGoldHighChanceOID_S
Int PpLootMinOID_S
Int PpLootMaxOID_S
Int PpLootChanceOfNoneOID_T
Int PpLootFoodChanceOID_S
Int PpLootGemsChanceOID_S
Int PpLootSoulgemsChanceOID_S
Int PpLootJewelryChanceOID_S
Int PpLootEnchJewelryChanceOID_S
Int PpLootPotionsChanceOID_S
Int PpLootKeysChanceOID_S
Int PpLootTomesChanceOID_S
Int PpLootCureChanceOID_S

Int PpCrimeGoldOID_S
Int PpFailDevicesOID_S
Int PpFailStealValueOID_S
Int PpFailDrugCountOID_S

Int DismemberCooldownOID_S
Int DismemberMaxAmpedLimbsOID_S
Int DismemberChanceOID_S
Int DismemberArmorBonusOID_S
Int DismemberDamageThresOID_S
Int DismemberHealthThresOID_S
Int AmpPriestHealCostOID_S
Int DismemberTrollCumOID
Int DismemberBathingOID
Int DismemberPlayerSayOID

Int IneqStatsValOID
Int IneqCarryValOID
Int IneqSpeedValOID
Int IneqDamageValOID
Int IneqDestValOID
Int IneqHealthCushionOID
Int IneqVendorGoldOID

Int KnockSlaveryChanceOID_S
Int SimpleSlaveryWeightOID_S
Int SdWeightOID_S

Int GluttedSpeedMultOID_S
Int CumFoodMultOID_S
Int CumDrinkMultOID_S
Int SkoomaSleepOID_S
Int MilkSleepMultOID_S
Int DrugEndFatigueIncOID_S
Int BaseBellyScaleOID_S
Int BellyScaleRnd00OID_S
Int BellyScaleRnd01OID_S
Int BellyScaleRnd02OID_S
Int BellyScaleRnd03OID_S
Int BellyScaleRnd04OID_S
Int BellyScaleRnd05OID_S

Int BellyScaleIneed00OID_S
Int BellyScaleIneed01OID_S
Int BellyScaleIneed02OID_S
Int BellyScaleIneed03OID_S

Int WarmBodiesOID_S
Int CumWetMultOID_S
Int CumExposureMultOID_S
Int MilkLeakWetOID_S
Int SwimCumCleanOID_S
Int SimpleSlaveryFFOID_S
Int SdDreamFFOID_S

Int EvictionLimitOID_S
Int SlaverunEvictionLimitOID_S
Int ConfiscationFineOID_S
Int ConfiscationFineSlaverunOID_S
Int TollCostGoldOID_S
Int SlaverunFactorOID
Int SlaverunJobFactorOID
Int TollCostDevicesOID_S
Int TollCostTattoosOID_S
Int TollCostDrugsOID_S
Int MaxTatsBodyOID_S
Int MaxTatsFaceOID_S
Int MaxTatsHandsOID_S
Int MaxTatsFeetOID_S
Int TollFollowersOID_S
Int TollDodgeHuntFreqOID_S
Int TollDodgeMaxGuardsOID_S
Int TollDodgeDetectDistMaxOID_S
Int TollDodgeDetectDistTownMaxOID_S
Int TollDodgeDisguiseBodyPenaltyOID_S
Int TollDodgeDisguiseHeadPenaltyOID_S
Int TollDodgeCurrentSpotDist
Int TollDodgeCurrentSpotDistTown
Int TollDodgeItemValueModOID_S
Int TollDodgeGracePeriodOID_S

Int EnforcerRespawnDurOID_S
Int TradeRestrictBribeOID_S
Int LicUnlockCostOID_S
Int LicBlockChanceOID_S
Int LicFactionDiscountOID_S
Int LicShortDurOID_S
Int LicLongDurOID_S
Int LicWeapShortCostOID_S
Int LicWeapLongCostOID_S
Int LicWeapPerCostOID_S
Int LicMagicShortCostOID_S
Int LicMagicLongCostOID_S
Int LicMagicPerCostOID_S
Int LicArmorShortCostOID_S
Int LicArmorLongCostOID_S
Int LicArmorPerCostOID_S
Int LicBikiniEnableOID
Int LicBikiniCurseEnableOID
Int LicMagicEnableOID
Int LicMagicCursedDevicesOID
Int LicMagicChainCollarsOID
Int LicBikiniHeelHeightOID_S
Int LicBikiniShortCostOID_S
Int LicBikiniLongCostOID_S
Int LicBikiniPerCostOID_S
Int LicClothesShortCostOID_S
Int LicClothesLongCostOID_S
Int LicClothesPerCostOID_S
Int EnforcersMinOID_S
Int EnforcersMaxOID_S

Int RoadDistOID_S
Int StealXItemsOID_S

Int BegNumItemsOID_S
Int BegGoldOID_S
Int BegMwaCurseChanceOID_S
Int KennelSafeCellCostOID_S
Int KennelCreatureChanceOID_S
Int KennelRapeChancePerHourOID_S
Int KennelSlaveRapeTimeMinOID_S 
Int KennelSlaveRapeTimeMaxOID_S

Int BikiniExpPerLevelOID_S
Int BikiniExpTrainOID_S
Int BikiniExpUntrainOID_S

Int BikiniDropsVendorCityOID_S
Int BikiniDropsVendorTownOID_S
Int BikiniDropsVendorKhajiitOID_S
Int BikiniDropsChestOID_S
Int BikiniDropsChestOrnateOID_S

Int BikiniChanceHideOID_S
Int BikiniChanceLeatherOID_S
Int BikiniChanceIronOID_S
Int BikiniChanceSteelOID_S
Int BikiniChanceSteelPlateOID_S
Int BikiniChanceDwarvenOID_S
Int BikiniChanceFalmerOID_S
Int BikiniChanceWolfOID_S
Int BikiniChanceBladesOID_S
Int BikiniChanceEbonyOID_S
Int BikiniChanceDragonboneOID_S

; DialogBox
Int PushEventsDB
Int ProxSpankNpcDB
Int ProxSpankCoverDB
Int CumAddictAutoSuckStageDB
Int LicClothesEnableDB
Int BegSexAggDB
Int BegSexVictimDB
Int KennelSexAggDB
Int KennelSexVictimDB
Int CompassHideMethodDB
Int DevEffLockpickDiffDB
Int DevEffPickpocketDiffDB
Int TollSexAggDB
Int TollSexVictimDB
Int DismembermentsDB
Int DismemberProgressionDB
Int DismemberWeaponsDB
Int DismemberDepthMaxArmsDB
Int DismemberDepthMaxLegsDB
Int LicenceStyleDB
Int FollowerLicStyleDB
Int LicBuyBackPriceDB
Int LicEquipListDB
Int BikiniCurseAreaDB
Int MagicCurseAreaDB
Int SexExpCorruptionDB

; Menu Variables Begin =======================================================

Bool IsInMcm = false ; Set to true when the SLS Mcm is opened and set false when it's closed

Bool DoSlaverunInitOnClose = false
Bool DoToggleCatCalling = false
Bool HardcoreMode = false
Bool IsHardcoreLocked = false
Bool LicMagicChainCollars = false
Bool TradeRestrictions = true
Bool PpLootEnable = true
Bool DoToggleCumEffects = false
Bool DoPpLvlListbuildOnClose = false
Bool DoTogglePpFailHandle = false
Bool DoInequalityRefresh = false
Bool DoToggleBikiniExp = false
Bool DoToggleAnimalBreeding = false
Bool DoTogglePushEvents = false
Bool DoToggleHalfNakedCover = false
Bool DoToggleIneqStrongFemaleFollowers = false
Bool DoToggleSexExp = false
Bool DoToggleHeelsRequired = false
Bool DoToggleStashTracking = false
Bool DoStashAddRemoveException = false
Bool CumEffectsEnable = true
Bool BikiniExpT = true
Bool InequalitySkills = true
Bool InequalityBuySell = true
Bool IneqStrongFemaleFollowers = false
Bool TollFollowersHardcore = false
Bool Property CoverMyselfMechanics = true Auto Hidden
Bool AssSlappingEvents = true
Bool Property BellyScaleEnable = true Auto Hidden
Bool Property HalfNakedEnable = false Auto Hidden
Bool SleepDepriv = true
Bool SlaverunAutoStart = false
Bool DoDeviousEffectsChange = false
Bool DoToggleBondFurn = false
Bool Property TollDodging = true Auto Hidden
Bool DoTollDodgingToggle = false
Bool FolContraBlock = true
Bool PpFailHandle = true
Bool PpSleepNpcPerk = true
Bool DoToggleLicenceStyle = false
Bool DoToggleGuardComments = false
Bool DoToggleGuardBehavWeapDrawn = false
Bool DoToggleGuardBehavLockpick = false
Bool DoToggleGuardBehavArmorEquip = false
Bool DoToggleGuardBehavWeapEquip = false
Bool DoToggleGuardBehavDrugs = false
Bool GuardComments = true
Bool Property GuardBehavWeapDrawn = true Auto Hidden
Bool Property GuardBehavArmorEquip = false Auto Hidden
Bool Property GuardBehavWeapEquip = true Auto Hidden
Bool GuardBehavLockpicking = true
Bool GuardBehavDrugs = true
Bool DoToggleProxSpank = false
Bool DoToggleBarefootSpeed = false
Bool DoToggleCumAddiction = false
Bool DoToggleCoverMechanics = false
Bool DoToggleCumAddictAutoSuckCreature = false
Bool Property SnowberryEnable = false Auto Hidden
Bool DoToggleBellyInflation = false

Bool Property CumLactacidAll = false Auto Hidden
Bool Property CumLactacidAllPlayable = false Auto Hidden

Int ProxSpankNpcType = 1
Int TradeRestrictBribe = 50
Int SurvivalHorseCost = 6000

Float PpGoldLowChance = 60.0
Float PpGoldModerateChance = 20.0
Float PpGoldHighChance = 2.0

Int PpLootLootMin = 0
Int PpLootLootMax = 8
Float PpLootFoodChance = 25.0
Float PpLootGemsChance = 15.0
Float PpLootSoulgemsChance = 10.0
Float PpLootJewelryChance = 15.0
Float PpLootEnchJewelryChance = 5.0
Float PpLootPotionsChance = 10.0
Float PpLootKeysChance = 10.0
Float PpLootTomesChance = 5.0
Float PpLootCureChance = 5.0
Float GreetDist = 150.0

Int SelectedEquip = 0

Int BikiniDropsVendorCity = 30
Int BikiniDropsVendorTown = 16
Int BikiniDropsVendorKhajiit = 12
Int BikiniDropsChest = 6
Int BikiniDropsChestOrnate = 10

Float BikiniChanceHide = 10.0
Float BikiniChanceLeather = 10.0
Float BikiniChanceIron = 10.0
Float BikiniChanceSteel = 11.0
Float BikiniChanceSteelPlate = 8.0
Float BikiniChanceDwarven = 6.0
Float BikiniChanceFalmer = 6.0
Float BikiniChanceWolf = 6.0
Float BikiniChanceBlades = 2.0
Float BikiniChanceEbony = 1.0
Float BikiniChanceDragonbone = 0.5

Float Property IneqFemaleVendorGoldMult = 1.0 Auto Hidden
Float IneqStatsVal = 40.0
Float IneqHealthCushion = 20.0
Float IneqCarryVal = 150.0
Float IneqSpeedVal = 10.0
Float IneqDamageVal = 20.0
Float IneqDestVal = 20.0

Int Property AmpType = 2 Auto Hidden ; Off/Random/Hands first
Int Property AmpDepth = 2 Auto Hidden ; One level at a time/Max in one go/Random
Int Property MaxAmpDepthArms = 1 Auto Hidden
Int Property MaxAmpDepthLegs = 1 Auto Hidden
Int Property DismemberDamageThres = 3 Auto Hidden
Int Property DismemberWeapon = 0 Auto Hidden ; Twohanded/Everything except daggers & ranged/Everything
Int Property MaxAmpedLimbs = 2 Auto Hidden ; How many limbs can be amputated at any one time
Float Property DismemberChance = 90.0 Auto Hidden
Float Property DismemberArmorBonus = 5.0 Auto Hidden
Float Property DismemberCooldown = 0.1 Auto Hidden
Float Property DismemberHealthThres = 110.0 Auto Hidden

Int[] Property SlotMasks Auto Hidden

String[] SplashArray

String[] PushEventsType
String[] ClothesLicenceMethod
String[] HeavyBondageDifficulty
String[] SexAggressiveness
String[] SexPlayerIsVictim
String[] FollowerLicStyles
String[] CompassHideMethods

String[] EquipSlotStrings
Form[] EquipSlots

String[] AmputationTypes
String[] AmputationDepth
String[] MaxAmputationDepthArms
String[] MaxAmputationDepthLegs
String[] DismemberWeapons
String[] Property OverlayAreas Auto Hidden
String[] BuyBackPrices
String[] LicenceStyleList
String[] ProxSpankNpcList
String[] ProxSpankRequiredCoverList
String[] CumHungerStrings
String[] SexExpCreatureCorruption

; Properties ============================================================
Int Property FolGoldStealChance = 50 Auto Hidden
Int Property FolGoldSteamAmount = 30 Auto Hidden
Int Property PpCrimeGold = 100 Auto Hidden
Int Property PpFailDevices = 4 Auto Hidden
Int Property PpFailDrugCount = 2 Auto Hidden
Int Property AproTwoTrollHealAmount = 200 Auto Hidden
Int Property BondFurnMilkWill = 4 Auto Hidden
Int Property BondFurnWill = 2 Auto Hidden
Int Property SwimCumClean = 12 Auto Hidden
Int Property ConfiscationFine = 100 Auto Hidden
Int Property ConfiscationFineSlaverun = 200 Auto Hidden
Int Property TollSexAgg = 0 Auto Hidden
Int Property TollSexVictim = 0 Auto Hidden
Int Property MaxTatsBody = 6 Auto Hidden
Int Property MaxTatsFace = 3 Auto Hidden
Int Property MaxTatsHands = 0 Auto Hidden
Int Property MaxTatsFeet = 0 Auto Hidden
Int Property BegNumItems = 2 Auto Hidden
Int Property BegSexAgg = 0 Auto Hidden
Int Property BegSexVictim = 0 Auto Hidden
Int Property HalfNakedBra = 56 Auto Hidden
Int Property HalfNakedPanty = 49 Auto Hidden
Int Property SexExpCorruption = 0 Auto Hidden
Int Property TollDodgeMaxGuards = 6 Auto Hidden
Int Property BikiniCurseArea = 0 Auto Hidden
Int Property MagicCurseArea = 1 Auto Hidden
Int Property EnforcersMin = 2 Auto Hidden
Int Property BuyBackPrice = 2 Auto Hidden
Int Property EnforcersMax= 4 Auto Hidden
Int Property BegQuantity = 2 Auto Hidden
Int Property KennelSafeCellCost = 40 Auto Hidden
Int Property PushEvents = 0 Auto Hidden ; 0 - Off, 1 - Stagger, 2 - Paralysis, 3 - Both
Int Property DevEffLockpickDiff = 1 Auto Hidden
Int Property DevEffPickpocketDiff = 1 Auto Hidden
Int Property KennelSlaveRapeTimeMin = 10 Auto Hidden
Int Property KennelSlaveRapeTimeMax = 40 Auto Hidden
Int Property KennelSexAgg = 2 Auto Hidden
Int Property KennelSexVictim = 1 Auto Hidden
Int Property CumHungerAutoSuck = 2 Auto Hidden
Int Property CompassHideMethod = 0 Auto Hidden

Float Property BarefootMag = 50.0 Auto Hidden
Float Property CatCallVol = 20.0 Auto Hidden
Float Property CatCallWillLoss = 1.0 Auto Hidden
Float Property SlaverunAutoMin = 2.0 Auto Hidden
Float Property SlaverunAutoMax = 14.0 Auto Hidden
Float Property AssSlapResistLoss = 1.0 Auto Hidden
Float Property ProxSpankCooloff = 10.0 Auto Hidden
Float Property CockSizeBonusEnjFreq = 3.0 Auto Hidden
Float Property RapeForcedSkoomaChance = 35.0 Auto Hidden
Float Property RapeMinArousal = 50.0 Auto Hidden
Float Property SexMinStaminaRate = 2.5 Auto Hidden
Float Property SexMinStaminaMult = 60.0 Auto Hidden
Float Property SexMinMagickaRate = 1.5 Auto Hidden
Float Property SexMinMagickaMult = 50.0 Auto Hidden
Float Property KennelRapeChancePerHour = 20.0 Auto Hidden
Float Property MinSpeedMult = 50.0 Auto Hidden
Float Property MinCarryWeight = 50.0 Auto Hidden
Float Property ReplaceMapsTimer = 180.0 Auto Hidden
Float Property GoldWeight = 0.01 Auto Hidden
Float Property GluttedSpeed = 10.0 Auto Hidden
Float Property SkoomaSleep = 1.0 Auto Hidden
Float Property MilkSleepMult = 1.0 Auto Hidden
Float Property DrugEndFatigueInc = 0.25 Auto Hidden
Float Property CumIsLactacid = 0.0 Auto Hidden
Float Property CumSwallowInflateMult = 1.0 Auto Hidden
Float Property CumEffectsMagMult = 1.0 Auto Hidden
Float Property CumEffectsDurMult = 1.0 Auto Hidden
Float Property CumpulsionChance = 25.0 Auto Hidden
Float Property CumRegenTime = 24.0 Auto Hidden
Float Property CumEffectVolThres = 85.0 Auto Hidden
Float Property SuccubusCumSwallowEnergyMult = 1.0 Auto Hidden
Float Property CumAddictionHungerRate = 0.1 Auto Hidden
Float Property CumAddictionSpeed = 1.0 Auto Hidden
Float Property CumAddictionDecayPerHour = 1.0 Auto Hidden
Float Property CumSatiation = 1.0 Auto Hidden
Float Property CumAddictBatheRefuseTime = 6.0 Auto Hidden
Float Property CumAddictAutoSuckCreature = 1.0 Auto Hidden
Float Property CumAddictAutoSuckCooldown = 6.0 Auto Hidden
Float Property CumAddictAutoSuckCreatureArousal = 70.0 Auto Hidden
Float Property CumAddictReflexSwallow = 1.0 Auto Hidden
Float Property DflowResistLoss = 5.0 Auto Hidden

Float Property DeviousGagDebuff = 80.0 Auto Hidden
Float Property BondFurnMilkFreq = 6.0 Auto Hidden
Float Property BondFurnMilkFatigueMult = 1.0 Auto Hidden
Float Property BondFurnFreq = 3.0 Auto Hidden
Float Property BondFurnFatigueMult = 1.0 Auto Hidden

Float Property KnockSlaveryChance = 3.0 Auto Hidden
Float Property SimpleSlaveryWeight = 50.0 Auto Hidden
Float Property SdWeight = 50.0 Auto Hidden

Float Property WarmBodies = -3.0 Auto Hidden
Float Property CumWetMult = 1.0 Auto Hidden
Float Property CumExposureMult = 1.0 Auto Hidden
Float Property MilkLeakWet = 50.0 Auto Hidden
Float Property SimpleSlaveryFF = 50.0 Auto Hidden
Float Property SdDreamFF = 50.0 Auto Hidden

Float Property EvictionLimit = 500.0 Auto Hidden
Float Property SlaverunEvictionLimit = 200.0 Auto Hidden
Float Property TollDodgeHuntFreq = 1.5 Auto Hidden
Float Property TollDodgeDisguiseBodyPenalty = 0.75 Auto Hidden
Float Property TollDodgeDisguiseHeadPenalty = 0.75 Auto Hidden
Float Property TollDodgeItemValueMod = 1.0 Auto Hidden
Float Property TollDodgeGracePeriod = 2.0 Auto Hidden
Float Property GuardSpotDistNom = 512.0 Auto Hidden
Float Property GuardSpotDistTown = 768.0 Auto Hidden
Float Property EnforcerRespawnDur = 7.0 Auto Hidden

Float Property LicBlockChance = 70.0 Auto Hidden

Float Property RoadDist = 3072.0 Auto Hidden
Float Property StealXItems = 3.0 Auto Hidden

Float Property BegGold = 1.0 Auto Hidden
Float Property BegMwaCurseChance = 50.0 Auto Hidden
Float Property KennelCreatureChance = 50.0 Auto Hidden

Float Property BikTrainingSpeed = 1.0 Auto Hidden
Float Property BikUntrainingSpeed = 0.5 Auto Hidden

Bool Property CumSwallowInflate = true Auto Hidden
Bool Property CumEffectsStack = true Auto Hidden
Bool Property SuccubusCumSwallowEnergyPerRank = true Auto Hidden
Bool Property CumAddictEn = true Auto Hidden
Bool Property CumAddictClampHunger = true Auto Hidden
Bool Property CumAddictBeastLevels = false Auto Hidden
Bool Property MilkDecCumBreath = false Auto Hidden
Bool Property DropItems = true Auto Hidden
Bool Property EasyBedTraps = true Auto Hidden
Bool Property AnimalBreedEnable = true Auto Hidden
Bool Property CumBreath = true Auto Hidden
Bool Property CumBreathNotify = true Auto Hidden
Bool Property FollowersStealGold = true Auto Hidden
Bool Property FastTravelDisable = true Auto Hidden
Bool Property FtDisableIsNormal = true Auto Hidden
Bool Property ReplaceMaps = true Auto Hidden
Bool Property CompassMechanics = true Auto Hidden
Bool Property MinAvToggleT = true Auto Hidden
Bool Property FfRescueEvents = true Auto Hidden
Bool Property DoorLockDownT = true Auto Hidden
Bool Property StashTrackEn = true Auto Hidden
Bool Property ContTypeCountsT = true Auto Hidden
Bool Property OrgasmRequired = true Auto Hidden
Bool Property SaltyCum = false Auto Hidden
Bool Property HalfNakedStrips = false Auto Hidden
Bool Property SexExpEn = true Auto Hidden
Bool Property DremoraCorruption = false Auto Hidden
Bool Property SexMinStamMagRates = true Auto Hidden
Bool Property RapeDrainsAttributes = true Auto Hidden
Bool Property CurfewEnable = true Auto Hidden
Bool Property DeviousEffectsEnable = false Auto Hidden
Bool Property DevEffNoGagTrading = false Auto Hidden
Bool Property BondFurnEnable = true Auto Hidden
Bool Property KennelFollowerToggle = true Auto Hidden
Bool Property DismemberTrollCum = true Auto Hidden
Bool Property DismemberBathing = true Auto Hidden
Bool Property DismemberPlayerSay = true Auto Hidden

Quest Property _SLS_AssSlapQuest Auto
Quest Property _SLS_BellyInflationQuest Auto

Quest Property _SLS_LicenceAliases Auto
Quest Property _SLS_MapAndCompassQuest Auto
Quest Property _SLS_SleepDeprivationQuest Auto
Quest Property _SLS_SlaverunKickerQuest Auto
Quest Property _SLS_HalfNakedCoverQuest Auto
Quest Property _SLS_DeviousEffectsQuest Auto
Quest Property _SLS_TollDodgeHuntQuest Auto
Quest Property _SLS_TollDodgeQuest Auto
Quest Property _SLS_LicenceTradersQuest Auto
Quest Property _SLS_LicFollowerEnforcementDumbQuest Auto
Quest Property _SLS_PickPocketFailDetectQuest Auto
Quest Property _SLS_LicTownCheckEnforcerAliases Auto
Quest Property _SLS_LicTownCheckPlayerAliasQuest Auto
Quest Property _SLS_LicTownCheckQuest Auto
Quest Property _SLS_AmputationQuest Auto
Quest Property _SLS_InequalityRefreshQuest Auto
Quest Property _SLS_BikiniExpTrainingQuest Auto
Quest Property _SLS_CumEffectsQuest Auto
Quest Property _SLS_AnimalFriendQuest Auto
Quest Property _SLS_AnimalFriendAliases Auto
Quest Property _SLS_DeviousFurnitureQuest Auto
Quest Property _SLS_LicenceBuyBlockerQuest Auto
Quest Property _SLS_CatCallsQuest Auto
Quest Property _SLS_GuardWarnLockpickQuest Auto
Quest Property _SLS_GuardWarnDrugsQuest Auto
Quest Property _SLS_GuardWarnArmorEquippedQuest Auto
Quest Property _SLS_GuardWarnArmorEquippedDetectQuest Auto
Quest Property _SLS_GuardWarnWeapEquippedQuest Auto
Quest Property _SLS_GuardWarnWeapEquippedDetectQuest Auto
Quest Property _SLS_GuardWarnWeapDrawnQuest Auto
Quest Property _SLS_GuardWarnWeapDrawnDetectionQuest Auto
Quest Property _SLS_GuardHellosQuest Auto
Quest Property _SLS_HelloSpankAnythingQuest Auto
Quest Property _SLS_HelloSpankGuardsQuest Auto
Quest Property _SLS_HelloSpankGuardsAndMenQuest Auto
Quest Property _SLS_HelloSpankMenQuest Auto
Quest Property _SLS_HelloSpankWomenQuest Auto
Quest Property _SLS_CoverMySelfQuest Auto
Quest Property _SLS_CumAddictAutoSuckCreatureQuest Auto
Quest Property _SLS_SexExperienceQuest Auto
Quest Property _SLS_SexCockSizeQuest Auto
Quest Property _SLS_StashTrack Auto
Quest Property _SLS_StashAddExceptionQuest Auto
Quest Property _SLS_FindEscortsQuest Auto
Quest Property _SLS_LicenceQuest Auto
Quest Property _SLS_LicenceSnowberryQuest Auto

Quest Property CW01A Auto
Quest Property CW01B Auto
Quest Property Stables Auto
Quest Property MQ101 Auto

Actor Property PlayerRef Auto

Faction Property PotentialFollowerFaction Auto
Faction Property PotentialHireling Auto
Faction Property CollegeofWinterholdFaction Auto
Faction Property CompanionsFaction Auto
Faction Property _SLS_IneqStrongFemaleFact Auto

ObjectReference Property _SLS_LicenceGateActJkRef Auto
ObjectReference Property _SLS_LicenceDumpRef Auto

Spell Property _SLS_MagicLicenceCurse Auto
Spell Property _SLS_InequalitySpell Auto
Spell Property _SLS_BikiniExpSpell Auto
Spell Property _SLS_DebugGetActorPackSpell Auto
Spell Property _SLS_DebugGetActorVoiceTypeSpell Auto
Spell Property _SLS_WeaponReadySpell Auto
Spell Property _SLS_CumAddictHungerSpell Auto
Spell Property _SLS_CumAddictStatusSpell Auto
Spell Property _SLS_LicInspLostSightSpell Auto

MagicEffect Property _SLS_MagicLicenceCollarMgef Auto
MagicEffect Property _SLS_LicBikiniCurseInactiveMgef Auto
MagicEffect Property _SLS_LicBikiniCurseStamina Auto

Perk Property _SLS_CreatureTalk Auto
Perk Property _SLS_IncPickpocketLootPerk Auto
Perk Property _SLS_PickpocketSleepBonusPerk Auto
Perk Property _SLS_InequalityBuySellPerk Auto
Perk Property _SLS_InequalitySkillsPerk Auto
Perk Property _SLS_BikiniExpPerk Auto

Formlist Property _SLS_LicenceGateActList Auto
Formlist Property _SLS_TraderListExceptions Auto
Formlist Property _SLS_TraderListAll Auto
Formlist Property _SLS_TraderBaseListAll Auto
Formlist Property _SLS_TraderListFalkreath Auto
Formlist Property _SLS_TraderListMarkarth Auto
Formlist Property _SLS_TraderListMorthal Auto
Formlist Property _SLS_TraderListRavenRock Auto
Formlist Property _SLS_TraderListRiften Auto
Formlist Property _SLS_TraderListRiverwood Auto
Formlist Property _SLS_TraderListSolitude Auto
Formlist Property _SLS_TraderListWhiterun Auto
Formlist Property _SLS_TraderListWindhelm Auto
Formlist Property _SLS_TraderListWinterhold Auto
Formlist Property _SLS_TraderListDawnstar Auto
Formlist Property _SLS_EscortsList Auto
Formlist Property _SLS_QuestItems Auto
Formlist Property _SLS_FondleableVoices Auto
Formlist Property _SLS_LocsWhiterun Auto
Formlist Property _SLS_LocsSolitude Auto
Formlist Property _SLS_LocsMarkarth Auto
Formlist Property _SLS_LocsWindhelm Auto
Formlist Property _SLS_LocsRiften Auto
Formlist Property _SLS_LicExceptionsWeapon Auto
Formlist Property _SLS_LicExceptionsArmor Auto
Formlist Property _SLS_CumHasLactacidVoices Auto
Formlist Property _SLS_StaticMapList Auto
Formlist Property _SLS_ActivatableMapList Auto
Formlist Property _SLS_EscortsVanilla Auto
Formlist Property _SLS_EscortsBaseList Auto
Formlist Property _SLS_CumLactacidVoicesList Auto

GlobalVariable Property _SLS_TollCost Auto
GlobalVariable Property _SLS_TollFollowersRequired Auto
GlobalVariable Property _SLS_KennelCellCost Auto
GlobalVariable Property _SLS_LicCostShort Auto
GlobalVariable Property _SLS_LicCostLong Auto
GlobalVariable Property _SLS_LicCostPer Auto
GlobalVariable Property _SLS_BeggingDialogT Auto
GlobalVariable Property _SLS_TollDodgeHuntRadius Auto
GlobalVariable Property _SLS_TollDodgeHuntRadiusTown Auto
GlobalVariable Property _SLS_RestrictTradeBribe Auto
GlobalVariable Property _SLS_PickPocketFailStealValue Auto
GlobalVariable Property _SLS_BegSelfDegradationEnable Auto
GlobalVariable Property _SLS_ResponsiveEnforcers Auto
GlobalVariable Property _SLS_KennelExtraDevices Auto
GlobalVariable Property _SLS_AmpPriestHealCost Auto
GlobalVariable Property _SLS_BikiniExpReflexes Auto
GlobalVariable Property _SLS_BikiniExpLevel Auto
GlobalVariable Property _SLS_GuardBehavShoutEn Auto
GlobalVariable Property _SLS_GuardBehavWeapDropEn Auto
GlobalVariable Property _SLS_ProxSpankRequiredCover Auto
GlobalVariable Property _SLS_CumAddictionPool Auto
GlobalVariable Property _SLS_CumAddictionHunger Auto
GlobalVariable Property _SLS_CumHunger0 Auto ; < Satisfied
GlobalVariable Property _SLS_CumHunger1 Auto ; < Peckish
GlobalVariable Property _SLS_CumHunger2 Auto ; < Hungry
GlobalVariable Property _SLS_CumHunger3 Auto ; < Starving, >= Ravenous
GlobalVariable Property _SLS_CoveringNakedStatus Auto
GlobalVariable Property _SLS_BodyCoverStatus Auto
GlobalVariable Property _SLS_LicUnlockCost Auto
GlobalVariable Property _SLS_LicInspPersistence Auto
GlobalVariable Property _SLS_MapAndCompassRecipeEnable Auto

GlobalVariable Property _SLS_IneqCarry Auto
GlobalVariable Property _SLS_IneqDamage Auto
GlobalVariable Property _SLS_IneqDestruction Auto
GlobalVariable Property _SLS_IneqSpeed Auto
GlobalVariable Property _SLS_IneqStat Auto
GlobalVariable Property _SLS_IneqDebuffPlusCushion Auto

GlobalVariable Property HorseCost Auto

MiscObject Property Gold001 Auto

Message Property _SLS_TradeRestrictSetMerchant Auto
Message Property _SLS_GetLocationJurisdiction Auto
Message Property _SLS_AddEscortsMsg Auto

ReferenceAlias Property _SLS_TollGateWhiterunInside Auto
ReferenceAlias Property _SLS_TollGateSolitudeInside Auto
ReferenceAlias Property _SLS_TollGateRiftenMainInside Auto
ReferenceAlias Property _SLS_TollGateWindhelmInterior Auto
ReferenceAlias Property _SLS_TollGateMarkarthInterior Auto

Location Property _SLS_KennelWhiterunLocation Auto

Keyword Property SexlabNoStrip Auto

LeveledItem Property _SLS_PpLootRootList Auto
LeveledItem Property _SLS_PpGoldRoot Auto
LeveledItem Property _SLS_PpLootEmptyList Auto

LeveledItem Property _SLS_PpLootFoodList Auto
LeveledItem Property _SLS_PpLootGemsList Auto
LeveledItem Property _SLS_PpLootSoulgemsList Auto
LeveledItem Property _SLS_PpLootJewelryList Auto
LeveledItem Property _SLS_PpLootEnchJewelryList Auto
LeveledItem Property _SLS_PpLootPotionsList Auto
LeveledItem Property _SLS_PpLootKeysList Auto
LeveledItem Property _SLS_PpLootTomesList Auto
Potion Property CureDisease Auto

LeveledItem Property _SLS_PpGoldLow Auto
LeveledItem Property _SLS_PpGoldModerate Auto
LeveledItem Property _SLS_PpGoldHigh Auto

LeveledItem Property _SLS_BikiniArmorsListHide Auto
LeveledItem Property _SLS_BikiniArmorsListLeather Auto
LeveledItem Property _SLS_BikiniArmorsListIron Auto
LeveledItem Property _SLS_BikiniArmorsListSteel Auto
LeveledItem Property _SLS_BikiniArmorsListSteelPlate Auto
LeveledItem Property _SLS_BikiniArmorsListDwarven Auto
LeveledItem Property _SLS_BikiniArmorsListFalmer Auto
LeveledItem Property _SLS_BikiniArmorsListWolf Auto
LeveledItem Property _SLS_BikiniArmorsListBlades Auto
LeveledItem Property _SLS_BikiniArmorsListEbony Auto
LeveledItem Property _SLS_BikiniArmorsListDragonbone Auto

LeveledItem Property _SLS_BikiniArmorsEntryPointChest Auto
LeveledItem Property _SLS_BikiniArmorsEntryPointChestOrnate Auto
LeveledItem Property _SLS_BikiniArmorsEntryPointVendorCity Auto
LeveledItem Property _SLS_BikiniArmorsEntryPointVendorTown Auto
LeveledItem Property _SLS_BikiniArmorsEntryPointVendorKhajiit Auto

LeveledItem Property _SLS_BikiniArmorsList Auto

Form Property BikiniCurseTriggerArmor Auto Hidden

;/
VoiceType Property CrBearVoice Auto
VoiceType Property CrChaurusVoice Auto
VoiceType Property CrDeerVoice Auto
VoiceType Property CrDogVoice Auto
VoiceType Property CrDragonPriestVoice Auto
VoiceType Property CrDragonVoice Auto
VoiceType Property CrDraugrVoice Auto
VoiceType Property CrDremoraVoice Auto
VoiceType Property CrDwarvenCenturionVoice Auto
VoiceType Property CrDwarvenSphereVoice Auto
VoiceType Property CrDwarvenSpiderVoice Auto
VoiceType Property CrFalmerVoice Auto
VoiceType Property CrFoxVoice Auto
VoiceType Property CrFrostbiteSpiderGiantVoice Auto
VoiceType Property CrFrostbiteSpiderVoice Auto
VoiceType Property CrGiantVoice Auto
VoiceType Property CrGoatVoice Auto
VoiceType Property CrHorkerVoice Auto
VoiceType Property CrHorseVoice Auto
VoiceType Property CrMammothVoice Auto
VoiceType Property CrSabreCatVoice Auto
VoiceType Property CrSkeeverVoice Auto
VoiceType Property CrSprigganVoice Auto
VoiceType Property CrTrollVoice Auto
VoiceType Property CrWerewolfVoice Auto
VoiceType Property CrWolfVoice Auto
/;
SLS_Init Property Init Auto
SLS_Main Property Main Auto
SLS_MinAv Property MinAv Auto
SLS_Utility Property Util Auto
SLS_GluttonyInflationScript Property Gluttony Auto
_SLS_Needs Property Needs Auto
_SLS_LicenceUtil Property LicUtil Auto
_SLS_MapAndCompassAlias Property Compass Auto
_SLS_HalfNakedCover Property HalfNakedCover Auto
_SLS_DeviousEffects Property DeviousEffects Auto
_SLS_TollDodgeDisguise Property DodgeDisguise Auto
_SLS_TollDodge Property TollDodge Auto
_SLS_AnimalFriend Property AnimalFriend Auto
_SLS_Amputation Property Amputation Auto
_SLS_BikiniExpTraining Property BikiniExp Auto
_SLS_LicBikiniCurse Property BikiniCurse Auto
SLS_EvictionTrack Property Eviction Auto
_SLS_LicenceBuyBlocker Property LicBuyBlocker Auto
_SLS_DeviousEffectsGagTrade Property GagTrade Auto
_SLS_CumAddict Property CumAddict Auto
_SLS_CoverMyself Property CoverMyself Auto
_SLS_CumSwallow Property CumSwallow Auto
SLS_StashTrackPlayer Property StashTrack Auto
_SLS_MapAndCompassAlias Property MapAndCompass Auto
_SLS_AllInOneKey Property AllInOne Auto
_SLS_ForcedDrugging Property ForceDrug Auto
_SLS_FashionRape Property FashionRape Auto
_SLS_TollUtil Property TollUtil Auto
_SLS_LocTrackCentral Property LocTrack Auto
_SLS_Trauma Property Trauma Auto

_SLS_InterfaceRnd Property Rnd Auto
_SLS_InterfaceIneed Property Ineed Auto
_SLS_InterfaceFrostfall Property Frostfall Auto
_SLS_InterfaceSlaverun Property Slaverun Auto
_SLS_InterfacePaySexCrime Property Psc Auto
_SLS_InterfaceDevious Property Devious Auto
_SLS_InterfaceEff Property Eff Auto
_SLS_InterfaceSgo Property Sgo Auto
_SLS_InterfaceFhu Property Fhu Auto
_SLS_InterfaceAmputation Property Amp Auto
_SLS_InterfaceAproposTwo Property AproposTwo Auto
_SLS_InterfaceSlavetats Property Tats Auto
_SLS_InterfaceMilkAddict Property MilkAddict Auto
_SLS_InterfaceSlax Property Sla Auto
_SLS_InterfaceDeviousFollowers Property Dflow Auto
_SLS_InterfaceSlsf Property Slsf Auto
_SLS_InterfaceSlso Property Slso Auto
_SLS_InterfaceEatSleepDrink Property EatSleepDrink Auto
_SLS_InterfaceSpankThatAss Property Sta Auto
_SLS_InterfaceBis Property Bis Auto
_SLS_InterfaceSexyMove Property SexyMove Auto

CWScript Property Cw Auto
