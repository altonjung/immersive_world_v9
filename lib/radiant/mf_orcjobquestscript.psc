Scriptname mf_OrcJobQuestScript extends MF_RandomQuest  

SexLabFramework Property SexLab Auto
mf_Handler Property Handler Auto
mf_Handler_Config Property HandlerConfig Auto

mf_OrcJobConditional Property QuestConditional Auto

ReferenceAlias Property CampCenter Auto
ReferenceAlias Property akFarmerRef Auto
ReferenceAlias Property akChiefRef Auto
ReferenceAlias Property akHunter1Ref Auto
ReferenceAlias Property akHunter2Ref Auto
ReferenceAlias[] Property akClientRefs Auto
ReferenceAlias Property OrcChief  Auto

Faction Property OrcFriendFaction Auto
Faction Property TownLargashburFaction  Auto  
Faction Property TownDushnikhYalFaction  Auto  
Faction Property TownNarzulburFaction  Auto 

Package Property WaitPackage  Auto  

Actor Property Player  Auto  

ImageSpaceModifier Property FadeOut Auto
ImageSpaceModifier Property BlackScreen Auto
ImageSpaceModifier Property FadeIn Auto

LeveledItem Property RandomGem Auto
MiscObject Property Gold Auto

int turn = 0

int Function getRank()
    return 3
endFunction

Function OrcJobArousal()
    handler.ResetArousal()
    handler.NoSLSOSatisfaction()
Endfunction

Function ActivateExtraReward()
    Handler.HandlerConditional.GrantExtraReward=true
endFunction

Function getExtraReward()
    GetInitialReward()
    GetInitialReward()
endFunction


Function GetInitialReward()
    Actor akPlayer = Handler.akPlayer

    if(akPlayer == none)
        akPlayer = Player
        Handler.akPlayer = Player
    endIf

    int totalPrice = HandlerConfig.RandomJobReward
    int amount = Utility.RandomInt(totalPrice/2, totalPrice)
    akPlayer.AddItem(Gold, amount)
    
    int i = 10
    While i > 0
        i -= 1
        akPlayer.AddItem(RandomGem, 1, true)
    endWhile
endFunction


Function GetFinalReward()
    Actor akPlayer = Handler.akPlayer
    if(AddedPlayerToOrcFaction)
        akPlayer.RemoveFromFaction(OrcFriendFaction)
    endif
    akPlayer.RemoveFromFaction(TownLargashburFaction)
    akPlayer.RemoveFromFaction(TownDushnikhYalFaction)
    akPlayer.RemoveFromFaction(TownNarzulburFaction)
    
endFunction


Function SetOrcHunter()
    Actor akPlayer = Handler.akPlayer
    Actor akHunter1 = akHunter1Ref.GetRef() as Actor    
    Actor akHunter2 = akHunter2Ref.GetRef() as Actor    
    
    float dist = 350.0  
    float dir = akPlayer.GetAngleZ()
    float px = akPlayer.GetPositionX()
    float py = akPlayer.GetPositionY()
    float pz = akPlayer.GetPositionZ()
    
    
    akHunter1.SetPosition(px + dist * Math.sin(dir + 120.0), py + dist * Math.cos(dir + 120.0), pz + 75.0)
    akHunter2.SetPosition(px + dist * Math.sin(dir + 240.0), py + dist * Math.cos(dir + 240.0), pz + 75.0)

    QuestConditional.OrcHunterPrompt = 1
    akHunter1.EvaluatePackage()
endFunction


Function UnleashOrcHunter()
    QuestConditional.OrcHunterPrompt = 0

    Actor akPlayer = Handler.akPlayer
    Actor akHunter1 = akHunter1Ref.GetRef() as Actor    
    Actor akHunter2 = akHunter2Ref.GetRef() as Actor    
    
    akHunter1.StartCombat(akPlayer)
    akHunter1.SendAssaultAlarm()

    akHunter2.StartCombat(akPlayer)
    akHunter2.SendAssaultAlarm()

    SetStage(100) ; escaped or dead
endFunction


