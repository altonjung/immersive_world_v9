scriptname ImmersivePcVoiceActorAlias extends ReferenceAlias

Actor playerRef 

Event OnPlayerLoadGame()		
	Debug.Notification("OnPlayerLoadGame")
	playerRef = Game.GetPlayer()

	; Play StartGameSound
	Sound.SetInstanceVolume(SayIntroSound.Play(playerRef), 0.8)
EndEvent

event OnInit()
	Setup()
endEvent

function Setup ()
	playerRef = Game.GetPlayer()
	RegisterForSleep()
	RegisterForSingleUpdateGameTime(1.0)	; 1시간 마다 onUpdate 이벤트 발생
	RegisterForActorAction(0)	; Weapon Swing or barehand
	RegisterForActorAction(1)	; Spell Cast
	RegisterForActorAction(2)	; Spell Fire
	RegisterForActorAction(3)	; Voice Cast
	RegisterForActorAction(4)	; Voice Fire
	RegisterForActorAction(5)	; Bow Draw
	RegisterForActorAction(6)	; Bow Release	
	RegisterForActorAction(8)	; Unsheathe End	- combat start
	RegisterForActorAction(10)	; Sheathe End - combat end
endFunction

; ActionTypes
; 0 - Weapon Swing (Melee weapons that are swung, also barehand)
; 1 - Spell Cast (Spells and staves)
; 2 - Spell Fire (Spells and staves)
; 3 - Voice Cast
; 4 - Voice Fire
; 5 - Bow Draw
; 6 - Bow Release
; 7 - Unsheathe Begin
; 8 - Unsheathe End
; 9 - Sheathe Begin
; 10 - Sheathe End
; Slots
; 0 - Left Hand
; 1 - Right Hand
; 2 - Voice
Event OnActorAction(int actionType, Actor akActor, Form source, int slot)
	Log("OnActorAction " + actionType)	

	if actionType == 0
		bool pAttack = akActor.GetAnimationVariableBool("bAllowRotation")

		if pAttack 
			Sound.SetInstanceVolume(SayCombatNormalAttackSound.Play(playerRef), 0.8)
		else 
			Sound.SetInstanceVolume(SayCombatPowerAttackSound.Play(playerRef), 0.8)
		endif		
	elseif actionType == 1 || actionType == 2
; int Function GetCastingType() native
	; Constant Effect     0
	; Fire And Forget     1
	; Concentration       2

; int Function GetDeliveryType() native
	; Self                0
	; Contact             1
	; Aimed               2
	; Target Actor        3
	; Target Location     4
		Spell magicSpell = source as spell
		MagicEffect[] magicEffects = magicSpell.GetMagicEffects()

		int idxx=0
		while idxx < magicEffects.length
			int castingType = magicEffects[idxx].GetCastingType()
			int deliveryType = magicEffects[idxx].GetDeliveryType()

			if magicEffects[idxx].HasKeyWordString("RitualSpellEffect")
				if magicEffects[idxx].HasKeyWordString("MagicDamageFire")

				elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")

				elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")

				elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")

				elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")

				elseif magicEffects[idxx].HasKeyWordString("MagicRestoreHealth")

				else 

				endif 
				return 
			elseif magicEffects[idxx].HasKeyWordString("MagicDamageFire")
				return 
			elseif magicEffects[idxx].HasKeyWordString("MagicDamageFrost")
				return 
			elseif magicEffects[idxx].HasKeyWordString("MagicDamageLight")
				return 	
			elseif magicEffects[idxx].HasKeyWordString("MagicDamageShock")
				return 			
			elseif magicEffects[idxx].HasKeyWordString("MagicDamagePoison")
				return 									
			elseif magicEffects[idxx].HasKeyWordString("MagicRestoreHealth")

				if deliveryType == 0  ; self 

				else 				  ; teammate

				endif 
				return 					
			elseif magicEffects[idxx].HasKeyWordString("MagicTurnUndead")
				return 									
			elseif magicEffects[idxx].HasKeyWordString("MagicSummonShock") || magicEffects[idxx].HasKeyWordString("MagicSummonFrost") || magicEffects[idxx].HasKeyWordString("MagicSummonLight")
				return 												
			endif
			idxx += 1
		endwhile
	elseif actionType == 3 && actionType == 5
		Spell magicSpell = source as spell
		MagicEffect[] magicEffects = magicSpell.GetMagicEffects()
		
		int idxx=0
		while idxx < magicEffects.length
			int castingType = magicEffects[idxx].GetCastingType()
			int deliveryType = magicEffects[idxx].GetDeliveryType()

			if magicEffects[idxx].HasKeyWordString("MagicVoiceChangeWeather")
				return 	
			elseif magicEffects[idxx].HasKeyWordString("MagicShout")
				return 			
			endif
			idxx += 1
		endwhile			
	elseif actionType == 5	; bow draw
		Sound.SetInstanceVolume(SayCombatBowDrawSound.Play(playerRef), 0.8)
	elseif actionType == 6	; bow release
		Sound.SetInstanceVolume(SayCombatBowReleaseSound.Play(playerRef), 0.8)
	elseif actionType == 8	; combat ready
		Sound.SetInstanceVolume(SayCombatStartSound.Play(playerRef), 0.8)
	elseif actionType == 10	; combat end
		Sound.SetInstanceVolume(SayCombatEndSound.Play(playerRef), 0.8)				
	endif 
