Scriptname SLAPPResetScript extends Quest  

Function ResetQuest()

SLApproach_Config.stop()
SLApproach_Main.stop()
SLApproachAskForSexQuest.stop()
SSLAppAsk2.stop()
SSLAppPCRapeHelper.stop()
SLApproachScanningPlayerHouse.stop()
SLApproach_ExternalMods.stop()

Utility.wait(3.0)

SLApproach_Config.start()
SLApproach_Main.start()
SLApproachAskForSexQuest.start()
SLApproach_ExternalMods.start()

Debug.notification("SLAPP Reset Complete")

EndFunction

Quest Property SLApproach_Config Auto
Quest Property SLApproach_Main Auto
Quest Property SLApproachAskForSexQuest Auto
Quest Property SLApproachAskForSex2Quest Auto
Quest Property SSLAppAsk2 Auto
Quest Property SSLAppAsk2Helper Auto
Quest Property SSLAppPCRapeHelper Auto
Quest Property SLApproachScanningPlayerHouse Auto
Quest Property SLApproach_ExternalMods Auto
