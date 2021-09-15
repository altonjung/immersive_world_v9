Scriptname SLHH_Upkeep extends Quest Conditional

Import debug

Int StripCount = 0 Conditional
Int StripSuccessCount = 0 Conditional
int Property SLHHStripPossibility = 80 Auto;This is default value
slhh_Monitor Property SLHHMonitor  Auto
SLAppPCSexQuestScript Property SLAPPPCQuest Auto
Quest Property SLHHMonitorScript Auto

Idle Property BaboBackHuginitGfortroll Auto
Idle Property BaboBackHuginitMfortroll Auto
Idle Property BaboBackHugClimaxGfortroll Auto
Idle Property BaboBackHugClimaxMfortroll Auto
Idle Property BaboBackhugStruggling01Gfortroll Auto
Idle Property BaboBackhugStruggling02Gfortroll Auto
Idle Property BaboBackhugStruggling01Mfortroll Auto
Idle Property BaboBackhugStruggling02Mfortroll Auto
Idle Property BaboBackhugStruggling01PGfortroll Auto
Idle Property BaboBackhugStruggling01PMfortroll Auto

Idle Property BaboBackHuginitG Auto
Idle Property BaboBackHuginitM Auto
Idle Property BaboBackHugClimaxG Auto
Idle Property BaboBackHugClimaxM Auto
Idle Property BaboBackhugStruggling01G Auto
Idle Property BaboBackhugStruggling02G Auto
Idle Property BaboBackhugStruggling01M Auto
Idle Property BaboBackhugStruggling02M Auto
Idle Property BaboBackhugStruggling01PG Auto
Idle Property BaboBackhugStruggling01PM Auto

Idle Property SLHH_ChokeHug_S01_A01 Auto
Idle Property SLHH_ChokeHug_S02_A01 Auto
Idle Property SLHH_ChokeHug_S03_A01 Auto
Idle Property SLHH_ChokeHug_S04_A01 Auto
Idle Property SLHH_ChokeHug_S05_A01 Auto
Idle Property SLHH_ChokeHug_S01_A02 Auto
Idle Property SLHH_ChokeHug_S02_A02 Auto
Idle Property SLHH_ChokeHug_S03_A02 Auto
Idle Property SLHH_ChokeHug_S04_A02 Auto
Idle Property SLHH_ChokeHug_S05_A02 Auto

Idle Property SLHH_Drunk_S01_A01 Auto
Idle Property SLHH_Drunk_S02_A01 Auto
Idle Property SLHH_Drunk_S03_A01 Auto
Idle Property SLHH_Drunk_S04_A01 Auto
Idle Property SLHH_Drunk_S05_A01 Auto
Idle Property SLHH_Drunk_S01_A02 Auto
Idle Property SLHH_Drunk_S02_A02 Auto
Idle Property SLHH_Drunk_S03_A02 Auto
Idle Property SLHH_Drunk_S04_A02 Auto
Idle Property SLHH_Drunk_S05_A02 Auto

Idle Property SLHH_Drunk_SBD_A01Start Auto
Idle Property SLHH_Drunk_SBD_A02Start Auto
Idle Property SLHH_DeathStart Auto
Idle Property SLHH_DeathLoop Auto


Bool BackHugStage01
Bool BackHugStage02
Bool BackHugStage03
Bool BackHugStage04

Bool IsCreature
int ViableRace
int BackAttack
;0: NPC human
;1: Troll

Bool Property NegotiatingSuccess Auto conditional

SLHH_MCM Property MCM auto
SexLabFramework Property SexLab Auto
ReferenceAlias Property Player auto
ReferenceAlias Property Aggressor auto
ReferenceAlias Property ThirdOne auto
ReferenceAlias Property companion auto
Quest Property SLHH_companion auto
int property iCuirassCount auto
int property iCount auto hidden
int property EscapeCountCriterion = 12 auto conditional
int property AVdivision = 20 auto
int property NegoArmorStripint = 2 auto conditional

Message Property SLHHResistMessagebox auto
Message Property SLHHResistCreatureMessagebox auto
Message Property SLHHFailedMessagebox auto
Message Property SLHHChokeFailedMessagebox  auto
Message Property SLHHDrunkFailedMessagebox  auto
Message Property SLHHFailedCreatureMessagebox auto
GlobalVariable Property SLHH_EscapeChance Auto
GlobalVariable Property SLHH_ResistMethodGlobal Auto

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

Scene Property SLHHSceneRunningaway Auto

String Property GAVCustom Auto;It could be stamina or magicka. But base will be stamina
String Property GAVCustom2 Auto;It could be stamina or magicka. But base will be none
ActorBase BaboWhiterunViceCaptainImperial
ActorBase BaboWhiterunViceCaptainStormcloack
Faction BaboChangeLocationEvent06Faction
Faction BaboCurrentHireling
Faction BaboWasHireling
Quest BaboChangeLocationEvent05
Quest BaboDialogueWhiterun

Race Property TrollRace Auto
Race Property TrollFrostRace Auto
Keyword Property ActorTypeNPC Auto
Keyword Property ActorTypeCreature Auto

GlobalVariable Property SLHH_DamageActorValueGlobal Auto

GlobalVariable Property SLHH_ScriptEventBC Auto
GlobalVariable Property SLHH_ScriptEventDrunk Auto
GlobalVariable Property SLHH_AssualtType Auto

Event OnInit()
	SLHHRegisterAnimationEvent()
	SLHHRegisterForModEvent()
	;SLHHActorRegisterForexternalmods()
EndEvent

Function SLHHRegisterForModEvent()
	RegisterForModEvent("StageStart_More", "HeWantsMore")
	RegisterForModEvent("AnimationEnd_More", "Finished")
EndFunction

