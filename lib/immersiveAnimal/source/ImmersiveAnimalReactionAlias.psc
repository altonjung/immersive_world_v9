scriptname ImmersiveAnimalReactionAlias extends ReferenceAlias

Event OnInit()
EndEvent

Event OnLoad()
    registerAction()	
	init()
EndEvent
    
function registerAction ()	
	regAnimation()
endFunction

function regAnimation ()	
	RegisterForModEvent("ImpInTouchChicken", "reactionToChicken")
	RegisterForModEvent("ImpInTouchChicken", "reactionToChicken")
	RegisterForModEvent("ImpInTouchHorse",   "reactionToHorse")
	RegisterForModEvent("ImpInTouchCow",     "reactionToCow")
	RegisterForModEvent("ImpInTouchRikling", "reactionToRikling")
	RegisterForModEvent("ImpInTouchGoat",    "reactionToGoat")
	RegisterForModEvent("ImpInTouchGiant",   "reactionToGiant")
	RegisterForModEvent("ImpInTouchHare",    "reactionToHare")
endFunction

function init ()		

endFunction

Actor function getCrossHairRef()
	ObjectReference _overHairRef = Game.GetCurrentCrosshairRef()
	If _overHairRef != none
		return _overHairRef as Actor
	endif

	return none
endfunction

event reactionToRikling()
	actor _actor = getCrossHairRef()
	if _actor 
		SoundPlay(_actor, SayAnimalRiklingReactionSound)	
		Debug.SendAnimationEvent(_actor, "ImmGestureAniRiklingTouch")
		utility.wait(3.0)
	endif
endEvent

event reactionToHare()
	actor _actor = getCrossHairRef()
	if _actor 		
		Debug.SendAnimationEvent(_actor, "ImmGestureAniHareTouch")
		utility.wait(3.0)
	endif
endEvent

event reactionToChicken()
	actor _actor = getCrossHairRef()
	if _actor 
		SoundPlay(_actor, SayAnimalChickenReactionSound)	
		Debug.SendAnimationEvent(_actor, "ImmGestureAniChickenTouch")
		utility.wait(3.0)
	endif
endEvent

event reactionToCow()
	actor _actor = getCrossHairRef()
	if _actor 
		SoundPlay(_actor, SayAnimalCowReactionSound)	
		Debug.SendAnimationEvent(_actor, "ImmGestureAniCowTouch")
		utility.wait(3.0)
	endif
endEvent

event reactionToHorse()
	actor _actor = getCrossHairRef()
	if _actor 
		SoundPlay(_actor, SayAnimalHorseReactionSound)	
		Debug.SendAnimationEvent(_actor, "ImmGestureAniHorseTouch")
		utility.wait(3.0)	
	endif
endEvent

event reactionToGiant()
	actor _actor = getCrossHairRef()
	if _actor 
		SoundPlay(_actor, SayAnimalGiantReactionSound)	
		Debug.SendAnimationEvent(_actor, "ImmGestureAniGiantTouch")
		utility.wait(3.0)	
	endif
endEvent

event reactionToGoat()
	actor _actor = getCrossHairRef()
	if _actor 
		SoundPlay(_actor, SayAnimalGoatReactionSound)	
		Debug.SendAnimationEvent(_actor, "ImmGestureAniGoatTouch")
		utility.wait(3.0)	
	endif
endEvent

function SoundPlay(Actor _actor, Sound _sound, float _volume = 0.8)	
	if _actor.IsSwimming() || _actor.IsInCombat() 
		return
	endif	
	Sound.SetInstanceVolume(_sound.Play(_actor), _volume)
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

Sound property SayAnimalCowReactionSound Auto
Sound property SayAnimalHorseReactionSound Auto
Sound property SayAnimalGiantReactionSound Auto
Sound property SayAnimalChickenReactionSound Auto
Sound property SayAnimalGoatReactionSound Auto
Sound property SayAnimalRiklingReactionSound Auto
