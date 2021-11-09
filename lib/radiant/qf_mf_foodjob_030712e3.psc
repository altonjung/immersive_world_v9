;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 17
Scriptname QF_mf_FoodJob_030712E3 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Food0
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Food0 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FoodChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FoodChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Food3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Food3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY HungryOne
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_HungryOne Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Food4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Food4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Food1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Food1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Food2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Food2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Inn
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_Inn Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN AUTOCAST TYPE mf_FoodJob
Quest __temp = self as Quest
mf_FoodJob kmyQuest = __temp as mf_FoodJob
;END AUTOCAST
;BEGIN CODE
kmyQuest.initFood()
kmyQuest.checkClothsState()
SetStage(1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