Function SLHHActorRegisterForexternalmods()
	BaboWhiterunViceCaptainImperial = Game.GetFormFromFile(0xB67C33, "BaboInteractiveDia.esp") as ActorBase
	BaboWhiterunViceCaptainStormcloack = Game.GetFormFromFile(0xB71E3D, "BaboInteractiveDia.esp") as ActorBase
	BaboChangeLocationEvent06Faction = Game.GetFormFromFile(0x1066E3, "BaboInteractiveDia.esp") as Faction
	BaboCurrentHireling = Game.GetFormFromFile(0xC92D9D, "BaboInteractiveDia.esp") as Faction
	BaboWasHireling = Game.GetFormFromFile(0xD6272A, "BaboInteractiveDia.esp") as Faction
	BaboChangeLocationEvent05 = Game.GetFormFromFile(0xC287AB, "BaboInteractiveDia.esp") as Quest
	BaboDialogueWhiterun = Game.GetFormFromFile(0xB67C31, "BaboInteractiveDia.esp") as Quest
EndFunction

Function SLHHRegisterAnimationEvent()
	RegisterForAnimationEvent(Game.getplayer(), "BaboBackhugStruggling01G")
	RegisterForAnimationEvent(Game.getplayer(), "BaboBackhugStruggling02G")
	RegisterForAnimationEvent(Game.getplayer(), "BaboBackhugStruggling01PG")
	RegisterForAnimationEvent(Game.getplayer(), "SLHH_DeathStart")
	;Debug.notification("Registering SLHH Animation Events...")
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if (akSource == game.getplayer()) && (asEventName == "SLHH_DeathStart")
		Debug.Trace("SLHH_DeathStart Played")
	endIf
endEvent

Function Action()
iCount = 0
sslBaseAnimation[] anims
sslBaseAnimation[] animsCompanion
actor[] sexActorsCompanion
actor[] sexActors
actor NPC
int random = Utility.RandomInt(0, 100)

if MCM.Companion == true
	SLHH_Companion.Start()
endif
if random <= mcm.threesome
	NPC = SexLab.FindAvailableActor(CenterRef = Game.GetPlayer(), Radius = 2048.0, FindGender = 0, IgnoreRef1 = Game.GetPlayer(), IgnoreRef2 = Aggressor.GetActorRef(), IgnoreRef3 = Companion.GetActorRef(), IgnoreRef4 = none)
	ThirdOne.ForceRefTo(NPC)
	If NPC != none
		sexActors = new actor[3]
		sexActors[0] = Game.GetPlayer()
		sexActors[1] = Aggressor.GetRef() as Actor
		sexActors[2] = NPC
		
		If MCM.anim == "Bound/Forced"
			;debug.messagebox ("1")
			anims = SexLab.GetAnimationsByTags(3, "Forced", "Binding", "Bound")
		else
			;debug.messagebox ("2")
			anims = SexLab.GetAnimationsByTags(3, "Aggressive", TagSuppress = "MFF")
		endif	
			
	else
		sexActors = new actor[2]
		sexActors[0] = Game.GetPlayer()
		sexActors[1] = Aggressor.GetRef() as Actor
		
		If MCM.anim == "Sleeping/Faint"
			;debug.messagebox ("3")
			anims = SexLab.GetAnimationsByTags(2, "Necro", "Sleeping", "Faint")
		elseIf MCM.anim == "Bound/Forced"
			;debug.messagebox ("4")
			anims = SexLab.GetAnimationsByTags(2, "Forced", "Bound", "Binding")
		else
			;debug.messagebox ("5")
			anims = SexLab.GetAnimationsByTags(2, "Aggressive")
		endif	
	endif
else
		sexActors = new actor[2]
		sexActors[0] = Game.GetPlayer()
		sexActors[1] = Aggressor.GetRef() as Actor

		If MCM.anim == "Sleeping/Faint"
			;debug.messagebox ("6")
			anims = SexLab.GetAnimationsByTags(2, "Necro", "Sleeping", "Faint")
		elseIf MCM.anim == "Bound/Forced"
			;debug.messagebox ("7")
			anims = SexLab.GetAnimationsByTags(2, "Forced", "Bound", "Binding")
		else
			;debug.messagebox ("8")
			anims = SexLab.GetAnimationsByTags(2, "Aggressive")
		endif
endif

SexLab.StartSex(sexActors, anims, victim=Game.GetPlayer(), allowBed=false, hook="More")
Utility.wait(10.0)
AnimationStart(60)
return
endFunction

Event HeWantsMore(string eventName, string argString, float argNum, form sender)
sslThreadController thread = SexLab.HookController("HeWantsMore")
If iCount > 0 && iCount < 4
	If (iCount == 1 && Utility.RandomInt(0, 100) <= MCM.StageChance) || (iCount == 2 && Utility.RandomInt(0, 100) <= (MCM.StageChance * 0.67)) || (iCount == 3 && Utility.RandomInt(0, 100) <= (MCM.StageChance * 0.34))
		thread.AdvanceStage(true)
		;Debug.Notification("9")
		iCount += 1
	endif
else
	iCount += 1
endif
endEvent

Event Finished(string eventName, string argString, float argNum, form sender)
Actor Victim = SexLab.HookActors(argString)[0]
Actor Raper = SexLab.HookActors(argString)[1]
If SLHH_Companion.isRunning() == true
	SLHH_Companion.Stop()
endif
If BaboDialogueVerification(Raper) == true
	BaboDialogueTrigger(Raper, True)
endif
SetStage(150)
endEvent

Function FinishedBackAttack(Actor Rapist)
If SLHH_Companion.isRunning() == true
	SLHH_Companion.Stop()
endif
If BaboDialogueVerification(Rapist) == true
	BaboDialogueTrigger(Rapist, True)
endif
SetStage(150)
EndFunction

Bool Function BaboDialogueVerification(Actor akactor)
if (akactor.getactorbase() == BaboWhiterunViceCaptainImperial) || (akactor.getactorbase() == BaboWhiterunViceCaptainStormcloack)
	Return True
elseif akactor.isinfaction(BaboCurrentHireling)
	Return True
elseif akactor.isinfaction(BaboChangeLocationEvent06Faction)
	Return True
else
	Return False
endif
EndFunction

