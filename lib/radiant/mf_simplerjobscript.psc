Scriptname mf_SimplerJobScript extends Quest  

mf_Handler Property Handler Auto
mf_Handler_Config Property HandlerConfig Auto
mf_SimplerJobVariables Property QuestConditional Auto

MiscObject Property gold Auto
Keyword Property ArmorKeyword Auto

Potion Property VenisonStew Auto
Potion Property LoafofBread Auto
Potion Property SalmonSteak Auto
Potion Property Ale Auto
Potion Property Wine Auto
Potion Property Sweetroll Auto
Idle Property OffsetCarryMQ201DrinkTray  Auto  
Idle Property IdleWave  Auto  

Potion[] FoodList
int[] orderList
int[] ActualItems

int amount
int tip
int count = 0
int[] Correct


Event OnInit()
    FoodList = new Potion[6]
    FoodList[0] = VenisonStew
    FoodList[1] = LoafofBread
    FoodList[2] = SalmonSteak
    FoodList[3] = Ale
    FoodList[4] = Wine
    FoodList[5] = Sweetroll
    
    ActualItems = new int[3]
    orderList = new int[3]
    Correct = new int[3]
endEvent

Function SimplerArousalReset()
    handler.ResetArousal()
EndFunction

Function TakeOrderNo(int order)
    if(order == 0)
        orderList[0] = 0
        orderList[1] = 1
        orderList[2] = 3
    elseif(order == 1)
        orderList[0] = 2
        orderList[1] = 4
        orderList[2] = 5
    elseif(order == 2)
        orderList[0] = 1
        orderList[1] = 4
        orderList[2] = 3
    endif
    
    count = 0
    Correct[0] = 0
    Correct[1] = 0
    Correct[2] = 0
endFunction


Function GetFooditem(int food)
    if count >= 3
        Debug.Notification("Your hands are full...")
        Return
    endif

    Actor akPlayer = Handler.akPlayer

    if(orderList[0] == food)
        Correct[0] = 1
    elseif(orderList[1] == food)
        Correct[1] = 1
    elseif(orderList[2] == food)
        Correct[2] = 1
    else
        ; Debug.Notification("food not in the list")
    endif

    ActualItems[count] = food
    akPlayer.additem(FoodList[food], 1)
    count += 1

    QuestConditional.Success = Correct[0] + Correct[1] + Correct[2]
endFunction



Function GiveFoodItem()
    Actor akPlayer = Handler.akPlayer
    amount = 0

    int i = count
    While(i)
        i -= 1
        akPlayer.removeitem(FoodList[ActualItems[i]], 1)
        amount += FoodList[ActualItems[i]].GetGoldValue() * 3
    EndWhile

    tip = Math.Floor(akPlayer.GetAV("Speechcraft") * HandlerConfig.GoldBonusPerSpeechcraft * HandlerConfig.TipModifier)
    if(!akPlayer.WornHasKeyword(ArmorKeyword))
        tip += 5
    endif
    amount += tip
    if(QuestConditional.Success == 3)
        FoodList[ActualItems[0]].GetGoldValue()
        akPlayer.Additem(gold, amount)
    endif

    Game.AdvanceSkill("Speechcraft", 250.0)
endFunction


Function GetTip()
    Actor akPlayer = Handler.akPlayer
    
    if(QuestConditional.Success == 3)
        akPlayer.RemoveItem(gold, amount)
        akPlayer.Additem(gold, tip)
    endif
endFunction


Function EquipFoodTray()
    Game.ForceThirdPerson()
    Utility.Wait(0.2)
    Handler.akPlayer.PlayIdle(OffsetCarryMQ201DrinkTray)
EndFunction


Function UnequipFoodTray()
    Game.ForceThirdPerson()
    Utility.Wait(0.2)
    Handler.akPlayer.PlayIdle(OffsetCarryMQ201DrinkTray) ;ensure the player is holding tray before wave animation is played
    Utility.Wait(0.5)
    Handler.akPlayer.PlayIdle(IdleWave)
EndFunction





