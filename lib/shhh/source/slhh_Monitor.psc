Scriptname slhh_Monitor extends Quest  Conditional
{This script deals with paired animations}

Import Debug
Import Game

;\\\\\\\\\Property Zone\\\\\\\\\\
SLHH_Upkeep Property SLHHUpkeep Auto
ObjectReference Property SlHHMiscReferences Auto
ObjectReference Property SlHHPlayerNameRef Auto
ObjectReference Property SlHHPlayerNameNegoRef Auto
ObjectReference Property SlHHReturnPoint Auto
Actor Property PlayerRef Auto
Package Property DoNothing Auto

Int[] eqslot
Int Property NegotiationSuccessPossibility = 0 Auto Conditional
Bool Property PersuadeSuccess Auto Conditional
Bool Property BaboDialogueActive Auto

GlobalVariable Property SLHHSlotMask  Auto  
GlobalVariable Property SLHHSlotMaskB  Auto  
GlobalVariable Property SLHH_ScaleSetting Auto
Float property PreviousVictimScale auto
Float property PreviousAggressormScale auto
Float property VicActorScale auto
Float property AggActorScale auto
Float property VicAnimScale auto
Float property AggAnimScale auto
Actor targ
Armor CurrentPanty
Armor CurrentHead
Armor CurrentBody
Topic Property CombatTopicPanty  Auto
Topic Property CombatTopicBra  Auto
bool bPlayerOnly
Bool bIsOkToPlay
Bool Isplaying = false
Bool SetscaleTrigger = False


Keyword Property SLA_ArmorPretty Auto
Keyword Property SLA_ArmorSpendex Auto
Keyword Property EroticArmor Auto
Keyword Property SLA_ArmorHalfNakedBikini Auto
Keyword Property SLA_ArmorHalfNaked Auto
Keyword Property SLA_ArmorLewdLeotard auto
Keyword Property SLA_ArmorCurtain auto
Keyword Property SLA_ArmorTransparent auto

Keyword Property SLA_Brabikini Auto

Keyword Property SLA_PantyNormal Auto
Keyword Property SLA_ThongCString auto
Keyword Property SLA_ThongLowleg auto
Keyword Property SLA_ThongT auto
Keyword Property SLA_ThongGstring auto
Keyword Property SLA_MicroHotpants auto
Keyword Property SLA_PantsNormal auto

Keyword Property SLA_PastiesCrotch auto
Keyword Property SLA_PastiesNipple auto

Keyword Property SLA_PelvicCurtain auto
Keyword Property SLA_ShowgirlSkirt auto
Keyword Property SLA_FullSkirt auto
Keyword Property SLA_MiniSkirt auto
Keyword Property SLA_MicroSkirt auto

Keyword Property ArmorCuirass Auto
Keyword Property Clothingbody Auto

Keyword Property ArmorClothing Auto
Keyword Property ArmorHeavy Auto
Keyword Property ArmorLight Auto

Scene Property SLHHMonitorScriptNegotiating01 Auto
Scene Property SLHHMonitorScriptNegotiating02 Auto
Scene Property SLHHMonitorScriptNegotiating03 Auto
Scene Property SLHHMonitorScriptScene01 Auto

ReferenceAlias Property AggressorRef Auto

Faction Property SLHH_BaboDIaViceCaptainFaction Auto
Faction Property BaboViceGuardCaptainFaction Auto

;\\\\\\\\\Function Zone\\\\\\\\\\

Function XmarkerMove(Bool GoReturn)
if GoReturn
	SlHHPlayerNameRef.moveto(PlayerRef)
else
	SlHHPlayerNameRef.moveto(SlHHReturnPoint)
endif
EndFunction

Function XmarkerMoveNego(Bool GoReturn)
if GoReturn
	SlHHPlayerNameNegoRef.moveto(PlayerRef)
else
	SlHHPlayerNameNegoRef.moveto(SlHHReturnPoint)
endif
EndFunction

