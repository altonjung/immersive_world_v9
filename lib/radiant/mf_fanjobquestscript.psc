Scriptname mf_FanJobQuestScript extends MF_RandomQuest

SexLabFramework Property SexLab Auto
mf_FanJobConditional Property QuestConditional Auto
mf_Handler Property Handler Auto
mf_Handler_Config Property Config Auto
Quest Property StuffBack Auto

MiscObject Property Gold Auto

ReferenceAlias Property akPlayerRef Auto
ReferenceAlias Property akChestRef Auto
ReferenceAlias[] Property akGoonRef Auto

GlobalVariable Property GearCost Auto

ObjectReference Property transferChestWhiterunStablesDresser  Auto  

bool GoonInHiding = true
Actor akPlayer

int Function getRank()
    return 3
endFunction

Function FanJobArousal()
    handler.ResetArousal()
    handler.NoSLSOSatisfaction()
Endfunction

Function StripAndGiveItem()

    ; WS - frostfall warm player
    ;Handler.frostfallWarmPlayer()
    
    akPlayer = Handler.akPlayer
    ObjectReference akChest = akChestRef.GetRef()

    if(StuffBack.IsRunning())   
        (StuffBack as mf_GettingStuffQuestScript).MoveLootToInterChest()
    endif
    
    ; WS edits - use whiterunstables chest instead of removing items directly from player (save quest items on player)
    ;clean transfer chest
    transferChestWhiterunStablesDresser.RemoveAllItems(None, false, false)
    ;send all items off to temp chest, leaving quest items behind
    akPlayer.RemoveAllItems(transferChestWhiterunStablesDresser, false, false)

    int totalPrice = 0
    int n = transferChestWhiterunStablesDresser.GetNumItems()
    while(n > 0)
        n -= 1
        Form kForm = transferChestWhiterunStablesDresser.GetNthForm(n)
        if ( (kForm.GetType() == 26 || kForm.GetType() == 41) && kForm.GetGoldValue() > 0 ) ; armor or weapon, non-zeroGold items
            totalPrice += kForm.GetGoldValue()
            transferChestWhiterunStablesDresser.RemoveItem(kForm, transferChestWhiterunStablesDresser.GetItemCount(kForm), true, akChest)
        endIf
    endWhile
    
    ; WS - return remaining items from whiterunstables chest back to player
    transferChestWhiterunStablesDresser.RemoveAllItems(akPlayer, false, false)
    
    int c = GearCost.GetValue() as int
    GearCost.SetValue(c + Math.Floor(totalPrice / 3))
    UpdateCurrentInstanceGlobal(GearCost)

    Debug.Notification("Worn items worth "+totalPrice+" gold")
    
    if(totalprice >= Config.GearCostForTheft)
        QuestConditional.PlayerHasExpensiveGear = 1
    else
        QuestConditional.PlayerHasExpensiveGear = 0
    endif
    
    ; WS - frostfall warm player
    ;Handler.frostfallWarmPlayer()
endFunction


Function GiveValuables()

    ; WS - frostfall warm player
    ;Handler.frostfallWarmPlayer()
    
    if(!StuffBack.IsRunning())
        StuffBack.Start()
    else
        StuffBack.SetStage(0)
    endif
endFunction


Function FanPays100Gold()
    Actor akFan = akGoonRef[0].GetRef() as Actor
    akPlayer = Handler.akPlayer
    akFan.RemoveItem(Gold, 100)
    akPlayer.AddItem(Gold, 100)
    Handler.ResetArousal()
    
    ; WS - frostfall warm player
    ;Handler.frostfallWarmPlayer()
endFunction


Function GetGear()
    ObjectReference akChest = akChestRef.GetRef()

    akChest.RemoveAllItems(akPlayer, true, false)
    GearCost.SetValue(0)
    UpdateCurrentInstanceGlobal(GearCost)
endFunction


Function MoveItemToTarget(Actor target)
    if(StuffBack.IsRunning())
        (StuffBack as mf_GettingStuffQuestScript).TransferItemsToTarget(target)
    else    
        ObjectReference akChest = akChestRef.GetRef()

        akChest.RemoveAllItems(target)
        GearCost.SetValue(0)
        UpdateCurrentInstanceGlobal(GearCost)   
    endif
endFunction


