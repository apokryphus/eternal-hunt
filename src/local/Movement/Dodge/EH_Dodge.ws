statemachine class cBruxaDodgeSlideBack
{
    function BruxaDodgeSlideBack_Engage()
	{
		this.PushState('BruxaDodgeSlideBack_Engage');
	}
}

state BruxaDodgeSlideBack_Engage in cBruxaDodgeSlideBack
{
	private var pActor, actor 									: CActor;
	private var movementAdjustor								: CMovementAdjustor;
	private var ticket 											: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance							: float;
	private var actors, targetActors    						: array<CActor>;
	private var i         										: int;
	private var npc, targetNpc     								: CNewNPC;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		BruxaDodgeSlideBack();
	}
	
	entry function BruxaDodgeSlideBack()
	{	
		if (ACSGetCEntity('ACS_Aim_Impact_Entity'))
		{
			ACSGetCEntity('ACS_Aim_Impact_Entity').Destroy();
		}

		if ( ACS_Settings_Main_Bool('acs_stamina_settings','acs_stamina_block_action', false) 
		&& GetACSWatcher().StaminaCheck('default')
		)
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");

			return;
		}

		if (((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_hard'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_soil'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'hay'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'stone_debris'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'clay_tile'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_large'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_small'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'sand'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_short'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_long'
		)
		{
			//thePlayer.StopEffect('covered_dirt_ACS');
			//thePlayer.PlayEffect('covered_dirt_ACS');

			if( GetRainStrength() > 0 
			&& !thePlayer.IsInInterior()
			&& !GetACSWatcher().RoofCheck()
			) 
			{

			}
			else if (ACS_Settings_Main_Bool('acs_player_misc_settings','acs_dirt_vfx_enabled', true))
			{
				switch(GetACSWatcher().dirt_counter)
				{
					case 5:
						thePlayer.StopEffect('covered_dirt_small_ACS');
						thePlayer.PlayEffect('covered_dirt_small_ACS');
						
						GetACSWatcher().ManageDirtCounter(false);
					break;

					case 4:

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 3:

						thePlayer.StopEffect('covered_dirt_big_ACS');
						thePlayer.PlayEffect('covered_dirt_big_ACS');

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 2:

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 1:

						GetACSWatcher().ManageDirtCounter(true);
						
					break;

					default:
						GetACSWatcher().ManageDirtCounter(true);

					break;
				}
			}
		}
		
		if (ACSGetCActor('ACS_Enemy_Attacking_From_Behind')
		&& ACS_Settings_Main_Float('acs_dodge_settings','acs_flip_dodge_cooldown', 4) > 0
		)
		{
			GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
			
			thePlayer.PlayEffectSingle('acs_fast_sprint_trail');
			thePlayer.StopEffect('acs_fast_sprint_trail');

			thePlayer.RaiseEvent('ACS_FrontTwistFlip');

			if (RandF() < 0.5)
			{
				thePlayer.RaiseEvent( 'ACS_CastAardLocomotion' );
			}
			else
			{
				thePlayer.RaiseEvent( 'ACS_CastIgniLocomotion' );
			}

			ACSGetCActorRemoveTag('ACS_Enemy_Attacking_From_Behind');
		}

		thePlayer.SetSprintActionPressed( false );
		thePlayer.SetSprintToggle( false );

		if (ACS_Settings_Main_Bool('acs_movement_main_settings','acs_walking_by_default_enabled', true))
		{
			thePlayer.SetWalkToggle( true );	
		}

		if(ACSGetCEntity('ACS_Viper_Dagger_L'))
		{
			thePlayer.RaiseEvent('ACS_LHandAttack01');
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

		GetWitcherPlayer().StopEffect('dive_shape');
		GetWitcherPlayer().RemoveTag('ACS_Bruxa_Jump_End');

		if (GetWitcherPlayer().HasTag('ACS_Vampire_Claws_Roll') && ACSGetCEntity('ACS_Vampire_Roll_FX'))
		{
			ACSGetCEntity('ACS_Vampire_Roll_FX').Destroy();

			thePlayer.SoundEvent("monster_dettlaff_monster_combat_construct_dash_vfx");

			thePlayer.DestroyEffect('avatar_death_swollen_no_decal_construct');

			thePlayer.DestroyEffect('shadowdash_body_blood_construct');

			thePlayer.DestroyEffect('shadowdash_ground_blood_construct');

			thePlayer.PlayEffect('avatar_death_swollen_no_decal_construct');
			thePlayer.StopEffect('avatar_death_swollen_no_decal_construct');

			thePlayer.PlayEffect('shadowdash_body_blood_construct');
			thePlayer.StopEffect('shadowdash_body_blood_construct');

			thePlayer.PlayEffect('shadowdash_ground_blood_construct');
			thePlayer.StopEffect('shadowdash_ground_blood_construct');

			thePlayer.SetVisibility(true);

			thePlayer.SetCanPlayHitAnim(true); 

			thePlayer.EnableCharacterCollisions(true); 

			GetWitcherPlayer().RemoveTag('ACS_Vampire_Claws_Roll');
		}

		if (RandF() < 0.25)
		{
			if (thePlayer.IsAnyWeaponHeld() 
			&& !thePlayer.IsWeaponHeld('fist')
			&& !thePlayer.HasTag('acs_vampire_claws_equipped')
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
				GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
				 
				 
				GetACSWatcher().RemoveTimer('CombatTauntDelay');GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
				GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondaryWeaponBlood'); 
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 , false ); 

				if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
				{
					GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 , false ); 

					thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
				}
			}
		}

		thePlayer.SetSprintActionPressed( false );
		thePlayer.SetSprintToggle( false );
		
		if (ACS_Settings_Main_Bool('acs_movement_main_settings','acs_walking_by_default_enabled', true))
		{
			thePlayer.SetWalkToggle( true );	
		}

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	

		ACS_ThingsThatShouldBeRemoved();

		ACS_ExplorationDelayHack(false, 3);

		thePlayer.ACS_DealPlayerPostureDamage(2.5, false);

		GetWitcherPlayer().ResetUninterruptedHitsCount();

		//GetWitcherPlayer().SendAttackReactionEvent();

		ACSGetCActorDestroyAll('ACS_Geralt_Phantom');

		if ( thePlayer.IsCrossbowHeld() ) 
		{
			thePlayer.OnRangedForceHolster( false, true );
		}

		GetWitcherPlayer().RaiseEvent( 'Dodge' );

		if (ACSGetCEntity('ACS_Bruxa_Camo_Trail'))
		{
			ACSGetCEntity('ACS_Bruxa_Camo_Trail').StopEffect('smoke');
			ACSGetCEntity('ACS_Bruxa_Camo_Trail').PlayEffectSingle('smoke');
		}

		if (ACS_Armor_Set_Check('acs_armor', false))
		{
			thePlayer.SoundEvent( "monster_caretaker_mv_cloth_hard" );

			thePlayer.SoundEvent( "monster_caretaker_mv_footstep" );
		}

		if ( !theSound.SoundIsBankLoaded("monster_dettlaff_monster.bnk") )
		{
			theSound.SoundLoadBank( "monster_dettlaff_monster.bnk", false );
		}

		if (GetACSWatcher().combatExtraActive)
		{
			GetACSWatcher().RemoveTimer('combatExtraReset');
			
			thePlayer.RaiseEvent('ACS_CombatExtraReset');
		
			GetACSWatcher().SetCombatExtraStatus(false);
		}

		if (
		FactsQuerySum("ACS_Slayer_Active") > 0
		|| FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			wolf_school_dodges();
		}
		else
		{
			if (
			GetWitcherPlayer().HasTag('acs_vampire_claws_equipped')
			|| GetWitcherPlayer().HasTag('acs_sorc_fists_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			{
				vampire_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
			)
			{
				aard_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
			)
			{
				yrden_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
			)
			{
				yrden_secondary_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
			)
			{
				axii_secondary_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_axii_sword_equipped')
			)
			{
				axii_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
			)
			{
				quen_secondary_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
			)
			{
				aard_secondary_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_quen_sword_equipped')
			)
			{
				quen_sword_dodges();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_igni_sword_equipped') 
			|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
			)
			{
				ignii_sword_dodges();
			}
			else
			{
				if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  
				&& ( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
				|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
				|| ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				|| thePlayer.HasTag('acs_vampire_claws_equipped')
				|| ACS_Vampire_Claws_Access()
				)
				&& ACS_can_special_dodge())
				{
					ACS_refresh_special_dodge_cooldown();

					WeaponRespawn();

					if (thePlayer.IsAnyWeaponHeld()
					&& !thePlayer.IsWeaponHeld('fist')
					)
					{
						if (RandF() < 0.5)
						{
							bruxa_slide_back();	
						}
						else
						{
							olgierd_slide_back_2();
						}
					}
					else
					{
						bruxa_slide_back();	
					}

					GetACSWatcher().ACS_StaminaDrain(4);
				}
				else
				{
					WeaponRespawn();

					GetACSWatcher().dodge_timer_attack_actual();

					if (ACS_DefaultGeraltMovesetOverrideModeDodge_Enabled())
					{
						if ((thePlayer.IsWeaponHeld('fist') 
						|| !thePlayer.IsAnyWeaponHeld())
						&& !GetACSWatcher().ACS_IS_SNEAKING 
						&& !thePlayer.HasTag('ACS_Is_Sneaking')
						)
						{
							geralt_moveset_fist_dodge_override_mode();
						}
						else
						{
							geralt_moveset_dodge_override_mode();
						}
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

						Sleep(0.0625);

						GetWitcherPlayer().EvadePressed(EBAT_Dodge);

						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
			}
		}


	}

	latent function WeaponRespawn()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}
	}

	latent function DodgeEffects()
	{
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
			GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

			GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
			GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function ACSDodgeMovementAdjust(direction : CName)
	{
		var movementAdjustorWitcher		: CMovementAdjustor; 
		var ticketWitcher				: SMovementAdjustmentRequestTicket; 

		movementAdjustorWitcher = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

		ticketWitcher = movementAdjustorWitcher.GetRequest( 'ACSMovAdj');
		movementAdjustorWitcher.CancelByName( 'ACSMovAdj' );
		movementAdjustorWitcher.CancelAll();
		ticketWitcher = movementAdjustorWitcher.CreateNewRequest( 'ACSMovAdj' );
		movementAdjustorWitcher.AdjustmentDuration( ticketWitcher, 0.125 );
		movementAdjustorWitcher.MaxRotationAdjustmentSpeed( ticketWitcher, 500000 );
		movementAdjustorWitcher.Continuous(ticketWitcher);
		movementAdjustorWitcher.KeepActiveFor(ticketWitcher, 0.125f);

		movementAdjustorWitcher.BlendIn(ticketWitcher, 0.1f);

		movementAdjustorWitcher.ShouldStartFacing(ticketWitcher, theCamera.GetCameraHeading());

		switch ( direction )
		{
			case 'backright':
			movementAdjustorWitcher.RotateTo( ticketWitcher, VecHeading( (theCamera.GetCameraDirection() * 5) + (theCamera.GetCameraRight() * 5) ) );
			break;

			case 'backleft':
			movementAdjustorWitcher.RotateTo( ticketWitcher, VecHeading( (theCamera.GetCameraDirection() * 5) + (theCamera.GetCameraRight() * -5) ) );
			break;

			case 'forwardright':
			movementAdjustorWitcher.RotateTo( ticketWitcher, VecHeading( (theCamera.GetCameraDirection() * 5) + (theCamera.GetCameraRight() * -5) ) );
			break;

			case 'forwardleft':
			movementAdjustorWitcher.RotateTo( ticketWitcher, VecHeading( (theCamera.GetCameraDirection() * 5) + (theCamera.GetCameraRight() * 5) ) );
			break;

			default:
			movementAdjustorWitcher.CancelAll();
			break;
		}
	}

	latent function vampire_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (thePlayer.IsAnyWeaponHeld()
				&& !thePlayer.IsWeaponHeld('fist')
				)
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();	
					}
					else
					{
						olgierd_slide_back_2();
					}
				}
				else
				{
					bruxa_slide_back();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
				
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_front_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			GetACSWatcher().ACS_BruxaDodgeInit('right');
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			GetACSWatcher().ACS_BruxaDodgeInit('left');	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_front_dodge();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

					GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
					GetWitcherPlayer().StopEffect( 'shadowdash_short' );
				}

				bruxa_front_dodge();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			GetACSWatcher().ACS_BruxaDodgeInit('right');

			ACSDodgeMovementAdjust('backleft');
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			GetACSWatcher().ACS_BruxaDodgeInit('left');

			ACSDodgeMovementAdjust('backright');
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function aard_sword_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (ACS_can_special_dodge()
			&& ( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			)
			{
				ACS_refresh_special_dodge_cooldown();

				bruxa_slide_back();	
				
				GetACSWatcher().ACS_StaminaDrain(4);	
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				bruxa_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				bruxa_front_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				bruxa_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
				
				DodgeEffects();

				bruxa_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				bruxa_front_dodge();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				bruxa_front_dodge();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				bruxa_right_dodge();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
				
				DodgeEffects();

				bruxa_left_dodge();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function yrden_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_right_dodge();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_left_dodge();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function yrden_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_front_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function axii_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function axii_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function quen_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}		
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function aard_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);	
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_front_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function quen_sword_dodges()
	{
		if ( theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				olgierd_slide_back();	
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_3();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_3();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_3();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_3();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function ignii_sword_dodges()
	{
		WeaponRespawn();

		if (ACS_GetItem_Sword_IsEquipped('zireal_steel_held', 'steel') || ACS_GetItem_Sword_IsEquipped('zireal_silver_held', 'silver'))
		{
			ciri_dodges();
		}
		else
		{
			if (ACS_Armor_Set_Check('wolf', true) || ACS_Armor_Set_Check('acs_armor_omega', false))
			{
				wolf_school_dodges();
			}
			else if (ACS_Armor_Set_Check('bear', true))
			{
				bear_school_dodges();
			}
			else if (ACS_Armor_Set_Check('cat', true) || ACS_Armor_Set_Check('acs_armor_alpha', false) )
			{
				cat_school_dodges();
			}
			else if (ACS_Armor_Set_Check('griffin', true) || thePlayer.HasTag('ACS_Dual_Wield_Active'))
			{
				griffin_school_dodges();
			}
			else if (ACS_Armor_Set_Check('manticore', true))
			{
				manticore_school_dodges();
			}
			else if (ACS_Armor_Set_Check('forgotten_wolf', true))
			{
				forgotten_wolf_school_dodges();
			}
			else if (ACS_Armor_Set_Check('viper', true))
			{
				viper_school_dodges();
			}
			else
			{
				if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  
				&& ( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
				|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
				|| ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				|| thePlayer.HasTag('acs_vampire_claws_equipped')
				|| ACS_Vampire_Claws_Access()
				)
				&& ACS_can_special_dodge())
				{
					ACS_refresh_special_dodge_cooldown();

					WeaponRespawn();

					if (ACS_Armor_Set_Check('acs_armor', false))
					{
						olgierd_slide_back();	
					}
					else
					{
						if (RandF() < 0.5)
						{
							bruxa_slide_back();
						}
						else
						{
							olgierd_slide_back_2();	
						}
					}

					GetACSWatcher().ACS_StaminaDrain(4);
				}
				else
				{
					WeaponRespawn();

					GetACSWatcher().dodge_timer_attack_actual();

					if (ACS_DefaultGeraltMovesetOverrideModeDodge_Enabled())
					{
						if ((thePlayer.IsWeaponHeld('fist') 
						|| !thePlayer.IsAnyWeaponHeld())
						&& !GetACSWatcher().ACS_IS_SNEAKING 
						&& !thePlayer.HasTag('ACS_Is_Sneaking')
						)
						{
							geralt_moveset_fist_dodge_override_mode();
						}
						else
						{
							geralt_moveset_dodge_override_mode();
						}
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

						Sleep(0.0625);

						GetWitcherPlayer().EvadePressed(EBAT_Dodge);

						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function geralt_moveset_dodge_override_mode()
	{
		var dodge_variations 							: array<int>;
		var chosen_dodge_variation 						: int;

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  ) // back
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else 
			{
				if (ACS_can_dodge())
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					GetACSWatcher().ACS_StaminaDrain(4);

					if (GetACSWatcher().silver_fast_stance)
					{
						override_mode_back_dodge_extras('tw1_silver_fast_dodge_back_short_ACS');

						return;
					}

					if (GetACSWatcher().silver_group_stance)
					{
						override_mode_back_dodge_extras('tw1_silver_group_dodge_back_short_ACS');

						return;
					}

					if (GetACSWatcher().silver_strong_stance)
					{
						override_mode_back_dodge_extras('tw1_silver_strong_dodge_back_short_ACS');

						return;
					}

					if (GetACSWatcher().steel_fast_stance)
					{
						override_mode_back_dodge_extras('tw1_steel_fast_dodge_back_short_ACS');

						return;
					}

					if (GetACSWatcher().steel_group_stance)
					{
						override_mode_back_dodge_extras('tw1_steel_group_dodge_back_short_ACS');

						return;
					}

					if (GetACSWatcher().steel_strong_stance)
					{
						override_mode_back_dodge_extras('tw1_steel_strong_dodge_back_short_ACS');

						return;
					}

					if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_randomized_enabled', false))
					{
						switch( GetACSWatcher().GetRandomizedDodgeVariation() )
						{
							case 13:
								override_mode_orient_back_dodge_extras('tw2_dodge_02_ACS');
							break;

							case 12:
								override_mode_orient_back_dodge_extras('tw2_dodge_01_ACS');
							break;

							case 11:
								override_mode_back_dodge_6();
							break;

							case 10:
								override_mode_back_dodge_2();
							break;

							case 9:
								override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
							break;

							case 8:
								override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
							break;

							case 7:
								override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
							break;

							case 6:
								override_mode_back_dodge_4();
							break;

							case 5:
								override_mode_back_dodge_3();
							break;

							case 4:
								override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
							break;

							case 3:
								override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
							break;

							case 2:
								override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
							break;

							case 1:
								override_mode_back_dodge_5();
							break;

							case 0:
								override_mode_back_dodge_1();
							break;

							default:
								override_mode_back_dodge_1();
							break;
						}

						return;
					}

					switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_backward_dodge_options', 0) )
					{
						case 13:
							override_mode_orient_back_dodge_extras('tw2_dodge_02_ACS');
						break;

						case 12:
							override_mode_orient_back_dodge_extras('tw2_dodge_01_ACS');
						break;

						case 11:
							override_mode_back_dodge_6();
						break;

						case 10:
							override_mode_back_dodge_2();
						break;

						case 9:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
						break;

						case 8:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
						break;

						case 7:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
						break;

						case 6:
							override_mode_back_dodge_4();
						break;

						case 5:
							override_mode_back_dodge_3();
						break;

						case 4:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
						break;

						case 3:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
						break;

						case 2:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
						break;

						case 1:
							override_mode_back_dodge_5();
						break;

						case 0:
							override_mode_back_dodge_1();
						break;

						default:
							override_mode_back_dodge_1();
						break;
					}
				}	
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0) // forward
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_fast_dodge_forward_short_ACS');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_group_dodge_forward_short_ACS');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_strong_dodge_forward_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_fast_dodge_forward_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_group_dodge_forward_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_strong_dodge_forward_short_ACS');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_randomized_enabled', false))
				{
					switch( GetACSWatcher().GetRandomizedDodgeVariation() )
					{
						case 13:
							override_mode_back_dodge_extras('tw2_dodge_02_ACS');
						break;

						case 12:
							override_mode_back_dodge_extras('tw2_dodge_01_ACS');
						break;

						case 11:
							override_mode_front_dodge_6();
						break;

						case 10:
							override_mode_front_dodge_2();
						break;

						case 9:
							override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
						break;

						case 8:
							override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
						break;

						case 7:
							override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
						break;

						case 6:
							override_mode_front_dodge_4();
						break;

						case 5:
							override_mode_front_dodge_3();
						break;

						case 4:
							override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
						break;

						case 3:
							override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
						break;

						case 2:
							override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
						break;

						case 1:
							override_mode_front_dodge_5();
						break;

						case 0:
							override_mode_front_dodge_1();
						break;

						default:
							override_mode_front_dodge_1();
						break;
					}

					return;
				}

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_foward_dodge_options', 0) )
				{
					case 13:
						override_mode_back_dodge_extras('tw2_dodge_02_ACS');
					break;

					case 12:
						override_mode_back_dodge_extras('tw2_dodge_01_ACS');
					break;

					case 11:
						override_mode_front_dodge_6();
					break;

					case 10:
						override_mode_front_dodge_2();
					break;

					case 9:
						override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
					break;

					case 8:
						override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
					break;

					case 7:
						override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
					break;

					case 6:
						override_mode_front_dodge_4();
					break;

					case 5:
						override_mode_front_dodge_3();
					break;

					case 4:
						override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
					break;

					case 3:
						override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
					break;

					case 2:
						override_mode_front_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
					break;

					case 1:
						override_mode_front_dodge_5();
					break;

					case 0:
						override_mode_front_dodge_1();
					break;

					default:
						override_mode_front_dodge_1();
					break;
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 ) // right
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_fast_dodge_right_short_ACS');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_group_dodge_right_short_ACS');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_strong_dodge_right_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_fast_dodge_right_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_group_dodge_right_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_strong_dodge_right_short_ACS');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_randomized_enabled', false))
				{
					switch( GetACSWatcher().GetRandomizedDodgeVariation() )
					{
						case 13:
							override_mode_left_dodge_extras('tw2_dodge_02_ACS');
						break;

						case 12:
							override_mode_left_dodge_extras('tw2_dodge_01_ACS');
						break;

						case 11:
							override_mode_right_dodge_6();
						break;

						case 10:
							override_mode_right_dodge_2();
						break;

						case 9:
							override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
						break;

						case 8:
							override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
						break;

						case 7:
							override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
						break;

						case 6:
							override_mode_right_dodge_4();
						break;

						case 5:
							override_mode_right_dodge_3();
						break;

						case 4:
							override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
						break;

						case 3:
							override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
						break;

						case 2:
							override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
						break;

						case 1:
							override_mode_right_dodge_5();
						break;

						case 0:
							override_mode_right_dodge_1();
						break;

						default:
							override_mode_right_dodge_1();
						break;
					}

					return;
				}

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_right_dodge_options', 0) )
				{
					case 13:
						override_mode_left_dodge_extras('tw2_dodge_02_ACS');
					break;

					case 12:
						override_mode_left_dodge_extras('tw2_dodge_01_ACS');
					break;

					case 11:
						override_mode_right_dodge_6();
					break;

					case 10:
						override_mode_right_dodge_2();
					break;

					case 9:
						override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
					break;

					case 8:
						override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
					break;

					case 7:
						override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
					break;

					case 6:
						override_mode_right_dodge_4();
					break;

					case 5:
						override_mode_right_dodge_3();
					break;

					case 4:
						override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
					break;

					case 3:
						override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
					break;

					case 2:
						override_mode_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
					break;

					case 1:
						override_mode_right_dodge_5();
					break;

					case 0:
						override_mode_right_dodge_1();
					break;

					default:
						override_mode_right_dodge_1();
					break;
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) // left
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_fast_dodge_left_short_ACS');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_group_dodge_left_short_ACS');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_strong_dodge_left_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_fast_dodge_left_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_group_dodge_left_short_ACS');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_strong_dodge_left_short_ACS');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_randomized_enabled', false))
				{
					switch( GetACSWatcher().GetRandomizedDodgeVariation() )
					{
						case 13:
							override_mode_right_dodge_extras('tw2_dodge_02_ACS');
						break;

						case 12:
							override_mode_right_dodge_extras('tw2_dodge_01_ACS');
						break;

						case 11:
							override_mode_left_dodge_6();
						break;

						case 10:
							override_mode_left_dodge_2();
						break;

						case 9:
							override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
						break;

						case 8:
							override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
						break;

						case 7:
							override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
						break;

						case 6:
							override_mode_left_dodge_4();
						break;

						case 5:
							override_mode_left_dodge_3();
						break;

						case 4:
							override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
						break;

						case 3:
							override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
						break;

						case 2:
							override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
						break;

						case 1:
							override_mode_left_dodge_5();
						break;

						case 0:
							override_mode_left_dodge_1();
						break;

						default:
							override_mode_left_dodge_1();
						break;
					}

					return;
				}

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_left_dodge_options', 0) )
				{
					case 13:
						override_mode_right_dodge_extras('tw2_dodge_02_ACS');
					break;

					case 12:
						override_mode_right_dodge_extras('tw2_dodge_01_ACS');
					break;

					case 11:
						override_mode_left_dodge_6();
					break;

					case 10:
						override_mode_left_dodge_2();
					break;

					case 9:
						override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
					break;

					case 8:
						override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
					break;

					case 7:
						override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
					break;

					case 6:
						override_mode_left_dodge_4();
					break;

					case 5:
						override_mode_left_dodge_3();
					break;

					case 4:
						override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
					break;

					case 3:
						override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
					break;

					case 2:
						override_mode_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
					break;

					case 1:
						override_mode_left_dodge_5();
					break;

					case 0:
						override_mode_left_dodge_1();
					break;

					default:
						override_mode_left_dodge_1();
					break;
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 ) // front right
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_fast_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_group_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_strong_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_fast_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_group_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_strong_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_randomized_enabled', false))
				{
					switch( GetACSWatcher().GetRandomizedDodgeVariation() )
					{
						case 13:
							override_mode_back_right_dodge_extras('tw2_dodge_02_ACS');
						break;

						case 12:
							override_mode_back_right_dodge_extras('tw2_dodge_01_ACS');
						break;

						case 11:
							override_mode_right_dodge_6();

							ACSDodgeMovementAdjust('forwardleft');
						break;

						case 10:
							override_mode_right_dodge_2();

							ACSDodgeMovementAdjust('forwardleft');
						break;

						case 9:
							override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
						break;

						case 8:
							override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
						break;

						case 7:
							override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
						break;

						case 6:
							override_mode_front_dodge_4();

							ACSDodgeMovementAdjust('forwardleft');
						break;

						case 5:
							override_mode_right_dodge_3();

							ACSDodgeMovementAdjust('forwardright');
						break;

						case 4:
							override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
						break;

						case 3:
							override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
						break;

						case 2:
							override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
						break;

						case 1:
							override_mode_right_dodge_5();

							ACSDodgeMovementAdjust('forwardleft');
						break;

						case 0:
							override_mode_right_dodge_1();

							ACSDodgeMovementAdjust('forwardright');
						break;

						default:
							override_mode_right_dodge_1();

							ACSDodgeMovementAdjust('forwardright');
						break;
					}

					return;
				}

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_right_dodge_options', 0) )
				{
					case 13:
						override_mode_back_right_dodge_extras('tw2_dodge_02_ACS');
					break;

					case 12:
						override_mode_back_right_dodge_extras('tw2_dodge_01_ACS');
					break;

					case 11:
						override_mode_right_dodge_6();

						ACSDodgeMovementAdjust('forwardleft');
					break;

					case 10:
						override_mode_right_dodge_2();

						ACSDodgeMovementAdjust('forwardleft');
					break;

					case 9:
						override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
					break;

					case 8:
						override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
					break;

					case 7:
						override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
					break;

					case 6:
						override_mode_front_dodge_4();

						ACSDodgeMovementAdjust('forwardleft');
					break;

					case 5:
						override_mode_right_dodge_3();

						ACSDodgeMovementAdjust('forwardright');
					break;

					case 4:
						override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
					break;

					case 3:
						override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
					break;

					case 2:
						override_mode_front_right_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
					break;

					case 1:
						override_mode_right_dodge_5();

						ACSDodgeMovementAdjust('forwardleft');
					break;

					case 0:
						override_mode_right_dodge_1();

						ACSDodgeMovementAdjust('forwardright');
					break;

					default:
						override_mode_right_dodge_1();

						ACSDodgeMovementAdjust('forwardright');
					break;
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 ) // front left
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_fast_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_group_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_strong_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_fast_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_group_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_strong_dodge_forward_short_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_randomized_enabled', false))
				{
					switch( GetACSWatcher().GetRandomizedDodgeVariation() )
					{
						case 13:
							override_mode_back_left_dodge_extras('tw2_dodge_02_ACS');
						break;

						case 12:
							override_mode_back_left_dodge_extras('tw2_dodge_01_ACS');
						break;

						case 11:
							override_mode_left_dodge_6();

							ACSDodgeMovementAdjust('forwardright');
						break;

						case 10:
							override_mode_left_dodge_2();

							ACSDodgeMovementAdjust('forwardright');
						break;

						case 9:
							override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
						break;

						case 8:
							override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
						break;

						case 7:
							override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
						break;

						case 6:
							override_mode_front_dodge_4();

							ACSDodgeMovementAdjust('forwardright');
						break;

						case 5:
							override_mode_left_dodge_3();

							ACSDodgeMovementAdjust('forwardleft');
						break;

						case 4:
							override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
						break;

						case 3:
							override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
						break;

						case 2:
							override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
						break;

						case 1:
							override_mode_left_dodge_5();

							ACSDodgeMovementAdjust('forwardright');
						break;

						case 0:
							override_mode_left_dodge_1();

							ACSDodgeMovementAdjust('forwardleft');
						break;

						default:
							override_mode_left_dodge_1();

							ACSDodgeMovementAdjust('forwardleft');
						break;
					}

					return;
				}

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_left_dodge_options', 0) )
				{
					case 13:
						override_mode_back_left_dodge_extras('tw2_dodge_02_ACS');
					break;

					case 12:
						override_mode_back_left_dodge_extras('tw2_dodge_01_ACS');
					break;

					case 11:
						override_mode_left_dodge_6();

						ACSDodgeMovementAdjust('forwardright');
					break;

					case 10:
						override_mode_left_dodge_2();

						ACSDodgeMovementAdjust('forwardright');
					break;

					case 9:
						override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');
					break;

					case 8:
						override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');
					break;

					case 7:
						override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');
					break;

					case 6:
						override_mode_front_dodge_4();

						ACSDodgeMovementAdjust('forwardright');
					break;

					case 5:
						override_mode_left_dodge_3();

						ACSDodgeMovementAdjust('forwardleft');
					break;

					case 4:
						override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');
					break;

					case 3:
						override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');
					break;

					case 2:
						override_mode_front_left_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');
					break;

					case 1:
						override_mode_left_dodge_5();

						ACSDodgeMovementAdjust('forwardright');
					break;

					case 0:
						override_mode_left_dodge_1();

						ACSDodgeMovementAdjust('forwardleft');
					break;

					default:
						override_mode_left_dodge_1();

						ACSDodgeMovementAdjust('forwardleft');
					break;
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 ) // back right
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_fast_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_group_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_strong_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_fast_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_group_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_strong_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_randomized_enabled', false))
				{
					switch( GetACSWatcher().GetRandomizedDodgeVariation() )
					{
						case 13:
							override_mode_front_left_dodge_extras('tw2_dodge_02_ACS');
						break;

						case 12:
							override_mode_front_left_dodge_extras('tw2_dodge_01_ACS');
						break;

						case 11:
							override_mode_back_dodge_6();

							ACSDodgeMovementAdjust('backleft');
						break;

						case 10:
							override_mode_back_dodge_2();

							ACSDodgeMovementAdjust('backleft');
						break;

						case 9:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');

							ACSDodgeMovementAdjust('backleft');
						break;

						case 8:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');

							ACSDodgeMovementAdjust('backleft');
						break;

						case 7:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');

							ACSDodgeMovementAdjust('backleft');
						break;

						case 6:
							override_mode_back_dodge_4();

							ACSDodgeMovementAdjust('backleft');
						break;

						case 5:
							override_mode_back_dodge_3();

							ACSDodgeMovementAdjust('backleft');
						break;

						case 4:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');

							ACSDodgeMovementAdjust('backleft');
						break;

						case 3:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');

							ACSDodgeMovementAdjust('backleft');
						break;

						case 2:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');

							ACSDodgeMovementAdjust('backleft');
						break;

						case 1:
							override_mode_back_dodge_5();

							ACSDodgeMovementAdjust('backleft');
						break;

						case 0:
							override_mode_right_dodge_1();

							ACSDodgeMovementAdjust('backright');
						break;

						default:
							override_mode_right_dodge_1();

							ACSDodgeMovementAdjust('backright');
						break;
					}

					return;
				}

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_right_dodge_options', 0) )
				{
					case 13:
						override_mode_front_left_dodge_extras('tw2_dodge_02_ACS');
					break;

					case 12:
						override_mode_front_left_dodge_extras('tw2_dodge_01_ACS');
					break;

					case 11:
						override_mode_back_dodge_6();

						ACSDodgeMovementAdjust('backleft');
					break;

					case 10:
						override_mode_back_dodge_2();

						ACSDodgeMovementAdjust('backleft');
					break;

					case 9:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');

						ACSDodgeMovementAdjust('backleft');
					break;

					case 8:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');

						ACSDodgeMovementAdjust('backleft');
					break;

					case 7:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');

						ACSDodgeMovementAdjust('backleft');
					break;

					case 6:
						override_mode_back_dodge_4();

						ACSDodgeMovementAdjust('backleft');
					break;

					case 5:
						override_mode_back_dodge_3();

						ACSDodgeMovementAdjust('backleft');
					break;

					case 4:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');

						ACSDodgeMovementAdjust('backleft');
					break;

					case 3:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');

						ACSDodgeMovementAdjust('backleft');
					break;

					case 2:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');

						ACSDodgeMovementAdjust('backleft');
					break;

					case 1:
						override_mode_back_dodge_5();

						ACSDodgeMovementAdjust('backleft');
					break;

					case 0:
						override_mode_right_dodge_1();

						ACSDodgeMovementAdjust('backright');
					break;

					default:
						override_mode_right_dodge_1();

						ACSDodgeMovementAdjust('backright');
					break;
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 ) // back left
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_fast_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_group_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_strong_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_fast_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_group_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_strong_dodge_back_short_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_randomized_enabled', false))
				{
					switch( GetACSWatcher().GetRandomizedDodgeVariation() )
					{
						case 13:
							override_mode_front_right_dodge_extras('tw2_dodge_02_ACS');
						break;

						case 12:
							override_mode_front_right_dodge_extras('tw2_dodge_01_ACS');
						break;

						case 11:
							override_mode_back_dodge_6();

							ACSDodgeMovementAdjust('backright');
						break;

						case 10:
							override_mode_back_dodge_2();

							ACSDodgeMovementAdjust('backright');
						break;

						case 9:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');

							ACSDodgeMovementAdjust('backright');
						break;

						case 8:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');

							ACSDodgeMovementAdjust('backright');
						break;

						case 7:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');

							ACSDodgeMovementAdjust('backright');

						break;

						case 6:
							override_mode_back_dodge_4();

							ACSDodgeMovementAdjust('backright');
						break;

						case 5:
							override_mode_back_dodge_3();

							ACSDodgeMovementAdjust('backright');
						break;

						case 4:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');

							ACSDodgeMovementAdjust('backright');
						break;

						case 3:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');

							ACSDodgeMovementAdjust('backright');
						break;

						case 2:
							override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');

							ACSDodgeMovementAdjust('backright');
						break;

						case 1:
							override_mode_back_dodge_5();

							ACSDodgeMovementAdjust('backright');
						break;

						case 0:
							override_mode_left_dodge_1();

							ACSDodgeMovementAdjust('backleft');
						break;

						default:
							override_mode_left_dodge_1();

							ACSDodgeMovementAdjust('backleft');
						break;
					}

					return;
				}

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_left_dodge_options', 0) )
				{
					case 13:
						override_mode_front_right_dodge_extras('tw2_dodge_02_ACS');
					break;

					case 12:
						override_mode_front_right_dodge_extras('tw2_dodge_01_ACS');
					break;

					case 11:
						override_mode_back_dodge_6();

						ACSDodgeMovementAdjust('backright');
					break;

					case 10:
						override_mode_back_dodge_2();

						ACSDodgeMovementAdjust('backright');
					break;

					case 9:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_03');

						ACSDodgeMovementAdjust('backright');
					break;

					case 8:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_02');

						ACSDodgeMovementAdjust('backright');
					break;

					case 7:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_02');

						ACSDodgeMovementAdjust('backright');

					break;

					case 6:
						override_mode_back_dodge_4();

						ACSDodgeMovementAdjust('backright');
					break;

					case 5:
						override_mode_back_dodge_3();

						ACSDodgeMovementAdjust('backright');
					break;

					case 4:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_03');

						ACSDodgeMovementAdjust('backright');
					break;

					case 3:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_lp_01');

						ACSDodgeMovementAdjust('backright');
					break;

					case 2:
						override_mode_back_dodge_extras('man_geralt_sword_dodge_back_337cm_rp_01');

						ACSDodgeMovementAdjust('backright');
					break;

					case 1:
						override_mode_back_dodge_5();

						ACSDodgeMovementAdjust('backright');
					break;

					case 0:
						override_mode_left_dodge_1();

						ACSDodgeMovementAdjust('backleft');
					break;

					default:
						override_mode_left_dodge_1();

						ACSDodgeMovementAdjust('backleft');
					break;
				}
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function geralt_moveset_fist_dodge_override_mode()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				bruxa_slide_back();

				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				override_mode_fist_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				override_mode_fist_front_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				override_mode_fist_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				override_mode_fist_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				override_mode_fist_right_dodge();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				override_mode_fist_left_dodge();

				ACSDodgeMovementAdjust('forwardleft');

				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				override_mode_fist_right_dodge();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				override_mode_fist_left_dodge();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_fist_regular_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.Continuous(ticket);
		movementAdjustor.KeepActiveFor(ticket, 0.5f);

		GetACSWatcher().dodge_timer_actual();
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge_back_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge_back_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_fist_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.Continuous(ticket);
		movementAdjustor.KeepActiveFor(ticket, 0.1f);

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_fist_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.Continuous(ticket);
		movementAdjustor.KeepActiveFor(ticket, 0.25f);

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );
	}

	latent function override_mode_fist_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.Continuous(ticket);
		movementAdjustor.KeepActiveFor(ticket, 0.25f);

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_back_dodge_1()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.Continuous(ticket);
		movementAdjustor.KeepActiveFor(ticket, 0.1f);

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function override_mode_back_dodge_2()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_back_dodge_5()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_with_torso_left_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_with_torso_right_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_with_torso_left_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_with_torso_right_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function override_mode_back_dodge_4()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_back_dodge_3()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_back_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_back_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_back_dodge_6()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_flip_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_dodge_b_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_flip_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_dodge_b_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_front_dodge_1()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function override_mode_front_dodge_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function override_mode_front_dodge_5()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function override_mode_front_dodge_4()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function override_mode_front_dodge_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function override_mode_front_dodge_6()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_front_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if (RandF() < 0.5)
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 180 );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 180 );
		}
		

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_front_right_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if (RandF() < 0.5)
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 135 );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 225 );
		}
		
		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_front_left_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if (RandF() < 0.5)
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 225 );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 135 );
		}
		

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_back_right_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if (RandF() < 0.5)
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 315 );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 45 );
		}
		
		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_back_left_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if (RandF() < 0.5)
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 45 );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 315 );
		}
		
		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_right_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );
		

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		if (GetACSWatcher().silver_group_stance
		|| GetACSWatcher().silver_strong_stance
		|| GetACSWatcher().silver_fast_stance
		|| GetACSWatcher().steel_group_stance
		|| GetACSWatcher().steel_strong_stance
		|| GetACSWatcher().steel_fast_stance
		)
		{					
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5  ); }	
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_left_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );
		

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		if (GetACSWatcher().silver_group_stance
		|| GetACSWatcher().silver_strong_stance
		|| GetACSWatcher().silver_fast_stance
		|| GetACSWatcher().steel_group_stance
		|| GetACSWatcher().steel_strong_stance
		|| GetACSWatcher().steel_fast_stance
		)
		{					
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5  ); }	
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_back_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	

		if (GetACSWatcher().silver_group_stance
		|| GetACSWatcher().silver_strong_stance
		|| GetACSWatcher().silver_fast_stance
		|| GetACSWatcher().steel_group_stance
		|| GetACSWatcher().steel_strong_stance
		|| GetACSWatcher().steel_fast_stance
		)
		{					
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5  ); }	
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_orient_back_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if (RandF() < 0.5)
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 180 );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 180 );
		}
		
		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_right_dodge_1()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_right_dodge_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_right_dodge_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_right_dodge_4()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_right_dodge_5()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_right_dodge_6()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_right_dodge_7()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_left_dodge_1()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_left_dodge_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_left_dodge_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_left_dodge_4()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_left_dodge_5()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_left_dodge_6()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_left_dodge_7()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function wolf_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function bear_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function cat_school_dodges()
	{
		if ( theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_front_dodge_alt_3();

				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_right_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_left_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_right_dodge_alt_3();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_left_dodge_alt_3();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_right_dodge_alt_3();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				cat_one_hand_sword_left_dodge_alt_3();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function griffin_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function manticore_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function forgotten_wolf_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4_short();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4_short();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4_short();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4_short();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4_short();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4_short();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function viper_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4();

				ACSDodgeMovementAdjust('forwardright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4();

				ACSDodgeMovementAdjust('forwardleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_right_dodge_alt_4();

				ACSDodgeMovementAdjust('backright');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_left_dodge_alt_4();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	latent function ciri_dodges()
	{
		if (!GetWitcherPlayer().IsEffectActive('fury_403_ciri', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'fury_403_ciri' );
		}

		if (!GetWitcherPlayer().IsEffectActive('fury_ciri', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'fury_ciri' );
		}

		if (!GetWitcherPlayer().IsEffectActive('acs_fury_ciri', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'acs_fury_ciri' );
		}

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_dodge_slide_back', true) 
			|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) 
			|| ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			|| thePlayer.HasTag('acs_vampire_claws_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('back');

				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					olgierd_slide_back();	
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();	
					}
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('back');

				ciri_dodge_back();
				
				GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('front');

				ciri_dodge_front();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('right');

				ciri_dodge_right();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('left');

				ciri_dodge_left();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('right');

				ciri_dodge_right();

				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('left');

				ciri_dodge_left();

				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('right');

				ciri_dodge_right();

				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodge('left');

				ciri_dodge_left();

				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			GetACSWatcher().ACS_BruxaDodgeInit('center');
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function bruxa_slide_back()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
				GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_slideback_actual();

			GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();
		
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 2  ); }	
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

			if ((thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist'))
			|| ACSGetCEntity('acs_finisher_dagger')
			|| thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering() 
			|| !thePlayer.GetWeaponHolster().IsMeleeWeaponReady()
			)
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_with_weapon_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}

			movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2.25 ) + theCamera.GetCameraDirection() * -2.25) );		

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
				GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	
			}
					
			GetACSWatcher().dodge_timer_slideback_actual();

			GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 2  ); }	
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if ((thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist'))
			|| ACSGetCEntity('acs_finisher_dagger')
			|| thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering() 
			|| !thePlayer.GetWeaponHolster().IsMeleeWeaponReady()
			)
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_with_weapon_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			
			movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2.25 ) + theCamera.GetCameraDirection() * -2.25) );
		}

		//Sleep(1);
		
		//GetWitcherPlayer().SetIsCurrentlyDodging(false);
	}

	latent function olgierd_slide_back()
	{
		if (ACS_Armor_Set_Check('acs_armor', false))
		{
			if (RandF() < 0.5)
			{
				bruxa_slide_back();
			}
			else
			{
				olgierd_slide_back_actual();	
			}
		}
		else
		{
			if (ACS_GetWeaponMode() == 3)
			{
				if (thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' ))
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_actual();
					}
				}
				else
				{
					if (RandF() < 0.5)
					{
						bruxa_slide_back();
					}
					else
					{
						olgierd_slide_back_2();
					}
				}
			}
			else
			{
				if (RandF() < 0.5)
				{
					bruxa_slide_back();
				}
				else
				{
					olgierd_slide_back_actual();
				}
			}
		}
	}

	latent function olgierd_slide_back_actual()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if( targetDistance <= 2*2 ) 
			{
				GetACSWatcher().dodge_timer_attack_actual();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
				&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
				{
					GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
					GetWitcherPlayer().StopEffect('special_attack_fx');

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();
			
				if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5  ); }
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
				movementAdjustor.SlideTo( ticket, ACSFixZAxis((GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.5) + theCamera.GetCameraDirection() * -1.5) );
			}
			else
			{
				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
				&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
				{
					GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
					GetWitcherPlayer().StopEffect('special_attack_fx');

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}
						
				GetACSWatcher().dodge_timer_attack_actual();

				GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();
			
				if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5  ); }
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_igni_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
				movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3 );		
			}

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
				GetWitcherPlayer().StopEffect('special_attack_fx');

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5  ); }
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_igni_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );
		}

		if (!GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
		{
			GetWitcherPlayer().AddTag('ACS_Special_Dodge');
		}
	}

	latent function olgierd_slide_back_2()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();
		
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5  ); }
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );		
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5  ); }
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );
		}
	}

	latent function bruxa_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		movementAdjustor.CancelAll();

		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );
		}
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//movementAdjustor.RotateTowards( ticket, actor );
					
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			)
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			
			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );			
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			)
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			
			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		
		}
	}

	latent function bruxa_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function bruxa_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}

	latent function bruxa_regular_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function two_hand_front_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function two_hand_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function two_hand_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
		//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		
		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_sword_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 2*2 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_b_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				/*
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_rp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				*/

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{				
			/*
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_rp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_longsword_dodge_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			*/
			
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function two_hand_sword_front_dodge()
	{
		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);

		GetACSWatcher().ACS_StaminaDrain(4);
	}

	latent function two_hand_sword_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_l_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function two_hand_sword_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_r_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}

		/*
		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);	

		*/
	}

	latent function one_hand_sword_front_dodge_long()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 3 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 3) );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}

		/*
		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);	

		*/
	}

	latent function one_hand_sword_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_1()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_lp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_rp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_front_dodge_alt_1()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function ciri_dodge_front()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 6 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 6) );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if (RandF() < 0.5)
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_front_lp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_front_rp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if (RandF() < 0.5)
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_front_lp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_front_rp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
			}
		}
	}

	latent function one_hand_sword_left_dodge_alt_1()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 1.5*1.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	latent function one_hand_sword_right_dodge_alt_1()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 1.5*1.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_left_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_1hand_dodge_b_right_far_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_front_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function one_hand_sword_left_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();}	

		/*
		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_back_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function ciri_dodge_back()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -6 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -6) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_special_blink_attack_disappear_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));
	}

	latent function one_hand_sword_front_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function one_hand_sword_left_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_left_dodge_alt_4()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_left_dodge_alt_4_short()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4_short()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function ciri_dodge_left()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -6 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -6) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if (RandF() < 0.5)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_left_rp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_left_lp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
		}
	}

	latent function ciri_dodge_right()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 6 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 6) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  , false );

		if (RandF() < 0.5)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_right_rp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_right_lp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function cat_one_hand_sword_back_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25   , false );	

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_back_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function cat_one_hand_sword_front_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25   , false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function cat_one_hand_sword_left_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25   , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function cat_one_hand_sword_right_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25   , false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cBruxaDodgeBack
{
    function BruxaDodgeBackCenter_Engage()
	{
		this.PushState('BruxaDodgeBackCenter_Engage');
	}

	function BruxaDodgeBackLeft_Engage()
	{
		this.PushState('BruxaDodgeBackLeft_Engage');
	}

	function BruxaDodgeBackRight_Engage()
	{
		this.PushState('BruxaDodgeBackRight_Engage');
	}

	/*
	function BruxaRegularDodgeBack_Engage()
	{
		this.PushState('BruxaRegularDodgeBack_Engage');
	}

	function BruxaRegularDodgeLeft_Engage()
	{
		this.PushState('BruxaRegularDodgeLeft_Engage');
	}

	function BruxaRegularDodgeRight_Engage()
	{
		this.PushState('BruxaRegularDodgeRight_Engage');
	}
	*/
}



