Scriptname slapp_util extends Quest

Function Log(String msg)
	; bool debugflag = true
	; bool debugflag = false

	if (SLApproachMain.debugLogFlag)
		debug.trace("[slapp] " + msg);
	endif
EndFunction

int Function RelationCalc(Actor akRef, Actor akRef2)
	int relationship = akRef.GetRelationshipRank(akRef2)
	
	if (relationship <= -4)
		return 50
	Elseif (relationship == -3)
		return 40
	Elseif (relationship == -2)
		return 35
	Elseif (relationship == -2)
		return 20
	Elseif (relationship == -1)
		return 10
	Elseif (relationship == 0)
		return 0
	Elseif (relationship == 1)
		return -20
	Elseif (relationship == 2)
		return -30
	Elseif (relationship == 3)
		return -50
	Elseif (relationship >= 4)
		return -60
	endif
	return 0
EndFunction

int Function TimeCalc(bool enableMinus = true)
	float Time = Utility.GetCurrentGameTime()
	Time -= Math.Floor(Time)
	Time *= 24
	int hour = (Time as Int)
	
	if(hour >= 22 || hour < 2)
		return 25
	elseif(hour >= 20 || hour < 4)
		return 20
	elseif(hour >= 18 || hour < 6)
		return 15
	elseif (hour > 8 || hour < 16)
		return -25
	endif
	
	return 0
EndFunction

int Function HomeAlone() ; SLAActorInHouseType
	Actor randomActor = Game.FindRandomActorFromRef(PlayerRef.GetReference() as Actor, 1024.0)
	

	if randomActor
		if randomactor.isinfaction(PlayerMarriedFaction)
			SLAActorInHouseType.setvalue(3)
		elseif	randomactor.isinfaction(PotentialFollowerFaction) || randomactor.isinfaction(CurrentFollowerFaction)
			SLAActorInHouseType.setvalue(2)
		elseif	randomactor.ischild()
			SLAActorInHouseType.setvalue(1)
		else
			SLAActorInHouseType.setvalue(0)
		endif
		
		if SLAActorInHouseType.getvalue() == 1
			return 10
		elseif SLAActorInHouseType.getvalue() == 2
			return -50
		elseif SLAActorInHouseType.getvalue() == 3
			return -80
		else
			return -30
		endif
	else
		SLAActorInHouseType.setvalue(0);No one
		return 50
	endif
EndFunction

int Function CharacterCalc(Actor akRef)
	int character = akRef.Getfactionrank(slapp_Characterfaction) as int
	
	if (character == 0)
		return -25
	elseif (character == 1)
		return -10
	elseif (character == 2)
		return 0
	elseif (character == 3)
		return 10
	elseif (character == 0)
		return 25
	else
		return 0
	endif
EndFunction

int Function LightLevelCalc(Actor akRef, bool enableMinus = true)
	int anslightlevel = akRef.GetLightLevel() as int
	
	if(anslightlevel < 50)
		return 25
	elseif(anslightlevel < 60)
		return 20
	elseif(anslightlevel < 75)
		return 15
	elseif (anslightlevel > 100)
		return -25
	elseif (anslightlevel > 150)
		return -50
	endif

	return 0
EndFunction

int Function BedCalc(Actor akRef)
	if(SexLab.FindBed(akRef, 1000.0))
		return 20
	else
		return -30
	endif
EndFunction

int Function NudeCalc(Actor akRef)
If SLANakedArmorToggle.getvalue() == 1
	If akRef.WornHasKeyword(SLA_ArmorPretty)
		return 5
	ElseIf (akRef.WornHasKeyword(EroticArmor)) || (akRef.isequipped(sla_NakedArmorList))
		return 25
	ElseIf (akRef.WornHasKeyword(SLA_ArmorSpendex)) || (akRef.WornHasKeyword(SLA_ArmorLewdLeotard))
		return 35
	ElseIf (akRef.WornHasKeyword(SLA_ArmorHalfNakedBikini)) || (akRef.WornHasKeyword(SLA_ArmorCurtain))
		return 50
	ElseIf (akRef.WornHasKeyword(SLA_ArmorHalfNaked)) || (akRef.WornHasKeyword(SLA_ArmorTransparent))
		return 60
	elseif (!akRef.WornHasKeyword(kArmorCuirass) && !akRef.WornHasKeyword(kClothingBody))
		return 70
	else
		return 0
	endif
Else
	return 0
EndIf
EndFunction

int Function AppearanceCalc()

