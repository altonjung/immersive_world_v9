;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname QF_SLHH_Companion_030063F1 Extends Quest Hidden

;BEGIN ALIAS PROPERTY companion
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_companion Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Actor NPC = SexLab.FindAvailableActor(CenterRef = Game.GetPlayer(), Radius = 2048.0, FindGender = 0, IgnoreRef1 = Game.GetPlayer(), IgnoreRef2 = Aggressor.GetActorRef(), IgnoreRef3 = Alias_Companion.GetActorRef(), IgnoreRef4 = ThirdOne.GetActorRef())
Actor[] sexActorsCompanion
sslBaseAnimation[] AnimsCompanion
If NPC != None
	sexActorsCompanion = new actor[2]
	sexActorsCompanion[0] = Alias_Companion.GetRef() as Actor
	sexActorsCompanion[1] = NPC
			
	If MCM.anim == "Sleeping/Necro"
		animsCompanion = SexLab.GetAnimationsByTags(2, "Sleeping")
	elseIf MCM.anim == "Leitos-Bound"
		animsCompanion = SexLab.GetAnimationsByTags(2, "Leito, Binding")
	else
		animsCompanion = SexLab.GetAnimationsByTags(2, "Aggressive")
	endif
endif

SexLab.StartSex(sexActorsCompanion, animsCompanion, victim=Alias_Companion.GetActorRef(), allowBed=false, hook="")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property ThirdOne  Auto
ReferenceAlias Property Aggressor  Auto  
SLHH_MCM Property MCM auto
SexLabFramework Property SexLab  Auto  
