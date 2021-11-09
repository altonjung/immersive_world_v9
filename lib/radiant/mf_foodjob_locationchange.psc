Scriptname MF_FoodJob_LocationChange extends ReferenceAlias  

mf_handler_config Property HandlerConfig  Auto  

MF_FoodJob_Conditionals Property FoodJobConditional  Auto  

mf_FoodJob Property FoodJob  Auto  

Event onLocationChange(Location oldOne, Location newOne)
	if(HandlerConfig.RestrictToTown && (FoodJobConditional.totalCost > 0   || FoodJobConditional.GoldFromSex > 0  ))
		FoodJob.addBounty(5)
		FoodJob.addBountyForSex(5)
		FoodJob.endQuest()
	endIf
endEvent

