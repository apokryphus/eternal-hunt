function ACS_Jump_Extend_Init( type : EJumpType )
{
	var camera 														: CCustomCamera;
	var dest, prev_pos				 								: Vector;
	var ticket 														: SMovementAdjustmentRequestTicket;
	var movementAdjustor											: CMovementAdjustor;
	var slideDuration												: float;

	if (FactsQuerySum("ACS_In_Meditation") > 0
	|| GetACSWatcher().meditation_block 
	|| FactsQuerySum("ACS_Study_Target_Active") > 0
	)
	{
		return;
	}


	if ( 
	ACS_Settings_Main_Bool('acs_main_settings','acs_mod_enabled', true) && !thePlayer.IsCiri() 
	&& (ACS_Settings_Main_Bool('acs_jump_settings','acs_jump_extend', false) || ACS_Armor_Set_Check('acs_armor', false) )
	&& !GetWitcherPlayer().HasTag('acs_in_wraith') 
	&& FactsQuerySum("acs_transformation_activated") <= 0
	&& GetWitcherPlayer().IsAlive()
	&& !GetWitcherPlayer().IsInAir()
	&& GetWitcherPlayer().IsOnGround()
	&& thePlayer.IsActionAllowed(EIAB_Movement)
	&& thePlayer.IsActionAllowed(EIAB_Jump)
	&& (type == EJT_Idle 
	|| type == EJT_IdleToWalk 
	|| type == EJT_Walk 
	|| type == EJT_WalkHigh 
	|| type == EJT_Run 
	|| type == EJT_Sprint 
	|| type == EJT_Slide
	)
	)
	{	
		ACS_ThingsThatShouldBeRemoved();
		
		if (!GetWitcherPlayer().HasTag('acs_in_wraith')
		&& ACS_Settings_Main_Bool('acs_jump_settings','acs_jump_extend_effect', false))
		{
			GetWitcherPlayer().PlayEffect( 'bruxa_dash_trails_backup' );
			GetWitcherPlayer().StopEffect( 'bruxa_dash_trails_backup' );

			GetWitcherPlayer().PlayEffect( 'magic_step_l' );
			GetWitcherPlayer().StopEffect( 'magic_step_l' );	

			GetWitcherPlayer().PlayEffect( 'magic_step_r' );
			GetWitcherPlayer().StopEffect( 'magic_step_r' );	

			GetWitcherPlayer().PlayEffect( 'claws_effect' );
			GetWitcherPlayer().StopEffect( 'claws_effect' );	
		}

		if (
		!GetWitcherPlayer().GetIsSprinting() 
		&& !GetWitcherPlayer().HasTag('acs_in_wraith') 
		&& !GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
		)
		{
			GetACSWatcher().dodge_timer_slideback_actual();
		}	

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		prev_pos = GetWitcherPlayer().GetWorldPosition();
						
		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		movementAdjustor.CancelByName( 'ACS_jumpextend' );
		movementAdjustor.CancelAll();

		ticket = movementAdjustor.CreateNewRequest( 'ACS_jumpextend' );
		movementAdjustor.AdjustmentDuration( ticket, 0.5 );
		movementAdjustor.AdjustLocationVertically( ticket, true );
		movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
		//movementAdjustor.ShouldStartAt(ticket, prev_pos);
		//movementAdjustor.UseBoneForAdjustment(ticket, 'pelvis', true);
		
		if (GetWitcherPlayer().GetIsSprinting())
		{
			dest = GetWitcherPlayer().PredictWorldPosition(1.0) + (GetWitcherPlayer().GetHeadingVector() * (ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_sprinting_distance', 12)  ));
			
			dest.Z += ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_sprinting_height', 7);
			
			movementAdjustor.MaxLocationAdjustmentDistance(ticket, true, ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_sprinting_distance', 12) + 5, ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_sprinting_height', 7) + 5);

			if (
			(ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_sprinting_distance', 12) >= 15 
			|| ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_sprinting_height', 7) >= 15)
			&& !GetWitcherPlayer().HasTag('acs_in_wraith')
			&& ACS_Settings_Main_Bool('acs_jump_settings','acs_jump_extend_effect', false)
			)
			{
				GetWitcherPlayer().StopEffect('smoke_explosion');
				GetWitcherPlayer().PlayEffect('smoke_explosion');

				GetWitcherPlayer().StopEffect('suck_out');
				GetWitcherPlayer().PlayEffect('suck_out');
			}
		}
		else
		{
			dest = GetWitcherPlayer().PredictWorldPosition(1.0) + (GetWitcherPlayer().GetHeadingVector() * (ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_normal_distance', 10) ));
			
			dest.Z += ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_normal_height', 5) ;
			
			movementAdjustor.MaxLocationAdjustmentDistance(ticket, true, ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_normal_distance', 10) + 5, ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_normal_height', 5) + 5);

			if (
			(ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_normal_distance', 10) >= 15 
			|| ACS_Settings_Main_Int('acs_jump_settings','acs_jump_extend_normal_height', 5) >= 15)
			&& !GetWitcherPlayer().HasTag('acs_in_wraith')
			&& ACS_Settings_Main_Bool('acs_jump_settings','acs_jump_extend_effect', false)
			)
			{
				GetWitcherPlayer().StopEffect('smoke_explosion');
				GetWitcherPlayer().PlayEffect('smoke_explosion');

				GetWitcherPlayer().StopEffect('suck_out');
				GetWitcherPlayer().PlayEffect('suck_out');
			}
		}
		
		movementAdjustor.SlideTo(ticket, dest);
	}
}

function ACS_UpdateJumpCamera( out moveData : SCameraMovementData, dt : float ) : bool
{
	var camera								: CCustomCamera;
	var cameraPreset						: SCustomCameraPreset;
	
	camera = (CCustomCamera)theCamera.GetTopmostCameraObject();
	cameraPreset = camera.GetActivePreset();

	camera.ChangePivotDistanceController( 'Default' );
	camera.ChangePivotPositionController( 'Default' );
	
	moveData.pivotDistanceController = camera.GetActivePivotDistanceController();
	moveData.pivotPositionController = camera.GetActivePivotPositionController();

	moveData.pivotDistanceController.SetDesiredDistance(cameraPreset.distance + 1.0f);
	moveData.pivotPositionController.SetDesiredPosition(GetWitcherPlayer().GetWorldPosition());
	moveData.pivotPositionController.offsetZ = -0.25f;

	return true;
}