Event OnUpdateGameTime()
;Debug.notification("SLHH_Upkeep Updatetime...")
Utility.Wait(0.1)
;If GetStage() == 130 || GetStage() == 131 || GetStage() == 132
;	ResistSelection((Player.getRef() as Actor), (Aggressor.getRef() as Actor))
If GetStage() == 150 || 136
	If SLHHMonitorScript.getstage() >= 10 && SLHHMonitorScript.getstage() < 100
		AnimationStart(100, true)
	EndIf
	SLHHSceneRunningaway.stop()
	StripCount = 0
	StripSuccessCount = 0
	SetStage(160)
endif
EndEvent

Function AnimationStart(int nextstage, bool settodefault = false)
	SLHHMonitorScript.setstage(nextstage)
	if settodefault
	BackHugStage01 = True
	BackHugStage02 = True
	BackHugStage03 = True
	BackHugStage04 = True
	endif
EndFunction

Function SLHHAnimStart(Actor Victim, Actor rapist, int AttackType);needs to add creature

race rr = rapist.getrace()

if (rr.HasKeyword(ActorTypeNPC)) && !(rr.HasKeyword(ActorTypeCreature))
	iscreature = false
	ViableRace = 0
elseif rr.HasKeyword(ActorTypeCreature)
iscreature = true
	if rapist.getactorbase().getrace() == TrollRace || rapist.getactorbase().getrace() == TrollFrostRace; if getactorbase doesn't work, getleveledactorbase should do the job.
		ViableRace = 1
	else
		Debug.trace("No Creature Race")
	endif
endif

BackAttack = AttackType
SLHH_AssualtType.setvalue(AttackType)

	;Debug.notification("SLHH Race number " + ViableRace + "Creature " + iscreature)
	StruggleAnimCheckRace(Victim, rapist, 1)
	AnimationStart(10, true)
	SLHHMonitor.RegisterAlias(rapist, true)
EndFunction




