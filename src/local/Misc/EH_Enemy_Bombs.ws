class W3ACSPetard extends CThrowable
{
	protected editable var cameraShakeStrMin 				: float;
	protected editable var cameraShakeStrMax 				: float;
	protected editable var cameraShakeRange 				: float;
	protected editable var hitReactionType 					: EHitReactionType;
	protected editable var noLoopEffectIfHitWater			: bool;
	protected editable var dismemberOnKill 					: bool;
	protected editable var componentsEnabledOnLoop 			: array<name>;
	protected editable var friendlyFire						: bool;
	protected editable var impactParams						: SPetardParams;
	protected editable var loopParams						: SPetardParams;
	protected editable var dodgeable						: bool;
	protected editable var audioImpactName					: name;
	protected editable var ignoreBombSkills					: bool;
	protected editable var enableTrailFX 					: bool;
	protected editable var alignToNormal					: bool;
	
		hint initialBlastRadius = "Radius in which targets are collected when petard explodes";
		hint loopEffectRadius = "Radius for the lasting effect";
		hint cameraShakeRange = "Max range at which camera shake will occur";
		hint cameraShakeStrMin = "Min strength of camera shake (at max distance from center)";
		hint cameraShakeStrMax = "Max strength of camera shake (at the center of explosion)";
		hint hitReactionType = "Type of hit animation to play on target when hit by bomb. Ignored if Knockdown/Stagger used";
		hint noLoopEffectIfHitWater = "If petard hit water then there will be no loop effect or FX";
		hint dismemberOnKill = "If set then if Actor is killed by this petard it will dismember";
		hint clusterFX = "Name of FX to play when bomb cleaves into clusters";
		hint friendlyFire = "If set then the one who created bomb explosion will also be affected by it";
		hint enableTrailFX = "If set then trail fx will be played on projectile release";
		hint alignToNormal = "If set entity will align it's Z axis with collision normal";
		
	
	private const var FX_TRAIL 						: name;								
	private const var FX_CLUSTER 					: name;								
	
	protected var itemName							: name;								
	private var targetPos 							: Vector;							
	private var isProximity							: bool;								
	private var isInWater							: bool;								
	private var isInDeepWater  						: bool;								
	private var isStuck								: bool;								
	protected var isCluster							: bool;								
	private var justPlayingFXs						: array<name>;						
	protected var loopDuration						: float;							
	protected var snapCollisionGroupNames 			: array<name>;						
	protected var stopCollisions					: bool;								
	protected var previousTargets					: array<CGameplayEntity>;			
	protected var targetsSinceLastCheck				: array<CGameplayEntity>;			
	private var	wasInTutorialTrigger				: bool;								
	private var decalRemainingTimes					: array< SPetardShownDecals > ;		
	protected var impactNormal						: Vector;
	protected saved var hasImpactFireDamage			: bool;
	protected saved var hasImpactFrostDamage		: bool;
	protected saved var hasLoopFireDamage			: bool;
	protected saved var hasLoopFrostDamage			: bool;
	
		default isStuck = false;
		default isCluster = false;
		default isProximity = false;
		default isInWater = false;
		default isInDeepWater = false;
		default stopCollisions = false;
		default FX_TRAIL = 'fx_trail';
		default FX_CLUSTER = 'fx_cluster_cleave';
		default dodgeable = true;
		default enableTrailFX = true;
		
	
	
	
	event OnDestroyed()
	{
		
	}

	public function ThrowProjectile( targetPosIn : Vector )
	{		
		var phantom : CPhantomComponent;
		var inv : CInventoryComponent;
		var distanceToTarget, projectileFlightTime : float;
		var target : CActor = GetWitcherPlayer().GetTarget();
		var actorsInAoE : array<CActor>;
		var i : int;
		var collisionGroups : array<name>;
			
		
		phantom = (CPhantomComponent)GetComponent('snappingCollisionGroupNames');
		if(phantom)
		{
			phantom.GetTriggeringCollisionGroupNames(snapCollisionGroupNames);
		}
		else
		{
			snapCollisionGroupNames.PushBack('Terrain');
			snapCollisionGroupNames.PushBack('Static');
		}
		
		targetPos = targetPosIn;
		
		isProximity = false;
		
		
		BreakAttachment();

		ShootProjectileAtPosition( 20.0f, 15.0f, targetPos, theGame.params.MAX_THROW_RANGE );
		

		if ( enableTrailFX )
		{
			PlayEffectSingle(FX_TRAIL);
		}

		wasThrown = true;
		
		if ( GetOwner() != GetWitcherPlayer() )
		{
			inv = GetOwner().GetInventory();
			if(inv)
				inv.RemoveItem( itemId );
		}
	}
	
	
	event OnProjectileCollision( pos, normal : Vector, collidingComponent : CComponent, hitCollisionsGroups : array< name >, actorIndex : int, shapeIndex : int )
	{
		var depthTestPos, petardPos, collisionPos, collisionNormal, yVec : Vector;
		var template : CEntityTemplate;
		var npc : CNewNPC;
		var victim : CActor;
		var entity : CEntity;
		var rot : EulerAngles;
		var rotMatrix, m1, m2, m3 : Matrix;
		var waterEntity : CEntity; 

		if ( ( hitCollisionsGroups.Contains( 'Terrain' ) 
		//|| hitCollisionsGroups.Contains( 'Static' ) 
		|| hitCollisionsGroups.Contains( 'Foliage' ) ) 
		&& !stopCollisions )
		{
			ProcessEffect( GetWorldPosition() );
		}

		if(collidingComponent)
		{
			entity = collidingComponent.GetEntity();
		}
			
		if(collidingComponent)
		{
			victim = (CActor)entity;
			npc = (CNewNPC)(victim);	
		}

		if(entity == GetOwner())
		{
			return true;
		}

		if(stopCollisions)
			return true;
		
		impactNormal = normal;

		if ( (victim == GetWitcherPlayer() 
		|| npc == GetWitcherPlayer() )
		&& 
		(GetWitcherPlayer().IsGuarded() 
		|| GetWitcherPlayer().IsInGuardedState()
		)
		)
		{
			thePlayer.SetBehaviorVariable( 'parryType', RandRange(9) );
			thePlayer.RaiseForceEvent( 'PerformParry' );

			bounceOfVelocityPreserve = 1;

			BounceOff( normal, pos );

			this.Init( npc );

			return true;
		}
		
		theGame.VibrateControllerVeryHard();	
			
		
		if ( hitCollisionsGroups.Contains( 'Water' ) )
		{
			if(isInWater)
				return true;
				
			isInWater = true;
		
			petardPos = GetWorldPosition();
			depthTestPos = petardPos;
			depthTestPos.Z -= 1;
			
			if ( !theGame.GetWorld().StaticTrace(petardPos, depthTestPos, collisionPos, collisionNormal, snapCollisionGroupNames) )
				isInDeepWater = true;
			
			
			
			
			if(isInWater && !waterFXPlayed)
			{
				template = (CEntityTemplate)LoadResource("water_splash_small");
				waterEntity = theGame.CreateEntity(template, petardPos, GetWitcherPlayer().GetWorldRotation());				
				if(isInDeepWater)
					waterEntity.PlayEffectSingle('splash_big');
				else
					waterEntity.PlayEffectSingle('splash');
				waterFXPlayed = true;
				waterEntity.AddTag('bomb_water_splash');
				waterEntity.DestroyAfter(6.f);
				waterEntity.SoundEvent("fx_water_object_splash_small");
			}
			
			if(isInDeepWater)
			{
				stopCollisions = true;
				DestroyAfter(3);
			}
			
			return true;
		}
		
		
		if ( hitCollisionsGroups.Contains( 'Terrain' ) || hitCollisionsGroups.Contains( 'Static' ) )
		{
			StopFlying();		
			
			ProcessEffect( pos );
		}
		
		if( alignToNormal )
		{
			
			
			
			m1 = MatrixBuildFromDirectionVector( normal );
			m2 = MatrixBuiltRotation( EulerAngles( -90, 0, 0 ) );
			m3 = m1 * m2;
			rot = MatrixGetRotation( m3 );
			
			TeleportWithRotation( GetWorldPosition(), rot );
			
		}
	}
	
	private var waterFXPlayed : bool;
	
	
	
	protected function StopFlying()
	{		
		if( enableTrailFX )
		{
			StopEffect(FX_TRAIL);
		}
		stopCollisions = true;
		StopProjectile();
	}
		
	event OnRangeReached()
	{	
		StopFlying();
		ProcessEffect();
	}
	
	
	public function ProcessEffect( optional explosionPosition : Vector, optional collidedTarget : CGameplayEntity )
	{
		var targets, additionalTargets : array< CGameplayEntity >;
		var i : int;
		var victimTags, attackerTags : array<name>;
		var dist, camShakeStr, camShakeStrFrac : float;
		var temp, isPerk16Active : bool;
		var phantom : CPhantomComponent;
		var meshes : array<CComponent>;
		var mesh : CMeshComponent;
		var npc : CNewNPC;
		
		
		if(isInDeepWater || (noLoopEffectIfHitWater && isInWater) )
		{
			Destroy();
			return;
		}
		
		
		stopCollisions = true;
		
		
		meshes = GetComponentsByClassName('CMeshComponent');
		for(i=0; i<meshes.Size(); i+=1)
		{
			mesh = (CMeshComponent)meshes[i];
			if( !mesh )
			{
				continue;
			}
			
			mesh.SetVisible(false);
			mesh.SetEnabled(false);
		}
		
		
		if ( explosionPosition == Vector( 0, 0, 0 ) )
		{
			explosionPosition = this.GetWorldPosition();
		}
		
		
		explosionPosition = explosionPosition + Vector( 0.0f, 0.0f, 0.1f );
		FindGameplayEntitiesInSphere(targets, explosionPosition, impactParams.range, 1000, '', FLAG_TestLineOfSight);	
		
		if( targets.Size() == 0 )
		{
			explosionPosition = explosionPosition - Vector( 0.0f, 0.0f, 0.2f ); 
			FindGameplayEntitiesInSphere(targets, explosionPosition, impactParams.range, 1000, '', FLAG_TestLineOfSight);	
		}
		
		
		if ( additionalTargets.Size() > 0 )
		{
			for ( i = 0 ; i < additionalTargets.Size() ; i += 1 )
			{
				if ( !targets.Contains( additionalTargets[i] ) )
				{
					targets.PushBack( additionalTargets[i] );
				}
			}
		}
		
		if(collidedTarget && !targets.Contains(collidedTarget))
			targets.PushBack(collidedTarget);
			
		if( caster == GetWitcherPlayer() && GetWitcherPlayer().CanUseSkill( S_Perk_16 ) )
		{
			isPerk16Active = true;
		}
		
		
		SnapComponents(true);
				
		
		ProcessMechanicalEffect(targets, true);
		
		
		if(cameraShakeStrMin + cameraShakeStrMax > 0)	
		{
			dist = VecDistance(GetOwner().GetWorldPosition(), GetWorldPosition());
			
			if(dist <= cameraShakeRange)
			{
				camShakeStrFrac = (cameraShakeRange - dist) / cameraShakeRange;
				camShakeStr = cameraShakeStrMin + camShakeStrFrac * (cameraShakeStrMax - cameraShakeStrMin);
				
				
				GCameraShake(camShakeStr, true, GetWorldPosition(), impactParams.range * 2);
			}
		}
		
		
		theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( this, 'BombExplosionAction', 10.0, 50.0f, -1, -1, true); 
		
		
		ProcessEffectPlayFXs(true);

		ApplyAppearance("invisible");
	}

	protected function SnapComponents(isImpact : bool)
	{
		var params : SPetardParams;
		var i : int;
		var pos : Vector;
		
		if(isImpact)
			params = impactParams;
		else
			params = loopParams;
			
		for(i=0; i<params.componentsToSnap.Size(); i+=1)
			SnapComponentByName(params.componentsToSnap[i], 2, 0.25, snapCollisionGroupNames, pos);
	}
	

	protected function ProcessEffectPlayFXs(isImpact : bool)
	{
		var params : SPetardParams;
		var i : int;
		var fx : array<name>;
		var decalRandomID : int;
	
		if(isImpact)
			params = impactParams;
		else
			params = loopParams;
			
		
		if(isInWater)
		{
			if(isCluster && params.fxClusterWater.Size() > 0)
			{
				fx = params.fxClusterWater;
			}
			else
			{
				fx = params.fxWater;
			}
		}
		else
		{
			if(isCluster && params.fxCluster.Size() > 0)
			{
				fx = params.fxCluster;
			}
			else
			{
				fx = params.fx;
			}
		}
		
		
		for(i=0; i<fx.Size(); i+=1)
			PlayEffectInternal(fx[i]);
			
		
		if( params.decalComponentNames.Size() > 0 )
		{
			decalRemainingTimes.Resize( params.decalComponentNames.Size() );
			
			if( params.decalComponentUseRandom )		
			{
				decalRandomID = RandRange( 0 , params.decalComponentNames.Size() );
				ShowDecalComponent( decalRandomID, params );
			}
			else										
			{
				for( i=0; i<params.decalComponentNames.Size(); i+= 1)
				{
					ShowDecalComponent( i, params );
				}
			}
		}
	}
	
	private function ShowDecalComponent ( decalID : int, params : SPetardParams )
	{
		var decalComp : CDecalComponent;
		var decalScale : Vector;
		var scaleModifier : float;
		
		decalComp = ( CDecalComponent ) GetComponent( params.decalComponentNames[ decalID ] );
					
		if( decalComp )
		{
			if( params.decalComponentScaleModifier )
			{
				scaleModifier = params.decalComponentScaleModifier;
				scaleModifier = RandRangeF( scaleModifier, -scaleModifier);
				
				decalScale = decalComp.GetLocalScale();
				decalScale = decalScale * ( 1 + scaleModifier );
				
				decalComp.SetScale( decalScale );
			}

			decalComp.SetVisible( true ) ;
			decalRemainingTimes[ decalID ].remainingShowTime = params.decalComponentVisibleTimes[ decalID ];
			decalRemainingTimes[ decalID ].componentName = params.decalComponentNames[ decalID ];
		}
	}

	
	protected function ProcessMechanicalEffect(targets : array<CGameplayEntity>, isImpact : bool, optional dt : float)
	{			
		var i, index, j, k : int;
		var action : W3DamageAction;
		var none : SAbilityAttributeValue;
		var atts : array<name>;
		var newDamage : SRawDamage;
		var params : SPetardParams;
		var attackerTags, allVictimsTags, targetTags : array<name>;
		var dm : CDefinitionsManagerAccessor;
		var actorTarget : CActor;
		var surface	: CGameplayFXSurfacePost;		
		var successfullBlock, canUsePerk20 : bool;
		var hitType : EHitReactionType;
		var npc : CNewNPC;
		var DoTBuff : W3BuffDoTParams;
		var damageMax, maxTargetVitality, maxTargetEssence	: float;
		var paramsKnockdown, paramsDrunkEffect 				: SCustomEffectParams;
	
		
		for(i=targets.Size()-1; i>=0; i-=1)
		{
			
			if( (CActionPoint)targets[i] || (W3ACSPetard)targets[i] )
			{
				targets.Erase(i);
				continue;
			}
			
			if(GetAttitudeBetween(GetOwner(), targets[i]) == AIA_Friendly)
			{
				actorTarget = (CActor)targets[i];
				
				
				if(!actorTarget || (targets[i] == GetOwner() && GetOwner() == GetWitcherPlayer()))
					continue;
				
				
				targets.Erase(i);
			}
		}
		
		
		
		
		if(isImpact)
			params = impactParams;
		else
			params = loopParams;
			
		
		if(params.surfaceFX.fxType >= 0 && !isInWater)
		{
			surface = theGame.GetSurfacePostFX();
			surface.AddSurfacePostFXGroup(GetWorldPosition(), params.surfaceFX.fxFadeInTime, params.surfaceFX.fxLastingTime, params.surfaceFX.fxFadeOutTime, params.surfaceFX.fxRadius, params.surfaceFX.fxType);
		}	
		
		if(targets.Size() == 0)
			return;				
			
		if(isImpact)
		{
			
			
		
			
			if( !ignoreBombSkills && (W3PlayerWitcher)GetOwner() && GetWitcherPlayer().CanUseSkill(S_Alchemy_s10) && !HasTag('Snowball'))
			{
				theGame.GetDefinitionsManager().GetAbilityAttributes(SkillEnumToName(S_Alchemy_s10), atts);
				
				for(j=0; j<atts.Size(); j+=1)
				{
					if(IsDamageTypeNameValid(atts[j]))
					{
						index = -1;
						for(i=0; i<params.damages.Size(); i+=1)
						{
							if(params.damages[i].dmgType == atts[j])
							{
								index = i;
								break;
							}
						}
						
						
						if(index != -1)
						{
							params.damages[index].dmgVal += CalculateAttributeValue(GetWitcherPlayer().GetSkillAttributeValue(S_Alchemy_s10, atts[j], false, true)) * GetWitcherPlayer().GetSkillLevel(S_Alchemy_s10);
						}
						else
						{
							newDamage.dmgType = atts[j];
							newDamage.dmgVal = CalculateAttributeValue(GetWitcherPlayer().GetSkillAttributeValue(S_Alchemy_s10, atts[j], false, true)) * GetWitcherPlayer().GetSkillLevel(S_Alchemy_s10);
							params.damages.PushBack(newDamage);
						}
					}
				}
			}
		}
		
		dm = theGame.GetDefinitionsManager();
					
		
		if(isImpact)
			hitType = hitReactionType;
		else
			hitType = EHRT_None;
		

		
		for(i=0; i<targets.Size(); i+=1)
		{	
			
			targetTags = targets[i].GetTags();
			ArrayOfNamesAppendUnique(allVictimsTags, targetTags);
			
			
			actorTarget = (CActor)targets[i];
			if(!actorTarget)
			{
				if( isImpact )
				{
					if( hasImpactFireDamage )
					{
						targets[i].OnFireHit(this);
					}
					if( hasImpactFrostDamage )
					{
						targets[i].OnFireHit(this);
					}
				}
				else
				{
					if( hasLoopFireDamage )
					{
						targets[i].OnFireHit(this);
					}
					if( hasLoopFrostDamage )
					{
						targets[i].OnFireHit(this);
					}
				}
				
				
				if(isFromAimThrow && wasInTutorialTrigger && ShouldProcessTutorial('TutorialThrowHold'))
				{
					for(j=0; j<targetTags.Size(); j+=1)
					{
						FactsAdd("aimthrowed_" + targetTags[j]);
					}
				}
					
				continue;
			}
			
			
			if( actorTarget && !actorTarget.IsAlive() )
			{
				continue;
			}
			
			
			action = new W3DamageAction in theGame.damageMgr;
			action.Initialize(GetOwner(), actorTarget, this, 'petard', hitType, CPS_Undefined, false, true, false, false);

			if (actorTarget == GetWitcherPlayer())
			{
				action.SetHitAnimationPlayType(params.playHitAnimMode);
				action.SetIgnoreArmor(params.ignoresArmor);
				action.SetProcessBuffsIfNoDamage(true);
				action.SetIsDoTDamage(dt);

				for(j=0; j<params.damages.Size(); j+=1)
				{
					action.AddDamage(params.damages[j].dmgType, params.damages[j].dmgVal);
				}

				for(j=0; j<params.buffs.Size(); j+=1)
				{
					
					
					
					params.buffs[j].effectCustomParam = DoTBuff;
					
					
					action.AddEffectInfo(params.buffs[j].effectType, params.buffs[j].effectDuration, params.buffs[j].effectCustomValue, params.buffs[j].effectAbilityName, params.buffs[j].effectCustomParam, params.buffs[j].applyChance);
				}
				
				if (!GetWitcherPlayer().IsAnyQuenActive()
				&& !GetWitcherPlayer().IsCurrentlyDodging()
				&& !GetWitcherPlayer().IsInAir()
				&& GetWitcherPlayer().IsOnGround()
				&& !thePlayer.HasTag('ACS_Is_Currently_Dodging')
				&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
				&& !thePlayer.HasTag('ACS_IsPerformingCombatDismember')
				)
				{
					if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
					GetWitcherPlayer().RaiseEvent( 'AttackInterrupt' );

					if (actorTarget.UsesVitality()) 
					{ 
						maxTargetVitality = actorTarget.GetStat( BCS_Vitality );

						damageMax = maxTargetVitality * RandRangeF(0.075, 0.05); 
					} 
					else if (actorTarget.UsesEssence()) 
					{ 
						maxTargetEssence = actorTarget.GetStat( BCS_Essence );
						
						damageMax = maxTargetEssence * RandRangeF(0.075, 0.05); 
					} 

					action.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, damageMax );
					
					/*
					if( !GetWitcherPlayer().HasBuff( EET_Knockdown ) ) 
					{ 	
						if(GetWitcherPlayer().IsAlive()){GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

						paramsKnockdown.effectType = EET_Knockdown;
						paramsKnockdown.creator = GetOwner();
						paramsKnockdown.sourceName = "ACS_Bomb_Effect_Custom";
						paramsKnockdown.duration = 0.25;

						GetWitcherPlayer().AddEffectCustom( paramsKnockdown ); 							
					}
					*/

					ACS_Hit_Animations(action);
				}
			}
			else
			{
				if (GetAttitudeBetween(GetOwner(), actorTarget) == AIA_Friendly
				|| GetOwner().GetAttitude( actorTarget ) == AIA_Friendly 
				|| theGame.GetGlobalAttitude( actorTarget.GetBaseAttitudeGroup(), GetOwner().GetBaseAttitudeGroup() ) == AIA_Friendly)
				{
					action.SetHitAnimationPlayType(EAHA_ForceNo); 
					action.ClearDamage(); 
					action.ClearEffects(); 
					action.SuppressHitSounds();
				}
			}

			theGame.damageMgr.ProcessAction(action);
			
			delete action;
						
			
			npc = (CNewNPC)actorTarget;
			if(npc && npc.GetNPCType() == ENGT_Guard && !npc.IsInCombat() )
			{
				npc.SignalGameplayEventParamObject('BeingHitAction', GetOwner());
				theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( npc, 'BeingHitAction', 8.0, 1.0f, 999.0f, 1, false); 
			}
		}	
	}
	
	protected function PlayEffectInternal(fx : name)
	{
		
		PlayEffectSingle(fx);
		
		
		justPlayingFXs.PushBack(fx);
	}
	
	
}



