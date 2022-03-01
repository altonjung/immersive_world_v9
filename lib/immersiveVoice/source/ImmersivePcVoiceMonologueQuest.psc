scriptname ImmersivePcVoiceMonologueQuest extends Quest

ReferenceAlias property actorRefAliasForMonologue Auto
ReferenceAlias property actorRefAliasForAction Auto
ReferenceAlias property actorRefAliasForCombat Auto

String version = "v0.1"

event OnInit()
	Setup()
endEvent

function Setup()
	PO3_Events_Alias.RegisterForWeatherChange(actorRefAliasForMonologue)
endFunction