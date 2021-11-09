Scriptname mf_prostitute_StableBangQuest extends mf_randomquest  

ReferenceAlias Property Horse  Auto  
ReferenceAlias Property StableMaster  Auto  
ReferenceAlias Property StableMasterBackup  Auto  
ReferenceAlias Property Jarl  Auto  
ReferenceAlias Property MarkarthJarl  Auto  
ReferenceAlias Property WhiterunJarl  Auto  
ReferenceAlias Property WindhelmJarl  Auto  
ReferenceAlias Property MarkarthJarlBed  Auto  
ReferenceAlias Property WhiterunJarlBed  Auto  
ReferenceAlias Property WindhelmJarlBed  Auto  
Actor Property Player  Auto  

MiscObject Property Gold001  Auto  
LeveledItem Property Circlet  Auto  
LeveledItem Property Ring  Auto  
LeveledItem Property Necklace  Auto  

mf_handler Property Handler  Auto  
mf_StableBangVariables Property Variables  Auto  
SexLabFramework Property SexLab  Auto  

int Function getRank()
    return 3
endFunction

bool Function checkConditions()
    ;return SexLab.AllowedCreature(Horse.getActorRef().getRace())
    return true
endFunction

Function StableArousal()
    handler.ResetArousal()
    handler.NoSLSOSatisfaction()
Endfunction

Function evaluatePackages()
    Horse.getActorRef().evaluatePackage()
    StableMaster.getActorRef().evaluatePackage()
    StableMasterBackup.getActorRef().evaluatePackage()
endFunction

Function paymentFullBucket()
    ;this is called when bucked is filled and the Jarl is female
    int baseReward = Handler.HandlerConfig.RandomJobReward
    int reward = ( baseReward * 3 )

    Player.addItem(Gold001, reward);

endFunction


Function paymentFullBucket1()
    ;this is called when bucked is filled and the Jarl is male
    int baseReward = Handler.HandlerConfig.RandomJobReward
    int reward = ( baseReward * 3 )

    Player.addItem(Gold001, reward);

    int random = Utility.RandomInt(1,3)
    while random > 0
        Player.addItem(Circlet, 1);
        random = (random - 1)
    endWhile

    random = Utility.RandomInt(1,3)
    while random > 0
        Player.addItem(Ring, 1);
        random = random - 1
    endWhile
    
    random = Utility.RandomInt(1,3)
    while random > 0
        Player.addItem(Necklace, 1);
        random = random - 1
    endWhile
endFunction

Function paymentHalfFullBucket()
    int baseReward = Handler.HandlerConfig.RandomJobReward
    int reward = baseReward

    Player.addItem(Gold001, reward);

endFunction


Function paymentEmptylBucket()
    int baseReward = Handler.HandlerConfig.RandomJobReward
    int reward = ( baseReward * 0.5 ) As Int

    Player.addItem(Gold001, reward);
    
endFunction


Function moveJarlToBed()
    MarkarthJarl.getActorRef().PathToReference(MarkarthJarlBed.getRef(),1)
    WhiterunJarl.getActorRef().PathToReference(WhiterunJarlBed.getRef(),1)
    WindhelmJarl.getActorRef().PathToReference(WindhelmJarlBed.getRef(),1)
    Jarl.getActorRef().evaluatePackage()
endFunction

Function startHorseRape()
    RegisterForModEvent("AnimationEnd_HorseRape", "HorseRape")
    Actor[] creaturs = new Actor[1]
    creaturs[0] = Horse.getActorRef()
    Handler.PerformCreatureSex(creaturs,"HorseRape")
endFunction

