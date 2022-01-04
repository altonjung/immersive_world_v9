scriptname ImmersivePcVoiceCombatQuest extends Quest

ReferenceAlias property playerRefAlias Auto

String version = "v0.1"

event OnInit()
	Debug.Notification("Load Immersive Combat " + version)
	
	Setup()
endEvent

function Setup()
	PO3_Events_Alias.RegisterForActorKilled(playerRefAlias)
endFunction

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
