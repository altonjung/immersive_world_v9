scriptname FrameworkMain extends Quest
;/*  
* * This is a Property of SexLab and it is important to set it with the name of your mod if you are extending this script SexLab Framework
* * e.g. "Scriptname mySexLabMod extends SexLabFramework" Letting you call all functions here directly from your script as if they were it's own.
* * (currently this is unused by SexLab, but may or may not be used in the future.)
*/;
string property ModName auto

;/* The current SexLab script version as represented by a basic int version number, for example: 16100 for 1.61 */;
int function GetVersion()
	return FrameworkUtil.GetVersion()
endFunction

;/* The current SexLab script version as represented by a more user friendly string, for example: "1.60b" for 16001 */;
string function GetStringVer()
	return FrameworkUtil.GetStringVer()
endFunction

;/* A readonly property that tells you whether or not SexLab is currently enabled and able to start a new scene */;
bool property Enabled hidden
	bool function get()
		return GetState() != "Disabled"
	endFunction
endProperty

;/* A readonly property that returns TRUE if SexLab is currently actively playing a sex animation */;
bool property IsRunning hidden
	bool function get()
		return ThreadSlots.IsRunning()
	endFunction
endProperty

;/* A readonly property that, like IsRunning tells you if, this tells you how many (out of max 15) animations are currently playing */;
int property ActiveAnimations hidden
	int function get()
		return ThreadSlots.ActiveThreads()
	endFunction
endProperty
;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                          API RELATED FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

sslThreadModel function NewThread(float TimeOut = 30.0)
	; Claim an available thread
	return ThreadSlots.PickModel(TimeOut)
endFunction

;/* StartSex 
* * This is an easy and quick function to start a Sexlab animation without requiring too much code.
* * The difference between StartSex and QuickStart is that StartSex requires a list of animations (at least one), while QuickStart grabs the animations using animation Tags
* * 
* * @param: Positions, is an array of Actors that will be used in the animation, up to 5 actors are supported. The very first is considered to be the "Passive Position". If actors are unspecified this function will fail.
* * @param: Anims, is an array of sslBaseAnimation, and it is used to specify which animations will play. In case the animations are empty, not valid, or the number of the actors expected by the animation is not equal to the specified number of actors, then the animations are picked automatically by the default animation. (See GetAnimationsByDefault)
* * @param: Victim [OPTIONAL], if this Actor specified, then the specified actor (that should be one of the list of actors) will be considered as a victim.
* * @param: CenterOn [OPTIONAL], if the ObjectReference is specified, then the animation will be centered on the specified object. It can be a marker, a furniture, or any other possible ObjectReference.
* * @param: AllowBed, it is a boolean, if the value is false, then the animations requiring a bed will be filtered out
* * @param: Hook, you can specify a Hook for the animation, to register for the animation events (AnimationStart, AnimationEnd, OrgasmStart, etc.) See the Hooks section for further description
* *
* * @return: the tid of the thread that is allocated by the function, useable with GetController(). -1 if something went wrong and the animation will not start.
*/;
int function StartSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = none, ObjectReference CenterOn = none, bool AllowBed = true, string Hook = "")
	; Claim a thread
	sslThreadModel Thread = NewThread()
	if !Thread
		Log("StartSex() - Failed to claim an available thread")
		return -1
	; Add actors list to thread
	elseIf !Thread.AddActors(Positions, Victim)
		Log("StartSex() - Failed to add some actors to thread")
		return -1
	endIf
	; Configure our thread with passed arguments
	Thread.SetAnimations(Anims)
	Thread.CenterOnObject(CenterOn)
	Thread.DisableBedUse(!AllowBed)
	Thread.SetHook(Hook)
	; Start the animation
	if Thread.StartThread()
		return Thread.tid
	endIf
	return -1
endFunction

