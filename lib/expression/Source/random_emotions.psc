Scriptname random_emotions extends ReferenceAlias

Quest Property this_quest Auto

Import Utility
Import Math
Import mfgconsolefunc

Float interval_update = 0.3
Float interval_eye_move = 0.6
Float interval_blink = 6.0
Float interval_squint = 6.0
Float interval_squint_reset = 4.0
Float interval_brow_in = 30.0
Float interval_brow_in_reset = 10.0
Float interval_brow_down = 30.0
Float interval_brow_down_reset = 10.0
Float interval_brow_up = 30.0
Float interval_brow_up_reset = 10.0
Float interval_expression_strength = 30.0
Float interval_phoneme = 21.0
Float interval_phoneme_reset = 14.0
Float interval_expression = 300.0
Float time_blink = 0.03
Int strength_eye_move = 100
Int strength_squint = 80
Int strength_brow_in = 50
Int strength_brow_down = 50
Int strength_brow_up = 50
Int strength_expression = 80
Int strength_phoneme = 50
Int speed_phoneme_min = 1
Int speed_phoneme_max = 1
Int speed_modifier_min = 1
Int speed_modifier_max = 3
Int speed_eye_move_min = 1
Int speed_eye_move_max = 15
Int speed_blink_min = 25
Int speed_blink_max = 60
Actor act
Float time
Float next_eye_move
Float next_blink
Float next_squint
Float next_squint_reset
Float next_brow_in
Float next_brow_in_reset
Float next_brow_down
Float next_brow_down_reset
Float next_brow_up
Float next_brow_up_reset
Float next_expression_strength
Float next_phoneme
Float next_phoneme_reset
Float next_expression
Int is_idle
Int speed_blink
Int exp_value

State Idle
	Event OnUpdate()
	EndEvent
	Function RandomPhoneme(Int str)
	EndFunction
	Function SmoothSetPhoneme(Int number, Int str_dest)
	EndFunction
	Function SmoothSetModifier(Int number1, Int number2, Int str_dest)
	EndFunction
EndState

Event OnKeyDown(Int KeyCode)
	If (KeyCode == 68 && Input.IsKeyPressed(42) && is_idle != 3)
		If (is_idle)
			GotoState("")
			Defaults()
			If (act == Game.GetPlayer())
				Debug.Notification("Random Emotions: unpaused")
			EndIf
			If (GetPhoneme(act, 0))
				SmoothSetPhoneme(0, 0)
				SmoothSetPhoneme(1, 0)
				SmoothSetPhoneme(11, 0)
			EndIf
			RegisterForSingleUpdate(interval_update)
		Else
			is_idle = 1
			GotoState("Idle")
			If (act == Game.GetPlayer())
				Debug.Notification("Random Emotions: paused")
			EndIf
		EndIf
	ElseIf (KeyCode == 14 && Input.IsKeyPressed(42) && is_idle != 3)
		If (is_idle)
			GotoState("")
			If (act == Game.GetPlayer())
				ResetQuest()
				Debug.Notification("Random Emotions: started")
			EndIf
		Else
			is_idle = 2
			GotoState("Idle")
			Wait(3.0)
			SetPhonemeModifier(act, -1, 0, 0)
			act.ClearExpressionOverride()
			exp_value = 0
			If (act == Game.GetPlayer())
				Debug.Notification("Random Emotions: stopped")
			EndIf
		EndIf
	ElseIf (KeyCode == 18 && act == Game.GetCurrentCrosshairRef())
		If (!is_idle)
			is_idle = 3
			GotoState("Idle")
			Wait(0.1)
			SetPhonemeModifier(act, -1, 0, 0)
			act.ClearExpressionOverride()
			exp_value = 0
			Wait(5.0)
			While (act.IsInDialogueWithPlayer() || act.IsDoingFavor())
				Wait(5.0)
			EndWhile
			Wait(5.0)
			GotoState("")
			Defaults()
			RegisterForSingleUpdate(interval_update)
		ElseIf (is_idle == 1)
			is_idle = 3
			SetPhonemeModifier(act, -1, 0, 0)
			act.ClearExpressionOverride()
			exp_value = 0
		ElseIf (is_idle == 2)
			is_idle = 3
		EndIf
	EndIf
EndEvent

Event OnPlayerLoadGame()
	ResetQuest()
