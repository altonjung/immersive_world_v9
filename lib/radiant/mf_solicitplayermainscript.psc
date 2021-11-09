Scriptname mf_SolicitPlayerMainScript extends Quest  

mf_Handler Property Handler Auto
mf_Variables Property HandlerConditional Auto
mf_Handler_Config Property HandlerConfig Auto

ReferenceAlias Property akClientRef Auto
ReferenceAlias Property akPlayerRef Auto

AssociationType Property SpouseType Auto
Keyword Property ArmorKeyword Auto
Keyword Property ClothesKeyword Auto
Keyword Property JobWhore  Auto  

FormList Property BeastRace Auto
FormList Property ElfRace Auto
FormList Property HumanRace Auto

SexLabFramework Property SexLab Auto hidden
slaFrameworkScr Property sla Auto hidden

float LastOrgasm1

Actor help222 = none

Actor lastClient = none

Actor Function GetClient()

    If Game.GetModByName("SexLab.esm") != 255
        SexLab = Game.GetFormFromFile(0x00000d62, "SexLab.esm") as SexLabFramework 
    EndIf

    If Game.GetModByName("SexLabAroused.esm") != 255
        sla = Game.GetFormFromFile(0x0004290F, "SexLabAroused.esm") as slaFrameworkScr
    EndIf

    Actor akPlayer = akPlayerRef.GetRef() as Actor
    Actor akClient = akClientRef.GetRef() as Actor
    int cSex = akClient.GetLeveledActorBase().GetSex()
    Race clientRace = akClient.GetLeveledActorBase().GetRace()
    int cRace
    if(HumanRace.HasForm(clientRace))
        cRace = 1
    elseif(ElfRace.HasForm(clientRace))
        cRace = 2
    elseif(BeastRace.HasForm(clientRace))   
        cRace = 4
    else
        cRace = 8
    endif
    
;   LastOrgasm1 = StorageUtil.GetFloatValue(akClient, "SLAroused.LastOrgasmDate", Missing = 0.0)
    int ArousalHelp = sla.GetActorExposure(akClient)
    float ArousalStore1 = ArousalHelp as float
    
;   help222 = SexLab.LastSexPartner(akClient)
;   if help222 != none
;       debug.notification("Found something")
;   else
;       debug.notification("Version "+SexLab.GetVersion())
;   endif
    
;   debug.notification("Client "+akClient.GetLeveledActorBase().GetName()+" Arousal "+ArousalStore1)
;   debug.notification("Client "+akClient.GetLeveledActorBase().GetName()+" Last Orgasm "+LastOrgasm1)
;   debug.notification("Client "+akClient.GetLeveledActorBase().GetName()+" Last Partner "+help222.GetLeveledActorBase().GetName())
;   debug.notification("Last Client "+Sexlab.LastSexPartner(akPlayer).GetLeveledActorBase().GetName())

    if(akClient == lastClient)
        return none     ;this client just performed but somehow snuck past the mf_Refractory condition
    EndIf
    
; checking for Rape and locking rapist for 12 hours without Sex

    if SexLab.WasVictimOf(akPlayer, akClient)
;       debug.notification(akClient.GetLeveledActorBase().GetName()+" has raped Prostitute")
        float whenwasit = SexLab.HoursSinceLastSex(akClient)
        if whenwasit < 12.0
;           debug.notification("He will steam longer than "+whenwasit)
            return none
        else
;           debug.notification("He steamed for "+whenwasit+" which is long enough")
        endif
    else
;       debug.notification("no rape")
    endif

; checking for Sex and locking Client for 6 hours without Sex
    
    if (SexLab.HoursSinceLastSex(akClient) < 6.0 )
;       debug.notification(akClient.GetLeveledActorBase().GetName()+" had Sex the last 6 hours")
        return none
    endif
    
    ;base MCM chance
    float baseChance = (100.0 / HandlerConfig.OveralModifier)

    ;gender MCM modifiers
    if(Game.GetPlayer().GetActorBase().GetSex() == 0)
        if(cSex == 0)
            baseChance = ( baseChance * ( HandlerConfig.MMApproachFreq As Float / 100 ) )
        else
            baseChance = ( baseChance * ( HandlerConfig.FMApproachFreq As Float / 100 ) )
        endif
    else
        if(cSex == 0)
            baseChance = ( baseChance * ( HandlerConfig.MFApproachFreq As Float / 100 ) )
        else
            baseChance = ( baseChance * ( HandlerConfig.FFApproachFreq As Float / 100 ) )
        endif   
    endif
    
    ;race MCM modifiers
    int RaceDiff = Math.abs((cRace - Handler.PlayerRace) as float) as int       
    if(RaceDiff == 1)
        baseChance = ( baseChance * ( (100 + HandlerConfig.HEChance As Float) / 100 ) )
    elseif(RaceDiff == 2)
        baseChance = ( baseChance * ( (100 + HandlerConfig.EBChance As Float) / 100 ) )
    elseif(RaceDiff == 3)
        baseChance = ( baseChance * ( (100 + HandlerConfig.HBChance As Float) / 100 ) )
    else
        ; same race or mix involving mod races
    endif
    
    ;spouse modifier
    if(akClient.HasAssociation(SpouseType)) ; make married NPC less likely to approach
        baseChance = baseChance * 0.75
    endif

    ;player clothing modifiers
    Form armorForm = Game.GetPlayer().GetWornForm(0x00000004)
    if(akPlayer.WornHasKeyword(JobWhore) || HandlerConfig.WorkingClothes.hasForm(armorForm))
        baseChance = baseChance * 1.2
    elseif(akPlayer.WornHasKeyword(ClothesKeyword))
        baseChance = baseChance * 1.05
    elseif(akPlayer.WornHasKeyword(ArmorKeyword))
        baseChance = baseChance * 0.8
    else ; naked torso
        baseChance = baseChance * 1.1
    endif
    ; Arousal Modifier
    
    float Arousal_Modifier = 1.0
    if (ArousalStore1 < 50)
        Arousal_Modifier = (100 - (50 - ArousalStore1))  / 100
    else
        Arousal_Modifier = (100 + (ArousalStore1 - 50))  / 100
    endif

;   Debug.Notification("Arousal Modification Factor "+Arousal_Modifier)

    baseChance = baseChance * Arousal_Modifier

    ;calc if client wins the approach roll
;   Debug.Notification("Base Chance "+baseChance)
    int approachChance = baseChance As Int
    int approachRoll = Utility.RandomInt(1,100)
    
    If ( approachRoll < approachChance )
        return akClient
    Else
        return none
    EndIf
    
 endFunction
