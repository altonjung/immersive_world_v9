;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname PRKF_SLAPPDooLockPerk_0613FE7B Extends Perk Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
if akTargetRef == none
return 
endIf
key thisKey = akTargetRef.GetKey()
if akActor.GetItemCount(thisKey as form) > 0
akTargetRef.Lock(false, false)
else
SLAPP_UnLocktheDoor.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
if akTargetRef == none
return 
endIf
key thisKey = akTargetRef.GetKey()
if akActor.GetItemCount(thisKey as form) > 0
akTargetRef.Lock(true, false)
else
SLAPP_LocktheDoor.Show(0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
endIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akTargetRef, Actor akActor)
;BEGIN CODE
SLAMain.Openthedoor(akTargetRef)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef  Auto
SLApproachMainScript Property SLAMain Auto

Message Property SLAPP_LocktheDoor  Auto  

Message Property SLAPP_UnLocktheDoor  Auto  