;/* QuickStart 
* * This is a very easy and quick function to start a Sexlab animation without requiring more than a single line of code.
* * The difference between StartSex and QuickStart is that StartSex requires a list of animations (at least one), while QuickStart grabs the animations using animation Tags\
* * This function is actually a wrapper around StartSex, that gets the animations by tags and then delegates StartSex to do the job.
* * 
* * @param: Actor Actor1, is the first position of the animation, and it is mandatory
* * @param: Actor Actor2 ... Actor5 [OPTIONAL], are the other actors involved in the animation.
* * @param: Actor Victim [OPTIONAL], if this Actor specified, then the specified actor (that should be one of the list of actors) will be considered as a victim.
* * @param: string Hook [OPTIONAL], you can specify a Hook for the animation, to register for the animation events (AnimationStart, AnimationEnd, OrgasmStart, etc.) See the Hooks section for further description
* * @param: string AnimationTags [OPTIONAL], is the list of tags the animation has to have. You can add more than one tag by separating them by commas "," (Example: "Oral, Aggressive, FemDom"), the animations will be collected if they have at least one of the specified tags.
* *
* * @return: the thread instance that is allocated by the function. NONE if something went wrong and the animation will not start.
*/;
sslThreadController function QuickStart(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, Actor Victim = none, string Hook = "", string AnimationTags = "")
	log("QuickStart")
	Actor[] Positions = FrameworkUtil.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
	sslBaseAnimation[] Anims
	if AnimationTags != ""
		int[] Genders = ActorLib.GenderCount(Positions)
		if (Genders[2] + Genders[3]) < 1
			Anims = AnimSlots.GetByTags(Positions.Length, AnimationTags, "", false)
		else
			Anims = CreatureSlots.GetByCreatureActorsTags(Positions.Length, Positions, AnimationTags, "", false)
		endIf
	endIf
	return ThreadSlots.GetController(StartSex(Positions, Anims, Victim, none, true, Hook))
endFunction
;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                       BEGIN BED FUNCTIONS                                                            #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* FindBed
* * Searches for a bed within a given radius from a provided center, and returns its ObjectReference.
* * 
* * @param: ObjectReference CenterRef - An object/actor/marker to use as the center point of your search.
* * @param: float Radius - The radius distance to search within the given CenterRef for a bed. 
* * @param: bool IgnoreUsed - When searching for beds, attempt to check if any actor is currently using the bed, in this case the bed will be ignored. 
* * @param: ObjectReference IgnoreRef1/IgnoreRef2 - A bed object that might be within the search radius, but you know you don't want.
* * @return: ObjectReference - The found valid bed within the radius. NONE if no bed found. 
*/;
ObjectReference function FindBed(ObjectReference CenterRef, float Radius = 1000.0, bool IgnoreUsed = true, ObjectReference IgnoreRef1 = none, ObjectReference IgnoreRef2 = none)
	return AniFrameUtil.FindBed(CenterRef, Radius, IgnoreUsed, IgnoreRef1, IgnoreRef2)
endFunction
;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                         BEGIN THREAD FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* GetController
* * Gets the thread associated with the given thread id number. Mostly used for getting the thread associated with a hook event.
* * 
* * @param: int tid - The thread id number of the thread you wish to retrieve. Should be a number between 0-14
* * @return: sslThreadController - The thread that the given tid belongs to.
*/;
sslThreadController function GetController(int tid)
	return ThreadSlots.GetController(tid)
endFunction

;/* FindActorController
* * Finds any thread controller an actor is currently associated with and returns it's thread id number.
* *
* * @param: Actor ActorRef - The actor to search for.
* * @return: int - The id of the ThreadController where the actor is currently in. -1 if the actor couldn't be found in any of the ThreadControllers.
*/;
int function FindActorController(Actor ActorRef)
	return ThreadSlots.FindActorController(ActorRef)
endFunction

;/* FindActorController
* * Finds any thread controller the player is currently associated with and returns it's thread id number
* * @return: int - The id of the ThreadController where the player is currently in. -1 if the player couldn't be found in any of the ThreadControllers.
*/;
int function FindPlayerController()
	return ThreadSlots.FindActorController(PlayerRef)
endFunction

;/* 
* * Finds any thread controller an actor is currently associated with and returns it.
* * 
* * @param: Actor ActorRef - The actor to search for.
* * @return: sslThreadController - The ThreadController the actor is currently part of. NONE if actor couldn't be found.
*/;
sslThreadController function GetActorController(Actor ActorRef)
	return ThreadSlots.GetActorController(ActorRef)
endFunction

;/* GetPlayerController
* * Finds any thread controller the player is currently associated with and returns it.
* * 
* * @return: sslThreadController - The ThreadController the player is currently part of. NONE if player couldn't be found.
*/;
sslThreadController function GetPlayerController()
	return ThreadSlots.GetActorController(PlayerRef)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                     END THREAD FUNCTIONS                                                      ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                        BEGIN ANIMATION FUNCTIONS                                                        #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* GetAnimationsByTags
