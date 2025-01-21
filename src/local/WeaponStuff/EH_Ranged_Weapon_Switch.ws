statemachine class cACS_RangedWeaponSwitch
{
    function Engage()
	{
		this.PushState('ACS_RangedWeaponSwitch_Engage');
	}
}
 
state ACS_RangedWeaponSwitch_Engage in cACS_RangedWeaponSwitch
{
	private var steelID, silverID 						: SItemUniqueId;
	private var steelsword, silversword					: CDrawableComponent;
	private var attach_vec								: Vector;
	private var attach_rot								: EulerAngles;
	private var sword1, sword2							: CEntity;
	private var weapontype 								: EPlayerWeapon;
	private var res 									: bool;
	
	event OnEnterState(prevStateName : name)
	{
		LockEntryFunction(true);
		RangedWeaponSwitch();
		LockEntryFunction(false);
	}
	
	entry function RangedWeaponSwitch()
	{
		ACS_HideSwordWitoutScabbardStuff();

		ACS_BowHandSwitch(false);
		
		ACS_ExplorationDelayHack();
		
		if
		(
			(GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
			|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		)
		{
			if (FactsQuerySum("ACS_Azkar_Active") > 0
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_bow_equipped'))
				{
					BowCreate();

					BowSwitch();
				}
				else
				{
					if (!ACSGetCEntity('acs_bow'))
					{
						BowCreate();
					}
				}
			}
			else if (GetWitcherPlayer().HasTag('acs_crossbow_active'))
			{
				if (!GetWitcherPlayer().HasTag('acs_crossbow_equipped'))
				{
					CrossbowCreate();

					CrossbowSwitch();
				}
				else
				{
					if (!ACSGetCEntity('acs_crossbow'))
					{
						CrossbowCreate();
					}
				}
			}
		}

		Sleep(0.125);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function GetCurrentMeleeWeapon() : EPlayerWeapon
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

	latent function UpdateBehGraph( optional init : bool )
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

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BowSwitch()
	{
		var stupidArray 							: array< name >;
		
		if (!GetWitcherPlayer().HasAbility('ForceDismemberment'))
		{
			GetWitcherPlayer().AddAbility('ForceDismemberment');
		}

		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_SCAAR' )
				{
					
					
					stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh_E3ARP' )
				{
					
					
					stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
				}
			}
			else
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_bow_beh' )
				{
					
					
					stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
				}
			}
					
			if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0 );
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				thePlayer.ActivateBehaviors(stupidArray);

				if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
				{
					thePlayer.GotoState('Combat');
				}
			}

			UpdateBehGraph();
		}
	}

	latent function BowCreate()
	{
		if (ACSGetCEntity('acs_bow'))
		{
			return;
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0)
		{
			AzkarBow();
		}
		else
		{
			if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 0 )
			{
				BowEvolving();
			}
			else if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 1 )
			{
				BowStatic();
			}
		}
		
		GetWitcherPlayer().AddTag('acs_bow_equipped');
	}

	latent function BowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit(true);

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_bow');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_bow');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_acs\data\entities\ranged\bow_azkar.w2ent" 
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_bow');
				sword1.PlayEffect('ghost_06');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_acs\data\entities\ranged\bow_azkar.w2ent" 
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_bow');
				sword1.PlayEffect('ghost_06');
			}
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent" 
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_bow');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_bow');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_acs\data\entities\ranged\bow_azkar.w2ent" 
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_bow');
				sword1.PlayEffect('ghost_06');
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_acs\data\entities\ranged\bow_azkar.w2ent" 
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_bow');
				sword1.PlayEffect('ghost_06');
			}
		}
	}

	latent function BowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit(true);

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 
				
			, true), GetWitcherPlayer().GetWorldPosition() );

		}
		else
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 
				
			, true), GetWitcherPlayer().GetWorldPosition() );
		}
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = -0.025;
		attach_vec.Z = -0.045;
			
		sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
		sword1.AddTag('acs_bow');
	}

	latent function AzkarBow()
	{
		ACS_WeaponDestroyInit(true);

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\ranged\bow_azkar.w2ent" 
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = -0.025;
		attach_vec.Z = -0.045;
			
		sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
		sword1.AddTag('acs_bow');
		sword1.PlayEffect('ghost_06');

		GetACSWatcher().AzkarFXCreate();
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function CrossbowSwitch()
	{	
		var stupidArray 							: array< name >;

		if (!GetWitcherPlayer().HasAbility('ForceDismemberment'))
		{
			GetWitcherPlayer().AddAbility('ForceDismemberment');
		}

		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_SCAAR' )
				{
					
					
					stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh_E3ARP' )
				{
					
					
					stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
				}
			}
			else
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_crossbow_beh' )
				{
					
					
					stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
				}
			}
					
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

	latent function CrossbowCreate()
	{
		if (ACSGetCEntity('acs_crossbow'))
		{
			return;
		}

		CrossbowStatic();
		
		GetWitcherPlayer().AddTag('acs_crossbow_equipped');
	}

	latent function CrossbowStatic()
	{
		ACS_WeaponDestroyInit(true);
		
		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\ranged\acs_wolf_crossbow_fake.w2ent"
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = -90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 180;
		attach_vec.X = -0.125; // + forward - backward
		attach_vec.Y = 0; // + left - right
		attach_vec.Z = 0.06125; // + up - down
			
		sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('acs_crossbow');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.