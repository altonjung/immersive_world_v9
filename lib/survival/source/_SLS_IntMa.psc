Scriptname _SLS_IntMa  Hidden 

Int Function GetDurDilute(Quest MaMcm) Global
	Return (MaMcm as _MA_Mcm).DurationDilute
EndFunction

Int Function GetDurWeak(Quest MaMcm) Global
	Return (MaMcm as _MA_Mcm).DurationWeak
EndFunction

Int Function GetDurRegular(Quest MaMcm) Global
	Return (MaMcm as _MA_Mcm).DurationRegular
EndFunction

Int Function GetDurStrong(Quest MaMcm) Global
	Return (MaMcm as _MA_Mcm).DurationStrong
EndFunction

Int Function GetDurTasty(Quest MaMcm) Global
	Return (MaMcm as _MA_Mcm).DurationTasty
EndFunction

Int Function GetDurCreamy(Quest MaMcm) Global
	Return (MaMcm as _MA_Mcm).DurationCreamy
EndFunction

Int Function GetDurEnriched(Quest MaMcm) Global
	Return (MaMcm as _MA_Mcm).DurationEnriched
EndFunction

Int Function GetDurSublime(Quest MaMcm) Global
	Return (MaMcm as _MA_Mcm).DurationSublime
EndFunction

Int Function GetCurrentEffectsStage(ReferenceAlias MaMain) Global
	Return (MaMain as _MA_Main).GetCurrentEffectsStage()
EndFunction
