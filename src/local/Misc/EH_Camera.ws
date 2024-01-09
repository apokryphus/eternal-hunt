statemachine class ACSMeditationCamera extends CStaticCamera
{
	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetMeditationCamera(this);
		
		cameraPos = theCamera.GetCameraPosition();
		cameraRot = theCamera.GetCameraRotation();
		
		currentHeading = cameraRot.Yaw;		

		Start();
	}
	
	var targetPos : Vector;
	var targetRot : EulerAngles;

	function Start()	
	{	
		this.deactivationDuration = 1;
		this.activationDuration = 1;
		this.fadeStartDuration = 1;
		this.fadeEndDuration = 1;
		this.Run();
		this.TeleportWithRotation(cameraPos,cameraRot);
		
		//targetPos = thePlayer.GetWorldPosition();
		//targetPos.Z += 1;

		targetPos = cameraPos;

		targetRot = cameraRot;

		//targetPos += VecConeRand(currentHeading, 0, -3, -3);

		/*
		if (thePlayer.IsInInterior())
		{
			targetPos += VecConeRand(currentHeading, 0, -3, -3);
		}
		else
		{
			targetPos += VecConeRand(currentHeading, 0, -5, -5);
		}
		*/

		//targetRot = thePlayer.GetWorldRotation();

		
		AddTimer('IntoTick',0.006,true);
	}
	
	timer function IntoTick( deltaTime : float , id : int)	
	{		
		var pos : Vector;
		var rot, currentRot : EulerAngles;
	
		currentRot = this.GetWorldRotation();
		pos = VecInterpolate(this.GetWorldPosition(), targetPos, 0.07);
		rot.Pitch = AngleApproach( targetRot.Pitch, currentRot.Pitch, 1 );
		rot.Roll = AngleApproach( targetRot.Roll, currentRot.Roll, 1 );
		rot.Yaw = AngleApproach( targetRot.Yaw, currentRot.Yaw, 1 );
		
		
		
		if(VecDistance(pos, targetPos) < 0.01 )
		{
			AddTimer('Tick',0.0000000016,true);
			RemoveTimer('IntoTick');
		}
	
		this.TeleportWithRotation(pos,rot);	
	}
	
	public function getHeading() : float
	{
		return this.currentHeading;
	}
	
	public function getPitch() : float
	{
		return this.currentPitch;
	}
	
	var currentHeading : float;
	var currentPitch : float;
	var maxPitch : float; default maxPitch = 50;
	
	var cameraPos, vampPos : Vector;
	var cameraRot : EulerAngles;

	timer function Tick( deltaTime : float , id : int)	
	{	
		vampPos = thePlayer.GetWorldPosition();
		vampPos.Z += 1;

		if ( theInput.LastUsedPCInput() )
		{
			if(theInput.GetActionValue( 'GI_MouseDampX' )!=0)
			{
				currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' ) * -1,0.01f,0.1f);
			} 

			if(theInput.GetActionValue( 'GI_MouseDampY' )!=0)
			{
				currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' ) * -1,0.01f,0.1f);
				
				if(AbsF(currentPitch) > maxPitch )
				{
					currentPitch = maxPitch * SignF(currentPitch);
				}
			}
		}
		else
		{
			if(theInput.GetActionValue( 'GI_MouseDampX' )( 'GI_AxisRightX' )!=0)
			{
				currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' )( 'GI_AxisRightX' ) * -1,0.09f,3.5f);
			}

			if(theInput.GetActionValue( 'GI_MouseDampY' )( 'GI_AxisRightY' )!=0)
			{
				currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' )( 'GI_AxisRightY' ) * 1,0.09f,1.5f);

				if(AbsF(currentPitch) > maxPitch )
				{
					currentPitch = maxPitch * SignF(currentPitch);
				}
			}
		}

		if (thePlayer.IsInInterior())
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -3, -3);
		}
		else
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -5, -5);
		}

		cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/100, LerpF(AbsF(currentPitch)  , 0 , 3.0)/100);
		cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/40;

		cameraRot.Yaw = currentHeading;
		cameraRot.Pitch = currentPitch;
		
		this.TeleportWithRotation(cameraPos, cameraRot);
	}	
	
	var originalCamPos : Vector;
	var originalCamRot : EulerAngles;
	
	public function GoBack()
	{
		var rr : EulerAngles;
		
		rr = this.GetWorldRotation();
		rr.Pitch = 0;
		rr.Roll = 0;
	
		originalCamPos = thePlayer.GetWorldPosition();
		originalCamPos += VecConeRand(thePlayer.GetHeading(), 0.01, -3, -3);
		originalCamPos.Z += 2;
		originalCamRot = thePlayer.GetWorldRotation();
		originalCamRot.Pitch -= 15;
		
		RemoveTimer('Tick');
		AddTimer('EndTick',0.0016, true);		
	}

	timer function EndTick( deltaTime : float , id : int)	
	{	
		var pos : Vector;
		var rot, currentRot : EulerAngles;
	
		currentRot = this.GetWorldRotation();
		pos = VecInterpolate(this.GetWorldPosition(), originalCamPos, 0.07);
		rot.Pitch = AngleApproach( originalCamRot.Pitch, currentRot.Pitch, 1 );
		rot.Roll = AngleApproach( originalCamRot.Roll, currentRot.Roll, 1 );
		rot.Yaw = AngleApproach( originalCamRot.Yaw, currentRot.Yaw, 1 );
		
		if(VecDistance(pos, originalCamPos) < 0.01 )
		{
			this.Stop();
			this.Destroy();			
		}
	
		this.TeleportWithRotation(pos,rot);
	}
}

