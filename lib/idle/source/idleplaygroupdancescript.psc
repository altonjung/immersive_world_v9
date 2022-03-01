Scriptname IdlePlayGroupDanceScript extends Quest 

 
int result
actor property playerref auto

Spell property IdlePlayCiceroDance01Spell auto
Spell property IdlePlayCiceroDance02Spell auto
Spell property IdlePlayCiceroDance03Spell auto
Spell property IdlePlayDrinkDanceSpell auto

GlobalVariable Property IdleGpDC auto
GlobalVariable Property IsOpenGpDC auto



Event OnInit()
	if self.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenGpDC.setvalue(1.0)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 4, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_JokerDance01")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_JokerDance02")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 4, "$IAWM_JokerDance03")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_MugDance")
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 0,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 1,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 4,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 5,true)
		RegisterForModEvent("UIWheelMenu_ChooseOption", "OnChooseOption")
		RegisterForModEvent("UIWheelMenu_SetOption", "OnSelectOption")
		RegisterForModEvent("UIWheelMenu_LoadMenu", "OnLoadMenu")		
		RegisterForModEvent("UIWheelMenu_CloseMenu", "OnUnloadMenu")
		UIExtensions.OpenMenu("UIWheelMenu")
	endif
EndEvent



Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	IsOpenGpDC.setvalue(0.0)
EndEvent


Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	IdleGpDC.setvalue(numArg)
EndEvent	



Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	If result == 0
		IdlePlayCiceroDance01Spell.cast(playerref)
	Elseif result == 1
		IdlePlayCiceroDance02Spell.cast(playerref)
	Elseif result == 4
		IdlePlayCiceroDance03Spell.cast(playerref) 
	Elseif result == 5
		IdlePlayDrinkDanceSpell.cast(playerref)
	endif	
endevent	

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	self.Reset()
EndEvent  
