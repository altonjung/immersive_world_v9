scriptname ImmersiveAnimalFarmRat extends Actor

Event OnLoad()
    RegisterForSingleUpdateGameTime(0.1) 
EndEvent

Event OnUpdateGameTime()
	; -1 - No classification
	;  0 - Pleasant
	;  1 - Cloudy
	;  2 - Rainy
	;  3 - Snow
    int _weatherType =  Weather.GetCurrentWeather().GetClassification()	
    if _weatherType != 2
        float _currentHour = (Utility.GetCurrentGameTime() * 24.0) as Int % 24

        if _currentHour >= 1.0 && _currentHour <= 23.0
            SoundCoolTimePlay(SayAnimalRatCrySound)
            RegisterForSingleUpdateGameTime(Utility.RandomFloat(0.1, 0.2))
        else
            RegisterForSingleUpdateGameTime(0.5)
        endif
    else 
        RegisterForSingleUpdateGameTime(0.5)
    endif
EndEvent

Event OnDeath(Actor akKiller)
    UnregisterForUpdateGameTime()
EndEvent

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8)
	if self.IsSwimming() || self.IsInCombat()
		return
	endif

    bool shouldSendEvent = false

    Sound.SetInstanceVolume(_sound.Play(self), _volume)		
    ObjectReference[] _refArray = PO3_SKSEFunctions.FindAllReferencesOfFormType(self, 62, 4000.0)
    int _idx = 0
    actor _playerRef = Game.getPlayer()    
    while _idx < _refArray.length
        if _refArray[_idx] == _playerRef
            shouldSendEvent = true        
           _idx = _refArray.length
        endif
        _idx += 1
    endwhile	

    if shouldSendEvent
        utility.wait(2.0)
        ModEvent.Send(ModEvent.Create("ImaOwlCry"))
    endif
endFunction

; function Log(string _msg)
; 	MiscUtil.PrintConsole(_msg)
; endFunction

Sound property SayAnimalRatCrySound Auto