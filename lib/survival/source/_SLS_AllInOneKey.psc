Scriptname _SLS_AllInOneKey extends Quest

Event OnInit()
	PlayerIsNpcVar = PlayerRef.GetAnimationVariableInt("IsNPC")
	BuildScriptArrays()
	SetKey(AioKey)
EndEvent

Function SetKey(Int KeyCode)
	AioKey = KeyCode
	UnRegisterForAllKeys()
	If KeyCode > 0
		RegisterForKey(KeyCode)
	EndIf
EndFunction

Event OnKeyDown(Int KeyCode)
	If !Utility.IsInMenuMode() && !UI.IsMenuOpen("InventoryMenu") && !UI.IsMenuOpen("Crafting Menu") ; Because IsInMenuMode() only checks if time is paused - and the unpause mod fucks that.
		;(Game.GetFormFromFile(0x00F624, "Devious Devices - Integration.esm") as zadLibs).ActorOrgasm(PlayerRef)
		;PlayerRef.PlayIdle(Game.GetFormFromFile(0xCEFD0, "Skyrim.esm") as Idle)
		;Game.ShakeCamera(afStrength = 1.0, afDuration = 2.0)
		;PlayerRef.PlayIdle(Game.GetFormFromFile(0xCEFD1, "Skyrim.esm") as Idle)
		;Utility.Wait(5.0)
		;Orgasmfatigue.AdjustOrgasmCount(1.0)
		;Orgasmfatigue.SetFatigue()
		;(Game.GetFormFromFile(0x0F37A1, "SL Survival.esp") as _SLS_Trauma).AddRandomTrauma(PlayerRef)
		;Main.Sexlab.AddCum(Game.GetCurrentCrosshairRef() as Actor, Vaginal = false, Oral = true, Anal = false)
		MainMenu()
	EndIf
EndEvent

Event OnMenuClose(String MenuName)
	; Sleep On Ground
	StorageUtil.SetIntValue(PlayerRef, "_SLS_SleepingRough", 0)
	Debug.SendAnimationEvent(PlayerRef, "IdleBedExitStart")
	UnRegisterForMenu("Sleep/Wait Menu")
EndEvent

; Main Menu ===================================================================================================

Bool IsToggled = false
Function MainMenu()
	Int MenuSelect = ShowMainMenu()
	If MenuSelect == 0
		SelfMenu()
	ElseIf MenuSelect == 1
		ActionsMenu()
	ElseIf MenuSelect == 2
		SurvivalMenu()
	ElseIf MenuSelect == 3
		StatusMenu()
	ElseIf MenuSelect == 4
		IdleMenu()
	ElseIf MenuSelect == 5
		MiscMenu()
	ElseIf MenuSelect == 7
		LastAction()
	EndIf
EndFunction

Int Function ShowMainMenu()
	;Debug.Messagebox((Game.GetFormFromFile(0x0C4706, "SL Survival.esp") as _SLS_InterfaceCreatureFramework).GetArousalThreshold())

	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Self ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Actions ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Survival ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Status ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Idle ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Misc ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = "Free Town: " + (Game.GetFormFromFile(0x03F041, "SL Survival.esp") as _SLS_InterfaceSlaverun).IsFreeArea())

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Self ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Actions ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Survival ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Status ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Idle ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Misc ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = "Free Town: " + (Game.GetFormFromFile(0x03F041, "SL Survival.esp") as _SLS_InterfaceSlaverun).IsFreeArea())
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = true)
	;wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	
	If Self.GetState() != ""
		wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = GetLastActionString())
		wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = GetLastActionString())
		wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)
	EndIf

	Return wheelMenu.OpenMenu(PlayerRef)
EndFunction

; Self Menu ======================================================================================================

Function SelfMenu()
	Int MenuSelect = ShowSelfMenu()
	If MenuSelect == -1
		MainMenu()
	ElseIf MenuSelect == 1 ; Open/Close Mouth
		CumSwallow.OnKeyDown(0)
		GoToState("OpenCloseMouth")
	ElseIf MenuSelect == 0 ; Cover self
		CoverMyself.OnKeyDown(0)
		GoToState("CoverMyself")
	ElseIf MenuSelect == 2
		TongueMenu()
		GoToState("Tongue")
	ElseIf MenuSelect == 3
		BeginLookAt()
		GoToState("LookAt")
	ElseIf MenuSelect == 4
		ChangeStanceMenu()
	ElseIf MenuSelect == 5
		EmoteMenu()
		GoToState("Emote")
	ElseIf MenuSelect == 6 ; Play with myself
		;Debug.SendAnimationEvent(PlayerRef , "DDZazHornyB")
		If !PlayerRef.HasSpell(_SLS_TeaseMyselfSpell)
			PlayWithMyselfMenu()
		Else
			PlayerRef.RemoveSpell(_SLS_TeaseMyselfSpell)
			;Debug.SendAnimationEvent(PlayerRef, "OffsetStop")
			Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		EndIf
	ElseIf MenuSelect == 7
		DanceMenu()
		GoToState("Dance")
	EndIf
EndFunction

Int Function ShowSelfMenu()
	String MouthString = "Open Mouth"
	If sslBaseExpression.IsMouthOpen(PlayerRef)
		MouthString = "Close Mouth"
	EndIf
	String CoverString = "Cover Myself"
	If CoverMyself.GetState() == "Covered"
		CoverString = "Uncover Myself"
	EndIf
	String LookString = "Look At"
	If LookAtTarget
		LookString = "Stop Looking At"
	EndIf
	String PlayWithMyselfString = "Play With Myself"
	If PlayerRef.HasSpell(_SLS_TeaseMyselfSpell)
		PlayWithMyselfString = "Stop Playing"
	EndIf

	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	;UIExtensions.InitMenu("UIWheelMenu")	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = MouthString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = CoverString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Tongue ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = LookString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Change Stance")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Emote ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = PlayWithMyselfString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = "Dance ")

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = MouthString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = CoverString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Tongue ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = LookString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Change Stance")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Emote ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = PlayWithMyselfString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = "Dance ")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = !Devious.IsPlayerGagged())
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = _SLS_BodyCoverStatus.GetValueInt() == 0)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = Devious.CanDoOral(PlayerRef))
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)

	Return wheelMenu.OpenMenu()
EndFunction

Function EmoteMenu()
	Int MenuSelect = ShowEmoteMenu()
	If MenuSelect == -1
		SelfMenu()
	ElseIf MenuSelect == 0
		PlayerRef.ClearExpressionOverride()
		PlayerRef.SetExpressionOverride(7, 0)
	ElseIf MenuSelect >= 1 && MenuSelect <= 7
		;EmoteStrenthMenu(7 + MenuSelect)
		PlayerRef.SetExpressionOverride(7 + MenuSelect, 100)
	EndIf
EndFunction

Int Function ShowEmoteMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Clear ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Anger ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Fear ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Happy ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Sad ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Surprise ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = "Puzzled ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = "Disgusted ")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Clear ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Anger ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Fear ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Happy ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Sad ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Surprise ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = "Puzzled ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = "Disgusted ")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction
;/
Function EmoteStrenthMenu(Int Emote)
	Int MenuSelect = ShowEmoteStrengthMenu()
	If MenuSelect == -1
		EmoteMenu()
	ElseIf MenuSelect >= 0 && MenuSelect <= 4
		PlayerRef.SetExpressionOverride(Emote, 25 + (25 * MenuSelect))
	EndIf
EndFunction

Int Function ShowEmoteStrengthMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "25% ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "50% ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "75% ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "100% ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "100% ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Surprise ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = "Puzzled ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = "Disgusted ")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "25% ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "50% ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "75% ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "100% ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "100% ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Surprise ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = "Puzzled ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = "Disgusted ")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	;wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	;wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = true)
	;wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	;wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction
/;
; ZazCaptiveBoundKneeling_Enter - kneeling, hands behind back, fidgeting. Doesn't look

; ZazBellyDance_Enter

; ZazAPCYKNA1 - Kneel with arms in yoke
; ZazAPCYKNA2 - Same ^
; ZazAPCYKNB1 - Same ^

Function ChangeStanceMenu()
	Int MenuSelect = ShowChangeStanceMenu()
	If MenuSelect == -1
	
	ElseIf MenuSelect == 0
		ToggleCrawl()
		GoToState("Crawl")
	ElseIf MenuSelect == 1
		ToggleKneel()
		GoToState("Kneel")
	ElseIf MenuSelect == 2
		BendOverMenu()
		;Debug.SendAnimationEvent(PlayerRef , "SLS_BendOver")
	ElseIf MenuSelect == 3
		ChangeAnimationSetMenu()
		GoToState("SexyMove")
	EndIf
EndFunction

Function BendOverMenu()
	Int MenuSelect = ShowBendOverMenu()
	
	If MenuSelect == -1
		ChangeStanceMenu()
	ElseIf MenuSelect == 0
		Debug.SendAnimationEvent(PlayerRef , "SLS_BendOver_BendOver1")
		IsBendingOver = true
		StorageUtil.SetIntValue(None, "_STA_ForbidSpankStaggers", 1)
		Game.DisablePlayerControls(true, !Game.IsFightingControlsEnabled(), !Game.IsCamSwitchControlsEnabled(), !Game.IsLookingControlsEnabled(), !Game.IsSneakingControlsEnabled(), !Game.IsMenuControlsEnabled(), !Game.IsActivateControlsEnabled(), !Game.IsJournalControlsEnabled())
		_SLS_SpankRandomPeriodicQuest.Start()
		GoToState("BendOver")
	ElseIf MenuSelect == 1
		Debug.SendAnimationEvent(PlayerRef , "SLS_BendOver_GetUp1")
		IsBendingOver = false
		Game.EnablePlayerControls(true, Game.IsFightingControlsEnabled(), Game.IsCamSwitchControlsEnabled(), Game.IsLookingControlsEnabled(), Game.IsSneakingControlsEnabled(), Game.IsMenuControlsEnabled(), Game.IsActivateControlsEnabled(), Game.IsJournalControlsEnabled())
		_SLS_SpankRandomPeriodicQuest.Stop()
		StorageUtil.SetIntValue(None, "_STA_ForbidSpankStaggers", 0)
		GoToState("BendOver")
	ElseIf MenuSelect == 2
		Debug.SendAnimationEvent(PlayerRef , "SLS_BendOver_Twerk1")
		GoToState("BendOver")
	ElseIf MenuSelect == 3
		Debug.SendAnimationEvent(PlayerRef , "SLS_BendOver_OfferBj1")
		GoToState("BendOver")
	EndIf		
EndFunction

Int Function ShowBendOverMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Bend Over")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Get up")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Twerk")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Bj")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Bend Over")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Get up")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Twerk")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Bj")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = !IsBendingOver)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = IsBendingOver)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = IsBendingOver)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = IsBendingOver)
	
	Return wheelMenu.OpenMenu()
EndFunction

Int Function ShowChangeStanceMenu()
	String CrawlString = "Crawl "
	If IsCrawling
		CrawlString = "Stop Crawling"
	EndIf
	
	String KneelString = "Kneel "
	If Init.IsKneeling
		KneelString = "Stop Kneeling"
	EndIf

	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = CrawlString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = KneelString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Bend Over")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Sexy Move")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = CrawlString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = KneelString)
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Bend Over")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Sexy Move")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = !Init.IsKneeling)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = !IsCrawling)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = (!Init.IsKneeling && !IsCrawling))
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = (!Init.IsKneeling && !IsCrawling) && Game.GetModByName("FNISSexyMove.esp") != 255)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function ChangeAnimationSetMenu()
	Int MenuSelect = ShowChangeAnimationSetMenu()
	If MenuSelect == -1
		ShowSelfMenu()
	Else
		SexyMove.ChangeAnimationSet(MenuSelect, PlayerRef)
	EndIf

	;(Game.GetFormFromFile(0x0012C7, "FNISSexyMove.esp") as FNISSMConfigMenu).set_SMplayer(MenuSelect) ; Function call fails and causes log spam because the Mcm is expected to be open
EndFunction

Int Function ShowChangeAnimationSetMenu()
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	ListMenu.AddEntryItem("No Sexy Move: Default ")
	ListMenu.AddEntryItem("Sexy Move 1: Female Animation")
	ListMenu.AddEntryItem("Sexy Move 2: A Bit Sexy")
	Int i = 3
	While i < 9
		ListMenu.AddEntryItem("Sexy Move " + i)
		i += 1
	EndWhile
	ListMenu.AddEntryItem("Sexy Move 9: Very Sexy")
	ListMenu.OpenMenu()
	;Debug.Messagebox(ListMenu.GetResultInt())
	Return ListMenu.GetResultInt()
EndFunction

Function ToggleKneel()
	If Init.IsKneeling
		Game.EnablePlayerControls(true, true, Game.IsCamSwitchControlsEnabled(), Game.IsLookingControlsEnabled(), Game.IsSneakingControlsEnabled(), Game.IsMenuControlsEnabled(), Game.IsActivateControlsEnabled(), Game.IsJournalControlsEnabled())
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	Else
		Debug.SendAnimationEvent(PlayerRef , "ZazCaptiveBoundKneeling_Enter")
		Game.DisablePlayerControls(true, true, !Game.IsCamSwitchControlsEnabled(), !Game.IsLookingControlsEnabled(), !Game.IsSneakingControlsEnabled(), !Game.IsMenuControlsEnabled(), !Game.IsActivateControlsEnabled(), !Game.IsJournalControlsEnabled())
		RegisterForModEvent("HookAnimationEnd", "OnAnimationEnd")
	EndIf
	Init.IsKneeling = !Init.IsKneeling
EndFunction

Event OnAnimationEnd(int tid, bool HasPlayer)
	If HasPlayer
		; AnimationEnd restores player controls and makes standing
		Init.IsKneeling = false
		UnRegisterForModEvent("HookAnimationEnd")
	EndIf
EndEvent

