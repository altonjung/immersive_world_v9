scriptname ImmersivePcVoiceCombatActorAlias extends ReferenceAlias

int    underAttackCountByAnimal
int    underAttackCountByNpc
float[] coolTimeMap

Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume

float  bowDrawCalculate

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
	; RegisterForActorAction(5) ; bow draw
	; RegisterForActorAction(6) ; bow release 

	regAnimation()
endFunction

function init ()		
	runningCoolTimeSoundRes = None
	runningCoolTimeSoundVolume = 0.0
	underAttackCountByAnimal = 0
	underAttackCountByNpc = 0

	bowDrawCalculate = 0
	coolTimeMap = new float[5]
endFunction

function regAnimation ()
	; bow
	RegisterForAnimationEvent(playerRef, "bowDraw")
	RegisterForAnimationEvent(playerRef, "BowDrawn")	; full draw	
	; RegisterForAnimationEvent(playerRef, "BowRelease")

	; weapon
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
		bool isExpertLevel = false
		; getSkill Level
		float oneHandSkillLevel = playerRef.GetAV("OneHanded")
		if oneHandSkillLevel >= 60
			isExpertLevel = true
		endif 

		if !isExpertLevel
			float twoHandSkillLevel = playerRef.GetAV("TwoHanded")
			if twoHandSkillLevel >= 45
				isExpertLevel = true
			endif 
		endif

		
		if playerRef.GetAnimationVariableBool("bAllowRotation")
			if isExpertLevel
				SoundCoolTimePlay(SayCombatPowerAttackExpertSound, _coolTime=1.5)					
			else
				SoundCoolTimePlay(SayCombatPowerAttackNoviceSound, _coolTime=1.5)
			endif
		else
			if isExpertLevel
				SoundCoolTimePlay(SayCombatAttackExpertSound, _volume=0.4, _coolTime=1.0)					
			else
				SoundCoolTimePlay(SayCombatAttackNoviceSound, _volume=0.4, _coolTime=1.0)
			endif
		endif
	elseif asEventName == "bowDraw"
		SoundCoolTimePlay(SoundEffectBowDrawInit, _delay=0.2, _volume=0.5, _coolTime=0.3, _mapIdx=1, _mapCoolTime=60.0)
		bowDrawCalculate = Utility.GetCurrentRealTime()
	elseif asEventName == "bowDrawn"		
		float _skillLevel = playerRef.GetAV("Marksman")
		if _skillLevel <= 40 || playerRef.GetActorValue("Stamina") <= 30.0
			if Utility.RandomInt(0, 4) == 0
				Game.ShakeCamera(afDuration = 0.5)
			endif
		endif
		
		if playerRef.IsSneaking()
			SoundCoolTimePlay(SayCombatBowDrawSneakSound, _delay=1.0, _volume=0.4, _coolTime=2.0, _mapIdx=2, _mapCoolTime=2.0)
		else
			SoundCoolTimePlay(SayCombatBowDrawSound, _delay=1.0, _volume=0.5, _coolTime=2.0, _mapIdx=2, _mapCoolTime=2.0)
		endif
		bowDrawCalculate = Utility.GetCurrentRealTime()
	endif
endEvent

; player bow release
Event OnPlayerBowShot(Weapon akWeapon, Ammo akAmmo, float afPower, bool abSunGazing)
	clearRunnintSoundRes()

	if akAmmo.HasKeyWordString("fireArrow")
		soundPlay(SoundEffectFireRelease, 0.6)
	endif 

	if afPower >= 0.8
		SoundPlay(SoundEffectBowRelease, 0.6)

		if afPower == 1.0
			if playerRef.IsSneaking()
				SoundCoolTimePlay(SayCombatBowReleaseSneakSound, _volume=0.4, _coolTime=0.5, _mapIdx=3, _mapCoolTime=0.5)
			else
				SoundCoolTimePlay(SayCombatBowReleaseSound, _volume=0.5, _coolTime=0.5, _mapIdx=3, _mapCoolTime=0.5)
			endif
		endif			
	endif	
EndEvent

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	if akActor == playerRef
		if actionType == 1
			Spell magicSpell = source as spell
			if magicSpell
				MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

				if magicEffects
					int idxx=0
					while idxx < magicEffects.length
						int castingType = magicEffects[idxx].GetCastingType()
						int deliveryType = magicEffects[idxx].GetDeliveryType()

						if magicEffects[idxx].HasKeyWordString("RitualSpellEffect")
							SoundCoolTimePlay(SoundEffectMagicInit, _volume=0.5, _coolTime=0.3)
							if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
								; Log("Magic Cast from RitualSpellEffect and MagicDamageFire")
								SoundCoolTimePlay(SayMagicFireRitualSound, _delay=0.5, _coolTime=3.0)
							elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
								; Log("Magic Cast from RitualSpellEffect and MagicDamageFrost")
								SoundCoolTimePlay(SayMagicFrostRitualSound, _delay=0.5, _coolTime=3.0)
							elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
								; Log("Magic Cast from RitualSpellEffect and MagicDamageShock")
								SoundCoolTimePlay(SayMagicShockRitualSound, _delay=0.5, _coolTime=3.0)
							elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
								; Log("Magic Cast from RitualSpellEffect and MagicDamageLight")
								SoundCoolTimePlay(SayMagicLightRitualSound, _delay=0.5, _coolTime=3.0)
							elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
								; Log("Magic Cast from RitualSpellEffect and MagicDamagePoison")
								SoundCoolTimePlay(SayMagicPoisonRitualSound, _delay=0.5, _coolTime=3.0)
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
							return
						endif
						idxx += 1
					endwhile
				endif
			endif
		endif
	endif
