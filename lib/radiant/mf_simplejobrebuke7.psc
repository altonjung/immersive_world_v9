;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname mf_simplejobrebuke7 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_3
Function Fragment_3(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(GetOwningQuest() as mf_SimpleJobQuestScript).ForceSpeakerClient_WS(akSpeaker)
(GetOwningQuest() as mf_SimpleJobQuestScript).PerformRape()
(GetOwningQuest() as mf_SimpleJobQuestScript).Disatisfaction(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property Handler  Auto  