Function PlayWithMyselfMenu()
	Int MenuSelect = ShowPlayWithMyselfMenu()
	If MenuSelect == -1 ; Back
		SelfMenu()
	ElseIf MenuSelect == 0 ; Tease
		;Debug.SendAnimationEvent(PlayerRef, HornyAnimsList[Utility.RandomInt(0, HornyAnimsList.Length - 1)])
		PlayerRef.AddSpell(_SLS_TeaseMyselfSpell, false)
		GoToState("Tease")
	ElseIf MenuSelect == 1 ; Masturbate
		Masturbate()
		GoToState("Masturbate")
	EndIf
EndFunction

Function Masturbate()
	sslBaseAnimation Anim = ShowMasturbationList()
	If Anim == None ; Back
		ShowPlayWithMyselfMenu()
	Else
		Main.Masturbate(PlayerRef, Anim)
	EndIf
EndFunction

sslBaseAnimation Function ShowMasturbationList()
	String AnimTags = "Solo"
	If PlayerRef.GetActorBase().GetSex() == 1
		AnimTags += ",F"
	Else
		AnimTags += ",M"
	EndIf
	String SuppressTags = ""
	sslBaseAnimation[] animations = Main.GetAnims(1, false, AnimTags, SuppressTags)

	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	ListMenu.AddEntryItem("Random ")
	Int i = 0
	While i < animations.Length
		ListMenu.AddEntryItem(animations[i].Name)
		i += 1
	EndWhile
	ListMenu.OpenMenu(PlayerRef)
	Int Result = ListMenu.GetResultInt()
	If Result == -1 ; Back
		Return None
	ElseIf Result == 0 ; Random
		Return animations[Utility.RandomInt(0, animations.Length - 1)]
	Else
		Return animations[Result - 1]
	EndIf
EndFunction

Int Function ShowPlayWithMyselfMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Tease ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Masturbate ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Tease & Masturbate")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Tease ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Masturbate ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Tease & Masturbate")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	;wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	Return wheelMenu.OpenMenu(PlayerRef)
EndFunction

Function DanceMenu()
	Int MenuSelect = ShowDanceMenu()
	If MenuSelect == -1
		SelfMenu()
	ElseIf MenuSelect == 0
		Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
	ElseIf MenuSelect == 1
		Debug.SendAnimationEvent(PlayerRef, DancesList[Utility.RandomInt(2, DancesList.Length - 1)])
	ElseIf MenuSelect > 1
		Debug.SendAnimationEvent(PlayerRef, DancesList[MenuSelect])
	EndIf
EndFunction

Int Function ShowDanceMenu()
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	Int i = 0
	While i < DancesList.Length
		ListMenu.AddEntryItem(DancesList[i])
		i += 1
	EndWhile
	ListMenu.OpenMenu()
	;Debug.Messagebox(ListMenu.GetResultInt())
	Return ListMenu.GetResultInt()
EndFunction

Function TongueMenu()
	Int MenuSelect = ShowTongueMenu()
	If MenuSelect == -1
		SelfMenu()
	ElseIf MenuSelect >= 0
		ToggleTongue(MenuSelect)
	EndIf
EndFunction

Int Function ShowTongueMenu()
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	TonguesList[0] = "Stick out tongue"
	If PlayerRef.WornHasKeyword(_SLS_TongueKeyword)
		TonguesList[0] = "Retract tongue"
	EndIf
	Int i = 0
	While i < TonguesList.Length
		ListMenu.AddEntryItem(TonguesList[i])
		i += 1
	EndWhile
	ListMenu.OpenMenu()
	;Debug.Messagebox(ListMenu.GetResultInt())
	Return ListMenu.GetResultInt()
EndFunction

Function ToggleCrawl()

	;/ ; SD way
	StorageUtil.SetStringValue(PlayerRef, "_SD_sDefaultStance", "Crawling")
	PlayerRef.SendModEvent("SLDRefreshGlobals")
	(Game.GetFormFromFile(0x000D64, "sanguinesDebauchery.esp") as _sdqs_fcts_constraints).CollarEffectStart(akTarget = PlayerRef, akCaster = PlayerRef)
	(Game.GetFormFromFile(0x000D64, "sanguinesDebauchery.esp") as _sdqs_fcts_constraints).UpdateStanceOverrides()
	/;
	
	If !IsCrawling
		; Amputator way
		String ModName = "Amputator"
		Int ModID = FNIS_aa.GetAAModID("amp", "Amputator",true)
		Int mtidle_base = FNIS_aa.GetGroupBaseValue(ModID, FNIS_aa._mtidle(), "Amputator", true)
		Int mt_base = FNIS_aa.GetGroupBaseValue(ModID, FNIS_aa._mt(), "Amputator", true)
		Int mtx_base = FNIS_aa.GetGroupBaseValue(ModID, FNIS_aa._mtx(), "Amputator", true)
		Int sprint_base = FNIS_aa.GetGroupBaseValue(ModID, FNIS_aa._sprint(), "Amputator", true)
		Int mtturn_base = FNIS_aa.GetGroupBaseValue(ModID, FNIS_aa._mtturn(), "Amputator", true)
		
		Int sneakidle_base = FNIS_aa.GetGroupBaseValue(ModID, FNIS_aa._sneakidle(), "Amputator", true)
		Int sneakmt_base = FNIS_aa.GetGroupBaseValue(ModID, FNIS_aa._sneakmt(), "Amputator", true)

		;Bool bOk
		FNIS_aa.SetAnimGroup(PlayerRef,"_mtidle", mtidle_base, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_mt", mt_base, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_mtx", mtx_base, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_sprint", sprint_base, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_mtturn", mtturn_base, 0, "Amputator", true)
		
		FNIS_aa.SetAnimGroup(PlayerRef,"_sneakidle", sneakidle_base, 0, Modname, true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_sneakmt", sneakmt_base, 0, Modname, true)
		
		; Game.SetGameSettingFloat("fJumpHeightMin", 10.0)
		IsCrawling = true
		PlayerRef.AddPerk(_SLS_CrawlingPerk)
		FightControlsWereEnabled = Game.IsFightingControlsEnabled()
		Game.DisablePlayerControls(!Game.IsMovementControlsEnabled(), true, !Game.IsCamSwitchControlsEnabled(), !Game.IsLookingControlsEnabled(), !Game.IsSneakingControlsEnabled(), !Game.IsMenuControlsEnabled(), !Game.IsActivateControlsEnabled(), !Game.IsJournalControlsEnabled())
		
		;Debug.Messagebox("ADD")
	
	Else
		FNIS_aa.SetAnimGroup(PlayerRef,"_mtidle", 0, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_mt", 0, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_mtx", 0, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_sprint", 0, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_mtturn", 0, 0, "Amputator", true)
		
		FNIS_aa.SetAnimGroup(PlayerRef,"_sneakidle", 0, 0, "Amputator", true)
		FNIS_aa.SetAnimGroup(PlayerRef,"_sneakmt", 0, 0, "Amputator", true)
		
		IsCrawling = false
		PlayerRef.RemovePerk(_SLS_CrawlingPerk)
		Game.EnablePlayerControls(Game.IsMovementControlsEnabled(), (FightControlsWereEnabled || Game.IsFightingControlsEnabled()), Game.IsCamSwitchControlsEnabled(), Game.IsLookingControlsEnabled(), Game.IsSneakingControlsEnabled(), Game.IsMenuControlsEnabled(), Game.IsActivateControlsEnabled(), Game.IsJournalControlsEnabled())
		;Debug.Messagebox("remove")
	EndIf
EndFunction

Function BeginLookAt(ObjectReference akTarget = None, Bool MoveMarker = true)
	If LookAtTarget && !akTarget
		ClearLookAtTarget()
	Else
		If !akTarget
			akTarget = ShowLookAtMenulist()
		EndIf
		;Debug.Messagebox("akTarget: " + akTarget)
		If !akTarget
			ShowSelfMenu()
		ElseIf akTarget == _SLS_LookAtMarkerRef
			RegisterForAnimationEvent(PlayerRef, "FootLeft")
			RegisterForAnimationEvent(PlayerRef, "FootRight")
			If MoveMarker
				_SLS_LookAtMarkerRef.MoveTo(PlayerRef, 100.0 * Math.Sin(PlayerRef.GetAngleZ()), 100.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 80.0)
			EndIf
			IsLookingSubmissively = true
		Else
			IsLookingSubmissively = false
		EndIf
		PlayerIsNpcVar = PlayerRef.GetAnimationVariableInt("IsNPC")
		;PlayerRef.ClearLookAt()
		PlayerRef.SetAnimationVariableInt("IsNPC", 1)
		PlayerRef.SetLookAt(akTarget)
		LookAtTarget = akTarget
	EndIf
EndFunction

Function ClearLookAtTarget(Int ForcePlayerIsNpcTo = -1)
	If ForcePlayerIsNpcTo > -1
		PlayerRef.SetAnimationVariableInt("IsNPC", ForcePlayerIsNpcTo)
	Else
		PlayerRef.SetAnimationVariableInt("IsNPC", PlayerIsNpcVar)
	EndIf
	PlayerRef.ClearLookAt()
	UnRegisterForAnimationEvent(PlayerRef, "FootLeft")
	UnRegisterForAnimationEvent(PlayerRef, "FootRight")
	LookAtTarget = None
	IsLookingSubmissively = false
EndFunction

Event OnAnimationEvent(ObjectReference aktarg, String EventName)
	_SLS_LookAtMarkerRef.MoveTo(PlayerRef, 100.0 * Math.Sin(PlayerRef.GetAngleZ()), 100.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 80.0)
	;Debug.Messagebox("Event")
EndEvent

ObjectReference Function ShowLookAtMenulist()
	_SLS_LookAtSearchQuest.Stop()
	_SLS_LookAtSearchQuest.Start()
	
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	ListMenu.AddEntryItem("Feet")
	Int i = 0
	Actor akTarget
	While i < _SLS_LookAtSearchQuest.GetNumAliases()
		akTarget = (_SLS_LookAtSearchQuest.GetNthAlias(i) as ReferenceAlias).GetReference() as Actor
		If akTarget
			ListMenu.AddEntryItem(akTarget.GetBaseObject().GetName())
		EndIf
		i += 1
	EndWhile
	ListMenu.OpenMenu()
	Int Result = ListMenu.GetResultInt()
	If Result == -1
		Return None
	ElseIf Result == 0 ; Feet
		Return _SLS_LookAtMarkerRef
	Else
		Return (_SLS_LookAtSearchQuest.GetNthAlias(Result - 1) as ReferenceAlias).GetReference() as ObjectReference
	EndIf
EndFunction

Function ToggleTongue(Int MenuSelect)
	If MenuSelect == 0 ; Stick out / retract
		If PlayerRef.WornHasKeyword(_SLS_TongueKeyword) ; Retract
			Form akTongue = PlayerRef.GetWornForm(TongueSlotMask) ; 0x00100000
			PlayerRef.UnequipItem(akTongue, abPreventEquip = false, abSilent = true)
			PlayerRef.RemoveItem(akTongue, 10, abSilent = true)
		Else ; Stick out
			Form akTongue = _SLS_TonguesList.GetAt(LastTongue)
			If akTongue && akTongue.HasKeyword(_SLS_TongueKeyword)
				If !sslBaseExpression.IsMouthOpen(PlayerRef)
					CumSwallow.OnKeyDown(0)
				EndIf
				PlayerRef.AddItem(akTongue, 1, abSilent = true)
				PlayerRef.EquipItem(akTongue, abSilent = true)
			EndIf
			If Game.GetCameraState() == 3
				Game.ForceThirdPerson() ; Tongue doesn't visually equip in freecam and QueueNiNodeUpdate closes the mouth again. Resort to bullshitery
			EndIf
		EndIf
		
	Else ; Select tongue
		Form akTongue
		If PlayerRef.WornHasKeyword(_SLS_TongueKeyword) ; Unequip old tongue
			akTongue = PlayerRef.GetWornForm(TongueSlotMask) ; 0x00100000
			If akTongue && akTongue.HasKeyword(_SLS_TongueKeyword)
				PlayerRef.UnequipItem(akTongue, abPreventEquip = false, abSilent = true)
				PlayerRef.RemoveItem(akTongue, 10, abSilent = true)
			EndIf
		EndIf
		
		If !sslBaseExpression.IsMouthOpen(PlayerRef)
			CumSwallow.OnKeyDown(0)
		EndIf
		akTongue = _SLS_TonguesList.GetAt(MenuSelect - 2)
		PlayerRef.AddItem(akTongue, 1, abSilent = true)
		PlayerRef.EquipItem(akTongue, abSilent = true)
		TongueSlotMask = (akTongue as Armor).GetSlotMask()
		If Game.GetCameraState() == 3
			Game.ForceThirdPerson() ; Tongue doesn't visually equip in freecam and QueueNiNodeUpdate closes the mouth again. Resort to bullshitery
		EndIf
		LastTongue = MenuSelect + 2
	EndIf

;/
	If PlayerRef.WornHasKeyword(_SLS_TongueKeyword)
		Form akTongue = PlayerRef.GetWornForm(0x00100000)
		If akTongue && akTongue.HasKeyword(_SLS_TongueKeyword)
			PlayerRef.UnequipItem(akTongue, abPreventEquip = false, abSilent = true)
			PlayerRef.RemoveItem(akTongue, 10, abSilent = true)
		EndIf
	Else
		Form akTongue
		If MenuSelect == -1
			akTongue = _SLS_TonguesList.GetAt(Utility.RandomInt(0, _SLS_TonguesList.GetSize() - 1))
		Else
			akTongue = _SLS_TonguesList.GetAt(MenuSelect)
		EndIf
		PlayerRef.AddItem(akTongue, 1, abSilent = false)
		PlayerRef.EquipItem(akTongue, abSilent = false)

		If Game.GetCameraState() == 3
			Game.ForceThirdPerson() ; Tongue doesn't visually equip in freecam and QueueNiNodeUpdate closes the mouth again. Resort to bullshitery
		EndIf
	EndIf
	/;
EndFunction

; Actions Menu ======================================================================================================

Function ActionsMenu()
	Int MenuSelect = ShowActionsMenu()
	If MenuSelect == -1
		MainMenu()
	ElseIf MenuSelect == 0
		OutfitMenu()
		GoToState("Outfits")
	ElseIf MenuSelect == 1
		MoreActionsMenu()
	ElseIf MenuSelect == 2
		ToggleAutoFuck()
		GoToState("AutoFuck")
	ElseIf MenuSelect == 3

	ElseIf MenuSelect == 4
		
	ElseIf MenuSelect == 5

	ElseIf MenuSelect == 6

	ElseIf MenuSelect == 7

	EndIf
EndFunction

Int Function ShowActionsMenu()
	String AutoFuckStr = "Start Fucking"
	If CompulsiveSex.IsFucking
		AutoFuckStr = "Stop Fucking"
	EndIf
	
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Outfits ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "More Actions")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = AutoFuckStr)

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Outfits ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "More Actions")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = AutoFuckStr)

	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = PlayerRef.IsInFaction(CompulsiveSex.SexlabAnimatingFaction))

	Return wheelMenu.OpenMenu()
