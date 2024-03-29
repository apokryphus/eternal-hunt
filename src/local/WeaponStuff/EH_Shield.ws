// CNTRL + F THE WORD [SHIELDS] TO LEARN HOW TO SWAP THE SHIELD FOR AXII PRIMARY WEAPON STANCE.

function ACS_Shield_Destroy()
{		
	ACS_Axii_Shield_Destroy();
	ACS_Axii_Shield_Destroy_DELAY();
	Quen_Monsters_Despawn();
	Bruxa_Camo_Decoy_Deactivate();
	AardPull_Deactivate();

	//GetWitcherPlayer().RemoveTag('acs_bow_active');
	//GetWitcherPlayer().RemoveTag('acs_crossbow_active');
}

statemachine class cACS_Shield_Summon
{		
    function Axii_Shield_Summon()
	{	
		this.PushState('Axii_Shield');
	}

	function Axii_Persistent_Shield_Summon()
	{
		if(!GetWitcherPlayer().HasTag('ACS_Shield_Summoned'))
		{
			this.PushState('Axii_Persistent_Shield');
		}
	}

	function Axii_Shield_Entity()
	{	
		this.PushState('Axii_Shield_Entity');
	}

	function BruxaCamoDecoy()
	{
		this.PushState('BruxaCamoDecoy');
	}

	function Quen_Monster_Summon()
	{
		if ( GetWitcherPlayer().GetStat( BCS_Vitality ) <= GetWitcherPlayer().GetStatMax( BCS_Vitality )/2 )
		{
			GetWitcherPlayer().DrainVitality((GetWitcherPlayer().GetStat(BCS_Vitality) * 0.15) );

			this.PushState('Quen_Centipede_Summon');
		}
		else
		{
			GetWitcherPlayer().DrainVitality((GetWitcherPlayer().GetStat(BCS_Vitality) * 0.2) );

			this.PushState('Quen_Wolf_Summon');
		}
	}

	function Aard_Pull()
	{
		this.PushState('Aard_Pull');
	}

	function Yrden_Skele_Summon()
	{
		if ( GetWitcherPlayer().GetStat( BCS_Vitality ) <= GetWitcherPlayer().GetStatMax( BCS_Vitality )/2 )
		{
			this.PushState('Yrden_Skele_Summon_Normal');
		}
		else
		{
			this.PushState('Yrden_Revive_Normal');
		}
	}
}

state Aard_Pull in cACS_Shield_Summon
{
	private var playerRot									: EulerAngles;
	private var markerNPC									: CEntity;
	private var playerPos, spawnPos							: Vector;
	private var randAngle, randRange						: float;
	private var i, markerCount								: int;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		AardPull_Entry();
	}

	entry function AardPull_Entry()
	{
		AardPull_Latent();
	}

	latent function AardPull_Latent()
	{	
		if (!GetWitcherPlayer().HasTag('ACS_AardPull_Active'))
		{
			GetWitcherPlayer().AddTag('ACS_AardPull_Active');
		}
		
		GetWitcherPlayer().PlayEffectSingle('swarm_gathers');
		GetWitcherPlayer().StopEffect('swarm_gathers');

		SpawnBats();
	}

	latent function SpawnBats()
	{
		playerPos = GetWitcherPlayer().GetWorldPosition();

		playerRot = GetWitcherPlayer().GetWorldRotation();
	
		markerCount = 6;

		for( i = 0; i < markerCount; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + playerPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + playerPos.Y;
			spawnPos.Z = playerPos.Z;
			spawnPos.Z -= 1;

			playerRot.Yaw = RandRangeF(360,1);
			playerRot.Pitch = RandRangeF(45,-45);

			if( RandF() < 0.75 ) 
			{
				if( RandF() < 0.5 ) 
				{
					if( RandF() < 0.5 ) 
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_01.w2ent"
							
							, true ), spawnPos, playerRot );
					}
					else
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_02.w2ent"
							
							, true ), spawnPos, playerRot );
					}
				}
				else
				{
					if( RandF() < 0.5 ) 
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
	
							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_03.w2ent"
							
							, true ), spawnPos, playerRot );
					}
					else
					{
						markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

							"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_04.w2ent"
							
							, true ), spawnPos, playerRot );
					}
				}
			}
			else
			{
				if( RandF() < 0.5 ) 
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

						"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_05.w2ent"
						
						, true ), spawnPos, playerRot );
				}
				else 
				{
					markerNPC = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
						
						"dlc\bob\data\fx\quest\q704\street_bat_swarm\bat_swarm_06.w2ent"
						
						, true ), spawnPos, playerRot );
				}
			}
			markerNPC.PlayEffectSingle('bat_swarm');
			markerNPC.DestroyAfter(3);
		}
	}
}

