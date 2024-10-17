function ACS_WeaponHolsterInit()
{
	var steelID, silverID, rangedID 										: SItemUniqueId;
	var steelsword, silversword, scabbard_steel, scabbard_silver			: CDrawableComponent;
	var scabbards_steel, scabbards_silver 									: array<SItemUniqueId>;
	var i 																	: int;
	var steelswordentity, silverswordentity, crossbowentity  				: CEntity;

	/*
	var vWeaponHolster : cWeaponHolster;
	vWeaponHolster = new cWeaponHolster in theGame;
	
	if ( ACS_Enabled() )
	{
		GetACSWatcher().Weapon_Summon_Effect_Delay();
		vWeaponHolster.WeaponHolster_Engage();
	}
	*/

	GetACSWatcher().register_extra_inputs();

	if (ACS_Armor_Equipped_Check())
	{
		thePlayer.SoundEvent("monster_caretaker_fx_black_exhale");
	}

	if (GetWitcherPlayer().HasAbility('ForceFinisher'))
	{
		GetWitcherPlayer().RemoveAbility('ForceFinisher');
	}
				
	if (GetWitcherPlayer().HasAbility('ForceDismemberment'))
	{
		GetWitcherPlayer().RemoveAbility('ForceDismemberment');
	}

	if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted')) //ACS
	{
		GetACSWatcher().Grow_Geralt_Immediate_Fast(); //ACS

		GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted'); //ACS
	}

	GetWitcherPlayer().StopEffect('fury_ciri');

	GetWitcherPlayer().StopEffect('fury_403_ciri');

	GetWitcherPlayer().StopEffect('acs_fury_ciri');

	GetWitcherPlayer().StopEffect('teleport_glow_ciri');

	if (GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_igni_sword_equipped_TAG')
	|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped_TAG'))
	{
		ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE();

		if ( ACS_GetWeaponMode() == 0 
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2 )
		{
			if (ACS_CloakEquippedCheck() || ACS_HideSwordsheathes_Enabled())
			{
				GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
				GetWitcherPlayer().StopEffect('embers_particles_test');
				acs_igni_sword_summon();
			}
		}
	}
	else
	{
		if (!GetWitcherPlayer().HasTag('acs_in_wraith'))
		{
			//ACSGetEquippedSword().StopAllEffects();

			if ( ACS_GetWeaponMode() == 0 
			|| ACS_GetWeaponMode() == 1
			|| ACS_GetWeaponMode() == 2 )
			{
				if (GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//acs_quen_sword_summon();
					acs_igni_sword_summon();
				}
				else if (GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//acs_axii_sword_summon();
					acs_igni_sword_summon();
				}
				else if (GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//acs_aard_sword_summon();
					acs_igni_sword_summon();
				}
				else if (GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//acs_yrden_sword_summon();
					acs_igni_sword_summon();
				}
				else if (GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//acs_quen_secondary_sword_summon();
					acs_igni_sword_summon();
				}
				else if (GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//acs_axii_secondary_sword_summon();
					acs_igni_sword_summon();
				}
				else if (GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//acs_aard_secondary_sword_summon();
					acs_igni_sword_summon();
				}
				else if (GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//acs_yrden_secondary_sword_summon();
					acs_igni_sword_summon();
				}
			}

			//Sword();
		}

		ACS_Shield_Destroy();
	
		ACS_WeaponDestroyIMMEDIATEInit();
		
		/*
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		steelsword.SetVisible(true); 
		silversword.SetVisible(true); 

		scabbards_steel = GetWitcherPlayer().GetInventory().GetItemsByCategory('steel_scabbards');

		for ( i=0; i < scabbards_steel.Size() ; i+=1 )
		{
			scabbard_steel = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
			scabbard_steel.SetVisible(true);
		}

		scabbards_silver = GetWitcherPlayer().GetInventory().GetItemsByCategory('silver_scabbards');

		for ( i=0; i < scabbards_silver.Size() ; i+=1 )
		{
			scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
			scabbard_silver.SetVisible(true);
		}
		*/
	}
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon, rangedID);
	
	steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
	silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());

	steelsword.SetVisible(true); 

	steelswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
	steelswordentity.SetHideInGame(false); 

	silversword.SetVisible(true); 
	
	silverswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);
	silverswordentity.SetHideInGame(false); 

	scabbards_steel = GetWitcherPlayer().GetInventory().GetItemsByCategory('steel_scabbards');

	for ( i=0; i < scabbards_steel.Size() ; i+=1 )
	{
		scabbard_steel = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
		scabbard_steel.SetVisible(true);
	}

	scabbards_silver = GetWitcherPlayer().GetInventory().GetItemsByCategory('silver_scabbards');

	for ( i=0; i < scabbards_silver.Size() ; i+=1 )
	{
		scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
		scabbard_silver.SetVisible(true);
	}

	crossbowentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(rangedID);

	crossbowentity.SetHideInGame(false);

	if (!GetWitcherPlayer().IsInCombat())
	{
		if (GetWitcherPlayer().HasTag ('acs_summoned_shades'))
		{
			GetWitcherPlayer().RemoveTag('acs_summoned_shades');
		}
		
		if (GetWitcherPlayer().HasTag ('acs_ethereal_shout'))
		{
			GetWitcherPlayer().RemoveTag('acs_ethereal_shout');
		}
		
		if (GetWitcherPlayer().HasTag ('acs_vampire_claws_equipped'))
		{
			GetACSWatcher().ClawDestroy();

			GetWitcherPlayer().PlayEffectSingle('claws_effect');
			GetWitcherPlayer().StopEffect('claws_effect');
		}

		if (GetWitcherPlayer().HasTag ('acs_sorc_fists_equipped'))
		{
			GetACSWatcher().SorcFistDestroy();
		}
		
		if (GetWitcherPlayer().HasTag('Swords_Ready'))
		{
			GetWitcherPlayer().RemoveTag('Swords_Ready');
		}

		ACS_Skele_Destroy();

		ACS_Revenant_Destroy();
		
		theGame.GetGameCamera().StopEffect( 'frost' );

		GetWitcherPlayer().StopEffect('drain_energy');

		GetACSWatcher().Remove_On_Hit_Tags();

		GetACSWatcher().BerserkMarkDestroy();

		ACS_HybridTagRemoval();

		ACS_Axii_Shield_Destroy_IMMEDIATE();
	}

	ACS_ThingsThatShouldBeRemoved();

	//GetACSWatcher().UpdateBehGraph();

	ACSGetEquippedSword().StopAllEffects();
}

