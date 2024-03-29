function ACS_BruxaBiteInit()
{
	var vBruxaBite : cBruxaBite;
	vBruxaBite = new cBruxaBite in theGame;

	if (ACS_New_Replacers_Female_Active())
	{
		GetACSWatcher().ACS_BruxaDodgeSlideBackInit();
		return;
	}
	
	if ( ACS_Enabled() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		)
		{
			if (!GetWitcherPlayer().HasTag('in_wraith'))
			{
				if (!GetWitcherPlayer().HasTag('blood_sucking') 
				//&& (ACS_BruxaDash_Enabled() || ACS_BruxaLeapAttack_Enabled())
				//&& GetWitcherPlayer().GetStat( BCS_Stamina ) == GetWitcherPlayer().GetStatMax( BCS_Stamina ) 
				)
				{
					vBruxaBite.BruxaBite_Engage();
				}
				else if ( GetWitcherPlayer().HasTag('blood_sucking') 
				//&& ACS_Hijack_Enabled() 
				)
				{
					vBruxaBite.BruxaBite_HijackForward();
				}
			}
			else
			{
				if(theInput.LastUsedPCInput())
				{
					if (GetWitcherPlayer().IsInCombat())
					{
						if (ACS_BruxaLeapAttack_Enabled())
						{
							GetACSWatcher().JumpAttackCombat();
						}
						else
						{
							GetACSWatcher().ACS_BruxaDodgeSlideBackInit();
						}
					}
					else
					{
						GetACSWatcher().ACS_BruxaDodgeSlideBackInit();
					}
				}
			}
		}
	}
	else
	{
		if(theInput.LastUsedPCInput())
		{
			GetACSWatcher().ACS_BruxaDodgeSlideBackInit();
		}
	}
}

statemachine class cBruxaBite 
{
    function BruxaBite_Engage()
	{
		this.PushState('BruxaBite_Engage');
	}

	function BruxaBite_HijackForward()
	{
		this.PushState('BruxaBite_HijackForward');
	}
}

state BruxaBite_HijackForward in cBruxaBite
{
	private var i 						: int;
	private var npc     				: CNewNPC;
	private var actors					: array< CActor >;
	private var animatedComponent 		: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		HijackForwardEntry();
	}
	
	entry function HijackForwardEntry()
	{
		HijackForwardLatent();	
	}

	latent function HijackForwardLatent()
	{
		actors.Clear();

		actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
				
			animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

			if( actors.Size() > 0 )
			{	
				((CNewNPC)npc).SetUnstoppable(true);

				npc.RemoveBuffImmunity_AllNegative();

				npc.RemoveBuffImmunity_AllCritical();

				npc.ClearAnimationSpeedMultipliers();
				
				if (npc.IsFlying())
				{
					if (npc.HasAbility('mon_gryphon_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_u', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_siren_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_u', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_wyvern_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_harpy_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_u', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_draco_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}	
					else if (npc.HasAbility('mon_basilisk'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_u', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
				}
				else
				{
					if (npc.HasAbility('mon_garkain'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_katakan_jump_up_aoe_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_sharley_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'roll_forward', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_bies_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_walk_f', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_golem_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_move_walk_f', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (
					npc.HasAbility('mon_endriaga_base')
					|| npc.HasAbility('mon_arachas_base')
					|| npc.HasAbility('mon_kikimore_base')
					|| npc.HasAbility('mon_black_spider_base')
					|| npc.HasAbility('mon_black_spider_ep2_base')
					)
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (
					npc.HasAbility('mon_ice_giant')
					|| npc.HasAbility('mon_cyclops')
					|| npc.HasAbility('mon_knight_giant')
					|| npc.HasAbility('mon_cloud_giant')
					)
					{
						animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_taunt_2', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_troll_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
				}
				
				npc.ClearAnimationSpeedMultipliers();
			}
		}
	}
}

state BruxaBite_Engage in cBruxaBite
{	
	private var markerNPC, markerNPC_2							: CEntity;
	private var markerTemplate 									: CEntityTemplate;
	private var attach_vec, bone_vec							: Vector;
	private var attach_rot, bone_rot							: EulerAngles;
	private var movementAdjustor								: CMovementAdjustor;
	private var ticket 											: SMovementAdjustmentRequestTicket;
	private var actor											: CActor;
	private var dist											: float;
	private var animatedComponent 								: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		BruxaBite();
	}
	
	entry function BruxaBite()
	{
		if (!GetWitcherPlayer().HasTag('ACS_Camo_Active'))
		{
			//GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
			//GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );

			GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
			
			if (!ACS_HideVampireClaws_Enabled())
			{
				GetWitcherPlayer().DestroyEffect('shadowdash_short');
				GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
				GetWitcherPlayer().StopEffect( 'shadowdash_short' );
			}	
		}

		ACS_ThingsThatShouldBeRemoved();
								
		bruxa_bite_init();	
	}
	
	latent function bruxa_bite_init ()
	{		
		actor = (CActor)( GetWitcherPlayer().GetTarget() );
		
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'bruxa_bite_init');
		
		movementAdjustor.CancelByName( 'bruxa_bite_init' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'bruxa_bite_init' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		movementAdjustor.AdjustLocationVertically( ticket, true );

		movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			if(theInput.LastUsedPCInput())
			{
				movementAdjustor.RotateTowards( ticket, actor );
				
				movementAdjustor.SlideTowards( ticket, actor, dist, dist );

				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}

			GetACSWatcher().RemoveTimer('ACS_bruxa_bite_delay');
			GetACSWatcher().AddTimer('ACS_bruxa_bite_delay', 0.25 , false);
		}
		else
		{
			if(theInput.LastUsedPCInput())
			{
				movementAdjustor.SlideTo( ticket, TraceFloor(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10) );
	
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_jump_up_stop_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
			}
		}
	}
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}