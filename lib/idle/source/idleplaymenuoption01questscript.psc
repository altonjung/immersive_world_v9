Scriptname IdlePlayMenuOption01QuestScript extends Quest  

int result
actor property playerref auto

Spell property IdlePlayProvokeSpell auto
Spell property IdlePlaySaluteSpell auto
Spell property IdlePlayCleanSwordSpell auto
Spell property IdlePlayPrisonerBeatSpell auto
Spell property IdlePlayStretchingSpell auto
Spell property IdlePlaySnapSpell auto
Spell property IdlePlayBlowHornSpell auto


Quest Property IdlePlayGroupSurrenderQuest auto

GlobalVariable Property IdleOp01 auto
GlobalVariable Property IsOpenOp01 auto



Event OnInit()
	if self.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenOp01.setvalue(1.0)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 2, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 3, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 4, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 6, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 7, "$IAWM_SelectGroup")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_Group_Provoke")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_LegionSaltue")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 2, "$IAWM_CleanSword")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 3, "$IAWM_Punch")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 4, "$IAWM_StretchBody")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_AtAttention")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 6, "$IAWM_BlowHorn")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 7, "$IAWM_Group_Surrender")
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 0,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 1,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 2,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 3,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 4,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 5,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 6,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 7,true)
		RegisterForModEvent("UIWheelMenu_ChooseOption", "OnChooseOption")
		RegisterForModEvent("UIWheelMenu_SetOption", "OnSelectOption")
		RegisterForModEvent("UIWheelMenu_LoadMenu", "OnLoadMenu")		
		RegisterForModEvent("UIWheelMenu_CloseMenu", "OnUnloadMenu")
		UIExtensions.OpenMenu("UIWheelMenu")
	endif
EndEvent



Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	IsOpenOp01.setvalue(0.0)
EndEvent


Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	IdleOp01.setvalue(numArg)
EndEvent	





Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	If result == 0
		IdlePlayProvokeSpell.cast(playerref)
	Elseif result == 1
		 IdlePlaySaluteSpell.cast(playerref)
	Elseif result == 2
		IdlePlayCleanSwordSpell.cast(playerref)
	Elseif result == 3
		IdlePlayPrisonerBeatSpell.cast(playerref)
	Elseif result == 4
		IdlePlayStretchingSpell.cast(playerref)
	Elseif result == 5
		IdlePlaySnapSpell.cast(playerref)
	Elseif result == 6	
		IdlePlayBlowHornSpell.cast(playerref)
	Elseif result == 7
		IdlePlayGroupSurrenderQuest.start()
	endif	
endevent	

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	self.Reset()
EndEvent  