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

	if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
	{
		GetACSWatcher().ClawDestroy();
	}

	if (GetWitcherPlayer().HasTag('acs_sorc_fists_equipped'))
	{
		GetACSWatcher().SorcFistDestroy();
	}

	ACS_IgniSwordDestroy();
	ACS_QuenSwordDestroy();
	ACS_AardSwordDestroy();
	ACS_YrdenSwordDestroy();
	ACS_AxiiSwordDestroy();	
	ACS_IgniSecondarySwordDestroy();
	ACS_QuenSecondarySwordDestroy();
	ACS_AardSecondarySwordDestroy();
	ACS_YrdenSecondarySwordDestroy();
	ACS_AxiiSecondarySwordDestroy();

	ACS_IgniBowDestroy();
	ACS_AxiiBowDestroy();
	ACS_AardBowDestroy();
	ACS_YrdenBowDestroy();
	ACS_QuenBowDestroy();

	ACS_IgniCrossbowDestroy();
	ACS_AxiiCrossbowDestroy();
	ACS_AardCrossbowDestroy();
	ACS_YrdenCrossbowDestroy();
	ACS_QuenCrossbowDestroy();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');
	ACS_Yrden_Sidearm_Destroy();

	ACSGetCEntity('ACS_Bow_Arrow').Destroy();

	ACS_Crossbow_Arrow().BreakAttachment();
	ACS_Crossbow_Arrow().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
	ACS_Crossbow_Arrow().DestroyAfter(0.125);
	ACS_Crossbow_Arrow().RemoveTag('ACS_Crossbow_Arrow');

	ACSGetCEntity('acs_sword_trail_1').Destroy();
	ACSGetCEntity('acs_sword_trail_2').Destroy();
	ACSGetCEntity('acs_sword_trail_3').Destroy();
	ACSGetCEntity('acs_sword_trail_4').Destroy();
	ACSGetCEntity('acs_sword_trail_5').Destroy();
	ACSGetCEntity('acs_sword_trail_6').Destroy();
	ACSGetCEntity('acs_sword_trail_7').Destroy();
	ACSGetCEntity('acs_sword_trail_8').Destroy();

	ACSGetCEntity('ACS_Frost_Sword_Ent').Destroy();
	ACSGetCEntity('ACS_Fire_Sword_Ent').Destroy();

	if (ACSGetCEntity('ACS_Armor_Ether_Sword'))
	{
		ACSGetCEntity('ACS_Armor_Ether_Sword').Destroy();

		//thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
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

	if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
	{
		GetACSWatcher().ClawDestroy();
	}

	if (GetWitcherPlayer().HasTag('acs_sorc_fists_equipped'))
	{
		GetACSWatcher().SorcFistDestroy();
	}

	ACS_IgniSwordDestroy();
	ACS_QuenSwordDestroyIMMEDIATE();
	ACS_AardSwordDestroyIMMEDIATE();
	ACS_YrdenSwordDestroyIMMEDIATE();
	ACS_AxiiSwordDestroyIMMEDIATE();	
	ACS_IgniSecondarySwordDestroy();
	ACS_QuenSecondarySwordDestroyIMMEDIATE();
	ACS_AardSecondarySwordDestroyIMMEDIATE();
	ACS_YrdenSecondarySwordDestroyIMMEDIATE();
	ACS_AxiiSecondarySwordDestroyIMMEDIATE();

	ACS_IgniBowDestroyIMMEDIATE();
	ACS_AxiiBowDestroyIMMEDIATE();
	ACS_AardBowDestroyIMMEDIATE();
	ACS_YrdenBowDestroyIMMEDIATE();
	ACS_QuenBowDestroyIMMEDIATE();

	ACS_IgniCrossbowDestroyIMMEDIATE();
	ACS_AxiiCrossbowDestroyIMMEDIATE();
	ACS_AardCrossbowDestroyIMMEDIATE();
	ACS_YrdenCrossbowDestroyIMMEDIATE()();
	ACS_QuenCrossbowDestroyIMMEDIATE()();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');
	ACS_Yrden_Sidearm_DestroyIMMEDIATE();

	ACSGetCEntity('ACS_Bow_Arrow').Destroy();

	ACS_Crossbow_Arrow().BreakAttachment();
	ACS_Crossbow_Arrow().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
	ACS_Crossbow_Arrow().DestroyAfter(0.125);
	ACS_Crossbow_Arrow().RemoveTag('ACS_Crossbow_Arrow');

	ACSGetCEntity('acs_sword_trail_1').Destroy();
	ACSGetCEntity('acs_sword_trail_2').Destroy();
	ACSGetCEntity('acs_sword_trail_3').Destroy();
	ACSGetCEntity('acs_sword_trail_4').Destroy();
	ACSGetCEntity('acs_sword_trail_5').Destroy();
	ACSGetCEntity('acs_sword_trail_6').Destroy();
	ACSGetCEntity('acs_sword_trail_7').Destroy();
	ACSGetCEntity('acs_sword_trail_8').Destroy();

	ACSGetCEntity('ACS_Frost_Sword_Ent').Destroy();
	ACSGetCEntity('ACS_Fire_Sword_Ent').Destroy();

	if (ACSGetCEntity('ACS_Armor_Ether_Sword'))
	{
		ACSGetCEntity('ACS_Armor_Ether_Sword').Destroy();

		//thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
	}
}

