statemachine class CACSTransformationBlackWolfSummon extends CNewNPC
{
	private saved var aiTreeFollow : CAIFollowSideBySideAction;
	private saved var actionID : int;
	
	private saved var npcScale : float;
	private saved var npcSpeed : float;
	private saved var isFollowing : bool;
	public saved var shouldFollow : bool;
	
	default npcScale = 1.125;
	default npcSpeed = 1.25;
	default isFollowing = false;
	default shouldFollow = true;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		npcScale = 1.125;
			
		npcSpeed = 1.25;
			
		super.OnSpawned(spawnData);
		AddTag('ACS_Transformation_Black_Wolf_Summon');

		SetAttitude(GetWitcherPlayer(), AIA_Friendly);

		SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);

		SignalGameplayEvent('AxiiGuardMeAdded');
		SignalGameplayEvent('NoticedObjectReevaluation');
		SetScale();
		SetSpeed();

		SetImmortalityMode(AIM_Immortal, AIC_Default);
			
		if( shouldFollow )
			GotoState('Following');
		else
			GotoState('Idle');
	}
	
	event OnTakeDamage( action : W3DamageAction )
	{
		super.OnTakeDamage(action);
	}
	
	event OnDeath( damageData : W3DamageAction )
	{
		super.OnDeath(damageData);
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
			GotoState('acsBlackWolfFollowing');
		}
		else
		{
			GotoState('acsBlackWolfIdle');
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
					((CNewNPC)actor).SetAttitude(this, AIA_Hostile);

					this.SetAttitude(((CNewNPC)actor), AIA_Hostile);
				}
				else
				{
					((CNewNPC)actor).SetAttitude(this, AIA_Neutral);

					this.SetAttitude(((CNewNPC)actor), AIA_Neutral);
				}
			}
		}

		if (this.GetStat(BCS_Stamina) < this.GetStatMax(BCS_Stamina))
		{
			this.GainStat(BCS_Stamina, this.GetStatMax(BCS_Stamina) );
		}

		if (this.GetStat(BCS_Morale) < this.GetStatMax(BCS_Morale))
		{
			this.GainStat(BCS_Morale, this.GetStatMax(BCS_Morale) );
		}
	}
}

state acsBlackWolfFollowing in CACSTransformationBlackWolfSummon
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
				

				parent.EnableCharacterCollisions(false);
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

				parent.EnableCharacterCollisions(true);
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
				
				parent.EnableCharacterCollisions(true);
			}
			else if( distanceToFollower > 10 * 10 )
			{
				parent.StartFollowing();

				parent.GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(1.f);

				parent.EnableCharacterCollisions(true);
			}

			parent.ACS_CompanionWolfForceAttitude();

			SleepOneFrame();
		}
	}
}

state acsBlackWolfIdle in CACSTransformationBlackWolfSummon extends NewIdle
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

		animatedComponentA = (CAnimatedComponent)(parent).GetComponentByClassName( 'CAnimatedComponent' );	

		if (RandF() < 0.5)
		{
			((CActor)parent).SoundEvent("monster_barghest_voice_howl");

			animatedComponentA.PlaySlotAnimationAsync ( 'wolf_rolling', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.85f));
		}
		else
		{
			animatedComponentA.PlaySlotAnimationAsync ( 'wolf_howling_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.85f));
		}
	}

	entry function IdleTickTimer()
	{
		var distanceToFollower : float;
		
		while(true)
		{
			distanceToFollower = VecDistanceSquared2D(parent.GetWorldPosition(), thePlayer.GetWorldPosition());

			if( distanceToFollower <= 2 * 2 )
			{
				parent.EnableCharacterCollisions(false);
			}
			else if( distanceToFollower > 2 * 2 )
			{
				parent.EnableCharacterCollisions(true);
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