Scriptname _SLS_CumAddict extends Quest  

; _SLS_CumAddictionPool:
; 0 - 100	: Cum averse
; 100 - 200	: Cum tolerant
; 200 - 300	: Cum addict
; 300 - 400	: Cum dump
; 400+		: Cum junkie

; _SLS_CumAddictionHunger:
; 0 - 0.5		: Satisfied
; 0.5 - 1.3		: Peckish
; 1.3 - 2.0		: Hungry
; 2.6 - 3.1	: Starving
; 3.1+ 		: Ravenous

; _SLS_CumAddictionHunger + Encourage Beastiality + Level 4 cum addiction:
; 0 - 2.0		: Satisfied
; 2.0 - 5.2		: Peckish
; 5.2 - 8.0		: Hungry
; 8.0 - 12.4	: Starving
; 12.4+ 		: Ravenous

Event OnInit()
	HungerStateStrings = new String[5]
	HungerStateStrings[0] = "satisfied"
	HungerStateStrings[1] = "peckish"
	HungerStateStrings[2] = "hungry"
	HungerStateStrings[3] = "starving"
	HungerStateStrings[4] = "ravenous"
	
	AddictionStateStrings = New String[5]
	AddictionStateStrings[0] = "unaffected"
	AddictionStateStrings[1] = "cum tolerant"
	AddictionStateStrings[2] = "cum addict"
	AddictionStateStrings[3] = "cum dump"
	AddictionStateStrings[4] = "cum junkie"
	
	_SLS_CumAddictionPool.SetValue(0.0)
	_SLS_CumAddictionHunger.SetValue(0.0)
	
	LastUpdateTime = Utility.GetCurrentGameTime()
	LastAddictionState =  GetAddictionState()
	
	LoadNewHungerThresholds()
	PlayerRef.AddSpell(_SLS_CumAddictStatusSpell, false)
	Utility.Wait(0.1)
	PlayerRef.AddSpell(_SLS_CumAddictHungerSpell, false)
	RegForEvents()
	RegisterForSingleUpdateGameTime(1.0)
	;SetNotifyKey(Menu.CumAddictKey)
EndEvent

Function RegForEvents()
	UnRegisterForAllModEvents()
	RegisterForModEvent("_SLS_PlayerSwallowedCum", "On_SLS_PlayerSwallowedCum")
	RegisterForModEvent("HookAnimationStarting", "OnAnimationStarting")
	RegisterForModEvent("HookAnimationStart", "OnAnimationStart")
	RegisterForModEvent("HookAnimationEnd", "OnAnimationEnd")
EndFunction

Function LoadGameMaintenance()
	If IsDaydreaming
		MushroomSwap(DoCocks = true)
		If StorageUtil.GetIntValue(Menu, "CumAddictDayDreamButterflys", Missing = 1) == 1
			;Debug.Messagebox("HIHI")
			ButterflySwap(DoSexy = true)
		EndIf
	Else
		MushroomSwap(DoCocks = false)
		ButterflySwap(DoSexy = false)
	EndIf
EndFunction

Event OnAnimationStarting(int tid, bool HasPlayer)
	If HasPlayer
		CumCountOnAnimStart = Sexlab.CountCum(PlayerRef)
	EndIf
EndEvent

Event OnAnimationStart(int tid, bool HasPlayer)
	If HasPlayer && SexStartMsg != ""
		Utility.Wait(1.0)
		Debug.Notification(SexStartMsg)
		SexStartMsg = ""
	EndIf
EndEvent

Event OnAnimationEnd(int tid, bool HasPlayer)
	If HasPlayer && Menu.CumAddictBatheRefuseTime > 0.0
		If Sexlab.CountCum(PlayerRef) > CumCountOnAnimStart ; Player took a fresh load
			If GetHungerState() >= 2 ; Player is hungry
				_SLS_CumAddictBathingTimerQuest.Stop()
				_SLS_CumAddictBathingTimerQuest.Start()
			EndIf
		EndIf
	EndIf
EndEvent