* * Get an array of animations that have a specified set of tags.
* * 
* * @param: int ActorCount - The total number of actors that will participate in the animation, valid values are between 1 and 5. Each animation is specific for a defined number of actors.
* * @param: string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations. (E.g. "Leito,Vaginal,Missionary", to get the animation from Leito, in missionary position, where the mouth has some importance. All or just one of the tags? Depends on the value of the parameter RequireAll)
* * @param: string TagSuppress [OPTIONAL] - A comma separated list of animation tags you DO NOT want present on any of the returned animations. (E.g. "Aggressive" will filter out all the animations that have the tag "Aggressive")
* * @param: bool RequireAll [OPTIONAL True by default] - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed. (E.g. If the tags are "oral,Vaginal" and RequireAll is set to TRUE, then the animations found will have BOTH Oral and Vaginal tags; if RequireAll is set to FALSE, then the animation swill have just one of the two tags, and also both together will be returned in the list.)
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments. Be aware that the maximum number of returned animations is 128. Also if more animations that 128 are valid for the parameters specified.
*/;
sslBaseAnimation[] function GetAnimationsByTags(int ActorCount, string Tags, string TagSuppress = "", bool RequireAll = true)
	return AnimSlots.GetByTags(ActorCount, Tags, TagSuppress, RequireAll)
endFunction

;/* GetAnimationsByType
* * Get an array of animations that fit a specified set of parameters based on the genders of the participants
* *
* * @param: int ActorCount - The total number of actors that will participate in the animation, valid values are between 1 and 5. Each animation is specific for a defined number of actors.
* * @param: int Males [OPTIONAL] - The total number of males the returned animations should be intended for. Set to -1 for any amount.
* * @param: int Females [OPTIONAL] - The total number of females the returned animations should be intended for. Set to -1 for any amount.
* * @param: int StageCount [OPTIONAL] - The total number of stages the returned animations should contain. Set to -1 for any amount.
* * @param: bool Aggressive [OPTIONAL false by default] - TRUE if you want the animations returned to include ones tagged as aggressive.
* * @param: bool Sexual [OPTIONAL true by default] - FALSE if you want the animations returned to be LeadIn/Foreplay type tagged.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function GetAnimationsByType(int ActorCount, int Males = -1, int Females = -1, int StageCount = -1, bool Aggressive = false, bool Sexual = true)
	log("GetAnimationsByType")
	return AnimSlots.GetByType(ActorCount, Males, Females, StageCount, Aggressive, Sexual)
endFunction

;/* PickAnimationsByActors
* * Get an array of animations that fit the given array of actors using SexLab's default selection criteria.
* *  
* * @param: Actor[] Positions - An array of 1 to 5 actors you intend to use the resulting animations with.
* * @param: int Limit [OPTIONAL 64 by default] - Limits the number of animations returned to this amount. Searches that result in more than this will randomize the results to fit within the limit.
* * @param: bool Aggressive [OPTIONAL false by default] - TRUE if you want the animations returned to include ones tagged as aggressive.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
*/;
sslBaseAnimation[] function PickAnimationsByActors(Actor[] Positions, int Limit = 64, bool Aggressive = false)
	return AnimSlots.PickByActors(Positions, limit, aggressive)
endFunction

;/* GetAnimationsByDefault
* * Get an array of animations that fit the given number of males and females using SexLab's default selection criteria.
* *  
* * @param: int Males - The total number of males the returned animations should be intended for. Set to -1 for any amount.
* * @param: int Females - The total number of females the returned animations should be intended for. Set to -1 for any amount.
* * @param: bool IsAggressive - TRUE if the animations to be played are considered aggressive.
* * @param: bool UsingBed - TRUE if the animation is going to be played on a bed, which will filter out standing animations and allow BedOnly tagged animations.
* * @param: bool RestrictAggressive - If TRUE, only return aggressive animations if IsAggressive=true and none if IsAggressive=false.
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
* * Note about the parameters "IsAggressive" and "RestrictAggressive", they work together and the logic is the following one:
* *  IsAggressive=True, RestrictAggressive=False  --> ONLY aggressive animations are used
* *  IsAggressive=True, RestrictAggressive=True  --> Only animations that are NOT aggressive are used
* *  IsAggressive=False, RestrictAggressive=False  --> Both aggressive and not aggressive animations are used
* *  IsAggressive=False, RestrictAggressive=True  --> Only animations that are NOT aggressive are used
*/;
sslBaseAnimation[] function GetAnimationsByDefault(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true)
	return AnimSlots.GetByDefault(Males, Females, IsAggressive, UsingBed, RestrictAggressive)