state BruxaDodgeBackCenter_Engage in cBruxaDodgeBack
{
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var actor									: CActor;
	private var dist									: float;

	event OnEnterState(prevStateName : name)
	{
		BruxaDodgeBack();
	}
	
	entry function BruxaDodgeBack()
	{
		if (ACSGetCEntity('ACS_Aim_Impact_Entity'))
		{
			ACSGetCEntity('ACS_Aim_Impact_Entity').Destroy();
		}

		if ( ACS_Settings_Main_Bool('acs_stamina_settings','acs_stamina_block_action', false) 
		&& GetACSWatcher().StaminaCheck('default')
		)
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");

			return;
		}

		if (((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_hard'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_soil'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'hay'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'stone_debris'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'clay_tile'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_large'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_small'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'sand'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_short'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_long'
		)
		{
			//thePlayer.StopEffect('covered_dirt_ACS');
			//thePlayer.PlayEffect('covered_dirt_ACS');

			if( GetRainStrength() > 0 
			&& !thePlayer.IsInInterior()
			) 
			{

			}
			else if (ACS_Settings_Main_Bool('acs_player_misc_settings','acs_dirt_vfx_enabled', true))
			{
				switch(GetACSWatcher().dirt_counter)
				{
					case 5:
						thePlayer.StopEffect('covered_dirt_small_ACS');
						thePlayer.PlayEffect('covered_dirt_small_ACS');
						
						GetACSWatcher().ManageDirtCounter(false);
					break;

					case 4:

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 3:

						thePlayer.StopEffect('covered_dirt_big_ACS');
						thePlayer.PlayEffect('covered_dirt_big_ACS');

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 2:

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 1:

						GetACSWatcher().ManageDirtCounter(true);
						
					break;

					default:
						GetACSWatcher().ManageDirtCounter(true);

					break;
				}
			}
		}

		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();

		if (thePlayer.IsAnyWeaponHeld() 
		&& !thePlayer.IsWeaponHeld('fist')
		&& !thePlayer.HasTag('acs_vampire_claws_equipped')
		&& !thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
			 
			 
			GetACSWatcher().RemoveTimer('CombatTauntDelay');GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondaryWeaponBlood'); 
			GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 , false ); 

			if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
			{
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 , false ); 

				thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
			}
		}
	
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 10 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if ((thePlayer.IsAnyWeaponHeld()
		&& !thePlayer.IsWeaponHeld('fist'))
		|| ACSGetCEntity('acs_finisher_dagger')
		|| thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering() 
		|| !thePlayer.GetWeaponHolster().IsMeleeWeaponReady()
		)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_center_with_weapon_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -2) );
	}
}

