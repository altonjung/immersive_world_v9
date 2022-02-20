scriptname ImmersivePcVoiceStatusQuest extends Quest

String version = "v0.1"

event OnInit()
	Setup()
endEvent

function Setup()
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