Function ResistSelection(Actor Victim, Actor Raper)
	String RaperName = Raper.getbaseobject().getname()
	Armor BodyPart = Game.getplayer().GetWornForm(0x00000004) as armor
	int BaseEscapeChance = SLHH_EscapeChance.getvalue() as int
	float fVictimValue = Victim.getactorvalue(GAVCustom)
	float fVictimValue2 = Victim.getactorvalue(GAVCustom2)
	float fraperValue = Raper.getactorvalue(GAVCustom)
	float fraperValue2 = Raper.getactorvalue(GAVCustom2)
	int iVictimLevel = Victim.getlevel()
	int iRaperLevel = Raper.getlevel()
	int choice
	
	
	if BackAttack == 2
		fraperValue += fraperValue*0.4
		iRaperLevel += iRaperLevel*0.4 as int
	elseif	BackAttack == 3
		fraperValue += fraperValue*0.7
		iRaperLevel += iRaperLevel*0.7 as int		
	endif
	
	if iscreature
		fraperValue += fraperValue*0.6
		iRaperLevel += iRaperLevel*0.6 as int
	endif
	
	;notification("Escape Chance Calculation")
	int EscapeChance = EscapeChanceCalculation(BaseEscapeChance, iVictimLevel, iRaperLevel, fVictimValue, fraperValue)
	
	int random = Utility.RandomInt(1, 100)
	int randomstripchance = Utility.RandomInt(1, 100)
	Armor TargPart = SLHHMonitor.FindArmor(Victim, Raper, False, None)
	
	if iscreature
		choice = SLHHResistCreatureMessagebox.Show()
	else
		choice = SLHHResistMessagebox.Show()
	endif
	
	if (choice == 0);Struggling
	
		If random <= EscapeChance
			Escapesucess()
		Elseif random > EscapeChance
		ValueDiminish(Victim, Raper, AVdivision)
			If (StripCount < EscapeCountCriterion) && BodyPart
				If TargPart
					If randomstripchance <= SLHHStripPossibility
						Victim.UnequipItem(TargPart)
						Utility.wait(2.0)
						if iscreature
							notification(RaperName + " is so persistent!")
						else
							notification("I failed to escape! " + RaperName + " took away my armor part!")
						endif
						StripSuccessCount = StripSuccessCount + 1
					Else
						if iscreature
							notification("I can't be a creature's plaything!")
						else
							if BackAttack == 1
								notification("You really thought you could get me?")
							elseif BackAttack == 2
								notification("Let go of me! Let.. Go!")
							elseif BackAttack == 3
								notification("Um.. I feel nauseous. I am going home...")
							endif
						endif
					EndIf
					StripCount = StripCount + 1
					self.AnimationCheck(victim, raper)
				Else
					If randomstripchance <= SLHHStripPossibility
						StripSuccessCount = StripSuccessCount + 1
						;Victim.UnequipItem(BodyPart)
						if SLHHMonitor.FindKeywordArmor(Victim, iscreature)
							if iscreature
								notification("This thing stripped me! Don't!")
							else
								if BackAttack == 1 || BackAttack == 2
									notification("No!! Give me back!! You son of a bitch!")
								elseif BackAttack == 3
									notification("Eh..? My clothes...?")
								endif
							endif
							
							Utility.wait(2.0)
							If BackHugStage04
								StruggleAnimCheckRace(Victim, Raper, 4)
								AnimationStart(25)
								BackHugStage02 = false
								BackHugStage03 = false
								BackHugStage04 = false
							EndIf
						else
							if iscreature
								notification("Phew, it almost got me. I thought I'd be naked.")
							else
								if BackAttack == 1 || BackAttack == 2
									notification("He almost removed my clothes. I don't know how much longer I can hold him off.")
								elseif BackAttack == 3
									notification("Don't... You are annoying... Go away. So dizzy.")
								endif
							endif
						endif

					else
						if iscreature
							notification("With a creature? Get out of here!")
						else
							if BackAttack == 1 || BackAttack == 2
								notification("You won't have me! I am not your fuck toy!")
							elseif BackAttack == 3
								notification("Go away.. Stop bothering me.. I hate you...")
							endif
						endif
					EndIf
					StripCount = StripCount + 1
					self.AnimationCheck(victim, raper)
				EndIf
			ElseIf (StripCount < EscapeCountCriterion) && BodyPart == False
				Utility.wait(2.0)
				If TargPart
					If randomstripchance <= SLHHStripPossibility
						StripSuccessCount = StripSuccessCount + 1
						Victim.UnequipItem(TargPart)
						self.AnimationCheck(victim, raper)
						if iscreature
							notification("I can do this... No way I bear its seeds inside me!")
						else
							if BackAttack == 1
								notification("No.. don't.. stop harrassing me!")
							elseif BackAttack == 2
								notification("No.. don't.. My consciousness is fading.. away..")
							elseif BackAttack == 3
								notification("It's hot.. Um.. Someone is helping me take off my clothes.. Hehe...")
							endif
						endif
					else
						if iscreature
							notification("You creature can't mess with me! Let go!")
						else
							if BackAttack == 1
								notification("I.. can do it.. I won't let you.. rape me!")
							elseif BackAttack == 2
								notification("Please... No.. Don't...")
							elseif BackAttack == 2
								notification("Heek..! It's tickling!")
							endif
						endif
					endif
				else
					If randomstripchance <= SLHHStripPossibility
						EscapeFail()
					else
					if iscreature
						notification("No..! Please don't! This creature is really trying to mate with me!")
					else
						if BackAttack == 1
							notification("Stop groping over my body! Disgusting!!")
						elseif BackAttack == 2
							notification("I can't breathe... I can't...")
						elseif BackAttack == 3
							notification("Feels good. More... Urgh.. A molester..? Ung..")
						endif
					endif
					endif
				EndIf
				StripCount = StripCount + 1
				self.AnimationCheck(victim, raper)
			ElseIf (StripCount >= EscapeCountCriterion)
				EscapeSucess()
			Else
				StripCount = StripCount + 1
			EndIf
		EndIf
		Utility.wait(10.0)
		StrugglingAgain()
	Elseif (choice == 1);Donothing
		If BodyPart
			If TargPart
				Victim.UnequipItem(TargPart)
				Utility.wait(2.0)
				if iscreature
					notification("I shuddered at the thought of getting raped... It stripped me with ease...")
				else
					if BackAttack == 1 || BackAttack == 2
						notification("I shuddered at the thought of getting raped... " + RaperName + " stripped me without difficulty...")
					elseif BackAttack == 3
						notification(RaperName + " stripped me without difficulty as I am soaked out...")
					endif
				endif
			Else
				;Victim.UnequipItem(BodyPart)
				if SLHHMonitor.FindKeywordArmor(Victim, iscreature)
					Utility.wait(2.0)
					If BackHugStage04
						StruggleAnimCheckRace(Victim, Raper, 4)
						AnimationStart(25)
						BackHugStage02 = false
						BackHugStage03 = false
						BackHugStage04 = false
						notification("What..just happened? Where is my clothes? I am.. naked?")
					Else
						if BackAttack == 1
							notification("Somebody please! Help me!")
						elseif BackAttack == 2
							notification("I.. can't breathe.. Please, somebody..")
						elseif BackAttack == 3
							notification("Um... Ummm....")
						endif
					EndIf
				else
					if iscreature
						notification("It seems like it doesn't know how to take off my clothes.")
					else
						notification("It seems like he fails to figure out how to unequip my clothes.")
					endif
				endif
			EndIf
			StripCount = StripCount + 1
			StripSuccessCount = StripSuccessCount + 1
			self.AnimationCheck(victim, raper)
		ElseIf BodyPart == False
			Utility.wait(2.0)
			If TargPart
				Victim.UnequipItem(TargPart)
				if iscreature
					notification("I can't bear creature's offspring! This is madness!")
				else
					if BackAttack == 1
						notification("I don't want to have your baby!! I don't want to get impregnanted by you!")
					elseif BackAttack == 2
						notification("Argh..! No..! No...")
					elseif BackAttack == 3
						notification("Um... Um.... Why am I.. What's going on..?")
					endif
				endif
			Else
				Utility.wait(2.0)
				EscapeFail()
			EndIf
			StripCount = StripCount + 1
			StripSuccessCount = StripSuccessCount + 1
			self.AnimationCheck(victim, raper)
		Else
			StripCount = StripCount + 1
			StripSuccessCount = StripSuccessCount + 1
			self.AnimationCheck(victim, raper)
		EndIf
		Utility.wait(10.0)
		StrugglingAgain()
	Elseif (choice == 2);Negotiating Start
		int randomNego = Utility.RandomInt(0, 99)
		int SpeechValue = Game.getplayer().getactorvalue("Speechcraft") as int
		int RaceValue
		EscapeChance = ((SpeechValue + EscapeChance) * 0.5) as int
		EscapeChance += Raper.getrelationshiprank(Victim)
		EscapeChance -= StripCount
	
		if iscreature
			EscapeChance -= 30;because creatures can't understand human's language.
		else
			if BackAttack == 1
				;Nothing
			elseif BackAttack == 2
				EscapeChance -= 10;Choking makes it hard to speak
			elseif BackAttack == 3
				EscapeChance -= 20;Wasted.. It makes it almost impossible to persuade an assualter.
			endif
			EscapeChance += Raper.getactorvalue("Morality") as int
		endif
	
		if randomNego <= EscapeChance;success
			NegotiatingSuccess = True
			StripCount = StripCount + 3
			StripSuccessCount = StripSuccessCount + 3
			self.AnimationCheck(victim, raper)
			;Debug.notification("randomNego Success")
		else;failed
			NegotiatingSuccess = false
			StripCount = StripCount + 1
			StripSuccessCount = StripSuccessCount + 1
			self.AnimationCheck(victim, raper)
			;Debug.notification("randomNego Failed")
		endif
		
		if iscreature == true
			Racevalue = 2
		else
			Racevalue = 1
		endif
		SLHHMonitor.ShuffleScenarioes(NegotiatingSuccess, EscapeChance, Racevalue)
	Elseif (choice == 3);GivingUp
		Utility.wait(2.0)
		EscapeFail()
	EndIf
	;notification(StripSuccessCount + " and " + StripCount + " with " + SLHHStripPossibility)