EndEvent

Event OnActorKilled(Actor akVictim, Actor akKiller)
	if akKiller == playerRef && playerRef.IsInCombat() == false
		
		if playerRef.IsSneaking()
			SoundCoolTimePlay(SayCombatEndSneakSound, _delay=0.5, _volume=0.5)
		else
			SoundCoolTimePlay(SayCombatEndSound, _delay=0.5, _volume=0.5)
		endif

		playerRef.SheatheWeapon()
		if akVictim.hasKeywordString("ActorTypeNPC")
			Utility.Wait(0.3)
			Debug.SendAnimationEvent(playerRef, "IdleGreybeardMeditateEnter")
			Utility.Wait(3.0)
			Debug.SendAnimationEvent(playerRef, "idleGreybeardMeditateExit")
			utility.wait(2.0)
		endif

		underAttackCountByAnimal = 0
		underAttackCountByNpc = 0
	endif
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)	
		
	if abHitBlocked
	Else	
		float healthValue = playerRef.GetActorValuePercentage("Health")	
		float healthValuePercentage = playerRef.GetActorValuePercentage("Health")	
		float _hitVolume = 0.5
		if healthValuePercentage >= 0.7
			_hitVolume = 0.1
		elseif healthValuePercentage >= 0.5
			_hitVolume = 0.2
		elseif healthValuePercentage >= 0.3
			_hitVolume = 0.3		
		endif

		if abPowerAttack || abBashAttack

			; heavy armor 인 경우 steel 사운드 출력
			bool  wornStrongArmor = false
			Armor _wornArmor = playerRef.GetWornForm(0x00000004) as Armor
			
			if _wornArmor
				if _wornArmor.IsHeavyArmor()
	
					SoundPlay(SoundEffectHitSteelArmor, 0.6)
					wornStrongArmor = true
				endif
			endif		

			; 옷 상태 처리
			Actor aggressor = akAggressor as Actor

			; 사람에 의한 강력한 공격으로 중갑옷이 벗겨질수 있음
			if aggressor.HasKeyWordString("ActorTypeNPC")
				underAttackCountByNpc += 1

				if underAttackCountByNpc > 15 && Utility.randomInt(0, 1) == 0
					Armor[] actorArmorList = new Armor[4]
					actorArmorList[0]	= playerRef.GetWornForm(0x00000001) As Armor	; actorHead
					actorArmorList[1] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
					actorArmorList[2]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor
					actorArmorList[3] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty

					int idx = 0
					while idx < actorArmorList.length 													
						if actorArmorList[idx] && isStrongArmor(actorArmorList[idx])
							playerRef.DropObject(actorArmorList[idx])
							idx = actorArmorList.length 
						elseif actorArmorList[idx]
							playerRef.RemoveItem(actorArmorList[idx])
							idx = actorArmorList.length 
						endif
						idx += 1
					endwhile
					underAttackCountByNpc /= 2
				endif
			; 동물들 공격에 의해 옷이 벗겨질 수 있음
			elseif aggressor.HasKeyWordString("ActorTypeAnimal")
				underAttackCountByAnimal += 1

				if underAttackCountByAnimal > 10 && Utility.randomInt(0, 1) == 0
					Armor[] actorArmorList = new Armor[8]
					actorArmorList[0]	= playerRef.GetWornForm(0x00000008) As Armor	; actorHand
					actorArmorList[1]	= playerRef.GetWornForm(0x00000010) As Armor	; actorArm
					actorArmorList[2] 	= playerRef.GetWornForm(0x00008000) as Armor	; actorSkirts
					actorArmorList[3] 	= playerRef.GetWornForm(0x00800000) as Armor	; actorThigh
					actorArmorList[4]	= playerRef.GetWornForm(0x00000080) As Armor	; actorBoot											
					actorArmorList[5] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak					
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
					underAttackCountByAnimal /= 2
				endif
			; 용 불길로 인해 옷이 타버릴 수 있음
			elseif aggressor.HasKeyWordString("ActorTypeDragon")
				if Utility.randomInt(0,4) == 0
					if checkFireSpell(akSource)				
						Armor[] actorArmorList = new Armor[6]
						actorArmorList[0]	= playerRef.GetWornForm(0x00000001) As Armor	; actorHead
						actorArmorList[1] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
						actorArmorList[2]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor
						actorArmorList[3] 	= playerRef.GetWornForm(0x00800000) as Armor	; actorThigh
						actorArmorList[4] 	= playerRef.GetWornForm(0x00008000) as Armor	; actorSkirts
						actorArmorList[5] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty

						int idx = 0
						while idx < actorArmorList.length 													
							if actorArmorList[idx] && isBurnArmor(actorArmorList[idx])
								playerRef.RemoveItem(actorArmorList[idx])
								idx += 3
							endif 							
							idx += 1
						endwhile
					endif
				endif
			endif
			SoundCoolTimePlay(SayCombatCriticalHitSound, _volume=_hitVolume, _coolTime=3.0)
		else 
			if PlayerNakeState.GetValue() == 1
				SoundCoolTimePlay(SayCombatCriticalHitSound, _volume=0.6, _coolTime=3.0)
			else 
				SoundCoolTimePlay(SayCombatHitSound, _volume=_hitVolume, _coolTime=3.0)
			endif
		endif
			
		if PlayerNakeState.GetValue() == 1
			healthValue = healthValue / 20.0				
			playerRef.DamageActorValue("Health", healthValue)
		endif

		if PlayerDrunkState.GetValue() == 1
			healthValue = healthValue / 10.0
			playerRef.DamageActorValue("Health", healthValue)
		endif	
	endif
