;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 14
Scriptname qf_mf_prostitute_campanionra_030455c9 Extends Quest Hidden

;BEGIN ALIAS PROPERTY theClient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theClient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY wolf1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_wolf1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Werewolf3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Werewolf3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RapeCagePoint
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RapeCagePoint Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Madam
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Madam Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Werewolf1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Werewolf1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Werewolf2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Werewolf2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Wolf2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Wolf2 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
SetObjectiveCompleted(20)
SetObjectiveDisplayed(30)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
FailAllObjectives()
Alias_Werewolf1.GetRef().Disable(true)
Alias_Werewolf1.GetRef().Delete()
Alias_Werewolf2.GetRef().Disable(true)
Alias_Werewolf2.GetRef().Delete()
Alias_Werewolf3.GetRef().Disable(true)
Alias_Werewolf3.GetRef().Delete()

Alias_Wolf1.GetRef().Disable(true)
Alias_Wolf1.GetRef().Delete()
Alias_Wolf2.GetRef().Disable(true)
Alias_Wolf2.GetRef().Delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
CompleteAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
SetObjectiveCompleted(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
SetObjectiveCompleted(10)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_companionrape_quest
Quest __temp = self as Quest
mf_companionrape_quest kmyQuest = __temp as mf_companionrape_quest
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(0)
kmyQuest.CompanionArousal()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
