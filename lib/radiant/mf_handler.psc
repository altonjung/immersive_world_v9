Scriptname mf_Handler extends Quest  

SexLabFramework Property SexLab Auto

mf_Handler_Config Property HandlerConfig Auto
mf_Variables Property HandlerConditional Auto
slaFrameworkScr Property sla Auto

ImageSpaceModifier Property FadeIn  Auto  
ImageSpaceModifier Property FadeOut  Auto  
ImageSpaceModifier Property BlackScreen  Auto  

Message Property ErrorMessage  Auto 

Armor Property WenchCloths  Auto  
Armor Property WenchBoots  Auto  
MiscObject Property Gold  Auto 
; ------ SERVING FOOD QUEST ------------------
MF_FoodJob Property FoodJob Auto
Quest Property SimplerJob  Auto  
mf_simplerjobscript Property SimplerJobScript  Auto  
float TimeLastJobFailed = 0.0
float TimeLastFailJob = 0.0
; ------ FREE ROAMING PROSTITUTION QUEST -----
Quest Property SingleJobMonitor Auto
mf_SolicitPlayerMainScript Property SingleJobMonitorScript Auto
mf_SimpleJobQuestScript Property SingleJob Auto
mf_SimpleJobQuestScript Property SingleJobScript Auto
String akJobType
int totalReward = 0
; ------ HOME DELIVERY QUEST -----------------
MF_RandomQuest Property HomeJob Auto
FormList Property HomeJobs  Auto  
float TimeLastHomeJobCompleted
; ------ MILITARY CAMP QUEST -----------------
MF_RandomQuest Property CampJob Auto
FormList Property CampJobs  Auto
float TimeLastCampJobCompleted
; ------ RANDOM JOB QUEST --------------------
FormList Property RandomQuests Auto
MF_RandomQuest currentQuest
float TimeLastRandomJobCompleted

GlobalVariable Property UndeclaredJobs Auto
GlobalVariable Property TotalClients  Auto
GlobalVariable Property MissingMoney  Auto  
Faction Property ProstituteFaction Auto
Faction Property MadameFaction  Auto 

SPELL Property RefractoryS Auto
SPELL Property RefractoryD Auto

FormList Property BeastRace Auto
FormList Property ElfRace Auto
FormList Property HumanRace Auto

ReferenceAlias Property akPlayerRef Auto
Actor Property akPlayer Auto
int Property PlayerRace Auto

Actor Property akMadame Auto

float Property BountyMult = 1.0 Auto

int lastHomeJob = 0
int lastCampJob = 0
int lastRandomJob = 0

;Frostfall things
bool isFrostfallLoaded = false
GlobalVariable  property Frostfall_exposurePoints = none  auto

SexLabFramework Function GetSexLab()
    return SexLab
endFunction

Actor Function GetPlayer()
    return akPlayer
endFunction

int Function GetScanInterval()
    return HandlerConfig.ScanInterval as int
endFunction

int Function GetMaxRepetitions()
    return (HandlerConfig.MaxRepetitions + 1) as int   ;WS note - the +1 is because of a mismatch between the MCM descriptions and how the scripts use the MaxRepetitions var. (as far as scripts are concerned, a single sex scene is already 1 repetition)
endFunction

Function AddInitClothes()
    HandlerConditional.GotClothes = true

    int config = JValue.readFromFile("Data/MF_RP_Config.json")

    if(config != 0)
        form chestPiece = JValue.solveForm(config, ".startCloths.chestPiece")
        akPlayer.addItem(chestPiece,1)

        int rest = JValue.solveObj(config, ".startCloths.rest")
        int count  = JArray.count(rest)
        while(count >= 0 )
            count -= 1
            akPlayer.addItem(JArray.getForm(rest,count),1)  
        endWhile
        JValue.release(rest)
        JValue.release(config)
    else
        akPlayer.addItem(WenchCloths,1)
        akPlayer.addItem(WenchBoots,1)
    endIf
endFunction

Function ModBountyMult(int point)
    if(point < 0)
        BountyMult -= HandlerConfig.BountyDownRate * point
    else
        BountyMult += HandlerConfig.BountyUpRate * point
    endif
    
    if(BountyMult < 1.0)
        BountyMult = 1.0
    elseif(BountyMult > HandlerConfig.MaxBountyMult)
        BountyMult = HandlerConfig.MaxBountyMult
    endif
endFunction


int Function ValidateStatInt(string statName, int localValue, int modLocValue)
    if(SexLab.FindStat(statName) == -1)
        int value = localValue + modLocValue
        SexLab.RegisterStat(statName, value as string) 
        return value
    else
        return SexLab.AdjustBy(statName, modLocValue)
    endif
endFunction


Function TriggerFailCD()
    RegisterForUpdateGameTime(0.5)
    TimeLastFailJob = Utility.GetCurrentGameTime()
    HandlerConditional.FailJobOnCD = 1
endFunction


Function TriggerHomeJobCD()
    RegisterForUpdateGameTime(0.5)
    TimeLastHomeJobCompleted = Utility.GetCurrentGameTime()
    HandlerConditional.HomeJobOnCD = 1
endFunction


Function TriggerCampJobCD()
    RegisterForUpdateGameTime(0.5)
    TimeLastCampJobCompleted = Utility.GetCurrentGameTime()
    HandlerConditional.CampJobOnCD = 1
endFunction

Function HomeJobGuestTrigger()
    int HomeJobGuestRoll = Utility.RandomInt(0,100)
    if HomeJobGuestRoll <= HandlerConfig.HomeDeliveryGuestChance
        HandlerConditional.HomeJobGuest = 1
    Else
        HandlerConditional.HomeJobGuest = 0
    EndIf
EndFunction

Function TriggerRandomJobCD()
    RegisterForUpdateGameTime(0.5)
    TimeLastRandomJobCompleted = Utility.GetCurrentGameTime()
    HandlerConditional.RandomJobOnCD = 1
endFunction


