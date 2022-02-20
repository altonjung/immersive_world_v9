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

	PO3_Events_Alias.RegisterForBookRead(actorRefAliasForAction)
	; PO3_Events_Alias.RegisterForDragonSoulGained(actorRefAliasForAction)
	PO3_Events_Alias.RegisterForItemHarvested(actorRefAliasForAction)

	PO3_Events_Alias.RegisterForActorKilled(actorRefAliasForCombat)
endFunction