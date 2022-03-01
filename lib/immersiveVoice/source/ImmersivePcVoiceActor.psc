Scriptname ImmersivePcVoiceActor extends Actor Hidden

bool hasHeavyArmor
bool isNaked

Event OnLoad()

	if  self.HasKeyWordString("ActorTypeCreature") || self.HasKeyWordString("ActorTypeAnimal")
		gotoState("creatureRole")
	else 
		Armor _wornArmor = self.GetWornForm(0x00000004) as Armor		; armor	

		hasHeavyArmor = false
		if _wornArmor
			if _wornArmor.IsHeavyArmor()
				hasHeavyArmor = true
			endif
		else
			isNaked = true
		endif	
		RegisterForSleep()		
		gotoState("npcRole")
	endif
EndEvent

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
    if isNaked
        self.additem(CommonCloth, 1)
        self.EquipItem(CommonCloth)
    endif
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
    checkHeavyArmor(akBaseObject as armor)
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    checkHeavyArmor(akBaseObject as armor)
EndEvent

state npcRole
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)	
		if abHitBlocked
		else
			weapon _weapon = akSource as weapon         
			bool isStrong = pcVoiceMCM.isStrongWeapon(_weapon)
			bool isBow = pcVoiceMCM.isBowWeapon(_weapon)
			bool isUnarm = pcVoiceMCM.isUnarmWeapon(_weapon)
			float healthValue = self.GetActorValuePercentage("Health")

			if hasHeavyArmor
				if isStrong || isBow
					SoundPlay(SoundEffectHitSteelArmor, 0.4)
				endif
			endif
			
			if abPowerAttack
				float staminaValue = self.GetActorValuePercentage("Stamina")
				Actor aggressor = akAggressor as Actor

				; 무기에 의한 강력한 공격으로 중갑옷이 벗겨질수 있음
				if isStrong
					if staminaValue <= 0.10 || self.IsBleedingOut()
						Armor[] actorArmorList = new Armor[4]
						actorArmorList[0]	= self.GetWornForm(0x00000001) As Armor	; actorHead
						actorArmorList[1] 	= self.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
						actorArmorList[2]	= self.GetWornForm(0x00000004) as Armor	; actorArmor
						actorArmorList[3] 	= self.GetWornForm(0x00400000) as Armor	; actorPanty

						int idx = 0
						while idx < actorArmorList.length 													
							if actorArmorList[idx] && pcVoiceMCM.isStrongArmor(actorArmorList[idx])
								self.DropObject(actorArmorList[idx])
								idx = actorArmorList.length 
							elseif actorArmorList[idx]
								self.RemoveItem(actorArmorList[idx])
								idx = actorArmorList.length
							endif
							idx += 1
						endwhile
					endif
				; 동물들 공격에 의해 옷이 벗겨질 수 있음
				elseif isUnarm
					if aggressor.HasKeyWordString("ActorTypeAnimal")	; unarm
						if staminaValue <= 0.20 || self.IsBleedingOut()
							Armor[] actorArmorList = new Armor[4]
							actorArmorList[0] 	= self.GetWornForm(0x00008000) as Armor	; actorSkirts
							actorArmorList[1] 	= self.GetWornForm(0x00800000) as Armor	; actorThigh				
							actorArmorList[2]	= self.GetWornForm(0x00000004) as Armor	; actorArmor		
							actorArmorList[3] 	= self.GetWornForm(0x00400000) as Armor	; actorPanty
						
							int idx = 0
							while idx < actorArmorList.length 													
								if actorArmorList[idx] && pcVoiceMCM.isWeakArmor(actorArmorList[idx])
									self.DropObject(actorArmorList[idx])
									idx = actorArmorList.length 
								endif
								idx += 1
							endwhile
						endif
					endif
				elseif pcVoiceMCM.checkFireSpell(akSource)
					bool _doStrip = false
					if  aggressor.HasKeyWordString("ActorTypeDragon")
						if healthValue < 0.25
							_doStrip = true
						endif
					else 
						if healthValue < 0.15
							_doStrip = true
						endif
					endif

					if _doStrip
						Armor[] actorArmorList = new Armor[3]
						actorArmorList[0] 	= self.GetWornForm(0x00010000) as Armor	; actorChest/Cloak
						actorArmorList[1]	= self.GetWornForm(0x00000004) as Armor	; actorArmor
						actorArmorList[2] 	= self.GetWornForm(0x00400000) as Armor	; actorPanty

						int idx = 0
						while idx < actorArmorList.length 													
							if actorArmorList[idx] && pcVoiceMCM.isBurnArmor(actorArmorList[idx])
								self.RemoveItem(actorArmorList[idx])
								idx += 3
							endif 							
							idx += 1
						endwhile
					endif
				endif
			endif
						
			if isNaked
				healthValue = (healthValue * 100) / 25.0				
				self.DamageActorValue("Health", healthValue)
			endif
		endif
	EndEvent
endState

state creatureRole
	; Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)	
	; 	if abHitBlocked
	; 	else
	; 		weapon _weapon = akSource as weapon
	; 		if checkFireSpell(akSource)
	; 		endif
	; 	endif
	; EndEvent
endState

function SoundPlay(Sound _sound, float _volume = 0.8)
	if self.IsSwimming()
		return
	endif

	Sound.SetInstanceVolume(_sound.Play(self), _volume)	
endFunction

function checkHeavyArmor(Armor _armor)
	Armor _wornArmor = self.GetWornForm(0x00000004) as Armor		; armor	
    hasHeavyArmor = false
    if _wornArmor
        if _wornArmor.IsHeavyArmor()
            hasHeavyArmor = true
        endif
    else 
        isNaked = true
    endif 
endFunction


Sound property SoundEffectHitSteelArmor Auto
Armor property CommonCloth Auto
ImmersivePcVoiceMCM property pcVoiceMCM Auto