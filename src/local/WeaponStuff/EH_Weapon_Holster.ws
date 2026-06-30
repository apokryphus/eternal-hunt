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
	
	if ( ACS_Settings_Main_Bool('acs_main_settings','acs_mod_enabled', true) && !thePlayer.IsCiri() )
	{
		GetACSWatcher().Weapon_Summon_Effect_Delay();
		vWeaponHolster.WeaponHolster_Engage();
	}
	*/

	GetACSWatcher().register_extra_inputs();

	if (ACS_Armor_Set_Check('acs_armor', false))
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

	GetWitcherPlayer().StopEffect('fury_ciri');

	GetWitcherPlayer().StopEffect('fury_403_ciri');

	GetWitcherPlayer().StopEffect('acs_fury_ciri');

	GetWitcherPlayer().StopEffect('teleport_glow_ciri');

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

	if (GetACSWatcher().idleAdditiveExtraActive)
	{
		thePlayer.RaiseEvent('ACS_IdleAdditiveReset');

		GetACSWatcher().SetIdleAdditiveExtraStatus(false);
	}

	if (GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_igni_sword_equipped_TAG')
	|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped_TAG'))
	{
		if ( ACS_GetWeaponMode() == 0 
		|| ACS_GetWeaponMode() == 1
		|| ACS_GetWeaponMode() == 2 )
		{
			if (
			(ACS_CloakEquippedCheck() && (ACS_Settings_Main_Int ('acs_player_equipment_visual_settings','acs_swords_positioning_when_cloaked', 0, true) == 1 || FactsQuerySum("ACS_Force_Weapons_On_Hips") > 0)) 
			|| ACS_Settings_Main_Bool('acs_player_equipment_visual_settings','acs_hide_sword_sheathes', false)
			)
			{
				GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
				GetWitcherPlayer().StopEffect('embers_particles_test');
				ACSSwordSummonEffect('igni');
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
					//ACSSwordSummonEffect('quen');
					ACSSwordSummonEffect('igni');
				}
				else if (GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//ACSSwordSummonEffect('axii');
					ACSSwordSummonEffect('igni');
				}
				else if (GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//ACSSwordSummonEffect('aard');
					ACSSwordSummonEffect('igni');
				}
				else if (GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//ACSSwordSummonEffect('yrden');
					ACSSwordSummonEffect('igni');
				}
				else if (GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//ACSSwordSummonEffect('quen_secondary');
					ACSSwordSummonEffect('igni');
				}
				else if (GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//ACSSwordSummonEffect('axii_secondary');
					ACSSwordSummonEffect('igni');
				}
				else if (GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//ACSSwordSummonEffect('aard_secondary');
					ACSSwordSummonEffect('igni');
				}
				else if (GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
				{
					GetWitcherPlayer().PlayEffectSingle('embers_particles_test');
					GetWitcherPlayer().StopEffect('embers_particles_test');
					//ACSSwordSummonEffect('yrden_secondary');
					ACSSwordSummonEffect('igni');
				}
			}

			//Sword();
		}

		ACS_Axii_Shield_Destroy();
		ACS_Axii_Shield_Destroy_DELAY();
		ACS_Quen_Monsters_Despawn();
		ACS_Bruxa_Camo_Decoy_Deactivate();
		ACS_AardPull_Deactivate();
	
		ACS_WeaponDestroyInit();

	}

	GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 

	if (thePlayer.IsDeadlySwordHeld())
	{
		GetACSWatcher().AddTimer('SwordTauntRunningSwitch', 0.01 / theGame.GetTimeScale(), false );
	}
	
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon, rangedID);
	
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

		ACSGetCEntityDestroyAll('ACS_BerserkMark');

		ACS_HybridTagRemoval();

		ACS_Axii_Shield_Destroy_IMMEDIATE();
	}

	ACS_ThingsThatShouldBeRemoved();

	ACSGetEquippedSword().StopAllEffects();
}