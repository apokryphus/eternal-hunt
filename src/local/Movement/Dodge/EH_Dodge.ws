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

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		ACS_ThingsThatShouldBeRemoved(true);

		ACS_ExplorationDelayHack();

		DodgePunishment();

		GetWitcherPlayer().ResetUninterruptedHitsCount();

		GetWitcherPlayer().SendAttackReactionEvent();

		ACS_Geralt_Phantom_Destroy();

		//GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

		if ( thePlayer.inv.IsItemCrossbow( thePlayer.inv.GetItemFromSlot( 'l_weapon' ) ) )
		{
			thePlayer.OnRangedForceHolster(false, true, false);
		}

		GetWitcherPlayer().RaiseEvent( 'Dodge' );

		if (ACSGetCEntity('ACS_Bruxa_Camo_Trail'))
		{
			ACSGetCEntity('ACS_Bruxa_Camo_Trail').StopEffect('smoke');
			ACSGetCEntity('ACS_Bruxa_Camo_Trail').PlayEffectSingle('smoke');
		}

		if (ACS_Armor_Equipped_Check())
		{
			thePlayer.SoundEvent( "monster_caretaker_mv_cloth_hard" );

			thePlayer.SoundEvent( "monster_caretaker_mv_footstep" );
		}

		if ( !theSound.SoundIsBankLoaded("monster_dettlaff_monster.bnk") )
		{
			theSound.SoundLoadBank( "monster_dettlaff_monster.bnk", false );
		}
		
		if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
		&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
		)
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");
		}
		else
		{
			if (
			GetWitcherPlayer().HasTag('acs_crossbow_active')
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
					&& ( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
					&& ACS_can_special_dodge())
					{
						ACS_refresh_special_dodge_cooldown();

						WeaponRespawn();

						GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

						bruxa_slide_back();	

						GetACSWatcher().ACS_StaminaDrain(4);
					}
					else
					{
						if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
						&& GetACSWatcher().StaminaCheck()
						)
						{							 
							if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');} if(thePlayer.IsInCombat()){thePlayer.RaiseEvent( 'CombatTaunt' );} thePlayer.SoundEvent("gui_no_stamina");
						}
						else
						{
							WeaponRespawn();

							GetACSWatcher().dodge_timer_attack_actual();

							if (ACS_DefaultGeraltMovesetOverrideModeDodge_Enabled() && !thePlayer.IsWeaponHeld('fist'))
							{
								geralt_moveset_dodge_override_mode();
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
		}
	}

	latent function WeaponRespawn()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}
	}

	latent function DodgeEffects()
	{
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
			GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

			GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
			GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
	}

	latent function DodgePunishment()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 3.5, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() == 1 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (npc.IsHuman())
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0.5 );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0.5 );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0.5 );
				}
				else
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
				}
			}
		}
		else if( actors.Size() > 1 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (npc.IsHuman())
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0.05 );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0.05 );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0.05 );
				}
				else
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0.5 );
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	function ACSDodgeMovementAdjust(direction : CName)
	{
		var movementAdjustorWitcher		: CMovementAdjustor; 
		var ticketWitcher				: SMovementAdjustmentRequestTicket; 

		movementAdjustorWitcher = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

		ticketWitcher = movementAdjustorWitcher.GetRequest( 'ACS_Witcher_Dodge_Rotate');
		movementAdjustorWitcher.CancelByName( 'ACS_Witcher_Dodge_Rotate' );
		movementAdjustorWitcher.CancelAll();
		ticketWitcher = movementAdjustorWitcher.CreateNewRequest( 'ACS_Witcher_Dodge_Rotate' );
		movementAdjustorWitcher.AdjustmentDuration( ticketWitcher, 0.125 );
		movementAdjustorWitcher.MaxRotationAdjustmentSpeed( ticketWitcher, 500000 );

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
		
				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

				bruxa_slide_back();	
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
				
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false) )
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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false) )
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
			ACS_BruxaDodgeBackRightInit();
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			ACS_BruxaDodgeBackLeftInit();	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();
					
				DodgeEffects();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false) )
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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false) )
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
			ACS_BruxaDodgeBackRightInit();

			ACSDodgeMovementAdjust('backleft');
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			ACS_BruxaDodgeBackLeftInit();

			ACSDodgeMovementAdjust('backright');
		}
		else
		{
			ACS_BruxaDodgeBackCenterInit();
		}
	}

	latent function aard_sword_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (ACS_can_special_dodge()
			&& ( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			)
			{
				ACS_refresh_special_dodge_cooldown();
		
				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				bruxa_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function yrden_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function yrden_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function axii_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function axii_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function quen_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_1();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function aard_secondary_sword_dodges()
	{
		WeaponRespawn();

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);	
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_2();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function quen_sword_dodges()
	{
		if ( theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function ignii_sword_dodges()
	{
		WeaponRespawn();

		if (ACS_Zireael_Check())
		{
			ciri_dodges();
		}
		else
		{
			if (ACS_Wolf_School_Check() || ACS_Armor_Omega_Equipped_Check())
			{
				wolf_school_dodges();
			}
			else if (ACS_Bear_School_Check())
			{
				bear_school_dodges();
			}
			else if (ACS_Cat_School_Check() || ACS_Armor_Alpha_Equipped_Check())
			{
				cat_school_dodges();
			}
			else if (ACS_Griffin_School_Check())
			{
				griffin_school_dodges();
			}
			else if (ACS_Manticore_School_Check())
			{
				manticore_school_dodges();
			}
			else if (ACS_Forgotten_Wolf_Check())
			{
				forgotten_wolf_school_dodges();
			}
			else if (ACS_Viper_School_Check())
			{
				viper_school_dodges();
			}
			else
			{
				if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  
				&& ( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
				&& ACS_can_special_dodge())
				{
					ACS_refresh_special_dodge_cooldown();

					WeaponRespawn();

					if (ACS_Armor_Equipped_Check())
					{
						olgierd_slide_back();	
					}
					else
					{
						olgierd_slide_back_2();	
					}

					GetACSWatcher().ACS_StaminaDrain(4);
				}
				else
				{
					WeaponRespawn();

					GetACSWatcher().dodge_timer_attack_actual();

					if (ACS_DefaultGeraltMovesetOverrideModeDodge_Enabled() && !thePlayer.IsWeaponHeld('fist'))
					{
						geralt_moveset_dodge_override_mode();
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
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 0)
					{
						override_mode_back_dodge_1();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 1)
					{
						override_mode_back_dodge_2();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 2)
					{
						override_mode_back_dodge_3();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 3)
					{
						override_mode_back_dodge_4();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 4)
					{
						override_mode_back_dodge_5();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 5)
					{
						override_mode_back_dodge_6();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 6)
					{
						override_mode_back_dodge_7();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 7)
					{
						override_mode_back_dodge_8();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeBackwardDodgeOptions', 0) == 8)
					{
						override_mode_back_dodge_9();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 0)
				{
					override_mode_front_dodge_1();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 1)
				{
					override_mode_front_dodge_2();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 2)
				{
					override_mode_front_dodge_3();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 3)
				{
					override_mode_front_dodge_4();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 4)
				{
					override_mode_front_dodge_5();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 5)
				{
					override_mode_front_dodge_6();
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

				if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 0)
				{
					override_mode_right_dodge_1();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 1)
				{
					override_mode_right_dodge_2();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 2)
				{
					override_mode_right_dodge_3();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 3)
				{
					override_mode_right_dodge_4();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 0)
				{
					override_mode_left_dodge_1();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 1)
				{
					override_mode_left_dodge_2();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 2)
				{
					override_mode_left_dodge_3();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 3)
				{
					override_mode_left_dodge_4();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 0)
				{
					override_mode_right_dodge_1();

					ACSDodgeMovementAdjust('forwardright');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 1)
				{
					override_mode_right_dodge_2();

					ACSDodgeMovementAdjust('forwardright');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 2)
				{
					override_mode_right_dodge_3();

					ACSDodgeMovementAdjust('forwardright');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 3)
				{
					if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 0)
					{
						override_mode_front_dodge_1();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 1)
					{
						override_mode_front_dodge_2();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 2)
					{
						override_mode_front_dodge_3();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 3)
					{
						override_mode_front_dodge_4();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 4)
					{
						override_mode_front_dodge_5();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 5)
					{
						override_mode_front_dodge_6();
					}

					ACSDodgeMovementAdjust('forwardleft');
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 0)
				{
					override_mode_left_dodge_1();

					ACSDodgeMovementAdjust('forwardleft');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 1)
				{
					override_mode_left_dodge_2();

					ACSDodgeMovementAdjust('forwardleft');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 2)
				{
					override_mode_left_dodge_3();

					ACSDodgeMovementAdjust('forwardleft');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 3)
				{
					if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 0)
					{
						override_mode_front_dodge_1();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 1)
					{
						override_mode_front_dodge_2();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 2)
					{
						override_mode_front_dodge_3();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 3)
					{
						override_mode_front_dodge_4();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 4)
					{
						override_mode_front_dodge_5();
					}
					else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeForwardDodgeOptions', 2) == 5)
					{
						override_mode_front_dodge_6();
					}

					ACSDodgeMovementAdjust('forwardright');
				}

				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 0)
				{
					override_mode_right_dodge_1();

					ACSDodgeMovementAdjust('backright');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 1)
				{
					override_mode_right_dodge_2();

					ACSDodgeMovementAdjust('backright');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 2)
				{
					override_mode_right_dodge_3();

					ACSDodgeMovementAdjust('backright');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeRightDodgeOptions', 0) == 3)
				{
					override_mode_right_dodge_4();

					ACSDodgeMovementAdjust('backleft');
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 0)
				{
					override_mode_left_dodge_1();

					ACSDodgeMovementAdjust('backleft');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 1)
				{
					override_mode_left_dodge_2();

					ACSDodgeMovementAdjust('backleft');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 2)
				{
					override_mode_left_dodge_3();

					ACSDodgeMovementAdjust('backleft');
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeLeftDodgeOptions', 0) == 3)
				{
					override_mode_left_dodge_4();

					ACSDodgeMovementAdjust('backright');
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 0)
				{
					override_mode_back_dodge_1();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 1)
				{
					override_mode_back_dodge_2();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 2)
				{
					override_mode_back_dodge_3();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 3)
				{
					override_mode_back_dodge_4();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 4)
				{
					override_mode_back_dodge_5();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 5)
				{
					override_mode_back_dodge_6();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 6)
				{
					override_mode_back_dodge_7();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 7)
				{
					override_mode_back_dodge_8();
				}
				else if (ACS_Settings_Main_Int('EHmodDefaultGeraltMovesetDodgeAndRollOverrideSettings','EHmodDefaultMovesetOverrideModeNeutralDodgeOptions', 0) == 8)
				{
					override_mode_back_dodge_9();
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_back_dodge_1()
	{	
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_1');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_2');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_back_dodge_3()
	{	
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_3');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_4');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_4' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_4' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_lp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_rp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
		else
		{				
			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_lp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_rp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function override_mode_back_dodge_5()
	{	
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_5');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_5' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_5' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_6');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_6' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_6' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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

	latent function override_mode_back_dodge_7()
	{	
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_7');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_7' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_7' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_back_dodge_8()
	{	
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_8');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_8' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_8' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_back_dodge_9()
	{	
		ticket = movementAdjustor.GetRequest( 'override_mode_back_dodge_9');
		
		movementAdjustor.CancelByName( 'override_mode_back_dodge_9' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_back_dodge_9' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_front_dodge_1()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_front_dodge_1');
		
		movementAdjustor.CancelByName( 'override_mode_front_dodge_1' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'override_mode_front_dodge_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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

	latent function override_mode_front_dodge_2()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_front_dodge_2');
		
		movementAdjustor.CancelByName( 'override_mode_front_dodge_2' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'override_mode_front_dodge_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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

	latent function override_mode_front_dodge_3()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_front_dodge_3');
		
		movementAdjustor.CancelByName( 'override_mode_front_dodge_3' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'override_mode_front_dodge_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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
		ticket = movementAdjustor.GetRequest( 'override_mode_front_dodge_4');
		
		movementAdjustor.CancelByName( 'override_mode_front_dodge_4' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'override_mode_front_dodge_4' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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

	latent function override_mode_front_dodge_5()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_front_dodge_5');
		
		movementAdjustor.CancelByName( 'override_mode_front_dodge_5' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'override_mode_front_dodge_5' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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
		ticket = movementAdjustor.GetRequest( 'override_mode_front_dodge_6');
		
		movementAdjustor.CancelByName( 'override_mode_front_dodge_6' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'override_mode_front_dodge_6' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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
	
	latent function override_mode_right_dodge_1()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_right_dodge_1');
		
		movementAdjustor.CancelByName( 'override_mode_right_dodge_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_right_dodge_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_right_dodge_2()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_right_dodge_2');
		
		movementAdjustor.CancelByName( 'override_mode_right_dodge_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_right_dodge_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_right_dodge_3()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_right_dodge_3');
		
		movementAdjustor.CancelByName( 'override_mode_right_dodge_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_right_dodge_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_right_dodge_4()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_right_dodge_4');
		
		movementAdjustor.CancelByName( 'override_mode_right_dodge_4' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_right_dodge_4' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_left_dodge_1()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_left_dodge_1');
		
		movementAdjustor.CancelByName( 'override_mode_left_dodge_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_left_dodge_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_left_dodge_2()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_left_dodge_2');
		
		movementAdjustor.CancelByName( 'override_mode_left_dodge_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_left_dodge_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_left_dodge_3()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_left_dodge_3');
		
		movementAdjustor.CancelByName( 'override_mode_left_dodge_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_left_dodge_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_left_dodge_4()
	{
		ticket = movementAdjustor.GetRequest( 'override_mode_left_dodge_4');
		
		movementAdjustor.CancelByName( 'override_mode_left_dodge_4' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'override_mode_left_dodge_4' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function wolf_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function bear_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				two_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function cat_school_dodges()
	{
		if ( theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function griffin_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function manticore_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function forgotten_wolf_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	latent function viper_school_dodges()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				one_hand_sword_back_dodge_alt_3();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
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
			if (( ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodWildHuntBlink', false) 
							|| ACS_GetItem_MageStaff() 
							|| ACS_Armor_Equipped_Check()
							|| ACS_WH_Armor_Equipped_Check()
							|| ACS_Eredin_Armor_Equipped_Check()
							|| ACS_Imlerith_Armor_Equipped_Check()
							|| ACS_Caranthir_Armor_Equipped_Check()
							|| ACS_VGX_Eredin_Armor_Equipped_Check()
							|| thePlayer.HasTag('acs_vampire_claws_equipped')
							)
			&& ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeBack();

				if (ACS_Armor_Equipped_Check())
				{
					olgierd_slide_back();	
				}
				else
				{
					olgierd_slide_back_2();	
				}
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
			else if (ACS_can_dodge())
			{
				if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					DodgeEffects();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeBack();

					one_hand_sword_back_dodge_alt_3_long();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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

				GetACSWatcher().CiriSpectreDodgeFront();

				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1_long();
				}
				else
				{
					one_hand_sword_front_dodge_long();
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

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeRight();

				one_hand_sword_right_dodge_alt_4_long();
				
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

				GetACSWatcher().CiriSpectreDodgeLeft();

				one_hand_sword_left_dodge_alt_4_long();
				
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

				GetACSWatcher().CiriSpectreDodgeRight();

				one_hand_sword_right_dodge_alt_4_long();

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

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeLeft();

				one_hand_sword_left_dodge_alt_4_long();

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

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeRight();

				one_hand_sword_right_dodge_alt_4_long();

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

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeLeft();

				one_hand_sword_left_dodge_alt_4_long();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				DodgeEffects();

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetACSWatcher().CiriSpectreDodgeBack();

				one_hand_sword_back_dodge_alt_3_long();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function bruxa_slide_back()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_slide_back');
		
		movementAdjustor.CancelByName( 'bruxa_slide_back' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_slide_back' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if( targetDistance <= 2*2 ) 
			{
				ACS_BruxaDodgeBackCenterInit();
			}
			else
			{
				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
				&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
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

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
				if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 2  ); }	
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				
				movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2.25 ) + theCamera.GetCameraDirection() * -2.25) );		
			}

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
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

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 2  ); }	
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_slide_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			
			movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2.25 ) + theCamera.GetCameraDirection() * -2.25) );
		}

		//Sleep(1);
		
		//GetWitcherPlayer().SetIsCurrentlyDodging(false);
	}

	latent function olgierd_slide_back()
	{
		if (ACS_Armor_Equipped_Check())
		{
			olgierd_slide_back_actual();	
		}
		else
		{
			if (ACS_GetWeaponMode() == 3)
			{
				if (ACS_GetItem_Iris())
				{
					olgierd_slide_back_actual();
				}
				else
				{
					olgierd_slide_back_2();
				}
			}
			else
			{
				olgierd_slide_back_actual();
			}
		}
	}

	latent function olgierd_slide_back_actual()
	{	
		ticket = movementAdjustor.GetRequest( 'olgierd_slide_back');
		
		movementAdjustor.CancelByName( 'olgierd_slide_back' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'olgierd_slide_back' );
		
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
				&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
				{
					GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
					GetWitcherPlayer().StopEffect('special_attack_fx');

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
				if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
				movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis((GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.5) + theCamera.GetCameraDirection() * -1.5) );
			}
			else
			{
				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
				&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
				{
					GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
					GetWitcherPlayer().StopEffect('special_attack_fx');

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}
						
				GetACSWatcher().dodge_timer_attack_actual();

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
				if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
					
				GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_igni_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
				movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3 );		
			}

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
			{
				GetWitcherPlayer().PlayEffectSingle('special_attack_fx');
				GetWitcherPlayer().StopEffect('special_attack_fx');

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_igni_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );
		}

		if (!GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
		{
			GetWitcherPlayer().AddTag('ACS_Special_Dodge');
		}
	}

	latent function olgierd_slide_back_2()
	{	
		ticket = movementAdjustor.GetRequest( 'olgierd_slide_back_2');
		
		movementAdjustor.CancelByName( 'olgierd_slide_back_2' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'olgierd_slide_back_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();
		
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );		
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
					
			GetACSWatcher().dodge_timer_attack_actual();

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();
			
			if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5  ); }
					
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'full_hit_reaction_with_taunt_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() * -3) );
		}
	}

	latent function bruxa_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_front_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_front_dodge' );
		
		movementAdjustor.CancelAll();

		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );
		}
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_front_dodge' );
		
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
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );			
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		
		}
	}

	latent function bruxa_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'bruxa_right_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_right_dodge' );
		
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
		ticket = movementAdjustor.GetRequest( 'bruxa_left_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}

	latent function bruxa_regular_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_regular_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_regular_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_regular_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_back_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'two_hand_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_front_dodge' );
		
		movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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
		ticket = movementAdjustor.GetRequest( 'two_hand_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'two_hand_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_left_dodge' );
		
		movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		/*	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);

		GetACSWatcher().ACS_StaminaDrain(4);
	}

	latent function two_hand_sword_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_l_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function two_hand_sword_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_r_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_long' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 3) );

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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

	latent function one_hand_sword_front_dodge_alt_1_long()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_1_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_1_long' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_1_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 3) );
		
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

	latent function one_hand_sword_left_dodge_alt_1()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_2()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

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

	latent function one_hand_sword_back_dodge_alt_3_long()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_3_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_3_long' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_3_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -3) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_front_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_left_dodge_alt_4()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_4');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_4' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_4' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_4');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_4' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_4' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_left_dodge_alt_4_short()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_4_short');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_4_short' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_4_short' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4_short()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_4_short');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_4_short' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_4_short' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_left_dodge_alt_4_long()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_4_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_4_long' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_4_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -3) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4_long()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_4_long');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_4_long' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_4_long' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 3 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 3) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function cat_one_hand_sword_back_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'cat_one_hand_sword_back_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'cat_one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'cat_one_hand_sword_back_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25  , false);	

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
		ticket = movementAdjustor.GetRequest( 'cat_one_hand_sword_front_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'cat_one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'cat_one_hand_sword_front_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25  , false);
		
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
		ticket = movementAdjustor.GetRequest( 'cat_one_hand_sword_left_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'cat_one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'cat_one_hand_sword_left_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25  , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function cat_one_hand_sword_right_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'cat_one_hand_sword_right_dodge_alt_3');
		
		movementAdjustor.CancelByName( 'cat_one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'cat_one_hand_sword_right_dodge_alt_3' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25  , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_BruxaDodgeSlideBackInitForWeaponSwitching()
{
	var vBruxaDodgeSlideBackInitForWeaponSwitching : cBruxaDodgeSlideBackInitForWeaponSwitching;
	vBruxaDodgeSlideBackInitForWeaponSwitching = new cBruxaDodgeSlideBackInitForWeaponSwitching in theGame;
	
	if ( ACS_Enabled() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('acs_in_wraith')
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
		&& ACS_BuffCheck()
		&& GetWitcherPlayer().IsActionAllowed(EIAB_Dodge)
		&& !GetWitcherPlayer().IsInAir()
		&& GetWitcherPlayer().IsActionAllowed(EIAB_Movement)
		&& GetWitcherPlayer().IsActionAllowed(EIAB_LightAttacks)
		&& !ACS_Transformation_Activated_Check()
		&& !GetWitcherPlayer().IsCrossbowHeld() 
		&& !GetWitcherPlayer().IsInHitAnim() 
		)
		{
			vBruxaDodgeSlideBackInitForWeaponSwitching.BruxaDodgeSlideBackInitForWeaponSwitching_Engage();
		}
	}
}

statemachine class cBruxaDodgeSlideBackInitForWeaponSwitching
{
    function BruxaDodgeSlideBackInitForWeaponSwitching_Engage()
	{
		this.PushState('BruxaDodgeSlideBackInitForWeaponSwitching_Engage');
	}
}

state BruxaDodgeSlideBackInitForWeaponSwitching_Engage in cBruxaDodgeSlideBackInitForWeaponSwitching
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

	function ACSDodgeMovementAdjust(direction : CName)
	{
		var movementAdjustorWitcher		: CMovementAdjustor; 
		var ticketWitcher				: SMovementAdjustmentRequestTicket; 

		movementAdjustorWitcher = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

		ticketWitcher = movementAdjustorWitcher.GetRequest( 'ACS_Witcher_Dodge_Rotate');
		movementAdjustorWitcher.CancelByName( 'ACS_Witcher_Dodge_Rotate' );
		movementAdjustorWitcher.CancelAll();
		ticketWitcher = movementAdjustorWitcher.CreateNewRequest( 'ACS_Witcher_Dodge_Rotate' );
		movementAdjustorWitcher.AdjustmentDuration( ticketWitcher, 0.125 );
		movementAdjustorWitcher.MaxRotationAdjustmentSpeed( ticketWitcher, 500000 );

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

			case '180forwardright':
			movementAdjustorWitcher.RotateTo( ticketWitcher, VecHeading( (theCamera.GetCameraDirection() * -15) + (theCamera.GetCameraRight() * 5) ) );
			break;

			case '180forwardleft':
			movementAdjustorWitcher.RotateTo( ticketWitcher, VecHeading( (theCamera.GetCameraDirection() * -15) + (theCamera.GetCameraRight() * -5) ) );
			break;

			default:
			movementAdjustorWitcher.CancelAll();
			break;
		}
	}
	
	entry function BruxaDodgeSlideBack()
	{
		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
				
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
		{
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		}	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Dodge_On_Change_Beh_Movement_Adjust' );
			
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );

		movementAdjustor.ShouldStartAt(ticket, GetWitcherPlayer().GetWorldPosition());
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTowards( ticket, actor );
		}
		
		if (GetWitcherPlayer().HasTag('acs_aard_sword_equipped'))
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
			&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
				GetWitcherPlayer().StopEffect( 'shadowdash_short' );
			}

			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				bruxa_regular_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				bruxa_front_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				bruxa_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				bruxa_left_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				bruxa_front_dodge();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				bruxa_front_dodge();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				bruxa_right_dodge();

				ACSDodgeMovementAdjust('backleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				bruxa_left_dodge();

				ACSDodgeMovementAdjust('backright');
			}
			else
			{
				bruxa_regular_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				two_hand_back_dodge();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				one_hand_sword_front_dodge_alt_2();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				two_hand_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				two_hand_left_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_front_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				one_hand_sword_front_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				two_hand_right_dodge();

				ACSDodgeMovementAdjust('backleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				two_hand_left_dodge();

				ACSDodgeMovementAdjust('backright');
			}
			else
			{
				two_hand_back_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				two_hand_back_dodge();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				two_hand_front_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				one_hand_sword_right_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				one_hand_sword_left_dodge_alt_2();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge_alt_1();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge_alt_1();

				ACSDodgeMovementAdjust('backright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('backleft');
			}
			else
			{
				two_hand_back_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				one_hand_sword_back_dodge_alt_1();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				if (RandF() < 0.5)
				{
					one_hand_sword_front_dodge_alt_1();
				}
				else
				{
					one_hand_sword_front_dodge();
				}
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				one_hand_sword_right_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				one_hand_sword_left_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge_alt_1();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				one_hand_sword_left_dodge_alt_1();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge_alt_1();

				ACSDodgeMovementAdjust('backright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				one_hand_sword_left_dodge_alt_1();

				ACSDodgeMovementAdjust('backleft');
			}
			else
			{
				one_hand_sword_back_dodge_alt_1();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				one_hand_sword_back_dodge_alt_2();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				one_hand_sword_front_dodge_alt_2();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				one_hand_sword_right_dodge_alt_2();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				one_hand_sword_left_dodge_alt_2();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge_alt_2();

				ACSDodgeMovementAdjust('backright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				one_hand_sword_left_dodge_alt_2();

				ACSDodgeMovementAdjust('backleft');
			}
			else
			{
				one_hand_sword_back_dodge_alt_2();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				two_hand_sword_back_dodge();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				two_hand_sword_front_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				two_hand_sword_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				two_hand_sword_left_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				two_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				two_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				two_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('backright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				two_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('backleft');
			}
			else
			{
				two_hand_sword_back_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_axii_sword_equipped')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				one_hand_sword_back_dodge();		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				one_hand_sword_front_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				one_hand_sword_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				one_hand_sword_left_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				one_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('backright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				one_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('backleft');
			}
			else
			{
				one_hand_sword_back_dodge();
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_quen_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_igni_sword_equipped_TAG')
		|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped_TAG')
		)
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				one_hand_sword_back_dodge();		
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				one_hand_sword_front_dodge_alt_1();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				one_hand_sword_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				one_hand_sword_left_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				one_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				one_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('backright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				one_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('backleft');
			}
			else
			{
				one_hand_sword_back_dodge();
			}
		}
		else
		{
			if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
			{
				two_hand_sword_back_dodge();	
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
			{
				two_hand_sword_front_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
			{
				two_hand_sword_right_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
			{
				two_hand_sword_left_dodge();
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				two_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('forwardright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
			{
				two_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('forwardleft');
			}
			else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
			{
				two_hand_sword_right_dodge();

				ACSDodgeMovementAdjust('backright');
			}
			else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
			{
				two_hand_sword_left_dodge();

				ACSDodgeMovementAdjust('backleft');
			}
			else
			{
				two_hand_sword_back_dodge();
			}
		}
	}

	latent function bruxa_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_front_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_front_dodge' );
		
		movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function bruxa_right_dodge()
	{		
		ticket = movementAdjustor.GetRequest( 'bruxa_right_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_right_dodge' );
		
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

	latent function bruxa_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_left_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_left_dodge' );
		
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

	latent function bruxa_regular_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_regular_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_regular_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_regular_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}


	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_back_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

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
		ticket = movementAdjustor.GetRequest( 'two_hand_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_front_dodge' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
		
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
		ticket = movementAdjustor.GetRequest( 'two_hand_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

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
		ticket = movementAdjustor.GetRequest( 'two_hand_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

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
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 2*2 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_b_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function two_hand_sword_front_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
									
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
					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
					else
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
					}
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			if( RandF() < 0.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
				}
			}
		}
	}

	latent function two_hand_sword_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_l_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function two_hand_sword_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'two_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'two_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_r_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		/*
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 180, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_right_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_flip_left_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_jump_rp_f_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		Sleep(0.0625);

		GetWitcherPlayer().EvadePressed(EBAT_Dodge);

		GetACSWatcher().ACS_StaminaDrain(4);
	}

	latent function one_hand_sword_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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

	latent function one_hand_sword_left_dodge_alt_1()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
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
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_1');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_1' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if( targetDistance <= 3*3 ) 
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
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_03', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_back_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_back_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1) );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_left_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_left_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_2()
	{	
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_right_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_right_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_BruxaDodgeBackCenterInit()
{
	var vBruxaDodgeBackCenter : cBruxaDodgeBackCenter;

	if (ACS_New_Replacers_Female_Active())
	{
		GetWitcherPlayer().EvadePressed(EBAT_Dodge);
		GetACSWatcher().ACS_StaminaDrain(4);
		return;
	}

	vBruxaDodgeBackCenter = new cBruxaDodgeBackCenter in theGame;
	
	if ( ACS_Enabled() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('acs_in_wraith')
		&& ACS_BuffCheck()
		)
		{	
			if (!GetWitcherPlayer().HasTag('acs_blood_sucking') && GetWitcherPlayer().IsActionAllowed(EIAB_Dodge) )
			{
				if (ACS_can_dodge())
				{
					if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
					&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						GetWitcherPlayer().SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						ACS_ThingsThatShouldBeRemoved(true);

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackCenter.BruxaDodgeBackCenter_Engage();
						
						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
				/*
				else
				{
					if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
					&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						GetWitcherPlayer().SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_ThingsThatShouldBeRemoved(true);

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackCenter.BruxaRegularDodgeBack_Engage();
						
						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
				*/
			}
			else if ( GetWitcherPlayer().HasTag('acs_blood_sucking') 
			//&& ACS_Hijack_Enabled() 
			)
			{
				vBruxaDodgeBackCenter.BruxaDodgeBackCenter_HijackBack();
			}
		}
	}
	else
	{
		GetWitcherPlayer().EvadePressed(EBAT_Dodge);

		GetACSWatcher().ACS_StaminaDrain(4);
	}
}

statemachine class cBruxaDodgeBackCenter
{
    function BruxaDodgeBackCenter_Engage()
	{
		this.PushState('BruxaDodgeBackCenter_Engage');
	}

	function BruxaDodgeBackCenter_HijackBack()
	{
		this.PushState('BruxaDodgeBackCenter_HijackBack');
	}

	function BruxaRegularDodgeBack_Engage()
	{
		this.PushState('BruxaRegularDodgeBack_Engage');
	}
}

state BruxaRegularDodgeBack_Engage in cBruxaDodgeBackCenter
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

		bruxa_regular_dodge();	
	}

	latent function bruxa_regular_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'bruxa_regular_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_regular_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_regular_dodge' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 1.25 ) + theCamera.GetCameraDirection() * 1.25 );		

			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}
}