EndEvent

Event OnInit()
	act = self.GetRef() as Actor
	If (!act)
		Return
	EndIf
	While (!ResetPhonemeModifier(act))
		Wait(1.0)
	EndWhile
	RegisterForKey(14)
	RegisterForKey(18)
	RegisterForKey(68)
	Defaults()
	RegisterForSingleUpdate(interval_update)
EndEvent

Event OnUpdate()
	While (!SetModifier(act, 14, 0))
		If (!act)
			Return
		EndIf
		Wait(5.0)
	EndWhile
	If (act.IsDead())
		ResetPhonemeModifier(act)
		If (RandomInt(0, 1))
			SmoothSetModifier(6, 7, RandomInt(80, 100))
			SmoothSetModifier(11, -1, 100)
			SmoothSetPhoneme(2, 50)
			SmoothSetPhoneme(11, 100)
			SmoothSetModifier(0, 1, RandomInt(20, 50))
		Else
			SmoothSetModifier(4, 5, RandomInt(0, 100))
			SmoothSetModifier(0, 1, 90)
		EndIf
		Return
	EndIf
	If (act.GetSleepState() == 3)
		If (GetModifier(act, 0) != 90)
			ResetPhonemeModifier(act)
			SmoothSetModifier(0, 1, 90)
		EndIf
		RegisterForSingleUpdate(5.0)
		Return
	EndIf
	If (act.GetActorValuePercentage("Health") < 0.34 && GetExpressionID(act) != 1)
		SmoothSetExpression(1, RandomInt(50, 100))
	EndIf
	If (act.IsInCombat() && GetExpressionID(act) != 15 && act.GetActorValuePercentage("Health") >= 0.34)
		SmoothSetExpression(15, RandomInt(50, 100))
	EndIf
	time = GetCurrentRealTime()
	If (time >= next_eye_move)
		SmoothSetModifier(RandomInt(8, 11), -1, RandomInt(0, RandomInt(0, strength_eye_move)))
		next_eye_move = RandomFloat(time, RandomFloat(time, time + interval_eye_move * 4.0))
	EndIf
	If (time >= next_blink)
		Int strength_blink = 90
		If (GetExpressionID(act) == 3 || GetExpressionID(act) == 11)
			strength_blink = strength_blink - Round(exp_value * 0.25)
		ElseIf (GetExpressionID(act) == 0 || GetExpressionID(act) == 2 || GetExpressionID(act) == 8 || GetExpressionID(act) == 16)
			strength_blink = strength_blink - Round(exp_value * 0.2)
		ElseIf (GetExpressionID(act) == 6 || GetExpressionID(act) == 10 || GetExpressionID(act) == 14)
			strength_blink = strength_blink - Round(exp_value * 0.15)
		ElseIf (GetExpressionID(act) == 5)
			strength_blink = strength_blink - Round(exp_value * 0.1)
		ElseIf (GetExpressionID(act) == 4 || GetExpressionID(act) == 9 || GetExpressionID(act) == 15)
			strength_blink = strength_blink + Round(exp_value * 0.05)
		ElseIf (GetExpressionID(act) == 12 || GetExpressionID(act) == 13)
			strength_blink = strength_blink + Round(exp_value * 0.1)
		EndIf
		If (GetModifier(act, 8) > GetModifier(act, 11))
			strength_blink = strength_blink - Round((GetModifier(act, 8) - GetModifier(act, 11)) * 0.2)
		EndIf
		strength_blink = strength_blink - Round(GetModifier(act, 12) * 0.3)
		SmoothSetModifier(0, 1, strength_blink)
		Wait(RandomFloat(0.0, RandomFloat(0.0, RandomFloat(0.0, RandomFloat(0.0, time_blink * 8.0)))))
		SmoothSetModifier(0, 1, 0)
		next_blink = RandomFloat(time, time + interval_blink * 2.0)
	EndIf
	If (time >= next_squint_reset)
		SmoothSetModifier(12, 13, 0)
		If (time >= next_squint)
			next_squint = RandomFloat(time, time + interval_squint)
		EndIf
		next_squint_reset = RandomFloat(time, time + interval_squint_reset * 2.0)
	ElseIf (time >= next_squint)
		SmoothSetModifier(12, 13, RandomInt(0, strength_squint))
		next_squint = RandomFloat(time, time + interval_squint * 2.0)
	EndIf
	If (time >= next_brow_in_reset)
		SmoothSetModifier(4, 5, 0)
		If (time >= next_brow_in)
			next_brow_in = RandomFloat(time, time + interval_brow_in)
		EndIf
		next_brow_in_reset = RandomFloat(time, time + interval_brow_in_reset * 2.0)
	ElseIf (time >= next_brow_in)
		SmoothSetModifier(4, 5, RandomInt(0, strength_brow_in))
		next_brow_in = RandomFloat(time, time + interval_brow_in * 2.0)
	EndIf
	If (time >= next_brow_down_reset)
		SmoothSetModifier(2, 3, 0)
		If (time >= next_brow_down)
			next_brow_down = RandomFloat(time, time + interval_brow_down)
		EndIf
		next_brow_down_reset = RandomFloat(time, time + interval_brow_down_reset * 2.0)
	ElseIf (time >= next_brow_down)
		SmoothSetModifier(2, 3, RandomInt(0, strength_brow_down))
		next_brow_down = RandomFloat(time, time + interval_brow_down * 2.0)
	EndIf
	If (time >= next_brow_up_reset)
		SmoothSetModifier(6, 7, 0)
		next_brow_up_reset = RandomFloat(time, time + interval_brow_up_reset * 2.0)
		If (time >= next_brow_up)
			next_brow_up = RandomFloat(time, time + interval_brow_up)
		EndIf
	ElseIf (time >= next_brow_up)
		SmoothSetModifier(6, 7, RandomInt(0, strength_brow_up))
		next_brow_up = RandomFloat(time, time + interval_brow_up * 2.0)
	EndIf
	Int t1 = GetExpressionID(act)
	If (time >= next_expression_strength)
		act.SetExpressionOverride(t1, RandomInt(0, strength_expression))
		next_expression_strength = RandomFloat(time, time + interval_expression_strength * 2.0)
	EndIf
	If (time >= next_expression && !act.IsInCombat() && act.GetActorValuePercentage("Health") >= 0.34)
		While (t1 == GetExpressionID(act))
			t1 = RandomInt(0, 15)
		EndWhile
		SmoothSetExpression(t1, RandomInt(0, strength_expression))
		next_expression = RandomFloat(time, time + interval_expression * 2.0)
	EndIf
	If (time >= next_phoneme_reset)
		RandomPhoneme(0)
		If (time >= next_phoneme)
			next_phoneme = RandomFloat(time, time + interval_phoneme)
		EndIf
		next_phoneme_reset = RandomFloat(time, time + interval_phoneme_reset * 2.0)
	ElseIf (time >= next_phoneme)
		If (t1 == 13 || t1 == 16)
			RandomPhoneme(0)
		ElseIf (t1 >= 8 && t1 != 11 && t1 != 15)
			RandomPhoneme(RandomInt(0, Round(strength_phoneme / 2.0)))
		Else
			RandomPhoneme(RandomInt(0, strength_phoneme))
		EndIf
		next_phoneme = RandomFloat(time, time + interval_phoneme * 2.0)
	EndIf
	RegisterForSingleUpdate(interval_update)
