class Rx_Blocker extends Rx_Building;

simulated function String GetBuildingName()
{
	return "Wall";
}

simulated function bool IsSpottable() {return false;}
simulated function bool GetIsValidLocalTarget(Controller PC) {return false;}

simulated function byte ScriptGetTeamNum() 
{
	return 255; 
}

simulated function byte GetTeamNum() 
{
	return 255; 
}

DefaultProperties
{
	BuildingInternalsClass = Rx_Blocker_Internals
	Begin Object Class=StaticMeshComponent Name=Wall
		StaticMesh=StaticMesh'RX_Deco_Barrier.Meshes.SM_Wall_Prison_2Point'
		LightingChannels=(bInitialized=True,BSP=False,Static=False,Dynamic=True,CompositeDynamic=True)
		Scale=4
	End Object

	bStatic=false
	bNoDelete=false
	TeamID=1
	bMovable=true

	Components.Add(Wall)
	bSignificant=false
}