Function ResetAllCD()
    HandlerConditional.FailJobOnCD = 0
    HandlerConditional.HomeJobOnCD = 0
    HandlerConditional.CampJobOnCD = 0
    HandlerConditional.RandomJobOnCD = 0
    UnregisterForUpdateGameTime()
endFunction


Event OnUpdateGameTime()
    float time = Utility.GetCurrentGameTime()

    if(TimeLastFailJob +  HandlerConfig.FailJobCD <= time)
    HandlerConditional.FailJobOnCD = 0
    endif
    if(TimeLastHomeJobCompleted + HandlerConfig.HomeJobCD <= time)
    HandlerConditional.HomeJobOnCD = 0
    endif
    if(TimeLastCampJobCompleted + HandlerConfig.CampJobCD <= time)
    HandlerConditional.CampJobOnCD = 0
    endif
    if(TimeLastRandomJobCompleted + HandlerConfig.RandomJobCD <= time)
    HandlerConditional.RandomJobOnCD = 0
    endif

    ;if all of them are off CD, stop receiving events
    if(HandlerConditional.FailJobOnCD == 0 && HandlerConditional.HomeJobOnCD == 0 && HandlerConditional.CampJobOnCD == 0 && HandlerConditional.RandomJobOnCD == 0)
    UnregisterForUpdateGameTime()
    endif
endEvent


Function SetMadame(Actor Madame, int rank)
    akPlayer = akPlayerRef.GetRef() as Actor
    Race pRace = akPlayer.GetActorBase().GetRace()
    if(HumanRace.HasForm(pRace))
        PlayerRace = 1
    elseif(ElfRace.HasForm(pRace))
        PlayerRace = 2
    elseif(BeastRace.HasForm(pRace))    
        PlayerRace = 4
    else
        PlayerRace = 8
    endif

    akMadame = Madame
    akMadame.SetFactionRank(MadameFaction, rank)
    akPlayer.SetFactionRank(MadameFaction, 0) ; just put the player in madame_faction such that we know by looking at ourselves that we are running a quest for a madame

    UndeclaredJobs.SetValue(0)
    ; ...
endFunction


Function Reset()
    akPlayer = akPlayerRef.GetRef() as Actor
    akPlayer.RemoveFromFaction(MadameFaction)
    if(akMadame != None)
     akMadame.SetFactionRank(MadameFaction, 0)
    endif
    ; WS edit - replacing foodjob with simplerjob
    ;FoodJob.Stop()
    SimplerJob.Stop()

    SingleJob.Stop()

    if(HomeJob)
        HomeJob.Stop()
    endif

    if(CampJob)
        CampJob.Stop()
    endif

    if(currentQuest)
        currentQuest.Stop()
    endif
    
    ResetAllCD()
endFunction


Function ResetMadame()
    int tc = TotalClients.GetValueInt()
    if(tc < HandlerConfig.ProstituteRank1)
        akPlayer.SetFactionRank(ProstituteFaction, 0)
    elseif(tc <  HandlerConfig.ProstituteRank2)
        akPlayer.SetFactionRank(ProstituteFaction, 1)
    elseif(tc <  HandlerConfig.ProstituteRank3)
        akPlayer.SetFactionRank(ProstituteFaction, 2)
    elseif(tc <  HandlerConfig.ProstituteRank4)
        akPlayer.SetFactionRank(ProstituteFaction, 3)
    elseif(tc <  HandlerConfig.ProstituteRank5)
        akPlayer.SetFactionRank(ProstituteFaction, 4)
    else
        akPlayer.SetFactionRank(ProstituteFaction, 5)
    endif

    int pr = akPlayer.GetFactionRank(ProstituteFaction)
    if(pr >= 1 && HandlerConditional.PlayerKnowsHomeJob != 1)
        HandlerConditional.PlayerLearnHomeJob = 1
    endif
    if(pr >= 2 && HandlerConditional.PlayerKnowsCampJob != 1)
        HandlerConditional.PlayerLearnCampJob = 1
    endif
    if(pr >= 3 && HandlerConditional.PlayerKnowsRandomJob != 1)
        HandlerConditional.PlayerLearnRandomJob = 1
    endif

    akMadame.SetFactionRank(MadameFaction, 0)
    akPlayer.RemoveFromFaction(MadameFaction)
endFunction

Function ResetFreeroam()
    singlejob.reset()
EndFunction

; ------------ QUEST KICKERS --------------
Function SimplerJobQuestKicker(Actor Madame)
    ; WS edit - replacing foodjob with simplerjob
    ;FoodJob.Start()
    ;FoodJob.setMadame(Madame)
    SimplerJob.Start()
    SetMadame(Madame, 1)
endFunction


Function SingleJobMonitorKicker(Actor Madame)
    SingleJob.Start()
    SingleJob.SetStage(0)
    SingleJob.ResetVariables()
    SetMadame(Madame, 2)
endFunction

Function SingleJobQuestKicker(Actor Client, bool once = false)  
    SingleJobScript.Start()
    SingleJobScript.SetOnce(once)
    SingleJobScript.ForceSpeakerClient(Client)
endFunction


Function SingleJobQuestKickerAndApproach(Actor Client)
    SingleJobQuestKicker(Client)
endFunction

Function HomeJobQuestKicker(Actor Madame)
    HomeJob = QuestKicker(HomeJobs,lastHomeJob)

    if(HomeJob)
        HomeJob.setMadame(Madame)
        SetMadame(Madame, 3)
    endif
    ;ResetArousal()
endFunction

Function CampJobQuestKicker(Actor Madame)
    CampJob = QuestKicker(CampJobs,lastCampJob)

    if(CampJob)
        CampJob.setMadame(Madame)
        SetMadame(Madame, 4)
    endif
endFunction

Function RandomJobQuestKicker(Actor Madame)
    currentQuest = QuestKicker(RandomQuests,lastRandomJob)
    
    if(currentQuest)
        currentQuest.setMadame(Madame)
        SetMadame(Madame, 5)
    endif
