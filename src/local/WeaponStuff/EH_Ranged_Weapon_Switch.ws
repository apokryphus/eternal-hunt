statemachine class cACS_RangedWeaponSwitch
{
    function Engage()
	{
		this.PushState('Engage');
	}
}
 
state Engage in cACS_RangedWeaponSwitch
{
	private var steelID, silverID 						: SItemUniqueId;
	private var steelsword, silversword					: CDrawableComponent;
	private var attach_vec								: Vector;
	private var attach_rot								: EulerAngles;
	private var sword1, sword2							: CEntity;
	
	event OnEnterState(prevStateName : name)
	{
		LockEntryFunction(true);
		RangedWeaponSwitch();
		LockEntryFunction(false);
	}
	
	entry function RangedWeaponSwitch()
	{
		ACS_HideSwordWitoutScabbardStuff();
		
		if
		(
			(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			&& (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
			|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		)
		{
			if (GetWitcherPlayer().HasTag('acs_bow_active'))
			{
				if (!GetWitcherPlayer().HasTag('igni_bow_equipped'))
				{
					IgniBow();

					BowSwitch();
				}
			}
			else if (GetWitcherPlayer().HasTag('acs_crossbow_active'))
			{
				if (!GetWitcherPlayer().HasTag('igni_crossbow_equipped'))
				{
					IgniCrossbow();

					CrossbowSwitch();
				}
			}
		}
		else if
		(
			(GetWitcherPlayer().GetEquippedSign() == ST_Quen)
			&& (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
			|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		)
		{
			if (GetWitcherPlayer().HasTag('acs_bow_active'))
			{
				if (!GetWitcherPlayer().HasTag('quen_bow_equipped'))
				{
					QuenBow();

					BowSwitch();
				}
			}
			else if (GetWitcherPlayer().HasTag('acs_crossbow_active'))
			{
				if (!GetWitcherPlayer().HasTag('quen_crossbow_equipped'))
				{
					QuenCrossbow();

					CrossbowSwitch();
				}
			}
		}
		else if
		(
			(GetWitcherPlayer().GetEquippedSign() == ST_Aard)
			&& (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
			|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		)
		{
			if (GetWitcherPlayer().HasTag('acs_bow_active'))
			{
				if (!GetWitcherPlayer().HasTag('aard_bow_equipped'))
				{
					AardBow();

					BowSwitch();
				}
			}
			else if (GetWitcherPlayer().HasTag('acs_crossbow_active'))
			{
				if (!GetWitcherPlayer().HasTag('aard_crossbow_equipped'))
				{
					AardCrossbow();

					CrossbowSwitch();
				}
			}
		}
		else if
		(
			(GetWitcherPlayer().GetEquippedSign() == ST_Axii)
			&& (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
			|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		)
		{
			if (GetWitcherPlayer().HasTag('acs_bow_active'))
			{
				if (!GetWitcherPlayer().HasTag('axii_bow_equipped'))
				{
					AxiiBow();

					BowSwitch();
				}
			}
			else if (GetWitcherPlayer().HasTag('acs_crossbow_active'))
			{
				if (!GetWitcherPlayer().HasTag('axii_crossbow_equipped'))
				{
					AxiiCrossbow();

					CrossbowSwitch();
				}
			}
		}
		else if
		(
			(GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
			&& (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
			|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		)
		{
			if (GetWitcherPlayer().HasTag('acs_bow_active'))
			{
				if (!GetWitcherPlayer().HasTag('yrden_bow_equipped'))
				{
					YrdenBow();

					BowSwitch();
				}
			}
			else if (GetWitcherPlayer().HasTag('acs_crossbow_active'))
			{
				if (!GetWitcherPlayer().HasTag('yrden_crossbow_equipped'))
				{
					YrdenCrossbow();

					CrossbowSwitch();
				}
			}
		}

		Sleep(0.125);

		WeaponSummonEffect();
	}
	

	latent function WeaponSummonEffect()
	{
		if (GetWitcherPlayer().HasTag('igni_bow_equipped')
		&& !GetWitcherPlayer().HasTag('igni_bow_effect_played'))
		{
			igni_bow_summon();

			GetWitcherPlayer().AddTag('igni_bow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('axii_bow_equipped')
		&& !GetWitcherPlayer().HasTag('axii_bow_effect_played'))
		{
			axii_bow_summon();

			GetWitcherPlayer().AddTag('axii_bow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('aard_bow_equipped')
		&& !GetWitcherPlayer().HasTag('aard_bow_effect_played'))
		{
			aard_bow_summon();

			GetWitcherPlayer().AddTag('aard_bow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('yrden_bow_equipped')
		&& !GetWitcherPlayer().HasTag('yrden_bow_effect_played'))
		{
			yrden_bow_summon();

			GetWitcherPlayer().AddTag('yrden_bow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('quen_bow_equipped')
		&& !GetWitcherPlayer().HasTag('quen_bow_effect_played'))
		{
			quen_bow_summon();

			GetWitcherPlayer().AddTag('quen_bow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('igni_crossbow_equipped')
		&& !GetWitcherPlayer().HasTag('igni_crossbow_effect_played'))
		{
			igni_crossbow_summon();

			GetWitcherPlayer().AddTag('igni_crossbow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('axii_crossbow_equipped')
		&& !GetWitcherPlayer().HasTag('axii_crossbow_effect_played'))
		{
			axii_crossbow_summon();

			GetWitcherPlayer().AddTag('axii_crossbow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('aard_crossbow_equipped')
		&& !GetWitcherPlayer().HasTag('aard_crossbow_effect_played'))
		{
			aard_crossbow_summon();

			GetWitcherPlayer().AddTag('aard_crossbow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('yrden_crossbow_equipped')
		&& !GetWitcherPlayer().HasTag('yrden_crossbow_effect_played'))
		{
			yrden_crossbow_summon();

			GetWitcherPlayer().AddTag('yrden_crossbow_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('quen_crossbow_equipped')
		&& !GetWitcherPlayer().HasTag('quen_crossbow_effect_played'))
		{
			quen_crossbow_summon();

			GetWitcherPlayer().AddTag('quen_crossbow_effect_played');
		}
	}

	latent function BowSwitch()
	{		
		if (!GetWitcherPlayer().HasAbility('ForceDismemberment'))
		{
			GetWitcherPlayer().AddAbility('ForceDismemberment');
		}

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_bow_beh' );
			}
					
			if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
			{
				//GetWitcherPlayer().GotoState( 'Combat' );
			}
		}
	}

	latent function CrossbowSwitch()
	{		
		if (!GetWitcherPlayer().HasAbility('ForceDismemberment'))
		{
			GetWitcherPlayer().AddAbility('ForceDismemberment');
		}

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				GetWitcherPlayer().ActivateAndSyncBehavior( 'acs_crossbow_beh' );
			}
					
			if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
			{
				//GetWitcherPlayer().GotoState( 'Combat' );
			}
		}
	}
	
	latent function IgniBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			IgniBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			IgniBowStatic();
		}
		
		GetWitcherPlayer().AddTag('igni_bow_equipped');
	}

	latent function IgniBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
				sword1.AddTag('igni_bow_1');
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
				sword1.AddTag('igni_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('igni_bow_2');
			}
			else
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
				sword1.AddTag('igni_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent" 
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('igni_bow_2');
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
				sword1.AddTag('igni_bow_1');
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
				sword1.AddTag('igni_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('igni_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('igni_bow_2');
			}
			else
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
				sword1.AddTag('igni_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('igni_bow_2');
			}
		}
	}

	latent function IgniBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

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
		sword1.AddTag('igni_bow_1');
	}

	latent function AxiiBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AxiiBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiBowStatic();
		}
		
		GetWitcherPlayer().AddTag('axii_bow_equipped');
	}

	latent function AxiiBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
				sword1.AddTag('axii_bow_1');
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
				sword1.AddTag('axii_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('axii_bow_2');
			}
			else
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
				sword1.AddTag('axii_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('axii_bow_2');
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
				sword1.AddTag('axii_bow_1');
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
				sword1.AddTag('axii_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('axii_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('axii_bow_2');
			}
			else
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
				sword1.AddTag('axii_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('axii_bow_2');
			}
		}
	}

	latent function AxiiBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

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
		sword1.AddTag('axii_bow_1');
	}

	latent function AardBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AardBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardBowStatic();
		}

		GetWitcherPlayer().AddTag('aard_bow_equipped');
	}

	latent function AardBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
				sword1.AddTag('aard_bow_1');
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
				sword1.AddTag('aard_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('aard_bow_2');
			}
			else
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
				sword1.AddTag('aard_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('aard_bow_2');
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
				sword1.AddTag('aard_bow_1');
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
				sword1.AddTag('aard_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('aard_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('aard_bow_2');
			}
			else
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
				sword1.AddTag('aard_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('aard_bow_2');
			}
		}
	}

	latent function AardBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{

			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

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
		sword1.AddTag('aard_bow_1');
	}
	
	latent function YrdenBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			YrdenBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenBowStatic();
		}

		GetWitcherPlayer().AddTag('yrden_bow_equipped'); 
	}
	
	latent function YrdenBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
				sword1.AddTag('yrden_bow_1');
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
				sword1.AddTag('yrden_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('yrden_bow_2');
			}
			else
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
				sword1.AddTag('yrden_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('yrden_bow_2');
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
				sword1.AddTag('yrden_bow_1');
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
				sword1.AddTag('yrden_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('yrden_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('yrden_bow_2');
			}
			else
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
				sword1.AddTag('yrden_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('yrden_bow_2');
			}
		}
	}

	latent function YrdenBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

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
		sword1.AddTag('yrden_bow_1');
	}

	latent function QuenBow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			QuenBowEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenBowStatic();
		}

		GetWitcherPlayer().AddTag('quen_bow_equipped'); 
	}

	latent function QuenBowEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
				sword1.AddTag('quen_bow_1');
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
				sword1.AddTag('quen_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('quen_bow_2');
			}
			else
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
				sword1.AddTag('quen_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('quen_bow_2');
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
				sword1.AddTag('quen_bow_1');
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
				sword1.AddTag('quen_bow_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword1.AddTag('quen_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
				"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('quen_bow_2');
			}
			else
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
				sword1.AddTag('quen_bow_1');
				
				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				
				sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

				"dlc\dlc_ACS\data\entities\ranged\bow_01.w2ent"
					
				, true), GetWitcherPlayer().GetWorldPosition() );
					
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = -0.025;
				attach_vec.Z = -0.045;
					
				sword2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
				sword2.AddTag('quen_bow_2');
			}
		}
	}

	latent function QuenBowStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		if (RandF() < 0.5 )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			//"dlc\dlc_ACS\data\entities\ranged\bow_elven_01.w2ent" 

			//"dlc\dlc_ACS\data\entities\ranged\bow_02.w2ent" 

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
		sword1.AddTag('quen_bow_1');
	}


	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	latent function IgniCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//IgniCrossbowEvolving();
			IgniCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			IgniCrossbowStatic();
		}
		
		GetWitcherPlayer().AddTag('igni_crossbow_equipped');
	}

	latent function IgniCrossbowEvolving()
	{
		
	}

	latent function IgniCrossbowStatic()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"

		"dlc\dlc_acs\data\entities\ranged\acs_wolf_crossbow_fake.w2ent"
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = -90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 180;
		attach_vec.X = -0.125; // + forward - backward
		attach_vec.Y = 0; // + left - right
		attach_vec.Z = 0.06125; // + up - down
			
		sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('igni_crossbow_1');
	}

	latent function AxiiCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//AxiiCrossbowEvolving();
			AxiiCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiCrossbowStatic();
		}
		
		GetWitcherPlayer().AddTag('axii_crossbow_equipped');
	}

	latent function AxiiCrossbowEvolving()
	{
		
	}

	latent function AxiiCrossbowStatic()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"

		"dlc\dlc_acs\data\entities\ranged\acs_wolf_crossbow_fake.w2ent"
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = -90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 180;
		attach_vec.X = -0.125; // + forward - backward
		attach_vec.Y = 0; // + left - right
		attach_vec.Z = 0.06125; // + up - down
			
		sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('axii_crossbow_1');
	}

	latent function AardCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//AardCrossbowEvolving();
			AardCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardCrossbowStatic();
		}

		GetWitcherPlayer().AddTag('aard_crossbow_equipped');
	}

	latent function AardCrossbowEvolving()
	{
		
	}

	latent function AardCrossbowStatic()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"

		"dlc\dlc_acs\data\entities\ranged\acs_wolf_crossbow_fake.w2ent"
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = -90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 180;
		attach_vec.X = -0.125; // + forward - backward
		attach_vec.Y = 0; // + left - right
		attach_vec.Z = 0.06125; // + up - down
			
		sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('aard_crossbow_1');
	}
	
	latent function YrdenCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//YrdenCrossbowEvolving();
			YrdenCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenCrossbowStatic();
		}

		GetWitcherPlayer().AddTag('yrden_crossbow_equipped'); 
	}
	
	latent function YrdenCrossbowEvolving()
	{
		
	}

	latent function YrdenCrossbowStatic()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"

		"dlc\dlc_acs\data\entities\ranged\acs_wolf_crossbow_fake.w2ent"
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = -90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 180;
		attach_vec.X = -0.125; // + forward - backward
		attach_vec.Y = 0; // + left - right
		attach_vec.Z = 0.06125; // + up - down
			
		sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('yrden_crossbow_1');
	}

	latent function QuenCrossbow()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			//QuenCrossbowEvolving();
			QuenCrossbowStatic();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenCrossbowStatic();
		}

		GetWitcherPlayer().AddTag('quen_crossbow_equipped'); 
	}

	latent function QuenCrossbowEvolving()
	{

	}

	latent function QuenCrossbowStatic()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"
		//"dlc\dlc_acs\data\entities\ranged\nilfgaardian_crossbow_01.w2ent"

		"dlc\dlc_acs\data\entities\ranged\acs_wolf_crossbow_fake.w2ent"
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = -90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 180;
		attach_vec.X = -0.125; // + forward - backward
		attach_vec.Y = 0; // + left - right
		attach_vec.Z = 0.06125; // + up - down
			
		sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword1.AddTag('yrden_crossbow_1');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.