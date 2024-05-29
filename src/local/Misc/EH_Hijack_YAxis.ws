function ACS_Hijack_Marker_Destroy()
{
	var marks							: array< CEntity >;
	var mark 							: CEntity;
	var i								: int;

	marks.Clear();
		
	theGame.GetEntitiesByTag( 'ACS_Hijack_Marker', marks );

	for( i=0; i<marks.Size(); i+=1 )
	{	
		mark = (CEntity)marks[i];	
		mark.DestroyAfter(2);
	}
}

function ACS_Hijack_Marker_2_Destroy()
{
	var marks							: array< CEntity >;
	var mark 							: CEntity;
	var i								: int;

	marks.Clear();
		
	theGame.GetEntitiesByTag( 'ACS_Hijack_Marker_2', marks );

	for( i=0; i<marks.Size(); i+=1 )
	{	
		mark = (CEntity)marks[i];	
		mark.DestroyAfter(2);
	}
}

function ACS_Hijack_YAxis_Up_Forward()
{
	var vHijackYAxis : cHijackYAxis;
	vHijackYAxis = new cHijackYAxis in theGame;
			
	vHijackYAxis.Hijack_YAxis_Engage();
}

statemachine class cHijackYAxis 
{
    function Hijack_YAxis_Engage()
	{
		this.PushState('Hijack_YAxis_Engage');
	}
}

state Hijack_YAxis_Engage in cHijackYAxis
{	
	private var i 										: int;
	private var npc     								: CNewNPC;
	private var actors									: array< CActor >;
	private var animatedComponent 						: CAnimatedComponent;
	private var settings								: SAnimatedComponentSlotAnimationSettings;
	private var markerNPC, markerNPC_2					: CEntity;
	private var markerTemplate 							: CEntityTemplate;
	private var attach_vec, bone_vec					: Vector;
	private var attach_rot, bone_rot					: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		HijackYAxis();
	}
	
	entry function HijackYAxis()
	{	
		//ACS_Hijack_Marker_Destroy();

		hijack_y_axis();	
	}
	
	latent function hijack_y_axis ()
	{
		theGame.GetActorsByTag( 'bruxa_bite_victim', actors );

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
					
			animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	

			if( actors.Size() > 0 )
			{
				if (npc.IsFlying())
				{	
					((CNewNPC)npc).SetUnstoppable(true);

					npc.RemoveBuffImmunity_AllNegative();

					npc.RemoveBuffImmunity_AllCritical();

					npc.ClearAnimationSpeedMultipliers();
					
					if (npc.HasAbility('mon_gryphon_base'))
					{
						npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'neck3' ), bone_vec, bone_rot );

						//markerNPC = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition() );

						//markerNPC.CreateAttachmentAtBoneWS( npc, 'neck3', bone_vec, bone_rot );

						animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_u', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.001, true);
					}
					else if (npc.HasAbility('mon_siren_base'))
					{
						//markerNPC.CreateAttachmentAtBoneWS( npc, 'head', npc.GetBoneWorldPosition('head'), npc.GetWorldRotation() );

						animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_u', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.001, true);
					}
					else if (npc.HasAbility('mon_wyvern_base'))
					{
						//markerNPC.CreateAttachmentAtBoneWS( npc, 'head', npc.GetBoneWorldPosition('head'), npc.GetWorldRotation() );

						animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.001, true);
					}
					else if (npc.HasAbility('mon_harpy_base'))
					{
						//markerNPC.CreateAttachmentAtBoneWS( npc, 'head', npc.GetBoneWorldPosition('head'), npc.GetWorldRotation() );

						animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_u', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.001, true);
					}
					else if (npc.HasAbility('mon_draco_base'))
					{
						//markerNPC.CreateAttachmentAtBoneWS( npc, 'head', npc.GetBoneWorldPosition('head'), npc.GetWorldRotation() );

						animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_up', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.001, true);
					}	
					else if (npc.HasAbility('mon_basilisk'))
					{
						//markerNPC.CreateAttachmentAtBoneWS( npc, 'head', npc.GetBoneWorldPosition('head'), npc.GetWorldRotation() );

						animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_u', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.001, true);
					}

					//markerNPC.AddTag('ACS_Hijack_Marker');
				}
				else
				{
					if (npc.HasAbility('mon_garkain'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_katakan_jump_up_aoe_attack', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.465, true);
					}
					else if (npc.HasAbility('mon_sharley'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'roll_forward', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.35, true);
					}
					else if (npc.HasAbility('mon_bies_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_bies_run__f', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 0.95, true);
					}
					else if (npc.HasAbility('mon_golem_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_elemental_attack_charge', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 2.75, true);
					}
					else if (
					npc.HasAbility('mon_endriaga_base')
					|| npc.HasAbility('mon_arachas_base')
					|| npc.HasAbility('mon_kikimore_base')
					|| npc.HasAbility('mon_black_spider_base')
					|| npc.HasAbility('mon_black_spider_ep2_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_archas_move_walk_f', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 1.55, true);
					}
					else if (npc.HasAbility('mon_ice_giant')
					|| npc.HasAbility('mon_cyclops')
					|| npc.HasAbility('mon_knight_giant')
					|| npc.HasAbility('mon_cloud_giant'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'giant_combat_walk', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 1.5, true);
					}
					else if (npc.HasAbility('mon_troll_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_cave_troll_run', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));

						GetACSWatcher().AddTimer('ACS_HijackMoveForward', 3.75, true);
					}
				}

				npc.ClearAnimationSpeedMultipliers();
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}