EndFunction

Function MoreActionsMenu()
	Int MenuResult = ShowMoreActionsMenu()
	If MenuResult == -1
		ActionsMenu()
	ElseIf MenuResult == 0
		_SLS_ScreamForHelpSpell.Cast(PlayerRef, PlayerRef)
		GoToState("CryForHelp")
	ElseIf MenuResult == 1
		SpankNpc()
		GoToState("SpankNpc")
	ElseIf MenuResult == 2
		Mme.MilkPlayer()
		GoToState("MilkMyself")
	ElseIf MenuResult == 3
		UntieNpc()
		GoToState("UntieNpc")
	ElseIf MenuResult == 4
		TattooNpc()
		GoToState("TattooNpc")
	ElseIf MenuResult == 5
		Fhu.DrainCum()
		GoToState("DrainCum")
	ElseIf MenuResult == 6
		BegForCockMenu()
	;ElseIf MenuResult == 7
	
	EndIf
EndFunction

Int Function ShowMoreActionsMenu()
	;Actor akTarget = Game.GetCurrentCrosshairRef() as Actor
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Cry For Help")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Spank Npc")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Milk Myself")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Devices ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Tattoo Npc")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Drain Cum")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = "Beg For Cock")

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Cry For Help")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Spank Npc")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Milk Myself")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Devices ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Tattoo Npc")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Drain Cum")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = "Beg For Cock")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = Game.GetModByName("Spank That Ass.esp") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = (Game.GetModByName("MilkModNEW.esp") != 255) && StorageUtil.GetFloatValue(PlayerRef, "MME.MilkMaid.MilkCount", Missing = -1.0) >= 1.0)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = (Game.GetModByName("Devious Devices - Expansion.esm") != 255))
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = Game.GetCurrentCrosshairRef() as Actor)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = Game.GetModByName("sr_FillHerUp.esp") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function ToggleAutoFuck()
	If CompulsiveSex.IsFucking
		If PlayerRef.GetFactionRank(Game.GetFormFromFile(0x03FC36, "SexLabAroused.esm") as Faction) < 100
			CompulsiveSex.ManualStopFucking()
		Else
			Debug.Notification("No way am I stopping now")
		EndIf
	Else
		CompulsiveSex.BeginAutoFucking(tid = -1, HasPlayer = false, ManualStart = true)
	EndIf
EndFunction

Function UntieNpc()
	Int MenuSelect = ShowUntieNpcMenu()
	If MenuSelect == -1
		UntieActorDevices = new String[1]
		UntieActorDevices[0] = "_SLS_RESET"
		ActionsMenu()
	Else
		ExamineDeviceMenu()
	EndIf
EndFunction

Int Function ShowUntieNpcMenu()
	If UntieActorDevices.Length == 0 || (UntieActorDevices.Length == 1 && UntieActorDevices[0] == "_SLS_RESET")
		UntieActor = Game.GetCurrentCrosshairRef() as Actor
		If !UntieActor
			UntieActor = PlayerRef
		EndIf
		UntieActorDevices = Devious.StringListAllDevices(UntieActor)
	EndIf
	Debug.Notification("Examining " + UntieActor.GetLeveledActorBase().GetName())
	If UntieActorDevices.Length > 0
		UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
		Int i = 0
		While i < UntieActorDevices.Length
			ListMenu.AddEntryItem(UntieActorDevices[i])
			i += 1
		EndWhile
		ListMenu.OpenMenu()
		;Debug.Messagebox(ListMenu.GetResultInt())
		UntieActorDeviceSelect = ListMenu.GetResultInt()
		Return UntieActorDeviceSelect
	EndIf
	If UntieActor == PlayerRef
		Debug.Notification("I'm not wearing any devices")
	Else
		Debug.Notification("She's not wearing any devices")
	EndIf
	Return -1
EndFunction

Function ExamineDeviceMenu()
	Int MenuResult = ShowExamineDeviceMenu()
	If MenuResult == -1
		ShowUntieNpcMenu()
	ElseIf MenuResult == 0
		Key UnlockKey = Devious.ExamineDevice(UntieActorDeviceSelect, UntieActor)
		If UnlockKey
			Debug.Messagebox("That device needs a " + UnlockKey.GetName())
		Else
			Debug.Messagebox("I don't know what key unlocks that device")
		EndIf
		Utility.Wait(0.01)
		UntieNpc()
	ElseIf MenuResult == 1
		UntieActorDevices = new String[1]
		UntieActorDevices[0] = "_SLS_RESET"
		Devious.TryUnlockNpcDevice(UntieActorDeviceSelect, UntieActor)
	EndIf
EndFunction

Int Function ShowExamineDeviceMenu()
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	ListMenu.AddEntryItem("Examine ")
	ListMenu.AddEntryItem("Unlock ")
	ListMenu.OpenMenu()
	Return ListMenu.GetResultInt()
EndFunction

Function TattooNpc()
	Actor akActor = Game.GetCurrentCrosshairRef() as Actor
	If akActor
		If PlayerRef.GetItemCount(Charcoal) > 0
			If (Init.PahInstalled && akActor.IsInFaction(Init.PahFaction)) || (Init.SbcInstalled && akActor.IsInFaction(Init.SbcFaction)) || (Init.ZazInstalled && akActor.IsInFaction(Init.ZazSlaveFaction)) || !Devious.AreHandsAvailable(akActor)
				Debug.SendAnimationEvent(PlayerRef, "IdleLockPick")
				RapeTats.AddRapeTat(akActor)
				PlayerRef.RemoveItem(Charcoal, 1)
			Else
				Debug.Notification(akActor.GetLeveledActorBase().GetName() + ": I don't think so!")
			EndIf
		Else
			Debug.Notification("I need some charcoal to do that")
		EndIf
	EndIf
EndFunction

Function SpankNpc()
	Actor akTarget = Game.GetCurrentCrosshairRef() as Actor
	If akTarget
		(Game.GetFormFromFile(0x017E5E, "Spank That Ass.esp") as Spell).Cast(PlayerRef, akTarget)
	EndIf
EndFunction

; Outfits Menu ===================================================================================================

Function OutfitMenu()
	Int MenuResult = ShowOutfitMenu()
	If MenuResult == -1
		ActionsMenu()
	ElseIf MenuResult == 0
		If IsDressed
			Undress()
		Else
			Dress()
		EndIf
	ElseIf MenuResult == 1
		SaveOutfitMenu()
	ElseIf MenuResult == 2
		EquipOutfit(OutfitForms6)
	ElseIf MenuResult == 3
		EquipOutfit(OutfitForms5)
	ElseIf MenuResult == 4
		EquipOutfit(OutfitForms1)
	ElseIf MenuResult == 5
		EquipOutfit(OutfitForms2)
	ElseIf MenuResult == 6
		EquipOutfit(OutfitForms3)
	ElseIf MenuResult == 7
		EquipOutfit(OutfitForms4)
	EndIf
EndFunction

Int Function ShowOutfitMenu()
	String StripStr = "Undress "
	If !IsDressed
		StripStr = "Get Dressed"
	EndIf
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = StripStr)
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Save Outfit")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = OutfitNames[5])
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = OutfitNames[4])
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = OutfitNames[0])
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = OutfitNames[1])
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = OutfitNames[2])
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = OutfitNames[3])

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = StripStr)
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Save Outfit")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = OutfitNames[5])
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = OutfitNames[4])
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = OutfitNames[0])
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = OutfitNames[1])
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = OutfitNames[2])
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = OutfitNames[3])

	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function SaveOutfitMenu()
	Int MenuResult = ShowSaveOutfitMenu()
	If MenuResult == -1
		OutfitMenu()
	ElseIf MenuResult == 2
		SaveOutfit(5)
	ElseIf MenuResult == 3
		SaveOutfit(4)
	ElseIf MenuResult == 4
		SaveOutfit(0)
	ElseIf MenuResult == 5
		SaveOutfit(1)
	ElseIf MenuResult == 6
		SaveOutfit(2)
	ElseIf MenuResult == 7
		SaveOutfit(3)
	EndIf
EndFunction

Int Function ShowSaveOutfitMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Save As Outfit 1")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Save As Outfit 2")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = "Save As Outfit 3")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = "Save As Outfit 4")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Save As Outfit 5")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Save As Outfit 6")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Save As Outfit 1")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Save As Outfit 2")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = "Save As Outfit 3")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = "Save As Outfit 4")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Save As Outfit 5")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Save As Outfit 6")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function Undress()
	Debug.SendAnimationEvent(PlayerRef, "Arrok_Undress_G1")
	StrippedItems = new Form[32]
	Int i = 0
	Form akForm
	While i < Menu.SlotMasks.Length
		akForm = PlayerRef.GetWornForm(Menu.SlotMasks[i])
		;Debug.Trace("_SLS_: Undress(): Doing: " + i + " - " + akForm)
		If akForm && !akForm.HasKeyword(SexLabNoStrip) && akForm.GetName() != "" && akForm.IsPlayable()
			StrippedItems[i] = akForm
			PlayerRef.UnEquipItem(akForm, abPreventEquip = false, abSilent = true)
		EndIf
		i += 1
	EndWhile
	IsDressed = false
	;Debug.Trace("_SLS_: Undress(): EHHHHHH: " + PlayerRef.GetWornForm(0x80000000) + ". SlotMask: " + Menu.SlotMasks[31])
EndFunction

Function Dress()
	Debug.SendAnimationEvent(PlayerRef, "Arrok_Undress_G1")
	Int i = 0
	Form akForm
	While i < StrippedItems.Length
		akForm = StrippedItems[i]
		If akForm && PlayerRef.GetItemCount(akForm) > 0
			PlayerRef.EquipItem(akForm, abPreventRemoval = false, abSilent = true)
		EndIf
		i += 1
	EndWhile
	IsDressed = true
EndFunction

Function EquipOutfit(Form[] OutfitArray)
	Debug.SendAnimationEvent(PlayerRef, "Arrok_Undress_G1")
	Int i = 0
	Form akForm
	While i < OutfitArray.Length
		akForm = OutfitArray[i]
		If akForm && PlayerRef.GetItemCount(akForm) > 0
			PlayerRef.EquipItem(akForm, abPreventRemoval = false, abSilent = true)
		Else
			akForm = PlayerRef.GetWornForm(Menu.SlotMasks[i])
			If akForm && !akForm.HasKeyword(SexLabNoStrip) && akForm.GetName() != "" && akForm.IsPlayable()
				PlayerRef.UnEquipItem(akForm, abPreventEquip = false, abSilent = true)
			EndIf
		EndIf
		i += 1
	EndWhile
EndFunction

Form[] Function GetOutfitArray(Int OutfitNumber)
	If OutfitNumber == 0
		Return OutfitForms1
	ElseIf OutfitNumber == 1
		Return OutfitForms2
	ElseIf OutfitNumber == 2
		Return OutfitForms3
	ElseIf OutfitNumber == 3
		Return OutfitForms4
	ElseIf OutfitNumber == 4
		Return OutfitForms5
	Else
		Return OutfitForms6
	EndIf
EndFunction

Function SaveOutfit(Int OutfitNumber)
	Form[] OutfitArray = GetOutfitArray(OutfitNumber)
	Int i = 0
	Int ItemCount = 0
	Form akForm
	While i < Menu.SlotMasks.Length
		akForm = PlayerRef.GetWornForm(Menu.SlotMasks[i])
		If akForm && !akForm.HasKeyword(SexLabNoStrip) && akForm.GetName() != "" && akForm.IsPlayable()
			OutfitArray[i] = akForm
		Else
			OutfitArray[i] = None
		EndIf
		i += 1
	EndWhile
	
	; Name outfit
	String MainName = "Outfit " + (OutfitNumber + 1)
	akForm = PlayerRef.GetWornForm(Menu.SlotMasks[2])
	If akForm && !akForm.HasKeyword(SexLabNoStrip) && akForm.GetName() != "" && akForm.IsPlayable()
		MainName = akForm.GetName()
	Else
		akForm = PlayerRef.GetWornForm(Menu.SlotMasks[Menu.HalfNakedBra - 30])
		If akForm && !akForm.HasKeyword(SexLabNoStrip) && akForm.GetName() != "" && akForm.IsPlayable()
			MainName = akForm.GetName()
		EndIf		
	EndIf
	OutfitNames[OutfitNumber] = (OutfitNumber + 1) + ": " + MainName
EndFunction

