scriptname ImmersivePcVoiceClothesActorAlias extends ReferenceAlias

String runningCoolTimeExpress
Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

bool   changeInventory
bool   isAnimalPlaying
bool   isInventoryMode
bool   shouldPlayNakeAnimation

Armor  lastEquipedArmor

Event OnInit()
	; initMenu()	
EndEvent

event OnLoad()
	setup()
	init()
endEvent

; save -> load 시 호출
Event OnPlayerLoadGame()
	init()
EndEvent

function setup()
	pcVoiceMCM.updateActorArmorStatus(playerRef)
endFunction

function init ()
	UnregisterForMenu("InventoryMenu")
	RegisterForMenu("InventoryMenu")

	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	runningCoolTimeExpress = "happy"
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	isInventoryMode = false
	changeInventory = false
	shouldPlayNakeAnimation = false

	lastEquipedArmor = none
	isAnimalPlaying = false	

	pcVoiceMCM.playerGender = pcVoiceMCM.GetGender(playerRef)

	pcVoiceMCM.soundCoolTime = 0.0

	if pcVoiceMCM.playerWornMap == none 
		pcVoiceMCM.playerWornMap =  new bool[30]
	endif

	UnregisterForUpdate()	
	pcVoiceMCM.updateActorArmorStatus(playerRef)
endFunction

;
;	Menu
;
Event OnMenuOpen(string menuName)
	if menuName == "InventoryMenu" && pcVoiceMCM.enableDressMotion == true
		isInventoryMode = true
	endif
endEvent

