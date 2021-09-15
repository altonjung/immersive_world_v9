scriptname sslThreadController extends sslThreadModel
{ Animation Thread Controller: Runs manipulation logic of thread based on information from model. Access only through functions; NEVER create a property directly to this. }

; TODO: SetFirstAnimation() - allow custom defined starter anims instead of random
; TODO: ctrl+shift+u - 180 degree rotation

import PapyrusUtil

; Animation
float SkillTime

; SFX
float BaseDelay
float SFXDelay
float SFXTimer

; Processing
bool TimedStage
float StageTimer
int StageCount

; Adjustment hotkeys
sslActorAlias AdjustAlias
int AdjustPos
bool Adjusted
bool hkReady

Faction property SfxPlayRoleFaction auto hidden 
Faction property SfxPlayTypeFaction auto hidden 
Faction property SfxPositionFaction auto hidden
Faction property SfxStageFaction auto hidden

Sound 	property SfxPussySound auto hidden
Sound 	property SfxFuckSound auto hidden
Sound	property SfxWeakSound auto hidden

Sound	property Sfx_F_LickSound auto hidden
Sound	property Sfx_F_MouthSound auto hidden
Sound	property Sfx_F_DeepMouthSound auto hidden
Sound	property Sfx_F_AfraidSound auto hidden
Sound	property Sfx_F_FearSound auto hidden
Sound	property Sfx_F_HappySound auto hidden
Sound	property Sfx_F_JoySound auto hidden
Sound	property Sfx_F_KissSound auto hidden
Sound   property Sfx_F_PainSound auto hidden

Sound	property Sfx_M_LickSound auto hidden
Sound	property Sfx_M_MouthSound auto hidden
Sound	property Sfx_M_DeepMouthSound auto hidden
Sound	property Sfx_M_HappySound auto hidden
Sound	property Sfx_M_JoySound auto hidden
Sound	property Sfx_M_PleaseSound auto hidden
Sound	property Sfx_M_FantasySound auto hidden
Sound	property Sfx_M_KissSound auto hidden

Sound	property SfxBedSound auto hidden

Scene 	property SfxProstitueDialog auto hidden
Scene 	property SfxRapeDialog auto hidden
Scene 	property SfxSoloDialog auto hidden
Scene 	property SfxLoveDialog auto hidden
Scene 	property SfxDialogScene auto hidden

int 	property SfxPlayRoleType auto hidden
int     property SfxPlayType auto hidden
bool    property hasFurnitureRole  auto hidden

; ------------------------------------------------------- ;
; --- Init                                 --- ;
; ------------------------------------------------------- ;

event OnInit()	
	init()
endEvent

function init()
	SfxPlayRoleFaction	   = Game.GetFormFromFile(0x0200EFEE, "Sexlab plus.esp") as Faction	
	SfxPlayTypeFaction	   = Game.GetFormFromFile(0x02023860, "Sexlab plus.esp") as Faction	
	SfxPositionFaction     = Game.GetFormFromFile(0x02011599, "Sexlab plus.esp") as Faction
	SfxStageFaction        = Game.GetFormFromFile(0x020125C0, "Sexlab plus.esp") as Faction
	
	SfxPussySound      	   = Game.GetFormFromFile(0x02014617, "Sexlab plus.esp") as Sound
	SfxFuckSound      	   = Game.GetFormFromFile(0x02007400, "Sexlab plus.esp") as Sound
	SfxWeakSound		   = Game.GetFormFromFile(0x02020287, "Sexlab plus.esp") as Sound

	Sfx_F_LickSound        = Game.GetFormFromFile(0x0200842E, "Sexlab plus.esp") as Sound
	Sfx_F_MouthSound       = Game.GetFormFromFile(0x0200842D, "Sexlab plus.esp") as Sound
	Sfx_F_DeepMouthSound   = Game.GetFormFromFile(0x02009456, "Sexlab plus.esp") as Sound
	Sfx_F_KissSound		   = Game.GetFormFromFile(0x020222D5, "Sexlab plus.esp") as Sound

	Sfx_M_LickSound        = Game.GetFormFromFile(0x02024894, "Sexlab plus.esp") as Sound
	Sfx_M_MouthSound       = Game.GetFormFromFile(0x02025E20, "Sexlab plus.esp") as Sound
	Sfx_M_DeepMouthSound   = Game.GetFormFromFile(0x02025E21, "Sexlab plus.esp") as Sound
	Sfx_M_KissSound		   = Game.GetFormFromFile(0x02024893, "Sexlab plus.esp") as Sound

	SfxBedSound            = Game.GetFormFromFile(0x02007EC8, "Sexlab plus.esp") as Sound

	SfxProstitueDialog	   = Game.GetFormFromFile(0x0201CCA4, "Sexlab plus.esp") as Scene
	SfxLoveDialog	       = Game.GetFormFromFile(0x0201CCA4, "Sexlab plus.esp") as Scene
	SfxRapeDialog	       = Game.GetFormFromFile(0x0201CCA4, "Sexlab plus.esp") as Scene
	SfxSoloDialog	   	   = Game.GetFormFromFile(0x0201CCA4, "Sexlab plus.esp") as Scene
