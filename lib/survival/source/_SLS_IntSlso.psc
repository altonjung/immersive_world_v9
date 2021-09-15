Scriptname _SLS_IntSlso Hidden

Function ModEnjoyment(SexlabFramework Sexlab, Int CurrentTid, Actor akTarget, Int Enjoyment) Global
	;Debug.Messagebox("Sexlab: " + Sexlab + "\nCurrentTid: " + CurrentTid + "\nEnjoyment: " + Enjoyment + "\nThread: " + Sexlab.GetController(CurrentTid))
	Sexlab.GetController(CurrentTid).ActorAlias(akTarget).BonusEnjoyment(Ref = akTarget, fixedvalue = Enjoyment)
EndFunction