statemachine class ACSTransformationCamera extends CStaticCamera
{
	var targetPos : Vector;
	var targetRot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetTransformationCamera(this);
		
		cameraPos = theCamera.GetCameraPosition();
		cameraRot = theCamera.GetCameraRotation();
		
		currentHeading = cameraRot.Yaw;		
		
		this.deactivationDuration = 1;
		this.activationDuration = 1;
		this.fadeStartDuration = 1;
		this.fadeEndDuration = 1;
		this.Run();
		this.TeleportWithRotation(cameraPos,cameraRot);

		if (
		FactsQuerySum("acs_wolven_curse_activated") > 0
		)
		{
			targetPos = GetACSTransformationWerewolf().GetWorldPosition();

			targetPos.Z += 1.75;
			targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

			targetRot = GetACSTransformationWerewolf().GetWorldRotation();
		}
		else if (
		FactsQuerySum("acs_vampireess_transformation_activated") > 0
		)
		{
			targetPos = GetACSTransformationVampiress().GetWorldPosition();

			targetPos.Z += 1.5;
			targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

			targetRot = GetACSTransformationVampiress().GetWorldRotation();
		}
		else if (
		FactsQuerySum("acs_vampire_monster_transformation_activated") > 0
		)
		{
			targetPos = GetACSTransformationVampireMonster().GetWorldPosition();

			targetPos.Z += 1.5;
			targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

			targetRot = GetACSTransformationVampireMonster().GetWorldRotation();
		}
		if (
		FactsQuerySum("acs_toad_transformation_activated") > 0
		)
		{
			targetPos = GetACSTransformationToad().GetWorldPosition();

			targetPos.Z += 2.25;
			targetPos += VecConeRand(currentHeading, 0, -7.75, -7.75);

			targetRot = GetACSTransformationToad().GetWorldRotation();
		}
		else
		{
			targetPos.Z += 7;
			targetPos += VecConeRand(currentHeading, 0, -7.5, -7.5);
		}
		
		AddTimer('Tick',0.000000000001,true);
	}
	
	public function getHeading() : float
	{
		return this.currentHeading;
	}
	
	public function getPitch() : float
	{
		return this.currentPitch;
	}

	public function getCamWorldRotation() : EulerAngles
	{
		return this.GetWorldRotation();
	}

	public function getCameraPitch() : float
	{
		return currentCamPitch;
	}

	public function getCameraRoll() : float
	{
		return currentCamRoll;
	}

	public function getYaw() : float
	{
		return currentCamYaw;
	}
	
	var currentHeading : float;
	var currentPitch : float;

	var currentCamPitch : float;
	var currentCamRoll : float;
	var currentCamYaw : float;

	var maxPitch : float; default maxPitch = 50;
	
	var cameraPos, vampPos : Vector;
	var cameraRot, currentCamRot : EulerAngles;

	timer function Tick( deltaTime : float , id : int)	
	{	
		currentCamRot = this.GetWorldRotation();

		currentCamPitch = currentCamRot.Pitch;

		currentCamRoll = currentCamRot.Roll;

		currentCamYaw = currentCamRot.Yaw;

		if (
		FactsQuerySum("acs_wolven_curse_activated") > 0
		)
		{
			vampPos = GetACSTransformationWerewolf().GetWorldPosition();
			vampPos.Z += 1.75;
		}
		else if (
		FactsQuerySum("acs_vampireess_transformation_activated") > 0
		)
		{
			vampPos = GetACSTransformationVampiress().GetWorldPosition();

			vampPos.Z += 1.5;
		}
		else if (
		FactsQuerySum("acs_vampire_monster_transformation_activated") > 0
		)
		{
			//vampPos = GetACSTransformationVampireMonster().GetWorldPosition();

			vampPos = GetACSTransformationVampireMonsterCameraDummy().GetWorldPosition();

			if (GetACSTransformationVampireMonster().HasTag('ACS_Vampire_Monster_Flight_Mode'))
			{
				//vampPos.Z += 7;
				vampPos.Z += 1;
			}
			else if (GetACSTransformationVampireMonster().HasTag('ACS_Vampire_Monster_Ground_Mode'))
			{
				//vampPos.Z += 1.75;

				vampPos.Z += 0.01;
			}
		}
		else if (
		FactsQuerySum("acs_toad_transformation_activated") > 0
		)
		{
			vampPos = GetACSTransformationToad().GetWorldPosition();
			vampPos.Z += 2.25;
		}

		if ( theInput.LastUsedPCInput() )
		{
			if(theInput.GetActionValue( 'GI_MouseDampX' )!=0)
			{
				currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' ) * -1,0.01f,0.1f);
			} 

			if(theInput.GetActionValue( 'GI_MouseDampY' )!=0)
			{
				currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' ) * -1,0.01f,0.1f);
				
				if(AbsF(currentPitch) > maxPitch )
				{
					currentPitch = maxPitch * SignF(currentPitch);
				}
			}
		}
		else
		{
			if(theInput.GetActionValue( 'GI_MouseDampX' )( 'GI_AxisRightX' )!=0)
			{
				currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' )( 'GI_AxisRightX' ) * -1,0.09f,3.5f);
			}

			if(theInput.GetActionValue( 'GI_MouseDampY' )( 'GI_AxisRightY' )!=0)
			{
				currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' )( 'GI_AxisRightY' ) * 1,0.09f,1.5f);

				if(AbsF(currentPitch) > maxPitch )
				{
					currentPitch = maxPitch * SignF(currentPitch);
				}
			}
		}	

		if (
		FactsQuerySum("acs_wolven_curse_activated") > 0
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -4.5, -4.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
		}
		else if (
		FactsQuerySum("acs_vampireess_transformation_activated") > 0
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -4.5, -4.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/60;
		}
		else if (
		FactsQuerySum("acs_vampire_monster_transformation_activated") > 0
		)
		{
			if (GetACSTransformationVampireMonster().HasTag('ACS_Vampire_Monster_Flight_Mode'))
			{
				cameraPos = vampPos + VecConeRand(currentHeading, 0, -7.75, -7.75);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
			}
			else if (GetACSTransformationVampireMonster().HasTag('ACS_Vampire_Monster_Ground_Mode'))
			{
				cameraPos = vampPos + VecConeRand(currentHeading, 0, -4.5, -4.5);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
			}
		}
		if (
		FactsQuerySum("acs_toad_transformation_activated") > 0
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -7.75, -7.75);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
		}

		cameraRot.Yaw = currentHeading;
		cameraRot.Pitch = currentPitch;
		
		this.TeleportWithRotation(cameraPos, cameraRot);
	}	

	var originalCamPos : Vector;
	var originalCamRot : EulerAngles;

	public function GoBack()
	{
		var rr : EulerAngles;
		var pos : Vector;
		var rot, currentRot : EulerAngles;
		
		rr = this.GetWorldRotation();
		rr.Pitch = 0;
		rr.Roll = 0;

		originalCamPos = thePlayer.GetWorldPosition();
		originalCamPos += VecConeRand(thePlayer.GetHeading(), 0.01, -3, -3);
		originalCamPos.Z += 2;
		originalCamRot = thePlayer.GetWorldRotation();
		originalCamRot.Pitch -= 15;
		
		RemoveTimer('Tick');
		
		this.Stop();
		this.Destroy();			
	
		this.TeleportWithRotation(pos,rot);	
	}
}