state BruxaDodgeBackCenter_HijackBack in cBruxaDodgeBackCenter
{
	private var i 						: int;
	private var npc     				: CNewNPC;
	private var actors					: array< CActor >;
	private var animatedComponent 		: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		HijackBackEntry();
	}

	entry function HijackBackEntry()
	{
		//actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

		actors.Clear();
		
		theGame.GetActorsByTag( 'bruxa_bite_victim', actors );

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
				
			animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
				
			if( actors.Size() > 0 )
			{	
				/*
				((CNewNPC)npc).SetUnstoppable(true);

				npc.RemoveBuffImmunity_AllNegative();

				npc.RemoveBuffImmunity_AllCritical();

				npc.ClearAnimationSpeedMultipliers();
				
				if (npc.HasAbility('mon_gryphon_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_d', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_fall_stop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else if (npc.HasAbility('mon_siren_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_d', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_knockdown_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else if (npc.HasAbility('mon_wyvern_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_knockdown_fall', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else if (npc.HasAbility('mon_harpy_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_d', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_death_fly_high_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else if (npc.HasAbility('mon_draco_base'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_knockdown_fall', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}	
				else if (npc.HasAbility('mon_basilisk'))
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_d', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_fall_stop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else if (npc.HasAbility('mon_garkain'))
				{
					animatedComponent.PlaySlotAnimationAsync ( 'monster_katakan_jump_up_aoe_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else if (npc.HasAbility('mon_sharley_base'))
				{
					animatedComponent.PlaySlotAnimationAsync ( 'roll_back_from_idle_to_idle', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				
				npc.ClearAnimationSpeedMultipliers();
				*/

				npc.ClearAnimationSpeedMultipliers();

				if (npc.IsFlying())
				{
					((CNewNPC)npc).SetUnstoppable(false);

					if( !npc.HasBuff( EET_HeavyKnockdown ) )
					{
						npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );	
					}
				}
				else
				{
					if (npc.HasAbility('mon_garkain'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_katakan_jump_back', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					}
					else if (npc.HasAbility('mon_sharley_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'roll_back_from_idle_to_idle', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					}
					else if (npc.HasAbility('mon_bies_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_dodge_b', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					}
					else if (npc.HasAbility('mon_golem_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_idle_to_walk_r180', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					}
					else if (
					npc.HasAbility('mon_endriaga_base')
					|| npc.HasAbility('mon_arachas_base')
					|| npc.HasAbility('mon_kikimore_base')
					|| npc.HasAbility('mon_black_spider_base')
					|| npc.HasAbility('mon_black_spider_ep2_base')
					)
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_b', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					}
					else if (
					npc.HasAbility('mon_ice_giant')
					|| npc.HasAbility('mon_cyclops')
					|| npc.HasAbility('mon_knight_giant')
					|| npc.HasAbility('mon_cloud_giant')
					)
					{
						animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_taunt_2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
					}
					else if (npc.HasAbility('mon_troll_base'))
					{
						if( RandF() < 0.5 ) 
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_turn_r_180', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_turn_l_180', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
				}
				
				npc.ClearAnimationSpeedMultipliers();
			}
		}
	}
}

state BruxaDodgeBackCenter_Engage in cBruxaDodgeBackCenter
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
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();
	
		dodge_back_center();	
	}
	
	latent function dodge_back_center ()
	{		
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
		
		ticket = movementAdjustor.GetRequest( 'dodge_back_center');
		
		movementAdjustor.CancelByName( 'dodge_back_center' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'dodge_back_center' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 10 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -2) );

		/*
		
		if( actor.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.25 ) + theCamera.GetCameraDirection() * -1.25 );
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.25 ) + theCamera.GetCameraDirection() * -1.25 );
		}
		
		Sleep(1);
		
		GetWitcherPlayer().SetIsCurrentlyDodging(false);

		*/
	}
}

function ACS_BruxaDodgeBackLeftInit()
{
	var vBruxaDodgeBackLeft : cBruxaDodgeBackLeft;
	vBruxaDodgeBackLeft = new cBruxaDodgeBackLeft in theGame;

	if (ACS_New_Replacers_Female_Active())
	{
		GetWitcherPlayer().EvadePressed(EBAT_Dodge);
		GetACSWatcher().ACS_StaminaDrain(4);
		return;
	}
	
	if ( ACS_Enabled() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('acs_in_wraith')
		&& ACS_BuffCheck()
		)
		{
			if (!GetWitcherPlayer().HasTag('acs_blood_sucking') && GetWitcherPlayer().IsActionAllowed(EIAB_Dodge) )
			{
				if (ACS_can_dodge())
				{
					if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
					&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						GetWitcherPlayer().SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();	

						ACS_ThingsThatShouldBeRemoved(true);

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackLeft.BruxaDodgeBackLeft_Engage();
						
						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
				/*
				else
				{
					if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
					&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						GetWitcherPlayer().SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();	

						ACS_ThingsThatShouldBeRemoved(true);

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackLeft.BruxaRegularDodgeLeft_Engage();
						
						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
				*/
			}
			else if ( GetWitcherPlayer().HasTag('acs_blood_sucking') 
			//&& ACS_Hijack_Enabled() 
			)
			{
				vBruxaDodgeBackLeft.BruxaDodgeBackLeft_HijackLeft();
			}
		}
	}
	else
	{
		GetWitcherPlayer().EvadePressed(EBAT_Dodge);

		GetACSWatcher().ACS_StaminaDrain(4);
	}
}

statemachine class cBruxaDodgeBackLeft
{
    function BruxaDodgeBackLeft_Engage()
	{
		this.PushState('BruxaDodgeBackLeft_Engage');
	}

	function BruxaDodgeBackLeft_HijackLeft()
	{
		this.PushState('BruxaDodgeBackLeft_HijackLeft');
	}

	function BruxaRegularDodgeLeft_Engage()
	{
		this.PushState('BruxaRegularDodgeLeft_Engage');
	}
}

state BruxaRegularDodgeLeft_Engage in cBruxaDodgeBackLeft
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

		bruxa_regular_dodge();	
	}

	latent function bruxa_regular_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'bruxa_left_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_left_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_left_dodge' );
		
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

