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
		cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/80;

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
			targetPos = ACSGetCActor('ACS_Transformation_Werewolf').GetWorldPosition();

			targetPos.Z += 1.75;
			targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

			targetRot = ACSGetCActor('ACS_Transformation_Werewolf').GetWorldRotation();
		}
		else if (
		FactsQuerySum("acs_vampireess_transformation_activated") > 0
		)
		{
			targetPos = ACSGetCActor('ACS_Transformation_Vampiress').GetWorldPosition();

			targetPos.Z += 1.5;
			targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

			targetRot = ACSGetCActor('ACS_Transformation_Vampiress').GetWorldRotation();
		}
		else if (
		FactsQuerySum("acs_vampire_monster_transformation_activated") > 0
		)
		{
			targetPos = ACSGetCActor('ACS_Transformation_Vampire_Monster').GetWorldPosition();

			targetPos.Z += 1.5;
			targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

			targetRot = ACSGetCActor('ACS_Transformation_Vampire_Monster').GetWorldRotation();
		}
		else if (
		FactsQuerySum("acs_toad_transformation_activated") > 0
		)
		{
			targetPos = ACSGetCActor('ACS_Transformation_Toad').GetWorldPosition();

			targetPos.Z += 2.25;
			targetPos += VecConeRand(currentHeading, 0, -7.75, -7.75);

			targetRot = ACSGetCActor('ACS_Transformation_Toad').GetWorldRotation();
		}
		else if (
		FactsQuerySum("acs_red_miasmal_curse_activated") > 0
		)
		{
			targetPos = ACSGetCActor('ACS_Transformation_Red_Miasmal').GetWorldPosition();

			targetPos.Z += 1.625;
			targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

			targetRot = ACSGetCActor('ACS_Transformation_Red_Miasmal').GetWorldRotation();
		}
		else if (
		FactsQuerySum("acs_sharley_curse_activated") > 0
		)
		{
			targetPos = ACSGetCActor('ACS_Transformation_Sharley').GetWorldPosition();

			targetPos.Z += 1.625;
			targetPos += VecConeRand(currentHeading, 0, -5.5, -5.5);

			targetRot = ACSGetCActor('ACS_Transformation_Sharley').GetWorldRotation();
		}
		else if (
		FactsQuerySum("acs_black_wolf_curse_activated") > 0
		)
		{
			targetPos = ACSGetCActor('ACS_Transformation_Black_Wolf').GetWorldPosition();

			targetPos.Z += 1.625;
			targetPos += VecConeRand(currentHeading, 0, -6.5, -6.5);

			targetRot = ACSGetCActor('ACS_Transformation_Black_Wolf').GetWorldRotation();
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

	var cameraHeight, cameraDistance : float;

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
			vampPos = ACSGetCActor('ACS_Transformation_Werewolf').GetWorldPosition();
			vampPos.Z += 1.75;
		}
		else if (
		FactsQuerySum("acs_vampireess_transformation_activated") > 0
		)
		{
			vampPos = ACSGetCActor('ACS_Transformation_Vampiress').GetWorldPosition();

			vampPos.Z += 1.5;
		}
		else if (
		FactsQuerySum("acs_vampire_monster_transformation_activated") > 0
		)
		{
			//vampPos = ACSGetCActor('ACS_Transformation_Vampire_Monster').GetWorldPosition();

			vampPos = ACSGetCEntity('ACS_Transformation_Vampire_Monster_Camera_Dummy').GetWorldPosition();

			if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Vampire_Monster_Flight_Mode'))
			{
				//vampPos.Z += 7;
				//vampPos.Z += 1;

				if (cameraHeight < 1)
				{
					cameraHeight += LerpF(0.25, 0, 0.125, true);
				}

				if (cameraHeight > 1)
				{
					cameraHeight -= LerpF(0.25, 0, 0.125, true);
				}

				vampPos.Z += cameraHeight;
			}
			else if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Vampire_Monster_Ground_Mode'))
			{
				//vampPos.Z += 1.75;

				//vampPos.Z += 0.01;

				if (cameraHeight < 0)
				{
					cameraHeight += LerpF(0.25, 0, 0.125, true);
				}

				if (cameraHeight > 0)
				{
					cameraHeight -= LerpF(0.25, 0, 0.125, true);
				}

				vampPos.Z += cameraHeight;
			}
		}
		else if (
		FactsQuerySum("acs_toad_transformation_activated") > 0
		)
		{
			vampPos = ACSGetCActor('ACS_Transformation_Toad').GetWorldPosition();
			vampPos.Z += 2.25;
		}
		else if (
		FactsQuerySum("acs_red_miasmal_curse_activated") > 0
		)
		{
			vampPos = ACSGetCActor('ACS_Transformation_Red_Miasmal').GetWorldPosition();
			vampPos.Z += 1.625;
		}
		else if (
		FactsQuerySum("acs_sharley_curse_activated") > 0
		)
		{
			vampPos = ACSGetCActor('ACS_Transformation_Sharley').GetWorldPosition();
			vampPos.Z += 1.625;
		}
		else if (
		FactsQuerySum("acs_black_wolf_curse_activated") > 0
		)
		{
			vampPos = ACSGetCActor('ACS_Transformation_Black_Wolf').GetWorldPosition();

			vampPos.Z += 1.625;
		}
		else if (
		FactsQuerySum("acs_giant_curse_activated") > 0
		)
		{
			vampPos = ACSGetCActor('ACS_Transformation_Giant').GetWorldPosition();

			vampPos.Z += 3;

			if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
			{
				if (cameraHeight < 1.5)
				{
					cameraHeight += 0.03125;
				}

				if (cameraHeight > 1.5)
				{
					cameraHeight -= 0.03125;
				}

				vampPos.Z += cameraHeight;
			}
			else
			{
				if (cameraHeight < 0)
				{
					cameraHeight += 0.03125;
				}

				if (cameraHeight > 0)
				{
					cameraHeight -= 0.03125;
				}

				vampPos.Z += cameraHeight;
			}
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
			if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Vampire_Monster_Flight_Mode'))
			{
				if (cameraDistance < -7.75)
				{
					cameraDistance += 0.125;
				}
				else if (cameraDistance > -7.75)
				{
					cameraDistance -= 0.125;
				}
				else
				{
					cameraDistance = -7.75;
				}

				cameraPos = vampPos + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
			}
			else if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Vampire_Monster_Ground_Mode'))
			{
				if (cameraDistance < -4.5)
				{
					cameraDistance += 0.125;
				}
				else if (cameraDistance > -4.5)
				{
					cameraDistance -= 0.125;
				}
				else
				{
					cameraDistance = -4.5;
				}

				cameraPos = vampPos + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
			}
		}
		else if (
		FactsQuerySum("acs_toad_transformation_activated") > 0
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -7.75, -7.75);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
		}
		else if (
		FactsQuerySum("acs_red_miasmal_curse_activated") > 0
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -4.5, -4.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
		}
		else if (
		FactsQuerySum("acs_sharley_curse_activated") > 0
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -5.5, -5.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;
		}
		else if (
		FactsQuerySum("acs_black_wolf_curse_activated") > 0
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -6.5, -6.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/60;
		}
		else if (
		FactsQuerySum("acs_giant_curse_activated") > 0
		)
		{
			if (ACSGetCActor('ACS_Transformation_Giant').HasTag('ACS_Transformation_Giant_Weapon_Mode'))
			{
				if (cameraDistance < -12)
				{
					cameraDistance += 0.125;
				}
				else if (cameraDistance > -12)
				{
					cameraDistance -= 0.125;
				}
				else
				{
					cameraDistance = -12;
				}
			}
			else
			{
				if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
				{
					if (cameraDistance < -10)
					{
						cameraDistance += 0.125;
					}
					else if (cameraDistance > -9)
					{
						cameraDistance -= 0.125;
					}
					else
					{
						cameraDistance = -10;
					}
				}
				else
				{
					if (cameraDistance < -8)
					{
						cameraDistance += 0.125;
					}
					else if (cameraDistance > -8)
					{
						cameraDistance -= 0.125;
					}
					else
					{
						cameraDistance = -8;
					}
				}
			}
			

			cameraPos = vampPos + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

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

statemachine class ACSKestralCamera extends CStaticCamera
{
	var targetPos : Vector;
	var targetRot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetKestralCamera(this);
		
		cameraPos = theCamera.GetCameraPosition();
		cameraRot = theCamera.GetCameraRotation();
		
		currentHeading = cameraRot.Yaw;		
		
		this.deactivationDuration = 1;
		this.activationDuration = 1;
		this.fadeStartDuration = 1;
		this.fadeEndDuration = 1;
		this.Run();
		this.TeleportWithRotation(cameraPos,cameraRot);

		targetPos = ACSKestralSkull().GetWorldPosition();

		targetPos.Z += 0.5;
		targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

		targetRot = ACSKestralSkull().GetWorldRotation();
		
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

		vampPos = ACSKestralSkull().GetWorldPosition();
		vampPos.Z += 0.5;

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

		cameraPos = vampPos + VecConeRand(currentHeading, 0, -4.5, -4.5);

		cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/75, LerpF(AbsF(currentPitch)  , 0 , 3.0)/75);
		cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/30;

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
		cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/80;

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

statemachine class ACSPlayerCamera extends CStaticCamera
{
	var targetPos : Vector;
	var targetRot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetPlayerCamera(this);
		
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

	var cameraHeight, cameraDistance : float;

	timer function Tick( deltaTime : float , id : int)	{	
		
		vampPos = thePlayer.GetWorldPosition();

		if ( thePlayer.HasTag('ACS_In_Umbral_Slash_End') 
		)
		{
			vampPos.Z += 4.75;
		}
		else if ( thePlayer.HasTag('ACS_GrappleMovingPlayer') 
		)
		{
			vampPos.Z += 1.25;
		}
		else if ( thePlayer.HasTag('ACS_In_Dance_Of_Wrath') 
		|| thePlayer.HasTag('ACS_In_Ciri_Special_Attack')  
		)
		{
			vampPos.Z += 2;
		}
		else if (thePlayer.HasTag('ACS_Ghost_Stance_Active')
		|| thePlayer.HasTag('ACS_Aiming_Bow')
		)
		{
			vampPos.Z += 1.5;
		}
		else if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (FactsQuerySum("ACS_Azkar_Aiming") > 0)
			{
				if (cameraHeight < 1.5)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 1.5)
				{
					cameraHeight -= 0.0625;
				}

				vampPos.Z += cameraHeight;
			}
			else 
			{
				if (cameraHeight < 1.5)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 1.5)
				{
					cameraHeight -= 0.0625;
				}

				vampPos.Z += cameraHeight;
			}
		}
		else if (ACSGetCEntity('ACS_Wings_Entity')
		)
		{
			vampPos.Z += 2;
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped')
		)
		{
			vampPos.Z += 1.5;
		}
		else
		{
			vampPos.Z += 1.5;
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

		if ( thePlayer.HasTag('ACS_In_Umbral_Slash_End') 
		|| thePlayer.HasTag('ACS_In_Dance_Of_Wrath')  
		|| thePlayer.HasTag('ACS_In_Ciri_Special_Attack')
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -12.5, -12.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/100, LerpF(AbsF(currentPitch)  , 0 , 3.0)/100);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/80;
		}
		else if (thePlayer.HasTag('ACS_Ghost_Stance_Active')
		)
		{
			cameraPos = vampPos + thePlayer.GetWorldRight() * 0.5 + VecConeRand(currentHeading, 0, -1.5, -1.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/100, LerpF(AbsF(currentPitch)  , 0 , 3.0)/100);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/80;
		}
		else if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (FactsQuerySum("ACS_Azkar_Aiming") > 0)
			{
				if (cameraDistance < -1)
				{
					cameraDistance += 0.0625;
				}
				else if (cameraDistance > -1)
				{
					cameraDistance -= 0.0625;
				}
				else
				{
					cameraDistance = -1;
				}

				cameraPos = vampPos + thePlayer.GetWorldRight() * 1 + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/100, LerpF(AbsF(currentPitch)  , 0 , 3.0)/100);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/80;
			}
			else
			{
				if (cameraDistance < -2.5)
				{
					cameraDistance += 0.0625;
				}
				else if (cameraDistance > -2.5)
				{
					cameraDistance -= 0.0625;
				}
				else
				{
					cameraDistance = -2.5;
				}

				cameraPos = vampPos + thePlayer.GetWorldRight() * 0.5 + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/100, LerpF(AbsF(currentPitch)  , 0 , 3.0)/100);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/80;
			}
		}
		else if ( thePlayer.HasTag('ACS_GrappleMovingPlayer') 
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -3.5, -3.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/100, LerpF(AbsF(currentPitch)  , 0 , 3.0)/100);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/80;
		}
		else if (ACSGetCEntity('ACS_Wings_Entity')
		)
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -6.5, -6.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/25, LerpF(AbsF(currentPitch)  , 0 , 3.0)/25);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/20;
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped')
		)
		{
			if (thePlayer.HasTag('ACS_IsPerformingFinisher'))
			{
				if (cameraDistance < -3)
				{
					cameraDistance += 0.0625;
				}
				else if (cameraDistance > -3)
				{
					cameraDistance -= 0.0625;
				}
				else
				{
					cameraDistance = -3;
				}

				cameraPos = vampPos + thePlayer.GetWorldRight() * 1 + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/40;
			}
			else
			{
				if (cameraDistance < -7.5)
				{
					cameraDistance += 0.0625;
				}
				else if (cameraDistance > -7.5)
				{
					cameraDistance -= 0.0625;
				}
				else
				{
					cameraDistance = -7.5;
				}

				cameraPos = vampPos + thePlayer.GetWorldRight() * 0.5 + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/40;
			}
		}
		else
		{
			cameraPos = vampPos + VecConeRand(currentHeading, 0, -8.5, -8.5);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/40;
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