function ACS_WeaponDestroyInit_WITHOUT_HIDESWORD()
{
	if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
	{
		GetACSWatcher().ClawDestroy();
	}

	if (GetWitcherPlayer().HasTag('acs_sorc_fists_equipped'))
	{
		GetACSWatcher().SorcFistDestroy();
	}
	
	ACS_IgniSwordDestroy();
	ACS_QuenSwordDestroy();
	ACS_AardSwordDestroy();
	ACS_YrdenSwordDestroy();
	ACS_AxiiSwordDestroy();	
	ACS_IgniSecondarySwordDestroy();
	ACS_QuenSecondarySwordDestroy();
	ACS_AardSecondarySwordDestroy();
	ACS_YrdenSecondarySwordDestroy();
	ACS_AxiiSecondarySwordDestroy();

	ACS_IgniBowDestroy();
	ACS_AxiiBowDestroy();
	ACS_AardBowDestroy();
	ACS_YrdenBowDestroy();
	ACS_QuenBowDestroy();

	ACS_IgniCrossbowDestroy();
	ACS_AxiiCrossbowDestroy();
	ACS_AardCrossbowDestroy();
	ACS_YrdenCrossbowDestroy();
	ACS_QuenCrossbowDestroy();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');
	ACS_Yrden_Sidearm_Destroy();

	ACSGetCEntity('acs_sword_trail_1').Destroy();
	ACSGetCEntity('acs_sword_trail_2').Destroy();
	ACSGetCEntity('acs_sword_trail_3').Destroy();
	ACSGetCEntity('acs_sword_trail_4').Destroy();
	ACSGetCEntity('acs_sword_trail_5').Destroy();
	ACSGetCEntity('acs_sword_trail_6').Destroy();
	ACSGetCEntity('acs_sword_trail_7').Destroy();
	ACSGetCEntity('acs_sword_trail_8').Destroy();

	ACSGetCEntity('ACS_Frost_Sword_Ent').Destroy();
	ACSGetCEntity('ACS_Fire_Sword_Ent').Destroy();

	if (ACSGetCEntity('ACS_Armor_Ether_Sword'))
	{
		ACSGetCEntity('ACS_Armor_Ether_Sword').Destroy();

		//thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
	}
}

function ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE()
{
	if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
	{
		GetACSWatcher().ClawDestroy();
	}

	if (GetWitcherPlayer().HasTag('acs_sorc_fists_equipped'))
	{
		GetACSWatcher().SorcFistDestroy();
	}
	
	ACS_IgniSwordDestroy();
	ACS_QuenSwordDestroyIMMEDIATE();
	ACS_AardSwordDestroyIMMEDIATE();
	ACS_YrdenSwordDestroyIMMEDIATE();
	ACS_AxiiSwordDestroyIMMEDIATE();	
	ACS_IgniSecondarySwordDestroy();
	ACS_QuenSecondarySwordDestroyIMMEDIATE();
	ACS_AardSecondarySwordDestroyIMMEDIATE();
	ACS_YrdenSecondarySwordDestroyIMMEDIATE();
	ACS_AxiiSecondarySwordDestroyIMMEDIATE();

	ACS_IgniBowDestroyIMMEDIATE();
	ACS_AxiiBowDestroyIMMEDIATE();
	ACS_AardBowDestroyIMMEDIATE();
	ACS_YrdenBowDestroyIMMEDIATE();
	ACS_QuenBowDestroyIMMEDIATE();

	ACS_IgniCrossbowDestroyIMMEDIATE();
	ACS_AxiiCrossbowDestroyIMMEDIATE();
	ACS_AardCrossbowDestroyIMMEDIATE();
	ACS_YrdenCrossbowDestroyIMMEDIATE()();
	ACS_QuenCrossbowDestroyIMMEDIATE()();

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');
	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');
	ACS_Yrden_Sidearm_DestroyIMMEDIATE();

	ACSGetCEntity('acs_sword_trail_1').Destroy();
	ACSGetCEntity('acs_sword_trail_2').Destroy();
	ACSGetCEntity('acs_sword_trail_3').Destroy();
	ACSGetCEntity('acs_sword_trail_4').Destroy();
	ACSGetCEntity('acs_sword_trail_5').Destroy();
	ACSGetCEntity('acs_sword_trail_6').Destroy();
	ACSGetCEntity('acs_sword_trail_7').Destroy();
	ACSGetCEntity('acs_sword_trail_8').Destroy();

	ACSGetCEntity('ACS_Frost_Sword_Ent').Destroy();
	ACSGetCEntity('ACS_Fire_Sword_Ent').Destroy();

	if (ACSGetCEntity('ACS_Armor_Ether_Sword'))
	{
		ACSGetCEntity('ACS_Armor_Ether_Sword').Destroy();

		//thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
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
			&& !GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') 
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
			if (!GetWitcherPlayer().HasTag('acs_blood_sucking'))
			{
				if (!GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
				{
					acs_igni_sword_summon();
				}
			}
		}

		GetWitcherPlayer().AddTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}

	//ACS_StopAerondightEffectInit();

	if (GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
	{
		acs_quen_sword_summon();
		ACS_QuenSwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
	{
		acs_axii_sword_summon();
		ACS_AxiiSwordDestroy_NOTAG();	
	}
	else if (GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
	{
		acs_aard_sword_summon();
		ACS_AardSwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
	{
		acs_yrden_sword_summon();
		ACS_YrdenSwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
	{
		acs_quen_secondary_sword_summon();
		ACS_QuenSecondarySwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
	{
		acs_axii_secondary_sword_summon();
		ACS_AxiiSecondarySwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
	{
		acs_aard_secondary_sword_summon();
		ACS_AardSecondarySwordDestroy_NOTAG();
	}
	else if (GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
	{
		acs_yrden_secondary_sword_summon();
		ACS_YrdenSecondarySwordDestroy_NOTAG();
	}

	if (ACSGetCEntity('ACS_Armor_Ether_Sword'))
	{
		ACSGetCEntity('ACS_Armor_Ether_Sword').Destroy();

		//thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_stop");
	}
	
	ACSGetCEntity('acs_sword_trail_1').StopAllEffects();

	ACSGetCEntity('acs_sword_trail_2').StopAllEffects();
	
	ACSGetCEntity('acs_sword_trail_3').StopAllEffects();

	ACSGetCEntity('acs_sword_trail_4').StopAllEffects();

	ACSGetCEntity('acs_sword_trail_5').StopAllEffects();

	ACSGetCEntity('acs_sword_trail_6').StopAllEffects();

	ACSGetCEntity('acs_sword_trail_7').StopAllEffects();

	ACSGetCEntity('acs_sword_trail_8').StopAllEffects();
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

	GetWitcherPlayer().RemoveTag('acs_igni_sword_effect_played');

	GetWitcherPlayer().RemoveTag('acs_igni_secondary_sword_effect_played');
}

function ACS_ShowSwordWitoutScabbardStuff()
{
	var steelID, silverID 													: SItemUniqueId;
	var steelsword, silversword, scabbard_steel, scabbard_silver			: CDrawableComponent;
	var scabbards_steel, scabbards_silver 									: array<SItemUniqueId>;
	var i 																	: int;
	var steelswordentity, silverswordentity 								: CEntity;

	ACSGetCEntity('ACS_Bow_Arrow').Destroy();
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

	GetWitcherPlayer().RemoveTag('acs_igni_sword_effect_played');

	GetWitcherPlayer().RemoveTag('acs_igni_secondary_sword_effect_played');
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
		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = GetWitcherPlayer();
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
			
			if (ACS_Armor_Equipped_Check())
			{
				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws_blood.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
			}
			else
			{
				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				if (!ACS_HideVampireClaws_Enabled())
				{
					if (ACS_GetItem_VampClaw_Blood())
					{
						claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

						((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

						claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws_blood.w2ent", true);	

						((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
					}
					else
					{
						claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws_blood.w2ent", true);	

						((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);
						
						claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

						((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
					}
				}
			}
		}
	}
}

statemachine class cACSClawDestroy
{
    function ClawDestroy_Engage()
	{
		this.PushState('ClawDestroy_Engage');
	}

	function ClawDestroy_NOTAG_Engage()
	{
		this.PushState('ClawDestroy_NOTAG_Engage');
	}

	function ClawDestroy_WITH_EFFECT_Engage()
	{
		this.PushState('ClawDestroy_WITH_EFFECT_Engage');
	}

	function SorcFistDestroy_Engage()
	{
		this.PushState('SorcFistDestroy_Engage');
	}
}

state ClawDestroy_Engage in cACSClawDestroy
{
	private var claw_temp								: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;
	private var stupidArray 							: array< name >;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}

	entry function ClawDestroy_Entry()
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
			if (!ACS_HideVampireClaws_Enabled())
			{
				thePlayer.PlayEffectSingle('claws_effect');
				thePlayer.StopEffect('claws_effect');
			}

			p_actor = GetWitcherPlayer();
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );
				
			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws_blood.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);
		}
			
		GetWitcherPlayer().RemoveTag('acs_vampire_claws_equipped');	
			
		GetWitcherPlayer().RemoveTag('ACS_blood_armor');

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			stupidArray.Clear();

			if (ACS_SCAAR_Installed() )
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else if (ACS_E3ARP_Installed() )
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
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
							stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							stupidArray.PushBack( 'igni_primary_beh' );
						}
					}
				}
			}

			//Sleep(0.5);

			if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0 );
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				//thePlayer.ActivateAndSyncBehaviors(stupidArray);
			}
		}
	}
}

state ClawDestroy_NOTAG_Engage in cACSClawDestroy
{
	private var claw_temp					: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_NoTag_Entry();
	}
	
	entry function ClawDestroy_NoTag_Entry()
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

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws_blood.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			//GetWitcherPlayer().PlayEffectSingle('claws_effect');
			//GetWitcherPlayer().StopEffect('claws_effect');
		}
	}
}

