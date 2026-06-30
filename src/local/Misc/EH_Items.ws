class W3ACSWisp extends W3QuestUsableItem 
{
    private var wispCurrentRotationCircleAngle 								: float; 
    private var wispCurrentRotation 												: EulerAngles; 
    private var wispCurrentPosition 													: Vector;
    private var wispCurrentVelocity 													: Vector;
    private var wispCurrentAcceleration 											: Vector;
	
	private var wispGoalPosition 														: Vector;
    private var wispGoalPositionOffset 												: Vector;
    private var wispGoalPositionOffset_regenerateInSeconds 				: float;
   
    private var entity                          											:  CEntity;
    private var entityTemplate                  										:  CEntityTemplate;
    private var resourcePath                   											:  string;
    
    private var active 																		: bool;
   
    event OnUsed(usedBy : CEntity) 
	{
		var item 											: array<CEntity>;
		var i												: int;

		super.OnUsed(usedBy);

		resourcePath = "dlc\dlc_acs\data\entities\items\acs_wisp.w2ent";
 
        entityTemplate = (CEntityTemplate)LoadResource(resourcePath,true);

		if(usedBy == GetWitcherPlayer()) 
		{
			
			if (FactsQuerySum("ACS_Wisp_Released") <= 0)
			{
				ACSWisp().Destroy();

				GetACSWatcher().AddTimer('ACS_Wisp_Tutorial_Delay', 0.5 , false);

				item.Clear();

				theGame.GetEntitiesByTag( 'ACS_Wisp' , item );	
				
				for( i = 0; i < item.Size(); i += 1 )
				{
					item[i].Destroy();
				}

				entity = (W3ACSWisp)theGame.CreateEntity(entityTemplate, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

				((CActor)entity).EnableCollisions(false);
				((CActor)entity).EnableCharacterCollisions(false);

				entity.AddTag('ACS_Wisp');

				entity.PlayEffectSingle('wisp_fx');
				
				//entity.PlayEffectSingle('502_barrier_hold');

				FactsAdd("ACS_Wisp_Released", 1, -1);
			}
			else if (FactsQuerySum("ACS_Wisp_Released") > 0)
			{
				this.RemoveTimer('FollowPlayer');

				this.RemoveTimer('GatlingGunTimer');

				this.StopAllEffects();

				ACSWisp().Destroy();

				ACSGetCEntityDestroyAll('ACS_Wisp');

				FactsRemove("ACS_Wisp_Released");
			}
		}
    }
	
	event OnDestroyed() 
	{	
		RemoveTimers();
	}
	
	event OnSpawned(spawnData : SEntitySpawnData) 
	{
		var bonePos															: Vector;
		var temp 															: CEntityTemplate;
		var ent																: CEntity;

		//get position of left hand (boneindex for l_hand is 24)

		bonePos = MatrixGetTranslation(thePlayer.GetBoneWorldMatrixByIndex(24));

		this.AddTimer('FollowPlayer', 0.0001 , true);

		//this.AddTimer('DisplayTutorial', 10 , true);

		wispCurrentPosition = bonePos + Vector(0,0,0.1);

        wispCurrentVelocity = Vector(3,0,0);

		wispCurrentAcceleration = Vector(0,0,0);

	}

	var vACS_Wisp_Gatling_Gun : cACS_Wisp_Gatling_Gun;

    timer function FollowPlayer(deltaTime : float, id : int) 
	{
		var target : CEntity;
		var targetPosition : Vector;
		var targetRotation : EulerAngles;
		
                       
        var playerPosition : Vector;
        var playerRotation : EulerAngles;      
        
        var goalAcceleration : Vector;
        var navigationComputeZReturn : float;  
 
        // DEFAULT CONFIG start //
 
        var rotationCircleRadius : float;
        var rotationCircleMovementSpeed : float;
        var selfRotationSpeed : float;
        var maxAcceleration : float;      
        var accelerationMultiplier : float;
        var maxVelocity : float;
        var velocityDampeningFactor : float;

		var lookatents										: array<CGameplayEntity>;
		var i, j											: int;

		var gameLightComp, gameInteractComp 				: CComponent;

		var pos, lookatentsPos								 : Vector;
 
        rotationCircleMovementSpeed = 50;
        rotationCircleRadius = 1;
        selfRotationSpeed = 2.2;
        maxAcceleration = 200;
        accelerationMultiplier = 50;
        maxVelocity = 100;
        velocityDampeningFactor = 0.9;

		vACS_Wisp_Gatling_Gun = new cACS_Wisp_Gatling_Gun in this;

		if (FactsQuerySum("ACS_Wisp_Attack_Enable") > 0
		&& thePlayer.IsInCombat())
		{
			if (ACS_wisp_projectile_spawn())
			{
				ACS_refresh_wisp_projectile_cooldown();

				vACS_Wisp_Gatling_Gun.Wisp_Gatling_Gun_Engage();
			}
		}
 
        // DEFAULT CONFIG end //
		
		
		// Player is in Interior (buildings, caves etc.)
		// INTERIOR CONFIG start //
		if(thePlayer.IsInInterior()) 
		{
			rotationCircleMovementSpeed = 50;
			rotationCircleRadius = 0.5;
			selfRotationSpeed = 0.6;
			maxAcceleration = 100;
			accelerationMultiplier = 20;
			maxVelocity = 20;
			velocityDampeningFactor = 0.9;
		
		}
		// INTERIOR CONFIG end //
       
        // increase current angle in the circle around player
        wispCurrentRotationCircleAngle += deltaTime * rotationCircleMovementSpeed;
 
        // if rotation increased over 360 degrees make sure its under 360
        while(wispCurrentRotationCircleAngle > 360) 
		{          
            wispCurrentRotationCircleAngle -= 360;                        
        }

		pos = thePlayer.GetWorldPosition();
		pos.Z += 0.8;
       
	   // get current target
	   if (thePlayer.IsInCombat())
	   {
		 target = thePlayer.moveTarget;
	   }
	   else 
	   {
			if (ACSGetCEntity('ACS_Guiding_Light_Navigation_Guide'))
			{
				target = ACSGetCEntity('ACS_Guiding_Light_Navigation_Guide');
			}	
			else
			{
				lookatents.Clear();

				//FindGameplayEntitiesInRange(lookatents, thePlayer, 25, 1, ,FLAG_ExcludePlayer, ,);

				FindGameplayEntitiesInCone( lookatents, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection(), VecHeading( theCamera.GetCameraDirection() ), 120, 120, 1, , FLAG_ExcludePlayer );

				for(i = 0; i < lookatents.Size(); i += 1)
				{
					if 
					( 
					lookatents[i] == GetWitcherPlayer() 
					|| lookatents[i] == GetACSWatcher()
					|| lookatents[i] == theCamera
					)
					{
						continue;
					}

					for( j = lookatents.Size()-1; j >= 0; j -= 1 ) 
					{	
						lookatentsPos = lookatents[j].GetWorldPosition();
						
						if ( AbsF( lookatentsPos.Z - pos.Z ) > 2.5 )
						{
							lookatents.EraseFast(j);
						}

						if (lookatents.Size() > 0)
						{
							if ( lookatents[j] = thePlayer.GetDisplayTarget())
							{
								target = thePlayer.GetDisplayTarget();
							}
							else
							{
								gameLightComp = lookatents[j].GetComponentByClassName('CGameplayLightComponent');

								gameInteractComp = lookatents[j].GetComponentByClassName('CInteractionComponent');

								if(
								(CNewNPC)lookatents[j]
								|| (COilBarrelEntity)lookatents[j]
								|| gameLightComp
								|| gameInteractComp
								|| (W3AnimationInteractionEntity)lookatents[j]
								|| (CInteractiveEntity)lookatents[j]
								|| (W3NoticeBoard)lookatents[j]
								|| (W3FastTravelEntity)lookatents[j]
								|| (W3SmartObject)lookatents[j]
								|| (W3ItemRepairObject)lookatents[j]
								|| (W3AlchemyTable)lookatents[j]
								|| (W3Stables)lookatents[j]
								|| (W3LockableEntity)lookatents[j] 
								|| (W3Poster)lookatents[j]
								|| (W3LadderInteraction)lookatents[j]
								)
								{
									target = lookatents[j];
								}
							}
						}
					}	
				}
			}
	   }

	   //get current player position
		if (thePlayer.IsInInterior())
		{
			playerPosition = thePlayer.GetWorldPosition();
			targetPosition = target.GetWorldPosition();
		}
		else
		{
			playerPosition = TraceFloor(thePlayer.GetWorldPosition());
			targetPosition = TraceFloor(target.GetWorldPosition());
		}
		
		//get current player rotation
		playerRotation = thePlayer.GetWorldRotation();

		targetRotation = target.GetWorldRotation();
       
        // calculate wisp Goal position
		

		// if player has target and is in focusmode (right mouse button), change some of the wisps config values to adjust movement around target	
		if(target 
		&& (theGame.IsFocusModeActive() 

		|| (thePlayer.IsInCombat() 
		|| thePlayer.IsThreatened()) 
		&& thePlayer.IsHardLockEnabled())
		
		) 
		{	
			rotationCircleMovementSpeed -= 25;	
			rotationCircleRadius -= 0.25;

			wispGoalPosition = targetPosition;

			if (!this.IsEffectActive('wisp_fx_combat', false))
			{
				this.PlayEffectSingle('wisp_fx_combat');
			}

			if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
			{
				if (FactsQuerySum("ACS_Wisp_Attack_Enable") > 0)
				{
					if ( thePlayer.GetEquippedSign() == ST_Igni )
					{	
						if (thePlayer.GetLevel() < 10)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_red', false))
							{
								this.PlayEffectSingle('wisp_fx_red');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Axii )
					{
						if (thePlayer.GetLevel() < 20)
						{

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_green', false))
							{
								this.PlayEffectSingle('wisp_fx_green');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Aard )
					{
						if (thePlayer.GetLevel() < 5)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_blue', false))
							{
								this.PlayEffectSingle('wisp_fx_blue');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Quen )
					{	
						if (thePlayer.GetLevel() < 25)
						{
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_gold', false))
							{
								this.PlayEffectSingle('wisp_fx_gold');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Yrden )
					{
						if (thePlayer.GetLevel() < 15)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');

							if (!this.IsEffectActive('wisp_fx_purple', false))
							{
								this.PlayEffectSingle('wisp_fx_purple');
							}
						}
					}
				}
				else
				{
					this.StopEffect('wisp_fx_gold');
					this.StopEffect('wisp_fx_blue');
					this.StopEffect('wisp_fx_green');
					this.StopEffect('wisp_fx_red');
					this.StopEffect('wisp_fx_purple');
					
					if (!this.IsEffectActive('wisp_fx', false))
					{
						this.PlayEffectSingle('wisp_fx');
					}
				}
			}
			else
			{
				this.StopEffect('wisp_fx_gold');
				this.StopEffect('wisp_fx_blue');
				this.StopEffect('wisp_fx_green');
				this.StopEffect('wisp_fx_red');
				this.StopEffect('wisp_fx_purple');
				
				if (!this.IsEffectActive('wisp_fx', false))
				{
					this.PlayEffectSingle('wisp_fx');
				}
			}
		} 
		else 
		{
			this.StopEffect('wisp_fx_combat');

			if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
			{
				if (FactsQuerySum("ACS_Wisp_Attack_Enable") > 0)
				{
					if ( thePlayer.GetEquippedSign() == ST_Igni )
					{	
						if (thePlayer.GetLevel() < 10)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_red', false))
							{
								this.PlayEffectSingle('wisp_fx_red');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Axii )
					{
						if (thePlayer.GetLevel() < 20)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_green', false))
							{
								this.PlayEffectSingle('wisp_fx_green');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Aard )
					{
						if (thePlayer.GetLevel() < 5)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}

						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_combat');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_blue', false))
							{
								this.PlayEffectSingle('wisp_fx_blue');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Quen )
					{	
						if (thePlayer.GetLevel() < 25)
						{
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}

						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');
							this.StopEffect('wisp_fx_purple');

							if (!this.IsEffectActive('wisp_fx_gold', false))
							{
								this.PlayEffectSingle('wisp_fx_gold');
							}
						}
					}
					else if ( thePlayer.GetEquippedSign() == ST_Yrden )
					{
						if (thePlayer.GetLevel() < 15)
						{
							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');

							if (!this.IsEffectActive('wisp_fx', false))
							{
								this.PlayEffectSingle('wisp_fx');
							}
						}
						else
						{
							this.StopEffect('wisp_fx');

							this.StopEffect('wisp_fx_gold');
							this.StopEffect('wisp_fx_blue');
							this.StopEffect('wisp_fx_green');
							this.StopEffect('wisp_fx_red');

							if (!this.IsEffectActive('wisp_fx_purple', false))
							{
								this.PlayEffectSingle('wisp_fx_purple');
							}
						}
					}
				}
				else
				{
					this.StopEffect('wisp_fx_gold');
					this.StopEffect('wisp_fx_blue');
					this.StopEffect('wisp_fx_green');
					this.StopEffect('wisp_fx_red');
					this.StopEffect('wisp_fx_purple');
					
					if (!this.IsEffectActive('wisp_fx', false))
					{
						this.PlayEffectSingle('wisp_fx');
					}
				}
			}
			else
			{
				this.StopEffect('wisp_fx_gold');
				this.StopEffect('wisp_fx_blue');
				this.StopEffect('wisp_fx_green');
				this.StopEffect('wisp_fx_red');
				this.StopEffect('wisp_fx_purple');

				if (
				theGame.IsDialogOrCutscenePlaying() 
				|| theGame.IsFading()
				|| theGame.IsBlackscreen()
				)
				{
					this.StopEffect('wisp_fx');

					if (!this.IsEffectActive('wisp_fx_cutscene', false))
					{
						this.PlayEffectSingle('wisp_fx_cutscene');
					}
				}
				else
				{
					this.StopEffect('wisp_fx_cutscene');

					if (!this.IsEffectActive('wisp_fx', false))
					{
						this.PlayEffectSingle('wisp_fx');
					}
				}
			}

			//if no target and no focusmode, stick to player and use default config values	
			wispGoalPosition = playerPosition;
		
		}
		
	    wispGoalPosition += wispGoalPositionOffset;
        wispGoalPosition.X += CosF(Deg2Rad(wispCurrentRotationCircleAngle)) * rotationCircleRadius;
        wispGoalPosition.Y += SinF(Deg2Rad(wispCurrentRotationCircleAngle)) * rotationCircleRadius;

		if ((thePlayer.IsInCombat() 
		|| thePlayer.IsThreatened()) 
		&& thePlayer.IsHardLockEnabled())
		{
       		wispGoalPosition.Z += 3;
		}
		else
		{
			wispGoalPosition.Z += 2.5;
		}
       
        // see if we can set new random wisp position offset
        wispGoalPositionOffset_regenerateInSeconds -= deltaTime;
        if(wispGoalPositionOffset_regenerateInSeconds < 0) {
            wispGoalPositionOffset_regenerateInSeconds = RandRangeF(1, 0.1);
            wispGoalPositionOffset = VecRand() * rotationCircleRadius * 0.25;
        }
 
        // accelerate towards goal position
        wispCurrentAcceleration = (wispGoalPosition - wispCurrentPosition) * accelerationMultiplier;
 
        // clamp wisp acceleration, so its not too fast
        if(VecLength(wispCurrentAcceleration) > maxAcceleration) {
            wispCurrentAcceleration = VecNormalize(wispCurrentAcceleration) * maxAcceleration;
        }
 
        // simulate acceleration and velocity for more natural movement
        wispCurrentVelocity += wispCurrentAcceleration * deltaTime;
 
        // dampen velocity
        wispCurrentVelocity *= velocityDampeningFactor;
 
        // clamp wisp velocity, so its not too fast
        if(VecLength(wispCurrentVelocity) > maxVelocity) {
            wispCurrentVelocity = VecNormalize(wispCurrentVelocity) * maxVelocity;
        }
 
        // get the height
        if (theGame.GetWorld().NavigationComputeZ( wispCurrentPosition, wispCurrentPosition.Z - 2, wispCurrentPosition.Z + 2, navigationComputeZReturn ) )
        {
            // if wisp is too close to collision, bounce off it and loose some velocity
            if(AbsF(wispCurrentPosition.Z - navigationComputeZReturn) < 0.1) 
			{
                wispCurrentVelocity.Z *= -0.9;
            }
        }
 
        // simulate acceleration and velocity for more natural movement
        wispCurrentPosition += wispCurrentVelocity * deltaTime;
 
        // if wisp is too far away, just teleport it back to player
        if(VecDistance(wispCurrentPosition, wispGoalPosition) > 100) {
            wispCurrentPosition = wispGoalPosition;
            wispCurrentVelocity = Vector(0,0,0);
            wispCurrentAcceleration = Vector(0,0,0);
        }
 
        // rotate wisp it self over time
        wispCurrentRotation.Pitch += deltaTime * selfRotationSpeed;
		wispCurrentRotation.Roll += deltaTime * selfRotationSpeed;
		wispCurrentRotation.Yaw += deltaTime * selfRotationSpeed;
 
        // finall set the wisp position and rotation

		this.TeleportWithRotation(wispCurrentPosition, wispCurrentRotation); 		
    }   
}

function ACS_WispCheck()
{
	var entity                          										:  CEntity;
	var entityTemplate                  										:  CEntityTemplate;
	var resourcePath                   											:  string;

	if (FactsQuerySum("ACS_Wisp_Released") > 0 && thePlayer.inv.HasItem('acs_wisp'))
	{
		ACSWisp().Destroy();

		ACSGetCEntityDestroyAll('ACS_Wisp');

		if (thePlayer.inv.HasItem('acs_wisp'))
		{
			resourcePath = "dlc\dlc_acs\data\entities\items\acs_wisp.w2ent";

			entityTemplate = (CEntityTemplate)LoadResource(resourcePath,true);

			entity = (W3ACSWisp)theGame.CreateEntity(entityTemplate, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

			((CActor)entity).EnableCollisions(false);
			((CActor)entity).EnableCharacterCollisions(false);

			entity.AddTag('ACS_Wisp');

			entity.PlayEffectSingle('wisp_fx');

			//entity.PlayEffectSingle('502_barrier_hold');
		}
		else
		{
			FactsRemove("ACS_Wisp_Released");
		}
	}
}

function ACSWisp() : W3ACSWisp
{
	var entity 			 : W3ACSWisp;
	
	entity = (W3ACSWisp)theGame.GetEntityByTag( 'ACS_Wisp' );
	
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////

class W3ACSKestralSkullItem extends W3QuestUsableItem
{
	private var entity                          										:  CEntity;
    private var temp1, temp2                  											:  CEntityTemplate;
    private var path1, path2                   											:  string;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			super.OnUsed(usedBy);

			if(usedBy == GetWitcherPlayer()) 
			{
				if (FactsQuerySum("ACS_Kestral_Released") <= 0)
				{
					ACSKestralSkull().Destroy();

					ACSGetCEntityDestroyAll('ACS_Kestral_Skull');

					GetACSWatcher().AddTimer('ACS_Kestral_Skull_Tutorial_Delay', 0.5 , false);

					if (thePlayer.IsInInterior())
					{
						path2 = "dlc\dlc_acs\data\entities\items\acs_kestral_interior.w2ent";

						temp2 = (CEntityTemplate)LoadResource(path2,true);

						entity = (W3ACSKestralSkull)theGame.CreateEntity(temp2, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

						entity.AddTag('ACS_Kestral_Skull_Interior');
					}
					else
					{
						path1 = "dlc\dlc_acs\data\entities\items\acs_kestral.w2ent";

						temp1 = (CEntityTemplate)LoadResource(path1,true);

						entity = (W3ACSKestralSkull)theGame.CreateEntity(temp1, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

						entity.AddTag('ACS_Kestral_Skull_Exterior');
					}

					entity.AddTag('ACS_Kestral_Skull');

					FactsAdd("ACS_Kestral_Released", 1, -1);
				}
				else if (FactsQuerySum("ACS_Kestral_Released") > 0)
				{
					if(theGame.IsFocusModeActive())
					{
						if (FactsQuerySum("ACS_Kestral_Camera_Active") <= 0)
						{
							GetACSWatcher().CreateKestralCamera();

							FactsAdd("ACS_Kestral_Camera_Active", 1, -1);
						}
						else if (FactsQuerySum("ACS_Kestral_Camera_Active") > 0)
						{
							ACSGetKestralCamera().Stop();

							ACSGetKestralCamera().Destroy();

							FactsRemove("ACS_Kestral_Camera_Active");
						}
					}
					else
					{
						if (FactsQuerySum("ACS_Kestral_Camera_Active") > 0)
						{
							ACSGetKestralCamera().Stop();

							ACSGetKestralCamera().Destroy();

							FactsRemove("ACS_Kestral_Camera_Active");
						}
						else
						{
							ACSKestralSkull().Destroy();

							ACSGetCEntityDestroyAll('ACS_Kestral_Skull');

							FactsRemove("ACS_Kestral_Released");
						}
					}
						
				}
			}
		}		
	}
}

class W3ACSKestralSkull extends CGameplayEntity 
{
    private var wispCurrentRotationCircleAngle 								: float; 
    private var wispCurrentRotation 												: EulerAngles; 
    private var wispCurrentPosition 													: Vector;
    private var wispCurrentVelocity 													: Vector;
    private var wispCurrentAcceleration 											: Vector;
	
	private var wispGoalPosition 														: Vector;
    private var wispGoalPositionOffset 												: Vector;
    private var wispGoalPositionOffset_regenerateInSeconds 				: float;
   
    private var entity                          											:  CEntity;
    private var entityTemplate                  										:  CEntityTemplate;
    private var resourcePath                   											:  string;
    
    private var active 																		: bool;


	event OnDestroyed() 
	{	
		var ent                          											:  CEntity;
    	var temp1, temp2                  											:  CEntityTemplate;
   		var path1, path2                   											:  string;

		resourcePath = "dlc\dlc_acs\data\entities\other\fx_ent.w2ent";
	
		entityTemplate = (CEntityTemplate)LoadResource(resourcePath,true);

		entity = (CEntity)theGame.CreateEntity(entityTemplate, this.GetWorldPosition(), this.GetWorldRotation());

		entity.PlayEffect('teleport_out');

		entity.DestroyAfter(3);


		if (this.HasTag('ACS_Kestral_Skull_Interior_Respawn'))
		{
			path2 = "dlc\dlc_acs\data\entities\items\acs_kestral_interior.w2ent";

			temp2 = (CEntityTemplate)LoadResource(path2,true);

			ent = (W3ACSKestralSkull)theGame.CreateEntity(temp2, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

			ent.AddTag('ACS_Kestral_Skull_Interior');

			ent.AddTag('ACS_Kestral_Skull');
		}
		else if (this.HasTag('ACS_Kestral_Skull_Exterior_Respawn'))
		{
			path1 = "dlc\dlc_acs\data\entities\items\acs_kestral.w2ent";

			temp1 = (CEntityTemplate)LoadResource(path1,true);

			ent = (W3ACSKestralSkull)theGame.CreateEntity(temp1, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

			ent.AddTag('ACS_Kestral_Skull_Exterior');

			ent.AddTag('ACS_Kestral_Skull');
		}
	}

	event OnSpawned(spawnData : SEntitySpawnData) 
	{
		var bonePos															: Vector;
		var temp 															: CEntityTemplate;
		var ent																: CEntity;

		bonePos = MatrixGetTranslation(thePlayer.GetBoneWorldMatrixByIndex(24));

		this.AddTimer('AreaCheck', 0.0001 , true);

		this.AddTimer('FollowPlayer', 0.0001 , true);

		PlayEffect('teleport_in');
		StopEffect('teleport_in');

		PlayEffectSingle('feathers_fx');

		wispCurrentPosition = bonePos + Vector(0,0,0.1);

        wispCurrentVelocity = Vector(3,0,0);

		wispCurrentAcceleration = Vector(0,0,0);
	}	

	var last_kestral_attack_refresh_time : float;

	function kestral_can_attack(): bool 
	{
		return theGame.GetEngineTimeAsSeconds() - last_kestral_attack_refresh_time > 5;
	}

	function refresh_kestral_attack_cooldown() 
	{
		last_kestral_attack_refresh_time = theGame.GetEngineTimeAsSeconds();
	}

	var last_kestral_damage_refresh_time : float;

	function kestral_can_do_damage(): bool 
	{
		return theGame.GetEngineTimeAsSeconds() - last_kestral_damage_refresh_time > 0.25;
	}

	function refresh_kestral_damage_cooldown() 
	{
		last_kestral_damage_refresh_time = theGame.GetEngineTimeAsSeconds();
	}

	function kestral_damage()
	{
		var i									: int;
		var entities 							: array<CGameplayEntity>;
		var actortarget 						: CActor;
		var dmg									: W3DamageAction;
		var damageMax, damageMin				: float;
		var fxent                        	  	: CEntity;
    	var temp                  				: CEntityTemplate;
    	var path                   				: string;
		var targetpos							: Vector;
		
		if (kestral_can_do_damage())
		{
			refresh_kestral_damage_cooldown();

			entities.Clear();

			FindGameplayEntitiesInSphere(entities, this.GetWorldPosition(), 1.5, 20, ,FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors , ,);
			
			if( entities.Size() > 0 )
			{
				for( i = 0; i < entities.Size(); i += 1 )
				{
					actortarget = (CActor)entities[i];

					if (actortarget == ACSGetCActor('ACS_Transformation_Black_Wolf')
					|| actortarget.HasTag('smokeman') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
					|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
					|| actortarget.HasTag('ACS_Chaos_Cloud')
					)
					continue;

					actortarget.IsAttacked();

					actortarget.SignalGameplayEventParamInt('Time2Dodge', (int)EDT_Attack_Light );

					dmg = new W3DamageAction in theGame.damageMgr;
					
					dmg.Initialize(thePlayer, actortarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
					
					dmg.SetProcessBuffsIfNoDamage(true);
					
					dmg.SetIgnoreImmortalityMode(false);

					dmg.SetHitAnimationPlayType(EAHA_ForceYes);

					if (actortarget.UsesVitality()) 
					{ 
						damageMax = actortarget.GetStat( BCS_Vitality ) * 0.03125; 

						damageMin = actortarget.GetStat( BCS_Vitality ) * 0.03125; 
					} 
					else if (actortarget.UsesEssence()) 
					{ 
						if (((CMovingPhysicalAgentComponent)(actortarget.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| actortarget.GetRadius() >= 0.7
						|| actortarget.HasAbility('Boss')
						|| actortarget.HasTag('IsBoss')
						)
						{
							damageMax = actortarget.GetStat( BCS_Essence ) * 0.03125; 
						
							damageMin = actortarget.GetStat( BCS_Essence ) * 0.03125; 
						}
						else
						{
							damageMax = actortarget.GetStat( BCS_Essence ) * 0.03125; 
						
							damageMin = actortarget.GetStat( BCS_Essence ) * 0.03125; 
						}
					}

					dmg.SetHitReactionType( EHRT_Heavy, true);

					dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );

					//dmg.AddEffectInfo( EET_Bleeding, 3 );

					dmg.SetForceExplosionDismemberment();
						
					theGame.damageMgr.ProcessAction( dmg );
						
					delete dmg;	



					path = "gameplay\abilities\sorceresses\fx_dummy_entity.w2ent";
			
					temp = (CEntityTemplate)LoadResource(path,true);

					targetpos = actortarget.GetWorldPosition();
					targetpos.Z += 1;

					fxent = (CEntity)theGame.CreateEntity(temp, targetpos, actortarget.GetWorldRotation());

					fxent.CreateAttachment(actortarget,, Vector( 0, 0, 1 ), EulerAngles(0,0,0));

					fxent.PlayEffect('hit_electric');

					fxent.DestroyAfter(3);

					this.StopEffect('hit_electric');
					this.PlayEffect('hit_electric');
				}
			}
		}
	}

	var last_kestral_lightning_refresh_time : float;

	function kestral_can_perform_lightning(): bool 
	{
		return theGame.GetEngineTimeAsSeconds() - last_kestral_lightning_refresh_time > 3;
	}

	function refresh_kestral_lightning_cooldown() 
	{
		last_kestral_lightning_refresh_time = theGame.GetEngineTimeAsSeconds();
	}

	timer function kestral_lightning (deltaTime : float, id : int) 
	{
		var actortarget 						: CActor;
		var dmg									: W3DamageAction;
		var damageMax, damageMin				: float;
		var fxent                        	  	: CEntity;
    	var temp                  				: CEntityTemplate;
    	var path                   				: string;
		var targetpos							: Vector;
		
		actortarget = (CActor)thePlayer.moveTarget;

		if (actortarget)
		{
			path = "gameplay\abilities\sorceresses\fx_dummy_entity.w2ent";
		
			temp = (CEntityTemplate)LoadResource(path,true);

			targetpos = actortarget.GetWorldPosition();
			targetpos.Z += 1;

			fxent = (CEntity)theGame.CreateEntity(temp, targetpos, actortarget.GetWorldRotation());

			fxent.CreateAttachment(actortarget,, Vector( 0, 0, 1 ), EulerAngles(0,0,0));

			fxent.PlayEffect('hit_electric');

			fxent.DestroyAfter(3);

			this.StopEffect('lightning');
			this.PlayEffect('lightning', fxent);

			this.StopEffect('hit_electric');
			this.PlayEffect('hit_electric');

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(thePlayer, actortarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetIgnoreImmortalityMode(false);

			dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			if (actortarget.UsesVitality()) 
			{ 
				damageMax = actortarget.GetStat( BCS_Vitality ) * 0.125; 

				damageMin = actortarget.GetStat( BCS_Vitality ) * 0.0625; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				if (((CMovingPhysicalAgentComponent)(actortarget.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| actortarget.GetRadius() >= 0.7
				|| actortarget.HasAbility('Boss')
				|| actortarget.HasTag('IsBoss')
				)
				{
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.0625; 
				
					damageMin = actortarget.GetStat( BCS_Essence ) * 0.03125; 
				}
				else
				{
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.125; 
				
					damageMin = actortarget.GetStat( BCS_Essence ) * 0.0625; 
				}
			}

			dmg.SetHitReactionType( EHRT_Heavy, true);

			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) );

			dmg.SetForceExplosionDismemberment();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
		}
	}

	function kestral_lightning_interior() 
	{
		var actortarget 						: CActor;
		var dmg									: W3DamageAction;
		var damageMax, damageMin				: float;
		var fxent                        	  	: CEntity;
    	var temp                  				: CEntityTemplate;
    	var path                   				: string;
		var targetpos							: Vector;
		
		if (kestral_can_perform_lightning())
		{
			refresh_kestral_lightning_cooldown();

			actortarget = (CActor)thePlayer.moveTarget;

			if (actortarget)
			{
				path = "gameplay\abilities\sorceresses\fx_dummy_entity.w2ent";
			
				temp = (CEntityTemplate)LoadResource(path,true);

				targetpos = actortarget.GetWorldPosition();
				targetpos.Z += 1;

				fxent = (CEntity)theGame.CreateEntity(temp, targetpos, actortarget.GetWorldRotation());

				fxent.CreateAttachment(actortarget,, Vector( 0, 0, 1 ), EulerAngles(0,0,0));

				fxent.PlayEffect('hit_electric');

				fxent.DestroyAfter(3);

				this.StopEffect('lightning');
				this.PlayEffect('lightning', fxent);

				this.StopEffect('hit_electric');
				this.PlayEffect('hit_electric');

				dmg = new W3DamageAction in theGame.damageMgr;
				
				dmg.Initialize(thePlayer, actortarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetIgnoreImmortalityMode(false);

				dmg.SetHitAnimationPlayType(EAHA_ForceYes);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Vitality ) * 0.125; 

					damageMin = actortarget.GetStat( BCS_Vitality ) * 0.0625; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					if (((CMovingPhysicalAgentComponent)(actortarget.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
					|| actortarget.GetRadius() >= 0.7
					|| actortarget.HasAbility('Boss')
					|| actortarget.HasTag('IsBoss')
					)
					{
						damageMax = actortarget.GetStat( BCS_Essence ) * 0.0625; 
					
						damageMin = actortarget.GetStat( BCS_Essence ) * 0.03125; 
					}
					else
					{
						damageMax = actortarget.GetStat( BCS_Essence ) * 0.125; 
					
						damageMin = actortarget.GetStat( BCS_Essence ) * 0.0625; 
					}
				}

				dmg.SetHitReactionType( EHRT_Heavy, true);

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) );

				dmg.SetForceExplosionDismemberment();
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;	
			}
		}
	}

	timer function reveal_crow(deltaTime : float, id : int) 
	{
		DestroyEffect('teleport_in');
		PlayEffect('teleport_in');
		StopEffect('teleport_in');

		PlayEffectSingle('feathers_fx');

		StopEffect('disappear');

		if (thePlayer.IsInCombat())
		{
			RemoveTimer('kestral_lightning');
			AddTimer('kestral_lightning', 2 / theGame.GetTimeScale(), false );
		}
	}

	timer function AreaCheck(deltaTime : float, id : int) 
	{
		if(thePlayer.IsInInterior()) 
		{
			if (this.HasTag('ACS_Kestral_Skull_Exterior'))
			{
				this.AddTag('ACS_Kestral_Skull_Interior_Respawn');

				this.Destroy();
			}
		}
		else
		{
			if (this.HasTag('ACS_Kestral_Skull_Interior'))
			{
				this.AddTag('ACS_Kestral_Skull_Exterior_Respawn');

				this.Destroy();
			}
		}
	}

    timer function FollowPlayer(deltaTime : float, id : int) 
	{
		var target : CEntity;
		var targetPosition, attackposition : Vector;
		var targetRotation : EulerAngles;
		
        var playerPosition : Vector;
        var playerRotation : EulerAngles;      
        
        var goalAcceleration : Vector;
        var navigationComputeZReturn : float;  
 
        var rotationCircleRadius : float;
        var rotationCircleMovementSpeed : float;
        var selfRotationSpeed : float;
        var maxAcceleration : float;      
        var accelerationMultiplier : float;
        var maxVelocity : float;
        var velocityDampeningFactor : float;

		var lookatents										: array<CGameplayEntity>;
		var i, j											: int;

		var gameLightComp, gameInteractComp 				: CComponent;

		var pos, lookatentsPos								 : Vector;

		var targetDistance									: float;

		var bonePos															: Vector;

		if (this.HasTag('ACS_Kestral_Skull_Exterior'))
		{
			rotationCircleMovementSpeed = 100;
			rotationCircleRadius = 7.5;
			selfRotationSpeed = 200;
			maxAcceleration = 200;
			accelerationMultiplier = 100;
			maxVelocity = 100;
			velocityDampeningFactor = 0.9;


			wispCurrentRotationCircleAngle += deltaTime * rotationCircleMovementSpeed;
	
			while(wispCurrentRotationCircleAngle > 360) 
			{          
				wispCurrentRotationCircleAngle -= 360;                        
			}

			pos = thePlayer.GetWorldPosition();
			pos.Z += 0.8;
		
			if (thePlayer.IsInCombat())
			{
				target = thePlayer.moveTarget;
			}
			else 
			{
				lookatents.Clear();

				FindGameplayEntitiesInCone( lookatents, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection(), VecHeading( theCamera.GetCameraDirection() ), 120, 120, 1, , FLAG_ExcludePlayer );

				for(i = 0; i < lookatents.Size(); i += 1)
				{
					if 
					( 
					lookatents[i] == GetWitcherPlayer() 
					|| lookatents[i] == GetACSWatcher()
					|| lookatents[i] == theCamera
					)
					{
						continue;
					}

					for( j = lookatents.Size()-1; j >= 0; j -= 1 ) 
					{	
						lookatentsPos = lookatents[j].GetWorldPosition();
						
						if ( AbsF( lookatentsPos.Z - pos.Z ) > 2.5 )
						{
							lookatents.EraseFast(j);
						}

						if (lookatents.Size() > 0)
						{
							if ( lookatents[j] = thePlayer.GetDisplayTarget())
							{
								target = thePlayer.GetDisplayTarget();
							}
							else
							{
								gameLightComp = lookatents[j].GetComponentByClassName('CGameplayLightComponent');

								gameInteractComp = lookatents[j].GetComponentByClassName('CInteractionComponent');

								if(
								(CNewNPC)lookatents[j]
								|| (COilBarrelEntity)lookatents[j]
								|| gameLightComp
								|| gameInteractComp
								|| (W3AnimationInteractionEntity)lookatents[j]
								|| (CInteractiveEntity)lookatents[j]
								|| (W3NoticeBoard)lookatents[j]
								|| (W3FastTravelEntity)lookatents[j]
								|| (W3SmartObject)lookatents[j]
								|| (W3ItemRepairObject)lookatents[j]
								|| (W3AlchemyTable)lookatents[j]
								|| (W3Stables)lookatents[j]
								|| (W3LockableEntity)lookatents[j] 
								|| (W3Poster)lookatents[j]
								|| (W3LadderInteraction)lookatents[j]
								)
								{
									target = lookatents[j];
								}
							}
						}
					}	
				}
			}

			playerPosition = TraceFloor(thePlayer.GetWorldPosition());
			targetPosition = TraceFloor(target.GetWorldPosition());

			playerRotation = thePlayer.GetWorldRotation();

			targetRotation = target.GetWorldRotation();

			if(target 
			&& (theGame.IsFocusModeActive() 
			|| (thePlayer.IsInCombat() 
			|| thePlayer.IsThreatened()) 
			&& target)
			) 
			{	
				wispGoalPosition = targetPosition;

				if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
				{
					
				}
				else
				{
					
				}
			} 
			else 
			{
				if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
				{
					
				}
				else
				{
					
				}

				wispGoalPosition = playerPosition;
			}
			
			wispGoalPosition += wispGoalPositionOffset;
			wispGoalPosition.X += CosF(Deg2Rad(wispCurrentRotationCircleAngle)) * rotationCircleRadius;
			wispGoalPosition.Y += SinF(Deg2Rad(wispCurrentRotationCircleAngle)) * rotationCircleRadius;

			if ((thePlayer.IsInCombat() 
			|| thePlayer.IsThreatened()) )
			{
				if (this.HasTag('ACS_Kestral_Attack_Mode'))
				{
					wispGoalPosition.Z += 4;
				}
				else
				{
					wispGoalPosition.Z += 4.5;
				}
			}
			else
			{
				wispGoalPosition.Z += 6;
			}
		
			attackposition = targetPosition;

			targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), targetPosition ) ;

			if (thePlayer.IsInCombat())
			{
				kestral_damage();

				if (kestral_can_attack())
				{
					refresh_kestral_attack_cooldown();

					if(!this.HasTag('ACS_Kestral_Attack_Mode'))
					{
						//PlayEffect('teleport_in');
						//StopEffect('teleport_in');

						DestroyEffect('teleport_out');
						PlayEffect('teleport_out');
						//StopEffect('teleport_out');

						DestroyEffect('disappear');
						PlayEffect('disappear');

						DestroyEffect('feathers_fx');

						RemoveTimer('reveal_crow');
						AddTimer('reveal_crow', 1 / theGame.GetTimeScale(), false );

						this.AddTag('ACS_Kestral_Attack_Mode');
					}
					else if(this.HasTag('ACS_Kestral_Attack_Mode'))
					{
						//PlayEffect('teleport_in');
						//StopEffect('teleport_in');

						DestroyEffect('teleport_out');
						PlayEffect('teleport_out');
						//StopEffect('teleport_out');

						DestroyEffect('disappear');
						PlayEffect('disappear');

						DestroyEffect('feathers_fx');

						RemoveTimer('reveal_crow');
						AddTimer('reveal_crow', 1 / theGame.GetTimeScale(), false );

						this.RemoveTag('ACS_Kestral_Attack_Mode');
					}
				}

				if(!this.HasTag('ACS_Kestral_In_Combat'))
				{
					this.AddTag('ACS_Kestral_In_Combat');
				}

				if (this.HasTag('ACS_Kestral_Attack_Mode'))
				{
					wispGoalPositionOffset_regenerateInSeconds -= deltaTime;

					if(wispGoalPositionOffset_regenerateInSeconds < 0) 
					{
						wispGoalPositionOffset_regenerateInSeconds = 0.1;

						wispGoalPositionOffset = VecNormalize(attackposition) * rotationCircleRadius;

						wispGoalPositionOffset.Z -= 3;
					}
				}
				else
				{
					wispGoalPositionOffset_regenerateInSeconds -= deltaTime;

					if(wispGoalPositionOffset_regenerateInSeconds < 0) 
					{
						wispGoalPositionOffset_regenerateInSeconds = 0.1;

						wispGoalPositionOffset = VecRand() * rotationCircleRadius * 0.01;

						//wispGoalPositionOffset = VecNormalize(attackposition) * rotationCircleRadius;

						//wispGoalPositionOffset.Z += 3;
					}	
				}
			}
			else
			{
				if(this.HasTag('ACS_Kestral_Attack_Mode'))
				{
					this.RemoveTag('ACS_Kestral_Attack_Mode');
				}

				if(this.HasTag('ACS_Kestral_In_Combat'))
				{
					DestroyEffect('teleport_out');
					PlayEffect('teleport_out');

					DestroyEffect('disappear');
					PlayEffect('disappear');

					DestroyEffect('feathers_fx');

					RemoveTimer('reveal_crow');
					AddTimer('reveal_crow', 2 / theGame.GetTimeScale(), false );

					this.RemoveTag('ACS_Kestral_In_Combat');
				}

				wispGoalPositionOffset_regenerateInSeconds -= deltaTime;

				if(wispGoalPositionOffset_regenerateInSeconds < 0) 
				{
					wispGoalPositionOffset_regenerateInSeconds = 0.1;

					wispGoalPositionOffset = VecRand() * rotationCircleRadius * 0.01;
				}	
			}
			
			wispCurrentAcceleration = (wispGoalPosition - wispCurrentPosition) * accelerationMultiplier;
	
			if(VecLength(wispCurrentAcceleration) > maxAcceleration) 
			{
				wispCurrentAcceleration = VecNormalize(wispCurrentAcceleration) * maxAcceleration;
			}

			wispCurrentVelocity += wispCurrentAcceleration * deltaTime;

			wispCurrentVelocity *= velocityDampeningFactor;

			if(VecLength(wispCurrentVelocity) > maxVelocity) 
			{
				wispCurrentVelocity = VecNormalize(wispCurrentVelocity) * maxVelocity;
			}
	
			if (theGame.GetWorld().NavigationComputeZ( wispCurrentPosition, wispCurrentPosition.Z - 2, wispCurrentPosition.Z + 2, navigationComputeZReturn ) )
			{
				if(AbsF(wispCurrentPosition.Z - navigationComputeZReturn) < 0.1) 
				{
					wispCurrentVelocity.Z *= -0.9;
				}
			}

			wispCurrentPosition += wispCurrentVelocity * deltaTime;
	
			if(VecDistance(wispCurrentPosition, wispGoalPosition) > 100) {
				wispCurrentPosition = wispGoalPosition;
				wispCurrentVelocity = Vector(0,0,0);
				wispCurrentAcceleration = Vector(0,0,0);
			}
	
			wispCurrentRotation.Roll = -45;
			wispCurrentRotation.Yaw += deltaTime * rotationCircleMovementSpeed;
		}
		else if (this.HasTag('ACS_Kestral_Skull_Interior'))
		{
			bonePos = MatrixGetTranslation(thePlayer.GetBoneWorldMatrixByIndex(thePlayer.GetBoneIndex( 'l_shoulder' )));

			wispCurrentPosition = bonePos + (thePlayer.GetWorldRight() * -0.5) + (thePlayer.GetWorldUp() * 0.5) + (thePlayer.GetWorldForward() * -0.25);

			wispCurrentRotation = thePlayer.GetWorldRotation();

			if (thePlayer.IsInCombat())
			{
				if (thePlayer.GetTarget())
				{
					kestral_lightning_interior();
				}
			}
		}
			
		this.TeleportWithRotation(wispCurrentPosition, wispCurrentRotation); 
    }   
}

function ACS_KestralCheck()
{
	var entity                          										:  CEntity;
	var temp1, temp2                  											:  CEntityTemplate;
    var path1, path2                   											:  string;

	if (FactsQuerySum("ACS_Kestral_Camera_Active") > 0)
	{
		FactsRemove("ACS_Kestral_Camera_Active");
	}

	if (FactsQuerySum("ACS_Kestral_Released") > 0 && thePlayer.inv.HasItem('acs_kestral_skull'))
	{
		ACSKestralSkull().Destroy();

		ACSGetCEntityDestroyAll('ACS_Kestral_Skull');

		if (thePlayer.inv.HasItem('acs_kestral_skull'))
		{
			if (thePlayer.IsInInterior())
			{
				path2 = "dlc\dlc_acs\data\entities\items\acs_kestral_interior.w2ent";

				temp2 = (CEntityTemplate)LoadResource(path2,true);

				entity = (W3ACSKestralSkull)theGame.CreateEntity(temp2, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

				entity.AddTag('ACS_Kestral_Skull_Interior');
			}
			else
			{
				path1 = "dlc\dlc_acs\data\entities\items\acs_kestral.w2ent";

				temp1 = (CEntityTemplate)LoadResource(path1,true);

				entity = (W3ACSKestralSkull)theGame.CreateEntity(temp1, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

				entity.AddTag('ACS_Kestral_Skull_Exterior');
			}

			entity.AddTag('ACS_Kestral_Skull');
		}
		else
		{
			FactsRemove("ACS_Kestral_Released");
		}
	}
}

function ACSKestralSkull() : W3ACSKestralSkull
{
	var entity 			 : W3ACSKestralSkull;
	
	entity = (W3ACSKestralSkull)theGame.GetEntityByTag( 'ACS_Kestral_Skull' );
	
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////

class W3ACSPhoenixAshesItem extends W3QuestUsableItem
{
	private var entity                          										:  CEntity;
    private var temp1, temp2                  											:  CEntityTemplate;
    private var path1, path2                   											:  string;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			super.OnUsed(usedBy);

			if(usedBy == GetWitcherPlayer()) 
			{
				if (FactsQuerySum("ACS_Phoenix_Released") <= 0)
				{
					ACSPhoenix().Destroy();

					ACSGetCEntityDestroyAll('ACS_Phoenix');

					GetACSWatcher().AddTimer('ACS_Phoenix_Ashes_Tutorial_Delay', 0.5 / theGame.GetTimeScale(), false );

					if (thePlayer.IsInInterior())
					{
						path2 = "dlc\dlc_acs\data\entities\items\acs_phoenix_interior.w2ent";

						temp2 = (CEntityTemplate)LoadResource(path2,true);

						entity = (W3ACSPhoenix)theGame.CreateEntity(temp2, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

						entity.AddTag('ACS_Phoenix_Interior');
					}
					else
					{
						path1 = "dlc\dlc_acs\data\entities\items\acs_phoenix.w2ent";

						temp1 = (CEntityTemplate)LoadResource(path1,true);

						entity = (W3ACSPhoenix)theGame.CreateEntity(temp1, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

						entity.AddTag('ACS_Phoenix_Exterior');
					}

					entity.AddTag('ACS_Phoenix');

					FactsAdd("ACS_Phoenix_Released", 1, -1);
				}
				else if (FactsQuerySum("ACS_Phoenix_Released") > 0)
				{
					ACSPhoenix().Destroy();

					ACSGetCEntityDestroyAll('ACS_Phoenix');

					FactsRemove("ACS_Phoenix_Released");
				}
			}
		}		
	}
}

class W3ACSPhoenix extends CGameplayEntity 
{
    private var wispCurrentRotationCircleAngle 								: float; 
    private var wispCurrentRotation 												: EulerAngles; 
    private var wispCurrentPosition 													: Vector;
    private var wispCurrentVelocity 													: Vector;
    private var wispCurrentAcceleration 											: Vector;
	
	private var wispGoalPosition 														: Vector;
    private var wispGoalPositionOffset 												: Vector;
    private var wispGoalPositionOffset_regenerateInSeconds 				: float;
   
    private var entity                          											:  CEntity;
    private var entityTemplate                  										:  CEntityTemplate;
    private var resourcePath                   											:  string;
    
    private var active 																		: bool;


	event OnDestroyed() 
	{	
		var ent                          											:  CEntity;
    	var temp1, temp2                  											:  CEntityTemplate;
   		var path1, path2                   											:  string;

		resourcePath = "dlc\dlc_acs\data\entities\other\fx_ent.w2ent";
	
		entityTemplate = (CEntityTemplate)LoadResource(resourcePath,true);

		entity = (CEntity)theGame.CreateEntity(entityTemplate, this.GetWorldPosition(), this.GetWorldRotation());

		entity.PlayEffect('teleport_out_fire');

		entity.DestroyAfter(3);


		if (this.HasTag('ACS_Phoenix_Interior_Respawn'))
		{
			path2 = "dlc\dlc_acs\data\entities\items\acs_phoenix_interior.w2ent";

			temp2 = (CEntityTemplate)LoadResource(path2,true);

			ent = (W3ACSPhoenix)theGame.CreateEntity(temp2, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

			ent.AddTag('ACS_Phoenix_Interior');

			ent.AddTag('ACS_Phoenix');
		}
		else if (this.HasTag('ACS_Phoenix_Exterior_Respawn'))
		{
			path1 = "dlc\dlc_acs\data\entities\items\acs_Phoenix.w2ent";

			temp1 = (CEntityTemplate)LoadResource(path1,true);

			ent = (W3ACSPhoenix)theGame.CreateEntity(temp1, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

			ent.AddTag('ACS_Phoenix_Exterior');

			ent.AddTag('ACS_Phoenix');
		}
	}

	event OnSpawned(spawnData : SEntitySpawnData) 
	{
		var bonePos															: Vector;
		var temp 															: CEntityTemplate;
		var ent																: CEntity;

		bonePos = MatrixGetTranslation(thePlayer.GetBoneWorldMatrixByIndex(24));

		this.AddTimer('AreaCheck', 0.0001 , true);

		this.AddTimer('FollowPlayer', 0.0001 , true);

		PlayEffect('teleport_in');
		StopEffect('teleport_in');

		PlayEffectSingle('feathers_fx');

		wispCurrentPosition = bonePos + Vector(0,0,0.1);

        wispCurrentVelocity = Vector(3,0,0);

		wispCurrentAcceleration = Vector(0,0,0);
	}	

	var last_kestral_attack_refresh_time : float;

	function kestral_can_attack(): bool 
	{
		return theGame.GetEngineTimeAsSeconds() - last_kestral_attack_refresh_time > 5;
	}

	function refresh_kestral_attack_cooldown() 
	{
		last_kestral_attack_refresh_time = theGame.GetEngineTimeAsSeconds();
	}

	var last_kestral_damage_refresh_time : float;

	function kestral_can_do_damage(): bool 
	{
		return theGame.GetEngineTimeAsSeconds() - last_kestral_damage_refresh_time > 0.25;
	}

	function refresh_kestral_damage_cooldown() 
	{
		last_kestral_damage_refresh_time = theGame.GetEngineTimeAsSeconds();
	}

	function kestral_damage()
	{
		var i									: int;
		var entities 							: array<CGameplayEntity>;
		var actortarget 						: CActor;
		var dmg									: W3DamageAction;
		var damageMax, damageMin				: float;
		var fxent                        	  	: CEntity;
    	var temp                  				: CEntityTemplate;
    	var path                   				: string;
		var targetpos							: Vector;
		
		if (kestral_can_do_damage())
		{
			refresh_kestral_damage_cooldown();

			entities.Clear();

			FindGameplayEntitiesInSphere(entities, this.GetWorldPosition(), 1.5, 20, ,FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors , ,);
			
			if( entities.Size() > 0 )
			{
				for( i = 0; i < entities.Size(); i += 1 )
				{
					actortarget = (CActor)entities[i];

					if (actortarget == ACSGetCActor('ACS_Transformation_Black_Wolf')
					|| actortarget.HasTag('smokeman') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
					|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
					|| actortarget.HasTag('ACS_Chaos_Cloud')
					)
					continue;

					actortarget.IsAttacked();

					actortarget.SignalGameplayEventParamInt('Time2Dodge', (int)EDT_Attack_Light );

					dmg = new W3DamageAction in theGame.damageMgr;
					
					dmg.Initialize(thePlayer, actortarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
					
					dmg.SetProcessBuffsIfNoDamage(true);
					
					dmg.SetIgnoreImmortalityMode(false);

					dmg.SetHitAnimationPlayType(EAHA_ForceYes);

					if (actortarget.UsesVitality()) 
					{ 
						damageMax = actortarget.GetStat( BCS_Vitality ) * 0.03125; 

						damageMin = actortarget.GetStat( BCS_Vitality ) * 0.03125; 
					} 
					else if (actortarget.UsesEssence()) 
					{ 
						if (((CMovingPhysicalAgentComponent)(actortarget.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| actortarget.GetRadius() >= 0.7
						|| actortarget.HasAbility('Boss')
						|| actortarget.HasTag('IsBoss')
						)
						{
							damageMax = actortarget.GetStat( BCS_Essence ) * 0.03125; 
						
							damageMin = actortarget.GetStat( BCS_Essence ) * 0.03125; 
						}
						else
						{
							damageMax = actortarget.GetStat( BCS_Essence ) * 0.03125; 
						
							damageMin = actortarget.GetStat( BCS_Essence ) * 0.03125; 
						}
					}

					dmg.SetHitReactionType( EHRT_Heavy, true);

					dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

					dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );

					dmg.AddEffectInfo( EET_Burning, 1 );

					dmg.SetForceExplosionDismemberment();
						
					theGame.damageMgr.ProcessAction( dmg );
						
					delete dmg;	



					path = "dlc\dlc_acs\data\entities\other\fx_dummy_entity_ifrit.w2ent";
			
					temp = (CEntityTemplate)LoadResource(path,true);

					targetpos = actortarget.GetWorldPosition();
					targetpos.Z += 1;

					fxent = (CEntity)theGame.CreateEntity(temp, targetpos, actortarget.GetWorldRotation());

					fxent.CreateAttachment(actortarget,, Vector( 0, 0, 1 ), EulerAngles(0,0,0));

					fxent.PlayEffect('hit_fire');

					fxent.DestroyAfter(3);

					this.StopEffect('hit_electric');
					this.PlayEffect('hit_electric');
				}
			}
		}
	}

	var last_kestral_lightning_refresh_time : float;

	function kestral_can_perform_lightning(): bool 
	{
		return theGame.GetEngineTimeAsSeconds() - last_kestral_lightning_refresh_time > 3;
	}

	function refresh_kestral_lightning_cooldown() 
	{
		last_kestral_lightning_refresh_time = theGame.GetEngineTimeAsSeconds();
	}

	timer function kestral_lightning (deltaTime : float, id : int) 
	{
		var actortarget 						: CActor;
		var dmg									: W3DamageAction;
		var damageMax, damageMin				: float;
		var fxent                        	  	: CEntity;
    	var temp                  				: CEntityTemplate;
    	var path                   				: string;
		var targetpos							: Vector;
		
		actortarget = (CActor)thePlayer.moveTarget;

		if (actortarget)
		{
			path = "dlc\dlc_acs\data\entities\other\fx_dummy_entity_ifrit.w2ent";
		
			temp = (CEntityTemplate)LoadResource(path,true);

			targetpos = actortarget.GetWorldPosition();
			targetpos.Z += 1;

			fxent = (CEntity)theGame.CreateEntity(temp, targetpos, actortarget.GetWorldRotation());

			fxent.CreateAttachment(actortarget,, Vector( 0, 0, 1 ), EulerAngles(0,0,0));

			fxent.PlayEffect('hit_fire');

			fxent.DestroyAfter(3);

			this.StopEffect('lightning');
			this.PlayEffect('lightning', fxent);

			this.StopEffect('hit_electric');
			this.PlayEffect('hit_electric');

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(thePlayer, actortarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetIgnoreImmortalityMode(false);

			dmg.SetHitAnimationPlayType(EAHA_ForceYes);

			if (actortarget.UsesVitality()) 
			{ 
				damageMax = actortarget.GetStat( BCS_Vitality ) * 0.125; 

				damageMin = actortarget.GetStat( BCS_Vitality ) * 0.0625; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				if (((CMovingPhysicalAgentComponent)(actortarget.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| actortarget.GetRadius() >= 0.7
				|| actortarget.HasAbility('Boss')
				|| actortarget.HasTag('IsBoss')
				)
				{
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.0625; 
				
					damageMin = actortarget.GetStat( BCS_Essence ) * 0.03125; 
				}
				else
				{
					damageMax = actortarget.GetStat( BCS_Essence ) * 0.125; 
				
					damageMin = actortarget.GetStat( BCS_Essence ) * 0.0625; 
				}
			}

			dmg.SetHitReactionType( EHRT_Heavy, true);

			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) );

			dmg.AddEffectInfo( EET_Burning, 1 );

			dmg.SetForceExplosionDismemberment();
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
		}
	}

	function kestral_lightning_interior() 
	{
		var actortarget 						: CActor;
		var dmg									: W3DamageAction;
		var damageMax, damageMin				: float;
		var fxent                        	  	: CEntity;
    	var temp                  				: CEntityTemplate;
    	var path                   				: string;
		var targetpos							: Vector;
		
		if (kestral_can_perform_lightning())
		{
			refresh_kestral_lightning_cooldown();

			actortarget = (CActor)thePlayer.moveTarget;

			if (actortarget)
			{
				path = "dlc\dlc_acs\data\entities\other\fx_dummy_entity_ifrit.w2ent";
			
				temp = (CEntityTemplate)LoadResource(path,true);

				targetpos = actortarget.GetWorldPosition();
				targetpos.Z += 1;

				fxent = (CEntity)theGame.CreateEntity(temp, targetpos, actortarget.GetWorldRotation());

				fxent.CreateAttachment(actortarget,, Vector( 0, 0, 1 ), EulerAngles(0,0,0));

				fxent.PlayEffect('hit_fire');

				fxent.DestroyAfter(3);

				this.StopEffect('lightning');
				this.PlayEffect('lightning', fxent);

				this.StopEffect('hit_electric');
				this.PlayEffect('hit_electric');

				dmg = new W3DamageAction in theGame.damageMgr;
				
				dmg.Initialize(thePlayer, actortarget, NULL, thePlayer.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetIgnoreImmortalityMode(false);

				dmg.SetHitAnimationPlayType(EAHA_ForceYes);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStat( BCS_Vitality ) * 0.125; 

					damageMin = actortarget.GetStat( BCS_Vitality ) * 0.0625; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					if (((CMovingPhysicalAgentComponent)(actortarget.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
					|| actortarget.GetRadius() >= 0.7
					|| actortarget.HasAbility('Boss')
					|| actortarget.HasTag('IsBoss')
					)
					{
						damageMax = actortarget.GetStat( BCS_Essence ) * 0.0625; 
					
						damageMin = actortarget.GetStat( BCS_Essence ) * 0.03125; 
					}
					else
					{
						damageMax = actortarget.GetStat( BCS_Essence ) * 0.125; 
					
						damageMin = actortarget.GetStat( BCS_Essence ) * 0.0625; 
					}
				}

				dmg.SetHitReactionType( EHRT_Heavy, true);

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, RandRangeF(damageMax,damageMin) );

				dmg.AddEffectInfo( EET_Burning, 1 );

				dmg.SetForceExplosionDismemberment();
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;	
			}
		}
	}

	timer function reveal_crow(deltaTime : float, id : int) 
	{
		DestroyEffect('teleport_in');
		PlayEffect('teleport_in');
		StopEffect('teleport_in');

		PlayEffectSingle('feathers_fx');

		StopEffect('disappear');

		if (thePlayer.IsInCombat())
		{
			RemoveTimer('kestral_lightning');
			AddTimer('kestral_lightning', 2 / theGame.GetTimeScale(), false );
		}
	}

	timer function AreaCheck(deltaTime : float, id : int) 
	{
		if(thePlayer.IsInInterior()) 
		{
			if (this.HasTag('ACS_Phoenix_Exterior'))
			{
				this.AddTag('ACS_Phoenix_Interior_Respawn');

				this.Destroy();
			}
		}
		else
		{
			if (this.HasTag('ACS_Phoenix_Interior'))
			{
				this.AddTag('ACS_Phoenix_Exterior_Respawn');

				this.Destroy();
			}
		}
	}

    timer function FollowPlayer(deltaTime : float, id : int) 
	{
		var target : CEntity;
		var targetPosition, attackposition : Vector;
		var targetRotation : EulerAngles;
		
        var playerPosition : Vector;
        var playerRotation : EulerAngles;      
        
        var goalAcceleration : Vector;
        var navigationComputeZReturn : float;  
 
        var rotationCircleRadius : float;
        var rotationCircleMovementSpeed : float;
        var selfRotationSpeed : float;
        var maxAcceleration : float;      
        var accelerationMultiplier : float;
        var maxVelocity : float;
        var velocityDampeningFactor : float;

		var lookatents										: array<CGameplayEntity>;
		var i, j											: int;

		var gameLightComp, gameInteractComp 				: CComponent;

		var pos, lookatentsPos								 : Vector;

		var targetDistance									: float;

		var bonePos															: Vector;

		if (this.HasTag('ACS_Phoenix_Exterior'))
		{
			rotationCircleMovementSpeed = 100;
			rotationCircleRadius = 7.5;
			selfRotationSpeed = 200;
			maxAcceleration = 200;
			accelerationMultiplier = 100;
			maxVelocity = 100;
			velocityDampeningFactor = 0.9;


			wispCurrentRotationCircleAngle += deltaTime * rotationCircleMovementSpeed;
	
			while(wispCurrentRotationCircleAngle > 360) 
			{          
				wispCurrentRotationCircleAngle -= 360;                        
			}

			pos = thePlayer.GetWorldPosition();
			pos.Z += 0.8;
		
			if (thePlayer.IsInCombat())
			{
				target = thePlayer.moveTarget;
			}
			else 
			{
				lookatents.Clear();

				FindGameplayEntitiesInCone( lookatents, thePlayer.GetWorldPosition() + theCamera.GetCameraDirection(), VecHeading( theCamera.GetCameraDirection() ), 120, 120, 1, , FLAG_ExcludePlayer );

				for(i = 0; i < lookatents.Size(); i += 1)
				{
					if 
					( 
					lookatents[i] == GetWitcherPlayer() 
					|| lookatents[i] == GetACSWatcher()
					|| lookatents[i] == theCamera
					)
					{
						continue;
					}

					for( j = lookatents.Size()-1; j >= 0; j -= 1 ) 
					{	
						lookatentsPos = lookatents[j].GetWorldPosition();
						
						if ( AbsF( lookatentsPos.Z - pos.Z ) > 2.5 )
						{
							lookatents.EraseFast(j);
						}

						if (lookatents.Size() > 0)
						{
							if ( lookatents[j] = thePlayer.GetDisplayTarget())
							{
								target = thePlayer.GetDisplayTarget();
							}
							else
							{
								gameLightComp = lookatents[j].GetComponentByClassName('CGameplayLightComponent');

								gameInteractComp = lookatents[j].GetComponentByClassName('CInteractionComponent');

								if(
								(CNewNPC)lookatents[j]
								|| (COilBarrelEntity)lookatents[j]
								|| gameLightComp
								|| gameInteractComp
								|| (W3AnimationInteractionEntity)lookatents[j]
								|| (CInteractiveEntity)lookatents[j]
								|| (W3NoticeBoard)lookatents[j]
								|| (W3FastTravelEntity)lookatents[j]
								|| (W3SmartObject)lookatents[j]
								|| (W3ItemRepairObject)lookatents[j]
								|| (W3AlchemyTable)lookatents[j]
								|| (W3Stables)lookatents[j]
								|| (W3LockableEntity)lookatents[j] 
								|| (W3Poster)lookatents[j]
								|| (W3LadderInteraction)lookatents[j]
								)
								{
									target = lookatents[j];
								}
							}
						}
					}	
				}
			}

			playerPosition = TraceFloor(thePlayer.GetWorldPosition());
			targetPosition = TraceFloor(target.GetWorldPosition());

			playerRotation = thePlayer.GetWorldRotation();

			targetRotation = target.GetWorldRotation();

			if(target 
			&& (theGame.IsFocusModeActive() 
			|| (thePlayer.IsInCombat() 
			|| thePlayer.IsThreatened()) 
			&& target)
			) 
			{	
				wispGoalPosition = targetPosition;

				if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
				{
					
				}
				else
				{
					
				}
			} 
			else 
			{
				if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
				{
					
				}
				else
				{
					
				}

				wispGoalPosition = playerPosition;
			}
			
			wispGoalPosition += wispGoalPositionOffset;
			wispGoalPosition.X += CosF(Deg2Rad(wispCurrentRotationCircleAngle)) * rotationCircleRadius;
			wispGoalPosition.Y += SinF(Deg2Rad(wispCurrentRotationCircleAngle)) * rotationCircleRadius;

			if ((thePlayer.IsInCombat() 
			|| thePlayer.IsThreatened()) )
			{
				if (this.HasTag('ACS_Kestral_Attack_Mode'))
				{
					wispGoalPosition.Z += 4;
				}
				else
				{
					wispGoalPosition.Z += 4.5;
				}
			}
			else
			{
				wispGoalPosition.Z += 6;
			}
		
			attackposition = targetPosition;

			targetDistance = VecDistanceSquared2D( this.GetWorldPosition(), targetPosition ) ;

			if (thePlayer.IsInCombat())
			{
				kestral_damage();

				if (kestral_can_attack())
				{
					refresh_kestral_attack_cooldown();

					if(!this.HasTag('ACS_Kestral_Attack_Mode'))
					{
						//PlayEffect('teleport_in');
						//StopEffect('teleport_in');

						DestroyEffect('teleport_out');
						PlayEffect('teleport_out');
						//StopEffect('teleport_out');

						DestroyEffect('disappear');
						PlayEffect('disappear');

						DestroyEffect('feathers_fx');

						RemoveTimer('reveal_crow');
						AddTimer('reveal_crow', 1 / theGame.GetTimeScale(), false );

						this.AddTag('ACS_Kestral_Attack_Mode');
					}
					else if(this.HasTag('ACS_Kestral_Attack_Mode'))
					{
						//PlayEffect('teleport_in');
						//StopEffect('teleport_in');

						DestroyEffect('teleport_out');
						PlayEffect('teleport_out');
						//StopEffect('teleport_out');

						DestroyEffect('disappear');
						PlayEffect('disappear');

						DestroyEffect('feathers_fx');

						RemoveTimer('reveal_crow');
						AddTimer('reveal_crow', 1 / theGame.GetTimeScale(), false );

						this.RemoveTag('ACS_Kestral_Attack_Mode');
					}
				}

				if(!this.HasTag('ACS_Kestral_In_Combat'))
				{
					this.AddTag('ACS_Kestral_In_Combat');
				}

				if (this.HasTag('ACS_Kestral_Attack_Mode'))
				{
					wispGoalPositionOffset_regenerateInSeconds -= deltaTime;

					if(wispGoalPositionOffset_regenerateInSeconds < 0) 
					{
						wispGoalPositionOffset_regenerateInSeconds = 0.1;

						wispGoalPositionOffset = VecNormalize(attackposition) * rotationCircleRadius;

						wispGoalPositionOffset.Z -= 3;
					}
				}
				else
				{
					wispGoalPositionOffset_regenerateInSeconds -= deltaTime;

					if(wispGoalPositionOffset_regenerateInSeconds < 0) 
					{
						wispGoalPositionOffset_regenerateInSeconds = 0.1;

						wispGoalPositionOffset = VecRand() * rotationCircleRadius * 0.01;

						//wispGoalPositionOffset = VecNormalize(attackposition) * rotationCircleRadius;

						//wispGoalPositionOffset.Z += 3;
					}	
				}
			}
			else
			{
				if(this.HasTag('ACS_Kestral_Attack_Mode'))
				{
					this.RemoveTag('ACS_Kestral_Attack_Mode');
				}

				if(this.HasTag('ACS_Kestral_In_Combat'))
				{
					DestroyEffect('teleport_out');
					PlayEffect('teleport_out');

					DestroyEffect('disappear');
					PlayEffect('disappear');

					DestroyEffect('feathers_fx');

					RemoveTimer('reveal_crow');
					AddTimer('reveal_crow', 2 / theGame.GetTimeScale(), false );

					this.RemoveTag('ACS_Kestral_In_Combat');
				}

				wispGoalPositionOffset_regenerateInSeconds -= deltaTime;

				if(wispGoalPositionOffset_regenerateInSeconds < 0) 
				{
					wispGoalPositionOffset_regenerateInSeconds = 0.1;

					wispGoalPositionOffset = VecRand() * rotationCircleRadius * 0.01;
				}	
			}
			
			wispCurrentAcceleration = (wispGoalPosition - wispCurrentPosition) * accelerationMultiplier;
	
			if(VecLength(wispCurrentAcceleration) > maxAcceleration) 
			{
				wispCurrentAcceleration = VecNormalize(wispCurrentAcceleration) * maxAcceleration;
			}

			wispCurrentVelocity += wispCurrentAcceleration * deltaTime;

			wispCurrentVelocity *= velocityDampeningFactor;

			if(VecLength(wispCurrentVelocity) > maxVelocity) 
			{
				wispCurrentVelocity = VecNormalize(wispCurrentVelocity) * maxVelocity;
			}
	
			if (theGame.GetWorld().NavigationComputeZ( wispCurrentPosition, wispCurrentPosition.Z - 2, wispCurrentPosition.Z + 2, navigationComputeZReturn ) )
			{
				if(AbsF(wispCurrentPosition.Z - navigationComputeZReturn) < 0.1) 
				{
					wispCurrentVelocity.Z *= -0.9;
				}
			}

			wispCurrentPosition += wispCurrentVelocity * deltaTime;
	
			if(VecDistance(wispCurrentPosition, wispGoalPosition) > 100) {
				wispCurrentPosition = wispGoalPosition;
				wispCurrentVelocity = Vector(0,0,0);
				wispCurrentAcceleration = Vector(0,0,0);
			}
	
			wispCurrentRotation.Roll = -45;
			wispCurrentRotation.Yaw += deltaTime * rotationCircleMovementSpeed;
		}
		else if (this.HasTag('ACS_Phoenix_Interior'))
		{
			bonePos = MatrixGetTranslation(thePlayer.GetBoneWorldMatrixByIndex(thePlayer.GetBoneIndex( 'l_shoulder' )));

			wispCurrentPosition = bonePos + (thePlayer.GetWorldRight() * -0.5) + (thePlayer.GetWorldUp() * 0.5) + (thePlayer.GetWorldForward() * -0.25);

			wispCurrentRotation = thePlayer.GetWorldRotation();

			if (thePlayer.IsInCombat())
			{
				if (thePlayer.GetTarget())
				{
					kestral_lightning_interior();
				}
			}
		}
			
		this.TeleportWithRotation(wispCurrentPosition, wispCurrentRotation); 
    }   
}

function ACS_PhoenixCheck()
{
	var entity                          										:  CEntity;
	var temp1, temp2                  											:  CEntityTemplate;
    var path1, path2                   											:  string;

	if (FactsQuerySum("ACS_Phoenix_Released") > 0 && thePlayer.inv.HasItem('acs_phoenix_ashes'))
	{
		ACSPhoenix().Destroy();

		ACSGetCEntityDestroyAll('ACS_Phoenix');

		if (thePlayer.inv.HasItem('acs_phoenix_ashes'))
		{
			if (thePlayer.IsInInterior())
			{
				path2 = "dlc\dlc_acs\data\entities\items\acs_phoenix_interior.w2ent";

				temp2 = (CEntityTemplate)LoadResource(path2,true);

				entity = (W3ACSPhoenix)theGame.CreateEntity(temp2, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

				entity.AddTag('ACS_Phoenix_Interior');
			}
			else
			{
				path1 = "dlc\dlc_acs\data\entities\items\acs_phoenix.w2ent";

				temp1 = (CEntityTemplate)LoadResource(path1,true);

				entity = (W3ACSPhoenix)theGame.CreateEntity(temp1, thePlayer.GetWorldPosition() + Vector(0,0,2), thePlayer.GetWorldRotation());

				entity.AddTag('ACS_Phoenix_Exterior');
			}

			entity.AddTag('ACS_Phoenix');
		}
		else
		{
			FactsRemove("ACS_Phoenix_Released");
		}
	}
}

function ACSPhoenix() : W3ACSPhoenix
{
	var entity 			 : W3ACSPhoenix;
	
	entity = (W3ACSPhoenix)theGame.GetEntityByTag( 'ACS_Phoenix' );
	
	return entity;
}

///////////////////////////////////////////////////////////////////////////////////////////

class W3ACSWolfHeartItem extends W3QuestUsableItem
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			GetACSWatcher().AddTimer('ACS_Wolf_Heart_Tutorial_Delay', 1 / theGame.GetTimeScale(), false );
			
			if (
			FactsQuerySum("acs_wolf_companion_summoned") <= 0
			)
			{
				GetACSWatcher().ManageFollower();

				FactsAdd("acs_wolf_companion_summoned", 1, -1);
			}
			else  if (
			FactsQuerySum("acs_wolf_companion_summoned") > 0
			)
			{
				if (
				FactsQuerySum("acs_wolf_companion_command_stay") <= 0
				)
				{
					GetACSWatcher().ManageFollower();

					FactsAdd("acs_wolf_companion_command_stay", 1, -1);
				}
				else  if (
				FactsQuerySum("acs_wolf_companion_command_stay") > 0
				)
				{ 
					GetACSWatcher().DestroyFollower();

					FactsRemove("acs_wolf_companion_command_stay");

					FactsRemove("acs_wolf_companion_summoned");
				}
			}
		}		
	}
}

///////////////////////////////////////////////////////////////////////////////////////////

class W3ACSKillCountBookItem extends W3QuestUsableItem
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		var item 															: SItemUniqueId;
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var attach_vec														: Vector;
		var attach_rot														: EulerAngles;
		var timeToDestroy, h												: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;

		super.OnSpawned(spawnData);

		ACSGetCEntity('ACS_Book').Destroy();

		temp = (CEntityTemplate)LoadResource(

		//"items\readable_books\readable_books_source\elven_sages_full.w2ent"

		"items\readable_books\readable_books_source\basics_of_magic_full.w2ent"

		, true );

		ent = theGame.CreateEntity( temp, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

		attach_rot.Roll = 0;
		attach_rot.Pitch = 90;
		attach_rot.Yaw = -45;
		attach_vec.X = 0.05;
		attach_vec.Y = -0.075;
		attach_vec.Z = 0;

		ent.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );

		ent.AddTag('ACS_Book');
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			GetACSWatcher().RemoveTimer('KillCountMenuDisplayDelay');

			GetACSWatcher().AddTimer('KillCountMenuDisplayDelay', 0.5 / theGame.GetTimeScale(), false );
		}		
	}

	event OnHidden( hiddenBy : CEntity )
	{
		super.OnHidden(hiddenBy);

		if ( hiddenBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			GetACSWatcher().RemoveTimer('KillCountMenuDisplayDelay');

			ACSGetCEntity('ACS_Book').BreakAttachment();

			ACSGetCEntity('ACS_Book').Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );

			ACSGetCEntity('ACS_Book').DestroyAfter(0.00125);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////

class W3ACSSchoolMedallionItem extends W3QuestUsableItem
{

}

///////////////////////////////////////////////////////////////////////////////////////////

class W3ACSPirateAmuletItem extends W3QuestUsableItem
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			GetACSWatcher().AddTimer('ACS_Pirate_Amulet_Tutorial_Delay', 1 / theGame.GetTimeScale(), false );
			
			if (RandF() < 0.5)
			{
				if (GetWeatherConditionName() != 'WT_Clear')
				{
					RequestWeatherChangeTo('WT_Clear', 1.0, false);
				}
			}
			else
			{
				if (!ACSGetCActor('ACS_Melusine')
				|| !ACSGetCActor('ACS_Melusine').IsAlive())
				{
					if (GetWeatherConditionName() != 'WT_Rain_Storm')
					{
						RequestWeatherChangeTo('WT_Rain_Storm', 5.0, false);
					}

					GetACSWatcher().Lightning_Strike_No_Condition();

					GetACSWatcher().RemoveTimer('MelusineSpawnDelay');
					GetACSWatcher().AddTimer('MelusineSpawnDelay', RandRangeF(10,5) / theGame.GetTimeScale(), false );
				}
				else
				{
					if (GetWeatherConditionName() != 'WT_Rain_Storm')
					{
						RequestWeatherChangeTo('WT_Rain_Storm', 1.0, false);
					}
				}
			}
		}		
	}
}

///////////////////////////////////////////////////////////////////////////////////////////

class W3ACSDullahanSteedSummonItem extends W3QuestUsableItem
{

}

function ACS_SummonDullahanSteed()
{
	var initpos, targetPosition_1				: Vector;
	var meteor_proj_1 							: W3ACSDullahanProjectile;

	initpos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 25 + theCamera.GetCameraRight() * RandRangeF(50,-50);	

	initpos.Z += 50;			
				
	targetPosition_1 = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 25;

	meteor_proj_1 = (W3ACSDullahanProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\dullahan_proj_meteorite_big.w2ent", true ), initpos, thePlayer.GetWorldRotation() );

	meteor_proj_1.Init(NULL);
	meteor_proj_1.AddTag('ACS_Dullahan_Steed_Spawning_Proj');
	meteor_proj_1.ShootProjectileAtPosition( 0, 15, targetPosition_1, 500 );
	meteor_proj_1.DestroyAfter(20);
}


///////////////////////////////////////////////////////////////////////////////////////////

class W3ACSTrophyItem extends W3QuestUsableItem
{
	var ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	var rot, attach_rot                        						 	: EulerAngles;
    var pos, attach_vec													: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var camera 															: CCustomCamera;

	var actors		    												: array<CActor>;
	var i 																: int;

	var trophy_name														: string;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		var horse : CNewNPC;	
		var trophy_path : string;
		var trophy_attach_vector : Vector;

		super.OnSpawned(spawnData);

		rot = thePlayer.GetWorldRotation();

		pos = thePlayer.GetWorldPosition();

		if (!thePlayer.IsUsingHorse()
		&& !thePlayer.IsUsingVehicle()
		)
		{
			ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\entities\other\acs_fear_entity.w2ent"

			, true ), pos, rot );

			ent_1.AddTag('ACS_Fear_Ent');

			animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_1.GetComponentByClassName('CMeshComponent');
			h = 0;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			animcomp.FreezePose();

			((CNewNPC)ent_1).SetAttitude(thePlayer, AIA_Friendly);

			if (thePlayer.GetTarget())
			{
				((CNewNPC)ent_1).SetAttitude(((CNewNPC)thePlayer.GetTarget()), AIA_Hostile);
			}

			((CNewNPC)ent_1).SetCanPlayHitAnim(false);

			((CNewNPC)ent_1).EnableCollisions(false);

			((CNewNPC)ent_1).EnableCharacterCollisions(false);

			((CActor)ent_1).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

			ent_1.CreateAttachment( thePlayer, , Vector( 0, 0, 2 ), EulerAngles(0,90,0) );
		}
			
		//ent.PlayEffectSingle('fear_icon_activate');

		if (GetACSWatcher().use_horse_trophy)
		{
			horse = thePlayer.GetHorseWithInventory();

			horse.ACS_HorseTrophyVisibility(false, trophy_name);
		}
		else
		{
			trophy_name = GetACSWatcher().trophy_name_to_use;
		}
		
		switch(trophy_name)
		{
			case "mq7018_basilisk_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\basilisk_white\acs_trophy_basilisk_white.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh201_cave_troll_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\cave_troll\acs_trophy_cave_troll.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh101_cockatrice_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\cockatris\acs_trophy_cockatris.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "acs_cyklop_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\cyklop\acs_cyklop_trophy.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh107_czart_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\czart\acs_trophy_czart.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh104_ekimma_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\ekima\acs_trophy_ekima.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "q704_garkain_trophy":
				if (RandF() < 0.5)
				{
					trophy_path = "dlc\dlc_acs\data\models\trophies\garkain\acs_garkain_trophy.w2ent";
				}
				else
				{
					trophy_path = "dlc\dlc_acs\data\models\trophies\garkain_mh\acs_garkain_mh_trophy.w2ent";
				}

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "q701_cyclops_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\giant_windmill\acs_giant_windmill_trophy.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "q002_griffin_trophy":
			case "mq7009_griffin_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\gryphon\acs_gryphon_trophy.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh301_gryphon_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\gryphon_mh\acs_gryphon_mh_trophy.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh304_katakan_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\katakan\acs_trophy_katakan.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh204_leshy_trophy":
			case "mh205_leshy_trophy":
			case "mh302_leshy_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\lessun\acs_trophy_lessun.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mq7010_dracolizard_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\oszluzg\acs_trophy_oszluzg.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh701_sharley_matriarch_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\sharley\acs_sharley_trophy.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "q702_wicht_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\spooncollector\acs_trophy_spooncollector_01.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mq7002_spriggan_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\spriggan\acs_spriggan_trophy.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh105_wyvern_trophy":
			case "mq1051_wyvern_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\wyvern\acs_wyvern_trophy.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh211_bies_trophy":
			case "mh206_fiend_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\bies\acs_trophy_bies.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			case "mh208_forktail_trophy":
				trophy_path = "dlc\dlc_acs\data\models\trophies\forktail\acs_trophy_forktail.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;

			default:
				trophy_path = "dlc\dlc_acs\data\models\trophies\universal\acs_trophy_universal.w2ent";

				trophy_attach_vector = Vector( 0, 0, 0.3 );
			break;
		}

		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		trophy_path

		, true ), pos, rot );

		ent_2.CreateAttachment( this, 'fx', trophy_attach_vector, EulerAngles(0,0,0) );

		theSound.SoundEvent("gui_global_loot");

		RemoveTimer('blood_drip_fx_loop');
		AddTimer('blood_drip_fx_loop', 0.001, true);

	}

	timer function blood_drip_fx_loop( time : float , id : int )
	{
		if (!IsEffectActive('blood_drip', false))
		{
			PlayEffectSingle('blood_drip');
		}
	}
	
	event OnUsed( usedBy : CEntity )
	{
		super.OnUsed( usedBy );

		if ( usedBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			
		}		
	}

	event OnHidden( hiddenBy : CEntity )
	{
		var horse : CNewNPC;	
		var distance_from_horse : float;

		super.OnHidden(hiddenBy);

		if ( hiddenBy == GetWitcherPlayer() )
		{
			if (!GetACSWatcher())
			{
				return false;
			}

			RemoveTimer('blood_drip_fx_loop');

			ent_1.Destroy();

			ent_2.BreakAttachment();

			ent_2.Teleport(this.GetWorldPosition() + Vector(0,0,-200));

			ent_2.DestroyAfter(0.125f);

			horse = thePlayer.GetHorseWithInventory();

			theSound.SoundEvent("gui_inventory_armor_attach");

			horse.ACS_HorseTrophyVisibility(true, trophy_name);
		}
	}
}