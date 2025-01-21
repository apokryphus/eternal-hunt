function ACS_RandomWeaponEquipInit()
{
	if ( ACS_Enabled() && !ACS_New_Replacers_Female_Active() && !thePlayer.IsCiri() )
	{	
		if (ACS_Armor_Equipped_Check())
		{
			thePlayer.SoundEvent("monster_caretaker_vo_taunt_long");
		}
		
		ACS_ThingsThatShouldBeRemoved(true);

		if (!thePlayer.HasTag('ACS_Drawn_Weapon'))
		{
			thePlayer.AddTag('ACS_Drawn_Weapon');
		}

		GetACSWatcher().RemoveTimer('Drawn_Weapon_Reset');
		GetACSWatcher().AddTimer('Drawn_Weapon_Reset', ACS_Settings_Main_Float('EHmodHudSettings','EHmodHudElementsDespawnDelay', 3), false);

		if (ACS_Zireael_Check() && GetWitcherPlayer().IsDeadlySwordHeld())
		{
			GetWitcherPlayer().StopEffect('fury_ciri');
			GetWitcherPlayer().PlayEffectSingle('fury_ciri');

			GetWitcherPlayer().StopEffect('fury_403_ciri');
			GetWitcherPlayer().PlayEffectSingle('fury_403_ciri');
			
			GetWitcherPlayer().StopEffect('acs_fury_ciri');
			GetWitcherPlayer().PlayEffectSingle( 'acs_fury_ciri' );

			ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_sword_fx');
			ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_sword_fx');
		}
		
		if ( ACS_GetWeaponMode() == 0 )
		{
			ACS_ArmmigerModeWeaponEquipInit();
		}
		else if ( ACS_GetWeaponMode() == 1 )
		{
			ACS_FocusModeWeaponEquipInit();
		}
		else if ( ACS_GetWeaponMode() == 2 )
		{
			ACS_HybridModeWeaponEquipInit();
		}
		else if ( ACS_GetWeaponMode() == 3 )
		{
			ACS_EquipmentModeWeaponEquipInit();
		}
	}
}

