;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SF_SLAppAfterDrink_0737217B Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
SQuest.DrinkRapedby(talkingactor.GetReference() as Actor, 0)
stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SLAppPCSexQuestScript Property SQuest Auto
ReferenceAlias Property talkingActor  Auto  
