Scriptname mf_CampJobQuestScript extends MF_RandomQuest

ReferenceAlias Property akCoworkerRef Auto
ReferenceAlias Property akCurrentClientRef Auto
ReferenceAlias Property akSecondClientRef Auto

mf_CampJobVariables Property QuestConditional Auto

mf_Variables Property HandlerConditional Auto
mf_Handler_Config Property HandlerConfig Auto
mf_Handler Property Handler Auto

MiscObject Property gold Auto

float NumPoints = 0.0
int NumClients = 0
int NumCoworkerClients = 0

Function CampJobArousal()
    handler.ResetArousal()
EndFunction

Function setNextStage(int nextStage)
    QuestConditional.Stage = nextStage
endFunction

int Function getRank()
    return 2
endFunction

Function GetCampJobReward()
    setStage(200)
    Handler.GetCampJobReward()
endFunction

Function PrintValues()
    Debug.Notification("You've had "+NumClients+ "so far")
    Debug.Notification("Your coworker has had "+NumCoworkerClients+" clients")
endFunction


Function FollowMe(Actor speaker, int stage)
    akCurrentClientRef.ForceRefTo(Speaker)
    handler.resetCampJobActors()
    HandlerConditional.FollowPlayer = 1
    speaker.EvaluatePackage()
    handler.setClientOrgasmActor(akCurrentClientRef.GetRef() as Actor)
    QuestConditional.SexStage = stage
endFunction


Function FollowMeToo(Actor speaker)
    akSecondClientRef.ForceRefTo(Speaker)
    handler.setGuestOrgasmActor(akSecondClientRef.GetRef() as Actor)
    speaker.EvaluatePackage()

    QuestConditional.SexStage = 6
endFunction

Function ForceMadam()
    Madam.ForceRefTo(Handler.akMadame)
endFunction

Function StopFollow()
    HandlerConditional.FollowPlayer = 0

    (akCurrentClientRef.GetRef() as Actor).EvaluatePackage()
    akCurrentClientRef.Clear()

    if(akSecondClientRef.GetRef() != None)
        (akSecondClientRef.GetRef() as Actor).EvaluatePackage()
        akSecondClientRef.Clear()
    endif
endFunction


Function Perform()
    ; 0: nothing
    ; 1: Oral
    ; 2: Anal
    ; 3: Vaginal
    ; 4: Rough
    ; 5: Looking for 2nd 3S actor
    ; 6: Threesome

    if(QuestConditional.SexStage == 1)
        NumClients += 1
        NumPoints += 1.0
        Handler.PerformSex(akCurrentClientRef.GetRef() as Actor, "Oral")
    elseif(QuestConditional.SexStage == 2)
        NumClients += 1
        NumPoints += 1.5
        Handler.PerformSex(akCurrentClientRef.GetRef() as Actor, "Anal")
    elseif(QuestConditional.SexStage == 3)
        NumClients += 1
        NumPoints += 2.5
        Handler.PerformSex(akCurrentClientRef.GetRef() as Actor, "Vaginal")
    elseif(QuestConditional.SexStage == 4)
        NumClients += 1
        NumPoints += 3.5
        int rapeType = Utility.RandomInt(1,100)
        string position = "Anal"
        if(rapeType < 33)
            position = "Vaginal"
        endif
        Handler.PerformSex(akCurrentClientRef.GetRef() as Actor, position, "Aggressive", isPlayerVictim=true)
    elseif(QuestConditional.SexStage == 6)
        NumClients += 2
        NumPoints += 3.0
        Handler.PerformThreesome(akCurrentClientRef.GetRef() as Actor, akSecondClientRef.GetRef() as Actor)
    else
        Debug.Notification("Incorrect selection... ")
        NumClients += 1
        NumPoints += 1.0
        Handler.PerformSex(akCurrentClientRef.GetRef() as Actor, "Sex")
    endif

    StopFollow()

    if(NumClients >= HandlerConfig.CampJobTargetClient)
        SetStage(100)
    endif

    if(NumCoworkerClients == 0)
        if(NumClients == 0)
             QuestConditional .BetIsWon = 0
        else
             QuestConditional .BetIsWon = 1
        endif
    endif

    QuestConditional.SexStage = 0
endFunction



Function CoworkerGetClient()
    if(NumCoworkerClients == 0)
        if(NumClients == 0)
             QuestConditional .BetIsWon = 0
        else
             QuestConditional .BetIsWon = 1
        endif
    endif
    NumCoworkerClients += 1
endFunction


Function CollectBet()
    Actor akPlayer= Handler.akPlayer
    Actor akCoworker = akCoworkerRef.GetRef() as Actor

    if(QuestConditional .BetIsWon == 1)
        akPlayer.Additem(gold, 100)
    else
        akPlayer.Removeitem(gold, 100)
        akCoworker.AddItem(gold, 100)
    endif

    QuestConditional.BetIsOn = 0
    Handler.CampJobSatisfaction(NumClients)
endFunction


float Function GetModifier()
    if(QuestConditional.CoworkerAlive == 1)
        return NumPoints
    else
        return NumPoints/2
    endif
endFunction
ReferenceAlias Property Madam  Auto  
