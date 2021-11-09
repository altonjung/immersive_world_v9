Scriptname MF_HomeVisit_Quest extends mf_randomquest  

SexLabFramework Property SexLab  Auto
mf_handler Property Handler  Auto
mf_handler_config Property HandlerConfig  Auto
mf_variables Property HandlerConditional  Auto

MF_HomeVisit_Conditional Property Conditions Auto

MiscObject Property Gold  Auto

ReferenceAlias Property house  Auto
ReferenceAlias Property Player  Auto
ReferenceAlias Property Madame  Auto
ReferenceAlias Property MainClient  Auto
ReferenceAlias Property Friend  Auto
ReferenceAlias Property Coworker  Auto

ReferenceAlias Property Winner  Auto
ReferenceAlias Property WinnerWhore  Auto
ReferenceAlias Property Loser  Auto
ReferenceAlias Property LoserWhore  Auto

Scene Property AddictedLoserWhore  Auto
Scene Property AddictedLoserWhore2  Auto

Scene Property VisitScene  Auto
Scene Property VisitScene2  Auto

Scene Property WinnerScene  Auto
Scene Property WinnerScene2  Auto
Scene Property WinnerScene3  Auto

bool PlayerAddedToHouseFaction =false

Faction Property HouseOwner  Auto  

int stage = 0
int round = 0
int roundMax = 0

bool allowCoworkerInterrupt = false
bool allowPlayerInterupt = false

Form[] mainClientItems
Form[] friendItems

sslThreadController playerThread
sslThreadController coworkerThread

int Function getRank()
    return 1
endFunction

Function setMadame(Actor pimp)
    akMadame = pimp
    Madame.ForceRefTo(pimp)
endFunction

bool Function checkConditions()
    return (Game.GetPlayer().GetActorBase().getSex() == 1)
endFunction

Form[] Function stripAct(Actor act)
    return SexLab.stripActor(act, doAnimate = false)
endFunction

Form[] Function stripAli(ReferenceAlias ali)
    return stripAct(ali.getActorRef())
endFunction

Function TheBetArousal()
    handler.ResetArousal()
    handler.NoSLSOSatisfaction()
Endfunction

Function StripPlayer()
    stripAli(Player)
    Conditions.WhoreStriped = 1
    MainClient.TryToEvaluatePackage()
endFunction

Function suckHimDry()
    sslBaseAnimation[] anim = SexLab.GetAnimationsByTags(2, "MF,Blowjob", "Vaginal,69",true)
    Actor[] actors =  new Actor[2]
    actors[0] = Player.getActorRef()
    actors[1] = MainClient.getActorRef()
    mainClientItems = stripAli(MainClient)
    RegisterForModEvent("StageStart_AboutToBlow","AboutToBlow")
    RegisterForModEvent("AnimationEnd_AboutToBlow","AboutToSwallow")
    Handler.fuck(actors,0,anim,false,"AboutToBlow").startThread()
endFunction

Event AboutToBlow(string eventName, string argString, float argNum, form sender)
    stage += 1

    if(stage == 2 )
        UnregisterForModEvent("StageStart_AboutToBlow")
        Friend.TryToEnable()
        Coworker.TryToEnable()
        Coworker.TryToEvaluatePackage()
        Friend.TryToEvaluatePackage()
        VisitScene.Start()
    endIf

endEvent

Event AboutToSwallow(string eventName, string argString, float argNum, form sender)
    while(VisitScene.isPlaying())
        Utility.wait(2)
    endWhile
    MainClient.TryToEvaluatePackage()
    VisitScene2.Start()
    SetStage(20)
endEvent

Function startBanging()
    SetStage(30)
    friendItems =  stripAli(friend)
    stripAli(coworker)
    
    decideWinner()
    roundMax = Utility.RandomInt(2,3)
    
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)

    RegisterForModEvent("AnimationEnd_KeepFilling","KeepFilling")
    RegisterForModEvent("AnimationEnd_KeepFilling1","KeepFilling1")
    
    allowCoworkerInterrupt = false
    allowPlayerInterupt = false
    fillWhores()
    
endFunction

