;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname QF_mf_SoliciteProstitute_0300BA71 Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theProstitute
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theProstitute Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_SolicitProstitute
Quest __temp = self as Quest
mf_SolicitProstitute kmyQuest = __temp as mf_SolicitProstitute
;END AUTOCAST
;BEGIN CODE
kmyQuest.PerformSex()
SetStage(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN AUTOCAST TYPE mf_SolicitProstitute
Quest __temp = self as Quest
mf_SolicitProstitute kmyQuest = __temp as mf_SolicitProstitute
;END AUTOCAST
;BEGIN CODE
kmyQuest.StopFollow()
Reset()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