Event OnMenuClose(string menuName)	
	if menuName == "InventoryMenu" && pcVoiceMCM.enableDressMotion == true
		if changeInventory
			pcVoiceMCM.updateActorArmorStatus(playerRef)
			if !isAnimalPlaying && !playerRef.IsOnMount() && !playerRef.IsInCombat() && !playerRef.IsSwimming()
				isAnimalPlaying = true
				if pcVoiceMCM.isPossibleFemaleAnimation(playerRef)		
					Game.DisablePlayerControls(false, false, true, false, false, false, false)			
					if pcVoiceMCM.isNaked && shouldPlayNakeAnimation
						; naked 출력
						SoundCoolTimePlay(SayClothesNakedShockSound, _delay=0.2, _express="sad")
						Debug.SendAnimationEvent(playerRef, "ImmGestureNakeCoverPlay_" + Utility.randomInt(1,3))
						shouldPlayNakeAnimation = false
					else
						; 옷 체크
						if lastEquipedArmor
							Sound  _dressCheckSound = SayClothesInvestigateSound
							string _checkExpress = ""
							string _checkAnimation = ""
							float  _dressAnimationDelay = 3.0
							float  _dressCheckSoundDelay = 0.3
							bool   _isSayingSpecialWord = false
							bool   _isHaireAnimation = false
							bool   _isNeedIntroAnimation = false
							Armor _armor = lastEquipedArmor
							lastEquipedArmor = none
							int    _slotMask = _armor.GetSlotMask()

							pcVoiceMCM.log("_slotMask " + _slotMask)							

							if Math.LogicalAnd(_slotMask, 0x00000002) == 0x00000002			; hair/longHair		
								_isHaireAnimation = true
								_checkExpress = "cute"
								_dressCheckSound = SayDialogueActiveSelfHappySound
								if pcVoiceMCM.playerWornMap[0]
									_checkExpress = "hate"
								elseif pcVoiceMCM.playerWornMap[1]
									_checkExpress = "beauty"
								elseif pcVoiceMCM.playerWornMap[2]
									_checkExpress = "cute"
								elseif pcVoiceMCM.playerWornMap[3]
									_checkExpress = "cute"
								elseif pcVoiceMCM.playerWornMap[4]
									_checkExpress = "cute"
									_dressCheckSound = SayDialogueActiveSelfHateSound
								else
									_checkExpress = "cute"
								endif

								if _checkExpress == "beauty" && Utility.randomInt(1,4) == 1
									_checkAnimation = "ImmCheckHair"
								else 
									_checkAnimation = "ImmCheckHairLong"
								endif					
							elseif Math.LogicalAnd(_slotMask, 0x00000800) == 0x00000800		; longHair
								_isHaireAnimation = true
								_checkExpress = "beauty"
								_dressCheckSound = SayDialogueActiveSelfHappySound
								if pcVoiceMCM.playerWornMap[0]
									_checkExpress = "hate"
								elseif pcVoiceMCM.playerWornMap[1]
									_checkExpress = "beauty"
								elseif pcVoiceMCM.playerWornMap[2]
									_checkExpress = "cute"
								elseif pcVoiceMCM.playerWornMap[3]
									_checkExpress = "cute"
								elseif pcVoiceMCM.playerWornMap[4]
									_checkExpress = "cute"
									_dressCheckSound = SayDialogueActiveSelfHateSound
								endif

								if _checkExpress == "beauty" && Utility.randomInt(1,4) == 1
									_checkAnimation = "ImmCheckHair"
								else 
									_checkAnimation = "ImmCheckHairLong"
								endif
							elseif _slotMask ==	0x01000000 || _slotMask == 0x00004000       ; mask
								_checkExpress = "beauty"
								_checkAnimation = "ImmCheckMask"
								if _armor.HasKeyWordString("ClothingVeinMask")
									_checkExpress = "sexy"
								endif
							elseif _slotMask == 0x00000020									; necklace
								_checkAnimation = "ImmCheckNecklace"
								_checkExpress = "beauty"
							elseif _slotMask == 0x00000080									; boots
								_dressAnimationDelay = 4.5			
								_checkAnimation = "ImmCheckBoots"
								if _armor.HasKeyWordString("ClothingHeels")
									_checkExpress = "beauty"
								endif			
							elseif _slotMask == 0x00800000 									; stocking
								_dressAnimationDelay = 4.5
								_checkAnimation = "ImmCheckStocking"
								_checkExpress = "beauty"
							elseif _slotMask == 0x00080000									; panties
								_checkAnimation = "ImmCheckPanties"
								if  _armor.HasKeyWordString("ClothingStocking") 
									_dressAnimationDelay = 4.5
									_checkAnimation = "ImmCheckStocking"							
								endif 
							elseif Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004 || Math.LogicalAnd(_slotMask, 0x00400000) == 0x00400000
								_checkAnimation = "ImmCheckClothes"
								if Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004		; clothes
									clearRunnintSoundRes()
									_checkExpress = ""
									if pcVoiceMCM.playerWornMap[10]
										_checkExpress = "embarass"
									elseif pcVoiceMCM.playerWornMap[11]
										_checkExpress = "sexy"
									elseif pcVoiceMCM.playerWornMap[12]
										_checkExpress = "beauty"
									elseif pcVoiceMCM.playerWornMap[13]
										_checkExpress = "cute"
									elseif pcVoiceMCM.playerWornMap[14]
										_checkExpress = "beauty"
									elseif pcVoiceMCM.playerWornMap[15]
										_checkExpress = "beauty"
									elseif pcVoiceMCM.playerWornMap[16]
										_checkExpress = "sexy"
										_checkAnimation = "ImmCheckSwimSuit"
									elseif pcVoiceMCM.playerWornMap[17]
										_checkExpress = "sexy"
										_checkAnimation = "ImmCheckSwimSuit"
									elseif pcVoiceMCM.playerWornMap[18]
									elseif _armor.HasKeyWordString("ClothingPoor")
										_checkExpress = "hate"
									elseif _armor.HasKeyWordString("ClothingPanties")
										_checkAnimation = "ImmCheckPanties"
									endif
								elseif Math.LogicalAnd(_slotMask, 0x00400000) == 0x00400000	; checkpanty
									_checkAnimation = "ImmCheckPanties"
								endif
							elseif _slotMask == 0x00400000 									; panty
								_dressAnimationDelay = 3.0
								_checkAnimation = "ImmCheckPanties"
							elseif _slotMask == 0x00000008 || _slotMask == 0x00000040		; glove or ring
								_dressAnimationDelay = 3.0						
								_checkAnimation = "ImmCheckGlove"
								_checkExpress = ""
								if _armor.HasKeyWordString("ClothingRingSayEng")
									_isSayingSpecialWord = true
									_dressCheckSound = SayDefaultSpecialEngSound
								elseif _armor.HasKeyWordString("ClothingRingSayKor")
									_dressCheckSound = SayDefaultSpecialKorSound
									_isSayingSpecialWord = true
								elseif _armor.HasKeyWordString("ClothingRingSayBugFix")
									_isSayingSpecialWord = true
									_isNeedIntroAnimation = true
									_dressCheckSound = SayDefaultSpecialBugFixSound
								endif
							elseif _slotMask ==	0x02000000  								; tongue
								_dressAnimationDelay = 3.0
							endif
							
							; animation and sound play							
							if _checkAnimation != "" && !playerRef.IsSprinting()													
								SoundCoolTimePlay(_dressCheckSound, _delay = _dressCheckSoundDelay, _express=_checkExpress)
								Debug.SendAnimationEvent(playerRef, _checkAnimation + "Start")
								Utility.Wait(_dressAnimationDelay)
								if _checkAnimation == "ImmCheckHairLong"
									Debug.SendAnimationEvent(playerRef, _checkAnimation + "End_" + Utility.randomInt(1,3))
								else 
									Debug.SendAnimationEvent(playerRef, _checkAnimation + "End")
								endif 
							endif
							
							if pcVoiceMCM.isNaked
								SoundCoolTimePlay(SayClothesNakedShockSound, _delay=0.2, _express="sad")
								Debug.SendAnimationEvent(playerRef, "ImmGestureNakeCoverPlay_" + Utility.randomInt(1,3))
							endif
						endif
					endif	
					Game.EnablePlayerControls()
				endif			
			isAnimalPlaying = false					
			endif 	
			changeInventory = false	
		endif
		isInventoryMode = false
	endif
