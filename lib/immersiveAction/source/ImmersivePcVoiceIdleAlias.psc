scriptname ImmersivePcVoiceIdleAlias extends ReferenceAlias

ObjectReference overHairRef

bool   isAnimalPlaying

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

Event OnInit()
EndEvent

event OnLoad()
	registerAction()	
	init()
endEvent

; save -> load 시 호출
Event OnPlayerLoadGame()
	init()
EndEvent

function registerAction ()	
	regAnimation()
endFunction

function regAnimation ()
	RegisterForControl("Activate")	
	RegisterForModEvent("ImaRoosterCry", 	"RoosterCryReaction")
	RegisterForModEvent("ImaOwlCry", 		"OwlHootReaction")

	RegisterForModEvent("ImpInStruggle", 	"PlayStruggleSnd")
	RegisterForModEvent("ImpInScream", 	 	"PlayScreamSnd")
	RegisterForModEvent("ImpInPrettyLaugh",	"PlayPrettyLaughSnd")
	RegisterForModEvent("ImpInSexyLaugh", 	"PlaySexyLaughSnd")
	RegisterForModEvent("ImpInEmbarras", 	"PlayEmbarrasSnd")
	RegisterForModEvent("ImpInAngry", 	 	"PlayAngrySnd")
	RegisterForModEvent("ImpInCry", 	 	"PlayCrySnd")
	RegisterForModEvent("ImpInSigh", 	 	"PlaySighSnd")
	RegisterForModEvent("ImpInWorry", 	 	"PlayWorrySnd")
	RegisterForModEvent("ImpInDisappoint", 	"PlayDisappointSnd")
endFunction

function init ()		
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeExpress = "happy"
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	isAnimalPlaying = false	
endFunction

Event OnControlDown(string control)
	if control == "Activate"
		overHairRef = Game.GetCurrentCrosshairRef()
	endif
endEvent 

Event OnControlUp(string control, float holdTime)
	if control == "Activate"
		If overHairRef == none
			if holdTime >= 1.0 && !isAnimalPlaying && !playerRef.IsOnMount() && !playerRef.IsInCombat() && !playerRef.IsSwimming()
				isAnimalPlaying = true
				String _doAnimation = ""
				Game.DisablePlayerControls(false, false, true, false, false, false, false)				

				if hasAnimalStyle.getValue() == -4
					_doAnimation = "WagTail"
				elseif isWornNothingClothes.getValue() != 0
					if playerRef.IsInCombat()
						SoundCoolTimePlay(SayDialogueActiveSelfNakedSound, _express="angry")
						_doAnimation = "Dance"
					else 
						SoundCoolTimePlay(SayDialogueActiveSelfNakedSound, _express="angry")
						_doAnimation = "NakeCover"
					endif
				else 
					if isWornSexy.getValue() != 0
						SoundCoolTimePlay(SayDialogueActiveSelfSexySound, _express="sexy")
						_doAnimation = "Sexy"
					elseif isWornSlutty.getValue() != 0
						SoundCoolTimePlay(SayDialogueActiveSelfEmbarrasSound, _express="happy")
						_doAnimation = "Embarras"						
					elseif isWornBeauty.getValue() != 0 || isWornHeel.getValue() != 0 || hasHairStyle.getValue() != 0 || isWornDress.getValue() != 0
						int _randomInt = utility.randomInt(1,2)
						if hasHairStyle.getValue() == -1 && _randomInt == 0
						  _doAnimation = "HairLong"
						elseif isWornHeel.getValue() != 0 && _randomInt == 0
						  _doAnimation = "Happy"
						else
						  if _randomInt == 0
							_doAnimation = "Beauty"
						  else 
							_doAnimation = "Happy"
						  endif
						endif
						SoundCoolTimePlay(SayDialogueActiveSelfHappySound, _express="happy")				
					elseif isWornNothingClothes.getValue() != 0
						SoundCoolTimePlay(SayDialogueActiveSelfAngrySound,_express="angry")
					endif
				endif

				if _doAnimation != ""
					Debug.SendAnimationEvent(playerRef, "ImmGesture" + _doAnimation + "Play_" + utility.randomInt(1,3))
					if _doAnimation == "Beauty"	; Happy 액션은 12초 구간이라, 중간에 quit 필요
						Utility.Wait(2.5)
						Debug.SendAnimationEvent(playerRef, "IdleForceDefaultState")
					endif
				endif

				Game.EnablePlayerControls()
				isAnimalPlaying = false
			endif
		else
			; int _type = overHairRef.getType()

			; if _type == 43 || _type == 62
			; 	Actor _akActor = overHairRef as Actor
			; 	; _akActor.IsHostileToActor(playerRef)
			; endif
		endif
	endif
	overHairRef = none
endEvent

event RoosterCryReaction()
	; SoundCoolTimePlay(SayEmotionStruggleSound, _express="painful")	
endEvent

event OwlHootReaction()
	; SoundCoolTimePlay(SayEmotionStruggleSound, _express="painful")	
endEvent

