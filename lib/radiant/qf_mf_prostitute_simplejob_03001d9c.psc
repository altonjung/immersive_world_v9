;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 22
Scriptname qf_mf_prostitute_simplejob_03001d9c Extends Quest Hidden

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY myNPC
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_myNPC Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theInn
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theInn Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theClient
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_theClient Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN AUTOCAST TYPE mf_simplejobquestscript
Quest __temp = self as Quest
mf_simplejobquestscript kmyQuest = __temp as mf_simplejobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.Perform()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_simplejobquestscript
Quest __temp = self as Quest
mf_simplejobquestscript kmyQuest = __temp as mf_simplejobquestscript
;END AUTOCAST
;BEGIN CODE
kmyQuest.Collect()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN AUTOCAST TYPE mf_simplejobquestscript
Quest __temp = self as Quest
mf_simplejobquestscript kmyQuest = __temp as mf_simplejobquestscript
;END AUTOCAST
;BEGIN CODE
utility.wait(1)
kmyQuest.SimpleJobSatisfaction()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN AUTOCAST TYPE mf_simplejobquestscript
Quest __temp = self as Quest
mf_simplejobquestscript kmyQuest = __temp as mf_simplejobquestscript
;END AUTOCAST
;BEGIN CODE
;kmyQuest.ResumePooling()  ;this function no longer exists, quest start is handled by ResetVariables() and called separately
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
