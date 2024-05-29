function ACS_TKInit()
{
	var vACS_TK : cACS_TK;
	vACS_TK = new cACS_TK in theGame;
			
	vACS_TK.ACS_TK_Engage();
	ACS_Yrden_Sidearm_Summon();
}

statemachine class cACS_TK
{
    function ACS_TK_Engage()
	{
		this.PushState('ACS_TK_Engage');
	}
}

state ACS_TK_Engage in cACS_TK
{
	private var victimsarray																			: array<CActor>;
	private var movementAdjustor1, movementAdjustor2													: CMovementAdjustor;
	private var ticket1, ticket2 																		: SMovementAdjustmentRequestTicket;
	private var actor																					: CActor;
	private var dist																					: float;
	private var animatedComponent 																		: CAnimatedComponent;
	private var settings																				: SAnimatedComponentSlotAnimationSettings;
	private var pActor 																					: CActor;
	private var i         																				: int;
	private var npc     																				: CActor;
	private var dest, dest_adjusted 																	: Vector;
	private var initial_dist																			: float;
	private var progress, progress_inc, speed 															: float;
    private var prev_time, new_time, delta_time, stuck_time, slide_time 								: float;
	private var prev_pos, new_pos 																		: Vector;
	private var delta_dist 																				: float;
	private var teleport, slide 																		: bool;
	private var slideDuration 																			: float;
	private var pull_anchor1, pull_anchor2, pull_anchor3, pull_anchor4, pull_anchor5					: CEntity;
	private var markerTemplate																			: CEntityTemplate;

	event OnEnterState(prevStateName : name)
	{
		TK();
	}
	
	entry function TK()
	{
		if (GetWitcherPlayer().IsHardLockEnabled())
		{
			Pull_Single();
		}
		else
		{
			Pull_Mult();
		}
	}
	
	latent function Pull_Mult()
	{
		GetWitcherPlayer().DestroyEffect('mind_control');	

		ACSGetCEntity('ACS_pull_anchor1').Destroy();
		ACSGetCEntity('ACS_pull_anchor2').Destroy();
		ACSGetCEntity('ACS_pull_anchor3').Destroy();
		ACSGetCEntity('ACS_pull_anchor4').Destroy();
		ACSGetCEntity('ACS_pull_anchor5').Destroy();
		
		settings.blendIn = 0.175f;
		settings.blendOut = 1.f;

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
		
		victimsarray = GetActorsInRange(GetWitcherPlayer(), 25, 25);
		
		for( i = 0; i < victimsarray.Size(); i += 1 )
		{		
			npc = (CActor)victimsarray[i];
			
			dest = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1;
			dest_adjusted = dest + Vector(0, 0, 1.25, 0);
			initial_dist = VecDistance2D(npc.GetWorldPosition(), dest);
			
			dist = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
			+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) * 2.125;
			
			prev_time = theGame.GetEngineTimeAsSeconds();
			stuck_time = 0;

			speed = 4;
			progress = 0;
			progress_inc = (speed / VecDistance2D(npc.GetWorldPosition(), dest_adjusted)) / 2.3;

			teleport = true;
			slide = false;

			prev_pos = npc.GetWorldPosition();
			
			movementAdjustor1 = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
			movementAdjustor1.CancelByName( 'ACS_TK_turn' );
			ticket1 = movementAdjustor1.CreateNewRequest( 'ACS_TK_turn' );
			movementAdjustor1.AdjustmentDuration( ticket1, 0.5 );
			
			movementAdjustor2 = npc.GetMovingAgentComponent().GetMovementAdjustor();
			movementAdjustor2.CancelByName( 'ACS_pull_mult' );
			ticket2 = movementAdjustor2.CreateNewRequest( 'ACS_pull_mult' );
			slideDuration = VecDistance2D( prev_pos, dest ) / speed;
			movementAdjustor2.AdjustmentDuration( ticket2, slideDuration );
			movementAdjustor2.ShouldStartAt(ticket2, prev_pos);
			movementAdjustor2.AdjustLocationVertically( ticket2, true );
			movementAdjustor2.ScaleAnimationLocationVertically( ticket2, true );
			movementAdjustor2.MaxLocationAdjustmentSpeed( ticket2, 10000000 );
			
			SleepOneFrame();
			
			if ( victimsarray.Size() >0 )
			{
				if (GetWitcherPlayer().IsInCombat())
				{
					if( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
					{	
						markerTemplate = (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\quest\q702\702_08_vampire_vision\q702_magical_decal.w2ent", true );
						
						pull_anchor1 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor2 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor3 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor4 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor5 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );

						/*
						pull_anchor1 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						pull_anchor2 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						pull_anchor3 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						*/

						pull_anchor1.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
						pull_anchor2.CreateAttachment( npc, , Vector( 0.25, 0, 1 ) );				
						pull_anchor3.CreateAttachment( npc, , Vector( -0.25, 0, 1 ) );
						pull_anchor4.CreateAttachment( npc, , Vector( 0.25, 0, 0 ) );
						pull_anchor5.CreateAttachment( npc, , Vector( -0.25, 0, 0 ) );
						pull_anchor1.DestroyAfter(10);
						pull_anchor2.DestroyAfter(10);
						pull_anchor3.DestroyAfter(10);
						pull_anchor4.DestroyAfter(10);
						pull_anchor5.DestroyAfter(10);
						
						SleepOneFrame();

						GetWitcherPlayer().DestroyEffect('mind_control');	
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor4);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor5);
						GetWitcherPlayer().StopEffect('mind_control');	
						
						
						if (!theGame.IsDialogOrCutscenePlaying() 
						|| !GetWitcherPlayer().IsInNonGameplayCutscene() 
						|| !GetWitcherPlayer().IsInGameplayScene()
						//&& !GetWitcherPlayer().IsSwimming()
						|| !GetWitcherPlayer().IsUsingHorse()
						|| !GetWitcherPlayer().IsUsingVehicle()
						)
						{
							movementAdjustor1.RotateTowards( ticket1, npc );
						}
						
						npc.RemoveAllBuffsOfType( EET_HeavyKnockdown );
					
						npc.RemoveAllBuffsOfType( EET_Knockdown );
					
						npc.RemoveAllBuffsOfType( EET_LongStagger );
					
						npc.RemoveAllBuffsOfType( EET_Ragdoll );
						
						npc.RemoveAllBuffsOfType( EET_Stagger );
						
						npc.RemoveAllBuffsOfType( EET_Paralyzed );

						Sleep(0.1);
					
						if (npc.UsesEssence())
						{
							if (npc.IsAnimal())
							{
								npc.EnableCharacterCollisions(false);
								npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
							}
							else
							{
								if (!npc.IsImmuneToBuff(EET_LongStagger) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
								//if (!npc.IsImmuneToBuff(EET_HeavyKnockdown) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
								{
									//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
									npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
									//npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
								}
								else
								{
									npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
								}
							}
						}
						else if (!npc.UsesEssence())
						{
							if (npc.IsUsingVehicle()) 
							{
								npc.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
								//npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
								//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
								npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
							}
							else
							{
								if (npc.IsAnimal())
								{
									npc.EnableCharacterCollisions(false);
									npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
								}
								else
								{
									if (!npc.IsImmuneToBuff(EET_LongStagger) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
									//if (!npc.IsImmuneToBuff(EET_HeavyKnockdown) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
									{
										//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
										npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
										//npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
									}
									else
									{
										npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
									}
								}
							}
						}
								
						while (true) 
						{
							//animatedComponent.PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
							
							new_time = theGame.GetEngineTimeAsSeconds();
							delta_time = new_time - prev_time;

							new_pos = npc.GetWorldPosition();
							delta_dist = VecDistance2D(prev_pos, new_pos);

							if (delta_dist <= 0.1) 
							{
								if (stuck_time == 0) stuck_time = new_time;
							}
							else stuck_time = 0;

							if (!slide && VecDistance2D(prev_pos, dest) <= 2.5 && dest_adjusted.Z - prev_pos.Z <= 2 ) 
							{
								GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
								
								GetWitcherPlayer().DestroyEffect('mind_control');	
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor4);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor5);
								GetWitcherPlayer().StopEffect('mind_control');	

								movementAdjustor2.SlideTowards( ticket2, GetWitcherPlayer(), dist, dist );	
								teleport = false;
								slide = true;
								slide_time = new_time;
							}
									
							if (teleport) 
							{
								GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
								
								GetWitcherPlayer().DestroyEffect('mind_control');	
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor4);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor5);
								GetWitcherPlayer().StopEffect('mind_control');	
								
								progress += progress_inc*delta_time;
										
								npc.Teleport( LerpV(new_pos, dest_adjusted, progress) );
							}	
									
							prev_pos = new_pos;
							prev_time = new_time;
							
							//GetWitcherPlayer().DestroyEffect('mind_control');		
							SleepOneFrame();
						}
						
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', settings);
						//GetWitcherPlayer().DestroyEffect('mind_control');
					}
				}
				else 
				{
					if( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
					{	
						markerTemplate = (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\quest\q702\702_08_vampire_vision\q702_magical_decal.w2ent", true );
						
						pull_anchor1 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor2 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor3 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor4 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor5 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );

						/*
						pull_anchor1 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						pull_anchor2 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						pull_anchor3 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						*/

						pull_anchor1.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
						pull_anchor2.CreateAttachment( npc, , Vector( 0.25, 0, 1 ) );				
						pull_anchor3.CreateAttachment( npc, , Vector( -0.25, 0, 1 ) );
						pull_anchor4.CreateAttachment( npc, , Vector( 0.25, 0, 0 ) );
						pull_anchor5.CreateAttachment( npc, , Vector( -0.25, 0, 0 ) );
						pull_anchor1.DestroyAfter(10);
						pull_anchor2.DestroyAfter(10);
						pull_anchor3.DestroyAfter(10);
						pull_anchor4.DestroyAfter(10);
						pull_anchor5.DestroyAfter(10);
						
						SleepOneFrame();

						GetWitcherPlayer().DestroyEffect('mind_control');	
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor4);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor5);
						GetWitcherPlayer().StopEffect('mind_control');	
						
						
						if (!theGame.IsDialogOrCutscenePlaying() 
						|| !GetWitcherPlayer().IsInNonGameplayCutscene() 
						|| !GetWitcherPlayer().IsInGameplayScene()
						//&& !GetWitcherPlayer().IsSwimming()
						|| !GetWitcherPlayer().IsUsingHorse()
						|| !GetWitcherPlayer().IsUsingVehicle()
						)
						{
							movementAdjustor1.RotateTowards( ticket1, npc );
						}
						
						npc.RemoveAllBuffsOfType( EET_HeavyKnockdown );
					
						npc.RemoveAllBuffsOfType( EET_Knockdown );
					
						npc.RemoveAllBuffsOfType( EET_LongStagger );
					
						npc.RemoveAllBuffsOfType( EET_Ragdoll );
						
						npc.RemoveAllBuffsOfType( EET_Stagger );
						
						npc.RemoveAllBuffsOfType( EET_Paralyzed );
						
						npc.EnableCollisions(false);

						Sleep(0.1);
						
						if (npc.UsesEssence())
						{
							if (npc.IsAnimal())
							{
								npc.EnableCharacterCollisions(false);
								npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
							}
							else
							{
								if (!npc.IsImmuneToBuff(EET_LongStagger) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
								//if (!npc.IsImmuneToBuff(EET_HeavyKnockdown) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
								{
									//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
									npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
									//npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
								}
								else
								{
									npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
								}
							}
						}
						else if (!npc.UsesEssence())
						{
							if (npc.IsUsingVehicle()) 
							{
								npc.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
								//npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
								//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
								npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
							}
							else
							{
								if (npc.IsAnimal())
								{
									npc.EnableCharacterCollisions(false);
									npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
								}
								else
								{
									if (!npc.IsImmuneToBuff(EET_LongStagger) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
									//if (!npc.IsImmuneToBuff(EET_HeavyKnockdown) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
									{
										//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
										npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
										//npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
									}
									else
									{
										npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
									}
								}
							}
						}
						
						while (true) 
						{
							//animatedComponent.PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
							
							new_time = theGame.GetEngineTimeAsSeconds();
							delta_time = new_time - prev_time;

							new_pos = npc.GetWorldPosition();
							delta_dist = VecDistance2D(prev_pos, new_pos);

							if (delta_dist <= 0.1) 
							{
								if (stuck_time == 0) stuck_time = new_time;
							}
							else stuck_time = 0;

							if (!slide && VecDistance2D(prev_pos, dest) <= 2.5 && dest_adjusted.Z - prev_pos.Z <= 2 ) 
							{	
								GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
								
								
								GetWitcherPlayer().DestroyEffect('mind_control');	
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor4);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor5);
								GetWitcherPlayer().StopEffect('mind_control');	
								
								//movementAdjustor2.SlideTo( ticket2, dest );	
								movementAdjustor2.SlideTowards( ticket2, GetWitcherPlayer(), dist, dist );	
								teleport = false;
								slide = true;
								slide_time = new_time;
							}
									
							if (teleport) 
							{
								GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
								
								
								GetWitcherPlayer().DestroyEffect('mind_control');	
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor4);
								GetWitcherPlayer().PlayEffect('mind_control', pull_anchor5);
								GetWitcherPlayer().StopEffect('mind_control');	
								
								progress += progress_inc*delta_time;
									
								npc.Teleport( LerpV(new_pos, dest_adjusted, progress) );
							}	
									
							prev_pos = new_pos;
							prev_time = new_time;
							
							SleepOneFrame();
						}					
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', settings);
					}
				}
			}
		}
	}
	

	latent function Pull_Single()
	{
		GetWitcherPlayer().DestroyEffect('mind_control');	

		ACSGetCEntity('ACS_pull_anchor1').Destroy();
		ACSGetCEntity('ACS_pull_anchor2').Destroy();
		ACSGetCEntity('ACS_pull_anchor3').Destroy();
		
		settings.blendIn = 0.175f;
		settings.blendOut = 1.f;

		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
		
		npc = (CActor)( GetWitcherPlayer().GetDisplayTarget() );
			
		dest = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * -1.1;
		dest_adjusted = dest + Vector(0, 0, 1.25, 0);
		initial_dist = VecDistance2D(npc.GetWorldPosition(), dest);
			
		dist = (((CMovingPhysicalAgentComponent)actor.GetMovingAgentComponent()).GetCapsuleRadius() 
		+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) * 2.125;
			
		prev_time = theGame.GetEngineTimeAsSeconds();
		stuck_time = 0;

		speed = 4;
		progress = 0;
		progress_inc = (speed / VecDistance2D(npc.GetWorldPosition(), dest_adjusted)) / 2.3;

		teleport = true;
		slide = false;

		prev_pos = npc.GetWorldPosition();
			
		movementAdjustor1 = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		movementAdjustor1.CancelByName( 'ACS_TK_turn' );
		ticket1 = movementAdjustor1.CreateNewRequest( 'ACS_TK_turn' );
		movementAdjustor1.AdjustmentDuration( ticket1, 0.5 );
			
		movementAdjustor2 = npc.GetMovingAgentComponent().GetMovementAdjustor();
		movementAdjustor2.CancelByName( 'ACS_pull_mult' );
		ticket2 = movementAdjustor2.CreateNewRequest( 'ACS_pull_mult' );
		slideDuration = VecDistance2D( prev_pos, dest ) / speed;
		movementAdjustor2.AdjustmentDuration( ticket2, slideDuration );
		movementAdjustor2.ShouldStartAt(ticket2, prev_pos);
		movementAdjustor2.AdjustLocationVertically( ticket2, true );
		movementAdjustor2.ScaleAnimationLocationVertically( ticket2, true );
		movementAdjustor2.MaxLocationAdjustmentSpeed( ticket2, 10000000 );
			
		SleepOneFrame();

		if (GetWitcherPlayer().IsInCombat())
		{
			if( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
			{	
				markerTemplate = (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\quest\q702\702_08_vampire_vision\q702_magical_decal.w2ent", true );
						
						pull_anchor1 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor2 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor3 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );

						/*
						pull_anchor1 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						pull_anchor2 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						pull_anchor3 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						*/
				pull_anchor1.AddTag('ACS_pull_anchor1');
				pull_anchor2.AddTag('ACS_pull_anchor2');
				pull_anchor3.AddTag('ACS_pull_anchor3');
				pull_anchor1.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
				pull_anchor2.CreateAttachment( npc, , Vector( 0.25, 0, 1 ) );				
				pull_anchor3.CreateAttachment( npc, , Vector( -0.25, 0, 1 ) );
				pull_anchor1.DestroyAfter(10);
				pull_anchor2.DestroyAfter(10);
				pull_anchor3.DestroyAfter(10);
						
				if (!theGame.IsDialogOrCutscenePlaying() 
				|| !GetWitcherPlayer().IsInNonGameplayCutscene() 
				|| !GetWitcherPlayer().IsInGameplayScene()
				//&& !GetWitcherPlayer().IsSwimming()
				|| !GetWitcherPlayer().IsUsingHorse()
				|| !GetWitcherPlayer().IsUsingVehicle()
				)
				{
					movementAdjustor1.RotateTowards( ticket1, npc );
				}
						
				npc.RemoveAllBuffsOfType( EET_HeavyKnockdown );
					
				npc.RemoveAllBuffsOfType( EET_Knockdown );
					
				npc.RemoveAllBuffsOfType( EET_LongStagger );
					
				npc.RemoveAllBuffsOfType( EET_Ragdoll );
				
				npc.RemoveAllBuffsOfType( EET_Stagger );
						
				npc.RemoveAllBuffsOfType( EET_Paralyzed );

				Sleep(0.1);
					
				if (npc.UsesEssence())
				{
					if (npc.IsAnimal())
					{
						npc.EnableCharacterCollisions(false);
						npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
					}
					else
					{
						if (!npc.IsImmuneToBuff(EET_LongStagger) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
						//if (!npc.IsImmuneToBuff(EET_HeavyKnockdown) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
						{
							//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
							npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
							//npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
						}
						else
						{
							npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
						}
					}
				}
				else if (!npc.UsesEssence())
				{
					if (npc.IsUsingVehicle()) 
					{
						npc.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
						//npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
						//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
						npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
					}
					else
					{
						if (npc.IsAnimal())
						{
							npc.EnableCharacterCollisions(false);
							npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
						}
						else
						{
							if (!npc.IsImmuneToBuff(EET_LongStagger) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
							//if (!npc.IsImmuneToBuff(EET_HeavyKnockdown) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
							{
								//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
								npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
								//npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
							}
							else
							{
								npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
							}
						}
					}
				}							
				while (true) 
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
							
					new_time = theGame.GetEngineTimeAsSeconds();
					delta_time = new_time - prev_time;

					new_pos = npc.GetWorldPosition();
					delta_dist = VecDistance2D(prev_pos, new_pos);

					if (delta_dist <= 0.1) 
					{
						if (stuck_time == 0) stuck_time = new_time;
					}
					else stuck_time = 0;

					if (!slide && VecDistance2D(prev_pos, dest) <= 2.5 && dest_adjusted.Z - prev_pos.Z <= 2 ) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
								

						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);

						movementAdjustor2.SlideTowards( ticket2, GetWitcherPlayer(), dist, dist );	
						teleport = false;
						slide = true;
						slide_time = new_time;
					}
									
					if (teleport) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);


						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
						GetWitcherPlayer().StopEffect('mind_control');	

								
						progress += progress_inc*delta_time;
										
						npc.Teleport( LerpV(new_pos, dest_adjusted, progress) );
					}	
									
					prev_pos = new_pos;
					prev_time = new_time;
							
					//GetWitcherPlayer().DestroyEffect('mind_control');		
					SleepOneFrame();
				}
						
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', settings);
				//GetWitcherPlayer().DestroyEffect('mind_control');
			}
		}
		else 
		{
			if( npc.GetAttitude(GetWitcherPlayer()) == AIA_Hostile && npc.IsAlive() )
			{	
				markerTemplate = (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\quest\q702\702_08_vampire_vision\q702_magical_decal.w2ent", true );
						
						pull_anchor1 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor2 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );
						pull_anchor3 = (CEntity)theGame.CreateEntity( markerTemplate, npc.GetWorldPosition(), npc.GetWorldRotation() );

						/*
						pull_anchor1 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						pull_anchor2 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						pull_anchor3 = npc.CreateFXEntityAtPelvis('runeword_4', false);
						*/
				pull_anchor1.AddTag('ACS_pull_anchor1');
				pull_anchor2.AddTag('ACS_pull_anchor2');
				pull_anchor3.AddTag('ACS_pull_anchor3');
				pull_anchor1.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
				pull_anchor2.CreateAttachment( npc, , Vector( 0.25, 0, 1 ) );				
				pull_anchor3.CreateAttachment( npc, , Vector( -0.25, 0, 1 ) );
				pull_anchor1.DestroyAfter(10);
				pull_anchor2.DestroyAfter(10);
				pull_anchor3.DestroyAfter(10);

				if (!theGame.IsDialogOrCutscenePlaying() 
				|| !GetWitcherPlayer().IsInNonGameplayCutscene() 
				|| !GetWitcherPlayer().IsInGameplayScene()
				//&& !GetWitcherPlayer().IsSwimming()
				|| !GetWitcherPlayer().IsUsingHorse()
				|| !GetWitcherPlayer().IsUsingVehicle()
				)
				{
					movementAdjustor1.RotateTowards( ticket1, npc );
				}
						
				npc.RemoveAllBuffsOfType( EET_HeavyKnockdown );
					
				npc.RemoveAllBuffsOfType( EET_Knockdown );
					
				npc.RemoveAllBuffsOfType( EET_LongStagger );
					
				npc.RemoveAllBuffsOfType( EET_Ragdoll );
						
				npc.RemoveAllBuffsOfType( EET_Stagger );
						
				npc.RemoveAllBuffsOfType( EET_Paralyzed );
						
				npc.EnableCollisions(false);

				Sleep(0.1);
						
				if (npc.UsesEssence())
				{
					if (npc.IsAnimal())
					{
						npc.EnableCharacterCollisions(false);
						npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
					}
					else
					{
						if (!npc.IsImmuneToBuff(EET_LongStagger) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
						//if (!npc.IsImmuneToBuff(EET_HeavyKnockdown) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
						{
							//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
							npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
							//npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
						}
						else
						{
							npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
						}
					}
				}
				else if (!npc.UsesEssence())
				{
					if (npc.IsUsingVehicle()) 
					{
						npc.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
						//npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
						//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
						npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
					}
					else
					{
						if (npc.IsAnimal())
						{
							npc.EnableCharacterCollisions(false);
							npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
						}
						else
						{
							if (!npc.IsImmuneToBuff(EET_LongStagger) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
							//if (!npc.IsImmuneToBuff(EET_HeavyKnockdown) && !npc.HasAbility('Flying') && ( (CMovingPhysicalAgentComponent)( npc.GetMovingAgentComponent() ) ).HasRagdoll())
							{
								//npc.AddEffectDefault( EET_Ragdoll, npc, 'console' );
								npc.AddEffectDefault( EET_LongStagger, npc, 'console' );
								//npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
							}
							else
							{
								npc.AddEffectDefault( EET_Paralyzed, npc, 'console' );
							}
						}
					}
				}
						
				while (true) 
				{
					//animatedComponent.PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);
							
					new_time = theGame.GetEngineTimeAsSeconds();
					delta_time = new_time - prev_time;

					new_pos = npc.GetWorldPosition();
					delta_dist = VecDistance2D(prev_pos, new_pos);

					if (delta_dist <= 0.1) 
					{
						if (stuck_time == 0) stuck_time = new_time;
					}
					else stuck_time = 0;

					if (!slide && VecDistance2D(prev_pos, dest) <= 2.5 && dest_adjusted.Z - prev_pos.Z <= 2 ) 
					{	
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);


						GetWitcherPlayer().DestroyEffect('mind_control');
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
						GetWitcherPlayer().StopEffect('mind_control');	

								
						//movementAdjustor2.SlideTo( ticket2, dest );	
						movementAdjustor2.SlideTowards( ticket2, GetWitcherPlayer(), dist, dist );	
						teleport = false;
						slide = true;
						slide_time = new_time;
					}
									
					if (teleport) 
					{
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'man_geralt_gabriel_aim_idle_lp', 'PLAYER_SLOT', settings);


						GetWitcherPlayer().DestroyEffect('mind_control');
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor1);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor2);
						GetWitcherPlayer().PlayEffect('mind_control', pull_anchor3);
						GetWitcherPlayer().StopEffect('mind_control');	

								
						progress += progress_inc*delta_time;
									
						npc.Teleport( LerpV(new_pos, dest_adjusted, progress) );
					}	
									
					prev_pos = new_pos;
					prev_time = new_time;
							
					SleepOneFrame();
				}					
				GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( '', 'PLAYER_SLOT', settings);
			}
		}
	}
}