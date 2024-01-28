statemachine class cACS_PrimaryWeaponSwitch
{
    function Primary_Weapon_Switch_Engage()
	{
		this.PushState('Primary_Weapon_Switch_Engage');
	}
}
 
state Primary_Weapon_Switch_Engage in cACS_PrimaryWeaponSwitch
{
	private var steelID, silverID 																																																																																				: SItemUniqueId;
	private var steelsword, silversword, scabbard_steel, scabbard_silver																																																																										: CDrawableComponent;
	private var scabbards_steel, scabbards_silver 																																																																																: array<SItemUniqueId>;
	private var attach_vec, bone_vec																																																																																			: Vector;
	private var attach_rot, bone_rot																																																																																			: EulerAngles;
	private var anchor_temp, blade_temp, claw_temp, extra_arms_temp_r, extra_arms_temp_l, extra_arms_anchor_temp, head_temp, back_claw_temp, trail_temp																																																							: CEntityTemplate;
	private var r_blade1, r_blade2, r_blade3, r_blade4, l_blade1, l_blade2, l_blade3, l_blade4, r_anchor, l_anchor, sword1, sword2, sword3, sword4, sword5, sword6, sword7, sword8, blade_temp_ent, extra_arms_anchor_r, extra_arms_anchor_l, extra_arms_1, extra_arms_2, extra_arms_3, extra_arms_4, vampire_head_anchor, vampire_head, back_claw, vampire_claw_anchor			: CEntity;
	private var sword_trail_1, sword_trail_2, sword_trail_3, sword_trail_4, sword_trail_5, sword_trail_6, sword_trail_7, sword_trail_8 																																																											: CEntity;
	private var p_actor 																																																																																						: CActor;
	private var p_comp, meshcompHead																																																																																			: CComponent;
	private var weapontype 																																																																																						: EPlayerWeapon;
	private var item 																																																																																							: SItemUniqueId;
	private var res 																																																																																							: bool;
	private var inv 																																																																																							: CInventoryComponent;
	private var tags 																																																																																							: array<name>;
	private var animatedComponent_extra_arms 																																																																																	: CAnimatedComponent;
	private var stupidArray_extra_arms 																																																																																			: array< name >;
	private var h 																																																																																								: float;
	private var d_comp																																																																																							: array<CComponent>;							
	private var i, manual_sword_check																																																																																			: int;								
	private var watcher																																																																																							: W3ACSWatcher;
	private var steelswordentity, silverswordentity 																																																																															: CEntity;	
	private var physicalComponent 																																																																																				: CMeshComponent;

	event OnEnterState(prevStateName : name)
	{
		LockEntryFunction(true);
		PrimaryWeaponSwitch();
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
			GetWitcherPlayer().SetBehaviorVariable( 'playerWeapon', (int) weapontype ); ACS_Theft_Prevention_9 ();
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
	
	entry function PrimaryWeaponSwitch()
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
					if (!GetWitcherPlayer().HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();				
					}
				}
				else if (ACS_Armiger_Igni_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();			
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
					if (!GetWitcherPlayer().HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();	
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Quen_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();			
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
					if (!GetWitcherPlayer().HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();	
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();				
					}
				}
				else if (ACS_Armiger_Aard_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();			
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
					if (!GetWitcherPlayer().HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();				
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Axii_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();			
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
					if (!GetWitcherPlayer().HasTag('igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 1)
				{
					if (!GetWitcherPlayer().HasTag('quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 2)
				{
					if (!GetWitcherPlayer().HasTag('axii_sword_equipped'))
					{
						ArmigerModeAxiiSword(); ACS_Theft_Prevention_9 ();

						AxiiSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 3)
				{
					if (!GetWitcherPlayer().HasTag('aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Armiger_Yrden_Set_Sign_Weapon_Type() == 4)
				{
					if (!GetWitcherPlayer().HasTag('yrden_sword_equipped'))
					{
						ArmigerModeYrdenSword();

						YrdenSwordSwitch();		
					}
				}
			}	
			else if 
			(
				GetWitcherPlayer().IsWeaponHeld( 'fist' )
			)
			{
				if (ACS_GetFistMode() == 0
				|| ACS_GetFistMode() == 2 )
				{
					NormalFistsSwitch();
				}
				else if (ACS_GetFistMode() == 1 && !GetWitcherPlayer().HasTag('vampire_claws_equipped') )
				{
					VampireClaws();

					VampireClawsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 1)
		{
			if 
			(
				ACS_GetFocusModeSilverWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('igni_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('igni_sword_equipped')
			)
			{
				IgniSword();

				IgniSwordSwitch();
			}
			
			else if  
			(
				ACS_GetFocusModeSilverWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('axii_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('axii_sword_equipped')
			)
			{
				FocusModeAxiiSword();

				AxiiSwordSwitch();
			}
			
			else if  
			(
				ACS_GetFocusModeSilverWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('aard_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('aard_sword_equipped')
			)
			{
				FocusModeAardSword();

				AardSwordSwitch();
			}
			
			else if  
			(
				ACS_GetFocusModeSilverWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('yrden_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('yrden_sword_equipped')
			)
			{
				FocusModeYrdenSword();

				YrdenSwordSwitch();
			}
			
			else if 
			(
				ACS_GetFocusModeSilverWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('quen_sword_equipped') 
				|| ACS_GetFocusModeSteelWeapon() == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('quen_sword_equipped')
			)
			{
				FocusModeQuenSword();

				QuenSwordSwitch();
			}
			
			else if 
			(
				GetWitcherPlayer().IsWeaponHeld( 'fist' ) 
			)
			{
				if (ACS_GetFistMode() == 0
				|| ACS_GetFistMode() == 2 )
				{
					NormalFistsSwitch();
				}
				else if (ACS_GetFistMode() == 1 && !GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					VampireClaws();

					VampireClawsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 2)
		{
			if 
			(
				GetWitcherPlayer().HasTag('HybridDefaultWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('igni_sword_equipped') )
				{
					IgniSword();

					IgniSwordSwitch();
				}	

				HybridTagRemoval();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('HybridEredinWeaponTicket') 
			)
			{
				if (!GetWitcherPlayer().HasTag('axii_sword_equipped') )
				{
					HybridModeAxiiSword();

					AxiiSwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('HybridClawWeaponTicket') 
			)
			{
				if (!GetWitcherPlayer().HasTag('aard_sword_equipped') )
				{
					HybridModeAardSword();

					AardSwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('HybridImlerithWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('yrden_sword_equipped') )
				{
					HybridModeYrdenSword();

					YrdenSwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('HybridOlgierdWeaponTicket') 
			)
			{
				if (!GetWitcherPlayer().HasTag('quen_sword_equipped') )
				{
					HybridModeQuenSword();

					QuenSwordSwitch();
				}

				HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().IsWeaponHeld( 'fist' )
			)
			{
				if (ACS_GetFistMode() == 0
				|| ACS_GetFistMode() == 2 )
				{
					NormalFistsSwitch();
				}
				else if (ACS_GetFistMode() == 1 && !GetWitcherPlayer().HasTag('vampire_claws_equipped'))
				{
					VampireClaws();

					VampireClawsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 3 )
		{
			if 
			(
				ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('axii_sword_equipped') 
				|| ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('axii_sword_equipped')
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

				GetWitcherPlayer().AddTag('axii_sword_equipped');

				AxiiSwordSwitch();
			}
			
			else if 
			(
				ACS_GetItem_Claws_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('aard_sword_equipped') 
				|| ACS_GetItem_Claws_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('aard_sword_equipped')
			)
			{
				EquipmentModeAardSword();

				AardSwordSwitch();

				//Sleep(0.125);

				WeaponSummonEffect();
			}
			
			else if 
			(
				ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('yrden_sword_equipped') 
				|| ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('yrden_sword_equipped')
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

				GetWitcherPlayer().AddTag('yrden_sword_equipped');

				YrdenSwordSwitch();
			}
			
			else if 
			(
				ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('quen_sword_equipped') 
				|| ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('quen_sword_equipped')
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

				GetWitcherPlayer().AddTag('quen_sword_equipped');

				if (ACS_GetItem_Iris())
				{
					ACS_Sword_Trail_2().StopEffect('red_charge_10');
					ACS_Sword_Trail_2().PlayEffectSingle('red_charge_10');

					ACS_Sword_Trail_2().StopEffect('red_aerondight_special_trail');
					ACS_Sword_Trail_2().PlayEffectSingle('red_aerondight_special_trail');
				}

				QuenSwordSwitch();
			}
			else if 
			(
				ACS_GetItem_Katana_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
				|| ACS_GetItem_Katana_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
			)
			{
				GetACSWatcher().SecondaryWeaponSwitch();
			}

			else if 
			(
				ACS_GetItem_VampClaw_Shades() && GetWitcherPlayer().IsWeaponHeld( 'fist' ) && !GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				//GetWitcherPlayer().AddTag('vampire_claws_equipped');

				VampireClaws();

				VampireClawsSwitch();
			}

			else if 
			(
				ACS_GetItem_VampClaw() && GetWitcherPlayer().IsWeaponHeld( 'fist' ) && !GetWitcherPlayer().HasTag('vampire_claws_equipped')
			)
			{
				ACS_WeaponDestroyInit();

				VampireClaws();

				VampireClawsSwitch();
			}
		}
	}

	latent function WeaponSummonEffect()
	{
		GetWitcherPlayer().RemoveTimer('ACS_Weapon_Summon_Delay');
		
		if (GetWitcherPlayer().HasTag('igni_sword_equipped')
		&& !GetWitcherPlayer().HasTag('igni_sword_effect_played'))
		{
			igni_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('igni_sword_effect_played');
			GetWitcherPlayer().AddTag('igni_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('axii_sword_equipped')
		&& !GetWitcherPlayer().HasTag('axii_sword_effect_played'))
		{
			igni_sword_summon();

			//axii_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('axii_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped')
		&& !GetWitcherPlayer().HasTag('aard_sword_effect_played'))
		{
			//aard_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('aard_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('yrden_sword_equipped')
		&& !GetWitcherPlayer().HasTag('yrden_sword_effect_played'))
		{
			igni_sword_summon();

			//yrden_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('yrden_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('quen_sword_equipped')
		&& !GetWitcherPlayer().HasTag('quen_sword_effect_played'))
		{
			igni_sword_summon();

			//quen_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('quen_sword_effect_played');
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

	latent function NormalFistsSwitch()
	{
		if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			ClawDestroy_WITH_EFFECT();
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
		}
	}

	latent function VampireClawsSwitch()
	{
		ACS_Theft_Prevention_9 ();
		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			//theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( GetWitcherPlayer(), 'CastSignAction', -1, 20.0f, -1.f, -1, true );

			if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}

				if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
				{
					GetWitcherPlayer().GotoState( 'Combat' );
				}
			}

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'locomotion_walkstart_forward_dettlaff_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1) );
		}
	}

	latent function IgniSwordSwitch()
	{
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

	latent function AxiiSwordSwitch()
	{		
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
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'axii_primary_beh' );
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
			
	latent function AardSwordSwitch()
	{		
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
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'aard_primary_beh' );
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
			
	latent function YrdenSwordSwitch()
	{		
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
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'yrden_primary_beh' );
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
			
	latent function QuenSwordSwitch()
	{		
		ACS_Theft_Prevention_9 ();
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
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_SwordWalk_Enabled())
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_swordwalk' );
					}
				}
				else
				{
					if (ACS_PassiveTaunt_Enabled())
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh_passive_taunt' );
					}
					else
					{
						GetWitcherPlayer().ActivateAndSyncBehavior( 'quen_primary_beh' );
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
	
	latent function VampireClaws()
	{
		stupidArray_extra_arms.PushBack( 'Cutscene' );

		//ACS_WeaponDestroyInit();
		//ACS_StopAerondightEffectInit();

		ACS_Sword_Trail_1().Destroy();
		ACS_Sword_Trail_2().Destroy();
		ACS_Sword_Trail_3().Destroy();
		ACS_Sword_Trail_4().Destroy();
		ACS_Sword_Trail_5().Destroy();
		ACS_Sword_Trail_6().Destroy();
		ACS_Sword_Trail_7().Destroy();
		ACS_Sword_Trail_8().Destroy();

		ACS_Vampire_Arms_1_Get().Destroy();

		ACS_Vampire_Arms_2_Get().Destroy();

		ACS_Vampire_Arms_3_Get().Destroy();

		ACS_Vampire_Arms_4_Get().Destroy();

		ACS_Vampire_Arms_Anchor_L_Get().Destroy();

		ACS_Vampire_Arms_Anchor_R_Get().Destroy();

		ACS_Vampire_Head_Anchor_Get().Destroy();

		ACS_Vampire_Head_Get().Destroy();

		stupidArray_extra_arms.PushBack( 'Cutscene' );

		extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0.5;
		attach_vec.Z = -0.4;

		sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_1.AddTag('acs_sword_trail_1');

		sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
		sword_trail_2.AddTag('acs_sword_trail_2');
		
		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = GetWitcherPlayer();

			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

			if (ACS_Armor_Equipped_Check())
			{
				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
			}
			else
			{
				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				if (!ACS_HideVampireClaws_Enabled())
				{
					claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

					((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
				}
			}

			GetWitcherPlayer().PlayEffectSingle('claws_effect');
			GetWitcherPlayer().StopEffect('claws_effect');	
		}

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().StopEffect('dive_shape');	
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			GetWitcherPlayer().StopEffect('blood_color_2');	
			GetWitcherPlayer().PlayEffectSingle('blood_color_2');

			GetWitcherPlayer().StopEffect('blood_effect_claws');
			GetWitcherPlayer().PlayEffectSingle('blood_effect_claws');

			thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP" );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_temp_r = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_right.w2ent", true);	

			extra_arms_temp_l = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_left.w2ent", true);	

			extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_r = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_r.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_r.AddTag('extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('extra_arms_anchor_l');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_1 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_1.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 110;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 200;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = 0.75;
			
			extra_arms_1.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_1.StopEffect('blood');

			extra_arms_1.PlayEffectSingle('blood');

			extra_arms_1.AddTag('vampire_extra_arms_1');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_2 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_2.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 70;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -160;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = -0.75;
			
			extra_arms_2.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_2.StopEffect('blood');

			extra_arms_2.PlayEffectSingle('blood');

			extra_arms_2.AddTag('vampire_extra_arms_2');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_3 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_3.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 160;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = 1.5;
			
			extra_arms_3.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_3.StopEffect('blood');

			extra_arms_3.PlayEffectSingle('blood');

			extra_arms_3.AddTag('vampire_extra_arms_3');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_4 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_4.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 20;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = -1.5;
			
			extra_arms_4.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_4.StopEffect('blood');

			extra_arms_4.PlayEffectSingle('blood');

			extra_arms_4.AddTag('vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_1_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_2_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_3_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_4_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('vampire_head_anchor');

			head_temp = (CEntityTemplate)LoadResource(
			"dlc\dlc_acs\data\entities\other\dettlaff_monster_head.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_2.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_3.w2ent"
			, true);	

			vampire_head = (CEntity)theGame.CreateEntity( head_temp, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = vampire_head.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.2825;
			attach_vec.Y = -0.075;
			attach_vec.Z = 0;
			
			vampire_head.CreateAttachment( vampire_head_anchor, , attach_vec, attach_rot );

			vampire_head.AddTag('vampire_head');

			GetWitcherPlayer().AddTag('ACS_blood_armor');

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		}

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'torso3' ), bone_vec, bone_rot );

		vampire_claw_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

		vampire_claw_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'torso3', bone_vec, bone_rot );

		vampire_claw_anchor.AddTag('vampire_claw_anchor');

		back_claw_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_back_claws.w2ent", true);	

		back_claw = (CEntity)theGame.CreateEntity( back_claw_temp, GetWitcherPlayer().GetWorldPosition() );

		meshcompHead = back_claw.GetComponentByClassName('CMeshComponent');

		h = 2;

		meshcompHead.SetScale(Vector(h,h,h,1));	
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 45;
		attach_vec.X = -1;
		attach_vec.Y = -1;
		attach_vec.Z = 0;
		
		back_claw.CreateAttachment( vampire_claw_anchor, , attach_vec, attach_rot );

		back_claw.AddTag('back_claw');

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		GetWitcherPlayer().AddTag('vampire_claws_equipped');

		/*
		if (!ACS_DisableAutomaticSwordSheathe_Enabled())
		{
			manual_sword_check = 0;

			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', true);
		}
		else if (ACS_DisableAutomaticSwordSheathe_Enabled())
		{
			manual_sword_check = 1;
		}

		watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

		watcher.vACS_Manual_Sword_Drawing_Check.manual_sword_drawing = manual_sword_check;
		*/

		d_comp = GetWitcherPlayer().GetComponentsByClassName( 'CDrawableComponent' );

		for ( i=0; i<d_comp.Size(); i+= 1 )
		{
			((CDrawableComponent)d_comp[ i ]).SetCastingShadows( false );
		}

		GetWitcherPlayer().BlockAction(EIAB_SpecialAttackLight,	'ACS_Vamp_Claws_Block_Action');
		GetWitcherPlayer().BlockAction(EIAB_SpecialAttackHeavy,	'ACS_Vamp_Claws_Block_Action');

		UpdateBehGraph();
	}
	
	latent function IgniSword()
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

			if ( !ACS_HideSwordsheathes_Enabled() && !ACS_CloakEquippedCheck() )
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

			if ( !ACS_HideSwordsheathes_Enabled() && !ACS_CloakEquippedCheck() )
			{
				scabbards_silver = GetWitcherPlayer().inv.GetItemsByCategory('silver_scabbards');

				for ( i=0; i < scabbards_silver.Size() ; i+=1 )
				{
					scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().inv.GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
					//scabbard_silver.SetVisible(true);
				}
			}
		}

		GetWitcherPlayer().AddTag('igni_sword_equipped');
		GetWitcherPlayer().AddTag('igni_secondary_sword_equipped');

		GetWitcherPlayer().AddTag('igni_sword_equipped_TAG');
	}

	latent function ArmigerModeAxiiSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AxiiSwordStatic();
		}
		
		GetWitcherPlayer().AddTag('axii_sword_equipped');
	}

	latent function FocusModeAxiiSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AxiiSwordStatic();
		}
		
		GetWitcherPlayer().AddTag('axii_sword_equipped');
	}

	latent function HybridModeAxiiSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0)
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1)
		{
			AxiiSwordStatic();
		}
		
		GetWitcherPlayer().AddTag('axii_sword_equipped');
	}

	latent function AxiiSwordEvolving()
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
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
			
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0.25;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.01;
					attach_vec.Y = 0;
					attach_vec.Z = 0.35;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0.25;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.01;
					attach_vec.Y = 0;
					attach_vec.Z = 0.35;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('axii_sword_5');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\pridefall\pridefall.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.05;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\voidblade\voidbladeshades.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
			
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.045;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.045;
					
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword5.AddTag('axii_sword_5');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\oblivion\sinter2.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\dlc_shadesofiron\data\items\weapons\sinner\sinter1.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.055;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
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
						
					"items\weapons\unique\eredin_sword.w2ent" 
						
					, true), GetWitcherPlayer().GetWorldPosition() );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.005;
					attach_vec.Y = 0;
					attach_vec.Z = 0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.005;
					attach_vec.Y = 0;
					attach_vec.Z = 0.16;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"items\weapons\unique\eredin_sword.w2ent" 
						
					, true), GetWitcherPlayer().GetWorldPosition() );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.005;
					attach_vec.Y = 0;
					attach_vec.Z = 0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.005;
					attach_vec.Y = 0;
					attach_vec.Z = 0.16;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\unique\unique_silver_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"items\weapons\unique\eredin_sword.w2ent" 
						
					, true), GetWitcherPlayer().GetWorldPosition() );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.005;
					attach_vec.Y = 0;
					attach_vec.Z = 0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.005;
					attach_vec.Y = 0;
					attach_vec.Z = 0.16;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"items\weapons\unique\eredin_sword.w2ent" 
						
					, true), GetWitcherPlayer().GetWorldPosition() );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.005;
					attach_vec.Y = 0;
					attach_vec.Z = 0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');

					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent"
						
					, true), GetWitcherPlayer().GetWorldPosition() );
						
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.005;
					attach_vec.Y = 0;
					attach_vec.Z = 0.16;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0125;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 45;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword3.AddTag('axii_sword_3');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 135;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword4.AddTag('axii_sword_4');
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.2;
					
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('axii_sword_1');
					
					/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
					//AXII SWORD PATH
					
					"dlc\bob\data\items\weapons\swords\knight_swords\knight_lvl1_sword.w2ent" //REPLACE WHAT'S INSIDE THE QUOTATION MARKS
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0;
					
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword2.AddTag('axii_sword_2');
				}
			}
		}
	}

	latent function AxiiSwordStatic()
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
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\unique\eredin_sword.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = -0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.1;
				
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.16;
				
			sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('axii_sword_2');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\unique\eredin_sword.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = -0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.1;
				
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('axii_sword_1');

			sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			// AXII SILVER SWORD PATH
				
			"items\weapons\swords\wildhunt_swords\wildhunt_sword_rusty.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.005;
			attach_vec.Y = 0;
			attach_vec.Z = 0.16;
				
			sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword2.AddTag('axii_sword_2');
		}
	}

	latent function ArmigerModeAardSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}

		GetWitcherPlayer().AddTag('aard_sword_equipped');
	}

	latent function FocusModeAardSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}

		GetWitcherPlayer().AddTag('aard_sword_equipped');
	}

	latent function HybridModeAardSword()
	{	
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			AardSwordStatic();
		}

		GetWitcherPlayer().AddTag('aard_sword_equipped'); 
	}

	latent function EquipmentModeAardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );
		
		ACS_StopAerondightEffectInit();

		ACS_HideSword();
		
		if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			blade_temp_ent = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
		}
		else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			blade_temp_ent = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);
		}
				
		r_blade1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );
		l_blade1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(blade_temp_ent.GetReadableName(), true ), Vector( 0, 0, -20 ) );

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.15;
		attach_vec.Y = -0.075;
		attach_vec.Z = -0.005;
		
		l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

		sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.15;
		attach_vec.Y = -0.075;
		attach_vec.Z = -0.005;
		
		r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

		sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');

		sword_trail_1.AddTag('acs_sword_trail_1');
		sword_trail_2.AddTag('acs_sword_trail_2');

		GetWitcherPlayer().AddTag('aard_sword_equipped');
	}

	latent function AardSwordEvolving()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StopAerondightEffectInit();

		if ( ACS_Warglaives_Installed() && ACS_Warglaives_Enabled() )
		{
			Warglaives_AardSword();
		}
		else
		{
			Normal_AardSword();
		}
	}

	latent function Warglaives_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\swords\gla_black_01.w2ent"

				, true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;

				sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;

				sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;

				sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');

		sword_trail_1.AddTag('acs_sword_trail_1');
		sword_trail_2.AddTag('acs_sword_trail_2');
		sword_trail_3.AddTag('acs_sword_trail_3');
		sword_trail_4.AddTag('acs_sword_trail_4');
		sword_trail_5.AddTag('acs_sword_trail_5');
		sword_trail_6.AddTag('acs_sword_trail_6');
		sword_trail_7.AddTag('acs_sword_trail_7');
		sword_trail_8.AddTag('acs_sword_trail_8');
	}

	latent function SOI_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');

		sword_trail_1.AddTag('acs_sword_trail_1');
		sword_trail_2.AddTag('acs_sword_trail_2');
		sword_trail_3.AddTag('acs_sword_trail_3');
		sword_trail_4.AddTag('acs_sword_trail_4');
		sword_trail_5.AddTag('acs_sword_trail_5');
		sword_trail_6.AddTag('acs_sword_trail_6');
		sword_trail_7.AddTag('acs_sword_trail_7');
		sword_trail_8.AddTag('acs_sword_trail_8');
	}

	latent function Normal_AardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_silver.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_silver.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_silver.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.0525;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.0125;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.0175;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.0525;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.0525;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.0125;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.0175;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.0525;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_silver.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.0525;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.0125;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.0175;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.0525;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.0525;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.0125;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.0175;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				//////////////////////////////////////////////////////////////////////////////////////////
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.0525;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else
			{			
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );
			
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

				sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.045;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.05;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.005;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = 0.045;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.15;
				attach_vec.Y = -0.075;
				attach_vec.Z = -0.05;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');

		sword_trail_1.AddTag('acs_sword_trail_1');
		sword_trail_2.AddTag('acs_sword_trail_2');
		sword_trail_3.AddTag('acs_sword_trail_3');
		sword_trail_4.AddTag('acs_sword_trail_4');
		sword_trail_5.AddTag('acs_sword_trail_5');
		sword_trail_6.AddTag('acs_sword_trail_6');
		sword_trail_7.AddTag('acs_sword_trail_7');
		sword_trail_8.AddTag('acs_sword_trail_8');
	}

	latent function AardSwordStatic()
	{
		ACS_WeaponDestroyInit();
		
		ACS_StopAerondightEffectInit();

		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() && ACS_Warglaives_Installed() && ACS_Warglaives_Enabled() )
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				blade_temp = (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\swords\gla_black_01.w2ent"

				, true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 270;
				attach_rot.Pitch = 90;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.05;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\bloodletter.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\lionsword.w2ent", true );
				//blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\rakuyos.w2ent", true );
				
				r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

				sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = 0.1025;
				
				r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = 0.0325;
				
				r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.15;
				attach_vec.Z = -0.0375;
				
				r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				
				attach_rot.Roll = 90;
				attach_rot.Pitch = 270;
				attach_rot.Yaw = 10;
				attach_vec.X = -0.25;
				attach_vec.Y = -0.05;
				attach_vec.Z = -0.1025;
				
				r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

				sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
			}
		}
		else
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_silver.w2ent", true );
					
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_silver.w2ent", true );
				
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.045;
					
					l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.05;
					
					l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.045;
					
					r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.05;
					
					r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_silver.w2ent", true );
					
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
					
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
					
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
					
					r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
					l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

					sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.05;
					attach_vec.Z = 0.0525;
					
					l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.0125;
					
					l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.0175;
					
					l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.05;
					attach_vec.Z = -0.0525;
					
					l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.05;
					attach_vec.Z = 0.0525;
					
					r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.0125;
					
					r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.0175;
					
					r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.05;
					attach_vec.Z = -0.0525;
					
					r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				}
				else
				{
					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_silver.w2ent", true );
				
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.045;
					
					l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.05;
					
					l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.045;
					
					r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.05;
					
					r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );
					
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_2.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );
				
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.045;
					
					l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.05;
					
					l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.045;
					
					r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.05;
					
					r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );
				
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_7 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_8 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.05;
					attach_vec.Z = 0.0525;
					
					l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.0125;
					
					l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.0175;
					
					l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.05;
					attach_vec.Z = -0.0525;
					
					l_blade4.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_4.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.05;
					attach_vec.Z = 0.0525;
					
					r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.0125;
					
					r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.0175;
					
					r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_7.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					//////////////////////////////////////////////////////////////////////////////////////////
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.05;
					attach_vec.Z = -0.0525;
					
					r_blade4.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_8.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				}
				else
				{			
					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );
				
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_6 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.045;
					
					l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.05;
					
					l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

					sword_trail_3.CreateAttachment( l_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.005;
					
					r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_4.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = 0.045;
					
					r_blade2.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_5.CreateAttachment( r_anchor, , attach_vec, attach_rot );
					
					attach_rot.Roll = 90;
					attach_rot.Pitch = 270;
					attach_rot.Yaw = 10;
					attach_vec.X = -0.15;
					attach_vec.Y = -0.075;
					attach_vec.Z = -0.05;
					
					r_blade3.CreateAttachment( r_anchor, , attach_vec, attach_rot );

					sword_trail_6.CreateAttachment( r_anchor, , attach_vec, attach_rot );
				}
			}
		}

		r_blade1.AddTag('aard_blade_1');
		l_blade1.AddTag('aard_blade_2');
		r_blade2.AddTag('aard_blade_3');
		l_blade2.AddTag('aard_blade_4');
		r_blade3.AddTag('aard_blade_5');
		l_blade3.AddTag('aard_blade_6');
		r_blade4.AddTag('aard_blade_7');
		l_blade4.AddTag('aard_blade_8');
		r_anchor.AddTag('r_hand_anchor_1');
		l_anchor.AddTag('l_hand_anchor_1');

		sword_trail_1.AddTag('acs_sword_trail_1');
		sword_trail_2.AddTag('acs_sword_trail_2');
		sword_trail_3.AddTag('acs_sword_trail_3');
		sword_trail_4.AddTag('acs_sword_trail_4');
		sword_trail_5.AddTag('acs_sword_trail_5');
		sword_trail_6.AddTag('acs_sword_trail_6');
		sword_trail_7.AddTag('acs_sword_trail_7');
		sword_trail_8.AddTag('acs_sword_trail_8');
	}
	
	latent function ArmigerModeYrdenSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}

		GetWitcherPlayer().AddTag('yrden_sword_equipped'); 
	}

	latent function FocusModeYrdenSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}

		GetWitcherPlayer().AddTag('yrden_sword_equipped'); 
	}

	latent function HybridModeYrdenSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			YrdenSwordStatic();
		}
		
		GetWitcherPlayer().AddTag('yrden_sword_equipped');
	}
	
	latent function YrdenSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit();
		
		ACS_StartAerondightEffectInit();

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');	
					*/

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 5;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 30;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_5.AddTag('acs_sword_trail_5');

					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\aquila\eaglesword.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 5;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 30;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_5.AddTag('acs_sword_trail_5');

					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\dlc_shadesofiron\data\items\weapons\bloodletter\bloodletter.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
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
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');	
					*/

					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 5;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 30;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_5.AddTag('acs_sword_trail_5');

					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_01.w2ent"

					"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					/*
					sword2 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = -0.0125;
					attach_vec.Z = 0.7;
						
					sword2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

					sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_1.AddTag('acs_sword_trail_1');

					sword2.AddTag('yrden_sword_2');
					
					sword3 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0;
					attach_vec.Y = 0.0125;
					attach_vec.Z = 0.7;
						
					sword3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_2.AddTag('acs_sword_trail_2');
					
					sword3.AddTag('yrden_sword_3');
					*/
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
					sword_trail_5 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 5;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');

					sword4 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 30;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_5.AddTag('acs_sword_trail_5');

					sword4.AddTag('yrden_sword_4');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
				else
				{
					sword_trail_4 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\spear_02.w2ent"
					
					"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					/*
					attach_rot.Roll = 180;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 1;
					*/

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = -0.1;
						
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('yrden_sword_1');
					
					sword5 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 40;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.2;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_4.AddTag('acs_sword_trail_4');

					sword5.AddTag('yrden_sword_5');
					
					sword6 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
					
					"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 50;
					attach_rot.Pitch = 180;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.4;
					attach_vec.Y = 0;
					attach_vec.Z = 1.4;
						
					sword6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					
					sword_trail_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword_trail_3.AddTag('acs_sword_trail_3');

					sword6.AddTag('yrden_sword_6');
				}
			}
		}
	}

	latent function YrdenSwordStatic()
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
			
			// YRDEN SILVER SWORD PATH

			"dlc\dlc_acs\data\entities\swords\imlerith_mace.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS

			//"dlc\dlc_acs\data\entities\swords\scythe_bone.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.1;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

			sword1.AddTag('yrden_sword_1');
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
			// YRDEN STEEL SWORD PATH

			"dlc\dlc_acs\data\entities\swords\caretaker_shovel.w2ent" // REPLACE WHAT'S INSIDE THE QUOTATION MARKS

			//"dlc\dlc_acs\data\entities\swords\scythe_samurai.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = -0.1;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

			sword1.AddTag('yrden_sword_1');
		}
	}

	latent function ArmigerModeQuenSword()
	{
		if ( ACS_GetArmigerModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetArmigerModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}

		GetWitcherPlayer().AddTag('quen_sword_equipped'); 
	}

	latent function FocusModeQuenSword()
	{
		if ( ACS_GetFocusModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetFocusModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}
	
		GetWitcherPlayer().AddTag('quen_sword_equipped'); 
	}

	latent function HybridModeQuenSword()
	{
		if ( ACS_GetHybridModeWeaponType() == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_GetHybridModeWeaponType() == 1 )
		{
			QuenSwordStatic();
		}
	
		GetWitcherPlayer().AddTag('quen_sword_equipped'); 
	}

	latent function QuenSwordEvolving()
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
				
					"dlc\dlc_shadesofiron\data\items\weapons\vulcan\vulcan.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\vulcan.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\vulcan.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
			
					if( physicalComponent )
					{
						physicalComponent.SetVisible(false);
					}

					sword1.AddTag('quen_sword_upgraded_2');	
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\vulcan.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_shadesofiron\data\items\weapons\khopesh\khopesh.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0.025;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\khopesh.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\khopesh.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
			
					if( physicalComponent )
					{
						physicalComponent.SetVisible(false);
					}

					sword1.AddTag('quen_sword_upgraded_2');	
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\khopesh.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
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

					"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_01.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
			
					if( physicalComponent )
					{
						physicalComponent.SetVisible(false);
					}

					sword1.AddTag('quen_sword_upgraded_2');	
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\hakland_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
			{
				if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 10 || GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) == 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\olgierd_sabre.w2ent"

					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
				else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					"dlc\dlc_acs\data\entities\swords\olgierd_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');	

					physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
			
					if( physicalComponent )
					{
						physicalComponent.SetVisible(false);
					}

					sword1.AddTag('quen_sword_upgraded_2');	
				}
				else
				{
					sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
				
					//"dlc\dlc_acs\data\entities\swords\olgierd_sabre.w2ent"

					"dlc\ep1\data\items\weapons\swords\unique\olgierd_sabre\olgierd_sabre.w2ent"
					
					, true), GetWitcherPlayer().GetWorldPosition() );
					
					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;
					attach_vec.X = 0;
					attach_vec.Y = 0;
					attach_vec.Z = 0.025;
							
					sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
					sword1.AddTag('quen_sword_1');

					sword1.AddTag('quen_sword_upgraded_1');	
				}
			}
		}
	}

	latent function QuenSwordStatic()
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
			
			"dlc\dlc_acs\data\entities\swords\hakland_sabre.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.025;
						
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_sword_1');

			sword1.AddTag('quen_sword_upgraded_1');	
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\entities\swords\olgierd_sabre.w2ent"
			
			, true), GetWitcherPlayer().GetWorldPosition() );
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.025;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('quen_sword_1');	

			sword1.AddTag('quen_sword_upgraded_1');	
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

