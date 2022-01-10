scriptname ImmersivePcVoiceCombatActorAlias extends ReferenceAlias

int    underAttackCountByAnimal
float  soundCoolTime
float[] coolTimeMap

Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume

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
	RegisterForActorAction(1) ; 1 - Spell Cast, 2 - Spell Fire
	RegisterForActorAction(5) ; bow draw
	RegisterForActorAction(6) ; bow release 

	regAnimation()
endFunction

function init ()		
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	underAttackCountByAnimal = 0
	soundCoolTime = 0.0	
	coolTimeMap = new float[5]
endFunction

function regAnimation ()
	LOG("regAnimation")

	; weapon/bow
	RegisterForAnimationEvent(playerRef, "weaponSwing")
	RegisterForAnimationEvent(playerRef, "weaponLeftSwing")

	; weapon
	RegisterForAnimationEvent(playerRef, "weaponDraw")
	; RegisterForAnimationEvent(playerRef, "weaponSheathe")	
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if asEventName == "weaponDraw"
		if playerRef.IsSneaking()
			SoundCoolTimePlay(SayCombatStartSneakSound, _delay=0.3, _coolTime=3.0)
		else 
			SoundCoolTimePlay(SayCombatStartSound, _delay=0.3, _coolTime=3.0)
		endif		
	elseif asEventName == "weaponLeftSwing" || asEventName == "weaponSwing"
		int level = 0
		; getSkill Level
		float oneHandSkillLevel = playerRef.GetAV("OneHanded")	
		if oneHandSkillLevel < 30
			level = 0
		elseif  oneHandSkillLevel < 60
			level = 1
		else 
			level = 2
		endif 

		if level == 0
			float twoHandSkillLevel = playerRef.GetAV("TwoHanded")
			if twoHandSkillLevel < 30
				level = 0
			elseif  twoHandSkillLevel < 60
				level = 1
			else 
				level = 2
			endif 
		endif

		if playerRef.GetActorValue("Health") >= 0.3
			if playerRef.GetAnimationVariableBool("bAllowRotation")
				if level == 0
					SoundCoolTimePlay(SayCombatPowerAttackNoviceSound, _coolTime=1.5)
				elseif level == 1
					SoundCoolTimePlay(SayCombatPowerAttackApprenticeSound, _coolTime=1.5)
				else 
					SoundCoolTimePlay(SayCombatPowerAttackExpertSound, _coolTime=1.5)
				endif
			else
				if level == 0
					SoundCoolTimePlay(SayCombatAttackNoviceSound, _volume=0.4, _coolTime=1.0)
				elseif level == 1
					SoundCoolTimePlay(SayCombatAttackApprenticeSound, _volume=0.4, _coolTime=1.0)
				else 
					SoundCoolTimePlay(SayCombatAttackExpertSound, _volume=0.4, _coolTime=1.0)
				endif				
			endif		
		endif		
	endif
