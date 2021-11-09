Scriptname mf_companionRape_Quest extends mf_randomquest  

Actor Property Player  Auto  
Potion Property customBrew  Auto
ReferenceAlias[] Property Rapists  Auto
ReferenceAlias Property Client  Auto  
ReferenceAlias Property theMadame  Auto  

mf_handler Property Handler  Auto  
SexLabFramework Property SexLab  Auto  

Faction Property WerewolfFaction  Auto  
Faction Property WolfFaction  Auto  

MiscObject Property Gold  Auto  
LeveledItem Property FOOD  Auto  
LeveledItem Property Sweets  Auto  

int currentRapistIndex = 0

ImageSpaceModifier Property BlackScreen  Auto  
ImageSpaceModifier Property FadeIn  Auto  
ImageSpaceModifier Property FadeOut  Auto  

Location Property WhiterunHoldLocation  Auto  

int Function getRank()
    return 3
endFunction

Function setMadame(Actor pimp)
    akMadame = pimp
    theMadame.ForceRefTo(pimp)
endFunction

bool Function checkConditions()
    ;return SexLab.AllowedCreature(Rapists[0].getActorRef().getRace()) && SexLab.AllowedCreature(Rapists[1].getActorRef().getRace())
    
    If ( Player.IsInLocation(WhiterunHoldLocation) )
        Debug.Trace("[Radiant Prostitution] Companion Quest conditions: player is in Whiterun = true")
        return true
    ElseIf ( Utility.RandomInt(1,100) < 50 )
        Debug.Trace("[Radiant Prostitution] Companion Quest conditions: player is in Whiterun = false, but selected by random roll.")
        return true
    EndIf
    
    Debug.Trace("[Radiant Prostitution] Companion Quest conditions: player is in Whiterun = false, failing condition check.")
    return false
    
endFunction

Function CompanionArousal()
    handler.ResetArousal()
    handler.NoSLSOSatisfaction()
Endfunction

Function addCustomBrew()
    Player.addItem(customBrew  ,1)
endFunction


Function stripBlackOutAndTeleport()
    SexLab.stripActor(Player)
    Utility.Wait(1.0)
    Player.addToFaction(WerewolfFaction)
    Player.addToFaction(WolfFaction)
    setStage(20)
    blackOutAndTeleport(Rapists[0].GetActorRef())
endFunction

Function blackOutAndTeleportBack()
    blackOutAndTeleport(Client.GetActorRef())
    setStage(30)
    Player.removeFromFaction(WerewolfFaction)
    Player.removeFromFaction(WolfFaction)
endFunction

Function blackOutAndTeleport(Actor act)
    Debug.SendAnimationEvent(Player, "BleedoutStart")

    Utility.Wait(1.0)
        
    FadeOut.Apply()
    Utility.Wait(2.5) ; since Fadeout lasts exactly 3.0s, we need to allow some script delay
    FadeOut.PopTo(BlackScreen)
    
    Player.moveTo(act,abMatchRotation = false)
    Utility.Wait(2.5) 

    BlackScreen.PopTo(FadeIn)   
    Utility.Wait(2.0)       
    FadeIn.Remove() 
    Debug.SendAnimationEvent(Player, "BleedoutStop")
endFunction

Function initRape()
    setStage(21)
    
    Utility.Wait(1.0)
    currentRapistIndex = 0
    RegisterForModEvent("AnimationEnd_NextScene", "NextScene")
    rape()
endFunction

Function rape()
    Actor[] actors = new Actor[1]
    actors [0]=Rapists[currentRapistIndex].GetActorRef()
    Handler.PerformCreatureSex(actors,"NextScene")
    Debug.Trace("[Radiant Prostitution] Waiting for Event to start the next Act")
endFunction

Event NextScene(string eventName, string argString, float argNum, form sender)
    Debug.Trace("[Radiant Prostitution] Caught NextScene Event")

    if(currentRapistIndex < Rapists.length - 1)
        Debug.Trace("[Radiant Prostitution] currentRapistIndex=" + currentRapistIndex + " Rapists.length=" + Rapists.length)
        currentRapistIndex +=1
        rape()
    else
        Debug.Trace("[Radiant Prostitution] Last actor processed, sending player back.")
        UnregisterForModEvent("AnimationEnd_NextScene")
        blackOutAndTeleportBack()
    endIf
    
endEvent

Function getPayment()
    int i = 10
    While i > 0
        i -= 1
        Player.AddItem(FOOD, 1, true)
    endWhile

    i = 3
    While i > 0
        i -= 1
        Player.AddItem(Sweets, 1, true)
    endWhile

    int reward = Handler.HandlerConfig.RandomJobReward
    int amount = Utility.RandomInt(reward, reward*2)
    Player.AddItem(Gold, amount)
    setStage(40)
    Handler.GetRandomJobReward()
endFunction

Function EndQuest()
    Handler.GetRandomJobReward()
endFunction


