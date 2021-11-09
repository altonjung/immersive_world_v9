Scriptname mf_GettingStuffQuestScript extends Quest

SexLabFramework Property SexLab  Auto  
mf_GettingStuffConditional Property QuestConditional Auto
mf_Handler_Config Property Config Auto
mf_Handler Property Handler Auto

ReferenceAlias Property akPlayerRef Auto
ReferenceAlias Property akLootChestRef Auto
ReferenceAlias Property akInterChestRef Auto 
ReferenceAlias Property akVendorChestRef Auto
ReferenceAlias Property akVendorRef Auto

GlobalVariable Property LootGearCost Auto
GlobalVariable Property VendorGearCost Auto

MiscObject Property Gold Auto 
ObjectReference Property transferChestWhiterunStablesDresser  Auto  

int GoldStolen = 0
int InterChestGearCost = 0
float StartTime = 0.0
Form[] VendorEquipment


Function VendorFound(Actor akSpeaker)
	akVendorRef.ForceRefTo(akSpeaker)
	
	;dump loot and inter chest into vendor chest
	ObjectReference akLootChest = akLootChestRef.GetRef()
	ObjectReference akInterChest = akInterChestRef.GetRef()
	ObjectReference akVendorChest = akVendorChestRef.GetRef()
	akLootChest.RemoveAllItems(akVendorChest, true, false)
	akInterChest.RemoveAllItems(akVendorChest, true, false)
	
	;update gear cost
	int c = VendorGearCost.GetValueInt()
	VendorGearCost.SetValue(c + InterChestGearCost + LootGearCost.GetValueInt())
	LootGearCost.SetValue(0)
	UpdateCurrentInstanceGlobal(VendorGearCost)

	InterChestGearCost = 0
	
	QuestConditional.FoundVendor = 1
	QuestConditional.OpenedInventory = 0
endFunction
	
	
Function OpenInventory()
	if(QuestConditional.OpenedInventory == 0)
		QuestConditional.OpenedInventory = 1
		StartTime = Utility.GetCurrentGameTime()	
		RegisterForSingleUpdateGameTime(1.0)
	endif
	
	ObjectReference akVendorChest = akVendorChestRef.GetRef()
	Actor akPlayer = akPlayerRef.GetRef() as Actor
	akVendorChest.Activate(akPlayer)	
endFunction


Event OnUpdateGameTime()
 	if(StartTime +  Config.TimeToPayStuff <= Utility.GetCurrentGameTime())
		Actor akVendor = akVendorRef.GetRef() as Actor
		akVendor.GetCrimeFaction().ModCrimeGold(VendorGearCost.GetValueInt())
		Debug.Notification("You didn't pay for your gear in time, a bounty has been put on your head!")
		Debug.Notification("Any items still with the merchant have been sold off.")
		DumpItemsFromChest()
	Else
		RegisterForSingleUpdateGameTime(1.0)
	endif
endEvent
	

Function MoveLootToInterChest()
	ObjectReference akLootChest = akLootChestRef.GetRef()
	ObjectReference akInterChest = akInterChestRef.GetRef()	

	akLootChest.RemoveAllItems(akInterChest, true, false)
	InterChestGearCost += LootGearCost.GetValueInt()
	LootGearCost.SetValue(0)
endFunction


Function RemoveValuables()
	ObjectReference akLootChest = akLootChestRef.GetRef()
	ObjectReference akInterChest = akInterChestRef.GetRef()	
	
	Actor akPlayer = akPlayerRef.GetRef() as Actor
	
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
		if(kForm.GetGoldValue() >= Config.ItemCostForTheft)
			totalPrice += kForm.GetGoldValue()
			transferChestWhiterunStablesDresser.RemoveItem(kForm, transferChestWhiterunStablesDresser.GetItemCount(kForm), true, akLootChest)
		endIf
	endWhile
	
	; WS - return remaining items from whiterunstables chest back to player
	transferChestWhiterunStablesDresser.RemoveAllItems(akPlayer, false, false)
	
	int c = LootGearCost.GetValueInt()
	LootGearCost.SetValue(c + Math.Floor(totalPrice / 3))
	UpdateCurrentInstanceGlobal(LootGearCost)

	GoldStolen = (akPlayer.GetItemCount(Gold) * (Config.PercGoldTheft / 100)) as int
	akPlayer.RemoveItem(Gold, GoldStolen)
endFunction



Function PerformSex(Actor akSpeaker) 
	string jobtyp = calcCostAndReturnJobTyp()
	QuestConditional.HasGivenSex = 1
 	Handler.PerformSex(akSpeaker, jobtyp)
endFunction