endFunction

;/* GetAnimationsByDefaultTags
* * Get an array of animations that fit the given number of males and females using SexLab's default selection criteria.
* *  
* * @param: int Males - The total number of males the returned animations should be intended for. Set to -1 for any amount.
* * @param: int Females - The total number of females the returned animations should be intended for. Set to -1 for any amount.
* * @param: bool IsAggressive - TRUE if the animations to be played are considered aggressive.
* * @param: bool UsingBed - TRUE if the animation is going to be played on a bed, which will filter out standing animations and allow BedOnly tagged animations.
* * @param: bool RestrictAggressive - If TRUE, only return aggressive animations if IsAggressive=true and none if IsAggressive=false.
* * @param: string Tags - A comma separated list of animation tags you want to use as a filter for the returned animations. (E.g. "Leito,Vaginal,Missionary", to get the animation from Leito, in missionary position, where the mouth has some importance. All or just one of the tags? Depends on the value of the parameter RequireAll). WARNING! To prevent issues don't add gender tags or the "Aggressive" tag to this parameter.
* * @param: string TagSuppress [OPTIONAL] - A comma separated list of animation tags you DO NOT want present on any of the returned animations. (E.g. "LeadIn" will filter out all the animations that have the tag "LeadIn"). WARNING! To prevent issues don't add the "Aggressive" tag to this parameter.
* * @param: bool RequireAll [OPTIONAL True by default] - If TRUE, all tags in the provided "string Tags" list must be present in an animation to be returned. When FALSE only one tag in the list is needed. (E.g. If the tags are "oral,Vaginal" and RequireAll is set to TRUE, then the animations found will have BOTH Oral and Vaginal tags; if RequireAll is set to FALSE, then the animation swill have just one of the two tags, and also both together will be returned in the list.)
* * @return: sslBaseAnimation[] - An array of animations that fit the provided search arguments.
* * Note about the parameters "IsAggressive" and "RestrictAggressive", they work together and the logic is the following one:
* *  IsAggressive=True, RestrictAggressive=False  --> ONLY aggressive animations are used
* *  IsAggressive=True, RestrictAggressive=True  --> Only animations that are NOT aggressive are used
* *  IsAggressive=False, RestrictAggressive=False  --> Both aggressive and not aggressive animations are used
* *  IsAggressive=False, RestrictAggressive=True  --> Only animations that are NOT aggressive are used
*/;
sslBaseAnimation[] function GetAnimationsByDefaultTags(int Males, int Females, bool IsAggressive = false, bool UsingBed = false, bool RestrictAggressive = true, string Tags, string TagsSuppressed = "", bool RequireAll = true)
	return AnimSlots.GetByDefaultTags(Males, Females, IsAggressive, UsingBed, RestrictAggressive, Tags, TagsSuppressed, RequireAll)
endFunction

;/* GetAnimationByName
* * Get a single animation by name. Ignores if a user has the animation enabled or not.
* * The animation will NOT include creatures. Use GetCreatureAnimationByName() if you want an animation that is including Creatures.
* * 
* * @param: string FindName - The name of an animation as seen in the SexLab MCM.
* * @return: sslBaseAnimation - The animation whose name matches, if found.
*/;
sslBaseAnimation function GetAnimationByName(string FindName)
	return AnimSlots.GetByName(FindName)
endFunction

;/* GetAnimationByRegistry
* * Get a single animation by it's unique registry name (the ID of the animation.) Ignores if a user has the animation enabled or not.
* * The animation will NOT include creatures. Use GetCreatureAnimationByRegistry() if you want an animation that is including Creatures.
* * 
* * @param: string Registry - The unique registry name of the animation. (string property Registry on any animation)
* * @return: sslBaseAnimation - The animation whose registry matches, if found.
*/;
sslBaseAnimation function GetAnimationByRegistry(string Registry)
	return AnimSlots.GetByRegistrar(Registry)
endFunction

