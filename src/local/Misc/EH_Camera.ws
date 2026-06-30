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
		
		AddTimer('Tick',0.000000000001 / theGame.GetTimeScale(),true);
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
		
		AddTimer('Tick',0.000000000001 / theGame.GetTimeScale(),true);
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
			if(theInput.GetActionValue( 'GI_AxisRightX' )!=0)
			{
				currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_AxisRightX' ) * -1,0.09f,3.5f);
			}

			if(theInput.GetActionValue( 'GI_AxisRightY' )!=0)
			{
				currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_AxisRightY' ) * 1,0.09f,1.5f);

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
		
		
		AddTimer('IntoTick',0.0016 / theGame.GetTimeScale(),true);
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
			AddTimer('Tick',0.0000000016 / theGame.GetTimeScale(),true);
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

	var attach_vec, bone_vec																										: Vector;
	var attach_rot, bone_rot																										: EulerAngles;

	var x_offset, y_offset, z_offset				: float;

	var vehicle										: CEntity;

	var boatLogic : CBoatComponent;

	var rudderDamper : float;

	default rudderDamper = 0.f;

	timer function Tick( deltaTime : float , id : int)	
	{	
		var turnFactor  : float;
		var velocityRatio : float;		
		var sailCameraOffset : float;
		
		var fovDistPitch : Vector;
		var offsetZ : float;
		var offsetUp : Vector;
		var sailOffset : float;
		var boatComponent: CBoatComponent;
		
		var boatPPC : CCustomCameraBoatPPC;
		var cameraToBoatDot : float;
		var turnFactorSum : float;
		
		var camera : CCustomCamera;
		var angleDist : float;

		vampPos = thePlayer.GetWorldPosition();

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

		if (thePlayer.IsUsingVehicle())
		{
			if ( thePlayer.ShouldEnableCombatMusic() )
			{
				theSound.LeaveGameState(ESGS_Boat);
			}
			else
			{
				theSound.EnterGameState(ESGS_Boat);	
			}
					

			vehicle = thePlayer.GetUsedVehicle();

			boatLogic = (CBoatComponent)vehicle.GetComponentByClassName('CBoatComponent');

			turnFactor	= theInput.GetActionValue( 'GI_AxisLeftX' );		
			
			turnFactorSum = AbsF( turnFactor + boatLogic.localSpaceCameraTurnPercent );		
			if( turnFactorSum > 1.0f )
			{
				turnFactorSum = AbsF( turnFactor * 2.0f + boatLogic.localSpaceCameraTurnPercent );
				turnFactor = ( turnFactor * 2.0f ) / turnFactorSum + boatLogic.localSpaceCameraTurnPercent / turnFactorSum;
			}
			else
			{
				turnFactor = turnFactor + boatLogic.localSpaceCameraTurnPercent;
			}	
			
			LogChannel('Boat', "Rudder turn factor: " + turnFactor );
			
			
			rudderDamper = rudderDamper + deltaTime * 6.f * ( turnFactor - rudderDamper );	
			LogChannel('Boat', "Rudder damper: " + rudderDamper );
			
			boatLogic.SetRudderDir( thePlayer, rudderDamper );

			if ( theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'EnableAlternateExplorationCamera') == "0" )
			{
				x_offset =ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_custom_camera_positioning_vehicle_camera_default_x', 0);

				y_offset = -6.5 + ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_custom_camera_positioning_vehicle_camera_default_y', 0);

				z_offset = 2 + ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_custom_camera_positioning_vehicle_camera_default_z', 0);
			}
			else if ( theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'EnableAlternateExplorationCamera') == "1" )
			{
				x_offset = ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_custom_camera_positioning_vehicle_camera_close_x', 0);

				y_offset = -6.5 + ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_custom_camera_positioning_vehicle_camera_close_y', 0);

				z_offset = 2 + ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_custom_camera_positioning_vehicle_camera_close_z', 0);
			}

			if (vehicle.HasTag('ACS_Player_Merchant_Ship') || vehicle.HasTag('ACS_Player_Ghost_Ship'))
			{
				if (!theGame.IsFocusModeActive())
				{
					y_offset -= 30;

					z_offset += 10;
				}
				
			}

			if (cameraHeight < z_offset)
			{
				cameraHeight += 0.0625;
			}

			if (cameraHeight > z_offset)
			{
				cameraHeight -= 0.0625;
			}

			vampPos.Z += cameraHeight;

			if (cameraDistance < y_offset)
			{
				cameraDistance += 0.0625;
			}
			else if (cameraDistance > y_offset)
			{
				cameraDistance -= 0.0625;
			}
			else
			{
				cameraDistance = y_offset;
			}

			if (x_offset != 0)
			{
				vampPos + thePlayer.GetWorldRight() * x_offset;
			}

			cameraPos = vampPos + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

			cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
			cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/40;
		}
		else
		{

			if ( thePlayer.HasTag('ACS_In_Umbral_Slash_End') 
			)
			{
				if (cameraHeight < 4.75)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 4.75)
				{
					cameraHeight -= 0.0625;
				}
			}
			else if ( thePlayer.HasTag('ACS_GrappleMovingPlayer') 
			)
			{
				if (cameraHeight < 1.25)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 1.25)
				{
					cameraHeight -= 0.0625;
				}
			}
			else if ( thePlayer.HasTag('ACS_In_Dance_Of_Wrath') 
			|| thePlayer.HasTag('ACS_In_Ciri_Special_Attack')  
			|| FactsQuerySum("ACS_Mounted_Attack_Attachment_Active") > 0
			)
			{
				if (cameraHeight < 2)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight >2)
				{
					cameraHeight -= 0.0625;
				}
			}
			else if (thePlayer.HasTag('ACS_Aiming_Bow')
			)
			{
				if (cameraHeight < 1.5)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 1.5)
				{
					cameraHeight -= 0.0625;
				}
			}
			else if (FactsQuerySum("ACS_Mounted_Attack_Attachment_Active") > 0)
			{
				if (thePlayer.HasTag('ACS_MountedAttackDismountProcessStart')
				)
				{
					if (cameraHeight < 1)
					{
						cameraHeight += 0.0625;
					}

					else if (cameraHeight > 1)
					{
						cameraHeight -= 0.0625;
					}

					else
					{
						cameraHeight = 1;
					}
				}
				else
				{
					if (cameraHeight < 1.5)
					{
						cameraHeight += 0.0625;
					}

					else if (cameraHeight > 1.5)
					{
						cameraHeight -= 0.0625;
					}

					else
					{
						cameraHeight = 1.5;
					}
				}
			}
			else if (FactsQuerySum("ACS_Azkar_Active") > 0
			)
			{
				if (cameraHeight < 1.5)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 1.5)
				{
					cameraHeight -= 0.0625;
				}
			}
			else if (ACSGetCEntity('ACS_Wings_Entity')
			)
			{
				if (cameraHeight < 2)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 2)
				{
					cameraHeight -= 0.0625;
				}
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped')
			)
			{
				if (cameraHeight < 1.5)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 1.5)
				{
					cameraHeight -= 0.0625;
				}
			}
			else if (FactsQuerySum("acs_fp_emabled") > 0
			)
			{
				if (cameraHeight < 1.5)
				{
					cameraHeight += 0.0625;
				}

				if (cameraHeight > 1.5)
				{
					cameraHeight -= 0.0625;
				}
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
			}

			vampPos.Z += cameraHeight;

			if ( thePlayer.HasTag('ACS_In_Umbral_Slash_End') 
			|| thePlayer.HasTag('ACS_In_Dance_Of_Wrath')  
			|| thePlayer.HasTag('ACS_In_Ciri_Special_Attack')
			)
			{
				if (cameraDistance < -12.5)
				{
					cameraDistance += 0.0625;
				}
				else if (cameraDistance > -12.5)
				{
					cameraDistance -= 0.0625;
				}
				else
				{
					cameraDistance = -12.5;
				}

				cameraPos = vampPos + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

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
				if (cameraDistance < -3.5)
				{
					cameraDistance += 0.0625;
				}
				else if (cameraDistance > -3.5)
				{
					cameraDistance -= 0.0625;
				}
				else
				{
					cameraDistance = -3.5;
				}

				cameraPos = vampPos + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/100, LerpF(AbsF(currentPitch)  , 0 , 3.0)/100);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/80;
			}
			else if (ACSGetCEntity('ACS_Wings_Entity')
			)
			{
				if (cameraDistance < -6.5)
				{
					cameraDistance += 0.0625;
				}
				else if (cameraDistance > -6.5)
				{
					cameraDistance -= 0.0625;
				}
				else
				{
					cameraDistance = -6.5;
				}

				cameraPos = vampPos + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/25, LerpF(AbsF(currentPitch)  , 0 , 3.0)/25);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/20;
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped')
			)
			{
				if (thePlayer.HasTag('ACS_IsPerformingFinisher')
				|| thePlayer.HasTag('ACS_IsPerformingCombatDismember')
				)
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
			else if (FactsQuerySum("ACS_FP_Enabled") > 0
			)
			{
				thePlayer.GetBoneWorldPositionAndRotationByIndex( thePlayer.GetBoneIndex( 'head' ), bone_vec, bone_rot );

				bone_vec.Z += 0.1;


				if (thePlayer.GetIsSprinting() 
				|| thePlayer.GetIsRunning() 
				)
				{
					if (cameraDistance < 0.15)
					{
						cameraDistance += 0.01;
					}
					else if (cameraDistance > 0.15)
					{
						cameraDistance -= 0.01;
					}
					else
					{
						cameraDistance = 0.15;
					}
				}
				else
				{
					if (thePlayer.GetIsWalking())
					{
						if (cameraDistance < 0.05)
						{
							cameraDistance += 0.01;
						}
						else if (cameraDistance > 0.05)
						{
							cameraDistance -= 0.01;
						}
						else
						{
							cameraDistance = 0.05;
						}
					}
				}

				cameraPos = bone_vec + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/1000, LerpF(AbsF(currentPitch)  , 0 , 3.0)/1000);
				cameraPos.Z = bone_vec.Z + LerpF(currentPitch  , 1.0 , -1.0)/1000;
			}
			else if (FactsQuerySum("ACS_Mounted_Attack_Attachment_Active") > 0)
			{
				if (thePlayer.HasTag('ACS_MountedAttackDismountProcessStart')
				)
				{
					if (cameraDistance < -4.5)
					{
						cameraDistance += 0.0625;
					}
					else if (cameraDistance > -4.5)
					{
						cameraDistance -= 0.0625;
					}
					else
					{
						cameraDistance = -4.5;
					}
				}
				else
				{
					if (cameraDistance < -6.5)
					{
						cameraDistance += 0.0625;
					}
					else if (cameraDistance > -6.5)
					{
						cameraDistance -= 0.0625;
					}
					else
					{
						cameraDistance = -6.5;
					}
				}

				cameraPos = vampPos + thePlayer.GetWorldForward() * 1.5 + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/40;
			}
			else
			{
				if (cameraDistance < -8.5)
				{
					cameraDistance += 0.0625;
				}
				else if (cameraDistance > -8.5)
				{
					cameraDistance -= 0.0625;
				}
				else
				{
					cameraDistance = -8.5;
				}

				cameraPos = vampPos + VecConeRand(currentHeading, 0, cameraDistance, cameraDistance);

				cameraPos = cameraPos + VecConeRand(currentHeading, 0, LerpF( AbsF(currentPitch)  , 0 , 3.0)/50, LerpF(AbsF(currentPitch)  , 0 , 3.0)/50);
				cameraPos.Z = vampPos.Z + LerpF(currentPitch  , 1.0 , -1.0)/40;
			}
		}

		cameraRot.Yaw = currentHeading;

		cameraRot.Pitch = currentPitch;
		
		this.TeleportWithRotation(cameraPos, cameraRot);
	}	
}

