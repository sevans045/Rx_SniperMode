class Rx_Weapon_Railgun_Modified extends Rx_Weapon_Railgun;

simulated function ProcessInstantHit(byte FiringMode, ImpactInfo Impact, optional int NumHits)
{
	return;
}

DefaultProperties
{
	CustomWeaponName="Tailgun (HS ONLY)"
	ClipSize = 999
	InitalNumClips = 999
	MaxClips = 999
	bHasInfiniteAmmo = true
	ShotCost(0)=0
	ShotCost(1)=1
}