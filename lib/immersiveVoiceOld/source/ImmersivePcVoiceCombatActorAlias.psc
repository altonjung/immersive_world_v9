scriptname ImmersivePcVoiceCombatActorAlias extends ReferenceAlias

int    underAttackCountByAnimal
int    underAttackCountByNpc
float[] coolTimeMap

Sound  runningCoolTimeSoundRes
float  runningCoolTimeSoundVolume
float  runningCoolTimeSoundCurtime
float  runningCoolTimeSoundCoolingTime

int    killCount 
bool   isInjury

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
	runningCoolTimeSoundCurtime = 0.0
	runningCoolTimeSoundCoolingTime = 0.0

	underAttackCountByAnimal = 0
	underAttackCountByNpc = 0

	isInjury = false

	killCount = 0
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
	RegisterForAnimationEvent(playerRef, "weaponSheathe")
endFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	if asEventName == "weaponDraw"
		pcVoiceMCM.isWeaponDraw = true
		float volume = 0.4 
		if pcVoiceMCM.isInField 
			volume = 0.6
		endif
		if playerRef.IsInCombat()
			if playerRef.IsSneaking()
				SoundCoolTimePlay(SayCombatBeginSneakSound, _volume = volume, _delay=0.3, _coolTime=3.0)
			else 
				SoundCoolTimePlay(SayCombatBeginSound,_volume = volume, _delay=0.3, _coolTime=3.0)
			endif
		else 
			SoundCoolTimePlay(SayCombatBeginIdleSound, _volume = volume, _delay=0.3, _coolTime=3.0)
		endif 
	elseif asEventName == "weaponSheathe"
		pcVoiceMCM.isWeaponDraw = false
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
		SoundCoolTimePlay(SoundEffectBowDrawInit, _delay=0.1, _volume=0.5, _coolTime=0.3, _mapIdx=1, _mapCoolTime=30.0)
	elseif asEventName == "bowDrawn"
		float _skillLevel = playerRef.GetAV("Marksman")
		if _skillLevel <= 40
			if Utility.RandomInt(0, 9) == 0		; 10%
				Game.ShakeCamera(afDuration = 0.5)
			endif
		endif 
		
		if playerRef.IsSneaking()
			SoundCoolTimePlay(SayCombatBowDrawSneakSound, _delay=0.3, _volume=0.4, _coolTime=3.0, _mapIdx=2, _mapCoolTime=3.0)
		else
			SoundCoolTimePlay(SayCombatBowDrawSound, _delay=0.3, _volume=0.5, _coolTime=3.0, _mapIdx=2, _mapCoolTime=3.0)
		endif	
	endif
endEvent

; player bow release
Event OnPlayerBowShot(Weapon akWeapon, Ammo akAmmo, float afPower, bool abSunGazing)
	if !pcVoiceMCM.isGameRunning
		return 
	endif
	clearRunnintSoundRes()
	if afPower >= 0.85
		if akAmmo.HasKeyWordString("fireArrow")
			soundPlay(SoundEffectFireRelease, 0.6)
		else
			SoundPlay(SoundEffectBowRelease, 0.6)
		endif 			

		if playerRef.IsSneaking()
			SoundCoolTimePlay(SayCombatBowReleaseSneakSound, _volume=0.4, _coolTime=1.0, _mapIdx=3, _mapCoolTime=0.5)
		else
			SoundCoolTimePlay(SayCombatBowReleaseSound, _volume=0.5, _coolTime=1.0, _mapIdx=3, _mapCoolTime=0.5)
		endif
	endif	
EndEvent

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	if akActor == playerRef
		if actionType == 1
			Spell magicSpell = source as spell
			if magicSpell
				MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

				if magicEffects
					int idxx=0
					while idxx < magicEffects.length
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
							int castingType = magicEffects[idxx].GetCastingType()						
							int deliveryType = magicEffects[idxx].GetDeliveryType()
							; Log("Magic Cast from MagicRestoreHealth")
							if deliveryType == 0  ; self
								SoundCoolTimePlay(SayMagicHealSelfSound, _coolTime=2.0)
							else 				  ; others
								SoundCoolTimePlay(SayMagicHealCastSound, _coolTime=2.0)
							endif 
							return 					
						elseif magicEffects[idxx].HasKeyWordString("MagicCandleLight")							
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

Event OnPlayerCameraState(int oldState, int newState)
EndEvent

