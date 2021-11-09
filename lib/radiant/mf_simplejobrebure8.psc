;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname mf_simplejobrebure8 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(GetOwningQuest() as mf_SimpleJobQuestScript).ForceSpeakerClient_WS(akSpeaker)
(GetOwningQuest() as mf_SimpleJobQuestScript).PerformRape()
(GetOwningQuest() as mf_SimpleJobQuestScript).Disatisfaction(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Quest Property Madame  Auto  