EndFunction

Function NegotiatingOver(Bool Success)
	String RaperName = Raper.getbaseobject().getname()
	Actor Victim = Player.getactorreference()
	Actor Raper = Aggressor.getactorreference()
	Armor BodyPart = Game.getplayer().GetWornForm(0x00000004) as armor
	int BaseEscapeChance = SLHH_EscapeChance.getvalue() as int
	float fVictimValue = Victim.getactorvalue(GAVCustom)
	float fVictimValue2 = Victim.getactorvalue(GAVCustom2)
	float fraperValue = Raper.getactorvalue(GAVCustom)
	float fraperValue2 = Raper.getactorvalue(GAVCustom2)
	int iVictimLevel = Victim.getlevel()
	int iRaperLevel = Raper.getlevel()
	int NegoArmorStripinstant = NegoArmorStripint
	
	Armor TargPart = SLHHMonitor.FindArmor(Victim, Raper, False, None)
	
	int RSCAfterNegotiation = Utility.RandomInt(1, 100)
	
	ValueDiminish(Victim, Raper, AVdivision)
	
	If Success
		If (StripCount < EscapeCountCriterion) && BodyPart
			If TargPart
				If RSCAfterNegotiation <= SLHHStripPossibility
					while NegoArmorStripinstant > 0 
						Victim.UnequipItem(TargPart)
						TargPart = SLHHMonitor.FindArmor(Victim, Raper, False, None)
						NegoArmorStripinstant -= 1
					endwhile
					Utility.wait(2.0)
					if iscreature
						notification("The creature seemed interested in what I had to say but nothing more. it gets back to what he was doing.")
					else
						notification("Despite my persuasion, " + RaperName + " keeps stripping me!")
					endif

				else
					if iscreature
						notification("The creature seemed to understand my intention. But it never got me free. At least I managed to protect my clothes from being taken.")
					else
						notification("While " + RaperName + "was hesitating, I managed to keep " + RaperName + "away from my gear.")
					endif
					
				endif
				self.AnimationCheck(victim, raper)
			Else
				If RSCAfterNegotiation <= SLHHStripPossibility
					;Victim.UnequipItem(BodyPart)
					if SLHHMonitor.FindKeywordArmor(Victim, iscreature)
						Utility.wait(2.0)
						If BackHugStage04
							StruggleAnimCheckRace(Victim, Raper, 4)
							AnimationStart(25)
							BackHugStage02 = false
							BackHugStage03 = false
							BackHugStage04 = false
							if iscreature
								notification("No!! I am going to get fucked by this creature. This is madness! Please help!")
							else
								if BackAttack == 1 || BackAttack == 2
									notification("No!! Please!! I will give anything you want! Stop!")
								elseif BackAttack == 3
									notification("Ah... Oh.. Thirsty.. Water... It's so hot.")
								endif
							endif
						EndIf
					else
						if iscreature
							notification("Phew, it almost got me. I thought I'd be naked.")
						else
							if BackAttack == 1 || BackAttack == 2
								notification("He almost removed my clothes. I don't know how much longer I can hold him off.")
							elseif BackAttack == 3
								notification("You bad hands! How dare you! You bad hands!")
							endif
						endif
					endif
				else
					if BackAttack == 1 || BackAttack == 2
						notification("Khu..! My body is not a toy..! You need to stop!")
					elseif BackAttack == 3
						notification("Ah... Oh.. Ah.... Spinning...")
					endif
				endif
				self.AnimationCheck(victim, raper)
			EndIf
		ElseIf (StripCount < EscapeCountCriterion) && BodyPart == False
			Utility.wait(2.0)
			If TargPart
				If RSCAfterNegotiation <= SLHHStripPossibility
					while NegoArmorStripinstant > 0 
						Victim.UnequipItem(TargPart)
						TargPart = SLHHMonitor.FindArmor(Victim, Raper, False, None)
						NegoArmorStripinstant -= 1
					endwhile
					
					if iscreature
						notification("This creature is only interested in my body. This beast just wants to fuck me..!")
					else
						if BackAttack == 1 || BackAttack == 2
							notification("I know you don't want to do this. Please.. You have to stop here!")
						elseif BackAttack == 3
							notification("Please more.. Hehehe.. You want me? Take me! Hehe..")
						endif
					endif
				else
					if BackAttack == 1 || BackAttack == 2
						notification("I can't let you take off my gear! This is enough!")
					elseif BackAttack == 3
						notification("You bad boy! Um.. Where.. do you think you are touching! Hehe.. Mama scolds you!")
					endif
				endif
			else
				If RSCAfterNegotiation <= SLHHStripPossibility
					EscapeFail()
					if BackAttack == 1 || BackAttack == 2
						notification("No! I am being overwhelmed!")
					elseif BackAttack == 3
						notification("Sweet.. Dream...")
					endif
				else
					if BackAttack == 1 || BackAttack == 2
						notification("Khu! Please don't! I beg you!")
					elseif BackAttack == 3
						notification("Um.. I love kiss.. Ummm...")
					endif
				endif
			EndIf
			self.AnimationCheck(victim, raper)
		ElseIf (StripCount >= EscapeCountCriterion)
			EscapeSucess()
		EndIf
		Utility.wait(10.0)
		StrugglingAgain()
	Else
		If BodyPart
			If TargPart
				while NegoArmorStripinstant > 0 
					Victim.UnequipItem(TargPart)
					TargPart = SLHHMonitor.FindArmor(Victim, Raper, False, None)
					NegoArmorStripinstant -= 1
				endwhile
				Utility.wait(2.0)
				
				if SLHHMonitor.RemoveLower(Victim) > 0
					if BackAttack == 1 || BackAttack == 2
						notification("No! He tore off my underwear! My privates are exposed!")
					elseif BackAttack == 3
						notification("Eeh..? Did I forget to wear my underwear..? Pussy...")
					endif
				else
					if BackAttack == 1 || BackAttack == 2
						notification("I think I made his blood boil! It didn't work!")
					elseif BackAttack == 3
						notification("Did I say something..? More drink!")
					endif
				endif
			Else
				if SLHHMonitor.FindKeywordArmor(Victim, iscreature)
					;Victim.UnequipItem(BodyPart)
					Utility.wait(2.0)
					If BackHugStage04
						StruggleAnimCheckRace(Victim, Raper, 4)
						AnimationStart(25)
						BackHugStage02 = false
						BackHugStage03 = false
						BackHugStage04 = false
						if BackAttack == 1 || BackAttack == 2
							notification("No.. Please.. My private parts are exposed! Stop staring at me.")
						elseif BackAttack == 3
							notification("Where are you touching you pervert! I'll forgive you if you have another ale.. Heehee..")
						endif
					Else
						if BackAttack == 1 || BackAttack == 2
							notification("You let me go at once! Somebody help!")
						elseif BackAttack == 3
							notification("Noo... You no fun.. I am going home...")
						endif
					EndIf
				else
					if iscreature
						notification("It seems like it doesn't know how to take off my clothes.")
					else
						notification("It seems like he fails to figure out how to unequip my clothes.")
					endif
				endif
			EndIf
			self.AnimationCheck(victim, raper)
		ElseIf BodyPart == False
			Utility.wait(2.0)
			If TargPart
				while NegoArmorStripinstant > 0 
					Victim.UnequipItem(TargPart)
					TargPart = SLHHMonitor.FindArmor(Victim, Raper, False, None)
					NegoArmorStripinstant -= 1
				endwhile
				
				if SLHHMonitor.RemoveLower(Victim) > 0
					if BackAttack == 1 || BackAttack == 2
						notification("No! He took my underwear! I am completely naked!")
					elseif BackAttack == 3
						notification("I lost my underwear.. I feel like I want to pee...")
					endif
				else
					if BackAttack == 1 || BackAttack == 2
						notification("I am going to be raped at this rate! Auagh!")
					elseif BackAttack == 3
						notification("Good dog be good.. Eh.. You.. want sex..? Oh..?")
					endif
				endif
			Else
				Utility.wait(2.0)
				EscapeFail()
				notification("No.. not like this...")
			EndIf
			self.AnimationCheck(victim, raper)
		EndIf
		Utility.wait(10.0)
		StrugglingAgain()
	Endif
