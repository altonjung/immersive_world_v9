Scriptname AR_Ref_AliasScript extends ReferenceAlias  

AR_QuestScript Property AR_Quest Auto
Actor Property PlayerRef Auto
Idle Property IdleStop_Loose Auto
Idle Property idlebook_reading Auto
Idle Property IdleBookSitting_Reading Auto
Idle Property idlenoteread Auto
Idle Property CombatIdleStretching Auto
Idle Property idlelaydownexit Auto
Idle Property coughing Auto
Sound property AR_CoughSoundMarker Auto
keyword property vendoritemingredient auto
FormList Property AR_ElderScrolls Auto
Keyword Property VendorItemSpellTome Auto
GlobalVariable Property AR_Books Auto
GlobalVariable Property AR_SkyrimSouls Auto
int previousStat 
float currenttimescale
keyword property vendoritempoison auto
GlobalVariable Property AR_DogUp Auto
GlobalVariable Property AR_Poison Auto
GlobalVariable Property AR_Wait Auto
GlobalVariable Property AR_Timescale Auto
GlobalVariable Property Timescale Auto
GlobalVariable Property AR_Coughing Auto
GlobalVariable Property AR_StandUpKey Auto
GlobalVariable Property AR_SavedSitting Auto
bool Ground 
Bool Random 

Event OnPlayerLoadGame()
	AR_Quest.LootingMaint()
	previousStat = Game.QueryStat("Poisons Used")
	
	If AR_Wait.GetValue() == 0
	;nothing

	else
RegisterForControl("Wait")
	If AR_SavedSitting.GetValue() == 1
		Debug.SendanimationEvent(PlayerRef, "IdleForceDefaultState")	
	endif

	If AR_Timescale.GetValue() == 1 && TimeScale.GetValue() == 2000
	Timescale.SetValue(CurrentTimescale)
	endif
endif
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)

If akBaseObject.HasKeyword(VendorItemIngredient) && PlayerRef.GetSitState() == 0 && AR_Coughing.GetValue() == 1
Int chance = utility.RandomInt(1,3)
If chance == 3
PlayerRef.PlayIdle(Coughing)
int instanceID = AR_CoughSoundMarker.play(PlayerRef)     
Sound.SetInstanceVolume(instanceID, 0.8)
endif

elseif akBaseObject as Book && AR_Books.GetValue() == 1 && AR_SkyrimSouls.GetValue() == 1

If !akBaseObject.HasKeyword(VendorItemSpellTome) && PlayerRef.GetSitState() == 0 && akBaseObject.GetGoldValue() == 0 && !AR_ElderScrolls.HasForm(akBaseObject)
Utility.Wait(0.2)
Game.ForceThirdPerson()
PlayerRef.PlayIdle(idlenoteread)
utility.wait(0.2)
While Utility.IsInMenuMode() == True
utility.WaitMenuMode(0.5)
endwhile
PlayerRef.PlayIdle(IdleStop_Loose)

elseif !akBaseObject.HasKeyword(VendorItemSpellTome) && PlayerRef.GetSitState() == 0  && !AR_ElderScrolls.HasForm(akBaseObject)
Utility.Wait(0.2)
Game.ForceThirdPerson()
PlayerRef.PlayIdle(idlebook_reading)
utility.wait(0.2)
While Utility.IsInMenuMode() == True
utility.WaitMenuMode(0.5)
endwhile
PlayerRef.PlayIdle(IdleStop_Loose)

elseif !akBaseObject.HasKeyword(VendorItemSpellTome) && PlayerRef.GetSitState() == 3  && !AR_ElderScrolls.HasForm(akBaseObject)
Utility.Wait(0.2)
Game.ForceThirdPerson()
PlayerRef.PlayIdle(IdleBookSitting_Reading)
utility.wait(0.2)
While Utility.IsInMenuMode() == True
utility.WaitMenuMode(0.5)
endwhile
PlayerRef.PlayIdle(IdleStop_Loose)

endif
endif
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer) 
if akBaseItem.HasKeyword(VendorItemPoison) && AR_Poison.GetValue() == 1
AR_DogUp.SetValue(6)
int stat = Game.QueryStat("Poisons Used") 
if (stat > previousStat) ; the poison was actually used

previousStat = stat
if PlayerRef.IsWeaponDrawn()
Utility.Wait(0.2)
Playerref.PlayIdle(CombatIdleStretching)
endif
endif
Utility.Wait(0.8)
AR_DogUp.SetValue(0)
endif
EndEvent


Event OnControlDown(string control)

If control == "Wait" && UI.IsMenuOpen("Sleep/Wait Menu") && !PlayerRef.IsWeaponDrawn() && PlayerRef.GetSitState() == 0

AR_SavedSitting.SetValue(1) 

	If AR_Wait.GetValue() == 4
	AR_Wait.SetValue(Utility.RandomInt(1,3))
	Random = True
	Endif

	If AR_Wait.GetValue() == 1
	Debug.sendAnimationEvent(PlayerRef, "IdleSitCrossLeggedEnter")
		
	elseif AR_Wait.GetValue() == 2
	Debug.sendAnimationEvent(PlayerRef, "IdleGreybeardMeditateEnter")
		
	elseif AR_Wait.GetValue() == 3
	Debug.sendAnimationEvent(PlayerRef, "idlelaydownenter")
	Ground = True
	endif

	If AR_Wait.GetValue() == 0
	;nothing
	elseif AR_StandUpKey.GetValue() == 0
	RegisterForControl("Forward")
	else
	RegisterForControl("Sneak")
	endif

	If Random == True
	AR_Wait.SetValue(4)
	Random = False
	endif

	If AR_Timescale.GetValue() == 1
	Utility.Wait(2.5)
	CurrentTimeScale = Timescale.GetValue()
	Timescale.SetValue(2000.0)
	endif

elseif control == "Forward" && PlayerRef.GetSitState() == 3 && AR_StandUpKey.GetValue() == 0
StandUp()
UnregisterForControl("Forward")

elseif control == "Sneak" && PlayerRef.GetSitState() == 3 && AR_StandUpKey.GetValue() == 1
PlayerRef.StartSneaking()
StandUp()
UnregisterForControl("Sneak")
endif
endevent

Function StandUp() 
If AR_Timescale.GetValue() == 1
Timescale.SetValue(CurrentTimeScale)
endif

AR_SavedSitting.SetValue(0) 

If Ground == True
		PlayerRef.PlayIdle(idlelaydownexit)
else
		Debug.sendAnimationEvent(PlayerRef, "IdleChairExitStart")
endif
endfunction