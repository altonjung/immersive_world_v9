Scriptname SexlabSoundScript extends Quest

Actor Property Player  Auto

Sound Property FurnitureSoundRes  Auto

SexLabFramework property SexLab auto

bool[] actorVictimList = none
sslThreadController sslController = none

event OnInit()
    Debug.Notification("Sexlab Plus Sound v0.1 Load..")

    RegisterForModEvent("AnimationStart", "Begin")
	RegisterForModEvent("StageStart", "StageStart")
    RegisterForModEvent("StageEnd", "StageEnd")
	RegisterForModEvent("OrgasmStart", "OrgasmStart")
    RegisterForModEvent("OrgasmEnd", "OrgasmEnd")
    RegisterForModEvent("AnimationEnd", "Done")     
endEvent

Sound[] mildSoundSfx = none
Sound[] mediumSoundSfx = none
Sound[] hotSoundSfx = none
Sound[] orgasmSoundSfx = none

Actor[] actorList = none

int progress = 0

function soundLoad(string _sceneType, string _voiceType, int _genderType, int _actorIdx) 
    mildsoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA87, "SexlabPlusSound.esp") As Sound) ; mild
    mediumSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA86, "SexlabPlusSound.esp") As Sound) ; medium		
    hotSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA85, "SexlabPlusSound.esp") As Sound) ; hot
    orgasmSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA88, "SexlabPlusSound.esp") As Sound) ; orgasm

    ; if _sceneType == "normal" 
    ;     if _voiceType == "player"
    ;         mildsoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA87, "SexlabPlusSound.esp") As Sound) ; mild
    ;         mediumSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA86, "SexlabPlusSound.esp") As Sound) ; medium		
    ;         hotSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA85, "SexlabPlusSound.esp") As Sound) ; hot
    ;         orgasmSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA88, "SexlabPlusSound.esp") As Sound) ; orgasm
    ;     endif
    
    ; elseif _sceneType == "aggressive" 
    ;     if _voiceType == "player"
    ;         mildsoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA87, "SexlabPlusSound.esp") As Sound) ; mild
    ;         mediumSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA86, "SexlabPlusSound.esp") As Sound) ; medium		
    ;         hotSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA85, "SexlabPlusSound.esp") As Sound) ; hot
    ;         orgasmSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA88, "SexlabPlusSound.esp") As Sound) ; orgasm
    ;     endif
    
    ; else 
    ;     if _voiceType == "player"
    ;         mildsoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA87, "SexlabPlusSound.esp") As Sound) ; mild
    ;         mediumSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA86, "SexlabPlusSound.esp") As Sound) ; medium		
    ;         hotSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA85, "SexlabPlusSound.esp") As Sound) ; hot
    ;         orgasmSoundSfx[_actorIdx] =  (Game.GetFormFromFile(0x0605BA88, "SexlabPlusSound.esp") As Sound) ; orgasm
    ;     endif    
    ; endif 

endfunction

function playActorVoice(int _progress, int _actorIdx, Actor _actor, float _volumn)

    if 70 < _progress 
       _volumn += 0.2
    endif

    Sound.SetInstanceVolume(mildSoundSfx[_actorIdx].Play(_actor), _volumn) 
    
endfunction

event OnUpdate()

    if actorList[0]

        ObjectReference _actorRef = actorList[0] as ObjectReference
        ObjectReference _playerRef = Player as ObjectReference

        float _distance = _actorRef.GetDistance(_playerRef)

        float _volumn = 0.1

        ; if _distance < 30.0
        ;     _volumn = 0.8
        ; elseif _distance < 50.0
        ;     _volumn = 0.7
        ; elseif _distance < 80.0
        ;     _volumn = 0.6
        ; elseif _distance < 100.0 
        ;     _volumn = 0.5
        ; elseif _distance < 200.0  
        ;     _volumn = 0.4
        ; elseif _distance < 400.0
        ;     _volumn = 0.35
        ; elseif _distance < 500.0
        ;     _volumn = 0.3        
        ; elseif _distance < 600.0
        ;     _volumn = 0.25        
        ; elseif _distance < 700.0
        ;     _volumn = 0.2
        ; elseif _distance < 1000.0
        ;     _volumn = 0.15
        ; elseif _distance < 1500.0
        ;     _volumn = 0.1        
        ; else
        ;     _volumn = 0.0
        ; endif

        if _volumn > 0.0
            int idx=0
            while idx < actorList.length
                    Actor _actor = actorList[idx]
                    int gender = Sexlab.GetGender(_actor)                
                    if gender < 2   ; 사람인 경우(남,여)만 활용
                        ; victim 여부 확인
                        if idx == 0
                            playActorVoice(progress, idx, _actor, _volumn)
                        endif     
                    endif
                    idx += 1 
            endWhile 
        endif
        RegisterForSingleUpdate(3.0)
    endif
endEvent

