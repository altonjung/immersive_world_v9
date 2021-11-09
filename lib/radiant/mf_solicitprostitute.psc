Scriptname mf_SolicitProstitute extends Quest  

SexLabFramework Property SexLab Auto

mf_SolicitVariables Property SolicitConditional Auto
mf_Handler Property Handler Auto
mf_Handler_Config Property HandlerConfig Auto

ReferenceAlias Property akPlayerRef Auto
ReferenceAlias Property akProstituteRef Auto

GlobalVariable Property TimesPayForSex Auto
MiscObject Property Gold  Auto  

Actor akPlayer
Actor akProstitute
string akTypeRequested

int TotalCostForO = 0
int TotalCostForA = 0
int TotalCostForV = 0



Function CalculateCost(Actor Speaker)
 float BG = HandlerConfig.NPCBaseGoldCost
 float SM = Speaker.GetAV("Speechcraft")
 TotalCostForO = Math.Floor((BG + SM) * HandlerConfig.OralModifier)
 TotalCostForA = Math.Floor((BG + SM) * HandlerConfig.AnalModifier)
 TotalCostForV = Math.Floor((BG + SM) *  HandlerConfig.VaginalModifier)
 
 akPlayer =  akPlayerRef.GetRef() as Actor
 if(akPlayer.GetItemCount(Gold) >= TotalCostForO)
	SolicitConditional.PlayerHasGoldForO = 1
 else
 	SolicitConditional.PlayerHasGoldForO = 0
 endif
 if(akPlayer.GetItemCount(Gold) >= TotalCostForA)
	SolicitConditional.PlayerHasGoldForA = 1
 else
 	SolicitConditional.PlayerHasGoldForA = 0
 endif
 if(akPlayer.GetItemCount(Gold) >= TotalCostForV)
	SolicitConditional.PlayerHasGoldForV = 1
 else
 	SolicitConditional.PlayerHasGoldForV = 0
 endif
endFunction


Function FollowMe(Actor Speaker, string typeRequested)
  akPlayer = akPlayerRef.GetRef() as Actor
  akProstituteRef.ForceRefTo(Speaker)
  akProstitute = Speaker

 akTypeRequested = typeRequested
 
 SolicitConditional.WhoreFollowsPlayer = 1
 akProstitute.EvaluatePackage()
endFunction


Function StopFollow()
 SolicitConditional.WhoreFollowsPlayer = 0
 akProstitute.EvaluatePackage()
 akProstituteRef.Clear()
endFunction


Function PerformSex()
 int amount = 0
 if (akTypeRequested == "Blowjob" || akTypeRequested == "Cunnilingus")
	amount = TotalCostForO
 elseif (akTypeRequested == "Vaginal")
	amount = TotalCostForV
 elseif (akTypeRequested == "Anal")
	amount = TotalCostForA
 endif

 int tp = TimesPayForSex.GetValue() as int
 TimesPayForSex.SetValue(Handler.ValidateStatInt("Times As Client", tp, 1))
 UpdateCurrentInstanceGlobal(TimesPayForSex)
	
 akProstitute.AddItem(gold, amount)
 akPlayer.RemoveItem(gold, amount)

 sslBaseAnimation[] anims
 actor[] sexActors = new actor[2]
 
 int sex0 = (akProstitute.GetBaseObject() as ActorBase).GetSex()  ;SexLab.GetGender(akProstitute)
 int sex1 = (akPlayer.GetBaseObject() as ActorBase).GetSex()  ;SexLab.GetGender(SexLab.PlayerRef) ;
 
 ; we sort the actors according to the intent of the scene i.e. that the prostitute is in the dominated position
 if(sex0 == 1);if prostitute is female
	if(sex1 == 1) ; FF
		sexActors[0] = akProstitute
		sexActors[1] = akPlayer
		anims = SexLab.GetAnimationsByTag(2, akTypeRequested, "FF", requireAll=false) ;coz there is so few FF anims
	else ; NPC F PC M
		sexActors[0] = akProstitute
		sexActors[1] = akPlayer
		anims = SexLab.GetAnimationsByTag(2, akTypeRequested, "MF")
	endif
 else		;if prostitute is male
	if(sex1 == 1) ; NPC M PC F
		if(akTypeRequested == "Cunnilingus")
			sexActors[0] = akProstitute
			sexActors[1] = akPlayer
		else
			sexActors[0] = akPlayer
			sexActors[1] = akProstitute	
		endif
		anims = SexLab.GetAnimationsByTag(2, akTypeRequested, "MF")
	else ;MM
		if(akTypeRequested == "Vaginal")
			sexActors[0] = akProstitute
			sexActors[1] = akPlayer	
			anims = SexLab.GetAnimationsByTag(2, "Anal", "MF")
		else
			sexActors[0] = akProstitute
			sexActors[1] = akPlayer	
			anims = SexLab.GetAnimationsByTag(2, akTypeRequested, "MF")
		endif
	endif
 endif
 

 sslThreadModel th = SexLab.NewThread()
 th.AddActor(sexActors[0])
 th.AddActor(sexActors[1])
 th.SetAnimations(anims)
 th.DisableLeadIn(true) 
 th.StartThread()
endFunction