endEvent

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	if akActor == playerRef	
		if actionType == 1
			Spell magicSpell = source as spell
			MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

			if magicEffects
				int idxx=0
				while idxx < magicEffects.length
					int castingType = magicEffects[idxx].GetCastingType()
					int deliveryType = magicEffects[idxx].GetDeliveryType()

					if magicEffects[idxx].HasKeyWordString("RitualSpellEffect")
						if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
							; Log("Magic Cast from RitualSpellEffect and MagicDamageFire")
							SoundCoolTimePlay(SayMagicFireRitualSound, _coolTime=3.0)
						elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
							; Log("Magic Cast from RitualSpellEffect and MagicDamageFrost")
							SoundCoolTimePlay(SayMagicFrostRitualSound, _coolTime=3.0)
						elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
							; Log("Magic Cast from RitualSpellEffect and MagicDamageShock")
							SoundCoolTimePlay(SayMagicShockRitualSound, _coolTime=3.0)
						elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
							; Log("Magic Cast from RitualSpellEffect and MagicDamageLight")
							SoundCoolTimePlay(SayMagicLightRitualSound, _coolTime=3.0)
						elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
							; Log("Magic Cast from RitualSpellEffect and MagicDamagePoison")
							SoundCoolTimePlay(SayMagicPoisonRitualSound, _coolTime=3.0)
						else 
							Log("Magic Cast from RitualSpellEffect")
						endif 
						return 
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageFire")
						; Log("Magic Cast from MagicDamageFire")
						SoundCoolTimePlay(SayMagicFireCastSound, _coolTime=2.0)
						return 
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
						SoundCoolTimePlay(SayMagicFrostCastSound, _coolTime=2.0)
						; Log("Magic Cast from MagicDamageFrost")
						return 
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
						SoundCoolTimePlay(SayMagicShockCastSound, _coolTime=2.0)
						; Log("Magic Cast from MagicDamageShock")
						return 						
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
						SoundCoolTimePlay(SayMagicLightCastSound, _coolTime=2.0)
						; Log("Magic Cast from MagicDamageLight")
						return 			
					elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
						SoundCoolTimePlay(SayMagicPoisonCastSound, _coolTime=2.0)
						; Log("Magic Cast from MagicDamagePoison")
						return 									
					elseif magicEffects[idxx].HasKeyWordString("MagicRestoreHealth")
						; Log("Magic Cast from MagicRestoreHealth")
						if deliveryType == 0  ; self
							SoundCoolTimePlay(SayMagicHealSelfSound, _coolTime=2.0)
						else 				  ; others
							SoundCoolTimePlay(SayMagicHealCastSound, _coolTime=2.0)
						endif 
						return 					
					elseif magicEffects[idxx].HasKeyWordString("MagicCandleLight")
						; Log("Magic Cast from MagicCandleLight")
						SoundCoolTimePlay(SayMagicCandleLightSelfSound, _coolTime=2.0)				
						return
					elseif magicEffects[idxx].HasKeyWordString("MagicTurnUndead") || magicEffects[idxx].HasKeyWordString("MagicSummonShock") || magicEffects[idxx].HasKeyWordString("MagicSummonFrost") || magicEffects[idxx].HasKeyWordString("MagicSummonLight")
						SoundCoolTimePlay(SayMagicSummonSound, _coolTime=2.0)
						; Log("Magic Cast from MagicSummon")
						return 									
					else
						SoundCoolTimePlay(SayMagicDefaultSound, _coolTime=2.0)
						; Log("Magic Cast from MagicDefault")					
					endif
					idxx += 1
				endwhile
			endif
		elseif actionType == 5 ; bow draw
			float _skillLevel = playerRef.GetAV("Marksman")			
			if _skillLevel < 40 && playerRef.GetActorValue("Stamina") <= 50.0
				if 5 <= Utility.RandomInt(0, 10)
					Game.ShakeCamera(afDuration = 1.0)
				endif 
			endif
			
			if playerRef.IsSneaking()
				SoundCoolTimePlay(SayCombatBowDrawSneakSound, _volume=0.4, _coolTime=3.0)
			else
				SoundCoolTimePlay(SayCombatBowDrawSound, _volume=0.5, _coolTime=1.5)
			endif
		elseif actionType == 6 ; bow release			
			if playerRef.IsSneaking()
				SoundCoolTimePlay(SayCombatBowReleaseSneakSound, _delay=0.3, _volume=0.4)
			else 
				SoundCoolTimePlay(SayCombatBowReleaseSound, _delay=0.3 , _volume=0.5)
			endif
		endif			
	endif
EndEvent

Event OnActorKilled(Actor akVictim, Actor akKiller)	
	if akKiller == playerRef && playerRef.IsInCombat() == false
		playerRef.SheatheWeapon()
		if playerRef.IsSneaking()
			SoundCoolTimePlay(SayCombatEndSneakSound, _delay=1.0, _volume=0.5, _coolTime=2.0)
		else
			SoundCoolTimePlay(SayCombatEndSound, _delay=1.0, _volume=0.5, _coolTime=2.0)
		endif
	endif
EndEvent
	
