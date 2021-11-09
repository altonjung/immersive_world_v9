Scriptname mf_Handler_Config extends SKI_ConfigBase  

Quest Property NPCScene1 Auto
Quest Property NPCScene2 Auto
Quest Property NPCScene3 Auto
mf_Handler Property Handler Auto
mf_GettingStuffQuestScript Property StuffBack Auto
mf_SolicitVariables Property NPCWhore Auto
mf_Variables Property QuestConditional Auto
mf_simplejobquestscript Property simplejob Auto
FormList Property WorkingClothes  Auto  

bool Property PlayerMinimalStripping = false Auto
bool Property ClientMinimalStripping = false Auto
bool Property UseBeds = false Auto

int Property ProstituteRank1 = 10 Auto 
int Property ProstituteRank2 = 25 Auto 
int Property ProstituteRank3 = 35 Auto 
int Property ProstituteRank4 = 45 Auto 
int Property ProstituteRank5 = 60 Auto 

float Property TimeForFullReward = 90.0 Auto 
float Property BaseGoldPerClient = 40.0 Auto 
float Property BaseGoldMadameCut = 50.0 Auto
float Property FemaleGoldBonus = 10.0 Auto 
float Property MaleGoldBonus = 0.0 Auto 
float Property GoldBonusPerRank = 5.0 Auto 
float Property GoldBonusPerSpeechcraft = 0.5 Auto 
float Property GoldBonusPerSexRank = 10.0 Auto 
float Property TipModifier = 1.0 Auto
float Property OralModifier = 1.0 Auto 
float Property AnalModifier = 1.5 Auto 
float Property VaginalModifier = 2.5 Auto 
float Property RapeModifier = 1.75 Auto 
float Property MultipleBonus = 1.00 Auto
float Property MaxRepetitions = 0.00 Auto

float Property BountyDownRate = 0.1 Auto
float Property BountyUpRate = 1.0 Auto
float Property MaxBountyMult = 10.0 Auto

bool Property RestrictToTown = true Auto
float Property FailJobCD = 0.125 Auto

float Property HomeJobCD = 0.125 Auto
float Property HomeDeliveryQuestModifier = 1.0 Auto 
int Property HomeDeliveryGuestChance = 50 Auto

float Property CampJobCD = 1.0 Auto
float Property CampJobQuestModifier = 1.0 Auto 
float Property CampJobExpireTime = 0.125 Auto
int Property CampJobTargetClient = 5 Auto

float Property RandomJobCD = 0.5 Auto
int Property GearCostForTheft = 100 Auto
int Property ItemCostForTheft = 10 Auto
float Property PercGoldTheft = 100.0 Auto
int Property RandomJobReward = 500 Auto

float Property TimeToPayStuff = 1.0 Auto

float Property NPCBaseGoldCost = 50.0 Auto

float Property MeterPerUnit = 0.01428 Auto
GlobalVariable Property AggroDistance Auto
float Property ScanInterval = 25.0 Auto
float Property OveralModifier = 1.0 Auto

int Property HEChance = 0 Auto
int Property HBChance = 0 Auto
int Property EBChance = 0 Auto

int Property MFApproachFreq = 100 Auto
int Property FFApproachFreq = 25 Auto
int Property MMApproachFreq = 50 Auto
int Property FMApproachFreq = 50 Auto

GlobalVariable Property MFChance Auto
GlobalVariable Property FFChance Auto
GlobalVariable Property MMChance Auto
GlobalVariable Property FMChance Auto
GlobalVariable Property TotalClients Auto

;----------- Rank Variables ID ------------
int rankStride = 5
int idPMS
int idCMS
int idUB  
int idPRS
;----------- Reward Variables ID ----------

int idTC
int idTFFR
int idBGPC
int idBGMC
int idFGB
int idMGB
int idGBPR
int idGBPS
int idGBPX
Int idTM
int idOM
int idAM
int idVM
int idRM
int idMB
int idMR

int idBDR
int idBUR
int idMBM
;------------- Quest Variables ID --------

int idGAA
int idSM
int idRTT
int idAD
int idPSI
int idOPF
int idHEC
int idHBC
int idEBC
int idMFC
int idFFC
int idMMC
int idFMC

int idCQ
int idScanQuests
int idReset
int idSimplejob
int idFJCD
int idHJQM
int idHJCD
int idHDGC
int idCJCD
int idCJQM
int idCJET
int idCJTC

int idRJCD
int idGCFT
int idICFT
int idPGT
int idRJR

int idCheat
int idTTPS
;------------- NPC Event ID --------------

bool GuardAllowed = false
bool IsNPCActive = true
bool NPCSchedule = true

int idNPCActive
int idNPCSchedule
int idNPCBaseGold
int idScene

int idPanic1
int idPanic2

;------------- Working Clothes ID --------------
int idWC

