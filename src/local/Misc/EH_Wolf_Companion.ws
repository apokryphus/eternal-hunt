statemachine class CACSWolfCompanion extends CNewNPC
{
	private saved var aiTreeFollow : CAIFollowSideBySideAction;
	private saved var actionID : int;
	
	private saved var npcScale : float;
	private saved var npcSpeed : float;
	private saved var isFollowing : bool;
	public saved var shouldFollow : bool;
	
	default npcScale = 1.5f;
	default npcSpeed = 1.25f;
	default isFollowing = false;
	default shouldFollow = true;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		npcScale = 1.5f;
			
		npcSpeed = 1.25f;
			
		super.OnSpawned(spawnData);
		AddTag('ACS_Companion_Wolf');

		PlayEffectSingle('demonic_posession');

		PlayEffectSingle('fire_breath');
		StopEffect('fire_breath');

		PlayEffectSingle('shadow_form');
		PlayEffectSingle('critical_burning_red');

		PlayEffectSingle('critical_burning_red_alt');

		SetAttitude(GetWitcherPlayer(), AIA_Friendly);

		SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);

		SignalGameplayEvent('AxiiGuardMeAdded');
		SignalGameplayEvent('NoticedObjectReevaluation');
		SetScale();
		SetSpeed();

		SetImmortalityMode(AIM_Immortal, AIC_Default);
			
		if( shouldFollow )
			GotoState('CACSWolfCompanionFollowing');
		else
			GotoState('CACSWolfCompanionIdle');
	}
	
	event OnTakeDamage( action : W3DamageAction )
	{
		super.OnTakeDamage(action);
	}
	
	event OnDeath( damageData : W3DamageAction )
	{
		super.OnDeath(damageData);
		GetACSWatcher().RemoveFollower();
	}
	
	event OnInteraction( actionName : string, activator : CEntity ) {}
	
	event OnInteractionActivationTest( interactionComponentName : string, activator : CEntity ) {}
	
	event OnInteractionActivated( interactionComponentName : string, activator : CEntity ) {}
	
	event OnInteractionDeactivated( interactionComponentName : string, activator : CEntity ) {}
	
	event OnCompanionInteraction()
	{
		shouldFollow = !shouldFollow;
		if( shouldFollow )
		{
			GetACSWatcher().SetIsWolfFollowing(true);
			GotoState('CACSWolfCompanionFollowing');
		}
		else
		{
			GetACSWatcher().SetIsWolfFollowing(false);
			GotoState('CACSWolfCompanionIdle');
		}
	}
	
	public function StartFollowing() 
	{
		if( !isFollowing )
		{
			aiTreeFollow = new CAIFollowSideBySideAction in this;
			aiTreeFollow.OnCreated();
			aiTreeFollow.params.targetTag = 'PLAYER';
			aiTreeFollow.params.moveSpeed = 6;
			aiTreeFollow.params.teleportToCatchup = true;
			
			actionID = ForceAIBehavior(aiTreeFollow, BTAP_Emergency);
			if( actionID )
			{
				//GetMovingAgentComponent().SetDirectionChangeRate(0.16);
				GetMovingAgentComponent().SetDirectionChangeRate(10000);
				GetMovingAgentComponent().SetMaxMoveRotationPerSec(60);
				isFollowing = true;
			}
		}
	}
	
	public function StopFollowing() : void
	{
		if( isFollowing )
		{
			CancelAIBehavior(actionID);
			delete aiTreeFollow;
			isFollowing = false;
		}
	}
	
	private function SetScale() : void
	{
		var animComps : array<CComponent>;
		var localScale : Vector;
		var i : int;
		
		if( npcScale == 1 )
			return;
			
		animComps = GetComponentsByClassName('CAnimatedComponent');
		for(i=0; i<animComps.Size(); i+=1)
		{
			if( animComps[i] )
			{
				localScale = animComps[i].GetLocalScale();
				animComps[i].SetScale(localScale * npcScale);
			}
		}
	}	
	
	private var npcSpeedMultID : int;	default npcSpeedMultID = -1;
	private function SetSpeed() : void
	{
		npcSpeedMultID = SetAnimationSpeedMultiplier(npcSpeed, npcSpeedMultID);
	}

	function ACS_CompanionWolfForceAttitude()
	{
		var actor							: CActor; 
		var actors		    				: array<CActor>;
		var i								: int;
		var npc								: CNewNPC;
		var targetDistance					: float;
		
		actors.Clear();

		actors = thePlayer.GetNPCsAndPlayersInRange( 50, 999, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (actor.GetAttitude(thePlayer) == AIA_Hostile)
				{
					((CNewNPC)actor).SetAttitude(GetACSWolfCompanion(), AIA_Hostile);

					GetACSWolfCompanion().SetAttitude(((CNewNPC)actor), AIA_Hostile);
				}
				else
				{
					((CNewNPC)actor).SetAttitude(GetACSWolfCompanion(), AIA_Neutral);

					GetACSWolfCompanion().SetAttitude(((CNewNPC)actor), AIA_Neutral);
				}
			}
		}

		if (GetACSWolfCompanion().GetStat(BCS_Stamina) < GetACSWolfCompanion().GetStatMax(BCS_Stamina))
		{
			GetACSWolfCompanion().GainStat(BCS_Stamina, GetACSWolfCompanion().GetStatMax(BCS_Stamina) );
		}

		if (GetACSWolfCompanion().GetStat(BCS_Morale) < GetACSWolfCompanion().GetStatMax(BCS_Morale))
		{
			GetACSWolfCompanion().GainStat(BCS_Morale, GetACSWolfCompanion().GetStatMax(BCS_Morale) );
		}
	}
}

