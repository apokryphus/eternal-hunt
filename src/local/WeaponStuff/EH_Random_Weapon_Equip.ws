function ACS_RandomWeaponEquipInit()
{
	if ( ACS_Enabled() && !ACS_New_Replacers_Female_Active() && !thePlayer.IsCiri() )
	{	
		if (ACS_Armor_Equipped_Check())
		{
			thePlayer.SoundEvent("monster_caretaker_vo_taunt_long");
		}
		
		ACS_ThingsThatShouldBeRemoved();

		if (!thePlayer.HasTag('ACS_Drawn_Weapon'))
		{
			thePlayer.AddTag('ACS_Drawn_Weapon');
		}

		GetACSWatcher().RemoveTimer('Drawn_Weapon_Reset');
		GetACSWatcher().AddTimer('Drawn_Weapon_Reset', ACS_Hud_Elements_Despawn_Delay(), false);

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
			if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) || GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( 
				(GetWitcherPlayer().GetEquippedSign() == ST_Quen 
				&& ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
				||
				(GetWitcherPlayer().GetEquippedSign() == ST_Aard 
				&& ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
				||
				(GetWitcherPlayer().GetEquippedSign() == ST_Axii 
				&& ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
				||
				(GetWitcherPlayer().GetEquippedSign() == ST_Yrden 
				&& ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
				||
				( GetWitcherPlayer().GetEquippedSign() == ST_Igni 
				&& ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)				
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
		else if ( ACS_GetWeaponMode() == 1 )
		{
			if 
			(
				(ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
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
				(ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
				|| (ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
				|| (ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
				|| (ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
				|| (GetWitcherPlayer().IsWeaponHeld( 'fist' ) && !GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') && !GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
			)
			{
				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if  
			(
				(ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
				|| (ACS_GetFocusModeSilverWeapon() == 8  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
				|| (ACS_GetFocusModeSilverWeapon() == 6  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
				|| (ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
				|| (ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
			)
			{
				GetACSWatcher().SecondaryWeaponSwitch();
			}
			
			if (GetWitcherPlayer().IsInCombat()) {GetACSWatcher().EquipTauntInit();}
		}
		else if ( ACS_GetWeaponMode() == 2 )
		{
			if 
			(
				(ACS_GetHybridModeLightAttack() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
			)
			{
				ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE();

				GetACSWatcher().DefaultSwitch_2();
				
				GetWitcherPlayer().AddTag('acs_igni_sword_equipped');
				GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped');	
				GetWitcherPlayer().AddTag('acs_igni_sword_effect_played');
				GetWitcherPlayer().AddTag('acs_igni_secondary_sword_effect_played');	
			}
			else if 
			(
				(ACS_GetHybridModeLightAttack() == 2  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
			)
			{
				GetWitcherPlayer().AddTag('HybridEredinWeaponTicket');
				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if 
			(
				(ACS_GetHybridModeLightAttack() == 3  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
			)
			{
				GetWitcherPlayer().AddTag('HybridClawWeaponTicket');
				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if 
			(
				(ACS_GetHybridModeLightAttack() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
			)
			{
				GetWitcherPlayer().AddTag('HybridImlerithWeaponTicket');
				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if 
			(
				(ACS_GetHybridModeLightAttack() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
			)
			{
				GetWitcherPlayer().AddTag('HybridOlgierdWeaponTicket');
				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if  
			(
				(ACS_GetHybridModeLightAttack() == 6 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
			)
			{
				GetWitcherPlayer().AddTag('HybridGregWeaponTicket');
				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if  
			(
				(ACS_GetHybridModeLightAttack() == 7  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
			)
			{
				GetWitcherPlayer().AddTag('HybridAxeWeaponTicket');
				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if  
			(
				(ACS_GetHybridModeLightAttack() == 8  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
			)
			{
				GetWitcherPlayer().AddTag('HybridGiantWeaponTicket');
				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if  
			(
				(ACS_GetHybridModeLightAttack() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
				|| (ACS_GetHybridModeLightAttack() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
			)
			{
				GetWitcherPlayer().AddTag('HybridSpearWeaponTicket');
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
		else if ( ACS_GetWeaponMode() == 3 )
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
	}
}

function ACS_Equip_Weapon(weaponType : EPlayerWeapon)
{
	if ( ACS_Enabled() && !ACS_New_Replacers_Female_Active() && !thePlayer.IsCiri()) 
	{
		GetACSWatcher().register_extra_inputs();

		ACS_WeaponDestroyInit_WITHOUT_HIDESWORD_IMMEDIATE();

		GetACSWatcher().RemoveTimer( 'ACS_DelayedSheathSword' );

		if (GetWitcherPlayer().IsAnyWeaponHeld())
		{
			if (ACS_CloakEquippedCheck() || ACS_HideSwordsheathes_Enabled())
			{
				ACS_RandomWeaponEquipInit();
			}
			else
			{
				GetACSWatcher().RemoveTimer('ACS_WeaponEquipDelay');
				GetACSWatcher().AddTimer('ACS_WeaponEquipDelay', 0.15, false);
			}
		}
		else
		{
			ACS_WeaponHolsterInit();
		}
	}
}