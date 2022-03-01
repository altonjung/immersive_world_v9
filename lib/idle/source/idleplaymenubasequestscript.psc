Scriptname IdlePlayMenuBaseQuestScript extends Quest  

int result
actor property playerref auto
quest property IdlePlayWheelMenuBaseQuest auto
Quest Property IdlePlayWheelMenuOptionQuest000 auto
Quest Property IdlePlayWheelMenuOptionQuest001 auto
Quest Property IdlePlayWheelMenuOptionQuest002 auto
Quest Property IdlePlayWheelMenuOptionQuest003 auto
Quest Property IdlePlayWheelMenuOptionQuest004 auto
Quest Property IdlePlayWheelMenuOptionQuest005 auto
Quest Property IdlePlayWheelMenuOptionQuest006 auto

GlobalVariable Property idlemenu auto
GlobalVariable Property IsOpenBase auto
GlobalVariable property backupchoose auto

GlobalVariable property luteinstance auto
GlobalVariable property luteplaying auto

GlobalVariable property fluteinstance auto
GlobalVariable property fluteplaying auto

GlobalVariable property Druminstance auto
GlobalVariable property Drumplaying auto

message property LuteStopMes auto
message property FluteStopMes auto
message property DrumStopMes auto

int instancesound


Event OnInit()
	if IdlePlayWheelMenuBaseQuest.IsRunning() == 1
		UIExtensions.InitMenu("UIWheelMenu")
		IsOpenBase.setvalue(1.0)
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 0, "$IAWM_Select_Type")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 1, "$IAWM_Select_Type")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 2, "$IAWM_Select_Type")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 3, "$IAWM_Select_Type")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 4, "$IAWM_Select_Type")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 5, "$IAWM_Select_Type")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 6, "$IAWM_Select_Type")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionText", 7, "$IAWM_Stop_Idle")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 0, "$IAWM_Type:Option0")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 1, "$IAWM_Type:Option1")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 2, "$IAWM_Type:Option2")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 3, "$IAWM Type:Option3")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 4, "$IAWM_Type:Option4")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 5, "$IAWM_Type:Option5")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 6, "$IAWM_Type:Option6")
		UIExtensions.SetMenuPropertyIndexString("UIWheelMenu", "optionLabelText", 7, "$IAWM_Type:StopIdle")
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 0,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 1,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 2,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 3,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 4,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 5,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 6,true)
		UIExtensions.SetMenuPropertyIndexBool("UIWheelMenu", "optionEnabled", 7,true)
		RegisterForModEvent("UIWheelMenu_ChooseOption", "OnChooseOption")
		RegisterForModEvent("UIWheelMenu_LoadMenu", "OnLoadMenu")
		RegisterForModEvent("UIWheelMenu_CloseMenu", "OnUnloadMenu")
		RegisterForModEvent("UIWheelMenu_SetOption", "OnSelectOption")
		UIExtensions.OpenMenu("UIWheelMenu")
	endif
EndEvent


Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	IsOpenBase.setvalue(0.0)
EndEvent	



Event OnChooseOption(string eventName, string strArg, float numArg, Form formArg)
	result = numArg as Int
	if numArg != 7.0 && numArg >= 0
		backupchoose.setvalue(numArg)
	endif		
	If result == 0
		IdlePlayWheelMenuOptionQuest000.start()
	elseif result == 1
		IdlePlayWheelMenuOptionQuest001 .start()
	elseif result == 2	
		IdlePlayWheelMenuOptionQuest002 .start()
	elseif result == 3	
		IdlePlayWheelMenuOptionQuest003 .start()
	elseif result == 4	
		IdlePlayWheelMenuOptionQuest004 .start()
	elseif result == 5	
		IdlePlayWheelMenuOptionQuest005 .start()
	elseif result == 6	
		IdlePlayWheelMenuOptionQuest006 .start()
	elseif result == 7	
		Debug.SendAnimationEvent(playerref,"Idlestop")
		Debug.SendAnimationEvent(playerref,"OffsetStop")
		Debug.sendAnimationEvent(playerref, "IdleRailLeanExit")
		if playerref.GetSitState() == 3 || playerref.GetSitState() == 4
			debug.SendAnimationEvent(playerref,"IdleChairExitStart")
		endif	
		if luteplaying.getvalue() == 1.0
			instancesound = luteinstance.getvalue() as int
			sound.stopinstance(instancesound)
			luteplaying.setvalue(0.0) 
			LuteStopMes.show()
		endif	
		if fluteplaying.getvalue() == 1.0
			instancesound = fluteinstance.getvalue() as int
			sound.stopinstance(instancesound)
			fluteplaying.setvalue(0.0) 
			FluteStopMes.show()
		endif
		if drumplaying.getvalue() == 1.0
			instancesound = druminstance.getvalue() as int
			sound.stopinstance(instancesound)
			drumplaying.setvalue(0.0) 
			DrumStopMes.show()
		endif		
	endif
EndEvent	



Event OnSelectOption(string eventName, string strArg, float numArg, Form formArg)
	if numArg == 7.0
		idlemenu.setvalue(backupchoose.getvalue())
		debug.trace("backupchoose is" + backupchoose.getvalue())
	else	
		idlemenu.setvalue(numArg)
	endif	
endevent	

			

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	IdlePlayWheelMenuBaseQuest.Reset()
EndEvent