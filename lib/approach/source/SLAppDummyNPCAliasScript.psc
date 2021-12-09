Scriptname SLAppDummyNPCAliasScript   extends ReferenceAlias  

Event OnDeath(Actor akKiller)
	SLA_BullyNPCGlobal.setvalue(SLA_BullyNPCGlobal.getvalue() - 1)
	clear()
endEvent

GlobalVariable Property SLA_BullyNPCGlobal Auto