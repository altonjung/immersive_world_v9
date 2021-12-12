scriptname ImmersivePcVoiceObjectAlias extends ReferenceAlias

event OnInit() 
	init()
endEvent

function init ()	
endFunction

Event OnActivate(ObjectReference akActionRef)
	log("OnActivate")
EndEvent

Event OnLockStateChanged()
	log("lock changed")

	if GetReference().IsLocked()
		Sound.SetInstanceVolume(SayActionFailSound.Play(Game.GetPlayer()), 0.8)
	else 
		Sound.SetInstanceVolume(SayActionSuccessSound.Play(Game.GetPlayer()), 0.8)		
	endif
EndEvent

Event OnOpen(ObjectReference akActionRef)
	log("opened")
EndEvent

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction

; action
Sound property SayActionSuccessSound Auto
Sound property SayActionFailSound Auto



