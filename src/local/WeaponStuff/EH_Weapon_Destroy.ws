function ACS_WeaponDestroyInit( hide_sword : bool )
{
	if (hide_sword)
	{
		if ( 
		ACS_GetWeaponMode() == 0
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2
		)
		{
			ACS_HideSword();
		}
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
	ACS_QuenSwordDestroy(true);
	ACS_AardSwordDestroy(true);
	ACS_YrdenSwordDestroy(true);
	ACS_AxiiSwordDestroy(true);	
	ACS_IgniSecondarySwordDestroy();
	ACS_QuenSecondarySwordDestroy(true);
	ACS_AardSecondarySwordDestroy(true);
	ACS_YrdenSecondarySwordDestroy(true);
	ACS_AxiiSecondarySwordDestroy(true);

	ACS_BowDestroy();

	ACS_CrossbowDestroy();

	ACS_Yrden_Sidearm_Destroy();

	ACS_BowArrowDestroy();

	ACS_CrossbowArrowDestroy();

	ACS_SwordTrailDestroy();

	if (ACSGetCEntity('ACS_Frost_Sword_Ent'))
	{
		ACSGetCEntity('ACS_Frost_Sword_Ent').Destroy();
	}

	if (ACSGetCEntity('ACS_Fire_Sword_Ent'))
	{
		ACSGetCEntity('ACS_Fire_Sword_Ent').Destroy();

		ACSGetCEntity('ACS_Fire_Sword_Ground_Fx_Ent').Destroy();
	}

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
		ACS_QuenSwordDestroy(false);
	}
	else if (GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
	{
		acs_axii_sword_summon();
		ACS_AxiiSwordDestroy(false);	
	}
	else if (GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
	{
		acs_aard_sword_summon();
		ACS_AardSwordDestroy(false);
	}
	else if (GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
	{
		acs_yrden_sword_summon();
		ACS_YrdenSwordDestroy(false);
	}
	else if (GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
	{
		acs_quen_secondary_sword_summon();
		ACS_QuenSecondarySwordDestroy(false);
	}
	else if (GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
	{
		acs_axii_secondary_sword_summon();
		ACS_AxiiSecondarySwordDestroy(false);
	}
	else if (GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
	{
		acs_aard_secondary_sword_summon();
		ACS_AardSecondarySwordDestroy(false);
	}
	else if (GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
	{
		acs_yrden_secondary_sword_summon();
		ACS_YrdenSecondarySwordDestroy(false);
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

	ACS_BowArrowDestroy();

	ACS_CrossbowArrowDestroy();
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
	steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
	silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
	
	if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) && !thePlayer.HasTag('acs_aard_sword_equipped') )
	{
		steelsword.SetVisible(true);

		steelswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
		steelswordentity.SetHideInGame(false);
	}
	else if ( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) && !thePlayer.HasTag('acs_aard_sword_equipped'))
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
		if (ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodHideSwordsheathes', false) || ACS_CloakEquippedCheck())
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
		if (ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodHideSwordsheathes', false) || ACS_CloakEquippedCheck())
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
	var anchor_temp, blade_temp											: CEntityTemplate;
	
	var 

	r_anchor1, 
	r_anchor2,
	r_anchor3,
	r_anchor4,
	r_anchor5,

	l_anchor1, 
	l_anchor2,
	l_anchor3,
	l_anchor4,
	l_anchor5,

	r_blade1, 
	r_blade2,
	r_blade3,
	r_blade4,
	r_blade5,

	l_blade1,
	l_blade2,
	l_blade3,
	l_blade4,
	l_blade5	

	: CEntity;

	var bone_vec, attach_vec											: Vector;
	var bone_rot, attach_rot											: EulerAngles;

	var morphManager : CMorphedMeshManagerComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}
	
	entry function ClawDestroy_Entry()
	{
		if (!ACS_GetItem_VampClaw_Shades())
		{
			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').RemoveTag('ACS_Vamp_Claws_R1_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').RemoveTag('ACS_Vamp_Claws_R2_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').RemoveTag('ACS_Vamp_Claws_R3_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').RemoveTag('ACS_Vamp_Claws_R4_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').RemoveTag('ACS_Vamp_Claws_R5_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').RemoveTag('ACS_Vamp_Claws_L1_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').RemoveTag('ACS_Vamp_Claws_L2_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').RemoveTag('ACS_Vamp_Claws_L3_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').RemoveTag('ACS_Vamp_Claws_L4_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').RemoveTag('ACS_Vamp_Claws_L5_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R1').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R1').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R1').RemoveTag('ACS_Vamp_Claws_R1');

			ACSGetCEntity('ACS_Vamp_Claws_R2').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R2').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R2').RemoveTag('ACS_Vamp_Claws_R2');

			ACSGetCEntity('ACS_Vamp_Claws_R3').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R3').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R3').RemoveTag('ACS_Vamp_Claws_R3');

			ACSGetCEntity('ACS_Vamp_Claws_R4').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R4').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R4').RemoveTag('ACS_Vamp_Claws_R4');

			ACSGetCEntity('ACS_Vamp_Claws_R5').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_R5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_R5').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_R5').RemoveTag('ACS_Vamp_Claws_R5');

			ACSGetCEntity('ACS_Vamp_Claws_L1').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L1').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L1').RemoveTag('ACS_Vamp_Claws_L1');

			ACSGetCEntity('ACS_Vamp_Claws_L2').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L2').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L2').RemoveTag('ACS_Vamp_Claws_L2');

			ACSGetCEntity('ACS_Vamp_Claws_L3').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L3').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L3').RemoveTag('ACS_Vamp_Claws_L3');

			ACSGetCEntity('ACS_Vamp_Claws_L4').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L4').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L4').RemoveTag('ACS_Vamp_Claws_L4');

			ACSGetCEntity('ACS_Vamp_Claws_L5').BreakAttachment(); 
			ACSGetCEntity('ACS_Vamp_Claws_L5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('ACS_Vamp_Claws_L5').DestroyAfter(0.00125);
			ACSGetCEntity('ACS_Vamp_Claws_L5').RemoveTag('ACS_Vamp_Claws_L5');
			
			if (ACS_Armor_Equipped_Check() || ACS_GetItem_VampClaw_ACS_Armor())
			{
				
			}
			else
			{
				if (!ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodHideVampireClaws', false))
				{
					anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\models\vamp_claws\blood\vamp_claws_singular_morph_bone.w2ent", true );

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_thumb3' ), bone_vec, bone_rot );
					r_anchor1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor1.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_thumb3', bone_vec, bone_rot );
					r_anchor1.AddTag('ACS_Vamp_Claws_R1_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_index3' ), bone_vec, bone_rot );
					r_anchor2 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor2.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_index3', bone_vec, bone_rot );
					r_anchor2.AddTag('ACS_Vamp_Claws_R2_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_middle3' ), bone_vec, bone_rot );
					r_anchor3 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor3.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_middle3', bone_vec, bone_rot );
					r_anchor3.AddTag('ACS_Vamp_Claws_R3_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_ring3' ), bone_vec, bone_rot );
					r_anchor4 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor4.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_ring3', bone_vec, bone_rot );
					r_anchor4.AddTag('ACS_Vamp_Claws_R4_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_pinky3' ), bone_vec, bone_rot );
					r_anchor5 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor5.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_pinky3', bone_vec, bone_rot );
					r_anchor5.AddTag('ACS_Vamp_Claws_R5_Anchor');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_thumb3' ), bone_vec, bone_rot );
					l_anchor1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor1.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_thumb3', bone_vec, bone_rot );
					l_anchor1.AddTag('ACS_Vamp_Claws_L1_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_index3' ), bone_vec, bone_rot );
					l_anchor2 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor2.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_index3', bone_vec, bone_rot );
					l_anchor2.AddTag('ACS_Vamp_Claws_L2_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_middle3' ), bone_vec, bone_rot );
					l_anchor3 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor3.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_middle3', bone_vec, bone_rot );
					l_anchor3.AddTag('ACS_Vamp_Claws_L3_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_ring3' ), bone_vec, bone_rot );
					l_anchor4 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor4.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_ring3', bone_vec, bone_rot );
					l_anchor4.AddTag('ACS_Vamp_Claws_L4_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_pinky3' ), bone_vec, bone_rot );
					l_anchor5 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor5.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_pinky3', bone_vec, bone_rot );
					l_anchor5.AddTag('ACS_Vamp_Claws_L5_Anchor');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade5 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade5 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

					r_blade1.AddTag('ACS_Vamp_Claws_R1');
					r_blade2.AddTag('ACS_Vamp_Claws_R2');
					r_blade3.AddTag('ACS_Vamp_Claws_R3');
					r_blade4.AddTag('ACS_Vamp_Claws_R4');
					r_blade5.AddTag('ACS_Vamp_Claws_R5');

					l_blade1.AddTag('ACS_Vamp_Claws_L1');
					l_blade2.AddTag('ACS_Vamp_Claws_L2');
					l_blade3.AddTag('ACS_Vamp_Claws_L3');
					l_blade4.AddTag('ACS_Vamp_Claws_L4');
					l_blade5.AddTag('ACS_Vamp_Claws_L5');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					attach_rot.Roll = 90;
					attach_rot.Pitch = -90;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0825;
					attach_vec.Y = 0.00625;
					attach_vec.Z = 0.0;
					
					r_blade1.CreateAttachment( r_anchor1, , attach_vec, attach_rot );

					l_blade1.CreateAttachment( l_anchor1, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade2.CreateAttachment( r_anchor2, , attach_vec, attach_rot );

					l_blade2.CreateAttachment( l_anchor2, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade3.CreateAttachment( r_anchor3, , attach_vec, attach_rot );

					l_blade3.CreateAttachment( l_anchor3, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					r_blade4.CreateAttachment( r_anchor4, , attach_vec, attach_rot );

					l_blade4.CreateAttachment( l_anchor4, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade5.CreateAttachment( r_anchor5, , attach_vec, attach_rot );

					l_blade5.CreateAttachment( l_anchor5, , attach_vec, attach_rot );


					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					morphManager = (CMorphedMeshManagerComponent) r_blade1.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade2.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade3.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade4.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade5.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade1.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade2.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade3.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade4.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade5.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );
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
	private var stupidArray 							: array< name >;
	private var morphManager 							: CMorphedMeshManagerComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_Entry();
	}

	entry function ClawDestroy_Entry()
	{
		ACS_Blood_Armor_Destroy(true);

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().StopEffect('dive_shape');	
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			GetWitcherPlayer().StopEffect('blood_color_2');
			GetWitcherPlayer().PlayEffectSingle('blood_color_2');
		}

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R1').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R2').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R3').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R4').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R5').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L1').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L2').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L3').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L4').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L5').GetComponentByClassName('CMorphedMeshManagerComponent');
		morphManager.SetMorphBlend( 0, 1 );

		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').RemoveTag('ACS_Vamp_Claws_R1_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').RemoveTag('ACS_Vamp_Claws_R2_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').RemoveTag('ACS_Vamp_Claws_R3_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').RemoveTag('ACS_Vamp_Claws_R4_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').RemoveTag('ACS_Vamp_Claws_R5_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').RemoveTag('ACS_Vamp_Claws_L1_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').RemoveTag('ACS_Vamp_Claws_L2_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').RemoveTag('ACS_Vamp_Claws_L3_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').RemoveTag('ACS_Vamp_Claws_L4_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').RemoveTag('ACS_Vamp_Claws_L5_Anchor');

		
		ACSGetCEntity('ACS_Vamp_Claws_R1').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R1').RemoveTag('ACS_Vamp_Claws_R1');

		
		ACSGetCEntity('ACS_Vamp_Claws_R2').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R2').RemoveTag('ACS_Vamp_Claws_R2');

		
		ACSGetCEntity('ACS_Vamp_Claws_R3').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R3').RemoveTag('ACS_Vamp_Claws_R3');

		
		ACSGetCEntity('ACS_Vamp_Claws_R4').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R4').RemoveTag('ACS_Vamp_Claws_R4');

		
		ACSGetCEntity('ACS_Vamp_Claws_R5').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_R5').RemoveTag('ACS_Vamp_Claws_R5');

		
		ACSGetCEntity('ACS_Vamp_Claws_L1').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L1').RemoveTag('ACS_Vamp_Claws_L1');

		
		ACSGetCEntity('ACS_Vamp_Claws_L2').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L2').RemoveTag('ACS_Vamp_Claws_L2');

		
		ACSGetCEntity('ACS_Vamp_Claws_L3').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L3').RemoveTag('ACS_Vamp_Claws_L3');

		
		ACSGetCEntity('ACS_Vamp_Claws_L4').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L4').RemoveTag('ACS_Vamp_Claws_L4');

		
		ACSGetCEntity('ACS_Vamp_Claws_L5').DestroyAfter(1);
		ACSGetCEntity('ACS_Vamp_Claws_L5').RemoveTag('ACS_Vamp_Claws_L5');
	
		
		GetWitcherPlayer().RemoveTag('acs_vampire_claws_equipped');	
			
		GetWitcherPlayer().RemoveTag('ACS_blood_armor');

		if (thePlayer.IsEffectActive('acs_armor_effect_1', false))
		{
			thePlayer.StopEffect('acs_armor_effect_1');
		}
		
		if (thePlayer.IsEffectActive('acs_armor_effect_2', false))
		{
			thePlayer.StopEffect('acs_armor_effect_2');
		}

		if (thePlayer.IsEffectActive('demon_cs', false))
		{
			thePlayer.StopEffect('demon_cs');
		}

		if (thePlayer.IsEffectActive('him_smoke_red', false))
		{
			thePlayer.StopEffect('him_smoke_red');
		}

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			stupidArray.Clear();

			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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

			//Sleep(0.5);

			if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0 );
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				thePlayer.ActivateBehaviors(stupidArray);
			}
		}
	}
}

