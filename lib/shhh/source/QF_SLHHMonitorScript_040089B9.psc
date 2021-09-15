;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname QF_SLHHMonitorScript_040089B9 Extends Quest Hidden

;BEGIN ALIAS PROPERTY PlayerRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerRepresentativeNegotiating
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerRepresentativeNegotiating Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerRepresentative
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerRepresentative Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY AggressorRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_AggressorRef Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;This is the starting point
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
;Debug.notification("Monitor Ended")
(Alias_PlayerRepresentative.getref() as objectreference).moveto(SlHHReturnPoint)
SLHHMonitorScriptScene01.Stop()
Reset()
SetStage(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE slhh_Monitor
Quest __temp = self as Quest
slhh_Monitor kmyQuest = __temp as slhh_Monitor
;END AUTOCAST
;BEGIN CODE
kmyquest.XmarkerMove(True)
SLHHMonitorScriptScene01.Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
(Alias_PlayerRepresentative.getref() as objectreference).moveto(SlHHReturnPoint)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property SLHHMonitorScriptScene01  Auto  

ObjectReference Property SlHHReturnPoint  Auto  
