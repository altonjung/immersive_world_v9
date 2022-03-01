Scriptname IdlePlayMenuOption06QuestScript extends Quest  

int result
actor property playerref auto

Spell Property IdlePlayHoeSpell auto
Spell Property IdlePlayWipeBrowSpell auto
Spell Property IdlePlaySweepingSpell auto
Spell Property IdlePlayFeedChickenSpell auto
Spell Property IdlePlayHoldingDrinkTraySpell auto
Spell Property IdlePlayFrightenedGestureSpell auto

Quest Property IdlePlayGroupPickingandSearchingQuest auto

GlobalVariable Property IdleOp06 auto
GlobalVariable Property IsOpenOp06 auto


Event OnInit()
	if self.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenOp06.setvalue(1.0)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 2, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 3, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 4, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 6, "$IAWM_SelectGroup")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_Hoe")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_WipeBrow")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 2, "$IAWM_SweepFloor")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 3, "$IAWM_HoldingTray")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 4, "$IAWM_FeedChicken")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_FrightenedGesture")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 6, "$IAWM_Group_PickandSearch")
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 0,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 1,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 2,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 3,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 4,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 5,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 6,true)
		RegisterForModEvent("UIWheelMenu_ChooseOption", "OnChooseOption")
		RegisterForModEvent("UIWheelMenu_SetOption", "OnSelectOption")
		RegisterForModEvent("UIWheelMenu_LoadMenu", "OnLoadMenu")		
		RegisterForModEvent("UIWheelMenu_CloseMenu", "OnUnloadMenu")
		UIExtensions.OpenMenu("UIWheelMenu")
	endif
EndEvent


Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	IsOpenOp06.setvalue(0.0)
EndEvent


Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	IdleOp06.setvalue(numArg)
EndEvent	




Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	If result == 0	
		IdlePlayHoeSpell.cast(playerref)
	Elseif result == 1	
		IdlePlayWipeBrowSpell.cast(playerref)
	Elseif result == 2	
		IdlePlaySweepingSpell.cast(playerref)
	Elseif result == 3
		IdlePlayHoldingDrinkTraySpell.cast(playerref)
	Elseif result == 4	
		IdlePlayFeedChickenSpell.cast(playerref)
	Elseif result == 5
		IdlePlayFrightenedGestureSpell.cast(playerref)
	Elseif result == 6	
		IdlePlayGroupPickingandSearchingQuest.start()
	endif	
endevent	

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	self.Reset()
EndEvent  