EndEvent

Function Defaults()
	time = GetCurrentRealTime()
	next_eye_move = RandomFloat(time, RandomFloat(time, time + interval_eye_move * 2.0))
	next_blink = RandomFloat(time, time + interval_blink)
	next_squint = RandomFloat(time, time + interval_squint)
	next_squint_reset = RandomFloat(time, time + interval_squint_reset)
	next_brow_in = RandomFloat(time, time + interval_brow_in)
	next_brow_in_reset = RandomFloat(time, time + interval_brow_in_reset)
	next_brow_down = RandomFloat(time, time + interval_brow_down)
	next_brow_down_reset = RandomFloat(time, time + interval_brow_down_reset)
	next_brow_up = RandomFloat(time, time + interval_brow_up)
	next_brow_up_reset = RandomFloat(time, time + interval_brow_up_reset)
	next_expression_strength = RandomFloat(time, time + interval_expression_strength)
	next_phoneme = RandomFloat(time, time + interval_phoneme)
	next_phoneme_reset = RandomFloat(time, time + interval_phoneme_reset)
	next_expression = 0.0
	is_idle = 0
	exp_value = 0
EndFunction

Function RandomPhoneme(Int str)
	Int[] phonemes = new Int[14]
	Int i = 0
	While (i < 14)
		phonemes[i] = i + 2
		i = i + 1
	EndWhile
	Int temp_str
	Int gp_length = phonemes.Length
	Int gp_temp = RandomInt(0, gp_length - 1)
	While (str != 0)
		If (str <= 100)
			temp_str = RandomInt(Round(str / gp_length), str)
		Else
			temp_str = RandomInt(Round(str / gp_length), 100)
		EndIf
		While (phonemes[gp_temp] < 0)
			gp_temp = RandomInt(0, phonemes.Length - 1)
		EndWhile
		SmoothSetPhoneme(phonemes[gp_temp], temp_str)
		phonemes[gp_temp] = -1
		gp_length = gp_length - 1
		str = str - temp_str
	EndWhile
	i = 0
	While (i < phonemes.Length)
		If (phonemes[i] >= 0)
			SmoothSetPhoneme(phonemes[i], 0)
		EndIf
		i = i + 1
	EndWhile
