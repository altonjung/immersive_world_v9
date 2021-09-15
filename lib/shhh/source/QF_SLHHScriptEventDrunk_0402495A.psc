;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname QF_SLHHScriptEventDrunk_0402495A Extends Quest Hidden

;BEGIN ALIAS PROPERTY TempAggressor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TempAggressor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TempAggressor02
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TempAggressor02 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Alias_TempAggressor.Clear()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;Aggressor.Clear()
Actor TempAggressorActor = Alias_TempAggressor.getref() as actor


If (SLHH.Getstage() > 0) && (SLHH.Getstage() <= 130)
Debug.Trace("SLHH Quest is already ongoing. Abort the trigger.")
Debug.notification("SLHH Quest is already ongoing. Abort the trigger.")
Alias_TempAggressor.Clear()
stop()
EndIf

slhhupkeep.AnimationStart(100, true)
SLHH.setstage(160)

While !SLHH.isrunning() || (SLHH.Getstage() == 160)
Utility.wait(5.0)
Debug.Trace("SLHH pending...")
EndWhile

If SLHH.isrunning()
SLHH_ScriptEventDrunk.setvalue(0); Yes Sex
slhhmonitor.GiveTempFaction(TempAggressorActor, true)
Aggressor.ForceRefTo(TempAggressorActor)
Debug.Trace(TempAggressorActor.getbaseobject().getname() + "is trying to hold me.")
Debug.Notification(TempAggressorActor.getbaseobject().getname() + "is trying to hold me.")
SLHH.setstage(132)
Utility.wait(5.0)
Setstage(10)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


Quest Property SLHH  Auto  

ReferenceAlias Property Aggressor  Auto  

Slhh_upkeep Property slhhupkeep auto

Faction Property SLHH_BaboDIaViceCaptainFaction  Auto  

slhh_Monitor Property slhhMonitor auto

GlobalVariable Property SLHH_ScriptEventDrunk  Auto  