state CACSWolfCompanionFollowing in CACSWolfCompanion
{
	event OnEnterState( prevStateName : name )
	{
		FollowTickTimer();
	}
	
	event OnLeaveState( nextStateName : name )
	{
		parent.StopFollowing();
	}

	entry function FollowTickTimer()
	{
		var distanceToFollower : float;
		
		while(true)
		{
			distanceToFollower = VecDistanceSquared2D(parent.GetWorldPosition(), thePlayer.GetWorldPosition());

			if( distanceToFollower <= 2 * 2 )
			{
				if (thePlayer.IsUsingVehicle()
				|| thePlayer.IsUsingHorse())
				{
					if ( (theInput.GetActionValue('GI_AxisLeftY') == 0
					&& theInput.GetActionValue('GI_AxisLeftX') == 0)
					)
					{
						parent.StopFollowing();

						parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0.f);
					}
				}
				else
				{
					if(!thePlayer.GetIsSprinting()
					&& !thePlayer.GetIsRunning()
					)
					{
						parent.StopFollowing();

						parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0.f);
					}
				}
				
				if (!GetACSWolfCompanion().IsEffectActive('shadows_form', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('shadows_form');
				}

				if (GetACSWolfCompanion().IsEffectActive('critical_burning_red', false)
				)
				{
					GetACSWolfCompanion().StopEffect('critical_burning_red');
				}

				if (GetACSWolfCompanion().IsEffectActive('critical_burning_red_alt', false)
				)
				{
					GetACSWolfCompanion().StopEffect('critical_burning_red_alt');
				}

				GetACSWolfCompanion().EnableCharacterCollisions(false);
			}
			else if( distanceToFollower > 2 * 2 && distanceToFollower <= 3.5 * 3.5)
			{
				if (thePlayer.IsUsingVehicle()
				|| thePlayer.IsUsingHorse())
				{
					if ( (theInput.GetActionValue('GI_AxisLeftY') == 0
					&& theInput.GetActionValue('GI_AxisLeftX') == 0)
					)
					{
						parent.StopFollowing();

						parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0.f);
					}
				}
				else
				{
					if(!thePlayer.GetIsSprinting()
					&& !thePlayer.GetIsRunning()
					)
					{
						parent.StopFollowing();

						parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0.f);
					}
				}

				if (GetACSWolfCompanion().IsEffectActive('shadows_form', false)
				)
				{
					GetACSWolfCompanion().StopEffect('shadows_form');
				}

				if (!GetACSWolfCompanion().IsEffectActive('critical_burning_red', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('critical_burning_red');
				}

				if (!GetACSWolfCompanion().IsEffectActive('critical_burning_red_alt', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('critical_burning_red_alt');
				}

				GetACSWolfCompanion().EnableCharacterCollisions(true);
			}
			else if( distanceToFollower > 3.5 * 3.5 && distanceToFollower <= 10 * 10 )
			{
				parent.StartFollowing();

				if (thePlayer.IsUsingVehicle()
				|| thePlayer.IsUsingHorse())
				{
					parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(1.f);
				}
				else
				{
					if(!thePlayer.GetIsSprinting()
					&& !thePlayer.GetIsRunning())
					{
						parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0.5f);
					}
					else
					{
						parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(1.f);
					}
				}
				
				if (GetACSWolfCompanion().IsEffectActive('shadows_form', false)
				)
				{
					GetACSWolfCompanion().StopEffect('shadows_form');
				}

				if (!GetACSWolfCompanion().IsEffectActive('critical_burning_red', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('critical_burning_red');
				}

				if (!GetACSWolfCompanion().IsEffectActive('critical_burning_red_alt', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('critical_burning_red_alt');
				}

				GetACSWolfCompanion().EnableCharacterCollisions(true);
			}
			else if( distanceToFollower > 10 * 10 )
			{
				parent.StartFollowing();

				parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(1.f);
				
				if (GetACSWolfCompanion().IsEffectActive('shadows_form', false)
				)
				{
					GetACSWolfCompanion().StopEffect('shadows_form');
				}

				if (!GetACSWolfCompanion().IsEffectActive('critical_burning_red', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('critical_burning_red');
				}

				if (!GetACSWolfCompanion().IsEffectActive('critical_burning_red_alt', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('critical_burning_red_alt');
				}

				GetACSWolfCompanion().EnableCharacterCollisions(true);
			}

			parent.ACS_CompanionWolfForceAttitude();

			SleepOneFrame();
		}
	}
}

state CACSWolfCompanionIdle in CACSWolfCompanion extends NewIdle
{
	event OnEnterState( prevStateName : name )
	{
		super.OnEnterState(prevStateName);

		IdleAction();

		IdleTickTimer();
	}

	function IdleAction()
	{
		var animatedComponentA								: CAnimatedComponent;

		animatedComponentA = (CAnimatedComponent)(GetACSWolfCompanion()).GetComponentByClassName( 'CAnimatedComponent' );	

		if (RandF() < 0.5)
		{
			((CActor)GetACSWolfCompanion()).SoundEvent("monster_barghest_voice_howl");

			animatedComponentA.PlaySlotAnimationAsync ( 'wolf_rolling', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.85f));
		}
		else
		{
			animatedComponentA.PlaySlotAnimationAsync ( 'wolf_howling_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.85f));
		}

		GetACSWolfCompanion().PlayEffectSingle('fire_breath');
		GetACSWolfCompanion().StopEffect('fire_breath');
	}

	entry function IdleTickTimer()
	{
		var distanceToFollower : float;
		
		while(true)
		{
			distanceToFollower = VecDistanceSquared2D(parent.GetWorldPosition(), thePlayer.GetWorldPosition());

			if( distanceToFollower <= 2 * 2 )
			{
				if (!GetACSWolfCompanion().IsEffectActive('shadows_form', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('shadows_form');
				}

				if (GetACSWolfCompanion().IsEffectActive('critical_burning_red', false)
				)
				{
					GetACSWolfCompanion().StopEffect('critical_burning_red');
				}

				if (GetACSWolfCompanion().IsEffectActive('critical_burning_red_alt', false)
				)
				{
					GetACSWolfCompanion().StopEffect('critical_burning_red_alt');
				}

				GetACSWolfCompanion().EnableCharacterCollisions(false);
			}
			else if( distanceToFollower > 2 * 2 )
			{
				if (GetACSWolfCompanion().IsEffectActive('shadows_form', false)
				)
				{
					GetACSWolfCompanion().StopEffect('shadows_form');
				}

				if (!GetACSWolfCompanion().IsEffectActive('critical_burning_red', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('critical_burning_red');
				}

				if (!GetACSWolfCompanion().IsEffectActive('critical_burning_red_alt', false)
				)
				{
					GetACSWolfCompanion().PlayEffectSingle('critical_burning_red_alt');
				}

				GetACSWolfCompanion().EnableCharacterCollisions(true);
			}

			parent.ACS_CompanionWolfForceAttitude();

			SleepOneFrame();
		}
	}
	
	event OnLeaveState( nextStateName : name )
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSWolfCompanion() : CACSWolfCompanion
{
	var entity 			 : CACSWolfCompanion;
	
	entity = (CACSWolfCompanion)theGame.GetEntityByTag( 'ACS_Companion_Wolf' );
	return entity;
}