class Rx_Blocker_Internals extends Rx_Building_Team_Internals;

DefaultProperties
{
	Begin Object Name=BuildingSkeletalMeshComponent
		SkeletalMesh        = None
		AnimSets(0)         = None
		AnimTreeTemplate    = None
		PhysicsAsset        = None
	End Object

	HDamagePointsScale		= 0
	ADamagePointsScale		= 0

	HealPointsScale         = 0
	Destroyed_Score			= 0 // Total number of points divided out when  
	
	HealthMax               = 4600
	BA_HealthMax			= 4600
	DestructionAnimName     = "BuildingDeath"
	LowHPWarnLevel          = 0 // critical Health level
	RepairedHPLevel         = 3400
	RepairedArmorLevel		= 1200 
	bBuildingRecoverable    = false
	TeamID                  = 255
	MessageClass            = class'Rx_Message_Buildings'
	MessageWaitTime         = 15.0f

	DamageLodLevel          = 1
	bInitialDamageLod       = true
	
	ArmorResetTime			= 300 //5 Minute time between being able to be rewarded for breaking armor (Seconds)
	bCanArmorBreak 			= false
	HealthLocked			= true 
}
