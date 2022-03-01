Scriptname IdlePlayMenuOption05QuestScript extends Quest  

int result
actor property playerref auto

Spell property IdlePlayLookFarSpell auto
Spell property IdlePlayPraySpell auto
Spell property IdlePlaySitMeditateSpell auto
Spell property IdlePlayRitualStartSpell auto


Quest Property IdlePlayGroupPointtheWayQuest auto
Quest Property IdlePlayGroupMourningQuest auto

GlobalVariable Property IdleOp05 auto
GlobalVariable Property IsOpenOp05 auto



Event OnInit()
	if self.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenOp05.setvalue(1.0)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_SelectGroup")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 2, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 4, "$IAWM_SelectGroup")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 6, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_Group_PointtheWay")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_LookFar")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 2, "$IAWM_Pray")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 4, "$IAWM_Group_Mourning")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_Meditate")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 6, "$IAWM_PerformRitual")
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 0,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 1,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 2,true)
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
	IsOpenOp05.setvalue(0.0)
EndEvent


Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	IdleOp05.setvalue(numArg)
EndEvent	




Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	If result == 0
		IdlePlayGroupPointtheWayQuest.start()
	Elseif result == 1
		IdlePlayLookFarSpell.cast(playerref)
	Elseif result == 2
		IdlePlayPraySpell.cast(playerref)
	Elseif result == 4
		IdlePlayGroupMourningQuest.start()
	Elseif result == 5
		IdlePlaySitMeditateSpell.cast(playerref)
	Elseif result == 6	
		IdlePlayRitualStartSpell.cast(playerref)
	endif	
endevent	

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	self.Reset()
EndEvent  