state ClawDestroy_NOTAG_Engage in cACSClawDestroy
{
	private var morphManager 							: CMorphedMeshManagerComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawDestroy_NoTag_Entry();
	}
	
	entry function ClawDestroy_NoTag_Entry()
	{
		//ACS_Blood_Armor_Destroy(true);

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			//GetWitcherPlayer().PlayEffectSingle('dive_shape');
		}

		if (!ACS_GetItem_VampClaw_Shades())
		{
			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R1').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R2').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R3').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R4').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R5').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L1').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L2').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L3').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L4').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L5').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').RemoveTag('ACS_Vamp_Claws_R1_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').RemoveTag('ACS_Vamp_Claws_R2_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').RemoveTag('ACS_Vamp_Claws_R3_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').RemoveTag('ACS_Vamp_Claws_R4_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').RemoveTag('ACS_Vamp_Claws_R5_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').RemoveTag('ACS_Vamp_Claws_L1_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').RemoveTag('ACS_Vamp_Claws_L2_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').RemoveTag('ACS_Vamp_Claws_L3_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').RemoveTag('ACS_Vamp_Claws_L4_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').RemoveTag('ACS_Vamp_Claws_L5_Anchor');

			
			ACSGetCEntity('ACS_Vamp_Claws_R1').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R1').RemoveTag('ACS_Vamp_Claws_R1');

			
			ACSGetCEntity('ACS_Vamp_Claws_R2').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R2').RemoveTag('ACS_Vamp_Claws_R2');

			
			ACSGetCEntity('ACS_Vamp_Claws_R3').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R3').RemoveTag('ACS_Vamp_Claws_R3');

			
			ACSGetCEntity('ACS_Vamp_Claws_R4').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R4').RemoveTag('ACS_Vamp_Claws_R4');

			
			ACSGetCEntity('ACS_Vamp_Claws_R5').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R5').RemoveTag('ACS_Vamp_Claws_R5');

			
			ACSGetCEntity('ACS_Vamp_Claws_L1').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L1').RemoveTag('ACS_Vamp_Claws_L1');

			
			ACSGetCEntity('ACS_Vamp_Claws_L2').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L2').RemoveTag('ACS_Vamp_Claws_L2');

			
			ACSGetCEntity('ACS_Vamp_Claws_L3').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L3').RemoveTag('ACS_Vamp_Claws_L3');

			
			ACSGetCEntity('ACS_Vamp_Claws_L4').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L4').RemoveTag('ACS_Vamp_Claws_L4');

			
			ACSGetCEntity('ACS_Vamp_Claws_L5').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L5').RemoveTag('ACS_Vamp_Claws_L5');
		}
	}
}

