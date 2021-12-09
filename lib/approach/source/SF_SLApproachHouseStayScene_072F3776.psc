;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname SF_SLApproachHouseStayScene_072F3776 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
int arousal = (StayingActor.getreference() as actor).getfactionrank(sla_arousal)
arousal += 30
(StayingActor.getreference() as actor).setfactionrank(sla_arousal, arousal)

if SLApproachDialogArousal.getvalue() as int <= arousal
;(StayingActor.getreference() as actor).Setactorvalue("Variable06", 5);For future update
endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
int arousal = (StayingActor.getreference() as actor).getfactionrank(sla_arousal)
arousal += 10
(StayingActor.getreference() as actor).setfactionrank(sla_arousal, arousal)

if SLApproachDialogArousal.getvalue() as int <= arousal
;(StayingActor.getreference() as actor).Setactorvalue("Variable06", 5);For future update
endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
int arousal = (StayingActor.getreference() as actor).getfactionrank(sla_arousal)
arousal += 40
(StayingActor.getreference() as actor).setfactionrank(sla_arousal, arousal)

if SLApproachDialogArousal.getvalue() as int <= arousal
;(StayingActor.getreference() as actor).Setactorvalue("Variable06", 5);For future update
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property StayingActor  Auto  

Faction Property sla_Arousal  Auto  

GlobalVariable Property SLApproachDialogArousal  Auto  