;/
Function SetNotifyKey(Int KeyCode)
	UnRegisterForKey(Menu.CumAddictKey)
	RegisterForKey(KeyCode)
	Menu.CumAddictKey = KeyCode
EndFunction
/;

Event OnKeyDown(Int KeyCode)
	If !Utility.IsInMenuMode() && _SLS_CumAddictionPool.GetValue() >= 100.0
		DoKeyDownNotify()
	EndIf
EndEvent

Event OnUpdateGameTime()
	;Debug.Messagebox("Update game time. Hours Passed: " + ((Utility.GetCurrentGameTime() - LastUpdateTime) * 24.0))
	DoUpdate()
	;LastUpdateTime = Utility.GetCurrentGameTime()
EndEvent

Function DoUpdate()
	Float HoursPassed = ((Utility.GetCurrentGameTime() - LastUpdateTime) * 24.0)
	AddictionUpdate(HoursPassed)
	Int HungerStateOld = GetHungerState()
	Int AddictLevel = GetAddictionState()
	Int AddictLevelAdjusted = AddictLevel - 1
	If AddictLevelAdjusted == -1
		AddictLevelAdjusted = 0
	EndIf

	If AddictLevel > 0
		ClampHunger(_SLS_CumAddictionHunger.GetValue() + (HoursPassed * (Menu.CumAddictionHungerRate + ((Menu.CumAddictBeastLevels as Float) * (AddictLevelAdjusted * Menu.CumAddictionHungerRate)))))
		DoHungerNotification(HungerStateOld, GetHungerState())
	Else
		ClampHunger(_SLS_CumAddictionHunger.GetValue() - 0.2)
	EndIf

	LastUpdateTime = Utility.GetCurrentGameTime()
	LastAddictionState = AddictLevel
	RegisterForSingleUpdateGameTime(1.0)
EndFunction

Event On_SLS_PlayerSwallowedCum(Form akSource, Bool DidSwallow, Float CumAmount, Float LoadSizeBase)
	SwallowedCum(akSource, DidSwallow, CumAmount)
	Int AddictionStateNew = GetAddictionState()
	DoAddictionStateChangeNotif(LastAddictionState, AddictionStateNew)
	LastAddictionState = AddictionStateNew
EndEvent

Function AddictionUpdate(Float HoursPassed)
	Float SkinCumAddiction = ProcSkinCumAddiction(DoProc = true, HoursPassed = HoursPassed) ; ProcSkinCumAddiction() adds addiction itself
	Float AnalCumAddiction = ProcAnalCumAddiction(DoProc = true, HoursPassed = HoursPassed) ; Adds addiction
	Float VagCumAddiction = ProcVagCumAddiction(DoProc = true, HoursPassed = HoursPassed) ; Adds addiction
	If (SkinCumAddiction + AnalCumAddiction + VagCumAddiction == 0.0) || !CumBlocksAddictionDecay ; Decay addiction
		ClampAddiction(_SLS_CumAddictionPool.GetValue() - (HoursPassed * Menu.CumAddictionDecayPerHour * Menu.CumAddictionSpeed))
	EndIf
	Int NewAddictionState = GetAddictionState()
	DoAddictionStateChangeNotif(LastAddictionState, NewAddictionState)
	LastAddictionState = NewAddictionState
EndFunction

Int Function GetHungerState()
	Float Hunger = _SLS_CumAddictionHunger.GetValue()
	If Hunger < _SLS_CumHunger0.GetValue() ; Satisfied - Default < 0.5
		Return 0
	ElseIf Hunger < _SLS_CumHunger1.GetValue() ; Peckish - Default < 1.3
		Return 1
	ElseIf Hunger < _SLS_CumHunger2.GetValue() ; Hungry - Default < 2.0
		Return 2
	ElseIf Hunger < _SLS_CumHunger3.GetValue() ; Starving - Default < 2.6
		Return 3
	Else ; Ravenous - Default >= 2.6
		Return 4
	EndIf
EndFunction