Endfunction

int Function AnimationCheck(actor victim, actor raper)
	If (StripCount > (EscapeCountCriterion * 0.2) as int) && (StripCount < (EscapeCountCriterion * 0.4) as int) && BackHugStage02
		StruggleAnimCheckRace(Victim, Raper, 2)
		AnimationStart(15)
		BackHugStage02 = False
	Elseif (StripCount >= (EscapeCountCriterion * 0.4) as int) && BackHugStage03
		StruggleAnimCheckRace(Victim, Raper, 3)
		AnimationStart(20)
		BackHugStage03 = False
	ElseIf (StripCount >= (EscapeCountCriterion * 0.6) as int) && BackHugStage04
		StruggleAnimCheckRace(Victim, Raper, 4)
		AnimationStart(25)
		BackHugStage02 = false
		BackHugStage03 = false
		BackHugStage04 = false
	Else
		;Nothing
	EndIf
Endfunction

Function StruggleAnimCheckRace(Actor Victim, Actor Raper, int stage)
if ViableRace == 0;Human
	if BackAttack == 1
		if stage == 1
			SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackHuginitG, BaboBackHuginitM, false)
		elseif stage == 2
			SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackhugStruggling01G, BaboBackhugStruggling01M, false)
		elseif stage == 3
			SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackhugStruggling01PG, BaboBackhugStruggling01PM, false)
		elseif stage == 4
			SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackHugClimaxG, BaboBackHugClimaxM, false)
		elseif stage == 5
			SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackhugStruggling02G, BaboBackhugStruggling02M, false)
		endif
	Elseif BackAttack == 2
		if stage == 1
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_ChokeHug_S01_A01, SLHH_ChokeHug_S01_A02, false)
		elseif stage == 2
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_ChokeHug_S02_A01, SLHH_ChokeHug_S02_A02, false)
		elseif stage == 3
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_ChokeHug_S03_A01, SLHH_ChokeHug_S03_A02, false)
		elseif stage == 4
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_ChokeHug_S04_A01, SLHH_ChokeHug_S04_A02, false)
		elseif stage == 5
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_ChokeHug_S05_A01, SLHH_ChokeHug_S05_A02, false)
		endif
	Elseif BackAttack == 3
		if stage == 1
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_Drunk_S01_A01, SLHH_Drunk_S01_A02, false)
		elseif stage == 2
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_Drunk_S02_A01, SLHH_Drunk_S02_A02, false)
		elseif stage == 3
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_Drunk_S03_A01, SLHH_Drunk_S03_A02, false)
		elseif stage == 4
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_Drunk_S04_A01, SLHH_Drunk_S04_A02, false)
		elseif stage == 5
			SLHHMonitor.StruggleAnim(Victim, Raper, True, SLHH_Drunk_S05_A01, SLHH_Drunk_S05_A02, false)
		endif
	Endif
Expression(Victim, false, true)
Expression(Raper, false, false)
elseif ViableRace == 1;Troll
	if stage == 1
		SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackHuginitGfortroll, BaboBackHuginitMfortroll, true)
	elseif stage == 2
		SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackhugStruggling01Gfortroll, BaboBackhugStruggling01Mfortroll, true)
	elseif stage == 3
		SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackhugStruggling01PGfortroll, BaboBackhugStruggling01PMfortroll, true)
	elseif stage == 4
		SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackHugClimaxGfortroll, BaboBackHugClimaxMfortroll, true)
	elseif stage == 5
		SLHHMonitor.StruggleAnim(Victim, Raper, True, BaboBackhugStruggling02Gfortroll, BaboBackhugStruggling02Mfortroll, true)
	endif
