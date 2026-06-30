function ACS_BruxaBiteInit()
{
	var movementAdjustor								: CMovementAdjustor;
	var ticket 											: SMovementAdjustmentRequestTicket;
	var actor											: CActor;
	var dist											: float;
	var animatedComponent 								: CAnimatedComponent;

	if (ACS_New_Replacers_Female_Active())
	{
		GetACSWatcher().ACS_BruxaDodgeSlideBackInit();
		return;
	}
	
	if ( ACS_Settings_Main_Bool('acs_main_settings','acs_mod_enabled', true) && !thePlayer.IsCiri() )
	{
		if (!GetWitcherPlayer().IsCiri()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		)
		{
			if (!GetWitcherPlayer().HasTag('acs_in_wraith'))
			{
				if (!GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process') 
				//&& (ACS_Settings_Main_Bool('acs_bruxa_dash_settings','acs_bruxa_dash', false) || ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_leap_attack', false))
				//&& GetWitcherPlayer().GetStat( BCS_Stamina ) == GetWitcherPlayer().GetStatMax( BCS_Stamina ) 
				)
				{
					if (!GetWitcherPlayer().HasTag('ACS_Camo_Active'))
					{
						//GetWitcherPlayer().PlayEffectSingle( 'special_attack_only_black_fx' );
						//GetWitcherPlayer().StopEffect( 'special_attack_only_black_fx' );

						GetWitcherPlayer().PlayEffectSingle( 'bruxa_dash_trails' );
						GetWitcherPlayer().StopEffect( 'bruxa_dash_trails' );
						
						if (!ACS_Settings_Main_Bool('acs_player_misc_settings','acs_hide_vampire_claws', false))
						{
							GetWitcherPlayer().DestroyEffect('shadowdash_short');
							GetWitcherPlayer().PlayEffectSingle( 'shadowdash_short' );
							GetWitcherPlayer().StopEffect( 'shadowdash_short' );
						}	
					}

					ACS_ThingsThatShouldBeRemoved();

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
						GetACSWatcher().AddTimer('ACS_bruxa_bite_delay', 0.25 / theGame.GetTimeScale() , false);
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
			}
			else
			{
				if(theInput.LastUsedPCInput())
				{
					if (GetWitcherPlayer().IsInCombat())
					{
						if (ACS_Settings_Main_Bool('acs_dodge_settings','acs_bruxa_leap_attack', false))
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