Function LoadNewHungerThresholds()
	Int AddictLevel = GetAddictionState() - 1 ; - 1: No additional effect at level 1 addiction
	If AddictLevel == -1
		AddictLevel = 0
	EndIf
	_SLS_CumHunger0.SetValue(StockSatisfied + ((Menu.CumAddictBeastLevels as Float) * (AddictLevel * StockSatisfied)))
	_SLS_CumHunger1.SetValue(StockPeckish + ((Menu.CumAddictBeastLevels as Float) * (AddictLevel * StockPeckish)))
	_SLS_CumHunger2.SetValue(StockHungry + ((Menu.CumAddictBeastLevels as Float) * (AddictLevel * StockHungry)))
	_SLS_CumHunger3.SetValue(StockStarving + ((Menu.CumAddictBeastLevels as Float) * (AddictLevel * StockStarving)))
EndFunction

Int Function GetAddictionState()
	Float Addiction = _SLS_CumAddictionPool.GetValue()
	If Addiction < 100.0 ; Unaffected
		Return 0
	ElseIf Addiction < 200.0 ; Tolerant
		Return 1
	ElseIf Addiction < 300.0 ; Addict
		Return 2
	ElseIf Addiction < 400.0 ; Dump
		Return 3
	Else ; Junkie
		Return 4
	EndIf
EndFunction

Function DoAddictionStateChangeNotif(Int AddictionOld, Int AddictionNew)
	If AddictionNew != AddictionOld
		LoadNewHungerThresholds()
		If AddictionNew > AddictionOld
			Debug.Notification("I've become more addicted to cum - " + AddictionStateStrings[AddictionNew])
		Else
			Debug.Notification("I've become less addicted to cum - " + AddictionStateStrings[AddictionNew])
		EndIf
	EndIf
EndFunction

Function SwallowedCum(Form akSource, Bool DidSwallow, Float CumAmount)
	Int HungerStateOld = GetHungerState()
	Float Hunger = _SLS_CumAddictionHunger.GetValue() - (CumAmount * Menu.CumSatiation)
	ClampHunger(Hunger)
	DoHungerNotification(HungerStateOld, GetHungerState())
	
	Float NewAddiction = _SLS_CumAddictionPool.GetValue() + (CumAmount * Menu.CumAddictionSpeed * 5.0)
	ClampAddiction(NewAddiction)
EndFunction

Function DoHungerNotification(Int HungerStateOld, Int HungerStateNew)
	If HungerStateNew != HungerStateOld
		SatiationLevelChange(HungerStateOld, HungerStateNew)
		Debug.Notification("Cum Hunger: I'm " + HungerStateStrings[HungerStateNew] + " now.")
	EndIf
EndFunction

Function SatiationLevelChange(Int HungerStateOld, Int HungerStateNew)
	If HungerStateNew < 2
		If _SLS_CumAddictBathingTimerQuest.IsRunning()
			_SLS_CumAddictBathingTimerQuest.Stop()
			Util.PermitBathing(PlayerRef)
		EndIf
	EndIf
	
	;Debug.Messagebox("Sate change: HungerStateNew: " + HungerStateNew + ". CumHungerAutoSuck: " + Menu.CumHungerAutoSuck + ". _SLS_CumAddictAutoSuckCooldownQuest.IsRunning(): " + _SLS_CumAddictAutoSuckCooldownQuest.IsRunning())
	If Init.SlsCreatureEvents && HungerStateNew >= Menu.CumHungerAutoSuck && !_SLS_CumAddictAutoSuckCooldownQuest.IsRunning()
		_SLS_CumAddictAutoSuckCreatureQuest.Start()
	Else
		_SLS_CumAddictAutoSuckCreatureQuest.Stop()
	EndIf
	
	CumDesperationEffects(HungerStateNew)
	Api.SendCumHungerChangeEvent(HungerStateNew)
EndFunction

Float Function ProcSkinCumAddiction(Bool DoProc = true, Float HoursPassed)
	; Gain addiction for every layer of cum on your body
	
	Float Addiction = Sexlab.CountCum(PlayerRef) * 1.0 * Menu.CumAddictionSpeed * HoursPassed
	If DoProc
		ClampAddiction(_SLS_CumAddictionPool.GetValue() + Addiction)
	EndIf
	Return Addiction