state BruxaDodgeBackLeft_HijackLeft in cBruxaDodgeBackLeft
{
	private var i 						: int;
	private var npc     				: CNewNPC;
	private var actors					: array< CActor >;
	private var animatedComponent 		: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		HijackLeftEntry();
	}

	entry function HijackLeftEntry()
	{
		actors.Clear();
		
		actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
				
			animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
					
			if( actors.Size() > 0 )
			{	
				npc.ClearAnimationSpeedMultipliers();

				if (npc.IsFlying())
				{
					((CNewNPC)npc).SetUnstoppable(true);

					npc.RemoveBuffImmunity_AllNegative();

					npc.RemoveBuffImmunity_AllCritical();

					if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_ul_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_ul', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_ul_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_ul_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dl_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_dl', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_dl_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dl_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_l_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_l_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_l_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
				}
				else
				{
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_arachas_move_strafe_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'walk_left_fast', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_arachas_move_strafe_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
				}

				npc.ClearAnimationSpeedMultipliers();
			}
		}
	}
}

state BruxaDodgeBackLeft_Engage in cBruxaDodgeBackLeft
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
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();
	
		dodge_back_left();	
	}
	
	latent function dodge_back_left ()
	{	
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() + ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'dodge_back_left');
		
		movementAdjustor.CancelByName( 'dodge_back_left' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'dodge_back_left' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 ) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

		movementAdjustor.SlideTo( ticket, TraceFloor( ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 ) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -2 ) );
		
		//if( actor.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && actor.IsAlive() )
		//{	
			//movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
				
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );

			//movementAdjustor.RotateTowards( ticket, actor );
		//}
		//else
		//{
			//movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );

			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		//}
		
		//Sleep(1);
		
		//GetWitcherPlayer().SetIsCurrentlyDodging(false);
	}
}

