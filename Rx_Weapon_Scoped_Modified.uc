class Rx_Weapon_Scoped_Modified extends Rx_Weapon_Scoped;

simulated function bool IsInstantHit()
{
	return true; 
}

simulated function rotator AddSpread(rotator BaseAim)
{
	if (SM_GRI(`WorldInfoObject.GRI).GetSpreadSniper())
		return super.AddSpread(BaseAim);

	return BaseAim;
}

simulated function bool GetWeaponCanReload()
{
	return false;
}

DefaultProperties
{

	//-------------- Recoil
	RecoilDelay = 0.02
	MinRecoil = 200.0
	MaxRecoil = 300.0
	MaxTotalRecoil = 5000.0
	RecoilYawModifier = 0.5 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 40.0
	RecoilDeclinePct = 0.8
	RecoilDeclineSpeed = 5.0
	MaxSpread = 0.12
	RecoilSpreadIncreasePerShot = 0.0
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadDecreaseDelay = 0.3
	RecoilSpreadCrosshairScaling = 4000	// 2500

	Spread(0)=0.15 //0.1 //0.0
	IronSightAndScopedSpread(0)= 0.0
}