Function BegForCockMenu()
	Int MenuSelect = ShowBegForCockMenu()
	If MenuSelect == -1 
		ActionsMenu()
	ElseIf MenuSelect == 0
		Debug.SendAnimationEvent(PlayerRef , "SLS_BegForCock_LeadIn_HandPump1")
	ElseIf MenuSelect == 1
		Debug.SendAnimationEvent(PlayerRef , "SLS_BegForCock_LeadIn_StickyFingers1")
	ElseIf MenuSelect == 2
		Debug.SendAnimationEvent(PlayerRef , "SLS_BegForCock_LeadIn_Sore1")
	EndIf
EndFunction

Int Function ShowBegForCockMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Hand pump")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Sticky Fingers")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Sore Ass")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Hand pump")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Sticky Fingers")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Sore Ass")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

; Survival Menu ==============================================================================================================

Function SurvivalMenu()
	Int MenuResult = ShowSurvivalMenu()
	If MenuResult == -1
		MainMenu()
	ElseIf MenuResult == 0
		CraftingMenu()
	ElseIf MenuResult == 1
		SurvivalSkillsMenu()
	ElseIf MenuResult == 2
		SleepOnGround()
		GoToState("SleepOnGround")
	ElseIf MenuResult == 3
		BatheMenu()
		GoToState("Bathe")
	EndIf	
EndFunction

Int Function ShowSurvivalMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Crafting ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Skills ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Sleep On Ground")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Bathe ")

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Crafting ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Skills ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Sleep On Ground")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Bathe ")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = Game.GetModByName("Bathing in Skyrim - Main.esp") != 255)

	Return wheelMenu.OpenMenu()
EndFunction

Function CraftingMenu()
	Int MenuSelect = ShowCraftingMenu()
	If MenuSelect == -1
		SurvivalMenu()
	ElseIf MenuSelect == 0
		(Game.GetFormFromFile(0x02306B, "Campfire.esm") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("FrostfallCrafting")
	ElseIf MenuSelect == 1
		(Game.GetFormFromFile(0x025C0C, "Hunterborn.esp") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("HunterbornCrafting")
	ElseIf MenuSelect == 2
		(Game.GetFormFromFile(0x073D95, "Hunterborn.esp") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("PrimitiveCooking")
	ElseIf MenuSelect == 3
		Frostfall.OpenAlchemyCrafting()
		GoToState("MortarPestle")
	EndIf
EndFunction

Int Function ShowCraftingMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Frostfall Crafting")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Hunterborn Crafting")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Primitive Cooking")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Mortar & Pestle")

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Frostfall Crafting")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Hunterborn Crafting")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Primitive Cooking")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Mortar & Pestle")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = Game.GetModByName("Campfire.esm") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = Game.GetModByName("Hunterborn.esp") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = Game.GetModByName("Hunterborn.esp") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = Game.GetModByName("Campfire.esm") != 255)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function SurvivalSkillsMenu()
	Int MenuResult = ShowSurvivalSkillsMenu()
	If MenuResult == -1
		SurvivalMenu()
	ElseIf MenuResult == 0
		(Game.GetFormFromFile(0x025BD5, "Campfire.esm") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("BuildCampfire")
	ElseIf MenuResult == 1
		Frostfall.PlaceTent()
		GoToState("PlaceTent")
	ElseIf MenuResult == 2
		(Game.GetFormFromFile(0x025647, "Campfire.esm") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("HarvestWood")
	ElseIf MenuResult == 3
		(Game.GetFormFromFile(0x035411, "Campfire.esm") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("Instincts")
	ElseIf MenuResult == 4
		(Game.GetFormFromFile(0x014225, "Hunterborn.esp") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("Forage")
	ElseIf MenuResult == 5
		(Game.GetFormFromFile(0x044ED1, "Hunterborn.esp") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("SenseDirection")
	ElseIf MenuResult == 6
		(Game.GetFormFromFile(0x01BD9E, "Mortal Weapons & Armor.esp") as Spell).Cast(PlayerRef, PlayerRef)
		GoToState("DetectEquipment")
	ElseIf MenuResult == 7
		SearchDistanceMenu()
		GoToState("SearchGround")
	EndIf
EndFunction

Int Function ShowSurvivalSkillsMenu()
	Bool CampfireInstalled = Game.GetModByName("Campfire.esm") != 255
	
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Build Campfire")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Place Tent")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Harvest Wood")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Instincts ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Forage ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Sense Direction")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = "Detect Equipment")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = "Search Ground")

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Build Campfire")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Place Tent")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Harvest Wood")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Instincts ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Forage ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Sense Direction")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = "Detect Equipment")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = "Search Ground")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = CampfireInstalled)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = CampfireInstalled)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = CampfireInstalled)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = CampfireInstalled)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = Game.GetModByName("Hunterborn.esp") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = Game.GetModByName("Hunterborn.esp") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = Game.GetModByName("Mortal Weapons & Armor.esp") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function SearchDistanceMenu()
	Int MenuResult = ShowSearchDistanceMenu()
	If MenuResult == -1
		SurvivalSkillsMenu()
	ElseIf MenuResult == 0
		_SLS_SearchGroundDistance.SetValue(600.0)
		BeginSearchGround()
	ElseIf MenuResult == 1
		_SLS_SearchGroundDistance.SetValue(1800.0)
		BeginSearchGround()
	ElseIf MenuResult == 2
		_SLS_SearchGroundDistance.SetValue(40000.0)
		BeginSearchGround()
	EndIf
EndFunction

Int Function ShowSearchDistanceMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Nearby ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Medium Distance")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Everywhere ")


	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Nearby ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Medium Distance")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Everywhere ")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function BeginSearchGround()
	If !PlayerRef.IsInCombat()
		_SLS_SearchGroundHostilesQuest.Stop()
		_SLS_SearchGroundHostilesQuest.Start()
		If !(_SLS_SearchGroundHostilesQuest.GetNthAlias(0) as ReferenceAlias).GetReference()
			SearchGroundMenu()
		Else
			Debug.Notification("I need to clear the search area of enemies first")
		EndIf
	Else
		Debug.Notification("I can't search in combat")
	EndIf
EndFunction

Function SearchGroundMenu()
	Int MenuResult = ShowSearchGroundMenu()
	If MenuResult == -1
		SearchDistanceMenu()
	Else
		; Get object
		ObjectReference ObjRef = StorageUtil.FormListGet(Self, "_SLS_SearchGroundForms", MenuResult) as ObjectReference
		If ObjRef
			;Debug.Messagebox("GetActorOwner(): " + ObjRef.GetActorOwner() + "\nGetFactionOwner(): " + ObjRef.GetFactionOwner())
			PlayerRef.AddItem(ObjRef)
			ObjRef.SendStealAlarm(PlayerRef)
		EndIf
	EndIf
EndFunction

Int Function ShowSearchGroundMenu()
	_SLS_SearchGroundQuest.Stop()
	_SLS_SearchGroundQuest.Start()
	StorageUtil.FormListClear(Self, "_SLS_SearchGroundForms")
	ObjectReference ObjRef
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	Int i = 0
	While i < _SLS_SearchGroundQuest.GetNumAliases()
		ObjRef = (_SLS_SearchGroundQuest.GetNthAlias(i) as ReferenceAlias).GetReference()
		If ObjRef ;/&& ObjRef.GetActorOwner() == None && ObjRef.GetFactionOwner() == None/;
			ListMenu.AddEntryItem(ObjRef.GetDisplayName())
			StorageUtil.FormListAdd(Self, "_SLS_SearchGroundForms", ObjRef)
		EndIf
		i += 1
	EndWhile
	If StorageUtil.FormListCount(Self, "_SLS_SearchGroundForms") > 0
		ListMenu.OpenMenu()
		Return ListMenu.GetResultInt()
	EndIf
	Debug.Notification("I couldn't find anything")
	Return -1
EndFunction

Function SleepOnGround()
	;/
	If Game.GetModByName("SexLab_Dialogues.esp") != 255
		(Game.GetFormFromFile(0x020B5D, "SexLab_Dialogues.esp") as Spell).Cast(PlayerRef, PlayerRef)
	Else
	
	EndIf
	/;
	If Menu.GetIsSleepDeprivationEnabled()
		Needs.GetSleepPenalty(ShowConditions = true, IsSleeping = false)
		Int Button = _SLS_SleepHereMsg.Show()
		If Button == 0 ; Yes
			DoSleepOnGround()
		Else
			SurvivalMenu()
		EndIf
	Else
		DoSleepOnGround()
	EndIf
EndFunction

Function DoSleepOnGround()
	If !PlayerRef.IsTrespassing() && !PlayerRef.IsInCombat()
		Location MyLoc = PlayerRef.GetCurrentLocation()
		If !MyLoc.HasKeyword(LocTypeInn)
			StorageUtil.SetIntValue(PlayerRef, "_SLS_SleepingRough", 1)
			ObjectReference BedObjRef = PlayerRef.PlaceAtMe(Bedroll01, aiCount = 1, abForcePersist = false, abInitiallyDisabled = true)
			BedObjRef.MoveTo(PlayerRef, 0.0, 0.0, PlayerRef.GetHeight() - 1000.0)
			BedObjRef.Enable()
			;Debug.Messagebox(PlayerRef.IsTrespassing())
			;If Utility.RandomInt(0,1) == 0
				Debug.SendAnimationEvent(PlayerRef, "IdleBedRollRightEnterStart")
			;Else
			;	Debug.SendAnimationEvent(PlayerRef, "IdleLayDownEnter")
			;EndIf
			Utility.Wait(3.5)
			FadeToBlack.Apply()
			Utility.Wait(1.5)
			BedObjRef.Activate(PlayerRef)
			BedObjRef.Disable()
			BedObjRef.Delete()
			RegisterForMenu("Sleep/Wait Menu")
		Else
			Debug.Notification("I can't sleep here")
		EndIf
	
	Else
		Debug.Notification("I don't have a good feeling about that")
	EndIf
EndFunction

Function BatheMenu()
	MiscObject MenuSelect = ShowSoapMenu()
	If MenuSelect == None
		SurvivalMenu()
	ElseIf MenuSelect == _SLS_NeverAddedItem
		Bis.TryBatheActor(PlayerRef, None)
	Else
		Bis.TryBatheActor(PlayerRef, MenuSelect)
	EndIf
EndFunction

MiscObject Function ShowSoapMenu()
	; Return None = Menu Back
	; Return _SLS_NeverAddedItem = wash without soap

	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	Bool FoundSoap = false
	Int i = 0
	While i < _SLS_BisSoapList.GetSize()
		If PlayerRef.GetItemCount(_SLS_BisSoapList.GetAt(i)) > 0
			ListMenu.AddEntryItem(_SLS_BisSoapList.GetAt(i).GetName())
			FoundSoap = true
		EndIf
		i += 1
	EndWhile
	If !FoundSoap
		ListMenu.AddEntryItem("Wash Without Soap")
	EndIf
	ListMenu.OpenMenu()
	Int Result = ListMenu.GetResultInt()
	If Result == -1
		Return None
	ElseIf !FoundSoap
		Return _SLS_NeverAddedItem
	Else
		Return _SLS_BisSoapList.GetAt(Result) as MiscObject
	EndIf
EndFunction

; Idle Menu ===============================================================================================================

Function IdleMenu()
	Int MenuSelect = ShowIdleMenu()
	If MenuSelect == -1
		MainMenu()
	ElseIf MenuSelect == 0
		Hug()
	ElseIf MenuSelect == 1
		IdleGesturesMenu()
	ElseIf MenuSelect == 2

	ElseIf MenuSelect == 3

	ElseIf MenuSelect == 4
		IdleCombatMenu()
	ElseIf MenuSelect == 5

	ElseIf MenuSelect == 6

	ElseIf MenuSelect == 7

	EndIf
EndFunction

Int Function ShowIdleMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Hug ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Gestures ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Wave ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Taunt ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Combat ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Salute ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = "Pray ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = "IdleCombatStretchingStar ")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Hug ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Gestures ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Wave ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Taunt ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Combat ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Salute ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = "Pray ")
	;wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = "IdleCombatStretchingStart")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = (PlayerRef.IsInCombat() == false && Game.GetCurrentCrosshairRef() as Actor))
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function IdleCombatMenu()
	Int MenuSelect = ShowIdleCombatMenu()
	If MenuSelect == -1
		IdleMenu()
	ElseIf MenuSelect == 0
		Taunt()
		GoToState("Taunt")
	ElseIf MenuSelect == 1
		Stretch()
		GoToState("Stretch")
	ElseIf MenuSelect == 2
		FlyYouFools()
		GoToState("FlyYouFools")
	EndIf
EndFunction

Int Function ShowIdleCombatMenu()
	String FlyYouFools = "Withdraw "
	If _SLS_FlyYouFoolsQuest.IsRunning()
		FlyYouFools = "Engage "
	EndIf

	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Taunt ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Stretch ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = FlyYouFools)
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Taunt ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Stretch ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = FlyYouFools)
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function FlyYouFools()
	If _SLS_FlyYouFoolsQuest.IsRunning()
		_SLS_FlyYouFoolsQuest.Stop()
	Else
		_SLS_FlyYouFoolsQuest.Start()
		If Sta.GetState() == "Installed"
			Sta.QueueComment(_SLS_AioRetreat, PriorityComment = true, ForcedGagComment = false)
		Else
			_SLS_RetreatSM.Play(PlayerRef)
		EndIf
		;PlayerRef.AddSpell(_SLS_CombatChangeDetectSpell, false)
	EndIf
EndFunction

Function Taunt()
	If PlayerRef.IsWeaponDrawn()
		If Sta.GetState() == "Installed"
			Sta.QueueComment(_SLS_AioTauntTopic, PriorityComment = true, ForcedGagComment = false)
		Else
			_SLS_TauntSM.Play(PlayerRef)
		EndIf
		Debug.SendAnimationEvent(PlayerRef, "IdleCombatShieldStart")
		_SLS_CombatTauntQuest.Stop()
		_SLS_CombatTauntQuest.Start()
	Else
		Debug.Notification("I'll need to draw my weapons to intimidate them")
	EndIf
