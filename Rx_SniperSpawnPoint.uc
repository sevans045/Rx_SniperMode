class Rx_SniperSpawnPoint extends NavigationPoint;

var byte Team;
var StaticMeshComponent TriggerMesh;

replication 
{
	if (bNetDirty && Role == ROLE_Authority)
		Team;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	if (WorldInfo.NetMode != NM_DedicatedServer)
	{
		ForceNetRelevant();
		Timer();
		SetTimer(2.5, false);
	}

	if (WorldInfo.NetMode != NM_Client)
		SetTimer(0.1f, true, 'CheckTouch');
}

function CheckTouch()
{
	local Rx_Pawn P;

	ForEach CollidingActors(class'Rx_Pawn', P, 1050)
	{
		if (P.GetTeamNum() != ScriptGetTeamNum())
		{
			Rx_Controller(P.Controller).CTextMessage("Stay out of enemy spawn", 'Red');
			P.Suicide();
		}
	}
}

simulated function Timer()
{
	SetHidden(GetALocalPlayerController().GetTeamNum() == ScriptGetTeamNum());
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

	Begin Object Class=StaticMeshComponent Name=TMesh
		StaticMesh=StaticMesh'RenX_AssetBase.Mesh.SM_Sphere_Rad100'
		HiddenGame=false
		AlwaysLoadOnClient = True
		AlwaysLoadOnServer = True
		Scale=10
		Materials[0]=MaterialInstanceConstant'SM_Content.Materials.M_Holo_INST'
		CollideActors=false
		BlockActors=False
		BlockZeroExtent=False
		BlockNonZeroExtent=False
		BlockRigidBody=False
	End Object
	TriggerMesh=TMesh
	CollisionComponent=TMesh
	Components.Add(TMesh)

	bCollideActors=false
}