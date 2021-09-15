Scriptname _SLS_TeaseMyself extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	TargetActor = akTarget
	Debug.SendAnimationEvent(akTarget, AllInOneKey.GetRandomHornyAnim())
	RegisterForSingleUpdate(Utility.RandomFloat(3.0, 5.0))
EndEvent

Event OnUpdate()
	Util.ModArousal(TargetActor, 2.0)
	If Counter <= 0
		Devious.DoMoan(TargetActor)
		Counter = Utility.RandomInt(0, 2)
	EndIf
	Counter -= 1
	RegisterForSingleUpdate(Utility.RandomFloat(3.0, 5.0))
EndEvent

Int Counter = 1

Actor TargetActor

SLS_Utility Property Util Auto

_SLS_InterfaceDevious Property Devious Auto
_SLS_AllInOneKey Property AllInOneKey Auto
