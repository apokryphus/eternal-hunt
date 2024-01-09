function ACS_WeaponDestroyInit()
{
	if ( 
	ACS_GetWeaponMode() == 0
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2
	)
	{
		ACS_HideSword();
	}

	if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
	{
		ClawDestroy();
	}

	IgniSwordDestroy();
	QuenSwordDestroy();
	AardSwordDestroy();
	YrdenSwordDestroy();
	AxiiSwordDestroy();	
	IgniSecondarySwordDestroy();
	QuenSecondarySwordDestroy();
	AardSecondarySwordDestroy();
	YrdenSecondarySwordDestroy();
	AxiiSecondarySwordDestroy();

	IgniBowDestroy();
	AxiiBowDestroy();
	AardBowDestroy();
	YrdenBowDestroy();
	QuenBowDestroy();

	IgniCrossbowDestroy();
	AxiiCrossbowDestroy();
	AardCrossbowDestroy();
	YrdenCrossbowDestroy();
	QuenCrossbowDestroy();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');
	ACS_Yrden_Sidearm_Destroy();

	ACS_Bow_Arrow().Destroy();

	ACS_Crossbow_Arrow().BreakAttachment();
	ACS_Crossbow_Arrow().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
	ACS_Crossbow_Arrow().DestroyAfter(0.125);
	ACS_Crossbow_Arrow().RemoveTag('ACS_Crossbow_Arrow');

	ACS_Sword_Trail_1().Destroy();
	ACS_Sword_Trail_2().Destroy();
	ACS_Sword_Trail_3().Destroy();
	ACS_Sword_Trail_4().Destroy();
	ACS_Sword_Trail_5().Destroy();
	ACS_Sword_Trail_6().Destroy();
	ACS_Sword_Trail_7().Destroy();
	ACS_Sword_Trail_8().Destroy();

	if (GetACSArmorEtherSword())
	{
		GetACSArmorEtherSword().Destroy();

		thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
	}
}

function ACS_WeaponDestroyIMMEDIATEInit()
{
	if ( 
	ACS_GetWeaponMode() == 0
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2
	)
	{
		ACS_HideSword();
	}

	if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
	{
		ClawDestroy();
	}

	IgniSwordDestroy();
	QuenSwordDestroyIMMEDIATE();
	AardSwordDestroyIMMEDIATE();
	YrdenSwordDestroyIMMEDIATE();
	AxiiSwordDestroyIMMEDIATE();	
	IgniSecondarySwordDestroy();
	QuenSecondarySwordDestroyIMMEDIATE();
	AardSecondarySwordDestroyIMMEDIATE();
	YrdenSecondarySwordDestroyIMMEDIATE();
	AxiiSecondarySwordDestroyIMMEDIATE();

	IgniBowDestroyIMMEDIATE();
	AxiiBowDestroyIMMEDIATE();
	AardBowDestroyIMMEDIATE();
	YrdenBowDestroyIMMEDIATE();
	QuenBowDestroyIMMEDIATE();

	IgniCrossbowDestroyIMMEDIATE();
	AxiiCrossbowDestroyIMMEDIATE();
	AardCrossbowDestroyIMMEDIATE();
	YrdenCrossbowDestroyIMMEDIATE();
	QuenCrossbowDestroyIMMEDIATE();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');
	ACS_Yrden_Sidearm_DestroyIMMEDIATE();

	ACS_Bow_Arrow().Destroy();

	ACS_Crossbow_Arrow().BreakAttachment();
	ACS_Crossbow_Arrow().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
	ACS_Crossbow_Arrow().DestroyAfter(0.125);
	ACS_Crossbow_Arrow().RemoveTag('ACS_Crossbow_Arrow');

	ACS_Sword_Trail_1().Destroy();
	ACS_Sword_Trail_2().Destroy();
	ACS_Sword_Trail_3().Destroy();
	ACS_Sword_Trail_4().Destroy();
	ACS_Sword_Trail_5().Destroy();
	ACS_Sword_Trail_6().Destroy();
	ACS_Sword_Trail_7().Destroy();
	ACS_Sword_Trail_8().Destroy();

	if (GetACSArmorEtherSword())
	{
		GetACSArmorEtherSword().Destroy();

		thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
	}
}

function ACS_WeaponDestroyInit_WITHOUT_HIDESWORD()
{
	if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
	{
		ClawDestroy();
	}
	
	IgniSwordDestroy();
	QuenSwordDestroy();
	AardSwordDestroy();
	YrdenSwordDestroy();
	AxiiSwordDestroy();	
	IgniSecondarySwordDestroy();
	QuenSecondarySwordDestroy();
	AardSecondarySwordDestroy();
	YrdenSecondarySwordDestroy();
	AxiiSecondarySwordDestroy();

	IgniBowDestroy();
	AxiiBowDestroy();
	AardBowDestroy();
	YrdenBowDestroy();
	QuenBowDestroy();

	IgniCrossbowDestroy();
	AxiiCrossbowDestroy();
	AardCrossbowDestroy();
	YrdenCrossbowDestroy();
	QuenCrossbowDestroy();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');
	ACS_Yrden_Sidearm_Destroy();

	ACS_Sword_Trail_1().Destroy();
	ACS_Sword_Trail_2().Destroy();
	ACS_Sword_Trail_3().Destroy();
	ACS_Sword_Trail_4().Destroy();
	ACS_Sword_Trail_5().Destroy();
	ACS_Sword_Trail_6().Destroy();
	ACS_Sword_Trail_7().Destroy();
	ACS_Sword_Trail_8().Destroy();

	if (GetACSArmorEtherSword())
	{
		GetACSArmorEtherSword().Destroy();

		thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
	}
}

function ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE()
{
	if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
	{
		ClawDestroy();
	}
	
	IgniSwordDestroy();
	QuenSwordDestroyIMMEDIATE();
	AardSwordDestroyIMMEDIATE();
	YrdenSwordDestroyIMMEDIATE();
	AxiiSwordDestroyIMMEDIATE();	
	IgniSecondarySwordDestroy();
	QuenSecondarySwordDestroyIMMEDIATE();
	AardSecondarySwordDestroyIMMEDIATE();
	YrdenSecondarySwordDestroyIMMEDIATE();
	AxiiSecondarySwordDestroyIMMEDIATE();

	IgniBowDestroyIMMEDIATE();
	AxiiBowDestroyIMMEDIATE();
	AardBowDestroyIMMEDIATE();
	YrdenBowDestroyIMMEDIATE();
	QuenBowDestroyIMMEDIATE();

	IgniCrossbowDestroyIMMEDIATE();
	AxiiCrossbowDestroyIMMEDIATE();
	AardCrossbowDestroyIMMEDIATE();
	YrdenCrossbowDestroyIMMEDIATE();
	QuenCrossbowDestroyIMMEDIATE();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');
	ACS_Yrden_Sidearm_DestroyIMMEDIATE();

	ACS_Sword_Trail_1().Destroy();
	ACS_Sword_Trail_2().Destroy();
	ACS_Sword_Trail_3().Destroy();
	ACS_Sword_Trail_4().Destroy();
	ACS_Sword_Trail_5().Destroy();
	ACS_Sword_Trail_6().Destroy();
	ACS_Sword_Trail_7().Destroy();
	ACS_Sword_Trail_8().Destroy();

	if (GetACSArmorEtherSword())
	{
		GetACSArmorEtherSword().Destroy();

		thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
	}
}

