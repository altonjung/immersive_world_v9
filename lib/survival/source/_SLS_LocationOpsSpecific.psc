Scriptname _SLS_LocationOpsSpecific extends Quest  

Event OnInit()
	If Self.IsRunning()
		;Setup()
	EndIf
EndEvent
;/
Function Setup()
	; Stringlist index positions determined by formlist _SLS_LocsAll
	; Stringlist order corresponds with equivalent Slaverun town Jurisdictions.
	; Eg: 13 - Ivarstead will follow the rules for Riften enslavement
	
	StorageUtil.StringListClear(Self, "_SLS_SlaverunJurisdictions")
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Whiterun") ; Whiterun
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Solitude") ; Solitude
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Markarth") ; Markarth
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Riften") ; Riften
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Windhelm") ; Windhelm
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Dawnstar") ; Dawnstar
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Falkreath") ; Falkreath
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Morthal") ; Morthal
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Riverwood") ; Riverwood
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Riverwood") ; Rorikstead - No enslavement of Rorikstead. Consider Rorikstead enslaved when Riverwood is
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Winterhold") ; Winterhold
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Solitude") ; Dragonbridge
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Windhelm") ; Kynesgrove
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Riften") ; ShorsStone
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Riften") ; Ivarstead
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Markarth") ; Karthwasten
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Dawnstar") ; Nightgate
	StorageUtil.StringListAdd(Self, "_SLS_SlaverunJurisdictions", "Markarth") ; OldHroldan
EndFunction

Bool Function GetIsFreeTown(Int LocIndex)
	;Debug.Messagebox("LocIndex: " + LocIndex)
	GoToState(StorageUtil.StringListGet(Self, "_SLS_SlaverunJurisdictions", LocIndex))
	Return IsFreeTown()
EndFunction
/;
Bool Function GetIsFreeTownByString(String Town)
	; See _SLS_LocTrackCentral for accepted string arguments - StringList _SLS_LocIndex
	
	;Debug.Messagebox("GetIsFreeTownByString: " + Town)
	GoToState(Town)
	Return IsFreeTown()
EndFunction

Int Function GetInnCostByString(String Town)
	GoToState(Town)
	Return GetInnCost()
EndFunction

Bool Function GetHasHomeAtLoc(String Town)
	GoToState(Town)
	Return HasHomeAtLoc()
EndFunction

Bool Function GetIsEvictedAtLoc(String Town)
	GoToState(Town)
	Return IsEvictedAtLoc()
EndFunction

ObjectReference Function GetInnDoorByString(String Town)
	GoToState(Town)
	Return GetInnDoor()
EndFunction

; Empty state ===========================================

Bool Function IsFreeTown()
	Return true
EndFunction

Int Function GetInnCost()
	Return 90
EndFunction

Bool Function HasHomeAtLoc()
	Return false
EndFunction

Bool Function IsEvictedAtLoc()
	Return false
EndFunction

ObjectReference Function GetInnDoor()
	Return None
EndFunction

; Areas with individual slaverun jurisdictions =================================================================
State Whiterun
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownWhiterun()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[0]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsWhiterun
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredWhiterun && Eviction.OwnsWhiterun)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x1A6F4, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Solitude
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownSolitude()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[1]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsSolitude
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredSolitude && Eviction.OwnsSolitude)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x37F25, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Markarth
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownMarkarth()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[2]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsMarkarth
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredMarkarth && Eviction.OwnsMarkarth)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x16E3B, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Windhelm
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownWindhelm()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[3]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsWindhelm
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredWindhelm && Eviction.OwnsWindhelm)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0xD18B1, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Riften
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownRiften()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[4]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsRiften
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredRiften && Eviction.OwnsRiften)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x430A6, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Dawnstar
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownDawnstar()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[5]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x17636, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Falkreath
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownFalkreath()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[6]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x17762, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Morthal
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownMorthal()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[7]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x177AF, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Riverwood
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownRiverwood()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[8]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x13424, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Winterhold
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownWinterhold()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[10]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x177FB, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

; City exteriors ===================================================================================================
State WhiterunExterior
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownWhiterun()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[0]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsWhiterun
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredWhiterun && Eviction.OwnsWhiterun)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x1A6F4, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State SolitudeExterior
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownSolitude()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[1]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsSolitude
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredSolitude && Eviction.OwnsSolitude)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x37F25, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State MarkarthExterior
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownMarkarth()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[2]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsMarkarth
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredMarkarth && Eviction.OwnsMarkarth)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x16E3B, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State WindhelmExterior
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownWindhelm()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[3]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsWindhelm
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredWindhelm && Eviction.OwnsWindhelm)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0xD18B1, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State RiftenExterior
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownRiften()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[4]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return Eviction.OwnsRiften
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return (Eviction.IsBarredRiften && Eviction.OwnsRiften)
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x430A6, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

; Small towns ===========================================================================================
State Rorikstead
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownRiverwood()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[9]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x177D1, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Dragonbridge
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownSolitude()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[11]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x1775D, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Kynesgrove
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownWindhelm()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[12]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x177A5, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State ShorsStone
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownRiften()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[13]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x430A6, "Skyrim.esm") as ObjectReference ; Bee and barb
	EndFunction
EndState

State Ivarstead
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownRiften()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[14]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x17797, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State Kartwasten
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownMarkarth()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[15]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x17798, "Skyrim.esm") as ObjectReference ; Miner's Barracks
	EndFunction
EndState

State Nightgate
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownDawnstar()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[16]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x17786, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

State OldHroldan
	Bool Function IsFreeTown()
		Return Slaverun.IsFreeTownMarkarth()
	EndFunction
	
	Int Function GetInnCost()
		Return LocCentral.InnCosts[17]
	EndFunction
	
	Bool Function HasHomeAtLoc()
		Return false
	EndFunction
	
	Bool Function IsEvictedAtLoc()
		Return false
	EndFunction
	
	ObjectReference Function GetInnDoor()
		Return Game.GetFormFromFile(0x1762F, "Skyrim.esm") as ObjectReference
	EndFunction
EndState

_SLS_LocTrackCentral Property LocCentral Auto
_SLS_InterfaceSlaverun Property Slaverun Auto
SLS_EvictionTrack Property Eviction Auto