endFunction


; ------------- QUEST FAILURE --------------

; WS edit - adding functions for SimplerJob
Function SimplerJobQuestFail()
    ResetMadame()
    TriggerFailCD()
    SimplerJob.Stop()
endFunction

; WS edit - adding functions for SimplerJob
Function SimplerJobLeave()
    if(SimplerJob.GetStage() == 20 || SimplerJob.GetStage() == 30); food or gold
        Debug.Notification("You left the inn with the innkeeper's property")
        TriggerFailCD()
    
        ; consequence ??
        int amount = (100.0 * BountyMult) as int
        akMadame.GetCrimeFaction().ModCrimeGold(amount)
        Debug.Notification(amount+"gold bounty added")
        ModBountyMult(1)
    else
        Debug.Notification("You quitted serving food at the inn")
    endif

    ResetMadame()   
    SimplerJob.Stop() 
    SingleJob.Stop()
endFunction

Function SingleJobQuestFail()
    SingleJob.Stop()
endFunction


Function SingleJobLeave()
    if(UndeclaredJobs.GetValue() > 0)
        Debug.Notification("You left town with the innkeeper's gold")
        TriggerFailCD()

        ; consequence ??
        int amount =  (BountyMult * (UndeclaredJobs.GetValueInt() * HandlerConfig.BaseGoldPerClient * HandlerConfig.BaseGoldMadameCut * BountyMult) / 100.0) as int
        akMadame.GetCrimeFaction().ModCrimeGold(amount)
        Debug.Notification(amount+" gold bounty added")
        ModBountyMult(1)
    else
        Debug.Notification("You left the prostitution job behind you")
    endif

    ResetMadame()
    UndeclaredJobs.SetValue(0)
    SingleJob.CompleteAllObjectives()
    SingleJob.StopFollow()
    SingleJob.Stop()
endFunction


Function HomeJobQuestFail()
    HomeJob.FailAllObjectives()
    HomeJob.SetStage(201)   ;to get the quest fail message
    EndHomeJob()            ;this will ensure the homeJob CD is triggered, and that the quest's shutdown stage is called, and also calls ResetMadame()
endFunction


Function CampJobQuestFail()
    CampJob.FailAllObjectives()
    CampJob.SetStage(201)   ;to get the fail message
    endCampJob()
endFunction


Function RandomJobQuestFail()
    ResetMadame()
    TriggerRandomJobCD()
    currentQuest.FailAllObjectives()
    currentQuest.setStage(200)
    currentQuest.Stop()
    currentQuest = None
endFunction

;
; ---------- FOOD JOB REWARD - WS added
;
Function GetSimplerJobReward(bool success = true)
    if(success)
        SimplerJobScript.GetTip()
    endif
    ResetMadame() 
    SimplerJob.Stop()
endFunction

;
; ----------- SINGLE JOB REWARD -------------
;
Function GetSingleJobReward(int lie)
    int amount

    if (lie == 0)
        amount =  Math.Floor(totalReward * HandlerConfig.BaseGoldMadameCut / 100)
        ModBountyMult(UndeclaredJobs.GetValueInt() * (-1))
    elseif (lie == 1) 
        amount =  Math.Floor(totalReward * HandlerConfig.BaseGoldMadameCut / 1000)
    elseif (lie > 1)
        amount = Math.Floor(totalReward * HandlerConfig.BaseGoldMadameCut / 33)
        akMadame.GetCrimeFaction().ModCrimeGold(Math.floor(amount * BountyMult))
        Debug.Notification("The innkeeper put a bounty on my head, I'll have to sort that out with the guards")
        ModBountyMult(1)
        TriggerFailCD()
        amount = 0
    endif
    
    totalReward = 0;

    if(amount != 0)
        int goldCount = Game.GetPlayer().GetItemCount(Gold)
        if(goldCount < amount)
            amount -= goldCount
            MissingMoney.mod(amount)
            UpdateCurrentInstanceGlobal(MissingMoney) 
            amount = goldCount
        endIf
        akMadame.AddItem(Gold, amount)
        akPlayer.RemoveItem(Gold,  amount)
    endif

    ResetMadame()
    UndeclaredJobs.SetValue(0)
    SingleJobMonitor.Stop()
    SingleJob.UnregisterForUpdate()
    SingleJob.Stop()
    
    ;Finish misc quest for learning about prostitution if present
    If IsObjectiveDisplayed(10)
        SetObjectiveCompleted(10)
    EndIf
endFunction