state BruxaCamoDecoy in cACS_Shield_Summon
{
	private var envID 										: int;
	private var i 											: int;
	private var npc     									: CNewNPC;
	private var npcActor     								: CActor;
	private var actors										: array< CActor >;
	private var animatedComponentA 							: CAnimatedComponent;
	private var settingsA									: SAnimatedComponentSlotAnimationSettings;
	private var attach_vec									: Vector;
	private var attach_rot									: EulerAngles;
	private var vfxEnt_1, vfxEnt_2, vfxEnt_3				: CEntity;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		BruxaCamo_Entry();
	}

	entry function BruxaCamo_Entry()
	{
		BruxaCamo_Latent();
	}

	latent function BruxaCamo_Latent()
	{	
		GetWitcherPlayer().StopAllEffects();
		GetWitcherPlayer().DestroyEffect('shadowdash');
		GetWitcherPlayer().PlayEffectSingle('shadowdash');

		if (GetACSHelm1())
		{
			GetACSHelm1().PlayEffectSingle('shadowdash');
		}

		if (GetACSHelm2())
		{
			GetACSHelm2().PlayEffectSingle('shadowdash');
		}

		if (GetACSHelm3())
		{
			GetACSHelm3().PlayEffectSingle('shadowdash');
		}

		if (GetACSHelm4())
		{
			GetACSHelm4().PlayEffectSingle('shadowdash');
		}

		GetWitcherPlayer().SoundEvent("monster_bruxa_combat_disappear");

		GetWitcherPlayer().SoundEvent( "expl_focus_start" );

		/*
		ACS_Vampire_Arms_1_Get().Destroy();

		ACS_Vampire_Arms_2_Get().Destroy();

		ACS_Vampire_Arms_3_Get().Destroy();

		ACS_Vampire_Arms_4_Get().Destroy();

		ACS_Vampire_Arms_Anchor_L_Get().Destroy();

		ACS_Vampire_Arms_Anchor_R_Get().Destroy();

		ACS_Vampire_Head_Anchor_Get().Destroy();

		ACS_Vampire_Head_Get().Destroy();

		ACS_Vampire_Back_Claw_Get().Destroy();

		ACS_Vampire_Claw_Anchor_Get().Destroy();
		*/

		//ACS_Blood_Armor_Destroy();

		GetACSWatcher().ACS_Vampire_Back_Claw_Teleport();

		GetWitcherPlayer().AddTag('ACS_Camo_Active');

		GetACSWatcher().Activate_Bruxa_Camo_Env();

		NPC_Fear_Start();

		EnableCatViewFx( 1.5 );
		SetTintColorsCatViewFx(Vector(0.1f,0.12f,0.13f,0.6f),Vector(0.075f,0.1f,0.11f,0.6f),1.25);
		SetBrightnessCatViewFx(100.0f);
		SetViewRangeCatViewFx(500.0f);
		SetPositionCatViewFx( Vector(0,0,0,0) , true );	
		SetHightlightCatViewFx( Vector(0.5f,0.2f,0.2f,1.f),0.05f,10);
		SetFogDensityCatViewFx( 0.25 );

		ACS_Bruxa_Camo_Trail().Destroy();

		ACS_Bruxa_Camo_Sonar().Destroy();

		ACS_Bruxa_Camo_Sonar_2().Destroy();

		vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource(
			//"dlc\dlc_acs\data\fx\acs_sonar.w2ent"
			//"dlc\bob\data\fx\gameplay\mutation\mutation_7\mutation_7.w2ent"
			"dlc\dlc_acs\data\fx\acs_pulse_1.w2ent"
			, true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		vfxEnt_1.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, -1 ), EulerAngles(0,0,0) );

		vfxEnt_1.AddTag('ACS_Bruxa_Camo_Sonar');

		vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource(
			"dlc\dlc_acs\data\fx\acs_pulse.w2ent"
			, true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		vfxEnt_1.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 0.5 ), EulerAngles(0,0,0) );

		vfxEnt_1.AddTag('ACS_Bruxa_Camo_Sonar_2');

		vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource(
			//"dlc\bob\data\fx\monsters\bruxa\alp_teleport_trail.w2ent"
			"dlc\bob\data\fx\cutscenes\cs704_detalff_destroyed\trasnform_smoke_body.w2ent"
			, true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

		vfxEnt_2.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, 1 ), EulerAngles(0,0,0) );

		vfxEnt_2.AddTag('ACS_Bruxa_Camo_Trail');
	}

	latent function HighlightEnemies()
	{
		var ents : array<CGameplayEntity>;
		var i : int;
		var catComponent : CGameplayEffectsComponent;

		FindGameplayEntitiesInSphere(ents, GetWitcherPlayer().GetWorldPosition(), 100, 100, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);
		
		for(i=0; i<ents.Size(); i+=1)
		{
			if(IsRequiredAttitudeBetween(GetWitcherPlayer(), ents[i], true))
			{
				catComponent = GetGameplayEffectsComponent(ents[i]);

				if(catComponent)
				{
					catComponent.SetGameplayEffectFlag(EGEF_CatViewHiglight, true);
				}

				ents[i].AddTag('ACS_Bruxa_Camo_Highlighted_Enemies');
			}
		}
	}

	latent function NPC_Fear_Start()
	{
		actors.Clear();

		//ACS_Focus_Sound_Red_Destroy();

		ACS_Bruxa_Camo_Sonar_NPC_Destroy();

		HighlightEnemies();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];

			npcActor = (CActor)actors[i];
				
			animatedComponentA = (CAnimatedComponent)npcActor.GetComponentByClassName( 'CAnimatedComponent' );	
				
			settingsA.blendIn = 1;
			settingsA.blendOut = 1;
				
			if( actors.Size() > 0 )
			{
				if (npcActor.IsAlive()
				&& !theGame.IsDialogOrCutscenePlaying()
				&& !GetWitcherPlayer().IsUsingHorse() 
				&& !GetWitcherPlayer().IsUsingVehicle()
				&& npcActor.IsHuman()
				)
				{				
					npcActor.RemoveTag('fear_end');

					attach_rot.Roll = 0;
					attach_rot.Pitch = 0;
					attach_rot.Yaw = 0;

					attach_vec.X = 0;
					attach_vec.Y = 0;

					if (((CMovingPhysicalAgentComponent)(npcActor.GetMovingAgentComponent())).GetCapsuleHeight() > 2.25
					|| npcActor.GetRadius() > 0.7
					)
					{
						attach_vec.Z = 1.75;
					}
					else
					{
						attach_vec.Z = 1;
					}

					/*
					vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\fx\acs_red_focus.w2ent", true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

					vfxEnt.CreateAttachment( npc, , attach_vec, attach_rot );

					vfxEnt.PlayEffectSingle('focus_sound_red_fx');
					vfxEnt.PlayEffectSingle('focus_sound_red_fx');
					vfxEnt.PlayEffectSingle('focus_sound_red_fx');
					vfxEnt.PlayEffectSingle('focus_sound_red_fx');
					vfxEnt.PlayEffectSingle('focus_sound_red_fx');

					vfxEnt.AddTag('ACS_Focus_Sound_Red');
					*/

					vfxEnt_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource(
						//"dlc\dlc_acs\data\fx\acs_sonar.w2ent"

						"dlc\bob\data\fx\monsters\sharley\detection\detection_player_fx.w2ent"

						, true ), GetWitcherPlayer().GetWorldPosition(), GetWitcherPlayer().GetWorldRotation() );

					vfxEnt_3.CreateAttachment( npc, , Vector( 0, 0, 0 ), EulerAngles(0,0,0) );

					vfxEnt_3.AddTag('ACS_Bruxa_Camo_Sonar_NPC');

					animatedComponentA.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', settingsA);	
				}
			}
		}
	}
}

function ACS_Bruxa_Camo_Trail() : CEntity
{
	var ent 			 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Bruxa_Camo_Trail' );

	return ent;
}

function ACS_Bruxa_Camo_Sonar_NPC_Play_Effect()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Bruxa_Camo_Sonar_NPC', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		/*
		ents[i].DestroyEffect('fx_sonar');

		ents[i].PlayEffectSingle('fx_sonar');
		ents[i].PlayEffectSingle('fx_sonar');
		ents[i].PlayEffectSingle('fx_sonar');
		ents[i].PlayEffectSingle('fx_sonar');
		ents[i].PlayEffectSingle('fx_sonar');

		ents[i].StopEffect('fx_sonar');
		*/

		ents[i].DestroyEffect('detection');

		ents[i].PlayEffectSingle('detection');
		ents[i].PlayEffectSingle('detection');
		ents[i].PlayEffectSingle('detection');
		ents[i].PlayEffectSingle('detection');

		ents[i].StopEffect('detection');
	}

	GetWitcherPlayer().SoundEvent("expl_focus_start");

	theSound.SoundEvent( 'expl_focus_start' ); 

	GetWitcherPlayer().SoundEvent("expl_focus_stop_sfx");

	theSound.SoundEvent( 'expl_focus_stop_sfx' ); 
}

function ACS_Bruxa_Camo_Highlighted_Enemies_Remove_Highlight()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Bruxa_Camo_Highlighted_Enemies', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].AddTimer( 'EnemyHighlightOff', 0, false, , , , true );
	}
}

function ACS_Bruxa_Camo_Sonar_NPC_Destroy()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Bruxa_Camo_Sonar_NPC', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACS_Bruxa_Camo_Sonar_Destroy()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Bruxa_Camo_Sonar', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACS_Bruxa_Camo_Sonar() : CEntity
{
	var ent 			 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Bruxa_Camo_Sonar' );

	return ent;
}

function ACS_Bruxa_Camo_Sonar_2() : CEntity
{
	var ent 			 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Bruxa_Camo_Sonar_2' );

	return ent;
}

function ACS_Focus_Sound_Red_Destroy()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Focus_Sound_Red', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACS_Focus_Sound_Red() : CEntity
{
	var ent 			 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( 'ACS_Focus_Sound_Red' );

	return ent;
}

