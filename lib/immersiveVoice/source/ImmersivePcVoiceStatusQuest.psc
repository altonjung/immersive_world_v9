scriptname ImmersivePcVoiceStatusQuest extends Quest

String version = "v0.1"

event OnInit()
	Debug.Notification("Load Immersive Pc Status " + version)
	
	Setup()
endEvent

function Setup()
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