int Function CalcReward(float QM = 1.0, float PERF = 1.0, string Type = "All",int repetitions=1)
    float BG = HandlerConfig.BaseGoldPerClient ; base cost
    float SM = akPlayer.GetAV("Speechcraft") * HandlerConfig.GoldBonusPerSpeechcraft ; speechcraft modifier
    float FM = akPlayer.GetFactionRank(ProstituteFaction) * HandlerConfig.GoldBonusPerRank ; faction reputation modifier
    float GM = 0.0

    if(Game.GetPlayer().GetActorBase().GetSex() == 1)
        GM = HandlerConfig.FemaleGoldBonus
    else
        GM = HandlerConfig.MaleGoldBonus
    endif

    float MOD
    float PM
    if(Type == "Oral" || Type == "Blowjob" || Type == "Cunnilingus")
        MOD = HandlerConfig.OralModifier
        PM =  HandlerConfig.GoldBonusPerSexRank * SexLab.GetPlayerStatLevel("Oral") 
    elseif(Type == "Anal")
        MOD = HandlerConfig.AnalModifier
        PM =  HandlerConfig.GoldBonusPerSexRank * SexLab.GetPlayerStatLevel("Anal") 
    elseif(Type == "Vaginal")
        MOD = HandlerConfig.VaginalModifier
        PM =  HandlerConfig.GoldBonusPerSexRank * SexLab.GetPlayerStatLevel("Vaginal") 
    elseif(Type == "Rape")
        MOD = HandlerConfig.RapeModifier
        PM =  HandlerConfig.GoldBonusPerSexRank * SexLab.GetPlayerStatLevel("Victim") 
    elseIf(Type == "Lesbian")
        MOD = HandlerConfig.VaginalModifier
        PM =  HandlerConfig.GoldBonusPerSexRank * SexLab.GetPlayerStatLevel("Vaginal") 
    else
        MOD = 1.0 ; overall quest modifier
        PM =   HandlerConfig.GoldBonusPerSexRank * (SexLab.GetPlayerStatLevel("Anal") + SexLab.GetPlayerStatLevel("Vaginal") + SexLab.GetPlayerStatLevel("Oral"))/3
    endif

    MOD *= PERF * QM
    
    Float OrgasmMod = 1.0
    
    if handlerConditional.ClientSatisfaction == 3
        OrgasmMod = 1.0
    elseif handlerConditional.ClientSatisfaction == 2
        OrgasmMod = 0.75
    elseif handlerConditional.ClientSatisfaction == 1
        OrgasmMod = 0.5
    elseif handlerConditional.ClientSatisfaction == 0
        OrgasmMod = 0.0
    Endif

    int payment = Math.Floor(((BG + SM + FM + PM + GM) * MOD) * OrgasmMod)

    if(repetitions > 1)
        int multipleBonus=  Math.Floor(payment * (repetitions - 1) * HandlerConfig.MultipleBonus)
        payment = payment + multipleBonus
    endif

    return  payment
endFunction

;
; ----------- HOME JOB REWARD -------------
;
Function GetHomeJobReward()
    float PERF = HandlerConditional.PerformanceRewardMod
    float QM = 3.0 * HandlerConfig.HomeDeliveryQuestModifier

    akPlayer.AddItem(Gold, CalcReward(QM, PERF))
    HomeJob.CompleteAllObjectives()
    EndHomeJob()
endFunction

Function EndHomeJob()
    HomeJob.Stop()
    ModBountyMult(-2)
    ResetMadame()   
    TriggerHomeJobCD()
endFunction

;
; ----------- CAMP JOB REWARD -------------
;
Function GetCampJobReward()
    float PERF = (CampJob as mf_CampJobQuestScript).GetModifier() ; overall quest modifier
    float QM = 0.75 * HandlerConfig.CampJobQuestModifier

    ModBountyMult(-PERF as int)
    
    akPlayer.AddItem(Gold, CalcReward(QM, PERF))
    CampJob.CompleteAllObjectives()
    endCampJob()
endFunction

Function endCampJob()
    ResetMadame()   
    TriggerCampJobCD()
    CampJob.stop()
endFunction
;
; ----------- RANDOM JOB REWARD -------------
;
Function GetRandomJobReward()
    ModBountyMult(-5)
    ResetMadame()   
    TriggerRandomJobCD()
    currentQuest.Stop()
    currentQuest = None
    HandlerConditional.GrantExtraReward = false;
endFunction

Function GetRandomJobExtraReward()
    ModBountyMult(-5)
    ResetMadame()   
    TriggerRandomJobCD()
    (currentQuest as MF_RandomQuest).getExtraReward()
    currentQuest.Stop()
    currentQuest = None
    HandlerConditional.GrantExtraReward = false;
endFunction

;
; ----------- REWARD FROM CLIENT -------------
;
Function GetRewardSingleFromClient(Actor akClient, int repetitions=0, int jobNumeric = -1)
    float PERF = HandlerConditional.PerformanceRewardMod
    float QM = 1.0

    string jobType= akJobType
    if(jobNumeric == 1)
        jobType= "Oral"
    elseif(jobNumeric == 2)
        jobType= "Anal"
    elseif(jobNumeric == 3)
        jobType= "Vaginal"
    elseif(jobNumeric == 4)
        jobType= "Things"
    elseif(jobNumeric == 5)
        jobType= "Rape"
    elseif(jobNumeric == 6)
        jobType= "Masturbation"
    elseif(jobNumeric == 7)
        jobType= "Lesbian"
    endIf
    
    if(repetitions > 0)
        int reward = CalcReward(QM, PERF, jobType,repetitions)
        totalReward += reward
        akPlayer.AddItem(Gold, reward)
        int t = UndeclaredJobs.GetValueInt() + 1
        UndeclaredJobs.SetValue(t)
        UpdateCurrentInstanceGlobal(UndeclaredJobs)
    endif
endFunction



event EvaluateSex(string eventName, string argString, float argNum, form sender)
    if handlerConditional.NoSLSO != 1
        evaluateClientOrgasm()
        if HandlerConditional.GuestOrgasmActor != None
            evaluateGuestOrgasm()
        endif
    else
        handlerConditional.ClientSatisfaction = 3   
    Endif
    CalcRewardMod(argString)
    ; Debug.Notification("Sex lasted " + sexLasted + " sec")
    UnregisterForModEvent("AnimationEnd_GetTime") 
endEvent

Function CalcRewardMod(string argString)
    float sexLasted = SexLab.HookTime(argString)
    
    if(sexLasted > HandlerConfig.TimeForFullReward)
        HandlerConditional.PerformanceRewardMod = 1.0
    else
        HandlerConditional.PerformanceRewardMod = sexLasted / HandlerConfig.TimeForFullReward
    endif
endFunction

;----AROUSAL INTEGRATION

Function StripExposure(Actor akClient, int exp)
    sla.UpdateActorExposure(akClient, exp)
EndFunction

Function setClientOrgasmActor(Actor akClient)
    handlerConditional.ClientOrgasmActor = akClient
EndFunction

Function setGuestOrgasmActor(Actor akGuest)
    handlerConditional.GuestOrgasmActor = akGuest
EndFunction

Float Function getLastOrgasm(Actor akActor)
    Float lastOrgasmDate = StorageUtil.GetFloatValue(akActor, "SLAroused.LastOrgasmDate", Missing = 0.0)
    Return Utility.GetCurrentGameTime() - lastOrgasmDate
