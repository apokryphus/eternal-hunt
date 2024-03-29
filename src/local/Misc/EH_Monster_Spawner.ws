
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Ghoul_Venom
{
	function ACS_Ghoul_Venom_Start_Engage()
	{
		this.PushState('ACS_Ghoul_Venom_Start_Engage');
	}

    function ACS_Ghoul_Venom_Engage()
	{
		this.PushState('ACS_Ghoul_Venom_Engage');
	}
}

state ACS_Ghoul_Venom_Start_Engage in cACS_Ghoul_Venom
{
	private var actors															: array<CActor>;
	private var i, num 															: int;
	private var npc 															: CNewNPC;
	private var actor 															: CActor;
	private var proj_1, proj_2, proj_3	 										: W3ACSPoisonProjectile;
	private var initpos, targetPosition											: Vector;
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;
	private var targetDistance													: float;
	private var ghoulAnimatedComponent 											: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Ghoul_Venom_Start_Entry();
	}
	
	entry function ACS_Ghoul_Venom_Start_Entry()
	{
		ACS_Ghoul_Venom_Start_Latent();
	}
	
	latent function ACS_Ghoul_Venom_Start_Latent()
	{
		if (theGame.GetDifficultyLevel() == EDM_Easy)
		{
			num = 1;
		}
		else if (theGame.GetDifficultyLevel() == EDM_Medium)
		{
			num = 2;
		}
		else if (theGame.GetDifficultyLevel() == EDM_Hard)
		{
			num = 3;
		}
		else if (theGame.GetDifficultyLevel() == EDM_Hardcore)
		{
			num = 4;
		}
		else
		{
			num = 1;
		}

		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, num, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				npc.HasAbility('mon_ghoul_base')
				&& (npc.GetStat(BCS_Stamina) >= npc.GetStatMax(BCS_Stamina) * 0.25)
				)
				{
					if (
					npc.HasBuff(EET_Knockdown)
					|| npc.HasBuff(EET_HeavyKnockdown)
					|| npc.HasBuff(EET_Ragdoll)
					|| npc.HasBuff(EET_Burning)
					|| npc.HasBuff(EET_Frozen)
					|| npc.HasBuff(EET_LongStagger)
					|| npc.HasBuff(EET_Stagger)
					|| npc.HasBuff(EET_Weaken)
					|| npc.HasBuff(EET_Confusion)
					|| npc.HasBuff(EET_AxiiGuardMe)
					|| npc.HasBuff(EET_Hypnotized)
					|| npc.HasBuff(EET_Immobilized)
					|| npc.HasBuff(EET_Paralyzed)
					|| npc.HasBuff(EET_Blindness)
					|| npc.HasBuff(EET_Choking)
					|| npc.HasBuff(EET_Swarm)
					|| npc.HasTag('ACS_Canaris_Minion')
					)			
					{
						return;
					}
					
					if( targetDistance >= 4.5 * 4.5 ) 
					{
						if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
						{
							theSound.SoundLoadBank( "monster_toad.bnk", false );
						}

						if ( !theSound.SoundIsBankLoaded("monster_golem_ice.bnk") )
						{
							theSound.SoundLoadBank( "monster_golem_ice.bnk", false );
						}

						if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
						{
							theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
						}

						movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

						ghoulAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

						ticket = movementAdjustor.GetRequest( 'ACS_Ghoul_Proj_Rotate_1');
						movementAdjustor.CancelByName( 'ACS_Ghoul_Proj_Rotate_1' );
						movementAdjustor.CancelAll();
						ticket = movementAdjustor.CreateNewRequest( 'ACS_Ghoul_Proj_Rotate_1' );
						movementAdjustor.AdjustmentDuration( ticket, 1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

						ghoulAnimatedComponent.PlaySlotAnimationAsync ( 'rage', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

						npc.AddBuffImmunity(EET_Poison, 'ACS_Ghoul_Proj_Poison_Negate', true);

						npc.AddBuffImmunity(EET_PoisonCritical , 'ACS_Ghoul_Proj_Poison_Negate', true);

						npc.AddTag('ACS_Ghoul_Venom_Init');

						npc.PlayEffectSingle('morph_fx');
						npc.StopEffect('morph_fx');

						npc.SoundEvent('monster_ghoul_morph_loop_stop');

						npc.DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ) * 0.25, 4 );

						npc.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
						npc.SetCanPlayHitAnim(false); 
						npc.AddBuffImmunity_AllNegative('acs_ghoul_immune', true); 

						npc.SetInteractionPriority( IP_Prio_10 );
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

state ACS_Ghoul_Venom_Engage in cACS_Ghoul_Venom
{
	private var actors																				: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor 																				: CActor;
	private var proj_1, proj_2, proj_3	 															: W3ACSPoisonProjectile;
	private var ice_proj_1, ice_proj_2, ice_proj_3  												: W3WHMinionProjectile;
	private var initpos, targetPosition, targetPosition_1, targetPosition_2, targetPosition_3		: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ghoulAnimatedComponent 																: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Ghoul_Venom_Entry();
	}
	
	entry function ACS_Ghoul_Venom_Entry()
	{
		ACS_Ghoul_Venom_Latent();
	}
	
	latent function ACS_Ghoul_Venom_Latent()
	{
		actors.Clear();
		
		theGame.GetActorsByTag( 'ACS_Ghoul_Venom_Init', actors );	

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				npc.HasAbility('mon_ghoul_base')
				&& npc.HasTag('ACS_Ghoul_Venom_Init')
				)
				{
					npc.SetImmortalityMode( AIM_None, AIC_Combat ); 
					npc.SetCanPlayHitAnim(true); 
					npc.RemoveBuffImmunity_AllNegative('acs_ghoul_immune'); 

					npc.SetInteractionPriority( IP_Prio_3 );

					npc.RemoveTag('ACS_Ghoul_Venom_Init');

					npc.PlayEffectSingle('morph_fx');
					npc.StopEffect('morph_fx');

					npc.SoundEvent('monster_ghoul_morph_loop_stop');

					ghoulAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

					movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

					ticket = movementAdjustor.GetRequest( 'ACS_Ghoul_Proj_Rotate_2');
					movementAdjustor.CancelByName( 'ACS_Ghoul_Proj_Rotate_2' );
					movementAdjustor.CancelAll();
					ticket = movementAdjustor.CreateNewRequest( 'ACS_Ghoul_Proj_Rotate_2' );
					movementAdjustor.AdjustmentDuration( ticket, 1 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

					//ghoulAnimatedComponent.PlaySlotAnimationAsync ( 'rage', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

					npc.AddBuffImmunity(EET_Poison, 'ACS_Ghoul_Proj_Poison_Negate', true);

					npc.AddBuffImmunity(EET_PoisonCritical , 'ACS_Ghoul_Proj_Poison_Negate', true);

					//initpos = npc.GetWorldPosition() + npc.GetWorldForward() * 0.5 ;

					initpos = npc.GetBoneWorldPosition('head');	

					initpos.Y += 0.25;
							
					targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
					targetPosition.Z += 0.5;

					targetPosition_1 = GetWitcherPlayer().PredictWorldPosition(0.1f);
					targetPosition_1.Z += 0.5;

					targetPosition_2 = GetWitcherPlayer().PredictWorldPosition(0.5f);
					targetPosition_2.Z += 0.5;

					targetPosition_3 = GetWitcherPlayer().PredictWorldPosition(1.0f);
					targetPosition_3.Z += 0.5;

					if ( npc.HasAbility('mon_ghoul_lesser')
					|| npc.HasAbility('mon_ghoul')
					|| npc.HasAbility('mon_ghoul_stronger')
					|| npc.HasAbility('mon_EP2_ghouls')
					|| npc.HasAbility('ghoul_hardcore')
					)
					{ 	
						proj_1 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_1.Init(npc);

						npc.SoundEvent('monster_toad_fx_mucus_spit');

						//proj_1.PlayEffectSingle('spit_travel');

						proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
						proj_1.DestroyAfter(10);
					}
					else if ( 
					npc.HasAbility('mon_alghoul')
					)
					{ 	
						proj_1 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_1.Init(npc);

						npc.SoundEvent('monster_toad_fx_mucus_spit');

						//proj_1.PlayEffectSingle('spit_travel');

						proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition_1, 500 );
						proj_1.DestroyAfter(10);

						Sleep(0.375);

						proj_2 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_2.Init(npc);

						npc.SoundEvent('monster_toad_fx_mucus_spit');

						//proj_2.PlayEffectSingle('spit_travel');

						proj_2.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition_2, 500 );
						proj_2.DestroyAfter(10);

						Sleep(0.375);

						proj_3 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_3.Init(npc);

						npc.SoundEvent('monster_toad_fx_mucus_spit');

						proj_3.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition_3, 500 );
						proj_3.DestroyAfter(10);
					}
					else if (
					npc.HasAbility('mon_greater_miscreant')
					)
					{ 	
						proj_1 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_1.Init(npc);
						npc.SoundEvent('monster_toad_fx_mucus_spit');

						//proj_1.PlayEffectSingle('spit_travel');

						proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
						proj_1.DestroyAfter(10);

						proj_2 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_2.Init(npc);

						//proj_2.PlayEffectSingle('spit_travel');

						proj_2.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5, 500 );
						proj_2.DestroyAfter(10);


						proj_3 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
							
							, true ), initpos );
										
						proj_3.Init(npc);

						//proj_3.PlayEffectSingle('spit_travel');

						//proj_3.PlayEffectSingle('spit_hit');
						proj_3.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5, 500 );
						proj_3.DestroyAfter(10);
					}
					else if (
					npc.HasAbility('mon_wild_hunt_minionMH')
					)
					{
						npc.PlayEffectSingle('rift_fx_special');
						npc.PlayEffectSingle('rift_fx_special');
						npc.PlayEffectSingle('rift_fx_special');
						npc.StopEffect('rift_fx_special');

						npc.PlayEffectSingle('morph_fx_copy');
						npc.PlayEffectSingle('morph_fx_copy');
						npc.PlayEffectSingle('morph_fx_copy');
						npc.StopEffect('morph_fx_copy');

						npc.StopEffect('r_trail_snow');
						npc.PlayEffectSingle('r_trail_snow');
						npc.PlayEffectSingle('r_trail_snow');
						npc.PlayEffectSingle('r_trail_snow');

						npc.StopEffect('l_trail_snow');
						npc.PlayEffectSingle('l_trail_snow');
						npc.PlayEffectSingle('l_trail_snow');
						npc.PlayEffectSingle('l_trail_snow');

						npc.StopEffect('ice_armor');
						npc.PlayEffectSingle('ice_armor');
						npc.PlayEffectSingle('ice_armor');
						npc.PlayEffectSingle('ice_armor');
						npc.PlayEffectSingle('ice_armor');
						npc.PlayEffectSingle('ice_armor');
						npc.PlayEffectSingle('ice_armor');
						npc.PlayEffectSingle('ice_armor');

						npc.PlayEffectSingle('marker');
						npc.PlayEffectSingle('marker');
						npc.PlayEffectSingle('marker');
						npc.StopEffect('marker');

						npc.SoundEvent('monster_wildhunt_minion_ice_spike_out');
						GetWitcherPlayer().SoundEvent('monster_wildhunt_minion_ice_spike_out');

						ice_proj_1 = (W3WHMinionProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
							
							, true ), initpos );
										
						ice_proj_1.Init(npc);
						ice_proj_1.PlayEffectSingle('fire_line');
						ice_proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
						ice_proj_1.DestroyAfter(10);

						ice_proj_2 = (W3WHMinionProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
							
							, true ), initpos );
										
						ice_proj_2.Init(npc);
						ice_proj_2.PlayEffectSingle('fire_line');
						ice_proj_2.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 3, 500 );
						ice_proj_2.DestroyAfter(10);

						ice_proj_3 = (W3WHMinionProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
							
							, true ), initpos );
										
						ice_proj_3.Init(npc);
						ice_proj_3.PlayEffectSingle('fire_line');
						ice_proj_3.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -3, 500 );
						ice_proj_3.DestroyAfter(10);
					}
					else if (
					npc.HasAbility('mon_wild_hunt_minion')
					)
					{
						npc.PlayEffectSingle('rift_fx_special');
						npc.StopEffect('rift_fx_special');

						npc.PlayEffectSingle('morph_fx_copy');
						npc.StopEffect('morph_fx_copy');

						npc.StopEffect('r_trail_snow');
						npc.PlayEffectSingle('r_trail_snow');

						npc.StopEffect('l_trail_snow');
						npc.PlayEffectSingle('l_trail_snow');

						npc.PlayEffectSingle('marker');
						npc.StopEffect('marker');

						npc.SoundEvent('monster_wildhunt_minion_ice_spike_out');
						GetWitcherPlayer().SoundEvent('monster_wildhunt_minion_ice_spike_out');

						ice_proj_1 = (W3WHMinionProjectile)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
							
							, true ), initpos );
										
						ice_proj_1.Init(npc);
						ice_proj_1.PlayEffectSingle('fire_line');
						ice_proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
						ice_proj_1.DestroyAfter(10);
					}

					/*
					proj_2 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
						
						, true ), initpos );
									
					proj_2.Init(npc);
					proj_2.PlayEffectSingle('spit_travel');
					proj_2.PlayEffectSingle('spit_hit');
					proj_2.ShootProjectileAtPosition( 0, 10 + RandRangeF(5 , 0), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 3, 500 );
					proj_2.DestroyAfter(10);


					proj_3 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\entities\projectiles\ghoul_projectile.w2ent"
						
						, true ), initpos );
									
					proj_3.Init(npc);
					proj_3.PlayEffectSingle('spit_travel');
					proj_3.PlayEffectSingle('spit_hit');
					proj_3.ShootProjectileAtPosition( 0, 10 + RandRangeF(5 , 0), GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -3, 500 );
					proj_3.DestroyAfter(10);
					*/
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Witch_Hunter_Throw_Bomb
{
	function ACS_Witch_Hunter_Throw_Bomb_Engage()
	{
		this.PushState('ACS_Witch_Hunter_Throw_Bomb_Engage');
	}

	function ACS_Witch_Hunter_Throw_Bomb_Actual_Engage()
	{
		this.PushState('ACS_Witch_Hunter_Throw_Bomb_Actual_Engage');
	}
}

state ACS_Witch_Hunter_Throw_Bomb_Engage in cACS_Witch_Hunter_Throw_Bomb
{
	private var actors															: array<CActor>;
	private var i 																: int;
	private var npc 															: CNewNPC;
	private var actor 															: CActor;
	private var proj_1															: W3Dimeritium;
	private var initpos, targetPosition											: Vector;
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;
	private var targetDistance, chance											: float;
	private var witchHunterAnimatedComponent, animatedComponentA 				: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Witch_Hunter_Throw_Bomb_Entry();
	}
	
	entry function ACS_Witch_Hunter_Throw_Bomb_Entry()
	{
		ACS_Witch_Hunter_Throw_Bomb_Latent();
	}
	
	latent function ACS_Witch_Hunter_Throw_Bomb_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 3, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				if (
				npc.IsHuman()
				&& npc.IsMan()
				&& !npc.IsWoman()
				&& npc.IsAnyWeaponHeld()
				&& ((CNewNPC)npc).GetNPCType() != ENGT_Quest
				&& !npc.HasTag( 'ethereal' )
				&& !npc.HasBuff(EET_Burning)
				&& !npc.HasBuff(EET_HeavyKnockdown)
				&& !npc.HasBuff(EET_Knockdown)
				&& !npc.HasBuff(EET_LongStagger)
				&& !npc.HasBuff(EET_Stagger)
				&& !npc.HasBuff(EET_Weaken)
				&& !npc.HasBuff(EET_WeakeningAura)
				&& !npc.HasBuff(EET_Confusion)
				&& !npc.HasBuff(EET_AxiiGuardMe)
				&& !npc.HasBuff(EET_Hypnotized)
				&& !npc.HasBuff(EET_Immobilized)
				&& !npc.HasBuff(EET_Paralyzed)
				&& !npc.HasBuff(EET_Blindness)
				&& !npc.HasBuff(EET_Choking)
				&& !npc.HasBuff(EET_Swarm)
				&& !npc.IsUsingHorse()
				&& !npc.IsUsingVehicle()
				&& !npc.GetInventory().HasItem('crossbow')
				&& !npc.GetInventory().HasItem('bow')
				&& !npc.GetInventory().HasItemByTag('crossbow')
				&& !npc.GetInventory().HasItemByTag('bow')
				&& !npc.HasAbility( 'q604_shades' )
				&& !npc.HasTag('ACS_Final_Bomb_Thrown')
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !npc.HasTag('ACS_Poise_Finisher')
				&& !npc.HasTag('ACS_Shades_Crusader')
				&& GetACSWatcher().ACS_Rage_Process == false
				&& !animatedComponentA.HasFrozenPose()
				&& !npc.GetIsRecoveringFromKnockdown()
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Fists
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Undefined
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Crossbow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Bow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_None
				)
				{
					if (!npc.HasTag('ACS_Bomber'))
					{ 
						npc.AddTag('ACS_Bomber');
					}

					if( 
					targetDistance >= 3.5 * 3.5
					//&& Bomb_Obstruct_Check()
					) 
					{
						if ( npc.HasTag('ACS_Shades_Hunter')
						)
						{
							chance = 0.99;
						}
						else
						{
							if (StrContains( npc.GetReadableName(), "witch_hunter" ) 
							|| StrContains( npc.GetReadableName(), "inq_" )
							)
							{
								if (theGame.GetDifficultyLevel() == EDM_Easy)
								{
									chance = 0.3;
								}
								else if (theGame.GetDifficultyLevel() == EDM_Medium)
								{
									chance = 0.4;
								}
								else if (theGame.GetDifficultyLevel() == EDM_Hard)
								{
									chance = 0.5;
								}
								else if (theGame.GetDifficultyLevel() == EDM_Hardcore)
								{
									chance = 0.75;
								}
								else
								{
									chance = 0.5;
								}
							}
							else
							{
								if (theGame.GetDifficultyLevel() == EDM_Easy)
								{
									chance = 0.2;
								}
								else if (theGame.GetDifficultyLevel() == EDM_Medium)
								{
									chance = 0.3;
								}
								else if (theGame.GetDifficultyLevel() == EDM_Hard)
								{
									chance = 0.4;
								}
								else if (theGame.GetDifficultyLevel() == EDM_Hardcore)
								{
									chance = 0.5;
								}
								else
								{
									chance = 0.5;
								}
							}
						}

						if( RandF() < chance ) 
						{
							if (RandF() < 0.5)
							{
								if (!npc.GetInventory().HasItem('ACS_Knife'))
								{
									npc.GetInventory().AddAnItem('ACS_Knife', 1);
								}
							}

							npc.AddBuffImmunity_AllNegative('ACS_Bomber', true);

							npc.AddBuffImmunity_AllCritical('ACS_Bomber', true);

							movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

							ticket = movementAdjustor.GetRequest( 'ACS_Witch_Hunter_Proj_Rotate_1');
							movementAdjustor.CancelByName( 'ACS_Witch_Hunter_Proj_Rotate_1' );
							movementAdjustor.CancelAll();
							ticket = movementAdjustor.CreateNewRequest( 'ACS_Witch_Hunter_Proj_Rotate_1' );
							movementAdjustor.AdjustmentDuration( ticket, 0.5 );
							movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

							movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

							witchHunterAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

							witchHunterAnimatedComponent.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_throw_bomb_01_rp_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

							GetACSWatcher().RemoveTimer('Witch_Hunter_Throw_Bomb_Delay_Timer');
							GetACSWatcher().AddTimer('Witch_Hunter_Throw_Bomb_Delay_Timer', 0.5, false);

							/*
							if (RandF() < 0.5)
							{
								if (RandF() < 0.5)
								{
									witchHunterAnimatedComponent.PlaySlotAnimationAsync ( 'man_npc_longsword_petard_aim_shoot_rp_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
									
									GetACSWatcher().RemoveTimer('Witch_Hunter_Throw_Bomb_Delay');
									GetACSWatcher().AddTimer('Witch_Hunter_Throw_Bomb_Delay', 0.25, false);
								}
								else
								{
									witchHunterAnimatedComponent.PlaySlotAnimationAsync ( 'man_npc_petard_aim_shoot_rp_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

									GetACSWatcher().RemoveTimer('Witch_Hunter_Throw_Bomb_Delay');
									GetACSWatcher().AddTimer('Witch_Hunter_Throw_Bomb_Delay', 0.25, false);
								}
							}
							else
							{
								witchHunterAnimatedComponent.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_throw_bomb_01_rp_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

								GetACSWatcher().RemoveTimer('Witch_Hunter_Throw_Bomb_Delay');
								GetACSWatcher().AddTimer('Witch_Hunter_Throw_Bomb_Delay', 0.5, false);
							}
							*/
							
							npc.AddTag('ACS_Throw_Bomb_Init');
						}
					}
				}
			}
		}
	}

	function Bomb_Obstruct_Check(): bool
	{
		var tempEndPoint_1, tempEndPoint_2, normal_1, normal_2, bomberPos			: Vector;
		var collisionGroupsNames													: array<name>;	

		collisionGroupsNames.Clear();

		collisionGroupsNames.PushBack( 'Terrain');
		//collisionGroupsNames.PushBack( 'Static');
		collisionGroupsNames.PushBack( 'Water'); 
        //collisionGroupsNames.PushBack( 'Door' );
        //collisionGroupsNames.PushBack( 'Dangles' );
        //collisionGroupsNames.PushBack( 'Foliage' );
        //collisionGroupsNames.PushBack( 'Destructible' );
        //collisionGroupsNames.PushBack( 'RigidBody' );
        //collisionGroupsNames.PushBack( 'Boat' );
        //collisionGroupsNames.PushBack( 'BoatDocking' );
        //collisionGroupsNames.PushBack( 'Platforms' );
        //collisionGroupsNames.PushBack( 'Corpse' );
        //collisionGroupsNames.PushBack( 'Ragdoll' ); 

		bomberPos = ACSGetBomber().GetWorldPosition();

		//bomberPos.Z += 1.25;

		if ( theGame.GetWorld().StaticTrace( bomberPos, bomberPos + ACSGetBomber().GetHeadingVector() * 2.25, tempEndPoint_1, normal_1, collisionGroupsNames )
		//|| theGame.GetWorld().StaticTrace( bomberPos, bomberPos + ACSGetBomber().GetWorldRight() * -1.5, tempEndPoint_2, normal_2, collisionGroupsNames)	
		)
		{
			return false;
		}
		
		return true;
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Witch_Hunter_Throw_Bomb_Actual_Engage in cACS_Witch_Hunter_Throw_Bomb
{
	private var actors															: array<CActor>;
	private var i, num 															: int;
	private var npc 															: CNewNPC;
	private var actor 															: CActor;
	private var proj_Dimeritium													: W3ACSEnemyDimeritium;
	private var proj_Shrapnel													: W3ACSPetard;
	private var proj_knife														: W3ACSEnemyKnifeProjectile;
	private var chance															: float;
	private var animatedComponentA 												: CAnimatedComponent;
	private var initpos, targetPosition											: Vector;
	private var  blade_temp														: CEntityTemplate;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Witch_Hunter_Throw_Bomb_Actual_Entry();
	}
	
	entry function ACS_Witch_Hunter_Throw_Bomb_Actual_Entry()
	{
		ACS_Witch_Hunter_Throw_Bomb_Actual_Latent();
	}
	
	latent function ACS_Witch_Hunter_Throw_Bomb_Actual_Latent()
	{
		actors.Clear();
		
		//actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 30, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		theGame.GetActorsByTag( 'ACS_Throw_Bomb_Init', actors );	

		if (actors.Size() <= 0)
		{
			return;
		}

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				npc.RemoveTag('ACS_Bomber');

				npc.RemoveBuffImmunity_AllNegative('ACS_Bomber');

				npc.RemoveBuffImmunity_AllCritical('ACS_Bomber');

				if (npc.IsHuman()
				&& !npc.IsWoman()
				&& GetACSWatcher().ACS_Rage_Process == false
				&& npc.HasTag('ACS_Throw_Bomb_Init')
				&& !npc.HasBuff(EET_Burning)
				&& !npc.HasBuff(EET_HeavyKnockdown)
				&& !npc.HasBuff(EET_Knockdown)
				&& !npc.HasBuff(EET_LongStagger)
				&& !npc.HasBuff(EET_Stagger)
				&& !npc.HasBuff(EET_WeakeningAura)
				&& !npc.HasBuff(EET_Weaken)
				&& !npc.HasBuff(EET_Confusion)
				&& !npc.HasBuff(EET_AxiiGuardMe)
				&& !npc.HasBuff(EET_Hypnotized)
				&& !npc.HasBuff(EET_Immobilized)
				&& !npc.HasBuff(EET_Paralyzed)
				&& !npc.HasBuff(EET_Blindness)
				&& !npc.HasBuff(EET_Choking)
				&& !npc.HasBuff(EET_Swarm)
				&& !npc.IsUsingHorse()
				&& !npc.IsUsingVehicle()
				&& !npc.GetInventory().HasItem('crossbow')
				&& !npc.GetInventory().HasItem('bow')
				&& !npc.GetInventory().HasItemByTag('crossbow')
				&& !npc.GetInventory().HasItemByTag('bow')
				&& !npc.HasTag('ACS_Final_Bomb_Thrown')
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !npc.HasTag('ACS_Poise_Finisher')
				&& !animatedComponentA.HasFrozenPose()
				&& !npc.GetIsRecoveringFromKnockdown()
				&& npc.IsAnyWeaponHeld()
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Fists
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Undefined
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Crossbow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Bow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_None
				)
				{
					npc.RemoveTag('ACS_Throw_Bomb_Init');

					initpos = npc.GetWorldPosition() + npc.GetHeadingVector() * 1.1 + npc.GetWorldForward() * 1.1;	
					initpos.Z += 1.1;
					//initpos.X -= 1;

					if (npc.GetInventory().HasItem('ACS_Knife'))
					{
						blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_enemy_knife_projectile.w2ent", true );

						proj_knife = (W3ACSEnemyKnifeProjectile)theGame.CreateEntity( blade_temp, initpos );
												
						proj_knife.Init(npc);

						targetPosition = GetWitcherPlayer().PredictWorldPosition(0.3f);
						targetPosition.Z += RandRangeF(1.1, 0.75);

						npc.GetInventory().RemoveItemByName('ACS_Knife', 1);

						proj_knife.ShootProjectileAtPosition( 0, 20, targetPosition, 500 );

						return;
					}

					//initpos.Y += 0.25;

					targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
					targetPosition.Z += RandRangeF(1.1, 0.5);

					if (StrContains( npc.GetReadableName(), "witch_hunter" ) 
					|| StrContains( npc.GetReadableName(), "inq_" )
					|| npc.HasTag('ACS_Shades_Hunter')
					)
					{
						if (!npc.HasTag('ACS_1st_Bomb_Thrown')
						&& !npc.HasTag('ACS_2nd_Bomb_Thrown')
						&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
						)
						{
							chance = 0.25;
						}
						else if (npc.HasTag('ACS_1st_Bomb_Thrown')
						&& !npc.HasTag('ACS_2nd_Bomb_Thrown')
						&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
						)
						{
							chance = 0.5;
						}
						else if (npc.HasTag('ACS_1st_Bomb_Thrown')
						&& npc.HasTag('ACS_2nd_Bomb_Thrown')	
						&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
						)
						{
							chance = 0.75;
						}
						else if (npc.HasTag('ACS_1st_Bomb_Thrown')
						&& npc.HasTag('ACS_2nd_Bomb_Thrown')	
						&& npc.HasTag('ACS_3rd_Bomb_Thrown')	
						)
						{
							chance = 0.95;
						}
						
						if( RandF() < chance ) 
						{
							proj_Dimeritium = (W3ACSEnemyDimeritium)theGame.CreateEntity( 
							(CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_dimeritium_bomb.w2ent"
							
							, true ), initpos );
											
							proj_Dimeritium.Init(npc);

							proj_Dimeritium.Initialize(npc);

							proj_Dimeritium.PlayEffectSingle('activate');

							proj_Dimeritium.PlayEffectSingle('activate_cluster');

							proj_Dimeritium.ThrowProjectile(targetPosition);
						}
						else
						{
							proj_Shrapnel = (W3ACSPetard)theGame.CreateEntity( 
							(CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_shrapnel_bomb.w2ent"
							
							, true ), initpos );
											
							proj_Shrapnel.Init(npc);

							proj_Shrapnel.Initialize(npc);

							proj_Shrapnel.ThrowProjectile(targetPosition);

							/*
							proj_Shrapnel = (W3ACSPetard)theGame.CreateEntity( 
							(CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_grapeshot.w2ent"
							
							, true ), initpos );
											
							proj_Shrapnel.Init(npc);

							proj_Shrapnel.Initialize(npc);

							proj_Shrapnel.ThrowProjectile(targetPosition);
							*/
						}
					}
					else
					{
						proj_Shrapnel = (W3ACSPetard)theGame.CreateEntity( 
						(CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_shrapnel_bomb.w2ent"

						, true ), initpos );
										
						proj_Shrapnel.Init(npc);

						proj_Shrapnel.Initialize(npc);

						proj_Shrapnel.ThrowProjectile(targetPosition);

						/*
						proj_Shrapnel = (W3ACSPetard)theGame.CreateEntity( 
						(CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\enemy_bombs\enemy_petard_grapeshot.w2ent"
						
						, true ), initpos );
										
						proj_Shrapnel.Init(npc);

						proj_Shrapnel.Initialize(npc);

						proj_Shrapnel.ThrowProjectile(targetPosition);
						*/
					}

					if (!npc.HasTag('ACS_1st_Bomb_Thrown')
					&& !npc.HasTag('ACS_2nd_Bomb_Thrown')
					&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
					)
					{
						npc.AddTag('ACS_1st_Bomb_Thrown');
					}
					else if (npc.HasTag('ACS_1st_Bomb_Thrown')
					&& !npc.HasTag('ACS_2nd_Bomb_Thrown')
					&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
					)
					{
						npc.AddTag('ACS_2nd_Bomb_Thrown');
					}
					else if (npc.HasTag('ACS_1st_Bomb_Thrown')
					&& npc.HasTag('ACS_2nd_Bomb_Thrown')	
					&& !npc.HasTag('ACS_3rd_Bomb_Thrown')	
					)
					{
						npc.AddTag('ACS_3rd_Bomb_Thrown');
					}
					else if (npc.HasTag('ACS_1st_Bomb_Thrown')
					&& npc.HasTag('ACS_2nd_Bomb_Thrown')	
					&& npc.HasTag('ACS_3rd_Bomb_Thrown')	
					)
					{
						if (!npc.HasTag('ACS_Final_Bomb_Thrown'))
						{
							npc.AddTag('ACS_Final_Bomb_Thrown');
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

function ACSGetBomber() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Bomber' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Tentacle
{
	function ACS_Tentacle_Start_Engage()
	{
		this.PushState('ACS_Tentacle_Start_Engage');
	}
}

state ACS_Tentacle_Start_Engage in cACS_Tentacle
{
	private var actors, victims																		: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var drownerAnimatedComponent 															: CAnimatedComponent;
	private var ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, anchor    							: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var anchor_temp, ent_1_temp, ent_2_temp													: CEntityTemplate;

	private var dmg																					: W3DamageAction;

	private var l_aiTree																			: CAIExecuteAttackAction;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Tentacle_Start_Entry();
	}
	
	entry function ACS_Tentacle_Start_Entry()
	{
		ACS_Tentacle_Start_Latent();
	}
	
	latent function ACS_Tentacle_Start_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				(npc.HasAbility('mon_drowner_base')
				&& !npc.HasTag('ACS_Necrofiend_Adds')
				)
				)			
				{
					if (
					npc.HasBuff(EET_Knockdown)
					|| npc.HasBuff(EET_HeavyKnockdown)
					|| npc.HasBuff(EET_Ragdoll)
					|| npc.HasBuff(EET_Burning)
					|| npc.HasBuff(EET_Frozen)
					|| npc.HasBuff(EET_LongStagger)
					|| npc.HasBuff(EET_Stagger)
					|| npc.HasBuff(EET_Weaken)
					|| npc.HasBuff(EET_Confusion)
					|| npc.HasBuff(EET_AxiiGuardMe)
					|| npc.HasBuff(EET_Hypnotized)
					|| npc.HasBuff(EET_Immobilized)
					|| npc.HasBuff(EET_Paralyzed)
					|| npc.HasBuff(EET_Blindness)
					|| npc.HasBuff(EET_Choking)
					|| npc.HasBuff(EET_Swarm)
					)			
					{
						return;
					}

					if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
					{
						theSound.SoundLoadBank( "monster_toad.bnk", false );
					}

					npc.AddTag('ACS_Tentacle_Init');

					npc.SetInteractionPriority( IP_Prio_10 );

					l_aiTree = new CAIExecuteAttackAction in npc;
					l_aiTree.OnCreated();

					l_aiTree.attackParameter = EAT_Attack5;

					//npc.ForceAIBehavior( l_aiTree, BTAP_AboveCombat2);

					movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

					drownerAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

					ticket = movementAdjustor.GetRequest( 'ACS_Tentacle_Rotate_1');
					movementAdjustor.CancelByName( 'ACS_Tentacle_Rotate_1' );
					movementAdjustor.CancelAll();
					ticket = movementAdjustor.CreateNewRequest( 'ACS_Tentacle_Rotate_1' );
					movementAdjustor.AdjustmentDuration( ticket, 1 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

					//npc.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
					//npc.SetCanPlayHitAnim(false); 
					//npc.AddBuffImmunity_AllNegative('acs_tentacle_immune', true); 

					GetACSTentacle_1().Destroy();

					GetACSTentacle_2().Destroy();

					GetACSTentacle_3().Destroy();

					GetACSTentacleAnchor().Destroy();

					rot = npc.GetWorldRotation();

					pos = npc.GetWorldPosition() + npc.GetWorldForward() * 5;

					anchor_temp = (CEntityTemplate)LoadResource( 
						
					"dlc\dlc_acs\data\fx\drowner_warning.w2ent"
					
					, true );


					npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'head' ), bone_vec, bone_rot );

					anchor = (CEntity)theGame.CreateEntity( anchor_temp, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );

					anchor.PlayEffectSingle('marker');

					anchor.AddTag('acs_tentacle_anchor');

					anchor.CreateAttachmentAtBoneWS( npc, 'head', bone_vec, bone_rot );

					((CActor)anchor).EnableCollisions(false);
					((CActor)anchor).EnableCharacterCollisions(false);

					//ent_1_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue.w2ent", true );

					ent_2_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue_no_face.w2ent", true );

					ent_1 = theGame.CreateEntity( ent_2_temp, pos, rot );

					ent_1.AddTag('ACS_Tentacle_1');

					((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
					((CNewNPC)ent_1).EnableCharacterCollisions(false);
					((CNewNPC)ent_1).EnableCollisions(false);
					((CNewNPC)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
					((CActor)ent_1).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
					((CActor)ent_1).EnableCollisions(false);
					((CActor)ent_1).EnableCharacterCollisions(false);
					((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

					npc.EnableCharacterCollisions(false);

					animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
					meshcomp = ent_1.GetComponentByClassName('CMeshComponent');

					animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

					meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

					attach_rot.Roll = 90;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = 0.4;
					attach_vec.Y = 0.15;
					attach_vec.Z = 0;

					ent_1.CreateAttachment( anchor, , attach_vec, attach_rot );
					
					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

					//animcomp.FreezePoseFadeIn(7.5f);

					ent_2 = theGame.CreateEntity( ent_2_temp, pos, rot );

					ent_2.AddTag('ACS_Tentacle_2');

					((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
					((CNewNPC)ent_2).EnableCharacterCollisions(false);
					((CNewNPC)ent_2).EnableCollisions(false);
					((CNewNPC)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
					((CActor)ent_2).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
					((CActor)ent_2).EnableCollisions(false);
					((CActor)ent_2).EnableCharacterCollisions(false);
					((CActor)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

					animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
					meshcomp = ent_2.GetComponentByClassName('CMeshComponent');

					animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

					meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

					attach_rot.Roll = -30;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = -0.3;
					attach_vec.Y = 0.15;
					attach_vec.Z = -0.35;

					ent_2.CreateAttachment( anchor, , attach_vec, attach_rot );

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

					//animcomp.FreezePoseFadeIn(7.5f);

					ent_3 = theGame.CreateEntity( ent_2_temp, pos, rot );

					ent_3.AddTag('ACS_Tentacle_3');

					((CNewNPC)ent_3).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
					((CNewNPC)ent_3).EnableCharacterCollisions(false);
					((CNewNPC)ent_3).EnableCollisions(false);
					((CNewNPC)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
					((CActor)ent_3).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
					((CActor)ent_3).EnableCollisions(false);
					((CActor)ent_3).EnableCharacterCollisions(false);
					((CActor)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

					animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
					meshcomp = ent_3.GetComponentByClassName('CMeshComponent');

					animcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));

					meshcomp.SetScale(Vector( 0.25, 0.25, 0.25, 1 ));	

					attach_rot.Roll = -150;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 180;
					attach_vec.X = -0.3;
					attach_vec.Y = 0.15;
					attach_vec.Z = 0.35;

					ent_3.CreateAttachment( anchor, , attach_vec, attach_rot );

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

					GetACSWatcher().RemoveTimer('ACS_Tentacle_Damage_Delay');
					GetACSWatcher().AddTimer('ACS_Tentacle_Damage_Delay', 1, false);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Tentacle_Damage_Actual()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;
	var l_aiTree						: CAIExecuteAttackAction;
	
	npc = (CActor)theGame.GetEntityByTag( 'ACS_Tentacle_Init' );
	
	if ( npc.GetCurrentHealth() <= 0 
	|| !npc.IsAlive())
	{
		GetACSTentacleAnchor().BreakAttachment(); 
		GetACSTentacleAnchor().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSTentacleAnchor().DestroyAfter(0.0125);

		GetACSTentacle_1().BreakAttachment(); 
		GetACSTentacle_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSTentacle_1().DestroyAfter(0.0125);

		GetACSTentacle_2().BreakAttachment(); 
		GetACSTentacle_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSTentacle_2().DestroyAfter(0.0125);

		GetACSTentacle_3().BreakAttachment(); 
		GetACSTentacle_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSTentacle_3().DestroyAfter(0.0125);

		npc.SetInteractionPriority( IP_Prio_3 );

		npc.RemoveTag('ACS_Tentacle_Init');

		npc.EnableCharacterCollisions(true);

		return;
	}

	GetACSWatcher().RemoveTimer('ACS_Tentacle_Remove');
	GetACSWatcher().AddTimer('ACS_Tentacle_Remove', 0.5, false);

	victims.Clear();

	victims = npc.GetNPCsAndPlayersInCone(3, VecHeading(npc.GetHeadingVector()), 15, 20, , FLAG_OnlyAliveActors );

	if( victims.Size() > 0)
	{
		for( i = 0; i < victims.Size(); i += 1 )
		{
			actortarget = (CActor)victims[i];

			if (actortarget != npc
			&& actortarget != GetACSTentacle_1()
			&& actortarget != GetACSTentacle_2()
			&& actortarget != GetACSTentacle_3()
			&& actortarget != GetACSTentacleAnchor()
			&& actortarget != GetACSNecrofiendTentacle_1()
			&& actortarget != GetACSNecrofiendTentacle_2()
			&& actortarget != GetACSNecrofiendTentacle_3()
			&& actortarget != GetACSNecrofiendTentacle_4()
			&& actortarget != GetACSNecrofiendTentacle_5()
			&& actortarget != GetACSNecrofiendTentacle_6()
			&& actortarget != GetACSNecrofiendTentacleAnchor()
			)
			{
				if 
				(
					GetWitcherPlayer().IsInGuardedState()
					|| GetWitcherPlayer().IsGuarded()
				)
				{
					GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
					GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
				}
				else if 
				(
					GetWitcherPlayer().IsAnyQuenActive()
				)
				{
					GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
					GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
					GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
					GetWitcherPlayer().StopEffect('lasting_shield_discharge');
				}
				else if 
				(
					GetWitcherPlayer().IsCurrentlyDodging()
				)
				{
					GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
					GetWitcherPlayer().StopEffect('lasting_shield_discharge');
				}
				else
				{
					movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

					ticket = movementAdjustor.GetRequest( 'ACS_Tentacle_Hit_Rotate');
					movementAdjustor.CancelByName( 'ACS_Tentacle_Hit_Rotate' );
					movementAdjustor.CancelAll();

					ticket = movementAdjustor.CreateNewRequest( 'ACS_Tentacle_Hit_Rotate' );
					movementAdjustor.AdjustmentDuration( ticket, 0.1 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustor.RotateTowards( ticket, npc );

					actortarget.SoundEvent("cmb_play_hit_heavy");

					if (actortarget == GetWitcherPlayer())
					{
						AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

						AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

						if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
						{
							GetACSWatcher().Grow_Geralt_Immediate_Fast();

							GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
						}

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
					}

					params.effectType = EET_Knockdown;
					params.creator = npc;
					params.sourceName = "ACS_Tentacle_Knockdown";
					params.duration = 1;

					actortarget.AddEffectCustom( params );	
				}
			}
		}
	}

	npc.SetInteractionPriority( IP_Prio_3 );

	npc.RemoveTag('ACS_Tentacle_Init');

	npc.EnableCharacterCollisions(true);
}

function GetACSTentacle_1() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Tentacle_1' );
	return entity;
}

function GetACSTentacle_2() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Tentacle_2' );
	return entity;
}

function GetACSTentacle_3() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Tentacle_3' );
	return entity;
}

function GetACSTentacleAnchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_tentacle_anchor' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Necrofiend
{
	function ACS_Necrofiend_Proj_Engage()
	{
		this.PushState('ACS_Necrofiend_Proj_Engage');
	}

	function ACS_Necrofiend_Proj_Start_Engage()
	{
		this.PushState('ACS_Necrofiend_Proj_Start_Engage');
	}
}

state ACS_Necrofiend_Proj_Start_Engage in cACS_Necrofiend
{
	private var actors, victims																		: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var drownerAnimatedComponent 															: CAnimatedComponent;
	private var ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, anchor    							: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var anchor_temp, ent_1_temp, ent_2_temp													: CEntityTemplate;

	private var dmg																					: W3DamageAction;

	private var l_aiTree																			: CAIExecuteAttackAction;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Necrofiend_Tentacle_Start_Entry();
	}
	
	entry function ACS_Necrofiend_Tentacle_Start_Entry()
	{
		ACS_Necrofiend_Tentacle_Start_Latent();
	}
	
	latent function ACS_Necrofiend_Tentacle_Start_Latent()
	{
		npc = ((CNewNPC)GetACSNecrofiend());

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

		if (
		npc
		)			
		{
			if (
			!npc
			|| npc.HasBuff(EET_Knockdown)
			|| npc.HasBuff(EET_HeavyKnockdown)
			|| npc.HasBuff(EET_Ragdoll)
			|| npc.HasBuff(EET_Burning)
			|| npc.HasBuff(EET_Frozen)
			|| npc.HasBuff(EET_LongStagger)
			|| npc.HasBuff(EET_Stagger)
			|| npc.HasBuff(EET_Weaken)
			|| npc.HasBuff(EET_Confusion)
			|| npc.HasBuff(EET_AxiiGuardMe)
			|| npc.HasBuff(EET_Hypnotized)
			|| npc.HasBuff(EET_Immobilized)
			|| npc.HasBuff(EET_Paralyzed)
			|| npc.HasBuff(EET_Blindness)
			|| npc.HasBuff(EET_Choking)
			|| npc.HasBuff(EET_Swarm)
			|| !npc.IsAlive()
			)			
			{
				return;
			}

			if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
			{
				theSound.SoundLoadBank( "monster_toad.bnk", false );
			}

			npc.AddTag('ACS_Necrofiend_Tentacle_Init');

			movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

			drownerAnimatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

			ticket = movementAdjustor.GetRequest( 'ACS_Necrofiend_Tentacle_Rotate_1');
			movementAdjustor.CancelByName( 'ACS_Necrofiend_Tentacle_Rotate_1' );
			movementAdjustor.CancelAll();
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Necrofiend_Tentacle_Rotate_1' );
			movementAdjustor.AdjustmentDuration( ticket, 1 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

			if (!GetACSNecrofiendTentacleAnchor())
			{
				GetACSNecrofiendTentacle_1().Destroy();

				GetACSNecrofiendTentacle_2().Destroy();

				GetACSNecrofiendTentacle_3().Destroy();

				GetACSNecrofiendTentacleAnchor().Destroy();

				rot = npc.GetWorldRotation();

				pos = npc.GetWorldPosition() + npc.GetWorldForward() * 5;

				anchor_temp = (CEntityTemplate)LoadResource( 
					
				"dlc\dlc_acs\data\fx\drowner_warning.w2ent"
				
				, true );


				npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'head' ), bone_vec, bone_rot );

				anchor = (CEntity)theGame.CreateEntity( anchor_temp, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );

				anchor.PlayEffectSingle('marker');

				anchor.AddTag('acs_necrofiend_tentacle_anchor');

				anchor.CreateAttachmentAtBoneWS( npc, 'head', bone_vec, bone_rot );

				((CActor)anchor).EnableCollisions(false);
				((CActor)anchor).EnableCharacterCollisions(false);

				ent_1_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue.w2ent", true );

				ent_2_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\toad_tongue_no_face.w2ent", true );


				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				ent_1 = theGame.CreateEntity( ent_1_temp, pos, rot );

				ent_1.AddTag('ACS_Necrofiend_Tentacle_1');

				((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
				((CNewNPC)ent_1).EnableCharacterCollisions(false);
				((CNewNPC)ent_1).EnableCollisions(false);
				((CNewNPC)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
				((CActor)ent_1).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
				((CActor)ent_1).EnableCollisions(false);
				((CActor)ent_1).EnableCharacterCollisions(false);
				((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

				npc.EnableCharacterCollisions(false);

				animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_1.GetComponentByClassName('CMeshComponent');

				h = 0.25;

				animcomp.SetScale(Vector( h, 0.5, h, 1 ));

				meshcomp.SetScale(Vector( h, 0.5, h, 1 ));	

				attach_rot.Roll = 90;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = 0.5;
				attach_vec.Y = 1;
				attach_vec.Z = 0;

				ent_1.CreateAttachment( anchor, , attach_vec, attach_rot );
				
				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

				//animcomp.FreezePoseFadeIn(7.5f);


				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				ent_2 = theGame.CreateEntity( ent_1_temp, pos, rot );

				ent_2.AddTag('ACS_Necrofiend_Tentacle_2');

				((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
				((CNewNPC)ent_2).EnableCharacterCollisions(false);
				((CNewNPC)ent_2).EnableCollisions(false);
				((CNewNPC)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
				((CActor)ent_2).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
				((CActor)ent_2).EnableCollisions(false);
				((CActor)ent_2).EnableCharacterCollisions(false);
				((CActor)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

				animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_2.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( h, 0.5, h, 1 ));

				meshcomp.SetScale(Vector( h, 0.5, h, 1 ));	

				attach_rot.Roll = -30;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = -0.2;
				attach_vec.Y = 1;
				attach_vec.Z = -0.35;

				ent_2.CreateAttachment( anchor, , attach_vec, attach_rot );

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

				//animcomp.FreezePoseFadeIn(7.5f);


				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				ent_3 = theGame.CreateEntity( ent_1_temp, pos, rot );

				ent_3.AddTag('ACS_Necrofiend_Tentacle_3');

				((CNewNPC)ent_3).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
				((CNewNPC)ent_3).EnableCharacterCollisions(false);
				((CNewNPC)ent_3).EnableCollisions(false);
				((CNewNPC)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
				((CActor)ent_3).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
				((CActor)ent_3).EnableCollisions(false);
				((CActor)ent_3).EnableCharacterCollisions(false);
				((CActor)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

				animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_3.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( h, 0.5, h, 1 ));

				meshcomp.SetScale(Vector( h, 0.5, h, 1 ));	

				attach_rot.Roll = -150;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = -0.2;
				attach_vec.Y = 1;
				attach_vec.Z = 0.35;

				ent_3.CreateAttachment( anchor, , attach_vec, attach_rot );

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));


				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


				ent_4 = theGame.CreateEntity( ent_2_temp, pos, rot );

				ent_4.AddTag('ACS_Necrofiend_Tentacle_4');

				((CNewNPC)ent_4).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
				((CNewNPC)ent_4).EnableCharacterCollisions(false);
				((CNewNPC)ent_4).EnableCollisions(false);
				((CNewNPC)ent_4).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
				((CActor)ent_4).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
				((CActor)ent_4).EnableCollisions(false);
				((CActor)ent_4).EnableCharacterCollisions(false);
				((CActor)ent_4).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

				animcomp = (CAnimatedComponent)ent_4.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_4.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 0.3, 0.75, 0.3, 1 ));

				meshcomp.SetScale(Vector( 0.3, 0.75, 0.3, 1 ));	

				attach_rot.Roll = 90;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = 0.5;
				attach_vec.Y = 0.875;
				attach_vec.Z = 0;

				ent_4.CreateAttachment( anchor, , attach_vec, attach_rot );
				
				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

				//animcomp.FreezePoseFadeIn(7.5f);

				ent_5 = theGame.CreateEntity( ent_2_temp, pos, rot );

				ent_5.AddTag('ACS_Necrofiend_Tentacle_5');

				((CNewNPC)ent_5).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
				((CNewNPC)ent_5).EnableCharacterCollisions(false);
				((CNewNPC)ent_5).EnableCollisions(false);
				((CNewNPC)ent_5).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
				((CActor)ent_5).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
				((CActor)ent_5).EnableCollisions(false);
				((CActor)ent_5).EnableCharacterCollisions(false);
				((CActor)ent_5).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

				animcomp = (CAnimatedComponent)ent_5.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_5.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 0.3, 0.75, 0.3, 1 ));

				meshcomp.SetScale(Vector( 0.3, 0.75, 0.3, 1 ));	

				attach_rot.Roll = -30;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = -0.2;
				attach_vec.Y = 0.875;
				attach_vec.Z = -0.35;

				ent_5.CreateAttachment( anchor, , attach_vec, attach_rot );

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

				//animcomp.FreezePoseFadeIn(7.5f);

				ent_6 = theGame.CreateEntity( ent_2_temp, pos, rot );

				ent_6.AddTag('ACS_Necrofiend_Tentacle_6');

				((CNewNPC)ent_6).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
				((CNewNPC)ent_6).EnableCharacterCollisions(false);
				((CNewNPC)ent_6).EnableCollisions(false);
				((CNewNPC)ent_6).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );
				((CActor)ent_6).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
				((CActor)ent_6).EnableCollisions(false);
				((CActor)ent_6).EnableCharacterCollisions(false);
				((CActor)ent_6).SetImmortalityMode( AIM_Invulnerable, AIC_Combat, true );

				animcomp = (CAnimatedComponent)ent_6.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_6.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 0.3, 0.75, 0.3, 1 ));

				meshcomp.SetScale(Vector( 0.3, 0.75, 0.3, 1 ));	

				attach_rot.Roll = -150;
				attach_rot.Pitch = 0;
				attach_rot.Yaw = 180;
				attach_vec.X = -0.2;
				attach_vec.Y = 0.875;
				attach_vec.Z = 0.35;

				ent_6.CreateAttachment( anchor, , attach_vec, attach_rot );

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));


				((CNewNPC)ent_1).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)ent_1), AIA_Friendly);

				((CNewNPC)ent_2).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)ent_2), AIA_Friendly);

				((CNewNPC)ent_3).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)ent_3), AIA_Friendly);


				((CNewNPC)ent_4).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)ent_4), AIA_Friendly);

				((CNewNPC)ent_5).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)ent_5), AIA_Friendly);

				((CNewNPC)ent_6).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)ent_6), AIA_Friendly);
			}
			else
			{
				((CNewNPC)GetACSNecrofiendTentacle_1()).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)GetACSNecrofiendTentacle_1()), AIA_Friendly);

				((CNewNPC)GetACSNecrofiendTentacle_2()).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)GetACSNecrofiendTentacle_2()), AIA_Friendly);

				((CNewNPC)GetACSNecrofiendTentacle_3()).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)GetACSNecrofiendTentacle_3()), AIA_Friendly);

				if (RandF() < 0.5)
				{
					animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_1().GetComponentByClassName('CAnimatedComponent');

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_2().GetComponentByClassName('CAnimatedComponent');

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_3().GetComponentByClassName('CAnimatedComponent');

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}
				else
				{
					animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_1().GetComponentByClassName('CAnimatedComponent');

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_2().GetComponentByClassName('CAnimatedComponent');

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_3().GetComponentByClassName('CAnimatedComponent');

					animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue_10m', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}

				((CNewNPC)GetACSNecrofiendTentacle_4()).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)GetACSNecrofiendTentacle_4()), AIA_Friendly);

				((CNewNPC)GetACSNecrofiendTentacle_5()).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)GetACSNecrofiendTentacle_5()), AIA_Friendly);

				((CNewNPC)GetACSNecrofiendTentacle_6()).SetAttitude(((CNewNPC)npc), AIA_Friendly);

				((CNewNPC)npc).SetAttitude(((CActor)GetACSNecrofiendTentacle_6()), AIA_Friendly);

				animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_4().GetComponentByClassName('CAnimatedComponent');

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_5().GetComponentByClassName('CAnimatedComponent');

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				animcomp = (CAnimatedComponent)GetACSNecrofiendTentacle_6().GetComponentByClassName('CAnimatedComponent');

				animcomp.PlaySlotAnimationAsync ( 'monster_toad_attack_tongue', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
			}

			GetACSWatcher().RemoveTimer('ACS_Necrofiend_Tentacle_Damage_Delay');
			GetACSWatcher().AddTimer('ACS_Necrofiend_Tentacle_Damage_Delay', 1, false);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Necrofiend_Proj_Engage in cACS_Necrofiend
{
	private var actors																				: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor 																				: CActor;
	private var proj_1, proj_2, proj_3	 															: W3ACSZombieSpawnerProjectile;
	private var initpos, targetPosition, targetPosition_1, targetPosition_2, targetPosition_3		: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ghoulAnimatedComponent 																: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Necrofiend_Venom_Entry();
	}
	
	entry function ACS_Necrofiend_Venom_Entry()
	{
		ACS_Necrofiend_Venom_Latent();
	}
	
	latent function ACS_Necrofiend_Venom_Latent()
	{
		npc = ((CNewNPC)GetACSNecrofiend());

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

		if (
		(npc.HasTag('ACS_Necrofiend')
		)
		)
		{
			npc.AddBuffImmunity(EET_Poison, 'ACS_Necrofiend_Proj_Poison_Negate', true);

			npc.AddBuffImmunity(EET_PoisonCritical , 'ACS_Necrofiend_Proj_Poison_Negate', true);

			//initpos = npc.GetWorldPosition() + npc.GetWorldForward() * 0.5 ;

			initpos = npc.GetWorldPosition() + npc.GetHeadingVector() + npc.GetWorldForward() * 1.5;	

			initpos.Z += 1.75;
					
			targetPosition = npc.GetHeadingVector() + GetWitcherPlayer().PredictWorldPosition(0.5f);
			//targetPosition.Z += 0.5;

			targetPosition_1 = GetWitcherPlayer().PredictWorldPosition(0.1f);
			//targetPosition_1.Z += 0.5;

			targetPosition_2 = GetWitcherPlayer().PredictWorldPosition(0.5f);
			//targetPosition_2.Z += 0.5;

			targetPosition_3 = GetWitcherPlayer().PredictWorldPosition(1.0f);
			//targetPosition_3.Z += 0.5;

			proj_1 = (W3ACSZombieSpawnerProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( 

				"dlc\dlc_acs\data\entities\projectiles\zombie_spawner_projectile.w2ent"
				
				, true ), initpos );
							
			proj_1.Init(npc);

			npc.SoundEvent('monster_toad_fx_mucus_spit');

			//proj_1.PlayEffectSingle('spit_travel');

			proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
			proj_1.DestroyAfter(20);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Necrofiend_Tentacle_Damage_Actual()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;
	var l_aiTree						: CAIExecuteAttackAction;
	
	npc = (CActor)theGame.GetEntityByTag( 'ACS_Necrofiend_Tentacle_Init' );
	
	if ( npc.GetCurrentHealth() <= 0 
	|| !npc.IsAlive())
	{
		GetACSNecrofiendTentacleAnchor().BreakAttachment(); 
		GetACSNecrofiendTentacleAnchor().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSNecrofiendTentacleAnchor().DestroyAfter(0.0125);

		GetACSNecrofiendTentacle_1().BreakAttachment(); 
		GetACSNecrofiendTentacle_1().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSNecrofiendTentacle_1().DestroyAfter(0.0125);

		GetACSNecrofiendTentacle_2().BreakAttachment(); 
		GetACSNecrofiendTentacle_2().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSNecrofiendTentacle_2().DestroyAfter(0.0125);

		GetACSNecrofiendTentacle_3().BreakAttachment(); 
		GetACSNecrofiendTentacle_3().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSNecrofiendTentacle_3().DestroyAfter(0.0125);

		GetACSNecrofiendTentacle_4().BreakAttachment(); 
		GetACSNecrofiendTentacle_4().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSNecrofiendTentacle_4().DestroyAfter(0.0125);

		GetACSNecrofiendTentacle_5().BreakAttachment(); 
		GetACSNecrofiendTentacle_5().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSNecrofiendTentacle_5().DestroyAfter(0.0125);

		GetACSNecrofiendTentacle_6().BreakAttachment(); 
		GetACSNecrofiendTentacle_6().Teleport( thePlayer.GetWorldPosition() + Vector( 0, 0, -200 ) );
		GetACSNecrofiendTentacle_6().DestroyAfter(0.0125);

		npc.RemoveTag('ACS_Necrofiend_Tentacle_Init');

		npc.EnableCharacterCollisions(true);

		return;
	}

	GetACSWatcher().Necrofiend_Proj();

	//GetACSWatcher().RemoveTimer('ACS_Necrofiend_Tentacle_Remove');
	//GetACSWatcher().AddTimer('ACS_Necrofiend_Tentacle_Remove', 1, false);

	victims.Clear();

	victims = npc.GetNPCsAndPlayersInCone(4, VecHeading(npc.GetHeadingVector()), 15, 20, , FLAG_OnlyAliveActors );

	if( victims.Size() > 0)
	{
		for( i = 0; i < victims.Size(); i += 1 )
		{
			actortarget = (CActor)victims[i];

			if (actortarget != npc
			&& actortarget != GetACSTentacle_1()
			&& actortarget != GetACSTentacle_2()
			&& actortarget != GetACSTentacle_3()
			&& actortarget != GetACSNecrofiendTentacle_1()
			&& actortarget != GetACSNecrofiendTentacle_2()
			&& actortarget != GetACSNecrofiendTentacle_3()
			&& actortarget != GetACSNecrofiendTentacle_4()
			&& actortarget != GetACSNecrofiendTentacle_5()
			&& actortarget != GetACSNecrofiendTentacle_6()
			&& actortarget != GetACSNecrofiendTentacleAnchor()
			)
			{
				if 
				(
					GetWitcherPlayer().IsInGuardedState()
					|| GetWitcherPlayer().IsGuarded()
				)
				{
					GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
					GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
				}
				else if 
				(
					GetWitcherPlayer().IsAnyQuenActive()
				)
				{
					GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
					GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
					GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
					GetWitcherPlayer().StopEffect('lasting_shield_discharge');
				}
				else if 
				(
					GetWitcherPlayer().IsCurrentlyDodging()
				)
				{
					GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
					GetWitcherPlayer().StopEffect('lasting_shield_discharge');
				}
				else
				{
					movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

					ticket = movementAdjustor.GetRequest( 'ACS_Tentacle_Hit_Rotate');
					movementAdjustor.CancelByName( 'ACS_Tentacle_Hit_Rotate' );
					movementAdjustor.CancelAll();

					ticket = movementAdjustor.CreateNewRequest( 'ACS_Tentacle_Hit_Rotate' );
					movementAdjustor.AdjustmentDuration( ticket, 0.1 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustor.RotateTowards( ticket, npc );

					actortarget.SoundEvent("cmb_play_hit_heavy");

					if (actortarget == GetWitcherPlayer())
					{
						AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

						AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

						if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
						{
							GetACSWatcher().Grow_Geralt_Immediate_Fast();

							GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
						}

						GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
					}

					params.effectType = EET_Knockdown;
					params.creator = npc;
					params.sourceName = "ACS_Necrofiend_Tentacle_Knockdown";
					params.duration = 1;

					actortarget.AddEffectCustom( params );	
				}
			}
		}
	}

	npc.RemoveTag('ACS_Necrofiend_Tentacle_Init');

	npc.EnableCharacterCollisions(true);
}

function GetACSNecrofiendTentacle_1() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Necrofiend_Tentacle_1' );
	return entity;
}

function GetACSNecrofiendTentacle_2() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Necrofiend_Tentacle_2' );
	return entity;
}

function GetACSNecrofiendTentacle_3() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Necrofiend_Tentacle_3' );
	return entity;
}

function GetACSNecrofiendTentacle_4() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Necrofiend_Tentacle_4' );
	return entity;
}

function GetACSNecrofiendTentacle_5() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Necrofiend_Tentacle_5' );
	return entity;
}

function GetACSNecrofiendTentacle_6() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Necrofiend_Tentacle_6' );
	return entity;
}

function GetACSNecrofiend() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Necrofiend' );
	return entity;
}

function GetACSNecrofiendTentacleAnchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_necrofiend_tentacle_anchor' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Nekker_Guardian
{
	function ACS_Nekker_Guardian_Start_Engage()
	{
		this.PushState('ACS_Nekker_Guardian_Start_Engage');
	}

	function ACS_Nekker_Guardian_Heal_Engage()
	{
		this.PushState('ACS_Nekker_Guardian_Heal_Engage');
	}
}

state ACS_Nekker_Guardian_Start_Engage in cACS_Nekker_Guardian
{
	private var actors, victims																		: array<CActor>;
	private var i, ii 																				: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent, anchor  																		: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
	private var playerRot, adjustedRot 																: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var temp, anchorTemplate																: CEntityTemplate;

	private var dmg																					: W3DamageAction;
	private var randAngle, randRange																: float;
	private var playerPos, spawnPos																	: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		if (!thePlayer.IsInInterior())
		{
			ACS_Nekker_Guardian_Start_Entry();
		}
	}
	
	entry function ACS_Nekker_Guardian_Start_Entry()
	{
		ACS_Nekker_Guardian_Start_Latent();
	}
	
	latent function ACS_Nekker_Guardian_Start_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() >= 3 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if (
				npc.HasAbility('mon_nekker')
				&& !npc.HasTag('ACS_Nekker_Guardian')
				&& npc.IsInCombat()
				&& !npc.HasTag('ACS_Has_Summoned_Nekker_Guardian')
				)			
				{
					if (!GetACSNekkerGuardian() || !GetACSNekkerGuardian().IsAlive())
					{

						if (npc.HasAbility('mon_q704_ft_pixies'))
						{
							temp = (CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\entities\monsters\pixie_guardian.w2ent"
							
							, true );
						}
						else
						{
							temp = (CEntityTemplate)LoadResourceAsync( 

							"dlc\dlc_acs\data\entities\monsters\nekker_guardian.w2ent"
							
							, true );
						}
						

						randRange = 1.5 + 1.5 * RandF();
						randAngle = 1.5 * Pi() * RandF();

						playerPos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 5;
						
						spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
						spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
						spawnPos.Z = playerPos.Z;

						GetACSNekkerGuardian().Destroy();

						playerRot = thePlayer.GetWorldRotation();

						playerRot.Yaw += 180;

						adjustedRot = EulerAngles(0,0,0);

						adjustedRot.Yaw = playerRot.Yaw;
						
						ent = theGame.CreateEntity( temp, spawnPos, adjustedRot );

						animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
						meshcomp = ent.GetComponentByClassName('CMeshComponent');
						h = 2;
						animcomp.SetScale(Vector(h,h,h,1));
						meshcomp.SetScale(Vector(h,h,h,1));	

						((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel() + 7);
						((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

						//((CNewNPC)ent).SetCanPlayHitAnim(false); 

						//((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
						((CActor)ent).SetAnimationSpeedMultiplier(0.75);

						((CActor)ent).AddBuffImmunity_AllNegative('ACS_Nekker_Guardian', true);

						((CActor)ent).AddBuffImmunity_AllCritical('ACS_Nekker_Guardian', true);

						((CActor)ent).GetInventory().RemoveItemByName('Devine', -1);

						actor.SetInteractionPriority( IP_Max_Unpushable );

						if (npc.HasAbility('mon_q704_ft_pixies'))
						{
							ent.PlayEffectSingle('demonic_possession');

							ent.AddTag('ACS_Pixie_Guardian');
						}

						ent.AddTag( 'ACS_Nekker_Guardian' );

						ent.AddTag( 'NoBestiaryEntry' );
					}

					npc.SetAttitude(GetACSNekkerGuardian(), AIA_Friendly);

					npc.AddTag('ACS_Has_Summoned_Nekker_Guardian');
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Nekker_Guardian_Heal_Engage in cACS_Nekker_Guardian
{
	private var actors, victims																		: array<CActor>;
	private var i, ii 																				: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent, anchor, anchor_2  																: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var anchorTemplate																		: CEntityTemplate;

	private var dmg																					: W3DamageAction;
	private var randAngle, randRange																: float;
	private var playerPos, spawnPos																	: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Nekker_Guardian_Heal_Entry();
	}
	
	entry function ACS_Nekker_Guardian_Heal_Entry()
	{
		ACS_Nekker_Guardian_Heal_Latent();
	}
	
	latent function ACS_Nekker_Guardian_Heal_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if (
				npc.HasAbility('mon_nekker')
				&& npc.IsInCombat()
				&& !npc.HasTag('ACS_Nekker_Guardian')
				)			
				{
					if (GetACSNekkerGuardian().IsAlive())
					{
						npc.SetAttitude(GetACSNekkerGuardian(), AIA_Friendly);

						if (
						npc.GetStat(BCS_Essence) <= (npc.GetStatMax(BCS_Essence) * 0.75)
						)
						{
							if (GetACSNekkerGuardian().GetStat(BCS_Essence) >= GetACSNekkerGuardian().GetStatMax(BCS_Essence) * 0.25)
							{
								GetACSNekkerGuardian().DrainEssence( GetACSNekkerGuardian().GetStatMax(BCS_Essence) * 0.0125 );
							}

							npc.Heal(GetACSNekkerGuardian().GetStatMax(BCS_Essence) * 0.05);

							npc.SoundEvent("monster_dettlaff_vampire_combat_magic_regeneration");

							GetACSNekkerGuardian().SoundEvent("monster_nekker_vo_scream");

							anchorTemplate = (CEntityTemplate)LoadResourceAsync( 
							
							"dlc\dlc_acs\data\fx\nekker_share_life_force.w2ent"
							
							, true );


							GetACSNekkerGuardian().GetBoneWorldPositionAndRotationByIndex( GetACSNekkerGuardian().GetBoneIndex( 'k_torso_g' ), bone_vec, bone_rot );

							anchor = (CEntity)theGame.CreateEntity( anchorTemplate, GetACSNekkerGuardian().GetWorldPosition() + Vector( 0, 0, -10 ) );

							anchor.CreateAttachmentAtBoneWS( GetACSNekkerGuardian(), 'k_torso_g', bone_vec, bone_rot );


							//anchor = (CEntity)theGame.CreateEntity( anchorTemplate, GetACSNekkerGuardian().GetWorldPosition(), GetACSNekkerGuardian().GetWorldRotation() );

							//anchor.CreateAttachment( GetACSNekkerGuardian(), , Vector(0,0,2) );

							anchor.AddTag('ACS_Nekker_Life_Force');

							anchor.DestroyAfter(5);




							npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'k_torso_g' ), bone_vec, bone_rot );

							anchor_2 = (CEntity)theGame.CreateEntity( anchorTemplate, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );

							anchor_2.CreateAttachmentAtBoneWS( npc, 'k_torso_g', bone_vec, bone_rot );


							//anchor_2 = (CEntity)theGame.CreateEntity( anchorTemplate, ent.GetWorldPosition(), ent.GetWorldRotation() );

							//anchor_2.CreateAttachment( npc, , Vector( 0, 0, 1 ) );

							anchor_2.AddTag('ACS_Nekker_Life_Force_Anchor');

							anchor_2.DestroyAfter(5);









							GetACSNekkerGuardianShareLifeForce().StopEffect('drain_energy_1');
							GetACSNekkerGuardianShareLifeForce().PlayEffectSingle('drain_energy_1', anchor_2);

							anchor_2.PlayEffectSingle('drain_energy');
							anchor_2.PlayEffectSingle('drain_energy');
							anchor_2.PlayEffectSingle('drain_energy');
							anchor_2.StopEffect('drain_energy');
							
							anchor_2.StopEffect('drain_energy_1');
							anchor_2.PlayEffectSingle('drain_energy_1', anchor);
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

function GetACSNekkerGuardian() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Nekker_Guardian' );
	return entity;
}

function GetACSNekkerGuardianShareLifeForce() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Nekker_Life_Force' );
	return entity;
}

function ACS_NekkerGuardianShareLifeForce_Destroy()
{
	var ents 												: array<CEntity>;
	var i													: int;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Nekker_Life_Force', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACS_NekkerGuardianShareLifeForceAnchor_Destroy()
{
	var ents 												: array<CEntity>;
	var i													: int;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Nekker_Life_Force_Anchor', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Katakan_Summon
{
	function ACS_Katakan_Summon_Start_Engage()
	{
		this.PushState('ACS_Katakan_Summon_Start_Engage');
	}
}

state ACS_Katakan_Summon_Start_Engage in cACS_Katakan_Summon
{
	private var actors, victims																		: array<CActor>;
	private var i, ii 																				: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var proj_1, proj_2, proj_3	 															: DebuffProjectile;
	private var initpos, targetPosition																: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent, anchor  																		: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var temp, anchorTemplate																: CEntityTemplate;

	private var dmg																					: W3DamageAction;
	private var randAngle, randRange																: float;
	private var playerPos, spawnPos																	: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Katakan_Summon_Start_Entry();
	}
	
	entry function ACS_Katakan_Summon_Start_Entry()
	{
		ACS_Katakan_Summon_Start_Latent();
	}
	
	latent function ACS_Katakan_Summon_Start_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if (
				npc.IsAlive()
				&& npc.HasTag('novigrad_underground_vampire')
				//&& !npc.HasTag('ACS_Has_Summoned_Katakan')
				)			
				{
					if (!GetACSKatakan() || !GetACSKatakan().IsAlive())
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"characters\npc_entities\monsters\vampire_katakan_lvl1.w2ent"
						
						, true );

						playerPos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2.5;

						GetACSKatakan().Destroy();
						
						ent = theGame.CreateEntity( temp, playerPos, npc.GetWorldRotation() );

						animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
						meshcomp = ent.GetComponentByClassName('CMeshComponent');
						h = 1;
						//animcomp.SetScale(Vector(h,h,h,1));
						//meshcomp.SetScale(Vector(h,h,h,1));

						((CActor)ent).SetAnimationSpeedMultiplier(0.75);

						((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel()/2);

						((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

						((CNewNPC)ent).SetAttitude(npc, AIA_Friendly);

						//((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

						ent.AddTag( 'ACS_Katakan' );
					}

					npc.SetAttitude(GetACSKatakan(), AIA_Friendly);

					//npc.AddTag('ACS_Has_Summoned_Katakan');
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSKatakan() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Katakan' );
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Unseen_Blade_Summon_Start()
{
	var vACS_Unseen_Blade_Summon 		: cACS_Unseen_Blade_Summon;

	vACS_Unseen_Blade_Summon = new cACS_Unseen_Blade_Summon in theGame;

	vACS_Unseen_Blade_Summon.ACS_Unseen_Blade_Summon_Start_Engage();
}

function ACS_Unseen_Monster_Summon_Start()
{
	var vACS_Unseen_Blade_Summon 		: cACS_Unseen_Blade_Summon;

	vACS_Unseen_Blade_Summon = new cACS_Unseen_Blade_Summon in theGame;

	vACS_Unseen_Blade_Summon.ACS_Unseen_Monster_Summon_Start_Engage();
}

statemachine class cACS_Unseen_Blade_Summon
{
	function ACS_Unseen_Blade_Summon_Start_Engage()
	{
		this.PushState('ACS_Unseen_Blade_Summon_Start_Engage');
	}

	function ACS_Unseen_Monster_Summon_Start_Engage()
	{
		this.PushState('ACS_Unseen_Monster_Summon_Start_Engage');
	}
}

state ACS_Unseen_Blade_Summon_Start_Engage in cACS_Unseen_Blade_Summon
{
	private var temp, anchor_temp, ent_1_temp, blade_temp						: CEntityTemplate;
	private var ent, anchor, ent_1, r_anchor, l_anchor, r_blade1, l_blade1		: CEntity;
	private var i, count, j														: int;
	private var playerPos, spawnPos, newSpawnPos								: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	private var actors															: array<CActor>;
	private var npc																: CNewNPC;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Unseen_Blade_Summon_Start_Entry();
	}
	
	entry function ACS_Unseen_Blade_Summon_Start_Entry()
	{
		ACS_Unseen_Blade_Summon_Start_Latent();

		UnseenBladeSetAttitude();
	}
	
	latent function ACS_Unseen_Blade_Summon_Start_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\blade_of_the_unseen.w2ent"
		
		, true );

		anchor_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		//blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\swords\swordclaws_unseen.w2ent", true );

		blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			ACS_Blade_Of_The_Unseen().Destroy();

			GetACS_Blade_Of_The_Unseen_L_Blade().Destroy();

			GetACS_Blade_Of_The_Unseen_L_Anchor().Destroy();

			GetACS_Blade_Of_The_Unseen_R_Blade().Destroy();

			GetACS_Blade_Of_The_Unseen_R_Anchor().Destroy();

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().DisplayHudMessage( "I am the blade in the darkness." );
			}
			else
			{
				GetWitcherPlayer().DisplayHudMessage( "The unseen blade is the deadliest." );
			}
	
			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel() + 7);
			((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Blade_Of_The_Unseen' );

			ent.PlayEffectSingle('shadowdash');

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('him_smoke_red');
			ent.PlayEffectSingle('him_smoke_red');
			ent.PlayEffectSingle('him_smoke_red');
			ent.PlayEffectSingle('him_smoke_red');

			ent.PlayEffectSingle('special_attack_tell_r_leg');

			ent.PlayEffectSingle('special_attack_tell_l_leg');

			ent.PlayEffectSingle('hym_spawn');

			((CActor)ent).GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
			r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() );

			r_anchor.CreateAttachment( ((CActor)ent), 'r_hand',  );

			r_anchor.AddTag('ACS_Unseen_Blade_R_Anchor');
			
			ent.GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
			l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() );

			l_anchor.CreateAttachment( ((CActor)ent), 'l_hand',  );

			l_anchor.AddTag('ACS_Unseen_Blade_L_Anchor');

			r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -20 ) );
			l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -20 ) );

			attach_rot.Roll = 90;
			attach_rot.Pitch = 270;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.05;
			attach_vec.Y = 0;
			attach_vec.Z = -0.005;
			
			l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

			l_blade1.PlayEffectSingle('runeword_igni');

			//l_blade1.PlayEffectSingle('red_runeword_igni_1');

			//l_blade1.PlayEffectSingle('red_runeword_igni_2');

			l_blade1.PlayEffectSingle('runeword1_fire_trail');

			l_blade1.PlayEffectSingle('fire_sparks_trail');

			l_blade1.PlayEffectSingle('weapon_blood_stage2');

			l_blade1.PlayEffectSingle('weapon_blood_stage1');

			attach_rot.Roll = 90;
			attach_rot.Pitch = 270;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.05;
			attach_vec.Y = 0;
			attach_vec.Z = -0.005;
			
			r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

			r_blade1.PlayEffectSingle('runeword_igni');

			//r_blade1.PlayEffectSingle('red_runeword_igni_1');

			//r_blade1.PlayEffectSingle('red_runeword_igni_2');

			r_blade1.PlayEffectSingle('runeword1_fire_trail');

			r_blade1.PlayEffectSingle('fire_sparks_trail');

			r_blade1.PlayEffectSingle('weapon_blood_stage2');

			r_blade1.PlayEffectSingle('weapon_blood_stage1');

			l_blade1.AddTag('ACS_Blade_Of_The_Unseen_L_Blade');

			r_blade1.AddTag('ACS_Blade_Of_The_Unseen_R_Blade');
		}
	}

	latent function UnseenBladeSetAttitude()
	{
		actors.Clear();
		
		actors = ACS_Blade_Of_The_Unseen().GetNPCsAndPlayersInRange( 20, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( j = 0; j < actors.Size(); j += 1 )
			{
				npc = (CNewNPC)actors[j];

				if (
				npc.IsAlive()
				&& npc.HasAbility('mon_vampiress_base')
				)			
				{
					((CNewNPC)ACS_Blade_Of_The_Unseen()).SetAttitude(npc, AIA_Friendly);

					((CNewNPC)npc).SetAttitude(ACS_Blade_Of_The_Unseen(), AIA_Friendly);
				}
			}
		}
	}

	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Unseen_Monster_Summon_Start_Engage in cACS_Unseen_Blade_Summon
{
	private var temp, temp_bossbar												: CEntityTemplate;
	private var ent, ent_bossbar												: CEntity;
	private var i, count, j														: int;
	private var playerPos, spawnPos, newSpawnPos								: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp, meshcomp_bossbar										: CComponent;
	private var animcomp, animcomp_bossbar 										: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	private var actors															: array<CActor>;
	private var npc																: CNewNPC;
	private var animatedComponentA												: CAnimatedComponent;
	private var movementAdjustorNPC												: CMovementAdjustor; 
	private var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Unseen_Monster_Summon_Start_Entry();
	}
	
	entry function ACS_Unseen_Monster_Summon_Start_Entry()
	{
		ACS_Unseen_Monster_Summon_Start_Latent();

		UnseenMonsterSetAttitude();

		UnseenMonsterSpawnRotate();

		UnseenMonsterSpawnAnim();
	}
	
	latent function ACS_Unseen_Monster_Summon_Start_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\vampire_monster.w2ent"
			
		, true );

		temp_bossbar = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\vampire_monster_bossbar_dummy.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = 1;

		ACSVampireMonster().Destroy();

		ACSVampireMonsterBossBar().Destroy();
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( RandF() < 0.5 ) 
			{
				GetWitcherPlayer().DisplayHudMessage( "I WILL TEAR YOU LIMB FROM LIMB" );
			}
			else
			{
				GetWitcherPlayer().DisplayHudMessage( "I SHALL FEAST UPON YOUR CORPSE AND BATHE IN YOUR BLOOD" );
			}

			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
			((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			//((CNewNPC)ent).SetCanPlayHitAnim(false);

			ent.PlayEffectSingle('dive_shape');
			ent.StopEffect('dive_shape');

			ent.PlayEffectSingle('smoke_explosion');
			ent.StopEffect('smoke_explosion');

			ent.PlayEffectSingle('third_teleport_out');
			ent.StopEffect('third_teleport_out');

			ent.AddTag( 'ACS_Vampire_Monster' );

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag('NoBestiaryEntry');

			((CActor)ent).SetImmortalityMode( AIM_None, AIC_Default ); 

			ent_bossbar = theGame.CreateEntity( temp_bossbar, playerPos, adjustedRot );

			((CActor)ent_bossbar).SetCanPlayHitAnim(false); 

			((CNewNPC)ent_bossbar).SetCanPlayHitAnim(false); 

			((CActor)ent_bossbar).EnableCharacterCollisions(false);

			((CActor)ent_bossbar).EnableCollisions(false);	

			((CNewNPC)ent_bossbar).EnableCharacterCollisions(false);

			((CNewNPC)ent_bossbar).EnableCollisions(false);	

			((CNewNPC)ent_bossbar).SetLevel(GetWitcherPlayer().GetLevel());
			((CNewNPC)ent_bossbar).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
			((CActor)ent_bossbar).SetAnimationSpeedMultiplier(0);

			((CActor)ent_bossbar).SetVisibility(false);

			((CActor)ent_bossbar).AddBuffImmunity_AllNegative('ACS_Vampire_Boss_Bar', true); 

			((CActor)ent_bossbar).AddBuffImmunity_AllCritical('ACS_Vampire_Boss_Bar', true); 

			((CActor)ent_bossbar).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

			((CNewNPC)ent_bossbar).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

			ent_bossbar.CreateAttachment(ent,,Vector(0,0,1),EulerAngles(0,0,0));

			animcomp_bossbar = (CAnimatedComponent)ent_bossbar.GetComponentByClassName('CAnimatedComponent');
			animcomp_bossbar.FreezePoseFadeIn(1);

			meshcomp_bossbar = ent_bossbar.GetComponentByClassName('CMeshComponent');
			meshcomp_bossbar.SetScale(Vector(0,0,0,0));	
			
			ent_bossbar.AddTag( 'ACS_Vampire_Monster_Boss_Bar' );

			((CNewNPC)ent_bossbar).SetAttitude(((CActor)ent), AIA_Friendly);
			((CNewNPC)ent).SetAttitude(((CActor)ent_bossbar), AIA_Friendly);
		}
	}

	latent function UnseenMonsterSetAttitude()
	{
		actors.Clear();
		
		actors = ACSVampireMonster().GetNPCsAndPlayersInRange( 20, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( j = 0; j < actors.Size(); j += 1 )
			{
				npc = (CNewNPC)actors[j];

				if (
				npc.IsAlive()
				&& npc.HasAbility('mon_vampiress_base')
				)			
				{
					((CNewNPC)ACSVampireMonster()).SetAttitude(npc, AIA_Friendly);

					((CNewNPC)npc).SetAttitude(ACSVampireMonster(), AIA_Friendly);

				}
			}
		}
	}

	latent function UnseenMonsterSpawnRotate()
	{
		movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Unseen_Monster_Spawn_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Unseen_Monster_Spawn_Rotate' );

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Unseen_Monster_Spawn_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );
		movementAdjustorNPC.Continuous(ticketNPC);

		movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );
	}

	latent function UnseenMonsterSpawnAnim()
	{
		animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );	

		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_diving', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

		GetACSWatcher().SetVampireMonsterSpawnProcess(true);
		
		GetACSWatcher().AddTimer('VampireMonsterDiveCancel', 3, false);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_VampireMonsterManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;
	var wing_temp_1, wing_temp_2, wing_temp_3																				: CEntityTemplate;
	var p_comp 																												: CComponent;

	if (!ACSVampireMonster() || !ACSVampireMonster().IsAlive())
	{
		return;
	}

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( ACSVampireMonster().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (ACSVampireMonster()
	&& ACSVampireMonster().IsAlive()
	&& ACSVampireMonster().IsInCombat())
	{
		if (ACS_vampire_monster_abilities()
		&& GetACSWatcher().ACS_Vampire_Monster_Flying_Process == false
		&& GetACSWatcher().ACS_Vampire_Monster_Spawn_Process == false )
		{
			ACS_refresh_vampire_monster_cooldown();

			ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Vampire_Monster_Abilities_Rotate');
			movementAdjustorNPC.CancelByName( 'ACS_Vampire_Monster_Abilities_Rotate' );
			movementAdjustorNPC.CancelAll();

			ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Vampire_Monster_Abilities_Rotate' );
			movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
			movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

			movementAdjustorNPC.Continuous(ticketNPC);

			movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

			ACSVampireMonster().StopEffect('swarm_light');
			ACSVampireMonster().PlayEffectSingle('swarm_light');

			if ( targetDistance < 2 * 2 )
			{
				animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_fly_phase2_start', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));
				ACS_VampireMonsterFlyingStartDamage();

				ACSVampireMonster().StopEffect('shadowdash');
				ACSVampireMonster().PlayEffectSingle('shadowdash');

				GetACSWatcher().RemoveTimer('VampireMonsterCancel');

				GetACSWatcher().AddTimer('VampireMonsterCancel', 1, false);
			}
			else if ( targetDistance >= 2 * 2 )
			{
				GetWitcherPlayer().SetFlyingBossCamera( true );

				GetACSWatcher().SetVampireMonsterFlyingProcess(true);

				p_comp = ACSVampireMonster().GetComponentByClassName( 'CAppearanceComponent' );

				wing_temp_1 = (CEntityTemplate)LoadResource(
				"dlc\bob\data\characters\models\monsters\detlaff_monster\detlaff_wings.w2ent"
				, true);	
				
				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(wing_temp_1);

				wing_temp_2 = (CEntityTemplate)LoadResource(
				"dlc\dlc_acs\data\models\vampire_monster\wings_bloody_large.w2ent"
				, true);	
				
				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(wing_temp_2);

				wing_temp_3 = (CEntityTemplate)LoadResource(
				"dlc\dlc_acs\data\models\vampire_monster\wings_large.w2ent"
				, true);	
				
				((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(wing_temp_3);

				animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_fly_phase2_start', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));

				ACS_VampireMonsterFlyingStartDamage();

				ACSVampireMonster().StopEffect('swarm_attack');
				ACSVampireMonster().PlayEffectSingle('swarm_attack');
				
				GetACSWatcher().RemoveTimer('VampireMonsterFlyAttack');

				GetACSWatcher().AddTimer('VampireMonsterFlyAttack', 3, false);
			}
		}
	}
}

function ACS_VampireMonsterFlyingStartDamage()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;

	ACSVampireMonster().PlayEffectSingle('shadowdash');
	ACSVampireMonster().StopEffect('shadowdash');

	ACSVampireMonster().PlayEffectSingle('smoke_explosion');
	ACSVampireMonster().StopEffect('smoke_explosion');

	ACSVampireMonster().PlayEffectSingle('third_teleport_out');
	ACSVampireMonster().StopEffect('third_teleport_out');

	ACSVampireMonster().PlayEffectSingle('third_dash');
	ACSVampireMonster().StopEffect('third_dash');

	victims.Clear();

	//victims = ACSVampireMonster().GetNPCsAndPlayersInCone(5, VecHeading(ACSVampireMonster().GetHeadingVector()), 360, 20, , FLAG_OnlyAliveActors );

	victims = ACSVampireMonster().GetNPCsAndPlayersInRange( 5, 5, , FLAG_OnlyAliveActors);

	if (ACSVampireMonster().IsAlive())
	{
		if( victims.Size() > 0)
		{
			for( i = 0; i < victims.Size(); i += 1 )
			{
				actortarget = (CActor)victims[i];

				if (actortarget != ACSVampireMonster()
				&& actortarget != ACSVampireMonsterBossBar()
				&& actortarget != GetACSTentacle_1()
				&& actortarget != GetACSTentacle_2()
				&& actortarget != GetACSTentacle_3()
				&& actortarget != GetACSNecrofiendTentacle_1()
				&& actortarget != GetACSNecrofiendTentacle_2()
				&& actortarget != GetACSNecrofiendTentacle_3()
				&& actortarget != GetACSNecrofiendTentacle_4()
				&& actortarget != GetACSNecrofiendTentacle_5()
				&& actortarget != GetACSNecrofiendTentacle_6()
				&& actortarget != GetACSNecrofiendTentacleAnchor()
				&& actortarget != GetACSTentacleAnchor()
				)
				{
					if 
					(
						GetWitcherPlayer().IsAnyQuenActive()
					)
					{
						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else
					{
						movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.GetRequest( 'ACS_Vampire_Monster_Hit_Rotate');
						movementAdjustor.CancelByName( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.CancelAll();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.AdjustmentDuration( ticket, 0.1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, ACSVampireMonster() );

						if (actortarget == GetWitcherPlayer())
						{
							AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

							AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

							if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
							{
								GetACSWatcher().Grow_Geralt_Immediate_Fast();

								GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
							}

							GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
						}

						actortarget.SoundEvent("cmb_play_dismemberment_gore");

						actortarget.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						params.effectType = EET_Knockdown;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Knockdown";
						params.duration = 1;

						actortarget.AddEffectCustom( params );
					}
				}
			}
		}
	}
}

function ACS_VampireMonsterFlyAttackActual()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var playerRot, adjustedRot 																								: EulerAngles;
	var swarmattackent_1, swarmattackent_2, swarmattackent_3																: CEntity;
	var distAttack, distSwarmAttack																							: float;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	adjustedRot = EulerAngles(0,0,0);

	adjustedRot.Yaw = playerRot.Yaw;

	//ACSVampireMonster().PlayEffectSingle('shadowdash_body_blood');
	//ACSVampireMonster().StopEffect('shadowdash_body_blood');

	ACSVampireMonster().PlayEffectSingle('shadowdash');
	ACSVampireMonster().StopEffect('shadowdash');

	ACSVampireMonster().PlayEffectSingle('smoke_explosion');
	ACSVampireMonster().StopEffect('smoke_explosion');

	ACSVampireMonster().PlayEffectSingle('third_teleport_out');
	ACSVampireMonster().StopEffect('third_teleport_out');

	ACSVampireMonster().PlayEffectSingle('third_dash');
	ACSVampireMonster().StopEffect('third_dash');

	ACSVampireMonster().StopEffect('swarm_light');
	ACSVampireMonster().PlayEffectSingle('swarm_light');

	ACSVampireMonster().StopEffect('swarm_gathers');
	ACSVampireMonster().PlayEffectSingle('swarm_gathers');
	ACSVampireMonster().PlayEffectSingle('swarm_gathers');
	ACSVampireMonster().PlayEffectSingle('swarm_gathers');
	ACSVampireMonster().PlayEffectSingle('swarm_gathers');
	ACSVampireMonster().PlayEffectSingle('swarm_gathers');

	distAttack = ((((CMovingPhysicalAgentComponent)ACSVampireMonster().GetMovingAgentComponent()).GetCapsuleRadius())
	+ (((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) ) * 1.5;

	distSwarmAttack = ((((CMovingPhysicalAgentComponent)ACSVampireMonster().GetMovingAgentComponent()).GetCapsuleRadius())
	+ (((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) ) * 20;

	ACSVampireMonster().AddTag('ACS_Fly_Attack_Started');

	if (!ACSVampireMonster().HasTag('ACS_Fly_Attack_1'))
	{
		ACSVampireMonster().PlayEffectSingle('teleport');
		ACSVampireMonster().StopEffect('teleport');

		//ACSVampireMonster().TeleportWithRotation(ACSPlayerFixZAxis(theCamera.GetCameraPosition() + theCamera.GetCameraForward() * 8), rot);

		GetACSWatcher().RemoveTimer('VampireMonsterTeleport');
		GetACSWatcher().AddTimer('VampireMonsterTeleport', 1.25, false);
	
		movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Vampire_Monster_Abilities_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Vampire_Monster_Abilities_Rotate' );
		movementAdjustorNPC.CancelAll();

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Vampire_Monster_Abilities_Rotate' );
		
		animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );

		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		movementAdjustorNPC.Continuous(ticketNPC);

		movementAdjustorNPC.RotateTowards(ticketNPC, GetWitcherPlayer() );

		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_fly_attack_split_a', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));

		GetACSWatcher().RemoveTimer('VampireMonsterFlyAttackDamage');
		GetACSWatcher().AddTimer('VampireMonsterFlyAttackDamage', 3, false);

		GetACSWatcher().RemoveTimer('VampireMonsterDive');
		GetACSWatcher().AddTimer('VampireMonsterDive', 4, false);

		ACSVampireMonster().AddTag('ACS_Fly_Attack_1');
	}
	else if (ACSVampireMonster().HasTag('ACS_Fly_Attack_1'))
	{
		//ACSVampireMonster().StopEffect('swarm_attack');
		//ACSVampireMonster().PlayEffectSingle('swarm_attack');

		ACSVampireMonster().PlayEffectSingle('shadowdash_body_blood');
		ACSVampireMonster().StopEffect('shadowdash_body_blood');

		//ACSVampireMonster().TeleportWithRotation(ACSPlayerFixZAxis(theCamera.GetCameraPosition() + theCamera.GetCameraForward() * 15), rot);
	
		movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Vampire_Monster_Abilities_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Vampire_Monster_Abilities_Rotate' );
		movementAdjustorNPC.CancelAll();

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Vampire_Monster_Abilities_Rotate' );
		
		animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );

		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		movementAdjustorNPC.Continuous(ticketNPC);

		movementAdjustorNPC.RotateTowards(ticketNPC, GetWitcherPlayer() );

		movementAdjustorNPC.SlideTowards(ticketNPC, GetWitcherPlayer(), distSwarmAttack, distSwarmAttack);

		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_fly_swarm_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));

		swarmattackent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\dettlaff_swarm_attack_blood.w2ent"
			, true ), ACSVampireMonster().GetWorldPosition(), ACSVampireMonster().GetWorldRotation() );
		
		swarmattackent_1.CreateAttachment( ACSVampireMonster(), , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );

		swarmattackent_1.PlayEffectSingle('swarm_attack');

		swarmattackent_1.DestroyAfter(7);

		swarmattackent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\dettlaff_swarm_attack_blood.w2ent"
			, true ), ACSVampireMonster().GetWorldPosition(), ACSVampireMonster().GetWorldRotation() );
		
		swarmattackent_2.CreateAttachment( ACSVampireMonster(), , Vector( 9, 0, 0 ), EulerAngles(0,45,0) );

		swarmattackent_2.PlayEffectSingle('swarm_attack');

		swarmattackent_2.DestroyAfter(7);

		swarmattackent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\dettlaff_swarm_attack_blood.w2ent"
			, true ), ACSVampireMonster().GetWorldPosition(), ACSVampireMonster().GetWorldRotation() );
		
		swarmattackent_3.CreateAttachment( ACSVampireMonster(), , Vector( -9, 0, 0 ), EulerAngles(0,-45,0) );

		swarmattackent_3.PlayEffectSingle('swarm_attack');

		swarmattackent_3.DestroyAfter(7);

		GetACSWatcher().RemoveTimer('VampireMonsterSwarmAttackDamage');
		GetACSWatcher().AddTimer('VampireMonsterSwarmAttackDamage', 4.75, false);

		GetACSWatcher().RemoveTimer('VampireMonsterDive');
		GetACSWatcher().AddTimer('VampireMonsterDive', 7, false);

		ACSVampireMonster().RemoveTag('ACS_Fly_Attack_1');
	}
}

function ACS_VampireMonsterTeleportActual()
{
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var distAttack, targetDistance																							: float;

	distAttack = ((((CMovingPhysicalAgentComponent)ACSVampireMonster().GetMovingAgentComponent()).GetCapsuleRadius())
	+ (((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) ) * 2 ;

	movementAdjustorNPC = ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

	ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Vampire_Monster_Abilities_Rotate');
	movementAdjustorNPC.CancelByName( 'ACS_Vampire_Monster_Abilities_Rotate' );
	movementAdjustorNPC.CancelAll();

	ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Vampire_Monster_Abilities_Rotate' );

	movementAdjustorNPC.AdjustLocationVertically(ticketNPC, true);

	movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.1 );
	movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

	targetDistance = VecDistanceSquared2D( ACSVampireMonster().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (targetDistance <= 40 * 40)
	{
		movementAdjustorNPC.MaxLocationAdjustmentSpeed( ticketNPC, 12.5 );
	}
	else
	{
		movementAdjustorNPC.MaxLocationAdjustmentSpeed( ticketNPC, 50 );
	}
	
	movementAdjustorNPC.Continuous( ticketNPC );

	movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

	movementAdjustorNPC.SlideTowards( ticketNPC, GetWitcherPlayer(), distAttack, distAttack );
}

function ACS_VampireMonsterSwarmAttackDamage()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;

	victims.Clear();

	victims = ACSVampireMonster().GetNPCsAndPlayersInCone(30, VecHeading(ACSVampireMonster().GetHeadingVector()), 90, 20, , FLAG_OnlyAliveActors );

	if (ACSVampireMonster().IsAlive())
	{
		if( victims.Size() > 0)
		{
			for( i = 0; i < victims.Size(); i += 1 )
			{
				actortarget = (CActor)victims[i];

				if (actortarget != ACSVampireMonster()
				&& actortarget != ACSVampireMonsterBossBar()
				&& actortarget != GetACSTentacle_1()
				&& actortarget != GetACSTentacle_2()
				&& actortarget != GetACSTentacle_3()
				&& actortarget != GetACSTentacleAnchor()
				&& actortarget != GetACSNecrofiendTentacle_1()
				&& actortarget != GetACSNecrofiendTentacle_2()
				&& actortarget != GetACSNecrofiendTentacle_3()
				&& actortarget != GetACSNecrofiendTentacle_4()
				&& actortarget != GetACSNecrofiendTentacle_5()
				&& actortarget != GetACSNecrofiendTentacle_6()
				&& actortarget != GetACSNecrofiendTentacleAnchor()
				)
				{
					if 
					(
						GetWitcherPlayer().IsInGuardedState()
						|| GetWitcherPlayer().IsGuarded()
					)
					{
						GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
						GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
					}
					else if 
					(
						GetWitcherPlayer().IsAnyQuenActive()
					)
					{
						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else if 
					(
						GetWitcherPlayer().IsCurrentlyDodging()
					)
					{
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else
					{
						movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.GetRequest( 'ACS_Vampire_Monster_Hit_Rotate');
						movementAdjustor.CancelByName( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.CancelAll();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.AdjustmentDuration( ticket, 0.1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, ACSVampireMonster() );

						if (actortarget == GetWitcherPlayer())
						{
							AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

							AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

							if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
							{
								GetACSWatcher().Grow_Geralt_Immediate_Fast();

								GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
							}

							GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
						}

						if (actortarget.UsesVitality())
						{
							actortarget.DrainVitality(actortarget.GetStat(BCS_Vitality) * 0.3);
						}
						else if (actortarget.UsesEssence())
						{
							actortarget.DrainEssence(actortarget.GetStat(BCS_Essence) * 0.3);
						}

						actortarget.SoundEvent("cmb_play_dismemberment_gore");

						actortarget.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						params.effectType = EET_Knockdown;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Knockdown";
						params.duration = 1;

						actortarget.AddEffectCustom( params );

						params.effectType = EET_Bleeding;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Bleeding";
						params.duration = 10;

						actortarget.AddEffectCustom( params );
					}
				}
			}
		}
	}
}

function ACS_VampireMonsterFlyAttackDamage()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;

	victims.Clear();

	victims = ACSVampireMonster().GetNPCsAndPlayersInCone(5, VecHeading(ACSVampireMonster().GetHeadingVector()), 90, 20, , FLAG_OnlyAliveActors );

	if (ACSVampireMonster().IsAlive())
	{
		if( victims.Size() > 0)
		{
			for( i = 0; i < victims.Size(); i += 1 )
			{
				actortarget = (CActor)victims[i];

				if (actortarget != ACSVampireMonster()
				&& actortarget != ACSVampireMonsterBossBar()
				&& actortarget != GetACSTentacle_1()
				&& actortarget != GetACSTentacle_2()
				&& actortarget != GetACSTentacle_3()
				&& actortarget != GetACSTentacleAnchor()
				&& actortarget != GetACSNecrofiendTentacle_1()
				&& actortarget != GetACSNecrofiendTentacle_2()
				&& actortarget != GetACSNecrofiendTentacle_3()
				&& actortarget != GetACSNecrofiendTentacle_4()
				&& actortarget != GetACSNecrofiendTentacle_5()
				&& actortarget != GetACSNecrofiendTentacle_6()
				&& actortarget != GetACSNecrofiendTentacleAnchor()
				)
				{
					if 
					(
						GetWitcherPlayer().IsInGuardedState()
						|| GetWitcherPlayer().IsGuarded()
					)
					{
						GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
						GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
					}
					else if 
					(
						GetWitcherPlayer().IsAnyQuenActive()
					)
					{
						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else if 
					(
						GetWitcherPlayer().IsCurrentlyDodging()
					)
					{
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else
					{
						movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.GetRequest( 'ACS_Vampire_Monster_Hit_Rotate');
						movementAdjustor.CancelByName( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.CancelAll();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_Vampire_Monster_Hit_Rotate' );
						movementAdjustor.AdjustmentDuration( ticket, 0.1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, ACSVampireMonster() );

						if (actortarget == GetWitcherPlayer())
						{
							AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

							AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

							if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
							{
								GetACSWatcher().Grow_Geralt_Immediate_Fast();

								GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
							}

							GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
						}

						if (actortarget.UsesVitality())
						{
							actortarget.DrainVitality(actortarget.GetStat(BCS_Vitality) * 0.3);
						}
						else if (actortarget.UsesEssence())
						{
							actortarget.DrainEssence(actortarget.GetStat(BCS_Essence) * 0.3);
						}

						actortarget.SoundEvent("cmb_play_dismemberment_gore");

						actortarget.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						params.effectType = EET_Knockdown;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Knockdown";
						params.duration = 1;

						actortarget.AddEffectCustom( params );

						params.effectType = EET_Bleeding;
						params.creator = ACSVampireMonster();
						params.sourceName = "ACS_Vampire_Monster_Bleeding";
						params.duration = 10;

						actortarget.AddEffectCustom( params );
					}
				}
			}
		}
	}
}

function ACS_VampireMonsterDiveActual()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor;
	var playerRot, adjustedRot																								: EulerAngles;
	var position, newSpawnPos 																								: Vector;
	var wing_temp_1, wing_temp_2, wing_temp_3																				: CEntityTemplate;
	var p_comp 																												: CComponent;

	GetWitcherPlayer().SetFlyingBossCamera( false );

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	adjustedRot = EulerAngles(0,0,0);

	adjustedRot.Yaw = playerRot.Yaw;

	ACSVampireMonster().PlayEffectSingle('shadowdash_body_blood');
	ACSVampireMonster().StopEffect('shadowdash_body_blood');

	ACSVampireMonster().StopEffect('shadowdash');
	ACSVampireMonster().PlayEffectSingle('shadowdash');

	ACSVampireMonster().StopEffect('smoke_explosion');
	ACSVampireMonster().PlayEffectSingle('smoke_explosion');

	ACSVampireMonster().StopEffect('third_teleport_out');
	ACSVampireMonster().PlayEffectSingle('third_teleport_out');

	ACSVampireMonster().StopEffect('third_dash');
	ACSVampireMonster().PlayEffectSingle('third_dash');

	ACSVampireMonster().StopEffect('swarm_attack');
	ACSVampireMonster().PlayEffectSingle('swarm_attack');

	ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor().CancelAll();

	position = ACSPlayerFixZAxis(theCamera.GetCameraPosition() + theCamera.GetCameraForward() * 3);

	if( !theGame.GetWorld().NavigationFindSafeSpot( position, 0.3, 0.3 , newSpawnPos ) )
	{
		theGame.GetWorld().NavigationFindSafeSpot( position, 0.3, 4 , newSpawnPos );
		position = newSpawnPos;
	}

	ACSVampireMonster().TeleportWithRotation(ACSPlayerFixZAxis(position), adjustedRot);
	
	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );	
	animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_diving', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0));

	p_comp = ACSVampireMonster().GetComponentByClassName( 'CAppearanceComponent' );
		
	wing_temp_1 = (CEntityTemplate)LoadResource(
	"dlc\bob\data\characters\models\monsters\detlaff_monster\detlaff_wings.w2ent"
	, true);	
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(wing_temp_1);

	wing_temp_2 = (CEntityTemplate)LoadResource(
	"dlc\dlc_acs\data\models\vampire_monster\wings_bloody_large.w2ent"
	, true);	
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(wing_temp_2);

	wing_temp_3 = (CEntityTemplate)LoadResource(
	"dlc\dlc_acs\data\models\vampire_monster\wings_large.w2ent"
	, true);	
	
	((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(wing_temp_3);

	ACSVampireMonster().RemoveTag('ACS_Fly_Attack_Started');

	GetACSWatcher().RemoveTimer('VampireMonsterDiveCancel');
	GetACSWatcher().AddTimer('VampireMonsterDiveCancel', 3, false);
}

function ACS_VampireMonsterDiveCancelActual()
{
	ACS_VampireMonsterCancelActual();

	GetACSWatcher().RemoveTimer('VampireMonsterSetFlyingProcessFalse');
	GetACSWatcher().AddTimer('VampireMonsterSetFlyingProcessFalse', 20, false);

	GetACSWatcher().RemoveTimer('VampireMonsterSetSpawnProcessFalse');
	GetACSWatcher().AddTimer('VampireMonsterSetSpawnProcessFalse', 3, false);
}

function ACS_VampireMonsterCancelActual()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 

	ACSVampireMonster().GetMovingAgentComponent().GetMovementAdjustor().CancelAll();

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSVampireMonster()).GetComponentByClassName( 'CAnimatedComponent' );

	if (!ACSVampireMonster().HasTag('ACS_Construct_Combo_1')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_2')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_3')
	)
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_combo_attack_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 0));

		ACSVampireMonster().AddTag('ACS_Construct_Combo_1');
	}
	else if (ACSVampireMonster().HasTag('ACS_Construct_Combo_1')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_2')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_3')
	)
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_combo_attack_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 0));

		ACSVampireMonster().AddTag('ACS_Construct_Combo_2');
	}
	else if (ACSVampireMonster().HasTag('ACS_Construct_Combo_1')
	&& ACSVampireMonster().HasTag('ACS_Construct_Combo_2')
	&& !ACSVampireMonster().HasTag('ACS_Construct_Combo_3')
	) 
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_combo_attack_03', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 0));

		ACSVampireMonster().AddTag('ACS_Construct_Combo_3');
	}
	else if (ACSVampireMonster().HasTag('ACS_Construct_Combo_1')
	&& ACSVampireMonster().HasTag('ACS_Construct_Combo_2')
	&& ACSVampireMonster().HasTag('ACS_Construct_Combo_3')
	) 
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_combo_attack_04', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(1, 0));

		ACSVampireMonster().RemoveTag('ACS_Construct_Combo_1');
		ACSVampireMonster().RemoveTag('ACS_Construct_Combo_2');
		ACSVampireMonster().RemoveTag('ACS_Construct_Combo_3');
	}
}

class CACSVampireMonster extends CNewNPC
{
	var numberOfHits 						: int;
	var destroyCalled						: bool;
	var percLife							: float;
	var chunkLife							: float;
	var healthBarPerc						: float;
	var lastHitTimestamp					: float;
	var testedHitTimestamp					: float;
	var l_temp								: float;
	
	editable var timeBetweenHits			: float;
	editable var timeBetweenFireDamage		: float;
	editable var baseStat					: EBaseCharacterStats;
	editable var requiredHits				: int;
	editable var effectOnTakeDamage			: name;
	editable var timeToDestroy				: float;

	default destroyCalled = false;
	default timeBetweenHits = 0.5f;
	default timeBetweenFireDamage = 1.0f;
	default baseStat = BCS_Vitality;
	default requiredHits = 30;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned( spawnData );
		SoundSwitch( "dettlaff_monster", "dettlaff_construct", 'Head' );
		requiredHits = 30;
	}
	
	function AddHit()
	{
		lastHitTimestamp = theGame.GetEngineTimeAsSeconds();
		numberOfHits+=1;
		RaiseEvent('AdditiveHit');
		SoundEvent("cmd_heavy_hit");
		percLife = (100/requiredHits)*0.01;	
		chunkLife = ( GetStatMax( BCS_Essence ) )* percLife;
		ForceSetStat( BCS_Essence, ( GetStat( BCS_Essence ) - chunkLife ));
		CheckHitsCounter();

		if (ACSVampireMonster().IsAlive() && !ACSVampireMonster().HasTag('acs_vampire_monster_not_alive_state'))
		{
			if (ACSVampireMonsterBossBar().UsesEssence())
			{
				ACSVampireMonsterBossBar().DrainEssence(ACSVampireMonsterBossBar().GetStatMax( BCS_Essence ) * 0.0125);
			}
			else if (ACSVampireMonsterBossBar().UsesVitality())
			{
				ACSVampireMonsterBossBar().DrainVitality(ACSVampireMonsterBossBar().GetStatMax( BCS_Vitality ) * 0.0125);
			}

			StopEffect('vampire_monster_on_hit');
			PlayEffectSingle('vampire_monster_on_hit');
			//SoundEvent("monster_dettlaff_monster_construct_death");
		}
	}
	
	function CheckHitsCounter()
	{
		if( numberOfHits >= requiredHits )
		{
			if( !destroyCalled )
			{
				DestroyEntity();
			}
		}
	}
	
	function DestroyEntity()
	{
		destroyCalled = true;
	}
	
	event OnTakeDamage( action : W3DamageAction )
	{	
		testedHitTimestamp = theGame.GetEngineTimeAsSeconds();
		if( action.attacker == GetWitcherPlayer() && action.DealsAnyDamage() && ( testedHitTimestamp > lastHitTimestamp + timeBetweenHits ) && !action.HasDealtFireDamage() )
		{
			AddHit();
		}
		else if( action.attacker == GetWitcherPlayer() && action.DealsAnyDamage() && ( testedHitTimestamp > lastHitTimestamp + timeBetweenFireDamage ) && action.HasDealtFireDamage())
		{
			AddHit();
			PlayEffectSingle('critical_burning');
			AddTimer('StopBurningFX', 2.0f, false );
		}
		
		if( destroyCalled )
		{
			numberOfHits = 0;
			destroyCalled = false;
			OnDeath(action);
		}
	}
	
	timer function StopBurningFX(dt : float, id : int)
	{
		StopEffect('critical_burning');
	}
}

function ACS_Blade_Of_The_Unseen() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Blade_Of_The_Unseen' );
	return entity;
}

function ACSVampireMonster() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Vampire_Monster' );
	return entity;
}

function ACSVampireMonsterBossBar() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Vampire_Monster_Boss_Bar' );
	return entity;
}

function ACS_Novigrad_Underground_Vampire() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'novigrad_underground_vampire' );
	return entity;
}

function ACS_Hubert_Rejk_Vampire() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'hubert_rejk_vampire' );
	return entity;
}

function ACS_Orianna_Vampire() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'acs_orianna_vampire' );
	return entity;
}

function ACS_Orianna_Vampire_Base() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'acs_orianna_vampire_base' );
	return entity;
}

function GetACS_Blade_Of_The_Unseen_L_Blade() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Blade_Of_The_Unseen_L_Blade' );
	return entity;
}

function GetACS_Blade_Of_The_Unseen_R_Blade() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Blade_Of_The_Unseen_R_Blade' );
	return entity;
}

function GetACS_Blade_Of_The_Unseen_R_Anchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Unseen_Blade_R_Anchor' );
	return entity;
}

function GetACS_Blade_Of_The_Unseen_L_Anchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Unseen_Blade_L_Anchor' );
	return entity;
}

function ACS_BladeOfTheUnseenDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Blade_Of_The_Unseen().GetWorldPosition(), ACS_Blade_Of_The_Unseen().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_VampireMonsterDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACSVampireMonster().GetWorldPosition(), ACSVampireMonster().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');
	ent.PlayEffectSingle('swarm_attack');
	ent.PlayEffectSingle('swarm_attack');
	ent.PlayEffectSingle('swarm_attack');
	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_NovigradUndergroundVampireDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Novigrad_Underground_Vampire().GetWorldPosition(), ACS_Novigrad_Underground_Vampire().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_HubertRejkVampireDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Hubert_Rejk_Vampire().GetWorldPosition(), ACS_Hubert_Rejk_Vampire().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_OriannaVampireDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Orianna_Vampire().GetWorldPosition(), ACS_Orianna_Vampire().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_OriannaVampireSpawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Orianna_Vampire_Base().GetWorldPosition(), ACS_Orianna_Vampire_Base().GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

function ACS_TransformationVampireMonsterDespawnEffect()
{
	var ent : CEntity;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACSFixZAxis(thePlayer.GetWorldPosition()), thePlayer.GetWorldRotation() );

	ent.PlayEffectSingle('swarm_attack');

	ent.DestroyAfter(2);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class ACSOriannaDisappearController extends CEntity
{
	private var fear_index_1																												: int;
	private var previous_fear_index_1																										: int;

	default fear_index_1 																													= -1;
	default previous_fear_index_1 																											= -1;


	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('OriannaActiveCheck', 0.0001, true);
	}

	timer function OriannaActiveCheck( time : float, optional id : int)
	{
		if (FactsQuerySum("q704_orianas_part_done") > 0 
		&& FactsQuerySum("ACS_Orianna_Killed") <= 0
		)
		{
			this.PushState('SpawnOriannaBase');

			if (FactsQuerySum("ACS_Orianna_Singing_Range") > 0)
			{
				FactsRemove("ACS_Orianna_Singing_Range");
			}

			AddTimer('DetectLife', 0.0001, true);

			GetACSWatcher().ACSOriannaBasePlayAnim('woman_noble_enjoying_nature_02', 0.25, 0.25f);

			AddTimer('OriannaIdleAction', 5, false);

			RemoveTimer('OriannaActiveCheck');
		}
	}

	timer function OriannaIdleAction( time : float, optional id : int)
	{
		/*
		var vampiress_taunt_anim_names	: array<name>;

		vampiress_taunt_anim_names.Clear();

		vampiress_taunt_anim_names.PushBack('woman_noble_enjoying_nature_01');
		vampiress_taunt_anim_names.PushBack('woman_noble_enjoying_nature_02');
		vampiress_taunt_anim_names.PushBack('woman_noble_posing_mirror_loop_01');
		vampiress_taunt_anim_names.PushBack('woman_work_searching_ground_loop_01');
		vampiress_taunt_anim_names.PushBack('woman_work_searching_ground_loop_02');
		vampiress_taunt_anim_names.PushBack('woman_work_searching_ground_loop_03');

		GetACSWatcher().ACSOriannaBasePlayAnim(vampiress_taunt_anim_names[RandRange(vampiress_taunt_anim_names.Size())], 0.75f, 0.875f);
		*/

		fear_index_1 = RandDifferent(this.previous_fear_index_1 , 6);

		switch (fear_index_1) 
		{	
			case 5:
			GetACSWatcher().ACSOriannaBasePlayAnim('woman_noble_enjoying_nature_01', 0.75f, 0.875f);

			RemoveTimer('OriannaIdleAction');
			AddTimer('OriannaIdleAction', 10, false);
			break;

			case 4:
			GetACSWatcher().ACSOriannaBasePlayAnim('woman_noble_enjoying_nature_02', 0.75f, 0.875f);

			RemoveTimer('OriannaIdleAction');
			AddTimer('OriannaIdleAction', 10, false);
			break;

			case 3:
			GetACSWatcher().ACSOriannaBasePlayAnim('woman_noble_posing_mirror_loop_01', 0.75f, 0.875f);

			RemoveTimer('OriannaIdleAction');
			AddTimer('OriannaIdleAction', 10, false);
			break;

			case 2:
			GetACSWatcher().ACSOriannaBasePlayAnim('woman_work_searching_ground_loop_01', 0.75f, 0.875f);

			RemoveTimer('OriannaIdleAction');
			AddTimer('OriannaIdleAction', 5, false);
			break;

			case 1:
			GetACSWatcher().ACSOriannaBasePlayAnim('woman_work_searching_ground_loop_02', 0.75f, 0.875f);

			RemoveTimer('OriannaIdleAction');
			AddTimer('OriannaIdleAction', 5, false);
			break;

			default:
			GetACSWatcher().ACSOriannaBasePlayAnim('woman_work_searching_ground_loop_03', 0.75f, 0.875f);

			RemoveTimer('OriannaIdleAction');
			AddTimer('OriannaIdleAction', 5, false);
			break;		
		}
		
		this.previous_fear_index_1 = fear_index_1;
	}

	timer function OriannaLine1( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().PlayLine( 1174593, true);

		AddTimer('OriannaLine2', 10, false);
	}

	timer function OriannaLine2( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().PlayLine( 1176970, true);

		if (RandF() < 0.5)
		{
			AddTimer('GeraltLine1', 14, false);

			AddTimer('OriannaLine3', 16, false);
		}
		else
		{
			AddTimer('OriannaLine3', 14, false);
		}
	}

	timer function OriannaLine3( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().PlayLine( 1179997, true);

		AddTimer('OriannaLine4', 5.5, false);
	}

	timer function OriannaLine4( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().PlayLine( 1179999, true);

		AddTimer('OriannaLine5', 5.5, false);
	}

	timer function OriannaLine5( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().PlayLine( 1180001, true);

		AddTimer('OriannaLine6', 5.5, false);
	}

	timer function OriannaLine6( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().PlayLine( 1180003, true);

		AddTimer('OriannaLine1', 7, false);
	}

	timer function OriannaLine7( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().PlayLine( 1174627, true);
	}

	timer function GeraltLine1( time : float, optional id : int)
	{
		thePlayer.PlayLine( 1157736, true);
	}

	function RemoveOriannaLinesAll()
	{
		RemoveTimer('OriannaLine1');
		RemoveTimer('OriannaLine2');
		RemoveTimer('OriannaLine3');
		RemoveTimer('OriannaLine4');
		RemoveTimer('OriannaLine5');
		RemoveTimer('OriannaLine6');
		RemoveTimer('OriannaLine7');

		RemoveTimer('GeraltLine1');
	}

	timer function DetectLife( time : float, optional id : int)
	{
		var actors    														: array<CGameplayEntity>;
		var i																: int;
		var actor															: CActor;
		var movementAdjustorVampiress										: CMovementAdjustor; 
		var ticketVampiress 												: SMovementAdjustmentRequestTicket; 
		var targetDistance													: float;

		targetDistance = VecDistanceSquared2D( ACS_Orianna_Vampire_Base().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		if ( targetDistance <= 7 * 7 )
		{
			if (FactsQuerySum("ACS_Orianna_Singing_Range") > 0)
			{
				RemoveOriannaLinesAll();

				FactsRemove("ACS_Orianna_Singing_Range");
			}

			thePlayer.PlayLine( 1174617, true);

			AddTimer('OriannaLine7', 1, false);

			RemoveTimer('OriannaIdleAction');



			movementAdjustorVampiress = ACS_Orianna_Vampire_Base().GetMovingAgentComponent().GetMovementAdjustor();

			ticketVampiress = movementAdjustorVampiress.GetRequest( 'ACS_Orianna_Rotate');
			movementAdjustorVampiress.CancelByName( 'ACS_Orianna_Rotate' );
			movementAdjustorVampiress.CancelAll();

			ticketVampiress = movementAdjustorVampiress.CreateNewRequest( 'ACS_Orianna_Rotate' );
			movementAdjustorVampiress.AdjustmentDuration( ticketVampiress, 0.125f );
			movementAdjustorVampiress.MaxRotationAdjustmentSpeed( ticketVampiress, 500000 );

			movementAdjustorVampiress.RotateTowards( ticketVampiress, thePlayer );

			ACS_Orianna_Vampire_Base().PlayEffect('shadowdash');

			GetACSWatcher().ACSOriannaBasePlayAnim('bruxa_jump_up_start', 0.25, 0.25f);

			ACS_OriannaVampireSpawnEffect();

			AddTimer('OriannaTurnOffVisibility', 0.75, false);

			AddTimer('SpawnOriannaVampDelay', 3, false);

			RemoveTimer('DetectLife');
		}
		else if ( targetDistance > 7 * 7 && targetDistance <= 20 * 20 )
		{
			if ( FactsQuerySum("ACS_Orianna_Singing_Range") <= 0 )
			{
				ACS_Orianna_Vampire_Base().PlayLine( 1174593, true);

				AddTimer('OriannaLine2', 10, false);

				FactsAdd("ACS_Orianna_Singing_Range", 1, -1);
			}
		}
		else if ( targetDistance > 20 * 20 )
		{
			if (FactsQuerySum("ACS_Orianna_Singing_Range") > 0)
			{
				RemoveOriannaLinesAll();

				FactsRemove("ACS_Orianna_Singing_Range");
			}
		}
	}

	timer function OriannaTurnOffVisibility( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().SetVisibility(false);

		ACS_Orianna_Vampire_Base().EnableCharacterCollisions(false);

		ACS_Orianna_Vampire_Base().EnableCollisions(false);
	}

	timer function SpawnOriannaVampDelay( time : float, optional id : int)
	{
		ACS_Orianna_Vampire_Base().DestroyAfter(3);

		ACS_Orianna_Vampire_Base().PlayLine( 1164688, true);

		this.PushState('SpawnOriannaVamp');

		this.DestroyAfter(3);
	}
}

state SpawnOriannaBase in ACSOriannaDisappearController 
{
	event OnEnterState(prevStateName : name)
	{
		Orianna_Base_Spawn_Entry();
	}
	
	entry function Orianna_Base_Spawn_Entry()
	{	
		Orianna_Base_Spawn_Latent();
	}

	latent function Orianna_Base_Spawn_Latent()
	{
		var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
		var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
		var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
		var l_aiTree														: CAIMoveToAction;			

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\orianna.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = 1;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Friendly);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'acs_orianna_vampire_base' );

		parent.CreateAttachment(ent);
	}
}

state SpawnOriannaVamp in ACSOriannaDisappearController 
{
	event OnEnterState(prevStateName : name)
	{
		Orianna_Vampire_Spawn_Entry();
	}
	
	entry function Orianna_Vampire_Spawn_Entry()
	{	
		Orianna_Vampire_Spawn_Latent();
	}

	latent function OriannaVampireDespawnEffect()
	{
		var ent : CEntity;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

		, true ), ACS_Orianna_Vampire().GetWorldPosition(), ACS_Orianna_Vampire().GetWorldRotation() );

		ent.PlayEffectSingle('swarm_attack');

		ent.DestroyAfter(2);
	}

	latent function Orianna_Vampire_Spawn_Latent()
	{
		var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
		var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
		var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
		var movementAdjustorVampiress										: CMovementAdjustor; 
		var ticketVampiress 												: SMovementAdjustmentRequestTicket; 

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\orianna_higher_vampire.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'acs_orianna_vampire' );

		((CActor)ent).GetInventory().AddAnItem( 'acs_bruxa_fang' , 1 );

		OriannaVampireDespawnEffect();

		ent.PlayEffectSingle( 'shadowdash' );
		ent.StopEffect( 'shadowdash' );

		animcomp.PlaySlotAnimationAsync ( 'bruxa_jump_up_stop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f) );

		movementAdjustorVampiress = ((CActor)ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketVampiress = movementAdjustorVampiress.GetRequest( 'ACS_Orianna_Rotate');
		movementAdjustorVampiress.CancelByName( 'ACS_Orianna_Rotate' );
		movementAdjustorVampiress.CancelAll();

		ticketVampiress = movementAdjustorVampiress.CreateNewRequest( 'ACS_Orianna_Rotate' );
		movementAdjustorVampiress.AdjustmentDuration( ticketVampiress, 0.125f );
		movementAdjustorVampiress.MaxRotationAdjustmentSpeed( ticketVampiress, 500000 );

		movementAdjustorVampiress.RotateTowards( ticketVampiress, thePlayer );
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Bat_Projectile_Manager()
{
	if (ACS_can_shoot_bat_projectile())
	{
		ACS_refresh_bat_projectile_cooldown();

		ACS_Bat_Projectile_Start();
	}	
}

function ACS_Bat_Projectile_Start()
{
	var vACS_Bat_Projectile 		: cACS_Bat_Projectile;
	var vW3ACSWatcher				: W3ACSWatcher;

	vACS_Bat_Projectile = new cACS_Bat_Projectile in vW3ACSWatcher;

	vACS_Bat_Projectile.ACS_Bat_Projectile_Start_Engage();
}

statemachine class cACS_Bat_Projectile
{
	function ACS_Bat_Projectile_Start_Engage()
	{
		this.PushState('ACS_Bat_Projectile_Start_Engage');
	}
}

state ACS_Bat_Projectile_Start_Engage in cACS_Bat_Projectile
{
	private var initpos											: Vector;
	private var rotation										: EulerAngles;
	private var bat_projectile 									: W3BatSwarmAttack;
	private var effect_entity, main_effect  					: CEntity;
	private var i         										: int;
	private var actor       									: CActor;
	private var actors    										: array<CActor>;
	private var targetPosition									: Vector;
	private var npc												: CNewNPC;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Bat_Projectile_Start_Entry();
	}
	
	entry function ACS_Bat_Projectile_Start_Entry()
	{
		ACS_Bat_Projectile_Start_Latent();
	}
	
	latent function ACS_Bat_Projectile_Start_Latent()
	{
		initpos = ACS_Blade_Of_The_Unseen().GetWorldPosition();
				
		initpos.Z += 1.5;
				
		rotation = ACS_Blade_Of_The_Unseen().GetWorldRotation();
				
		targetPosition = GetWitcherPlayer().PredictWorldPosition( 0.7 );
		
		bat_projectile = (W3BatSwarmAttack)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\bat_swarm_attack_2.w2ent", true ), initpos, rotation );
		bat_projectile.Init(ACS_Blade_Of_The_Unseen());
		bat_projectile.PlayEffectSingle( 'venom' );
		bat_projectile.ShootProjectileAtPosition( 0, 10, targetPosition, 500 );
		bat_projectile.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Fire_Bear_Flames_Manager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance, fireballChance, firelineChance, fireballDistance, firelineDistance, flameOnChance					: float;

	if (!ACSFireBear() || !ACSFireBear().IsAlive())
	{
		return;
	}

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSFireBear()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSFireBear().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( ACSFireBear().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (ACSFireBear() 
	&& ACSFireBear().IsAlive()
	&& !animatedComponentA.HasFrozenPose())
	{
		if (ACS_bear_can_flame_on()
		&& GetACSWatcher().ACS_Fire_Bear_FireLine_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Fireball_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Meteor_Process == false
		)
		{
			if (ACS_FireBearBuffCheck()
			&& !ACSFireBear().IsEffectActive('flames', false)
			)
			{
				ACS_refresh_bear_flame_on_cooldown();

				GetACSWatcher().SetFireBearFlameOnProcess(true);

				if (ACSFireBear().GetStat(BCS_Essence) <= ACSFireBear().GetStatMax(BCS_Essence)/2)
				{
					flameOnChance = 0.95;
				}
				else
				{
					flameOnChance = 0.5;
				}

				if( RandF() < flameOnChance )
				{
					ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_FlameOn_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_Fire_FlameOn_Rotate' );

					ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_FlameOn_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

					movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

					animatedComponentA.PlaySlotAnimationAsync ( 'bear_special_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					ACSFireBear().RemoveBuff(EET_FireAura, true, 'acs_fire_bear_fire_aura');

					ACSFireBear().AddEffectDefault( EET_FireAura, ACSFireBear(), 'acs_fire_bear_fire_aura' );

					ACSFireBear().PlayEffectSingle('flames');

					GetACSWatcher().RemoveTimer('ACSFireBearFlameOnDelay');
					GetACSWatcher().AddTimer('ACSFireBearFlameOnDelay', 1.5, false);
				}
				else
				{
					GetACSWatcher().SetFireBearFlameOnProcess(false);
				}
			}
		}

		if (ACS_bear_can_throw_fireball()
		&& GetACSWatcher().ACS_Fire_Bear_FlameOn_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_FireLine_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Meteor_Process == false
		)
		{
			ACS_refresh_bear_fireball_cooldown();

			GetACSWatcher().SetFireBearFireballProcess(true);

			if (ACSFireBear().GetStat(BCS_Essence) <= ACSFireBear().GetStatMax(BCS_Essence)/2)
			{
				fireballChance = 0.25;

				fireballDistance = 5;

				if (ACSFireBear().IsEffectActive('flames', false))
				{
					fireballChance += 0.25;

					fireballDistance -= 2;
				}
			}
			else
			{
				fireballChance = 0.125;

				fireballDistance = 7;

				if (ACSFireBear().IsEffectActive('flames', false))
				{
					fireballChance += 0.125;

					fireballDistance -= 2;
				}
			}

			if( RandF() < fireballChance )
			{
				if ( ACS_FireBearBuffCheck()
				//&& ACSFireBear().IsInCombat()
				)
				{
					if ( targetDistance > fireballDistance * fireballDistance && targetDistance < 35 * 35 )
					{
						ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Fireball_Rotate');
						movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Fireball_Rotate' );

						ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Fireball_Rotate' );
						movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
						movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

						movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

						//animatedComponentA.PlaySlotAnimationAsync ( 'bear_attack_bite', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

						//Fireball();

						if( RandF() < 0.5 )
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'bear_attack_swing_left_move', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

							GetACSWatcher().RemoveTimer('ACSFireBearFireballLeftDelay');
							GetACSWatcher().AddTimer('ACSFireBearFireballLeftDelay', 0.75, false);
						}
						else
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'bear_attack_swing_right_move', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

							GetACSWatcher().RemoveTimer('ACSFireBearFireballRightDelay');
							GetACSWatcher().AddTimer('ACSFireBearFireballRightDelay', 0.75, false);
						}
					}
					else if (targetDistance > 35 * 35)
					{
						GetACSWatcher().SetFireBearFireballProcess(false);

						ACS_dropbearmeteorstart();
					}
					else
					{
						GetACSWatcher().SetFireBearFireballProcess(false);
					}
				}
			}
			else
			{
				GetACSWatcher().SetFireBearFireballProcess(false);
			}
		}

		if (ACS_bear_can_throw_fireline()
		&& GetACSWatcher().ACS_Fire_Bear_FlameOn_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Fireball_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Meteor_Process == false
		)
		{
			ACS_refresh_bear_fireline_cooldown();

			GetACSWatcher().SetFireBearFireLineProcess(true);

			if (ACSFireBear().GetStat(BCS_Essence) <= ACSFireBear().GetStatMax(BCS_Essence)/2)
			{
				firelineChance = 0.5;

				firelineDistance = 5;

				if (ACSFireBear().IsEffectActive('flames', false))
				{
					fireballChance += 0.25;

					firelineDistance -= 2;
				}
			}
			else
			{
				firelineChance = 0.25;

				firelineDistance = 7;

				if (ACSFireBear().IsEffectActive('flames', false))
				{
					firelineChance += 0.25;

					firelineDistance -= 2;
				}
			}

			if( RandF() < firelineChance )
			{
				if (ACS_FireBearBuffCheck()
				//&& ACSFireBear().IsInCombat()
				)
				{
					if ( targetDistance > firelineDistance * firelineDistance && targetDistance < 25 * 25 )
					{
						ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Bear_Fireball_Rotate');
						movementAdjustorNPC.CancelByName( 'ACS_Fire_Bear_Fireball_Rotate' );

						ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Bear_Fireball_Rotate' );
						movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.75 );
						movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

						movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

						animatedComponentA.PlaySlotAnimationAsync ( 'bear_taunt02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

						GetACSWatcher().RemoveTimer('ACSFireBearFireLineDelay');
						GetACSWatcher().AddTimer('ACSFireBearFireLineDelay', 2, false);
					}
					else if ( targetDistance > 25 * 25 )
					{
						GetACSWatcher().SetFireBearFireLineProcess(false);

						ACS_dropbearmeteorstart();
					}
					else
					{
						GetACSWatcher().SetFireBearFireLineProcess(false);
					}
				}
			}
			else
			{
				GetACSWatcher().SetFireBearFireLineProcess(false);
			}
		}
	}	
}


statemachine class cACS_Fire_Bear_Projectiles
{
	function ACS_Fire_Bear_FireballLeft_Start_Engage()
	{
		this.PushState('ACS_Fire_Bear_FireballLeft_Start_Engage');
	}

	function ACS_Fire_Bear_FireballRight_Start_Engage()
	{
		this.PushState('ACS_Fire_Bear_FireballRight_Start_Engage');
	}

	function ACS_Fire_Bear_FireLines_Start_Engage()
	{
		this.PushState('ACS_Fire_Bear_FireLines_Start_Engage');
	}
}

state ACS_Fire_Bear_FireballLeft_Start_Engage in cACS_Fire_Bear_Projectiles
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Fire_Bear_FireballLeft_Start_Entry();
	}
	
	entry function Fire_Bear_FireballLeft_Start_Entry()
	{
		FireballLeft();

		GetACSWatcher().SetFireBearFireballProcess(false);
	}

	latent function FireballLeft()
	{
		var collisionGroups 			: array<name>;
		var meteorEntityTemplate 		: CEntityTemplate;
		var userPosition 				: Vector;
		var meteorPosition 				: Vector;
		var userRotation 				: EulerAngles;
		var meteorEntity 				: W3FireballProjectile;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		collisionGroups.Clear();
		collisionGroups.PushBack('Terrain');
		collisionGroups.PushBack('Static');

		meteorEntityTemplate = (CEntityTemplate)LoadResourceAsync(

		"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.35f);

		//userPosition.Z += 1.5;

		userRotation = EulerAngles(0,0,0);

		meteorPosition = ACSFireBear().GetBoneWorldPosition('l_frontpaw');

		meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
		meteorEntity.Init(ACSFireBear());
		meteorEntity.PlayEffectSingle('fire_fx');
		//meteorEntity.PlayEffectSingle('explosion');
		//meteorEntity.decreasePlayerDmgBy = 0.75;
		meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, userPosition, 500, collisionGroups );
	}
}

state ACS_Fire_Bear_FireballRight_Start_Engage in cACS_Fire_Bear_Projectiles
{
	private var animatedComponentA												: CAnimatedComponent;
	private var movementAdjustorNPC												: CMovementAdjustor; 
	private var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	private var targetDistance													: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Fire_Bear_FireballRight_Start_Entry();
	}
	
	entry function Fire_Bear_FireballRight_Start_Entry()
	{
		FireballRight();

		GetACSWatcher().SetFireBearFireballProcess(false);
	}

	latent function FireballRight()
	{
		var collisionGroups 			: array<name>;
		var meteorEntityTemplate 		: CEntityTemplate;
		var userPosition 				: Vector;
		var meteorPosition 				: Vector;
		var userRotation 				: EulerAngles;
		var meteorEntity 				: W3FireballProjectile;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		collisionGroups.Clear();
		collisionGroups.PushBack('Terrain');
		collisionGroups.PushBack('Static');

		meteorEntityTemplate = (CEntityTemplate)LoadResourceAsync(

		"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.35f);
		//userPosition.Z += 1.5;

		userRotation = EulerAngles(0,0,0);

		meteorPosition = ACSFireBear().GetBoneWorldPosition('r_frontpaw');

		meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
		meteorEntity.Init(ACSFireBear());
		meteorEntity.PlayEffectSingle('fire_fx');
		//meteorEntity.PlayEffectSingle('explosion');
		//meteorEntity.decreasePlayerDmgBy = 0.75;
		meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, userPosition, 500, collisionGroups );
	}
}

state ACS_Fire_Bear_FireLines_Start_Engage in cACS_Fire_Bear_Projectiles
{
	private var animatedComponentA												: CAnimatedComponent;
	private var movementAdjustorNPC												: CMovementAdjustor; 
	private var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	private var targetDistance													: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Fire_Bear_FireLines_Start_Entry();
	}
	
	entry function Fire_Bear_FireLines_Start_Entry()
	{
		FireLinesLeft();

		FireLinesRight();

		GetACSWatcher().SetFireBearFireLineProcess(false);
	}

	latent function FireLinesLeft()
	{
		var collisionGroups 			: array<name>;
		var meteorEntityTemplate 		: CEntityTemplate;
		var userPosition 				: Vector;
		var meteorPosition 				: Vector;
		var userRotation 				: EulerAngles;
		var meteorEntity 				: W3ACSFireLine;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		meteorEntityTemplate = (CEntityTemplate)LoadResourceAsync(

		//"dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent"

		"dlc\dlc_acs\data\entities\projectiles\elemental_bear_fire_line.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.35f);

		//userPosition.Z += 1.5;

		userRotation = GetWitcherPlayer().GetWorldRotation();

		meteorPosition = ACSFireBear().GetBoneWorldPosition('l_frontpaw') + (ACSFireBear().GetWorldForward() * 1.5) + (ACSFireBear().GetWorldRight() * -1.25);

		meteorPosition = ACSPlayerFixZAxis(meteorPosition);

		meteorEntity = (W3ACSFireLine)theGame.CreateEntity(meteorEntityTemplate, ACSPlayerFixZAxis(meteorPosition), userRotation);
		meteorEntity.Init(ACSFireBear());
		meteorEntity.PlayEffectSingle('fire_line');
		//meteorEntity.PlayEffectSingle('explosion');
		meteorEntity.ShootProjectileAtPosition( 0, 10, userPosition, 500 );
	}

	latent function FireLinesRight()
	{
		var collisionGroups 			: array<name>;
		var meteorEntityTemplate 		: CEntityTemplate;
		var userPosition 				: Vector;
		var meteorPosition 				: Vector;
		var userRotation 				: EulerAngles;
		var meteorEntity 				: W3ACSFireLine;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		meteorEntityTemplate = (CEntityTemplate)LoadResourceAsync(

		//"dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent"

		"dlc\dlc_acs\data\entities\projectiles\elemental_bear_fire_line.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.35f);
		//userPosition.Z += 1.5;

		userRotation = EulerAngles(0,0,0);

		meteorPosition = ACSFireBear().GetBoneWorldPosition('r_frontpaw') + (ACSFireBear().GetWorldForward() * 1.5) + (ACSFireBear().GetWorldRight() * 1.25);

		meteorPosition = ACSPlayerFixZAxis(meteorPosition);

		meteorEntity = (W3ACSFireLine)theGame.CreateEntity(meteorEntityTemplate, ACSPlayerFixZAxis(meteorPosition), userRotation);
		meteorEntity.Init(ACSFireBear());
		meteorEntity.PlayEffectSingle('fire_line');
		//meteorEntity.PlayEffectSingle('explosion');
		meteorEntity.ShootProjectileAtPosition( 0, 10, userPosition, 500 );
	}
}

function ACS_FireBearDespawnEffect()
{
	var collisionGroups 															: array<name>;
	var meteorEntityTemplate, meteorEntity2Template 								: CEntityTemplate;
	var userPosition 																: Vector;
	var meteorPosition 																: Vector;
	var userRotation 																: EulerAngles;
	var meteorEntity 																: W3FireballProjectile;
	var meteorEntity2 																: W3BearDespawnMeteorProjectile;

	if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
	{
		theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
	}
	
	ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"

	//"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );

	meteorEntity2Template = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_despawn_meteor.w2ent"
	
	, true );

	userPosition = ACSFireBear().GetWorldPosition();

	userPosition.Z += 50;

	userRotation = ACSFireBear().GetWorldRotation();

	meteorPosition = ACSFireBear().GetWorldPosition();

	meteorPosition.Z += 3;

	meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(ACSFireBear());
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 0.25, userPosition, 500, collisionGroups );

	meteorEntity.DestroyAfter(10);

	meteorEntity2 = (W3BearDespawnMeteorProjectile)theGame.CreateEntity(meteorEntity2Template, meteorPosition, userRotation);
	meteorEntity2.Init(ACSFireBear());
	meteorEntity2.PlayEffectSingle('explosion_cutscene');
	meteorEntity2.PlayEffectSingle('explosion');
	meteorEntity2.PlayEffectSingle('explosion_cutscene');
	meteorEntity2.PlayEffectSingle('explosion');
	meteorEntity2.PlayEffectSingle('explosion_cutscene');
	meteorEntity2.PlayEffectSingle('explosion');
	meteorEntity2.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 0.25, userPosition, 500, collisionGroups );

	meteorEntity2.DestroyAfter(6);
}

function ACS_FireBearSpawnEffect()
{
	var collisionGroups 															: array<name>;
	var meteorEntityTemplate, meteorEntity2Template 								: CEntityTemplate;
	var userPosition 																: Vector;
	var meteorPosition 																: Vector;
	var userRotation 																: EulerAngles;
	var meteorEntity 																: W3FireballProjectile;
	var meteorEntity2 																: W3BearDespawnMeteorProjectile;

	if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
	{
		theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
	}
	
	ACSFireBearAltarEntity().SoundEvent("monster_golem_dao_cmb_swoosh_light");

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"

	//"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );

	userPosition = ACSFireBearAltarEntity().GetWorldPosition();

	userPosition.Z += 50;

	userRotation = ACSFireBearAltarEntity().GetWorldRotation();

	meteorPosition = ACSFireBearAltarEntity().GetWorldPosition();

	meteorPosition.Z += 3;

	meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(ACSFireBearAltarEntity());
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed , userPosition, 500, collisionGroups );

	meteorEntity.DestroyAfter(5);
}

function ACS_FireBearMeteorAscend()
{
	var collisionGroups 															: array<name>;
	var meteorEntityTemplate, meteorEntity2Template 								: CEntityTemplate;
	var userPosition 																: Vector;
	var meteorPosition 																: Vector;
	var userRotation 																: EulerAngles;
	var meteorEntity 																: W3FireballProjectile;
	var meteorEntity2 																: W3BearDespawnMeteorProjectile;

	ACSFireBear().EnableCharacterCollisions(false); 

	ACSFireBear().EnableCollisions(false);

	if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
	{
		theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
	}
	
	ACSFireBear().SoundEvent("monster_golem_dao_cmb_swoosh_light");

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	/*
	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"

	//"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );
	*/

	meteorEntity2Template = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_despawn_meteor.w2ent"
	
	, true );

	userPosition = GetWitcherPlayer().GetWorldPosition() + theCamera.GetCameraDirection() * 50;

	userPosition.Z += 200;

	userRotation = ACSFireBear().GetWorldRotation();

	meteorPosition = ACSFireBear().GetWorldPosition();

	meteorPosition.Z += 2;
	
	/*
	meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(ACSFireBear());
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('fire_fx');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.CreateAttachment(meteorEntity2);

	meteorEntity.DestroyAfter(6.95);
	*/

	meteorEntity2 = (W3BearDespawnMeteorProjectile)theGame.CreateEntity(meteorEntity2Template, meteorPosition, userRotation);
	meteorEntity2.Init(ACSFireBear());
	meteorEntity2.PlayEffectSingle('explosion_cutscene');
	meteorEntity2.PlayEffectSingle('explosion');
	meteorEntity2.PlayEffectSingle('explosion_cutscene');
	meteorEntity2.PlayEffectSingle('explosion');
	meteorEntity2.PlayEffectSingle('explosion_cutscene');
	meteorEntity2.PlayEffectSingle('explosion');
	meteorEntity2.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 0.25, userPosition, 500, collisionGroups );

	meteorEntity2.DestroyAfter(8.95);

	GetACSWatcher().AddTimer('DropBearMeteor', 9, false);
}

function ACSFireBear() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Fire_Bear' );
	return entity;
}

function ACS_FireBearBuffCheck() : bool
{
	if ( ACSFireBear().HasBuff(EET_HeavyKnockdown) 
	|| ACSFireBear().HasBuff( EET_Knockdown ) 
	|| ACSFireBear().HasBuff( EET_Ragdoll ) 
	|| ACSFireBear().HasBuff( EET_Stagger )
	|| ACSFireBear().HasBuff( EET_LongStagger )
	|| ACSFireBear().HasBuff( EET_Pull )
	|| ACSFireBear().HasBuff( EET_Immobilized )
	|| ACSFireBear().HasBuff( EET_Hypnotized )
	|| ACSFireBear().HasBuff( EET_WitchHypnotized )
	|| ACSFireBear().HasBuff( EET_Blindness )
	|| ACSFireBear().HasBuff( EET_WraithBlindness )
	|| ACSFireBear().HasBuff( EET_Frozen )
	|| ACSFireBear().HasBuff( EET_Paralyzed )
	|| ACSFireBear().HasBuff( EET_Confusion )
	|| ACSFireBear().HasBuff( EET_Tangled )
	|| ACSFireBear().HasBuff( EET_Tornado )
	|| ACSFireBear().HasBuff( EET_Swarm )
	)
	{
		return false;
	}
	else
	{
		return true;
	}
}

function ACS_dropbearbossfight()
{	
	var ent        													   : CEntity;
	var rot                       						 				: EulerAngles;
    var pos																: Vector;

	GetACSFireSkyEnt().Destroy();

	rot = ACSFireBearAltarEntity().GetWorldRotation();

    pos = ACSFireBearAltarEntity().GetWorldPosition();

	pos.Z -= 100;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\fire_conjunction.w2ent"

		, true ), pos, rot );

	ent.AddTag('ACS_Fire_Sky_Ent');

	ent.PlayEffectSingle('conjunction');

	GetACSWatcher().AddTimer('DropBearSummon', 8.5, false);
}

function GetACSFireSkyEnt() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Fire_Sky_Ent' );
	return entity;
}

function ACS_dropbearsummon()
{
	var collisionGroups 						: array<name>;
	var firesky_ent, meteorEntityTemplate 		: CEntityTemplate;
	var userPosition 							: Vector;
	var meteorPosition 							: Vector;
	var userRotation 							: EulerAngles;
	var meteorEntity 							: W3BearSummonMeteorProjectile;

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );

	userPosition = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 75;
	//userPosition = GetWitcherPlayer().PredictWorldPosition(0.35f) + theCamera.GetCameraDirection() * 5;

	userPosition = ACSPlayerFixZAxis(userPosition);

	userRotation = EulerAngles(0,0,0);

	//meteorPosition = userPosition;
	meteorPosition = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 75;
	meteorPosition.Z += 100;

	meteorEntity = (W3BearSummonMeteorProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(NULL);
	meteorEntity.PlayEffectSingle('explosion_cutscene');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion_cutscene');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion_cutscene');
	meteorEntity.PlayEffectSingle('explosion');
	//meteorEntity.decreasePlayerDmgBy = 0.25;
	meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, ACSPlayerFixZAxis(userPosition), 500, collisionGroups );
}

function ACS_dropbearmeteorstart()
{
	var animatedComponentA						: CAnimatedComponent;
	var movementAdjustorNPC						: CMovementAdjustor;
	var ticketNPC 								: SMovementAdjustmentRequestTicket; 

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSFireBear()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSFireBear().GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(
		GetACSWatcher().ACS_Fire_Bear_FlameOn_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_FireLine_Process == false
		&& GetACSWatcher().ACS_Fire_Bear_Fireball_Process == false
	)
	{
		GetACSWatcher().SetFireBearMeteorProcess(true);

		GetACSWatcher().RemoveTimer('DropBearMeteorStart');

		GetACSWatcher().RemoveTimer('ACSFireBearFlameOnDelay');

		GetACSWatcher().RemoveTimer('ACSFireBearFireballLeftDelay');

		GetACSWatcher().RemoveTimer('ACSFireBearFireballRightDelay');

		GetACSWatcher().RemoveTimer('ACSFireBearFireLineDelay');

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Meteor_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Fire_Meteor_Rotate' );

		movementAdjustorNPC.CancelAll();

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Meteor_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.01 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

		movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

		animatedComponentA.PlaySlotAnimationAsync ( 'bear_counter_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

		GetACSWatcher().AddTimer('DropBearMeteorAscend', 1, false);
	}
}

function ACS_dropbearmeteor()
{
	var collisionGroups 						: array<name>;
	var firesky_ent, meteorEntityTemplate 		: CEntityTemplate;
	var userPosition 							: Vector;
	var meteorPosition 							: Vector;
	var userRotation 							: EulerAngles;
	var meteorEntity 							: W3BearSummonMeteorProjectile;

	collisionGroups.Clear();
	collisionGroups.PushBack('Terrain');
	collisionGroups.PushBack('Static');

	meteorEntityTemplate = (CEntityTemplate)LoadResource(

	"dlc\dlc_acs\data\entities\projectiles\bear_summon_meteor.w2ent"
	
	, true );

	userPosition = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 75;
	//userPosition = GetWitcherPlayer().PredictWorldPosition(0.35f) + theCamera.GetCameraDirection() * 10;

	userPosition = ACSPlayerFixZAxis(userPosition);

	userRotation = EulerAngles(0,0,0);

	//meteorPosition = userPosition;
	meteorPosition = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 75;
	meteorPosition.Z += 100;

	meteorEntity = (W3BearSummonMeteorProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
	meteorEntity.Init(ACSFireBear());
	meteorEntity.PlayEffectSingle('explosion_cutscene');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion_cutscene');
	meteorEntity.PlayEffectSingle('explosion');
	meteorEntity.PlayEffectSingle('explosion_cutscene');
	meteorEntity.PlayEffectSingle('explosion');
	//meteorEntity.decreasePlayerDmgBy = 0.25;
	meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, ACSPlayerFixZAxis(userPosition), 500, collisionGroups );
}

function ACSFireBearAltarEntity() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Fire_Bear_Altar_Entity' );
	return entity;
}

function ACSFireBearAltar() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Fire_Bear_Altar' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_KnightmareEternumManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance, fireballChance, firelineChance, fireballDistance, firelineDistance, flameOnChance					: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSKnightmareEternum()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = GetACSKnightmareEternum().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( GetACSKnightmareEternum().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (!GetACSKnightmareEternum() || !GetACSKnightmareEternum().IsAlive())
	{
		return;
	}

	if (GetACSKnightmareEternum()
	&& GetACSKnightmareEternum().IsAlive()
	&& ACS_KnightmareEternumBuffCheck())
	{
		if (ACS_knightmare_shout()
		//&& GetACSWatcher().ACS_Knightmare_Igni_Process == false
		)
		{
			ACS_refresh_knightmare_shout_cooldown();

			//GetACSWatcher().SetKnightmareShoutProcess(true);

			if ( targetDistance <= 5 * 5 )
			{
				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Knightmare_Eternum_Shout_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Knightmare_Eternum_Shout_Rotate' );

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Knightmare_Eternum_Shout_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetACSKnightmareEternum().GetTarget() );

				GetACSKnightmareEternum().PlayEffectSingle('olgierd_energy_blast');

				GetACSKnightmareEternum().PlayEffectSingle('special_attack_fx');

				GetACSKnightmareEternum().SetImmortalityMode( AIM_None, AIC_Combat ); 

				GetACSKnightmareEternum().SetCanPlayHitAnim(true); 

				GetACSKnightmareEternum().SetIsCurrentlyDodging(false);

				GetACSKnightmareEternum().SetParryEnabled(false);

				GetACSKnightmareEternum().SetGuarded(false);

				if( GetACSWatcher().ACS_Knightmare_Igni_Process == false )
				{
					GetACSWatcher().SetKnightmareIgniProcess(true);

					animatedComponentA.PlaySlotAnimationAsync ( 'ethereal_attack_shout', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					GetACSWatcher().AddTimer('KnightmareEternumShout', 1.75, false);

					//GetACSWatcher().AddTimer('ResetKnightmareEternumShoutProcess', 1.5, false);
				}
				else
				{
					GetACSWatcher().SetKnightmareIgniProcess(false);

					animatedComponentA.PlaySlotAnimationAsync ( 'ethereal_attack_with_shout_001', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					GetACSWatcher().AddTimer('KnightmareEternumIgni', 1, false);

					//GetACSWatcher().AddTimer('ResetKnightmareEternumIgniProcess',2, false);
				}
			}
			else
			{
				//GetACSWatcher().SetKnightmareShoutProcess(false);
			}
		}

		/*
		if (ACS_knightmare_igni()
		&& GetACSWatcher().ACS_Knightmare_Shout_Process == false
		)
		{
			ACS_refresh_knightmare_igni_cooldown();

			GetACSWatcher().SetKnightmareIgniProcess(true);

			if ( targetDistance <= 5 )
			{
				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Knightmare_Eternum_Igni_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Knightmare_Eternum_Igni_Rotate' );

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Knightmare_Eternum_Igni_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 50000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

				animatedComponentA.PlaySlotAnimationAsync ( 'ethereal_attack_with_shout_001', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				GetACSWatcher().AddTimer('KnightmareEternumIgni', 1, false);

				GetACSWatcher().AddTimer('ResetKnightmareEternumIgniProcess', 1.5, false);
			}
			else
			{
				GetACSWatcher().SetKnightmareIgniProcess(false);
			}
		}
		*/
	}
}

function ACS_KnightmareEternumShoutActual()
{
	var dmg																																								: W3DamageAction;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;
	var ent, ent_2																																								: CEntity;

	if (GetACSKnightmareEternum()
	&& GetACSKnightmareEternum().IsAlive())
	{
		//GetACSKnightmareEternum().PlayEffectSingle('shout');
		//GetACSKnightmareEternum().StopEffect('shout');

		GetACSKnightmareEternum().SetImmortalityMode( AIM_None, AIC_Combat ); 

		GetACSKnightmareEternum().SetCanPlayHitAnim(true); 

		GetACSKnightmareEternum().SetIsCurrentlyDodging(false);

		GetACSKnightmareEternum().SetParryEnabled(false);

		GetACSKnightmareEternum().SetGuarded(false);

		GetACSKnightmareEternum().StopEffect('olgierd_energy_blast');

		GetACSKnightmareEternum().StopEffect('special_attack_fx');

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\knightmare_scream_attack.w2ent"
		, true ), GetACSKnightmareEternum().GetWorldPosition(), GetACSKnightmareEternum().GetWorldRotation() );

		ent.CreateAttachment( GetACSKnightmareEternum(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');
		ent.PlayEffect('cone');

		ent.PlayEffect('fx_push');
		ent.PlayEffect('fx_push');
		ent.PlayEffect('fx_push');
		ent.PlayEffect('fx_push');
		ent.PlayEffect('fx_push');

		ent.DestroyAfter(0.75);


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\pc_aard_mq1060.w2ent"
		, true ), GetACSKnightmareEternum().GetWorldPosition(), GetACSKnightmareEternum().GetWorldRotation() );

		ent_2.CreateAttachment( GetACSKnightmareEternum(), , Vector( 0, 1, 1 ), EulerAngles(0,0,0) );

		ent_2.PlayEffect('cone');
		ent_2.PlayEffect('cone');
		ent_2.PlayEffect('cone');
		ent_2.PlayEffect('cone');
		ent_2.PlayEffect('cone');

		//ent_2.PlayEffectSingle('cone_ground');

		//ent_2.PlayEffectSingle('cone_ground');

		//ent_2.PlayEffectSingle('cone_ground');

		//ent_2.PlayEffectSingle('cone_ground');

		//ent_2.PlayEffectSingle('cone_ground');

		ent_2.DestroyAfter(5);


		actors.Clear();

		actors = GetACSKnightmareEternum().GetNPCsAndPlayersInCone(10, VecHeading(GetACSKnightmareEternum().GetHeadingVector()), 60, 50, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetACSKnightmareEternum(), actortarget, theGame, 'ACS_Knightmare_Eternum_Shout_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					maxTargetVitality = actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * 0.15; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					maxTargetEssence = actortarget.GetStat( BCS_Essence );
					
					damageMax = maxTargetEssence * 0.15; 
				} 

				dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}
	}
}

function ACS_KnightmareEternumIgniActual()
{
	var dmg																																								: W3DamageAction;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;
	var ent																																								: CEntity;

	if (GetACSKnightmareEternum()
	&& GetACSKnightmareEternum().IsAlive())
	{
		GetACSKnightmareEternum().SetImmortalityMode( AIM_None, AIC_Combat ); 

		GetACSKnightmareEternum().SetCanPlayHitAnim(true); 

		GetACSKnightmareEternum().SetIsCurrentlyDodging(false);

		GetACSKnightmareEternum().SetParryEnabled(false);

		GetACSKnightmareEternum().SetGuarded(false);

		GetACSKnightmareEternum().StopEffect('shout');

		GetACSKnightmareEternum().StopEffect('olgierd_energy_blast');

		GetACSKnightmareEternum().StopEffect('special_attack_fx');

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\fx\pc_igni_mq1060.w2ent"
		, true ), GetACSKnightmareEternum().GetWorldPosition(), GetACSKnightmareEternum().GetWorldRotation() );

		ent.CreateAttachment( GetACSKnightmareEternum(), , Vector( 0, 1, 1 ), EulerAngles(0,90,0) );

		ent.PlayEffect('cone');
		ent.PlayEffect('cone_1_red');
		ent.PlayEffect('cone_2_red');
		//ent_3.PlayEffect('cone_melt_1_red');
		ent.PlayEffect('cone_melt_2_red');
		ent.PlayEffect('cone_superpower_1_red');
		//ent_3.PlayEffect('cone_power_1_red');
		ent.PlayEffect('cone_power_2_red');

		ent.DestroyAfter(3);

		actors.Clear();

		actors = GetACSKnightmareEternum().GetNPCsAndPlayersInCone(10, VecHeading(GetACSKnightmareEternum().GetHeadingVector()), 90, 50, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetACSKnightmareEternum(), actortarget, theGame, 'ACS_Knightmare_Eternum_Igni_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					maxTargetVitality = actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * 0.15; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					maxTargetEssence = actortarget.GetStat( BCS_Essence );
					
					damageMax = maxTargetEssence * 0.15; 
				} 

				dmg.AddEffectInfo( EET_Burning, 3 );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}
	}
}

function ACS_KnightmareEternumBuffCheck() : bool
{
	if ( GetACSKnightmareEternum().HasBuff(EET_HeavyKnockdown) 
	|| GetACSKnightmareEternum().HasBuff( EET_Knockdown ) 
	|| GetACSKnightmareEternum().HasBuff( EET_Ragdoll ) 
	|| GetACSKnightmareEternum().HasBuff( EET_Stagger )
	|| GetACSKnightmareEternum().HasBuff( EET_LongStagger )
	|| GetACSKnightmareEternum().HasBuff( EET_Pull )
	|| GetACSKnightmareEternum().HasBuff( EET_Hypnotized )
	|| GetACSKnightmareEternum().HasBuff( EET_WitchHypnotized )
	|| GetACSKnightmareEternum().HasBuff( EET_Blindness )
	|| GetACSKnightmareEternum().HasBuff( EET_WraithBlindness )
	|| GetACSKnightmareEternum().HasBuff( EET_Frozen )
	|| GetACSKnightmareEternum().HasBuff( EET_Paralyzed )
	|| GetACSKnightmareEternum().HasBuff( EET_Confusion )
	|| GetACSKnightmareEternum().HasBuff( EET_Tangled )
	|| GetACSKnightmareEternum().HasBuff( EET_Tornado ) 
	|| GetACSKnightmareEternum().HasBuff( EET_Swarm ) 
	)
	{
		return false;
	}
	else
	{
		return true;
	}
}

function GetACSKnightmareEternum() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Knightmare_Eternum' );
	return entity;
}

function GetACSKnightmareSwordTrail() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_sword_trail' );
	return entity;
}

function GetACSKnightmareQuen() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_quen' );
	return entity;
}

function GetACSKnightmareQuenHit() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_quen_hit' );
	return entity;
}

function GetACSKnightmareChestBlade1() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_chest_blade_1' );
	return entity;
}

function GetACSKnightmareChestBlade2() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_chest_blade_2' );
	return entity;
}

function GetACSKnightmareChestBlade3() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_chest_blade_3' );
	return entity;
}

function GetACSKnightmareChestBlade4() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_knightmare_chest_blade_4' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Rat_Mage_Spawner
{
	function ACS_Rat_Mage_Rat_Spawner_Engage()
	{
		this.PushState('ACS_Rat_Mage_Rat_Spawner_Engage');
	}
}

state ACS_Rat_Mage_Rat_Spawner_Engage in cACS_Rat_Mage_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var adjustedRot														: EulerAngles;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;	

	event OnEnterState(prevStateName : name)
	{
		Spawn_Rat_Mage_Rats_Entry();
	}
	
	entry function Spawn_Rat_Mage_Rats_Entry()
	{	
		Spawn_Rat_Mage_Rats_Latent();
	}

	latent function Spawn_Rat_Mage_Rats_Latent()
	{
		if (GetACSRatMage()
		&& GetACSRatMage().IsAlive())
		{	
			GetACSRatMage().SoundEvent("magic_olgierd_ethereal_death");

			temp = (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\entities\mages\rat_mage_rats.w2ent"
				
			, true );

			playerPos = GetACSRatMage().GetWorldPosition();

			adjustedRot = GetACSRatMage().GetWorldRotation();

			//playerRot.Yaw += 180;
			
			count = RandRange(10,5);
				
			for( i = 0; i < count; i += 1 )
			{
				randRange = 2.5 + 2.5 * RandF();
				randAngle = 2 * Pi() * RandF();
				
				spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
				spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
				spawnPos.Z = playerPos.Z;

				ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

				animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent.GetComponentByClassName('CMeshComponent');
				h = 1;
				animcomp.SetScale(Vector(h,h,h,1));
				meshcomp.SetScale(Vector(h,h,h,1));	

				((CNewNPC)ent).SetLevel(GetACSRatMage().GetLevel()/4);

				((CNewNPC)ent).SetAttitude(GetACSRatMage(), AIA_Friendly);

				((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
				
				((CActor)ent).SetAnimationSpeedMultiplier(1);

				ent.PlayEffectSingle('demonic_possession');

				ent.AddTag( 'ACS_Rat_Mage_Rat' );
			}
		}
	}
}

function ACS_RatMageManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance, fireballChance, firelineChance, fireballDistance, firelineDistance, flameOnChance					: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSRatMage()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = GetACSRatMage().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( GetACSRatMage().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (!GetACSRatMage() || !GetACSRatMage().IsAlive())
	{
		return;
	}

	if (GetACSRatMage()
	&& GetACSRatMage().IsAlive()
	&& ACS_RatMageBuffCheck())
	{
		if (ACS_rat_mage_abilities()
		)
		{
			ACS_refresh_rat_mage_abilities_cooldown();

			if ( targetDistance >= 5 * 5 && targetDistance < 15 * 15 )
			{
				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Rat_Mage_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Rat_Mage_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Rat_Mage_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, thePlayer );

				if( !GetACSRatMage().HasTag('ACS_Summoned_Rats') )
				{
					GetACSRatMage().AddTag('ACS_Summoned_Rats');

					animatedComponentA.PlaySlotAnimationAsync ( 'man_mage_root_attack_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					GetACSWatcher().AddTimer('RatMageSummonRats', 1, false);
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'man_mage_fireball_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					GetACSWatcher().AddTimer('RatMageProjectile', 1, false);

					GetACSRatMage().RemoveTag('ACS_Summoned_Rats');
				}
			}
		}
	}
}

function ACS_RatMageSummonRatsActual()
{
	var vACS_Rat_Mage_Spawner: cACS_Rat_Mage_Spawner;
	vACS_Rat_Mage_Spawner = new cACS_Rat_Mage_Spawner in theGame;

	vACS_Rat_Mage_Spawner.ACS_Rat_Mage_Rat_Spawner_Engage();
}

function ACS_RatMageProjectileActual()
{
	var proj_1								: W3ACSRedPlagueProjectile;
	var initpos, newpos, targetPosition		: Vector;

	if ( !theSound.SoundIsBankLoaded("mq_nml_1060.bnk") )
	{
		theSound.SoundLoadBank( "mq_nml_1060.bnk", false );
	}

	initpos = GetACSRatMage().GetWorldPosition();	
	initpos.Z += 0.5;
			
	targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
	targetPosition.Z += 0.5;

	proj_1 = (W3ACSRedPlagueProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\red_plague_proj.w2ent"
		
		, true ), initpos );
					
	proj_1.Init(GetACSRatMage());

	proj_1.ShootProjectileAtPosition( 0, 5, targetPosition, 500 );
	proj_1.DestroyAfter(10);
}

function ACS_RatMageBuffCheck() : bool
{
	if ( GetACSRatMage().HasBuff(EET_HeavyKnockdown) 
	|| GetACSRatMage().HasBuff( EET_Knockdown ) 
	|| GetACSRatMage().HasBuff( EET_Ragdoll ) 
	|| GetACSRatMage().HasBuff( EET_Stagger )
	|| GetACSRatMage().HasBuff( EET_LongStagger )
	|| GetACSRatMage().HasBuff( EET_Pull )
	|| GetACSRatMage().HasBuff( EET_Hypnotized )
	|| GetACSRatMage().HasBuff( EET_WitchHypnotized )
	|| GetACSRatMage().HasBuff( EET_Blindness )
	|| GetACSRatMage().HasBuff( EET_WraithBlindness )
	|| GetACSRatMage().HasBuff( EET_Frozen )
	|| GetACSRatMage().HasBuff( EET_Paralyzed )
	|| GetACSRatMage().HasBuff( EET_Confusion )
	|| GetACSRatMage().HasBuff( EET_Tangled )
	|| GetACSRatMage().HasBuff( EET_Tornado ) 
	|| GetACSRatMage().HasBuff( EET_Swarm ) 
	)
	{
		return false;
	}
	else
	{
		return true;
	}
}

function ACS_spawnratmage()
{
	var temp, quen_temp, quen_hit_temp									: CEntityTemplate;
	var ent, quen_ent, quen_hit_ent										: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var playerRot, adjustedRot											: EulerAngles;	

	GetACSRatMage().Destroy();

	GetACSRatMageQuen().Destroy();

	GetACSRatMageQuenHit().Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\mages\rat_mage.w2ent"
		
	, true );

	quen_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_quen_mq1060.w2ent" , true );

	quen_hit_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_quen_hit_mq1060.w2ent" , true );

	playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	adjustedRot = EulerAngles(0,0,0);

	adjustedRot.Yaw = playerRot.Yaw;
	
	count = 1;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
		spawnPos.Z = playerPos.Z;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffectSingle('black_smoke');
		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('smoke');
		ent.PlayEffectSingle('demonic_possession');

		ent.AddTag( 'ACS_Rat_Mage' );






		quen_ent = (CEntity)theGame.CreateEntity( quen_temp, playerPos + Vector( 0, 0, -20 ) );

		quen_hit_ent = (CEntity)theGame.CreateEntity( quen_hit_temp, playerPos + Vector( 0, 0, -20 ) );

		quen_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_ent.AddTag( 'ACS_rat_mage_quen' );

		quen_hit_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_hit_ent.AddTag( 'ACS_rat_mage_quen_hit' );

		quen_ent.StopEffect('default_fx');

		quen_ent.StopEffect('shield');
	}
}

function GetACSRatMage() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Rat_Mage' );
	return entity;
}

function GetACSRatMageQuen() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_rat_mage_quen' );
	return entity;
}

function GetACSRatMageQuenHit() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_rat_mage_quen_hit' );
	return entity;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSCloakVampInCombatCheck()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Cloak_Vamp', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		targetDistance = VecDistanceSquared2D( actors[i].GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		if (
			actors[i].IsInCombat()
		)
		{
			if (!actors[i].HasTag('ACS_Cloak_Vamp_In_Combat'))
			{
				actors[i].AddTag('ACS_Cloak_Vamp_In_Combat');
			}
		}

		if (!actors[i].HasTag('ACS_Cloak_Vamp_In_Combat'))
		{
			((CActor)actors[i]).GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - actors[i].GetWorldPosition()));

			if (targetDistance <= 15 * 15)
			{
				((CActor)actors[i]).GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(1);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_SheWhoKnowsManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;

	if (!ACSSheWhoKnows() || !ACSSheWhoKnows().IsAlive())
	{
		return;
	}

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSSheWhoKnows()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSSheWhoKnows().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( ACSSheWhoKnows().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (ACSSheWhoKnows()
	&& ACSSheWhoKnows().IsAlive()
	&& ACSSheWhoKnows().IsInCombat())
	{
		ACSSheWhoKnows().DisableLookAt();

		if (ACS_she_who_knows_abilities()
		)
		{
			ACS_refresh_she_who_knows_abilities_cooldown();

			ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_She_Who_Knows_Abilities_Rotate');
			movementAdjustorNPC.CancelByName( 'ACS_She_Who_Knows_Abilities_Rotate' );

			ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_She_Who_Knows_Abilities_Rotate' );
			movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
			movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

			movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

			if ( targetDistance <= 5 * 5)
			{
				animatedComponentA.PlaySlotAnimationAsync ( 'water_dodge_to_submerge', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

				ACSSheWhoKnows().StopEffect('spawn_disappear');
				ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');
				ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');
				ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');
				ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');
				ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');

				GetACSWatcher().RemoveTimer('SheWhoKnowsHide');
				GetACSWatcher().AddTimer('SheWhoKnowsHide', 0.5, false);

				GetACSWatcher().RemoveTimer('SheWhoKnowsTeleport');
				GetACSWatcher().AddTimer('SheWhoKnowsTeleport', 1.25, false);
			}
			else if ( targetDistance > 5 * 5 && targetDistance <= 20 * 20 )
			{
				if( GetACSWatcher().ACS_She_Who_Knows_Throw_Projectile_Process == false )
				{
					GetACSWatcher().SetSheWhoKnowsProjectileProcess(true);

					if(!ACSSheWhoKnows().HasTag('ACS_SheWhoKnowsVolleyContinuous'))
					{
						movementAdjustorNPC.Continuous(ticketNPC);

						animatedComponentA.PlaySlotAnimationAsync ( 'witch_hypno_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingle');

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingleStop');

						GetACSWatcher().AddTimer('SheWhoKnowsProjectileSingle', 0.5, true);

						GetACSWatcher().AddTimer('SheWhoKnowsProjectileSingleStop', 4.5, false);

						ACSSheWhoKnows().AddTag('ACS_SheWhoKnowsVolleyContinuous');
					}
					else
					{
						ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnowsVolleyContinuous');

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley1');

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley2');

						GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileVolley3');

						if (!ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Volley')
						&& !ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Volley')
						)
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'water_attack_throw_mud_faster', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

							GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley2', 0.875, false,,,false);

							ACSSheWhoKnows().AddTag('ACS_SheWhoKnows_1st_Volley');
						}
						else if (ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Volley')
						&& !ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Volley'))
						{
							if (RandF() < 0.5)
							{
								animatedComponentA.PlaySlotAnimationAsync ( 'water_emerge_throw_mud_fast', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

								GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley2', 1, false,,,false);

								GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley3', 1.125, false,,,false);
							}
							else
							{
								animatedComponentA.PlaySlotAnimationAsync ( 'water_attack_throw_mud_faster', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

								GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley1', 0.875, false,,,false);

								GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley2', 1, false,,,false);
							}

							ACSSheWhoKnows().AddTag('ACS_SheWhoKnows_2nd_Volley');
						}
						else if (ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Volley')
						&& ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Volley')) 
						{
							animatedComponentA.PlaySlotAnimationAsync ( 'water_emerge_throw_mud_fast', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

							GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley1', 0.875, false,,,false);

							GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley2', 1, false,,,false);

							GetACSWatcher().AddTimer('SheWhoKnowsProjectileVolley3', 1.125, false,,,false);

							ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnows_1st_Volley');
							ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnows_2nd_Volley');
						}
					}	
				}
				else
				{
					GetACSWatcher().SetSheWhoKnowsProjectileProcess(false);

					animatedComponentA.PlaySlotAnimationAsync ( 'water_submerge', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));

					ACSSheWhoKnows().StopEffect('spawn_disappear');
					ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');
					ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');
					ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');
					ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');
					ACSSheWhoKnows().PlayEffectSingle('spawn_disappear');

					GetACSWatcher().RemoveTimer('SheWhoKnowsHide');
					GetACSWatcher().AddTimer('SheWhoKnowsHide', 1.125, false);

					GetACSWatcher().RemoveTimer('SheWhoKnowsTeleport');
					GetACSWatcher().AddTimer('SheWhoKnowsTeleport', 1.25, false);
				}
			}
		}
	}
}

function ACS_SheWhoKnowsTeleportStartActual()
{
	((CActor)ACSSheWhoKnows()).SetVisibility( false );

	GetACSWatcher().AddTimer('SheWhoKnowsTeleport', 1, false);
}

function ACS_SheWhoKnowsHideActual()
{
	ACSSheWhoKnows().SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
	
	ACSSheWhoKnows().SetCanPlayHitAnim(false); 
	
	ACSSheWhoKnows().EnableCharacterCollisions(false);
	
	ACSSheWhoKnows().AddBuffImmunity_AllNegative('ACS_She_Who_Knows_Dodge', true); 
	
	ACSSheWhoKnows().SetVisibility(false);
}

function ACS_SheWhoKnowsShowActual()
{
	ACS_SheWhoKnowsTeleportDamage(); 
	
	ACSSheWhoKnows().SetImmortalityMode( AIM_None, AIC_Combat ); 
	
	ACSSheWhoKnows().SetCanPlayHitAnim(true); 
	
	ACSSheWhoKnows().EnableCharacterCollisions(true); 
	
	ACSSheWhoKnows().RemoveBuffImmunity_AllNegative('ACS_She_Who_Knows_Dodge'); 
	
	ACSSheWhoKnows().SetVisibility(true);
}

function ACS_SheWhoKnowsTeleportActual()
{
	var playerRot, adjustedRot																								: EulerAngles;
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket;
	var dist																												: float;
	var spawnPos, newSpawnPos																								: Vector;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSSheWhoKnows()).GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustorNPC = ACSSheWhoKnows().GetMovingAgentComponent().GetMovementAdjustor();

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	adjustedRot = EulerAngles(0,0,0);

	adjustedRot.Yaw = playerRot.Yaw;

	spawnPos = ACSPlayerFixZAxis(GetWitcherPlayer().PredictWorldPosition(0.7f));

	if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
	{
		theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
		spawnPos = newSpawnPos;
	}

	ACSSheWhoKnows().TeleportWithRotation(ACSPlayerFixZAxis(spawnPos), adjustedRot);

	dist = ((((CMovingPhysicalAgentComponent)ACSSheWhoKnows().GetMovingAgentComponent()).GetCapsuleRadius())
	+ (((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) );

	ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_She_Who_Knows_Abilities_Rotate');
	movementAdjustorNPC.CancelByName( 'ACS_She_Who_Knows_Abilities_Rotate' );
	movementAdjustorNPC.CancelAll();

	ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_She_Who_Knows_Abilities_Rotate' );
	movementAdjustorNPC.AdjustmentDuration( ticketNPC, 1 );
	movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );
	movementAdjustorNPC.AdjustLocationVertically( ticketNPC, true );
	movementAdjustorNPC.ScaleAnimationLocationVertically( ticketNPC, true );

	movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

	movementAdjustorNPC.SlideTowards( ticketNPC, GetWitcherPlayer(), dist, dist ); 

	if (!ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Sneak_Attack')
	&& !ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Sneak_Attack')
	)
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'witch_emerge_sneakattack_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));
		ACSSheWhoKnows().AddTag('ACS_SheWhoKnows_1st_Sneak_Attack');
	}
	else if (ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Sneak_Attack')
	&& !ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Sneak_Attack'))
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'witch_emerge_sneakattack_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));
		ACSSheWhoKnows().AddTag('ACS_SheWhoKnows_2nd_Sneak_Attack');
	}
	else if (ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_1st_Sneak_Attack')
	&& ACSSheWhoKnows().HasTag('ACS_SheWhoKnows_2nd_Sneak_Attack')) 
	{
		animatedComponentA.PlaySlotAnimationAsync ( 'witch_emerge_sneakattack_03', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 1));
		ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnows_1st_Sneak_Attack');
		ACSSheWhoKnows().RemoveTag('ACS_SheWhoKnows_2nd_Sneak_Attack');
	}

	ACSSheWhoKnows().StopEffect('spawn_disappear');
	ACSSheWhoKnows().StopEffect('death_dissapear');
	ACSSheWhoKnows().PlayEffectSingle('death_dissapear');
	ACSSheWhoKnows().PlayEffectSingle('death_dissapear');
	ACSSheWhoKnows().PlayEffectSingle('death_dissapear');
	ACSSheWhoKnows().PlayEffectSingle('death_dissapear');
	ACSSheWhoKnows().PlayEffectSingle('death_dissapear');

	GetACSWatcher().RemoveTimer('SheWhoKnowsShow');
	GetACSWatcher().AddTimer('SheWhoKnowsShow', 1, false);
}

function ACS_SheWhoKnowsProjectileLaunchSingleStop()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 

	GetACSWatcher().RemoveTimer('SheWhoKnowsProjectileSingle');

	movementAdjustorNPC = ACSSheWhoKnows().GetMovingAgentComponent().GetMovementAdjustor();
	movementAdjustorNPC.CancelAll();

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSSheWhoKnows()).GetComponentByClassName( 'CAnimatedComponent' );	

	animatedComponentA.PlaySlotAnimationAsync ( 'witch_hypno_stop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 1));
}

function ACS_SheWhoKnowsProjectileLaunchSingle()
{
	var proj_1								: W3ACSPoisonProjectile;
	var initpos, newpos, targetPosition		: Vector;

	if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
	{
		theSound.SoundLoadBank( "monster_toad.bnk", false );
	}

	ACSSheWhoKnows().SoundEvent('monster_toad_fx_mucus_spit');

	initpos = ACSSheWhoKnows().GetWorldPosition();	
	initpos.Z += 6;

	newpos = initpos;
	newpos.Z += RandRangeF(2, -2);
	newpos.X += RandRangeF(5, -5);
	newpos.Y -= 2;
			
	targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
	targetPosition.Z += 0.5;

	proj_1 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), newpos );
					
	proj_1.Init(ACSSheWhoKnows());

	//proj_1.PlayEffectSingle('spit_travel');

	proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
	proj_1.DestroyAfter(10);
}

function ACS_SheWhoKnowsProjectileLaunch()
{
	var proj_1, proj_2, proj_3, proj_4, proj_5	 																				: W3ACSPoisonProjectile;
	var initpos, targetPosition, targetPosition_left, targetPosition_right, targetPosition_forward, targetPosition_back			: Vector;

	if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
	{
		theSound.SoundLoadBank( "monster_toad.bnk", false );
	}

	ACSSheWhoKnows().SoundEvent('monster_toad_fx_mucus_spit');

	initpos = ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldRight() * 1.5;	

	initpos.Z += 5;
			
	targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
	targetPosition.Z += 0.5;

	targetPosition_left = GetWitcherPlayer().PredictWorldPosition(0.7f) + GetWitcherPlayer().GetWorldRight() * -2.5;
	targetPosition_left.Z += 0.5;

	targetPosition_right = GetWitcherPlayer().PredictWorldPosition(0.7f) + GetWitcherPlayer().GetWorldRight() * 2.5;
	targetPosition_right.Z += 0.5;

	targetPosition_forward = GetWitcherPlayer().PredictWorldPosition(0.7f) + GetWitcherPlayer().GetWorldForward() * 2.5;
	targetPosition_forward.Z += 0.5;

	targetPosition_back = GetWitcherPlayer().PredictWorldPosition(0.7f) + GetWitcherPlayer().GetWorldForward() * -2.5;
	targetPosition_back.Z += 0.5;


	proj_1 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_1.Init(ACSSheWhoKnows());

	//proj_1.PlayEffectSingle('spit_travel');

	proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
	proj_1.DestroyAfter(10);


	proj_2 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_2.Init(ACSSheWhoKnows());

	//proj_2.PlayEffectSingle('spit_travel');

	proj_2.ShootProjectileAtPosition( 0, 5 + RandRangeF(15 , 0), targetPosition_left, 500 );
	proj_2.DestroyAfter(10);


	proj_3 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_3.Init(ACSSheWhoKnows());

	//proj_3.PlayEffectSingle('spit_travel');

	proj_3.ShootProjectileAtPosition( 0, 5 + RandRangeF(15 , 0), targetPosition_right, 500 );
	proj_3.DestroyAfter(10);


	proj_4 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_4.Init(ACSSheWhoKnows());

	//proj_4.PlayEffectSingle('spit_travel');

	proj_4.ShootProjectileAtPosition( 0, 5 + RandRangeF(15 , 0), targetPosition_forward, 500 );
	proj_4.DestroyAfter(10);


	proj_5 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), initpos );
					
	proj_5.Init(ACSSheWhoKnows());

	//proj_5.PlayEffectSingle('spit_travel');

	proj_5.ShootProjectileAtPosition( 0, 5 + RandRangeF(15 , 0), targetPosition_back, 500 );
	proj_5.DestroyAfter(10);
}

function ACS_SheWhoKnowsProjectileLaunchArea()
{
	var proj_1, proj_2, proj_3, proj_4, proj_5	 																							: W3ACSPoisonProjectile;
	var initpos_1, initpos_2, initpos_3, initpos_4, initpos_5, targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4		: Vector;

	if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
	{
		theSound.SoundLoadBank( "monster_toad.bnk", false );
	}

	ACSSheWhoKnows().SoundEvent('monster_toad_fx_mucus_spit');

	initpos_1 = ACSPlayerFixZAxis(ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldForward() * 2.5 + ACSSheWhoKnows().GetWorldRight() * 2.5);

	//initpos_1.Z -= 0.5;

	initpos_2 = ACSPlayerFixZAxis(ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldForward() * -2.5 + ACSSheWhoKnows().GetWorldRight() * 2.5);

	//initpos_2.Z -= 0.5;

	initpos_3 = ACSPlayerFixZAxis(ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldForward() * 2.5 + ACSSheWhoKnows().GetWorldRight() * -2.5);

	//initpos_3.Z -= 0.5;

	initpos_4 = ACSPlayerFixZAxis(ACSSheWhoKnows().GetWorldPosition() + ACSSheWhoKnows().GetWorldForward() * -2.5 + ACSSheWhoKnows().GetWorldRight() * -2.5);

	//initpos_4.Z -= 0.5;
			
	targetPosition_1 = initpos_1;
	targetPosition_1.Z += 10;
	targetPosition_1.X += 10;
	targetPosition_1.Y += 10;

	targetPosition_2 = initpos_2;
	targetPosition_2.Z += 10;
	targetPosition_2.X += 10;
	targetPosition_2.Y -= 10;

	targetPosition_3 = initpos_3;
	targetPosition_3.Z += 10;
	targetPosition_3.X -= 10;
	targetPosition_3.Y += 10;

	targetPosition_4 = initpos_4;
	targetPosition_4.Z += 10;
	targetPosition_4.X -= 10;
	targetPosition_4.Y -= 10;

	proj_1 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), ACSPlayerFixZAxis(initpos_1) );
					
	proj_1.Init(ACSSheWhoKnows());

	//proj_1.PlayEffectSingle('spit_travel');

	proj_1.ShootProjectileAtPosition( 0, 10, targetPosition_1, 500 );
	proj_1.DestroyAfter(10);


	proj_2 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), ACSPlayerFixZAxis(initpos_2) );
					
	proj_2.Init(ACSSheWhoKnows());

	//proj_2.PlayEffectSingle('spit_travel');

	proj_2.ShootProjectileAtPosition( 0, 10, targetPosition_2, 500 );
	proj_2.DestroyAfter(10);


	proj_3 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), ACSPlayerFixZAxis(initpos_3) );
					
	proj_3.Init(ACSSheWhoKnows());

	//proj_3.PlayEffectSingle('spit_travel');

	proj_3.ShootProjectileAtPosition( 0, 10, targetPosition_3, 500 );
	proj_3.DestroyAfter(10);


	proj_4 = (W3ACSPoisonProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\mother_projectile.w2ent"
		
		, true ), ACSPlayerFixZAxis(initpos_4) );
					
	proj_4.Init(ACSSheWhoKnows());

	//proj_4.PlayEffectSingle('spit_travel');

	proj_4.ShootProjectileAtPosition( 0, 10, targetPosition_4, 500 );
	proj_4.DestroyAfter(10);
}

function ACS_SheWhoKnowsTeleportDamage()
{
	var npc, actortarget				: CActor;
	var victims			 				: array<CActor>;
	var dmg								: W3DamageAction;
	var i								: int;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 				: CAnimatedComponent;
	var params 							: SCustomEffectParams;

	victims.Clear();

	victims = ACSSheWhoKnows().GetNPCsAndPlayersInCone(5, VecHeading(ACSSheWhoKnows().GetHeadingVector()), 360, 20, , FLAG_OnlyAliveActors );

	if (ACSSheWhoKnows().IsAlive())
	{
		ACS_SheWhoKnowsProjectileLaunchArea();

		if( victims.Size() > 0)
		{
			for( i = 0; i < victims.Size(); i += 1 )
			{
				actortarget = (CActor)victims[i];

				if (actortarget != ACSSheWhoKnows()
				&& actortarget != GetACSTentacle_1()
				&& actortarget != GetACSTentacle_2()
				&& actortarget != GetACSTentacle_3()
				&& actortarget != GetACSTentacleAnchor()
				&& actortarget != GetACSNecrofiendTentacle_1()
				&& actortarget != GetACSNecrofiendTentacle_2()
				&& actortarget != GetACSNecrofiendTentacle_3()
				&& actortarget != GetACSNecrofiendTentacle_4()
				&& actortarget != GetACSNecrofiendTentacle_5()
				&& actortarget != GetACSNecrofiendTentacle_6()
				&& actortarget != GetACSNecrofiendTentacleAnchor()
				)
				{
					if 
					(
						GetWitcherPlayer().IsInGuardedState()
						|| GetWitcherPlayer().IsGuarded()
					)
					{
						GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
						GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
					}
					else if 
					(
						GetWitcherPlayer().IsAnyQuenActive()
					)
					{
						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else if 
					(
						GetWitcherPlayer().IsCurrentlyDodging()
					)
					{
						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
						GetWitcherPlayer().StopEffect('lasting_shield_discharge');
					}
					else
					{
						movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();

						ticket = movementAdjustor.GetRequest( 'ACS_She_Who_Knows_Hit_Rotate');
						movementAdjustor.CancelByName( 'ACS_She_Who_Knows_Hit_Rotate' );
						movementAdjustor.CancelAll();

						ticket = movementAdjustor.CreateNewRequest( 'ACS_She_Who_Knows_Hit_Rotate' );
						movementAdjustor.AdjustmentDuration( ticket, 0.1 );
						movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

						movementAdjustor.RotateTowards( ticket, ACSSheWhoKnows() );

						if (actortarget == GetWitcherPlayer())
						{
							AnimatedComponent = (CAnimatedComponent)actortarget.GetComponentByClassName( 'CAnimatedComponent' );	

							AnimatedComponent.PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

							if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
							{
								GetACSWatcher().Grow_Geralt_Immediate_Fast();

								GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
							}

							GetWitcherPlayer().ClearAnimationSpeedMultipliers();	
						}

						actortarget.SoundEvent("cmb_play_dismemberment_gore");

						actortarget.SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						params.effectType = EET_Knockdown;
						params.creator = ACSSheWhoKnows();
						params.sourceName = "ACS_She_Who_Knows_Knockdown";
						params.duration = 1;

						actortarget.AddEffectCustom( params );

						params.effectType = EET_Poison;
						params.creator = ACSSheWhoKnows();
						params.sourceName = "ACS_She_Who_Knows_Poison";
						params.duration = 5;

						actortarget.AddEffectCustom( params );	
					}
				}
			}
		}
	}
}

function ACSSheWhoKnows() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_She_Who_Knows' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACSBigLizard() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Big_Lizard' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Werewolf_Spawn_Adds
{
	function ACS_Werewolf_Spawn_Adds_Engage()
	{
		this.PushState('ACS_Werewolf_Spawn_Adds_Engage');
	}
}

state ACS_Werewolf_Spawn_Adds_Engage in cACS_Werewolf_Spawn_Adds
{
	private var actors, victims																		: array<CActor>;
	private var i, count, j 																		: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var spawnPos, playerPos, newPlayerPos													: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent_1, ent_2, ent_3, vfxEnt_1, vfxEnt_2												: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var playerRot, adjustedRot																: EulerAngles;
	private var temp, ent_1_temp, ent_2_temp														: CEntityTemplate;

	private var randAngle, randRange																: float;

	private var animatedComponentA																	: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_Werewolf_Spawn_Adds_Entry();
	}
	
	entry function ACS_Werewolf_Spawn_Adds_Entry()
	{
		ACS_Werewolf_Spawn_Adds_Latent();
	}
	
	latent function ACS_Werewolf_Spawn_Adds_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				(
				(npc.HasAbility('mon_werewolf_lesser')
				|| npc.HasAbility('mon_werewolf')
				|| npc.HasAbility('mon_lycanthrope')
				)
				&& npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.5
				&& npc.IsAlive()
				&& !npc.HasTag('ACS_Shades_Kara_Shadow_Werewolf')
				)
				)			
				{
					if (targetDistance > 5 * 5 && targetDistance <= 20 * 20)
					{
						if ( !theSound.SoundIsBankLoaded("animals_wolf.bnk") )
						{
							theSound.SoundLoadBank( "animals_wolf.bnk", false );
						}

						if ( !theSound.SoundIsBankLoaded("monster_wild_dog.bnk") )
						{
							theSound.SoundLoadBank( "monster_wild_dog.bnk", false );
						}

						if (!npc.HasTag('ACS_Werewolf_Has_Summoned_Adds'))
						{
							npc.AddTag('ACS_Werewolf_Has_Summoned_Adds');





							vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(
							"dlc\bob\data\fx\gameplay\mutation\mutation_7\mutation_7.w2ent"
							, true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

							vfxEnt_1.CreateAttachment( npc, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );

							vfxEnt_1.PlayEffectSingle('sonar_mesh');

							vfxEnt_1.PlayEffectSingle('sonar');

							vfxEnt_1.PlayEffectSingle('fx_sonar');

							vfxEnt_1.DestroyAfter(2);



							vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(
								"dlc\dlc_acs\data\fx\acs_sonar.w2ent"
								, true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

							vfxEnt_2.CreateAttachment( npc, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );


							vfxEnt_2.PlayEffectSingle('sonar_mesh');

							vfxEnt_2.PlayEffectSingle('sonar');

							vfxEnt_2.PlayEffectSingle('fx_sonar');

							vfxEnt_2.DestroyAfter(2);




							movementAdjustor = ((CActor)npc).GetMovingAgentComponent().GetMovementAdjustor();

							ticket = movementAdjustor.GetRequest( 'ACS_Werewolf_Smmmon_Rotate');
							movementAdjustor.CancelByName( 'ACS_Werewolf_Smmmon_Rotate' );
							movementAdjustor.CancelAll();

							ticket = movementAdjustor.CreateNewRequest( 'ACS_Werewolf_Smmmon_Rotate' );
							movementAdjustor.AdjustmentDuration( ticket, 0.5 );
							movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

							movementAdjustor.RotateTowards(ticket, ((CActor)(npc.GetTarget())));

							((CAnimatedComponent)((CNewNPC)npc).GetComponentByClassName( 'CAnimatedComponent' )).RaiseBehaviorForceEvent('Howl');

							if ( npc.IsInInterior() )
							{
								((CActor)npc).SetCanPlayHitAnim(false); 

								npc.AddBuffImmunity(EET_Stagger, 'acs_werewolf_howl_interior', true);

								npc.AddBuffImmunity(EET_LongStagger, 'acs_werewolf_howl_interior', true);

								npc.AddBuffImmunity(EET_Knockdown , 'acs_werewolf_howl_interior', true);

								npc.AddBuffImmunity(EET_HeavyKnockdown , 'acs_werewolf_howl_interior', true);
							}
							else
							{
								npc.SoundEvent("animals_wolf_howl");

								npc.SoundEvent("monster_wild_dog_howl");

								temp = (CEntityTemplate)LoadResourceAsync( 

								"characters\npc_entities\monsters\wolf_lvl1__summon.w2ent"
									
								, true );

								playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * -10;

								if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newPlayerPos ) )
								{
									theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.5f, 10 , newPlayerPos );
									playerPos = newPlayerPos;
								}

								playerRot = thePlayer.GetWorldRotation();

								adjustedRot = EulerAngles(0,0,0);

								adjustedRot.Yaw = playerRot.Yaw;

								ent_1 = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

								((CNewNPC)ent_1).SetAttitude(npc, AIA_Friendly);

								((CNewNPC)ent_1).SetLevel(npc.GetLevel() - 3);

								((CNewNPC)ent_1).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);

								ent_2 = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

								((CNewNPC)ent_2).SetAttitude(npc, AIA_Friendly);

								((CNewNPC)ent_2).SetLevel( npc.GetLevel() - 3 );

								((CNewNPC)ent_2).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);

								ent_3 = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

								((CNewNPC)ent_3).SetAttitude(npc, AIA_Friendly);

								((CNewNPC)ent_3).SetLevel(npc.GetLevel() - 3);

								((CNewNPC)ent_3).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);

								/*
								
								count = 3;
									
								for( j = 0; j < count; j += 1 )
								{
									randRange = 2.5 + 2.5 * RandF();
									randAngle = 2.5 * Pi() * RandF();
									
									spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
									spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
									spawnPos.Z = playerPos.Z;
									
									theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 5.f, spawnPos);

									ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

									((CNewNPC)ent).SetLevel(npc.GetLevel()/2);

									((CNewNPC)ent).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);
									((CActor)ent).SetAnimationSpeedMultiplier(1);

									ent.AddTag( 'ACS_Werewolf_Summoned_Wolves' );
								}
								*/
							}
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_WildHunt_Rider_Area_Check() : bool
{
	if (
	theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_NMLandNovigrad
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Velen
	)
	{
		return true;
	}

	return false;
}

statemachine class cACS_Wild_Hunt_Riders
{
    function ACS_Wild_Hunt_Riders_Engage()
	{
		this.PushState('ACS_Wild_Hunt_Riders_Engage');
	}

	function ACS_Eredin_Spawn_Engage()
	{
		this.PushState('ACS_Eredin_Spawn_Engage');
	}

	function ACS_Dark_Portal_Spawn_Engage()
	{
		this.PushState('ACS_Dark_Portal_Spawn_Engage');
	}

	function ACS_Wh_Ship_Spawn_Engage()
	{
		this.PushState('ACS_Wh_Ship_Spawn_Engage');
	}
}

state ACS_Wild_Hunt_Riders_Engage in cACS_Wild_Hunt_Riders
{
	private var temp, temp_2, temp_3											: CEntityTemplate;
	private var ent, ent_2, ent_3												: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos, newSpawnPos								: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	private var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	private var l_aiTree														: CAIHorseDoNothingAction;			
	private var horseTag 														: array<name>;	
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;

	event OnEnterState(prevStateName : name)
	{
		Wild_Hunt_Riders_Entry();
	}
	
	entry function Wild_Hunt_Riders_Entry()
	{	
		Wild_Hunt_Riders_Latent();
	}

	latent function Wild_Hunt_Riders_Latent()
	{
		thePlayer.AddTag('ACS_Wild_Hunt_Pursuit');

		GetACSWatcher().RemoveTimer('ACS_WildHuntRiders_Spawn');

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\enemy_rider_wildhunt.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\horse_vehicle_wild_hunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * RandRangeF(70,20) + thePlayer.GetWorldRight() * RandRangeF(25,-25);

		//playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + (thePlayer.GetHeadingVector() * RandRangeF(50,10)) + thePlayer.GetWorldRight() * RandRangeF(25,-25);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = RandRange(7,5);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			ent_3 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			ent_3.PlayEffectSingle('teleport_fx');

			ent_3.DestroyAfter(3);

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.15;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetAttitude(GetACSEredin(), AIA_Friendly);

			((CActor)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag('NoBestiaryEntry');

			ent.PlayEffectSingle('critical_frozen');

			horseTag.Clear();
			
			horseTag.PushBack('enemy_horse');

			ent_2 = theGame.CreateEntity(temp_2, ACSPlayerFixZAxis(spawnPos), playerRot,true,false,false,PM_DontPersist,horseTag);

			ent_2.PlayEffectSingle('ice_armor_no_smoke');

			//((CNewNPC)ent_2).EnableCollisions(false);

			//((CNewNPC)ent_2).EnableCharacterCollisions(false);

			//((CNewNPC)ent).SetAttitude(((CNewNPC)ent_2), AIA_Friendly);

			//((CNewNPC)ent_2).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			ent.AddTag( 'ACS_Wild_Hunt_Rider' );

			ent_2.AddTag( 'ACS_Wild_Hunt_Rider_Horse' );

			movementAdjustor = ((CActor)ent_2).GetMovingAgentComponent().GetMovementAdjustor();

			ticket = movementAdjustor.GetRequest( 'ACS_Wild_Hunt_Smmmon_Rotate');
			movementAdjustor.CancelByName( 'ACS_Wild_Hunt_Smmmon_Rotate' );
			movementAdjustor.CancelAll();

			ticket = movementAdjustor.CreateNewRequest( 'ACS_Wild_Hunt_Smmmon_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.5 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

			movementAdjustor.RotateTowards(ticket, thePlayer);


			l_aiTree = new CAIHorseDoNothingAction in ent;
			l_aiTree.OnCreated();
			((CActor)ent).ForceAIBehavior( l_aiTree, BTAP_Emergency, 'AI_Rider_Load_Forced' );

			((CActor)ent).SignalGameplayEventParamInt( 'RidingManagerMountHorse', MT_instant | MT_fromScript );
		}

		GetACSWatcher().RemoveTimer('ACS_WildHuntRiders_DeactivateFrostEffect');

		GetACSWatcher().RemoveTimer('ACS_WildHuntRiders_Destroy');

		GetACSWatcher().AddTimer('ACS_WildHuntRiders_DeactivateFrostEffect', 30, false);

		GetACSWatcher().AddTimer('ACS_WildHuntRiders_Destroy', 60, false);
	}
}

state ACS_Eredin_Spawn_Engage in cACS_Wild_Hunt_Riders
{
	event OnEnterState(prevStateName : name)
	{
		Eredin_Spawn_Entry();
	}
	
	entry function Eredin_Spawn_Entry()
	{	
		Eredin_Spawn_Latent();
	}

	latent function Eredin_Spawn_Latent()
	{
		var temp, portal_temp												: CEntityTemplate;
		var ent, portal_ent													: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var playerRot, adjustedRot											: EulerAngles;	

		GetACSEredin().Destroy();

		if (FactsQuerySum("q501_eredin_died") > 0)
		{
			temp = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\monsters\enemy_eredin_miniboss_alt.w2ent"
				
			, true );
		}
		else
		{
			temp = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\monsters\enemy_eredin_miniboss.w2ent"
				
			, true );
		}

		portal_temp = (CEntityTemplate)LoadResourceAsync( 

		"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 20;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

		((CActor)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).SetVisibility( false );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Eredin' );

		GetACSWatcher().RemoveTimer('ACS_Eredin_SetVisibility');

		GetACSWatcher().AddTimer('ACS_Eredin_SetVisibility', 1, false);

		GetACSWatcher().RemoveTimer('ACS_Eredin_Kill_Timer');

		GetACSWatcher().AddTimer('ACS_Eredin_Kill_Timer', 45, false);



		portal_ent = theGame.CreateEntity( portal_temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		portal_ent.PlayEffectSingle('teleport_fx');

		portal_ent.DestroyAfter(3);

		ent.AddTag( 'ACS_Eredin_Portal' );

		ent.PlayEffectSingle('him_smoke');
		ent.PlayEffectSingle('smokeman');
		ent.PlayEffectSingle('him_smoke_red');

		//animcomp.PlaySlotAnimationAsync ( 'attack_ready_furycombo_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
	}
}

state ACS_Dark_Portal_Spawn_Engage in cACS_Wild_Hunt_Riders
{
	event OnEnterState(prevStateName : name)
	{
		Dark_Portal_Spawn_Entry();
	}
	
	entry function Dark_Portal_Spawn_Entry()
	{	
		Dark_Portal_Spawn_Latent();
	}

	latent function Dark_Portal_Spawn_Latent()
	{
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos														: Vector;
		var meshcomp														: CComponent;
		var playerRot, adjustedRot											: EulerAngles;

		GetACSDarkPortal().Destroy();
		GetACSDarkPortalEnt().Destroy();

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\other\dark_portal_ent.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 20;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		ent.AddTag('ACS_Dark_Portal');

		ent.DestroyAfter(30);
	}
}

state ACS_Wh_Ship_Spawn_Engage in cACS_Wild_Hunt_Riders
{
	event OnEnterState(prevStateName : name)
	{
		Wh_Ship_Spawn_Entry();
	}
	
	entry function Wh_Ship_Spawn_Entry()
	{	
		Wh_Ship_Spawn_Latent();
	}

	latent function Wh_Ship_Spawn_Latent()
	{
		var temp, temp_2													: CEntityTemplate;
		var ent, ent_2														: CEntity;
		var playerPos, playerPos2, entPos									: Vector;
		var playerRot, adjustedRot											: EulerAngles;

		GetACSNaglfar().Destroy();

		GetACSNaglfarPortal().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"items\cutscenes\wild_hunt_ship_cs\wild_hunt_ship_cs.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\test_rift.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 200;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw -= 101.25;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		playerPos.Z += 50;

		playerPos2 = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 200;

		playerPos2.Z += 50;

		ent = theGame.CreateEntity( temp, playerPos, adjustedRot );

		ent.AddTag( 'ACS_Naglfar' );

		entPos = ent.GetWorldPosition(); 

		entPos.Z += 6;

		ent_2 = theGame.CreateEntity( temp_2, entPos + ent.GetWorldRight() * 50, adjustedRot );

		ent_2.PlayEffect('test_rift_2');

		ent_2.AddTag( 'ACS_Naglfar_Portal' );

		ent_2.DestroyAfter(35);

		thePlayer.SoundEvent("magic_caranthil_teleport_fx_stop");

		thePlayer.SoundEvent("magic_caranthil_teleport_fx_start");

		GetACSWatcher().naglfarProgressReset();

		GetACSWatcher().RemoveTimer('NaglfarStopSound');

		GetACSWatcher().RemoveTimer('NaglfarMove');
		GetACSWatcher().AddTimer('NaglfarMove', 0.0001, true);

		GetACSWatcher().RemoveTimer('NaglfarStop');
		GetACSWatcher().AddTimer('NaglfarStop', 35, false);
	}
}

function ACSWildHuntRiders_CheckDistance() : bool
{	
	var actors		    				: array<CActor>;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 15, 5, 'ACS_Wild_Hunt_Rider', FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		return true;
	}

	return false;
}

function ACSWildHuntRiders_DeactivateFrostEffect_Actual()
{	
	var actors 											: array<CActor>;
	var i, j											: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].StopEffect('critical_frozen');
	}

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider_Horse', actors );	
	
	for( j = 0; j < actors.Size(); j += 1 )
	{
		actors[j].StopEffect('ice_armor_no_smoke');
	}
}

function ACSWildHuntRidersRideTowardsPlayer()
{	
	var actors 															: array<CActor>;
	var i, j															: int;
	var targetDistance_1, targetDistance_2 								: float;
	var movementAdjustor												: CMovementAdjustor;
	var ticket 															: SMovementAdjustmentRequestTicket;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		targetDistance_1 = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actors[i].GetWorldPosition() ) ;

		if (targetDistance_1 > 5 * 5)
		{
			actors[i].GetMovingAgentComponent().ForceSetRelativeMoveSpeed( 2 );

			actors[i].GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - actors[i].GetWorldPosition()));
		}
	}

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider_Horse', actors );	
	
	for( j = 0; j < actors.Size(); j += 1 )
	{
		targetDistance_2 = VecDistanceSquared2D( thePlayer.GetWorldPosition(), actors[j].GetWorldPosition() ) ;

		movementAdjustor = actors[j].GetMovingAgentComponent().GetMovementAdjustor();

		if( (actors[j].GetMovingAgentComponent()).IsOnNavigableSpace() )
		{
			(actors[j].GetMovingAgentComponent()).SnapToNavigableSpace( true );
		}		

		if (targetDistance_2 > 7.5  * 7.5
		&& ((CNewNPC)actors[j]).GetHorseComponent().IsFullyMounted() )
		{
			actors[j].GetMovingAgentComponent().SetGameplayRelativeMoveSpeed( 2 );

			actors[j].GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - actors[j].GetWorldPosition()));

			//actors[j].SetBehaviorVariable( 'direction', VecHeading(thePlayer.GetWorldPosition() - actors[j].GetWorldPosition()) );

			movementAdjustor = actors[j].GetMovingAgentComponent().GetMovementAdjustor();

			ticket = movementAdjustor.GetRequest( 'ACS_Wild_Hunt_Horse_Rotate');
			movementAdjustor.CancelByName( 'ACS_Wild_Hunt_Horse_Rotate' );
			movementAdjustor.CancelAll();

			ticket = movementAdjustor.CreateNewRequest( 'ACS_Wild_Hunt_Horse_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 1 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

			movementAdjustor.RotateTowards(ticket, thePlayer);
		}
		else
		{
			actors[j].GetMovingAgentComponent().SetGameplayRelativeMoveSpeed( 0 );

			movementAdjustor.CancelAll();

			actors[j].SetBehaviorVariable( 'direction',  VecHeading(actors[j].GetWorldPosition()) );
		}
	}
}

function ACSWildHuntRiders_Destroy()
{	
	var actors 											: array<CActor>;
	var i, j											: int;
	var temp											: CEntityTemplate;
	var ent												: CEntity;
	var animatedComponentRider							: CAnimatedComponent;
	var animatedComponentHorse							: CAnimatedComponent;

	thePlayer.RemoveTag('ACS_Wild_Hunt_Pursuit');

	temp = (CEntityTemplate)LoadResource( 

	"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
		
	, true );
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		animatedComponentRider = (CAnimatedComponent)actors[i].GetComponentByClassName( 'CAnimatedComponent' );

		if (actors[i].IsAlive())
		{
			if (!actors[i].IsUsingHorse())
			{
				animatedComponentRider.PlaySlotAnimationAsync ( 'sq701_knight_sword_drawn_gesture_hailing', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
			}

			actors[i].PlayEffectSingle('critical_frozen');

			ent = theGame.CreateEntity( temp, actors[i].GetWorldPosition(), actors[i].GetWorldRotation() );

			ent.CreateAttachment( actors[i], , Vector( 0, 0, 1 ), EulerAngles(0,0,0) );

			ent.PlayEffectSingle('teleport_fx');

			ent.DestroyAfter(3);

			actors[i].DestroyAfter(2);
		}
	}

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Wild_Hunt_Rider_Horse', actors );	
	
	for( j = 0; j < actors.Size(); j += 1 )
	{
		animatedComponentHorse = (CAnimatedComponent)actors[j].GetComponentByClassName( 'CAnimatedComponent' );

		if (thePlayer.GetUsedVehicle() == actors[j])
		{
			thePlayer.AddEffectDefault( EET_HeavyKnockdown, thePlayer, "ACS_Wild_Hunt_Horse_Knockdown" );
		}
		else
		{
			if (actors[j].IsAlive())
			{
				animatedComponentHorse.PlaySlotAnimationAsync ( 'horse_rearing01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
			}
		}

		actors[j].PlayEffectSingle('ice_armor_no_smoke');

		ent = theGame.CreateEntity( temp, actors[j].GetWorldPosition(), actors[j].GetWorldRotation() );

		ent.CreateAttachment( actors[j], , Vector( 0, 0, 0.75 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('teleport_fx');

		ent.DestroyAfter(3);

		actors[j].DestroyAfter(2);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_spawneredin()
{
	var temp, portal_temp												: CEntityTemplate;
	var ent, portal_ent													: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var playerRot, adjustedRot											: EulerAngles;	

	GetACSEredin().Destroy();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\enemy_eredin_miniboss.w2ent"
		
	, true );

	portal_temp = (CEntityTemplate)LoadResource( 

	"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
		
	, true );

	playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	adjustedRot = EulerAngles(0,0,0);

	adjustedRot.Yaw = playerRot.Yaw;

	ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');
	h = 1;
	animcomp.SetScale(Vector(h,h,h,1));
	meshcomp.SetScale(Vector(h,h,h,1));	

	((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

	((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

	((CActor)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

	((CActor)ent).SetAnimationSpeedMultiplier(1);

	((CNewNPC)ent).SetVisibility( false );

	((CActor)ent).AddTag( 'ContractTarget' );

	((CActor)ent).AddTag('IsBoss');

	((CActor)ent).AddAbility('Boss');

	((CActor)ent).AddAbility('BounceBoltsWildhunt');

	ent.AddTag('NoBestiaryEntry');

	ent.AddTag( 'ACS_Eredin' );

	((CActor)ent).GetInventory().AddAnItem('ACS_Steel_Zireal_Sword', 1);

	GetACSWatcher().RemoveTimer('ACS_Eredin_SetVisibility');

	GetACSWatcher().AddTimer('ACS_Eredin_SetVisibility', 1, false);

	GetACSWatcher().RemoveTimer('ACS_Eredin_Kill_Timer');

	GetACSWatcher().AddTimer('ACS_Eredin_Kill_Timer', 45, false);



	portal_ent = theGame.CreateEntity( portal_temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

	portal_ent.PlayEffectSingle('teleport_fx');

	portal_ent.DestroyAfter(3);

	ent.AddTag( 'ACS_Eredin_Portal' );

	//ent.PlayEffectSingle('rift_fx_special');
	//ent.StopEffect('rift_fx_special');

	//ent.PlayEffectSingle('disappear');
	//ent.StopEffect('disappear');

	//animcomp.PlaySlotAnimationAsync ( 'attack_ready_furycombo_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
}

function GetACSEredin() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Eredin' );
	return entity;
}

function GetACSEredinPortal() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Eredin_Portal' );
	return entity;
}

function GetACSEredin_CheckDistance() : bool
{	
	var actors		    				: array<CActor>;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 15, 1, 'ACS_Eredin', FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		return true;
	}
	else
	{
		return false;
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_NightStalkerAreaCheck() : bool
{
	if (
	theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_NMLandNovigrad
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Velen
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Kaer_Morhen
	|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Dlc_Bob
	)
	{
		return true;
	}

	return false;
}

function GetACSNightStalker() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Night_Stalker' );
	return entity;
}

statemachine class cACS_Night_Stalker
{
    function ACS_Night_Stalker_Engage()
	{
		this.PushState('ACS_Night_Stalker_Engage');
	}
}

state ACS_Night_Stalker_Engage in cACS_Night_Stalker
{
	private var temp, temp2, ent_1_temp, trail_temp							: CEntityTemplate;
	var ent, ent2, ent_1, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;			
	var p_comp															: CComponent;
	var apptemp															: CEntityTemplate;	

	event OnEnterState(prevStateName : name)
	{
		Night_Stalker_Entry();
	}
	
	entry function Night_Stalker_Entry()
	{	
		Night_Stalker_Latent();
	}

	latent function Night_Stalker_Latent()
	{
		GetACSNightStalker().Destroy();

		GetACSWatcher().RemoveTimer('ACS_NightStalker_Kill_Timer');

		GetACSWatcher().RemoveTimer('NightStalkerCamo');
		GetACSWatcher().RemoveTimer('NightStalkerVisibility');

		GetACSWatcher().RemoveTimer('NightStalkerDeathCamo');
		GetACSWatcher().RemoveTimer('NightStalkerDeathTeleport');

		GetACSWatcher().AddTimer('NightStalkerCamo', 7, true);

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\nightstalker.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		

		ent = theGame.CreateEntity( temp, playerPos, adjustedRot );

		p_comp = ent.GetComponentByClassName( 'CAppearanceComponent' );



		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.25;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');
		
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffectSingle('demonic_possession');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Night_Stalker_Buff', true);

		((CActor)ent).SetCanPlayHitAnim(false); 

		ent.AddTag( 'ACS_Night_Stalker' );

		ent.AddTag('ACS_Hostile_To_All');

		GetACSWatcher().AddTimer('ACS_NightStalker_Kill_Timer', 45, false);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_XenoSwarm_Spawner
{
    function ACS_XenoTyrant_Spawner_Engage()
	{
		this.PushState('ACS_XenoTyrant_Spawner_Engage');
	}

	function ACS_XenoSoldiers_Spawn_Engage()
	{
		this.PushState('ACS_XenoSoldiers_Spawn_Engage');
	}

	function ACS_XenoWorkers_Spawn_Engage()
	{
		this.PushState('ACS_XenoWorkers_Spawn_Engage');
	}
}

state ACS_XenoTyrant_Spawner_Engage in cACS_XenoSwarm_Spawner
{
	private var temp, temp_2, ent_1_temp, trail_temp, quen_temp, quen_hit_temp, anchor_temp														: CEntityTemplate;
	private var ent, ent_2, quen_ent, quen_hit_ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3, chestblade_4, chestanchor			: CEntity;
	private var i, count																														: int;
	private var playerPos, spawnPos																												: Vector;
	private var randAngle, randRange																											: float;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var bone_vec, pos, attach_vec																										: Vector;
	private var bone_rot, rot, attach_rot																										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_XenoSwarm_Entry();
	}
	
	entry function Spawn_XenoSwarm_Entry()
	{	
		Spawn_XenoSwarm_Latent();
	}

	latent function Spawn_XenoSwarm_Latent()
	{
		ACS_spawnxenotyrant();
	}

	latent function ACS_spawnxenotyrant()
	{
		var temp															: CEntityTemplate;
		var ent 															: CEntity;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;

		GetACSXenoTyrant().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_kikimore_tyrant.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = 1;
			
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.75;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetCanPlayHitAnim(false); 

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
		((CActor)ent).SetAnimationSpeedMultiplier(0.75);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Xeno_Tyrant_Buff', true);

		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Xeno_Tyrant_Buff', true);

		ent.AddTag( 'ACS_Xeno_Tyrant' );

		GetACSWatcher().RemoveTimer('ACS_Spawn_XenoSoldiers_Swarm');
		GetACSWatcher().AddTimer('ACS_Spawn_XenoSoldiers_Swarm', 1, false);
	}
}

state ACS_XenoSoldiers_Spawn_Engage in cACS_XenoSwarm_Spawner
{
	event OnEnterState(prevStateName : name)
	{
		XenoSoldiers_Spawn_Entry();
	}
	
	entry function XenoSoldiers_Spawn_Entry()
	{	
		XenoSoldiers_Spawn_Latent();
	}

	latent function XenoSoldiers_Spawn_Latent()
	{
		ACS_spawnxenosoldiers();
	}

	latent function ACS_spawnxenosoldiers()
	{
		var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
		var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, newSpawnPos								: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
		var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
		var l_aiTree														: CAIMoveToAction;			

		//GetACSXenoSoldiersDestroyAll();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_kikimore_small.w2ent"
			
		, true );

		playerPos = GetACSXenoTyrant().GetWorldPosition();

		playerRot = GetACSXenoTyrant().GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = 5;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 3 + 3 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.125;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag('NoBestiaryEntry');

			ent.AddTag( 'ACS_Xeno_Soldiers' );
		}
	}
}

state ACS_XenoWorkers_Spawn_Engage in cACS_XenoSwarm_Spawner
{
	event OnEnterState(prevStateName : name)
	{
		XenoWorkers_Spawn_Entry();
	}
	
	entry function XenoWorkers_Spawn_Entry()
	{	
		XenoWorkers_Spawn_Latent();
	}

	latent function XenoWorkers_Spawn_Latent()
	{
		ACS_spawnxenoworkers();
	}

	latent function ACS_spawnxenoworkers()
	{
		var temp_1, temp_2													: CEntityTemplate;
		var ent_1, ent_2, ent_3												: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, newSpawnPos								: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var pos																: Vector;
		var playerRot, adjustedRot											: EulerAngles;

		//GetACSXenoWorkersDestroyAll();

		//GetACSXenoArmoredWorkersDestroyAll();

		temp_1 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_workers.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_workers_normal.w2ent"
			
		, true );

		playerPos = GetACSXenoTyrant().GetWorldPosition();

		playerRot = GetACSXenoTyrant().GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = 5;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 7 + 7 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
			{
				theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
				spawnPos = newSpawnPos;
			}

			ent_1 = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_1.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_1).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_1).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_1).SetAnimationSpeedMultiplier(1);

			((CActor)ent_1).AddTag( 'ContractTarget' );

			((CActor)ent_1).AddAbility('BounceBoltsWildhunt');

			ent_1.AddTag('NoBestiaryEntry');

			ent_1.AddTag( 'ACS_Xeno_Workers' );


			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent_2 = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1.125;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent_2).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddTag( 'ContractTarget' );

			((CActor)ent_2).AddAbility('BounceBoltsWildhunt');

			((CActor)ent_2).AddAbility('mon_arachas');
			
			ent_2.AddTag('NoBestiaryEntry');

			ent_2.AddTag( 'ACS_Xeno_Armored_Workers' );
		}
	}
}

function GetACSXenoTyrant() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Xeno_Tyrant' );
	return entity;
}

function ACSXenoTyrantAddAbility()
{
	if (!GetACSXenoTyrant().HasAbility('mon_kikimore_small'))
	{
		GetACSXenoTyrant().AddAbility('mon_kikimore_small');
	}
}

function ACSXenoTyrantnRemoveAbility()
{
	if (GetACSXenoTyrant().HasAbility('mon_kikimore_small'))
	{
		GetACSXenoTyrant().RemoveAbility('mon_kikimore_small');
	}
}

function GetACSXenoSoldiersDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Soldiers', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function ACSXenoSoldiersAddAbility()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Soldiers', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (actors[i].HasAbility('mon_kikimore_small'))
		{
			actors[i].RemoveAbility('mon_kikimore_small');
		}

		if (actors[i].HasAbility('Burrow'))
		{
			actors[i].RemoveAbility('Burrow');
		}

		if (actors[i].HasAbility('mon_kikimora_worker'))
		{
			actors[i].RemoveAbility('mon_kikimora_worker');
		}

		if (!actors[i].HasAbility('mon_kikimore_big'))
		{
			actors[i].AddAbility('mon_kikimore_big');
		}

		if (!actors[i].HasAbility('mon_kikimora_warrior'))
		{
			actors[i].AddAbility('mon_kikimora_warrior');
		}
	}
}

function ACSXenoSoldiersRemoveAbility()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Soldiers', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (actors[i].HasAbility('mon_kikimore_big'))
		{
			actors[i].RemoveAbility('mon_kikimore_big');
		}

		if (actors[i].HasAbility('mon_kikimora_warrior'))
		{
			actors[i].RemoveAbility('mon_kikimora_warrior');
		}

		if (!actors[i].HasAbility('mon_kikimore_small'))
		{
			actors[i].AddAbility('mon_kikimore_small');
		}

		if (!actors[i].HasAbility('Burrow'))
		{
			actors[i].AddAbility('Burrow');
		}

		if (!actors[i].HasAbility('mon_kikimora_worker'))
		{
			actors[i].AddAbility('mon_kikimora_worker');
		}
	}
}

function GetACSXenoWorkersDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Workers', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function GetACSXenoArmoredWorkersDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Armored_Workers', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function ACSXenoArmoredWorkersSwapAbility()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Xeno_Armored_Workers', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (RandF() < 0.5)
		{
			if (RandF() < 0.5)
			{
				if (!actors[i].HasAbility('Venom'))
				{
					actors[i].AddAbility('Venom');
				}

				if (!actors[i].HasAbility('mon_endriaga_worker'))
				{
					actors[i].AddAbility('mon_endriaga_worker');
				}

				if (actors[i].HasAbility('Charge'))
				{
					actors[i].RemoveAbility('Charge');
				}

				if (actors[i].HasAbility('Block'))
				{
					actors[i].RemoveAbility('Block');
				}

				if (actors[i].HasAbility('Spikes'))
				{
					actors[i].RemoveAbility('Spikes');
				}
			}
			else
			{
				if (!actors[i].HasAbility('Charge'))
				{
					actors[i].AddAbility('Charge');
				}

				if (!actors[i].HasAbility('mon_endriaga_soldier_spikey'))
				{
					actors[i].AddAbility('mon_endriaga_soldier_spikey');
				}

				if (actors[i].HasAbility('Venom'))
				{
					actors[i].RemoveAbility('Venom');
				}

				if (actors[i].HasAbility('Block'))
				{
					actors[i].RemoveAbility('Block');
				}

				if (actors[i].HasAbility('Spikes'))
				{
					actors[i].RemoveAbility('Spikes');
				}
			}
		}
		else
		{
			if (RandF() < 0.5)
			{
				if (!actors[i].HasAbility('Block'))
				{
					actors[i].AddAbility('Block');
				}

				if (!actors[i].HasAbility('mon_arachas'))
				{
					actors[i].AddAbility('mon_arachas');
				}

				if (actors[i].HasAbility('Charge'))
				{
					actors[i].RemoveAbility('Charge');
				}

				if (actors[i].HasAbility('Venom'))
				{
					actors[i].RemoveAbility('Venom');
				}

				if (actors[i].HasAbility('Spikes'))
				{
					actors[i].RemoveAbility('Spikes');
				}
			}
			else
			{
				if (!actors[i].HasAbility('Spikes'))
				{
					actors[i].AddAbility('Spikes');
				}

				if (!actors[i].HasAbility('mon_endriaga_soldier_spikey'))
				{
					actors[i].AddAbility('mon_endriaga_soldier_spikey');
				}

				if (actors[i].HasAbility('Charge'))
				{
					actors[i].RemoveAbility('Charge');
				}

				if (actors[i].HasAbility('Block'))
				{
					actors[i].RemoveAbility('Block');
				}

				if (actors[i].HasAbility('Venom'))
				{
					actors[i].RemoveAbility('Venom');
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSLynxWitcher() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Lynx_Witcher' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_CanarisBuffCheck() : bool
{
	if ( GetACSCanaris().HasBuff(EET_HeavyKnockdown) 
	|| GetACSCanaris().HasBuff( EET_Knockdown ) 
	|| GetACSCanaris().HasBuff( EET_Ragdoll ) 
	|| GetACSCanaris().HasBuff( EET_Stagger )
	|| GetACSCanaris().HasBuff( EET_LongStagger )
	|| GetACSCanaris().HasBuff( EET_Pull )
	|| GetACSCanaris().HasBuff( EET_Hypnotized )
	|| GetACSCanaris().HasBuff( EET_WitchHypnotized )
	|| GetACSCanaris().HasBuff( EET_Blindness )
	|| GetACSCanaris().HasBuff( EET_WraithBlindness )
	|| GetACSCanaris().HasBuff( EET_Frozen )
	|| GetACSCanaris().HasBuff( EET_Paralyzed )
	|| GetACSCanaris().HasBuff( EET_Confusion )
	|| GetACSCanaris().HasBuff( EET_Tangled )
	|| GetACSCanaris().HasBuff( EET_Tornado ) 
	|| GetACSCanaris().HasBuff( EET_Swarm ) 
	|| !GetACSCanaris().GetVisibility()
	|| ((CNewNPC)GetACSCanaris()).IsInHitAnim()
	)
	{
		return false;
	}
	else
	{
		return true;
	}
}

function GetACSCanaris() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Canaris' );
	return entity;
}

function ACSCanaris_RemoveTimers()
{
	GetACSCanarisIceSpearSingle().BreakAttachment();
	GetACSCanarisIceSpearSingle().Destroy();

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spear_Single_Fire_Delay_1');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spear_Single_Fire_Delay_2');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spear_Single_Fire_Delay_3');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Summon_Golem_Delay');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Meteorite_Storm_Delay');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spike_Delay_1');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spike_Delay_2');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spike_Delay_3');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spear_Summon_Delay');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Line_Single_Fire_Delay_1');

	GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Line_Single_Fire_Delay_2');
}

function ACS_CanarisManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance, fireballChance, firelineChance, fireballDistance, firelineDistance, flameOnChance					: float;
	var caranthir_attack_anim_names, caranthir_taunt_names																	: array< name >;
	var playerRot 																											: EulerAngles;
	var spawnPos, newSpawnPos																								: Vector;
	var animName																											: name;

	if (!GetACSCanaris() || !GetACSCanaris().IsAlive())
	{
		return;
	}

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSCanaris()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = GetACSCanaris().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( GetACSCanaris().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (GetACSCanaris()
	&& GetACSCanaris().IsAlive()
	&& ACS_CanarisBuffCheck())
	{
		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Canaris_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Canaris_Rotate' );
		movementAdjustorNPC.CancelAll();

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Canaris_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		movementAdjustorNPC.RotateTowards( ticketNPC, thePlayer );

		if ( targetDistance < 1.125 * 1.125 )
		{
			if (ACS_canaris_teleport()
			)
			{
				ACS_refresh_canaris_teleport_cooldown();

				ACSCanaris_RemoveTimers();

				caranthir_attack_anim_names.Clear();

				caranthir_attack_anim_names.PushBack('attack_front_03');
				caranthir_attack_anim_names.PushBack('attack_front_02');
				caranthir_attack_anim_names.PushBack('attack_fast_03');
				caranthir_attack_anim_names.PushBack('attack_fast_01');

				if( GetACSCanaris().IsAlive()) {GetACSCanaris().ClearAnimationSpeedMultipliers();}	

				GetACSCanaris().SetAnimationSpeedMultiplier( 1.5  );
																	
				GetACSWatcher().RemoveTimer('ACS_Caranthir_ResetAnimation'); 
				GetACSWatcher().AddTimer('ACS_Caranthir_ResetAnimation', 0.5  , false);

				animatedComponentA.PlaySlotAnimationAsync ( caranthir_attack_anim_names[RandRange(caranthir_attack_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));

				GetACSCanaris().DestroyEffect('teleport_short');
				GetACSCanaris().PlayEffectSingle('teleport_short');
				GetACSCanaris().StopEffect('teleport_short');

				GetACSCanaris().DestroyEffect('ice_armor');
				GetACSCanaris().PlayEffectSingle('ice_armor');

				GetACSWatcher().ACS_Caranthir_Teleport_FX();

				if (RandF() < 0.125)
				{
					spawnPos = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() * -15;
				}
				else
				{
					spawnPos = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() * -3;
				}

				if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
				{
					theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
					spawnPos = newSpawnPos;
				}

				GetACSCanaris().Teleport(ACSPlayerFixZAxis(spawnPos));
			}
			else if (ACS_canaris_melee()
			)
			{
				ACS_refresh_canaris_melee_cooldown();

				ACSCanaris_RemoveTimers();

				caranthir_attack_anim_names.Clear();

				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_04_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_05_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_special_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_01_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_02_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_03_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_03_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_03_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_special_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_special_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_special_03_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_special_04_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_01_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_02_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_03_rp');
				caranthir_attack_anim_names.PushBack('attack_front_03');
				caranthir_attack_anim_names.PushBack('attack_front_02');
				caranthir_attack_anim_names.PushBack('attack_fast_03');
				caranthir_attack_anim_names.PushBack('attack_fast_01');

				if( GetACSCanaris().IsAlive()) {GetACSCanaris().ClearAnimationSpeedMultipliers();}	

				GetACSCanaris().SetAnimationSpeedMultiplier( 1.5  );
																	
				GetACSWatcher().RemoveTimer('ACS_Caranthir_ResetAnimation'); 
				GetACSWatcher().AddTimer('ACS_Caranthir_ResetAnimation', 0.5  , false);

				animatedComponentA.PlaySlotAnimationAsync ( caranthir_attack_anim_names[RandRange(caranthir_attack_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
			}
		}
		else if ( targetDistance >= 1.125 * 1.125 && targetDistance < 5 * 5 )
		{
			if (ACS_canaris_melee()
			)
			{
				ACS_refresh_canaris_melee_cooldown();

				ACSCanaris_RemoveTimers();

				caranthir_attack_anim_names.Clear();

				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_04_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_05_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhalberd_attack_special_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_01_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_02_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_03_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2hhammer_attack_03_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_03_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_special_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_special_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_special_03_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2hspear_attack_special_04_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_01_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_01_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_02_lp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_02_rp');
				caranthir_attack_anim_names.PushBack('man_npc_2haxe_attack_03_rp');
				caranthir_attack_anim_names.PushBack('attack_front_03');
				caranthir_attack_anim_names.PushBack('attack_front_02');
				caranthir_attack_anim_names.PushBack('attack_fast_03');
				caranthir_attack_anim_names.PushBack('attack_fast_01');

				if( GetACSCanaris().IsAlive()) {GetACSCanaris().ClearAnimationSpeedMultipliers();}	

				GetACSCanaris().SetAnimationSpeedMultiplier( 1.5  );
																	
				GetACSWatcher().RemoveTimer('ACS_Caranthir_ResetAnimation'); 
				GetACSWatcher().AddTimer('ACS_Caranthir_ResetAnimation', 0.5  , false);

				animatedComponentA.PlaySlotAnimationAsync ( caranthir_attack_anim_names[RandRange(caranthir_attack_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
			}
		}
		else if ( targetDistance >= 5 * 5 && targetDistance < 20 * 20 && ACS_CanarisBuffCheck())
		{
			if (ACS_canaris_abilities()
			)
			{
				ACS_refresh_canaris_abilities_cooldown();

				if( GetACSCanaris().IsAlive()) {GetACSCanaris().ClearAnimationSpeedMultipliers();}	

				GetACSCanaris().SetAnimationSpeedMultiplier( 2  );
																	
				GetACSWatcher().RemoveTimer('ACS_Caranthir_ResetAnimation'); 
				GetACSWatcher().AddTimer('ACS_Caranthir_ResetAnimation', 0.5  , false);

				GetACSWatcher().CaranthirMagicAttacks();
			}
		}
		else if ( targetDistance >= 20 * 20 )
		{
			if (ACS_canaris_teleport()
			)
			{
				ACS_refresh_canaris_teleport_cooldown();

				ACSCanaris_RemoveTimers();

				if( GetACSCanaris().IsAlive()) {GetACSCanaris().ClearAnimationSpeedMultipliers();}	

				animatedComponentA.PlaySlotAnimationAsync ( 'strong_blink_land', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));

				GetACSCanaris().DestroyEffect('teleport_short');
				GetACSCanaris().PlayEffectSingle('teleport_short');
				GetACSCanaris().StopEffect('teleport_short');

				GetACSCanaris().DestroyEffect('ice_armor');
				GetACSCanaris().PlayEffectSingle('ice_armor');

				GetACSWatcher().ACS_Caranthir_Teleport_FX();

				spawnPos = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() * -3;

				if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
				{
					theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
					spawnPos = newSpawnPos;
				}

				GetACSCanaris().Teleport(ACSPlayerFixZAxis(spawnPos));

				/*
				if( !GetACSCanaris().HasTag('ACS_Summoned_Rats') )
				{
					GetACSCanaris().AddTag('ACS_Summoned_Rats');

					animatedComponentA.PlaySlotAnimationAsync ( 'weak_spell_hand_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					GetACSWatcher().AddTimer('RatMageSummonRats', 1, false);
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'spell_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					GetACSWatcher().AddTimer('RatMageProjectile', 1, false);

					GetACSRatMage().RemoveTag('ACS_Summoned_Rats');
				}
				*/
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Caranthir_Abilities
{
    function ACS_Caranthir_Ice_Spear_Summon_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Ice_Spear_Summon_Engage');
	}

	function ACS_Caranthir_Ice_Spear_Fire_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Ice_Spear_Fire_Engage');
	}

	function ACS_Caranthir_Meteorite_Storm_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Meteorite_Storm_Engage');
	}

	function ACS_Caranthir_Ice_Spike_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Ice_Spike_Engage');
	}

	function ACS_Caranthir_Summon_Minion_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Summon_Minion_Engage');
	}

	function ACS_Caranthir_Minion_Prep_Ice_Line_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Minion_Prep_Ice_Line_Engage');
	}

	function ACS_Caranthir_Summon_Golem_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Summon_Golem_Engage');
	}

	function ACS_Caranthir_Ice_Spear_Single_Summon_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Ice_Spear_Single_Summon_Engage');
	}

	function ACS_Caranthir_Ice_Spear_Single_Fire_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Ice_Spear_Single_Fire_Engage');
	}

	function ACS_Caranthir_Ice_Line_Single_Fire_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Ice_Line_Single_Fire_Engage');
	}

	function ACS_Caranthir_Teleport_FX_Engage()
	{
		GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
		GetACSCanarisMeleeEffect().StopEffect('explode');

		this.PushState('ACS_Caranthir_Teleport_FX_Engage');
	}

	function ACS_Caranthir_Summon_Engage()
	{
		this.PushState('ACS_Caranthir_Summon_Engage');
	}

	function ACS_Caranthir_Weapon_FX_Engage()
	{
		this.PushState('ACS_Caranthir_Weapon_FX_Engage');
	}
}

state ACS_Caranthir_Summon_Engage in cACS_Caranthir_Abilities
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, portalEntity, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var blade_temp_ent													: CItemEntity;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Caranthir_Summon();
	}
	
	entry function Caranthir_Summon()
	{
		Caranthir_Summon_Latent();
	}
	
	latent function Caranthir_Summon_Latent()
	{
		GetACSCanaris().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\canaris.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;


		portalEntity = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
			
		, true ), ACSPlayerFixZAxis(playerPos), adjustedRot );

		portalEntity.PlayEffectSingle('teleport_fx');

		portalEntity.DestroyAfter(3);








		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		((CNewNPC)ent).SetCanPlayHitAnim(false); 

		((CNewNPC)ent).SetVisibility(false);


		GetACSWatcher().AddTimer('ACS_Caranthir_Set_Visibility', 1, false);


		GetACSWatcher().AddTimer('ACS_Caranthir_Weapon_FX_Attach', 1, false);



		ent.AddTag( 'ACS_Canaris' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Weapon_FX_Engage in cACS_Caranthir_Abilities
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var blade_temp_ent													: CItemEntity;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Caranthir_Weapon_FX_Summon();
	}
	
	entry function Caranthir_Weapon_FX_Summon()
	{
		Caranthir_Weapon_FX_Summon_Latent();
	}
	
	latent function Caranthir_Weapon_FX_Summon_Latent()
	{
		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = EulerAngles(0,0,0);

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent_2 = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );

		ent_3 = GetACSCanaris().GetInventory().GetItemEntityUnsafe( GetACSCanaris().GetInventory().GetItemFromSlot( 'r_weapon' ) );

		ent_2.CreateAttachment( ent_3 , , Vector(0,0,1.7) );

		ent_2.PlayEffectSingle('fire_fx');
		ent_2.PlayEffectSingle('fire_fx');
		ent_2.PlayEffectSingle('fire_fx');

		ent_2.AddTag('ACS_Canaris_Melee_Effect');

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Ice_Spear_Summon_Engage in cACS_Caranthir_Abilities
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 																													: W3ACSIceSpearProjectile;
	private var initpos																																						: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear();
	}
	
	entry function Ice_Spear()
	{
		GetACSCanarisIceSpear_1().Destroy();
		GetACSCanarisIceSpear_2().Destroy();
		GetACSCanarisIceSpear_3().Destroy();
		GetACSCanarisIceSpear_4().Destroy();
		GetACSCanarisIceSpear_5().Destroy();

		Ice_Spear_1_Summon();

		//Sleep(0.5);

		Ice_Spear_2_Summon();

		//Sleep(0.5);

		Ice_Spear_3_Summon();

		//Sleep(0.5);

		Ice_Spear_4_Summon();

		//Sleep(0.5);

		Ice_Spear_5_Summon();
	}
	
	latent function Ice_Spear_1_Summon()
	{
		initpos = GetACSCanaris().GetWorldPosition();			
		initpos.Z += 5;
				
		proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
						
		proj_1.Init(GetACSCanaris());
		proj_1.PlayEffectSingle('fire_fx');
		proj_1.PlayEffectSingle('explode');

		proj_1.AddTag('ACS_Canaris_Ice_Spear_1');
	}

	latent function Ice_Spear_2_Summon()
	{
		initpos = GetACSCanaris().GetWorldPosition() + GetACSCanaris().GetWorldRight() * 1.5;			
		initpos.Z += 4;
				
		proj_2 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
						
		proj_2.Init(GetACSCanaris());
		proj_2.PlayEffectSingle('fire_fx');
		proj_2.PlayEffectSingle('explode');

		proj_2.AddTag('ACS_Canaris_Ice_Spear_2');
	}

	latent function Ice_Spear_3_Summon()
	{
		initpos = GetACSCanaris().GetWorldPosition() + GetACSCanaris().GetWorldRight() * -1.5;		
		initpos.Z += 4;
				
		proj_3 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
						
		proj_3.Init(GetACSCanaris());
		proj_3.PlayEffectSingle('fire_fx');
		proj_3.PlayEffectSingle('explode');

		proj_3.AddTag('ACS_Canaris_Ice_Spear_3');
	}

	latent function Ice_Spear_4_Summon()
	{
		initpos = GetACSCanaris().GetWorldPosition() + GetACSCanaris().GetWorldRight() * 3;		
		initpos.Z += 3;
				
		proj_4 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
						
		proj_4.Init(GetACSCanaris());
		proj_4.PlayEffectSingle('fire_fx');
		proj_4.PlayEffectSingle('explode');

		proj_4.AddTag('ACS_Canaris_Ice_Spear_4');
	}

	latent function Ice_Spear_5_Summon()
	{
		initpos = GetACSCanaris().GetWorldPosition() + GetACSCanaris().GetWorldRight() * -3;		
		initpos.Z += 3;
				
		proj_5 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
						
		proj_5.Init(GetACSCanaris());
		proj_5.PlayEffectSingle('fire_fx');
		proj_5.PlayEffectSingle('explode');

		proj_5.AddTag('ACS_Canaris_Ice_Spear_5');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Ice_Spear_Fire_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																																: Vector;

	event OnEnterState(prevStateName : name)
	{
		Ice_Spear_Fire_Entry();
	}
	
	entry function Ice_Spear_Fire_Entry()
	{
		Ice_Spear_Fire_Latent();
	}
	
	latent function Ice_Spear_Fire_Latent()
	{
		targetPosition = thePlayer.PredictWorldPosition(0.35f);

		targetPosition.Z += 1.1;

		GetACSCanarisIceSpear_1().PlayEffectSingle('fire_fx');
		//GetACSCanarisIceSpear_1().PlayEffectSingle('explode');
		GetACSCanarisIceSpear_1().ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPosition, 500 );

		//Sleep(0.5);

		GetACSCanarisIceSpear_2().PlayEffectSingle('fire_fx');
		//GetACSCanarisIceSpear_2().PlayEffectSingle('explode');
		GetACSCanarisIceSpear_2().ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPosition, 500 );

		//Sleep(0.5);

		GetACSCanarisIceSpear_3().PlayEffectSingle('fire_fx');
		//GetACSCanarisIceSpear_3().PlayEffectSingle('explode');
		GetACSCanarisIceSpear_3().ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPosition, 500 );

		//Sleep(0.5);

		GetACSCanarisIceSpear_4().PlayEffectSingle('fire_fx');
		//GetACSCanarisIceSpear_4().PlayEffectSingle('explode');
		GetACSCanarisIceSpear_4().ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPosition, 500 );

		//Sleep(0.5);

		GetACSCanarisIceSpear_5().PlayEffectSingle('fire_fx');
		//GetACSCanarisIceSpear_5().PlayEffectSingle('explode');
		GetACSCanarisIceSpear_5().ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPosition, 500 );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Meteorite_Storm_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																																: Vector;

	event OnEnterState(prevStateName : name)
	{
		Meteorite_Storm_Entry();
	}
	
	entry function Meteorite_Storm_Entry()
	{
		Meteorite_Storm_Latent();
	}
	
	latent function Meteorite_Storm_Latent()
	{
		var entity : CEntity;
		var meteoriteStorm : CACSCanarisMeteoriteStormEntity;
		var spawnPos : Vector;
		var rotation, adjustedRot : EulerAngles;
		
		spawnPos = GetWitcherPlayer().PredictWorldPosition(0.35f);
		rotation = GetWitcherPlayer().GetWorldRotation();

		entity = (CACSCanarisMeteoriteStormEntity)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\enemy_magic\caranthir_meteorite_storm.w2ent", true ), spawnPos, rotation );

		meteoriteStorm = (CACSCanarisMeteoriteStormEntity)entity;

		if( meteoriteStorm )
		{
			meteoriteStorm.Execute( GetWitcherPlayer() );
		}

		meteoriteStorm.DestroyAfter(6);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Ice_Spike_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																																: Vector;

	event OnEnterState(prevStateName : name)
	{
		Ice_Spike_Entry();
	}
	
	entry function Ice_Spike_Entry()
	{
		Ice_Spike_Latent();
	}
	
	latent function Ice_Spike_Latent()
	{
		var entity : CEntity;
		var iceSpike : W3ACSCaranthirIceSpike;
		var spawnPos : Vector;
		var rotation, adjustedRot : EulerAngles;
		
		spawnPos = GetWitcherPlayer().PredictWorldPosition(0.35f);

		spawnPos.Z += 1.1;

		rotation = GetWitcherPlayer().GetWorldRotation();

		rotation.Yaw = RandRangeF( 180.0, -180.0 );

		entity = (W3ACSCaranthirIceSpike)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\enemy_magic\caranthir_ice_spike.w2ent", true ), spawnPos, rotation );

		iceSpike = (W3ACSCaranthirIceSpike)entity;

		if( iceSpike )
		{
			iceSpike.Appear();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Summon_Minion_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																		: Vector;
	private var actors																				: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor 																				: CActor;
	private var ice_proj_1, ice_proj_2, ice_proj_3  												: W3WHMinionProjectile;
	private var initpos, targetPosition_1, targetPosition_2, targetPosition_3		: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ghoulAnimatedComponent 																: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		Summon_Minion_Entry();
	}
	
	entry function Summon_Minion_Entry()
	{
		if (GetACSCanarisMinion() && GetACSCanarisMinion().IsAlive())
		{
			Summon_Minion_Fire_Line();
		}
		else
		{
			Summon_Minion_Latent();
		}
	}
	
	latent function Summon_Minion_Latent()
	{
		var entity, portalEntity 											: CEntity;
		var spawnPos, initpos, portalpos 									: Vector;
		var rotation, adjustedRot 														: EulerAngles;
		var actor															: CActor; 
		var actors		    												: array<CActor>;
		var npc																: CNewNPC;
		var i, count, j														: int;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;

		GetACSCanarisMinion().Destroy();
		
		spawnPos = GetACSCanaris().GetWorldPosition() +  GetACSCanaris().GetWorldRight() * -3 + GetACSCanaris().GetWorldForward() * 3;

		rotation = GetACSCanaris().GetWorldRotation();

		portalEntity = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"fx\characters\canaris\canaris_groundrift.w2ent"
			
		, true ), ACSPlayerFixZAxis(spawnPos), rotation );

		portalEntity.PlayEffectSingle('ground_fx');

		portalEntity.DestroyAfter(3);

		entity = (CEntity)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "characters\npc_entities\monsters\wildhunt_minion_lvl2.w2ent", true ), ACSPlayerFixZAxis(spawnPos), rotation );

		animcomp = (CAnimatedComponent)entity.GetComponentByClassName('CAnimatedComponent');
		meshcomp = entity.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)entity).SetLevel(thePlayer.GetLevel());

		((CNewNPC)entity).SetAttitude(thePlayer, AIA_Hostile);

		((CActor)entity).SetAnimationSpeedMultiplier(1);

		((CActor)entity).AddTag( 'ContractTarget' );

		((CActor)entity).AddAbility('BounceBoltsWildhunt');

		((CActor)entity).AddTag('IsBoss');

		((CActor)entity).AddAbility('Boss');

		entity.AddTag('NoBestiaryEntry');

		entity.AddTag( 'ACS_Canaris_Minion' );

		actors.Clear();

		actors = ((CActor)entity).GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer);
		{
			if( actors.Size() > 0 )
			{
				for( j = 0; j < actors.Size(); j += 1 )
				{
					npc = (CNewNPC)actors[j];

					actor = actors[j];

					if (actor.HasTag('ACS_Canaris')
					|| actor.HasTag('ACS_Canaris_Golem')
					)
					{
						((CNewNPC)entity).SetAttitude(actor, AIA_Friendly);

						actor.SetAttitude(((CActor)entity), AIA_Friendly);
					}
					else
					{
						((CNewNPC)entity).SetAttitude(actor, AIA_Hostile);

						actor.SetAttitude(((CActor)entity), AIA_Hostile);
					}
				}
			}
		}
	}

	latent function Summon_Minion_Fire_Line()
	{
		GetACSCanarisMinion().SetImmortalityMode( AIM_None, AIC_Combat ); 
		GetACSCanarisMinion().SetCanPlayHitAnim(true); 
		GetACSCanarisMinion().RemoveBuffImmunity_AllNegative('acs_ghoul_immune'); 

		GetACSCanarisMinion().RemoveTag('ACS_Ghoul_Venom_Init');

		GetACSCanarisMinion().PlayEffectSingle('morph_fx');
		GetACSCanarisMinion().StopEffect('morph_fx');

		GetACSCanarisMinion().SoundEvent('monster_ghoul_morph_loop_stop');

		ghoulAnimatedComponent = (CAnimatedComponent)GetACSCanarisMinion().GetComponentByClassName( 'CAnimatedComponent' );	

		movementAdjustor = GetACSCanarisMinion().GetMovingAgentComponent().GetMovementAdjustor();

		ticket = movementAdjustor.GetRequest( 'ACS_Ghoul_Proj_Rotate_2');
		movementAdjustor.CancelByName( 'ACS_Ghoul_Proj_Rotate_2' );
		movementAdjustor.CancelAll();
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Ghoul_Proj_Rotate_2' );
		movementAdjustor.AdjustmentDuration( ticket, 1 );
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

		//ghoulAnimatedComponent.PlaySlotAnimationAsync ( 'rage', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

		//initpos = npc.GetWorldPosition() + npc.GetWorldForward() * 0.5 ;

		initpos = GetACSCanarisMinion().GetBoneWorldPosition('head');	

		initpos.Y += 0.5;
				
		targetPosition = GetWitcherPlayer().PredictWorldPosition(0.7f);
		targetPosition.Z += 0.5;

		targetPosition_1 = GetWitcherPlayer().PredictWorldPosition(0.1f);
		targetPosition_1.Z += 0.5;

		targetPosition_2 = GetWitcherPlayer().PredictWorldPosition(0.5f);
		targetPosition_2.Z += 0.5;

		targetPosition_3 = GetWitcherPlayer().PredictWorldPosition(1.0f);
		targetPosition_3.Z += 0.5;

		GetACSCanarisMinion().PlayEffectSingle('rift_fx_special');
		GetACSCanarisMinion().StopEffect('rift_fx_special');

		GetACSCanarisMinion().PlayEffectSingle('morph_fx_copy');
		GetACSCanarisMinion().StopEffect('morph_fx_copy');

		GetACSCanarisMinion().StopEffect('r_trail_snow');
		GetACSCanarisMinion().PlayEffectSingle('r_trail_snow');

		GetACSCanarisMinion().StopEffect('l_trail_snow');
		GetACSCanarisMinion().PlayEffectSingle('l_trail_snow');

		GetACSCanarisMinion().PlayEffectSingle('marker');
		GetACSCanarisMinion().StopEffect('marker');

		GetACSCanarisMinion().SoundEvent('monster_wildhunt_minion_ice_spike_out');
		GetWitcherPlayer().SoundEvent('monster_wildhunt_minion_ice_spike_out');

		ice_proj_1 = (W3WHMinionProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent"
			
			, true ), initpos );
						
		ice_proj_1.Init(GetACSCanarisMinion());
		ice_proj_1.PlayEffectSingle('fire_line');
		ice_proj_1.ShootProjectileAtPosition( 0, 10 + RandRangeF(10 , 5), targetPosition, 500 );
		ice_proj_1.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Minion_Prep_Ice_Line_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																		: Vector;
	private var actors																				: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor 																				: CActor;
	private var ice_proj_1, ice_proj_2, ice_proj_3  												: W3WHMinionProjectile;
	private var initpos, targetPosition_1, targetPosition_2, targetPosition_3		: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ghoulAnimatedComponent 																: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		Minion_Prep_Ice_Line_Entry();
	}
	
	entry function Minion_Prep_Ice_Line_Entry()
	{
		if (GetACSCanarisMinion() && GetACSCanarisMinion().IsAlive())
		{
			Minion_Prep_Ice_Line_Latent();
		}
	}
	
	latent function Minion_Prep_Ice_Line_Latent()
	{
		if ( !theSound.SoundIsBankLoaded("monster_toad.bnk") )
		{
			theSound.SoundLoadBank( "monster_toad.bnk", false );
		}

		if ( !theSound.SoundIsBankLoaded("monster_golem_ice.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ice.bnk", false );
		}

		if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
		}

		movementAdjustor = GetACSCanarisMinion().GetMovingAgentComponent().GetMovementAdjustor();

		ghoulAnimatedComponent = (CAnimatedComponent)GetACSCanarisMinion().GetComponentByClassName( 'CAnimatedComponent' );	

		ticket = movementAdjustor.GetRequest( 'ACS_Ghoul_Proj_Rotate_1');
		movementAdjustor.CancelByName( 'ACS_Ghoul_Proj_Rotate_1' );
		movementAdjustor.CancelAll();
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Ghoul_Proj_Rotate_1' );
		movementAdjustor.AdjustmentDuration( ticket, 1 );
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.RotateTowards( ticket, GetWitcherPlayer() );

		ghoulAnimatedComponent.PlaySlotAnimationAsync ( 'rage', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.5f));

		GetACSCanarisMinion().AddBuffImmunity(EET_Poison, 'ACS_Ghoul_Proj_Poison_Negate', true);

		GetACSCanarisMinion().AddBuffImmunity(EET_PoisonCritical , 'ACS_Ghoul_Proj_Poison_Negate', true);

		GetACSCanarisMinion().AddTag('ACS_Ghoul_Venom_Init');

		GetACSCanarisMinion().PlayEffectSingle('morph_fx');
		GetACSCanarisMinion().StopEffect('morph_fx');

		GetACSCanarisMinion().SoundEvent('monster_ghoul_morph_loop_stop');

		GetACSCanarisMinion().DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ) * 0.25, 4 );

		GetACSCanarisMinion().SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		GetACSCanarisMinion().SetCanPlayHitAnim(false); 
		GetACSCanarisMinion().AddBuffImmunity_AllNegative('acs_ghoul_immune', true); 
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Summon_Golem_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																		: Vector;
	private var actors																				: array<CActor>;
	private var i 																					: int;
	private var npc 																				: CNewNPC;
	private var actor 																				: CActor;
	private var ice_proj_1, ice_proj_2, ice_proj_3  												: W3WHMinionProjectile;
	private var initpos, targetPosition_1, targetPosition_2, targetPosition_3		: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ghoulAnimatedComponent 																: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		Summon_Golem_Entry();
	}
	
	entry function Summon_Golem_Entry()
	{
		if (GetACSCanarisGolem() && GetACSCanarisGolem().IsAlive())
		{
			Summon_Golem_Stomp();
		}
		else
		{
			Summon_Golem_Latent();
		}
	}
	
	latent function Summon_Golem_Latent()
	{
		var entity, portalEntity 											: CEntity;
		var spawnPos, initpos, portalpos 									: Vector;
		var rotation, adjustedRot 														: EulerAngles;
		var actor															: CActor; 
		var actors		    												: array<CActor>;
		var npc																: CNewNPC;
		var i, count, j														: int;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;

		GetACSCanarisGolem().Destroy();
		
		spawnPos = GetACSCanaris().GetWorldPosition() + GetACSCanaris().GetWorldRight() * 3 + GetACSCanaris().GetWorldForward() * 3;

		spawnPos.Z += 1.1;

		rotation = GetACSCanaris().GetWorldRotation();

		portalEntity = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"quests\part_1\quest_files\q203_him\entities\q203_ciri_portal.w2ent"
			
		, true ), spawnPos, EulerAngles(0,0,0) );

		portalEntity.PlayEffectSingle('teleport_fx');

		portalEntity.DestroyAfter(3);

		entity = (CEntity)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "characters\npc_entities\monsters\elemental_dao_lvl3__ice.w2ent", true ), ACSPlayerFixZAxis(spawnPos), rotation );

		animcomp = (CAnimatedComponent)entity.GetComponentByClassName('CAnimatedComponent');
		meshcomp = entity.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)entity).SetLevel(thePlayer.GetLevel());

		((CNewNPC)entity).SetAttitude(thePlayer, AIA_Hostile);

		((CActor)entity).SetAnimationSpeedMultiplier(1);

		((CActor)entity).AddTag( 'ContractTarget' );

		((CActor)entity).AddAbility('BounceBoltsWildhunt');

		((CActor)entity).AddTag('IsBoss');

		((CActor)entity).AddAbility('Boss');

		entity.AddTag( 'ACS_Canaris_Golem' );

		entity.AddTag('NoBestiaryEntry');

		actors.Clear();

		actors = ((CActor)entity).GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer);
		{
			if( actors.Size() > 0 )
			{
				for( j = 0; j < actors.Size(); j += 1 )
				{
					npc = (CNewNPC)actors[j];

					actor = actors[j];

					if (actor.HasTag('ACS_Canaris')
					|| actor.HasTag('ACS_Canaris_Minion')
					)
					{
						((CNewNPC)entity).SetAttitude(actor, AIA_Friendly);

						actor.SetAttitude(((CActor)entity), AIA_Friendly);
					}
					else
					{
						((CNewNPC)entity).SetAttitude(actor, AIA_Hostile);

						actor.SetAttitude(((CActor)entity), AIA_Hostile);
					}
				}
			}
		}
	}

	latent function Summon_Golem_Stomp()
	{
		var actor															: CActor; 
		var actors		    												: array<CActor>;
		var npc																: CNewNPC;
		var i, count, j														: int;
		var entity 															: CEntity;
		var golempos 														: Vector;
		
		GetACSCanarisGolem().DestroyEffect('attack_special');
		GetACSCanarisGolem().PlayEffectSingle('attack_special');
		GetACSCanarisGolem().StopEffect('attack_special');

		GetACSCanarisGolem().DestroyEffect('spawn');
		GetACSCanarisGolem().PlayEffectSingle('spawn');
		GetACSCanarisGolem().StopEffect('spawn');

		golempos = GetACSCanarisGolem().GetWorldPosition();

		golempos.Z += 1.5;

		entity = (CEntity)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\enemy_magic\caranthir_meteorite.w2ent", true ), golempos, GetACSCanarisGolem().GetWorldRotation() );

		entity.PlayEffectSingle('explosion');

		entity.DestroyAfter(5);

		GetACSWatcher().AddTimer('ACS_Caranthir_Golem_Kill_Delay', 0.5, false);

		actors.Clear();

		actors = GetACSCanarisGolem().GetNPCsAndPlayersInRange( 4, 20, , FLAG_OnlyAliveActors );
		{
			if( actors.Size() > 0 )
			{
				for( j = 0; j < actors.Size(); j += 1 )
				{
					npc = (CNewNPC)actors[j];

					actor = actors[j];

					if (!actor.HasTag('ACS_Canaris')
					&& !actor.HasTag('ACS_Canaris_Minion')
					)
					{
						actor.AddEffectDefault( EET_Knockdown, GetACSCanaris(), 'ACS_Canaris_Golem_Knockdown' );
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

state ACS_Caranthir_Ice_Spear_Single_Summon_Engage in cACS_Caranthir_Abilities
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 																													: W3ACSCaranthirIceMeteorProjectile;
	private var initpos																																						: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear_Single();
	}
	
	entry function Ice_Spear_Single()
	{
		GetACSCanarisIceSpearSingle().Destroy();

		Ice_Spear_Single_Summon();
	}
	
	latent function Ice_Spear_Single_Summon()
	{
		initpos = GetACSCanaris().GetWorldPosition();			
		initpos.Z += 5;
				
		proj_1 = (W3ACSCaranthirIceMeteorProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\enemy_magic\caranthir_meteorite.w2ent", true ), initpos );
						
		proj_1.Init(GetACSCanaris());
		proj_1.PlayEffectSingle('fire_fx');

		proj_1.AddTag('ACS_Canaris_Ice_Spear_Single');

		proj_1.CreateAttachment(GetACSCanaris(), 'l_weapon');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Ice_Spear_Single_Fire_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																																: Vector;
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 																													: W3ACSCaranthirIceMeteorProjectile;
	private var initpos																																						: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		Ice_Spear_Single_Fire_Entry();
	}
	
	entry function Ice_Spear_Single_Fire_Entry()
	{
		Ice_Spear_Single_Fire_Latent();
	}
	
	latent function Ice_Spear_Single_Fire_Latent()
	{
		targetPosition = thePlayer.PredictWorldPosition(0.35f);

		//targetPosition.Z += 1.1;

		initpos = GetACSCanaris().GetBoneWorldPosition('l_weapon');	

		//initpos.Y += 1.5;
				
		proj_1 = (W3ACSCaranthirIceMeteorProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\enemy_magic\caranthir_meteorite.w2ent", true ), initpos );
						
		proj_1.Init(GetACSCanaris());
		proj_1.PlayEffectSingle('fire_fx');

		proj_1.ShootProjectileAtPosition( 0, 15, targetPosition, 500 );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Teleport_FX_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																																: Vector;
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 																									: W3ACSIceSpearProjectile;
	private var initpos																																		: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		ACS_Caranthir_Teleport_FX_Entry();
	}
	
	entry function ACS_Caranthir_Teleport_FX_Entry()
	{
		ACS_Caranthir_Teleport_FX_Latent();
	}
	
	latent function ACS_Caranthir_Teleport_FX_Latent()
	{
		var entity 															: CEntity;
		var spawnPos, initpos, portalpos 									: Vector;
		var rotation, adjustedRot 														: EulerAngles;

		spawnPos = GetACSCanaris().GetWorldPosition();

		rotation = GetACSCanaris().GetWorldRotation();

		entity = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"fx\characters\eredin\eredin_teleport.w2ent"
			
		, true ), spawnPos, EulerAngles(0,0,0));

		entity.PlayEffectSingle('appear');
		entity.PlayEffectSingle('disappear');

		entity.DestroyAfter(3);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Caranthir_Ice_Line_Single_Fire_Engage in cACS_Caranthir_Abilities
{
	private var targetPosition																																: Vector;
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 																													: W3ACSEredinFrostLine;
	private var initpos																																						: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		Ice_Line_Single_Fire_Entry();
	}
	
	entry function Ice_Line_Single_Fire_Entry()
	{
		Ice_Line_Single_Fire_Latent();
	}
	
	latent function Ice_Line_Single_Fire_Latent()
	{
		targetPosition = thePlayer.PredictWorldPosition(0.35f);

		//targetPosition.Z += 1.1;

		initpos = GetACSCanaris().GetBoneWorldPosition('l_weapon');	

		//initpos.Y += 1.5;
				
		proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), initpos );
						
		proj_1.Init(GetACSCanaris());
		proj_1.PlayEffectSingle('fire_line');

		proj_1.ShootProjectileAtPosition( 0, 15, targetPosition, 500 );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSCanarisEquippedStaff() : CEntity
{
	var entity			: CEntity;
		
	entity = GetACSCanaris().GetInventory().GetItemEntityUnsafe( GetACSCanaris().GetInventory().GetItemFromSlot( 'r_weapon' ) );

	return entity;
}

function GetACSCanarisMeleeEffect() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Canaris_Melee_Effect' );
	return entity;
}

function ACS_Canaris_Fire_Attached_Ice_Spear()
{
	var targetPosition																																: Vector;

	targetPosition = thePlayer.PredictWorldPosition(0.35f);

	//targetPosition.Z += 1.1;
	
	GetACSCanarisIceSpearSingle().BreakAttachment();
	GetACSCanarisIceSpearSingle().ShootProjectileAtPosition( 0, 15, targetPosition, 500 );
}

function GetACSCanarisGolem() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Canaris_Golem' );
	return entity;
}

function GetACSCanarisMinion() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Canaris_Minion' );
	return entity;
}

function GetACSCanarisIceSpearSingle() : W3ACSCaranthirIceMeteorProjectile
{
	var entity 			 : W3ACSCaranthirIceMeteorProjectile;
	
	entity = (W3ACSCaranthirIceMeteorProjectile)theGame.GetEntityByTag( 'ACS_Canaris_Ice_Spear_Single' );
	return entity;
}

function GetACSCanarisIceSpear_1() : W3ACSIceSpearProjectile
{
	var entity 			 : W3ACSIceSpearProjectile;
	
	entity = (W3ACSIceSpearProjectile)theGame.GetEntityByTag( 'ACS_Canaris_Ice_Spear_1' );
	return entity;
}

function GetACSCanarisIceSpear_2() : W3ACSIceSpearProjectile
{
	var entity 			 : W3ACSIceSpearProjectile;
	
	entity = (W3ACSIceSpearProjectile)theGame.GetEntityByTag( 'ACS_Canaris_Ice_Spear_2' );
	return entity;
}

function GetACSCanarisIceSpear_3() : W3ACSIceSpearProjectile
{
	var entity 			 : W3ACSIceSpearProjectile;
	
	entity = (W3ACSIceSpearProjectile)theGame.GetEntityByTag( 'ACS_Canaris_Ice_Spear_3' );
	return entity;
}

function GetACSCanarisIceSpear_4() : W3ACSIceSpearProjectile
{
	var entity 			 : W3ACSIceSpearProjectile;
	
	entity = (W3ACSIceSpearProjectile)theGame.GetEntityByTag( 'ACS_Canaris_Ice_Spear_4' );
	return entity;
}

function GetACSCanarisIceSpear_5() : W3ACSIceSpearProjectile
{
	var entity 			 : W3ACSIceSpearProjectile;
	
	entity = (W3ACSIceSpearProjectile)theGame.GetEntityByTag( 'ACS_Canaris_Ice_Spear_5' );
	return entity;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSFireGargoyle() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Fire_Gargoyle' );
	return entity;
}

function ACS_FireGargoyleManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;

	if (!GetACSFireGargoyle() || !GetACSFireGargoyle().IsAlive())
	{
		return;
	}

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSFireGargoyle()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = GetACSFireGargoyle().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( GetACSFireGargoyle().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (GetACSFireGargoyle()
	&& GetACSFireGargoyle().IsAlive()
	&& GetACSFireGargoyle().IsInCombat())
	{
		GetACSFireGargoyle().DisableLookAt();

		if (ACS_fire_gargoyle_abilities()
		)
		{
			ACS_refresh_fire_gargoyle_abilities_cooldown();

			ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Gargoyle_Abilities_Rotate');
			movementAdjustorNPC.CancelByName( 'ACS_Fire_Gargoyle_Abilities_Rotate' );

			ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Gargoyle_Abilities_Rotate' );
			movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
			movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

			movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

			if(!GetACSFireGargoyle().HasTag('ACS_Gargoyle_Jump'))
			{
				if(RandF() < 0.5)
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'taunt_2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'taunt_3', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
				}

				GetACSWatcher().AddTimer('FireGargoyleFireballDelay', 1, false);

				GetACSFireGargoyle().AddTag('ACS_Gargoyle_Jump');
			}
			else
			{
				GetACSFireGargoyle().RemoveTag('ACS_Gargoyle_Jump');

				animatedComponentA.PlaySlotAnimationAsync ( 'jump_out', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));

				GetACSWatcher().AddTimer('FireGargoyleJumpInDelay', 0.5, false);
			}
		}
	}
}

function ACS_FireGargoyleFireball()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var dist																												: float;
	var collisionGroups 																									: array<name>;
	var meteorEntityTemplate 																								: CEntityTemplate;
	var userPosition 																										: Vector;
	var meteorPosition 																										: Vector;
	var userRotation, adjustedRot 																										: EulerAngles;
	var meteorEntity 																										: W3FireballProjectile;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSFireGargoyle()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = GetACSFireGargoyle().GetMovingAgentComponent().GetMovementAdjustor();

	if (GetACSFireGargoyle()
	&& GetACSFireGargoyle().IsAlive()
	&& GetACSFireGargoyle().IsInCombat())
	{
		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Gargoyle_Abilities_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Fire_Gargoyle_Abilities_Rotate' );

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Gargoyle_Abilities_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		GetACSFireGargoyle().SoundEvent("monster_golem_dao_cmb_swoosh_light");

		collisionGroups.Clear();
		collisionGroups.PushBack('Terrain');
		collisionGroups.PushBack('Static');

		meteorEntityTemplate = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\entities\projectiles\bear_fireball_proj_2.w2ent"
		
		, true );

		userPosition = GetWitcherPlayer().PredictWorldPosition(0.35f);

		userPosition.Z += 0.75;

		userRotation = GetACSFireGargoyle().GetWorldRotation();

		meteorPosition = GetACSFireGargoyle().GetWorldPosition() + GetACSFireGargoyle().GetWorldForward() * 1.25;
		meteorPosition.Z += 2;


		meteorEntity = (W3FireballProjectile)theGame.CreateEntity(meteorEntityTemplate, meteorPosition, userRotation);
		meteorEntity.Init(GetACSFireGargoyle());
		meteorEntity.PlayEffectSingle('fire_fx');
		meteorEntity.PlayEffectSingle('explosion');
		//meteorEntity.decreasePlayerDmgBy = 0.75;
		meteorEntity.ShootProjectileAtPosition( meteorEntity.projAngle, meteorEntity.projSpeed * 1.5, userPosition, 500, collisionGroups );
	}
}

function ACS_FireGargoyleJumpIn()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var dist																												: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)GetACSFireGargoyle()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = GetACSFireGargoyle().GetMovingAgentComponent().GetMovementAdjustor();

	if (GetACSFireGargoyle()
	&& GetACSFireGargoyle().IsAlive()
	&& GetACSFireGargoyle().IsInCombat())
	{
		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Fire_Gargoyle_Abilities_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Fire_Gargoyle_Abilities_Rotate' );

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Fire_Gargoyle_Abilities_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

		dist = (((CMovingPhysicalAgentComponent)GetACSFireGargoyle().GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius())/2;

		movementAdjustorNPC.SlideTowards( ticketNPC, GetWitcherPlayer(), dist, dist );

		animatedComponentA.PlaySlotAnimationAsync ( 'jump_in', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSLynxWitcherInCombatCheck()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;
	var dmg												: W3DamageAction;
	

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Lynx_Witcher', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (!actors[i].IsAlive())
		{
			return;
		}

		targetDistance = VecDistanceSquared2D( ((CActor)actors[i]).GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		animatedComponentA = (CAnimatedComponent)(((CActor)actors[i])).GetComponentByClassName( 'CAnimatedComponent' );	

		((CActor)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		if (!actors[i].IsInCombat())
		{
			animatedComponentA.PlaySlotAnimationAsync ( 'meditation_idle01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
		}

		if (targetDistance <= 10 * 10 && GetWitcherPlayer().IsOnGround())
		{
			if (!actors[i].HasTag('ACS_Lynx_Witcher_Combat'))
			{
				dmg = new W3DamageAction in theGame.damageMgr;
					
				dmg.Initialize(GetWitcherPlayer(), ((CActor)actors[i]), NULL, GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);

				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;	

				animatedComponentA.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

				actors[i].PlayEffectSingle('shadowdash');
				actors[i].StopEffect('shadowdash');

				actors[i].SoundEvent("bomb_dragons_dream_explo");

				ACS_LynxWitcherSmokeScreen(actors[i], actors[i].GetWorldPosition());

				actors[i].AddTag('ACS_Lynx_Witcher_Combat');
			}
		}

		if (actors[i].HasTag('ACS_Lynx_Witcher_Stealth'))
		{
			((CActor)actors[i]).SetTatgetableByPlayer(false);
		}
		else
		{
			((CActor)actors[i]).SetTatgetableByPlayer(true);
		}
	}
}

function ACSLynxWitcherRemoveStealth()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Lynx_Witcher', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (actors[i].HasTag('ACS_Lynx_Witcher_Stealth'))
		{
			actors[i].RemoveTag('ACS_Lynx_Witcher_Stealth');

			actors[i].StopEffect('shadowdash');
		}
	}
}

function ACS_LynxWitcherSmokeScreen( npc : CActor, pos : Vector )
{
	var ent       														: CEntity;
	var rot, attach_rot, adjustedRot                        						 	: EulerAngles;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;

	rot = EulerAngles(0,0,0);

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	//"dlc\dlc_acs\data\fx\dettlaff_swarm_tornado.w2ent"

	"fx\quest\q501\navalbattle\q501_fog_to_hide_spawn.w2ent"

	, true ), ACSPlayerFixZAxis(pos), rot );

	ent.DestroyAfter(120);

	//ent.CreateAttachment(npc);

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 2, 2, 0.25, 1 ));

	meshcomp.SetScale(Vector( 2, 2, 0.25, 1 ));	

	ent.PlayEffectSingle('fog');
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSShadowWolf() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Shadow_Wolf' );
	return entity;
}

function ACSShadowWolfRotate()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;
	var movementAdjustor								: CMovementAdjustor;
	var ticket 											: SMovementAdjustmentRequestTicket;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Shadow_Wolf', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (actors[i].IsAlive())
		{
			targetDistance = VecDistanceSquared2D( ((CActor)actors[i]).GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

			if (targetDistance <= 5 * 5 && GetWitcherPlayer().IsOnGround())
			{
				actors[i].GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - actors[i].GetWorldPosition()));

				//actors[j].SetBehaviorVariable( 'direction', VecHeading(thePlayer.GetWorldPosition() - actors[j].GetWorldPosition()) );

				movementAdjustor = actors[i].GetMovingAgentComponent().GetMovementAdjustor();

				ticket = movementAdjustor.GetRequest( 'ACS_Shadow_Wolf_Rotate');
				movementAdjustor.CancelByName( 'ACS_Shadow_Wolf_Rotate' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Shadow_Wolf_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

				movementAdjustor.RotateTowards(ticket, thePlayer);
			}
		}
	}
}

function ACSShadowWolfDestroy()
{	
	var actors 											: array<CActor>;
	var i												: int;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Shadow_Wolf', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function ACS_ShadowWolfSpawn( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var playerRot, adjustedRot											: EulerAngles;

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\shadow_wolf_new.w2ent"
		
	, true );

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	adjustedRot = EulerAngles(0,0,0);

	adjustedRot.Yaw = playerRot.Yaw;
	
	count = 1;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + pos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
		spawnPos.Z = pos.Z;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(pos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.25;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(npc.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.5);

		ent.PlayEffectSingle('appear');
		ent.StopEffect('appear');
		ent.PlayEffectSingle('shadow_form');
		ent.PlayEffectSingle('demonic_possession');
		ent.PlayEffectSingle('shadow_form_2');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Shadow_Wolf_Buff', true);

		ent.AddTag( 'ACS_Shadow_Wolf' );
	}
}

function ACS_FluffyShadowWolfSpawn( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var playerRot, adjustedRot											: EulerAngles;
	var ticket															: SMovementAdjustmentRequestTicket;	
	var p_comp															: CComponent;
	var movementAdjustor												: CMovementAdjustor;

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\shadow_wolf_new.w2ent"
		
	, true );

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	adjustedRot = EulerAngles(0,0,0);

	adjustedRot.Yaw = playerRot.Yaw;
	
	count = 7;
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 5 + 5 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + pos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
		spawnPos.Z = pos.Z;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(pos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(npc.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffectSingle('appear');
		ent.StopEffect('appear');
		ent.PlayEffectSingle('shadow_form');
		ent.PlayEffectSingle('demonic_possession');
		ent.PlayEffectSingle('shadow_form_2');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Shadow_Wolf_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Shadow_Wolf_Buff', true);


		movementAdjustor = ((CActor)ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticket = movementAdjustor.GetRequest( 'ACS_Shadow_Wolf_Rotate');
		movementAdjustor.CancelByName( 'ACS_Shadow_Wolf_Rotate' );
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACS_Shadow_Wolf_Rotate' );
		movementAdjustor.AdjustmentDuration( ticket, 0.00001 );
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );
		movementAdjustor.Continuous(ticket);

		movementAdjustor.RotateTowards(ticket, GetWitcherPlayer());

		ent.AddTag( 'ACS_Fluffy_Shadow_Wolf' );
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_FluffyManager()
{
	var actors 																												: array<CActor>;
	var i, j																												: int;
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;

	var npc, actortarget																									: CActor;
	var victims			 																									: array<CActor>;

	var movementAdjustor																									: CMovementAdjustor;
	var ticket 																												: SMovementAdjustmentRequestTicket;
	var AnimatedComponent 																									: CAnimatedComponent;
	var params 																												: SCustomEffectParams;

	var action : W3DamageAction;

	var fluffy_attack_anim_names	: array<name>;

	if (!GetACSFluffy() || !GetACSFluffy().IsAlive())
	{
		return;
	}

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Fluffy', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		animatedComponentA = (CAnimatedComponent)((CNewNPC)actors[i]).GetComponentByClassName( 'CAnimatedComponent' );	

		movementAdjustorNPC = actors[i].GetMovingAgentComponent().GetMovementAdjustor();

		targetDistance = VecDistanceSquared2D( actors[i].GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

		if (actors[i]
		&& actors[i].IsAlive()
		&& actors[i].IsInCombat())
		{
			if (ACS_fluffy_ability()
			)
			{
				ACS_refresh_fluffy_ability_cooldown();

				victims.Clear();

				victims = actors[i].GetNPCsAndPlayersInCone(4, VecHeading(actors[i].GetHeadingVector()), 270, 20, , FLAG_OnlyAliveActors );

				if (actors[i].IsAlive())
				{
					if( victims.Size() > 0)
					{
						for( j = 0; j < victims.Size(); j += 1 )
						{
							actortarget = (CActor)victims[j];

							if (actortarget == GetWitcherPlayer())
							{
								ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_fluffy_Abilities_Rotate');
								movementAdjustorNPC.CancelByName( 'ACS_fluffy_Abilities_Rotate' );

								ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_fluffy_Abilities_Rotate' );
								movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.5 );
								movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

								movementAdjustorNPC.RotateTowards( ticketNPC, actortarget );

								fluffy_attack_anim_names.Clear();

								fluffy_attack_anim_names.PushBack('wolf_attack_bite');
								fluffy_attack_anim_names.PushBack('wolf_attack_closer');
								fluffy_attack_anim_names.PushBack('wolf_attack_closer_from_run');
								fluffy_attack_anim_names.PushBack('wolf_attack_closer_from_run02');
								fluffy_attack_anim_names.PushBack('wolf_attack_bite02');
								fluffy_attack_anim_names.PushBack('wolf_attack_closer_from_run_01');
								fluffy_attack_anim_names.PushBack('wolf_attack_jump_back_left');
								fluffy_attack_anim_names.PushBack('wolf_attack_jump_back_right');
								fluffy_attack_anim_names.PushBack('wolf_attack_jump_back_left_low');
								fluffy_attack_anim_names.PushBack('wolf_attack_jump_back_right_low');

								animatedComponentA.PlaySlotAnimationAsync ( fluffy_attack_anim_names[RandRange(fluffy_attack_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.75f));

								actors[i].PlayEffectSingle('fire_breath');
								actors[i].StopEffect('fire_breath');

								if 
								(
									GetWitcherPlayer().IsInGuardedState()
									|| GetWitcherPlayer().IsGuarded()
								)
								{
									GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
									GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
								}
								else if 
								(
									GetWitcherPlayer().IsAnyQuenActive()
								)
								{
									GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');
									GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
									GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');
									GetWitcherPlayer().StopEffect('lasting_shield_discharge');
								}
								else if 
								(
									GetWitcherPlayer().IsCurrentlyDodging()
								)
								{
									GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');
									GetWitcherPlayer().StopEffect('lasting_shield_discharge');
								}
								else
								{
									action = new W3DamageAction in theGame.damageMgr;
									action.Initialize( actors[i], (CActor)victims[j], theGame, 'ACS_Fluffy_Fire', EHRT_Light, CPS_Undefined, false, false, true, false);

									action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, 50 + victims[j].GetStat(BCS_Vitality) * 0.25 );

									action.AddDamage(theGame.params.DAMAGE_NAME_ELEMENTAL, 50 + victims[j].GetStat(BCS_Essence) * 0.25 );

									action.SetCanPlayHitParticle(false);
									
									theGame.damageMgr.ProcessAction( action );
									delete action;
								}

								actortarget.AddEffectDefault( EET_Burning, actors[i], 'ACS_Fluffy_Effect' );
							}
						}
					}
				}
			}
		}
	}
}

function GetACSFluffy() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Fluffy' );
	return entity;
}

function GetACSFluffyIdleAction()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Fluffy', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		if (
			!actors[i].HasTag('ACS_Fluffy_In_Combat')
			&& actors[i].IsAlive()
		)
		{
			animatedComponentA = (CAnimatedComponent)((CNewNPC)actors[i]).GetComponentByClassName( 'CAnimatedComponent' );	
			
			if(RandF() < 0.5)
			{
				if(RandF() < 0.5)
				{
					if(RandF() < 0.5)
					{
						actors[i].SoundEvent("animals_wolf_howl");

						actors[i].SoundEvent("monster_wild_dog_howl");

						actors[i].SoundEvent("monster_barghest_voice_howl");

						animatedComponentA.PlaySlotAnimationAsync ( 'barghest_attack_spitting_fire', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.85f, 0.85f));
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'wolf_cleaning_itself_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.85f, 0.85f));

						actors[i].DestroyEffect('fire_breath');
						actors[i].PlayEffectSingle('fire_breath');
						actors[i].StopEffect('fire_breath');
					}
				}
				else
				{
					if(RandF() < 0.5)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'wolf_rolling', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.85f, 0.85f));

						actors[i].SoundEvent("animals_wolf_howl");

						actors[i].SoundEvent("monster_wild_dog_howl");

						actors[i].DestroyEffect('fire_breath');
						actors[i].PlayEffectSingle('fire_breath');
						actors[i].StopEffect('fire_breath');
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'wolf_howling_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.85f, 0.85f));

						actors[i].SoundEvent("animals_wolf_howl");

						actors[i].SoundEvent("monster_wild_dog_howl");

						actors[i].DestroyEffect('fire_breath');
						actors[i].PlayEffectSingle('fire_breath');
						actors[i].StopEffect('fire_breath');
					}
				}
			}
			else
			{
				if(RandF() < 0.5)
				{
					if(RandF() < 0.5)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'wolf_walk_turn_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.85f, 0.85f));
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'wolf_walk_turn_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.85f, 0.85f));
					}
				}
				else
				{
					if(RandF() < 0.5)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'wolf_eating_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.85f, 0.85f));

						actors[i].DestroyEffect('fire_breath');
						actors[i].PlayEffectSingle('fire_breath');
						actors[i].StopEffect('fire_breath');
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'wolf_sleeping_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.85f, 0.85f));
					}
				}
			}
		}
	}
}

function ACS_FluffyFriendlyWolves()
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var i								: int;
	var npc								: CNewNPC;

	actors.Clear();

	actors = GetACSFluffy().GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			if (actor.HasAbility('mon_wolf_base')
			|| actor.HasAbility('mon_barghest_base')
			)
			{
				((CNewNPC)actor).SetAttitude(GetACSFluffy(), AIA_Friendly);

				GetACSFluffy().SetAttitude(((CNewNPC)actor), AIA_Friendly);
			}
		}
	}
}

function GetACSFluffyInCombatCheck()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Fluffy', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (!actors[i].IsAlive())
		{
			return;
		}

		if (
			actors[i].IsInCombat()
		)
		{
			if (!actors[i].HasTag('ACS_Fluffy_In_Combat'))
			{
				actors[i].AddTag('ACS_Fluffy_In_Combat');
			}
		}
		else
		{
			if (actors[i].HasTag('ACS_Fluffy_In_Combat'))
			{
				actors[i].RemoveTag('ACS_Fluffy_In_Combat');
			}
		}
	}
}

function GetACSFluffyKillAdds()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Fluffy_Shadow_Wolf', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Kill('ACS_Fluffy_Death', true);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Fog_Assassin_Spawner
{
	function Fog_Assassin_Doppleganger_Spawner_Engage()
	{
		this.PushState('Fog_Assassin_Doppleganger_Spawner_Engage');
	}
}

state Fog_Assassin_Doppleganger_Spawner_Engage in cACS_Fog_Assassin_Spawner
{
	var temp, temp_2, temp_3, ent_1_temp								: CEntityTemplate;
	var ent, ent_2, ent_3, l_anchor										: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot							: EulerAngles;	
	var targetDistance													: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Fog_Assassin_Doppleganger_Spawn_Entry();
	}
	
	entry function Fog_Assassin_Doppleganger_Spawn_Entry()
	{
		Fog_Assassin_Doppleganger_Spawn_Latent();
	}
	
	latent function Fog_Assassin_Doppleganger_Spawn_Latent()
	{
		ACS_FogAssassinSmokeScreen(GetACSFogAssassin(), GetACSFogAssassin().GetWorldPosition());

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\fogling_lvl1__doppelganger.w2ent"
			
		, true );

		playerPos = GetACSFogAssassin().GetWorldPosition();

		playerRot = GetACSFogAssassin().GetWorldRotation();
		
		count = 3;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.125;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(GetACSFogAssassin().GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetAttitude(GetACSFogAssassin(), AIA_Friendly);

			GetACSFogAssassin().SetAttitude(((CNewNPC)ent), AIA_Friendly);

			((CActor)ent).SetAnimationSpeedMultiplier(1.25);

			((CActor)ent).SetCanPlayHitAnim(false);

			((CActor)ent).EnableCharacterCollisions(true);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

			ent.AddTag('NoBestiaryEntry');

			ent.PlayEffectSingle('mist_form');

			ent.PlayEffectSingle('disappear_fog');

			ent.PlayEffectSingle('appear_fog');

			ent.PlayEffectSingle('light_and_fog');

			ent.AddTag( 'ACS_Fog_Assassin_Doppleganger' );

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			ACS_FogAssassinSmokeScreen(((CActor)ent), ((CActor)ent).GetWorldPosition());
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSFogAssassin() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Fog_Assassin' );
	return entity;
}

function ACS_FogAssassinManager()
{
	var targetDistance													: float;

	if (!GetACSFogAssassin() || !GetACSFogAssassin().IsAlive())
	{
		return;
	}

	targetDistance = VecDistanceSquared2D( GetACSFogAssassin().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (
	GetACSFogAssassin().IsAlive() 
	&& GetACSFogAssassin().IsInCombat()
	&& GetACSFogAssassin().IsEffectActive('disappear_fog')
	&& ACS_can_spawn_fogling()
	&& targetDistance <= 10
	)
	{
		ACS_refresh_fogling_cooldown();

		GetACSWatcher().ACS_Fog_Assassin_Doppleganer_Spawner();
	}
}

function GetACSFogAssassinKillAdds()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Fog_Assassin_Doppleganger', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Kill('ACS_Fog_Assassin_Death', true);
	}
}

function GetACSFogAssassinDestroyFogEnts()
{	
	var gas 											: array<CEntity>;
	var i												: int;
	
	gas.Clear();

	theGame.GetEntitiesByTag( 'ACS_Fog_Assassin_Fog_Entity', gas );	
	
	for( i = 0; i < gas.Size(); i += 1 )
	{
		gas[i].Destroy();
	}
}

function ACS_FogAssassinSmokeScreen( npc : CActor, pos : Vector )
{
	var ent       														: CEntity;
	var rot, attach_rot, adjustedRot                        						 	: EulerAngles;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;

	if (!GetACSFogAssassin())
	{
		return;
	}

	if (!thePlayer.IsInCombat())
	{
		return;
	}

	rot = EulerAngles(0,0,0);

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	//"dlc\dlc_acs\data\fx\dettlaff_swarm_tornado.w2ent"

	"fx\quest\q501\navalbattle\q501_fog_to_hide_spawn.w2ent"

	, true ), ACSPlayerFixZAxis(pos), rot );

	ent.DestroyAfter(770);

	//ent.CreateAttachment(npc);

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 3, 3, 0.25, 1 ));

	meshcomp.SetScale(Vector( 3, 3, 0.25, 1 ));	

	ent.PlayEffectSingle('fog');

	ent.AddTag('ACS_Fog_Assassin_Fog_Entity');

	GetACSFogAssassin().SoundEvent("monster_fogling_appear_disappear_vfx");
}

function ACS_FogAssassinDopplegangerSmokeScreen( npc : CActor, pos : Vector )
{
	var ent       														: CEntity;
	var rot, attach_rot, adjustedRot                        						 	: EulerAngles;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;

	rot = EulerAngles(0,0,0);

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	//"dlc\dlc_acs\data\fx\dettlaff_swarm_tornado.w2ent"

	"fx\quest\q501\navalbattle\q501_fog_to_hide_spawn.w2ent"

	, true ), ACSPlayerFixZAxis(pos), rot );

	ent.DestroyAfter(770);

	ent.CreateAttachment( npc, , Vector( 0, 0 , 2 ), EulerAngles(0,0,0) );

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 3, 3, 0.25, 1 ));

	meshcomp.SetScale(Vector( 3, 3, 0.25, 1 ));	

	ent.PlayEffectSingle('fog');

	ent.AddTag('ACS_Fog_Assassin_Fog_Entity');

	GetACSFogAssassin().SoundEvent("monster_fogling_appear_disappear_vfx");
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Forest_God_Adds_1_Spawner()
{
	var vACS_Forest_God_Spawner : cACS_Forest_God_Spawner;
	vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;

	vACS_Forest_God_Spawner.ACS_Forest_God_Adds_1_Spawner_Engage();
}

function ACS_Forest_God_Adds_2_Spawner()
{
	var vACS_Forest_God_Spawner : cACS_Forest_God_Spawner;
	vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;

	vACS_Forest_God_Spawner.ACS_Forest_God_Adds_2_Spawner_Engage();
}

function ACS_Forest_God_Shadows_Destroy()
{	
	var shadows 										: array<CActor>;
	var i												: int;
	
	shadows.Clear();

	theGame.GetActorsByTag( 'ACS_Forest_God_Shadows', shadows );	

	if (shadows.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < shadows.Size(); i += 1 )
	{
		shadows[i].Destroy();
	}
}

statemachine class cACS_Forest_God_Spawner
{
	function ACS_Forest_God_Adds_1_Spawner_Engage()
	{
		this.PushState('ACS_Forest_God_Adds_1_Spawner_Engage');
	}

	function ACS_Forest_God_Adds_2_Spawner_Engage()
	{
		this.PushState('ACS_Forest_God_Adds_2_Spawner_Engage');
	}

	function ACS_Forest_God_Shadows_Spawner_Engage()
	{
		this.PushState('ACS_Forest_God_Shadows_Spawner_Engage');
	}
}

state ACS_Forest_God_Shadows_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Shadows_Entry();
	}
	
	entry function Spawn_Shadows_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Shadows_Latent();
		
		LockEntryFunction(false);
	}

	latent function Spawn_Shadows_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\forest_god_shadow.w2ent"
			
		, true );

		playerPos = thePlayer.GetWorldPosition();

		if( thePlayer.GetStat( BCS_Vitality ) <= thePlayer.GetStatMax(BCS_Vitality)/2 ) 
		{	
			count = 1;
		}
		else if( thePlayer.GetStat( BCS_Vitality ) == thePlayer.GetStatMax(BCS_Vitality) ) 
		{
			count = 2;
		}
		else
		{
			count = 1;
		}
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			playerRot = thePlayer.GetWorldRotation();

			playerRot.Yaw += 180;

			adjustedRot = EulerAngles(0,0,0);

			adjustedRot.Yaw = playerRot.Yaw;
			
			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 0.65;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 3 );

			((CActor)ent).GetInventory().AddAnItem( 'Leshy mutagen', 1 );

			((CNewNPC)ent).SetLevel( thePlayer.GetLevel() - 15 );

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

			((CActor)ent).SetAnimationSpeedMultiplier(1.25);

			((CActor)ent).AddBuffImmunity_AllNegative('ACS_Forest_God_Shadows', true);

			((CActor)ent).AddBuffImmunity_AllCritical('ACS_Forest_God_Shadows', true);

			((CActor)ent).EnableCharacterCollisions(false);

			((CActor)ent).SetUnpushableTarget(thePlayer);

			((CActor)ent).PlayEffectSingle('demonic_possession');

			if (count == 2)
			{
				((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence)/2);
			}

			((CActor)ent).RemoveBuffImmunity(EET_Slowdown);

			((CActor)ent).RemoveBuffImmunity(EET_Paralyzed);

			((CActor)ent).RemoveBuffImmunity(EET_Stagger);

			ent.AddTag( 'ACS_Forest_God_Shadows' );

			ent.AddTag( 'ContractTarget' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACSForestGodShadow() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Forest_God_Shadows' );
	return entity;
}

state ACS_Forest_God_Adds_1_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Adds_1_Entry();
	}
	
	entry function Spawn_Adds_1_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Adds_1_Latent();
		
		LockEntryFunction(false);
	}

	latent function Spawn_Adds_1_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent"
			
		, true );

		playerPos = ACS_Forest_God().GetWorldPosition();
		
		count = 3;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			playerRot = thePlayer.GetWorldRotation();

			playerRot.Yaw += 180;

			adjustedRot = EulerAngles(0,0,0);

			adjustedRot.Yaw = playerRot.Yaw;
			
			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );
			
			((CNewNPC)ent).SetLevel( 5 );

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetAttitude(ACS_Forest_God(), AIA_Friendly);

			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.25);

			((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence)/4);
			ent.AddTag( 'ACS_Echinops' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Forest_God_Adds_2_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Adds_2_Entry();
	}
	
	entry function Spawn_Adds_2_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Adds_2_Latent();
		
		LockEntryFunction(false);
	}

	latent function Spawn_Adds_2_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent"
			
		, true );

		playerPos = ACS_Forest_God().GetWorldPosition();
		
		count = 6;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			playerRot = thePlayer.GetWorldRotation();

			playerRot.Yaw += 180;

			adjustedRot = EulerAngles(0,0,0);

			adjustedRot.Yaw = playerRot.Yaw;
			
			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );
			
			((CNewNPC)ent).SetLevel( 5 );

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetAttitude(ACS_Forest_God(), AIA_Friendly);

			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.5);

			((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence)/4);
			ent.AddTag( 'ACS_Echinops' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Forest_God_Spawner_Engage in cACS_Forest_God_Spawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var gasEntity														: W3ToxicCloud;
	private var weapon_names, armor_names										: array<CName>;
	private var playerRot, adjustedRot											: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Entry();
	}
	
	entry function Spawn_Entry()
	{	
		LockEntryFunction(true);
		
		thePlayer.StopEffect('summon');
		thePlayer.PlayEffectSingle('summon');
	
		Spawn_Latent();
		
		LockEntryFunction(false);
	}

	function fill_shades_weapons_array()
	{
		weapon_names.Clear();

		weapon_names.PushBack('Shades Steel Claymore 2');
		weapon_names.PushBack('Shades Steel Rakuyo 2');
		weapon_names.PushBack('Shades Steel Graveripper 2');
		weapon_names.PushBack('Shades Steel Kukri 2');
		weapon_names.PushBack('Shades Steel a123 2');
		weapon_names.PushBack('Shades Steel Realmdrifter Blade 2');
		weapon_names.PushBack('Shades Steel Realmdrifter Divider 2');
		weapon_names.PushBack('Shades Steel Hades Grasp 2');
		weapon_names.PushBack('Shades Steel Icarus Tears 2');
		weapon_names.PushBack('Shades Steel Kingslayer 2');
		weapon_names.PushBack('Shades Steel Vulcan 2');
		weapon_names.PushBack('Shades Steel Flameborn 2');
		weapon_names.PushBack('Shades Steel Frostmourne 2');
		weapon_names.PushBack('Shades Steel Oblivion 2');
		weapon_names.PushBack('Shades Steel Sinner 2');
		weapon_names.PushBack('Shades Steel Bloodletter 2');
		weapon_names.PushBack('Shades Steel Ares 2');
		weapon_names.PushBack('Shades Steel Voidblade 2');
		weapon_names.PushBack('Shades Steel Bloodshot 2');
		weapon_names.PushBack('Shades Steel Eagle Sword 2');
		weapon_names.PushBack('Shades Steel Lion Sword 2');
		weapon_names.PushBack('Shades Steel Pridefall 2');
		weapon_names.PushBack('Shades Steel Haoma 2');
		weapon_names.PushBack('Shades Steel Cursed Khopesh 2');
		weapon_names.PushBack('Shades Steel Sithis Blade 2');
		weapon_names.PushBack('Shades Steel Ejderblade 2');
		weapon_names.PushBack('Shades Steel Dragonbane 2');
		weapon_names.PushBack('Shades Steel Doomblade 2');
		weapon_names.PushBack('Shades Steel Crownbreaker 2');
		weapon_names.PushBack('Shades Steel Blooddusk 2');
		weapon_names.PushBack('Shades Steel Oathblade 2');
		weapon_names.PushBack('Shades Steel Beastcutter 2');
		weapon_names.PushBack('Shades Steel Hellspire 2');
		weapon_names.PushBack('Shades Steel Heavenspire 2');
		weapon_names.PushBack('Shades Steel Guandao 2');
		weapon_names.PushBack('Shades Steel Hitokiri Katana 2');
		weapon_names.PushBack('Shades Steel Gorgonslayer 2');
		weapon_names.PushBack('Shades Steel Ryu Katana 2');
		weapon_names.PushBack('Shades Steel Blackdawn 2');
		weapon_names.PushBack('Shades Steel Knife 2');
		weapon_names.PushBack('Shades Silver Claymore 2');
		weapon_names.PushBack('Shades Silver Rakuyo 2');
		weapon_names.PushBack('Shades Silver Graveripper 2');
		weapon_names.PushBack('Shades Silver a123 2');
		weapon_names.PushBack('Shades Silver Kukri 2');
		weapon_names.PushBack('Shades Silver Realmdrifter Blade 2');
		weapon_names.PushBack('Shades Silver Realmdrifter Divider 2');
		weapon_names.PushBack('Shades Silver Hades Grasp 2');
		weapon_names.PushBack('Shades Silver Icarus Tears 2');
		weapon_names.PushBack('Shades Silver Kingslayer 2');
		weapon_names.PushBack('Shades Silver Vulcan 2');
		weapon_names.PushBack('Shades Silver Flameborn 2');
		weapon_names.PushBack('Shades Silver Frostmourne 2');
		weapon_names.PushBack('Shades Silver Oblivion 2');
		weapon_names.PushBack('Shades Silver Sinner 2');
		weapon_names.PushBack('Shades Silver Bloodletter 2');
		weapon_names.PushBack('Shades Silver Ares 2');
		weapon_names.PushBack('Shades Silver Voidblade 2');
		weapon_names.PushBack('Shades Silver Bloodshot 2');
		weapon_names.PushBack('Shades Silver Eagle Sword 2');
		weapon_names.PushBack('Shades Silver Lion Sword 2');
		weapon_names.PushBack('Shades Silver Pridefall 2');
		weapon_names.PushBack('Shades Silver Haoma 2');
		weapon_names.PushBack('Shades Silver Cursed Khopesh 2');
		weapon_names.PushBack('Shades Silver Sithis Blade 2');
		weapon_names.PushBack('Shades Silver Ejderblade 2');
		weapon_names.PushBack('Shades Silver Dragonbane 2');
		weapon_names.PushBack('Shades Silver Doomblade 2');
		weapon_names.PushBack('Shades Silver Crownbreaker 2');
		weapon_names.PushBack('Shades Silver Blooddusk 2');
		weapon_names.PushBack('Shades Silver Oathblade 2');
		weapon_names.PushBack('Shades Silver Beastcutter 2');
		weapon_names.PushBack('Shades Silver Hellspire 2');
		weapon_names.PushBack('Shades Silver Heavenspire 2');
		weapon_names.PushBack('Shades Silver Guandao 2');
		weapon_names.PushBack('Shades Silver Hitokiri Katana 2');
		weapon_names.PushBack('Shades Silver Gorgonslayer 2');
		weapon_names.PushBack('Shades Silver Ryu Katana 2');
		weapon_names.PushBack('Shades Silver Blackdawn 2');
		weapon_names.PushBack('Shades Silver Knife 2');
	}

	function fill_shades_armor_arrawy()
	{
		armor_names.Clear();

		armor_names.PushBack('Shades Realmdrifter Armor 2');
		armor_names.PushBack('Shades Realmdrifter Boots 2');
		armor_names.PushBack('Shades Realmdrifter Gloves 2');
		armor_names.PushBack('Shades Realmdrifter Helm');
		armor_names.PushBack('Shades Realmdrifter Pants 2');

		armor_names.PushBack('Shades Omen Armor 3');
		armor_names.PushBack('Shades Omen Boots 3');
		armor_names.PushBack('Shades Omen Gloves 3');
		armor_names.PushBack('Shades Omen Helm');
		armor_names.PushBack('Shades Omen Pants 3');

		armor_names.PushBack('Shades Plunderer Armor 3');
		armor_names.PushBack('Shades Plunderer Boots 3');
		armor_names.PushBack('Shades Plunderer Gloves 3');
		armor_names.PushBack('Shades Plunderer Headwear');
		armor_names.PushBack('Shades Plunderer Hat');
		armor_names.PushBack('Shades Plunderer Mask');
		armor_names.PushBack('Shades Plunderer Pants 3');

		armor_names.PushBack('Shade Plunderer Armor 3');
		armor_names.PushBack('Shade Plunderer Boots 3');
		armor_names.PushBack('Shade Plunderer Gloves 3');
		armor_names.PushBack('Shade Plunderer Headwear');
		armor_names.PushBack('Shade Plunderer Hat');
		armor_names.PushBack('Shade Plunderer Mask');
		armor_names.PushBack('Shade Plunderer Pants 3');
		
		armor_names.PushBack('Shades Oldhunter Armor 2');
		armor_names.PushBack('Shades Oldhunter Boots 2');
		armor_names.PushBack('Shades Oldhunter Gloves 2');
		armor_names.PushBack('Shades Oldhunter Cap');
		armor_names.PushBack('Shades Oldhunter Pants 2');
		
		armor_names.PushBack('Shades Faraam Armor 2');
		armor_names.PushBack('Shades Faraam Boots 2');
		armor_names.PushBack('Shades Faraam Gloves 2');
		armor_names.PushBack('Shades Faraam Helm');
		armor_names.PushBack('Shades Faraam Pants 2');
		
		armor_names.PushBack('Shades Hunter Armor 2');
		armor_names.PushBack('Shades Hunter Boots 2');
		armor_names.PushBack('Shades Hunter Gloves 2');
		armor_names.PushBack('Shades Hunter Hat');
		armor_names.PushBack('Shades Hunter Mask');
		armor_names.PushBack('Shades Hunter Mask and Hat');
		armor_names.PushBack('Shades Hunter Pants 2');
		
		armor_names.PushBack('Shades Yahargul Armor 2');
		armor_names.PushBack('Shades Yahargul Boots 2');
		armor_names.PushBack('Shades Yahargul Gloves 2');
		armor_names.PushBack('Shades Yahargul Helm');
		armor_names.PushBack('Shades Yahargul Pants 2');
		
		armor_names.PushBack('Shades Crow Armor 2');
		armor_names.PushBack('Shades Crow Boots 2');
		armor_names.PushBack('Shades Crow Gloves 2');
		armor_names.PushBack('Shades Crow Mask');
		armor_names.PushBack('Shades Crow Pants 2');
		
		armor_names.PushBack('Shades Sithis Armor 2');
		armor_names.PushBack('Shades Taifeng Boots 2');
		armor_names.PushBack('Shades Taifeng Gloves 2');
		armor_names.PushBack('Shades Sithis Hood');
		armor_names.PushBack('Shades Taifeng Pants 2');
		armor_names.PushBack('Shades Taifeng Armor 2');

		armor_names.PushBack('Shades Kara Armor 2');
		armor_names.PushBack('Shades Kara Boots 2');
		armor_names.PushBack('Shades Kara Gloves 2');
		armor_names.PushBack('Shades Kara Hat');
		armor_names.PushBack('Shades Kara Pants 2');
		
		armor_names.PushBack('Shades Lionhunter Armor 2');
		armor_names.PushBack('Shades Lionhunter Boots 2');
		armor_names.PushBack('Shades Lionhunter Gloves 2');
		armor_names.PushBack('Shades Lionhunter Hat');
		armor_names.PushBack('Shades Lionhunter Pants 2');
		
		armor_names.PushBack('Shades Berserker Armor 2');
		armor_names.PushBack('Shades Berserker Boots 2');
		armor_names.PushBack('Shades Berserker Gloves 2');
		armor_names.PushBack('Shades Berserker Helm');
		armor_names.PushBack('Shades Berserker Pants 2');
		
		armor_names.PushBack('Shades Bismarck Armor 2');
		armor_names.PushBack('Shades Bismarck Boots 2');
		armor_names.PushBack('Shades Bismarck Gloves 2');
		armor_names.PushBack('Shades Bismarck Helm');
		armor_names.PushBack('Shades Bismarck Pants 2');
		
		armor_names.PushBack('Shades Undertaker Armor 2');
		armor_names.PushBack('Shades Undertaker Boots 2');
		armor_names.PushBack('Shades Undertaker Gloves 2');
		armor_names.PushBack('Shades Undertaker Pants 2');
		armor_names.PushBack('Shades Undertaker Mask');
		
		armor_names.PushBack('Shades Ezio Pants 2');
		armor_names.PushBack('Shades Ezio Armor 2');
		armor_names.PushBack('Shades Ezio Boots 2');
		armor_names.PushBack('Shades Ezio Gloves 2');
		armor_names.PushBack('Shades Ezio Hood');
		
		armor_names.PushBack('Shades Headtaker Armor 2');
		armor_names.PushBack('Shades Headtaker Boots 2');
		armor_names.PushBack('Shades Headtaker Gloves 2');
		armor_names.PushBack('Shades Headtaker Pants 2');
		armor_names.PushBack('Shades Headtaker Mask');
		
		armor_names.PushBack('Shades Viper Armor 2');
		armor_names.PushBack('Shades Viper Boots 2');
		armor_names.PushBack('Shades Viper Gloves 2');
		armor_names.PushBack('Shades Viper Mask');
		armor_names.PushBack('Shades Viper Pants 2');
		
		armor_names.PushBack('Shades Ronin Hat');
		armor_names.PushBack('Shades Hitokiri Mask');
		armor_names.PushBack('Shades Warborn Helm');
		armor_names.PushBack('Shades Headtaker Cloak');
		armor_names.PushBack('Shades Genichiro Helm');
	}

	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 
		"dlc\dlc_acs\data\entities\monsters\forest_god.w2ent"
		, true );

		playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			playerRot = thePlayer.GetWorldRotation();

			playerRot.Yaw += 180;

			adjustedRot = EulerAngles(0,0,0);

			adjustedRot.Yaw = playerRot.Yaw;
			
			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,1.25,1));
			meshcomp.SetScale(Vector(h,h,1.25,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
			((CActor)ent).SetAnimationSpeedMultiplier(1.1);

			((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

			if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
			{
				fill_shades_weapons_array();

				fill_shades_armor_arrawy();

				((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

				((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
			}
			else
			{
				((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

				((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
			}

			((CActor)ent).AddTag( 'ACS_Forest_God' );

			((CActor)ent).AddTag( 'ACS_Big_Boi' );

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Forest_God_Buff', true);

			ent.AddTag('NoBestiaryEntry');

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('demonic_possession_r_hand');
			ent.PlayEffectSingle('demonic_possession_l_hand');

			ent.PlayEffectSingle('demonic_possession_torso');
			ent.PlayEffectSingle('demonic_possession_pelvis');

			ent.PlayEffectSingle('demonic_possession_r_bicep');
			ent.PlayEffectSingle('demonic_possession_l_bicep');

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

			ent.PlayEffectSingle('demonic_possession_l_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_foot'); 
			ent.PlayEffectSingle('demonic_possession_r_shin'); 
			ent.PlayEffectSingle('demonic_possession_l_shin'); 

			ent.PlayEffectSingle('demonic_possession_torso2'); 

			ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
			ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

			ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
			ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

			ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
			ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

			ent.PlayEffectSingle('demonic_possession_torso3'); 
		}

		GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);

		ACS_ToxicGasSpawner();
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Forest_God() : CActor
{
	var enemy 				 : CActor;
	
	enemy = (CActor)theGame.GetEntityByTag( 'ACS_Forest_God' );
	return enemy;
}

function ACS_Big_Boi() : CActor
{
	var enemy 				 : CActor;
	
	enemy = (CActor)theGame.GetEntityByTag( 'ACS_Big_Boi' );
	return enemy;
}

function ACS_Forest_God_Secondary() : CActor
{
	var enemy 				 : CActor;
	
	enemy = (CActor)theGame.GetEntityByTag( 'ACS_Forest_God_Secondary' );
	return enemy;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Spawner()
{
	var vACS_Spawner : cACS_Spawner;
	var vW3ACSWatcher	: W3ACSWatcher;

	vACS_Spawner = new cACS_Spawner in vW3ACSWatcher;
			
	vACS_Spawner.ACS_Spawner_Engage();
}

statemachine class cACS_Spawner
{
    function ACS_Spawner_Engage()
	{
		this.PushState('ACS_Spawner_Engage');
	}
}

state ACS_Spawner_Engage in cACS_Spawner
{
	private var temp, anchor_temp, ent_1_temp									: CEntityTemplate;
	private var ent, anchor, ent_1												: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Entry();
	}
	
	entry function Spawn_Entry()
	{	
		Spawn_Latent();
	}
	
	/*
	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

			//"dlc/dlc_acs/data/entities/monsters/hym.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\treant.w2ent"

			//"quests\part_1\quest_files\q202_giant\characters\q202_ice_giant.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\ice_giant_1.w2ent"

			//"dlc\ep1\data\characters\npc_entities\monsters\ethernal.w2ent"

			//"dlc\ep1\data\quests\main_npcs\olgierd.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\shadow_wolf.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\ethernal.w2ent"
			//"dlc\dlc_acs\data\entities\monsters\nekker_nekker.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_evil_spirit.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_plague_victim_axe_hostile.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_witcher.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\entities\mq1060_glow_roots_large.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\spiral_endrega.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\echinops_turret.w2ent"

			"characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent"

			//"characters\npc_entities\monsters\_quest__endriaga_spiral.w2ent"
			
			, true );

		playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;
		
		count = 100;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			ent = theGame.CreateEntity( temp, spawnPos, thePlayer.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CNewNPC)ent).EnableCharacterCollisions(false);
			((CActor)ent).EnableCharacterCollisions(false);


			ent.PlayEffectSingle('spikes');

			((CNewNPC)ent).GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'head' ), bone_vec, bone_rot );

			anchor_temp = (CEntityTemplate)LoadResourceAsync( 
						
				"dlc\dlc_acs\data\entities\other\fx_ent.w2ent"
				
				, true );

			anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -10 ) );

			anchor.AddTag('acs_spiral_echinops_anchor');

			//anchor.CreateAttachmentAtBoneWS( ((CNewNPC)ent), 'head', bone_vec, bone_rot );

			anchor.CreateAttachment( ent );

			((CActor)anchor).EnableCollisions(false);
			((CActor)anchor).EnableCharacterCollisions(false);


			ent_1_temp = (CEntityTemplate)LoadResourceAsync( 

				//"dlc\dlc_acs\data\entities\monsters\endrega_echinops_turret.w2ent"

				//"dlc\bob\data\characters\npc_entities\monsters\scolopendromorph.w2ent"

				//"dlc\dlc_acs\data\entities\monsters\spiral_endrega.w2ent"

				//"characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent"

				//"characters\npc_entities\monsters\endriaga_lvl3__spikey.w2ent"

				"characters\npc_entities\monsters\_quest__endriaga_spiral.w2ent"
				
				, true );


			ent_1 = theGame.CreateEntity( ent_1_temp, ent.GetWorldPosition(), ent.GetWorldRotation() );

			ent_1.AddTag('ACS_spiral_echinops_1');

			((CNewNPC)ent_1).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent_1).SetAttitude((CNewNPC)ent, AIA_Friendly);

			((CNewNPC)ent).SetAttitude((CNewNPC)ent_1, AIA_Friendly);

			//((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
			((CNewNPC)ent_1).EnableCharacterCollisions(false);
			((CNewNPC)ent_1).EnableCollisions(false);
			//((CNewNPC)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
			//((CActor)ent_1).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
			((CActor)ent_1).EnableCollisions(false);
			((CActor)ent_1).EnableCharacterCollisions(false);
			//((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );


			animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_1.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 0;
			attach_vec.X = 0;
			attach_vec.Y = 1;
			attach_vec.Z = 0;

			ent_1.CreateAttachment( anchor, , attach_vec, attach_rot );

			//ent.PlayEffectSingle('ice');

			//ent.PlayEffectSingle('appear');
			//ent.StopEffect('appear');
			//ent.PlayEffectSingle('shadow_form');
			//ent.PlayEffectSingle('demonic_possession');

			//((CActor)ent).SetBehaviorVariable( 'wakeUpType', 1.0 );
			//((CActor)ent).AddAbility( 'EtherealActive' );

			((CActor)ent).RemoveBuffImmunity( EET_Stagger );
			((CActor)ent).RemoveBuffImmunity( EET_LongStagger );

			//ent.PlayEffectSingle('special_attack_fx');

			ent.AddTag( 'ACS_enemy' );
			//ent.AddTag( 'ACS_Big_Boi' );
		}
	}
	*/

	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

			//"dlc/dlc_acs/data/entities/monsters/hym.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\treant.w2ent"

			//"quests\part_1\quest_files\q202_giant\characters\q202_ice_giant.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\ice_giant_1.w2ent"

			//"dlc\ep1\data\characters\npc_entities\monsters\ethernal.w2ent"

			//"dlc\ep1\data\quests\main_npcs\olgierd.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\shadow_wolf.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\bruxa_alp_cloak_always_spawn.w2ent"

			//"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak_always_spawn.w2ent"

			//"dlc\dlc_acs\data\entities\monsters\ethernal.w2ent"
			//"dlc\dlc_acs\data\entities\monsters\nekker_nekker.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_evil_spirit.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_plague_victim_axe_hostile.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\characters\mq1060_witcher.w2ent"

			//"quests\minor_quests\no_mans_land\quest_files\mq1060_devils_pit\entities\mq1060_glow_roots_large.w2ent"

			"characters\npc_entities\monsters\burnedman_lvl1.w2ent"
			
			, true );

		playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 5;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			playerRot = thePlayer.GetWorldRotation();

			playerRot.Yaw += 180;

			adjustedRot = EulerAngles(0,0,0);

			adjustedRot.Yaw = playerRot.Yaw;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);
			
			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(100);
			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			//ent.PlayEffectSingle('ice');

			//ent.PlayEffectSingle('appear');
			//ent.StopEffect('appear');
			//ent.PlayEffectSingle('shadow_form');
			//ent.PlayEffectSingle('demonic_possession');

			//((CActor)ent).SetBehaviorVariable( 'wakeUpType', 1.0 );
			//((CActor)ent).AddAbility( 'EtherealActive' );

			((CActor)ent).RemoveBuffImmunity( EET_Stagger );
			((CActor)ent).RemoveBuffImmunity( EET_LongStagger );

			//ent.PlayEffectSingle('special_attack_fx');

			ent.AddTag( 'ACS_enemy' );
			//ent.AddTag( 'ACS_Big_Boi' );

			SleepOneFrame();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSLegolas() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Legolas' );
	return entity;
}

function GetACSEnemy() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_enemy' );
	return entity;
}

function GetACSEnemyDestroyAll()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_enemy', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ToxicGasSpawner()
{
	var vACS_ToxicGasSpawner : cACS_ToxicGasSpawner;
	vACS_ToxicGasSpawner = new cACS_ToxicGasSpawner in theGame;
			
	vACS_ToxicGasSpawner.ACS_ToxicGasSpawner_Engage();
}

statemachine class cACS_ToxicGasSpawner
{
    function ACS_ToxicGasSpawner_Engage()
	{
		this.PushState('ACS_ToxicGasSpawner_Engage');
	}
}

state ACS_ToxicGasSpawner_Engage in cACS_ToxicGasSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var gasEntity 														: W3ToxicCloud;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Entry();
	}
	
	entry function Spawn_Entry()
	{	
		LockEntryFunction(true);
	
		Spawn_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\toxic_gas_7m.w2ent", true );

		pos = ACS_Forest_God().GetWorldPosition();

		ACS_Toxic_Gas_Destroy();

		ACS_Get_Toxic_Gas().Destroy();
			
		gasEntity = (W3ToxicCloud)theGame.CreateEntity(temp, spawnPos, ACS_Forest_God().GetWorldRotation());

		gasEntity.CreateAttachment(ACS_Forest_God());

		//gasEntity.Enable(true);
			
		//gasEntity.PlayEffectSingle('toxic_gas');

		gasEntity.AddTag( 'ACS_Toxic_Gas' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Get_Toxic_Gas() : W3ToxicCloud
{
	var gas 			 : W3ToxicCloud;
	
	gas = (W3ToxicCloud)theGame.GetEntityByTag( 'ACS_Toxic_Gas' );
	return gas;
}

function ACS_Toxic_Gas_Destroy()
{	
	var gas 											: array<CEntity>;
	var i												: int;
	
	gas.Clear();

	theGame.GetEntitiesByTag( 'ACS_Toxic_Gas', gas );	
	
	for( i = 0; i < gas.Size(); i += 1 )
	{
		gas[i].Destroy();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_MelusineSpawner()
{
	var vACS_MelusineSpawner : cACS_MelusineSpawner;
	vACS_MelusineSpawner = new cACS_MelusineSpawner in theGame;

	GetACSMelusine().Destroy();

	GetACSMelusineCloud().Destroy();

	GetACSMelusineBossbar().Destroy();

	ACS_Lightning_Strike_No_Condition_Mult();
			
	vACS_MelusineSpawner.ACS_MelusineSpawner_Engage();
}

function ACS_MelusineCloudTesla()
{
	var vACS_MelusineSpawner : cACS_MelusineSpawner;
	vACS_MelusineSpawner = new cACS_MelusineSpawner in theGame;
			
	vACS_MelusineSpawner.ACS_MelusineCloudTesla_Engage();
}

statemachine class cACS_MelusineSpawner
{
	function ACS_MelusineSpawner_Engage()
	{
		this.PushState('ACS_MelusineSpawner_Engage');
	}

    function ACS_MelusineCloudTesla_Engage()
	{
		this.PushState('ACS_MelusineCloudTesla_Engage');
	}
}

state ACS_MelusineSpawner_Engage in cACS_MelusineSpawner
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	var l_aiTree														: CAIMoveToAction;		

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Melusine_Spawner_Entry();
	}
	
	entry function Melusine_Spawner_Entry()
	{	
		Melusine_Spawner_Latent();
	}
	
	latent function Melusine_Spawner_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\melusine.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 20;

		playerPos.Z += 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
			
		ent = theGame.CreateEntity( temp, playerPos, adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.875);

		//((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Ragdoll , 'ACS_Enemy_Buff', true);

		//((CActor)ent).AddBuffImmunity_AllNegative('ACS_Immunity_Negative', true); 
		//((CActor)ent).AddBuffImmunity_AllCritical('ACS_Immunity_Critical', true); 

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		ent.AddTag('NoBestiaryEntry');

		((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

		ent.AddTag( 'ACS_Melusine' );

		((CActor)ent).GetInventory().AddAnItem('acs_vampire_necklace', 1);






		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\melusine_cloud.w2ent"
			
		, true );

		ent_2 = theGame.CreateEntity( temp_2, playerPos, adjustedRot );

		animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent_2).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent_2).SetAttitude(((CNewNPC)ent), AIA_Friendly);
		
		((CActor)ent_2).SetCanPlayHitAnim(false);

		((CActor)ent_2).AddBuffImmunity_AllNegative('ACS_Immunity_Negative', true); 
		((CActor)ent_2).AddBuffImmunity_AllCritical('ACS_Immunity_Critical', true); 

		((CActor)ent_2).SetImmortalityMode( AIM_Immortal, AIC_Default, true );

		((CActor)ent_2).AddTag( 'ContractTarget' );

		((CActor)ent_2).AddTag('IsBoss');

		((CActor)ent_2).AddTag('ACS_Big_Boi');

		((CActor)ent_2).AddAbility('Boss');

		((CActor)ent_2).AddAbility('BounceBoltsWildhunt');

		((CActor)ent_2).AddAbility('DisableFinisher');

		((CActor)ent_2).AddAbility('InstantKillImmune');

		((CActor)ent_2).AddAbility('DjinnWeak');

		//((CActor)ent_2).AddAbility('DjinnRage');

		ent_2.AddTag('NoBestiaryEntry');

		((CNewNPC)ent_2).SetBehaviorVariable( 'lookatOn', 0, true );

		ent_2.AddTag( 'ACS_Melusine_Cloud' );

		ent_2.CreateAttachment( ent, 'attach_slot', Vector( -1.5, 0 , 0), EulerAngles(-180,0,90) );

		((CNewNPC)ent_2).EnableCharacterCollisions(false); 
		((CNewNPC)ent_2).EnableCollisions(false);

		ent_2.PlayEffectSingle('teleport_glow_fx');
		ent_2.PlayEffectSingle('teleport_out');
		ent_2.PlayEffectSingle('teleport_in');
		ent_2.PlayEffectSingle('fx_push');
		ent_2.PlayEffectSingle('prepare_attack_fx');
		ent_2.PlayEffectSingle('aard_reaction');
		ent_2.PlayEffectSingle('igni_reaction');


		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\melusine_mh.w2ent"
			
		, true );

		ent_3 = theGame.CreateEntity( temp_3, playerPos, adjustedRot );

		animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_3.GetComponentByClassName('CMeshComponent');
		h = 0;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent_3).SetAnimationSpeedMultiplier(0);

		((CNewNPC)ent_3).SetAttitude(((CNewNPC)ent), AIA_Friendly);
		
		((CActor)ent_3).SetCanPlayHitAnim(false);

		((CActor)ent_3).AddBuffImmunity_AllNegative('ACS_Immunity_Negative', true); 
		((CActor)ent_3).AddBuffImmunity_AllCritical('ACS_Immunity_Critical', true); 

		((CActor)ent_3).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

		((CActor)ent_3).AddTag('IsBoss');

		((CActor)ent_3).AddAbility('Boss');

		((CActor)ent_3).AddAbility('BounceBoltsWildhunt');

		((CActor)ent_3).AddAbility('DisableFinisher');

		((CActor)ent_3).AddAbility('InstantKillImmune');

		ent_3.AddTag('NoBestiaryEntry');

		((CNewNPC)ent_3).SetBehaviorVariable( 'lookatOn', 0, true );

		ent_3.AddTag( 'ACS_Melusine_Bossbar' );

		ent_3.CreateAttachment( ent, 'attach_slot', Vector( 3, -5, 0), EulerAngles(-180,0,90) );

		((CNewNPC)ent_3).EnableCharacterCollisions(false); 
		((CNewNPC)ent_3).EnableCollisions(false);

		((CNewNPC)ent_3).SetVisibility( false );


		((CNewNPC)ent).SetAttitude(((CNewNPC)ent_2), AIA_Friendly);

		((CNewNPC)ent).SetAttitude(((CNewNPC)ent_3), AIA_Friendly);

		((CNewNPC)ent_2).SetAttitude(((CNewNPC)ent), AIA_Friendly);

		((CNewNPC)ent_2).SetAttitude(((CNewNPC)ent_3), AIA_Friendly);

		((CNewNPC)ent_3).SetAttitude(((CNewNPC)ent), AIA_Friendly);

		((CNewNPC)ent_3).SetAttitude(((CNewNPC)ent_2), AIA_Friendly);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MelusineCloudTesla_Engage in cACS_MelusineSpawner
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var playerRot, adjustedRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Tesla_Entry();
	}
	
	entry function Tesla_Entry()
	{	
		LockEntryFunction(true);
	
		Tesla_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Tesla_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		//"dlc\dlc_acs\data\entities\other\fx_dummy_entity.w2ent"

		"gameplay\abilities\sorceresses\fx_dummy_entity.w2ent"
			
		, true );

		playerPos = GetACSMelusine().GetWorldPosition();

		playerRot = GetACSMelusine().GetWorldRotation();
		
		count = RandRange(5,3);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 7.5 + 7.5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			ent.PlayEffectSingle('hit_electric');

			ent.AddTag( 'ACS_Tesla_FX_Dummy' );

			ent.DestroyAfter(1);

			GetACSMelusineCloud().StopEffect('lightning_tesla');	
			GetACSMelusineCloud().PlayEffectSingle('lightning_tesla', ent);
			GetACSMelusineCloud().StopEffect('lightning_tesla');	
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSMelusine() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Melusine' );
	return entity;
}

function GetACSMelusineCloud() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Melusine_Cloud' );
	return entity;
}

function GetACSMelusineBossbar() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Melusine_Bossbar' );
	return entity;
}

function ACS_Melusine_Cloud_Controls()
{
	var l_aiTree																	: CAIExecuteAttackAction;

	if (GetACSMelusineCloud() && GetACSMelusine())
	{
		if (!GetACSMelusine().HasAbility('DisableFinisher'))
		{
			GetACSMelusine().AddAbility('DisableFinisher');
		}

		if (!GetACSMelusine().HasAbility('InstantKillImmune'))
		{
			GetACSMelusine().AddAbility('InstantKillImmune');
		}

		if (ACS_melusine_ability_switch())
		{
			ACS_refresh_melusine_ability_switch_cooldown();

			if (GetACSMelusineCloud().HasAbility('DjinnRage'))
			{
				GetACSMelusineCloud().AddAbility('DjinnWeak');

				GetACSMelusineCloud().RemoveAbility('DjinnRage');
			}
			else if (GetACSMelusineCloud().HasAbility('DjinnWeak'))
			{
				GetACSMelusineCloud().AddAbility('DjinnRage');

				GetACSMelusineCloud().RemoveAbility('DjinnWeak');
			}
		}

		if (ACS_melusine_cloud_can_attack())
		{
			ACS_refresh_melusine_cloud_attack_cooldown();

			if (GetACSMelusineCloud().HasAbility('DjinnRage'))
			{ 
				ACS_MelusineCloudTesla();
			}
			else if (GetACSMelusineCloud().HasAbility('DjinnWeak'))
			{
				l_aiTree = new CAIExecuteAttackAction in GetACSMelusineCloud();

				l_aiTree.OnCreated();

				l_aiTree.attackParameter = EAT_Attack1;
				
				GetACSMelusineCloud().ForceAIBehavior( l_aiTree, BTAP_AboveCombat2);
			}
		}
	}
	else
	{
		return;
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Cultist_Boss_Siren_Spawn()
{
	var vACS_Cultist_Spawner : cACS_Cultist_Spawner;
	vACS_Cultist_Spawner = new cACS_Cultist_Spawner in theGame;
			
	vACS_Cultist_Spawner.ACS_Cultist_Boss_Siren_Spawn_Engage();
}

function ACS_Cultist_Siren_Spawn()
{
	var vACS_Cultist_Spawner : cACS_Cultist_Spawner;
	vACS_Cultist_Spawner = new cACS_Cultist_Spawner in theGame;
			
	vACS_Cultist_Spawner.ACS_Cultist_Siren_Spawn_Engage();
}

statemachine class cACS_Cultist_Spawner
{
	function ACS_Cultist_Boss_Siren_Spawn_Engage()
	{
		this.PushState('ACS_Cultist_Boss_Siren_Spawn_Engage');
	}

    function ACS_Cultist_Siren_Spawn_Engage()
	{
		this.PushState('ACS_Cultist_Siren_Spawn_Engage');
	}
}

state ACS_Cultist_Spawn_Engage in cACS_Cultist_Spawner
{
	var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
	var ent, ent_2, ent_3, ent_4										: CEntity;
	var i, count														: int;
	var playerPos, spawnPos, bossPos									: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot		: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Cultist_Spawn_Entry();
	}
	
	entry function Cultist_Spawn_Entry()
	{	
		Cultist_Spawn_Latent();
	}
	
	latent function Cultist_Spawn_Latent()
	{
		temp_1 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Cultist_Static_Spawn_Engage in cACS_Cultist_Spawner
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Cultist_Static_Spawn_Entry();
	}
	
	entry function Cultist_Static_Spawn_Entry()
	{	
		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			Cultist_Static_Spawn_Pos_1_Latent();

			Cultist_Static_Spawn_Pos_2_Latent();

			Cultist_Static_Spawn_Pos_3_Latent();

			Cultist_Static_Spawn_Pos_4_Latent();

			Cultist_Static_Spawn_Pos_5_Latent();

			Cultist_Static_Spawn_Pos_6_Latent();

			Cultist_Static_Spawn_Pos_7_Latent();
		}
	}
	
	latent function Cultist_Static_Spawn_Pos_1_Latent()
	{
		var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
		var ent, ent_2, ent_3, ent_4										: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, bossPos									: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot		: EulerAngles;

		temp_1 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = Vector(-389.277191, 899.686523, 4.009470, 1);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		ent.AddTag( 'ACS_Cultist_Boss_2' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}

	latent function Cultist_Static_Spawn_Pos_2_Latent()
	{
		var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
		var ent, ent_2, ent_3, ent_4										: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, bossPos									: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot		: EulerAngles;

		temp_1 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = Vector(-1889.174927, 1141.632202, 33.613052, 1);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		ent.AddTag( 'ACS_Cultist_Boss_1' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}

	latent function Cultist_Static_Spawn_Pos_3_Latent()
	{
		var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
		var ent, ent_2, ent_3, ent_4										: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, bossPos									: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot					: EulerAngles;

		temp_1 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = Vector(-2107.615723, -802.813721, 30.930084, 1);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		ent.AddTag( 'ACS_Cultist_Boss_3' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}

	latent function Cultist_Static_Spawn_Pos_4_Latent()
	{
		var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
		var ent, ent_2, ent_3, ent_4										: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, bossPos									: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot					: EulerAngles;

		temp_1 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = Vector(1480.860352, -1900.234863, 6.942338, 1);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		ent.AddTag( 'ACS_Cultist_Boss_4' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}

	latent function Cultist_Static_Spawn_Pos_5_Latent()
	{
		var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
		var ent, ent_2, ent_3, ent_4										: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, bossPos									: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot					: EulerAngles;

		temp_1 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = Vector(2703.981934, 384.496979, 0.653838, 1);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		ent.AddTag( 'ACS_Cultist_Boss_5' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}

	latent function Cultist_Static_Spawn_Pos_6_Latent()
	{
		var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
		var ent, ent_2, ent_3, ent_4										: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, bossPos									: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot					: EulerAngles;

		temp_1 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = Vector(1120.144775, -260.285004, 3.353843, 1);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		ent.AddTag( 'ACS_Cultist_Boss_6' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}

	latent function Cultist_Static_Spawn_Pos_7_Latent()
	{
		var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
		var ent, ent_2, ent_3, ent_4										: CEntity;
		var i, count														: int;
		var playerPos, spawnPos, bossPos									: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot					: EulerAngles;
		
		temp_1 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = Vector(-1537.084839, 1231.020874, 1.866044, 1);

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		ent.AddTag( 'ACS_Cultist_Boss_7' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Cultist_Boss_Siren_Spawn_Engage in cACS_Cultist_Spawner
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var pos, spawnPos													: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var playerRot, adjustedRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Cultist_Boss_Siren_Spawn_Entry();
	}
	
	entry function Cultist_Boss_Siren_Spawn_Entry()
	{	
		Cultist_Boss_Siren_Spawn_Latent();
	}
	
	latent function Cultist_Boss_Siren_Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"characters\npc_entities\monsters\siren_mh__lamia.w2ent"
			
		, true );

		pos = theCamera.GetCameraPosition();

		pos.Z += 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			ent = theGame.CreateEntity( temp, spawnPos, adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			((CActor)ent).DrainEssence( ((CActor)ent).GetStatMax(BCS_Essence) * 0.5 );

			ent.AddTag('NoBestiaryEntry');

			ent.AddTag( 'ACS_Siren_Miniboss' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Cultist_Siren_Spawn_Engage in cACS_Cultist_Spawner
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var pos, spawnPos													: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var playerRot, adjustedRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Cultist_Siren_Spawn_Entry();
	}
	
	entry function Cultist_Siren_Spawn_Entry()
	{	
		Cultist_Siren_Spawn_Latent();
	}
	
	latent function Cultist_Siren_Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"characters\npc_entities\monsters\siren_lvl1.w2ent"
			
		, true );

		pos = theCamera.GetCameraPosition();

		pos.Z += 5;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			ent = theGame.CreateEntity( temp, spawnPos, adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).DrainEssence( ((CActor)ent).GetStatMax(BCS_Essence) * 0.5 );

			ent.AddTag('NoBestiaryEntry');

			ent.AddTag( 'ACS_Siren' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Cultist_Force_Attitude()
{
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Cultist', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);
	}

	ACS_Cultist_Singer_Song();
}

function ACS_Cultist_Singer_Song()
{
	var actors, actorsCultists 							: array<CActor>;
	var i, j												: int;
	var animcomp 										: CAnimatedComponent;
	var anim_names										: array< name >;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Cultist_Singer', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	else
	{
		if (ACS_cultist_singer_can_sing())
		{
			ACS_refresh_cultist_singer_song_cooldown();

			for( i = 0; i < actors.Size(); i += 1 )
			{
				if (actors[i].IsAlive())
				{
					animcomp = (CAnimatedComponent)actors[i].GetComponentByClassName('CAnimatedComponent');

					anim_names.Clear();

					anim_names.PushBack('woman_work_stand_praying_loop_01');
					anim_names.PushBack('woman_work_stand_praying_loop_02');
					anim_names.PushBack('woman_work_stand_praying_loop_03');

					animcomp.PlaySlotAnimationAsync ( anim_names[RandRange(anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					actors[i].SoundEvent("qu_sk_210_siren_singing");

					actors[i].SoundEvent("qu_sk_210_siren_singing_alt");

					actorsCultists.Clear();
	
					actorsCultists = actors[i].GetNPCsAndPlayersInRange( 15, 15, , FLAG_ExcludePlayer );

					if( actorsCultists.Size() > 0 )
					{
						for( j = 0; j < actorsCultists.Size(); j += 1 )
						{
							if (actorsCultists[j].HasTag('ACS_Cultist')
							|| actorsCultists[j].HasTag('ACS_Cultist_Boss')
							)
							{
								actorsCultists[j].GainStat(BCS_Essence, actorsCultists[j].GetStatMax(BCS_Essence) * 0.05 );

								actorsCultists[j].GainStat( BCS_Morale, actorsCultists[j].GetStatMax( BCS_Morale ) );  

								actorsCultists[j].GainStat( BCS_Focus, actorsCultists[j].GetStatMax( BCS_Focus ) );  
									
								actorsCultists[j].GainStat( BCS_Stamina, actorsCultists[j].GetStatMax( BCS_Stamina ) );
							}
						}
					}
				}
			}
		}
	}
}

function GetACSCultistSinger() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Cultist_Singer' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSPirateZombie() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Pirate_Zombie' );
	return entity;
}

function GetACSPirateZombieSwordTrail() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Pirate_Zombie_Trail' );
	return entity;
}

function GetACSPirateZombieChestBone1() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Pirate_Zombie_Chest_Bone_1' );
	return entity;
}

function GetACSPirateZombieChestBone2() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Pirate_Zombie_Chest_Bone_2' );
	return entity;
}

function GetACSPirateZombieChestBone3() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Pirate_Zombie_Chest_Bone_3' );
	return entity;
}

function GetACSPirateZombieChestBone4() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Pirate_Zombie_Chest_Bone_4' );
	return entity;
}

function ACS_PirateZombieController()
{
	if (GetACSPirateZombie())
	{
		if (GetACSPirateZombie().IsEffectActive('special_attack_fx'))
		{
			GetACSPirateZombie().StopEffect('special_attack_fx');
		}

		if (GetACSPirateZombie().IsEffectActive('special_attack_only_black_fx'))
		{
			GetACSPirateZombie().StopEffect('special_attack_only_black_fx');
		}
	}
	else
	{
		return;
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_Svalblod_Bear_Spawn()
{
	var vACS_Svalblod_Spawn : cACS_Svalblod_Spawn;
	vACS_Svalblod_Spawn = new cACS_Svalblod_Spawn in theGame;
			
	vACS_Svalblod_Spawn.ACS_Svalblod_Bear_Spawn_Engage();
}

statemachine class cACS_Svalblod_Spawn
{
	function ACS_Svalblod_Bear_Spawn_Engage()
	{
		this.PushState('ACS_Svalblod_Bear_Spawn_Engage');
	}
}

state ACS_Svalblod_Bear_Spawn_Engage in cACS_Svalblod_Spawn
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count, j														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot							: EulerAngles;	
	var animatedComponentA												: CAnimatedComponent;
	var targetDistance													: float;
	var movementAdjustor												: CMovementAdjustor;
	var ticket 															: SMovementAdjustmentRequestTicket;
	var l_comp : array< CComponent >;
	var size : int;
	var p_comp				: CComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Svalblod_Bear_Spawn_Entry();
	}
	
	entry function Svalblod_Bear_Spawn_Entry()
	{	
		Svalblod_Bear_Spawn_Latent();
	}
	
	latent function Svalblod_Bear_Spawn_Latent()
	{
		GetACSSvalblodBossbar().BreakAttachment();

		GetACSSvalblodBear().Destroy();

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\monsters\svalblod.w2ent"
			
		, true );

		playerPos = GetACSSvalblod().GetWorldPosition();

		playerRot = GetACSSvalblod().GetWorldRotation();

		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.5;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).SetCanPlayHitAnim(false);

			((CActor)ent).AddBuffImmunity_AllNegative('acs_svalblod_buff_all_negative', true); 
			((CActor)ent).AddBuffImmunity_AllCritical('acs_svalblod_buff_all_critical', true); 

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).SetHealth(GetACSSvalblodBossbar().GetCurrentHealth());

			//((CActor)ent).AddTag('ACS_Big_Boi');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag('NoBestiaryEntry');

			ent.PlayEffectSingle('suck_out');

			ent.PlayEffectSingle('smoke_explosion');

			ent.PlayEffectSingle('demonic_possession');

			ent.PlayEffectSingle('him_smoke_swirl');

			ent.PlayEffectSingle('him_smoke_swirl_black');

			ent.PlayEffectSingle('glow_normal');

			((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

			ent.AddTag( 'ACS_Svalblod_Bear' );

			ent.AddTag( 'ACS_Big_Boi' );



			GetACSSvalblodBossbar().CreateAttachment( ent , , Vector(0,0,5) );

			GetACSSvalblod().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));



			animatedComponentA = (CAnimatedComponent)((CNewNPC)ent).GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponentA.PlaySlotAnimationAsync ( 'bear_counter_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));


			movementAdjustor = ((CNewNPC)ent).GetMovingAgentComponent().GetMovementAdjustor();

			ticket = movementAdjustor.GetRequest( 'ACS_Svalblod_Bear_Rotate');
			movementAdjustor.CancelByName( 'ACS_Svalblod_Bear_Rotate' );
			movementAdjustor.CancelAll();

			ticket = movementAdjustor.CreateNewRequest( 'ACS_Svalblod_Bear_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.1 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );

			movementAdjustor.RotateTowards(ticket, thePlayer);

			targetDistance = VecDistanceSquared2D( ent.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

			if (targetDistance <= 4 * 4 && GetWitcherPlayer().IsOnGround())
			{
				movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

				ticket = movementAdjustor.GetRequest( 'ACS_Svalblod_Bear_Knockdown_Rotate');
				movementAdjustor.CancelByName( 'ACS_Svalblod_Bear_Knockdown_Rotate' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Svalblod_Bear_Knockdown_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.1 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );

				movementAdjustor.RotateTowards(ticket, ((CActor)ent));

				if (!GetWitcherPlayer().HasBuff(EET_HeavyKnockdown))
				{
					GetWitcherPlayer().AddEffectDefault( EET_HeavyKnockdown, ((CNewNPC)ent), 'ACS_Svalblod_Bear' );
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSSvalblod() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Svalblod' );
	return entity;
}


function GetACSSvalblodBear() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Svalblod_Bear' );
	return entity;
}


function GetACSSvalblodBossbar() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Svalblod_Bossbar' );
	return entity;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Berserker_Bear_Spawn( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var spawnPos														: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;
	var animatedComponentA												: CAnimatedComponent;
	var movementAdjustor												: CMovementAdjustor;
	var ticket 															: SMovementAdjustmentRequestTicket;
	var targetDistance													: float;
	var attack_anim_names												: array<EAttackType>;
	var l_aiTree														: CAIExecuteAttackAction;

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\berserkers_bear.w2ent"
		
	, true );

	adjustedRot = npc.GetWorldRotation();

	ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(pos), adjustedRot );

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');
	h = 1.125;
	animcomp.SetScale(Vector(h,h,h,1));
	meshcomp.SetScale(Vector(h,h,h,1));	

	((CNewNPC)ent).SetLevel(npc.GetLevel());

	((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
	((CActor)ent).SetAnimationSpeedMultiplier(1.5);

	ent.PlayEffectSingle('suck_out');
	ent.PlayEffectSingle('smoke_explosion');

	((CActor)ent).SetCanPlayHitAnim(false);

	((CActor)ent).AddTag( 'ContractTarget' );

	((CActor)ent).AddTag('IsBoss');

	((CActor)ent).AddAbility('Boss');

	((CActor)ent).AddAbility('BounceBoltsWildhunt');

	ent.AddTag('NoBestiaryEntry');

	((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Berserkers_Bear_Buff', true);

	((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Berserkers_Bear_Buff', true);

	if (npc.HasTag('ACS_Berserker_Transform_Stage_1'))
	{
		((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence) * 0.75);
	}
	else
	{
		((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence) * 0.5);
	}

	movementAdjustor = ((CNewNPC)ent).GetMovingAgentComponent().GetMovementAdjustor();

	ticket = movementAdjustor.GetRequest( 'ACS_Berserker_Bear_Rotate');
	movementAdjustor.CancelByName( 'ACS_Berserker_Bear_Rotate' );
	movementAdjustor.CancelAll();

	ticket = movementAdjustor.CreateNewRequest( 'ACS_Berserker_Bear_Rotate' );
	movementAdjustor.AdjustmentDuration( ticket, 0.1 );
	movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000000 );

	movementAdjustor.RotateTowards(ticket, thePlayer);


	l_aiTree = new CAIExecuteAttackAction in ((CActor)ent);
	l_aiTree.OnCreated();

	attack_anim_names.Clear();

	attack_anim_names.PushBack(EAT_Attack1);
	attack_anim_names.PushBack(EAT_Attack2);
	attack_anim_names.PushBack(EAT_Attack3);
	attack_anim_names.PushBack(EAT_Attack4);
	attack_anim_names.PushBack(EAT_Attack5);
	attack_anim_names.PushBack(EAT_Attack6);

	l_aiTree.attackParameter = attack_anim_names[RandRange(attack_anim_names.Size())];

	((CActor)ent).ForceAIBehavior( l_aiTree, BTAP_AboveCombat2);

	theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( ((CActor)ent), 'AttackAction', 1.0, 1.0f, 999.0f, 1, true); 

	((CNewNPC)((CActor)ent)).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

	npc.Teleport(thePlayer.GetWorldPosition() + Vector(0,0, -200));

	npc.DestroyAfter(0.1);

	ent.AddTag( 'ACS_Berserkers_Bear' );

	ent.AddTag('ACS_Hostile_To_All');
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Duskwraith_Spawner
{
	function ACS_Duskwraith_Skeletons_Spawner_Engage()
	{
		this.PushState('ACS_Duskwraith_Skeletons_Spawner_Engage');
	}
}

state ACS_Duskwraith_Skeletons_Spawner_Engage in cACS_Duskwraith_Spawner
{
	private var temp, temp_2, temp_3, ent_1_temp								: CEntityTemplate;
	private var ent, ent_2, ent_3												: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var targetRotationNPC, rot, attach_rot, playerRot, adjustedRot					: EulerAngles;
	private var tomb_names														: array< string >;
	private var tomb_temp_1, tomb_temp_2										: CEntityTemplate;
	private var tomb_ent_1,tomb_ent_2											: CEntity;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Skeletons_Entry();
	}
	
	entry function Spawn_Skeletons_Entry()
	{	
		Spawn_Skeletons_Latent();
	}

	latent function tomb_names_array()
	{
		tomb_names.Clear();
		//tomb_names.PushBack("dlc\bob\data\environment\decorations\gameplay\generic\stone\gravestones\entities\bob_tombstone_05.w2ent");
		//tomb_names.PushBack("dlc\bob\data\quests\minor_quests\quest_files\mq7017_talking_horse\entities\mq7017_tombstone.w2ent");
		tomb_names.PushBack("dlc\dlc_acs\data\entities\tombstones\tombstone_pillar.w2ent");
	}

	latent function Spawn_Skeletons_Latent()
	{
		playerPos = ACSDuskwraith().GetWorldPosition();

		playerRot = ACSDuskwraith().GetWorldRotation();

		count = 15;
			
		for( i = 0; i < count; i += 1 )
		{
			if( ACSDuskwraith().HasTag('ACS_Summoned_Skeletons_Primary') )
			{
				if( RandF() < 0.5 ) 
				{
					if( RandF() < 0.75 ) 
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\skele_1.w2ent"
							
						, true );
					}
					else
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\skele_2.w2ent"
							
						, true );
					}
				}
				else
				{
					if( RandF() < 0.75 ) 
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\noonwraith_lvl1.w2ent"
							
						, true );
					}
					else
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\nightwraith_lvl1.w2ent"
							
						, true );
					}
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					if( RandF() < 0.25 ) 
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\skele_1.w2ent"
							
						, true );
					}
					else
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\skele_2.w2ent"
							
						, true );
					}
				}
				else
				{
					if( RandF() < 0.25 ) 
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\noonwraith_lvl1.w2ent"
							
						, true );
					}
					else
					{
						temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\monsters\nightwraith_lvl1.w2ent"
							
						, true );
					}
				}
			}

			tomb_names_array();

			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddAbility('Boss');

			((CNewNPC)ent).SetAttitude(((CNewNPC)ACSDuskwraith()), AIA_Friendly);

			((CNewNPC)ACSDuskwraith()).SetAttitude(((CNewNPC)ent), AIA_Friendly);

			ent.AddTag('NoBestiaryEntry');

			targetRotationNPC = ((CActor)ent).GetWorldRotation();
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);


			tomb_temp_2 = (CEntityTemplate)LoadResourceAsync(tomb_names[RandRange(tomb_names.Size())], true);

			tomb_ent_2 = theGame.CreateEntity( tomb_temp_2, ACSPlayerFixZAxis(((CActor)ent).GetWorldPosition()), targetRotationNPC );

			tomb_ent_2.PlayEffect('marker_fx');

			tomb_ent_2.PlayEffect('circle_stone');

			tomb_ent_2.DestroyAfter(16);

			tomb_ent_2.AddTag( 'ACS_Duskwraith_Tombs' );


			tomb_temp_1 = (CEntityTemplate)LoadResourceAsync("dlc\bob\data\quests\minor_quests\quest_files\mq7017_talking_horse\entities\mq7017_fx_tomb.w2ent", true);

			tomb_ent_1 = theGame.CreateEntity( tomb_temp_1, tomb_ent_2.GetWorldPosition(), tomb_ent_2.GetWorldRotation() );

			tomb_ent_1.PlayEffect('fx');

			tomb_ent_1.DestroyAfter(16);

			tomb_ent_1.AddTag( 'ACS_Duskwraith_Tombs_FX' );






			ent.AddTag( 'ACS_Duskwraith_Skeleton' );
		}

		GetACSWatcher().RemoveTimer('ACS_Duskwraith_Skeletons_Despawn');

		GetACSWatcher().AddTimer('ACS_Duskwraith_Skeletons_Despawn', 20, false);
	}
}

function ACS_Duskwraith_Skeletons_Kill()
{	
	var skele 											: array<CActor>;
	var i												: int;
	
	skele.Clear();

	theGame.GetActorsByTag( 'ACS_Duskwraith_Skeleton', skele );	
	
	for( i = 0; i < skele.Size(); i += 1 )
	{
		skele[i].PlayEffectSingle('death_glow');
		skele[i].PlayEffectSingle('suck_into_painting');
		skele[i].Kill('ACS_Duskwraith_Skeleton_Despawn', true);
	}
}

function ACSDuskwraith() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Duskwraith' );
	return entity;
}

function ACS_DuskwraithManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSDuskwraith()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSDuskwraith().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( ACSDuskwraith().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	if (!ACSDuskwraith() || !ACSDuskwraith().IsAlive())
	{
		return;
	}

	if (ACSDuskwraith()
	&& ACSDuskwraith().IsAlive()
	&& ACSDuskwraith().IsInCombat()
	)
	{
		if (ACS_duskwraith_abilities()
		)
		{
			ACS_refresh_duskwraith_abilities_cooldown();

			if ( targetDistance >= 2 * 2 && targetDistance < 15 * 15 )
			{
				ACSDuskwraith().StopEffect('shadows_form_banshee');
				ACSDuskwraith().StopEffect('shadows_form_noonwraith_test');
				ACSDuskwraith().PlayEffectSingle('shadows_form_noonwraith');

				GetACSWatcher().RemoveTimer('ACS_Duskwraith_Shadowcloak');

				GetACSWatcher().AddTimer('ACS_Duskwraith_Shadowcloak', 4, false);

				ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Duskwraith_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_Duskwraith_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Duskwraith_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

				movementAdjustorNPC.RotateTowards( ticketNPC, thePlayer );

				ACSDuskwraith().SoundEvent("monster_banshee_combat_summoning");

				ACSDuskwraith().PlayEffectSingle('scream_summone');

				if( !ACSDuskwraith().HasTag('ACS_Summoned_Skeletons_Primary') )
				{

					ACSDuskwraith().AddTag('ACS_Summoned_Skeletons_Primary');
				}
				else
				{
					ACSDuskwraith().RemoveTag('ACS_Summoned_Skeletons_Primary');
				}

				GetACSWatcher().RemoveTimer('ACS_Duskwraith_Skeletons_Spawner_Delay');
				GetACSWatcher().AddTimer('ACS_Duskwraith_Skeletons_Spawner_Delay', 1, false);
			}
		}

		if (ACS_duskwraith_break_yrden())
		{
			ACS_refresh_duskwraith_break_yrden_cooldown();

			if ( targetDistance <= 15 * 15 )
			{
				if (!ACSDuskwraith().IsEffectActive('shadows_form_banshee', false))
				{
					ACS_FindAndStopNearYrdenEntities(ACSDuskwraith());
				}
				else
				{
					if(GetWitcherPlayer().IsAnyQuenActive())
					{
						ACSDuskwraith().StopEffect('scream_summone_orange');
						ACSDuskwraith().PlayEffectSingle('scream_summone_orange');

						GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');

						GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');

						GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');

						GetWitcherPlayer().StopEffect('lasting_shield_discharge');

						GetWitcherPlayer().FinishQuen(false);
					}
				}
			}
		}
	}
}

function ACS_FindAndStopNearYrdenEntities( npc : CActor )
{	
	var i						: int;
	var l_entities 				: array<CGameplayEntity>;
	var l_yrden					: W3YrdenEntity;
	var min, max 				: SAbilityAttributeValue;
	var yrden					: W3YrdenEntity;
	var yrdenIsActionTarget		: bool;
	var range					: float;
	var maxResults				: int;
	var onActivate				: bool;
	var onDeactivate			: bool;
	var onAnimEvent 			: bool;
	var eventName 				: name;
	var stopYrdenShock			: bool;
	
	npc.RemoveAllBuffsOfType( EET_Burning );
	npc.RemoveAllBuffsOfType( EET_Frozen );
	npc.RemoveAllBuffsOfType( EET_Bleeding );
	npc.RemoveAllBuffsOfType( EET_SlowdownFrost );
	npc.RemoveAllBuffsOfType( EET_Slowdown );
	
	l_entities.Clear();
	
	FindGameplayEntitiesInSphere( l_entities, npc.GetWorldPosition(), 20, -1 );

	if (l_entities.Size() > 0)
	{
		for( i = 0; i < l_entities.Size(); i += 1 )
		{
			l_yrden = (W3YrdenEntity) l_entities[i];
			
			if( l_yrden )
			{
				ACSDuskwraith().StopEffect('scream_summone_purple');
				ACSDuskwraith().PlayEffectSingle('scream_summone_purple');

				l_yrden.TimedCanceled( 0, 0 );
				l_yrden.OnSignAborted( true );
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSHostileToAllIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Hostile_To_All', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

					npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSFogAssassinIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Fog_Assassin', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Fog_Assassin_Doppleganger'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSSvalblodIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Svalblod', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Svalblod_Bossbar'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSSvalblodBearIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Svalblod_Bear', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Svalblod_Bossbar'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSCultistBossIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Cultist_Boss', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Cultist_Singer')
					|| npc.HasTag('ACS_Cultist')
					|| npc.HasTag('ACS_Cultist_Boss')
					|| npc.HasTag('ACS_Siren')
					|| npc.HasTag('ACS_Siren_Miniboss')
					|| npc.IsAnimal()
					)
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSCultistIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Cultist', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer);
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Cultist_Singer')
					|| npc.HasTag('ACS_Cultist_Boss')
					|| npc.HasTag('ACS_Cultist')
					|| npc.IsAnimal()
					)
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSMegaWraithIdleAction()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;

	var actor, actor2									: CActor; 
	var actors2		    								: array<CActor>;
	var j												: int;

	var npc, npc_1										: CNewNPC;
	var movementAdjustorBigWraith						: CMovementAdjustor;
	var ticket_1										: SMovementAdjustmentRequestTicket;

	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_MegaWraith', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}

	if ( ((CActor)(GetACSMegaWraith().GetTarget())) )
	{
		targetDistance = VecDistanceSquared2D( ((CActor)(GetACSMegaWraith().GetTarget())).GetWorldPosition(), GetACSMegaWraith().GetWorldPosition() ) ;

		movementAdjustorBigWraith = GetACSMegaWraith().GetMovingAgentComponent().GetMovementAdjustor();

		ticket_1 = movementAdjustorBigWraith.GetRequest( 'ACS_MegaWraith_Rotate');
		movementAdjustorBigWraith.CancelByName( 'ACS_MegaWraith_Rotate' );
		movementAdjustorBigWraith.CancelAll();

		ticket_1 = movementAdjustorBigWraith.CreateNewRequest( 'ACS_MegaWraith_Rotate' );
		movementAdjustorBigWraith.AdjustmentDuration( ticket_1, 1 );

		movementAdjustorBigWraith.MaxRotationAdjustmentSpeed( ticket_1, 50000000 );

		if (targetDistance <= 4*4)
		{
			movementAdjustorBigWraith.RotateTowards(ticket_1, ((CActor)(GetACSMegaWraith().GetTarget())));
		}
		else
		{
			movementAdjustorBigWraith.CancelByName( 'ACS_MegaWraith_Rotate' );
		}
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		npc = (CNewNPC)actors[i];

		actor = actors[i];

		if (!npc.IsAlive())
		{
			return;
		}

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc_1 = (CNewNPC)actors2[j];

					actor2 = actors2[j];

					if (npc_1.IsAnimal()
					|| npc_1.HasTag('ACS_MegaWraith_Minion')
					)
					{
						((CNewNPC)actors[i]).SetAttitude(npc_1, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc_1, AIA_Hostile);

						npc_1.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSInfectedPrimeIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Infected_Prime', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Infected_Prime')
					|| npc.HasTag('ACS_Infected_Spawn')
					)
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Neutral);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Neutral);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSInfectedSpawnIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Infected_Spawn', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Infected_Prime')
					|| npc.HasTag('ACS_Infected_Spawn')
					)
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Neutral);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Neutral);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSNecrofiendIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Necrofiend', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (actors[i].IsAlive())
		{
			actors[i].StopEffect('spike');
			actors[i].PlayEffect('spike');

			actors[i].StopEffect('spikes_explode_after');
			actors[i].PlayEffect('spikes_explode_after');
		}
		else
		{
			return;
		}

		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Necrofiend')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_4')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_3')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_2')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_1')
					|| npc.HasTag('ACS_Necrofiend_Adds')
					)
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSNecrofiendSpawnsIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Necrofiend_Adds', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (actors[i].IsAlive())
		{
			actors[i].StopEffect('spike');
			actors[i].PlayEffect('spike');

			actors[i].StopEffect('spikes_explode_after');
			actors[i].PlayEffect('spikes_explode_after');
		}
		else
		{
			return;
		}

		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Necrofiend')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_4')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_3')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_2')
					|| npc.HasTag('ACS_Necrofiend_Tentacle_1')
					|| npc.HasTag('ACS_Necrofiend_Adds')
					)
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function ACS_Shades_Item_Check ( id : SItemUniqueId ) : bool
{
	if 
	(
	thePlayer.GetInventory().ItemHasTag(id,'ironshade') 
	)
	{
		return true; 
	}
	
	return false;
}

function ACS_ShadesItemEquippedCheck() : bool
{
	var equippedItemsId 		: array<SItemUniqueId>;
	var i 						: int;
	
	equippedItemsId.Clear();

	equippedItemsId = GetWitcherPlayer().GetEquippedItems();

	for ( i=0; i < equippedItemsId.Size() ; i+=1 ) 
	{
		if (ACS_Shades_Item_Check(equippedItemsId[i])
		)
		{
			return true;
		} 	
	}
	
	return false;
}

function GetACSShadesHunterIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;
	var targetDistance 									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Shades_Hunter', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (ACS_ShadesItemEquippedCheck())
		{
			((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);
		}
		else
		{
			targetDistance = VecDistanceSquared2D( ((CNewNPC)actors[i]).GetWorldPosition(), thePlayer.GetWorldPosition() ) ;

			if (targetDistance <= 4 * 4)
			{
				((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);
			}
		}
		
		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Shades_Hunter'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSShadesRogueIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Shades_Rogue', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Shades_Rogue'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSShadesRogueEnemiesIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Shades_Rogue_Enemies', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Shades_Rogue_Enemies'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSShadowPixieIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Shadow_Pixie', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Shadow_Pixie')
					|| npc.HasTag('ACS_Pixie_Guardian')
					)
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSPlumardIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Plumard', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Plumard'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSMaerolornIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Maerolorn', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Maerolorn'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

function GetACSHellhoundIdleAction()
{	
	var actors, actors2 								: array<CActor>;
	var i												: int;
	var actor											: CActor; 
	var j												: int;
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Hellhound_Pack', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		((CNewNPC)actors[i]).SetAttitude(thePlayer, AIA_Hostile);

		actors2.Clear();

		actors2 = actors[i].GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer  );
		{
			if( actors2.Size() > 0 )
			{
				for( j = 0; j < actors2.Size(); j += 1 )
				{
					npc = (CNewNPC)actors2[j];

					actor = actors2[j];

					if (npc.HasTag('ACS_Hellhound_Pack'))
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Friendly);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Friendly);
					}
					else
					{
						((CNewNPC)actors[i]).SetAttitude(npc, AIA_Hostile);

						npc.SetAttitude(((CNewNPC)actors[i]), AIA_Hostile);
					}
				}
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Draug_Spawner
{
	function ACS_Draug_Swap_To_Close_Range_Engage()
	{
		this.PushState('ACS_Draug_Swap_To_Close_Range_Engage');
	}

	function ACS_Draug_Swap_To_Far_Range_Engage()
	{
		this.PushState('ACS_Draug_Swap_To_Far_Range_Engage');
	}
}

state ACS_Draug_Swap_To_Close_Range_Engage in cACS_Draug_Spawner
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count, j														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot							: EulerAngles;
	var p_actor 														: CActor;
	var p_comp															: CComponent;
	var l_comp 															: array< CComponent >;
	var size 															: int;

	event OnEnterState(prevStateName : name)
	{
		Draug_Swap_To_Close_Range_Entry();
	}
	
	entry function Draug_Swap_To_Close_Range_Entry()
	{	
		Draug_Swap_To_Close_Range_Latent();
	}

	latent function Draug_Swap_To_Close_Range_Latent()
	{
		p_actor = ACSDraug();

		p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

		temp = (CEntityTemplate)LoadResourceAsync(

		"dlc\dlc_acs\data\models\draug\anchor_static.w2ent"
		
		, true);

		//((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

		l_comp = ((CActor)ACSDraug()).GetComponentsByClassName( 'CMorphedMeshManagerComponent' );
		size = l_comp.Size();

		for ( j=0; j<size; j+= 1 )
		{
			((CMorphedMeshManagerComponent)l_comp[ j ]).SetMorphBlend( 0, 0.001 );
		}

		GetACSDraugFakeAnchor().Destroy();

		sword_trail_1 = (CEntity)theGame.CreateEntity( temp, ACSDraug().GetWorldPosition() + Vector( 0, 0, -20 ) );

		sword_trail_1.CreateAttachment(ACSDraug(), 'r_weapon', Vector(0,0,-3));

		sword_trail_1.AddTag('ACS_Draug_Fake_Anchor');

		sword_trail_1.PlayEffect('lugos_vision_burning_mat');

		ACSDraug().PlayEffectSingle('earthquake_fx');
		ACSDraug().StopEffect('earthquake_fx');
	}
}

state ACS_Draug_Swap_To_Far_Range_Engage in cACS_Draug_Spawner
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count,j														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot							: EulerAngles;
	var p_actor 														: CActor;
	var p_comp															: CComponent;
	var l_comp 															: array< CComponent >;
	var size 															: int;
	var draugAnimatedComponentA											: CAnimatedComponent;
	var movementAdjustorNPC												: CMovementAdjustor;
	var ticketNPC 														: SMovementAdjustmentRequestTicket; 
	var targetDistance													: float;
	

	event OnEnterState(prevStateName : name)
	{
		Draug_Swap_To_Far_Range_Entry();
	}
	
	entry function Draug_Swap_To_Far_Range_Entry()
	{	
		Draug_Swap_To_Far_Range_Latent();
	}

	latent function Draug_Swap_To_Far_Range_Latent()
	{
		//p_actor = ACSDraug();

		//p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

		//temp = (CEntityTemplate)LoadResourceAsync(

		//"items\weapons\unique\anchor__giant_weapon.w2ent"
		
		//, true);

		l_comp = ((CActor)ACSDraug()).GetComponentsByClassName( 'CMorphedMeshManagerComponent' );
		size = l_comp.Size();

		for ( j=0; j<size; j+= 1 )
		{
			((CMorphedMeshManagerComponent)l_comp[ j ]).SetMorphBlend( 1, 0.001 );
		}

		GetACSDraugFakeAnchor().BreakAttachment();

		GetACSDraugFakeAnchor().Teleport(ACSDraug().GetWorldPosition() + Vector(0,0,-200));

		GetACSDraugFakeAnchor().DestroyAfter(0.001);

		//((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

		ACSDraug().PlayEffectSingle('earthquake_fx');
		ACSDraug().StopEffect('earthquake_fx');

		movementAdjustorNPC = ACSDraug().GetMovingAgentComponent().GetMovementAdjustor();

		ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Draug_Rotate');
		movementAdjustorNPC.CancelByName( 'ACS_Draug_Rotate' );
		movementAdjustorNPC.CancelAll();

		ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Draug_Rotate' );
		movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.5 );
		movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

		movementAdjustorNPC.RotateTowards( ticketNPC, ((CActor)(ACSDraug().GetTarget())) );

		draugAnimatedComponentA = (CAnimatedComponent)((CNewNPC)ACSDraug()).GetComponentByClassName( 'CAnimatedComponent' );	

		targetDistance = VecDistanceSquared2D( ACSDraug().GetWorldPosition(), ((CActor)(ACSDraug().GetTarget())).GetWorldPosition() );

		if ( targetDistance <= 6 * 6 )
		{
			draugAnimatedComponentA.PlaySlotAnimationAsync ( 'giant_combat_anchor_attack_far_f', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));
		}
		else if ( targetDistance > 6 * 6 )
		{
			draugAnimatedComponentA.PlaySlotAnimationAsync ( 'giant_combat_anchor_attack_distance', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));
		}
	}
}

function ACS_DraugManager()
{
	var animatedComponentA																									: CAnimatedComponent;
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;

	animatedComponentA = (CAnimatedComponent)((CNewNPC)ACSDraug()).GetComponentByClassName( 'CAnimatedComponent' );	

	movementAdjustorNPC = ACSDraug().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( ACSDraug().GetWorldPosition(), ((CActor)(ACSDraug().GetTarget())).GetWorldPosition() );

	if (!ACSDraug() || !ACSDraug().IsAlive())
	{
		return;
	}

	if (ACSDraug()
	&& ACSDraug().IsAlive()
	&& ACSDraug().IsInCombat()
	)
	{
		if (ACS_draug_ability())
		{
			ACS_refresh_draug_ability_cooldown();

			ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Draug_Rotate');
			movementAdjustorNPC.CancelByName( 'ACS_Draug_Rotate' );
			movementAdjustorNPC.CancelAll();

			ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Draug_Rotate' );
			movementAdjustorNPC.AdjustmentDuration( ticketNPC, 1 );
			movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

			movementAdjustorNPC.RotateTowards( ticketNPC, ((CActor)(ACSDraug().GetTarget())) );

			GetACSWatcher().RemoveTimer('ACS_Draug_Anchor_Respawn');

			if ( targetDistance <= 6 * 6 )
			{
				GetACSWatcher().DraugAttacks_CloseRange();
			}
			else if ( targetDistance > 6 * 6 && targetDistance <= 25 * 25 )
			{
				GetACSWatcher().DraugAttacks_FarRange();
			}
			else if ( targetDistance > 25 * 25 )
			{
				GetACSWatcher().ACS_Draug_Swap_Close_Range();

				GetACSWatcher().AddTimer('ACS_Draug_Anchor_Respawn', 3, false);

				animatedComponentA.PlaySlotAnimationAsync ( 'giant_combat_attack_charge', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
			}
		}
	}
}

function ACSDraug() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Draug' );
	return entity;
}

function GetACSDraugFakeAnchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Draug_Fake_Anchor' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_MegaWraith_Spawner
{
	function ACS_MegaWraith_SpawnAdds_Engage()
	{
		this.PushState('ACS_MegaWraith_SpawnAdds_Engage');
	}
}

state ACS_MegaWraith_SpawnAdds_Engage in cACS_MegaWraith_Spawner
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var pos, spawnPos													: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h, dist 														: float;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot							: EulerAngles;
	var movementAdjustorBigWraith, movementAdjustorLittleWraith			: CMovementAdjustor;
	var ticket_1, ticket_2												: SMovementAdjustmentRequestTicket;	
	var animatedComponentA												: CAnimatedComponent;
	var attack_anim_names												: array<EAttackType>;
	var l_aiTree														: CAIExecuteAttackAction;

	event OnEnterState(prevStateName : name)
	{
		Spawn_MegaWraith_Adds_Entry();
	}
	
	entry function Spawn_MegaWraith_Adds_Entry()
	{	
		Spawn_MegaWraith_Adds_Latent();
	}

	latent function Spawn_MegaWraith_Adds_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\mega_wraith_minion.w2ent"
			
		, true );

		pos = ((CActor)(GetACSMegaWraith().GetTarget())).PredictWorldPosition(0.35);

		playerRot = GetACSMegaWraith().GetWorldRotation();

		count = RandRange(3,2);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 4.5 + 4.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1.5);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			//((CActor)ent).AddTag('ACS_Big_Boi');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag('NoBestiaryEntry');

			ent.PlayEffectSingle('appear');

			//ent.PlayEffectSingle('disappear');

			ent.PlayEffectSingle('shadows_form');

			ent.AddTag( 'ACS_MegaWraith_Minion' );

			((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
			((CActor)ent).SetCanPlayHitAnim(false); 

			((CActor)ent).AddBuffImmunity_AllNegative('acs_mega_wraith_dummy_buff_negative', true); 
			((CActor)ent).AddBuffImmunity_AllCritical('acs_mega_wraith_dummy_buff_critical', true); 

			GetACSWatcher().RemoveTimer('MegaWraithMinionDisppearEffect');
			GetACSWatcher().AddTimer('MegaWraithMinionDisppearEffect', 0.5, false);

			dist = ((((CMovingPhysicalAgentComponent)((CActor)ent).GetMovingAgentComponent()).GetCapsuleRadius())
			+ (((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) ) * 1.25;

			movementAdjustorBigWraith = ((CActor)ent).GetMovingAgentComponent().GetMovementAdjustor();

			ticket_1 = movementAdjustorBigWraith.GetRequest( 'ACS_MegaWraith_Minion_Rotate');
			movementAdjustorBigWraith.CancelByName( 'ACS_MegaWraith_Minion_Rotate' );
			movementAdjustorBigWraith.CancelAll();

			ticket_1 = movementAdjustorBigWraith.CreateNewRequest( 'ACS_MegaWraith_Minion_Rotate' );
			movementAdjustorBigWraith.AdjustmentDuration( ticket_1, 1 );

			movementAdjustorBigWraith.MaxRotationAdjustmentSpeed( ticket_1, 50000000 );

			movementAdjustorBigWraith.MaxLocationAdjustmentSpeed( ticket_1, 50 );

			movementAdjustorBigWraith.MaxLocationAdjustmentDistance(ticket_1, true, 4.5);

			movementAdjustorBigWraith.Continuous(ticket_1);

			movementAdjustorBigWraith.RotateTowards(ticket_1, ((CActor)(GetACSMegaWraith().GetTarget())));

			movementAdjustorBigWraith.SlideTowards(ticket_1, ((CActor)(GetACSMegaWraith().GetTarget())), dist, dist);


			l_aiTree = new CAIExecuteAttackAction in ((CActor)ent);
			l_aiTree.OnCreated();

			attack_anim_names.Clear();

			attack_anim_names.PushBack(EAT_Attack1);
			attack_anim_names.PushBack(EAT_Attack2);
			attack_anim_names.PushBack(EAT_Attack3);
			attack_anim_names.PushBack(EAT_Attack4);
			attack_anim_names.PushBack(EAT_Attack5);
			attack_anim_names.PushBack(EAT_Attack6);

			l_aiTree.attackParameter = attack_anim_names[RandRange(attack_anim_names.Size())];

			((CActor)ent).ForceAIBehavior( l_aiTree, BTAP_AboveCombat2);

			theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( ((CActor)ent), 'AttackAction', 1.0, 1.0f, 999.0f, 1, true); 

			((CNewNPC)((CActor)ent)).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		}
	}
}

function GetACSMegaWraith() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_MegaWraith' );
	return entity;
}

function GetACSMegaWraithLWeapon() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_MegaWraith_L_Weapon' );
	return entity;
}

function GetACSMegaWraithRWeapon() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_MegaWraith_R_Weapon' );
	return entity;
}

function GetACSMegaWraithDummyDisappearAction()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;
	var actor											: CActor; 
	var npc												: CNewNPC;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_MegaWraith_Minion', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		npc = (CNewNPC)actors[i];

		actor = actors[i];

		actor.StopAllEffects();
		//actor.PlayEffectSingle('appear');
		actor.PlayEffectSingle('disappear');

		actor.DestroyAfter(0.5);
	}
}

function GetACSMegaWraithSwordHide()
{	
	var actors 											: array<CActor>;
	var i												: int;
	var animatedComponentA								: CAnimatedComponent;

	var actor, actor2									: CActor; 
	var actors2		    								: array<CActor>;
	var j												: int;

	var npc, npc_1										: CNewNPC;
	var movementAdjustorBigWraith						: CMovementAdjustor;
	var ticket_1										: SMovementAdjustmentRequestTicket;

	var targetDistance									: float;

	actors.Clear();

	theGame.GetActorsByTag( 'ACS_MegaWraith', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		npc = (CNewNPC)actors[i];

		actor = actors[i];

		if (!npc.IsAlive())
		{
			return;
		}

		if (npc.IsEffectActive('appear', false))
		{
			if (!npc.IsEffectActive('demonic_possession', false))
			{
				npc.PlayEffectSingle('demonic_possession');
			}

			if (!npc.IsEffectActive('critical_burning_green_ex', false))
			{
				npc.PlayEffectSingle('critical_burning_green_ex');
			}

			if (!npc.IsEffectActive('critical_burning_green_ex_r', false))
			{
				npc.PlayEffectSingle('critical_burning_green_ex_r');
			}

			if (!npc.IsEffectActive('candle', false))
			{
				npc.PlayEffectSingle('candle');
			}

			if (!GetACSMegaWraithRWeapon().IsEffectActive('runeword1_fire_trail_green', false))
			{
				GetACSMegaWraithRWeapon().PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!GetACSMegaWraithRWeapon().IsEffectActive('runeword_quen', false))
			{
				GetACSMegaWraithRWeapon().PlayEffectSingle('runeword_quen');
			}

			if (!GetACSMegaWraithLWeapon().IsEffectActive('runeword1_fire_trail_green', false))
			{
				GetACSMegaWraithLWeapon().PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!GetACSMegaWraithLWeapon().IsEffectActive('runeword_quen', false))
			{
				GetACSMegaWraithLWeapon().PlayEffectSingle('runeword_quen');
			}

			GetACSMegaWraithLWeapon().CreateAttachment(GetACSMegaWraith(), 'attach_slot_l', Vector(0.1,-0.025,0), EulerAngles(180,0,0));

			GetACSMegaWraithRWeapon().CreateAttachment(GetACSMegaWraith(), 'attach_slot_r', Vector(0.1,0.025,0), EulerAngles(0,0,0));

			return;
		}

		if (!npc.IsEffectActive('disappear', false))
		{
			if (!npc.IsEffectActive('demonic_possession', false))
			{
				npc.PlayEffectSingle('demonic_possession');
			}

			if (!npc.IsEffectActive('critical_burning_green_ex', false))
			{
				npc.PlayEffectSingle('critical_burning_green_ex');
			}

			if (!npc.IsEffectActive('critical_burning_green_ex_r', false))
			{
				npc.PlayEffectSingle('critical_burning_green_ex_r');
			}

			if (!npc.IsEffectActive('candle', false))
			{
				npc.PlayEffectSingle('candle');
			}

			if (!GetACSMegaWraithRWeapon().IsEffectActive('runeword1_fire_trail_green', false))
			{
				GetACSMegaWraithRWeapon().PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!GetACSMegaWraithRWeapon().IsEffectActive('runeword_quen', false))
			{
				GetACSMegaWraithRWeapon().PlayEffectSingle('runeword_quen');
			}

			if (!GetACSMegaWraithLWeapon().IsEffectActive('runeword1_fire_trail_green', false))
			{
				GetACSMegaWraithLWeapon().PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!GetACSMegaWraithLWeapon().IsEffectActive('runeword_quen', false))
			{
				GetACSMegaWraithLWeapon().PlayEffectSingle('runeword_quen');
			}

			GetACSMegaWraithLWeapon().CreateAttachment(GetACSMegaWraith(), 'attach_slot_l', Vector(0.1,-0.025,0), EulerAngles(180,0,0));

			GetACSMegaWraithRWeapon().CreateAttachment(GetACSMegaWraith(), 'attach_slot_r', Vector(0.1,0.025,0), EulerAngles(0,0,0));
		}
		else
		{
			npc.DestroyEffect('demonic_possession');

			npc.DestroyEffect('critical_burning_green_ex');

			npc.DestroyEffect('critical_burning_green_ex_r');

			npc.DestroyEffect('candle');

			

			GetACSMegaWraithLWeapon().DestroyEffect('igni_power_green');

			GetACSMegaWraithLWeapon().DestroyEffect('quen_power');

			GetACSMegaWraithLWeapon().DestroyEffect('runeword1_fire_trail_green');

			GetACSMegaWraithLWeapon().DestroyEffect('runeword_quen');

			GetACSMegaWraithLWeapon().DestroyEffect('runeword_igni_green');

			GetACSMegaWraithLWeapon().DestroyEffect('light_trail_extended_fx');

			GetACSMegaWraithLWeapon().DestroyEffect('wraith_trail');

			GetACSMegaWraithLWeapon().DestroyEffect('special_trail_fx');



			GetACSMegaWraithRWeapon().DestroyEffect('igni_power_green');

			GetACSMegaWraithRWeapon().DestroyEffect('quen_power');

			GetACSMegaWraithRWeapon().DestroyEffect('runeword1_fire_trail_green');

			GetACSMegaWraithRWeapon().DestroyEffect('runeword_quen');

			GetACSMegaWraithRWeapon().DestroyEffect('runeword_igni_green');

			GetACSMegaWraithRWeapon().DestroyEffect('light_trail_extended_fx');

			GetACSMegaWraithRWeapon().DestroyEffect('wraith_trail');

			GetACSMegaWraithRWeapon().DestroyEffect('special_trail_fx');




			GetACSMegaWraithLWeapon().BreakAttachment();

			GetACSMegaWraithLWeapon().Teleport(GetACSMegaWraith().GetWorldPosition() + Vector(0,0,-200));

			GetACSMegaWraithRWeapon().BreakAttachment();

			GetACSMegaWraithRWeapon().Teleport(GetACSMegaWraith().GetWorldPosition() + Vector(0,0,-200));
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSFireGryphon() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Fire_Gryphon' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSMula() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Mula' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Spawn_Big_Hym( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var playerRot, adjustedRot											: EulerAngles;
	var ticket															: SMovementAdjustmentRequestTicket;	
	var p_comp															: CComponent;
	var movementAdjustor												: CMovementAdjustor;

	GetACSWatcher().MiniHymSizeSpeedReset();

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\giant_hym.w2ent"
		
	, true );

	playerRot = thePlayer.GetWorldRotation();

	playerRot.Yaw += 180;

	adjustedRot = EulerAngles(0,0,0);

	adjustedRot.Yaw = playerRot.Yaw;
	
	count = 1;
		
	for( i = 0; i < count; i += 1 )
	{
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(pos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.375;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.5);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Big_Hym_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		//((CActor)ent).RemoveAbility('Venom');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession_ex');

		ent.PlayEffect('suck_out');

		ent.PlayEffect('smoke_explosion');

		ent.PlayEffect('shadowdash_body_blood');

		ent.PlayEffect('shadowdash');

		ent.AddTag( 'ACS_Big_Hym' );

		ent.AddTag( 'ACS_Hostile_To_All' );

		/*
		movementAdjustor = ((CActor)ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticket = movementAdjustor.GetRequest( 'ACS_Big_Hym_Rotate');
		movementAdjustor.CancelByName( 'ACS_Big_Hym_Rotate' );
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACS_Big_Hym_Rotate' );
		movementAdjustor.AdjustmentDuration( ticket, 0.00001 );
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );
		movementAdjustor.Continuous(ticket);

		movementAdjustor.RotateTowards(ticket, GetWitcherPlayer());
		*/
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function GetACSInfectedPrime() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Infected_Prime' );
	return entity;
}

function GetACSInfectedSpawn() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Infected_Spawn' );
	return entity;
}

function ACS_Spawn_Infected( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;
	var ticket															: SMovementAdjustmentRequestTicket;	
	var p_comp															: CComponent;
	var movementAdjustor												: CMovementAdjustor;

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\monsters\gravier_zombie_spawn.w2ent"
		
	, true );

	adjustedRot = GetACSInfectedPrime().GetWorldRotation();

	adjustedRot.Yaw += 180;
	
	count = 1;
		
	for( i = 0; i < count; i += 1 )
	{
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(pos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetACSInfectedPrime().GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Neutral);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.AddTag( 'ACS_Infected_Spawn' );
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSHarpyQueen() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Harpy_Queen' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Elderblood_Assassin
{
    function ACS_Elderblood_Assassin_Engage()
	{
		this.PushState('ACS_Elderblood_Assassin_Engage');
	}
}

state ACS_Elderblood_Assassin_Engage in cACS_Elderblood_Assassin
{
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var bone_vec, pos, attach_vec										: Vector;
	var bone_rot, rot, attach_rot, playerRot							: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Elderblood_Assassin_Entry();
	}
	
	entry function Elderblood_Assassin_Entry()
	{	
		Elderblood_Assassin_Latent();
	}

	latent function Elderblood_Assassin_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\witchers\elderblood_assassin.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			//((CActor)ent).SetCanPlayHitAnim(false);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag('NoBestiaryEntry');

			ent.PlayEffect('demonic_possession');

			ent.AddTag( 'ACS_Elderblood_Assassin' );

			ent.PlayEffect('fury');

			ent.PlayEffect('fury_403');

			ent.PlayEffect('teleport_glow');
		}
	}
}

function ACS_ElderbloodAssassinSmokeScreen( npc : CActor, pos : Vector )
{
	var ent       														: CEntity;
	var rot, attach_rot, adjustedRot                        			: EulerAngles;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	var ent_2, ent_3													: CEntity;
	var i, count														: int;
	var playerPos, spawnPos												: Vector;
	var randAngle, randRange											: float;
	var h 																: float;
	var bone_vec, attach_vec											: Vector;
	var bone_rot, playerRot												: EulerAngles;

	rot = EulerAngles(0,0,0);

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	//"dlc\dlc_acs\data\fx\dettlaff_swarm_tornado.w2ent"

	"fx\quest\q501\navalbattle\q501_fog_to_hide_spawn.w2ent"

	, true ), ACSPlayerFixZAxis(pos), rot );

	ent.DestroyAfter(120);

	//ent.CreateAttachment(npc);

	animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
	meshcomp = ent.GetComponentByClassName('CMeshComponent');

	animcomp.SetScale(Vector( 2, 2, 0.25, 1 ));

	meshcomp.SetScale(Vector( 2, 2, 0.25, 1 ));	

	ent.PlayEffectSingle('fog');




	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\witchers\elderblood_assassin.w2ent"
		
	, true );

	playerPos = pos;

	playerRot = npc.GetWorldRotation();
	
	count = RandRange(4,2);
		
	for( i = 0; i < count; i += 1 )
	{
		randRange = 2 + 2 * RandF();
		randAngle = 2 * Pi() * RandF();
		
		spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
		spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
		spawnPos.Z = playerPos.Z;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.AddTag( 'ACS_Elderblood_Assassin_Clone' );

		ent.PlayEffect('fury');

		ent.PlayEffect('appear');

		ent.PlayEffect('appear_cutscene');

		if (((CActor)ent).UsesVitality())
		{
			((CActor)ent).DrainVitality(((CActor)ent).GetStat(BCS_Vitality) * 0.5);
		}
		else if (((CActor)ent).UsesEssence())
		{
			((CActor)ent).DrainEssence(((CActor)ent).GetStat(BCS_Essence) * 0.5);
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSIceBoar() : CActor
{
	var ent 				 : CActor;
	
	ent = (CActor)theGame.GetEntityByTag( 'ACS_Ice_Boar' );
	return ent;
}

function ACS_Ice_Boar_Explode( npc : CActor, pos : Vector )
{
	var entity : CEntity;
	var iceSpike : W3ACSCaranthirIceSpike;
	var spawnPos : Vector;
	var rotation, adjustedRot : EulerAngles;

	pos.Z += 1.1;

	rotation = EulerAngles(0,0,0);

	rotation.Yaw = RandRangeF( 180.0, -180.0 );

	entity = (W3ACSCaranthirIceSpike)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\enemy_magic\caranthir_ice_spike.w2ent", true ), pos, rotation );

	iceSpike = (W3ACSCaranthirIceSpike)entity;

	iceSpike.AddTag('ACS_Ice_Boar_Explode');

	if( iceSpike )
	{
		iceSpike.Appear();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class CACSHeartMiniboss extends CNewNPC
{
	var phasesCount : int;
	var currentPhase : int;
	var essenceChunks : int;
	var essenceChunkValue : float;
	var canHit : bool;
	var valuesInitialised : bool;
	editable var factSetAfterDeath : string;
	editable var factSetInOpenedPhase : string;
	editable var factSetInArmoredPhase : string;

	const var MONSTER_HUNT_TARGET_TAG : name; default MONSTER_HUNT_TARGET_TAG = 'MonsterHuntTarget';
	
	private var bossBarOn : bool;
	saved var musicOn : bool;
	editable var displayBossBar : bool;	
	editable saved var switchMusic : bool;
	editable saved var questFocusSoundOnSpawn: bool;
	
	editable var dontTagForAchievement : bool;
	editable var disableDismemberment  : bool;
	
	editable var combatMusicStartEvent : string;
	editable var combatMusicStopEvent  : string;
	
	editable var associatedInvestigationAreasTag : name;
	saved var investigationAreasProcessed : bool;
	
	default displayBossBar 		   = true;
	default questFocusSoundOnSpawn = true;
	default switchMusic 		   = true;
	default disableDismemberment   = true;
	
	default phasesCount = 2;
	default currentPhase = 1;
	default canHit = false;
	default valuesInitialised = true;

	private var proj_1																												: W3ACSBloodTentacles;

	var tentacle_count : int;
	default tentacle_count = 0;

	private var DarknessEnvironment 																										: CEnvironmentDefinition;	
	private var DarknessEnvID																												: int;

	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		var tags : array< name >;
		super.OnSpawned( spawnData );
		
		if ( theGame.IsActive() )
		{
			tags = GetTags();
			
			if ( !HasTag( MONSTER_HUNT_TARGET_TAG ) && !dontTagForAchievement )
			{
				tags.PushBack( MONSTER_HUNT_TARGET_TAG );
			}
			
			if( !HasTag( 'HideHealthBarModule' ) && displayBossBar )
			{
				tags.PushBack( 'HideHealthBarModule' );
			}
			
			SetTags( tags );
		}
		
		
		
		AddTimer( 'MonsterHuntNPCBossBarTimer', 0.5f, true);
		
		if( questFocusSoundOnSpawn )
			SetFocusModeSoundEffectType( FMSET_Red );
			
		
		if( disableDismemberment )
		{
			if( !HasAbility( 'DisableDismemberment' ) )
			{
				AddAbility( 'DisableDismemberment', false );
			}
		}

		super.OnSpawned( spawnData );
		
		SpawnDomain();
		
		
		((CMovingPhysicalAgentComponent)GetMovingAgentComponent()).SetAnimatedMovement( true );
		EnableCollisions(false);
		EnablePhysicalMovement( false );
		
		essenceChunks = phasesCount * 2;
		SetAppearance( 'heart_dying_morph' );

		SetBehaviorVariable( 'combatStart', 1.0 );

		AddTimer('pathfinding_and_darkness', 0.1, true);

		AddTimer('tentalce_attack_loop', 4, true);
	}

	timer function apply_appearance(deltaTime : float, id : int) 
	{
		//GetACSHeartOfDarknessArenaAppearance_01().PlayEffectSingle('arena_start');
		//GetACSHeartOfDarknessArenaAppearance_02().PlayEffectSingle('growing');

		//GetACSHeartOfDarknessArenaAppearance_03().StopEffect('pumping');
		//GetACSHeartOfDarknessArenaAppearance_03().StopEffect('growing');
		//GetACSHeartOfDarknessArenaAppearance_03().StopEffect('dripping');
		//GetACSHeartOfDarknessArenaAppearance_03().StopEffect('comming_out');

		//GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('pumping');
		//GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('growing');
		//GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('dripping');
		//GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('comming_out');


		//GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('pumping');
		//GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('growing');
		//GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('blood_in');


		//GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('pumping');
		//GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('growing');
		//GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('blood_in');


		//GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('pumping');
		//GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('growing');
		//GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('blood_in');

		thePlayer.OnBecomeUnawareOrCannotAttack( ((CActor)(GetACSHeartOfDarknessArenaAppearance_04())) );

		thePlayer.OnBecomeUnawareOrCannotAttack( ((CActor)(GetACSHeartOfDarknessArenaAppearance_05())) );

		thePlayer.OnBecomeUnawareOrCannotAttack( ((CActor)(GetACSHeartOfDarknessArenaAppearance_06())) );
	}

	function Activate_Darkness_Env()
	{
		DarknessEnvironment = (CEnvironmentDefinition)LoadResource(

		"dlc\dlc_acs\data\env\darkness_upon_us.env"

		, true);

		DarknessEnvID = ActivateEnvironmentDefinition( DarknessEnvironment, 1000, 1, 20.f );

		theGame.SetEnvironmentID(DarknessEnvID);
	}

	function Deactivate_Darkness_Env()
	{
		DeactivateEnvironment(DarknessEnvID, 1.25f);
	}

	timer function pathfinding_and_darkness(deltaTime : float, id : int) 
	{
		//var rot, newRot : EulerAngles;

		//rot = thePlayer.GetWorldRotation();

		//rot.Pitch += 180;

		//rot.Yaw += 180;

		//newRot = VecToRotation( theCamera.GetCameraDirection() );

		//newRot.Yaw += 180;

		//newRot.Pitch = rot.Pitch;

		//newRot.Roll = rot.Roll;

		//this.TeleportWithRotation(this.GetWorldPosition(), newRot);

		if( VecDistance( GetACSHeartOfDarknessArenaAppearance_01().GetWorldPosition(), thePlayer.GetWorldPosition() ) <= 50.0f )
		{
			if (!this.HasTag('ACS_Heart_Of_Darkness_Start'))
			{
				GetACSHeartOfDarknessArenaAppearance_01().PlayEffectSingle('arena_start');
				GetACSHeartOfDarknessArenaAppearance_02().PlayEffectSingle('growing');

				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('dripping');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('comming_out');

				GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('dripping');
				GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('comming_out');


				GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('blood_in');


				GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('blood_in');


				GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('blood_in');
				
				this.AddTag('ACS_Heart_Of_Darkness_Start');
			}

			if (!this.HasTag('ACS_Heart_Of_Darkness_Pathfinding'))
			{
				//thePlayer.OnCanFindPath( this );
				thePlayer.OnBecomeAwareAndCanAttack( this );

				this.AddTag('ACS_Heart_Of_Darkness_Pathfinding');
			}
		}
		else
		{
			if (this.HasTag('ACS_Heart_Of_Darkness_Start'))
			{
				GetACSHeartOfDarknessArenaAppearance_01().StopEffect('arena_start');
				GetACSHeartOfDarknessArenaAppearance_02().StopEffect('growing');

				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('dripping');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('comming_out');

				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('dripping');
				GetACSHeartOfDarknessArenaAppearance_03().StopEffect('comming_out');


				GetACSHeartOfDarknessArenaAppearance_04().StopEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_04().StopEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_04().StopEffect('blood_in');


				GetACSHeartOfDarknessArenaAppearance_05().StopEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_05().StopEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_05().StopEffect('blood_in');


				GetACSHeartOfDarknessArenaAppearance_06().StopEffect('pumping');
				GetACSHeartOfDarknessArenaAppearance_06().StopEffect('growing');
				GetACSHeartOfDarknessArenaAppearance_06().StopEffect('blood_in');
				
				this.RemoveTag('ACS_Heart_Of_Darkness_Start');
			}

			if (this.HasTag('ACS_Heart_Of_Darkness_Pathfinding'))
			{
				//thePlayer.OnCannotFindPath( this );
				thePlayer.OnBecomeUnawareOrCannotAttack( this );

				this.RemoveTag('ACS_Heart_Of_Darkness_Pathfinding');
			}
		}

		if( VecDistance( GetACSHeartOfDarknessArenaAppearance_01().GetWorldPosition(), thePlayer.GetWorldPosition() ) <= 15.0f )
		{
			if (!this.HasTag('ACS_Heart_Of_Darkness_Slow'))
			{
				Activate_Darkness_Env();

				((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).FreezePoseFadeIn(40);

				this.AddTag('ACS_Heart_Of_Darkness_Slow');
			}
		}
		else
		{
			if (this.HasTag('ACS_Heart_Of_Darkness_Slow'))
			{
				Deactivate_Darkness_Env();

				((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePoseFadeOut(0.1);

				((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePose();

				this.RemoveTag('ACS_Heart_Of_Darkness_Slow');
			}
		}

		//theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( this.GetWorldPosition() + this.GetWorldForward() * 9 ), 1.f, 10, 1.f, 60.f, 1);
	}

	timer function tentalce_attack_loop_resume(deltaTime : float, id : int) 
	{
		if ( this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.75)
		{
			AddTimer('tentalce_attack_loop', 4, true);
		}
		else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.75 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.5)
		{
			AddTimer('tentalce_attack_loop', 6, true);
		}
		else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.5 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.25)
		{
			AddTimer('tentalce_attack_loop', 8, true);
		}
		else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.25 )
		{
			AddTimer('tentalce_attack_loop', 10, true);
		}
	}

	timer function tentalce_attack_loop(deltaTime : float, id : int) 
	{
		var temp 								: CEntityTemplate;
		var ent	 								: CEntity;
		var playerRot							: EulerAngles;

		if( VecDistance( GetACSHeartOfDarknessArenaAppearance_01().GetWorldPosition(), thePlayer.GetWorldPosition() ) <= 15.0f )
		{
			if ( this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.75)
			{
				if (RandF() < 0.75)
				{
					proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.GetWorldPosition()) );
					proj_1.DestroyAfter(10);	

					AddTimer('attack_delay_1', 1, false);

					AddTimer('attack_delay_2', 2, false);
				}
				else
				{
					if (GetACSHeartOfDarknessGuardianBloodHymSmallCheck() && ACS_can_spawn_guardian_blood_hym())
					{
						ACS_refresh_guardian_blood_hym_cooldown();

						temp = (CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\entities\monsters\mini_hym_alt.w2ent"
							
						, true );

						playerRot = thePlayer.GetWorldRotation();

						playerRot.Yaw += 180;

						ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.7)), playerRot );

						((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

						((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
						((CActor)ent).SetAnimationSpeedMultiplier(0.75);

						((CActor)ent).SetCanPlayHitAnim(false);

						((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddTag( 'ContractTarget' );

						((CActor)ent).AddTag('IsBoss');

						//((CActor)ent).AddTag('ACS_Big_Boi');

						((CActor)ent).AddAbility('Boss');

						((CActor)ent).AddAbility('BounceBoltsWildhunt');

						//((CActor)ent).RemoveAbility('Venom');

						ent.AddTag('NoBestiaryEntry');

						ent.PlayEffect('demonic_possession_ex');

						ent.PlayEffect('shadowdash');
						ent.StopEffect('shadowdash');

						ent.PlayEffect('shadowdash_smoke');
						ent.StopEffect('shadowdash_smoke');

						//ent.PlayEffect('him_smoke_red');

						ent.AddTag( 'ACS_Guardian_Blood_Hym_Small' );
					}
					else
					{
						proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.GetWorldPosition()) );
						proj_1.DestroyAfter(10);	

						AddTimer('attack_delay_1', 1, false);

						AddTimer('attack_delay_2', 2, false);
					}
				}
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.75 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.5)
			{
				if (GetACSHeartOfDarknessGuardianBloodHymSmallCheck() && ACS_can_spawn_guardian_blood_hym())
				{
					ACS_refresh_guardian_blood_hym_cooldown();

					temp = (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\entities\monsters\mini_hym_alt.w2ent"
						
					, true );

					playerRot = thePlayer.GetWorldRotation();

					playerRot.Yaw += 180;

					ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.7)), playerRot );

					((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

					((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
					((CActor)ent).SetAnimationSpeedMultiplier(0.75);

					((CActor)ent).SetCanPlayHitAnim(false);

					((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddTag( 'ContractTarget' );

					((CActor)ent).AddTag('IsBoss');

					//((CActor)ent).AddTag('ACS_Big_Boi');

					((CActor)ent).AddAbility('Boss');

					((CActor)ent).AddAbility('BounceBoltsWildhunt');

					//((CActor)ent).RemoveAbility('Venom');

					ent.AddTag('NoBestiaryEntry');

					ent.PlayEffect('demonic_possession_ex');

					ent.PlayEffect('shadowdash');
					ent.StopEffect('shadowdash');

					ent.PlayEffect('shadowdash_smoke');
					ent.StopEffect('shadowdash_smoke');

					//ent.PlayEffect('him_smoke_red');

					ent.AddTag( 'ACS_Guardian_Blood_Hym_Small' );
				}
				else
				{
					proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.5)) );
					proj_1.DestroyAfter(10);	

					AddTimer('attack_delay_1', 1, false);

					AddTimer('attack_delay_2', 2, false);
				}
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.5 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.25)
			{
				if (RandF() < 0.75)
				{
					proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.GetWorldPosition()) );
					proj_1.DestroyAfter(10);	

					AddTimer('attack_delay_1', 1, false);

					AddTimer('attack_delay_2', 2, false);
				}
				else
				{
					GetACSHeartOfDarknessGuardianBloodHymSmallDestroy();

					if (GetACSHeartOfDarknessGuardianBloodHymLargeCheck() && ACS_can_spawn_guardian_blood_hym())
					{
						ACS_refresh_guardian_blood_hym_cooldown();

						temp = (CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\entities\monsters\giant_hym_old.w2ent"
							
						, true );

						playerRot = thePlayer.GetWorldRotation();

						playerRot.Yaw += 180;

						ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.7)), playerRot );

						((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

						((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
						((CActor)ent).SetAnimationSpeedMultiplier(1.25);

						((CActor)ent).SetCanPlayHitAnim(false);

						((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Enemy_Buff', true);

						((CActor)ent).AddTag( 'ContractTarget' );

						((CActor)ent).AddTag('IsBoss');

						//((CActor)ent).AddTag('ACS_Big_Boi');

						((CActor)ent).AddAbility('Boss');

						((CActor)ent).AddAbility('BounceBoltsWildhunt');

						//((CActor)ent).RemoveAbility('Venom');

						ent.AddTag('NoBestiaryEntry');

						ent.PlayEffect('demonic_possession_ex');

						ent.PlayEffect('suck_out');

						ent.PlayEffect('smoke_explosion');

						ent.PlayEffect('shadowdash_body_blood');

						ent.PlayEffect('shadowdash');

						//ent.PlayEffect('hand_fx');

						//ent.PlayEffect('default_fx');

						//ent.PlayEffect('him_smoke_red');

						ent.AddTag( 'ACS_Guardian_Blood_Hym_Large' );
					}
					else
					{
						proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
						(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.GetWorldPosition()) );
						proj_1.DestroyAfter(10);	

						AddTimer('attack_delay_1', 1, false);

						AddTimer('attack_delay_2', 2, false);
					}
				}
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.25 )
			{
				GetACSHeartOfDarknessGuardianBloodHymSmallDestroy();

				if (GetACSHeartOfDarknessGuardianBloodHymLargeCheck() && ACS_can_spawn_guardian_blood_hym())
				{
					ACS_refresh_guardian_blood_hym_cooldown();

					temp = (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\entities\monsters\giant_hym_old.w2ent"
						
					, true );

					playerRot = thePlayer.GetWorldRotation();

					playerRot.Yaw += 180;

					ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.7)), playerRot );

					((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

					((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
					((CActor)ent).SetAnimationSpeedMultiplier(1.25);

					((CActor)ent).SetCanPlayHitAnim(false);

					((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddTag( 'ContractTarget' );

					((CActor)ent).AddTag('IsBoss');

					//((CActor)ent).AddTag('ACS_Big_Boi');

					((CActor)ent).AddAbility('Boss');

					((CActor)ent).AddAbility('BounceBoltsWildhunt');

					//((CActor)ent).RemoveAbility('Venom');

					ent.AddTag('NoBestiaryEntry');

					ent.PlayEffect('demonic_possession_ex');

					ent.PlayEffect('suck_out');

					ent.PlayEffect('smoke_explosion');

					ent.PlayEffect('shadowdash_body_blood');

					ent.PlayEffect('shadowdash');

					//ent.PlayEffect('hand_fx');

					//ent.PlayEffect('default_fx');

					//ent.PlayEffect('him_smoke_red');

					ent.AddTag( 'ACS_Guardian_Blood_Hym_Large' );
				}
				else
				{
					proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.75)) );
					proj_1.DestroyAfter(10);

					AddTimer('attack_delay_1', 1, false);

					AddTimer('attack_delay_2', 2, false);
				}
			}

			if (tentacle_count < 3)
			{
				tentacle_count += 1;
			}
			else if (tentacle_count >= 3)
			{
				tentacle_count -= tentacle_count;
				AddTimer('tentalce_attack_loop_resume', 4, false);
				RemoveTimer('tentalce_attack_loop');
			}
		}
		else if( VecDistance( GetACSHeartOfDarknessArenaAppearance_01().GetWorldPosition(), thePlayer.GetWorldPosition() ) > 15.0f && VecDistance( this.GetWorldPosition(), thePlayer.GetWorldPosition() ) <= 50.0f )
		{
			if ( this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.75)
			{
				proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
				(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.7)) );
				proj_1.DestroyAfter(10);
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.5 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.5)
			{
				if (GetACSHeartOfDarknessGuardianBloodHymSmallCheck() && ACS_can_spawn_guardian_blood_hym())
				{
					ACS_refresh_guardian_blood_hym_cooldown();

					temp = (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\entities\monsters\mini_hym_alt.w2ent"
						
					, true );

					playerRot = thePlayer.GetWorldRotation();

					playerRot.Yaw += 180;

					ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.7)), playerRot );

					((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

					((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
					((CActor)ent).SetAnimationSpeedMultiplier(0.75);

					((CActor)ent).SetCanPlayHitAnim(false);

					((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddTag( 'ContractTarget' );

					((CActor)ent).AddTag('IsBoss');

					//((CActor)ent).AddTag('ACS_Big_Boi');

					((CActor)ent).AddAbility('Boss');

					((CActor)ent).AddAbility('BounceBoltsWildhunt');

					//((CActor)ent).RemoveAbility('Venom');

					ent.AddTag('NoBestiaryEntry');

					ent.PlayEffect('demonic_possession_ex');

					ent.PlayEffect('shadowdash');
					ent.StopEffect('shadowdash');

					ent.PlayEffect('shadowdash_smoke');
					ent.StopEffect('shadowdash_smoke');

					//ent.PlayEffect('him_smoke_red');

					ent.AddTag( 'ACS_Guardian_Blood_Hym_Small' );
				}
				else
				{
					proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.5)) );
					proj_1.DestroyAfter(10);	

					AddTimer('attack_delay_1', 1, false);

					AddTimer('attack_delay_2', 2, false);
				}
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.5 )
			{
				if (GetACSHeartOfDarknessGuardianBloodHymLargeCheck() && ACS_can_spawn_guardian_blood_hym())
				{
					ACS_refresh_guardian_blood_hym_cooldown();

					GetACSHeartOfDarknessGuardianBloodHymSmallDestroy();

					temp = (CEntityTemplate)LoadResource( 

					"dlc\dlc_acs\data\entities\monsters\giant_hym_old.w2ent"
						
					, true );

					playerRot = thePlayer.GetWorldRotation();

					playerRot.Yaw += 180;

					ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.7)), playerRot );

					((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

					((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
					((CActor)ent).SetAnimationSpeedMultiplier(1.25);

					((CActor)ent).SetCanPlayHitAnim(false);

					((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Enemy_Buff', true);

					((CActor)ent).AddTag( 'ContractTarget' );

					((CActor)ent).AddTag('IsBoss');

					//((CActor)ent).AddTag('ACS_Big_Boi');

					((CActor)ent).AddAbility('Boss');

					((CActor)ent).AddAbility('BounceBoltsWildhunt');

					//((CActor)ent).RemoveAbility('Venom');

					ent.AddTag('NoBestiaryEntry');

					ent.PlayEffect('demonic_possession_ex');

					ent.PlayEffect('suck_out');

					ent.PlayEffect('smoke_explosion');

					ent.PlayEffect('shadowdash_body_blood');

					ent.PlayEffect('shadowdash');

					//ent.PlayEffect('hand_fx');

					//ent.PlayEffect('default_fx');

					//ent.PlayEffect('him_smoke_red');

					ent.AddTag( 'ACS_Guardian_Blood_Hym_Large' );
				}
				else
				{
					proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
					(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.75)) );
					proj_1.DestroyAfter(10);
				}
			}
		}
	}

	timer function attack_delay_1(deltaTime : float, id : int) 
	{
		var playerPos : Vector;

		if ( this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.75)
		{
			playerPos = ACSPlayerFixZAxis(thePlayer.GetWorldPosition());
		}
		else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.75 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.25)
		{
			playerPos = ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.5));
		}

		proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), playerPos );
		proj_1.DestroyAfter(10);	
	}

	timer function attack_delay_2(deltaTime : float, id : int) 
	{
		var playerPos : Vector;

		if ( this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.75)
		{
			playerPos = ACSPlayerFixZAxis(thePlayer.GetWorldPosition());
		}
		else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.75 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.25)
		{
			playerPos = ACSPlayerFixZAxis(thePlayer.PredictWorldPosition(0.5));
		}
		
		proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), playerPos );
		proj_1.DestroyAfter(10);	
	}
	
	event OnTakeDamage( action : W3DamageAction )
	{	
		if( action.attacker != thePlayer || !action.DealsAnyDamage() ) 
		{
			return false;
		}
		
		if( action.GetSignSkill() != S_Magic_s02 )
		{
			DrainEssence( RandRangeF(this.GetStatMax(BCS_Essence) * 0.025, this.GetStatMax(BCS_Essence) * 0.0125) );

			GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('dripping');
			GetACSHeartOfDarknessArenaAppearance_03().StopEffect('dripping');

			GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('hit');
			GetACSHeartOfDarknessArenaAppearance_04().StopEffect('hit');

			GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('hit');
			GetACSHeartOfDarknessArenaAppearance_05().StopEffect('hit');

			GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('hit');
			GetACSHeartOfDarknessArenaAppearance_06().StopEffect('hit');

			if ( this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.9)
			{
				PlayEffect( 'wood_hit' );
				StopEffect( 'wood_hit' );
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.9 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.7)
			{
				PlayEffect( 'wood_hit' );
				StopEffect( 'wood_hit' );

				if (!this.HasTag('ACS_Heart_Of_Darkness_Phase_1'))
				{
					GotoState( 'FourRoots' );

					GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('boom');

					this.AddTag('ACS_Heart_Of_Darkness_Phase_1');
				}
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.7 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.5)
			{
				PlayEffect( 'wood_hit' );
				StopEffect( 'wood_hit' );

				if (!this.HasTag('ACS_Heart_Of_Darkness_Phase_2'))
				{
					GotoState( 'TwoRoots' );

					GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('boom');

					this.AddTag('ACS_Heart_Of_Darkness_Phase_2');
				}
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.5 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.3)
			{
				PlayEffect( 'heart_hit' );
				StopEffect( 'heart_hit' );

				PlayEffect( 'heart_shield' );
				StopEffect( 'heart_shield' );

				if (!this.HasTag('ACS_Heart_Of_Darkness_Phase_3'))
				{
					GotoState( 'NoRoots' );

					GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('boom');

					this.AddTag('ACS_Heart_Of_Darkness_Phase_3');
				}
			}
			else if (this.GetStat(BCS_Essence) < this.GetStatMax(BCS_Essence) * 0.3 && this.GetStat(BCS_Essence) >= this.GetStatMax(BCS_Essence) * 0.011)
			{
				PlayEffect( 'heart_hit' );
				StopEffect( 'heart_hit' );

				PlayEffect( 'heart_shield' );
				StopEffect( 'heart_shield' );

			}
			else if (this.GetStat(BCS_Essence) <= this.GetStatMax(BCS_Essence) * 0.01)
			{
				PlayEffect( 'heart_hit' );
				StopEffect( 'heart_hit' );

				PlayEffect( 'heart_shield' );
				StopEffect( 'heart_shield' );


				if (!this.HasTag('ACS_Heart_Of_Darkness_Dead'))
				{
					SetBehaviorVariable( 'dead', 1.0 );

					SetAppearance( 'heart_cut_morph' );

					GetACSHeartOfDarknessArenaAppearance_01().StopEffect('arena_start');
					GetACSHeartOfDarknessArenaAppearance_01().PlayEffectSingle('arena_end');

					GetACSHeartOfDarknessArenaAppearance_02().StopEffect('growing');
					GetACSHeartOfDarknessArenaAppearance_02().PlayEffectSingle('disappearing');
					
					GetACSHeartOfDarknessArenaAppearance_03().StopEffect('pumping');
					GetACSHeartOfDarknessArenaAppearance_03().StopEffect('growing');
					GetACSHeartOfDarknessArenaAppearance_03().StopEffect('dripping');
					GetACSHeartOfDarknessArenaAppearance_03().StopEffect('comming_out');

					GetACSHeartOfDarknessArenaAppearance_03().PlayEffect('disappearing');

					GetACSHeartOfDarknessArenaAppearance_04().StopAllEffects();
					GetACSHeartOfDarknessArenaAppearance_04().PlayEffect('disappearing');

					GetACSHeartOfDarknessArenaAppearance_05().StopAllEffects();
					GetACSHeartOfDarknessArenaAppearance_05().PlayEffect('disappearing');

					GetACSHeartOfDarknessArenaAppearance_06().StopAllEffects();
					GetACSHeartOfDarknessArenaAppearance_06().PlayEffect('disappearing');

					GetACSHeartOfDarknessArenaAppearance_01().DestroyAfter(15);

					GetACSHeartOfDarknessArenaAppearance_02().DestroyAfter(15);

					GetACSHeartOfDarknessArenaAppearance_03().DestroyAfter(15);

					GetACSHeartOfDarknessArenaAppearance_04().DestroyAfter(15);

					GetACSHeartOfDarknessArenaAppearance_05().DestroyAfter(15);

					GetACSHeartOfDarknessArenaAppearance_06().DestroyAfter(15);

					GetACSHeartOfDarknessGuardianBloodHymSmallDestroy();

					GetACSHeartOfDarknessGuardianBloodHymLargeDestroy();

					this.DestroyAfter(15);

					RemoveTimer('pathfinding_and_darkness');

					RemoveTimer('tentalce_attack_loop');

					RemoveTimer('tentalce_attack_loop_resume');

					//thePlayer.OnCannotFindPath( this );
					thePlayer.OnBecomeUnawareOrCannotAttack( this );

					if (this.HasTag('ACS_Heart_Of_Darkness_Slow'))
					{
						Deactivate_Darkness_Env();

						((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePoseFadeOut(0.1);

						((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePose();

						this.RemoveTag('ACS_Heart_Of_Darkness_Slow');
					}

					this.AddTag('ACS_Heart_Of_Darkness_Dead');
				}
			}
		}
			
		/*
		if( GetCurrentStateName() == 'FullyCovered' && canHit )
		{
			canHit = false;
			if(action.GetSignSkill() != S_Magic_s02)
				PlayEffect( 'wood_hit' );
			GotoState( 'FourRoots' );
		}
		else if( GetCurrentStateName() == 'FourRoots' && canHit )
		{
			canHit = false;
			if(action.GetSignSkill() != S_Magic_s02)
				PlayEffect( 'wood_hit' );
			GotoState( 'TwoRoots' );
		}
		else if( GetCurrentStateName() == 'TwoRoots' && canHit )
		{
			canHit = false;
			if(action.GetSignSkill() != S_Magic_s02)
				PlayEffect( 'wood_hit' );
			GotoState( 'NoRoots' );
			FactsAdd( factSetInOpenedPhase, 1 );
		}
		else if( GetCurrentStateName() == 'NoRoots' && canHit )
		{
			canHit = false;
			PlayEffect( 'heart_hit' );
			essenceChunkValue = this.GetStat( BCS_Essence ) / essenceChunks;
			GotoState( 'HeartHitOnce' );
		}
		else if( GetCurrentStateName() == 'HeartHitOnce' && canHit )
		{
			canHit = false;
			PlayEffect( 'heart_hit' );
			essenceChunkValue = this.GetStat( BCS_Essence ) / essenceChunks;
			DrainEssence( essenceChunkValue );
			essenceChunks -= 1;
			
			if( currentPhase == phasesCount || !this.IsAlive() || this.GetStat( BCS_Essence ) <= essenceChunkValue )
			{
				GotoState( 'Dead' );
				OnDeath( action );
			}
			else 
			{
				currentPhase += 1;
				SetBehaviorVariable( 'stage', 4.0 );
				GotoState( 'FullyCovered' );
				FactsAdd( factSetInArmoredPhase, 1 );	
			}
		}
		*/
	}

	function CreateLoot()
	{
		var loot_temp							: CEntityTemplate;
		var loot 								: CEntity;
		var droppeditemID 						: SItemUniqueId;

		loot_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_guiding_light.w2ent", true );

		loot = (CEntity)theGame.CreateEntity( loot_temp, this.GetWorldPosition() );

		((CNewNPC)loot).EnableCharacterCollisions(false);
		((CNewNPC)loot).EnableCollisions(false);

		((CActor)loot).AddBuffImmunity_AllNegative('ACS_Loot_Entity', true);

		((CActor)loot).AddBuffImmunity_AllCritical('ACS_Loot_Entity', true);

		((CActor)loot).SetUnpushableTarget(thePlayer);

		((CActor)loot).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		((CActor)loot).SetCanPlayHitAnim(false); 

		((CNewNPC)loot).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CActor)(loot)).GetInventory().RemoveAllItems();

		((CActor)(loot)).GetInventory().AddAnItem( 'ACS_AllBlackNecrosword' , 1 );

		droppeditemID = ((CActor)(loot)).GetInventory().GetItemId('ACS_AllBlackNecrosword');

		((CActor)(loot)).GetInventory().DropItemInBag(droppeditemID, 1);
	
		loot.DestroyAfter(0.1);
	}

	function SpawnDomain()
	{
		var position, position2, position3, position4, position5, position6 : Vector;
		var arenaApp1, arenaApp2, arenaApp3, arenaApp4, arenaApp5, arenaApp6 : CEntity;


		position = this.GetWorldPosition() + this.GetWorldForward() * 9;

		position2 = ACSFixZAxis( position );

		position2.Z -= 2;

		position3 = this.GetWorldPosition() + this.GetWorldForward() * -2.5;

		position3.Z += 2;

		position6 = this.GetWorldPosition() + this.GetWorldForward() * 7 + this.GetWorldRight() * -11;
		position6.Z += 0.125;

		position5 = this.GetWorldPosition() + this.GetWorldForward() * 21 + this.GetWorldRight() * -2;
		position5.Z += 0.125;

		position4 = this.GetWorldPosition() + this.GetWorldForward() * 4 + this.GetWorldRight() * 9;
		position4.Z -= 0.125;



		GetACSHeartOfDarknessArenaAppearance_01().Destroy();

		arenaApp1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\lillith_magic\chaos_arena_appearance_01.w2ent" ,true ), position2, this.GetWorldRotation());

		//arenaApp1.CreateAttachment(arena);

		arenaApp1.AddTag('ACS_Heart_Of_Darkness_Arena_Appearance_01');

		GetACSHeartOfDarknessArenaAppearance_02().Destroy();

		arenaApp2 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\lillith_magic\chaos_arena_appearance_02.w2ent" ,true ), position2, this.GetWorldRotation());

		//arenaApp2.CreateAttachment(arena);

		arenaApp2.AddTag('ACS_Heart_Of_Darkness_Arena_Appearance_02');


		GetACSHeartOfDarknessArenaAppearance_03().Destroy();

		arenaApp3 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\fx\monsters\dettlaff\monster\dettlaff_cocoon_with_dettlaff.w2ent" ,true ), position3, this.GetWorldRotation());

		arenaApp3.AddTag('ACS_Heart_Of_Darkness_Arena_Appearance_03');



		GetACSHeartOfDarknessArenaAppearance_04().Destroy();

		arenaApp4 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\heart_of_darkness\dettlaff_veiny_001.w2ent" ,true ), position4, this.GetWorldRotation());

		arenaApp4.AddTag('ACS_Heart_Of_Darkness_Arena_Appearance_04');


		GetACSHeartOfDarknessArenaAppearance_05().Destroy();

		arenaApp5 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\heart_of_darkness\dettlaff_veiny_002.w2ent" ,true ), position5, this.GetWorldRotation());

		arenaApp5.AddTag('ACS_Heart_Of_Darkness_Arena_Appearance_05');


		GetACSHeartOfDarknessArenaAppearance_06().Destroy();

		arenaApp6 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\monsters\heart_of_darkness\dettlaff_veiny_003.w2ent" ,true ), position6, this.GetWorldRotation());

		arenaApp6.AddTag('ACS_Heart_Of_Darkness_Arena_Appearance_06');

		AddTimer('apply_appearance', 0.5f, false);
	}

	event OnDestroyed()
	{
		super.OnDestroyed();
		
		ShowMonsterHuntBossFightIndicator( false );
		SwitchMonsterHuntCombatMusic( false );
		RemoveTimer( 'MonsterHuntNPCBossBarTimer' );

		GetACSHeartOfDarknessGuardianBloodHymLarge().Destroy();

		CreateLoot();
	}

	event OnDeath( damageAction : W3DamageAction  )
	{
		super.OnDeath( damageAction );
		
		ShowMonsterHuntBossFightIndicator( false );
		SwitchMonsterHuntCombatMusic( false );
		RemoveTimer( 'MonsterHuntNPCBossBarTimer' );

		DrainEssence( this.GetStatMax(BCS_Essence) );

		PlayEffect( 'heart_hit' );
		StopEffect( 'heart_hit' );

		if (!this.HasTag('ACS_Heart_Of_Darkness_Dead'))
		{
			SetBehaviorVariable( 'dead', 1.0 );

			SetAppearance( 'heart_cut_morph' );

			GetACSHeartOfDarknessArenaAppearance_01().StopEffect('arena_start');
			GetACSHeartOfDarknessArenaAppearance_01().PlayEffectSingle('arena_end');

			GetACSHeartOfDarknessArenaAppearance_02().StopEffect('growing');
			GetACSHeartOfDarknessArenaAppearance_02().PlayEffectSingle('disappearing');

			GetACSHeartOfDarknessArenaAppearance_01().DestroyAfter(15);

			GetACSHeartOfDarknessArenaAppearance_02().DestroyAfter(15);

			GetACSHeartOfDarknessArenaAppearance_03().DestroyAfter(15);

			RemoveTimer('destroy_app_effect');

			AddTimer('destroy_app_effect', 15, false );

			RemoveTimer('pathfinding_and_darkness');

			this.AddTag('ACS_Heart_Of_Darkness_Dead');
		}
	}

	timer function MonsterHuntNPCBossBarTimer( delta : float , id : int)
	{
		
		if( ( IfCanSeePlayer() || thePlayer.GetDisplayTarget() == this ) && !bossBarOn )
		{
			if( GetAttitudeBetween( thePlayer, this ) == AIA_Hostile )
			{
				if(displayBossBar)
				{
					ShowMonsterHuntBossFightIndicator( true );
				}
				
				SwitchAssociatedInvestigationAreas( false );
				SwitchMonsterHuntCombatMusic( true );
			}
		}
		else
		{
			if( VecDistance( this.GetWorldPosition(), thePlayer.GetWorldPosition() ) >= 45.0f || GetAttitudeBetween( thePlayer, this ) != AIA_Hostile )
			{
				if(displayBossBar)
				{
					ShowMonsterHuntBossFightIndicator( false );
				}
				
				SwitchMonsterHuntCombatMusic( false );
			}
			
		}
		
	}
	
	private function ShowMonsterHuntBossFightIndicator( enable : bool )
	{
		var hud : CR4ScriptedHud;	
		var bossFocusModule : CR4HudModuleBossFocus;
		
		hud = (CR4ScriptedHud)theGame.GetHud();	
		
		if(hud)
		{
			bossFocusModule = (CR4HudModuleBossFocus)hud.GetHudModule("BossFocusModule");
			
			if(bossFocusModule)
			{
				if(enable && !bossBarOn)
				{			
					bossFocusModule.ShowBossIndicator( true, '', this );
					bossBarOn = true;
					return;
				}
				else if(!enable && bossBarOn)
				{
					bossFocusModule.ShowBossIndicator( false, '' );
					bossBarOn = false;
				}
			}
		}
	}
	
	public function SwitchMonsterHuntCombatMusic( enable : bool )
	{
		if( !switchMusic )
			return;
		
		if( enable )
		{
			theSound.SoundEvent( combatMusicStartEvent );
			musicOn = true;
		}
		else
		{
			if( musicOn )
			{
				theSound.SoundEvent( combatMusicStopEvent );
				musicOn = false;
			}
		}
	}
	
	public function GetIsBossbarOn() : bool
	{
		return bossBarOn;
	}
	

	private function SwitchAssociatedInvestigationAreas( enable : bool )
	{
		var entitesList : array<CEntity>;
		var area		: W3MonsterHuntInvestigationArea;
		var i 			: int;
		
		if( !IsNameValid( associatedInvestigationAreasTag ) || investigationAreasProcessed )
			return;
			
		theGame.GetEntitiesByTag( associatedInvestigationAreasTag, entitesList );
		
		for(i=0; i<entitesList.Size(); i+=1)
		{
			area = ( W3MonsterHuntInvestigationArea ) entitesList[i];
			
			if( area )
			{
				area.SetInvestigationAreaEnabled( enable, true );
			}
		}
		
		investigationAreasProcessed = true;
	}
	
	event OnBehaviorNodeActivation()
	{
		canHit = true;
	}
	
	event OnDeathAnimFinished()
	{
		SetAlive( false );
	}
}

function GetACSHeartOfDarknessGuardianBloodHymSmallDestroy()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Guardian_Blood_Hym_Small', actors );	

	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function GetACSHeartOfDarknessGuardianBloodHymLargeDestroy()
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Guardian_Blood_Hym_Large', actors );	

	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

function GetACSHeartOfDarknessGuardianBloodHymSmallCheck() : bool
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Guardian_Blood_Hym_Small', actors );	

	if (actors.Size() <= 3)
	{
		return true;
	}

	return false;
}

function GetACSHeartOfDarknessGuardianBloodHymLargeCheck() : bool
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Guardian_Blood_Hym_Large', actors );	

	if (actors.Size() <= 3)
	{
		return true;
	}

	return false;
}

function GetACSHeartOfDarknessGuardianBloodHymSmall() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Guardian_Blood_Hym_Small' );
	return entity;
}

function GetACSHeartOfDarknessGuardianBloodHymLarge() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Guardian_Blood_Hym_Large' );
	return entity;
}

function GetACSHeartOfDarkness() : CACSHeartMiniboss
{
	var entity 			 : CACSHeartMiniboss;
	
	entity = (CACSHeartMiniboss)theGame.GetEntityByTag( 'ACS_Heart_Of_Darknness' );
	return entity;
}

function GetACSHeartOfDarknessArenaAppearance_01() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Heart_Of_Darkness_Arena_Appearance_01' );
	return entity;
}

function GetACSHeartOfDarknessArenaAppearance_02() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Heart_Of_Darkness_Arena_Appearance_02' );
	return entity;
}

function GetACSHeartOfDarknessArenaAppearance_03() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Heart_Of_Darkness_Arena_Appearance_03' );
	return entity;
}

function GetACSHeartOfDarknessArenaAppearance_04() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Heart_Of_Darkness_Arena_Appearance_04' );
	return entity;
}

function GetACSHeartOfDarknessArenaAppearance_05() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Heart_Of_Darkness_Arena_Appearance_05' );
	return entity;
}

function GetACSHeartOfDarknessArenaAppearance_06() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Heart_Of_Darkness_Arena_Appearance_06' );
	return entity;
}

state FourRoots in CACSHeartMiniboss
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
		parent.SetBehaviorVariable( 'stage', 1.0 );
		//thePlayer.PlayLine( 0416489, true);
	}
}

state TwoRoots in CACSHeartMiniboss
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
		parent.SetBehaviorVariable( 'stage', 2.0 );
		//thePlayer.PlayLine( 0416491, true);
	}
}

state NoRoots in CACSHeartMiniboss
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState( prevStateName );
		parent.SetBehaviorVariable( 'stage', 3.0 );
		//thePlayer.PlayLine( 0416493, true);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class CACSMonsterSpawner extends CEntity
{
	var pos : Vector;
	var rot : EulerAngles;
	var targetDistance : float;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		pos = this.GetWorldPosition();
		rot = this.GetWorldRotation();

		AddTimer('PlayerDistanceCheck', 0.01, true);

		AddTimer('PlayerDistanceCheckForDestruction', 0.01, true);

		this.AddTag('ACS_MonsterSpawner_POI_Point');
	}

	function IsEntityOutsideOfCameraFrame() : bool
	{
		if (this.HasTag('ACS_MonsterSpawner_Spawn_In_Frame'))
		{
			return true;
		}
		else
		{
			if ( thePlayer.WasVisibleInScaledFrame( this, 1.f, 1.f ) )
			{
				return false;
			}
		}

		return true;
	}

	function GetDistance() : float
	{
		return 100;
	}

	timer function PlayerDistanceCheck ( dt : float, id : int )
	{
		if (this.HasTag('ACS_MonsterSpawner_HorseRidersNovigrad')
		|| this.HasTag('ACS_MonsterSpawner_HorseRidersRedania')
		|| this.HasTag('ACS_MonsterSpawner_HorseRidersNilfgaard')
		)
		{
			if ( this.HasTag('ACS_MonsterSpawner_POI_Point'))
			{
				this.RemoveTag('ACS_MonsterSpawner_POI_Point');
			}
		}

		targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), pos );

		if (
		( targetDistance > 5 * 5 && targetDistance <= (GetDistance() * GetDistance()) )
		&& IsEntityOutsideOfCameraFrame()
		&& thePlayer.IsOnGround()
		&& !thePlayer.IsInInterior()
		&& !theGame.IsDialogOrCutscenePlaying() 
		&& !thePlayer.IsInNonGameplayCutscene() 
		&& !thePlayer.IsInGameplayScene()
		&& !thePlayer.IsCiri()
		&& !theGame.IsCurrentlyPlayingNonGameplayScene()
		&& !theGame.IsFading()
		&& !theGame.IsBlackscreen()
		&& !theGame.IsPaused() 
		)
		{
			if (!this.HasTag('ACS_MonsterSpawner_Activated'))
			{
				if (this.HasTag('ACS_MonsterSpawner_ForestGod'))
				{
					this.PushState('ACS_MonsterSpawner_ForestGod');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_IceTitan'))
				{
					this.PushState('ACS_MonsterSpawner_IceTitan');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ChaosAltar'))
				{
					this.PushState('ACS_MonsterSpawner_ChaosAltar');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_KnightmareEternum'))
				{
					this.PushState('ACS_MonsterSpawner_KnightmareEternum');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Loviatar'))
				{
					this.PushState('ACS_MonsterSpawner_Loviatar');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_FireWyrm'))
				{
					this.PushState('ACS_MonsterSpawner_FireWyrm');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_RatMage'))
				{
					this.PushState('ACS_MonsterSpawner_RatMage');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Mages'))
				{
					this.PushState('ACS_MonsterSpawner_Mages');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_CloakedVampiress'))
				{
					this.PushState('ACS_MonsterSpawner_CloakedVampiress');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Draugir'))
				{
					this.PushState('ACS_MonsterSpawner_Draugir');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Draug'))
				{
					this.PushState('ACS_MonsterSpawner_Draug');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_NecrofiendNest'))
				{
					this.PushState('ACS_MonsterSpawner_NecrofiendNest');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_HarpyQueenNest'))
				{
					this.PushState('ACS_MonsterSpawner_HarpyQueenNest');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Berserkers'))
				{
					this.PushState('ACS_MonsterSpawner_Berserkers');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_CatAssassin'))
				{
					this.PushState('ACS_MonsterSpawner_CatAssassin');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_NamelessDemon'))
				{
					this.PushState('ACS_MonsterSpawner_NamelessDemon');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Garmr'))
				{
					this.PushState('ACS_MonsterSpawner_Garmr');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_FataMorgana'))
				{
					this.PushState('ACS_MonsterSpawner_FataMorgana');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_XenoTyrantEgg'))
				{
					this.PushState('ACS_MonsterSpawner_XenoTyrantEgg');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_CultOfMelusine'))
				{
					this.PushState('ACS_MonsterSpawner_CultOfMelusine');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Rioghan'))
				{
					this.PushState('ACS_MonsterSpawner_Rioghan');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Svalblod'))
				{
					this.PushState('ACS_MonsterSpawner_Svalblod');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Duskwraith'))
				{
					this.PushState('ACS_MonsterSpawner_Duskwraith');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_OmnesMoriendus'))
				{
					this.PushState('ACS_MonsterSpawner_OmnesMoriendus');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_OpinicusMatriarch'))
				{
					this.PushState('ACS_MonsterSpawner_OpinicusMatriarch');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Incubus'))
				{
					this.PushState('ACS_MonsterSpawner_Incubus');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Mula'))
				{
					this.PushState('ACS_MonsterSpawner_Mula');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_BloodHym'))
				{
					this.PushState('ACS_MonsterSpawner_BloodHym');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Orianna'))
				{
					this.PushState('ACS_MonsterSpawner_Orianna');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_HeartOfDarkness'))
				{
					this.PushState('ACS_MonsterSpawner_HeartOfDarkness');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Bumbakvetch'))
				{
					this.PushState('ACS_MonsterSpawner_Bumbakvetch');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_IceBoar'))
				{
					this.PushState('ACS_MonsterSpawner_IceBoar');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_NimeanPanther'))
				{
					this.PushState('ACS_MonsterSpawner_NimeanPanther');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ForestGodShadow'))
				{
					this.PushState('ACS_MonsterSpawner_ForestGodShadow');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadesCrusaders'))
				{
					this.PushState('ACS_MonsterSpawner_ShadesCrusaders');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadesHunters'))
				{
					this.PushState('ACS_MonsterSpawner_ShadesHunters');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadesRogues'))
				{
					this.PushState('ACS_MonsterSpawner_ShadesRogues');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadesShowdown'))
				{
					this.PushState('ACS_MonsterSpawner_ShadesShowdown');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadesDancerWaning'))
				{
					this.PushState('ACS_MonsterSpawner_ShadesDancerWaning');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadesDancerWaxing'))
				{
					this.PushState('ACS_MonsterSpawner_ShadesDancerWaxing');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadesKara'))
				{
					this.PushState('ACS_MonsterSpawner_ShadesKara');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadesNightmareIncarnate'))
				{
					this.PushState('ACS_MonsterSpawner_ShadesNightmareIncarnate');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ShadowPixies'))
				{
					this.PushState('ACS_MonsterSpawner_ShadowPixies');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_DemonicConstruct'))
				{
					this.PushState('ACS_MonsterSpawner_DemonicConstruct');
					RemoveSpawner();
					return;
				}
				
				if (this.HasTag('ACS_MonsterSpawner_ViyOfMaribor'))
				{
					this.PushState('ACS_MonsterSpawner_ViyOfMaribor');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Phooca'))
				{
					this.PushState('ACS_MonsterSpawner_Phooca');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Plumard'))
				{
					this.PushState('ACS_MonsterSpawner_Plumard');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_GiantRockTroll'))
				{
					this.PushState('ACS_MonsterSpawner_GiantRockTroll');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_GiantIceTroll'))
				{
					this.PushState('ACS_MonsterSpawner_GiantIceTroll');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_GiantMagmaTroll'))
				{
					this.PushState('ACS_MonsterSpawner_GiantMagmaTroll');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_TheBeast'))
				{
					this.PushState('ACS_MonsterSpawner_TheBeast');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ElementalTitanOfFire'))
				{
					this.PushState('ACS_MonsterSpawner_ElementalTitanOfFire');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ElementalTitanOfTerra'))
				{
					this.PushState('ACS_MonsterSpawner_ElementalTitanOfTerra');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_ElementalTitanOfIce'))
				{
					this.PushState('ACS_MonsterSpawner_ElementalTitanOfIce');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_DarkKnight'))
				{
					this.PushState('ACS_MonsterSpawner_DarkKnight');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_DarkKnightCalidus'))
				{
					this.PushState('ACS_MonsterSpawner_DarkKnightCalidus');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Voref'))
				{
					this.PushState('ACS_MonsterSpawner_Voref');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Maerolorn'))
				{
					this.PushState('ACS_MonsterSpawner_Maerolorn');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Ifrit'))
				{
					this.PushState('ACS_MonsterSpawner_Ifrit');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_Carduin'))
				{
					this.PushState('ACS_MonsterSpawner_Carduin');
					RemoveSpawner();
					return;
				}


				/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

				if (this.HasTag('ACS_MonsterSpawner_HorseRidersNovigrad'))
				{
					this.PushState('ACS_MonsterSpawner_HorseRidersNovigrad');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_HorseRidersRedania'))
				{
					this.PushState('ACS_MonsterSpawner_HorseRidersRedania');
					RemoveSpawner();
					return;
				}

				if (this.HasTag('ACS_MonsterSpawner_HorseRidersNilfgaard'))
				{
					this.PushState('ACS_MonsterSpawner_HorseRidersNilfgaard');
					RemoveSpawner();
					return;
				}

				
				this.PushState('ACS_MonsterSpawner_Default');

				RemoveSpawner();

				return;
			}
		}
	}

	timer function PlayerDistanceCheckForDestruction ( dt : float, id : int )
	{
		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), pos );

		if (targetDistance <= 50 * 50 && this.HasTag('ACS_MonsterSpawner_Activated'))
		{
			this.DestroyAfter(10);
			RemoveTimer('PlayerDistanceCheckForDestruction');
		}
	}

	function RemoveSpawner()
	{
		RemoveTimer('PlayerDistanceCheck');
		this.AddTag('ACS_MonsterSpawner_Activated');
	}
}

state ACS_MonsterSpawner_Default in CACSMonsterSpawner
{
	private var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
	private var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot							: EulerAngles;
	private var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	private var l_aiTree														: CAIMoveToAction;		
		
	event OnEnterState(prevStateName : name)
	{
		Spawn_Default_Entry();
	}
	
	entry function Spawn_Default_Entry()
	{	
		Spawn_Default_Latent();
	}

	latent function Spawn_Default_Latent()
	{
		GetACSEnemy().Destroy();

		GetACSEnemyDestroyAll();

		temp = (CEntityTemplate)LoadResourceAsync( 

		//"dlc\bob\data\quests\main_quests\quest_files\q704b_fairy_tale\entities\q704_wolpertinger.w2ent"

		//"dlc\dlc_acs_test\data\entities\monsters\kikimore_queen.w2ent"

		//"dlc\dlc_acs_test\data\entities\monsters\voref.w2ent"

		//"dlc\ep1\data\quests\quest_files\q605_finale\characters\q605_shadow_fogling.w2ent"

		//"dlc\dlc_acs_test\data\entities\monsters\hare_aggressive.w2ent"

		"dlc\dlc_acs\data\entities\mages\carduin_of_lan_exeter.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		count = 1;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).SetCanPlayHitAnim(true);

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

			//((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			//((CActor)ent).AddTag('ACS_Big_Boi');

			((CActor)ent).AddAbility('Boss');

			//((CActor)ent).AddAbility('AcidSpit');

			((CActor)ent).AddAbility('InstantKillImmune');

			((CActor)ent).AddAbility('ablIgnoreSigns');

			((CActor)ent).AddAbility('DisableFinishers');

			((CActor)ent).AddAbility('MonsterMHBoss');

			((CActor)ent).AddAbility('ForceCriticalEffects');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			//((CActor)ent).RemoveAbility('Venom');

			//ent.AddTag('NoBestiaryEntry');

			//ent.PlayEffect('shadow_form');
			
			//ent.PlayEffect('shadow_form_head');

			//ent.PlayEffect('demonic_eye_r');

			//ent.PlayEffect('demonic_eye_l');

			//((CActor)ent).RemoveBuff(EET_FireAura, true, 'acs_ifrit_fire_aura');

			//((CActor)ent).AddEffectDefault( EET_FireAura, ((CActor)ent), 'acs_ifrit_fire_aura' );

			ent.AddTag( 'ACS_enemy' );

			//ent.AddTag( 'ACS_Hostile_To_All' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_ForestGod in CACSMonsterSpawner
{
	private var temp, temp2														: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var gasEntity														: W3ToxicCloud;
	private var weapon_names, armor_names										: array<CName>;
	private var playerRot, adjustedRot											: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		Spawn_Forest_God_Entry();
	}
	
	entry function Spawn_Forest_God_Entry()
	{	
		Spawn_Forest_God_Latent();
	}

	function fill_shades_weapons_array()
	{
		weapon_names.Clear();

		weapon_names.PushBack('Shades Steel Claymore 2');
		weapon_names.PushBack('Shades Steel Rakuyo 2');
		weapon_names.PushBack('Shades Steel Graveripper 2');
		weapon_names.PushBack('Shades Steel Kukri 2');
		weapon_names.PushBack('Shades Steel a123 2');
		weapon_names.PushBack('Shades Steel Realmdrifter Blade 2');
		weapon_names.PushBack('Shades Steel Realmdrifter Divider 2');
		weapon_names.PushBack('Shades Steel Hades Grasp 2');
		weapon_names.PushBack('Shades Steel Icarus Tears 2');
		weapon_names.PushBack('Shades Steel Kingslayer 2');
		weapon_names.PushBack('Shades Steel Vulcan 2');
		weapon_names.PushBack('Shades Steel Flameborn 2');
		weapon_names.PushBack('Shades Steel Frostmourne 2');
		weapon_names.PushBack('Shades Steel Oblivion 2');
		weapon_names.PushBack('Shades Steel Sinner 2');
		weapon_names.PushBack('Shades Steel Bloodletter 2');
		weapon_names.PushBack('Shades Steel Ares 2');
		weapon_names.PushBack('Shades Steel Voidblade 2');
		weapon_names.PushBack('Shades Steel Bloodshot 2');
		weapon_names.PushBack('Shades Steel Eagle Sword 2');
		weapon_names.PushBack('Shades Steel Lion Sword 2');
		weapon_names.PushBack('Shades Steel Pridefall 2');
		weapon_names.PushBack('Shades Steel Haoma 2');
		weapon_names.PushBack('Shades Steel Cursed Khopesh 2');
		weapon_names.PushBack('Shades Steel Sithis Blade 2');
		weapon_names.PushBack('Shades Steel Ejderblade 2');
		weapon_names.PushBack('Shades Steel Dragonbane 2');
		weapon_names.PushBack('Shades Steel Doomblade 2');
		weapon_names.PushBack('Shades Steel Crownbreaker 2');
		weapon_names.PushBack('Shades Steel Blooddusk 2');
		weapon_names.PushBack('Shades Steel Oathblade 2');
		weapon_names.PushBack('Shades Steel Beastcutter 2');
		weapon_names.PushBack('Shades Steel Hellspire 2');
		weapon_names.PushBack('Shades Steel Heavenspire 2');
		weapon_names.PushBack('Shades Steel Guandao 2');
		weapon_names.PushBack('Shades Steel Hitokiri Katana 2');
		weapon_names.PushBack('Shades Steel Gorgonslayer 2');
		weapon_names.PushBack('Shades Steel Ryu Katana 2');
		weapon_names.PushBack('Shades Steel Blackdawn 2');
		weapon_names.PushBack('Shades Steel Knife 2');
		weapon_names.PushBack('Shades Silver Claymore 2');
		weapon_names.PushBack('Shades Silver Rakuyo 2');
		weapon_names.PushBack('Shades Silver Graveripper 2');
		weapon_names.PushBack('Shades Silver a123 2');
		weapon_names.PushBack('Shades Silver Kukri 2');
		weapon_names.PushBack('Shades Silver Realmdrifter Blade 2');
		weapon_names.PushBack('Shades Silver Realmdrifter Divider 2');
		weapon_names.PushBack('Shades Silver Hades Grasp 2');
		weapon_names.PushBack('Shades Silver Icarus Tears 2');
		weapon_names.PushBack('Shades Silver Kingslayer 2');
		weapon_names.PushBack('Shades Silver Vulcan 2');
		weapon_names.PushBack('Shades Silver Flameborn 2');
		weapon_names.PushBack('Shades Silver Frostmourne 2');
		weapon_names.PushBack('Shades Silver Oblivion 2');
		weapon_names.PushBack('Shades Silver Sinner 2');
		weapon_names.PushBack('Shades Silver Bloodletter 2');
		weapon_names.PushBack('Shades Silver Ares 2');
		weapon_names.PushBack('Shades Silver Voidblade 2');
		weapon_names.PushBack('Shades Silver Bloodshot 2');
		weapon_names.PushBack('Shades Silver Eagle Sword 2');
		weapon_names.PushBack('Shades Silver Lion Sword 2');
		weapon_names.PushBack('Shades Silver Pridefall 2');
		weapon_names.PushBack('Shades Silver Haoma 2');
		weapon_names.PushBack('Shades Silver Cursed Khopesh 2');
		weapon_names.PushBack('Shades Silver Sithis Blade 2');
		weapon_names.PushBack('Shades Silver Ejderblade 2');
		weapon_names.PushBack('Shades Silver Dragonbane 2');
		weapon_names.PushBack('Shades Silver Doomblade 2');
		weapon_names.PushBack('Shades Silver Crownbreaker 2');
		weapon_names.PushBack('Shades Silver Blooddusk 2');
		weapon_names.PushBack('Shades Silver Oathblade 2');
		weapon_names.PushBack('Shades Silver Beastcutter 2');
		weapon_names.PushBack('Shades Silver Hellspire 2');
		weapon_names.PushBack('Shades Silver Heavenspire 2');
		weapon_names.PushBack('Shades Silver Guandao 2');
		weapon_names.PushBack('Shades Silver Hitokiri Katana 2');
		weapon_names.PushBack('Shades Silver Gorgonslayer 2');
		weapon_names.PushBack('Shades Silver Ryu Katana 2');
		weapon_names.PushBack('Shades Silver Blackdawn 2');
		weapon_names.PushBack('Shades Silver Knife 2');
	}

	function fill_shades_armor_arrawy()
	{
		armor_names.Clear();

		armor_names.PushBack('Shades Realmdrifter Armor 2');
		armor_names.PushBack('Shades Realmdrifter Boots 2');
		armor_names.PushBack('Shades Realmdrifter Gloves 2');
		armor_names.PushBack('Shades Realmdrifter Helm');
		armor_names.PushBack('Shades Realmdrifter Pants 2');

		armor_names.PushBack('Shades Omen Armor 3');
		armor_names.PushBack('Shades Omen Boots 3');
		armor_names.PushBack('Shades Omen Gloves 3');
		armor_names.PushBack('Shades Omen Helm');
		armor_names.PushBack('Shades Omen Pants 3');

		armor_names.PushBack('Shades Plunderer Armor 3');
		armor_names.PushBack('Shades Plunderer Boots 3');
		armor_names.PushBack('Shades Plunderer Gloves 3');
		armor_names.PushBack('Shades Plunderer Headwear');
		armor_names.PushBack('Shades Plunderer Hat');
		armor_names.PushBack('Shades Plunderer Mask');
		armor_names.PushBack('Shades Plunderer Pants 3');

		armor_names.PushBack('Shade Plunderer Armor 3');
		armor_names.PushBack('Shade Plunderer Boots 3');
		armor_names.PushBack('Shade Plunderer Gloves 3');
		armor_names.PushBack('Shade Plunderer Headwear');
		armor_names.PushBack('Shade Plunderer Hat');
		armor_names.PushBack('Shade Plunderer Mask');
		armor_names.PushBack('Shade Plunderer Pants 3');
		
		armor_names.PushBack('Shades Oldhunter Armor 2');
		armor_names.PushBack('Shades Oldhunter Boots 2');
		armor_names.PushBack('Shades Oldhunter Gloves 2');
		armor_names.PushBack('Shades Oldhunter Cap');
		armor_names.PushBack('Shades Oldhunter Pants 2');
		
		armor_names.PushBack('Shades Faraam Armor 2');
		armor_names.PushBack('Shades Faraam Boots 2');
		armor_names.PushBack('Shades Faraam Gloves 2');
		armor_names.PushBack('Shades Faraam Helm');
		armor_names.PushBack('Shades Faraam Pants 2');
		
		armor_names.PushBack('Shades Hunter Armor 2');
		armor_names.PushBack('Shades Hunter Boots 2');
		armor_names.PushBack('Shades Hunter Gloves 2');
		armor_names.PushBack('Shades Hunter Hat');
		armor_names.PushBack('Shades Hunter Mask');
		armor_names.PushBack('Shades Hunter Mask and Hat');
		armor_names.PushBack('Shades Hunter Pants 2');
		
		armor_names.PushBack('Shades Yahargul Armor 2');
		armor_names.PushBack('Shades Yahargul Boots 2');
		armor_names.PushBack('Shades Yahargul Gloves 2');
		armor_names.PushBack('Shades Yahargul Helm');
		armor_names.PushBack('Shades Yahargul Pants 2');
		
		armor_names.PushBack('Shades Crow Armor 2');
		armor_names.PushBack('Shades Crow Boots 2');
		armor_names.PushBack('Shades Crow Gloves 2');
		armor_names.PushBack('Shades Crow Mask');
		armor_names.PushBack('Shades Crow Pants 2');
		
		armor_names.PushBack('Shades Sithis Armor 2');
		armor_names.PushBack('Shades Taifeng Boots 2');
		armor_names.PushBack('Shades Taifeng Gloves 2');
		armor_names.PushBack('Shades Sithis Hood');
		armor_names.PushBack('Shades Taifeng Pants 2');
		armor_names.PushBack('Shades Taifeng Armor 2');

		armor_names.PushBack('Shades Kara Armor 2');
		armor_names.PushBack('Shades Kara Boots 2');
		armor_names.PushBack('Shades Kara Gloves 2');
		armor_names.PushBack('Shades Kara Hat');
		armor_names.PushBack('Shades Kara Pants 2');
		
		armor_names.PushBack('Shades Lionhunter Armor 2');
		armor_names.PushBack('Shades Lionhunter Boots 2');
		armor_names.PushBack('Shades Lionhunter Gloves 2');
		armor_names.PushBack('Shades Lionhunter Hat');
		armor_names.PushBack('Shades Lionhunter Pants 2');
		
		armor_names.PushBack('Shades Berserker Armor 2');
		armor_names.PushBack('Shades Berserker Boots 2');
		armor_names.PushBack('Shades Berserker Gloves 2');
		armor_names.PushBack('Shades Berserker Helm');
		armor_names.PushBack('Shades Berserker Pants 2');
		
		armor_names.PushBack('Shades Bismarck Armor 2');
		armor_names.PushBack('Shades Bismarck Boots 2');
		armor_names.PushBack('Shades Bismarck Gloves 2');
		armor_names.PushBack('Shades Bismarck Helm');
		armor_names.PushBack('Shades Bismarck Pants 2');
		
		armor_names.PushBack('Shades Undertaker Armor 2');
		armor_names.PushBack('Shades Undertaker Boots 2');
		armor_names.PushBack('Shades Undertaker Gloves 2');
		armor_names.PushBack('Shades Undertaker Pants 2');
		armor_names.PushBack('Shades Undertaker Mask');
		
		armor_names.PushBack('Shades Ezio Pants 2');
		armor_names.PushBack('Shades Ezio Armor 2');
		armor_names.PushBack('Shades Ezio Boots 2');
		armor_names.PushBack('Shades Ezio Gloves 2');
		armor_names.PushBack('Shades Ezio Hood');
		
		armor_names.PushBack('Shades Headtaker Armor 2');
		armor_names.PushBack('Shades Headtaker Boots 2');
		armor_names.PushBack('Shades Headtaker Gloves 2');
		armor_names.PushBack('Shades Headtaker Pants 2');
		armor_names.PushBack('Shades Headtaker Mask');
		
		armor_names.PushBack('Shades Viper Armor 2');
		armor_names.PushBack('Shades Viper Boots 2');
		armor_names.PushBack('Shades Viper Gloves 2');
		armor_names.PushBack('Shades Viper Mask');
		armor_names.PushBack('Shades Viper Pants 2');
		
		armor_names.PushBack('Shades Ronin Hat');
		armor_names.PushBack('Shades Hitokiri Mask');
		armor_names.PushBack('Shades Warborn Helm');
		armor_names.PushBack('Shades Headtaker Cloak');
		armor_names.PushBack('Shades Genichiro Helm');
	}

	latent function Spawn_Forest_God_Latent()
	{
		ACS_Forest_God().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 
		"dlc\dlc_acs\data\entities\monsters\forest_god.w2ent"
		, true );

		playerPos = parent.pos;
		
		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(parent.pos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,1.25,1));
		meshcomp.SetScale(Vector(h,h,1.25,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel() + 10);
		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
		((CActor)ent).SetAnimationSpeedMultiplier(1.1);

		((CActor)ent).GetInventory().AddAnItem( 'Crowns', 50000 );

		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			fill_shades_weapons_array();

			fill_shades_armor_arrawy();

			((CActor)ent).GetInventory().AddAnItem( weapon_names[RandRange(weapon_names.Size())] , 1 );

			((CActor)ent).GetInventory().AddAnItem( armor_names[RandRange(armor_names.Size())] , 1 );
		}
		else
		{
			((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 50 );

			((CActor)ent).GetInventory().AddAnItem( 'Ruby flawless', 50 );

			((CActor)ent).GetInventory().AddAnItem( 'Diamond flawless', 50 );
		}

		((CActor)ent).AddTag( 'ACS_Forest_God' );

		ent.AddTag('ACS_Hostile_To_All');

		((CActor)ent).AddTag( 'ACS_Big_Boi' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Forest_God_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Forest_God_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Forest_God_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffectSingle('demonic_possession');

		ent.PlayEffectSingle('demonic_possession_r_hand');
		ent.PlayEffectSingle('demonic_possession_l_hand');

		ent.PlayEffectSingle('demonic_possession_torso');
		ent.PlayEffectSingle('demonic_possession_pelvis');

		ent.PlayEffectSingle('demonic_possession_r_bicep');
		ent.PlayEffectSingle('demonic_possession_l_bicep');

		ent.PlayEffectSingle('demonic_possession_l_forearmRoll');
		ent.PlayEffectSingle('demonic_possession_r_forearmRoll'); 

		ent.PlayEffectSingle('demonic_possession_l_foot'); 
		ent.PlayEffectSingle('demonic_possession_r_foot'); 
		ent.PlayEffectSingle('demonic_possession_r_shin'); 
		ent.PlayEffectSingle('demonic_possession_l_shin'); 

		ent.PlayEffectSingle('demonic_possession_torso2'); 

		ent.PlayEffectSingle('demonic_possession_l_kneeRoll'); 
		ent.PlayEffectSingle('demonic_possession_r_kneeRoll'); 

		ent.PlayEffectSingle('demonic_possession_r_bicep2'); 
		ent.PlayEffectSingle('demonic_possession_l_bicep2'); 

		ent.PlayEffectSingle('demonic_possession_l_forearmRoll1'); 
		ent.PlayEffectSingle('demonic_possession_r_forearmRoll1'); 

		ent.PlayEffectSingle('demonic_possession_torso3'); 

		temp2 = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\toxic_gas_7m.w2ent", true );

		ACS_Toxic_Gas_Destroy();

		ACS_Get_Toxic_Gas().Destroy();
			
		gasEntity = (W3ToxicCloud)theGame.CreateEntity(temp2, ent.GetWorldPosition());

		gasEntity.CreateAttachment(ent);

		gasEntity.AddTag( 'ACS_Toxic_Gas' );

		GetACSWatcher().RemoveTimer('ACS_Forest_God_Spikes');
		GetACSWatcher().AddTimer('ACS_Forest_God_Spikes', 0.1, true);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_IceTitan in CACSMonsterSpawner
{
	private var temp_1																																	: CEntityTemplate;
	private var ent_1																																	: CEntity;
	private var spawnPos																																: Vector;
	private var meshcomp																																: CComponent;
	private var animcomp 																																: CAnimatedComponent;
	private var h 																																		: float;
	private var playerRot, adjustedRot																													: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Ice_Titan_Entry();
	}
	
	entry function Spawn_Ice_Titan_Entry()
	{	
		Spawn_Ice_Titan_Latent();
	}

	latent function Spawn_Ice_Titan_Latent()
	{
		temp_1 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\ice_giant_1.w2ent"
			
		, true );

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent_1 = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(parent.pos), adjustedRot );

		animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_1.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent_1).SetLevel(75);
		((CNewNPC)ent_1).SetAttitude(thePlayer, AIA_Hostile);
		((CNewNPC)ent_1).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );
		((CActor)ent_1).SetAnimationSpeedMultiplier(1);

		((CActor)ent_1).GetInventory().AddAnItem( 'Crowns', 2500 );

		((CActor)ent_1).GetInventory().AddAnItem( 'Diamond flawless', 10 );

		((CActor)ent_1).AddTag( 'ACS_Ice_Titan' );

		((CActor)ent_1).AddTag( 'ACS_Hostile_To_All' );

		((CActor)ent_1).AddTag( 'ACS_Big_Boi' );

		((CActor)ent_1).AddTag( 'ContractTarget' );

		((CActor)ent_1).AddTag('IsBoss');

		((CActor)ent_1).AddAbility('Boss');

		((CActor)ent_1).AddAbility('BounceBoltsWildhunt');

		((CActor)ent_1).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Ice_Titan_Buff', true);

		((CActor)ent_1).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Titan_Buff', true);

		((CActor)ent_1).AddBuffImmunity(EET_Burning , 'ACS_Ice_Titan_Buff', true);

		((CActor)ent_1).AddBuffImmunity(EET_Swarm , 'ACS_Ice_Titan_Buff', true);

		ent_1.PlayEffectSingle('demonic_possession');

		ent_1.PlayEffectSingle('ice');

		ent_1.AddTag('NoBestiaryEntry');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_ChaosAltar in CACSMonsterSpawner
{
	private var temp, temp2														: CEntityTemplate;
	private var ent, ent2														: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot										: EulerAngles;
	private var comp 															: CComponent;
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket															: SMovementAdjustmentRequestTicket;	
	private var p_comp															: CComponent;
	private var playerRot, adjustedRot 											: EulerAngles;
		

	event OnEnterState(prevStateName : name)
	{
		Spawn_Altar_Entry();
	}
	
	entry function Spawn_Altar_Entry()
	{	
		Spawn_Altar_Latent();
	}

	latent function Spawn_Altar_Latent()
	{
		playerRot = thePlayer.GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\chaos_flame_altar_mesh.w2ent"
		
		, true );

		temp2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\chaos_flame_altar_entity.w2ent"
		
		, true );


		spawnPos = parent.pos;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

		ent2 = theGame.CreateEntity( temp2, ACSPlayerFixZAxis(spawnPos), adjustedRot );

		if(!ent)
		{
			return;
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		comp = ent.GetComponentByClassName('CGameplayLightComponent');

		((CGameplayLightComponent)comp).SetInteractive(false);

		ent.PlayEffectSingle('fire_old');

		ent.PlayEffectSingle('fire');

		ent.AddTag('ACS_Fire_Bear_Altar');


		animcomp = (CAnimatedComponent)ent2.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent2.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		animcomp.FreezePose();

		((CNewNPC)ent2).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent2).SetAttitude(GetWitcherPlayer(), AIA_Neutral);
		((CActor)ent2).SetAnimationSpeedMultiplier(0);

		((CNewNPC)ent2).EnableCharacterCollisions(false);
		((CNewNPC)ent2).EnableCollisions(false);

		((CActor)ent2).AddBuffImmunity_AllNegative('ACS_Altar_Entity', true);

		((CActor)ent2).AddBuffImmunity_AllCritical('ACS_Altar_Entity', true);

		((CActor)ent2).SetUnpushableTarget(GetWitcherPlayer());

		((CActor)ent2).SetVisibility( false );

		ent2.AddTag('ACS_Fire_Bear_Altar_Entity');

		ent2.AddTag('ACS_Big_Boi');

		((CActor)ent2).AddTag( 'ContractTarget' );

		((CActor)ent2).AddTag('IsBoss');

		((CActor)ent2).AddAbility('Boss');

		((CActor)ent2).AddAbility('BounceBoltsWildhunt');

		ent2.AddTag('NoBestiaryEntry');

		movementAdjustor = ((CActor)ent2).GetMovingAgentComponent().GetMovementAdjustor();

		ticket = movementAdjustor.GetRequest( 'ACS_Fire_Bear_Altar_Rotate');
		movementAdjustor.CancelByName( 'ACS_Fire_Bear_Altar_Rotate' );
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACS_Fire_Bear_Altar_Rotate' );
		movementAdjustor.AdjustmentDuration( ticket, 0.00001 );
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );
		movementAdjustor.Continuous(ticket);

		movementAdjustor.RotateTowards(ticket, GetWitcherPlayer());

		//ent2.CreateAttachment( ent, , Vector( -0.25, -0.5, -0.75 ), EulerAngles(0,0,0) );
	}
}

state ACS_MonsterSpawner_KnightmareEternum in CACSMonsterSpawner
{
	private var temp, temp_2, ent_1_temp, trail_temp, quen_temp, quen_hit_temp, anchor_temp														: CEntityTemplate;
	private var ent, ent_2, quen_ent, quen_hit_ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3, chestblade_4, chestanchor			: CEntity;
	private var i, count																														: int;
	private var playerPos, spawnPos, newSpawnPos																								: Vector;
	private var randAngle, randRange																											: float;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var pos, attach_vec																										: Vector;
	private var rot, attach_rot, playerRot, adjustedRot																				: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Knightmare_Entry();
	}
	
	entry function Spawn_Knightmare_Entry()
	{	
		Spawn_Knightmare_Latent();
	}

	latent function Spawn_Knightmare_Latent()
	{
		if ( !theSound.SoundIsBankLoaded("sq_sk_209.bnk") )
		{
			theSound.SoundLoadBank( "sq_sk_209.bnk", false );
		}

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\ethernal.w2ent"
		
		, true );

		trail_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent" , true );

		quen_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\pc_quen_mq1060.w2ent" , true );

		quen_hit_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\pc_quen_hit_mq1060.w2ent" , true );

		spawnPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos) );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

		chestblade_1 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

		chestblade_2 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

		chestblade_3 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

		chestblade_4 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

		quen_ent = (CEntity)theGame.CreateEntity( quen_temp, spawnPos + Vector( 0, 0, -20 ) );

		quen_hit_ent = (CEntity)theGame.CreateEntity( quen_hit_temp, spawnPos + Vector( 0, 0, -20 ) );

		if(!ent)
		{
			return;
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.25;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		//((CNewNPC)ent).AddAbility('EtherealActive');

		ent.PlayEffectSingle('smokeman');
		ent.PlayEffectSingle('smokeman');
		ent.PlayEffectSingle('smokeman');

		//ent.PlayEffectSingle('demonic_possession');

		ent.PlayEffectSingle('red_electricity_r_arm');
		ent.PlayEffectSingle('red_electricity_r_arm');

		ent.PlayEffectSingle('default_fx');
		ent.PlayEffectSingle('default_fx');
		ent.PlayEffectSingle('default_fx');
		ent.PlayEffectSingle('default_fx');
		ent.PlayEffectSingle('default_fx');

		ent.SoundEvent("qu_sk_209_two_sirens_sings_loop");

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Knightmare_Eternum_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Knightmare_Eternum_Buff', true);

		ent.AddTag( 'ACS_Knightmare_Eternum' );

		ent.AddTag( 'ACS_Hostile_To_All' );

		sword_trail_1.CreateAttachment( ent, 'r_weapon');

		sword_trail_1.AddTag( 'ACS_knightmare_sword_trail' );

		sword_trail_1.PlayEffectSingle('special_attack_charged_iris');

		sword_trail_1.PlayEffectSingle('red_runeword_igni_1');

		sword_trail_1.PlayEffectSingle('red_runeword_igni_2');

		quen_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_ent.AddTag( 'ACS_knightmare_quen' );

		quen_hit_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_hit_ent.AddTag( 'ACS_knightmare_quen_hit' );

		quen_ent.StopEffect('default_fx');

		quen_ent.StopEffect('shield');

		attach_rot.Roll = 45;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;

		attach_vec.X = -0.5;
		// - go down, + go up

		attach_vec.Y = 0.25;

		attach_vec.Z = -0.4;
		// - go left, + go right

		chestblade_1.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_1.AddTag('ACS_knightmare_chest_blade_1');

		attach_rot.Roll = 30;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;
		attach_vec.X = -0.4;

		attach_vec.Y = 0.35;

		attach_vec.Z = -0.4;

		chestblade_2.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_2.AddTag('ACS_knightmare_chest_blade_2');

		attach_rot.Roll = 15;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;
		attach_vec.X = -0.3;

		attach_vec.Y = 0.45;

		attach_vec.Z = -0.4;

		chestblade_3.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_3.AddTag('ACS_knightmare_chest_blade_3');

		attach_rot.Roll = -45;
		attach_rot.Pitch = -120;
		attach_rot.Yaw = 0;

		attach_vec.X = 0.85;
		// - go down, + go up

		attach_vec.Y = -0.75;

		attach_vec.Z = 0.5;
		// - go left, + go right

		chestblade_4.CreateAttachment( ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_4.AddTag('ACS_knightmare_chest_blade_4');
	}
}

state ACS_MonsterSpawner_Loviatar in CACSMonsterSpawner
{
	private var temp																															: CEntityTemplate;
	private var ent																																: CEntity;
	private var spawnPos																														: Vector;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var playerRot, adjustedRot																											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Mother_Entry();
	}
	
	entry function Spawn_Mother_Entry()
	{	
		Spawn_Mother_Latent();
	}

	latent function Spawn_Mother_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\the_mother.w2ent"
		
		, true );

		spawnPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos) );

		if(!ent)
		{
			return;
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('him_smoke_red');

		ent.AddTag( 'ACS_She_Who_Knows' );

		ent.AddTag('ACS_Hostile_To_All');

		((CActor)ent).AddTag( 'ACS_Big_Boi' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_She_Who_Knows_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_She_Who_Knows_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost, 'ACS_She_Who_Knows_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_She_Who_Knows_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_She_Who_Knows_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_She_Who_Knows_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_She_Who_Knows_Buff', true);

		ent.AddTag('NoBestiaryEntry');
	}
}

state ACS_MonsterSpawner_FireWyrm in CACSMonsterSpawner
{
	private var temp																															: CEntityTemplate;
	private var ent																																: CEntity;
	private var spawnPos																														: Vector;
	private var meshcomp																														: CComponent;
	private var animcomp 																														: CAnimatedComponent;
	private var h 																																: float;
	private var playerRot, adjustedRot																											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Big_Lizard_Entry();
	}
	
	entry function Spawn_Big_Lizard_Entry()
	{	
		Spawn_Big_Lizard_Latent();
	}

	latent function Spawn_Big_Lizard_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\fire_oszluzg.w2ent"
		
		, true );

		spawnPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

		if(!ent)
		{
			return;
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)ent).SetAttitude(GetWitcherPlayer(), AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		//((CNewNPC)ent).SetCanPlayHitAnim(false);

		ent.PlayEffectSingle('flames');

		ent.PlayEffectSingle('embers_red');

		ent.AddTag( 'ACS_Big_Lizard' );

		((CActor)ent).AddTag( 'ACS_Big_Boi' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		((CActor)ent).AddBuffImmunity(EET_Burning, 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_LongStagger , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Big_Lizard', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Big_Lizard', true);
	}
}

state ACS_MonsterSpawner_RatMage in CACSMonsterSpawner
{
	private var temp, quen_temp, quen_hit_temp									: CEntityTemplate;
	private var ent, quen_ent, quen_hit_ent										: CEntity;
	private var spawnPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;	

	event OnEnterState(prevStateName : name)
	{
		Spawn_Rat_Mage_Entry();
	}
	
	entry function Spawn_Rat_Mage_Entry()
	{	
		Spawn_Rat_Mage_Latent();
	}

	latent function Spawn_Rat_Mage_Latent()
	{
		GetACSRatMage().Destroy();

		GetACSRatMageQuen().Destroy();

		GetACSRatMageQuenHit().Destroy();

		spawnPos = parent.pos;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\rat_mage.w2ent"
			
		, true );

		quen_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\pc_quen_mq1060.w2ent" , true );

		quen_hit_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\pc_quen_hit_mq1060.w2ent" , true );

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos) );

		quen_ent = (CEntity)theGame.CreateEntity( quen_temp, spawnPos + Vector( 0, 0, -20 ) );

		quen_hit_ent = (CEntity)theGame.CreateEntity( quen_hit_temp, spawnPos + Vector( 0, 0, -20 ) );

		if(!ent)
		{
			return;
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffectSingle('black_smoke');
		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('smoke');
		ent.PlayEffectSingle('demonic_possession');

		ent.AddTag( 'ACS_Rat_Mage' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Rat_Mage', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Rat_Mage', true);

		ent.AddTag('NoBestiaryEntry');



		quen_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_ent.AddTag( 'ACS_rat_mage_quen' );

		quen_hit_ent.CreateAttachment( ent, , Vector( 0, 0, 1 ) );

		quen_hit_ent.AddTag( 'ACS_rat_mage_quen_hit' );

		quen_ent.StopEffect('default_fx');

		quen_ent.StopEffect('shield');
	}
}

state ACS_MonsterSpawner_Mages in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var spawnPos, pos													: Vector;
	private var randAngle, randRange											: float;
	private var rot, playerRot, adjustedRot										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Mage_Entry();
	}
	
	entry function Spawn_Mage_Entry()
	{	
		Spawn_Mage_Latent();
	}

	latent function Spawn_Mage_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\mage.w2ent"

		, true );

		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(4,2);

		for( i = 0; i < count; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Mage' );

			ent.AddTag('ACS_Hostile_To_All');
		}
	}
}

state ACS_MonsterSpawner_CloakedVampiress in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var pos																: Vector;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Cloak_Vamp_Entry();
	}
	
	entry function Spawn_Cloak_Vamp_Entry()
	{	
		Spawn_Cloak_Vamp_Latent();
	}

	latent function Spawn_Cloak_Vamp_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\bob\data\characters\npc_entities\monsters\bruxa_cloak.w2ent"

		, true );

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(parent.pos), adjustedRot);

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		//((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cloak_Vamp' );
	}
}

state ACS_MonsterSpawner_Draugir in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var rot, playerRot, adjustedRot										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Draugir_Entry();
	}
	
	entry function Spawn_Draugir_Entry()
	{	
		Spawn_Draugir_Latent();
	}

	latent function Spawn_Draugir_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\draugir.w2ent"

		, true );

		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(50,12);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 10 + 10 * RandF();
			randAngle = 5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Draugir_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Draugir_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Draugir_Buff', true);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag('NoBestiaryEntry');

			//ent.PlayEffect('demonic_possession');

			ent.PlayEffect('critical_burning_small');

			ent.AddTag( 'ACS_Draugir' );

			ent.AddTag( 'ACS_Hostile_To_All' );
		}
	}
}

state ACS_MonsterSpawner_Draug in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var pos																: Vector;
	private var rot, playerRot, adjustedRot										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Draug_Static_Entry();
	}
	
	entry function Spawn_Draug_Static_Entry()
	{	
		Spawn_Draug_Static_Latent();
	}

	latent function Spawn_Draug_Static_Latent()
	{
		ACSDraug().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\draug.w2ent"

		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.25;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.5);

		//((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		((CNewNPC)ent).ChangeFightStage( NFS_Stage2 );

		((CNewNPC)ent).SetAppearance( 'ice_giant_anchor' );

		ent.PlayEffect('default_fx');

		ent.PlayEffect('critical_burning');

		ent.PlayEffect('demonic_possession');

		ent.PlayEffect('him_smoke');

		ent.PlayEffect('him_smoke_l');

		ent.PlayEffect('him_smoke_fire');

		//ent.PlayEffect('him_smoke_fire_l');

		ent.PlayEffect('smokeman');

		ent.PlayEffect('him_smoke_red');

		ent.PlayEffect('red_electricity_r_arm');

		ent.PlayEffect('critical_burning_ex');

		ent.PlayEffect('critical_burning_ex_r');

		ent.PlayEffect('critical_burning_ex_l');

		ent.PlayEffect('lugos_vision_burning');

		ent.PlayEffect('lugos_vision_burning_mat');

		ent.PlayEffect('lugos_vision_burning_gp');

		//ent.PlayEffect('hit_lightning');

		ent.AddTag( 'ACS_Draug' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

state ACS_MonsterSpawner_NecrofiendNest in CACSMonsterSpawner
{
	private var temp					: CEntityTemplate;
	private var ent						: CEntity;
	private var playerRot, adjustedRot	: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Necrofiend_Nest_Static_Entry();
	}
	
	entry function Spawn_Necrofiend_Nest_Static_Entry()
	{	
		Spawn_Necrofiend_Nest_Static_Latent();
	}

	latent function Spawn_Necrofiend_Nest_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\gravier_zombie_nest.w2ent"

		, true );

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(parent.pos), adjustedRot);
	}
}

state ACS_MonsterSpawner_HarpyQueenNest in CACSMonsterSpawner
{
	private var temp					: CEntityTemplate;
	private var ent						: CEntity;
	private var playerRot, adjustedRot	: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_HarpyQueen_Nest_Static_Entry();
	}
	
	entry function Spawn_HarpyQueen_Nest_Static_Entry()
	{	
		Spawn_HarpyQueen_Nest_Static_Latent();
	}

	latent function Spawn_HarpyQueen_Nest_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\harpy_queen_nest.w2ent"

		, true );

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(parent.pos), adjustedRot);
	}
}

state ACS_MonsterSpawner_Berserkers in CACSMonsterSpawner
{
	private var temp												: CEntityTemplate;
	private var ent													: CEntity;
	private var i, count											: int;
	private var playerPos, spawnPos, newSpawnPos					: Vector;
	private var randAngle, randRange								: float;
	private var meshcomp											: CComponent;
	private var animcomp 											: CAnimatedComponent;
	private var h 													: float;
	private var pos													: Vector;
	private var playerRot, rot, adjustedRot							: EulerAngles;	
	private var actor												: CActor; 
	private var actors		    									: array<CActor>;
	private var j													: int;
	private var npc													: CNewNPC;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Berserkers_Entry();
	}
	
	entry function Spawn_Berserkers_Entry()
	{	
		Spawn_Berserkers_Latent();
	}

	latent function Spawn_Berserkers_Latent()
	{
		playerPos = parent.pos;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\berserkers_human.w2ent"
			
		, true );

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		count = RandRange(5,3);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Berserker_Human_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Berserker_Human_Buff', true);

			ent.AddTag( 'ACS_Berserkers_Human' );

			ent.AddTag('ACS_Hostile_To_All');

			actors.Clear();

			actors = ((CActor)ent).GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer);
			{
				if( actors.Size() > 0 )
				{
					for( j = 0; j < actors.Size(); j += 1 )
					{
						npc = (CNewNPC)actors[j];

						actor = actors[j];

						if (actor.HasTag('ACS_Berserkers_Human'))
						{
							((CNewNPC)ent).SetAttitude(actor, AIA_Friendly);

							actor.SetAttitude(((CActor)ent), AIA_Friendly);
						}
						else
						{
							((CNewNPC)ent).SetAttitude(actor, AIA_Hostile);

							actor.SetAttitude(((CActor)ent), AIA_Hostile);
						}
					}
				}
			}
		}
	}
}

state ACS_MonsterSpawner_CatAssassin in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Lynx_Witcher_Entry();
	}
	
	entry function Spawn_Lynx_Witcher_Entry()
	{	
		Spawn_Lynx_Witcher_Latent();
	}

	latent function Spawn_Lynx_Witcher_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\witchers\lynx_witcher.w2ent"

		, true );

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(parent.pos), adjustedRot);

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CActor)ent).SetAnimationSpeedMultiplier(RandRangeF(1.25,1));

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

		((CActor)ent).GetInventory().AddAnItem('Lynx School steel sword 4', 1);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Lynx_Witcher_Buff', true);

		((CActor)ent).AttachBehaviorSync( 'LynxWitcher' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Lynx_Witcher' );
	}
}

state ACS_MonsterSpawner_NamelessDemon in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;
	private var spawnPos														: Vector;

	event OnEnterState(prevStateName : name)
	{
		Fire_Gargoyle_Spawn_Entry();
	}
	
	entry function Fire_Gargoyle_Spawn_Entry()
	{
		Fire_Gargoyle_Spawn_Latent();
	}
	
	latent function Fire_Gargoyle_Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\nameless_demon.w2ent"
			
		, true );

		spawnPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), playerRot );

		if (!ent)
		{
			return;
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).PlayEffectSingle('critical_burning');

		((CActor)ent).PlayEffectSingle('fire_hand_l');

		((CActor)ent).PlayEffectSingle('fire_hand_r');

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Fire_Gargoyle_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Fire_Gargoyle_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost, 'ACS_Fire_Gargoyle_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Fire_Gargoyle_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Fire_Gargoyle_Buff', true);

		((CActor)ent).SetCanPlayHitAnim(false);

		ent.AddTag( 'ACS_Fire_Gargoyle' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_Garmr in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var spawnPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Fluffy_Spawn_Entry();
	}
	
	entry function Fluffy_Spawn_Entry()
	{
		Fluffy_Spawn_Latent();
	}
	
	latent function Fluffy_Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\barghest.w2ent"
			
		, true );

		spawnPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

		if (!ent)
		{
			return;
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).PlayEffectSingle('shadow_form');

		((CActor)ent).PlayEffectSingle('critical_burning_red');

		((CActor)ent).PlayEffectSingle('critical_burning_red_alt');

		((CActor)ent).AddBuffImmunity(EET_Burning, 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Fluffy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).GetInventory().AddAnItem( 'acs_wolf_heart' , 1 );

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Fluffy' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_FataMorgana in CACSMonsterSpawner
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var spawnPos														: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Fog_Assassin_Spawn_Entry();
	}
	
	entry function Fog_Assassin_Spawn_Entry()
	{
		Fog_Assassin_Spawn_Latent();
	}
	
	latent function Fog_Assassin_Spawn_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\fogling_lvl4.w2ent"
			
		, true );

		spawnPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

		ACS_FogAssassinSmokeScreen(((CActor)ent), ((CActor)ent).GetWorldPosition());

		if (!ent)
		{
			return;
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Fog_Assassin_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Fog_Assassin' );

		((CActor)ent).SoundEvent("monster_fogling_appear_disappear_vfx");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_XenoTyrantEgg in CACSMonsterSpawner
{
	private var temp, temp2														: CEntityTemplate;
	private var ent, ent2 														: CEntity;
	private var playerPos, spawnPos, newPlayerPos, newSpawnPos					: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var pos																: Vector;
	private var rot, playerRot, adjustedRot										: EulerAngles;
	private var i, count														: int;

	event OnEnterState(prevStateName : name)
	{
		Static_Spawn_XenoSwarm_Entry();
	}
	
	entry function Static_Spawn_XenoSwarm_Entry()
	{	
		Static_Spawn_XenoSwarm_Latent();
	}

	latent function Static_Spawn_XenoSwarm_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_egg_tyrant.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		ent.AddTag( 'ACS_Xeno_Tyrant_Egg' );

		temp2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\xeno_egg_normal.w2ent"
			
		, true );

		count = 20;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 15 + 15 * RandF();
			randAngle = 10 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent2 = theGame.CreateEntity( temp2, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			((CNewNPC)ent2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent2).SetAttitude(thePlayer, AIA_Hostile);

			ent2.AddTag( 'ACS_Xeno_Egg' );
		}
	}
}

state ACS_MonsterSpawner_CultOfMelusine in CACSMonsterSpawner
{
	private var temp_1, temp_2, temp_3, temp_4, temp_5, temp_6, temp_7			: CEntityTemplate;
	private var ent, ent_2, ent_3, ent_4										: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos, bossPos									: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot, bossRot, adjustedRot		: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Cultist_Static_Spawn_Entry();
	}
	
	entry function Cultist_Static_Spawn_Entry()
	{	
		Cultist_Static_Spawn_Latent();
	}
	
	latent function Cultist_Static_Spawn_Latent()
	{
		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_axe.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_blunt.w2ent"
			
		, true );

		temp_6 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_thrall.w2ent"
			
		, true );

		temp_7 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\cultist\cultist_singer.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if (RandF() < 0.5)
		{
			temp_1 = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss.w2ent"
				
			, true );

			ent = theGame.CreateEntity( temp_1, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}
		else
		{
			temp_2 = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\monsters\cultist\cultist_boss_blunt.w2ent"
				
			, true );

			ent = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );
		}

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Cultist_Boss' );

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).AddAbility('DisableFinisher');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('DisableDismemberment');

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Cultist_Boss_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Cultist_Boss_Buff', true);

		ent.AddTag('NoBestiaryEntry');

		bossPos = ent.GetWorldPosition();

		bossRot = ent.GetWorldRotation();

		count = 10;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + bossPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + bossPos.Y;
			spawnPos.Z = bossPos.Z;

			if (RandF() < 0.5)
			{
				ent_2 = theGame.CreateEntity( temp_3, ACSPlayerFixZAxis(spawnPos), bossRot );
			}
			else
			{
				if (RandF() < 0.75)
				{
					ent_2 = theGame.CreateEntity( temp_4, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
				else
				{
					ent_2 = theGame.CreateEntity( temp_5, ACSPlayerFixZAxis(spawnPos), bossRot );
				}
			}

			animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_2).SetAnimationSpeedMultiplier(1);

			((CActor)ent_2).AddAbility('DisableDismemberment');

			ent_2.AddTag( 'ACS_Cultist' );


			ent_3 = theGame.CreateEntity( temp_6, ACSPlayerFixZAxis(spawnPos), bossRot );

			((CNewNPC)ent_3).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_3).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_3).SetAnimationSpeedMultiplier(1);

			((CActor)ent_3).AddAbility('DisableDismemberment');

			ent_3.AddTag( 'ACS_Cultist_Thrall' );




			if (RandF() < 0.33)
			{
				ent_4 = theGame.CreateEntity( temp_7, ACSPlayerFixZAxis(spawnPos), bossRot );
			}

			((CNewNPC)ent_4).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent_4).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent_4).SetAnimationSpeedMultiplier(1);

			((CActor)ent_4).AddAbility('DisableDismemberment');

			ent_4.AddTag('ACS_Cultist_Singer');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_Rioghan in CACSMonsterSpawner
{
	private var temp, ent_1_temp, trail_temp																: CEntityTemplate;
	private var ent, sword_trail_1, chestblade_1, chestblade_2, chestblade_3								: CEntity;
	private var i, count																					: int;
	private var playerPos, spawnPos																			: Vector;
	private var randAngle, randRange																		: float;
	private var meshcomp																					: CComponent;
	private var animcomp 																					: CAnimatedComponent;
	private var h 																							: float;
	private var bone_vec, pos, attach_vec																	: Vector;
	private var bone_rot, rot, attach_rot, playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Pirate_Zombie_Static_Spawn_Entry();
	}
	
	entry function Pirate_Zombie_Static_Spawn_Entry()
	{	
		Pirate_Zombie_Static_Spawn_Latent();
	}
	
	latent function Pirate_Zombie_Static_Spawn_Latent()
	{
		GetACSPirateZombie().Destroy();

		GetACSPirateZombieSwordTrail().Destroy();

		GetACSPirateZombieChestBone1().Destroy();

		GetACSPirateZombieChestBone2().Destroy();

		GetACSPirateZombieChestBone3().Destroy();

		GetACSPirateZombieChestBone4().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\pirate_zombie.w2ent"
			
		, true );

		trail_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent" , true );

		ent_1_temp = (CEntityTemplate)LoadResourceAsync( "environment\decorations\corpses\armor_pieces\leg_bones01.w2ent" , true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, ACSPlayerFixZAxis(playerPos) + Vector( 0, 0, -20 ) );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.125;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.125);

		//((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

		((CActor)ent).GetInventory().AddAnItem('acs_pirate_amulet', 1);

		ent.AddTag( 'ACS_Pirate_Zombie' );

		sword_trail_1.CreateAttachment( ent, 'r_weapon');

		sword_trail_1.AddTag('ACS_Pirate_Zombie_Trail');

		sword_trail_1.PlayEffectSingle('red_runeword_igni_1');

		sword_trail_1.PlayEffectSingle('red_runeword_igni_2');


		chestblade_1 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

		chestblade_2 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

		chestblade_3 = (CEntity)theGame.CreateEntity( trail_temp, spawnPos + Vector( 0, 0, -20 ) );

		//chestblade_4 = (CEntity)theGame.CreateEntity( ent_1_temp, spawnPos + Vector( 0, 0, -20 ) );

		attach_rot.Roll = -15;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;

		attach_vec.X = 0;
		// - go down, + go up

		attach_vec.Y = -0.25;

		attach_vec.Z = 0;
		// - go left, + go right

		chestblade_1.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_1.AddTag('ACS_Pirate_Zombie_Chest_Bone_1');

		attach_rot.Roll = -30;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;
		attach_vec.X = -0.1;

		attach_vec.Y = -0.45;

		attach_vec.Z = 0;

		chestblade_2.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_2.AddTag('ACS_Pirate_Zombie_Chest_Bone_2');

		attach_rot.Roll = -45;
		attach_rot.Pitch = 60;
		attach_rot.Yaw = 0;
		attach_vec.X = -0.2;

		attach_vec.Y = -0.65;

		attach_vec.Z = 0;

		chestblade_3.CreateAttachment(  ent, 'blood_point' ,attach_vec, attach_rot);

		chestblade_3.AddTag('ACS_Pirate_Zombie_Chest_Bone_3');

		chestblade_1.PlayEffectSingle('bone_glow');
		chestblade_2.PlayEffectSingle('bone_glow');
		chestblade_3.PlayEffectSingle('bone_glow');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_Svalblod in CACSMonsterSpawner
{
	private var temp, temp_2													: CEntityTemplate;
	private var ent, ent_2														: CEntity;
	private var i, j															: int;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;	
	private var l_comp 															: array< CComponent >;
	private var size 															: int;

	event OnEnterState(prevStateName : name)
	{
		Svalblod_Static_Spawn_Entry();
	}
	
	entry function Svalblod_Static_Spawn_Entry()
	{	
		Svalblod_Static_Spawn_Latent();
	}
	
	latent function Svalblod_Static_Spawn_Latent()
	{
		GetACSSvalblod().Destroy();

		GetACSSvalblodBear().Destroy();

		GetACSSvalblodBossbar().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\svalblod_human.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\svalblod_bossbar.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
			
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Svalblod_Human_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		//((CActor)ent).AddAbility('DjinnRage');

		ent.AddTag('NoBestiaryEntry');

		((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

		ent.AddTag( 'ACS_Svalblod' );

		ent.PlayEffectSingle('acs_armor_effect_1');
		ent.PlayEffectSingle('acs_armor_effect_2');
		ent.PlayEffectSingle('demonic_possession');

		l_comp = ((CActor)ent).GetComponentsByClassName( 'CMorphedMeshManagerComponent' );
		size = l_comp.Size();

		for ( j=0; j<size; j+= 1 )
		{
			((CMorphedMeshManagerComponent)l_comp[ j ]).SetMorphBlend( 1, 0.5 );
		}

		ent_2 = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_2.GetComponentByClassName('CMeshComponent');
		h = 0;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		animcomp.FreezePose();

		((CNewNPC)ent_2).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Hostile);

		ent_2.CreateAttachment( ent , , Vector(0,0,5) );

		ent_2.AddTag('ACS_Svalblod_Bossbar');

		((CActor)ent_2).AddTag('IsBoss');

		((CActor)ent_2).AddAbility('Boss');

		((CActor)ent_2).AddAbility('BounceBoltsWildhunt');

		((CActor)ent_2).EnableCollisions(false);

		((CActor)ent_2).EnableCharacterCollisions(false);

		((CActor)ent_2).AddBuffImmunity_AllNegative('acs_svalblod_boss_buff_all_negative', true); 
		((CActor)ent_2).AddBuffImmunity_AllCritical('acs_svalblod_boss_buff_all_critical', true); 

		((CNewNPC)ent_2).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

		ent_2.StopAllEffects();
	
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_Duskwraith in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Duskwraith_Static_Entry();
	}
	
	entry function Spawn_Duskwraith_Static_Entry()
	{	
		Spawn_Duskwraith_Static_Latent();
	}

	latent function Spawn_Duskwraith_Static_Latent()
	{
		ACSDuskwraith().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\duskwraith.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.25;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Duskwraith_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).GetInventory().AddAnItem('Noonwraith light essence', 2);

		((CActor)ent).GetInventory().AddAnItem('Noonwraith mutagen', 2);

		((CActor)ent).GetInventory().AddAnItem('Nightwraith dark essence', 2);

		((CActor)ent).GetInventory().AddAnItem('Nightwraith mutagen', 2);

		((CActor)ent).GetInventory().AddAnItem('Nightwraiths hair', 3);

		//((CActor)ent).AddAbility('DjinnRage');

		//ent.PlayEffectSingle('shadows_form');

		ent.PlayEffectSingle('shadows_form_noonwraith_test');

		ent.PlayEffectSingle('shadows_form_banshee');

		ent.PlayEffectSingle('default');

		//ent.PlayEffectSingle('shadows_form_iris');

		((CNewNPC)ent).EnableCharacterCollisions(false); 

		ent.AddTag('NoBestiaryEntry');

		((CNewNPC)ent).SetBehaviorVariable( 'lookatOn', 0, true );

		ent.AddTag( 'ACS_Duskwraith' );
	}
}

state ACS_MonsterSpawner_OmnesMoriendus in CACSMonsterSpawner
{
	private var temp, temp_2													: CEntityTemplate;
	private var ent, ent_2, ent_3												: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h, dist 														: float;
	private var playerRot, adjustedRot											: EulerAngles;
	private var movementAdjustorBigWraith										: CMovementAdjustor;
	private var ticket_1														: SMovementAdjustmentRequestTicket;	

	event OnEnterState(prevStateName : name)
	{
		Spawn_MegaWraith_Static_Entry();
	}
	
	entry function Spawn_MegaWraith_Static_Entry()
	{	
		Spawn_MegaWraith_Static_Latent();
	}

	latent function Spawn_MegaWraith_Static_Latent()
	{
		GetACSMegaWraith().Destroy();

		GetACSMegaWraithRWeapon().Destroy();

		GetACSMegaWraithLWeapon().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\mega_wraith.w2ent"

		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\swords\nomansland_sword_rusty.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
		

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.PlayEffect('critical_burning_green_ex');

		ent.PlayEffect('critical_burning_green_ex_r');

		ent.PlayEffect('candle');

		ent.PlayEffect('appear');

		ent.AddTag( 'ACS_MegaWraith' );


		movementAdjustorBigWraith = ((CActor)ent).GetMovingAgentComponent().GetMovementAdjustor();

		dist = ((((CMovingPhysicalAgentComponent)((CActor)ent).GetMovingAgentComponent()).GetCapsuleRadius())
		+ (((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent()).GetCapsuleRadius()) ) * 1.75;

		ticket_1 = movementAdjustorBigWraith.GetRequest( 'ACS_MegaWraith_Rotate');
		movementAdjustorBigWraith.CancelByName( 'ACS_MegaWraith_Rotate' );
		movementAdjustorBigWraith.CancelAll();

		ticket_1 = movementAdjustorBigWraith.CreateNewRequest( 'ACS_MegaWraith_Rotate' );
		movementAdjustorBigWraith.AdjustmentDuration( ticket_1, 3 );
		movementAdjustorBigWraith.MaxRotationAdjustmentSpeed( ticket_1, 500000 );
		//movementAdjustorBigWraith.Continuous(ticket_1);

		movementAdjustorBigWraith.RotateTowards(ticket_1, GetWitcherPlayer());

		//movementAdjustorBigWraith.SlideTowards(ticket_1, GetWitcherPlayer(), dist, dist);


		ent_2 = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );

		ent_2.CreateAttachment(ent, 'attach_slot_l', Vector(0.1,-0.025,0), EulerAngles(180,0,0));

		ent_2.AddTag('ACS_MegaWraith_L_Weapon');


		ent_3 = theGame.CreateEntity( temp_2, ACSPlayerFixZAxis(playerPos), adjustedRot );

		ent_3.CreateAttachment(ent, 'attach_slot_r', Vector(0.1,0.025,0), EulerAngles(0,0,0));

		ent_3.AddTag('ACS_MegaWraith_R_Weapon');
	}
}

state ACS_MonsterSpawner_OpinicusMatriarch in CACSMonsterSpawner
{
	private var temp 															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Fire_Gryphon_Static_Entry();
	}
	
	entry function Spawn_Fire_Gryphon_Static_Entry()
	{	
		Spawn_Fire_Gryphon_Static_Latent();
	}

	latent function Spawn_Fire_Gryphon_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\mh301_gryphon.w2ent"
			
		, true );

		playerPos = parent.pos;
		
		playerPos.Z += 10;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, playerPos, adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Fire_Gryphon_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.PlayEffect('critical_burning_ex_r');

		ent.PlayEffect('critical_burning_ex_l');

		ent.PlayEffect('lugos_vision_burning');

		ent.PlayEffect('lugos_vision_burning_mat');

		ent.AddTag( 'ACS_Fire_Gryphon' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

state ACS_MonsterSpawner_Incubus in CACSMonsterSpawner
{
	private var temp												: CEntityTemplate;
	private var ent													: CEntity;
	private var i, count											: int;
	private var playerPos, spawnPos, newSpawnPos					: Vector;
	private var randAngle, randRange								: float;
	private var meshcomp											: CComponent;
	private var animcomp 											: CAnimatedComponent;
	private var h 													: float;
	private var pos													: Vector;
	private var playerRot, rot, adjustedRot							: EulerAngles;	
	private var num													: int;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Incubus_Entry();
	}
	
	entry function Spawn_Incubus_Entry()
	{	
		Spawn_Incubus_Latent();
	}

	latent function Spawn_Incubus_Latent()
	{
		num = RandRange(5,0);

		switch (num)
		{
			default:
			temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\enemy_sorcerers\enemy_succubus.w2ent", true);
			break;

			case 0:
			temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\enemy_sorcerers\enemy_succubus.w2ent", true);
			break;

			case 1:
			temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\enemy_sorcerers\enemy_sorceress.w2ent", true);
			break;

			case 2:
			temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\enemy_sorcerers\lynx_witch_version.w2ent", true);
			break;

			case 3:
			temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\enemy_sorcerers\philipa_version.w2ent", true);
			break;

			case 4:
			temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\enemy_sorcerers\all_in_one_prototype.w2ent", true);
			break;
		}

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(parent.pos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag( 'ACS_Incubus' );

		ent.AddTag('ACS_Hostile_To_All');
	}
}

state ACS_MonsterSpawner_Mula in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Mula_Static_Entry();
	}
	
	entry function Spawn_Mula_Static_Entry()
	{	
		Spawn_Mula_Static_Latent();
	}

	latent function Spawn_Mula_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\mula.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Mula_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Mula_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		//((CActor)ent).RemoveAbility('Venom');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Mula' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

state ACS_MonsterSpawner_BloodHym in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Blood_Hym_Entry();
	}

	entry function Spawn_Blood_Hym_Entry()
	{	
		Spawn_Blood_Hym_Latent();
	}
	
	latent function Spawn_Blood_Hym_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\mini_hym_alt.w2ent"

		, true );

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(parent.pos), adjustedRot);

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.5);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Mini_Hym_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession_ex');

		ent.AddTag( 'ACS_Mini_Hym' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

state ACS_MonsterSpawner_Orianna in CACSMonsterSpawner
{
	private var temp												: CEntityTemplate;
	private var ent													: ACSOriannaDisappearController;
	private var playerPos											: Vector;
	private var playerRot, rot, adjustedRot							: EulerAngles;	

	event OnEnterState(prevStateName : name)
	{
		Spawn_Orianna_Controller_Entry();
	}
	
	entry function Spawn_Orianna_Controller_Entry()
	{	
		Spawn_Orianna_Controller_Latent();
	}

	latent function Spawn_Orianna_Controller_Latent()
	{
		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\orianna_disappear_controller.w2ent"
			
		, true );

		ent = (ACSOriannaDisappearController)theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );
	}
}

state ACS_MonsterSpawner_HeartOfDarkness in CACSMonsterSpawner
{
	private var temp											: CEntityTemplate;
	private var ent												: CEntity;
	private var playerPos										: Vector;
	private var playerRot										: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Heart_Of_Darkness_Static_Entry();
	}
	
	entry function Spawn_Heart_Of_Darkness_Static_Entry()
	{	
		Spawn_Heart_Of_Darkness_Static_Latent();
	}

	latent function Spawn_Heart_Of_Darkness_Static_Latent()
	{
		GetACSHeartOfDarkness().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\heart_of_darkness\heart_of_darkness.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = EulerAngles(0,-45,0);

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), playerRot );

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.AddTag( 'ACS_Heart_Of_Darkness' );
	}
}

state ACS_MonsterSpawner_Bumbakvetch in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Bumbakvetch_Static_Entry();
	}
	
	entry function Spawn_Bumbakvetch_Static_Entry()
	{	
		Spawn_Bumbakvetch_Static_Latent();
	}

	latent function Spawn_Bumbakvetch_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\bies_hybrid.w2ent"

		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.75);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Bumbakvetch_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		//((CActor)ent).RemoveAbility('Venom');

		ent.PlayEffect('glow');
		ent.PlayEffect('glow');
		ent.PlayEffect('glow');
		ent.PlayEffect('glow');
		ent.PlayEffect('glow');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Bumbakvetch' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

state ACS_MonsterSpawner_IceBoar in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_IceBoar_Static_Entry();
	}
	
	entry function Spawn_IceBoar_Static_Entry()
	{	
		Spawn_IceBoar_Static_Latent();
	}

	latent function Spawn_IceBoar_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\boar_beast.w2ent"

		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.825);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Frozen , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_SlowdownFrost , 'ACS_Ice_Boar_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.PlayEffect('ice');

		ent.AddTag( 'ACS_Ice_Boar' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

state ACS_MonsterSpawner_NimeanPanther in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_NimeanPanther_Static_Entry();
	}
	
	entry function Spawn_NimeanPanther_Static_Entry()
	{	
		Spawn_NimeanPanther_Static_Latent();
	}

	latent function Spawn_NimeanPanther_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\panther.w2ent"

		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.75;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.75);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Nimean_Panther_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('demonic_possession');

		ent.PlayEffect('glow');

		ent.AddTag( 'ACS_Nimean_Panther' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

state ACS_MonsterSpawner_ForestGodShadow in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_ForestGodShadows_Entry();
	}
	
	entry function Spawn_ForestGodShadows_Entry()
	{	
		Spawn_ForestGodShadows_Latent();
	}

	latent function Spawn_ForestGodShadows_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\forest_god_shadow.w2ent"
			
		, true );

		playerPos = parent.GetWorldPosition();

		if( thePlayer.GetStat( BCS_Vitality ) <= thePlayer.GetStatMax(BCS_Vitality)/2 ) 
		{	
			count = 1;
		}
		else if( thePlayer.GetStat( BCS_Vitality ) == thePlayer.GetStatMax(BCS_Vitality) ) 
		{
			count = 2;
		}
		else
		{
			count = 1;
		}
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			theGame.GetWorld().NavigationFindSafeSpot(spawnPos, 0.5f, 20.f, spawnPos);

			playerRot = thePlayer.GetWorldRotation();

			playerRot.Yaw += 180;

			adjustedRot = EulerAngles(0,0,0);

			adjustedRot.Yaw = playerRot.Yaw;
			
			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), adjustedRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 0.65;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CActor)ent).GetInventory().AddAnItem( 'Emerald flawless', 3 );

			((CActor)ent).GetInventory().AddAnItem( 'Leshy mutagen', 1 );

			((CNewNPC)ent).SetLevel( thePlayer.GetLevel() - 15 );

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CNewNPC)ent).SetTemporaryAttitudeGroup( 'hostile_to_player', AGP_Default );

			((CActor)ent).SetAnimationSpeedMultiplier(1.25);

			((CActor)ent).AddBuffImmunity_AllNegative('ACS_Forest_God_Shadows', true);

			((CActor)ent).AddBuffImmunity_AllCritical('ACS_Forest_God_Shadows', true);

			((CActor)ent).EnableCharacterCollisions(false);

			((CActor)ent).SetUnpushableTarget(thePlayer);

			((CActor)ent).PlayEffectSingle('demonic_possession');

			if (count == 2)
			{
				((CActor)ent).DrainEssence(((CActor)ent).GetStatMax(BCS_Essence)/2);
			}

			((CActor)ent).RemoveBuffImmunity(EET_Slowdown);

			((CActor)ent).RemoveBuffImmunity(EET_Paralyzed);

			((CActor)ent).RemoveBuffImmunity(EET_Stagger);

			ent.AddTag( 'ACS_Forest_God_Shadows' );

			ent.AddTag( 'ContractTarget' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_ShadowPixies in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var rot, playerRot, adjustedRot										: EulerAngles;
	private var num, num_2														: int;

	event OnEnterState(prevStateName : name)
	{
		Spawn_ShadowPixies_Entry();
	}
	
	entry function Spawn_ShadowPixies_Entry()
	{	
		Spawn_ShadowPixies_Latent();
	}

	latent function Spawn_ShadowPixies_Latent()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(6,3);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			num = RandRange(2,0);

			switch (num)
			{
				default:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\monsters\shadow_pixie_1.w2ent", true);
				break;

				case 0:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\monsters\shadow_pixie_1.w2ent", true);
				break;

				case 1:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\monsters\shadow_pixie_2.w2ent", true);
				break;
			}

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			//ent.AddTag('NoBestiaryEntry');

			ent.AddTag( 'ACS_Shadow_Pixie' );
		}
	}
}

state ACS_MonsterSpawner_DemonicConstruct in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_DemonicConstruct_Static_Entry();
	}
	
	entry function Spawn_DemonicConstruct_Static_Entry()
	{	
		Spawn_DemonicConstruct_Static_Latent();
	}

	latent function Spawn_DemonicConstruct_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\demonic_construct.w2ent"

		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.125;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Demonic_Construct_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Demonic_Construct' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

state ACS_MonsterSpawner_DarkKnight in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		Spawn_DarkKnight_Entry();
	}
	
	entry function Spawn_DarkKnight_Entry()
	{	
		Spawn_DarkKnight_Latent();
	}

	latent function Spawn_DarkKnight_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\dark_knight.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('ghost');

		ent.PlayEffect('him_smoke_red');

		ent.PlayEffect('shadow_form');

		ent.PlayEffect('smoke_effect_1');

		ent.PlayEffect('smoke_effect_2');

		ent.AddTag( 'ACS_Dark_Knight' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_DarkKnightCalidus in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		Spawn_DarkKnightCalidus_Entry();
	}
	
	entry function Spawn_DarkKnightCalidus_Entry()
	{	
		Spawn_DarkKnightCalidus_Latent();
	}

	latent function Spawn_DarkKnightCalidus_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\dark_knight_calidus.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('lugos_vision_burning_mat');

		//ent.PlayEffect('burning_body');

		ent.PlayEffect('him_smoke_red');

		ent.PlayEffect('shadow_form');

		ent.PlayEffect('lugos_vision_burning');

		ent.PlayEffect('smoke_effect_1');

		ent.PlayEffect('smoke_effect_2');

		ent.AddTag( 'ACS_Dark_Knight_Calidus' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_Voref in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		Spawn_Voref_Entry();
	}
	
	entry function Spawn_Voref_Entry()
	{	
		Spawn_Voref_Latent();
	}

	latent function Spawn_Voref_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\voref.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.125);

		((CActor)ent).SetCanPlayHitAnim(true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Voref' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_Maerolorn in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var rot, playerRot, adjustedRot										: EulerAngles;
	private var num, num_2														: int;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Maerolorn_Entry();
	}
	
	entry function Spawn_Maerolorn_Entry()
	{	
		Spawn_Maerolorn_Latent();
	}

	latent function Spawn_Maerolorn_Latent()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = 3;
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			temp = (CEntityTemplate)LoadResourceAsync( 

			"dlc\dlc_acs\data\entities\monsters\maerolorn.w2ent"
				
			, true );

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			//ent.AddTag('NoBestiaryEntry');

			((CActor)ent).AddAbility('InstantKillImmune');

			((CActor)ent).AddAbility('DisableFinishers');

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.PlayEffect('shadow_form');
			
			ent.PlayEffect('shadow_form_head');

			ent.PlayEffect('demonic_eye_r');

			ent.PlayEffect('demonic_eye_l');

			ent.PlayEffect('shadow_smoke');

			ent.AddTag('NoBestiaryEntry');

			ent.AddTag( 'ACS_Maerolorn' );
		}
	}
}

state ACS_MonsterSpawner_Ifrit in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var pos																: Vector;
	private var playerRot														: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		Spawn_Ifrit_Entry();
	}
	
	entry function Spawn_Ifrit_Entry()
	{	
		Spawn_Ifrit_Latent();
	}

	latent function Spawn_Ifrit_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\ifrit.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CActor)ent).RemoveBuff(EET_FireAura, true, 'acs_ifrit_fire_aura');

		((CActor)ent).AddEffectDefault( EET_FireAura, ((CActor)ent), 'acs_ifrit_fire_aura' );

		ent.PlayEffectSingle('fire');

		ent.AddTag( 'ACS_Ifrit' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_Carduin in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var pos																: Vector;
	private var playerRot														: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		Spawn_Carduin_Entry();
	}
	
	entry function Spawn_Carduin_Entry()
	{	
		Spawn_Carduin_Latent();
	}

	latent function Spawn_Carduin_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\mages\carduin_of_lan_exeter.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag( 'ACS_Carduin' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

state ACS_MonsterSpawner_ViyOfMaribor in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Viy_Entry();
	}
	
	entry function Spawn_Viy_Entry()
	{	
		Spawn_Viy_Latent();
	}

	latent function Spawn_Viy_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\viy_of_maribor.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 10;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.875);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Viy_Of_Maribor_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('AcidSpit');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.PlayEffect('glow1');
		ent.PlayEffect('glow2');
		ent.PlayEffect('glow3');

		ent.AddTag( 'ACS_Viy_Of_Maribor' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACSViyOfMaribor() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Viy_Of_Maribor' );
	return entity;
}

statemachine class CACSViyBaseEffect extends CGameplayEntity
{
	var pos : Vector;
	var rot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		pos = this.GetWorldPosition();
		rot = this.GetWorldRotation();

		AddTimer('CreateFireLine', 1.5, false);

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( pos ), 1.f, 10, 1.f, 60.f, 1);

		GCameraShake(1.0, true, this.GetWorldPosition(), 60.0f, false);
	}

	timer function CreateFireLine ( dt : float, id : int )
	{
		var meteorEntityTemplate 		: CEntityTemplate;
		var meteorEntity 				: W3ACSViyBaseEffectFireLine;

		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}

		meteorEntityTemplate = (CEntityTemplate)LoadResource(

		"dlc\dlc_acs\data\entities\projectiles\scolopendromorph_base_effect_fire_line.w2ent"
		
		, true );

		meteorEntity = (W3ACSViyBaseEffectFireLine)theGame.CreateEntity(meteorEntityTemplate, ACSPlayerFixZAxis(pos), rot);
		meteorEntity.Init(ACSViyOfMaribor());

		meteorEntity.PlayEffectSingle('fire_line_old');
		meteorEntity.ShootProjectileAtPosition( 0, 10, pos, 500 );

		meteorEntity.StopAllEffectsAfter(1.5);

		meteorEntity.DestroyAfter(10);

		GCameraShake(1.0, true, this.GetWorldPosition(), 60.0f, false);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

state ACS_MonsterSpawner_Phooca in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;
	
	event OnEnterState(prevStateName : name)
	{
		Spawn_Phooca_Entry();
	}
	
	entry function Spawn_Phooca_Entry()
	{	
		Spawn_Phooca_Latent();
	}

	latent function Spawn_Phooca_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\phooca.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.375;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.125);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		//((CActor)ent).AddTag('ACS_Legolas');

		//((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('AcidSpit');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Phooca' );

		ent.AddTag( 'ACS_Hostile_To_All' );
		
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_Plumard in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;
	
	event OnEnterState(prevStateName : name)
	{
		Spawn_Plumard_Entry();
	}
	
	entry function Spawn_Plumard_Entry()
	{	
		Spawn_Plumard_Latent();
	}

	latent function Spawn_Plumard_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\plumard.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		count = RandRange(9,5);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel()/2);

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).SetCanPlayHitAnim(true);

			ent.AddTag('NoBestiaryEntry');

			ent.AddTag( 'ACS_Plumard' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_GiantRockTroll in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_GiantRockTroll_Entry();
	}
	
	entry function Spawn_GiantRockTroll_Entry()
	{	
		Spawn_GiantRockTroll_Latent();
	}

	latent function Spawn_GiantRockTroll_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\giant_rock_troll.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.9);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Giant_Troll' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_GiantIceTroll in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_GiantIceTroll_Entry();
	}
	
	entry function Spawn_GiantIceTroll_Entry()
	{	
		Spawn_GiantIceTroll_Latent();
	}

	latent function Spawn_GiantIceTroll_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\giant_ice_troll.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.9);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Giant_Troll' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_GiantMagmaTroll in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_GiantMagmaTroll_Entry();
	}
	
	entry function Spawn_GiantMagmaTroll_Entry()
	{	
		Spawn_GiantMagmaTroll_Latent();
	}

	latent function Spawn_GiantMagmaTroll_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\giant_magma_troll.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.9);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Giant_Troll' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_TheBeast in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;
	
	event OnEnterState(prevStateName : name)
	{
		Spawn_TheBeast_Entry();
	}
	
	entry function Spawn_TheBeast_Entry()
	{	
		Spawn_TheBeast_Latent();

		Spawn_TheBeastMinions_Latent();
	}

	latent function Spawn_TheBeast_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\the_beast.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		//((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Hellhound' );

		ent.AddTag( 'ACS_Hellhound_Pack' );
	}

	latent function Spawn_TheBeastMinions_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\the_beast_minion.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;
		
		count = RandRange(4,2);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(spawnPos), playerRot );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel()/2);

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).SetCanPlayHitAnim(true);

			ent.AddTag( 'ACS_Hellhound_Minion' );

			ent.AddTag( 'ACS_Hellhound_Pack' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_ElementalTitanOfFire in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_ElementalTitanOfFire_Entry();
	}
	
	entry function Spawn_ElementalTitanOfFire_Entry()
	{	
		Spawn_ElementalTitanOfFire_Latent();
	}

	latent function Spawn_ElementalTitanOfFire_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\giant_fire_elemental.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.9);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_LongStagger , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CNewNPC)ent).SetUnstoppable( true );

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Elemental_Titan' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_ElementalTitanOfTerra in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_ElementalTitanOfTerra_Entry();
	}
	
	entry function Spawn_ElementalTitanOfTerra_Entry()
	{	
		Spawn_ElementalTitanOfTerra_Latent();
	}

	latent function Spawn_ElementalTitanOfTerra_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\giant_rock_elemental.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.9);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_LongStagger , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CNewNPC)ent).SetUnstoppable( true );

		//((CActor)ent).RemoveAbility('ThrowStone');

		//((CActor)ent).AddAbility('ThrowFire');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Elemental_Titan' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_ElementalTitanOfIce in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos														: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot														: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_ElementalTitanOfIce_Entry();
	}
	
	entry function Spawn_ElementalTitanOfIce_Entry()
	{	
		Spawn_ElementalTitanOfIce_Latent();
	}

	latent function Spawn_ElementalTitanOfIce_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\giant_ice_elemental.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), playerRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 2.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(0.9);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Stagger , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_LongStagger , 'ACS_Elemental_Titan_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddTag('ACS_Big_Boi');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('ForceCriticalEffects');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		((CNewNPC)ent).SetUnstoppable( true );

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Elemental_Titan' );

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

state ACS_MonsterSpawner_HorseRidersNovigrad in CACSMonsterSpawner
{
	private var temp, temp_2, temp_3											: CEntityTemplate;
	private var ent, ent_2, ent_3												: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos, newSpawnPos								: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	private var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	private var l_aiTree														: CAIHorseDoNothingAction;			
	private var horseTag 														: array<name>;	
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;
	private var l_aiTreeFollow													: CAIFollowSideBySideAction;	
	var actor							: CActor; 
	var enemyAnimatedComponent 			: CAnimatedComponent;

	var actors		    				: array<CActor>;
	var npc								: CNewNPC;

	event OnEnterState(prevStateName : name)
	{
		Spawn_HorseRiderNovigrad_Entry();
	}
	
	entry function Spawn_HorseRiderNovigrad_Entry()
	{	
		Spawn_HorseRiderNovigrad_Latent();

		if (!GetACS_HorseRiderFollowTargetNovigrad())
		{
			Spawn_HorseRiderTargetNovigrad_Latent();
		}
	}

	latent function Spawn_HorseRiderNovigrad_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\enemy_rider_novigrad_soldier.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\horse_vehicle_novigrad.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newSpawnPos ) )
		{
			theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 10 , newSpawnPos );
			playerPos = newSpawnPos;
		}

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Neutral);

		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag('NoBestiaryEntry');

		horseTag.Clear();
		
		horseTag.PushBack('enemy_horse');

		ent_2 = theGame.CreateEntity(temp_2, ACSPlayerFixZAxis(playerPos), playerRot,true,false,false,PM_DontPersist,horseTag);

		((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Neutral);

		ent.AddTag( 'ACS_Horse_Rider_Novigrad' );

		ent_2.AddTag( 'ACS_Horse_Rider_Horse_Novigrad' );

		((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Neutral);

		((CActor)ent).CreateAttachment(((CActor)ent_2),,Vector( 0, 0 , 0.01f ));
		
		actor = ((CActor)ent);
		
		enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );	
		
		enemyAnimatedComponent.PlaySlotAnimationAsync( 'horse_walk', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		enemyAnimatedComponent.FreezePoseFadeIn(1.f);

		((CActor)ent).EnableCollisions(false);
		((CActor)ent).EnableCharacterCollisions(false);

		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
	}

	latent function Spawn_HorseRiderTargetNovigrad_Latent()
	{
		var ent           										: CEntity;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\horse_follow_target_novigrad.w2ent"

		, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

		((CActor)ent).EnableCollisions(false);
		((CActor)ent).EnableCharacterCollisions(false);

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Horse_Rider_Target_Novigrad_Entity', true);

		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Horse_Rider_Target_Novigrad_Entity', true);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

		((CActor)ent).SetVisibility( false );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('ACS_Horse_Rider_Follow_Target_Novigrad_Tag');

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_HorseRidersNilfgaard in CACSMonsterSpawner
{
	private var temp, temp_2, temp_3											: CEntityTemplate;
	private var ent, ent_2, ent_3												: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos, newSpawnPos								: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	private var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	private var l_aiTree														: CAIHorseDoNothingAction;			
	private var horseTag 														: array<name>;	
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;
	private var l_aiTreeFollow													: CAIFollowSideBySideAction;	
	var actor							: CActor; 
	var enemyAnimatedComponent 			: CAnimatedComponent;

	var actors		    				: array<CActor>;
	var npc								: CNewNPC;

	event OnEnterState(prevStateName : name)
	{
		Spawn_HorseRiderNilfgaard_Entry();
	}
	
	entry function Spawn_HorseRiderNilfgaard_Entry()
	{	
		Spawn_HorseRiderNilfgaard_Latent();

		if (!GetACS_HorseRiderFollowTargetNilfgaard())
		{
			Spawn_HorseRiderTargetNilfgaardLatent();
		}
	}

	latent function Spawn_HorseRiderNilfgaard_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\enemy_rider_nilfgaard_soldier.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\horse_vehicle_nilfgaard.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newSpawnPos ) )
		{
			theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 10 , newSpawnPos );
			playerPos = newSpawnPos;
		}

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Neutral);

		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag('NoBestiaryEntry');

		horseTag.Clear();
		
		horseTag.PushBack('enemy_horse');

		ent_2 = theGame.CreateEntity(temp_2, ACSPlayerFixZAxis(playerPos), playerRot,true,false,false,PM_DontPersist,horseTag);

		((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Neutral);

		ent.AddTag( 'ACS_Horse_Rider_Nilfgaard' );

		ent_2.AddTag( 'ACS_Horse_Rider_Horse_Nilfgaard' );

		((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Neutral);

		((CActor)ent).CreateAttachment(((CActor)ent_2),,Vector( 0, 0 , 0.01f ));
		
		actor = ((CActor)ent);
		
		enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );	
		
		enemyAnimatedComponent.PlaySlotAnimationAsync( 'horse_walk', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		enemyAnimatedComponent.FreezePoseFadeIn(1.f);

		((CActor)ent).EnableCollisions(false);
		((CActor)ent).EnableCharacterCollisions(false);

		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
	}

	latent function Spawn_HorseRiderTargetNilfgaardLatent()
	{
		var ent           										: CEntity;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\horse_follow_target_nilfgaard.w2ent"

		, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

		((CActor)ent).EnableCollisions(false);
		((CActor)ent).EnableCharacterCollisions(false);

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Horse_Rider_Target_Nilfgaard_Entity', true);

		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Horse_Rider_Target_Nilfgaard_Entity', true);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

		((CActor)ent).SetVisibility( false );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('ACS_Horse_Rider_Follow_Target_Nilfgaard_Tag');

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_MonsterSpawner_HorseRidersRedania in CACSMonsterSpawner
{
	private var temp, temp_2, temp_3											: CEntityTemplate;
	private var ent, ent_2, ent_3												: CEntity;
	private var i, count														: int;
	private var playerPos, spawnPos, newSpawnPos								: Vector;
	private var randAngle, randRange											: float;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var bone_vec, pos, attach_vec										: Vector;
	private var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
	private var steelsword, silversword, scabbard_steel, scabbard_silver		: CDrawableComponent;	
	private var l_aiTree														: CAIHorseDoNothingAction;			
	private var horseTag 														: array<name>;	
	private var movementAdjustor												: CMovementAdjustor;
	private var ticket 															: SMovementAdjustmentRequestTicket;
	private var l_aiTreeFollow													: CAIFollowSideBySideAction;	
	var actor							: CActor; 
	var enemyAnimatedComponent 			: CAnimatedComponent;

	var actors		    				: array<CActor>;
	var npc								: CNewNPC;

	event OnEnterState(prevStateName : name)
	{
		Spawn_HorseRiderRedania_Entry();
	}
	
	entry function Spawn_HorseRiderRedania_Entry()
	{	
		Spawn_HorseRiderRedania_Latent();

		if (!GetACS_HorseRiderFollowTargetRedania())
		{
			Spawn_HorseRiderTargetRedaniaLatent();
		}
	}

	latent function Spawn_HorseRiderRedania_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\enemy_rider_redanian_soldier.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\horse_vehicle_redania.w2ent"
			
		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newSpawnPos ) )
		{
			theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 10 , newSpawnPos );
			playerPos = newSpawnPos;
		}

		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Neutral);

		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.AddTag('NoBestiaryEntry');

		horseTag.Clear();
		
		horseTag.PushBack('enemy_horse');

		ent_2 = theGame.CreateEntity(temp_2, ACSPlayerFixZAxis(playerPos), playerRot,true,false,false,PM_DontPersist,horseTag);

		((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Neutral);

		ent.AddTag( 'ACS_Horse_Rider_Redania' );

		ent_2.AddTag( 'ACS_Horse_Rider_Horse_Redania' );

		((CNewNPC)ent_2).SetAttitude(thePlayer, AIA_Neutral);

		((CActor)ent).CreateAttachment(((CActor)ent_2),,Vector( 0, 0 , 0.01f ));
		
		actor = ((CActor)ent);
		
		enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );	
		
		enemyAnimatedComponent.PlaySlotAnimationAsync( 'horse_walk', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

		enemyAnimatedComponent.FreezePoseFadeIn(1.f);

		((CActor)ent).EnableCollisions(false);
		((CActor)ent).EnableCharacterCollisions(false);

		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );	
	}

	latent function Spawn_HorseRiderTargetRedaniaLatent()
	{
		var ent           										: CEntity;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\enemy_riders\horse_follow_target_redania.w2ent"

		, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

		((CActor)ent).EnableCollisions(false);
		((CActor)ent).EnableCharacterCollisions(false);

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Horse_Rider_Target_Redania_Entity', true);

		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Horse_Rider_Target_Redania_Entity', true);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

		((CActor)ent).SetVisibility( false );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('InstantKillImmune');

		((CActor)ent).AddAbility('ablIgnoreSigns');

		((CActor)ent).AddAbility('DisableFinishers');

		((CActor)ent).AddAbility('MonsterMHBoss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('ACS_Horse_Rider_Follow_Target_Redania_Tag');

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACS_HorseRiderFollowTargetNovigrad() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Horse_Rider_Follow_Target_Novigrad_Tag' );
	return entity;
}

function GetACS_HorseRiderFollowTargetNilfgaard() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Horse_Rider_Follow_Target_Nilfgaard_Tag' );
	return entity;
}

function GetACS_HorseRiderFollowTargetRedania() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Horse_Rider_Follow_Target_Redania_Tag' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

state ACS_MonsterSpawner_ShadesCrusaders in CACSMonsterSpawner
{
	private var temp, sword_trail_temp											: CEntityTemplate;
	private var ent, sword_trail_1												: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var rot, playerRot, adjustedRot										: EulerAngles;
	private var num																: int;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Shades_Crusaders_Entry();
	}
	
	entry function Spawn_Shades_Crusaders_Entry()
	{	
		Spawn_Shades_Crusaders_Latent();
	}

	latent function Spawn_Shades_Crusaders_Latent()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(4,2);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			num = RandRange(10,0);

			switch (num)
			{
				default:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader.w2ent", true);
				break;

				case 0:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader.w2ent", true);
				break;

				case 1:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader2.w2ent", true);
				break;

				case 2:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader3.w2ent", true);
				break;

				case 3:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader4.w2ent", true);
				break;

				case 4:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader5.w2ent", true);
				break;

				case 5:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader12.w2ent", true);
				break;

				case 6:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader8.w2ent", true);
				break;

				case 7:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader9.w2ent", true);
				break;

				case 8:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader10.w2ent", true);
				break;

				case 9:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader11.w2ent", true);
				break;
			}

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Shades_Crusader_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Shades_Crusader_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Shades_Crusader_Buff', true);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			ent.AddTag('NoBestiaryEntry');

			ent.PlayEffect('demonic_possession');

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			ent.AddTag( 'ACS_Shades_Crusader' );

			ent.AddTag( 'ACS_Hostile_To_All' );




			sword_trail_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent" , true );

			sword_trail_1 = (CEntity)theGame.CreateEntity( sword_trail_temp, pos + Vector( 0, 0, -20 ) );

			sword_trail_1.CreateAttachment( ent, 'r_weapon');

			sword_trail_1.AddTag( 'ACS_crusader_sword_trail' );

			sword_trail_1.PlayEffectSingle('special_attack_charged_iris');

			sword_trail_1.PlayEffectSingle('red_runeword_igni_1');

			sword_trail_1.PlayEffectSingle('red_runeword_igni_2');


		}
	}
}

state ACS_MonsterSpawner_ShadesHunters in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var rot, playerRot, adjustedRot										: EulerAngles;
	private var num, num_2														: int;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Shades_Hunters_Entry();
	}
	
	entry function Spawn_Shades_Hunters_Entry()
	{	
		Spawn_Shades_Hunters_Latent();

		Spawn_Shades_BeastsForHunter_Latent();
	}

	latent function Spawn_Shades_Hunters_Latent()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(4,2);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			num = RandRange(7,0);

			switch (num)
			{
				default:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter1.w2ent", true);
				break;

				case 0:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter1.w2ent", true);
				break;

				case 1:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter2.w2ent", true);
				break;

				case 2:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter3.w2ent", true);
				break;

				case 3:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter4.w2ent", true);
				break;

				case 4:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter5.w2ent", true);
				break;

				case 5:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter6.w2ent", true);
				break;

				case 6:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter7.w2ent", true);
				break;
			}

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Neutral);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Shades_Hunter_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Shades_Hunter_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Shades_Hunter_Buff', true);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			ent.AddTag('NoBestiaryEntry');

			//ent.PlayEffect('demonic_possession');

			ent.AddTag( 'ACS_Shades_Hunter' );
		}
	}

	latent function Spawn_Shades_BeastsForHunter_Latent()
	{
		num_2 = RandRange(14,0);

		switch (num_2)
		{
			default:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\wildhunt_minion_lvl1.w2ent"
				
				, true);
			break;

			case 0:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\wildhunt_minion_lvl1.w2ent"
				
				, true);
			break;

			case 1:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"dlc\bob\data\characters\npc_entities\monsters\kikimore.w2ent"
				
				, true);
			break;

			case 2:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\fogling_lvl1.w2ent"
				
				, true);
			break;

			case 3:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\nekker_lvl1.w2ent"
				
				, true);
			break;

			case 4:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\troll_cave_lvl3.w2ent"
				
				, true);
			break;

			case 5:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\vampire_ekima_lvl1.w2ent"
				
				, true);
			break;

			case 6:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\ghoul_lvl1.w2ent"
				
				, true);
			break;

			case 7:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\werewolf_lvl1.w2ent"
				
				, true);
			break;

			case 8:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\hag_grave_lvl1.w2ent"
				
				, true);
			break;

			case 9:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\hag_water_lvl1.w2ent"
				
				, true);
			break;

			case 10:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\endriaga_lvl2__tailed.w2ent"
				
				, true);
			break;

			case 11:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\wyvern_lvl1.w2ent"
				
				, true);
			break;

			case 12:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\forktail_lvl1.w2ent"
				
				, true);
			break;

			case 13:
			temp = (CEntityTemplate)LoadResourceAsync(
				
				"characters\npc_entities\monsters\drowner_lvl1.w2ent"
				
				, true);
			break;
		}

		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(4,2);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddTag( 'ContractTarget' );

			//((CActor)ent).AddAbility('BounceBoltsWildhunt');

			//ent.AddTag('NoBestiaryEntry');

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			//ent.PlayEffect('demonic_possession');

			ent.AddTag( 'ACS_Shades_Beasts' );

			ent.AddTag( 'ACS_Hostile_To_All' );
		}
	}
}

state ACS_MonsterSpawner_ShadesRogues in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var rot, playerRot, adjustedRot										: EulerAngles;
	private var num, num_2														: int;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Shades_Rogue_Entry();
	}
	
	entry function Spawn_Shades_Rogue_Entry()
	{	
		Spawn_Shades_Rogue_Latent();

		Spawn_Shades_EnemiesForRogue_Latent();
	}

	latent function Spawn_Shades_Rogue_Latent()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(12,6);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			num = RandRange(2,0);

			switch (num)
			{
				default:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\rogue\1\enemy_bow.w2ent", true);
				break;

				case 0:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\rogue\1\enemy_bow.w2ent", true);
				break;

				case 1:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\rogue\1\enemy_fallen.w2ent", true);
				break;
			}

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Shades_Rogue_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Shades_Rogue_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Shades_Rogue_Buff', true);

			((CActor)ent).AddTag( 'ContractTarget' );

			ent.AddTag('NoBestiaryEntry');

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			ent.AddTag( 'ACS_Shades_Rogue' );
		}
	}

	latent function Spawn_Shades_EnemiesForRogue_Latent()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(9,5);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
			{
				num_2 = RandRange(5,0);

				switch (num_2)
				{
					default:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\skellige\ske_1h_axe_t1.w2ent"
						
						, true);
					break;

					case 0:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\skellige\ske_1h_axe_t1.w2ent"
						
						, true);
					break;

					case 1:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\skellige\ske_1h_club.w2ent"
						
						, true);
					break;

					case 2:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\skellige\ske_shield_axe_t1.w2ent"
						
						, true);
					break;

					case 3:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\skellige\ske_2h_spear.w2ent"
						
						, true);
					break;

					case 4:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\skellige\ske_bow.w2ent"
						
						, true);
					break;
				}
			}
			else
			{
				num_2 = RandRange(5,0);

				switch (num_2)
				{
					default:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\nml\nml_1h_axe_bandit.w2ent"
						
						, true);
					break;

					case 0:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\nml\nml_1h_axe_bandit.w2ent"
						
						, true);
					break;

					case 1:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\nml\nml_1h_club_bandit.w2ent"
						
						, true);
					break;

					case 2:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\nml\nml_1h_mace_bandit.w2ent"
						
						, true);
					break;

					case 3:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\nml\nml_2h_axe_bandits.w2ent"
						
						, true);
					break;

					case 4:
					temp = (CEntityTemplate)LoadResourceAsync(
						
						"gameplay\templates\characters\presets\nml\nml_bow_bandit.w2ent"
						
						, true);
					break;
				}
			}

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			ent.AddTag( 'ACS_Shades_Rogue_Enemies' );
		}
	}
}

state ACS_MonsterSpawner_ShadesShowdown in CACSMonsterSpawner
{
	private var temp, sword_trail_temp											: CEntityTemplate;
	private var ent, sword_trail_1												: CEntity;
	private var i, count														: int;
	private var pos, spawnPos													: Vector;
	private var randAngle, randRange											: float;
	private var rot, playerRot, adjustedRot										: EulerAngles;
	private var num, num_1, num_2, num_3										: int;

	event OnEnterState(prevStateName : name)
	{
		Spawn_Shades_Showdown_Entry();
	}
	
	entry function Spawn_Shades_Showdown_Entry()
	{	
		num = RandRange(4,0);

		switch (num)
		{
			default:
			Spawn_Shades_Showdown_Latent_1();
			Spawn_Shades_Showdown_Latent_2();
			if (RandF() < 0.25)
			{
				Spawn_Shades_Showdown_Latent_3();
			}
			break;

			case 0:
			Spawn_Shades_Showdown_Latent_1();
			Spawn_Shades_Showdown_Latent_2();
			if (RandF() < 0.25)
			{
				Spawn_Shades_Showdown_Latent_3();
			}
			break;

			case 1:
			Spawn_Shades_Showdown_Latent_1();
			Spawn_Shades_Showdown_Latent_3();
			if (RandF() < 0.25)
			{
				Spawn_Shades_Showdown_Latent_2();
			}
			break;

			case 2:
			Spawn_Shades_Showdown_Latent_2();
			Spawn_Shades_Showdown_Latent_3();
			if (RandF() < 0.25)
			{
				Spawn_Shades_Showdown_Latent_1();
			}
			break;

			case 3:
			Spawn_Shades_Showdown_Latent_1();
			Spawn_Shades_Showdown_Latent_2();
			Spawn_Shades_Showdown_Latent_3();
			break;
		}
	}

	latent function Spawn_Shades_Showdown_Latent_1()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(6,3);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			num_1 = RandRange(7,0);

			switch (num_1)
			{
				default:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter1.w2ent", true);
				break;

				case 0:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter1.w2ent", true);
				break;

				case 1:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter2.w2ent", true);
				break;

				case 2:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter3.w2ent", true);
				break;

				case 3:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter4.w2ent", true);
				break;

				case 4:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter5.w2ent", true);
				break;

				case 5:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter6.w2ent", true);
				break;

				case 6:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_hunter7.w2ent", true);
				break;
			}

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Neutral);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Shades_Hunter_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Shades_Hunter_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Shades_Hunter_Buff', true);

			((CActor)ent).AddTag( 'ContractTarget' );

			ent.AddTag('NoBestiaryEntry');

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			//ent.PlayEffect('demonic_possession');

			ent.AddTag( 'ACS_Shades_Hunter' );
		}
	}

	latent function Spawn_Shades_Showdown_Latent_2()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(6,3);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			num_2 = RandRange(9,0);

			switch (num_2)
			{
				default:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader.w2ent", true);
				break;

				case 0:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader.w2ent", true);
				break;

				case 1:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader2.w2ent", true);
				break;

				case 2:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader3.w2ent", true);
				break;

				case 3:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader4.w2ent", true);
				break;

				case 4:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader5.w2ent", true);
				break;

				case 5:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader12.w2ent", true);
				break;

				case 6:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader8.w2ent", true);
				break;

				case 7:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader9.w2ent", true);
				break;

				case 8:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader10.w2ent", true);
				break;

				case 9:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\1\enemy_crusader11.w2ent", true);
				break;
			}

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Shades_Crusader_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Shades_Crusader_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Shades_Crusader_Buff', true);

			((CActor)ent).AddTag( 'ContractTarget' );

			((CActor)ent).AddAbility('BounceBoltsWildhunt');

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			ent.AddTag('NoBestiaryEntry');

			ent.PlayEffect('demonic_possession');

			ent.AddTag( 'ACS_Shades_Crusader' );

			ent.AddTag( 'ACS_Hostile_To_All' );




			sword_trail_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent" , true );

			sword_trail_1 = (CEntity)theGame.CreateEntity( sword_trail_temp, pos + Vector( 0, 0, -20 ) );

			sword_trail_1.CreateAttachment( ent, 'r_weapon');

			sword_trail_1.AddTag( 'ACS_crusader_sword_trail' );

			sword_trail_1.PlayEffectSingle('special_attack_charged_iris');

			sword_trail_1.PlayEffectSingle('red_runeword_igni_1');

			sword_trail_1.PlayEffectSingle('red_runeword_igni_2');


		}
	}

	latent function Spawn_Shades_Showdown_Latent_3()
	{
		pos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = RandRange(12,6);
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + pos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + pos.Y;
			spawnPos.Z = pos.Z;

			num_3 = RandRange(2,0);

			switch (num_3)
			{
				default:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\rogue\1\enemy_bow.w2ent", true);
				break;

				case 0:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\rogue\1\enemy_bow.w2ent", true);
				break;

				case 1:
				temp = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\shades_enemies\rogue\1\enemy_fallen.w2ent", true);
				break;
			}

			ent = theGame.CreateEntity(temp, ACSPlayerFixZAxis(spawnPos), adjustedRot);

			((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

			((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);

			((CActor)ent).SetAnimationSpeedMultiplier(1);

			((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Shades_Rogue_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Shades_Rogue_Buff', true);

			((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Shades_Rogue_Buff', true);

			((CActor)ent).AddTag( 'ContractTarget' );

			ent.AddTag('NoBestiaryEntry');

			((CActor)ent).AddTag('IsBoss');

			((CActor)ent).AddAbility('Boss');

			ent.AddTag( 'ACS_Shades_Rogue' );
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


state ACS_MonsterSpawner_ShadesDancerWaning in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	private var anchor_temp, blade_temp											: CEntityTemplate;
	private var r_anchor, l_anchor, r_blade1, l_blade1							: CEntity;
	private var bone_vec, attach_vec											: Vector;
	private var bone_rot, attach_rot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_ShadesDancerWaning_Static_Entry();
	}
	
	entry function Spawn_ShadesDancerWaning_Static_Entry()
	{	
		Spawn_ShadesDancerWaning_Static_Latent();
	}

	latent function Spawn_ShadesDancerWaning_Static_Latent()
	{
		GetACS_ShadesDancerWaning_L_Blade().Destroy();

		GetACS_ShadesDancerWaning_L_Anchor().Destroy();

		GetACS_ShadesDancerWaning_R_Blade().Destroy();

		GetACS_ShadesDancerWaning_R_Anchor().Destroy();
		
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\shades_enemies\boss\enemy_dancer_v2.w2ent"

		, true );

		anchor_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.125;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.125);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.PlayEffect('ice_armor');

		//ent.PlayEffect('ice');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Shades_Dancer_Waning' );

		ent.AddTag('ACS_Shades_Evolved');

		ent.AddTag( 'ACS_Hostile_To_All' );


		((CActor)ent).GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() );

		r_anchor.CreateAttachment( ((CActor)ent), 'r_hand'  );

		r_anchor.AddTag('ACS_ShadesDancerWaning_R_Anchor');
		
		((CActor)ent).GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() );

		l_anchor.CreateAttachment( ((CActor)ent), 'l_hand'  );

		l_anchor.AddTag('ACS_ShadesDancerWaning_L_Anchor');


		r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -20 ) );
		l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.05;
		attach_vec.Y = 0;
		attach_vec.Z = -0.005;
		
		l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

		//l_blade1.PlayEffectSingle('red_runeword_igni_1');

		//l_blade1.PlayEffectSingle('red_runeword_igni_2');

		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.05;
		attach_vec.Y = 0;
		attach_vec.Z = -0.005;
		
		r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

		//r_blade1.PlayEffectSingle('red_runeword_igni_1');

		//r_blade1.PlayEffectSingle('red_runeword_igni_2');

		l_blade1.AddTag('ACS_ShadesDancerWaning_L_Blade');

		r_blade1.AddTag('ACS_ShadesDancerWaning_R_Blade');

		GetACSWatcher().AddTimer('ACS_ShadesDancerWaning_BladeEffectDelay', 1, false);
	}
}

function GetACS_ShadesDancerWaning_L_Blade() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_ShadesDancerWaning_L_Blade' );
	return entity;
}

function GetACS_ShadesDancerWaning_R_Blade() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_ShadesDancerWaning_R_Blade' );
	return entity;
}

function GetACS_ShadesDancerWaning_R_Anchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_ShadesDancerWaning_R_Anchor' );
	return entity;
}

function GetACS_ShadesDancerWaning_L_Anchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_ShadesDancerWaning_L_Anchor' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


state ACS_MonsterSpawner_ShadesDancerWaxing in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	private var anchor_temp, blade_temp											: CEntityTemplate;
	private var r_anchor, l_anchor, r_blade1, l_blade1							: CEntity;
	private var bone_vec, attach_vec											: Vector;
	private var bone_rot, attach_rot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_ShadesDancerWaxing_Static_Entry();
	}
	
	entry function Spawn_ShadesDancerWaxing_Static_Entry()
	{	
		Spawn_ShadesDancerWaxing_Static_Latent();
	}

	latent function Spawn_ShadesDancerWaxing_Static_Latent()
	{
		GetACS_ShadesDancerWaxing_L_Blade().Destroy();

		GetACS_ShadesDancerWaxing_L_Anchor().Destroy();

		GetACS_ShadesDancerWaxing_R_Blade().Destroy();

		GetACS_ShadesDancerWaxing_R_Anchor().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\shades_enemies\boss\enemy_dancer_v1.w2ent"

		, true );

		anchor_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\swords\swordclaws_steel.w2ent", true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.125;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Dancer_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.PlayEffect('acs_fire_eff');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Shades_Dancer_Waxing' );

		ent.AddTag('ACS_Shades_Evolved');

		ent.AddTag( 'ACS_Hostile_To_All' );




		((CActor)ent).GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'r_hand' ), bone_vec, bone_rot );
		r_anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() );

		r_anchor.CreateAttachment( ((CActor)ent), 'r_hand'  );

		r_anchor.AddTag('ACS_ShadesDancerWaxing_R_Anchor');
		
		((CActor)ent).GetBoneWorldPositionAndRotationByIndex( ((CActor)ent).GetBoneIndex( 'l_hand' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, ((CActor)ent).GetWorldPosition() );

		l_anchor.CreateAttachment( ((CActor)ent), 'l_hand'  );

		l_anchor.AddTag('ACS_ShadesDancerWaxing_L_Anchor');


		r_blade1 = (CEntity)theGame.CreateEntity( blade_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -20 ) );
		l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, ((CActor)ent).GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.05;
		attach_vec.Y = 0;
		attach_vec.Z = -0.005;
		
		l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );

		//l_blade1.PlayEffectSingle('red_runeword_igni_1');

		//l_blade1.PlayEffectSingle('red_runeword_igni_2');

		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.05;
		attach_vec.Y = 0;
		attach_vec.Z = -0.005;
		
		r_blade1.CreateAttachment( r_anchor, , attach_vec, attach_rot );

		//r_blade1.PlayEffectSingle('red_runeword_igni_1');

		//r_blade1.PlayEffectSingle('red_runeword_igni_2');

		l_blade1.AddTag('ACS_ShadesDancerWaxing_L_Blade');

		r_blade1.AddTag('ACS_ShadesDancerWaxing_R_Blade');

		GetACSWatcher().AddTimer('ACS_ShadesDancerWaxing_BladeEffectDelay', 1, false);
	}
}

function GetACS_ShadesDancerWaxing_L_Blade() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_ShadesDancerWaxing_L_Blade' );
	return entity;
}

function GetACS_ShadesDancerWaxing_R_Blade() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_ShadesDancerWaxing_R_Blade' );
	return entity;
}

function GetACS_ShadesDancerWaxing_R_Anchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_ShadesDancerWaxing_R_Anchor' );
	return entity;
}

function GetACS_ShadesDancerWaxing_L_Anchor() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_ShadesDancerWaxing_L_Anchor' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


state ACS_MonsterSpawner_ShadesKara in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_ShadesKara_Static_Entry();
	}
	
	entry function Spawn_ShadesKara_Static_Entry()
	{	
		Spawn_ShadesKara_Static_Latent();
	}

	latent function Spawn_ShadesKara_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\shades_enemies\boss\kara_v1.w2ent"

		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.125;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Knockdown , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Kara_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_KnockdownTypeApplicator , 'ACS_Kara_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Shades_Kara' );

		ent.AddTag('ACS_Shades_Evolved');

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_ShadesKara_Spawn_Adds
{
	function ACS_ShadesKara_Spawn_Adds_Engage()
	{
		this.PushState('ACS_ShadesKara_Spawn_Adds_Engage');
	}
}

state ACS_ShadesKara_Spawn_Adds_Engage in cACS_ShadesKara_Spawn_Adds
{
	private var actors, victims																		: array<CActor>;
	private var i, count, j 																		: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var spawnPos, playerPos, newPlayerPos													: Vector;
	private var movementAdjustor																	: CMovementAdjustor;
	private var ticket 																				: SMovementAdjustmentRequestTicket;
	private var targetDistance																		: float;
	private var ent_1, ent_2, ent_3, vfxEnt_1, vfxEnt_2												: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var playerRot, adjustedRot																: EulerAngles;
	private var temp, ent_1_temp, ent_2_temp														: CEntityTemplate;

	private var randAngle, randRange																: float;

	private var animatedComponentA																	: CAnimatedComponent;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		ACS_ShadesKara_Spawn_Adds_Entry();
	}
	
	entry function ACS_ShadesKara_Spawn_Adds_Entry()
	{
		ACS_ShadesKara_Spawn_Adds_Latent();
	}
	
	latent function ACS_ShadesKara_Spawn_Adds_Latent()
	{
		actors.Clear();
		
		theGame.GetActorsByTag( 'ACS_Shades_Kara', actors );	

		if( actors.Size() <= 0 )
		{
			return;
		}

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

				if (
				(
				npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.5
				&& npc.IsAlive()
				)
				)			
				{
					if (targetDistance <= 20 * 20)
					{
						if ( !theSound.SoundIsBankLoaded("animals_wolf.bnk") )
						{
							theSound.SoundLoadBank( "animals_wolf.bnk", false );
						}

						if ( !theSound.SoundIsBankLoaded("monster_wild_dog.bnk") )
						{
							theSound.SoundLoadBank( "monster_wild_dog.bnk", false );
						}

						if (!npc.HasTag('ACS_ShadesKara_Has_Summoned_Adds'))
						{
							npc.AddTag('ACS_ShadesKara_Has_Summoned_Adds');





							vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(
							"dlc\bob\data\fx\gameplay\mutation\mutation_7\mutation_7.w2ent"
							, true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

							vfxEnt_1.CreateAttachment( npc, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );

							vfxEnt_1.PlayEffectSingle('sonar_mesh');

							vfxEnt_1.PlayEffectSingle('sonar');

							vfxEnt_1.PlayEffectSingle('fx_sonar');

							vfxEnt_1.DestroyAfter(2);



							vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(
								"dlc\dlc_acs\data\fx\acs_sonar.w2ent"
								, true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

							vfxEnt_2.CreateAttachment( npc, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );


							vfxEnt_2.PlayEffectSingle('sonar_mesh');

							vfxEnt_2.PlayEffectSingle('sonar');

							vfxEnt_2.PlayEffectSingle('fx_sonar');

							vfxEnt_2.DestroyAfter(2);




							movementAdjustor = ((CActor)npc).GetMovingAgentComponent().GetMovementAdjustor();

							ticket = movementAdjustor.GetRequest( 'ACS_ShadesKara_Summon_Rotate');
							movementAdjustor.CancelByName( 'ACS_ShadesKara_Summon_Rotate' );
							movementAdjustor.CancelAll();

							ticket = movementAdjustor.CreateNewRequest( 'ACS_ShadesKara_Summon_Rotate' );
							movementAdjustor.AdjustmentDuration( ticket, 0.5 );
							movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

							movementAdjustor.RotateTowards(ticket, ((CActor)(npc.GetTarget())));

							if ( !npc.IsInInterior() )
							{
								npc.SoundEvent("animals_wolf_howl");

								npc.SoundEvent("monster_wild_dog_howl");

								temp = (CEntityTemplate)LoadResourceAsync( 

								"dlc\dlc_acs\data\entities\monsters\shadow_werewolf.w2ent"
									
								, true );

								playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * -5;

								if( !theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.3, 0.3 , newPlayerPos ) )
								{
									theGame.GetWorld().NavigationFindSafeSpot( playerPos, 0.5f, 10 , newPlayerPos );
									playerPos = newPlayerPos;
								}

								playerRot = thePlayer.GetWorldRotation();

								adjustedRot = EulerAngles(0,0,0);

								adjustedRot.Yaw = playerRot.Yaw;

								ent_1 = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

								((CNewNPC)ent_1).SetAttitude(npc, AIA_Friendly);

								((CNewNPC)ent_1).SetLevel(npc.GetLevel() - 3);

								((CNewNPC)ent_1).SetAttitude(((CActor)(npc.GetTarget())), AIA_Hostile);

								ent_1.AddTag('NoBestiaryEntry');

								ent_1.AddTag('ACS_Shades_Kara_Shadow_Werewolf');
							}
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

function GetACS_ShadesKara() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Shades_Kara' );
	return entity;
}

function GetACS_ShadesKaraShadowWerewolf() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Shades_Kara_Shadow_Werewolf' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


state ACS_MonsterSpawner_ShadesNightmareIncarnate in CACSMonsterSpawner
{
	private var temp															: CEntityTemplate;
	private var ent																: CEntity;
	private var playerPos, spawnPos												: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var playerRot, adjustedRot											: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Spawn_ShadesNightmareIncarnate_Static_Entry();
	}
	
	entry function Spawn_ShadesNightmareIncarnate_Static_Entry()
	{	
		Spawn_ShadesNightmareIncarnate_Static_Latent();
	}

	latent function Spawn_ShadesNightmareIncarnate_Static_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\shades_enemies\boss\nightmareincarnate.w2ent"

		, true );

		playerPos = parent.pos;

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		ent = theGame.CreateEntity( temp, ACSFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.125;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		((CNewNPC)ent).SetAttitude(thePlayer, AIA_Hostile);
		((CActor)ent).SetAnimationSpeedMultiplier(1.25);

		((CActor)ent).SetCanPlayHitAnim(false);

		((CActor)ent).AddBuffImmunity(EET_Poison, 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_PoisonCritical , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Bleeding , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Weaken , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_WeakeningAura , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Confusion , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Hypnotized , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_AxiiGuardMe , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Immobilized , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Paralyzed , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Blindness , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Choking , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Swarm , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddBuffImmunity(EET_Burning , 'ACS_Nightmare_Incarnate_Buff', true);

		((CActor)ent).AddTag( 'ContractTarget' );

		((CActor)ent).AddTag('IsBoss');

		((CActor)ent).AddAbility('Boss');

		((CActor)ent).AddAbility('BounceBoltsWildhunt');

		ent.PlayEffect('igni_reaction_djinn');

		ent.PlayEffect('acs_armor_effect_1');

		ent.PlayEffect('acs_armor_effect_2');

		ent.AddTag('NoBestiaryEntry');

		ent.AddTag( 'ACS_Shades_Nightmare_Incarnate' );

		ent.AddTag('ACS_Shades_Evolved');

		ent.AddTag( 'ACS_Hostile_To_All' );
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

state ACS_Monster_Static_Spawner in W3ACSWatcher
{
	event OnEnterState(prevStateName : name)
	{
		Monster_Static_Spawner_Entry();
	}
	
	entry function Monster_Static_Spawner_Entry()
	{	
		if (thePlayer.IsCiri())
		{
			return;
		}

		ForestGod_Static_Spawn_Latent();

		IceTitan_Static_Spawn_Latent();

		ChaosAltar_Static_Spawn_Latent();

		KnightmareEternum_Static_Spawn_Latent();

		Loviatar_Static_Spawn_Latent();

		FireWyrm_Static_Spawn_Latent();

		RatMage_Static_Spawn_Latent();

		Mages_Static_Spawn_Latent();

		CloakedVampiress_Static_Spawn_Latent();

		Draugir_Static_Spawn_Latent();

		Draug_Static_Spawn_Latent();

		NecrofiendNest_Static_Spawn_Latent();

		HarpyQueenNest_Static_Spawn_Latent();

		Berserkers_Static_Spawn_Latent();

		CatAssassin_Static_Spawn_Latent();

		NamelessDemon_Static_Spawn_Latent();

		Garmr_Static_Spawn_Latent();

		FataMorgana_Static_Spawn_Latent();

		XenoTyrantEgg_Static_Spawn_Latent();

		CultOfMelusine_Static_Spawn_Latent();

		Rioghan_Static_Spawn_Latent();

		Svalblod_Static_Spawn_Latent();

		Duskwraith_Static_Spawn_Latent();

		OmnesMoriendus_Static_Spawn_Latent();

		OpinicusMatriarch_Static_Spawn_Latent();

		Incubus_Static_Spawn_Latent();

		Mula_Static_Spawn_Latent();

		BloodHym_Static_Spawn_Latent();
		
		Orianna_Static_Spawn_Latent();

		HeartOfDarkness_Static_Spawn_Latent();

		Bumbakvetch_Static_Spawn_Latent();

		IceBoar_Static_Spawn_Latent();

		NimeanPanther_Static_Spawn_Latent();

		ShadowPixies_Static_Spawn_Latent();

		DemonicConstruct_Static_Spawn_Latent();

		Viy_Static_Spawn_Latent();

		Phooca_Static_Spawn_Latent();
		
		Plumard_Static_Spawn_Latent();

		The_Beast_Static_Spawn_Latent();

		GiantRockTroll_Static_Spawn_Latent();

		GiantIceTroll_Static_Spawn_Latent();

		GiantMagmaTroll_Static_Spawn_Latent();

		GiantRockElemental_Static_Spawn_Latent();

		GiantIceElemental_Static_Spawn_Latent();

		GiantFireElemental_Static_Spawn_Latent();

		DarkKnight_Static_Spawn_Latent();

		DarkKnightCalidus_Static_Spawn_Latent();

		Voref_Static_Spawn_Latent();

		Maerolorn_Static_Spawn_Latent();

		Ifrit_Static_Spawn_Latent();

		Carduin_Static_Spawn_Latent();

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		Horse_Riders_Novigrad_Static_Spawn_Latent();

		Horse_Riders_Nilfgaard_Static_Spawn_Latent();

		Horse_Riders_Redania_Static_Spawn_Latent();

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		Shades_Static_Spawns();
	}

	function LoadTemp() : CEntityTemplate
	{
		var temp	: CEntityTemplate;

		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\other\acs_monster_spawner.w2ent"
			
		, true );

		return temp;
	}

	latent function ForestGod_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Forest_God_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(-193.561172, -351.898865, 54.047535, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(2222.130859, 65.340538, 3.541907, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w")
		{
			locationArray.PushBack(Vector(-342.549713, -11.509377, 201.521057, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(480.838440,-1857.715454, 62.028912, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\island_of_mist\island_of_mist.w2w")
		{
			locationArray.PushBack(Vector(-13.837394, -240.803009, 12.674740, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\the_spiral\spiral.w2w")
		{
			locationArray.PushBack(Vector(-686.634521, -2314.287598, 83.935310, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ForestGod' );
		}
	}

	latent function IceTitan_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Ice_Titans_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(-316.550293, -52.626392, 0.580286, 1));
			locationArray.PushBack(Vector(-2565.660889, -1334.807983, 8.729300, 1));
			locationArray.PushBack(Vector(-2411.800537, -733.482727, 0.528175, 1));
			locationArray.PushBack(Vector(-217.916077, -1965.651978, 0.149090, 1));
			locationArray.PushBack(Vector(2325.307129, 630.480408, 1.681702, 1));
			locationArray.PushBack(Vector(1495.861328, 1156.037598, 0.594969, 1));
			locationArray.PushBack(Vector(335.897614, 1542.949951, 2.687820, 1));
			locationArray.PushBack(Vector(-1032.823975, 2006.107666, 0.313784, 1));
			locationArray.PushBack(Vector(-377.889740, 2108.553955, 0.941095, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_IceTitan' );
		}
	}

	latent function ChaosAltar_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Fire_Bear_Altar_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(1107.765381, -253.113007, 0.957805, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(-203.508453, 80.339691, 10.792603, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(-201.472031, 186.004318, 5.699091, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ChaosAltar' );
		}
	}

	latent function KnightmareEternum_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Knightmare_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(269.988220, -2141.231934, 63.465191, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_KnightmareEternum' );
		}
	}

	latent function Loviatar_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_SheWhoKnows_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(1712.061768, -472.764587, 0.223357, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Loviatar' );
		}
	}

	latent function FireWyrm_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_BigLizard_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(-597.852112, -669.305786, 1.309426, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(627.695984, -863.526184, 7.658407, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(149.465164, 67.219673, -0.071147, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_FireWyrm' );
		}
	}

	latent function RatMage_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_RatMage_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(-192.292648, -638.07611, 3.449075, 1));
		}
		
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_RatMage' );
		}
	}

	latent function Mages_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Mages_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(-33.535828, 368.284454, 15.516759, 1));
			locationArray.PushBack(Vector(-4.271485, 723.641541, 12.635901, 1));
			locationArray.PushBack(Vector(-640.648071, 381.257263, 0.528113, 1));
			locationArray.PushBack(Vector(-752.968201, 182.820084, 2.477805, 1));
			locationArray.PushBack(Vector(-737.226868, -569.517212, 0.451547, 1));
			locationArray.PushBack(Vector(-169.419769, -1120.828491, 9.378743, 1));
			locationArray.PushBack(Vector(-463.316956, -895.156433, 3.258704, 1));
			locationArray.PushBack(Vector(-255.035706, 120.645454, 6.724324, 1));
			locationArray.PushBack(Vector(-460.418091, 148.707809, 3.231544, 1));
			locationArray.PushBack(Vector(-665.973572, -125.281822, 9.988349, 1));
			locationArray.PushBack(Vector(-582.600159, -347.738068, 6.804880, 1));
			locationArray.PushBack(Vector(-620.631470, -610.329773, 14.780170, 1));
			locationArray.PushBack(Vector(731.618530, 732.352722, 7.271194, 1));
			locationArray.PushBack(Vector(741.291382, 623.972839, 26.438852, 1));
			locationArray.PushBack(Vector(812.667542, 542.385559, 19.872581, 1));
			locationArray.PushBack(Vector(520.018860, 450.320496, 12.395922, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Mages' );
		}
	}

	latent function CloakedVampiress_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_CloakedVamp_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(383.835297, -786.881592, 25.523346, 1));
			locationArray.PushBack(Vector(1.683741, -745.764832, 3.888556, 1));
			locationArray.PushBack(Vector(-463.699371, -612.664246, 24.718271, 1));
			locationArray.PushBack(Vector(-1170.926758, -905.084045, 114.828140, 1));
			locationArray.PushBack(Vector(-503.869019, -1256.736938, 84.032448, 1));
			locationArray.PushBack(Vector(-598.496948, -1305.905640, 100.997940, 1));
			locationArray.PushBack(Vector(-900.160461, -1051.603638, 107.347839, 1));
			locationArray.PushBack(Vector(-95.625397, -45.747398, 21.383781, 1));
			locationArray.PushBack(Vector(-601.451294, -1381.649292, 84.708740, 1));
			locationArray.PushBack(Vector(-431.481750, -1513.786865, 92.610535, 1));
			locationArray.PushBack(Vector(-414.924622, -1621.056641, 83.527710, 1));
			locationArray.PushBack(Vector(-374.093903, -1932.673584, 68.965660, 1));
			locationArray.PushBack(Vector(3.154538, -1763.351929, 36.846001, 1));
			locationArray.PushBack(Vector(307.538818, -2030.597290, 50.896366, 1));
			locationArray.PushBack(Vector(-226.599213, -1241.298096, 3.180026, 1));
			locationArray.PushBack(Vector(-451.251984, -1106.072998, 67.235977, 1));
			locationArray.PushBack(Vector(-388.597839, -1220.337402, 46.206013, 1));
			locationArray.PushBack(Vector(-553.122498, -1228.427246, 90.973755, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_CloakedVampiress' );
		}
	}

	latent function Draugir_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_DraugirEncounters_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(1864.458374,-689.706726,0.015041,1));
			locationArray.PushBack(Vector(1302.472168,1493.241333,-0.220483,1));
			locationArray.PushBack(Vector(312.184479,891.360840,-0.025470,1));
			locationArray.PushBack(Vector(363.551514, 978.802185, 1.373179, 1));
			locationArray.PushBack(Vector(613.871643,884.598389,1.036278,1));
			locationArray.PushBack(Vector(569.490195,978.070190,-0.108501,1));
			locationArray.PushBack(Vector(405.802002,1068.651611,0.608021,1));
			locationArray.PushBack(Vector(521.863770,1081.006836,1.518828,1));
			locationArray.PushBack(Vector(381.410614,1027.466553,-0.259066,1));
			locationArray.PushBack(Vector(1461.869141, 1121.341797, 0.007444, 1));
			locationArray.PushBack(Vector(917.797424, 915.553467, 11.310884, 1));
			locationArray.PushBack(Vector(899.050049, 993.041687, 0.236208, 1));
			locationArray.PushBack(Vector(814.379395, 759.632629, 16.101336, 1));
			locationArray.PushBack(Vector(1567.507568, 1266.352539, 0.209946, 1));
			locationArray.PushBack(Vector(1507.250366, 1212.312256, -0.029652, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Draugir' );
		}
	}

	latent function Draug_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Draug_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(1864.458374,-689.706726,0.015041,1));
			locationArray.PushBack(Vector(1302.472168,1493.241333,-0.220483,1));
			locationArray.PushBack(Vector(312.184479,891.360840,-0.025470,1));
			locationArray.PushBack(Vector(363.551514,978.802185,1.373179,1));
			locationArray.PushBack(Vector(613.871643,884.598389,1.036278,1));
			locationArray.PushBack(Vector(569.490195,978.070190,-0.108501,1));
			locationArray.PushBack(Vector(405.802002,1068.651611,0.608021,1));
			locationArray.PushBack(Vector(521.863770,1081.006836,1.518828,1));
			locationArray.PushBack(Vector(381.410614,1027.466553,-0.259066,1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		ent = theGame.CreateEntity(LoadTemp(), locationArray[RandRange(locationArray.Size())]);	

		ent.AddTag( 'ACS_MonsterSpawner_Draug' );
	}

	latent function NecrofiendNest_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Necrofiend_Nest_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(-34.453140,-729.554626, 0.009129, 1));
			locationArray.PushBack(Vector(-162.942245, -257.508209, 7.231867, 1));
			locationArray.PushBack(Vector(-255.236084, 194.111725, 4.340678, 1));
			locationArray.PushBack(Vector(-16.400957, 214.687317, 7.781210, 1));
			locationArray.PushBack(Vector(-767.976257, -283.169495, 9.743191, 1));
			locationArray.PushBack(Vector(-674.891785, -522.950378, 12.143078, 1));
			locationArray.PushBack(Vector(-5.568320, -1099.184814, 16.359182, 1));
			locationArray.PushBack(Vector(189.790710, 867.004761, 7.784650, 1));
			locationArray.PushBack(Vector(90.158119, 1623.641235, 2.586885, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_NecrofiendNest' );
		}
	}

	latent function HarpyQueenNest_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_HarpyQueen_Nest_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(487.541107, 1314.663330, 19.169302, 1));
			locationArray.PushBack(Vector(716.671936, 1170.829834, 9.838730, 1));
			locationArray.PushBack(Vector(217.745026, 807.506226, 4.789504, 1));
			locationArray.PushBack(Vector(86.657265, 729.971008, 12.658746, 1));
			locationArray.PushBack(Vector(61.971802, 936.288635, 11.570417, 1));
			locationArray.PushBack(Vector(379.489044, 1951.652222, 0.596632, 1));
			locationArray.PushBack(Vector(140.006851, 2352.843018, 0.767854, 1));
			locationArray.PushBack(Vector(463.728821, 2487.617188, 0.164658, 1));
			locationArray.PushBack(Vector(923.273926, 2256.131592, 4.099892, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_HarpyQueenNest' );
		}
	}

	latent function Berserkers_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Berserkers_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(159.226700, -41.232437, 22.403845, 1));
			locationArray.PushBack(Vector(-224.057724, -504.910767, 66.554497, 1));
			locationArray.PushBack(Vector(-206.366287, -582.547180, 99.741768, 1));
			locationArray.PushBack(Vector(-344.830292, -961.966187, 11.376847, 1));
			locationArray.PushBack(Vector(-318.583130, -288.942657, 37.038479, 1));
			locationArray.PushBack(Vector(445.866913, -482.297333, 15.613439, 1));
			locationArray.PushBack(Vector(111.097275, -689.275269, 89.946808, 1));
			locationArray.PushBack(Vector(-436.023285, -945.449341, 2.724056, 1));
			locationArray.PushBack(Vector(-325.336884, -985.246399, 9.480059, 1));
			locationArray.PushBack(Vector(-213.434402, -1180.457642, 2.318056, 1));
			locationArray.PushBack(Vector(185.917999, -1317.859009, 4.039735, 1));
			locationArray.PushBack(Vector(543.599548, -1451.897705, 3.470709, 1));

		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Berserkers' );
		}
	}

	latent function CatAssassin_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_LynxWitchers_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(495.437793, 1915.586548, 3.823041, 1));
			locationArray.PushBack(Vector(726.837158, 1957.476196, 19.479492, 1));
			locationArray.PushBack(Vector(1795.391968, 890.932068, 4.168532, 1));
			locationArray.PushBack(Vector(776.202454, 1254.185791, 7.839949, 1));
			locationArray.PushBack(Vector(422.340088, 1120.030151, 0.761418, 1));
			locationArray.PushBack(Vector(398.718903, 718.387451, 10.681791, 1));
			locationArray.PushBack(Vector(64.081848, 28.880114, 15.549473, 1));
		}

		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_CatAssassin' );
		}
	}

	latent function NamelessDemon_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_FireGargoyle_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(291.042725, -385.664246, 16.149393, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(28.673340, -1243.264526, 12.543667, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(862.849976, -940.765381, 0.683770, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_NamelessDemon' );
		}
	}

	latent function Garmr_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Fluffy_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(-129.572678, -511.812714, 62.366535, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(464.682465, -81.948090, 15.784894, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(26.269510, 394.783081, 21.503819, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w"
		)
		{
			locationArray.PushBack(Vector(-96.208778, -511.844208, 129.133301, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\prolog_village\prolog_village.w2w"
		)
		{
			locationArray.PushBack(Vector(-226.370712, 238.623001, 2.252295, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Garmr' );
		}
	}

	latent function FataMorgana_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_FogAssassin_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(1640.047485, -1924.358154, 8.649158, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(637.185303, -462.441040, 2.985913, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(759.760742, -1730.699463, 1.774744, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_FataMorgana' );
		}
	}

	latent function XenoTyrantEgg_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_XenoTyrantEgg_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w")
		{
			locationArray.PushBack(Vector(190.299957, 190.045547, 22.075409, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(1752.351074, 518.808289, 3.625612, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w")
		{
			locationArray.PushBack(Vector(-91.659164, 793.199951, 48.489071, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			locationArray.PushBack(Vector(387.123108, -709.767944, 10.444670, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\wyzima_castle\wyzima_castle.w2w")
		{
			locationArray.PushBack(Vector(146.306946, -64.951698, 37.446629, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\island_of_mist\island_of_mist.w2w")
		{
			locationArray.PushBack(Vector(52.411758, 257.636658, 7.797175, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\the_spiral\spiral.w2w")
		{
			locationArray.PushBack(Vector(-710.308411, -2296.816406, 85.194946, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\prolog_village\prolog_village.w2w")
		{
			locationArray.PushBack(Vector(-252.197891, -93.352190, 6.237315, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\prolog_village_winter\prolog_village.w2w")
		{
			locationArray.PushBack(Vector(-334.244812, -201.047256, 7.126178, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_XenoTyrantEgg' );
		}
	}

	latent function CultOfMelusine_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Cultists_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(-389.277191, 899.686523, 4.009470, 1));
			locationArray.PushBack(Vector(-1889.174927, 1141.632202, 33.613052, 1));
			locationArray.PushBack(Vector(-2107.615723, -802.813721, 30.930084, 1));
			locationArray.PushBack(Vector(1480.860352, -1900.234863, 6.942338, 1));
			locationArray.PushBack(Vector(2703.981934, 384.496979, 0.653838, 1));
			locationArray.PushBack(Vector(1120.144775, -260.285004, 3.353843, 1));
			locationArray.PushBack(Vector(-1537.084839, 1231.020874, 1.866044, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_CultOfMelusine' );
		}
	}

	latent function Rioghan_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_PirateZombie_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(-1971.268555, 1428.374878, 4.172275, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Rioghan' );
		}
	}

	latent function Svalblod_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Svalblod_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(-263.874298, -626.085205, 130.848526, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Svalblod' );
		}
	}

	latent function Duskwraith_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Duskwraith_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(346.484314,-1167.110107,0.028669,1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(63.170185,-1283.644897,1.035181,1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(248.109192,-67.130280,0.359924,1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Duskwraith' );
		}
	}

	latent function OmnesMoriendus_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_MegaWraith_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(548.112183,1156.229736,-0.092723,1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(-480.718048,-404.972412,62.880489,1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(816.320862,39.775669,2.120495,1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w"))
		{
			locationArray.PushBack(Vector(-139.526535,-279.187317,116.491623,1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_OmnesMoriendus' );
		}
	}

	latent function OpinicusMatriarch_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_FireGryphon_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1055.846558,-613.535156,0.725005,1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_OpinicusMatriarch' );
		}
	}

	latent function Incubus_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Incubus_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1459.147583, -782.431091, 23.573896, 1));
			locationArray.PushBack(Vector(-598.496948, -1305.905640, 100.997940, 1));
			locationArray.PushBack(Vector(1222.221924, -624.690186, 0.060957, 1));
			locationArray.PushBack(Vector(-331.515900, -189.137604, 7.542162, 1));
			locationArray.PushBack(Vector(35.626671, -269.306458, 0.220381, 1));
			locationArray.PushBack(Vector(197.706436, -1351.475952, -0.065988, 1));
			locationArray.PushBack(Vector(167.66636, -1259.566650, -0.049578, 1));
			locationArray.PushBack(Vector(-119.368332, -200.208389, 9.711581, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(877.475708, -496.414917, 77.988220, 1));
			locationArray.PushBack(Vector(215.900528, -1033.119995, 0.603014, 1));
			locationArray.PushBack(Vector(14.436355, -872.204590, -0.134461, 1));
			locationArray.PushBack(Vector(803.263550, -1119.614258, 2.100239, 1));
			locationArray.PushBack(Vector(570.753662, -204.012292, 10.932338, 1));
			locationArray.PushBack(Vector(202.613632, 401.661346, 1.135371, 1));
			locationArray.PushBack(Vector(167.66636, -1259.566650, -0.049578, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Incubus' );
		}
	}

	latent function Mula_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Mula_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(2097.906250,-877.609863,2.176330,1));
			locationArray.PushBack(Vector(-119.368332, -200.208389, 9.711581, 1));
			locationArray.PushBack(Vector(1412.445923, -516.720642, -0.376114, 1));
			locationArray.PushBack(Vector(1812.816895, -151.270233, 35.216846, 1));
			locationArray.PushBack(Vector(1961.057617, 183.068954, -0.167544, 1));
			locationArray.PushBack(Vector(1539.826416, -116.563423, 30.740000, 1));
			locationArray.PushBack(Vector(1455.942871, -608.051086, -0.023946, 1));
			locationArray.PushBack(Vector(772.609863, 817.236694, 8.522795, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-183.340759,-2079.917969,70.201691,1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Mula' );
		}
	}

	latent function BloodHym_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_BloodHym_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(1.597600, -285.186035, 0.648419, 1));
			locationArray.PushBack(Vector(1249.765137, -195.124130, 51.976997, 1));
			locationArray.PushBack(Vector(1878.900757, 1910.021240, 54.799717, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(387.108490, 67.570854, 25.444578, 1));
			locationArray.PushBack(Vector(-106.453294, 396.848755, 35.675682, 1));
			locationArray.PushBack(Vector(735.360474, -878.761963, 10.785432, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w"))
		{
			locationArray.PushBack(Vector(-16.957508, -343.451813, 124.298019, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(276.552582, 252.264786, 3.044791, 1));
			locationArray.PushBack(Vector(-441.005096, 446.996918, -0.155340, 1));
			locationArray.PushBack(Vector(-483.528076, 342.722382, 1.073746, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_BloodHym' );
		}
	}

	latent function Orianna_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (FactsQuerySum("ACS_Orianna_Killed") > 0
		|| FactsQuerySum("q704_orianas_part_done") <= 0 
		)
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-323.534851, -356.957886, 1.192906, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Orianna' );
		}
	}

	latent function HeartOfDarkness_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Heart_Of_Darkness_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-2863.197510, -3317.121094, 1504.084717, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_HeartOfDarkness' );
		}
	}

	latent function Bumbakvetch_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Bumbakvetch_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1883.878174, 1838.144287, 54.547291, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(585.648071, -361.425720, 33.400547, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(884.327637, -1164.023926, 0.135543, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Bumbakvetch' );
		}
	}

	latent function IceBoar_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Frost_Boar_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(-43.513680, 544.209656, 1.564306, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(532.878113, 211.200607, 44.074902, 1));
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\the_spiral\spiral.w2w")
		{
			locationArray.PushBack(Vector(1069.765015, -3259.119385, 303.520691, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_IceBoar' );
		}
	}

	latent function NimeanPanther_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Nimean_Panther_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(-122.590904, 638.652466, 14.217310, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(586.202820, -392.148804, 32.500904, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(541.468201, -1371.525391, 1.449926, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_NimeanPanther' );
		}
	}

	latent function ShadowPixies_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Shadow_Pixies_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(271.135742, -147.438171, 7.280310, 1));
			locationArray.PushBack(Vector(463.799438, -361.274048, 0.296418, 1));
			locationArray.PushBack(Vector(599.206787, -397.121460, 10.285901, 1));
			locationArray.PushBack(Vector(371.895050, -510.124054, 6.847486, 1));
			locationArray.PushBack(Vector(177.546051, -61.754978, 9.655753, 1));
			locationArray.PushBack(Vector(299.481964, -303.651520, 11.594185, 1));
			locationArray.PushBack(Vector(-28.425116, -205.097290, 7.271303, 1));
			locationArray.PushBack(Vector(-126.091499, 3.244767, 6.862248, 1));
			locationArray.PushBack(Vector(-78.343086, 211.889999, 7.628993, 1));
			locationArray.PushBack(Vector(-217.629944, 392.221222, 16.061609, 1));
			locationArray.PushBack(Vector(12.658245, 627.254822, 14.014564, 1));
			locationArray.PushBack(Vector(188.457001, 509.025726, 17.939335, 1));
			locationArray.PushBack(Vector(298.970306, 348.487823, 2.253508, 1));
			locationArray.PushBack(Vector(185.634033, 308.978424, 11.315175, 1));
			locationArray.PushBack(Vector(-367.346954, -27.573330, 5.005935, 1));
			locationArray.PushBack(Vector(-547.080750, -27.352812, 7.717431, 1));
			locationArray.PushBack(Vector(-298.242371, 109.682884, 9.805280, 1));
			locationArray.PushBack(Vector(-77.422363, 1.390148, 10.724735, 1));
			locationArray.PushBack(Vector(126.216682, -150.340363, 6.183069, 1));
			locationArray.PushBack(Vector(-103.774078, -424.728729, 17.689028, 1));
			locationArray.PushBack(Vector(148.437027, -505.091248, 1.046939, 1));
			locationArray.PushBack(Vector(508.310608, -671.548889, 1.998710, 1));
			locationArray.PushBack(Vector(532.568420, -515.193542, 3.633354, 1));
			locationArray.PushBack(Vector(394.641602, -273.185089, 2.823583, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	
			
			ent.AddTag( 'ACS_MonsterSpawner_ShadowPixies' );
		}
	}

	latent function Maerolorn_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Maerolorn_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(201.009018, -89.774681, 6.168664, 1));
			locationArray.PushBack(Vector(596.421265, 87.885803, 14.969600, 1));
			locationArray.PushBack(Vector(1049.233643, 428.017303, 5.511171, 1));
			locationArray.PushBack(Vector(1265.125977, 206.285004, 3.577551, 1));
			locationArray.PushBack(Vector(1506.852295, 215.139084, 3.939094, 1));
			locationArray.PushBack(Vector(1754.959351, 262.906799, 11.737625, 1));
			locationArray.PushBack(Vector(1892.983521, 310.453888, 0.146344, 1));
			locationArray.PushBack(Vector(1964.691650, 810.300781, 3.302141, 1));
			locationArray.PushBack(Vector(2082.302246, 909.669250, 0.585171, 1));
			locationArray.PushBack(Vector(1530.940552, 1536.965210, 3.791963, 1));
			locationArray.PushBack(Vector(1255.081909, 2480.425537, 7.296978, 1));
			locationArray.PushBack(Vector(484.645172, 2595.197266, 2.990394, 1));
			locationArray.PushBack(Vector(268.605865, 1671.472168, 1.294217, 1));
			locationArray.PushBack(Vector(410.308380, 1578.405640, 7.772007, 1));
			locationArray.PushBack(Vector(362.397278, 2531.332764, 0.631143, 1));
			locationArray.PushBack(Vector(1006.987488, 2125.078613, 8.094496, 1));
			locationArray.PushBack(Vector(1260.580811, 1841.733032, 1.311177, 1));
			locationArray.PushBack(Vector(1058.876343, 2055.265137, 4.961911, 1));
			locationArray.PushBack(Vector(842.074341, 2050.669922, 2.215760, 1));
			locationArray.PushBack(Vector(1270.554321, 2216.509277, 2.900468, 1));
			locationArray.PushBack(Vector(1244.779663, 2291.313232, 5.070327, 1));
			locationArray.PushBack(Vector(704.376648, 2545.877686, 27.123940, 1));
			locationArray.PushBack(Vector(1936.959473, 2041.495605, 64.342918, 1));
			locationArray.PushBack(Vector(2443.289551, 2007.770874, 16.714565, 1));
			locationArray.PushBack(Vector(1458.906372, 2035.430054, 3.149824, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(-250.648987, -225.613937, 50.329533, 1));
			locationArray.PushBack(Vector(-281.433411, -315.749115, 48.481895, 1));
			locationArray.PushBack(Vector(-478.772614, -325.816406, 40.550762, 1));
			locationArray.PushBack(Vector(-557.016968, -239.274811, 29.269978, 1));
			locationArray.PushBack(Vector(-662.958740, -368.075073, 36.580730, 1));
			locationArray.PushBack(Vector(-629.118713, -454.444824, 24.667442, 1));
			locationArray.PushBack(Vector(-362.263702, -773.948547, 48.340256, 1));
			locationArray.PushBack(Vector(343.466217, -1034.842041, 7.201228, 1));
			locationArray.PushBack(Vector(-393.795563, -218.860306, 44.933662, 1));
			locationArray.PushBack(Vector(-519.567017, -116.759766, 14.104027, 1));
			locationArray.PushBack(Vector(-356.946930, -138.365829, 43.513229, 1));

		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-65.393364, 229.019211, 9.804246, 1));
			locationArray.PushBack(Vector(129.678940, 321.257416, 8.369221, 1));
			locationArray.PushBack(Vector(-221.635056, 802.966064, 9.048968, 1));
			locationArray.PushBack(Vector(-347.041260, 874.186096, 5.744734, 1));
			locationArray.PushBack(Vector(-289.218597, 1008.576599, 18.032904, 1));
			locationArray.PushBack(Vector(82.924866, -675.782593, 16.568867, 1));
			locationArray.PushBack(Vector(437.431305, -675.855835, 13.835930, 1));
			locationArray.PushBack(Vector(1002.411743, -647.667297, 57.719486, 1));
			locationArray.PushBack(Vector(1200.223267, -730.116089, 59.851807, 1));
			locationArray.PushBack(Vector(1293.875244, -579.901123, 47.885342, 1));
			locationArray.PushBack(Vector(1549.631348, -588.727051, 27.637899, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	
			
			ent.AddTag( 'ACS_MonsterSpawner_Maerolorn' );
		}
	}

	latent function DemonicConstruct_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Demonic_Construct_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(89.057091, 593.340576, 36.645748, 1));
			locationArray.PushBack(Vector(625.502747, -644.265015, 3.202374, 1));
			locationArray.PushBack(Vector(921.095154, 377.607300, 20.903379, 1));
			locationArray.PushBack(Vector(1857.800903, -116.292358, 47.805347, 1));
			locationArray.PushBack(Vector(1850.774658, 566.121948, 3.189325, 1));
			locationArray.PushBack(Vector(2000.905762, 1134.007080, 7.018495, 1));
			locationArray.PushBack(Vector(1125.795166, 1756.960449, -0.321325, 1));
			locationArray.PushBack(Vector(609.381897, 2441.609863, 14.510590, 1));
			locationArray.PushBack(Vector(1180.151978, 928.981018, 1.267978, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(786.033875, -346.937103, 33.184544, 1));
			locationArray.PushBack(Vector(925.891541, -249.306229, 40.366764, 1));
			locationArray.PushBack(Vector(1085.731689, -276.682037, 39.590401, 1));
			locationArray.PushBack(Vector(1131.786255, -483.291107, 61.852448, 1));
			locationArray.PushBack(Vector(786.369751, -151.175552, 8.624273, 1));
			locationArray.PushBack(Vector(153.237411, -689.852112, 3.570430, 1));
			locationArray.PushBack(Vector(390.102875, -1059.416504, 15.472711, 1));
			locationArray.PushBack(Vector(233.615845, -1561.855835, 28.989651, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_DemonicConstruct' );
		}
	}

	latent function Viy_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Viy_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1512.937134, 2767.984375, 22.905933, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-434.079163, 137.873047, 0.264920, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ViyOfMaribor' );
		}
	}

	latent function Phooca_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Phooca_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(-309.806213, -12.130629, 6.355621, 1));
			locationArray.PushBack(Vector(-217.993256, -201.438065, -0.007215, 1));
			locationArray.PushBack(Vector(-310.222260, -556.260315, 12.819904, 1));
			locationArray.PushBack(Vector(-326.428589, -994.577209, 9.115502, 1));
			locationArray.PushBack(Vector(-58.793747, -1088.911255, 15.187658, 1));
			locationArray.PushBack(Vector(-221.109116, -1334.758179, 2.988543, 1));
			locationArray.PushBack(Vector(-413.678253, -965.686707, 18.881584, 1));
			locationArray.PushBack(Vector(-478.313019, -576.372437, 0.989693, 1));
			locationArray.PushBack(Vector(-471.687408, -304.360718, 6.090889, 1));
			locationArray.PushBack(Vector(-466.381348, -70.429337, 13.885661, 1));
			locationArray.PushBack(Vector(-108.438202, -364.045288, 21.700657, 1));
			locationArray.PushBack(Vector(403.627533, 21.946386, 14.263351, 1));
			locationArray.PushBack(Vector(527.674377, 437.758820, 11.075422, 1));
			locationArray.PushBack(Vector(352.311310, 621.796631, 11.316551, 1));
			locationArray.PushBack(Vector(425.906219, 778.331238, 0.498355, 1));
			locationArray.PushBack(Vector(622.418762, 767.745117, 9.982017, 1));
			locationArray.PushBack(Vector(1083.745117, 997.666992, 0.237540, 1));
			locationArray.PushBack(Vector(1296.631714, 1228.667480, 3.763229, 1));
			locationArray.PushBack(Vector(1634.657837, 1336.022217, 4.576551, 1));
			locationArray.PushBack(Vector(1463.239258, 1426.611450, 0.406934, 1));
			locationArray.PushBack(Vector(1244.548584, 905.599121, 8.224167, 1));
			locationArray.PushBack(Vector(1344.185547, 962.923645, 4.485644, 1));
			locationArray.PushBack(Vector(1303.751099, 1004.022400, 6.708428, 1));
			locationArray.PushBack(Vector(1301.843140, 1178.571045, -0.127025, 1));
			locationArray.PushBack(Vector(2337.958252, 1433.572144, 56.266186, 1));
			locationArray.PushBack(Vector(2402.581299, 1800.875488, 25.891737, 1));
		}
		if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-186.363312, -1893.770996, 48.059792, 1));
			locationArray.PushBack(Vector(-344.072906, -2093.879883, 79.584808, 1));
			locationArray.PushBack(Vector(-503.066711, -1940.372559, 86.045418, 1));
			locationArray.PushBack(Vector(-903.430603, -1717.940552, 105.720253, 1));
			locationArray.PushBack(Vector(-1016.057617, -1407.408691, 123.840996, 1));
			locationArray.PushBack(Vector(-1119.396362, -1342.514160, 141.596375, 1));
			locationArray.PushBack(Vector(-993.063721, -1176.904663, 152.789749, 1));
			locationArray.PushBack(Vector(-1034.244141, -1003.966370, 133.748672, 1));
			locationArray.PushBack(Vector(-840.275574, -774.929443, 59.384888, 1));
			locationArray.PushBack(Vector(-856.001953, -603.389221, 46.191223, 1));
			locationArray.PushBack(Vector(0.726310, -607.658508, 24.529608, 1));
			locationArray.PushBack(Vector(407.886566, -557.544189, 22.235830, 1));
			locationArray.PushBack(Vector(708.602478, -402.620605, 17.965200, 1));
			locationArray.PushBack(Vector(805.953796, -570.503845, 49.959652, 1));
			locationArray.PushBack(Vector(1068.740112, -742.722656, 48.708954, 1));
			locationArray.PushBack(Vector(1330.748779, -706.607605, 49.725273, 1));
			locationArray.PushBack(Vector(1245.156616, -1002.181152, 34.783703, 1));
			locationArray.PushBack(Vector(1195.632935, -1236.864746, 3.214235, 1));
			locationArray.PushBack(Vector(855.881470, -1037.284546, 3.171189, 1));
			locationArray.PushBack(Vector(859.237305, -792.381958, 18.118769, 1));
			locationArray.PushBack(Vector(644.261047, -679.302246, 30.725731, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Phooca' );
		}
	}

	latent function Plumard_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Plumard_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(-113.550011, -293.514191, 15.165395, 1));
			locationArray.PushBack(Vector(98.915962, -390.873230, 7.779979, 1));
			locationArray.PushBack(Vector(-495.109802, -665.237122, 16.498842, 1));
			locationArray.PushBack(Vector(-669.183044, -163.483078, 14.383647, 1));
			locationArray.PushBack(Vector(-372.574402, 112.467865, 3.057209, 1));
			locationArray.PushBack(Vector(-322.405365, 663.856262, 7.021557, 1));
			locationArray.PushBack(Vector(-33.923191, 776.514465, 1.268860, 1));
			locationArray.PushBack(Vector(369.754761, 829.642395, 0.058789, 1));
			locationArray.PushBack(Vector(758.484680, 633.648926, 26.403652, 1));
			locationArray.PushBack(Vector(829.530029, 397.860077, 6.489234, 1));
			locationArray.PushBack(Vector(908.231995, -257.649109, 2.601311, 1));
			locationArray.PushBack(Vector(1037.110718, -429.625122, 1.717417, 1));
			locationArray.PushBack(Vector(1309.664429, -189.607056, 59.493999, 1));
			locationArray.PushBack(Vector(1556.100830, 48.231869, 15.460027, 1));
			locationArray.PushBack(Vector(1942.644287, -84.989563, 67.931824, 1));
			locationArray.PushBack(Vector(2244.792725, 399.043579, 9.307269, 1));
			locationArray.PushBack(Vector(2143.829590, 993.916321, 9.623662, 1));
			locationArray.PushBack(Vector(1921.153198, 1677.497192, 53.787735, 1));
			locationArray.PushBack(Vector(1798.041382, 2245.388672, 25.049421, 1));
			locationArray.PushBack(Vector(1371.197632, 2669.423340, 22.356218, 1));
			locationArray.PushBack(Vector(2079.475586, -470.123962, 6.851670, 1));
			locationArray.PushBack(Vector(73.458557, -316.602020, 3.533530, 1));
			locationArray.PushBack(Vector(16.252119, -468.912170, 12.709140, 1));
			locationArray.PushBack(Vector(349.460144, -423.570984, 0.829480, 1));
			locationArray.PushBack(Vector(539.309387, -127.748688, 5.721369, 1));
			locationArray.PushBack(Vector(469.873840, 207.302292, 15.570441, 1));
			locationArray.PushBack(Vector(381.270203, 103.280365, 13.728671, 1));
			locationArray.PushBack(Vector(71.422661, 189.642700, 12.144307, 1));
			locationArray.PushBack(Vector(372.044373, 294.698669, 12.074133, 1));
			locationArray.PushBack(Vector(426.272186, 492.548401, 4.412453, 1));
			locationArray.PushBack(Vector(637.340271, 726.201416, 10.877499, 1));
			locationArray.PushBack(Vector(970.197205, 554.683899, 24.736645, 1));
			locationArray.PushBack(Vector(1005.125549, 669.880615, 46.845470, 1));
			locationArray.PushBack(Vector(1048.338135, 879.819702, 25.295919, 1));
			locationArray.PushBack(Vector(1237.814453, 1042.234497, 5.863652, 1));
			locationArray.PushBack(Vector(1424.071777, 797.444641, 12.719515, 1));
			locationArray.PushBack(Vector(1521.724365, 665.587952, 14.807588, 1));
			locationArray.PushBack(Vector(1546.617798, 742.251343, 7.241004, 1));
			locationArray.PushBack(Vector(1592.058716, 500.552856, 0.884511, 1));
			locationArray.PushBack(Vector(945.443542, 909.594849, 14.161572, 1));
			locationArray.PushBack(Vector(804.166748, 891.754211, 5.302580, 1));
			locationArray.PushBack(Vector(-308.923248, 441.003937, 8.911276, 1));
			locationArray.PushBack(Vector(1654.742798, 1393.394287, 4.738217, 1));
			locationArray.PushBack(Vector(2216.801758, 1514.659912, 63.202801, 1));
			locationArray.PushBack(Vector(2062.631104, 1393.094727, 40.999130, 1));
			locationArray.PushBack(Vector(2274.527344, 1856.616699, 31.518398, 1));
			locationArray.PushBack(Vector(2395.979492, 1936.375854, 24.093918, 1));
			locationArray.PushBack(Vector(2418.147949, 2128.505615, 13.727621, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Plumard' );
		}
	}

	latent function The_Beast_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_The_Beast_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(-340.750336, 499.078217, 5.579980, 1));
			locationArray.PushBack(Vector(-240.779892, 744.179504, 23.957359, 1));
			locationArray.PushBack(Vector(435.992065, 1326.085693, 21.042843, 1));
			locationArray.PushBack(Vector(665.411133, 1472.419312, 6.838765, 1));
			locationArray.PushBack(Vector(959.845520, 1569.980713, 3.392555, 1));
			locationArray.PushBack(Vector(1388.463135, 1610.053833, 1.860427, 1));
			locationArray.PushBack(Vector(1530.992554, 1965.764160, 5.588093, 1));
			locationArray.PushBack(Vector(1387.307739, 1480.788574, 2.095412, 1));
			locationArray.PushBack(Vector(1570.825928, 1297.688599, -0.123172, 1));
			locationArray.PushBack(Vector(1470.294434, 1187.032715, 2.240878, 1));
			locationArray.PushBack(Vector(1783.669678, 1172.022217, 4.548589, 1));
			locationArray.PushBack(Vector(1960.101196, 1147.488647, 8.013702, 1));
			locationArray.PushBack(Vector(2074.075928, 1089.023926, 4.917964, 1));
			locationArray.PushBack(Vector(1953.877441, 927.431519, 1.269838, 1));
			locationArray.PushBack(Vector(2100.793457, 1303.387939, 24.075527, 1));
			locationArray.PushBack(Vector(2312.710938, 960.193970, 30.624783, 1));
			locationArray.PushBack(Vector(2140.385986, -392.130829, 7.141558, 1));
			locationArray.PushBack(Vector(699.186707, 460.728790, 13.150536, 1));
			locationArray.PushBack(Vector(942.565308, 825.476440, 19.566553, 1));
			locationArray.PushBack(Vector(942.565308, 825.476440, 19.566553, 1));
			locationArray.PushBack(Vector(917.797424, 915.553467, 11.310884, 1));
			locationArray.PushBack(Vector(899.050049, 993.041687, 0.236208, 1));
			locationArray.PushBack(Vector(1110.524536, 916.439270, 12.815605, 1));
			locationArray.PushBack(Vector(1168.049438, 959.228699, 2.232119, 1));
			locationArray.PushBack(Vector(1243.095825, 1396.839966, 0.038495, 1));

		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-727.400085, -484.026886, 29.109505, 1));
			locationArray.PushBack(Vector(-674.402771, -353.762695, 20.994011, 1));
			locationArray.PushBack(Vector(-776.804626, -189.315796, 3.700600, 1));
			locationArray.PushBack(Vector(-845.259521, 33.708336, 6.991922, 1));
			locationArray.PushBack(Vector(-935.302856, 169.652054, 26.963079, 1));
			locationArray.PushBack(Vector(-924.858337, 398.163055, 37.801090, 1));
			locationArray.PushBack(Vector(-963.745667, 531.646790, 64.991776, 1));
			locationArray.PushBack(Vector(-890.756592, 686.291809, 19.700903, 1));
			locationArray.PushBack(Vector(-461.354553, 615.971375, 2.315744, 1));
			locationArray.PushBack(Vector(-248.619080, 721.939392, -0.175762, 1));
			locationArray.PushBack(Vector(-72.771103, 630.751465, 15.047138, 1));
			locationArray.PushBack(Vector(103.121086, 457.775452, 13.096078, 1));
			locationArray.PushBack(Vector(163.520279, 543.093323, 18.353504, 1));
			locationArray.PushBack(Vector(108.897484, 706.738892, 44.768902, 1));
			locationArray.PushBack(Vector(-30.010857, 803.107300, 26.647226, 1));
			locationArray.PushBack(Vector(500.922668, -164.858215, 9.097790, 1));
			locationArray.PushBack(Vector(799.975159, -78.755714, 12.026348, 1));
			locationArray.PushBack(Vector(750.720093, -236.485458, 17.653166, 1));
			locationArray.PushBack(Vector(461.852081, -349.161407, 38.958031, 1));
			locationArray.PushBack(Vector(392.519257, -601.149536, 19.787714, 1));
			locationArray.PushBack(Vector(339.226318, -820.844788, 25.294600, 1));
			locationArray.PushBack(Vector(177.564240, -949.896973, 11.095909, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_TheBeast' );
		}
	}

	latent function GiantRockTroll_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Giant_Trolls_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(-83.652283, 825.619385, 6.814040, 1));
			locationArray.PushBack(Vector(439.038361, 297.068268, 2.413083, 1));
			locationArray.PushBack(Vector(432.175995, 1189.342407, 10.317221, 1));
			locationArray.PushBack(Vector(296.638794, 1417.689453, 26.598749, 1));
			locationArray.PushBack(Vector(135.326385, 1564.283813, 4.147139, 1));
			locationArray.PushBack(Vector(378.451141, 1547.816040, 7.426154, 1));
			locationArray.PushBack(Vector(1057.539307, 2124.237061, 6.799896, 1));
			locationArray.PushBack(Vector(954.551636, 2237.672607, 4.126230, 1));
			locationArray.PushBack(Vector(1007.959045, 2382.247070, 3.155971, 1));
			locationArray.PushBack(Vector(904.387024, 2478.490479, 20.083954, 1));
			locationArray.PushBack(Vector(685.963379, 2660.965576, 42.131599, 1));
			locationArray.PushBack(Vector(1203.423218, -1336.628662, 13.647555, 1));
			locationArray.PushBack(Vector(1365.308960, -1411.254028, 25.590517, 1));
			locationArray.PushBack(Vector(1568.900513, -1441.859497, 24.755070, 1));
			locationArray.PushBack(Vector(556.318054, -161.332397, 0.982558, 1));
			locationArray.PushBack(Vector(695.733459, -103.891937, 3.385972, 1));
			locationArray.PushBack(Vector(820.482666, -27.432623, 9.354900, 1));
			locationArray.PushBack(Vector(1362.515381, 97.368980, 15.285660, 1));
			locationArray.PushBack(Vector(1944.443970, -28.135277, 67.442513, 1));
			locationArray.PushBack(Vector(2126.497559, -629.321228, 7.145461, 1));
			locationArray.PushBack(Vector(2133.784912, -346.064240, 0.765507, 1));
			locationArray.PushBack(Vector(39.825802, -57.843487, 2.932896, 1));
			locationArray.PushBack(Vector(814.379395, 759.632629, 16.101336, 1));
			locationArray.PushBack(Vector(895.817932, 783.947632, 25.214117, 1));
			locationArray.PushBack(Vector(895.817932, 783.947632, 25.214117, 1));
			locationArray.PushBack(Vector(1030.896606, 986.082764, 0.090311, 1));
			locationArray.PushBack(Vector(1087.558960, 973.826416, 0.063283, 1));
			locationArray.PushBack(Vector(210.700470, 720.616943, 2.240232, 1));
			locationArray.PushBack(Vector(2360.036377, 1480.215942, 44.723820, 1));
			locationArray.PushBack(Vector(396.246948, 469.986145, 0.662693, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_GiantRockTroll' );
		}
	}

	latent function GiantIceTroll_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Giant_Trolls_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(4.445589, -333.085541, 71.284271, 1));
			locationArray.PushBack(Vector(5.287621, -580.129456, 62.766724, 1));
			locationArray.PushBack(Vector(310.019714, -747.174500, 16.894848, 1));
			locationArray.PushBack(Vector(493.789459, -693.541748, 29.782984, 1));
			locationArray.PushBack(Vector(671.784180, -531.278015, 72.428757, 1));
			locationArray.PushBack(Vector(843.949829, -436.526093, 66.400955, 1));
			locationArray.PushBack(Vector(899.529968, -248.567078, 22.200169, 1));
			locationArray.PushBack(Vector(1003.532410, -331.773621, 12.782719, 1));
			locationArray.PushBack(Vector(1099.866333, 499.817047, 2.947420, 1));
			locationArray.PushBack(Vector(1043.034180, 659.841064, 1.871318, 1));
			locationArray.PushBack(Vector(370.272583, 970.457214, 0.645516, 1));
			locationArray.PushBack(Vector(-114.917969, 398.548798, 36.592354, 1));
			locationArray.PushBack(Vector(-102.911087, 229.688812, 2.486377, 1));
			locationArray.PushBack(Vector(-227.657761, -111.409737, 40.609638, 1));
			locationArray.PushBack(Vector(-503.814514, -225.105331, 38.784515, 1));
			locationArray.PushBack(Vector(-694.657593, -235.945084, 14.500160, 1));
			locationArray.PushBack(Vector(-1494.397583, -589.593445, 24.010265, 1));
			locationArray.PushBack(Vector(-2091.409180, -693.341980, 21.748358, 1));
			locationArray.PushBack(Vector(-2407.948975, -982.762390, 0.496828, 1));
			locationArray.PushBack(Vector(-1798.451172, -1978.912720, 6.662552, 1));
			locationArray.PushBack(Vector(-723.084167, -1895.524658, 1.139682, 1));
			locationArray.PushBack(Vector(-44.313530, -1245.620361, 3.188847, 1));
			locationArray.PushBack(Vector(349.847565, -1409.451660, 4.052605, 1));
			locationArray.PushBack(Vector(408.525635, -1230.413940, 8.973654, 1));
			locationArray.PushBack(Vector(485.187592, -831.525208, 1.485389, 1));
			locationArray.PushBack(Vector(645.458984, -635.424561, 57.471813, 1));
			locationArray.PushBack(Vector(832.278015, -440.492004, 66.671371, 1));
			locationArray.PushBack(Vector(1096.462769, -189.441208, 2.649631, 1));
			locationArray.PushBack(Vector(-631.686157, -560.699890, 6.997999, 1));
			locationArray.PushBack(Vector(-669.275574, -629.244019, 1.302735, 1));
			locationArray.PushBack(Vector(-528.461853, -688.140320, 4.295346, 1));
			locationArray.PushBack(Vector(-456.681580, -796.733887, 16.357405, 1));
			locationArray.PushBack(Vector(446.876892, -1287.261597, 5.703918, 1));
			locationArray.PushBack(Vector(-316.006287, -443.072784, 52.868565, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_GiantIceTroll' );
		}
	}

	latent function GiantMagmaTroll_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Giant_Trolls_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(59.739307, 37.811275, 8.193762, 1));
			locationArray.PushBack(Vector(-221.911743, -198.083328, 17.216597, 1));
			locationArray.PushBack(Vector(-206.392944, -484.391296, 6.202147, 1));
			locationArray.PushBack(Vector(389.383667, -481.389313, 36.636112, 1));
			locationArray.PushBack(Vector(412.723297, -277.240631, 28.178568, 1));
			locationArray.PushBack(Vector(239.237747, -186.436615, 39.053719, 1));
			locationArray.PushBack(Vector(53.277809, -372.931610, 12.303003, 1));
			locationArray.PushBack(Vector(-239.807907, -158.113632, 19.732639, 1));
			locationArray.PushBack(Vector(-700.918396, -599.062073, 28.272722, 1));
			locationArray.PushBack(Vector(-894.362000, -435.819611, 48.287174, 1));
			locationArray.PushBack(Vector(-1462.350708, -1118.758423, 132.064682, 1));
			locationArray.PushBack(Vector(-1491.314697, -1425.742065, 207.128387, 1));
			locationArray.PushBack(Vector(-1156.875732, -1708.053955, 152.096863, 1));
			locationArray.PushBack(Vector(-819.692200, -2121.879150, 185.318588, 1));
			locationArray.PushBack(Vector(-413.944336, -2237.573242, 102.716560, 1));
			locationArray.PushBack(Vector(-124.331795, -2299.412842, 99.222824, 1));
			locationArray.PushBack(Vector(162.306305, -2284.646729, 99.687889, 1));
			locationArray.PushBack(Vector(440.774536, -2363.433350, 75.127831, 1));
			locationArray.PushBack(Vector(649.908264, -2487.118652, 4.996531, 1));
			locationArray.PushBack(Vector(557.734192, -2064.443604, 32.717133, 1));
			locationArray.PushBack(Vector(533.501648, -1498.732544, 6.590299, 1));
			locationArray.PushBack(Vector(432.482147, -1360.970093, 1.059601, 1));
			locationArray.PushBack(Vector(183.312088, -1502.213989, 9.366125, 1));
			locationArray.PushBack(Vector(528.933594, -1018.452271, 7.716246, 1));
			locationArray.PushBack(Vector(136.884506, -540.972046, 27.618055, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_GiantMagmaTroll' );
		}
	}

	latent function GiantRockElemental_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Elemental_Titans_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1060.282471, -76.535538, 19.190325, 1));
			locationArray.PushBack(Vector(1687.603149, 198.648117, 6.743061, 1));
			locationArray.PushBack(Vector(2048.343506, -517.623840, 12.872213, 1));
			locationArray.PushBack(Vector(2032.016235, -1036.760376, 3.535477, 1));
			locationArray.PushBack(Vector(2297.008057, -798.962219, 9.000401, 1));

		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ElementalTitanOfTerra' );
		}
	}

	latent function GiantIceElemental_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Elemental_Titans_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(1183.560059, 189.393356, 89.293564, 1));
			locationArray.PushBack(Vector(314.260742, 794.084473, 119.502014, 1));
			locationArray.PushBack(Vector(-1513.627686, -731.456543, 59.752247, 1));
			locationArray.PushBack(Vector(359.591278, -966.082092, 6.209056, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ElementalTitanOfIce' );
		}
	}

	latent function GiantFireElemental_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Elemental_Titans_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-915.964355, -488.935425, 47.484203, 1));
			locationArray.PushBack(Vector(-1290.276001, -1028.771240, 129.549973, 1));
			locationArray.PushBack(Vector(-331.664551, -1749.667725, 69.612183, 1));
			locationArray.PushBack(Vector(74.388710, 198.024963, -0.119638, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ElementalTitanOfFire' );
		}
	}

	latent function DarkKnight_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Dark_Knight_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(836.191589, -395.673523, 2.224552, 1));
			locationArray.PushBack(Vector(1381.291504, -1055.433960, 58.014816, 1));
			locationArray.PushBack(Vector(1545.358398, -1124.355347, 80.713638, 1));
			locationArray.PushBack(Vector(1428.787842, -1156.680664, 95.420837, 1));
			locationArray.PushBack(Vector(1974.339722, 2232.804443, 27.868523, 1));
			locationArray.PushBack(Vector(1542.161377, 2229.752441, 11.161452, 1));
			locationArray.PushBack(Vector(1428.027954, 1828.565918, 2.368070, 1));
			locationArray.PushBack(Vector(1590.977051, 1615.722534, 9.431250, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(-1576.830322, -756.010864, 55.247936, 1));
			locationArray.PushBack(Vector(-1792.773560, -602.607910, 6.070964, 1));
			locationArray.PushBack(Vector(-1950.407227, -811.379333, 27.354528, 1));
			locationArray.PushBack(Vector(1504.942993, 2018.200928, 46.665878, 1));
			locationArray.PushBack(Vector(2436.818359, -19.264551, 2.124149, 1));
			
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(1123.347168, -860.468994, 39.825954, 1));
			locationArray.PushBack(Vector(633.753723, -1489.232300, 25.632366, 1));
			locationArray.PushBack(Vector(-1175.391846, -1145.981934, 164.548019, 1));
			locationArray.PushBack(Vector(-2.496078, 454.166565, 16.158661, 1));
			locationArray.PushBack(Vector(-223.599854, 583.759888, 0.350415, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_DarkKnight' );
		}
	}

	latent function DarkKnightCalidus_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Dark_Knight_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1439.434326, -1199.826416, 106.754715, 1));
			locationArray.PushBack(Vector(1590.977051, 1615.722534, 9.431250, 1));
			locationArray.PushBack(Vector(2437.777344, 986.931763, 40.605934, 1));
			locationArray.PushBack(Vector(-286.669891, 921.278931, 14.871866, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(722.866943, 455.438446, 145.939957, 1));
			locationArray.PushBack(Vector(893.768738, 585.886963, 70.309082, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-772.236755, -1674.176514, 96.629082, 1));
			locationArray.PushBack(Vector(-1237.059204, -523.899353, 71.799675, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_DarkKnightCalidus' );
		}
	}

	latent function Voref_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Voref_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(-1858.732544, 1242.505371, 54.716381, 1));
			locationArray.PushBack(Vector(-1639.657471, 1499.595093, 8.460683, 1));
			locationArray.PushBack(Vector(1347.586548, 1895.510254, 13.347636, 1));
			locationArray.PushBack(Vector(1507.984375, 1973.587402, 12.546463, 1));
			locationArray.PushBack(Vector(2774.545898, -98.046440, 20.527134, 1));
			locationArray.PushBack(Vector(2277.303223, 131.885757, 22.807037, 1));
			locationArray.PushBack(Vector(2339.241455, -1968.287354, 11.821833, 1));
			locationArray.PushBack(Vector(2068.948486, -1997.734863, 17.378977, 1));
			locationArray.PushBack(Vector(1693.152466, -2017.753174, 17.882828, 1));
			locationArray.PushBack(Vector(1644.724487, -1852.296631, 21.086523, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Voref' );
		}
	}

	latent function Ifrit_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Ifrit_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1730.903931, -900.514587, 7.117824, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Ifrit' );
		}
	}

	latent function Carduin_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (FactsQuerySum("mq3035_fdb_radovid_dead") <= 0
		|| FactsQuerySum("ACS_Carduin_Killed") > 0)
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1964.925415, 985.420044, 1.828611, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_Carduin' );
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function Horse_Riders_Novigrad_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_HorseRiders_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(559.804443, 1292.834473, 9.919272, 1));
			locationArray.PushBack(Vector(626.770203, 1445.273315, 4.688265, 1));
			locationArray.PushBack(Vector(777.864685, 1529.187256, 5.996058, 1));
			locationArray.PushBack(Vector(786.411133, 1579.262695, 1.806557, 1));
			locationArray.PushBack(Vector(827.466064, 1599.035034, 1.995532, 1));
			locationArray.PushBack(Vector(841.997986, 1642.311035, 5.163556, 1));
			locationArray.PushBack(Vector(891.803589, 1623.978394, 2.756525, 1));
			locationArray.PushBack(Vector(940.476013, 1615.778931, 2.154349, 1));
			locationArray.PushBack(Vector(981.116882, 1635.465332, 2.013911, 1));
			locationArray.PushBack(Vector(1007.539856, 1748.234253, 3.210988, 1));
			locationArray.PushBack(Vector(1019.289246, 1783.243408, 7.284018, 1));
			locationArray.PushBack(Vector(988.604309, 1808.649536, 11.240920, 1));
			locationArray.PushBack(Vector(941.202698, 1805.843628, 6.114297, 1));
			locationArray.PushBack(Vector(922.937561, 1758.661743, 0.841169, 1));
			locationArray.PushBack(Vector(881.182800, 1741.015503, 2.027400, 1));
			locationArray.PushBack(Vector(827.453064, 1743.890381, 4.692541, 1));
			locationArray.PushBack(Vector(802.076965, 1735.344238, 5.798975, 1));
			locationArray.PushBack(Vector(798.924316, 1701.939697, 5.609519, 1));
			locationArray.PushBack(Vector(817.108704, 1680.515381, 8.443353, 1));
			locationArray.PushBack(Vector(804.355835, 1591.489014, 3.118973, 1));
			locationArray.PushBack(Vector(699.809265, 1582.292725, 1.037407, 1));
			locationArray.PushBack(Vector(637.489319, 1549.314941, 6.752225, 1));
			locationArray.PushBack(Vector(615.151428, 1568.734131, 6.565228, 1));
			locationArray.PushBack(Vector(649.136963, 1614.806885, 1.939423, 1));
			locationArray.PushBack(Vector(679.148193, 1685.042969, 4.162844, 1));
			locationArray.PushBack(Vector(714.279419, 1712.226929, 4.342856, 1));
			locationArray.PushBack(Vector(707.908508, 1746.473755, 4.275872, 1));
			locationArray.PushBack(Vector(667.339111, 1755.046875, 3.991571, 1));
			locationArray.PushBack(Vector(626.909180, 1750.054565, 3.332775, 1));
			locationArray.PushBack(Vector(592.320618, 1749.682617, 2.733042, 1));
			locationArray.PushBack(Vector(569.994507, 1746.251465, 3.530958, 1));
			locationArray.PushBack(Vector(546.997925, 1752.926514, 4.037784, 1));
			locationArray.PushBack(Vector(549.058167, 1721.820801, 2.737222, 1));
			locationArray.PushBack(Vector(576.248352, 1711.315674, 2.765430, 1));
			locationArray.PushBack(Vector(574.178650, 1678.055176, 2.745425, 1));
			locationArray.PushBack(Vector(676.974243, 1787.377197, 1.077542, 1));
			locationArray.PushBack(Vector(699.022766, 1774.245117, 1.882885, 1));
			locationArray.PushBack(Vector(734.696594, 1803.436646, 3.171304, 1));
			locationArray.PushBack(Vector(747.296082, 1837.330322, 6.207741, 1));
			locationArray.PushBack(Vector(723.387878, 1862.406494, 8.130503, 1));
			locationArray.PushBack(Vector(693.268799, 1864.740479, 10.415036, 1));
			locationArray.PushBack(Vector(667.678833, 1879.213867, 9.865468, 1));
			locationArray.PushBack(Vector(667.065674, 1907.984619, 10.069596, 1));
			locationArray.PushBack(Vector(667.809387, 1933.181152, 12.748077, 1));
			locationArray.PushBack(Vector(661.394470, 1959.732056, 19.485044, 1));
			locationArray.PushBack(Vector(641.407593, 2006.548340, 26.732508, 1));
			locationArray.PushBack(Vector(646.360901, 2056.395264, 30.960327, 1));
			locationArray.PushBack(Vector(672.580811, 2064.704590, 32.483738, 1));
			locationArray.PushBack(Vector(705.145142, 2051.127930, 35.471329, 1));
			locationArray.PushBack(Vector(687.579590, 1980.914429, 24.101236, 1));
			locationArray.PushBack(Vector(687.579590, 1980.914429, 24.101236, 1));
			locationArray.PushBack(Vector(606.221375, 1836.773071, 4.580671, 1));
			locationArray.PushBack(Vector(577.206543, 1851.548584, 4.460234, 1));
			locationArray.PushBack(Vector(560.922791, 1881.145020, 3.898340, 1));
			locationArray.PushBack(Vector(574.965698, 1908.730835, 4.934678, 1));
			locationArray.PushBack(Vector(582.241699, 1942.485718, 5.169654, 1));
			locationArray.PushBack(Vector(609.031250, 1926.634399, 7.640145, 1));
			locationArray.PushBack(Vector(572.713379, 1905.652710, 5.047591, 1));
			locationArray.PushBack(Vector(514.613220, 1864.846680, 4.373676, 1));
			locationArray.PushBack(Vector(487.588776, 1878.159424, 4.246819, 1));
			locationArray.PushBack(Vector(432.304901, 1900.859619, 2.441375, 1));
			locationArray.PushBack(Vector(423.872437, 1917.379517, 2.187095, 1));
			locationArray.PushBack(Vector(439.886108, 1960.878052, 2.989876, 1));
			locationArray.PushBack(Vector(480.748413, 1999.432861, 1.993202, 1));
			locationArray.PushBack(Vector(554.924988, 2008.583496, 0.945228, 1));
			locationArray.PushBack(Vector(545.887024, 1823.119019, 3.741268, 1));
			locationArray.PushBack(Vector(553.286987, 1785.111450, 4.094858, 1));
			locationArray.PushBack(Vector(546.797119, 1745.893555, 4.004136, 1));
			locationArray.PushBack(Vector(514.200684, 1712.156494, 1.766035, 1));
			locationArray.PushBack(Vector(483.030518, 1715.200684, 4.273919, 1));
			locationArray.PushBack(Vector(442.358643, 1720.356812, 3.523132, 1));
			locationArray.PushBack(Vector(408.354736, 1716.762573, 2.893276, 1));
			locationArray.PushBack(Vector(353.660461, 1748.678101, 3.527761, 1));
			locationArray.PushBack(Vector(312.378174, 1812.231934, 2.779862, 1));
			locationArray.PushBack(Vector(546.447998, 1581.426025, 4.560590, 1));
			locationArray.PushBack(Vector(550.437134, 1618.311157, 3.349564, 1));
			locationArray.PushBack(Vector(548.704529, 1653.926392, 5.524598, 1));
			locationArray.PushBack(Vector(550.694824, 1691.461060, 1.408275, 1));
			locationArray.PushBack(Vector(571.221008, 1675.925415, 2.652921, 1));
			locationArray.PushBack(Vector(616.582092, 1696.772461, 3.295815, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_HorseRidersNovigrad' );
		}
	}

	latent function Horse_Riders_Nilfgaard_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_HorseRiders_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(2466.281494, -893.399902, 6.793127, 1));
			locationArray.PushBack(Vector(2428.339844, -923.481384, 13.503413, 1));
			locationArray.PushBack(Vector(2458.485107, -956.510071, 15.537817, 1));
			locationArray.PushBack(Vector(2532.146729, -979.413635, 17.048088, 1));
			locationArray.PushBack(Vector(2481.230957, -1004.989929, 22.102385, 1));
			locationArray.PushBack(Vector(2424.871582, -1027.307373, 16.699303, 1));
			locationArray.PushBack(Vector(2407.072998, -1065.895020, 16.452110, 1));
			locationArray.PushBack(Vector(2380.022949, -1040.435791, 13.158699, 1));
			locationArray.PushBack(Vector(2396.104980, -1035.843384, 11.626535, 1));
			locationArray.PushBack(Vector(2388.740723, -990.363525, 10.828608, 1));
			locationArray.PushBack(Vector(2412.333008, -929.406921, 12.793174, 1));
			locationArray.PushBack(Vector(2377.936523, -901.019287, 15.148425, 1));
			locationArray.PushBack(Vector(2443.541016, -911.930664, 10.890745, 1));
			locationArray.PushBack(Vector(2490.681396, -866.127502, 4.416340, 1));
			locationArray.PushBack(Vector(2338.140625, -897.091736, 14.075936, 1));
			locationArray.PushBack(Vector(2315.433594, -914.326111, 13.513382, 1));
			locationArray.PushBack(Vector(2277.500244, -838.670593, 18.885704, 1));
			locationArray.PushBack(Vector(2235.349609, -800.985962, 13.757975, 1));
			locationArray.PushBack(Vector(2213.363525, -749.072876, 4.433287, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_HorseRidersNilfgaard' );
		}
	}

	latent function Horse_Riders_Redania_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_HorseRiders_Enabled())
		{
			return;
		}
		
		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1465.958252, 784.778442, 16.446341, 1));
			locationArray.PushBack(Vector(1407.601074, 735.999512, 20.292717, 1));
			locationArray.PushBack(Vector(1311.785156, 693.150452, 27.286922, 1));
			locationArray.PushBack(Vector(1374.735962, 712.657837, 24.236000, 1));
			locationArray.PushBack(Vector(1455.147095, 754.743103, 12.448925, 1));
			locationArray.PushBack(Vector(1473.313110, 795.962158, 17.800457, 1));
			locationArray.PushBack(Vector(1524.016479, 796.382690, 12.599571, 1));
			locationArray.PushBack(Vector(1552.367798, 748.240356, 6.686374, 1));
			locationArray.PushBack(Vector(1517.720581, 820.937866, 19.875105, 1));
			locationArray.PushBack(Vector(1553.853516, 837.139771, 24.376753, 1));
			locationArray.PushBack(Vector(1704.479980, 907.655884, 16.390196, 1));
			locationArray.PushBack(Vector(1737.160889, 913.022888, 13.461655, 1));
			locationArray.PushBack(Vector(1786.758301, 946.775269, 7.173893, 1));
			locationArray.PushBack(Vector(1778.848755, 989.085938, 5.434481, 1));
			locationArray.PushBack(Vector(1743.482788, 990.343933, 6.351764, 1));
			locationArray.PushBack(Vector(1697.981689, 1027.782349, 4.815741, 1));
			locationArray.PushBack(Vector(1678.539673, 992.940125, 6.632220, 1));
			locationArray.PushBack(Vector(1659.149902, 959.008972, 3.297548, 1));
			locationArray.PushBack(Vector(1645.828491, 944.151489, 0.349907, 1));
			locationArray.PushBack(Vector(1644.858521, 1001.239258, 0.958614, 1));
			locationArray.PushBack(Vector(1671.532837, 1087.961914, 1.291269, 1));
			locationArray.PushBack(Vector(1698.655151, 1123.668335, 2.611463, 1));
			locationArray.PushBack(Vector(1728.511353, 1056.475952, 3.611060, 1));
			locationArray.PushBack(Vector(1756.355347, 988.342896, 6.334800, 1));
			locationArray.PushBack(Vector(1785.741455, 957.808899, 6.415081, 1));
			locationArray.PushBack(Vector(1806.454224, 927.368164, 3.625343, 1));
			locationArray.PushBack(Vector(1761.244263, 864.744263, 12.226563, 1));
			locationArray.PushBack(Vector(1748.525635, 893.263916, 11.910158, 1));
			locationArray.PushBack(Vector(1777.484009, 931.466125, 9.068529, 1));
			locationArray.PushBack(Vector(1776.572021, 1036.940063, 6.366843, 1));
			locationArray.PushBack(Vector(1820.379639, 1038.930664, 6.410772, 1));
			locationArray.PushBack(Vector(1855.259766, 1050.624390, 5.604130, 1));
			locationArray.PushBack(Vector(1887.046875, 1081.388306, 3.855273, 1));
			locationArray.PushBack(Vector(1928.295166, 1120.715210, 5.250492, 1));
			locationArray.PushBack(Vector(1868.810913, 1164.570190, 4.222408, 1));
			locationArray.PushBack(Vector(1830.323730, 1206.231445, 8.353842, 1));
			locationArray.PushBack(Vector(1740.551880, 1211.378540, 1.532006, 1));
			locationArray.PushBack(Vector(1688.423462, 1242.124146, 0.214568, 1));
			locationArray.PushBack(Vector(1629.176147, 1271.613525, 0.904921, 1));

		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_HorseRidersRedania' );
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function Shades_Static_Spawns()
	{
		if ( ACS_SOI_Installed() && ACS_SOI_Enabled() )
		{
			Shades_Crusaders_Static_Spawn_Latent();

			Shades_Hunters_Static_Spawn_Latent();

			Shades_Rogue_Static_Spawn_Latent();

			Shades_Showdown_Static_Spawn_Latent();

			Shades_DancerWaxing_Static_Spawn_Latent();

			Shades_DancerWaning_Static_Spawn_Latent();

			Shades_Kara_Static_Spawn_Latent();

			Shades_NightmareIncarnate_Static_Spawn_Latent();
		}
		else
		{
			return;
		}
	}

	latent function Shades_Crusaders_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_ShadesCrusadersEncounters_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(-96.261490, 496.514160, 4.168004, 1));
			locationArray.PushBack(Vector(1442.825317, -156.178467, 34.575020, 1));
			locationArray.PushBack(Vector(1247.143188, -396.933289, 13.577165, 1));
			locationArray.PushBack(Vector(1537.524170, -648.968018, 12.437199, 1));
			locationArray.PushBack(Vector(1990.312378, -436.714294, 15.229907, 1));
			locationArray.PushBack(Vector(1463.748413, -233.927139, 33.607555, 1));
			locationArray.PushBack(Vector(286.134247, 763.021851, 13.521165, 1));
			locationArray.PushBack(Vector(1897.699219, 101.162201, 23.550243, 1));
			locationArray.PushBack(Vector(346.650421, 2289.112549, 1.287983, 1));

		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(51.748489, -365.346252, 79.771088, 1));
			locationArray.PushBack(Vector(914.110901, -537.865051, 107.964684, 1));
			locationArray.PushBack(Vector(582.840027, 110.165916, 35.443645, 1));
			locationArray.PushBack(Vector(124.594612, 405.387482, 18.596962, 1));
			locationArray.PushBack(Vector(-1912.970703, 1047.903198, 0.658970, 1));
			locationArray.PushBack(Vector(-1858.698608, -659.427185, 4.476814, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-21.013346, -474.961517, 24.952700, 1));
			locationArray.PushBack(Vector(-13.111011, -326.271423, 19.201012, 1));
			locationArray.PushBack(Vector(598.972046, -1180.097656, 0.641823, 1));
			locationArray.PushBack(Vector(-365.026398, -159.983231, 3.368326, 1));
			locationArray.PushBack(Vector(-228.809097, -533.481140, 3.519588, 1));
			locationArray.PushBack(Vector(18.647285, -678.582947, 10.790012, 1));
			locationArray.PushBack(Vector(362.993073, -647.690308, 9.928025, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ShadesCrusaders' );
		}
	}

	latent function Shades_Hunters_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_ShadesHuntersEncounters_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(-359.939789, -350.841095, 9.029205, 1));
			locationArray.PushBack(Vector(808.790405, 887.532349, 5.092355, 1));
			locationArray.PushBack(Vector(368.268494, 167.110001, 13.391841, 1));
			locationArray.PushBack(Vector(1315.874023, -91.625465, 48.924984, 1));
			locationArray.PushBack(Vector(1621.877563, -463.916565, -0.001937, 1));
			locationArray.PushBack(Vector(1713.485962, -153.484406, 16.518621, 1));
			locationArray.PushBack(Vector(204.403564, 896.528564, 15.489869, 1));
			locationArray.PushBack(Vector(1890.886597, 44.568913, 41.834393, 1));
			locationArray.PushBack(Vector(276.504639, -221.105301, 9.195626, 1));
			locationArray.PushBack(Vector(-341.500397, -388.934540, 0.169806, 1));
			locationArray.PushBack(Vector(1074.788208, 2023.471558, 2.105470, 1));
			locationArray.PushBack(Vector(2201.661621, 2263.071289, 25.586481, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(10.146903, -208.712524, 44.414921, 1));
			locationArray.PushBack(Vector(-378.827759, -330.870056, 32.853519, 1));
			locationArray.PushBack(Vector(1145.710205, 198.261917, 83.065720, 1));
			locationArray.PushBack(Vector(8.202209, 255.646484, 38.309612, 1));
			locationArray.PushBack(Vector(-717.588013, -12.888141, 13.429689, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-204.278168, -406.220703, 12.914266, 1));
			locationArray.PushBack(Vector(139.384125, -211.354691, 3.244171, 1));
			locationArray.PushBack(Vector(293.605682, -1968.699585, 52.851368, 1));
			locationArray.PushBack(Vector(-373.853302, -963.247925, 45.784046, 1));
			locationArray.PushBack(Vector(-183.772324, -581.050476, -0.253637, 1));
			locationArray.PushBack(Vector(189.077301, -656.824219, 5.551025, 1));
			locationArray.PushBack(Vector(459.234619, -585.749390, 14.529069, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ShadesHunters' );
		}
	}

	latent function Shades_Rogue_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_ShadesRoguesEncounters_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(353.239471, 2285.213867, 3.979245, 1));
			locationArray.PushBack(Vector(568.127380, 677.087646, 2.163726, 1));
			locationArray.PushBack(Vector(-381.984070, 593.227051, 8.234993, 1));
			locationArray.PushBack(Vector(634.776794, -162.416946, 1.703640, 1));
			locationArray.PushBack(Vector(939.541443, -228.531357, 7.599963, 1));
			locationArray.PushBack(Vector(1829.481567, -327.418030, 24.964720, 1));
			locationArray.PushBack(Vector(1992.832397, -283.588928, 41.125053, 1));
			locationArray.PushBack(Vector(1039.208496, -162.161713, 20.850004, 1));
			locationArray.PushBack(Vector(1290.747925, 2070.509277, 0.722277, 1));
			locationArray.PushBack(Vector(-78.507347, 88.184929, 9.766612, 1));
			locationArray.PushBack(Vector(-153.862198, -246.019089, 7.853103, 1));
			locationArray.PushBack(Vector(218.776566, 2450.163330, 0.333243, 1));
			locationArray.PushBack(Vector(540.532898, 2520.572021, 3.470522, 1));
			locationArray.PushBack(Vector(835.068115, 2301.150146, 6.422600, 1));
			locationArray.PushBack(Vector(935.644897, 2023.260742, 2.735881, 1));
			locationArray.PushBack(Vector(1238.741089, 2418.603271, 5.442310, 1));
			locationArray.PushBack(Vector(2080.517822, 2238.471436, 28.278675, 1));
			locationArray.PushBack(Vector(1982.532715, 2350.692627, 19.361572, 1));
			locationArray.PushBack(Vector(1741.040894, 2290.050293, 17.632099, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(188.853058, -830.516968, 52.398876, 1));
			locationArray.PushBack(Vector(206.081543, -792.950867, 48.885567, 1));
			locationArray.PushBack(Vector(-107.220207, -440.772888, 74.338486, 1));
			locationArray.PushBack(Vector(-285.313995, -750.034546, 88.877937, 1));
			locationArray.PushBack(Vector(-15.530822, -122.219963, 43.646618, 1));
			locationArray.PushBack(Vector(217.708710, 130.410004, 19.422598, 1));
			locationArray.PushBack(Vector(407.643341, 679.707825, 98.302200, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-106.270882, 34.509460, 16.529608, 1));
			locationArray.PushBack(Vector(-106.270882, 34.509460, 16.529608, 1));
			locationArray.PushBack(Vector(-146.143570, -169.555008, 23.651306, 1));
			locationArray.PushBack(Vector(558.679810, -376.019470, 20.434679, 1));
			locationArray.PushBack(Vector(614.657776, -556.352722, 14.072641, 1));
			locationArray.PushBack(Vector(315.880219, -1379.732300, 0.531166, 1));
			locationArray.PushBack(Vector(437.794006, -1504.202026, 23.864157, 1));
			locationArray.PushBack(Vector(597.245667, -1616.217773, 19.213041, 1));
			locationArray.PushBack(Vector(442.757446, -1743.896118, 36.139801, 1));
			locationArray.PushBack(Vector(253.836945, -1627.747925, 35.834690, 1));
			locationArray.PushBack(Vector(-254.203934, -780.528137, 12.520227, 1));
			locationArray.PushBack(Vector(-78.764366, -643.127441, 11.251825, 1));
			locationArray.PushBack(Vector(308.915741, -689.140320, 1.892760, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ShadesRogues' );
		}
	}

	latent function Shades_Showdown_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_ShadesShowdownEncounters_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w")
		{
			locationArray.PushBack(Vector(1769.390137, -102.458519, 23.400986, 1));
			locationArray.PushBack(Vector(1162.685303, -155.978531, 36.365353, 1));
			locationArray.PushBack(Vector(523.304016, 113.031120, 11.453874, 1));
			locationArray.PushBack(Vector(1148.690186, -370.782593, 13.497196, 1));
			locationArray.PushBack(Vector(1915.071167, -399.412628, 21.503414, 1));
			locationArray.PushBack(Vector(154.158691, -1116.292603, -0.015483, 1));
			locationArray.PushBack(Vector(1092.640625, -657.726257, 0.569505, 1));
			locationArray.PushBack(Vector(1779.888550, 1842.635376, 52.746086, 1));
			locationArray.PushBack(Vector(1330.569824, 443.738770, 4.523870, 1));
			locationArray.PushBack(Vector(-66.315247, 730.689331, 11.878308, 1));
			locationArray.PushBack(Vector(-74.997055, 1450.612305, 3.191873, 1));
			locationArray.PushBack(Vector(173.484207, -109.843445, 5.414771, 1));
			locationArray.PushBack(Vector(1790.676636, 1245.648926, 5.143333, 1));
			locationArray.PushBack(Vector(1112.810913, 1853.209473, -0.255843, 1));
			locationArray.PushBack(Vector(857.966125, 2238.721191, 5.727160, 1));
			locationArray.PushBack(Vector(878.537842, 2526.318604, 29.140984, 1));
			locationArray.PushBack(Vector(1208.398682, 2166.351807, 1.419053, 1));
			locationArray.PushBack(Vector(1007.221985, 2508.671631, 16.703279, 1));
			locationArray.PushBack(Vector(1490.885620, 2095.469971, 2.666871, 1));
			locationArray.PushBack(Vector(1726.934692, 2063.275391, 23.493605, 1));
			locationArray.PushBack(Vector(2481.259521, 2179.320801, 8.126663, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(-157.971573, -496.601532, 62.651382, 1));
			locationArray.PushBack(Vector(174.719025, 518.487366, 142.540710, 1));
			locationArray.PushBack(Vector(2055.271729, 1844.695312, 0.523307, 1));
			locationArray.PushBack(Vector(2574.385010, 1312.545044, 0.806857, 1));
			locationArray.PushBack(Vector(2555.852051, 1392.525757, 2.043532, 1));
			locationArray.PushBack(Vector(1875.469849, -826.150208, 0.370608, 1));
			locationArray.PushBack(Vector(-1139.844849, 2000.307495, 0.427565, 1));
			locationArray.PushBack(Vector(-1975.446899, -651.535278, 17.261555, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(53.079929, 120.814186, 8.233986, 1));
			locationArray.PushBack(Vector(154.414902, 228.924133, 2.163975, 1));
			locationArray.PushBack(Vector(883.237854, -651.240295, 42.029953, 1));
			locationArray.PushBack(Vector(771.788635, -1217.359985, 1.433838, 1));
			locationArray.PushBack(Vector(457.746307, -453.938965, 33.677498, 1));
			locationArray.PushBack(Vector(568.703613, -318.280945, 14.034167, 1));
			locationArray.PushBack(Vector(347.647552, -180.982834, 27.435987, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ShadesShowdown' );
		}
	}

	latent function Shades_DancerWaxing_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_ShadesDancerWaxing_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(507.355347, 114.080887, 11.957545, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(14.560478, -280.081360, 57.146980, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-585.864563, -1136.140137, 68.955757, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ShadesDancerWaxing' );
		}
	}

	latent function Shades_DancerWaning_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_ShadesDancerWaning_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1590.577881, -293.454285, 6.917136, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(972.469971, -622.263306, 160.332458, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-725.037659, -936.377991, 65.841370, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ShadesDancerWaning' );
		}
	}

	latent function Shades_Kara_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_Kara_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(1063.570435, 1055.188232, 5.496740, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(523.187012, -1352.352783, 6.551035, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-678.755920, -585.183228, 25.092775, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ShadesKara' );
		}
	}

	latent function Shades_NightmareIncarnate_Static_Spawn_Latent()
	{
		var locationArray 													: array<Vector>;
		var sizeArray , idx 												: int;
		var ent																: CEntity;

		if (!ACS_ShadesNightmareIncarnate_Enabled())
		{
			return;
		}

		locationArray.Clear();

		if ((theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"))
		{
			locationArray.PushBack(Vector(694.428406, 2466.855957, 23.605322, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			locationArray.PushBack(Vector(870.946960, 692.877014, 52.820572, 1));
		}
		else if ((theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w"))
		{
			locationArray.PushBack(Vector(-440.670990, -291.445679, 0.676720, 1));
		}
		else
		{
			locationArray.Clear();
		}

		sizeArray = locationArray.Size();

		if (sizeArray <= 0)
		{
			return;
		}

		for(idx = 0; idx < sizeArray; idx += 1)
		{
			ent = theGame.CreateEntity(LoadTemp(), locationArray[idx]);	

			ent.AddTag( 'ACS_MonsterSpawner_ShadesNightmareIncarnate' );
		}
	}
}