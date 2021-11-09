Scriptname mf_homegangbangquestscript extends MF_RandomQuest  

SexLabFramework Property SexLab Auto

ReferenceAlias Property akClientRef Auto
ReferenceAlias Property akGuestRef Auto
ReferenceAlias Property akHCenterRef Auto

mf_Handler Property Handler Auto
mf_HomeGangbangConditional Property QuestConditional Auto

Idle Property IdleAnimation  Auto  
ReferenceAlias Property Madam  Auto  

ReferenceAlias Property Guest1  Auto  
ReferenceAlias Property Guest2  Auto  
ReferenceAlias Property Guest3  Auto  

bool PlayerAddedToHouseFaction = false
Faction HouseFaction = None

int Property roundsCounter = 0 Auto


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
        Guest1.GetActorRef().AddToFaction(HouseFaction)
        Guest2.GetActorRef().AddToFaction(HouseFaction)
        Guest3.GetActorRef().AddToFaction(HouseFaction)
    else
        Debug.Notification("No faction owns the client's house")
    endif
    handler.ResetArousal()
    handler.StripExposure(akClientRef.GetRef() as Actor, 25)
    handler.StripExposure(Guest1.GetRef() as Actor, 25)
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


Event HomeGangbangRoundFinished(string eventName, string argString, float argNum, form sender)
    if roundsCounter < 3
        PerformScene1()
    Else
        UnregisterForModEvent("AnimationEnd_Scene1Finalize")
        SetStage(21)
    EndIf
endEvent

Function finalEval()
    handler.MultipleHomeClientSatisfaction()
    SetStage(25)
EndFunction


Function PerformScene1()
    Utility.wait(1)
    roundsCounter += 1
    Actor a1
    Actor a2
    
    if ( roundsCounter % 2 == 0 )
        a1 = Guest2.GetActorRef()
        handler.setClientOrgasmActor(Guest2.GetRef() as Actor)
        a2 = Guest3.GetActorRef()
        handler.setGuestOrgasmActor(Guest3.GetRef() as Actor)
    Else
        a1 = akClientRef.GetActorRef()
        handler.setClientOrgasmActor(akClientRef.GetRef() as Actor)
        a2 = Guest1.GetActorRef()
        handler.setGuestOrgasmActor(Guest1.GetRef() as Actor)
    EndIf
    
    RegisterForModEvent("AnimationEnd_HomeGangbang", "HomeGangbangRoundFinished")
    Handler.PerformThreesome(a1, a2, next="HomeGangbang", isPlayerVictim=false)

endFunction




