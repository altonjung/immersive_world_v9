Scriptname mf_WhoreSexScene extends Quest  

ReferenceAlias Property akClient  Auto  
ReferenceAlias Property akWhore  Auto  
SPELL Property Refractory  Auto  
SexLabFramework Property SexLab  Auto  
MiscObject Property Gold001  Auto  

Function StartScene()

	;give whore some money
	int GoldAmount = Utility.RandomInt(50, 200)
	akWhore.GetReference().AddItem(Gold001, GoldAmount, true)

	actor[] activeActors = new actor[2]
	activeActors[0] = (akWhore.GetReference() as Actor)
	activeActors[1] = (akClient.GetReference() as Actor)
	sslBaseAnimation[] anims = SexLab.GetAnimationsByType(2, 1, 1)

	Refractory.Cast(activeActors[1], activeActors[1])

	sslThreadModel th = SexLab.NewThread()
	th.AddActor(activeActors[0])
	th.AddActor(activeActors[1])
	th.SetAnimations(anims)
	th.DisableLeadIn(true) 
	th.StartThread()
endFunction



