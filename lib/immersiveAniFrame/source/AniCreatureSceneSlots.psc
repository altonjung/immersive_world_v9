scriptname AniCreatureSceneSlots extends AniHumanSceneSlots

; ------------------------------------------------------- ;
; --- Creature aniamtion support                      --- ;
; ------------------------------------------------------- ;

string function GetRaceKey(Race RaceRef) global native
string function GetRaceKeyByID(string RaceID) global native
function AddRaceID(string RaceKey, string RaceID) global native
bool function HasRaceID(string RaceKey, string RaceID) global native
bool function HasRaceKey(string RaceKey) global native
bool function ClearRaceKey(string RaceKey) global native
bool function HasRaceIDType(string RaceID) global native
bool function HasCreatureType(Actor ActorRef) global native
bool function HasRaceType(Race RaceRef) global native
string[] function GetAllRaceKeys(Race RaceRef = none) global native
string[] function GetAllRaceIDs(string RaceKey) global native
Race[] function GetAllRaces(string RaceKey) global native
