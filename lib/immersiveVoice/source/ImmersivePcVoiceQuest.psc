scriptname ImmersivePcVoiceQuest extends Quest

Actor property playerRef Auto
ReferenceAlias property playerRefAlias Auto

String version = "v0.1"

event OnInit()
	Debug.Notification("Load Immersive PC Voice " + version)
	
	Setup()
endEvent

function Setup()
	PO3_Events_Alias.RegisterForBookRead(playerRefAlias)
	PO3_Events_Alias.RegisterForDragonSoulGained(playerRefAlias)
	PO3_Events_Alias.RegisterForItemHarvested(playerRefAlias)
	PO3_Events_Alias.RegisterForLevelIncrease(playerRefAlias)
	PO3_Events_Alias.RegisterForLocationDiscovery(playerRefAlias)
	PO3_Events_Alias.RegisterForWeatherChange(playerRefAlias)
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
