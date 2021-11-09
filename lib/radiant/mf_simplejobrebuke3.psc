;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 6
Scriptname mf_simplejobrebuke3 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_5
Function Fragment_5(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(GetOwningQuest() as mf_SimpleJobQuestScript).ForceSpeakerClient_WS(akSpeaker)
(GetOwningQuest() as mf_SimpleJobQuestScript).PerformRape()
(GetOwningQuest() as mf_SimpleJobQuestScript).Disatisfaction(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