Function RegisterAlias(Actor Raper, Bool Start)
if Start
	AggressorRef.clear()
	AggressorRef.forcerefto(Raper)
else
	AggressorRef.clear()
endif
EndFunction




Function StruggleAnim(Actor Victim, Actor Aggressor, Bool Animate = True, Idle VictimAnim, Idle AggressorAnim, bool iscreature)
If Animate
	If (Aggressor != PlayerRef)
 		ActorUtil.AddPackageOverride(Aggressor, DoNothing, 100, 1)
		Aggressor.EvaluatePackage()
		Aggressor.SetRestrained()
		Aggressor.SetDontMove(True)
		;Victim.SetRestrained()
		;Victim.SetDontMove(True)
		
		Game.DisablePlayerControls( true, true, false, false, true, true, false, false )

		Game.SetPlayerAIDriven( true )
		if Game.GetCameraState() == 0
			Game.ForceThirdPerson()
		endIf
	Else
		SetPlayerAiDriven()
	Endif
		SlHHMiscReferences.MoveTo(Victim) ; PosRef
		Float AngleZ = Victim.GetAngleZ()
		Aggressor.MoveTo(Victim, 0.0 * Math.Sin(AngleZ), 0.0 * Math.Cos(AngleZ))
		Victim.SetVehicle(SlHHMiscReferences) ; PosRef
		Aggressor.SetVehicle(SlHHMiscReferences) ; PosRef
		If isplaying == false
			;if !iscreature
				SendAnimationEvent(Aggressor, "IdleForceDefaultState")
			;endif
			SendAnimationEvent(Victim, "IdleForceDefaultState")
		EndIf
		Utility.Wait(1.0)
		Aggressor.MoveTo(Victim, 0.0 * Math.Sin(AngleZ), 0.0 * Math.Cos(AngleZ))
		If (SLHH_ScaleSetting.getvalue() == 1) && (SetscaleTrigger == false)
			PreviousVictimScale = Victim.getscale()
			PreviousAggressormScale = Aggressor.getscale()
			VicActorScale = (1.0 / PreviousVictimScale)
			AggActorScale = (1.0 / PreviousAggressormScale)
			Victim.setscale(VicActorScale)
			Aggressor.setscale(AggActorScale)

			SetscaleTrigger = True
		EndIf
		Victim.Playidle(VictimAnim)
		Aggressor.Playidle(AggressorAnim)
		isplaying = True
		;Notification("Play" + AggressorAnim)
Else
		If SetscaleTrigger
			Victim.setscale(1.0)
			Aggressor.setscale(1.0)
			SetscaleTrigger = False
		Else
			;Nothing
		EndIf
		Victim.SetVehicle(None)
		Aggressor.SetVehicle(None)
		If (Aggressor != PlayerRef)
			Game.EnablePlayerControls()
			Game.SetPlayerAIDriven(false)
			Game.ForceThirdPerson()
			Victim.SetRestrained(False)
			Victim.SetDontMove(False)
			Aggressor.SetRestrained(False)
			Aggressor.SetDontMove(False)
			ActorUtil.RemovePackageOverride(Aggressor, DoNothing)
		Else
			SetPlayerAiDriven(False)
		Endif
	if iscreature
		SendAnimationEvent(Aggressor, "Reset")
		SendAnimationEvent(Aggressor, "ReturnToDefault")
		SendAnimationEvent(Aggressor, "FNISDefault")
		SendAnimationEvent(Aggressor, "IdleReturnToDefault")
		SendAnimationEvent(Aggressor, "ForceFurnExit")
	else
		SendAnimationEvent(Aggressor, "IdleForceDefaultState")
	endif
		SendAnimationEvent(Victim, "IdleForceDefaultState")
	isplaying = false
Endif
EndFunction

