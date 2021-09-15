Scriptname _SLS_DebugGetActorPack extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If akTarget

		; Package
		Package AiPack = akTarget.GetCurrentPackage() ; Game.GetFormFromFile(0x015962, "Ordinator - Perks of Skyrim.esp") as Package
		Int FormId = AiPack.GetFormID()
		Int Index = Math.RightShift(Math.LogicalAnd(FormId, 0xFF000000), 24)
		String ModName = Game.GetModName(Index)

		; Scene
		Scene AkScene = akTarget.GetCurrentScene()
		Quest akQuest
		Int QuestStage = -1
		If akScene
			akQuest = AkScene.GetOwningQuest()
			QuestStage = akQuest.GetCurrentStageID()
		EndIf
		Debug.Messagebox("Target: " + akTarget.GetActorBase().GetName() + "\nAI Package : " + AiPack + "\nModName: " + ModName + "\n\nScene: " + AkScene + "\nQuest: " + akQuest + "\nQuest Stage: "+ QuestStage)
	EndIf
EndEvent