state BruxaDodgeBackLeft_Engage in cBruxaDodgeBack
{
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var actor									: CActor;
	private var dist									: float;

	event OnEnterState(prevStateName : name)
	{
		BruxaDodgeBackLeft();
	}
	
	entry function BruxaDodgeBackLeft()
	{
		if (ACSGetCEntity('ACS_Aim_Impact_Entity'))
		{
			ACSGetCEntity('ACS_Aim_Impact_Entity').Destroy();
		}

		if ( ACS_Settings_Main_Bool('acs_stamina_settings','acs_stamina_block_action', false) 
		&& GetACSWatcher().StaminaCheck('default')
		)
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");

			return;
		}

		if (((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_hard'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_soil'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'hay'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'stone_debris'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'clay_tile'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_large'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_small'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'sand'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_short'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_long'
		)
		{
			//thePlayer.StopEffect('covered_dirt_ACS');
			//thePlayer.PlayEffect('covered_dirt_ACS');

			if( GetRainStrength() > 0 
			&& !thePlayer.IsInInterior()
			&& !GetACSWatcher().RoofCheck()
			) 
			{

			}
			else if (ACS_Settings_Main_Bool('acs_player_misc_settings','acs_dirt_vfx_enabled', true))
			{
				switch(GetACSWatcher().dirt_counter)
				{
					case 5:
						thePlayer.StopEffect('covered_dirt_small_ACS');
						thePlayer.PlayEffect('covered_dirt_small_ACS');
						
						GetACSWatcher().ManageDirtCounter(false);
					break;

					case 4:

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 3:

						thePlayer.StopEffect('covered_dirt_big_ACS');
						thePlayer.PlayEffect('covered_dirt_big_ACS');

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 2:

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 1:

						GetACSWatcher().ManageDirtCounter(true);
						
					break;

					default:
						GetACSWatcher().ManageDirtCounter(true);

					break;
				}
			}
		}

		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();

		if (thePlayer.IsAnyWeaponHeld() 
		&& !thePlayer.IsWeaponHeld('fist')
		&& !thePlayer.HasTag('acs_vampire_claws_equipped')
		&& !thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
			 
			 
			GetACSWatcher().RemoveTimer('CombatTauntDelay');GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondaryWeaponBlood'); 
			GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 , false ); 

			if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
			{
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 , false ); 

				thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
			}
		}
	
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() + ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 ) );

		if ((thePlayer.IsAnyWeaponHeld()
		&& !thePlayer.IsWeaponHeld('fist'))
		|| ACSGetCEntity('acs_finisher_dagger')
		|| thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering() 
		|| !thePlayer.GetWeaponHolster().IsMeleeWeaponReady()
		)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_left_with_weapon_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, TraceFloor( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 ) );
	}
}

