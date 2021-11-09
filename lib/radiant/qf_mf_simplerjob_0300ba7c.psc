;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname qf_mf_simplerjob_0300ba7c Extends Quest Hidden

;BEGIN ALIAS PROPERTY theClient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theClient Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theInn
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theInn Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE mf_simplerjobscript
Quest __temp = self as Quest
mf_simplerjobscript kmyQuest = __temp as mf_simplerjobscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GiveFoodItem()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE mf_simplerjobscript
Quest __temp = self as Quest
mf_simplerjobscript kmyQuest = __temp as mf_simplerjobscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.SimplerArousalReset()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_simplerjobscript
Quest __temp = self as Quest
mf_simplerjobscript kmyQuest = __temp as mf_simplerjobscript
;END AUTOCAST
;BEGIN CODE
stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE mf_simplerjobscript
Quest __temp = self as Quest
mf_simplerjobscript kmyQuest = __temp as mf_simplerjobscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.GiveFoodItem()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
