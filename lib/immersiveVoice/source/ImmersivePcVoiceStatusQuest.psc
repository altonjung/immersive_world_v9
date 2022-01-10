scriptname ImmersivePcVoiceStatusQuest extends Quest

ReferenceAlias property playerRefAlias Auto

String version = "v0.1"

event OnInit()
	Debug.Notification("Load Immersive Status " + version)
	
	Setup()
endEvent

function Setup()
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