state Yrden_Revive_Normal in cACS_Shield_Summon
{
	private var rev_temp																								: CEntityTemplate;
	private var rev_ent																									: CEntity;
	private var entities																								: array<CGameplayEntity>;
	private var i																										: int;
	private var npc																										: CNewNPC;
	private var revAnimatedComponent 																					: CAnimatedComponent;
	private var revMovementAdjustor																						: CMovementAdjustor; 
	private var revTicket 																								: SMovementAdjustmentRequestTicket; 
	private var curVitality, maxVitality, curMorale, maxMorale, curStamina, maxStamina, curEssence, maxEssence, damage	: float;
	private var action 																									: W3DamageAction;
	private var actor 																									: CActor;	
	private var dismembermentComp 																						: CDismembermentComponent;
	private var wounds																									: array< name >;
	private var usedWound																								: name;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Revive_Entry();
	}

	entry function Revive_Entry()
	{
		Revive_Latent();
	}

	latent function Revive_Latent()
	{
		entities.Clear();

		FindGameplayEntitiesInRange( entities, GetWitcherPlayer(), 10, 10,, FLAG_ExcludePlayer,,'CNewNPC' );

		for (i = 0; i < entities.Size(); i += 1) 
		{
			npc = (CNewNPC)entities[i];

			if (!npc.IsAlive() && GetWitcherPlayer().IsInCombat()) 
			{
				curVitality = GetWitcherPlayer().GetStat( BCS_Vitality );

				if (npc.UsesEssence())
				{
					if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() > 2
					|| npc.GetRadius() > 0.6
					)
					{
						damage = curVitality * 0.2;
					}
					else
					{
						damage = curVitality * 0.075;
					}
				}
				else if (npc.UsesVitality()) 
				{
					damage = curVitality * 0.05;
				}

				GetWitcherPlayer().ForceSetStat( BCS_Vitality,  curVitality - damage );

				if (npc.IsHuman())
				{
					rev_ent = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(npc.GetReadableName(), true ), npc.GetBoneWorldPosition('torso3'), npc.GetWorldRotation() );
				}
				else
				{
					rev_ent = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(npc.GetReadableName(), true ), npc.GetWorldPosition(), npc.GetWorldRotation() );
				}
				
				((CNewNPC)rev_ent).SetLevel(npc.GetLevel());
				//((CNewNPC)rev_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
				((CNewNPC)rev_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
				((CNewNPC)rev_ent).NoticeActor(GetWitcherPlayer().GetTarget());

				/*
				dismembermentComp = (CDismembermentComponent)(((CActor)rev_ent).GetComponentByClassName( 'CDismembermentComponent' ));

				dismembermentComp.GetWoundsNames( wounds, WTF_Explosion );

				if ( wounds.Size() > 0 )
				{
					usedWound = wounds[ RandRange( wounds.Size() ) ];
				}
			
				((CActor)rev_ent).SetDismembermentInfo( usedWound, ((CActor)rev_ent).GetWorldPosition() - ((CActor)rev_ent).GetWorldPosition(), true );

				((CActor)rev_ent).AddTimer( 'DelayedDismemberTimer', 0.05f );
				*/
				
				maxVitality = ((CNewNPC)rev_ent).GetStatMax( BCS_Vitality );

				maxEssence = ((CNewNPC)rev_ent).GetStatMax( BCS_Essence );

				maxMorale = ((CNewNPC)rev_ent).GetStatMax( BCS_Morale );

				maxStamina = ((CNewNPC)rev_ent).GetStatMax( BCS_Stamina );

				if (((CNewNPC)rev_ent).UsesEssence())
				{
					((CNewNPC)rev_ent).ForceSetStat( BCS_Essence, maxEssence * 0.05 );  
				}
				else if (((CNewNPC)rev_ent).UsesVitality())
				{
					((CNewNPC)rev_ent).ForceSetStat( BCS_Vitality, maxVitality * 0.1 );  
				}

				((CNewNPC)rev_ent).ForceSetStat( BCS_Morale, maxMorale );  
				((CNewNPC)rev_ent).ForceSetStat( BCS_Stamina, maxStamina );  

				//((CNewNPC)rev_ent).SetAnimationSpeedMultiplier(RandRangeF(0.75,1.25));
								
				//((CNewNPC)rev_ent).SetAnimationTimeMultiplier(RandRangeF(0.75,1.25));

				if ( !((CNewNPC)rev_ent).HasBuff( EET_Poison ) )
				{
					//((CNewNPC)rev_ent).AddEffectDefault( EET_Poison, ((CNewNPC)rev_ent), 'acs' );
				}

				if ( !((CNewNPC)rev_ent).HasBuff( EET_Bleeding ) )
				{
					//((CNewNPC)rev_ent).AddEffectDefault( EET_Bleeding, ((CNewNPC)rev_ent), 'acs' );
				}

				if ( !((CNewNPC)rev_ent).HasBuff( EET_AutoMoraleRegen ) )
				{
					((CNewNPC)rev_ent).AddEffectDefault( EET_AutoMoraleRegen, ((CNewNPC)rev_ent), 'acs' );
				}

				if ( !((CNewNPC)rev_ent).HasBuff( EET_AutoStaminaRegen ) )
				{
					((CNewNPC)rev_ent).AddEffectDefault( EET_AutoStaminaRegen, ((CNewNPC)rev_ent), 'acs' );
				}

				if ( !((CNewNPC)rev_ent).HasBuff( EET_AutoPanicRegen ) )
				{
					((CNewNPC)rev_ent).AddEffectDefault( EET_AutoPanicRegen, ((CNewNPC)rev_ent), 'acs' );
				}

				rev_ent.PlayEffectSingle('blood_spill');
				rev_ent.PlayEffectSingle('blood_throat_cut');
				rev_ent.PlayEffectSingle('yrden_shock');
				rev_ent.PlayEffectSingle('yrden_slowdown');
				rev_ent.PlayEffectSingle('critical_poison');

				rev_ent.AddTag('ACS_Revenant');

				npc.Teleport( GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -50 ) );
				npc.DestroyAfter(0.5);

				revAnimatedComponent = (CAnimatedComponent)rev_ent.GetComponentByClassName( 'CAnimatedComponent' );	

				if (npc.IsHuman())
				{
					if( RandF() < 0.5 ) 
					{
						revAnimatedComponent.PlaySlotAnimationAsync ( 'exploration_effect_getup_front', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
					}
					else
					{
						revAnimatedComponent.PlaySlotAnimationAsync ( 'exploration_effect_getup_back', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0.5f));
					}
				}
			}
		}
	}
}

