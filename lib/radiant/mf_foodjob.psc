Scriptname mf_FoodJob extends mf_randomquest  

;Public
MF_FoodJob_Conditionals Property Conditionals  Auto  
MiscObject Property Gold  Auto  
LeveledItem Property FOOD  Auto  

GlobalVariable Property LetItSlide  Auto
GlobalVariable Property MissingMoney  Auto

Keyword Property JobWhore  Auto  

ReferenceAlias[] Property FoodAliases  Auto  
ReferenceAlias Property FoodChest  Auto  
ReferenceAlias Property HungryOne  Auto  

mf_handler_config Property HandlerConfig  Auto  
mf_handler Property Handler  Auto 

;Private
int[] foodIndex
int payment = 0
int retryCounter = 0
int sexType = 0

Function setMadame(Actor pimp)
	akMadame = pimp
endFunction

Function setPhase(int phaseToSet)
	Conditionals.Phase = phaseToSet
endFunction

Function setSexType(int typeToSet)
	sexType  = typeToSet
endFunction

Function endQuest()
	Handler.ResetMadame()
	stop()
endFunction

Function DontLetItSlideAgain()
	if(LetItSlide.GetValue() == 0)
		LetItSlide.setValue(1)
		UpdateCurrentInstanceGlobal(LetItSlide)
	endIf
endFunction

Function initFood()
	ObjectReference chest = FoodChest.getRef()
	chest.RemoveAllItems()
	int itemCount = 0
	int trys = 0
	while(itemCount < 5 && trys < 50)
		chest.addItem(FOOD ,1)
		trys +=1
		itemCount = chest.GetNumItems()
	endWhile
	
	int i = 0
	int j = 0	
	int max = 0
	Form item = none
	
	while(i < 5)
		while (j < itemCount)	
			Form tempItem =  chest.GetNthForm(j)
			int tempCount = chest.getItemCount(tempItem)
			if(tempCount > max)
				item = tempItem
				max = tempCount
			endIf
			j += 1
		endWhile

		ObjectReference ref = chest.placeAtMe(item,1)
		FoodAliases[i].ForceRefTo(ref)
		chest.RemoveItem(item,max)
		itemCount = chest.GetNumItems()
		ref.delete()
		max = 0
		item  = none
		i += 1
		j = 0
	endWhile
	Conditionals.Phase = 1
endFunction

int Function checkClothsState()
	Form armorForm = Game.GetPlayer().GetWornForm(0x00000004)
	if(Game.GetPlayer().WornHasKeyword(JobWhore) || HandlerConfig.WorkingClothes.hasForm(armorForm))
		Conditionals.WearesWorkingCloths = 1
	else
		Conditionals.WearesWorkingCloths = 0
	endIf
	return Conditionals.WearesWorkingCloths
endFunction

Function setFoodIndex(int index0, int index1, int index2)
	foodIndex = new Int[3]
	foodIndex[0] = index0
	foodIndex[1] = index1
	foodIndex[2] = index2
	int bonus = Math.Floor(Game.getPlayer().GetAV("Speechcraft") * HandlerConfig.GoldBonusPerSpeechcraft)
	payment += FoodAliases[foodIndex[0]].getRef().getGoldValue() + bonus
	payment += FoodAliases[foodIndex[1]].getRef().getGoldValue() + bonus
	payment += FoodAliases[foodIndex[2]].getRef().getGoldValue() + bonus
	Conditionals.Phase = 10
endFunction

Function addFoodItem(int index)
	int bonus = Math.Floor(Game.getPlayer().GetAV("Speechcraft") * HandlerConfig.GoldBonusPerSpeechcraft)	
	Game.GetPlayer().addItem(FoodAliases[Index].getRef(),1)
	Conditionals.totalCost += FoodAliases[Index].getRef().GetGoldValue() +  bonus 
endFunction

Function checkForMissingStuff()
	Conditionals.MissingFood = -1
	int foodIndex0Count = Game.GetPlayer().GetItemCount(FoodAliases[foodIndex[0]].getRef())
	int foodIndex1Count = Game.GetPlayer().GetItemCount(FoodAliases[foodIndex[1]].getRef())
	int foodIndex2Count = Game.GetPlayer().GetItemCount(FoodAliases[foodIndex[2]].getRef())

	if(foodIndex0Count < 1 || foodIndex1Count < 1 || foodIndex2Count < 1)
		Conditionals.MissingFood = 0
		retryCounter += 1
	endIf
	Conditionals.Phase = 11
endFunction

Function GetPayed()
	if(retryCounter < 1)
		int tip = 0
		if(checkClothsState() == 1)
			tip = Math.ceiling( (payment  * Utility.RandomFloat(20,30)) / 100)
		else
			tip = Math.ceiling( (payment  * Utility.RandomFloat(10,15)) / 100)
		endIf
		payment += tip 
	endIf

	int i = 0
	while(i < retryCounter)
		i += 1
		payment -= Math.floor(payment  * 0.15)
	endWhile
	
	Game.GetPlayer().addItem(Gold,payment)
	payment  = 0
	retryCounter = 0
	Conditionals.Phase = 1
	HungryOne.Clear()
