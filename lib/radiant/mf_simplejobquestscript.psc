Scriptname mf_SimpleJobQuestScript extends Quest  

ReferenceAlias Property akClientRef Auto
mf_Handler Property Handler Auto
mf_Variables Property Variables  Auto  
mf_SimpleJobConditional Property QuestConditional Auto
GlobalVariable Property NextDeclineIsRape  Auto  
Quest Property poolClients  Auto  

SPELL Property Disatisfaction Auto
SPELL Property Satisfaction Auto

bool isPlayerApproached = false

int count =0
int repetitions =1
String currentPosition

bool justOnce = false

Function SetOnce(bool onlyOnce)
    justOnce = onlyOnce
endFunction

Function ActiveExtremePerformance()
    QuestConditional.ExtremePerformance=1
endFunction

Function DeactivateExtremePerformance()
    QuestConditional.ExtremePerformance=0
endFunction

Function PausePooling()
    poolClients.Stop()
    isPlayerApproached = true
endFunction

Function ResetVariables()
    isPlayerApproached = false   
    handler.ResetArousal()
    RegisterForSingleUpdate(3)  ;start the client pooling a few seconds after the player leaves the dialogue
EndFunction

Event onUpdate()
    ScanForClient()
endEvent

Function ScanForClient()

    If ( !isRunning() )
        ;quest's dead, return so the next update register isn't made
        return
    EndIf

    if ( Variables.PassiveSolicit == 0 || QuestConditional.FollowPlayer == 1 || isPlayerApproached )
        ;do nothing for this update, player's already busy or passive solicit is disabled
    Else
        Debug.Notification("I'm looking for a client...")
        if(!poolClients.IsRunning())
            poolClients.Start()
            Utility.Wait(3)
        endIf

        int i=0
        while(!poolClients.IsRunning() && i <=2)
            i = i + 1
            Utility.Wait(2)
        endwhile

        Actor client =(poolClients as mf_SolicitPlayerMainScript).getClient()
        if(client != none)
            ForceSpeakerClient(client)
        else
            poolClients.Reset()
        endif
    endif

    RegisterForSingleUpdate(Handler.GetScanInterval())
EndFunction


Function ForceSpeakerClient(Actor Speaker)

    ;WS - clean-up the previous client if any.
    Actor previousClient = akClientRef.GetActorRef()
    If previousClient
        akClientRef.Clear()
        previousClient.EvaluatePackage()
    EndIf
    
    akClientRef.ForceRefTo(Speaker)
    Debug.Notification("A Client is coming my way...")
    SetStage(1)
    akClientRef.GetActorReference().EvaluatePackage()
    PausePooling()
    
endFunction


Function ForceSpeakerClient_WS(Actor Speaker)
    ;this function is used to fill the clientRef alias with the rapist, otherwise the rape animation won't start properly. PausePooling() doesn't need to be called here as it's already done in PerformRape()
    akClientRef.ForceRefTo(Speaker)
endFunction


Function FollowMe(Actor Speaker, int type)
    QuestConditional.FollowPlayer = 1
    QuestConditional.SexStage = type
    QuestConditional.DoneFucking=0
    akClientRef.ForceRefTo(Speaker)
    PausePooling()
    handler.setClientOrgasmActor(akClientRef.GetActorRef())
    SetStage(10)
    Speaker.EvaluatePackage()
endFunction


Function StopFollow()
    justOnce = false
    QuestConditional.SexStage = 0
    QuestConditional.FollowPlayer = 0
    QuestConditional.DoneFucking = 0
    akClientRef.TryToEvaluatePackage()
    akClientRef.Clear()
    Variables.ClientOrgasmActor = None
    Variables.OrgasmCount = 0
endFunction


Event ExtremeEvent(string eventName, string argString, float argNum, form sender)
    if(eventName == "AnimationStart_ExtremeEvent")
        ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
        if(count == repetitions)
            UnregisterForModEvent("AnimationStart_ExtremeEvent")
        endif
    endif

    if(eventName == "AnimationEnd_ExtremeEvent" && count == repetitions)
        debug.notification("Your Client is done.")
        Handler.CalcRewardMod(argString)        
        ;Game.EnablePlayerControls()
        UnregisterForModEvent("AnimationEnd_ExtremeEvent")
        SetStage(25)
    elseif (eventName == "AnimationEnd_ExtremeEvent")
        debug.notification("Your Client wants more.")
        PerformScene(currentPosition)
    endif
endEvent


Function PerformScene(string position, bool switchFF = false)

    RegisterForModEvent("AnimationStart_ExtremeEvent", "ExtremeEvent")
    RegisterForModEvent("AnimationEnd_ExtremeEvent", "ExtremeEvent")
    currentPosition = position
    string finalPosition = position
    string aggr = "None"
    int animSelectRoll = Utility.RandomInt(1,100)
    int aggroRoll = Utility.RandomInt(1,100)
    bool playerVictim = false
    
    
    If ( position == "StrapOn" )
        finalPosition = "Vaginal"
        If( animSelectRoll < 33 )
            finalPosition = "Anal"
        Endif
    ElseIf ( position == "Rough" )
        finalPosition = "Sex"
        playerVictim = true
    EndIf

    If( aggroRoll < 10 || position == "Rough" )
        aggr ="Aggressive"
    Else
        aggr = "None"
    Endif
    count = count + 1
    Handler.PerformSex(akClientRef.GetActorReference(), finalPosition, aggr, next="ExtremeEvent", isPlayerVictim=playerVictim, switchOnFF=switchFF)
