Scriptname SLHH_Commented extends Quest  

GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property SLHH_NextCommentAllowed auto
GlobalVariable Property WICommentNextAllowed auto
GlobalVariable Property SLHH_Timeout auto
GlobalVariable Property GameHour auto
GlobalVariable Property SLHH_Nighttime auto
SLHH_MCM Property MCM Auto

float DaysUntilNextAllowed = 0.04 ;about 1 "game hour" expressed in GameDaysPassed

Function Commented()
	float Timeout = SLHH_Timeout.GetValue()
	float NextAllowed = GameDaysPassed.GetValue() + (0.04 * timeout)	
	SLHH_NextCommentAllowed.SetValue(NextAllowed)

	Float WINextAllowed = GameDaysPassed.GetValue() + DaysUntilNextAllowed
	WICommentNextAllowed.SetValue(WINextAllowed)

EndFunction

Event OnInit()
	RegisterForUpdateGameTime(1.0)
EndEvent

Event OnUpdateGameTime()
Utility.Wait(0.1)
If MCM.Nighttime == true
	If GameHour.GetValue() >= 18 || GameHour.GetValue() < 6
		SLHH_NightTime.SetValue(1)
	else
		SLHH_NightTime.SetValue(0)
	endif
else
	SLHH_NightTime.SetValue(1)
endif
EndEvent