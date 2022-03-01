Scriptname IdlePlayWheelMenuHotKeyNew extends SKI_ConfigBase  


Int Property IdleMenuHotKey auto hidden
Int SetKey
actor property playerref auto

quest property IdlePlayWheelMenuBaseQuest auto
quest property IdlePlayWheelMenuOptionQuest000 auto
quest property IdlePlayWheelMenuOptionQuest001 auto
quest property IdlePlayWheelMenuOptionQuest002 auto
quest property IdlePlayWheelMenuOptionQuest003 auto
quest property IdlePlayWheelMenuOptionQuest004 auto
quest property IdlePlayWheelMenuOptionQuest005 auto
quest property IdlePlayWheelMenuOptionQuest006 auto




Event OnKeyDown(Int KeyCode)
	if keycode == IdleMenuHotKey
		if	playerref.IsRunning() == false && playerref.IsOnMount() == false && playerref.IsSwimming() == 0 && playerref.IsSprinting() == 0 \
		&& playerref.GetFlyingState() == 0 && Utility.IsInMenuMode() == false && Game.IsMenuControlsEnabled() == true && Game.IsActivateControlsEnabled() == true \
		&& Game.IsMovementControlsEnabled() == true && IdlePlayWheelMenuBaseQuest.IsRunning() == 0 && IdlePlayWheelMenuOptionQuest000.IsRunning() == 0 && IdlePlayWheelMenuOptionQuest001.IsRunning() == 0 && \
		IdlePlayWheelMenuOptionQuest002.IsRunning() == 0 && IdlePlayWheelMenuOptionQuest003.IsRunning() == 0 && IdlePlayWheelMenuOptionQuest004.IsRunning() == 0 \
		&& IdlePlayWheelMenuOptionQuest005.IsRunning() == 0 && IdlePlayWheelMenuOptionQuest006.IsRunning() == 0 && UI.IsMenuOpen("Crafting Menu") == false

		IdlePlayWheelMenuBaseQuest.start()
		endif
	endif
endevent	



Event onconfiginit()
	Pages = new string[1]
	Pages[0] = "$Hotkey_Set"
endevent

event OnPageReset(string page)
	if page == "$Hotkey_Set"
		SetCursorFillMode(LEFT_TO_RIGHT) 
		SetKey = AddKeyMapOption("$IAWM_Hotkey", IdleMenuHotKey)
	endif	
endevent




event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	if option == SetKey
			bool continue = true
		if (conflictControl != "")
			string msg
			if (conflictName != "")
				msg = "This key is already mapped to:\n\"" + conflictControl + GetCustomControl(keyCode) + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
			else
				msg = "This key is already mapped to:\n\"" + conflictControl + GetCustomControl(keyCode) + "\"\n\nAre you sure you want to continue?"
			endIf

			continue = ShowMessage(msg, true, "$Yes", "$No")
		endIf

		if (continue)
		IdleMenuHotKey = keyCode
		SetKeyMapOptionValue(SetKey, IdleMenuHotKey)
		endif
	endIf
	endEvent		
	
event OnOptionHighlight(int option)
	if option == SetKey 	
		SetInfoText("$IAWM_HighLight")
	endIf
endEvent	

Event OnConfigClose()
	UnregisterForAllKeys()
	if IdleMenuHotKey != 1
		RegisterForKey(IdleMenuHotKey)
	endif	
EndEvent

string function GetCustomControl(int keyCode)
	if (keyCode == SetKey)
		return "$IAWM_Hotkey"
	else
		return ""
	endIf
endFunction