EndFunction

Function evaluateClientOrgasm()
    handlerConditional.finalClientOrgasm = getLastOrgasm(handlerConditional.ClientOrgasmActor)
    if handlerConditional.finalClientOrgasm < (Utility.GetCurrentGameTime() - handlerConditional.SexStartTime)
        handlerConditional.ClientOrgasmOccurred = 1
        handlerConditional.OrgasmCount += 1
        Debug.Notification("Your Client came!")
        debug.notification("Orgasm count is " +handlerConditional.OrgasmCount)
    Else
        handlerConditional.ClientOrgasmOccurred = 0
        Debug.Notification("Your Client did not come.")
    endif
EndFunction

Function evaluateGuestOrgasm()
    handlerConditional.finalGuestOrgasm = getLastOrgasm(handlerConditional.GuestOrgasmActor)
    if handlerConditional.finalGuestOrgasm < (Utility.GetCurrentGameTime() - handlerConditional.SexStartTime)
        handlerConditional.GuestOrgasmOccurred = 1
        handlerConditional.OrgasmCount += 1
        Debug.Notification("Your second Client came!")
        debug.notification("Orgasm count is " +handlerConditional.OrgasmCount)
    Else
        handlerConditional.ClientOrgasmOccurred = 0
        Debug.Notification("Your second Client did not come.")
    endif
EndFunction

Function evaluatePlayerOrgasm()
    handlerConditional.finalPlayerOrgasm = getLastOrgasm(akPlayer)
    if handlerConditional.finalPlayerOrgasm < (Utility.GetCurrentGameTime() - handlerConditional.SexStartTime)
        handlerConditional.PlayerOrgasmOccurred = 1
        handlerConditional.OrgasmCount += 1
        Debug.Notification("You came!")
        debug.notification("Orgasm count is " +handlerConditional.OrgasmCount)
    Else
        handlerConditional.ClientOrgasmOccurred = 0
        Debug.Notification("You did not come.")
    endif
EndFunction

Function ResetArousal()
    handlerConditional.ClientOrgasmActor = None
    handlerConditional.GuestOrgasmActor = None
    handlerConditional.NoSLSO = 0
    handlerConditional.OrgasmCount = 0
    handlerConditional.ClientSatisfaction = 0
EndFunction

Function ResetCampJobActors()
    handlerConditional.ClientOrgasmActor = None
    handlerConditional.GuestOrgasmActor = None
EndFunction

Function SingleHomeClientSatisfaction()
    if handlerConditional.OrgasmCount == 0
        handlerConditional.ClientSatisfaction = 0
    ElseIf handlerConditional.OrgasmCount == 1 
        handlerConditional.ClientSatisfaction = 2
    ElseIf handlerConditional.OrgasmCount >= 2
        handlerConditional.ClientSatisfaction = 3
    EndIf
    debug.notification("Client satisfaction is "+handlerConditional.ClientSatisfaction)
Endfunction 

Function MultipleHomeClientSatisfaction()
    if handlerConditional.OrgasmCount == 0
        handlerConditional.ClientSatisfaction = 0
    ElseIf handlerConditional.OrgasmCount <= 2 
        handlerConditional.ClientSatisfaction = 1
    ElseIf handlerConditional.OrgasmCount == 3
        handlerConditional.ClientSatisfaction = 2
    Elseif handlerConditional.OrgasmCount >= 4
        handlerConditional.ClientSatisfaction =3
    EndIf
    debug.notification("Client satisfaction is "+handlerConditional.ClientSatisfaction)
EndFunction

int Function CampJobSatisfaction(Int n)
    if handlerConditional.OrgasmCount == 0
        handlerConditional.ClientSatisfaction = 0
    ElseIf handlerConditional.OrgasmCount == n - 2
        handlerConditional.ClientSatisfaction = 1
    ElseIf handlerConditional.OrgasmCount == n - 1
        handlerConditional.ClientSatisfaction = 2
    ElseIf handlerConditional.OrgasmCount == n
        handlerConditional.ClientSatisfaction = 3
    Endif
    
    debug.notification("The Camp Commanders's satisfaction is " +handlerConditional.ClientSatisfaction)
EndFunction

Function NoSLSOSatisfaction()
    handlerConditional.NoSLSO = 1
    debug.notification("This quest is not compatible with Aroused / SLSO.")
EndFunction
    
Function IncrementTotalClients(int c)
    int t = TotalClients.GetValueInt()
    TotalClients.SetValue(ValidateStatInt("Client Count", t, c))
    UpdateCurrentInstanceGlobal(TotalClients)
endFunction


Function SetRefractory(Actor Client, bool satisfied=true)
    if(satisfied)
        RefractoryS.Cast(Client, Client)
    else
        RefractoryD.Cast(Client, Client)
    endIf
endFunction


