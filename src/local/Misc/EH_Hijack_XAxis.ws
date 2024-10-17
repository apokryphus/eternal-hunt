function ACS_Hijack_XAxis_Init()
{
	var vHijackXAxis : cHijackXAxis;
	vHijackXAxis = new cHijackXAxis in theGame;
			
	vHijackXAxis.HijackXAxis_Engage();
}

statemachine class cHijackXAxis 
{
    function HijackXAxis_Engage()
	{
		this.PushState('HijackXAxis_Engage');
	}
}

state HijackXAxis_Engage in cHijackXAxis
{	
	event OnEnterState(prevStateName : name)
	{
		HijackXAxis();
	}
	
	entry function HijackXAxis()
	{				
		hijack_x_axis();	
	}
	
	latent function hijack_x_axis ()
	{
		var i 						: int;
    	var npc     				: CNewNPC;
		var actors					: array< CActor >;
		var animatedComponent 		: CAnimatedComponent;
		var settings				: SAnimatedComponentSlotAnimationSettings;
		
		if (theInput.GetActionValue('GI_AxisLeftX') > 0.5 )
		{
			actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, ,true);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
					
				animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
					
				if( actors.Size() > 0 )
				{				
					if( npc.IsAlive() )
					{	
						if (npc.HasTag('bruxa_bite_victim'))
						{
							npc.ClearAnimationSpeedMultipliers();
							
							if (npc.HasAbility('mon_gryphon_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dr_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_siren_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_dr', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_wyvern_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_harpy_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_dr_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_draco_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_right_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_basilisk'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dr_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_garkain'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_r', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_sharley'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_right', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							
							npc.ClearAnimationSpeedMultipliers();
						}
					}
				}
			}
		}
		else if (theInput.GetActionValue('GI_AxisLeftX') < -0.5 )
		{
			actors = GetActorsInRange(GetWitcherPlayer(), 1, 100, ,true);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
					
				animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
					
				settings.blendIn = 0.2f;
				settings.blendOut = 1.0f;
					
				if( actors.Size() > 0 )
				{	
					if( npc.IsAlive() )
					{	
						if (npc.HasTag('bruxa_bite_victim'))
						{
							npc.ClearAnimationSpeedMultipliers();
							
							if (npc.HasAbility('mon_gryphon_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dl_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_siren_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_dl', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_wyvern_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_harpy_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_dl_tight', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_draco_base'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_left_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_basilisk'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_dl_tighter', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_garkain'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'monster_werewolf_run_turn_l', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							else if (npc.HasAbility('mon_sharley'))
							{
								animatedComponent.PlaySlotAnimationAsync ( 'roll_forward_left', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
							}
							
							npc.ClearAnimationSpeedMultipliers();
						}
					}
				}
			}
		}
		/*
		else
		{
			actors = GetActorsInRange(GetWitcherPlayer(), 1, 100, ,true);
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
					
				animatedComponent = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
					
				settings.blendIn = 0.2f;
				settings.blendOut = 1.0f;
					
				if( actors.Size() > 0 )
				{	
					npc.ClearAnimationSpeedMultipliers();
					
					if (npc.HasAbility('mon_gryphon_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_d', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_siren_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_siren_fly_fast_d', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_wyvern_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_harpy_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_harpy_fly_fast_d', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
					else if (npc.HasAbility('mon_draco_base'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_wyvern_fly_down', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}	
					else if (npc.HasAbility('mon_basilisk'))
					{
						animatedComponent.PlaySlotAnimationAsync ( 'monster_gryphon_fly_d', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 1.0f));
					}
								
					npc.ClearAnimationSpeedMultipliers();
				}
			}
		}
		*/
	}
}