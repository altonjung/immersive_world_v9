;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 10
Scriptname qf_mf_prostitute_fanjob_0301ce4b Extends Quest Hidden

;BEGIN ALIAS PROPERTY theChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theSpawnPoint
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theSpawnPoint Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theGoon2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theGoon2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theFan
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theFan Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMapMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMapMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theCity
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theCity Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theGoon1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theGoon1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theGoon3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theGoon3 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN AUTOCAST TYPE mf_fanjobquestscript
Quest __temp = self as Quest
mf_fanjobquestscript kmyQuest = __temp as mf_fanjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GiveValuables()
kmyQuest.KnockOut()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE mf_fanjobquestscript
Quest __temp = self as Quest
mf_fanjobquestscript kmyQuest = __temp as mf_fanjobquestscript
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(0)
SetObjectiveDisplayed(100)
SetObjectiveCompleted(100)
kmyQuest.WSEndFanQuest()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
Alias_theFan.GetRef().Disable(true)
Alias_theGoon1.GetRef().Disable(true)
Alias_theGoon2.GetRef().Disable(true)

Alias_theFan.GetRef().Delete()
Alias_theGoon1.GetRef().Delete()
Alias_theGoon2.GetRef().Delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE mf_fanjobquestscript
Quest __temp = self as Quest
mf_fanjobquestscript kmyQuest = __temp as mf_fanjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.StripAndGiveItem()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE mf_fanjobquestscript
Quest __temp = self as Quest
mf_fanjobquestscript kmyQuest = __temp as mf_fanjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.OutOfHiding()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_fanjobquestscript
Quest __temp = self as Quest
mf_fanjobquestscript kmyQuest = __temp as mf_fanjobquestscript
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(0)
kmyQuest.FanJobArousal()
if(alias_theMapMarker.GetRef() != None)
 Alias_theMapMarker.GetRef().AddToMap()
endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE mf_fanjobquestscript
Quest __temp = self as Quest
mf_fanjobquestscript kmyQuest = __temp as mf_fanjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.OutOfHiding()
kmyQuest.StartFight()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE mf_fanjobquestscript
Quest __temp = self as Quest
mf_fanjobquestscript kmyQuest = __temp as mf_fanjobquestscript
;END AUTOCAST
;BEGIN CODE
; Remove player control
kmyQuest.StartRape()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN AUTOCAST TYPE mf_fanjobquestscript
Quest __temp = self as Quest
mf_fanjobquestscript kmyQuest = __temp as mf_fanjobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GetGear()
kmyQuest.GiveValuables()
kmyQuest.KnockOut()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
Actor akFan = alias_theFan.GetRef() as Actor
if(akFan.IsDead() || akFan.IsInCombat())
 SetStage(100)
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
