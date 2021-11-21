scriptname sslCreatureAnimationDefaults extends sslAnimationFactory

function LoadCreatureAnimations()
	; Prepare factory resources (as creature)
	PrepareFactoryCreatures()
	
	; Register any remaining custom categories from json loaders
	RegisterOtherCategories()
endFunction
