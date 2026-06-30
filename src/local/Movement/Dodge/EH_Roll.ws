statemachine class cWildHuntBlink
{	
    function WildHuntBlink_Engage()
	{
		this.PushState('WildHuntBlink_Engage');
	}
}
 
state WildHuntBlink_Engage in cWildHuntBlink
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
	private var dodge_counter_roll						: int;
		
	event OnEnterState(prevStateName : name)
	{
		WildHuntBlink();
	}
	
	entry function WildHuntBlink()
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

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
		
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

		if (((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'wood_hollow'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'wood_debris'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_hard'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_soil'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'hay'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'stone_debris'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'stone_solid'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'clay_tile'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_large'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_small'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'sand'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'water_shallow'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'water_deep'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_short'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_long'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'carpet'
		)
		{

			thePlayer.StopEffect('jump_ground_fx1');
			thePlayer.PlayEffect('jump_ground_fx1');

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
		}

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	

		ACS_ThingsThatShouldBeRemoved();
		
		ACS_ExplorationDelayHack(false, 3);

		thePlayer.ACS_DealPlayerPostureDamage(5, false);

		if (ACS_Settings_Main_Bool('acs_movement_main_settings','acs_walking_by_default_enabled', true))
		{
			thePlayer.SetWalkToggle( true );	
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
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 / theGame.GetTimeScale(), false ); 

				if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
				{
					GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 / theGame.GetTimeScale(), false ); 

					thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
				}
			}
		}

		ACSGetCActorDestroyAll('ACS_Geralt_Phantom');

		if ( thePlayer.IsCrossbowHeld() ) 
		{
			thePlayer.OnRangedForceHolster( false, true );
		}

		GetWitcherPlayer().ResetUninterruptedHitsCount();

		//GetWitcherPlayer().SendAttackReactionEvent();

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

		
		if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped')
		|| GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_sorc_fists_equipped')
		|| ACS_Vampire_Claws_Access()
		)
		{
			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
			
				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

				bruxa_jump_up();	
				
				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );	
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
		)
		{
			TeleportWeaponSpawn();

			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				if (ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				)
				{
					wild_hunt_blink();
				}
				else
				{
					mage_teleport();
				}

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			TeleportWeaponSpawn();

			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				if (ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				)
				{
					wild_hunt_blink();
				}
				else
				{
					lightning_teleport();
				}	

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			TeleportWeaponSpawn();

			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				if (ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				)
				{
					wild_hunt_blink();
				}
				else
				{
					fountain_portal_teleport();	
				}

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			TeleportWeaponSpawn();

			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				if (ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				)
				{
					wild_hunt_blink();
				}
				else
				{
					explosion_teleport();	
				}

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			TeleportWeaponSpawn();

			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				)
				{
					wild_hunt_blink();
				}
				else
				{
					dolphin_teleport();	
				}

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_quen_sword_equipped')
		)
		{
			TeleportWeaponSpawn();

			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();

				if (ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				)
				{
					wild_hunt_blink();
				}
				else
				{
					iris_teleport();	
				}

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			TeleportWeaponSpawn();

			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
				
				if (ACS_Armor_Set_Check('acs_armor', false)
				|| ACS_Armor_Set_Check('wh_armor', false)
				|| ACS_Armor_Set_Check('eredin_armor', false)
				|| ACS_Armor_Set_Check('imlerith_armor', false)
				|| ACS_Armor_Set_Check('caranthir_armor', false)
				|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
				)
				{
					wild_hunt_blink();
				}
				else
				{
					if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped')
					|| GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_sorc_fists_equipped')
					|| ACS_Vampire_Claws_Access()
					)
					{
						if (ACS_can_special_dodge())
						{
							ACS_refresh_special_dodge_cooldown();
						
							GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_movement_whoosh_large");

							bruxa_jump_up();	
							
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );	
						}
					}
					else
					{
						fire_blink();	
					}	
				}

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );
			}
		}
		else if (
		GetWitcherPlayer().HasTag('acs_axii_sword_equipped')
		)
		{
			TeleportWeaponSpawn();

			if (ACS_can_special_dodge())
			{
				ACS_refresh_special_dodge_cooldown();
					
				wild_hunt_blink();	

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue,  GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.5, 1 );
			}
		}
	}

	latent function TeleportWeaponSpawn()
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

	function TeleportBlockAction()
	{
		GetWitcherPlayer().BlockAction( EIAB_Crossbow, 				'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_CallHorse,				'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_Signs, 				'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_DrawWeapon, 			'ACS_Teleport_Dodge'); 
		GetWitcherPlayer().BlockAction( EIAB_FastTravel, 			'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_Fists, 				'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_InteractionAction, 	'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_UsableItem,			'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_ThrowBomb,				'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_SwordAttack,			'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_Jump,					'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_LightAttacks,			'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_HeavyAttacks,			'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_SpecialAttackLight,	'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_SpecialAttackHeavy,	'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_Dodge,					'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_Roll,					'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_Parry,					'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,		'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'ACS_Teleport_Dodge');
		GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'ACS_Teleport_Dodge');
	}

	latent function ACS_Armor_Quen()
	{
		var newQuen						: W3QuenEntity;
		var signOwner					: W3SignOwnerPlayer;


		signOwner = new W3SignOwnerPlayer in this;
		signOwner.Init( GetWitcherPlayer() );
		
		newQuen = (W3QuenEntity)theGame.CreateEntity( GetWitcherPlayer().GetSignTemplate( ST_Quen ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );
		newQuen.Init( signOwner, GetWitcherPlayer().GetSignEntity( ST_Quen ), true );
		newQuen.OnStarted();
		newQuen.OnThrowing();
		newQuen.OnEnded();

		thePlayer.SoundEvent("magic_eredin_appear_disappear");
	}
	
	latent function wild_hunt_blink()
	{	
		theGame.SetTimeScale( 0.75, theGame.GetTimescaleSource( ETS_InstantKill ), theGame.GetTimescalePriority( ETS_InstantKill ), false, true );

		GetWitcherPlayer().AddTimer( 'RemoveInstantKillSloMo', 0.3 );

		if ( GetWitcherPlayer().IsHardLockEnabled() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading()); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		//dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		//+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		//pos = actor.PredictWorldPosition(0.25) + VecFromHeading( AngleNormalize180( GetWitcherPlayer().GetHeading() - dist ) ) * 1.25;
		//pos = actor.GetWorldPosition() + VecFromHeading( AngleNormalize180( GetWitcherPlayer().GetHeading() - dist ) ) * 1.25;
		
		if ( !theSound.SoundIsBankLoaded("magic_caranthil.bnk") )
    	{
        	theSound.SoundLoadBank( "magic_caranthil.bnk", false );
    	}
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{
			if (ACS_Armor_Set_Check('acs_armor', false)
			|| ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
			)
			{
				if (!GetWitcherPlayer().IsAnyQuenActive())
				{
					ACS_Armor_Quen();
				}
			}

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active'))
			{
				GetWitcherPlayer().StopAllEffects();
				
				GetWitcherPlayer().PlayEffectSingle( 'ice_armor' );
				GetWitcherPlayer().StopEffect( 'ice_armor' );
			}

			movementAdjustor.RotateTowards( ticket, actor );

			GetWitcherPlayer().SetIsCurrentlyDodging(true);
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'blink_start_back_ready_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			GetWitcherPlayer().SoundEvent("magic_canaris_teleport_short");

			//theGame.GetGameCamera().PlayEffectSingle( 'frost' );

			GetWitcherPlayer().AddTag('ACS_wildhunt_teleport_init');
			
			ACSGetCEntity('wh_teleportfx').Destroy();

			thePlayer.PlayEffectSingle('eredin_disappear');
			thePlayer.StopEffect('eredin_disappear');

			//teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), GetWitcherPlayer().GetWorldPosition(), EulerAngles(0,0,0) );
			//teleport_fx.CreateAttachment(GetWitcherPlayer());
			//teleport_fx.AddTag('wh_teleportfx');
			//teleport_fx.PlayEffectSingle('disappear');
			
			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 1.f, 15, 2.f, 12.5f, 0);

			//Sleep ( 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier() );

			TeleportBlockAction();
			
			GetACSWatcher().RemoveTimer('ACS_dodge_timer_wildhunt');
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier()  / theGame.GetTimeScale(), false );

			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 55, 20);

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;
				
				if( actors.Size() > 0 )
				{		
					if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && npc.IsAlive() )
					{
						if( targetDistance <= 2*2 ) 
						{
							npc.AddEffectDefault( EET_Frozen, npc, 'console' );
						}
					}
				}
			}
		}
	}

	latent function fire_blink()
	{	
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		//dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		//+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		//pos = actor.PredictWorldPosition(0.25) + VecFromHeading( AngleNormalize180( GetWitcherPlayer().GetHeading() - dist ) ) * 1.25;
		//pos = actor.GetWorldPosition() + VecFromHeading( AngleNormalize180( GetWitcherPlayer().GetHeading() - dist ) ) * 1.25;
		
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active'))
			{
				GetWitcherPlayer().StopAllEffects();
				
				GetWitcherPlayer().PlayEffectSingle( 'lugos_vision_burning' );
				GetWitcherPlayer().StopEffect( 'lugos_vision_burning' );
			}

			movementAdjustor.RotateTowards( ticket, actor );

			GetWitcherPlayer().SetIsCurrentlyDodging(true);
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_roll_flip_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			GetACSWatcher().Marker_Fire();

			GetWitcherPlayer().SoundEvent('monster_dracolizard_combat_fireball_flyby');

			//Sleep ( 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier() );

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_fire', 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier()  / theGame.GetTimeScale(), false );
			
			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 55, 2);

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if( actors.Size() > 0 )
				{		
					if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && npc.IsAlive() )
					{
						if ( RandF() < 0.5 )
						{
							npc.AddEffectDefault( EET_Burning, npc, 'console' );
						}
					}
				}
			}
		}
	}

	latent function bruxa_jump_up()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		thePlayer.DrainVitality( thePlayer.GetStat( BCS_Vitality ) * 0.125 );

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_actual();
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			movementAdjustor.RotateTowards( ticket, actor );
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_start_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			rot = GetWitcherPlayer().GetWorldRotation();

			pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

			ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

				"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

				, true ), pos, rot );

			ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ), EulerAngles( 0, 90, 0 ) );

			ent.PlayEffectSingle('swarm_attack');

			ent.DestroyAfter(2);

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}

			GetWitcherPlayer().PlayEffectSingle( 'shadowdash' );

			GetWitcherPlayer().AddTag('ACS_Bruxa_Jump_Init');

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.65   / theGame.GetTimeScale(), false );
		}
		else
		{
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	latent function mage_teleport()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

			movementAdjustor.RotateTowards( ticket, actor );
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_mage_teleport_out_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			//GetWitcherPlayer().PlayEffectSingle('teleport_out');
			//GetWitcherPlayer().StopEffect('teleport_out');

			if (ACS_GetItem_Sword_IsEquipped('water_staff_steel', 'steel'))
			{
				thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );
				thePlayer.PlayEffectSingle( 'hand_sand_fx_water_ACS' );
				thePlayer.StopEffect( 'hand_sand_fx_water_ACS' );

				thePlayer.StopEffect( 'hand_sand_fx_water_l_ACS' );
				thePlayer.PlayEffectSingle( 'hand_sand_fx_water_l_ACS' );
				thePlayer.StopEffect( 'hand_sand_fx_water_l_ACS' );

				thePlayer.PlayEffect('teleport_out_water_ACS');
				thePlayer.StopEffect('teleport_out_water_ACS');
			}
			else if (ACS_GetItem_Sword_IsEquipped('sand_staff_steel', 'steel'))
			{
				thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );
				thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_ACS' );
				thePlayer.StopEffect( 'hand_sand_fx_sand_ACS' );

				thePlayer.StopEffect( 'hand_sand_fx_sand_l_ACS' );
				thePlayer.PlayEffectSingle( 'hand_sand_fx_sand_l_ACS' );
				thePlayer.StopEffect( 'hand_sand_fx_sand_l_ACS' );

				thePlayer.PlayEffect('teleport_out_sand_ACS');
				thePlayer.StopEffect('teleport_out_sand_ACS');
			}
			else if (ACS_GetItem_Sword_IsEquipped('fire_staff_steel', 'steel'))
			{
				thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );
				thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_ACS' );
				thePlayer.StopEffect( 'hand_sand_fx_fire_ACS' );

				thePlayer.StopEffect( 'hand_sand_fx_fire_l_ACS' );
				thePlayer.PlayEffectSingle( 'hand_sand_fx_fire_l_ACS' );
				thePlayer.StopEffect( 'hand_sand_fx_fire_l_ACS' );
				
				thePlayer.PlayEffect('teleport_out_fire_ACS');
				thePlayer.StopEffect('teleport_out_fire_ACS');
			}
			else if (ACS_GetItem_Sword_IsEquipped('ice_staff_steel', 'steel'))
			{
				thePlayer.PlayEffectSingle('eredin_disappear');
				thePlayer.StopEffect('eredin_disappear');
			}

			ACSGetEquippedSword().DestroyEffect( 'fx_staff_cast' );
			ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_cast' );
			ACSGetEquippedSword().StopEffect( 'fx_staff_cast' );

			ACSGetEquippedSword().DestroyEffect( 'fx_staff_gameplay' );
			ACSGetEquippedSword().PlayEffectSingle( 'fx_staff_gameplay' );
			ACSGetEquippedSword().StopEffect( 'fx_staff_gameplay' );

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_mage', 0.65   / theGame.GetTimeScale(), false );
		}
	}

	latent function sorceress_teleport()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

			movementAdjustor.RotateTowards( ticket, actor );
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'mage_teleport_start_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			rot = GetWitcherPlayer().GetWorldRotation();

			pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

			ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

				"fx\characters\mage\teleport\teleport_01.w2ent"

				, true ), pos, rot );

			ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 1 ), EulerAngles( 0, 0, 0 ) );

			//ent.PlayEffectSingle('teleport_fx_triss');

			ent.PlayEffectSingle('teleport_fx');

			ent.DestroyAfter(2);

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
			
			TeleportBlockAction();

			GetACSWatcher().AddTimer('ACS_dodge_timer_mage', 0.65   / theGame.GetTimeScale(), false );
		}
	}

	latent function dolphin_teleport()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

			movementAdjustor.RotateTowards( ticket, actor );
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_mage_cast_shield_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			rot = GetWitcherPlayer().GetWorldRotation();

			pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

			ACSGetCEntity('acs_dolphin_fx').Destroy();

			ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

				"dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent"

				, true ), pos, rot );

			//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ), EulerAngles( 0, 0, 0 ) );

			//ent.PlayEffectSingle('teleport_fx_triss');

			ent.PlayEffectSingle('up');
			ent.PlayEffectSingle('warning_up');

			ent.PlayEffectSingle('diagonal_up_right');
			ent.PlayEffectSingle('warning_up_right');

			ent.PlayEffectSingle('diagonal_up_left');
			ent.PlayEffectSingle('warning_up_left');

			GetWitcherPlayer().SoundEvent('monster_water_mage_combat_spray');

			ent.AddTag('acs_dolphin_fx');

			//ent.DestroyAfter(2);

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_dolphin', 0.65   / theGame.GetTimeScale(), false );
		}
	}

	latent function lightning_teleport()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

			movementAdjustor.RotateTowards( ticket, actor );
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_mage_cast_shield_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			rot = GetWitcherPlayer().GetWorldRotation();

			pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

			ACSGetCEntity('acs_lightning_teleport_fx').Destroy();

			ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

				//"dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent"

				"fx\quest\sq209\sq209_lightning_scene.w2ent"

				, true ), pos, rot );

			//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ), EulerAngles( 0, 0, 0 ) );

			//ent.PlayEffectSingle('teleport_fx_triss');

			GetWitcherPlayer().SoundEvent('fx_other_lightning_hit');

			//ent.PlayEffectSingle('lightning');

			//ent.PlayEffectSingle('pre_lightning');

			ent.PlayEffectSingle('lighgtning');

			GetACSWatcher().Marker_Lightning();

			GetWitcherPlayer().PlayEffectSingle('hit_lightning');
			GetWitcherPlayer().StopEffect('hit_lightning');

			ent.AddTag('acs_lightning_teleport_fx');

			//ent.DestroyAfter(2);

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false)) 
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_lightning', 0.65   / theGame.GetTimeScale(), false );
		}
	}

	latent function iris_teleport()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

			movementAdjustor.RotateTowards( ticket, actor );

			if( RandF() < 0.5 ) 
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_forward_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_down_to_forward_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'taunt_forward_to_down_001_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				}
			}

			GetWitcherPlayer().StopEffect('special_attack_fx');

			GetWitcherPlayer().PlayEffectSingle('special_attack_fx');

			GetACSWatcher().Marker_Smoke();

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_iris', 0.65   / theGame.GetTimeScale(), false );

			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 3, 5);

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if( actors.Size() > 0 )
				{		
					if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && npc.IsAlive() )
					{
						if ( RandF() < 0.5 )
						{
							npc.StopEffect('demonic_possession');
							npc.PlayEffectSingle('demonic_possession');
							npc.StopEffect('demonic_possession');

							if (npc.IsHuman())
							{
								npc.AddEffectDefault( EET_Swarm, npc, 'console' );
							}
							else
							{
								npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
							}
						}
					}
				}
			}
		}
	}

	latent function explosion_teleport()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

			movementAdjustor.RotateTowards( ticket, actor );

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_quen_front_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_quen_front_rp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}

			rot = GetWitcherPlayer().GetWorldRotation();

			pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

			//ACSGetCEntity('acs_explosion_teleport_fx').Destroy();

			//ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

				//"dlc\bob\data\fx\cutscenes\cs704_detlaff_morphs\cs704_detlaff_force.w2ent"

				//, true ), pos, rot );

			//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ), EulerAngles( 0, 0, 0 ) );

			//ent.PlayEffectSingle('teleport_fx_triss');

			GetWitcherPlayer().StopEffect('smoke_explosion');
			GetWitcherPlayer().PlayEffectSingle('smoke_explosion');

			//ent.AddTag('acs_explosion_teleport_fx');

			//ent.DestroyAfter(2);

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_explosion', 0.65   / theGame.GetTimeScale(), false );
		}
	}

	latent function fountain_portal_teleport()
	{	
		var ent                         : CEntity;
		var rot                         : EulerAngles;
		var pos							: Vector;

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

			movementAdjustor.RotateTowards( ticket, actor );

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_quen_start_rp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_quen_start_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}

			rot = GetWitcherPlayer().GetWorldRotation();

			pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

			ACSGetCEntity('acs_fountain_portal_teleport_fx').Destroy();

			ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

				"dlc\bob\data\fx\quest\q704\q704_13_fountain\q704_fairlytale_portal.w2ent"

				, true ), pos, rot );

			ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 1 ), EulerAngles( 0, 0, 0 ) );

			//ent.PlayEffectSingle('teleport_fx_triss');

			ent.PlayEffectSingle('portal');

			GetWitcherPlayer().SoundEvent('magic_geralt_teleport');

			ent.AddTag('acs_fountain_portal_teleport_fx');

			//ent.DestroyAfter(2);

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
			
			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_fountain_portal', 0.65   / theGame.GetTimeScale(), false );
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function bruxa_regular_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetACSWatcher().dodge_timer_actual();
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3.25 ) + theCamera.GetCameraDirection() );		

			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -3.25 ) + theCamera.GetCameraDirection() );		

			//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_sword_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_lp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_dodge_back_rp_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_2()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1 ));

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_lp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337cm_rp_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_3()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1 ));

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_back_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_dodge_b_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