sslThreadController Function PerformSex(Actor akClient, string type, string aggr = "None", string next = "None",bool isPlayerVictim=false, bool foreplay=false, bool switchOnFF =false)

    sslBaseAnimation[] anims

    actor[] actors = new actor[2]
    int playerIndex =0
    actors[0] = akPlayer
    actors[1] = akClient
    
        
    int sex0 = actors[0].GetActorBase().GetSex()
    int sex1 = actors[1].GetLeveledActorBase().GetSex() 

    int f  = sex0 + sex1
    int m = 2 - f

    string option = ""
    string suppress ="Aggressive"
    if(aggr != "None" || isPlayerVictim)
        option = ",Aggressive"
        suppress =""
    endif

    ; sort the player/client depending on the anim type that will be chosen
    if(f == 2); FF
        option = ""
        suppress ="Aggressive"
        if(type == "Oral" && !switchOnFF)
            actors[0] = akClient
            actors[1] = akPlayer
            playerIndex=1
        elseif(switchOnFF)
            actors[0] = akClient
            actors[1] = akPlayer
            playerIndex=1
        endif
        
        ;ws edit - searching by "FF,<type>" when type=oral removes a lot of valid cunnilingus animations - search for tag cunnilingus instead, with 69 suppress 
        if type == "Oral"
            anims = SexLab.GetAnimationsByTags(2, "Cunnilingus", "69", requireAll=true)
        Else
            ;if type isn't Oral, then use the code that was already here
            anims = SexLab.GetAnimationsByTags(2, "Lesbian,"+ type+ option,suppress, requireAll=true)
        EndIf

        if(anims.Length == 0)
            anims = SexLab.GetAnimationsByTags(2, "MF,"+ type+ option,suppress, requireAll=true)
        endif
    elseif(f == 1);FM || MF
        if(sex0 == 0) ;PC is male
            actors[0] = akClient
            actors[1] = akPlayer
            playerIndex=1
        endif
        anims = SexLab.GetAnimationsByTags(2, "MF,"+ type+ option,suppress+",69", requireAll=true)
    else; MM
        anims = SexLab.GetAnimationsByTags(2, "MM,"+ type+ option,suppress, requireAll=true)
        if(anims.Length == 0)
            anims = SexLab.GetAnimationsByTags(2, "MF,"+ type+ option,suppress, requireAll=true)
        endif
    endif


    if(anims.Length == 0)
        Debug.Notification("You've blacklisted all consensual "+type+" sex anims. This won't work.")
        anims = SexLab.GetAnimationsByTags(2,"Sex")
    endif

    SetRefractory(akClient)

    return fuck(actors,playerIndex,anims,foreplay,next,type,isPlayerVictim).StartThread()
    
endFunction

sslThreadModel Function fuck(Actor[] actors, int playerIndex, sslBaseAnimation[] anims, bool foreplay = true, string next = "None",string type = "None", bool isPlayerVictim = false)

    HandlerConditional.SexStartTime = Utility.GetCurrentGameTime()
    
    akJobType = type
    IncrementTotalClients(1)

    bool[] equip0 = New bool[33]
    bool[] equip1 = New bool[33]
    int i=0
    While(i < 33)
        equip0[i] = false
        equip1[i] = false
        i += 1
    endWhile

    if(type == "Oral")
        equip0[0] = true ;head
        equip0[3] = true ;hand
        equip0[4] = true ;forearms
        equip0[9] = true ;shield
        equip0[14] = true ;face
        equip0[32] = true ;weapon

        equip1[2] = true ;body
        equip1[9] = true ;shield
        equip1[16] = true ;chest
        equip1[19] = true ;pelvis
        equip1[28] = true ;undergarment
        equip1[32] = true ;weapon   
    else
        equip0[2] = true ;body
        equip0[9] = true ;shield
        equip0[16] = true ;chest
        equip0[19] = true ;pelvis
        equip0[28] = true ;undergarment
        equip0[32] = true ;weapon   

        equip1[2] = true ;body
        equip1[9] = true ;shield
        equip1[16] = true ;chest
        equip1[19] = true ;pelvis
        equip1[28] = true ;undergarment
        equip1[32] = true ;weapon   
    endif

    RegisterForModEvent("AnimationEnd_GetTime", "EvaluateSex")
    While (SexLab.FindActorController(actors[0]) != -1 || SexLab.FindActorController(actors[1]) != -1)
        Utility.Wait(1.0)
    endwhile

    sslThreadModel th = SexLab.NewThread()
    if(actors.length == 2)
        if(playerIndex == 1)
            th.AddActor(actors[0])
            th.AddActor(actors[1], isVictim= isPlayerVictim)
            if(HandlerConfig.PlayerMinimalStripping)
                th.SetStrip(actors[1], equip0)
            endif
            if(HandlerConfig.ClientMinimalStripping)
                th.SetStrip(actors[0], equip1)
            endif
        else
            th.AddActor(actors[0], isVictim= isPlayerVictim)
            th.AddActor(actors[1])

            if(HandlerConfig.PlayerMinimalStripping)
                th.SetStrip(actors[0], equip0)
            endif
            if(HandlerConfig.ClientMinimalStripping)
                th.SetStrip(actors[1], equip1)
            endif
        endif
    elseif(actors.length == 3)
        if(playerIndex == 0)
            th.AddActor(actors[0], isVictim= isPlayerVictim)
            th.AddActor(actors[1])
            th.AddActor(actors[2])

            if(HandlerConfig.PlayerMinimalStripping)
                th.SetStrip(actors[0], equip0)
            endif
            if(HandlerConfig.ClientMinimalStripping)
                th.SetStrip(actors[1], equip1)
                th.SetStrip(actors[2], equip1)
            endif
        elseif(playerIndex == 1)
            th.AddActor(actors[0])
            th.AddActor(actors[1], isVictim= isPlayerVictim)
            th.AddActor(actors[2])
            if(HandlerConfig.PlayerMinimalStripping)
                th.SetStrip(actors[1], equip0)
            endif
            if(HandlerConfig.ClientMinimalStripping)
                th.SetStrip(actors[0], equip1)
                th.SetStrip(actors[2], equip1)
            endif
        elseif(playerIndex == 2)
            th.AddActor(actors[0])
            th.AddActor(actors[1])
            th.AddActor(actors[2], isVictim= isPlayerVictim)

            if(HandlerConfig.PlayerMinimalStripping)
                th.SetStrip(actors[2], equip0)
            endif
            if(HandlerConfig.ClientMinimalStripping)
                th.SetStrip(actors[0], equip1)
                th.SetStrip(actors[1], equip1)
            endif
        endif
    endIf
    th.SetAnimations(anims)
    if(isPlayerVictim)
        th.DisableLeadIn(true) 
    else
        th.DisableLeadIn(!foreplay) 
    endif
    ;Bed Search is Disabled if a CenterObject is set
    ;if(!HandlerConfig.UseBeds)    ;ws - commented out - this might be what's causing issues with the automatic free cam (edit: it was!)
    ;   th.CenterOnObject(actors[playerIndex])
    ;endIf
    ;WS - restoring UseBeds MCM function
    If(!HandlerConfig.UseBeds) 
        th.DisableBedUse(true)
    EndIf
    th.SetHook("GetTime")
    if(next != "None")
        th.SetHook(next)
    endif
    return th