EndFunction

Float Function ProcAnalCumAddiction(Bool DoProc = true, Float HoursPassed)
	Float Addiction = Fhu.GetCurrentCumAnal(PlayerRef) * Menu.CumAddictionSpeed * HoursPassed
	If DoProc
		ClampAddiction(_SLS_CumAddictionPool.GetValue() + Addiction)
	EndIf
	Return Addiction
EndFunction

Float Function ProcVagCumAddiction(Bool DoProc = true, Float HoursPassed)
	Float Addiction = Fhu.GetCurrentCumVaginal(PlayerRef) * Menu.CumAddictionSpeed * HoursPassed
	If DoProc
		ClampAddiction(_SLS_CumAddictionPool.GetValue() + Addiction)
	EndIf
	Return Addiction
EndFunction

Function ClampAddiction(Float Addiction)
	Addiction = PapyrusUtil.ClampFloat(Addiction, 0.0, 550.0)
	_SLS_CumAddictionPool.SetValue(Addiction)
EndFunction

Function ClampHunger(Float Hunger)
	Hunger = PapyrusUtil.ClampFloat(Hunger, 0.0, GetMaxHunger())
	_SLS_CumAddictionHunger.SetValue(Hunger)
EndFunction

Float Function GetMaxHunger()
	Int AddictLevel = GetAddictionState()
	Int AddictLevelAdjusted = AddictLevel - 1
	If AddictLevelAdjusted == -1
		AddictLevelAdjusted = 0
	EndIf
	If Menu.CumAddictClampHunger
		If AddictLevel == 1 ; Cum tolerant
			Return (StockPeckish + (AddictLevelAdjusted * StockPeckish)) - 0.01
		ElseIf AddictLevel == 2 ; Cum addict
			Return (StockHungry + (AddictLevelAdjusted * StockHungry)) - 0.01
		ElseIf AddictLevel == 3 ; Cum dump
			Return (StockStarving + (AddictLevelAdjusted * StockStarving)) - 0.01
		ElseIf AddictLevel == 4 ; Cum junkie
			Return	(StockHungerMax + (AddictLevelAdjusted * StockHungerMax))
		EndIf
		Return (StockSatisfied + (AddictLevelAdjusted * StockSatisfied)) - 0.01 ; Unaffected
	
	Else
		If Menu.CumAddictBeastLevels
			Return StockHungerMax + (AddictLevelAdjusted * StockHungerMax)
		Else
			Return StockHungerMax
		EndIf
	EndIf
EndFunction

String Function GetCurrentAddictionString()
	Return AddictionStateStrings[GetAddictionState()]
EndFunction

String Function GetCurrentHungerString()
	Return HungerStateStrings[GetHungerState()]
EndFunction

Function DoKeyDownNotify()
	Debug.Notification(GetStatusMessage())
EndFunction

String Function GetStatusMessage()
	Return ("Cum Addict: " + AddictionStateStrings[GetAddictionState()] + ". Hunger: " + HungerStateStrings[GetHungerState()])
EndFunction

Bool Function IsReflexCumSwallow()
	; higher chance to auto swallow the higher addiction or hunger is
	
	If (GetAddictionState() as Float / 4.0) > Utility.RandomFloat(0.0, 1.0) || (GetHungerState() as Float / 4.0) * Menu.CumAddictReflexSwallow > Utility.RandomFloat(0.0, 1.0)
		Return true
	EndIf
	Return false
EndFunction

