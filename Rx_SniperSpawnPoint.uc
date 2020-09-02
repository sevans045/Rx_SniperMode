class Rx_SniperSpawnPoint extends NavigationPoint;

var byte Team;

replication 
{
	if (bNetDirty && Role == ROLE_Authority)
		Team;
}

simulated event byte ScriptGetTeamNum()
{
	return Team;
}

DefaultProperties
{
	bStatic=false
	bNoDelete=false
	RemoteRole=ROLE_AutonomousProxy
}