function ACS_ArmmigerModeWeaponEquipInit()
{
	if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
	{
		if ( 
		(GetWitcherPlayer().GetEquippedSign() == ST_Quen 
		&& ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
		||
		(GetWitcherPlayer().GetEquippedSign() == ST_Aard 
		&& ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
		||
		(GetWitcherPlayer().GetEquippedSign() == ST_Axii 
		&& ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
		||
		(GetWitcherPlayer().GetEquippedSign() == ST_Yrden 
		&& ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
		||
		( GetWitcherPlayer().GetEquippedSign() == ST_Igni 
		&& ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)				
		)
		{
			if ( GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') )
			{
				GetACSWatcher().ClawDestroy_WITH_EFFECT();
			}
			else if ( GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
			{
				GetACSWatcher().SorcFistDestroy();
			}

			GetACSWatcher().DefaultSwitch_2();

			GetWitcherPlayer().AddTag('acs_igni_sword_equipped');
			GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped');	
			GetWitcherPlayer().AddTag('acs_igni_sword_effect_played');
			GetWitcherPlayer().AddTag('acs_igni_secondary_sword_effect_played');	
		}
		else
		{
			GetACSWatcher().PrimaryWeaponSwitch();
		}	
	}
	else if 
	(
		GetWitcherPlayer().IsWeaponHeld( 'fist' )
	)
	{
		GetACSWatcher().PrimaryWeaponSwitch();
	}
	
	if (GetWitcherPlayer().IsInCombat()) {GetACSWatcher().EquipTauntInit();}
}

function ACS_FocusModeWeaponEquipInit()
{
	if 
	(
		(ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
	)
	{
		if ( GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') )
		{
			GetACSWatcher().ClawDestroy_WITH_EFFECT();
		}
		else if ( GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
		{
			GetACSWatcher().SorcFistDestroy();
		}

		GetACSWatcher().DefaultSwitch_2();

		GetWitcherPlayer().AddTag('acs_igni_sword_equipped');
		GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped');	
		GetWitcherPlayer().AddTag('acs_igni_sword_effect_played');
		GetWitcherPlayer().AddTag('acs_igni_secondary_sword_effect_played');	
	}
	else if
	(
		(ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
		|| (GetWitcherPlayer().IsWeaponHeld( 'fist' ) && !GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') && !GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
	)
	{
		GetACSWatcher().PrimaryWeaponSwitch();
	}
	else if  
	(
		(ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
	)
	{
		GetACSWatcher().SecondaryWeaponSwitch();
	}
	
	if (GetWitcherPlayer().IsInCombat()) {GetACSWatcher().EquipTauntInit();}
}

function ACS_HybridModeWeaponEquipInit()
{
	if 
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
	)
	{
		ACS_WeaponDestroyInit(false);

		GetACSWatcher().DefaultSwitch_2();
		
		GetWitcherPlayer().AddTag('acs_igni_sword_equipped');
		GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped');	
		GetWitcherPlayer().AddTag('acs_igni_sword_effect_played');
		GetWitcherPlayer().AddTag('acs_igni_secondary_sword_effect_played');	
	}
	else if 
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 2  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
	)
	{
		GetWitcherPlayer().AddTag('ACSHybridEredinWeaponTicket');
		GetACSWatcher().PrimaryWeaponSwitch();
	}
	else if 
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 3  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
	)
	{
		GetWitcherPlayer().AddTag('ACSHybridClawWeaponTicket');
		GetACSWatcher().PrimaryWeaponSwitch();
	}
	else if 
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
	)
	{
		GetWitcherPlayer().AddTag('ACSHybridImlerithWeaponTicket');
		GetACSWatcher().PrimaryWeaponSwitch();
	}
	else if 
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
	)
	{
		GetWitcherPlayer().AddTag('ACSHybridOlgierdWeaponTicket');
		GetACSWatcher().PrimaryWeaponSwitch();
	}
	else if  
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
	)
	{
		GetWitcherPlayer().AddTag('ACSHybridGregWeaponTicket');
		GetACSWatcher().SecondaryWeaponSwitch();
	}
	else if  
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 7  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
	)
	{
		GetWitcherPlayer().AddTag('ACSHybridAxeWeaponTicket');
		GetACSWatcher().SecondaryWeaponSwitch();
	}
	else if  
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 8  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
	)
	{
		GetWitcherPlayer().AddTag('ACSHybridGiantWeaponTicket');
		GetACSWatcher().SecondaryWeaponSwitch();
	}
	else if  
	(
		(ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
		|| (ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
	)
	{
		GetWitcherPlayer().AddTag('ACSHybridSpearWeaponTicket');
		GetACSWatcher().SecondaryWeaponSwitch();
	}
	else if 
	(
		GetWitcherPlayer().IsWeaponHeld( 'fist' )
	)
	{
		GetACSWatcher().PrimaryWeaponSwitch();
	}
	
	if (GetWitcherPlayer().IsInCombat()) {GetACSWatcher().EquipTauntInit();}
}

function ACS_EquipmentModeWeaponEquipInit()
{
	if 
	(
		( ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
		|| ( ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
		|| ( ACS_GetItem_Claws_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
		|| ( ACS_GetItem_Claws_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
		|| ( ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
		|| ( ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
		|| ( ACS_GetItem_MageStaff_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
		|| ( ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
		|| ( ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
		|| ( GetWitcherPlayer().IsWeaponHeld( 'fist' ) && !GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') && !GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
	)
	{
		GetACSWatcher().PrimaryWeaponSwitch();
	}
	else if  
	(
		( ACS_GetItem_Greg_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
		|| ( ACS_GetItem_Greg_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
		|| ( ACS_GetItem_Axe_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
		|| ( ACS_GetItem_Axe_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
		|| ( ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
		|| ( ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
		|| ( ACS_GetItem_Spear_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
		|| ( ACS_GetItem_Spear_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
		|| ( ACS_GetItem_Katana_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
		|| ( ACS_GetItem_Katana_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
	)
	{
		GetACSWatcher().SecondaryWeaponSwitch();
	}
	else
	{
		GetACSWatcher().DefaultSwitch();
	}
	
	if (GetWitcherPlayer().IsInCombat()) {GetACSWatcher().EquipTauntInit();}
}


function ACS_Equip_Weapon(weaponType : EPlayerWeapon)
{
	if ( ACS_Enabled() && !ACS_New_Replacers_Female_Active() && !thePlayer.IsCiri()) 
	{
		GetACSWatcher().register_extra_inputs();

		ACS_WeaponDestroyInit(false);

		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');
			GetACSWatcher().AddTimer('ACS_WeaponEquipDelay', 0.15, false);
		}
		else
		{
			ACS_WeaponHolsterInit();
		}
	}
}