Function AutoSuck(Actor akTarget)
	If Init.SlsCreatureEvents
		;Float Arousal = StorageUtil.GetFloatValue(akTarget, "SLAroused.ActorExposure")
		Float Arousal = akTarget.GetFactionRank(Game.GetFormFromFile(0x03FC36, "SexLabAroused.esm") as Faction)
		sslBaseAnimation[] AnimsOral = Sexlab.GetCreatureAnimationsByRaceTags(2, akTarget.GetLeveledActorBase().GetRace(), "Blowjob,Oral", TagSuppress = "Cunnilingus", RequireAll = false)
		;Debug.Messagebox(akTarget.GetLeveledActorBase().GetRace())
		If AnimsOral.Length > 0 && Arousal > Menu.CumAddictAutoSuckCreatureArousal && Util.GetLoadFullnessMod(akTarget) > 0.7
			If (GetHungerState() / 4.0) * Menu.CumAddictAutoSuckCreature >= Utility.RandomFloat(0.0, 1.0)
				If Devious.CanDoOral(PlayerRef) 
					;Debug.Notification("Mmm, look at that lovely fat cock... Maybe just a little taste")
					Actor[] SexActors = new Actor[2]
					SexActors[0] = PlayerRef
					SexActors[1] = akTarget
					If AutoSuckVictim
						Sexlab.StartSex(SexActors, AnimsOral, Victim = PlayerRef, CenterOn = none, AllowBed = false)
					Else
						Sexlab.StartSex(SexActors, AnimsOral, Victim = none, CenterOn = none, AllowBed = false)
					EndIf
					Debug.Trace("_SLS_: CumAddict Auto Suck: Sucky start - Target: " + akTarget + ". Arousal: " + Arousal + ". AnimCount: " + AnimsOral.Length)
					SexStartMsg = "Mmm, look at that lovely fat cock... Maybe just a little taste"
					_SLS_CumAddictAutoSuckCooldownQuest.Start()
				
				Else
					Debug.Notification("Damn! If I hadn't got this stupid gag in my mouth I'd suck those balls dry!")
				EndIf
			Else
				Debug.Notification("Mmm, look at that lovely fat cock... But I better not")
			EndIf
		Else
			Debug.Trace("_SLS_: CumAddict Auto Suck: Event but no sucky - Target: " + akTarget + ". Arousal: " + Arousal + ". AnimCount: " + AnimsOral.Length)
		EndIf
	EndIf
EndFunction

Function SetAutoSuckBeginStage()
	If GetHungerState() >= Menu.CumHungerAutoSuck
		If !_SLS_CumAddictAutoSuckCooldownQuest.IsRunning()
			_SLS_CumAddictAutoSuckCreatureQuest.Start()
		EndIf
	Else
		_SLS_CumAddictAutoSuckCreatureQuest.Stop()
	EndIf
EndFunction

Function CumDesperationEffects(Int HungerState)
	If StorageUtil.GetIntValue(Menu, "CumAddictDayDream", Missing = 1) == 1
		If HungerState >= 2 ; Hungry or worse
			If !IsDaydreaming
				IsDaydreaming = true
				MushroomSwap(DoCocks = true)
				If StorageUtil.GetIntValue(Menu, "CumAddictDayDreamButterflys", Missing = 1)
					ButterflySwap(DoSexy = true)
				EndIf
				_SLS_CumDesperationEffectsQuest.Start()
				Cf.SetArousalThreshold(-2)
			EndIf
		Else
			If IsDaydreaming
				IsDaydreaming = false
				MushroomSwap(DoCocks = false)
				If StorageUtil.GetIntValue(Menu, "CumAddictDayDreamButterflys", Missing = 1)
					ButterflySwap(DoSexy = false)
				EndIf
				_SLS_CumDesperationEffectsQuest.Stop()
				Cf.ResetArousalThreshold()
			EndIf	
		EndIf
	EndIf
EndFunction

