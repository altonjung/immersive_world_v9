Scriptname ImmersivePcVoiceMCM extends SKI_ConfigBase
{MCM Menu}

bool Property enableStatusSound = true Auto
bool Property enableActionSound = true Auto
bool Property enableCombatSound = true Auto

Quest property pcVoiceStatus Auto
Quest property pcVoiceAction Auto
Quest property pcVoiceCombat Auto


int optionIDs = 0

int optionCombatId
int optionStatusId
int optionActionId

int function GetVersion()
  return 20220110
endFunction

event OnConfigOpen()
  ; Reload the JSON data automatically each time the MCM is opened
  optionIDs = JValue.retain(JMap.object())
endEvent

event OnConfigClose() 
  JValue.release(optionIDs)
endEvent

Event OnGameReload()
	parent.OnGameReload()
	Debug.notification(GetVersion())
EndEvent

event OnPageReset(string page)
  ; SetCursorFillMode(LEFT_TO_RIGHT)
  SetCursorFillMode(TOP_TO_BOTTOM)

  UnloadCustomContent()
  ; AddEmptyOption()
  AddHeaderOption("Player Voice Settings")

  optionCombatId = AddToggleOption("Combat", enableCombatSound)
  optionStatusId = AddToggleOption("Status", enableStatusSound)
  optionActionId = AddToggleOption("Action", enableActionSound)

  JMap.clear(optionIDs)
	; endIf
endEvent

event OnOptionSelect(int option)
  if optionCombatId == option 
    enableCombatSound = !enableCombatSound
    SetToggleOptionValue(optionCombatId, enableCombatSound)

    if pcVoiceCombat.IsRunning()
      pcVoiceCombat.setActive(enableCombatSound)
    endif
  elseif optionStatusId == option
    enableStatusSound = !enableStatusSound
    SetToggleOptionValue(optionStatusId, enableStatusSound)

    if pcVoiceStatus.IsRunning()
      pcVoiceStatus.setActive(enableStatusSound)
    endif
  else 
    enableActionSound = !enableActionSound
    SetToggleOptionValue(optionActionId, enableActionSound)

    if pcVoiceAction.IsRunning()
      pcVoiceAction.setActive(enableActionSound)
    endif
  endif
endEvent

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