state ClawDestroy_WITH_EFFECT_Engage in cACSClawDestroy
{
	private var claw_temp								: CEntityTemplate;
	private var p_actor 								: CActor;
	private var p_comp 									: CComponent;
	private var components 								: array < CComponent >;
	private var drawableComponent 						: CDrawableComponent;
	private var i										: int;
	private var stupidArray 							: array< name >;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_WithEffect_Entry();
	}
	
	entry function ClawDestroy_WithEffect_Entry()
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
			p_actor = GetWitcherPlayer();
			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws_blood.w2ent", true);	

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

			if (!ACS_HideVampireClaws_Enabled())
			{
				thePlayer.PlayEffectSingle('claws_effect');
				thePlayer.StopEffect('claws_effect');
			}
		}
			
		GetWitcherPlayer().RemoveTag('acs_vampire_claws_equipped');	

		GetWitcherPlayer().RemoveTag('ACS_blood_armor');

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsInCombat()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			stupidArray.Clear();

			if (ACS_SCAAR_Installed() )
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else if (ACS_E3ARP_Installed() )
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
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
							stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							stupidArray.PushBack( 'igni_primary_beh' );
						}
					}
				}
			}

			//Sleep(0.5);

			if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0 );
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				//thePlayer.ActivateAndSyncBehaviors(stupidArray);
			}
		}
	}
}

state SorcFistDestroy_Engage in cACSClawDestroy
{
	private var stupidArray 							: array< name >;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		SorcFistDestroy_Entry();
	}
	
	entry function SorcFistDestroy_Entry()
	{
		GetWitcherPlayer().RemoveTag('acs_sorc_fists_equipped');	

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			stupidArray.Clear();

			if (ACS_SCAAR_Installed() )
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else if (ACS_E3ARP_Installed() )
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
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
							stupidArray.PushBack( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							stupidArray.PushBack( 'igni_primary_beh_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							stupidArray.PushBack( 'igni_primary_beh' );
						}
					}
				}
			}

			Sleep(0.5);

			if (stupidArray.Size() > 0)
			{
				thePlayer.ActivateAndSyncBehaviors(stupidArray);
			}
		}
	}
}