EndFunction

Function Stretch()
	Debug.SendAnimationEvent(PlayerRef, "IdleCombatStretchingStart")
EndFunction

Function IdleGesturesMenu()
	Int MenuResult = ShowIdleGestureMenu()
	If MenuResult == -1
		IdleMenu()
	ElseIf MenuResult == 0
		ComeThisWay()
	ElseIf MenuResult == 1
		Salute()
	ElseIf MenuResult == 2
		AttractAttention()
	ElseIf MenuResult == 3
		Wave()
	ElseIf MenuResult == 4
		Applaud()
	EndIf
EndFunction

Int Function ShowIdleGestureMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Come This Way")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Salute ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Attract Attention")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Wave ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Applaud ")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Come This Way")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Salute ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Attract Attention")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Wave ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Applaud ")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function Hug()
	ObjectReference akTarget = Game.GetCurrentCrosshairRef()
	If akTarget as Actor && !(akTarget as Actor).IsInCombat()
		PlayerRef.PlayIdleWithTarget(pa_HugA, akTarget)
	EndIf
EndFunction

Function Applaud()
	Debug.SendAnimationEvent(PlayerRef, "IdleApplaud" + Utility.RandomInt(2,5))
EndFunction

Function Salute()
	Debug.SendAnimationEvent(PlayerRef, "IdleSalute")
	Actor akTarget = Game.GetCurrentCrosshairRef() as Actor
	;Debug.Messagebox("akTarget: " + akTarget + "\nakTarget.IsInCombat(): " + akTarget.IsInCombat() + "\nakTarget.IsInFaction(CWImperialFaction): " + akTarget.IsInFaction(CWImperialFaction) + "\nakTarget.IsInFaction(CWSonsFaction): " + akTarget.IsInFaction(CWSonsFaction))
	If akTarget && !akTarget.IsInCombat() && (akTarget.IsInFaction(CWImperialFaction) || akTarget.IsInFaction(CWSonsFaction)) && akTarget.IsInFaction(CWDialogueSoldierFaction)
		Utility.Wait(0.7)
		Debug.SendAnimationEvent(akTarget, "IdleSalute")
	EndIf
EndFunction

Function ComeThisWay()
	Debug.SendAnimationEvent(PlayerRef, "IdleComeThisWay")
EndFunction

Function AttractAttention()
	Debug.SendAnimationEvent(PlayerRef, "IdleGetAttention")
	If Sta.GetState() == "Installed"
		Sta.QueueComment(_SLS_AllInOneKeyGetAttention, PriorityComment = true, ForcedGagComment = false)
		PlayerRef.CreateDetectionEvent(PlayerRef, aiSoundLevel = 1000)
		; There's all sorts of delays calling STA dialogue out. Need to thread off dialogue so the script will continue otherwise waving arms about like a moron for ages
	Else
		_SLS_GetAttentionSM.Play(PlayerRef)
		PlayerRef.CreateDetectionEvent(PlayerRef, aiSoundLevel = 1000)
		Utility.Wait(1.0)
	EndIf
	
	;Debug.Messagebox("STOP")
	Debug.SendAnimationEvent(PlayerRef, "IdleStop")
EndFunction

Function Wave()
	Debug.SendAnimationEvent(PlayerRef, "IdleWave")
EndFunction


;/
String Function GetCustomIdle()
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	String[] ZazAnims = New String[128]
	ZazAnims[0] = "TepiFingYes"
	ZazAnims[1] = "TepiFingNo"
	ZazAnims[2] = "xDancerExit"
	ZazAnims[3] = "xDancerIdle"
	ZazAnims[4] = "xDayDreaming"
	ZazAnims[5] = "xEstimateing"
	ZazAnims[6] = "xFlashingIdle"
	ZazAnims[7] = "xGenericEnterExit"
	ZazAnims[8] = "xBarstoolIdle"
	ZazAnims[9] = "xBrokenLying"
	ZazAnims[10] = "TepKneelCuff"
	ZazAnims[11] = "TepiShowVagina"
	ZazAnims[12] = "TepiShowArs"
	ZazAnims[13] = "TepiHandsHip"
	
	
	;ZazAnims[] = ""
	
	
	Int i = 0
	While i < ZazAnims.Length
		ListMenu.AddEntryItem(ZazAnims[i])
		i += 1
	EndWhile
	ListMenu.OpenMenu()
	;Debug.Messagebox(ListMenu.GetResultInt())
	Return ZazAnims[ListMenu.GetResultInt()]
EndFunction
/;

; Status Menu ================================================================================================================

Function StatusMenu()
	Int MenuResult = ShowStatusMenu()
	If MenuResult == -1
		MainMenu()
	EndIf
EndFunction

Int Function ShowStatusMenu()	
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	Actor CrosshairRef = Game.GetCurrentCrosshairRef() as Actor

	;/ Doesn't display max health correctly
	ListMenu.AddEntryItem("H: (" + (PlayerRef.GetAv("Health") as Int) + "/" + (ActorValueInfo.GetActorValueInfoByName("Health").GetMaximumValue(PlayerRef) as Int) +\
	") S: (" + (PlayerRef.GetAv("Stamina") as Int) + "/" + (ActorValueInfo.GetActorValueInfoByName("Stamina").GetMaximumValue(PlayerRef) as Int) +\
	") M: (" + (PlayerRef.GetAv("Magicka") as Int) + "/" + (ActorValueInfo.GetActorValueInfoByName("Magicka").GetMaximumValue(PlayerRef) as Int) + ")")
	/;
	ListMenu.AddEntryItem("==== " + PlayerRef.GetActorBase().GetName() + " ====")
	ListMenu.AddEntryItem("Health: " + (PlayerRef.GetAv("Health") as Int) +\
	". Stamina: " + (PlayerRef.GetAv("Stamina") as Int) +\
	". Magicka: " + (PlayerRef.GetAv("Magicka") as Int))

	Frostfall.ShowMeters()
	;/
	ListMenu.AddEntryItem("H: (" + (PlayerRef.GetAv("Health") as Int) + "/" + (PlayerRef.GetActorValueMax("Health") as Int) +\
	"). S: (" + (PlayerRef.GetAv("Stamina") as Int) + "/" + (PlayerRef.GetActorValueMax("Stamina") as Int) +\
	"). M: (" + (PlayerRef.GetAv("Magicka") as Int) + "/" + (PlayerRef.GetActorValueMax("Magicka") as Int)) + ")"
/;
	
	
	If Needs.GetState() != ""
		; Needs
		;/
		ListMenu.AddEntryItem("Hunger: " + Needs.GetAioHunger())
		ListMenu.AddEntryItem("Thirst: " + Needs.GetAioThirst())
		ListMenu.AddEntryItem("Fatigue: " + Needs.GetAioFatigue())
		/;
		ListMenu.AddEntryItem(Needs.GetAioHunger() + ", " + Needs.GetAioThirst() + ", " + Needs.GetAioFatigue())
	EndIf
	
	; BiS
	If Bis.GetState() == "Installed"
		ListMenu.AddEntryItem("Dirt: " + ((Bis.GetPlayerDirt() * 100.0) as Int) + "%")
	EndIf
	
	; Arousal
	Float CumCapacity = Fhu.GetCumCapacityMax()
	ListMenu.AddEntryItem("Arousal: " + PlayerRef.GetFactionRank(Game.GetFormFromFile(0x03FC36, "SexLabAroused.esm") as Faction))
	
	; Orgasm Fatigue
	String OrgFat = Orgasmfatigue.GetOrgasmFatigueString()
	If OrgFat != ""
		ListMenu.AddEntryItem("Orgasm Fatigue: " + OrgFat)
	EndIf

	; Devious Followers
	If Game.GetModByName("DeviousFollowers.esp") != 255
		ListMenu.AddEntryItem("Debt: " + (Game.GetFormFromFile(0x00C54F, "DeviousFollowers.esp") as GlobalVariable).GetValue() as Int + \
		" Gold. Lives: " + (Game.GetFormFromFile(0x02DB9E, "DeviousFollowers.esp") as GlobalVariable).GetValueInt() + \
		". Willpower: " + SnipToDecimalPlaces((Game.GetFormFromFile(0x01A2A7, "Update.esm") as GlobalVariable).GetValue(), 2))
	EndIf
	
	; Cum
	If CumAddict.GetAddictionState() > 0
		ListMenu.AddEntryItem(CumAddict.GetStatusMessage())
	EndIf
	If Fhu.GetState() == "Installed"
		;Float CumCapacity = Fhu.GetCumCapacityMax()
		ListMenu.AddEntryItem("Cum In My Ass: " + (((Fhu.GetCurrentCumAnal(PlayerRef) / CumCapacity) * 100.0) as Int) + "%. Pussy: " + (((Fhu.GetCurrentCumVaginal(PlayerRef) / CumCapacity) * 100.0) as Int) + "%")
	EndIf
	
	; Milk
	If StorageUtil.GetFloatValue(PlayerRef, "MME.MilkMaid.MilkCount", Missing = -1.0) >= 0.0
		ListMenu.AddEntryItem("Milk: (" + SnipToDecimalPlaces(StorageUtil.GetFloatValue(PlayerRef, "MME.MilkMaid.MilkCount", Missing = 0.0), 2) + "/" + \
		SnipToDecimalPlaces(StorageUtil.GetFloatValue(PlayerRef, "MME.MilkMaid.MilkMaximum", Missing = 0.0), 2) +\
		"). Lact: " + SnipToDecimalPlaces(StorageUtil.GetFloatValue(PlayerRef, "MME.MilkMaid.LactacidCount", Missing = 0.0), 2) + \
		". Lvl: " + (StorageUtil.GetFloatValue(PlayerRef, "MME.MilkMaid.Level", Missing = 0.0) as Int))
	EndIf

	; Milk Addict
	String MaAddictLevel = MilkAddict.GetAddictionLevel()
	If MaAddictLevel != ""
		ListMenu.AddEntryItem("Lact Addict: " + MilkAddict.GetAddictionLevel() + ". Withdrawal: " + MilkAddict.GetWithdrawalLevel())
	EndIf
	
	; Soulgem Oven
	If Sgo.GetState() == "Installed"
		Float GemProgress = Sgo.ActorGemGetPercent(PlayerRef)
		;Debug.Messagebox("GemProgress: " + GemProgress)
		If GemProgress > 0.0
			String SgoString = "Gems: " + SnipToDecimalPlaces(GemProgress, 2) + "%"
			Float Milk = StorageUtil.GetFloatValue(PlayerRef, "SGO.Actor.Milk.Data")
			If Milk > 0.0
				SgoString += ". Milk: " + SnipToDecimalPlaces(((Milk / Sgo.GetMilkCapacity(PlayerRef)) * 100.0), 2) + "%"
			EndIf
			ListMenu.AddEntryItem(SgoString)
		EndIf
	EndIf
	
	; Creature Corruption
	If StorageUtil.GetIntValue(None, "_SLS_CreatureCorruption", Missing = 0) > 1
		ListMenu.AddEntryItem("Creature Corruption (" + StorageUtil.GetIntValue(None, "_SLS_CreatureCorruption", Missing = 0) + "/100). Breeder Lvl: " + (Util.CreatureFondleCount as Int))
	EndIf
	
	; Bikini
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
	ListMenu.AddEntryItem("Bikini Lvl: " + BikRankString + ". Xp: " + SnipToDecimalPlaces(BikExp, 1) + ". Next Xp: " + SnipToDecimalPlaces(BikExpNextLevel, 1))
	;/
	If LicUtil.LicBikiniEnable
		Bool IsCursed = (LicUtil.HasValidBikiniLicence && !LicUtil.HasValidArmorLicence)
		String CurseStr = "Bikini Cursed: " + (LicUtil.HasValidBikiniLicence && !LicUtil.HasValidArmorLicence)
		If IsCursed
			CurseStr += ". Active: " + (_SLS_LicBikiniCurseIsWearingArmor.GetValueInt() == 1)
		EndIf
		ListMenu.AddEntryItem(CurseStr)
		If IsCursed && _SLS_LicBikiniCurseIsWearingArmor.GetValueInt() == 1
			ListMenu.AddEntryItem("Curse Trigger: " + Menu.BikiniCurseTriggerArmor.GetName() + " - " + StringUtil.Substring(Menu.BikiniCurseTriggerArmor, StringUtil.Find(Menu.BikiniCurseTriggerArmor, "(", 0) + 1, len = 8))
		EndIf
	EndIf