state BruxaDodgeBackRight_Engage in cBruxaDodgeBack
{
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var actor									: CActor;
	private var dist									: float;

	event OnEnterState(prevStateName : name)
	{
		BruxaDodgeBackRight();
	}
	
	entry function BruxaDodgeBackRight()
	{
		if (ACSGetCEntity('ACS_Aim_Impact_Entity'))
		{
			ACSGetCEntity('ACS_Aim_Impact_Entity').Destroy();
		}
		
		if ( ACS_Settings_Main_Bool('acs_stamina_settings','acs_stamina_block_action', false) 
		&& GetACSWatcher().StaminaCheck('default')
		)
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");

			return;
		}

		if (((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_hard'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_soil'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'hay'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'stone_debris'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'clay_tile'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_large'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_small'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'sand'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_short'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_long'
		)
		{
			//thePlayer.StopEffect('covered_dirt_ACS');
			//thePlayer.PlayEffect('covered_dirt_ACS');

			if( GetRainStrength() > 0 
			&& !thePlayer.IsInInterior()
			&& !GetACSWatcher().RoofCheck()
			) 
			{

			}
			else if (ACS_Settings_Main_Bool('acs_player_misc_settings','acs_dirt_vfx_enabled', true))
			{
				switch(GetACSWatcher().dirt_counter)
				{
					case 5:
						thePlayer.StopEffect('covered_dirt_small_ACS');
						thePlayer.PlayEffect('covered_dirt_small_ACS');
						
						GetACSWatcher().ManageDirtCounter(false);
					break;

					case 4:

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 3:

						thePlayer.StopEffect('covered_dirt_big_ACS');
						thePlayer.PlayEffect('covered_dirt_big_ACS');

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 2:

						GetACSWatcher().ManageDirtCounter(true);
					break;

					case 1:

						GetACSWatcher().ManageDirtCounter(true);
						
					break;

					default:
						GetACSWatcher().ManageDirtCounter(true);

					break;
				}
			}
		}
		
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();

		if (thePlayer.IsAnyWeaponHeld() 
		&& !thePlayer.IsWeaponHeld('fist')
		&& !thePlayer.HasTag('acs_vampire_claws_equipped')
		&& !thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
			 
			 
			GetACSWatcher().RemoveTimer('CombatTauntDelay');GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondaryWeaponBlood'); 
			GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 , false ); 

			if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
			{
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 , false ); 

				thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
			}
		}
	
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() + ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 ) );

		if ((thePlayer.IsAnyWeaponHeld()
		&& !thePlayer.IsWeaponHeld('fist'))
		|| ACSGetCEntity('acs_finisher_dagger')
		|| thePlayer.GetWeaponHolster().IsOnTheMiddleOfHolstering() 
		|| !thePlayer.GetWeaponHolster().IsMeleeWeaponReady()
		)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_right_with_weapon_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1) );
	}
}