; sexlab support
event Begin(string eventName, string argString, float argNum, form sender)
    mildSoundSfx = new Sound[5]
    mediumSoundSfx = new Sound[5]
    hotSoundSfx = new Sound[5]
    orgasmSoundSfx = new Sound[5]

    sslBaseAnimation anim = SexLab.HookAnimation(argString)    
    sslController = SexLab.HookController(argString)       
        
    ; Scene에 참여 전체 액터 리스트 조회
    actorList = SexLab.HookActors(argString)

    ; actor 정보 구성
    int numOfActor = actorList.length
    int idx=0    
    bool isRapeScene = false 

    if numOfActor > 1
        Actor _actor = actorList[0]
        int _gender = Sexlab.GetGender(_actor)
        if _gender < 2   ; 사람인 경우(남,여)만 활용
            ; victim 여부 확인
            if sslController.IsVictim(_actor)
                isRapeScene = true
                Debug.Notification("rape scene")
            endif
        endif    
    endif 
    
    idx=0
    if isRapeScene 
        while idx < numOfActor
                Actor _actor = actorList[idx]
                int _gender = Sexlab.GetGender(_actor)                
                if _gender < 2   ; 사람인 경우(남,여)만 활용
                    bool isVictim = sslController.IsVictim(_actor)    
                    String _actorvType = getVoiceTypeIdx(_actor)

                    ; 섹랩 목소리 disabled                    
                    sslController.ActorAlias(_actor).SetVoice(none, ForceSilence=true)
                    
                    ; 목소리 선택
                    if isVictim == true
                       soundLoad("victim", _actorvType, _gender, idx)
                    else 
                       soundLoad("aggressive", _actorvType, _gender, idx)
                    endif
                endif
                idx += 1 
        endWhile    
    Else
        while idx < numOfActor        
                Actor _actor = actorList[idx]
                int _gender = Sexlab.GetGender(_actor)                
                if _gender < 2   ; 사람인 경우(남,여)만 활용
                     String _actorvType = getVoiceTypeIdx(_actor)
                    ; 목소리 선택
                    soundLoad("normal", _actorvType, _gender, idx)
                endif
                idx += 1 
        endWhile            
    endif 

    animName = anim.Name

    if anim.HasTag("Foreplay") || anim.HasTag("LeadIn") 
        curStage = "foreplay"
    else 
        curStage = "play"
    endif 

    RegisterForSingleUpdate(2.0)
    Debug.Notification("Begin = " + argString + ", Tag = " + anim.Name)
endEvent

event StageStart(string eventName, string argString, float argNum, form sender)
    
    sslBaseAnimation anim = SexLab.HookAnimation(argString)
    Int totalStageCount = anim.StageCount()
    Int curStageCount = SexLab.HookStage(argString)

    if animName != anim.name
        curStage = "play"
    endif

    If curStage == "foreplay"
        if curStageCount == 1        ; animation 단계에서 첫번재 스테이지
            Debug.Notification("ForePlay Stage")            
        endif        

    elseIf curStage == "play"
       ; Debug.Notification("CollisionStartTime " + anim.GetCollisionStartTime(0, curStageCount))

        if curStageCount == 1        ; animation 단계에서 첫번재 스테이지        

            ; bed sqweaky sound
            ; if sslController.CenterOnBed(false, 750.0) || anim.HasTag("Furniture") || anim.HasTag("Chair")
            ;     isFurnitureSfx = true
            ; endif
            Debug.Notification("Play Stage")            
        endif 
    endif
    
    progress = (curStageCount * 100) / totalStageCount 

    RegisterForSingleUpdate(2.0)
    Debug.Notification("Stage -> anim = " + anim.Name +", curStg = " + curStageCount + ", toStg = " +  totalStageCount + ", curStage = " + curStage)      
endevent

event StageEnd(string eventName, string argString, float argNum, form sender)
    UnregisterForUpdate()
endEvent

event OrgasmStart(string eventName, string argString, float argNum, form sender)

endevent

event OrgasmEnd(string eventName, string argString, float argNum, form sender)

endevent


int function getVoiceTypeIdx(actor _actor)

	int vType = 0
	ActorBase actBase = _actor.GetBaseObject() as ActorBase    
	VoiceType actVoiceType = actBase.GetVoiceType()
    int formId= actVoiceType.GetFormID()
    int gender = _actor.GetActorBase().getSex()

    if gender == 1 
        ; female   
		if _actor == Game.GetPlayer()
			vType = 0

		elseif formId == 0x13AE9 ;Teen
			vType = 1

		elseif formId == 0x13ADC ;young
            vType = 2
            
		elseif formId == 0x13AE5 ;coward
			vType = 3        

		elseif formId == 0x13AE0 ;sultry
            vType = 3

		elseif formId == 0x13BC3 ;shrill
            vType = 3  

		elseif formId == 0x13AE4 ;con
			vType = 3            
                        
		elseif formId == 0x13ADD ;even
            vType = 4                       

		elseif formId == 0x13AF3 || formId == 0x13Af1 ; elf
			vType = 4

		elseif formId == 0x13AE3 ;commander
            vType = 4               
            
		elseif formId == 0x1B560 ;solder
			vType = 4              
		
		elseif formId == 0x13AE1 || formId == 0x13AE2 ; old
			vType = 5 

		elseif formId == 0x13AE8 ; orc
			vType = 6

		elseif formId == 0x13AED ; Khajit
			vType = 7

		elseif formId == 0x13AE9 ; Argonian
            vType = 8                   
			
		else 
			vType = 3
        endif  
        
    else 
        ; male
        vType = 1
	endif        

	return vType
endFunction


event Done(string eventName, string argString, float argNum, form sender)
    ; isFurnitureSfx = false
    ; isFistHitSfx = false

    curStage = "foreplay"
    animName = "nothing"
    ftimestart = 0.0    
    sslController = none
    actorList = none
endEvent

float   ftimeStart = 0.0

string  animName = "nothing"
string  curStage = "foreplay"  ; foreplay, play, orgasm, postplay

; bool    isFurnitureSfx = false
; bool    isFistHitSfx = false