Function MushroomSwap(Bool DoCocks)
	;Debug.Messagebox("DoCocks: " + DoCocks)
	String TexPathPrefix = ""
	If DoCocks
		TexPathPrefix = "SL Survival/Aradia/"
	EndIf
	If (Game.GetFormFromFile(0xE1FB2, "Skyrim.esm")).GetWorldModelPath() != TexPathPrefix + "plants/floranirnroot01.nif"
		(Game.GetFormFromFile(0xE1FB2, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floranirnroot01.nif") ; TreeFloraNirnroot01
		(Game.GetFormFromFile(0xB6FB9, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floranirnroot01red.nif") ; TreeFloraNirnrootRed01
		(Game.GetFormFromFile(0x4D9FF, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom01.nif") ; FloraMushroom01
		(Game.GetFormFromFile(0x4DA03, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom01small.nif") ; FloraMushroom01Small
		(Game.GetFormFromFile(0x4DA04, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom02.nif") ; FloraMushroom02
		(Game.GetFormFromFile(0x4DA05, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom02small.nif") ; FloraMushroom02Small
		(Game.GetFormFromFile(0x4DA06, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom03.nif") ; FloraMushroom03
		(Game.GetFormFromFile(0x4DA07, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom03small.nif") ; FloraMushroom03Small
		(Game.GetFormFromFile(0xECA59, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom03.nif") ; FloraMushroom03ReachDirt01 (White Cap - Fairy ring)
		(Game.GetFormFromFile(0x4DA08, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom04.nif") ; FloraMushroom04
		(Game.GetFormFromFile(0x4DA09, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom04small.nif") ; FloraMushroom04Small
		(Game.GetFormFromFile(0x4DA0A, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom05.nif") ; FloraMushroom05
		(Game.GetFormFromFile(0x4DA0B, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom05small.nif") ; FloraMushroom05Small
		(Game.GetFormFromFile(0x4DA0C, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom06.nif") ; FloraMushroom06
		(Game.GetFormFromFile(0x4DA1F, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/floramushroom06small.nif") ; FloraMushroom06Small
		(Game.GetFormFromFile(0x7EE00, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/glowingmushroomcluster01.nif") ; GlowingMushroomCluster
		(Game.GetFormFromFile(0x9748B, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/glowingmushroomsingle01.nif") ; GlowingMushroomSingle
		
		; Ingredients
		(Game.GetFormFromFile(0x59B86, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/nirnroot01.nif") ; Nirnroot
		(Game.GetFormFromFile(0xB701A, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/nirnroot01red.nif") ; NirnrootRed
		(Game.GetFormFromFile(0x4DA00, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/mushroom01.nif") ; Mushroom01
		(Game.GetFormFromFile(0x4DA20, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/mushroom02.nif") ; Mushroom02
		(Game.GetFormFromFile(0x4DA22, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/mushroom03.nif") ; Mushroom03
		(Game.GetFormFromFile(0x4DA23, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/mushroom04.nif") ; Mushroom04
		(Game.GetFormFromFile(0x4DA24, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/mushroom05.nif") ; Mushroom05
		(Game.GetFormFromFile(0x4DA25, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/mushroom06.nif") ; Mushroom06
		(Game.GetFormFromFile(0x7EE01, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "plants/glowingmushroom01.nif") ; GlowingMushroom
		
		_SLS_CumDesperationMushroomRefreshQuest.Stop()
		_SLS_CumDesperationMushroomRefreshQuest.Start()
	EndIf
EndFunction

Function ButterflySwap(Bool DoSexy)
	;Debug.Messagebox("DoSexy: " + DoSexy)
	String TexPathPrefix = ""
	If DoSexy
		TexPathPrefix = "SL Survival/MyBugs/"
	EndIf
	If (Game.GetFormFromFile(0xB97AF, "Skyrim.esm")).GetWorldModelPath() != TexPathPrefix + "Critters/Moths/CritterMothMonarch.nif"
		; Critters
		(Game.GetFormFromFile(0xB97AF, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "Critters/Moths/CritterMothMonarch.nif") ; CritterMothMonarch
		(Game.GetFormFromFile(0x22219, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "Critters/Moths/CritterMothBlue.nif") ; CritterMothBlue
		(Game.GetFormFromFile(0x2221E, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "Critters/Moths/CritterMothGreen.nif") ; CritterMothLuna
		
		; Ingredients
		(Game.GetFormFromFile(0x727E0, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "Clutter/Ingredients/MothWing02Monarch.nif") ; MothWingMonarch
		(Game.GetFormFromFile(0x727DF, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "Clutter/Ingredients/MothWing01.nif") ; MothWingLuna
		(Game.GetFormFromFile(0x727DE, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "Clutter/Ingredients/MothWing03Blue.nif") ; MothWingBlue

		; Jars
		(Game.GetFormFromFile(0xFBC3D, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "Critters/Moths/MothLunarInJar.nif") ; dunUniqueMothInJar
		(Game.GetFormFromFile(0xFBC3C, "Skyrim.esm")).SetWorldModelPath(TexPathPrefix + "Critters/Moths/MothMonarchInJar.nif") ; dunUniqueButterflyInJar
		
		_SLS_CumDesperationButterflyRefreshQuest.Stop()
		_SLS_CumDesperationButterflyRefreshQuest.Start()
	EndIf
EndFunction

Function ToggleButterflys(Bool ToggleOn)
	If ToggleOn && IsDaydreaming
		ButterflySwap(DoSexy = true)
	Else
		ButterflySwap(DoSexy = false)
	EndIf
EndFunction

Function ToggleDaydreaming(Bool ToggleOn)
	If ToggleOn
		If GetHungerState() >= 2
			IsDaydreaming = true
			MushroomSwap(DoCocks = true)
			If StorageUtil.GetIntValue(Menu, "CumAddictDayDreamButterflys", Missing = 1)
				ButterflySwap(DoSexy = true)
			EndIf
			_SLS_CumDesperationEffectsQuest.Start()
			Cf.SetArousalThreshold(-2)
		Else
			IsDaydreaming = false
			MushroomSwap(DoCocks = false)
			If StorageUtil.GetIntValue(Menu, "CumAddictDayDreamButterflys", Missing = 1)
				ButterflySwap(DoSexy = false)
			EndIf
			_SLS_CumDesperationEffectsQuest.Stop()
			Cf.ResetArousalThreshold()
		EndIf
	Else
		IsDaydreaming = false
		MushroomSwap(DoCocks = false)
		If StorageUtil.GetIntValue(Menu, "CumAddictDayDreamButterflys", Missing = 1)
			ButterflySwap(DoSexy = false)
		EndIf
		_SLS_CumDesperationEffectsQuest.Stop()
		Cf.ResetArousalThreshold()
	EndIf
EndFunction

String[] HungerStateStrings
String[] AddictionStateStrings

Float LastUpdateTime
Float StockSatisfied = 0.5
Float StockPeckish = 1.3
Float StockHungry = 2.0
Float StockStarving = 2.6
Float StockHungerMax = 3.1

Int LastAddictionState
Int CumCountOnAnimStart

String SexStartMsg

Bool Property CumBlocksAddictionDecay = true Auto Hidden
Bool Property IsDaydreaming = false Auto Hidden
Bool Property AutoSuckVictim = true Auto Hidden

GlobalVariable Property _SLS_CumAddictionPool Auto
GlobalVariable Property _SLS_CumAddictionHunger Auto
GlobalVariable Property _SLS_CumHunger0 Auto ; < Satisfied
GlobalVariable Property _SLS_CumHunger1 Auto ; < Peckish
GlobalVariable Property _SLS_CumHunger2 Auto ; < Hungry
GlobalVariable Property _SLS_CumHunger3 Auto ; < Starving, >= Ravenous

Spell Property _SLS_CumAddictHungerSpell Auto
Spell Property _SLS_CumAddictStatusSpell Auto

Actor Property PlayerRef Auto

Quest Property _SLS_CumAddictBathingTimerQuest Auto
Quest Property _SLS_CumAddictAutoSuckCreatureQuest Auto
Quest Property _SLS_CumAddictAutoSuckCooldownQuest Auto
Quest Property _SLS_CumDesperationMushroomRefreshQuest Auto
Quest Property _SLS_CumDesperationButterflyRefreshQuest Auto
Quest Property _SLS_CumDesperationEffectsQuest Auto

SLS_Mcm Property Menu Auto
SexlabFramework Property Sexlab Auto

_SLS_InterfaceDevious Property Devious Auto
_SLS_InterfaceFhu Property Fhu Auto
_SLS_InterfaceCreatureFramework Property Cf Auto
_SLS_Api Property Api Auto
SLS_Utility Property Util Auto
SLS_Init Property Init Auto