endFunction


sslThreadController Function PerformCreatureSex(Actor[] creatures, string next = "None")
    sslThreadModel th = SexLab.NewThread()
    th.AddActor(akPlayer, isVictim=true)
    int count = 0
    while count < creatures.length
        th.AddActor(creatures[count])
        count= count+1
    endWhile

    if(next != "None")
        th.SetHook(next)
    endif
    th.CenterOnObject(akPlayer)
    return th.StartThread() 
endFunction

sslThreadController Function PerformThreesome(Actor akClient, Actor akGuest, string next = "None", bool isPlayerVictim =false)
     IncrementTotalClients(2)
     SetRefractory(akClient)
     SetRefractory(akGuest)
     
     HandlerConditional.SexStartTime = Utility.GetCurrentGameTime()

     sslBaseAnimation[] anims
     actor[] actors = new actor[3]
     int playerIndex =0
     actors[0] = akPlayer
     actors[1] = akClient
     actors[2] = akGuest

     int sex0 = Game.GetPlayer().GetActorBase().GetSex()
     int sex1 = akClient.GetLeveledActorBase().GetSex() 
     int sex2 = akGuest.GetLeveledActorBase().GetSex() 
     
     int c = 1
     sslBaseAnimation[] anims2
     
     int f  = sex0 + sex1 + sex2
     int m = 3 - f

     if(sex0 == 1) ; female PC
        if(sex1 == 1); female NPC
            if(sex2 == 1); FFF
                actors[0] = akGuest
                actors[1] = akPlayer
                actors[2] = akClient
                playerIndex =1
                anims = SexLab.GetAnimationsByTags(3, "FFF")
                if(anims.length ==0)
                    anims  = SexLab.GetAnimationsByTag(3, "Sex")
                endif
            else; male NPC
                if (sex2 == 0); FFM
                    actors[0] = akClient
                    actors[1] = akPlayer
                    actors[2] = akGuest
                    playerIndex =1
                    anims = SexLab.GetAnimationsByTags(3, "MFF")
                else ;FMM
                anims = SexLab.GetAnimationsByTags(3, "MMF")
                endif
            endif
        else; male NPC
            if(sex1 == 0)
                if(sex2 == 1) ; FMF
                    actors[0] = akGuest
                    actors[1] = akPlayer
                    actors[2] = akClient
                    playerIndex =1
                    anims = SexLab.GetAnimationsByTags(3, "MFF")
                Else ;FMM
                    anims = SexLab.GetAnimationsByTags(3, "MMF")
                EndIf
            endif
        endif
     else; male PC
        if(sex1 == 1)
            if(sex2 == 1); MFF
                actors[0] = akGuest
                actors[2] = akPlayer
                playerIndex =2
                anims = SexLab.GetAnimationsByTags(3, "MFF")
            else ; MFM
                anims = SexLab.GetAnimationsByTags(3, "MFF")
            endif
        else
            if(sex2 == 1) ; MMF
                actors[1] = akGuest
                actors[2] = akClient
            
                anims = SexLab.GetAnimationsByTags(3, "MFF")
            else ;MMM
                anims  = SexLab.GetAnimationsByTags(3, "MMF") ;player in female position
            endif
        endif 
     endif
     
     if(anims.Length == 0)
        Debug.Notification("You've blacklisted all threesome sex anims. This won't work.")
        if(c == 1)
            anims = SexLab.GetAnimationsByTags(3,"Sex")
        else
            anims = SexLab.GetAnimationsByTags(2,"Sex")
            anims2 = SexLab.GetAnimationsByTags(1,"Sex")
        endif
     endif
        RegisterForModEvent("AnimationEnd_GetTime", "EvaluateSex")
        While (SexLab.FindActorController(actors[0]) != -1 ||SexLab.FindActorController(actors[1]) != -1 || SexLab.FindActorController(actors[2]) != -1)
            Utility.Wait(1.0)
        endwhile
        if(c == 1)
            sslThreadModel th = SexLab.NewThread()
            if(playerIndex ==0) 
                th.AddActor(actors[0],isVictim = isPlayerVictim)
                th.AddActor(actors[1])
                th.AddActor(actors[2])
            elseif(playerIndex ==1)
                th.AddActor(actors[0])
                th.AddActor(actors[1],isVictim = isPlayerVictim)
                th.AddActor(actors[2])
            else
                th.AddActor(actors[0])
                th.AddActor(actors[1])
                th.AddActor(actors[2],isVictim = isPlayerVictim)
            endif
            th.SetAnimations(anims)
            th.DisableLeadIn(isPlayerVictim) 
            th.SetHook("GetTime")
            if(next != "None")
                th.SetHook(next)
            endif
            return th.StartThread()
        else
            sslThreadModel th2 = SexLab.NewThread()
            th2.AddActor(actors[1])
            th2.SetAnimations(anims2)
            th2.DisableLeadIn(true) 
            th2.StartThread()   
        
            sslThreadModel th1 = SexLab.NewThread()
            if(playerIndex ==0) 
                th1.AddActor(actors[0],isVictim = isPlayerVictim)
                th1.AddActor(actors[2])
            else
                th1.AddActor(actors[0])
                th1.AddActor(actors[2],isVictim = isPlayerVictim)
            endif
            th1.SetAnimations(anims)
            th1.DisableLeadIn(true) 
            th1.SetHook("GetTime")
            if(next != "None")
                th1.SetHook(next)
            endif
            return th1.StartThread()
        endif
endFunction


