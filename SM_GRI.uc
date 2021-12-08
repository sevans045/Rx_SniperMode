class SM_GRI extends Rx_GRI;

var bool bSpreadSniper;

replication
{
	if (bNetDirty)
		bSpreadSniper;
}

simulated function bool GetSpreadSniper()
{
	return bSpreadSniper;
}