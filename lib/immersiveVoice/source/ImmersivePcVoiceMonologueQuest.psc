scriptname ImmersivePcVoiceMonologueQuest extends Quest

ReferenceAlias property playerRefAlias Auto

String version = "v0.1"

event OnInit()
	Debug.Notification("Load Immersive Monologue " + version)
	
	Setup()
endEvent

function Setup()
	PO3_Events_Alias.RegisterForWeatherChange(playerRefAlias)
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
