Scriptname SLAppSpawnNPCs extends Quest  

;Riverwood
Function SpawnBullyNPCRiverwood()
	if (maleriverwood01 == None) && (maleriverwood02 == None)
		Actor actor1 = SLARiverwoodCentermarker.placeatme(SLA_ThugMaleRiverwood01) as actor
		Actor actor2 = SLARiverwoodCentermarker.placeatme(SLA_ThugMaleRiverwood02) as actor
		maleriverwood01.forcerefto(actor1)
		maleriverwood02.forcerefto(actor2)

		SLA_BullyNPCRiverwood.setvalue(SLA_BullyNPCRiverwood.getvalue() + 2)
	endif
EndFunction

Function DespawnBullyNPCRiverwood()
	(maleriverwood01.getreference() as actor).delete()
	(maleriverwood02.getreference() as actor).delete()
	maleriverwood01.clear()
	maleriverwood02.clear()
EndFunction


Actorbase Property SLA_ThugMaleRiverwood01  Auto  
Actorbase Property SLA_ThugMaleRiverwood02  Auto  

Referencealias Property maleriverwood01 auto
Referencealias Property maleriverwood02 auto

ObjectReference Property SLARiverwoodCentermarker Auto

GlobalVariable Property SLA_BullyNPCRiverwood Auto
GlobalVariable Property SLA_BullyNPCWhiterun Auto
GlobalVariable Property SLA_BullyNPCFalkreath Auto