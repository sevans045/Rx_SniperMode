class Rx_SniperMode extends Rx_Mutator
config(SniperMode);

var config bool bNoSpreadSnipers;

enum TEAM
{
	TEAM_GDI,
	TEAM_NOD,
	TEAM_UNOWNED
};

struct Barrier
{
	var byte Team;
	var vector Loc;
	var rotator Rot;
};

struct SpawnPoint
{
	var byte Team;
	var vector Loc;
};

struct MapData
{
	var string MapName;
	var class<Rx_MapData> MapDataClass;
};

struct PT
{
	var byte Team;
	var vector Loc;
	var rotator Rot;
};

struct KillStreak
{
	var string StreakName;
	var string ColourCode;
	var int KillsNeeded;
};

struct PlayerData
{
	var Controller C;
	var int CurrentKills;

	structdefaultproperties
	{
		CurrentKills = 0
	}
};

var string GDIColour, NodColour, NeutralColour;

var array<MapData> MapDatas;
var class<Rx_MapData> CurrentMapData;

var array<Rx_SniperSpawnPoint> Spawns;

var array<PlayerData> PlayerDatas;
var array<KillStreak> KillStreaks;

function OnMatchStart()
{
	local Rx_Defence Def;
	local Rx_Building_Team_Internals TeamInt;
	local Rx_Defence_Controller DefCon;

	ForEach `WorldInfoObject.AllActors(class'Rx_Defence', Def)
		Def.Destroy();

	ForEach `WorldInfoObject.AllActors(class'Rx_Defence_Controller', DefCon)
		DefCon.Destroy();

	ForEach `WorldInfoObject.AllActors(class'Rx_Building_Team_Internals', TeamInt)
	{
		TeamInt.PowerLost();
		TeamInt.HealthLocked = true;
	}

	super.OnMatchStart();
}

function OnPlayerConnect(PlayerController NewPlayer, string SteamID)
{
	local PlayerData P;

	P.C = Rx_Controller(NewPlayer);

	PlayerDatas.AddItem(P);
}

function OnPlayerKill(Controller Killer, Controller Victim, Pawn KilledPawn, class<DamageType> DamageType)
{
	local int K;

	Rx_PRI(Killer.PlayerReplicationInfo).Veterancy_Points = 0;
	Rx_PRI(Killer.PlayerReplicationInfo).VRank = 0;

	if (Rx_Controller(Victim) != None && Rx_Controller(Killer) != None)
		ResetKills(Victim, Killer);

	if (Killer != None)
		AddKill(Killer);

	if (Killer != None)
		K = GetCurrentStreak(Killer);

	if (K != INDEX_NONE)
		StreakEffect(Killer, KillStreaks[K]);

	super.OnPlayerKill(Killer, Victim, KilledPawn, DamageType);
}

function AddKill(Controller Player)
{
	local PlayerData P;
	local int i;

	i = PlayerDatas.Find('C', Player);
	P = PlayerDatas[PlayerDatas.Find('C', Player)];

	if (i == INDEX_NONE)
	{
		P.C = Player;
		P.CurrentKills = 1;
		PlayerDatas.AddItem(P);
	}
	else
		PlayerDatas[PlayerDatas.Find('C', Player)].CurrentKills++;
}

function ResetKills(Controller Player, Controller Killer)
{
	local int KS;
	local int i;

	KS = GetCurrentStreak(Player);
	i = PlayerDatas.Find('C', Player);

	if (KS != INDEX_NONE)
		StreakEnd(Player, Killer, KillStreaks[KS]);

	if (i != INDEX_NONE)
		PlayerDatas[i].CurrentKills = 0;
}

event StreakEffect(Controller Player, KillStreak StreakStarted)
{
	local string Message, PlayerName, KillStreakName;

	if (Player != None)
		PlayerName = "<font color='" $GetTeamColour(Player.GetTeamNum())$"'>" $Player.GetHumanReadableName()$"</font>";
	else
		return;

	KillStreakName = "<font color='" $StreakStarted.ColourCode$"'>" $StreakStarted.StreakName$"</font>";

	Message = PlayerName @ "is now on a" @ KillStreakName @ StreakStarted.KillsNeeded @ "killstreak!";

	Announce(Message);
}

event StreakEnd(Controller Player, Controller Killer, KillStreak StreakEnded)
{
	local string Message, KillerName, VictimName, KillStreakName;

	if (Killer != None)
		KillerName = "<font color='" $GetTeamColour(Killer.GetTeamNum())$"'>" $Killer.GetHumanReadableName()$"</font>";
	else
		KillerName = "<font color='" $NeutralColour$"'>Nobody</font>";

	if (Player != None)
		VictimName = "<font color='" $GetTeamColour(Player.GetTeamNum())$"'>" $Player.GetHumanReadableName()$"</font>";
	else
		VictimName = "<font color='" $NeutralColour$"'>Nobody</font>";

	KillStreakName = "<font color='" $StreakEnded.ColourCode$"'>" $StreakEnded.StreakName$"</font>";

	Message = KillerName @ "just ended" @ VictimName $ "'s" @ KillStreakName @ "killstreak!";

	Announce(Message);
}

function int GetCurrentStreak(Controller Player)
{
	local PlayerData P;

	P = PlayerDatas[PlayerDatas.Find('C', Player)];

	if (P.CurrentKills < KillStreaks[0].KillsNeeded) return INDEX_NONE;

	if (KillStreaks.Find('KillsNeeded', P.CurrentKills) != INDEX_NONE)
		return KillStreaks.Find('KillsNeeded', P.CurrentKills);

	return KillStreaks.Length - 1;
}

function PostBeginPlay()
{
	local SpawnPoint NewSpawn;
	local Rx_SniperSpawnPoint TempSpawn;
	local PT thisPT;
	local SM_PT TempSpawn2;
	local Barrier NewBarrier;

	super.PostBeginPlay();

	CurrentMapData = MapDatas[MapDatas.Find('MapName', `WorldInfoObject.GetMapName(true))].MapDataClass;

	if (CurrentMapData == None)
		`warn("COULDN'T LOAD SNIPER SERVER MAPDATA");

	ForEach CurrentMapData.default.SpawnPoints(NewSpawn)
	{
		TempSpawn = Spawn(class'Rx_SniperSpawnPoint',,,NewSpawn.Loc);
		TempSpawn.Team = NewSpawn.Team;
		Spawns.AddItem(TempSpawn);
	}

	ForEach CurrentMapData.default.Barriers(NewBarrier)
		Spawn(class'Rx_Blocker',,,NewBarrier.Loc,NewBarrier.Rot);

	ForEach CurrentMapData.default.PTs(thisPT)
	{
		TempSpawn2 = Spawn(class'SM_PT',,,thisPT.Loc,thisPT.Rot,,true);
		TempSpawn2.TeamID = thisPT.Team;
	}

	`WorldInfoObject.Game.GameReplicationInfoClass = class'SM_GRI';

	SetTimer(1.0f, true, 'SetSpread');
}

