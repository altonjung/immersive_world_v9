scriptname ImmersivePcVoiceActionQuest extends Quest

ReferenceAlias property playerRefAlias Auto

String version = "v0.1"

event OnInit()
	Debug.Notification("Load Immersive Action " + version)
	
	Setup()
endEvent

function Setup()	
	PO3_Events_Alias.RegisterForBookRead(playerRefAlias)
	PO3_Events_Alias.RegisterForDragonSoulGained(playerRefAlias)
	PO3_Events_Alias.RegisterForItemHarvested(playerRefAlias)
	PO3_Events_Alias.RegisterForLevelIncrease(playerRefAlias)
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
