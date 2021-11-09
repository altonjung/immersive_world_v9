;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 22
Scriptname qf_mf_prostitute_homeservice_03007998 Extends Quest Hidden

;BEGIN ALIAS PROPERTY theHouseCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theHouseCenter Auto
;END ALIAS PROPERTY

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

;BEGIN ALIAS PROPERTY theGuest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theGuest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myNPC
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_myNPC Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.PerformScene2()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.DisallowEntry()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetRef() as Actor).EvaluatePackage()
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

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
utility.wait(2)
kmyQuest.JobSatisfaction()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.PerformScene1()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
(Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
if(Alias_theGuest.GetReference() != None)
 (Alias_theGuest.GetReference() as Actor).EvaluatePackage()
endif
SetObjectiveFailed(100)
kmyQuest.DisallowEntry()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GetDressed()
if(alias_theGuest.GetRef() == None)
 SetObjectiveCompleted(0)
else
 SetObjectiveCompleted(1)
endif
SetObjectiveDisplayed(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GetNaked()
SetStage(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
(Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
if(Alias_theGuest.GetReference() != None)
 (Alias_theGuest.GetReference() as Actor).EvaluatePackage()
endif
SetObjectiveCompleted(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE mf_homejobquestscript
Quest __temp = self as Quest
mf_homejobquestscript kmyQuest = __temp as mf_homejobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.AllowEntry()
if(alias_theGuest.GetRef() == None)
 SetObjectiveDisplayed(0)
 (Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
 ; Alias_theMainClient.GetRef().MoveTo(Alias_theHouseCenter.GetRef())
else
 SetObjectiveDisplayed(1)
 (Alias_theMainClient.GetReference() as Actor).EvaluatePackage()
 (Alias_theGuest.GetReference() as Actor).EvaluatePackage()
endif
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

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
