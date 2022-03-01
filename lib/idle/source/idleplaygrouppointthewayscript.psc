Scriptname IdlePlayGroupPointtheWayScript extends Quest  

int result
actor property playerref auto

Spell property IdlePlayPointfar01Spell auto
Spell property IdlePlayPointfar02Spell auto
Spell property IdlePlayPointCloseSpell auto

GlobalVariable Property IdleGpPTW auto
GlobalVariable Property IsOpenGpPTW auto




Event OnInit()
	if self.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenGpPTW.setvalue(1.0)	
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_PointFar01")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_PointFar02")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_PointClose")
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 0,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 1,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 5,true)
		RegisterForModEvent("UIWheelMenu_ChooseOption", "OnChooseOption")
		RegisterForModEvent("UIWheelMenu_SetOption", "OnSelectOption")
		RegisterForModEvent("UIWheelMenu_LoadMenu", "OnLoadMenu")		
		RegisterForModEvent("UIWheelMenu_CloseMenu", "OnUnloadMenu")
		UIExtensions.OpenMenu("UIWheelMenu")
	endif
EndEvent



Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	IsOpenGpPTW.setvalue(0.0)
EndEvent


Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	IdleGpPTW.setvalue(numArg)
EndEvent	



Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	If result == 0
		IdlePlayPointfar01Spell.cast(playerref)
	Elseif result == 1
		IdlePlayPointfar02Spell.cast(playerref) 
	Elseif result == 5
		IdlePlayPointCloseSpell.cast(playerref)
	endif	
endevent	

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	self.Reset()
endevent	