class SM_Controller extends Rx_Controller;

exec function Use()
{
	if (SM_PT(Rx_HUD(myHUD).WeaponAimingActor) != None)
	{
		if (Rx_HUD(myHUD).WeaponAimingActor.GetTeamNum() == GetTeamNum() && Pawn.Health == Pawn.HealthMax)
		{
			SwitchClass();
		}
	}

	super.Use();
}

reliable server function SwitchClass()
{
	if (!WorldInfo.GRI.bMatchHasBegun) return;

	switch (GetTeamNum())
	{
		case 0:
			Rx_PRI(PlayerReplicationInfo).SetChar(class'SM_FamInfo_Havoc', Pawn);
		break;
		case 1:
			Rx_PRI(PlayerReplicationInfo).SetChar(class'SM_FamInfo_Sak', Pawn);
		break;
	}
}