function ACS_Weapon_Invisible()
{
	if (!GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge_Claw_Effect'))
	{
		/*
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active'))
		{
			if (!ACS_GetItem_VampClaw_Shades() 
			&& !GetWitcherPlayer().HasTag('vampire_claws_equipped') 
			&& GetWitcherPlayer().IsInCombat())
			{
				GetWitcherPlayer().PlayEffectSingle('claws_effect');
				GetWitcherPlayer().StopEffect('claws_effect');

				ACS_ClawEquip_OnDodge();
			}
		}
		*/

		ACS_HideSwordWitoutScabbardStuff();

		if ( ACS_GetWeaponMode() == 3)
		{
			if (!GetWitcherPlayer().HasTag('blood_sucking'))
			{
				if (!GetWitcherPlayer().HasTag('aard_sword_equipped') )
				{
					igni_sword_summon();
				}
			}
		}

		GetWitcherPlayer().AddTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}

	//ACS_StopAerondightEffectInit();

	if (GetWitcherPlayer().HasTag('quen_sword_equipped'))
	{
		quen_sword_summon();
		QuenSwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
	{
		axii_sword_summon();
		AxiiSwordDestroy_NOTAG();	
	}
	else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
	{
		aard_sword_summon();
		AardSwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('yrden_sword_equipped'))
	{
		yrden_sword_summon();
		YrdenSwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
	{
		quen_secondary_sword_summon();
		QuenSecondarySwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
	{
		axii_secondary_sword_summon();
		AxiiSecondarySwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
	{
		aard_secondary_sword_summon();
		AardSecondarySwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
	{
		yrden_secondary_sword_summon();
		YrdenSecondarySwordDestroy_NOTAG();
	}

	if (GetACSArmorEtherSword())
	{
		GetACSArmorEtherSword().Destroy();

		thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
	}
	
	ACS_Sword_Trail_1().StopAllEffects();

	ACS_Sword_Trail_2().StopAllEffects();
	
	ACS_Sword_Trail_3().StopAllEffects();

	ACS_Sword_Trail_4().StopAllEffects();

	ACS_Sword_Trail_5().StopAllEffects();

	ACS_Sword_Trail_6().StopAllEffects();

	ACS_Sword_Trail_7().StopAllEffects();

	ACS_Sword_Trail_8().StopAllEffects();
}

function ACS_HideSwordWitoutScabbardStuff()
{
	var steelID, silverID 													: SItemUniqueId;
	var steelsword, silversword, scabbard_steel, scabbard_silver			: CDrawableComponent;
	var scabbards_steel, scabbards_silver 									: array<SItemUniqueId>;
	var i 																	: int;
	var steelswordentity, silverswordentity 								: CEntity;
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
	steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
	silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
	
	if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) )
	{
		steelsword.SetVisible(false);

		steelswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
		steelswordentity.SetHideInGame(true);
	}
	else if ( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
	{
		silversword.SetVisible(false);

		silverswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);
		silverswordentity.SetHideInGame(true);
	}

	GetWitcherPlayer().RemoveTag('igni_sword_effect_played');

	GetWitcherPlayer().RemoveTag('igni_secondary_sword_effect_played');
}

function ACS_ShowSwordWitoutScabbardStuff()
{
	var steelID, silverID 													: SItemUniqueId;
	var steelsword, silversword, scabbard_steel, scabbard_silver			: CDrawableComponent;
	var scabbards_steel, scabbards_silver 									: array<SItemUniqueId>;
	var i 																	: int;
	var steelswordentity, silverswordentity 								: CEntity;

	ACS_Bow_Arrow().Destroy();
	ACS_Crossbow_Arrow().BreakAttachment();
	ACS_Crossbow_Arrow().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
	ACS_Crossbow_Arrow().DestroyAfter(0.125);
	ACS_Crossbow_Arrow().RemoveTag('ACS_Crossbow_Arrow');
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
	steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
	silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
	
	if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) )
	{
		steelsword.SetVisible(true);

		steelswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
		steelswordentity.SetHideInGame(false);
	}
	else if ( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
	{
		silversword.SetVisible(true);

		silverswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);
		silverswordentity.SetHideInGame(false);
	}
}

function ACS_HideSword()
{
	var steelsword, silversword, scabbard_steel, scabbard_silver			: CDrawableComponent;
	var scabbards_steel, scabbards_silver 									: array<SItemUniqueId>;
	var i 																	: int;
	var steelID, silverID, rangedID 										: SItemUniqueId;
	var steelswordentity, silverswordentity, crossbowentity 				: CEntity;
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon, rangedID);
		
	steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
	silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
	
	if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) )
	{
		steelsword.SetVisible(false);

		steelswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
		steelswordentity.SetHideInGame(true); 

		scabbards_steel.Clear();

		scabbards_steel = GetWitcherPlayer().GetInventory().GetItemsByCategory('steel_scabbards');

		for ( i=0; i < scabbards_steel.Size() ; i+=1 )
		{
			scabbard_steel = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
			scabbard_steel.SetVisible(false);
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if (ACS_HideSwordsheathes_Enabled() || ACS_CloakEquippedCheck())
		{
			silversword.SetVisible(false);

			silverswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);
			silverswordentity.SetHideInGame(true); 

			scabbards_silver.Clear();

			scabbards_silver = GetWitcherPlayer().GetInventory().GetItemsByCategory('silver_scabbards');

			for ( i=0; i < scabbards_silver.Size() ; i+=1 )
			{
				scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
				scabbard_silver.SetVisible(false);
			}

			crossbowentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(rangedID);

			crossbowentity.SetHideInGame(true);
			
			GetWitcherPlayer().rangedWeapon.ClearDeployedEntity(true);
		}
		
	}
	else if ( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
	{
		silversword.SetVisible(false);

		silverswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);
		silverswordentity.SetHideInGame(true); 

		scabbards_silver.Clear();

		scabbards_silver = GetWitcherPlayer().GetInventory().GetItemsByCategory('silver_scabbards');

		for ( i=0; i < scabbards_silver.Size() ; i+=1 )
		{
			scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
			scabbard_silver.SetVisible(false);
		}

		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if (ACS_HideSwordsheathes_Enabled() || ACS_CloakEquippedCheck())
		{
			steelsword.SetVisible(false);

			steelswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
			steelswordentity.SetHideInGame(true); 

			scabbards_steel.Clear();

			scabbards_steel = GetWitcherPlayer().GetInventory().GetItemsByCategory('steel_scabbards');

			for ( i=0; i < scabbards_steel.Size() ; i+=1 )
			{
				scabbard_steel = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
				scabbard_steel.SetVisible(false);
			}

			crossbowentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(rangedID);

			crossbowentity.SetHideInGame(true);
			
			GetWitcherPlayer().rangedWeapon.ClearDeployedEntity(true);
		}

	}

	GetWitcherPlayer().RemoveTag('igni_sword_effect_played');

	GetWitcherPlayer().RemoveTag('igni_secondary_sword_effect_played');
}

function ACS_ClawEquip_OnDodge()
{
	var vACS_ClawEquip_OnDodge : cACS_ClawEquip_OnDodge;
	vACS_ClawEquip_OnDodge = new cACS_ClawEquip_OnDodge in theGame;
			
	vACS_ClawEquip_OnDodge.ClawEquip_OnDodge_Engage();	
}

statemachine class cACS_ClawEquip_OnDodge
{
    function ClawEquip_OnDodge_Engage()
	{
		this.PushState('ClawEquip_OnDodge_Engage');
	}
}

state ClawEquip_OnDodge_Engage in cACS_ClawEquip_OnDodge
{
	private var claw_temp								: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		ClawDestroy_Latent();
	}
	
	latent function ClawDestroy_Latent()
	{
		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = GetWitcherPlayer();
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
			
			if (ACS_Armor_Equipped_Check())
			{
				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
			}
			else
			{
				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
			}
		}
	}
}

function ClawDestroy_NOTAG()
{
	var vClawDestroy_NOTAG : cClawDestroy_NOTAG;
	vClawDestroy_NOTAG = new cClawDestroy_NOTAG in theGame;
			
	vClawDestroy_NOTAG.ClawDestroy_NOTAG_Engage();

	ACS_Sword_Trail_1().Destroy();
	ACS_Sword_Trail_2().Destroy();
	ACS_Sword_Trail_3().Destroy();
	ACS_Sword_Trail_4().Destroy();
	ACS_Sword_Trail_5().Destroy();
	ACS_Sword_Trail_6().Destroy();
	ACS_Sword_Trail_7().Destroy();
	ACS_Sword_Trail_8().Destroy();
}

statemachine class cClawDestroy_NOTAG
{
    function ClawDestroy_NOTAG_Engage()
	{
		this.PushState('ClawDestroy_NOTAG_Engage');
	}
}

state ClawDestroy_NOTAG_Engage in cClawDestroy_NOTAG
{
	private var claw_temp, head_temp					: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		ClawDestroy_Latent();
	}
	
	latent function ClawDestroy_Latent()
	{
		//ACS_Blood_Armor_Destroy();

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			//GetWitcherPlayer().PlayEffectSingle('dive_shape');
		}

		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = GetWitcherPlayer();
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
				
			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			//GetWitcherPlayer().PlayEffectSingle('claws_effect');
			//GetWitcherPlayer().StopEffect('claws_effect');
		}
	}
}