/;
	; STA
	If Sta.GetState() == "Installed"
		ListMenu.AddEntryItem("Masochism: " + Sta.GetMasochismAttitudeString() + " pain (" + SnipToDecimalPlaces(Sta.GetPlayerMasochism(), 2) + "/" + SnipToDecimalPlaces((Sta.GetMasochismStepSize() * 4.0), 2) + ")")
	EndIf
	
	; Jiggles
	If PlayerRef.HasSpell(Game.GetFormFromFile(0x0CF9B0, "SL Survival.esp") as Spell)
		ListMenu.AddEntryItem("Jiggles: " + GetJigglesString())
	EndIf
	
	
	; Target ====================================================
	If CrosshairRef
		ListMenu.AddEntryItem("==== " + CrosshairRef.GetActorBase().GetName() + " ====")
		;ListMenu.AddEntryItem(CrosshairRef.GetActorBase().GetName())
		ListMenu.AddEntryItem("Arousal: " + (CrosshairRef).GetFactionRank(Game.GetFormFromFile(0x03FC36, "SexLabAroused.esm") as Faction))
		If (CrosshairRef).GetLeveledActorBase().GetSex() == 0 ; Male
			ListMenu.AddEntryItem("Cum Fullness: " + SnipToDecimalPlaces(StrInput = (Util.GetLoadFullnessMod(CrosshairRef) * 100.0), Places = 1) + "%")
		ElseIf Fhu.GetState() == "Installed"
			ListMenu.AddEntryItem("Cum in her ass: " + (((Fhu.GetCurrentCumAnal(CrosshairRef) / CumCapacity) * 100.0) as Int) + "%. Pussy: " + (((Fhu.GetCurrentCumVaginal(CrosshairRef) / CumCapacity) * 100.0) as Int) + "%")
		EndIf
	EndIf
	
	;/
	ListMenu.AddEntryItem("Lips: " + StorageUtil.GetStringValue(None, "yps_LipstickColor", Missing = "None") + " " + StorageUtil.GetStringValue(None, "yps_LipstickSmudged"))
	ListMenu.AddEntryItem("Eyes: " + StorageUtil.GetStringValue(None, "yps_EyeShadowColor", Missing = "None") + " " + StorageUtil.GetStringValue(None, "yps_EyeShadowSmudged"))
	ListMenu.AddEntryItem("Finger Nails: " + StorageUtil.GetStringValue(None, "yps_FingerNailPolishColor", Missing = "None") + " " + StorageUtil.GetStringValue(None, "yps_FingerNailPolishSmudged"))
	ListMenu.AddEntryItem("Toe Nails: " + StorageUtil.GetStringValue(None, "yps_ToeNailPolishColor", Missing = "None") + " " + StorageUtil.GetStringValue(None, "yps_ToeNailPolishSmudged"))
	
	ListMenu.AddEntryItem("IsBarredWhiterun: " + Menu.Eviction.IsBarredWhiterun)
	/;
	ListMenu.OpenMenu()
	Return ListMenu.GetResultInt()
	
EndFunction

; Misc Menu ===================================================================================================================

Function MiscMenu()
	Int MenuResult = ShowMiscMenu()
	If MenuResult == -1
		MainMenu()
	ElseIf MenuResult == 0
		DebugMenu()
	ElseIf MenuResult == 1
		(Game.GetFormFromFile(0x002DD9, "dcc-soulgem-oven-000.esm") as Spell).Cast(PlayerRef, PlayerRef)
	ElseIf MenuResult == 2
		;(Game.GetFormFromFile(0x000F5B, "EFFCore.esm") as Spell).Cast(PlayerRef, PlayerRef)
		TeleportFollowersMenu()
	EndIf
EndFunction

Int Function ShowMiscMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Debug Menu")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "SGO Menu")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Teleport Followers")

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Debug Menu")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "SGO Menu")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Teleport Followers")

	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = Game.GetModByName("dcc-soulgem-oven-000.esm") != 255)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = Game.GetModByName("EFFCore.esm") != 255)

	Return wheelMenu.OpenMenu()
EndFunction

Bool Function GetIsTransferableTarget(ObjectReference TargetRef)
	If TargetRef
		Form TargetBase = TargetRef.GetBaseObject()
		If TargetBase as Actor || TargetBase as Container
			Return true
		Else
			Debug.Messagebox("Target object is not an actor or container. Sometimes objects can act like a container but they're really just an activator that's linked to a container somewhere (sometimes hidden underground)\nIt's impossible for SLS to determine the target container in these cases\n\nYou can not transfer from/to this object!!!")
			Return false
		EndIf
	EndIf
EndFunction

Function ContainerTransferMenu()
	ObjectReference TargetRef = Game.GetCurrentCrosshairRef()
	Int MenuResult = ShowContainerTransferMenu(TargetRef)
	;/If MenuResult == -2
		 Not a transferable object under crosshairs
	Else/;If MenuResult == -1
		MiscMenu()
	ElseIf MenuResult == 0
		TransferFromContainer = TargetRef
		Debug.Notification("Transfer from: " + TransferFromContainer.GetBaseObject().GetName())
		GoToState("TransferMenu")
	ElseIf MenuResult == 1
		TransferToMenu(TargetRef)
		GoToState("TransferToMenu")
	EndIf 
EndFunction

Int Function ShowContainerTransferMenu(ObjectReference TargetRef)
	Bool IsTransferableTarget = GetIsTransferableTarget(TargetRef)
	String TargetStr
	If IsTransferableTarget
		TargetStr = TargetRef.GetBaseObject().GetName()
	Else
		Return -2 ; Not a transferable object under crosshairs - Do nothing. Error message printed in GetIsTransferableTarget()
	EndIf
	If TransferFromContainer
		Debug.Notification("Transferring from: " + TransferFromContainer.GetBaseObject().GetName())
	EndIf
	
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Transfer From " + TargetStr)
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Transfer To " + TargetStr)
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Transfer From " + TargetStr)
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Transfer To " + TargetStr)

	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = IsTransferableTarget)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = TransferFromContainer && IsTransferableTarget)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function TransferToMenu(ObjectReference DestRef)
	If !TransferInProc
		Int MenuResult = ShowTransferToMenu(DestRef)
		If MenuResult == -1
			ContainerTransferMenu()
		Else
			TransferInProc = true
			If MenuResult == 0 ; Move ALL To 
				TransferFromContainer.RemoveAllItems(akTransferTo = Game.GetCurrentCrosshairRef(), abKeepOwnership = true, abRemoveQuestItems = true)
				TransferFromContainer = None
			ElseIf MenuResult == 1 ; ALL ARMORS
				TransferAllArmors(DestRef)
			ElseIf MenuResult == 2 ; Devious Devices
				TransferDeviousDevices(DestRef)
			ElseIf MenuResult == 3 ; Bikini Armor
				TransferBikiniArmors(DestRef)
			ElseIf MenuResult == 4 ; Jewelry
				TransferJewelry(DestRef)
			ElseIf MenuResult == 5 ; Clothes
				TransferClothes(DestRef)
			ElseIf MenuResult == 6 ; Light Armor
				TransferLightArmor(DestRef)
			ElseIf MenuResult == 7 ; Heavy Armor
				TransferHeavyArmor(DestRef)
			ElseIf MenuResult == 8 ; All WEAPONS
				TransferAllWeapons(DestRef)
			ElseIf MenuResult == 9 ; All AMMO
				TransferAmmo(DestRef)
			ElseIf MenuResult == 10 ; All INGREDIENTS
				TransferIngredients(DestRef)
			ElseIf MenuResult == 11 ; All Potions
				TransferAllPotions(DestRef)
			ElseIf MenuResult == 12 ; All Food
				TransferAllFood(DestRef)
			ElseIf MenuResult == 13 ; All BOOKS
				TransferAllBooks(DestRef)
			ElseIf MenuResult == 14 ; All MISC OBJECTS
				TransferAllMiscObjects(DestRef)
			ElseIf MenuResult == 15 ; Gems
				TransferGems(DestRef)
			ElseIf MenuResult == 16 ; Crafting Material
				TransferCraftingMaterial(DestRef)
			ElseIf MenuResult == 17 ; Clutter
				TransferClutter(DestRef)
			EndIf
			TransferInProc = false
		EndIf
		
		If MenuResult > -1
			Debug.Notification(TransferFromContainer.GetBaseObject().GetName() + " item count: " + TransferFromContainer.GetNumItems())
			If TransferFromContainer.GetNumItems() == 0
				TransferFromContainer = None
			EndIf
		EndIf
		
	Else
		Debug.Messagebox("A transfer is already in progress. Wait until it's done")
	EndIf
EndFunction

Int Function ShowTransferToMenu(ObjectReference DestRef)
	Debug.Notification("Move target: " + DestRef.GetBaseObject().GetName())
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	ListMenu.AddEntryItem("Move ALL")
	ListMenu.AddEntryItem("ALL ARMORS")
	ListMenu.AddEntryItem("Devious Devices")
	ListMenu.AddEntryItem("Bikini Armor")
	ListMenu.AddEntryItem("Jewelry")
	ListMenu.AddEntryItem("Clothes")
	ListMenu.AddEntryItem("Light Armor")
	ListMenu.AddEntryItem("Heavy Armor")
	ListMenu.AddEntryItem("All WEAPONS")
	ListMenu.AddEntryItem("All AMMO")
	ListMenu.AddEntryItem("All INGREDIENTS")
	ListMenu.AddEntryItem("ALL POTIONS")
	ListMenu.AddEntryItem("ALL FOOD")
	ListMenu.AddEntryItem("All BOOKS")
	ListMenu.AddEntryItem("All MISC OBJECTS")
	ListMenu.AddEntryItem("Gems")
	ListMenu.AddEntryItem("Crafting Material")
	ListMenu.AddEntryItem("Clutter")
	ListMenu.OpenMenu()
	Return ListMenu.GetResultInt()
EndFunction

Function TeleportFollowersMenu()
	Int MenuResult = ShowTeleportFollowersMenu()
	If MenuResult == -1
		MiscMenu()
	ElseIf MenuResult == 0
		TeleportAllFollowersToMe()
		GoToState("TeleportFollower")
	ElseIf MenuResult == 1
		TeleportOneFollowerToMe()
		GoToState("TeleportFollower")
	ElseIf MenuResult == 2
		TeleportToFollower()
		GoToState("TeleportFollower")
	EndIf
EndFunction

Int Function ShowTeleportFollowersMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Teleport All To Me")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Teleport One")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Teleport To Follower")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Teleport All To Me")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Teleport One")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Teleport To Follower")

	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Int Function TeleportToFollower()
	Int MenuResult = ShowFollowersListMenu()
	If MenuResult == -1
		TeleportFollowersMenu()
	Else
		PlayerRef.MoveTo(FollowersList[MenuResult] as Actor)
	EndIf
EndFunction

Int Function TeleportOneFollowerToMe()
	Int MenuResult = ShowFollowersListMenu()
	If MenuResult == -1
		TeleportFollowersMenu()
	Else
		TeleportActorToMe(FollowersList[MenuResult] as Actor)
	EndIf
EndFunction

Function TeleportAllFollowersToMe()
	FollowersList = Util.GetFollowers()
	Int i = 0
	While i < FollowersList.Length
		If FollowersList[i] as Actor
			TeleportActorToMe(FollowersList[i] as Actor)
		EndIf
		i += 1
	EndWhile
EndFunction

Function TeleportActorToMe(Actor akActor)
	akActor.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight())
EndFunction

Int Function ShowFollowersListMenu()
	UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
	FollowersList = Util.GetFollowers()
	Int i = 0
	While i < FollowersList.Length
		ListMenu.AddEntryItem((FollowersList[i] as Actor).GetLeveledActorBase().GetName())
		i += 1
	EndWhile
	ListMenu.OpenMenu()
	;Debug.Messagebox(ListMenu.GetResultInt())
	Return ListMenu.GetResultInt()
EndFunction

; Debug Menu ===================================================================================================================

Function DebugMenu()
	Int MenuResult = ShowDebugMenu()
	If MenuResult == -1
		MiscMenu()
	ElseIf MenuResult == 0
		Actor akTarget = Game.GetCurrentCrosshairRef() as Actor
		If akTarget
			(Game.GetFormFromFile(0x0840A3, "SL Survival.esp") as Spell).Cast(PlayerRef, akTarget) ; GetActorPackage
		Else
			Debug.Notification("No crosshair ref")
		EndIf
	ElseIf MenuResult == 1
		Actor akTarget = Game.GetCurrentCrosshairRef() as Actor
		If akTarget
			(Game.GetFormFromFile(0x0969EC, "SL Survival.esp") as Spell).Cast(PlayerRef, akTarget) ; GetActorVoice
		Else
			Debug.Notification("No crosshair ref")
		EndIf
	
	ElseIf MenuResult == 2
		TeleportMenu()
		
	ElseIf MenuResult == 3
		LookAtDebug()
		
	ElseIf MenuResult == 4
		ContainerTransferMenu()
	ElseIf MenuResult == 5
		CompulsiveSex.SexStopped()
	ElseIf MenuResult == 6
		CumSwallow.OpenMouth(Override = true)
	ElseIf MenuResult == 7
		ModEventsMenu()
	EndIf	
EndFunction

Int Function ShowDebugMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Get Actor Package")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Get Actor Voice")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Teleport To...")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Look At Debug")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Container Transfer")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 5, value = "Stop Fucking")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 6, value = "Open/Close Mouth")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 7, value = "Mod Events")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Get Actor Package")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Get Actor Voice")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Teleport To...")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Look At Debug")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Container Transfer")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 5, value = "Stop Fucking")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 6, value = "Open/Close Mouth")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 7, value = "Mod Events")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 5, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 6, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 7, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function ModEventsMenu()
	Int MenuResult = ShowModEventsMenu()
	If MenuResult == -1
		DebugMenu()
	ElseIf MenuResult == 0
		EvictRootMenu()
	EndIf
EndFunction

Int Function ShowModEventsMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Evict ")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Evict ")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function EvictRootMenu()
	Int MenuResult = ShowEvictRootMenu()
	If MenuResult == -1
		ModEventsMenu()
	ElseIf MenuResult == 0
		EvictFromMenu()
	ElseIf MenuResult == 1
		UnEvictFromMenu()
	ElseIf MenuResult == 2
		EvictionFormsMenu()
	ElseIf MenuResult == 3
		EvictionReasonsMenu()
	EndIf
EndFunction

Int Function ShowEvictRootMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Evict Test")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "UnEvict Test")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Eviction Forms")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Eviction Reasons")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Evict Test")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "UnEvict Test")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Eviction Forms")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Eviction Reasons")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function EvictFromMenu()
	Int MenuResult = ShowCityLocationMenu()
	If MenuResult == -1
		EvictRootMenu()
	ElseIf MenuResult == 0
		Api.On_SLS_EvictFromHome(HomeInt = 0, EvictForm = Self, EvictReason = "Test ")
	ElseIf MenuResult == 1
		Api.On_SLS_EvictFromHome(HomeInt = 1, EvictForm = Self, EvictReason = "Test ")
	ElseIf MenuResult == 2
		Api.On_SLS_EvictFromHome(HomeInt = 2, EvictForm = Self, EvictReason = "Test ")
	ElseIf MenuResult == 3
		Api.On_SLS_EvictFromHome(HomeInt = 3, EvictForm = Self, EvictReason = "Test ")
	ElseIf MenuResult == 4
		Api.On_SLS_EvictFromHome(HomeInt = 4, EvictForm = Self, EvictReason = "Test ")
	EndIf
