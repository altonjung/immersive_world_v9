;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLAppViceCaptainTIF01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
SLABQS.TakeArmor(Game.getplayer(), akspeaker, SLA_ThongT)
SLABQS.TakeArmor(Game.getplayer(), akspeaker, SLA_ThongLowleg)
SLABQS.TakeArmor(Game.getplayer(), akspeaker, SLA_ThongCString)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


SLApproachBaseQuestScript Property SLABQS Auto
Keyword Property SLA_ThongCString  Auto  

Keyword Property SLA_ThongLowleg  Auto  

Keyword Property SLA_ThongT  Auto  
