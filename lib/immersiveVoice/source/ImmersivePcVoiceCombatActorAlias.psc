scriptname ImmersivePcVoiceCombatActorAlias extends ReferenceAlias

int    underAttackCountByAnimal
float  soundCoolTime
float[] coolTimeMap

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
	underAttackCountByAnimal = 0
	soundCoolTime = 0.0	
	coolTimeMap = new float[10]
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
		Log("weaponDraw")
		if playerRef.IsSneaking()
			SoundCoolTimePlay(SayCombatStartSneakSound, 0.4, 0.0, 1.5)
		else 
			SoundCoolTimePlay(SayCombatStartSound, 0.4, 0.0, 1.5)
		endif
	elseif asEventName == "weaponLeftSwing" || asEventName == "weaponSwing"
		if playerRef.GetAnimationVariableBool("bAllowRotation") 
			SoundCoolTimePlay(SayCombatNormalAttackSound, 0.5, 0.0)
		else 
			SoundCoolTimePlay(SayCombatPowerAttackSound, 0.5, 0.0)
		endif		
		Log("Weapon Swing")		
	endif
	
	; Log("OnAnimationEvent " + asEventName)
endEvent

Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	if akActor == playerRef	
		if actionType == 1
			Spell magicSpell = source as spell
			MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

			int idxx=0
			while idxx < magicEffects.length
				int castingType = magicEffects[idxx].GetCastingType()
				int deliveryType = magicEffects[idxx].GetDeliveryType()

				if magicEffects[idxx].HasKeyWordString("RitualSpellEffect")
					if magicEffects[idxx].HasKeyWordString("MagicDamageFire")
						Log("Magic Cast from RitualSpellEffect and MagicDamageFire")
						SoundCoolTimePlay(SayMagicFireRitualSound)
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
						Log("Magic Cast from RitualSpellEffect and MagicDamageFrost")
						SoundCoolTimePlay(SayMagicFrostRitualSound)
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
						Log("Magic Cast from RitualSpellEffect and MagicDamageShock")
						SoundCoolTimePlay(SayMagicShockRitualSound)
					elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
						Log("Magic Cast from RitualSpellEffect and MagicDamageLight")
						SoundCoolTimePlay(SayMagicLightRitualSound)
					elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
						Log("Magic Cast from RitualSpellEffect and MagicDamagePoison")
						SoundCoolTimePlay(SayMagicPoisonRitualSound)
					else 
						Log("Magic Cast from RitualSpellEffect")
					endif 
					return 
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageFire")
					Log("Magic Cast from MagicDamageFire")
					SoundCoolTimePlay(SayMagicFireCastSound)
					return 
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
					SoundCoolTimePlay(SayMagicFrostCastSound)
					Log("Magic Cast from MagicDamageFrost")
					return 
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
					SoundCoolTimePlay(SayMagicShockCastSound)
					Log("Magic Cast from MagicDamageShock")
					return 						
				elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
					SoundCoolTimePlay(SayMagicLightCastSound)
					Log("Magic Cast from MagicDamageLight")
					return 			
				elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
					SoundCoolTimePlay(SayMagicPoisonCastSound)
					Log("Magic Cast from MagicDamagePoison")
					return 									
				elseif magicEffects[idxx].HasKeyWordString("MagicRestoreHealth")
					Log("Magic Cast from MagicRestoreHealth")
					if deliveryType == 0  ; self
						SoundCoolTimePlay(SayMagicHealSelfSound)
					else 				  ; others
						SoundCoolTimePlay(SayMagicHealCastSound)
					endif 
					return 					
				elseif magicEffects[idxx].HasKeyWordString("MagicCandleLight")
					Log("Magic Cast from MagicCandleLight")
					SoundCoolTimePlay(SayMagicCandleLightSelfSound)					
					return
				elseif magicEffects[idxx].HasKeyWordString("MagicTurnUndead") || magicEffects[idxx].HasKeyWordString("MagicSummonShock") || magicEffects[idxx].HasKeyWordString("MagicSummonFrost") || magicEffects[idxx].HasKeyWordString("MagicSummonLight")
					SoundCoolTimePlay(SayMagicSummonSound)
					Log("Magic Cast from MagicSummon")
					return 									
				else 
					SoundCoolTimePlay(SayMagicDefaultSound)
					Log("Magic Cast from MagicDefault")
				endif
				idxx += 1
			endwhile
		elseif actionType == 5 ; bow draw
			if playerRef.IsSneaking()
				SoundCoolTimePlay(SayCombatBowDrawSneakSound)
			else
				SoundCoolTimePlay(SayCombatBowDrawSound)
			endif

			log("bow draw")
		elseif actionType == 6 ; bow release
			if playerRef.IsSneaking()
				SoundCoolTimePlay(SayCombatBowReleaseSneakSound)
			else 
				SoundCoolTimePlay(SayCombatBowReleaseSound)
			endif
			log("bow release")
		endif			
	endif