statemachine class cClawEquipStandalone
{
    function Claw_Equip_Standalone_Engage()
	{
		this.PushState('Claw_Equip_Standalone_Engage');
	}
}

state Claw_Equip_Standalone_Engage in cClawEquipStandalone
{
	private var claw_temp, head_temp, extra_arms_anchor_temp, extra_arms_temp_r, extra_arms_temp_l, back_claw_temp																			: CEntityTemplate;
	private var p_actor 																																									: CActor;
	private var p_comp, meshcompHead, p_comp_2																																				: CComponent;
	private var animatedComponent_extra_arms 																																				: CAnimatedComponent;
	private var stupidArray_extra_arms 																																						: array< name >;
	private var attach_vec, bone_vec																																						: Vector;
	private var attach_rot, bone_rot																																						: EulerAngles;
	private var extra_arms_anchor_r, extra_arms_anchor_l, extra_arms_1, extra_arms_2, extra_arms_3, extra_arms_4, vampire_head_anchor, vampire_head, back_claw, vampire_claw_anchor			: CEntity;
	private var h 																																											: float;
	private var manual_sword_check																																							: int;
	private var watcher																																										: W3ACSWatcher;
	private var sword_trail_1, sword_trail_2, sword_trail_3, sword_trail_4, sword_trail_5, sword_trail_6, sword_trail_7, sword_trail_8 														: CEntity;
	private var trail_temp																																									: CEntityTemplate;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawEquipStandalone_Entry();
	}
	
	entry function ClawEquipStandalone_Entry()
	{
		ClawEquipStandalone_Latent();
	}
	
	latent function ClawEquipStandalone_Latent()
	{
		ACS_Sword_Trail_1().Destroy();
		ACS_Sword_Trail_2().Destroy();
		ACS_Sword_Trail_3().Destroy();
		ACS_Sword_Trail_4().Destroy();
		ACS_Sword_Trail_5().Destroy();
		ACS_Sword_Trail_6().Destroy();
		ACS_Sword_Trail_7().Destroy();
		ACS_Sword_Trail_8().Destroy();

		ACS_Vampire_Arms_1_Get().Destroy();

		ACS_Vampire_Arms_2_Get().Destroy();

		ACS_Vampire_Arms_3_Get().Destroy();

		ACS_Vampire_Arms_4_Get().Destroy();

		ACS_Vampire_Arms_Anchor_L_Get().Destroy();

		ACS_Vampire_Arms_Anchor_R_Get().Destroy();

		ACS_Vampire_Head_Anchor_Get().Destroy();

		ACS_Vampire_Head_Get().Destroy();

		stupidArray_extra_arms.PushBack( 'Cutscene' );

		extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 0;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0.5;
		attach_vec.Z = -0.4;

		sword_trail_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
		sword_trail_1.AddTag('acs_sword_trail_1');

		sword_trail_2.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
		sword_trail_2.AddTag('acs_sword_trail_2');

		if (!ACS_GetItem_VampClaw_Shades())
		{
			p_actor = GetWitcherPlayer();

			p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

			if (ACS_Armor_Equipped_Check())
			{
				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
			}
			else
			{
				claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent", true);	

				((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(claw_temp);

				if (!ACS_HideVampireClaws_Enabled())
				{
					claw_temp = (CEntityTemplate)LoadResource(	"dlc\dlc_acs\data\entities\swords\vamp_claws.w2ent", true);	

					((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(claw_temp);
				}
			}

			GetWitcherPlayer().PlayEffectSingle('claws_effect');
			GetWitcherPlayer().StopEffect('claws_effect');
		}

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().StopEffect('dive_shape');	
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			GetWitcherPlayer().StopEffect('blood_color_2');
			GetWitcherPlayer().PlayEffectSingle('blood_color_2');

			GetWitcherPlayer().StopEffect('blood_effect_claws');
			GetWitcherPlayer().PlayEffectSingle('blood_effect_claws');

			thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP" );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_temp_r = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_right.w2ent", true);	

			extra_arms_temp_l = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_left.w2ent", true);	

			extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_r = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_r.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_r.AddTag('extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('extra_arms_anchor_l');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_1 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_1.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 110;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 200;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = 0.75;
			
			extra_arms_1.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_1.StopEffect('blood');

			extra_arms_1.PlayEffectSingle('blood');

			extra_arms_1.AddTag('vampire_extra_arms_1');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_2 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_2.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 70;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -160;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = -0.75;
			
			extra_arms_2.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_2.StopEffect('blood');

			extra_arms_2.PlayEffectSingle('blood');

			extra_arms_2.AddTag('vampire_extra_arms_2');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_3 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_3.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 160;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = 1.5;
			
			extra_arms_3.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_3.StopEffect('blood');

			extra_arms_3.PlayEffectSingle('blood');

			extra_arms_3.AddTag('vampire_extra_arms_3');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_4 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_4.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 20;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = -1.5;
			
			extra_arms_4.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_4.StopEffect('blood');

			extra_arms_4.PlayEffectSingle('blood');

			extra_arms_4.AddTag('vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_1_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_2_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_3_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_4_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('vampire_head_anchor');

			head_temp = (CEntityTemplate)LoadResource(
			"dlc\dlc_acs\data\entities\other\dettlaff_monster_head.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_2.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_3.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_4.w2ent"
			, true);

			vampire_head = (CEntity)theGame.CreateEntity( head_temp, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = vampire_head.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.2825;
			attach_vec.Y = -0.075;
			attach_vec.Z = 0;
			
			vampire_head.CreateAttachment( vampire_head_anchor, , attach_vec, attach_rot );

			vampire_head.AddTag('vampire_head');

			GetWitcherPlayer().AddTag('ACS_blood_armor');
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'torso3' ), bone_vec, bone_rot );

		vampire_claw_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

		vampire_claw_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'torso3', bone_vec, bone_rot );

		vampire_claw_anchor.AddTag('vampire_claw_anchor');

		back_claw_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_back_claws.w2ent", true);	

		back_claw = (CEntity)theGame.CreateEntity( back_claw_temp, GetWitcherPlayer().GetWorldPosition() );

		meshcompHead = back_claw.GetComponentByClassName('CMeshComponent');

		h = 2;

		meshcompHead.SetScale(Vector(h,h,h,1));	
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 45;
		attach_vec.X = -1;
		attach_vec.Y = -1;
		attach_vec.Z = 0;
		
		back_claw.CreateAttachment( vampire_claw_anchor, , attach_vec, attach_rot );

		back_claw.AddTag('back_claw');

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
		GetWitcherPlayer().AddTag('vampire_claws_equipped');	

		/*
		if (!ACS_DisableAutomaticSwordSheathe_Enabled())
		{
			manual_sword_check = 0;

			theGame.GetInGameConfigWrapper().SetVarValue('Gameplay', 'DisableAutomaticSwordSheathe', true);
		}
		else if (ACS_DisableAutomaticSwordSheathe_Enabled())
		{
			manual_sword_check = 1;
		}

		watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

		watcher.vACS_Manual_Sword_Drawing_Check.manual_sword_drawing = manual_sword_check;
		*/

		p_comp_2 =  GetWitcherPlayer().GetComponentByClassName ( 'CMeshComponent' );

		((CDrawableComponent)p_comp_2).SetCastingShadows ( false );

		GetWitcherPlayer().BlockAction(EIAB_SpecialAttackLight,	'ACS_Vamp_Claws_Block_Action');
		GetWitcherPlayer().BlockAction(EIAB_SpecialAttackHeavy,	'ACS_Vamp_Claws_Block_Action');

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			//theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( GetWitcherPlayer(), 'CastSignAction', -1, 20.0f, -1.f, -1, true );

			if (ACS_SCAAR_Installed() && ACS_SCAAR_Enabled() && !ACS_E3ARP_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_SCAAR' );
				}
			}
			else if (ACS_E3ARP_Installed() && ACS_E3ARP_Enabled() && !ACS_SCAAR_Enabled())
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_PassiveTaunt_Enabled())
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh_passive_taunt' );
				}
				else
				{
					GetWitcherPlayer().ActivateAndSyncBehavior( 'claw_beh' );
				}

				if ( GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetCurrentStateName() != 'Combat') 
				{
					GetWitcherPlayer().GotoState( 'Combat' );
				}
			}

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'locomotion_walkstart_forward_dettlaff_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1) );
		}
	}
}

