Scriptname mf_Variables extends Quest Conditional
;
int Property FollowPlayer = 0 Auto Conditional

float Property PerformanceRewardMod = 0.0 Auto Conditional

int Property ActiveSolicit = 1 Auto Conditional
int Property PassiveSolicit = 0 Auto Conditional
int Property GuardAllowed = 0 Auto Conditional

int Property PlayerLearnHomeJob = 0 Auto Conditional
int Property PlayerLearnCampJob = 0 Auto Conditional
int Property PlayerLearnRandomJob = 0 Auto Conditional
int Property PlayerLearnMadameJob = 0 Auto Conditional
int Property PlayerLearnBusinessJob = 0 Auto Conditional

int Property PlayerKnowsHomeJob = 0 Auto Conditional
int Property PlayerKnowsCampJob = 0 Auto Conditional
int Property PlayerKnowsRandomJob = 0 Auto Conditional
int Property PlayerKnowsMadameJob = 0 Auto Conditional
int Property PlayerKnowsBusinessJob = 0 Auto Conditional

int Property FailJobOnCD = 0 Auto Conditional
int Property HomeJobOnCD = 0 Auto Conditional
int Property CampJobOnCD = 0 Auto Conditional
int Property RandomJobOnCD = 0 Auto Conditional

int Property HomeJobGuest = 0 Auto Conditional
;

Bool Property GotClothes = False Auto  Conditional

Bool Property GrantExtraReward  Auto  Conditional

; Arousal integration

Actor Property ClientOrgasmActor Auto
Actor Property GuestOrgasmActor Auto

float Property SexStartTime Auto
float Property finalPlayerOrgasm Auto
float Property finalClientOrgasm Auto
float Property finalGuestOrgasm Auto

int Property PlayerOrgasmOccurred Auto Conditional
int Property ClientOrgasmOccurred Auto Conditional
int Property GuestOrgasmOccurred Auto Conditional
int Property OrgasmCount Auto Conditional

int Property ClientSatisfaction Auto Conditional
int Property NoSLSO = 0 AUto Conditional