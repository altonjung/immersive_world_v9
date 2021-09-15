Scriptname SLS_AssessStash extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	ObjectReference WhatIAm = Game.GetCurrentCrosshairRef()

	String S1
	String S2
	String S3
	
	; Container factor: Only factor now is if the container is a hunterborn 'disguised' cache
	If WhatIAm != None
		If WhatIAm.GetBaseObject() as Container
			Float ContTypeFactor = StashTrack.GetContainerFactor(WhatIAm)
		
			; Decide description
			If ContTypeFactor < 1.0
				S1 = "This stash is pretty obvious. "
			Else
				S1 = "This stash is well hidden. "
			EndIf
		Else
			WhatIAm = PlayerRef
		EndIf
	Else
		WhatIAm = PlayerRef
	EndIf
	
	; Road factor description: Distance to the nearest road. Further from busy roads = better
	If !WhatIAm.IsInInterior()
		Float RoadFactor = StashTrack.GetRoadFactor(WhatIAm)
		If RoadFactor < 0.5
			S3 = " and the road is too close."
		ElseIf RoadFactor < 1.0
			S3 = " and the road is fairly close."
		Else
			S3 = " and there are no roads nearby."
		EndIf
	ElseIf WhatIAm.GetCurrentLocation().IsCleared()
		S3 = " and someone is bound to come around eventually"
	Else
		S3 = ". This place is not safe."
	EndIf

	; Location type factor description
	Float LocTypeFactor = StashTrack.GetLocTypeFactor(WhatIAm)
	If LocTypeFactor <= 0.5
		s2 = "There are a lot of eyes around here."
	ElseIf LocTypeFactor <= 0.7
		S2 = "It's quite busy here"
	ElseIf LocTypeFactor <= 0.9 
		S2 = "There are signs of footprints here"
	Else
		S2 = "It's pretty remote here"
	EndIf

	String StashDescription = S1 + S2 + S3
	Debug.Messagebox(StashDescription)
EndEvent

SLS_StashTrackPlayer Property StashTrack Auto

Actor Property PlayerRef Auto