function ACS_Blood_Armor_Destroy()
{
	thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP_Stop" );

	ACSGetCEntity('acs_vampire_extra_arms_1').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_2').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_3').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_4').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_head').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_1').BreakAttachment(); 
	ACSGetCEntity('acs_vampire_extra_arms_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_vampire_extra_arms_1').DestroyAfter(0.00125);

	ACSGetCEntity('acs_vampire_extra_arms_2').BreakAttachment(); 
	ACSGetCEntity('acs_vampire_extra_arms_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_vampire_extra_arms_2').DestroyAfter(0.00125);

	ACSGetCEntity('acs_vampire_extra_arms_3').BreakAttachment(); 
	ACSGetCEntity('acs_vampire_extra_arms_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_vampire_extra_arms_3').DestroyAfter(0.00125);

	ACSGetCEntity('acs_vampire_extra_arms_4').BreakAttachment(); 
	ACSGetCEntity('acs_vampire_extra_arms_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_vampire_extra_arms_4').DestroyAfter(0.00125);

	ACSGetCEntity('acs_extra_arms_anchor_l').BreakAttachment(); 
	ACSGetCEntity('acs_extra_arms_anchor_l').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_extra_arms_anchor_l').DestroyAfter(0.00125);

	ACSGetCEntity('acs_extra_arms_anchor_r').BreakAttachment(); 
	ACSGetCEntity('acs_extra_arms_anchor_r').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_extra_arms_anchor_r').DestroyAfter(0.00125);

	ACSGetCEntity('acs_vampire_head_anchor').BreakAttachment(); 
	ACSGetCEntity('acs_vampire_head_anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_vampire_head_anchor').DestroyAfter(0.00125);

	ACSGetCEntity('acs_vampire_head').BreakAttachment(); 
	ACSGetCEntity('acs_vampire_head').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_vampire_head').DestroyAfter(0.00125);

	ACSGetCEntity('acs_vampire_back_claw').BreakAttachment(); 
	ACSGetCEntity('acs_vampire_back_claw').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_vampire_back_claw').DestroyAfter(0.00125);

	ACSGetCEntity('acs_vampire_claw_anchor').BreakAttachment(); 
	ACSGetCEntity('acs_vampire_claw_anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_vampire_claw_anchor').DestroyAfter(0.00125);
}

function ACS_Blood_Armor_Destroy_IMMEDIATE()
{
	ACS_Blood_Armor_Destroy_Without_Back_Claw_IMMEDIATE();

	ACSGetCEntity('acs_vampire_back_claw').Destroy();

	ACSGetCEntity('acs_vampire_claw_anchor').Destroy();
}

function ACS_Blood_Armor_Destroy_Without_Back_Claw_IMMEDIATE()
{
	thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP_Stop" );

	thePlayer.DestroyEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_1').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_2').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_3').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_4').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_head').StopEffect('blood_color');

	ACSGetCEntity('acs_vampire_extra_arms_1').Destroy();

	ACSGetCEntity('acs_vampire_extra_arms_2').Destroy();

	ACSGetCEntity('acs_vampire_extra_arms_3').Destroy();

	ACSGetCEntity('acs_vampire_extra_arms_4').Destroy();

	ACSGetCEntity('acs_extra_arms_anchor_l').Destroy();

	ACSGetCEntity('acs_extra_arms_anchor_r').Destroy();

	ACSGetCEntity('acs_vampire_head_anchor').Destroy();

	ACSGetCEntity('acs_vampire_head').Destroy();
}

////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_IgniSwordDestroy()
{
	//ACS_HideSword();
		
	GetWitcherPlayer().RemoveTag('acs_igni_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_igni_sword_equipped_TAG');

	GetWitcherPlayer().RemoveTag('acs_igni_sword_effect_played');
}
	
function ACS_IgniSecondarySwordDestroy()
{
	//ACS_HideSword();
		
	GetWitcherPlayer().RemoveTag('acs_igni_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_igni_secondary_sword_equipped_TAG');

	GetWitcherPlayer().RemoveTag('acs_igni_secondary_sword_effect_played');
}
	
function ACS_QuenSwordDestroy()
{
	ACSGetCEntity('acs_quen_sword_1').BreakAttachment();
	ACSGetCEntity('acs_quen_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_sword_1').DestroyAfter(0.00125);

	ACSGetCEntity('acs_quen_sword_2').BreakAttachment();
	ACSGetCEntity('acs_quen_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_sword_2').DestroyAfter(0.00125);

	ACSGetCEntity('acs_quen_sword_3').BreakAttachment();
	ACSGetCEntity('acs_quen_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_sword_3').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_quen_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_quen_sword_effect_played');
}

function ACS_QuenSwordDestroyIMMEDIATE()
{
	ACSGetCEntity('acs_quen_sword_1').Destroy();

	ACSGetCEntity('acs_quen_sword_2').Destroy();

	ACSGetCEntity('acs_quen_sword_3').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_quen_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_quen_sword_effect_played');
}

function ACS_QuenSwordDestroy_NOTAG()
{
	ACSGetCEntity('acs_quen_sword_1').BreakAttachment();
	ACSGetCEntity('acs_quen_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_sword_1').DestroyAfter(0.00125);

	ACSGetCEntity('acs_quen_sword_2').BreakAttachment();
	ACSGetCEntity('acs_quen_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_sword_2').DestroyAfter(0.00125);

	ACSGetCEntity('acs_quen_sword_3').BreakAttachment();
	ACSGetCEntity('acs_quen_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_sword_3').DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('acs_quen_sword_effect_played');
}
	
function ACS_QuenSecondarySwordDestroy()
{	
	ACSGetCEntity('acs_quen_secondary_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_6').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_6').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_effect_played');
}

function ACS_QuenSecondarySwordDestroyIMMEDIATE()
{	
	ACSGetCEntity('acs_quen_secondary_sword_1').Destroy();

	ACSGetCEntity('acs_quen_secondary_sword_2').Destroy();

	ACSGetCEntity('acs_quen_secondary_sword_3').Destroy();

	ACSGetCEntity('acs_quen_secondary_sword_4').Destroy();

	ACSGetCEntity('acs_quen_secondary_sword_5').Destroy();

	ACSGetCEntity('acs_quen_secondary_sword_6').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_effect_played');
}

function ACS_QuenSecondarySwordDestroy_NOTAG()
{	
	ACSGetCEntity('acs_quen_secondary_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_quen_secondary_sword_6').BreakAttachment(); 
	ACSGetCEntity('acs_quen_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_quen_secondary_sword_6').DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_effect_played');
}
	