state Yrden_Skele_Summon_Normal in cACS_Shield_Summon
{
	private var skele_temp																		: CEntityTemplate;
	private var skele_ent																		: CEntity;
	private var tomb_temp																		: CEntityTemplate;
	private var tomb_ent																		: CEntity;
	private var actor       																	: CActor;
	private var i																				: int;
	private var targetBonePositionNPC															: Vector;
	private var randAngle, randRange															: float;
	private var entities																		: array<CGameplayEntity>;
	private var npc																				: CNewNPC;
	private var tomb_names																		: array< string >;
	private var targetRotationNPC																: EulerAngles;
	private var tombmeshcomp 																	: CComponent;
	private var skelemeshcomp 																	: CComponent;
	private var skeleanimcomp 																	: CAnimatedComponent;
	private var h, damage, curVitality															:float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Skele_Destroy();
		Skele_Summon();
	}

	entry function Skele_Summon()
	{
		Skele_Summon_Actual();
	}

	latent function tomb_names_array()
	{
		tomb_names.Clear();
		tomb_names.PushBack("dlc\bob\data\environment\decorations\gameplay\generic\stone\gravestones\entities\bob_tombstone_05.w2ent");
		tomb_names.PushBack("dlc\bob\data\quests\minor_quests\quest_files\mq7017_talking_horse\entities\mq7017_tombstone.w2ent");
	}

	latent function Skele_Summon_Actual()
	{
		entities.Clear();

		FindGameplayEntitiesInRange( entities, GetWitcherPlayer(), 20, 15,, FLAG_ExcludePlayer,,'CNewNPC' );

		for (i = 0; i < entities.Size(); i += 1) 
		{
			npc = (CNewNPC)entities[i];

			if (!npc.IsAlive() && GetWitcherPlayer().IsInCombat()) 
			{
				curVitality = GetWitcherPlayer().GetStat( BCS_Vitality );
		
				damage = curVitality * 0.1;

				GetWitcherPlayer().ForceSetStat( BCS_Vitality,  curVitality - damage );

				tomb_names_array();

				if( RandF() < 0.75 ) 
				{
					skele_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\monsters\skele_1.w2ent", true);
				}
				else
				{
					skele_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\monsters\skele_2.w2ent", true);
				}

				tomb_temp = (CEntityTemplate)LoadResource(tomb_names[RandRange(tomb_names.Size())], true);

				targetBonePositionNPC = ACSPlayerFixZAxis(npc.GetBoneWorldPosition('torso3') + npc.GetWorldForward() * 2 + npc.GetWorldRight() * -1.5);
				targetBonePositionNPC.Z -= 1.5;
				
				if (npc.IsHuman())
				{
					skele_ent = theGame.CreateEntity( skele_temp, targetBonePositionNPC, npc.GetWorldRotation() );
				}
				else
				{
					skele_ent = theGame.CreateEntity( skele_temp, npc.GetWorldPosition(), npc.GetWorldRotation() );
				}

				skelemeshcomp = skele_ent.GetComponentByClassName('CMeshComponent');
				skeleanimcomp = (CAnimatedComponent)skele_ent.GetComponentByClassName('CAnimatedComponent');
				h = RandRangeF(0.75,1.25);
				skelemeshcomp.SetScale(Vector(h,h,h,1));
				skeleanimcomp.SetScale(Vector(h,h,h,1));	

				((CNewNPC)skele_ent).SetAnimationSpeedMultiplier(RandRangeF(1,1.5));
								
				((CNewNPC)skele_ent).SetAnimationTimeMultiplier(RandRangeF(1,1.5));

				targetRotationNPC = npc.GetWorldRotation();
				targetRotationNPC.Yaw = RandRangeF(360,1);
				targetRotationNPC.Pitch = RandRangeF(45,-45);

				if (npc.IsHuman())
				{
					tomb_ent = theGame.CreateEntity( tomb_temp, ACSPlayerFixZAxis(npc.GetBoneWorldPosition('torso3')), targetRotationNPC );
				}
				else
				{
					tomb_ent = theGame.CreateEntity( tomb_temp, ACSPlayerFixZAxis(npc.GetWorldPosition()), targetRotationNPC );
				}

				tombmeshcomp = tomb_ent.GetComponentByClassName('CMeshComponent');
				h = RandRangeF(1,1.5);
				tombmeshcomp.SetScale(Vector(h,h,h,1));

				((CNewNPC)skele_ent).SetLevel(GetWitcherPlayer().GetLevel());
				((CNewNPC)skele_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
				((CNewNPC)skele_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
				((CNewNPC)skele_ent).NoticeActor(GetWitcherPlayer().GetTarget());

				skele_ent.PlayEffectSingle('appear');
				skele_ent.StopEffect('appear');
				skele_ent.PlayEffectSingle('explode');
				skele_ent.StopEffect('explode');
				skele_ent.PlayEffectSingle('critical_burning_green');
				skele_ent.PlayEffectSingle('yrden_shock');
				skele_ent.PlayEffectSingle('yrden_slowdown');

				skele_ent.AddTag( 'ACS_Summoned_Skeleton' );

				tomb_ent.PlayEffect('fx');

				tomb_ent.DestroyAfter(30);
			}

			Sleep(RandRangeF(0.25,0.5));
		}
	}
}

state Quen_Wolf_Summon in cACS_Shield_Summon
{
	private var wolf_temp																		: CEntityTemplate;
	private var wolf_ent																		: CEntity;
	private var actor       																	: CActor;
	private var i, wolfCount																	: int;
	private var actorPos, spawnPos																: Vector;
	private var randAngle, randRange															: float;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Wolf_Destroy();
		Wolf_Summon();
	}
	
	entry function Wolf_Summon()
	{
		Wolf_Summon_Actual();
	}
	
	latent function Wolf_Summon_Actual()
	{	
		actor = (CActor)( GetWitcherPlayer().GetTarget() );
		
		actorPos = actor.GetWorldPosition();
		
		wolf_temp = (CEntityTemplate)LoadResource( 

		"dlc/dlc_acs/data/entities/monsters/summoned_wolf.w2ent"

		, true );
		
		wolfCount = 3;
		
		for( i = 0; i < wolfCount; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
			spawnPos.Z = actorPos.Z;
			
			wolf_ent = theGame.CreateEntity( wolf_temp, spawnPos, actor.GetWorldRotation() );
			
			((CNewNPC)wolf_ent).SetLevel(GetWitcherPlayer().GetLevel());
			((CNewNPC)wolf_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
			((CNewNPC)wolf_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
			//((CNewNPC)wolf_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
			((CNewNPC)wolf_ent).EnableCharacterCollisions(false);
		
			wolf_ent.PlayEffectSingle('appear');
			wolf_ent.StopEffect('appear');
			wolf_ent.PlayEffectSingle('shadow_form');
			wolf_ent.PlayEffectSingle('demonic_possession');
			wolf_ent.PlayEffectSingle('shadow_form_2');
			
			wolf_ent.AddTag( 'ACS_Summoned_Wolf' );
		}

		GetWitcherPlayer().AddTag('ACS_Has_Summoned_Wolf');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Quen_Centipede_Summon in cACS_Shield_Summon
{
	private var centipede_temp																	: CEntityTemplate;
	private var centipede_ent																	: CEntity;
	private var meshcomp																		: CComponent;
	private var animcomp 																		: CAnimatedComponent;
	private var h 																				: float;
	private var actor       																	: CActor;
	private var i, centipedeCount																: int;
	private var actorPos, spawnPos																: Vector;
	private var randAngle, randRange															: float;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ACS_Centipede_Destroy();
		Centipede_Summon();
	}
	
	entry function Centipede_Summon()
	{
		Centipede_Summon_Actual();
	}
	
	latent function Centipede_Summon_Actual()
	{	
	
		actor = (CActor)( GetWitcherPlayer().GetTarget() );
		
		actorPos = actor.GetWorldPosition();
		
		centipede_temp = (CEntityTemplate)LoadResource( 

		"dlc/dlc_acs/data/entities/monsters/centipede.w2ent"

		, true );
		
		centipedeCount = 3;
		
		for( i = 0; i < centipedeCount; i += 1 )
		{
			randRange = 2.5 + 2.5 * RandF();
			randAngle = 2 * Pi() * RandF();
			
			spawnPos.X = randRange * CosF( randAngle ) + actorPos.X;
			spawnPos.Y = randRange * SinF( randAngle ) + actorPos.Y;
			spawnPos.Z = actorPos.Z;
			
			centipede_ent = theGame.CreateEntity( centipede_temp, spawnPos, actor.GetWorldRotation() );
			animcomp = (CAnimatedComponent)centipede_ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = centipede_ent.GetComponentByClassName('CMeshComponent');
			h = 2;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			((CNewNPC)centipede_ent).SetLevel(GetWitcherPlayer().GetLevel());
			((CNewNPC)centipede_ent).SetAttitude(GetWitcherPlayer(), AIA_Friendly);
			((CNewNPC)centipede_ent).SetTemporaryAttitudeGroup('player', AGP_Default);
			((CNewNPC)centipede_ent).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
			((CNewNPC)centipede_ent).EnableCharacterCollisions(false);
		
			centipede_ent.PlayEffectSingle('shadow_form');
			centipede_ent.PlayEffectSingle('demonic_possession');
			
			centipede_ent.AddTag( 'ACS_Summoned_Centipede' );
		}

		GetWitcherPlayer().AddTag('ACS_Has_Summoned_Centipede');
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Axii_Shield in cACS_Shield_Summon
{
	private var shield_temp														: CEntityTemplate;
	private var shield, shield_pre												: CEntity;
	//private var settings_interrupt											: SAnimatedComponentSlotAnimationSettings;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Shield_Summon();
	}
	
	entry function Shield_Summon()
	{
		//shield_pre = (CEntity)theGame.GetEntityByTag( 'ACS_Shield' );
		//shield_pre.Destroy();
		SummonAxiiShield();
	}

	latent function SummonAxiiShield()
	{	
		//settings_interrupt.blendIn = 0;
		//settings_interrupt.blendOut = 0;

		//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( ' ', 'PLAYER_SLOT', settings_interrupt );

		if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			GetWitcherPlayer().AddBuffImmunity	( EET_Stagger,					'acs_shield', false);
			GetWitcherPlayer().AddBuffImmunity	( EET_LongStagger,				'acs_shield', false);
			GetWitcherPlayer().AddBuffImmunity	( EET_Knockdown,				'acs_shield', false);
			GetWitcherPlayer().AddBuffImmunity	( EET_HeavyKnockdown,			'acs_shield', false);
			GetWitcherPlayer().AddBuffImmunity	( EET_KnockdownTypeApplicator,	'acs_shield', false);

			//shield = (CEntity)theGame.CreateEntity( shield_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

			//shield.CreateAttachment( GetWitcherPlayer(), 'l_weapon' );

			//shield.AddTag('ACS_Shield');

			if(!GetWitcherPlayer().HasTag('ACS_Shielded'))
			{
				GetWitcherPlayer().AddTag('ACS_Shielded');
			}
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Axii_Persistent_Shield in cACS_Shield_Summon
{
	private var shield_temp														: CEntityTemplate;
	private var shield, shield_pre												: CEntity;
	//private var settings_interrupt												: SAnimatedComponentSlotAnimationSettings;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Persistent_Shield_Summon();
	}
	
	entry function Persistent_Shield_Summon()
	{
		//Sleep(0.5);
		shield_pre = (CEntity)theGame.GetEntityByTag( 'ACS_Shield' );
		shield_pre.Destroy();
		Persistent_SummonAxiiShield();
	}

	latent function Persistent_SummonAxiiShield()
	{	
		if (GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
		{
			GetWitcherPlayer().RemoveTag('ACS_Special_Dodge');
		}

		shield_temp = (CEntityTemplate)LoadResource( 
		
		// SHIELDS
		
		//"items\weapons\unique\imlerith_shield_new.w2ent" // REPLACE IN THE QUOTATIONS WHAT SHIELD YOU WANT TO USE. DEFAULT IS IMLERITH'S SHIELD.

		//"dlc\dlc_acs\data\entities\other\imlerith_shield_damaged.w2ent"

		"dlc\dlc_acs\data\entities\other\amasii_shield.w2ent"
		
		// LIST OF AVAILABLE SHIELDS TO USE //
		
		// VANILLA GAME SHIELDS
		// items\weapons\shields\bandit_shield_01.w2ent
		// items\weapons\shields\bandit_shield_02.w2ent
		// items\weapons\shields\bandit_shield_03.w2ent
		// items\weapons\shields\bandit_shield_04.w2ent
		// items\weapons\shields\baron_guard_shield_01.w2ent
		// items\weapons\shields\nilfgaard_shield_01.w2ent
		// items\weapons\shields\nilfgaard_shield_02.w2ent
		// items\weapons\shields\novigrad_shield_01.w2ent
		// items\weapons\shields\novigrad_shield_02.w2ent
		// items\weapons\shields\redanian_shield_01.w2ent
		// items\weapons\shields\skellige_brokvar_shield_01.w2ent
		// items\weapons\shields\skellige_craite_shield_01.w2ent
		// items\weapons\shields\skellige_dimun_shield_01.w2ent
		// items\weapons\shields\skellige_drummond_shield_01.w2ent
		// items\weapons\shields\skellige_heymaey_shield_01.w2ent
		// items\weapons\shields\skellige_tuiseach_shield_01.w2ent
		// items\weapons\shields\temeria_shield_01.w2ent
		
		// HEART OF STONE SHIELDS
		// dlc\ep1\data\items\weapons\shields\borsody_shield_01.w2ent
		// dlc\ep1\data\items\weapons\shields\flaming_rose_shield_01.w2ent
		// dlc\ep1\data\items\weapons\shields\hakland_shield_01.w2ent
		// dlc\ep1\data\items\weapons\shields\olgierd_man_shield_01.w2ent
		
		// BLOOD AND WINE SHIELDS
		// dlc\bob\data\items\weapons\shields\toussaint_shield_01_1_peyrac.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_01_2_palmerin.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_01_3_troy.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_01_4_frenes.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_01_5_toussaint.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_01_6_flat_color.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_02_1_dornal.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_02_2_attre.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_02_3_attre_creiqiau.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_02_4_fourhorn.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_02_5_milton.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_02_6_toussaint.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_02_7_flat_color.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_03_1_anseis.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_03_2_maecht.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_03_3_mettina.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_03_4_rivia.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_03_5_toussaint.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_03_6_flat_color.w2ent
		// dlc\bob\data\items\weapons\shields\toussaint_shield_03_7_dun_tynne.w2ent
		
		, true );

		if (GetWitcherPlayer().HasTag('axii_sword_equipped'))
		{
			if(!GetWitcherPlayer().HasTag('ACS_Shielded'))
			{
				GetWitcherPlayer().AddTag('ACS_Shielded');
			}

			//GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( ' ', 'PLAYER_SLOT', settings_interrupt );

			GetWitcherPlayer().AddBuffImmunity	( EET_Stagger,					'acs_shield', false);
			GetWitcherPlayer().AddBuffImmunity	( EET_LongStagger,				'acs_shield', false);
			GetWitcherPlayer().AddBuffImmunity	( EET_Knockdown,				'acs_shield', false);
			GetWitcherPlayer().AddBuffImmunity	( EET_HeavyKnockdown,			'acs_shield', false);
			GetWitcherPlayer().AddBuffImmunity	( EET_KnockdownTypeApplicator,	'acs_shield', false);

			GetWitcherPlayer().BlockAction( EIAB_Dodge,				'acs_shield');
			GetWitcherPlayer().BlockAction( EIAB_Roll,				'acs_shield');

			shield = (CEntity)theGame.CreateEntity( shield_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ) );

			//shield.CreateAttachment( GetWitcherPlayer(), 'l_weapon', Vector(0.1, 0, 0.1), EulerAngles(10, -20, 0) );

			shield.CreateAttachment( GetWitcherPlayer(), 'l_weapon', Vector(0, 0.125, -0.5), EulerAngles(0, 0, 0) );

			//shield.StopEffect('fire_sparks_trail');

			//shield.StopEffect('runeword1_fire_trail');

			//shield.PlayEffectSingle('fire_sparks_trail');

			//shield.PlayEffectSingle('runeword1_fire_trail');

			//shield.PlayEffectSingle('appear');

			//shield.PlayEffectSingle('burn');

			shield.AddTag('ACS_Shield');

			//Sleep(0.25);

			//shield.StopEffect('appear');

			shield.PlayEffectSingle('destroy');

			shield.StopEffect('destroy');

			shield.PlayEffectSingle('destroy_shield_fx');

			shield.StopEffect('destroy_shield_fx');

			shield.PlayEffectSingle('igni_cone_hit');

			shield.StopEffect('igni_cone_hit');

			//shield.PlayEffectSingle('appear');

			//shield.StopEffect('appear');

			//SleepOneFrame();

			//shield.PlayEffectSingle('aard_cone_hit');

			//shield.StopEffect('aard_cone_hit');

			//shield.PlayEffectSingle('fire_sparks_trail');

			//shield.PlayEffectSingle('runeword1_fire_trail');

			GetWitcherPlayer().AddTag('ACS_Shield_Summoned');
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Axii_Shield_Entity in cACS_Shield_Summon
{
	private var shield_entity_temp																: CEntityTemplate;
	private var shield_entity																	: CEntity;
	private var meshcomp																		: CComponent;
	private var animcomp 																		: CAnimatedComponent;
	private var h 																				: float;
	private var shieldAnimatedComponent 														: CAnimatedComponent;
	private var shieldMovementAdjustor															: CMovementAdjustor; 
	private var shieldTicket 																	: SMovementAdjustmentRequestTicket; 
	private var actors 																			: array< CActor >;
	private var actor       																	: CActor;
	private var i 																				: int;
	private var curVitality, damage																: float;
	
	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		Shield_Entity_Summon();
	}
	
	entry function Shield_Entity_Summon()
	{
		shield_entity_destroy_pre();

		if (ACS_IsNight_Adjustable() || GetWitcherPlayer().IsInDarkPlace())
		{
			Summon_Shield_Entity();
		}
	}
	
	latent function Summon_Shield_Entity()
	{	
		curVitality = GetWitcherPlayer().GetStat( BCS_Vitality );
		
		damage = curVitality * 0.3;

		GetWitcherPlayer().ForceSetStat( BCS_Vitality,  curVitality - damage );

		shield_entity_temp = (CEntityTemplate)LoadResource( 

		"dlc/dlc_acs/data/entities/monsters/hym.w2ent"

		, true );

		shield_entity = (CEntity)theGame.CreateEntity( shield_entity_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -20 ), GetWitcherPlayer().GetWorldRotation() );
		animcomp = (CAnimatedComponent)shield_entity.GetComponentByClassName('CAnimatedComponent');
		meshcomp = shield_entity.GetComponentByClassName('CMeshComponent');
		h = 2.5;
		animcomp.SetScale(Vector(h,h,h,1));
		meshcomp.SetScale(Vector(h,h,h,1));	

		shield_entity.PlayEffectSingle('hym_summon');

		((CNewNPC)shield_entity).SetTemporaryAttitudeGroup( 'friendly_to_player', AGP_Default );	
		((CNewNPC)shield_entity).EnableCollisions(false);
		((CNewNPC)shield_entity).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
		((CActor)shield_entity).SetAnimationTimeMultiplier(1.5);
		((CActor)shield_entity).SetTemporaryAttitudeGroup( 'neutral_to_all', AGP_Default );
		((CActor)shield_entity).EnableCollisions(false);
		((CActor)shield_entity).SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

		shield_entity.CreateAttachment( GetWitcherPlayer(), , Vector( 0, 0, -4 ), GetWitcherPlayer().GetWorldRotation() );

		shield_entity.AddTag('ACS_Shield_Entity');

		GetWitcherPlayer().AddTag('ACS_Shielded_Entity');

		shield_entity_spawn_anim();

		GetWitcherPlayer().AddBuffImmunity	( EET_Stagger,					'acs_shield_entity', false);
		GetWitcherPlayer().AddBuffImmunity	( EET_LongStagger,				'acs_shield_entity', false);
		GetWitcherPlayer().AddBuffImmunity	( EET_Knockdown,				'acs_shield_entity', false);
		GetWitcherPlayer().AddBuffImmunity	( EET_HeavyKnockdown,			'acs_shield_entity', false);
		GetWitcherPlayer().AddBuffImmunity	( EET_KnockdownTypeApplicator,	'acs_shield_entity', false);

	}

	latent function shield_entity_spawn_anim()
	{
		shieldAnimatedComponent = (CAnimatedComponent)ACS_Shield_Entity().GetComponentByClassName( 'CAnimatedComponent' );	

		shieldMovementAdjustor = ((CMovingPhysicalAgentComponent)ACS_Shield_Entity().GetMovingAgentComponent()).GetMovementAdjustor();

		shieldMovementAdjustor.CancelAll();
			
		shieldTicket = shieldMovementAdjustor.CreateNewRequest( 'ACS_Shield_Movement_Adjust' );

		//shieldMovementAdjustor.AdjustmentDuration( shieldTicket, 0.1 );
		//shieldMovementAdjustor.ShouldStartAt(shieldTicket, ACS_Shield_Entity().GetWorldPosition());
		shieldMovementAdjustor.MaxRotationAdjustmentSpeed( shieldTicket, 50000 );
		shieldMovementAdjustor.MaxLocationAdjustmentSpeed( shieldTicket, 50000 );
		//shieldMovementAdjustor.AdjustLocationVertically( shieldTicket, true );
		//shieldMovementAdjustor.ScaleAnimationLocationVertically( shieldTicket, true );
		shieldMovementAdjustor.RotateTo( shieldTicket, VecHeading(GetWitcherPlayer().GetHeadingVector()) );

		shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_taunt_leaves', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 0.5f));
	}

	latent function shield_entity_destroy_pre()
	{	
		actors.Clear();

		theGame.GetActorsByTag( 'ACS_Shield_Entity', actors );

		if (actors.Size() <= 0)
		{
			return;
		}

		actor = (CActor)actors[i];
			
		for( i=0; i<actors.Size(); i+=1 )
		{		
			actor.BreakAttachment();
			actor.Destroy();
		}
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

function ACS_Shield() : CEntity
{
	var shield 				 : CEntity;
	
	shield = (CEntity)theGame.GetEntityByTag( 'ACS_Shield' );
	return shield;
}

function ACS_Axii_Shield_Entity_Destroy()
{
	GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'acs_shield_entity');
	GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'acs_shield_entity');
	GetWitcherPlayer().RemoveBuffImmunity( EET_Knockdown,				'acs_shield_entity');
	GetWitcherPlayer().RemoveBuffImmunity( EET_HeavyKnockdown,			'acs_shield_entity');
	GetWitcherPlayer().RemoveBuffImmunity( EET_KnockdownTypeApplicator,	'acs_shield_entity');

	shield_entity_despawn_anim();
	ACS_Shield_Entity().DestroyAfter(2);

	GetWitcherPlayer().RemoveTag('ACS_Shielded_Entity');
}

function ACS_Axii_Shield_Destroy()
{
	shield_entity_despawn_anim();
	ACS_Shield_Entity().DestroyAfter(2);

	GetWitcherPlayer().RemoveTag('ACS_Shielded');
	GetWitcherPlayer().RemoveTag('ACS_Shielded_Entity');
}

function ACS_Axii_Shield_Destroy_DELAY()
{
	GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'acs_shield');
	GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'acs_shield');
	GetWitcherPlayer().RemoveBuffImmunity( EET_Knockdown,				'acs_shield');
	GetWitcherPlayer().RemoveBuffImmunity( EET_HeavyKnockdown,			'acs_shield');
	GetWitcherPlayer().RemoveBuffImmunity( EET_KnockdownTypeApplicator,	'acs_shield');
				
	GetWitcherPlayer().UnblockAction( EIAB_Dodge,			'acs_shield');
	GetWitcherPlayer().UnblockAction( EIAB_Roll,				'acs_shield');

	ACS_Shield().StopEffect('appear');

	if (
	!GetWitcherPlayer().HasTag('axii_sword_equipped') 
	||GetWitcherPlayer().IsCurrentlyDodging()
	||GetWitcherPlayer().IsPerformingFinisher()
	|| !GetWitcherPlayer().IsInCombat())
	{
		ACS_Shield().PlayEffectSingle('disappear_fast');
		//ACS_Shield().StopEffect('disappear');
		ACS_Shield().DestroyAfter(0.25);
	}
	else
	{
		ACS_Shield().PlayEffectSingle('disappear');
		//ACS_Shield().StopEffect('disappear');
		ACS_Shield().DestroyAfter(0.75);
	}

	GetWitcherPlayer().RemoveTag('ACS_Shielded');

	GetWitcherPlayer().RemoveTag('ACS_Shield_Summoned');

	if (!GetWitcherPlayer().HasTag('ACS_Shield_Destroyed'))
	{
		//GetWitcherPlayer().AddTag('ACS_Shield_Destroyed');
	}
}

function ACS_Axii_Shield_Destroy_IMMEDIATE()
{
	GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'acs_shield');
	GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'acs_shield');
	GetWitcherPlayer().RemoveBuffImmunity( EET_Knockdown,				'acs_shield');
	GetWitcherPlayer().RemoveBuffImmunity( EET_HeavyKnockdown,			'acs_shield');
	GetWitcherPlayer().RemoveBuffImmunity( EET_KnockdownTypeApplicator,	'acs_shield');

	GetWitcherPlayer().UnblockAction( EIAB_Dodge,			'acs_shield');
	GetWitcherPlayer().UnblockAction( EIAB_Roll,				'acs_shield');

	ACS_Shield().StopEffect('appear');

	ACS_Shield().PlayEffectSingle('disappear_fast');
	//ACS_Shield().StopEffect('disappear');
	
	ACS_Shield().Destroy();

	GetWitcherPlayer().RemoveTag('ACS_Shielded');

	GetWitcherPlayer().RemoveTag('ACS_Shield_Summoned');

	if (!GetWitcherPlayer().HasTag('ACS_Shield_Destroyed'))
	{
		GetWitcherPlayer().AddTag('ACS_Shield_Destroyed');
	}
}

function shield_entity_despawn_anim()
{
	var shieldAnimatedComponent 					: CAnimatedComponent;
	var shieldMovementAdjustor						: CMovementAdjustor; 
	var shieldTicket 								: SMovementAdjustmentRequestTicket; 

	shieldAnimatedComponent = (CAnimatedComponent)ACS_Shield_Entity().GetComponentByClassName( 'CAnimatedComponent' );	

	shieldMovementAdjustor = ((CMovingPhysicalAgentComponent)ACS_Shield_Entity().GetMovingAgentComponent()).GetMovementAdjustor();

	shieldMovementAdjustor.CancelAll();
			
	shieldTicket = shieldMovementAdjustor.CreateNewRequest( 'ACS_Shield_Movement_Adjust' );

	//shieldMovementAdjustor.ShouldStartAt(shieldTicket, ACS_Shield_Entity().GetWorldPosition());
	shieldMovementAdjustor.MaxRotationAdjustmentSpeed( shieldTicket, 50000 );
	shieldMovementAdjustor.MaxLocationAdjustmentSpeed( shieldTicket, 50000 );
	//shieldMovementAdjustor.AdjustLocationVertically( shieldTicket, true );
	//shieldMovementAdjustor.ScaleAnimationLocationVertically( shieldTicket, true );
	shieldMovementAdjustor.RotateTo( shieldTicket, VecHeading(GetWitcherPlayer().GetHeadingVector()) );

	shieldAnimatedComponent.PlaySlotAnimationAsync ( 'monster_lessun_taunt_scream', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 0.5f));

	ACS_Shield_Entity().PlayEffectSingle('hym_despawn');
	ACS_Shield_Entity().StopEffect('hym_despawn');
}

function ACS_Shield_Entity() : CActor
{
	var shield_entity 			 : CActor;
	
	shield_entity = (CActor)theGame.GetEntityByTag( 'ACS_Shield_Entity' );
	return shield_entity;
}

function ACS_Revenant() : CNewNPC
{
	var revenant 			 : CNewNPC;
	
	revenant = (CNewNPC)theGame.GetEntityByTag( 'ACS_Revenant' );
	return revenant;
}

function Quen_Monsters_Despawn()
{
	ACS_Centipede_Destroy();
	ACS_Wolf_Destroy();

	if (thePlayer.HasTag('ACS_Quen_Monster_Summoned'))
	{
		thePlayer.RemoveTag('ACS_Quen_Monster_Summoned');
	}
}

function AardPull_Deactivate()
{
	GetACSWatcher().RemoveTimer('ACS_bruxa_camo_npc_reaction');

	GetWitcherPlayer().RemoveTag('ACS_AardPull_Active');
}

function Bruxa_Camo_Decoy_Deactivate()
{
	var vBruxa_Camo_Decoy_DeactivateClawEquip																											: cBruxa_Camo_Decoy_DeactivateClawEquip;
	
	vBruxa_Camo_Decoy_DeactivateClawEquip = new cBruxa_Camo_Decoy_DeactivateClawEquip in theGame;

	if (GetWitcherPlayer().HasTag('ACS_Camo_Active'))
	{
		GetWitcherPlayer().StopEffect('shadowdash');

		if (GetACSHelm1())
		{
			GetACSHelm1().StopEffect('shadowdash');
		}

		if (GetACSHelm2())
		{
			GetACSHelm2().StopEffect('shadowdash');
		}

		if (GetACSHelm3())
		{
			GetACSHelm3().StopEffect('shadowdash');
		}

		if (GetACSHelm4())
		{
			GetACSHelm4().StopEffect('shadowdash');
		}

		GetWitcherPlayer().SoundEvent("monster_bruxa_combat_appear");

		GetWitcherPlayer().SoundEvent( "expl_focus_stop" ); 

		NPC_Fear_Revert();

		DisableCatViewFx( 0 );
		
		GetACSWatcher().Deactivate_Bruxa_Camo_Env();

		GetACSWatcher().RemoveTimer('ACS_npc_fear_reaction');

		GetACSWatcher().RemoveTimer('ACS_Bruxa_Camo_Sonar_Timer');

		GetWitcherPlayer().RemoveTag('ACS_Camo_Active');

		//vBruxa_Camo_Decoy_DeactivateClawEquip.Bruxa_Camo_Decoy_Deactivate_Claw_Equip_Standalone_Engage();

		GetACSWatcher().ACS_Vampire_Back_Claw_Reattach();

		ACS_Bruxa_Camo_Sonar().Destroy();

		ACS_Bruxa_Camo_Sonar_2().Destroy();

		ACS_Bruxa_Camo_Trail().Destroy();

		ACS_Bruxa_Camo_Sonar_NPC_Destroy();

		ACS_Bruxa_Camo_Highlighted_Enemies_Remove_Highlight();
	}
}

statemachine class cBruxa_Camo_Decoy_DeactivateClawEquip
{
    function Bruxa_Camo_Decoy_Deactivate_Claw_Equip_Standalone_Engage()
	{
		this.PushState('Bruxa_Camo_Decoy_Deactivate_Claw_Equip_Standalone_Engage');
	}
}

state Bruxa_Camo_Decoy_Deactivate_Claw_Equip_Standalone_Engage in cBruxa_Camo_Decoy_DeactivateClawEquip
{
	private var claw_temp, head_temp, extra_arms_anchor_temp, extra_arms_temp_r, extra_arms_temp_l, back_claw_temp																			: CEntityTemplate;
	private var p_actor 																																									: CActor;
	private var p_comp, meshcompHead																																						: CComponent;
	private var settings																																									: SAnimatedComponentSlotAnimationSettings;
	private var animatedComponent_extra_arms 																																				: CAnimatedComponent;
	private var stupidArray_extra_arms 																																						: array< name >;
	private var attach_vec, bone_vec																																						: Vector;
	private var attach_rot, bone_rot																																						: EulerAngles;
	private var extra_arms_anchor_r, extra_arms_anchor_l, extra_arms_1, extra_arms_2, extra_arms_3, extra_arms_4, vampire_head_anchor, vampire_head, back_claw, vampire_claw_anchor			: CEntity;
	private var h 																																											: float;

	event OnEnterState(prevStateName : name)
	{
		super.OnEnterState(prevStateName);
		ClawEquipStandalone_Entry();
	}
	
	entry function ClawEquipStandalone_Entry()
	{
		ClawEquipStandalone_Latent();
	}
	
	latent function ClawEquipStandalone_Latent()
	{
		/*
		ACS_Vampire_Arms_1_Get().Destroy();

		ACS_Vampire_Arms_2_Get().Destroy();

		ACS_Vampire_Arms_3_Get().Destroy();

		ACS_Vampire_Arms_4_Get().Destroy();

		ACS_Vampire_Arms_Anchor_L_Get().Destroy();

		ACS_Vampire_Arms_Anchor_R_Get().Destroy();

		ACS_Vampire_Head_Anchor_Get().Destroy();

		ACS_Vampire_Head_Get().Destroy();

		ACS_Vampire_Back_Claw_Get().Destroy();

		ACS_Vampire_Claw_Anchor_Get().Destroy();
		*/

		ACS_Blood_Armor_Destroy_IMMEDIATE();

		stupidArray_extra_arms.PushBack( 'Cutscene' );

		extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

		if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
		{
			GetWitcherPlayer().PlayEffectSingle('dive_shape');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_temp_r = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_right.w2ent", true);	

			extra_arms_temp_l = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_extra_arm_left.w2ent", true);	

			extra_arms_anchor_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\fx_ent.w2ent", true );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'r_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_r = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_r.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'r_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_r.AddTag('extra_arms_anchor_r');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'l_shoulder' ), bone_vec, bone_rot );

			extra_arms_anchor_l = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			extra_arms_anchor_l.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'l_shoulder', bone_vec, bone_rot );

			extra_arms_anchor_l.AddTag('extra_arms_anchor_l');

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_1 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_1.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 110;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 200;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = 0.75;
			
			extra_arms_1.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_1.StopEffect('blood');

			extra_arms_1.PlayEffectSingle('blood');

			extra_arms_1.AddTag('vampire_extra_arms_1');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_2 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_2.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 70;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -160;
			attach_vec.X = 1.25;
			attach_vec.Y = 0.475;
			attach_vec.Z = -0.75;
			
			extra_arms_2.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_2.StopEffect('blood');

			extra_arms_2.PlayEffectSingle('blood');

			extra_arms_2.AddTag('vampire_extra_arms_2');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_3 = (CEntity)theGame.CreateEntity( extra_arms_temp_r, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_3.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 160;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = 1.5;
			
			extra_arms_3.CreateAttachment( extra_arms_anchor_r, , attach_vec, attach_rot );

			extra_arms_3.StopEffect('blood');

			extra_arms_3.PlayEffectSingle('blood');

			extra_arms_3.AddTag('vampire_extra_arms_3');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			extra_arms_4 = (CEntity)theGame.CreateEntity( extra_arms_temp_l, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = extra_arms_4.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 20;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = -180;
			attach_vec.X = 0.5;
			attach_vec.Y = 0;
			attach_vec.Z = -1.5;
			
			extra_arms_4.CreateAttachment( extra_arms_anchor_l, , attach_vec, attach_rot );

			extra_arms_4.StopEffect('blood');

			extra_arms_4.PlayEffectSingle('blood');

			extra_arms_4.AddTag('vampire_extra_arms_4');	

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_1.GetComponentByClassName( 'CAnimatedComponent' );	

			animatedComponent_extra_arms = (CAnimatedComponent)extra_arms_2.GetComponentByClassName( 'CAnimatedComponent' );	

			ACS_Vampire_Arms_1_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( '__cutsceneAnimation', true );

			ACS_Vampire_Arms_2_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( '__cutsceneAnimation', true );

			ACS_Vampire_Arms_3_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( '__cutsceneAnimation', true );

			ACS_Vampire_Arms_4_Get().GetRootAnimatedComponent().PlaySkeletalAnimationAsync( '__cutsceneAnimation', true );

			/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'head' ), bone_vec, bone_rot );

			vampire_head_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

			vampire_head_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'head', bone_vec, bone_rot );

			vampire_head_anchor.AddTag('vampire_head_anchor');

			head_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\dettlaff_monster_head.w2ent", true);	

			vampire_head = (CEntity)theGame.CreateEntity( head_temp, GetWitcherPlayer().GetWorldPosition() );

			meshcompHead = vampire_head.GetComponentByClassName('CMeshComponent');

			h = 2;

			meshcompHead.SetScale(Vector(h,h,h,1));	
			
			attach_rot.Roll = 0;
			attach_rot.Pitch = 0;
			attach_rot.Yaw = 10;
			attach_vec.X = -0.275;
			attach_vec.Y = -0.0875;
			attach_vec.Z = 0;
			
			vampire_head.CreateAttachment( vampire_head_anchor, , attach_vec, attach_rot );

			vampire_head.AddTag('vampire_head');
		}

		//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		GetWitcherPlayer().GetBoneWorldPositionAndRotationByIndex( GetWitcherPlayer().GetBoneIndex( 'torso3' ), bone_vec, bone_rot );

		vampire_claw_anchor = (CEntity)theGame.CreateEntity( extra_arms_anchor_temp, GetWitcherPlayer().GetWorldPosition() + Vector( 0, 0, -10 ) );

		vampire_claw_anchor.CreateAttachmentAtBoneWS( GetWitcherPlayer(), 'torso3', bone_vec, bone_rot );

		vampire_claw_anchor.AddTag('acs_vampire_claw_anchor');

		back_claw_temp = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\entities\other\vampire_back_claws.w2ent", true);	

		back_claw = (CEntity)theGame.CreateEntity( back_claw_temp, GetWitcherPlayer().GetWorldPosition() );

		meshcompHead = back_claw.GetComponentByClassName('CMeshComponent');

		h = 2;

		meshcompHead.SetScale(Vector(h,h,h,1));	
		
		attach_rot.Roll = 90;
		attach_rot.Pitch = 0;
		attach_rot.Yaw = 45;
		attach_vec.X = -1;
		attach_vec.Y = -1;
		attach_vec.Z = 0;
		
		back_claw.CreateAttachment( vampire_claw_anchor, , attach_vec, attach_rot );

		back_claw.StopEffect('blood_color');

		back_claw.PlayEffectSingle('blood_color');

		back_claw.AddTag('acs_vampire_back_claw');
	}
}