/*
statemachine class cWeaponHolster
{
    function WeaponHolster_Engage()
	{
		this.PushState('WeaponHolster_Engage');
	}
}

state WeaponHolster_Engage in cWeaponHolster
{
	private var steelID, silverID 				: SItemUniqueId;
	private var steelsword, silversword			: CDrawableComponent;
	
	event OnEnterState(prevStateName : name)
	{
		WeaponHolster();
		ACS_ThingsThatShouldBeRemoved();
	}
	
	entry function WeaponHolster()
	{
		if (GetWitcherPlayer().HasAbility('ForceFinisher'))
		{
			GetWitcherPlayer().RemoveAbility('ForceFinisher');
		}
					
		if (GetWitcherPlayer().HasAbility('ForceDismemberment'))
		{
			GetWitcherPlayer().RemoveAbility('ForceDismemberment');
		}

		if (GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_igni_sword_equipped_TAG')
		|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped_TAG'))
		{
			ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE();
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('acs_in_wraith'))
			{
				ACSGetEquippedSword().StopAllEffects();
				WeaponSummonEffect();
				//Sword();
			}

			ACS_Shield_Destroy();
		
			ACS_WeaponDestroyIMMEDIATEInit();
			
			Sword();
		}

		if (!GetWitcherPlayer().IsInCombat())
		{
			if (GetWitcherPlayer().HasTag ('acs_summoned_shades'))
			{
				GetWitcherPlayer().RemoveTag('acs_summoned_shades');
			}
			
			if (GetWitcherPlayer().HasTag ('acs_ethereal_shout'))
			{
				GetWitcherPlayer().RemoveTag('acs_ethereal_shout');
			}
			
			if (GetWitcherPlayer().HasTag ('acs_vampire_claws_equipped'))
			{
				ClawDestroy();

				GetWitcherPlayer().PlayEffectSingle('claws_effect');
				GetWitcherPlayer().StopEffect('claws_effect');
			}
			
			if (GetWitcherPlayer().HasTag('Swords_Ready'))
			{
				GetWitcherPlayer().RemoveTag('Swords_Ready');
			}

			ACS_Skele_Destroy();

			ACS_Revenant_Destroy();
			
			theGame.GetGameCamera().StopEffect( 'frost' );

			GetWitcherPlayer().StopEffect('drain_energy');

			GetACSWatcher().Remove_On_Hit_Tags();

			GetACSWatcher().BerserkMarkDestroy();

			ACS_HybridTagRemoval();

			ACS_Axii_Shield_Destroy_IMMEDIATE();
		}
	}
	
	latent function Sword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		steelsword.SetVisible(true); 
		silversword.SetVisible(true); 
	}

	latent function WeaponSummonEffect()
	{
		if ( ACS_GetWeaponMode() == 0 
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2 )
		{
			if (GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
			{
				//acs_quen_sword_summon();
				acs_igni_sword_summon();
			}
			else if (GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
			{
				//acs_axii_sword_summon();
				acs_igni_sword_summon();
			}
			else if (GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
			{
				//acs_aard_sword_summon();
				acs_igni_sword_summon();
			}
			else if (GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
			{
				//acs_yrden_sword_summon();
				acs_igni_sword_summon();
			}
			else if (GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
			{
				//acs_quen_secondary_sword_summon();
				acs_igni_sword_summon();
			}
			else if (GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
			{
				//acs_axii_secondary_sword_summon();
				acs_igni_sword_summon();
			}
			else if (GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
			{
				//acs_aard_secondary_sword_summon();
				acs_igni_sword_summon();
			}
			else if (GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
			{
				//acs_yrden_secondary_sword_summon();
				acs_igni_sword_summon();
			}

			//acs_igni_sword_summon();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
*/