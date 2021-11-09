;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 21
Scriptname qf_mf_prostitute_giantsacref_0304fd4e Extends Quest Hidden

;BEGIN ALIAS PROPERTY Giant2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Giant2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY GiantCampEdge
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_GiantCampEdge Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Madam
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Madam Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Giant1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Giant1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Farmer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Farmer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY GiantCampMiddle
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_GiantCampMiddle Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY GiantCamp
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_GiantCamp Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Hold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_Hold Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE mf_giantsacrificequest
Quest __temp = self as Quest
mf_giantsacrificequest kmyQuest = __temp as mf_giantsacrificequest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(0)
SetObjectiveDisplayed(5)
kmyQuest.goToCamp()
kmyQuest.giantRape()
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

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
SetObjectiveCompleted(0)
SetObjectiveDisplayed(6)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
SetObjectiveCompleted(10)
setObjectiveDisplayed(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_giantsacrificequest
Quest __temp = self as Quest
mf_giantsacrificequest kmyQuest = __temp as mf_giantsacrificequest
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(0)
kmyQuest.GiantArousal()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE mf_giantsacrificequest
Quest __temp = self as Quest
mf_giantsacrificequest kmyQuest = __temp as mf_giantsacrificequest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(6)
SetObjectiveDisplayed(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
SetObjectiveCompleted(5)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
SetObjectiveCompleted(10)
setObjectiveDisplayed(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
SetObjectiveCompleted(5)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE mf_giantsacrificequest
Quest __temp = self as Quest
mf_giantsacrificequest kmyQuest = __temp as mf_giantsacrificequest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(0)
SetObjectiveDisplayed(5)
kmyQuest.goToCamp()
kmyQuest.giantRape()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
SetObjectiveCompleted(10)
setObjectiveDisplayed(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
SetObjectiveCompleted(6)
SetObjectiveDisplayed(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
Alias_Farmer.trytodisable()
Alias_Farmer.getRef().delete()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
