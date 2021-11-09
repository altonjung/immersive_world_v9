;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname mf_ProstituteJob_Yes_Cloths1 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
mf_Handler thisQuest = (GetOwningQuest() as mf_Handler)
thisQuest.SetStage(10)
thisQuest.SetObjectiveDisplayed(10)
thisQuest.SingleJobMonitorKicker(akSpeaker)
thisQuest.AddInitClothes()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
