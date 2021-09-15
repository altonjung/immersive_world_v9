Scriptname SLHHResetQuestScript extends Quest  
{Quest}

Function ResetCurrentQuest()

Slhhupkeep.AnimationStart(160, true)
;SLHH.Setstage(160)

Utility.wait(1.0)
SLHH.Reset()
SLHHMonitorScript.Reset()
SLHH_HarassingComments.Reset()

Utility.wait(1.0)

SLHH.Stop()
SLHHMonitorScript.Stop()
SLHH_HarassingComments.Stop()

Utility.wait(1.0)

SLHH.Start()
SLHHMonitorScript.Start()
SLHH_HarassingComments.start()

if SLHH.isrunning()
Debug.notification("SLHH Reset Complete")
Debug.notification("SLHH Version = " + VersionCheck() + "." + VersionCheckDecimal())
else
Debug.notification("SLHH Update Failed. Something went wrong. The quest couldn't start.")
endif
EndFunction

int Function VersionCheck()
	Version = 3
	Return Version
EndFunction
int Function VersionCheckDecimal()
	VersionDecimal = 4
	Return VersionDecimal
EndFunction

int Version
int VersionDecimal
Quest Property SLHH Auto
Quest Property SLHH_Companion Auto
Quest Property SLHH_HarassingComments Auto
Quest Property SLHHMonitorScript Auto
Quest Property SLHHScriptEvent Auto
slhh_upkeep property Slhhupkeep auto