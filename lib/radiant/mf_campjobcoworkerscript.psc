Scriptname mf_CampJobCoworkerScript extends Quest  

Quest Property CampJob Auto

ReferenceAlias Property akClient  Auto  
ReferenceAlias Property akWhore  Auto  
SPELL Property Refractory  Auto  
SexLabFramework Property SexLab  Auto  


Function StartScene()
	
	Debug.Trace("Start Coworker Sex Scene")

	RegisterForModEvent("AnimationEnd_CowokerGotClient", "CowokerGotClient")
	actor[] activeActors = new actor[2]
	activeActors[0] = (akWhore.GetReference() as Actor)
	activeActors[1] = (akClient.GetReference() as Actor)
	sslBaseAnimation[] anims = SexLab.GetAnimationsByType(2, 1, 1)

	sslThreadModel th = SexLab.NewThread()
	th.AddActor(activeActors[0])
	th.AddActor(activeActors[1])
	th.SetAnimations(anims)
	th.DisableLeadIn(true) 
	th.SetHook("CowokerGotClient")
	th.StartThread()
endFunction

Event CowokerGotClient(string eventName, string argString, float argNum, form sender)
	Debug.Trace("End Coworker Sex Scene")
	UnregisterForModEvent("AnimationEnd_CowokerGotClient")
	(CampJob as mf_CampJobQuestScript).CoworkerGetClient()
	Refractory.Cast(akClient.GetActorRef(), akClient.GetActorRef())
endEvent