int value
int AppearanceValue = ((SLApproachMain.SLAPCAppearance)/4) as int
int BreastsValue = ((SLApproachMain.SLAPCBreasts)/4) as int
int ButtsValue = ((SLApproachMain.SLAPCButts)/4) as int

Value = AppearanceValue + BreastsValue + ButtsValue

;If Value > 100 ; Actually this is meaningless for 75 is the highest value at best
;	Value = 100
;EndIf

Return Value

EndFunction

int Function SexAnimActiveCalc(Actor akRef)
	if(SexLab.IsActorActive(akRef))
		return 40
	else
		return 0
	endif
EndFunction

int Function TeammateCalc(Actor akRef, Actor target)
	if(akRef.IsPlayerTeammate())
		if(target.IsPlayerTeammate())
			return 0
		else
			return -20
		endif
	endif

	if(target.IsPlayerTeammate())
		if(!akRef.IsPlayerTeammate())
			return -20
		endif
	endif
	
	return 0
EndFunction

bool Function ValidatePromise(Actor akRef, Actor target)
	if (!SLApproachMain.enablePromiseFlag)
		return true
	else
		bool akRefAgree = (akRef.GetItemCount(SLAppRingAgreement) > 0)
		bool targetAgree = (target.GetItemCount(SLAppRingAgreement) > 0)
		
		if (akRef.IsEquipped(SLAppRingLove) || target.IsEquipped(SLAppRingLove))
			return true
		elseif (akRef.WornHasKeyword(kSLAppPromiseRing) || akRefAgree)
			if (target.WornHasKeyword(kSLAppPromiseRing) || targetAgree)
				if (self._validatePromise(akRef, akRefAgree, target, targetAgree, SLAppRing01))
					return true
				elseif (self._validatePromise(akRef, akRefAgree, target, targetAgree, SLAppRing02))
					return true
				elseif (self._validatePromise(akRef, akRefAgree, target, targetAgree, SLAppRing03))
					return true
				elseif (self._validatePromise(akRef, akRefAgree, target, targetAgree, SLAppRing04))
					return true
				elseif (self._validatePromise(akRef, akRefAgree, target, targetAgree, SLAppRing05))
					return true
				endif
			endif
			
			return false
		elseif (target.WornHasKeyword(kSLAppPromiseRing) || targetAgree)
			return false
		else
			return true
		endif
	endif
EndFunction

bool Function _validatePromise(Actor akRef, bool akRefAgree, Actor target, bool targetAgree, Armor keyItem)
	if (akRef.IsEquipped(keyItem) && target.IsEquipped(keyItem))
		return true
	elseif (akRef.IsEquipped(keyItem) && (targetAgree && target.GetItemCount(keyItem)))
		return true
	elseif ((akRefAgree && akRef.GetItemCount(keyItem)) && target.IsEquipped(keyItem))
		return true
	elseif (akRefAgree && targetAgree && akRef.GetItemCount(keyItem) && target.GetItemCount(keyItem))
		return true
	else
		return false
	endif
EndFunction

bool Function ValidateShyness(Actor akRef, Actor target)
	if (akRef.IsEquipped(SLAppRingShyness) && !target.IsPlayerTeammate() && target != PlayerRef.GetReference() as Actor)
		return false
	elseif (target.IsEquipped(SLAppRingShyness) && (!akRef.IsPlayerTeammate() && !self.ValidateHorse(akRef)))
		return false
	else
		return true
	endif
EndFunction

bool Function ValidateGender(Actor akRef, Actor target, bool isplayer = false)
	int akRefGender = SexLab.GetGender(akRef)
	int targetGender = SexLab.GetGender(target)

	if (isplayer)
		if (akRefGender != targetGender && target.IsEquipped(SLAppRingHomoStrong))
			return false
		elseif (akRefGender == targetGender && (!target.IsEquipped(SLAppRingHomo) && !target.IsEquipped(SLAppRingHomoStrong)))
			return false
		endif
	elseif (akRefGender == targetGender)
		if !(akRef.IsEquipped(SLAppRingHomo) && target.IsEquipped(SLAppRingHomo))
			return false
		endif
	endif
	
	return true
EndFunction

int Function GetTargetGender(Actor akRef)
	int srcgender = SexLab.GetGender(akRef)
	if (akRef.IsEquipped(SLAppRingHomo))
		return -1 ; any
	elseif (srcgender != 1 && srcgender != 3) ; not female and female creature
		return 1
	else
		return 0
	endif
EndFunction

int Function ValidateChance(int x)
	if (x < 0)
		return 0
	elseif (x > 150)
		return 150
	else
		return x
	endif