Bool Function FindKeywordArmor(Actor target, Bool IsCreature)
Armor thisArmor = target.GetWornForm(0x00000004) as Armor
int ri = Utility.randomint(1, 100)
	if thisArmor.HasKeyword(SLA_ArmorTransparent) || thisArmor.HasKeyword(SLA_ArmorCurtain) || thisArmor.HasKeyword(SLA_ArmorHalfNaked) || thisArmor.HasKeyword(SLA_ArmorHalfNakedBikini) ||  thisArmor.HasKeyword(SLA_PastiesNipple)
		Target.UnequipItem(thisArmor)
		debug.notification("Rapist: Too easy. You really thought this clothes could protect you, slut?")
		Return true
	elseif thisArmor.HasKeyword(EroticArmor)
		if ri < 90
			Target.UnequipItem(thisArmor)
			Return true
		else
			if !IsCreature
				debug.notification("Rapist: Fuck! My hands are slippery.")
			endif
			Return false
		endif
	elseif thisArmor.HasKeyword(SLA_ArmorLewdLeotard)
		if ri < 80
			Target.UnequipItem(thisArmor)
			Return true
		else
			if !IsCreature
				debug.notification("Rapist: Shit! I almost stripped you! Give up, bitch.")
			endif
			Return false
		endif
	elseif thisArmor.HasKeyword(SLA_ArmorSpendex)
		if ri < 70
			Target.UnequipItem(thisArmor)
			Return true
		else
			if !IsCreature
				debug.notification("Rapist: Why is it so tight and sticky! It's hard to tear it off!")
			endif
			Return false
		endif
	elseif thisArmor.HasKeyword(SLA_ArmorPretty)
		if ri < 65
			Target.UnequipItem(thisArmor)
			Return true
		else
			if !IsCreature
				debug.notification("Rapist: What kind of clothes is this?")
			endif
			Return false
		endif
	else
		if ri < 50
			Target.UnequipItem(thisArmor)
			Return true
		else
			if !IsCreature
				debug.notification("Rapist: Damn it! Take it off!")
			endif
			Return false
		endif
	EndIf

EndFunction

int Function RemoveLower(Actor target)
	Int CurrentArmorSlotsMaskB = Math.LeftShift(SLHHSlotMaskB.GetValue() As Int, 24)
	Int CurrentArmorSlotsMaskA = SLHHSlotMask.GetValue() As Int
	Int slotsChecked = Math.LogicalOr(CurrentArmorSlotsMaskA, CurrentArmorSlotsMaskB)
	Int idx = 0
	Int ct = 0
	Form[] EQArmor = new Form[30]
	Form[] retForm = new Form[30]
	eqslot = new Int[30]
	
	EQArmor = po3_sksefunctions.AddAllEquippedItemsToArray(target)
	Int EQcount = EQArmor.length
	if EQcount == 0
		return 0
	endIf
		while ct < EQcount
			armor thisArmor = EQArmor[ct] as armor
			if thisArmor as Bool
				if thisArmor.HasKeyWord(SLA_ThongCString) || thisArmor.HasKeyWord(SLA_ThongLowleg) || thisArmor.HasKeyWord(SLA_ThongT) || thisArmor.HasKeyWord(SLA_ThongGstring) || thisArmor.HasKeyWord(SLA_MicroHotpants) || thisArmor.HasKeyWord(SLA_PastiesNipple) || thisArmor.HasKeyWord(SLA_PastiesCrotch) || thisArmor.HasKeyWord(SLA_FullSkirt) || thisArmor.HasKeyWord(SLA_ShowgirlSkirt) || thisArmor.HasKeyWord(SLA_MicroSkirt) || thisArmor.HasKeyWord(SLA_MiniSkirt) || thisArmor.HasKeyWord(SLA_PelvicCurtain) 
					Target.UnequipItem(thisArmor)
					Int slotmask = thisArmor.GetSlotMask()
					Int slotmaskb = math.LogicalAnd(slotsChecked, slotmask)
					if slotmaskb != 0 && slotmask == slotmaskb
						retForm[idx] = thisArmor as Form
						eqslot[idx] = slotmask
						idx += 1
					endIf
				endif
			endIf
			ct += 1
		endWhile

	return idx
		
