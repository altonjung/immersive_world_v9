;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname SF_SLApproachScanningPlayerH_071AA433 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
SLAPPMarker_DoorKnock.Play(SLAPPTalkingActivaterRef)
SLAKnockCount.setvalue(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
SLAPPMarker_DoorKnock.Play(SLAPPTalkingActivaterRef)
SLAKnockCount.setvalue(4)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
SLAPPMarker_DoorKnock.Play(SLAPPTalkingActivaterRef)
SLAKnockCount.setvalue(2)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
GetOwningQuest().SetStage(49)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
SLAPPMarker_DoorKnock.Play(SLAPPTalkingActivaterRef)
SLAKnockCount.setvalue(3)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SLAPPMarker_DoorKnock.Play(SLAPPTalkingActivaterRef)
SLAKnockCount.setvalue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
SLAKnockCount.setvalue(0)
stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Sound Property SLAPPMarker_DoorClose  Auto  
Sound Property SLAPPMarker_DoorKnob  Auto  
Sound Property SLAPPMarker_DoorKnock  Auto  

ObjectReference Property SLAPPTalkingActivaterRef  Auto  

SLAppPCSexQuestScript Property SLAPPPCSexQuest Auto  

GlobalVariable Property SLAKnockCount  Auto  
