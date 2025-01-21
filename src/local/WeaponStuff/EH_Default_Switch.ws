statemachine class cACS_DefaultSwitch
{
    function DefaultSwitch_Engage()
	{
		this.PushState('DefaultSwitch_Engage');
	}

	function DefaultSwitch_2_Engage()
	{
		this.PushState('DefaultSwitch_2_Engage');
	}
}
 
state DefaultSwitch_Engage in cACS_DefaultSwitch
{
	private var weapontype 														: EPlayerWeapon;
	private var item 															: SItemUniqueId;
	private var res 															: bool;
	private var inv 															: CInventoryComponent;
	private var tags 															: array<name>;
	private var settings														: SAnimatedComponentSlotAnimationSettings;
	private var trail_temp														: CEntityTemplate;
	private var sword_trail_1, sword_trail_2, sword_trail_3 					: CEntity;
	private var attach_rot														: EulerAngles;
	private var attach_vec														: Vector;
	private var stupidArray 													: array< name >;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		if (ACS_New_Replacers_Female_Active())
		{
			return false;
		}

		DefaultSwitch_PrimaryWeaponSwitch();
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (GetWitcherPlayer().IsWeaponHeld('fist'))
		{
			return PW_Fists;
		}
		else
		{
			return PW_None;
		}
	}

	function UpdateBehGraph( optional init : bool )
	{
		weapontype = GetCurrentMeleeWeapon();
		
		if ( weapontype == PW_None )
		{
			weapontype = PW_Fists;
		}
		
		if (thePlayer.GetBehaviorVariable( 'WeaponType') != 0)
		{
			GetWitcherPlayer().SetBehaviorVariable( 'WeaponType', 0);
		}
		
		if ( (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') 
		|| GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
		&& GetWitcherPlayer().IsInCombat() )
		{
			if (thePlayer.GetBehaviorVariable( 'playerWeapon') != (int) PW_Steel)
			{
				thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			}
			
			if (thePlayer.GetBehaviorVariable( 'playerWeaponForOverlay') != (int) PW_Steel)
			{
				thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
			}
		}
		else
		{
			if (thePlayer.GetBehaviorVariable( 'playerWeapon') != (int) weapontype)
			{
				thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			}
			
			if (thePlayer.GetBehaviorVariable( 'playerWeaponForOverlay') != (int) weapontype)
			{
				thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
			}
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			if (thePlayer.GetBehaviorVariable( 'isOnHorse') != 1.0)
			{
				thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
			}
		}
		else
		{
			if (thePlayer.GetBehaviorVariable( 'isOnHorse') != 0.0)
			{
				thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
			}
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				GetWitcherPlayer().SetBehaviorVariable( 'SelectedWeapon', 0, true);
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = GetWitcherPlayer().RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				GetWitcherPlayer().SetBehaviorVariable( 'SelectedWeapon', 1, true);
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = GetWitcherPlayer().RaiseEvent('DrawWeaponInstant');
				break;
			default:
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}
	
	entry function DefaultSwitch_PrimaryWeaponSwitch()
	{
		if 
		(
			GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped') 
			|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
		)
		{
			ACS_WeaponDestroyInit(false);

			trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

			sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

			sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

			sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;

			sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword_trail_1.AddTag('acs_sword_trail_1');

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.2;

			sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword_trail_2.AddTag('acs_sword_trail_2');

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.4;

			sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword_trail_3.AddTag('acs_sword_trail_3');

			ACSGetEquippedSwordUpdateEnhancements();

			GetWitcherPlayer().AddTag('acs_igni_sword_equipped');
			GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped');

			GetWitcherPlayer().AddTag('acs_igni_sword_equipped_TAG');
			GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped_TAG');

			if (ACS_GetItem_Aerondight() && !ACS_Armor_Equipped_Check() && !ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodIconicSwordVFXOffEnabled', false))
			{
				//ACSGetCEntity('acs_sword_trail_1').StopEffect('aerondight_glow_sword');

				if (ACS_GetItem_Aerondight_Steel_Held())
				{
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('aerondight_glow_sword_steel');
					ACSGetCEntity('acs_sword_trail_1').StopEffect('aerondight_glow_sword_steel');
				}
				else if (ACS_GetItem_Aerondight_Silver_Held())
				{
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('aerondight_glow_sword');
					ACSGetCEntity('acs_sword_trail_1').StopEffect('aerondight_glow_sword');
				}

				ACSGetCEntity('acs_sword_trail_2').StopEffect('charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('aerondight_special_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('aerondight_special_trail');
			}

			if (ACS_GetItem_Iris() && !ACS_Armor_Equipped_Check() && !ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodIconicSwordVFXOffEnabled', false))
			{
				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
			}

			if (ACS_Zireael_Check() && !ACS_Armor_Equipped_Check())
			{
				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_sword_fx');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_sword_fx');
			}

			if (GetWitcherPlayer().HasAbility('ForceFinisher'))
			{
				GetWitcherPlayer().RemoveAbility('ForceFinisher');
			}
					
			if (GetWitcherPlayer().HasAbility('ForceDismemberment'))
			{
				GetWitcherPlayer().RemoveAbility('ForceDismemberment');
			}

			if (!GetWitcherPlayer().IsSwimming()
			&& !GetWitcherPlayer().IsUsingHorse()
			&& !GetWitcherPlayer().IsUsingVehicle()
			)
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

					if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
					{
						thePlayer.GotoState('Combat');
					}
				}
			}
		}
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.


state DefaultSwitch_2_Engage in cACS_DefaultSwitch
{
	private var weapontype 																											: EPlayerWeapon;
	private var item 																												: SItemUniqueId;
	private var res 																												: bool;
	private var inv 																												: CInventoryComponent;
	private var tags 																												: array<name>;
	private var settings																											: SAnimatedComponentSlotAnimationSettings;
	private var steelsword, silversword, scabbard_steel, scabbard_silver															: CDrawableComponent;
	private var i 																													: int;
	private var scabbards_steel, scabbards_silver 																					: array<SItemUniqueId>;
	private var steelID, silverID, rangedID 																						: SItemUniqueId;
	private var steelswordentity, silverswordentity, crossbowentity, sword_trail_1, sword_trail_2, sword_trail_3 					: CEntity; 
	private var trail_temp																											: CEntityTemplate;
	private var attach_rot																											: EulerAngles;
	private var attach_vec																											: Vector;
	private var stupidArray 																										: array< name >;

	event OnEnterState(prevStateName : name)
	{
		if (ACS_New_Replacers_Female_Active())
		{
			return false;
		}
		
		ACS_WeaponDestroyInit(false);
		DefaultSwitch_2_PrimaryWeaponSwitch();
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (GetWitcherPlayer().IsWeaponHeld('fist'))
		{
			return PW_Fists;
		}
		else
		{
			return PW_None;
		}
	}

	function UpdateBehGraph( optional init : bool )
	{
		weapontype = GetCurrentMeleeWeapon();
		
		if ( weapontype == PW_None )
		{
			weapontype = PW_Fists;
		}
		
		if (thePlayer.GetBehaviorVariable( 'WeaponType') != 0)
		{
			GetWitcherPlayer().SetBehaviorVariable( 'WeaponType', 0);
		}
		
		if ( (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') 
		|| GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
		&& GetWitcherPlayer().IsInCombat() )
		{
			if (thePlayer.GetBehaviorVariable( 'playerWeapon') != (int) PW_Steel)
			{
				thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			}
			
			if (thePlayer.GetBehaviorVariable( 'playerWeaponForOverlay') != (int) PW_Steel)
			{
				thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
			}
		}
		else
		{
			if (thePlayer.GetBehaviorVariable( 'playerWeapon') != (int) weapontype)
			{
				thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			}
			
			if (thePlayer.GetBehaviorVariable( 'playerWeaponForOverlay') != (int) weapontype)
			{
				thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
			}
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			if (thePlayer.GetBehaviorVariable( 'isOnHorse') != 1.0)
			{
				thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
			}
		}
		else
		{
			if (thePlayer.GetBehaviorVariable( 'isOnHorse') != 0.0)
			{
				thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
			}
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				GetWitcherPlayer().SetBehaviorVariable( 'SelectedWeapon', 0, true);
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = GetWitcherPlayer().RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				GetWitcherPlayer().SetBehaviorVariable( 'SelectedWeapon', 1, true);
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = GetWitcherPlayer().RaiseEvent('DrawWeaponInstant');
				break;
			default:
				GetWitcherPlayer().SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}

	entry function DefaultSwitch_2_PrimaryWeaponSwitch()
	{
		if (ACS_CloakEquippedCheck() || ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodHideSwordsheathes', false))
		{
			acs_igni_sword_summon();
		}

		ACSGetEquippedSwordUpdateEnhancements();

		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_RangedWeapon, rangedID);
		
		steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());

		scabbards_steel.Clear();

		scabbards_silver.Clear();

		scabbards_steel = GetWitcherPlayer().GetInventory().GetItemsByCategory('steel_scabbards');

		scabbards_silver = GetWitcherPlayer().GetInventory().GetItemsByCategory('silver_scabbards');

		steelswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);

		silverswordentity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0;

		sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_1.AddTag('acs_sword_trail_1');

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.2;

		sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_2.AddTag('acs_sword_trail_2');

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.4;

		sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_3.AddTag('acs_sword_trail_3');

		if (ACS_GetItem_Aerondight() && !ACS_Armor_Equipped_Check() && !ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodIconicSwordVFXOffEnabled', false) )
		{
			//ACSGetCEntity('acs_sword_trail_1').StopEffect('aerondight_glow_sword');

			if (ACS_GetItem_Aerondight_Steel_Held())
			{
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('aerondight_glow_sword_steel');
				ACSGetCEntity('acs_sword_trail_1').StopEffect('aerondight_glow_sword_steel');
			}
			else if (ACS_GetItem_Aerondight_Silver_Held())
			{
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('aerondight_glow_sword');
				ACSGetCEntity('acs_sword_trail_1').StopEffect('aerondight_glow_sword');
			}

			ACSGetCEntity('acs_sword_trail_2').StopEffect('charge_10');
			ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('charge_10');

			ACSGetCEntity('acs_sword_trail_2').StopEffect('aerondight_special_trail');
			ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('aerondight_special_trail');
		}

		if (ACS_GetItem_Iris() && !ACS_Armor_Equipped_Check() && !ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodIconicSwordVFXOffEnabled', false))
		{
			ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
			ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

			ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
			ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
		}

		if (ACS_Zireael_Check() && !ACS_Armor_Equipped_Check())
		{
			ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_sword_fx');
			ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_sword_fx');
		}

		if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) )
		{
			//steelsword.SetVisible(true);

			steelswordentity.SetHideInGame(false); 

		}
		else if( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
		{
			//silversword.SetVisible(true);

			silverswordentity.SetHideInGame(false); 
		}

		if (!ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodHideSwordsheathes', false) && !ACS_CloakEquippedCheck())
		{
			if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) )
			{
				//steelsword.SetVisible(true);

				steelswordentity.SetHideInGame(false); 

			}
			else if( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
			{
				//silversword.SetVisible(true);

				silverswordentity.SetHideInGame(false); 
			}

			for ( i=0; i < scabbards_steel.Size() ; i+=1 )
			{
				scabbard_steel = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
				scabbard_steel.SetVisible(true);
			}

			for ( i=0; i < scabbards_silver.Size() ; i+=1 )
			{
				scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
				scabbard_silver.SetVisible(true);
			}
		}
		else if (ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodHideSwordsheathes', false))
		{
			if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) )
			{
				//steelsword.SetVisible(true);

				steelswordentity.SetHideInGame(false); 

				//silversword.SetVisible(false);

				silverswordentity.SetHideInGame(true); 

			}
			else if( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
			{
				//silversword.SetVisible(true);

				silverswordentity.SetHideInGame(false); 

				steelsword.SetVisible(false); 

				steelswordentity.SetHideInGame(true); 
			}

			for ( i=0; i < scabbards_steel.Size() ; i+=1 )
			{
				scabbard_steel = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
				scabbard_steel.SetVisible(false);
			}

			for ( i=0; i < scabbards_silver.Size() ; i+=1 )
			{
				scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
				scabbard_silver.SetVisible(false);
			}
		}

		if 
		(
		!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0 );
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

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

				if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
				{
					thePlayer.GotoState('Combat');
				}
			}
		}
	}
}