endFunction

Function payForFood(Actor speaker)
	int goldCount = Game.GetPlayer().GetItemCount(Gold)
	if(goldCount < Conditionals.totalCost)
		Conditionals.totalCost -= goldCount
		MissingMoney.mod(Conditionals.totalCost) 
		UpdateCurrentInstanceGlobal(MissingMoney)
		Conditionals.totalCost = goldCount
	endIf

	Game.GetPlayer().removeItem(Gold, Conditionals.totalCost)
	speaker.addItem(Gold, Conditionals.totalCost)
	Conditionals.totalCost = 0
endFunction

Function cheat(Actor speaker)
	float speechcraft = Game.GetPlayer().GetAV("Speechcraft")
	float cheatPercent = 0.005 * speechcraft
	if(cheatPercent > 0.5)
		cheatPercent = 0.5
	endIf
	Conditionals.totalCost = Math.Floor(Conditionals.totalCost * cheatPercent)

	int goldCount = Game.GetPlayer().GetItemCount(Gold)
	if(goldCount < Conditionals.totalCost)
		Conditionals.totalCost -= goldCount
		MissingMoney.mod(Conditionals.totalCost) 
		UpdateCurrentInstanceGlobal(MissingMoney)
		Conditionals.totalCost = goldCount
	endIf

	Game.GetPlayer().removeItem(Gold, Conditionals.totalCost)
	speaker.addItem(Gold, Conditionals.totalCost)
	Conditionals.totalCost = 0
endFunction

Function payForCustomers(Actor speaker)
	int share = Math.floor((Conditionals.GoldFromSex * HandlerConfig.BaseGoldMadameCut) / 100)
	int goldCount = Game.GetPlayer().GetItemCount(Gold)
	if(goldCount < share)
		share -= goldCount
		MissingMoney.mod(share) 
		UpdateCurrentInstanceGlobal(MissingMoney)
		share = goldCount
	endIf

	Game.GetPlayer().removeItem(Gold, share)
	speaker.addItem(Gold, share )
	Conditionals.GoldFromSex = 0
endFunction

Function cheatOnCustomers(Actor speaker)
	float speechcraft = Game.GetPlayer().GetAV("Speechcraft")
	float cheatPercent = 0.005 * speechcraft
	if(cheatPercent > 0.5)
		cheatPercent = 0.5
	endIf
	float cheatedGold = Conditionals.GoldFromSex * cheatPercent 
	int share = Math.floor((cheatedGold  * HandlerConfig.BaseGoldMadameCut) / 100)
	int goldCount = Game.GetPlayer().GetItemCount(Gold)
	
	if(goldCount < share)
		share -= goldCount
		MissingMoney.mod(share)
		UpdateCurrentInstanceGlobal(MissingMoney) 
		share = goldCount
	endIf

	Game.GetPlayer().removeItem(Gold, share)
	speaker.addItem(Gold, share)
	Conditionals.GoldFromSex = 0
endFunction


Function addBounty(float multi)
	akMadame.GetCrimeFaction().ModCrimeGold( Math.Floor(Conditionals.totalCost * multi))
	Debug.Notification( Math.Floor(Conditionals.totalCost * multi)+"gold bounty added")
	Handler.TriggerFailCD()
endFunction

Function addBountyForSex(float multi)
	akMadame.GetCrimeFaction().ModCrimeGold( Math.Floor(Conditionals.GoldFromSex * multi))
	Debug.Notification( Math.Floor(Conditionals.GoldFromSex * multi)+"gold bounty added")
	Handler.TriggerFailCD()
endFunction

Function fuck()
	int bonus = Math.Floor(Game.getPlayer().GetAV("Speechcraft") * HandlerConfig.GoldBonusPerSpeechcraft)
	String type = ""
	if(sexType == 1)
		type = "Oral"
		Game.GetPlayer().addItem(Gold, bonus)
		Conditionals.GoldFromSex += bonus 
	elseif(sexType == 2)
		type = "vaginal"
		Game.GetPlayer().addItem(Gold, (5 * bonus))
		Conditionals.GoldFromSex += (5 * bonus)
	elseif(sexType == 3)
		type = "anal"
		Game.GetPlayer().addItem(Gold, (2 * bonus))
		Conditionals.GoldFromSex += (2 * bonus) 
	endIf
	Handler.PerformSex(HungryOne.getActorRef(), type,foreplay=true)
	Conditionals.Phase = 1
	HungryOne.TryToEvaluatePackage()
	HungryOne.Clear()
endFunction

Function AddInitClothes()
	Handler.AddInitClothes()
endFunction
  
