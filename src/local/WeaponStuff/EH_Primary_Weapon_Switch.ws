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
	private var h 																																																																																								: float;
	private var d_comp																																																																																							: array<CComponent>;							
	private var i, manual_sword_check																																																																																			: int;								
	private var watcher																																																																																							: W3ACSWatcher;
	private var steelswordentity, silverswordentity 																																																																															: CEntity;	
	private var physicalComponent 																																																																																				: CMeshComponent;
	private var stupidArray 																																																																																					: array< name >;

	event OnEnterState(prevStateName : name)
	{
		if (ACS_New_Replacers_Female_Active()
		)
		{
			return false;
		}

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
				if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();				
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
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
				if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();	
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
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
				if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();	
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();				
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
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
				if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
					{
						ArmigerModeAxiiSword();

						AxiiSwordSwitch();				
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
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
				if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
				{
					if (!GetWitcherPlayer().HasTag('acs_igni_sword_equipped'))
					{
						IgniSword();

						IgniSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
				{
					if (!GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
					{
						ArmigerModeQuenSword();

						QuenSwordSwitch();
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
				{
					if (!GetWitcherPlayer().HasTag('acs_axii_sword_equipped'))
					{
						ArmigerModeAxiiSword(); 

						AxiiSwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
				{
					if (!GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
					{
						ArmigerModeAardSword();

						AardSwordSwitch();			
					}
				}
				else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
				{
					if (!GetWitcherPlayer().HasTag('acs_yrden_sword_equipped'))
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
				if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
				{
					NormalFistsSwitch();
				}
				else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1 && !GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') )
				{
					VampireClaws();

					VampireClawsSwitch();
				}
				else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 && !GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
				{
					SorcFists();

					SorcFistsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		else if ( ACS_GetWeaponMode() == 1)
		{
			if 
			(
				( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped') )
				|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_igni_sword_equipped') )
			)
			{
				IgniSword();

				IgniSwordSwitch();
			}
			
			else if  
			(
				( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
				|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
			)
			{
				FocusModeAxiiSword();

				AxiiSwordSwitch();
			}
			
			else if  
			(
				( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
				|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
			)
			{
				FocusModeAardSword();

				AardSwordSwitch();
			}
			
			else if  
			(
				( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
				|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
			)
			{
				FocusModeYrdenSword();

				YrdenSwordSwitch();
			}
			
			else if 
			(
				( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
				|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
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
				if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
				{
					NormalFistsSwitch();
				}
				else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1 && !GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
				{
					VampireClaws();

					VampireClawsSwitch();
				}
				else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 && !GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
				{
					SorcFists();

					SorcFistsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		else if ( ACS_GetWeaponMode() == 2)
		{
			if 
			(
				GetWitcherPlayer().HasTag('ACSHybridDefaultWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_igni_sword_equipped') )
				{
					IgniSword();

					IgniSwordSwitch();
				}	

				ACS_HybridTagRemoval();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('ACSHybridEredinWeaponTicket') 
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
				{
					HybridModeAxiiSword();

					AxiiSwordSwitch();
				}

				ACS_HybridTagRemoval();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('ACSHybridClawWeaponTicket') 
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
				{
					HybridModeAardSword();

					AardSwordSwitch();
				}

				ACS_HybridTagRemoval();
			}
			
			else if  
			(
				GetWitcherPlayer().HasTag('ACSHybridImlerithWeaponTicket')
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
				{
					HybridModeYrdenSword();

					YrdenSwordSwitch();
				}

				ACS_HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().HasTag('ACSHybridOlgierdWeaponTicket') 
			)
			{
				if (!GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
				{
					HybridModeQuenSword();

					QuenSwordSwitch();
				}

				ACS_HybridTagRemoval();
			}
			
			else if 
			(
				GetWitcherPlayer().IsWeaponHeld( 'fist' )
			)
			{
				if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
				{
					NormalFistsSwitch();
				}
				else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1 && !GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
				{
					VampireClaws();

					VampireClawsSwitch();
				}
				else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 && !GetWitcherPlayer().HasTag('acs_sorc_fists_equipped') )
				{
					SorcFists();

					SorcFistsSwitch();
				}
			}

			//Sleep(0.125);

			WeaponSummonEffect();
		}
		
		else if ( ACS_GetWeaponMode() == 3 )
		{
			if 
			(
				( ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
				|| ( ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit(true);

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

				GetWitcherPlayer().AddTag('acs_axii_sword_equipped');

				AxiiSwordSwitch();
			}
			
			else if 
			(
				( ACS_GetItem_Claws_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
				|| ( ACS_GetItem_Claws_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_aard_sword_equipped') )
			)
			{
				EquipmentModeAardSword();

				AardSwordSwitch();

				//Sleep(0.125);

				WeaponSummonEffect();
			}
			
			else if 
			(
				( ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
				|| ( ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
				|| ( ACS_GetItem_MageStaff_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit(true);
				
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

				GetWitcherPlayer().AddTag('acs_yrden_sword_equipped');

				YrdenSwordSwitch();
			}
			
			else if 
			(
				( ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
				|| ( ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_quen_sword_equipped') )
			)
			{
				ACS_WeaponDestroyInit(true);

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

				GetWitcherPlayer().AddTag('acs_quen_sword_equipped');

				if (ACS_GetItem_Iris() && !ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodIconicSwordVFXOffEnabled', false))
				{
					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
				}

				QuenSwordSwitch();
			}
			else if 
			(
				( ACS_GetItem_Katana_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
				|| ( ACS_GetItem_Katana_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
			)
			{
				GetACSWatcher().SecondaryWeaponSwitch();
			}

			else if 
			(
				ACS_GetItem_MageStaff_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && !GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') 
			)
			{
				ACS_WeaponDestroyInit(true);
				
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

				GetWitcherPlayer().AddTag('acs_yrden_sword_equipped');

				YrdenSwordSwitch();
			}

			else if 
			(
				GetWitcherPlayer().IsAnyWeaponHeld() && GetWitcherPlayer().IsWeaponHeld( 'fist' )
			)
			{
				if 
				(
					ACS_GetItem_VampClaw_Shades() || ACS_GetItem_VampClaw()
				)
				{
					if 
					(
						!GetWitcherPlayer().HasTag('acs_vampire_claws_equipped')
					)
					{
						ACS_WeaponDestroyInit(true);

						VampireClaws();

						VampireClawsSwitch();
					}
				}
				else if 
				(
					ACS_GetItem_SorcFists()
				)
				{
					if 
					(
						!GetWitcherPlayer().HasTag('acs_sorc_fists_equipped')
					)
					{
						ACS_WeaponDestroyInit(true);

						SorcFists();

						SorcFistsSwitch();
					}
				}
				else
				{
					NormalFistsSwitch();
				}
			}
		}
	}

	latent function WeaponSummonEffect()
	{
		GetWitcherPlayer().RemoveTimer('ACS_Weapon_Summon_Delay');
		
		if (GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_igni_sword_effect_played'))
		{
			acs_igni_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('acs_igni_sword_effect_played');
			GetWitcherPlayer().AddTag('acs_igni_secondary_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('acs_axii_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_axii_sword_effect_played'))
		{
			acs_igni_sword_summon();

			//acs_axii_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('acs_axii_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_aard_sword_effect_played'))
		{
			//acs_aard_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('acs_aard_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_yrden_sword_effect_played'))
		{
			acs_igni_sword_summon();

			//acs_yrden_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('acs_yrden_sword_effect_played');
		}
		else if (GetWitcherPlayer().HasTag('acs_quen_sword_equipped')
		&& !GetWitcherPlayer().HasTag('acs_quen_sword_effect_played'))
		{
			acs_igni_sword_summon();

			//acs_quen_sword_summon();

			GetACSWatcher().AddTimer('ACS_Weapon_Summon_Delay', 0.125, false);

			GetWitcherPlayer().AddTag('acs_quen_sword_effect_played');
		}
	}

	latent function NormalFistsSwitch()
	{
		if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
		{
			GetACSWatcher().ClawDestroy_WITH_EFFECT();
		}

		if (GetWitcherPlayer().HasTag('acs_sorc_fists_equipped'))
		{
			GetACSWatcher().SorcFistDestroy();
		}

		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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

			UpdateBehGraph();
		}
	}

	latent function VampireClawsSwitch()
	{
		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			//theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( GetWitcherPlayer(), 'CastSignAction', -1, 20.0f, -1.f, -1, true );

			if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
			}
			else
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' );
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

			ACS_ExplorationDelayHack();
		}
	}

	latent function SorcFistsSwitch()
	{
		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
			{
				
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' );
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

	latent function IgniSwordSwitch()
	{
		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
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

			UpdateBehGraph();
		}
	}

	latent function AxiiSwordSwitch()
	{		
		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
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

			UpdateBehGraph();
		}
	}
			
	latent function AardSwordSwitch()
	{		
		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
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

			UpdateBehGraph();
		}
	}
			
	latent function YrdenSwordSwitch()
	{		
		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
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

			UpdateBehGraph();
		}
	}
			
	latent function QuenSwordSwitch()
	{		
		if (!GetWitcherPlayer().IsSwimming()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
					}
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
					}
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
					}
				}
				else
				{
					if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
					{
						
						stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
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

			UpdateBehGraph();
		}
	}
	
	latent function VampireClaws()
	{
		var anchor_temp, blade_temp											: CEntityTemplate;
		var 
		r_anchor1, 
		r_anchor2,
		r_anchor3,
		r_anchor4,
		r_anchor5,

		l_anchor1, 
		l_anchor2,
		l_anchor3,
		l_anchor4,
		l_anchor5,

		r_blade1, 
		r_blade2,
		r_blade3,
		r_blade4,
		r_blade5,

		l_blade1,
		l_blade2,
		l_blade3,
		l_blade4,
		l_blade5	

		: CEntity;

		var bone_vec, attach_vec											: Vector;
		var bone_rot, attach_rot											: EulerAngles;

		var morphManager : CMorphedMeshManagerComponent;

		ACS_SwordTrailDestroy();

		ACSGetCEntity('acs_vampire_extra_arms_1').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_2').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_3').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_4').Destroy();

		ACSGetCEntity('acs_extra_arms_anchor_l').Destroy();

		ACSGetCEntity('acs_extra_arms_anchor_r').Destroy();

		ACSGetCEntity('acs_vampire_head_anchor').Destroy();

		ACSGetCEntity('acs_vampire_head').Destroy();

		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').RemoveTag('ACS_Vamp_Claws_R1_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').RemoveTag('ACS_Vamp_Claws_R2_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').RemoveTag('ACS_Vamp_Claws_R3_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').RemoveTag('ACS_Vamp_Claws_R4_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').RemoveTag('ACS_Vamp_Claws_R5_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').RemoveTag('ACS_Vamp_Claws_L1_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').RemoveTag('ACS_Vamp_Claws_L2_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').RemoveTag('ACS_Vamp_Claws_L3_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').RemoveTag('ACS_Vamp_Claws_L4_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').RemoveTag('ACS_Vamp_Claws_L5_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R1').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R1').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R1').RemoveTag('ACS_Vamp_Claws_R1');

		ACSGetCEntity('ACS_Vamp_Claws_R2').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R2').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R2').RemoveTag('ACS_Vamp_Claws_R2');

		ACSGetCEntity('ACS_Vamp_Claws_R3').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R3').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R3').RemoveTag('ACS_Vamp_Claws_R3');

		ACSGetCEntity('ACS_Vamp_Claws_R4').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R4').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R4').RemoveTag('ACS_Vamp_Claws_R4');

		ACSGetCEntity('ACS_Vamp_Claws_R5').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R5').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R5').RemoveTag('ACS_Vamp_Claws_R5');

		ACSGetCEntity('ACS_Vamp_Claws_L1').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L1').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L1').RemoveTag('ACS_Vamp_Claws_L1');

		ACSGetCEntity('ACS_Vamp_Claws_L2').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L2').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L2').RemoveTag('ACS_Vamp_Claws_L2');

		ACSGetCEntity('ACS_Vamp_Claws_L3').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L3').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L3').RemoveTag('ACS_Vamp_Claws_L3');

		ACSGetCEntity('ACS_Vamp_Claws_L4').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L4').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L4').RemoveTag('ACS_Vamp_Claws_L4');

		ACSGetCEntity('ACS_Vamp_Claws_L5').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L5').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L5').RemoveTag('ACS_Vamp_Claws_L5');

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

			if (ACS_Armor_Equipped_Check() || ACS_GetItem_VampClaw_ACS_Armor())
			{
				
			}
			else
			{
				if (!ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodHideVampireClaws', false))
				{
					anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\models\vamp_claws\blood\vamp_claws_singular_morph_bone.w2ent", true );

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_thumb3' ), bone_vec, bone_rot );
					r_anchor1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor1.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_thumb3', bone_vec, bone_rot );
					r_anchor1.AddTag('ACS_Vamp_Claws_R1_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_index3' ), bone_vec, bone_rot );
					r_anchor2 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor2.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_index3', bone_vec, bone_rot );
					r_anchor2.AddTag('ACS_Vamp_Claws_R2_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_middle3' ), bone_vec, bone_rot );
					r_anchor3 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor3.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_middle3', bone_vec, bone_rot );
					r_anchor3.AddTag('ACS_Vamp_Claws_R3_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_ring3' ), bone_vec, bone_rot );
					r_anchor4 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor4.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_ring3', bone_vec, bone_rot );
					r_anchor4.AddTag('ACS_Vamp_Claws_R4_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_pinky3' ), bone_vec, bone_rot );
					r_anchor5 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor5.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_pinky3', bone_vec, bone_rot );
					r_anchor5.AddTag('ACS_Vamp_Claws_R5_Anchor');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_thumb3' ), bone_vec, bone_rot );
					l_anchor1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor1.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_thumb3', bone_vec, bone_rot );
					l_anchor1.AddTag('ACS_Vamp_Claws_L1_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_index3' ), bone_vec, bone_rot );
					l_anchor2 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor2.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_index3', bone_vec, bone_rot );
					l_anchor2.AddTag('ACS_Vamp_Claws_L2_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_middle3' ), bone_vec, bone_rot );
					l_anchor3 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor3.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_middle3', bone_vec, bone_rot );
					l_anchor3.AddTag('ACS_Vamp_Claws_L3_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_ring3' ), bone_vec, bone_rot );
					l_anchor4 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor4.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_ring3', bone_vec, bone_rot );
					l_anchor4.AddTag('ACS_Vamp_Claws_L4_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_pinky3' ), bone_vec, bone_rot );
					l_anchor5 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor5.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_pinky3', bone_vec, bone_rot );
					l_anchor5.AddTag('ACS_Vamp_Claws_L5_Anchor');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade5 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade5 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

					r_blade1.AddTag('ACS_Vamp_Claws_R1');
					r_blade2.AddTag('ACS_Vamp_Claws_R2');
					r_blade3.AddTag('ACS_Vamp_Claws_R3');
					r_blade4.AddTag('ACS_Vamp_Claws_R4');
					r_blade5.AddTag('ACS_Vamp_Claws_R5');

					l_blade1.AddTag('ACS_Vamp_Claws_L1');
					l_blade2.AddTag('ACS_Vamp_Claws_L2');
					l_blade3.AddTag('ACS_Vamp_Claws_L3');
					l_blade4.AddTag('ACS_Vamp_Claws_L4');
					l_blade5.AddTag('ACS_Vamp_Claws_L5');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					attach_rot.Roll = 90;
					attach_rot.Pitch = -90;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0825;
					attach_vec.Y = 0.00625;
					attach_vec.Z = 0.0;
					
					r_blade1.CreateAttachment( r_anchor1, , attach_vec, attach_rot );

					l_blade1.CreateAttachment( l_anchor1, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade2.CreateAttachment( r_anchor2, , attach_vec, attach_rot );

					l_blade2.CreateAttachment( l_anchor2, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade3.CreateAttachment( r_anchor3, , attach_vec, attach_rot );

					l_blade3.CreateAttachment( l_anchor3, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					r_blade4.CreateAttachment( r_anchor4, , attach_vec, attach_rot );

					l_blade4.CreateAttachment( l_anchor4, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade5.CreateAttachment( r_anchor5, , attach_vec, attach_rot );

					l_blade5.CreateAttachment( l_anchor5, , attach_vec, attach_rot );


					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					morphManager = (CMorphedMeshManagerComponent) r_blade1.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade2.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade3.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade4.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade5.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade1.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade2.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade3.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade4.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade5.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );
				}
			}
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

			extra_arms_anchor_r.AddTag('acs_extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('acs_extra_arms_anchor_l');

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

			extra_arms_1.AddTag('acs_vampire_extra_arms_1');	

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

			extra_arms_2.AddTag('acs_vampire_extra_arms_2');	

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

			extra_arms_3.AddTag('acs_vampire_extra_arms_3');	

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

			extra_arms_4.AddTag('acs_vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_1').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_2').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_3').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_4').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('acs_vampire_head_anchor');

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

			vampire_head.AddTag('acs_vampire_head');

			GetWitcherPlayer().AddTag('ACS_blood_armor');

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		}

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'torso3' ), bone_vec, bone_rot );

		vampire_claw_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

		vampire_claw_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'torso3', bone_vec, bone_rot );

		vampire_claw_anchor.AddTag('acs_vampire_claw_anchor');

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

		back_claw.StopEffect('blood_color');

		back_claw.PlayEffectSingle('blood_color');

		back_claw.AddTag('acs_vampire_back_claw');

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		GetWitcherPlayer().AddTag('acs_vampire_claws_equipped');

		UpdateBehGraph();
	}

	latent function SorcFists()
	{
		var ent_1, ent_2            : CEntity;
		var rot                     : EulerAngles;
		var pos						: Vector;

		ACSGetCEntity('ACS_Sorc_Fist_Fx_1').Destroy();

		ACSGetCEntity('ACS_Sorc_Fist_Fx_2').Destroy();

		rot = thePlayer.GetWorldRotation();

		pos = thePlayer.GetWorldPosition();

		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

		, true ), pos, rot );

		ent_1.PlayEffectSingle('sorc_hand_fx');

		ent_1.AddTag('ACS_Sorc_Fist_Fx_1');

		ent_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon' );

		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

		, true ), pos, rot );

		ent_2.PlayEffectSingle('sorc_hand_fx');

		ent_2.AddTag('ACS_Sorc_Fist_Fx_2');

		ent_2.CreateAttachment( GetWitcherPlayer(), 'l_weapon' );

		GetWitcherPlayer().AddTag('acs_sorc_fists_equipped');

		UpdateBehGraph();
	}
	
	latent function IgniSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		steelsword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID)).GetMeshComponent());
		silversword = (CDrawableComponent)((GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID)).GetMeshComponent());
		
		ACS_WeaponDestroyInit(true);

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

			if ( !ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodHideSwordsheathes', false) && !ACS_CloakEquippedCheck() )
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

			if ( !ACS_Settings_Main_Bool('EHmodVisualSettings','EHmodHideSwordsheathes', false) && !ACS_CloakEquippedCheck() )
			{
				scabbards_silver = GetWitcherPlayer().inv.GetItemsByCategory('silver_scabbards');

				for ( i=0; i < scabbards_silver.Size() ; i+=1 )
				{
					scabbard_silver = (CDrawableComponent)((GetWitcherPlayer().inv.GetItemEntityUnsafe(scabbards_silver[i])).GetMeshComponent());
					//scabbard_silver.SetVisible(true);
				}
			}
		}

		GetWitcherPlayer().AddTag('acs_igni_sword_equipped');
		GetWitcherPlayer().AddTag('acs_igni_secondary_sword_equipped');

		GetWitcherPlayer().AddTag('acs_igni_sword_equipped_TAG');
	}

	latent function ArmigerModeAxiiSword()
	{
		if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 0 )
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 1 )
		{
			AxiiSwordStatic();
		}
		
		GetWitcherPlayer().AddTag('acs_axii_sword_equipped');
	}

	latent function FocusModeAxiiSword()
	{
		if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeWeaponType', 0) == 0 )
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeWeaponType', 0) == 1 )
		{
			AxiiSwordStatic();
		}
		
		GetWitcherPlayer().AddTag('acs_axii_sword_equipped');
	}

	latent function HybridModeAxiiSword()
	{
		if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeWeaponType', 0) == 0)
		{
			AxiiSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeWeaponType', 0) == 1)
		{
			AxiiSwordStatic();
		}
		
		GetWitcherPlayer().AddTag('acs_axii_sword_equipped');
	}

	latent function AxiiSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit(true);

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
					sword1.AddTag('acs_axii_sword_1');
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
					sword1.AddTag('acs_axii_sword_1');

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
					sword2.AddTag('acs_axii_sword_2');

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
					sword3.AddTag('acs_axii_sword_3');
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
					sword1.AddTag('acs_axii_sword_1');
					
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
					sword2.AddTag('acs_axii_sword_2');
					
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
					sword3.AddTag('acs_axii_sword_3');
					
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
					sword4.AddTag('acs_axii_sword_4');

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
					sword5.AddTag('acs_axii_sword_5');
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
					sword1.AddTag('acs_axii_sword_1');

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
					sword2.AddTag('acs_axii_sword_2');

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
					sword3.AddTag('acs_axii_sword_3');
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
					sword1.AddTag('acs_axii_sword_1');
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
					sword1.AddTag('acs_axii_sword_1');
					
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
					sword2.AddTag('acs_axii_sword_2');

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
					sword3.AddTag('acs_axii_sword_3');
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
					sword1.AddTag('acs_axii_sword_1');
					
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
					sword2.AddTag('acs_axii_sword_2');

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
					sword3.AddTag('acs_axii_sword_3');

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
					sword4.AddTag('acs_axii_sword_4');

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
					sword5.AddTag('acs_axii_sword_5');
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
					sword1.AddTag('acs_axii_sword_1');
					
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
					sword2.AddTag('acs_axii_sword_2');

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
					sword3.AddTag('acs_axii_sword_3');
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
					sword1.AddTag('acs_axii_sword_1');

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
					sword2.AddTag('acs_axii_sword_2');
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
					sword1.AddTag('acs_axii_sword_1');

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
					sword2.AddTag('acs_axii_sword_2');
					
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
					sword3.AddTag('acs_axii_sword_3');
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
					sword1.AddTag('acs_axii_sword_1');
					
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
					sword2.AddTag('acs_axii_sword_2');
					
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
					sword3.AddTag('acs_axii_sword_3');
					
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
					sword4.AddTag('acs_axii_sword_4');
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
					sword1.AddTag('acs_axii_sword_1');
					
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
					sword2.AddTag('acs_axii_sword_2');
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
					sword1.AddTag('acs_axii_sword_1');

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
					sword2.AddTag('acs_axii_sword_2');
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
					sword1.AddTag('acs_axii_sword_1');

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
					sword2.AddTag('acs_axii_sword_2');
					
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
					sword3.AddTag('acs_axii_sword_3');
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
					sword1.AddTag('acs_axii_sword_1');
					
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
					sword2.AddTag('acs_axii_sword_2');
					
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
					sword3.AddTag('acs_axii_sword_3');
					
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
					sword4.AddTag('acs_axii_sword_4');
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
					sword1.AddTag('acs_axii_sword_1');
					
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
					sword2.AddTag('acs_axii_sword_2');
				}
			}
		}
	}

	latent function AxiiSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit(true);

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
			sword1.AddTag('acs_axii_sword_1');

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
			sword2.AddTag('acs_axii_sword_2');
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
			sword1.AddTag('acs_axii_sword_1');

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
			sword2.AddTag('acs_axii_sword_2');
		}
	}

	latent function ArmigerModeAardSword()
	{
		if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 1 )
		{
			AardSwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_aard_sword_equipped');
	}

	latent function FocusModeAardSword()
	{
		if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeWeaponType', 0) == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeWeaponType', 0) == 1 )
		{
			AardSwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_aard_sword_equipped');
	}

	latent function HybridModeAardSword()
	{	
		if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeWeaponType', 0) == 0 )
		{
			AardSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeWeaponType', 0) == 1 )
		{
			AardSwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_aard_sword_equipped'); 
	}

	latent function EquipmentModeAardSword()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit(true);

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		r_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_hand', bone_vec, bone_rot );
		
		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_hand', bone_vec, bone_rot );

		//ACS_HideSword();

		if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			blade_temp_ent = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(steelID);
		}
		else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			blade_temp_ent = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(silverID);
		}

		if (blade_temp_ent.GetReadableName() == "dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_chain_weapon.w2ent"
		)
		{
			ACS_Create_Claw_Chains();
		}
		else
		{
			r_anchor.PlayEffect('shadowdash_construct_small');
			l_anchor.PlayEffect('shadowdash_construct_small');

			r_anchor.PlayEffect('mist_regis');
			l_anchor.PlayEffect('mist_regis');

			r_anchor.PlayEffect('mist_regis_q702');
			l_anchor.PlayEffect('mist_regis_q702');

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

			r_blade1.AddTag('acs_aard_blade_1');
			l_blade1.AddTag('acs_aard_blade_2');
			r_anchor.AddTag('acs_r_hand_anchor_1');
			l_anchor.AddTag('acs_l_hand_anchor_1');

			sword_trail_1.AddTag('acs_sword_trail_1');
			sword_trail_2.AddTag('acs_sword_trail_2');
		}
		
		GetWitcherPlayer().AddTag('acs_aard_sword_equipped');
	}

	latent function AardSwordEvolving()
	{
		ACS_WeaponDestroyInit(true);
		
		

		if ( ACS_Is_DLC_Installed('dlc_glaives_9897'))
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

		r_anchor.PlayEffect('shadowdash_construct_small');
		l_anchor.PlayEffect('shadowdash_construct_small');

		r_anchor.PlayEffect('mist_regis');
		l_anchor.PlayEffect('mist_regis');

		r_anchor.PlayEffect('mist_regis_q702');
		l_anchor.PlayEffect('mist_regis_q702');

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

		r_blade1.AddTag('acs_aard_blade_1');
		l_blade1.AddTag('acs_aard_blade_2');
		r_blade2.AddTag('acs_aard_blade_3');
		l_blade2.AddTag('acs_aard_blade_4');
		r_blade3.AddTag('acs_aard_blade_5');
		l_blade3.AddTag('acs_aard_blade_6');
		r_blade4.AddTag('acs_aard_blade_7');
		l_blade4.AddTag('acs_aard_blade_8');
		r_anchor.AddTag('acs_r_hand_anchor_1');
		l_anchor.AddTag('acs_l_hand_anchor_1');

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

		r_anchor.PlayEffect('shadowdash_construct_small');
		l_anchor.PlayEffect('shadowdash_construct_small');

		r_anchor.PlayEffect('mist_regis');
		l_anchor.PlayEffect('mist_regis');

		r_anchor.PlayEffect('mist_regis_q702');
		l_anchor.PlayEffect('mist_regis_q702');

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

		r_blade1.AddTag('acs_aard_blade_1');
		l_blade1.AddTag('acs_aard_blade_2');
		r_blade2.AddTag('acs_aard_blade_3');
		l_blade2.AddTag('acs_aard_blade_4');
		r_blade3.AddTag('acs_aard_blade_5');
		l_blade3.AddTag('acs_aard_blade_6');
		r_blade4.AddTag('acs_aard_blade_7');
		l_blade4.AddTag('acs_aard_blade_8');
		r_anchor.AddTag('acs_r_hand_anchor_1');
		l_anchor.AddTag('acs_l_hand_anchor_1');

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

		r_anchor.PlayEffect('shadowdash_construct_small');
		l_anchor.PlayEffect('shadowdash_construct_small');

		r_anchor.PlayEffect('mist_regis');
		l_anchor.PlayEffect('mist_regis');

		r_anchor.PlayEffect('mist_regis_q702');
		l_anchor.PlayEffect('mist_regis_q702');

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

		r_blade1.AddTag('acs_aard_blade_1');
		l_blade1.AddTag('acs_aard_blade_2');
		r_blade2.AddTag('acs_aard_blade_3');
		l_blade2.AddTag('acs_aard_blade_4');
		r_blade3.AddTag('acs_aard_blade_5');
		l_blade3.AddTag('acs_aard_blade_6');
		r_blade4.AddTag('acs_aard_blade_7');
		l_blade4.AddTag('acs_aard_blade_8');
		r_anchor.AddTag('acs_r_hand_anchor_1');
		l_anchor.AddTag('acs_l_hand_anchor_1');

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
		ACS_WeaponDestroyInit(true);
		
		

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

		r_anchor.PlayEffect('shadowdash_construct_small');
		l_anchor.PlayEffect('shadowdash_construct_small');

		r_anchor.PlayEffect('mist_regis');
		l_anchor.PlayEffect('mist_regis');

		r_anchor.PlayEffect('mist_regis_q702');
		l_anchor.PlayEffect('mist_regis_q702');

		if ( ACS_Is_DLC_Installed('dlc_050_51') && ACS_Is_DLC_Installed('dlc_glaives_9897') )
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

		r_blade1.AddTag('acs_aard_blade_1');
		l_blade1.AddTag('acs_aard_blade_2');
		r_blade2.AddTag('acs_aard_blade_3');
		l_blade2.AddTag('acs_aard_blade_4');
		r_blade3.AddTag('acs_aard_blade_5');
		l_blade3.AddTag('acs_aard_blade_6');
		r_blade4.AddTag('acs_aard_blade_7');
		l_blade4.AddTag('acs_aard_blade_8');
		r_anchor.AddTag('acs_r_hand_anchor_1');
		l_anchor.AddTag('acs_l_hand_anchor_1');

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
		if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 1 )
		{
			YrdenSwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_yrden_sword_equipped'); 
	}

	latent function FocusModeYrdenSword()
	{
		if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeWeaponType', 0) == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeWeaponType', 0) == 1 )
		{
			YrdenSwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_yrden_sword_equipped'); 
	}

	latent function HybridModeYrdenSword()
	{
		if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeWeaponType', 0) == 0 )
		{
			YrdenSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeWeaponType', 0) == 1 )
		{
			YrdenSwordStatic();
		}
		
		GetWitcherPlayer().AddTag('acs_yrden_sword_equipped');
	}
	
	latent function YrdenSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit(true);

		trail_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_2 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		sword_trail_3 = (CEntity)theGame.CreateEntity( trail_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		if ( ACS_Is_DLC_Installed('dlc_050_51')  )
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword2.AddTag('acs_yrden_sword_2');
					
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
					
					sword3.AddTag('acs_yrden_sword_3');	
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

					sword2.AddTag('acs_yrden_sword_2');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword2.AddTag('acs_yrden_sword_2');
					
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
					
					sword3.AddTag('acs_yrden_sword_3');
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword2.AddTag('acs_yrden_sword_2');
					
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
					
					sword3.AddTag('acs_yrden_sword_3');
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

					sword4.AddTag('acs_yrden_sword_4');
					
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword2.AddTag('acs_yrden_sword_2');
					
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
					
					sword3.AddTag('acs_yrden_sword_3');
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');

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

					sword4.AddTag('acs_yrden_sword_4');
					
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword2.AddTag('acs_yrden_sword_2');
					
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
					
					sword3.AddTag('acs_yrden_sword_3');	
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

					sword2.AddTag('acs_yrden_sword_2');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword2.AddTag('acs_yrden_sword_2');
					
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
					
					sword3.AddTag('acs_yrden_sword_3');
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword2.AddTag('acs_yrden_sword_2');
					
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
					
					sword3.AddTag('acs_yrden_sword_3');
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

					sword4.AddTag('acs_yrden_sword_4');
					
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword2.AddTag('acs_yrden_sword_2');
					
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
					
					sword3.AddTag('acs_yrden_sword_3');
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');

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

					sword4.AddTag('acs_yrden_sword_4');
					
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
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
					sword1.AddTag('acs_yrden_sword_1');
					
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

					sword5.AddTag('acs_yrden_sword_5');
					
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

					sword6.AddTag('acs_yrden_sword_6');
				}
			}
		}
	}

	latent function YrdenSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit(true);
		
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

			sword1.AddTag('acs_yrden_sword_1');
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

			sword1.AddTag('acs_yrden_sword_1');
		}
	}

	latent function ArmigerModeQuenSword()
	{
		if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerModeWeaponType', 0) == 1 )
		{
			QuenSwordStatic();
		}

		GetWitcherPlayer().AddTag('acs_quen_sword_equipped'); 
	}

	latent function FocusModeQuenSword()
	{
		if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeWeaponType', 0) == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeWeaponType', 0) == 1 )
		{
			QuenSwordStatic();
		}
	
		GetWitcherPlayer().AddTag('acs_quen_sword_equipped'); 
	}

	latent function HybridModeQuenSword()
	{
		if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeWeaponType', 0) == 0 )
		{
			QuenSwordEvolving();
		}
		else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeWeaponType', 0) == 1 )
		{
			QuenSwordStatic();
		}
	
		GetWitcherPlayer().AddTag('acs_quen_sword_equipped'); 
	}

	latent function QuenSwordEvolving()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);
		
		ACS_WeaponDestroyInit(true);

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
				sword1.AddTag('acs_quen_sword_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) <= 11 && GetWitcherPlayer().GetInventory().GetItemLevel(silverID) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
				"dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_novalis.w2ent"
				
				, true), GetWitcherPlayer().GetWorldPosition() );
				
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.025;
						
				sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_quen_sword_1');

				sword1.AddTag('acs_quen_sword_upgraded_1');	
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( silverID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( silverID ) >= 2 ) 
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
				"dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_novalis.w2ent"
				
				, true), GetWitcherPlayer().GetWorldPosition() );
				
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.025;
						
				sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_quen_sword_1');

				physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
		
				if( physicalComponent )
				{
					physicalComponent.SetVisible(false);
				}

				sword1.AddTag('acs_quen_sword_upgraded_2');	
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
				"dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_novalis.w2ent"
				
				, true), GetWitcherPlayer().GetWorldPosition() );
				
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.025;
						
				sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_quen_sword_1');

				sword1.AddTag('acs_quen_sword_upgraded_1');	
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
				sword1.AddTag('acs_quen_sword_1');
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 11 && GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) <= 20 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) > 1 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
				"dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_true_iris.w2ent"

				, true), GetWitcherPlayer().GetWorldPosition() );
				
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.025;
						
				sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_quen_sword_1');

				sword1.AddTag('acs_quen_sword_upgraded_1');	
			}
			else if ( GetWitcherPlayer().GetInventory().GetItemLevel( steelID ) >= 21 && GetWitcherPlayer().GetInventory().GetItemQuality( steelID ) >= 2 )
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
				"dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_true_iris.w2ent"
				
				, true), GetWitcherPlayer().GetWorldPosition() );
				
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.025;
						
				sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_quen_sword_1');	

				physicalComponent = (CMeshComponent)(sword1.GetComponentByClassName('CRigidMeshComponent'));
		
				if( physicalComponent )
				{
					physicalComponent.SetVisible(false);
				}

				sword1.AddTag('acs_quen_sword_upgraded_2');	
			}
			else
			{
				sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
			
				"dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_true_iris.w2ent"
				
				, true), GetWitcherPlayer().GetWorldPosition() );
				
				attach_rot.Roll = 0;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 0;
				attach_vec.X = 0;
				attach_vec.Y = 0;
				attach_vec.Z = 0.025;
						
				sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
				sword1.AddTag('acs_quen_sword_1');

				sword1.AddTag('acs_quen_sword_upgraded_1');	
			}
		}
	}

	latent function QuenSwordStatic()
	{
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
		GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

		ACS_WeaponDestroyInit(true);

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
			
			"dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_true_iris.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.025;
						
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_quen_sword_1');

			sword1.AddTag('acs_quen_sword_upgraded_1');	
		}
		else if ( GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) )
		{
			sword1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\entities\equipment_mode_weapons\acs_true_iris.w2ent"
			
			, true), GetWitcherPlayer().GetWorldPosition() );
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0.025;
					
			sword1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			sword1.AddTag('acs_quen_sword_1');	

			sword1.AddTag('acs_quen_sword_upgraded_1');	
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
	private var attach_vec, bone_vec																																						: Vector;
	private var attach_rot, bone_rot																																						: EulerAngles;
	private var extra_arms_anchor_r, extra_arms_anchor_l, extra_arms_1, extra_arms_2, extra_arms_3, extra_arms_4, vampire_head_anchor, vampire_head, back_claw, vampire_claw_anchor			: CEntity;
	private var h 																																											: float;
	private var manual_sword_check																																							: int;
	private var watcher																																										: W3ACSWatcher;
	private var sword_trail_1, sword_trail_2, sword_trail_3, sword_trail_4, sword_trail_5, sword_trail_6, sword_trail_7, sword_trail_8 														: CEntity;
	private var trail_temp																																									: CEntityTemplate;
	private var stupidArray 																																								: array< name >;
	private var weapontype 																																																																																						: EPlayerWeapon;
	private var res 																																																																																							: bool;
	
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawEquipStandalone_Entry();
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

	entry function ClawEquipStandalone_Entry()
	{
		var anchor_temp, blade_temp											: CEntityTemplate;
	
		var 

		r_anchor1, 
		r_anchor2,
		r_anchor3,
		r_anchor4,
		r_anchor5,

		l_anchor1, 
		l_anchor2,
		l_anchor3,
		l_anchor4,
		l_anchor5,

		r_blade1, 
		r_blade2,
		r_blade3,
		r_blade4,
		r_blade5,

		l_blade1,
		l_blade2,
		l_blade3,
		l_blade4,
		l_blade5	

		: CEntity;

		var bone_vec, attach_vec											: Vector;
		var bone_rot, attach_rot											: EulerAngles;

		var morphManager : CMorphedMeshManagerComponent;

		ACS_SwordTrailDestroy();

		ACSGetCEntity('acs_vampire_extra_arms_1').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_2').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_3').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_4').Destroy();

		ACSGetCEntity('acs_extra_arms_anchor_l').Destroy();

		ACSGetCEntity('acs_extra_arms_anchor_r').Destroy();

		ACSGetCEntity('acs_vampire_head_anchor').Destroy();

		ACSGetCEntity('acs_vampire_head').Destroy();

		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R1_Anchor').RemoveTag('ACS_Vamp_Claws_R1_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R2_Anchor').RemoveTag('ACS_Vamp_Claws_R2_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R3_Anchor').RemoveTag('ACS_Vamp_Claws_R3_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R4_Anchor').RemoveTag('ACS_Vamp_Claws_R4_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R5_Anchor').RemoveTag('ACS_Vamp_Claws_R5_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L1_Anchor').RemoveTag('ACS_Vamp_Claws_L1_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L2_Anchor').RemoveTag('ACS_Vamp_Claws_L2_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L3_Anchor').RemoveTag('ACS_Vamp_Claws_L3_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L4_Anchor').RemoveTag('ACS_Vamp_Claws_L4_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L5_Anchor').RemoveTag('ACS_Vamp_Claws_L5_Anchor');

		ACSGetCEntity('ACS_Vamp_Claws_R1').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R1').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R1').RemoveTag('ACS_Vamp_Claws_R1');

		ACSGetCEntity('ACS_Vamp_Claws_R2').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R2').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R2').RemoveTag('ACS_Vamp_Claws_R2');

		ACSGetCEntity('ACS_Vamp_Claws_R3').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R3').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R3').RemoveTag('ACS_Vamp_Claws_R3');

		ACSGetCEntity('ACS_Vamp_Claws_R4').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R4').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R4').RemoveTag('ACS_Vamp_Claws_R4');

		ACSGetCEntity('ACS_Vamp_Claws_R5').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_R5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_R5').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_R5').RemoveTag('ACS_Vamp_Claws_R5');

		ACSGetCEntity('ACS_Vamp_Claws_L1').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L1').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L1').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L1').RemoveTag('ACS_Vamp_Claws_L1');

		ACSGetCEntity('ACS_Vamp_Claws_L2').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L2').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L2').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L2').RemoveTag('ACS_Vamp_Claws_L2');

		ACSGetCEntity('ACS_Vamp_Claws_L3').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L3').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L3').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L3').RemoveTag('ACS_Vamp_Claws_L3');

		ACSGetCEntity('ACS_Vamp_Claws_L4').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L4').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L4').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L4').RemoveTag('ACS_Vamp_Claws_L4');

		ACSGetCEntity('ACS_Vamp_Claws_L5').BreakAttachment(); 
		ACSGetCEntity('ACS_Vamp_Claws_L5').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACSGetCEntity('ACS_Vamp_Claws_L5').DestroyAfter(0.00125);
		ACSGetCEntity('ACS_Vamp_Claws_L5').RemoveTag('ACS_Vamp_Claws_L5');

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
			if (ACS_Armor_Equipped_Check() || ACS_GetItem_VampClaw_ACS_Armor())
			{
				
			}
			else
			{
				if (!ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodHideVampireClaws', false))
				{
					anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

					blade_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\models\vamp_claws\blood\vamp_claws_singular_morph_bone.w2ent", true );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_thumb3' ), bone_vec, bone_rot );
					r_anchor1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor1.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_thumb3', bone_vec, bone_rot );
					r_anchor1.AddTag('ACS_Vamp_Claws_R1_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_index3' ), bone_vec, bone_rot );
					r_anchor2 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor2.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_index3', bone_vec, bone_rot );
					r_anchor2.AddTag('ACS_Vamp_Claws_R2_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_middle3' ), bone_vec, bone_rot );
					r_anchor3 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor3.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_middle3', bone_vec, bone_rot );
					r_anchor3.AddTag('ACS_Vamp_Claws_R3_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_ring3' ), bone_vec, bone_rot );
					r_anchor4 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor4.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_ring3', bone_vec, bone_rot );
					r_anchor4.AddTag('ACS_Vamp_Claws_R4_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'r_pinky3' ), bone_vec, bone_rot );
					r_anchor5 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					r_anchor5.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_pinky3', bone_vec, bone_rot );
					r_anchor5.AddTag('ACS_Vamp_Claws_R5_Anchor');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_thumb3' ), bone_vec, bone_rot );
					l_anchor1 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor1.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_thumb3', bone_vec, bone_rot );
					l_anchor1.AddTag('ACS_Vamp_Claws_L1_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_index3' ), bone_vec, bone_rot );
					l_anchor2 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor2.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_index3', bone_vec, bone_rot );
					l_anchor2.AddTag('ACS_Vamp_Claws_L2_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_middle3' ), bone_vec, bone_rot );
					l_anchor3 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor3.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_middle3', bone_vec, bone_rot );
					l_anchor3.AddTag('ACS_Vamp_Claws_L3_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_ring3' ), bone_vec, bone_rot );
					l_anchor4 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor4.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_ring3', bone_vec, bone_rot );
					l_anchor4.AddTag('ACS_Vamp_Claws_L4_Anchor');

					thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'l_pinky3' ), bone_vec, bone_rot );
					l_anchor5 = (CEntity)theGame.CreateEntity( anchor_temp, thePlayer.GetWorldPosition() );
					l_anchor5.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_pinky3', bone_vec, bone_rot );
					l_anchor5.AddTag('ACS_Vamp_Claws_L5_Anchor');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					r_blade5 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

					l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade4 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );
					l_blade5 = (CEntity)theGame.CreateEntity( blade_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

					r_blade1.AddTag('ACS_Vamp_Claws_R1');
					r_blade2.AddTag('ACS_Vamp_Claws_R2');
					r_blade3.AddTag('ACS_Vamp_Claws_R3');
					r_blade4.AddTag('ACS_Vamp_Claws_R4');
					r_blade5.AddTag('ACS_Vamp_Claws_R5');

					l_blade1.AddTag('ACS_Vamp_Claws_L1');
					l_blade2.AddTag('ACS_Vamp_Claws_L2');
					l_blade3.AddTag('ACS_Vamp_Claws_L3');
					l_blade4.AddTag('ACS_Vamp_Claws_L4');
					l_blade5.AddTag('ACS_Vamp_Claws_L5');

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					attach_rot.Roll = 90;
					attach_rot.Pitch = -90;
					attach_rot.Yaw = 0;
					attach_vec.X = -0.0825;
					attach_vec.Y = 0.00625;
					attach_vec.Z = 0.0;
					
					r_blade1.CreateAttachment( r_anchor1, , attach_vec, attach_rot );

					l_blade1.CreateAttachment( l_anchor1, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade2.CreateAttachment( r_anchor2, , attach_vec, attach_rot );

					l_blade2.CreateAttachment( l_anchor2, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade3.CreateAttachment( r_anchor3, , attach_vec, attach_rot );

					l_blade3.CreateAttachment( l_anchor3, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
					
					r_blade4.CreateAttachment( r_anchor4, , attach_vec, attach_rot );

					l_blade4.CreateAttachment( l_anchor4, , attach_vec, attach_rot );

					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					r_blade5.CreateAttachment( r_anchor5, , attach_vec, attach_rot );

					l_blade5.CreateAttachment( l_anchor5, , attach_vec, attach_rot );


					//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

					morphManager = (CMorphedMeshManagerComponent) r_blade1.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade2.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade3.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade4.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) r_blade5.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade1.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade2.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade3.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade4.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );

					morphManager = (CMorphedMeshManagerComponent) l_blade5.GetComponentByClassName('CMorphedMeshManagerComponent');
					morphManager.SetMorphBlend( 1, 1 );
				}
			}
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

			extra_arms_anchor_r.AddTag('acs_extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('acs_extra_arms_anchor_l');

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

			extra_arms_1.AddTag('acs_vampire_extra_arms_1');	

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

			extra_arms_2.AddTag('acs_vampire_extra_arms_2');	

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

			extra_arms_3.AddTag('acs_vampire_extra_arms_3');	

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

			extra_arms_4.AddTag('acs_vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_1').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_2').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_3').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_4').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('acs_vampire_head_anchor');

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

			vampire_head.AddTag('acs_vampire_head');

			GetWitcherPlayer().AddTag('ACS_blood_armor');
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'torso3' ), bone_vec, bone_rot );

		vampire_claw_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

		vampire_claw_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'torso3', bone_vec, bone_rot );

		vampire_claw_anchor.AddTag('acs_vampire_claw_anchor');

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

		back_claw.StopEffect('blood_color');

		back_claw.PlayEffectSingle('blood_color');

		back_claw.AddTag('acs_vampire_back_claw');

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
		GetWitcherPlayer().AddTag('acs_vampire_claws_equipped');	

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

		if (!theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsThrowingItemWithAim()
		&& !GetWitcherPlayer().IsThrowingItem()
		&& !GetWitcherPlayer().IsThrowHold()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		&& GetWitcherPlayer().IsAlive())
		{
			//theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( GetWitcherPlayer(), 'CastSignAction', -1, 20.0f, -1.f, -1, true );

			if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' );
				}
			}
			else
			{
				if ( GetWitcherPlayer().GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' );
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
}

function ACS_BloodArmorStandalone()
{
	var vBloodArmorStandalone : cBloodArmorStandalone;
	vBloodArmorStandalone = new cBloodArmorStandalone in theGame;

	if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
	{
		if (
		( ACS_GetWeaponMode() == 0 && ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1 )
		|| ( ACS_GetWeaponMode() == 1 && ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1 )
		|| ( ACS_GetWeaponMode() == 2 && ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1 )
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
		ACSGetCEntity('acs_vampire_extra_arms_1').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_2').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_3').Destroy();

		ACSGetCEntity('acs_vampire_extra_arms_4').Destroy();

		ACSGetCEntity('acs_extra_arms_anchor_l').Destroy();

		ACSGetCEntity('acs_extra_arms_anchor_r').Destroy();

		ACSGetCEntity('acs_vampire_head_anchor').Destroy();

		ACSGetCEntity('acs_vampire_head').Destroy();

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

			extra_arms_anchor_r.AddTag('acs_extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('acs_extra_arms_anchor_l');

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

			extra_arms_1.AddTag('acs_vampire_extra_arms_1');	

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

			extra_arms_2.AddTag('acs_vampire_extra_arms_2');	

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

			extra_arms_3.AddTag('acs_vampire_extra_arms_3');	

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

			extra_arms_4.AddTag('acs_vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_3.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_4.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms.PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_1').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_2').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_3').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			ACSGetCEntity('acs_vampire_extra_arms_4').GetRootAnimatedComponent().PlaySkeletalAnimationAsync( 'cs704_detlaff_morphs' );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('acs_vampire_head_anchor');

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

			vampire_head.AddTag('acs_vampire_head');

			GetWitcherPlayer().AddTag('ACS_blood_armor');
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	}
}

// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server. Not authorized to be distributed elsewhere, unless you ask me nicely.