function ACS_BruxaDodgeBackRightInit()
{
	var vBruxaDodgeBackRight : cBruxaDodgeBackRight;
	vBruxaDodgeBackRight = new cBruxaDodgeBackRight in theGame;

	if (ACS_New_Replacers_Female_Active())
	{
		GetWitcherPlayer().EvadePressed(EBAT_Dodge);
		GetACSWatcher().ACS_StaminaDrain(4);
		return;
	}
	
	if ( ACS_Enabled() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('acs_in_wraith')
		&& ACS_BuffCheck()
		)
		{
			if (!GetWitcherPlayer().HasTag('acs_blood_sucking') && GetWitcherPlayer().IsActionAllowed(EIAB_Dodge) )
			{
				if (ACS_can_dodge())
				{
					if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
					&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						GetWitcherPlayer().SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						ACS_ThingsThatShouldBeRemoved(true);

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackRight.BruxaDodgeBackRight_Engage();

						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
				/*
				else
				{
					if ( ACS_Settings_Main_Bool('EHmodStaminaSettings','EHmodStaminaBlockAction', true) 
					&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
					)
					{
						GetWitcherPlayer().SoundEvent("gui_no_stamina");
					}
					else
					{
						ACS_refresh_dodge_cooldown();

						ACS_ThingsThatShouldBeRemoved(true);

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();

						ACS_ExplorationDelayHack();

						vBruxaDodgeBackRight.BruxaRegularDodgeRight_Engage();

						GetACSWatcher().ACS_StaminaDrain(4);
					}
				}
				*/
			}
			else if ( GetWitcherPlayer().HasTag('acs_blood_sucking') 
			//&& ACS_Hijack_Enabled() 
			)
			{
				vBruxaDodgeBackRight.BruxaDodgeBackRight_HijackRight();
			}
		}
	}
	else
	{
		GetWitcherPlayer().EvadePressed(EBAT_Dodge);

		GetACSWatcher().ACS_StaminaDrain(4);
	}
}

