Scriptname mf_GiantSacrificeQuest extends MF_Randomquest  

Faction Property GiantFaction  Auto  

ReferenceAlias Property Farmer  Auto  
ReferenceAlias Property Giant1  Auto  
ReferenceAlias Property Giant2  Auto  
ReferenceAlias Property Madam  Auto  

mf_GiantSacrifice_Variables Property Variables  Auto  
mf_handler Property Handler  Auto  
mf_handler_config Property config  Auto  
SexLabFramework Property SexLab  Auto  

ImageSpaceModifier Property FadeIn  Auto  
ImageSpaceModifier Property FadeOut  Auto  
ImageSpaceModifier Property BlackScreen  Auto  

Faction Property WEPlayerEnemy  Auto  

bool anal = false
bool secondGiantDone = false
Form[] farmerEquipment
Actor giant

int Function getRank()
    return 3
endFunction

bool Function checkConditions()
    ;return SexLab.AllowedCreature(Giant1.getActorRef().getRace())
    return true
endFunction

Function GiantArousal()
    handler.ResetArousal()
    handler.NoSLSOSatisfaction()
Endfunction

Function endQuest()
    UnregisterForCrosshairRef()
    Handler.akPlayer.RemoveFromFaction(GiantFaction)
    CompleteAllObjectives()
    completeQuest()
    Handler.GetRandomJobReward()
endFunction

Function failQuest()
    UnregisterForCrosshairRef()
    Handler.akPlayer.RemoveFromFaction(GiantFaction)
    FailAllObjectives()
    FailQuest()
    Handler.GetRandomJobReward()
endFunction

Function setMadame(Actor pimp)
    akMadame = pimp
    Madam.ForceRefTo(pimp)
endFunction

Function fuckFarmHand1()
    ;pay1()
    farmerEquipment = Handler.GetSexLab().StripActor(Farmer.getActorRef(),doAnimate=false)
    Handler.GetSexLab().StripActor(Handler.akPlayer,doAnimate=false)
    Variables.FuckedByFarmHand = 1
    anal = false
    RegisterForModEvent("AnimationEnd_FuckFarmHand", "FuckFarmHand")
    Handler.PerformSex(Farmer.getActorRef(),"Vaginal", next="fuckFarmHand")
endFunction

Function fuckFarmHand2()
    pay2()
    farmerEquipment = Handler.GetSexLab().StripActor(Farmer.getActorRef(),doAnimate=false)
    Handler.GetSexLab().StripActor(Handler.akPlayer,doAnimate=false)
    
    if(Variables.FuckedByFarmHand == 0)
        Handler.PerformSex(Farmer.getActorRef(),"Oral")
    endIf

    Handler.PerformSex(Farmer.getActorRef(),"Vaginal")
    Variables.FuckedByFarmHandAgain = 1
    SetStage(15)
endFunction

Event fuckFarmHand(string eventName, string argString, float argNum, form sender)
    if(!anal)
        anal = true
        Handler.PerformSex(Farmer.getActorRef(),"Anal", next="fuckFarmHand")
    else
        UnregisterForModEvent("AnimationEnd_FuckFarmHand")
        Handler.GetSexLab().UnstripActor(Farmer.getActorRef(),farmerEquipment)
        SetStage(5)
    endIf
    handler.ResetArousal()
endEvent

Function goToCamp()
    handler.ResetArousal()
    Variables.HauledToCamp = 1
    Farmer.getActorRef().evaluatePackage()
    Handler.akPlayer.AddToFaction(GiantFaction)
    Handler.GetSexLab().StripActor(Handler.akPlayer,doAnimate=false)
    Utility.wait(0.5)
    Handler.akPlayer.SetRestrained(true)    
    FadeOut.Apply()
    Utility.Wait(2.5) ; since Fadeout lasts exactly 3.0s, we need to allow some script delay
    FadeOut.PopTo(BlackScreen)
    
    Handler.akPlayer.moveTo(Giant1.getActorRef())
    Debug.SendAnimationEvent(Handler.akPlayer, "ZazAPCAO310")
    
    BlackScreen.PopTo(FadeIn)   
    Utility.Wait(2.0)
    FadeIn.Remove()
    Handler.akPlayer.SetRestrained(false)
    Utility.wait(2)
    
endFunction

Function startFight()
    Variables.Declined = 1;
    SetStage(5)
    Utility.Wait(0.5)
    Handler.akPlayer.RemoveFromFaction(GiantFaction)
    Farmer.getActorRef().AddToFaction(WEPlayerEnemy)
    Farmer.getActorRef().StartCombat(Handler.akPlayer)
