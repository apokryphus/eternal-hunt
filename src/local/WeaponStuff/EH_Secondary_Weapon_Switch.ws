statemachine class cACS_SecondaryWeaponSwitch
{
    function Secondary_Weapon_Switch_Engage()
	{
		this.PushState('ACS_Secondary_Weapon_Switch_Engage');
	}
}
 
state ACS_Secondary_Weapon_Switch_Engage in cACS_SecondaryWeaponSwitch
{
	private var steelID, silverID 																														: SItemUniqueId;
	private var steelsword, silversword, scabbard_steel, scabbard_silver																				: CDrawableComponent;
	private var scabbards_steel, scabbards_silver 																										: array<SItemUniqueId>;
	private var attach_vec																																: Vector;
	private var attach_rot																																: EulerAngles;
	private var trail_temp																																: CEntityTemplate;
	private var sword1, sword2, sword3, sword4, sword5, sword6, sword7, sword8																			: CEntity;
	private var sword_trail_1, sword_trail_2, sword_trail_3, sword_trail_4, sword_trail_5, sword_trail_6, sword_trail_7, sword_trail_8 					: CEntity;
	private var weapontype 																																: EPlayerWeapon;
	private var item 																																	: SItemUniqueId;
	private var res 																																	: bool;
	private var inv 																																	: CInventoryComponent;
	private var tags 																																	: array<name>;
	private var i																																		: int;				
	private var steelswordentity, silverswordentity 																									: CEntity;				
	private var stupidArray 																															: array< name >;


	event OnEnterState(prevStateName : name)
	{
		if (ACS_New_Replacers_Female_Active()
		)
		{
			return false;
		}
		
		LockEntryFunction(true);
		SecondaryWeaponSwitch();
		LockEntryFunction(false);
	}

	entry function SecondaryWeaponSwitch()
	{
		GetACSWatcher().RemoveTimer('ForceControlModuleHudUpdate');
		GetACSWatcher().AddTimer('ForceControlModuleHudUpdate', 0.25f , false);
		
		if ( ACS_GetWeaponMode() == 0 )
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				&& (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
				|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			)
			{
				if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_igni_sign_weapon', 0) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();
						
						YrdenSecondarySwordSwitch();		
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
				if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_quen_sign_weapon', 1) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();

						YrdenSecondarySwordSwitch();		
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
				if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_aard_sign_weapon', 3) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();

						YrdenSecondarySwordSwitch();		
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
				if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_axii_sign_weapon', 2) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();

						YrdenSecondarySwordSwitch();		
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
				if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_yrden_sign_weapon', 4) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped'))
					{
						ArmigerModeYrdenSecondarySword();

						YrdenSecondarySwordSwitch();		
					}
				}
			}

			//Sleep(0.125);

			SecondaryWeaponSummonEffect();
		}
		else if ( ACS_GetWeaponMode() == 1)
		{
			if 
			(
				( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped') )
				|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit();
				
				IgniSecondarySword();

				IgniSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
				|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
			)
			{
				FocusModeAxiiSecondarySword();

				AxiiSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 8  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
				|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
			)
			{
				FocusModeAardSecondarySword();

				AardSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 6  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
				|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
			)
			{
				FocusModeYrdenSecondarySword();

				YrdenSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_silver_weapon', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
				|| ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_steel_weapon', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
			)
			{
				FocusModeQuenSecondarySword();

				QuenSecondarySwordSwitch();
			}

			//Sleep(0.125);

			SecondaryWeaponSummonEffect();
		}
		else if ( ACS_GetWeaponMode() == 2)
		{
			if 
			(
				GetWitcherPlayer().HasTag('ACSHybridDefaultSecondaryWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped') )
				{
					IgniSecondarySword();

					IgniSecondarySwordSwitch();
				}

				ACS_HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('ACSHybridGregWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
				{
					HybridModeAxiiSecondarySword();

					AxiiSecondarySwordSwitch();
				}

				ACS_HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('ACSHybridAxeWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
				{
					HybridModeAardSecondarySword();

					AardSecondarySwordSwitch();
				}

				ACS_HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('ACSHybridGiantWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
				{
					HybridModeYrdenSecondarySword();

					YrdenSecondarySwordSwitch();
				}

				ACS_HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('ACSHybridSpearWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
				{
					HybridModeQuenSecondarySword();

					QuenSecondarySwordSwitch();
				}

				ACS_HybridTagRemoval();
			}

			//Sleep(0.125);

			SecondaryWeaponSummonEffect();
		}
		else if ( ACS_GetWeaponMode() == 3)
		{
			if 
			(
				( ACS_GetItem_Sword_IsEquipped('greg_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
				|| ( ACS_GetItem_Sword_IsEquipped('greg_steel', 'steel') && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
				|| ( ACS_GetItem_Sword_IsEquipped('katana_steel', 'steel') && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
				|| ( ACS_GetItem_Sword_IsEquipped('katana_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit();

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

				GetWitcherPlayer().AddTag('acs_axii_secondary_sword_equipped');

				AxiiSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetItem_Sword_IsEquipped('axe_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
				|| ( ACS_GetItem_Sword_IsEquipped('axe_steel', 'steel') && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
				|| ( ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel') && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit();

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

				GetWitcherPlayer().AddTag('acs_aard_secondary_sword_equipped');

				AardSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetItem_Sword_IsEquipped('hammer_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
				|| ( ACS_GetItem_Sword_IsEquipped('hammer_steel', 'steel') && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit();

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
				attach_vec.Z = 0.4;

				sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_2.AddTag('acs_sword_trail_2');

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.8;

				sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_3.AddTag('acs_sword_trail_3');

				GetWitcherPlayer().AddTag('acs_yrden_secondary_sword_equipped');

				YrdenSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetItem_Sword_IsEquipped('spear_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
				|| ( ACS_GetItem_Sword_IsEquipped('spear_steel', 'steel') && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit();

				trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

				sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.4;

				sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_1.AddTag('acs_sword_trail_1');

				attach_rot.Roll = 180;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = -0.2;

				sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_2.AddTag('acs_sword_trail_2');

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.6;

				sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_3.AddTag('acs_sword_trail_3');

				attach_rot.Roll = 180;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = -0.4;

				sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_4.AddTag('acs_sword_trail_4');

				GetWitcherPlayer().AddTag('acs_quen_secondary_sword_equipped');

				QuenSecondarySwordSwitch();
			}
			else if 
			(
				( ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
				|| ( ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit();

				trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

				sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.4;

				sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_1.AddTag('acs_sword_trail_1');

				attach_rot.Roll = 180;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = -0.2;

				sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_2.AddTag('acs_sword_trail_2');

				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.6;

				sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_3.AddTag('acs_sword_trail_3');

				attach_rot.Roll = 180;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = -0.4;

				sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword_trail_4.AddTag('acs_sword_trail_4');

				GetWitcherPlayer().AddTag('acs_quen_secondary_sword_equipped');

				QuenSecondarySwordSwitch();
			}
		}
	}

	latent function SecondaryWeaponSummonEffect()
	{
		GetWitcherPlayer().RemoveTimer('ACS_Weapon_Summon_Delay');

		if (GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_igni_secondary_sword_effect_played'))
		{
			ACSSwordSummonEffect('igni');

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125 / theGame.GetTimeScale(), false );

			GetWitcherPlayer().AddTag('acs_igni_secondary_sword_effect_played');
			GetWitcherPlayer().AddTag('acs_igni_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_effect_played'))
		{
			ACSSwordSummonEffect('igni');

			//ACSSwordSummonEffect('axii_secondary');

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125 / theGame.GetTimeScale(), false );

			GetWitcherPlayer().AddTag('acs_axii_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_aard_secondary_sword_effect_played'))
		{
			ACSSwordSummonEffect('igni');

			//ACSSwordSummonEffect('aard_secondary');

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125 / theGame.GetTimeScale(), false );

			GetWitcherPlayer().AddTag('acs_aard_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_effect_played'))
		{
			ACSSwordSummonEffect('igni');

			//ACSSwordSummonEffect('yrden_secondary');

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125 / theGame.GetTimeScale(), false );

			GetWitcherPlayer().AddTag('acs_yrden_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_quen_secondary_sword_effect_played'))
		{
			ACSSwordSummonEffect('igni');
			
			//ACSSwordSummonEffect('quen_secondary');

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125 / theGame.GetTimeScale(), false );

			GetWitcherPlayer().AddTag('acs_quen_secondary_sword_effect_played');
		}
	}

	latent function IgniSecondarySwordSwitch()
	{
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
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
					}
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
			
	latent function AxiiSecondarySwordSwitch()
	{		
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
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
					}
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
			
	latent function AardSecondarySwordSwitch()
	{			
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
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
					}
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
			
	latent function YrdenSecondarySwordSwitch()
	{			
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
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
					}
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
			
	latent function QuenSecondarySwordSwitch()
	{		
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
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('acs_taunt_settings','acs_passive_taunt_enabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
					}
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
	
	latent function IgniSecondarySword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		ACS_WeaponDestroyInit();

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
		
		if ( GetWitcherPlayer().GetInventory().IsItemHeld(steelID) )
		{
			steelsword.SetVisible(true);

			steelswordentity = GetWitcherPlayer().inv.GetItemEntityUnsafe(steelID);
			steelswordentity.SetHideInGame(false); 
		}
		else if( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
		{
			silversword.SetVisible(true);

			silverswordentity = GetWitcherPlayer().inv.GetItemEntityUnsafe(silverID);
			silverswordentity.SetHideInGame(false); 
		}
		
		GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped');
		GetWitcherPlayer().AddTag('acs_igni_sword_equipped');

		GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped_TAG');
	}

	latent function ArmigerModeAxiiSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 0 )
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 1 )
		{
			AxiiSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_axii_secondary_sword_equipped');	 
	}

	latent function FocusModeAxiiSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 0 )
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 1 )
		{
			AxiiSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_axii_secondary_sword_equipped'); 
	}

	latent function HybridModeAxiiSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 0)
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 1)
		{
			AxiiSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_axii_secondary_sword_equipped'); 
	}

	latent function AxiiSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
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

		if ( ACS_Is_DLC_Installed('dlc_050_51')  )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmdivider\goyen_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\realmblade\goyen_blade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\unique_steel_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
							
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_axii_secondary_sword_3');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_axii_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\bob\data\items\weapons\unique\collector_sword\collector_sword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
							
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_axii_secondary_sword_2');
				}
			}
		}
	}

	latent function AxiiSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
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

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.05;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_axii_secondary_sword_1');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\sword_for_champion_of_arena.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.05;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_axii_secondary_sword_1');
		}
	}

	latent function ArmigerModeAardSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 0 )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 1 )
		{
			AardSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_aard_secondary_sword_equipped'); 
	}

	latent function FocusModeAardSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 0  )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 1 )
		{
			AardSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_aard_secondary_sword_equipped');	 
	}

	latent function HybridModeAardSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 0 )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 1 )
		{
			AardSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_aard_secondary_sword_equipped'); 
	}	

	latent function AardSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();

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

		if ( ACS_Is_DLC_Installed('dlc_050_51')  )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('acs_aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('acs_aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('acs_aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('acs_aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\doomblade\doomblade.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('acs_aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('acs_aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
		
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_aard_secondary_sword_5');

					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_aard_secondary_sword_6');

					sword7 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 225;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword7.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword7.AddTag('acs_aard_secondary_sword_7');

					sword8 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 315;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.5;
					
					sword8.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword8.AddTag('acs_aard_secondary_sword_8');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );	
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
		
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_aard_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_aard_secondary_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_aard_secondary_sword_3');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_aard_secondary_sword_4');
				}
			}
		}
	}

	latent function AardSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();

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
		
		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );	
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.2;
	
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_aard_secondary_sword_1');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );	
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.2;
	
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_aard_secondary_sword_1');
		}
	}

	latent function ArmigerModeYrdenSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_yrden_secondary_sword_equipped');	 
	}

	latent function FocusModeYrdenSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_yrden_secondary_sword_equipped'); 
	}

	latent function HybridModeYrdenSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_yrden_secondary_sword_equipped');
	}

	latent function YrdenSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();

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
		attach_vec.Z = 0.4;

		sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_2.AddTag('acs_sword_trail_2');

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.8;

		sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_3.AddTag('acs_sword_trail_3');

		if ( ACS_Is_DLC_Installed('dlc_050_51')  )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\beastcutter\beastcutter_nier.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\graveripper\graveripper.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_hammer_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					//"items\weapons\unique\anchor__giant_weapon.w2ent"
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_yrden_secondary_sword_3');
						
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_yrden_secondary_sword_4');
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_yrden_secondary_sword_5');
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\wildhunt_axe_01.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 45;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 270;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 2.0;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_yrden_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\stone_wheel__giant_weapon.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.525;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_yrden_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.8;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_yrden_secondary_sword_2');
				}
			}
		}
	}

	latent function YrdenSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();

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
		attach_vec.Z = 0.4;

		sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_2.AddTag('acs_sword_trail_2');

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.8;

		sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_3.AddTag('acs_sword_trail_3');

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\cloud_giant__giant_weapon.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.525;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_yrden_secondary_sword_1');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			"dlc\dlc_acs\data\entities\swords\anchor_giant_weapon_equip.w2ent"
			
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 180;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 2.0;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_yrden_secondary_sword_1');
		}
	}
	
	latent function ArmigerModeQuenSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 1 )
		{
			QuenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_quen_secondary_sword_equipped'); 
	}

	latent function FocusModeQuenSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 1 )
		{
			QuenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_quen_secondary_sword_equipped'); 
	}

	latent function HybridModeQuenSecondarySword()
	{
		if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 1 )
		{
			QuenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_quen_secondary_sword_equipped'); 
	}

	latent function QuenSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.4;

		sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_1.AddTag('acs_sword_trail_1');

		attach_rot.Roll = 180;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = -0.2;

		sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_2.AddTag('acs_sword_trail_2');

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.6;

		sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_3.AddTag('acs_sword_trail_3');

		attach_rot.Roll = 180;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = -0.4;

		sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_4.AddTag('acs_sword_trail_4');

		if ( ACS_Is_DLC_Installed('dlc_050_51')  )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
						
					////////////////////////////////////////////////////////////////////////////
						
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
							
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_quen_secondary_sword_5');

					////////////////////////////////////////////////////////////////////////////
						
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
						
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.2;
							
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\heavenspire\heavenspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(steelID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.2;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_quen_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.2;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\hellspire\hellspire.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
				}
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\guisarme_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.7;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_quen_secondary_sword_4');

					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.7;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 90;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\guisarme_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.8;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\guisarme_01.w2ent"

					//"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.5;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(steelID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.004;
					attach_vec.Y = 0;
					attach_vec.Z = 0.75;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.004;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.004;
					attach_vec.Y = 0;
					attach_vec.Z = 0.75;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.004;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('acs_quen_secondary_sword_3');
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('acs_quen_secondary_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.125;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('acs_quen_secondary_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\q308_iron_poker.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword6.AddTag('acs_quen_secondary_sword_6');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.004;
					attach_vec.Y = 0;
					attach_vec.Z = 0.75;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('acs_quen_secondary_sword_1');
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.004;
					attach_vec.Y = 0;
					attach_vec.Z = -0.6;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('acs_quen_secondary_sword_2');
				}
			}
		}
	}

	latent function QuenSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		ACS_WeaponDestroyInit();

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.4;

		sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_1.AddTag('acs_sword_trail_1');

		attach_rot.Roll = 180;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = -0.2;

		sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_2.AddTag('acs_sword_trail_2');

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 0.6;

		sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_3.AddTag('acs_sword_trail_3');

		attach_rot.Roll = 180;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = -0.4;

		sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_4.AddTag('acs_sword_trail_4');

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.6;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_quen_secondary_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\halberd_02.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 180;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.8;
					
			sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('acs_quen_secondary_sword_2');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = -0.004;
			attach_vec.Y = 0;
			attach_vec.Z = -0.6;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_quen_secondary_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
			"dlc\dlc_acs\data\entities\swords\hakland_spear_01.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 180;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0.004;
			attach_vec.Y = 0;
			attach_vec.Z = 0.75;
					
			sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('acs_quen_secondary_sword_2');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.