;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname QF_mf_GettingStuffBack_0301FEE8 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLootChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theLootChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theMerchant
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theMerchant Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theVendorChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theVendorChest Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theInterChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theInterChest Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE mf_GettingStuffQuestScript
Quest __temp = self as Quest
mf_GettingStuffQuestScript kmyQuest = __temp as mf_GettingStuffQuestScript
;END AUTOCAST
;BEGIN CODE
CompleteQuest()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_GettingStuffQuestScript
Quest __temp = self as Quest
mf_GettingStuffQuestScript kmyQuest = __temp as mf_GettingStuffQuestScript
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(0)
kmyQuest.RemoveValuables()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
