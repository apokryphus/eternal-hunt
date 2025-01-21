/*
function ACS_Dodge()
{
	//var vACS_Dodge : cACS_Dodge;
	//vACS_Dodge = new cACS_Dodge in theGame;
	
	if ( ACS_Enabled())
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('acs_in_wraith')
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
		)
		{	
			//vACS_Dodge.ACS_Dodge_Engage();

			if( ACS_Armor_Equipped_Check()
			|| ACS_Wolf_School_Check()
			|| ACS_Bear_School_Check()
			|| ACS_Cat_School_Check()
			|| ACS_Griffin_School_Check()
			|| ACS_Manticore_School_Check()
			|| ACS_Forgotten_Wolf_Check()
			|| ACS_Viper_School_Check()
			)
			{
				return;
			}

			if (ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaCostAction', false))
			{
				thePlayer.DrainStamina( ESAT_FixedValue,  thePlayer.GetStatMax( BCS_Stamina ) * ACS_Settings_Main_Float('EHmodStaminaSettings','EHmodDodgeStaminaCost', 0.05), ACS_Settings_Main_Float('EHmodStaminaSettings','EHmodDodgeStaminaRegenDelay', 1) );
			}
		}
	}
}

statemachine class cACS_Dodge
{
    function ACS_Dodge_Engage()
	{
		this.PushState('ACS_Dodge_Engage');
	}
}

state ACS_Dodge_Engage in cACS_Dodge
{
	private var teleport_fx								: CEntity;
	private var i 										: int;
    private var npc     								: CNewNPC;
	private var actor       							: CActor;
	private var actors 									: array< CActor >;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		
		Dodge();
	}
	
	entry function Dodge()
	{
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
			GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

			GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
			GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
		
		//Dodge_Effects();

		if ((thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG')
		|| thePlayer.HasTag('acs_igni_sword_equipped')
		|| thePlayer.HasTag('acs_igni_sword_equipped_TAG'))
		&& !thePlayer.HasTag('acs_quen_sword_equipped')
		&& !thePlayer.HasTag('acs_axii_sword_equipped')
		&& !thePlayer.HasTag('acs_aard_sword_equipped')
		&& !thePlayer.HasTag('acs_yrden_sword_equipped')
		&& !thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		&& !thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		&& !thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		&& !thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			DodgeStaminaDrain();
		}
	}

	latent function DodgeStaminaDrain()
	{
		if( ACS_Armor_Equipped_Check()
		|| ACS_Wolf_School_Check()
		|| ACS_Bear_School_Check()
		|| ACS_Cat_School_Check()
		|| ACS_Griffin_School_Check()
		|| ACS_Manticore_School_Check()
		|| ACS_Forgotten_Wolf_Check()
		|| ACS_Viper_School_Check()
		)
		{
			return;
		}

		if (ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaCostAction', false))
		{
			thePlayer.DrainStamina( ESAT_FixedValue,  thePlayer.GetStatMax( BCS_Stamina ) * ACS_Settings_Main_Float('EHmodStaminaSettings','EHmodDodgeStaminaCost', 0.05), ACS_Settings_Main_Float('EHmodStaminaSettings','EHmodDodgeStaminaRegenDelay', 1) );
		}
	}
	
	
	latent function Dodge_Effects()
	{
		if ( ACS_GetWeaponMode() == 0 )
		{	
			if (GetWitcherPlayer().IsAnyWeaponHeld())
			{
				if (!GetWitcherPlayer().IsWeaponHeld( 'fist' ))
				{
					if (GetWitcherPlayer().GetEquippedSign() == ST_Igni )
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
						{
							FireDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
						{
							IceDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
						{
							BloodDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
						{
							ParalyzeDodge();
						}
					}
					else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii )
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
						{
							FireDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
						{
							IceDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
						{
							BloodDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
						{
							ParalyzeDodge();
						}
					}
					else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard )
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
						{
							FireDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
						{
							IceDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
						{
							BloodDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
						{
							ParalyzeDodge();
						}
					}
					else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
						{
							FireDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
						{
							IceDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
						{
							BloodDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
						{
							ParalyzeDodge();
						}
					}
					else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen )
					{
						if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
						{
							FireDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
						{
							ShadowDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
						{
							IceDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
						{
							BloodDodge();
						}
						else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
						{
							ParalyzeDodge();
						}
					}
				}
				else if ( GetWitcherPlayer().IsWeaponHeld( 'fist' ) && GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') )
				{
					BloodDodge();
				}
			}
		}
		else if ( ACS_GetWeaponMode() == 1 )
		{
			if ( 
			ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_quen_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_quen_sword_equipped') 
			)
			{
				ShadowDodge();
			}
			else if ( 
			ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_aard_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_aard_sword_equipped') 
			)
			{
				BloodDodge();
			}
			else if ( 
			ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_axii_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_axii_sword_equipped')
			)
			{
				IceDodge();	
			}
			else if ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') 
			)
			{
				ParalyzeDodge();	
			}	
			else if ( 
			ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_igni_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
			)
			{
				FireDodge();	
			}
			else if ( 
			ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') 
			)
			{
				ParalyzeDodge();	
			}
			else if ( 
			ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') 
			)
			{
				IceDodge();	
			}
			else if ( 
			ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') 
			)
			{
				ParalyzeDodge();	
			}
			else if ( 
			ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8  && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') 
			|| ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') 
			)
			{
				FireDodge();	
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'fist' ) && GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') )
			{
				BloodDodge();	
			}
		}
		else if ( ACS_GetWeaponMode() == 3 )
		{
			if ( 
			ACS_GetItem_Olgierd_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_quen_sword_equipped') 
			|| ACS_GetItem_Olgierd_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_quen_sword_equipped')
			)
			{
				ShadowDodge();
			}
			else if ( 
			ACS_GetItem_Claws_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_aard_sword_equipped') 
			|| ACS_GetItem_Claws_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
			)
			{
				BloodDodge();
			}
			else if ( 
			ACS_GetItem_Eredin_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_axii_sword_equipped') 
			|| ACS_GetItem_Eredin_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_axii_sword_equipped')
			)
			{
				IceDodge();	
			}
			else if ( 
			ACS_GetItem_Imlerith_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_yrden_sword_equipped') 
			|| ACS_GetItem_Imlerith_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
			)
			{
				ParalyzeDodge();	
			}	
			else if ( 
			ACS_GetItem_Spear_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') 
			|| ACS_GetItem_Spear_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
			)
			{
				ShadowDodge();	
			}
			else if ( 
			ACS_GetItem_Greg_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') 
			|| ACS_GetItem_Greg_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
			)
			{
				IceDodge();	
			}
			else if ( 
			ACS_GetItem_Hammer_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped') 
			|| ACS_GetItem_Hammer_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
			)
			{
				ParalyzeDodge();	
			}
			else if ( 
			ACS_GetItem_Axe_Silver() && GetWitcherPlayer().IsWeaponHeld( 'silversword' ) && GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') 
			|| ACS_GetItem_Axe_Steel() && GetWitcherPlayer().IsWeaponHeld( 'steelsword' ) && GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
			)
			{
				ParalyzeDodge();	
			}
			else if ( GetWitcherPlayer().IsWeaponHeld( 'fist' ) && GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') )
			{
				BloodDodge();	
			}
		}
	}

	latent function FireDodge()
	{
		if (GetWitcherPlayer().GetEquippedSign() == ST_Igni )
		{
			GetWitcherPlayer().PlayEffectSingle('fire_hit');
			GetWitcherPlayer().StopEffect('fire_hit');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );
			teleport_fx.PlayEffectSingle('disappear');
			GetWitcherPlayer().SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard )
		{
			GetWitcherPlayer().PlayEffectSingle('trap_attack_smoke');
			GetWitcherPlayer().StopEffect('trap_attack_smoke');
							
			GetWitcherPlayer().PlayEffectSingle('move_trail');
			GetWitcherPlayer().StopEffect('move_trail');
							
			GetWitcherPlayer().PlayEffectSingle('roll_dettlaff_flesh');
			GetWitcherPlayer().StopEffect('roll_dettlaff_flesh');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
		{
			GetWitcherPlayer().PlayEffectSingle('special_attack_steps');
			GetWitcherPlayer().StopEffect('special_attack_steps');
							
			GetWitcherPlayer().PlayEffectSingle('yrden_shock');
			GetWitcherPlayer().StopEffect('yrden_shock');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen )
		{
			GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
			GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );
							
			GetWitcherPlayer().PlayEffectSingle('hit_electric');
			GetWitcherPlayer().StopEffect('hit_electric');
		}
		
						
		//GetWitcherPlayer().PlayEffectSingle('fire_blowing');
		//GetWitcherPlayer().StopEffect('fire_blowing');
						
		//GetWitcherPlayer().PlayEffectSingle('fire_blowing_2');
		//GetWitcherPlayer().StopEffect('fire_blowing_2');
						
		if( RandF() < 0.1 ) 
		{
			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
					{
						if( !npc.HasBuff( EET_Burning ) )
						{
							npc.AddEffectDefault( EET_Burning, npc, 'acs_dodge_buffs' );
						}										
					}
				}		
			}
		}
	}

	latent function IceDodge()
	{
		if (GetWitcherPlayer().GetEquippedSign() == ST_Igni )
		{
			GetWitcherPlayer().PlayEffectSingle('fire_hit');
			GetWitcherPlayer().StopEffect('fire_hit');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );
			teleport_fx.PlayEffectSingle('disappear');
			GetWitcherPlayer().SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard )
		{
			GetWitcherPlayer().PlayEffectSingle('trap_attack_smoke');
			GetWitcherPlayer().StopEffect('trap_attack_smoke');
							
			GetWitcherPlayer().PlayEffectSingle('move_trail');
			GetWitcherPlayer().StopEffect('move_trail');
							
			GetWitcherPlayer().PlayEffectSingle('roll_dettlaff_flesh');
			GetWitcherPlayer().StopEffect('roll_dettlaff_flesh');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
		{
			GetWitcherPlayer().PlayEffectSingle('special_attack_steps');
			GetWitcherPlayer().StopEffect('special_attack_steps');
							
			GetWitcherPlayer().PlayEffectSingle('yrden_shock');
			GetWitcherPlayer().StopEffect('yrden_shock');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen )
		{
			GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
			GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );
							
			GetWitcherPlayer().PlayEffectSingle('hit_electric');
			GetWitcherPlayer().StopEffect('hit_electric');
		}
						
		if( RandF() < 0.1 ) 
		{
			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
					{
						if( !npc.HasBuff( EET_SlowdownFrost ) )
						{
							npc.AddEffectDefault( EET_SlowdownFrost, npc, 'acs_dodge_buffs' );
						}										
					}
				}		
			}
		}
	}

	latent function BloodDodge()
	{
		if (GetWitcherPlayer().GetEquippedSign() == ST_Igni )
		{
			GetWitcherPlayer().PlayEffectSingle('fire_hit');
			GetWitcherPlayer().StopEffect('fire_hit');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );
			teleport_fx.PlayEffectSingle('disappear');
			GetWitcherPlayer().SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard )
		{
			GetWitcherPlayer().PlayEffectSingle('trap_attack_smoke');
			GetWitcherPlayer().StopEffect('trap_attack_smoke');
							
			GetWitcherPlayer().PlayEffectSingle('move_trail');
			GetWitcherPlayer().StopEffect('move_trail');
							
			GetWitcherPlayer().PlayEffectSingle('roll_dettlaff_flesh');
			GetWitcherPlayer().StopEffect('roll_dettlaff_flesh');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
		{
			GetWitcherPlayer().PlayEffectSingle('special_attack_steps');
			GetWitcherPlayer().StopEffect('special_attack_steps');
							
			GetWitcherPlayer().PlayEffectSingle('yrden_shock');
			GetWitcherPlayer().StopEffect('yrden_shock');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen )
		{
			GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
			GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );
							
			GetWitcherPlayer().PlayEffectSingle('hit_electric');
			GetWitcherPlayer().StopEffect('hit_electric');
		}

		if( RandF() < 0.1 ) 
		{
			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
					{										
						if( !npc.HasBuff( EET_Bleeding ) )
						{
							npc.AddEffectDefault( EET_Bleeding, npc, 'acs_dodge_buffs' );	
						}
					}
				}		
			}
		}
	}

	latent function ParalyzeDodge()
	{
		if (GetWitcherPlayer().GetEquippedSign() == ST_Igni )
		{
			GetWitcherPlayer().PlayEffectSingle('fire_hit');
			GetWitcherPlayer().StopEffect('fire_hit');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );
			teleport_fx.PlayEffectSingle('disappear');
			GetWitcherPlayer().SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard )
		{
			GetWitcherPlayer().PlayEffectSingle('trap_attack_smoke');
			GetWitcherPlayer().StopEffect('trap_attack_smoke');
							
			GetWitcherPlayer().PlayEffectSingle('move_trail');
			GetWitcherPlayer().StopEffect('move_trail');
							
			GetWitcherPlayer().PlayEffectSingle('roll_dettlaff_flesh');
			GetWitcherPlayer().StopEffect('roll_dettlaff_flesh');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
		{
			GetWitcherPlayer().PlayEffectSingle('special_attack_steps');
			GetWitcherPlayer().StopEffect('special_attack_steps');
							
			GetWitcherPlayer().PlayEffectSingle('yrden_shock');
			GetWitcherPlayer().StopEffect('yrden_shock');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen )
		{
			GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
			GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );
							
			GetWitcherPlayer().PlayEffectSingle('hit_electric');
			GetWitcherPlayer().StopEffect('hit_electric');
		}
						
		if( RandF() < 0.1 ) 
		{
			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
					{
						if( !npc.HasBuff( EET_Paralyzed ) )
						{
							npc.AddEffectDefault( EET_Paralyzed, npc, 'acs_dodge_buffs' );	
						}
					}
									
					if ( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
					{
						if( !npc.HasBuff( EET_Slowdown ) )
						{
							npc.AddEffectDefault( EET_Slowdown, npc, 'acs_dodge_buffs' );	
						}
					}
				}		
			}
		}
	}

	latent function ShadowDodge()
	{
		if (GetWitcherPlayer().GetEquippedSign() == ST_Igni )
		{
			GetWitcherPlayer().PlayEffectSingle('fire_hit');
			GetWitcherPlayer().StopEffect('fire_hit');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii )
		{
			teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );
			teleport_fx.PlayEffectSingle('disappear');
			GetWitcherPlayer().SoundEvent("magic_canaris_teleport_short");
			teleport_fx.DestroyAfter(1.5);
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard )
		{
			GetWitcherPlayer().PlayEffectSingle('trap_attack_smoke');
			GetWitcherPlayer().StopEffect('trap_attack_smoke');
							
			GetWitcherPlayer().PlayEffectSingle('move_trail');
			GetWitcherPlayer().StopEffect('move_trail');
							
			GetWitcherPlayer().PlayEffectSingle('roll_dettlaff_flesh');
			GetWitcherPlayer().StopEffect('roll_dettlaff_flesh');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
		{
			GetWitcherPlayer().PlayEffectSingle('special_attack_steps');
			GetWitcherPlayer().StopEffect('special_attack_steps');
							
			GetWitcherPlayer().PlayEffectSingle('yrden_shock');
			GetWitcherPlayer().StopEffect('yrden_shock');
		}
		else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen )
		{
			GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
			GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );
							
			GetWitcherPlayer().PlayEffectSingle('hit_electric');
			GetWitcherPlayer().StopEffect('hit_electric');
		}
						
		if( RandF() < 0.1 ) 
		{
			actors.Clear();
			
			actors = GetActorsInRange(GetWitcherPlayer(), 2, 20);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
								
				if( actors.Size() > 0 )
				{
					if ( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
					{											
						if( !npc.HasBuff( EET_Confusion ) )
						{
							npc.AddEffectDefault( EET_Confusion, npc, 'acs_dodge_buffs' );	
						}
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
*/