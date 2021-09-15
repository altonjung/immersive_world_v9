Scriptname _SLS_IntSgo Hidden 

Int Function GetGemCapacityMax(Quest SgoQuest) Global
	Return (SgoQuest as dcc_sgo_QuestController).OptGemMaxCapacity
EndFunction

Float Function ActorGemGetPercent(Quest SgoQuest, Actor akTarget) Global
	Return (SgoQuest as dcc_sgo_QuestController).ActorGemGetPercent(akTarget)
EndFunction

Int Function ActorGemGetCount(Quest SgoQuest, Actor akTarget) Global
	Return (SgoQuest as dcc_sgo_QuestController).ActorGemGetCount(akTarget)
EndFunction

Int Function GetMilkCapacity(Quest SgoQuest, Actor akTarget) Global
	Return (SgoQuest as dcc_sgo_QuestController).ActorMilkGetCapacity(akTarget)
EndFunction
