;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname SF_SLHHMonitorScriptNegotiat_0401872C Extends Scene Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
If (SLHHMonitor.NegotiationSuccessPossibility) as int >= 100
SLHHMonitor.ScenarioesEnded(true)
else
SLHHMonitor.ScenarioesEnded(false)
endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
SLHHMonitor.ScenarioesEnded(false)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

slhh_Monitor Property SLHHMonitor Auto
