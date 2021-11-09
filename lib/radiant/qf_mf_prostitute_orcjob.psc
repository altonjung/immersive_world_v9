;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 12
Scriptname qf_mf_prostitute_orcjob Extends Quest Hidden

;BEGIN ALIAS PROPERTY theInn
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theInn Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCampChief
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCampChief Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theClient2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theClient2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCampEdge
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCampEdge Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theClient3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theClient3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theClient1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theClient1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theOrcHunter2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theOrcHunter2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theOrcCamp
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theOrcCamp Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theClient4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theClient4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCampCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCampCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theFarmer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theFarmer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theOrcHunter1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theOrcHunter1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theClient0
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theClient0 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE mf_orcjobquestscript
Quest __temp = self as Quest
mf_orcjobquestscript kmyQuest = __temp as mf_orcjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.ChiefSexScene()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE mf_orcjobquestscript
Quest __temp = self as Quest
mf_orcjobquestscript kmyQuest = __temp as mf_orcjobquestscript
;END AUTOCAST
;BEGIN CODE
; delete dynamic  NPC
Alias_theFarmer.GetRef().Delete()
Alias_theOrcHunter1.GetRef().Delete()
Alias_theOrcHunter2.GetRef().Delete()

Alias_theClient0.GetRef().Delete()
Alias_theClient1.GetRef().Delete()
Alias_theClient2.GetRef().Delete()
FailAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN AUTOCAST TYPE mf_orcjobquestscript
Quest __temp = self as Quest
mf_orcjobquestscript kmyQuest = __temp as mf_orcjobquestscript
;END AUTOCAST
;BEGIN CODE
; delete dynamic  NPC
Alias_theFarmer.GetRef().Delete()
Alias_theOrcHunter1.GetRef().Delete()
Alias_theOrcHunter2.GetRef().Delete()

Alias_theClient0.GetRef().Delete()
Alias_theClient1.GetRef().Delete()
Alias_theClient2.GetRef().Delete()
CompleteAllObjectives()
kmyQuest.GetFinalReward()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
SetObjectiveCompleted(10)
setObjectiveDisplayed(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE mf_orcjobquestscript
Quest __temp = self as Quest
mf_orcjobquestscript kmyQuest = __temp as mf_orcjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GroupSexScene()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE mf_orcjobquestscript
Quest __temp = self as Quest
mf_orcjobquestscript kmyQuest = __temp as mf_orcjobquestscript
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(0)
SetObjectiveDisplayed(10)
alias_theCampChief.GetRef().MoveTo(alias_theCampCenter.GetRef())
kmyQuest.TiedAndDragged()
SetStage(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
SetObjectiveCompleted(15)
SetObjectiveDisplayed(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_orcjobquestscript
Quest __temp = self as Quest
mf_orcjobquestscript kmyQuest = __temp as mf_orcjobquestscript
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(0)
kmyQuest.OrcJobArousal()
if(alias_theMapMarker.GetRef() != None)
 Alias_theMapMarker.GetRef().AddToMap()
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
