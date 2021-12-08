class SM_PS extends Rx_PurchaseSystem;

simulated function class<Rx_FamilyInfo> GetStartClass(byte TeamID, PlayerReplicationInfo PRI)
{
	return TeamID == 0 ? class'SM_FamInfo_Deadeye' : class'SM_FamInfo_BHS';
}