Function OutOfHiding()
 if(GoonInHiding)
    akPlayer = Handler.akPlayer

    float dist = 350.0  
    float dir = akPlayer.GetAngleZ()
    float px = akPlayer.GetPositionX()
    float py = akPlayer.GetPositionY()
    float pz = akPlayer.GetPositionZ()

    int i = 1
    int n = akGoonRef.Length
    float dO = 360.0 / n
    
    While (i < n)
        ObjectReference akGoon = akGoonRef[i].GetRef()
        akGoon.Enable() ; must enable before changing position or nothing happens
        akGoon.SetPosition(px + dist * Math.sin(dir + dO * i), py + dist * Math.cos(dir + dO * i), pz + 75.0)
        i += 1
    endWhile
    GoonInHiding = false
 endif
endFunction


Function StartFight()
    akPlayer = Handler.akPlayer
    ObjectReference akFan = akGoonRef[0].GetRef()
    ObjectReference akChest = akChestRef.GetRef()

    int i = 0
    While (i < akGoonRef.Length)
        Actor akGoon = akGoonRef[i].GetRef() as Actor
        akGoon.StartCombat(akPlayer)
        akGoon.SendAssaultAlarm()
        i += 1
    endWhile
endFunction


int turn = 0
int threesomes=0;
Event NextScene(string eventName, string argString, float argNum, form sender)
    turn += 1
    if(turn < akGoonRef.Length || threesomes < (akGoonRef.Length - (akGoonRef.Length % 2)))
        ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
    endif
    StartRape() 
endEvent


Function StartRape()
    akPlayer = Handler.akPlayer

    if(turn < akGoonRef.Length)
        Actor akGoon = akGoonRef[turn].GetRef() as Actor
    
        if(!akGoon.IsDead() && !akGoon.IsInCombat())
            RegisterForModEvent("AnimationEnd_NextScene", "NextScene")
            int type = Utility.RandomInt(1,100)
            if( (type % 2) == 0)
                Handler.PerformSex(akGoon, "Anal", "Aggressive", "NextScene",true,false)
                ;Handler.PerformRape(akGoon, "Anal", "NextScene")   
            else
                Handler.PerformSex(akGoon, "Vaginal", "Aggressive", "NextScene",true,false)
                ;Handler.PerformRape(akGoon, "Vaginal", "NextScene")    
            endif
        else
            Debug.MessageBox("Radiant Prostitution - Error 1 - Invalid actor")
            StartRape()
        endif
    elseif(turn >= akGoonRef.Length && threesomes < (akGoonRef.Length - (akGoonRef.Length % 2)))
        Handler.PerformThreesome(akGoonRef[threesomes].GetRef() as Actor, akGoonRef[threesomes+1].GetRef() as Actor, "NextScene",true)
        threesomes= threesomes + 2
    else
        UnregisterForModEvent("AnimationEnd_NextScene") 
        Utility.Wait(1.0)
        SetStage(40)
        (akGoonRef[0].GetRef() as Actor).EvaluatePackage()  
        ;Game.EnablePlayerControls()
    endif
endFunction


ImageSpaceModifier Property FadeOut Auto
ImageSpaceModifier Property BlackScreen Auto
ImageSpaceModifier Property FadeIn Auto

Function KnockOut()
        Actor akFan = akGoonRef[0].GetRef() as Actor
    
        Debug.SendAnimationEvent(akFan, "attackStart")
        Game.TriggerScreenBlood(5)
        Debug.SendAnimationEvent(akPlayer, "BleedoutStart")
        akPlayer.SetRestrained(true)    
    
        Utility.Wait(1.0)
        
        FadeOut.Apply()
        Utility.Wait(2.5) ; since Fadeout lasts exactly 3.0s, we need to allow some script delay
        FadeOut.PopTo(BlackScreen)
        
        int i = 0
        While (i < akGoonRef.Length)
            akGoonRef[i].GetRef().Disable()
            i += 1
        endWhile
        
        BlackScreen.PopTo(FadeIn)   
        Utility.Wait(2.0)       
        FadeIn.Remove()     
        
        Debug.SendAnimationEvent(akPlayer, "BleedoutStop")
        akPlayer.SetRestrained(false)
        ;Game.EnablePlayerControls()
        
        SetStage(100)
        
        ; WS - frostfall warm player
        ;Handler.frostfallWarmPlayer()
endFunction

Function WSEndFanQuest()

    ;this should be called when FanJob hits stage 100, but give it 10 seconds to show the player the objective pop-ups
    Utility.Wait(10)
    Handler.GetRandomJobReward()
EndFunction
