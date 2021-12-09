;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SF_SLApproachScanningInnScen_071AF544 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
if (Alias_ManA.GetReference() as Actor).getactorvalue("Variable06") == 0
int RandomVariable = Utility.randomint(1, 4)
(Alias_ManA.GetReference() as Actor).Setactorvalue("Variable06", RandomVariable)
endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property Alias_ManA Auto
