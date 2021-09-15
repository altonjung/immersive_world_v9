scriptname sslCreatureAnimationDefaults extends sslAnimationFactory

function LoadCreatureAnimations()
	; Prepare factory resources (as creature)
	PrepareFactoryCreatures()
	
	; Falmer
	RegisterAnimation("FalmerDoggystyle")
	RegisterCategory("Falmer")
	
	; Giant
	RegisterAnimation("GiantPenetration")
	RegisterAnimation("GiantHarrassment")
	RegisterAnimation("GiantHolding")
	RegisterCategory("Giant")
	
	; Riekling
	RegisterAnimation("RieklingMissionary")
	RegisterAnimation("RieklingThreeWay")
	RegisterCategory("Riekling")
	
	; Troll
	RegisterAnimation("TrollDoggystyle")
	RegisterAnimation("TrollHolding")
	RegisterAnimation("TrollMissionary")
	RegisterAnimation("TrollDominate")
	RegisterAnimation("TrollGrabbing")
	RegisterCategory("Troll")
	
	; Dawnguard Vampire Lord
	RegisterAnimation("VampireLordDoggystyle")
	RegisterAnimation("VampireLordHolding")
	RegisterAnimation("VampireLordMissionary")
	RegisterCategory("VampireLord")

	; Register any remaining custom categories from json loaders
	RegisterOtherCategories()
endFunction

function FalmerDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Falmer) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Falmers"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Falmer_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Falmers", CreatureMale)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Falmer_Doggystyle_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Falmer,Anal")

	Base.Save(id)
endFunction

function GiantPenetration(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Penetration"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Giants"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S1")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S2")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S3")
	Base.AddPositionStage(a1, "Giant_Penetration_A1_S4")

	int a2 = Base.AddCreaturePosition("Giants", CreatureMale)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S1", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S2", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S3", 35.0, rotate=180.0)
	Base.AddPositionStage(a2, "Giant_Penetration_A2_S4", 35.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Rough,Giant,Vaginal")

	Base.Save(id)
endFunction

function TrollDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "Troll_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Doggystyle_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Troll,Anal")

	Base.Save(id)
endFunction

function TrollHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Holding_A1_S1")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S2")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S3")
	Base.AddPositionStage(a1, "Troll_Holding_A1_S4")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Holding_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Troll,Vaginal")

	Base.Save(id)
endFunction

function TrollMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Troll_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S1", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S2", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S3", 45.0, rotate=180.0)
	Base.AddPositionStage(a2, "Troll_Missionary_A2_S4", 45.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Troll,Vaginal")

	Base.Save(id)
endFunction

function TrollDominate(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Dominate"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S1")
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S2")
	Base.AddPositionStage(a1, "Troll_Dominate_A1_S3")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S1")
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S2")
	Base.AddPositionStage(a2, "Troll_Dominate_A2_S3")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Missionary,Troll,Anal")

	Base.Save(id)
endFunction

function TrollGrabbing(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Troll) Grabbing"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Trolls"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S1")
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S2")
	Base.AddPositionStage(a1, "Troll_Grabbing_A1_S3")

	int a2 = Base.AddCreaturePosition("Trolls", CreatureMale)
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S1")
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S2")
	Base.AddPositionStage(a2, "Troll_Grabbing_A2_S3")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Doggystyle,Troll,Vaginal")

	Base.Save(id)
endFunction

function VampireLordDoggystyle(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Doggystyle"
	Base.SoundFX  = Squishing
	; Base.RaceType = "VampireLords"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Anal)
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Doggystyle_A1_S4")

	int a2 = Base.AddCreaturePosition("VampireLords", CreatureMale)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Doggystyle_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Doggystyle,Vampire Lord,Anal")

	Base.Save(id)
endFunction

function VampireLordHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "VampireLords"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Holding_A1_S4")

	int a2 = Base.AddCreaturePosition("VampireLords", CreatureMale)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Holding_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Holding,Vampire Lord,Vaginal")

	Base.Save(id)
endFunction

function VampireLordMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Vampire Lord) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "VampireLords"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, Vaginal)
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S1")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S2")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S3")
	Base.AddPositionStage(a1, "VampireLord_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("VampireLords", CreatureMale)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S1", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S2", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S3", 40.0, rotate=180.0)
	Base.AddPositionStage(a2, "VampireLord_Missionary_A2_S4", 40.0, rotate=180.0)

	Base.SetTags("Gone,Creature,Bestiality,Dirty,Missionary,Vampire Lord,Vaginal")

	Base.Save(id)
endFunction

function GiantHarrassment(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Harrassment"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Giants"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S1")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S2")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S3")
	Base.AddPositionStage(a1, "Giant_Harrassment_A1_S4")

	int a2 = Base.AddCreaturePosition("Giants", Creature)
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S1")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S2")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S3")
	Base.AddPositionStage(a2, "Giant_Harrassment_A2_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Holding,Rough,Giant,Vaginal")

	Base.Save(id)
endFunction

function GiantHolding(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Giant) Holding"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Giants"

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Giant_Holding_A1_S1")
	Base.AddPositionStage(a1, "Giant_Holding_A1_S2")
	Base.AddPositionStage(a1, "Giant_Holding_A1_S3")

	int a2 = Base.AddCreaturePosition("Giants", CreatureMale)
	Base.AddPositionStage(a2, "Giant_Holding_A2_S1")
	Base.AddPositionStage(a2, "Giant_Holding_A2_S2")
	Base.AddPositionStage(a2, "Giant_Holding_A2_S3")

	Base.SetTags("Panicforever,Creature,Bestiality,Dirty,Holding,Rough,Giant,Vaginal")

	Base.Save(id)
endFunction

function RieklingThreesome(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Threesome"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Rieklings"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S1")
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S2", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S3", silent = true, openMouth = true)
	Base.AddPositionStage(a1, "Riekling_Threesome_A1_S4", silent = true, openMouth = true)

	int a2 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S1")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S2")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S3")
	Base.AddPositionStage(a2, "Riekling_Threesome_A2_S4")

	int a3 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S1")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S2")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S3")
	Base.AddPositionStage(a3, "Riekling_Threesome_A3_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Gangbang,Riekling,Dirty,Vaginal,Oral")

	Base.Save(id)
endFunction


function RieklingMissionary(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Missionary"
	Base.SoundFX  = Squishing
	; Base.RaceType = "Rieklings"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalAnal)
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S1")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S2")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S3")
	Base.AddPositionStage(a1, "Riekling_Missionary_A1_S4")

	int a2 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S1")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S2")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S3")
	Base.AddPositionStage(a2, "Riekling_Threeway_A2_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Riekling,Dirty,Vaginal")

	Base.Save(id)
endFunction

function RieklingThreeWay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name     = "(Riekling) Three-Way"
	Base.SoundFX  = SexMix
	; Base.RaceType = "Rieklings"
	Base.GenderedCreatures = true

	int a1 = Base.AddPosition(Female, VaginalOralAnal)
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S1")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S2")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S3")
	Base.AddPositionStage(a1, "Riekling_ThreeWay_A1_S4")

	int a2 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S1")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S2")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S3")
	Base.AddPositionStage(a2, "Riekling_ThreeWay_A2_S4")

	int a3 = Base.AddCreaturePosition("Rieklings", CreatureMale)
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S1")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S2")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S3")
	Base.AddPositionStage(a3, "Riekling_ThreeWay_A3_S4")

	Base.SetTags("Panicforever,Creature,Bestiality,Gangbang,3P,Riekling,Dirty,Vaginal,Oral")

	Base.Save(id)
endFunction
