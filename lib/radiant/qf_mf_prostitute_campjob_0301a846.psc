;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 23
Scriptname qf_mf_prostitute_campjob_0301a846 Extends Quest Hidden

;BEGIN ALIAS PROPERTY theInn
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theInn Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCamp
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theCamp Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCampMapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCampMapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCampCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCampCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theInnCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theInnCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCurrentClient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCurrentClient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Madam
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Madam Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCoworker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCoworker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theSecondClient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theSecondClient Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.setNextStage(200)
SetObjectiveCompleted(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.setNextStage(250)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.setNextStage(100)
setObjectiveCompleted(1)
SetObjectiveDisplayed(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.setNextStage(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.setNextStage(10)
kmyQuest.Perform()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.setNextStage(201)
FailAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(0)
Alias_theCampMapMarker.GetRef().AddToMap()

Actor base = Alias_theCoworker.GetRef() as actor
kmyQuest.CampJobArousal()

if(base)
    Debug.Notification("Base is filled")
    base = Alias_TheInnCenter.GetRef().PlaceActorAtMe(base.GetBaseObject() as ActorBase) as Actor
    Alias_theCoworker.ForceRefTo(base)
endIf

Actor akCoworker = Alias_theCoworker.GetRef() as Actor
akCoworker.enable()
akCoworker.MoveTo(Alias_TheInnCenter.GetRef())
akCoworker.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.setNextStage(1)
(Alias_theCoworker.GetRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN AUTOCAST TYPE mf_campjobquestscript
Quest __temp = self as Quest
mf_campjobquestscript kmyQuest = __temp as mf_campjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.setNextStage(2)
(Alias_theCoworker.GetRef() as Actor).EvaluatePackage()
SetObjectiveCompleted(0)
SetObjectiveDisplayed(1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