function NPC_Fear_Revert()
{
	var i 						: int;
	var npc     				: CNewNPC;
	var actors					: array< CActor >;
	var npcGroupType 			: ENPCGroupType;
	var animatedComponentA 		: CAnimatedComponent;

	//ACS_Focus_Sound_Red_Destroy();

	actors.Clear();

	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 100, 100, , FLAG_ExcludePlayer + FLAG_Attitude_Hostile + FLAG_OnlyAliveActors);
		
	for( i = 0; i < actors.Size(); i += 1 )
	{
		npc = (CNewNPC)actors[i];
			
		animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );	
			
		if ( npc == GetWitcherPlayer() || npc.HasTag('smokeman') )
			continue;
			
		if( actors.Size() > 0 
		&& npc.IsAlive()
		&& !theGame.IsDialogOrCutscenePlaying()
		&& !GetWitcherPlayer().IsUsingHorse() && !GetWitcherPlayer().IsUsingVehicle()
		&& npc.IsHuman()
		)
		{				
			animatedComponentA.PlaySlotAnimationAsync ( '', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
		}
	}
}

function ACS_Revenant_Destroy()
{
	var revenant 											: array<CActor>;
	var i													: int;
	var revenantAnimatedComponent 							: CAnimatedComponent;
	var revenantMovementAdjustor							: CMovementAdjustor; 
	var revenantTicket 										: SMovementAdjustmentRequestTicket; 
	
	revenant.Clear();

	theGame.GetActorsByTag( 'ACS_Revenant', revenant );	

	if (revenant.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < revenant.Size(); i += 1 )
	{
		revenantMovementAdjustor = ((CMovingPhysicalAgentComponent)revenant[i].GetMovingAgentComponent()).GetMovementAdjustor();

		revenantMovementAdjustor.CancelAll();

		revenantTicket = revenantMovementAdjustor.CreateNewRequest( 'ACS_Revenant_Movement_Adjust' );

		revenantMovementAdjustor.AdjustmentDuration( revenantTicket, 0.25 );
		//shieldMovementAdjustor.ShouldStartAt(shieldTicket, ACS_Shield_Entity().GetWorldPosition());
		revenantMovementAdjustor.MaxRotationAdjustmentSpeed( revenantTicket, 50000 );
		revenantMovementAdjustor.MaxLocationAdjustmentSpeed( revenantTicket, 50000 );
		//shieldMovementAdjustor.AdjustLocationVertically( shieldTicket, true );
		//shieldMovementAdjustor.ScaleAnimationLocationVertically( shieldTicket, true );

		revenantMovementAdjustor.RotateTowards( revenantTicket, GetWitcherPlayer() );

		revenantAnimatedComponent = (CAnimatedComponent)revenant[i].GetComponentByClassName( 'CAnimatedComponent' );	
		
		revenantAnimatedComponent.PlaySlotAnimationAsync ( 'sq701_knight_sword_drawn_gesture_hailing', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 0.5f));
		
		revenant[i].PlayEffectSingle('demonic_possession');
		revenant[i].DestroyAfter(2.5);

		//revenant[i].Kill( 'Finisher', false, GetWitcherPlayer() );
	}
	
	GetWitcherPlayer().RemoveTag('ACS_Has_Summoned_Centipede');
}