EndEvent

Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	if akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreHealth"); restore health

	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreMagicka"); restore magicka

	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	&& akEffect.HasKeyWordString("MagicAlchRestoreStamina"); restore stamina	

	elseif akEffect.HasKeyWordString("MagicAlchBeneficial")	; cure poison
	
	elseif akEffect.HasKeyWordString("MagicAlchHarmful")	; alchol

	endif
EndEvent

Event OnBookRead(Book akBook)
	Sound.SetInstanceVolume(SayActionBookReadSound.Play(playerRef), 0.8)
	Log("OnBookRead")
EndEvent

Event OnDragonSoulGained(float afSouls)
	Sound.SetInstanceVolume(SayActionDragonSoulSound.Play(playerRef), 0.8)
	Log("OnDragonSoulGained")
EndEvent

Event OnItemHarvested(Form akProduce)
	Sound.SetInstanceVolume(SayActionHarvestedSound.Play(playerRef), 0.8)
	Log("OnItemHarvested")
EndEvent

Event OnLevelIncrease(int aiLevel)
	Sound.SetInstanceVolume(SayLevelUpSound.Play(playerRef), 0.8)
	Log("OnLevelIncrease")
EndEvent

Event OnLocationDiscovery(String asRegionName, String asWorldspaceName)
	Log("OnLocationDiscovery")
EndEvent

Event OnWeatherChange(Weather akOldWeather, Weather akNewWeather)
;  0 - Pleasant
;  1 - Cloudy
;  2 - Rainy
;  3 - Snow
	int weatherType = akNewWeather.GetClassification()
	if weatherType == 0
		Sound.SetInstanceVolume(SayWeatherClearSound.Play(playerRef), 0.8)
	elseif weatherType == 1
		Sound.SetInstanceVolume(SayWeatherCloudySound.Play(playerRef), 0.8)
	elseif weatherType == 2
		Sound.SetInstanceVolume(SayWeatherRainySound.Play(playerRef), 0.8)
	elseif weatherType == 3
		Sound.SetInstanceVolume(SayWeatherSnowSound.Play(playerRef), 0.8)
	endif 

	Log("OnWeatherChange " + weatherType)
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if abHitBlocked
		Sound.SetInstanceVolume(SayCombatBlockSound.Play(playerRef), 0.8)
	elseif abPowerAttack || abSneakAttack
		Sound.SetInstanceVolume(SayCombatCriticalHitSound.Play(playerRef), 0.8)
	else
		Sound.SetInstanceVolume(SayCombatNormalHitSound.Play(playerRef), 0.8)
	endif

	Log("OnHit")
EndEvent

; Event that is triggered when this actor sits in the furniture
Event OnSit(ObjectReference akFurniture)	
	Sound.SetInstanceVolume(SayActionSitSound.Play(playerRef), 0.8)
	Log("OnSit")
EndEvent
	
