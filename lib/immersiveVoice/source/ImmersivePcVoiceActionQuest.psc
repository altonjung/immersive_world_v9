scriptname ImmersivePcVoiceActionQuest extends Quest

ReferenceAlias property actorRefAlias Auto

String version = "v0.1"

event OnInit()
	Debug.Notification("Load Immersive Pc Action " + version)
	
	Setup()
endEvent

function Setup()	
	PO3_Events_Alias.RegisterForItemHarvested(actorRefAlias)
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
