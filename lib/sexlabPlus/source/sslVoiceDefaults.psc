scriptname sslVoiceDefaults extends sslVoiceFactory

function LoadVoices()
	; Prepare factory resources
	PrepareFactory()
	; Female voices
	RegisterVoice("FemaleClassic")
	RegisterVoice("FemaleBreathy")
	RegisterVoice("FemaleYoung")
	RegisterVoice("FemaleStimulated")
	RegisterVoice("FemaleQuiet")
	RegisterVoice("FemaleExcitable")
	RegisterVoice("FemaleAverage")
	RegisterVoice("FemaleMature")
	; Male voices
	RegisterVoice("MaleNeutral")
	RegisterVoice("MaleCalm")
	RegisterVoice("MaleRough")
	RegisterVoice("MaleAverage")
endFunction

function FemaleClassic(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Classic (Female)"
	Base.Gender = Female

	Base.Mild   = Game.GetFormFromFile(0x67548, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67547, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x67546, "SexLab.esm") as Sound

	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Female,Classic,Normal")

	Base.Save(id)
endFunction

function FemaleBreathy(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Breathy (Female)"
	Base.Gender = Female

	Base.Mild   = Game.GetFormFromFile(0x6754B, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x6754A, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x67549, "SexLab.esm") as Sound

	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Female,Breathy,Loud,Rough")

	Base.Save(id)
endFunction

function FemaleYoung(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Young (Female)"
	Base.Gender = Female

	Base.Mild   = Game.GetFormFromFile(0x6754E, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x6754D, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x6754C, "SexLab.esm") as Sound

	Base.Enjoy1  = Game.GetFormFromFile(0x02001842, "Sexlab plus.esp") as Sound
	Base.Enjoy2  = Game.GetFormFromFile(0x02001843, "Sexlab plus.esp") as Sound
	Base.Enjoy3  = Game.GetFormFromFile(0x02001844, "Sexlab plus.esp") as Sound
	Base.Feel1   = Game.GetFormFromFile(0x020038A2, "Sexlab plus.esp") as Sound
	Base.Feel2   = Game.GetFormFromFile(0x0200539A, "Sexlab plus.esp") as Sound
	Base.Feel3   = Game.GetFormFromFile(0x0200539B, "Sexlab plus.esp") as Sound
	Base.Happy1  = Game.GetFormFromFile(0x02001845, "Sexlab plus.esp") as Sound
	Base.Happy2  = Game.GetFormFromFile(0x02003339, "Sexlab plus.esp") as Sound
	Base.Happy3  = Game.GetFormFromFile(0x0200333A, "Sexlab plus.esp") as Sound
	Base.Horror1 = Game.GetFormFromFile(0x0200333B, "Sexlab plus.esp") as Sound
	Base.Horror2 = Game.GetFormFromFile(0x0200333C, "Sexlab plus.esp") as Sound
	Base.Horror3 = Game.GetFormFromFile(0x0200333D, "Sexlab plus.esp") as Sound
	Base.Pain1   = Game.GetFormFromFile(0x02001846, "Sexlab plus.esp") as Sound
	Base.Pain2   = Game.GetFormFromFile(0x02003E08, "Sexlab plus.esp") as Sound
	Base.Pain3   = Game.GetFormFromFile(0x02003E09, "Sexlab plus.esp") as Sound
	Base.Hate1   = Game.GetFormFromFile(0x020063C7, "Sexlab plus.esp") as Sound
	Base.Hate2   = Game.GetFormFromFile(0x020063C8, "Sexlab plus.esp") as Sound
	Base.Hate3   = Game.GetFormFromFile(0x020063C9, "Sexlab plus.esp") as Sound

	Base.Giggle  = Game.GetFormFromFile(0x0200692E, "Sexlab plus.esp") as Sound
	Base.Threaten = Game.GetFormFromFile(0x0200692F, "Sexlab plus.esp") as Sound
	
	Base.Moan    = Game.GetFormFromFile(0x020038A3, "Sexlab plus.esp") as Sound
	Base.Orgasm  = Game.GetFormFromFile(0x02001847, "Sexlab plus.esp") as Sound

	Base.Kiss    = Game.GetFormFromFile(0x020012C5, "Sexlab plus.esp") as Sound
	Base.Lick    = Game.GetFormFromFile(0x020012CF, "Sexlab plus.esp") as Sound
	Base.SuckSlow= Game.GetFormFromFile(0x020012D1, "Sexlab plus.esp") as Sound
	Base.SuckFast= Game.GetFormFromFile(0x02004E35, "Sexlab plus.esp") as Sound
	Base.Deep    = Game.GetFormFromFile(0x020012D3, "Sexlab plus.esp") as Sound	

	Base.SetTags("Female,Young,Loud")

	Base.Save(id)
endFunction

function FemaleStimulated(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Stimulated (Female)"
	Base.Gender = Female

	Base.Mild   = Game.GetFormFromFile(0x67551, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67550, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x6754F, "SexLab.esm") as Sound

	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Female,Stimulated,Loud,Excited")

	Base.Save(id)
endFunction

function FemaleQuiet(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Quiet (Female)"
	Base.Gender = Female

	Base.Mild   = Game.GetFormFromFile(0x67554, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67553, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x67552, "SexLab.esm") as Sound

	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Female,Quiet,Timid")

	Base.Save(id)
endFunction

function FemaleExcitable(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Excitable (Female)"
	Base.Gender = Female

	Base.Mild   = Game.GetFormFromFile(0x67557, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67556, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x67555, "SexLab.esm") as Sound

	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Female,Excitable,Excited,Loud")

	Base.Save(id)
endFunction

function FemaleAverage(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Average (Female)"
	Base.Gender = Female

	Base.Mild   = Game.GetFormFromFile(0x6755A, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67559, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x67558, "SexLab.esm") as Sound

	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Female,Average,Normal,Harsh")

	Base.Save(id)
endFunction

function FemaleMature(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Mature (Female)"
	Base.Gender = Female

	Base.Mild   = Game.GetFormFromFile(0x6755D, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x6755C, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x6755B, "SexLab.esm") as Sound

	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Female,Mature,Old,Harsh,Rough")

	Base.Save(id)
endFunction

function MaleNeutral(int id)
	sslBaseVoice Base = Create(id)
	
	Base.Name = "Neutral (Male)"
	Base.Gender = Male

	Base.Mild   = Game.GetFormFromFile(0x67560, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x6755F, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x6755E, "SexLab.esm") as Sound

	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Male,Neutral,Quiet,Normal")

	Base.Save(id)
endFunction

function MaleCalm(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Calm (Male)"
	Base.Gender = Male

	Base.Mild   = Game.GetFormFromFile(0x67563, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67562, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x67561, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Male,Calm,Quiet")

	Base.Save(id)
endFunction

function MaleRough(int id)
	sslBaseVoice Base = Create(id)

	Base.Name   = "Rough (Male)"
	Base.Gender = Male

	Base.Mild   = Game.GetFormFromFile(0x67566, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67565, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x67564, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Male,Rough,Harsh,Loud,Old")

	Base.Save(id)
endFunction

function MaleAverage(int id)
	sslBaseVoice Base = Create(id)
	
	Base.Name   = "Average (Male)"
	Base.Gender = Male
	
	Base.Mild   = Game.GetFormFromFile(0x67569, "SexLab.esm") as Sound
	Base.Medium = Game.GetFormFromFile(0x67568, "SexLab.esm") as Sound
	Base.Hot    = Game.GetFormFromFile(0x67567, "SexLab.esm") as Sound
	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.SetTags("Male,Average,Normal,Quiet")

	Base.Save(id)
endFunction



function LoadCreatureVoices()
	; Prepare factory resources
	PrepareFactory()
	; Register creature voices
	RegisterVoice("ChaurusVoice01")
	RegisterVoice("DogVoice01")
	RegisterVoice("DraugrVoice01")
	RegisterVoice("FalmerVoice01")
	RegisterVoice("GiantVoice01")
	RegisterVoice("HorseVoice01")
	RegisterVoice("SprigganVoice01")
	RegisterVoice("TrollVoice01")
	RegisterVoice("WerewolfVoice01")
	RegisterVoice("WolfVoice01")
endFunction

function ChaurusVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Chaurus 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C090, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C090, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C090, "SexLab.esm") as Sound
	
	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Chaurus")
	Base.AddRaceKey("Chaurusflyers")

	Base.Save(id)
endFunction

function DogVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Dog 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C091, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C091, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C091, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Dogs")
	Base.AddRaceKey("Dogpanic")

	Base.Save(id)
endFunction

function DraugrVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Draugr 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C08C, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C08C, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C08C, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Draugrs")

	Base.Save(id)
endFunction

function FalmerVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Falmer 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C08F, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C08F, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C08F, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Falmers")

	Base.Save(id)
endFunction

function GiantVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Giant 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C08E, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C08E, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C08E, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Giants")

	Base.Save(id)
endFunction

function HorseVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Horse 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C08D, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C08D, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C08D, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Horses")
	Base.AddRaceKey("Horseses")

	Base.Save(id)
endFunction

function SprigganVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Spriggan 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C08B, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C08B, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C08B, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Spriggans")
	Base.AddRaceKey("SprigganXan")

	Base.Save(id)
endFunction

function TrollVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Troll 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C089, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C089, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C089, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Trolls")

	Base.Save(id)
endFunction

function WerewolfVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Werewolf 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8C08A, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8C08A, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8C08A, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none

	Base.AddRaceKey("Werewolves")
	Base.AddRaceKey("Werewolfgal")
	Base.AddRaceKey("Werewolfpanic")

	Base.Save(id)
endFunction

function WolfVoice01(int id)
	sslBaseVoice Base = Create(id)

	Base.Name    = "Wolf 1 (Creature)"
	Base.Gender  = Creature
	
	Base.Mild    = Game.GetFormFromFile(0x8B5BB, "SexLab.esm") as Sound
	Base.Medium  = Game.GetFormFromFile(0x8B5BB, "SexLab.esm") as Sound
	Base.Hot     = Game.GetFormFromFile(0x8B5BB, "SexLab.esm") as Sound

	Base.Enjoy1  = none
	Base.Enjoy2  = none
	Base.Enjoy3  = none
	Base.Feel1   = none
	Base.Feel2   = none
	Base.Feel3   = none	
	Base.Happy1  = none
	Base.Happy2  = none
	Base.Happy3  = none
	Base.Horror1 = none
	Base.Horror2 = none
	Base.Horror3 = none
	Base.Pain1   = none
	Base.Pain2   = none
	Base.Pain3   = none
	Base.Hate1   = none
	Base.Hate2   = none
	Base.Hate3   = none

	Base.Giggle = none
	Base.Threaten = none

	Base.Moan    = none
	Base.Orgasm  = none

	Base.Kiss    = none
	Base.Lick    = none
	Base.SuckSlow= none
	Base.SuckFast= none
	Base.Deep    = none
	
	Base.AddRaceKey("Wolves")
	Base.AddRaceKey("Wolfpanic")

	Base.Save(id)
endFunction
