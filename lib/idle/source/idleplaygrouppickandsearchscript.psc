Scriptname IdlePlayGroupPickandSearchScript extends Quest  

int result
actor property playerref auto

Spell property IdlePlaySearchingChestSpell auto
Spell property IdlePlaySearchingTableSpell auto
Spell property IdlePlayPickupSpell auto
Spell property IdlePlaySearchBodySpell auto

GlobalVariable Property IdleGpPaS auto
GlobalVariable Property IsOpenGpPas auto





Event OnInit()
	if self.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenGpPas.setvalue(1.0)	
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 2, "$IAWM_Play_Idle")		
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_CrouchSearch")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_StandSearch")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 2, "$IAWM_KneelSearch")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_PickUp")
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 0,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 1,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 2,true)		
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 5,true)
		RegisterForModEvent("UIWheelMenu_ChooseOption", "OnChooseOption")
		RegisterForModEvent("UIWheelMenu_SetOption", "OnSelectOption")
		RegisterForModEvent("UIWheelMenu_LoadMenu", "OnLoadMenu")		
		RegisterForModEvent("UIWheelMenu_CloseMenu", "OnUnloadMenu")
		UIExtensions.OpenMenu("UIWheelMenu")
	endif
EndEvent


Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	IsOpenGpPas.setvalue(0.0)
EndEvent


Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	IdleGpPaS.setvalue(numArg)
EndEvent	



Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	If result == 0
		IdlePlaySearchingChestSpell.cast(playerref)
	Elseif result == 1
		IdlePlaySearchingTableSpell.cast(playerref) 
	Elseif result == 2
		IdlePlaySearchBodySpell.cast(playerref) 		
	Elseif result == 5
		IdlePlayPickupSpell.cast(playerref)
	endif	
endevent	

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	self.Reset()
endevent	