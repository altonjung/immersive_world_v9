;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLAppViceCaptainTIF05 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
SLABQS.TakeArmor(Game.getplayer(), akspeaker, ArmorCuirass)
SLABQS.TakeArmor(Game.getplayer(), akspeaker, ClothingBody)
SLABQS.TakeArmor(Game.getplayer(), akspeaker, SLA_BraBikini)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SLApproachBaseQuestScript Property SLABQS Auto
Keyword Property Armorcuirass  Auto  

Keyword Property clothingbody  Auto  

Keyword Property SLA_BraBikini  Auto  
