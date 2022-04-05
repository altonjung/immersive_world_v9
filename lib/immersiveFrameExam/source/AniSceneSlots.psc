scriptname AniSceneSlots extends Quest

AniFrameworkMain property SexLab auto hidden

; Slots
sslThreadController[] Slots
sslThreadController[] property Scenes hidden
	sslThreadController[] function get()
		return Slots
	endFunction
endProperty

sslThreadModel function PickModel(float TimeOut = 30.0)
	if SexLab.GetState() == "Disabled"
		log("Failed to start new thread - Mod is currently disabled in PickModel()")
		return none
	endIf
	float failsafe = Utility.GetCurrentRealTime() + TimeOut
	while GetState() == "Locked" && Utility.GetCurrentRealTime() < failsafe
		Utility.WaitMenuMode(0.1)
	endWhile
	GoToState("Locked")

	sslThreadModel Thread
	int i
	while !Thread && i < Slots.Length
		if !Slots[i].IsLocked
			Thread = Slots[i].Make()
		endIf
		i += 1
	endWhile
	; Failsafe - check for possibly stuck/ending threads and use them.
	if !Thread
		i = 0
		while !Thread && i < Slots.Length
			string ThreadState = Slots[i].GetState()
			if ThreadState == "Frozen" || ThreadState == "Ending"
				Slots[i].Fatal("Resetting possibly stuck thread: "+Slots[i], "PickModel")
				Thread = Slots[i].Make()
			endIf
			i += 1
		endWhile
	endIf
	GoToState("")
	return Thread
endFunction

sslThreadController function GetController(int tid)
	if tid < 0 || tid >= Slots.Length
		return none
	endIf
	return Slots[tid]
endfunction

int function FindActorController(Actor ActorRef)
	if !ActorRef
		return -1
	endIf
	int i
	while i < Slots.Length
		if Slots[i].FindSlot(ActorRef) != -1
			return i
		endIf
		i += 1
	endwhile

	return -1
endFunction

sslThreadController function GetActorController(Actor ActorRef)
	return GetController(FindActorController(ActorRef))
endFunction

bool function IsRunning()
	int i
	while i < Slots.Length
		if Slots[i].IsLocked
			return true
		endIf
		i += 1
	endwhile
	return false
endfunction

int function ActiveThreads()
	int Count
	int i = Slots.Length
	while i
		i -= 1
		Count += (Slots[i].IsLocked as int)
	endwhile
	return Count
endfunction

function StopThread(sslThreadController Slot)
	string SlotState = Slot.GetState()
	if SlotState == "Making"
		SexLabUtil.DebugLog("Making during StopAll - Initializing.", Slot, true)
		Slot.Initialize()
	elseIf SlotState == "Frozen"
		Slot.Initialize()
	elseIf SlotState != "Unlocked"
		SexLabUtil.DebugLog(SlotState+" during StopAll - EndAnimation.", Slot, true)
		Slot.EndAnimation(true)
	endIf
endFunction

function StopAll()
	; End all threads
	int i = Slots.Length
	while i
		i -= 1
		StopThread(Slots[i])
	endWhile
	; Send event
	ModEvent.Send(ModEvent.Create("SexLabStoppedActive"))
endFunction

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;
function Setup()
	GoToState("Locked")
	Quest SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esm") as Quest
	if SexLabQuestFramework	
		SexLab = SexLabQuestFramework as AniFrameworkMain
	endIf
	; Slot Form IDs
	int[] SlotFormID = new int[5]
	SlotFormID[0]  = 0x61EEF
	SlotFormID[1]  = 0x62452
	SlotFormID[2]  = 0x6C62C
	SlotFormID[3]  = 0x6C62D
	SlotFormID[4]  = 0x6C62E

	; Get and stop all thread quest slots
	Slots = new sslThreadController[5]
	int i = Slots.Length
	while i
		i -= 1
		Slots[i] = Game.GetFormFromFile(SlotFormID[i], "SexLab.esp") as sslThreadController
		if !Slots[i].IsStopped() || Slots[i].IsStopping()
			Slots[i].Stop()
			float max = Utility.GetCurrentRealTime() + 5.0
			while Slots[i].IsStopping() && Utility.GetCurrentRealTime() <= max
				Utility.Wait(0.5)
			endwhile
		endIf
	endWhile
	Utility.WaitMenuMode(1.0)
	i = Slots.Length
	while i
		i -= 1
		if Slots[i].Start()
			Slots[i].SetTID(i)
		else
			Log("Failed to start thread quest("+i+"): "+Slots[i])
		endIf
	endWhile
	log("slots: "+Slots)
	GoToState("")
endFunction

state Locked
	function Setup()
	endFunction
endState

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction
