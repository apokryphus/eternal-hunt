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

		ACS_ThingsThatShouldBeRemoved();
		
		ACS_ExplorationDelayHack();

		DodgePunishment();

		ACS_Geralt_Phantom_Destroy();

		if ( thePlayer.inv.IsItemCrossbow( thePlayer.inv.GetItemFromSlot( 'l_weapon' ) ) )
		{
			thePlayer.OnRangedForceHolster(false, true, false);
		}

		GetWitcherPlayer().ResetUninterruptedHitsCount();

		GetWitcherPlayer().SendAttackReactionEvent();

		//GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

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

		if ( ACS_StaminaBlockAction_Enabled() 
		&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
		)
		{
			GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			GetWitcherPlayer().SoundEvent("gui_no_stamina");
		}
		else
		{
			if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped')
			|| GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
			|| GetWitcherPlayer().HasTag('acs_sorc_fists_equipped')
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
					
					if (ACS_Armor_Equipped_Check()
					|| ACS_WH_Armor_Equipped_Check()
					|| ACS_Eredin_Armor_Equipped_Check()
					|| ACS_Imlerith_Armor_Equipped_Check()
					|| ACS_Caranthir_Armor_Equipped_Check()
					|| ACS_VGX_Eredin_Armor_Equipped_Check()
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
					
					if (ACS_Armor_Equipped_Check()
					|| ACS_WH_Armor_Equipped_Check()
					|| ACS_Eredin_Armor_Equipped_Check()
					|| ACS_Imlerith_Armor_Equipped_Check()
					|| ACS_Caranthir_Armor_Equipped_Check()
					|| ACS_VGX_Eredin_Armor_Equipped_Check()
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
					
					if (ACS_Armor_Equipped_Check()
					|| ACS_WH_Armor_Equipped_Check()
					|| ACS_Eredin_Armor_Equipped_Check()
					|| ACS_Imlerith_Armor_Equipped_Check()
					|| ACS_Caranthir_Armor_Equipped_Check()
					|| ACS_VGX_Eredin_Armor_Equipped_Check()
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
					
					if (ACS_Armor_Equipped_Check()
					|| ACS_WH_Armor_Equipped_Check()
					|| ACS_Eredin_Armor_Equipped_Check()
					|| ACS_Imlerith_Armor_Equipped_Check()
					|| ACS_Caranthir_Armor_Equipped_Check()
					|| ACS_VGX_Eredin_Armor_Equipped_Check()
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

					if (ACS_Armor_Equipped_Check()
					|| ACS_WH_Armor_Equipped_Check()
					|| ACS_Eredin_Armor_Equipped_Check()
					|| ACS_Imlerith_Armor_Equipped_Check()
					|| ACS_Caranthir_Armor_Equipped_Check()
					|| ACS_VGX_Eredin_Armor_Equipped_Check()
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

					if (ACS_Armor_Equipped_Check()
					|| ACS_WH_Armor_Equipped_Check()
					|| ACS_Eredin_Armor_Equipped_Check()
					|| ACS_Imlerith_Armor_Equipped_Check()
					|| ACS_Caranthir_Armor_Equipped_Check()
					|| ACS_VGX_Eredin_Armor_Equipped_Check()
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
					
					if (ACS_Armor_Equipped_Check()
					|| ACS_WH_Armor_Equipped_Check()
					|| ACS_Eredin_Armor_Equipped_Check()
					|| ACS_Imlerith_Armor_Equipped_Check()
					|| ACS_Caranthir_Armor_Equipped_Check()
					|| ACS_VGX_Eredin_Armor_Equipped_Check()
					)
					{
						wild_hunt_blink();
					}
					else
					{
						fire_blink();	
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
	}

	latent function TeleportWeaponSpawn()
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

		ticket = movementAdjustor.GetRequest( 'wildhunt_blink');
		
		movementAdjustor.CancelByName( 'wildhunt_blink' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'wildhunt_blink' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
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
			if (ACS_Armor_Equipped_Check()
			|| ACS_WH_Armor_Equipped_Check()
			|| ACS_Eredin_Armor_Equipped_Check()
			|| ACS_Imlerith_Armor_Equipped_Check()
			|| ACS_Caranthir_Armor_Equipped_Check()
			|| ACS_VGX_Eredin_Armor_Equipped_Check()
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
			
			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 1.f, 15, 2.f, 12.5f, 0);

			//Sleep ( 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier() );

			TeleportBlockAction();
			
			GetACSWatcher().RemoveTimer('ACS_dodge_timer_wildhunt');
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier() , false);

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

		ticket = movementAdjustor.GetRequest( 'fire_blink');
		
		movementAdjustor.CancelByName( 'fire_blink' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'fire_blink' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
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
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_fire', 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier() , false);
			
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

		if ( GetWitcherPlayer().IsHardLockEnabled() && GetWitcherPlayer().GetTarget() )
			actor = (CActor)( GetWitcherPlayer().GetTarget() );	
		else
		{
			GetWitcherPlayer().FindMoveTarget();
			actor = (CActor)( GetWitcherPlayer().moveTarget );		
		}

		ticket = movementAdjustor.GetRequest( 'bruxa_jump_up');
		
		movementAdjustor.CancelByName( 'bruxa_jump_up' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_jump_up' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

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

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled())
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
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.65  , false);
		}
		else
		{
			GetACSWatcher().dodge_timer_actual();

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled())
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

		ticket = movementAdjustor.GetRequest( 'mage_teleport');
		
		movementAdjustor.CancelByName( 'mage_teleport' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'mage_teleport' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() && actor.IsOnGround() )
		{	
			GetWitcherPlayer().SetIsCurrentlyDodging(true);

			movementAdjustor.RotateTowards( ticket, actor );
						
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_mage_teleport_out_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			//GetWitcherPlayer().PlayEffectSingle('teleport_out');
			//GetWitcherPlayer().StopEffect('teleport_out');

			if (ACS_GetItem_MageStaff_Water())
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
			else if (ACS_GetItem_MageStaff_Sand())
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
			else if (ACS_GetItem_MageStaff_Fire())
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
			else if (ACS_GetItem_MageStaff_Ice())
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
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_mage', 0.65  , false);
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

		ticket = movementAdjustor.GetRequest( 'sorceress_teleport');
		
		movementAdjustor.CancelByName( 'sorceress_teleport' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'sorceress_teleport' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
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

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled())
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
			
			TeleportBlockAction();

			GetACSWatcher().AddTimer('ACS_dodge_timer_mage', 0.65  , false);
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

		ticket = movementAdjustor.GetRequest( 'dolphin_teleport');
		
		movementAdjustor.CancelByName( 'dolphin_teleport' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'dolphin_teleport' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
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

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled())
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_dolphin', 0.65  , false);
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

		ticket = movementAdjustor.GetRequest( 'lightning_teleport');
		
		movementAdjustor.CancelByName( 'lightning_teleport' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'lightning_teleport' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
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

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled()) 
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_lightning', 0.65  , false);
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

		ticket = movementAdjustor.GetRequest( 'iris_teleport');
		
		movementAdjustor.CancelByName( 'iris_teleport' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'iris_teleport' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
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
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_iris', 0.65  , false);
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

		ticket = movementAdjustor.GetRequest( 'explosion_teleport');
		
		movementAdjustor.CancelByName( 'explosion_teleport' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'explosion_teleport' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
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

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}

			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_explosion', 0.65  , false);
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

		ticket = movementAdjustor.GetRequest( 'fountain_portal_teleport');
		
		movementAdjustor.CancelByName( 'fountain_portal_teleport' );
		
		movementAdjustor.CancelAll();

		GetWitcherPlayer().ResetRawPlayerHeading();
		
		ticket = movementAdjustor.CreateNewRequest( 'fountain_portal_teleport' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.1 );
		
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

			if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
			{
				GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
				GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

				GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
				GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			}
			
			TeleportBlockAction();
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_fountain_portal', 0.65  , false);
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1 ));

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

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -1.1 ));

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

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

function ACS_RollInit()
{
	var vACS_RollInit : cACS_RollInit;
	vACS_RollInit = new cACS_RollInit in theGame;
	
	if ( ACS_Enabled()
	&& !GetWitcherPlayer().IsCiri()
	&& !GetWitcherPlayer().IsPerformingFinisher()
	&& !GetWitcherPlayer().HasTag('acs_in_wraith')
	&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
	&& ACS_BuffCheck()
	&& GetWitcherPlayer().IsActionAllowed(EIAB_Roll)
	)
	{
		vACS_RollInit.ACS_RollInit_Engage();
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

	
	entry function RollInit()
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

		ACS_ThingsThatShouldBeRemoved();
		
		ACS_ExplorationDelayHack();

		DodgePunishment();

		ACS_Geralt_Phantom_Destroy();

		if ( thePlayer.inv.IsItemCrossbow( thePlayer.inv.GetItemFromSlot( 'l_weapon' ) ) )
		{
			thePlayer.OnRangedForceHolster(false, true, false);
		}

		GetWitcherPlayer().ResetUninterruptedHitsCount();

		GetWitcherPlayer().SendAttackReactionEvent();

		//GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

		if (ACS_Armor_Equipped_Check()
		|| ACS_WH_Armor_Equipped_Check()
		|| ACS_Eredin_Armor_Equipped_Check()
		|| ACS_Imlerith_Armor_Equipped_Check()
		|| ACS_Caranthir_Armor_Equipped_Check()
		|| ACS_VGX_Eredin_Armor_Equipped_Check()
		)
		{
			thePlayer.SoundEvent( "monster_caretaker_mv_cloth_hard" );

			thePlayer.SoundEvent( "monster_caretaker_mv_footstep" );
		}

		if (
		GetWitcherPlayer().HasTag('acs_bow_active')
		|| GetWitcherPlayer().HasTag('acs_crossbow_active')
		)
		{
			forgotten_wolf_school_rolls();
		}
		else
		{
			if (GetWitcherPlayer().HasTag('acs_vampire_claws_equipped')
			|| GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
			|| GetWitcherPlayer().HasTag('acs_sorc_fists_equipped')
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
				if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
				{
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
								GetWitcherPlayer().SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
									GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
								}

								front_dodge_skate();
								
								GetACSWatcher().ACS_StaminaDrain(4);
							}
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
								GetWitcherPlayer().SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
									GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
								}

								right_dodge_skate();
		
								GetACSWatcher().ACS_StaminaDrain(4);
							}
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
								GetWitcherPlayer().SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
									GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
								}

								left_dodge_skate();

								GetACSWatcher().ACS_StaminaDrain(4);
							}
						}
					}
					else
					{
						if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
						&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
						)
						{
							ACS_Weapon_Respawn();

							GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

							GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
						}

						GetACSWatcher().dodge_timer_attack_actual();

						if (ACS_DefaultGeraltMovesetOverrideModeRoll_Enabled() && !thePlayer.IsWeaponHeld('fist'))
						{
							geralt_moveset_roll_override_mode();
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
				else
				{
					if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
					&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
					)
					{
						ACS_Weapon_Respawn();

						GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

						GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
					}

					GetACSWatcher().dodge_timer_attack_actual();

					if (ACS_DefaultGeraltMovesetOverrideModeRoll_Enabled() && !thePlayer.IsWeaponHeld('fist'))
					{
						geralt_moveset_roll_override_mode();
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
	
	latent function vampire_claws_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0 ) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();
					
					//ACS_Dodge();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function yrden_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
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
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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
		
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_right_dodge_alt();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}
					
					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_left_dodge_alt();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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

					ACSDodgeMovementAdjust('forwardleft');
		
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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

					ACSDodgeMovementAdjust('forwardright');
		
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_right_dodge_alt();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}
					
					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_left_dodge_alt();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function yrden_secondary_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
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
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
					{
						two_hand_front_dodge();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_right_dodge();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_left_dodge();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
					{
						two_hand_front_dodge();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
					{
						two_hand_front_dodge();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_right_dodge();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_left_dodge();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function axii_secondary_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
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
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_sword_right_dodge();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_sword_left_dodge();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_sword_right_dodge();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_sword_left_dodge();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_sword_right_dodge();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_sword_left_dodge();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function quen_secondary_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
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
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function aard_secondary_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
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
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
					{
						one_hand_sword_front_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function igni_sword_rolls()
	{
		if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
		)
		{
			ACS_Weapon_Respawn();

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

			GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
		}

		if (ACS_Zireael_Check())
		{
			ciri_rolls();
		}
		else
		{
			if (ACS_Wolf_School_Check() || ACS_Armor_Omega_Equipped_Check() || ACS_Armor_Alpha_Equipped_Check() )
			{
				wolf_school_rolls();
			}
			else if (ACS_Bear_School_Check())
			{
				bear_school_rolls();
			}
			else if (ACS_Cat_School_Check() )
			{
				cat_school_rolls();
			}
			else if (ACS_Griffin_School_Check())
			{
				griffin_school_rolls();
			}
			else if (ACS_Manticore_School_Check())
			{
				manticore_school_rolls();
			}
			else if (ACS_Forgotten_Wolf_Check())
			{
				forgotten_wolf_school_rolls();
			}
			else if (ACS_Viper_School_Check())
			{
				viper_school_rolls();
			}
			else
			{
				if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
				{
					if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
								GetWitcherPlayer().SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
									GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
								}

								front_dodge_skate();
								
								GetACSWatcher().ACS_StaminaDrain(4);
							}
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
								GetWitcherPlayer().SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
									GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
								}

								right_dodge_skate();

								GetACSWatcher().ACS_StaminaDrain(4);
							}
						}
					}
					else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
					{
						if (ACS_can_dodge())
						{
							if ( ACS_StaminaBlockAction_Enabled() 
							&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
							)
							{
								GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
								GetWitcherPlayer().SoundEvent("gui_no_stamina");
							}
							else
							{
								ACS_refresh_dodge_cooldown();

								if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
								{
									GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
									GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

									GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
									GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
								}

								left_dodge_skate();

								GetACSWatcher().ACS_StaminaDrain(4);
							}
						}
					}
					else
					{
						if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
						&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
						)
						{
							ACS_Weapon_Respawn();

							GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

							GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
						}

						GetACSWatcher().dodge_timer_attack_actual();

						if (ACS_DefaultGeraltMovesetOverrideModeRoll_Enabled() && !thePlayer.IsWeaponHeld('fist'))
						{
							geralt_moveset_roll_override_mode();
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
				else
				{
					if ( ACS_StaminaBlockAction_Enabled() 
					&& GetACSWatcher().StaminaCheck()
					)
					{							 
						if(thePlayer.IsInCombat()){thePlayer.RaiseEvent( 'CombatTaunt' );} thePlayer.SoundEvent("gui_no_stamina");
					}
					else
					{
						if (GetWitcherPlayer().HasTag('ACS_HideWeaponOnDodge') 
						&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
						)
						{
							ACS_Weapon_Respawn();

							GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge');

							GetWitcherPlayer().RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
						}

						GetACSWatcher().dodge_timer_attack_actual();

						if (ACS_DefaultGeraltMovesetOverrideModeRoll_Enabled() && !thePlayer.IsWeaponHeld('fist'))
						{
							geralt_moveset_roll_override_mode();
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
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function geralt_moveset_roll_override_mode()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 0)
					{
						override_mode_back_dodge_1();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 1)
					{
						override_mode_back_dodge_2();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 2)
					{
						override_mode_back_dodge_3();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 3)
					{
						override_mode_back_dodge_4();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 4)
					{
						override_mode_back_dodge_5();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 5)
					{
						override_mode_back_dodge_6();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 6)
					{
						override_mode_back_dodge_7();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 7)
					{
						override_mode_back_dodge_8();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeBackwardRollOptions() == 8)
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
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
					{
						if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 0)
						{
							override_mode_front_dodge_1();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 1)
						{
							override_mode_front_dodge_2();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 2)
						{
							override_mode_front_dodge_3();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 3)
						{
							override_mode_front_dodge_4();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 4)
						{
							override_mode_front_dodge_5();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 5)
						{
							override_mode_front_dodge_6();
						}
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 0)
						{
							override_mode_right_dodge_1();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 1)
						{
							override_mode_right_dodge_2();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 2)
						{
							override_mode_right_dodge_3();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 3)
						{
							override_mode_right_dodge_4();
						}
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 0)
						{
							override_mode_left_dodge_1();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 1)
						{
							override_mode_left_dodge_2();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 2)
						{
							override_mode_left_dodge_3();
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 3)
						{
							override_mode_left_dodge_4();
						}
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 0)
						{
							override_mode_right_dodge_1();

							ACSDodgeMovementAdjust('forwardright');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 1)
						{
							override_mode_right_dodge_2();

							ACSDodgeMovementAdjust('forwardright');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 2)
						{
							override_mode_right_dodge_3();

							ACSDodgeMovementAdjust('forwardright');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 3)
						{
							if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 0)
							{
								override_mode_front_dodge_1();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 1)
							{
								override_mode_front_dodge_2();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 2)
							{
								override_mode_front_dodge_3();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 3)
							{
								override_mode_front_dodge_4();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 4)
							{
								override_mode_front_dodge_5();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 5)
							{
								override_mode_front_dodge_6();
							}

							ACSDodgeMovementAdjust('forwardleft');
						}
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 0)
						{
							override_mode_left_dodge_1();

							ACSDodgeMovementAdjust('forwardleft');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 1)
						{
							override_mode_left_dodge_2();

							ACSDodgeMovementAdjust('forwardleft');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 2)
						{
							override_mode_left_dodge_3();

							ACSDodgeMovementAdjust('forwardleft');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 3)
						{
							if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 0)
							{
								override_mode_front_dodge_1();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 1)
							{
								override_mode_front_dodge_2();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 2)
							{
								override_mode_front_dodge_3();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 3)
							{
								override_mode_front_dodge_4();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 4)
							{
								override_mode_front_dodge_5();
							}
							else if (ACS_DefaultGeraltMovesetOverrideModeForwardRollOptions() == 5)
							{
								override_mode_front_dodge_6();
							}

							ACSDodgeMovementAdjust('forwardright');
						}
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 0)
						{
							override_mode_right_dodge_1();

							ACSDodgeMovementAdjust('backright');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 1)
						{
							override_mode_right_dodge_2();

							ACSDodgeMovementAdjust('backright');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 2)
						{
							override_mode_right_dodge_3();

							ACSDodgeMovementAdjust('backright');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeRightRollOptions() == 3)
						{
							override_mode_right_dodge_4();

							ACSDodgeMovementAdjust('backleft');
						}
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 0)
						{
							override_mode_left_dodge_1();

							ACSDodgeMovementAdjust('backleft');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 1)
						{
							override_mode_left_dodge_2();

							ACSDodgeMovementAdjust('backleft');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 2)
						{
							override_mode_left_dodge_3();

							ACSDodgeMovementAdjust('backleft');
						}
						else if (ACS_DefaultGeraltMovesetOverrideModeLeftRollOptions() == 3)
						{
							override_mode_left_dodge_4();

							ACSDodgeMovementAdjust('backright');
						}
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 0)
					{
						override_mode_back_dodge_1();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 1)
					{
						override_mode_back_dodge_2();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 2)
					{
						override_mode_back_dodge_3();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 3)
					{
						override_mode_back_dodge_4();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 4)
					{
						override_mode_back_dodge_5();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 5)
					{
						override_mode_back_dodge_6();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 6)
					{
						override_mode_back_dodge_7();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 7)
					{
						override_mode_back_dodge_8();
					}
					else if (ACS_DefaultGeraltMovesetOverrideModeNeutralRollOptions() == 8)
					{
						override_mode_back_dodge_9();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
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
	
	latent function wolf_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_4();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_4();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_4();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_4();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_4();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_4();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function bear_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_sword_right_dodge();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_sword_left_dodge();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_sword_right_dodge();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_sword_left_dodge();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						two_hand_sword_right_dodge();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						two_hand_sword_left_dodge();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function cat_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_front_dodge_alt_3();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_right_dodge_alt_3();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_left_dodge_alt_3();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_right_dodge_alt_3();
					}
					
					ACSDodgeMovementAdjust('forwardright');

					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_left_dodge_alt_3();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_right_dodge_alt_3();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_left_dodge_alt_3();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function griffin_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function manticore_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function forgotten_wolf_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
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
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_2();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
	}

	latent function viper_school_rolls()
	{
		if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_front_dodge_alt_3();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_right_dodge_alt_3();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_left_dodge_alt_3();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_right_dodge_alt_3();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_left_dodge_alt_3();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_right_dodge_alt_3();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
					{
						GetWitcherPlayer().PlayEffectSingle( 'magic_step_l_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_l_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'magic_step_r_new' );
						GetWitcherPlayer().StopEffect( 'magic_step_r_new' );	

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
					}

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						left_dodge_skate();
					}
					else
					{
						cat_one_hand_sword_left_dodge_alt_3();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active') && ACS_DodgeEffects_Enabled() )
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
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

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
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeFront();

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						front_dodge_skate();
					}
					else
					{
						if (RandF() < 0.5)
						{
							one_hand_sword_front_dodge_alt_1_long();
						}
						else
						{
							one_hand_sword_front_dodge_long();
						}
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') > 0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0)
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeRight();

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_4_long();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') == 0) 
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeLeft();

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_4_long();
					}
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeRight();

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_4_long();
					}

					ACSDodgeMovementAdjust('forwardright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') > 0.1 && theInput.GetActionValue('GI_AxisLeftX') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeLeft();

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_4_long();
					}

					ACSDodgeMovementAdjust('forwardleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftY') < -0.1 && theInput.GetActionValue('GI_AxisLeftX') > 0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeRight();

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat() && ACS_Skate_Enabled()) 
					{
						right_dodge_skate();
					}
					else
					{
						one_hand_sword_right_dodge_alt_4_long();
					}

					ACSDodgeMovementAdjust('backright');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.1 && theInput.GetActionValue('GI_AxisLeftY') < -0.1 )
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeLeft();

					if ( GetWitcherPlayer().IsGuarded() && !GetWitcherPlayer().IsInCombat()) 
					{
						left_dodge_skate();
					}
					else
					{
						one_hand_sword_left_dodge_alt_4_long();
					}

					ACSDodgeMovementAdjust('backleft');
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
		else
		{
			if (ACS_can_dodge())
			{
				if ( ACS_StaminaBlockAction_Enabled() 
				&& GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15
				)
				{
					GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
					GetWitcherPlayer().SoundEvent("gui_no_stamina");
				}
				else
				{
					ACS_refresh_dodge_cooldown();

					GetWitcherPlayer().DestroyEffect('dodge_ciri');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

					GetACSWatcher().CiriSpectreDodgeBack();

					one_hand_sword_back_dodge_alt_3_long();
					
					GetACSWatcher().ACS_StaminaDrain(4);
				}
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
			//movementAdjustor.RotateTowards( ticket, actor );
					
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_to_walk_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2 ) + theCamera.GetCameraDirection() * 2 );			
		}
		else
		{			
			GetACSWatcher().dodge_timer_actual();

			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
				
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_f_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'bruxa_move_run_to_walk_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			
			//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2 ) + theCamera.GetCameraDirection() * 2 );		
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
			
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}

		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 60, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/
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
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{				
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'dialogue_man_geralt_sword_dodge_back_350', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}

		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 60, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
		
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/
	}

	latent function two_hand_right_dodge_alt()
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

		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 60, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -5 ) );
				
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_right_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/
	}

	latent function two_hand_left_dodge_alt()
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

		/*
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if (GetWitcherPlayer().IsEnemyInCone( actor, GetWitcherPlayer().GetHeadingVector(), 50, 60, actor ))
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
			
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				movementAdjustor.RotateTowards( ticket, actor );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 5 ) );
		
			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_flip_left_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));

			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_sword_dodge_pirouette_rp_b_01', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
		}
		*/
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

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 4 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 4) );

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

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 4 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 4) );
		
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
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
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

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_ger_sword_dodge_b_02', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
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

		GetACSWatcher().dodge_timer_attack_ciri_actual();

		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 1.1 ) );

		movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -4 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * -4) );

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
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active')
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
		&& ACS_DodgeEffects_Enabled())
		{
			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails_backup' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails_backup' );
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

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

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5) );

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

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5) );

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

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -4 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -4) );

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

		movementAdjustor.SlideTo( ticket, ( ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 4 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 4) );

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

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function front_dodge_skate()
	{
		ticket = movementAdjustor.GetRequest( 'one_hand_sword_front_dodge_alt_2');
		
		movementAdjustor.CancelByName( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'one_hand_sword_front_dodge_alt_2' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().dodge_timer_attack_actual();

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 2.5) );
		}
		else
		{			
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );

			movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraForward() * 2.5) );
		}
		
		GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails_backup' );
		GetWitcherPlayer().StopEffect( 'bruxa_dash_trails_backup' );

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.5 ) 
		{
			if( RandF() < 0.75 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_l', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_r', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
		else
		{
			if( RandF() < 0.75 ) 
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_02_loop_l', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
			else
			{
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_02_loop_r', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
			}
		}
	}

	latent function left_dodge_skate()
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

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * -1.5 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails_backup' );
		GetWitcherPlayer().StopEffect( 'bruxa_dash_trails_backup' );

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.75 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_l_turn_l', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_r_turn_l', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	latent function right_dodge_skate()
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

		//movementAdjustor.SlideTo( ticket, ( GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5 ) + theCamera.GetCameraDirection() + theCamera.GetCameraRight() * 1.5 );

		GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
								
		//if (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15){GetWitcherPlayer().SetAnimationSpeedMultiplier( 1  ); }else{GetWitcherPlayer().SetAnimationSpeedMultiplier( 1.25  ); }	
				
		//GetACSWatcher().AddTimer('ACS_ResetAnimation', 0.5 , false);

		GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails_backup' );
		GetWitcherPlayer().StopEffect( 'bruxa_dash_trails_backup' );

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 0.5f, 50.f, 0);

		if( RandF() < 0.75 ) 
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_l_turn_r', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
		else
		{
			GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'ice_skating_attack_loop_r_turn_r', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));	
		}
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

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
		&& !GetWitcherPlayer().HasTag('acs_blood_sucking')
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
			
			GetACSWatcher().AddTimer('ACS_dodge_timer_wildhunt', 0.45 / GetWitcherPlayer().GetAnimationTimeMultiplier() , false);
			
			/*
			movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
			movementAdjustor.CancelAll();

			

			

			

			GetWitcherPlayer().ResetRawPlayerHeading();

			ticket = movementAdjustor.CreateNewRequest( 'wh_blink' );
			movementAdjustor.AdjustmentDuration( ticket, 0.25 );
			movementAdjustor.RotateTowards( ticket, actor );
			movementAdjustor.SlideTo(ticket, pos);
			*/
		}
	}
}