Scriptname mf_HomePerformanceQuest  extends MF_RandomQuest 

SexLabFramework Property SexLab Auto

ReferenceAlias Property akClientRef Auto
ReferenceAlias Property akHCenterRef Auto

mf_Handler Property Handler Auto
mf_HomePerformanceConditional Property QuestConditional Auto

bool PlayerAddedToHouseFaction = false
Faction HouseFaction = None

; type 0 - oral
; type 1 - anal
; type 2 - vaginal
; type 3 - 3some
; type 6 - Masturbation
; type 7 - Lesbian

int Function getRank()
    return 1
endFunction

Function GetHomeJobReward()
    setStage(100)
    Handler.GetHomeJobReward()
endFunction


Function AllowEntry()
    
    madam.ForceRefTo(handler.akMadame)
    
    Actor akPlayer = Handler.akPlayer
    Cell akHouseCell = akHCenterRef.GetRef().GetParentCell()
    HouseFaction = akHouseCell.GetFactionOwner()
    if(HouseFaction != None)
        if(!akPlayer.IsInFaction(HouseFaction))
            PlayerAddedToHouseFaction = true
            akPlayer.AddToFaction(HouseFaction)
        endif
    else
        Debug.Notification("No faction owns the client's house")
    endif

    QuestConditional.Scene1Type = 6
    
    Actor akClient = akClientRef.GetRef() as Actor
    if(akClient.GetLeveledActorBase().GetSex() == 0) ; male
        QuestConditional.Scene2Type = 0
        QuestConditional.Scene3Type = Utility.RandomInt(1,2)
    ElseIf(akClient.GetLeveledActorBase().GetSex() == 1) ; female
        if(akPlayer.GetActorBase().GetSex() == 0) ; male
            QuestConditional.Scene2Type = 0
            QuestConditional.Scene3Type = Utility.RandomInt(1,2)
        Else
            QuestConditional.Scene2Type = 0
            QuestConditional.Scene3Type = 2
        EndIf
    EndIf
    handler.resetArousal()
    handler.setClientOrgasmActor(akClientRef.GetRef() as Actor)    
EndFunction

Function DisallowEntry()
    Actor akPlayer = Handler.akPlayer
    if(PlayerAddedToHouseFaction)
        akPlayer.RemoveFromFaction(HouseFaction)
    endif
endFunction

Form[] EquipedItems


Function GetNaked()
     EquipedItems = SexLab.StripActor(Handler.akPlayer, doAnimate = false)
endFunction


Function GetDressed()
    SexLab.UnStripActor(Handler.akPlayer, EquipedItems)
endFunction

Event DoNothing(string eventName, string argString, float argNum, form sender)
endEvent

Event Scene1Start(string eventName, string argString, float argNum, form sender)
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    UnregisterForModEvent("AnimationStart_Scene1Start")
endEvent

Event Scene1Finalize(string eventName, string argString, float argNum, form sender)
    SetStage(25)
    handler.evaluatePlayerOrgasm()
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    UnregisterForModEvent("AnimationEnd_Scene1Finalize")
endEvent


Function PerformScene1()
    RegisterForModEvent("AnimationEnd_Scene1Finalize", "Scene1Finalize")
    Handler.PerformMasturbation(Handler.akPlayer as Actor, next = "Scene1Finalize")
endFunction

Event Scene2Start(string eventName, string argString, float argNum, form sender) 
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    UnregisterForModEvent("AnimationStart_Scene2Start")
endEvent

Event Scene2Finalize(string eventName, string argString, float argNum, form sender)
    SetStage(35)
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    UnregisterForModEvent("AnimationEnd_Scene2Finalize")
endEvent


Function PerformScene2()
    RegisterForModEvent("AnimationEnd_Scene2Finalize", "Scene2Finalize")
    Handler.PerformSex(akClientRef.GetRef() as Actor, "Oral", next = "Scene2Finalize")
endFunction

Event Scene3Start(string eventName, string argString, float argNum, form sender)
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    UnregisterForModEvent("AnimationStart_Scene3Start")
endEvent

Event Scene3Finalize(string eventName, string argString, float argNum, form sender)
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    SetStage(41)
    UnregisterForModEvent("AnimationEnd_Scene3Finalize")
endEvent

Function PerformScene3()
    RegisterForModEvent("AnimationEnd_Scene3Finalize", "Scene3Finalize")
    if(QuestConditional.Scene3Type == 1)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Anal", next = "Scene3Finalize",foreplay=true)    
    elseif(QuestConditional.Scene3Type == 2)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Vaginal", next = "Scene3Finalize",foreplay=true)
    elseif(QuestConditional.Scene3Type == 7)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Lesbian", next = "Scene3Finalize",foreplay=true)    
    endif   
endFunction

Function JobSatisfaction()
    handler.SingleHomeClientSatisfaction()
    Setstage(45)
EndFunction


Idle Property IdleAnimation  Auto  

ReferenceAlias Property Madam  Auto 