Scriptname IdlePlayMenuOption02QuestScript extends Quest  

int result
actor property playerref auto
Spell property IdlePlayWordTeachSpell auto
Spell property IdlePlayStudySpell auto
Spell property IdlePlayReadBookSpell auto
Spell property IdlePlayWriteSpell auto
Spell property IdlePlayExamineSpell auto
Spell property IdlePlayNoteReadSpell auto
Spell property IdlePlayAgitatedSpell auto
Spell property IdlePlayDiscussSpell auto

GlobalVariable Property IdleOp02 auto
GlobalVariable Property IsOpenOp02 auto





Event OnInit()
	if self.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenOp02.setvalue(1.0)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 2, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 3, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 4, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 6, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 7, "$IAWM_Play_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_Teach")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_Study")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 2, "$IAWM_ReadBook")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 3, "$IAWM_TakeNotes")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 4, "$IAWM_Discuss")		
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_Examine")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 6, "$IAWM_ReadNote")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 7, "$IAWM_Agitate")
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
	IsOpenOp02.setvalue(0.0)
EndEvent


Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	IdleOp02.setvalue(numArg)
EndEvent	






Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	If result == 0	
		IdlePlayWordTeachSpell.cast(playerref)
	Elseif result == 1	
		IdlePlayStudySpell.cast(playerref)
	Elseif result == 2	
		IdlePlayReadBookSpell.cast(playerref)
	Elseif result == 3	
		IdlePlayWriteSpell.cast(playerref)
	Elseif result == 4
		IdlePlayDiscussSpell.cast(playerref)
	Elseif result == 5
		IdlePlayExamineSpell.cast(playerref)
	Elseif result == 6	
		IdlePlayNoteReadSpell.cast(playerref)
	Elseif result == 7	
		IdlePlayAgitatedSpell.cast(playerref)
	endif	
endevent	

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	self.Reset()
EndEvent  