statemachine class cACS_RollInit
{	
    function ACS_RollInit_Engage()
	{
		this.PushState('ACS_RollInit_Engage');
	}
}
 
state ACS_RollInit_Engage in cACS_RollInit
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
	private var dodge_counter_roll						: int;
		
	event OnEnterState(prevStateName : name)
	{
		RollInit();
	}

	function ACSDodgeMovementAdjust(direction : CName)
	{
		var movementAdjustorWitcher		: CMovementAdjustor; 
		var ticketWitcher				: SMovementAdjustmentRequestTicket; 

		movementAdjustorWitcher = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

		ticketWitcher = movementAdjustorWitcher.GetRequest( 'ACSMovAdj' );
		movementAdjustorWitcher.CancelByName( 'ACSMovAdj' );
		movementAdjustorWitcher.CancelAll();
		ticketWitcher = movementAdjustorWitcher.CreateNewRequest( 'ACSMovAdj' ); 
		movementAdjustorWitcher.AdjustmentDuration( ticketWitcher, 0.125 );
		movementAdjustorWitcher.MaxRotationAdjustmentSpeed( ticketWitcher, 500000 );

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

	
	entry function RollInit()
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

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		GetWitcherPlayer().StopEffect('dive_shape');

		GetWitcherPlayer().RemoveTag('ACS_Bruxa_Jump_End');

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	

		ACS_ThingsThatShouldBeRemoved();
		
		ACS_ExplorationDelayHack(false, 3);

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

		if (((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'wood_hollow'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'wood_debris'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_hard'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'dirt_soil'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'hay'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'stone_debris'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'stone_solid'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'clay_tile'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_large'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'gravel_small'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'sand'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'water_shallow'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'water_deep'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_short'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'grass_long'
		|| ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetMaterialName() == 'carpet'
		)
		{

			thePlayer.StopEffect('jump_ground_fx1');
			thePlayer.PlayEffect('jump_ground_fx1');

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
		}

		thePlayer.ACS_DealPlayerPostureDamage(5, false);

		thePlayer.SetSprintActionPressed( false );
		thePlayer.SetSprintToggle( false );
		
		if (ACS_Settings_Main_Bool('acs_movement_main_settings','acs_walking_by_default_enabled', true))
		{
			thePlayer.SetWalkToggle( true );	
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
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 0.01 / theGame.GetTimeScale(), false ); 

				if (thePlayer.HasTag('ACS_Sword_Hit_Blood_Trigger'))
				{
					GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondaryWeaponBlood', 1.01 / theGame.GetTimeScale(), false ); 

					thePlayer.RemoveTag('ACS_Sword_Hit_Blood_Trigger');
				}
			}
		}

		ACSGetCActorDestroyAll('ACS_Geralt_Phantom');

		if ( thePlayer.inv.IsItemCrossbow( thePlayer.inv.GetItemFromSlot( 'l_weapon' ) ) )
		{
			thePlayer.OnRangedForceHolster(false, true, false);
		}

		GetWitcherPlayer().ResetUninterruptedHitsCount();

		//GetWitcherPlayer().SendAttackReactionEvent();

		if (ACS_Armor_Set_Check('acs_armor', false)
		|| ACS_Armor_Set_Check('wh_armor', false)
		|| ACS_Armor_Set_Check('eredin_armor', false)
		|| ACS_Armor_Set_Check('imlerith_armor', false)
		|| ACS_Armor_Set_Check('caranthir_armor', false)
		|| ACS_Armor_Set_Check('vgx_eredin_armor', false)
		)
		{
			thePlayer.SoundEvent( "monster_caretaker_mv_cloth_hard" );

			thePlayer.SoundEvent( "monster_caretaker_mv_footstep" );
		}
		
		if (
		FactsQuerySum("ACS_Slayer_Active") > 0
		|| FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			cat_school_rolls();
		}
		else
		{
			if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped')
			|| GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
			|| GetWitcherPlayer().HasTag('acs_sorc_fists_equipped')
			|| ACS_Vampire_Claws_Access()
			)
			{
				vampire_claws_rolls();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
			)
			{
				yrden_sword_rolls();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
			)
			{
				yrden_secondary_sword_rolls();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
			)
			{
				axii_secondary_sword_rolls();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
			)
			{
				quen_secondary_sword_rolls();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
			)
			{
				aard_secondary_sword_rolls();
			}
			else if (
			GetWitcherPlayer().HasTag('acs_igni_sword_equipped') || GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
			)
			{
				igni_sword_rolls();
			}
			else
			{
				if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
				&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
				)
				{
					ACS_Weapon_Respawn();

					GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

					GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
				}

				GetACSWatcher().dodge_timer_attack_actual();

				if (ACS_DefaultGeraltMovesetOverrideModeRoll_Enabled())
				{
					if ((thePlayer.IsWeaponHeld('fist') 
					|| !thePlayer.IsAnyWeaponHeld())
					&& !GetACSWatcher().ACS_IS_SNEAKING 
					&& !thePlayer.HasTag('ACS_Is_Sneaking')
					)
					{
						geralt_moveset_fist_roll_override_mode();
					}
					else
					{
						geralt_moveset_roll_override_mode();
					}
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

					Sleep(0.0625);
					
					GetWitcherPlayer().EvadePressed(EBAT_Roll);

					GetACSWatcher().ACS_StaminaDrain(4);	
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function vampire_claws_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

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
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

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

					bruxa_right_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 ) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

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

					bruxa_left_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

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
					
					//ACS_Dodge();

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
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

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
					
					//ACS_Dodge();

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
					
					//ACS_Dodge();

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

					GetACSWatcher().dodge_timer_actual();

					bruxa_regular_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function yrden_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_right_dodge_alt();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}
					
					two_hand_left_dodge_alt();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_right_dodge_alt();

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}
					
					two_hand_left_dodge_alt();

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function yrden_secondary_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_front_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_right_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_left_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_front_dodge();

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_front_dodge();

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function axii_secondary_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_sword_right_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_sword_left_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function quen_secondary_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_right_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_left_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function aard_secondary_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}		
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_front_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_right_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_left_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function igni_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		if (ACS_GetItem_Sword_IsEquipped('zireal_steel_held', 'steel') || ACS_GetItem_Sword_IsEquipped('zireal_silver_held', 'silver') || ACS_Armor_Set_Check('acs_armor_omega', false) || ACS_Armor_Set_Check('acs_armor_alpha', false))
		{
			if (ACS_GetItem_Sword_IsEquipped('zireal_steel_held', 'steel') || ACS_GetItem_Sword_IsEquipped('zireal_silver_held', 'silver'))
			{
				ciri_rolls();
			}
			else
			{
				acs_armor_rolls();
			}
		}
		else
		{
			if (ACS_Armor_Set_Check('wolf', true))
			{
				wolf_school_rolls();
			}
			else if (ACS_Armor_Set_Check('bear', true))
			{
				bear_school_rolls();
			}
			else if (ACS_Armor_Set_Check('cat', true) || thePlayer.HasTag('ACS_Dual_Wield_Active'))
			{
				cat_school_rolls();
			}
			else if (ACS_Armor_Set_Check('griffin', true))
			{
				griffin_school_rolls();
			}
			else if (ACS_Armor_Set_Check('manticore', true))
			{
				manticore_school_rolls();
			}
			else if (ACS_Armor_Set_Check('forgotten_wolf', true) )
			{
				forgotten_wolf_school_rolls();
			}
			else if (ACS_Armor_Set_Check('viper', true))
			{
				viper_school_rolls();
			}
			else
			{
				if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
				&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
				)
				{
					ACS_Weapon_Respawn();

					GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

					GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
				}

				GetACSWatcher().dodge_timer_attack_actual();

				if (ACS_DefaultGeraltMovesetOverrideModeRoll_Enabled())
				{
					if ((thePlayer.IsWeaponHeld('fist') 
					|| !thePlayer.IsAnyWeaponHeld())
					&& !GetACSWatcher().ACS_IS_SNEAKING 
					&& !thePlayer.HasTag('ACS_Is_Sneaking')
					)
					{
						geralt_moveset_fist_roll_override_mode();
					}
					else
					{
						geralt_moveset_roll_override_mode();
					}
				}
				else
				{
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

					Sleep(0.0625);
					
					GetWitcherPlayer().EvadePressed(EBAT_Roll);

					GetACSWatcher().ACS_StaminaDrain(4);	
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function geralt_moveset_roll_override_mode()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 ) // back
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_fast_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_group_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_strong_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_fast_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_group_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_strong_dodge_back_long_ACS');

					return;
				}


				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_backward_roll_options', 11) )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0) // forward
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_fast_dodge_forward_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_group_dodge_forward_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_strong_dodge_forward_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_fast_dodge_forward_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_group_dodge_forward_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_strong_dodge_forward_long_ACS');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_foward_roll_options', 11) )
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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) // right
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_fast_dodge_right_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_group_dodge_right_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_strong_dodge_right_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_fast_dodge_right_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_group_dodge_right_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_strong_dodge_right_long_ACS');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_right_roll_options', 11) )
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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_fast_dodge_left_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_group_dodge_left_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_strong_dodge_left_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_fast_dodge_left_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_group_dodge_left_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_strong_dodge_left_long_ACS');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_left_roll_options', 11) )
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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_fast_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_group_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_strong_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_fast_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_group_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_strong_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardleft');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_right_roll_options', 11) )
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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_fast_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_group_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_strong_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_fast_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_group_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_strong_dodge_forward_long_ACS');

					ACSDodgeMovementAdjust('forwardright');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_left_roll_options', 2) )
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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_fast_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_group_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_right_dodge_extras('tw1_silver_strong_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_fast_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_group_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_right_dodge_extras('tw1_steel_strong_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backleft');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_right_roll_options', 11) )
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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_fast_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_group_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_left_dodge_extras('tw1_silver_strong_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_fast_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_group_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_left_dodge_extras('tw1_steel_strong_dodge_back_long_ACS');

					ACSDodgeMovementAdjust('backright');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_left_roll_options', 11) )
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
		else // neutral
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				GetACSWatcher().ACS_StaminaDrain(4);

				if (GetACSWatcher().silver_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_fast_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_group_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_group_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().silver_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_silver_strong_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_fast_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_fast_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_group_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_group_dodge_back_long_ACS');

					return;
				}

				if (GetACSWatcher().steel_strong_stance)
				{
					override_mode_back_dodge_extras('tw1_steel_strong_dodge_back_long_ACS');

					return;
				}

				if (ACS_Settings_Main_Bool('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_randomized_enabled', false))
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

				switch( ACS_Settings_Main_Int('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_mode_neutral_roll_options', 11) )
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

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function geralt_moveset_fist_roll_override_mode()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0  )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}

				override_mode_fist_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}


				override_mode_fist_front_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}


				override_mode_fist_right_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}


				override_mode_fist_left_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}


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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}


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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}


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

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}


				override_mode_fist_left_dodge();

				ACSDodgeMovementAdjust('backleft');
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				ACS_refresh_dodge_cooldown();

				if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
				{
					GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
					GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

					GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
					GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
				}


				override_mode_fist_regular_dodge();
				
				GetACSWatcher().ACS_StaminaDrain(4);
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_fist_regular_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_actual();
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge1_back_425cm', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2.5 ) + theCamera.GetCameraDirection() * -2.5 );		
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge1_back_425cm', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2.5 ) + theCamera.GetCameraDirection() * -2.5 );		
		}
	}

	latent function override_mode_fist_front_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			
		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge1_forward_425cm', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2.5 ) + theCamera.GetCameraDirection() * 2.5 );	
	}

	latent function override_mode_fist_left_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge1_left_425cm', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -2.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -2.25) );
	}

	latent function override_mode_fist_right_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_fistfight_dodge1_right_425cm', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 2.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 2.25) );
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_back_dodge_1()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_back_337m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_back_dodge_3()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_front_right_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_front_left_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_back_right_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_back_left_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	latent function override_mode_right_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_left_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_back_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
			GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function override_mode_orient_back_dodge_extras( anim_name : name )
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
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
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( anim_name, 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_right_dodge_1()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.25) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_right_dodge_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_right_dodge_4()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) - 90 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function override_mode_left_dodge_1()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.25 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.25) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_left_dodge_2()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function override_mode_left_dodge_4()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) + 90 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function wolf_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					
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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_right_dodge_alt_4();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					
					one_hand_sword_left_dodge_alt_4();
					
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					
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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					
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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					
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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}
					
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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function bear_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_sword_right_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_sword_left_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					two_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function cat_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					cat_one_hand_sword_front_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					cat_one_hand_sword_right_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					cat_one_hand_sword_left_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function griffin_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_right_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_left_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function manticore_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_1();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_right_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_left_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function forgotten_wolf_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_right_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_left_dodge_alt_2();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function viper_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					cat_one_hand_sword_front_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					cat_one_hand_sword_right_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					cat_one_hand_sword_left_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

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

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false) )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					one_hand_sword_back_dodge_alt_3();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function ciri_rolls()
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

		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('back');

					ciri_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('front');

					ciri_front_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('right');

					ciri_right_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('left');

					ciri_left_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('right');

					ciri_right_dodge();

					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('left');

					ciri_left_dodge();

					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('right');

					ciri_right_dodge();

					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('left');

					ciri_left_dodge();

					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodge('back');

					ciri_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	latent function acs_armor_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}	
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_front_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_right_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_left_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_right_dodge();

					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_left_dodge();

					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_right_dodge();

					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_left_dodge();

					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_acs_armor');
					GetWitcherPlayer().PlayEffectSingle('dodge_acs_armor');

					GetWitcherPlayer().DestroyEffect('bruxa_dash_trails');
					GetWitcherPlayer().PlayEffectSingle('bruxa_dash_trails');

					GetWitcherPlayer().PlayEffectSingle('special_attack_only_black_fx');
					GetWitcherPlayer().StopEffect('special_attack_only_black_fx');

					acs_armor_back_dodge();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function bruxa_front_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		thePlayer.DrainVitality(thePlayer.GetStat(BCS_Vitality) * 0.125);

		GetWitcherPlayer().AddTag('ACS_Vampire_Claws_Roll');

		GetACSWatcher().dodge_timer_actual();
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_to_walk_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 4.5 ) + theCamera.GetCameraDirection() * 4.5 );	
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_to_walk_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 4.5 ) + theCamera.GetCameraDirection() * 4.5 );		
		}
	}

	latent function bruxa_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		thePlayer.DrainVitality(thePlayer.GetStat(BCS_Vitality) * 0.125);

		GetWitcherPlayer().AddTag('ACS_Vampire_Claws_Roll');

		GetACSWatcher().dodge_timer_actual();
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 4.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 4.5) );	
		}
		else
		{			
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 4.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 4.5) );
		}
	}

	latent function bruxa_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		thePlayer.DrainVitality(thePlayer.GetStat(BCS_Vitality) * 0.125);

		GetWitcherPlayer().AddTag('ACS_Vampire_Claws_Roll');

		GetACSWatcher().dodge_timer_actual();
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{		
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -4.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -4.5) );
		}
		else
		{			
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -4.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -4.5) );
		}
	}

	latent function bruxa_regular_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.5 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		thePlayer.DrainVitality(thePlayer.GetStat(BCS_Vitality) * 0.125);

		GetWitcherPlayer().AddTag('ACS_Vampire_Claws_Roll');

		GetACSWatcher().dodge_timer_actual();
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
					
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -4.5 ) + theCamera.GetCameraDirection() * -4.5 );		
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -4.5 ) + theCamera.GetCameraDirection() * -4.5 );		
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function two_hand_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
		//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function two_hand_right_dodge_alt()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
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

	latent function two_hand_left_dodge_alt()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
		//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		
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

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function two_hand_sword_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
	}

	latent function two_hand_sword_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_l_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function two_hand_sword_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_npc_sword_2hand_dodge_r_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 4 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 4) );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -2 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
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

	latent function ciri_front_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 8 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 8) );
		
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

	latent function acs_armor_front_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 8 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 8) );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		

		

		

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}

		if( RandF() < 0.75 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward1_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward2_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function one_hand_sword_left_dodge_alt_2()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m_90deg_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_2()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();


		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		//movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5) );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m_90deg_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_back_dodge_alt_3()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -1.1) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_dodge_b_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function ciri_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -8 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -8) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_special_blink_attack_disappear_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));
	}

	latent function acs_armor_back_dodge()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ACSFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -8 ) + theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * -8) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_dodge_b_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_front_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );
		
		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		&& ACS_Settings_Main_Bool('acs_dodge_settings','acs_dodge_effects', false))
		{
			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails_backup' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails_backup' );
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.5 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_forward_300m_lp', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function one_hand_sword_left_dodge_alt_3()
	{	
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function one_hand_sword_left_dodge_alt_4()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_left_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function one_hand_sword_right_dodge_alt_4()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_right_350m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function ciri_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -8 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -8) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (RandF() < 0.5)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_left_lp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_left_rp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
		}
	}

	latent function ciri_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 8 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 8) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (RandF() < 0.5)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_right_lp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_right_rp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
		}
	}

	latent function acs_armor_left_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -8 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -8) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (RandF() < 0.5)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_left_lp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_left_rp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
		}
	}

	latent function acs_armor_right_dodge()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.375 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 8 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 8) );

		GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5  / theGame.GetTimeScale(), false );

		if (RandF() < 0.5)
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_right_lp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'woman_ciri_sword_dodge_start_right_rp_extended_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));	
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function cat_one_hand_sword_back_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
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

	latent function cat_one_hand_sword_front_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25   / theGame.GetTimeScale(), false );
		
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
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.1 );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5 ); }

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25   / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_left_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	latent function cat_one_hand_sword_right_dodge_alt_3()
	{
		ticket = movementAdjustor.GetRequest( 'ACSMovAdj' );
		
		movementAdjustor.CancelByName( 'ACSMovAdj' );
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' ); movementAdjustor.BlendIn(ticket, 0.1f); movementAdjustor.ShouldStartFacing(ticket, theCamera.GetCameraHeading());
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000000 );

		GetACSWatcher().dodge_timer_attack_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + GetACSWatcher().GetWorldForward() * 1.1 ) );

		//if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.1 );

		if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();}	

		if (GetWitcherPlayer().IsGuarded()||GetWitcherPlayer().HasBuff(EET_SlowdownFrost)||GetWitcherPlayer().HasBuff(EET_Slowdown)||GetWitcherPlayer().HasBuff(EET_Blizzard)){GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.25  ); }else{GetWitcherPlayer().ACS_SetAnimationSpeedMultiplier( 1.5 ); }		

		GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.25   / theGame.GetTimeScale(), false );

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge1_right_4m', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