function ACS_BloodArmorStandalone()
{
	var vBloodArmorStandalone : cBloodArmorStandalone;
	vBloodArmorStandalone = new cBloodArmorStandalone in theGame;

	if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
	{
		if (
		( ACS_GetWeaponMode() == 0 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 1 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 2 && ACS_GetFistMode() == 1 )
		|| ( ACS_GetWeaponMode() == 3 && (ACS_GetItem_VampClaw_Shades() || ACS_GetItem_VampClaw() ) )
		)
		{
			vBloodArmorStandalone.Blood_Armor_Standalone_Engage();	
		}
	}
}

statemachine class cBloodArmorStandalone
{
    function Blood_Armor_Standalone_Engage()
	{
		this.PushState('Blood_Armor_Standalone_Engage');
	}
}

state Blood_Armor_Standalone_Engage in cBloodArmorStandalone
{
	private var head_temp, extra_arms_anchor_temp, extra_arms_temp_r, extra_arms_temp_l, back_claw_temp																						: CEntityTemplate;
	private var p_actor 																																									: CActor;
	private var p_comp, meshcompHead																																						: CComponent;
	private var animatedComponent_extra_arms 																																				: CAnimatedComponent;
	private var stupidArray_extra_arms 																																						: array< name >;
	private var attach_vec, bone_vec																																						: Vector;
	private var attach_rot, bone_rot																																						: EulerAngles;
	private var extra_arms_anchor_r, extra_arms_anchor_l, extra_arms_1, extra_arms_2, extra_arms_3, extra_arms_4, vampire_head_anchor, vampire_head, back_claw, vampire_claw_anchor			: CEntity;
	private var h 																																											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Blood_Armor_Standalone_Entry();
	}
	
	entry function Blood_Armor_Standalone_Entry()
	{
		Blood_Armor_Standalone_Latent();
	}
	
	latent function Blood_Armor_Standalone_Latent()
	{
		ACS_Vampire_Arms_1_Get().Destroy();

		ACS_Vampire_Arms_2_Get().Destroy();

		ACS_Vampire_Arms_3_Get().Destroy();

		ACS_Vampire_Arms_4_Get().Destroy();

		ACS_Vampire_Arms_Anchor_L_Get().Destroy();

		ACS_Vampire_Arms_Anchor_R_Get().Destroy();

		ACS_Vampire_Head_Anchor_Get().Destroy();

		ACS_Vampire_Head_Get().Destroy();

		extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			thePlayer.SoundEvent( "monster_dettlaff_monster_vein_beating_heart_LP" );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_temp_r = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_right.w2ent", true);	

			extra_arms_temp_l = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_left.w2ent", true);	

			extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_r = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_r.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_r.AddTag('extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('extra_arms_anchor_l');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_1 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_1.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 110;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 200;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = 0.75;
			
			extra_arms_1.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_1.StopEffect('blood');

			extra_arms_1.PlayEffectSingle('blood');

			extra_arms_1.AddTag('vampire_extra_arms_1');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_2 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_2.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 70;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -160;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = -0.75;
			
			extra_arms_2.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_2.StopEffect('blood');

			extra_arms_2.PlayEffectSingle('blood');

			extra_arms_2.AddTag('vampire_extra_arms_2');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_3 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_3.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 160;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = 1.5;
			
			extra_arms_3.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_3.StopEffect('blood');

			extra_arms_3.PlayEffectSingle('blood');

			extra_arms_3.AddTag('vampire_extra_arms_3');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_4 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_4.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 20;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = -1.5;
			
			extra_arms_4.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_4.StopEffect('blood');

			extra_arms_4.PlayEffectSingle('blood');

			extra_arms_4.AddTag('vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_1_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_2_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_3_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACS_Vampire_Arms_4_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			GetWitcherPlayer().PlayEffectSingle('claws_effect');
			GetWitcherPlayer().StopEffect('claws_effect');

			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('vampire_head_anchor');

			head_temp = (CEntityTemplate)LoadResource(
			"dlc\dlc_acs\data\entities\other\dettlaff_monster_head.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_2.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_3.w2ent"
			//"dlc\dlc_acs\data\entities\other\dettlaff_monster_head_4.w2ent"
			, true);

			vampire_head = (CEntity)theGame.CreateEntity( head_temp, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = vampire_head.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.2825;
			attach_vec.Y = -0.075;
			attach_vec.Z = 0;
			
			vampire_head.CreateAttachment( vampire_head_anchor, , attach_vec, attach_rot );

			vampire_head.AddTag('vampire_head');

			GetWitcherPlayer().AddTag('ACS_blood_armor');
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}

// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.