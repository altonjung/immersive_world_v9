Scriptname mf_HomeJobQuestScript01 extends MF_RandomQuest

SexLabFramework Property SexLab Auto

ReferenceAlias Property akClientRef Auto
ReferenceAlias Property akGuestRef Auto
ReferenceAlias Property akHCenterRef Auto

mf_Handler Property Handler Auto
mf_HomeJobConditional01 Property QuestConditional Auto

bool PlayerAddedToHouseFaction = false
Faction HouseFaction = None

; type 0 - oral
; type 1 - anal
; type 2 - vaginal
; type 3 - 3some

int Function getRank()
    return 1
endFunction

Function GetHomeJobReward()
    setStage(200)
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

    Actor akClient = akClientRef.GetRef() as Actor
    if(akClient.GetLeveledActorBase().GetSex() == 0) ; male
        if(akGuestRef.GetRef() != None)
            QuestConditional.Scene1Type = 3
            QuestConditional.Scene2Type = 3
        else
            QuestConditional.Scene1Type = Utility.RandomInt(0,2)
            QuestConditional.Scene2Type = Utility.RandomInt(1,2)
        endif 
    else ; female
        if(akGuestRef.GetRef() != None)
            QuestConditional.Scene1Type = 3
            QuestConditional.Scene2Type = 3
        else
            QuestConditional.Scene1Type = Utility.RandomInt(0,2)
            QuestConditional.Scene2Type = Utility.RandomInt(1,2)
        endif 
    endif
endFunction


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
    SetStage(15)
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    UnregisterForModEvent("AnimationEnd_Scene1Finalize")
endEvent


Function PerformScene1()
    RegisterForModEvent("AnimationEnd_Scene1Finalize", "Scene1Finalize")
    if(QuestConditional.Scene1Type == 0)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Oral", next = "Scene1Finalize")
    elseif(QuestConditional.Scene1Type == 1)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Anal", next = "Scene1Finalize",foreplay=true)    
    elseif(QuestConditional.Scene1Type == 2)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Vaginal", next = "Scene1Finalize",foreplay=true)
    elseif(QuestConditional.Scene1Type == 3); do try out
        RegisterForModEvent("AnimationStart_Scene1Start", "Scene1Start")
        int performBlowJob1 = Utility.RandomInt(1,100)
        int analChance1 = Utility.RandomInt(1,100)
        int performBlowJob2 = Utility.RandomInt(1,100)
        int analChance2 = Utility.RandomInt(1,100)
        ;Main Client Tryout Start

        Actor akClient = akClientRef.GetRef() as Actor
        bool doForeplay =true
        
        if(akClient.GetLeveledActorBase().GetSex() == 0 && (performBlowJob1 % 2) == 0 );male start with blowjob
            Handler.PerformSex(akClient, "Oral",next = "Scene1Start")
            doForeplay=false
        endif

        
        if((analChance1 % 2) == 0)
            Handler.PerformSex(akClient, "Anal", next = "Scene1Start",foreplay=doForeplay)  
        else
            Handler.PerformSex(akClient, "Vaginal",next = "Scene1Start",foreplay=doForeplay)
        endif
        ;Main Client Tryout end

        ;Guest Tryout Start
        Actor akGuest = akGuestRef.GetRef() as Actor
        doForeplay=true
        if(akGuest.GetLeveledActorBase().GetSex() == 0 && (performBlowJob2 % 2) == 0 );male start with blowjob
            Handler.PerformSex(akGuest, "Oral",next = "DoNothing")
            doForeplay=false
        endif

        if((analChance2 % 2) == 0)
            Handler.PerformSex(akGuest, "Anal", next = "Scene1Finalize",foreplay=doForeplay)    
        else
            Handler.PerformSex(akGuest, "Vaginal", next = "Scene1Finalize",foreplay=doForeplay)
        endif
        ;Guest Tryout end
    endif
endFunction



Event Scene2Finalize(string eventName, string argString, float argNum, form sender)
    ;Game.EnablePlayerControls()
    SetStage(25)
    UnregisterForModEvent("AnimationEnd_Scene2Finalize")
endEvent


Function PerformScene2()
    RegisterForModEvent("AnimationEnd_Scene2Finalize", "Scene2Finalize")

    if(QuestConditional.Scene2Type == 0)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Oral", next = "Scene2Finalize")
    elseif(QuestConditional.Scene2Type == 1)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Anal", next = "Scene2Finalize")  
    elseif(QuestConditional.Scene2Type == 2)
        Handler.PerformSex(akClientRef.GetRef() as Actor, "Vaginal", next = "Scene2Finalize")
    elseif(QuestConditional.Scene2Type == 3)
        Handler.PerformThreesome(akClientRef.GetRef() as Actor, akGuestRef.GetRef() as Actor, next = "Scene2Finalize")
    endif
endFunction




Idle Property IdleAnimation  Auto  

ReferenceAlias Property Madam  Auto  
