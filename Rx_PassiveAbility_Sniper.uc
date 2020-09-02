class Rx_PassiveAbility_Sniper extends Rx_PassiveAbility;

var private Rx_Controller C;
var private int WarningCounts;

simulated function Init(Pawn InitiatingPawn, byte SlotNum)
{
	super.Init(InitiatingPawn, SlotNum);

	C = Rx_Controller(InitiatingPawn.Controller);

	SetTimer(5.0, true);
	SetTimer(2.0, true, nameof(CheckDistance));
}

simulated function CheckDistance()
{
	local Rx_SniperSpawnPoint SpawnPoint;

	if (WorldInfo.NetMode != NM_DedicatedServer) return;

	ForEach `WorldInfoObject.AllActors(class'Rx_SniperSpawnPoint', SpawnPoint)
	{
		if (SpawnPoint.GetTeamNum() == UsingPawn.GetTeamNum()) continue;

		if (WarningCounts >= 2)
		{
			C.CTextMessage("You were warned :)", 'Red');
			UsingPawn.Suicide();
			return;
		}

		if (VSize(UsingPawn.Location - SpawnPoint.Location) <= 1000 && UsingPawn.Health >= 0 && C != None)
		{
			C.CTextMessage("Please back up from enemy spawn :)", 'Red',,,,true);
			WarningCounts++;
			return;
		}
	}

	WarningCounts--;

	WarningCounts = Max(0, WarningCounts);
}

simulated function Timer()
{
	if (UsingPawn == None || UsingPawn.Controller == None || C == None)
		Destroy();

	Rx_Pawn(UsingPawn).ClientSetStamina(100);

	Rx_Controller(UsingPawn.Controller).SetRadarVisibility(2);
}

simulated function ToggleAbility()
{
	if (C == None)
		C = Rx_Controller(UsingPawn.Controller);

	if (C == None)
		return;

	if (CanUse())
	{
		switch (C.GetTeamNum())
		{
			case TEAM_GDI:
				Rx_PRI(C.PlayerReplicationInfo).SetChar(class'Rx_FamilyInfo_GDI_Havoc', C.Pawn);
			break;
			case TEAM_NOD:
				Rx_PRI(C.PlayerReplicationInfo).SetChar(class'Rx_FamilyInfo_Nod_Sakura', C.Pawn);
			break;
		}
	}
}

simulated function ActivateAbility()
{
	ToggleAbility();
}

simulated function bool CanUse()
{
	local Rx_SniperSpawnPoint SpawnPoint;

	ForEach `WorldInfoObject.AllActors(class'Rx_SniperSpawnPoint', SpawnPoint)
	{
		if (SpawnPoint.GetTeamNum() != C.GetTeamNum()) continue;

		if (VSize(UsingPawn.Location - SpawnPoint.Location) <= 500 && UsingPawn.Health == Rx_Pawn(UsingPawn).HealthMax)
		return true;
	}

	return false;
}

simulated function RemoveUser()
{
}