;/* FindAnimationByName
* * Find the registration slot number that an animation currently occupies.
* * 
* * @param: string FindName - The name of an animation as seen in the SexLab MCM.
* * @return: int - The registration slot number for the animation.
*/;
int function FindAnimationByName(string FindName)
	return AnimSlots.FindByName(FindName)
endFunction

;/* GetAnimationCount
* * Get the number of registered animations.
* * 
* * @param: bool IgnoreDisabled [OPTIONAL true by default] - If TRUE, only count animations that are enabled in the SexLab MCM, otherwise count all.
* * @return: int - The total number of animations.
*/;
int function GetAnimationCount(bool IgnoreDisabled = true)
	return AnimSlots.GetCount(IgnoreDisabled)
endFunction

;/* MakeAnimationGenderTag
* * Create a gender tag from a list of actors, in order: F for female, M for male, C for creatures
* * All animations in SexLab have this GenderTag automatically generated based on the animation definition.
* * 
* * @param: Actor[] Positions - A list of actors to create a tag for
* * @return: string - A usable tag for filtering animations by tag and gender. If given an array with 1 male and 1 female, the return will be "FM"
* *
* * EXAMPLE: if the animation expects in the first position is Female, and in the next two positions are a Male, you will get "FMM" as result.
*/;
string function MakeAnimationGenderTag(Actor[] Positions)
	return ActorLib.MakeGenderTag(Positions)
endFunction

;/* GetGenderTag
* * Create a gender tag from specified amount of genders, in order: F for female, M for male, C for creatures
* * @param: int Females - The number of females (F) for the gender tag.
* * @param: int Males - The number of males (M) for the gender tag.
* * @param: int Creatures - The number of creatures (C) for the gender tag.
* * @return: string - A usable tag for filtering animations by tag and gender. If given an array with 2 male and 1 female, the return will be "FMM"
*/;
string function GetGenderTag(int Females = 0, int Males = 0, int Creatures = 0)
	return ActorLib.GetGenderTag(Females, Males, Creatures)
endFunction

;/* MergeAnimationLists
* * Combine 2 separate lists of animations into a single list, removing any duplicates between the two. (Works with both regular and creature animations.)
* * Warning if in the first list there are None values they are kept (duplicates are not removed), and if in the second list there is at least one None value, then at least one None value wil be in the resulting list
* * 
* * @param: sslBaseAnimation[] List1 - The first array of animations to combine.
* * @param: sslBaseAnimation[] List2 - The second array of animations to combine.
* * @return: sslBaseAnimation[] - All the animations from List1 and List2, with any duplicates between them removed.
*/;
sslBaseAnimation[] function MergeAnimationLists(sslBaseAnimation[] List1, sslBaseAnimation[] List2)
	return sslUtility.MergeAnimationLists(List1, List2)
endFunction

;/* RemoveTagged
* * Removes any animations from an existing list that contain one of the provided animation tags. (Works with both regular and creature animations.)
* * 
* * @param: sslBaseAnimation[] Anims - A list of animations you want to filter certain tags out of.
* * @param: string Tags - A comma separated list of animation tags to check Anim's element for, if any of the tags given are present, the animation won't be included in the return.
* * @return: sslBaseAnimation[] - All the animations from Anims that did not have any of the provided tags.
*/;
sslBaseAnimation[] function RemoveTagged(sslBaseAnimation[] Anims, string Tags)
	return sslUtility.RemoveTaggedAnimations(Anims, PapyrusUtil.StringSplit(Tags))
endFunction

;/* CountTag
* * Counts the number of animations in the given array that contain one of provided animation tags. (Works with both regular and creature animations.)
* * 
* * @param: sslBaseAnimation[] Anims - A list of animations you want to check for tags on.
* * @param: string Tags - A comma separated list of animation tags.
* * @return: int - The number of animations from Anims that contain one of the tags provided.
*/;
int function CountTag(sslBaseAnimation[] Anims, string Tags)
	return AnimSlots.CountTag(Anims, Tags)
endFunction

;/* CountTagUsage
* * Counts the number of animations in the registry that contain one of provided animation tags.
* * 
* * @param: string Tags - A comma separated list of animation tags.
* * @return: int - The number of animations from Anims that contain one of the tags provided.
*/;
int function CountTagUsage(string Tags, bool IgnoreDisabled = true)
	return AnimSlots.CountTagUsage(Tags, IgnoreDisabled)
endFunction

int function CountCreatureTagUsage(string Tags, bool IgnoreDisabled = true)
	return CreatureSlots.CountTagUsage(Tags, IgnoreDisabled)