Function payWithSex()
	RegisterForModEvent("AnimationEnd_NextScene", "Pay")
	Actor player = akPlayerRef.getActorRef()
	Faction owner = player.getParentCell().GetFactionOwner()
	player.AddToFaction(owner)
	string jobtyp = calcCostAndReturnJobTyp()

	int random = Utility.RandomInt(0,100) % 3

	string aggressive = "None"

	if(random == 0)
		aggressive = "Aggressive"
	endIf

	VendorEquipment = SexLab.StripActor(akVendorRef.getActorRef(), doAnimate=false)

	Handler.PerformSex(akVendorRef.getActorRef(), jobtyp, aggressive,"NextScene")
	;Game.DisablePlayerControls(1, 1, 0, 0, 0, 0, 1)
	QuestConditional.PayedWithSex = 1
endFunction

Event Pay(string eventName, string argString, float argNum, form sender)
	int cost = VendorGearCost.GetValue() as int

	if(cost > 0)
		Debug.Notification(cost+" Gold left to pay")
		payWithSex()
	else
		Debug.Notification("No more Gold left to pay")
		UnregisterForModEvent("AnimationEnd_NextScene") 
		;Game.EnablePlayerControls()
		SexLab.UnstripActor(akVendorRef.getActorRef(), VendorEquipment)
		Actor player = akPlayerRef.getActorRef()
		Faction owner = player.getParentCell().GetFactionOwner()
		player.RemoveFromFaction(owner)
	endIf
	
endEvent

string Function calcCostAndReturnJobTyp()
	int cost = VendorGearCost.GetValue() as int
	string jobtyp
	int random = Utility.RandomInt(0,100) % 3
 	if(random == 0)
 		jobtyp =  "Oral"
 	elseif(random == 1)
 		jobtyp =  "Vaginal"
 	else
 		jobtyp =  "Anal"
 	endIf
 	int sub  = Handler.CalcReward(1.0, 1.0, jobtyp)

 	if(cost > sub)
 		VendorGearCost.SetValue(cost - sub)
	else
		VendorGearCost.SetValue(0)
	endif
	UpdateCurrentInstanceGlobal(VendorGearCost)
	return jobtyp
endFunction


Function TransferItemsToPlayer()
	ObjectReference akLootChest = akLootChestRef.GetRef()
	ObjectReference akInterChest = akInterChestRef.GetRef()
	ObjectReference akVendorChest = akVendorChestRef.GetRef()
	Actor akPlayer = akPlayerRef.GetRef() as Actor
	Actor akVendor = akVendorRef.GetRef() as Actor
	
	akVendorChest.RemoveAllItems(akPlayer, true, false)
	akPlayer.RemoveItem(Gold, VendorGearCost.GetValue() as int)
	akVendor.AddItem(Gold, VendorGearCost.GetValue() as int)
	
	VendorGearCost.SetValue(0)
	UpdateCurrentInstanceGlobal(VendorGearCost)
	
	QuestConditional.FoundVendor = 0
	QuestConditional.OpenedInventory = 0
	Stop()
	if(akLootChest.GetNumItems() == 0 && akInterChest.GetNumItems() == 0 )
		
	endif
endFunction


Function TransferItemsToTarget(Actor akTarget)
	ObjectReference akLootChest = akLootChestRef.GetRef()
	ObjectReference akInterChest = akInterChestRef.GetRef()
	ObjectReference akVendorChest = akVendorChestRef.GetRef()
	
	akLootChest.RemoveAllItems(akTarget, true, false)
	akTarget.AddItem(Gold, GoldStolen)
	
	GoldStolen = 0
		
	LootGearCost.SetValue(0)
	UpdateCurrentInstanceGlobal(LootGearCost)	
	
	if(akInterChest.GetNumItems() == 0 && akVendorChest.GetNumItems() == 0 )
		Stop()
	endif
endFunction


Function DumpItemsFromChest()
	ObjectReference akLootChest = akLootChestRef.GetRef()
	ObjectReference akInterChest = akInterChestRef.GetRef()
	ObjectReference akVendorChest = akVendorChestRef.GetRef()
	
	akVendorChest.RemoveAllItems()
	
	VendorGearCost.SetValue(0)
	UpdateCurrentInstanceGlobal(VendorGearCost)	
	
	QuestConditional.FoundVendor = 0
	QuestConditional.OpenedInventory = 0
		
	if(akLootChest.GetNumItems() == 0 && akInterChest.GetNumItems() == 0 )
		Stop()
	endif
endFunction


Function ResetChests()
	ObjectReference akLootChest = akLootChestRef.GetRef()
	ObjectReference akInterChest = akInterChestRef.GetRef()
	ObjectReference akVendorChest = akVendorChestRef.GetRef()
	Actor akPlayer = akPlayerRef.GetRef() as Actor
	
	akLootChest.RemoveAllItems(akPlayer, true, false)
	akInterChest.RemoveAllItems(akPlayer, true, false)	
	akVendorChest.RemoveAllItems(akPlayer, true, false)
	
	LootGearCost.SetValue(0)
	UpdateCurrentInstanceGlobal(LootGearCost)
	
	VendorGearCost.SetValue(0)
	UpdateCurrentInstanceGlobal(VendorGearCost)
	
	Stop()
endFunction
