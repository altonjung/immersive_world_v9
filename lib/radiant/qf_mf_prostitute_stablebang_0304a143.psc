;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 24
Scriptname qf_mf_prostitute_stablebang_0304a143 Extends Quest Hidden

;BEGIN ALIAS PROPERTY RiftenStableMasterBackup
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RiftenStableMasterBackup Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WhiterunJarl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WhiterunJarl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SolitudeStableMaster
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SolitudeStableMaster Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY thePlayer
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_thePlayer Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theHold
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theHold Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WindhelmStableMaster
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WindhelmStableMaster Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WindhelmStableMasterBackup
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WindhelmStableMasterBackup Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SolitudeStableMasterBackup
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SolitudeStableMasterBackup Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RiftenStableMaster
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RiftenStableMaster Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY StableMasterBackup
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_StableMasterBackup Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WhiterunJarlBed
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WhiterunJarlBed Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY JarlBed
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_JarlBed Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY RiftenJarl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_RiftenJarl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WhiterunStableMasterBackup
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WhiterunStableMasterBackup Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MarkarthJarl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MarkarthJarl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MarkarthJarlBed
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MarkarthJarlBed Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Horse
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Horse Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WhiterunStableMaster
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WhiterunStableMaster Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WindhelmJarl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WindhelmJarl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY StableMaster
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_StableMaster Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MarkarthStableMaster
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MarkarthStableMaster Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SolitudeJarl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SolitudeJarl Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MarkarthStableMasterBackup
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MarkarthStableMasterBackup Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WindhelmJarlBed
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WindhelmJarlBed Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY theLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_theLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY HorseSpawnPoint
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_HorseSpawnPoint Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Jarl
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Jarl Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(0)
kmyQuest.coverTravelExpenses()
kmyQuest.Handler.GetRandomJobReward()
Alias_Horse.getActorRef().disable()
Alias_Horse.getActorRef().delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(10)
SetObjectiveCompleted(15)
SetObjectiveDisplayed(20)
kmyQuest.evaluatePackages()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(0)
kmyQuest.coverTravelExpenses()
kmyQuest.Handler.GetRandomJobReward()
Alias_Horse.getActorRef().disable()
Alias_Horse.getActorRef().delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(20)
SetObjectiveDisplayed(30)

kmyQuest.moveJarlToBed()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_22
Function Fragment_22()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(30)
kmyQuest.Handler.GetRandomJobReward()
Alias_Horse.getActorRef().disable()
Alias_Horse.getActorRef().delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
SetObjectiveCompleted(0)
SetObjectiveDisplayed(5)
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(20)
kmyQuest.Handler.GetRandomJobReward()
Alias_Horse.getActorRef().disable()
Alias_Horse.getActorRef().delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
SetObjectiveCompleted(20)
SetObjectiveDisplayed(30)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(30)
kmyQuest.Handler.GetRandomJobReward()
Alias_Horse.getActorRef().disable()
Alias_Horse.getActorRef().delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
SetObjectiveCompleted(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
SetObjectiveCompleted(5)
SetObjectiveDisplayed(15)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(0)
kmyQuest.StableArousal()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
SetObjectiveCompleted(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(20)
SetObjectiveCompleted(10)
SetObjectiveCompleted(15)
kmyQuest.evaluatePackages()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_17
Function Fragment_17()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveCompleted(20)
kmyQuest.Handler.GetRandomJobReward()
Alias_Horse.getActorRef().disable()
Alias_Horse.getActorRef().delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_15
Function Fragment_15()
;BEGIN AUTOCAST TYPE mf_prostitute_stablebangquest
Quest __temp = self as Quest
mf_prostitute_stablebangquest kmyQuest = __temp as mf_prostitute_stablebangquest
;END AUTOCAST
;BEGIN CODE
SetObjectiveDisplayed(20)
SetObjectiveCompleted(10)
SetObjectiveCompleted(15)

Alias_StableMasterBackUp.getActorRef().moveTo(Alias_StableMaster.getActorRef())
kmyQuest.evaluatePackages()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_23
Function Fragment_23()
;BEGIN CODE
Alias_Horse.getActorRef().disable()
Alias_Horse.getActorRef().delete()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
SetObjectiveCompleted(10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
