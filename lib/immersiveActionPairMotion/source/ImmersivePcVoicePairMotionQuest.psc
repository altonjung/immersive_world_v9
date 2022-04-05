scriptname ImmersivePcVoiceActionQuest extends Quest

ReferenceAlias property actorRefAlias Auto

String version = "v0.1"

event OnInit()
	Setup()
endEvent

function Setup()
	PO3_Events_Alias.RegisterForItemHarvested(actorRefAlias)
endFunction