endFunction

;/* GetAllAnimationTags
* * Get a list of all unique tags contained in a set of registered animations.
* * see also: GetAllCreatureAnimationTags, GetAllBothAnimationTags, GetAllAnimationTagsInArray
* * 
* * @param: int ActorCount - The number of actors the animations checked should be intended for. -1 to check all animations regardless of the number of positions.
* * @param: bool IgnoreDisabled - Whether to ignore tags from animations that have been disabled by the user or not. Default value of TRUE will ignore disabled animations.
* * @return: string[] - An alphabetically sorted string array of all unique tags found in the matching animations. 
*/;
string[] function GetAllAnimationTags(int ActorCount = -1, bool IgnoreDisabled = true)
	return AnimSlots.GetAllTags(ActorCount, IgnoreDisabled)
endFunction


;/* GetAllAnimationTagsInArray
* * Get a list of all unique tags contained in an arbitrary list of provided animations. alias to sslUtility.
* * see also: GetAllAnimationTags, GetAllCreatureAnimationTags, GetAllBothAnimationTags
* * 
* * @param: sslBaseAnimation[] - The array of animation objects you want a list of tags for.
* * @return: string[] - An alphabetically sorted string array of all unique tags found in the provided animations. 
*/;
string[] function GetAllAnimationTagsInArray(sslBaseAnimation[] List)
	return sslUtility.GetAllAnimationTagsInArray(List)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                         END ANIMATION FUNCTIONS                                                         #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* GetEnjoyment
* * Given a thread ID and an Actor, gives the enjoyment level for the actor between orgasms
* * NOTE: overkill? Don't use too much!
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look for the enjoyment
* * @return: int - the enjoyment calculated for the specific actor between orgasms when separated orgasms is enabled or the total enjoyment when separated orgasms is disabled
*/;
int function GetEnjoyment(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).GetEnjoyment(ActorRef)
endfunction

;/* IsVictim
* * Used to understand is a specific actor is the Victim for the animation
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look to be a victim
* * @return: TRUE if the actor is a Victim for the animation, FALSE otherwise
*/;
bool function IsVictim(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).IsVictim(ActorRef)
endFunction

;/* IsAggressor
* * Used to understand is a specific actor is the Aggressor for the animation
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look to be an aggressor
* * @return: TRUE if the actor is the Aggressor for the animation, FALSE otherwise
*/;
bool function IsAggressor(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).IsAggressor(ActorRef)
endFunction

;/* IsUsingStrapon
* * Used to understand is a specific actor is using a strapon
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look for strapons
* * @return: TRUE if the actor is using a strapon for the animation, FALSE otherwise
*/;
bool function IsUsingStrapon(int tid, Actor ActorRef)
	return ThreadSlots.GetController(tid).ActorAlias(ActorRef).IsUsingStrapon()
endFunction

;/* PregnancyRisk
* * Used to understand if the actor can become pregnant by the sex animation
* *
* * @param: int tid - The thread id
* * @param: Actor ActorRef - The actors to look for pregnancy risk
* * @param: AllowFemaleCum [OPTIONAL false by default] - If set to TRUE then also the cum produced by a Female actor may impregnate
* * @param: AllowCreatureCum [OPTIONAL false by default] - If set to TRUE then also the cum produced by a Creature actor may impregnate
* * @return: TRUE if the actor can become pregnant, FALSE otherwise
*/;
bool function PregnancyRisk(int tid, Actor ActorRef, bool AllowFemaleCum = false, bool AllowCreatureCum = false)
	return ThreadSlots.GetController(tid).PregnancyRisk(ActorRef, AllowFemaleCum, AllowCreatureCum)
endfunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#  ^^^                                                       END HOOK FUNCTIONS                                                      ^^^  #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                         START UTILITY FUNCTIONS                                                         #
;#                                                        See functions located at:                                                        #
;#                                                              FrameworkUtil.psc                                                          #
;#                                                              sslUtility.psc                                                             #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

