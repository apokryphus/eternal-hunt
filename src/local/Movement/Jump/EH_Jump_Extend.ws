function ACS_Jump_Extend_Init( type : EJumpType )
{
	var vACS_JumpExtend : cACS_JumpExtend;
	vACS_JumpExtend = new cACS_JumpExtend in theGame;
	
	if ( 
	ACS_Enabled() 
	&& ACS_JumpExtend_Enabled() 
	&& !GetWitcherPlayer().HasTag('acs_in_wraith') 
	&& !ACS_Transformation_Activated_Check()
	&& GetWitcherPlayer().IsAlive()
	&& !GetWitcherPlayer().IsInAir()
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
		vACS_JumpExtend.ACS_JumpExtend();
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

statemachine class cACS_JumpExtend 
{
    function ACS_JumpExtend()
	{
		this.PushState('ACS_JumpExtendState');
	}
}

state ACS_JumpExtendState in cACS_JumpExtend
{
	private var camera 														: CCustomCamera;
	private var dest, prev_pos				 								: Vector;
	private var ticket 														: SMovementAdjustmentRequestTicket;
	private var movementAdjustor											: CMovementAdjustor;
	private var slideDuration												: float;
	private var settings_interrupt											: SAnimatedComponentSlotAnimationSettings;
	private var mass, velocity, momentum 									: float;
	
	event OnEnterState(prevStateName : name)
	{
		JumpExtend_Entry();
	}
	
	entry function JumpExtend_Entry()
	{
		settings_interrupt.blendIn = 0;
		settings_interrupt.blendOut = 0;

		mass = ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetComponentByClassName( 'CMovingPhysicalAgentComponent' ) ).GetPhysicalObjectMass();
		velocity = VecLength( ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetComponentByClassName( 'CMovingPhysicalAgentComponent' ) ).GetPhysicalObjectLinearVelocity() );
		momentum = mass * velocity;
		
		if (!GetWitcherPlayer().HasTag('acs_in_wraith')
		&& ACS_JumpExtend_Effect_Enabled())
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
		&& !ACS_SwordWalk_Enabled()
		)
		{
			GetACSWatcher().dodge_timer_slideback_actual();
		}	

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', settings_interrupt );

		//Sleep(0.025);

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
			dest = GetWitcherPlayer().PredictWorldPosition(1.0) + (GetWitcherPlayer().GetHeadingVector() * (ACS_Sprinting_JumpExtend_GetDistance()  ));
			
			dest.Z += ACS_Sprinting_JumpExtend_GetHeight();
			
			movementAdjustor.MaxLocationAdjustmentDistance(ticket, true, ACS_Sprinting_JumpExtend_GetDistance() + 5, ACS_Sprinting_JumpExtend_GetHeight() + 5);

			if (
			(ACS_Sprinting_JumpExtend_GetDistance() >= 15 
			|| ACS_Sprinting_JumpExtend_GetHeight() >= 15)
			&& !GetWitcherPlayer().HasTag('acs_in_wraith')
			&& ACS_JumpExtend_Effect_Enabled()
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
			dest = GetWitcherPlayer().PredictWorldPosition(1.0) + (GetWitcherPlayer().GetHeadingVector() * (ACS_Normal_JumpExtend_GetDistance() ));
			
			dest.Z += ACS_Normal_JumpExtend_GetHeight() ;
			
			movementAdjustor.MaxLocationAdjustmentDistance(ticket, true, ACS_Normal_JumpExtend_GetDistance() + 5, ACS_Normal_JumpExtend_GetHeight() + 5);

			if (
			(ACS_Normal_JumpExtend_GetDistance() >= 15 
			|| ACS_Normal_JumpExtend_GetHeight() >= 15)
			&& !GetWitcherPlayer().HasTag('acs_in_wraith')
			&& ACS_JumpExtend_Effect_Enabled()
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
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}