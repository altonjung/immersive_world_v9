Scriptname SLAPPOnEnterTriggerScript extends ObjectReference  

Message Property SLAPP_KnockingDoorMsg Auto
Quest Property SLApproachAskForSexQuest Auto
Quest Property SLApproachScanningPlayerHouse Auto
bool Property SceneSwitch = false Auto
bool Property DoOnce = true Auto  
{set to true if you want this trigger to fire only once
false means it will try to start the scene each time
the trigger actor enters it
}

Referencealias[] Property ReferenceArray Auto

bool Property ActorArrayToggle = false Auto 
{by default, it is set to false. set to true if you want this event to be triggered by kills}

objectReference property triggerActor auto
{by default, the player}


Bool Function CountActors()
Int iIndex = ReferenceArray.Length
	If iIndex != 0
	While iIndex
		iIndex -= 1 ; 29'th element is 30'th Draugr
		Referencealias kalias = ReferenceArray[iIndex]
		Actor kActor = (kalias.GetReference() as actor)
		If kActor.isdead()
		Else
			Return false
		EndIf
	EndWhile
	Else
		Return false
	EndIf
	Return True
EndFunction

Function ReArmTrigger()
;Debug.notification("No need to reset the Trigger Box.")
EndFunction

auto state waiting

EVENT onTriggerEnter(objectReference actronaut)
	if (triggerActor == None || actronaut as actor == triggerActor)
			if DoOnce
				gotoState("done")
			endif
		int choice = SLAPP_KnockingDoorMsg.Show()
		if (choice == 0);Open the door
			(SLApproachAskForSexQuest as SLAppPCSexQuestScript).PreVisitorEntering()
		Elseif (choice == 1);Slience
		Elseif (choice == 2);Reject
		Else
		Endif
	endif
endEVENT
endState


state done

Function ReArmTrigger()
gotoState("waiting")
EndFunction

EVENT onTriggerEnter(objectReference actronaut)
	Utility.wait(1.0)
	ReArmTrigger()
endEvent

endState