Event OnActorKilled(Actor akVictim, Actor akKiller)
	if !pcVoiceMCM.isGameRunning
		return
	endif

	if akKiller == playerRef
		killCount += 1

		if !playerRef.IsInCombat()
			if playerRef.getDistance(akVictim)  <= 1024.0
				clearRunnintSoundRes()
				Utility.Wait(1.0)				
				if pcVoiceMCM.isInField
					if akVictim.getFactionRank(BanditFaction) > -2 ; 산적
						SoundCoolTimePlay(SayCombatEndBanditSound, _volume=0.5)
					elseif akVictim.getFactionRank(WolfFaction) > -2 ; 늑대				
						SoundCoolTimePlay(SayCombatEndWolfSound, _volume=0.5)
					else
						SoundCoolTimePlay(SayCombatEndSound, _volume=0.5)
					endif					
				else 
					if akVictim.getFactionRank(BanditFaction) > -2 ; 산적
						SoundCoolTimePlay(SayCombatEndBanditSound, _volume=0.5)
					else
						SoundCoolTimePlay(SayCombatEndSound, _volume=0.5)
					endif
				endif

				if playerRef.IsWeaponDrawn()
					if pcVoiceMCM.enableCombatMotion
						playerRef.SheatheWeapon()

						; Debug.SendAnimationEvent(playerRef, "ImmPrayKneelStart")
						; Utility.Wait(3.0)
						; Debug.SendAnimationEvent(playerRef, _clotheCheckAnimation + "End")
						; Utility.wait(3.0)
					endif
				endif
			endif

			Debug.Notification("Total kill " + killCount)
			killCount = 0
			underAttackCountByAnimal = 0
			underAttackCountByNpc = 0
		endif
	endif
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)	
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	if abHitBlocked
	else
		weapon _weapon = akSource as weapon 
		bool isStrong = pcVoiceMCM.isStrongWeapon(_weapon)
		bool isBow = pcVoiceMCM.isBowWeapon(_weapon)
		bool isUnarm = pcVoiceMCM.isUnarmWeapon(_weapon)
		float healthValue = playerRef.GetActorValuePercentage("Health")

		if pcVoiceMCM.wornArmor && pcVoiceMCM.wornArmor.IsHeavyArmor()
			if isStrong || isBow
				SoundPlay(SoundEffectHitSteelArmor, 0.4)
			endif
		endif

		; if pcVoiceMCM.enableCombatMotion
		; 	if isBow
		; 		if isInjury == false					
		; 			int _random = Utility.randomInt(1, 10)
		; 			isInjury = TRUE
		; 			if _random > 7	; 30%
		; 				Debug.SendAnimationEvent(playerRef, "ImmStaggerBackSmall")
		; 				Utility.Wait(0.2)
		; 				if playerRef.IsWeaponDrawn()
		; 					playerRef.SheatheWeapon()
		; 					playerRef.DrawWeapon()
		; 				endif
		; 			endif
		; 			isInjury = false
		; 		endif
		; 	endif
		; endif

		if abPowerAttack
			float staminaValue = playerRef.GetActorValuePercentage("Stamina")
			Actor aggressor = akAggressor as Actor

			; 무기에 의한 강력한 공격으로 중갑옷이 벗겨질수 있음
			if isStrong
				underAttackCountByNpc += 1

				if (underAttackCountByNpc > 2 && staminaValue <= 0.15) || playerRef.IsBleedingOut()
					Armor[] actorArmorList = new Armor[4]
					actorArmorList[0]	= playerRef.GetWornForm(0x00000001) As Armor	; actorHead
					actorArmorList[1] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
					actorArmorList[2]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor
					actorArmorList[3] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty

					int idx = 0
					while idx < actorArmorList.length 													
						if actorArmorList[idx] && pcVoiceMCM.isStrongArmor(actorArmorList[idx])
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
			elseif isUnarm 
				if aggressor.HasKeyWordString("ActorTypeAnimal")	; unarm
					underAttackCountByAnimal += 1

					if (underAttackCountByAnimal > 3 && staminaValue <= 0.25) || playerRef.IsBleedingOut()
						Armor[] actorArmorList = new Armor[6]
						actorArmorList[0] 	= playerRef.GetWornForm(0x00008000) as Armor	; actorSkirts
						actorArmorList[1] 	= playerRef.GetWornForm(0x00800000) as Armor	; actorThigh
						actorArmorList[2]	= playerRef.GetWornForm(0x00000080) As Armor	; actorBoot											
						actorArmorList[3] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak					
						actorArmorList[4]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor		
						actorArmorList[5] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty
					
						int idx = 0
						while idx < actorArmorList.length 													
							if actorArmorList[idx] && pcVoiceMCM.isWeakArmor(actorArmorList[idx])
								playerRef.DropObject(actorArmorList[idx])
								idx = actorArmorList.length 
							endif
							idx += 1
						endwhile
						underAttackCountByAnimal /= 2
					endif
				endif
			; 불길로 인해 옷이 타버릴 수 있음
			elseif pcVoiceMCM.checkFireSpell(akSource)
				bool doStrip = false
				if  aggressor.HasKeyWordString("ActorTypeDragon")
					if Utility.randomInt(1, 10) > 7
						doStrip = true
					endif
				else 
					if Utility.randomInt(1, 10) > 9
						doStrip = true
					endif
				endif

				if doStrip
						Armor[] actorArmorList = new Armor[4]
						actorArmorList[0] 	= playerRef.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
						actorArmorList[1]	= playerRef.GetWornForm(0x00000004) as Armor	; actorArmor
						actorArmorList[2] 	= playerRef.GetWornForm(0x00008000) as Armor	; actorSkirts
						actorArmorList[3] 	= playerRef.GetWornForm(0x00400000) as Armor	; actorPanty

						int idx = 0
						while idx < actorArmorList.length 													
							if actorArmorList[idx] && pcVoiceMCM.isBurnArmor(actorArmorList[idx])
								playerRef.RemoveItem(actorArmorList[idx])
								idx += 3
							endif 							
							idx += 1
						endwhile
				endif
			endif
			SoundCoolTimePlay(SayCombatCriticalHitSound, _volume=0.4, _coolTime=3.0)
		else 
			if pcVoiceMCM.isNaked
				SoundCoolTimePlay(SayCombatCriticalHitSound, _volume=0.4, _coolTime=3.0)
			else
				SoundCoolTimePlay(SayCombatHitSound, _volume=0.3, _coolTime=3.0)
			endif
		endif
			
		if pcVoiceMCM.isNaked
			healthValue = (healthValue * 100) / 25.0				
			playerRef.DamageActorValue("Health", healthValue)
		endif
		; pcVoiceMCM.log("hitVolume " + _hitVolume)
	endif