; Event received when an actor enters bleedout.
Event OnEnterBleedout()
	SoundCoolTimePlay(SayCombatBleedOutSound, _volume=0.4, _coolTime=5.0)
	Log("OnEnterBleedout")
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)	
	
	; playerRef.SetRelationshipRank(akAggressor, -1)

	if abHitBlocked
		SoundCoolTimePlay(SayCombatBlockSound, _volume=0.4, _coolTime=2.0)
	Else
		bool  isPowerDamange = false
		float nakedDamagePenalty = 10.0
		float drunkDamagePenalty = 10.0		
		
		if abPowerAttack || abBashAttack
			; 옷 상태 처리
			Actor aggressor = akAggressor as Actor

			; 동물들 공격에 의해 옷이 벗겨질 수 있음
			if aggressor.HasKeyWordString("ActorTypeAnimal")
				underAttackCountByAnimal += 1

				if underAttackCountByAnimal > 5 && Utility.randomInt(1, 10) == 2
					Armor[] actorArmorList = new Armor[8]
					actorArmorList[0]	= playerRef.GetWornForm(0x00000008) As Armor	; actorHand
					actorArmorList[1]	= playerRef.GetWornForm(0x00000010) As Armor	; actorArm
					actorArmorList[2]	= playerRef.GetWornForm(0x00000080) As Armor	; actorBoot
					actorArmorList[3] 	= playerRef.GetWornForm(0x00800000) as Armor	; actorThigh				
					actorArmorList[4] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
					actorArmorList[5] 	= playerRef.GetWornForm(0x00008000) as Armor	; actorSkirts
					actorArmorList[6]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor		
					actorArmorList[7] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty
				
					int idx = 0
					while idx < actorArmorList.length 													
						if actorArmorList[idx] && isWeakArmor(actorArmorList[idx])
							playerRef.DropObject(actorArmorList[idx])
							idx = actorArmorList.length 
						endif
						idx += 1
					endwhile
				endif
			; 용 불길로 인해 옷이 타버릴 수 있음
			elseif aggressor.HasKeyWordString("ActorTypeDragon")
				if Utility.randomInt(1, 10) < 3
					if checkFireSpell(akSource)				
						Armor[] actorArmorList = new Armor[5]
						actorArmorList[0] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
						actorArmorList[1]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor
						actorArmorList[2] 	= playerRef.GetWornForm(0x00800000) as Armor	; actorThigh
						actorArmorList[3] 	= playerRef.GetWornForm(0x00008000) as Armor	; actorSkirts
						actorArmorList[4] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty

						int idx = 0
						while idx < actorArmorList.length 													
							if actorArmorList[idx] && isWeakArmor(actorArmorList[idx])
								playerRef.RemoveItem(actorArmorList[idx])
								idx = actorArmorList.length
							endif 							
							idx += 1
						endwhile
					endif
				endif
			endif			
			isPowerDamange = true

			; 파워 공격에 추가 데미지 적용
			nakedDamagePenalty = 20.0
			SoundCoolTimePlay(SayCombatCriticalHitSound, _volume=0.6, _coolTime=2.0)
		else 
			SoundCoolTimePlay(SayCombatHitSound, _volume=0.6, _coolTime=2.0)
		endif

		float penaltyHealthValue = playerRef.GetActorValue("Health")
		bool  getPenalty = false
		if PlayerNakeState.GetValue() == 1
			penaltyHealthValue = penaltyHealthValue / nakedDamagePenalty
			getPenalty = true
		endif

		if PlayerDrunkState.GetValue() == 1
			penaltyHealthValue = penaltyHealthValue / drunkDamagePenalty
			getPenalty = true
		endif

		if getPenalty
			playerRef.DamageActorValue("Health", penaltyHealthValue)
		endif		
	endif

	Log("health " +  playerRef.GetActorValue("Health"))
EndEvent

Event OnUpdate()
	; sound play
	if runningCoolTimeSoundRes != None		
		Sound.SetInstanceVolume(runningCoolTimeSoundRes.Play(playerRef), runningCoolTimeSoundVolume)
		runningCoolTimeSoundRes = none 
		runningCoolTimeSoundVolume = 0.0
	endif