statemachine class ACSFocusModeCamera extends CStaticCamera
{
	var targetPos : Vector;
	var targetRot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetFocusModeCamera(this);
		
		cameraPos = theCamera.GetCameraPosition();
		cameraRot = theCamera.GetCameraRotation();
		
		currentHeading = cameraRot.Yaw;		
		
		Start();
	}

	function Start()	
	{	
		this.deactivationDuration = 1;
		this.activationDuration = 1;
		this.fadeStartDuration = 1;
		this.fadeEndDuration = 1;
		this.Run();
		this.TeleportWithRotation(cameraPos,cameraRot);
		

		//targetPos = thePlayer.GetWorldPosition();
		//targetPos.Z += 1.75;

		//targetPos += VecConeRand(currentHeading, 0, -3.5, -3.5);

		//targetRot = thePlayer.GetWorldRotation();

		targetPos = cameraPos;

		targetRot = cameraRot;
		
		
		AddTimer('IntoTick',0.0016,true);
	}
	
	timer function IntoTick( deltaTime : float , id : int)	{		
		var pos : Vector;
		var rot, currentRot : EulerAngles;
	
		currentRot = this.GetWorldRotation();
		pos = VecInterpolate(this.GetWorldPosition(), targetPos, 0.07);
		rot.Pitch = AngleApproach( targetRot.Pitch, currentRot.Pitch, 1 );
		rot.Roll = AngleApproach( targetRot.Roll, currentRot.Roll, 1 );
		rot.Yaw = AngleApproach( targetRot.Yaw, currentRot.Yaw, 1 );
		
		
		
		if(VecDistance(pos, targetPos) < 0.01 )
		{
			AddTimer('Tick',0.0000000016,true);
			RemoveTimer('IntoTick');
		}
	
		this.TeleportWithRotation(pos,rot);	
	}
	
	public function getHeading() : float
	{
		return this.currentHeading;
	}
	
	public function getPitch() : float
	{
		return this.currentPitch;
	}
	
	var currentHeading : float;
	var currentPitch : float;
	var maxPitch : float; default maxPitch = 50;
	
	var cameraPos, vampPos : Vector;
	var cameraRot : EulerAngles;

	timer function Tick( deltaTime : float , id : int)	{	
		
		vampPos = thePlayer.GetWorldPosition();
		vampPos.Z += 1.75;

		if ( theInput.LastUsedPCInput() )
		{
			if(theInput.GetActionValue( 'GI_MouseDampX' )!=0)
			{
				currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' ) * -1,0.01f,0.1f);
			} 

			if(theInput.GetActionValue( 'GI_MouseDampY' )!=0)
			{
				currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' ) * -1,0.01f,0.1f);
				
				if(AbsF(currentPitch) > maxPitch )
				{
					currentPitch = maxPitch * SignF(currentPitch);
				}
			}
		}
		else
		{
			if(theInput.GetActionValue( 'GI_MouseDampX' )( 'GI_AxisRightX' )!=0)
			{
				currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_MouseDampX' )( 'GI_AxisRightX' ) * -1,0.09f,3.5f);
			}

			if(theInput.GetActionValue( 'GI_MouseDampY' )( 'GI_AxisRightY' )!=0)
			{
				currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_MouseDampY' )( 'GI_AxisRightY' ) * 1,0.09f,1.5f);

				if(AbsF(currentPitch) > maxPitch )
				{
					currentPitch = maxPitch * SignF(currentPitch);
				}
			}
		}

		cameraPos = vampPos + VecConeRand(currentHeading, 0, -3.5, -3.5);

		cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/100, LerpF(AbsF(currentPitch)  , 0 , 3.0)/100);
		cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/40;

		cameraRot.Yaw = currentHeading;
		cameraRot.Pitch = currentPitch;
		
		this.TeleportWithRotation(cameraPos, cameraRot);
	}	
	
	var originalCamPos : Vector;
	var originalCamRot : EulerAngles;
	
	public function GoBack()
	{
		var rr : EulerAngles;
		
		rr = this.GetWorldRotation();
		rr.Pitch = 0;
		rr.Roll = 0;
	
		originalCamPos = thePlayer.GetWorldPosition();
		originalCamPos += VecConeRand(thePlayer.GetHeading(), 0.01, -3, -3);
		originalCamPos.Z += 2;
		originalCamRot = thePlayer.GetWorldRotation();
		originalCamRot.Pitch -= 15;
		
		RemoveTimer('Tick');
		AddTimer('EndTick',0.006, true);		
	}

	timer function EndTick( deltaTime : float , id : int)	
	{	
		var pos : Vector;
		var rot, currentRot : EulerAngles;
	
		currentRot = this.GetWorldRotation();
		pos = VecInterpolate(this.GetWorldPosition(), originalCamPos, 0.07);
		rot.Pitch = AngleApproach( originalCamRot.Pitch, currentRot.Pitch, 1 );
		rot.Roll = AngleApproach( originalCamRot.Roll, currentRot.Roll, 1 );
		rot.Yaw = AngleApproach( originalCamRot.Yaw, currentRot.Yaw, 1 );
		
		if(VecDistance(pos, originalCamPos) < 0.01 )
		{
			this.Stop();
			AddTimer('DestroyDelay', 1, false);	
		}
	
		this.TeleportWithRotation(pos,rot);
	}

	timer function DestroyDelay( deltaTime : float , id : int)	
	{
		this.Destroy();
	}
}