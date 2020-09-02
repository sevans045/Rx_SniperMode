class Rx_Weapon_Scoped_Modified extends Rx_Weapon_Scoped;

simulated function bool IsInstantHit()
{
	return true; 
}

simulated function rotator AddSpread(rotator BaseAim)
{
	return BaseAim;
}

simulated function bool GetWeaponCanReload()
{
	return false;
}