event PlayStruggleSnd()
	SoundCoolTimePlay(SayEmotionStruggleSound, _express="painful")	
endEvent

event PlayScreamSnd()
	SoundCoolTimePlay(SayEmotionScreamSound, _express="angry")	
endEvent

event PlayPrettyLaughSnd()
	SoundCoolTimePlay(SayEmotionPrettyLaughSound, _express="happy")	
endEvent

event PlaySexyLaughSnd()
	SoundCoolTimePlay(SayEmotionSexyLaughSound, _express="happy")	
endEvent

event PlayEmbarrasSnd()
	SoundCoolTimePlay(SayEmotionEmbarrasSound, _express="happy")	
endEvent

event PlayAngrySnd()
	SoundCoolTimePlay(SayEmotionAngrySound, _express="angry")	
endEvent

event PlayCrySnd()
	SoundCoolTimePlay(SayEmotionCrySound, _express="sad")	
endEvent

event PlaySighSnd()
	SoundCoolTimePlay(SayEmotionSignSound, _express="sad")	
endEvent

event PlayWorrySnd()
	SoundCoolTimePlay(SayEmotionWorrySound, _express="sad")	
endEvent

event PlayDisappointSnd()
	SoundCoolTimePlay(SayEmotionDisAppointSound, _express="sad")
endEvent

Event OnUpdate()
	; sound play
	if runningCoolTimeSoundRes != None
		pcVoiceMCM.soundCoolTime = runningCoolTimeSoundCurtime + runningCoolTimeSoundCoolingTime
		Sound.SetInstanceVolume(runningCoolTimeSoundRes.Play(playerRef), runningCoolTimeSoundVolume)
		pcVoiceMCM.expression(playerRef, runningCoolTimeExpress)
		runningCoolTimeSoundRes = none
		runningCoolTimeSoundVolume = 0.0
		runningCoolTimeSoundCoolingTime = 0.0
		runningCoolTimeSoundCurtime = 0.0		
		runningCoolTimeExpress = ""
	endif
endEvent

;
;	Utility
;
function SoundCoolTimePlay(Sound _sound, float _volume = 0.5, float _coolTime = 2.0, float _delay = 0.3, String _express)
	if playerRef.IsSwimming()
		return
	endif

	float currentTime = Utility.GetCurrentRealTime()
	if currentTime >= pcVoiceMCM.soundCoolTime
		if _delay == 0.0	
			pcVoiceMCM.soundCoolTime = currentTime + _coolTime + _delay
			runningCoolTimeSoundRes = none
			runningCoolTimeSoundVolume = 0.0
			Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
			pcVoiceMCM.expression(playerRef, _express)
		else
			runningCoolTimeExpress = _express
			runningCoolTimeSoundRes = _sound
			runningCoolTimeSoundVolume = _volume
			runningCoolTimeSoundCurtime = currentTime
			runningCoolTimeSoundCoolingTime = _coolTime
			UnregisterForUpdate()
			RegisterForSingleUpdate(_delay)
		endif
	endif
endFunction

ImmersivePcVoiceMCM property pcVoiceMCM Auto

Actor property playerRef Auto

Idle property TauntIdle1 Auto
Idle property TauntIdle2 Auto
Idle property TauntIdle3 Auto

; action
Sound property SayActionTauntSound Auto

; emotion
Sound property SayEmotionAngrySound Auto
Sound property SayEmotionCrySound Auto
Sound property SayEmotionDisAppointSound Auto
Sound property SayEmotionEmbarrasSound Auto
Sound property SayEmotionInsultSound Auto
Sound property SayEmotionPrettyLaughSound Auto
Sound property SayEmotionSexyLaughSound Auto
Sound property SayEmotionScreamSound Auto
Sound property SayEmotionStruggleSound Auto
Sound property SayEmotionSignSound Auto
Sound property SayEmotionWorrySound Auto

; self
Sound property SayDialogueActiveSelfHappySound Auto
Sound property SayDialogueActiveSelfHateSound Auto
Sound property SayDialogueActiveSelfembarrasSound Auto
Sound property SayDialogueActiveSelfSexySound Auto
Sound property SayDialogueActiveSelfAngrySound Auto
Sound property SayDialogueActiveSelfHostileSound Auto
Sound property SayDialogueActiveSelfMeowSound Auto
Sound property SayDialogueActiveSelfNakedSound Auto

GlobalVariable Property hasHairStyle Auto			; 006CE2F3
GlobalVariable Property hasAnimalStyle Auto			; 006CE2EC
GlobalVariable Property isWornDress Auto			; 00663DB4
GlobalVariable Property isWornHeel Auto				; 006CE2EA
GlobalVariable Property isWornSexy Auto				; 006CE2ED
GlobalVariable Property isWornSlutty Auto			; 006CE2EE
GlobalVariable Property isWornBeauty Auto			; 006CE2F1
GlobalVariable Property isWornNothingHelmet Auto	; 006CE2F2
GlobalVariable Property isWornNothingClothes Auto	; 006CE2EB