statemachine class ACSFreeCamera extends CStaticCamera
{
	var targetPos : Vector;
	var targetRot : EulerAngles;

	var ent		: CEntity;

	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		ACSGetCEntity('ACS_Freecam_Player').Destroy();

		GetACSWatcher().SetFreeCamera(this);
		
		cameraPos = theCamera.GetCameraPosition();
		cameraRot = theCamera.GetCameraRotation();
		
		currentHeading = cameraRot.Yaw;		

		this.deactivationDuration = 1;
		this.activationDuration = 1;
		this.fadeStartDuration = 1;
		this.fadeEndDuration = 1;

		this.Run();

		this.TeleportWithRotation(cameraPos,cameraRot);

		targetPos = cameraPos;

		targetPos.Z += 0.5;
		targetPos += VecConeRand(currentHeading, 0, -4.5, -4.5);

		targetRot = cameraRot;

		
		AddTimer('Tick',0.000000000001 / theGame.GetTimeScale(),true);
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

		vampPos = this.GetWorldPosition();

		vampPos += 0.5*VecConeRand(getHeading(), 0.001,theInput.GetActionValue('GI_AxisLeftY')*0.25, theInput.GetActionValue('GI_AxisLeftY')*0.25);	
	
		vampPos -= 0.5*VecConeRand(getHeading()+90, 5, theInput.GetActionValue('GI_AxisLeftX') * 0.25 , theInput.GetActionValue('GI_AxisLeftX') * 0.25 );	

		if (thePlayer.IsInCombat())
		{
			if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Has_Abduction_Victim'))
			{
				vampPos.Z += 0.5*(theInput.GetActionValue('Dodge'))*(0.125);

				vampPos.Z += 0.5*(theInput.GetActionValue('CbtRoll'))*(0.125);
			}
			else
			{
				vampPos.Z += 0.5*(theInput.GetActionValue('Dodge'))*(0.25);

				vampPos.Z += 0.5*(theInput.GetActionValue('CbtRoll'))*(0.25);
			}
		}
		else
		{
			if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Has_Abduction_Victim'))
			{
				vampPos.Z += 0.5*(theInput.GetActionValue('Jump'))*(0.125);
			}
			else
			{
				vampPos.Z += 0.5*(theInput.GetActionValue('Jump'))*(0.25);
			}
		}

		vampPos.Z -= 0.5*theInput.GetActionValue('SwordSheathe')*(0.25);
		
	
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
			if(theInput.GetActionValue( 'GI_AxisRightX' )!=0)
			{
				currentHeading = currentHeading + LerpF(theInput.GetActionValue( 'GI_AxisRightX' ) * -1,0.09f,3.5f);
			}

			if(theInput.GetActionValue( 'GI_AxisRightY' )!=0)
			{
				currentPitch = currentPitch + LerpF(theInput.GetActionValue( 'GI_AxisRightY' ) * 1,0.09f,1.5f);

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


		if (theGame.IsFocusModeActive() || theInput.GetActionValue('Focus') > 0.1f)
		{
			thePlayer.BlockAction( EIAB_Movement, 			'ACS_Free_Cam_Movement');
		}
		else
		{
			thePlayer.UnblockAction( EIAB_Movement,			'ACS_Free_Cam_Movement');
		}

		this.TeleportWithRotation(vampPos, cameraRot);

			
	}	
}