function ACS_AardSwordDestroy()
{	
	ACSGetCEntity('l_hand_anchor_1').BreakAttachment(); 
	ACSGetCEntity('l_hand_anchor_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('l_hand_anchor_1').DestroyAfter(0.00125);

	ACSGetCEntity('r_hand_anchor_1').BreakAttachment(); 
	ACSGetCEntity('r_hand_anchor_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('r_hand_anchor_1').DestroyAfter(0.00125);

	ACSGetCEntity('aard_blade_1').BreakAttachment(); 
	ACSGetCEntity('aard_blade_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_2').BreakAttachment(); 
	ACSGetCEntity('aard_blade_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_3').BreakAttachment(); 
	ACSGetCEntity('aard_blade_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_4').BreakAttachment(); 
	ACSGetCEntity('aard_blade_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_5').BreakAttachment(); 
	ACSGetCEntity('aard_blade_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_6').BreakAttachment(); 
	ACSGetCEntity('aard_blade_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_6').DestroyAfter(0.00125);

	ACSGetCEntity('aard_blade_7').BreakAttachment(); 
	ACSGetCEntity('aard_blade_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_7').DestroyAfter(0.00125);

	ACSGetCEntity('aard_blade_8').BreakAttachment(); 
	ACSGetCEntity('aard_blade_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_aard_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_aard_sword_effect_played');
}

function ACS_AardSwordDestroyIMMEDIATE()
{	
	ACSGetCEntity('l_hand_anchor_1').Destroy();

	ACSGetCEntity('r_hand_anchor_1').Destroy();

	ACSGetCEntity('aard_blade_1').Destroy();
		
	ACSGetCEntity('aard_blade_2').Destroy();

	ACSGetCEntity('aard_blade_3').Destroy();

	ACSGetCEntity('aard_blade_4').Destroy();

	ACSGetCEntity('aard_blade_5').Destroy();

	ACSGetCEntity('aard_blade_6').Destroy();

	ACSGetCEntity('aard_blade_7').Destroy();

	ACSGetCEntity('aard_blade_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_aard_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_aard_sword_effect_played');
}

function ACS_AardSwordDestroy_NOTAG()
{	
	ACSGetCEntity('l_hand_anchor_1').BreakAttachment(); 
	ACSGetCEntity('l_hand_anchor_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('l_hand_anchor_1').DestroyAfter(0.00125);

	ACSGetCEntity('r_hand_anchor_1').BreakAttachment(); 
	ACSGetCEntity('r_hand_anchor_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('r_hand_anchor_1').DestroyAfter(0.00125);

	ACSGetCEntity('aard_blade_1').BreakAttachment(); 
	ACSGetCEntity('aard_blade_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_2').BreakAttachment(); 
	ACSGetCEntity('aard_blade_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_3').BreakAttachment(); 
	ACSGetCEntity('aard_blade_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_4').BreakAttachment(); 
	ACSGetCEntity('aard_blade_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_5').BreakAttachment(); 
	ACSGetCEntity('aard_blade_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_blade_6').BreakAttachment(); 
	ACSGetCEntity('aard_blade_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_6').DestroyAfter(0.00125);

	ACSGetCEntity('aard_blade_7').BreakAttachment(); 
	ACSGetCEntity('aard_blade_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_7').DestroyAfter(0.00125);

	ACSGetCEntity('aard_blade_8').BreakAttachment(); 
	ACSGetCEntity('aard_blade_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_blade_8').DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('acs_aard_sword_effect_played');
}
	
function ACS_AardSecondarySwordDestroy()
{
	ACSGetCEntity('acs_aard_secondary_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_6').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_6').DestroyAfter(0.00125);

	ACSGetCEntity('acs_aard_secondary_sword_7').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_7').DestroyAfter(0.00125);

	ACSGetCEntity('acs_aard_secondary_sword_8').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_effect_played');
}

function ACS_AardSecondarySwordDestroyIMMEDIATE()
{
	ACSGetCEntity('acs_aard_secondary_sword_1').Destroy();

	ACSGetCEntity('acs_aard_secondary_sword_2').Destroy();

	ACSGetCEntity('acs_aard_secondary_sword_3').Destroy();

	ACSGetCEntity('acs_aard_secondary_sword_4').Destroy();

	ACSGetCEntity('acs_aard_secondary_sword_5').Destroy();

	ACSGetCEntity('acs_aard_secondary_sword_6').Destroy();

	ACSGetCEntity('acs_aard_secondary_sword_7').Destroy();

	ACSGetCEntity('acs_aard_secondary_sword_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_effect_played');
}

function ACS_AardSecondarySwordDestroy_NOTAG()
{
	ACSGetCEntity('acs_aard_secondary_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_aard_secondary_sword_6').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_6').DestroyAfter(0.00125);

	ACSGetCEntity('acs_aard_secondary_sword_7').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_7').DestroyAfter(0.00125);

	ACSGetCEntity('acs_aard_secondary_sword_8').BreakAttachment(); 
	ACSGetCEntity('acs_aard_secondary_sword_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_aard_secondary_sword_8').DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_effect_played');
}
	
function ACS_YrdenSwordDestroy()
{
	ACSGetCEntity('acs_yrden_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_6').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_6').DestroyAfter(0.00125);

	ACSGetCEntity('acs_yrden_sword_7').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_7').DestroyAfter(0.00125);

	ACSGetCEntity('acs_yrden_sword_8').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_yrden_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_yrden_sword_effect_played');
}

function ACS_YrdenSwordDestroyIMMEDIATE()
{
	ACSGetCEntity('acs_yrden_sword_1').Destroy();

	ACSGetCEntity('acs_yrden_sword_2').Destroy();

	ACSGetCEntity('acs_yrden_sword_3').Destroy();

	ACSGetCEntity('acs_yrden_sword_4').Destroy();

	ACSGetCEntity('acs_yrden_sword_5').Destroy();

	ACSGetCEntity('acs_yrden_sword_6').Destroy();

	ACSGetCEntity('acs_yrden_sword_7').Destroy();

	ACSGetCEntity('acs_yrden_sword_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_yrden_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_yrden_sword_effect_played');
}

function ACS_YrdenSwordDestroy_NOTAG()
{
	ACSGetCEntity('acs_yrden_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_sword_6').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_6').DestroyAfter(0.00125);

	ACSGetCEntity('acs_yrden_sword_7').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_7').DestroyAfter(0.00125);

	ACSGetCEntity('acs_yrden_sword_8').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_sword_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_sword_8').DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('acs_yrden_sword_effect_played');
}
	
function ACS_YrdenSecondarySwordDestroy()
{
	ACSGetCEntity('acs_yrden_secondary_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_6').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_6').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_effect_played');
}

function ACS_YrdenSecondarySwordDestroyIMMEDIATE()
{
	ACSGetCEntity('acs_yrden_secondary_sword_1').Destroy();

	ACSGetCEntity('acs_yrden_secondary_sword_2').Destroy();

	ACSGetCEntity('acs_yrden_secondary_sword_3').Destroy();

	ACSGetCEntity('acs_yrden_secondary_sword_4').Destroy();

	ACSGetCEntity('acs_yrden_secondary_sword_5').Destroy();

	ACSGetCEntity('acs_yrden_secondary_sword_6').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_effect_played');
}

function ACS_YrdenSecondarySwordDestroy_NOTAG()
{
	ACSGetCEntity('acs_yrden_secondary_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_yrden_secondary_sword_6').BreakAttachment(); 
	ACSGetCEntity('acs_yrden_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_yrden_secondary_sword_6').DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_effect_played');
}
	
function ACS_AxiiSwordDestroy()
{
	ACSGetCEntity('acs_axii_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_5').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_axii_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_axii_sword_effect_played');
}

function ACS_AxiiSwordDestroyIMMEDIATE()
{
	ACSGetCEntity('acs_axii_sword_1').Destroy();

	ACSGetCEntity('acs_axii_sword_2').Destroy();

	ACSGetCEntity('acs_axii_sword_3').Destroy();

	ACSGetCEntity('acs_axii_sword_4').Destroy();

	ACSGetCEntity('acs_axii_sword_5').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_axii_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_axii_sword_effect_played');
}

function ACS_AxiiSwordDestroy_NOTAG()
{
	ACSGetCEntity('acs_axii_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_sword_4').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_sword_5').BreakAttachment(); 
	ACSGetCEntity('acs_axii_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_sword_5').DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('acs_axii_sword_effect_played');
}
	
function ACS_AxiiSecondarySwordDestroy()
{
	ACSGetCEntity('acs_axii_secondary_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_axii_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_secondary_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_secondary_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_axii_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_secondary_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_secondary_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_axii_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_secondary_sword_3').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_effect_played');
}

function ACS_AxiiSecondarySwordDestroyIMMEDIATE()
{
	ACSGetCEntity('acs_axii_secondary_sword_1').Destroy();

	ACSGetCEntity('acs_axii_secondary_sword_2').Destroy();

	ACSGetCEntity('acs_axii_secondary_sword_3').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_equipped');

	GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_effect_played');
}

function ACS_AxiiSecondarySwordDestroy_NOTAG()
{
	ACSGetCEntity('acs_axii_secondary_sword_1').BreakAttachment(); 
	ACSGetCEntity('acs_axii_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_secondary_sword_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_secondary_sword_2').BreakAttachment(); 
	ACSGetCEntity('acs_axii_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_secondary_sword_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_axii_secondary_sword_3').BreakAttachment(); 
	ACSGetCEntity('acs_axii_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_axii_secondary_sword_3').DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_effect_played');
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_IgniBowDestroy()
{
	ACSGetCEntity('acs_igni_bow_1').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_2').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_3').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_4').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_5').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_6').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('acs_igni_bow_7').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('acs_igni_bow_8').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('acs_igni_bow_equipped');

	GetWitcherPlayer().RemoveTag('acs_igni_bow_effect_played');
}

function ACS_IgniBowDestroyIMMEDIATE()
{
	ACSGetCEntity('acs_igni_bow_1').Destroy();

	ACSGetCEntity('acs_igni_bow_2').Destroy();

	ACSGetCEntity('acs_igni_bow_3').Destroy();

	ACSGetCEntity('acs_igni_bow_4').Destroy();

	ACSGetCEntity('acs_igni_bow_5').Destroy();

	ACSGetCEntity('acs_igni_bow_6').Destroy();

	ACSGetCEntity('acs_igni_bow_7').Destroy();

	ACSGetCEntity('acs_igni_bow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('acs_igni_bow_equipped');

	GetWitcherPlayer().RemoveTag('acs_igni_bow_effect_played');
}

function IgniBowDestroy_NOTAG()
{
	ACSGetCEntity('acs_igni_bow_1').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_2').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_3').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_4').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_5').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('acs_igni_bow_6').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('acs_igni_bow_7').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('acs_igni_bow_8').BreakAttachment(); 
	ACSGetCEntity('acs_igni_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('acs_igni_bow_8').DestroyAfter(0.00125);
}

function ACS_AxiiBowDestroy()
{
	ACSGetCEntity('axii_bow_1').BreakAttachment(); 
	ACSGetCEntity('axii_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_2').BreakAttachment(); 
	ACSGetCEntity('axii_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_3').BreakAttachment(); 
	ACSGetCEntity('axii_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_4').BreakAttachment(); 
	ACSGetCEntity('axii_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_5').BreakAttachment(); 
	ACSGetCEntity('axii_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_6').BreakAttachment(); 
	ACSGetCEntity('axii_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('axii_bow_7').BreakAttachment(); 
	ACSGetCEntity('axii_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('axii_bow_8').BreakAttachment(); 
	ACSGetCEntity('axii_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('axii_bow_equipped');

	GetWitcherPlayer().RemoveTag('axii_bow_effect_played');
}

function ACS_AxiiBowDestroyIMMEDIATE()
{
	ACSGetCEntity('axii_bow_1').Destroy();

	ACSGetCEntity('axii_bow_2').Destroy();

	ACSGetCEntity('axii_bow_3').Destroy();

	ACSGetCEntity('axii_bow_4').Destroy();

	ACSGetCEntity('axii_bow_5').Destroy();

	ACSGetCEntity('axii_bow_6').Destroy();

	ACSGetCEntity('axii_bow_7').Destroy();

	ACSGetCEntity('axii_bow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('axii_bow_equipped');

	GetWitcherPlayer().RemoveTag('axii_bow_effect_played');
}

function AxiiBowDestroy_NOTAG()
{
	ACSGetCEntity('axii_bow_1').BreakAttachment(); 
	ACSGetCEntity('axii_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_2').BreakAttachment(); 
	ACSGetCEntity('axii_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_3').BreakAttachment(); 
	ACSGetCEntity('axii_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_4').BreakAttachment(); 
	ACSGetCEntity('axii_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_5').BreakAttachment(); 
	ACSGetCEntity('axii_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_bow_6').BreakAttachment(); 
	ACSGetCEntity('axii_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('axii_bow_7').BreakAttachment(); 
	ACSGetCEntity('axii_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('axii_bow_8').BreakAttachment(); 
	ACSGetCEntity('axii_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_bow_8').DestroyAfter(0.00125);
}

function ACS_AardBowDestroy()
{
	ACSGetCEntity('aard_bow_1').BreakAttachment(); 
	ACSGetCEntity('aard_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_2').BreakAttachment(); 
	ACSGetCEntity('aard_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_3').BreakAttachment(); 
	ACSGetCEntity('aard_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_4').BreakAttachment(); 
	ACSGetCEntity('aard_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_5').BreakAttachment(); 
	ACSGetCEntity('aard_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_6').BreakAttachment(); 
	ACSGetCEntity('aard_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('aard_bow_7').BreakAttachment(); 
	ACSGetCEntity('aard_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('aard_bow_8').BreakAttachment(); 
	ACSGetCEntity('aard_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('aard_bow_equipped');

	GetWitcherPlayer().RemoveTag('aard_bow_effect_played');
}

function ACS_AardBowDestroyIMMEDIATE()
{
	ACSGetCEntity('aard_bow_1').Destroy();

	ACSGetCEntity('aard_bow_2').Destroy();

	ACSGetCEntity('aard_bow_3').Destroy();

	ACSGetCEntity('aard_bow_4').Destroy();
	
	ACSGetCEntity('aard_bow_5').Destroy();

	ACSGetCEntity('aard_bow_6').Destroy();

	ACSGetCEntity('aard_bow_7').Destroy();

	ACSGetCEntity('aard_bow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('aard_bow_equipped');

	GetWitcherPlayer().RemoveTag('aard_bow_effect_played');
}

function AardBowDestroy_NOTAG()
{
	ACSGetCEntity('aard_bow_1').BreakAttachment(); 
	ACSGetCEntity('aard_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_2').BreakAttachment(); 
	ACSGetCEntity('aard_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_3').BreakAttachment(); 
	ACSGetCEntity('aard_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_4').BreakAttachment(); 
	ACSGetCEntity('aard_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_5').BreakAttachment(); 
	ACSGetCEntity('aard_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_bow_6').BreakAttachment(); 
	ACSGetCEntity('aard_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('aard_bow_7').BreakAttachment(); 
	ACSGetCEntity('aard_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('aard_bow_8').BreakAttachment(); 
	ACSGetCEntity('aard_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_bow_8').DestroyAfter(0.00125);
}

function ACS_YrdenBowDestroy()
{
	ACSGetCEntity('yrden_bow_1').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_2').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_3').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_4').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_5').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_6').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('yrden_bow_7').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('yrden_bow_8').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('yrden_bow_equipped');

	GetWitcherPlayer().RemoveTag('yrden_bow_effect_played');
}

function ACS_YrdenBowDestroyIMMEDIATE()
{
	ACSGetCEntity('yrden_bow_1').Destroy();

	ACSGetCEntity('yrden_bow_2').Destroy();

	ACSGetCEntity('yrden_bow_3').Destroy();

	ACSGetCEntity('yrden_bow_4').Destroy();

	ACSGetCEntity('yrden_bow_5').Destroy();

	ACSGetCEntity('yrden_bow_6').Destroy();

	ACSGetCEntity('yrden_bow_7').Destroy();

	ACSGetCEntity('yrden_bow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('yrden_bow_equipped');

	GetWitcherPlayer().RemoveTag('yrden_bow_effect_played');
}

function YrdenBowDestroy_NOTAG()
{
	ACSGetCEntity('yrden_bow_1').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_2').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_3').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_4').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_5').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_bow_6').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('yrden_bow_7').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('yrden_bow_8').BreakAttachment(); 
	ACSGetCEntity('yrden_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_bow_8').DestroyAfter(0.00125);
}

function ACS_QuenBowDestroy()
{
	ACSGetCEntity('quen_bow_1').BreakAttachment(); 
	ACSGetCEntity('quen_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_2').BreakAttachment(); 
	ACSGetCEntity('quen_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_3').BreakAttachment(); 
	ACSGetCEntity('quen_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_4').BreakAttachment(); 
	ACSGetCEntity('quen_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_5').BreakAttachment(); 
	ACSGetCEntity('quen_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_6').BreakAttachment(); 
	ACSGetCEntity('quen_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('quen_bow_7').BreakAttachment(); 
	ACSGetCEntity('quen_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('quen_bow_8').BreakAttachment(); 
	ACSGetCEntity('quen_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('quen_bow_equipped');

	GetWitcherPlayer().RemoveTag('quen_bow_effect_played');
}

function ACS_QuenBowDestroyIMMEDIATE()
{
	ACSGetCEntity('quen_bow_1').Destroy();
	
	ACSGetCEntity('quen_bow_2').Destroy();
	
	ACSGetCEntity('quen_bow_3').Destroy();

	ACSGetCEntity('quen_bow_4').Destroy();

	ACSGetCEntity('quen_bow_5').Destroy();

	ACSGetCEntity('quen_bow_6').Destroy();

	ACSGetCEntity('quen_bow_7').Destroy();

	ACSGetCEntity('quen_bow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('quen_bow_equipped');

	GetWitcherPlayer().RemoveTag('quen_bow_effect_played');
}

function QuenBowDestroy_NOTAG()
{
	ACSGetCEntity('quen_bow_1').BreakAttachment(); 
	ACSGetCEntity('quen_bow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_2').BreakAttachment(); 
	ACSGetCEntity('quen_bow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_3').BreakAttachment(); 
	ACSGetCEntity('quen_bow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_4').BreakAttachment(); 
	ACSGetCEntity('quen_bow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_5').BreakAttachment(); 
	ACSGetCEntity('quen_bow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_bow_6').BreakAttachment(); 
	ACSGetCEntity('quen_bow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_6').DestroyAfter(0.00125);

	ACSGetCEntity('quen_bow_7').BreakAttachment(); 
	ACSGetCEntity('quen_bow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_7').DestroyAfter(0.00125);

	ACSGetCEntity('quen_bow_8').BreakAttachment(); 
	ACSGetCEntity('quen_bow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_bow_8').DestroyAfter(0.00125);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_IgniCrossbowDestroy()
{
	ACSGetCEntity('igni_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('igni_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('igni_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('igni_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('igni_crossbow_effect_played');
}

function ACS_IgniCrossbowDestroyIMMEDIATE()
{
	ACSGetCEntity('igni_crossbow_1').Destroy();

	ACSGetCEntity('igni_crossbow_2').Destroy();

	ACSGetCEntity('igni_crossbow_3').Destroy();

	ACSGetCEntity('igni_crossbow_4').Destroy();

	ACSGetCEntity('igni_crossbow_5').Destroy();

	ACSGetCEntity('igni_crossbow_6').Destroy();

	ACSGetCEntity('igni_crossbow_7').Destroy();

	ACSGetCEntity('igni_crossbow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('igni_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('igni_crossbow_effect_played');
}

function IgniCrossbowDestroy_NOTAG()
{
	ACSGetCEntity('igni_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('igni_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('igni_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('igni_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('igni_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('igni_crossbow_8').DestroyAfter(0.00125);
}

function ACS_AxiiCrossbowDestroy()
{
	ACSGetCEntity('axii_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('axii_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('axii_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('axii_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('axii_crossbow_effect_played');
}

function ACS_AxiiCrossbowDestroyIMMEDIATE()
{
	ACSGetCEntity('axii_crossbow_1').Destroy();
	
	ACSGetCEntity('axii_crossbow_2').Destroy();

	ACSGetCEntity('axii_crossbow_3').Destroy();

	ACSGetCEntity('axii_crossbow_4').Destroy();

	ACSGetCEntity('axii_crossbow_5').Destroy();

	ACSGetCEntity('axii_crossbow_6').Destroy();

	ACSGetCEntity('axii_crossbow_7').Destroy();

	ACSGetCEntity('axii_crossbow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('axii_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('axii_crossbow_effect_played');
}

function AxiiCrossbowDestroy_NOTAG()
{
	ACSGetCEntity('axii_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('axii_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('axii_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('axii_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('axii_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('axii_crossbow_8').DestroyAfter(0.00125);
}

function ACS_AardCrossbowDestroy()
{
	ACSGetCEntity('aard_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('aard_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('aard_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('aard_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('aard_crossbow_effect_played');
}

function ACS_AardCrossbowDestroyIMMEDIATE()
{
	ACSGetCEntity('aard_crossbow_1').Destroy();

	ACSGetCEntity('aard_crossbow_2').Destroy();

	ACSGetCEntity('aard_crossbow_3').Destroy();

	ACSGetCEntity('aard_crossbow_4').Destroy();

	ACSGetCEntity('aard_crossbow_5').Destroy();

	ACSGetCEntity('aard_crossbow_6').Destroy();

	ACSGetCEntity('aard_crossbow_7').Destroy();

	ACSGetCEntity('aard_crossbow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('aard_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('aard_crossbow_effect_played');
}

function AardCrossbowDestroy_NOTAG()
{
	ACSGetCEntity('aard_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('aard_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('aard_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('aard_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('aard_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('aard_crossbow_8').DestroyAfter(0.00125);
}

function ACS_YrdenCrossbowDestroy()
{
	ACSGetCEntity('yrden_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('yrden_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('yrden_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('yrden_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('yrden_crossbow_effect_played');
}

function ACS_YrdenCrossbowDestroyIMMEDIATE()
{
	ACSGetCEntity('yrden_crossbow_1').Destroy();

	ACSGetCEntity('yrden_crossbow_2').Destroy();

	ACSGetCEntity('yrden_crossbow_3').Destroy();

	ACSGetCEntity('yrden_crossbow_4').Destroy();

	ACSGetCEntity('yrden_crossbow_5').Destroy();
		
	ACSGetCEntity('yrden_crossbow_6').Destroy();

	ACSGetCEntity('yrden_crossbow_7').Destroy();

	ACSGetCEntity('yrden_crossbow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('yrden_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('yrden_crossbow_effect_played');
}

function YrdenCrossbowDestroy_NOTAG()
{
	ACSGetCEntity('yrden_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('yrden_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('yrden_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('yrden_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('yrden_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('yrden_crossbow_8').DestroyAfter(0.00125);
}

function ACS_QuenCrossbowDestroy()
{
	ACSGetCEntity('quen_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('quen_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('quen_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_8').DestroyAfter(0.00125);
		
	GetWitcherPlayer().RemoveTag('quen_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('quen_crossbow_effect_played');
}

function ACS_QuenCrossbowDestroyIMMEDIATE()
{
	ACSGetCEntity('quen_crossbow_1').Destroy();

	ACSGetCEntity('quen_crossbow_2').Destroy();

	ACSGetCEntity('quen_crossbow_3').Destroy();

	ACSGetCEntity('quen_crossbow_4').Destroy();

	ACSGetCEntity('quen_crossbow_5').Destroy();

	ACSGetCEntity('quen_crossbow_6').Destroy();

	ACSGetCEntity('quen_crossbow_7').Destroy();

	ACSGetCEntity('quen_crossbow_8').Destroy();
		
	GetWitcherPlayer().RemoveTag('quen_crossbow_equipped');

	GetWitcherPlayer().RemoveTag('quen_crossbow_effect_played');
}

function QuenCrossbowDestroy_NOTAG()
{
	ACSGetCEntity('quen_crossbow_1').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_1').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_2').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_2').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_3').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_3').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_4').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_4').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_5').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_5').DestroyAfter(0.00125);
		
	ACSGetCEntity('quen_crossbow_6').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_6').DestroyAfter(0.00125);

	ACSGetCEntity('quen_crossbow_7').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_7').DestroyAfter(0.00125);

	ACSGetCEntity('quen_crossbow_8').BreakAttachment(); 
	ACSGetCEntity('quen_crossbow_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACSGetCEntity('quen_crossbow_8').DestroyAfter(0.00125);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_HybridTagRemoval()
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