endEvent
;
;	Cloth status
;
Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	changeInventory = true
	if pcVoiceMCM.enableDressMotion == true
		Armor _armor = akBaseObject as armor

		if _armor
			if lastEquipedArmor
				if lastEquipedArmor == _armor
					lastEquipedArmor = none
				endif			
			endif			

			int _slotMask = _armor.GetSlotMask()
			
			if Math.LogicalAnd(_slotMask, 0x00000004) == 0x00000004	|| Math.LogicalAnd(_slotMask, 0x00080000) == 0x00080000|| Math.LogicalAnd(_slotMask, 0x00800000) == 0x00800000	; clothes/ panties/ stocking
				if isInventoryMode
					shouldPlayNakeAnimation = true
				else
					; 주변 가까운곳에 npc 가 있는 경우라면, 그 npc로 인해 벗겨진 경우라 가정함..
					Actor _akActor = PO3_SKSEFunctions.GetClosestActorFromRef(playerRef as ObjectReference, true)	
					if _akActor && _akActor.getDistance(playerRef) < 200.0
						if playerRef.GetRelationshipRank(_akActor) < 1
							SoundCoolTimePlay(SayClothesNakedShockSound, _delay=2.0, _coolTime=5.0, _express="sad")
						endif
					endif
				endif
			endif
		endif
	endif

	if !isInventoryMode
		pcVoiceMCM.updateActorArmorStatus(playerRef)
	endif
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)	
	changeInventory = true
	if pcVoiceMCM.enableDressMotion == true
		Armor _armor = akBaseObject as armor

		if _armor
			lastEquipedArmor = _armor
		endif
	endif

	if !isInventoryMode
		pcVoiceMCM.updateActorArmorStatus(playerRef)
	endif
EndEvent

;
;
;
Event OnUpdate()
	; sound play
	if runningCoolTimeSoundRes != None
		if runningCoolTimeSoundRes == SayClothesNakedShockSound
			; nake 상태 한번더 확인
			if !pcVoiceMCM.isNaked
				pcVoiceMCM.soundCoolTime = -3.0
				return						
			endif
		endif

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

function clearRunnintSoundRes()
	UnregisterForUpdate()
	runningCoolTimeSoundRes = none	
	pcVoiceMCM.soundCoolTime = 0.0
endFunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 2.0, float _delay = 0.3, String _express)
	if playerRef.IsSwimming() || playerRef.IsInCombat()
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

Sound property SayClothesNakedShockSound Auto
Sound property SayClothesInvestigateSound Auto

Sound property SayDialogueActiveSelfHappySound Auto
Sound property SayDialogueActiveSelfHateSound Auto

Sound property SayDefaultSpecialEngSound Auto
Sound property SayDefaultSpecialKorSound Auto
Sound property SayDefaultSpecialBugFixSound Auto

