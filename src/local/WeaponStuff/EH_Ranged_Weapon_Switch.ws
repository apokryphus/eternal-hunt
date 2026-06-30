statemachine class cACS_RangedWeaponSwitch
{
    function ACS_RangedWeaponSwitch_Engage()
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
		GetACSWatcher().RemoveTimer('ForceControlModuleHudUpdate');
		GetACSWatcher().AddTimer('ForceControlModuleHudUpdate', 0.25f , false);
		
		ACS_BowHandSwitch(false);
		
		ACS_ExplorationDelayHack(false, 3);
		
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
			else if (FactsQuerySum("ACS_Slayer_Active") > 0)
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
			ACS_WeaponDestroyInit();

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
		
		GetWitcherPlayer().AddTag('acs_bow_equipped');
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

		if (FactsQuerySum("ACS_Slayer_Active") > 0)
		{
			ACS_WeaponDestroyInit();
			
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_acs\data\entities\ranged\acs_wolf_crossbow_fake.w2ent"

			"dlc\dlc_acs\data\entities\ranged\shotgun_1.w2ent" 
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0; // + forward - backward
			attach_vec.Y = 0; // + left - right
			attach_vec.Z = 0; // + up - down
				
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_crossbow');
		}
		
		GetWitcherPlayer().AddTag('acs_crossbow_equipped');
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.