Expression(Victim, false, true)
endif
EndFunction

Function StrugglingAgain()
If GetStage() == 130 || GetStage() == 131 || GetStage() == 132
	ResistSelection((Player.getRef() as Actor), (Aggressor.getRef() as Actor))
EndIf
EndFunction

Function EscapeFail()
	int choice
	Actor Raper = Aggressor.getRef() as Actor
	SLHHMonitor.NegotiationSuccessPossibility = 0
	SLHHMonitor.RegisterAlias(none, false)
	if iscreature
		choice = SLHHFailedCreatureMessagebox.Show()
	else
		if BackAttack == 1
			choice = SLHHFailedMessagebox.Show()
		elseif BackAttack == 2
			choice = SLHHChokeFailedMessagebox.Show()
		elseif BackAttack == 3
			choice = SLHHDrunkFailedMessagebox.Show()
		endif
	endif
	if (choice == 0);Nochoice
		SLAPPTrigger(True)
		AnimationStart(30)
		if viablerace == 0
			if BackAttack == 1
				SLHHMonitor.StruggleAnim(game.getplayer(), Raper, False, None, None, false)
			;elseif BackAttack == 2 && SLHH_ScriptEventBC.getvalue() == 1
			elseif BackAttack == 2
				SLHHMonitor.StruggleAnim(game.getplayer(), Raper, False, None, None, false)
				Utility.wait(0.5);wait for the script
				game.getplayer().Playidle(SLHH_DeathStart)
				FinishedBackAttack(Raper)
				Return
			elseif BackAttack == 3 && SLHH_ScriptEventDrunk.getvalue() == 1
				Utility.wait(0.5);wait for the script
				SLHHMonitor.StruggleAnim(game.getplayer(), Raper, True, SLHH_Drunk_SBD_A01Start, SLHH_Drunk_SBD_A02Start, false)
				;game.getplayer().Playidle(SLHH_Drunk_SBD_A01Start)
				;Raper.Playidle(SLHH_Drunk_SBD_A02Start)
				FinishedBackAttack(Raper)
				Utility.wait(10.0)
				SLHHMonitor.StruggleAnim(game.getplayer(), Raper, False, None, None, false)
				Return
			else
				SLHHMonitor.StruggleAnim(game.getplayer(), Raper, False, None, None, false)
			endif
			
		elseif viablerace > 0
			SLHHMonitor.StruggleAnim(game.getplayer(), Raper, False, None, None, true)
		endif
		setstage(140)
	EndIf
EndFunction

Function EscapeSucess()
	Actor Raper = Aggressor.getRef() as Actor
		SLAPPTrigger(false)
			If BaboDialogueVerification(Raper) == true
				BaboDialogueTrigger(Raper, false)
			Endif
		SLHHMonitor.NegotiationSuccessPossibility = 0
		SLHHMonitor.RegisterAlias(none, false)
		StruggleAnimCheckRace(game.getplayer(), Raper, 5)
		Utility.wait(2.0)
		if viablerace == 0
			SLHHMonitor.StruggleAnim(game.getplayer(), Raper, False, None, None, false)
		elseif viablerace > 0
			SLHHMonitor.StruggleAnim(game.getplayer(), Raper, False, None, None, true)
		endif
		setstage(134)
EndFunction

Function Expression(Actor akActor, Bool Removal = false, Bool Victim = True)

If !Removal

MfgConsoleFunc.ResetPhonemeModifier(akActor) ; Remove any previous modifiers and phonemes
	Int random = Utility.RandomInt(0, 99)
	If Victim

	If random < 22

		akActor.SetExpressionOverride(14,100)	; Disgusted!
		MfgConsoleFunc.SetPhoneme(akActor,0,60)
	
	ElseIf random < 44 && random >= 22
	
		akActor.SetExpressionOverride(9,100)	; Fear!
		MfgConsoleFunc.SetModifier(akActor,0,15)
		MfgConsoleFunc.SetModifier(akActor,1,15)
		MfgConsoleFunc.SetModifier(akActor,4,70)
		MfgConsoleFunc.SetModifier(akActor,5,70)
		MfgConsoleFunc.SetPhoneme(akActor,4,30)
		MfgConsoleFunc.SetPhoneme(akActor,7,30)
		MfgConsoleFunc.SetPhoneme(akActor,11,30)
		
	ElseIf random < 66 && random >= 44

		akActor.SetExpressionOverride(8,100)	; Don't touch me! Angry
		MfgConsoleFunc.SetPhoneme(akActor,1,60)
		
	ElseIf random < 88 && random >= 66
	
		akActor.SetExpressionOverride(11,100)	; Sad! Don't!
		MfgConsoleFunc.SetModifier(akActor,0,70)
		MfgConsoleFunc.SetModifier(akActor,1,70)
		MfgConsoleFunc.SetPhoneme(akActor,11,50)
		
	Else

		akActor.SetExpressionOverride(11,100)	; Sad! Don't!
		MfgConsoleFunc.SetModifier(akActor,0,30)
		MfgConsoleFunc.SetModifier(akActor,1,30)
		MfgConsoleFunc.SetPhoneme(akActor,11,50)
	
	EndIf
	EndIf
	
	If !Victim
	
	If random < 22

		akActor.SetExpressionOverride(14,100)	; Disgusted!
		MfgConsoleFunc.SetPhoneme(akActor,0,60)
	
	ElseIf random < 44 && random >= 22
	
		akActor.SetExpressionOverride(0,100)	; Angry!
		MfgConsoleFunc.SetPhoneme(akActor,4,30)
		MfgConsoleFunc.SetPhoneme(akActor,7,30)
		
	ElseIf random < 66 && random >= 44

		akActor.SetExpressionOverride(8,100)	; Angry!!
		MfgConsoleFunc.SetPhoneme(akActor,1,60)
		
	ElseIf random < 88 && random >= 66
	
		akActor.SetExpressionOverride(6,100)	; Don't Move! Disgusted
		MfgConsoleFunc.SetPhoneme(akActor,1,30)
		
	Else

		akActor.SetExpressionOverride(8,100)
		MfgConsoleFunc.SetModifier(akActor,0,30)
		MfgConsoleFunc.SetModifier(akActor,1,30)
		MfgConsoleFunc.SetPhoneme(akActor,7,50)
	
	EndIf
	
	EndIf
	