EndFunction

Function UnEvictFromMenu()
	Int MenuResult = ShowCityLocationMenu()
	If MenuResult == -1
		EvictRootMenu()
	ElseIf MenuResult == 0
		Api.On_SLS_UnEvictFromHome(HomeInt = 0, EvictForm = Self)
	ElseIf MenuResult == 1
		Api.On_SLS_UnEvictFromHome(HomeInt = 1, EvictForm = Self)
	ElseIf MenuResult == 2
		Api.On_SLS_UnEvictFromHome(HomeInt = 2, EvictForm = Self)
	ElseIf MenuResult == 3
		Api.On_SLS_UnEvictFromHome(HomeInt = 3, EvictForm = Self)
	ElseIf MenuResult == 4
		Api.On_SLS_UnEvictFromHome(HomeInt = 4, EvictForm = Self)
	EndIf
EndFunction

Function EvictionFormsMenu()
	Int i = ShowCityLocationMenu()
	If i > -1
		String Loc = GetCityStringFromInt(i)
		
		UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
		If StorageUtil.FormListCount(Api.Eviction, "EvictForms" + Loc) > 0
			i = 0
			While i < StorageUtil.FormListCount(Api.Eviction, "EvictForms" + Loc)
				ListMenu.AddEntryItem(StorageUtil.FormListGet(Api.Eviction, "EvictForms" + Loc, i))
				i += 1
			EndWhile
		Else
			ListMenu.AddEntryItem(None)
		EndIf
		ListMenu.OpenMenu()
	Else
		EvictRootMenu()
	EndIf
EndFunction

Function EvictionReasonsMenu()
	Int i = ShowCityLocationMenu()
	If i > -1
		String Loc = GetCityStringFromInt(i)
		
		UIListMenu ListMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
		If StorageUtil.StringListCount(Api.Eviction, "EvictReasons" + Loc) > 0
			i = 0
			While i < StorageUtil.StringListCount(Api.Eviction, "EvictReasons" + Loc)
				ListMenu.AddEntryItem(StorageUtil.StringListGet(Api.Eviction, "EvictReasons" + Loc, i))
				i += 1
			EndWhile
		Else
			ListMenu.AddEntryItem("-- List is EMPTY --")
		EndIf
		ListMenu.OpenMenu()
		;Debug.Messagebox(ListMenu.GetResultInt())
		;Return ListMenu.GetResultInt()
	Else
		EvictRootMenu()
	EndIf
EndFunction

String Function GetCityStringFromInt(Int Loc)
	If Loc == 0
		Return "Whiterun"
	ElseIf Loc == 1
		Return "Solitude"
	ElseIf Loc == 2
		Return "Markarth"
	ElseIf Loc == 3
		Return "Windhelm"
	ElseIf Loc == 4
		Return "Riften"
	EndIf
	Return ""
EndFunction

Function LookAtDebug()
	Int MenuResult = ShowLookAtDebugMenu()
	If MenuResult == -1
		 DebugMenu()
	ElseIf MenuResult == 0
		SetIsNpcVar()
	ElseIf MenuResult == 1
		PlayerRef.ClearLookAt()
	EndIf
EndFunction

Int Function ShowLookAtDebugMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "IsNpc: " + PlayerRef.GetAnimationVariableInt("IsNPC"))
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Clear Look At")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "IsNpc: " + PlayerRef.GetAnimationVariableInt("IsNPC"))
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Clear Look At")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function SetIsNpcVar()
	Int MenuResult = ShowSetIsNpcVarMenu()
	If MenuResult == -1
		LookAtDebug()
	ElseIf MenuResult == 0
		PlayerRef.SetAnimationVariableInt("IsNPC", 0)
	ElseIf MenuResult == 1
		PlayerRef.SetAnimationVariableInt("IsNPC", 1)
	EndIf
EndFunction

Int Function ShowSetIsNpcVarMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Set IsNpc To 0")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Set IsNpc To 1")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Set IsNpc To 0")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Set IsNpc To 1")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

; Debug Menu ===================================================================================================================

Function TeleportMenu()
	Int MenuResult = ShowTeleportMenu()
	If MenuResult == -1
		ShowDebugMenu()
	ElseIf MenuResult == 0
		TeleportToQuartermasterMenu()
	ElseIf MenuResult == 1
		TeleportToKennelMenu()
	EndIf
EndFunction

Int Function ShowTeleportMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Quartermaster ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Kennel ")

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Quartermaster ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Kennel ")
	
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

Function TeleportToKennelMenu()
	Int MenuSelect = ShowCityLocationMenu() ; Same menu
	If MenuSelect == -1
		TeleportMenu()
	ElseIf MenuSelect >= 0 && MenuSelect <= 4
		((Util._SLS_KennelOutsideDoors.GetAt(MenuSelect) as ObjectReference) as SLS_KennelOutsideDoorScript).OnActivate(PlayerRef)
		PlayerRef.MoveTo(Game.GetFormFromFile(0x038F3C, "SL Survival.esp") as ObjectReference)
	EndIf
EndFunction

Function TeleportToQuartermasterMenu()
	Int MenuSelect = ShowCityLocationMenu()
	If MenuSelect == -1
		TeleportMenu()
	ElseIf MenuSelect == 0
		PlayerRef.MoveTo(Game.GetFormFromFile(0x046213, "SL Survival.esp") as ObjectReference)
	ElseIf MenuSelect == 1
		PlayerRef.MoveTo(Game.GetFormFromFile(0x046772, "SL Survival.esp") as ObjectReference)
	ElseIf MenuSelect == 2
		PlayerRef.MoveTo(Game.GetFormFromFile(0x046774, "SL Survival.esp") as ObjectReference)
	ElseIf MenuSelect == 3
		PlayerRef.MoveTo(Game.GetFormFromFile(0x046773, "SL Survival.esp") as ObjectReference)
	ElseIf MenuSelect == 4
		PlayerRef.MoveTo(Game.GetFormFromFile(0x046775, "SL Survival.esp") as ObjectReference)
	EndIf
EndFunction

Int Function ShowCityLocationMenu()
	UIMenuBase wheelMenu = UIExtensions.GetMenu("UIWheelMenu")
	
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 0, value = "Whiterun ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 1, value = "Solitude ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 2, value = "Markarth ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 3, value = "Windhelm ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionText", index = 4, value = "Riften ")

	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 0, value = "Whiterun ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 1, value = "Solitude ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 2, value = "Markarth ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 3, value = "Windhelm ")
	wheelMenu.SetPropertyIndexString(propertyName = "optionLabelText", index = 4, value = "Riften ")

	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 0, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 1, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 2, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 3, value = true)
	wheelMenu.SetPropertyIndexBool(propertyName = "optionEnabled", index = 4, value = true)
	
	Return wheelMenu.OpenMenu()
EndFunction

; Last Action States ====================================================================================================================

Function LastAction()
EndFunction

String Function GetLastActionString()
	Return ""
EndFunction

State OpenCloseMouth
	String Function GetLastActionString()
		If sslBaseExpression.IsMouthOpen(PlayerRef)
			Return "Close Mouth"
		EndIf
		Return "Open Mouth"
	EndFunction
	
	Function LastAction()
		CumSwallow.OnKeyDown(0)
	EndFunction
EndState

State CoverMyself
	String Function GetLastActionString()
		If CoverMyself.GetState() == "Covered"
			Return "Uncover Myself"
		EndIf
		Return "Cover Myself"
	EndFunction
	
	Function LastAction()
		CoverMyself.OnKeyDown(0)
	EndFunction
EndState

;/
State Tongue

EndState
/;

State LookAt
	String Function GetLastActionString()
		If LookAtTarget
			Return "Stop Looking At"
		EndIf
		Return "Look At"
	EndFunction
	
	Function LastAction()
		BeginLookAt()
	EndFunction
EndState

State Crawl
	String Function GetLastActionString()
		If !IsCrawling
			Return "Crawl"
		EndIf
		Return "Stop Crawling"
	EndFunction
	
	Function LastAction()
		ToggleCrawl()
	EndFunction
EndState

State SexyMove
	String Function GetLastActionString()
		Return "Sexy Move"
	EndFunction
	
	Function LastAction()
		ChangeAnimationSetMenu()
	EndFunction
EndState

State Emote
	String Function GetLastActionString()
		Return "Emote"
	EndFunction
	
	Function LastAction()
		EmoteMenu()
	EndFunction
EndState

State Tease
	String Function GetLastActionString()
		If PlayerRef.HasSpell(_SLS_TeaseMyselfSpell)
			Return "Stop Playing"
		EndIf
		Return "Tease "
	EndFunction
	
	Function LastAction()
		If !PlayerRef.HasSpell(_SLS_TeaseMyselfSpell)
			PlayerRef.AddSpell(_SLS_TeaseMyselfSpell, false)
		Else
			PlayerRef.RemoveSpell(_SLS_TeaseMyselfSpell)
			Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		EndIf
	EndFunction
EndState

State Masturbate
	String Function GetLastActionString()
		Return "Masturbate "
	EndFunction
	
	Function LastAction()
		Masturbate()
	EndFunction
EndState

State Dance
	String Function GetLastActionString()
		Return "Dance "
	EndFunction
	
	Function LastAction()
		DanceMenu()
	EndFunction
EndState

State CryForHelp
	String Function GetLastActionString()
		Return "Cry For Help"
	EndFunction
	
	Function LastAction()
		_SLS_ScreamForHelpSpell.Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State SpankNpc
	String Function GetLastActionString()
		Return "Spank Npc"
	EndFunction
	
	Function LastAction()
		SpankNpc()
	EndFunction
EndState

State Outfits
	String Function GetLastActionString()
		Return "Outfits "
	EndFunction
	
	Function LastAction()
		OutfitMenu()
	EndFunction
EndState

State MilkMyself
	String Function GetLastActionString()
		Return "Milk Myself"
	EndFunction
	
	Function LastAction()
		Mme.MilkPlayer()
	EndFunction
EndState

State DrainCum
	String Function GetLastActionString()
		Return "Drain Cum"
	EndFunction
	
	Function LastAction()
		Fhu.DrainCum()
	EndFunction
EndState

State FrostfallCrafting
	String Function GetLastActionString()
		Return "Frostfall Crafting"
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x02306B, "Campfire.esm") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State HunterbornCrafting
	String Function GetLastActionString()
		Return "Hunterborn Crafting"
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x025C0C, "Hunterborn.esp") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State PrimitiveCooking
	String Function GetLastActionString()
		Return "Primitive Cooking"
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x073D95, "Hunterborn.esp") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State MortarPestle
	String Function GetLastActionString()
		Return "Mortar & Pestle"
	EndFunction
	
	Function LastAction()
		Frostfall.OpenAlchemyCrafting()
	EndFunction
EndState

State BuildCampfire
	String Function GetLastActionString()
		Return "Build Campfire"
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x025BD5, "Campfire.esm") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State PlaceTent
	String Function GetLastActionString()
		Return "Place Tent"
	EndFunction
	
	Function LastAction()
		Frostfall.PlaceTent()
	EndFunction
EndState

State HarvestWood
	String Function GetLastActionString()
		Return "Harvest Wood"
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x025647, "Campfire.esm") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State Instincts
	String Function GetLastActionString()
		Return "Instincts "
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x035411, "Campfire.esm") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State Forage
	String Function GetLastActionString()
		Return "Forage "
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x014225, "Hunterborn.esp") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State SenseDirection
	String Function GetLastActionString()
		Return "Sense Direction"
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x044ED1, "Hunterborn.esp") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State DetectEquipment
	String Function GetLastActionString()
		Return "Detect Equipment"
	EndFunction
	
	Function LastAction()
		(Game.GetFormFromFile(0x01BD9E, "Mortal Weapons & Armor.esp") as Spell).Cast(PlayerRef, PlayerRef)
	EndFunction
EndState

State SleepOnGround
	String Function GetLastActionString()
		Return "Sleep On Ground"
	EndFunction
	
	Function LastAction()
		SleepOnGround()
	EndFunction
EndState

State Bathe
	String Function GetLastActionString()
		Return "Bathe "
	EndFunction
	
	Function LastAction()
		BatheMenu()
	EndFunction
EndState

State Taunt
	String Function GetLastActionString()
		Return "Taunt "
	EndFunction
	
	Function LastAction()
		Taunt()
	EndFunction
EndState

State Stretch
	String Function GetLastActionString()
		Return "Stretch "
	EndFunction
	
	Function LastAction()
		Stretch()
	EndFunction
EndState

State FlyYouFools
	String Function GetLastActionString()
		If _SLS_FlyYouFoolsQuest.IsRunning()
			Return "Engage "
		EndIf
		Return "Withdraw "
	EndFunction
	
	Function LastAction()
		FlyYouFools()
	EndFunction
EndState

State Tongue
	String Function GetLastActionString()
		Return "Tongue "
	EndFunction
	
	Function LastAction()
		TongueMenu()
	EndFunction
EndState

State BendOver
	String Function GetLastActionString()
		Return "Bend Over"
	EndFunction
	
	Function LastAction()
		BendOverMenu()
	EndFunction
EndState

State TattooNpc
	String Function GetLastActionString()
		Return "Tattoo Npc"
	EndFunction
	
	Function LastAction()
		TattooNpc()
	EndFunction
EndState

State UntieNpc
	String Function GetLastActionString()
		Return "Devices "
	EndFunction
	
	Function LastAction()
		UntieNpc()
	EndFunction
EndState

State SearchGround
	String Function GetLastActionString()
		Return "Search Ground"
	EndFunction
	
	Function LastAction()
		SearchDistanceMenu()
	EndFunction
EndState