/*

state BruxaRegularDodgeBack_Engage in cBruxaDodgeBack
{
	private var pActor, actor 							: CActor;
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance					: float;
	private var pos, cPos								: Vector;
	private var actors, targetActors    				: array<CActor>;
	private var i         								: int;
	private var npc, targetNpc     						: CNewNPC;
	private var teleport_fx								: CEntity;

	event OnEnterState(prevStateName : name)
	{
		bruxa_regular_dodge_Entry();
	}
	
	entry function bruxa_regular_dodge_Entry()
	{	
		if ( ACS_Settings_Main_Bool('acs_stamina_settings','acs_stamina_block_action', false) 
		&& GetACSWatcher().StaminaCheck('default')
		)
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");

			return;
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		GetWitcherPlayer().StopEffect('dive_shape');

		GetWitcherPlayer().RemoveTag('ACS_Bruxa_Jump_End');

		if (thePlayer.IsAnyWeaponHeld() 
		&& !thePlayer.IsWeaponHeld('fist')
		&& !thePlayer.HasTag('acs_vampire_claws_equipped')
		&& !thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
			 
			 
			GetACSWatcher().RemoveTimer('CombatTauntDelay');GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondaryWeaponBlood'); 
			GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 , false ); 

			if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
			{
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 , false ); 

				thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
			}
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}
}

state BruxaRegularDodgeLeft_Engage in cBruxaDodgeBack
{
	private var pActor, actor 							: CActor;
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance					: float;
	private var pos, cPos								: Vector;
	private var actors, targetActors    				: array<CActor>;
	private var i         								: int;
	private var npc, targetNpc     						: CNewNPC;
	private var teleport_fx								: CEntity;

	event OnEnterState(prevStateName : name)
	{
		bruxa_regular_dodge_left_Entry();
	}
	
	entry function bruxa_regular_dodge_left_Entry()
	{
		if ( ACS_Settings_Main_Bool('acs_stamina_settings','acs_stamina_block_action', false) 
		&& GetACSWatcher().StaminaCheck('default')
		)
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");

			return;
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		GetWitcherPlayer().StopEffect('dive_shape');

		GetWitcherPlayer().RemoveTag('ACS_Bruxa_Jump_End');

		if (thePlayer.IsAnyWeaponHeld() 
		&& !thePlayer.IsWeaponHeld('fist')
		&& !thePlayer.HasTag('acs_vampire_claws_equipped')
		&& !thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
			 
			 
			GetACSWatcher().RemoveTimer('CombatTauntDelay');GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondaryWeaponBlood'); 
			GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 , false ); 

			if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
			{
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 , false ); 

				thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
			}
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
					
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}
}

state BruxaRegularDodgeRight_Engage in cBruxaDodgeBack
{
	private var pActor, actor 							: CActor;
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance					: float;
	private var pos, cPos								: Vector;
	private var actors, targetActors    				: array<CActor>;
	private var i         								: int;
	private var npc, targetNpc     						: CNewNPC;
	private var teleport_fx								: CEntity;

	event OnEnterState(prevStateName : name)
	{
		bruxa_regular_dodge_right_Entry();
	}
	
	entry function bruxa_regular_dodge_right_Entry()
	{
		if ( ACS_Settings_Main_Bool('acs_stamina_settings','acs_stamina_block_action', false) 
		&& GetACSWatcher().StaminaCheck('default')
		)
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");

			return;
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		GetWitcherPlayer().StopEffect('dive_shape');

		GetWitcherPlayer().RemoveTag('ACS_Bruxa_Jump_End');

		if (thePlayer.IsAnyWeaponHeld() 
		&& !thePlayer.IsWeaponHeld('fist')
		&& !thePlayer.HasTag('acs_vampire_claws_equipped')
		&& !thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
			 
			 
			GetACSWatcher().RemoveTimer('CombatTauntDelay');GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondaryWeaponBlood'); 
			GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 , false ); 

			if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
			{
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 , false ); 

				thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
			}
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj');
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}
}

*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////