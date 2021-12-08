class SM_PT extends Actor
implements(RxIfc_Targetable)
implements (Rx_ObjectTooltipInterface);

var byte TeamID;
var StaticMeshComponent MCTSkeletalMesh;
var DynamicLightEnvironmentComponent MyLightEnvironment;

replication 
{
	if (bNetDirty)
		TeamID, MCTSkeletalMesh;
}

simulated function byte ScriptGetTeamNum()
{
	return TeamID;
}

simulated function string GetTooltip(Rx_Controller PC)
{
	if (GetTeamNum() == PC.GetTeamNum())
		return "<font color='#ff0000' size='20'>Press E for a NOOBJET</font>";

	return "TF u doin here bruv";
}

simulated function bool IsTouchingOnly(){return false;}
simulated function bool IsBasicOnly(){return false;}


/*-------------------------------------------*/
/*BEGIN TARGET INTERFACE [RxIfc_Targetable]*/
/*------------------------------------------*/
//Health
simulated function int GetTargetHealth() {return 1;} //Return the current health of this target
simulated function int GetTargetHealthMax() {return 1;} //Return the current health of this target

//Armour 
simulated function int GetTargetArmour() {return 1;} // Get the current Armour of the target
simulated function int GetTargetArmourMax() {return 1;} // Get the current Armour of the target 

// Veterancy

simulated function int GetVRank() {return 0;}


/*Get Health/Armour Percents*/
simulated function float GetTargetHealthPct() {return (1.0);}
simulated function float GetTargetArmourPct() {return (1.0);}
simulated function float GetTargetMaxHealthPct() {return (1.0);} //Everything together (Basically Health and armour)

/*Get what we're actually looking at*/
simulated function Actor GetActualTarget() {return self;} //Should return 'self' most of the time, save for things that should return something else (like building internals should return the actual building)

/*Booleans*/
simulated function bool GetUseBuildingArmour(){return false;} //Stupid legacy function to determine if we use building armour when drawing. 
simulated function bool GetShouldShowHealth(){return true;} //If we need to draw health on this 
simulated function bool AlwaysTargetable() {return false;} //Targetable no matter what range they're at
simulated function bool GetIsInteractable(PlayerController PC) {return true;} //Are we ever interactable?
simulated function bool GetCurrentlyInteractable(PlayerController RxPC) {return RxPC.GetTeamNum() == GetTeamNum();} //Are we interactable right now? 
simulated function bool GetIsValidLocalTarget(Controller PC) {return PC.GetTeamNum() == GetTeamNum();} //Are we a valid target for our local playercontroller?  (Buildings are always valid to look at (maybe stealthed buildings aren't?))
simulated function bool HasDestroyedState() {return false;} //Do we have a destroyed state where we won't have health, but can't come back? (Buildings in particular have this)
simulated function bool UseDefaultBBox() {return true;} //We're big AF so don't use our bounding box 
simulated function bool IsStickyTarget() {return false;} //Does our target box 'stick' even after we're untargeted for awhile 
simulated function bool HasVeterancy() {return false;}

//Spotting
simulated function bool IsSpottable() {return false;}
simulated function bool IsCommandSpottable() {return false;} 

simulated function bool IsSpyTarget(){return false;} //Do we use spy mechanics? IE: our bounding box will show up friendly to the enemy [.... There are no spy Refineries...... Or are there?]

/* Text related */

simulated function string GetTargetName() {return "Adv. Sniper PT";} //Get our targeted name 
simulated function string GetInteractText(Controller C, string BindKey) {return "";} //Get the text for our interaction 
simulated function string GetTargetedDescription(PlayerController PlayerPerspective) {return "";} //Get any special description we might have when targeted 

//Actions
simulated function SetTargeted(bool bTargeted) 
{
	return; //lol, why the hell is it spelled different? 
}; //Function to say what to do when you're targeted client-side 

/*----------------------------------------*/
/*END TARGET INTERFACE [RxIfc_Targetable]*/
/*---------------------------------------*/

simulated function string GetHumanReadableName()
{
	return "Adv. Sniper PT";
}

DefaultProperties
{
	Begin Object Class=StaticMeshComponent Name=MCTMeshCmp
		StaticMesh                   = StaticMesh'rx_deco_terminal.Mesh.SM_BU_MCT_Visible'
		CollideActors                = True
		BlockActors                  = True
		BlockRigidBody               = True
		BlockZeroExtent              = True
		BlockNonZeroExtent           = True
		bCastDynamicShadow           = True
		bAcceptsDynamicLights        = True
		bAcceptsLights               = True
		bAcceptsDecalsDuringGameplay = True
		bAcceptsDecals               = True
		AlwaysLoadOnClient=true
		RBChannel                    = RBCC_Pawn
		RBCollideWithChannels        = (Pawn=True)
	End Object
	CollisionComponent=MCTMeshCmp
	Components.Add(MCTMeshCmp)
	MCTSkeletalMesh = MCTMeshCmp

	RemoteRole            = ROLE_SimulatedProxy
	bBlocksNavigation   = false
	bBlocksTeleport     = True
	BlockRigidBody      = True
	bCollideActors      = True
	bBlockActors        = True
	bStatic             = false
	bWorldGeometry      = True
	bMovable            = true
	bAlwaysRelevant     = True
	bGameRelevant       = True
	bOnlyDirtyReplication = True
	
	NetUpdateFrequency=10.0
}