State TeleportFollower
	String Function GetLastActionString()
		Return "Teleport Followers"
	EndFunction
	
	Function LastAction()
		TeleportFollowersMenu()
	EndFunction
EndState

State TransferMenu
	String Function GetLastActionString()
		Return "Container Transfer"
	EndFunction
	
	Function LastAction()
		ContainerTransferMenu()
	EndFunction
EndState

State TransferToMenu
	String Function GetLastActionString()
		Return "Transfer To "
	EndFunction
	
	Function LastAction()
		ObjectReference TargetRef = Game.GetCurrentCrosshairRef()
		If GetIsTransferableTarget(TargetRef)
			TransferToMenu(TargetRef)
		EndIf
	EndFunction
EndState

State Kneel
	String Function GetLastActionString()
		If Init.IsKneeling
			Return "Stop Kneeling"
		EndIf
		Return "Kneel "
	EndFunction
	
	Function LastAction()
		ToggleKneel()
	EndFunction
EndState

State AutoFuck
	String Function GetLastActionString()
		If CompulsiveSex.IsFucking
			Return "Stop Fucking"
		EndIf
		Return "Start Fucking"
	EndFunction
	
	Function LastAction()
		If PlayerRef.IsInFaction(CompulsiveSex.SexlabAnimatingFaction)
			ToggleAutoFuck()
		EndIf
	EndFunction
EndState

; Functions ====================================================================================================================

Function BuildScriptArrays()
	BuildDancesArray()
	BuildHornyAnimsList()
	BuildTonguesArray()
	BuildOutfitNames()
	BuildOutfits()
EndFunction

Function BuildOutfits()
	OutfitForms1 = new Form[32]
	OutfitForms2 = new Form[32]
	OutfitForms3 = new Form[32]
	OutfitForms4 = new Form[32]
	OutfitForms5 = new Form[32]
	OutfitForms6 = new Form[32]
EndFunction

Function BuildOutfitNames()
	OutfitNames = new String[6]
	OutfitNames[0] = "Outfit 1"
	OutfitNames[1] = "Outfit 2"
	OutfitNames[2] = "Outfit 3"
	OutfitNames[3] = "Outfit 4"
	OutfitNames[4] = "Outfit 5"
	OutfitNames[5] = "Outfit 6"
EndFunction

Function BuildDancesArray()
	StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "Stop Dancing")
	StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "Random Dance")

	StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "IdleCiceroAgitated")
	StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "IdleCiceroDance1")
	StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "IdleCiceroDance2")
	StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "IdleCiceroDance3")
	StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "IdleCiceroHappy")
	
	If MiscUtil.FileExists("data/Meshes/actors/character/animations/ZaZAnimationPack/FNIS_ZaZAnimationPack_List.txt")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazPoleDance_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazSnakeDance_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazSexyAJDance_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazBellyDance_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazShakeAssDance_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazSexyDance_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazBreakingPop_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazDisco_VB_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazFunky_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazKickDance_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazLMFAO_Shuffle_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazSara_MelbourneShuffle_Enter")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", "ZazSeph05Disco_Enter")
	EndIf
	
	Int i = 0 
	While i < JsonUtil.StringListCount("SL Survival/DanceAnims.json", "danceanims")
		StorageUtil.StringListAdd(Self, "_SLS_DanceAnimsTemp", JsonUtil.StringListGet("SL Survival/DanceAnims.json", "danceanims", i))
		i += 1
	EndWhile
	DancesList = StorageUtil.StringListToArray(Self, "_SLS_DanceAnimsTemp")
	StorageUtil.StringListClear(Self, "_SLS_DanceAnimsTemp")
EndFunction

Function BuildHornyAnimsList()
	HornyAnimsList = new String[5]
	HornyAnimsList[0] = "SLS_ZazHornyA"
	HornyAnimsList[1] = "SLS_ZazHornyB"
	HornyAnimsList[2] = "SLS_ZazHornyC"
	HornyAnimsList[3] = "SLS_ZazHornyD"
	HornyAnimsList[4] = "SLS_ZazHornyE"
EndFunction

Function BuildTonguesArray()
	StorageUtil.StringListAdd(Self, "_SLS_TonguesListTemp", "Stick out/Retract ")
	StorageUtil.StringListAdd(Self, "_SLS_TonguesListTemp", "Random ")
	Int i = 0
	While i < _SLS_TonguesList.GetSize()
		StorageUtil.StringListAdd(Self, "_SLS_TonguesListTemp", "Tongue " + (i + 1))
		i += 1
	EndWhile
	TonguesList = StorageUtil.StringListToArray(Self, "_SLS_TonguesListTemp")
	StorageUtil.StringListClear(Self, "_SLS_TonguesListTemp")
EndFunction

String Function GetRandomHornyAnim()
	Return HornyAnimsList[Utility.RandomInt(0, HornyAnimsList.Length - 1)]
EndFunction

String Function SnipToDecimalPlaces(String StrInput, Int Places)
	Return StringUtil.Substring(StrInput, startIndex = 0, len =  Places + 1 + StringUtil.Find(StrInput, ".", startIndex = 0))
EndFunction

String Function GetJigglesString()
	If _SLS_BodyInflationScale.GetValue() < 0.3
		Return "None "
	ElseIf _SLS_BodyInflationScale.GetValue() < 0.6
		Return "Low (+3% prices, -3% speed)"
	ElseIf _SLS_BodyInflationScale.GetValue() < 0.99
		Return "Moderate (+6% prices, -6% speed)"
	Else
		Return "High (+10% prices, -10% speed)"
	EndIf		
EndFunction

; Transfer Functions ===============================================================================

Function TransferDeviousDevices(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Armor && Devious.IsDeviousInvDevice(akForm)
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferAllArmors(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Armor
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferBikiniArmors(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Armor && akForm.HasKeyword(LicUtil._SLS_BikiniArmor)
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferJewelry(ObjectReference DestRef)
	Keyword VendorItemJewelry = Game.GetFormFromFile(0x8F95A, "Skyrim.esm") as Keyword
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Armor && akForm.HasKeyword(VendorItemJewelry) && !Devious.IsDeviousInvDevice(akForm)
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferClothes(ObjectReference DestRef)
	Keyword VendorItemJewelry = Game.GetFormFromFile(0x8F95A, "Skyrim.esm") as Keyword
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Armor && (akForm as Armor).GetWeightClass() == 2 && !Devious.IsDeviousInvDevice(akForm) && !akForm.HasKeyword(VendorItemJewelry)
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferLightArmor(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Armor && (akForm as Armor).GetWeightClass() == 0 && !Devious.IsDeviousInvDevice(akForm)
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferHeavyArmor(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Armor && (akForm as Armor).GetWeightClass() == 1 && !Devious.IsDeviousInvDevice(akForm)
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferAllWeapons(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Weapon
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferAmmo(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Ammo
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferIngredients(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Ingredient
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferAllPotions(ObjectReference DestRef)
	Keyword VendorItemPotion = Game.GetFormFromFile(0x8CDEC, "Skyrim.esm") as Keyword
	Keyword VendorItemPoison = Game.GetFormFromFile(0x8CDED, "Skyrim.esm") as Keyword
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Potion && (akForm.HasKeyword(VendorItemPotion) || akForm.HasKeyword(VendorItemPoison))
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferAllFood(ObjectReference DestRef)
	Keyword VendorItemFood = Game.GetFormFromFile(0x8CDEA, "Skyrim.esm") as Keyword
	Keyword VendorItemFoodRaw = Game.GetFormFromFile(0xA0E56, "Skyrim.esm") as Keyword
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Potion && (akForm.HasKeyword(VendorItemFood) || akForm.HasKeyword(VendorItemFoodRaw))
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferAllBooks(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as Book
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferAllMiscObjects(ObjectReference DestRef)
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as MiscObject
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferGems(ObjectReference DestRef)
	Keyword VendorItemGem = Game.GetFormFromFile(0x914ED, "Skyrim.esm") as Keyword
	Form akForm
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as MiscObject && akForm.HasKeyword(VendorItemGem)
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferCraftingMaterial(ObjectReference DestRef)
	Form akForm
	Keyword VendorItemOreIngot = Game.GetFormFromFile(0x914EC, "Skyrim.esm") as Keyword
	Keyword VendorItemAnimalPart = Game.GetFormFromFile(0x914EB, "Skyrim.esm") as Keyword
	Keyword VendorItemAnimalHide = Game.GetFormFromFile(0x914EA, "Skyrim.esm") as Keyword
	Keyword VendorItemFireword = Game.GetFormFromFile(0xBECD7, "Skyrim.esm") as Keyword
	
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as MiscObject && (akForm.HasKeyword(VendorItemOreIngot) || akForm.HasKeyword(VendorItemAnimalPart) || akForm.HasKeyword(VendorItemAnimalHide) || akForm.HasKeyword(VendorItemFireword))
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

Function TransferClutter(ObjectReference DestRef)
	Form akForm
	Keyword VendorItemClutter = Game.GetFormFromFile(0x914E9, "Skyrim.esm") as Keyword
	MiscObject Gold001 = Game.GetFormFromFile(0xf, "Skyrim.esm") as MiscObject
	Int i = TransferFromContainer.GetNumItems()
	While i > 0
		i -= 1
		akForm = TransferFromContainer.GetNthForm(i)
		If akForm as MiscObject && akForm.HasKeyword(VendorItemClutter) && akForm != Gold001
			TransferFromContainer.RemoveItem(akItemToRemove = akForm, aiCount = TransferFromContainer.GetItemCount(akForm), abSilent = true, akOtherContainer = DestRef)
		EndIf
	EndWhile
EndFunction

; Transfer Functions END===============================================================================

Bool IsDressed = true
Bool TransferInProc = false

Int PlayerIsNpcVar
Int LastTongue = 0
Int UntieActorDeviceSelect
Int TongueSlotMask = 0x00100000

String[] DancesList
String[] HornyAnimsList
String[] TonguesList
String[] OutfitNames
String[] UntieActorDevices

Form[] StrippedItems
Form[] OutfitForms1
Form[] OutfitForms2
Form[] OutfitForms3
Form[] OutfitForms4
Form[] OutfitForms5
Form[] OutfitForms6
Form[] FollowersList

Actor UntieActor

ObjectReference TransferFromContainer

Bool Property IsBendingOver = false Auto Hidden
Bool Property IsCrawling = false Auto Hidden
Bool Property IsLookingSubmissively = false Auto Hidden
Bool FightControlsWereEnabled = true

ObjectReference Property LookAtTarget Auto Hidden

Int Property AioKey = 34 Auto Hidden

ObjectReference Property _SLS_LookAtMarkerRef Auto

Formlist Property _SLS_TonguesList Auto
Formlist Property _SLS_BisSoapList Auto

Actor Property PlayerRef Auto

Keyword Property SexLabNoStrip Auto

Faction Property CWImperialFaction Auto
Faction Property CWSonsFaction Auto
Faction Property CWDialogueSoldierFaction Auto

Perk Property _SLS_CrawlingPerk Auto

Spell Property _SLS_TeaseMyselfSpell Auto
Spell Property _SLS_ScreamForHelpSpell Auto

GlobalVariable Property _SLS_LicBikiniCurseIsWearingArmor Auto
GlobalVariable Property _SLS_BodyCoverStatus Auto
GlobalVariable Property _SLS_SearchGroundDistance Auto
GlobalVariable Property _SLS_BodyInflationScale Auto

Keyword Property _SLS_TongueKeyword Auto
Keyword Property LocTypeInn Auto

Quest Property _SLS_CoverMySelfQuest Auto
Quest Property _SLS_LookAtSearchQuest Auto
Quest Property _SLS_CombatTauntQuest Auto
Quest Property _SLS_BikiniExpTrainingQuest Auto
Quest Property _SLS_FlyYouFoolsQuest Auto
Quest Property _SLS_SpankRandomPeriodicQuest Auto
Quest Property _SLS_SearchGroundHostilesQuest Auto
Quest Property _SLS_SearchGroundQuest Auto

MiscObject Property _SLS_NeverAddedItem Auto
MiscObject Property Charcoal Auto

Message Property _SLS_SleepHereMsg Auto

Furniture Property Bedroll01 Auto

ImageSpaceModifier Property FadeToBlack Auto

Topic Property _SLS_AllInOneKeyGetAttention Auto
Topic Property _SLS_AioTauntTopic Auto
Topic Property _SLS_AioRetreat Auto

Sound Property _SLS_GetAttentionSM Auto
Sound Property _SLS_TauntSM Auto
Sound Property _SLS_RetreatSM Auto

Armor Property _SLS_DummyObject Auto

_SLS_InterfaceRapeTats Property RapeTats Auto
_SLS_InterfaceDevious Property Devious Auto
_SLS_InterfaceMilkAddict Property MilkAddict Auto
_SLS_InterfaceMme Property Mme Auto
_SLS_InterfaceFrostfall Property Frostfall Auto
_SLS_InterfaceBis Property Bis Auto
_SLS_InterfaceSexyMove Property SexyMove Auto
_SLS_InterfaceSpankThatAss Property Sta Auto
_SLS_InterfaceFhu Property Fhu Auto
_SLS_InterfaceSgo Property Sgo Auto

_SLS_CompulsiveSex Property CompulsiveSex Auto
_SLS_OrgasmFatigue Property Orgasmfatigue Auto
_SLS_LicenceUtil Property LicUtil Auto
_SLS_BikiniExpTraining Property BikiniExp Auto
_SLS_CumAddict Property CumAddict Auto
_SLS_CumSwallow Property CumSwallow Auto
_SLS_CoverMyself Property CoverMyself Auto
_SLS_Needs Property Needs Auto
_SLS_Api Property Api Auto
SLS_Utility Property Util Auto
SLS_Main Property Main Auto
SLS_Mcm Property Menu Auto
SLS_Init Property Init Auto

Idle Property pa_HugA Auto
