statemachine class cACS_SecondaryWeaponSwitch
{
    function Secondary_Weapon_Switch_Engage()
	{
		this.PushState('Secondary_Weapon_Switch_Engage');
	}
}
 
state Secondary_Weapon_Switch_Engage in cACS_SecondaryWeaponSwitch
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
	

	event OnEnterState(prevStateName : name)
	{
		LockEntryFunction(true);
		SecondaryWeaponSwitch();
		UpdateBehGraph();
		LockEntryFunction(false);
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
		
		GetWitcherPlayer().SetBehaviorVariable( 'WeaponType', 0);
		
		if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') && GetWitcherPlayer().IsInCombat() )
		{
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
		}
		else
		{
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
		}
		
		if ( GetWitcherPlayer().IsUsingHorse() )
		{
			GetWitcherPlayer().SetBehaviorVariable( 'isOnHorse', 1.0 );
		}
		else
		{
			GetWitcherPlayer().SetBehaviorVariable( 'isOnHorse', 0.0 );
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
	
	entry function SecondaryWeaponSwitch()
	{
		if ( ACS_GetWeaponMode() == 0 )
		{
			if
			(
				(GetWitcherPlayer().GetEquippedSign() == ST_Igni)
				&& (GetWitcherPlayer().IsWeaponHeld( 'silversword' ) 
				|| GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			)
			{
				if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 0)
				{
					if (!GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
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
				if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 0)
				{
					if (!GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
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
				if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 0)
				{
					if (!GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
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
				if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 0)
				{
					if (!GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
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
				if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 0)
				{
					if (!GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
					{
						IgniSecondarySword();

						IgniSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
					{
						ArmigerModeQuenSecondarySword();

						QuenSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_secondary_sword_equipped'))
					{
						ArmigerModeAxiiSecondarySword();

						AxiiSecondarySwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_secondary_sword_equipped'))
					{
						ArmigerModeAardSecondarySword();

						AardSecondarySwordSwitch();			
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped'))
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
				( ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') )
				|| ( ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit();
				
				IgniSecondarySword();

				IgniSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetFocusModeSilverWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
				|| ( ACS_GetFocusModeSteelWeapon() == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
			)
			{
				FocusModeAxiiSecondarySword();

				AxiiSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetFocusModeSilverWeapon() == 8  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
				|| ( ACS_GetFocusModeSteelWeapon() == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
			)
			{
				FocusModeAardSecondarySword();

				AardSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetFocusModeSilverWeapon() == 6  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
				|| ( ACS_GetFocusModeSteelWeapon() == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
			)
			{
				FocusModeYrdenSecondarySword();

				YrdenSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetFocusModeSilverWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
				|| ( ACS_GetFocusModeSteelWeapon() == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
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
				GetWitcherPlayer().HasTag('HybridDefaultSecondaryWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') )
				{
					IgniSecondarySword();

					IgniSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('HybridGregWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
				{
					HybridModeAxiiSecondarySword();

					AxiiSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('HybridAxeWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
				{
					HybridModeAardSecondarySword();

					AardSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('HybridGiantWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
				{
					HybridModeYrdenSecondarySword();

					YrdenSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('HybridSpearWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
				{
					HybridModeQuenSecondarySword();

					QuenSecondarySwordSwitch();
				}

				HybridTagRemoval();
			}

			//Sleep(0.125);

			SecondaryWeaponSummonEffect();
		}
		else if ( ACS_GetWeaponMode() == 3)
		{
			if 
			(
				( ACS_GetItem_Greg_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
				|| ( ACS_GetItem_Greg_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
				|| ( ACS_GetItem_Katana_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
				|| ( ACS_GetItem_Katana_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
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

				GetWitcherPlayer().AddTag('axii_secondary_sword_equipped');

				AxiiSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetItem_Axe_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
				|| ( ACS_GetItem_Axe_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
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

				GetWitcherPlayer().AddTag('aard_secondary_sword_equipped');

				AardSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
				|| ( ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
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

				GetWitcherPlayer().AddTag('yrden_secondary_sword_equipped');

				YrdenSecondarySwordSwitch();
			}
			
			else if 
			(
				( ACS_GetItem_Spear_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
				|| ( ACS_GetItem_Spear_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
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

				GetWitcherPlayer().AddTag('quen_secondary_sword_equipped');

				QuenSecondarySwordSwitch();
			}
		}
	}

	latent function SecondaryWeaponSummonEffect()
	{
		GetWitcherPlayer().RemoveTimer('ACS_Weapon_Summon_Delay');

		if (GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('igni_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('igni_secondary_sword_effect_played');
			GetWitcherPlayer().AddTag('igni_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('axii_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//axii_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('axii_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('aard_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//aard_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('aard_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('yrden_secondary_sword_effect_played'))
		{
			igni_sword_summon();

			//yrden_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('yrden_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
		&& !GetWitcherPlayer().HasTag('quen_secondary_sword_effect_played'))
		{
			igni_sword_summon();
			
			//quen_secondary_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('quen_secondary_sword_effect_played');
		}
	}

	latent function WeaponSummonAnimation()
	{
		if (GetWitcherPlayer().IsInCombat())
		{
			ACS_BruxaDodgeSlideBackInitForWeaponSwitching();
		}
		else
		{
			if ( GetWitcherPlayer().GetCurrentStateName() == 'Combat' ) 
			{
				ACS_BruxaDodgeSlideBackInitForWeaponSwitching();
			}
			else
			{
				if (theInput.GetActionValue('GI_AxisLeftY') != 0
				|| theInput.GetActionValue('GI_AxisLeftX') != 0)
				{
					ACS_BruxaDodgeSlideBackInitForWeaponSwitching();
				}
				else
				{
					if (!GetWitcherPlayer().IsCiri()
					&& !GetWitcherPlayer().IsPerformingFinisher()
					&& !GetWitcherPlayer().HasTag('in_wraith')
					&& !GetWitcherPlayer().HasTag('blood_sucking')
					&& ACS_BuffCheck()
					&& GetWitcherPlayer().IsActionAllowed(EIAB_Dodge)
					&& !GetWitcherPlayer().IsInAir()
					)
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1) );
					}
				}
			}
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
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_E3ARP' );
						}
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_swordwalk' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_swordwalk' );
						}
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							GetWitcherPlayer().ActivateAndSyncBehavior( 'igni_primary_beh' );
						}
					}
				}
			}
	
			if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
			{
				GetWitcherPlayer().GotoState( 'Combat' );
			}

			UpdateBehGraph();

			if ( 
			ACS_GetWeaponMode() == 0
			|| ACS_GetWeaponMode() == 1
			)
			{
				WeaponSummonAnimation();
			}
		}
	}
			
	latent function AxiiSecondarySwordSwitch()
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
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_secondary_beh' );
					}
				}
			}
	
			if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
			{
				GetWitcherPlayer().GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function AardSecondarySwordSwitch()
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
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_secondary_beh' );
					}
				}
			}
					
			if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
			{
				GetWitcherPlayer().GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function YrdenSecondarySwordSwitch()
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
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_secondary_beh' );
					}
				}
			}
					
			if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
			{
				GetWitcherPlayer().GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
			
	latent function QuenSecondarySwordSwitch()
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
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_secondary_beh' );
					}
				}
			}

			if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
			{
				GetWitcherPlayer().GotoState( 'Combat' );
			}

			UpdateBehGraph();

			WeaponSummonAnimation();
		}
	}
	
	latent function IgniSecondarySword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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

			if (!ACS_HideSwordsheathes_Enabled())
			{
				scabbards_steel = GetWitcherPlayer().inv.GetItemsByCategory('steel_scabbards');

				for ( i=0; i < scabbards_steel.Size() ; i+=1 )
				{
					scabbard_steel = (CDrawableComponent)((GetWitcherPlayer().inv.GetItemEntityUnsafe(scabbards_steel[i])).GetMeshComponent());
					//scabbard_steel.SetVisible(true);
				}
			}
		}
		else if( GetWitcherPlayer().GetInventory().IsItemHeld(silverID) )
		{
			silversword.SetVisible(true);

			silverswordentity = GetWitcherPlayer().inv.GetItemEntityUnsafe(silverID);
			silverswordentity.SetHideInGame(false); 

			if (!ACS_HideSwordsheathes_Enabled())
			{
				scabbards_silver = GetWitcherPlayer().inv.GetItemsByCategory('silver_scabbards');

				for ( i=0; i < scabbards_silver.Size() ; i+=1 )
				{
					scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().inv.GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
					//scabbard_silver.SetVisible(true);
				}
			}
		}
		
		GetWitcherPlayer().AddTag('igni_secondary_sword_equipped');
		GetWitcherPlayer().AddTag('igni_sword_equipped');

		GetWitcherPlayer().AddTag('igni_secondary_sword_equipped_TAG');
	}

	latent function ArmigerModeAxiiSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('axii_secondary_sword_equipped');	 
	}

	latent function FocusModeAxiiSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AxiiSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('axii_secondary_sword_equipped'); 
	}

	latent function HybridModeAxiiSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0)
		{
			AxiiSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1)
		{
			AxiiSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('axii_secondary_sword_equipped'); 
	}

	latent function AxiiSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
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
					sword1.AddTag('axii_secondary_sword_1');
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
					sword1.AddTag('axii_secondary_sword_1');
					
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
					sword2.AddTag('axii_secondary_sword_2');
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
					sword1.AddTag('axii_secondary_sword_1');
							
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
					sword2.AddTag('axii_secondary_sword_2');
					
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
					sword3.AddTag('axii_secondary_sword_3');
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
					sword1.AddTag('axii_secondary_sword_1');
					
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
					sword2.AddTag('axii_secondary_sword_2');
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
					sword1.AddTag('axii_secondary_sword_1');
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
					sword1.AddTag('axii_secondary_sword_1');
					
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
					sword2.AddTag('axii_secondary_sword_2');
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
					sword1.AddTag('axii_secondary_sword_1');
							
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
					sword2.AddTag('axii_secondary_sword_2');
					
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
					sword3.AddTag('axii_secondary_sword_3');
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
					sword1.AddTag('axii_secondary_sword_1');
					
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
					sword2.AddTag('axii_secondary_sword_2');
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
					sword1.AddTag('axii_secondary_sword_1');
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
					sword1.AddTag('axii_secondary_sword_1');
					
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
					sword2.AddTag('axii_secondary_sword_2');
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
					sword1.AddTag('axii_secondary_sword_1');
							
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
					sword2.AddTag('axii_secondary_sword_2');
					
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
					sword3.AddTag('axii_secondary_sword_3');
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
					sword1.AddTag('axii_secondary_sword_1');
					
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
					sword2.AddTag('axii_secondary_sword_2');
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
					sword1.AddTag('axii_secondary_sword_1');
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
					sword1.AddTag('axii_secondary_sword_1');
					
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
					sword2.AddTag('axii_secondary_sword_2');
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
					sword1.AddTag('axii_secondary_sword_1');
							
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
					sword2.AddTag('axii_secondary_sword_2');
					
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
					sword3.AddTag('axii_secondary_sword_3');
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
					sword1.AddTag('axii_secondary_sword_1');
					
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
					sword2.AddTag('axii_secondary_sword_2');
				}
			}
		}
	}

	latent function AxiiSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
			sword1.AddTag('axii_secondary_sword_1');
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
			sword1.AddTag('axii_secondary_sword_1');
		}
	}

	latent function ArmigerModeAardSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('aard_secondary_sword_equipped'); 
	}

	latent function FocusModeAardSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0  )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('aard_secondary_sword_equipped');	 
	}

	latent function HybridModeAardSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			AardSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			AardSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('aard_secondary_sword_equipped'); 
	}	

	latent function AardSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
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
					sword1.AddTag('aard_secondary_sword_1');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
					
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
					sword5.AddTag('aard_secondary_sword_5');

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
					sword6.AddTag('aard_secondary_sword_6');

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
					sword7.AddTag('aard_secondary_sword_7');

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
					sword8.AddTag('aard_secondary_sword_8');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
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
					sword1.AddTag('aard_secondary_sword_1');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
					
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
					sword5.AddTag('aard_secondary_sword_5');

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
					sword6.AddTag('aard_secondary_sword_6');

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
					sword7.AddTag('aard_secondary_sword_7');

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
					sword8.AddTag('aard_secondary_sword_8');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
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
					sword1.AddTag('aard_secondary_sword_1');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
					
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
					sword5.AddTag('aard_secondary_sword_5');

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
					sword6.AddTag('aard_secondary_sword_6');

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
					sword7.AddTag('aard_secondary_sword_7');

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
					sword8.AddTag('aard_secondary_sword_8');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
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
					sword1.AddTag('aard_secondary_sword_1');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
					
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
					sword5.AddTag('aard_secondary_sword_5');

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
					sword6.AddTag('aard_secondary_sword_6');

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
					sword7.AddTag('aard_secondary_sword_7');

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
					sword8.AddTag('aard_secondary_sword_8');
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
					sword1.AddTag('aard_secondary_sword_1');

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
					sword2.AddTag('aard_secondary_sword_2');

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
					sword3.AddTag('aard_secondary_sword_3');

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
					sword4.AddTag('aard_secondary_sword_4');
				}
			}
		}
	}

	latent function AardSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
			sword1.AddTag('aard_secondary_sword_1');
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
			sword1.AddTag('aard_secondary_sword_1');
		}
	}

	latent function ArmigerModeYrdenSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('yrden_secondary_sword_equipped');	 
	}

	latent function FocusModeYrdenSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('yrden_secondary_sword_equipped'); 
	}

	latent function HybridModeYrdenSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			YrdenSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			YrdenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('yrden_secondary_sword_equipped');
	}

	latent function YrdenSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
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
					sword1.AddTag('yrden_secondary_sword_1');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
					
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
					sword3.AddTag('yrden_secondary_sword_3');
						
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
					sword4.AddTag('yrden_secondary_sword_4');
						
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
					sword5.AddTag('yrden_secondary_sword_5');
						
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
					sword6.AddTag('yrden_secondary_sword_6');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
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
					sword1.AddTag('yrden_secondary_sword_1');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
					
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
					sword3.AddTag('yrden_secondary_sword_3');
						
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
					sword4.AddTag('yrden_secondary_sword_4');
						
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
					sword5.AddTag('yrden_secondary_sword_5');
						
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
					sword6.AddTag('yrden_secondary_sword_6');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
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
					sword1.AddTag('yrden_secondary_sword_1');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
					
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
					sword3.AddTag('yrden_secondary_sword_3');
						
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
					sword4.AddTag('yrden_secondary_sword_4');
						
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
					sword5.AddTag('yrden_secondary_sword_5');
						
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
					sword6.AddTag('yrden_secondary_sword_6');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
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
					sword1.AddTag('yrden_secondary_sword_1');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
					
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
					sword3.AddTag('yrden_secondary_sword_3');
						
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
					sword4.AddTag('yrden_secondary_sword_4');
						
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
					sword5.AddTag('yrden_secondary_sword_5');
						
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
					sword6.AddTag('yrden_secondary_sword_6');
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
					sword1.AddTag('yrden_secondary_sword_1');
					
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
					sword2.AddTag('yrden_secondary_sword_2');
				}
			}
		}
	}

	latent function YrdenSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
			sword1.AddTag('yrden_secondary_sword_1');
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
			sword1.AddTag('yrden_secondary_sword_1');
		}
	}
	
	latent function ArmigerModeQuenSecondarySword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('quen_secondary_sword_equipped'); 
	}

	latent function FocusModeQuenSecondarySword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('quen_secondary_sword_equipped'); 
	}

	latent function HybridModeQuenSecondarySword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			QuenSecondarySwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			QuenSecondarySwordStatic();
		}

		GetWitcherPlayer().AddTag('quen_secondary_sword_equipped'); 
	}

	latent function QuenSecondarySwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
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
					sword1.AddTag('quen_secondary_sword_1');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
						
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
					sword5.AddTag('quen_secondary_sword_5');

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
					sword6.AddTag('quen_secondary_sword_6');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
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
					sword1.AddTag('quen_secondary_sword_1');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
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
					sword1.AddTag('quen_secondary_sword_1');

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
					sword2.AddTag('quen_secondary_sword_2');
					
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
					sword3.AddTag('quen_secondary_sword_3');
					
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
					sword4.AddTag('quen_secondary_sword_4');
					
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
					sword5.AddTag('quen_secondary_sword_5');
					
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
					sword6.AddTag('quen_secondary_sword_6');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
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
					sword1.AddTag('quen_secondary_sword_1');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
					
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
					sword3.AddTag('quen_secondary_sword_3');
					
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
					sword4.AddTag('quen_secondary_sword_4');

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
					sword5.AddTag('quen_secondary_sword_5');
					
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
					sword6.AddTag('quen_secondary_sword_6');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
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
					sword1.AddTag('quen_secondary_sword_1');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
					
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
					sword3.AddTag('quen_secondary_sword_3');
					
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
					sword4.AddTag('quen_secondary_sword_4');
					
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
					sword5.AddTag('quen_secondary_sword_5');
					
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
					sword6.AddTag('quen_secondary_sword_6');
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
					sword1.AddTag('quen_secondary_sword_1');
					
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
					sword2.AddTag('quen_secondary_sword_2');
				}
			}
		}
	}

	latent function QuenSecondarySwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

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
			sword1.AddTag('quen_secondary_sword_1');

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
			sword2.AddTag('quen_secondary_sword_2');
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
			sword1.AddTag('quen_secondary_sword_1');

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
			sword2.AddTag('quen_secondary_sword_2');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.