;/* MakeActorArray
* * Creates an array of actors with the specified actor objects.
* * Deprecated this script, use it directly from FrameworkUtil instead.
* * 
* * @param: Actor Actor1, one actor to add in the array (can be unspefified and so ignored)
* * @param: Actor Actor2, one actor to add in the array (can be unspefified and so ignored)
* * @param: Actor Actor3, one actor to add in the array (can be unspefified and so ignored)
* * @param: Actor Actor4, one actor to add in the array (can be unspefified and so ignored)
* * @param: Actor Actor5, one actor to add in the array (can be unspefified and so ignored)
* * @return: an Actor[] of the size of the non null actors with the specified actors inside.
*/;
Actor[] function MakeActorArray(Actor Actor1 = none, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none)
	return FrameworkUtil.MakeActorArray(Actor1, Actor2, Actor3, Actor4, Actor5)
endFunction

;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                                          END UTILITY FUNCTIONS                                                          #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#



;#-----------------------------------------------------------------------------------------------------------------------------------------#
;#                                                                                                                                         #
;#                                    THE FOLLOWING PROPERTIES AND FUNCTION ARE FOR INTERNAL USE ONLY                                      #
;#                                                                                                                                         #
;#                                                                                                                                         #
;#                             ****       ***         *     *   ***   *******     *     *   ******  *******                                #
;#                             *   **    *   *        **    *  *   *     *        *     *  *      * *                                      #
;#                             *     *  *     *       * *   * *     *    *        *     *  *        *                                      #
;#                             *      * *     *       *  *  * *     *    *        *     *   ******  *****                                  #
;#                             *     *  *     *       *   * * *     *    *        *     *         * *                                      #
;#                             *   **    *   *        *    **  *   *     *         *   *   *      * *                                      #
;#                             ****       ***         *     *   ***      *          ***     ******  *******                                #
;#                                                                                                                                         #
;#                                                                                                                                         #
;#-----------------------------------------------------------------------------------------------------------------------------------------#

; Data
Faction property AnimatingFaction auto hidden
Actor property PlayerRef auto hidden

; Object registries
AniSceneSlots property sceneSlots auto hidden
AniAnimationSlots property AnimSlots auto hidden

; Mod Extends support
AniFramework Sexlab
function Setup()
	Form SexLabQuestFramework = Game.GetFormFromFile(0xD62, "SexLab.esp")
	if SexLabQuestFramework
		Sexlab      = SexLabQuestFramework as AniFramework
		; Config      = SexLabQuestFramework as sslSystemConfig
		; ThreadLib   = SexLabQuestFramework as sslThreadLibrary
		sceneSlots = SexLabQuestFramework as AniSceneSlots
		; ActorLib    = SexLabQuestFramework as sslActorLibrary
		; Stats       = SexLabQuestFramework as sslActorStats
	endIf
	; Reset animation registry - SexLabQuestAnimations
	Form SexLabQuestAnimations = Game.GetFormFromFile(0x639DF, "SexLab.esp")
	if SexLabQuestAnimations
		AnimSlots = SexLabQuestAnimations as AniAnimationSlots
	endIf
	; Sync Data
	PlayerRef        = Game.GetPlayer()	
	; Check if main framework file, or extended
	Log(self+" - Loaded SexLabFramework")
endFunction

event OnInit()
	Setup()
endEvent

function Log(string Log, string Type = "NOTICE")
	Log = Type+": "+Log
	if Config.InDebugMode
		FrameworkUtil.PrintConsole(Log)
	endIf
endFunction

state Disabled
	sslThreadModel function NewThread(float TimeOut = 30.0)
		Log("NewThread() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return none
	endFunction
	int function StartSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = none, ObjectReference CenterOn = none, bool AllowBed = true, string Hook = "")
		Log("StartSex() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return -1
	endFunction
	sslThreadController function QuickStart(Actor Actor1, Actor Actor2 = none, Actor Actor3 = none, Actor Actor4 = none, Actor Actor5 = none, Actor Victim = none, string Hook = "", string AnimationTags = "")
		Log("QuickStart() - Failed to make new thread model; system is currently disabled or not installed", "FATAL")
		return none
	endFunction
	event OnBeginState()
		if SexLab == self || (!SexLab && self == FrameworkUtil.GetAPI())
			Log("SexLabFramework - Disabled")
			ModEvent.Send(ModEvent.Create("SexLabDisabled"))
		endIf
	endEvent
endState

state Enabled
	event OnBeginState()
		if SexLab == self || (!SexLab && self == FrameworkUtil.GetAPI())
			Log("SexLabFramework - Enabled")
			ModEvent.Send(ModEvent.Create("SexLabEnabled"))
		endIf
	endEvent
endState

