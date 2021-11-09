Scriptname mf_onloadaome extends ReferenceAlias  

 ; EVENTS -----------------------------------------------------------------------------------------

event OnPlayerLoadGame()
        (GetOwningQuest() as SKI_QuestBase).OnGameReload()
endEvent