Function decideWinner()
    int vagExp = SexLab.GetPlayerStatLevel("Vaginal") +30
    if(vagExp >95)
        vagExp =95
    endIf
    
    ;ws edit - make 50/50 chance of win/loss
    vagExp = 50
    
    bool playerWon = Utility.RandomInt(0, 100) < vagExp 
    
    if(playerWon)
        winner.ForceRefTo(MainClient.getRef())
        winnerWhore.ForceRefTo(Player.getRef())
        loser.ForceRefTo(Friend.getRef())
        loserWhore.ForceRefTo(Coworker.getRef())
        Conditions.AddictedLoserWhore =  Utility.RandomInt(0,100) % 3
    else
        loser.ForceRefTo(MainClient.getRef())
        loserWhore.ForceRefTo(Player.getRef())
        winner.ForceRefTo(Friend.getRef())
        winnerWhore.ForceRefTo(Coworker.getRef())
    endIf

endFunction

Function fillWhores()

    MoveRefToPositionRelativeTo(Coworker.getRef(), Player.getRef(), 100.0, 90.0)

    While (SexLab.FindActorController(Player.getActorRef()) != -1 || SexLab.FindActorController(Coworker.getActorRef()) != -1 || allowCoworkerInterrupt || allowPlayerInterupt )
        Utility.Wait(1.0)
        Debug.Trace("MF_RP : mf_Homevisit_quest.psc in WHILE loop = " + SexLab.FindActorController(Player.getActorRef()) + ":" + SexLab.FindActorController(Coworker.getActorRef()) + ":" + allowCoworkerInterrupt + ":" + allowPlayerInterupt)
        If ( !isRunning() )
            return  ;ensure that this WHILE loop doesn't keep running infinitely if something goes wrong and the quest is already finished
        EndIf
    endwhile
    
    Utility.Wait(1.0)

    sslBaseAnimation[] anim = new sslBaseAnimation[1]
    sslBaseAnimation[] anims = SexLab.GetAnimationsByTags(2,"MF,Vaginal")

    int i = Utility.RandomInt(0,  anims.length - 1)

    anim[0]  = anims[i]

    Actor[] actors1 =  new Actor[2]
    actors1[0] = Player.getActorRef()
    actors1[1] = MainClient.getActorRef()
    sslThreadModel model1 = Handler.fuck(actors1,0,anim,false,"KeepFilling1")

    Actor[] actors2 =  new Actor[2]
    actors2[0] = Coworker.getActorRef()
    actors2[1] = Friend.getActorRef()
    sslThreadModel model2 = Handler.fuck(actors2,0,anim,false,"KeepFilling")
    
    playerThread = model1.StartThread()
    coworkerThread = model2.StartThread()
    allowCoworkerInterrupt = true
    allowPlayerInterupt = true
endFunction

Event KeepFilling(string eventName, string argString, float argNum, form sender)
    Utility.wait(1.5)
    if(allowPlayerInterupt)
        if(SexLab.FindActorController(Player.getActorRef()) != -1)
            Utility.Wait(5.0)
        endIf

        if(SexLab.FindActorController(Player.getActorRef()) != -1)
            playerThread.EndAnimation()
        endIf
    endIf
    allowPlayerInterupt = false
    if(round < roundMax)
        fillWhores()
    else
        UnregisterForModEvent("AnimationEnd_KeepFilling")
        UnregisterForModEvent("AnimationEnd_KeepFilling1")
        Utility.Wait(1.0)
        playWinnerScene()
    endIf

    round += 1
endEvent

Event KeepFilling1(string eventName, string argString, float argNum, form sender)
    Utility.wait(1.5)
    if(allowCoworkerInterrupt)
        if(SexLab.FindActorController(Coworker.getActorRef()) != -1)
            Utility.Wait(5.0)
        endIf

        if(SexLab.FindActorController(Coworker.getActorRef()) != -1)
            coworkerThread.EndAnimation()
        endIf
    endif
    allowCoworkerInterrupt = false
endEvent

Function MoveRefToPositionRelativeTo(ObjectReference akSubject, ObjectReference akTarget, Float OffsetDistance = 0.0, Float OffsetAngle = 0.0)
    float AngleZ = akTarget.GetAngleZ() + OffsetAngle
    float OffsetX = OffsetDistance * Math.Sin(AngleZ)
    float OffsetY = OffsetDistance * Math.Cos(AngleZ)
    akSubject.MoveTo(akTarget, OffsetX, OffsetY, 0.0)
    akSubject.SetAngle(akTarget.GetAngleX(), akTarget.GetAngleY(), akTarget.GetAngleZ())
EndFunction

Function playWinnerScene()
    RegisterForModEvent("AnimationEnd_ClaimPrize","ClaimPrize")
    Actor[] actors =  new Actor[2]
    actors[0] = winnerWhore.getActorRef()
    actors[1] = winner.getActorRef()
    Handler.fuck(actors,0,SexLab.GetAnimationsByTags(2,"MF,Vaginal","",true),false,"ClaimPrize").StartThread()
    Utility.wait(5)
    WinnerScene.Start()