class W3ACSEnemyDimeritium extends W3ACSPetard
{
	editable var affectedFX, affectedFXCluster : name;	
	private var disableTimerCalled : bool;
	private const var DISABLED_FX_CHECK_DELAY : float;
	private var disabledFxDT : float;
	
		hint affectedFX = "Additional FX that is added when there are affected targets in the area";
		hint affectedFXCluster = "Additional FX for Clusters that is added when there are affected targets in the area";
		
		default disableTimerCalled = false;
		default DISABLED_FX_CHECK_DELAY = 1.f;
	
	protected function ProcessMechanicalEffect(targets : array<CGameplayEntity>, isImpact : bool, optional dt : float)
	{
		var i : int;
		var witcher : W3PlayerWitcher;
		var rift : CRiftEntity;
	
		super.ProcessMechanicalEffect(targets, isImpact, dt);
			
		
		witcher = GetWitcherPlayer();

		if(targets.Contains(witcher) )
		{
			if (!thePlayer.HasTag('ACS_Player_Hit_By_Dimeritium'))
			{
				witcher.CastSignAbort();

				GetWitcherPlayer().BlockAction( EIAB_Signs, 				'ACS_Dimeritium');

				if (witcher.IsAnyQuenActive())
				{
					GetWitcherPlayer().PlayEffectSingle('quen_lasting_shield_hit');

					GetWitcherPlayer().StopEffect('quen_lasting_shield_hit');

					GetWitcherPlayer().PlayEffectSingle('lasting_shield_discharge');

					GetWitcherPlayer().StopEffect('lasting_shield_discharge');

					witcher.FinishQuen(false);
				}

				ACS_Bruxa_Camo_Decoy_Deactivate();

				//GetWitcherPlayer().StopAllEffects();

				GetWitcherPlayer().StopEffect('dimeritium_hit_electricity');

				GetWitcherPlayer().StopEffect('dimeritium_hit');

				GetWitcherPlayer().PlayEffectSingle('dimeritium_hit_electricity');

				GetWitcherPlayer().PlayEffectSingle('dimeritium_hit');

				GetACSWatcher().RemoveTimer('DimeritiumHitRestore');
				GetACSWatcher().AddTimer('DimeritiumHitRestore', 3 , false);

				thePlayer.AddTag('ACS_Player_Hit_By_Dimeritium');
			}
		}
			
		
		for(i=0; i<targets.Size(); i+=1)
		{
			rift = (CRiftEntity)targets[i];
			if(rift)
			{	
				rift.PlayEffectSingle( 'rift_dimeritium' );
				rift.DeactivateRiftIfPossible();
			}
		}
	}
}