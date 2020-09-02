class Rx_Weapon_SniperRifle_Modified extends Rx_Weapon_Scoped_Modified;

DefaultProperties
{
	CustomWeaponName="1337 Sniper"

	Begin Object class=AnimNodeSequence Name=MeshSequenceA
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'RX_WP_SniperRifle.Mesh.SK_DSR50_1P'
		AnimSets(0)=AnimSet'RX_WP_SniperRifle.Anims.AS_DSR50_1P'
		Animations=MeshSequenceA
		Scale=2.0
		FOV=55
	End Object

	// Weapon SkeletalMesh
	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'RX_WP_SniperRifle.Mesh.SK_DSR50_Back'		// SkeletalMesh'RX_WP_SniperRifle.Mesh.SK_WP_SniperRifle_Back'
		// Translation=(X=-12)
		Scale=1.0
	End Object

	ArmsAnimSet=AnimSet'RX_WP_SniperRifle.Anims.AS_DSR50_Arms'
	
	PlayerViewOffset=(X=2.0,Y=0.0,Z=-1.0)		// (X=-5.0,Y=-3.0,Z=-0.5)
	
	LeftHandIK_Offset=(X=0.0,Y=0.0,Z=0.0)
	RightHandIK_Offset=(X=3.0,Y=-1.0,Z=-2.0)
	LeftHandIK_Relaxed_Offset = (X=2.0,Y=-1.5,Z=3.5)

	//-------------- Recoil
	RecoilDelay = 0.00
	MinRecoil = 1.0
	MaxRecoil = 1.0
	MaxTotalRecoil = 1.0
	RecoilYawModifier = 0.0 // will be a random value between 0 and this value for every shot
	RecoilInterpSpeed = 0.0
	RecoilDeclinePct = 0.0
	RecoilDeclineSpeed = 10.0
	MaxSpread = 0.0
	RecoilSpreadIncreasePerShot = 0.0
	RecoilSpreadDeclineSpeed = 0.1
	RecoilSpreadDecreaseDelay = 0.3
	RecoilSpreadCrosshairScaling = 4000	// 2500
	
	bInstantHit=true
	bSplashJump=false
	bRecommendSplashDamage=false
	bSniping=true
	GroupWeight=1
	AimError=600

	InventoryGroup=2

	ShotCost(0)=0
	ShotCost(1)=1
	FireInterval(0)=+1.0
	FireInterval(1)=+0.0
	ReloadTime(0) = 4.0
	ReloadTime(1) = 4.0
	
	EquipTime=0.75
//	PutDownTime=0.5
	
	Spread(0)=0.0 //0.1 //0.0
	IronSightAndScopedSpread(0)= 0.0
	
	InstantHitDamage(0)=100
	InstantHitDamage(1)=0
	InstantHitMomentum(0)=10000.0
	
	HeadShotDamageMult=3.5 //3.25 //3.0

//	BotDamagePercentage = 0.4;

	WeaponFireTypes(0)=EWFT_InstantHit

	FiringStatesArray(1)=Active

	InstantHitDamageTypes(0)=class'Rx_DmgType_SniperRifle'
	InstantHitDamageTypes(1)=None

	ClipSize = 999
	InitalNumClips = 999
	MaxClips = 999
	bHasInfiniteAmmo=true
	
	bAutoFire = false
	BoltActionReload=true
	BoltReloadTime(0) = 1.75 //2.0f (Factor in RefireBoltReloadInterrupt) 
	BoltReloadTime(1) = 1.75 //2.0f

	ReloadAnimName(0) = "weaponreload"
	ReloadAnimName(1) = "weaponreload"
	ReloadArmAnimName(0) = "weaponreload"
	ReloadArmAnimName(1) = "weaponreload"
	
	BoltReloadAnimName(0) = "WeaponBolt"
	BoltReloadAnimName(1) = "WeaponBolt"
	BoltReloadArmAnimName(0) = "WeaponBolt"
	BoltReloadArmAnimName(1) = "WeaponBolt"

	WeaponFireSnd[0]=SoundCue'RX_WP_SniperRifle.Sounds.SC_DSR50_Fire'
	WeaponFireSnd[1]=SoundCue'RX_WP_SniperRifle.Sounds.SC_DSR50_Fire'
	
	WeaponPutDownSnd=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_PutDown'
	WeaponEquipSnd=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Equip'
	ReloadSound(0)=SoundCue'RX_WP_SniperRifle.Sounds.SC_DSR50_Reload'
	ReloadSound(1)=SoundCue'RX_WP_SniperRifle.Sounds.SC_DSR50_Reload'
	BoltReloadSound(0)=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_BoltPull'
	BoltReloadSound(1)=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_BoltPull'

	PickupSound=SoundCue'RX_WP_SniperRifle.Sounds.SC_Sniper_Reload'

	MuzzleFlashSocket=MuzzleFlashSocket
	FireSocket=MuzzleFlashSocket
	MuzzleFlashPSCTemplate=ParticleSystem'RX_WP_AutoRifle.Effects.MuzzleFlash_1P'
	MuzzleFlashDuration=0.1
	MuzzleFlashLightClass=class'Rx_Light_AutoRifle_MuzzleFlash'

	// Configure the zoom

	bZoomedFireMode(0)=0
	bZoomedFireMode(1)=1

	bInstantZoom=true

	CrosshairWidth = 256
	CrosshairHeight = 256
	
	CrosshairMIC = MaterialInstanceConstant'RenX_AssetBase.UI.MI_Reticle_Simple'

	CrosshairDotMIC = MaterialInstanceConstant'RenXHud.MI_Reticle_Dot'

	CrossHairCoordinates=(U=256,V=64,UL=64,VL=64)
	IconCoordinates=(U=726,V=532,UL=165,VL=51)

	bDisplaycrosshair = true;
	InventoryMovieGroup=5
	// DroppedPickupClass = class'RxDroppedPickup_SniperRifle'
	
	WeaponIconTexture=Texture2D'RX_WP_SniperRifle.UI.T_WeaponIcon_SniperRifle'
	
	/*******************/
	/*Veterancy*/
	/******************/
	
	Vet_DamageModifier(0)=1  //Applied to instant-hits only
	Vet_DamageModifier(1)=1 
	Vet_DamageModifier(2)=1 
	Vet_DamageModifier(3)=1 
	
	Vet_ROFModifier(0) = 1
	Vet_ROFModifier(1) = 1 
	Vet_ROFModifier(2) = 1  
	Vet_ROFModifier(3) = 1  
	
	Vet_ClipSizeModifier(0)=0 //Normal (should be 1)	
	Vet_ClipSizeModifier(1)=0 //Veteran 
	Vet_ClipSizeModifier(2)=0 //Elite
	Vet_ClipSizeModifier(3)=0 //Heroic

	Vet_ReloadSpeedModifier(0)=1 //Normal (should be 1)
	Vet_ReloadSpeedModifier(1)=1 //Veteran 
	Vet_ReloadSpeedModifier(2)=1 //Elite
	Vet_ReloadSpeedModifier(3)=1 //Heroic
	/**********************/
	
	bLocSync = true; 
	ROFTurnover = 2;

	IronSightViewOffset=(X=-5,Y=-6.45,Z=0.84)

	AttachmentClass=class'Rx_Attachment_SniperRifle_Nod'

	/** one1: Added. */
	BackWeaponAttachmentClass = class'Rx_BackWeaponAttachment_SniperRifle_Nod'
}