function ACS_Skele_Destroy()
{
	var skeleton 											: array<CActor>;
	var i													: int;
	var skeletonAnimatedComponent 							: CAnimatedComponent;
	var skeleMovementAdjustor								: CMovementAdjustor; 
	var skeleTicket 										: SMovementAdjustmentRequestTicket; 
	
	skeleton.Clear();

	theGame.GetActorsByTag( 'ACS_Summoned_Skeleton', skeleton );	

	if (skeleton.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < skeleton.Size(); i += 1 )
	{
		skeleMovementAdjustor = ((CMovingPhysicalAgentComponent)skeleton[i].GetMovingAgentComponent()).GetMovementAdjustor();

		skeleMovementAdjustor.CancelAll();

		skeleTicket = skeleMovementAdjustor.CreateNewRequest( 'ACS_Skele_Movement_Adjust' );

		skeleMovementAdjustor.AdjustmentDuration( skeleTicket, 0.25 );
		//shieldMovementAdjustor.ShouldStartAt(shieldTicket, ACS_Shield_Entity().GetWorldPosition());
		skeleMovementAdjustor.MaxRotationAdjustmentSpeed( skeleTicket, 50000 );
		skeleMovementAdjustor.MaxLocationAdjustmentSpeed( skeleTicket, 50000 );
		//shieldMovementAdjustor.AdjustLocationVertically( shieldTicket, true );
		//shieldMovementAdjustor.ScaleAnimationLocationVertically( shieldTicket, true );

		skeleMovementAdjustor.RotateTowards( skeleTicket, GetWitcherPlayer() );

		skeletonAnimatedComponent = (CAnimatedComponent)skeleton[i].GetComponentByClassName( 'CAnimatedComponent' );	
		
		skeletonAnimatedComponent.PlaySlotAnimationAsync ( 'sq701_knight_sword_drawn_gesture_hailing', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 0.5f));
		
		skeleton[i].PlayEffectSingle('death_glow');
		skeleton[i].PlayEffectSingle('suck_into_painting');
		skeleton[i].DestroyAfter(2.5);
	}
	
	GetWitcherPlayer().RemoveTag('ACS_Has_Summoned_Centipede');
}