EndEvent

; Event received when an actor enters bleedout.
Event OnEnterBleedout()
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	SoundCoolTimePlay(SayCombatBleedOutSound, _volume=0.4, _coolTime=5.0)	
EndEvent

Event OnDying(Actor akKiller)
	if !pcVoiceMCM.isGameRunning
		return 
	endif

	SoundCoolTimePlay(SayCombatDyingSound, _volume=0.4, _coolTime=5.0)
EndEvent

Event OnUpdate()
	if !pcVoiceMCM.isGameRunning
		return
	endif

	; sound play
	if runningCoolTimeSoundRes != None		
		pcVoiceMCM.soundCoolTime = runningCoolTimeSoundCurtime + runningCoolTimeSoundCoolingTime
		Sound.SetInstanceVolume(runningCoolTimeSoundRes.Play(playerRef), runningCoolTimeSoundVolume)		
		runningCoolTimeSoundRes = none
		runningCoolTimeSoundVolume = 0.0
		runningCoolTimeSoundCoolingTime = 0.0
		runningCoolTimeSoundCurtime = 0.0
	endif
EndEvent

;
;	Utility
;
function clearRunnintSoundRes()
	UnregisterForUpdate()
	runningCoolTimeSoundRes = none	
	pcVoiceMCM.soundCoolTime = 0.0
	coolTimeMap[0] = 0.0
endFunction

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 0.5, float _delay = 0.0, int _mapIdx = 0, float _mapCoolTime = 1.0)
	if pcVoiceMCM.enableCombatSound == false || playerRef.IsSwimming()
		return
	endif

	float currentTime = Utility.GetCurrentRealTime()
	if currentTime > pcVoiceMCM.soundCoolTime && currentTime > coolTimeMap[_mapIdx] 
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime + _delay		
		if _delay == 0.0			
			pcVoiceMCM.soundCoolTime = currentTime + _coolTime + _delay
			runningCoolTimeSoundRes = none
			runningCoolTimeSoundVolume = 0.0
			int _soundId = _sound.Play(playerRef)
			Sound.SetInstanceVolume(_soundId, _volume)
		else 
			runningCoolTimeSoundRes = _sound
			runningCoolTimeSoundVolume = _volume
			runningCoolTimeSoundCurtime = currentTime
			runningCoolTimeSoundCoolingTime = _coolTime
			UnregisterForUpdate()
			RegisterForSingleUpdate(_delay)
		endif
	endif
endFunction

function SoundPlay(Sound _sound, float _volume = 0.8)
	if pcVoiceMCM.enableCombatSound == false || playerRef.IsSwimming()
		return
	endif

	Sound.SetInstanceVolume(_sound.Play(playerRef), _volume)	
endFunction

ImmersivePcVoiceMCM property pcVoiceMCM Auto

Actor property playerRef Auto

; Combat
	; start/end
Sound property SayCombatBeginIdleSound Auto
Sound property SayCombatBeginSound Auto
Sound property SayCombatBeginSneakSound Auto

Sound property SayCombatEndSound Auto
Sound property SayCombatEndWolfSound Auto
Sound property SayCombatEndBanditSound Auto

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
; Sound property SayMagicWeaponSelfSound Auto

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

; 
Faction property WolfFaction Auto
Faction property BanditFaction Auto