sslThreadController Function PerformMasturbation(Actor akSoloer, string next = "None")
 int sex = akSoloer.GetLeveledActorBase().GetSex() 

 HandlerConditional.SexStartTime = Utility.GetCurrentGameTime()
    
 akJobType = "Masturbation"
 sslBaseAnimation[] anims
 if(sex == 0)
    anims = SexLab.GetAnimationsByTag(1, "M", akJobType,  requireAll=true)  
    ;anims = SexLab.GetAnimationsByTag(1, "M", akJobType, tagSuppress="Zaz", requireAll=true)
 else
    anims = SexLab.GetAnimationsByTag(1, "F", akJobType, requireAll=true)
    ;anims = SexLab.GetAnimationsByTag(1, "F", akJobType, tagSuppress="Zaz", requireAll=true)
 endif 
 
 if(anims.Length == 0)
    Debug.Notification("You've blacklisted all consensual "+akJobType+" sex anims. This won't work.")
    return None
 else
    While (SexLab.FindActorController(akSoloer) != -1 )
        Utility.Wait(1.0)
    endwhile
    sslThreadModel th = SexLab.NewThread()
    th.AddActor(akSoloer)
    th.SetAnimations(anims)
    th.DisableLeadIn(true)
    if(next != "None")
        th.SetHook(next)
    endif
    return th.StartThread()
 endif
endFunction

Function PerformDance()

endFunction

Function FadeToBlack()
    akPlayer.SetRestrained(true)    
    FadeOut.Apply()
    Utility.Wait(2.5) ; since Fadeout lasts exactly 3.0s, we need to allow some script delay
    FadeOut.PopTo(BlackScreen)
endFunction

Function FadeFromBlack()
    BlackScreen.PopTo(FadeIn)   
    Utility.Wait(2.0)       
    FadeIn.Remove()     
    akPlayer.SetRestrained(false)
endFunction

MF_RandomQuest Function QuestKicker(FormList quests,int lastIndex)

    Debug.Trace("[Radiant Prostitution] try to start a quest from list " + quests.GetName())
    Debug.Trace("[Radiant Prostitution] last Index was " + lastIndex)

    MF_RandomQuest questToStart = randomQuest(quests, lastIndex)

    Debug.Trace("[Radiant Prostitution] Try to start Quest " + questToStart)

    int try1 = 0
    While(!questToStart.IsRunning() && try1 < 5)
        int try2 = 0
        Debug.Trace("[Radiant Prostitution] Are Preconditions fullfilled ? " + (questToStart.checkConditions()))
        if(questToStart.checkConditions())
            questToStart.Start() 
            Utility.wait(0.5)
            While(!questToStart.IsRunning() && try2 < 5)
                Debug.Trace("[Radiant Prostitution] Quest not started Retry "+ try2)
                questToStart.Start()
                try2 += 1
                Utility.wait(0.5)
            endWhile
        endIf
        if(!questToStart.IsRunning())
            Debug.Trace("[Radiant Prostitution] Quest did not start get a new one")
            questToStart = randomQuest(quests, lastIndex)
            Debug.Trace("[Radiant Prostitution] New Quest is "+ questToStart)
            questToStart.Start() 
            try1 += 1
        endIf
    endWhile

    if(questToStart.IsRunning())
        Debug.Trace("[Radiant Prostitution] Quest started")
        return questToStart
    endif
    
    Debug.Trace("[Radiant Prostitution] no Quest Could be started")
    Debug.Notification("No quest was started. Please try again.")
    return none
endFunction

MF_RandomQuest Function randomQuest(FormList quests, int lastIndex)

    int listSize = quests.GetSize()
    
    if(listSize <= 0)
        ErrorMessage.show()
    endIf

    ; WS - commented out, this method of picking a quest confuses me and seems to cause predictable repetition even after the first round
    ;lastIndex = lastIndex + Utility.RandomInt(1, Math.ceiling(listSize / 2))
    ;while(lastIndex > listSize - 1)
    ;   lastIndex = lastIndex - (listSize - 1)
    ;endWhile
    
    
    ; WS - instead of the above whatever-the-hell-that-is, all we want is ensure that a random quest isn't given twice in a row, if there are more than 2 choices
    ; note: the WHILE needs to check if listSize is larger than one, so we don't get stuck if the list only has 1 quest
    ; and if the listSize is 2, we need to do RandomInt(0,1) instead, otherwise it'll always alternate between one and the other with no randomness
    int newIndex = lastIndex
    if listSize == 2
        newIndex = Utility.RandomInt(0,1)
    Else
        While ( (newIndex == lastIndex) && (listSize > 1) )
            newIndex = Utility.RandomInt(0, (listSize - 1))
        EndWhile
    EndIf

    Debug.Trace("MF_RP TRACE : FINAL INDEX IS " + newIndex + " (" + quests.GetAt(newIndex) + ")")
    MF_RandomQuest questToStart = quests.GetAt(newIndex) as MF_RandomQuest

    if(questToStart.getRank() == 1)
        lastHomeJob = newIndex
    elseif(questToStart.getRank() == 2)
        lastCampJob = newIndex
    elseif(questToStart.getRank() >= 3)
        lastRandomJob = newIndex
    endIf

    return questToStart
endFunction


Function loadFrostfall()
    isFrostfallLoaded = false
    int Mods = Game.GetModCount()
    int i
    While i < Mods
        string Modname = Game.GetModName(i)
        If !isFrostfallLoaded && Modname == "Chesko_Frostfall.esp"
            isFrostfallLoaded = true
            Frostfall_exposurePoints = Game.GetFormFromFile(0x00000183d, "chesko_frostfall.esp") as GlobalVariable
            return
        EndIf
        i += 1
    EndWhile
EndFunction


Function frostfallWarmPlayer()
    if (isFrostfallLoaded)
        Frostfall_exposurePoints.SetValue(120)
    Else
        loadFrostfall()
        If (isFrostfallLoaded)
            Frostfall_exposurePoints.SetValue(120)
        EndIf
    EndIf
EndFunction