/*
function ACS_Blink_Hit_Reaction()
{
	var vACS_BlinkHitReaction : cACS_BlinkHitReaction;
	vACS_BlinkHitReaction = new cACS_BlinkHitReaction in theGame;
	
	vACS_BlinkHitReaction.BlinkHitReaction_Engage();
}

statemachine class cACS_BlinkHitReaction
{	
    function BlinkHitReaction_Engage()
	{
		this.PushState('BlinkHitReaction_Engage');
	}
}
 
state BlinkHitReaction_Engage in cACS_BlinkHitReaction
{
	private var actor 									: CActor;
	private var movementAdjustor						: CMovementAdjustor;
	private var ticket 									: SMovementAdjustmentRequestTicket;
	private var dist, targetDistance					: float;
	private var pos, cPos								: Vector;
	private var actors    								: array<CActor>;
	private var i         								: int;
	private var npc     								: CNewNPC;
	private var teleport_fx								: CEntity;
		
	event OnEnterState(prevStateName : name)
	{
		BlinkHitReaction_Entry();
	}
	
	entry function BlinkHitReaction_Entry()
	{		
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('acs_in_wraith')
		&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
		)
		{
			BlinkHitReaction_Latent();
		}
	}
	
	latent function BlinkHitReaction_Latent ()
	{		
		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}
		
		//dist = ((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		//+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius();
		
		//pos = actor.PredictWorldPosition(0.25) + VecFromHeading( AngleNormalize180( GetWitcherPlayer().GetHeading() - dist ) ) * 1.25;
		//pos = actor.GetWorldPosition() + VecFromHeading( AngleNormalize180( GetWitcherPlayer().GetHeading() - dist ) ) * 1.25;
		
		if ( !theSound.SoundIsBankLoaded("magic_caranthil.bnk") )
    	{
        	theSound.SoundLoadBank( "magic_caranthil.bnk", false );
    	}
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active'))
			{
				GetWitcherPlayer().StopAllEffects();
				
				GetWitcherPlayer().PlayEffectSingle( 'ice_armor' );
				GetWitcherPlayer().StopEffect( 'ice_armor' );
			}

			movementAdjustor.RotateTowards( ticket, actor );

			GetWitcherPlayer().SetIsCurrentlyDodging(true);
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'blink_start_back_ready_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			GetWitcherPlayer().SoundEvent("magic_canaris_teleport_short");

			theGame.GetGameCamera().PlayEffectSingle( 'frost' );

			GetWitcherPlayer().AddTag('ACS_wildhunt_teleport_init');
			
			ACSGetCEntity('wh_teleportfx').Destroy();

			thePlayer.PlayEffectSingle('eredin_disappear');
			thePlayer.StopEffect('eredin_disappear');
			
			//teleport_fx = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\characters\eredin\eredin_teleport.w2ent", true ), GetWitcherPlayer().GetWorldPosition(), EulerAngles(0,0,0) );
			//teleport_fx.CreateAttachment(GetWitcherPlayer());
			//teleport_fx.AddTag('wh_teleportfx');
			//teleport_fx.PlayEffectSingle('disappear');
			
			
			//Sleep ( 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier() );
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier()  / theGame.GetTimeScale(), false );
			
			
			movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
			thePlayer.RaiseEvent('ACS_CombatExtraReset');movementAdjustor.CancelAll();

			

			

			

			GetWitcherPlayer().ResetRawPlayerHeading();

			ticket = movementAdjustor.CreateNewRequest( 'wh_blink' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 / theGame.GetTimeScale());
			movementAdjustor.RotateTowards( ticket, actor );
			if (GetACSWatcher().playerContactWithNpc){movementAdjustor.MaxLocationAdjustmentDistance( ticket, 0 );} movementAdjustor.SlideTo(ticket, pos);
			
		}
	}
}
*/