endFunction

Function pay1()
    Handler.akPlayer.addItem(Handler.Gold,Config.RandomJobReward)
    Variables.PayedByFarmHand = 1
endFunction

Function pay2()
    If ( Variables.PayedByFarmHand == 1 )
        Handler.akPlayer.addItem(Handler.Gold, Math.Floor((Config.RandomJobReward / 2) * (Variables.AdditionalGiants)))
    Else
        Handler.akPlayer.addItem(Handler.Gold, Math.Floor((Config.RandomJobReward / 2) * (2 + Variables.AdditionalGiants)))
    EndIf
endFunction

Function rape()
    farmerEquipment = Handler.GetSexLab().StripActor(Farmer.getActorRef(),doAnimate=false)
    Handler.GetSexLab().StripActor(Handler.akPlayer,doAnimate=false)
    Variables.FuckedByFarmHand = 1
    Farmer.getActorRef().evaluatePackage()
    anal = false
    RegisterForModEvent("AnimationEnd_FarmHandRape", "FarmHandRape")
    Handler.PerformSex(Farmer.getActorRef(), "Vaginal", aggr="Aggressive", next="FarmHandRape", isPlayerVictim=true)
    ;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
endFunction

Event FarmHandRape(string eventName, string argString, float argNum, form sender)
    if(!anal)
        anal = true
        Handler.PerformSex(Farmer.getActorRef(),"Anal",aggr = "Aggressive", next="FarmHandRape", isPlayerVictim=true)
    else
        Handler.GetSexLab().UnstripActor(Farmer.getActorRef(),farmerEquipment)
        UnregisterForModEvent("AnimationEnd_FarmHandRape")
        goToCamp()
        giantRape1()
    endIf
endEvent

Function giantRape()
    secondGiantDone = false
    Actor[] creature = new Actor[1]
    creature[0] = Giant1.getActorRef()
    RegisterForModEvent("AnimationEnd_GiantRapeEvent", "GiantRapeEvent")
    Handler.PerformCreatureSex(creature,"GiantRapeEvent")
endFunction

Event GiantRapeEvent(string eventName, string argString, float argNum, form sender)
    if(!secondGiantDone)
        Utility.wait(2)
        Giant1.getActorRef().kill(Handler.akPlayer)
        secondGiantDone = true
        Actor[] creature = new Actor[1]
        creature[0] = Giant2.getActorRef()
        Handler.PerformCreatureSex(creature,"GiantRapeEvent")
    else
        Utility.wait(2)
        Giant2.getActorRef().kill(Handler.akPlayer)
        SetStage(10)
        RegisterForCrosshairRef()
        ;Game.EnablePlayerControls()
        UnregisterForModEvent("AnimationEnd_GiantRapeEvent")
    endIf
endEvent


Function giantRape1()
    secondGiantDone = false
    Actor[] creature = new Actor[1]
    creature[0] = Giant1.getActorRef()
    RegisterForModEvent("AnimationEnd_GiantRapeEvent1", "GiantRapeEvent1")
    Handler.PerformCreatureSex(creature,"GiantRapeEvent1")
endFunction

Event GiantRapeEvent1(string eventName, string argString, float argNum, form sender)
    if(!secondGiantDone)
        Utility.wait(2)
        Giant1.getActorRef().kill(Handler.akPlayer)
        secondGiantDone = true
        Actor[] creature = new Actor[1]
        creature[0] = Giant2.getActorRef()
        Handler.PerformCreatureSex(creature,"GiantRapeEvent1")
    else
        Utility.wait(2)
        Giant2.getActorRef().kill(Handler.akPlayer)
        SetStage(10)
        RegisterForCrosshairRef()
        ;Game.EnablePlayerControls()
        UnregisterForModEvent("AnimationEnd_GiantRapeEvent1")
    endIf
endEvent



Function fuckGiant(Actor akGiant)
    giant = akGiant
    Actor[] creature = new Actor[1]
    creature[0] = giant
    RegisterForModEvent("AnimationEnd_FuckGiantEvent", "FuckGiantEvent")
    Handler.PerformCreatureSex(creature,"FuckGiantEvent")
endFunction

Event FuckGiantEvent(string eventName, string argString, float argNum, form sender)
    Utility.wait(2)
    giant.kill(Handler.akPlayer)
    Variables.AdditionalGiants +=1
    UnregisterForModEvent("AnimationEnd_FuckGiantEvent")
endEvent
