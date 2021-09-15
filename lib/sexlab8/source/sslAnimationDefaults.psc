scriptname sslAnimationDefaults extends sslAnimationFactory

function LoadAnimations()	
	; Prepare factory resources (as non creature)
	PrepareFactory()

	; Foreplay
	RegisterAnimation("LovingKiss")	
	RegisterAnimation("LayingForeplay")	
	RegisterAnimation("SittingForeplay")	
	RegisterCategory("Foreplay")

	RegisterOtherCategories()
endFunction

function LovingKiss(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name = "Loving Kiss"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "SP_Kissing_A1_S1", 0, silent = true, dress = true, sfxVoiceType="hapy")
	Base.AddPositionStage(a1, "SP_Kissing_A1_S2", 0, silent = true, dress = true, sfxVoiceType="kiss")
	Base.AddPositionStage(a1, "SP_Kissing_A1_S3", 0, silent = true, dress = true, sfxVoiceType="kiss")
	Base.AddPositionStage(a1, "SP_Kissing_A1_S4", 0, silent = true, dress = true, sfxVoiceType="kiss")
	Base.AddPositionStage(a1, "SP_Kissing_A1_S5", 0, silent = true, dress = true, sfxVoiceType="kiss", orgasmType="none")

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "SP_Kissing_A2_S1", -2, silent = true, dress = true)
	Base.AddPositionStage(a2, "SP_Kissing_A2_S2",  0, silent = true, dress = true)
	Base.AddPositionStage(a2, "SP_Kissing_A2_S3",  0, silent = true, dress = true)
	Base.AddPositionStage(a2, "SP_Kissing_A2_S4",  0, silent = true, dress = true)
	Base.AddPositionStage(a2, "SP_Kissing_A2_S5",  0, silent = true, dress = true, orgasmType="none")

	Base.SetStageTimer(3, 1.2)

	Base.SetTags("Foreplay,LeadIn,Loving,Straight,Mouth,Kissing,RSound")

	Base.Save(id)
endFunction

function LayingForeplay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Laying Foreplay"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "SP_LayingForeplay_A1_S1", 0, up=4, sfxVoiceType="joy")
	Base.AddPositionStage(a1, "SP_LayingForeplay_A1_S2", 0, up=4, sfxVoiceType="hapy")
	Base.AddPositionStage(a1, "SP_LayingForeplay_A1_S3", 0, up=0, silent = true, sfxVoiceType="kiss")
	Base.AddPositionStage(a1, "SP_LayingForeplay_A1_S4", 0, up=0, silent = true, orgasmType="none")

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "SP_LayingForeplay_A2_S1", 0, strapon = false, sos = 0)
	Base.AddPositionStage(a2, "SP_LayingForeplay_A2_S2", 0, strapon = false, sos = 3)
	Base.AddPositionStage(a2, "SP_LayingForeplay_A2_S3", 0, strapon = false, sos = 4, silent = true)
	Base.AddPositionStage(a2, "SP_LayingForeplay_A2_S4", 0, strapon = false, sos = 5, silent = true, orgasmType="none")

	Base.SetStageTimer(1, 10.0)

	Base.SetTags("Foreplay,LeadIn,Oral,Hands,Dick,Laying,Lying,OnBack,Cuddling,Loving,RSound")

	Base.Save(id)
endFunction

function SittingForeplay(int id)
	sslBaseAnimation Base = Create(id)

	Base.Name    = "Sitting Foreplay"

	int a1 = Base.AddPosition(Female)
	Base.AddPositionStage(a1, "SP_SittingForeplay_A1_S1", 0, up=3, sfxVoiceType="joy")
	Base.AddPositionStage(a1, "SP_SittingForeplay_A1_S2", 0, up=0, silent = true, sfxVoiceType="kiss")
	Base.AddPositionStage(a1, "SP_SittingForeplay_A1_S3", 0, up=0, silent = true, sfxVoiceType="kiss")
	Base.AddPositionStage(a1, "SP_SittingForeplay_A1_S4", 0, up=0, silent = true, orgasmType="none")

	int a2 = Base.AddPosition(Male)
	Base.AddPositionStage(a2, "SP_SittingForeplay_A2_S1", 0, strapon = false, sos = 1)
	Base.AddPositionStage(a2, "SP_SittingForeplay_A2_S2", 0, strapon = false, silent = true, sos = 2)
	Base.AddPositionStage(a2, "SP_SittingForeplay_A2_S3", 0, strapon = false, silent = true, sos = 3)
	Base.AddPositionStage(a2, "SP_SittingForeplay_A2_S4", 0, strapon = false, silent = true, sos = 5, orgasmType="none")

	Base.SetStageTimer(1, 10.0)

	Base.SetTags("Foreplay,LeadIn,Mouth,Hands,Handjob,Kissing,Cuddling,Laying,Loving,RSound")

	Base.Save(id)
endFunction