Scriptname SLApproachScanQuest extends Quest

ReferenceAlias Property ApproachActor01 Auto
ReferenceAlias Property ApproachActor02 Auto
ReferenceAlias Property ApproachActor03 Auto
ReferenceAlias Property ApproachActor04 Auto
ReferenceAlias Property ApproachActor05 Auto
ReferenceAlias[] Property ApproachAliases Auto

Actor[] Property approachActors Auto hidden

Int Function GetApproachActors()
	Start()
	Utility.Wait(0.3)

	Int actorCount = 0
	approachActors = new Actor[5]
	Actor approachActor

	Int ii = 0
	While ii < 5
		approachActor = ApproachAliases[ii].GetReference() as Actor
		If approachActor != None
			approachActors[actorCount] = approachActor
			;Debug.Notification("Actor[" + actorCount + "] " + approachActor.GetBaseObject().GetName())
			actorCount += 1
		EndIf
		ii += 1
	EndWhile

	;Debug.Notification("actorCount is " + actorCount)

	
	Reset()
	Stop()
	
	Return actorCount
EndFunction
