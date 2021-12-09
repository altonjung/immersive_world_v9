;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 4
Scriptname PRKF_SLAPPDoorLockKeyPerk_0729D59F Extends Perk Hidden

;BEGIN FRAGMENT Fragment_3
Function Fragment_3(ObjectReference akTargetRef, Actor akActor)
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

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef  Auto
SLApproachMainScript Property SLAMain Auto

Message Property SLAPP_LocktheDoor  Auto  