; Event that is triggered when this actor leaves the furniture
Event OnGetUp(ObjectReference akFurniture)
	Sound.SetInstanceVolume(SayActionGetUpSound.Play(playerRef), 0.8)
	Log("OnGetUp")
EndEvent

; Received when the player sleeps. Start and desired end time are in game time days (after registering)
Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	Sound.SetInstanceVolume(SayActionSleepBeginSound.Play(playerRef), 0.8)
	Log("OnSleepStart")
EndEvent
	
; Received when the player stops sleeping - whether naturally or interrupted (after registering)
Event OnSleepStop(bool abInterrupted)
	Sound.SetInstanceVolume(SayActionSleepEndSound.Play(playerRef), 0.8)
	Log("OnSleepStop")
EndEvent

; Event that is triggered when this actor finishes dying
Event OnDeath(Actor akKiller)
	Sound.SetInstanceVolume(SayCombatDeathEndSound.Play(playerRef), 0.8)
EndEvent
	
; Event that is triggered when this actor begins to die
; Event OnDying(Actor akKiller)
; 	Sound.SetInstanceVolume(SayCombatDyingSound.Play(playerRef), 0.8)
; EndEvent
	
	; Event received when an actor enters bleedout.
Event OnEnterBleedout()
	Sound.SetInstanceVolume(SayCombatBleedOutSound.Play(playerRef), 0.8)
	Log("OnEnterBleedout")
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)	
	Armor _armor = akBaseObject as armor
	if _armor.IsClothingBody()
		UnregisterForUpdate()
		RegisterForSingleUpdate(5.0) ; 5초 뒤
	endif
EndEvent

event OnUpdate()
	Armor _armor = playerRef.GetWornForm(0x00000004) as Armor 		

	if !_armor
		Sound.SetInstanceVolume(SayActionNakedSound.Play(playerRef), 0.8)
		Log("naked")
		;naked
	endif
endEvent

event OnUpdateGameTime()
	float Time = Utility.GetCurrentGameTime()
	Log("gameTiem " + time)
endEvent

function Log(string msg)
	MiscUtil.PrintConsole(msg)
endFunction

; intro
Sound property SayIntroSound Auto

; levelup
Sound property SayLevelUpSound Auto

; weather
Sound property SayWeatherCloudySound Auto
Sound property SayWeatherRainySound Auto
Sound property SayWeatherClearSound Auto
Sound property SayWeatherSnowSound Auto

; action
Sound property SayActionSitSound Auto
Sound property SayActionGetUpSound Auto
Sound property SayActionHarvestedSound Auto
Sound property SayActionBookReadSound Auto
Sound property SayActionDragonSoulSound Auto
Sound property SayActionSleepBeginSound Auto
Sound property SayActionSleepEndSound Auto
Sound property SayActionNakedSound Auto

; Combat
	; start/end
Sound property SayCombatStartSound Auto
Sound property SayCombatEndSound Auto

	; bow
Sound property SayCombatBowDrawSound Auto
Sound property SayCombatBowReleaseSound Auto

	; weapon | unarm
Sound property SayCombatNormalAttackSound Auto
Sound property SayCombatPowerAttackSound Auto

	; shield
Sound property SayCombatBlockSound Auto

	; under attack
Sound property SayCombatNormalHitSound Auto
Sound property SayCombatCriticalHitSound Auto

	; health
Sound property SayCombatDeathEndSound Auto
Sound property SayCombatBleedOutSound Auto

; Magic
	; fire
Sound property SayMagicFireCastSound Auto
Sound property SayMagicFireConcentrationSound Auto

	; ice
Sound property SayMagicIceCastSound Auto
Sound property SayMagicIceConcentrationSound Auto

	; light
Sound property SayMagicLightCastSound Auto
Sound property SayMagicLightConcentrationSound Auto

	; voice
Sound property SayMagicVoiceCastSound Auto
Sound property SayMagicVoiceConcentrationSound Auto

	; heal
Sound property SayMagicHealCastSound Auto
Sound property SayMagicHealConcentrationSound Auto

	; change sky
Sound property SayMagicClearSkySound Auto

	; candle light
Sound property SayMagicCandleLightSound Auto

	; summon
Sound property SayMagicSummonSound Auto

	; etc
Sound property SayMagicEtcSound Auto