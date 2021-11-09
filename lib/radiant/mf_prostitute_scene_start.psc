;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 52
Scriptname mf_prostitute_scene_start Extends Scene Hidden

;BEGIN FRAGMENT Fragment_45
Function Fragment_45()
;BEGIN CODE
(GetOwningQuest() as mf_WhoreSexSceneVar).ClientFollowWhore = 1
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_37
Function Fragment_37()
;BEGIN CODE
Debug.Notification("a wench is on a job")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_47
Function Fragment_47()
;BEGIN CODE
(GetOwningQuest() as mf_WhoreSexSceneVar).ClientFollowWhore = 0
(akClient.GetReference() as Actor).EvaluatePackage()
(GetOwningQuest() as mf_WhoreSexScene).StartScene()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property akClient  Auto  
