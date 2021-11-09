;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 41
Scriptname QF_mf_Prostitute_HomePerform_030AE92C Extends Quest Hidden

;BEGIN ALIAS PROPERTY Madam
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Madam Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCity
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theCity Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMainClient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMainClient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHouse
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHouse Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHouseCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theHouseCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myNPC
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_myNPC Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
kmyQuest.GetDressed()
SetObjectiveCompleted(10)
SetObjectiveDisplayed(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
kmyQuest.PerformScene1()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
kmyQuest.PerformScene3()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_34
Function Fragment_34()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_31
Function Fragment_31()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
kmyQuest.DisallowEntry()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_33
Function Fragment_33()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_36
Function Fragment_36()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_25
Function Fragment_25()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
SetObjectiveCompleted(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
SetObjectiveFailed(50)
kmyQuest.DisallowEntry()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_39
Function Fragment_39()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
utility.wait(2)
kmyquest.JobSatisfaction()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
kmyQuest.AllowEntry()
SetObjectiveDisplayed(10)
(Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
kmyQuest.GetNaked()
SetStage(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
kmyQuest.PerformScene2()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_35
Function Fragment_35()
;BEGIN AUTOCAST TYPE mf_homeperformancequest
Quest __temp = self as Quest
mf_homeperformancequest kmyQuest = __temp as mf_homeperformancequest
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
