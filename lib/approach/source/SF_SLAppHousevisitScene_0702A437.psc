;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname SF_SLAppHousevisitScene_0702A437 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Actor TalkingActorRef
TalkingActorRef = TalkingActor.getreference() as actor
TalkingActor.clear()
StayingActor.forcerefto(TalkingActorRef)
stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property StayingActor  Auto  

ReferenceAlias Property talkingActor  Auto  
