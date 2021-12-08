class Rx_MapData extends Object
dependson(Rx_SniperMode);

/** struct Barrier
{
	var byte Team;
	var vector Loc;
	var rotator Rot;
};

struct SpawnPoint
{
	var byte Team;
	var vector Loc;
}; **/

var const array<Barrier> Barriers;
var const array<SpawnPoint> SpawnPoints;
var const array<PT> PTs;

DefaultProperties
{
	//Barriers(0)=(Team=0,Loc=, Rot=)
	//SpawnPoints(0)=(Team=0,Loc=)
}