endfunction

; ------------------------------------------------------- ;
; --- Thread Starter                                  --- ;
; ------------------------------------------------------- ;

bool Prepared
state Prepare
	function FireAction()
		Prepared = false

		HookAnimationPrepare()

		; Ensure center is set
		if !CenterRef
			CenterOnObject(Positions[0], false)
		endIf
		if CenterAlias.GetReference() != CenterRef
			CenterAlias.TryToClear()
			CenterAlias.ForceRefTo(CenterRef)
		endIf
		; Set important vars needed for actor prep
		UpdateAdjustKey()
		if StartingAnimation && Animations.Find(StartingAnimation) != -1
			SetAnimation(Animations.Find(StartingAnimation))
		else
			SetAnimation()
			StartingAnimation = none
		endIf

		; Begin actor prep
		; SyncEvent(kPrepareActor, 30.0)
		ModEvent.Send(ModEvent.Create(Key("Prepare")))

		bool ready = false
		while ready == false
			int actorIdx = 0
			int readyCount = 0
			while actorIdx < actorCount
				if ActorAlias[actorIdx].kPrepareActor
					readyCount += 1
				endif
				actorIdx += 1
			endWhile
			Utility.wait(0.1)

			if readyCount == ActorCount
				ready = true
			endif
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function PrepareDone()
		RegisterForSingleUpdate(0.1)
	endFunction

	function StartupDone()
		RegisterForSingleUpdate(0.1)
	endFunction

	event OnUpdate()
		if !Prepared
			; Set starting adjusted actor
			AdjustPos   = (ActorCount > 1) as int
			AdjustAlias = PositionAlias(AdjustPos)
			; Get localized config options
			BaseDelay = Config.SFXDelay
			; Send starter events
			SendThreadEvent("AnimationStart")
			if LeadIn
				SendThreadEvent("LeadInStart")
			endIf
			; Start time trackers
			RealTime[0] = Utility.GetCurrentRealTime()
			SkillTime = RealTime[0]
			; Start actor loops
			; SyncEvent(kStartup, 10.0)

			ModEvent.Send(ModEvent.Create(Key("Startup")))
			Prepared = true

			RegisterForSingleUpdate(0.1)
		else
			; Start animating
			Action("Advancing")
		endIf
	endEvent

	function PlayStageAnimations()
	endFunction
	function ResetPositions()
	endFunction
	function RecordSkills()
	endFunction
	function SetBonuses()
	endFunction
endState

; ------------------------------------------------------- ;
; --- Animation Loop                                  --- ;
; ------------------------------------------------------- ;

state Advancing
	function FireAction()
		Log("Stage: "+ Stage + ", StageCount: " + StageCount, "Advancing")

		if Stage < 1
			Stage = 1

			string[] aniTags = Animation.GetRawTags()		
			SfxPlayRoleType = 0
			SfxPlayType = -1
			hasFurnitureRole = false
			SfxDialogScene = SfxProstitueDialog
			; 0:Prostitute, 1:Rape, 2:Love, 3:Solo
				
			if aniTags.Find("Prostitute") != -1
				SfxDialogScene = SfxProstitueDialog
				SfxPlayRoleType = 0
			elseif aniTags.Find("Rape") != -1
				SfxDialogScene = SfxRapeDialog
				SfxPlayRoleType = 1
			elseif aniTags.Find("Loving") != -1
				SfxDialogScene = SfxLoveDialog
				SfxPlayRoleType = 2
			elseif aniTags.Find("Solo") != -1
				SfxDialogScene = SfxSoloDialog
				SfxPlayRoleType = 3
			endif

			if aniTags.Find("Default") != -1
				SfxPlayType = 0
			elseif aniTags.Find("Aggressive") != -1
				SfxPlayType = 1			
			elseif aniTags.Find("Dirty") != -1
				SfxPlayType = 2				
			else
				SfxPlayType = 0							
			endif			
	
			if isBedRole || aniTags.Find("Furniture") != -1 || aniTags.Find("Chair") != -1
				hasFurnitureRole = true
			endif			
		elseIf Stage > StageCount
			if LeadIn
				EndLeadIn()
			else
				EndAnimation()
			endIf
			return
		endIf

		ModEvent.Send(ModEvent.Create(Key("Sync")))
				
		bool ready = false		
		while ready == false
			int readyCount = 0
			int actorIdx = 0
			while actorIdx < actorCount
				if ActorAlias[actorIdx].kSyncActor
					readyCount += 1
				endif
				actorIdx += 1
			endWhile
			Utility.wait(0.1)

			if readyCount == ActorCount
				ready = true
			endif
		endWhile
		
		; reset
		int actorIdx = 0	
		while actorIdx < actorCount
			ActorAlias[actorIdx].kSyncActor = false
			actorIdx += 1
		endWhile

		RegisterForSingleUpdate(0.1)
	endFunction

	; function SyncDone()
	; 	RegisterForSingleUpdate(0.1)
	; endFunction

	event OnUpdate()				
		HookStageStart()
		Action("Animating")
		SendThreadEvent("StageStart")
	endEvent
