function ACS_Giant_Lightning_Strike_Single()
{
	var vACS_Giant_Lightning_Strike_Single : cACS_Giant_Lightning_Strike_Single;
	vACS_Giant_Lightning_Strike_Single = new cACS_Giant_Lightning_Strike_Single in theGame;
			
	vACS_Giant_Lightning_Strike_Single.Giant_Lightning_Strike_Single_Engage();
}

statemachine class cACS_Giant_Lightning_Strike_Single
{
    function Giant_Lightning_Strike_Single_Engage()
	{
		this.PushState('Giant_Lightning_Strike_Single_Engage');
	}
}

state Giant_Lightning_Strike_Single_Engage in cACS_Giant_Lightning_Strike_Single
{
	private var targetRotationNPC												: EulerAngles;
	private var actor															: CActor;
	private var lightning, lightning_2, markerNPC, vfxEnt						: CEntity;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var actorPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;
	private var world															: CWorld;
	private var l_groundZ														: float;
	private var entPos															: Vector;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Lightning_Strike_Single();
	}
	
	entry function Giant_Lightning_Strike_Single()
	{
		Strike_Single();
	}
	
	latent function Strike_Single()
	{
		GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax( BCS_Stamina )/2, 1 );

		targetRotationNPC = actor.GetWorldRotation();
		targetRotationNPC.Yaw = RandRangeF(360,1);
		targetRotationNPC.Pitch = RandRangeF(45,-45);
		
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
		if (!actor.HasBuff(EET_HeavyKnockdown)
		&& !actor.HasBuff(EET_Burning) )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actor.GetWorldPosition(), targetRotationNPC );
			vfxEnt.CreateAttachment( actor, , Vector( 0, 0, 1.5 ) );	
			vfxEnt.PlayEffectSingle('critical_quen');
			vfxEnt.DestroyAfter(2);
							
			lightning = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), actor.GetWorldPosition(), targetRotationNPC );
			lightning.PlayEffectSingle('pre_lightning');
			lightning.PlayEffectSingle('lightning');
			lightning.DestroyAfter(1.5);

			lightning_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\quest\sq209\sq209_lightning_scene.w2ent", true ), actor.GetWorldPosition(), targetRotationNPC );
			lightning_2.PlayEffectSingle('lighgtning');
			lightning_2.DestroyAfter(1.5);
		
			actor.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'console' );

			actor.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'console' );

			if (actor.IsOnGround())
			{
				temp = (CEntityTemplate)LoadResourceAsync( 

				"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
					
				, true );

				actorPos = actor.GetWorldPosition();
				
				count = 6;
					
				for( i = 0; i < count; i += 1 )
				{
					randRange = 2.5 + 2.5 * RandF();
					randAngle = 2 * Pi() * RandF();
					
					spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
					spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
					spawnPos.Z = actorPos.Z;
					
					markerNPC = theGame.CreateEntity( temp, ACSPlayerFixZAxis( spawnPos ), actor.GetWorldRotation() );

					markerNPC.PlayEffectSingle('explosion');
					markerNPC.DestroyAfter(7);
				}

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( actor.GetWorldPosition() ), 0.5f, 1.0f, 1.5f, 2.5f, 1);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Lightning_Strike_Check() : bool
{
	if (
	(
	GetWeatherConditionName() == 'WT_Blizzard' 
	|| GetWeatherConditionName() == 'WT_Rain_Storm' 
	|| GetWeatherConditionName() == 'WT_Battle' 
	|| GetWeatherConditionName() == 'WT_Battle_Forest' 
	|| GetWeatherConditionName() == 'WT_Wild_Hunt' 
	|| GetWeatherConditionName() == 'WT_q501_Blizzard' 
	|| GetWeatherConditionName() == 'WT_q501_Storm' 
	|| GetWeatherConditionName() == 'WT_q501_Blizzard2' 
	|| GetWeatherConditionName() == 'WT_q501_fight_ship_18_00' 
	|| GetWeatherConditionName() == 'WT_q501_storm_arena' 
	|| GetWeatherConditionName() == 'Spiral_Eternal_Cold' 
	|| GetWeatherConditionName() == 'Spiral_Dark_Valley'
	|| GetWeatherConditionName() == 'WT_Rain_Heavy' 
	|| GetWeatherConditionName() == 'WT_Rain_Dark' 
	)
	&& !thePlayer.IsInInterior()
	)
	{
		return true;
	}

	return false;
}

function ACS_Lightning_Strike()
{
	var vACS_Lightning_Strike : cACS_Lightning_Strike;
	vACS_Lightning_Strike = new cACS_Lightning_Strike in theGame;
	
	if (ACS_Lightning_Strike_Check()
	&& ACS_can_lightning())
	{
		ACS_refresh_lightning_cooldown();

		ACS_Lightning_Tutorial();

		vACS_Lightning_Strike.ACS_Lightning_Strike_Engage();
	}
}

function ACS_Lightning_Strike_No_Condition()
{
	var vACS_Lightning_Strike : cACS_Lightning_Strike;
	vACS_Lightning_Strike = new cACS_Lightning_Strike in theGame;
	
	vACS_Lightning_Strike.ACS_Lightning_Strike_Engage();
}

function ACS_Lightning_Strike_No_Condition_Mult()
{
	var vACS_Lightning_Strike : cACS_Lightning_Strike;
	vACS_Lightning_Strike = new cACS_Lightning_Strike in theGame;
	
	vACS_Lightning_Strike.ACS_Lightning_Strike_Mult_Engage();
}

statemachine class cACS_Lightning_Strike
{
    function ACS_Lightning_Strike_Engage()
	{
		this.PushState('ACS_Lightning_Strike_Engage');
	}

	function ACS_Lightning_Strike_Mult_Engage()
	{
		this.PushState('ACS_Lightning_Strike_Mult_Engage');
	}
}

state ACS_Lightning_Strike_Engage in cACS_Lightning_Strike
{
	var temp, temp_2, temp_3, temp_4, temp_5									: CEntityTemplate;
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5									: CEntity;
	var i, count, count_2, j, k													: int;
	var playerPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos		: Vector;
	var randAngle, randRange, randAngle_2, randRange_2, distance				: float;
	var adjustedRot, playerRot2													: EulerAngles;
	var actors    																: array<CActor>;
	var actor    																: CActor;
	var dmg																		: W3DamageAction;
	var world																	: CWorld;
	var l_groundZ																: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Lightning_Strike_Entry();
	}
	
	entry function ACS_Lightning_Strike_Entry()
	{
		ACS_Lightning_Strike_Latent();
	}
	
	latent function ACS_Lightning_Strike_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\giant_lightning_strike.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\custom_lightning.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\custom_lightning_lights.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\q603_08_fire_01.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\acs_guiding_wind.w2ent"
			
		, true );

		playerPos = ACSPlayerFixZAxis(theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 20);

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = RandRangeF(360,1);
		adjustedRot.Pitch = RandRangeF(22.5,-22.5);

		playerRot2 = EulerAngles(0,0,0);
		playerRot2.Yaw = RandRangeF(360,1);

		ent = theGame.CreateEntity( temp_3, playerPos, EulerAngles(0,0,0) );

		ent.PlayEffectSingle('lights');

		ent.DestroyAfter(1);
		
		count = RandRange(3,1);

		distance = RandRangeF(50,10);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = distance + distance * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			//spawnPos.Z = playerPos.Z;

			posAdjusted = ACSPlayerFixZAxis(spawnPos);

			ent_1 = theGame.CreateEntity( temp, posAdjusted, adjustedRot );

			ent_1.PlayEffectSingle('pre_lightning');
			ent_1.PlayEffectSingle('lightning');

			ent_1.DestroyAfter(10);



			ent_2 = theGame.CreateEntity( temp_2, posAdjusted, playerRot2 );

			ent_2.PlayEffectSingle('lighgtning');

			ent_2.DestroyAfter(10);



			ent_3 = theGame.CreateEntity( temp_2, posAdjusted, adjustedRot );

			ent_3.PlayEffectSingle('lighgtning');

			ent_3.DestroyAfter(10);


			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( posAdjusted, 0.5f, 10.5f, 0.5f, 7.f, 1);


			count_2 = 12;

			for( j = 0; j < count_2; j += 1 )
			{
				randRange_2 = 2 + 2 * RandF();
				randAngle_2 = 2 * Pi() * RandF();
				
				spawnPos2.X = randRange_2 * CosF( randAngle_2 ) + posAdjusted.X;
				spawnPos2.Y = randRange_2 * SinF( randAngle_2 ) + posAdjusted.Y;
				//spawnPos2.Z = posAdjusted.Z;

				posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

				ent_4 = theGame.CreateEntity( temp_4, posAdjusted2, EulerAngles(0,0,0) );

				if (RandF() < 0.5)
				{
					ent_4.PlayEffectSingle('explosion');
				}
				else
				{
					if (RandF() < 0.5)
					{
						ent_4.PlayEffectSingle('explosion_big');
					}
					else
					{
						ent_4.PlayEffectSingle('explosion_medium');
					}
				}

				ent_4.DestroyAfter(10);
			}

			ent_5 = theGame.CreateEntity( temp_5, posAdjusted, adjustedRot );

			((CActor)ent_5).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
			((CActor)ent_5).SetCanPlayHitAnim(false); 
			((CActor)ent_5).AddBuffImmunity_AllNegative('ACS_Lightning_Rabbit', true); 

			ent_5.DestroyAfter(3);

			actors.Clear();

			actors = ((CActor)ent_5).GetNPCsAndPlayersInRange( 5, 20, , FLAG_OnlyAliveActors);

			for( k = 0; k < actors.Size(); k += 1 )
			{
				actor = actors[k];
				
				if( actors.Size() > 0 )
				{	
					dmg = new W3DamageAction in theGame.damageMgr;

					dmg.Initialize(((CActor)ent_5), actor, ((CActor)ent_5), ((CActor)ent_5).GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
					
					dmg.SetProcessBuffsIfNoDamage(true);

					dmg.SetHitReactionType( EHRT_Heavy, true);

					dmg.AddEffectInfo( EET_Stagger, 2 );

					dmg.AddEffectInfo( EET_Burning, 3 );
						
					theGame.damageMgr.ProcessAction( dmg );
						
					delete dmg;	
				}
			}
		}

		//GetACSWatcher().RemoveTimer('Thunder_Sounds');
		//GetACSWatcher().AddTimer('Thunder_Sounds', 1, false);

		thePlayer.SoundEvent( "fx_amb_thunder_close" );

		thePlayer.SoundEvent( "qu_nml_103_lightning" );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Lightning_Strike_Mult_Engage in cACS_Lightning_Strike
{
	var temp, temp_2, temp_3, temp_4, temp_5									: CEntityTemplate;
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5									: CEntity;
	var i, count, count_2, j, k													: int;
	var playerPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos		: Vector;
	var randAngle, randRange, randAngle_2, randRange_2, distance				: float;
	var adjustedRot, playerRot2													: EulerAngles;
	var actors    																: array<CActor>;
	var actor    																: CActor;
	var dmg																		: W3DamageAction;
	var world																	: CWorld;
	var l_groundZ																: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Lightning_Strike_Mult_Entry();
	}
	
	entry function ACS_Lightning_Strike_Mult_Entry()
	{
		ACS_Lightning_Strike_Mult_Latent();
	}
	
	latent function ACS_Lightning_Strike_Mult_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\giant_lightning_strike.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\custom_lightning.w2ent"
			
		, true );

		temp_3 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\custom_lightning_lights.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\q603_08_fire_01.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\acs_guiding_wind.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * 20;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = RandRangeF(360,1);
		adjustedRot.Pitch = RandRangeF(22.5,-22.5);

		playerRot2 = EulerAngles(0,0,0);
		playerRot2.Yaw = RandRangeF(360,1);

		ent = theGame.CreateEntity( temp_3, playerPos, EulerAngles(0,0,0) );

		ent.PlayEffectSingle('lights');

		ent.DestroyAfter(1);
		
		count = 5;

		distance = RandRangeF(50,10);
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = distance + distance * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			//spawnPos.Z = playerPos.Z;

			posAdjusted = ACSPlayerFixZAxis(spawnPos);

			ent_1 = theGame.CreateEntity( temp, posAdjusted, adjustedRot );

			ent_1.PlayEffectSingle('pre_lightning');
			ent_1.PlayEffectSingle('lightning');

			ent_1.DestroyAfter(10);


			ent_2 = theGame.CreateEntity( temp_2, posAdjusted, playerRot2 );

			ent_2.PlayEffectSingle('lighgtning');

			ent_2.DestroyAfter(10);


			ent_3 = theGame.CreateEntity( temp_2, posAdjusted, adjustedRot );

			ent_3.PlayEffectSingle('lighgtning');

			ent_3.DestroyAfter(10);


			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( posAdjusted, 0.5f, 10.5f, 0.5f, 7.f, 1);

			count_2 = 12;

			for( j = 0; j < count_2; j += 1 )
			{
				randRange_2 = 2 + 2 * RandF();
				randAngle_2 = 2 * Pi() * RandF();
				
				spawnPos2.X = randRange_2 * CosF( randAngle_2 ) + posAdjusted.X;
				spawnPos2.Y = randRange_2 * SinF( randAngle_2 ) + posAdjusted.Y;
				spawnPos2.Z = posAdjusted.Z;

				posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

				ent_4 = theGame.CreateEntity( temp_4, posAdjusted2, EulerAngles(0,0,0) );

				if (RandF() < 0.5)
				{
					ent_4.PlayEffectSingle('explosion');
				}
				else
				{
					if (RandF() < 0.5)
					{
						ent_4.PlayEffectSingle('explosion_big');
					}
					else
					{
						ent_4.PlayEffectSingle('explosion_medium');
					}
				}

				ent_4.DestroyAfter(10);
			}


			ent_5 = theGame.CreateEntity( temp_5, posAdjusted, adjustedRot );

			((CActor)ent_5).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
			((CActor)ent_5).SetCanPlayHitAnim(false); 
			((CActor)ent_5).AddBuffImmunity_AllNegative('ACS_Lightning_Rabbit', true); 

			ent_5.DestroyAfter(3);

			actors.Clear();

			actors = ((CActor)ent_5).GetNPCsAndPlayersInRange( 5, 20, , FLAG_OnlyAliveActors);

			for( k = 0; k < actors.Size(); k += 1 )
			{
				actor = actors[k];
				
				if( actors.Size() > 0 )
				{	
					dmg = new W3DamageAction in theGame.damageMgr;

					dmg.Initialize(((CActor)ent_5), actor, ((CActor)ent_5), ((CActor)ent_5).GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
					
					dmg.SetProcessBuffsIfNoDamage(true);

					dmg.SetHitReactionType( EHRT_Heavy, true);

					dmg.AddEffectInfo( EET_Stagger, 2 );

					dmg.AddEffectInfo( EET_Burning, 3 );
						
					theGame.damageMgr.ProcessAction( dmg );
						
					delete dmg;	
				}
			}
		}

		//GetACSWatcher().RemoveTimer('Thunder_Sounds');
		//GetACSWatcher().AddTimer('Thunder_Sounds', 1, false);

		thePlayer.SoundEvent( "fx_amb_thunder_close" );

		thePlayer.SoundEvent( "qu_nml_103_lightning" );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Marker_Fire()
{
	var vACS_Marker : cACS_Marker;
	vACS_Marker = new cACS_Marker in theGame;
			
	vACS_Marker.ACS_Marker_Fire_Engage();
}

function ACS_Marker_Smoke()
{
	var vACS_Marker : cACS_Marker;
	vACS_Marker = new cACS_Marker in theGame;
			
	vACS_Marker.ACS_Marker_Smoke_Engage();
}

function ACS_Marker_Lightning()
{
	var vACS_Marker : cACS_Marker;
	vACS_Marker = new cACS_Marker in theGame;
			
	vACS_Marker.ACS_Marker_Lightning_Engage();
}

statemachine class cACS_Marker
{
    function ACS_Marker_Fire_Engage()
	{
		this.PushState('ACS_Marker_Fire_Engage');
	}

	function ACS_Marker_Lightning_Engage()
	{
		this.PushState('ACS_Marker_Lightning_Engage');
	}

	function ACS_Marker_Smoke_Engage()
	{
		this.PushState('ACS_Marker_Smoke_Engage');
	}
}

state ACS_Marker_Smoke_Engage in cACS_Marker
{
	private var markerNPC, markerNPC_2											: CEntity;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Marker_Smoke_Entry();
	}
	
	entry function ACS_Marker_Smoke_Entry()
	{
		ACS_Marker_Smoke_Latent();
	}
	
	latent function ACS_Marker_Smoke_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\ep1\data\fx\quest\q604\604_11_cellar\ground_smoke_ent.w2ent"
			
		, true );

		playerPos = GetWitcherPlayer().GetWorldPosition();

		markerNPC = theGame.CreateEntity( temp, ACSPlayerFixZAxis( playerPos ), GetWitcherPlayer().GetWorldRotation() );

		markerNPC.PlayEffectSingle('ground_smoke');
		markerNPC.DestroyAfter(3);

		markerNPC_2 = theGame.CreateEntity( temp, ACSPlayerFixZAxis( playerPos ), GetWitcherPlayer().GetWorldRotation() );

		markerNPC_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, -1 ) );	

		markerNPC_2.PlayEffectSingle('ground_smoke');
		markerNPC_2.DestroyAfter(3.5);
		
		/*
		count = 3;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 1.5 + 1.5 * RandF();
			randAngle = 0.5 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			markerNPC_2 = theGame.CreateEntity( temp, ACSPlayerFixZAxis( spawnPos ), GetWitcherPlayer().GetWorldRotation() );

			markerNPC_2.PlayEffectSingle('ground_smoke');
			markerNPC_2.DestroyAfter(7);
		}
		*/

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Marker_Fire_Engage in cACS_Marker
{
	private var markerNPC, markerNPC_2											: CEntity;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var playerPos, playerPosLower, spawnPos								: Vector;
	private var randAngle, randRange											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Marker_Fire_Entry();
	}
	
	entry function ACS_Marker_Fire_Entry()
	{
		ACS_Marker_Fire_Latent();
	}
	
	latent function ACS_Marker_Fire_Latent()
	{
		playerPosLower = GetWitcherPlayer().GetWorldPosition();
		playerPosLower.Z -= 6;

		markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			//"dlc\bob\data\fx\quest\q701\q701_02_roof_fire.w2ent"

			"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_hut_fire.w2ent"
			
			, true ), playerPosLower, EulerAngles(0,0,0) );

		markerNPC.PlayEffectSingle('fire_01');
		//markerNPC.PlayEffectSingle('fire_02');
		markerNPC.DestroyAfter(5);

		temp = (CEntityTemplate)LoadResource( 

		"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
			
		, true );

		playerPos = GetWitcherPlayer().GetWorldPosition();
		
		count = 6;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			markerNPC_2 = theGame.CreateEntity( temp, ACSPlayerFixZAxis( spawnPos ), GetWitcherPlayer().GetWorldRotation() );

			markerNPC_2.PlayEffectSingle('explosion');
			markerNPC_2.DestroyAfter(7);
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 5.5f, 5.f, 1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Marker_Lightning_Engage in cACS_Marker
{
	private var markerNPC														: CEntity;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Marker_Lightning_Entry();
	}
	
	entry function ACS_Marker_Lightning_Entry()
	{
		ACS_Marker_Lightning_Latent();
	}
	
	latent function ACS_Marker_Lightning_Latent()
	{
		/*
		markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
			//"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_hut_fire.w2ent"
			, true ), ACSPlayerFixZAxis( GetWitcherPlayer().GetWorldPosition() ), EulerAngles(0,0,0) );
		markerNPC.PlayEffectSingle('explosion');
		//markerNPC.PlayEffectSingle('fire_01');
		markerNPC.StopAllEffectsAfter(3);
		markerNPC.DestroyAfter(3);
		*/

		temp = (CEntityTemplate)LoadResource( 

		"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
			
		, true );

		playerPos = GetWitcherPlayer().GetWorldPosition();
		
		count = 6;
			
		for( i = 0; i < count; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			markerNPC = theGame.CreateEntity( temp, ACSPlayerFixZAxis( spawnPos ), GetWitcherPlayer().GetWorldRotation() );

			markerNPC.PlayEffectSingle('explosion');
			markerNPC.DestroyAfter(7);
		}

		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( GetWitcherPlayer().GetWorldPosition() ), 0.5f, 1.0f, 1.5f, 5.f, 1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_Giant_Lightning_Strike_Mult()
{
	var vACS_Giant_Lightning_Strike_Mult : cACS_Giant_Lightning_Strike_Mult;
	vACS_Giant_Lightning_Strike_Mult = new cACS_Giant_Lightning_Strike_Mult in theGame;
			
	vACS_Giant_Lightning_Strike_Mult.Giant_Lightning_Strike_Mult_Engage();
}

statemachine class cACS_Giant_Lightning_Strike_Mult
{
    function Giant_Lightning_Strike_Mult_Engage()
	{
		this.PushState('Giant_Lightning_Strike_Mult_Engage');
	}
}

state Giant_Lightning_Strike_Mult_Engage in cACS_Giant_Lightning_Strike_Mult
{
	private var npc     														: CNewNPC;
	private var actors    														: array<CActor>;
	private var lightning, markerNPC, vfxEnt									: CEntity;
	private var targetRotationNPC												: EulerAngles;
	private var temp															: CEntityTemplate;
	private var i, count														: int;
	private var actorPos, spawnPos												: Vector;
	private var randAngle, randRange											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Lightning_Strike_Mult();
	}
	
	entry function Giant_Lightning_Strike_Mult()
	{
		Strike_Mult();
	}
	
	latent function Strike_Mult()
	{
		//actors = GetActorsInRange(GetWitcherPlayer(), 55, 20);
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 55, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{		
				if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
				{
					if( VecDistance2D( npc.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) <= 8 ) 
					{
						if( RandF() < 0.75 ) 
						{
							if (!npc.HasBuff(EET_HeavyKnockdown))
							{
								npc.AddEffectDefault( EET_HeavyKnockdown, npc, 'console' );
							}
								
							if (!npc.HasBuff(EET_Burning))
							{
								npc.AddEffectDefault( EET_Burning, npc, 'console' );
							}

							targetRotationNPC = npc.GetWorldRotation();
							targetRotationNPC.Yaw = RandRangeF(360,1);
							targetRotationNPC.Pitch = RandRangeF(45,-45);

							vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
							vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
							vfxEnt.PlayEffectSingle('critical_quen');
							vfxEnt.DestroyAfter(1.5);

							lightning = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
							lightning.PlayEffectSingle('pre_lightning');
							lightning.PlayEffectSingle('lightning');
							lightning.DestroyAfter(1.5);
							
							if (npc.IsOnGround())
							{
								temp = (CEntityTemplate)LoadResource( 

								"dlc\ep1\data\fx\quest\q603\08_demo_dwarf\q603_08_fire_01.w2ent"
									
								, true );

								actorPos = npc.GetWorldPosition();
								
								count = 6;
									
								for( i = 0; i < count; i += 1 )
								{
									randRange = 2.5 + 2.5 * RandF();
									randAngle = 2 * Pi() * RandF();
									
									spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
									spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
									spawnPos.Z = actorPos.Z;
									
									markerNPC = theGame.CreateEntity( temp, ACSPlayerFixZAxis( spawnPos ), npc.GetWorldRotation() );

									markerNPC.PlayEffectSingle('explosion');
									markerNPC.DestroyAfter(7);
								}

								theGame.GetSurfacePostFX().AddSurfacePostFXGroup( ACSPlayerFixZAxis( npc.GetWorldPosition() ), 0.5f, 1.0f, 1.5f, 5.f, 1);
							}
						}
					}
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Yrden_Lightning_LVL_1()
{
	var vACS_Yrden_Lightning_LVL_1 : cACS_Yrden_Lightning_LVL_1;
	vACS_Yrden_Lightning_LVL_1 = new cACS_Yrden_Lightning_LVL_1 in theGame;
			
	vACS_Yrden_Lightning_LVL_1.ACS_Yrden_Lightning_LVL_1_Engage();
}

statemachine class cACS_Yrden_Lightning_LVL_1
{
    function ACS_Yrden_Lightning_LVL_1_Engage()
	{
		this.PushState('ACS_Yrden_Lightning_LVL_1_Engage');
	}
}

state ACS_Yrden_Lightning_LVL_1_Engage in cACS_Yrden_Lightning_LVL_1
{
	private var npc     							: CNewNPC;
	private var actors    							: array<CActor>;
	private var i         							: int;
	private var lightning, markerNPC, vfxEnt		: CEntity;
	private var targetRotationNPC					: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Yrden_Lightning();
	}
	
	entry function Yrden_Lightning()
	{
		Yrden_Lightning_Activate();
	}
	
	latent function Yrden_Lightning_Activate()
	{
		//actors = GetActorsInRange(GetWitcherPlayer(), 2.5, 3);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 5, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{									
				targetRotationNPC = npc.GetWorldRotation();
				targetRotationNPC.Yaw = RandRangeF(360,1);
				targetRotationNPC.Pitch = RandRangeF(45,-45);

				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
				vfxEnt.PlayEffectSingle('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffectSingle('pre_lightning');
				lightning.PlayEffectSingle('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), ACSPlayerFixZAxis( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
					markerNPC.StopAllEffectsAfter(1.5);
					markerNPC.DestroyAfter(1.5);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Yrden_Lightning_LVL_2()
{
	var vACS_Yrden_Lightning_LVL_2 : cACS_Yrden_Lightning_LVL_2;
	vACS_Yrden_Lightning_LVL_2 = new cACS_Yrden_Lightning_LVL_2 in theGame;
			
	vACS_Yrden_Lightning_LVL_2.ACS_Yrden_Lightning_LVL_2_Engage();
}

statemachine class cACS_Yrden_Lightning_LVL_2
{
    function ACS_Yrden_Lightning_LVL_2_Engage()
	{
		this.PushState('ACS_Yrden_Lightning_LVL_2_Engage');
	}
}

state ACS_Yrden_Lightning_LVL_2_Engage in cACS_Yrden_Lightning_LVL_2
{
	private var npc     							: CNewNPC;
	private var actors    							: array<CActor>;
	private var i         							: int;
	private var lightning, markerNPC, vfxEnt		: CEntity;
	private var targetRotationNPC					: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Yrden_Lightning();
	}
	
	entry function Yrden_Lightning()
	{
		Yrden_Lightning_Activate();
	}
	
	latent function Yrden_Lightning_Activate()
	{
		//actors = GetActorsInRange(GetWitcherPlayer(), 5, 20);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{									
				targetRotationNPC = npc.GetWorldRotation();
				targetRotationNPC.Yaw = RandRangeF(360,1);
				targetRotationNPC.Pitch = RandRangeF(45,-45);

				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
				vfxEnt.PlayEffectSingle('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffectSingle('pre_lightning');
				lightning.PlayEffectSingle('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), ACSPlayerFixZAxis( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
					markerNPC.StopAllEffectsAfter(1.5);
					markerNPC.DestroyAfter(1.5);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Yrden_Lightning_LVL_3()
{
	var vACS_Yrden_Lightning_LVL_3 : cACS_Yrden_Lightning_LVL_3;
	vACS_Yrden_Lightning_LVL_3 = new cACS_Yrden_Lightning_LVL_3 in theGame;
			
	vACS_Yrden_Lightning_LVL_3.ACS_Yrden_Lightning_LVL_3_Engage();
}

statemachine class cACS_Yrden_Lightning_LVL_3
{
    function ACS_Yrden_Lightning_LVL_3_Engage()
	{
		this.PushState('ACS_Yrden_Lightning_LVL_3_Engage');
	}
}

state ACS_Yrden_Lightning_LVL_3_Engage in cACS_Yrden_Lightning_LVL_3
{
	private var npc     							: CNewNPC;
	private var actors    							: array<CActor>;
	private var i         							: int;
	private var lightning, markerNPC, vfxEnt		: CEntity;
	private var targetRotationNPC					: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Yrden_Lightning();
	}
	
	entry function Yrden_Lightning()
	{
		Yrden_Lightning_Activate();
	}
	
	latent function Yrden_Lightning_Activate()
	{
		//actors = GetActorsInRange(GetWitcherPlayer(), 10, 20);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{									
				targetRotationNPC = npc.GetWorldRotation();
				targetRotationNPC.Yaw = RandRangeF(360,1);
				targetRotationNPC.Pitch = RandRangeF(45,-45);

				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ) );	
				vfxEnt.PlayEffectSingle('critical_quen');
				vfxEnt.DestroyAfter(1.5);

				lightning = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\giant\giant_lightning_strike.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
				//lightning.PlayEffectSingle('pre_lightning');
				lightning.PlayEffectSingle('lightning');
				lightning.DestroyAfter(1.5);
							
				if (npc.IsOnGround())
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\quest\q403\meteorite\q403_marker.w2ent", true ), ACSPlayerFixZAxis( npc.GetWorldPosition() ), EulerAngles(0,0,0) );
					markerNPC.StopAllEffectsAfter(1.5);
					markerNPC.DestroyAfter(1.5);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Lightning_Area()
{
	var vACS_Lightning_Area : cACS_Lightning_Area;
	vACS_Lightning_Area = new cACS_Lightning_Area in theGame;
			
	vACS_Lightning_Area.ACS_Lightning_Area_Engage();
}

statemachine class cACS_Lightning_Area
{
    function ACS_Lightning_Area_Engage()
	{
		this.PushState('ACS_Lightning_Area_Engage');
	}
}

state ACS_Lightning_Area_Engage in cACS_Lightning_Area
{
	private var lightning1, lightning2 				: CEntity;
	private var targetPositionNPC					: Vector;
	private var targetRotationNPC					: EulerAngles;
	private var actor								: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Lightning_Area();
	}
	
	entry function Lightning_Area()
	{
		Lighting_Area_Activate();
	}
	
	latent function Lighting_Area_Activate()
	{
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
		lightning1 = (CEntity)theGame.GetEntityByTag( 'lightning_area_1' );
		lightning1.Destroy();
		
		if (actor.IsOnGround())
		{
			lightning2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\quests\main_quests\quest_files\q704b_fairy_tale\entities\giant\q704_ft_lightning_area.w2ent", true ), ACSPlayerFixZAxis( actor.GetWorldPosition() ), actor.GetWorldRotation() );
			lightning2.PlayEffectSingle('lightning_area');
			lightning2.AddTag('lightning_area_1');
			lightning2.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Rock_Pillar()
{
	var vACS_Rock_Pillar : cACS_Rock_Pillar;
	vACS_Rock_Pillar = new cACS_Rock_Pillar in theGame;
			
	vACS_Rock_Pillar.ACS_Rock_Pillar_Engage();
}

statemachine class cACS_Rock_Pillar
{
    function ACS_Rock_Pillar_Engage()
	{
		this.PushState('ACS_Rock_Pillar_Engage');
	}
}

state ACS_Rock_Pillar_Engage in cACS_Rock_Pillar
{
	private var actor										: CActor;
	private var npc     									: CNewNPC;
	private var actors    									: array<CActor>;
	private var rock_pillar_temp							: CEntityTemplate;
	private var targetRotationActor							: EulerAngles;
	private var markerNPC									: CEntity;
	private var actorPos, spawnPos							: Vector;
	private var randAngle, randRange						: float;
	private var i, PillarCount								: int;	

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Rock_Pillar();
	}
	
	entry function Rock_Pillar()
	{
		LockEntryFunction(true);
		Rock_Pillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Rock_Pillar_Activate()
	{
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );

		rock_pillar_temp = (CEntityTemplate)LoadResource( "gameplay\abilities\elemental\elemental_dao_pillar.w2ent", true );
		actorPos = actor.GetWorldPosition();
			
		PillarCount = 10;

		targetRotationActor = actor.GetWorldRotation();
			
		for( i = 0; i < PillarCount; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
			spawnPos.Z = actorPos.Z;

			targetRotationActor.Yaw = RandRangeF(360,1);
			targetRotationActor.Pitch = RandRangeF(45,-45);
			
			if (actor.IsOnGround())
			{
				markerNPC = (CEntity)theGame.CreateEntity( rock_pillar_temp, ACSPlayerFixZAxis(spawnPos), targetRotationActor );
				markerNPC.PlayEffectSingle('marker_fx');
				markerNPC.PlayEffectSingle('circle_stone');
				markerNPC.DestroyAfter(5);
			}
		}

		if (actor.IsOnGround())
		{
			//actors = GetActorsInRange(actor, 6, 20);

			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 6, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];
				
				if( actors.Size() > 0 )
				{		
					if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
					{
						if (!npc.HasBuff(EET_HeavyKnockdown))
						{
							npc.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'ACS_Rock_Pillar' );
						}
					}
				}
			}
		}

		GetWitcherPlayer().PlayEffectSingle('stomp');
		GetWitcherPlayer().StopEffect('stomp');

		GetWitcherPlayer().PlayEffectSingle('earthquake_fx');
		GetWitcherPlayer().StopEffect('earthquake_fx');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Ice_Spear_LVL_1()
{
	var vAOE_Ice_Spear_LVL_1 : cAOE_Ice_Spear_LVL_1;
	vAOE_Ice_Spear_LVL_1 = new cAOE_Ice_Spear_LVL_1 in theGame;
			
	vAOE_Ice_Spear_LVL_1.AOE_Ice_Spear_LVL_1_Engage();
}

statemachine class cAOE_Ice_Spear_LVL_1
{
    function AOE_Ice_Spear_LVL_1_Engage()
	{
		this.PushState('AOE_Ice_Spear_LVL_1_Engage');
	}
}

state AOE_Ice_Spear_LVL_1_Engage in cAOE_Ice_Spear_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: W3ACSIceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear();
	}
	
	entry function Ice_Spear()
	{
		LockEntryFunction(true);
		Ice_Spear_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ice_Spear_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.35f);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Ice_Spear_LVL_2()
{
	var vAOE_Ice_Spear_LVL_2 : cAOE_Ice_Spear_LVL_2;
	vAOE_Ice_Spear_LVL_2 = new cAOE_Ice_Spear_LVL_2 in theGame;
			
	vAOE_Ice_Spear_LVL_2.AOE_Ice_Spear_LVL_2_Engage();
}

statemachine class cAOE_Ice_Spear_LVL_2
{
    function AOE_Ice_Spear_LVL_2_Engage()
	{
		this.PushState('AOE_Ice_Spear_LVL_2_Engage');
	}
}

state AOE_Ice_Spear_LVL_2_Engage in cAOE_Ice_Spear_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: W3ACSIceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear();
	}
	
	entry function Ice_Spear()
	{
		LockEntryFunction(true);
		Ice_Spear_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ice_Spear_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.35f);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Ice_Spear_LVL_3()
{
	var vAOE_Ice_Spear_LVL_3 : cAOE_Ice_Spear_LVL_3;
	vAOE_Ice_Spear_LVL_3 = new cAOE_Ice_Spear_LVL_3 in theGame;
			
	vAOE_Ice_Spear_LVL_3.AOE_Ice_Spear_LVL_3_Engage();
}

statemachine class cAOE_Ice_Spear_LVL_3
{
    function AOE_Ice_Spear_LVL_3_Engage()
	{
		this.PushState('AOE_Ice_Spear_LVL_3_Engage');
	}
}

state AOE_Ice_Spear_LVL_3_Engage in cAOE_Ice_Spear_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: W3ACSIceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ice_Spear();
	}
	
	entry function Ice_Spear()
	{
		LockEntryFunction(true);
		Ice_Spear_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ice_Spear_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.35f);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Freeze_LVL_1()
{
	var vACS_AOE_Freeze_LVL_1 : cACS_AOE_Freeze_LVL_1;
	vACS_AOE_Freeze_LVL_1 = new cACS_AOE_Freeze_LVL_1 in theGame;
			
	vACS_AOE_Freeze_LVL_1.ACS_AOE_Freeze_LVL_1_Engage();
}

statemachine class cACS_AOE_Freeze_LVL_1
{
    function ACS_AOE_Freeze_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Freeze_LVL_1_Engage');
	}
}

state ACS_AOE_Freeze_LVL_1_Engage in cACS_AOE_Freeze_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Freeze();
	}
	
	entry function Freeze()
	{
		LockEntryFunction(true);
		Freeze_Activate();
		LockEntryFunction(false);
	}
	
	latent function Freeze_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\characters\canaris\canaris_groundrift.w2ent", true ), ACSPlayerFixZAxis (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('ground_fx');
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Freeze_LVL_2()
{
	var vACS_AOE_Freeze_LVL_2 : cACS_AOE_Freeze_LVL_2;
	vACS_AOE_Freeze_LVL_2 = new cACS_AOE_Freeze_LVL_2 in theGame;
			
	vACS_AOE_Freeze_LVL_2.ACS_AOE_Freeze_LVL_2_Engage();
}

statemachine class cACS_AOE_Freeze_LVL_2
{
    function ACS_AOE_Freeze_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Freeze_LVL_2_Engage');
	}
}

state ACS_AOE_Freeze_LVL_2_Engage in cACS_AOE_Freeze_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Freeze();
	}
	
	entry function Freeze()
	{
		LockEntryFunction(true);
		Freeze_Activate();
		LockEntryFunction(false);
	}
	
	latent function Freeze_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\characters\canaris\canaris_groundrift.w2ent", true ), ACSPlayerFixZAxis (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('ground_fx');
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Freeze_LVL_3()
{
	var vACS_AOE_Freeze_LVL_3 : cACS_AOE_Freeze_LVL_3;
	vACS_AOE_Freeze_LVL_3 = new cACS_AOE_Freeze_LVL_3 in theGame;
			
	vACS_AOE_Freeze_LVL_3.ACS_AOE_Freeze_LVL_3_Engage();
}

statemachine class cACS_AOE_Freeze_LVL_3
{
    function ACS_AOE_Freeze_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Freeze_LVL_3_Engage');
	}
}

state ACS_AOE_Freeze_LVL_3_Engage in cACS_AOE_Freeze_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Freeze();
	}
	
	entry function Freeze()
	{
		LockEntryFunction(true);
		Freeze_Activate();
		LockEntryFunction(false);
	}
	
	latent function Freeze_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "fx\characters\canaris\canaris_groundrift.w2ent", true ), ACSPlayerFixZAxis (actortarget.GetWorldPosition()), actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('ground_fx');
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandstorm_LVL_1()
{
	var vACS_AOE_Sandstorm_LVL_1 : cACS_AOE_Sandstorm_LVL_1;
	vACS_AOE_Sandstorm_LVL_1 = new cACS_AOE_Sandstorm_LVL_1 in theGame;
			
	vACS_AOE_Sandstorm_LVL_1.ACS_AOE_Sandstorm_LVL_1_Engage();
}

statemachine class cACS_AOE_Sandstorm_LVL_1
{
    function ACS_AOE_Sandstorm_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Sandstorm_LVL_1_Engage');
	}
}

state ACS_AOE_Sandstorm_LVL_1_Engage in cACS_AOE_Sandstorm_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandstorm();
	}
	
	entry function Sandstorm()
	{
		LockEntryFunction(true);
		Sandstorm_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandstorm_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandstorm_LVL_2()
{
	var vACS_AOE_Sandstorm_LVL_2 : cACS_AOE_Sandstorm_LVL_2;
	vACS_AOE_Sandstorm_LVL_2 = new cACS_AOE_Sandstorm_LVL_2 in theGame;
			
	vACS_AOE_Sandstorm_LVL_2.ACS_AOE_Sandstorm_LVL_2_Engage();
}

statemachine class cACS_AOE_Sandstorm_LVL_2
{
    function ACS_AOE_Sandstorm_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Sandstorm_LVL_2_Engage');
	}
}

state ACS_AOE_Sandstorm_LVL_2_Engage in cACS_AOE_Sandstorm_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandstorm();
	}
	
	entry function Sandstorm()
	{
		LockEntryFunction(true);
		Sandstorm_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandstorm_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandstorm_LVL_3()
{
	var vACS_AOE_Sandstorm_LVL_3 : cACS_AOE_Sandstorm_LVL_3;
	vACS_AOE_Sandstorm_LVL_3 = new cACS_AOE_Sandstorm_LVL_3 in theGame;
			
	vACS_AOE_Sandstorm_LVL_3.ACS_AOE_Sandstorm_LVL_3_Engage();
}

statemachine class cACS_AOE_Sandstorm_LVL_3
{
    function ACS_AOE_Sandstorm_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Sandstorm_LVL_3_Engage');
	}
}

state ACS_AOE_Sandstorm_LVL_3_Engage in cACS_AOE_Sandstorm_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandstorm();
	}
	
	entry function Sandstorm()
	{
		LockEntryFunction(true);
		Sandstorm_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandstorm_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandpillar_LVL_1()
{
	var vACS_AOE_Sandpillar_LVL_1 : cACS_AOE_Sandpillar_LVL_1;
	vACS_AOE_Sandpillar_LVL_1 = new cACS_AOE_Sandpillar_LVL_1 in theGame;
			
	vACS_AOE_Sandpillar_LVL_1.ACS_AOE_Sandpillar_LVL_1_Engage();
}

statemachine class cACS_AOE_Sandpillar_LVL_1
{
    function ACS_AOE_Sandpillar_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Sandpillar_LVL_1_Engage');
	}
}

state ACS_AOE_Sandpillar_LVL_1_Engage in cACS_AOE_Sandpillar_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandpillar();
	}
	
	entry function Sandpillar()
	{
		LockEntryFunction(true);
		Sandpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandpillar_LVL_2()
{
	var vACS_AOE_Sandpillar_LVL_2 : cACS_AOE_Sandpillar_LVL_2;
	vACS_AOE_Sandpillar_LVL_2 = new cACS_AOE_Sandpillar_LVL_2 in theGame;
			
	vACS_AOE_Sandpillar_LVL_2.ACS_AOE_Sandpillar_LVL_2_Engage();
}

statemachine class cACS_AOE_Sandpillar_LVL_2
{
    function ACS_AOE_Sandpillar_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Sandpillar_LVL_2_Engage');
	}
}

state ACS_AOE_Sandpillar_LVL_2_Engage in cACS_AOE_Sandpillar_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandpillar();
	}
	
	entry function Sandpillar()
	{
		LockEntryFunction(true);
		Sandpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Sandpillar_LVL_3()
{
	var vACS_AOE_Sandpillar_LVL_3 : cACS_AOE_Sandpillar_LVL_3;
	vACS_AOE_Sandpillar_LVL_3 = new cACS_AOE_Sandpillar_LVL_3 in theGame;
			
	vACS_AOE_Sandpillar_LVL_3.ACS_AOE_Sandpillar_LVL_3_Engage();
}

statemachine class cACS_AOE_Sandpillar_LVL_3
{
    function ACS_AOE_Sandpillar_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Sandpillar_LVL_3_Engage');
	}
}

state ACS_AOE_Sandpillar_LVL_3_Engage in cACS_AOE_Sandpillar_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sandpillar();
	}
	
	entry function Sandpillar()
	{
		LockEntryFunction(true);
		Sandpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Sandpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\gameplay\abilities\mage\sand_gusts.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Waterarc_LVL_1()
{
	var vACS_AOE_Waterarc_LVL_1 : cACS_AOE_Waterarc_LVL_1;
	vACS_AOE_Waterarc_LVL_1 = new cACS_AOE_Waterarc_LVL_1 in theGame;
			
	vACS_AOE_Waterarc_LVL_1.ACS_AOE_Waterarc_LVL_1_Engage();
}

statemachine class cACS_AOE_Waterarc_LVL_1
{
    function ACS_AOE_Waterarc_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Waterarc_LVL_1_Engage');
	}
}

state ACS_AOE_Waterarc_LVL_1_Engage in cACS_AOE_Waterarc_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Waterarc();
	}
	
	entry function Waterarc()
	{
		LockEntryFunction(true);
		Waterarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Waterarc_LVL_2()
{
	var vACS_AOE_Waterarc_LVL_2 : cACS_AOE_Waterarc_LVL_2;
	vACS_AOE_Waterarc_LVL_2 = new cACS_AOE_Waterarc_LVL_2 in theGame;
			
	vACS_AOE_Waterarc_LVL_2.ACS_AOE_Waterarc_LVL_2_Engage();
}

statemachine class cACS_AOE_Waterarc_LVL_2
{
    function ACS_AOE_Waterarc_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Waterarc_LVL_2_Engage');
	}
}

state ACS_AOE_Waterarc_LVL_2_Engage in cACS_AOE_Waterarc_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Waterarc();
	}
	
	entry function Waterarc()
	{
		LockEntryFunction(true);
		Waterarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Waterarc_LVL_3()
{
	var vACS_AOE_Waterarc_LVL_3 : cACS_AOE_Waterarc_LVL_3;
	vACS_AOE_Waterarc_LVL_3 = new cACS_AOE_Waterarc_LVL_3 in theGame;
			
	vACS_AOE_Waterarc_LVL_3.ACS_AOE_Waterarc_LVL_3_Engage();
}

statemachine class cACS_AOE_Waterarc_LVL_3
{
    function ACS_AOE_Waterarc_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Waterarc_LVL_3_Engage');
	}
}

state ACS_AOE_Waterarc_LVL_3_Engage in cACS_AOE_Waterarc_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Waterarc();
	}
	
	entry function Waterarc()
	{
		LockEntryFunction(true);
		Waterarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z += 1.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_AOE_Waterpillar_LVL_1()
{
	var vACS_AOE_Waterpillar_LVL_1 : cACS_AOE_Waterpillar_LVL_1;
	vACS_AOE_Waterpillar_LVL_1 = new cACS_AOE_Waterpillar_LVL_1 in theGame;
			
	vACS_AOE_Waterpillar_LVL_1.ACS_AOE_Waterpillar_LVL_1_Engage();
}

statemachine class cACS_AOE_Waterpillar_LVL_1
{
    function ACS_AOE_Waterpillar_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Waterpillar_LVL_1_Engage');
	}
}

state ACS_AOE_Waterpillar_LVL_1_Engage in cACS_AOE_Waterpillar_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Waterpillar();
	}
	
	entry function Waterpillar()
	{
		LockEntryFunction(true);
		Waterpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');

			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Waterpillar_LVL_2()
{
	var vACS_AOE_Waterpillar_LVL_2 : cACS_AOE_Waterpillar_LVL_2;
	vACS_AOE_Waterpillar_LVL_2 = new cACS_AOE_Waterpillar_LVL_2 in theGame;
			
	vACS_AOE_Waterpillar_LVL_2.ACS_AOE_Waterpillar_LVL_2_Engage();
}

statemachine class cACS_AOE_Waterpillar_LVL_2
{
    function ACS_AOE_Waterpillar_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Waterpillar_LVL_2_Engage');
	}
}

state ACS_AOE_Waterpillar_LVL_2_Engage in cACS_AOE_Waterpillar_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Waterpillar();
	}
	
	entry function Waterpillar()
	{
		LockEntryFunction(true);
		Waterpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');

			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Waterpillar_LVL_3()
{
	var vACS_AOE_Waterpillar_LVL_3 : cACS_AOE_Waterpillar_LVL_3;
	vACS_AOE_Waterpillar_LVL_3 = new cACS_AOE_Waterpillar_LVL_3 in theGame;
			
	vACS_AOE_Waterpillar_LVL_3.ACS_AOE_Waterpillar_LVL_3_Engage();
}

statemachine class cACS_AOE_Waterpillar_LVL_3
{
    function ACS_AOE_Waterpillar_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Waterpillar_LVL_3_Engage');
	}
}

state ACS_AOE_Waterpillar_LVL_3_Engage in cACS_AOE_Waterpillar_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Waterpillar();
	}
	
	entry function Waterpillar()
	{
		LockEntryFunction(true);
		Waterpillar_Activate();
		LockEntryFunction(false);
	}
	
	latent function Waterpillar_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			markerNPC.PlayEffectSingle('up');
			markerNPC.PlayEffectSingle('blood_up');
			markerNPC.PlayEffectSingle('warning_up');

			if( RandF() < 0.5 ) 
			{
				markerNPC.PlayEffectSingle('diagonal_up_right');
				markerNPC.PlayEffectSingle('blood_diagonal_up_right');
				markerNPC.PlayEffectSingle('warning_up_right');
			}
			else
			{
				markerNPC.PlayEffectSingle('diagonal_up_left');
				markerNPC.PlayEffectSingle('blood_diagonal_up_left');
				markerNPC.PlayEffectSingle('warning_up_left');
			}
			
			markerNPC.DestroyAfter(3);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Bloodarc_LVL_1()
{
	var vACS_AOE_Bloodarc_LVL_1 : cACS_AOE_Bloodarc_LVL_1;
	vACS_AOE_Bloodarc_LVL_1 = new cACS_AOE_Bloodarc_LVL_1 in theGame;
			
	vACS_AOE_Bloodarc_LVL_1.ACS_AOE_Bloodarc_LVL_1_Engage();
}

statemachine class cACS_AOE_Bloodarc_LVL_1
{
    function ACS_AOE_Bloodarc_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Bloodarc_LVL_1_Engage');
	}
}

state ACS_AOE_Bloodarc_LVL_1_Engage in cACS_AOE_Bloodarc_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Bloodarc();
	}
	
	entry function Bloodarc()
	{
		LockEntryFunction(true);
		Bloodarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bloodarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z -= 0.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');
			
			markerNPC.DestroyAfter(3);
		}

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Bloodarc_LVL_2()
{
	var vACS_AOE_Bloodarc_LVL_2 : cACS_AOE_Bloodarc_LVL_2;
	vACS_AOE_Bloodarc_LVL_2 = new cACS_AOE_Bloodarc_LVL_2 in theGame;
			
	vACS_AOE_Bloodarc_LVL_2.ACS_AOE_Bloodarc_LVL_2_Engage();
}

statemachine class cACS_AOE_Bloodarc_LVL_2
{
    function ACS_AOE_Bloodarc_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Bloodarc_LVL_2_Engage');
	}
}

state ACS_AOE_Bloodarc_LVL_2_Engage in cACS_AOE_Bloodarc_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Bloodarc();
	}
	
	entry function Bloodarc()
	{
		LockEntryFunction(true);
		Bloodarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bloodarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z -= 0.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');
			
			markerNPC.DestroyAfter(3);
		}

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_AOE_Bloodarc_LVL_3
{
    function ACS_AOE_Bloodarc_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Bloodarc_LVL_3_Engage');
	}
}

state ACS_AOE_Bloodarc_LVL_3_Engage in cACS_AOE_Bloodarc_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Bloodarc();
	}
	
	entry function Bloodarc()
	{
		LockEntryFunction(true);
		Bloodarc_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bloodarc_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			targetPositionNPC = actortarget.GetWorldPosition();
			targetPositionNPC.Z -= 0.5;

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\gameplay\abilities\water_mage\sand_gusts_bob.w2ent", true ), targetPositionNPC, actortarget.GetWorldRotation() );
			
			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');

			markerNPC.PlayEffectSingle('blood_diagonal_up_right');

			markerNPC.PlayEffectSingle('blood_diagonal_up_left');

			markerNPC.PlayEffectSingle('blood_up');
			
			markerNPC.DestroyAfter(3);
		}

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Igni_Blast_LVL_1()
{
	var vACS_AOE_Igni_Blast_LVL_1 : cACS_AOE_Igni_Blast_LVL_1;
	vACS_AOE_Igni_Blast_LVL_1 = new cACS_AOE_Igni_Blast_LVL_1 in theGame;
			
	vACS_AOE_Igni_Blast_LVL_1.ACS_AOE_Igni_Blast_LVL_1_Engage();
}

statemachine class cACS_AOE_Igni_Blast_LVL_1
{
    function ACS_AOE_Igni_Blast_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Igni_Blast_LVL_1_Engage');
	}
}

state ACS_AOE_Igni_Blast_LVL_1_Engage in cACS_AOE_Igni_Blast_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Igni_Blast();
	}
	
	entry function Igni_Blast()
	{
		LockEntryFunction(true);
		Igni_Blast_Activate();
		LockEntryFunction(false);
	}
	
	latent function Igni_Blast_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffectSingle('critical_igni');
			markerNPC.DestroyAfter(1.5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Igni_Blast_LVL_2()
{
	var vACS_AOE_Igni_Blast_LVL_2 : cACS_AOE_Igni_Blast_LVL_2;
	vACS_AOE_Igni_Blast_LVL_2 = new cACS_AOE_Igni_Blast_LVL_2 in theGame;
			
	vACS_AOE_Igni_Blast_LVL_2.ACS_AOE_Igni_Blast_LVL_2_Engage();
}

statemachine class cACS_AOE_Igni_Blast_LVL_2
{
    function ACS_AOE_Igni_Blast_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Igni_Blast_LVL_2_Engage');
	}
}

state ACS_AOE_Igni_Blast_LVL_2_Engage in cACS_AOE_Igni_Blast_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Igni_Blast();
	}
	
	entry function Igni_Blast()
	{
		LockEntryFunction(true);
		Igni_Blast_Activate();
		LockEntryFunction(false);
	}
	
	latent function Igni_Blast_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffectSingle('critical_igni');
			markerNPC.DestroyAfter(1.5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Igni_Blast_LVL_3()
{
	var vACS_AOE_Igni_Blast_LVL_3 : cACS_AOE_Igni_Blast_LVL_3;
	vACS_AOE_Igni_Blast_LVL_3 = new cACS_AOE_Igni_Blast_LVL_3 in theGame;
			
	vACS_AOE_Igni_Blast_LVL_3.ACS_AOE_Igni_Blast_LVL_3_Engage();
}

statemachine class cACS_AOE_Igni_Blast_LVL_3
{
    function ACS_AOE_Igni_Blast_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Igni_Blast_LVL_3_Engage');
	}
}

state ACS_AOE_Igni_Blast_LVL_3_Engage in cACS_AOE_Igni_Blast_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var markerNPC																																					: CEntity;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Igni_Blast();
	}
	
	entry function Igni_Blast()
	{
		LockEntryFunction(true);
		Igni_Blast_Activate();
		LockEntryFunction(false);
	}
	
	latent function Igni_Blast_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{	
			actortarget = (CActor)actors[i];
		
			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), actortarget.GetWorldPosition(), actortarget.GetWorldRotation() );
			markerNPC.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
			markerNPC.PlayEffectSingle('explode');
			markerNPC.DestroyAfter(2.5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Magic_Missiles_LVL_1()
{
	var vACS_AOE_Magic_Missiles_LVL_1 : cACS_AOE_Magic_Missiles_LVL_1;
	vACS_AOE_Magic_Missiles_LVL_1 = new cACS_AOE_Magic_Missiles_LVL_1 in theGame;
			
	vACS_AOE_Magic_Missiles_LVL_1.ACS_AOE_Magic_Missiles_LVL_1_Engage();
}

statemachine class cACS_AOE_Magic_Missiles_LVL_1
{
    function ACS_AOE_Magic_Missiles_LVL_1_Engage()
	{
		this.PushState('ACS_AOE_Magic_Missiles_LVL_1_Engage');
	}
}

state ACS_AOE_Magic_Missiles_LVL_1_Engage in cACS_AOE_Magic_Missiles_LVL_1
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var proj_1																																						: W3ACSIceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Magic_Missiles();
	}
	
	entry function Magic_Missiles()
	{
		LockEntryFunction(true);
		Magic_Missiles_Activate();
		LockEntryFunction(false);
	}
	
	latent function Magic_Missiles_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.35f);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode_copy');
			proj_1.PlayEffectSingle('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_AOE_Magic_Missiles_LVL_2()
{
	var vACS_AOE_Magic_Missiles_LVL_2 : cACS_AOE_Magic_Missiles_LVL_2;
	vACS_AOE_Magic_Missiles_LVL_2 = new cACS_AOE_Magic_Missiles_LVL_2 in theGame;
			
	vACS_AOE_Magic_Missiles_LVL_2.ACS_AOE_Magic_Missiles_LVL_2_Engage();
}

statemachine class cACS_AOE_Magic_Missiles_LVL_2
{
    function ACS_AOE_Magic_Missiles_LVL_2_Engage()
	{
		this.PushState('ACS_AOE_Magic_Missiles_LVL_2_Engage');
	}
}

state ACS_AOE_Magic_Missiles_LVL_2_Engage in cACS_AOE_Magic_Missiles_LVL_2
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var proj_1																																						: W3ACSIceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Magic_Missiles();
	}
	
	entry function Magic_Missiles()
	{
		LockEntryFunction(true);
		Magic_Missiles_Activate();
		LockEntryFunction(false);
	}
	
	latent function Magic_Missiles_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.35f);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode_copy');
			proj_1.PlayEffectSingle('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_AOE_Magic_Missiles_LVL_3()
{
	var vACS_AOE_Magic_Missiles_LVL_3 : cACS_AOE_Magic_Missiles_LVL_3;
	vACS_AOE_Magic_Missiles_LVL_3 = new cACS_AOE_Magic_Missiles_LVL_3 in theGame;
			
	vACS_AOE_Magic_Missiles_LVL_3.ACS_AOE_Magic_Missiles_LVL_3_Engage();
}

statemachine class cACS_AOE_Magic_Missiles_LVL_3
{
    function ACS_AOE_Magic_Missiles_LVL_3_Engage()
	{
		this.PushState('ACS_AOE_Magic_Missiles_LVL_3_Engage');
	}
}

state ACS_AOE_Magic_Missiles_LVL_3_Engage in cACS_AOE_Magic_Missiles_LVL_3
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var proj_1																																						: W3ACSIceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Magic_Missiles();
	}
	
	entry function Magic_Missiles()
	{
		LockEntryFunction(true);
		Magic_Missiles_Activate();
		LockEntryFunction(false);
	}
	
	latent function Magic_Missiles_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
					
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 10;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.35f);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\soceress_arcane_missile.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode_copy');
			proj_1.PlayEffectSingle('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Rend_Projectile_Switch()
{
	var maxAdrenaline								: float;
	var curAdrenaline								: float;

	maxAdrenaline = GetWitcherPlayer().GetStatMax(BCS_Focus);
		
	curAdrenaline = GetWitcherPlayer().GetStat(BCS_Focus);

	GetACSWatcher().RemoveTimer('RendProjectileSwitchDelay');

	if ( ACS_ElementalRend_Enabled() )
	{
		if (curAdrenaline >= maxAdrenaline * 2/3)
		{
			if( GetWitcherPlayer().GetEquippedSign() == ST_Igni && GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Ifrit_Fire_Projectile();
			}
			else if( GetWitcherPlayer().GetEquippedSign() == ST_Axii && GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Eredin_Frost_Projectile();
			}
			else if( GetWitcherPlayer().GetEquippedSign() == ST_Aard && GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Golem_Stone_Projectile();
			}
			else if( GetWitcherPlayer().GetEquippedSign() == ST_Quen && GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Root_Projectile();
			}
			else if( GetWitcherPlayer().GetEquippedSign() == ST_Yrden && GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') && GetWitcherPlayer().CanUseSkill(S_Sword_s02))
			{
				ACS_Giant_Shockwave_Mult();
			}
		}
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Eredin_Frost_Projectile()
{
	var vACS_Eredin_Frost_Projectile : cACS_Eredin_Frost_Projectile;
	vACS_Eredin_Frost_Projectile = new cACS_Eredin_Frost_Projectile in theGame;
			
	vACS_Eredin_Frost_Projectile.ACS_Eredin_Frost_Projectile_Engage();
}

statemachine class cACS_Eredin_Frost_Projectile
{
    function ACS_Eredin_Frost_Projectile_Engage()
	{
		this.PushState('ACS_Eredin_Frost_Projectile_Engage');
	}
}

state ACS_Eredin_Frost_Projectile_Engage in cACS_Eredin_Frost_Projectile
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3ACSEredinFrostLine;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Eredin_Frost_Projectile();
	}
	
	entry function Eredin_Frost_Projectile()
	{
		LockEntryFunction(true);
		Eredin_Frost_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Eredin_Frost_Projectile_Activate()
	{
		//position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 2) + GetWitcherPlayer().GetHeadingVector() * 1.7;
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + GetWitcherPlayer().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_2 = position + (GetWitcherPlayer().GetWorldRight() * -6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_3 = position + (GetWitcherPlayer().GetWorldRight() * 6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_4 = position + (GetWitcherPlayer().GetWorldRight() * -13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_5 = position + (GetWitcherPlayer().GetWorldRight() * 13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		if (!GetWitcherPlayer().HasTag('eredin_frost_proj_begin') && !GetWitcherPlayer().HasTag('eredin_frost_proj_1st') && !GetWitcherPlayer().HasTag('eredin_frost_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.10 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, GetWitcherPlayer(), 'acs_weapon_effects' ); 
						}
					}
				}
			}		
			
			proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			GetWitcherPlayer().AddTag('eredin_frost_proj_begin');
			GetWitcherPlayer().AddTag('eredin_frost_proj_1st');
		}
		else if (GetWitcherPlayer().HasTag('eredin_frost_proj_begin') && GetWitcherPlayer().HasTag('eredin_frost_proj_1st'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.25 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, GetWitcherPlayer(), 'acs_weapon_effects' ); 
						}
					}
				}
			}	
			
			proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('eredin_frost_proj_1st');
			GetWitcherPlayer().AddTag('eredin_frost_proj_2nd');
		}
		else if (GetWitcherPlayer().HasTag('eredin_frost_proj_begin') && GetWitcherPlayer().HasTag('eredin_frost_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_SlowdownFrost ) && !actortarget.HasBuff( EET_SlowdownFrost ) ) 
					{ 
						actortarget.AddEffectDefault( EET_SlowdownFrost, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
					
					if( RandF() < 0.75 ) 
					{ 
						if( !actortarget.IsImmuneToBuff( EET_Frozen ) && !actortarget.HasBuff( EET_Frozen ) ) 
						{ 
							actortarget.AddEffectDefault( EET_Frozen, GetWitcherPlayer(), 'acs_weapon_effects' ); 
						}
					}
				}
			}	
			
			proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('eredin_frost_proj_begin');
			GetWitcherPlayer().RemoveTag('eredin_frost_proj_1st');
			GetWitcherPlayer().RemoveTag('eredin_frost_proj_2nd');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Ifrit_Fire_Projectile()
{
	var vACS_Ifrit_Fire_Projectile : cACS_Ifrit_Fire_Projectile;
	vACS_Ifrit_Fire_Projectile = new cACS_Ifrit_Fire_Projectile in theGame;
			
	vACS_Ifrit_Fire_Projectile.ACS_Ifrit_Fire_Projectile_Engage();
}

statemachine class cACS_Ifrit_Fire_Projectile
{
    function ACS_Ifrit_Fire_Projectile_Engage()
	{
		this.PushState('ACS_Ifrit_Fire_Projectile_Engage');
	}
}

state ACS_Ifrit_Fire_Projectile_Engage in cACS_Ifrit_Fire_Projectile
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3ACSFireLine;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ifrit_Fire_Projectile();
	}
	
	entry function Ifrit_Fire_Projectile()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Ifrit_Fire_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Ifrit_Fire_Projectile_Activate()
	{
		//position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 2) + GetWitcherPlayer().GetHeadingVector() * 1.7;
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.5) + GetWitcherPlayer().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_2 = position + (GetWitcherPlayer().GetWorldRight() * -6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_3 = position + (GetWitcherPlayer().GetWorldRight() * 6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_4 = position + (GetWitcherPlayer().GetWorldRight() * -13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_5 = position + (GetWitcherPlayer().GetWorldRight() * 13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		if (!GetWitcherPlayer().HasTag('ifrit_fire_proj_begin') && !GetWitcherPlayer().HasTag('ifrit_fire_proj_1st') && !GetWitcherPlayer().HasTag('ifrit_fire_proj_2nd'))
		{	
			proj_1 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			GetWitcherPlayer().AddTag('ifrit_fire_proj_begin');
			GetWitcherPlayer().AddTag('ifrit_fire_proj_1st');
		}
		else if (GetWitcherPlayer().HasTag('ifrit_fire_proj_begin') && GetWitcherPlayer().HasTag('ifrit_fire_proj_1st'))
		{
			proj_1 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('ifrit_fire_proj_1st');
			GetWitcherPlayer().AddTag('ifrit_fire_proj_2nd');
		}
		else if (GetWitcherPlayer().HasTag('ifrit_fire_proj_begin') && GetWitcherPlayer().HasTag('ifrit_fire_proj_2nd'))
		{	
			proj_1 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('ifrit_fire_proj_begin');
			GetWitcherPlayer().RemoveTag('ifrit_fire_proj_1st');
			GetWitcherPlayer().RemoveTag('ifrit_fire_proj_2nd');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Golem_Stone_Projectile()
{
	var vACS_Golem_Stone_Projectile : cACS_Golem_Stone_Projectile;
	vACS_Golem_Stone_Projectile = new cACS_Golem_Stone_Projectile in theGame;
			
	vACS_Golem_Stone_Projectile.ACS_Golem_Stone_Projectile_Engage();
}

statemachine class cACS_Golem_Stone_Projectile
{
    function ACS_Golem_Stone_Projectile_Engage()
	{
		this.PushState('ACS_Golem_Stone_Projectile_Engage');
	}
}

state ACS_Golem_Stone_Projectile_Engage in cACS_Golem_Stone_Projectile
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5																																		: W3ACSRockLine;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Golem_Stone_Projectile();
	}
	
	entry function Golem_Stone_Projectile()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
		}
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Golem_Stone_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Golem_Stone_Projectile_Activate()
	{
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 2.2) + GetWitcherPlayer().GetHeadingVector() * 1.7;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_2 = position + (GetWitcherPlayer().GetWorldRight() * -6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_3 = position + (GetWitcherPlayer().GetWorldRight() * 6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_4 = position + (GetWitcherPlayer().GetWorldRight() * -13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_5 = position + (GetWitcherPlayer().GetWorldRight() * 13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		if (!GetWitcherPlayer().HasTag('golem_stone_proj_begin') && !GetWitcherPlayer().HasTag('golem_stone_proj_1st') && !GetWitcherPlayer().HasTag('golem_stone_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			GetWitcherPlayer().AddTag('golem_stone_proj_begin');
			GetWitcherPlayer().AddTag('golem_stone_proj_1st');
		}
		else if (GetWitcherPlayer().HasTag('golem_stone_proj_begin') && GetWitcherPlayer().HasTag('golem_stone_proj_1st'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('golem_stone_proj_1st');
			GetWitcherPlayer().AddTag('golem_stone_proj_2nd');
		}
		else if (GetWitcherPlayer().HasTag('golem_stone_proj_begin') && GetWitcherPlayer().HasTag('golem_stone_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 80, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_Stagger ) && !actortarget.HasBuff( EET_Stagger ) ) 
					{ 
						actortarget.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(5);
			
			proj_2 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(5);		
			
			proj_3 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(5);
			
			proj_4 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(5);
			
			proj_5 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(5);
			
			GetWitcherPlayer().RemoveTag('golem_stone_proj_begin');
			GetWitcherPlayer().RemoveTag('golem_stone_proj_1st');
			GetWitcherPlayer().RemoveTag('golem_stone_proj_2nd');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Root_Projectile()
{
	var vACS_Root_Projectile : cACS_Root_Projectile;
	vACS_Root_Projectile = new cACS_Root_Projectile in theGame;
			
	vACS_Root_Projectile.ACS_Root_Projectile_Engage();
}

statemachine class cACS_Root_Projectile
{
    function ACS_Root_Projectile_Engage()
	{
		this.PushState('ACS_Root_Projectile_Engage');
	}
}

state ACS_Root_Projectile_Engage in cACS_Root_Projectile
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5 																														: W3ACSRootAttack;
	private var position_1, position_2, position_3, position_4, position_5																									: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Root_Projectile();
	}
	
	entry function Root_Projectile()
	{
		LockEntryFunction(true);
		Root_Projectile_Activate();
		LockEntryFunction(false);
	}
	
	latent function Root_Projectile_Activate()
	{
		position_1 = GetWitcherPlayer().GetTarget().GetWorldPosition();
		position_1 = ACSPlayerFixZAxis(position_1);
		
		position_2 = GetWitcherPlayer().GetTarget().GetWorldPosition() + GetWitcherPlayer().GetTarget().GetWorldRight() * 2.5;
		position_2 = ACSPlayerFixZAxis(position_2);
		
		position_3 = GetWitcherPlayer().GetTarget().GetWorldPosition() + GetWitcherPlayer().GetTarget().GetWorldRight() * -2.5;
		position_3 = ACSPlayerFixZAxis(position_3);
		
		position_4 = GetWitcherPlayer().GetTarget().GetWorldPosition() + GetWitcherPlayer().GetTarget().GetWorldRight() * 5.5;
		position_4 = ACSPlayerFixZAxis(position_4);
		
		position_5 = GetWitcherPlayer().GetTarget().GetWorldPosition() + GetWitcherPlayer().GetTarget().GetWorldRight() * -5.5;
		position_5 = ACSPlayerFixZAxis(position_5);
		
		if (!GetWitcherPlayer().HasTag('root_proj_begin') && !GetWitcherPlayer().HasTag('root_proj_1st') && !GetWitcherPlayer().HasTag('root_proj_2nd'))
		{
			proj_1 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_1) );
			proj_1.DestroyAfter(5);		
			
			GetWitcherPlayer().AddTag('root_proj_begin');
			GetWitcherPlayer().AddTag('root_proj_1st');
		}
		else if (GetWitcherPlayer().HasTag('root_proj_begin') && GetWitcherPlayer().HasTag('root_proj_1st'))
		{
			proj_1 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_1) );
			proj_1.DestroyAfter(5);	
			
			proj_2 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_2) );
			proj_2.DestroyAfter(5);	
			
			proj_3 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_3) );
			proj_3.DestroyAfter(5);	
			
			GetWitcherPlayer().RemoveTag('root_proj_1st');
			GetWitcherPlayer().AddTag('root_proj_2nd');
		}
		else if (GetWitcherPlayer().HasTag('root_proj_begin') && GetWitcherPlayer().HasTag('root_proj_2nd'))
		{
			proj_1 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_1) );
			proj_1.DestroyAfter(5);	
			
			proj_2 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_2) );
			proj_2.DestroyAfter(5);	
			
			proj_3 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_3) );
			proj_3.DestroyAfter(5);	
			
			proj_4 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_4) );
			proj_4.DestroyAfter(5);	
			
			proj_5 = (W3ACSRootAttack)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent", true ), ACSPlayerFixZAxis(position_5) );
			proj_5.DestroyAfter(5);	
			
			GetWitcherPlayer().RemoveTag('root_proj_begin');
			GetWitcherPlayer().RemoveTag('root_proj_1st');
			GetWitcherPlayer().RemoveTag('root_proj_2nd');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Giant_Shockwave_Mult()
{
	var vACS_Giant_Shockwave_Mult : cACS_Giant_Shockwave_Mult;
	vACS_Giant_Shockwave_Mult = new cACS_Giant_Shockwave_Mult in theGame;
			
	vACS_Giant_Shockwave_Mult.ACS_Giant_Shockwave_Mult_Engage();
}

statemachine class cACS_Giant_Shockwave_Mult
{
    function ACS_Giant_Shockwave_Mult_Engage()
	{
		this.PushState('ACS_Giant_Shockwave_Mult_Engage');
	}
}

state ACS_Giant_Shockwave_Mult_Engage in cACS_Giant_Shockwave_Mult
{
	private var proj_1 																																: W3ACSGiantShockwave;
	private var proj_2, proj_3, proj_4, proj_5																										: W3ACSSharleyShockwave;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position									: Vector;
	private var actors																																: array<CActor>;
	private var i         																															: int;
	private var actortarget					       																									: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Shockwave();
	}
	
	entry function Giant_Shockwave()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
		}
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Giant_Shockwave_Activate();
		LockEntryFunction(false);
	}
	
	latent function Giant_Shockwave_Activate()
	{
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + GetWitcherPlayer().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_2 = position + (GetWitcherPlayer().GetWorldRight() * -6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_3 = position + (GetWitcherPlayer().GetWorldRight() * 6.5) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_4 = position + (GetWitcherPlayer().GetWorldRight() * -13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		targetPosition_5 = position + (GetWitcherPlayer().GetWorldRight() * 13) + GetWitcherPlayer().GetHeadingVector() * 30;
		
		if (!GetWitcherPlayer().HasTag('giant_shockwave_proj_begin') && !GetWitcherPlayer().HasTag('giant_shockwave_proj_1st') && !GetWitcherPlayer().HasTag('giant_shockwave_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSGiantShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			GetWitcherPlayer().AddTag('giant_shockwave_proj_begin');
			GetWitcherPlayer().AddTag('giant_shockwave_proj_1st');

			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'ACS_Stabbed', true);
		
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actors[i].BreakAttachment();
				actors[i].RemoveTag('ACS_Stabbed');
			}
		}
		else if (GetWitcherPlayer().HasTag('giant_shockwave_proj_begin') && GetWitcherPlayer().HasTag('giant_shockwave_proj_1st'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 40, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSGiantShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			proj_2 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(2.5);		
			
			proj_3 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(2.5);
			
			GetWitcherPlayer().RemoveTag('giant_shockwave_proj_1st');
			GetWitcherPlayer().AddTag('giant_shockwave_proj_2nd');

			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'ACS_Stabbed', true);
		
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actors[i].BreakAttachment();
				actors[i].RemoveTag('ACS_Stabbed');
			}
		}
		else if (GetWitcherPlayer().HasTag('giant_shockwave_proj_begin') && GetWitcherPlayer().HasTag('giant_shockwave_proj_2nd'))
		{
			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(30, VecHeading(GetWitcherPlayer().GetHeadingVector()), 80, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];
				
				if( actors.Size() > 0 )
				{
					if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
					{ 
						actortarget.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'acs_weapon_effects' ); 
					}
				}
			}	
			
			proj_1 = (W3ACSGiantShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\giant_shockwave_proj.w2ent", true ), position );
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_line');
			proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
			proj_1.DestroyAfter(2.5);
			
			proj_2 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_2.Init(GetWitcherPlayer());
			proj_2.PlayEffectSingle('fire_line');
			proj_2.ShootProjectileAtPosition(0,	20, targetPosition_2, 30 );
			proj_2.DestroyAfter(2.5);		
			
			proj_3 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_3.Init(GetWitcherPlayer());
			proj_3.PlayEffectSingle('fire_line');
			proj_3.ShootProjectileAtPosition(0,	20, targetPosition_3, 30 );
			proj_3.DestroyAfter(2.5);
			
			proj_4 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_4.Init(GetWitcherPlayer());
			proj_4.PlayEffectSingle('fire_line');
			proj_4.ShootProjectileAtPosition(0,	20, targetPosition_4, 30 );
			proj_4.DestroyAfter(2.5);
			
			proj_5 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent", true ), position );
			proj_5.Init(GetWitcherPlayer());
			proj_5.PlayEffectSingle('fire_line');
			proj_5.ShootProjectileAtPosition(0,	20, targetPosition_5, 30 );
			proj_5.DestroyAfter(2.5);
			
			GetWitcherPlayer().RemoveTag('giant_shockwave_proj_begin');
			GetWitcherPlayer().RemoveTag('giant_shockwave_proj_1st');
			GetWitcherPlayer().RemoveTag('giant_shockwave_proj_2nd');

			actors.Clear();

			actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'ACS_Stabbed', true);
		
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actors[i].BreakAttachment();
				actors[i].RemoveTag('ACS_Stabbed');
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Theft_Prevention_8()
{
	return;
}

function ACS_Giant_Shockwave()
{
	var vACS_Giant_Shockwave : cACS_Giant_Shockwave;
	vACS_Giant_Shockwave = new cACS_Giant_Shockwave in theGame;
			
	vACS_Giant_Shockwave.ACS_Giant_Shockwave_Engage();
}

statemachine class cACS_Giant_Shockwave
{
    function ACS_Giant_Shockwave_Engage()
	{
		this.PushState('ACS_Giant_Shockwave_Engage');
	}
}

state ACS_Giant_Shockwave_Engage in cACS_Giant_Shockwave
{
	private var proj_1																					: W3ACSSharleyShockwave;
	private var targetPosition_1, position																: Vector;
	private var actors																					: array<CActor>;
	private var i         																				: int;
	private var actortarget					       														: CActor;
	private var dmg																						: W3DamageAction;
	private var maxTargetVitality, maxTargetEssence, damageMax											: float;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Shockwave();
	}
	
	entry function Giant_Shockwave()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_dao.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_dao.bnk", false );
		}
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Giant_Shockwave_Activate();
		LockEntryFunction(false);
	}
	
	latent function Giant_Shockwave_Activate()
	{
		position = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetWorldForward() * 1.1) + GetWitcherPlayer().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetWitcherPlayer().GetHeadingVector() * 30;

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );
			
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
			
			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality );

				damageMax = maxTargetVitality * 0.05; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.05; 
			} 

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);

			dmg.SetForceExplosionDismemberment();
			
			dmg.SetHitReactionType( EHRT_Heavy, true);
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );

			if( !actortarget.IsImmuneToBuff( EET_HeavyKnockdown ) && !actortarget.HasBuff( EET_HeavyKnockdown ) ) 
			{ 
				dmg.AddEffectInfo( EET_HeavyKnockdown, 0.1 );
			}
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;	
		}
			
		proj_1 = (W3ACSSharleyShockwave)theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\entities\projectiles\giant_shockwave_proj.w2ent"

			"dlc\dlc_acs\data\entities\projectiles\sharley_shockwave_proj.w2ent"
			
			, true ), position );
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_line');
		proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
		proj_1.DestroyAfter(2.5);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Spawn_Shades()
{
	var vACS_Spawn_Shades : cACS_Spawn_Shades;
	vACS_Spawn_Shades = new cACS_Spawn_Shades in theGame;
			
	vACS_Spawn_Shades.ACS_Spawn_Shades_Engage();
}

statemachine class cACS_Spawn_Shades
{
    function ACS_Spawn_Shades_Engage()
	{
		this.PushState('ACS_Spawn_Shades_Engage');
	}
}

state ACS_Spawn_Shades_Engage in cACS_Spawn_Shades
{
	private var shadeTemplate													: CEntityTemplate;
	private var shadeEntity														: CEntity;
	private var i, shadesCount													: int;
	private var playerPos, spawnPos												: Vector;
	private var randAngle, randRange, curPlayerVitality, maxPlayerVitality		: float;
	private var playerVitality 													: EBaseCharacterStats;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Spawn_Shades();
	}
	
	entry function Spawn_Shades()
	{	
		LockEntryFunction(true);
		
		GetWitcherPlayer().StopEffect('summon');
		GetWitcherPlayer().PlayEffectSingle('summon');
	
		Spawn_Shades_Activate();
		
		LockEntryFunction(false);
	}
	
	latent function Spawn_Shades_Activate()
	{
		shadeTemplate = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\monsters\q604_shade.w2ent", true );
		playerPos = GetWitcherPlayer().GetWorldPosition();
		
		playerVitality = BCS_Vitality;
		curPlayerVitality = GetWitcherPlayer().GetStat( BCS_Vitality );
		maxPlayerVitality = GetWitcherPlayer().GetStatMax( BCS_Vitality );
		
		if ( GetWitcherPlayer().GetLevel() <= 10 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 2;
			}
			else
			{
				shadesCount = 1;
			}
		}
		else if ( GetWitcherPlayer().GetLevel() > 10 && GetWitcherPlayer().GetLevel() <= 15 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 5;
			}
			else
			{
				shadesCount = 2;
			}
		}
		else if ( GetWitcherPlayer().GetLevel() > 15 && GetWitcherPlayer().GetLevel() <= 20 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 7;
			}
			else
			{
				shadesCount = 3;
			}
		}
		else if ( GetWitcherPlayer().GetLevel() > 20 && GetWitcherPlayer().GetLevel() <= 25 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 10;
			}
			else
			{
				shadesCount = 5;
			}
		}
		else if ( GetWitcherPlayer().GetLevel() > 25 )
		{
			if ( curPlayerVitality <= maxPlayerVitality/2 )
			{
				shadesCount = 15;
			}
			else
			{
				shadesCount = 7;
			}
		}
			
		for( i = 0; i < shadesCount; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			
			shadeEntity = theGame.CreateEntity( shadeTemplate, spawnPos, GetWitcherPlayer().GetWorldRotation() );
			shadeEntity.AddTag( 'ACS_caretaker_shade' );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Beam_Attack
{
    function ACS_Beam_Attack_Engage()
	{
		if (GetWitcherPlayer().GetStat( BCS_Stamina ) > GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0)
		{
			this.PushState('ACS_Beam_Attack_Engage');
		}
	}
}

state ACS_Beam_Attack_Engage in cACS_Beam_Attack
{
	private var beam_anchor1																																		: CEntity;
	private var actortarget, actor, pActor																															: CActor;
	private var anchor_temp_1, anchor_temp_2																														: CEntityTemplate;
	private var dmg																																					: W3DamageAction;
	private var movementAdjustor1																																	: CMovementAdjustor;
	private var ticket1																																				: SMovementAdjustmentRequestTicket;
	private var i																																					: int;
	private var actors																																				: array<CActor>;
	private var curTargetVitality, curTargetEssence, maxTargetVitality, maxTargetEssence, missingTargetVitality, missingTargetEssence, damage						: float;
	private var targetVitality, targetEssence 																														: EBaseCharacterStats;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Beam_Attack();
	}
	
	entry function Beam_Attack()
	{
		Beam_Attack_Activate();
	}
	
	latent function Beam_Attack_Activate()
	{	
		GetWitcherPlayer().StopEffect('lightning_djinn');
		
		GetWitcherPlayer().PlayEffectSingle('hit_lightning');
		GetWitcherPlayer().StopEffect('hit_lightning');
		
		pActor = GetWitcherPlayer();
		
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
		anchor_temp_1 = (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_6\glyphword_6.w2ent", true);
		
		anchor_temp_2 = (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\runeword\runeword_1\runeword_1_aard.w2ent", true);
		
		targetVitality = BCS_Vitality;
		
		targetEssence = BCS_Essence;
		
		missingTargetVitality = actor.GetStatMax( BCS_Vitality ) - actor.GetStat( BCS_Vitality );
		
		missingTargetEssence = actor.GetStatMax( BCS_Essence ) - actor.GetStat( BCS_Essence );

		curTargetVitality = actor.GetStat( BCS_Vitality );

		curTargetEssence = actor.GetStat( BCS_Essence );
		
		maxTargetVitality = actor.GetStatMax( BCS_Vitality );
		
		maxTargetEssence = actor.GetStatMax( BCS_Essence );
		
		if (actor.UsesEssence())
		{
			if ( curTargetEssence <= maxTargetEssence * 0.01 )
			{
				damage = maxTargetEssence;
			}
			else
			{
				damage = 1 + curTargetEssence * 0.000625;
			}
		}
		else if (actor.UsesVitality())
		{
			if ( curTargetVitality <= maxTargetVitality * 0.01 )
			{
				damage = maxTargetVitality;
			}
			else
			{
				damage = 1 + curTargetVitality * 0.000625;
			}
		}
		
		if (GetWitcherPlayer().IsOnGround())
		{
			if( VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) <= 3.5 ) 
			{
				while (
				(theInput.GetActionValue('LockAndGuard') > 0.5f || theInput.GetActionValue('Guard') > 0.5f)
				&& GetWitcherPlayer().GetStat(BCS_Stamina) > 0
				) 
				{
					thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax( BCS_Stamina ) * 0.005, 0.1 );

					if ((theInput.GetActionValue('LockAndGuard') < -0.5f || theInput.GetActionValue('Guard') < -0.5f))
					{
						break;
					}

					actors.Clear();

					actors = GetWitcherPlayer().GetNPCsAndPlayersInCone( 3.5, VecHeading(GetWitcherPlayer().GetHeadingVector()), 20, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];
						
						GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'utility_dodge_attack_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.15f, 1.0f));
							
						beam_anchor1 = theGame.CreateEntity(anchor_temp_1, actortarget.GetWorldPosition());
						beam_anchor1.CreateAttachment( actortarget, , Vector( 0, 0, 1.5 ) );	
						beam_anchor1.AddTag('beam_anchor');
						beam_anchor1.DestroyAfter(1.5);
							
						//GetWitcherPlayer().PlayEffectSingle('shout', beam_anchor1);
						//GetWitcherPlayer().StopEffect('shout');
						
						GetWitcherPlayer().PlayEffectSingle('toad_vomit', beam_anchor1);
						GetWitcherPlayer().StopEffect('toad_vomit');
							
						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
		
						dmg.AddDamage( theGame.params.DAMAGE_NAME_POISON, damage );

						if (ACS_Armor_Equipped_Check())
						{
							if (thePlayer.GetStat(BCS_Vitality) < thePlayer.GetStatMax(BCS_Vitality))
							{
								thePlayer.GainStat(BCS_Vitality, thePlayer.GetStatMax(BCS_Vitality) * 0.00025);
							}
						}
													
						dmg.AddEffectInfo( EET_Immobilized, 2 );
						dmg.AddEffectInfo( EET_Poison, 3 );
							
						theGame.damageMgr.ProcessAction( dmg );
												
						delete dmg;	
					}

					SleepOneFrame();			
				}
			}
			else if( VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) > 3.5)
			{
				while (
				(theInput.GetActionValue('LockAndGuard') > 0.5f || theInput.GetActionValue('Guard') > 0.5f)
				&& GetWitcherPlayer().GetStat(BCS_Stamina) > 0
				) 
				{	
					thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax( BCS_Stamina ) * 0.005, 0.1 );

					if ((theInput.GetActionValue('LockAndGuard') < -0.5f || theInput.GetActionValue('Guard') < -0.5f))
					{
						break;
					}

					GetWitcherPlayer().StopEffect('lightning_djinn');
					GetWitcherPlayer().StopEffect('lightning_djinn');
					
					movementAdjustor1 = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
					movementAdjustor1.CancelByName( 'turn' );
					ticket1 = movementAdjustor1.CreateNewRequest( 'turn' );
					movementAdjustor1.AdjustmentDuration( ticket1, 0.1 );
						
					if (!GetWitcherPlayer().IsUsingHorse() && !GetWitcherPlayer().IsUsingVehicle()) {movementAdjustor1.RotateTowards( ticket1, actor );}  
				
					GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync ( 'locomotion_walkstart_forward_dettlaff_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.15f, 1.0f));

					actors.Clear();

					actors = GetWitcherPlayer().GetNPCsAndPlayersInCone( VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) , VecHeading(GetWitcherPlayer().GetHeadingVector()), 10, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors  );
					for( i = 0; i < actors.Size(); i += 1 )
					{
						actortarget = (CActor)actors[i];
						
						dmg = new W3DamageAction in theGame.damageMgr;
						dmg.Initialize(GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
						dmg.SetProcessBuffsIfNoDamage(true);
						
						dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damage / 2 );
							
						//dmg.AddEffectInfo( EET_Stagger, 0.5 );
						
						if( RandF() < 0.001 ) 
						{
							dmg.AddEffectInfo( EET_Stagger, 0.5 );
							dmg.AddEffectInfo( EET_Burning, 0.1 );
						}

						if (ACS_Armor_Equipped_Check())
						{
							if (thePlayer.GetStat(BCS_Vitality) < thePlayer.GetStatMax(BCS_Vitality))
							{
								thePlayer.GainStat(BCS_Vitality, thePlayer.GetStatMax(BCS_Vitality) * 0.00025);
							}
						}
								
						theGame.damageMgr.ProcessAction( dmg );
													
						delete dmg;	
					}
					
					beam_anchor1 = theGame.CreateEntity(anchor_temp_2, actor.GetWorldPosition());
					beam_anchor1.CreateAttachment( actor, , Vector( 0, 0, 1 ) );	
					beam_anchor1.AddTag('beam_anchor');
					beam_anchor1.DestroyAfter(1.5);
				
					GetWitcherPlayer().StopEffect('lightning_djinn');
					GetWitcherPlayer().StopEffect('lightning_djinn');
					GetWitcherPlayer().PlayEffectSingle('lightning_djinn', beam_anchor1);
					GetWitcherPlayer().StopEffect('lightning_djinn');
					GetWitcherPlayer().StopEffect('lightning_djinn');
								
					dmg = new W3DamageAction in theGame.damageMgr;
					dmg.Initialize(GetWitcherPlayer(), actor, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
					dmg.SetProcessBuffsIfNoDamage(true);
					
					dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damage );
										
					if( RandF() < 0.001 ) 
					{
						dmg.AddEffectInfo( EET_Stagger, 0.5 );
						dmg.AddEffectInfo( EET_Burning, 0.5 );
					}
								
					theGame.damageMgr.ProcessAction( dmg );
													
					delete dmg;
					
					SleepOneFrame();	
					
					GetWitcherPlayer().StopEffect('lightning_djinn');
				}
			}
			else
			{
				GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			}
			
			GetWitcherPlayer().StopEffect('lightning_djinn');
		}
		else
		{
			GetWitcherPlayer().StopEffect('lightning_djinn');
			
			GetWitcherPlayer().PlayEffectSingle('djinn_default');
			GetWitcherPlayer().StopEffect('djinn_default');
			
			if( VecDistance2D( actor.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) <= 100 ) 
			{
				while (
				(theInput.GetActionValue('LockAndGuard') > 0.5f || theInput.GetActionValue('Guard') > 0.5f)
				&& GetWitcherPlayer().GetStat(BCS_Stamina) > 0
				) 
				{	
					thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax( BCS_Stamina ) * 0.005, 0.1 );

					if ((theInput.GetActionValue('LockAndGuard') < -0.5f || theInput.GetActionValue('Guard') < -0.5f))
					{
						break;
					}

					//actors = GetActorsInRange(GetWitcherPlayer(), 20, 5);

					actors.Clear();

					actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 5, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

					for( i = 0; i < actors.Size(); i += 1 )
					{
						if 
						( 
						actors[i] == GetWitcherPlayer() 
						|| actors[i].HasTag('smokeman') 
						|| ((CNewNPC)(actors[i])).IsHorse() 
						|| actors[i].HasTag('ACS_Rat_Mage_Rat')
						|| actors[i].HasTag('ACS_Plumard')
						|| actors[i].HasTag('ACS_Tentacle_1') 
						|| actors[i].HasTag('ACS_Tentacle_2') 
						|| actors[i].HasTag('ACS_Tentacle_3') 
						|| actors[i].HasTag('ACS_Necrofiend_Tentacle_1') 
						|| actors[i].HasTag('ACS_Necrofiend_Tentacle_2') 
						|| actors[i].HasTag('ACS_Necrofiend_Tentacle_3') 
						|| actors[i].HasTag('ACS_Necrofiend_Tentacle_6')
						|| actors[i].HasTag('ACS_Necrofiend_Tentacle_5')
						|| actors[i].HasTag('ACS_Necrofiend_Tentacle_4') 
						|| actors[i].HasTag('ACS_Svalblod_Bossbar') 
						|| actors[i].HasTag('ACS_Melusine_Bossbar') 
						|| actors[i].HasTag('ACS_Vampire_Monster_Boss_Bar') 
						)
						continue;

						actortarget = (CActor)actors[i];
						
						if( actors.Size() > 0 )
						{		
							if( ACS_AttitudeCheck ( actortarget ) && actortarget.IsAlive() )
							{
								beam_anchor1 = theGame.CreateEntity(anchor_temp_2, actortarget.GetWorldPosition());
								beam_anchor1.CreateAttachment( actortarget, , Vector( 0, 0, 1 ) );	
								beam_anchor1.AddTag('beam_anchor');
								beam_anchor1.DestroyAfter(0.1);
								
								GetWitcherPlayer().StopEffect('lightning_djinn');
								GetWitcherPlayer().StopEffect('lightning_djinn');
								GetWitcherPlayer().PlayEffectSingle('lightning_djinn', beam_anchor1);
								GetWitcherPlayer().StopEffect('lightning_djinn');
								GetWitcherPlayer().StopEffect('lightning_djinn');
								
								dmg = new W3DamageAction in theGame.damageMgr;
								dmg.Initialize(GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
								dmg.SetProcessBuffsIfNoDamage(true);
								
								dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damage );

								if( RandF() < 0.001 ) 
								{
									dmg.AddEffectInfo( EET_Stagger, 0.5 );
									dmg.AddEffectInfo( EET_Burning, 0.5 );
								}

								if (ACS_Armor_Equipped_Check())
								{
									if (thePlayer.GetStat(BCS_Vitality) < thePlayer.GetStatMax(BCS_Vitality))
									{
										thePlayer.GainStat(BCS_Vitality, thePlayer.GetStatMax(BCS_Vitality) * 0.00025);
									}
								}
											
								theGame.damageMgr.ProcessAction( dmg );
																
								delete dmg;
							}
						}
					}
					
					SleepOneFrame();
				}

				GetWitcherPlayer().StopEffect('lightning_djinn');
			}
			else
			{
				GetWitcherPlayer().RaiseEvent( 'CombatTaunt' );
			}
			
			GetWitcherPlayer().StopEffect('lightning_djinn');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Detonation_Weapon_Effects_Switch
{
    function ACS_Detonation_Weapon_Effects_Switch_Engage()
	{
		GetWitcherPlayer().PlayBattleCry( 'BattleCryAttack', 1, true, false );	
		this.PushState('ACS_Detonation_Weapon_Effects_Switch_Engage');
	}
}

state ACS_Detonation_Weapon_Effects_Switch_Engage in cACS_Detonation_Weapon_Effects_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt_2, vfxEnt3		: CEntity;
	private var weaponSlotMatrix 							: Matrix;
	private var fxPos 										: Vector;
	private var fxRot 										: EulerAngles;
	private var targets 									: array<CGameplayEntity>;
	private var dist, ang									: float;
	private var pos, targetPos								: Vector;
	private var targetRot 									: EulerAngles;
	private var i											: int;
	private var npc 										: CNewNPC;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Detonation_Weapon_Effects_Switch();
	}
	
	entry function Detonation_Weapon_Effects_Switch()
	{
		Detonation_Weapon_Effects_Switch_Activate();
	}
	
	/*
	latent function Detonation_Weapon_Effects_Switch_Activate()
	{	
		weaponEntity = GetWitcherPlayer().GetInventory().GetItemEntityUnsafe(GetWitcherPlayer().GetInventory().GetItemFromSlot('r_weapon'));
		weaponEntity.CalcEntitySlotMatrix('blood_fx_point', weaponSlotMatrix);
		
		fxPos = MatrixGetTranslation(weaponSlotMatrix);
		fxRot = weaponEntity.GetWorldRotation();
		
		if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "fx\monsters\arachas\arachas_poison_cloud.w2ent", true ), fxPos, GetWitcherPlayer().GetWorldRotation() );
			vfxEnt.PlayEffectSingle('poison_cloud');
			vfxEnt.DestroyAfter(2.5);
		}
		else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffectSingle('mutation_2_igni');
			vfxEnt.DestroyAfter(1.5);
		}
		else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffectSingle('mutation_2_aard_b');
			vfxEnt.DestroyAfter(1.5);
		}
		else if ( GetWitcherPlayer().HasTag('igni_secondary_sword_equipped') )
		{
			vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), fxPos, fxRot );
			vfxEnt.PlayEffectSingle('explode');
			vfxEnt.DestroyAfter(2.5);
		}
	}
	*/

	latent function Detonation_Weapon_Effects_Switch_Activate()
	{
		if (!thePlayer.IsPerformingFinisher())
		{
			if ( thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.HasBuff(EET_BlackBlood) )
					{
						dist = 2;
						ang = 90;
					}
					else	
					{
						dist = 1.25;
						ang = 60;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}
			}
			else
			{
				if ( 
				thePlayer.HasTag('igni_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	55;

					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						ang +=	315;
					}

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_secondary_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	55;

					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						ang +=	315;
					}

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('axii_sword_equipped') )
				{
					dist = 1.6;
					ang =	55;	

					if (thePlayer.HasTag('ACS_Sparagmos_Active'))
					{
						dist += 10;
						ang +=	30;
					}
				}
				else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					if ( 
					ACS_GetWeaponMode() == 0
					|| ACS_GetWeaponMode() == 1
					|| ACS_GetWeaponMode() == 2
					)
					{
						dist = 2.25;
						ang =	55;
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{ 
						dist = 1.75;
						ang =	55;
					}
				}
				else if ( thePlayer.HasTag('aard_sword_equipped') )
				{
					dist = 2;
					ang =	75;	
				}
				else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					dist = 2;
					ang = 45;
				}
				else if ( thePlayer.HasTag('yrden_sword_equipped') )
				{
					if ( ACS_GetWeaponMode() == 0 )
					{
						if (ACS_GetArmigerModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 1 )
					{
						if (ACS_GetFocusModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 2 )
					{
						if (ACS_GetHybridModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						dist = 2.5;
						ang = 60;
					}
				}
				else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.HasTag('quen_sword_equipped') )
				{
					dist = 1.6;
					ang =	55;

					if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
					{
						ang +=	320;
					}
				}
				else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
					{
						dist = 10;
						ang =	30;
					}
					else
					{
						dist = 2.25;
						ang =	55;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}

				if (ACS_Armor_Equipped_Check())
				{
					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if( !thePlayer.IsDoingSpecialAttack( false )
						&& !thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1;
						}
					}
					else
					{
						dist += 1;
					}
				}
			}

			if ( thePlayer.GetTarget() == ACS_Big_Boi() )
			{
				dist += 0.75;
				ang += 15;
			}

			if (ACS_Player_Scale() > 1)
			{
				dist += ACS_Player_Scale() * 0.75;
			}
			else if (ACS_Player_Scale() < 1)
			{
				dist -= ACS_Player_Scale() * 0.5;
			}

			if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
			&& !thePlayer.HasTag('igni_sword_equipped') 
			&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
			&& !ACS_Armor_Equipped_Check())
			{
				dist += 1;
			}

			if (thePlayer.IsUsingHorse()) 
			{
				dist += 1.5;

				ang += 270;
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				dist += 1.5;

				ang += 315;
			}

			if (ACS_Bear_School_Check())
			{
				dist += 0.5;
				ang +=	15;

				if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Griffin_School_Check()
			&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
			{
				dist += 2;
				ang +=	15;
			}

			if (ACS_Manticore_School_Check())
			{
				dist += 0.5;

				if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Viper_School_Check())
			{
				if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					dist += 1.5;
				}
			}
		}
		else 
		{
			dist = 1;
			ang = 30;
		}

		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999,,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw = RandRangeF(360,1);
			targetRot.Pitch = RandRangeF(45,-45);

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			|| npc.HasTag('ACS_Plumard')
			|| npc.HasTag('ACS_Tentacle_1') 
			|| npc.HasTag('ACS_Tentacle_2') 
			|| npc.HasTag('ACS_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_1') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_2') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_4') 
			|| npc.HasTag('ACS_Svalblod_Bossbar') 
			|| npc.HasTag('ACS_Melusine_Bossbar') 
			|| npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
			)
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) && npc.IsAlive() )
				{
					if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), fxPos, fxRot );
						vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), fxPos, fxRot );
						vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_quen');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_quen');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_aard_b');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_aard_b');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_yrden');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_yrden');
						vfxEnt.DestroyAfter(1.5);
					}
					else if ( GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG') )
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt.PlayEffectSingle('mutation_2_igni');
						vfxEnt.DestroyAfter(1.5);

						vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\glyphword\glyphword_20\glyphword_20_explode.w2ent", true ), targetPos, targetRot );
						vfxEnt_2.PlayEffectSingle('explode');
						vfxEnt_2.DestroyAfter(2.5);
					}
				}
			}
		}	
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Passive_Weapon_Effects_Switch
{
    function ACS_Passive_Weapon_Effects_Switch_Engage()
	{
		this.PushState('ACS_Passive_Weapon_Effects_Switch_Engage');
	}
}

state ACS_Passive_Weapon_Effects_Switch_Engage in cACS_Passive_Weapon_Effects_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt2, vfxEnt3, vfxEnt4			: CEntity;
	private var weaponSlotMatrix 										: Matrix;
	private var fxPos 													: Vector;
	private var fxRot 													: EulerAngles;
	private var targets 												: array<CGameplayEntity>;
	private var dist, ang												: float;
	private var pos, targetPos											: Vector;
	private var targetRot 												: EulerAngles;
	private var i														: int;
	private var npc     												: CNewNPC;
	private var maxAdrenaline											: float;
	private var curAdrenaline											: float;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Passive_Weapon_Effects_Switch();
	}
	
	entry function Passive_Weapon_Effects_Switch()
	{
		Passive_Weapon_Effects_Switch_Activate();
	}

	latent function Passive_Weapon_Effects_Switch_Activate()
	{
		maxAdrenaline = GetWitcherPlayer().GetStatMax(BCS_Focus);
		
		curAdrenaline = GetWitcherPlayer().GetStat(BCS_Focus);

		targets.Clear();

		if (!thePlayer.IsPerformingFinisher())
		{
			if ( thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.HasBuff(EET_BlackBlood) )
					{
						dist = 2;
						ang = 90;
					}
					else	
					{
						dist = 1.25;
						ang = 60;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}
			}
			else
			{
				if ( 
				thePlayer.HasTag('igni_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	55;

					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						ang +=	315;
					}

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_secondary_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	55;

					if(  thePlayer.IsDoingSpecialAttack( false ) )
					{
						ang +=	315;
					}

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('axii_sword_equipped') )
				{
					dist = 1.6;
					ang =	55;	

					if (thePlayer.HasTag('ACS_Sparagmos_Active'))
					{
						dist += 10;
						ang +=	30;
					}
				}
				else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					if ( 
					ACS_GetWeaponMode() == 0
					|| ACS_GetWeaponMode() == 1
					|| ACS_GetWeaponMode() == 2
					)
					{
						dist = 2.25;
						ang =	55;
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{ 
						dist = 1.75;
						ang =	55;
					}
				}
				else if ( thePlayer.HasTag('aard_sword_equipped') )
				{
					dist = 2;
					ang =	75;	
				}
				else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					dist = 2;
					ang = 45;
				}
				else if ( thePlayer.HasTag('yrden_sword_equipped') )
				{
					if ( ACS_GetWeaponMode() == 0 )
					{
						if (ACS_GetArmigerModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 1 )
					{
						if (ACS_GetFocusModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 2 )
					{
						if (ACS_GetHybridModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						dist = 2.5;
						ang = 60;
					}
				}
				else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.HasTag('quen_sword_equipped') )
				{
					dist = 1.6;
					ang =	55;

					if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
					{
						ang +=	320;
					}
				}
				else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
					{
						dist = 10;
						ang =	30;
					}
					else
					{
						dist = 2.25;
						ang =	55;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}

				if (ACS_Armor_Equipped_Check())
				{
					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if( !thePlayer.IsDoingSpecialAttack( false )
						&& !thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1;
						}
					}
					else
					{
						dist += 1;
					}
				}
			}

			if ( thePlayer.GetTarget() == ACS_Big_Boi() )
			{
				dist += 0.75;
				ang += 15;
			}

			if (ACS_Player_Scale() > 1)
			{
				dist += ACS_Player_Scale() * 0.75;
			}
			else if (ACS_Player_Scale() < 1)
			{
				dist -= ACS_Player_Scale() * 0.5;
			}

			if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
			&& !thePlayer.HasTag('igni_sword_equipped') 
			&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
			&& !ACS_Armor_Equipped_Check())
			{
				dist += 1;
			}

			if (thePlayer.IsUsingHorse()) 
			{
				dist += 1.5;

				ang += 270;
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				dist += 1.5;

				ang += 315;
			}

			if (ACS_Bear_School_Check())
			{
				dist += 0.5;
				ang +=	15;

				if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Griffin_School_Check()
			&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
			{
				dist += 2;
				ang +=	15;
			}

			if (ACS_Manticore_School_Check())
			{
				dist += 0.5;

				if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Viper_School_Check())
			{
				if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					dist += 1.5;
				}
			}
		}
		else 
		{
			dist = 1;
			ang = 30;
		}

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999,,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw += RandRangeF(360,1);
			targetRot.Pitch += RandRangeF(360,1);
			targetRot.Roll += RandRangeF(360,1);

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			|| npc.HasTag('ACS_Plumard')
			|| npc.HasTag('ACS_Tentacle_1') 
			|| npc.HasTag('ACS_Tentacle_2') 
			|| npc.HasTag('ACS_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_1') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_2') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_4') 
			|| npc.HasTag('ACS_Svalblod_Bossbar') 
			|| npc.HasTag('ACS_Melusine_Bossbar') 
			|| npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
			)
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) && npc.IsAlive() )
				{
					if( ACS_OnHitEffects_Enabled() )
					{
						if ( ACS_GetWeaponMode() == 0 )
						{
							if ( !GetWitcherPlayer().IsWeaponHeld( 'fist' ) )
							{
								if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('critical_igni');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffectSingle('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffectSingle('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffectSingle('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
								else if (GetWitcherPlayer().GetEquippedSign() == ST_Quen)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffectSingle('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffectSingle('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffectSingle('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
								else if (GetWitcherPlayer().GetEquippedSign() == ST_Aard)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffectSingle('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffectSingle('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffectSingle('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
								else if (GetWitcherPlayer().GetEquippedSign() == ST_Axii)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('critical_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('critical_aard');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffectSingle('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffectSingle('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffectSingle('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
								else if (GetWitcherPlayer().GetEquippedSign() == ST_Yrden)
								{
									if ( GetWitcherPlayer().HasTag('yrden_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('critical_yrden');
										vfxEnt.DestroyAfter(1.5);
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
									|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
									)
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_explode.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('mutation_2_yrden');
										vfxEnt.DestroyAfter(1.5);
									}
									else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
									{
										if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
										{
											vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
											vfxEnt.PlayEffectSingle('blood_explode_red');
											vfxEnt.DestroyAfter(1.5);
										}
										else
										{
											npc.PlayEffectSingle('heavy_hit');
											npc.StopEffect('heavy_hit');

											npc.PlayEffectSingle('light_hit');
											npc.StopEffect('light_hit');
										}
									}
								}
							}
							else if ( GetWitcherPlayer().IsWeaponHeld( 'fist' ) && GetWitcherPlayer().HasTag('vampire_claws_equipped') )
							{
								if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
								{
									vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
									vfxEnt.PlayEffectSingle('hit_red');
									vfxEnt.PlayEffectSingle('hit_refraction_red');
									vfxEnt.PlayEffectSingle('crawl_blood_red');
									vfxEnt.DestroyAfter(1.5);
								}
								else
								{
									npc.PlayEffectSingle('blood');
									npc.StopEffect('blood');

									npc.PlayEffectSingle('death_blood');
									npc.StopEffect('death_blood');

									npc.PlayEffectSingle('heavy_hit');
									npc.StopEffect('heavy_hit');

									npc.PlayEffectSingle('light_hit');
									npc.StopEffect('light_hit');

									npc.PlayEffectSingle('blood_spill');
									npc.StopEffect('blood_spill');
								}

								/*
								vfxEnt3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
								vfxEnt3.PlayEffectSingle('blood_explode_red');
								vfxEnt3.DestroyAfter(1.5);
								*/

								if (GetWitcherPlayer().HasBuff(EET_BlackBlood))
								{
									targetPos.Z += RandRangeF( 0.5, -0.4 );
								
									targetPos.Y += RandRangeF( 0.4, -0.4 );
									
									targetRot.Roll = RandRange( 360, 0 );

									vfxEnt4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPos, targetRot );

									vfxEnt4.PlayEffectSingle('sword_slash_red_medium');

									vfxEnt4.DestroyAfter(1);
								}
							}	
						}
						else
						{
							if (GetWitcherPlayer().IsAnyWeaponHeld()
							&& !GetWitcherPlayer().IsWeaponHeld( 'fist' )
							)
							{
								if (
								npc.HasBuff(EET_Burning)
								|| npc.HasBuff(EET_Confusion)
								|| npc.HasBuff(EET_Stagger)
								|| npc.HasBuff(EET_Paralyzed)
								|| npc.HasBuff(EET_Slowdown)
								)
								{
									if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
									{
										aard_blade_trail();
									}
									else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
									{
										aard_secondary_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
									{
										yrden_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
									{
										yrden_secondary_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
									{
										axii_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
									{
										axii_secondary_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
									{
										//quen_sword_glow();
										quen_sword_trail();
									}
									else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
									{
										quen_secondary_sword_trail();
									}
								}

								if ( GetWitcherPlayer().GetEquippedSign() == ST_Igni )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if ( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Burning ) && !npc.HasBuff( EET_Burning ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if ( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Burning ) && !npc.HasBuff( EET_Burning ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}

												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if ( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Burning ) && !npc.HasBuff( EET_Burning ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}

												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
												vfxEnt.DestroyAfter(1.5);	
												npc.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( GetWitcherPlayer().GetEquippedSign() == ST_Axii )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if ( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Confusion ) && !npc.HasBuff( EET_Confusion ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Confusion ) && !npc.HasBuff( EET_Confusion ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Confusion ) && !npc.HasBuff( EET_Confusion ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( GetWitcherPlayer().GetEquippedSign() == ST_Aard )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Stagger ) && !npc.HasBuff( EET_Stagger ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_aard');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( GetWitcherPlayer().GetEquippedSign() == ST_Quen )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Paralyzed ) && !npc.HasBuff( EET_Paralyzed ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Paralyzed ) && !npc.HasBuff( EET_Paralyzed ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Paralyzed ) && !npc.HasBuff( EET_Paralyzed ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('mutation_1_hit_quen');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
								else if ( GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
								{
									if( curAdrenaline >= maxAdrenaline/3
									&& curAdrenaline < maxAdrenaline * 2/3)
									{
										if( RandF() < 0.0625 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline >= maxAdrenaline * 2/3
									&& curAdrenaline < maxAdrenaline)
									{
										if( RandF() < 0.125 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
									else if( curAdrenaline == maxAdrenaline ) 
									{
										if( RandF() < 0.25 ) 
										{
											if( !npc.IsImmuneToBuff( EET_Slowdown ) && !npc.HasBuff( EET_Slowdown ) ) 
											{ 
												if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
												{
													aard_blade_trail();
												}
												else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
												{
													aard_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
												{
													yrden_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
												{
													yrden_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
												{
													axii_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
												{
													axii_secondary_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
												{
													//quen_sword_glow();
													quen_sword_trail();
												}
												else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
												{
													quen_secondary_sword_trail();
												}
													
												vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_2\mutation_2_critical_force.w2ent", true ), targetPos, targetRot );
												vfxEnt.PlayEffectSingle('critical_yrden');
												vfxEnt.DestroyAfter(1.5);
												npc.AddEffectDefault( EET_Slowdown, GetWitcherPlayer(), 'acs_weapon_passive_effects' ); 							
											}
										}
									}
								}
							}
							else
							{
								if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') )
								{
									if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
									{
										vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
										vfxEnt.PlayEffectSingle('hit_red');
										vfxEnt.PlayEffectSingle('hit_refraction_red');
										vfxEnt.PlayEffectSingle('crawl_blood_red');
										vfxEnt.DestroyAfter(1.5);
									}
									else
									{
										npc.PlayEffectSingle('blood');
										npc.StopEffect('blood');

										npc.PlayEffectSingle('death_blood');
										npc.StopEffect('death_blood');

										npc.PlayEffectSingle('heavy_hit');
										npc.StopEffect('heavy_hit');

										npc.PlayEffectSingle('light_hit');
										npc.StopEffect('light_hit');

										npc.PlayEffectSingle('blood_spill');
										npc.StopEffect('blood_spill');
									}

									/*
									vfxEnt3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
									vfxEnt3.PlayEffectSingle('blood_explode_red');
									vfxEnt3.DestroyAfter(1.5);
									*/

									if (GetWitcherPlayer().HasBuff(EET_BlackBlood))
									{
										targetPos.Z += RandRangeF( 0.5, -0.4 );
									
										targetPos.Y += RandRangeF( 0.4, -0.4 );
										
										targetRot.Roll = RandRange( 360, 0 );

										vfxEnt4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPos, targetRot );

										vfxEnt4.PlayEffectSingle('sword_slash_red_medium');

										vfxEnt4.DestroyAfter(1);
									}
								}
							}
						}
					}
					else
					{
						if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') )
						{
							if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
							{
								vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
								vfxEnt.PlayEffectSingle('hit_red');
								vfxEnt.PlayEffectSingle('hit_refraction_red');
								vfxEnt.PlayEffectSingle('crawl_blood_red');
								vfxEnt.DestroyAfter(1.5);
							}
							else
							{
								npc.PlayEffectSingle('blood');
								npc.StopEffect('blood');

								npc.PlayEffectSingle('death_blood');
								npc.StopEffect('death_blood');

								npc.PlayEffectSingle('heavy_hit');
								npc.StopEffect('heavy_hit');

								npc.PlayEffectSingle('light_hit');
								npc.StopEffect('light_hit');

								npc.PlayEffectSingle('blood_spill');
								npc.StopEffect('blood_spill');
							}

							/*
							vfxEnt3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), targetPos, targetRot );
							vfxEnt3.PlayEffectSingle('blood_explode_red');
							vfxEnt3.DestroyAfter(1.5);
							*/

							if (GetWitcherPlayer().HasBuff(EET_BlackBlood))
							{
								targetPos.Z += RandRangeF( 0.5, -0.4 );
							
								targetPos.Y += RandRangeF( 0.4, -0.4 );
								
								targetRot.Roll = RandRange( 360, 0 );

								vfxEnt4 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPos, targetRot );

								vfxEnt4.PlayEffectSingle('sword_slash_red_medium');

								vfxEnt4.DestroyAfter(1);
							}
						}
					}
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Blood_Spatter_Switch
{
    function ACS_Blood_Spatter_Switch_Engage()
	{
		this.PushState('ACS_Blood_Spatter_Switch_Engage');
	}

	 function ACS_Blood_Spatter_Switch_Full_Engage()
	{
		this.PushState('ACS_Blood_Spatter_Switch_Full_Engage');
	}
}

state ACS_Blood_Spatter_Switch_Engage in cACS_Blood_Spatter_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt2, vfxEnt3, vfxEnt4			: CEntity;
	private var temp													: CEntityTemplate;
	private var targets 												: array<CGameplayEntity>;
	private var dist, ang												: float;
	private var pos, targetPos											: Vector;
	private var targetRot 												: EulerAngles;
	private var i														: int;
	private var npc     												: CNewNPC;
	private var tmpBool 												: bool;
	private var mc 														: EMonsterCategory;
	private var tmpName 												: name;
	private var eff_names												: array< name >;
	
	
	event OnEnterState(prevStateName : name)
	{
		Blood_Spatter_Switch_Entry();
	}
	
	entry function Blood_Spatter_Switch_Entry()
	{
		Blood_Spatter_Switch_Latent();
	}

	latent function Blood_Spatter_Switch_Latent()
	{
		if (!thePlayer.IsPerformingFinisher())
		{
			if ( thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.HasBuff(EET_BlackBlood) )
					{
						dist = 2;
						ang = 90;
					}
					else	
					{
						dist = 1.25;
						ang = 60;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}
			}
			else
			{
				if ( 
				thePlayer.HasTag('igni_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	55;

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
							ang +=	315;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_secondary_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	55;

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
							ang +=	315;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('axii_sword_equipped') )
				{
					dist = 1.6;
					ang =	55;	

					if (thePlayer.HasTag('ACS_Sparagmos_Active'))
					{
						dist += 10;
						ang +=	30;
					}
				}
				else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					if ( 
					ACS_GetWeaponMode() == 0
					|| ACS_GetWeaponMode() == 1
					|| ACS_GetWeaponMode() == 2
					)
					{
						dist = 2.25;
						ang =	55;
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{ 
						dist = 1.75;
						ang =	55;
					}
				}
				else if ( thePlayer.HasTag('aard_sword_equipped') )
				{
					dist = 2;
					ang =	75;	
				}
				else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					dist = 2;
					ang = 45;
				}
				else if ( thePlayer.HasTag('yrden_sword_equipped') )
				{
					if ( ACS_GetWeaponMode() == 0 )
					{
						if (ACS_GetArmigerModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 1 )
					{
						if (ACS_GetFocusModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 2 )
					{
						if (ACS_GetHybridModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						dist = 2.5;
						ang = 60;
					}
				}
				else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.HasTag('quen_sword_equipped') )
				{
					dist = 1.6;
					ang =	55;

					if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
					{
						ang +=	320;
					}
				}
				else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
					{
						dist = 10;
						ang =	30;
					}
					else
					{
						dist = 2.25;
						ang =	55;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}

				if (ACS_Armor_Equipped_Check())
				{
					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if( !thePlayer.IsDoingSpecialAttack( false )
						&& !thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1;
						}
					}
					else
					{
						dist += 1;
					}
				}
			}

			if ( thePlayer.GetTarget() == ACS_Big_Boi() )
			{
				dist += 0.75;
				ang += 15;
			}

			if (ACS_Player_Scale() > 1)
			{
				dist += ACS_Player_Scale() * 0.75;
			}
			else if (ACS_Player_Scale() < 1)
			{
				dist -= ACS_Player_Scale() * 0.5;
			}

			if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
			&& !thePlayer.HasTag('igni_sword_equipped') 
			&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
			&& !ACS_Armor_Equipped_Check())
			{
				dist += 1;
			}

			if (thePlayer.IsUsingHorse()) 
			{
				dist += 1.5;

				ang += 270;
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				dist += 1.5;

				ang += 315;
			}

			if (ACS_Bear_School_Check())
			{
				dist += 0.5;
				ang +=	15;

				if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Griffin_School_Check()
			&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
			{
				dist += 2;
				ang +=	15;
			}

			if (ACS_Manticore_School_Check())
			{
				dist += 0.5;

				if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Viper_School_Check())
			{
				if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					dist += 1.5;
				}
			}
		}
		else 
		{
			dist = 1;
			ang = 30;
		}

		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999,,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw += RandRangeF(360,1);
			targetRot.Pitch += RandRangeF(360,1);
			targetRot.Roll += RandRangeF( 360, 1 );

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			|| npc.HasTag('ACS_Plumard')
			|| npc.HasTag('ACS_Tentacle_1') 
			|| npc.HasTag('ACS_Tentacle_2') 
			|| npc.HasTag('ACS_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_1') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_2') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_4') 
			|| npc.HasTag('ACS_Svalblod_Bossbar') 
			|| npc.HasTag('ACS_Melusine_Bossbar') 
			|| npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
			)
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( (CActor)targets[i] ) 
				&& npc.IsAlive() 
				)
				{
					if ( ACS_Armor_Equipped_Check()
					&& GetWitcherPlayer().IsAnyWeaponHeld()
					&& !GetWitcherPlayer().IsWeaponHeld( 'fist' ))
					{
						//targetPos.Z += RandRangeF( 0.5, -0.4 );
						
						//targetPos.Y += RandRangeF( 0.4, -0.4 );

						vfxEnt4 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
							
						"dlc\dlc_acs\data\entities\lillith_magic\chaos_red_slashes.w2ent"
						
						, true ), targetPos, targetRot );

						eff_names.Clear();

						eff_names.PushBack('diagonal_up_right');
						eff_names.PushBack('diagonal_down_right');
						eff_names.PushBack('right');
						eff_names.PushBack('diagonal_up_left');
						eff_names.PushBack('diagonal_down_left');
						eff_names.PushBack('left');
						eff_names.PushBack('up');
						eff_names.PushBack('down');

						vfxEnt4.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

						vfxEnt4.DestroyAfter(1);

						if ((GetWitcherPlayer().HasTag('igni_sword_equipped')
						|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
						&& thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
						&& thePlayer.GetStat(BCS_Stamina) == thePlayer.GetStatMax(BCS_Stamina)
						)
						{
							vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\bob\data\fx\gameplay\mutation\mutation_1\mutation_1_hit.w2ent", true ), targetPos, targetRot );
							vfxEnt.PlayEffectSingle('mutation_1_hit_igni');
							vfxEnt.DestroyAfter(1.5);
						}	
					}

					//if( RandF() < 0.5)
					{
						temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true );

						vfxEnt = theGame.CreateEntity( temp, targetPos, targetRot );
						vfxEnt.DestroyAfter(1.5);

						theGame.GetMonsterParamsForActor(npc, mc, tmpName, tmpBool, tmpBool, tmpBool);

						if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
						{
							if (npc.HasAbility('mon_lessog_base')
							|| npc.HasAbility('mon_sprigan_base')
							)
							{						
								vfxEnt.PlayEffectSingle('blood_spatter_black');
							} 
							else
							{
								vfxEnt.PlayEffectSingle('blood_spatter_red');
							}
						}
						else if( ((CNewNPC)npc).GetBloodType() == BT_Green) 
						{
							if (npc.HasAbility('mon_kikimore_base')
							|| npc.HasAbility('mon_black_spider_base')
							|| npc.HasAbility('mon_black_spider_ep2_base')
							)
							{						
								vfxEnt.PlayEffectSingle('blood_spatter_black');
							} 
							else 
							{
								vfxEnt.PlayEffectSingle('blood_spatter_green');
							}
						}
						else if( ((CNewNPC)npc).GetBloodType() == BT_Yellow) 
						{
							if (npc.HasAbility('mon_archespor_base'))
							{
								vfxEnt.PlayEffectSingle('blood_spatter_yellow');
							} 
							else 
							{
								vfxEnt.PlayEffectSingle('blood_spatter_red');
							}
						}
						else if( ((CNewNPC)npc).GetBloodType() == BT_Black) 
						{
							if ( mc == MC_Vampire ) 
							{
								vfxEnt.PlayEffectSingle('blood_spatter_red');
							}
							else if ( mc == MC_Magicals ) 
							{
								if (npc.HasAbility('mon_golem_base')
								|| npc.HasAbility('mon_djinn')
								|| npc.HasAbility('mon_gargoyle')
								)
								{
									vfxEnt.PlayEffectSingle('blood_spatter_black');
								}
								else
								{
									vfxEnt.PlayEffectSingle('blood_spatter_red');
								}
							}
							else
							{
								vfxEnt.PlayEffectSingle('blood_spatter_black');
							}
						}
						else
						{
							vfxEnt.PlayEffectSingle('blood_spatter_red');
						}
					}
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Blood_Spatter_Switch_Full_Engage in cACS_Blood_Spatter_Switch
{
	private var weaponEntity, vfxEnt, vfxEnt2, vfxEnt3, vfxEnt4			: CEntity;
	private var temp													: CEntityTemplate;
	private var targets 												: array<CGameplayEntity>;
	private var dist, ang												: float;
	private var pos, targetPos											: Vector;
	private var targetRot 												: EulerAngles;
	private var i														: int;
	private var npc     												: CNewNPC;
	private var tmpBool 												: bool;
	private var mc 														: EMonsterCategory;
	private var tmpName 												: name;
	
	event OnEnterState(prevStateName : name)
	{
		Blood_Spatter_Switch_Full_Entry();
	}
	
	entry function Blood_Spatter_Switch_Full_Entry()
	{
		Blood_Spatter_Switch_Full_Latent();
	}

	latent function Blood_Spatter_Switch_Full_Latent()
	{
		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), 360, 2, 999,,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot = npc.GetWorldRotation();
			targetRot.Yaw += RandRangeF(360,1);
			targetRot.Pitch += RandRangeF(360,1);
			targetRot.Roll += RandRangeF(360,1);

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			|| npc.HasTag('ACS_Plumard')
			|| npc.HasTag('ACS_Tentacle_1') 
			|| npc.HasTag('ACS_Tentacle_2') 
			|| npc.HasTag('ACS_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_1') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_2') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_4') 
			|| npc.HasTag('ACS_Svalblod_Bossbar') 
			|| npc.HasTag('ACS_Melusine_Bossbar') 
			|| npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
			)
				continue;

			if( targets.Size() > 0 )			
			{
				temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true );

				vfxEnt = theGame.CreateEntity( temp, targetPos, targetRot );
				vfxEnt.DestroyAfter(1.5);

				theGame.GetMonsterParamsForActor(npc, mc, tmpName, tmpBool, tmpBool, tmpBool);

				if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
				{
					if (npc.HasAbility('mon_lessog_base')
					|| npc.HasAbility('mon_sprigan_base')
					)
					{						
						vfxEnt.PlayEffectSingle('blood_spatter_black');
					} 
					else
					{
						vfxEnt.PlayEffectSingle('blood_spatter_red');
					}
				}
				else if( ((CNewNPC)npc).GetBloodType() == BT_Green) 
				{
					if (npc.HasAbility('mon_kikimore_base')
					|| npc.HasAbility('mon_black_spider_base')
					|| npc.HasAbility('mon_black_spider_ep2_base')
					)
					{						
						vfxEnt.PlayEffectSingle('blood_spatter_black');
					} 
					else 
					{
						vfxEnt.PlayEffectSingle('blood_spatter_green');
					}
				}
				else if( ((CNewNPC)npc).GetBloodType() == BT_Yellow) 
				{
					if (npc.HasAbility('mon_archespor_base'))
					{
						vfxEnt.PlayEffectSingle('blood_spatter_yellow');
					} 
					else 
					{
						vfxEnt.PlayEffectSingle('blood_spatter_red');
					}
				}
				else if( ((CNewNPC)npc).GetBloodType() == BT_Black) 
				{
					if ( mc == MC_Vampire ) 
					{
						vfxEnt.PlayEffectSingle('blood_spatter_red');
					}
					else if ( mc == MC_Magicals ) 
					{
						if (npc.HasAbility('mon_golem_base')
						|| npc.HasAbility('mon_djinn')
						|| npc.HasAbility('mon_gargoyle')
						)
						{
							vfxEnt.PlayEffectSingle('blood_spatter_black');
						}
						else
						{
							vfxEnt.PlayEffectSingle('blood_spatter_red');
						}
					}
					else
					{
						vfxEnt.PlayEffectSingle('blood_spatter_black');
					}
				}
				else
				{
					vfxEnt.PlayEffectSingle('blood_spatter_red');
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_Caretaker_Drain_Energy()
{
	var vACS_Caretaker_Drain_Energy : cACS_Caretaker_Drain_Energy;
	vACS_Caretaker_Drain_Energy = new cACS_Caretaker_Drain_Energy in theGame;
			
	vACS_Caretaker_Drain_Energy.ACS_Caretaker_Drain_Energy_Engage();
}

statemachine class cACS_Caretaker_Drain_Energy
{
    function ACS_Caretaker_Drain_Energy_Engage()
	{
		this.PushState('ACS_Caretaker_Drain_Energy_Engage');
	}
}

state ACS_Caretaker_Drain_Energy_Engage in cACS_Caretaker_Drain_Energy
{
	private var targets 						: array<CGameplayEntity>;
	private var dist, ang						: float;
	private var pos, targetPos					: Vector;
	private var targetRot 						: EulerAngles;
	private var i								: int;
	private var npc     						: CNewNPC;
	private var anchor							: CEntity;
	private var anchorTemplate					: CEntityTemplate;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Caretaker_Drain_Energy_Entry();
	}
	
	entry function ACS_Caretaker_Drain_Energy_Entry()
	{
		ACS_Caretaker_Drain_Energy_Latent();
	}

	latent function ACS_Caretaker_Drain_Energy_Latent()
	{
		if ( !GetWitcherPlayer().IsWeaponHeld( 'fist' ) && GetWitcherPlayer().HasTag('yrden_sword_equipped') )
		{
			if ( ACS_GetWeaponMode() == 0 )
			{
				if (ACS_GetArmigerModeWeaponType() == 0)
				{
					dist = 2.5;
					ang = 60;
				}
				else 
				{
					dist = 2;
					ang = 30;
				}
			}
			else if ( ACS_GetWeaponMode() == 1 )
			{
				if (ACS_GetFocusModeWeaponType() == 0)
				{
					dist = 2.5;
					ang = 60;
				}
				else 
				{
					dist = 2;
					ang = 30;
				}
			}
			else if ( ACS_GetWeaponMode() == 2 )
			{
				if (ACS_GetHybridModeWeaponType() == 0)
				{
					dist = 2.5;
					ang = 60;
				}
				else 
				{
					dist = 2;
					ang = 30;
				}
			}
			else if ( ACS_GetWeaponMode() == 3 )
			{
				dist = 2.5;
				ang = 60;
			}	
		}

		if (ACS_Player_Scale() > 1)
		{
			dist += ACS_Player_Scale() * 0.5;
		}
		else if (ACS_Player_Scale() < 1)
		{
			dist -= ACS_Player_Scale() * 0.5;
		}

		if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
		&& !thePlayer.HasTag('igni_sword_equipped') 
		&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
		&& !ACS_Armor_Equipped_Check())
		{
			dist += 1;
		}

		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999,,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();

			targetRot = npc.GetWorldRotation();

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			|| npc.HasTag('ACS_Plumard')
			|| npc.HasTag('ACS_Tentacle_1') 
			|| npc.HasTag('ACS_Tentacle_2') 
			|| npc.HasTag('ACS_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_1') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_2') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_4') 
			|| npc.HasTag('ACS_Svalblod_Bossbar') 
			|| npc.HasTag('ACS_Melusine_Bossbar') 
			|| npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
			)
				continue;

			if( targets.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
				{
					if (ACS_GetItem_Caretaker_Shovel())
					{
						anchorTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );		
						anchor = (CEntity)theGame.CreateEntity( anchorTemplate, targetPos, targetRot );

						anchor.CreateAttachment( npc, 'head', Vector( 0, 0, -0.5 ) );

						GetWitcherPlayer().PlayEffectSingle('drain_energy', anchor);
						GetWitcherPlayer().StopEffect('drain_energy');

						yrden_sword_effect_small();

						anchor.DestroyAfter(3);
					}
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Drain_Energy
{
    function ACS_Drain_Energy_Engage()
	{
		this.PushState('ACS_Drain_Energy_Engage');
	}
}

state ACS_Drain_Energy_Engage in cACS_Drain_Energy
{
	private var actors 							: array<CActor>;
	private var dist, ang						: float;
	private var pos, targetPos					: Vector;
	private var targetRot 						: EulerAngles;
	private var i								: int;
	private var npc     						: CNewNPC;
	private var anchor							: CEntity;
	private var anchorTemplate					: CEntityTemplate;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Drain_Energy_Entry();
	}
	
	entry function ACS_Drain_Energy_Entry()
	{
		ACS_Drain_Energy_Latent();
	}

	latent function ACS_Drain_Energy_Latent()
	{
		if( GetWitcherPlayer().GetStat(BCS_Focus) >= GetWitcherPlayer().GetStatMax(BCS_Focus)/3
			&& GetWitcherPlayer().GetStat(BCS_Focus) < GetWitcherPlayer().GetStatMax(BCS_Focus) * 2/3)
		{
			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 1.5, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		}	
		else if( GetWitcherPlayer().GetStat(BCS_Focus) >= GetWitcherPlayer().GetStatMax(BCS_Focus) * 2/3
		&& GetWitcherPlayer().GetStat(BCS_Focus) < GetWitcherPlayer().GetStatMax(BCS_Focus))
		{
			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		}
		else if( GetWitcherPlayer().GetStat(BCS_Focus) == GetWitcherPlayer().GetStatMax(BCS_Focus))
		{
			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		}

		pos = GetWitcherPlayer().GetWorldPosition();

		pos.Z += 0.8;

		actors.Clear();

		for( i = actors.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)actors[i];

			targetPos = npc.GetWorldPosition();

			targetRot = npc.GetWorldRotation();

			if 
			( 
			npc == GetWitcherPlayer() 
			|| npc.HasTag('smokeman') 
			|| npc.IsHorse() 
			|| npc.HasTag('ACS_Rat_Mage_Rat')
			|| npc.HasTag('ACS_Plumard')
			|| npc.HasTag('ACS_Tentacle_1') 
			|| npc.HasTag('ACS_Tentacle_2') 
			|| npc.HasTag('ACS_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_1') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_2') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_3') 
			|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
			|| npc.HasTag('ACS_Necrofiend_Tentacle_4') 
			|| npc.HasTag('ACS_Svalblod_Bossbar') 
			|| npc.HasTag('ACS_Melusine_Bossbar') 
			|| npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
			)
				continue;

			if( actors.Size() > 0 )
			{				
				if( ACS_AttitudeCheck ( npc ) && npc.IsAlive() )
				{
					anchorTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );		
					anchor = (CEntity)theGame.CreateEntity( anchorTemplate, targetPos, targetRot );

					anchor.CreateAttachment( npc, , Vector( 0, 0, 0.5 ) );

					GetWitcherPlayer().PlayEffectSingle('drain_energy', anchor);
					GetWitcherPlayer().StopEffect('drain_energy');

					anchor.DestroyAfter(3);
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Marker_Switch
{
    function ACS_Marker_Switch_Engage()
	{
		this.PushState('ACS_Marker_Switch_Engage');
	}
}

state ACS_Marker_Switch_Engage in cACS_Marker_Switch
{
	private var markerNPC_1, markerNPC_2, markerNPC_3, markerNPC_4, markerNPC_5, markerNPC_6, markerNPC_7, markerNPC_8, markerNPC_9, markerNPC_10, markerNPC_11, markerNPC_12		: CEntity;
	private var markerTemplate 																		: CEntityTemplate;
	private var targets 																			: array<CGameplayEntity>;
	private var dist, ang																			: float;
	private var pos, targetPos, npcPos, attach_vec													: Vector;
	private var targetRot_1, attach_rot																: EulerAngles;
	private var i																					: int;
	private var npc     																			: CNewNPC;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Passive_Weapon_Effects_Switch();
	}
	
	entry function Passive_Weapon_Effects_Switch()
	{
		GetACSWatcher().Remove_On_Hit_Tags();
		Passive_Weapon_Effects_Switch_Activate();
	}

	latent function Passive_Weapon_Effects_Switch_Activate()
	{
		if (!thePlayer.IsPerformingFinisher())
		{
			if ( thePlayer.IsWeaponHeld( 'fist' ) )
			{
				if ( thePlayer.HasTag('vampire_claws_equipped') )
				{
					if ( thePlayer.HasBuff(EET_BlackBlood) )
					{
						dist = 2;
						ang = 90;
					}
					else	
					{
						dist = 1.25;
						ang = 60;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}
			}
			else
			{
				if ( 
				thePlayer.HasTag('igni_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	55;

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
							ang +=	315;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('igni_secondary_sword_equipped_TAG') 
				|| thePlayer.HasTag('igni_secondary_sword_equipped') 
				)
				{
					dist = 1.5;
					ang =	55;

					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if(  thePlayer.IsDoingSpecialAttack( false ) )
						{
							dist += 1.1;
							ang +=	315;
						}
						else if(  thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1.9;
						}
					}
				}
				else if ( thePlayer.HasTag('axii_sword_equipped') )
				{
					dist = 1.6;
					ang =	55;	

					if (thePlayer.HasTag('ACS_Sparagmos_Active'))
					{
						dist += 10;
						ang +=	30;
					}
				}
				else if ( thePlayer.HasTag('axii_secondary_sword_equipped') )
				{
					if ( 
					ACS_GetWeaponMode() == 0
					|| ACS_GetWeaponMode() == 1
					|| ACS_GetWeaponMode() == 2
					)
					{
						dist = 2.25;
						ang =	55;
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{ 
						dist = 1.75;
						ang =	55;
					}
				}
				else if ( thePlayer.HasTag('aard_sword_equipped') )
				{
					dist = 2;
					ang =	75;	
				}
				else if ( thePlayer.HasTag('aard_secondary_sword_equipped') )
				{
					dist = 2;
					ang = 45;
				}
				else if ( thePlayer.HasTag('yrden_sword_equipped') )
				{
					if ( ACS_GetWeaponMode() == 0 )
					{
						if (ACS_GetArmigerModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 1 )
					{
						if (ACS_GetFocusModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 2 )
					{
						if (ACS_GetHybridModeWeaponType() == 0)
						{
							dist = 2.5;
							ang = 60;
						}
						else 
						{
							dist = 2;
							ang = 30;
						}
					}
					else if ( ACS_GetWeaponMode() == 3 )
					{
						dist = 2.5;
						ang = 60;
					}
				}
				else if ( thePlayer.HasTag('yrden_secondary_sword_equipped') )
				{
					dist = 3.5;
					ang =	180;
				}
				else if ( thePlayer.HasTag('quen_sword_equipped') )
				{
					dist = 1.6;
					ang =	55;

					if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
					{
						ang +=	320;
					}
				}
				else if ( thePlayer.HasTag('quen_secondary_sword_equipped') )
				{
					if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
					{
						dist = 10;
						ang =	30;
					}
					else
					{
						dist = 2.25;
						ang =	55;
					}
				}
				else 
				{
					dist = 1.25;
					ang = 30;
				}

				if (ACS_Armor_Equipped_Check())
				{
					if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
					{
						if( !thePlayer.IsDoingSpecialAttack( false )
						&& !thePlayer.IsDoingSpecialAttack( true ) )
						{
							dist += 1;
						}
					}
					else
					{
						dist += 1;
					}
				}
			}

			if ( thePlayer.GetTarget() == ACS_Big_Boi() )
			{
				dist += 0.75;
				ang += 15;
			}

			if (ACS_Player_Scale() > 1)
			{
				dist += ACS_Player_Scale() * 0.75;
			}
			else if (ACS_Player_Scale() < 1)
			{
				dist -= ACS_Player_Scale() * 0.5;
			}

			if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
			&& !thePlayer.HasTag('igni_sword_equipped') 
			&& !thePlayer.HasTag('igni_secondary_sword_equipped') 
			&& !ACS_Armor_Equipped_Check())
			{
				dist += 1;
			}

			if (thePlayer.IsUsingHorse()) 
			{
				dist += 1.5;

				ang += 270;
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				dist += 1.5;

				ang += 315;
			}

			if (ACS_Bear_School_Check())
			{
				dist += 0.5;
				ang +=	15;

				if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Griffin_School_Check()
			&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
			{
				dist += 2;
				ang +=	15;
			}

			if (ACS_Manticore_School_Check())
			{
				dist += 0.5;

				if (thePlayer.HasTag('ACS_Manticore_Special_Attack'))
				{
					dist += 1.5;
				}
			}

			if (ACS_Viper_School_Check())
			{
				if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
				{
					dist += 1.5;
				}
			}
		}
		else 
		{
			dist = 1;
			ang = 30;
		}

		targets.Clear();

		FindGameplayEntitiesInCone( targets, GetWitcherPlayer().GetWorldPosition(), VecHeading( GetWitcherPlayer().GetWorldForward() ), ang, dist, 999,,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		pos = GetWitcherPlayer().GetWorldPosition();
		pos.Z += 0.8;
		for( i = targets.Size()-1; i >= 0; i -= 1 ) 
		{	
			npc = (CNewNPC)targets[i];

			targetPos = npc.GetWorldPosition();
			targetPos.Z += 1.5;

			targetRot_1 = npc.GetWorldRotation();
				
			if( targets.Size() > 0 )
			{				
				if( 
				ACS_AttitudeCheck ( (CActor)targets[i] ) 
				&& npc != GetWitcherPlayer() 
				&& GetACSWatcher().ACS_Rage_Process == false
				&& !npc.HasTag('smokeman') 
				&& !npc.HasTag('ACS_Tentacle_1') 
				&& !npc.HasTag('ACS_Tentacle_2') 
				&& !npc.HasTag('ACS_Tentacle_3') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_1') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_2') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_3') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_6')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_5')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_4')
				&& !npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				&& !npc.HasTag('acs_snow_entity') 
				&& !npc.HasTag('ACS_Rat_Mage_Rat') 
				&& !npc.HasTag('ACS_Plumard')
				&& !npc.HasTag('ACS_Svalblod_Bossbar') 
				&& !npc.HasTag('ACS_Melusine_Bossbar') 
				&& npc.IsAlive()
				)
				{
					ACS_ElementalComboSystem_Tutorial();

					if ( GetWitcherPlayer().HasTag('aard_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_hand_blood');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_figure');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('yrden_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_gate');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_goat_ring');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_hand_snake');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_hand_winged');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('quen_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_hand_knife');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_goat');

						markerNPC_1.AddTag('PrimerMark');
					}
					else if ( GetWitcherPlayer().HasTag('igni_sword_equipped_TAG') )
					{
						markerTemplate = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\vampire_decal.w2ent", true );
		
						markerNPC_1 = (CEntity)theGame.CreateEntity( markerTemplate, targetPos, targetRot_1 );

						attach_rot.Roll = 0;
						attach_rot.Pitch = 0;
						attach_rot.Yaw = 0;

						attach_vec.X = 0;
						attach_vec.Y = 0;

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							attach_vec.Z = 4.25;
						}
						else
						{
							attach_vec.Z = 2.75;
						}

						markerNPC_1.CreateAttachment( npc, , attach_vec, attach_rot );

						markerNPC_1.PlayEffectSingle('glow');

						markerNPC_1.PlayEffectSingle('rune_black_circle');

						markerNPC_1.AddTag('PrimerMark');
					}
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Sword_Array()
{
	var vACS_Sword_Array : cACS_Sword_Array;
	vACS_Sword_Array = new cACS_Sword_Array in theGame;
			
	vACS_Sword_Array.Switch();
}

function ACS_Sword_Array_Fire_Override()
{
	var vACS_Sword_Array : cACS_Sword_Array;
	vACS_Sword_Array = new cACS_Sword_Array in theGame;
			
	vACS_Sword_Array.Swords_Fire_Override();
}

function ACS_Sword_Array_Destroy()
{
	var sword_torso_anchor_1, static_torso_sword_1, static_torso_sword_2, static_torso_sword_3, static_torso_sword_4, static_torso_sword_5 : CEntity;	
	var i													: int;
	
	sword_torso_anchor_1 = (CEntity)theGame.GetEntityByTag( 'sword_torso_anchor_1' );
	//sword_torso_anchor_1.BreakAttachment();
	sword_torso_anchor_1.Destroy();
				
	static_torso_sword_1 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_1' );
	//static_torso_sword_1.BreakAttachment();
	static_torso_sword_1.StopEffect('glow');
	static_torso_sword_1.PlayEffectSingle('disappear');
	static_torso_sword_1.DestroyAfter(0.4);

	static_torso_sword_2 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_2' );
	//static_torso_sword_2.BreakAttachment();
	static_torso_sword_2.StopEffect('glow');
	static_torso_sword_2.PlayEffectSingle('disappear');
	static_torso_sword_2.DestroyAfter(0.4);

	static_torso_sword_3 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_3' );
	//static_torso_sword_3.BreakAttachment();
	static_torso_sword_3.StopEffect('glow');
	static_torso_sword_3.PlayEffectSingle('disappear');
	static_torso_sword_3.DestroyAfter(0.4);

	static_torso_sword_4 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_4' );
	//static_torso_sword_4.BreakAttachment();
	static_torso_sword_4.StopEffect('glow');
	static_torso_sword_4.PlayEffectSingle('disappear');
	static_torso_sword_4.DestroyAfter(0.4);

	static_torso_sword_5 = (CEntity)theGame.GetEntityByTag( 'static_torso_sword_5' );
	//static_torso_sword_5.BreakAttachment();
	static_torso_sword_5.StopEffect('glow');
	static_torso_sword_5.PlayEffectSingle('disappear');
	static_torso_sword_5.DestroyAfter(0.4);
}

statemachine class cACS_Sword_Array
{
    function Switch()
	{
		if ( !GetWitcherPlayer().HasTag('Swords_Ready') 
		&& (GetWitcherPlayer().GetStat(BCS_Focus) == GetWitcherPlayer().GetStatMax(BCS_Focus) ) )
		{
			this.PushState('Ready');

			GetWitcherPlayer().AddTag('Swords_Ready');
		}
		else if ( GetWitcherPlayer().HasTag('Swords_Ready') )
		{
			this.PushState('Fire');

			GetWitcherPlayer().RemoveTag('Swords_Ready');
		}
	}

	function Swords_Fire_Override()
	{
		if ( GetWitcherPlayer().HasTag('Swords_Ready') )
		{
			this.PushState('Fire');

			GetWitcherPlayer().RemoveTag('Swords_Ready');
		}
	}
}

state Ready in cACS_Sword_Array
{
	private var anchor_temp, sword_temp																													: CEntityTemplate;
	private var bonePosition, attach_vec																												: Vector;
	private var boneRotation, attach_rot																												: EulerAngles;
	private var sword_torso_anchor_1, static_torso_sword_1, static_torso_sword_2, static_torso_sword_3, static_torso_sword_4, static_torso_sword_5 		: CEntity;	
	private var movementAdjustor																														: CMovementAdjustor;
	private var ticket 																																	: SMovementAdjustmentRequestTicket;
	private var actor																																	: CActor;
	private var action 																																	: W3DamageAction;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Ready_Swords();
	}
	
	entry function Ready_Swords()
	{
		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );

		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'summon_swords');
		
		movementAdjustor.CancelByName( 'summon_swords' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'summon_swords' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		GetACSWatcher().RemoveTimer('ACS_Shout');

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
			{	
				movementAdjustor.RotateTowards( ticket, actor );
			}
			else
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			}

			GetACSWatcher().PlayerPlayAnimationInterrupt( '' );
		}

		ACS_Sword_Array_Destroy();
		Swords();
	}
	
	latent function Swords()
	{	
		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );
		
		sword_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\aerondight_proj_static.w2ent", true );

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'Trajectory' ), bonePosition, boneRotation );
		sword_torso_anchor_1 = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		sword_torso_anchor_1.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'Trajectory', bonePosition, boneRotation );
		sword_torso_anchor_1.AddTag('sword_torso_anchor_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		static_torso_sword_1 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_2 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_3 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_4 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );
		static_torso_sword_5 = (CEntity)theGame.CreateEntity( sword_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// + down/ - up
		attach_rot.Roll = 0;

		attach_rot.Pitch = -110;
		
		// + left/ - right
		attach_rot.Yaw = 0;
		
		attach_vec.X = 0;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+up/-down
		attach_vec.Z = 3;
				
		static_torso_sword_1.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );

		GetWitcherPlayer().PlayEffectSingle('hit_lightning');
		GetWitcherPlayer().StopEffect('hit_lightning');

		static_torso_sword_1.PlayEffectSingle('glow');
		static_torso_sword_1.AddTag('static_torso_sword_1');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		attach_rot.Roll = 100;
		attach_rot.Pitch = 0;
		
		attach_rot.Yaw = 110;
		
		//+Up/-Down
		attach_vec.X = 1;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+Left/-Right
		attach_vec.Z = 2;
				
		static_torso_sword_2.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );
		static_torso_sword_2.PlayEffectSingle('glow');
		static_torso_sword_2.AddTag('static_torso_sword_2');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		attach_rot.Roll = 100;
		attach_rot.Pitch = 0;
		
		attach_rot.Yaw = 70;
		
		//+Up/-Down
		attach_vec.X = -1;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+Left/-Right
		attach_vec.Z = 2;
				
		static_torso_sword_3.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );
		static_torso_sword_3.PlayEffectSingle('glow');
		static_torso_sword_3.AddTag('static_torso_sword_3');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		attach_rot.Roll = 80;
		attach_rot.Pitch = 0;
		
		attach_rot.Yaw = 110;
		
		//+Up/-Down
		attach_vec.X = 1;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+Left/-Right
		attach_vec.Z = 1;
				
		static_torso_sword_4.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );
		static_torso_sword_4.PlayEffectSingle('glow');
		static_torso_sword_4.AddTag('static_torso_sword_4');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		attach_rot.Roll = 80;
		attach_rot.Pitch = 0;
		
		attach_rot.Yaw = 70;
		
		//+Up/-Down
		attach_vec.X = -1;
		
		//-Forward/+Backward
		attach_vec.Y = -0.5;
		
		//+Left/-Right
		attach_vec.Z = 1;
				
		static_torso_sword_5.CreateAttachment( sword_torso_anchor_1, , attach_vec, attach_rot );
		static_torso_sword_5.PlayEffectSingle('glow');
		static_torso_sword_5.AddTag('static_torso_sword_5');
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Fire in cACS_Sword_Array
{
	private var initpos					: Vector;
	private var sword 					: SwordProjectile;
	private var actor, pActor       	: CActor;
	private var targetPosition			: Vector;
	private var meshcomp 				: CComponent;
	private var h 						: float;
	private var movementAdjustor		: CMovementAdjustor;
	private var ticket 					: SMovementAdjustmentRequestTicket;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Swords_Fire();
	}
	
	entry function Swords_Fire()
	{
		GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStat( BCS_Focus ) * 2/3 );

		GetACSWatcher().RemoveTimer('ACS_Shout');

		actor = (CActor)( GetWitcherPlayer().GetDisplayTarget() );

		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();
		
		ticket = movementAdjustor.GetRequest( 'summon_swords');
		
		movementAdjustor.CancelByName( 'summon_swords' );
		
		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'summon_swords' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		
		movementAdjustor.MaxLocationAdjustmentDistance( ticket, true, 0 );
		
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

		if (!theGame.IsDialogOrCutscenePlaying() 
		&& !GetWitcherPlayer().IsInNonGameplayCutscene() 
		&& !GetWitcherPlayer().IsInGameplayScene()
		&& !GetWitcherPlayer().IsUsingHorse()
		&& !GetWitcherPlayer().IsUsingVehicle()
		)
		{
			if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
			{	
				movementAdjustor.RotateTowards( ticket, actor );
			}
			else
			{
				movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
			}

			GetACSWatcher().PlayerPlayAnimationInterrupt( '' );
		}

		ACS_Sword_Array_Destroy();
		Projectile_1();
		Projectile_2();
		Projectile_3();
		Projectile_4();
		Projectile_5();
	}
	
	latent function Projectile_1()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition();				
			initpos.Z += 3;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition();				
			initpos.Z += 3;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_2()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5;				
			initpos.Z += 2;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5;				
			initpos.Z += 2;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_3()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5;				
			initpos.Z += 2;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5;				
			initpos.Z += 2;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_4()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5;				
			initpos.Z += 1;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * 1.5;				
			initpos.Z += 1;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}

	latent function Projectile_5()
	{	
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5;				
			initpos.Z += 1;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldRight() * -1.5;				
			initpos.Z += 1;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_1.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 1;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500 );
			sword.DestroyAfter(31);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Bats_Summon()
{
	var vACS_Bats_Summon : cACS_Bats_Summon;
	vACS_Bats_Summon = new cACS_Bats_Summon in theGame;
				
	vACS_Bats_Summon.ACS_Bats_Summon_Engage();
}

function ACS_Bat_Damage()
{
	var actortarget																										: CActor;
	var actors    																										: array<CActor>;
	var damage																											: float;
	var i																												: int;
	var dmg 																											: W3DamageAction;
	var targetVitality, targetEssence 																					: EBaseCharacterStats;

	//actors = GetActorsInRange(GetWitcherPlayer(), 7, 100, ,true);

	actors.Clear();

	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 7, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

	//GetWitcherPlayer().DrainStamina( ESAT_FixedValue, 0.046875 );

	//GetWitcherPlayer().DrainStamina( ESAT_FixedValue, 0.0625 );

	GetWitcherPlayer().DrainStamina( ESAT_FixedValue, 0.5 );

	for( i = 0; i < actors.Size(); i += 1 )
	{
		actortarget = (CActor)actors[i];

		if (actortarget.UsesEssence())
		{
			if ( actortarget.GetStat( BCS_Essence ) <= actortarget.GetStatMax( BCS_Essence ) * 0.05 )
			{
				damage = 99999;
			}
			else
			{
				damage = actortarget.GetStat( BCS_Essence ) * 0.000625;
			}
		}
		else if (actortarget.UsesVitality())
		{
			if ( actortarget.GetStat( BCS_Vitality ) <= actortarget.GetStatMax( BCS_Vitality ) * 0.05 )
			{
				damage = 99999;
			}
			else
			{
				damage = actortarget.GetStat( BCS_Vitality ) * 0.000625;
			}
		}

		if 
		( 
		actortarget == GetWitcherPlayer() 
		|| actortarget.HasTag('smokeman') 
		|| ((CNewNPC)(actortarget)).IsHorse() 
		|| actortarget.HasTag('ACS_Rat_Mage_Rat')
		|| actortarget.HasTag('ACS_Plumard')
		|| actortarget.HasTag('ACS_Tentacle_1') 
		|| actortarget.HasTag('ACS_Tentacle_2') 
		|| actortarget.HasTag('ACS_Tentacle_3') 
		|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
		|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
		|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
		|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
		|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
		|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4') 
		)
		continue;
			
		dmg = new W3DamageAction in theGame.damageMgr;
		dmg.Initialize(NULL, actortarget, theGame, 'ACS_Bats_Damage', EHRT_None, CPS_Undefined, false, false, true, false);
		dmg.SetProcessBuffsIfNoDamage(true);
		dmg.SetCanPlayHitParticle(false);
		dmg.SetSuppressHitSounds(true);

		dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damage );
					
		//dmg.AddEffectInfo( EET_Bleeding, 10 );
			
		theGame.damageMgr.ProcessAction( dmg );
								
		delete dmg;	
	}
}

statemachine class cACS_Bats_Summon
{
	function ACS_Bats_Summon_Engage()
	{
		this.PushState('ACS_Bats_Summon_Engage');
	}
}

state ACS_Bats_Summon_Engage in cACS_Bats_Summon
{
	private var playerRot, adjustedRot																							: EulerAngles;
	private var markerNPC																										: CEntity;
	private var playerPos, spawnPos																								: Vector;
	private var i, markerCount																									: int;
	private var randRange, randAngle, dist																						: float;
	private var actortarget																										: CActor;
	private var actors    																										: array<CActor>;
	private var movementAdjustor																								: CMovementAdjustor;
	private var ticket																											: SMovementAdjustmentRequestTicket;
	private var bat_template_names																								: array< string >;

	event OnEnterState(prevStateName : name)
	{
		ACS_Bats_Summon_Entry();
	}
		
	entry function ACS_Bats_Summon_Entry()
	{
		ACS_Bats_Summon_Latent();
		
		BlindOrBleed();
	}

	latent function BlindOrBleed()
	{
		//actors = GetActorsInRange(GetWitcherPlayer(), 10, 100, ,true);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 7, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			if 
			( 
			actortarget == GetWitcherPlayer() 
			|| actortarget.HasTag('ACS_Transformation_Vampire_Monster') 
			|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
			|| ((CNewNPC)(actortarget)).IsHorse() 
			|| actortarget.HasTag('ACS_Rat_Mage_Rat')
			|| actortarget.HasTag('ACS_Plumard')
			|| actortarget.HasTag('ACS_Tentacle_1') 
			|| actortarget.HasTag('ACS_Tentacle_2') 
			|| actortarget.HasTag('ACS_Tentacle_3') 
			|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
			|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
			|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
			|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
			|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
			|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4') 
			)
			continue;

			if (FactsQuerySum("acs_transformation_activated") <= 0)
			{
				dist = (((CMovingPhysicalAgentComponent)actortarget.GetMovingAgentComponent()).GetCapsuleRadius() 
				+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) * 1.75;

				movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();
				movementAdjustor.CancelByName( 'ACS_AardPull' );
				ticket = movementAdjustor.CreateNewRequest( 'ACS_AardPull' );
				movementAdjustor.AdjustmentDuration( ticket, 1 );
				movementAdjustor.ShouldStartAt(ticket, actortarget.GetWorldPosition());
				movementAdjustor.AdjustLocationVertically( ticket, true );
				movementAdjustor.ScaleAnimationLocationVertically( ticket, true );
				movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 5 );

				movementAdjustor.SlideTowards( ticket, GetWitcherPlayer(), dist, dist );	
			}

			if ( RandF() < 0.75 )
			{
				if( RandF() < 0.025 ) 
				{
					if( actortarget.HasBuff( EET_Bleeding ) ) 
					{ 	
						actortarget.RemoveBuff( EET_Bleeding, true, 'acs_bat_effect' ); 						
					}

					if( !actortarget.IsImmuneToBuff( EET_Blindness ) && !actortarget.HasBuff( EET_Blindness ) ) 
					{ 	
						actortarget.AddEffectDefault( EET_Blindness, GetWitcherPlayer(), 'acs_bat_effect' ); 						
					}
				}
				else
				{
					if( actortarget.HasBuff( EET_Blindness ) ) 
					{ 	
						actortarget.RemoveBuff( EET_Blindness, true, 'acs_bat_effect' ); 						
					}

					if( !actortarget.IsImmuneToBuff( EET_Bleeding ) && !actortarget.HasBuff( EET_Bleeding ) ) 
					{ 	
						actortarget.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_bat_effect' ); 						
					}
				}
			}
		}
	}
		
	latent function ACS_Bats_Summon_Latent()
	{
		playerPos = GetWitcherPlayer().GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;
	
		markerCount = 3;

		for( i = 0; i < markerCount; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			spawnPos.Z -= 1;

			adjustedRot.Yaw = RandRangeF(360,1);
			adjustedRot.Pitch = RandRangeF(45,-45);
			adjustedRot.Roll = RandRangeF(45,-45);

			bat_template_names.Clear();

			bat_template_names.PushBack("dlc\dlc_acs\data\fx\bat_swarm\bat_swarm_01.w2ent");
			bat_template_names.PushBack("dlc\dlc_acs\data\fx\bat_swarm\bat_swarm_02.w2ent");
			bat_template_names.PushBack("dlc\dlc_acs\data\fx\bat_swarm\bat_swarm_03.w2ent");
			bat_template_names.PushBack("dlc\dlc_acs\data\fx\bat_swarm\bat_swarm_04.w2ent");
			bat_template_names.PushBack("dlc\dlc_acs\data\fx\bat_swarm\bat_swarm_05.w2ent");
			bat_template_names.PushBack("dlc\dlc_acs\data\fx\bat_swarm\bat_swarm_06.w2ent");

			/*

			if( RandF() < 0.75 ) 
			{
				if( RandF() < 0.5 ) 
				{
					if( RandF() < 0.5 ) 
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
							
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_01.w2ent"
							
							, true ), spawnPos, adjustedRot );
					}
					else
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
							
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_02.w2ent"
							
							, true ), spawnPos, adjustedRot );
					}
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_03.w2ent"
							
							, true ), spawnPos, adjustedRot );
					}
					else
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_04.w2ent"
							
							, true ), spawnPos, adjustedRot );
					}
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

						"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_05.w2ent"
						
						, true ), spawnPos, adjustedRot );
				}
				else 
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

						"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_06.w2ent"
						
						, true ), spawnPos, adjustedRot );
				}
			}
			*/

			markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

			bat_template_names[RandRange(bat_template_names.Size())]
			
			, true ), spawnPos, adjustedRot );

			markerNPC.PlayEffectSingle('bat_swarm');
			markerNPC.DestroyAfter(3);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_bruxa_blood_resource()
{
	var vACS_bruxa_blood_resource : cACS_bruxa_blood_resource;
	vACS_bruxa_blood_resource = new cACS_bruxa_blood_resource in theGame;
			
	vACS_bruxa_blood_resource.ACS_bruxa_blood_resource_Engage();
}

statemachine class cACS_bruxa_blood_resource
{
    function ACS_bruxa_blood_resource_Engage()
	{
		this.PushState('ACS_bruxa_blood_resource_Engage');
	}
}

state ACS_bruxa_blood_resource_Engage in cACS_bruxa_blood_resource
{
	private var npc 																																						: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var vfxEnt, vfxEnt2, vfxEnt3																																	: CEntity;
	private var targetRotationNPC																																			: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		ACS_bruxa_blood_resource_ENTRY();
	}
	
	entry function ACS_bruxa_blood_resource_ENTRY()
	{
		ACS_bruxa_blood_resource_LATENT();
	}
	
	latent function ACS_bruxa_blood_resource_LATENT()
	{
		actors.Clear();

		actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			targetRotationNPC = npc.GetWorldRotation();
			targetRotationNPC.Yaw += RandRangeF(360,1);
			targetRotationNPC.Pitch += RandRangeF(360,1);
			targetRotationNPC.Roll += RandRangeF(360,1);
			
			if( actors.Size() > 0 )
			{	
				if 
				(
				!((CNewNPC)npc).IsFlying()
				&& !npc.HasAbility('mon_garkain')
				&& !npc.HasAbility('mon_sharley_base')
				&& !npc.HasAbility('mon_bies_base')
				&& !npc.HasAbility('mon_golem_base')
				&& !npc.HasAbility('mon_endriaga_base')
				&& !npc.HasAbility('mon_arachas_base')
				&& !npc.HasAbility('mon_kikimore_base')
				&& !npc.HasAbility('mon_black_spider_base')
				&& !npc.HasAbility('mon_black_spider_ep2_base')
				&& !npc.HasAbility('mon_ice_giant')
				&& !npc.HasAbility('mon_cyclops')
				&& !npc.HasAbility('mon_knight_giant')
				&& !npc.HasAbility('mon_cloud_giant')
				&& !npc.HasAbility('mon_troll_base')
				)
				{
					if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
					{
						vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );
						vfxEnt.CreateAttachment( npc, , Vector( 0, 0, 1.5 ), EulerAngles(RandRangeF(360,1), RandRangeF(360,1), RandRangeF(360,1)) );	
						vfxEnt.PlayEffectSingle('blood_explode_red');
						vfxEnt.PlayEffectSingle('hit');
						vfxEnt.PlayEffectSingle('hit_refraction');
						vfxEnt.DestroyAfter(1.5);

						vfxEnt2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync('finisher_blood', true), npc.GetWorldPosition(), targetRotationNPC);
						vfxEnt2.CreateAttachment( npc, , Vector( 0, 0, 1.5 ), EulerAngles(RandRangeF(360,1), RandRangeF(360,1), RandRangeF(360,1)) );	
						vfxEnt2.PlayEffectSingle('crawl_blood');
						vfxEnt2.DestroyAfter(1.5);
					}
					else
					{
						npc.PlayEffectSingle('blood');
						npc.StopEffect('blood');

						npc.PlayEffectSingle('death_blood');
						npc.StopEffect('death_blood');

						npc.PlayEffectSingle('heavy_hit');
						npc.StopEffect('heavy_hit');

						npc.PlayEffectSingle('light_hit');
						npc.StopEffect('light_hit');

						npc.PlayEffectSingle('blood_spill');
						npc.StopEffect('blood_spill');
					}
				}
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Hijack_Marker_Create()
{
	var vACS_Hijack_Marker_Create : cACS_Hijack_Marker_Create;
	vACS_Hijack_Marker_Create = new cACS_Hijack_Marker_Create in theGame;
			
	vACS_Hijack_Marker_Create.ACS_Hijack_Marker_Create_Engage();
}

statemachine class cACS_Hijack_Marker_Create
{
    function ACS_Hijack_Marker_Create_Engage()
	{
		this.PushState('ACS_Hijack_Marker_Create_Engage');
	}
}

state ACS_Hijack_Marker_Create_Engage in cACS_Hijack_Marker_Create
{
	private var npc 																																						: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var vfxEnt																																						: CEntity;
	private var targetRotationNPC																																			: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		ACS_Hijack_Marker_Create_ENTRY();
	}
	
	entry function ACS_Hijack_Marker_Create_ENTRY()
	{
		ACS_Hijack_Marker_Create_LATENT();
	}
	
	latent function ACS_Hijack_Marker_Create_LATENT()
	{
		actors.Clear();

		actors = GetActorsInRange(GetWitcherPlayer(), 10, 10, 'bruxa_bite_victim', true);

		ACS_Hijack_Marker_2_Destroy();

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			targetRotationNPC = npc.GetWorldRotation();
			targetRotationNPC.Yaw = RandRangeF(360,1);
			targetRotationNPC.Pitch = RandRangeF(45,-45);
			
			if( actors.Size() > 0 )
			{	
				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\ep1\data\fx\quest\q604\604_11_cellar\ground_smoke_ent.w2ent", true ), npc.GetWorldPosition(), targetRotationNPC );

				vfxEnt.CreateAttachmentAtBoneWS( npc, 'head', npc.GetBoneWorldPosition('head'), npc.GetWorldRotation() );

				vfxEnt.StopEffect('ground_smoke');

				vfxEnt.PlayEffectSingle('ground_smoke');

				vfxEnt.AddTag('Hijack_Marker_2');
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Arrow_Create()
{
	var vACS_Arrow_Create : cACS_Arrow_Create;
	vACS_Arrow_Create = new cACS_Arrow_Create in theGame;
			
	vACS_Arrow_Create.ACS_Arrow_Create_Engage();
}

function ACS_Arrow_Create_Ready()
{
	var vACS_Arrow_Create : cACS_Arrow_Create;
	vACS_Arrow_Create = new cACS_Arrow_Create in theGame;
			
	vACS_Arrow_Create.ACS_Arrow_Create_Ready_Engage();
}

function ACS_Arrow_Create_Ready_Arrow_Rain()
{
	var vACS_Arrow_Create : cACS_Arrow_Create;
	vACS_Arrow_Create = new cACS_Arrow_Create in theGame;
			
	vACS_Arrow_Create.ACS_Arrow_Create_Ready_Arrow_Rain_Engage();
}

statemachine class cACS_Arrow_Create
{
    function ACS_Arrow_Create_Engage()
	{
		this.PushState('ACS_Arrow_Create_Engage');
	}

	function ACS_Arrow_Create_Ready_Engage()
	{
		this.PushState('ACS_Arrow_Create_Ready_Engage');
	}

	function ACS_Arrow_Create_Ready_Arrow_Rain_Engage()
	{
		this.PushState('ACS_Arrow_Create_Ready_Arrow_Rain_Engage');
	}
}

state ACS_Arrow_Create_Engage in cACS_Arrow_Create
{
	private var attach_vec, bone_vec					: Vector;
	private var attach_rot, bone_rot					: EulerAngles;
	private var arrow1									: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Arrow_Create_Entry();
	}
	
	entry function Arrow_Create_Entry()
	{
		Arrow_Create_Latent();
	}
	
	latent function Arrow_Create_Latent()
	{
		if (GetWitcherPlayer().HasTag('acs_bow_active'))
		{
			//ACS_Bow_Arrow().Destroy();
			ACS_Bow_Arrow().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACS_Bow_Arrow().DestroyAfter(0.0125);

			arrow1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			//"items\weapons\projectiles\arrows\arrow_01.w2ent"
			"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );
				
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;
			
			arrow1.PlayEffectSingle('glow');

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				arrow1.PlayEffectSingle( 'fire' );
			}

			arrow1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			arrow1.AddTag('ACS_Bow_Arrow');
		}	
	}
}

state ACS_Arrow_Create_Ready_Engage in cACS_Arrow_Create
{
	private var attach_vec, bone_vec					: Vector;
	private var attach_rot, bone_rot					: EulerAngles;
	private var arrow1, vfxEnt							: CEntity;
	private var eff_names								: array<CName>;


	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Arrow_Create_Ready_Entry();
	}
	
	entry function Arrow_Create_Ready_Entry()
	{
		Arrow_Create_Ready_Latent();
	}
	
	latent function Arrow_Create_Ready_Latent()
	{
		if (GetWitcherPlayer().HasTag('acs_bow_active'))
		{
			ACS_Bow_Arrow().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACS_Bow_Arrow().DestroyAfter(0.0125);

			arrow1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			//"items\weapons\projectiles\arrows\arrow_01.w2ent"
			"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;
			
			arrow1.PlayEffectSingle('glow');

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				arrow1.PlayEffectSingle( 'fire' );
			}

			arrow1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			arrow1.AddTag('ACS_Bow_Arrow');

			if (thePlayer.GetStat( BCS_Focus ) == thePlayer.GetStatMax( BCS_Focus ))
			{
				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\sorceresses\sorceress_lightining_bolt.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

				vfxEnt.CreateAttachment( GetWitcherPlayer(), 'r_weapon' );

				eff_names.Clear();

				eff_names.PushBack('diagonal_up_left');
				eff_names.PushBack('diagonal_down_left');
				eff_names.PushBack('down');
				eff_names.PushBack('up');
				eff_names.PushBack('diagonal_up_right');
				eff_names.PushBack('diagonal_down_right');
				eff_names.PushBack('right');
				eff_names.PushBack('left');
				
				vfxEnt.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

				vfxEnt.AddTag('ACS_Bow_Arrow_Stationary_Effect');

				vfxEnt.DestroyAfter(2);
			}
		}	
	}
}

state ACS_Arrow_Create_Ready_Arrow_Rain_Engage in cACS_Arrow_Create
{
	private var attach_vec, bone_vec					: Vector;
	private var attach_rot, bone_rot					: EulerAngles;
	private var arrow1, vfxEnt							: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Arrow_Create_Ready_Arrow_Rain_Entry();
	}
	
	entry function Arrow_Create_Ready_Arrow_Rain_Entry()
	{
		Arrow_Create_Ready_Arrow_Rain_Latent();
	}
	
	latent function Arrow_Create_Ready_Arrow_Rain_Latent()
	{
		if (GetWitcherPlayer().HasTag('acs_bow_active'))
		{
			ACS_Bow_Arrow().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
			ACS_Bow_Arrow().DestroyAfter(0.0125);

			arrow1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
			//"items\weapons\projectiles\arrows\arrow_01.w2ent"
			"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				
			, true), GetWitcherPlayer().GetWorldPosition() );

			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0;
			attach_vec.Y = 0;
			attach_vec.Z = 0;
			
			arrow1.PlayEffectSingle('glow');

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				arrow1.PlayEffectSingle( 'fire' );
			}

			arrow1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );
			arrow1.AddTag('ACS_Bow_Arrow');

			if (thePlayer.GetStat( BCS_Focus ) == thePlayer.GetStatMax( BCS_Focus ))
			{
				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "gameplay\abilities\sorceresses\sorceress_lightining_bolt.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

				vfxEnt.CreateAttachment( GetWitcherPlayer(), 'r_weapon' );
				
				vfxEnt.PlayEffectSingle('diagonal_up_left');
				vfxEnt.PlayEffectSingle('diagonal_down_left');
				vfxEnt.PlayEffectSingle('down');
				vfxEnt.PlayEffectSingle('up');
				vfxEnt.PlayEffectSingle('diagonal_up_right');
				vfxEnt.PlayEffectSingle('diagonal_down_right');
				vfxEnt.PlayEffectSingle('right');
				vfxEnt.PlayEffectSingle('left');
				//vfxEnt.PlayEffectSingle('lightning_fx');
				//vfxEnt.PlayEffectSingle('shock');

				vfxEnt.AddTag('ACS_Bow_Arrow_Stationary_Effect');

				vfxEnt.DestroyAfter(2);
			}
		}	
	}
}

function ACS_CreateCrossbow_Arrow()
{
	var arrow1	 																																					: ACSCrossbowProjectile;
	var initpos, targetPositionNPC, targetPosition																													: Vector;
	var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	var attach_vec																																					: Vector;
	var attach_rot																																					: EulerAngles;

	ACS_Crossbow_Arrow().BreakAttachment();
	ACS_Crossbow_Arrow().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
	ACS_Crossbow_Arrow().DestroyAfter(0.125);
	ACS_Crossbow_Arrow().RemoveTag('ACS_Crossbow_Arrow');

	arrow1 = (ACSCrossbowProjectile)theGame.CreateEntity((CEntityTemplate)LoadResource( 
	
	"dlc\dlc_acs\data\entities\projectiles\crossbow_projectile.w2ent"
		
	, true), thePlayer.GetWorldPosition());
	
	arrow1.PlayEffectSingle('glow');

	attach_rot.Roll = 75;
	attach_rot.Pitch = 0;
	attach_rot.Yaw = 0;
	attach_vec.X = 0;
	attach_vec.Y = 0;
	attach_vec.Z = 0;

	if (igni_crossbow_1())
	{
		arrow1.CreateAttachment( igni_crossbow_1(), , attach_vec, attach_rot );
	}
	else if (axii_crossbow_1())
	{
		arrow1.CreateAttachment( axii_crossbow_1(), , attach_vec, attach_rot );
	}
	else if (aard_crossbow_1())
	{
		arrow1.CreateAttachment( aard_crossbow_1(), , attach_vec, attach_rot );
	}
	else if (quen_crossbow_1())
	{
		arrow1.CreateAttachment( quen_crossbow_1(), , attach_vec, attach_rot );
	}
	else if (yrden_crossbow_1())
	{
		arrow1.CreateAttachment( yrden_crossbow_1(), , attach_vec, attach_rot );
	}
	
	arrow1.AddTag('ACS_Crossbow_Arrow');
}

function ACS_ShootCrossbow_Arrow()
{
	var actortarget																																					: CActor;
	var actors    																																					: array<CActor>;
	var i         																																					: int;
	var arrow1	 																																					: ACSCrossbowProjectile;
	var initpos, targetPositionNPC, targetPosition																													: Vector;
	var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	var dmg																																							: W3DamageAction;
	var targetDistance																																				: float;
	var meshcomp 																																					: CComponent;
	var h 																																							: float;
	var movementAdjustor																																			: CMovementAdjustor;
	var ticket 																																						: SMovementAdjustmentRequestTicket;
	

	actortarget = (CActor)( GetWitcherPlayer().GetDisplayTarget() );	

	if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control')){GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');} GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustor.CancelAll();
	
	ticket = movementAdjustor.CreateNewRequest( 'ACS_Shoot_Arrow_Rotate' );
		
	movementAdjustor.AdjustmentDuration( ticket, 0.125 );

	movementAdjustor.ShouldStartAt(ticket, GetWitcherPlayer().GetWorldPosition());
	movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 5000000 );
	movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 5000000 );

	movementAdjustor.RotateTowards( ticket, actortarget );

	//initpos = GetWitcherPlayer().GetBoneWorldPosition('r_hand');
	if (igni_crossbow_1())
	{
		initpos = igni_crossbow_1().GetWorldPosition() + igni_crossbow_1().GetWorldUp();		
	}
	else if (axii_crossbow_1())
	{
		initpos = axii_crossbow_1().GetWorldPosition() + axii_crossbow_1().GetWorldUp();		
	}
	else if (aard_crossbow_1())
	{
		initpos = aard_crossbow_1().GetWorldPosition() + aard_crossbow_1().GetWorldUp();		
	}
	else if (quen_crossbow_1())
	{
		initpos = quen_crossbow_1().GetWorldPosition() + quen_crossbow_1().GetWorldUp();		
	}
	else if (yrden_crossbow_1())
	{
		initpos = yrden_crossbow_1().GetWorldPosition() + yrden_crossbow_1().GetWorldUp();		
	}

	initpos.Z -= 0.2;
	//initpos.X += 0.4;
	//initpos.Y += 0.25;

	if (actortarget)
	{
		if ( thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus) )
		{
			targetPosition = thePlayer.GetWorldPosition() + ( thePlayer.GetWorldForward() * 50 ) + (thePlayer.GetWorldRight() * RandRangeF(5.25, -5.25));
			targetPosition.Z += RandRangeF(5.5, 1.5);
		}
		else
		{
			targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 50;
			targetPosition.Z += 1.5;
		}
	}
	else
	{
		targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 50;
		targetPosition.Z += 1.5;
	}

	ACS_Crossbow_Arrow().BreakAttachment();
	ACS_Crossbow_Arrow().Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
	ACS_Crossbow_Arrow().DestroyAfter(0.125);
	ACS_Crossbow_Arrow().RemoveTag('ACS_Crossbow_Arrow');

	arrow1 = (ACSCrossbowProjectile)theGame.CreateEntity((CEntityTemplate)LoadResource( 
		
	//"items\weapons\projectiles\arrows\arrow_01.w2ent"
	"dlc\dlc_acs\data\entities\projectiles\crossbow_projectile.w2ent"
		
	, true), initpos);
	
	arrow1.PlayEffectSingle('glow');

	arrow1.PlayEffectSingle( 'fire' );

	arrow1.PlayEffectSingle('arrow_trail_fire');

	arrow1.Init(GetWitcherPlayer());

	arrow1.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500  );

	arrow1.DestroyAfter(31);
}

function ACS_Bow_Arrow() : CEntity
{
	var arrow 			 : CEntity;
	
	arrow = (CEntity)theGame.GetEntityByTag( 'ACS_Bow_Arrow' );
	return arrow;
}

function ACS_Crossbow_Arrow() : ACSCrossbowProjectile
{
	var arrow 			 : ACSCrossbowProjectile;
	
	arrow = (ACSCrossbowProjectile)theGame.GetEntityByTag( 'ACS_Crossbow_Arrow' );
	return arrow;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Shoot_Bow()
{
	var vACS_Shoot_Bow : cACS_Shoot_Bow;
	vACS_Shoot_Bow = new cACS_Shoot_Bow in theGame;
			
	vACS_Shoot_Bow.ACS_Shoot_Bow_Engage();
}

function ACS_Shoot_Bow_Arrow_Rain()
{
	var vACS_Shoot_Bow : cACS_Shoot_Bow;
	vACS_Shoot_Bow = new cACS_Shoot_Bow in theGame;
			
	vACS_Shoot_Bow.ACS_Shoot_Bow_Arrow_Rain_Engage();
}

statemachine class cACS_Shoot_Bow
{
    function ACS_Shoot_Bow_Engage()
	{
		this.PushState('ACS_Shoot_Bow_Engage');
	}

	 function ACS_Shoot_Bow_Arrow_Rain_Engage()
	{
		this.PushState('ACS_Shoot_Bow_Arrow_Rain_Engage');
	}
}

state ACS_Shoot_Bow_Engage in cACS_Shoot_Bow
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: ACSBowProjectileMoving;
	private var proj_2	 																																					: ACSBowProjectile;
	private var initpos, targetPositionNPC, targetPosition																													: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
	private var targetDistance																																				: float;
	private var meshcomp 																																					: CComponent;
	private var h 																																							: float;
	private var movementAdjustor																																			: CMovementAdjustor;
	private var ticket 																																						: SMovementAdjustmentRequestTicket;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ShootBowEntry();
	}
	
	entry function ShootBowEntry()
	{
		LockEntryFunction(true);
		ShootBowLatent();
		LockEntryFunction(false);
	}
	
	latent function ShootBowLatent()
	{	
		ACS_Bow_Arrow().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACS_Bow_Arrow().DestroyAfter(0.0125);

		actortarget = (CActor)( GetWitcherPlayer().GetDisplayTarget() );	

		if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control')){GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');} GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Shoot_Arrow_Rotate' );
			
		movementAdjustor.AdjustmentDuration( ticket, 0.125 );

		movementAdjustor.ShouldStartAt(ticket, GetWitcherPlayer().GetWorldPosition());
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 5000000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 5000000 );

		if (actortarget)
		{
			movementAdjustor.RotateTowards( ticket, actortarget );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}
		
		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actortarget.GetWorldPosition() ) ;

		initpos = GetWitcherPlayer().GetBoneWorldPosition('r_hand');		
		//initpos.Z += 0.5;
		//targetPosition =  GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 20;
		//targetPosition.Z += 1.5;

		targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 50;
		//targetPosition = GetWitcherPlayer().GetLookAtPosition();
		targetPosition.Z += 1.5;

		proj_1 = (ACSBowProjectileMoving)theGame.CreateEntity( 
		(CEntityTemplate)LoadResource( 
		"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
		, true ), initpos );

		proj_1.Init(GetWitcherPlayer());

		if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
		{
			proj_1.PlayEffectSingle( 'fire' );
		}

		proj_1.PlayEffectSingle('glow');

		if( ACS_AttitudeCheck ( actortarget ) && GetWitcherPlayer().IsInCombat() && actortarget.IsAlive() )
		{
			if ( actortarget.HasTag('ACS_second_bow_moving_projectile'))
			{
				proj_1.PlayEffectSingle('arrow_trail_fire');
			}

			proj_1.ShootProjectileAtPosition( 0, 10, targetPosition, 500  );
		}
		else
		{
			proj_1.ShootProjectileAtPosition( 0, 10, targetPosition, 500  );
		}

		proj_1.DestroyAfter(31);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Shoot_Bow_Arrow_Rain_Engage in cACS_Shoot_Bow
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: ACSBowProjectileMoving;
	private var proj_2	 																																					: ACSBowProjectile;
	private var initpos, targetPositionNPC, targetPosition																													: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
	private var targetDistance																																				: float;
	private var meshcomp 																																					: CComponent;
	private var h 																																							: float;
	private var movementAdjustor																																			: CMovementAdjustor;
	private var ticket 																																						: SMovementAdjustmentRequestTicket;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ShootBowArrowRainEntry();
	}
	
	entry function ShootBowArrowRainEntry()
	{
		LockEntryFunction(true);
		ShootBowArrowRainLatent();
		LockEntryFunction(false);
	}
	
	latent function ShootBowArrowRainLatent()
	{	
		ACS_Bow_Arrow().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ACS_Bow_Arrow().DestroyAfter(0.0125);

		actortarget = (CActor)( GetWitcherPlayer().GetDisplayTarget() );	

		if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control')){GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');} GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

		movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

		movementAdjustor.CancelAll();
		
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Shoot_Arrow_Rotate' );
			
		movementAdjustor.AdjustmentDuration( ticket, 0.125 );

		movementAdjustor.ShouldStartAt(ticket, GetWitcherPlayer().GetWorldPosition());
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 5000000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 5000000 );

		if (actortarget)
		{
			movementAdjustor.RotateTowards( ticket, actortarget );
		}
		else
		{
			movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
		}

		targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actortarget.GetWorldPosition() ) ;

		initpos = GetWitcherPlayer().GetBoneWorldPosition('r_hand');		
		//initpos.Z += 0.5;

		if( targetDistance <= 3 * 3 ) 
		{
			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('head');
				//targetPositionNPC.Z += RandRangeF(0,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
			else
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('k_head_g');
				//targetPositionNPC.Z += RandRangeF(0.1,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
		}
		else if( targetDistance > 3 * 3 && targetDistance <= 7.5*7.5 ) 
		{
			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('head');
				targetPositionNPC.Z += RandRangeF(0,-0.25);
				targetPositionNPC.X += RandRangeF(0.15,-0.15);
			}
			else
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('k_head_g');
				targetPositionNPC.Z += RandRangeF(0,-0.25);
				targetPositionNPC.X += RandRangeF(0.15,-0.15);
			}
		}
		else
		{
			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('head');
				targetPositionNPC.Z += RandRangeF(0,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
			else
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('k_head_g');
				targetPositionNPC.Z += RandRangeF(0,-0.1);
				targetPositionNPC.X += RandRangeF(0.1,-0.1);
			}
		}

		//targetPosition =  GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 20;
		//targetPosition.Z += 1.5;

		targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 10;
		//targetPosition = GetWitcherPlayer().GetLookAtPosition();
		targetPosition.Z += 1.5;

		if ( thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus) )
		{		
			proj_2 = (ACSBowProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\projectiles\bow_projectile.w2ent"
				, true ), initpos );
			
			meshcomp = proj_2.GetComponentByClassName('CMeshComponent');
			h = 2;
			meshcomp.SetScale(Vector(h,h,h,1));	

			proj_2.Init(GetWitcherPlayer());

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				proj_2.PlayEffectSingle( 'fire' );
			}

			proj_2.PlayEffectSingle('glow');

			if( ACS_AttitudeCheck ( actortarget ) && GetWitcherPlayer().IsInCombat() && actortarget.IsAlive() )
			{
				proj_2.PlayEffectSingle('arrow_trail_fire');
				proj_2.ShootProjectileAtPosition( 0, 40+RandRange(5,1), targetPosition, 500  );
			}
			else
			{
				proj_2.ShootProjectileAtPosition( 0, 40+RandRange(5,1), targetPosition, 500  );
			}

			proj_2.DestroyAfter(31);
		}
		else
		{
			proj_1 = (ACSBowProjectileMoving)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\projectiles\bow_projectile_moving.w2ent"
				, true ), initpos );

			proj_1.Init(GetWitcherPlayer());

			if (GetWitcherPlayer().GetEquippedSign() == ST_Igni)
			{
				proj_1.PlayEffectSingle( 'fire' );
			}

			proj_1.PlayEffectSingle('glow');

			if( ACS_AttitudeCheck ( actortarget ) && GetWitcherPlayer().IsInCombat() && actortarget.IsAlive() )
			{
				if ( actortarget.HasTag('ACS_second_bow_moving_projectile'))
				{
					proj_1.ShootProjectileAtPosition( 0, 40+RandRange(5,1), targetPositionNPC, 500  );
					proj_1.PlayEffectSingle('arrow_trail_fire');
				}
				else
				{
					proj_1.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPositionNPC, 500  );
				}
			}
			else
			{
				proj_1.ShootProjectileAtPosition( 0, 20+RandRange(5,1), targetPosition, 500  );
			}

			proj_1.DestroyAfter(31);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Shoot_Bow_Stationary()
{
	var vACS_Shoot_Bow_Stationary : cACS_Shoot_Bow_Stationary;
	vACS_Shoot_Bow_Stationary = new cACS_Shoot_Bow_Stationary in theGame;
			
	vACS_Shoot_Bow_Stationary.ACS_Shoot_Bow_Stationary_Engage();
}

statemachine class cACS_Shoot_Bow_Stationary
{
    function ACS_Shoot_Bow_Stationary_Engage()
	{
		this.PushState('ACS_Shoot_Bow_Stationary_Engage');
	}
}

state ACS_Shoot_Bow_Stationary_Engage in cACS_Shoot_Bow_Stationary
{
	private var actortarget																																					: CActor;
	private var actors    																																					: array<CActor>;
	private var i         																																					: int;
	private var rock_pillar_temp																																			: CEntityTemplate;
	private var proj_1	 																																					: W3ACSIceSpearProjectile;
	private var initpos, targetPositionNPC																																	: Vector;
	private var targetRotationNPC, targetRotationPlayer																														: EulerAngles;
	private var dmg																																							: W3DamageAction;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Shoot_Bow_Stationary_Entry();
	}
	
	entry function Shoot_Bow_Stationary_Entry()
	{
		LockEntryFunction(true);
		Shoot_Bow_Stationary_Latent();
		LockEntryFunction(false);
	}
	
	latent function Shoot_Bow_Stationary_Latent()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 2.5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];
				
			initpos = actortarget.GetWorldPosition();			
			initpos.Z += 7;
					
			targetPositionNPC = actortarget.PredictWorldPosition(0.35f);
			targetPositionNPC.Z += 1.1;
					
			proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );
							
			proj_1.Init(GetWitcherPlayer());
			proj_1.PlayEffectSingle('fire_fx');
			proj_1.PlayEffectSingle('explode');
			proj_1.ShootProjectileAtPosition( 0, 10 + RandRange(10,0), targetPositionNPC, 500 );
			proj_1.DestroyAfter(5);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Umbral_Slash_Single()
{
	var vACS_Umbral_Slash_Single : cACS_Umbral_Slash_Single;
	vACS_Umbral_Slash_Single = new cACS_Umbral_Slash_Single in theGame;
			
	vACS_Umbral_Slash_Single.ACS_Umbral_Slash_Single_Engage();
}

statemachine class cACS_Umbral_Slash_Single
{
    function ACS_Umbral_Slash_Single_Engage()
	{
		this.PushState('ACS_Umbral_Slash_Single_Engage');
	}
}

state ACS_Umbral_Slash_Single_Engage in cACS_Umbral_Slash_Single
{
	private var ent, ent__2, ent__3, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6                         									: CEntity;
	private var playerRot, playerRot_1, playerRot_2, playerRot_3, rot, rot_1, rot_2, rot_3, rot_4, rot_5, rot_6, adjustedRot            : EulerAngles;
    private var playerPos, playerPos_1, playerPos_2, playerPos_3, pos, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6							: Vector;
	private var dmg 																													: W3DamageAction;
	private var damageMax																												: float;
	private var attAction																												: W3Action_Attack;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Umbral_Slash_Single();
	}
	
	entry function Umbral_Slash_Single()
	{
		LockEntryFunction(true);
		Umbral_Slash_Single_Activate();
		LockEntryFunction(false);
	}
	
	latent function Umbral_Slash_Single_Activate()
	{
		rot = GetWitcherPlayer().GetDisplayTarget().GetWorldRotation();

		pos = GetWitcherPlayer().GetDisplayTarget().GetWorldPosition();

		pos.Z += 1.5;

		playerPos = GetWitcherPlayer().GetWorldPosition();

		playerRot = thePlayer.GetWorldRotation();

		playerRot.Yaw += 180;

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;


		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), pos, adjustedRot );

		ent.CreateAttachment( GetWitcherPlayer().GetDisplayTarget(), , Vector( 0, -0.5, 1.5 ) );

		ent.PlayEffectSingle('sword_slash_orb');

		ent.DestroyAfter(1);

		/*
		playerRot_1 = playerRot;

		playerRot_1.Yaw = RandRangeF(360,1);

		playerRot_1.Pitch = RandRangeF(45,-45);

		playerRot_1.Roll = RandRange( 360, 0 );

		playerPos_1 = playerPos;

		playerPos_1.Z += RandRangeF( 0.5, -0.4 );

		playerPos_1.Y += RandRangeF( 0.4, -0.4 );

		playerPos_1.X += RandRangeF( 0.4, -0.4 );

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), playerPos_1, playerRot_1 );

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ) );

		ent.PlayEffectSingle('sword_slash_orb_big');

		ent.DestroyAfter(5);

		

		playerRot_2 = playerRot;

		playerRot_2.Yaw = RandRangeF(360,1);

		playerRot_2.Pitch = RandRangeF(45,-45);

		playerRot_2.Roll = RandRange( 360, 0 );

		playerPos_2 = playerPos;

		playerPos_2.Z += RandRangeF( 0.5, -0.4 );

		playerPos_2.Y += RandRangeF( 0.4, -0.4 );

		playerPos_2.X += RandRangeF( 0.4, -0.4 );


		ent__2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), playerPos_2, playerRot_2 );

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ) );

		ent__2.PlayEffectSingle('sword_slash_orb_big');

		ent__2.DestroyAfter(5);

		playerRot_3 = playerRot;

		playerRot_3.Yaw = RandRangeF(360,1);

		playerRot_3.Pitch = RandRangeF(45,-45);

		playerRot_3.Roll = RandRange( 360, 0 );

		playerPos_3 = playerPos;

		playerPos_3.Z += RandRangeF( 0.5, -0.4 );

		playerPos_3.Y += RandRangeF( 0.4, -0.4 );

		playerPos_3.X += RandRangeF( 0.4, -0.4 );


		ent__3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), playerPos_3, playerRot_3 );

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ) );

		ent__3.PlayEffectSingle('sword_slash_orb_big');

		ent__3.DestroyAfter(5);
		*/

		rot_1 = adjustedRot;

		rot_1.Yaw = RandRangeF(360,1);

		rot_1.Pitch = RandRangeF(45,-45);

		rot_1.Roll = RandRange( 360, 0 );

		pos_1 = pos;

		pos_1.Z += RandRangeF( 0.5, -0.4 );

		pos_1.Y += RandRangeF( 0.4, -0.4 );

		pos_1.X += RandRangeF( 0.4, -0.4 );



		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_1, rot_1 );

		ent_1.PlayEffectSingle('sword_slash_medium');

		ent_1.DestroyAfter(0.5);



		rot_2 = adjustedRot;

		rot_2.Yaw = RandRangeF(360,1);

		rot_2.Pitch = RandRangeF(45,-45);

		rot_2.Roll = RandRange( 360, 0 );

		pos_2 = pos;

		pos_2.Z += RandRangeF( 0.5, -0.4 );

		pos_2.Y += RandRangeF( 0.4, -0.4 );

		pos_2.X += RandRangeF( 0.4, -0.4 );


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_2, rot_2 );

		ent_2.PlayEffectSingle('sword_slash_medium');

		ent_2.DestroyAfter(0.5);





		rot_3 = adjustedRot;

		rot_3.Yaw = RandRangeF(360,1);

		rot_3.Pitch = RandRangeF(45,-45);

		rot_3.Roll = RandRange( 360, 0 );

		pos_3 = pos;

		pos_3.Z += RandRangeF( 0.5, -0.4 );

		pos_3.Y += RandRangeF( 0.4, -0.4 );

		pos_3.X += RandRangeF( 0.4, -0.4 );




		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_3, rot_3 );

		ent_3.PlayEffectSingle('sword_slash_medium');

		ent_3.DestroyAfter(0.5);




		rot_4 = adjustedRot;

		rot_4.Yaw = RandRangeF(360,1);

		rot_4.Pitch = RandRangeF(45,-45);

		rot_4.Roll = RandRange( 360, 0 );

		pos_4 = pos;

		pos_4.Z += RandRangeF( 0.5, -0.4 );

		pos_4.Y += RandRangeF( 0.4, -0.4 );

		pos_4.X += RandRangeF( 0.4, -0.4 );




		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_4, rot_4 );

		ent_4.PlayEffectSingle('sword_slash_medium');

		ent_4.DestroyAfter(0.5);





		rot_5 = adjustedRot;

		rot_5.Yaw = RandRangeF(360,1);

		rot_5.Pitch = RandRangeF(45,-45);

		rot_5.Roll = RandRange( 360, 0 );

		pos_5 = pos;

		pos_5.Z += RandRangeF( 0.5, -0.4 );

		pos_5.Y += RandRangeF( 0.4, -0.4 );

		pos_5.X += RandRangeF( 0.4, -0.4 );



		ent_5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_5, rot_5 );

		ent_5.PlayEffectSingle('sword_slash');

		ent_5.DestroyAfter(0.5);




		rot_6 = adjustedRot;

		rot_6.Yaw = RandRangeF(360,1);

		rot_6.Pitch = RandRangeF(45,-45);

		rot_6.Roll = RandRange( 360, 0 );

		pos_6 = pos;

		pos_6.Z += RandRangeF( 0.5, -0.4 );

		pos_6.Y += RandRangeF( 0.4, -0.4 );

		pos_6.X += RandRangeF( 0.4, -0.4 );



		ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), pos_6, rot_6 );

		ent_6.PlayEffectSingle('sword_slash');

		ent_6.DestroyAfter(0.5);

		/*
		dmg = new W3DamageAction in theGame.damageMgr;
		dmg.Initialize(NULL, GetWitcherPlayer().GetDisplayTarget(), theGame, 'ACS_Umbral_Slash_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

		dmg.SetProcessBuffsIfNoDamage(true);
		dmg.SetCanPlayHitParticle(true);

		if (GetWitcherPlayer().GetDisplayTarget().UsesVitality()) 
		{ 
			damageMax = GetWitcherPlayer().GetDisplayTarget().GetStat( BCS_Vitality ) * 0.25; 
		} 
		else if (GetWitcherPlayer().GetDisplayTarget().UsesEssence()) 
		{ 
			damageMax = GetWitcherPlayer().GetDisplayTarget().GetStat( BCS_Essence ) * 0.25; 
		} 

		dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, damageMax );

		dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, damageMax );
					
		//dmg.AddEffectInfo( EET_Stagger, 0.5 );

		dmg.SetForceExplosionDismemberment();
			
		theGame.damageMgr.ProcessAction( dmg );
								
		delete dmg;
		*/
		if( (CActor)GetWitcherPlayer().GetDisplayTarget() && ACS_AttitudeCheck ( (CActor)GetWitcherPlayer().GetDisplayTarget() ) )
		{
			((CActor)GetWitcherPlayer().GetDisplayTarget()).AddAbility( 'DisableFinishers', true );

			attAction = new W3Action_Attack in theGame.damageMgr;

			attAction.Init( GetWitcherPlayer(), GetWitcherPlayer().GetDisplayTarget(), GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
			theGame.params.ATTACK_NAME_HEAVY, GetWitcherPlayer().GetName(), EHRT_None, true, true, theGame.params.ATTACK_NAME_HEAVY, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
			attAction.SetHitReactionType(EHRT_Heavy);
			attAction.SetHitAnimationPlayType(EAHA_Default);

			if (((CActor)GetWitcherPlayer().GetDisplayTarget()).UsesVitality()) 
			{ 
				damageMax = ((CActor)GetWitcherPlayer().GetDisplayTarget()).GetStat( BCS_Vitality ) * 0.1; 
			} 
			else if (((CActor)GetWitcherPlayer().GetDisplayTarget()).UsesEssence()) 
			{ 
				damageMax = ((CActor)GetWitcherPlayer().GetDisplayTarget()).GetStat( BCS_Essence ) * 0.1; 
			}

			attAction.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
			
			attAction.SetSoundAttackType( 'wpn_slice' );
			
			attAction.AddEffectInfo( EET_Stagger, 1 );
			
			theGame.damageMgr.ProcessAction( attAction );	
			
			if ( ( (CNewNPC)GetWitcherPlayer().GetDisplayTarget()).IsShielded( NULL ) )
			{
				( (CNewNPC)GetWitcherPlayer().GetDisplayTarget()).ProcessShieldDestruction();
			}

			delete attAction;

			((CActor)GetWitcherPlayer().GetDisplayTarget()).RemoveAbility( 'DisableFinishers' );

			if( GetWitcherPlayer().GetStat( BCS_Focus ) >= GetWitcherPlayer().GetStatMax( BCS_Focus )/3
			&& GetWitcherPlayer().GetStat( BCS_Focus ) < GetWitcherPlayer().GetStatMax( BCS_Focus ) * 2/3) 
			{	
				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
			}
			else if( GetWitcherPlayer().GetStat( BCS_Focus ) >= GetWitcherPlayer().GetStatMax( BCS_Focus ) * 2/3
			&& GetWitcherPlayer().GetStat( BCS_Focus ) < GetWitcherPlayer().GetStatMax( BCS_Focus )) 
			{	
				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) * 1/3);
			}
			else if( GetWitcherPlayer().GetStat( BCS_Focus ) == GetWitcherPlayer().GetStatMax(BCS_Focus) ) 
			{
				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) * 1/3);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Umbral_Slash_End_Damage_Actual()
{
	var dmg 																																							: W3DamageAction;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var marks																																							: array< CEntity >;
	var mark       																																						: CEntity;
	var attAction																																						: W3Action_Attack;

	marks.Clear();
			
	theGame.GetEntitiesByTag( 'Umbral_Slash_End_Mark', marks );

	for( i=0; i<marks.Size(); i+=1 )
	{	
		mark = (CEntity)marks[i];	
		mark.Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -100) );
		mark.Destroy();
	}

	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actortarget = (CActor)actors[i];
		/*
		dmg = new W3DamageAction in theGame.damageMgr;
		dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Umbral_Slash_End_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

		dmg.SetProcessBuffsIfNoDamage(true);
		dmg.SetCanPlayHitParticle(true);

		if (actortarget.UsesVitality()) 
		{ 
			damageMax = actortarget.GetStatMax( BCS_Vitality ) * 0.75; 
		} 
		else if (GetWitcherPlayer().GetDisplayTarget().UsesEssence()) 
		{ 
			damageMax = actortarget.GetStatMax( BCS_Essence ) * 0.75; 
		} 

		dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
					
		dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );

		//dmg.SetForceExplosionDismemberment();
			
		theGame.damageMgr.ProcessAction( dmg );
								
		delete dmg;
		*/

		((CActor)actortarget).AddAbility( 'DisableFinishers', true );

		attAction = new W3Action_Attack in theGame.damageMgr;

		attAction.Init( GetWitcherPlayer(), actortarget, GetWitcherPlayer(), GetWitcherPlayer().GetInventory().GetItemFromSlot( 'r_weapon' ), 
		theGame.params.ATTACK_NAME_LIGHT, GetWitcherPlayer().GetName(), EHRT_None, true, true, theGame.params.ATTACK_NAME_LIGHT, AST_NotSet, ASD_NotSet, true, false, false, false, , , , , );
		attAction.SetHitReactionType(EHRT_Light);
		attAction.SetHitAnimationPlayType(EAHA_Default);

		if (actortarget.UsesVitality()) 
		{ 
			maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

			damageMax = maxTargetVitality * 0.45; 
		} 
		else if (actortarget.UsesEssence()) 
		{ 
			maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
			
			damageMax = maxTargetEssence * 0.45; 
		} 

		attAction.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );
		
		attAction.SetSoundAttackType( 'wpn_slice' );
		
		attAction.AddEffectInfo( EET_Stagger, 1 );
		
		theGame.damageMgr.ProcessAction( attAction );	
		
		if ( ( (CNewNPC)actortarget).IsShielded( NULL ) )
		{
			( (CNewNPC)actortarget).ProcessShieldDestruction();
		}

		delete attAction;

		((CActor)actortarget).RemoveAbility( 'DisableFinishers' );
	}

	GetWitcherPlayer().StopEffect('olgierd_energy_blast');
	
	GetWitcherPlayer().PlayEffectSingle('olgierd_energy_blast');
	GetWitcherPlayer().PlayEffectSingle('olgierd_energy_blast');
	GetWitcherPlayer().PlayEffectSingle('olgierd_energy_blast');
	GetWitcherPlayer().PlayEffectSingle('olgierd_energy_blast');
	GetWitcherPlayer().PlayEffectSingle('olgierd_energy_blast');
	GetWitcherPlayer().StopEffect('olgierd_energy_blast');
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Umbral_Slash_End_Effect()
{
	var vACS_Umbral_Slash_End : cACS_Umbral_Slash_End;
	vACS_Umbral_Slash_End = new cACS_Umbral_Slash_End in theGame;
			
	vACS_Umbral_Slash_End.ACS_Umbral_Slash_End_Engage();
}

statemachine class cACS_Umbral_Slash_End
{
    function ACS_Umbral_Slash_End_Engage()
	{
		this.PushState('ACS_Umbral_Slash_End_Engage');
	}
}

state ACS_Umbral_Slash_End_Engage in cACS_Umbral_Slash_End
{
	private var ent, ent__1, ent__2, ent__3, ent__4, ent__5, ent__6, ent__7, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6                         									: CEntity;
	private var playerRot, playerRot_1, playerRot_2, playerRot_3, playerRot_4, playerRot_5, playerRot_6, playerRot_7, rot, rot_1, rot_2, rot_3, rot_4, rot_5, rot_6             : EulerAngles;
    private var playerPos, playerPos_1, playerPos_2, playerPos_3, playerPos_4, playerPos_5, playerPos_6, playerPos_7, pos, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6				: Vector;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Umbral_Slash_End();
	}
	
	entry function Umbral_Slash_End()
	{
		LockEntryFunction(true);
		Umbral_Slash_End_Activate();
		LockEntryFunction(false);
	}
	
	latent function Umbral_Slash_End_Activate()
	{
		playerRot = GetWitcherPlayer().GetWorldRotation();

		playerPos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 2.5;

		playerPos.Z += 1.5;

		playerRot_1 = playerRot;

		playerRot_1.Yaw = RandRangeF(360,1);

		playerRot_1.Pitch = RandRangeF(45,-45);

		playerRot_1.Roll = RandRange( 360, 0 );

		playerPos_1 = playerPos;

		playerPos_1.Z += RandRangeF( 0.5, -0.4 );

		playerPos_1.Y += RandRangeF( 0.4, -0.4 );

		playerPos_1.X += RandRangeF( 0.4, -0.4 );

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			//"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			"dlc\dlc_acs\data\fx\acs_sword_slash_orb.w2ent"
			, true ), playerPos_1, playerRot_1 );

		ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0.5 ) );

		ent.PlayEffectSingle('sword_slash_orb_big');

		ent.DestroyAfter(5);


		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			actortarget.AddEffectDefault( EET_Immobilized, GetWitcherPlayer(), 'ACS_Umbral_Slash_End' );

			actortarget.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'ACS_Umbral_Slash_End' );

				
			rot = actortarget.GetWorldRotation();

			pos = actortarget.GetWorldPosition();

			pos.Z += 1.5;

			rot_1 = rot;

			rot_1.Yaw = RandRangeF(360,1);

			rot_1.Pitch = RandRangeF(45,-45);

			rot_1.Roll = RandRange( 360, 0 );

			pos_1 = pos;

			pos_1.Z += RandRangeF( 0.5, 0 );

			pos_1.Y += RandRangeF( 1.4, -1.4 );

			pos_1.X += RandRangeF( 2.4, -2.4 );



			ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_1, rot_1 );

			ent_1.AddTag('Umbral_Slash_End_Mark');


			ent_1.PlayEffectSingle('sword_slash_red_large');

			ent_1.DestroyAfter(2.5);



			rot_2 = rot;

			rot_2.Yaw = RandRangeF(360,1);

			rot_2.Pitch = RandRangeF(45,-45);

			rot_2.Roll = RandRange( 360, 0 );

			pos_2 = pos;

			pos_2.Z += RandRangeF( 0.5, 0 );

			pos_2.Y += RandRangeF( 1.4, -1.4 );

			pos_2.X += RandRangeF( 2.4, -2.4 );


			ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_2, rot_2 );

			ent_2.AddTag('Umbral_Slash_End_Mark');


			ent_2.PlayEffectSingle('sword_slash_red_large');

			ent_2.DestroyAfter(5);





			rot_3 = rot;

			rot_3.Yaw = RandRangeF(360,1);

			rot_3.Pitch = RandRangeF(45,-45);

			rot_3.Roll = RandRange( 360, 0 );

			pos_3 = pos;

			pos_3.Z += RandRangeF( 0.5, 0 );

			pos_3.Y += RandRangeF( 1.4, -1.4 );

			pos_3.X += RandRangeF( 2.4, -2.4 );




			ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_3, rot_3 );
			
			ent_3.AddTag('Umbral_Slash_End_Mark');


			ent_3.PlayEffectSingle('sword_slash_red_large');

			ent_3.DestroyAfter(5);


			rot_4 = rot;

			rot_4.Yaw = RandRangeF(360,1);

			rot_4.Pitch = RandRangeF(45,-45);

			rot_4.Roll = RandRange( 360, 0 );

			pos_4 = pos;

			pos_4.Z += RandRangeF( 0.5, 0 );

			pos_4.Y += RandRangeF( 1.4, -1.4 );

			pos_4.X += RandRangeF( 1.4, -1.4 );




			ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_4, rot_4 );

			ent_4.AddTag('Umbral_Slash_End_Mark');


			ent_4.PlayEffectSingle('sword_slash_red_large');

			ent_4.DestroyAfter(5);





			rot_5 = rot;

			rot_5.Yaw = RandRangeF(360,1);

			rot_5.Pitch = RandRangeF(45,-45);

			rot_5.Roll = RandRange( 360, 0 );

			pos_5 = pos;

			pos_5.Z += RandRangeF( 0.5, 0 );

			pos_5.Y += RandRangeF( 1.4, -1.4 );

			pos_5.X += RandRangeF( 2.4, -2.4 );



			ent_5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_5, rot_5 );

			ent_5.AddTag('Umbral_Slash_End_Mark');


			ent_5.PlayEffectSingle('sword_slash_red_large');

			ent_5.DestroyAfter(5);


			rot_6 = rot;

			rot_6.Yaw = RandRangeF(360,1);

			rot_6.Pitch = RandRangeF(45,-45);

			rot_6.Roll = RandRange( 360, 0 );

			pos_6 = pos;

			pos_6.Z += RandRangeF( 0.5, 0 );

			pos_6.Y += RandRangeF( 1.4, -1.4 );

			pos_6.X += RandRangeF( 2.4, -2.4 );

			ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
				, true ), pos_6, rot_6 );

			ent_6.AddTag('Umbral_Slash_End_Mark');

			ent_6.PlayEffectSingle('sword_slash_red_large');

			ent_6.DestroyAfter(5);

		}

		playerRot_2 = playerRot;

		playerRot_2.Yaw = RandRangeF(360,1);

		playerRot_2.Pitch = RandRangeF(45,-45);

		playerRot_2.Roll = RandRange( 360, 0 );

		playerPos_2 = playerPos;

		playerPos_2.Z += RandRangeF( 0.5, 0 );

		playerPos_2.Y += RandRangeF( 1.4, -0.4 );

		playerPos_2.X += RandRangeF( 2.4, -2.4 );



		ent__1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_2, playerRot_2 );

		ent__1.AddTag('Umbral_Slash_End_Mark');


		ent__1.PlayEffectSingle('sword_slash_red_large');

		ent__1.DestroyAfter(5);



		playerRot_3 = playerRot;

		playerRot_3.Yaw = RandRangeF(360,1);

		playerRot_3.Pitch = RandRangeF(45,-45);

		playerRot_3.Roll = RandRange( 360, 0 );

		playerPos_3 = playerPos;

		playerPos_3.Z += RandRangeF( 0.5, 0 );

		playerPos_3.Y += RandRangeF( 1.4, -1.4 );

		playerPos_3.X += RandRangeF( 2.4, -2.4 );


		ent__2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_3, playerRot_3 );

		ent__2.AddTag('Umbral_Slash_End_Mark');

		ent__2.PlayEffectSingle('sword_slash_red_large');

		ent__2.DestroyAfter(5);





		playerRot_4 = playerRot;

		playerRot_4.Yaw = RandRangeF(360,1);

		playerRot_4.Pitch = RandRangeF(45,-45);

		playerRot_4.Roll = RandRange( 360, 0 );

		playerPos_4 = playerPos;

		playerPos_4.Z += RandRangeF( 0.5, 0 );

		playerPos_4.Y += RandRangeF( 1.4, -0.4 );

		playerPos_4.X += RandRangeF( 2.4, -2.4 );




		ent__3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_4, playerRot_4 );
		
		ent__3.AddTag('Umbral_Slash_End_Mark');


		ent__3.PlayEffectSingle('sword_slash_red_large');

		ent__3.DestroyAfter(5);


		playerRot_5 = playerRot;

		playerRot_5.Yaw = RandRangeF(360,1);

		playerRot_5.Pitch = RandRangeF(45,-45);

		playerRot_5.Roll = RandRange( 360, 0 );

		playerPos_5 = playerPos;

		playerPos_5.Z += RandRangeF( 0.5, 0 );

		playerPos_5.Y += RandRangeF( 1.4, -0.4 );

		playerPos_5.X += RandRangeF( 1.4, -1.4 );




		ent__4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_5, playerRot_5 );
		
		ent__4.AddTag('Umbral_Slash_End_Mark');


		ent__4.PlayEffectSingle('sword_slash_red_large');

		ent__4.DestroyAfter(5);





		playerRot_6 = playerRot;

		playerRot_6.Yaw = RandRangeF(360,1);

		playerRot_6.Pitch = RandRangeF(45,-45);

		playerRot_6.Roll = RandRange( 360, 0 );

		playerPos_6 = playerPos;

		playerPos_6.Z += RandRangeF( 0.5, 0 );

		playerPos_6.Y += RandRangeF( 1.4, -0.4 );

		playerPos_6.X += RandRangeF( 2.4, -2.4 );



		ent__5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_6, playerRot_6 );
		
		ent__5.AddTag('Umbral_Slash_End_Mark');


		ent__5.PlayEffectSingle('sword_slash_red_large');

		ent__5.DestroyAfter(5);




		playerRot_7 = playerRot;

		playerRot_7.Yaw = RandRangeF(360,1);

		playerRot_7.Pitch = RandRangeF(45,-45);

		playerRot_7.Roll = RandRange( 360, 0 );

		playerPos_7 = playerPos;

		playerPos_7.Z += RandRangeF( 0.5, 0 );

		playerPos_7.Y += RandRangeF( 1.4, -0.4 );

		playerPos_7.X += RandRangeF( 2.4, -2.4 );


		ent__6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos_7, playerRot_7 );
		
		ent__6.AddTag('Umbral_Slash_End_Mark');

		ent__6.PlayEffectSingle('sword_slash_red_large');

		ent__6.DestroyAfter(5);

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Sparagmos_Effect()
{
	var vACS_Sparagmos : cACS_Sparagmos;
	vACS_Sparagmos = new cACS_Sparagmos in theGame;
			
	vACS_Sparagmos.ACS_Sparagmos_Engage();
}

function ACS_Sparagmos_Damage()
{
	var vACS_Sparagmos : cACS_Sparagmos;
	vACS_Sparagmos = new cACS_Sparagmos in theGame;
			
	vACS_Sparagmos.ACS_Sparagmos_Damage_Engage();
}

statemachine class cACS_Sparagmos
{
    function ACS_Sparagmos_Engage()
	{
		this.PushState('ACS_Sparagmos_Engage');
	}

	function ACS_Sparagmos_Damage_Engage()
	{
		this.PushState('ACS_Sparagmos_Damage_Engage');
	}
}

state ACS_Sparagmos_Engage in cACS_Sparagmos
{
	private var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7                         																					: CEntity;
	private var adjustedRot, playerRot_1, playerRot_2, playerRot_3, playerRot_4, playerRot_5, playerRot_6, playerRot_7, rot, rot_1, rot_2, rot_3, rot_4, rot_5, rot_6             : EulerAngles;
    private var playerPos, playerPos_1, playerPos_2, playerPos_3, playerPos_4, playerPos_5, playerPos_6, playerPos_7, pos, pos_1, pos_2, pos_3, pos_4, pos_5, pos_6				: Vector;
	private var euler_sword																																						: EulerAngles;
	private var vector_sword																																					: Vector;
	private var eff_names																																						: array<CName>;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sparagmos();
	}
	
	entry function Sparagmos()
	{
		Sparagmos_Activate();
	}

	function fill_lightning_array()
	{
		eff_names.Clear();

		eff_names.PushBack('diagonal_up_left');
		eff_names.PushBack('diagonal_down_left');
		eff_names.PushBack('down');
		eff_names.PushBack('up');
		eff_names.PushBack('diagonal_up_right');
		eff_names.PushBack('diagonal_down_right');
		eff_names.PushBack('right');
		eff_names.PushBack('left');
	}
	
	latent function Sparagmos_Activate()
	{
		fill_lightning_array();

		//GetACSWatcher().RemoveTimer('ACS_Sparagmos_Electric_Effect');

		//GetACSSparagmosEffect_2().Destroy();

		adjustedRot = GetWitcherPlayer().GetWorldRotation();

		playerPos = GetWitcherPlayer().GetWorldPosition();


		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"
			, true ), playerPos, adjustedRot );

		euler_sword.Roll = 0;
		euler_sword.Pitch = 0;
		euler_sword.Yaw = 0;
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 5.25;

		ent.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword );

		//ent.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent.AddTag('ACS_Sparagmos_Effect');

		ent.DestroyAfter(2);



		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			
			"gameplay\abilities\sorceresses\sorceress_lightining_bolt.w2ent"
			
			, true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 0.25;

		ent_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword );
		
		//ent.PlayEffectSingle('diagonal_up_left');
		//ent.PlayEffectSingle('diagonal_down_left');
		//ent.PlayEffectSingle('down');
		//ent.PlayEffectSingle('up');
		//ent.PlayEffectSingle('diagonal_up_right');
		//ent.PlayEffectSingle('diagonal_down_right');
		//ent.PlayEffectSingle('right');
		//ent.PlayEffectSingle('left');

		ent_1.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);
		ent_1.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);
		ent_1.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_1.PlayEffectSingle('shock');
		ent_1.PlayEffectSingle('shock');
		ent_1.PlayEffectSingle('shock');
		ent_1.PlayEffectSingle('shock');
		ent_1.PlayEffectSingle('shock');

		ent_1.StopEffect('shock');

		ent_1.DestroyAfter(2);

		ent_1.AddTag('ACS_Sparagmos_Effect_1');


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_lightning.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 2;

		ent_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword  );

		//ent_2.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_2.AddTag('ACS_Sparagmos_Effect_2');

		ent_2.DestroyAfter(2);



		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_lightning.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 6;

		ent_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword  );

		//ent_3.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_3.AddTag('ACS_Sparagmos_Effect_3');

		ent_3.DestroyAfter(2);


		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_lightning.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 10;

		ent_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword  );

		//ent_4.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_4.AddTag('ACS_Sparagmos_Effect_4');

		ent_4.DestroyAfter(2);




		ent_5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_lightning.w2ent", true ), GetWitcherPlayer().GetWorldPosition() );

		euler_sword.Roll = RandRangeF(360,1);
		euler_sword.Pitch = RandRangeF(360,1);
		euler_sword.Yaw = RandRangeF(360,1);
		vector_sword.X = 0;
		vector_sword.Y = 0;
		vector_sword.Z = 14;

		ent_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', vector_sword, euler_sword  );

		//ent_5.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent_5.AddTag('ACS_Sparagmos_Effect_5');

		ent_5.DestroyAfter(2);

		//ACS_Heavy_Attack_Extended_Trail();

		GetACSWatcher().AddTimer('ACS_Sparagmos_Electric_Effect', 0.1, true);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Sparagmos_Damage_Engage in cACS_Sparagmos
{
	private var ent_6                       																																	: CEntity;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var attAction																																						: W3Action_Attack;
	private var eff_names																																						: array<CName>;
	private var targetPos																																						: Vector;
	private var targetRot																																						: EulerAngles;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Sparagmos_Damage();
	}
	
	entry function Sparagmos_Damage()
	{
		LockEntryFunction(true);
		Sparagmos_Damage_Activate();
		LockEntryFunction(false);
	}

	function fill_lightning_array()
	{
		eff_names.Clear();

		eff_names.PushBack('diagonal_up_left');
		eff_names.PushBack('diagonal_down_left');
		eff_names.PushBack('down');
		eff_names.PushBack('up');
		eff_names.PushBack('diagonal_up_right');
		eff_names.PushBack('diagonal_down_right');
		eff_names.PushBack('right');
		eff_names.PushBack('left');
	}
	
	latent function Sparagmos_Damage_Activate()
	{
		fill_lightning_array();

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				targetPos = actortarget.GetWorldPosition();

				targetRot = actortarget.GetWorldRotation();

				ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "gameplay\abilities\sorceresses\sorceress_lightining_bolt.w2ent", true ), actortarget.GetWorldPosition() );

				ent_6.CreateAttachment( actortarget, , Vector(0,0,1), EulerAngles(RandRangeF(360,0), RandRangeF(360,0), RandRangeF(360,0)) );
				
				ent_6.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

				/*
				ent_6.PlayEffectSingle('diagonal_up_left');
				ent_6.PlayEffectSingle('diagonal_up_left');
				ent_6.PlayEffectSingle('diagonal_down_left');
				ent_6.PlayEffectSingle('down');
				ent_6.PlayEffectSingle('up');
				ent_6.PlayEffectSingle('diagonal_up_right');
				ent_6.PlayEffectSingle('diagonal_down_right');
				ent_6.PlayEffectSingle('right');
				ent_6.PlayEffectSingle('left');
				*/

				//ent_6.PlayEffectSingle('lightning_fx');
				ent_6.PlayEffectSingle('shock');

				ent_6.DestroyAfter(1);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSSparagmosEffect() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect' );
	return ent;
}

function GetACSSparagmosEffect_1() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_1' );
	return ent;
}

function GetACSSparagmosEffect_2() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_2' );
	return ent;
}

function GetACSSparagmosEffect_3() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_3' );
	return ent;
}

function GetACSSparagmosEffect_4() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_4' );
	return ent;
}

function GetACSSparagmosEffect_5() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Sparagmos_Effect_5' );
	return ent;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Bruxa_Scream()
{
	var vACS_Bruxa_Scream : cACS_Bruxa_Scream;
	vACS_Bruxa_Scream = new cACS_Bruxa_Scream in theGame;
			
	vACS_Bruxa_Scream.ACS_Bruxa_Scream_Engage();
}

statemachine class cACS_Bruxa_Scream
{
    function ACS_Bruxa_Scream_Engage()
	{
		this.PushState('ACS_Bruxa_Scream_Engage');
	}
}

state ACS_Bruxa_Scream_Engage in cACS_Bruxa_Scream
{
	private var ent, ent_2, ent_3                   : CEntity;
	private var rot                        			: EulerAngles;
    private var pos									: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Bruxa_Scream();
	}
	
	entry function Bruxa_Scream()
	{
		LockEntryFunction(true);
		Bruxa_Scream_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bruxa_Scream_Activate()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

		if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
		{
			if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
			{
				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_voice_taunt_claws");

				ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
					"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"
					, true ), pos, rot );
				
				ent_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 3, 0 ), EulerAngles(0,0,0) );

				ent_2.PlayEffectSingle('swarm_attack');

				ent_2.DestroyAfter(7);

				ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
					"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"
					, true ), pos, rot );
				
				ent_3.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 3, -5 ), EulerAngles(0,0,0) );

				ent_3.PlayEffectSingle('swarm_attack');

				ent_3.DestroyAfter(7);

				GetACSWatcher().AddTimer('ACS_Bruxa_Scream_Release_Delay', 4.5, false);
			}
			else	
			{
				GetWitcherPlayer().SoundEvent("monster_bruxa_voice_scream");

				ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
				"dlc\bob\data\gameplay\abilities\bruxa\bruxa_scream_attack.w2ent"
				, true ), pos, rot );

				ent.AddTag('ACS_Bruxa_Scream');

				ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

				ent.PlayEffectSingle('cone');

				ent.DestroyAfter(3);

				GetACSWatcher().AddTimer('ACS_Bruxa_Scream_Release_Delay', 2, false);
			}
		}
		else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
		{
			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_voice_taunt_claws");

			ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
				"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"
				, true ), pos, rot );
			
			ent_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 3, 0 ), EulerAngles(0,0,0) );

			ent_2.PlayEffectSingle('swarm_attack');

			ent_2.DestroyAfter(7);

			ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
				"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_attack.w2ent"
				, true ), pos, rot );
			
			ent_3.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 3, -5 ), EulerAngles(0,0,0) );

			ent_3.PlayEffectSingle('swarm_attack');

			ent_3.DestroyAfter(7);

			GetACSWatcher().AddTimer('ACS_Bruxa_Scream_Release_Delay', 4.5, false);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function Get_ACS_Bruxa_Scream() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Bruxa_Scream' );
	return ent;
}

function ACS_Bruxa_Scream_Release()
{
	var dmg																																								: W3DamageAction;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;

	actors.Clear();

	actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			dmg = new W3DamageAction in theGame.damageMgr;
			dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Bruxa_Scream_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

			dmg.SetProcessBuffsIfNoDamage(true);
			dmg.SetCanPlayHitParticle(true);
			
			if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
			{
				if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
				{
					if (actortarget.UsesVitality()) 
					{ 
						maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

						damageMax = maxTargetVitality * 0.35; 
					} 
					else if (actortarget.UsesEssence()) 
					{ 
						maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
						
						damageMax = maxTargetEssence * 0.35; 
					}  

					dmg.AddEffectInfo( EET_Bleeding, 10 );

					dmg.AddEffectInfo( EET_Confusion, 1 );
				}
				else
				{
					Get_ACS_Bruxa_Scream().StopEffect('cone');

					Get_ACS_Bruxa_Scream().PlayEffectSingle('fx_push');

					if (actortarget.UsesVitality()) 
					{ 
						maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

						damageMax = maxTargetVitality * 0.15; 
					} 
					else if (actortarget.UsesEssence()) 
					{ 
						maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
						
						damageMax = maxTargetEssence * 0.15; 
					} 

					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );
				}
			}
			else if (GetWitcherPlayer().HasTag('aard_sword_equipped'))
			{
				if (actortarget.UsesVitality()) 
				{ 
					maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * 0.35; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
					
					damageMax = maxTargetEssence * 0.35; 
				}  

				dmg.AddEffectInfo( EET_Bleeding, 10 );

				dmg.AddEffectInfo( EET_Confusion, 1 );
			}

			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );

			//dmg.SetForceExplosionDismemberment();
				
			theGame.damageMgr.ProcessAction( dmg );
									
			delete dmg;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Transformation_Bruxa_Scream()
{
	var vACS_Transformation_Bruxa_Scream : cACS_Transformation_Bruxa_Scream;
	vACS_Transformation_Bruxa_Scream = new cACS_Transformation_Bruxa_Scream in theGame;
			
	vACS_Transformation_Bruxa_Scream.ACS_Transformation_Bruxa_Scream_Engage();
}

statemachine class cACS_Transformation_Bruxa_Scream
{
    function ACS_Transformation_Bruxa_Scream_Engage()
	{
		this.PushState('ACS_Transformation_Bruxa_Scream_Engage');
	}
}

state ACS_Transformation_Bruxa_Scream_Engage in cACS_Transformation_Bruxa_Scream
{
	private var ent, ent_2, ent_3                   : CEntity;
	private var rot                        			: EulerAngles;
    private var pos									: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Bruxa_Scream();
	}
	
	entry function Bruxa_Scream()
	{
		LockEntryFunction(true);
		Bruxa_Scream_Activate();
		LockEntryFunction(false);
	}
	
	latent function Bruxa_Scream_Activate()
	{
		rot = GetACSTransformationVampiress().GetWorldRotation();

		pos = GetACSTransformationVampiress().GetWorldPosition() + GetACSTransformationVampiress().GetHeadingVector() * 1.3;
	
		//GetWitcherPlayer().SoundEvent("monster_bruxa_voice_scream");

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
		"dlc\bob\data\gameplay\abilities\bruxa\bruxa_scream_attack.w2ent"
		, true ), pos, rot );

		ent.AddTag('ACS_Transformation_Bruxa_Scream');

		ent.CreateAttachment( GetACSTransformationVampiress(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('cone');

		ent.DestroyAfter(3);

		GetACSWatcher().AddTimer('ACS_Transformation_Bruxa_Scream_Release_Delay', 2, false);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function Get_ACS_Transformation_Bruxa_Scream() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Bruxa_Scream' );
	return ent;
}

function ACS_Transformation_Bruxa_Scream_Release()
{
	var dmg																																								: W3DamageAction;
	var actortarget																																						: CActor;
	var actors    																																						: array<CActor>;
	var i         																																						: int;
	var damageMax, maxTargetVitality, maxTargetEssence																													: float;

	actors.Clear();

	actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetACSTransformationVampiress().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			actortarget = (CActor)actors[i];

			dmg = new W3DamageAction in theGame.damageMgr;
			dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Bruxa_Scream_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

			dmg.SetProcessBuffsIfNoDamage(true);
			dmg.SetCanPlayHitParticle(true);
			
			Get_ACS_Transformation_Bruxa_Scream().StopEffect('cone');

			Get_ACS_Transformation_Bruxa_Scream().PlayEffectSingle('fx_push');

			if (actortarget.UsesVitality()) 
			{ 
				maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

				damageMax = maxTargetVitality * 0.25; 
			} 
			else if (actortarget.UsesEssence()) 
			{ 
				maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
				
				damageMax = maxTargetEssence * 0.25; 
			} 

			dmg.AddEffectInfo( EET_HeavyKnockdown, 2 );
			
			dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 100 + damageMax );

			dmg.SetForceExplosionDismemberment();
				
			theGame.damageMgr.ProcessAction( dmg );
									
			delete dmg;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Bat_Teleport_FX()
{
	var vACS_Bat_Teleport_FX : cACS_Bat_Teleport_FX;
	vACS_Bat_Teleport_FX = new cACS_Bat_Teleport_FX in theGame;
			
	vACS_Bat_Teleport_FX.ACS_Bat_Teleport_FX_Engage();
}

statemachine class cACS_Bat_Teleport_FX
{
    function ACS_Bat_Teleport_FX_Engage()
	{
		this.PushState('ACS_Bat_Teleport_FX_Engage');
	}
}

state ACS_Bat_Teleport_FX_Engage in cACS_Bat_Teleport_FX
{
	private var ent                         : CEntity;
	private var rot                         : EulerAngles;
    private var pos							: Vector;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Bat_Teleport_FX_Entry();
	}
	
	entry function Bat_Teleport_FX_Entry()
	{
		Bat_Teleport_FX_Latent();
	}
	
	latent function Bat_Teleport_FX_Latent()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.3;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\bob\data\fx\monsters\dettlaff\dettlaff_swarm_trap.w2ent"

			, true ), pos, rot );

		ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0 ), EulerAngles( 0, 90, 0 ) );

		ent.PlayEffectSingle('swarm_attack');

		ent.DestroyAfter(2);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Water_Aard()
{
	var vACS_Water_Aard : cACS_Water_Aard;
	vACS_Water_Aard = new cACS_Water_Aard in theGame;
			
	vACS_Water_Aard.ACS_Water_Aard_Engage();
}

statemachine class cACS_Water_Aard
{
    function ACS_Water_Aard_Engage()
	{
		this.PushState('ACS_Water_Aard_Engage');
	}
	
	function ACS_Water_Aard_Release_Engage()
	{
		this.PushState('ACS_Water_Aard_Release_Engage');
	}
}

state ACS_Water_Aard_Engage in cACS_Water_Aard
{
	private var ent, ent_2, ent_3                   : CEntity;
	private var rot                        			: EulerAngles;
    private var pos									: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Water_Aard();
	}
	
	entry function Water_Aard()
	{
		LockEntryFunction(true);
		Water_Aard_Activate();
		LockEntryFunction(false);
	}
	
	latent function Water_Aard_Activate()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.1;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\bob\data\gameplay\abilities\water_mage\sand_push_cast_bob.w2ent"
		, true ), pos, rot );

		ent.AddTag('ACS_Water_Aard');

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('cone');

		ent.DestroyAfter(3);

		GetACSWatcher().AddTimer('ACS_Water_Aard_Release_Delay', 0.5, false);
	
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Water_Aard_Release_Engage in cACS_Water_Aard
{
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var ent, ent_2, ent_3                  																																: CEntity;
	private var rot                        																																		: EulerAngles;
    private var pos																																								: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Water_Aard_Release();
	}
	
	entry function Water_Aard_Release()
	{
		LockEntryFunction(true);
		Water_Aard_Release_Activate();
		LockEntryFunction(false);
	}
	
	latent function Water_Aard_Release_Activate()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 1.1;

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
		"dlc\bob\data\gameplay\abilities\water_mage\sand_push_cast_bob.w2ent"
		, true ), pos, rot );

		ent.AddTag('ACS_Water_Aard');

		//ent.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0.5, 0.375 ), EulerAngles(0,0,0) );

		ent.PlayEffectSingle('cone');

		ent.PlayEffectSingle('blast');

		ent.DestroyAfter(3);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetWitcherPlayer().GetHeadingVector()), 60, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Water_Aard_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					damageMax = actortarget.GetStatMax( BCS_Vitality ) * 0.03; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					damageMax = actortarget.GetStatMax( BCS_Essence ) * 0.03; 
				} 

				if (
				!actortarget.HasTag('ACS_First_Water_Wave_Hit')
				&& !actortarget.HasTag('ACS_Second_Water_Wave_Hit')
				)
				{
					actortarget.AddTag('ACS_First_Water_Wave_Hit'); 
				}
				else if (
				actortarget.HasTag('ACS_First_Water_Wave_Hit') 
				)
				{
					actortarget.RemoveTag('ACS_First_Water_Wave_Hit'); 
					actortarget.AddTag('ACS_Second_Water_Wave_Hit');
				}
				else if (
				actortarget.HasTag('ACS_Second_Water_Wave_Hit')
				)
				{
					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );

					actortarget.RemoveTag('ACS_Second_Water_Wave_Hit'); 
				}

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );

				//dmg.SetForceExplosionDismemberment();
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}
	}
}

function Get_ACS_Water_Aard() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Water_Aard' );
	return ent;
}

function ACS_Water_Aard_Release()
{
	var vACS_Water_Aard : cACS_Water_Aard;
	vACS_Water_Aard = new cACS_Water_Aard in theGame;
			
	vACS_Water_Aard.ACS_Water_Aard_Release_Engage();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Giant_Stomp()
{
	var vACS_Giant_Stomp : cACS_Giant_Stomp;
	vACS_Giant_Stomp = new cACS_Giant_Stomp in theGame;
			
	vACS_Giant_Stomp.ACS_Giant_Stomp_Engage();
}

statemachine class cACS_Giant_Stomp
{
    function ACS_Giant_Stomp_Engage()
	{
		this.PushState('ACS_Giant_Stomp_Engage');
	}
}

state ACS_Giant_Stomp_Engage in cACS_Giant_Stomp
{
	private var ent_1, ent_2                																																	: CEntity;
	private var rot                        																																		: EulerAngles;
    private var pos																																								: Vector;
	private var dmg																																								: W3DamageAction;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax, maxTargetVitality, maxTargetEssence																													: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Stomp_Entry();
	}
	
	entry function Giant_Stomp_Entry()
	{
		Giant_Stomp_Latent();
	}
	
	latent function Giant_Stomp_Latent()
	{
		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			//"dlc\bob\data\fx\monsters\dettlaff\dettlaff_monster_ground.w2ent"

			"dlc\dlc_acs\data\fx\stomp_prer_ground.w2ent"

			, true ), pos, rot );

		//ent_1.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 1, 0 ), EulerAngles(0,0,0) );

		ent_1.PlayEffectSingle('impact');

		ent_1.PlayEffectSingle('warning');

		ent_1.DestroyAfter(5);

		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			//"dlc\bob\data\fx\monsters\dettlaff\blast.w2ent"
			
			"dlc\dlc_acs\data\fx\stomp_blast.w2ent"

			, true ), pos, rot );

		//ent_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 1, 0 ), EulerAngles(0,0,0) );

		ent_2.PlayEffectSingle('blast_lv1');

		ent_2.DestroyAfter(1);

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 5, 20, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				dmg = new W3DamageAction in theGame.damageMgr;
				dmg.Initialize(GetWitcherPlayer(), actortarget, theGame, 'ACS_Giant_Stomp_Damage', EHRT_Heavy, CPS_Undefined, false, false, true, false);

				dmg.SetProcessBuffsIfNoDamage(true);
				dmg.SetCanPlayHitParticle(true);

				if (actortarget.UsesVitality()) 
				{ 
					maxTargetVitality = actortarget.GetStatMax( BCS_Vitality ) - actortarget.GetStat( BCS_Vitality );

					damageMax = maxTargetVitality * 0.25; 
				} 
				else if (actortarget.UsesEssence()) 
				{ 
					maxTargetEssence = actortarget.GetStatMax( BCS_Essence ) - actortarget.GetStat( BCS_Essence );
					
					damageMax = maxTargetEssence * 0.25; 
				} 

				if (
				!actortarget.HasTag('ACS_First_Giant_Stomp_Hit')
				&& !actortarget.HasTag('ACS_Second_Giant_Stomp_Hit')
				)
				{
					dmg.AddEffectInfo( EET_Stagger, 0.5 );

					actortarget.AddTag('ACS_First_Giant_Stomp_Hit'); 
				}
				else if (
				actortarget.HasTag('ACS_First_Giant_Stompe_Hit') 
				)
				{
					dmg.AddEffectInfo( EET_Stagger, 0.5 );

					actortarget.RemoveTag('ACS_First_Giant_Stomp_Hit'); 
					actortarget.AddTag('ACS_Second_Giant_Stomp_Hit');
				}
				else if (
				actortarget.HasTag('ACS_Second_Giant_Stomp_Hit')
				)
				{
					dmg.AddEffectInfo( EET_HeavyKnockdown, 1 );

					actortarget.RemoveTag('ACS_Second_Giant_Stomp_Hit'); 
				}

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );

				//dmg.SetForceExplosionDismemberment();
					
				theGame.damageMgr.ProcessAction( dmg );
										
				delete dmg;
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Storm_Spear_Effect()
{
	var vACS_Storm_Spear : cACS_Storm_Spear;
	vACS_Storm_Spear = new cACS_Storm_Spear in theGame;
			
	vACS_Storm_Spear.ACS_Storm_Spear_Engage();
}

function ACS_Storm_Spear_Damage()
{
	var vACS_Storm_Spear : cACS_Storm_Spear;
	vACS_Storm_Spear = new cACS_Storm_Spear in theGame;
			
	vACS_Storm_Spear.ACS_Storm_Spear_Damage_Engage();
}

statemachine class cACS_Storm_Spear
{
    function ACS_Storm_Spear_Engage()
	{
		this.PushState('ACS_Storm_Spear_Engage');
	}

	 function ACS_Storm_Spear_Damage_Engage()
	{
		this.PushState('ACS_Storm_Spear_Damage_Engage');
	}
}

state ACS_Storm_Spear_Damage_Engage in cACS_Storm_Spear
{
	private var ent_6                       																																	: CEntity;
	private var actortarget																																						: CActor;
	private var actors    																																						: array<CActor>;
	private var i         																																						: int;
	private var damageMax																																						: float;
	private var attAction																																						: W3Action_Attack;
	private var eff_names																																						: array<CName>;
	private var targetPos																																						: Vector;
	private var targetRot																																						: EulerAngles;
	private var meshcomp																																						: CComponent;
	private var animcomp 																																						: CAnimatedComponent;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Storm_Spear_Damage();
	}
	
	entry function Storm_Spear_Damage()
	{
		LockEntryFunction(true);
		Storm_Spear_Damage_Activate();
		LockEntryFunction(false);
	}
	
	latent function Storm_Spear_Damage_Activate()
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInCone(10, VecHeading(GetWitcherPlayer().GetHeadingVector()), 30, 50, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				targetPos = actortarget.GetWorldPosition();

				targetRot = actortarget.GetWorldRotation();

				ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\tornado_custom_2.w2ent", true ), actortarget.GetWorldPosition() );

				animcomp = (CAnimatedComponent)ent_6.GetComponentByClassName('CAnimatedComponent');
				meshcomp = ent_6.GetComponentByClassName('CMeshComponent');

				animcomp.SetScale(Vector( 0.5, 0.5, 0.5, 1 ));

				meshcomp.SetScale(Vector( 0.5, 0.5, 0.5, 1 ));	

				animcomp.SetAnimationSpeedMultiplier( 3  ); 

				ent_6.CreateAttachment( actortarget, , Vector( 0, 0, 0 ) );

				ent_6.PlayEffectSingle('tornado');

				ent_6.DestroyAfter(1.5);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Storm_Spear_Engage in cACS_Storm_Spear
{
	private var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	private var rot, attach_rot                        						 	: EulerAngles;
   	private var pos, attach_vec													: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Storm_Spear_Entry();
	}
	
	entry function Storm_Spear_Entry()
	{
		Storm_Spear_Latent();
	}
	
	latent function Storm_Spear_Latent()
	{
		ACS_Storm_Spear_Array_Destroy_Immediate();

		GetWitcherPlayer().SoundEvent("magic_man_tornado_loop_start");

		GetWitcherPlayer().SoundEvent("magic_man_sand_gust");

		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.25, 0.25, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.25, 0.25, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 8  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent.PlayEffectSingle('tornado');


		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_1.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_1.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_1.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.225, 0.225, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.225, 0.225, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 4  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_1.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_1.PlayEffectSingle('tornado');


		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_2.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_2.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_2.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.2, 0.2, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.2, 0.2, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 2  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_2.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_2.PlayEffectSingle('tornado');


		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_3.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_3.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_3.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.175, 0.175, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.175, 0.175, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 1 ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_3.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_3.PlayEffectSingle('tornado');

		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_4.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_4.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_4.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.15, 0.15, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.15, 0.15, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 0.5  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_4.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_4.PlayEffectSingle('tornado');


		ent_5 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_5.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_5.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_5.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.125, 0.125, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.125, 0.125, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 0.25  ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_5.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_5.PlayEffectSingle('tornado');

		ent_6 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\tornado_custom_2.w2ent"

			, true ), pos, rot );

		ent_6.AddTag('ACS_Tornado_Effect');

		animcomp = (CAnimatedComponent)ent_6.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent_6.GetComponentByClassName('CMeshComponent');

		animcomp.SetScale(Vector( 0.1, 0.1, 0.75, 1 ));

		meshcomp.SetScale(Vector( 0.1, 0.1, 0.75, 1 ));	

		animcomp.SetAnimationSpeedMultiplier( 0 ); 

		attach_rot.Roll = 0;
		attach_rot.Pitch = 180;
		attach_rot.Yaw = 0;
		attach_vec.X = 0;
		attach_vec.Y = 0;
		attach_vec.Z = 5;
		
		ent_6.CreateAttachment( GetWitcherPlayer(), 'r_weapon', attach_vec, attach_rot );

		ent_6.PlayEffectSingle('tornado');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Storm_Spear_Array_Destroy_Immediate()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Tornado_Effect', ents );	

	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}

	GetWitcherPlayer().SoundEvent("magic_man_tornado_loop_stop");
}

function ACS_Storm_Spear_Array_Destroy()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Tornado_Effect', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		//ents[i].Destroy();
		ents[i].StopAllEffects();
		ents[i].BreakAttachment(); 
		ents[i].Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
		ents[i].DestroyAfter(0.00125);
	}

	GetWitcherPlayer().SoundEvent("magic_man_tornado_loop_stop");
}

function ACS_Storm_Spear_Array_Stop_Effects()
{	
	var i												: int;
	var ents 											: array<CEntity>;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Tornado_Effect', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].StopAllEffects();
		ents[i].DestroyAfter(3);
	}

	GetWitcherPlayer().SoundEvent("magic_man_tornado_loop_stop");
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Giant_Sword_Fall()
{
	var vACS_Giant_Sword_Fall : cACS_Giant_Sword_Fall;
	vACS_Giant_Sword_Fall = new cACS_Giant_Sword_Fall in theGame;
			
	vACS_Giant_Sword_Fall.ACS_Giant_Sword_Fall_Engage();
}

statemachine class cACS_Giant_Sword_Fall
{
    function ACS_Giant_Sword_Fall_Engage()
	{
		this.PushState('ACS_Giant_Sword_Fall_Engage');
	}
}

state ACS_Giant_Sword_Fall_Engage in cACS_Giant_Sword_Fall
{
	private var initpos					: Vector;
	private var sword 					: SwordProjectileGiant;
	private var actor       			: CActor;
	private var targetPosition			: Vector;
	private var meshcomp 				: CComponent;
	private var h 						: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Giant_Sword_Fall_Entry();
	}
	
	entry function Giant_Sword_Fall_Entry()
	{
		Giant_Sword_Fall_Latent();
	}
	
	latent function Giant_Sword_Fall_Latent()
	{
		actor = ( CActor)( GetWitcherPlayer().GetDisplayTarget() );
		
		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{	
			initpos = actor.GetWorldPosition();				
			initpos.Z += 40;
						
			targetPosition = actor.PredictWorldPosition( 0.1 );
			//targetPosition.Z += 1.1;
				
			sword = (SwordProjectileGiant)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_giant.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 10;
			meshcomp.SetScale(Vector(h,h,h,1));	
				
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 50, targetPosition, 500 );
			sword.DestroyAfter(31);
		}		
		else
		{
			initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 5;				
			initpos.Z += 40;
								
			//targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 5;
			targetPosition = GetWitcherPlayer().GetLookAtPosition();
				
			sword = (SwordProjectileGiant)theGame.CreateEntity( 
			(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\sword_projectile_giant.w2ent", true ), initpos );
				
			meshcomp = sword.GetComponentByClassName('CMeshComponent');
			h = 10;
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			sword.Init(GetWitcherPlayer());
			sword.PlayEffectSingle('appear');
			sword.PlayEffectSingle('glow');
			sword.ShootProjectileAtPosition( 0, 50, targetPosition, 500 );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Dagger_Summon()
{
	var vACS_Dagger_Summon : cACS_Dagger_Summon;
	vACS_Dagger_Summon = new cACS_Dagger_Summon in theGame;
			
	vACS_Dagger_Summon.ACS_Dagger_Summon_Engage();
}

statemachine class cACS_Dagger_Summon
{
    function ACS_Dagger_Summon_Engage()
	{
		this.PushState('ACS_Dagger_Summon_Engage');
	}
}

state ACS_Dagger_Summon_Engage in cACS_Dagger_Summon
{
	private var attach_vec				: Vector;
	private var dagger_1 				: CEntity;
	private var attach_rot				: EulerAngles;
	private var meshcomp 				: CComponent;
	private var h 						: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		
		GetACSWatcher().RemoveTimer('ACS_Dagger_Destroy_Timer');
		//ACS_Dagger().Destroy();

		if(!GetWitcherPlayer().HasTag('ACS_Dagger_Summoned'))
		{
			Dagger_Summon_Entry();
		}

		GetACSWatcher().AddTimer('ACS_Dagger_Destroy_Timer', 1.25, false);
	}
	
	entry function Dagger_Summon_Entry()
	{
		Dagger_Summon_Latent();
	}
	
	latent function Dagger_Summon_Latent()
	{
		GetWitcherPlayer().AddTag('ACS_Dagger_Summoned');

		if ( !theSound.SoundIsBankLoaded("mq_nml_1035.bnk") )
		{
			theSound.SoundLoadBank( "mq_nml_1035.bnk", false );
		}

		GetWitcherPlayer().SoundEvent("scene_weapon_sword_unsheat_fast");

		dagger_1 = (CEntity)theGame.CreateEntity((CEntityTemplate)LoadResource( 
						
		"dlc\dlc_acs\data\entities\swords\baron_dagger.w2ent" 

		//"items\quest_items\q105\q105_item__ritual_dagger.w2ent"
			
		, true), GetWitcherPlayer().GetWorldPosition() );
			
		attach_rot.Roll = 30;
		attach_rot.Pitch = 30;
		attach_rot.Yaw = 30;
		attach_vec.X = 0.025;
		attach_vec.Y = 0;
		attach_vec.Z = 0.0125;
			
		dagger_1.CreateAttachment( GetWitcherPlayer(), 'l_weapon', attach_vec, attach_rot );
		dagger_1.AddTag('acs_dagger_1');

		//GetACSWatcher().AddTimer('ACS_Dagger_Summon_Delay', 0.125, false);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Dagger() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_dagger_1' );
	return sword;
}

function ACS_Dagger_Destroy()
{
	ACS_Dagger().PlayEffectSingle('fast_attack_buff_hit');

	ACS_Dagger().BreakAttachment(); 
	ACS_Dagger().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Dagger().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('ACS_Dagger_Summoned');
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Yrden_Sidearm_Summon()
{
	var vACS_Yrden_Sidearm_Summon : cACS_Yrden_Sidearm_Summon;
	vACS_Yrden_Sidearm_Summon = new cACS_Yrden_Sidearm_Summon in theGame;
			
	vACS_Yrden_Sidearm_Summon.ACS_Yrden_Sidearm_Summon_Engage();
}

statemachine class cACS_Yrden_Sidearm_Summon
{
    function ACS_Yrden_Sidearm_Summon_Engage()
	{
		this.PushState('ACS_Yrden_Sidearm_Summon_Engage');
	}
}

state ACS_Yrden_Sidearm_Summon_Engage in cACS_Yrden_Sidearm_Summon
{
	private var anchor_temp, blade_temp 					: CEntityTemplate;
	private var l_blade1, l_blade2, l_blade3, l_anchor		: CEntity;
	private var attach_vec, bone_vec						: Vector;
	private var attach_rot, bone_rot						: EulerAngles;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		
		GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Timer');

		GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');

		if(!GetWitcherPlayer().HasTag('ACS_Yrden_Sidearm_Summoned'))
		{
			Dagger_Summon_Entry();
		}

		GetACSWatcher().AddTimer('ACS_Yrden_Sidearm_Destroy_Timer', 4, false);
	}
	
	entry function Dagger_Summon_Entry()
	{
		Dagger_Summon_Latent();
	}
	
	latent function Dagger_Summon_Latent()
	{
		GetWitcherPlayer().AddTag('ACS_Yrden_Sidearm_Summoned');

		anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_forearm' ), bone_vec, bone_rot );
		l_anchor = (CEntity)theGame.CreateEntity( anchor_temp, GetWitcherPlayer().GetWorldPosition() );
		
		l_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_forearm', bone_vec, bone_rot );

		if ( GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
		{
			blade_temp = (CEntityTemplate)LoadResource( 
				"dlc\ep1\data\items\weapons\swords\steel_swords\steel_sword_ep1_02.w2ent"
				
				, true );
		}
		else
		{
			blade_temp = (CEntityTemplate)LoadResource( 
				"items\weapons\swords\wildhunt_swords\wildhunt_sword_lvl3.w2ent"
				
				, true );
		}
				
		l_blade1 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		
		l_blade2 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );
		
		l_blade3 = (CEntity)theGame.CreateEntity( blade_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.15;
		attach_vec.Y = -0.15;
		attach_vec.Z = -0.005;
		
		l_blade1.CreateAttachment( l_anchor, , attach_vec, attach_rot );
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.15;
		attach_vec.Y = -0.15;
		attach_vec.Z = 0.045;
		
		l_blade2.CreateAttachment( l_anchor, , attach_vec, attach_rot );
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 270;
		attach_rot.Yaw = 10;
		attach_vec.X = -0.15;
		attach_vec.Y = -0.15;
		attach_vec.Z = -0.05;
		
		l_blade3.CreateAttachment( l_anchor, , attach_vec, attach_rot );

		l_anchor.AddTag('acs_yrden_sidearm_anchor');

		l_blade1.AddTag('acs_yrden_sidearm_1');

		l_blade2.AddTag('acs_yrden_sidearm_2');

		l_blade3.AddTag('acs_yrden_sidearm_3');

		GetACSWatcher().AddTimer('ACS_Yrden_Sidearm_Summon_Delay', 0.125, false);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Yrden_Sidearm_Anchor() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_yrden_sidearm_anchor' );
	return sword;
}

function ACS_Yrden_Sidearm_1() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_yrden_sidearm_1' );
	return sword;
}

function ACS_Yrden_Sidearm_2() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_yrden_sidearm_2' );
	return sword;
}

function ACS_Yrden_Sidearm_3() : CEntity
{
	var sword 			 : CEntity;
	
	sword = (CEntity)theGame.GetEntityByTag( 'acs_yrden_sidearm_3' );
	return sword;
}

function ACS_Yrden_Sidearm_Destroy()
{
	ACS_Yrden_Sidearm_1().PlayEffectSingle('fire_sparks_trail');
	ACS_Yrden_Sidearm_1().PlayEffectSingle('runeword1_fire_trail');
	ACS_Yrden_Sidearm_1().PlayEffectSingle('fast_attack_buff_hit');

	ACS_Yrden_Sidearm_2().PlayEffectSingle('fire_sparks_trail');
	ACS_Yrden_Sidearm_2().PlayEffectSingle('runeword1_fire_trail');
	ACS_Yrden_Sidearm_2().PlayEffectSingle('fast_attack_buff_hit');

	ACS_Yrden_Sidearm_3().PlayEffectSingle('fire_sparks_trail');
	ACS_Yrden_Sidearm_3().PlayEffectSingle('runeword1_fire_trail');
	ACS_Yrden_Sidearm_3().PlayEffectSingle('fast_attack_buff_hit');

	GetACSWatcher().RemoveTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer');

	GetACSWatcher().AddTimer('ACS_Yrden_Sidearm_Destroy_Actual_Timer', 0.125, false);
}

function ACS_Yrden_Sidearm_DestroyActual()
{
	ACS_Yrden_Sidearm_Anchor().BreakAttachment(); 
	ACS_Yrden_Sidearm_Anchor().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Yrden_Sidearm_Anchor().DestroyAfter(0.00125);

	ACS_Yrden_Sidearm_1().BreakAttachment(); 
	ACS_Yrden_Sidearm_1().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Yrden_Sidearm_1().DestroyAfter(0.00125);

	ACS_Yrden_Sidearm_2().BreakAttachment(); 
	ACS_Yrden_Sidearm_2().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Yrden_Sidearm_2().DestroyAfter(0.00125);

	ACS_Yrden_Sidearm_3().BreakAttachment(); 
	ACS_Yrden_Sidearm_3().Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -200 ) );
	ACS_Yrden_Sidearm_3().DestroyAfter(0.00125);

	GetWitcherPlayer().RemoveTag('ACS_Yrden_Sidearm_Summoned');
}

function ACS_Yrden_Sidearm_DestroyIMMEDIATE()
{
	ACS_Yrden_Sidearm_Anchor().BreakAttachment(); 
	ACS_Yrden_Sidearm_Anchor().Destroy();

	ACS_Yrden_Sidearm_1().BreakAttachment(); 
	ACS_Yrden_Sidearm_1().Destroy();

	ACS_Yrden_Sidearm_2().BreakAttachment(); 
	ACS_Yrden_Sidearm_2().Destroy();

	ACS_Yrden_Sidearm_3().BreakAttachment(); 
	ACS_Yrden_Sidearm_3().Destroy();

	GetWitcherPlayer().RemoveTag('ACS_Yrden_Sidearm_Summoned');
}

function ACS_Yrden_Sidearm_UpdateEnhancements()
{
	var steelID, silverID 						: SItemUniqueId;
	var enhancements 							: array<name>;
	var runeCount 								: int;

	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverID);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelID);

	enhancements.Clear();

	if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
	{
		GetWitcherPlayer().GetInventory().GetItemEnhancementItems( steelID, enhancements );

		runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( steelID );
	}
	else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
	{
		GetWitcherPlayer().GetInventory().GetItemEnhancementItems( silverID, enhancements );

		runeCount = GetWitcherPlayer().GetInventory().GetItemEnhancementCount( silverID );
	}

	if ( runeCount > 0 && ( ( runeCount - 1 ) < enhancements.Size() ) )
	{
		ACS_Yrden_Sidearm_1().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_1().StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_2().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_2().StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_3().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_3().StopEffect( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_1().PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_1().PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_2().PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_2().PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );

		ACS_Yrden_Sidearm_3().PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_3().PlayEffectSingle( ACS_GetRuneFxName( enhancements[ runeCount - 1 ] ) );
	}
	else if ( 3 == runeCount && 1 == enhancements.Size() )
	{
		ACS_Yrden_Sidearm_1().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_1().StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_2().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_2().StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_3().StopEffect( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_3().StopEffect( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_1().PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_1().PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_2().PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_2().PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );

		ACS_Yrden_Sidearm_3().PlayEffectSingle( ACS_GetRuneLevel( runeCount ) );
		ACS_Yrden_Sidearm_3().PlayEffectSingle( ACS_GetEnchantmentFxName( enhancements[ 0 ] ) );
	}

	ACS_Yrden_Sidearm_1().PlayEffectSingle('rune_blast_loop');

	ACS_Yrden_Sidearm_2().PlayEffectSingle('rune_blast_loop');

	ACS_Yrden_Sidearm_3().PlayEffectSingle('rune_blast_loop');
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Remove_Monster_Fear()
{
	var actors															: array<CActor>;
	var i																: int;
	var npc 															: CNewNPC;
	var actor 															: CActor;
	var targetDistance													: float;

	actors.Clear();
	
	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			targetDistance = VecDistanceSquared2D( npc.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

			if (!npc.HasAbility('IsNotScaredOfMonsters'))
			{
				npc.AddAbility('IsNotScaredOfMonsters');
			}

			if ( targetDistance <= 10 * 10 )
			{
				if 
				(
					!npc.HasAbility('EtherealActive') 
					&& npc.HasTag('ACS_Knightmare_Eternum')
				)
				{
					npc.SoundEvent("qu_209_two_sirens_sing_loop_stop");
					npc.SoundEvent("magic_olgierd_ethereal_wake");

					npc.PlayEffectSingle('demonic_possession');

					npc.PlayEffectSingle('ethereal_buff');
					npc.StopEffect('ethereal_buff');

					if (GetWeatherConditionName() != 'WT_Rain_Storm')
					{
						RequestWeatherChangeTo('WT_Rain_Storm', 1.0, false);
					}

					npc.AddAbility('EtherealActive');
				}
			}
		}
	}
	else
	{
		return;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Rage_Marker_Manager()
{
	if (ACS_can_spawn_rage_marker() 
	&& ACS_RageMechanic_Enabled())
	{
		ACS_refresh_rage_marker_cooldown();

		ACS_Rage_Markers_Destroy();

		ACS_Rage_Markers_Player_Destroy();

		Rage_Marker_Player();

		GetACSWatcher().RemoveTimer('ACS_Rage_Delay');

		GetACSWatcher().AddTimer('ACS_Rage_Delay', 1, false);
	}	
}

function Rage_Marker_Player()
{
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	var npcRot, rot, attach_rot                        					: EulerAngles;
	var npcPos, pos, attach_vec											: Vector;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;
	var actors															: array<CActor>;
	var i, num 															: int;
	var npc 															: CNewNPC;
	var actor 															: CActor;
	var markerTemplate 													: CEntityTemplate;

	if (
	GetWitcherPlayer().IsInCombat()
	)
	{
		actors.Clear();

		num = ACS_NumberOfEnragedEnemies();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( ACS_RageMechanicRadius(), num, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (
				npc.IsInCombat()
				&& !npc.HasTag('ACS_Forest_God')
				&& !npc.HasTag('ACS_taunted')
				&& !npc.HasTag('ACS_Forest_God_Shadows')
				&& !npc.HasTag('ACS_Tentacle_1')
				&& !npc.HasTag('ACS_Tentacle_2')
				&& !npc.HasTag('ACS_Tentacle_3')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_1') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_2') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_3') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_6')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_5')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_4')
				&& !npc.HasTag('acs_snow_entity') 
				&& !npc.HasTag('ACS_Nekker_Guardian')
				&& !npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				&& !npc.HasTag('ACS_Svalblod_Bossbar') 
				&& !npc.HasTag('ACS_Melusine_Bossbar') 
				&& !npc.HasTag('ACS_Rat_Mage_Rat')
				&& !npc.IsFlying()
				&& !npc.IsSwimming()
				&& !npc.IsUsingVehicle()
				&& !npc.IsUsingHorse()
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !npc.HasTag('ACS_Poise_Finisher')
				&& !npc.GetCharacterStats().HasAbilityWithTag('Boss')
				&& !npc.HasAbility( 'SkillBoss' )
				&& !npc.HasAbility( 'Boss' )
				&& !npc.HasAbility( 'MonsterMHBoss' )
				&& npc.GetNPCType() != ENGT_Guard
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Fists
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Undefined
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Crossbow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Bow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_None
				//&& npc.GetNPCType() != ENGT_Guard
				//&& !((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).IsLeavingStyle()
				//&& !npc.HasBuff(EET_Knockdown)
				//&& !npc.HasBuff(EET_Stagger)
				//&& !npc.HasBuff(EET_HeavyKnockdown)
				//&& !npc.HasBuff(EET_Ragdoll)
				//&& !npc.IsInHitAnim()
				)
				{
					if (npc.HasTag('ACS_Vampire_Monster')
					&& GetACSWatcher().ACS_Vampire_Monster_Flying_Process == true)
					{
						continue;
					}

					if (!ACS_Rage_Marker_Player_1_Get())
					{
						GetACSWatcher().Remove_On_Hit_Tags();

						markerTemplate = (CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\fx\wolf_decal.w2ent"
						
						, true );

						ent_1 = theGame.CreateEntity( markerTemplate, pos, rot );

						ent_1.AddTag('ACS_Rage_Marker_Player_1');

						attach_vec.X = 0;
						attach_vec.Y = 0;

						attach_vec.Z = 2.25;

						ent_1.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

						//ent_1.CreateAttachment( GetWitcherPlayer(), 'head', Vector(0,0,1), EulerAngles(0,0,0) );

						ent_1.PlayEffectSingle('marker');

						ent_1.PlayEffectSingle('rune');

						ent_1.DestroyAfter(1.5);

						if ( FactsQuerySum("ACS_Rage_Sound_Played") <= 0 )
						{
							GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
							GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
							GetWitcherPlayer().SoundEvent("sign_axii_ready");
							GetWitcherPlayer().SoundEvent("sign_axii_ready");

							FactsAdd("ACS_Rage_Sound_Played", 1, -1);
						}

						ACS_Rage_Tutorial();

						GetACSWatcher().SetRageProcess(true);
					}

					npc.RemoveTag('ACS_Pre_Rage');

					npc.RemoveTag('ACS_In_Rage');

					npc.AddTag('ACS_Pre_Rage');
				}
			}
		}

		/*
		ent_2 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_2.AddTag('ACS_Rage_Marker_Player_2');

		ent_2.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_2.PlayEffectSingle('marker');

		ent_2.DestroyAfter(3);


		ent_3 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_3.AddTag('ACS_Rage_Marker_Player_3');

		ent_3.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_3.PlayEffectSingle('marker');

		ent_3.DestroyAfter(3);

		ent_4 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_4.AddTag('ACS_Rage_Marker_Player_4');

		ent_4.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_4.PlayEffectSingle('marker');

		ent_4.DestroyAfter(4);

		ent_5 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_5.AddTag('ACS_Rage_Marker_Player_5');

		ent_5.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_5.PlayEffectSingle('marker');

		ent_5.DestroyAfter(4);


		ent_6 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_6.AddTag('ACS_Rage_Marker_Player_6');

		ent_6.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_6.PlayEffectSingle('marker');

		ent_6.DestroyAfter(4);


		ent_7 = theGame.CreateEntity( markerTemplate, pos, rot );

		ent_7.AddTag('ACS_Rage_Marker_Player_7');

		ent_7.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

		ent_7.PlayEffectSingle('marker');

		ent_7.DestroyAfter(4);
		*/
	}
}

function ACS_Rage_Marker()
{
	var vACS_Rage_Marker : cACS_Rage_Marker;
	vACS_Rage_Marker = new cACS_Rage_Marker in theGame;

	vACS_Rage_Marker.ACS_Rage_Marker_Engage();
}

statemachine class cACS_Rage_Marker
{
    function ACS_Rage_Marker_Engage()
	{
		this.PushState('ACS_Rage_Marker_Engage');
	}

	function ACS_Rage_Marker_Player_Engage()
	{
		this.PushState('ACS_Rage_Marker_Player_Engage');
	}
}

state ACS_Rage_Marker_Engage in cACS_Rage_Marker
{
	private var ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7, markerNPC, markerNPC_1     : CEntity;
	private var npcRot, rot, attach_rot                        								: EulerAngles;
	private var npcPos, pos, attach_vec														: Vector;
	private var meshcomp																	: CComponent;
	private var animcomp 																	: CAnimatedComponent;
	private var h 																			: float;
	private var actors																		: array<CActor>;
	private var i 																			: int;
	private var npc 																		: CNewNPC;
	private var actor 																		: CActor;
	private var markerTemplate_1, markerTemplate_2 											: CEntityTemplate;
	private var movementAdjustorNPC															: CMovementAdjustor;
	private var ticket 																		: SMovementAdjustmentRequestTicket;
	private var l_aiTree																	: CAIExecuteAttackAction;
	private var animatedComponentA 															: CAnimatedComponent;
	private var attackTypes																	: array<EAttackType>;
	
	event OnEnterState(prevStateName : name)
	{
		Rage_Marker_Entry();
	}
	
	entry function Rage_Marker_Entry()
	{
		Rage_Marker_Latent();
	}
	
	latent function Rage_Marker_Latent()
	{
		actors.Clear();
		
		//actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		theGame.GetActorsByTag( 'ACS_Pre_Rage', actors );

		if (actors.Size() <= 0)
		{
			return;
		}

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (
				npc.IsInCombat()
				&& !npc.HasTag('ACS_Forest_God')
				&& !npc.HasTag('ACS_taunted')
				&& !npc.HasTag('ACS_Forest_God_Shadows')
				&& !npc.HasTag('ACS_Tentacle_1')
				&& !npc.HasTag('ACS_Tentacle_2')
				&& !npc.HasTag('ACS_Tentacle_3')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_1') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_2') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_3') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_6')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_5')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_4')
				&& !npc.HasTag('acs_snow_entity') 
				&& !npc.HasTag('ACS_Nekker_Guardian')
				&& !npc.HasTag('ACS_Katakan')
				&& !npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				&& !npc.HasTag('ACS_Vampire_Monster') 
				&& !npc.HasTag('ACS_Svalblod_Bossbar') 
				&& !npc.HasTag('ACS_Melusine_Bossbar') 
				&& npc.GetNPCType() != ENGT_Guard
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !npc.HasTag('ACS_Poise_Finisher')
				&& !npc.HasTag('ACS_Rat_Mage_Rat')
				&& !npc.IsUsingVehicle()
				&& !npc.IsUsingHorse()
				//&& !npc.HasBuff(EET_Knockdown)
				//&& !npc.HasBuff(EET_Stagger)
				//&& !npc.HasBuff(EET_HeavyKnockdown)
				//&& !npc.HasBuff(EET_Ragdoll)
				//&& !npc.IsInHitAnim()
				)
				{
					GetACSWatcher().Remove_On_Hit_Tags();

					npcRot = npc.GetWorldRotation();

					npcPos = npc.GetWorldPosition();

					attach_vec.X = 0;
					attach_vec.Y = 0;

					if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() > 2.25
					|| npc.GetRadius() > 0.7
					)
					{
						attach_vec.Z = 4.25;
					}
					else
					{
						attach_vec.Z = 2.5;
					}

					markerTemplate_1 = (CEntityTemplate)LoadResource( 
						
						"dlc\dlc_acs\data\fx\wolf_decal.w2ent"
						
						, true );

					markerTemplate_2 = (CEntityTemplate)LoadResource( 
					
					"dlc\dlc_acs\data\fx\vulnerable_marker.w2ent"
					
					, true );


					ent_1 = theGame.CreateEntity( markerTemplate_1, pos, rot );

					ent_1.AddTag('ACS_Rage_Marker_1');

					ent_1.CreateAttachment( npc, , attach_vec, EulerAngles(0,0,0) );

					ent_1.PlayEffectSingle('rune_2');

					ent_1.PlayEffectSingle('ground_smoke');

					ent_1.DestroyAfter(2);


					ent_2 = theGame.CreateEntity( markerTemplate_2, pos, rot );

					ent_2.AddTag('ACS_Rage_Marker_2');

					ent_2.CreateAttachment( npc, , attach_vec, EulerAngles(0,0,0) );

					ent_2.DestroyAfter(2);


					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );

					if (
					!npc.HasAbility('ImlerithSecondStage')
					)
					{
						npc.SetAnimationSpeedMultiplier(1 + RandRangeF(0.5, 0.25));
					}

					movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

					npc.RemoveTag('ACS_Pre_Rage');
					npc.AddTag('ACS_In_Rage');

					npc.AddBuffImmunity_AllNegative('ACS_Rage', true); 

					npc.AddBuffImmunity_AllCritical('ACS_Rage', true);

					npc.SetCanPlayHitAnim(false); 

					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Rage_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Rage_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Rage_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 50000 );

					movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

					((CNewNPC)actor).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

					if (
					!npc.HasAbility('mon_wyvern_base') 
					&& !npc.HasAbility('mon_draco_base')
					)
					{
						l_aiTree = new CAIExecuteAttackAction in actor;
						l_aiTree.OnCreated();

						if (actor.HasAbility('mon_golem_base')
						|| actor.HasAbility('mon_werewolf_base')
						)
						{
							l_aiTree.attackParameter = EAT_Attack3;
						}
						else
						{
							attackTypes.Clear();

							attackTypes.PushBack(EAT_Attack1);
							//attackTypes.PushBack(EAT_Attack2);
							//attackTypes.PushBack(EAT_Attack3);

							l_aiTree.attackParameter = attackTypes[RandRange(attackTypes.Size())];
						}
						
						actor.ForceAIBehavior( l_aiTree, BTAP_AboveCombat2);

						theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( actor, 'AttackAction', 1.0, 1.0f, 999.0f, 1, true); 
					}

					((CNewNPC)actor).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

					GetACSWatcher().RemoveTimer('ACS_Rage_Remove');

					GetACSWatcher().AddTimer('ACS_Rage_Remove', 2, false);
				}
			}
		}
		else
		{
			GetACSWatcher().RemoveTimer('ACS_Rage_Remove');
			GetACSWatcher().AddTimer('ACS_Rage_Remove', 0, false);

			ACS_Rage_Markers_Destroy();

			ACS_Rage_Markers_Player_Destroy();
		}
	}
}

state ACS_Rage_Marker_Player_Engage in cACS_Rage_Marker
{
	private var ent, ent_1, ent_2, ent_3, ent_4, ent_5, ent_6, ent_7            : CEntity;
	private var npcRot, rot, attach_rot                        					: EulerAngles;
	private var npcPos, pos, attach_vec											: Vector;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var actors															: array<CActor>;
	private var i 																: int;
	private var npc 															: CNewNPC;
	private var actor 															: CActor;
	private var markerTemplate 													: CEntityTemplate;
	
	event OnEnterState(prevStateName : name)
	{
		Rage_Marker_Player_Entry();
	}
	
	entry function Rage_Marker_Player_Entry()
	{
		Rage_Marker_Player_Latent();
	}
	
	latent function Rage_Marker_Player_Latent()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				actor = actors[i];

				if (
				npc.IsInCombat()
				&& !npc.HasTag('ACS_Forest_God')
				&& !npc.HasTag('ACS_taunted')
				&& !npc.HasTag('ACS_Forest_God_Shadows')
				&& !npc.HasTag('ACS_Tentacle_1')
				&& !npc.HasTag('ACS_Tentacle_2')
				&& !npc.HasTag('ACS_Tentacle_3')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_1') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_2') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_3') 
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_6')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_5')
				&& !npc.HasTag('ACS_Necrofiend_Tentacle_4')
				&& !npc.HasTag('acs_snow_entity') 
				&& !npc.HasTag('ACS_Nekker_Guardian')
				&& !npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				&& !npc.HasTag('ACS_Svalblod_Bossbar') 
				&& !npc.HasTag('ACS_Melusine_Bossbar') 
				&& npc.GetNPCType() != ENGT_Guard
				&& !npc.HasTag('ACS_Final_Fear_Stack')
				&& !npc.HasTag('ACS_Poise_Finisher')
				&& !npc.HasTag('ACS_Rat_Mage_Rat')
				&& !npc.IsUsingVehicle()
				&& !npc.IsUsingHorse()
				)
				{
					attach_vec.X = 0;
					attach_vec.Y = 0;

					attach_vec.Z = 2.5;

					markerTemplate = (CEntityTemplate)LoadResource( 

						//"dlc\dlc_acs\data\fx\vulnerable_marker.w2ent"

						"dlc\dlc_acs\data\fx\wolf_decal.w2ent"
						
						, true );

					ACS_Rage_Markers_Destroy();

					ACS_Rage_Markers_Player_Destroy();

					ent_1 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_1.AddTag('ACS_Rage_Marker_Player_1');

					ent_1.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_1.PlayEffectSingle('marker');

					ent_1.PlayEffectSingle('glow');

					ent_1.DestroyAfter(3);

					GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
					GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
					GetWitcherPlayer().SoundEvent("magic_geralt_healing_oneshot");
					GetWitcherPlayer().SoundEvent("sign_axii_ready");
					GetWitcherPlayer().SoundEvent("sign_axii_ready");
					GetWitcherPlayer().SoundEvent("sign_axii_ready");

					ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\wolf_decal.w2ent", true ), pos, rot );

					ent_2.AddTag('ACS_Rage_Marker_Player_2');

					ent_2.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_2.PlayEffectSingle('glow');

					ent_2.DestroyAfter(3);

					/*
					ent_3 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_3.AddTag('ACS_Rage_Marker_Player_3');

					ent_3.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_3.PlayEffectSingle('marker');

					ent_3.DestroyAfter(3);

					ent_4 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_4.AddTag('ACS_Rage_Marker_Player_4');

					ent_4.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_4.PlayEffectSingle('marker');

					ent_4.DestroyAfter(4);

					ent_5 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_5.AddTag('ACS_Rage_Marker_Player_5');

					ent_5.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_5.PlayEffectSingle('marker');

					ent_5.DestroyAfter(4);


					ent_6 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_6.AddTag('ACS_Rage_Marker_Player_6');

					ent_6.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_6.PlayEffectSingle('marker');

					ent_6.DestroyAfter(4);


					ent_7 = theGame.CreateEntity( markerTemplate, pos, rot );

					ent_7.AddTag('ACS_Rage_Marker_Player_7');

					ent_7.CreateAttachment( GetWitcherPlayer(), , attach_vec, EulerAngles(0,0,0) );

					ent_7.PlayEffectSingle('marker');

					ent_7.DestroyAfter(4);
					*/
				}
			}
		}
	}
}

function ACS_Rage_Markers_Destroy()
{	
	var markers 										: array<CEntity>;
	var i												: int;
	
	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_1', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_2', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_3', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_4', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_5', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_6', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_7', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	if (FactsQuerySum("ACS_Rage_Sound_Played") > 0)
	{
		FactsRemove("ACS_Rage_Sound_Played");
	}
}

function ACS_Rage_Markers_Player_Destroy()
{	
	var markers 										: array<CEntity>;
	var i												: int;
	
	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_1', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_2', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_3', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_4', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_5', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_6', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	markers.Clear();

	theGame.GetEntitiesByTag( 'ACS_Rage_Marker_Player_7', markers );	
	
	for( i = 0; i < markers.Size(); i += 1 )
	{
		markers[i].Destroy();
	}

	if (FactsQuerySum("ACS_Rage_Sound_Played") > 0)
	{
		FactsRemove("ACS_Rage_Sound_Played");
	}
}

function ACS_Rage_Marker_1_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_1' );
	return marker;
}

function ACS_Rage_Marker_2_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_2' );
	return marker;
}

function ACS_Rage_Marker_3_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_3' );
	return marker;
}

function ACS_Rage_Marker_4_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_4' );
	return marker;
}

function ACS_Rage_Marker_5_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_5' );
	return marker;
}

function ACS_Rage_Marker_6_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_6' );
	return marker;
}

function ACS_Rage_Marker_7_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_7' );
	return marker;
}

function ACS_Rage_Marker_Player_1_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_1' );
	return marker;
}

function ACS_Rage_Marker_Player_2_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_2' );
	return marker;
}

function ACS_Rage_Marker_Player_3_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_3' );
	return marker;
}

function ACS_Rage_Marker_Player_4_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_4' );
	return marker;
}

function ACS_Rage_Marker_Player_5_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_5' );
	return marker;
}

function ACS_Rage_Marker_Player_6_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_6' );
	return marker;
}

function ACS_Rage_Marker_Player_7_Get() : CEntity
{
	var marker 			 : CEntity;
	
	marker = (CEntity)theGame.GetEntityByTag( 'ACS_Rage_Marker_Player_7' );
	return marker;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ACSShieldSpawner extends CEntity
{
	var actor															: CActor;
	var shield_temp														: CEntityTemplate;
	var shield															: CEntity;
	var ents  															: array<CGameplayEntity>;
	var i																: int;
	var progres, targetDistance 										: float;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('ShieldCheckTimer', 0.0000000000001, true);
	}
	
	timer function ShieldCheckTimer ( dt : float, id : int)
	{ 
		shieldcheck();
	}

	timer function DropShield ( dt : float, id : int)
	{ 
		if(this.GetWorldPosition() != ACSPlayerFixZAxis(this.GetWorldPosition()) )
		{
			this.Teleport( LerpV(this.GetWorldPosition(), ACSPlayerFixZAxis(this.GetWorldPosition()), progres) );
			progres += 0.00075/theGame.GetTimeScale();
		
			if(progres >= 1)
			{
				RemoveTimer( 'DropShield' );
			}
		}
	}

	function shieldcheck()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 10, ,FLAG_ExcludePlayer, ,);
		
		for( i = 0; i < ents.Size(); i += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[i];

				targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), actor.GetWorldPosition() ) ;

				if (actor.IsAlive()
				&& actor.HasTag('ACS_Swapped_To_Shield')
				&& !actor.HasTag('ACS_Shield_Attached'))
				{
					if (StrContains( actor.GetReadableName(), "novigrad" ) )
					{
						if( RandF() < 0.5 )
						{
							shield_temp = (CEntityTemplate)LoadResource( 

							"items\weapons\shields\novigrad_shield_01.w2ent"
							
							, true );
						}
						else
						{
							shield_temp = (CEntityTemplate)LoadResource( 

							"items\weapons\shields\novigrad_shield_02.w2ent"
							
							, true );
						}	
					}
					else if (StrContains( actor.GetReadableName(), "redania" ) 
					|| StrContains( actor.GetReadableName(), "witch_hunter" ) 
					|| StrContains( actor.GetReadableName(), "inq_" ) 
					)
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\redanian_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "nilfgaard" ) )
					{
						if( RandF() < 0.5 )
						{
							shield_temp = (CEntityTemplate)LoadResource( 

							"items\weapons\shields\nilfgaard_shield_01.w2ent"
							
							, true );
						}
						else
						{
							shield_temp = (CEntityTemplate)LoadResource( 

							"items\weapons\shields\nilfgaard_shield_02.w2ent"
							
							, true );
						}	
					}
					else if (StrContains( actor.GetReadableName(), "brokvar" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_brokvar_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "craite" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_craite_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "dimun" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_dimun_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "drummond" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_drummond_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "heymaey" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_heymaey_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "tuiseach" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\skellige_tuiseach_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "temeria" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\shields\temeria_shield_01.w2ent"
						
						, true );	
					}
					else if (StrContains( actor.GetReadableName(), "knight" ) )
					{
						if (StrContains( actor.GetReadableName(), "nilfgaard" ) )
						{
							if( RandF() < 0.5 )
							{
								shield_temp = (CEntityTemplate)LoadResource( 

								"items\weapons\shields\nilfgaard_shield_01.w2ent"
								
								, true );
							}
							else
							{
								shield_temp = (CEntityTemplate)LoadResource( 

								"items\weapons\shields\nilfgaard_shield_02.w2ent"
								
								, true );
							}	
						}
						else
						{
							if( RandF() < 0.5 )
							{
								if( RandF() < 0.5 )
								{
									shield_temp = (CEntityTemplate)LoadResource( 

									"dlc\bob\data\items\weapons\shields\toussaint_shield_01_5_toussaint.w2ent"
									
									, true );
								}
								else
								{
									shield_temp = (CEntityTemplate)LoadResource( 

									"dlc\bob\data\items\weapons\shields\toussaint_shield_02_6_toussaint.w2ent"
									
									, true );
								}
							}
							else
							{
								if( RandF() < 0.5 )
								{
									shield_temp = (CEntityTemplate)LoadResource( 

									"dlc\bob\data\items\weapons\shields\toussaint_shield_03_7_dun_tynne.w2ent"
									
									, true );
								}
								else
								{
									if( RandF() < 0.5 )
									{
										shield_temp = (CEntityTemplate)LoadResource( 

										"dlc\bob\data\items\weapons\shields\toussaint_shield_01_6_flat_color.w2ent"
										
										, true );
									}
									else
									{
										if( RandF() < 0.5 )
										{
											shield_temp = (CEntityTemplate)LoadResource( 

											"dlc\bob\data\items\weapons\shields\toussaint_shield_02_7_flat_color.w2ent"
											
											, true );
										}
										else
										{
											shield_temp = (CEntityTemplate)LoadResource( 

											"dlc\bob\data\items\weapons\shields\toussaint_shield_03_6_flat_color.w2ent"
											
											, true );
										}
									}
								}
							}
						}
					}
					else if (StrContains( actor.GetReadableName(), "wildhunt" ) )
					{
						shield_temp = (CEntityTemplate)LoadResource( 

						"items\weapons\unique\imlerith_shield\imlerith_shield_intact.w2ent"
						
						, true );
					}
					else 
					{
						if( RandF() < 0.5 )
						{
							if( RandF() < 0.5 )
							{
								shield_temp = (CEntityTemplate)LoadResource( 

								"items\weapons\shields\bandit_shield_01.w2ent"
								
								, true );
							}
							else
							{
								shield_temp = (CEntityTemplate)LoadResource( 

								"items\weapons\shields\bandit_shield_02.w2ent"
								
								, true );
							}	
						}
						else
						{
							if( RandF() < 0.5 )
							{
								shield_temp = (CEntityTemplate)LoadResource( 
						
								"items\weapons\shields\bandit_shield_03.w2ent"
								
								, true );
							}
							else
							{
								shield_temp = (CEntityTemplate)LoadResource( 
					
								"items\weapons\shields\bandit_shield_04.w2ent"
								
								, true );
							}
						}
					}
					
					shield = (CEntity)theGame.CreateEntity( shield_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

					//shield.CreateAttachment( actor, 'l_weapon', Vector(0,0,-0.5), EulerAngles(0,0,0) );

					shield.CreateAttachment( this, , Vector(0,0.0125,0), EulerAngles(0,0,0) );

					shield.PlayEffectSingle('aard_cone_hit');
					shield.PlayEffectSingle('igni_cone_hit');
					shield.PlayEffectSingle('heavy_block');
					shield.PlayEffectSingle('light_block');

					shield.DestroyAfter(300);

					actor.AddTag('ACS_Shield_Attached');
				}
				else if (
				( !actor.IsAlive() || ( !ACS_AttitudeCheck ( actor ) && targetDistance >= 30 * 30 ) )
				&& actor.HasTag('ACS_Shield_Attached')
				&& !actor.HasTag('ACS_Lost_Shield') )
				{
					actor.AddTag('ACS_Lost_Shield');

					actor.RemoveTag('ACS_Swapped_To_Shield');

					this.BreakAttachment();

					AddTimer( 'DropShield', 0.0001, true );

					this.DestroyAfter(3);

					RemoveTimer('ShieldCheckTimer');
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Human_Death_Controller
{
    function ACS_Human_Death_Controller_Engage()
	{
		this.PushState('ACS_Human_Death_Controller_Engage');
	}
}

state ACS_Human_Death_Controller_Engage in cACS_Human_Death_Controller
{
	var crawl_temp								: CEntityTemplate;
	var crawl_controller						: CEntity;
	var deathactors		    					: array<CActor>;
	var i										: int;
	var actor									: CActor;
	var npc										: CNewNPC;

	event OnEnterState(prevStateName : name)
	{
		Human_Death_Controller_Entry();
	}
	
	entry function Human_Death_Controller_Entry()
	{	
		Human_Death_Controller_Latent();
	}

	latent function Human_Death_Controller_Latent()
	{
		deathactors.Clear();

		deathactors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 50, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors + FLAG_Attitude_Hostile );

		if( deathactors.Size() > 0 )
		{
			for( i = 0; i < deathactors.Size(); i += 1 )
			{
				npc = (CNewNPC)deathactors[i];

				actor = deathactors[i];
				
				if(
				npc.IsHuman()
				&& !npc.HasTag('ACS_Rat_Mage')
				)
				{
					if (!npc.HasTag('ACS_Crawl_Controller_Attached'))
					{
						crawl_temp = (CEntityTemplate)LoadResourceAsync( 

						"dlc\dlc_acs\data\entities\other\human_death_crawl_controller.w2ent"
						
						, true );

						crawl_controller = (CEntity)theGame.CreateEntity( crawl_temp, npc.GetWorldPosition() + Vector( 0, 0, -20 ) );

						crawl_controller.CreateAttachment( npc, 'blood_point', Vector(0,0,0), EulerAngles(0,0,0) );

						npc.AddTag('ACS_Crawl_Controller_Attached');
					}
				}	
			}
		}
	}
}

class ACSHumanDeathCrawlController extends CEntity
{
	var actor															: CActor;
	var shield_temp														: CEntityTemplate;
	var shield															: CEntity;
	var ents  															: array<CGameplayEntity>;
	var i, j, k, l, m													: int;
	var dismembermentComp 												: CDismembermentComponent;
	var wounds															: array< name >;
	var usedWound														: name;
	var movementAdjustorNPCCrawl										: CMovementAdjustor;
	var ticketNPCCrawl													: SMovementAdjustmentRequestTicket;
	var animatedComponentA												: CAnimatedComponent;
	var soundComponentA													: CSoundEmitterComponent;
	var drawableComponents 												: array < CComponent >;
	var drawableComponent 												: CDrawableComponent;
	var temp 															: CR4Player;
	var finisher_anim_names												: array< name >;
	var finisher_anim_name_selected										: name;
	
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('AliveCheckTimer', 0.1, true);
	}
	
	timer function AliveCheckTimer ( dt : float, id : int)
	{ 
		AliveCheck();
	}

	timer function HumanDeathCrawlLoopFeetTimerDelay ( dt : float, id : int)
	{
		HumanDeathCrawlFeetCheck();

		AddTimer('HumanDeathCrawlLoopTimer', 1.15, true);
	}

	timer function HumanDeathCrawlLoopFinalFearTimerDelay ( dt : float, id : int)
	{
		HumanDeathCrawlFinalFearCheck();

		AddTimer('HumanDeathCrawlLoopTimer', 1.15, true);
	}

	timer function HumanDeathCrawlLoopNeckTimerDelay ( dt : float, id : int)
	{
		AddTimer('HumanDeathCrawlNeckCheckDelay', 0.5, false);

		AddTimer('HumanDeathCrawlLoopTimer', 1.15, true);
	}

	timer function HumanDeathCrawlLoopTimerDelay ( dt : float, id : int)
	{
		AddTimer('HumanDeathCrawlLoopTimer', 1.15, true);
	}

	timer function HumanDeathCrawlNeckCheckDelay ( dt : float, id : int)
	{ 
		HumanDeathCrawlFeetCheck();
	}

	timer function HumanDeathCrawlLoopTimer ( dt : float, id : int)
	{ 
		HumanDeathCrawlLoop();
	}

	timer function HumanDeathCrawlLoopTimerStop ( dt : float, id : int)
	{ 
		HumanDeathCrawlLoopStop();
	}

	timer function HumanDeathCrawlLoopTimerSelfDestruct ( dt : float, id : int)
	{ 
		HumanDeathCrawlLoopSelfDestruct();
	}

	function AliveCheck()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 1, ,FLAG_ExcludePlayer, ,);

		//FindGameplayEntitiesInRange(ents, this, 0.01, 1, ,FLAG_ExcludePlayer );
		
		for( i = 0; i < ents.Size(); i += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[i];

				if ( !actor.IsAlive() )
				{
					if (actor.IsHuman()
					&& actor.IsMan()
					&& !actor.HasTag('ACS_caretaker_shade') 
					&& !actor.HasTag('ACS_Lynx_Witcher')
					&& actor.GetImmortalityMode() != AIM_Invulnerable
					&& actor.GetImmortalityMode() != AIM_Immortal
					&& !actor.HasTag('acs_was_dismembered')
					&& ((CNewNPC)(actor)).GetNPCType() != ENGT_Guard
					&& !actor.UsesEssence()
					)
					{
						actor.SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Tpose );

						actor.SetAnimationSpeedMultiplier(1);

						animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

						movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

						GetACSWatcher().Fear_Stack();

						actor.StopEffect('demonic_possession');
						
						actor.DropItemFromSlot('r_weapon'); 

						if( RandF() < 0.25 ) 
						{
							actor.StopEffect('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
							actor.PlayEffectSingle('pee');
						}

						if( RandF() < 0.5 ) 
						{
							actor.StopEffect('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
							actor.PlayEffectSingle('puke');
						}

						actor.StopAllEffectsAfter(5);

						if( actor.HasTag('ACS_One_Hand_Swap_Stage_1') )
						{
							actor.RemoveTag('ACS_One_Hand_Swap_Stage_1');
						}

						if( actor.HasTag('ACS_One_Hand_Swap_Stage_2') )
						{
							actor.RemoveTag('ACS_One_Hand_Swap_Stage_2');
						}

						if( actor.HasTag('ACS_sword2h_npc') )
						{
							if( actor.HasTag('ACS_Swapped_To_Witcher') )
							{
								actor.RemoveTag('ACS_Swapped_To_Witcher');
							}

							if( actor.HasTag('ACS_Swapped_To_1h_Sword') )
							{
								actor.RemoveTag('ACS_Swapped_To_1h_Sword');
							}

							actor.RemoveTag('ACS_sword2h_npc');
						}
						else if( actor.HasTag('ACS_sword1h_npc') )
						{
							if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
							{
								actor.RemoveTag('ACS_Swapped_To_2h_Sword');
							}

							if( actor.HasTag('ACS_Swapped_To_Witcher') )
							{
								actor.RemoveTag('ACS_Swapped_To_Witcher');
							}

							actor.RemoveTag('ACS_sword1h_npc');
						}
						else if( actor.HasTag('ACS_shield_npc') )
						{
							if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
							{
								actor.RemoveTag('ACS_Swapped_To_2h_Sword');
							}

							if( actor.HasTag('ACS_Swapped_To_Witcher') )
							{
								actor.RemoveTag('ACS_Swapped_To_Witcher');
							}

							actor.RemoveTag('ACS_shield_npc');
						}
						else if( actor.HasTag('ACS_witcher_npc') )
						{
							if( actor.HasTag('ACS_Swapped_To_2h_Sword') )
							{
								actor.RemoveTag('ACS_Swapped_To_2h_Sword');
							}

							if( actor.HasTag('ACS_Swapped_To_1h_Sword') )
							{
								actor.RemoveTag('ACS_Swapped_To_1h_Sword');
							}

							actor.RemoveTag('ACS_witcher_npc');
						}

						if (GetWitcherPlayer().HasTag('vampire_claws_equipped')
						|| GetWitcherPlayer().HasTag('aard_sword_equipped')
						|| GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
						|| GetWitcherPlayer().HasTag('yrden_sword_equipped')
						|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
						|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped'))
						{
							if (RandF() < 0.5)
							{
								animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(0.5f, 0.25f), RandRangeF(0.5f, 0.25f)) );

								animatedComponentA.FreezePoseFadeIn(RandRangeF(2.f, 1.75f));
							}
							else
							{
								animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_killed_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(0.5f, 0.25f), RandRangeF(0.5f, 0.25f)) );

								animatedComponentA.FreezePoseFadeIn(RandRangeF(2.f, 1.75f));
							}

							AddTimer('HumanDeathCrawlLoopTimer', 1.15, true);
							AddTimer('HumanDeathCrawlLoopTimerStop', RandRangeF(30, 15), false);
							AddTimer('HumanDeathCrawlLoopTimerSelfDestruct', 31, false);

							RemoveTimer('AliveCheckTimer');

							actor.AddTag('acs_was_dismembered');

							actor.AddTag('ACS_Crawling_Disabled');

							actor.SoundEvent( "grunt_vo_death_stop", 'head' );

							ACS_Normal_Death_Explode(actor, actor.GetWorldPosition());

							return;
						}
						else
						{
							if (actor.HasTag('ACS_Final_Fear_Stack'))
							{
								if (RandF() < 0.5)
								{
									animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(0.5f, 0.25f), RandRangeF(0.5f, 0.25f)) );

									animatedComponentA.FreezePoseFadeIn(RandRangeF(2.f, 1.75f));
								}
								else
								{
									animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_killed_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(0.5f, 0.25f), RandRangeF(0.5f, 0.25f)) );

									animatedComponentA.FreezePoseFadeIn(RandRangeF(2.f, 1.75f));
								}

								AddTimer('HumanDeathCrawlLoopTimer', 1.15, true);
								AddTimer('HumanDeathCrawlLoopTimerStop', RandRangeF(30, 15), false);
								AddTimer('HumanDeathCrawlLoopTimerSelfDestruct', 31, false);

								RemoveTimer('AliveCheckTimer');

								actor.AddTag('acs_was_dismembered');

								actor.AddTag('ACS_Crawling_Disabled');

								actor.SoundEvent( "grunt_vo_death_stop", 'head' );

								return;
							}
							else
							{
								if (actor.HasTag('ACS_man_finisher_dlc_legs_lp')
								|| actor.HasTag('ACS_man_finisher_dlc_legs_rp')
								)
								{
									AddTimer('HumanDeathCrawlLoopFeetTimerDelay', 0.75, false);
								}
								else if (actor.HasTag('ACS_man_finisher_dlc_arm_rp')
								|| actor.HasTag('ACS_man_finisher_dlc_arm_lp')
								)
								{
									AddTimer('HumanDeathCrawlLoopFeetTimerDelay', 1, false);
								}
								else if (
								actor.HasTag('ACS_man_finisher_dlc_neck_rp')
								)
								{
									AddTimer('HumanDeathCrawlLoopNeckTimerDelay', 0.25, false);
								}
								else if (
								actor.HasTag('ACS_man_finisher_08_lp')
								|| actor.HasTag('ACS_man_finisher_dlc_head_rp')
								)
								{
									AddTimer('HumanDeathCrawlLoopNeckTimerDelay', 0.5, false);
								}
								else if (
								actor.HasTag('ACS_man_finisher_01_rp')
								|| actor.HasTag('ACS_man_finisher_02_lp')
								|| actor.HasTag('ACS_man_finisher_dlc_torso_rp')
								|| actor.HasTag('ACS_man_finisher_dlc_torso_lp')
								|| actor.HasTag('ACS_man_finisher_head')
								)
								{
									AddTimer('HumanDeathCrawlLoopTimerSelfDestruct', 1, false);
								}
								else if (
								actor.HasTag('ACS_man_ger_crawl_finish')
								|| actor.HasTag('ACS_man_trample')
								)
								{
									AddTimer('HumanDeathCrawlLoopFinalFearTimerDelay', 0.5f, false);
								}
								else
								{
									AddTimer('HumanDeathCrawlLoopTimerDelay', 0.85, false);
								}

								AddTimer('HumanDeathCrawlLoopTimerStop', RandRangeF(30, 15), false);
								AddTimer('HumanDeathCrawlLoopTimerSelfDestruct', 31, false);

								RemoveTimer('AliveCheckTimer');

								actor.AddTag('acs_was_dismembered');

								actor.SoundEvent( "grunt_vo_death_stop", 'head' );
							}
						}
					}
				}	
			}
		}
	}

	function HumanDeathCrawlFeetCheck()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 2, ,FLAG_ExcludePlayer, ,);
		
		for( m = 0; m < ents.Size(); m += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[m];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

				soundComponentA = (CSoundEmitterComponent)actor.GetComponentByClassName( 'CSoundEmitterComponent' );

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& !actor.HasTag('ACS_Crawling_Disable')
				)
				{
					actor.StopEffect('blood');
					actor.PlayEffectSingle('blood');

					actor.StopEffect('death_blood');
					actor.PlayEffectSingle('death_blood');

					actor.StopEffect('blood_spill');
					actor.PlayEffectSingle('blood_spill');  

					if (RandF() < 0.75)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
					}
				}
			}
		}
	}

	function HumanDeathCrawlFinalFearCheck()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 2, ,FLAG_ExcludePlayer, ,);
		
		for( m = 0; m < ents.Size(); m += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[m];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

				soundComponentA = (CSoundEmitterComponent)actor.GetComponentByClassName( 'CSoundEmitterComponent' );

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& !actor.HasTag('ACS_Crawling_Disable')
				)
				{
					actor.StopEffect('blood');
					actor.PlayEffectSingle('blood');

					actor.StopEffect('death_blood');
					actor.PlayEffectSingle('death_blood');

					actor.StopEffect('blood_spill');
					actor.PlayEffectSingle('blood_spill');  

					if (actor.HasTag('ACS_Scared_Standing'))
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f) );
					}
					else if (actor.HasTag('ACS_Scared_On_Ground'))
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_hit_knockdown_death', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f) );

						animatedComponentA.FreezePoseFadeIn(0.75f);

						AddTimer('HumanDeathCrawlLoopTimerSelfDestruct', 1, false);
					}
				}
			}
		}
	}

	function HumanDeathCrawlLoop()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 2, ,FLAG_ExcludePlayer, ,);
		
		for( j = 0; j < ents.Size(); j += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[j];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

				soundComponentA = (CSoundEmitterComponent)actor.GetComponentByClassName( 'CSoundEmitterComponent' );

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& actor != GetWitcherPlayer().GetFinisherVictim()
				&& !actor.HasTag('ACS_Crawling_Disable')
				&& !actor.HasTag('ACS_Scared_On_Ground')
				)
				{
					actor.StopEffect('blood');
					actor.PlayEffectSingle('blood');

					actor.StopEffect('death_blood');
					actor.PlayEffectSingle('death_blood');

					actor.StopEffect('blood_spill');
					actor.PlayEffectSingle('blood_spill');  

					actor.SetAnimationSpeedMultiplier(1);

					actor.SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Tpose );

					dismembermentComp = (CDismembermentComponent)(actor.GetComponentByClassName( 'CDismembermentComponent' ));

					if( StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "head" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "cut_head" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "doppler_trophy_head" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "none" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "torso" ) 
					|| StrContains( NameToString(dismembermentComp.GetVisibleWoundName()), "explode" ) 
					|| dismembermentComp.GetMainCurveName(dismembermentComp.GetVisibleWoundName()) == 'head'
					)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
	
						RemoveTimer('HumanDeathCrawlLoopTimerStop');
						RemoveTimer('HumanDeathCrawlLoopTimerSelfDestruct');
						AddTimer('HumanDeathCrawlLoopTimerStop', 1, false);
						AddTimer('HumanDeathCrawlLoopTimerSelfDestruct', 2, false);

						RemoveTimer('HumanDeathCrawlLoopTimer');
						return;
					}

					ticketNPCCrawl = movementAdjustorNPCCrawl.GetRequest( 'ACS_NPC_Crawl_Rotate');
					movementAdjustorNPCCrawl.CancelByName( 'ACS_NPC_Crawl_Rotate' );
					movementAdjustorNPCCrawl.CancelAll();

					ticketNPCCrawl = movementAdjustorNPCCrawl.CreateNewRequest( 'ACS_NPC_Crawl_Rotate' );
					movementAdjustorNPCCrawl.AdjustmentDuration( ticketNPCCrawl, RandRangeF(4, 2) );
					movementAdjustorNPCCrawl.MaxRotationAdjustmentSpeed( ticketNPCCrawl, 500000 );
					
					//actor.SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Death );
					
					if (RandF() < 0.5)
					{
						movementAdjustorNPCCrawl.RotateTo( ticketNPCCrawl, VecHeading( actor.GetHeadingVector() +  actor.GetWorldRight() * 10 ) );

						actor.PlayMimicAnimationAsync('geralt_neutral_gesture_death_longer_face');
					}
					else
					{
						movementAdjustorNPCCrawl.RotateTo( ticketNPCCrawl, VecHeading( actor.GetHeadingVector() +  actor.GetWorldRight() * -10 ) );

						actor.PlayMimicAnimationAsync('geralt_neutral_gesture_death_shorter_face');
					}

					if (RandF() < 0.75)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(1.f, 0.75f), RandRangeF(1.f, 0.75f)) );
					}
				}
			}
		}
	}

	function HumanDeathCrawlLoopStop()
	{
		var dismembermentComp 						: CDismembermentComponent;
		var wounds									: array< name >;
		var usedWound								: name;
		var movementAdjustorNPCCrawl				: CMovementAdjustor;
		var ticketNPCCrawl							: SMovementAdjustmentRequestTicket;

		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 2, ,FLAG_ExcludePlayer, ,);
		
		for( k = 0; k < ents.Size(); k += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[k];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& actor.HasTag('acs_was_dismembered')
				&& !actor.HasTag('ACS_Crawling_Disable')
				)
				{
					actor.StopEffect('blood');
					actor.PlayEffectSingle('blood');

					actor.StopEffect('death_blood');
					actor.PlayEffectSingle('death_blood');

					actor.StopEffect('blood_spill');
					actor.PlayEffectSingle('blood_spill'); 

					movementAdjustorNPCCrawl.CancelAll();

					if (RandF() < 0.5)
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_death', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(0.5f, 0.25f), RandRangeF(0.5f, 0.25f)) );

						animatedComponentA.FreezePoseFadeIn(RandRangeF(2.f, 1.75f));
					}
					else
					{
						animatedComponentA.PlaySlotAnimationAsync ( 'man_npc_sword_1hand_wounded_crawl_killed_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(RandRangeF(0.5f, 0.25f), RandRangeF(0.5f, 0.25f)) );

						animatedComponentA.FreezePoseFadeIn(RandRangeF(2.f, 1.75f));
					}
						
					actor.AddTag('ACS_Crawling_Disable');

					actor.StopAllEffectsAfter(1);
				}
			}
		}
	}

	function HumanDeathCrawlLoopSelfDestruct()
	{
		var dismembermentComp 						: CDismembermentComponent;
		var wounds									: array< name >;
		var usedWound								: name;
		var movementAdjustorNPCCrawl				: CMovementAdjustor;
		var ticketNPCCrawl							: SMovementAdjustmentRequestTicket;

		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 5, ,FLAG_ExcludePlayer, ,);
		
		for( l = 0; l < ents.Size(); l += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[l];

				animatedComponentA = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );

				movementAdjustorNPCCrawl = actor.GetMovingAgentComponent().GetMovementAdjustor();

				if (!actor.IsAlive()
				&& actor.IsHuman()
				&& actor.HasTag('acs_was_dismembered')
				&& actor.HasTag('ACS_Crawling_Disable')
				)
				{
					actor.TurnOnRagdoll();

					//actor.SetAnimationSpeedMultiplier(0);

					actor.SetBehaviorMimicVariable( 'gameplayMimicsMode', (float)(int)GMM_Tpose );

					this.DestroyAfter(10);
				}
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Ciri_Special_Attack extends CEntity
{
    function ACS_Ciri_Special_Attack_Engage()
	{
		GotoState('ACS_Ciri_Special_Attack_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Attack_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Attack_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Dodge_Front_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Dodge_Front_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Dodge_Back_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Dodge_Back_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Dodge_Left_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Dodge_Left_Engage', true, true);
	}

	function ACS_Ciri_Spectre_Dodge_Right_Engage()
	{
		GotoState('ACS_Ciri_Spectre_Dodge_Right_Engage', true, true);
	}
}

function ACSCiriSpecialSphere() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Ciri_Special_Attack_Sphere' );
	return entity;
}

state ACS_Ciri_Special_Attack_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp, specialAttackEffectTemplate									: CEntityTemplate;
	private var dummy_ent, specialAttackSphereEnt										: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;
	private var specialAttackSphere 													: CMeshComponent;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Special_Attack_Entry();
	}
	
	entry function Ciri_Special_Attack_Entry()
	{
		ACS_Ciri_Special_Attack_Sphere_Destroy();

		specialAttackEffectTemplate = (CEntityTemplate)LoadResourceAsync('special_attack_ciri');

		specialAttackSphereEnt = theGame.CreateEntity( specialAttackEffectTemplate, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		specialAttackSphereEnt.AddTag('ACS_Ciri_Special_Attack_Sphere');

		GetACSWatcher().ResetCiriSpecialSphereSize();

		GetACSWatcher().RemoveTimer('GrowCiriSpecialSphereTimer');

		GetACSWatcher().AddTimer('GrowCiriSpecialSphereTimer', 0.001, true);

		actorVictims.Clear();
		
		actorVictims = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors + FLAG_Attitude_Hostile );

		if( actorVictims.Size() > 0 )
		{
			GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

			last_enemy = false;

			GetWitcherPlayer().EnableCharacterCollisions(false);
			GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
			GetWitcherPlayer().SetCanPlayHitAnim(false);
			GetWitcherPlayer().AddBuffImmunity_AllNegative('acs_ciri_special', true);

			GetWitcherPlayer().ClearAnimationSpeedMultipliers();

			GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

			GetWitcherPlayer().SetAnimationSpeedMultiplier( 4 );

			GetWitcherPlayer().BlockAction( EIAB_Crossbow, 			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_CallHorse,			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Signs, 				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_DrawWeapon, 		'acs_ciri_special_attack'); 
			GetWitcherPlayer().BlockAction( EIAB_FastTravel, 		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Fists, 				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_InteractionAction, 	'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_UsableItem,			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_ThrowBomb,			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_SwordAttack,		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Jump,				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_LightAttacks,		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_HeavyAttacks,		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_SpecialAttackLight,	'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_SpecialAttackHeavy,	'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Dodge,				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Roll,				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Parry,				'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_MeditationWaiting,	'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_OpenMeditation,		'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_RadialMenu,			'acs_ciri_special_attack');
			GetWitcherPlayer().BlockAction( EIAB_Interactions, 		'acs_ciri_special_attack');

			GetWitcherPlayer().AddTag('ACS_In_Ciri_Special_Attack');

			theGame.SetTimeScale( 0.25, theGame.GetTimescaleSource( ETS_ThrowingAim ), theGame.GetTimescalePriority( ETS_ThrowingAim ), false, true );

			for( j = 0; j < actorVictims.Size(); j += 1 )
			{
				if ( j == actorVictims.Size() - 1 )
				{
					last_enemy = true;
				}

				if (actorVictims[j] && actorVictims[j].IsAlive())
				{
					//GetWitcherPlayer().StopEffect('disappear_ciri');
					//GetWitcherPlayer().PlayEffectSingle('disappear_ciri');

					GetWitcherPlayer().StopEffect('dodge_ciri_trail');
					GetWitcherPlayer().PlayEffectSingle('dodge_ciri_trail');

					GetWitcherPlayer().DestroyEffect('teleport_glow_ciri');
					GetWitcherPlayer().PlayEffectSingle('teleport_glow_ciri');

					movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

					dist = (((CMovingPhysicalAgentComponent)actorVictims[j].GetMovingAgentComponent()).GetCapsuleRadius() 
					+ ((CMovingPhysicalAgentComponent)GetWitcherPlayer().GetMovingAgentComponent()).GetCapsuleRadius()) * 2;

					ticket = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack');
					movementAdjustor.CancelByName( 'ACS_Ciri_Speical_Attack' );
					movementAdjustor.CancelAll();

					ticket = movementAdjustor.CreateNewRequest( 'ACS_Ciri_Speical_Attack' );
					movementAdjustor.AdjustmentDuration( ticket, 0.125 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

					victimPos = actorVictims[j].PredictWorldPosition(0.35f) + VecFromHeading( AngleNormalize180( GetWitcherPlayer().GetHeading() - dist ) ) * 2;

					if( !theGame.GetWorld().NavigationFindSafeSpot( victimPos, 0.3, 0.3 , newVictimPos ) )
					{
						theGame.GetWorld().NavigationFindSafeSpot( victimPos, 0.3, 4 , newVictimPos );
						victimPos = newVictimPos;
					}

					movementAdjustor.RotateTowards(ticket, actorVictims[j]);

					if ( ((CNewNPC)actorVictims[j]).IsShielded( NULL )
					|| actorVictims[j].IsGuarded()
					)
					{
						movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(victimPos) );
					}
					else
					{
						movementAdjustor.SlideTowards( ticket, actorVictims[j], dist, dist );
					}

					attack_anim_names.Clear();
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_left_2_lp_50ms_mod_ACS');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_right_2_rp_50ms_mod_ACS');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_left_1_lp_50ms_mod_ACS');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_right_1_rp_50ms_mod_ACS');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_left_2_rp_50ms_mod_ACS');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_right_2_lp_50ms_mod_ACS');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_left_1_rp_50ms_mod_ACS');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_right_1_lp_50ms_mod_ACS');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_forward_1_lp_50ms');
					attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_forward_1_rp_50ms');

					GetACSWatcher().PlayerPlayAnimation( attack_anim_names[RandRange(attack_anim_names.Size())] );

					GetWitcherPlayer().ClearAnimationSpeedMultipliers();

					GetACSWatcher().RemoveTimer('ACS_ResetAnimation');

					GetWitcherPlayer().SetAnimationSpeedMultiplier( 4 );

					GetWitcherPlayer().EnableCharacterCollisions(false);
					GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Combat );
					GetWitcherPlayer().SetCanPlayHitAnim(false);
					GetWitcherPlayer().AddBuffImmunity_AllNegative('acs_ciri_special', true);

					spawn_ciri_phantom(actorVictims[j]);

					Sleep( 0.25 );
				}
			}

			if ( last_enemy == true ) 
			{
				GetWitcherPlayer().DestroyEffect('teleport_glow_ciri');

				GetWitcherPlayer().StopEffect('dodge_ciri_trail');

				GetWitcherPlayer().RemoveTag('ACS_In_Ciri_Special_Attack');

				theGame.RemoveTimeScale( theGame.GetTimescaleSource(ETS_ThrowingAim) );

				if( GetWitcherPlayer().IsAlive()) {GetWitcherPlayer().ClearAnimationSpeedMultipliers();}

				GetWitcherPlayer().EnableCharacterCollisions(true);
				GetWitcherPlayer().SetImmortalityMode( AIM_None, AIC_Combat );
				GetWitcherPlayer().SetCanPlayHitAnim(true);
				GetWitcherPlayer().RemoveBuffImmunity_AllNegative('acs_ciri_special');

				GetWitcherPlayer().UnblockAction( EIAB_Crossbow, 			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_CallHorse,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Signs, 				'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_DrawWeapon, 			'acs_ciri_special_attack'); 
				GetWitcherPlayer().UnblockAction( EIAB_FastTravel, 			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Fists, 				'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_InteractionAction, 	'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_UsableItem,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_ThrowBomb,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_SwordAttack,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Jump,					'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_LightAttacks,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_HeavyAttacks,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_SpecialAttackLight,	'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_SpecialAttackHeavy,	'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Dodge,				'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Roll,					'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Parry,				'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_MeditationWaiting,	'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_OpenMeditation,		'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_RadialMenu,			'acs_ciri_special_attack');
				GetWitcherPlayer().UnblockAction( EIAB_Interactions, 		'acs_ciri_special_attack');

				GetWitcherPlayer().DestroyEffect('dodge_ciri');
				GetWitcherPlayer().PlayEffectSingle('dodge_ciri');

				GetWitcherPlayer().PlayEffectSingle('teleport_glow_ciri');

				movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

				ticket = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack');
				movementAdjustor.CancelByName( 'ACS_Ciri_Speical_Attack' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Ciri_Speical_Attack' );
				movementAdjustor.AdjustmentDuration( ticket, 0.125 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

				movementAdjustor.SlideTo( ticket, ACSPlayerFixZAxis(specialAttackSphereEnt.GetWorldPosition()) );

				if (GetWitcherPlayer().IsInCombat() && GetWitcherPlayer().GetTarget())
				{
					movementAdjustor.RotateTowards( ticket, GetWitcherPlayer().GetTarget() );
				}
				else
				{
					movementAdjustor.RotateTo( ticket, VecHeading( theCamera.GetCameraDirection() ) );
				}

				GetACSWatcher().PlayerPlayAnimation ( 'man_mage_teleport_in_ACS');

				specialAttackSphereEnt.PlayEffectSingle('fade');
				specialAttackSphereEnt.DestroyAfter(1);
			}
		}
		else
		{
			attack_anim_names.Clear();

			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_left_2_lp_50ms_mod_ACS');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_right_2_rp_50ms_mod_ACS');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_left_1_lp_50ms_mod_ACS');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_right_1_rp_50ms_mod_ACS');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_left_2_rp_50ms_mod_ACS');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_right_2_lp_50ms_mod_ACS');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_left_1_rp_50ms_mod_ACS');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_right_1_lp_50ms_mod_ACS');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_forward_1_lp_50ms');
			attack_anim_names.PushBack('man_geralt_sword_attack_fast_far_forward_1_rp_50ms');

			GetACSWatcher().PlayerPlayAnimation( attack_anim_names[RandRange(attack_anim_names.Size())] );

			GetACSWatcher().RemoveTimer('GrowCiriSpecialSphereTimer');

			GetACSWatcher().ResetCiriSpecialSphereSize();

			specialAttackSphereEnt.PlayEffectSingle('fade');
			specialAttackSphereEnt.DestroyAfter(1);
		}
	}

	latent function spawn_ciri_phantom( victim : CActor )
	{
		actorPos = victim.PredictWorldPosition(0.35f);

		actorRot = victim.GetWorldRotation();

		actorRot.Yaw += RandRange(180,0);

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_count = RandRange(3,1);

		for( k = 0; k < dummy_count; k += 1 )
		{
			randRange = 1.125 + 1.125 * RandF();
			randAngle = 1.125 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
			spawnPos.Z = actorPos.Z;
			
			dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(spawnPos), actorRot );
			animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
			h = 1;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
			((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
			((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
			((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
			((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

			((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

			dummy_ent.PlayEffectSingle('dodge');

			dummy_ent.PlayEffectSingle('fury');

			dummy_ent.PlayEffectSingle('fury_403');
		
			dummy_ent.PlayEffectSingle('teleport_glow');

			dummy_ent.PlayEffectSingle('appear');
			
			dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

			movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

			ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
			movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
			movementAdjustorDummy.CancelAll();

			ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
			movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
			movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

			movementAdjustorDummy.RotateTowards( ticketDummy, victim);
			movementAdjustorDummy.SlideTowards( ticketDummy, victim, dist, dist );

			ciri_attack_anim_names.Clear();

			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_forward_1_rp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_1_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_2_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_3_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_4_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_5_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_back_1_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_left_1_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_right_1_rp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_back_1_rp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_left_1_rp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_right_1_rp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_1_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_2_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_3_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_4_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_back_1_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_left_1_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_right_1_lp_40ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_forward_1_lp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_back_1_lp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_left_1_lp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_right_1_lp_50ms');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_special_heavy_attack_short_rp');
			ciri_attack_anim_names.PushBack('woman_ciri_sword_special_heavy_attack_short_lp');

			animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

			dummy_ent.DestroyAfter(0.75);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_Ciri_Spectre_Attack_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims, actors													: array<CActor>;
	private var actortarget																: CActor;
	private var i, j, k, dummy_count 													: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Attack_Entry();
	}
	
	entry function Ciri_Spectre_Attack_Entry()
	{
		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_blink_attack_start_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_blink_attack_start_rp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);

		/*

		Sleep(0.5);

		GetWitcherPlayer().PlayEffectSingle('dodge_ciri');
		GetWitcherPlayer().DestroyEffect('dodge_ciri');

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_forward_1_rp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_forward_1_lp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_heavy_attack_short_rp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_heavy_attack_short_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_1_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_2_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_3_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_4_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_5_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_1_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_2_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_3_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_4_lp_40ms');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);

		Sleep(0.125);

		GetWitcherPlayer().PlayEffectSingle('dodge_ciri');
		GetWitcherPlayer().DestroyEffect('dodge_ciri');

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_left_1_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_left_1_rp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_left_1_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_left_1_lp_50ms');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);

		Sleep(0.125);

		GetWitcherPlayer().PlayEffectSingle('dodge_ciri');
		GetWitcherPlayer().DestroyEffect('dodge_ciri');

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_back_1_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_back_1_rp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_back_1_lp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_back_1_lp_40ms');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);

		Sleep(0.125);

		GetWitcherPlayer().PlayEffectSingle('dodge_ciri');
		GetWitcherPlayer().DestroyEffect('dodge_ciri');

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		movementAdjustorDummy = ((CActor)dummy_ent).GetMovingAgentComponent().GetMovementAdjustor();

		ticketDummy = movementAdjustor.GetRequest( 'ACS_Ciri_Speical_Attack_Dummy');
		movementAdjustorDummy.CancelByName( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.CancelAll();

		ticketDummy = movementAdjustorDummy.CreateNewRequest( 'ACS_Ciri_Speical_Attack_Dummy' );
		movementAdjustorDummy.AdjustmentDuration( ticket, 0.125 );
		movementAdjustorDummy.MaxRotationAdjustmentSpeed( ticketDummy, 500000 );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_right_1_rp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_right_1_rp_50ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_right_1_lp_40ms');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_attack_fast_far_right_1_lp_50ms');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
		
		*/
	}
}

state ACS_Ciri_Spectre_Dodge_Front_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Dodge_Front_Entry();
	}
	
	entry function Ciri_Spectre_Dodge_Front_Entry()
	{
		//Sleep(0.25);

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_attack_end_disappear_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_attack_end_disappear_rp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
	}
}

state ACS_Ciri_Spectre_Dodge_Back_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Dodge_Back_Entry();
	}
	
	entry function Ciri_Spectre_Dodge_Back_Entry()
	{
		//Sleep(0.25);

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_special_blink_attack_disappear');
		//ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_back_lp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
	}
}

state ACS_Ciri_Spectre_Dodge_Left_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Dodge_Left_Entry();
	}
	
	entry function Ciri_Spectre_Dodge_Left_Entry()
	{
		actorRot = GetWitcherPlayer().GetWorldRotation();

		actorRot.Yaw -= 45;

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), actorRot );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_left_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_left_rp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
	}
}

state ACS_Ciri_Spectre_Dodge_Right_Engage in cACS_Ciri_Special_Attack
{
	private var actorVictims															: array<CActor>;
	private var j, k, dummy_count 														: int;
	private var movementAdjustor, movementAdjustorDummy									: CMovementAdjustor;
	private var ticket, ticketDummy														: SMovementAdjustmentRequestTicket;
	private var dist																	: float;
	private var attack_anim_names, ciri_attack_anim_names								: array< name >;
	private var victimPos, newVictimPos													: Vector;
	private var last_enemy																: bool;
	private var dummy_temp																: CEntityTemplate;
	private var dummy_ent																: CEntity;
	private var actorPos, spawnPos														: Vector;
	private var randAngle, randRange													: float;
	private var meshcomp																: CComponent;
	private var animcomp 																: CAnimatedComponent;
	private var h 																		: float;
	private var actorRot																: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		this.Ciri_Spectre_Dodge_Right_Entry();
	}
	
	entry function Ciri_Spectre_Dodge_Right_Entry()
	{
		actorRot = GetWitcherPlayer().GetWorldRotation();

		actorRot.Yaw += 45;

		dummy_temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\other\ciri_phantom_fx.w2ent"
			
		, true );

		dummy_ent = theGame.CreateEntity( dummy_temp, ACSPlayerFixZAxis(GetWitcherPlayer().GetWorldPosition() ), actorRot );
		animcomp = (CAnimatedComponent)dummy_ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = dummy_ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	
		
		((CNewNPC)dummy_ent).SetLevel(GetWitcherPlayer().GetLevel());
		((CNewNPC)dummy_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
		((CNewNPC)dummy_ent).SetTemporaryAttitudeGroup('q104_avallach_friendly_to_all', AGP_Default);
		((CNewNPC)dummy_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CNewNPC)dummy_ent).EnableCharacterCollisions(false);

		((CActor)dummy_ent).SetAnimationSpeedMultiplier(5);

		dummy_ent.PlayEffectSingle('dodge');

		dummy_ent.PlayEffectSingle('fury');

		dummy_ent.PlayEffectSingle('fury_403');
	
		dummy_ent.PlayEffectSingle('teleport_glow');

		dummy_ent.PlayEffectSingle('appear');
		
		dummy_ent.AddTag( 'ACS_Ciri_Special_Dummy' );

		ciri_attack_anim_names.Clear();

		ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_right_lp');
		ciri_attack_anim_names.PushBack('woman_ciri_sword_dodge_start_right_rp');

		animcomp.PlaySlotAnimationAsync ( ciri_attack_anim_names[RandRange(ciri_attack_anim_names.Size())], 'GAMEPLAY_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));

		dummy_ent.DestroyAfter(0.75);
	}
}

function ACS_Ciri_Special_Attack_Sphere_Destroy()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Ciri_Special_Attack_Sphere', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Spawn_Transformation_Werewolf
{
    function Spawn_Transformation_Werewolf_Engage()
	{
		this.PushState('Spawn_Transformation_Werewolf_Engage');
	}
}

state Spawn_Transformation_Werewolf_Engage in cACS_Spawn_Transformation_Werewolf
{
	private var actor															: CActor;
	private var ent																: CEntity;
	private var temp															: CEntityTemplate;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var p_comp															: CComponent;
	private var apptemp															: CEntityTemplate;

	var cameraTemplate															: CEntityTemplate;
	var cameraEnt																: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		GetACSTransformationWerewolf().Destroy();
		Spawn_Transformation_Werewolf_Entry();
	}
	
	entry function Spawn_Transformation_Werewolf_Entry()
	{
		Spawn_Transformation_Werewolf_Latent();
	}
	
	latent function Spawn_Transformation_Werewolf_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\transformation_entities\acs_werewolf.w2ent"
			
		, true );

		ent = theGame.CreateEntity( temp, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		//p_comp = ent.GetComponentByClassName( 'CAppearanceComponent' );

		//apptemp = (CEntityTemplate)LoadResourceAsync(

		//"dlc\dlc_acs\data\models\transformation_werewolf\t_03__werewolf.w2ent"
			
		//, true);
		
		//((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(apptemp);

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1.1875;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());

		((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Transformation_Werewolf_Immunity_Negative', true); 
		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Transformation_Werewolf_Immunity_Critical', true); 

		ent.AddTag('ACS_Transformation_Werewolf');

		ent.PlayEffectSingle('sonar');
		ent.StopEffect('sonar');

		ent.PlayEffectSingle('blood');
		ent.StopEffect('blood');

		ent.PlayEffectSingle('morph_fx');
		ent.StopEffect('morph_fx');

		//ent.PlayEffectSingle('shadow_disappear');
		//ent.StopEffect('shadow_disappear');

		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('him_smoke_red');
		ent.PlayEffectSingle('him_smoke_red');

		ent.PlayEffectSingle('him_smoke_swirl');
		ent.StopEffect('him_smoke_swirl');

		//ent.PlayEffectSingle('smash_ground');
		//ent.StopEffect('smash_ground');

		ent.PlayEffectSingle('attack_special');
		ent.StopEffect('attack_special');

		GetACSWatcher().ACSTransformWerewolfPlayAnim('monster_werewolf_taunt_02', 1, 1);

		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		GetWitcherPlayer().SoundEvent("animals_wolf_howl");
		
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");
		GetWitcherPlayer().SoundEvent("monster_wild_dog_howl");

		GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");
		GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt1");

		GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
		GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");
		//GetWitcherPlayer().SoundEvent("monster_werewolf_vo_taunt2");



		GetACSWatcher().CamerasDestroy();

		cameraTemplate = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\transformation_camera.w2ent", true);

		cameraEnt = (CStaticCamera)theGame.CreateEntity(cameraTemplate, theCamera.GetCameraPosition(), theCamera.GetCameraRotation());	

		cameraEnt.AddTag('ACS_Transformation_Custom_Camera');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSTransformationWerewolf() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Transformation_Werewolf' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Spawn_Transformation_Red_Miasmal
{
    function Spawn_Transformation_Red_Miasmal_Engage()
	{
		this.PushState('Spawn_Transformation_Red_Miasmal_Engage');
	}

	function ACS_RedMiasmalBehSwitch_Engage()
	{
		this.PushState('ACS_RedMiasmalBehSwitch_Engage');
	}
}

state Spawn_Transformation_Red_Miasmal_Engage in cACS_Spawn_Transformation_Red_Miasmal
{
	private var actor															: CActor;
	private var ent																: CEntity;
	private var temp															: CEntityTemplate;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var p_comp															: CComponent;
	private var apptemp															: CEntityTemplate;

	var cameraTemplate															: CEntityTemplate;
	var cameraEnt																: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		GetACSTransformationRedMiasmal().Destroy();
		Spawn_Transformation_Red_Miasmal_Entry();
	}
	
	entry function Spawn_Transformation_Red_Miasmal_Entry()
	{
		Spawn_Transformation_Red_Miasmal_Latent();
	}
	
	latent function Spawn_Transformation_Red_Miasmal_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\transformation_entities\acs_red_miasmal.w2ent"
			
		, true );

		ent = theGame.CreateEntity( temp, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 0.875;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());

		((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Transformation_Red_Miasmal_Immunity_Negative', true); 
		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Transformation_Red_Miasmal_Immunity_Critical', true); 

		ent.AddTag('ACS_Transformation_Red_Miasmal');

		GetACSTransformationRedMiasmal().PlayEffectSingle('evil_appear');
		GetACSTransformationRedMiasmal().StopEffect('evil_appear');

		GetACSTransformationRedMiasmal().PlayEffectSingle('appear');
		GetACSTransformationRedMiasmal().StopEffect('appear');

		GetACSWatcher().CamerasDestroy();

		cameraTemplate = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\transformation_camera.w2ent", true);

		cameraEnt = (CStaticCamera)theGame.CreateEntity(cameraTemplate, theCamera.GetCameraPosition(), theCamera.GetCameraRotation());	

		cameraEnt.AddTag('ACS_Transformation_Custom_Camera');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_RedMiasmalBehSwitch_Engage in cACS_Spawn_Transformation_Red_Miasmal
{
	var p_actor 					: CActor;
	var p_comp						: CComponent;
	var temp						: CEntityTemplate;
	var vampRot, adjustedRot 		: EulerAngles;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Beh_Switch_Entry();
	}
	
	entry function Beh_Switch_Entry()
	{	
		LockEntryFunction(true);
	
		Beh_Switch_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Beh_Switch_Latent()
	{
		p_actor = GetACSTransformationRedMiasmal();

		p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

		if (!GetACSTransformationRedMiasmal().HasTag('ACS_Red_Miasmal_Giant_Mode'))
		{
			if ( GetACSTransformationRedMiasmal().GetBehaviorGraphInstanceName() != 'Combat_Giant' )
			{
				GetACSTransformationRedMiasmal().ActivateAndSyncBehavior( 'Combat_Giant' );
			}

			GetACSTransformationRedMiasmal().AddTag('ACS_Red_Miasmal_Giant_Mode');
		}
		else
		{
			if ( GetACSTransformationRedMiasmal().GetBehaviorGraphInstanceName() != 'Exploration' )
			{
				GetACSTransformationRedMiasmal().ActivateAndSyncBehavior( 'Exploration' );
			}

			GetACSTransformationRedMiasmal().RemoveTag('ACS_Red_Miasmal_Giant_Mode');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSTransformationRedMiasmal() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Transformation_Red_Miasmal' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Transformation_Toad
{
    function Spawn_Transformation_Toad_Engage()
	{
		this.PushState('Spawn_Transformation_Toad_Engage');
	}

	function Transformation_Toad_Single_Projectile_Engage()
	{
		this.PushState('Transformation_Toad_Single_Projectile_Engage');
	}

	function Transformation_Toad_Mortar_Projectile1_Engage()
	{
		this.PushState('Transformation_Toad_Mortar_Projectile1_Engage');
	}

	function Transformation_Toad_Mortar_Projectile2_Engage()
	{
		this.PushState('Transformation_Toad_Mortar_Projectile2_Engage');
	}

	function Transformation_Toad_Mortar_Projectile3_Engage()
	{
		this.PushState('Transformation_Toad_Mortar_Projectile3_Engage');
	}

	function Transformation_Toad_Mortar_Projectile4_Engage()
	{
		this.PushState('Transformation_Toad_Mortar_Projectile4_Engage');
	}
}

state Spawn_Transformation_Toad_Engage in cACS_Transformation_Toad
{
	private var actor															: CActor;
	private var ent																: CEntity;
	private var temp															: CEntityTemplate;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var p_comp															: CComponent;
	private var apptemp															: CEntityTemplate;

	var cameraTemplate															: CEntityTemplate;
	var cameraEnt																: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		GetACSTransformationToad().Destroy();
		Spawn_Transformation_Toad_Entry();
	}
	
	entry function Spawn_Transformation_Toad_Entry()
	{
		Spawn_Transformation_Toad_Latent();
	}
	
	latent function Spawn_Transformation_Toad_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\transformation_entities\acs_toad.w2ent"
			
		, true );

		ent = theGame.CreateEntity( temp, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 0.75;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());

		//((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		//((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CActor)ent).SetTemporaryAttitudeGroup('player', AGP_Default);
		((CNewNPC)ent).SetTemporaryAttitudeGroup('player', AGP_Default);

		((CNewNPC)ent).SetCanPlayHitAnim(true);

		((CActor)ent).SetImmortalityMode( AIM_Immortal, AIC_Default, true );

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Transformation_Toad_Immunity_Negative', true); 
		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Transformation_Toad_Immunity_Critical', true); 

		ent.AddTag('ACS_Transformation_Toad');

		ent.PlayEffectSingle('jump');
		ent.StopEffect('jump');

		ent.PlayEffectSingle('screen_slime');
		ent.StopEffect('screen_slime');

		ent.PlayEffectSingle('landing');
		ent.StopEffect('landing');

		GetACSWatcher().ACSTransformToadPlayAnim('monster_toad_taunt_01', 0.5, 0.5);

		GetACSWatcher().CamerasDestroy();

		cameraTemplate = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\transformation_camera.w2ent", true);

		cameraEnt = (CStaticCamera)theGame.CreateEntity(cameraTemplate, theCamera.GetCameraPosition(), theCamera.GetCameraRotation());	

		cameraEnt.AddTag('ACS_Transformation_Custom_Camera');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Transformation_Toad_Single_Projectile_Engage in cACS_Transformation_Toad
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Transformation_Toad_Single_Projectile_Entry();
	}
	
	entry function Transformation_Toad_Single_Projectile_Entry()
	{	
		LockEntryFunction(true);
	
		Transformation_Toad_Single_Projectile_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Transformation_Toad_Single_Projectile_Latent()
	{
		var attackRange, attackAngle 				: float;
		var proj 								: CACSTransformationToadPoisonProjectile;
		var rotation 								: EulerAngles;
		var initpos, targetPosition, vampPos		: Vector;
		var actortarget								: CActor;
		var actors									: array<CActor>;
		var i 										: int;

		initpos = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 2;

		initpos.Z += 1.5;

		rotation = GetACSTransformationToad().GetWorldRotation();

		if (thePlayer.GetDisplayTarget())
		{
			targetPosition = ((CActor)(thePlayer.GetDisplayTarget())).GetWorldPosition();
		}
		else
		{
			targetPosition = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		proj = (CACSTransformationToadPoisonProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\toad_projectiles\toad_spawn_projectile.w2ent", true ), initpos, rotation );
		proj.Init(thePlayer);
		proj.PlayEffectSingle( 'spit_travel' );
		proj.ShootProjectileAtPosition( 0, 10 + RandRange(15,5), targetPosition, 500 );
		proj.DestroyAfter(10);
	}
}

state Transformation_Toad_Mortar_Projectile1_Engage in cACS_Transformation_Toad
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Transformation_Toad_Mortar_Projectile1_Entry();
	}
	
	entry function Transformation_Toad_Mortar_Projectile1_Entry()
	{	
		LockEntryFunction(true);
	
		Transformation_Toad_Mortar_Projectile1_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Transformation_Toad_Mortar_Projectile1_Latent()
	{
		var attackRange, attackAngle 				: float;
		var proj 									: CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile;
		var rotation, bone_rot 						: EulerAngles;
		var initpos, targetPosition, bone_vec		: Vector;
		var actortarget								: CActor;
		var actors									: array<CActor>;
		var i 										: int;

		//initpos = GetACSTransformationToad().GetBoneWorldPosition();

		GetACSTransformationToad().GetBoneWorldPositionAndRotationByIndex( GetACSTransformationToad().GetBoneIndex( 'r_torso_helper_04' ), bone_vec, bone_rot );

		initpos = bone_vec;

		initpos.Z += 0.5;

		rotation = GetACSTransformationToad().GetWorldRotation();

		if (thePlayer.GetDisplayTarget())
		{
			targetPosition = ((CActor)(thePlayer.GetDisplayTarget())).GetWorldPosition();
		}
		else
		{
			targetPosition = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		proj = (CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\toad_projectiles\toad_mortar_proj.w2ent", true ), initpos, rotation );
		proj.Init(thePlayer);
		proj.PlayEffectSingle( 'spit_travel' );
		//proj.ShootProjectileAtPosition( 0, 10 + RandRange(15,5), targetPosition, 500 );
		proj.ShootProjectileAtPosition( proj.projAngle, proj.projSpeed, FindPosition(), 500 );
		proj.DestroyAfter(10);
	}

	function FindPosition() : Vector
	{
		var randVec : Vector;
		var targetPos : Vector;
		var outPos : Vector;

		randVec = Vector( 0.f, 0.f, 0.f );

		if (thePlayer.GetDisplayTarget())
		{
			targetPos = (thePlayer.GetDisplayTarget()).GetWorldPosition();
		}
		else
		{
			targetPos = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		randVec = VecRingRand( 2, 6 );
		
		outPos = targetPos + randVec;

		return outPos;
	}
}

state Transformation_Toad_Mortar_Projectile2_Engage in cACS_Transformation_Toad
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Transformation_Toad_Mortar_Projectile2_Entry();
	}
	
	entry function Transformation_Toad_Mortar_Projectile2_Entry()
	{	
		LockEntryFunction(true);
	
		Transformation_Toad_Mortar_Projectile2_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Transformation_Toad_Mortar_Projectile2_Latent()
	{
		var attackRange, attackAngle 				: float;
		var proj 									: CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile;
		var rotation, bone_rot 						: EulerAngles;
		var initpos, targetPosition, bone_vec		: Vector;
		var actortarget								: CActor;
		var actors									: array<CActor>;
		var i 										: int;

		//initpos = GetACSTransformationToad().GetBoneWorldPosition();

		GetACSTransformationToad().GetBoneWorldPositionAndRotationByIndex( GetACSTransformationToad().GetBoneIndex( 'l_torso_helper_04' ), bone_vec, bone_rot );

		initpos = bone_vec;

		initpos.Z += 0.5;

		rotation = GetACSTransformationToad().GetWorldRotation();

		if (thePlayer.GetDisplayTarget())
		{
			targetPosition = ((CActor)(thePlayer.GetDisplayTarget())).GetWorldPosition();
		}
		else
		{
			targetPosition = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		proj = (CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\toad_projectiles\toad_mortar_proj.w2ent", true ), initpos, rotation );
		proj.Init(thePlayer);
		proj.PlayEffectSingle( 'spit_travel' );
		//proj.ShootProjectileAtPosition( 0, 10 + RandRange(15,5), targetPosition, 500 );
		proj.ShootProjectileAtPosition( proj.projAngle, proj.projSpeed, FindPosition(), 500 );
		proj.DestroyAfter(10);
	}

	function FindPosition() : Vector
	{
		var randVec : Vector;
		var targetPos : Vector;
		var outPos : Vector;

		randVec = Vector( 0.f, 0.f, 0.f );

		if (thePlayer.GetDisplayTarget())
		{
			targetPos = (thePlayer.GetDisplayTarget()).GetWorldPosition();
		}
		else
		{
			targetPos = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		randVec = VecRingRand( 2, 6 );
		
		outPos = targetPos + randVec;

		return outPos;
	}
}

state Transformation_Toad_Mortar_Projectile3_Engage in cACS_Transformation_Toad
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Transformation_Toad_Mortar_Projectile3_Entry();
	}
	
	entry function Transformation_Toad_Mortar_Projectile3_Entry()
	{	
		LockEntryFunction(true);
	
		Transformation_Toad_Mortar_Projectile3_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Transformation_Toad_Mortar_Projectile3_Latent()
	{
		var attackRange, attackAngle 				: float;
		var proj 									: CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile;
		var rotation, bone_rot 						: EulerAngles;
		var initpos, targetPosition, bone_vec		: Vector;
		var actortarget								: CActor;
		var actors									: array<CActor>;
		var i 										: int;

		//initpos = GetACSTransformationToad().GetBoneWorldPosition();

		GetACSTransformationToad().GetBoneWorldPositionAndRotationByIndex( GetACSTransformationToad().GetBoneIndex( 'r_torso_helper_05' ), bone_vec, bone_rot );

		initpos = bone_vec;

		initpos.Z += 0.5;

		rotation = GetACSTransformationToad().GetWorldRotation();

		if (thePlayer.GetDisplayTarget())
		{
			targetPosition = ((CActor)(thePlayer.GetDisplayTarget())).GetWorldPosition();
		}
		else
		{
			targetPosition = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		proj = (CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\toad_projectiles\toad_mortar_proj.w2ent", true ), initpos, rotation );
		proj.Init(thePlayer);
		proj.PlayEffectSingle( 'spit_travel' );
		//proj.ShootProjectileAtPosition( 0, 10 + RandRange(15,5), targetPosition, 500 );
		proj.ShootProjectileAtPosition( proj.projAngle, proj.projSpeed, FindPosition(), 500 );
		proj.DestroyAfter(10);
	}

	function FindPosition() : Vector
	{
		var randVec : Vector;
		var targetPos : Vector;
		var outPos : Vector;

		randVec = Vector( 0.f, 0.f, 0.f );

		if (thePlayer.GetDisplayTarget())
		{
			targetPos = (thePlayer.GetDisplayTarget()).GetWorldPosition();
		}
		else
		{
			targetPos = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		randVec = VecRingRand( 2, 6 );
		
		outPos = targetPos + randVec;

		return outPos;
	}
}

state Transformation_Toad_Mortar_Projectile4_Engage in cACS_Transformation_Toad
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Transformation_Toad_Mortar_Projectile4_Entry();
	}
	
	entry function Transformation_Toad_Mortar_Projectile4_Entry()
	{	
		LockEntryFunction(true);
	
		Transformation_Toad_Mortar_Projectile4_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Transformation_Toad_Mortar_Projectile4_Latent()
	{
		var attackRange, attackAngle 				: float;
		var proj 									: CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile;
		var rotation, bone_rot 						: EulerAngles;
		var initpos, targetPosition, bone_vec		: Vector;
		var actortarget								: CActor;
		var actors									: array<CActor>;
		var i 										: int;

		//initpos = GetACSTransformationToad().GetBoneWorldPosition();

		GetACSTransformationToad().GetBoneWorldPositionAndRotationByIndex( GetACSTransformationToad().GetBoneIndex( 'l_torso_helper_05' ), bone_vec, bone_rot );

		initpos = bone_vec;

		initpos.Z += 0.5;

		rotation = GetACSTransformationToad().GetWorldRotation();

		if (thePlayer.GetDisplayTarget())
		{
			targetPosition = ((CActor)(thePlayer.GetDisplayTarget())).GetWorldPosition();
		}
		else
		{
			targetPosition = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		proj = (CACSTransformationToadSpawnMultipleEntitiesPoisonProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\toad_projectiles\toad_mortar_proj.w2ent", true ), initpos, rotation );
		proj.Init(thePlayer);
		proj.PlayEffectSingle( 'spit_travel' );
		//proj.ShootProjectileAtPosition( 0, 10 + RandRange(15,5), targetPosition, 500 );
		proj.ShootProjectileAtPosition( proj.projAngle, proj.projSpeed, FindPosition(), 500 );
		proj.DestroyAfter(10);
	}

	function FindPosition() : Vector
	{
		var randVec : Vector;
		var targetPos : Vector;
		var outPos : Vector;

		randVec = Vector( 0.f, 0.f, 0.f );

		if (thePlayer.GetDisplayTarget())
		{
			targetPos = (thePlayer.GetDisplayTarget()).GetWorldPosition();
		}
		else
		{
			targetPos = GetACSTransformationToad().GetWorldPosition() + GetACSTransformationToad().GetWorldForward() * 50;
		}

		randVec = VecRingRand( 2, 6 );
		
		outPos = targetPos + randVec;

		return outPos;
	}
}

function GetACSTransformationToad() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Transformation_Toad' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Transformation_Vampire_Monster
{
    function Spawn_Transformation_Vampire_Monster_Engage()
	{
		this.PushState('Spawn_Transformation_Vampire_Monster_Engage');
	}

	function ACS_VampireMonsterBehSwitch_Engage()
	{
		this.PushState('ACS_VampireMonsterBehSwitch_Engage');
	}

	function ACS_VampireMonsterFastWalkSwitch_Engage()
	{
		this.PushState('ACS_VampireMonsterFastWalkSwitch_Engage');
	}

	function ACS_VampireMonsterSlowWalkSwitch_Engage()
	{
		this.PushState('ACS_VampireMonsterSlowWalkSwitch_Engage');
	}

	function ACS_VampireMonsterBatProjectile_Engage()
	{
		this.PushState('ACS_VampireMonsterBatProjectile_Engage');
	}

	function ACS_VampireMonsterBatProjectileRepeating_Engage()
	{
		this.PushState('ACS_VampireMonsterBatProjectileRepeating_Engage');
	}
}

state Spawn_Transformation_Vampire_Monster_Engage in cACS_Transformation_Vampire_Monster
{
	private var actor															: CActor;
	private var ent																: CEntity;
	private var temp															: CEntityTemplate;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var p_comp															: CComponent;
	private var apptemp															: CEntityTemplate;

	private var cameraTemplate													: CEntityTemplate;
	private var cameraEnt														: CEntity;

	private var cam_dummy_temp, sacrifice_dummy_temp							: CEntityTemplate;
	private var cam_dummy, sacrifice_dummy 										: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		GetACSTransformationVampireMonster().Destroy();
		Spawn_Transformation_Vampire_Monster_Entry();
	}
	
	entry function Spawn_Transformation_Vampire_Monster_Entry()
	{
		Spawn_Transformation_Vampire_Monster_Latent();
	}
	
	latent function Spawn_Transformation_Vampire_Monster_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\transformation_entities\acs_vampire_monster.w2ent"
			
		, true );

		ent = theGame.CreateEntity( temp, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 0.75;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());

		((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Transformation_Vampire_Monster_Immunity_Negative', true); 
		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Transformation_Vampire_Monster_Immunity_Critical', true); 

		ent.AddTag('ACS_Transformation_Vampire_Monster');

		ent.AddTag('ACS_Vampire_Monster_Ground_Mode');

		ent.PlayEffect('avatar_death_swollen_no_decal');

		GetACSWatcher().ACSTransformVampireMonsterPlayAnim('dettlaff_fly_phase2_start', 0.25, 0.25);

		GetACSWatcher().RemoveTimer('ACS_Transformation_Vampire_Monster_Delay_Cancel_Anim');

		GetACSWatcher().AddTimer('ACS_Transformation_Vampire_Monster_Delay_Cancel_Anim', 1, false);

		GetACSWatcher().CamerasDestroy();

		cameraTemplate = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\transformation_camera.w2ent", true);

		cameraEnt = (CStaticCamera)theGame.CreateEntity(cameraTemplate, theCamera.GetCameraPosition(), theCamera.GetCameraRotation());	

		cameraEnt.AddTag('ACS_Transformation_Custom_Camera');



		cam_dummy_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_dummy_entity.w2ent", true );

		cam_dummy = (CEntity)theGame.CreateEntity( cam_dummy_temp, ent.GetWorldPosition() );

		((CNewNPC)cam_dummy).EnableCharacterCollisions(false);
		((CNewNPC)cam_dummy).EnableCollisions(false);

		((CActor)cam_dummy).AddBuffImmunity_AllNegative('ACS_Dummy_Entity', true);

		((CActor)cam_dummy).AddBuffImmunity_AllCritical('ACS_Dummy_Entity', true);

		((CActor)cam_dummy).SetUnpushableTarget(thePlayer);

		((CActor)cam_dummy).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		((CActor)cam_dummy).SetCanPlayHitAnim(false); 

		((CNewNPC)cam_dummy).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CActor)(cam_dummy)).GetInventory().RemoveAllItems();

		cam_dummy.CreateAttachment(ent,'attach_slot', Vector( 0, 0, 0 ), EulerAngles(-90,0,0));

		cam_dummy.AddTag('ACS_Transformation_Vampire_Monster_Camera_Dummy');


		GetACSWatcher().AddTimer('TransformationVampireMonsterHeavyAttackDamageBlast', 0.5, false);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_VampireMonsterBehSwitch_Engage in cACS_Transformation_Vampire_Monster
{
	var p_actor 					: CActor;
	var p_comp						: CComponent;
	var temp						: CEntityTemplate;
	var vampRot, adjustedRot 		: EulerAngles;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Beh_Switch_Entry();
	}
	
	entry function Beh_Switch_Entry()
	{	
		LockEntryFunction(true);
	
		Beh_Switch_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Beh_Switch_Latent()
	{
		p_actor = GetACSTransformationVampireMonster();

		p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

		if (thePlayer.IsInCombat())
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustRotateTowardsEnemy();
		}
		else
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustForward();
		}

		GetACSWatcher().RemoveTimer('TransformationVampireMonsterLDashEnd');
		GetACSWatcher().RemoveTimer('TransformationVampireMonsterRDashEnd');

		GetACSTransformationVampireMonster().SetVisibility(true);

		GetACSWatcher().ACSVampireMonsterRemoveMoveTimers();

		if (GetACSTransformationVampireMonster().HasTag('ACS_Vampire_Monster_Ground_Mode'))
		{
			if ( GetACSTransformationVampireMonster().GetBehaviorGraphInstanceName() != 'DettlaffFlight' )
			{
				GetACSTransformationVampireMonster().ActivateAndSyncBehavior( 'DettlaffFlight' );
			}

			thePlayer.BreakAttachment();
			//thePlayer.CreateAttachment( GetACSTransformationVampireMonsterCameraDummy(), 'fx_point', Vector( 0, -2, 0 ), EulerAngles(0,90,0) );

			GetACSWatcher().AddTimer('TransformationVampireMonsterHeavyAttackDamageBlast', 0.5, false);

			//GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
			//GetWitcherPlayer().StopEffect('smoke_explosion');

			GetACSTransformationVampireMonster().DestroyEffect('dive_smoke');
			GetACSTransformationVampireMonster().PlayEffectSingle('dive_smoke');
			GetACSTransformationVampireMonster().StopEffect('dive_smoke');

			//GetACSTransformationVampireMonster().PlayEffectSingle('wing_trail');

			GetACSWatcher().ACSTransformVampireMonsterPlayAnim('dettlaff_fly_phase2_start', 0.0125f, 0.25f);

			GetACSWatcher().RemoveTimer('ACS_Transformation_Vampire_Monster_Delay_Flight_Controls');

			GetACSWatcher().AddTimer('ACS_Transformation_Vampire_Monster_Delay_Flight_Controls', 2, false);

			GetACSTransformationVampireMonster().AddTag('ACS_Vampire_Monster_Flight_Mode');

			GetACSTransformationVampireMonster().RemoveTag('ACS_Vampire_Monster_Ground_Mode');
		}
		else
		{
			if ( GetACSTransformationVampireMonster().GetBehaviorGraphInstanceName() != 'DettlaffMinion' )
			{
				GetACSTransformationVampireMonster().ActivateAndSyncBehavior( 'DettlaffMinion' );
			}

			GetACSWatcher().AddTimer('TransformationVampireMonsterHeavyAttackDamageBlast', 1, false);

			thePlayer.BreakAttachment();
			thePlayer.CreateAttachment( GetACSTransformationVampireMonster(), 'Trajectory' , Vector( 0, 0, 0.5 ), EulerAngles(0,0,0) );

			//GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
			//GetWitcherPlayer().StopEffect('smoke_explosion');

			GetACSTransformationVampireMonster().DestroyEffect('start_effect');
			GetACSTransformationVampireMonster().PlayEffectSingle('start_effect');

			//GetACSTransformationVampireMonster().StopEffect('wing_trail');

			GetACSWatcher().ACSTransformVampireMonsterPlayAnim('dettlaff_construct_diving', 0.25f, 0.25f);

			GetACSWatcher().RemoveTimer('ACS_Transformation_Vampire_Monster_Delay_Cancel_Anim');

			GetACSWatcher().AddTimer('ACS_Transformation_Vampire_Monster_Delay_Cancel_Anim', 2, false);

			GetACSTransformationVampireMonster().AddTag('ACS_Vampire_Monster_Ground_Mode');

			GetACSTransformationVampireMonster().RemoveTag('ACS_Vampire_Monster_Flight_Mode');

			vampRot = GetACSTransformationVampireMonster().GetWorldRotation();

			adjustedRot = EulerAngles(0,0,0);

			adjustedRot.Yaw = vampRot.Yaw;

			GetACSTransformationVampireMonster().TeleportWithRotation(ACSFixZAxis(GetACSTransformationVampireMonster().GetWorldPosition()), adjustedRot);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_VampireMonsterFastWalkSwitch_Engage in cACS_Transformation_Vampire_Monster
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Fast_Walk_Switch_Entry();
	}
	
	entry function Fast_Walk_Switch_Entry()
	{	
		LockEntryFunction(true);
	
		Fast_Walk_Switch_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Fast_Walk_Switch_Latent()
	{
		if (GetACSTransformationVampireMonster().HasTag('ACS_Vampire_Monster_Ground_Mode'))
		{
			if ( GetACSTransformationVampireMonster().GetBehaviorGraphInstanceName() != 'DettlaffMinionFastWalk' )
			{
				GetACSWatcher().ACSTransformVampireMonsterPlayAnim('dettlaff_weak_walk_forward', 0.875, 0.0125);

				GetACSTransformationVampireMonster().SetVisibility(false);

				GetACSWatcher().RemoveTimer('Vampire_Monster_Reveal_Delay');

				GetACSWatcher().AddTimer('Vampire_Monster_Reveal_Delay', 0.5, false);

				GetACSTransformationVampireMonster().StopEffect('shadowdash_body_blood');

				GetACSTransformationVampireMonster().StopEffect('shadowdash_ground_blood');

				GetACSTransformationVampireMonster().PlayEffectSingle('shadowdash_body_blood');

				GetACSTransformationVampireMonster().PlayEffectSingle('shadowdash_ground_blood');

				GetACSTransformationVampireMonster().DestroyEffect('finisher_sparks');
				
				GetACSTransformationVampireMonster().PlayEffectSingle('finisher_sparks');

				GetACSTransformationVampireMonster().DestroyEffect('body_blood_drip');
				GetACSTransformationVampireMonster().PlayEffectSingle('body_blood_drip');
				GetACSTransformationVampireMonster().StopEffect('body_blood_drip');

				GetACSTransformationVampireMonster().DestroyEffect('comming_out');
				GetACSTransformationVampireMonster().PlayEffectSingle('comming_out');
				GetACSTransformationVampireMonster().StopEffect('comming_out');

				GetACSTransformationVampireMonster().ActivateAndSyncBehavior( 'DettlaffMinionFastWalk' );
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_VampireMonsterSlowWalkSwitch_Engage in cACS_Transformation_Vampire_Monster
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Slow_Walk_Switch_Entry();
	}
	
	entry function Slow_Walk_Switch_Entry()
	{	
		LockEntryFunction(true);
	
		Slow_Walk_Switch_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Slow_Walk_Switch_Latent()
	{
		if (GetACSTransformationVampireMonster().HasTag('ACS_Vampire_Monster_Ground_Mode'))
		{
			if ( GetACSTransformationVampireMonster().GetBehaviorGraphInstanceName() != 'DettlaffMinion' )
			{
				GetACSWatcher().ACSTransformVampireMonsterPlayAnim('dettlaff_construct_walk_forward', 0.875, 0.0125);

				GetACSTransformationVampireMonster().SetVisibility(false);

				GetACSWatcher().RemoveTimer('Vampire_Monster_Reveal_Delay');

				GetACSWatcher().AddTimer('Vampire_Monster_Reveal_Delay', 0.5, false);

				GetACSTransformationVampireMonster().StopEffect('shadowdash_body_blood');

				GetACSTransformationVampireMonster().StopEffect('shadowdash_ground_blood');

				GetACSTransformationVampireMonster().PlayEffectSingle('shadowdash_body_blood');

				GetACSTransformationVampireMonster().PlayEffectSingle('shadowdash_ground_blood');

				GetACSTransformationVampireMonster().DestroyEffect('finisher_sparks');

				GetACSTransformationVampireMonster().PlayEffectSingle('finisher_sparks');

				GetACSTransformationVampireMonster().DestroyEffect('finisher_sparks');
				
				GetACSTransformationVampireMonster().PlayEffectSingle('finisher_sparks');

				GetACSTransformationVampireMonster().DestroyEffect('body_blood_drip');
				GetACSTransformationVampireMonster().PlayEffectSingle('body_blood_drip');
				GetACSTransformationVampireMonster().StopEffect('body_blood_drip');

				GetACSTransformationVampireMonster().DestroyEffect('comming_out');
				GetACSTransformationVampireMonster().PlayEffectSingle('comming_out');
				GetACSTransformationVampireMonster().StopEffect('comming_out');



				GetACSTransformationVampireMonster().ActivateAndSyncBehavior( 'DettlaffMinion' );
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_VampireMonsterBatProjectile_Engage in cACS_Transformation_Vampire_Monster
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		VampireMonsterBatProjectile_Entry();
	}
	
	entry function VampireMonsterBatProjectile_Entry()
	{	
		LockEntryFunction(true);
	
		VampireMonsterBatProjectile_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function VampireMonsterBatProjectile_Latent()
	{
		var attackRange 							: float;
		var bat_proj 								: W3BatSwarmAttack;
		var rotation 								: EulerAngles;
		var initpos, targetPosition, vampPos		: Vector;
		var actortarget								: CActor;
		var actors									: array<CActor>;
		var i 										: int;

		attackRange = 40;

		actors.Clear();

		actors = GetACSTransformationVampireMonster().GetNPCsAndPlayersInRange(attackRange, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		
		actors.Remove( GetACSTransformationVampireMonster() );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget == GetACSTransformationVampireMonster()
				|| actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud')
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster') 
				)
				continue;

				initpos = (actortarget.GetWorldPosition() + thePlayer.GetWorldPosition()) * 0.5;

				vampPos = thePlayer.GetWorldPosition() + Vector(0,0,2);

				initpos.Z = vampPos.Z;

				rotation = GetACSTransformationVampireMonster().GetWorldRotation();

				targetPosition = actortarget.PredictWorldPosition( 0.3 );
				//targetPosition.Z += 1;

				bat_proj = (W3BatSwarmAttack)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_bat_swarm_attack_2.w2ent", true ), initpos, rotation );
				bat_proj.Init(thePlayer);
				bat_proj.PlayEffectSingle( 'trail' );
				bat_proj.PlayEffectSingle( 'venom' );
				bat_proj.AddTag('ACS_Transformation_Vampire_Monster_Swarm_Proj');
				bat_proj.ShootProjectileAtPosition( 0, 10 + RandRange(15,5), targetPosition, 500 );
				bat_proj.DestroyAfter(7);
			}
		}

	}
}

function GetACSVampireMonsterSwarmProjDestroyAll()
{	
	var actors 											: array<CEntity>;
	var i												: int;
	
	actors.Clear();

	theGame.GetEntitiesByTag( 'ACS_Transformation_Vampire_Monster_Swarm_Proj', actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].Destroy();
	}
}

state ACS_VampireMonsterBatProjectileRepeating_Engage in cACS_Transformation_Vampire_Monster
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		VampireMonsterBatProjectileRepeating_Entry();
	}
	
	entry function VampireMonsterBatProjectileRepeating_Entry()
	{	
		LockEntryFunction(true);
	
		VampireMonsterBatProjectileRepeating_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function VampireMonsterBatProjectileRepeating_Latent()
	{
		var attackRange, attackAngle 				: float;
		var bat_proj 								: W3BatSwarmAttack;
		var rotation 								: EulerAngles;
		var initpos, targetPosition, vampPos		: Vector;
		var actortarget								: CActor;
		var actors									: array<CActor>;
		var i 										: int;

		attackRange = 40;

		actors.Clear();

		actors = GetACSTransformationVampireMonster().GetNPCsAndPlayersInRange(attackRange, 3, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
		
		actors.Remove( GetACSTransformationVampireMonster() );

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				actortarget = (CActor)actors[i];

				if (actortarget == GetACSTransformationVampireMonster()
				|| actortarget.HasTag('acs_snow_entity')
				|| actortarget.HasTag('smokeman') 
				|| actortarget.HasTag('ACS_Tentacle_1') 
				|| actortarget.HasTag('ACS_Tentacle_2') 
				|| actortarget.HasTag('ACS_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
				|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
				|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| actortarget.HasTag('ACS_Chaos_Cloud')
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
				|| actortarget.HasTag('ACS_Transformation_Vampire_Monster') 
				)
				continue;

				initpos = (actortarget.GetWorldPosition() + thePlayer.GetWorldPosition()) * 0.5;

				vampPos = thePlayer.GetWorldPosition() + Vector(0,0,3);

				initpos.Z = vampPos.Z;

				rotation = GetACSTransformationVampireMonster().GetWorldRotation();

				targetPosition = actortarget.PredictWorldPosition( 0.3 );
				//targetPosition.Z += 1;

				bat_proj = (W3BatSwarmAttack)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_bat_swarm_attack_2.w2ent", true ), initpos, rotation );
				bat_proj.Init(thePlayer);
				bat_proj.AddTag('ACS_Transformation_Vampire_Monster_Gatling_Proj');
				bat_proj.PlayEffectSingle( 'trail' );
				bat_proj.PlayEffectSingle( 'venom' );
				bat_proj.ShootProjectileAtPosition( 0, 10 + RandRange(15,5), targetPosition, 500 );
				bat_proj.DestroyAfter(3);
			}
		}

	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class W3TransformationVampireMonsterTrap extends CInteractiveEntity
{
	editable var effectOnSpawn				: name;
	editable var effectToPlayOnActivation	: name;
	editable var durationFrom				: int;
	editable var durationTo					: int;
	
	var areasActive							: bool;
	var movementAdjustorActive				: bool;
	var params 								: SCustomEffectParams;
	var movementAdjustor					: CMovementAdjustor;
	var ticket 								: SMovementAdjustmentRequestTicket;
	var ticketRot							: SMovementAdjustmentRequestTicket;
	var lifeTime							: int;
	var l_effectDuration					: int;
	var startTimestamp						: float;
	var enterTimestamp						: float;
	var actors								: array<CActor>;
	var actortarget							: CActor;
	var i									: int;
	var entities 							: array<CGameplayEntity>;
	
	default areasActive = true;
	default movementAdjustorActive = false;
	default durationTo = 5;
	default durationFrom = 0;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		PlayEffect( effectOnSpawn );
		lifeTime = RandRange(durationTo,durationFrom);
		AddTimer('DestroyEntityAfter', lifeTime, false );
		startTimestamp = theGame.GetEngineTimeAsSeconds();
		super.Init();
	}
	
	event OnAreaEnter( area : CTriggerAreaComponent, activator : CComponent )
	{
		if ( 
		area == (CTriggerAreaComponent)this.GetComponent( "TrapTrigger" ) 
		&& activator.GetEntity() != thePlayer 
		&& activator.GetEntity() != GetACSTransformationVampireMonster()
		&& activator.GetEntity() != GetACSTransformationVampireMonsterCameraDummy()
		&& areasActive )
		{
			
			PlayEffect( effectToPlayOnActivation );
		}
		
		if( area == (CTriggerAreaComponent)this.GetComponent( "TrapMovementAdjust" ) && areasActive )
		{
			FindGameplayEntitiesInSphere( entities, this.GetWorldPosition(), 4, 50, '', FLAG_ExcludePlayer + FLAG_OnlyAliveActors, this );

			entities.Remove( GetACSTransformationVampireMonster() );

			if( entities.Size() > 0 )
			{
				PlayEffect( effectToPlayOnActivation );

				for( i = 0; i < entities.Size(); i += 1 )
				{
					actortarget = (CActor)entities[i];

					if (actortarget == GetACSTransformationVampireMonster()
					|| actortarget.HasTag('acs_snow_entity')
					|| actortarget.HasTag('smokeman') 
					|| actortarget.HasTag('ACS_Tentacle_1') 
					|| actortarget.HasTag('ACS_Tentacle_2') 
					|| actortarget.HasTag('ACS_Tentacle_3') 
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_6')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_5')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_4')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_3')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_2')
					|| actortarget.HasTag('ACS_Necrofiend_Tentacle_1')
					|| actortarget.HasTag('ACS_Vampire_Monster_Boss_Bar') 
					|| actortarget.HasTag('ACS_Chaos_Cloud')
					|| actortarget.HasTag('ACS_Transformation_Vampire_Monster_Camera_Dummy') 
					|| actortarget.HasTag('ACS_Transformation_Vampire_Monster') 
					)

					continue;

					params.effectType = EET_Bleeding;
					enterTimestamp = theGame.GetEngineTimeAsSeconds();
					l_effectDuration = (int)(enterTimestamp - startTimestamp);
					params.duration = ( lifeTime - l_effectDuration )+1;
					actortarget.AddEffectCustom(params);
					
					movementAdjustor = actortarget.GetMovingAgentComponent().GetMovementAdjustor();
					ticketRot = movementAdjustor.CreateNewRequest( 'ACSVampireMonsterCriticalTrapRotate' );
					movementAdjustor.RotateTowards( ticketRot, this );
					movementAdjustor.BindToEvent( ticketRot, 'RotateTowards');
				}
			}

			AddTimer( 'MovementAdjustTimer', 0.2, false );
		}
		
	}
	timer function MovementAdjustTimer( delta : float , id : int )
	{
		if( movementAdjustor && !movementAdjustor.IsRequestActive(ticket) )
		{
			ticket = movementAdjustor.CreateNewRequest( 'ACSVampireMonsterCriticalTrapSlide' );
			movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 4.f );
			movementAdjustor.SlideTowards( ticket, this );
			movementAdjustor.Continuous(ticket);
		}
	}
	
	timer function DestroyEntityAfter( dt : float , id: int )
	{
		areasActive = false;
		movementAdjustor.CancelByName('ACSVampireMonsterCriticalTrapSlide');
		movementAdjustor.CancelByName('ACSVampireMonsterCriticalTrapRotate');
		StopEffects();
	}
	
	event OnAreaExit( area : CTriggerAreaComponent, activator : CComponent )
	{
		if ( area == (CTriggerAreaComponent)this.GetComponent( "TrapTrigger" )
		&& activator.GetEntity() != thePlayer 
		&& activator.GetEntity() != GetACSTransformationVampireMonster()
		&& activator.GetEntity() != GetACSTransformationVampireMonsterCameraDummy()
		)
		{
			StopEffect( effectToPlayOnActivation );
		}
		
		if( area == (CTriggerAreaComponent)this.GetComponent("TrapMovementAdjust") )
		{
			movementAdjustor.CancelByName('ACSVampireMonsterCriticalTrapSlide');
			movementAdjustor.CancelByName('ACSVampireMonsterCriticalTrapRotate');
			RemoveTimer( 'MovementAdjustTimer' );
		}
	}
	
	event OnAardHit( sign : W3AardProjectile )
	{
		//StopEffects();
	}
	
	private function StopEffects()
	{
		StopAllEffects();
		DestroyAfter( 2.0f );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function GetACSTransformationVampireMonster() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Monster' );
	return entity;
}

function GetACSTransformationVampireMonsterCameraDummy() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Monster_Camera_Dummy' );
	return entity;
}

function GetACSTransformationVampireMonsterSwarm1() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Monster_Swarm_1' );
	return entity;
}

function GetACSTransformationVampireMonsterSwarm2() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Monster_Swarm_2' );
	return entity;
}

function GetACSTransformationVampireMonsterSwarm3() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Monster_Swarm_3' );
	return entity;
}

function GetACSTransformationVampireMonsterAbductionVictim() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Abduction_Victim' );
	return entity;
}

function GetACSTransformationVampireMonsterAbductionVictimFX_1() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Mosnter_Abduction_FX_1' );
	return entity;
}

function GetACSTransformationVampireMonsterAbductionVictimFX_2() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Mosnter_Abduction_FX_2' );
	return entity;
}

function GetACSTransformationVampireMonsterAbductionVictimFX_3() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Mosnter_Abduction_FX_3' );
	return entity;
}

function GetACSVampireSprintFX() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Vampire_Sprint_FX' );
	return entity;
}

function GetACSTransformationVampireMonsterScreamEnt() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Transformation_Vampire_Monster_Scream' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Transformation_Vampiress
{
    function Spawn_Transformation_Vampiress_Engage()
	{
		this.PushState('Spawn_Transformation_Vampiress_Engage');
	}

	function Spawn_Transformation_Bruxa_Engage()
	{
		this.PushState('Spawn_Transformation_Bruxa_Engage');
	}

	function ACS_VampiressBehSwitch_Engage()
	{
		this.PushState('ACS_VampiressBehSwitch_Engage');
	}

	function Chaos_Meteorite_Storm_Engage()
	{
		this.PushState('Chaos_Meteorite_Storm_Engage');
	}

	function Chaos_Meteorite_Single_Summon_Engage()
	{
		this.PushState('Chaos_Meteorite_Single_Summon_Engage');
	}

	function Chaos_Meteorite_Single_Fire_Engage()
	{
		this.PushState('Chaos_Meteorite_Single_Fire_Engage');
	}

	function Chaos_Magma_Summon_Engage()
	{
		this.PushState('Chaos_Magma_Summon_Engage');
	}

	function Chaos_Magma_Line_Engage()
	{
		this.PushState('Chaos_Magma_Line_Engage');
	}

	function Chaos_Tornado_Engage()
	{
		this.PushState('Chaos_Tornado_Engage');
	}

	function Chaos_Lightning_Targeted_Engage()
	{
		this.PushState('Chaos_Lightning_Targeted_Engage');
	}

	function Chaos_Cloud_Summon_Engage()
	{
		this.PushState('Chaos_Cloud_Summon_Engage');
	}

	function Chaos_Root_Projectile_Engage()
	{
		this.PushState('Chaos_Root_Projectile_Engage');
	}

	function Chaos_Wood_Projectile_Engage()
	{
		this.PushState('Chaos_Wood_Projectile_Engage');
	}

	function Chaos_Snowball_Single_Summon_Engage()
	{
		this.PushState('Chaos_Snowball_Single_Summon_Engage');
	}

	function Chaos_Snowball_Engage()
	{
		this.PushState('Chaos_Snowball_Engage');
	}

	function Chaos_Ice_Explosion_Engage()
	{
		this.PushState('Chaos_Ice_Explosion_Engage');
	}

	function Chaos_Vacuum_Orb_Engage()
	{
		this.PushState('Chaos_Vacuum_Orb_Engage');
	}

	function Chaos_Orb_Small_Engage()
	{
		this.PushState('Chaos_Orb_Small_Engage');
	}

	function Chaos_Arena_Engage()
	{
		this.PushState('Chaos_Arena_Engage');
	}

	function Chaos_Drain_Engage()
	{
		this.PushState('Chaos_Drain_Engage');
	}
}

state Spawn_Transformation_Vampiress_Engage in cACS_Transformation_Vampiress
{
	private var actor															: CActor;
	private var ent																: CEntity;
	private var temp															: CEntityTemplate;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var p_comp															: CComponent;
	private var apptemp															: CEntityTemplate;
	private var vampiress_taunt_anim_names										: array<name>;
	private var cameraTemplate													: CEntityTemplate;
	private var cameraEnt														: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		GetACSTransformationVampiress().Destroy();
		Spawn_Transformation_Vampiress_Entry();
	}
	
	entry function Spawn_Transformation_Vampiress_Entry()
	{
		Spawn_Transformation_Vampiress_Latent();
	}
	
	latent function Spawn_Transformation_Vampiress_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\transformation_entities\acs_lillith.w2ent"
			
		, true );

		ent = theGame.CreateEntity( temp, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());

		((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Transformation_Vampiress_Immunity_Negative', true); 
		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Transformation_Vampiress_Immunity_Critical', true); 

		vampiress_taunt_anim_names.Clear();

		vampiress_taunt_anim_names.PushBack('bruxa_taunt_02');
		vampiress_taunt_anim_names.PushBack('bruxa_taunt_01');
		vampiress_taunt_anim_names.PushBack('utility_taunt_01');
		vampiress_taunt_anim_names.PushBack('utility_taunt_from_dodge');
		vampiress_taunt_anim_names.PushBack('utility_taunt_02');

		ent.AddTag('ACS_Transformation_Vampiress');

		//ent.AddTag('ACS_Transformation_Bruxa');

		ent.PlayEffectSingle('acs_armor_effect_1' );
		ent.PlayEffectSingle('acs_armor_effect_2' );

		ent.PlayEffectSingle('igni_reaction_djinn' );
		ent.StopEffect('igni_reaction_djinn' );

		ent.PlayEffectSingle('shadowdash_cs701_1' );
		ent.StopEffect('shadowdash_cs701_1' );

		//ent.PlayEffectSingle('demonic_possession' );

		ent.PlayEffectSingle('teleport_out' );
		ent.StopEffect('teleport_out');

		ent.PlayEffectSingle('shadowdash_smoke' );
		ent.StopEffect('shadowdash_smoke');

		((CActor)ent).SetInteractionPriority( IP_Max_Unpushable );

		GetACSWatcher().ACSTransformVampiressPlayAnim(vampiress_taunt_anim_names[RandRange(vampiress_taunt_anim_names.Size())], 0.5f, 0.5f);



		GetACSWatcher().CamerasDestroy();

		cameraTemplate = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\transformation_camera.w2ent", true);

		cameraEnt = (CStaticCamera)theGame.CreateEntity(cameraTemplate, theCamera.GetCameraPosition(), theCamera.GetCameraRotation());	

		cameraEnt.AddTag('ACS_Transformation_Custom_Camera');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Spawn_Transformation_Bruxa_Engage in cACS_Transformation_Vampiress
{
	private var actor															: CActor;
	private var ent																: CEntity;
	private var temp															: CEntityTemplate;
	private var meshcomp														: CComponent;
	private var animcomp 														: CAnimatedComponent;
	private var h 																: float;
	private var p_comp															: CComponent;
	private var apptemp															: CEntityTemplate;
	private var vampiress_taunt_anim_names										: array<name>;
	private var cameraTemplate													: CEntityTemplate;
	private var cameraEnt														: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		GetACSTransformationVampiress().Destroy();

		Spawn_Transformation_Bruxa_Entry();
	}
	
	entry function Spawn_Transformation_Bruxa_Entry()
	{
		Spawn_Transformation_Bruxa_Latent();
	}
	
	latent function Spawn_Transformation_Bruxa_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\transformation_entities\acs_bruxa.w2ent"
			
		, true );

		ent = theGame.CreateEntity( temp, GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 1;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(GetWitcherPlayer().GetLevel());

		((CActor)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );
		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'q104_avallach_friendly_to_all', AGP_Default );

		((CNewNPC)ent).SetCanPlayHitAnim(false);

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

		((CActor)ent).AddBuffImmunity_AllNegative('ACS_Transformation_Vampiress_Immunity_Negative', true); 
		((CActor)ent).AddBuffImmunity_AllCritical('ACS_Transformation_Vampiress_Immunity_Critical', true); 

		vampiress_taunt_anim_names.Clear();

		vampiress_taunt_anim_names.PushBack('bruxa_taunt_02');
		vampiress_taunt_anim_names.PushBack('bruxa_taunt_01');
		vampiress_taunt_anim_names.PushBack('utility_taunt_01');
		vampiress_taunt_anim_names.PushBack('utility_taunt_from_dodge');
		vampiress_taunt_anim_names.PushBack('utility_taunt_02');

		ent.AddTag('ACS_Transformation_Vampiress');

		ent.AddTag('ACS_Transformation_Bruxa');

		//ent.PlayEffectSingle('demonic_possession' );
		//ent.StopEffect('demonic_possession' );

		ent.PlayEffectSingle('shadowdash_short' );
		ent.StopEffect('shadowdash_short' );

		//ent.PlayEffectSingle('demonic_possession' );

		ent.PlayEffectSingle('shadowdash_smoke' );
		ent.StopEffect('shadowdash_smoke');

		((CActor)ent).SetInteractionPriority( IP_Max_Unpushable );

		GetACSWatcher().ACSTransformVampiressPlayAnim(vampiress_taunt_anim_names[RandRange(vampiress_taunt_anim_names.Size())], 0.5f, 0.5f);



		GetACSWatcher().CamerasDestroy();

		cameraTemplate = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\transformation_camera.w2ent", true);

		cameraEnt = (CStaticCamera)theGame.CreateEntity(cameraTemplate, theCamera.GetCameraPosition(), theCamera.GetCameraRotation());	

		cameraEnt.AddTag('ACS_Transformation_Custom_Camera');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state ACS_VampiressBehSwitch_Engage in cACS_Transformation_Vampiress
{
	var p_actor 					: CActor;
	var p_comp						: CComponent;
	var temp						: CEntityTemplate;
	var vampiress_taunt_anim_names	: array<name>;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Beh_Switch_Entry();
	}
	
	entry function Beh_Switch_Entry()
	{	
		LockEntryFunction(true);

		if (GetACSTransformationVampiress().HasTag('ACS_Transformation_Bruxa'))
		{
			return;
		}
	
		Beh_Switch_Latent();
		
		LockEntryFunction(false);
	}
	
	latent function Beh_Switch_Latent()
	{
		p_actor = GetACSTransformationVampiress();

		p_comp = p_actor.GetComponentByClassName( 'CAppearanceComponent' );

		if (thePlayer.IsInCombat())
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustRotateTowardsEnemy();
		}
		else
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustForward();
		}

		if (!GetACSTransformationVampiress().HasTag('ACS_Vampiress_Sorceress_Mode'))
		{
			if ( GetACSTransformationVampiress().GetBehaviorGraphInstanceName() != 'Sorceress_Beh' )
			{
				GetACSTransformationVampiress().ActivateAndSyncBehavior( 'Sorceress_Beh' );
			}

			temp = (CEntityTemplate)LoadResourceAsync(

			"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent"
			
			, true);

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

			temp = (CEntityTemplate)LoadResourceAsync(

			"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body_2.w2ent"
			
			, true);

			((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

			GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
			GetWitcherPlayer().StopEffect('smoke_explosion');

			GetACSWatcher().RemoveTimer('ACS_Vampiress_Hand_Fx_Delay');
			GetACSWatcher().AddTimer('ACS_Vampiress_Hand_Fx_Delay', 1.5, false);

			GetACSWatcher().VampiressSpecialAbilityEffectsSwitch();

			vampiress_taunt_anim_names.Clear();

			vampiress_taunt_anim_names.PushBack('woman_sorceress_taunt_01_lp');
			vampiress_taunt_anim_names.PushBack('woman_sorceress_taunt_01_rp');
			vampiress_taunt_anim_names.PushBack('woman_sorceress_taunt_02_lp');
			vampiress_taunt_anim_names.PushBack('woman_sorceress_taunt_02_rp');
			vampiress_taunt_anim_names.PushBack('woman_sorceress_taunt_03_lp');
			vampiress_taunt_anim_names.PushBack('woman_sorceress_taunt_03_rp');

			GetACSWatcher().ACSTransformVampiressPlayAnim(vampiress_taunt_anim_names[RandRange(vampiress_taunt_anim_names.Size())], 0.5f, 0.5f);

			GetACSTransformationVampiress().AddTag('ACS_Vampiress_Sorceress_Mode');
		}
		else
		{
			if ( GetACSTransformationVampiress().GetBehaviorGraphInstanceName() != 'Exploration' )
			{
				GetACSTransformationVampiress().ActivateAndSyncBehavior( 'Exploration' );
			}

			temp = (CEntityTemplate)LoadResourceAsync(

			"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body_2.w2ent"
			
			, true);

			((CAppearanceComponent)p_comp).ExcludeAppearanceTemplate(temp);

			temp = (CEntityTemplate)LoadResourceAsync(

			"dlc\dlc_acs\data\models\nightmare_to_remember\nightmare_body.w2ent"
			
			, true);

			((CAppearanceComponent)p_comp).IncludeAppearanceTemplate(temp);

			GetWitcherPlayer().PlayEffectSingle('smoke_explosion');
			GetWitcherPlayer().StopEffect('smoke_explosion');

			GetACSTransformationVampiress().PlayEffectSingle('shadowdash_smoke' );
			GetACSTransformationVampiress().StopEffect('shadowdash_smoke');

			GetACSWatcher().RemoveTimer('ACS_Vampiress_Hand_Fx_Delay');

			GetACSTransformationVampiress().StopEffect('hand_fx');

			GetACSTransformationVampiress().StopEffect('hand_fx_l');

			GetACSTransformationVampiress().StopEffect('igni_reaction_djinn');

			GetACSWatcher().VampiressSpecialAbilityEffectsStop();

			vampiress_taunt_anim_names.Clear();

			vampiress_taunt_anim_names.PushBack('bruxa_taunt_02');
			vampiress_taunt_anim_names.PushBack('bruxa_taunt_01');
			vampiress_taunt_anim_names.PushBack('utility_taunt_01');
			vampiress_taunt_anim_names.PushBack('utility_taunt_from_dodge');
			vampiress_taunt_anim_names.PushBack('utility_taunt_02');

			GetACSWatcher().ACSTransformVampiressPlayAnim(vampiress_taunt_anim_names[RandRange(vampiress_taunt_anim_names.Size())], 0.25f, 0.5f);

			GetACSTransformationVampiress().RemoveTag('ACS_Vampiress_Sorceress_Mode');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Meteorite_Storm_Engage in cACS_Transformation_Vampiress
{
	private var targetPosition																																: Vector;

	event OnEnterState(prevStateName : name)
	{
		Meteorite_Storm_Entry();
	}
	
	entry function Meteorite_Storm_Entry()
	{
		Meteorite_Storm_Latent();
	}
	
	latent function Meteorite_Storm_Latent()
	{
		var entity : CEntity;
		var meteoriteStorm : CACSChaosMeteoriteStormEntity;
		var spawnPos : Vector;
		var rotation : EulerAngles;

		GetACSChaosMeteorSingle().Destroy();

		if (thePlayer.IsInCombat())
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustRotateTowardsEnemy();
		}
		else
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustForward();
		}
		
		if (thePlayer.GetTarget())
		{
			spawnPos = (GetWitcherPlayer().GetTarget()).PredictWorldPosition(0.35f);
			rotation = (GetWitcherPlayer().GetTarget()).GetWorldRotation();

			entity = (CACSChaosMeteoriteStormEntity)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_meterorite_storm.w2ent", true ), spawnPos, rotation );

			meteoriteStorm = (CACSChaosMeteoriteStormEntity)entity;

			if( meteoriteStorm )
			{
				meteoriteStorm.Execute( GetWitcherPlayer().GetTarget() );
			}
		}

		meteoriteStorm.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Meteorite_Single_Summon_Engage in cACS_Transformation_Vampiress
{
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 								: W3ACSChaosMeteorProjectile;
	private var initpos																	: Vector;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Meteor_Single();
	}
	
	entry function Meteor_Single()
	{
		GetACSChaosMeteorSingle().Destroy();

		Meteor_Single_Summon();
	}
	
	latent function Meteor_Single_Summon()
	{
		initpos = GetACSTransformationVampiress().GetWorldPosition();			
		initpos.Z += 5;
				
		proj_1 = (W3ACSChaosMeteorProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_meteorite_small.w2ent", true ), initpos );
						
		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_fx');

		proj_1.AddTag('ACS_Chaos_Meteorite_Single');

		proj_1.CreateAttachment(GetACSTransformationVampiress(), 'r_weapon');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Meteorite_Single_Fire_Engage in cACS_Transformation_Vampiress
{
	private var targetPosition														: Vector;
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 							: W3ACSChaosMeteorProjectile;
	private var initpos																: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		Meteor_Single_Fire_Entry();
	}
	
	entry function Meteor_Single_Fire_Entry()
	{
		GetACSChaosMeteorSingle().Destroy();

		Meteor_Single_Fire_Latent();
	}
	
	latent function Meteor_Single_Fire_Latent()
	{
		if (thePlayer.IsInCombat())
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustRotateTowardsEnemy();
		}
		else
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustForward();
		}

		if ( thePlayer.IsInCombat() && thePlayer.GetTarget() )
		{
			targetPosition = (thePlayer.GetTarget()).PredictWorldPosition(0.35f);

			//targetPosition.Z += 1.1;

			initpos = GetACSTransformationVampiress().GetBoneWorldPosition('r_weapon');	

			//initpos.Y += 1.5;
					
			proj_1 = (W3ACSChaosMeteorProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_meteorite_small.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffectSingle('fire_fx');

			proj_1.ShootProjectileAtPosition( 0, 15, targetPosition, 500 );
		}
		else
		{
			targetPosition = GetACSTransformationVampiress().GetWorldPosition() + GetACSTransformationVampiress().GetHeadingVector() + GetACSTransformationVampiress().GetWorldForward() * 20;

			targetPosition.Z -= 1.1;

			initpos = GetACSTransformationVampiress().GetBoneWorldPosition('r_weapon');	

			//initpos.Y += 1.5;
					
			proj_1 = (W3ACSChaosMeteorProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_meteorite_small.w2ent", true ), initpos );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffectSingle('fire_fx');

			proj_1.ShootProjectileAtPosition( 0, 15, targetPosition, 500 );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Magma_Summon_Engage in cACS_Transformation_Vampiress
{
	private var proj_1																																										: W3ACSFireLine;
	private var proj_2																																										: W3ACSRockLine;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		GetACSChaosMagmaProj1().Destroy();
		GetACSChaosMagmaProj2().Destroy();

		Chaos_Magma_Summon();
	}
	
	entry function Chaos_Magma_Summon()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Chaos_Magma_Summon_Activate();
		LockEntryFunction(false);
	}
	
	latent function Chaos_Magma_Summon_Activate()
	{
		position = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward()) + GetACSTransformationVampiress().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetACSTransformationVampiress().GetHeadingVector() * 30;

		proj_1 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_line');
		proj_1.ShootProjectileAtPosition(0,	100, targetPosition_1, 1 );
		proj_1.AddTag('ACS_Magma_Line_1');

		proj_2 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
		proj_2.Init(GetWitcherPlayer());
		proj_2.PlayEffectSingle('fire_line');
		proj_2.ShootProjectileAtPosition(0,	100, targetPosition_1, 1 );
		proj_2.AddTag('ACS_Magma_Line_2');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Magma_Line_Engage in cACS_Transformation_Vampiress
{
	private var proj_1																																										: W3ACSFireLine;
	private var proj_2																																										: W3ACSRockLine;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Chaos_Magma_Line();
	}
	
	entry function Chaos_Magma_Line()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_ifryt.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ifryt.bnk", false );
		}
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Chaos_Magma_Line_Activate();
		LockEntryFunction(false);
	}
	
	latent function Chaos_Magma_Line_Activate()
	{
		position = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.5) + GetACSTransformationVampiress().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetACSTransformationVampiress().GetHeadingVector() * 30;

		proj_1 = (W3ACSFireLine)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\elemental_ifryt_proj.w2ent", true ), position );
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_line');
		proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
		proj_1.DestroyAfter(10);

		proj_2 = (W3ACSRockLine)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\elemental_dao_proj.w2ent", true ), position );
		proj_2.Init(GetWitcherPlayer());
		proj_2.PlayEffectSingle('fire_line');
		proj_2.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
		proj_2.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Tornado_Engage in cACS_Transformation_Vampiress
{
	var tornado 					: W3ACSChaosTornado;
	var duration					: float;
	var position					: Vector;
	var tornadoApp 					: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Chaos_Tornado();
	}
	
	entry function Chaos_Tornado()
	{
		Chaos_Tornado_Activate();
	}
	
	latent function Chaos_Tornado_Activate()
	{
		duration = 10;

		if (GetACSChaosTornado())
		{
			GetACSChaosTornado().RemoveTimer('explode_timer');
			GetACSChaosTornado().AddTimer('explode_timer', 0.0001, false);

			GetACSChaosTornadoAppearance().PlayEffectSingle('explode');
			GetACSChaosTornadoAppearance().StopEffect('explode');

			GetACSChaosTornado().RemoveTimer('destroy_tornado');

			GetACSChaosTornado().AddTimer('destroy_tornado', duration, false );

			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( position ), 1.f, duration, 1.f, 20.f, 1);
		}
		else
		{
			position = GetACSTransformationVampiress().GetWorldPosition() + GetACSTransformationVampiress().GetHeadingVector() + GetACSTransformationVampiress().GetWorldForward() * 10;

			tornado = (W3ACSChaosTornado)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\lillith_magic\chaos_tornado.w2ent" ,true ), ACSPlayerFixZAxis( position ), thePlayer.GetWorldRotation());

			tornado.AddTimer('destroy_tornado', duration, false );

			tornado.AddTag('ACS_Chaos_Tornado');



			GetACSChaosTornadoAppearance().Destroy();

			tornadoApp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\lillith_magic\chaos_tornado_appearance_1.w2ent" ,true ), position, thePlayer.GetWorldRotation());

			tornadoApp.CreateAttachment(tornado);

			tornadoApp.AddTag('ACS_Chaos_Tornado_Appearance');

			tornadoApp.PlayEffectSingle('explode');

			tornadoApp.StopEffect('explode');



			theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( position ), 1.f, duration, 1.f, 20.f, 1);
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Lightning_Targeted_Engage in cACS_Transformation_Vampiress
{
	var temp, temp_2, temp_3, temp_4, temp_5									: CEntityTemplate;
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5									: CEntity;
	var i, count, count_2, j, k													: int;
	var playerPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos		: Vector;
	var randAngle, randRange, randAngle_2, randRange_2, distance				: float;
	var playerRot, playerRot2, adjustedRot										: EulerAngles;
	var actors    																: array<CActor>;
	var actor    																: CActor;
	var dmg																		: W3DamageAction;
	var projDMG																	: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Chaos_Lightning_Targeted_Entry();
	}
	
	entry function Chaos_Lightning_Targeted_Entry()
	{
		Chaos_Lightning_Targeted_Latent();
	}
	
	latent function Chaos_Lightning_Targeted_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\giant_lightning_strike.w2ent"
			
		, true );

		temp_2 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\custom_lightning.w2ent"
			
		, true );

		temp_4 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\q603_08_fire_01.w2ent"
			
		, true );

		temp_5 = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\acs_guiding_wind.w2ent"
			
		, true );

		if (thePlayer.IsInCombat())
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustRotateTowardsEnemy();
		}
		else
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustForward();
		}

		if (thePlayer.GetTarget())
		{
			playerPos = ACSPlayerFixZAxis((thePlayer.GetDisplayTarget()).GetWorldPosition());
		}
		else
		{
			playerPos = ACSPlayerFixZAxis(GetACSTransformationVampiress().GetWorldPosition() + GetACSTransformationVampiress().GetHeadingVector() + GetACSTransformationVampiress().GetWorldForward() * 10);
		}

		playerRot = thePlayer.GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		playerRot.Yaw = RandRangeF(360,1);
		playerRot.Pitch = RandRangeF(22.5,-22.5);

		playerRot2 = thePlayer.GetWorldRotation();
		playerRot2.Yaw = RandRangeF(360,1);
			
		ent_1 = theGame.CreateEntity( temp, playerPos, adjustedRot );

		ent_1.PlayEffectSingle('pre_lightning');
		ent_1.PlayEffectSingle('lightning');

		ent_1.DestroyAfter(10);



		ent_2 = theGame.CreateEntity( temp_2, playerPos, playerRot2 );

		ent_2.PlayEffectSingle('lighgtning');

		ent_2.DestroyAfter(10);



		ent_3 = theGame.CreateEntity( temp_2, playerPos, adjustedRot );

		ent_3.PlayEffectSingle('lighgtning');

		ent_3.DestroyAfter(10);


		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( playerPos, 0.5f, 10.5f, 0.5f, 7.f, 1);


		count_2 = 12;

		for( j = 0; j < count_2; j += 1 )
		{
			randRange_2 = 2 + 2 * RandF();
			randAngle_2 = 2 * Pi() * RandF();
			
			spawnPos2.X = randRange_2 * CosF( randAngle_2 ) + playerPos.X;
			spawnPos2.Y = randRange_2 * SinF( randAngle_2 ) + playerPos.Y;
			//spawnPos2.Z = posAdjusted.Z;

			posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

			ent_4 = theGame.CreateEntity( temp_4, posAdjusted2, thePlayer.GetWorldRotation() );

			if (RandF() < 0.5)
			{
				ent_4.PlayEffectSingle('explosion');
			}
			else
			{
				if (RandF() < 0.5)
				{
					ent_4.PlayEffectSingle('explosion_big');
				}
				else
				{
					ent_4.PlayEffectSingle('explosion_medium');
				}
			}

			ent_4.DestroyAfter(10);
		}

		actors.Clear();

		actors = ((CActor)thePlayer.GetDisplayTarget()).GetNPCsAndPlayersInRange( 4, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer);

		for( k = 0; k < actors.Size(); k += 1 )
		{
			actor = actors[k];
			
			if( actors.Size() > 0 )
			{	
				if (actor != GetACSTransformationVampiress())
				{
					dmg =  new W3DamageAction in this;

					dmg.Initialize(GetWitcherPlayer(), actor, GetWitcherPlayer(), GetWitcherPlayer().GetName(), EHRT_None, CPS_Undefined, false, false, true, false);

					if (actor.UsesVitality()) 
					{ 
						if ( actor.GetStat( BCS_Vitality ) >= actor.GetStatMax( BCS_Vitality ) * 0.25 )
						{
							projDMG = actor.GetStat( BCS_Vitality ) * 0.125; 
						}
						else if ( actor.GetStat( BCS_Vitality ) < actor.GetStatMax( BCS_Vitality ) * 0.25 )
						{
							projDMG = ( actor.GetStatMax( BCS_Vitality ) - actor.GetStat( BCS_Vitality ) ) * 0.125; 
						}
					} 
					else if (actor.UsesEssence()) 
					{ 
						if (((CMovingPhysicalAgentComponent)(actor.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| actor.GetRadius() >= 0.7
						)
						{
							if ( actor.GetStat( BCS_Essence ) >= actor.GetStatMax( BCS_Essence ) * 0.25 )
							{
								projDMG = actor.GetStat( BCS_Essence ) * 0.06125; 
							}
							else if ( actor.GetStat( BCS_Essence ) < actor.GetStatMax( BCS_Essence ) * 0.25 )
							{
								projDMG = ( actor.GetStatMax( BCS_Essence ) - actor.GetStat( BCS_Essence ) ) * 0.06125; 
							}
						}
						else
						{
							if ( actor.GetStat( BCS_Essence ) >= actor.GetStatMax( BCS_Essence ) * 0.25 )
							{
								projDMG = actor.GetStat( BCS_Essence ) * 0.125; 
							}
							else if ( actor.GetStat( BCS_Essence ) < actor.GetStatMax( BCS_Essence ) * 0.25 )
							{
								projDMG = ( actor.GetStatMax( BCS_Essence ) - actor.GetStat( BCS_Essence ) ) * 0.125; 
							}
						}
					}

					dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, projDMG );
					dmg.SetHitAnimationPlayType(EAHA_ForceYes);
					dmg.SetSuppressHitSounds(true);

					dmg.AddEffectInfo(EET_HeavyKnockdown, 1);

					dmg.AddEffectInfo(EET_Burning, 1);

					dmg.SetForceExplosionDismemberment();
					
					theGame.damageMgr.ProcessAction( dmg );
					
					delete dmg;
				}
			}
		}

		thePlayer.SoundEvent( "fx_amb_thunder_close" );

		thePlayer.SoundEvent( "qu_nml_103_lightning" );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Cloud_Summon_Engage in cACS_Transformation_Vampiress
{
	var temp, temp_2, temp_3, temp_4, temp_5									: CEntityTemplate;
	var ent, ent_1, ent_2, ent_3, ent_4, ent_5									: CEntity;
	var i, count, count_2, j, k													: int;
	var playerPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos		: Vector;
	var randAngle, randRange, randAngle_2, randRange_2, distance				: float;
	var playerRot, playerRot2, adjustedRot										: EulerAngles;
	var actors    																: array<CActor>;
	var actor    																: CActor;
	var meshcomp																: CComponent;
	var animcomp 																: CAnimatedComponent;
	var h 																		: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Chaos_Cloud_Summon_Entry();
	}
	
	entry function Chaos_Cloud_Summon_Entry()
	{
		Chaos_Cloud_Summon_Latent();
	}
	
	latent function Chaos_Cloud_Summon_Latent()
	{
		temp_5 = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\lillith_magic\chaos_cloud.w2ent"
			
		, true );

		if (thePlayer.GetTarget())
		{
			playerPos = ACSPlayerFixZAxis((thePlayer.GetTarget()).GetWorldPosition());
		}
		else
		{
			playerPos = ACSPlayerFixZAxis(GetACSTransformationVampiress().GetWorldPosition() + GetACSTransformationVampiress().GetHeadingVector() + GetACSTransformationVampiress().GetWorldForward() * 10);
		}

		playerRot = thePlayer.GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		count = 3;
		
		for( i = 0; i < count; i += 1 )
		{
			randRange = 5 + 5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;

			ent_5 = theGame.CreateEntity( temp_5, spawnPos, adjustedRot );

			((CActor)ent_5).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
			((CActor)ent_5).SetCanPlayHitAnim(false); 
			((CActor)ent_5).AddBuffImmunity_AllNegative('ACS_Chaos_Cloud', true); 

			((CNewNPC)ent_5).SetAttitude(thePlayer, AIA_Friendly);

			((CActor)ent_5).AddTag('IsBoss');

			((CActor)ent_5).AddAbility('Boss');

			((CActor)ent_5).AddAbility('BounceBoltsWildhunt');

			((CActor)ent_5).AddAbility('DjinnRage');

			animcomp = (CAnimatedComponent)ent_5.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent_5.GetComponentByClassName('CMeshComponent');
			h = 3;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	

			ent_5.DestroyAfter(60);

			actors.Clear();

			actors = thePlayer.GetNPCsAndPlayersInRange( 50, 20, , FLAG_Attitude_Hostile + FLAG_OnlyAliveActors + FLAG_ExcludePlayer);

			for( k = 0; k < actors.Size(); k += 1 )
			{
				actor = actors[k];
				
				if( actors.Size() > 0 )
				{	
					if (actor != GetACSTransformationVampiress())
					{
						((CNewNPC)ent_5).SetAttitude(actor, AIA_Hostile);
					}
				}
			}

			((CNewNPC)ent_5).SetAttitude(GetACSTransformationVampiress(), AIA_Friendly);

			GetACSTransformationVampiress().SetAttitude(((CNewNPC)ent_5), AIA_Friendly);

			((CNewNPC)ent_5).SetAttitude(thePlayer, AIA_Friendly);

			thePlayer.SetAttitude(((CNewNPC)ent_5), AIA_Friendly);

			ent_5.AddTag('ACS_Chaos_Cloud');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Root_Projectile_Engage in cACS_Transformation_Vampiress
{
	var temp																	: CEntityTemplate;
	var ent																		: W3ACSRootAttack;
	var i, count_1, j, count_2													: int;
	var initPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos			: Vector;
	var randAngle, randRange, distance											: float;
	var pos																		: Vector;
	var rot, playerRot															: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Chaos_Root_Projectile();
	}
	
	entry function Chaos_Root_Projectile()
	{
		Chaos_Root_Projectile_Latent();
	}
	
	latent function Chaos_Root_Projectile_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\sprigan_root_attack.w2ent"
			
		, true );

		//initPos = ACSPlayerFixZAxis((thePlayer.GetDisplayTarget()).GetWorldPosition());

		initPos = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.5) + GetACSTransformationVampiress().GetHeadingVector() * 15;

		playerRot = GetACSTransformationVampiress().GetWorldRotation();

		playerRot.Yaw += RandRange(360,0);
		
		count_1 = 6;

		distance = 3;
			
		for( i = 0; i < count_1; i += 1 )
		{
			randRange = distance + distance * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + initPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + initPos.Y;
			spawnPos.Z = initPos.Z;

			posAdjusted = ACSPlayerFixZAxis(spawnPos);

			count_2 = 2;

			for( j = 0; j < count_2; j += 1 )
			{
				randRange = distance + distance * RandF();
				randAngle = 2 * Pi() * RandF();
				
				spawnPos2.X = randRange * CosF( randAngle ) + posAdjusted.X;
				spawnPos2.Y = randRange * SinF( randAngle ) + posAdjusted.Y;
				spawnPos2.Z = posAdjusted.Z;

				posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

				ent = (W3ACSRootAttack)theGame.CreateEntity( temp, posAdjusted2, playerRot );

				ent.DestroyAfter(10);	
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Wood_Projectile_Engage in cACS_Transformation_Vampiress
{
	private var targetPosition_1, targetPosition_2, targetPosition_3				: Vector;
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 							: W3ACSChaosWoodProjectile;
	private var initpos_1, initpos_2, initpos_3										: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		Chaos_Wood_Projectile_Entry();
	}
	
	entry function Chaos_Wood_Projectile_Entry()
	{
		Chaos_Wood_Projectile_Latent();
	}
	
	latent function Chaos_Wood_Projectile_Latent()
	{
		if (thePlayer.IsInCombat())
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustRotateTowardsEnemy();
		}
		else
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustForward();
		}

		if ( thePlayer.IsInCombat() && thePlayer.GetTarget() )
		{
			if (thePlayer.IsInCombat())
			{
				GetACSWatcher().ACSTransformVampiressMovementAdjustRotateTowardsEnemy();
			}
			else
			{
				GetACSWatcher().ACSTransformVampiressMovementAdjustForward();
			}

			initpos_1 = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.5) + GetACSTransformationVampiress().GetHeadingVector() * 1.1;

			initpos_1.Z += 1.25;

			targetPosition_1 = ((CActor)thePlayer.GetDisplayTarget()).PredictWorldPosition(0.35f);

			targetPosition_1.Z += 0.5;
					
			proj_1 = (W3ACSChaosWoodProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_wood_proj.w2ent", true ), initpos_1 );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffectSingle('glow');

			proj_1.ShootProjectileAtPosition( 0, 25, targetPosition_1, 500 );


			initpos_2 = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.1) + GetACSTransformationVampiress().GetWorldRight() * 1.1 + GetACSTransformationVampiress().GetHeadingVector() * 1.1;
			
			initpos_2.Z += 1.5;

			targetPosition_2 = initpos_2 + GetACSTransformationVampiress().GetWorldRight() * 1.5 + GetACSTransformationVampiress().GetHeadingVector() * 30;

			targetPosition_2.Z -= 1.1;

			proj_2 = (W3ACSChaosWoodProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_wood_proj.w2ent", true ), initpos_2 );
							
			proj_2.Init(thePlayer);
			proj_2.PlayEffectSingle('glow');

			proj_2.ShootProjectileAtPosition( 0, 25, targetPosition_1, 500 );


			initpos_3 = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.1) + GetACSTransformationVampiress().GetWorldRight() * -1.1 + GetACSTransformationVampiress().GetHeadingVector() * 1.1;

			initpos_3.Z += 1.5;

			targetPosition_3 = initpos_3 + GetACSTransformationVampiress().GetWorldRight() * -1.5 + GetACSTransformationVampiress().GetHeadingVector() * 30;

			targetPosition_3.Z -= 1.1;

			proj_3 = (W3ACSChaosWoodProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_wood_proj.w2ent", true ), initpos_3 );
							
			proj_3.Init(thePlayer);
			proj_3.PlayEffectSingle('glow');

			proj_3.ShootProjectileAtPosition( 0, 25, targetPosition_1, 500 );
		}
		else
		{
			targetPosition_1 = GetACSTransformationVampiress().GetWorldPosition() + GetACSTransformationVampiress().GetHeadingVector() + GetACSTransformationVampiress().GetWorldForward() * 20;

			targetPosition_1.Z -= 1.1;

			initpos_1 = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.5) + GetACSTransformationVampiress().GetHeadingVector() * 1.1;

			proj_1 = (W3ACSChaosWoodProjectile)theGame.CreateEntity( 
			(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_wood_proj.w2ent", true ), initpos_1 );
							
			proj_1.Init(thePlayer);
			proj_1.PlayEffectSingle('glow');

			proj_1.ShootProjectileAtPosition( 0, 25, targetPosition_1, 500 );
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Snowball_Single_Summon_Engage in cACS_Transformation_Vampiress
{
	private var proj_1																																										: W3ACSEredinFrostLine;
	private var proj_2																																										: W3WHMinionProjectile;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		GetACSChaosSnowballProj1().Destroy();
		GetACSChaosSnowballProj2().Destroy();

		Chaos_Snowball_Summon();
	}
	
	entry function Chaos_Snowball_Summon()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_ice.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ice.bnk", false );
		}
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Chaos_Snowball_Summon_Activate();
		LockEntryFunction(false);
	}
	
	latent function Chaos_Snowball_Summon_Activate()
	{
		position = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward()) + GetACSTransformationVampiress().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetACSTransformationVampiress().GetHeadingVector() * 30;

		proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_line');
		proj_1.ShootProjectileAtPosition(0,	100, targetPosition_1, 1 );
		proj_1.AddTag('ACS_Snowball_Line_1');

		proj_2 = (W3WHMinionProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent", true ), position );
		proj_2.Init(GetWitcherPlayer());
		proj_2.PlayEffectSingle('fire_line');
		proj_2.ShootProjectileAtPosition(0,	100, targetPosition_1, 1 );
		proj_2.AddTag('ACS_Snowball_Line_2');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Snowball_Engage in cACS_Transformation_Vampiress
{
	private var proj_1																																										: W3ACSEredinFrostLine;
	private var proj_2																																										: W3WHMinionProjectile;
	private var targetPosition_1, targetPosition_2, targetPosition_3, targetPosition_4, targetPosition_5, position																			: Vector;
	private var actors																																			   							: array<CActor>;
	private var i         																																									: int;
	private var actortarget					       																																			: CActor;
		
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Chaos_Snowball();
	}
	
	entry function Chaos_Snowball()
	{
		if ( !theSound.SoundIsBankLoaded("monster_golem_ice.bnk") )
		{
			theSound.SoundLoadBank( "monster_golem_ice.bnk", false );
		}
		
		GetWitcherPlayer().SoundEvent("monster_golem_dao_cmb_swoosh_light");
		
		LockEntryFunction(true);
		Chaos_Snowball_Activate();
		LockEntryFunction(false);
	}
	
	latent function Chaos_Snowball_Activate()
	{
		position = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.5) + GetACSTransformationVampiress().GetHeadingVector() * 1.1;
		
		targetPosition_1 = position + GetACSTransformationVampiress().GetHeadingVector() * 30;

		proj_1 = (W3ACSEredinFrostLine)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\eredin_frost_proj.w2ent", true ), position );
		proj_1.Init(GetWitcherPlayer());
		proj_1.PlayEffectSingle('fire_line');
		proj_1.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
		proj_1.DestroyAfter(10);

		proj_2 = (W3WHMinionProjectile)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\wh_minion_projectile.w2ent", true ), position );
		proj_2.Init(GetWitcherPlayer());
		proj_2.PlayEffectSingle('fire_line');
		proj_2.ShootProjectileAtPosition(0,	20, targetPosition_1, 30 );
		proj_2.DestroyAfter(10);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Ice_Explosion_Engage in cACS_Transformation_Vampiress
{
	var temp																	: CEntityTemplate;
	var ent																		: W3ChaosIceExplosion;
	var i, count_1, j, count_2													: int;
	var initPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos			: Vector;
	var randAngle, randRange, distance											: float;
	var pos																		: Vector;
	var rot, playerRot															: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Chaos_Ice_Explosion();
	}
	
	entry function Chaos_Ice_Explosion()
	{
		Chaos_Ice_Explosion_Latent();
	}
	
	latent function Chaos_Ice_Explosion_Latent()
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\lillith_magic\chaos_ice_explosion.w2ent"
			
		, true );

		//initPos = ACSPlayerFixZAxis((thePlayer.GetDisplayTarget()).GetWorldPosition());

		initPos = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.5) + GetACSTransformationVampiress().GetHeadingVector() * 15;

		playerRot = GetACSTransformationVampiress().GetWorldRotation();

		playerRot.Yaw += RandRange(360,0);
		
		count_1 = 6;

		distance = 3;
			
		for( i = 0; i < count_1; i += 1 )
		{
			randRange = distance + distance * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + initPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + initPos.Y;
			spawnPos.Z = initPos.Z;

			posAdjusted = ACSPlayerFixZAxis(spawnPos);

			count_2 = 2;

			for( j = 0; j < count_2; j += 1 )
			{
				randRange = distance + distance * RandF();
				randAngle = 2 * Pi() * RandF();
				
				spawnPos2.X = randRange * CosF( randAngle ) + posAdjusted.X;
				spawnPos2.Y = randRange * SinF( randAngle ) + posAdjusted.Y;
				spawnPos2.Z = posAdjusted.Z;

				posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

				ent = (W3ChaosIceExplosion)theGame.CreateEntity( temp, posAdjusted2, playerRot );

				ent.DestroyAfter(30);	

				theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( posAdjusted2 ), 1.f, 30, 1.f, 20.f, 0);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Orb_Small_Engage in cACS_Transformation_Vampiress
{
	private var targetPosition														: Vector;
	private var proj_1, proj_2, proj_3, proj_4, proj_5	 							: W3ACSChaosOrbSmall;
	private var initpos																: Vector;

	event OnEnterState(prevStateName : name)
	{
		Chaos_Orb_Small_Entry();
	}
	
	entry function Chaos_Orb_Small_Entry()
	{
		Chaos_Orb_Small_Latent();
	}
	
	latent function Chaos_Orb_Small_Latent()
	{
		if (thePlayer.IsInCombat())
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustRotateTowardsEnemy();
		}
		else
		{
			GetACSWatcher().ACSTransformVampiressMovementAdjustForward();
		}

		targetPosition = ((CActor)thePlayer.GetTarget()).PredictWorldPosition(0.35f);

		targetPosition.Z += 1.1;

		initpos = GetACSTransformationVampiress().GetBoneWorldPosition('r_weapon');		

		initpos.Z += 0.5;

		proj_1 = (W3ACSChaosOrbSmall)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_orb_small.w2ent", true ), initpos );
						
		proj_1.Init(thePlayer);
		proj_1.PlayEffectSingle('fire_fx');
		proj_1.ShootProjectileAtPosition( 0, 15, targetPosition, 500 );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Vacuum_Orb_Engage in cACS_Transformation_Vampiress
{
	private var targetPosition																																: Vector;

	event OnEnterState(prevStateName : name)
	{
		Vacuum_Orb_Entry();
	}
	
	entry function Vacuum_Orb_Entry()
	{
		Vacuum_Orb_Latent();
	}
	
	latent function Vacuum_Orb_Latent()
	{
		var entity : CEntity;
		var iceSpike : W3ACSChasoVacuumOrb;
		var spawnPos : Vector;
		var rotation : EulerAngles;
		
		spawnPos = GetACSTransformationVampiress().GetWorldPosition() + (GetACSTransformationVampiress().GetWorldForward() * 1.1) + GetACSTransformationVampiress().GetHeadingVector() * 5;

		spawnPos.Z += 1.1;

		rotation = GetWitcherPlayer().GetWorldRotation();

		rotation.Yaw = RandRangeF( 180.0, -180.0 );

		entity = (W3ACSChasoVacuumOrb)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\lillith_magic\chaos_vacuum_orb.w2ent", true ), ACSPlayerFixZAxis(spawnPos), rotation );

		iceSpike = (W3ACSChasoVacuumOrb)entity;

		if( iceSpike )
		{
			iceSpike.Appear();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Arena_Engage in cACS_Transformation_Vampiress
{
	var arena 											: W3ACSChaosArena;
	var duration										: float;
	var position, position2, position3					: Vector;
	var arenaApp1, arenaApp2 							: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Chaos_Arena();
	}
	
	entry function Chaos_Arena()
	{
		Chaos_Arena_Activate();
	}
	
	latent function Chaos_Arena_Activate()
	{
		duration = 30;

		GetACSChaosArena().Destroy();

		GetACSChaosArenaAppearance_01().Destroy();

		GetACSChaosArenaAppearance_02().Destroy();

		position = GetACSTransformationVampiress().GetWorldPosition();

		arena = (W3ACSChaosArena)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\lillith_magic\chaos_arena.w2ent" ,true ), ACSPlayerFixZAxis( position ), thePlayer.GetWorldRotation());

		arena.AddTimer('destroy_arena', duration, false );

		arena.AddTag('ACS_Chaos_Arena');




		position2 = ACSPlayerFixZAxis( position );

		position2.Z -= 2;



		GetACSChaosArenaAppearance_01().Destroy();

		arenaApp1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\lillith_magic\chaos_arena_appearance_01.w2ent" ,true ), position2, thePlayer.GetWorldRotation());

		//arenaApp1.CreateAttachment(arena);

		arenaApp1.AddTag('ACS_Chaos_Arena_Appearance_01');

		GetACSChaosArenaAppearance_02().Destroy();

		arenaApp2 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\lillith_magic\chaos_arena_appearance_02.w2ent" ,true ), position2, thePlayer.GetWorldRotation());

		//arenaApp2.CreateAttachment(arena);

		arenaApp2.AddTag('ACS_Chaos_Arena_Appearance_02');



		theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( position ), 1.f, duration, 1.f, 60.f, 1);
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Chaos_Drain_Engage in cACS_Transformation_Vampiress
{
	private var actors, victims																		: array<CActor>;
	private var i																					: int;
	private var npc 																				: CNewNPC;
	private var actor, actortarget 																	: CActor;
	private var initpos, targetPosition																: Vector;
	private var ent, anchor, anchor_2  																: CEntity;
	private var rot, attach_rot                        						 						: EulerAngles;
   	private var pos, attach_vec																		: Vector;
	private var meshcomp																			: CComponent;
	private var animcomp 																			: CAnimatedComponent;
	private var h 																					: float;
	private var bone_vec																			: Vector;
	private var bone_rot																			: EulerAngles;
	private var anchorTemplate, anchorTemplate2														: CEntityTemplate;
	private var randAngle, randRange																: float;
	private var playerPos, spawnPos																	: Vector;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		Chaos_Drain_Entry();
	}
	
	entry function Chaos_Drain_Entry()
	{
		Chaos_Drain_Latent();
	}
	
	latent function Chaos_Drain_Latent()
	{
		actors.Clear();
		
		//actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 3, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		actors = GetACSTransformationVampiress().GetNPCsAndPlayersInRange(20, 7, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors );

		if( actors.Size() > 0 )
		{
			thePlayer.GainStat( BCS_Vitality, thePlayer.GetStatMax( BCS_Vitality) * 0.33 );

			thePlayer.GainStat( BCS_Stamina, thePlayer.GetStatMax( BCS_Stamina) * 0.33 );

			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = (CNewNPC)actors[i];

				if (npc == GetACSTransformationVampiress()
				|| npc.HasTag('acs_snow_entity')
				|| npc.HasTag('smokeman') 
				|| npc.HasTag('ACS_Tentacle_1') 
				|| npc.HasTag('ACS_Tentacle_2') 
				|| npc.HasTag('ACS_Tentacle_3') 
				|| npc.HasTag('ACS_Necrofiend_Tentacle_1') 
				|| npc.HasTag('ACS_Necrofiend_Tentacle_2') 
				|| npc.HasTag('ACS_Necrofiend_Tentacle_3') 
				|| npc.HasTag('ACS_Necrofiend_Tentacle_6')
				|| npc.HasTag('ACS_Necrofiend_Tentacle_5')
				|| npc.HasTag('ACS_Necrofiend_Tentacle_4')
				|| npc.HasTag('ACS_Vampire_Monster_Boss_Bar') 
				|| npc.HasTag('ACS_Chaos_Cloud')
				|| npc.HasTag('ACS_Svalblod_Bossbar') 
				|| npc.HasTag('ACS_Melusine_Bossbar') 
				)
				continue;

				anchorTemplate = (CEntityTemplate)LoadResourceAsync( 
				
				"dlc\dlc_acs\data\fx\lillith_fx\health_drain.w2ent"
				
				, true );

				anchorTemplate2 = (CEntityTemplate)LoadResourceAsync( 
				
				"dlc\dlc_acs\data\entities\other\fx_dummy_entity.w2ent"
				
				, true );


				anchor = (CEntity)theGame.CreateEntity( anchorTemplate2, GetACSTransformationVampiress().GetWorldPosition() + Vector( 0, 0, -10 ) );

				anchor.CreateAttachment( GetACSTransformationVampiress(), 'r_weapon' );

				anchor.AddTag('ACS_Chaos_Life_Drain');

				anchor.DestroyAfter(10);



				anchor_2 = (CEntity)theGame.CreateEntity( anchorTemplate, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );

				anchor_2.CreateAttachment( npc, , Vector( 0, 0, 1.25 ), EulerAngles(0,0,0) );


				anchor_2.AddTag('ACS_Chaos_Life_Drain_Anchor');

				anchor_2.DestroyAfter(10);


				if (!npc.HasBuff( EET_Swarm ) )
				{
					npc.AddEffectDefault(EET_Swarm, thePlayer, 'ACS_Chaos_Drain_Buff ');
				}

				npc.DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ), 10 );

				anchor_2.StopEffect('drain_energy_1');
				anchor_2.PlayEffectSingle('drain_energy_1', anchor);

				anchor.PlayEffectSingle('hit_electric');
				anchor.StopEffect('hit_electric');
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function GetACSTransformationVampiress() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Transformation_Vampiress' );
	return entity;
}

function ACS_Vampiress_Fx_Dummy_Spawn_Left_No_Tether( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;
	var eff_names														: array<name>;

	thePlayer.SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_large");

	thePlayer.SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_small");

	if (GetACSTransformationVampiress().HasTag('ACS_Transformation_Bruxa'))
	{
		return;
	}

	if(RandF() < 0.5)
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\lillith_magic\chaos_red_slashes.w2ent"
			
		, true );

		pos.Z += 1.25;

		adjustedRot = thePlayer.GetWorldRotation();

		adjustedRot.Yaw += RandRangeF(360,1);
		adjustedRot.Pitch += RandRangeF(360,1);
		adjustedRot.Roll += RandRangeF( 360, 1 );
		
		ent = theGame.CreateEntity( temp, pos, adjustedRot );

		eff_names.Clear();

		eff_names.PushBack('diagonal_up_left');
		eff_names.PushBack('diagonal_down_left');
		eff_names.PushBack('left');

		ent.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent.DestroyAfter(1);
	}
}

function ACS_Vampiress_Fx_Dummy_Spawn_Left( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\lillith_magic\chaos_red_slashes.w2ent"
		
	, true );

	pos.Z += 1.25;

	adjustedRot = thePlayer.GetWorldRotation();

	adjustedRot.Yaw += RandRangeF(360,1);
	adjustedRot.Pitch += RandRangeF(360,1);
	adjustedRot.Roll += RandRangeF( 360, 1 );
	
	ent = theGame.CreateEntity( temp, pos, adjustedRot );

	ent.PlayEffectSingle('diagonal_up_left');
	ent.PlayEffectSingle('diagonal_down_left');
	ent.PlayEffectSingle('left');

	ent.DestroyAfter(1);

	//GetACSTransformationVampiress().PlayEffectSingle('lightning_l', ent );
	//GetACSTransformationVampiress().StopEffect('lightning_l');

	thePlayer.SoundEvent("magic_sorceress_vfx_arcane_explode");
}

function ACS_Vampiress_Fx_Dummy_Spawn_Right_No_Tether( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;
	var eff_names														: array<name>;

	thePlayer.SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_large");

	thePlayer.SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_small");

	if (GetACSTransformationVampiress().HasTag('ACS_Transformation_Bruxa'))
	{
		return;
	}

	if(RandF() < 0.5)
	{
		temp = (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\lillith_magic\chaos_red_slashes.w2ent"
			
		, true );

		pos.Z += 1.25;

		adjustedRot = thePlayer.GetWorldRotation();

		adjustedRot.Yaw += RandRangeF(360,1);
		adjustedRot.Pitch += RandRangeF(360,1);
		adjustedRot.Roll += RandRangeF( 360, 1 );
		
		ent = theGame.CreateEntity( temp, pos, adjustedRot );

		eff_names.Clear();

		eff_names.PushBack('diagonal_up_right');
		eff_names.PushBack('diagonal_down_right');
		eff_names.PushBack('right');

		ent.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent.DestroyAfter(1);
	}
}

function ACS_Vampiress_Fx_Dummy_Spawn_Right( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;

	temp = (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\lillith_magic\chaos_red_slashes.w2ent"
		
	, true );

	pos.Z += 1.25;

	adjustedRot = thePlayer.GetWorldRotation();

	adjustedRot.Yaw += RandRangeF(360,1);
	adjustedRot.Pitch += RandRangeF(360,1);
	adjustedRot.Roll += RandRangeF( 360, 1 );
	
	ent = theGame.CreateEntity( temp, pos, adjustedRot );

	ent.PlayEffectSingle('diagonal_up_right');
	ent.PlayEffectSingle('diagonal_down_right');
	ent.PlayEffectSingle('right');

	ent.DestroyAfter(1);

	//GetACSTransformationVampiress().PlayEffectSingle('lightning_r', ent );
	//GetACSTransformationVampiress().StopEffect('lightning_r');

	thePlayer.SoundEvent("magic_sorceress_vfx_arcane_explode");
}

function ACS_Vampiress_Fx_Dummy_Spawn( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;

	temp = (CEntityTemplate)LoadResource( 

	//"dlc\dlc_acs\data\entities\other\fx_dummy_entity.w2ent"

	//"gameplay\abilities\sorceresses\fx_dummy_entity.w2ent"

	"dlc\dlc_acs\data\entities\lillith_magic\chaos_red_slashes.w2ent"
		
	, true );

	pos.Z += 1.25;

	adjustedRot = thePlayer.GetWorldRotation();

	adjustedRot.Yaw += RandRangeF(360,1);
	adjustedRot.Pitch += RandRangeF(360,1);
	adjustedRot.Roll += RandRangeF( 360, 1 );
	
	ent = theGame.CreateEntity( temp, pos, adjustedRot );

	ent.PlayEffectSingle('diagonal_up_right');
	ent.PlayEffectSingle('diagonal_down_right');
	ent.PlayEffectSingle('right');
	ent.PlayEffectSingle('diagonal_up_left');
	ent.PlayEffectSingle('diagonal_down_left');
	ent.PlayEffectSingle('left');
	ent.PlayEffectSingle('up');
	ent.PlayEffectSingle('down');

	ent.DestroyAfter(1);

	GetACSTransformationVampiress().PlayEffectSingle('lightning', ent );
	GetACSTransformationVampiress().StopEffect('lightning');
}

function ACS_Vampiress_Fx_Dummy_Spawn_Both_Hands_No_Tether( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;
	var eff_names														: array<name>;

	thePlayer.SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_large");

	thePlayer.SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_small");

	if (GetACSTransformationVampiress().HasTag('ACS_Transformation_Bruxa'))
	{
		return;
	}

	if(RandF() < 0.5)
	{
		temp = (CEntityTemplate)LoadResource( 

		//"dlc\dlc_acs\data\entities\other\fx_dummy_entity.w2ent"

		//"gameplay\abilities\sorceresses\fx_dummy_entity.w2ent"

		"dlc\dlc_acs\data\entities\lillith_magic\chaos_red_slashes.w2ent"
			
		, true );

		pos.Z += 1.25;

		adjustedRot = thePlayer.GetWorldRotation();

		adjustedRot.Yaw += RandRangeF(360,1);
		adjustedRot.Pitch += RandRangeF(360,1);
		adjustedRot.Roll += RandRangeF( 360, 1 );
		
		ent = theGame.CreateEntity( temp, pos, adjustedRot );

		eff_names.Clear();

		eff_names.PushBack('diagonal_up_right');
		eff_names.PushBack('diagonal_down_right');
		eff_names.PushBack('right');
		eff_names.PushBack('diagonal_up_left');
		eff_names.PushBack('diagonal_down_left');
		eff_names.PushBack('left');
		eff_names.PushBack('up');
		eff_names.PushBack('down');

		ent.PlayEffectSingle(eff_names[RandRange(eff_names.Size())]);

		ent.DestroyAfter(1);
	}
}

function ACS_Vampiress_Fx_Dummy_Spawn_Both_Hands( npc : CActor, pos : Vector )
{
	var temp															: CEntityTemplate;
	var ent																: CEntity;
	var i, count														: int;
	var spawnPos														: Vector;
	var randAngle, randRange											: float;
	var meshcomp														: CComponent;
	var animcomp 														: CAnimatedComponent;
	var h 																: float;		
	var adjustedRot														: EulerAngles;

	temp = (CEntityTemplate)LoadResource( 

	//"dlc\dlc_acs\data\entities\other\fx_dummy_entity.w2ent"

	//"gameplay\abilities\sorceresses\fx_dummy_entity.w2ent"

	"dlc\dlc_acs\data\entities\lillith_magic\chaos_red_slashes.w2ent"
		
	, true );

	pos.Z += 1.25;

	adjustedRot = thePlayer.GetWorldRotation();

	adjustedRot.Yaw += RandRangeF(360,1);
	adjustedRot.Pitch += RandRangeF(360,1);
	adjustedRot.Roll += RandRangeF( 360, 1 );
	
	ent = theGame.CreateEntity( temp, pos, adjustedRot );

	ent.PlayEffectSingle('diagonal_up_right');
	ent.PlayEffectSingle('diagonal_down_right');
	ent.PlayEffectSingle('right');
	ent.PlayEffectSingle('diagonal_up_left');
	ent.PlayEffectSingle('diagonal_down_left');
	ent.PlayEffectSingle('left');
	ent.PlayEffectSingle('up');
	ent.PlayEffectSingle('down');

	ent.DestroyAfter(1);

	GetACSTransformationVampiress().PlayEffectSingle('lightning_r', ent );
	GetACSTransformationVampiress().StopEffect('lightning_r');

	GetACSTransformationVampiress().PlayEffectSingle('lightning_l', ent );
	GetACSTransformationVampiress().StopEffect('lightning_l');

	thePlayer.SoundEvent("magic_sorceress_vfx_arcane_explode");
}

function GetACSChaosMeteorSingle() : W3ACSChaosMeteorProjectile
{
	var entity 			 : W3ACSChaosMeteorProjectile;
	
	entity = (W3ACSChaosMeteorProjectile)theGame.GetEntityByTag( 'ACS_Chaos_Meteorite_Single' );
	return entity;
}

function GetACSChaosMagmaProj1() : W3ACSFireLine
{
	var entity 			 : W3ACSFireLine;
	
	entity = (W3ACSFireLine)theGame.GetEntityByTag( 'ACS_Magma_Line_1' );
	return entity;
}

function GetACSChaosMagmaProj2() : W3ACSRockLine
{
	var entity 			 : W3ACSRockLine;
	
	entity = (W3ACSRockLine)theGame.GetEntityByTag( 'ACS_Magma_Line_2' );
	return entity;
}

function GetACSChaosSnowballProj1() : W3ACSEredinFrostLine
{
	var entity 			 : W3ACSEredinFrostLine;
	
	entity = (W3ACSEredinFrostLine)theGame.GetEntityByTag( 'ACS_Snowball_Line_1' );
	return entity;
}

function GetACSChaosSnowballProj2() : W3WHMinionProjectile
{
	var entity 			 : W3WHMinionProjectile;
	
	entity = (W3WHMinionProjectile)theGame.GetEntityByTag( 'ACS_Snowball_Line_2' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Human_Ice_Breathe_Controller
{
    function ACS_Human_Ice_Breathe_Controller_Engage()
	{
		this.PushState('ACS_Human_Ice_Breathe_Controller_Engage');
	}
}

state ACS_Human_Ice_Breathe_Controller_Engage in cACS_Human_Ice_Breathe_Controller
{
	private var temp									: CEntityTemplate;
	private var controller								: CEntity;
	private var actors									: array<CActor>;
	//private var actors									: array<CGameplayEntity>;
	private var npc										: CActor;
	private var i, j									: int;
	private var voiceTagName 							: name;
	private var voiceTagStr								: string;
	private var appearanceName 							: name;
	private var appearanceStr							: string;
	private var bonePosition							: Vector;
	private var boneRotation							: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Human_Ice_Breathe_Controller_Entry();
	}
	
	entry function Human_Ice_Breathe_Controller_Entry()
	{	
		Human_Ice_Breathe_Controller_Latent();

		if (thePlayer.IsInInterior())
		{
			Remove_Weather_Facts();

			Remove_Skellige_Envs();

			GetACSSnowEntity().StopEffect('spiral_snow');
			GetACSSnowEntity().StopEffect('snow_dust');
			GetACSSnowEntity().StopEffect('slow_snow');
			GetACSSnowEntity().StopEffect('snow_low_fx');
			GetACSSnowEntity().StopEffect('snow_med_fx');
			GetACSSnowEntity().StopEffect('snow_low_fx_2');
			GetACSSnowEntity().StopEffect('snow_high_fx');
			GetACSSnowEntity().StopEffect('spiral_snow');
		}
		else
		{
			if (
			(thePlayer.HasTag('ACS_Wild_Hunt_Pursuit')
			&& ACSWildHuntRiders_CheckDistance())
			|| GetACSEredin() 
			|| GetACSCanaris()
			)
			{
				if (!GetACSSnowEntity().IsEffectActive('spiral_snow', false))
				{
					GetACSSnowEntity().PlayEffectSingle('spiral_snow');
				}

				Snow_Controller();
			}
			else
			{
				GetACSSnowEntity().StopEffect('spiral_snow');

				Snow_Controller();
			}
		}
	}

	latent function Snow_Controller()
	{
		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			if (GetWeatherConditionName() == 'WT_Clear')
			{
				if (FactsQuerySum("ACS_Skellige_Clear_No_Snow") > 0
				|| FactsQuerySum("ACS_Skellige_Clear_Low_Snow") > 0
				)
				{
					return;
				}

				if (RandF() < 0.5)
				{
					if (FactsQuerySum("ACS_Skellige_Clear_Low_Snow") <= 0)
					{
						Skellige_Normal_Env();

						GetACSSnowEntity().StopEffect('snow_dust');
						GetACSSnowEntity().StopEffect('slow_snow');
						GetACSSnowEntity().StopEffect('snow_med_fx');
						GetACSSnowEntity().StopEffect('snow_high_fx');

						if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
						{
							GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
						}

						if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
						{
							GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
						}

						FactsAdd("ACS_Skellige_Clear_Low_Snow");
					}
				}
				else
				{
					if (FactsQuerySum("ACS_Skellige_Clear_No_Snow") <= 0)
					{
						Skellige_Mid_Clouds_Env();

						GetACSSnowEntity().StopEffect('snow_dust');
						GetACSSnowEntity().StopEffect('slow_snow');
						GetACSSnowEntity().StopEffect('snow_low_fx');
						GetACSSnowEntity().StopEffect('snow_low_fx_2');
						GetACSSnowEntity().StopEffect('snow_med_fx');
						GetACSSnowEntity().StopEffect('snow_high_fx');

						FactsAdd("ACS_Skellige_Clear_No_Snow");
					}
				}
			}
			else
			{
				Remove_Weather_Facts();

				if (
				GetWeatherConditionName() == 'WT_Snow' 
				)
				{
					Skellige_Blizzard_Env();

					GetACSSnowEntity().StopEffect('snow_dust');
					GetACSSnowEntity().StopEffect('slow_snow');
					GetACSSnowEntity().StopEffect('snow_low_fx');
					GetACSSnowEntity().StopEffect('snow_low_fx_2');

					if (!GetACSSnowEntity().IsEffectActive('snow_high_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_high_fx');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
					}
				}
				else if (
				GetWeatherConditionName() == 'WT_Blizzard' 
				|| GetWeatherConditionName() == 'WT_Heavy_Snow' 
				)
				{
					Skellige_Blizzard_Env();

					if (!GetACSSnowEntity().IsEffectActive('snow_high_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_high_fx');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
					}

					if (!GetACSSnowEntity().IsEffectActive('slow_snow', false))
					{
						GetACSSnowEntity().PlayEffectSingle('slow_snow');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_dust', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_dust');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
					}
				}
				else if (
				GetWeatherConditionName() == 'WT_Wild_Hunt'
				|| GetWeatherConditionName() == 'WT_q501_Blizzard'
				|| GetWeatherConditionName() == 'WT_q501_Blizzard2'
				)
				{
					Skellige_Normal_Env();

					GetACSSnowEntity().StopEffect('snow_high_fx');

					GetACSSnowEntity().StopEffect('slow_snow');

					GetACSSnowEntity().StopEffect('snow_dust');

					if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
					}
				}
				else if (
				GetWeatherConditionName() == 'WT_Mid_Clouds'
				)
				{
					Skellige_Normal_Env();

					GetACSSnowEntity().StopEffect('snow_dust');
					GetACSSnowEntity().StopEffect('slow_snow');
					GetACSSnowEntity().StopEffect('snow_med_fx');
					GetACSSnowEntity().StopEffect('snow_low_fx_2');
					GetACSSnowEntity().StopEffect('snow_high_fx');

					if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
					}
				}
				else if (
				GetWeatherConditionName() == 'WT_Heavy_Clouds'
				)
				{
					Skellige_Rain_Storm_Env();

					GetACSSnowEntity().StopEffect('snow_dust');
					GetACSSnowEntity().StopEffect('slow_snow');
					GetACSSnowEntity().StopEffect('snow_med_fx');
					GetACSSnowEntity().StopEffect('snow_high_fx');

					if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
					}
				}
				else if (
				GetWeatherConditionName() == 'WT_Fog_Snow'
				|| GetWeatherConditionName() == 'WT_Mid_Clouds_Fog'
				)
				{
					Skellige_Blizzard_Env();

					GetACSSnowEntity().StopEffect('slow_snow');
					GetACSSnowEntity().StopEffect('snow_low_fx');
					GetACSSnowEntity().StopEffect('snow_low_fx_2');
					GetACSSnowEntity().StopEffect('snow_dust');

					if (!GetACSSnowEntity().IsEffectActive('snow_high_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_high_fx');
					}

					if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
					{
						GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
					}
				}
				else if (
				GetWeatherConditionName() == 'WT_Heavy_Clouds_Dark'
				)
				{
					Skellige_Heavy_Clouds_Dark_Env();

					GetACSSnowEntity().StopEffect('snow_dust');
					GetACSSnowEntity().StopEffect('slow_snow');
					GetACSSnowEntity().StopEffect('snow_low_fx');
					GetACSSnowEntity().StopEffect('snow_med_fx');
					GetACSSnowEntity().StopEffect('snow_low_fx_2');
					GetACSSnowEntity().StopEffect('snow_high_fx');
				}
				else if (
				GetWeatherConditionName() == 'WT_Rain_Storm'
				)
				{
					Skellige_Mid_Clouds_Env();

					GetACSSnowEntity().StopEffect('snow_dust');
					GetACSSnowEntity().StopEffect('slow_snow');
					GetACSSnowEntity().StopEffect('snow_low_fx');
					GetACSSnowEntity().StopEffect('snow_med_fx');
					GetACSSnowEntity().StopEffect('snow_low_fx_2');
					GetACSSnowEntity().StopEffect('snow_high_fx');
				}
				else
				{
					Skellige_Normal_Env();

					GetACSSnowEntity().StopEffect('snow_dust');
					GetACSSnowEntity().StopEffect('slow_snow');
					GetACSSnowEntity().StopEffect('snow_low_fx');
					GetACSSnowEntity().StopEffect('snow_med_fx');
					GetACSSnowEntity().StopEffect('snow_low_fx_2');
					GetACSSnowEntity().StopEffect('snow_high_fx');
				}
			}
		}
		else
		{
			Remove_Weather_Facts();

			Remove_Skellige_Envs();

			if (
			GetWeatherConditionName() == 'WT_Snow' 
			)
			{
				if (!GetACSSnowEntity().IsEffectActive('snow_high_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_high_fx');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
				}

				if (!GetACSSnowEntity().IsEffectActive('slow_snow', false))
				{
					GetACSSnowEntity().PlayEffectSingle('slow_snow');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_dust', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_dust');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
				}
			}
			else if (
			GetWeatherConditionName() == 'WT_Blizzard' 
			)
			{
				GetACSSnowEntity().StopEffect('snow_dust');
				GetACSSnowEntity().StopEffect('snow_low_fx');
				GetACSSnowEntity().StopEffect('snow_low_fx_2');
				GetACSSnowEntity().StopEffect('slow_snow');
				GetACSSnowEntity().StopEffect('snow_high_fx');

				if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
				}
			}
			else if (
			GetWeatherConditionName() == 'WT_Battle' 
			)
			{
				GetACSSnowEntity().StopEffect('snow_dust');
				GetACSSnowEntity().StopEffect('slow_snow');
				GetACSSnowEntity().StopEffect('snow_med_fx');
				GetACSSnowEntity().StopEffect('snow_high_fx');

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
				}
			}
			else if (
			GetWeatherConditionName() == 'WT_Battle_Forest'
			)
			{
				GetACSSnowEntity().StopEffect('snow_dust');
				GetACSSnowEntity().StopEffect('slow_snow');
				GetACSSnowEntity().StopEffect('snow_high_fx');

				if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
				}
			}
			else if (
			GetWeatherConditionName() == 'WT_Wild_Hunt'
			|| GetWeatherConditionName() == 'WT_q501_Blizzard'
			|| GetWeatherConditionName() == 'WT_q501_Blizzard2'
			)
			{
				GetACSSnowEntity().StopEffect('snow_high_fx');

				if (!GetACSSnowEntity().IsEffectActive('slow_snow', false))
				{
					GetACSSnowEntity().PlayEffectSingle('slow_snow');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_dust', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_dust');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_med_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_med_fx');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
				}

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
				}
			}
			else if (
			GetWeatherConditionName() == 'WT_q604_Snow'
			)
			{
				GetACSSnowEntity().StopEffect('snow_dust');
				GetACSSnowEntity().StopEffect('slow_snow');
				GetACSSnowEntity().StopEffect('snow_low_fx_2');
				GetACSSnowEntity().StopEffect('snow_med_fx');
				GetACSSnowEntity().StopEffect('snow_high_fx');

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx');
				}
			}
			else if (
			GetWeatherConditionName() == 'WT_Fog_Snow'
			)
			{
				GetACSSnowEntity().StopEffect('snow_dust');
				GetACSSnowEntity().StopEffect('slow_snow');
				GetACSSnowEntity().StopEffect('snow_low_fx');
				GetACSSnowEntity().StopEffect('snow_med_fx');
				GetACSSnowEntity().StopEffect('snow_high_fx');

				if (!GetACSSnowEntity().IsEffectActive('snow_low_fx_2', false))
				{
					GetACSSnowEntity().PlayEffectSingle('snow_low_fx_2');
				}
			}
			else
			{
				GetACSSnowEntity().StopEffect('snow_dust');
				GetACSSnowEntity().StopEffect('slow_snow');
				GetACSSnowEntity().StopEffect('snow_low_fx');
				GetACSSnowEntity().StopEffect('snow_med_fx');
				GetACSSnowEntity().StopEffect('snow_low_fx_2');
				GetACSSnowEntity().StopEffect('snow_high_fx');
			}
		}
	}

	latent function Skellige_Blizzard_Env()
	{
		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Heavy_Fog_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Dark_Env") > 0)
		{
			GetACSWatcher().Deactivate_Dark_Clouds_Heavy_Rain_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Dark_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Rain_Storm_Env") > 0)
		{
			GetACSWatcher().Deactivate_Rain_Storm_Env();

			FactsRemove("ACS_Skellige_Rain_Storm_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Mid_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Fog_Env();

			FactsRemove("ACS_Skellige_Mid_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Normal_Env") > 0)
		{
			GetACSWatcher().Deactivate_Normal_Skellige_Env();

			FactsRemove("ACS_Skellige_Normal_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Blizzard_Env") <= 0)
		{
			GetACSWatcher().Activate_Blizzard_Env();

			FactsAdd("ACS_Skellige_Blizzard_Env");
		}
	}

	latent function Skellige_Heavy_Clouds_Env()
	{
		if (FactsQuerySum("ACS_Skellige_Blizzard_Env") > 0)
		{
			GetACSWatcher().Deactivate_Blizzard_Env();

			FactsRemove("ACS_Skellige_Blizzard_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Dark_Env") > 0)
		{
			GetACSWatcher().Deactivate_Dark_Clouds_Heavy_Rain_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Dark_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Rain_Storm_Env") > 0)
		{
			GetACSWatcher().Deactivate_Rain_Storm_Env();

			FactsRemove("ACS_Skellige_Rain_Storm_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Mid_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Fog_Env();

			FactsRemove("ACS_Skellige_Mid_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Normal_Env") > 0)
		{
			GetACSWatcher().Deactivate_Normal_Skellige_Env();

			FactsRemove("ACS_Skellige_Normal_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Env") <= 0)
		{
			GetACSWatcher().Activate_Heavy_Fog_Env();

			FactsAdd("ACS_Skellige_Heavy_Clouds_Env");
		}
	}

	latent function Skellige_Heavy_Clouds_Dark_Env()
	{
		if (FactsQuerySum("ACS_Skellige_Blizzard_Env") > 0)
		{
			GetACSWatcher().Deactivate_Blizzard_Env();

			FactsRemove("ACS_Skellige_Blizzard_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Heavy_Fog_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Rain_Storm_Env") > 0)
		{
			GetACSWatcher().Deactivate_Rain_Storm_Env();

			FactsRemove("ACS_Skellige_Rain_Storm_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Mid_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Fog_Env();

			FactsRemove("ACS_Skellige_Mid_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Normal_Env") > 0)
		{
			GetACSWatcher().Deactivate_Normal_Skellige_Env();

			FactsRemove("ACS_Skellige_Normal_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Dark_Env") <= 0)
		{
			GetACSWatcher().Activate_Dark_Clouds_Heavy_Rain_Env();

			FactsAdd("ACS_Skellige_Heavy_Clouds_Dark_Env");
		}
	}

	latent function Skellige_Rain_Storm_Env()
	{
		if (FactsQuerySum("ACS_Skellige_Blizzard_Env") > 0)
		{
			GetACSWatcher().Deactivate_Blizzard_Env();

			FactsRemove("ACS_Skellige_Blizzard_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Heavy_Fog_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Dark_Env") > 0)
		{
			GetACSWatcher().Deactivate_Dark_Clouds_Heavy_Rain_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Dark_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Mid_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Fog_Env();

			FactsRemove("ACS_Skellige_Mid_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Normal_Env") > 0)
		{
			GetACSWatcher().Deactivate_Normal_Skellige_Env();

			FactsRemove("ACS_Skellige_Normal_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Rain_Storm_Env") <= 0)
		{
			GetACSWatcher().Activate_Rain_Storm_Env();

			FactsAdd("ACS_Skellige_Rain_Storm_Env");
		}
	}

	latent function Skellige_Mid_Clouds_Env()
	{
		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Dark_Env") > 0)
		{
			GetACSWatcher().Deactivate_Dark_Clouds_Heavy_Rain_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Dark_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Heavy_Fog_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Blizzard_Env") > 0)
		{
			GetACSWatcher().Deactivate_Blizzard_Env();

			FactsRemove("ACS_Skellige_Blizzard_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Rain_Storm_Env") > 0)
		{
			GetACSWatcher().Deactivate_Rain_Storm_Env();

			FactsRemove("ACS_Skellige_Rain_Storm_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Normal_Env") > 0)
		{
			GetACSWatcher().Deactivate_Normal_Skellige_Env();

			FactsRemove("ACS_Skellige_Normal_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Mid_Clouds_Env") <= 0)
		{
			GetACSWatcher().Activate_Fog_Env();

			FactsAdd("ACS_Skellige_Mid_Clouds_Env");
		}
	}

	latent function Skellige_Normal_Env()
	{
		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Dark_Env") > 0)
		{
			GetACSWatcher().Deactivate_Dark_Clouds_Heavy_Rain_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Dark_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Heavy_Fog_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Blizzard_Env") > 0)
		{
			GetACSWatcher().Deactivate_Blizzard_Env();

			FactsRemove("ACS_Skellige_Blizzard_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Rain_Storm_Env") > 0)
		{
			GetACSWatcher().Deactivate_Rain_Storm_Env();

			FactsRemove("ACS_Skellige_Rain_Storm_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Mid_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Fog_Env();

			FactsRemove("ACS_Skellige_Mid_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Normal_Env") <= 0)
		{
			GetACSWatcher().Activate_Normal_Skellige_Env();

			FactsAdd("ACS_Skellige_Normal_Env");
		}
	}
	
	latent function Remove_Skellige_Envs()
	{
		if (FactsQuerySum("ACS_Skellige_Blizzard_Env") > 0)
		{
			GetACSWatcher().Deactivate_Blizzard_Env();

			FactsRemove("ACS_Skellige_Blizzard_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Heavy_Fog_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Heavy_Clouds_Dark_Env") > 0)
		{
			GetACSWatcher().Deactivate_Dark_Clouds_Heavy_Rain_Env();

			FactsRemove("ACS_Skellige_Heavy_Clouds_Dark_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Rain_Storm_Env") > 0)
		{
			GetACSWatcher().Deactivate_Rain_Storm_Env();

			FactsRemove("ACS_Skellige_Rain_Storm_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Mid_Clouds_Env") > 0)
		{
			GetACSWatcher().Deactivate_Fog_Env();

			FactsRemove("ACS_Skellige_Mid_Clouds_Env");
		}

		if (FactsQuerySum("ACS_Skellige_Normal_Env") > 0)
		{
			GetACSWatcher().Deactivate_Normal_Skellige_Env();

			FactsRemove("ACS_Skellige_Normal_Env");
		}
	}

	latent function Remove_Weather_Facts()
	{
		if (FactsQuerySum("ACS_Skellige_Clear_No_Snow") > 0)
		{
			FactsRemove("ACS_Skellige_Clear_No_Snow");
		}

		if (FactsQuerySum("ACS_Skellige_Clear_Low_Snow") > 0)
		{
			FactsRemove("ACS_Skellige_Clear_Low_Snow");
		}
	}

	latent function Human_Ice_Breathe_Controller_Latent()
	{
		if (
		theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Island_of_Myst 
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Prologue_Village_Winter 
		|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Kaer_Morhen
		|| GetWeatherConditionName() == 'WT_Snow' 
		|| GetWeatherConditionName() == 'WT_Blizzard' 
		|| GetWeatherConditionName() == 'WT_Battle' 
		|| GetWeatherConditionName() == 'WT_Battle_Forest'
		|| GetWeatherConditionName() == 'WT_Mid_Clouds_Fog'
		|| GetWeatherConditionName() == 'WT_Wild_Hunt'
		|| GetWeatherConditionName() == 'WT_q501_Blizzard'
		|| GetWeatherConditionName() == 'WT_q501_Storm'
		|| GetWeatherConditionName() == 'WT_q501_Blizzard2'
		|| GetWeatherConditionName() == 'WT_q604_Snow'
		|| GetWeatherConditionName() == 'WT_Fog'
		|| GetWeatherConditionName() == 'WT_Light_Fog' 
		|| GetWeatherConditionName() == 'WT_Fog_Windy' 
		|| GetWeatherConditionName() == 'WT_Fog_Snow' 
		|| GetWeatherConditionName() == 'WT_Fog_Heavy' 
		|| GetWeatherConditionName() == 'WT_Cold' 
		|| GetWeatherConditionName() == 'WT_Cold_Clouds'
		|| GetWeatherConditionName() == 'WT_Cold_BOB'
		|| GetWeatherConditionName() == 'fog1' 
		|| GetWeatherConditionName() == 'fog2' 
		|| GetWeatherConditionName() == 'flurry1' 
		|| GetWeatherConditionName() == 'flurry2' 
		|| GetWeatherConditionName() == 'flurry3' 
		|| GetWeatherConditionName() == 'flurry4' 
		|| GetWeatherConditionName() == 'snow1' 
		|| GetWeatherConditionName() == 'snow2' 
		|| GetWeatherConditionName() == 'snow3' 
		|| GetWeatherConditionName() == 'snow4' 
		|| GetWeatherConditionName() == 'snow5' 
		|| GetWeatherConditionName() == 'snow6'
		|| GetWeatherConditionName() == 'blizzard'
		|| GetWeatherConditionName() == 'LightSnow' 
		|| GetWeatherConditionName() == 'MidCloudsSnow' 
		|| GetWeatherConditionName() == 'Snow' 
		|| GetWeatherConditionName() == 'SnowWhite' 
		|| GetWeatherConditionName() == 'Blizzard'
		)
		{
			if (thePlayer.GetVisibility())
			{
				if (thePlayer.IsInInterior())
				{
					if (ACS_FireSourceCheck(thePlayer))
					{
						thePlayer.DestroyEffect('ice_breath_gameplay_indoor');
					}
					else
					{
						if (!thePlayer.IsEffectActive('ice_breath_gameplay_indoor', false))
						{
							thePlayer.PlayEffectSingle('ice_breath_gameplay_indoor');
						}
					}
				}
				else
				{
					if (!thePlayer.IsEffectActive('ice_breath_gameplay', false))
					{
						thePlayer.PlayEffectSingle('ice_breath_gameplay');
					}
				}
			}

			actors.Clear();

			actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer );

			//actors.Clear();

			//FindGameplayEntitiesInRange(actors, GetACSWatcher(), 20, 100, '', FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

			if( actors.Size() > 0 )
			{
				for( i = 0; i < actors.Size(); i += 1 )
				{
					npc = actors[i];

					voiceTagName =  npc.GetVoicetag();
					voiceTagStr = NameToString( voiceTagName );
					
					appearanceName =  npc.GetAppearance();
					appearanceStr = NameToString( appearanceName );
					
					if(
					npc.IsHuman()
					|| npc.IsMan()
					|| npc.IsWoman()
					|| StrFindFirst(voiceTagStr, "BOY") >= 0
					|| StrFindFirst(voiceTagStr, "GIRL") >= 0
					|| StrFindFirst(appearanceStr, "BOY") >= 0
					|| StrFindFirst(appearanceStr, "GIRL") >= 0
					)
					{
						if 
						( 
						npc.HasTag('ACS_Ice_Breathe_Controller_Added') 
						)
						{
							continue;
						}

						if (!npc.HasTag('ACS_Ice_Breathe_Controller_Added'))
						{
							temp = (CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\fx\acs_ice_breathe.w2ent"
							
							, true );

							if(
							npc.IsWoman()
							)
							{
								npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'hroll' ), bonePosition, boneRotation );
								controller = (CEntity)theGame.CreateEntity( temp, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );
								controller.CreateAttachmentAtBoneWS( npc, 'hroll', bonePosition, boneRotation );
							}
							else
							{
								npc.GetBoneWorldPositionAndRotationByIndex( npc.GetBoneIndex( 'head' ), bonePosition, boneRotation );
								controller = (CEntity)theGame.CreateEntity( temp, npc.GetWorldPosition() + Vector( 0, 0, -10 ) );
								controller.CreateAttachmentAtBoneWS( npc, 'head', bonePosition, boneRotation );
							}

							controller.AddTag('ACS_Ice_Breathe_Controller');

							npc.AddTag('ACS_Ice_Breathe_Controller_Added');
						}
					}
					else if (((CNewNPC)npc).IsHorse())
					{
						if (npc.IsAlive()
						&& npc.GetVisibility())
						{
							if (!npc.HasTag('ACS_Ice_Breathe_Horse'))
							{
								if (!npc.IsEffectActive('breath_fx_cutscene', false))
								{
									npc.PlayEffectSingle('breath_fx_cutscene');
								}

								npc.AddTag('ACS_Ice_Breathe_Horse');
							}
						}
						else
						{
							if (npc.HasTag('ACS_Ice_Breathe_Horse'))
							{
								npc.DestroyEffect('breath_fx_cutscene');

								npc.RemoveTag('ACS_Ice_Breathe_Horse');
							}
						}
					}
					else
					{
						continue;
					}
				}
			}
			else
			{
				return;
			}
		}
		else
		{
			if (!theGame.IsDialogOrCutscenePlaying() 
			&& !thePlayer.IsInNonGameplayCutscene() 
			&& !thePlayer.IsInGameplayScene() 
			&& !theGame.IsCurrentlyPlayingNonGameplayScene())
			{
				thePlayer.DestroyEffect('ice_breath_gameplay_indoor');
				thePlayer.DestroyEffect('ice_breath_gameplay');
			}
			
			ACS_Ice_Breathe_Destroy();

			ACS_Ice_Breathe_Entity_RemoveTag();
		}
	}
}

function ACS_FireSourceCheck ( checkedActor: CActor ): bool 
{
    var entities: array<CGameplayEntity>;

	entities.Clear();

    FindGameplayEntitiesInRange(entities, checkedActor, 3, 1, , FLAG_ExcludePlayer, , 'W3FireSource');
	{
		if (entities.Size()>0)
		{
			return true;
		}
	}

    return false;
}

function ACS_Ice_Breathe_Destroy()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Ice_Breathe_Controller', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACS_Ice_Breathe_Entity_RemoveTag()
{	
	var ents, ents_2 										: array<CEntity>;
	var i, j												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Ice_Breathe_Controller_Added', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].DestroyEffect('ice_breath');

		ents[i].DestroyEffect('ice_breath_gameplay');

		ents[i].RemoveTag('ACS_Ice_Breathe_Controller_Added');
	}


	ents_2.Clear();

	theGame.GetEntitiesByTag( 'ACS_Ice_Breathe_Horse', ents_2 );	
	
	for( j = 0; j < ents_2.Size(); j += 1 )
	{
		ents_2[j].DestroyEffect('breath_fx_cutscene');

		ents_2[j].RemoveTag('ACS_Ice_Breathe_Horse');
	}
}

class CACSIceBreatheController extends CEntity
{
	private var ents  									: array<CGameplayEntity>;
	private var temp									: CEntityTemplate;
	private var controller								: CEntity;
	private var actors									: array<CActor>;
	private var actor									: CActor;
	private var i										: int;
	private var voiceTagName 							: name;
	private var voiceTagStr								: string;
	private var appearanceName 							: name;
	private var appearanceStr							: string;
	private var bonePosition							: Vector;
	private var boneRotation							: EulerAngles;
	
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('AliveCheckTimer', 0.01, true);
	}
	
	timer function AliveCheckTimer ( dt : float, id : int)
	{ 
		AliveCheck();
	}

	function AliveCheck()
	{
		ents.Clear();

		FindGameplayEntitiesCloseToPoint(ents, this.GetWorldPosition(), 0.01, 1, ,FLAG_ExcludePlayer, ,);

		//FindGameplayEntitiesInRange(ents, this, 0.01, 1, ,FLAG_ExcludePlayer );
		
		for( i = 0; i < ents.Size(); i += 1 )
		{
			if( ents.Size() > 0 )
			{
				actor = (CActor) ents[i];

				voiceTagName =  actor.GetVoicetag();
				voiceTagStr = NameToString( voiceTagName );
				
				appearanceName =  actor.GetAppearance();
				appearanceStr = NameToString( appearanceName );

				if (
				theGame.GetCommonMapManager().GetCurrentArea() == AN_Skellige_ArdSkellig 
				|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Island_of_Myst 
				|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Prologue_Village_Winter 
				|| theGame.GetCommonMapManager().GetCurrentArea() == AN_Kaer_Morhen
				|| GetWeatherConditionName() == 'WT_Snow' 
				|| GetWeatherConditionName() == 'WT_Blizzard' 
				|| GetWeatherConditionName() == 'WT_Battle' 
				|| GetWeatherConditionName() == 'WT_Battle_Forest'
				|| GetWeatherConditionName() == 'WT_Mid_Clouds_Fog'
				|| GetWeatherConditionName() == 'WT_Wild_Hunt'
				|| GetWeatherConditionName() == 'WT_q501_Blizzard'
				|| GetWeatherConditionName() == 'WT_q501_Storm'
				|| GetWeatherConditionName() == 'WT_q501_Blizzard2'
				|| GetWeatherConditionName() == 'WT_q604_Snow'
				|| GetWeatherConditionName() == 'WT_Fog'
				|| GetWeatherConditionName() == 'WT_Light_Fog' 
				|| GetWeatherConditionName() == 'WT_Fog_Windy' 
				|| GetWeatherConditionName() == 'WT_Fog_Snow' 
				|| GetWeatherConditionName() == 'WT_Fog_Heavy' 
				|| GetWeatherConditionName() == 'WT_Cold' 
				|| GetWeatherConditionName() == 'WT_Cold_Clouds'
				|| GetWeatherConditionName() == 'WT_Cold_BOB'
				|| GetWeatherConditionName() == 'fog1' 
				|| GetWeatherConditionName() == 'fog2' 
				|| GetWeatherConditionName() == 'flurry1' 
				|| GetWeatherConditionName() == 'flurry2' 
				|| GetWeatherConditionName() == 'flurry3' 
				|| GetWeatherConditionName() == 'flurry4' 
				|| GetWeatherConditionName() == 'snow1' 
				|| GetWeatherConditionName() == 'snow2' 
				|| GetWeatherConditionName() == 'snow3' 
				|| GetWeatherConditionName() == 'snow4' 
				|| GetWeatherConditionName() == 'snow5' 
				|| GetWeatherConditionName() == 'snow6'
				|| GetWeatherConditionName() == 'blizzard'
				|| GetWeatherConditionName() == 'LightSnow' 
				|| GetWeatherConditionName() == 'MidCloudsSnow' 
				|| GetWeatherConditionName() == 'Snow' 
				|| GetWeatherConditionName() == 'SnowWhite' 
				|| GetWeatherConditionName() == 'Blizzard'
				)
				{	
					if(
					actor.IsHuman()
					|| actor.IsMan()
					|| actor.IsWoman()
					|| StrFindFirst(voiceTagStr, "BOY") >= 0
					|| StrFindFirst(voiceTagStr, "GIRL") >= 0
					|| StrFindFirst(appearanceStr, "BOY") >= 0
					|| StrFindFirst(appearanceStr, "GIRL") >= 0
					)
					{
						if (actor.IsAlive())
						{
							if (((CNewNPC)actor).IsInInterior())
							{
								if (ACS_FireSourceCheck(actor))
								{
									this.DestroyEffect('ice_breath_gameplay');

									actor.DestroyEffect('ice_breath');

									actor.DestroyEffect('ice_breath_gameplay');
								}
								else
								{
									if (!this.IsEffectActive('ice_breath_gameplay', false))
									{
										this.PlayEffectSingle('ice_breath_gameplay');
									}

									if (!actor.IsEffectActive('ice_breath', false))
									{
										actor.PlayEffectSingle('ice_breath');
									}

									if (!actor.IsEffectActive('ice_breath_gameplay', false))
									{
										actor.PlayEffectSingle('ice_breath_gameplay');
									}
								}
							}
							else
							{
								if (!actor.IsEffectActive('ice_breath', false))
								{
									actor.PlayEffectSingle('ice_breath');
								}

								if (!actor.IsEffectActive('ice_breath_gameplay', false))
								{
									actor.PlayEffectSingle('ice_breath_gameplay');
								}

								if (!this.IsEffectActive('ice_breath_gameplay', false))
								{
									this.PlayEffectSingle('ice_breath_gameplay');
								}

								if (!this.IsEffectActive('ice_breath', false))
								{
									this.PlayEffectSingle('ice_breath');
								}
							}
						}
						else
						{
							actor.DestroyEffect('ice_breath');

							actor.DestroyEffect('ice_breath_gameplay');

							this.DestroyEffect('ice_breath_gameplay_indoor');
							this.DestroyEffect('ice_breath_gameplay');
						}
					}
				}
				else
				{
					this.DestroyEffect('ice_breath_gameplay_indoor');
					this.DestroyEffect('ice_breath_gameplay');
				}
			}
			else
			{
				this.DestroyEffect('ice_breath_gameplay_indoor');
				this.DestroyEffect('ice_breath_gameplay');
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSSnowEntity() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_snow_entity' );
	return entity;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_EtherSword_Summon
{
	function EtherSword_Spawner_Engage()
	{
		this.PushState('EtherSword_Spawner_Engage');
	}
}

state EtherSword_Spawner_Engage in cACS_EtherSword_Summon
{
	private var trail_temp													: CEntityTemplate;
	private var sword_trail_1												: CEntity;

	event OnEnterState(prevStateName : name)
	{
		EtherSword_Spawner_Entry();
	}
	
	entry function EtherSword_Spawner_Entry()
	{	
		EtherSword_Spawn_Latent();
	}

	latent function EtherSword_Spawn_Latent()
	{
		GetACSArmorEtherSword().Destroy();
		
		if (!GetACSArmorEtherSword())
		{
			ACS_HideSwordWitoutScabbardStuff();

			trail_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_enemy_sword_trail.w2ent" , true );

			sword_trail_1 = (CEntity)theGame.CreateEntity( trail_temp, thePlayer.GetWorldPosition() + Vector( 0, 0, -20 ) );

			sword_trail_1.CreateAttachment( thePlayer, 'r_weapon');

			sword_trail_1.AddTag( 'ACS_Armor_Ether_Sword' );

			sword_trail_1.PlayEffectSingle('special_attack_charged_iris');

			//sword_trail_1.PlayEffectSingle('red_runeword_igni_1');

			//sword_trail_1.PlayEffectSingle('red_runeword_igni_2');

			sword_trail_1.PlayEffectSingle('runeword1_fire_trail');

			sword_trail_1.PlayEffectSingle('runeword1_fire_trail_2');

			sword_trail_1.PlayEffectSingle('fire_sparks_trail');

			sword_trail_1.PlayEffectSingle('red_fast_attack_buff');

			sword_trail_1.PlayEffectSingle('red_fast_attack_buff_hit');

			if (ACS_Armor_Omega_Equipped_Check())
			{
				if(GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
				{
					sword_trail_1.PlayEffectSingle('soul_edge_glow');
				}
				else if(GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					sword_trail_1.PlayEffectSingle('war_sword_glow');
				}
			}
			else if (ACS_Armor_Alpha_Equipped_Check())
			{
				if(GetWitcherPlayer().IsWeaponHeld( 'silversword' ) )
				{
					sword_trail_1.PlayEffectSingle('doomsword_amasii_glow');
				}
				else if(GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
				{
					sword_trail_1.PlayEffectSingle('andurial_glow');
				}
			} 

			//sword_trail_1.PlayEffectSingle('arrow_trail_fire');

			//sword_trail_1.PlayEffectSingle('arrow_trail_fire_2');

			//thePlayer.SoundEvent("magic_sorceress_vfx_lightning_fx_loop_start");
		}

		//sword_trail_1.DestroyAfter(10);
	}

}

function GetACSArmorEtherSword() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Armor_Ether_Sword' );
	return entity;
}

function ACSMeditationCampfire() : W3Campfire
{
	var entity 			 : W3Campfire;
	
	entity = (W3Campfire)theGame.GetEntityByTag( 'ACS_Meditation_Campfire' );
	return entity;
}

function ACS_GPS_Entity() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_GPS_Entity' );
	return entity;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Red_Blade_Projectile_Fire
{
    function ACS_Red_Blade_Projectile_Engage()
	{
		this.PushState('ACS_Red_Blade_Projectile_Engage');
	}
}

state ACS_Red_Blade_Projectile_Engage in cACS_Red_Blade_Projectile_Fire
{
	private var proj_1								: ACSBladeProjectile;
	private var initpos, newpos, targetPosition		: Vector;
	private var portal_ent							: CEntity;
	private var actor								: CActor; 
	private var actors		    					: array<CActor>;
	private var i									: int;
	private var npc									: CNewNPC;
	private var blade_temp, portal_temp				: CEntityTemplate;
	private var playerRot, adjustedRot				: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		Red_Blade_Projectile_Entry();
	}
	
	entry function Red_Blade_Projectile_Entry()
	{	
		Red_Blade_Projectile_Latent();
	}

	latent function Red_Blade_Projectile_Latent()
	{
		thePlayer.SoundEvent("fx_rune_activate_igni");

		portal_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\portal.w2ent", true );
		
		blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent", true );

		initpos = GetWitcherPlayer().GetWorldPosition() + (GetWitcherPlayer().GetHeadingVector() * RandRangeF(2, -2)) + (GetWitcherPlayer().GetWorldRight() * RandRangeF(7, -7)) ;	
		initpos.Z += RandRangeF(7, 2.25);

		playerRot = thePlayer.GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		portal_ent = (CEntity)theGame.CreateEntity( portal_temp, initpos, adjustedRot );

		portal_ent.PlayEffectSingle('teleport');

		proj_1 = (ACSBladeProjectile)theGame.CreateEntity( blade_temp, initpos );
								
		proj_1.Init(thePlayer);

		if (ACS_Armor_Alpha_Equipped_Check())
		{
			portal_ent.DestroyAfter(7);
		}
		else if (ACS_Armor_Omega_Equipped_Check())
		{
			portal_ent.DestroyAfter(2);
		}

		if(thePlayer.IsInCombat())
		{
			if ( thePlayer.IsHardLockEnabled() )
			{
				targetPosition = ((CActor)( thePlayer.GetDisplayTarget() )).PredictWorldPosition(0.35f);

				if (ACS_Armor_Alpha_Equipped_Check())
				{
					targetPosition.Z += 0.75;
				}
				else if (ACS_Armor_Omega_Equipped_Check())
				{
					targetPosition.Z += 1.1;
				}
			}
			else
			{
				targetPosition = ((CActor)( thePlayer.moveTarget )).PredictWorldPosition(0.35f);
				
				if (ACS_Armor_Alpha_Equipped_Check())
				{
					targetPosition.Z += 0.75;
				}
				else if (ACS_Armor_Omega_Equipped_Check())
				{
					targetPosition.Z += 1.1;
				}

				/*
				actors.Clear();

				actors = thePlayer.GetNPCsAndPlayersInRange( 50, 1, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer + FLAG_Attitude_Hostile);

				if( actors.Size() > 0 )
				{
					for( i = 0; i < actors.Size(); i += 1 )
					{
						npc = (CNewNPC)actors[i];

						actor = actors[i];

						targetPosition = actor.PredictWorldPosition(0.35f);
						
						if (ACS_Armor_Alpha_Equipped_Check())
						{
							targetPosition.Z += 0.25;
						}
						else if (ACS_Armor_Omega_Equipped_Check())
						{
							targetPosition.Z += 1.1;
						}
					}
				}
				*/
			}
		}
		else
		{
			targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector() * 30;
			targetPosition.Z -= 5;
		}

		proj_1.ShootProjectileAtPosition( 0, RandRangeF(25,10), targetPosition, 500 );
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSGuidingLightMarker() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Guiding_Light_Marker' );
	return entity;
}

function GetACSGuidingLightPOIMarker() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Guiding_Light_POI_Marker' );
	return entity;
}

function GetACSGuidingLightAvailableQuestMarker() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Guiding_Light_Available_Quest_Marker' );
	return entity;
}

function GetACSGuidingLightUserPinMarker() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Guiding_Light_User_Pin_Marker' );
	return entity;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Throw_Knife
{
    function ACS_Throw_Knife_Engage()
	{
		this.PushState('ACS_Throw_Knife_Engage');
	}
}

state ACS_Throw_Knife_Engage in cACS_Throw_Knife
{
	private var proj_1								: W3ACSKnifeProjectile;
	private var initpos, newpos, targetPosition		: Vector;
	private var blade_temp							: CEntityTemplate;
	private var actor								: CActor;

	event OnEnterState(prevStateName : name)
	{
		Throw_Knife_Entry();
	}
	
	entry function Throw_Knife_Entry()
	{	
		Throw_Knife_Latent();
	}

	latent function Throw_Knife_Latent()
	{
		blade_temp = (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\acs_knife_projectile.w2ent", true );

		initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector();	
		initpos.Z += 1.1;

		proj_1 = (W3ACSKnifeProjectile)theGame.CreateEntity( blade_temp, initpos );
								
		proj_1.Init(thePlayer);

		actor = ((CActor)( thePlayer.GetDisplayTarget() ));

		if( ACS_AttitudeCheck ( actor ) && GetWitcherPlayer().IsInCombat() && actor.IsAlive() )
		{
			if ( actor.GetBoneIndex('head') != -1 )
			{
				targetPosition = actor.GetBoneWorldPosition('head');
				targetPosition.Z += RandRangeF(0,-0.5);
				targetPosition.X += RandRangeF(0.125,-0.125);
			}
			else
			{
				targetPosition = actor.GetBoneWorldPosition('k_head_g');
				targetPosition.Z += RandRangeF(0,-0.5);
				targetPosition.X += RandRangeF(0.125,-0.125);
			}
		}
		else
		{
			targetPosition = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 30;

			targetPosition.Z += 1.25;
		}

		proj_1.ShootProjectileAtPosition( 0, 15, targetPosition, 500 );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSUseableItem() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'ACS_Useable_Item' );
	return entity;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Construct_Summon
{
    function Construct_Summon_Engage()
	{
		this.PushState('Construct_Summon_Engage');
	}
}

state Construct_Summon_Engage in cACS_Construct_Summon
{
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Construct_Summon_Entry();
	}
	
	entry function Construct_Summon_Entry()
	{
		if (!GetACSSummonedConstruct_1())
		{
			acsspawnconstruct1();
		}

		if (!GetACSSummonedConstruct_2())
		{
			acsspawnconstruct2();
		}
	}
	
	latent function acsspawnconstruct1()
	{
		var temp, temp_2, temp_3, ent_1_temp, trail_temp					: CEntityTemplate;
		var ent, ent_2, ent_3, sword_trail_1, l_anchor, r_blade1, l_blade1	: CEntity;
		var i, count														: int;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
		var animatedComponentA												: CAnimatedComponent;

		GetACSSummonedConstruct_1().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\detlaff_construct_summon.w2ent"

		//"dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\detlaff_construct.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraRight() * -2 + VecFromHeading(theCamera.GetCameraHeading()) * 2;

		playerRot = thePlayer.GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		//playerRot.Yaw += 180;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 0.8;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		//((CNewNPC)ent).SetAttitude(thePlayer, AIA_Friendly);

		//thePlayer.SetAttitude(((CNewNPC)ent), AIA_Friendly);

		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffectSingle('dive_shape');
		ent.StopEffect('dive_shape');

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		((CActor)ent).SetCanPlayHitAnim(false); 
		//((CActor)ent).AddBuffImmunity_AllNegative('ACS_Summoned_Construct_1', true); 

		((CActor)ent).AddEffectDefault( EET_AxiiGuardMe, thePlayer, 'ACS_Summoned_Construct_Buff', false );

		ent.AddTag( 'ACS_Summoned_Construct_1' );

		animatedComponentA = (CAnimatedComponent)(((CNewNPC)ent)).GetComponentByClassName( 'CAnimatedComponent' );	

		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_resurrection', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
	}

	latent function acsspawnconstruct2()
	{
		var temp															: CEntityTemplate;
		var ent																: CEntity;
		var playerPos, spawnPos												: Vector;
		var randAngle, randRange											: float;
		var meshcomp														: CComponent;
		var animcomp 														: CAnimatedComponent;
		var h 																: float;
		var bone_vec, pos, attach_vec										: Vector;
		var bone_rot, rot, attach_rot, playerRot, adjustedRot				: EulerAngles;
		var animatedComponentA												: CAnimatedComponent;
			
		GetACSSummonedConstruct_2().Destroy();

		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\entities\monsters\detlaff_construct_summon.w2ent"

		//"dlc\bob\data\quests\main_quests\quest_files\q704_truth\characters\detlaff_construct.w2ent"
			
		, true );

		playerPos = theCamera.GetCameraPosition() + theCamera.GetCameraRight() * 2 + VecFromHeading(theCamera.GetCameraHeading()) * 2;

		playerRot = thePlayer.GetWorldRotation();

		adjustedRot = EulerAngles(0,0,0);

		adjustedRot.Yaw = playerRot.Yaw;

		//playerRot.Yaw += 180;
		
		ent = theGame.CreateEntity( temp, ACSPlayerFixZAxis(playerPos), adjustedRot );

		animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
		meshcomp = ent.GetComponentByClassName('CMeshComponent');
		h = 0.8;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		((CNewNPC)ent).SetLevel(thePlayer.GetLevel());

		//((CNewNPC)ent).SetAttitude(thePlayer, AIA_Friendly);

		//thePlayer.SetAttitude(((CNewNPC)ent), AIA_Friendly);

		((CNewNPC)ent).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

		((CActor)ent).SetAnimationSpeedMultiplier(1);

		ent.PlayEffectSingle('dive_shape');
		ent.StopEffect('dive_shape');

		((CActor)ent).SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 
		((CActor)ent).SetCanPlayHitAnim(false); 
		//((CActor)ent).AddBuffImmunity_AllNegative('ACS_Summoned_Construct_2', true); 

		((CActor)ent).AddEffectDefault( EET_AxiiGuardMe, thePlayer, 'ACS_Summoned_Construct_Buff', false );

		ent.AddTag( 'ACS_Summoned_Construct_2' );

		animatedComponentA = (CAnimatedComponent)(((CNewNPC)ent)).GetComponentByClassName( 'CAnimatedComponent' );	

		animatedComponentA.PlaySlotAnimationAsync ( 'dettlaff_construct_resurrection', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}


function GetACSSummonedConstruct_1() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Summoned_Construct_1' );
	return entity;
}

function GetACSSummonedConstruct_2() : CActor
{
	var entity 			 : CActor;
	
	entity = (CActor)theGame.GetEntityByTag( 'ACS_Summoned_Construct_2' );
	return entity;
}

function GetACSSummonedConstruct1Follow()
{
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;
	var actor																												: CActor; 
	var actors		    																									: array<CActor>;
	var i																													: int;
	var npc																													: CNewNPC;

	if (!GetACSSummonedConstruct_1())
	{
		return;
	}

	targetDistance = VecDistanceSquared2D( GetACSSummonedConstruct_1().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	movementAdjustorNPC = GetACSSummonedConstruct_1().GetMovingAgentComponent().GetMovementAdjustor();

	thePlayer.SetAttitude(GetACSSummonedConstruct_1(), AIA_Friendly);

	GetACSSummonedConstruct_1().SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

	ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Summoned_Construct_Rotate');
	movementAdjustorNPC.CancelByName( 'ACS_Summoned_Construct_Rotate' );

	ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Summoned_Construct_Rotate' );
	movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
	movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

	if (!GetACSSummonedConstruct_1().IsInCombat())
	{
		if (targetDistance <= 2 * 2)
		{
			GetACSSummonedConstruct_1().GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0);
		}
		else if (targetDistance > 2 * 2 && targetDistance <= 15 * 15)
		{
			movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

			GetACSSummonedConstruct_1().GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(2);
		}
		else if (targetDistance > 15 * 15 && GetWitcherPlayer().IsOnGround())
		{
			if (!GetACSSummonedConstruct_1().IsEffectActive('shadowdash_body_blood', false))
			{
				GetACSSummonedConstruct_1().PlayEffectSingle('shadowdash_body_blood');
			}

			if (!GetACSSummonedConstruct_1().HasTag('ACS_Summoned_Construct_Teleport_Start'))
			{
				GetACSSummonedConstruct_1().PlayEffectSingle('shadowdash');
				GetACSSummonedConstruct_1().StopEffect('shadowdash');

				GetACSWatcher().RemoveTimer('SummonedConstruct1TeleportDelay');
				GetACSWatcher().AddTimer('SummonedConstruct1TeleportDelay', 0.5, false);

				GetACSSummonedConstruct_1().AddTag('ACS_Summoned_Construct_Teleport_Start');
			}
		} 
	}

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 25, 20, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		GetACSSummonedConstruct_1().GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0);

		if (!GetACSSummonedConstruct_1().IsEffectActive('claws_trail', false))
		{
			GetACSSummonedConstruct_1().PlayEffectSingle('claws_trail');
		}

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			GetACSSummonedConstruct_1().SetAttitude(actor, AIA_Hostile);

			actor.SetAttitude(GetACSSummonedConstruct_1(), AIA_Hostile);
		}
	}
	
	if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
	{
		if (targetDistance > 35 * 35 && GetWitcherPlayer().IsOnGround())
		{
			if (!GetACSSummonedConstruct_1().IsEffectActive('shadowdash_body_blood', false))
			{
				GetACSSummonedConstruct_1().PlayEffectSingle('shadowdash_body_blood');
			}

			if (!GetACSSummonedConstruct_1().HasTag('ACS_Summoned_Construct_Teleport_Start'))
			{
				GetACSSummonedConstruct_1().PlayEffectSingle('shadowdash');
				GetACSSummonedConstruct_1().StopEffect('shadowdash');

				GetACSWatcher().RemoveTimer('SummonedConstruct1TeleportDelay');
				GetACSWatcher().AddTimer('SummonedConstruct1TeleportDelay', 0.5, false);

				GetACSSummonedConstruct_1().AddTag('ACS_Summoned_Construct_Teleport_Start');
			}
		}
	}
}

function GetACSSummonedConstruct2Follow()
{
	var movementAdjustorNPC																									: CMovementAdjustor; 
	var ticketNPC 																											: SMovementAdjustmentRequestTicket; 
	var targetDistance																										: float;
	var actor																												: CActor; 
	var actors		    																									: array<CActor>;
	var i																													: int;
	var npc																													: CNewNPC;

	if (!GetACSSummonedConstruct_2())
	{
		return;
	}

	targetDistance = VecDistanceSquared2D( GetACSSummonedConstruct_2().GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

	movementAdjustorNPC = GetACSSummonedConstruct_2().GetMovingAgentComponent().GetMovementAdjustor();

	thePlayer.SetAttitude(GetACSSummonedConstruct_2(), AIA_Friendly);

	GetACSSummonedConstruct_2().SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

	ticketNPC = movementAdjustorNPC.GetRequest( 'ACS_Summoned_Construct_Rotate');
	movementAdjustorNPC.CancelByName( 'ACS_Summoned_Construct_Rotate' );

	ticketNPC = movementAdjustorNPC.CreateNewRequest( 'ACS_Summoned_Construct_Rotate' );
	movementAdjustorNPC.AdjustmentDuration( ticketNPC, 0.25 );
	movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticketNPC, 500000 );

	if (!GetACSSummonedConstruct_2().IsInCombat())
	{
		if (targetDistance <= 2 * 2)
		{
			GetACSSummonedConstruct_2().GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0);
		}
		else if (targetDistance > 2 * 2 && targetDistance <= 15 * 15)
		{
			movementAdjustorNPC.RotateTowards( ticketNPC, GetWitcherPlayer() );

			GetACSSummonedConstruct_2().GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(2);
		}
		else if (targetDistance > 15 * 15 && GetWitcherPlayer().IsOnGround())
		{
			if (!GetACSSummonedConstruct_2().IsEffectActive('shadowdash_body_blood', false))
			{
				GetACSSummonedConstruct_2().PlayEffectSingle('shadowdash_body_blood');
			}

			if (!GetACSSummonedConstruct_2().HasTag('ACS_Summoned_Construct_Teleport_Start'))
			{
				GetACSSummonedConstruct_2().PlayEffectSingle('shadowdash');
				GetACSSummonedConstruct_2().StopEffect('shadowdash');

				GetACSWatcher().RemoveTimer('SummonedConstruct2TeleportDelay');
				GetACSWatcher().AddTimer('SummonedConstruct2TeleportDelay', 0.5, false);

				GetACSSummonedConstruct_2().AddTag('ACS_Summoned_Construct_Teleport_Start');
			}
		} 
	}

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 25, 20, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		GetACSSummonedConstruct_2().GetMovingAgentComponent().SetGameplayRelativeMoveSpeed(0);

		if (!GetACSSummonedConstruct_2().IsEffectActive('claws_trail', false))
		{
			GetACSSummonedConstruct_2().PlayEffectSingle('claws_trail');
		}

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			GetACSSummonedConstruct_2().SetAttitude(actor, AIA_Hostile);

			actor.SetAttitude(GetACSSummonedConstruct_2(), AIA_Hostile);
		}
	}

	if (thePlayer.IsInCombat() || thePlayer.IsThreatened())
	{
		if (targetDistance > 35 * 35 && GetWitcherPlayer().IsOnGround())
		{
			if (!GetACSSummonedConstruct_2().IsEffectActive('shadowdash_body_blood', false))
			{
				GetACSSummonedConstruct_2().PlayEffectSingle('shadowdash_body_blood');
			}

			if (!GetACSSummonedConstruct_2().HasTag('ACS_Summoned_Construct_Teleport_Start'))
			{
				GetACSSummonedConstruct_2().PlayEffectSingle('shadowdash');
				GetACSSummonedConstruct_2().StopEffect('shadowdash');

				GetACSWatcher().RemoveTimer('SummonedConstruct2TeleportDelay');
				GetACSWatcher().AddTimer('SummonedConstruct2TeleportDelay', 0.5, false);

				GetACSSummonedConstruct_2().AddTag('ACS_Summoned_Construct_Teleport_Start');
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Fog_Check() : bool
{
	if (
	(
	GetWeatherConditionName() != 'WT_Rain_Heavy' 
	&& GetWeatherConditionName() != 'WT_Rain_Dark' 
	&& GetWeatherConditionName() != 'WT_Rain_Storm' 
	&& ACS_FogSpawn_Enabled()
	)
	&& !thePlayer.IsInInterior()
	)
	{
		return true;
	}

	return false;
}

function ACS_Fog_Generate()
{
	var vACS_Fog_Generate : cACS_Fog_Generate;
	vACS_Fog_Generate = new cACS_Fog_Generate in theGame;
	
	if (ACS_Fog_Check()
	&& ACS_IsFogTime()
	&& theGame.GetWorld().GetDepotPath() != "dlc\bob\data\levels\bob\bob.w2w"
	)
	{
		if (ACS_fog_ent_spawn() 
		&& !thePlayer.IsInCombat() 
		&& !thePlayer.IsThreatened())
		{
			ACS_refresh_fog_ent_spawn_cooldown();

			vACS_Fog_Generate.Fog_Generate_Engage();
		}
	}
	else
	{
		ACSDestroyFogEnts();
	}
}

statemachine class cACS_Fog_Generate
{
    function Fog_Generate_Engage()
	{
		this.PushState('Fog_Generate_Engage');
	}
}

state Fog_Generate_Engage in cACS_Fog_Generate
{
	var temp																	: CEntityTemplate;
	var ent																		: CEntity;
	var i, count_1, j, count_2													: int;
	var initPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos			: Vector;
	var randAngle, randRange, distance											: float;
	var meshcomp																: CComponent;
	var animcomp 																: CAnimatedComponent;
	var h 																		: float;
	var bone_vec, pos, attach_vec												: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot									: EulerAngles;
	var world																	: CWorld;
	var l_groundZ																: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Fog_Generate();
	}
	
	entry function Fog_Generate()
	{
		Fog_Generate_Latent();
	}
	
	latent function Fog_Generate_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"dlc\dlc_acs\data\fx\fog_ent.w2ent"
			
		, true );

		initPos = ACSPlayerFixZAxis(theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * RandRangeF(60,20));

		playerRot = EulerAngles(0,0,0);

		playerRot.Yaw += RandRange(360,0);
		
		count_1 = RandRange(6,3);

		if (!ACS_PlayerSettlementCheck(50))
		{
			distance = RandRangeF(60, 30);
		}
		else
		{
			distance = RandRangeF(100, 70);
		}

		world = theGame.GetWorld();
			
		for( i = 0; i < count_1; i += 1 )
		{
			randRange = distance + distance * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + initPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + initPos.Y;
			spawnPos.Z = initPos.Z;

			posAdjusted = ACSPlayerFixZAxis(spawnPos);

			count_2 = RandRange(3,1);

			for( j = 0; j < count_2; j += 1 )
			{
				randRange = distance + distance * RandF();
				randAngle = 2 * Pi() * RandF();
				
				spawnPos2.X = randRange * CosF( randAngle ) + posAdjusted.X;
				spawnPos2.Y = randRange * SinF( randAngle ) + posAdjusted.Y;
				spawnPos2.Z = posAdjusted.Z;

				posAdjusted2 = ACSPlayerFixZAxis(spawnPos2);

				ent = theGame.CreateEntity( temp, posAdjusted2, adjustedRot );

				if (RandF() < 0.5)
				{
					if (RandF() < 0.5)
					{
						ent.PlayEffectSingle('fog_1');
						ent.PlayEffectSingle('fog_2');
						ent.PlayEffectSingle('fog_3');
						ent.PlayEffectSingle('fog_4');
					}
					else
					{
						ent.PlayEffectSingle('fog_7');
						ent.PlayEffectSingle('fog_8');
						ent.PlayEffectSingle('fog_9');
						ent.PlayEffectSingle('fog_10');
					}
				}
				else
				{
					if (RandF() < 0.5)
					{
						ent.PlayEffectSingle('fog_1');
						ent.PlayEffectSingle('fog_2');
						ent.PlayEffectSingle('fog_3');
						ent.PlayEffectSingle('fog_4');
					}
					else
					{
						ent.PlayEffectSingle('fog_11');
						ent.PlayEffectSingle('fog_12');
						ent.PlayEffectSingle('fog_13');
						ent.PlayEffectSingle('fog_14');
					}
				}
				
				//ent.PlayEffectSingle('fog_5');
				//ent.PlayEffectSingle('fog_6');

				ent.DestroyAfter(240);

				ent.AddTag('ACS_Fog_Ent');
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACSDestroyFogEnts()
{	
	var ents 											: array<CEntity>;
	var i												: int;

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Fog_Ent', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Volumetric_Clouds
{
    function Volumetric_Clouds_Engage()
	{
		if ((theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"))
		{
			this.PushState('Volumetric_Clouds_Engage');
		}
	}
}

state Volumetric_Clouds_Engage in cACS_Volumetric_Clouds
{
	var cloudArray : array<CEntity>;
	var cameraPos : Vector;
	var cameraRot, adjustedRot : EulerAngles;
	var rot : EulerAngles;
	var effectName : CName;
	var template : CEntityTemplate;
	var cloudEnt : CEntity;
	var cloudRotationArray : array<EulerAngles>; // Array holding the rotation of volumetric clouds (direction in which they spawn)
	var cloudLocationArray : array<Vector>; // Array holding the locations of volumetric clouds
	var cloudTypeArray : array<CName>; // Array holding the type of cloud to be used for each cloud
	var sizeCloudArray,idx : int;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Volumetric_Clouds();
	}
	
	entry function Volumetric_Clouds()
	{
		Volumetric_Clouds_Latent();
	}
	
	latent function Volumetric_Clouds_Latent()
	{
		rot.Pitch = 350;
		rot.Yaw = 260;
		rot.Roll = 0;

		template = (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\fx\volumetric_clouds.w2ent", true);

		// EulerAngles(Pitch, Yaw, Roll);
	
		////////////////////////////////////////// Cloud definition start //////////////////////////////////////////////
		
		// Ard Skellig
		cloudLocationArray.PushBack(Vector(-218,492,40)); // Hill near Kaer Trolde
		cloudRotationArray.PushBack(rot);
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-120,745,120)); // Kaer Trolde bridge waypoint, Z=70: below the bridge, Z=110: above the bridge
		cloudRotationArray.PushBack(EulerAngles(360,290,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-64,-690,255)); // Mountain peak close to Kaer Muire (northern Side) 
		cloudRotationArray.PushBack(rot);
		cloudTypeArray.PushBack('cloudsUp');
		
		
		cloudLocationArray.PushBack(Vector(-190,-814,240)); // Mountain side facing Undvik northwest of Kaer Muire 
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(-312,660,110)); // Western mountain peak close to Kaer Trolde Bridge (southern Side)
		cloudRotationArray.PushBack(EulerAngles(350,80,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(-297,988,214)); // Western mountain peak close to Kaer Trolde Bridge (northwestern Side near summit)
		cloudRotationArray.PushBack(EulerAngles(350,360,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(-359,790,102)); // West coast mountain front northwest of Kaer Trolde 
		cloudRotationArray.PushBack(EulerAngles(350,90,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(22,886,153)); // Northern coast mountain front northeastern peak of Kaer Trolde bridge
		cloudRotationArray.PushBack(EulerAngles(350,15,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(159,890,72)); // Northern coast mountain front mid high above ancient crypt
		cloudRotationArray.PushBack(EulerAngles(350,15,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(647,834,135)); // Northern coast mountain front east of the mountain top near ancient crypt
		cloudRotationArray.PushBack(EulerAngles(360,10,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(800,632,138)); // Eastern mountain front near Kaer Gelen
		cloudRotationArray.PushBack(EulerAngles(360,340,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(1327,245,84)); // East coast outlook east of Gedyneith
		cloudRotationArray.PushBack(EulerAngles(360,293,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		//cloudLocationArray.PushBack(Vector(1186,-409,43)); // East coast southeastern mountain low
		cloudLocationArray.PushBack(Vector(1141,-400,80));
		cloudRotationArray.PushBack(EulerAngles(48,230,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(1148,-467,109)); // East coast southeastern mountain higher up
		cloudRotationArray.PushBack(EulerAngles(48,230,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(1139,-494,160)); // East coast southeastern mountain top
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(1019,-702,149)); // South coast southeastern mountain south side close to cave entrance
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(1158,-631,110)); // South coast southeastern mountain midway up above Grotto east
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(876,-752,102)); // South coast southeastern mountain midway up above Grotto west
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(1195,104,76)); // East coast eastern mountain front southeast of Gedyneith and northeast of druids' camp
		cloudRotationArray.PushBack(EulerAngles(270,280,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-222,622,50)); // Western mountain close to Kaer Trolde Bridge (lower part)
		cloudRotationArray.PushBack(EulerAngles(320,280,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(87,511,100)); // Mountain front east of Kaer Trolde harbor
		//cloudRotationArray.PushBack(EulerAngles(350,290,0)); 
		cloudRotationArray.PushBack(EulerAngles(350,260,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		//////////////////////////////////////////////////////////////////// Testing distant clouds start /////////////////////////////////////////////////////////////////////////////////
		
		cloudLocationArray.PushBack(Vector(-312,409,270)); // Western mountain peak close to Kaer Trolde Bridge (southern Side)
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('cloudsHuge');
		
		//////////////////////////////////////////////////////////////////// Testing distant clouds end /////////////////////////////////////////////////////////////////////////////////
		
		cloudLocationArray.PushBack(Vector(426,802,170)); // Mountain top east of ancient crypt
		cloudRotationArray.PushBack(EulerAngles(360,360,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(70,-627,130)); // Mountains west of Fyresdal (low)
		cloudRotationArray.PushBack(EulerAngles(330,325,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(151,-627,85)); // Mountains west of Fyresdal (low, bit further north)
		cloudRotationArray.PushBack(EulerAngles(360,315,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(243,-616,85)); // Mountains west of Fyresdal (low, bit further north2)
		cloudRotationArray.PushBack(EulerAngles(360,325,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(190,-930,130)); // Mountains southwest of Fyresdal (low)
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(122,-879,160)); // Mountains west of Fyresdal (high)
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(24,-773,241)); // Mountains west of Fyresdal (peak)
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(1053,-526,177)); // Mountain peak east of Fyresdal (high)
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(913,-676,181)); // Mountain peak east of Fyresdal (high, western peak)
		cloudRotationArray.PushBack(EulerAngles(360,280,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(871,-585,151)); // Mountain peak east of Fyresdal (lower on western side)
		cloudRotationArray.PushBack(EulerAngles(280,175,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(453,-124,98)); // Mountains east of Boxholm, western side
		cloudRotationArray.PushBack(EulerAngles(360,245,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(497,-124,98)); // Mountains east of Boxholm, eastern side
		cloudRotationArray.PushBack(EulerAngles(360,245,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		// Undvik
		
		//////////////////////// ice fog ////////////////////////////
		//cloudLocationArray.PushBack(Vector(-1361,-48,1.67)); // 1. Most eastern rock wall near eastern coast of Undvik, northern part
		cloudLocationArray.PushBack(Vector(-1361,-48,1.5));
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1386,37,1.5)); // 2. Most eastern rock wall near eastern coast of Undvik, southern part
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1528,-149,1.5)); // 3. Big rock wall west of 1., southern end
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1574,-79,1.5)); // 4. Big rock wall west of 1., northern end
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1760,-201,1.5)); // 5. Small rock north of northern harbor
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1561,-291,1.5)); // 6. Small island with shipwreck east of northern harbor
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1863,43,1.5)); // 7. Northern most bigger rock, northeast of Undvik tower
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1665,-311,1.5)); // 8. Rock directly east of northern harbor
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1653,-364,1.5)); // 9. Small rock southeast of northern harbor
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1354,-414,1.5)); // 10. Eastern most bigger island with two shipwrecks -> southeastern end
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		cloudLocationArray.PushBack(Vector(-1408,-286,1.5)); // 11. Eastern most bigger island with two shipwrecks -> northern end
		cloudRotationArray.PushBack(EulerAngles(0,0,0));
		cloudTypeArray.PushBack('iceFog');
		
		//////////////////////// ice fog ////////////////////////////
		
		cloudLocationArray.PushBack(Vector(-1950,-916,95)); // Mountain west low
		cloudRotationArray.PushBack(rot);
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-1619,-907,158)); // Mountain east low
		cloudRotationArray.PushBack(EulerAngles(360,175,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-1508,-1058,135)); // Mountain eastern front facing Kaer Muire
		cloudRotationArray.PushBack(rot);
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(-1561,-980,192)); // Mountain eastern front facing Kaer Muire higher
		cloudRotationArray.PushBack(rot);
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(-1738,-1023,210)); // Mountain center high
		cloudRotationArray.PushBack(rot);
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(-1791,-943,145)); // Mountain center low
		cloudRotationArray.PushBack(EulerAngles(360,175,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-2149,-138,110)); // Tower northwest northern side
		cloudRotationArray.PushBack(EulerAngles(360,350,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		// Spiekeroog
		cloudLocationArray.PushBack(Vector(-1698,1497,55)); // SOD mountain old house up hill
		cloudRotationArray.PushBack(EulerAngles(350,190,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-1793,1434,115)); // SOD mountain platform near top
		cloudRotationArray.PushBack(EulerAngles(340,290,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		cloudLocationArray.PushBack(Vector(-1743,1360,85)); // SOD mountain front west of Svorlag
		cloudRotationArray.PushBack(EulerAngles(285,256,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-1744,1407,55)); // SOD mountain front west of Svorlag - lower part
		cloudRotationArray.PushBack(EulerAngles(330,238,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		
		cloudLocationArray.PushBack(Vector(-1592,1499,15)); // SOD mountain foot west of small lake in northern part of Spiekeroog
		cloudRotationArray.PushBack(rot);
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-1911,1171,90)); // Mountain peak south of SOD mountain west of Old Watchtower
		cloudRotationArray.PushBack(EulerAngles(350,234,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-1751,1176,73)); // Lower mountain south of Old Watchtower
		cloudRotationArray.PushBack(EulerAngles(10,234,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-3168,1778,79)); // Background mountains west of Spiekeroog
		cloudRotationArray.PushBack(EulerAngles(360,80,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(-3228,1233,107)); // Background mountains west of Spiekeroog south top
		cloudRotationArray.PushBack(EulerAngles(360,80,0));
		cloudTypeArray.PushBack('cloudsUp');
		
		// Larvik
		cloudLocationArray.PushBack(Vector(2524,60,79)); // Mountain east of Lofoten cemetry northwestern side
		cloudRotationArray.PushBack(EulerAngles(360,320,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(2533,30,90)); // Mountain east of Lofoten cemetry southeastern peak
		cloudRotationArray.PushBack(EulerAngles(360,320,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		cloudLocationArray.PushBack(Vector(2535,1274,49)); // Small island with large shipwreck north of Larvik
		cloudRotationArray.PushBack(EulerAngles(360,16,0));
		cloudTypeArray.PushBack('cloudsTerrain');
		
		////////////////////////////////////////// Cloud definition end //////////////////////////////////////////////
		
		sizeCloudArray = cloudLocationArray.Size();
		for(idx = 0; idx < sizeCloudArray; idx+=1){
		
			cloudEnt = theGame.CreateEntity(template, cloudLocationArray[idx], cloudRotationArray[idx]);
			
			effectName=cloudTypeArray[idx];
			
			cloudEnt.PlayEffectSingle(effectName);
			cloudArray.PushBack(cloudEnt); 
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSSpiralSky() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_spiral_entity' );
	return entity;
}

function GetACSSpiralSkyStars() : CEntity
{
	var entity 			 : CEntity;
	
	entity = (CEntity)theGame.GetEntityByTag( 'acs_spiral_star_entity' );
	return entity;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Startup_Entity_Spawns
{
    function Startup_Entities_Engage()
	{
		this.PushState('Startup_Entities_Engage');
	}
}

state Startup_Entities_Engage in cACS_Startup_Entity_Spawns
{
	event OnEnterState(prevStateName : name)
	{
		Entity_Spawn_Entry();
	}
	
	entry function Entity_Spawn_Entry()
	{
		LookatSpawn();

		SnowSpawn();

		if (theGame.GetWorld().GetDepotPath() == "levels\the_spiral\spiral.w2w"
		|| theGame.GetWorld().GetDepotPath() == "levels\island_of_mist\island_of_mist.w2w"
		)
		{
			return;
		}

		SpiralSkySpawn();

		SpiralStarSpawn();
	}
	
	latent function LookatSpawn()
	{
		var temp : CEntityTemplate;
		var pos : Vector;
		var rot : EulerAngles;
		var headtarget : CEntity;

		temp = (CEntityTemplate) LoadResource( "fx_dummy_entity" );
		pos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 7;
		rot = VecToRotation(thePlayer.GetWorldPosition() - pos);
		headtarget = theGame.CreateEntity(temp, pos, rot);

		((CActor)headtarget).SetImmortalityMode( AIM_Invulnerable, AIC_Default ); 
		((CActor)headtarget).SetCanPlayHitAnim(false); 
		((CActor)headtarget).AddBuffImmunity_AllNegative('acs_lookat_entity_buff', true); 

		headtarget.AddTag('acs_lookat_entity');

		((CActor)thePlayer).DisableLookAt();
		((CActor)thePlayer).EnableDynamicLookAt(GetACSLookatEntity(), 65535);
	}

	latent function SnowSpawn()
	{
		var temp : CEntityTemplate;
		var pos : Vector;
		var rot : EulerAngles;
		var snow_ent : CEntity;

		temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true);

		snow_ent = theGame.CreateEntity(temp, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation());

		snow_ent.CreateAttachment( thePlayer, 'blood_point', Vector( 0, 0, 0 ), EulerAngles(0,0,90) );

		((CActor)snow_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default ); 
		((CActor)snow_ent).SetCanPlayHitAnim(false); 
		((CActor)snow_ent).AddBuffImmunity_AllNegative('acs_snow_entity_buff_all_negative', true); 
		((CActor)snow_ent).AddBuffImmunity_AllCritical('acs_snow_entity_buff_all_critical', true); 

		snow_ent.AddTag('acs_snow_entity');
	}

	latent function SpiralSkySpawn()
	{
		var spiral_ent          : CEntity;
		var spiral_temp         : CEntityTemplate;
		var spiral_rotation		: EulerAngles;
		var spiral_vector		: Vector;

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"
		|| theGame.GetWorld().GetDepotPath() == "levels\skellige\skellige.w2w"
		)
		{
			spiral_rotation = EulerAngles(0,45,0);

			spiral_vector = Vector(0,0,0,1);
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			spiral_rotation = EulerAngles(0,180,0);

			spiral_vector = Vector(0,0,0,1);
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w"
		)
		{
			spiral_rotation = EulerAngles(0,45,0);

			spiral_vector = Vector(0,750,0,1);
		}
		else
		{
			spiral_rotation = EulerAngles(0,180,0);

			spiral_vector = Vector(0,0,0,1);
		}

		spiral_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true);
		
		spiral_ent = theGame.CreateEntity(spiral_temp, spiral_vector, spiral_rotation);
		
		((CActor)spiral_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default ); 
		((CActor)spiral_ent).SetCanPlayHitAnim(false); 
		((CActor)spiral_ent).AddBuffImmunity_AllNegative('acs_spiral_entity_buff_all_negative', true); 
		((CActor)spiral_ent).AddBuffImmunity_AllCritical('acs_spiral_entity_buff_all_critical', true); 

		if (ACS_SpiralSkyPlanets_Enabled())
		{
			spiral_ent.PlayEffectSingle('spiral_sky_original');

			spiral_ent.PlayEffectSingle('spiral_sky_red');

			if (theGame.GetWorld().GetDepotPath() != "levels\skellige\skellige.w2w"
			)
			{
				//spiral_ent.PlayEffectSingle('spiral_sky_original_second_moon');

				//spiral_ent.PlayEffectSingle('spiral_sky_red_second_moon');
			}
		}

		//spiral_ent.PlayEffectSingle('meteors');

		//spiral_ent.PlayEffect('spiral_sky_secondary');

		//spiral_ent.PlayEffect('spiral_sky');

		if (ACS_SpiralSkyBands_Enabled())
		{
			spiral_ent.PlayEffectSingle('spiral_sky_original_bands');

			spiral_ent.PlayEffectSingle('spiral_sky_red_bands');

			//spiral_ent.PlayEffect('spiral_sky_secondary_bands');
		}

		spiral_ent.AddTag('acs_spiral_entity');
	}

	latent function SpiralStarSpawn()
	{
		var spiral_star_ent         	: CEntity;
		var spiral_star_temp        	: CEntityTemplate;
		var spiral_star_rotation		: EulerAngles;

		if (theGame.GetWorld().GetDepotPath() == "levels\novigrad\novigrad.w2w"
		)
		{
			spiral_star_rotation = EulerAngles(0,60,0);
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\prolog_village_winter\prolog_village.w2w"
		|| theGame.GetWorld().GetDepotPath() == "levels\prolog_village\prolog_village.w2w"
		)
		{
			spiral_star_rotation = EulerAngles(0,165,0);
		}
		else if (theGame.GetWorld().GetDepotPath() == "dlc\bob\data\levels\bob\bob.w2w")
		{
			spiral_star_rotation = EulerAngles(0,195,0);
		}
		else if (theGame.GetWorld().GetDepotPath() == "levels\kaer_morhen\kaer_morhen.w2w"
		)
		{
			spiral_star_rotation = EulerAngles(0,240,0);
		}
		else
		{
			spiral_star_rotation = EulerAngles(0,195,0);
		}

		spiral_star_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true);

		spiral_star_ent = theGame.CreateEntity(spiral_star_temp, Vector(0,0,50), spiral_star_rotation);

		((CActor)spiral_star_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default ); 
		((CActor)spiral_star_ent).SetCanPlayHitAnim(false); 
		((CActor)spiral_star_ent).AddBuffImmunity_AllNegative('acs_spiral_entity_buff_all_negative', true); 
		((CActor)spiral_star_ent).AddBuffImmunity_AllCritical('acs_spiral_entity_buff_all_critical', true); 

		if (ACS_IsNight_Adjustable())
		{
			if (FactsQuerySum("ACS_Darkness_Upon_Us") > 0)
			{
				if (ACS_SpiralSkyStars_Enabled())
				{
					spiral_star_ent.PlayEffectSingle('stars');
				}
			}
		}

		spiral_star_ent.AddTag('acs_spiral_star_entity');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
function ACS_IDD_INIT()
{
	var vACS_IDD : cACS_IDD;
	vACS_IDD = new cACS_IDD in theGame;

	vACS_IDD.IDD_Engage();
}

statemachine class cACS_IDD
{
    function IDD_Engage()
	{
		this.PushState('IDD_Engage');
	}
}

state IDD_Engage in cACS_IDD
{
	var id : string;
	var mesh : CMesh;
	var res : CResource;
	var i, j : int;
	var meshName : string;
	var data: C2dArray;				
	var world: CGameWorld;
	var meshes: array<CMesh>;
	var tempFloat : float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);

		IDD_Entry();
	}
	
	entry function IDD_Entry()
	{
		IDD_Latent();
	}
	
	latent function IDD_Latent()
	{
		world = (CGameWorld)theGame.GetWorld();

		data = LoadCSV("dlc\dlc_acs\data\csv\meshes.csv");

		for(i = 0; i < data.GetNumRows(); i+=1)
		{							
			meshName = data.GetValueAt(0,i);			
			
			if (
				StrContains(meshName, "dlc1") || 
				StrContains(meshName, "dlc2") ||
				StrContains(meshName, "dlc3") ||				
				StrContains(meshName, "dlc4") ||
				StrContains(meshName, "dlc5") ||
				StrContains(meshName, "dlc6") ||
				StrContains(meshName, "dlc7") ||
				StrContains(meshName, "dlc8") ||
				StrContains(meshName, "ep1") ||
				StrContains(meshName, "dlc9") ||
				StrContains(meshName, "dlc10") ||
				StrContains(meshName, "dlc11") ||
				StrContains(meshName, "dlc12") ||
				StrContains(meshName, "dlc13") ||
				StrContains(meshName, "dlc14") ||
				StrContains(meshName, "dlc15") ||
				StrContains(meshName, "dlc16") ||
				StrContains(meshName, "items\usable") ||
				StrContains(meshName, "items\weapons") ||
				StrContains(meshName, "items\work") ||
				StrContains(meshName, "items\npc_items") ||
				StrContains(meshName, "items\horse_items") ||				
				StrContains(meshName, "merged_content") || 
				StrContains(meshName, "engine") ||
				StrContains(meshName, "cutscenes") ||
				StrContains(meshName, "living_world") || 
				StrContains(meshName, "weather_volume") || 
				StrContains(meshName, "block") ||
				StrContains(meshName, "plane") || 
				StrContains(meshName, "shadow") || 
				StrContains(meshName, "characters") ||
                StrContains(meshName, "geralt") ||	
                StrContains(meshName, "head") ||
				StrContains(meshName, "models") ||
                StrContains(meshName, "eyes") ||
                StrContains(meshName, "model") ||					
				StrContains(meshName, "volume") || 
				StrContains(meshName, "environment\definitions") || 
				StrContains(meshName, "environment\debug") || 
				StrContains(meshName, "environment\water") || 
				StrContains(meshName, "environment\shaders") || 				
				StrContains(meshName, "proxy"))
			{
				// Some objects cause randoms crashes, have not narrowed down a particular reason, only certain categories.
				// Proxys cannot be lined up with some non-proxy meshes which forces us to not scale them at all :(
				continue;
			}
			else
			{			
				res = LoadResource(meshName, true);

				if (res)
				{
					mesh = (CMesh)res;

					if (mesh)
					{
						meshes.PushBack(mesh);		
					}
				}
			}
		}
		
		UpdateIDD();
	}

	function UpdateIDD() 
	{		
		//world.umbraScene.distanceMultiplier = 0;	
	
		for(i = 0; i < meshes.Size(); i+=1)
		{
			mesh = meshes[i];

			UpdateDrawDistance(mesh);

			UpdateLod(mesh);
		}
    }
	
	function UpdateDrawDistance(mesh : CMesh)
	{
		meshName = mesh.GetPath();
		
		mesh.autoHideDistance *= 2;
		mesh.isTwoSided = true;	
	}
	
	function UpdateLod(mesh : CMesh)
	{
		meshName = mesh.GetPath();

		for(j = 0; j < mesh.cookedData.renderLODs.Size(); j+=1)
		{
			if (StrContains(meshName, "characters"))
			{
				continue;
			}		
			else
			{		
				mesh.cookedData.renderLODs[j] *= 2;
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ArmorFriendlyWolves()
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var i								: int;
	var npc								: CNewNPC;

	if (!ACS_Armor_Equipped_Check())
	{
		return;
	}
	
	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() <= 0 )
	{
		return;
	}

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			if (actor.HasAbility('mon_wolf_base')
			&& !actor.HasAbility('mon_wolf_summon_were')
			&& !actor.HasAbility('mon_evil_dog')
			&& !actor.HasTag('ACS_Shadow_Wolf')
			&& !actor.UsesEssence()
			)
			{
				if (!actor.HasTag('ACS_Friendly_Wolf'))
				{
					((CNewNPC)actor).SetAttitude(thePlayer, AIA_Neutral);
					
					//((CNewNPC)actor).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

					((CNewNPC)actor).ForgetActor(thePlayer);

					actor.AddTag('ACS_Friendly_Wolf');
				}		
			}
		}
	}
}

function ACS_FriendlyWolves()
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var i								: int;
	var npc								: CNewNPC;
	var targetDistance					: float;
	
	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer);

	if( actors.Size() <= 0 )
	{
		return;
	}

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			targetDistance = VecDistanceSquared2D( ((CActor)actors[i]).GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

			if (actor.HasAbility('mon_wolf_base')
			&& !actor.HasAbility('mon_wolf_summon_were')
			&& !actor.HasAbility('mon_evil_dog')
			&& !actor.HasTag('ACS_Shadow_Wolf')
			&& !actor.UsesEssence()
			&& !npc.IsInInterior()
			&& !thePlayer.IsInInterior()
			&& ((CNewNPC)npc).GetNPCType() != ENGT_Quest
			)
			{
				if (targetDistance < 2 * 2)
				{
					if (!actor.HasTag('ACS_Angry_Wolf') && actor.GetAttitude( thePlayer ) != AIA_Hostile)
					{
						((CNewNPC)actor).ResetAttitude(thePlayer);

						((CNewNPC)actor).ResetBaseAttitudeGroup();

						((CNewNPC)actor).SetAttitude(thePlayer, AIA_Hostile);

						actor.AddTag('ACS_Angry_Wolf');
					}
				}
				else if (targetDistance >= 2 * 2)
				{
					if (thePlayer.GetCurrentHealth() > thePlayer.GetMaxHealth() * 0.25)
					{
						if (!actor.HasTag('ACS_Friendly_Wolf') && actor.GetAttitude( thePlayer ) == AIA_Hostile)
						{
							((CNewNPC)actor).SetAttitude(thePlayer, AIA_Neutral);
							
							//((CNewNPC)actor).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

							((CNewNPC)actor).ForgetActor(thePlayer);

							actor.AddTag('ACS_Friendly_Wolf');
						}
					}
					else if (thePlayer.GetCurrentHealth() <= thePlayer.GetMaxHealth() * 0.25)
					{
						if (!actor.HasTag('ACS_Angry_Wolf') && actor.GetAttitude( thePlayer ) != AIA_Hostile)
						{
							((CNewNPC)actor).ResetAttitude(thePlayer);

							((CNewNPC)actor).ResetBaseAttitudeGroup();

							((CNewNPC)actor).SetAttitude(thePlayer, AIA_Hostile);

							actor.AddTag('ACS_Angry_Wolf');
						}
					}		
				}
			}
		}
	}
}

function ACS_Sneaking()
{
	if (thePlayer.HasTag('ACS_Is_Sneaking')
	)
	{
		ACS_Sneaking_For_Hostile();
	}
	else
	{
		ACS_Sneaking_Revert();
	}
}

function ACS_Sneaking_For_Hostile()
{
	var actor, actortarget								: CActor; 
	var actors, targets		    						: array<CActor>;
	var i, j											: int;
	var npc												: CNewNPC;
	var targetDistance									: float;
	var targetPlayer									: CPlayer;
	var actorSightCone, actorSightRange					: float;
	
	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_ExcludePlayer + FLAG_Attitude_Hostile);

	if( actors.Size() <= 0 )
	{
		return;
	}

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			targetDistance = VecDistanceSquared2D( ((CActor)actors[i]).GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

			if (!actor.HasAbility('mon_wolf_base')
			&& ((CNewNPC)actor).GetNPCType() != ENGT_Quest
			&& !actor.IsAnimal()
			)
			{
				if (targetDistance < 15 * 15)
				{
					if( GetRainStrength() > 0 ) 
					{
						if (npc.IsMonster())
						{
							actorSightCone = 225;

							actorSightRange = 15;
						}
						else
						{
							actorSightCone = 135;

							actorSightRange = 12;
						}
					}
					else
					{
						if (npc.IsMonster())
						{
							actorSightCone = 270;

							actorSightRange = 17;
						}
						else
						{
							actorSightCone = 180;

							actorSightRange = 15;
						}
					}

					targets.Clear();

					targets = actor.GetNPCsAndPlayersInCone(15, VecHeading(actor.GetHeadingVector()), actorSightCone, 50, , FLAG_OnlyAliveActors );

					if( targets.Size() > 0 )
					{
						for( j = 0; j < targets.Size(); j += 1 )
						{
							targetPlayer = (CPlayer)targets[j];

							if (targetPlayer)
							{
								if (!actor.HasTag('ACS_Sneaking_Hostile') 
								&& actor.GetAttitude( thePlayer ) != AIA_Hostile
								&& ((CNewNPC)actor).GetNPCType() != ENGT_Quest
								)
								{
									((CNewNPC)actor).ResetAttitude(thePlayer);

									((CNewNPC)actor).ResetBaseAttitudeGroup();

									((CNewNPC)actor).SetAttitude(thePlayer, AIA_Hostile);

									actor.AddTag('ACS_Sneaking_Hostile');
								}
							}
						}
					}
				}
				else if (targetDistance >= 15 * 15)
				{
					if (!actor.HasTag('ACS_Sneaking_Neutral') && actor.GetAttitude( thePlayer ) == AIA_Hostile)
					{
						((CNewNPC)actor).SetAttitude(thePlayer, AIA_Neutral);
						
						//((CNewNPC)actor).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	

						((CNewNPC)actor).ForgetActor(thePlayer);

						actor.AddTag('ACS_Sneaking_Neutral');
					}
				}
			}
		}
	}
}

function ACS_Sneaking_Revert()
{
	var actor, actortarget								: CActor; 
	var actors, targets		    						: array<CActor>;
	var i, j											: int;
	var npc												: CNewNPC;
	var targetDistance									: float;
	var targetPlayer									: CPlayer;
	var actorSightCone, actorSightRange					: float;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Sneaking_Neutral', actors );	

	if( actors.Size() <= 0 )
	{
		return;
	}

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			actor = actors[i];

			targetDistance = VecDistanceSquared2D( ((CActor)actors[i]).GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

			if (!actor.HasAbility('mon_wolf_base')
			&& ((CNewNPC)actor).GetNPCType() != ENGT_Quest
			&& !actor.IsAnimal()
			)
			{
				if (actor.HasTag('ACS_Sneaking_Neutral'))
				{
					((CNewNPC)actor).ResetAttitude(thePlayer);

					((CNewNPC)actor).ResetBaseAttitudeGroup();

					((CNewNPC)actor).SetAttitude(thePlayer, AIA_Hostile);

					actor.RemoveTag('ACS_Sneaking_Hostile');

					actor.RemoveTag('ACS_Sneaking_Neutral');
				}
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Fish_Check() : bool
{
	if (
	thePlayer.IsSwimming()
	&& thePlayer.IsDiving()
	)
	{
		return true;
	}

	return false;
}

statemachine class cACS_Fish_Generate
{
    function Fish_Generate_Engage()
	{
		this.PushState('Fish_Generate_Engage');
	}
}

state Fish_Generate_Engage in cACS_Fish_Generate
{
	var temp																	: CEntityTemplate;
	var ent																		: CEntity;
	var i, count_1, j, count_2													: int;
	var initPos, spawnPos, spawnPos2, posAdjusted, posAdjusted2, entPos			: Vector;
	var randAngle, randRange, distance											: float;
	var meshcomp																: CComponent;
	var animcomp 																: CAnimatedComponent;
	var h 																		: float;
	var bone_vec, pos, attach_vec												: Vector;
	var bone_rot, rot, attach_rot, playerRot, adjustedRot									: EulerAngles;
	var world																	: CWorld;
	var l_groundZ																: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Fish_Generate();
	}
	
	entry function Fish_Generate()
	{
		Fish_Generate_Latent();
	}
	
	latent function Fish_Generate_Latent()
	{
		temp = (CEntityTemplate)LoadResourceAsync( 

		"quests\sidequests\skellige\quest_files\sq209_weregild\entities\fishes\sq209_fish_v02.w2ent"

		//"quests\sidequests\skellige\quest_files\sq209_weregild\characters\sq209_flying_whale.w2ent"
			
		, true );

		initPos = (theCamera.GetCameraPosition() + theCamera.GetCameraDirection() * RandRangeF(30,20));

		playerRot = EulerAngles(0,0,0);

		playerRot.Yaw += RandRange(360,0);
		
		count_1 = RandRange(10,5);

		distance = RandRangeF(10, 5);

		world = theGame.GetWorld();
			
		for( i = 0; i < count_1; i += 1 )
		{
			randRange = distance + distance * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + initPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + initPos.Y;
			spawnPos.Z = initPos.Z;

			posAdjusted = (spawnPos);

			count_2 = RandRange(30,15);

			for( j = 0; j < count_2; j += 1 )
			{
				randRange = distance + distance * RandF();
				randAngle = 2 * Pi() * RandF();
				
				spawnPos2.X = randRange * CosF( randAngle ) + posAdjusted.X;
				spawnPos2.Y = randRange * SinF( randAngle ) + posAdjusted.Y;
				spawnPos2.Z = posAdjusted.Z;

				posAdjusted2 = (spawnPos2);

				if ( theGame.GetWorld().GetWaterDepth( posAdjusted2 , true ) > 0 )
				{
					ent = theGame.CreateEntity( temp, posAdjusted2, adjustedRot );
				}

				ent.DestroyAfter(480);

				ent.AddTag('ACS_Fish_Ent');
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSWisp() : W3ACSWisp
{
	var entity 			 : W3ACSWisp;
	
	entity = (W3ACSWisp)theGame.GetEntityByTag( 'ACS_Wisp' );
	return entity;
}

function ACS_Wisp_Gatling_Gun()
{
	var vACS_Wisp_Gatling_Gun : cACS_Wisp_Gatling_Gun;
	vACS_Wisp_Gatling_Gun = new cACS_Wisp_Gatling_Gun in theGame;
	
	if (ACS_wisp_projectile_spawn())
	{
		ACS_refresh_wisp_projectile_cooldown();

		vACS_Wisp_Gatling_Gun.Wisp_Gatling_Gun_Engage();
	}
}

statemachine class cACS_Wisp_Gatling_Gun
{
    function Wisp_Gatling_Gun_Engage()
	{
		this.PushState('Wisp_Gatling_Gun_Engage');
	}
}

state Wisp_Gatling_Gun_Engage in cACS_Wisp_Gatling_Gun
{
	var actortarget													: CActor;
	var actors    													: array<CActor>;
	var i         													: int;
	var rock_pillar_temp											: CEntityTemplate;
	var proj_1	 													: W3ACSIceSpearProjectile;
	var proj_2														: W3ACSBoulderProjectile;
	var initpos, targetPositionNPC, targetPositionRandom			: Vector;
	var initrot, targetRotationNPC, adjustedRot									: EulerAngles;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Wisp_Gatling_Gun();
	}
	
	entry function Wisp_Gatling_Gun()
	{
		Wisp_Gatling_Gun_Latent();
	}
	
	latent function Wisp_Gatling_Gun_Latent()
	{
		if (!thePlayer.IsInCombat() && !thePlayer.IsThreatened())
		{
			return;
		}

		if (FactsQuerySum("ACS_Wisp_Attack_Enable") <= 0)
		{
			return;
		}

		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 1, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			if (thePlayer.IsHardLockEnabled())
			{
				actortarget = (CActor)(thePlayer.GetDisplayTarget());
			}
			else
			{
				actortarget = (CActor)actors[i];
			}

			if (!actortarget)
			{
				return;
			}
				
			initpos = GetACSWisp().GetWorldPosition();		

			initrot = GetACSWisp().GetWorldRotation();
			initrot.Pitch += RandRangeF(360, 0);
			initrot.Roll += RandRangeF(360, 0);
			initrot.Yaw += RandRangeF(360, 0);

			if ( actortarget.GetBoneIndex('head') != -1 )
			{
				targetPositionNPC = actortarget.GetBoneWorldPosition('head');
				targetPositionNPC.Z += RandRangeF(0,-0.5);
				targetPositionNPC.X += RandRangeF(0.125,-0.125);
			}
			else
			{
				if ( actortarget.GetBoneIndex('k_head_g') != -1 )
				{
					targetPositionNPC = actortarget.GetBoneWorldPosition('k_head_g');
					targetPositionNPC.Z += RandRangeF(0,-0.5);
					targetPositionNPC.X += RandRangeF(0.125,-0.125);
				}
				else
				{
					targetPositionNPC = actortarget.GetWorldPosition();
					targetPositionNPC.Z += RandRangeF(0,-0.5);
					targetPositionNPC.X += RandRangeF(0.125,-0.125);
				}
			}

			targetPositionRandom = thePlayer.GetWorldPosition() + ( thePlayer.GetWorldForward() * RandRangeF(10, 5) ) + (thePlayer.GetWorldRight() * RandRangeF(10, -10));
			targetPositionRandom.Z += RandRangeF(10, 5);
			
			if ( thePlayer.GetEquippedSign() == ST_Aard )
			{
				if (thePlayer.GetLevel() < 5)
				{
					return;
				}

				GetACSWisp().PlayEffectSingle('wisp_fx_combat_attack');
				GetACSWisp().StopEffect('wisp_fx_combat_attack');

				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_start");
				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_stop");

				proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\wh_icespear.w2ent", true ), initpos );

				proj_1.AddTag('ACS_Shot_From_Wisp');

				if (GetACSWatcher().Wisp_Hit_Counter() >= 5)
				{
					proj_1.AddTag('ACS_Wisp_Projectile_Add_Freeze');
					
					GetACSWatcher().Reset_Wisp_Hit_Counter();
				}
								
				proj_1.Init(GetWitcherPlayer());
				proj_1.PlayEffectSingle('fire_fx');
				proj_1.ShootProjectileAtPosition( 0, 10, targetPositionNPC, 500 );
				proj_1.DestroyAfter(5);
			}
			else if ( thePlayer.GetEquippedSign() == ST_Yrden )
			{
				if (thePlayer.GetLevel() < 15)
				{
					return;
				}

				GetACSWisp().PlayEffectSingle('wisp_fx_combat_attack');
				GetACSWisp().StopEffect('wisp_fx_combat_attack');

				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_start");
				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_stop");

				proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\soceress_arcane_missile.w2ent", true ), initpos );

				proj_1.AddTag('ACS_Shot_From_Wisp');

				if (GetACSWatcher().Wisp_Hit_Counter() >= 5)
				{
					proj_1.AddTag('ACS_Wisp_Projectile_Add_Slow');
					
					GetACSWatcher().Reset_Wisp_Hit_Counter();
				}
								
				proj_1.Init(GetWitcherPlayer());
				proj_1.PlayEffectSingle('fire_fx');
				proj_1.ShootProjectileAtPosition( 0, 10, targetPositionNPC, 500 );
				proj_1.DestroyAfter(5);
			}
			else if ( thePlayer.GetEquippedSign() == ST_Igni )
			{
				if (thePlayer.GetLevel() < 10)
				{
					return;
				}

				GetACSWisp().PlayEffectSingle('wisp_fx_combat_attack');
				GetACSWisp().StopEffect('wisp_fx_combat_attack');

				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_start");
				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_stop");

				proj_1 = (W3ACSIceSpearProjectile)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\sorceress_fireball.w2ent", true ), initpos );

				proj_1.AddTag('ACS_Shot_From_Wisp');

				if (GetACSWatcher().Wisp_Hit_Counter() >= 5)
				{
					proj_1.AddTag('ACS_Wisp_Projectile_Add_Fire');

					GetACSWatcher().Reset_Wisp_Hit_Counter();
				}
								
				proj_1.Init(GetWitcherPlayer());
				proj_1.PlayEffectSingle('fire_fx');
				proj_1.ShootProjectileAtPosition( 0, 10, targetPositionNPC, 500 );
				proj_1.DestroyAfter(5);
			}
			else if ( thePlayer.GetEquippedSign() == ST_Quen )
			{
				if (thePlayer.GetLevel() < 25)
				{
					return;
				}

				GetACSWisp().PlayEffectSingle('wisp_fx_combat_attack');
				GetACSWisp().StopEffect('wisp_fx_combat_attack');

				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_start");
				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_stop");

				proj_2 = (W3ACSBoulderProjectile)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\lynx_rock_witch_rock.w2ent", true ), initpos, initrot );

				proj_2.AddTag('ACS_Shot_From_Wisp');
				proj_2.AddTag('ACS_Wisp_Rock_Projectile');
								
				proj_2.Init(GetWitcherPlayer());
				proj_2.PlayEffectSingle('glow');
				proj_2.ShootProjectileAtPosition( 0, 10, targetPositionRandom, 500 );
				proj_2.DestroyAfter(5);
			}
			else if ( thePlayer.GetEquippedSign() == ST_Axii )
			{
				if (thePlayer.GetLevel() < 20)
				{
					return;
				}

				GetACSWisp().PlayEffectSingle('wisp_fx_combat_attack');
				GetACSWisp().StopEffect('wisp_fx_combat_attack');

				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_start");
				GetACSWisp().SoundEvent("magic_sorceress_vfx_fireball_fire_fx_loop_stop");

				proj_2 = (W3ACSBoulderProjectile)theGame.CreateEntity( 
				(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\djinn_wood_proj.w2ent", true ), initpos );

				proj_2.AddTag('ACS_Shot_From_Wisp');
				proj_2.AddTag('ACS_Wisp_Wood_Projectile');
								
				proj_2.Init(GetWitcherPlayer());
				proj_2.PlayEffectSingle('glow');
				proj_2.ShootProjectileAtPosition( 0, 10, targetPositionRandom, 500 );
				proj_2.DestroyAfter(5);
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Ghoul_Explode( npc : CActor, pos : Vector )
{
	var ent       														: CEntity;
	var rot, attach_rot, adjustedRot                        						 	: EulerAngles;

	rot = EulerAngles(0,0,0);

	rot.Yaw += RandRangeF(360,0);
	rot.Pitch += RandRangeF(360,1);
	rot.Roll += RandRangeF(360,1);

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\fx\blood_fx.w2ent"

	, true ), pos, rot );

	ent.DestroyAfter(2);

	//ent.CreateAttachment( npc, , Vector( 0, 0 , 2 ), EulerAngles(0,0,0) );

	ent.PlayEffectSingle('blood_explode_red');

	ent.PlayEffectSingle('hit_red');
	ent.PlayEffectSingle('hit_refraction_red');
	ent.PlayEffectSingle('crawl_blood_red');
}

function ACS_Alghoul_Explode( npc : CActor, pos : Vector )
{
	var ent       														: CEntity;
	var rot, attach_rot, adjustedRot                        						 	: EulerAngles;

	rot = EulerAngles(0,0,0);

	rot.Yaw += RandRange(360,0);

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	"fx\monsters\rotfiend\rotfiend_explode.w2ent"

	, true ), pos, rot );

	ent.DestroyAfter(2);

	//ent.CreateAttachment( npc, , Vector( 0, 0 , 2 ), EulerAngles(0,0,0) );

	ent.PlayEffectSingle('blood_explode');
}

function ACS_Wildhunt_Minion_Explode( npc : CActor, pos : Vector )
{
	var entity : CEntity;
	var iceSpike : W3ACSCaranthirIceSpike;
	var spawnPos : Vector;
	var rotation, adjustedRot : EulerAngles;

	pos.Z += 1.1;

	rotation = EulerAngles(0,0,0);

	rotation.Yaw = RandRangeF( 180.0, -180.0 );

	entity = (W3ACSCaranthirIceSpike)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\enemy_magic\caranthir_ice_spike.w2ent", true ), pos, rotation );

	iceSpike = (W3ACSCaranthirIceSpike)entity;

	iceSpike.AddTag('ACS_Spawned_From_Minion_Death');

	if( iceSpike )
	{
		iceSpike.Appear();
	}
}

function ACS_Normal_Death_Explode( npc : CActor, pos : Vector )
{
	var ent       														: CACSGoreSpawnerEntity;
	var torsoBoneIndex													: int;
	var bone_vec														: Vector;

	if (!ACS_AdditionalGore_Enabled())
	{
		return;
	}

	torsoBoneIndex = npc.GetTorsoBoneIndex();

	if ( torsoBoneIndex != -1 )
	{
		bone_vec = MatrixGetTranslation( npc.GetBoneWorldMatrixByIndex( torsoBoneIndex ) );

		ent = (CACSGoreSpawnerEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\gore_spawner.w2ent", true ), bone_vec, npc.GetWorldRotation() );
	}
	else
	{
		bone_vec = pos;

		ent = (CACSGoreSpawnerEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\gore_spawner.w2ent", true ), bone_vec, npc.GetWorldRotation() );

		ent.AddTag('ACS_Gore_Spawn_No_Torso_Bone_Found');
	}

	ent.DestroyAfter(10);
}

function ACS_Human_Death_Explode( npc : CActor, pos : Vector, delay : float )
{
	var ent       														: CACSGoreSpawnerEntity;
	var bone_vec														: Vector;
	var bone_rot, adjustedRot											: EulerAngles;
	var torsoBoneIndex													: int;

	if (!ACS_AdditionalGore_Enabled())
	{
		return;
	}

	torsoBoneIndex = npc.GetTorsoBoneIndex();

	if ( torsoBoneIndex != -1 )
	{
		bone_vec = MatrixGetTranslation( npc.GetBoneWorldMatrixByIndex( torsoBoneIndex ) );
	}
	else
	{
		bone_vec = pos;
	}

	ent = (CACSGoreSpawnerEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\gore_spawner.w2ent", true ), bone_vec, npc.GetWorldRotation() );

	//ent.CreateAttachment( npc, 'blood_point', Vector(0.125,0.5,0), EulerAngles(0,0,0) );

	if (delay == 1)
	{
		ent.AddTag('ACS_Gore_Spawn_Delay_1');
	}
	else if (delay == 0.5)
	{
		ent.AddTag('ACS_Gore_Spawn_Delay_2');
	}
	
	ent.DestroyAfter(10);
}

statemachine class CACSGoreSpawnerEntity extends CEntity
{
	var pos : Vector;
	var rot, adjustedRot : EulerAngles;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		AddTimer('GoreSpawnCheck', 0.01, false);
	}

	timer function GoreSpawnCheck ( dt : float, id : int)
	{
		pos = this.GetWorldPosition();

		rot = this.GetWorldRotation();

		if (this.HasTag('ACS_Gore_Spawn_Delay_1'))
		{
			this.PushState('FinisherSpawnGore_1');
		}
		else if (this.HasTag('ACS_Gore_Spawn_Delay_2'))
		{
			this.PushState('FinisherSpawnGore_2');
		}
		else if (this.HasTag('ACS_Gore_Spawn_No_Torso_Bone_Found'))
		{
			this.PushState('SpawnGore_No_Torso_Bone');
		}
		else
		{
			this.PushState('SpawnGore');
		}
	}
}

state FinisherSpawnGore_1 in CACSGoreSpawnerEntity
{
	event OnEnterState(prevStateName : name)
	{
		Finisher_Gore_Spawn_1_Entry();
	}
	
	entry function Finisher_Gore_Spawn_1_Entry()
	{	
		Sleep(1);

		Finisher_Gore_Spawn_1_Latent();
	}

	latent function Finisher_Gore_Spawn_1_Latent()
	{
		var ent, ent_1, ent_2, ent_3, ent_4      							: CEntity;
		var gorePos 														: Vector;
		var goreRot															: EulerAngles;
		var bone_vec														: Vector;
		var bone_rot, adjustedRot											: EulerAngles;
		var spawn_paths														: array<string>;

		gorePos = parent.pos;
		goreRot = parent.rot;

		//gorePos.Z += 1;

		//gorePos.Y += 1;

		//goreRot.Pitch += RandRange(360,0);
		//goreRot.Roll += RandRange(360,0);
		//goreRot.Yaw += RandRange(360,0);

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

		spawn_paths.Clear();

		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore01.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore02.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore03.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore04.w2ent");

		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		spawn_paths[RandRange(spawn_paths.Size())]

		, true ), gorePos, goreRot );

		ent_1.DestroyAfter(600);


		/*
		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore01.w2ent"

		, true ), gorePos, goreRot );

		ent_1.DestroyAfter(600);

		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore02.w2ent"

		, true ), gorePos, goreRot );

		ent_2.DestroyAfter(600);

		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore03.w2ent"

		, true ), gorePos, goreRot );

		ent_3.DestroyAfter(600);

		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore04.w2ent"

		, true ), gorePos, goreRot );

		ent_4.DestroyAfter(600);
		*/
	}
}

state FinisherSpawnGore_2 in CACSGoreSpawnerEntity
{
	event OnEnterState(prevStateName : name)
	{
		Finisher_Gore_Spawn_2_Entry();
	}
	
	entry function Finisher_Gore_Spawn_2_Entry()
	{	
		Sleep(0.4);

		Finisher_Gore_Spawn_2_Latent();
	}

	latent function Finisher_Gore_Spawn_2_Latent()
	{
		var ent, ent_1, ent_2, ent_3, ent_4      							: CEntity;
		var gorePos 														: Vector;
		var goreRot, adjustedRot											: EulerAngles;
		var spawn_paths														: array<string>;

		gorePos = parent.pos;
		goreRot = parent.rot;

		//gorePos.Z += 1;

		//gorePos.Y += 1;

		//goreRot.Pitch += RandRange(360,0);
		//goreRot.Roll += RandRange(360,0);
		//goreRot.Yaw += RandRange(360,0);

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

		spawn_paths.Clear();
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore02.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore03.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore04.w2ent");


		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		spawn_paths[RandRange(spawn_paths.Size())]

		, true ), gorePos, goreRot );

		ent_1.DestroyAfter(600);


		/*
		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore01.w2ent"

		, true ), gorePos, goreRot );

		ent_1.DestroyAfter(600);

		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore02.w2ent"

		, true ), gorePos, goreRot );

		ent_2.DestroyAfter(600);

		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore03.w2ent"

		, true ), gorePos, goreRot );

		ent_3.DestroyAfter(600);

		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore04.w2ent"

		, true ), gorePos, goreRot );

		ent_4.DestroyAfter(600);
		*/
	}
}

state SpawnGore_No_Torso_Bone in CACSGoreSpawnerEntity
{
	event OnEnterState(prevStateName : name)
	{
		Gore_Spawn_No_Torso_Bone_Entry();
	}
	
	entry function Gore_Spawn_No_Torso_Bone_Entry()
	{	
		Gore_Spawn_No_Torso_Bone_Latent();
	}

	latent function Gore_Spawn_No_Torso_Bone_Latent()
	{
		var ent, ent_1, ent_2, ent_3, ent_4      							: CEntity;
		var gorePos 														: Vector;
		var goreRot, adjustedRot											: EulerAngles;
		var spawn_paths														: array<string>;
		
		gorePos = parent.pos;
		goreRot = parent.rot;

		//goreRot.Pitch += RandRange(360,0);
		//goreRot.Roll += RandRange(360,0);
		//goreRot.Yaw += RandRange(360,0);

		gorePos.Z += 1.5;

		/*
		ent = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\special\force.w2ent"

		, true ), gorePos, goreRot );

		ent.DestroyAfter(3);
		*/

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");


		spawn_paths.Clear();
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore01.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore02.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore03.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore04.w2ent");


		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		spawn_paths[RandRange(spawn_paths.Size())]

		, true ), gorePos, goreRot );

		ent_1.DestroyAfter(600);


		/*
		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore01.w2ent"

		, true ), gorePos, goreRot );

		ent_1.DestroyAfter(600);

		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore02.w2ent"

		, true ), gorePos, goreRot );

		ent_2.DestroyAfter(600);

		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore03.w2ent"

		, true ), gorePos, goreRot );

		ent_3.DestroyAfter(600);

		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore04.w2ent"

		, true ), gorePos, goreRot );

		ent_4.DestroyAfter(600);
		*/
	}
}

state SpawnGore in CACSGoreSpawnerEntity
{
	event OnEnterState(prevStateName : name)
	{
		Gore_Spawn_Entry();
	}
	
	entry function Gore_Spawn_Entry()
	{	
		Gore_Spawn_Latent();
	}

	latent function Gore_Spawn_Latent()
	{
		var ent, ent_1, ent_2, ent_3, ent_4      							: CEntity;
		var gorePos 														: Vector;
		var goreRot, adjustedRot											: EulerAngles;
		var spawn_paths														: array<string>;
		
		gorePos = parent.pos;
		goreRot = parent.rot;

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

		spawn_paths.Clear();
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore01.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore02.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore03.w2ent");
		spawn_paths.PushBack("characters\models\common\wounds\w_ma__gore04.w2ent");


		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		spawn_paths[RandRange(spawn_paths.Size())]

		, true ), gorePos, goreRot );

		ent_1.DestroyAfter(600);


		/*
		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore01.w2ent"

		, true ), gorePos, goreRot );

		ent_1.DestroyAfter(600);

		ent_2 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore02.w2ent"

		, true ), gorePos, goreRot );

		ent_2.DestroyAfter(600);

		ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore03.w2ent"

		, true ), gorePos, goreRot );

		ent_3.DestroyAfter(600);

		ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 

		"characters\models\common\wounds\w_ma__gore04.w2ent"

		, true ), gorePos, goreRot );

		ent_4.DestroyAfter(600);
		*/
	}
}

class CACSCustomScent extends CGameplayEntity
{
	//import saved var isSaveable : bool;
	editable saved var isScentEnabled         : bool; default isScentEnabled = false;
	editable saved var scentPoints            : array<Vector>;
	editable saved var scentPointsDistance    : float; default scentPointsDistance = 0.5f;

	var currentDirection                 : int; default currentDirection = 1;
	var nextPoint                        : int; default nextPoint = 0;

	event OnSpawned( spawnData : SEntitySpawnData )
	{
		super.OnSpawned(spawnData);

		//isSaveable = true;

		AddTimer( 'UpdateScent', 0.1f, true , , , true, true );

		if (scentPoints.Size() < 2)
			LogChannel('UpdateScent', "[WARNING] Path contains less then two points!");
	}

	function setScentEnabled(enabled : bool) 
	{
		isScentEnabled = enabled;
	}

	function setScentPoints(points : array<Vector>) 
	{
		if (points.Size() > 0) 
		{
			scentPoints = points;
			LogChannel('CACSCustomScent', "[OK] Set new scent points(" + scentPoints.Size() + ")");
		}
	}

	function setScentDistance(dist : float) 
	{
		if (dist > 0.0f) 
		{
			scentPointsDistance = dist;
			LogChannel('CACSCustomScent', "[OK] Set new dist(" + scentPointsDistance + ")");
		}
	}

	function FindNextPoint() 
	{
		nextPoint += currentDirection;

		if (nextPoint == scentPoints.Size()) 
		{
			nextPoint -= 2;
			currentDirection *= -1;
		}

		if (nextPoint == -1) 
		{
			nextPoint += 2;
			currentDirection *= -1;
		}
	}

	function GetNextInterPoint() : Vector 
	{
		var distToNext : float;
		var curPos : Vector;
		var ret    : Vector;

		if (scentPoints.Size() < 2) 
		{
			return GetWorldPosition();
		}

		curPos = GetWorldPosition();

		distToNext = VecDistance(curPos, scentPoints[nextPoint]);

		if (distToNext < scentPointsDistance) 
		{
			ret = scentPoints[nextPoint];
			FindNextPoint();
			return ret;
		} 
		else 
		{
			ret = GetWorldPosition() + (scentPoints[nextPoint] - GetWorldPosition()) / (distToNext / scentPointsDistance);
			return ret;
		}
	}

	timer function UpdateScent( time : float , id : int)
	{
		if (isScentEnabled) 
		{
			if (!IsEffectActive('focus_smell_alt', false)) 
			{
				PlayEffect('focus_smell_alt');
			}
		} 
		else 
		{
			StopEffectIfActive('focus_smell_alt');
		}

		Teleport(GetNextInterPoint());
	}
}	

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Wearable_Pocket_Items_Controller
{
    function ACS_Wearable_Pocket_Items_Controller_Engage()
	{
		this.PushState('ACS_Wearable_Pocket_Items_Controller_Engage');
	}
}

state ACS_Wearable_Pocket_Items_Controller_Engage in cACS_Wearable_Pocket_Items_Controller
{
	private var itemID_quickslot, itemID_petard 	: SItemUniqueId;
	private var item_name, petard_name 				: name;

	event OnEnterState(prevStateName : name)
	{
		Wearable_Pocket_Items_Entry();
	}
	
	entry function Wearable_Pocket_Items_Entry()
	{	
		if (theGame.IsDialogOrCutscenePlaying() 
		|| GetWitcherPlayer().IsInNonGameplayCutscene() 
		|| GetWitcherPlayer().IsInGameplayScene()
		|| theGame.IsCurrentlyPlayingNonGameplayScene()
		|| theGame.IsFading()
		|| theGame.IsBlackscreen()
		|| theGame.IsPaused()
		)
		{
			return;
		}

		if (thePlayer.HasTag('in_wraith')
		|| thePlayer.HasTag('ACS_Camo_Active')
		|| !thePlayer.GetVisibility()
		|| !GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_Pants)
		|| !GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_Armor)
		)
		{
			Remove_All_Items();

			Remove_All_Bombs();

			return;
		}
		else
		{
			if (!GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_Quickslot1))
			{
				Remove_All_Items();
			}
			else
			{
				if (ACS_WearablePocketItems_Enabled())
				{
					Wearable_Pocket_Items_Latent();
				}
				else
				{
					Remove_All_Items();
				}
			}

			if (!GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_Petard1))
			{
				Remove_All_Bombs();
			}
			else
			{
				if (ACS_WearableBombs_Enabled())
				{
					Wearable_Bombs_Latent();
				}
				else
				{
					Remove_All_Bombs();
				}
			}
		}
	}

	latent function Wearable_Pocket_Items_Latent()
	{
		thePlayer.GetInventory().GetItemEquippedOnSlot(EES_Quickslot1, itemID_quickslot);

		item_name = thePlayer.GetInventory().GetItemName( itemID_quickslot );

		switch (item_name)
		{
			case 'Torch':
			Torch_Equip();
			break;

			case 'q106_magic_oillamp':
			Magic_Lamp_Equip();
			break;

			case 'Oil Lamp':
			Oil_Lamp_Equip();
			break;

			case 'Censer' :
			Censer_Equip();
			break;

			case 'q202_navigator_horn':
			Navigator_Horn_Equip();
			break;

			case 'q701_grain_cup':
			case 'mh701_usable_lure':
			case 'mh107_czart_lure': 
			Lure_Equip();
			break;

			case 'q103_bell':
			Bell_Equip();
			break;

			case 'Potestaquisitor':
			Potestaquisitor_Equip();
			break;

			case 'q203_eyeofloki':
			Eye_Of_Loki_Equip();
			break;

			case 'Shani Flower 1':
			case 'Shani Flower 3':
			case 'Shani Alcohol 1':
			case 'Shani Alcohol 2':
			case 'q701_cookie_lure':
			case 'q701_carrot_basket':
			case 'q701_apple_lure':
			Pouch_Equip();
			break;

			default:
			Pouch_Equip();
			break;
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function Torch_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Torch_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("items\usable\torchleft\torchleft.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Torch_Prop');

				meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				meshComp.SetScale( Vector(0.8,0.8,0.8) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.025;
					pPos.Y = -0.22;
					pPos.Z = -0.195;
					pRot.Roll = 115;
					pRot.Pitch = 95;
					pRot.Yaw = 50; 
					break;

					case 1:
					pPos.X = -0.05;
					pPos.Y = -0.21;
					pPos.Z = 0.2;
					pRot.Roll = 110;
					pRot.Pitch = 95;
					pRot.Yaw = 45; 
					break;
					
					default:
					pPos.X = 0.025;
					pPos.Y = -0.22;
					pPos.Z = -0.195;
					pRot.Roll = 115;
					pRot.Pitch = 95;
					pRot.Yaw = 50; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Torch_Equipped");
			}
		}
	}

	latent function Magic_Lamp_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\q106_magic_oillamp_dummy.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Magic_Lamp_Prop');

				//meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				//meshComp.SetScale( Vector(0.8,0.8,0.8) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.04;
					pPos.Y = -0.19;
					pPos.Z = -0.15;
					pRot.Roll = 110;
					pRot.Pitch = 205;
					pRot.Yaw = -90; 
					break;

					case 1:
					pPos.X = 0.07;
					pPos.Y = -0.1;
					pPos.Z = 0.14;
					pRot.Roll = 110;
					pRot.Pitch = 310;
					pRot.Yaw = -90;
					break;
					
					default:
					pPos.X = 0.04;
					pPos.Y = -0.19;
					pPos.Z = -0.15;
					pRot.Roll = 110;
					pRot.Pitch = 205;
					pRot.Yaw = -90; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Magic_Lamp_Equipped");
			}
		}
	}

	latent function Oil_Lamp_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\oillamp_dummy.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Oil_Lamp_Prop');

				//meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				//meshComp.SetScale( Vector(0.8,0.8,0.8) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.04;
					pPos.Y = -0.19;
					pPos.Z = -0.15;
					pRot.Roll = 110;
					pRot.Pitch = 205;
					pRot.Yaw = -90; 
					break;

					case 1:
					pPos.X = 0.07;
					pPos.Y = -0.1;
					pPos.Z = 0.14;
					pRot.Roll = 110;
					pRot.Pitch = 310;
					pRot.Yaw = -90;
					break;
					
					default:
					pPos.X = 0.04;
					pPos.Y = -0.19;
					pPos.Z = -0.15;
					pRot.Roll = 110;
					pRot.Pitch = 205;
					pRot.Yaw = -90; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Oil_Lamp_Equipped");
			}
		}
	}

	latent function Censer_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\ep1\data\items\quest_items\q602\q602_item__censer_scene_prop.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Censer_Prop');

				//meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				//meshComp.SetScale( Vector(0.8,0.8,0.8) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.04;
					pPos.Y = -0.19;
					pPos.Z = -0.15;
					pRot.Roll = 110;
					pRot.Pitch = 205;
					pRot.Yaw = -90; 
					break;

					case 1:
					pPos.X = 0.07;
					pPos.Y = -0.1;
					pPos.Z = 0.14;
					pRot.Roll = 110;
					pRot.Pitch = 310;
					pRot.Yaw = -90;
					break;
					
					default:
					pPos.X = 0.04;
					pPos.Y = -0.19;
					pPos.Z = -0.15;
					pRot.Roll = 110;
					pRot.Pitch = 205;
					pRot.Yaw = -90; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Censer_Equipped");
			}
		}
	}

	latent function Navigator_Horn_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("items\usable\q202_hornval_horn.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Navigator_Horn_Prop');

				meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				meshComp.SetScale( Vector(0.9,0.9,0.9) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.05;
					pPos.Y = -0.19;
					pPos.Z = -0.17;
					pRot.Roll = -130;
					pRot.Pitch = 210;
					pRot.Yaw = -100; 
					break;

					case 1:
					pPos.X = 0.03;
					pPos.Y = -0.15;
					pPos.Z = 0.21;
					pRot.Roll = -130;
					pRot.Pitch = 285;
					pRot.Yaw = -100; 
					break;
					
					default:
					pPos.X = 0.05;
					pPos.Y = -0.19;
					pPos.Z = -0.17;
					pRot.Roll = -130;
					pRot.Pitch = 210;
					pRot.Yaw = -100; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Navigator_Horn_Equipped");
			}
		}
	}

	latent function Lure_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("items\quest_items\mh107\mh107_item_czart_lure_potion.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Lure_Prop');

				meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				meshComp.SetScale( Vector(0.9,0.9,0.9) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.13;
					pPos.Y = 0;
					pPos.Z = -0.16;
					pRot.Roll = -90;
					pRot.Pitch = 15;
					pRot.Yaw = -290; 
					break;

					case 1:
					pPos.X = 0.15;
					pPos.Y = 0.05;
					pPos.Z = 0.14;
					pRot.Roll = -80;
					pRot.Pitch = 45;
					pRot.Yaw = -295; 
					break;
					
					default:
					pPos.X = 0.13;
					pPos.Y = 0;
					pPos.Z = -0.16;
					pRot.Roll = -90;
					pRot.Pitch = 15;
					pRot.Yaw = -290; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Lure_Equipped");
			}
		}
	}

	latent function Bell_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("items\usable\q103_bell.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Bell_Prop');

				//meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				//meshComp.SetScale( Vector(0.9,0.9,0.9) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.08;
					pPos.Y = 0.07;
					pPos.Z = -0.24;
					pRot.Roll = 115;
					pRot.Pitch = 140;
					pRot.Yaw = -110; 
					break;

					case 1:
					pPos.X = 0.17;
					pPos.Y = 0.15;
					pPos.Z = 0.14;
					pRot.Roll = 85;
					pRot.Pitch = 225;
					pRot.Yaw = -110; 
					break;
					
					default:
					pPos.X = 0.08;
					pPos.Y = 0.07;
					pPos.Z = -0.24;
					pRot.Roll = 115;
					pRot.Pitch = 140;
					pRot.Yaw = -110; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Bell_Equipped");
			}
		}
	}

	latent function Potestaquisitor_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("items\usable\potestaquisitor\potestaquisitor.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Potestaquisitor_Prop');

				meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				meshComp.SetScale( Vector(0.9,0.9,0.9) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.05;
					pPos.Y = -0.24;
					pPos.Z = -0.13;
					pRot.Roll = 120;
					pRot.Pitch = 325;
					pRot.Yaw = 100; 
					break;

					case 1:
					pPos.X = 0.07;
					pPos.Y = -0.21;
					pPos.Z = 0.1;
					pRot.Roll = 120;
					pRot.Pitch = 235;
					pRot.Yaw = 100; 
					break;
					
					default:
					pPos.X = 0.05;
					pPos.Y = -0.24;
					pPos.Z = -0.13;
					pRot.Roll = 120;
					pRot.Pitch = 325;
					pRot.Yaw = 100; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Potestaquisitor_Equipped");
			}
		}
	}

	latent function Eye_Of_Loki_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
			{
				GetACSPouchPropDestroyAll();

				FactsRemove("ACS_Pouch_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("items\usable\q203_eyeofloki.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				fake.AddTag('ACS_Eye_Of_Loki_Prop');

				//meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				//meshComp.SetScale( Vector(0.9,0.9,0.9) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.07;
					pPos.Y = -0.21;
					pPos.Z = -0.16;
					pRot.Roll = 80;
					pRot.Pitch = 200;
					pRot.Yaw = 75; 
					break;

					case 1:
					pPos.X = 0.12;
					pPos.Y = -0.18;
					pPos.Z = 0.05;
					pRot.Roll = -65;
					pRot.Pitch = 5;
					pRot.Yaw = -100; 
					break;
					
					default:
					pPos.X = 0.07;
					pPos.Y = -0.21;
					pPos.Z = -0.16;
					pRot.Roll = 80;
					pRot.Pitch = 200;
					pRot.Yaw = 75; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Eye_Of_Loki_Equipped");
			}
		}
	}

	latent function Pouch_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (thePlayer.IsHoldingItemInLHand() || thePlayer.IsCurrentlyUsingItemL())
		{
			Remove_All_Items();
		}
		else
		{
			if (FactsQuerySum("ACS_Torch_Equipped") > 0)
			{
				GetACSTorchPropDestroyAll();

				FactsRemove("ACS_Torch_Equipped");
			}

			if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
			{
				GetACSMagicLampPropDestroyAll();

				FactsRemove("ACS_Magic_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
			{
				GetACSOilLampPropDestroyAll();

				FactsRemove("ACS_Oil_Lamp_Equipped");
			}

			if (FactsQuerySum("ACS_Censer_Equipped") > 0)
			{
				GetACSCenserPropDestroyAll();

				FactsRemove("ACS_Censer_Equipped");
			}

			if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
			{
				GetACSNavigatorHornPropDestroyAll();

				FactsRemove("ACS_Navigator_Horn_Equipped");
			}

			if (FactsQuerySum("ACS_Lure_Equipped") > 0)
			{
				GetACSLurePropDestroyAll();

				FactsRemove("ACS_Lure_Equipped");
			}

			if (FactsQuerySum("ACS_Bell_Equipped") > 0)
			{
				GetACSBellPropDestroyAll();

				FactsRemove("ACS_Bell_Equipped");
			}

			if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
			{
				GetACSPotestaquisitorPropDestroyAll();

				FactsRemove("ACS_Potestaquisitor_Equipped");
			}

			if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
			{
				GetACSEyeOfLokiPropDestroyAll();

				FactsRemove("ACS_Eye_Of_Loki_Equipped");
			}

			if (FactsQuerySum("ACS_Pouch_Equipped") <= 0)
			{
				if (!GetACSItemPropAnchor())
				{
					dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
					dummy.AddTag('ACS_Item_Prop_Anchor');
				}
				else 
				{
					dummy = GetACSItemPropAnchor();
				}
				
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(
					
					"items\cutscenes\pouch_01\pouch_01.w2ent"

					//"items\work\pouch\pouch_bag_01.w2ent"

					//"dlc\bob\data\items\cutscenes\cs_regis_bag\cs_regis_bag.w2ent"

					//"items\work\pack_to_carry\pack_to_carry.w2ent"

					//"environment\decorations\containers\bags\bundle_px.w2ent"

					//"environment\decorations\containers\bags\sack_px.w2ent"

					//"environment\decorations\containers\bags\sack_grain_px.w2ent"

					//"quests\minor_quests\kaer_morhen\quest_files\mq4005_sword\entities\mq4005_bag.w2ent"

					//"gameplay\containers\_container_definitions\_mesh_entities\cont_bag_bundle.w2ent"

					//"gameplay\containers\_container_definitions\_mesh_entities\cont_bag_sack.w2ent"

					//"dlc\bob\data\items\quest_items\q701\q701_item__bruxa_bag.w2ent"
					
					, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

				fake.AddTag('ACS_Pouch_Prop');

				meshComp = ( CMeshComponent ) fake.GetComponentByClassName( 'CMeshComponent' );
				meshComp.SetScale( Vector(2.0,2.0,2.0) );
				
				bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
				GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
				
				dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

				option = ACS_WearablePocketItemsPositioning();

				switch ( option )
				{
					case 0: 
					pPos.X = 0.06;
					pPos.Y = -0.1;
					pPos.Z = -0.19;
					pRot.Roll = 90;
					pRot.Pitch = 160;
					pRot.Yaw = -95; 
					break;

					case 1:
					pPos.X = 0.11;
					pPos.Y = -0.06;
					pPos.Z = 0.15;
					pRot.Roll = 90;
					pRot.Pitch = 240;
					pRot.Yaw = -90;
					break;
					
					default:
					pPos.X = 0.06;
					pPos.Y = -0.1;
					pPos.Z = -0.19;
					pRot.Roll = 90;
					pRot.Pitch = 160;
					pRot.Yaw = -95; 
					break;
				}

				fake.CreateAttachment(dummy, , pPos, pRot );

				FactsAdd("ACS_Pouch_Equipped");
			}
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function Remove_All_Items()
	{
		if (GetACSItemPropAnchor())
		{
			GetACSItemPropAnchor().Destroy();
		}
		
		if (FactsQuerySum("ACS_Torch_Equipped") > 0)
		{
			GetACSTorchPropDestroyAll();

			FactsRemove("ACS_Torch_Equipped");
		}

		if (FactsQuerySum("ACS_Magic_Lamp_Equipped") > 0)
		{
			GetACSMagicLampPropDestroyAll();

			FactsRemove("ACS_Magic_Lamp_Equipped");
		}

		if (FactsQuerySum("ACS_Oil_Lamp_Equipped") > 0)
		{
			GetACSOilLampPropDestroyAll();

			FactsRemove("ACS_Oil_Lamp_Equipped");
		}

		if (FactsQuerySum("ACS_Censer_Equipped") > 0)
		{
			GetACSCenserPropDestroyAll();

			FactsRemove("ACS_Censer_Equipped");
		}

		if (FactsQuerySum("ACS_Navigator_Horn_Equipped") > 0)
		{
			GetACSNavigatorHornPropDestroyAll();

			FactsRemove("ACS_Navigator_Horn_Equipped");
		}

		if (FactsQuerySum("ACS_Lure_Equipped") > 0)
		{
			GetACSLurePropDestroyAll();

			FactsRemove("ACS_Lure_Equipped");
		}

		if (FactsQuerySum("ACS_Bell_Equipped") > 0)
		{
			GetACSBellPropDestroyAll();

			FactsRemove("ACS_Bell_Equipped");
		}

		if (FactsQuerySum("ACS_Potestaquisitor_Equipped") > 0)
		{
			GetACSPotestaquisitorPropDestroyAll();

			FactsRemove("ACS_Potestaquisitor_Equipped");
		}

		if (FactsQuerySum("ACS_Eye_Of_Loki_Equipped") > 0)
		{
			GetACSEyeOfLokiPropDestroyAll();

			FactsRemove("ACS_Eye_Of_Loki_Equipped");
		}

		if (FactsQuerySum("ACS_Pouch_Equipped") > 0)
		{
			GetACSPouchPropDestroyAll();

			FactsRemove("ACS_Pouch_Equipped");
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function Wearable_Bombs_Latent()
	{
		if (thePlayer.IsThrowHold()
		|| thePlayer.IsThrowingItem()
		|| thePlayer.IsThrowingItemWithAim()
		)
		{
			Remove_All_Bombs();
		}
		else
		{
			thePlayer.GetInventory().GetItemEquippedOnSlot(EES_Petard1, itemID_petard);

			if (thePlayer.inv.SingletonItemGetAmmo(itemID_petard) > 0)
			{
				petard_name = thePlayer.GetInventory().GetItemName( itemID_petard );

				switch (petard_name)
				{
					case 'Dancing Star 1':
					case 'Dancing Star 2':
					case 'Dancing Star 3':
					Dancing_Star_Equip();
					break;

					case 'Devils Puffball 1':
					case 'Devils Puffball 2':
					case 'Devils Puffball 3':
					Devils_Puffball_Equip();
					break;

					case 'Dwimeritium Bomb 1':
					case 'Dwimeritium Bomb 2':
					case 'Dwimeritium Bomb 3':
					Dwimeritium_Equip();
					break;

					case 'Dragons Dream 1':
					case 'Dragons Dream 2':
					case 'Dragons Dream 3':
					Dragons_Dream_Equip();
					break;

					case 'Grapeshot 1':
					case 'Grapeshot 2':
					case 'Grapeshot 3':
					Grapeshot_Equip();
					break;

					case 'Silver Dust Bomb 1':
					case 'Silver Dust Bomb 2':
					case 'Silver Dust Bomb 3':
					Silver_Dust_Equip();
					break;

					case 'White Frost 1':
					case 'White Frost 2':
					case 'White Frost 3':
					White_Frost_Equip();
					break;

					case 'Samum 1':
					case 'Samum 2':
					case 'Samum 3':
					Samum_Equip();
					break;

					case 'Salt Bomb 1':
					case 'Salt Bomb 2':
					case 'Salt Bomb 3':
					Salt_Bomb_Equip();
					break;

					case 'Glue Bomb 1':
					case 'Glue Bomb 2':
					case 'Glue Bomb 3':
					Glue_Bomb_Equip();
					break;

					case 'Fungi Bomb 1':
					case 'Fungi Bomb 2':
					case 'Fungi Bomb 3':
					Fungi_Bomb_Equip();
					break;

					case 'Shrapnel Bomb 1':
					case 'Shrapnel Bomb 2':
					case 'Shrapnel Bomb 3':
					Shrapnel_Bomb_Equip();
					break;

					case 'Virus Bomb 1':
					case 'Virus Bomb 2':
					case 'Virus Bomb 3':
					Virus_Bomb_Equip();
					break;

					default:
					Remove_All_Bombs();
					break;
				}
			}
			else
			{
				Remove_All_Bombs();
			}
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function Dancing_Star_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}

			if (ACS_Ard_Bombs_Installed() && ACS_Ard_Bombs_Enabled())
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				"items\weapons\projectiles\petards\petard_dancing_star.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			else
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_dancing_star_bomb_dummy.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			
			fake.AddTag('ACS_Dancing_Star_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Dancing_Star_Equipped");
		}
	}

	latent function Devils_Puffball_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}

			if (ACS_Ard_Bombs_Installed() && ACS_Ard_Bombs_Enabled())
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"dlc\dlc_acs\data\entities\other\petard_grapeshot_bomb_dummy_ard.w2ent"

				"items\weapons\projectiles\petards\petard_devils_puffball.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			else
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"items\weapons\projectiles\petards\petard_grapeshot.w2ent"

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_devils_puffball_bomb_dummy.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			
			fake.AddTag('ACS_Devils_Puffball_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Devils_Puffball_Equipped");
		}
	}

	latent function Dwimeritium_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}

			if (ACS_Ard_Bombs_Installed() && ACS_Ard_Bombs_Enabled())
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"dlc\dlc_acs\data\entities\other\petard_grapeshot_bomb_dummy_ard.w2ent"

				"items\weapons\projectiles\petards\petard_dimeritium_bomb.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			else
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"items\weapons\projectiles\petards\petard_grapeshot.w2ent"

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_dimeritium_bomb_dummy.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			
			fake.AddTag('ACS_Dwimeritium_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Dwimeritium_Bomb_Equipped");
		}
	}

	latent function Dragons_Dream_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}

			if (ACS_Ard_Bombs_Installed() && ACS_Ard_Bombs_Enabled())
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"dlc\dlc_acs\data\entities\other\petard_grapeshot_bomb_dummy_ard.w2ent"

				"items\weapons\projectiles\petards\petard_dragons_dream.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			else
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"items\weapons\projectiles\petards\petard_grapeshot.w2ent"

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_dragons_dream_bomb_dummy.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			
			fake.AddTag('ACS_Dragons_Dream_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Dragons_Dream_Equipped");
		}
	}

	latent function Grapeshot_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}
			
			if (ACS_Ard_Bombs_Installed() && ACS_Ard_Bombs_Enabled())
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"dlc\dlc_acs\data\entities\other\petard_grapeshot_bomb_dummy_ard.w2ent"

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_grapeshot_bomb_dummy_ard.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			else
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"items\weapons\projectiles\petards\petard_grapeshot.w2ent"

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_grapeshot_bomb_dummy.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			
			fake.AddTag('ACS_Grapeshot_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Grapeshot_Equipped");
		}
	}

	latent function Silver_Dust_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}

			if (ACS_Ard_Bombs_Installed() && ACS_Ard_Bombs_Enabled())
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"dlc\dlc_acs\data\entities\other\petard_grapeshot_bomb_dummy_ard.w2ent"

				"items\weapons\projectiles\petards\petard_silver_dust_bomb.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			else
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"items\weapons\projectiles\petards\petard_grapeshot.w2ent"

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_silver_dust_bomb_dummy.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			
			fake.AddTag('ACS_Silver_Dust_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Silver_Dust_Equipped");
		}
	}

	latent function White_Frost_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}

			if (ACS_Ard_Bombs_Installed() && ACS_Ard_Bombs_Enabled())
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"dlc\dlc_acs\data\entities\other\petard_grapeshot_bomb_dummy_ard.w2ent"

				"items\weapons\projectiles\petards\petard_white_frost.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			else
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"items\weapons\projectiles\petards\petard_grapeshot.w2ent"

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_white_frost_bomb_dummy.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			
			fake.AddTag('ACS_White_Frost_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_White_Frost_Equipped");
		}
	}

	latent function Samum_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}

			if (ACS_Ard_Bombs_Installed() && ACS_Ard_Bombs_Enabled())
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"dlc\dlc_acs\data\entities\other\petard_grapeshot_bomb_dummy_ard.w2ent"

				"items\weapons\projectiles\petards\petard_samum.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			else
			{
				fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync(

				//"items\weapons\projectiles\petards\petard_grapeshot.w2ent"

				"dlc\dlc_acs\data\entities\other\bomb_dummies\petard_samum_bomb_dummy.w2ent"
				
				, true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			}
			
			fake.AddTag('ACS_Samum_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Samum_Equipped");
		}
	}

	latent function Salt_Bomb_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}
			
			fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlcardbombs\data\items\weapons\projectiles\petards\bomb_salt.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			fake.AddTag('ACS_Salt_Bomb_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Salt_Bomb_Equipped");
		}
	}

	latent function Glue_Bomb_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}
			
			fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlcardbombs\data\items\weapons\projectiles\petards\bomb_glue.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			fake.AddTag('ACS_Glue_Bomb_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Glue_Bomb_Equipped");
		}
	}

	latent function Fungi_Bomb_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}
			
			fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlcardbombs\data\items\weapons\projectiles\petards\bomb_fungi.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			fake.AddTag('ACS_Fungi_Bomb_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Fungi_Bomb_Equipped");
		}
	}

	latent function Shrapnel_Bomb_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}
			
			fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlcardbombs\data\items\weapons\projectiles\petards\bomb_shrapnel.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			fake.AddTag('ACS_Shrapnel_Bomb_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Shrapnel_Bomb_Equipped");
		}
	}

	latent function Virus_Bomb_Equip()
	{
		var fake, dummy : CEntity; 
		var bIndex : int;
		var bName : name;
		var bPos, pPos : Vector;
		var bRot, pRot : EulerAngles;
		var meshComp : CMeshComponent;
		var option : int;

		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") <= 0)
		{
			if (!GetACSBombPropAnchor())
			{
				dummy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
				dummy.AddTag('ACS_Bomb_Prop_Anchor');
			}
			else 
			{
				dummy = GetACSBombPropAnchor();
			}
			
			fake = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync("dlc\dlcardbombs\data\items\weapons\projectiles\petards\bomb_virus.w2ent", true), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
			fake.AddTag('ACS_Virus_Bomb_Prop');
			
			bIndex = GetWitcherPlayer().GetBoneIndex( 'pelvis' );	
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( bIndex, bPos, bRot );
			
			dummy.CreateAttachmentAtBoneWS(GetWitcherPlayer(), 'pelvis', bPos, bRot );

			option = ACS_WearableBombsPositioning();

			switch ( option )
			{
				case 0: //back lower
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;

				case 1: //back higher
				pPos.X = 0.13;
				pPos.Y = -0.09;
				pPos.Z = 0.11;
				pRot.Roll = 115;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
				
				case 2: //front right
				pPos.X = -0.15;
				pPos.Y = -0.07;
				pPos.Z = 0.17;
				pRot.Roll = 130;
				pRot.Pitch = 290;
				pRot.Yaw = -40; 
				break;
				
				case 3: //front left
				pPos.X = -0.18;
				pPos.Y = -0.07;
				pPos.Z = -0.09;
				pRot.Roll = 155;
				pRot.Pitch = 265;
				pRot.Yaw = -20; 
				break;
				
				case 4: //Akatoshka7
				pPos.X = -0.15;
				pPos.Y = -0.18;
				pPos.Z = 0.17;
				pRot.Roll = 125;
				pRot.Pitch = 325;
				pRot.Yaw = -55; 
				break;
				
				default: //back right higher antr
				pPos.X = 0.13;
				pPos.Y = 0.01;
				pPos.Z = 0.11;
				pRot.Roll = 125;
				pRot.Pitch = 280;
				pRot.Yaw = -80; 
				break;
			}

			fake.CreateAttachment(dummy, , pPos, pRot );

			FactsAdd("ACS_Virus_Bomb_Equipped");
		}
	}

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function Remove_All_Bombs()
	{
		if (GetACSBombPropAnchor())
		{
			GetACSBombPropAnchor().Destroy();
		}
		
		if (FactsQuerySum("ACS_Dancing_Star_Equipped") > 0)
		{
			GetACSDancingStarPropDestroyAll();

			FactsRemove("ACS_Dancing_Star_Equipped");
		}

		if (FactsQuerySum("ACS_Devils_Puffball_Equipped") > 0)
		{
			GetACSDevilsPuffballPropDestroyAll();

			FactsRemove("ACS_Devils_Puffball_Equipped");
		}

		if (FactsQuerySum("ACS_Dwimeritium_Bomb_Equipped") > 0)
		{
			GetACSDwimeritiumPropDestroyAll();

			FactsRemove("ACS_Dwimeritium_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Dragons_Dream_Equipped") > 0)
		{
			GetACSDragonsDreamPropDestroyAll();

			FactsRemove("ACS_Dragons_Dream_Equipped");
		}

		if (FactsQuerySum("ACS_Grapeshot_Equipped") > 0)
		{
			GetACSGrapeshotPropDestroyAll();

			FactsRemove("ACS_Grapeshot_Equipped");
		}

		if (FactsQuerySum("ACS_Silver_Dust_Equipped") > 0)
		{
			GetACSSilverDustPropDestroyAll();

			FactsRemove("ACS_Silver_Dust_Equipped");
		}

		if (FactsQuerySum("ACS_White_Frost_Equipped") > 0)
		{
			GetACSWhiteFrostPropDestroyAll();

			FactsRemove("ACS_White_Frost_Equipped");
		}

		if (FactsQuerySum("ACS_Samum_Equipped") > 0)
		{
			GetACSSamumPropDestroyAll();

			FactsRemove("ACS_Samum_Equipped");
		}

		if (FactsQuerySum("ACS_Salt_Bomb_Equipped") > 0)
		{
			GetACSSaltBombPropDestroyAll();

			FactsRemove("ACS_Salt_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Glue_Bomb_Equipped") > 0)
		{
			GetACSGlueBombPropDestroyAll();

			FactsRemove("ACS_Glue_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Fungi_Bomb_Equipped") > 0)
		{
			GetACSFungiBombPropDestroyAll();

			FactsRemove("ACS_Fungi_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Shrapnel_Bomb_Equipped") > 0)
		{
			GetACSShrapnelBombPropDestroyAll();

			FactsRemove("ACS_Shrapnel_Bomb_Equipped");
		}

		if (FactsQuerySum("ACS_Virus_Bomb_Equipped") > 0)
		{
			GetACSVirusBombPropDestroyAll();

			FactsRemove("ACS_Virus_Bomb_Equipped");
		}
	}
}

function GetACSBombPropAnchor() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Bomb_Prop_Anchor' );
	return ent;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSDancingStarPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Dancing_Star_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Dancing_Star_Prop');
	}
}

function GetACSDevilsPuffballPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Devils_Puffball_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Devils_Puffball_Prop');
	}
}

function GetACSDwimeritiumPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Dwimeritium_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Dwimeritium_Prop');
	}
}

function GetACSDragonsDreamPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Dragons_Dream_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Dragons_Dream_Prop');
	}
}

function GetACSGrapeshotPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Grapeshot_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Grapeshot_Prop');
	}
}

function GetACSSilverDustPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Silver_Dust_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Silver_Dust_Prop');
	}
}

function GetACSWhiteFrostPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_White_Frost_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_White_Frost_Prop');
	}
}

function GetACSSamumPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Samum_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Samum_Prop');
	}
}

function GetACSSaltBombPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Salt_Bomb_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Salt_Bomb_Prop');
	}
}

function GetACSGlueBombPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Glue_Bomb_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Glue_Bomb_Prop');
	}
}

function GetACSFungiBombPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Fungi_Bomb_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Fungi_Bomb_Prop');
	}
}

function GetACSShrapnelBombPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Shrapnel_Bomb_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Shrapnel_Bomb_Prop');
	}
}

function GetACSVirusBombPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Virus_Bomb_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Virus_Bomb_Prop');
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSItemPropAnchor() : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Item_Prop_Anchor' );
	return ent;
}

function GetACSTorchPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Torch_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Torch_Prop');
	}
}

function GetACSMagicLampPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Magic_Lamp_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Magic_Lamp_Prop');
	}
}

function GetACSOilLampPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Oil_Lamp_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Oil_Lamp_Prop');
	}
}

function GetACSCenserPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Censer_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Censer_Prop');
	}
}

function GetACSNavigatorHornPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Navigator_Horn_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Navigator_Horn_Prop');
	}
}

function GetACSLurePropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Lure_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Lure_Prop');
	}
}

function GetACSBellPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Bell_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Bell_Prop');
	}
}

function GetACSPotestaquisitorPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Potestaquisitor_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Potestaquisitor_Prop');
	}
}

function GetACSEyeOfLokiPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Eye_Of_Loki_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Eye_Of_Loki_Prop');
	}
}

function GetACSPouchPropDestroyAll()
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( 'ACS_Pouch_Prop', item );	
	
	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.01);
		item[i].RemoveTag('ACS_Pouch_Prop');
	}
}