endFunction

Event ClaimPrize(string eventName, string argString, float argNum, form sender)
    Utility.wait(1.5)
    UnregisterForModEvent("AnimationEnd_ClaimPrize")
    WinnerScene2.Start()
endEvent

Function fuckLoser()
    Actor[] actors =  new Actor[2]
    actors[0] = loserWhore.getActorRef()
    actors[1] = winner.getActorRef()
    if( Conditions.AddictedLoserWhore == 1)
        AddictedLoserWhore.start()
    endIF

    ;Handler.fuck(actors ,0, SexLab.GetAnimationsByTags(2,"MF,Vaginal","",true),false).StartThread()
    RegisterForModEvent("AnimationEnd_StartThreesome","StartThreesome")
    Handler.fuck(actors ,0, SexLab.GetAnimationsByTags(2,"MF,Vaginal","",true),false,"StartThreesome").StartThread()
endFunction

Event StartThreesome(string eventName, string argString, float argNum, form sender)
    AddictedLoserWhore.stop()
    Utility.wait(1.5)
    UnregisterForModEvent("AnimationEnd_StartThreesome")
    WinnerScene3.Start()
endEvent

Function threesome()
    
    Actor[] actors =  new Actor[3]
    actors[0] = winnerWhore.getActorRef()
    actors[1] = loserWhore.getActorRef()
    actors[2] = winner.getActorRef()
    
    sslBaseAnimation[] anim = new sslBaseAnimation[1]
    anim[0] = SexLab.GetAnimationByName("Arrok Tricycle")
    RegisterForModEvent("AnimationEnd_DoneThreesome","DoneThreesome")
    Handler.fuck(actors ,0, anim , next = "DoneThreesome").StartThread()
endFunction

Event DoneThreesome(string eventName, string argString, float argNum, form sender)
    Conditions.DoneThreesome = 1
    MainClient.TryToEvaluatePackage()
    SetStage(40)
    ;Game.EnablePlayerControls()
endEvent

Function pay()
    Conditions.GotBonus = 1
    SetObjectiveCompleted(2)
    SetObjectiveDisplayed(3)

    float PERF = 1
    float QM = 3.0 * HandlerConfig.HomeDeliveryQuestModifier
    
    player.getActorRef().AddItem(Gold, Handler.CalcReward(QM, PERF))
    
    if(Conditions.AddictedLoserWhore == 1)
        AddictedLoserWhore2.start()
    endIf

endFunction

Function fuckLoserAgain()
    ;RegisterForModEvent("AnimationEnd_FuckLoserEvent","FuckLoserEvent")

    Actor[] actors =  new Actor[2]
    actors[0] = loserWhore.getActorRef()
    actors[1] = winner.getActorRef()
    Handler.fuck(actors ,0, SexLab.GetAnimationsByTags(2,"MF,Vaginal","",true),false).StartThread()
endFunction

Event FuckLoserEvent(string eventName, string argString, float argNum, form sender)
    UnregisterForModEvent("AnimationEnd_FuckLoserEvent")
    if(winner.getRef().Is3DLoaded() && loserWhore.getRef().Is3DLoaded())
        fuckLoserAgain()
    endIf
endEvent

Function endQuest()
    CompleteAllObjectives()
    CompleteQuest()
    Handler.endHomeJob()
endFunction

Function getFinalReward()
    SetObjectiveCompleted(3)
    Handler.GetHomeJobReward()
endFunction

Function SkipScene()
    VisitScene2.Stop()
    startBanging()
endFunction

Function AllowEntry()
    Cell akHouseCell = House.GetRef().GetParentCell()
    HouseOwner  = akHouseCell.GetFactionOwner()
    if(HouseOwner  != None)
        if(!Player.GetActorRef().IsInFaction(HouseOwner))
            PlayerAddedToHouseFaction = true
            Player.GetActorRef().AddToFaction(HouseOwner)
        endif
        Friend.GetActorRef().AddToFaction(HouseOwner)
        Coworker.GetActorRef().AddToFaction(HouseOwner)
    endif
endFunction

Function DisallowEntry()
    if(PlayerAddedToHouseFaction )
        PlayerAddedToHouseFaction = false
        Player.GetActorRef().RemoveFromFaction(HouseOwner)
    endif
endFunction
