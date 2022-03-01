Scriptname IdlePlayHotkeyAliasScript extends ReferenceAlias  

actor property playerref auto
Spell property IdlePlayMenuBaseSpell auto

Event OnInit()
	RegisterForKey(34)
EndEvent

Event OnKeyDown(Int KeyCode)
	if keycode == 34
		IdlePlayMenuBaseSpell.cast(playerref)
	endif
endevent	