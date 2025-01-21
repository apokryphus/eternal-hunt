function ACS_TauntInit()
{
	var vTaunt : cTaunt;
	vTaunt = new cTaunt in theGame;

	if (!thePlayer.IsPerformingFinisher() 
	&& !thePlayer.IsCrossbowHeld() 
	&& !thePlayer.IsInHitAnim() 
	&& !thePlayer.HasTag('acs_blood_sucking') 
	&& !thePlayer.HasTag('acs_in_wraith')
	&& !thePlayer.IsInAir()
	&& thePlayer.IsActionAllowed(EIAB_Movement)
	&& thePlayer.IsActionAllowed(EIAB_LightAttacks)
	&& ACS_BuffCheck()
	&& !ACS_Transformation_Activated_Check()
	)		
	{
		ACS_ThingsThatShouldBeRemoved(false);
		vTaunt.Engage();
	}
}

statemachine class cTaunt
{
    function Engage()
	{
		this.PushState('acsTauntEngage');
	}
}
 
state acsTauntEngage in cTaunt
{
	private var movementAdjustor													: CMovementAdjustor;
	private var ticket 																: SMovementAdjustmentRequestTicket;
	private var actor																: CActor;
	private var i 																	: int;
	private var npc     															: CNewNPC;
	private var npcactor     														: CActor;
	private var actors																: array< CActor >;
	private var animatedComponentA 													: CAnimatedComponent;
	private var tauntMovementAdjustor												: CMovementAdjustor; 
	private var tauntTicket 														: SMovementAdjustmentRequestTicket; 
	private var markerNPC_1, markerNPC_2											: CEntity;
	private var markerTemplate_1, markerTemplate_2 									: CEntityTemplate;
	private var targetPos															: Vector;
	private var targetRot															: EulerAngles;
	private var watcher																: W3ACSWatcher;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		TauntSwitch();
	}
	
	entry function TauntSwitch()
	{
		watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

		if (theInput.GetActionValue('GI_AxisLeftY') == 0 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{	
			if ( thePlayer.IsAnyWeaponHeld() && !thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( ACS_GetWeaponMode() == 0 )
				{
					if ( thePlayer.GetEquippedSign() == ST_Quen)
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
						{
							normal_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
						{
							olgierd_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
						{
							eredin_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
						{
							claw_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
						{
							imlerith_combat_taunt();
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Aard)
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
						{
							normal_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
						{
							olgierd_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
						{
							eredin_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
						{
							claw_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
						{
							imlerith_combat_taunt();
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Axii)
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
						{
							normal_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
						{
							olgierd_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
						{
							eredin_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
						{
							claw_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
						{
							imlerith_combat_taunt();
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Yrden)
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
						{
							normal_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
						{
							olgierd_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
						{
							eredin_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
						{
							claw_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
						{
							imlerith_combat_taunt();
						}	
					}	
					else if ( thePlayer.GetEquippedSign() == ST_Igni)
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
						{
							normal_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
						{
							olgierd_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
						{
							eredin_combat_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
						{
							claw_taunt();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
						{
							imlerith_combat_taunt();
						}
					}
				}
				else if ( ACS_GetWeaponMode() == 1 )
				{
					if ( 
					ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') 
					)
					{
						olgierd_combat_taunt();
					}
					else if ( 
					ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						claw_taunt();
					}
					else if ( 
					 ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						eredin_combat_taunt();	
					}
					else if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') 
					)
					{
						imlerith_combat_taunt();	
					}	
					else if ( 
					ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped')
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped')
					)
					{
						normal_combat_taunt();	
					}
					else if ( 
					ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
					)
					{
						imlerith_combat_taunt();	
					}
					else if ( 
					ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						eredin_combat_taunt();	
					}
					else if ( 
					ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6  && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
					)
					{
						imlerith_combat_taunt();	
					}
					else if ( 
					ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8  && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						normal_combat_taunt();	
					}
				}
				else if ( ACS_GetWeaponMode() == 2 )
				{
					if ( 
					thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						olgierd_combat_taunt();
					}
					else if ( 
					thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						claw_taunt();
					}
					else if ( 
					thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						eredin_combat_taunt();	
					}
					else if ( 
					thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						imlerith_combat_taunt();	
					}	
					else if ( 
					thePlayer.HasTag('acs_igni_secondary_sword_equipped')
					)
					{
						normal_combat_taunt();	
					}
					else if ( 
					thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						imlerith_combat_taunt();	
					}
					else if ( 
					thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						eredin_combat_taunt();	
					}
					else if ( 
					thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						imlerith_combat_taunt();	
					}
					else if ( 
					thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						normal_combat_taunt();	
					}
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{
					if ( 
					ACS_GetItem_Olgierd_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') 
					|| ACS_GetItem_Olgierd_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						olgierd_combat_taunt();
					}
					else if ( 
					ACS_GetItem_Claws_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') 
					|| ACS_GetItem_Claws_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						claw_taunt();
					}
					else if ( 
					ACS_GetItem_Eredin_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') 
					|| ACS_GetItem_Eredin_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						eredin_combat_taunt();	
					}
					else if ( 
					ACS_GetItem_Imlerith_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') 
					|| ACS_GetItem_Imlerith_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						imlerith_combat_taunt();	
					}	
					else if ( 
					ACS_GetItem_Spear_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
					|| ACS_GetItem_Spear_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						imlerith_combat_taunt();	
					}
					else if ( 
					ACS_GetItem_Greg_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					|| ACS_GetItem_Greg_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						eredin_combat_taunt();	
					}
					else if ( 
					ACS_GetItem_Hammer_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
					|| ACS_GetItem_Hammer_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						imlerith_combat_taunt();	
					}
					else if ( 
					ACS_GetItem_Axe_Silver() && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					|| ACS_GetItem_Axe_Steel() && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						normal_combat_taunt();	
					}
					else
					{
						normal_combat_taunt();	
					}
				}
			}
			else if ( thePlayer.IsWeaponHeld( 'fist' ) && thePlayer.HasTag('acs_vampire_claws_equipped') )
			{
				claw_taunt();	
			}
			
			if (ACS_Settings_Main_Bool('EHmodTauntSettings','EHmodTauntSystemEnabled', false))
			{
				playerTaunt();
				NPC_Taunt_EnemyBoost();
			}	
		}	
	}

	latent function playerTaunt()
	{
		if ( !thePlayer.IsInCombat() && ACS_Settings_Main_Bool('EHmodTauntSettings','EHmodIWannaPlayGwentEnabled', false) )
		{
			thePlayer.RaiseEvent('ACS_GoPloughYourself');

			thePlayer.RemoveTag('ACS_taunt_begin');
			thePlayer.RemoveTag('ACS_taunt_1');
			thePlayer.RemoveTag('ACS_taunt_2');
			thePlayer.RemoveTag('ACS_taunt_3');
			thePlayer.RemoveTag('ACS_taunt_4');
			thePlayer.RemoveTag('ACS_taunt_5');
			thePlayer.RemoveTag('ACS_taunt_6');
			thePlayer.RemoveTag('ACS_taunt_7');
			thePlayer.RemoveTag('ACS_taunt_8');
			thePlayer.RemoveTag('ACS_taunt_9');
			thePlayer.RemoveTag('ACS_taunt_10');
			thePlayer.RemoveTag('ACS_taunt_11');
			thePlayer.RemoveTag('ACS_taunt_12');

			if (
				!thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& !thePlayer.HasTag('ACS_passive_taunt_1') 
				&& !thePlayer.HasTag('ACS_passive_taunt_2')
				&& !thePlayer.HasTag('ACS_passive_taunt_3')
				&& !thePlayer.HasTag('ACS_passive_taunt_4')
				&& !thePlayer.HasTag('ACS_passive_taunt_5')
				&& !thePlayer.HasTag('ACS_passive_taunt_6')
				&& !thePlayer.HasTag('ACS_passive_taunt_7')
				&& !thePlayer.HasTag('ACS_passive_taunt_8')
				&& !thePlayer.HasTag('ACS_passive_taunt_9')
				&& !thePlayer.HasTag('ACS_passive_taunt_10')
				&& !thePlayer.HasTag('ACS_passive_taunt_11')
				&& !thePlayer.HasTag('ACS_passive_taunt_12')
				&& !thePlayer.HasTag('ACS_passive_taunt_13')
				&& !thePlayer.HasTag('ACS_passive_taunt_14')
				&& !thePlayer.HasTag('ACS_passive_taunt_15')
				&& !thePlayer.HasTag('ACS_passive_taunt_16')
				&& !thePlayer.HasTag('ACS_passive_taunt_17')
				&& !thePlayer.HasTag('ACS_passive_taunt_18')
				&& !thePlayer.HasTag('ACS_passive_taunt_19')
				&& !thePlayer.HasTag('ACS_passive_taunt_20')
				&& !thePlayer.HasTag('ACS_passive_taunt_21')
			)
			{
				thePlayer.PlayLine( 587823, true);

				thePlayer.AddTag('ACS_passive_taunt_begin');
				thePlayer.AddTag('ACS_passive_taunt_1');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_1'))
			{
				thePlayer.PlayLine( 1188473, true);

				thePlayer.RemoveTag('ACS_passive_taunt_1');
				thePlayer.AddTag('ACS_passive_taunt_2');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_2'))
			{
				thePlayer.PlayLine( 1188488, true);

				thePlayer.RemoveTag('ACS_passive_taunt_2');
				thePlayer.AddTag('ACS_passive_taunt_3');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_3'))
			{
				thePlayer.PlayLine( 1188495, true);

				thePlayer.RemoveTag('ACS_passive_taunt_3');
				thePlayer.AddTag('ACS_passive_taunt_4');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_4'))
			{
				thePlayer.PlayLine( 1188498, true);

				thePlayer.RemoveTag('ACS_passive_taunt_4');
				thePlayer.AddTag('ACS_passive_taunt_5');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_5'))
			{
				thePlayer.PlayLine( 1188504, true);

				thePlayer.RemoveTag('ACS_passive_taunt_5');
				thePlayer.AddTag('ACS_passive_taunt_6');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_6'))
			{
				thePlayer.PlayLine( 1188506, true);

				thePlayer.RemoveTag('ACS_passive_taunt_6');
				thePlayer.AddTag('ACS_passive_taunt_7');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_7'))
			{
				thePlayer.PlayLine( 1136548, true);

				thePlayer.RemoveTag('ACS_passive_taunt_7');
				thePlayer.AddTag('ACS_passive_taunt_8');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_8'))
			{
				thePlayer.PlayLine( 1137383, true);

				thePlayer.RemoveTag('ACS_passive_taunt_8');
				thePlayer.AddTag('ACS_passive_taunt_9');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_9'))
			{
				thePlayer.PlayLine( 1136707, true);

				thePlayer.RemoveTag('ACS_passive_taunt_9');
				thePlayer.AddTag('ACS_passive_taunt_10');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_10'))
			{
				thePlayer.PlayLine( 1136514, true);

				thePlayer.RemoveTag('ACS_passive_taunt_10');
				thePlayer.AddTag('ACS_passive_taunt_11');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_11'))
			{
				thePlayer.PlayLine( 1028773, true);

				thePlayer.RemoveTag('ACS_passive_taunt_11');
				thePlayer.AddTag('ACS_passive_taunt_12');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_12'))
			{
				thePlayer.PlayLine( 1028746, true);

				thePlayer.RemoveTag('ACS_passive_taunt_12');
				thePlayer.AddTag('ACS_passive_taunt_13');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_13'))
			{
				thePlayer.PlayLine( 520912, true);

				thePlayer.RemoveTag('ACS_passive_taunt_13');
				thePlayer.AddTag('ACS_passive_taunt_14');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_14'))
			{
				thePlayer.PlayLine( 522382, true);

				thePlayer.RemoveTag('ACS_passive_taunt_14');
				thePlayer.AddTag('ACS_passive_taunt_15');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_15'))
			{
				thePlayer.PlayLine( 522516, true);

				thePlayer.RemoveTag('ACS_passive_taunt_15');
				thePlayer.AddTag('ACS_passive_taunt_16');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_16'))
			{
				thePlayer.PlayLine( 578330, true);

				thePlayer.RemoveTag('ACS_passive_taunt_16');
				thePlayer.AddTag('ACS_passive_taunt_17');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_17'))
			{
				thePlayer.PlayLine( 578469, true);

				thePlayer.RemoveTag('ACS_passive_taunt_17');
				thePlayer.AddTag('ACS_passive_taunt_18');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_18'))
			{
				thePlayer.PlayLine( 578556, true);

				thePlayer.RemoveTag('ACS_passive_taunt_18');
				thePlayer.AddTag('ACS_passive_taunt_19');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_19'))
			{
				thePlayer.PlayLine( 578576, true);

				thePlayer.RemoveTag('ACS_passive_taunt_19');
				thePlayer.AddTag('ACS_passive_taunt_20');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_20'))
			{
				thePlayer.PlayLine( 578592, true);

				thePlayer.RemoveTag('ACS_passive_taunt_20');
				thePlayer.AddTag('ACS_passive_taunt_21');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_21'))
			{
				thePlayer.PlayLine( 578592, true);

				thePlayer.RemoveTag('ACS_passive_taunt_21');
				thePlayer.AddTag('ACS_passive_taunt_22');
			}
			else if 
			(
				thePlayer.HasTag('ACS_passive_taunt_begin') 
				&& thePlayer.HasTag('ACS_passive_taunt_22'))
			{
				thePlayer.PlayLine( 1016673, true);

				thePlayer.RemoveTag('ACS_passive_taunt_begin');
				thePlayer.RemoveTag('ACS_passive_taunt_1');
				thePlayer.RemoveTag('ACS_passive_taunt_2');
				thePlayer.RemoveTag('ACS_passive_taunt_3');
				thePlayer.RemoveTag('ACS_passive_taunt_4');
				thePlayer.RemoveTag('ACS_passive_taunt_5');
				thePlayer.RemoveTag('ACS_passive_taunt_6');
				thePlayer.RemoveTag('ACS_passive_taunt_7');
				thePlayer.RemoveTag('ACS_passive_taunt_8');
				thePlayer.RemoveTag('ACS_passive_taunt_9');
				thePlayer.RemoveTag('ACS_passive_taunt_10');
				thePlayer.RemoveTag('ACS_passive_taunt_11');
				thePlayer.RemoveTag('ACS_passive_taunt_12');
				thePlayer.RemoveTag('ACS_passive_taunt_13');
				thePlayer.RemoveTag('ACS_passive_taunt_14');
				thePlayer.RemoveTag('ACS_passive_taunt_15');
				thePlayer.RemoveTag('ACS_passive_taunt_16');
				thePlayer.RemoveTag('ACS_passive_taunt_17');
				thePlayer.RemoveTag('ACS_passive_taunt_18');
				thePlayer.RemoveTag('ACS_passive_taunt_19');
				thePlayer.RemoveTag('ACS_passive_taunt_20');
				thePlayer.RemoveTag('ACS_passive_taunt_21');
				thePlayer.RemoveTag('ACS_passive_taunt_22');
			}

		}
		else if ( thePlayer.IsInCombat() && ACS_Settings_Main_Bool('EHmodTauntSettings','EHmodCombatTauntEnabled', false) && RandF() < 0.5 )
		{
			thePlayer.RemoveTag('ACS_passive_taunt_begin');
			thePlayer.RemoveTag('ACS_passive_taunt_1');
			thePlayer.RemoveTag('ACS_passive_taunt_2');
			thePlayer.RemoveTag('ACS_passive_taunt_3');
			thePlayer.RemoveTag('ACS_passive_taunt_4');
			thePlayer.RemoveTag('ACS_passive_taunt_5');
			thePlayer.RemoveTag('ACS_passive_taunt_6');
			thePlayer.RemoveTag('ACS_passive_taunt_7');
			thePlayer.RemoveTag('ACS_passive_taunt_8');
			thePlayer.RemoveTag('ACS_passive_taunt_9');
			thePlayer.RemoveTag('ACS_passive_taunt_10');
			thePlayer.RemoveTag('ACS_passive_taunt_11');
			thePlayer.RemoveTag('ACS_passive_taunt_12');
			thePlayer.RemoveTag('ACS_passive_taunt_13');
			thePlayer.RemoveTag('ACS_passive_taunt_14');
			thePlayer.RemoveTag('ACS_passive_taunt_15');
			thePlayer.RemoveTag('ACS_passive_taunt_16');
			thePlayer.RemoveTag('ACS_passive_taunt_17');
			thePlayer.RemoveTag('ACS_passive_taunt_18');
			thePlayer.RemoveTag('ACS_passive_taunt_19');
			thePlayer.RemoveTag('ACS_passive_taunt_20');
			thePlayer.RemoveTag('ACS_passive_taunt_21');
			thePlayer.RemoveTag('ACS_passive_taunt_22');
			thePlayer.RemoveTag('ACS_EnoughOfThisShit_Player');

			if (
				!thePlayer.HasTag('ACS_taunt_begin') 
				&& !thePlayer.HasTag('ACS_taunt_1') 
				&& !thePlayer.HasTag('ACS_taunt_2')
				&& !thePlayer.HasTag('ACS_taunt_3')
				&& !thePlayer.HasTag('ACS_taunt_4')
				&& !thePlayer.HasTag('ACS_taunt_5')
				&& !thePlayer.HasTag('ACS_taunt_6')
				&& !thePlayer.HasTag('ACS_taunt_7')
				&& !thePlayer.HasTag('ACS_taunt_8')
				&& !thePlayer.HasTag('ACS_taunt_9')
				&& !thePlayer.HasTag('ACS_taunt_10')
				&& !thePlayer.HasTag('ACS_taunt_11')
				&& !thePlayer.HasTag('ACS_taunt_12')
			)
			{
				thePlayer.PlayLine( 1102138, true);

				thePlayer.AddTag('ACS_taunt_begin');
				thePlayer.AddTag('ACS_taunt_1');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_1'))
			{
				thePlayer.PlayLine( 1095093, true);

				thePlayer.RemoveTag('ACS_taunt_1');
				thePlayer.AddTag('ACS_taunt_2');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_2'))
			{
				thePlayer.PlayLine( 1113584, true);

				thePlayer.RemoveTag('ACS_taunt_2');
				thePlayer.AddTag('ACS_taunt_3');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_3'))
			{
				thePlayer.PlayLine( 1124758, true);

				thePlayer.RemoveTag('ACS_taunt_3');
				thePlayer.AddTag('ACS_taunt_4');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_4'))
			{
				thePlayer.PlayLine( 1172071, true);

				thePlayer.RemoveTag('ACS_taunt_4');
				thePlayer.AddTag('ACS_taunt_5');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_5'))
			{
				thePlayer.PlayLine( 1095180, true);

				thePlayer.RemoveTag('ACS_taunt_5');
				thePlayer.AddTag('ACS_taunt_6');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_6'))
			{
				thePlayer.PlayLine( 1113447, true);

				thePlayer.RemoveTag('ACS_taunt_6');
				thePlayer.AddTag('ACS_taunt_7');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_7'))
			{
				thePlayer.PlayLine( 1124760, true);

				thePlayer.RemoveTag('ACS_taunt_7');
				thePlayer.AddTag('ACS_taunt_8');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_8'))
			{
				thePlayer.PlayLine( 1124772, true);

				thePlayer.RemoveTag('ACS_taunt_8');
				thePlayer.AddTag('ACS_taunt_9');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_9'))
			{
				thePlayer.PlayLine( 1197007, true);

				thePlayer.RemoveTag('ACS_taunt_9');
				thePlayer.AddTag('ACS_taunt_10');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_10'))
			{
				thePlayer.PlayLine( 1124766, true);

				thePlayer.RemoveTag('ACS_taunt_10');
				thePlayer.AddTag('ACS_taunt_11');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_11'))
			{
				thePlayer.PlayLine( 1093530, true);

				thePlayer.RemoveTag('ACS_taunt_11');
				thePlayer.AddTag('ACS_taunt_12');
				thePlayer.AddTag('ACS_EnoughOfThisShit_Player');
			}
			else if 
			(
				thePlayer.HasTag('ACS_taunt_begin') 
				&& thePlayer.HasTag('ACS_taunt_12'))
			{
				thePlayer.PlayLine( 1124764, true);

				thePlayer.RemoveTag('ACS_taunt_begin');
				thePlayer.RemoveTag('ACS_taunt_1');
				thePlayer.RemoveTag('ACS_taunt_2');
				thePlayer.RemoveTag('ACS_taunt_3');
				thePlayer.RemoveTag('ACS_taunt_4');
				thePlayer.RemoveTag('ACS_taunt_5');
				thePlayer.RemoveTag('ACS_taunt_6');
				thePlayer.RemoveTag('ACS_taunt_7');
				thePlayer.RemoveTag('ACS_taunt_8');
				thePlayer.RemoveTag('ACS_taunt_9');
				thePlayer.RemoveTag('ACS_taunt_10');
				thePlayer.RemoveTag('ACS_taunt_11');
				thePlayer.RemoveTag('ACS_taunt_12');
			}
		}
	}

	latent function NPC_Taunt_EnemyBoost()
	{	
		var anim_names					: array< name >;

		actors.Clear();
		
		if (thePlayer.IsAlive())
		{
			Sleep(0.75);

			if (thePlayer.IsInCombat())
			{
				actors = thePlayer.GetNPCsAndPlayersInCone( 10, VecHeading(thePlayer.GetHeadingVector()), 90, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
			}
			else if (!thePlayer.IsInCombat())
			{
				actors = thePlayer.GetNPCsAndPlayersInCone( 5, VecHeading(thePlayer.GetHeadingVector()), 60, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
			}
		}
		else if (!thePlayer.IsAlive())
		{
			actors = thePlayer.GetNPCsAndPlayersInCone( 100, VecHeading(thePlayer.GetHeadingVector()), 360, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		}
		
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			npcactor = (CActor)actors[i];

			animatedComponentA = (CAnimatedComponent)npcactor.GetComponentByClassName( 'CAnimatedComponent' );	
			
			if ( npc == thePlayer || npc.HasTag('smokeman') )
				continue;
			
			if( actors.Size() > 0 )
			{	
				if( npc.IsAlive() 
				//&& npc.IsHuman()
				)
				{	
					if (thePlayer.IsInCombat() 
					&& ACS_Settings_Main_Bool('EHmodTauntSettings','EHmodCombatTauntEnabled', false) 
					&& ACS_AttitudeCheck ( npc )
					&& npc.IsHuman() )
					{
						if ( !thePlayer.HasBuff( EET_Thunderbolt ) )
						{
							thePlayer.AddEffectDefault( EET_Thunderbolt, thePlayer, 'console' );
						}
													
						if ( !thePlayer.HasBuff( EET_AbilityOnLowHealth ) )
						{
							thePlayer.AddEffectDefault( EET_AbilityOnLowHealth, thePlayer, 'console' );
						}

						if ( !thePlayer.HasBuff( EET_EnhancedWeapon ) )
						{
							thePlayer.AddEffectDefault( EET_EnhancedWeapon, thePlayer, 'console' );
						}
						
						if ( !thePlayer.HasBuff( EET_EnhancedArmor ) )
						{
							thePlayer.AddEffectDefault( EET_EnhancedArmor, thePlayer, 'console' );
						}

						if (thePlayer.IsAlive())
						{ 
							Sleep(RandRangeF(0.05,0.25));
						}
						else
						{
							Sleep(0.05);
						}

						tauntMovementAdjustor = ((CMovingPhysicalAgentComponent)npcactor.GetMovingAgentComponent()).GetMovementAdjustor();

						tauntMovementAdjustor.CancelAll();
							
						tauntTicket = tauntMovementAdjustor.CreateNewRequest( 'ACS_Taunt_Movement_Adjust' );

						tauntMovementAdjustor.AdjustmentDuration( tauntTicket, 0.5 );
						tauntMovementAdjustor.MaxRotationAdjustmentSpeed( tauntTicket, 50000 );
						tauntMovementAdjustor.MaxLocationAdjustmentSpeed( tauntTicket, 50000 );
						tauntMovementAdjustor.RotateTowards( tauntTicket, thePlayer );

						if (npcactor.IsMan())
						{
							anim_names.Clear();
							anim_names.PushBack('man_npc_sword_1hand_taunt_righttoleft');
							anim_names.PushBack('man_npc_sword_1hand_taunt_4_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_lefttoright');
							anim_names.PushBack('man_npc_sword_1hand_taunt_6_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_9_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_5_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_10_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_11_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_8_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_7_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_8_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_7_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_5_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_6_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_4_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_16_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_17_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_14_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_14_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_15_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_12_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_13_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_6_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_19_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_7_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_2_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_7_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_2_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_5_right');
							anim_names.PushBack('man_npc_sword_1hand_taunt_3_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_6_left');
							anim_names.PushBack('man_npc_sword_1hand_taunt_3_right');

							animatedComponentA.PlaySlotAnimationAsync ( anim_names[RandRange(anim_names.Size())] , 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 0.5f));
						}
						else if (npcactor.IsWoman())
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'high_standing_aggressive_gesture_pfff', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 0.5f));
						}

						targetPos = npc.GetWorldPosition();

						targetPos.Z += 0.75;

						targetRot = npc.GetWorldRotation();

						npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

						npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
							
						npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) ); 

						npcactor.RemoveBuffImmunity_AllNegative();

						npcactor.RemoveBuffImmunity_AllCritical();

						markerTemplate_2 = (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\quest\q604\604_11_cellar\ground_smoke_ent.w2ent", true );
	
						markerNPC_2 = (CEntity)theGame.CreateEntity( markerTemplate_2, targetPos, targetRot );

						markerNPC_2.CreateAttachment( npc );

						markerNPC_2.PlayEffect('ground_smoke');

						markerNPC_2.DestroyAfter(5);

						if (!npc.HasTag('ACS_taunted'))
						{
							markerTemplate_1 = (CEntityTemplate)LoadResourceAsync( 
							
							//"fx\characters\filippa\attack_02\filippa_arcane_circle.w2ent"

							//"fx\characters\filippa\philippa_hit_marker.w2ent"
							
							//"fx\quest\q403\meteorite\q403_marker.w2ent"

							"fx\gameplay\throwing\throwing_impact_marker.w2ent"

							, true );
	
							markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate_1, targetPos, targetRot );

							markerNPC_1.CreateAttachment( npc, 'head' );
							//markerNPC_1.PlayEffect('arcane_circle');
							//markerNPC_1.PlayEffect('explosion');

							markerNPC_1.PlayEffect('marker');

							markerNPC_1.AddTag('BerserkMark');

							npc.SetAnimationSpeedMultiplier(1+RandRangeF(0.05,0.25));
							
							npc.SetAnimationTimeMultiplier(1+RandRangeF(0.05,0.25));

							npc.SetLevel( npc.GetLevel() * 1 / 2 );
								
							npc.AddTag('ACS_taunted');
						}
					}
					else if ( !thePlayer.IsInCombat() && ACS_Settings_Main_Bool('EHmodTauntSettings','EHmodIWannaPlayGwentEnabled', false) )
					{
						if (thePlayer.IsAlive())
						{ 
							Sleep(0.5);
						}
						else
						{
							Sleep(0.25);
						}

						tauntMovementAdjustor = ((CMovingPhysicalAgentComponent)npcactor.GetMovingAgentComponent()).GetMovementAdjustor();

						tauntMovementAdjustor.CancelAll();
							
						tauntTicket = tauntMovementAdjustor.CreateNewRequest( 'ACS_Taunt_Movement_Adjust' );

						tauntMovementAdjustor.AdjustmentDuration( tauntTicket, 0.5 );
						tauntMovementAdjustor.MaxRotationAdjustmentSpeed( tauntTicket, 50000 );
						tauntMovementAdjustor.MaxLocationAdjustmentSpeed( tauntTicket, 50000 );
						tauntMovementAdjustor.RotateTowards( tauntTicket, thePlayer );

						if (!npcactor.IsHuman())
						{
							if (npcactor.IsMonster())
							{
								animatedComponentA.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
							}
							else if (npcactor.IsAnimal())
							{
								animatedComponentA.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
							}
							else
							{
								if (!npcactor.HasTag('ACS_EnoughOfThisShit'))
								{
									if (RandF() < 0.95)
									{
										animatedComponentA.PlaySlotAnimationAsync ( 'dwarf_work_standing_spitting_loop_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
									}
									else
									{
										if (RandF() < 0.5)
										{
											animatedComponentA.PlaySlotAnimationAsync ( 'dwarf_work_standing_sick_loop_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
										}
										else
										{
											animatedComponentA.PlaySlotAnimationAsync ( 'dwarf_work_standing_sick_loop_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
										}

										npcactor.AddTag('ACS_EnoughOfThisShit');
									}
								}
								else if (npcactor.HasTag('ACS_EnoughOfThisShit')
								|| thePlayer.HasTag('ACS_EnoughOfThisShit_Player'))
								{
									if (RandF() < 0.5)
									{
										animatedComponentA.PlaySlotAnimationAsync ( 'dwarf_work_standing_sick_loop_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
									}
									else
									{
										animatedComponentA.PlaySlotAnimationAsync ( 'dwarf_work_standing_sick_loop_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
									}

									npcactor.AddTag('ACS_EnoughOfThisShit');
									thePlayer.RemoveTag('ACS_EnoughOfThisShit_Player');
								}
							}
						}
						else if (npcactor.IsHuman())
						{
							npcactor.PlayMimicAnimationAsync('geralt_neutral_gesture_you_kiddin_face');
							
							if (npcactor.IsMan())
							{
								if (!npcactor.HasTag('ACS_EnoughOfThisShit'))
								{
									if (RandF() < 0.95)
									{
										animatedComponentA.PlaySlotAnimationAsync ( 'high_standing_sad_gesture_go_plough_yourself', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
									}
									else
									{
										animatedComponentA.PlaySlotAnimationAsync ( 'man_kneeling_on_floor_in_pain_loop_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
										npcactor.AddTag('ACS_EnoughOfThisShit');
									}
								}
								else if (npcactor.HasTag('ACS_EnoughOfThisShit')
								|| thePlayer.HasTag('ACS_EnoughOfThisShit_Player'))
								{
									animatedComponentA.PlaySlotAnimationAsync ( 'man_kneeling_on_floor_in_pain_loop_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
									npcactor.AddTag('ACS_EnoughOfThisShit');
									thePlayer.RemoveTag('ACS_EnoughOfThisShit_Player');
								}
							}
							else if (npcactor.IsWoman())
							{
								if (!npcactor.HasTag('ACS_EnoughOfThisShit'))
								{
									if (RandF() < 0.95)
									{
										animatedComponentA.PlaySlotAnimationAsync ( 'high_standing_aggressive_gesture_pfff', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
									}
									else
									{
										animatedComponentA.PlaySlotAnimationAsync ( 'low_kneeling_devastated_idle', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
										npcactor.AddTag('ACS_EnoughOfThisShit');
									}
								}
								else if (npcactor.HasTag('ACS_EnoughOfThisShit')
								|| thePlayer.HasTag('ACS_EnoughOfThisShit_Player'))
								{
									animatedComponentA.PlaySlotAnimationAsync ( 'low_kneeling_devastated_idle', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.9f, 0.9f));
									npcactor.AddTag('ACS_EnoughOfThisShit');
									thePlayer.RemoveTag('ACS_EnoughOfThisShit_Player');
								}			
							}
						}	
					}
				}
			}
		}
	}
	
	latent function claw_taunt() 
	{
		var vamp_sound_names																											: array< string >;
		
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if (!ACS_Settings_Main_Bool('EHmodTauntSettings','EHmodTauntSystemEnabled', false))
		{
			vamp_sound_names.Clear();
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_taunt_claws");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_effort_big_short");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_roar");
			vamp_sound_names.PushBack("monster_dettlaff_monster_voice_heavy_charge");

			thePlayer.SoundEvent(vamp_sound_names[RandRange(vamp_sound_names.Size())]);
		}

		if ( thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() )
			actor = (CActor)( thePlayer.GetTarget() );	
		else
		{
			thePlayer.FindMoveTarget();
			actor = (CActor)( thePlayer.moveTarget );		
		}
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'claw_taunt');
		
		movementAdjustor.CancelByName( 'claw_taunt' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'claw_taunt' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{
			if (!thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()) {movementAdjustor.RotateTowards( ticket, actor );}  
		}

		watcher.claw_taunt_index = RandDifferent(watcher.previous_claw_taunt_index , 2);

		switch (watcher.claw_taunt_index) 
		{		
			case 1:
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_taunt_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
			break;	
					
			default:
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_taunt_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
			break;	
		}

		watcher.previous_claw_taunt_index = watcher.claw_taunt_index;
	}
	
	
	latent function olgierd_combat_taunt ()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if ( thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() )
			actor = (CActor)( thePlayer.GetTarget() );	
		else
		{
			thePlayer.FindMoveTarget();
			actor = (CActor)( thePlayer.moveTarget );		
		}
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'normal_combat_taunt');
		
		movementAdjustor.CancelByName( 'normal_combat_taunt' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'normal_combat_taunt' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (!thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()) {movementAdjustor.RotateTowards( ticket, actor );}  
			
			watcher.olgierd_combat_taunt_index_1 = RandDifferent(watcher.previous_olgierd_combat_taunt_index_1 , 16);

			switch (watcher.olgierd_combat_taunt_index_1) 
			{							
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_down_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_down_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_005_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;			
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_intro_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
			}

			watcher.previous_olgierd_combat_taunt_index_1 = watcher.olgierd_combat_taunt_index_1;
		}
		else
		{
			watcher.olgierd_combat_taunt_index_2 = RandDifferent(watcher.previous_olgierd_combat_taunt_index_2 , 16);

			switch (watcher.olgierd_combat_taunt_index_2) 
			{						
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_down_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_down_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_005_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_004_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;			
					
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_003_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_002_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_intro_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
			}

			watcher.previous_olgierd_combat_taunt_index_2 = watcher.olgierd_combat_taunt_index_2;
		}
	}
	
	latent function eredin_combat_taunt ()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if ( thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() )
			actor = (CActor)( thePlayer.GetTarget() );	
		else
		{
			thePlayer.FindMoveTarget();
			actor = (CActor)( thePlayer.moveTarget );		
		}
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'normal_combat_taunt');
		
		movementAdjustor.CancelByName( 'normal_combat_taunt' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'normal_combat_taunt' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (!thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()) {movementAdjustor.RotateTowards( ticket, actor );}  
			
			watcher.eredin_combat_taunt_index_1 = RandDifferent(watcher.previous_eredin_combat_taunt_index_1 , 22);

			switch (watcher.eredin_combat_taunt_index_1) 
			{	
				case 21:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_righttoleft_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 20:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_lefttoright_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;

				case 19:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_9_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 18:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_8_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 17:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_8_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;

				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_5_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_4_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_6_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_5_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_7_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_7_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_6_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_taunt_2_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_taunt_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_05_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_04_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_03_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;			
						
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_02_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_01_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
			}

			watcher.previous_eredin_combat_taunt_index_1 = watcher.eredin_combat_taunt_index_1;
		}
		else
		{
			watcher.eredin_combat_taunt_index_2 = RandDifferent(watcher.previous_eredin_combat_taunt_index_2 , 22);

			switch (watcher.eredin_combat_taunt_index_2) 
			{	
				case 21:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_righttoleft_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 20:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_lefttoright_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;

				case 19:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_9_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 18:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_8_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 17:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_8_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;

				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_5_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_4_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_6_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_5_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_7_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_7_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_6_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_taunt_2_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_taunt_1_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_05_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;

				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_04_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_03_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;			
						
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_02_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_taunt_01_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
			}

			watcher.previous_eredin_combat_taunt_index_2 = watcher.eredin_combat_taunt_index_2;
		}
	}
	
	latent function imlerith_combat_taunt ()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if ( thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() )
			actor = (CActor)( thePlayer.GetTarget() );	
		else
		{
			thePlayer.FindMoveTarget();
			actor = (CActor)( thePlayer.moveTarget );		
		}
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'normal_combat_taunt');
		
		movementAdjustor.CancelByName( 'normal_combat_taunt' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'normal_combat_taunt' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (!thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()) {movementAdjustor.RotateTowards( ticket, actor );}  
			
			watcher.imlerith_combat_taunt_index_1 = RandDifferent(watcher.previous_imlerith_combat_taunt_index_1 , 14);

			switch (watcher.imlerith_combat_taunt_index_1) 
			{										
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_03_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_02_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_01_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_04_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
			}

			watcher.previous_imlerith_combat_taunt_index_1 = watcher.imlerith_combat_taunt_index_1;
		}
		else
		{
			watcher.imlerith_combat_taunt_index_2 = RandDifferent(watcher.previous_imlerith_combat_taunt_index_2 , 14);

			switch (watcher.imlerith_combat_taunt_index_2) 
			{										
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_03_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_02_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_02_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_01_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2haxe_taunt_01_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
				
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_shield_taunt_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_04_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_2hhalberd_taunt_03_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
			}

			watcher.previous_imlerith_combat_taunt_index_2 = watcher.imlerith_combat_taunt_index_2;
		}
	}
	
	latent function normal_combat_taunt ()
	{
		if (!thePlayer.HasTag('ACS_Special_Dodge'))
		{
			thePlayer.AddTag('ACS_Special_Dodge');
		}
		
		if ( thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() )
			actor = (CActor)( thePlayer.GetTarget() );	
		else
		{
			thePlayer.FindMoveTarget();
			actor = (CActor)( thePlayer.moveTarget );		
		}
		
		movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'normal_combat_taunt');
		
		movementAdjustor.CancelByName( 'normal_combat_taunt' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'normal_combat_taunt' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && thePlayer.IsInCombat() && actor.IsAlive() )
		{	
			if (!thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()) {movementAdjustor.RotateTowards( ticket, actor );}  
			
			watcher.normal_combat_taunt_index_1 = RandDifferent(watcher.previous_normal_combat_taunt_index_1 , 17);

			switch (watcher.normal_combat_taunt_index_1) 
			{										
				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_4_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_3_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_3_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_2_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_2_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_19_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_18_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_17_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_16_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_15_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_14_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_13_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_12_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;			
						
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_11_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_10_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_1_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_1_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;		
			}

			watcher.previous_normal_combat_taunt_index_1 == watcher.normal_combat_taunt_index_1;
		}
		else
		{
			watcher.normal_combat_taunt_index_2 = RandDifferent(watcher.previous_normal_combat_taunt_index_2 , 17);

			switch (watcher.normal_combat_taunt_index_2) 
			{										
				case 16:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_4_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 15:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_3_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 14:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_3_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 13:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_2_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 12:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_2_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
						
				case 11:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_19_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;
					
				case 10:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_18_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 9:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_17_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 8:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_16_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
					
				case 7:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_15_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 6:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_14_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 5:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_13_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	

				case 4:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_12_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;			
						
				case 3:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_11_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 2:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_10_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				case 1:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_1_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;	
						
				default:
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_taunt_1_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.75f));
				break;		
			}

			watcher.previous_normal_combat_taunt_index_2 == watcher.normal_combat_taunt_index_2;
		}
	}
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}