event OnConfigInit()
    ModName = "Radiant Prostitution"
    Pages = new string[4]
    Pages[0] = "$PC Settings"
    Pages[1] = "$Quest Settings"
    Pages[2] = "$NPC Events"
    Pages[3] = "$Working clothes"
    initWorkingCloths()
    readQuestsFromDirectory()
endEvent

int function GetVersion()
    return 26
endFunction

bool reloadQuests = false

event OnVersionUpdate(int newVersion)

    if (newVersion >= 19 && CurrentVersion < 26)
        Pages = new string[4]
        Pages[0] = "$PC Settings"
        Pages[1] = "$Quest Settings"
        Pages[2] = "$NPC Events"
        Pages[3] = "$Working clothes"
    endIf

    if(reloadQuests)
        Debug.Notification("RPG - Reloading Quests")
        readQuestsFromDirectory()
    endIf
    Debug.Notification("Updating RPG finished")
endEvent

Function initWorkingCloths()
    int config = JValue.readFromFile("Data/MF_RP_Config.json")
    form ChestPiece = JValue.solveForm(config, ".startCloths.chestPiece")

    if(!WorkingClothes.HasForm(ChestPiece))
        WorkingClothes.AddForm(ChestPiece)
    endIf
    JValue.release(config)
endFunction

event OnPageReset(string pagename)
    if(pagename == "$PC Settings")
        buildPCSettingsPage()
    elseif(pagename == "$Quest Settings")
        buildQuestSettingsPage()
    elseif(pagename == "$NPC Events")
        buildNPCEventPage()
    elseif(pagename == "$Working clothes")
        buildWorkingClothsPage()
    else
        ;AddTextOption("Version:", "1.08b")
    endif
endEvent

Event OnOptionSelect(int option)
    if(option == idPanic1)
        SetTextOptionValue(idPanic1, "$Don't Panic")
    elseif(option == idPanic2)
        SetTextOptionValue(idPanic2, "$Don't Panic")
    elseif(option == idPMS)
        PlayerMinimalStripping = !PlayerMinimalStripping
        SetToggleOptionValue(idPMS, PlayerMinimalStripping)
    elseif(option == idUB)
        UseBeds = !UseBeds
        SetToggleOptionValue(idUB, UseBeds )
    elseif(option == idCMS)
        ClientMinimalStripping = !ClientMinimalStripping
        SetToggleOptionValue(idCMS, ClientMinimalStripping)
    elseif(option == idSM)
        if(QuestConditional.ActiveSolicit == 1 && QuestConditional.PassiveSolicit == 1)
            QuestConditional.ActiveSolicit = 0
            QuestConditional.PassiveSolicit = 1
            SetTextOptionValue(idSM, "$Passive")
        elseif(QuestConditional.ActiveSolicit == 0 && QuestConditional.PassiveSolicit == 1)
            QuestConditional.ActiveSolicit = 1
            QuestConditional.PassiveSolicit = 0
            SetTextOptionValue(idSM, "$Active")
        else
            QuestConditional.ActiveSolicit = 1
            QuestConditional.PassiveSolicit = 1
            SetTextOptionValue(idSM, "$Both")
        endif
    elseif(option == idGAA)
        GuardAllowed = !GuardAllowed 
        if(GuardAllowed)
            QuestConditional.GuardAllowed = 1
        else
            QuestConditional.GuardAllowed = 0
        endif
        SetToggleOptionValue(idGAA, GuardAllowed)           
    elseif(option == idRTT)
        RestrictToTown = !RestrictToTown
        SetToggleOptionValue(idRTT, RestrictToTown)
    elseif(option == idReset)
        Handler.Reset()
        SetTextOptionValue(idReset, "$Done")
    elseif(option == idSimplejob)
        handler.resetfreeroam()
        SetTextOptionValue(idSimplejob, "$Done")
    elseif(option == idScene)
        NPCScene1.Stop()
        NPCScene2.Stop()
        NPCScene3.Stop()
        SetTextOptionValue(idScene, "$Done")
    elseif(option == idCheat)
        StuffBack.ResetChests()
        SetTextOptionValue(idCheat, "$Done")
    elseif(option == idNPCActive)
        if(NPCWhore.WhoreActive == 0)
            NPCWhore.WhoreActive = 1
            IsNPCActive = true
        else
            NPCWhore.WhoreActive = 0
            IsNPCActive = false
        endif
        SetToggleOptionValue(idNPCActive, IsNPCActive)
    elseif(option == idNPCSchedule)
        NPCSchedule = !NPCSchedule 
        if(NPCSchedule)
            NPCWhore.BypassWhoreSchedule = 0
        else
            NPCWhore.BypassWhoreSchedule = 1
        endif
        SetToggleOptionValue(idNPCSchedule, NPCSchedule)
    elseif(option == idWC)
        Form armorForm = Game.GetPlayer().GetWornForm(0x00000004)
        if(!WorkingClothes.hasForm(armorForm))
            WorkingClothes.AddForm(armorForm)
            SetToggleOptionValue(idWC, true)
        else
            WorkingClothes.RemoveAddedForm(armorForm)
            SetToggleOptionValue(idWC, false)
        endIf
    elseif(option == idScanQuests)
        readQuestsFromDirectory()
    endif
endEvent

Function readQuestsFromDirectory()
    Debug.Notification("Scanning for Quests")
    Handler.RandomQuests.Revert()
    Handler.HomeJobs.Revert()
    Handler.CampJobs.Revert()
    int questsFiles = JValue.readFromDirectory("data/MF_RP_Quests")
    int questFilesNames = JMap.allKeys(questsFiles)
    int i = JArray.count(questFilesNames)
    while(i > 0)
        i -= 1
        string questFileName = JArray.getStr(questFilesNames,i)
        Debug.Notification("Reading File "+questFileName)
        int quests = JValue.solveObj(questsFiles,"."+questFileName)
        addQuestsToQuestList(quests)
        JValue.release(quests)
    endWhile
    JValue.release(questFilesNames)
    JValue.release(questsFiles)
    SetTextOptionValue(idCQ,(Handler.RandomQuests.GetSize() + Handler.CampJobs.GetSize()+Handler.HomeJobs.GetSize()))
    SetTextOptionValue(idScanQuests, "$Leave")
endFunction

Function addQuestsToQuestList(int quests)
    int i = JArray.Count(quests)
Debug.Notification("Adding "+i+" Quests")
    while(i > 0)
        i -= 1
        MF_RandomQuest QuestForm = JArray.getForm(quests,i) as MF_RandomQuest
        if(QuestForm.getRank() == 1)
            Handler.HomeJobs.addForm(QuestForm)
        elseif(QuestForm.getRank() == 2)
            Handler.CampJobs.addForm(QuestForm)
        elseif(QuestForm.getRank() >= 3)
            Handler.RandomQuests.addForm(QuestForm)
        endIf
    endWhile
endFunction

event OnOptionDefault(int option)
        if(option == idNPCActive)
            IsNPCActive = true
            NPCWhore.WhoreActive = 1
            SetToggleOptionValue(idNPCActive, IsNPCActive)
        elseif(option == idSM)
            QuestConditional.ActiveSolicit = 1
            QuestConditional.PassiveSolicit = 0
            SetTextOptionValue(idSM, "$Active")
        elseif(option == idPMS)
            PlayerMinimalStripping = false
            SetToggleOptionValue(idPMS, PlayerMinimalStripping)
        elseif(option == idCMS)
            ClientMinimalStripping = false
            SetToggleOptionValue(idCMS, ClientMinimalStripping)
        elseif(option == idRTT)
            RestrictToTown = true
            SetToggleOptionValue(idRTT, RestrictToTown)
        elseif(option == idNPCSchedule)
            NPCSchedule = true
            NPCWhore.BypassWhoreSchedule = 0
            SetToggleOptionValue(idNPCSchedule, NPCSchedule)
        endif
endEvent


event OnOptionHighlight(int option)
    if(option == idTC)
        SetInfoText("$MF_TotalNumberClientsHelp")
    elseif(option == idPRS)
        SetInfoText("$MF_RankStrideHelp")
    elseif(option == idSM)
        SetInfoText("$MF_SolicitationModeHelp")
    elseif(option == idPMS || option == idCMS)
        SetInfoText("$MF_MinimalStrippingHelp")
    elseif(option == idRTT)
        SetInfoText("$MF_RestrictToInnKeeperTownHelp")
    elseif(option == idBGMC)
        SetInfoText("$MF_InnKeeperCutHelp")
    elseif(option == idFJCD)
        SetInfoText("$MF_CoolDownHelp")
    elseif(option == idMFC || option == idFFC || option == idFMC || option == idMMC)
        SetInfoText("$MF_ApproachChanceHelp")
    elseif(option == idHEC || option == idHBC || option == idEBC)
        SetInfoText("$MF_RaceApproachChanceHelp")
    elseif(option == idAD) 
        SetInfoText("$MF_AggroDistanceHelp")
    elseif(option == idPSI)
        SetInfoText("$MF_ScanTimeHelp")
    elseif(option == idTTPS)
        SetInfoText("$MF_GetStuffBackHelp")
    elseif(option == idNPCSchedule)
        SetInfoText("$MF_WencheWorkSchedulHelp")
    elseif(option == idMB)
        SetInfoText("$MF_MultipleBonusHelp")
    elseif(option == idMR)
        SetInfoText("$MF_AdditionalSceneHelp")
    elseif(option == idTM || option == idOM || option == idAM || option == idVM || option == idRM)
        SetInfoText("$MF_ModifierHelp")
    endif
endEvent


event OnOptionSliderOpen(int option)
    if (option == idPRS)
        SetSliderDialogStartValue(rankStride as float)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(0.0, 20.0)
        SetSliderDialogInterval(1.0)
    elseif(option == idFJCD)
        SetSliderDialogStartValue(FailJobCD * 24.0)
        SetSliderDialogDefaultValue(3.0)
        SetSliderDialogRange(0.0, 24.0)
        SetSliderDialogInterval(1.0)        
    elseif(option == idHJQM)
        SetSliderDialogStartValue(HomeDeliveryQuestModifier)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.1, 4.0)
        SetSliderDialogInterval(0.1)    
    elseif(option == idHJCD)
        SetSliderDialogStartValue(HomeJobCD * 24.0)
        SetSliderDialogDefaultValue(3.0)
        SetSliderDialogRange(0.0, 24.0)
        SetSliderDialogInterval(1.0)
    elseif(option == idHDGC)
        SetSliderDialogStartValue(HomeDeliveryGuestChance)
        SetSliderDialogDefaultValue(50.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(1.0)      
    elseif(option == idCJTC)
        SetSliderDialogStartValue(CampJobTargetClient as float)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(1.0, 20.0)
        SetSliderDialogInterval(1.0)    
    elseif(option == idCJCD)
        SetSliderDialogStartValue(CampJobCD * 24.0)
        SetSliderDialogDefaultValue(24.0)
        SetSliderDialogRange(0.0, 72.0)
        SetSliderDialogInterval(3.0)
    elseif(option == idCJQM)
        SetSliderDialogStartValue(CampJobQuestModifier)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.1, 4.0)
        SetSliderDialogInterval(0.1)    
    elseif(option == idRJCD)
        SetSliderDialogStartValue(RandomJobCD * 24.0)
        SetSliderDialogDefaultValue(12.0)
        SetSliderDialogRange(0.0, 48.0)
        SetSliderDialogInterval(2.0)
    elseif(option == idCJET)
        SetSliderDialogStartValue(CampJobExpireTime * 24.0)
        SetSliderDialogDefaultValue(3.0)
        SetSliderDialogRange(0.0, 12.0)
        SetSliderDialogInterval(1.0)
    elseif(option == idTFFR)
        SetSliderDialogStartValue(TimeForFullReward)
        SetSliderDialogDefaultValue(90.0)
        SetSliderDialogRange(0.0, 120.0)
        SetSliderDialogInterval(6.0)    
    elseif(option == idBGPC)
        SetSliderDialogStartValue(BaseGoldPerClient)
        SetSliderDialogDefaultValue(40.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)    
    elseif(option == idBGMC)
        SetSliderDialogStartValue(BaseGoldMadameCut)
        SetSliderDialogDefaultValue(50.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(1.0)            
    elseif(option == idFGB)
        SetSliderDialogStartValue(FemaleGoldBonus)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(0.0, 40.0)
        SetSliderDialogInterval(2.0)        
    elseif(option == idMGB)
        SetSliderDialogStartValue(MaleGoldBonus)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(0.0, 40.0)
        SetSliderDialogInterval(2.0)        
    elseif(option == idGBPR)
        SetSliderDialogStartValue(GoldBonusPerRank)
        SetSliderDialogDefaultValue(5.0)
        SetSliderDialogRange(0.0, 20.0)
        SetSliderDialogInterval(1.0)        
    elseif(option == idGBPS)
        SetSliderDialogStartValue(GoldBonusPerSpeechcraft)
        SetSliderDialogDefaultValue(0.5)
        SetSliderDialogRange(0.0, 2.0)
        SetSliderDialogInterval(0.1)        
    elseif(option == idGBPX)
        SetSliderDialogStartValue(GoldBonusPerSexRank)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(0.0, 40.0)
        SetSliderDialogInterval(2.0)        
    elseif(option == idTM)
        SetSliderDialogStartValue(TipModifier)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 3.0)
        SetSliderDialogInterval(0.1)
    elseif(option == idOM)
        SetSliderDialogStartValue(OralModifier)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.0, 4.0)
        SetSliderDialogInterval(0.1)        
    elseif(option == idAM)
        SetSliderDialogStartValue(AnalModifier)
        SetSliderDialogDefaultValue(1.5)
        SetSliderDialogRange(0.0, 4.0)
        SetSliderDialogInterval(0.1)        
    elseif(option == idVM)
        SetSliderDialogStartValue(VaginalModifier)
        SetSliderDialogDefaultValue(2.5)
        SetSliderDialogRange(0.0, 4.0)
        SetSliderDialogInterval(0.1)
    elseif(option == idRM)
        SetSliderDialogStartValue(RapeModifier)
        SetSliderDialogDefaultValue(1.75)
        SetSliderDialogRange(0.0, 4.0)
        SetSliderDialogInterval(0.1)
    elseif(option == idMB)
        SetSliderDialogStartValue(MultipleBonus)
        SetSliderDialogDefaultValue(0.75)
        SetSliderDialogRange(0.0, 2.0)
        SetSliderDialogInterval(0.01)
    elseif(option == idMR)
        SetSliderDialogStartValue(MaxRepetitions)
        SetSliderDialogDefaultValue(0)
        SetSliderDialogRange(0, 10)
        SetSliderDialogInterval(1)
    elseif(option == idBUR)
        SetSliderDialogStartValue(BountyUpRate)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.1, 4.0)
        SetSliderDialogInterval(0.1)
    elseif(option == idBDR)
        SetSliderDialogStartValue(BountyDownRate)
        SetSliderDialogDefaultValue(1.0)
        SetSliderDialogRange(0.02, 1.0)
        SetSliderDialogInterval(0.02)
    elseif(option == idMBM)
        SetSliderDialogStartValue(MaxBountyMult)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(2.0, 100.0)
        SetSliderDialogInterval(2.0)
    elseif(option == idNPCBaseGold)
        SetSliderDialogStartValue(NPCBaseGoldCost)
        SetSliderDialogDefaultValue(50.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)
    elseif(option == idAD)
        SetSliderDialogStartValue(AggroDistance.GetValue() * MeterPerUnit)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(0.0, 30.0)
        SetSliderDialogInterval(1.0)
    elseif(option == idPSI)
        SetSliderDialogStartValue(ScanInterval)
        SetSliderDialogDefaultValue(25.0)
        SetSliderDialogRange(10.0, 60.0)
        SetSliderDialogInterval(1.0)
    elseif(option == idOPF)
        SetSliderDialogStartValue(100.0 / OveralModifier)
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(5.0, 100.0)
        SetSliderDialogInterval(5.0)            
    elseif(option == idHEC)
        SetSliderDialogStartValue(HEChance)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-50.0, 50.0)
        SetSliderDialogInterval(5.0)    
    elseif(option == idHBC)
        SetSliderDialogStartValue(HBChance)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-50.0, 50.0)
        SetSliderDialogInterval(5.0)    
    elseif(option == idEBC)
        SetSliderDialogStartValue(EBChance)
        SetSliderDialogDefaultValue(0.0)
        SetSliderDialogRange(-50.0, 50.0)
        SetSliderDialogInterval(5.0)    
    elseif(option == idMFC)
        SetSliderDialogStartValue(MFChance.GetValue())
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)    
    elseif(option == idFFC)
        SetSliderDialogStartValue(FFChance.GetValue())
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)    
    elseif(option == idMMC)
        SetSliderDialogStartValue(MMChance.GetValue())
        SetSliderDialogDefaultValue(50.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)    
    elseif(option == idFMC)
        SetSliderDialogStartValue(FMChance.GetValue())
        SetSliderDialogDefaultValue(50.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)
    elseif(option == idGCFT)
        SetSliderDialogStartValue(GearCostForTheft)
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(0.0, 400.0)
        SetSliderDialogInterval(20.0)
    elseif(option == idICFT)
        SetSliderDialogStartValue(ItemCostForTheft)
        SetSliderDialogDefaultValue(10.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)
    elseif(option == idPGT)
        SetSliderDialogStartValue(PercGoldTheft)
        SetSliderDialogDefaultValue(100.0)
        SetSliderDialogRange(0.0, 100.0)
        SetSliderDialogInterval(5.0)
    elseif(option == idRJR)
        SetSliderDialogStartValue(RandomJobReward as float)
        SetSliderDialogDefaultValue(500.0)
        SetSliderDialogRange(0.0, 2000.0)
        SetSliderDialogInterval(100.0)
    elseif(option == idTTPS)
        SetSliderDialogStartValue(TimeToPayStuff * 24.0)
        SetSliderDialogDefaultValue(24.0)
        SetSliderDialogRange(0.0, 72.0)
        SetSliderDialogInterval(4.0)
    endIf
endEvent


event OnOptionSliderAccept(int option, float value)
    if (option == idPRS)
        rankStride = value as int
        ProstituteRank1 = 2*rankStride
        ProstituteRank2 = 5*rankStride  
        ProstituteRank3 = 9*rankStride  
        ProstituteRank4 = 14*rankStride 
        ProstituteRank5 = 20*rankStride 
        SetSliderOptionValue(idPRS, value)
    elseif(option == idFJCD)
        FailJobCD = value / 24.0
        SetSliderOptionValue(idFJCD, value, "{0} hours")
    elseif(option == idHJQM)        
        HomeDeliveryQuestModifier = value
        SetSliderOptionValue(idHJQM, value, "{1}x")
    elseif(option == idHJCD)
        HomeJobCD = value / 24.0
        SetSliderOptionValue(idHJCD, value, "{0} hours")
    elseif (option == idHDGC)
        HomeDeliveryGuestChance = value as int
        SetSliderOptionValue(idHDGC, value, "{0}%")
    elseif(option == idCJTC)
        CampJobTargetClient = value as int
        SetSliderOptionValue(idCJTC, value, "{0} clients")
    elseif(option == idCJCD)
        CampJobCD = value / 24.0
        SetSliderOptionValue(idCJCD, value, "{0} hours")
    elseif(option == idCJQM)        
        CampJobQuestModifier = value
        SetSliderOptionValue(idCJQM, value, "{1}x")
    elseif(option == idRJCD)
        RandomJobCD = value / 24.0
        SetSliderOptionValue(idRJCD, value, "{0} hours")
    elseif(option == idCJET)
        CampJobExpireTime = value / 24.0
        SetSliderOptionValue(idCJET, value, "{0} hours")
    elseif(option == idTFFR)
        TimeForFullReward = value
        SetSliderOptionValue(idTFFR, value, "{0} sec")
    elseif(option == idBGPC)
        BaseGoldPerClient = value
        SetSliderOptionValue(idBGPC, value, "{0} gold")
    elseif(option == idBGMC)
        BaseGoldMadameCut = value
        SetSliderOptionValue(idBGMC, value, "{0}%")
    elseif(option == idFGB)
        FemaleGoldBonus = value
        SetSliderOptionValue(idFGB, value, "{0} gold")
    elseif(option == idMGB)
        MaleGoldBonus = value
        SetSliderOptionValue(idMGB, value, "{0} gold")
    elseif(option == idGBPR)
        GoldBonusPerRank = value
        SetSliderOptionValue(idGBPR, value, "{0} gold")
    elseif(option == idGBPS)
        GoldBonusPerSPeechcraft = value
        SetSliderOptionValue(idGBPS, value, "{1} gold")
    elseif(option == idGBPX)
        GoldBonusPerSexRank = value
        SetSliderOptionValue(idGBPX, value, "{0} gold")
    elseif(option == idTM)
        TipModifier = value
        SetSliderOptionValue(idTM, value, "{1}x")
    elseif(option == idOM)
        OralModifier = value
        SetSliderOptionValue(idOM, value, "{1}x")
    elseif(option == idAM)
        AnalModifier = value
        SetSliderOptionValue(idAM, value, "{1}x")
    elseif(option == idVM)
        VaginalModifier = value
        SetSliderOptionValue(idVM, value, "{1}x")
    elseif(option == idRM)
        RapeModifier = value
        SetSliderOptionValue(idRM, value, "{1}x")
    elseif(option == idMB)
        MultipleBonus = value
        SetSliderOptionValue(idMB, value, "{1}x")
    elseif(option == idMR)
        MaxRepetitions = value
        SetSliderOptionValue(idMR, value, "{0}")
    elseif(option == idBUR)
        BountyUpRate = value
        SetSliderOptionValue(idBUR, value, "{1}")
    elseif(option == idBDR)
        BountyDownRate = value
        SetSliderOptionValue(idBDR, value, "{1}")
    elseif(option == idMBM)
        MaxBountyMult = value
        SetSliderOptionValue(idMBM, value, "{1}")
    elseif(option == idNPCBaseGold)
        NPCBaseGoldCost = value
        SetSliderOptionValue(idNPCBaseGold, value, "{0} gold")
    elseif(option == idAD)
        AggroDistance.SetValue(value / MeterPerUnit)
        SetSliderOptionValue(idAD, value, "{0} meters")
    elseif(option == idPSI)
        ScanInterval = value
        SetSliderOptionValue(idPSI, value, "{0} sec")
    elseif(option == idOPF)
        OveralModifier = 100.0 / value
        SetSliderOptionValue(idOPF, value, "{0}%")
    elseif(option == idHEC)
        HEChance = value as int
        SetSliderOptionValue(idHEC, value, "{0}%")
    elseif(option == idHBC)
        HBChance = value as int
        SetSliderOptionValue(idHBC, value, "{0}%")
    elseif(option == idEBC)
        EBChance = value as int
        SetSliderOptionValue(idEBC, value, "{0}%")      
    elseif(option == idMFC)
        MFApproachFreq = value as int
        MFChance.SetValue(value)
        UpdateCurrentInstanceGlobal(MFChance)
        SetSliderOptionValue(idMFC, value, "{0}%")
    elseif(option == idFFC)
        FFApproachFreq = value as int
        FFChance.SetValue(value)
        UpdateCurrentInstanceGlobal(FFChance)
        SetSliderOptionValue(idFFC, value, "{0}%")
    elseif(option == idMMC)
        MMApproachFreq = value as int
        MMChance.SetValue(value)
        UpdateCurrentInstanceGlobal(MMChance)
        SetSliderOptionValue(idMMC, value, "{0}%")
    elseif(option == idFMC)
        FMApproachFreq = value as int
        FMChance.SetValue(value)
        UpdateCurrentInstanceGlobal(FMChance)
        SetSliderOptionValue(idFMC, value, "{0}%")
    elseif(option == idGCFT)
        GearCostForTheft = value as int
        SetSliderOptionValue(idGCFT, value, "{0} gold")
    elseif(option == idICFT)
        ItemCostForTheft = value as int
        SetSliderOptionValue(idICFT, value, "{0} gold")
    elseif(option == idPGT)
        PercGoldTheft = value
        SetSliderOptionValue(idPGT, value, "{0}%")
    elseif(option == idRJR)
        RandomJobReward = value as int
        SetSliderOptionValue(idRJR, value, "{0} gold")
    elseif(option == idTTPS)
        TimeToPayStuff = value / 24.0
        SetSliderOptionValue(idTTPS, value, "{0} hours")
    endIf
endEvent

Function buildPCSettingsPage()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$Prostitute Rank")
    idTC  = AddTextOption("$Total Clients", TotalClients.GetValue() as int)
    idPRS = AddSliderOption("$Rank Stride", rankStride as float)
    AddHeaderOption("$Stripping")
    idPMS  = AddToggleOption("$Player Minimal Stripping", PlayerMinimalStripping)
    idCMS  = AddToggleOption("$Client Minimal Stripping", ClientMinimalStripping)   

    AddEmptyOption()
        idUB  = AddToggleOption("$Use Beds", UseBeds)   
    AddEmptyOption()

    AddHeaderOption("$Player Detection")
    idAD  = AddSliderOption("$Aggro Distance", AggroDistance.GetValue() * MeterPerUnit, "{0} meters")
    idPSI = AddSliderOption("$Scan interval", ScanInterval, "{0} sec")  
    idOPF = AddSliderOption("$Overall Probability", 100.0 / OveralModifier, "{0}%")
    AddEmptyOption()
    idMFC = AddSliderOption("$M-F Approach Chance", MFChance.GetValue(), "{0}%")
    idFFC = AddSliderOption("$F-F Approach Chance", FFChance.GetValue(), "{0}%")
    idMMC = AddSliderOption("$M-M Approach Chance", MMChance.GetValue(), "{0}%")
    idFMC = AddSliderOption("$F-M Approach Chance", FMChance.GetValue(), "{0}%")    
    AddEmptyOption()
    idHEC = AddSliderOption("$Human/Elf Chance Bonus", HEChance, "{0}%")
    idHBC = AddSliderOption("$Human/Beast Chance Bonus", HBChance, "{0}%")  
    idEBC = AddSliderOption("$Elf/Beast Chance Bonus", EBChance, "{0}%")
        
    SetCursorPosition(1)
    AddHeaderOption("$Reward Settings")
    idTFFR = AddSliderOption("$Sex Duration for full Reward", TimeForFullReward, "{0} sec")
    idBGPC = AddSliderOption("$Base Gold per Client", BaseGoldPerClient, "{0} gold")
    idBGMC = AddSliderOption("$Madame Cut Percentage", BaseGoldMadameCut, "{0}%")
    idFGB  = AddSliderOption("$Female PC Gold Bonus", FemaleGoldBonus, "{0} gold")
    idMGB  = AddSliderOption("$Male PC Gold Bonus", MaleGoldBonus, "{0} gold")
    idGBPR = AddSliderOption("$Gold Bonus per Rank", GoldBonusPerRank, "{0} gold")
    idGBPS = AddSliderOption("$Gold Bonus per Speechcraft", GoldBonusPerSpeechcraft, "{1} gold")
    idGBPX = AddSliderOption("$Gold Bonus per Expertise", GoldBonusPerSexRank, "{0} gold")
    idTM   = AddSliderOption("$Tip Modifier", TipModifier, "{1}x")
    idOM   = AddSliderOption("$Oral Modifier", OralModifier, "{1}x")
    idAM   = AddSliderOption("$Anal Modifier", AnalModifier, "{1}x")
    idVM   = AddSliderOption("$Vaginal Modifier", VaginalModifier, "{1}x")
    idRM   = AddSliderOption("$Rape Modifier", RapeModifier, "{1}x")

    AddEmptyOption()
    AddHeaderOption("$Punishment Settings")
    idBDR = AddSliderOption("$Bounty Mult. Down Rate", BountyDownRate, "{1}")
    idBUR = AddSliderOption("$Bounty Mult. Up Rate", BountyUpRate, "{1}")
    idMBM = AddSliderOption("$Max Bounty Multiplier", MaxBountyMult, "{1}")
endFunction

Function buildQuestSettingsPage()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$Utility")
    idPanic1 = AddTextOption("$Panic button", "$Panic")
    idReset = AddTextOption("$Reset All Quests", "$Reset")
    idSimplejob = AddTextOption("$Release Freeroam Client", "$Release")

    idCQ = AddTextOption("$Currenty Registered Random Quest", (Handler.RandomQuests.GetSize() + Handler.CampJobs.GetSize()+Handler.HomeJobs.GetSize()),OPTION_FLAG_DISABLED)
    idScanQuests = AddTextOption("$Check for new Quests", "$Go")

    AddHeaderOption("$General Settings")
    idFJCD = AddSliderOption("$Fail Cooldown", FailJobCD * 24.0, "{0} hours")

    AddHeaderOption("$Free Roaming Prostitution")
    if(QuestConditional.ActiveSolicit == 0 && QuestConditional.PassiveSolicit == 1)
        idSM  = AddTextOption("$Solicitation Mode", "$Passive")
    elseif(QuestConditional.ActiveSolicit == 1 && QuestConditional.PassiveSolicit == 0)
        idSM  = AddTextOption("$Solicitation Mode", "$Active")
    else
        idSM  = AddTextOption("$Solicitation Mode", "$Both")
    endif
    idRTT = AddToggleOption("$Restrict to current Innkeeper's town", RestrictToTown)
    idGAA = AddToggleOption("$Guards can solicit player", GuardAllowed)
    idMB   = AddSliderOption("$Multiple Bonus", MultipleBonus, "{1}x")
    idMR   = AddSliderOption("$Max. Repetitions", MaxRepetitions, "{0}")
    AddHeaderOption("$Home Delivery Quest")
    idHJCD = AddSliderOption("$Cooldown", HomeJobCD * 24.0, "{0} hours")
    idHJQM = AddSliderOption("$Reward Modifier", HomeDeliveryQuestModifier, "{1}x")
    idHDGC = AddSliderOption("$Home Delivery Guest", HomeDeliveryGuestChance, "{0}%")
    
    SetCursorPosition(1)    
    AddHeaderOption("$Military Camp Quest")
    idCJCD = AddSliderOption("$Cooldown", CampJobCD * 24.0, "{0} hours")
    idCJQM = AddSliderOption("$Reward Modifier", CampJobQuestModifier, "{1}x")
    idCJTC = AddSliderOption("$Target Num Clients", CampJobTargetClient as float, "{0} clients")
    idCJET = AddSliderOption("$Expire Time", CampJobExpireTime * 24.0, "{0} hours")
    
    AddHeaderOption("$Random Quest")
    idRJCD = AddSliderOption("$Cooldown", RandomJobCD * 24.0, "{0} hours")
    idGCFT = AddSliderOption("$Gear Cost for Theft", GearCostForTheft, "{0} gold")
    idICFT = AddSliderOption("$Item Cost for Theft", ItemCostForTheft, "{0} gold")
    idPGT  = AddSliderOption("$Percentage Gold Theft", PercGoldTheft, "{0}%")
    idRJR  = AddSliderOption("$Effective Reward", RandomJobReward, "{0} gold")

    AddHeaderOption("$Getting your Stuff Back")
    idCheat = AddTextOption("$Get your stuff (Cheat)?", "Yes")
    idTTPS =  AddSliderOption("$Grace Time", TimeToPayStuff * 24.0, "{0} hours")
endFunction

Function buildNPCEventPage()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$Utility")
    idPanic2 = AddTextOption("$Panic button", "Panic")
    idScene = AddTextOption("$Reset NPC Scene", "Reset")
    AddHeaderOption("$Toggles")
    idNPCActive = AddToggleOption("$NPC Scene", IsNPCActive)
    idNPCSchedule = AddToggleOption("$NPC Schedule", NPCSchedule)
    ; idNPCBegin = AddSliderOption("$Beginning", , "{0} o'clock") 
    ; idNPCDur   = AddSliderOption("$Duration", , "{0} o'clock") 
    SetCursorPosition(1)
    AddHeaderOption("$Hiring Cost (Shares modifiers with PC)")
    idNPCBaseGold = AddSliderOption("$Base Cost for NPC Prostitute", NPCBaseGoldCost, "{0} gold")
endFunction

Function buildWorkingClothsPage()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$Equiped Clothes")
    Form Cuirass = Game.GetPlayer().GetWornForm(0x00000004)
    if(Cuirass)
        idWC = AddToggleOption(Cuirass.GetName(), WorkingClothes.HasForm(Cuirass))
    endIf
    SetCursorPosition(1)
    AddHeaderOption("$List of Working Clothes")
    int i = WorkingClothes.getSize()
    while (i > 0)
        i-= 1
        Form armorForm =  WorkingClothes.GetAt(i)
        AddTextOption(armorForm.GetName(), "", OPTION_FLAG_DISABLED)
    endWhile
endFunction
