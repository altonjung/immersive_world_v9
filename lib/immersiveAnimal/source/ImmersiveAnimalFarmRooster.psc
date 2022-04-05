scriptname ImmersiveAnimalFarmRooster extends Actor

Event OnLoad()  
    RegisterForSingleUpdateGameTime(0.1)
EndEvent

Event OnUpdateGameTime()
    float _currentHour = (Utility.GetCurrentGameTime() * 24.0) as Int % 24

	; -1 - No classification
	;  0 - Pleasant
	;  1 - Cloudy
	;  2 - Rainy
	;  3 - Snow    
    int _weatherType =  Weather.GetCurrentWeather().GetClassification()	
    if _weatherType != 2        
        if _currentHour > 3.0 && _currentHour < 5.0
            RegisterForSingleUpdateGameTime(0.5)
        elseif _currentHour >= 5.0 && _currentHour <= 9.0
            SoundCoolTimePlay(SayAnimalRoosterCrySound)
            RegisterForSingleUpdateGameTime(Utility.RandomFloat(0.2, 0.4))
        else
            RegisterForSingleUpdateGameTime(2.0)
        endif
    else
        RegisterForSingleUpdateGameTime(1.0)
    endif
EndEvent

Event OnDeath(Actor akKiller)
    UnregisterForUpdateGameTime()
EndEvent

function SoundCoolTimePlay(Sound _sound, float _volume = 0.8, float _coolTime = 3.0)
	if self.IsSwimming() || self.IsInCombat()
		return
	endif

    bool shouldSendEvent = false

    Sound.SetInstanceVolume(_sound.Play(self), _volume)		
    ObjectReference[] _refArray = PO3_SKSEFunctions.FindAllReferencesOfFormType(self, 62, 2500.0)
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
        ModEvent.Send(ModEvent.Create("ImaRoosterCry"))
    endif
endFunction

function Log(string _msg)
	MiscUtil.PrintConsole(_msg)
endFunction

Sound property SayAnimalRoosterCrySound Auto