EndEvent
;
;	Utility
;
bool function isWeakArmor(Armor _armor)
	if _armor.GetEnchantment() == none	; 마법옷이라면, burn 되지 않음
		if _armor.IsClothingBody()
			return true
		elseif _armor.IsClothingHead()
			return true
		elseif _armor.IsClothingFeet()
			return true
		elseif _armor.IsClothingHands()
			return true
		endif
	endif
	return false
endFunction 

bool function checkFireSpell(form _akSource)
	Spell magicSpell = _akSource as spell
	MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

	int idxx=0
	while idxx < magicEffects.length
		; 불 데미지라면 옷이 불에탐
		if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
			return true
		endif
		idxx += 1
	endwhile

	return false
endfunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.5, float _coolTime = 1.0, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
	float currentTime = Utility.GetCurrentRealTime()
	if !playerRef.IsSwimming() && currentTime >= soundCoolTime && currentTime >= coolTimeMap[_mapIdx] 
		soundCoolTime = currentTime + _coolTime
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime
		if _delay != 0.0
			UnregisterForUpdate()
			runningCoolTimeSoundRes = _sound
			runningCoolTimeSoundVolume = _volume
			RegisterForSingleUpdate(_delay)
		else 
			runningCoolTimeSoundRes = none
			runningCoolTimeSoundVolume = 0.0
			int _soundId = _sound.Play(playerRef)
			Sound.SetInstanceVolume(_soundId, _volume)
		endif
	endif
endFunction

function SoundPlay(Sound _sound, float _volume = 0.8)
	if !playerRef.IsSwimming() 
		Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)
	endif
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction


GlobalVariable property PlayerNakeState Auto
GlobalVariable property PlayerDrunkState Auto

Actor property playerRef Auto

; Combat
	; start/end
Sound property SayCombatStartSound Auto				
Sound property SayCombatEndSound Auto				

Sound property SayCombatStartSneakSound Auto				
Sound property SayCombatEndSneakSound Auto	

	; under attack
Sound property SayCombatHitSound Auto
Sound property SayCombatCriticalHitSound Auto

	; shield
Sound property SayCombatBlockSound Auto				

	; bow
Sound property SayCombatBowDrawSound Auto
Sound property SayCombatBowDrawSneakSound Auto
Sound property SayCombatBowReleaseSound Auto
Sound property SayCombatBowReleaseSneakSound Auto

	; weapon
Sound property SayCombatAttackNoviceSound Auto
Sound property SayCombatPowerAttackNoviceSound Auto

Sound property SayCombatAttackApprenticeSound Auto
Sound property SayCombatPowerAttackApprenticeSound Auto

Sound property SayCombatAttackExpertSound Auto
Sound property SayCombatPowerAttackExpertSound Auto

	; health
Sound property SayCombatBleedOutSound Auto

; Magic
	; fire
Sound property SayMagicFireCastSound Auto					
Sound property SayMagicFireRitualSound Auto				

	; frost
Sound property SayMagicFrostCastSound Auto				
Sound property SayMagicFrostRitualSound Auto			

	; shock
Sound property SayMagicShockCastSound Auto				
Sound property SayMagicShockRitualSound Auto			
	
	; light
Sound property SayMagicLightCastSound Auto				
Sound property SayMagicLightRitualSound Auto			

	; poison
Sound property SayMagicPoisonCastSound Auto				
Sound property SayMagicPoisonRitualSound Auto			

	; voice
Sound property SayMagicVoiceCastSound Auto

	; heal
Sound property SayMagicHealCastSound Auto			
Sound property SayMagicHealSelfSound Auto		

	; weapon strong
Sound property SayMagicWeaponSelfSound Auto

	; candle light
Sound property SayMagicCandleLightSelfSound Auto	

	; summon
Sound property SayMagicUndeadSound Auto					
Sound property SayMagicSummonSound Auto					

Sound property SayMagicDefaultSound Auto