function SetSpread()
{
	if (`WorldInfoObject.GRI != None && SM_GRI(`WorldInfoObject.GRI) != None)
	{
		SM_GRI(`WorldInfoObject.GRI).bSpreadSniper = !bNoSpreadSnipers;
	}
}

function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string incomingName)
{
	local array<Rx_SniperSpawnPoint> TempArray;
	local Rx_SniperSpawnPoint Temp;

	ForEach Spawns(Temp)
		if (Temp.GetTeamNum() == InTeam)
			TempArray.AddItem(Temp);

	return TempArray[Rand(TempArray.Length-1)];
}

function bool CheckReplacement(Actor Other)
{
	if (Rx_CratePickup(Other) != None)
		return false;

	if (Rx_TeamInfo(Other) != None)
	{
		Rx_Game(`WorldInfoObject.Game).HudClass = class'Rx_HUD_Sniper';
		Rx_Game(`WorldInfoObject.Game).PurchaseSystemClass = class'SM_PS';
		`WorldInfoObject.Game.DefaultPawnClass = class'SM_Pawn';
		`WorldInfoObject.Game.PlayerControllerClass = class'SM_Controller';

	}

	return true;
}

function Announce(coerce string Message)
{
	`WorldInfoObject.Game.BroadcastHandler.Broadcast(None, Message, 'Special');
}

function string GetTeamColour(byte TeamIndex)
{
	if (TeamIndex == 0)
		return GDIColour;
	else if (TeamIndex == 1)
		return NodColour;
	else
		return NeutralColour;
}

DefaultProperties
{
	MapDatas(0)=(MapName="CNC-Field",MapDataClass=class'Rx_MapData_Field')
	MapDatas(1)=(MapName="CNC-Islands",MapDataClass=class'Rx_MapData_Islands')
	MapDatas(2)=(MapName="CNC-Volcano",MapDataClass=class'Rx_MapData_Volcano')

	NodColour = "#FF0000"
	GDIColour = "#FFC600"
	NeutralColour = "#00FF00"

	KillStreaks(0)=(StreakName="Killing Spree",ColourCode="#25DA4B", KillsNeeded=3)
	KillStreaks(1)=(StreakName="Dominating",ColourCode="#B33BC4", KillsNeeded=6)
	KillStreaks(2)=(StreakName="Mega",ColourCode="#E11EA6", KillsNeeded=10)
	KillStreaks(3)=(StreakName="Unstoppable",ColourCode="#F67C09", KillsNeeded=12)
	KillStreaks(4)=(StreakName="Wicked Sick",ColourCode="#9FC33C", KillsNeeded=14)
	KillStreaks(5)=(StreakName="Monster",ColourCode="#8D4FB0", KillsNeeded=16)
	KillStreaks(6)=(StreakName="GODLIKE",ColourCode="#FF0000", KillsNeeded=20)
	KillStreaks(7)=(StreakName="BEYOND GODLIKE!!!",ColourCode="#00E9FF", KillsNeeded=21)
}