statemachine class cBruxaDodgeBackRight
{
    function BruxaDodgeBackRight_Engage()
	{
		this.PushState('BruxaDodgeBackRight_Engage');
	}

	function BruxaDodgeBackRight_HijackRight()
	{
		this.PushState('BruxaDodgeBackRight_HijackRight');
	}

	function BruxaRegularDodgeRight_Engage()
	{
		this.PushState('BruxaRegularDodgeRight_Engage');
	}
}

state BruxaRegularDodgeRight_Engage in cBruxaDodgeBackRight
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

		bruxa_regular_dodge();	
	}

	latent function bruxa_regular_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'bruxa_right_dodge');
		
		movementAdjustor.CancelByName( 'bruxa_right_dodge' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_right_dodge' );
		
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

state BruxaDodgeBackRight_HijackRight in cBruxaDodgeBackRight
{
	private var i 						: int;
	private var npc     				: CNewNPC;
	private var actors					: array< CActor >;
	private var animatedComponent 		: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		HijackRightEntry();
	}
	
	entry function HijackRightEntry()
	{
		actors.Clear();
		
		actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
				
			animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
	
			if( actors.Size() > 0 )
			{
				npc.ClearAnimationSpeedMultipliers();

				if (npc.IsFlying())
				{	
					((CNewNPC)npc).SetUnstoppable(true);

					npc.RemoveBuffImmunity_AllNegative();

					npc.RemoveBuffImmunity_AllCritical();

					if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_ur_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_ur', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_ur_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_ur_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dr_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_dr', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_dr_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dr_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else
					{
						if (npc.HasAbility('mon_gryphon_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_r_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_siren_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_wyvern_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_harpy_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_r_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_draco_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_basilisk'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_r_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
				}
				else
				{
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'walk_right_fast', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
					else
					{
						if (npc.HasAbility('mon_garkain'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_sharley_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_bies_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_golem_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_endriaga_base')
						|| npc.HasAbility('mon_arachas_base')
						|| npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_arachas_move_strafe_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (
						npc.HasAbility('mon_ice_giant')
						|| npc.HasAbility('mon_cyclops')
						|| npc.HasAbility('mon_knight_giant')
						|| npc.HasAbility('mon_cloud_giant')
						)
						{
							animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
						else if (npc.HasAbility('mon_troll_base'))
						{
							animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
						}
					}
				}
					
				npc.ClearAnimationSpeedMultipliers();
			}
		}
	}
}

state BruxaDodgeBackRight_Engage in cBruxaDodgeBackRight
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
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& ACS_Settings_Main_Bool('EHmodDodgeSettings','EHmodDodgeEffects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
			GetWitcherPlayer().StopEffect( 'shadowdash_short' );

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
		}
					
		GetACSWatcher().dodge_timer_actual();
	
		dodge_back_right();	
	}
	
	latent function dodge_back_right ()
	{		
		dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() + ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'dodge_back_right');
		
		movementAdjustor.CancelByName( 'dodge_back_right' );
		
		movementAdjustor.CancelAll();
		
		GetWitcherPlayer().ActionCancelAll();

		GetWitcherPlayer().GetMovingAgentComponent().ResetMoveRequests();

		GetWitcherPlayer().GetMovingAgentComponent().SetGameplayMoveDirection(0.0f);

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'dodge_back_right' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 ) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

		movementAdjustor.SlideTo( ticket, TraceFloor(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1) );

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 2 ) );

		/*
		
		if( actor.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );
			
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5 );

			//movementAdjustor.RotateTowards( ticket, actor );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, theCamera.GetCameraHeading() );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_dodge_back_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 )  + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5 );
		}
		
		Sleep(1);
		
		GetWitcherPlayer().SetIsCurrentlyDodging(false);
		*/
	}
}