function ACS_Centipede_Destroy()
{
	var centipedes 											: array<CActor>;
	var i													: int;
	var centipedeAnimatedComponent 							: CAnimatedComponent;
	
	centipedes.Clear();

	theGame.GetActorsByTag( 'ACS_Summoned_Centipede', centipedes );	

	if (centipedes.Size() <= 0)
	{
		return;
	}

	GetWitcherPlayer().GainStat( BCS_Vitality, (GetWitcherPlayer().GetStat(BCS_Vitality) * 0.0125) );

	for( i = 0; i < centipedes.Size(); i += 1 )
	{
		centipedeAnimatedComponent = (CAnimatedComponent)centipedes[i].GetComponentByClassName( 'CAnimatedComponent' );	
		
		centipedeAnimatedComponent.PlaySlotAnimationAsync ( 'attack_jump_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 0.5f));
		
		centipedes[i].PlayEffectSingle('dirt_jump');
		centipedes[i].DestroyAfter(2);
	}
	
	GetWitcherPlayer().RemoveTag('ACS_Has_Summoned_Centipede');
}

function ACS_Summoned_Centipedes() : array<CActor>
{
	var centipedes 											: array<CActor>;
	
	theGame.GetActorsByTag( 'ACS_Summoned_Centipede', centipedes );	
	
	return centipedes;
}

////////////////////////////////////////////////////////////////////////////////////////

function ACS_Wolf_Destroy()
{	
	var wolves 											: array<CActor>;
	var i												: int;
	var wolfAnimatedComponent 							: CAnimatedComponent;
	
	wolves.Clear();

	theGame.GetActorsByTag( 'ACS_Summoned_Wolf', wolves );	

	if (wolves.Size() <= 0)
	{
		return;
	}

	GetWitcherPlayer().GainStat( BCS_Vitality, (GetWitcherPlayer().GetStat(BCS_Vitality) * 0.025) );
	
	for( i = 0; i < wolves.Size(); i += 1 )
	{
		wolfAnimatedComponent = (CAnimatedComponent)wolves[i].GetComponentByClassName( 'CAnimatedComponent' );	
		
		wolfAnimatedComponent.PlaySlotAnimationAsync ( 'wolf_howling_loop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.2f, 0.5f));
		
		wolves[i].PlayEffectSingle('disappear');
		wolves[i].DestroyAfter(2);
	}
	
	GetWitcherPlayer().RemoveTag('ACS_Has_Summoned_Wolf');
}

function ACS_Summoned_Wolves() : array<CActor>
{
	var wolves 											: array<CActor>;
	
	theGame.GetActorsByTag( 'ACS_Summoned_Wolf', wolves );	
	
	return wolves;
}