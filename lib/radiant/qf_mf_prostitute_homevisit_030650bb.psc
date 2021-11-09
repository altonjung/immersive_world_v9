;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 22
Scriptname qf_mf_prostitute_homevisit_030650bb Extends Quest Hidden

;BEGIN ALIAS PROPERTY theLoserWhore
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLoserWhore Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCoworker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theCoworker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theWinnerWhore
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theWinnerWhore Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theFriend
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theFriend Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMainClient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMainClient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCity
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theCity Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHouse
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHouse Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHouseCenter
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theHouseCenter Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMadam
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMadam Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLoser
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLoser Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myNPC
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_myNPC Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theWinner
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theWinner Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
setObjectiveDisplayed(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN AUTOCAST TYPE mf_homevisit_quest
Quest __temp = self as Quest
mf_homevisit_quest kmyQuest = __temp as mf_homevisit_quest
;END AUTOCAST
;BEGIN CODE
kmyQuest.DisallowEntry()

Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
SetObjectiveDisplayed(3)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
setObjectiveCompleted(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE mf_homevisit_quest
Quest __temp = self as Quest
mf_homevisit_quest kmyQuest = __temp as mf_homevisit_quest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(0)
kmyQuest.suckHimDry()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE mf_homevisit_quest
Quest __temp = self as Quest
mf_homevisit_quest kmyQuest = __temp as mf_homevisit_quest
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(0)
kmyQuest.TheBetArousal()
kmyQuest.AllowEntry()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
FailAllObjectives()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
SetObjectiveDisplayed(3)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
