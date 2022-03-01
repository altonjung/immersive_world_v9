;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname TIF__00060022 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Game.GetPlayer().RemoveItem(Gold, 10)
Game.GetPlayer().PlayIdle(idlegive)
akspeaker.additem(gold, 10)
utility.wait(0.8)
Debug.SendanimationEvent(akspeaker, "AO_IdleTake")
utility.wait(0.5)
Debug.SendAnimationEvent(akspeaker, "OffsetStop")
FavorJobsBeggarsAbility.Cast(Game.GetPlayer(), Game.GetPlayer())
FavorJobsBeggarsMessage.Show()

If akspeaker.GetRelationshipRank(Game.GetPlayer()) == 0
  akspeaker.SetRelationshipRank(Game.GetPlayer(), 1)
Endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

MiscObject Property Gold  Auto  

Spell Property FavorJobsBeggarsAbility  Auto  

Message Property FavorJobsBeggarsMessage  Auto  

idle property idlegive auto
