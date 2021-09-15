Scriptname SLS_TollBox extends ObjectReference

Event OnActivate(ObjectReference akActionRef)
	TollUtil.TollBoxActivate(Self, akActionRef, BoxLoc, TollGate)
	
;/
	Init.TollHasEnoughFollowers()
	
	If akActionRef == PlayerRef
		If !Init.IsTollPaid
			_SLS_TollCost.SetValue(GetTollCost())
		EndIf
		If Init.IsTollPaid
			Debug.Notification("You have already paid the toll")
			
		ElseIf Init.IsGrounded(LocInt = BoxLoc)
			Debug.Notification("You are being punished and aren't allowed to leave town today")
			
		ElseIf Init.IsCurfewTime()
			Debug.Notification("You can not leave during curfew. Wait til morning")
			
		ElseIf PlayerRef.GetItemCount(Gold001) >= _SLS_TollCost.GetValueInt()
			
			If Init.HasEnoughFollowers == 1
				SLS_TollGate TollGateScript = TollGate as SLS_TollGate
				TollGateScript.TollPaid(true)
			ElseIf Init.HasEnoughFollowers == 0
				Debug.Notification("You need more protection if the guards are to let you leave")
			Else
				Debug.Notification("Women are not permitted to leave without an escort")
			EndIf
		Else
			Debug.notification("You are too poor to afford the toll - " + _SLS_TollCost.GetValueInt() + " septims")
		EndIf

		; Close strongbox again
		Utility.Wait(1.0)
		int openState = Self.GetOpenState()
		If (openState == 1 || openState == 2)
			Self.SetOpen(false)
		EndIf
	EndIf
/;
EndEvent

;/
Int Function GetTollCost()
	SLS_Mcm Menu = Init.Menu
	If Init.SlvrunRelInstalled
		_SLS_InterfaceSlaverun Slaverun = Menu.Slaverun
		; Whiterun
		If BoxLoc == 0
			If !Slaverun.IsFreeTownWhiterun()
				Init.IsEnslavedTown = true
			Else
				Init.IsEnslavedTown = false
			EndIf
		
		; Solitude
		ElseIf BoxLoc == 1
			If !Slaverun.IsFreeTownSolitude()
				Init.IsEnslavedTown = true
			Else
				Init.IsEnslavedTown = false
			EndIf
			
		; Markarth
		ElseIf BoxLoc == 2
			If !Slaverun.IsFreeTownMarkarth()
				Init.IsEnslavedTown = true
			Else
				Init.IsEnslavedTown = false
			EndIf
			
		; Windhelm
		ElseIf BoxLoc == 3
			If !Slaverun.IsFreeTownWindhelm()
				Init.IsEnslavedTown = true
			Else
				Init.IsEnslavedTown = false
			EndIf
			
		; Riften
		ElseIf BoxLoc == 4
			If !Slaverun.IsFreeTownRiften()
				Init.IsEnslavedTown = true
			Else
				Init.IsEnslavedTown = false
			EndIf
		EndIf
	EndIf
	If Init.IsEnslavedTown
		If Menu.GoldPerLevelT
			Return Math.Ceiling(((Menu.TollCostGold * PlayerRef.GetLevel() * Menu.SlaverunFactor) + GetHairyPussyTax()) * (Init.TollJobsToDo as Float / Menu.SlaverunJobFactor as Float))
		Else
			Return Math.Ceiling(((Menu.TollCostGold * Menu.SlaverunFactor) + GetHairyPussyTax()) * (Init.TollJobsToDo as Float / Menu.SlaverunJobFactor as Float))
		EndIf
	Else
		If Menu.GoldPerLevelT
			Return (Menu.TollCostGold * PlayerRef.GetLevel()) + GetHairyPussyTax()
		Else
			Return Menu.TollCostGold + GetHairyPussyTax()
		EndIf
	EndIf
EndFunction

Int Function GetHairyPussyTax()
	If BoxLoc == 0
		Return (Init.LicUtil.Fashion.HairyPussyTaxWhiterun as Int) * 200
	ElseIf BoxLoc == 1
		Return (Init.LicUtil.Fashion.HairyPussyTaxSolitude as Int) * 200
	ElseIf BoxLoc == 2
		Return (Init.LicUtil.Fashion.HairyPussyTaxMarkarth as Int) * 200
	ElseIf BoxLoc == 3
		Return (Init.LicUtil.Fashion.HairyPussyTaxWindhelm as Int) * 200
	ElseIf BoxLoc == 4
		Return (Init.LicUtil.Fashion.HairyPussyTaxRiften as Int) * 200
	EndIf
	Return 0
EndFunction
/;
_SLS_TollUtil Property TollUtil Auto

Int Property BoxLoc Auto ; 0 - Whiterun, 1 - Solitude, 2 - Markarth, 3 - Windhelm, 4 - Riften
ReferenceAlias Property TollGate  Auto  
;MiscObject Property Gold001  Auto  
;Actor Property PlayerRef Auto
;GlobalVariable Property _SLS_TollCost Auto
;SLS_Init Property Init Auto

;GlobalVariable Property PlayerFollowerCount Auto
;GlobalVariable Property _SLS_TollFollowersRequired Auto