EndFunction

bool Function ValidateHorse(Actor horse)
	if (horse.IsInFaction(PlayerHorseFaction) || horse == Frost || horse == Shadowmere)
		return true
	else
		return false
	endif
EndFunction

int Function GetDoorLockLevel(ObjectReference lock)
	int level = lock.GetLockLevel()
 
	if !lock.IsLocked()
		return 0
	endif
 
	if level == 0 || level == 1 ;novice
		return 1
	elseif level >= 2 && level <= 25 ;Apprentice
		return 2
	elseif level >= 26 && level <= 50 ;Adept
		return 3
	elseif level >= 51 && level <= 75 ;Expert
		return 4
	elseif level >= 76 && level <= 254 ;Master
		return 5
	else
		return 6; it requires a key
	endif
EndFunction


Function SendLicenceStateUpdateEvent()
	; Event sent when a licence changes state: Either from/to HasValidxxxxLicence/!HasValidxxxxLicence or a licence type has been enabled/disabled
	; Note this event is also sent periodically at the beginning of every game day.
	
	; Valid Global Variables:
	; _SLS_HasValidMagicLicence
	; _SLS_HasValidWeaponLicence
	; _SLS_HasValidArmorLicence
	; _SLS_HasValidBikiniLicence
	; _SLS_HasValidClothesLicence
	; _SLS_HasValidCurfewLicence
	; _SLS_HasValidWhoreLicence
	; _SLS_HasValidPropertyLicence
	; _SLS_HasValidFreedomLicence
	
	; Values: -1: Licence type disabled, 0: Does not have licence or licence expired, 1: Has a valid licence
	
	; Eg 1: StorageUtil.GetIntValue(None, "_SLS_HasValidMagicLicence", Missing = -2) == 1 ; Magic licence is enabled and the player has a valid magic licence
	; Eg 2: StorageUtil.GetIntValue(None, "_SLS_HasValidBikiniLicence", Missing = -2) == -1 ; Bikini licence is disabled
	; Eg 3: StorageUtil.GetIntValue(None, "_SLS_HasValidWeaponLicence", Missing = -2) == -1 ; All licences are disabled (because currently you can only disable weapon licences by disabling all licences)
	; Eg 4: StorageUtil.GetIntValue(None, "_SLS_HasValidClothesLicence", Missing = -2) == 0 ; Clothes licence is enabled but the player hasn't got a valid clothes licence
	; Eg 5: StorageUtil.GetIntValue(None, "_SLS_HasValidClothesLicence", Missing = -2) == -2 ; SLS is probably not installed
	
	;SendModEvent("_SLS_LicenceStateUpdateEvent")
EndFunction

SLApproachMainScript Property SLApproachMain Auto
SexLabFramework Property SexLab  Auto


GlobalVariable Property SLANakedArmorToggle Auto
GlobalVariable Property SLAAppearanceSlide Auto
GlobalVariable Property SLABreastsSlide Auto
GlobalVariable Property SLAButtsSlide Auto

Keyword Property SLA_ArmorPretty Auto
Keyword Property EroticArmor Auto
Keyword Property SLA_ArmorLewdLeotard Auto
Keyword Property SLA_ArmorSpendex Auto
Keyword Property SLA_ArmorHalfNakedBikini Auto
Keyword Property SLA_ArmorTransparent Auto
Keyword Property SLA_ArmorCurtain Auto
Keyword Property SLA_ArmorHalfNaked Auto

Form Property sla_NakedArmorList Auto

Keyword Property kArmorCuirass Auto
Keyword Property kClothingBody Auto
Keyword Property kSLAppPromiseRing  Auto

Armor Property SLAppRing01  Auto  
Armor Property SLAppRing02  Auto  
Armor Property SLAppRing03  Auto  
Armor Property SLAppRing04  Auto  
Armor Property SLAppRing05  Auto  
Armor Property SLAppRingLove  Auto  
Armor Property SLAppRingShyness  Auto  
Armor Property SLAppRingHomo  Auto  
Armor Property SLAppRingHomoStrong  Auto  
Armor Property SLAppRingAgreement  Auto  

ReferenceAlias Property PlayerRef  Auto  

Actor Property Frost  Auto  
Actor Property Shadowmere  Auto  
Faction Property PlayerHorseFaction  Auto  

GlobalVariable Property SLAActorInHouseType Auto
Faction Property PotentialFollowerFaction Auto
Faction Property CurrentFollowerFaction Auto
Faction Property PlayerMarriedFaction Auto
Faction Property slapp_Characterfaction Auto