Function OrcHunterTiedAndDragged()
    QuestConditional.OrcHunterPrompt = 0
    Actor akPlayer = Handler.akPlayer
    Actor akHunter1 = akHunter1Ref.GetRef() as Actor    
    Actor akHunter2 = akHunter2Ref.GetRef() as Actor    
    
    akPlayer.SheatheWeapon()
    Utility.Wait(2.0)   
    Debug.SendAnimationEvent(akPlayer, "IdleHandsBehindBack")
    akPlayer.SetRestrained(true)    
            
    FadeOut.Apply()
    Utility.Wait(2.5) ; since Fadeout lasts exactly 3.0s, we need to allow some script delay
    FadeOut.PopTo(BlackScreen)
        
    akPlayer.MoveTo(CampCenter.GetRef())
    akHunter1.MoveTo(CampCenter.GetRef())
    akHunter2.MoveTo(CampCenter.GetRef())

    BlackScreen.PopTo(FadeIn)   
    Utility.Wait(2.0)       
    FadeIn.Remove()     
        
    Debug.SendAnimationEvent(akPlayer, "Reset")
    akPlayer.SetRestrained(false)
    ;Game.EnablePlayerControls()
endFunction


bool AddedPlayerToOrcFaction = false

Function TiedAndDragged()
    Actor akPlayer = Handler.akPlayer
    if(!akPlayer.IsInFaction(OrcFriendFaction))
        AddedPlayerToOrcFaction = true
        akPlayer.AddToFaction(OrcFriendFaction)
    endif
    akPlayer.AddToFaction(TownLargashburFaction)
    akPlayer.AddToFaction(TownDushnikhYalFaction)
    akPlayer.AddToFaction(TownNarzulburFaction)

    ; akPlayer.SheatheWeapon()
    ; Utility.Wait(2.0) 
    ; Debug.SendAnimationEvent(akPlayer, "IdleHandsBehindBack")
    akPlayer.SetRestrained(true)    
        
    FadeOut.Apply()
    Utility.Wait(2.5) ; since Fadeout lasts exactly 3.0s, we need to allow some script delay
    FadeOut.PopTo(BlackScreen)
        
    akPlayer.MoveTo(CampCenter.GetRef())
    akFarmerRef.GetRef().Disable()
    akHunter1Ref.GetRef().Enable()
    akHunter2Ref.GetRef().Enable()
    
    BlackScreen.PopTo(FadeIn)   
    Utility.Wait(2.0)       
    FadeIn.Remove() 
    
    SetStage(15)
    
    Utility.Wait(2.5)   
    ; Debug.SendAnimationEvent(akPlayer, "Reset")
    akPlayer.SetRestrained(false)
    ;Game.EnablePlayerControls()
endFunction


Event ChiefSexScenePrompt(string eventName, string argString, float argNum, form sender)
    SetStage(25)
    UnregisterForModEvent("AnimationEnd_NextScene") 
endEvent


Function ChiefSexScene()
    Actor akChief = akChiefRef.GetRef() as Actor

    RegisterForModEvent("AnimationEnd_NextScene", "ChiefSexScenePrompt")
    Handler.PerformSex(akChief, "Vaginal", "Aggressive", "NextScene",isPlayerVictim=true,foreplay=false)
endFunction 

int ActorArray = 0

Function AddClient(Actor speaker)

    if(ActorArray == 0)
        ActorArray = JArray.object()
        JValue.retain(ActorArray)
    endIf

    if(JArray.findForm(ActorArray, speaker) == -1)
        JArray.addForm(ActorArray, speaker)
        ActorUtil.AddPackageOverride(speaker, WaitPackage, priority = 100)
        QuestConditional.ClientCount += 1
    endIf

    if(QuestConditional.ClientCount >= 5)
        Debug.Notification("Found Enough clients, should talk to the chief...")
        Debug.Notification("or search more and have more fun.")
    endif
    QuestConditional.ClientFollow = 1
endFunction



Event NextTurn(string eventName, string argString, float argNum, form sender)
    turn += 1

    if(turn < QuestConditional.ClientCount)
        ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    endif
    GroupSexScene() 
endEvent

Function GroupSexScene()

    if(turn == 0)
        SexLab.StripActor(Handler.akPlayer)
    endIf
    if(turn < QuestConditional.ClientCount)
        RegisterForModEvent("AnimationEnd_NextTurn", "NextTurn")
        int randomSelect = Utility.RandomInt(1,100)
        if randomSelect > 50
            Handler.PerformSex(JArray.getForm(ActorArray,turn) as Actor, "Anal", aggr = "Aggressive", next="NextTurn",isPlayerVictim=true,foreplay=false)
        else
            Handler.PerformSex(JArray.getForm(ActorArray,turn) as Actor, "Vaginal", aggr = "Aggressive", next="NextTurn",isPlayerVictim=true,foreplay=false)
        EndIf
    else
        UnregisterForModEvent("AnimationEnd_NextTurn") 
        QuestConditional.ClientFollow = 0
        ;Game.EnablePlayerControls()
        SetStage(100)
        JValue.release(ActorArray)
        ActorArray = 0
        ActorUtil.RemoveAllPackageOverride(WaitPackage)
    endif
endFunction