function ClawDestroy()
{
	var vClawDestroy : cClawDestroy;
	vClawDestroy = new cClawDestroy in theGame;
			
	vClawDestroy.ClawDestroy_Engage();

	ACS_Sword_Trail_1().Destroy();
	ACS_Sword_Trail_2().Destroy();
	ACS_Sword_Trail_3().Destroy();
	ACS_Sword_Trail_4().Destroy();
	ACS_Sword_Trail_5().Destroy();
	ACS_Sword_Trail_6().Destroy();
	ACS_Sword_Trail_7().Destroy();
	ACS_Sword_Trail_8().Destroy();
}

statemachine class cClawDestroy
{
    function ClawDestroy_Engage()
	{
		this.PushState('ClawDestroy_Engage');
	}
}

state ClawDestroy_Engage in cClawDestroy
{
	private var claw_temp, head_temp					: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;
	private var components 								: array < CComponent >;
	private var playerccomp 							: CComponent;
	private var i										: int;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		ClawDestroy_Latent();
	}
	
	latent function ClawDestroy_Latent()
	{
		ACS_Blood_Armor_Destroy();

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().StopEffect('dive_shape');	
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			GetWitcherPlayer().StopEffect('blood_color_2');
			GetWitcherPlayer().PlayEffectSingle('blood_color_2');
		}

		if (!ACS_GetItem_VampClaw_Shades())
		{
			GetWitcherPlayer().PlayEffectSingle('claws_effect');
			GetWitcherPlayer().StopEffect('claws_effect');

			p_actor = GetWitcherPlayer();
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
				
			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);
		}
			
		GetWitcherPlayer().RemoveTag('vampire_claws_equipped');	

		if (ACS_Manual_Sword_Drawing_Check_Actual() == 0)
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', false);
		}
		else if (ACS_Manual_Sword_Drawing_Check_Actual() == 1)
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', true);
		}
			
		GetWitcherPlayer().RemoveTag('ACS_blood_armor');

		GetWitcherPlayer().UnblockAction(EIAB_SpecialAttackLight,	'ACS_Vamp_Claws_Block_Action');
		GetWitcherPlayer().UnblockAction(EIAB_SpecialAttackHeavy,	'ACS_Vamp_Claws_Block_Action');

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
						}
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
						}
					}
				}
			}

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walk_forward_dettlaff_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1.0f));
		}
	}
}

function ACS_Blood_Armor_Destroy()
{
	thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP_Stop" );

	ACS_Vampire_Arms_1_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_2_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_3_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_4_Get().StopEffect('blood_color');

	ACS_Vampire_Head_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_1_Get().BreakAttachment(); 
	ACS_Vampire_Arms_1_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_1_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_2_Get().BreakAttachment(); 
	ACS_Vampire_Arms_2_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_2_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_3_Get().BreakAttachment(); 
	ACS_Vampire_Arms_3_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_3_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_4_Get().BreakAttachment(); 
	ACS_Vampire_Arms_4_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_4_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_Anchor_L_Get().BreakAttachment(); 
	ACS_Vampire_Arms_Anchor_L_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_Anchor_L_Get().DestroyAfter(0.00125);

	ACS_Vampire_Arms_Anchor_R_Get().BreakAttachment(); 
	ACS_Vampire_Arms_Anchor_R_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Arms_Anchor_R_Get().DestroyAfter(0.00125);

	ACS_Vampire_Head_Anchor_Get().BreakAttachment(); 
	ACS_Vampire_Head_Anchor_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Head_Anchor_Get().DestroyAfter(0.00125);

	ACS_Vampire_Head_Get().BreakAttachment(); 
	ACS_Vampire_Head_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Head_Get().DestroyAfter(0.00125);

	ACS_Vampire_Back_Claw_Get().BreakAttachment(); 
	ACS_Vampire_Back_Claw_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Back_Claw_Get().DestroyAfter(0.00125);

	ACS_Vampire_Claw_Anchor_Get().BreakAttachment(); 
	ACS_Vampire_Claw_Anchor_Get().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Vampire_Claw_Anchor_Get().DestroyAfter(0.00125);
}

function ACS_Blood_Armor_Destroy_IMMEDIATE()
{
	ACS_Blood_Armor_Destroy_Without_Back_Claw_IMMEDIATE();

	ACS_Vampire_Back_Claw_Get().Destroy();

	ACS_Vampire_Claw_Anchor_Get().Destroy();
}

function ACS_Blood_Armor_Destroy_Without_Back_Claw_IMMEDIATE()
{
	thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP_Stop" );

	thePlayer.DestroyEffect('blood_color');

	ACS_Vampire_Arms_1_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_2_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_3_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_4_Get().StopEffect('blood_color');

	ACS_Vampire_Head_Get().StopEffect('blood_color');

	ACS_Vampire_Arms_1_Get().Destroy();

	ACS_Vampire_Arms_2_Get().Destroy();

	ACS_Vampire_Arms_3_Get().Destroy();

	ACS_Vampire_Arms_4_Get().Destroy();

	ACS_Vampire_Arms_Anchor_L_Get().Destroy();

	ACS_Vampire_Arms_Anchor_R_Get().Destroy();

	ACS_Vampire_Head_Anchor_Get().Destroy();

	ACS_Vampire_Head_Get().Destroy();
}

function ClawDestroy_WITH_EFFECT()
{
	var vClawDestroy_WITH_EFFECT : cClawDestroy_WITH_EFFECT;
	vClawDestroy_WITH_EFFECT = new cClawDestroy_WITH_EFFECT in theGame;
			
	vClawDestroy_WITH_EFFECT.ClawDestroy_WITH_EFFECT_Engage();

	ACS_Sword_Trail_1().Destroy();
	ACS_Sword_Trail_2().Destroy();
	ACS_Sword_Trail_3().Destroy();
	ACS_Sword_Trail_4().Destroy();
	ACS_Sword_Trail_5().Destroy();
	ACS_Sword_Trail_6().Destroy();
	ACS_Sword_Trail_7().Destroy();
	ACS_Sword_Trail_8().Destroy();
}

statemachine class cClawDestroy_WITH_EFFECT
{
    function ClawDestroy_WITH_EFFECT_Engage()
	{
		this.PushState('ClawDestroy_WITH_EFFECT_Engage');
	}
}

state ClawDestroy_WITH_EFFECT_Engage in cClawDestroy_WITH_EFFECT
{
	private var claw_temp, head_temp					: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;
	private var components 								: array < CComponent >;
	private var drawableComponent 						: CDrawableComponent;
	private var i										: int;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		ClawDestroy_Latent();
	}
	
	latent function ClawDestroy_Latent()
	{
		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInCombat()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
						}
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
						}
					}
				}
			}

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walk_forward_dettlaff_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1.0f));
		}

		ACS_Blood_Armor_Destroy();

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().StopEffect('dive_shape');	
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			GetWitcherPlayer().StopEffect('blood_color_2');
			GetWitcherPlayer().PlayEffectSingle('blood_color_2');
		}
		
		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = GetWitcherPlayer();
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			GetWitcherPlayer().PlayEffectSingle('claws_effect');
			GetWitcherPlayer().StopEffect('claws_effect');
		}
			
		GetWitcherPlayer().RemoveTag('vampire_claws_equipped');	

		if (ACS_Manual_Sword_Drawing_Check_Actual() == 0)
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', false);
		}
		else if (ACS_Manual_Sword_Drawing_Check_Actual() == 1)
		{
			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', true);
		}

		components.Clear();

		components =  GetWitcherPlayer().GetComponentsByClassName ( 'CDrawableComponent' );
			
		for ( i = 0; i < components.Size(); i+=1 )
		{
			drawableComponent = ( CDrawableComponent)components[i];
			drawableComponent.SetCastingShadows ( true );
		}

		GetWitcherPlayer().RemoveTag('ACS_blood_armor');

		GetWitcherPlayer().UnblockAction(EIAB_SpecialAttackLight,	'ACS_Vamp_Claws_Block_Action');
		GetWitcherPlayer().UnblockAction(EIAB_SpecialAttackHeavy,	'ACS_Vamp_Claws_Block_Action');
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////

function IgniSwordDestroy()
{
	//ACS_HideSword();
		
	GetWitcherPlayer().RemoveTag('igni_sword_equipped');

	GetWitcherPlayer().RemoveTag('igni_sword_equipped_TAG');

	GetWitcherPlayer().RemoveTag('igni_sword_effect_played');
}
	