Else
	MfgConsoleFunc.ResetPhonemeModifier(akActor) ; Remove any previous modifiers and phonemes
EndIf

Endfunction

Function ValueDiminish(Actor Victim, Actor Raper, int division)
float Vvalue = GetMaximumActorValue(Victim, GAVCustom)
float Vvalue2 = GetMaximumActorValue(Victim, GAVCustom2)
float Rvalue = GetMaximumActorValue(Raper, GAVCustom)
float Rvalue2 = GetMaximumActorValue(Raper, GAVCustom2)

Int DamageVvalue = ((Vvalue / 100) * division) as int
Int DamageVvalue2 = ((Vvalue2 / 100) * division) as int
Int DamageRvalue = ((Rvalue / 100) * division) as int
Int DamageRvalue2 = ((Rvalue2 / 100) * division) as int
int ADvalue
int ADvalue2

If DamageVvalue >= DamageRvalue
	ADvalue = DamageVvalue
Else
	ADvalue = DamageRvalue
EndIf

If DamageVvalue2 >= DamageRvalue2
	ADvalue2 = DamageVvalue2
Else
	ADvalue2 = DamageRvalue2
EndIf

Victim.DamageActorValue(GAVCustom, ADvalue)
Victim.DamageActorValue(GAVCustom2, ADvalue2)
Raper.DamageActorValue(GAVCustom, ADvalue)
Raper.DamageActorValue(GAVCustom2, ADvalue2)
EndFunction

Float Function GetMaximumActorValue(Actor akActor, String asValueName)
    ; returns the maximum value for this actor value, buffs are accounted for.
    Float BaseValue = akActor.GetBaseActorValue(asValueName)
    Float CurrentMaxValue = Math.Ceiling(akActor.GetActorValue(asValueName) / akActor.GetActorValuePercentage(asValueName))
 
    if BaseValue < CurrentMaxValue
        return BaseValue
    else
        return CurrentMaxValue
    endif
EndFunction

int Function EscapeChanceCalculation(int BaseChance, int Vlevel, int Rlevel, float Vvalue, float Rvalue)
If BaseChance == 101
	Return 100;which means it will result in 100% escape chance
ElseIf Basechance == -1
	Return 0
EndIf
int FinalEscapeChance
int FinalValue
int Dlevel = Vlevel - Rlevel
int Dvalue = ((Vvalue - Rvalue) / 10) as int
FinalEscapeChance = BaseChance


If SLHH_DamageActorValueGlobal.getvalue() == 0
	GAVCustom = "None"
	GAVCustom2 = "None"
Elseif SLHH_DamageActorValueGlobal.getvalue() == 1
	GAVCustom = "Stamina"
	GAVCustom2 = "None"
Elseif SLHH_DamageActorValueGlobal.getvalue() == 2
	GAVCustom = "Magicka"
	GAVCustom2 = "None"
Elseif SLHH_DamageActorValueGlobal.getvalue() == 3
	GAVCustom = "Stamina"
	GAVCustom2 = "Magicka"
Endif
	
	
If SLHH_ResistMethodGlobal.getvalue() == 0
	Return FinalEscapeChance
Elseif SLHH_ResistMethodGlobal.getvalue() == 1
	FinalEscapeChance += Dvalue
Elseif SLHH_ResistMethodGlobal.getvalue() == 2
	FinalEscapeChance += Dlevel
Elseif SLHH_ResistMethodGlobal.getvalue() == 3
	FinalEscapeChance += Dlevel
	FinalEscapeChance += Dvalue
Endif
	If FinalEscapeChance > 100
		FinalEscapeChance = 100
	Endif

	Return FinalEscapeChance

EndFunction

Int Function CheckHundred(int value)
If value > 100
	value = 100
	return value
else
return value
EndIf
EndFunction

;---------------------------SLAPP Related-----------------------------------

Function SLAPPTrigger(Bool Worse = false)
	If Worse
		SLAPPEventRegister(True); SLHHConsequneceWorse, Rape Success
	Else
		SLAPPEventRegister(False); SLHHConsequneceBad, Rape Failed
	EndIf
EndFunction

Function SLAPPEventRegister(Bool Worse)
	int handle = ModEvent.Create("SLAPP_ConsequenceEvent")
	if (handle)
		ModEvent.PushBool(handle, Worse)
		ModEvent.PushString(handle, "SLHH activated SLAPPConsequence")
		ModEvent.Send(handle)
	endIf
EndFunction

;---------------------------BaboDialogue Related-----------------------------------

Function BaboDialogueTrigger(Actor Raper, Bool Worse = false)
Debug.Trace("BaboDialogueTrigger Function started")
	If Worse
		BaboDialogueEventRegister(Raper, True); SLHHConsequneceWorse, Rape Success
	;	Debug.notification("Worse")
	Else
		BaboDialogueEventRegister(Raper, False); SLHHConsequneceBad, Rape Failed
	;	Debug.notification("Worse false")
	EndIf
EndFunction

Function BaboDialogueEventRegister(Actor Raper, Bool Worse)
	String RaperName = Raper.getactorbase() as string
	;Debug.Notification(RaperName + " raped Player")
	Debug.Trace(Raper.getactorbase() + " raped Player" + Worse as Bool)
	int handle = ModEvent.Create("BaboDialogue_ConsequenceEvent")
	Form Raperform = Raper as form
	if (handle)
		ModEvent.Pushform(handle, Raper)
		ModEvent.PushBool(handle, Worse)
		ModEvent.PushString(handle, "SLHH activated BaboDialogueConsequence")
		ModEvent.Send(handle)
	endIf
EndFunction