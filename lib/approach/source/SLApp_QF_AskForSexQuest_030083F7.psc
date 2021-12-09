;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 14
Scriptname SLApp_QF_AskForSexQuest_030083F7 Extends Quest Hidden

;BEGIN ALIAS PROPERTY PlayerRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouseCOC
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerHouseCOC Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouseDoor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerHouseDoor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouseCenterMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerHouseCenterMarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FollowerRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FollowerRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY talkingActor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_talkingActor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY StayingActor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_StayingActor Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
self.SetStage(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
;Visitor Event Started
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
;if (!QuestScript.PCApproachOngoing)
;if (!QuestScript.approachEnding)
;QuestScript.endApproach()
;endif
Setstage(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_12
Function Fragment_12()
;BEGIN CODE
;The visitor came in
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
;He's staying
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
;The visitor left.
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SLAppPCSexQuestScript Property QuestScript Auto