endState

state Animating

	function FireAction()
		UnregisterForUpdate()
		; Prepare loop
		RealTime[0] = Utility.GetCurrentRealTime()
		SoundFX  = Animation.GetSoundFX(Stage)
		SFXDelay = ClampFloat(BaseDelay - ((Stage * 0.3) * ((Stage != 1) as int)), 0.5, 30.0)
		ResolveTimers()
		PlayStageAnimations()
		; Send events
		if !LeadIn && Stage >= StageCount && !DisableOrgasms
			SendThreadEvent("OrgasmStart")
			TriggerOrgasm()
		endIf
		; Begin loop

		; update volume
		float volume = GetVolume(Positions[0])
		int idx=0
		while idx < ActorAlias.length
			ActorAlias[idx].onUpdateVolume(volume)
			idx+=1
		endWhile		

		RegisterForSingleUpdate(0.5)
	endFunction

	event OnUpdate()
		; Debug.Trace("(thread update)")
		; Update timer share
		RealTime[0] = Utility.GetCurrentRealTime()
		; Pause further updates if in menu
		if Utility.IsInMenuMode()
			
			int idx=0
			while idx < ActorAlias.length
				ActorAlias[idx].onMenuModeEnter()
				idx+=1
			endWhile

			while Utility.IsInMenuMode()
				Utility.WaitMenuMode(1.5)
				StageTimer += 1.2
			endWhile

			idx=0
			while idx < ActorAlias.length
				ActorAlias[idx].onMenuModeExit()
				idx+=1
			endWhile
		endIf
		; Advance stage on timer
		if (AutoAdvance || TimedStage) && StageTimer < RealTime[0]
			GoToStage((Stage + 1))
			return
		endIf
		; Play SFX
		if SoundFX && SFXTimer < RealTime[0]
			SoundFX.Play(CenterRef)
			SFXTimer = RealTime[0] + SFXDelay
		endIf
		; Loop
		RegisterForSingleUpdate(0.5)
	endEvent

	function EndAction()
		HookStageEnd()
		if !LeadIn && Stage > StageCount && !DisableOrgasms
			SendThreadEvent("OrgasmEnd")
		else
			SendThreadEvent("StageEnd")
		endIf
	endFunction

	function GoToStage(int ToStage)
		UnregisterForUpdate()
		Stage = ToStage
		Action("Advancing")
	endFunction

	; ------------------------------------------------------- ;
	; --- Hotkey functions                                --- ;
	; ------------------------------------------------------- ;

	function AdvanceStage(bool backwards = false)
		if !backwards
			GoToStage((Stage + 1))
		elseIf backwards && Stage > 1
			GoToStage((Stage - 1))
		endIf
	endFunction

	function ChangeAnimation(bool backwards = false)
		if Animations.Length < 2
			return ; Nothing to change
		endIf
		UnregisterForUpdate()
		
		if !Config.AdjustStagePressed()
			; Forward/Backward
			SetAnimation(sslUtility.IndexTravel(Animations.Find(Animation), Animations.Length, backwards))
		else
			; Random
			int current = Animations.Find(Animation)
			int r = Utility.RandomInt(0, (Animations.Length - 1))
			; Try to get something other than the current animation
			if r == current
				int tries = 10
				while r == current && tries > 0
					tries -= 1
					r = Utility.RandomInt(0, (Animations.Length - 1))
				endWhile
			endIf
			SetAnimation(r)
		endIf

		SendThreadEvent("AnimationChange")
		RegisterForSingleUpdate(0.2)
	endFunction

	function ChangePositions(bool backwards = false)
		if ActorCount < 2 || HasCreature
			return ; Solo/Creature Animation, nobody to swap with
		endIf
		UnregisterforUpdate()
		; GoToState("")
		; Find position to swap to
		int NewPos = sslUtility.IndexTravel(AdjustPos, ActorCount, backwards)
		Actor AdjustActor = Positions[AdjustPos]
		Actor MovedActor  = Positions[NewPos]
		if MovedActor == AdjustActor
			Log("MovedActor["+NewPos+"] == AdjustActor["+AdjustPos+"] -- "+Positions, "ChangePositions() Errror")
			RegisterForSingleUpdate(0.2)
			return
		endIf
		; Shuffle actor positions
		Positions[AdjustPos] = MovedActor
		Positions[NewPos] = AdjustActor
		; New adjustment profile
		; UpdateActorKey()
		UpdateAdjustKey()
		Log(AdjustKey, "Adjustment Profile")
		; Sync new positions
		AdjustPos = NewPos
		; GoToState("Animating")
		ResetPositions()
		SendThreadEvent("PositionChange")
		RegisterForSingleUpdate(1.0)
	endFunction

	function AdjustForward(bool backwards = false, bool AdjustStage = false)
		UnregisterforUpdate()
		float Amount = SignFloat(backwards, 0.50)
		Adjusted = true
		PlayHotkeyFX(0, backwards)
		Animation.AdjustForward(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		int k = Config.AdjustForward
		while Input.IsKeyPressed(k)
			PlayHotkeyFX(0, backwards)
			Animation.AdjustForward(AdjustKey, AdjustPos, Stage, Amount, Config.AdjustStagePressed())
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function AdjustSideways(bool backwards = false, bool AdjustStage = false)
		UnregisterforUpdate()
		float Amount = SignFloat(backwards, 0.50)
		Adjusted = true
		PlayHotkeyFX(0, backwards)
		Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		AdjustAlias.RefreshLoc()
		int k = Config.AdjustSideways
		while Input.IsKeyPressed(k)
			PlayHotkeyFX(0, backwards)
			Animation.AdjustSideways(AdjustKey, AdjustPos, Stage, Amount, Config.AdjustStagePressed())
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function AdjustUpward(bool backwards = false, bool AdjustStage = false)
		float Amount = SignFloat(backwards, 0.50)
		UnregisterforUpdate()
		Adjusted = true
		PlayHotkeyFX(2, backwards)
		Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, Amount, AdjustStage)
		AdjustAlias.RefreshLoc()
		int k = Config.AdjustUpward
		while Input.IsKeyPressed(k)
			PlayHotkeyFX(2, backwards)
			Animation.AdjustUpward(AdjustKey, AdjustPos, Stage, Amount, Config.AdjustStagePressed())
			AdjustAlias.RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.1)
	endFunction

	function RotateScene(bool backwards = false)
		UnregisterForUpdate()
		float Amount = SignFloat(backwards, 15.0)
		PlayHotkeyFX(1, !backwards)
		CenterLocation[5] = CenterLocation[5] + Amount
		if CenterLocation[5] >= 360.0
			CenterLocation[5] = CenterLocation[5] - 360.0
		elseIf CenterLocation[5] < 0.0
			CenterLocation[5] = CenterLocation[5] + 360.0
		endIf
		ActorAlias[0].RefreshLoc()
		ActorAlias[1].RefreshLoc()
		ActorAlias[2].RefreshLoc()
		ActorAlias[3].RefreshLoc()
		ActorAlias[4].RefreshLoc()
		int k = Config.RotateScene
		while Input.IsKeyPressed(k)
			PlayHotkeyFX(1, !backwards)
			CenterLocation[5] = CenterLocation[5] + Amount
			if CenterLocation[5] >= 360.0
				CenterLocation[5] = CenterLocation[5] - 360.0
			elseIf CenterLocation[5] < 0.0
				CenterLocation[5] = CenterLocation[5] + 360.0
			endIf
			ActorAlias[0].RefreshLoc()
			ActorAlias[1].RefreshLoc()
			ActorAlias[2].RefreshLoc()
			ActorAlias[3].RefreshLoc()
			ActorAlias[4].RefreshLoc()
		endWhile
		RegisterForSingleUpdate(0.2)
	endFunction

	function AdjustSchlong(bool backwards = false)
		int Amount  = SignInt(backwards, 1)
		int Schlong = Animation.GetSchlong(AdjustKey, AdjustPos, Stage) + Amount
		if Math.Abs(Schlong) <= 9
			Adjusted = true
			Animation.AdjustSchlong(AdjustKey, AdjustPos, Stage, Amount)
			AdjustAlias.GetPositionInfo()
			Debug.SendAnimationEvent(Positions[AdjustPos], "SOSBend"+Schlong)
			PlayHotkeyFX(2, !backwards)
		endIf
	endFunction

	function AdjustChange(bool backwards = false)
		UnregisterForUpdate()
		if ActorCount > 1
			AdjustPos = sslUtility.IndexTravel(Positions.Find(AdjustAlias.ActorRef), ActorCount, backwards)
			AdjustAlias = ActorAlias(Positions[AdjustPos])
			Actor AdjustActor = AdjustAlias.ActorRef
			Config.SelectedSpell.Cast(AdjustActor, AdjustActor)
			PlayHotkeyFX(0, !backwards)
			string msg = "Adjusting Position For: "+AdjustActor.GetLeveledActorBase().GetName()			
			SexLabUtil.PrintConsole(msg)
		endIf
		RegisterForSingleUpdate(0.2)
	endFunction

	function RestoreOffsets()
		UnregisterForUpdate()
		Animation.RestoreOffsets(AdjustKey)
		RealignActors()
		RegisterForSingleUpdate(0.2)
	endFunction

	function CenterOnObject(ObjectReference CenterOn, bool resync = true)
		parent.CenterOnObject(CenterOn, resync)
		if resync
			RealignActors()
			SendThreadEvent("ActorsRelocated")
		endIf
	endFunction

	function CenterOnCoords(float LocX = 0.0, float LocY = 0.0, float LocZ = 0.0, float RotX = 0.0, float RotY = 0.0, float RotZ = 0.0, bool resync = true)
		parent.CenterOnCoords(LocX, LocY, LocZ, RotX, RotY, RotZ, resync)
		if resync
			RealignActors()
			SendThreadEvent("ActorsRelocated")
		endIf
	endFunction

	function MoveScene()
		; Stop animation loop
		UnregisterForUpdate()
		; Enable Controls
		sslActorAlias Slot = ActorAlias(PlayerRef)
		Slot.UnlockActor()
		Slot.StopAnimating(true)
		PlayerRef.StopTranslation()
		; Debug.SendAnimationEvent(PlayerRef, "IdleForceDefaultState")
		; Lock hotkeys and wait 7 seconds
		Debug.Notification("Player movement unlocked - repositioning scene in 7 seconds...")
		Utility.Wait(10.0)
		; Disable Controls
		Slot.LockActor()
		; Give player time to settle incase airborne
		Utility.Wait(1.0)
		; Recenter on coords to avoid stager + resync animations
		if !CenterOnBed(true, 150.0)
			CenterOnObject(PlayerRef, true)
		endIf
		; Return to animation loop
		ResetPositions()
	endFunction

	event OnKeyDown(int KeyCode)
		; StateCheck()
		if hkReady && !Utility.IsInMenuMode() ; || UI.IsMenuOpen("Console") || UI.IsMenuOpen("Loading Menu")
			hkReady = false
			int i = Hotkeys.Find(KeyCode)
			; Advance Stage
			if i == kAdvanceAnimation
				AdvanceStage(Config.BackwardsPressed())

			; Change Animation
			elseIf i == kChangeAnimation
				ChangeAnimation(Config.BackwardsPressed())

			; Forward / Backward adjustments
			elseIf i == kAdjustForward
				AdjustForward(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Up / Down adjustments
			elseIf i == kAdjustUpward
				AdjustUpward(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Left / Right adjustments
			elseIf i == kAdjustSideways
				AdjustSideways(Config.BackwardsPressed(), Config.AdjustStagePressed())

			; Rotate Scene
			elseIf i == kRotateScene
				RotateScene(Config.BackwardsPressed())

			; Adjust schlong bend
			elseIf i == kAdjustSchlong
				AdjustSchlong(Config.BackwardsPressed())

			; Change Adjusted Actor
			elseIf i == kAdjustChange
				AdjustChange(Config.BackwardsPressed())

			; RePosition Actors
			elseIf i == kRealignActors
				ResetPositions()

			; Change Positions
			elseIf i == kChangePositions
				ChangePositions(Config.BackwardsPressed())

			; Restore animation offsets
			elseIf i == kRestoreOffsets
				RestoreOffsets()

			; Move Scene
			elseIf i == kMoveScene
				MoveScene()

			; EndAnimation
			elseIf i == kEndAnimation
				if Config.BackwardsPressed()
					; End all threads
					Config.ThreadSlots.StopAll()
				else
					; End only current thread
					EndAnimation(true)
				endIf

			endIf
			hkReady = true
		endIf
	endEvent

	function MoveActors()
		Utility.wait(0.5)
		ActorAlias[0].RefreshLoc()
		ActorAlias[1].RefreshLoc()
		ActorAlias[2].RefreshLoc()
		ActorAlias[3].RefreshLoc()
		ActorAlias[4].RefreshLoc()
		Utility.wait(0.5)
	endFunction

	function RealignActors()
		UnregisterForUpdate()
		ActorAlias[0].SyncAll(true)
		ActorAlias[1].SyncAll(true)
		ActorAlias[2].SyncAll(true)
		ActorAlias[3].SyncAll(true)
		ActorAlias[4].SyncAll(true)
		Utility.wait(0.5)
		RegisterForSingleUpdate(0.5)
	endFunction

	function TriggerOrgasm()
		UnregisterForUpdate()
		if SoundFX && CenterRef && CenterRef.Is3DLoaded()
			SoundFX.Play(CenterRef)
		endIf
		QuickEvent("Orgasm")
		RegisterForSingleUpdate(0.5)
	endFunction

	function ResetPositions()
		UnregisterForUpdate()
		; SyncEvent(kRefreshActor, 10.0)
	
		ModEvent.Send(ModEvent.Create(Key("Refresh")))

		bool ready = false
		while ready == false
			int actorIdx = 0
			int readyCount = 0
			while actorIdx < actorCount
				if ActorAlias[actorIdx].kRefreshActor
					readyCount += 1
				endif
				actorIdx += 1
			endWhile
			Utility.wait(0.1)

			if readyCount == ActorCount
				ready = true
			endif
		endWhile		
		RegisterForSingleUpdate(0.1)
		GoToState("Refresh")
	endFunction
endState

state Refresh
	function RefreshDone()
		RegisterForSingleUpdate(0.5)
	endFunction
	function ResetPositions()
		RegisterForSingleUpdate(0.5)
	endFunction
	event OnUpdate()
		GoToState("Animating")
		FireAction()
	endEvent
endState

; ------------------------------------------------------- ;
; --- Context Sensitive Info                          --- ;
; ------------------------------------------------------- ;

function SetAnimation(int aid = -1)
	log("SetAnimation")
	; Randomize if -1
	if aid < 0 || aid >= Animations.Length
		aid = Utility.RandomInt(0, (Animations.Length - 1))
	endIf
	; Set active animation
	Animation = Animations[aid]
	; Inform player of animation being played now
	if DebugMode || HasPlayer
		string msg = "Playing Animation: " + Animation.Name
		SexLabUtil.PrintConsole(msg)
		Debug.Notification(msg)
	endIf
	; Update animation info
	RecordSkills()
	string[] Tags = Animation.GetRawTags()
	; IsType = [1] IsVaginal, [2] IsAnal, [3] IsOral, [4] IsLoving, [5] IsDirty
	IsType[1]  = Females > 0 && (Tags.Find("Vaginal") != -1 || Tags.Find("Pussy") != -1)
	IsType[2]  = Tags.Find("Anal")   != -1 || (Females == 0 && Tags.Find("Vaginal") != -1)
	IsType[3]  = Tags.Find("Oral")   != -1
	IsType[4]  = Tags.Find("Loving") != -1
	IsType[5]  = Tags.Find("Dirty")  != -1
	StageCount = Animation.StageCount
	SoundFX    = Animation.GetSoundFX(Stage)
	SetBonuses()
	; Check for out of range stage
	if Stage >= StageCount
		GoToStage((StageCount - 1))
	else
		TimedStage = Animation.HasTimer(Stage)
		if Stage == 1
			ResetPositions()
		else
			ActorAlias[0].SyncAll(true)
			ActorAlias[1].SyncAll(true)
			ActorAlias[2].SyncAll(true)
			ActorAlias[3].SyncAll(true)
			ActorAlias[4].SyncAll(true)
			Utility.WaitMenuMode(0.2)
			PlayStageAnimations()
		endIf
	endIf
endFunction

; 거리에 따라 볼륨값 획득 (조건절 수정 필요)
float function getvolume (actor ActorRef) 

	if hasPlayer
		return 0.5
	else 
		ObjectReference _actorRef = ActorRef as ObjectReference
		ObjectReference _playerRef = PlayerRef as ObjectReference
	
		float _distance = _actorRef.GetDistance(_playerRef)
		float _volume = 0.1
	
		if _distance < 1000
			_distance = (_distance / 150) / 10
			_volume = 0.5 - _distance
	
		elseif _distance < 100
			_distance = (_distance / 15) / 100
			_volume = 0.5 - _distance
		else
			_volume = 0.0
		endif

		return _volume
	endif 

endfunction

float function GetTimer()
	; Custom acyclic stage timer
	if TimedStage
		return Animation.GetTimer(Stage)
	endIf
	; Default stage timers
	int last = ( Timers.Length - 1 )
	if Stage < last
		return Timers[(Stage - 1)]
	elseIf Stage >= StageCount
		return Timers[last]
	endIf
	return Timers[(last - 1)]
endFunction

function ResolveTimers()
	parent.ResolveTimers()
	TimedStage = Animation.HasTimer(Stage)
	if TimedStage
		Log("Stage has timer: "+Animation.GetTimer(Stage))
	endIf
endFunction

float function GetAnimationRunTime()
	return Animation.GetTimersRunTime(Timers)
endFunction

function UpdateTimer(float AddSeconds = 0.0)
	TimedStage = true
	StageTimer += AddSeconds
endFunction

function EndLeadIn()
	if LeadIn
		UnregisterForUpdate()
		; Swap to non lead in animations
		Stage  = 1
		LeadIn = false
		SetAnimation()
		; Add runtime to foreplay skill xp
		SkillXP[0] = SkillXP[0] + (TotalTime / 10.0)
		; Restrip with new strip options
		QuickEvent("Strip")
		; Start primary animations at stage 1
		SendThreadEvent("LeadInEnd")
		Action("Advancing")
	endIf
endFunction

function EndAnimation(bool Quickly = false)
	UnregisterForUpdate()
	Stage   = StageCount
	FastEnd = Quickly
	if HasPlayer
		MiscUtil.SetFreeCameraState(false)
		if Game.GetCameraState() == 0
			Game.ForceThirdPerson()
		endIf
	endIf
	Utility.WaitMenuMode(0.5)
	GoToState("Ending")
endFunction

state Ending
	event OnBeginState()
		UnregisterForUpdate()
		HookAnimationEnding()
		SendThreadEvent("AnimationEnding")
		RecordSkills()
		DisableHotkeys()
		Config.DisableThreadControl(self)
		; SyncEvent(kResetActor, 30.0)
		ModEvent.Send(ModEvent.Create(Key("Reset")))

		bool ready = false
		while ready == false
			int actorIdx = 0
			int readyCount = 0
			while actorIdx < actorCount
				if ActorAlias[actorIdx].kResetActor
					readyCount += 1
				endif
				actorIdx += 1
			endWhile
			Utility.wait(0.1)

			if readyCount == ActorCount
				ready = true
			endif
		endWhile		
		RegisterForSingleUpdate(0.1)
	endEvent
	event OnUpdate()
		ResetDone()
	endEvent
	function ResetDone()
		UnregisterforUpdate()
		HookAnimationEnd()
		SendThreadEvent("AnimationEnd")
		if Adjusted
			Log("Auto saving adjustments...")
			sslSystemConfig.SaveAdjustmentProfile()
		endIf
		GoToState("Frozen")
	endFunction
	; Don't allow to be called twice
	function EndAnimation(bool Quickly = false)
	endFunction
endState

state Frozen
	; Hold before full reset so hook events can finish
	event OnBeginState()
		RegisterForSingleUpdate(10.0)
	endEvent
	event OnEndState()
		Log("Returning to thread pool...")
	endEvent
	event OnUpdate()
		Initialize()
	endEvent
	function EndAnimation(bool Quickly = false)
	endFunction
endState

; ------------------------------------------------------- ;
; --- System Use Only                                 --- ;
; ------------------------------------------------------- ;

function RecordSkills()
	float TimeNow = RealTime[0]
	float xp = ((TimeNow - SkillTime) / 8.0)
	if xp >= 0.5
		if IsType[1]
			SkillXP[1] = SkillXP[1] + xp
		endIf
		if IsType[2]
			SkillXP[2] = SkillXP[2] + xp
		endIf
		if IsType[3]
			SkillXP[3] = SkillXP[3] + xp
		endIf
		if IsType[4]
			SkillXP[4] = SkillXP[4] + xp
		endIf
		if IsType[5]
			SkillXP[5] = SkillXP[5] + xp
		endIf
	endIf
	SkillTime = TimeNow
endfunction

function SetBonuses()
	SkillBonus[0] = SkillXP[0]
	if IsType[1]
		SkillBonus[1] = SkillXP[1]
	endIf
	if IsType[2]
		SkillBonus[2] = SkillXP[2]
	endIf
	if IsType[3]
		SkillBonus[3] = SkillXP[3]
	endIf
	if IsType[4]
		SkillBonus[4] = SkillXP[4]
	endIf
	if IsType[5]
		SkillBonus[5] = SkillXP[5]
	endIf
endFunction

function EnableHotkeys(bool forced = false)
	if HasPlayer || forced
		; Prepare bound keys
		Hotkeys = new int[13]
		Hotkeys[kAdvanceAnimation] = Config.AdvanceAnimation
		Hotkeys[kChangeAnimation]  = Config.ChangeAnimation
		Hotkeys[kChangePositions]  = Config.ChangePositions
		Hotkeys[kAdjustChange]     = Config.AdjustChange
		Hotkeys[kAdjustForward]    = Config.AdjustForward
		Hotkeys[kAdjustSideways]   = Config.AdjustSideways
		Hotkeys[kAdjustUpward]     = Config.AdjustUpward
		Hotkeys[kRealignActors]    = Config.RealignActors
		Hotkeys[kRestoreOffsets]   = Config.RestoreOffsets
		Hotkeys[kMoveScene]        = Config.MoveScene
		Hotkeys[kRotateScene]      = Config.RotateScene
		Hotkeys[kEndAnimation]     = Config.EndAnimation
		Hotkeys[kAdjustSchlong]    = Config.AdjustSchlong
		int i
		while i < Hotkeys.Length
			RegisterForKey(Hotkeys[i])
			i += 1
		endwhile
		; Prepare soundfx
		HotkeyUp   = Config.HotkeyUp
		HotkeyDown = Config.HotkeyDown
		; Ready
		hkReady = true
	endIf
endFunction

function DisableHotkeys()
	UnregisterForAllKeys()
	hkReady = false
endFunction

function Initialize()
	Config.DisableThreadControl(self)
	DisableHotkeys()
	SFXTimer    = 0.0
	SkillTime   = 0.0
	TimedStage  = false
	Adjusted    = false
	AdjustPos   = 0
	AdjustAlias = ActorAlias[0]
	parent.Initialize()
endFunction

int function GetAdjustPos()
	return AdjustPos
endFunction

function PlayStageAnimations()
	if Stage <= StageCount
		Animation.GetAnimEvents(AnimEvents, Stage)

		QuickEvent("PrepareAnimate")
		; actoralias 애니메이션 준비 동기화
		bool ready = false
		while ready == false
			int actorIdx = 0
			int readyCount = 0
			while actorIdx < actorCount
				if ActorAlias[actorIdx].KAnimateReady == Stage
					readyCount += 1
				endif
				actorIdx += 1
			endWhile
			Utility.wait(0.1)

			if readyCount == ActorCount
				ready = true
			endif
		endWhile
		QuickEvent("StartAnimate")
		StageTimer = RealTime[0] + GetTimer()
	endIf
endFunction

; ------------------------------------------------------- ;
; --- Thread Events - Alton.jung	                  --- ;
; ------------------------------------------------------- ;

String function getVoiceType(actor _actor)
	String vType = "Player"

	int Gender     = ActorLib.GetGender(_actor)
	bool IsCreature = Gender >= 2
	bool IsPlayer   = _actor == PlayerRef

	if isCreature 

	else 
		ActorBase actBase = _actor.GetBaseObject() as ActorBase    
		VoiceType actVoiceType = actBase.GetVoiceType()
		int formId= actVoiceType.GetFormID()

		; female   
		if _actor.GetActorBase().getSex() == 1 
			; if IsPlayer
			; 	vType = "Player"

			; elseif formId == 0x13AE9
			; 	vType = "Teen"
	
			; elseif formId == 0x13ADC
			; 	vType = "Young"
				
			; elseif formId == 0x13AE5
			; 	vType = "Coward"
	
			; elseif formId == 0x13AE0 || formId == 0x13BC3
			; 	vType = "Sultry"
	
			; elseif formId == 0x13AE4
			; 	vType = "Confident"     
							
			; elseif formId == 0x13ADD
			; 	vType = "Even"              
	
			; elseif formId == 0x13AF3 || formId == 0x13Af1 ; elf
			; 	vType = "Young"
	
			; elseif formId == 0x13AE3 || formId == 0x1B560
			; 	vType = "Solder"
						
			; elseif formId == 0x13AE1 || formId == 0x13AE2 
			; 	vType = "Old"
	
			; elseif formId == 0x13AE8 ; orc
			; 	vType = "Orc"
	
			; elseif formId == 0x13AED ; Khajit
			; 	vType = "Khajit"
	
			; elseif formId == 0x13AE9 ; Argonian
			; 	vType = "Argonian"
			; endif          
			vType = "Player"
		else 
			; male
		endif        
	
	endif 
	return vType
endFunction


; ------------------------------------------------------- ;
; --- Thread Events - SYSTEM USE ONLY                 --- ;
; ------------------------------------------------------- ;



; ------------------------------------------------------- ;
; --- State Restricted                                --- ;
; ------------------------------------------------------- ;

auto state Unlocked
	function EndAnimation(bool Quickly = false)
	endFunction
endState

; State Animating
function AdvanceStage(bool backwards = false)
endFunction
function ChangeAnimation(bool backwards = false)
endFunction
function ChangePositions(bool backwards = false)
endFunction
function AdjustForward(bool backwards = false, bool AdjustStage = false)
endFunction
function AdjustSideways(bool backwards = false, bool AdjustStage = false)
endFunction
function AdjustUpward(bool backwards = false, bool AdjustStage = false)
endFunction
function RotateScene(bool backwards = false)
endFunction
function AdjustSchlong(bool backwards = false)
endFunction
function AdjustChange(bool backwards = false)
endFunction
function RestoreOffsets()
endFunction
function MoveScene()
endFunction
function RealignActors()
endFunction
function MoveActors()
endFunction
function GoToStage(int ToStage)
endFunction
function ResetPositions()
endFunction
function TriggerOrgasm()
endFunction

int[] Hotkeys
int property kAdvanceAnimation = 0  autoreadonly hidden
int property kChangeAnimation  = 1  autoreadonly hidden
int property kChangePositions  = 2  autoreadonly hidden
int property kAdjustChange     = 3  autoreadonly hidden
int property kAdjustForward    = 4  autoreadonly hidden
int property kAdjustSideways   = 5  autoreadonly hidden
int property kAdjustUpward     = 6  autoreadonly hidden
int property kRealignActors    = 7  autoreadonly hidden
int property kRestoreOffsets   = 8  autoreadonly hidden
int property kMoveScene        = 9  autoreadonly hidden
int property kRotateScene      = 10 autoreadonly hidden
int property kEndAnimation     = 11 autoreadonly hidden
int property kAdjustSchlong    = 12 autoreadonly hidden

Sound[] HotkeyDown
Sound[] HotkeyUp
function PlayHotkeyFX(int i, bool backwards)
	if backwards
		HotkeyDown[i].Play(Positions[AdjustPos])
	else
		HotkeyUp[i].Play(Positions[AdjustPos])
	endIf
endFunction

event OnKeyDown(int keyCode)
	; StateCheck()
endEvent

;/ function StateCheck()
	Log("THREAD STATE: "+GetState())
	if ActorCount == 1
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
	elseIf ActorCount == 2
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
		ActorAlias[1].Log("State: "+ActorAlias[1].GetState())
	elseIf ActorCount == 3
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
		ActorAlias[1].Log("State: "+ActorAlias[1].GetState())
		ActorAlias[2].Log("State: "+ActorAlias[2].GetState())
	elseIf ActorCount == 4
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
		ActorAlias[1].Log("State: "+ActorAlias[1].GetState())
		ActorAlias[2].Log("State: "+ActorAlias[2].GetState())
		ActorAlias[3].Log("State: "+ActorAlias[3].GetState())
	elseIf ActorCount == 5
		ActorAlias[0].Log("State: "+ActorAlias[0].GetState())
		ActorAlias[1].Log("State: "+ActorAlias[1].GetState())
		ActorAlias[2].Log("State: "+ActorAlias[2].GetState())
		ActorAlias[3].Log("State: "+ActorAlias[3].GetState())
		ActorAlias[4].Log("State: "+ActorAlias[4].GetState())
	endIf
endFunction /;