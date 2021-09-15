Scriptname _SLS_IntSlax  Hidden

Int Function GetVersion(Quest SlaxConfigQuest) Global
	Return (SlaxConfigQuest as slaConfigScr).GetVersion()
EndFunction