Event HorseRape(string eventName, string argString, float argNum, form sender)
    Variables.HorseRounds +=1

    int chance = Utility.RandomInt(1,100)
    int x = Sexlab.GetSkill(Player,"Creatures")
    
    if(x > 20)
        x=20
    endIf

    ;int totalChance = ( ( x * x ) / 7 ) + x + ( 2 * x / 3 ) + 10
    ; WS edit - 25% chance of fill, we ain't need none of that fancy math formula
    int totalChance = 25

    if(chance <= totalChance)
        if(Variables.BucketFillStand != 2)
            Variables.BucketFillStand +=1
        endIf
        ;Debug.MessageBox("Filled Bucket with cum from your pussy")
        Debug.MessageBox("Fed up with your teasing, the horse mounts you and shoves his huge cock into you, its flared tip slamming painfully into you with every thrust. You barely manage to stay conscious as he pummels you relentlessly, clenching your teeth and groaning. After a while, you feel him pulsing, and your insides are filled to the brim with his cum. The bucket is out of reach, so you try to tighten up to stop from dripping out, but this only makes the horse ram into you with more force.")
        Utility.Wait(0.1)
        Debug.MessageBox("With that final trust, you orgasm and nearly pass out, but manage to hold it together. You try to get the horse off of you, but he's ruthlessly pounding you, pushing cum deeper and deeper inside. You have no choice but to wait for him to get tired, doing your best not to drip as he continues on. Suddenly, he pulls out quickly, rocking your body with another orgasm, but you manage to react and cover yourself with one hand as you quiver on the ground. As you catch your breath, you carefully get up and move to the bucket, sitting on top and releasing your hand, waiting as the cum flows out of you.")
    else
        ;Debug.MessageBox("All cum flowed out of your gaping pussy")
        Debug.MessageBox("Fed up with your teasing, the horse mounts you and shoves his huge cock into you, its flared tip slamming painfully into you with every thrust. You barely manage to stay conscious as he pummels you relentlessly, clenching your teeth and groaning. After a while, you feel him pulsing, and your insides are filled to the brim with his cum. The bucket is out of reach, so you try to tighten up to stop from dripping out, but this only makes the horse ram into you with more force.")
        Utility.Wait(0.1)
        Debug.MessageBox("With that final trust, you orgasm and faint. You slowly regain glimpses of consciousness, vaguely aware the horse is still having his way with you. As you come back to reality, feeling swollen with cum, the horse pulls out of your stretched and clenched hole. With nothing to hold the pressure of cum inside, you gush out like a fountain as another orgasm takes over you, making you black out. You wake up covered in a mix of mud and horse cum, there's nothing left to go on the bucket.")
    endIf

    if(Variables.HorseRounds == 4)
        SetObjectiveCompleted(10)
    endIf

    if(Variables.BucketFillStand ==2)
        setStage(7)
    endIf
    Horse.getActorRef().evaluatePackage()
    UnregisterForModEvent("AnimationEnd_HorseRape")
endEvent 

Function coverTravelExpenses()
    int baseReward = Handler.HandlerConfig.RandomJobReward
    Player.addItem(Gold001, Math.ceiling(Utility.RandomFloat(baseReward *0.5, baseReward)));
    Handler.GetRandomJobReward()
endFunction

Function fuckHostlerOnce(bool doForeplay = true)
    int aggressiveChance = Utility.RandomInt(1,100)

    string agression = "None"

    if(aggressiveChance < 50)
        agression = "Aggressive"
    endIf
    Handler.PerformSex(StableMaster.getActorRef(), "Vaginal",aggr = agression, foreplay = doForeplay)
    Variables.FuckedHostler = 1
endFunction

Function fuckHostlerTwice()
    fuckHostlerOnce(true)
    fuckHostlerOnce(false)
endFunction

Function fuckHostlerAndAssitant()
    fuckHostlerOnce(true)
    int aggressiveChance = Utility.RandomInt(1,100)
    string agression = "None"

    if(aggressiveChance < 50 )
        agression = "Aggressive"
    endIf
    Handler.PerformSex(StableMasterBackup.getActorRef(), "Vaginal", aggr = agression,foreplay = true)
    Handler.PerformThreesome(StableMaster.getActorRef(), StableMasterBackup.getActorRef())
endFunction

Function fuckJarl()
    RegisterForModEvent("AnimationEnd_JarlFuck", "JarlFuck")
    Handler.PerformSex(Jarl.getActorRef(), "Vaginal", next="JarlFuck", foreplay=true)
endFunction

Event JarlFuck(string eventName, string argString, float argNum, form sender)
    Variables.JarlRounds = Variables.JarlRounds + 1
    UnregisterForModEvent("AnimationEnd_JarlFuck")
    Jarl.getActorRef().evaluatePackage()
endEvent 

Function activateHorseLoverMode()
    Variables.HorseLover = 1
endFunction