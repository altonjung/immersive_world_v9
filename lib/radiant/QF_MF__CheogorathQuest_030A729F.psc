;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 20
Scriptname QF_MF__CheogorathQuest_030A729F Extends Quest Hidden

;BEGIN ALIAS PROPERTY Guest3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Guest3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCity
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theCity Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myNPC
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_myNPC Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Guest1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Guest1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHouseCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theHouseCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Guest2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Guest2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Madam
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Madam Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHouse
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHouse Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMainClient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMainClient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE mf_Rpg_CheogorathQuestScript
Quest __temp = self as Quest
mf_Rpg_CheogorathQuestScript kmyQuest = __temp as mf_Rpg_CheogorathQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.AllowEntry()
SetObjectiveDisplayed(0)
(Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
; Alias_theMainClient.GetRef().MoveTo(Alias_theHouseCenter.GetRef())
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE mf_Rpg_CheogorathQuestScript
Quest __temp = self as Quest
mf_Rpg_CheogorathQuestScript kmyQuest = __temp as mf_Rpg_CheogorathQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GetDressed()
SetObjectiveCompleted(0)
SetObjectiveDisplayed(100)
If (HandlerConditional.PerformanceRewardMod >= 0.6)
   Game.GetPlayer().AddItem(Gold001, 500)
EndIf
Alias_Guest1.GetRef().DeleteWhenAble()
Alias_Guest2.GetRef().DeleteWhenAble()
Alias_Guest3.GetRef().DeleteWhenAble()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN AUTOCAST TYPE mf_Rpg_CheogorathQuestScript
Quest __temp = self as Quest
mf_Rpg_CheogorathQuestScript kmyQuest = __temp as mf_Rpg_CheogorathQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.roundsCounter = 0
kmyQuest.PerformScene1()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN AUTOCAST TYPE mf_Rpg_CheogorathQuestScript
Quest __temp = self as Quest
mf_Rpg_CheogorathQuestScript kmyQuest = __temp as mf_Rpg_CheogorathQuestScript
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
SetObjectiveFailed(100)
kmyQuest.DisallowEntry()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN CODE
(Alias_theMainClient.GetRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN AUTOCAST TYPE mf_Rpg_CheogorathQuestScript
Quest __temp = self as Quest
mf_Rpg_CheogorathQuestScript kmyQuest = __temp as mf_Rpg_CheogorathQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GetNaked()
SetStage(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN AUTOCAST TYPE mf_Rpg_CheogorathQuestScript
Quest __temp = self as Quest
mf_Rpg_CheogorathQuestScript kmyQuest = __temp as mf_Rpg_CheogorathQuestScript
;END AUTOCAST
;BEGIN CODE
kmyQuest.DisallowEntry()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
(Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
SetObjectiveCompleted(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN AUTOCAST TYPE mf_Rpg_CheogorathQuestScript
Quest __temp = self as Quest
mf_Rpg_CheogorathQuestScript kmyQuest = __temp as mf_Rpg_CheogorathQuestScript
;END AUTOCAST
;BEGIN CODE
;kmyQuest.PerformScene2()   ;this doesn't exist for gangbang quest
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
(Alias_theMainClient.GetRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
(Alias_theMainClient.GetRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property Gold001  Auto  

mf_variables Property HandlerConditional  Auto  