function IgniSecondarySwordDestroy()
{
	//ACS_HideSword();
		
	GetWitcherPlayer().RemoveTag('igni_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('igni_secondary_sword_equipped_TAG');

	GetWitcherPlayer().RemoveTag('igni_secondary_sword_effect_played');
}
	
function QuenSwordDestroy()
{
	quen_sword_1().BreakAttachment();
	quen_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_1().DestroyAfter(0.00125);

	quen_sword_2().BreakAttachment();
	quen_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_2().DestroyAfter(0.00125);

	quen_sword_3().BreakAttachment();
	quen_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_3().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('quen_sword_equipped');

	GetWitcherPlayer().RemoveTag('quen_sword_effect_played');
}

function QuenSwordDestroyIMMEDIATE()
{
	quen_sword_1().Destroy();

	quen_sword_2().Destroy();

	quen_sword_3().Destroy();
		
	GetWitcherPlayer().RemoveTag('quen_sword_equipped');

	GetWitcherPlayer().RemoveTag('quen_sword_effect_played');
}

function QuenSwordDestroy_NOTAG()
{
	quen_sword_1().BreakAttachment();
	quen_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_1().DestroyAfter(0.00125);

	quen_sword_2().BreakAttachment();
	quen_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_2().DestroyAfter(0.00125);

	quen_sword_3().BreakAttachment();
	quen_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_sword_3().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('quen_sword_effect_played');
}
	
function QuenSecondarySwordDestroy()
{	
	quen_secondary_sword_1().BreakAttachment(); 
	quen_secondary_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_1().DestroyAfter(0.00125);
		
	quen_secondary_sword_2().BreakAttachment(); 
	quen_secondary_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_2().DestroyAfter(0.00125);
		
	quen_secondary_sword_3().BreakAttachment(); 
	quen_secondary_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_3().DestroyAfter(0.00125);
		
	quen_secondary_sword_4().BreakAttachment(); 
	quen_secondary_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_4().DestroyAfter(0.00125);
		
	quen_secondary_sword_5().BreakAttachment(); 
	quen_secondary_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_5().DestroyAfter(0.00125);
		
	quen_secondary_sword_6().BreakAttachment(); 
	quen_secondary_sword_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_6().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('quen_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('quen_secondary_sword_effect_played');
}

function QuenSecondarySwordDestroyIMMEDIATE()
{	
	quen_secondary_sword_1().Destroy();

	quen_secondary_sword_2().Destroy();

	quen_secondary_sword_3().Destroy();

	quen_secondary_sword_4().Destroy();

	quen_secondary_sword_5().Destroy();

	quen_secondary_sword_6().Destroy();
		
	GetWitcherPlayer().RemoveTag('quen_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('quen_secondary_sword_effect_played');
}

function QuenSecondarySwordDestroy_NOTAG()
{	
	quen_secondary_sword_1().BreakAttachment(); 
	quen_secondary_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_1().DestroyAfter(0.00125);
		
	quen_secondary_sword_2().BreakAttachment(); 
	quen_secondary_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_2().DestroyAfter(0.00125);
		
	quen_secondary_sword_3().BreakAttachment(); 
	quen_secondary_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_3().DestroyAfter(0.00125);
		
	quen_secondary_sword_4().BreakAttachment(); 
	quen_secondary_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_4().DestroyAfter(0.00125);
		
	quen_secondary_sword_5().BreakAttachment(); 
	quen_secondary_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_5().DestroyAfter(0.00125);
		
	quen_secondary_sword_6().BreakAttachment(); 
	quen_secondary_sword_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_secondary_sword_6().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('quen_secondary_sword_effect_played');
}
	
function AardSwordDestroy()
{	
	aard_l_anchor_1().BreakAttachment(); 
	aard_l_anchor_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_l_anchor_1().DestroyAfter(0.00125);

	aard_r_anchor_1().BreakAttachment(); 
	aard_r_anchor_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_r_anchor_1().DestroyAfter(0.00125);

	aard_blade_1().BreakAttachment(); 
	aard_blade_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_1().DestroyAfter(0.00125);
		
	aard_blade_2().BreakAttachment(); 
	aard_blade_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_2().DestroyAfter(0.00125);
		
	aard_blade_3().BreakAttachment(); 
	aard_blade_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_3().DestroyAfter(0.00125);
		
	aard_blade_4().BreakAttachment(); 
	aard_blade_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_4().DestroyAfter(0.00125);
		
	aard_blade_5().BreakAttachment(); 
	aard_blade_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_5().DestroyAfter(0.00125);
		
	aard_blade_6().BreakAttachment(); 
	aard_blade_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_6().DestroyAfter(0.00125);

	aard_blade_7().BreakAttachment(); 
	aard_blade_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_7().DestroyAfter(0.00125);

	aard_blade_8().BreakAttachment(); 
	aard_blade_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('aard_sword_equipped');

	GetWitcherPlayer().RemoveTag('aard_sword_effect_played');
}

function AardSwordDestroyIMMEDIATE()
{	
	aard_l_anchor_1().Destroy();

	aard_r_anchor_1().Destroy();

	aard_blade_1().Destroy();
		
	aard_blade_2().Destroy();

	aard_blade_3().Destroy();

	aard_blade_4().Destroy();

	aard_blade_5().Destroy();

	aard_blade_6().Destroy();

	aard_blade_7().Destroy();

	aard_blade_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('aard_sword_equipped');

	GetWitcherPlayer().RemoveTag('aard_sword_effect_played');
}

function AardSwordDestroy_NOTAG()
{	
	aard_l_anchor_1().BreakAttachment(); 
	aard_l_anchor_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_l_anchor_1().DestroyAfter(0.00125);

	aard_r_anchor_1().BreakAttachment(); 
	aard_r_anchor_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_r_anchor_1().DestroyAfter(0.00125);

	aard_blade_1().BreakAttachment(); 
	aard_blade_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_1().DestroyAfter(0.00125);
		
	aard_blade_2().BreakAttachment(); 
	aard_blade_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_2().DestroyAfter(0.00125);
		
	aard_blade_3().BreakAttachment(); 
	aard_blade_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_3().DestroyAfter(0.00125);
		
	aard_blade_4().BreakAttachment(); 
	aard_blade_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_4().DestroyAfter(0.00125);
		
	aard_blade_5().BreakAttachment(); 
	aard_blade_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_5().DestroyAfter(0.00125);
		
	aard_blade_6().BreakAttachment(); 
	aard_blade_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_6().DestroyAfter(0.00125);

	aard_blade_7().BreakAttachment(); 
	aard_blade_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_7().DestroyAfter(0.00125);

	aard_blade_8().BreakAttachment(); 
	aard_blade_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_blade_8().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('aard_sword_effect_played');
}
	
function AardSecondarySwordDestroy()
{
	aard_secondary_sword_1().BreakAttachment(); 
	aard_secondary_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_1().DestroyAfter(0.00125);
		
	aard_secondary_sword_2().BreakAttachment(); 
	aard_secondary_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_2().DestroyAfter(0.00125);
		
	aard_secondary_sword_3().BreakAttachment(); 
	aard_secondary_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_3().DestroyAfter(0.00125);
		
	aard_secondary_sword_4().BreakAttachment(); 
	aard_secondary_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_4().DestroyAfter(0.00125);
		
	aard_secondary_sword_5().BreakAttachment(); 
	aard_secondary_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_5().DestroyAfter(0.00125);
		
	aard_secondary_sword_6().BreakAttachment(); 
	aard_secondary_sword_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_6().DestroyAfter(0.00125);

	aard_secondary_sword_7().BreakAttachment(); 
	aard_secondary_sword_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_7().DestroyAfter(0.00125);

	aard_secondary_sword_8().BreakAttachment(); 
	aard_secondary_sword_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('aard_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('aard_secondary_sword_effect_played');
}

function AardSecondarySwordDestroyIMMEDIATE()
{
	aard_secondary_sword_1().Destroy();

	aard_secondary_sword_2().Destroy();

	aard_secondary_sword_3().Destroy();

	aard_secondary_sword_4().Destroy();

	aard_secondary_sword_5().Destroy();

	aard_secondary_sword_6().Destroy();

	aard_secondary_sword_7().Destroy();

	aard_secondary_sword_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('aard_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('aard_secondary_sword_effect_played');
}

function AardSecondarySwordDestroy_NOTAG()
{
	aard_secondary_sword_1().BreakAttachment(); 
	aard_secondary_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_1().DestroyAfter(0.00125);
		
	aard_secondary_sword_2().BreakAttachment(); 
	aard_secondary_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_2().DestroyAfter(0.00125);
		
	aard_secondary_sword_3().BreakAttachment(); 
	aard_secondary_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_3().DestroyAfter(0.00125);
		
	aard_secondary_sword_4().BreakAttachment(); 
	aard_secondary_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_4().DestroyAfter(0.00125);
		
	aard_secondary_sword_5().BreakAttachment(); 
	aard_secondary_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_5().DestroyAfter(0.00125);
		
	aard_secondary_sword_6().BreakAttachment(); 
	aard_secondary_sword_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_6().DestroyAfter(0.00125);

	aard_secondary_sword_7().BreakAttachment(); 
	aard_secondary_sword_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_7().DestroyAfter(0.00125);

	aard_secondary_sword_8().BreakAttachment(); 
	aard_secondary_sword_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_secondary_sword_8().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('aard_secondary_sword_effect_played');
}
	
function YrdenSwordDestroy()
{
	yrden_sword_1().BreakAttachment(); 
	yrden_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_1().DestroyAfter(0.00125);
		
	yrden_sword_2().BreakAttachment(); 
	yrden_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_2().DestroyAfter(0.00125);
		
	yrden_sword_3().BreakAttachment(); 
	yrden_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_3().DestroyAfter(0.00125);
		
	yrden_sword_4().BreakAttachment(); 
	yrden_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_4().DestroyAfter(0.00125);
		
	yrden_sword_5().BreakAttachment(); 
	yrden_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_5().DestroyAfter(0.00125);
		
	yrden_sword_6().BreakAttachment(); 
	yrden_sword_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_6().DestroyAfter(0.00125);

	yrden_sword_7().BreakAttachment(); 
	yrden_sword_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_7().DestroyAfter(0.00125);

	yrden_sword_8().BreakAttachment(); 
	yrden_sword_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('yrden_sword_equipped');

	GetWitcherPlayer().RemoveTag('yrden_sword_effect_played');
}

function YrdenSwordDestroyIMMEDIATE()
{
	yrden_sword_1().Destroy();

	yrden_sword_2().Destroy();

	yrden_sword_3().Destroy();

	yrden_sword_4().Destroy();

	yrden_sword_5().Destroy();

	yrden_sword_6().Destroy();

	yrden_sword_7().Destroy();

	yrden_sword_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('yrden_sword_equipped');

	GetWitcherPlayer().RemoveTag('yrden_sword_effect_played');
}

function YrdenSwordDestroy_NOTAG()
{
	yrden_sword_1().BreakAttachment(); 
	yrden_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_1().DestroyAfter(0.00125);
		
	yrden_sword_2().BreakAttachment(); 
	yrden_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_2().DestroyAfter(0.00125);
		
	yrden_sword_3().BreakAttachment(); 
	yrden_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_3().DestroyAfter(0.00125);
		
	yrden_sword_4().BreakAttachment(); 
	yrden_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_4().DestroyAfter(0.00125);
		
	yrden_sword_5().BreakAttachment(); 
	yrden_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_5().DestroyAfter(0.00125);
		
	yrden_sword_6().BreakAttachment(); 
	yrden_sword_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_6().DestroyAfter(0.00125);

	yrden_sword_7().BreakAttachment(); 
	yrden_sword_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_7().DestroyAfter(0.00125);

	yrden_sword_8().BreakAttachment(); 
	yrden_sword_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_sword_8().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('yrden_sword_effect_played');
}
	
function YrdenSecondarySwordDestroy()
{
	yrden_secondary_sword_1().BreakAttachment(); 
	yrden_secondary_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_1().DestroyAfter(0.00125);
		
	yrden_secondary_sword_2().BreakAttachment(); 
	yrden_secondary_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_2().DestroyAfter(0.00125);
		
	yrden_secondary_sword_3().BreakAttachment(); 
	yrden_secondary_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_3().DestroyAfter(0.00125);
		
	yrden_secondary_sword_4().BreakAttachment(); 
	yrden_secondary_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_4().DestroyAfter(0.00125);
		
	yrden_secondary_sword_5().BreakAttachment(); 
	yrden_secondary_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_5().DestroyAfter(0.00125);
		
	yrden_secondary_sword_6().BreakAttachment(); 
	yrden_secondary_sword_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_6().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('yrden_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('yrden_secondary_sword_effect_played');
}

function YrdenSecondarySwordDestroyIMMEDIATE()
{
	yrden_secondary_sword_1().Destroy();

	yrden_secondary_sword_2().Destroy();

	yrden_secondary_sword_3().Destroy();

	yrden_secondary_sword_4().Destroy();

	yrden_secondary_sword_5().Destroy();

	yrden_secondary_sword_6().Destroy();
		
	GetWitcherPlayer().RemoveTag('yrden_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('yrden_secondary_sword_effect_played');
}

function YrdenSecondarySwordDestroy_NOTAG()
{
	yrden_secondary_sword_1().BreakAttachment(); 
	yrden_secondary_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_1().DestroyAfter(0.00125);
		
	yrden_secondary_sword_2().BreakAttachment(); 
	yrden_secondary_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_2().DestroyAfter(0.00125);
		
	yrden_secondary_sword_3().BreakAttachment(); 
	yrden_secondary_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_3().DestroyAfter(0.00125);
		
	yrden_secondary_sword_4().BreakAttachment(); 
	yrden_secondary_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_4().DestroyAfter(0.00125);
		
	yrden_secondary_sword_5().BreakAttachment(); 
	yrden_secondary_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_5().DestroyAfter(0.00125);
		
	yrden_secondary_sword_6().BreakAttachment(); 
	yrden_secondary_sword_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_secondary_sword_6().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('yrden_secondary_sword_effect_played');
}
	
function AxiiSwordDestroy()
{
	axii_sword_1().BreakAttachment(); 
	axii_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_1().DestroyAfter(0.00125);
		
	axii_sword_2().BreakAttachment(); 
	axii_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_2().DestroyAfter(0.00125);
		
	axii_sword_3().BreakAttachment(); 
	axii_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_3().DestroyAfter(0.00125);
		
	axii_sword_4().BreakAttachment(); 
	axii_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_4().DestroyAfter(0.00125);
		
	axii_sword_5().BreakAttachment(); 
	axii_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_5().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('axii_sword_equipped');

	GetWitcherPlayer().RemoveTag('axii_sword_effect_played');
}

function AxiiSwordDestroyIMMEDIATE()
{
	axii_sword_1().Destroy();

	axii_sword_2().Destroy();

	axii_sword_3().Destroy();

	axii_sword_4().Destroy();

	axii_sword_5().Destroy();
		
	GetWitcherPlayer().RemoveTag('axii_sword_equipped');

	GetWitcherPlayer().RemoveTag('axii_sword_effect_played');
}

function AxiiSwordDestroy_NOTAG()
{
	axii_sword_1().BreakAttachment(); 
	axii_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_1().DestroyAfter(0.00125);
		
	axii_sword_2().BreakAttachment(); 
	axii_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_2().DestroyAfter(0.00125);
		
	axii_sword_3().BreakAttachment(); 
	axii_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_3().DestroyAfter(0.00125);
		
	axii_sword_4().BreakAttachment(); 
	axii_sword_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_4().DestroyAfter(0.00125);
		
	axii_sword_5().BreakAttachment(); 
	axii_sword_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_sword_5().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('axii_sword_effect_played');
}
	
function AxiiSecondarySwordDestroy()
{
	axii_secondary_sword_1().BreakAttachment(); 
	axii_secondary_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_1().DestroyAfter(0.00125);
		
	axii_secondary_sword_2().BreakAttachment(); 
	axii_secondary_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_2().DestroyAfter(0.00125);
		
	axii_secondary_sword_3().BreakAttachment(); 
	axii_secondary_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_3().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('axii_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('axii_secondary_sword_effect_played');
}

function AxiiSecondarySwordDestroyIMMEDIATE()
{
	axii_secondary_sword_1().Destroy();

	axii_secondary_sword_2().Destroy();

	axii_secondary_sword_3().Destroy();
		
	GetWitcherPlayer().RemoveTag('axii_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('axii_secondary_sword_effect_played');
}

function AxiiSecondarySwordDestroy_NOTAG()
{
	axii_secondary_sword_1().BreakAttachment(); 
	axii_secondary_sword_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_1().DestroyAfter(0.00125);
		
	axii_secondary_sword_2().BreakAttachment(); 
	axii_secondary_sword_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_2().DestroyAfter(0.00125);
		
	axii_secondary_sword_3().BreakAttachment(); 
	axii_secondary_sword_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_secondary_sword_3().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('axii_secondary_sword_effect_played');
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function IgniBowDestroy()
{
	igni_bow_1().BreakAttachment(); 
	igni_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_1().DestroyAfter(0.00125);
		
	igni_bow_2().BreakAttachment(); 
	igni_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_2().DestroyAfter(0.00125);
		
	igni_bow_3().BreakAttachment(); 
	igni_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_3().DestroyAfter(0.00125);
		
	igni_bow_4().BreakAttachment(); 
	igni_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_4().DestroyAfter(0.00125);
		
	igni_bow_5().BreakAttachment(); 
	igni_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_5().DestroyAfter(0.00125);
		
	igni_bow_6().BreakAttachment(); 
	igni_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_6().DestroyAfter(0.00125);

	igni_bow_7().BreakAttachment(); 
	igni_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_7().DestroyAfter(0.00125);

	igni_bow_8().BreakAttachment(); 
	igni_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('igni_bow_equipped');

	GetWitcherPlayer().RemoveTag('igni_bow_effect_played');
}

function IgniBowDestroyIMMEDIATE()
{
	igni_bow_1().Destroy();

	igni_bow_2().Destroy();

	igni_bow_3().Destroy();

	igni_bow_4().Destroy();

	igni_bow_5().Destroy();

	igni_bow_6().Destroy();

	igni_bow_7().Destroy();

	igni_bow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('igni_bow_equipped');

	GetWitcherPlayer().RemoveTag('igni_bow_effect_played');
}

function IgniBowDestroy_NOTAG()
{
	igni_bow_1().BreakAttachment(); 
	igni_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_1().DestroyAfter(0.00125);
		
	igni_bow_2().BreakAttachment(); 
	igni_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_2().DestroyAfter(0.00125);
		
	igni_bow_3().BreakAttachment(); 
	igni_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_3().DestroyAfter(0.00125);
		
	igni_bow_4().BreakAttachment(); 
	igni_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_4().DestroyAfter(0.00125);
		
	igni_bow_5().BreakAttachment(); 
	igni_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_5().DestroyAfter(0.00125);
		
	igni_bow_6().BreakAttachment(); 
	igni_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_6().DestroyAfter(0.00125);

	igni_bow_7().BreakAttachment(); 
	igni_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_7().DestroyAfter(0.00125);

	igni_bow_8().BreakAttachment(); 
	igni_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_bow_8().DestroyAfter(0.00125);
}

function AxiiBowDestroy()
{
	axii_bow_1().BreakAttachment(); 
	axii_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_1().DestroyAfter(0.00125);
		
	axii_bow_2().BreakAttachment(); 
	axii_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_2().DestroyAfter(0.00125);
		
	axii_bow_3().BreakAttachment(); 
	axii_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_3().DestroyAfter(0.00125);
		
	axii_bow_4().BreakAttachment(); 
	axii_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_4().DestroyAfter(0.00125);
		
	axii_bow_5().BreakAttachment(); 
	axii_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_5().DestroyAfter(0.00125);
		
	axii_bow_6().BreakAttachment(); 
	axii_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_6().DestroyAfter(0.00125);

	axii_bow_7().BreakAttachment(); 
	axii_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_7().DestroyAfter(0.00125);

	axii_bow_8().BreakAttachment(); 
	axii_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('axii_bow_equipped');

	GetWitcherPlayer().RemoveTag('axii_bow_effect_played');
}

function AxiiBowDestroyIMMEDIATE()
{
	axii_bow_1().Destroy();

	axii_bow_2().Destroy();

	axii_bow_3().Destroy();

	axii_bow_4().Destroy();

	axii_bow_5().Destroy();

	axii_bow_6().Destroy();

	axii_bow_7().Destroy();

	axii_bow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('axii_bow_equipped');

	GetWitcherPlayer().RemoveTag('axii_bow_effect_played');
}

function AxiiBowDestroy_NOTAG()
{
	axii_bow_1().BreakAttachment(); 
	axii_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_1().DestroyAfter(0.00125);
		
	axii_bow_2().BreakAttachment(); 
	axii_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_2().DestroyAfter(0.00125);
		
	axii_bow_3().BreakAttachment(); 
	axii_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_3().DestroyAfter(0.00125);
		
	axii_bow_4().BreakAttachment(); 
	axii_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_4().DestroyAfter(0.00125);
		
	axii_bow_5().BreakAttachment(); 
	axii_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_5().DestroyAfter(0.00125);
		
	axii_bow_6().BreakAttachment(); 
	axii_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_6().DestroyAfter(0.00125);

	axii_bow_7().BreakAttachment(); 
	axii_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_7().DestroyAfter(0.00125);

	axii_bow_8().BreakAttachment(); 
	axii_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_bow_8().DestroyAfter(0.00125);
}

function AardBowDestroy()
{
	aard_bow_1().BreakAttachment(); 
	aard_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_1().DestroyAfter(0.00125);
		
	aard_bow_2().BreakAttachment(); 
	aard_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_2().DestroyAfter(0.00125);
		
	aard_bow_3().BreakAttachment(); 
	aard_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_3().DestroyAfter(0.00125);
		
	aard_bow_4().BreakAttachment(); 
	aard_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_4().DestroyAfter(0.00125);
		
	aard_bow_5().BreakAttachment(); 
	aard_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_5().DestroyAfter(0.00125);
		
	aard_bow_6().BreakAttachment(); 
	aard_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_6().DestroyAfter(0.00125);

	aard_bow_7().BreakAttachment(); 
	aard_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_7().DestroyAfter(0.00125);

	aard_bow_8().BreakAttachment(); 
	aard_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('aard_bow_equipped');

	GetWitcherPlayer().RemoveTag('aard_bow_effect_played');
}

function AardBowDestroyIMMEDIATE()
{
	aard_bow_1().Destroy();

	aard_bow_2().Destroy();

	aard_bow_3().Destroy();

	aard_bow_4().Destroy();
	
	aard_bow_5().Destroy();

	aard_bow_6().Destroy();

	aard_bow_7().Destroy();

	aard_bow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('aard_bow_equipped');

	GetWitcherPlayer().RemoveTag('aard_bow_effect_played');
}

function AardBowDestroy_NOTAG()
{
	aard_bow_1().BreakAttachment(); 
	aard_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_1().DestroyAfter(0.00125);
		
	aard_bow_2().BreakAttachment(); 
	aard_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_2().DestroyAfter(0.00125);
		
	aard_bow_3().BreakAttachment(); 
	aard_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_3().DestroyAfter(0.00125);
		
	aard_bow_4().BreakAttachment(); 
	aard_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_4().DestroyAfter(0.00125);
		
	aard_bow_5().BreakAttachment(); 
	aard_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_5().DestroyAfter(0.00125);
		
	aard_bow_6().BreakAttachment(); 
	aard_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_6().DestroyAfter(0.00125);

	aard_bow_7().BreakAttachment(); 
	aard_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_7().DestroyAfter(0.00125);

	aard_bow_8().BreakAttachment(); 
	aard_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_bow_8().DestroyAfter(0.00125);
}

function YrdenBowDestroy()
{
	yrden_bow_1().BreakAttachment(); 
	yrden_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_1().DestroyAfter(0.00125);
		
	yrden_bow_2().BreakAttachment(); 
	yrden_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_2().DestroyAfter(0.00125);
		
	yrden_bow_3().BreakAttachment(); 
	yrden_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_3().DestroyAfter(0.00125);
		
	yrden_bow_4().BreakAttachment(); 
	yrden_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_4().DestroyAfter(0.00125);
		
	yrden_bow_5().BreakAttachment(); 
	yrden_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_5().DestroyAfter(0.00125);
		
	yrden_bow_6().BreakAttachment(); 
	yrden_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_6().DestroyAfter(0.00125);

	yrden_bow_7().BreakAttachment(); 
	yrden_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_7().DestroyAfter(0.00125);

	yrden_bow_8().BreakAttachment(); 
	yrden_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('yrden_bow_equipped');

	GetWitcherPlayer().RemoveTag('yrden_bow_effect_played');
}

function YrdenBowDestroyIMMEDIATE()
{
	yrden_bow_1().Destroy();

	yrden_bow_2().Destroy();

	yrden_bow_3().Destroy();

	yrden_bow_4().Destroy();

	yrden_bow_5().Destroy();

	yrden_bow_6().Destroy();

	yrden_bow_7().Destroy();

	yrden_bow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('yrden_bow_equipped');

	GetWitcherPlayer().RemoveTag('yrden_bow_effect_played');
}

function YrdenBowDestroy_NOTAG()
{
	yrden_bow_1().BreakAttachment(); 
	yrden_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_1().DestroyAfter(0.00125);
		
	yrden_bow_2().BreakAttachment(); 
	yrden_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_2().DestroyAfter(0.00125);
		
	yrden_bow_3().BreakAttachment(); 
	yrden_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_3().DestroyAfter(0.00125);
		
	yrden_bow_4().BreakAttachment(); 
	yrden_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_4().DestroyAfter(0.00125);
		
	yrden_bow_5().BreakAttachment(); 
	yrden_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_5().DestroyAfter(0.00125);
		
	yrden_bow_6().BreakAttachment(); 
	yrden_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_6().DestroyAfter(0.00125);

	yrden_bow_7().BreakAttachment(); 
	yrden_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_7().DestroyAfter(0.00125);

	yrden_bow_8().BreakAttachment(); 
	yrden_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_bow_8().DestroyAfter(0.00125);
}

function QuenBowDestroy()
{
	quen_bow_1().BreakAttachment(); 
	quen_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_1().DestroyAfter(0.00125);
		
	quen_bow_2().BreakAttachment(); 
	quen_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_2().DestroyAfter(0.00125);
		
	quen_bow_3().BreakAttachment(); 
	quen_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_3().DestroyAfter(0.00125);
		
	quen_bow_4().BreakAttachment(); 
	quen_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_4().DestroyAfter(0.00125);
		
	quen_bow_5().BreakAttachment(); 
	quen_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_5().DestroyAfter(0.00125);
		
	quen_bow_6().BreakAttachment(); 
	quen_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_6().DestroyAfter(0.00125);

	quen_bow_7().BreakAttachment(); 
	quen_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_7().DestroyAfter(0.00125);

	quen_bow_8().BreakAttachment(); 
	quen_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('quen_bow_equipped');

	GetWitcherPlayer().RemoveTag('quen_bow_effect_played');
}

function QuenBowDestroyIMMEDIATE()
{
	quen_bow_1().Destroy();
	
	quen_bow_2().Destroy();
	
	quen_bow_3().Destroy();

	quen_bow_4().Destroy();

	quen_bow_5().Destroy();

	quen_bow_6().Destroy();

	quen_bow_7().Destroy();

	quen_bow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('quen_bow_equipped');

	GetWitcherPlayer().RemoveTag('quen_bow_effect_played');
}

function QuenBowDestroy_NOTAG()
{
	quen_bow_1().BreakAttachment(); 
	quen_bow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_1().DestroyAfter(0.00125);
		
	quen_bow_2().BreakAttachment(); 
	quen_bow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_2().DestroyAfter(0.00125);
		
	quen_bow_3().BreakAttachment(); 
	quen_bow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_3().DestroyAfter(0.00125);
		
	quen_bow_4().BreakAttachment(); 
	quen_bow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_4().DestroyAfter(0.00125);
		
	quen_bow_5().BreakAttachment(); 
	quen_bow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_5().DestroyAfter(0.00125);
		
	quen_bow_6().BreakAttachment(); 
	quen_bow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_6().DestroyAfter(0.00125);

	quen_bow_7().BreakAttachment(); 
	quen_bow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_7().DestroyAfter(0.00125);

	quen_bow_8().BreakAttachment(); 
	quen_bow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_bow_8().DestroyAfter(0.00125);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function IgniCrossbowDestroy()
{
	igni_crossbow_1().BreakAttachment(); 
	igni_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_1().DestroyAfter(0.00125);
		
	igni_crossbow_2().BreakAttachment(); 
	igni_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_2().DestroyAfter(0.00125);
		
	igni_crossbow_3().BreakAttachment(); 
	igni_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_3().DestroyAfter(0.00125);
		
	igni_crossbow_4().BreakAttachment(); 
	igni_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_4().DestroyAfter(0.00125);
		
	igni_crossbow_5().BreakAttachment(); 
	igni_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_5().DestroyAfter(0.00125);
		
	igni_crossbow_6().BreakAttachment(); 
	igni_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_6().DestroyAfter(0.00125);

	igni_crossbow_7().BreakAttachment(); 
	igni_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_7().DestroyAfter(0.00125);

	igni_crossbow_8().BreakAttachment(); 
	igni_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('igni_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('igni_crossbow_effect_played');
}

function IgniCrossbowDestroyIMMEDIATE()
{
	igni_crossbow_1().Destroy();

	igni_crossbow_2().Destroy();

	igni_crossbow_3().Destroy();

	igni_crossbow_4().Destroy();

	igni_crossbow_5().Destroy();

	igni_crossbow_6().Destroy();

	igni_crossbow_7().Destroy();

	igni_crossbow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('igni_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('igni_crossbow_effect_played');
}

function IgniCrossbowDestroy_NOTAG()
{
	igni_crossbow_1().BreakAttachment(); 
	igni_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_1().DestroyAfter(0.00125);
		
	igni_crossbow_2().BreakAttachment(); 
	igni_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_2().DestroyAfter(0.00125);
		
	igni_crossbow_3().BreakAttachment(); 
	igni_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_3().DestroyAfter(0.00125);
		
	igni_crossbow_4().BreakAttachment(); 
	igni_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_4().DestroyAfter(0.00125);
		
	igni_crossbow_5().BreakAttachment(); 
	igni_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_5().DestroyAfter(0.00125);
		
	igni_crossbow_6().BreakAttachment(); 
	igni_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_6().DestroyAfter(0.00125);

	igni_crossbow_7().BreakAttachment(); 
	igni_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_7().DestroyAfter(0.00125);

	igni_crossbow_8().BreakAttachment(); 
	igni_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	igni_crossbow_8().DestroyAfter(0.00125);
}

function AxiiCrossbowDestroy()
{
	axii_crossbow_1().BreakAttachment(); 
	axii_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_1().DestroyAfter(0.00125);
		
	axii_crossbow_2().BreakAttachment(); 
	axii_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_2().DestroyAfter(0.00125);
		
	axii_crossbow_3().BreakAttachment(); 
	axii_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_3().DestroyAfter(0.00125);
		
	axii_crossbow_4().BreakAttachment(); 
	axii_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_4().DestroyAfter(0.00125);
		
	axii_crossbow_5().BreakAttachment(); 
	axii_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_5().DestroyAfter(0.00125);
		
	axii_crossbow_6().BreakAttachment(); 
	axii_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_6().DestroyAfter(0.00125);

	axii_crossbow_7().BreakAttachment(); 
	axii_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_7().DestroyAfter(0.00125);

	axii_crossbow_8().BreakAttachment(); 
	axii_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('axii_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('axii_crossbow_effect_played');
}

function AxiiCrossbowDestroyIMMEDIATE()
{
	axii_crossbow_1().Destroy();
	
	axii_crossbow_2().Destroy();

	axii_crossbow_3().Destroy();

	axii_crossbow_4().Destroy();

	axii_crossbow_5().Destroy();

	axii_crossbow_6().Destroy();

	axii_crossbow_7().Destroy();

	axii_crossbow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('axii_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('axii_crossbow_effect_played');
}

function AxiiCrossbowDestroy_NOTAG()
{
	axii_crossbow_1().BreakAttachment(); 
	axii_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_1().DestroyAfter(0.00125);
		
	axii_crossbow_2().BreakAttachment(); 
	axii_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_2().DestroyAfter(0.00125);
		
	axii_crossbow_3().BreakAttachment(); 
	axii_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_3().DestroyAfter(0.00125);
		
	axii_crossbow_4().BreakAttachment(); 
	axii_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_4().DestroyAfter(0.00125);
		
	axii_crossbow_5().BreakAttachment(); 
	axii_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_5().DestroyAfter(0.00125);
		
	axii_crossbow_6().BreakAttachment(); 
	axii_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_6().DestroyAfter(0.00125);

	axii_crossbow_7().BreakAttachment(); 
	axii_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_7().DestroyAfter(0.00125);

	axii_crossbow_8().BreakAttachment(); 
	axii_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	axii_crossbow_8().DestroyAfter(0.00125);
}

function AardCrossbowDestroy()
{
	aard_crossbow_1().BreakAttachment(); 
	aard_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_1().DestroyAfter(0.00125);
		
	aard_crossbow_2().BreakAttachment(); 
	aard_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_2().DestroyAfter(0.00125);
		
	aard_crossbow_3().BreakAttachment(); 
	aard_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_3().DestroyAfter(0.00125);
		
	aard_crossbow_4().BreakAttachment(); 
	aard_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_4().DestroyAfter(0.00125);
		
	aard_crossbow_5().BreakAttachment(); 
	aard_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_5().DestroyAfter(0.00125);
		
	aard_crossbow_6().BreakAttachment(); 
	aard_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_6().DestroyAfter(0.00125);

	aard_crossbow_7().BreakAttachment(); 
	aard_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_7().DestroyAfter(0.00125);

	aard_crossbow_8().BreakAttachment(); 
	aard_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('aard_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('aard_crossbow_effect_played');
}

function AardCrossbowDestroyIMMEDIATE()
{
	aard_crossbow_1().Destroy();

	aard_crossbow_2().Destroy();

	aard_crossbow_3().Destroy();

	aard_crossbow_4().Destroy();

	aard_crossbow_5().Destroy();

	aard_crossbow_6().Destroy();

	aard_crossbow_7().Destroy();

	aard_crossbow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('aard_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('aard_crossbow_effect_played');
}

function AardCrossbowDestroy_NOTAG()
{
	aard_crossbow_1().BreakAttachment(); 
	aard_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_1().DestroyAfter(0.00125);
		
	aard_crossbow_2().BreakAttachment(); 
	aard_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_2().DestroyAfter(0.00125);
		
	aard_crossbow_3().BreakAttachment(); 
	aard_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_3().DestroyAfter(0.00125);
		
	aard_crossbow_4().BreakAttachment(); 
	aard_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_4().DestroyAfter(0.00125);
		
	aard_crossbow_5().BreakAttachment(); 
	aard_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_5().DestroyAfter(0.00125);
		
	aard_crossbow_6().BreakAttachment(); 
	aard_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_6().DestroyAfter(0.00125);

	aard_crossbow_7().BreakAttachment(); 
	aard_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_7().DestroyAfter(0.00125);

	aard_crossbow_8().BreakAttachment(); 
	aard_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	aard_crossbow_8().DestroyAfter(0.00125);
}

function YrdenCrossbowDestroy()
{
	yrden_crossbow_1().BreakAttachment(); 
	yrden_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_1().DestroyAfter(0.00125);
		
	yrden_crossbow_2().BreakAttachment(); 
	yrden_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_2().DestroyAfter(0.00125);
		
	yrden_crossbow_3().BreakAttachment(); 
	yrden_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_3().DestroyAfter(0.00125);
		
	yrden_crossbow_4().BreakAttachment(); 
	yrden_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_4().DestroyAfter(0.00125);
		
	yrden_crossbow_5().BreakAttachment(); 
	yrden_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_5().DestroyAfter(0.00125);
		
	yrden_crossbow_6().BreakAttachment(); 
	yrden_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_6().DestroyAfter(0.00125);

	yrden_crossbow_7().BreakAttachment(); 
	yrden_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_7().DestroyAfter(0.00125);

	yrden_crossbow_8().BreakAttachment(); 
	yrden_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('yrden_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('yrden_crossbow_effect_played');
}

function YrdenCrossbowDestroyIMMEDIATE()
{
	yrden_crossbow_1().Destroy();

	yrden_crossbow_2().Destroy();

	yrden_crossbow_3().Destroy();

	yrden_crossbow_4().Destroy();

	yrden_crossbow_5().Destroy();
		
	yrden_crossbow_6().Destroy();

	yrden_crossbow_7().Destroy();

	yrden_crossbow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('yrden_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('yrden_crossbow_effect_played');
}

function YrdenCrossbowDestroy_NOTAG()
{
	yrden_crossbow_1().BreakAttachment(); 
	yrden_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_1().DestroyAfter(0.00125);
		
	yrden_crossbow_2().BreakAttachment(); 
	yrden_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_2().DestroyAfter(0.00125);
		
	yrden_crossbow_3().BreakAttachment(); 
	yrden_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_3().DestroyAfter(0.00125);
		
	yrden_crossbow_4().BreakAttachment(); 
	yrden_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_4().DestroyAfter(0.00125);
		
	yrden_crossbow_5().BreakAttachment(); 
	yrden_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_5().DestroyAfter(0.00125);
		
	yrden_crossbow_6().BreakAttachment(); 
	yrden_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_6().DestroyAfter(0.00125);

	yrden_crossbow_7().BreakAttachment(); 
	yrden_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_7().DestroyAfter(0.00125);

	yrden_crossbow_8().BreakAttachment(); 
	yrden_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	yrden_crossbow_8().DestroyAfter(0.00125);
}

function QuenCrossbowDestroy()
{
	quen_crossbow_1().BreakAttachment(); 
	quen_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_1().DestroyAfter(0.00125);
		
	quen_crossbow_2().BreakAttachment(); 
	quen_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_2().DestroyAfter(0.00125);
		
	quen_crossbow_3().BreakAttachment(); 
	quen_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_3().DestroyAfter(0.00125);
		
	quen_crossbow_4().BreakAttachment(); 
	quen_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_4().DestroyAfter(0.00125);
		
	quen_crossbow_5().BreakAttachment(); 
	quen_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_5().DestroyAfter(0.00125);
		
	quen_crossbow_6().BreakAttachment(); 
	quen_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_6().DestroyAfter(0.00125);

	quen_crossbow_7().BreakAttachment(); 
	quen_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_7().DestroyAfter(0.00125);

	quen_crossbow_8().BreakAttachment(); 
	quen_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_8().DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('quen_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('quen_crossbow_effect_played');
}

function QuenCrossbowDestroyIMMEDIATE()
{
	quen_crossbow_1().Destroy();

	quen_crossbow_2().Destroy();

	quen_crossbow_3().Destroy();

	quen_crossbow_4().Destroy();

	quen_crossbow_5().Destroy();

	quen_crossbow_6().Destroy();

	quen_crossbow_7().Destroy();

	quen_crossbow_8().Destroy();
		
	GetWitcherPlayer().RemoveTag('quen_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('quen_crossbow_effect_played');
}

function QuenCrossbowDestroy_NOTAG()
{
	quen_crossbow_1().BreakAttachment(); 
	quen_crossbow_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_1().DestroyAfter(0.00125);
		
	quen_crossbow_2().BreakAttachment(); 
	quen_crossbow_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_2().DestroyAfter(0.00125);
		
	quen_crossbow_3().BreakAttachment(); 
	quen_crossbow_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_3().DestroyAfter(0.00125);
		
	quen_crossbow_4().BreakAttachment(); 
	quen_crossbow_4().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_4().DestroyAfter(0.00125);
		
	quen_crossbow_5().BreakAttachment(); 
	quen_crossbow_5().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_5().DestroyAfter(0.00125);
		
	quen_crossbow_6().BreakAttachment(); 
	quen_crossbow_6().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_6().DestroyAfter(0.00125);

	quen_crossbow_7().BreakAttachment(); 
	quen_crossbow_7().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_7().DestroyAfter(0.00125);

	quen_crossbow_8().BreakAttachment(); 
	quen_crossbow_8().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	quen_crossbow_8().DestroyAfter(0.00125);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function HybridTagRemoval()
{
	if (GetWitcherPlayer().HasTag('HybridDefaultWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridDefaultWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridDefaultSecondaryWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridDefaultSecondaryWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridEredinWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridEredinWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridClawWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridClawWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridImlerithWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridImlerithWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridOlgierdWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridOlgierdWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridSpearWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridSpearWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridGregWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridGregWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridAxeWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridAxeWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('HybridGiantWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('HybridGiantWeaponTicket');
	}
}