state ClawDestroy_WITH_EFFECT_Engage in cACSClawDestroy
{
	private var morphManager 							: CMorphedMeshManagerComponent;
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
		ACS_Blood_Armor_Destroy(true);

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().StopEffect('dive_shape');	
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			GetWitcherPlayer().StopEffect('blood_color_2');
			GetWitcherPlayer().PlayEffectSingle('blood_color_2');
		}
		
		if (!ACS_GetItem_VampClaw_Shades())
		{
			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R1').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R2').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R3').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R4').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_R5').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L1').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L2').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L3').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L4').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			morphManager = (CMorphedMeshManagerComponent) ACSGetCEntity('ACS_Vamp_Claws_L5').GetComponentByClassName('CMorphedMeshManagerComponent');
			morphManager.SetMorphBlend( 0, 1 );

			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').RemoveTag('ACS_Vamp_Claws_R1_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').RemoveTag('ACS_Vamp_Claws_R2_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').RemoveTag('ACS_Vamp_Claws_R3_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').RemoveTag('ACS_Vamp_Claws_R4_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').RemoveTag('ACS_Vamp_Claws_R5_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').RemoveTag('ACS_Vamp_Claws_L1_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').RemoveTag('ACS_Vamp_Claws_L2_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').RemoveTag('ACS_Vamp_Claws_L3_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').RemoveTag('ACS_Vamp_Claws_L4_Anchor');

			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').RemoveTag('ACS_Vamp_Claws_L5_Anchor');

			
			ACSGetCEntity('ACS_Vamp_Claws_R1').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R1').RemoveTag('ACS_Vamp_Claws_R1');

			
			ACSGetCEntity('ACS_Vamp_Claws_R2').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R2').RemoveTag('ACS_Vamp_Claws_R2');

			
			ACSGetCEntity('ACS_Vamp_Claws_R3').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R3').RemoveTag('ACS_Vamp_Claws_R3');

			
			ACSGetCEntity('ACS_Vamp_Claws_R4').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R4').RemoveTag('ACS_Vamp_Claws_R4');

			
			ACSGetCEntity('ACS_Vamp_Claws_R5').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_R5').RemoveTag('ACS_Vamp_Claws_R5');

			
			ACSGetCEntity('ACS_Vamp_Claws_L1').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L1').RemoveTag('ACS_Vamp_Claws_L1');

			
			ACSGetCEntity('ACS_Vamp_Claws_L2').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L2').RemoveTag('ACS_Vamp_Claws_L2');

			
			ACSGetCEntity('ACS_Vamp_Claws_L3').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L3').RemoveTag('ACS_Vamp_Claws_L3');

			
			ACSGetCEntity('ACS_Vamp_Claws_L4').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L4').RemoveTag('ACS_Vamp_Claws_L4');

			
			ACSGetCEntity('ACS_Vamp_Claws_L5').DestroyAfter(1);
			ACSGetCEntity('ACS_Vamp_Claws_L5').RemoveTag('ACS_Vamp_Claws_L5');
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

			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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

			//Sleep(0.5);

			if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0 );
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				thePlayer.ActivateBehaviors(stupidArray);
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

			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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

			if (stupidArray.Size() > 0)
			{
				thePlayer.ActivateBehaviors(stupidArray);
			}
		}
	}
}

