Scriptname mf_CallClientsScript extends activemagiceffect  

Quest Property Handler  Auto  


Event OnEffectStart(Actor akTarget, Actor akCaster)
  	Debug.Notification("Anyone in the market for a romp")
	(Handler as mf_Handler).SingleJobQuestKicker(None)
endEvent