scriptname ImmersivePcVoiceMonologueQuest extends Quest

ReferenceAlias property actorRefAlias Auto
String version = "v0.1"

event OnInit()
	Debug.Notification("Load Immersive Pc Monologue " + version)
	Setup()
endEvent

function Setup()
	PO3_Events_Alias.RegisterForWeatherChange(actorRefAlias)
endFunction