function ACS_Blood_Armor_Destroy( backclaw_destroy : bool )
{
	if (ACSGetCEntity('acs_vampire_extra_arms_1'))
	{
		ACSGetCEntity('acs_vampire_extra_arms_1').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_extra_arms_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_extra_arms_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_extra_arms_1').RemoveTag('acs_vampire_extra_arms_1');
	}

	if (ACSGetCEntity('acs_vampire_extra_arms_2'))
	{
		ACSGetCEntity('acs_vampire_extra_arms_2').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_extra_arms_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_extra_arms_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_extra_arms_2').RemoveTag('acs_vampire_extra_arms_2');
	}

	if (ACSGetCEntity('acs_vampire_extra_arms_3'))
	{
		ACSGetCEntity('acs_vampire_extra_arms_3').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_extra_arms_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_extra_arms_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_extra_arms_3').RemoveTag('acs_vampire_extra_arms_3');
	}

	if (ACSGetCEntity('acs_vampire_extra_arms_4'))
	{	

		ACSGetCEntity('acs_vampire_extra_arms_4').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_extra_arms_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_extra_arms_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_extra_arms_4').RemoveTag('acs_vampire_extra_arms_4');
	}

	if (ACSGetCEntity('acs_extra_arms_anchor_l'))
	{
		ACSGetCEntity('acs_extra_arms_anchor_l').BreakAttachment(); 
		ACSGetCEntity('acs_extra_arms_anchor_l').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_extra_arms_anchor_l').DestroyAfter(0.00125);
		ACSGetCEntity('acs_extra_arms_anchor_l').RemoveTag('acs_extra_arms_anchor_l');
	}

	if (ACSGetCEntity('acs_extra_arms_anchor_r'))
	{
		ACSGetCEntity('acs_extra_arms_anchor_r').BreakAttachment(); 
		ACSGetCEntity('acs_extra_arms_anchor_r').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_extra_arms_anchor_r').DestroyAfter(0.00125);
		ACSGetCEntity('acs_extra_arms_anchor_r').RemoveTag('acs_extra_arms_anchor_r');
	}

	if (ACSGetCEntity('acs_vampire_head_anchor'))
	{
		ACSGetCEntity('acs_vampire_head_anchor').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_head_anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_head_anchor').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_head_anchor').RemoveTag('acs_vampire_head_anchor');
	}

	if (ACSGetCEntity('acs_vampire_head'))
	{
		ACSGetCEntity('acs_vampire_head').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_head').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_head').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_head').RemoveTag('acs_vampire_head');
	}

	if (ACSGetCEntity('acs_vampire_back_claw'))
	{
		thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP_Stop" );

		ACSGetCEntity('acs_vampire_back_claw').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_back_claw').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_back_claw').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_back_claw').RemoveTag('acs_vampire_back_claw');
	}

	if (ACSGetCEntity('acs_vampire_claw_anchor'))
	{
		ACSGetCEntity('acs_vampire_claw_anchor').BreakAttachment(); 
		ACSGetCEntity('acs_vampire_claw_anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_vampire_claw_anchor').DestroyAfter(0.00125);
		ACSGetCEntity('acs_vampire_claw_anchor').RemoveTag('acs_vampire_claw_anchor');
	}

	if (backclaw_destroy)
	{
		if (ACSGetCEntity('acs_vampire_back_claw'))
		{
			ACSGetCEntity('acs_vampire_back_claw').BreakAttachment(); 
			ACSGetCEntity('acs_vampire_back_claw').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('acs_vampire_back_claw').DestroyAfter(0.00125);
			ACSGetCEntity('acs_vampire_back_claw').RemoveTag('acs_vampire_back_claw');
		}

		if (ACSGetCEntity('acs_vampire_claw_anchor'))
		{
			ACSGetCEntity('acs_vampire_claw_anchor').BreakAttachment(); 
			ACSGetCEntity('acs_vampire_claw_anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACSGetCEntity('acs_vampire_claw_anchor').DestroyAfter(0.00125);
			ACSGetCEntity('acs_vampire_claw_anchor').RemoveTag('acs_vampire_claw_anchor');
		}
	}
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
	
function ACS_QuenSwordDestroy(remove_tag : bool)
{
	if (ACSGetCEntity('acs_quen_sword_1'))
	{
		ACSGetCEntity('acs_quen_sword_1').BreakAttachment();
		ACSGetCEntity('acs_quen_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_sword_1').RemoveTag('acs_quen_sword_1');
	}

	if (ACSGetCEntity('acs_quen_sword_2'))
	{
		ACSGetCEntity('acs_quen_sword_2').BreakAttachment();
		ACSGetCEntity('acs_quen_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_sword_2').RemoveTag('acs_quen_sword_2');
	}

	if (ACSGetCEntity('acs_quen_sword_3'))
	{
		ACSGetCEntity('acs_quen_sword_3').BreakAttachment();
		ACSGetCEntity('acs_quen_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_sword_3').RemoveTag('acs_quen_sword_3');
	}
			
	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_quen_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_quen_sword_effect_played');
}
	
function ACS_QuenSecondarySwordDestroy(remove_tag : bool)
{	
	if (ACSGetCEntity('acs_quen_secondary_sword_1'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_1').RemoveTag('acs_quen_secondary_sword_1');
	}
	
	if (ACSGetCEntity('acs_quen_secondary_sword_2'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_2').RemoveTag('acs_quen_secondary_sword_2');
	}
	
	if (ACSGetCEntity('acs_quen_secondary_sword_3'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_3').RemoveTag('acs_quen_secondary_sword_3');
	}

	if (ACSGetCEntity('acs_quen_secondary_sword_4'))
	{	
		ACSGetCEntity('acs_quen_secondary_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_4').RemoveTag('acs_quen_secondary_sword_4');
	}
	
	if (ACSGetCEntity('acs_quen_secondary_sword_5'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_5').RemoveTag('acs_quen_secondary_sword_5');
	}
	
	if (ACSGetCEntity('acs_quen_secondary_sword_6'))
	{
		ACSGetCEntity('acs_quen_secondary_sword_6').BreakAttachment(); 
		ACSGetCEntity('acs_quen_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_quen_secondary_sword_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_quen_secondary_sword_6').RemoveTag('acs_quen_secondary_sword_6');
	}

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_quen_secondary_sword_effect_played');
}
	
function ACS_AardSwordDestroy(remove_tag : bool)
{	
	if (ACSGetCEntity('acs_l_hand_anchor_1'))
	{
		ACSGetCEntity('acs_l_hand_anchor_1').BreakAttachment(); 
		ACSGetCEntity('acs_l_hand_anchor_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_l_hand_anchor_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_l_hand_anchor_1').RemoveTag('acs_l_hand_anchor_1');
	}

	if (ACSGetCEntity('acs_r_hand_anchor_1'))
	{
		ACSGetCEntity('acs_r_hand_anchor_1').BreakAttachment(); 
		ACSGetCEntity('acs_r_hand_anchor_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_r_hand_anchor_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_r_hand_anchor_1').RemoveTag('acs_r_hand_anchor_1');
	}

	if (ACSGetCEntity('acs_aard_blade_1'))
	{
		ACSGetCEntity('acs_aard_blade_1').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_1').RemoveTag('acs_aard_blade_1');
	}	

	if (ACSGetCEntity('acs_aard_blade_2'))
	{
		ACSGetCEntity('acs_aard_blade_2').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_2').RemoveTag('acs_aard_blade_2');
	}	

	if (ACSGetCEntity('acs_aard_blade_3'))
	{	
		ACSGetCEntity('acs_aard_blade_3').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_3').RemoveTag('acs_aard_blade_3');
	}

	if (ACSGetCEntity('acs_aard_blade_4'))
	{		
		ACSGetCEntity('acs_aard_blade_4').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_4').RemoveTag('acs_aard_blade_4');
	}

	if (ACSGetCEntity('acs_aard_blade_5'))
	{		
		ACSGetCEntity('acs_aard_blade_5').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_5').RemoveTag('acs_aard_blade_5');
	}

	if (ACSGetCEntity('acs_aard_blade_6'))
	{		
		ACSGetCEntity('acs_aard_blade_6').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_6').RemoveTag('acs_aard_blade_6');
	}

	if (ACSGetCEntity('acs_aard_blade_7'))
	{
		ACSGetCEntity('acs_aard_blade_7').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_7').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_7').RemoveTag('acs_aard_blade_7');
	}

	if (ACSGetCEntity('acs_aard_blade_8'))
	{
		ACSGetCEntity('acs_aard_blade_8').BreakAttachment(); 
		ACSGetCEntity('acs_aard_blade_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_blade_8').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_blade_8').RemoveTag('acs_aard_blade_8');
	}
	
	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_aard_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_aard_sword_effect_played');
}

function ACS_AardSecondarySwordDestroy(remove_tag : bool)
{
	if (ACSGetCEntity('acs_aard_secondary_sword_1'))
	{
		ACSGetCEntity('acs_aard_secondary_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_1').RemoveTag('acs_aard_secondary_sword_1');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_2'))
	{	
		ACSGetCEntity('acs_aard_secondary_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_2').RemoveTag('acs_aard_secondary_sword_2');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_3'))
	{		
		ACSGetCEntity('acs_aard_secondary_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_3').RemoveTag('acs_aard_secondary_sword_3');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_4'))
	{		
		ACSGetCEntity('acs_aard_secondary_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_4').RemoveTag('acs_aard_secondary_sword_4');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_5'))
	{		
		ACSGetCEntity('acs_aard_secondary_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_5').RemoveTag('acs_aard_secondary_sword_5');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_6'))
	{		
		ACSGetCEntity('acs_aard_secondary_sword_6').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_6').RemoveTag('acs_aard_secondary_sword_6');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_7'))
	{
		ACSGetCEntity('acs_aard_secondary_sword_7').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_7').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_7').RemoveTag('acs_aard_secondary_sword_7');
	}	

	if (ACSGetCEntity('acs_aard_secondary_sword_8'))
	{
		ACSGetCEntity('acs_aard_secondary_sword_8').BreakAttachment(); 
		ACSGetCEntity('acs_aard_secondary_sword_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_aard_secondary_sword_8').DestroyAfter(0.00125);
		ACSGetCEntity('acs_aard_secondary_sword_8').RemoveTag('acs_aard_secondary_sword_8');
	}	

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_aard_secondary_sword_effect_played');
}

function ACS_YrdenSwordDestroy(remove_tag : bool)
{
	if (ACSGetCEntity('acs_yrden_sword_1'))
	{
		ACSGetCEntity('acs_yrden_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_1').RemoveTag('acs_yrden_sword_1');
	}

	if (ACSGetCEntity('acs_yrden_sword_2'))
	{
		ACSGetCEntity('acs_yrden_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_2').RemoveTag('acs_yrden_sword_2');
	}

	if (ACSGetCEntity('acs_yrden_sword_3'))
	{		
		ACSGetCEntity('acs_yrden_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_3').RemoveTag('acs_yrden_sword_3');
	}

	if (ACSGetCEntity('acs_yrden_sword_4'))
	{		
		ACSGetCEntity('acs_yrden_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_4').RemoveTag('acs_yrden_sword_4');
	}

	if (ACSGetCEntity('acs_yrden_sword_5'))
	{		
		ACSGetCEntity('acs_yrden_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_5').RemoveTag('acs_yrden_sword_5');
	}

	if (ACSGetCEntity('acs_yrden_sword_6'))
	{		
		ACSGetCEntity('acs_yrden_sword_6').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_6').RemoveTag('acs_yrden_sword_6');
	}

	if (ACSGetCEntity('acs_yrden_sword_7'))
	{
		ACSGetCEntity('acs_yrden_sword_7').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_7').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_7').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_7').RemoveTag('acs_yrden_sword_7');
	}

	if (ACSGetCEntity('acs_yrden_sword_8'))
	{
		ACSGetCEntity('acs_yrden_sword_8').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_sword_8').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_sword_8').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_sword_8').RemoveTag('acs_yrden_sword_8');
	}		

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_yrden_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_yrden_sword_effect_played');
}
	
function ACS_YrdenSecondarySwordDestroy(remove_tag : bool)
{
	if (ACSGetCEntity('acs_yrden_secondary_sword_1'))
	{
		ACSGetCEntity('acs_yrden_secondary_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_1').RemoveTag('acs_yrden_secondary_sword_1');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_2'))
	{		
		ACSGetCEntity('acs_yrden_secondary_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_2').RemoveTag('acs_yrden_secondary_sword_2');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_3'))
	{	
		ACSGetCEntity('acs_yrden_secondary_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_3').RemoveTag('acs_yrden_secondary_sword_3');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_4'))
	{		
		ACSGetCEntity('acs_yrden_secondary_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_4').RemoveTag('acs_yrden_secondary_sword_4');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_5'))
	{		
		ACSGetCEntity('acs_yrden_secondary_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_5').RemoveTag('acs_yrden_secondary_sword_5');
	}

	if (ACSGetCEntity('acs_yrden_secondary_sword_6'))
	{		
		ACSGetCEntity('acs_yrden_secondary_sword_6').BreakAttachment(); 
		ACSGetCEntity('acs_yrden_secondary_sword_6').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_yrden_secondary_sword_6').DestroyAfter(0.00125);
		ACSGetCEntity('acs_yrden_secondary_sword_6').RemoveTag('acs_yrden_secondary_sword_6');
	}

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_yrden_secondary_sword_effect_played');
}

function ACS_AxiiSwordDestroy( remove_tag : bool )
{
	if (ACSGetCEntity('acs_axii_sword_1'))
	{
		ACSGetCEntity('acs_axii_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_1').RemoveTag('acs_axii_sword_1');
	}

	if (ACSGetCEntity('acs_axii_sword_2'))
	{	
		ACSGetCEntity('acs_axii_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_2').RemoveTag('acs_axii_sword_2');
	}

	if (ACSGetCEntity('acs_axii_sword_3'))
	{		
		ACSGetCEntity('acs_axii_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_3').RemoveTag('acs_axii_sword_3');
	}

	if (ACSGetCEntity('acs_axii_sword_4'))
	{		
		ACSGetCEntity('acs_axii_sword_4').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_4').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_4').RemoveTag('acs_axii_sword_4');
	}

	if (ACSGetCEntity('acs_axii_sword_5'))
	{		
		ACSGetCEntity('acs_axii_sword_5').BreakAttachment(); 
		ACSGetCEntity('acs_axii_sword_5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_sword_5').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_sword_5').RemoveTag('acs_axii_sword_5');
	}	

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_axii_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_axii_sword_effect_played');
}
	
function ACS_AxiiSecondarySwordDestroy( remove_tag : bool )
{
	if (ACSGetCEntity('acs_axii_secondary_sword_1'))
	{
		ACSGetCEntity('acs_axii_secondary_sword_1').BreakAttachment(); 
		ACSGetCEntity('acs_axii_secondary_sword_1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_secondary_sword_1').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_secondary_sword_1').RemoveTag('acs_axii_secondary_sword_1');
	}	

	if (ACSGetCEntity('acs_axii_secondary_sword_2'))
	{	
		ACSGetCEntity('acs_axii_secondary_sword_2').BreakAttachment(); 
		ACSGetCEntity('acs_axii_secondary_sword_2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_secondary_sword_2').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_secondary_sword_2').RemoveTag('acs_axii_secondary_sword_2');
	}	

	if (ACSGetCEntity('acs_axii_secondary_sword_3'))
	{		
		ACSGetCEntity('acs_axii_secondary_sword_3').BreakAttachment(); 
		ACSGetCEntity('acs_axii_secondary_sword_3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_axii_secondary_sword_3').DestroyAfter(0.00125);
		ACSGetCEntity('acs_axii_secondary_sword_3').RemoveTag('acs_axii_secondary_sword_3');
	}	

	if (remove_tag)
	{
		GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_equipped');
	}

	GetWitcherPlayer().RemoveTag('acs_axii_secondary_sword_effect_played');
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_BowDestroy()
{
	if (ACSGetCEntity('acs_bow'))
	{
		ACSGetCEntity('acs_bow').BreakAttachment(); 
		ACSGetCEntity('acs_bow').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_bow').DestroyAfter(0.00125);
		ACSGetCEntity('acs_bow').RemoveTag('acs_bow');

		GetACSWatcher().AzkarFXCreate();

		GetWitcherPlayer().RemoveTag('acs_bow_equipped');
	}
}

function ACS_BowArrowDestroy()
{
	if (ACSGetCEntity('ACS_Bow_Arrow'))
	{
		ACSGetCEntity('ACS_Bow_Arrow').BreakAttachment();
		ACSGetCEntity('ACS_Bow_Arrow').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
		ACSGetCEntity('ACS_Bow_Arrow').DestroyAfter(0.125);
		ACSGetCEntity('ACS_Bow_Arrow').RemoveTag('ACS_Bow_Arrow');
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_CrossbowDestroy()
{
	if (ACSGetCEntity('acs_crossbow'))
	{
		ACSGetCEntity('acs_crossbow').BreakAttachment(); 
		ACSGetCEntity('acs_crossbow').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('acs_crossbow').DestroyAfter(0.00125);
		ACSGetCEntity('acs_crossbow').RemoveTag('acs_crossbow');
			
		GetWitcherPlayer().RemoveTag('acs_crossbow_equipped');
	}
}


function ACS_CrossbowArrowDestroy()
{
	if (ACSGetCEntity('ACS_Crossbow_Arrow'))
	{
		ACSGetCEntity('ACS_Crossbow_Arrow').BreakAttachment();
		ACSGetCEntity('ACS_Crossbow_Arrow').Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
		ACSGetCEntity('ACS_Crossbow_Arrow').DestroyAfter(0.125);
		ACSGetCEntity('ACS_Crossbow_Arrow').RemoveTag('ACS_Crossbow_Arrow');
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_SwordTrailDestroy()
{
	if (ACSGetCEntity('acs_sword_trail_1'))
	{
		ACSGetCEntity('acs_sword_trail_1').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_2'))
	{
		ACSGetCEntity('acs_sword_trail_2').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_3'))
	{
		ACSGetCEntity('acs_sword_trail_3').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_4'))
	{
		ACSGetCEntity('acs_sword_trail_4').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_5'))
	{
		ACSGetCEntity('acs_sword_trail_5').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_6'))
	{
		ACSGetCEntity('acs_sword_trail_6').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_7'))
	{
		ACSGetCEntity('acs_sword_trail_7').Destroy();
	}

	if (ACSGetCEntity('acs_sword_trail_8'))
	{
		ACSGetCEntity('acs_sword_trail_8').Destroy();
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_HybridTagRemoval()
{
	if (GetWitcherPlayer().HasTag('ACSHybridDefaultWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridDefaultWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridDefaultSecondaryWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridDefaultSecondaryWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridEredinWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridEredinWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridClawWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridClawWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridImlerithWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridImlerithWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridOlgierdWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridOlgierdWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridSpearWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridSpearWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridGregWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridGregWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridAxeWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridAxeWeaponTicket');
	}
	else if (GetWitcherPlayer().HasTag('ACSHybridGiantWeaponTicket'))
	{
		GetWitcherPlayer().RemoveTag('ACSHybridGiantWeaponTicket');
	}
}