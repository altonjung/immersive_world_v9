;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 8
Scriptname QF_SLApproachScanningPlayerH_06117645 Extends Quest Hidden

;BEGIN ALIAS PROPERTY VisitorRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_VisitorRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ChildRef02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ChildRef02 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY OldLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_OldLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouseTalkingActivater
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerHouseTalkingActivater Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouseCOC
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerHouseCOC Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ChildRef01
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ChildRef01 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouse
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_PlayerHouse Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BackXmarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_BackXmarker Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouseDoor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerHouseDoor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SpouseRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SpouseRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY FollowerRef
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_FollowerRef Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouseCenterMarkerActivater
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerHouseCenterMarkerActivater Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PlayerHouseCenterMarker
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PlayerHouseCenterMarker Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; A visitor came
SLApproachScanningPlayerHouseKnockScene.stop()
(Alias_PlayerHouseCenterMarkerActivater.getreference()).moveto(Alias_BackXmarker.getreference())
(Alias_PlayerHouseTalkingActivater.getreference()).moveto(Alias_BackXmarker.getreference())
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
;Status: Standby
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
; A visitor left
Debug.messagebox("It looks like the visitor has left.")
(Alias_PlayerHouseCenterMarkerActivater.getreference()).moveto(Alias_BackXmarker.getreference())
(Alias_PlayerHouseTalkingActivater.getreference()).moveto(Alias_BackXmarker.getreference())
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
objectreference PlayerHouseDoorRef = Alias_PlayerHouseDoor.getreference()
(Alias_PlayerHouseCenterMarkerActivater.getreference()).Activate(Alias_PlayerRef.GetReference() as Actor)
SLApproachScanningPlayerHouseKnockScene.start()
(Alias_PlayerHouseCenterMarkerActivater.getreference()).moveto(PlayerHouseDoorRef, 0, 0, 0)
(Alias_PlayerHouseTalkingActivater.getreference()).moveto(PlayerHouseDoorRef, 0, 0, 100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
;Debug.notification("SLAPPChangeLocationTest")
;objectreference Doorobj = Alias_PlayerHouseDoor.getref() as objectreference
;ObjectReference linkedRef = Doorobj.GetLinkedRef()
;Location linkedRefLocation = linkedRef.getcurrentlocation()
;If linkedRefLocation == Alias_OldLocation.getlocation()
;Debug.notification(linkedRef + " and " + Doorobj + " is linked.")
;Else
;Debug.notification("LinkDoor Detect Failed")
;EndIf
setstage(5)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
(Alias_PlayerHouseCenterMarkerActivater.getreference()).moveto(Alias_BackXmarker.getreference())
(Alias_PlayerHouseTalkingActivater.getreference()).moveto(Alias_BackXmarker.getreference())
(Alias_PlayerHouseTalkingActivater.getreference() as SLAPPOnEnterTriggerScript).ReArmTrigger()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property SLApproachScanningPlayerHouseKnockScene  Auto  