statemachine class ACSFastTravelCamera extends CStaticCamera
{
	var cameraPos, pos : Vector;
	var cameraRot : EulerAngles;
	var cameraSwitch : bool;

	var storedHoursPerMinute 					: float;	

	var fastForward 		: CGameFastForwardSystem;

	event OnSpawned( spawnData : SEntitySpawnData )	
	{
		GetACSWatcher().SetFastTravelCamera(this);

		pos = GetWorldPosition();

		
		cameraPos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * -50;

		cameraPos.Z += 500;

		cameraRot.Yaw = 0;
		cameraRot.Roll = 0;
		cameraRot.Pitch = -90;

		this.deactivationDuration = ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5);
		this.activationDuration = ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5);
		this.fadeStartDuration = ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5);
		this.fadeEndDuration = ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5);

		this.Run();

		fastForward = theGame.GetFastForwardSystem();
		fastForward.BeginFastForward(true, false);

		storedHoursPerMinute = theGame.GetHoursPerMinute();

		theGame.SetHoursPerMinute( storedHoursPerMinute * 90 );


		AddTimer('TickStart',0.1,false);

		
	}

	timer function TickStart( deltaTime : float , id : int)	
	{
		AddTimer('Tick',0.000000000001,true);

		if (GetACSWatcher().fast_travel_is_local)
		{
			AddTimer('TickDelay',ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5) * 0.375,false);
		}
		else
		{
			GetACSWatcher().Custom_Env_Switch('global_fast_travel', true);
			AddTimer('TickDelay',ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5) * 0.75,false);
		}
	}
	
	timer function TickDelay( deltaTime : float , id : int)	
	{
		if (GetACSWatcher().fast_travel_is_local)
		{
			cameraPos = ACSGetCEntity('ACS_Fast_Travel_Marker').GetWorldPosition();

			cameraPos.Z += 500;

			cameraSwitch = true;
		}
		else
		{
			if (FactsQuerySum("ACS_Global_Fast_Travel_Initiated") <= 0)
			{
				FactsAdd("ACS_Global_Fast_Travel_Initiated", 1, -1);
			}

			if (GetACSWatcher().globalGetTravelPointPosition)
			{
				theGame.ScheduleWorldChangeToPosition( GetACSWatcher().globalFastTravelWorldPath, GetACSWatcher().globalFastTravelposition, GetACSWatcher().globalFastTravelrotation );
			}
			else
			{
				theGame.ScheduleWorldChangeToMapPin( GetACSWatcher().globalFastTravelWorldPath, GetACSWatcher().globalFastTravelPinName );
			}
		}
	}

	var progress : float;

	timer function Tick( deltaTime : float , id : int)	
	{	
		cameraRot.Yaw = 0;
		cameraRot.Roll = 0;
		cameraRot.Pitch = -90;

		if (!cameraSwitch)
		{
			this.TeleportWithRotation(cameraPos, cameraRot);	
		}
		else
		{
			pos = GetWorldPosition();

			if (pos != cameraPos)
			{
				if (
				RoundF(pos.X) == RoundF(cameraPos.X)
				&& RoundF(pos.Y) == RoundF(cameraPos.Y)
				)
				{
					this.TeleportWithRotation(cameraPos, cameraRot);	
				}
				else
				{
					this.TeleportWithRotation(LerpV(GetWorldPosition(), cameraPos, 0.005f + progress), cameraRot);	

					progress += 0.0001;
				}
			}
			else
			{
				theGame.FadeOutAsync( ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5) * 0.125f , Color(0,0,0) );
				RemoveTimer('CameraDestroyTimer');
				AddTimer('CameraDestroyTimer', ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5) * 0.125f, false);

				RemoveTimer('Tick');
			}
		}
	}	

	timer function CameraDestroyTimer( deltaTime : float , id : int)	
	{
		Stop();

		fastForward = theGame.GetFastForwardSystem();

		fastForward.AllowFastForwardSelfCompletion();

		theGame.SetHoursPerMinute( storedHoursPerMinute );

		theGame.GetGameCamera().EnableManualControl( true );

		thePlayer.TeleportWithRotation( ACSGetCEntity('ACS_Fast_Travel_Marker').GetWorldPosition(), ACSGetCEntity('ACS_Fast_Travel_Marker').GetWorldRotation() );

		theGame.FadeInAsync( ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5) );

		ACSGetCEntity('ACS_Fast_Travel_Marker').DestroyAfter(1);

		DestroyAfter(ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5) + 0.35f);

		RemoveTimer('HudRestoreTimer');
		AddTimer('HudRestoreTimer', ACS_Settings_Main_Float('acs_misc_main_settings','acs_fast_travel_camera_transition_speed', 5), false);
	}

	timer function HudRestoreTimer( deltaTime : float , id : int)	
	{
		var hud : CR4ScriptedHud;
		var inGameConfigWrapper	: CInGameConfigWrapper;
		var newValue : bool;

		hud = (CR4ScriptedHud)theGame.GetHud();

		inGameConfigWrapper = (CInGameConfigWrapper)theGame.GetInGameConfigWrapper();

		newValue = inGameConfigWrapper.GetVarValue( 'Hud', 'HudVisibility' );
	
		if ( hud && newValue )
		{
			hud.ForceShow( true, HVS_System );

			GetACSWatcher().Enable_Hud_Exception_Flag(true);
		}

	}
}