EndFunction

Function SmoothSetPhoneme(Int number, Int str_dest)
	While (!SetModifier(act, 14, 0))
		If (!act)
			Return
		EndIf
		Wait(5.0)
	EndWhile
	Int t1 = GetPhoneme(act, number)
	Int t2
	Int speed = RandomInt(speed_phoneme_min, speed_phoneme_max)
	While (t1 != str_dest && !is_idle)
		t2 = (str_dest - t1) / Abs(str_dest - t1) as Int
		t1 = t1 + t2 * speed
		If ((str_dest - t1) / t2 < 0)
			t1 = str_dest
		EndIf
		SetPhoneme(act, number, t1)
	EndWhile
EndFunction

Function SmoothSetModifier(Int number1, Int number2, Int str_dest)
	While (!SetModifier(act, 14, 0))
		If (!act)
			Return
		EndIf
		Wait(5.0)
	EndWhile
	Int t1 = GetModifier(act, number1)
	Int t2
	Int t3
	Int speed
	If (number1 < 2)
		If (str_dest > 0)
			speed_blink = RandomInt(speed_blink_min, speed_blink_max)
			speed = speed_blink
		Else
			If (speed_blink > 0)
				speed = Round(speed_blink * 0.5)
			Else
				speed = Round(RandomInt(speed_blink_min, speed_blink_max) * 0.5)
			EndIf
		EndIf
	ElseIf (number1 > 7 && number1 < 12)
		speed = RandomInt(speed_eye_move_min, speed_eye_move_max)
	Else
		speed = RandomInt(speed_modifier_min, speed_modifier_max)
	EndIf
	While (t1 != str_dest && !is_idle)
		t2 = (str_dest - t1) / Abs(str_dest - t1) as Int
		t1 = t1 + t2 * speed
		If ((str_dest - t1) / t2 < 0)
			t1 = str_dest
		EndIf
		If (!(number2 < 0 || number2 > 13))
			t3 = RandomInt(0, 1)
			SetModifier(act, number1 * t3 + number2 * (1 - t3), t1)
			SetModifier(act, number2 * t3 + number1 * (1 - t3), t1)
		Else
			SetModifier(act, number1, t1)
		EndIf
	EndWhile
EndFunction

Function SmoothSetExpression(Int number, Int str_dest)
	While (!SetModifier(act, 14, 0))
		If (!act)
			Return
		EndIf
		Wait(5.0)
	EndWhile
	Int t2
	Int speed = RandomInt(speed_phoneme_min, speed_phoneme_max)
	While (exp_value != str_dest && !is_idle)
		t2 = (str_dest - exp_value) / Abs(str_dest - exp_value) as Int
		exp_value = exp_value + t2 * speed
		If ((str_dest - exp_value) / t2 < 0)
			exp_value = str_dest
		EndIf
		act.SetExpressionOverride(number, exp_value)
	EndWhile
EndFunction

Int Function Round(Float f)
	Return Floor(f + 0.5)
EndFunction

Function ResetQuest()
	While (this_quest.IsStarting() || this_quest.IsStopping())
		Wait(1.0)
	EndWhile
	If (this_quest.IsRunning())
		this_quest.Reset()
		this_quest.Stop()
	EndIf
	this_quest.Start()
EndFunction