endFunction

Function Perform()
    ; 0: nothing
    ; 1: Oral
    ; 2: Anal
    ; 3: Vaginal
    ; 4: Revers FF
    ; 5: Rough Sex
    ; 6: Threesome
    ; 7: Lesbian (WS added)
    
    count =0
    repetitions = 1
    QuestConditional.DoneFucking = 1

    if(QuestConditional.ExtremePerformance == 1)
        Debug.Trace("[Radiant Prostitution] Max Scenes : " +  Handler.GetMaxRepetitions())
        repetitions = Utility.RandomInt(1, Handler.GetMaxRepetitions())
        Debug.Trace("[Radiant Prostitution] Scenes count range is (1," + Handler.GetMaxRepetitions() + "), rolled " + repetitions + ".")
    endif
    
    int type = Utility.RandomInt(1,100)

    if(QuestConditional.SexStage == 1)
        performScene("Oral")
    elseif(QuestConditional.SexStage == 2)
        performScene("Anal")
    elseif(QuestConditional.SexStage == 3)
        performScene("Vaginal")
    elseif(QuestConditional.SexStage == 4)
        performScene("StrapOn", switchFF=true)          ; reverse FF : this is ONLY for when a female client requests to be fucked by a strap-on - scenarios where the player is the bottom are already using vaginal/anal
    elseif(QuestConditional.SexStage == 5)
        performScene("Rough")
    elseif(QuestConditional.SexStage == 6)
        Debug.MessageBox("Radiant Prostitution - Error 2 - Invalid sex type. (threesome)")   ;threesomes not implemented in current version
        Handler.PerformSex(akClientRef.GetActorReference(), "Sex")
    elseif(QuestConditional.SexStage == 7)
        performScene("Lesbian", switchFF=true)
    else
        Debug.MessageBox("Radiant Prostitution - Error 3 - Invalid sex type. (out of bounds)")
        Handler.PerformSex(akClientRef.GetActorReference(), "Sex")
    endif
endFunction


Event EndRape(string eventName, string argString, float argNum, form sender)
    repetitions=0
    ;Game.EnablePlayerControls()
    UnregisterForModEvent("AnimationEnd_EndRape")
    setStage(100)
endEvent

Event StartRape(string eventName, string argString, float argNum, form sender)
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    UnregisterForModEvent("AnimationStart_StartRape")
endEvent

Function PerformRape()
    RegisterForModEvent("AnimationStart_StartRape", "StartRape")
    RegisterForModEvent("AnimationEnd_EndRape", "EndRape")
    QuestConditional.FollowPlayer = 1
    NextDeclineIsRape.SetValueInt(1)
    UpdateCurrentInstanceGlobal(NextDeclineIsRape)
    PausePooling()
    handler.setClientOrgasmActor(akClientRef.GetActorRef())
    ;Handler.PerformSex(akClientRef.GetActorReference(), "Oral","Aggressive",next="StartRape",isPlayerVictim =true)
    int type = Utility.RandomInt(1,100)
    string position = "Vaginal"
    if((type % 2) == 0)
        position = "Anal"
    endif
    Handler.PerformSex(akClientRef.GetActorReference(), position, "Aggressive", next="EndRape",isPlayerVictim =true)
endFunction

function SimpleJobSatisfaction()
     if Variables.OrgasmCount == 0
        Variables.ClientSatisfaction = 0
    ElseIf Variables.OrgasmCount == repetitions - 2
        Variables.ClientSatisfaction = 1
    ElseIf Variables.OrgasmCount == repetitions - 1
        Variables.ClientSatisfaction = 2
    ElseIf Variables.OrgasmCount == repetitions
        Variables.ClientSatisfaction = 3
    Endif
    
    debug.notification("The Client's satisfaction is " +Variables.ClientSatisfaction)
EndFunction

 
Function Collect()
    
    
    Handler.GetRewardSingleFromClient(akClientRef.GetActorReference(),repetitions,QuestConditional.SexStage)
    if(repetitions > 0)
        Handler.SetRefractory(akClientRef.getActorReference())
    endif
    poolClients.Reset()
    StopFollow()
    SetStage(0)
    QuestConditional.ExtremePerformance=0
    isPlayerApproached = false
endFunction

Function Reset()
    actor akClient = akClientRef.getActorReference()
    poolClients.Reset()
    StopFollow()
    SetStage(0)
    QuestConditional.ExtremePerformance=0
    isPlayerApproached = false
EndFunction    

Function Rebuke(int chanceOfNextIsRape)
    repetitions=0
    Collect()
endFunction

Function Disatisfaction(Actor akSpeaker)
    Handler.SetRefractory(akSpeaker,false)
endFunction

Function setRapeChance()
    QuestConditional.RapeChance = Utility.RandomInt(1,100)
endFunction