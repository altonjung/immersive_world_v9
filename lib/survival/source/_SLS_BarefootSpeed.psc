Scriptname _SLS_BarefootSpeed extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	akTarget.ModAv("CarryWeight", 0.01)
	akTarget.ModAv("CarryWeight", -0.01)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akTarget.ModAv("CarryWeight", 0.01)
	akTarget.ModAv("CarryWeight", -0.01)
EndEvent
