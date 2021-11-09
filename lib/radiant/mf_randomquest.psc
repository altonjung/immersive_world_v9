Scriptname MF_RandomQuest extends Quest  
{Main Quest Typ for All Radiant Prostitution Random Quests.}

Actor Property akMadame Auto

;Determes into which quest list this quest should be added
;Rank 1 HomeJob Level
;Rank 2 CampJob Level
;Rank >=3 RandomJob Level
int Function getRank()
	return 5
endFunction

;Dont implement its legacy Support for older Quest inside of RP
Function getExtraReward()
endFunction

; Get called befor the random quests is started so you can check if quest conditions are fullfilled
bool Function checkConditions()
	;Override this Methode in your quest
	return true
endFunction

; Gets Called after the Quest is started and you can react to it like forcing it into a quest alias.
Function setMadame(Actor Madame)
	akMadame = Madame
endFunction