EndFunction


Armor Function FindArmor(Actor target, Actor Receiver, Bool Keywordswitch = False, Keyword TargetArmor)
Armor[] wornForms = new Armor[30]
int index
Bool StripSwitch
;slotsChecked += 0x00100000
;slotsChecked += 0x00200000;These slots need to be ignored on MCM
;slotsChecked += 0x00000004;Body

Int CurrentArmorSlotsMaskB = Math.LeftShift(SLHHSlotMaskB.GetValue() As Int, 24)
Int CurrentArmorSlotsMaskA = SLHHSlotMask.GetValue() As Int
Int slotsChecked = Math.LogicalOr(CurrentArmorSlotsMaskA, CurrentArmorSlotsMaskB)

int thisSlot = 0x01
	while (thisSlot < 0x80000000) && StripSwitch == False
	if (Math.LogicalAnd(slotsChecked, thisSlot) != thisSlot) ;only check slots we haven't found anything equipped on already
	Armor thisArmor = target.GetWornForm(thisSlot) as Armor
	StripSwitch = false
	If !Keywordswitch
		if (thisArmor.Haskeyword(ArmorClothing) || thisArmor.Haskeyword(ArmorLight) || thisArmor.Haskeyword(ArmorHeavy))
			;Target.UnequipItem(thisArmor)
			return thisarmor
			StripSwitch = True
		Else
			slotsChecked += thisSlot
		EndIf
	Else
		if (thisArmor.HasKeyword(TargetArmor))
			;Target.UnequipItem(thisArmor)
			return thisarmor
			StripSwitch = True
		Else
			slotsChecked += thisSlot
		EndIf
	endif
	endif
		thisSlot *= 2 ;double the number to move on to the next slot
	endWhile
	
EndFunction

Function ShuffleScenarioes(Bool Success, int Possibility, int ScenarioesInt)
;Debug.notification("ShuffleScenarioes" + ScenarioesInt + Success as int)
PersuadeSuccess = Success

if PersuadeSuccess
	NegotiationSuccessPossibility += Possibility
endif

SLHHMonitorScriptScene01.stop()
XmarkerMove(false)

Utility.wait(0.5)
XmarkerMoveNego(true)
if ScenarioesInt == 1
	;Debug.notification("SLHHMonitorScriptNegotiating01")
	SLHHMonitorScriptNegotiating01.forcestart()
elseif ScenarioesInt == 2;Creature
	;Debug.notification("SLHHMonitorScriptNegotiating02")
	SLHHMonitorScriptNegotiating02.forcestart()
elseif ScenarioesInt == 3
	SLHHMonitorScriptNegotiating03.forcestart()
else
; Skip
endif
EndFunction

Function ScenarioesEnded(Bool Success) ;NegotiationSuccessPossibility is over 100, true
	SLHHMonitorScriptNegotiating01.stop()
	SLHHMonitorScriptNegotiating02.stop()
;	SLHHMonitorScriptNegotiating03.stop()
	XmarkerMoveNego(false)
	Utility.wait(1.0)
	
if !Success
	XmarkerMove(true)
	Utility.wait(1.0)
	SLHHMonitorScriptScene01.start()
	Utility.wait(1.0)
	SLHHUpkeep.NegotiatingOver(PersuadeSuccess)
else
	SLHHUpkeep.EscapeSucess()
endif
EndFunction

Function GiveTempFaction(actor akactor, Bool Addfaction);it gives temporary faction to give more dialogue branches.

if BaboDialogueActive
if addfaction
	If (akactor.isinfaction(BaboViceGuardCaptainFaction)) && (!akactor.isinfaction(SLHH_BaboDIaViceCaptainFaction))
		akactor.addtofaction(SLHH_BaboDIaViceCaptainFaction)
	endif
else
	akactor.removefromfaction(SLHH_BaboDIaViceCaptainFaction)
endif
endif

EndFunction