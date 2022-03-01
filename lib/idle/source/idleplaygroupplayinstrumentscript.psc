Scriptname IdlePlayGroupPlayInstrumentScript extends Quest  


int result
actor property playerref auto

Spell property IdlePlayDrumStartSpell auto
Spell property IdlePlayFluteStartSepll auto
Spell property IdlePlayLuteStartSpell auto

GlobalVariable Property IdleGpPS auto
GlobalVariable Property IsOpenGpPS auto




Event OnInit()
	if self.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenGpPS.setvalue(1.0)	
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_PlayDrum")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_PlayFlute")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_PlayLute")
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
	IsOpenGpPS.setvalue(0.0)
EndEvent


Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	IdleGpPS.setvalue(numArg)
EndEvent	


Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	If result == 0
		IdlePlayDrumStartSpell.cast(playerref)
	Elseif result == 1
		IdlePlayFluteStartSepll.cast(playerref) 
	Elseif result == 5
		IdlePlayLuteStartSpell.cast(playerref)
	endif	
endevent	

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	self.Reset()
EndEvent  