EndEvent

Event OnActorKilled(Actor akVictim, Actor akKiller)	
	if akKiller == playerRef && playerRef.IsInCombat() == false
		playerRef.SheatheWeapon()
		if playerRef.IsSneaking()
			SoundCoolTimePlay(SayCombatEndSneakSound, 0.6, 1.5)
		else
			SoundCoolTimePlay(SayCombatEndSound, 0.6, 1.5)
		endif
	endif
EndEvent
	
; Event that is triggered when this actor finishes dying
Event OnDeath(Actor akKiller)
	SoundCoolTimePlay(SayCombatDeathEndSound)
	Log("OnDeath")
EndEvent

; Event received when an actor enters bleedout.
Event OnEnterBleedout()
	SoundCoolTimePlay(SayCombatBleedOutSound)
	Log("OnEnterBleedout")
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)	
	
	; playerRef.SetRelationshipRank(akAggressor, -1)

	if abHitBlocked
		SoundCoolTimePlay(SayCombatBlockSound, 0.7, 0.1, 1.5)
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

			nakedDamagePenalty = 20.0
			isPowerDamange = true
		endif

		; 데미지 처리
		if isPowerDamange
			SoundCoolTimePlay(SayCombatCriticalHitSound, 0.7, 0.1, 1.5)
		else 
			SoundCoolTimePlay(SayCombatNormalHitSound, 0.5, 0.1, 1.5)
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
			playerRef.DamageActorValue("Health", playerRef.GetActorValue("Health"))
		endif		
	endif

	Log("health " +  playerRef.GetActorValue("Health"))
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

int function SoundCoolTimePlay(Sound _sound, float _volume = 0.6, float _sleep = 0.2,float _gCoolTime = 3.0, int _mapIdx = 0, float _mapCoolTime = 0.5)
	float currentTime = Utility.GetCurrentRealTime()
	int _soundId = 0

	if currentTime >= soundCoolTime && currentTime > coolTimeMap[_mapIdx]
		soundCoolTime = currentTime + _gCoolTime
		coolTimeMap[_mapIdx] = currentTime + _mapCoolTime
		
		utility.WaitMenuMode(_sleep)		
		_soundId = _sound.Play(playerRef)
		Sound.SetInstanceVolume(_soundId, _volume)		
	endif
	return _soundId
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
Sound property SayCombatNormalHitSound Auto			
Sound property SayCombatCriticalHitSound Auto		

	; shield
Sound property SayCombatBlockSound Auto				

	; bow
Sound property SayCombatBowDrawSound Auto
Sound property SayCombatBowDrawSneakSound Auto
Sound property SayCombatBowReleaseSound Auto
Sound property SayCombatBowReleaseSneakSound Auto

	; weapon | unarm
Sound property SayCombatNormalAttackSound Auto
Sound property SayCombatPowerAttackSound Auto

	; health
Sound property SayCombatDeathEndSound Auto
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