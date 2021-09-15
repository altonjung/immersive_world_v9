;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 34
Scriptname QF_SLHH_030012C4 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Player
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Player Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY aggressor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_aggressor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ThirdOne
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ThirdOne Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_25
Function Fragment_25()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
;Escaping Succeeded
kmyQuest.AnimationStart(50)
;SLHHMonitor.StruggleAnim((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor), True, BaboBackhugStruggling02G, BaboBackhugStruggling02M)
;Utility.wait(2.0)
;SLHHMonitor.StruggleAnim((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor), False, None, None)
Setstage(136)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_28
Function Fragment_28()
;BEGIN CODE
;Male Old
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_27
Function Fragment_27()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
;Animation Ended
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
kmyQuest.RegisterForSingleUpdateGameTime(2)
Utility.wait(5.0)
kmyQuest.AnimationStart(60)
;kmyquest.SLHHSceneRunningaway.start()
kmyQuest.Expression((Alias_Player.getRef() as Actor), True)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_24
Function Fragment_24()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_33
Function Fragment_33()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
kmyQuest.SLHHAnimStart((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor), 3)
kmyQuest.Expression((Alias_Player.getRef() as Actor), False, True)
kmyQuest.Expression((Alias_Aggressor.getRef() as Actor), False, False)
Utility.wait(5.0)
kmyQuest.ResistSelection((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor))
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_29
Function Fragment_29()
;BEGIN CODE
;Female Not Old
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_32
Function Fragment_32()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
;Struggling Animation Started
;(Alias_Aggressor.getRef() as Actor).AddSpell(SLHH_Paralyze)
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
kmyQuest.SLHHAnimStart((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor), 2)
kmyQuest.Expression((Alias_Player.getRef() as Actor), False, True)
kmyQuest.Expression((Alias_Aggressor.getRef() as Actor), False, False)
Utility.wait(5.0)
kmyQuest.ResistSelection((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor))
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_30
Function Fragment_30()
;BEGIN CODE
;Guard
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
;Struggling Animation Started
;(Alias_Aggressor.getRef() as Actor).AddSpell(SLHH_Paralyze)
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
kmyQuest.SLHHAnimStart((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor), 1)
kmyQuest.Expression((Alias_Player.getRef() as Actor), False, True)
kmyQuest.Expression((Alias_Aggressor.getRef() as Actor), False, False)
Utility.wait(5.0)
kmyQuest.ResistSelection((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor))
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
;(Alias_Aggressor.getRef() as Actor).RemoveSpell(SLHH_Paralyze)
;kmyQuest.AnimationStart(60)
kmyQuest.Action()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_31
Function Fragment_31()
;BEGIN CODE
;Creature Troll
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
If SLHHMonitorScript.getstage() >= 10 && SLHHMonitorScript.getstage() < 100
kmyQuest.AnimationStart(100)
EndIf

If (SLHHScriptEvent.getstage() == 0) && (SLHHScriptEvent.isrunning() == True)
SLHHScriptEvent.setstage(10)
EndIf

Alias_Aggressor.Clear()
Reset()
SetStage(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_26
Function Fragment_26()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
;Escaping failed
;kmyQuest.AnimationStart(30)
;Utility.wait(1.0)
;SLHHMonitor.StruggleAnim((Alias_Player.getRef() as Actor), (Alias_Aggressor.getRef() as Actor), False, None, None)
;Utility.wait(1.0)
Setstage(140)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN AUTOCAST TYPE SLHH_Upkeep
Quest __temp = self as Quest
SLHH_Upkeep kmyQuest = __temp as SLHH_Upkeep
;END AUTOCAST
;BEGIN CODE
kmyQuest.RegisterForSingleUpdateGameTime(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_23
Function Fragment_23()
;BEGIN CODE
(Alias_Aggressor.getRef() as Actor).EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property SLHH_Paralyze  Auto  


slhh_Monitor Property SLHHMonitor  Auto  

Idle Property BaboBackhugStruggling01G Auto

Idle Property BaboBackhugStruggling02G Auto

Idle Property BaboBackhugStruggling01M Auto

Idle Property BaboBackhugStruggling02M Auto

Quest Property SLHHMonitorScript  Auto  

Quest Property SLHHScriptEvent  Auto  