EndEvent

; Event received when an actor enters bleedout.
Event OnEnterBleedout()
	SoundCoolTimePlay(SayCombatBleedOutSound, _volume=0.4, _coolTime=5.0)
	Log("OnEnterBleedout")
EndEvent

Event OnDying(Actor akKiller)
	SoundCoolTimePlay(SayCombatDyingSound, _volume=0.4, _coolTime=5.0)
	Log("OnDying")
EndEvent

Event OnUpdate()
	; sound play
	if runningCoolTimeSoundRes != None		
		Sound.SetInstanceVolume(runningCoolTimeSoundRes.Play(playerRef), runningCoolTimeSoundVolume)
		clearRunnintSoundRes()		
	endif
EndEvent

;
;	Utility
;
function clearRunnintSoundRes()	
	soundCoolTime.setValue(0.0)
	runningCoolTimeSoundRes = none
	UnregisterForUpdate()	
endFunction

bool function isBurnArmor(Armor _armor)
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

bool function isWeakArmor(Armor _armor)
	if _armor.IsClothingBody()
		return true
	elseif _armor.IsClothingHead()
		return true
	elseif _armor.IsClothingFeet()
		return true
	elseif _armor.IsClothingHands()
		return true
	endif
	return false
endFunction 

bool function isStrongArmor(Armor _armor)	
	if _armor.IsHeavyArmor()
		return true
	elseif _armor.IsLightArmor()
		return true
	elseif _armor.IsGauntlets()
		return true
	elseif _armor.IsCuirass()
		return true
	elseif _armor.IsHelmet()
		return true		
	elseif _armor.IsBoots()
		return true		
	endif
	
	return false
endFunction 

bool function checkFireSpell(form _akSource)
	Spell magicSpell = _akSource as spell

	if magicSpell
		MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

		int idxx=0
		while idxx < magicEffects.length
			; 불 데미지라면 옷이 불에탐
			if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
				return true
			endif
			idxx += 1
		endwhile
	endif

	return false
endfunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 0.5, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
	if pcVoiceMCM.enableCombatSound == false || playerRef.IsSwimming() 
		return
	endif

	float currentTime = Utility.GetCurrentRealTime()
	if currentTime >= soundCoolTime.getValue() && currentTime >= coolTimeMap[_mapIdx] 
		soundCoolTime.setValue(currentTime + _coolTime)
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime

		UnregisterForUpdate()
		if _delay != 0.0			
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
	if pcVoiceMCM.enableCombatSound == false || playerRef.IsSwimming() 
		return
	endif

	Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)	
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

ImmersivePcVoiceMCM property pcVoiceMCM Auto

GlobalVariable property soundCoolTime Auto
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


	; weapon
Sound property SayCombatAttackNoviceSound Auto
Sound property SayCombatPowerAttackNoviceSound Auto

Sound property SayCombatAttackExpertSound Auto
Sound property SayCombatPowerAttackExpertSound Auto

	; health
Sound property SayCombatBleedOutSound Auto
Sound property SayCombatDyingSound Auto

; Magic
Sound property SoundEffectMagicInit Auto

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

; bow
Sound property SayCombatBowDrawSound Auto
Sound property SayCombatBowDrawSneakSound Auto
Sound property SayCombatBowReleaseSound Auto
Sound property SayCombatBowReleaseSneakSound Auto

; bow draw
Sound property SoundEffectBowDrawInit Auto

; bow release
Sound property SoundEffectBowRelease Auto
Sound property SoundEffectCrossBowRelease Auto
Sound property SoundEffectFireRelease Auto

; steel armor hit
Sound property SoundEffectHitSteelArmor Auto
	