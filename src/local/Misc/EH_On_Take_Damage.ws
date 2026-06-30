function ACS_OnTakeDamage(action: W3DamageAction)
{
	if (ACS_Death_Check(action)) 
	{
		return;
	}

	if ( action.IsDoTDamage() 
	)
	{
		return;
	}

	ACS_Player_Fall_Negate(action);

	ACS_Player_Attack_Steel_Silver_Switch(action);

	ACS_Player_Attack_FX_Switch(action);

	ACS_Player_Attack(action);

    ACS_Player_Guard(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	ACS_AddItemOnAttack(action);

	ACS_Enemy_On_Take_Damage_01(action);

	ACS_Enemy_On_Take_Damage_02(action);

	ACS_Enemy_On_Take_Damage_03(action);

	ACS_Enemy_On_Take_Damage_04(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Add_Weapon_On_Take_Damage(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ACS_Enemy_On_Take_Damage_General(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Enemy_Attack_01(action);

	ACS_Enemy_Attack_02(action);

	ACS_Enemy_Attack_03(action);

	ACS_Enemy_Attack_04(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Vanilla_Vampires_Attack(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_SummonedCreatures_Attack(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Rage_Attack(action);

	ACS_NPC_Normal_Attack(action);

	ACS_Take_Damage(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

function ACS_Death_Check(action: W3DamageAction) : bool
{
	var money 							: float;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;
	var finisher_anim_names				: array< name >;
	var targetDistance 					: float;
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var i								: int;
	var npc								: CNewNPC;

	if ((!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) 
	|| GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) )
	&& (W3PlayerWitcher)action.victim 
	)
	{
		if (thePlayer.HasTag('ACS_Second_Life_Active'))
		{
			thePlayer.ActionPlaySlotAnimationAsync('PLAYER_SLOT','', 0.1, 1, false);

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

			thePlayer.BlockAllActions( 'Mutation11', false );	
			theGame.GetGameCamera().StopAnimation( 'camera_shake_loop_lvl1_1' );
			theGame.StopVibrateController();
			thePlayer.SetInteractionPriority( thePlayer.GetInteractionPriority() );
			thePlayer.RemoveBuff( EET_Mutation11Buff, true );
			
			thePlayer.RemoveTag('ACS_Second_Life_Active');
		}
	}
	
	if ((W3PlayerWitcher)action.victim )
	{
		if (ACS_Settings_Main_Float('acs_damage_settings','acs_player_damage_taken_multiplier', 1) != 1 && action.processedDmg.vitalityDamage != 0)
		{
			action.processedDmg.vitalityDamage *= ACS_Settings_Main_Float('acs_damage_settings','acs_player_damage_taken_multiplier', 1);
		}
	}

	if (
	(
	(GetWitcherPlayer().IsActionBlockedBy(EIAB_Movement, 'Mutation11') && GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) && !GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) )
	|| GetWitcherPlayer().HasBuff( EET_Mutation11Immortal )
	|| (GetWitcherPlayer().CanUseSkill(S_Sword_s18) && !GetWitcherPlayer().GetCannotUseUndying() && FloorF(GetWitcherPlayer().GetStat(BCS_Focus)) >= 1 && GetWitcherPlayer().HasBuff(EET_BattleTrance))
	)
	&& (W3PlayerWitcher)action.victim 
	&& !GetWitcherPlayer().IsInAir()
	&& action.DealsAnyDamage()
	&& !action.WasDodged() 
	&& !((W3Action_Attack)action).IsParried()
	&& !GetWitcherPlayer().IsGuarded()
	&& !GetWitcherPlayer().IsInGuardedState()
	&& !((W3Action_Attack)action).IsCountered()
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Immortal
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Invulnerable
	&& !thePlayer.IsUsingHorse()
	&& !thePlayer.IsUsingVehicle()
	&& action.GetBuffSourceName() != "FallingDamage"
	&& action.GetBuffSourceName() != "ACS_Debug"
	&& action.GetBuffSourceName() != "Debug"
	&& action.GetBuffSourceName() != "Quest"
	&& action.GetBuffSourceName() != "ACS_Death"
	&& action.GetBuffSourceName() != "Kill Trigger"
	&& action.GetBuffSourceName() != "Trap"
	&& action.processedDmg.vitalityDamage >= GetWitcherPlayer().GetCurrentHealth()
	//&& (GetWitcherPlayer().GetCurrentHealth() - action.processedDmg.vitalityDamage) <= 0
	)
	{
		ACS_ThingsThatShouldBeRemoved();

		GetACSWatcher().ACS_TransformationDisable();

		if ((GetWitcherPlayer().CanUseSkill(S_Sword_s18) 
		&& !GetWitcherPlayer().GetCannotUseUndying() 
		&& FloorF(GetWitcherPlayer().GetStat(BCS_Focus)) >= 1 
		&& GetWitcherPlayer().HasBuff(EET_BattleTrance)))
		{
			GetWitcherPlayer().SetCannotUseUndyingSkill(true);
		}

		if (
		GetWitcherPlayer().IsActionBlockedBy(EIAB_Movement, 'Mutation11') 
		&& GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) 
		&& !GetWitcherPlayer().HasBuff( EET_Mutation11Debuff )
		)
		{
			GetWitcherPlayer().AddTag('ACS_Second_Life_Active');
		}

		return true;
	}

	if (
	(W3PlayerWitcher)action.victim 
	&& action.GetBuffSourceName() != "FallingDamage"
	&& action.GetBuffSourceName() != "ACS_Debug"
	&& action.GetBuffSourceName() != "Debug"
	&& action.GetBuffSourceName() != "Quest"
	&& action.GetBuffSourceName() != "ACS_Death"
	&& action.GetBuffSourceName() != "Kill Trigger"
	&& action.GetBuffSourceName() != "Trap"
	&& action.processedDmg.vitalityDamage >= GetWitcherPlayer().GetCurrentHealth()
	//&& (GetWitcherPlayer().GetCurrentHealth() - action.processedDmg.vitalityDamage) <= 0
	&& action.DealsAnyDamage()
	&& !action.WasDodged() 
	&& !((W3Action_Attack)action).IsParried()
	&& !GetWitcherPlayer().IsGuarded()
	&& !GetWitcherPlayer().IsInGuardedState()
	&& !((W3Action_Attack)action).IsCountered()
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Immortal
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Invulnerable
	&& !thePlayer.IsUsingHorse()
	&& !thePlayer.IsUsingVehicle()
	&& theGame.GetWorld().GetDepotPath() != "levels\wmh_lv1\wmh_lv1.w2w"
	&& !thePlayer.IsSwimming()
	&& !thePlayer.IsDiving()
	&& !ACS_New_Replacers_Female_Active()
	&& !((CActor)action.attacker).HasTag('dandelion')
	&& !thePlayer.IsInFistFightMiniGame()
	&& !StrContains( ((CActor)action.attacker).GetReadableName(), "quests\main_npcs\dandelion.w2ent" )
	) 
	{
		if (((CNewNPC)action.attacker).GetNPCType() == ENGT_Guard
		&& !(GetACSWatcher().death_scene_start)
		)
		{
			if (FactsQuerySum("ACS_Enter_Unconscious_Start") <= 0)
			{
				GetACSWatcher().ACS_TransformationDisable();

				ACS_Tutorial_Display_Check('ACS_Guards_Tutorial_Shown');

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				if (GetWitcherPlayer().GetStat( BCS_Focus ) != 0)
				{
					GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
				}
				
				money = GetWitcherPlayer().GetMoney();

				switch ( theGame.GetDifficultyLevel() )
				{
					case EDM_Easy:		money *= 0.025;  break;
					case EDM_Medium:	money *= 0.050;  break;
					case EDM_Hard:		money *= 0.075;  break;
					case EDM_Hardcore:	money *= 0.1;    break;
					default : 			money *= 0; 	 break;
				}
				
				if (money != 0)
				{
					GetWitcherPlayer().RemoveMoney((int)money);
				}
				
				GetACSWatcher().RemoveTimer('ACS_Combo_Counter_Reset_Timer'); GetACSWatcher().AddTimer('ACS_Combo_Counter_Reset_Timer', 0.01 , false );

				/*
				if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
				&& !GetWitcherPlayer().IsPerformingFinisher())
				{
					ACS_Hit_Animations(action);
				}
				*/

				movementAdjustor = thePlayer.GetMovingAgentComponent().GetMovementAdjustor();

				ticket = movementAdjustor.GetRequest( 'ACS_Player_Hit_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Hit_Rotate' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Hit_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.5 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, ((CActor)action.attacker) );

				GetWitcherPlayer().DrainVitality( GetWitcherPlayer().GetStat( BCS_Vitality ) * 0.99 );

				if (GetWitcherPlayer().IsAnyWeaponHeld() && !GetWitcherPlayer().IsWeaponHeld('fist'))
				{
					if (RandF() < 0.5)
					{
						GetACSWatcher().PlayerPlayAnimation('man_npc_longsword_effect_knockdown_f_start');
						((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).FreezePoseFadeIn(2.125);
					}
					else
					{
						GetACSWatcher().PlayerPlayAnimation('man_npc_longsword_effect_knockdownfar_f_start');
						((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).FreezePoseFadeIn(2.125);
					}
				}
				else
				{
					if (thePlayer.HasTag('acs_vampire_claws_equipped'))
					{
						GetACSWatcher().PlayerPlayAnimation('bruxa_death_front_ACS');
						//((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).FreezePoseFadeIn(3.125);
					}
					else
					{
						GetACSWatcher().PlayerPlayAnimation('man_fistfight_hit_knockdown_f_start_right');
						((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).FreezePoseFadeIn(2.125);
					}
				}

				theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( thePlayer, 'PlayerUnconsciousAction', -1.f, 60.0f, -1, -1, true ); 

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Unconscious', true); 

				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Unconscious', true); 

				GetWitcherPlayer().AddBuffImmunity(EET_Poison , 'ACS_Unconscious', true);

				GetWitcherPlayer().AddBuffImmunity(EET_PoisonCritical , 'ACS_Unconscious', true);

				GetWitcherPlayer().AddBuffImmunity(EET_Bleeding , 'ACS_Unconscious', true);

				GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

				GetWitcherPlayer().SetCanPlayHitAnim(false);

				GetACSWatcher().ChangeInteractionPriority();

				actors.Clear();

				actors = thePlayer.GetNPCsAndPlayersInRange( 50, 20, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

				if( actors.Size() > 0 )
				{
					for( i = 0; i < actors.Size(); i += 1 )
					{
						npc = (CNewNPC)actors[i];

						actor = actors[i];

						if (((CNewNPC)actor).GetNPCType() == ENGT_Guard)
						{
							enemyAnimatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );		
							
							if (RandF() < 0.5)
							{
								enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_stand_cheering_01', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
							}
							else
							{
								enemyAnimatedComponent.PlaySlotAnimationAsync( 'man_stand_cheering_02', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f));
							}
						}
					}
				}

				GetACSWatcher().RemoveTimer('Gerry_Unconscious_State');

				GetACSWatcher().AddTimer('Gerry_Unconscious_State', 1 , false );

				thePlayer.BlockAction( EIAB_Crossbow, 			'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_CallHorse,			'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Signs, 				'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_DrawWeapon, 		'ACS_Unconscious_State'); 
				thePlayer.BlockAction( EIAB_FastTravel, 		'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Fists, 				'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_InteractionAction, 	'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_UsableItem,			'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_ThrowBomb,			'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_SwordAttack,		'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Jump,				'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_LightAttacks,		'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_HeavyAttacks,		'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_SpecialAttackLight,	'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_SpecialAttackHeavy,	'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Dodge,				'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Roll,				'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Parry,				'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_MeditationWaiting,	'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_OpenMeditation,		'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_RadialMenu,			'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Movement,			'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Interactions, 		'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_QuickSlots, 		'ACS_Unconscious_State');
				thePlayer.BlockAction( EIAB_Explorations, 		'ACS_Unconscious_State');

				GetACSWatcher().ACS_Unconscious_Create_Savelock();

				FactsAdd("ACS_Enter_Unconscious_Start", 1, -1);

				return true;
			}
		}
		else
		{
			if(!(GetACSWatcher().death_scene_start)
			&& FactsQuerySum("ACS_Enter_Unconscious_Start") <= 0
			)
			{
				GetWitcherPlayer().DestroyEffect('heavy_hit_back'); 
				GetWitcherPlayer().DestroyEffect('light_hit_back'); 

				GetWitcherPlayer().PlayEffectSingle('heavy_hit_back'); 
				GetWitcherPlayer().PlayEffectSingle('light_hit_back'); 

				//ACS_Hit_Animations(action);

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage; 

				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage; 

				action.SetHitReactionType(0, false);
				action.ClearDamage();
				action.ClearEffects();
				action.SuppressHitSounds();
				action.SetWasDodged();
				action.SetCannotReturnDamage(true);

				if (thePlayer.inv.HasItem('q111_imlerith_acorn'))
				{
					if (FactsQuerySum("ACS_Allow_Resurrection") <= 0 )
					{
						FactsAdd("ACS_Allow_Resurrection", 1, -1);
					}
				}

				thePlayer.BlockAllActions( 'ACS_Death_Scene', true );

				ACS_ThingsThatShouldBeRemoved();

				GetACSWatcher().ACS_TransformationDisable();

				GetWitcherPlayer().EnableCharacterCollisions(true); 

				GetWitcherPlayer().EnableCollisions(true);

				GetWitcherPlayer().SetIsCurrentlyDodging(false);

				if (GetWitcherPlayer().GetStat( BCS_Focus ) != 0)
				{
					GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
				}

				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

				GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

				GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Death', true); 

				GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Death', true); 

				GetWitcherPlayer().AddBuffImmunity(EET_Poison , 'ACS_Death', true);

				GetWitcherPlayer().AddBuffImmunity(EET_PoisonCritical , 'ACS_Death', true);

				GetWitcherPlayer().AddBuffImmunity(EET_Bleeding , 'ACS_Death', true);

				GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

				if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control'))
				{
					GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');
				} 
	
				GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

				((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePoseFadeOut(0.1);

				((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePose();

				if (((CActor)action.attacker).HasTag('ACS_Blade_Of_The_Unseen'))
				{
					FactsAdd("ACS_Killed_By_Blade_Of_The_Unseen", 1, -1);
				}
				else
				{
					FactsRemove("ACS_Killed_By_Blade_Of_The_Unseen");
				}

				GetACSWatcher().Gerry_Death_Scene_Actual();
				
				GetACSWatcher().DeathSceneEnabled(true);

				return true;
			}
		}
	}

	return false;
}

/*
function ACS_EnemySetupSyncAnimInternalHuman( syncAction : name, master, slave : CEntity ) : bool
{
	var masterDef, slaveDef													: SAnimationSequenceDefinition;
	var masterSequencePart, slaveSequencePart								: SAnimationSequencePartDefinition;
	var syncInstance														: CAnimationManualSlotSyncInstance;
	
	var instanceIndex														: int;
	var sequenceIndex														: int;
	
	var temp 																: name; 
	var tempF 																: float;
	var rot 																: EulerAngles;
	
	var finisherAnim 														: bool;
	var pos 																: Vector;
	
	var syncAnimName, cameraAnimName										: name;
	
	var node, node1 														: CNode; 
	var rot0, rot1, slaveRot 												: EulerAngles;
	
	var masterAnim, slaveAnim 												: name;
	var syncAnimIndex														: int;
	var currentAnimInstance													: CAnimationManualSlotSyncInstance;
	var actorMaster, actorSlave 											: CActor;

	var fear_actors															: array<CActor>;
	var j, k 																: int;
	var fear_actor															: CActor;
	var animatedComponentFearActor											: CAnimatedComponent;
	var movementAdjustorFinisher, movementAdjustorFinisherActor				: CMovementAdjustor;
	var ticketFinisher, ticketFinisherActor 								: SMovementAdjustmentRequestTicket;
	var dist																: float;
	var param																: SCustomEffectParams;
	
	syncInstance = theGame.GetSyncAnimManager().CreateNewSyncInstance( instanceIndex );
	syncAnimIndex = instanceIndex;
	currentAnimInstance = syncInstance;

	thePlayer.BlockAllActions( 'ACS_Finisher_Death_Action_Block', true );

	((CNewNPC)master).EnableCharacterCollisions(false); 

	//((CNewNPC)slave).EnableCharacterCollisions(false); 

	((CNewNPC)master).SetInteractionPriority( IP_Max_Unpushable );

	((CNewNPC)slave).SetInteractionPriority( IP_Max_Unpushable );

	thePlayer.SoundEvent("play_music_kaer_morhen");

	if (RandF() < 0.5)
	{
		thePlayer.SoundEvent("mus_cs001_nightmare_p1");
	}
	else
	{
		thePlayer.SoundEvent("mus_cs001_nightmare_p2");
	}
	

	GetACSWatcher().RemoveTimer('KillGerryRagdoll');

	GetACSWatcher().AddTimer('KillGerryRagdoll', 1.75f, false);

	switch( syncAction )
	{
		case 'man_finisher_dlc_legs_rp':
		{
			masterSequencePart.animation			= 'man_finisher_dlc_legs_rp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_dlc_legs_rp');
			slaveSequencePart.animation				= 'man_finisher_dlc_legs_rp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_dlc_legs_lp':
		{
			masterSequencePart.animation			= 'man_finisher_dlc_legs_lp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_dlc_legs_lp');
			slaveSequencePart.animation				= 'man_finisher_dlc_legs_lp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_dlc_arm_rp':
		{
			

			masterSequencePart.animation			= 'man_finisher_dlc_arm_rp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_dlc_arm_rp');
			slaveSequencePart.animation				= 'man_finisher_dlc_arm_rp_victim_ACS';	
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_dlc_arm_lp':
		{
			

			masterSequencePart.animation			= 'man_finisher_dlc_arm_lp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_dlc_arm_lp');
			slaveSequencePart.animation				= 'man_finisher_dlc_arm_lp_victim_ACS';	
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_dlc_head_rp':
		{
			

			masterSequencePart.animation			= 'man_finisher_dlc_head_rp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_dlc_head_rp');
			slaveSequencePart.animation				= 'man_finisher_dlc_head_rp_victim_ACS';	
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			finisherAnim 							= false;

			ACS_Human_Death_Explode(((CActor)(slave)), ((CActor)(slave)).GetWorldPosition(), 0.5);
			
			break;		
		}
		case 'man_finisher_01_rp':
		{
			

			masterSequencePart.animation			= 'man_finisher_01_rp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_01_rp');
			slaveSequencePart.animation				= 'man_finisher_01_rp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_07_lp':
		{
			

			masterSequencePart.animation			= 'man_finisher_07_lp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_07_lp');
			slaveSequencePart.animation				= 'man_finisher_07_lp_victim_ACS';	
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;

			ACS_Human_Death_Explode(((CActor)(slave)), ((CActor)(slave)).GetWorldPosition(), 0.5);

			break;		
		}
		case 'man_finisher_02_lp':
		{
			masterSequencePart.animation			= 'man_finisher_02_lp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_02_lp');
			slaveSequencePart.animation				= 'man_finisher_02_lp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_08_lp':
		{
			masterSequencePart.animation			= 'man_finisher_08_lp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_08_lp');
			slaveSequencePart.animation				= 'man_finisher_08_lp_victim_ACS';	
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_dlc_neck_rp':
		{
			

			masterSequencePart.animation			= 'man_finisher_dlc_neck_rp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_dlc_neck_rp');
			slaveSequencePart.animation				= 'man_finisher_dlc_neck_rp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_03_rp':
		{
			

			masterSequencePart.animation			= 'man_finisher_03_rp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= false;
			masterSequencePart.shouldRotate			= true;
			masterSequencePart.finalHeading			= slave.GetHeading();
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_03_rp');
			slaveSequencePart.animation				= 'man_finisher_03_rp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= true;
			slaveSequencePart.shouldSlide			= true;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			slaveSequencePart.finalPosition			= thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + thePlayer.GetWorldRight() * -2.5;
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_06_lp':
		{
			

			masterSequencePart.animation			= 'man_finisher_06_lp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= false;
			masterSequencePart.shouldRotate			= true;
			masterSequencePart.finalHeading			= slave.GetHeading();
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_06_lp');
			slaveSequencePart.animation				= 'man_finisher_06_lp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= true;
			slaveSequencePart.shouldSlide			= true;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			slaveSequencePart.finalPosition			= thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + thePlayer.GetWorldRight() * -2.5;
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_04_lp':
		{
			

			masterSequencePart.animation			= 'man_finisher_04_lp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= false;
			masterSequencePart.shouldRotate			= true;
			masterSequencePart.finalHeading			= slave.GetHeading();
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_04_lp');
			slaveSequencePart.animation				= 'man_finisher_04_lp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= true;
			slaveSequencePart.shouldSlide			= true;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			slaveSequencePart.finalPosition			= thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + thePlayer.GetWorldRight() * -2.5;
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			finisherAnim 							= false;
			
			break;		
		}	
		case 'man_finisher_05_rp':
		{
			

			masterSequencePart.animation			= 'man_finisher_05_rp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= false;
			masterSequencePart.shouldRotate			= true;
			masterSequencePart.finalHeading			= slave.GetHeading();
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_05_rp');
			slaveSequencePart.animation				= 'man_finisher_05_rp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= true;
			slaveSequencePart.shouldSlide			= true;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			slaveSequencePart.finalPosition			= thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + thePlayer.GetWorldRight() * -2.5;
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;

			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_dlc_torso_lp':
		{
			

			masterSequencePart.animation			= 'man_finisher_dlc_torso_lp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';


			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );
			slave.AddTag('ACS_man_finisher_dlc_torso_lp');
			slaveSequencePart.animation				= 'man_finisher_dlc_torso_lp_victim_ACS';
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			finisherAnim 							= false;
			
			break;		
		}
		case 'man_finisher_dlc_torso_rp':
		{
			masterSequencePart.animation			= 'man_finisher_dlc_torso_rp_attacker_ACS';
			masterSequencePart.syncType				= AMST_SyncBeginning;
			masterSequencePart.useRefBone			= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone = SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide			= true;
			masterSequencePart.shouldRotate			= true;
			
			masterSequencePart.blendInTime			= 0.25f;
			masterSequencePart.blendOutTime			= 0.25f;
			
			masterSequencePart.sequenceIndex		= 0;
			
			masterDef.parts.PushBack( masterSequencePart );
			masterDef.entity						= master;
			
			masterDef.manualSlotName			= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd					= false;
			
			slave.SetKinematic( true );

			slave.AddTag('ACS_man_finisher_dlc_torso_rp');

			slaveSequencePart.animation				= 'man_finisher_dlc_torso_rp_victim_ACS';	
			slaveSequencePart.syncType				= AMST_SyncBeginning;
			slaveSequencePart.useRefBone			= 'Reference';	
			slaveSequencePart.rotationTypeUsingRefBone = SRT_ToMatchOthersRotation;
			slaveSequencePart.shouldRotate			= false;
			slaveSequencePart.shouldSlide			= false;
			slaveSequencePart.finalHeading			= thePlayer.GetHeading();
			
			slaveSequencePart.blendInTime			= 0.25f;
			slaveSequencePart.blendOutTime			= 0.25f;
			slaveSequencePart.sequenceIndex			= 0;
			slaveSequencePart.disableProxyCollisions = true;
			
			slaveDef.parts.PushBack( slaveSequencePart );
			slaveDef.entity							= slave;
	
			slaveDef.manualSlotName					= 'GAMEPLAY_SLOT';
			slaveDef.freezeAtEnd					= false;
			
			finisherAnim 							= false;
			
			break;		
		}			
		default : 
		{
			return false;
		}
	}
	
	sequenceIndex = syncInstance.RegisterMaster( masterDef );
	
	
	actorMaster = (CActor)master;
	actorSlave = (CActor)slave;
	
	if(actorMaster)
	{
		actorMaster.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
		actorMaster.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
		if ( finisherAnim )
			actorMaster.SignalGameplayEvent( 'PlayFinisherSyncedAnim' );
		else
			actorMaster.SignalGameplayEvent( 'PlaySyncedAnim' );
		
	}
	
	sequenceIndex = syncInstance.RegisterSlave( slaveDef );
	if( sequenceIndex == -1 ) 
	{
		return false;
	}
	
	if(actorSlave)
	{
		if( syncAction == 'Throat' )
			actorSlave.SignalGameplayEventParamCName( 'SetupEndEvent', 'CriticalState' );
			
		actorSlave.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
		actorSlave.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
		if ( finisherAnim )
			actorSlave.SignalGameplayEvent( 'PlayFinisherSyncedAnim' );
		else
			actorSlave.SignalGameplayEvent( 'PlaySyncedAnim' );
	}
	
	return true;
}
*/

function ACS_Player_Fall_Negate(action: W3DamageAction)
{
	if ((CPlayer)action.victim && action.GetBuffSourceName() == "Quest"
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& theGame.GetWorld().GetDepotPath() != "levels\wmh_lv1\wmh_lv1.w2w"
	&& !thePlayer.IsSwimming()
	&& !thePlayer.IsDiving()
	)
	{
		action.SetCanPlayHitParticle(false);
		action.SetProcessBuffsIfNoDamage(false);
		action.SetHitReactionType(EHRT_None, false);

		action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

		action.processedDmg.vitalityDamage += ACS_Settings_Main_Float('acs_damage_settings','acs_player_fall_damage', 0.2) * thePlayer.GetMaxHealth();

		if (action.processedDmg.vitalityDamage == 0)
		{
			GetWitcherPlayer().StopEffect( 'heavy_hit' );

			GetWitcherPlayer().DestroyEffect( 'heavy_hit' );

			GetWitcherPlayer().StopEffect( 'hit_screen' );	

			GetWitcherPlayer().DestroyEffect( 'hit_screen' );
		}

		if (GetWitcherPlayer().IsOnGround()
		)
		{
			if ((theInput.GetActionValue('Jump') > 0.5
			|| theInput.GetActionValue('Dodge') > 0.5
			|| theInput.GetActionValue('CbtRoll') > 0.5)
			)
			{
				action.SetHitReactionType(0, false);
				action.ClearDamage();
				action.ClearEffects();
				action.SuppressHitSounds();
				action.SetWasDodged();
				action.SetCannotReturnDamage(true);
				
				ACS_Fall_Aard_Trigger();
			}
			else
			{
				thePlayer.PlayBattleCry('BattleCryBadSituation', 1, true, true );
			}
		}
	}

	if (
	(CPlayer)action.victim && action.GetBuffSourceName() == "FallingDamage"
	)
	{
		//action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * ACS_Settings_Main_Float('acs_damage_settings','acs_player_fall_damage', 0.2);

		action.SetCanPlayHitParticle(false);

		action.SetProcessBuffsIfNoDamage(false);

		if (
		(GetWitcherPlayer().GetCurrentHealth() - action.processedDmg.vitalityDamage) <= 0
		&& action.processedDmg.vitalityDamage >= GetWitcherPlayer().GetCurrentHealth()
		) 
		{

		}
		else
		{
			if (action.processedDmg.vitalityDamage == 0)
			{
				GetWitcherPlayer().StopEffect( 'heavy_hit' );

				GetWitcherPlayer().DestroyEffect( 'heavy_hit' );

				GetWitcherPlayer().StopEffect( 'hit_screen' );	

				GetWitcherPlayer().DestroyEffect( 'hit_screen' );
			}

			if (GetWitcherPlayer().IsOnGround()
			)
			{
				if ((theInput.GetActionValue('Jump') > 0.5
				|| theInput.GetActionValue('Dodge') > 0.5
				|| theInput.GetActionValue('CbtRoll') > 0.5)
				)
				{
					action.SetHitReactionType(0, false);
					action.ClearDamage();
					action.ClearEffects();
					action.SuppressHitSounds();
					action.SetWasDodged();
					action.SetCannotReturnDamage(true);

					ACS_Fall_Aard_Trigger();
				}
				else
				{
					thePlayer.PlayBattleCry('BattleCryBadSituation', 1, true, true );
				}
			}
		}	
	}
}

function ACS_Fall_Aard_Trigger()
{
	var ent                  				: CEntity;
	var rot                        			: EulerAngles;
    var pos									: Vector;
	var actors    							: array<CActor>;
	var i									: int;	
	var npc     							: CNewNPC;
	var parry_fx							: CEntity;

	//thePlayer.RaiseEvent( 'ACS_CastQuenIdle' );

	thePlayer.RaiseEvent('ACS_CombatExtraHeliotrop');

	if (RandF() < 0.5)
	{
		GetACSWatcher().PlayerPlayAnimation('tw2_npc_sword1h_31_ACS');
	}
	else
	{
		GetACSWatcher().PlayerPlayAnimation('tw2_npc_sword1h_17_ACS');
	}

	if (!GetACSWatcher().combatExtraActive)
	{
		GetACSWatcher().SetCombatExtraStatus(true);
	}

	GetACSWatcher().RemoveTimer('combatExtraReset');
	GetACSWatcher().AddTimer('combatExtraReset', 0.4 , false );

	parry_fx = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\sign_icons.w2ent", true ), 
	(thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 1.5) + Vector(0, 0, 0.5f), 
	thePlayer.GetWorldRotation() );

	parry_fx.PlayEffectSingle('heliotrop_icon');
	parry_fx.ACS_StopEffectAfter('heliotrop_icon', 1.5);

	parry_fx.PlayEffectSingle('heliotrop_fx_01');
	parry_fx.PlayEffectSingle('heliotrop_fx_02');
	parry_fx.PlayEffectSingle('heliotrop_fx_03');
	parry_fx.PlayEffectSingle('heliotrop_explode_01');
	parry_fx.PlayEffectSingle('heliotrop_explode_02');

	parry_fx.PlayEffectSingle('wave_attack_golem');
	parry_fx.PlayEffectSingle('attack_special_golem');
	parry_fx.PlayEffectSingle('light_hit_parried_golem');
	parry_fx.PlayEffectSingle('heavy_hit_parried_golem');
	//parry_fx.PlayEffectSingle('block_attack_fx_golem');

	parry_fx.CreateAttachment(thePlayer,'drain_energy', Vector(0,0.5,0), EulerAngles(0,0,0));

	parry_fx.DestroyAfter(10);

	//thePlayer.SoundEvent("sprj_kill_chance_bb_acs");
	thePlayer.SoundEvent("deflect_large_01_sekiro_acs");
	thePlayer.SoundEvent("sign_quen_discharge_rebound");
	thePlayer.SoundEvent("sign_quen_force_discharge");
	thePlayer.SoundEvent("sign_quen_force_discharge_stop");

	if (GetACSWatcher().idleAdditiveExtraActive)
	{
		thePlayer.RaiseEvent('ACS_IdleAdditiveReset');

		GetACSWatcher().SetIdleAdditiveExtraStatus(false);
	}

	if (thePlayer.IsAnyWeaponHeld()
	&& !thePlayer.IsWeaponHeld('fist')
	)
	{
		/*
		if (RandF() < 0.5)
		{
			GetACSWatcher().PlayerPlayAnimation( 'land_crouch_lf_to_idle_sword' );
		}
		else
		{
			GetACSWatcher().PlayerPlayAnimation( 'land_crouch_rf_to_idle_sword' );
		}
		*/

		GetACSWatcher().PlayerPlayAnimation( 'tw2_npc_sword2h_26_ACS' );
	}
	else
	{
		if (RandF() < 0.5)
		{
			GetACSWatcher().PlayerPlayAnimation( 'land_crouch_lf_to_idle' );
		}
		else
		{
			GetACSWatcher().PlayerPlayAnimation( 'land_crouch_rf_to_idle' );
		}
	}

	if ((theInput.GetActionValue('Sprint') > 0.5)
	)
	{
		actors.Clear();

		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 20, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

		for( i = 0; i < actors.Size(); i += 1 )
		{
			npc = (CNewNPC)actors[i];
			
			if( actors.Size() > 0 )
			{	
				npc.SignalGameplayEvent( 'AI_GetOutOfTheWay' ); 
			
				npc.SignalGameplayEventParamObject( 'CollideWithPlayer', thePlayer ); 

				theGame.GetBehTreeReactionManager().CreateReactionEvent( npc, 'BumpAction', 1, 1, 1, 1, false );

				if (!npc.HasBuff(EET_HeavyKnockdown) && !npc.IsImmuneToBuff(EET_HeavyKnockdown))
				{
					npc.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'ACS_Fall_Shockwave' );
				}

				if (!npc.HasBuff(EET_Stagger) && !npc.IsImmuneToBuff(EET_Stagger))
				{
					npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Fall_Shockwave' );
				}
			}
		}

		rot = GetWitcherPlayer().GetWorldRotation();

		pos = GetWitcherPlayer().GetWorldPosition();

		if ((ACS_Armor_Set_Check('forgotten_wolf', false) 
		|| ACS_Armor_Set_Check('acs_armor', false)
		|| ACS_Armor_Set_Check('volhikar', false)
		|| thePlayer.HasTag('acs_vampire_claws_equipped')
		))
		{
			ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\fx\pc_aard.w2ent"

			, true ), pos, rot );
		}
		else
		{
			ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"gameplay\templates\signs\pc_aard.w2ent"

			, true ), pos, rot );
		}

		ent.PlayEffectSingle('blast_cutscene');

		ent.PlayEffectSingle('blast');

		ent.PlayEffectSingle('blast_water');

		ent.PlayEffectSingle('blast_ground');

		ent.PlayEffectSingle('blast_lv0');

		ent.PlayEffectSingle('blast_lv0_power');

		ent.PlayEffectSingle('blast_lv1_power');

		ent.PlayEffectSingle('blast_lv2_power');

		ent.PlayEffectSingle('blast_lv3_power');

		ent.PlayEffectSingle('blast_lv3_damage');

		ent.PlayEffectSingle('blast_lv1');

		ent.PlayEffectSingle('blast_lv2');

		if ((ACS_Armor_Set_Check('forgotten_wolf', false) 
		|| ACS_Armor_Set_Check('acs_armor', false)
		|| ACS_Armor_Set_Check('volhikar', false)
		|| thePlayer.HasTag('acs_vampire_claws_equipped')
		))
		{
			ent.PlayEffectSingle('blast_lv3_red');
		}
		else
		{
			ent.PlayEffectSingle('blast_lv3');
		}

		ent.PlayEffectSingle('blast_ground_mutation_6');

		ent.DestroyAfter(3);

		theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( thePlayer, 'CastSignAction', -1, 20.0f, -1.f, -1, true );
	}
}

function ACS_Player_Attack_Steel_Silver_Switch(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var dmgValSilver, dmgValSteel																									: float;
	var item_steel, item_silver																										: SItemUniqueId;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	if 
	(playerAttacker && npc)
	{
		if ( !action.WasDodged() 
		&& action.IsActionMelee() 
		&& !thePlayer.IsUsingHorse() 
		&& !thePlayer.IsUsingVehicle()
		&& !(((W3Action_Attack)action).IsParried())
		//&& action.DealsAnyDamage()
		&& !npc.IsInvulnerable()
		&& !GetWitcherPlayer().IsGuarded()
		&& !GetWitcherPlayer().IsInGuardedState()
		)
		{
			ACS_ApplyForce((CNewNPC)npc);
			
			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				if (npc.UsesEssence()
				&& !npc.HasAbility('mon_wraith_base')
				&& !npc.HasAbility('mon_noonwraith_base')
				&& !npc.HasAbility('mon_nightwraith_banshee')
				&& !npc.HasAbility('mon_EP2_wraiths')
				&& !npc.HasAbility('mon_nightwraith_iris')
				&& !npc.HasAbility('q604_shades')
				&& !npc.HasAbility('mon_wraiths_ep1')
				&& !npc.HasAbility('mon_djinn')
				)
				{
					dmgValSilver = GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_SLASHING, GetInvalidUniqueId()) 
					+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_PIERCING, GetInvalidUniqueId())
					+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_BLUDGEONING, GetInvalidUniqueId());

					action.processedDmg.essenceDamage += dmgValSilver;
					
					if (thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' ) 
					|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' )
					)
					{
						if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * 0.025;
						}
						else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * 0.05;
						}

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_steel, GetWitcherPlayer().GetInventory().GetItemMaxDurability(item_steel) );
					}
					else
					{
						//action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.025, 0);
					}
				}
				else if (npc.UsesVitality())
				{
					if (thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' ) 
					|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' )
					)
					{
						if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
						{
							action.processedDmg.vitalityDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.025;
						}
						else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
						{
							action.processedDmg.vitalityDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.05;
						}

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_steel, GetWitcherPlayer().GetInventory().GetItemMaxDurability(item_steel) );
					}
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				if (npc.UsesVitality())
				{
					dmgValSteel = GetWitcherPlayer().GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

					action.processedDmg.vitalityDamage += dmgValSteel;

					if (thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' ) 
					|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' )
					|| ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver')
					)
					{
						if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
						{
							action.processedDmg.vitalityDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.025;
						}
						else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
						{
							action.processedDmg.vitalityDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.05;
						}

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, GetWitcherPlayer().GetInventory().GetItemMaxDurability(item_silver) );
					}
					else
					{
						//action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.025, 0);

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) * 0.025)) );
					}
				}
				else if (npc.UsesEssence())
				{
					if (thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' ) 
					|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' )
					|| ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver')
					)
					{
						if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * 0.025;
						}
						else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * 0.05;
						}

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, GetWitcherPlayer().GetInventory().GetItemMaxDurability(item_silver) );
					}
					else
					{
						if (action.processedDmg.essenceDamage == 0
						)
						{
							dmgValSilver = GetWitcherPlayer().GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

							action.processedDmg.essenceDamage += dmgValSilver;
						}
					}
				}
			}	
		}
	}
}

function ACS_Player_Attack_SFX_Switch(action: W3DamageAction)
{
	var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var acs_npc_blood_fx 																											: array<name>;
	var tmpName 																													: name;
	var tmpBool 																													: bool;
	var mc 																															: EMonsterCategory;
	var vfxEnt, vfxEnt_1, vfxEnt_2, vfxEnt_3																						: CEntity;
	var rot																															: EulerAngles;
	var targetPosition, pos, targetPosition_1, targetPosition_2, targetPosition_3													: Vector;
	var sword_slash_marker																											: CEntity;
	var targetDistance																												: float;
	var bonePosition																												: Vector;
	var boneRotation																												: EulerAngles;
	var headingDiff, tilt_inversion																									: float;
	var light_hit_sound_names, heavy_hit_sound_names																				: array<string>;
	var light_hit_sound_names_primary, heavy_hit_sound_names_primary																: array<string>;
	var light_hit_sound_names_secondary, heavy_hit_sound_names_secondary															: array<string>;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if (ACS_ActionDealsDamageType(action, 'fire'))
	{
		theSound.SoundEvent("proc_heat_wf_acs");
	}

	if (ACS_ActionDealsDamageType(action, 'frost'))
	{
		theSound.SoundEvent("proc_cold_wf_acs");
	}

	/*
	if (ACS_ActionDealsDamageType(action, 'slashing'))
	{
		theSound.SoundEvent("proc_slash_wf_acs");
	}

	if (ACS_ActionDealsDamageType(action, 'rending'))
	{
		theSound.SoundEvent("proc_bleed_wf_acs");
	}
	*/

	if (ACS_ActionDealsDamageType(action, 'elemental'))
	{
		theSound.SoundEvent("proc_radiation_wf_acs");
	}

	if (ACS_ActionDealsDamageType(action, 'poison'))
	{
		theSound.SoundEvent("proc_toxin_wf_acs");
	}

	light_hit_sound_names.Clear();

	light_hit_sound_names_primary.Clear();

	light_hit_sound_names_secondary.Clear();

	heavy_hit_sound_names.Clear();

	heavy_hit_sound_names_primary.Clear();

	heavy_hit_sound_names_secondary.Clear();

	theGame.GetMonsterParamsForActor(npc, mc, tmpName, tmpBool, tmpBool, tmpBool);

	if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
	{
		if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
		{
			light_hit_sound_names.PushBack("damage_01_bb_acs");
			light_hit_sound_names.PushBack("damage_02_bb_acs");

			theSound.SoundEvent(light_hit_sound_names[RandRange(light_hit_sound_names.Size())]);

			light_hit_sound_names_primary.PushBack("greatsword_meat_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_01_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_02_bb_acs");

			theSound.SoundEvent(light_hit_sound_names_primary[RandRange(light_hit_sound_names_primary.Size())]);
		}
		else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
		{
			heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

			theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

			heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
			heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

			theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
		}
		
		if (npc.HasAbility('mon_lessog_base')
		|| npc.HasAbility('mon_sprigan_base')
		)
		{	
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_f_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_g_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_h_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_i_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_j_wf_acs");

			theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
		} 
		else 
		{
			if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_a_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_b_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_c_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_d_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_e_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_f_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_g_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_h_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_i_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_j_wf_acs");

				theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
			}
			else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_a_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_b_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_c_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_d_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_e_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_f_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_g_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_h_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_i_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_j_wf_acs");

				/*
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_a_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_b_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_c_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_d_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_e_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_f_wf_acs");
				*/

				theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
			}
		}
	}
	else if( ((CNewNPC)npc).GetBloodType() == BT_Green) 
	{
		if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
		{
			light_hit_sound_names.PushBack("damage_01_bb_acs");
			light_hit_sound_names.PushBack("damage_02_bb_acs");

			theSound.SoundEvent(light_hit_sound_names[RandRange(light_hit_sound_names.Size())]);

			light_hit_sound_names_primary.PushBack("greatsword_meat_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_01_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_02_bb_acs");

			theSound.SoundEvent(light_hit_sound_names_primary[RandRange(light_hit_sound_names_primary.Size())]);
		}
		else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
		{
			heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

			theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

			heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
			heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

			theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
		}

		if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_f_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_g_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_h_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_i_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_j_wf_acs");

			theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
		}
		else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_f_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_g_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_h_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_i_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_j_wf_acs");

			/*
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_f_wf_acs");
			*/

			theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
		}

		heavy_hit_sound_names_secondary.PushBack("sword_armor_impact_a_wf_acs");
		heavy_hit_sound_names_secondary.PushBack("sword_armor_impact_b_wf_acs");
		heavy_hit_sound_names_secondary.PushBack("sword_armor_impact_c_wf_acs");
		heavy_hit_sound_names_secondary.PushBack("sword_armor_impact_d_wf_acs");
		heavy_hit_sound_names_secondary.PushBack("sword_armor_impact_e_wf_acs");
		heavy_hit_sound_names_secondary.PushBack("sword_armor_impact_f_wf_acs");

		theSound.SoundEvent(heavy_hit_sound_names_secondary[RandRange(heavy_hit_sound_names_secondary.Size())]);
	}
	else if( ((CNewNPC)npc).GetBloodType() == BT_Yellow) 
	{
		if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
		{
			light_hit_sound_names.PushBack("damage_01_bb_acs");
			light_hit_sound_names.PushBack("damage_02_bb_acs");

			theSound.SoundEvent(light_hit_sound_names[RandRange(light_hit_sound_names.Size())]);

			light_hit_sound_names_primary.PushBack("greatsword_meat_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_01_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_02_bb_acs");

			theSound.SoundEvent(light_hit_sound_names_primary[RandRange(light_hit_sound_names_primary.Size())]);
		}
		else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
		{
			heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

			theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

			heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
			heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

			theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
		}

		if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_f_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_g_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_h_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_i_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_j_wf_acs");

			theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
		}
		else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_f_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_g_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_h_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_i_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_j_wf_acs");

			/*
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_f_wf_acs");
			*/

			theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
		}
	}
	else if	( ((CNewNPC)npc).GetBloodType() == BT_Black) 
	{
		if ( mc == MC_Vampire ) 
		{
			if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
			{
				light_hit_sound_names.PushBack("damage_01_bb_acs");
				light_hit_sound_names.PushBack("damage_02_bb_acs");

				theSound.SoundEvent(light_hit_sound_names[RandRange(light_hit_sound_names.Size())]);

				light_hit_sound_names_primary.PushBack("greatsword_meat_bb_acs");
				light_hit_sound_names_primary.PushBack("kill_01_bb_acs");
				light_hit_sound_names_primary.PushBack("kill_02_bb_acs");

				theSound.SoundEvent(light_hit_sound_names_primary[RandRange(light_hit_sound_names_primary.Size())]);
			}
			else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
			{
				heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

				heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
				heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
			}

			if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_a_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_b_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_c_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_d_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_e_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_f_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_g_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_h_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_i_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_j_wf_acs");

				theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
			}
			else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_a_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_b_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_c_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_d_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_e_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_f_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_g_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_h_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_i_wf_acs");
				light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_j_wf_acs");

				/*
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_a_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_b_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_c_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_d_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_e_wf_acs");
				light_hit_sound_names_secondary.PushBack("sword_flesh_impact_f_wf_acs");
				*/

				theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
			}
		}
		else if ( mc == MC_Magicals ) 
		{
			if (npc.HasAbility('mon_golem_base')
			|| npc.HasAbility('mon_djinn')
			|| npc.HasAbility('mon_gargoyle')
			)
			{
				if (npc.HasAbility('mon_golem_base')
				|| npc.HasAbility('mon_gargoyle')
				)
				{
					heavy_hit_sound_names.PushBack("sword_dirt_impact_a_wf_acs");
					heavy_hit_sound_names.PushBack("sword_dirt_impact_b_wf_acs");
					heavy_hit_sound_names.PushBack("sword_dirt_impact_c_wf_acs");
					heavy_hit_sound_names.PushBack("sword_dirt_impact_d_wf_acs");
					heavy_hit_sound_names.PushBack("sword_dirt_impact_e_wf_acs");
					heavy_hit_sound_names.PushBack("sword_dirt_impact_f_wf_acs");

					theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);
				}
			}
			else
			{
				if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
				{
					light_hit_sound_names.PushBack("damage_01_bb_acs");
					light_hit_sound_names.PushBack("damage_02_bb_acs");

					theSound.SoundEvent(light_hit_sound_names[RandRange(light_hit_sound_names.Size())]);

					light_hit_sound_names_primary.PushBack("greatsword_meat_bb_acs");
					light_hit_sound_names_primary.PushBack("kill_01_bb_acs");
					light_hit_sound_names_primary.PushBack("kill_02_bb_acs");

					theSound.SoundEvent(light_hit_sound_names_primary[RandRange(light_hit_sound_names_primary.Size())]);
				}
				else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
				{
					heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
					heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
					heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

					theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

					heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
					heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

					theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
				}
			}
		}
	}
	else
	{
		if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
		{
			light_hit_sound_names.PushBack("damage_01_bb_acs");
			light_hit_sound_names.PushBack("damage_02_bb_acs");

			theSound.SoundEvent(light_hit_sound_names[RandRange(light_hit_sound_names.Size())]);

			light_hit_sound_names_primary.PushBack("greatsword_meat_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_01_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_02_bb_acs");

			theSound.SoundEvent(light_hit_sound_names_primary[RandRange(light_hit_sound_names_primary.Size())]);
		}
		else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
		{
			heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

			theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

			heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
			heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

			theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
		}

		if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_f_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_g_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_h_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_i_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_robotic_flesh_j_wf_acs");

			theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
		}
		else if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_f_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_g_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_h_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_i_wf_acs");
			light_hit_sound_names_secondary.PushBack("melee_sword_impact_flesh_j_wf_acs");

			/*
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_a_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_b_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_c_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_d_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_e_wf_acs");
			light_hit_sound_names_secondary.PushBack("sword_flesh_impact_f_wf_acs");
			*/

			theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
		}
	}
}

function ACS_Player_Attack_FX_Switch(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var acs_npc_blood_fx 																											: array<name>;
	var tmpName 																													: name;
	var tmpBool 																													: bool;
	var mc 																															: EMonsterCategory;
	var vfxEnt, vfxEnt_1, vfxEnt_2, vfxEnt_3																						: CEntity;
	var rot																															: EulerAngles;
	var targetPosition, pos, targetPosition_1, targetPosition_2, targetPosition_3													: Vector;
	var sword_slash_marker, markerNPC_1																								: CEntity;
	var targetDistance																												: float;
	var bonePosition																												: Vector;
	var boneRotation																												: EulerAngles;
	var headingDiff, tilt_inversion																									: float;
	var light_hit_sound_names, heavy_hit_sound_names																				: array<string>;
	var light_hit_sound_names_secondary, heavy_hit_sound_names_secondary															: array<string>;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	targetDistance = VecDistanceSquared2D( GetWitcherPlayer().GetWorldPosition(), npc.GetWorldPosition() ) ;

	if 
	(playerAttacker 
	&& npc
	&& !npc.IsInvulnerable()
	&& !action.WasDodged() 
	&& action.IsActionMelee() 
	&& !thePlayer.IsUsingHorse() 
	&& !thePlayer.IsUsingVehicle()
	&& !(((W3Action_Attack)action).IsParried())
	&& targetDistance <= 5 * 5
	)
	{
		ACS_Caretaker_Drain_Energy();

		if (action.DealsAnyDamage())
		{
			if ( !GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') 
			&& !GetWitcherPlayer().HasTag('ACS_Sparagmos_Active') 
			&& !GetWitcherPlayer().HasTag('ACS_Feainnewedd_Dance')
			&& !GetWitcherPlayer().HasTag('ACS_Mortal_Draw')
			)
			{
				theGame.GetMonsterParamsForActor(npc, mc, tmpName, tmpBool, tmpBool, tmpBool);

				if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
				{
					
					if (npc.HasAbility('mon_lessog_base')
					|| npc.HasAbility('mon_sprigan_base')
					)
					{		
						GetACSWatcher().weapon_blood_fx('black');
					} 
					else 
					{
						GetACSWatcher().weapon_blood_fx('red');
					}
				}
				else if( ((CNewNPC)npc).GetBloodType() == BT_Green) 
				{
					if (npc.HasAbility('mon_kikimore_base')
					|| npc.HasAbility('mon_black_spider_base')
					|| npc.HasAbility('mon_black_spider_ep2_base')
					|| npc.HasTag('ACS_Ungoliant')
					)
					{						
						GetACSWatcher().weapon_blood_fx('black');
					} 
					else 
					{
						GetACSWatcher().weapon_blood_fx('green');
					}
				}
				else if( ((CNewNPC)npc).GetBloodType() == BT_Yellow) 
				{
					if (npc.HasAbility('mon_archespor_base'))
					{
						GetACSWatcher().weapon_blood_fx('yellow');
					} 
					else 
					{
						GetACSWatcher().weapon_blood_fx('red');
					}
				}
				else if	( ((CNewNPC)npc).GetBloodType() == BT_Black) 
				{
					if ( mc == MC_Vampire ) 
					{
						GetACSWatcher().weapon_blood_fx('red');
					}
					else if ( mc == MC_Magicals ) 
					{
						if (npc.HasAbility('mon_golem_base')
						|| npc.HasAbility('mon_djinn')
						|| npc.HasAbility('mon_gargoyle')
						)
						{
							GetACSWatcher().weapon_blood_fx('black');
						}
						else
						{
							GetACSWatcher().weapon_blood_fx('red');
						}
					}
					else
					{
						GetACSWatcher().weapon_blood_fx('black');
					}
				}
				else
				{
					GetACSWatcher().weapon_blood_fx('red');
				}

				if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
				{
					if ( 
					(thePlayer.HasTag('acs_igni_sword_equipped_TAG') 
					|| thePlayer.HasTag('acs_igni_sword_equipped') 
					|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG') 
					|| thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
					&& (GetACSWatcher().silver_strong_stance || GetACSWatcher().steel_strong_stance)
					)
					{
						GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_heavy_attack_camera_shake_strength', 0.5), true, thePlayer.GetWorldPosition(), 30 );
					}
					else
					{
						GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_light_attack_camera_shake_strength', 0.2), true, thePlayer.GetWorldPosition(), 30 );
					}

					if (GetWitcherPlayer().IsDeadlySwordHeld())
					{
						if (ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
						{
							theSound.SoundEvent("monster_cloud_giant_cmb_weapon_hit_add");
						}

						if ( GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') )
						{
							GetWitcherPlayer().SoundEvent("magic_man_sand_gust");
						}
					}

					theSound.SoundEvent("cmb_play_hit_light");
				}
				else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
				{
					GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_heavy_attack_camera_shake_strength', 0.5), true, thePlayer.GetWorldPosition(), 30 );
					
					if (GetWitcherPlayer().IsDeadlySwordHeld())
					{
						if (ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
						{
							theSound.SoundEvent("monster_cloud_giant_cmb_weapon_hit_add");
						}

						if ( GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') )
						{
							GetWitcherPlayer().SoundEvent("magic_man_sand_gust");
						}
					}

					theSound.SoundEvent("cmb_play_hit_heavy");
				}
				else
				{
					if ( 
					(thePlayer.HasTag('acs_igni_sword_equipped_TAG') 
					|| thePlayer.HasTag('acs_igni_sword_equipped') 
					|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG') 
					|| thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
					&& (GetACSWatcher().silver_strong_stance || GetACSWatcher().steel_strong_stance)
					)
					{
						GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_heavy_attack_camera_shake_strength', 0.5), true, thePlayer.GetWorldPosition(), 30 );
					}
					else
					{
						GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_light_attack_camera_shake_strength', 0.2), true, thePlayer.GetWorldPosition(), 30 );
					}
					
					if (GetWitcherPlayer().IsDeadlySwordHeld())
					{
						if (ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver') && GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
						{
							theSound.SoundEvent("monster_cloud_giant_cmb_weapon_hit_add");
						}
						
						if ( GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') )
						{
							GetWitcherPlayer().SoundEvent("magic_man_sand_gust");
						}
					}

					theSound.SoundEvent("cmb_play_hit_heavy");
				}

				if (ACS_Settings_Main_Bool('acs_player_misc_settings','acs_additional_sfx_enabled', true) 
				&& GetWitcherPlayer().IsDeadlySwordHeld())
				{
					ACS_Player_Attack_SFX_Switch(action);
				}
			}

			if (ACS_Settings_Main_Bool('acs_visual_main_settings','acs_directional_slash_effects_enabled', true))
			{
				pos = TraceFloor(thePlayer.GetWorldPosition());
				
				headingDiff = AngleDistance( VecHeading( theCamera.GetCameraDirection() ), VecHeading( thePlayer.GetHeadingVector() ) );

				if (headingDiff >= 90 )
				{
					rot = thePlayer.GetWorldRotation();
				}
				else if (headingDiff < -90 )
				{
					rot = thePlayer.GetWorldRotation();
				}
				else
				{
					rot = theCamera.GetCameraRotation();
					rot.Pitch = 0;
					rot.Roll = 0;
				}

				if (GetWitcherPlayer().IsDeadlySwordHeld()
				&& !thePlayer.HasTag('acs_aard_sword_equipped')
				)
				{
					switch ( action.GetSwingType() )
					{
						case AST_Horizontal:
						
							switch ( action.GetSwingDirection() )
							{
								case ASD_LeftRight: 	
									rot.Roll -= 90;
								break;

								case ASD_RightLeft: 	
									rot.Roll += 90;
								break;

								default: 
									if (RandF() < 0.5)
									{
										rot.Roll -= 90;
									}
									else
									{
										rot.Roll += 90;
									}
								break;
							}
							break;
						
						break;

						case AST_Vertical:
						
							switch ( action.GetSwingDirection() )
							{
								case ASD_UpDown: 		
									rot.Roll += 0;
								break;

								case ASD_DownUp: 		
									rot.Roll += RandRangeF(195,165);	
								break;

								default:
									rot.Roll += 0;	
								break;
							}
							break;
						
						break;

						case AST_DiagonalUp:
						
							switch ( action.GetSwingDirection() )
							{
								case ASD_LeftRight: 	
									rot.Roll += RandRangeF(150,120);		
								break;

								case ASD_RightLeft: 	
									rot.Roll -= RandRangeF(150,120);		
								break;

								default: 
									rot.Roll += 0;	
								break;
							}
							break;
						
						break;

						case AST_DiagonalDown:
						
							switch ( action.GetSwingDirection() )
							{
								case ASD_LeftRight: 	
									rot.Roll += RandRangeF(60,30);		
								break;

								case ASD_RightLeft: 	
									rot.Roll -= RandRangeF(60,30);		
								break;

								default: 
									rot.Roll += 0;	
								break;
							}
							break;
						
						break;

						case AST_Jab:
							
							rot.Roll += 0;	
							rot.Pitch += RandRangeF(105,75);			
							
						break;

						default :					
							rot.Roll += 0;	
						break;
					}

					if ( npc.GetBoneIndex('torso') != -1 )
					{
						targetPosition = npc.GetBoneWorldPosition('torso');

						if (targetPosition.Z > pos.Z + RandRangeF(1.5f,1.125f))
						{
							targetPosition.Z = pos.Z + RandRangeF(1.5f,1.125f);
						}
						else
						{
							targetPosition.Z += RandRangeF(0.125,-0.125);
						}

						targetPosition.X += RandRangeF(0.125,-0.125);
						targetPosition.Y += RandRangeF(0.125,-0.125);
					}
					else
					{
						if ( npc.GetBoneIndex('k_torso_g') != -1 )
						{
							targetPosition = npc.GetBoneWorldPosition('k_torso_g');

							if (targetPosition.Z > pos.Z + RandRangeF(1.5f,1.125f))
							{
								targetPosition.Z = pos.Z + RandRangeF(1.5f,1.125f);
							}
							else
							{
								targetPosition.Z += RandRangeF(0.125,-0.125);
							}

							targetPosition.X += RandRangeF(0.125,-0.125);
							targetPosition.Y += RandRangeF(0.125,-0.125);
						}
						else
						{
							targetPosition = npc.GetWorldPosition();
							targetPosition.Z = pos.Z + RandRangeF(1.5f,1.125f);
							targetPosition.X += RandRangeF(0.125,-0.125);
							targetPosition.Y += RandRangeF(0.125,-0.125);
						}
					}

					vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPosition, rot );

					if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
					|| npc.GetRadius() >= 0.7
					|| npc.HasAbility('Boss')
					|| npc.HasTag('IsBoss')
					|| npc.HasTag('ACS_Big_Boi')
					)
					{
						if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
						{
							vfxEnt.PlayEffectSingle('sword_slash_hit_eff_large');
						}
						else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
						{
							vfxEnt.PlayEffectSingle('sword_slash_hit_eff_large_heavy');
						}
					}
					else
					{
						if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
						{
							vfxEnt.PlayEffectSingle('sword_slash_hit_eff');
						}
						else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
						{
							vfxEnt.PlayEffectSingle('sword_slash_hit_eff_heavy');
						}
					}

					vfxEnt.DestroyAfter(0.5);

					if (ACSGetCEntity('ACS_SwordExtensionStream'))
					{
						sword_slash_marker = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\fx\sword_slash_circular\acs_sword_slash_controller.w2ent"

							, true ), npc.GetWorldPosition() + Vector(0,0,RandRangeF(1.5, 1.25)), thePlayer.GetWorldRotation() );

						sword_slash_marker.AddTag('ACS_Sword_Slash_Light');

						sword_slash_marker.AddTag('ACS_Sword_Slash_Controller_Damage_Reduce_Extra');

						ACSGetCEntity('ACS_SwordExtensionStreamAnchor').Destroy();

						ACSGetCEntity('ACS_SwordExtensionStream').Destroy();
					}

					if (
					(thePlayer.HasTag('ACS_In_Combat_Art')
					|| thePlayer.HasTag('ACS_Horse_Dismount_Jump_Attack')
					|| thePlayer.HasTag('ACS_Flammable_Oil_Enabled')
					|| thePlayer.HasTag('ACS_Neutral_Flip')
					|| thePlayer.IsDoingSpecialAttack(true)
					|| thePlayer.IsDoingSpecialAttack(false)
					|| npc.HasBuff( EET_HeavyKnockdown ) 
					|| npc.HasBuff( EET_Knockdown ) 
					|| npc.HasBuff( EET_Ragdoll ) 
					|| npc.HasBuff( EET_Stagger )
					|| npc.HasBuff( EET_LongStagger )
					|| npc.HasBuff( EET_Pull )
					|| npc.HasBuff( EET_Hypnotized )
					|| npc.HasBuff( EET_WitchHypnotized )
					|| npc.HasBuff( EET_Blindness )
					|| npc.HasBuff( EET_WraithBlindness )
					|| npc.HasBuff( EET_Frozen )
					|| npc.HasBuff( EET_Paralyzed )
					|| npc.HasBuff( EET_Confusion )
					|| npc.HasBuff( EET_Tangled )
					|| npc.HasBuff( EET_Tornado ) 
					|| npc.HasBuff( EET_Swarm ) 
					|| npc.HasBuff( EET_Immobilized )
					|| npc.HasBuff( EET_Weaken )
					|| npc.HasBuff( EET_Burning )
					|| (npc.HasTag('ACS_Counter_Wound_Ready') && ((CNewNPC)npc).acs_wound_fx && ((CNewNPC)npc).acs_posture == ((CNewNPC)npc).acs_max_posture)
					|| npc.HasTag('ACS_Wraith_Finisher_Marked')
					|| npc.HasTag('ACS_Flip_Target')
					|| action.IsCriticalHit()
					|| FactsQuerySum("ACS_Mounted_Attack_Attachment_Active") > 0 
					)
					&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
					&& !thePlayer.HasTag('ACS_IsPerformingCounterWound')
					&& !thePlayer.HasTag('ACS_In_Heavenly_Strike')
					&& !thePlayer.HasTag('ACS_In_Dance_Of_Wrath')
					&& !thePlayer.HasTag('ACS_Ghost_Stance_Active')
					)
					{
						markerNPC_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\fx\sword_slash_circular\acs_sword_slash_circular.w2ent"

						, true ), thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + Vector(0,0,1.5), thePlayer.GetWorldRotation() );

						switch ( action.GetSwingType() )
						{
							case AST_Horizontal:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Right');
									break;

									case ASD_RightLeft: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Left');
									break;

									default: 
										if (RandF() < 0.5)
										{
											markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Right');
										}
										else
										{
											markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Left');
										}
									break;
								}
								break;
							
							break;

							case AST_Vertical:
								markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Overhead');
							break;

							case AST_DiagonalUp:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Diagonal_Right_Up');
									break;

									case ASD_RightLeft: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Diagonal_Left_Up');	
									break;

									default: 
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Diagonal_Left_Up');
									break;
								}
								break;
							
							break;

							case AST_DiagonalDown:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Diagonal_Left');	
									break;

									case ASD_RightLeft: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Diagonal_Right');	
									break;

									default: 
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Diagonal_Right');	
									break;
								}
								break;
							
							break;

							case AST_Jab:
								
								markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Stab');
							break;

							default :					
								rot.Roll += 0;	
							break;
						}
					}

					if (
					thePlayer.HasTag('ACS_IsPerformingFinisher')
					|| thePlayer.HasTag('ACS_IsPerformingCounterWound')
					|| thePlayer.HasTag('ACS_In_Heavenly_Strike')
					|| thePlayer.HasTag('ACS_In_Dance_Of_Wrath')
					|| thePlayer.HasTag('ACS_Ghost_Stance_Active')
					)
					{
						markerNPC_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

						"dlc\dlc_acs\data\fx\sword_slash_circular\acs_sword_slash_circular.w2ent"

						, true ), thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + Vector(0,0,1.5), thePlayer.GetWorldRotation() );

						switch ( action.GetSwingType() )
						{
							case AST_Horizontal:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Right');
									break;

									case ASD_RightLeft: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Left');
									break;

									default: 
										if (RandF() < 0.5)
										{
											markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Right');
										}
										else
										{
											markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Left');
										}
									break;
								}
								break;
							
							break;

							case AST_Vertical:
								markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Overhead');
							break;

							case AST_DiagonalUp:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Diagonal_Left');
									break;

									case ASD_RightLeft: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Diagonal_Right');	
									break;

									default: 
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Diagonal_Right');
									break;
								}
								break;
							
							break;

							case AST_DiagonalDown:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Diagonal_Left');	
									break;

									case ASD_RightLeft: 	
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Diagonal_Right');	
									break;

									default: 
										markerNPC_1.AddTag('ACS_Sword_Slash_Circular_Finisher_Switch_Diagonal_Right');	
									break;
								}
								break;
							
							break;

							case AST_Jab:
								
								markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Stab');
							break;

							default :					
								rot.Roll += 0;	
							break;
						}
					}
				}
				else
				{
					if (thePlayer.HasTag('acs_vampire_claws_equipped')
					|| thePlayer.HasTag('acs_aard_sword_equipped')
					|| FactsQuerySum("acs_transformation_activated") > 0
					)
					{
						switch ( action.GetSwingType() )
						{
							case AST_Horizontal:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										rot.Roll -= 90;
									break;

									case ASD_RightLeft: 	
										rot.Roll += 90;
									break;

									default: 
										if (RandF() < 0.5)
										{
											rot.Roll -= 90;
										}
										else
										{
											rot.Roll += 90;
										}
									break;
								}
								break;
							
							break;

							case AST_Vertical:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_UpDown: 		
										rot.Roll += 0;
									break;

									case ASD_DownUp: 		
										rot.Roll += RandRangeF(195,165);	
									break;

									default:
										rot.Roll += 0;	
									break;
								}
								break;
							
							break;

							case AST_DiagonalUp:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										rot.Roll += RandRangeF(150,120);		
									break;

									case ASD_RightLeft: 	
										rot.Roll -= RandRangeF(150,120);		
									break;

									default: 
										rot.Roll += 0;	
									break;
								}
								break;
							
							break;

							case AST_DiagonalDown:
							
								switch ( action.GetSwingDirection() )
								{
									case ASD_LeftRight: 	
										rot.Roll += RandRangeF(60,30);		
									break;

									case ASD_RightLeft: 	
										rot.Roll -= RandRangeF(60,30);		
									break;

									default: 
										rot.Roll += 0;	
									break;
								}
								break;
							
							break;

							case AST_Jab:
								
								rot.Roll += 0;	
								rot.Pitch += RandRangeF(105,75);			
								
							break;

							default :					
								rot.Roll += 0;	
							break;
						}
						
						if ( npc.GetBoneIndex('torso') != -1 )
						{
							targetPosition = npc.GetBoneWorldPosition('torso');

							if (targetPosition.Z > pos.Z + RandRangeF(1.5f,1.125f))
							{
								targetPosition.Z = pos.Z + RandRangeF(1.5f,1.125f);
							}
							else
							{
								targetPosition.Z += RandRangeF(0.125,-0.125);
							}

							targetPosition.X += RandRangeF(0.125,-0.125);
							targetPosition.Y += RandRangeF(0.125,-0.125);
						}
						else
						{
							if ( npc.GetBoneIndex('k_torso_g') != -1 )
							{
								targetPosition = npc.GetBoneWorldPosition('k_torso_g');

								if (targetPosition.Z > pos.Z + RandRangeF(1.5f,1.125f))
								{
									targetPosition.Z = pos.Z + RandRangeF(1.5f,1.125f);
								}
								else
								{
									targetPosition.Z += RandRangeF(0.125,-0.125);
								}

								targetPosition.X += RandRangeF(0.125,-0.125);
								targetPosition.Y += RandRangeF(0.125,-0.125);
							}
							else
							{
								targetPosition = npc.GetWorldPosition();
								targetPosition.Z = pos.Z + RandRangeF(1.5f,1.125f);
								targetPosition.X += RandRangeF(0.125,-0.125);
								targetPosition.Y += RandRangeF(0.125,-0.125);
							}
						}

						vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPosition_1, rot );

						vfxEnt_1.DestroyAfter(0.5);

						
						targetPosition_2 = targetPosition_1;

						targetPosition_3 = targetPosition_1;

						if (rot.Roll == 0
						)
						{
							targetPosition_2.X += 0.25;

							targetPosition_2.Y += 0.25;

							targetPosition_3.X -= 0.25;

							targetPosition_3.Y -= 0.25;
						}
						else
						{
							targetPosition_2.Z += 0.25;

							targetPosition_3.Z -= 0.25;
						}
						

						vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPosition_2, rot );

						vfxEnt_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPosition_3, rot );

						vfxEnt_2.DestroyAfter(0.5);

						vfxEnt_3.DestroyAfter(0.5);

						if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
						{
							vfxEnt_1.PlayEffectSingle('sword_slash_player_hit');
							vfxEnt_2.PlayEffectSingle('sword_slash_player_hit');
							vfxEnt_3.PlayEffectSingle('sword_slash_player_hit');
						}
						else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
						{
							vfxEnt_1.PlayEffectSingle('sword_slash_player_hit_heavy');
							vfxEnt_2.PlayEffectSingle('sword_slash_player_hit_heavy');
							vfxEnt_3.PlayEffectSingle('sword_slash_player_hit_heavy');
						}
						else
						{
							vfxEnt_1.PlayEffectSingle('sword_slash_player_hit');
							vfxEnt_2.PlayEffectSingle('sword_slash_player_hit');
							vfxEnt_3.PlayEffectSingle('sword_slash_player_hit');
						}
					}
					else
					{
						if (
						(thePlayer.HasTag('ACS_In_Combat_Art')
						|| thePlayer.HasTag('ACS_Horse_Dismount_Jump_Attack')
						|| thePlayer.HasTag('ACS_Flammable_Oil_Enabled')
						|| thePlayer.IsDoingSpecialAttack(true)
						|| thePlayer.IsDoingSpecialAttack(false)
						|| npc.HasBuff( EET_HeavyKnockdown ) 
						|| npc.HasBuff( EET_Knockdown ) 
						|| npc.HasBuff( EET_Ragdoll ) 
						|| npc.HasBuff( EET_Stagger )
						|| npc.HasBuff( EET_LongStagger )
						|| npc.HasBuff( EET_Pull )
						|| npc.HasBuff( EET_Hypnotized )
						|| npc.HasBuff( EET_WitchHypnotized )
						|| npc.HasBuff( EET_Blindness )
						|| npc.HasBuff( EET_WraithBlindness )
						|| npc.HasBuff( EET_Frozen )
						|| npc.HasBuff( EET_Paralyzed )
						|| npc.HasBuff( EET_Confusion )
						|| npc.HasBuff( EET_Tangled )
						|| npc.HasBuff( EET_Tornado ) 
						|| npc.HasBuff( EET_Swarm ) 
						|| npc.HasBuff( EET_Immobilized )
						|| npc.HasBuff( EET_Weaken )
						|| npc.HasBuff( EET_Burning )
						|| (npc.HasTag('ACS_Counter_Wound_Ready') && ((CNewNPC)npc).acs_wound_fx && ((CNewNPC)npc).acs_posture == ((CNewNPC)npc).acs_max_posture)
						|| npc.HasTag('ACS_Wraith_Finisher_Marked')
						|| action.IsCriticalHit()
						)
						&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
						&& !thePlayer.HasTag('ACS_IsPerformingCounterWound')
						&& !thePlayer.HasTag('ACS_In_Heavenly_Strike')
						&& !thePlayer.HasTag('ACS_In_Dance_Of_Wrath')
						&& !thePlayer.HasTag('ACS_Ghost_Stance_Active')
						)
						{
							markerNPC_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

							"dlc\dlc_acs\data\fx\sword_slash_circular\acs_sword_slash_circular.w2ent"

							, true ), thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() + Vector(0,0,1.5), thePlayer.GetWorldRotation() );

							markerNPC_1.AddTag('ACS_Sword_Slash_Circular_On_Hit_Switch_Stab');
						}
					}
				}
			}
		}
	}
}

function ACS_Allow_Additional_Hit_Sound( npc : CActor ) : bool
{
	if (npc.GetMovingAgentComponent().GetName() == "woman_base"
	|| npc.GetMovingAgentComponent().GetName() == "man_base"
	)
	{
		return true;
	}

	if 
	(
		npc.HasAbility('mon_boar_base')
		|| npc.HasAbility('mon_bear_base')
		|| npc.GetSfxTag() == 'sfx_wild_dog'
		|| npc.GetSfxTag() == 'sfx_wolf'
		|| npc.GetSfxTag() == 'sfx_bear'
		|| npc.HasAbility('mon_panther_base')
		|| npc.HasAbility('mon_q704_ft_pigs_evil')
		|| npc.HasAbility('mon_boar_ep2_base')
	)
	{
		return true;
	}

	if 
	(
		npc.HasAbility('mon_lycanthrope')
		|| npc.GetSfxTag() == 'sfx_werewolf'
		|| npc.HasAbility('mon_archespor_base')
		|| npc.HasAbility('mon_q704_ft_wilk')
	)
	{
		return true;
	}

	if 
	(
		npc.GetSfxTag() == 'sfx_cockatrice'
		|| npc.HasAbility('mon_basilisk')
		|| npc.HasAbility('mon_forktail_young')
		|| npc.HasAbility('mon_forktail')
		|| npc.HasAbility('mon_forktail_mh')
		|| npc.GetSfxTag() == 'sfx_wyvern'
		|| npc.HasAbility('mon_mq7010_dracolizard')
		|| npc.HasAbility('mon_draco_base')
		|| npc.HasAbility('mon_mq7018_basilisk')
	)
	{
		return true;
	}

	if 
	(
		npc.GetSfxTag() == 'sfx_elemental_dao' 	
		|| npc.GetSfxTag() == 'sfx_golem'
		|| npc.GetSfxTag() == 'sfx_elemental_ifryt'
		|| npc.GetSfxTag() == 'sfx_wildhunt_minion'
		|| npc.HasAbility('mon_ice_golem')
		|| npc.HasAbility('mon_gargoyle')
		|| npc.HasAbility('mon_dark_pixie_base')
		|| npc.HasAbility('mon_q704_ft_pixies')
		|| npc.HasAbility('mon_graveir')
		|| npc.HasAbility('mon_dark_pixie_base')
	)
	{
		return false;
	}

	if 
	(
		npc.GetSfxTag() == 'sfx_gryphon'
		|| npc.HasAbility('mon_erynia')
		|| npc.GetSfxTag() == 'sfx_harpy'
		|| npc.GetSfxTag() == 'sfx_siren'
	)
	{
		return true;
	}

	if 
	(
		npc.HasAbility('mon_arachas_base')
		|| npc.HasAbility('mon_poison_arachas')
		|| npc.HasAbility('mon_black_spider_base')
		|| npc.GetSfxTag() == 'sfx_arachas'
		|| npc.GetSfxTag() == 'sfx_endriaga'
		|| npc.HasAbility('mon_endriaga_soldier_tailed')
		|| npc.HasAbility('mon_endriaga_worker')
		|| npc.HasTag('mq7023_pale_widow')
		|| npc.HasAbility('mon_scolopendromorph_base')
		|| npc.HasAbility('mon_kikimora_warrior')
		|| npc.HasAbility('mon_kikimora_worker')
		|| npc.HasAbility('mon_black_spider_ep2_base')
	)
	{
		return false;
	}

	if 
	(
		npc.GetSfxTag() == 'sfx_alghoul' 
		|| npc.HasAbility('mon_greater_miscreant')
		|| npc.GetSfxTag() == 'sfx_drowner'
		|| npc.GetSfxTag() == 'sfx_fogling'
		|| npc.GetSfxTag() == 'sfx_gravehag'
		|| npc.GetSfxTag() == 'sfx_waterhag'
		|| npc.HasAbility('mon_rotfiend')
		|| npc.HasAbility('mon_rotfiend_large')
		|| npc.HasAbility('mon_gravier')
		|| npc.HasAbility('mon_wight')
		|| npc.HasAbility('mon_ghoul_lesser')
		|| npc.HasAbility('mon_ghoul')
		|| npc.HasAbility('mon_ghoul_stronger')
		|| npc.HasAbility('mon_EP2_ghouls')
		|| npc.HasAbility('ghoul_hardcore')
	)
	{
		return true;
	}

	if 
	(
		npc.GetSfxTag() == 'sfx_ice_giant'
		|| npc.GetSfxTag() == 'sfx_nekker'
		|| npc.HasTag('ice_troll')
		|| npc.GetSfxTag() == 'sfx_troll_cave'
		|| npc.HasAbility('mon_cyclops')
		|| npc.HasAbility('mon_knight_giant')
		|| npc.HasAbility('mon_cloud_giant')
	)
	{
		return true;
	}

	if 
	(
		npc.HasAbility('mon_toad_base')
		|| npc.HasAbility('q604_caretaker')
		|| npc.HasAbility('mon_czart')
		|| npc.GetSfxTag() == 'sfx_bies'
		|| npc.GetSfxTag() == 'sfx_lessog'
		|| npc.HasAbility('mon_sprigan')
		|| npc.HasAbility('mon_sharley_base')
		|| npc.HasAbility('mon_fairytale_witch')
		|| npc.HasTag('witch')
	)
	{
		return true;
	}

	if 
	(
		npc.HasAbility('mon_nightwraith_iris')
		|| npc.HasAbility('mon_nightwraith')
		|| npc.HasAbility('mon_nightwraith_mh')
		|| npc.HasAbility('mon_noonwraith')
		|| npc.HasAbility('mon_noonwraith_doppelganger')
		|| npc.GetSfxTag() == 'sfx_wraith'
		|| npc.HasAbility('mon_panther_ghost')
		|| npc.HasAbility('mon_barghest_base')
		|| npc.HasAbility('banshee_rapunzel')
		|| npc.HasAbility('mon_nightwraith_banshee')
		|| npc.HasAbility('banshee_rapunzel')
	)
	{
		return false;
	}

	if 
	(
		npc.GetSfxTag() == 'sfx_katakan'
		|| npc.HasAbility('mon_ekimma')
		|| npc.HasAbility('mon_garkain')
		|| npc.HasAbility('mon_bruxa')
		|| npc.HasAbility('mon_fleder')
		|| npc.HasAbility('q704_mon_protofleder')
		|| npc.HasAbility('mon_alp')
		|| npc.HasTag('dettlaff_vampire')
	)
	{
		return true;
	}

	return false;
}

function ACS_WintersBlade_Ability_Spawn()
{
	var proj_1											: W3ACSIceStaffIceSpearProjectile;
	var actors 											: array<CActor>;
	var i												: int;
	var initpos_1										: Vector;

	actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 10, 10, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors);

	if( actors.Size() > 0 )
	{
		for( i = 0; i < actors.Size(); i += 1 )
		{
			if ( GetAttitudeBetween( actors[i], GetWitcherPlayer() ) == AIA_Hostile && actors[i].IsAlive() )
			{
				initpos_1 = actors[i].GetWorldPosition();	

				initpos_1.Z += 3;

				proj_1 = (W3ACSIceStaffIceSpearProjectile)theGame.CreateEntity( 
				(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\ice_staff_ice_spear.w2ent", true ), initpos_1 );
								
				proj_1.Init(GetWitcherPlayer());
				proj_1.PlayEffectSingle('fire_fx');
				proj_1.PlayEffectSingle('explode');
				proj_1.ShootProjectileAtPosition( 0, 15, actors[i].GetWorldPosition(), 500 );
				proj_1.DestroyAfter(5);
			}
		}
	}
}

function ACS_AllBlack_Ability_Spawn( pos : Vector )
{
	var proj_1																												: W3ACSBloodTentacles;

	proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSFixZAxis(pos) );

	proj_1.AddTag('ACS_Necrosword_Ability');

	proj_1.DestroyAfter(10);	
}

function ACS_Red_Miasmal_Ability_Spawn_Big( pos : Vector )
{
	var proj_1																												: W3ACSBloodTentacles;

	
	proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\transformation_red_miasmal_tentacles.w2ent", true ), pos );

	proj_1.AddTag('ACS_Transformation_Red_Miasmal_Ability');

	proj_1.DestroyAfter(10);	
}

function ACS_Red_Miasmal_Ability_Spawn( pos : Vector )
{
	var proj_1																												: W3ACSBloodTentacles;

	
	proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\transformation_red_miasmal_tentacles_small.w2ent", true ), pos );

	proj_1.AddTag('ACS_Transformation_Red_Miasmal_Ability_Small');

	proj_1.DestroyAfter(10);	
}

function ACS_Enemy_On_Take_Damage_General(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animcomp 																													: CAnimatedComponent;
	var movementAdjustorNPC																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var soundeventstring																											: array< string >;
	var params 																														: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if (npc
	&& playerAttacker
	&& !npc.IsInvulnerable()
	)
	{
		if(((CNewNPC)npc).IsHorse() && npc != thePlayer.GetHorseWithInventory())
		{
			npc.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));
			npc.DestroyAfter(1);

			return;
		}

		if (npc.IsMonster()
		&& !npc.HasAbility('mon_wraith_base')
		&& !npc.HasAbility('mon_noonwraith_base')
		&& !npc.HasAbility('mon_nightwraith_banshee')
		&& !npc.HasAbility('mon_EP2_wraiths')
		&& !npc.HasAbility('mon_nightwraith_iris')
		&& !npc.HasAbility('q604_shades')
		&& !npc.HasAbility('mon_wraiths_ep1')
		&& !npc.HasAbility('mon_djinn')
		)
		{
			npc.SetInteractionPriority( IP_Max_Unpushable );
		}

		if (!((CNewNPC)npc).IsFlying()
		)
		{
			if (npc.HasTag('ACS_Gryphon_Eating_Process')
			)
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.99;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.99;
				}

				npc.RemoveTimer('ACS_AbductionDelayedHealing');

				((CAnimatedComponent)((CActor)npc).GetComponentByClassName('CAnimatedComponent')).PlaySlotAnimationAsync('monster_gryphon_special_attack_tearing_up_stop', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));

				npc.RemoveTag('ACS_Gryphon_Eating_Process');
			}
		}

		if(thePlayer.HasTag('ACS_Air_Time'))
		{
			if (thePlayer.GetStat(BCS_Stamina) > 0)
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage *= (npc.GetMaxHealth()/npc.GetCurrentHealth()) * 0.25;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage *= (npc.GetMaxHealth()/npc.GetCurrentHealth()) * 0.25;
				}

				GetACSWatcher().ACS_SlowMoAdjustable(0.75,0.25);

				//thePlayer.RaiseEvent('ACS_ForceLegsFloatIdle');

				GetACSWatcher().RemoveTimer('RemoveACSAirTime');
				GetACSWatcher().AddTimer('RemoveACSAirTime', 1 , false );
			}
			else
			{
				thePlayer.BlockAllActions( 'ACS_Air_Time_Init', false );

				GetACSWatcher().RemoveTimer('Air_Time_Movement_Adjust_Delay');

				GetACSWatcher().RemoveTimer('Air_Time_Trigger_Delay');

				thePlayer.EnableCollisions(true);

				thePlayer.UnblockAction( EIAB_CallHorse,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_DrawWeapon, 		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_FastTravel, 		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_InteractionAction, 	'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_UsableItem,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_MeditationWaiting,	'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_OpenMeditation,		'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_RadialMenu,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_Movement,			'ACS_Air_Time');
				thePlayer.UnblockAction( EIAB_QuickSlots, 		'ACS_Air_Time');

				thePlayer.RemoveTag('ACS_Air_Time');
				
				thePlayer.RaiseEvent('ACS_FeetAdditiveEnd');
			}
		}

		if(thePlayer.HasTag('ACS_Feainnewedd_Dance'))
		{
			ACSCreateFeainneweddVFX(npc, npc.GetWorldPosition());
		}

		if(thePlayer.HasTag('ACS_Mortal_Draw'))
		{
			if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.125;
			}
			else if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.125;
			}
		}

		if((npc.HasAbility('mon_golem_base')
		|| npc.HasAbility('mon_arachas_base') 
		|| npc.HasAbility('mon_poison_arachas')
		|| npc.GetSfxTag() == 'sfx_arachas'
		|| npc.HasAbility('mon_cyclops')
		|| npc.HasAbility('mon_ice_giant')
		|| npc.HasAbility('mon_cloud_giant')
		|| npc.HasAbility('mon_knight_giant')
		|| npc.HasAbility('SkillGregoire')
		|| npc.HasAbility('WildHunt_Imlerith')
		//|| npc.HasAbility('WildHunt_Eredin')
		|| npc.HasAbility('mon_bear_base')
		|| npc.HasAbility('mon_gryphon_base')
		|| npc.HasAbility('mon_bies_base')
		|| npc.HasAbility('mon_toad_base')
		|| npc.HasAbility('mon_troll_base')
		|| npc.HasAbility('q302_mh104')
		|| npc.HasAbility('mon_mq7010_dracolizard')
		|| npc.HasAbility('mon_sprigan')
		|| (npc.HasAbility('mon_lessog_base') && !npc.HasAbility('mon_him'))
		|| (npc.HasAbility('mon_fugas_base') && !StrContains(npc.GetAutoEffect(), "ghost" )
		))
		&& !npc.HasBuff(EET_Burning)
		&& !npc.HasBuff(EET_Frozen)
		&& !npc.HasBuff(EET_SlowdownFrost)
		&& !npc.HasBuff(EET_Stagger)
		&& !npc.HasBuff(EET_LongStagger)
		&& !npc.HasBuff(EET_Knockdown)
		&& !npc.HasBuff(EET_HeavyKnockdown)
		&& !npc.HasBuff(EET_Confusion)
		&& !npc.HasBuff(EET_Hypnotized)
		&& !npc.HasBuff(EET_Immobilized)
		&& !npc.HasBuff(EET_Paralyzed)
		&& !npc.HasTag('ACS_Pre_Rage')
		&& !npc.HasTag('ACS_In_Rage')
		&& !npc.HasTag('ACS_Currently_In_Grapple_Anim')
		&& !npc.HasTag('ACS_Currently_In_Beh_Switch_Anim')
		&& !thePlayer.HasTag('ACS_Is_Sneaking')
		)
		{
			movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

			ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
			movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
			movementAdjustorNPC.CancelAll();

			ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
			movementAdjustorNPC.AdjustmentDuration( ticket, 2 );
			movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 50000 );
			movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );

			((CActor)npc).GetMovingAgentComponent().SetGameplayMoveDirection(VecHeading(thePlayer.GetWorldPosition() - npc.GetWorldPosition()));

			if((((W3Action_Attack)action).GetAttackName() == 'attack_light'
			|| ((W3Action_Attack)action).GetAttackName() == 'attack_light_special')
			)
			{
				if (GetACSWatcher().steel_strong_stance
				|| GetACSWatcher().silver_strong_stance
				)
				{
					action.SetHitAnimationPlayType(EAHA_ForceYes);
				}
				else
				{
					if(npc.HasAbility('mon_cyclops')
					|| npc.HasAbility('mon_ice_giant')
					|| npc.HasAbility('mon_cloud_giant')
					|| npc.HasAbility('mon_knight_giant')
					|| npc.HasAbility('mon_bear_base')
					|| npc.HasAbility('mon_gryphon_base')
					|| npc.HasAbility('mon_bies_base')
					|| npc.HasAbility('mon_toad_base')
					|| (npc.HasAbility('mon_fugas_base') && !StrContains(npc.GetAutoEffect(), "ghost" ))
					)
					{
						theSound.SoundEvent("cmb_arrow_impact_body");
					}

					if(npc.HasAbility('mon_arachas_base')
					|| npc.HasAbility('mon_poison_arachas')
					|| npc.GetSfxTag() == 'sfx_arachas'
					|| npc.HasAbility('SkillGregoire')
					|| npc.HasAbility('WildHunt_Imlerith')
					//|| npc.HasAbility('WildHunt_Eredin')
					|| npc.HasAbility('mon_mq7010_dracolizard')
					)
					{
						theSound.SoundEvent("cmb_arrow_bounce");
					}

					if(npc.HasAbility('mon_golem_base')
					|| npc.HasAbility('mon_troll_base')
					|| npc.HasAbility('q302_mh104')
					)
					{
						theSound.SoundEvent("cmb_arrow_impact_stone");
					}

					if(npc.HasAbility('mon_sprigan')
					|| (npc.HasAbility('mon_lessog_base') && !npc.HasAbility('mon_him'))
					)
					{
						theSound.SoundEvent("cmb_arrow_impact_wood");
					}

					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}

					soundeventstring.Clear();
					soundeventstring.PushBack("scene_grunt_vo_attack_long_ALWAYS");
					soundeventstring.PushBack("scene_grunt_vo_attack_medium_ALWAYS");
					soundeventstring.PushBack("scene_grunt_vo_attack_short_ALWAYS");

					thePlayer.SoundEvent(soundeventstring[RandRange(soundeventstring.Size())]);

					if (((CNewNPC)npc).acs_posture == ((CNewNPC)npc).acs_max_posture
					)
					{
						if (RandF() < 0.75)
						{
							action.SetHitAnimationPlayType(EAHA_ForceNo);
						}
						else
						{
							action.SetHitAnimationPlayType(EAHA_ForceYes);
						}
					}
					else
					{
						action.SetHitAnimationPlayType(EAHA_ForceNo);
					}
				}
			}
		}
		
		if (ACS_Settings_Main_Float('acs_damage_settings','acs_player_damage_multiplier', 1) != 1 
		&& !npc.HasTag('ACS_Final_Fear_Stack')
		)
		{
			if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage *= ACS_Settings_Main_Float('acs_damage_settings','acs_player_damage_multiplier', 1);
			}
			else if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage *= ACS_Settings_Main_Float('acs_damage_settings','acs_player_damage_multiplier', 1);
			}
		}

		if (thePlayer.HasTag('ACS_Player_In_Everstorm_Distance_1'))
		{
			if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage;
			}
			else if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage += action.processedDmg.essenceDamage;
			}

			action.SetCriticalHit();
		}

		if(thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ) && action.IsActionMelee())
		{
			if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage *= 0.001;
			}
			else if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage *= 0.001;
			}
		}

		if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
		||
		(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
		{
			if (FactsQuerySum("acs_red_miasmal_curse_activated") > 0)
			{
				if (!npc.HasTag('ACS_Red_Miasmal_Ability_Spawn_From_Player'))
				{
					ACS_Red_Miasmal_Ability_Spawn(npc.GetWorldPosition());

					npc.AddTag('ACS_Red_Miasmal_Ability_Spawn_From_Player');
				}
			}
		}

		if ( (W3BoltProjectile)action.causer
		)
		{
			if (thePlayer.IsSwimming() || thePlayer.IsDiving())
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

					action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.0625;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

					action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.0625;
				}
			}
			else
			{
				if (npc.HasTag('ACS_CrossbowCounterTarget'))
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
					}

					if(!npc.IsImmuneToBuff(EET_HeavyKnockdown))
					{
						npc.RemoveTimer('ACS_AddHeavyKnockdownDelay');
						npc.AddTimer('ACS_AddHeavyKnockdownDelay', 0.1 , false );
					}
					else
					{
						npc.RemoveTimer('ACS_AddKnockdownDelay');
						npc.AddTimer('ACS_AddKnockdownDelay', 0.1 , false );
					}
				}
				else
				{
					if (ACS_Settings_Main_Int('acs_damage_settings','acs_crossbow_damage_max_health_or_current_health', 0) == 0)
					{
						if (npc.UsesVitality())
						{
							if (ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_human_min_damage', 0) > 0 || ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_human_max_damage', 0) > 0)
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

								action.processedDmg.vitalityDamage += npc.GetMaxHealth() * RandRangeF(ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_human_max_damage', 0), ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_human_min_damage', 0));
							}
						}
						else if (npc.UsesEssence())
						{
							if (ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_min_damage', 0) > 0 || ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_max_damage', 0) > 0)
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

								if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
								|| npc.GetRadius() >= 0.7
								|| npc.HasAbility('Boss')
								|| npc.HasTag('IsBoss')
								|| npc.HasTag('ACS_Big_Boi')
								)
								{
									action.processedDmg.essenceDamage += npc.GetMaxHealth() * RandRangeF(ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_max_damage', 0)/2, ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_min_damage', 0)/2);
								}
								else
								{
									action.processedDmg.essenceDamage += npc.GetMaxHealth() * RandRangeF(ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_max_damage', 0), ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_min_damage', 0));
								}
							}
						}
					}
					else if (ACS_Settings_Main_Int('acs_damage_settings','acs_crossbow_damage_max_health_or_current_health', 0) == 1)
					{
						if (npc.UsesVitality())
						{
							if (ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_human_min_damage', 0) > 0 || ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_human_max_damage', 0) > 0)
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

								action.processedDmg.vitalityDamage += npc.GetCurrentHealth() * RandRangeF(ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_human_max_damage', 0), ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_human_min_damage', 0));
							}
						}
						else if (npc.UsesEssence())
						{
							if (ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_min_damage', 0) > 0 || ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_max_damage', 0) > 0)
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

								if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
								|| npc.GetRadius() >= 0.7
								|| npc.HasAbility('Boss')
								|| npc.HasTag('IsBoss')
								|| npc.HasTag('ACS_Big_Boi')
								)
								{
									action.processedDmg.essenceDamage += npc.GetCurrentHealth() * RandRangeF(ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_max_damage', 0)/2, ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_min_damage', 0)/2);
								}
								else
								{
									action.processedDmg.essenceDamage += npc.GetCurrentHealth() * RandRangeF(ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_max_damage', 0), ACS_Settings_Main_Float('acs_damage_settings','acs_crossbow_monster_min_damage', 0));
								}
							}
						}
					}
					
					if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
					|| npc.GetRadius() >= 0.7
					|| npc.HasAbility('Boss')
					|| npc.HasTag('IsBoss')
					|| npc.HasTag('ACS_Big_Boi')
					)
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
					}
					else
					{
						params.effectType = EET_Stagger;
						params.creator = thePlayer;
						params.sourceName = "ACS_Bolt_Stagger";
						params.duration = 0.5;

						npc.AddEffectCustom( params );
					}
				}
			}
		}

		if ( (W3Petard)action.causer
		)
		{
			((CNewNPC)npc).ACS_DealPostureDamage(10);
		}

		if ( !action.WasDodged() 
		&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
		&& !GetWitcherPlayer().IsGuarded()
		&& !GetWitcherPlayer().IsInGuardedState()
		)
		{
			if (!(((W3Action_Attack)action).IsParried()))
			{
				if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
				||
				(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
				{
					if (RandF() < 0.25)
					{
						GetACSWatcher().Blood_Spatter_Switch();
					}

					if (ACS_GetItem_Sword_IsEquipped('all_black_held', 'steel'))
					{
						if (!npc.HasTag('ACS_AllBlack_Ability_Spawn_From_Player'))
						{
							ACS_AllBlack_Ability_Spawn(npc.GetWorldPosition());

							npc.AddTag('ACS_AllBlack_Ability_Spawn_From_Player');
						}
					}

					if (ACS_GetItem_SwordHeldSwitchBasedUponStat('poison_sword') && thePlayer.HasTag('ACS_Flammable_Oil_Enabled'))
					{
						if (!npc.HasTag('ACS_Poison_Sword_Death_Ability_Spawn_From_Player'))
						{
							ACS_Poison_Cloud();

							npc.AddTag('ACS_Poison_Sword_Death_Ability_Spawn_From_Player');
						}
					}

					if (ACS_GetItem_Sword_IsEquipped('winters_blade_held', 'steel'))
					{
						if (!npc.HasTag('ACS_WintersBlade_Ability_Spawn_From_Player'))
						{
							ACS_WintersBlade_Ability_Spawn();

							npc.AddTag('ACS_WintersBlade_Ability_Spawn_From_Player');
						}
					}
				}
				else
				{
					ACS_Sign_Combo_System(action);

					if(action.DealsAnyDamage())
					{
						GetACSWatcher().Player_Blood_Covered_Effect(npc);

						if (thePlayer.IsWeaponHeld('fist') 
						&& !thePlayer.HasTag('acs_vampire_claws_equipped')
						&& !thePlayer.HasTag('acs_sorc_fists_equipped')
						)
						{

						}
						else
						{
							if (RandF() < 0.25)
							{
								GetACSWatcher().Blood_Spatter_Switch();
							}
						}
						
					}

					if (thePlayer.HasTag('ACS_Counter_Initiated'))
					{
						thePlayer.RaiseEvent('ACS_SwordCounterAdditiveReset');

						thePlayer.RemoveTag('ACS_Counter_Initiated');
					}

					if (GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						|| npc.HasTag('ACS_Big_Boi')
						|| npc.HasAbility('mon_troll_base')
						|| npc.HasTag('ACS_Giant_Troll')
						|| npc.HasTag('ACS_Bullvore')
						|| npc.HasAbility('NPC Leather Armor') 
						|| npc.HasAbility('NPC Heavy Leather Armor') 
						|| npc.HasAbility('NPC Chainmail Armor') 
						|| npc.HasAbility('NPC Partial Plate Armor') 
						|| npc.HasAbility('NPC Full Plate Armor') 
						|| npc.HasAbility('NPC_Wild_Hunt_Armor')
						|| StrContains(npc.GetReadableName(), "armor" )
						|| ((CNewNPC)npc).IsShielded(thePlayer)
						|| npc.HasTag('ACS_Swapped_To_Shield') 
						|| npc.GetMovingAgentComponent().GetName() == "wild_hunt_base"
						|| CalculateAttributeValue(((CActor)npc).GetTotalArmor()) > 0
						)
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage;

							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage;

							action.SetCriticalHit();
						}

						action.SetIgnoreArmor(true);
					}

					if ( 
					thePlayer.HasTag('acs_igni_sword_equipped_TAG') 
					|| thePlayer.HasTag('acs_igni_sword_equipped') 
					|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG') 
					|| thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
					)
					{
						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						|| npc.HasTag('ACS_Big_Boi')
						|| npc.HasAbility('mon_troll_base')
						|| npc.HasTag('ACS_Giant_Troll')
						|| npc.HasTag('ACS_Bullvore')
						|| npc.HasAbility('NPC Leather Armor') 
						|| npc.HasAbility('NPC Heavy Leather Armor') 
						|| npc.HasAbility('NPC Chainmail Armor') 
						|| npc.HasAbility('NPC Partial Plate Armor') 
						|| npc.HasAbility('NPC Full Plate Armor') 
						|| npc.HasAbility('NPC_Wild_Hunt_Armor')
						|| StrContains(npc.GetReadableName(), "armor" )
						|| ((CNewNPC)npc).IsShielded(thePlayer)
						|| npc.HasTag('ACS_Swapped_To_Shield') 
						|| npc.GetMovingAgentComponent().GetName() == "wild_hunt_base"
						|| CalculateAttributeValue(((CActor)npc).GetTotalArmor()) > 0
						)
						{
							if (GetACSWatcher().silver_strong_stance || GetACSWatcher().steel_strong_stance) 
							{
								action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.75;

								action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.75;

								action.SetCriticalHit();
							}

							if (GetACSWatcher().silver_group_stance || GetACSWatcher().steel_group_stance) 
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;

								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
							}

							if (GetACSWatcher().silver_fast_stance || GetACSWatcher().steel_fast_stance) 
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;

								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
							}
						}

						if (ACS_PlayerSurroundedCheck())
						{
							if (GetACSWatcher().silver_group_stance || GetACSWatcher().steel_group_stance) 
							{
								action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.5;

								action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.5;

								action.SetCriticalHit();
							}
						}

						if (GetACSWatcher().silver_strong_stance || GetACSWatcher().steel_strong_stance) 
						{
							action.SetIgnoreArmor(true);

							action.SetEndsQuen(true);
						}
					}

					if ((npc.HasTag('ACS_Counter_Wound_Ready') && ((CNewNPC)npc).acs_wound_fx && ((CNewNPC)npc).acs_posture == ((CNewNPC)npc).acs_max_posture)
					|| npc.HasTag('ACS_Wraith_Finisher_Marked'))
					{
						if (!thePlayer.HasTag('ACS_IsPerformingFinisher')
						&& !thePlayer.HasTag('ACS_IsPerformingCombatDismember'))
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.125;

							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.125;

							action.SetIgnoreArmor(true);

							action.SetEndsQuen(true);
						}
					}

					if (thePlayer.HasTag('ACS_Neutral_Flip')
					)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.99;

						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.99;
					}
				}
			}
			else
			{
				if (!((CNewNPC)npc).IsShielded(thePlayer))
				{
					npc.GainStat(BCS_Stamina, npc.GetStatMax(BCS_Stamina) * 0.25f);
				}
			}
		}

		npc.SignalGameplayEvent('FinishQuen');
	}


	if (npc
	&& npcAttacker 
	)
	{
		if (npc.IsHuman())
		{
			if (!npc.HasAbility('IsNotScaredOfMonsters'))
			{
				return;
			}
		}

		if (npcAttacker == GetWitcherPlayer())
		{
			if (GetAttitudeBetween(npc, playerAttacker) == AIA_Hostile)
			{
				npc.SignalGameplayEventParamObject( 'ForceTarget', playerAttacker );
			}
		}
		else
		{
			if (npc.IsMonster()
			&& npcAttacker.IsHuman()
			)
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.95;
				}
			}

			if (!((CNewNPC)npc).IsFlying())
			{
				if (action.IsActionMelee())
				{
					npc.SignalGameplayEventParamObject( 'ForceTarget', npcAttacker );
				}
				else
				{
					if (RandF() < 0.125)
					{
						npc.SignalGameplayEventParamObject( 'ForceTarget', npcAttacker );
					}
				}
			}
		}
	}
}

function ACSCreateFeainneweddVFX( npc : CActor, pos : Vector )
{
	var signIconEnt				: CEntity;

	pos.Z += 1.5;

	signIconEnt = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\sign_icons.w2ent", true ), pos );
	signIconEnt.DestroyAfter(1.5);

	signIconEnt.PlayEffect('critical_yrden');

	signIconEnt.PlayEffect('mutation_2_yrden');
}

function ACS_Sign_Combo_System(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var ent 																														: CEntity;
	var attach_rot                        																							: EulerAngles;
	var attach_vec																													: Vector;
	var chance 																														: float;
	var iconPath																													: string;
	var boneIndex 																													: int;
	var bPos																														: Vector;
	var bRot 																														: EulerAngles;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if ( !ACS_SignComboSystem_Enabled() )
	{
		return;
	}

	if ( FactsQuerySum("acs_transformation_activated") > 0 )
	{
		return;
	}

	if ( thePlayer.IsInFistFightMiniGame() )
	{
		return;
	}

	if ( !thePlayer.IsActionAllowed(EIAB_Signs) )
	{
		return;
	}

	if ( GetWitcherPlayer().IsGuarded()
	|| GetWitcherPlayer().IsInGuardedState()
	)
	{
		return;
	}

	if (thePlayer.IsWeaponHeld('fist'))
	{
		return;
	}

	if (!playerAttacker)
	{
		return;
	}

	if (GetAttitudeBetween( playerAttacker, npc ) != AIA_Hostile)
	{
		return;
	}

	GetACSWatcher().RemoveTimer('RemoveSignComboStuffRepeating');
	GetACSWatcher().RemoveTimer('RemoveSignComboStuff');
	GetACSWatcher().AddTimer('RemoveSignComboStuff', 20 , false );

	if (!npc.HasTag('ACS_Sign_Combo_Attack_1')
	&& !npc.HasTag('ACS_Sign_Combo_Attack_2')
	&& !npc.HasTag('ACS_Sign_Combo_Igni_Ready')
	&& !npc.HasTag('ACS_Sign_Combo_Aard_Ready')
	)
	{
		npc.AddTag('ACS_Sign_Combo_Attack_1');
	}
	else if (npc.HasTag('ACS_Sign_Combo_Attack_1')
	&& !npc.HasTag('ACS_Sign_Combo_Attack_2')
	&& !npc.HasTag('ACS_Sign_Combo_Igni_Ready')
	&& !npc.HasTag('ACS_Sign_Combo_Aard_Ready')
	)
	{
		npc.AddTag('ACS_Sign_Combo_Attack_2');
	} 
	else if (npc.HasTag('ACS_Sign_Combo_Attack_1')
	&& npc.HasTag('ACS_Sign_Combo_Attack_2')
	&& !npc.HasTag('ACS_Sign_Combo_Igni_Ready')
	&& !npc.HasTag('ACS_Sign_Combo_Aard_Ready')
	)
	{
		ACS_Tutorial_Display_Check('ACS_Sign_Combo_System_Tutorial_Shown');

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\sign_icons.w2ent"

		, true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

		if ( npc.GetBoneIndex('pelvis') != -1 )
		{
			boneIndex = npc.GetBoneIndex( 'pelvis' );	
			npc.GetBoneWorldPositionAndRotationByIndex( boneIndex, bPos, bRot );

			ent.CreateAttachmentAtBoneWS(npc, 'pelvis', bPos, bRot);
		}
		else
		{
			if ( npc.GetBoneIndex('k_pelvis_g') != -1 )
			{
				boneIndex = npc.GetBoneIndex( 'k_pelvis_g' );	
				npc.GetBoneWorldPositionAndRotationByIndex( boneIndex, bPos, bRot );

				ent.CreateAttachmentAtBoneWS(npc, 'k_pelvis_g', bPos, bRot);
			}
			else
			{
				ent.CreateAttachment(npc, , Vector(0,0,1.5), npc.GetWorldRotation());
			}
		}

		if ( GetWitcherPlayer().GetEquippedSign() == ST_Igni)
		{
			chance = 0.45;
		}
		else if ( GetWitcherPlayer().GetEquippedSign() == ST_Aard)
		{
			chance = 0.55;
		}
		else
		{
			chance = 0.5;
		}

		if ( 
		ACS_GetItem_Sword_IsEquipped('eredin_steel', 'steel')
		|| ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel')
		|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel')
		)
		{
			iconPath = "<img src='img://" + "icons/inventory/acs_aard_icon_oneliner_sign_combo.xbm" + "' vspace='" + (1) + "' />&nbsp;";

			ent.AddTag('ACS_Sign_Combo_Aard_Symbol_Active');

			npc.AddTag('ACS_Sign_Combo_Aard_Ready');
		}
		else
		{
			if (RandF() < chance)
			{
				//ent.PlayEffectSingle('igni_icon_small');

				iconPath = "<img src='img://" + "icons/inventory/acs_igni_icon_oneliner_sign_combo.xbm" + "' vspace='" + (1) + "' />&nbsp;";

				ent.AddTag('ACS_Sign_Combo_Igni_Symbol_Active');

				npc.AddTag('ACS_Sign_Combo_Igni_Ready');
			}
			else
			{
				//ent.PlayEffectSingle('aard_icon_small');

				iconPath = "<img src='img://" + "icons/inventory/acs_aard_icon_oneliner_sign_combo.xbm" + "' vspace='" + (1) + "' />&nbsp;";

				ent.AddTag('ACS_Sign_Combo_Aard_Symbol_Active');

				npc.AddTag('ACS_Sign_Combo_Aard_Ready');
			}
		}

		ACS_Oneliner(iconPath, ent, "ACS_Sign_Combo_Indicator", Vector(0,0,-0.075));

		GetACSStorage().acs_setScaleForOnelinerByTag("ACS_Sign_Combo_Indicator", 50, 50, 50);

		GetACSStorage().acs_setAlphaForOnelinerByTag("ACS_Sign_Combo_Indicator", 50);

		ent.AddTag('ACS_Sign_Combo_Icon');
	}
}

/*
function ACSSignComboNPCAliveCheck() : bool
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( 'ACS_Sign_Combo_Attack_1', actors );	

	if (actors.Size() <= 0)
	{
		return false;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		if (!actors[i].IsAlive())
		{
			return false;
		}
	}

	return true;
}
*/

function ACSSignComboIconCheck()
{	
	var ents 											: array<CEntity>;
	var i												: int;

	var actors_igni 									: array<CActor>;
	var j												: int;

	var actors_aard 									: array<CActor>;
	var k												: int;

	var iconPath										: string;

	if ( !ACS_SignComboSystem_Enabled() )
	{
		return;
	}
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Sign_Combo_Icon', ents );	

	if (ents.Size() <= 0)
	{
		return;
	}

	if (ACS_can_activate_sign_combo_system())
	{
		ACS_refresh_sign_combo_system_cooldown();

		for( i = 0; i < ents.Size(); i += 1 )
		{
			if (!ents[i].HasTag('ACS_Sign_Combo_Icon_Ready_To_Activate'))
			{
				if (ents[i].HasTag('ACS_Sign_Combo_Igni_Symbol_Active'))
				{
					iconPath = "<img src='img://" + "icons/inventory/acs_igni_icon_oneliner_activated.xbm" + "' vspace='" + (1) + "' />&nbsp;";

					//ents[i].PlayEffectSingle('igni_icon');

					//ents[i].PlayEffectSingle('critical_igni');
				}
				else if (ents[i].HasTag('ACS_Sign_Combo_Aard_Symbol_Active'))
				{
					iconPath = "<img src='img://" + "icons/inventory/acs_aard_icon_oneliner_activated.xbm" + "' vspace='" + (1) + "' />&nbsp;";

					//ents[i].PlayEffectSingle('aard_icon');

					//ents[i].PlayEffectSingle('critical_aard');
				}

				ACS_Oneliner(iconPath, ents[i], "ACS_Sign_Combo_Indicator", Vector(0,0,-0.075));

				GetACSStorage().acs_setScaleForOnelinerByTag("ACS_Sign_Combo_Indicator", 50, 50, 50);

				GetACSStorage().acs_setAlphaForOnelinerByTag("ACS_Sign_Combo_Indicator", 75);

				ents[i].AddTag('ACS_Sign_Combo_Icon_Ready_To_Activate');
			}
		}

		actors_igni.Clear();

		theGame.GetActorsByTag( 'ACS_Sign_Combo_Igni_Ready', actors_igni );	

		for( j = 0; j < actors_igni.Size(); j += 1 )
		{
			actors_igni[j].AddTag('ACS_Sign_Combo_Icon_Ready_To_Activate_NPC_Igni');
		}


		actors_aard.Clear();

		theGame.GetActorsByTag( 'ACS_Sign_Combo_Aard_Ready', actors_aard );	

		for( k = 0; k < actors_aard.Size(); k += 1 )
		{
			actors_aard[k].AddTag('ACS_Sign_Combo_Icon_Ready_To_Activate_NPC_Aard');
		}
	}
}

function ACSSignComboSystemRemoveTags()
{
	var actors_igni 									: array<CActor>;
	var j												: int;

	actors_igni.Clear();

	theGame.GetActorsByTag( 'ACS_Sign_Combo_Attack_1', actors_igni );	

	if (actors_igni.Size() <= 0)
	{
		return;
	}

	for( j = 0; j < actors_igni.Size(); j += 1 )
	{
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Attack_1');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Attack_2');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Igni_Ready');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Aard_Ready');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Icon_Ready_To_Activate_NPC_Igni');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Icon_Ready_To_Activate_NPC_Aard');
	}

	GetACSStorage().acs_deleteOnelinerByTag("ACS_Sign_Combo_Indicator");
}

function ACS_KillCount_Manager( npc : CActor )
{
	if (npc.GetMovingAgentComponent().GetName() == "woman_base"
	|| npc.GetMovingAgentComponent().GetName() == "man_base"
	)
	{
		GetACSStorage().acs_Killcount_Increment('human');
	}
	else
	{
		if 
		(
			npc.HasAbility('mon_boar_base')
			|| npc.HasAbility('mon_bear_base')
			|| npc.GetSfxTag() == 'sfx_wild_dog'
			|| npc.GetSfxTag() == 'sfx_wolf'
			|| npc.GetSfxTag() == 'sfx_bear'
			|| npc.HasAbility('mon_panther_base')
			|| npc.HasAbility('mon_q704_ft_pigs_evil')
			|| npc.HasAbility('mon_boar_ep2_base')
		)
		{
			GetACSStorage().acs_Killcount_Increment('beast');
		}
		else if 
		(
			npc.HasAbility('mon_lycanthrope')
			|| npc.GetSfxTag() == 'sfx_werewolf'
			|| npc.HasAbility('mon_archespor_base')
			|| npc.HasAbility('mon_q704_ft_wilk')
		)
		{
			GetACSStorage().acs_Killcount_Increment('cursed_one');
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_cockatrice'
			|| npc.HasAbility('mon_basilisk')
			|| npc.HasAbility('mon_forktail_young')
			|| npc.HasAbility('mon_forktail')
			|| npc.HasAbility('mon_forktail_mh')
			|| npc.GetSfxTag() == 'sfx_wyvern'
			|| npc.HasAbility('mon_mq7010_dracolizard')
			|| npc.HasAbility('mon_draco_base')
			|| npc.HasAbility('mon_mq7018_basilisk')
			|| npc.HasAbility('mon_basilisk')
		)
		{
			GetACSStorage().acs_Killcount_Increment('draconid');
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_elemental_dao' 	
			|| npc.GetSfxTag() == 'sfx_golem'
			|| npc.GetSfxTag() == 'sfx_elemental_ifryt'
			|| npc.GetSfxTag() == 'sfx_wildhunt_minion'
			|| npc.HasAbility('mon_ice_golem')
			|| npc.HasAbility('mon_gargoyle')
			|| npc.HasAbility('mon_dark_pixie_base')
			|| npc.HasAbility('mon_q704_ft_pixies')
			|| npc.HasAbility('mon_graveir')
			|| npc.HasAbility('mon_dark_pixie_base')
		)
		{
			GetACSStorage().acs_Killcount_Increment('elementa');
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_gryphon'
			|| npc.HasAbility('mon_erynia')
			|| npc.GetSfxTag() == 'sfx_harpy'
			|| npc.HasAbility('mon_erynia')
			|| npc.GetSfxTag() == 'sfx_siren'
			|| npc.HasAbility('mon_erynia')
		)
		{
			GetACSStorage().acs_Killcount_Increment('hybrid');
		}
		else if 
		(
			npc.HasAbility('mon_arachas_base')
			|| npc.HasAbility('mon_poison_arachas')
			|| npc.HasAbility('mon_black_spider_base')
			|| npc.GetSfxTag() == 'sfx_arachas'
			|| npc.GetSfxTag() == 'sfx_endriaga'
			|| npc.HasAbility('mon_endriaga_soldier_tailed')
			|| npc.HasAbility('mon_endriaga_worker')
			|| npc.HasTag('mq7023_pale_widow')
			|| npc.HasAbility('mon_scolopendromorph_base')
			|| npc.HasAbility('mon_kikimora_warrior')
			|| npc.HasAbility('mon_kikimora_worker')
			|| npc.HasAbility('mon_black_spider_ep2_base')
		)
		{
			GetACSStorage().acs_Killcount_Increment('insectoid');
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_alghoul' 
			|| npc.HasAbility('mon_greater_miscreant')
			|| npc.GetSfxTag() == 'sfx_drowner'
			|| npc.GetSfxTag() == 'sfx_fogling'
			|| npc.GetSfxTag() == 'sfx_gravehag'
			|| npc.GetSfxTag() == 'sfx_waterhag'
			|| npc.HasAbility('mon_rotfiend')
			|| npc.HasAbility('mon_rotfiend_large')
			|| npc.HasAbility('mon_gravier')
			|| npc.HasAbility('mon_wight')
			|| npc.HasAbility('mon_ghoul_lesser')
			|| npc.HasAbility('mon_ghoul')
			|| npc.HasAbility('mon_ghoul_stronger')
			|| npc.HasAbility('mon_EP2_ghouls')
			|| npc.HasAbility('ghoul_hardcore')
		)
		{
			GetACSStorage().acs_Killcount_Increment('necrophage');
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_ice_giant'
			|| npc.GetSfxTag() == 'sfx_nekker'
			|| npc.HasTag('ice_troll')
			|| npc.GetSfxTag() == 'sfx_troll_cave'
			|| npc.HasAbility('mon_cyclops')
			|| npc.HasAbility('mon_knight_giant')
			|| npc.HasAbility('mon_cloud_giant')
		)
		{
			GetACSStorage().acs_Killcount_Increment('ogroid');
		}
		else if 
		(
			npc.HasAbility('mon_toad_base')
			|| npc.HasAbility('q604_caretaker')
			|| npc.HasAbility('mon_czart')
			|| npc.GetSfxTag() == 'sfx_bies'
			|| npc.GetSfxTag() == 'sfx_lessog'
			|| npc.HasAbility('mon_sprigan')
			|| npc.HasAbility('mon_sharley_base')
			|| npc.HasAbility('mon_fairytale_witch')
			|| npc.HasTag('witch')
		)
		{
			GetACSStorage().acs_Killcount_Increment('relict');
		}
		else if 
		(
			npc.HasAbility('mon_nightwraith_iris')
			|| npc.HasAbility('mon_nightwraith')
			|| npc.HasAbility('mon_nightwraith_mh')
			|| npc.HasAbility('mon_noonwraith')
			|| npc.HasAbility('mon_noonwraith_doppelganger')
			|| npc.GetSfxTag() == 'sfx_wraith'
			|| npc.HasAbility('mon_panther_ghost')
			|| npc.HasAbility('mon_barghest_base')
			|| npc.HasAbility('banshee_rapunzel')
			|| npc.HasAbility('mon_nightwraith_banshee')
			|| npc.HasAbility('banshee_rapunzel')
		)
		{
			GetACSStorage().acs_Killcount_Increment('spectre');
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_katakan'
			|| npc.HasAbility('mon_ekimma')
			|| npc.HasAbility('mon_garkain')
			|| npc.HasAbility('mon_bruxa')
			|| npc.HasAbility('mon_fleder')
			|| npc.HasAbility('q704_mon_protofleder')
			|| npc.HasAbility('mon_alp')
			|| npc.HasTag('dettlaff_vampire')
		)
		{
			GetACSStorage().acs_Killcount_Increment('vampire');
		}
		else 
		{
			GetACSStorage().acs_Killcount_Increment('other');
		}
	}
}

function ACS_Enemy_On_Take_Damage_01(action: W3DamageAction)
{
	var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var caranthir_hit_anim_names, anim_names, hit_anim_names																		: array< name >;
	var spawnPos, newSpawnPos																										: Vector;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var droppeditemID 																												: SItemUniqueId;
	var h 																															: float;		
	var l_comp 																														: array< CComponent >;
	var size, j  																													: int;
	var params 																														: SCustomEffectParams;
	var miniHymSize, miniHymSpeed																									: float;
	var ent																															: CACSMonsterSpawner;
	var vACS_Forest_God_Spawner 																									: cACS_Forest_God_Spawner;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	animcomp = (CAnimatedComponent)npc.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npc.GetComponentByClassName('CMeshComponent');

	if 
	(npc)
	{
		if (
		npc.HasTag('ACS_Swapped_To_Shield')
		|| npc.HasTag('ACS_Swapped_To_Vampire')
		|| npc.HasTag('ACS_In_Rage')
		)
		{
			if (npc.UsesVitality())
			{
				if( thePlayer.IsDoingSpecialAttack(false))
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
				}
				else
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}
			}
			else if (npc.UsesEssence())
			{
				if( thePlayer.IsDoingSpecialAttack(false))
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
				}
				else
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
				}
			}

			if ( !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );

				if (npc.HasTag('ACS_Swapped_To_Shield'))
				{
					theSound.SoundEvent("shield_wood_impact");

					theSound.SoundEvent("grunt_vo_block");
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Forest_God'))
		{
			if ( playerAttacker )
			{
				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}
				}

				if ( (npc.GetStat(BCS_Essence) <= npc.GetStatMax(BCS_Essence) * 0.5)
				&& !npc.HasTag('ACS_Spawn_Adds_1'))
				{
					vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;

					vACS_Forest_God_Spawner.ACS_Forest_God_Adds_1_Spawner_Engage();

					GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449961) );

					npc.AddTag('ACS_Spawn_Adds_1');
				}
				else if ( (npc.GetStat(BCS_Essence) <= npc.GetStatMax(BCS_Essence) * 0.25 )
				&& !npc.HasTag('ACS_Spawn_Adds_2'))
				{
					vACS_Forest_God_Spawner = new cACS_Forest_God_Spawner in theGame;

					vACS_Forest_God_Spawner.ACS_Forest_God_Adds_2_Spawner_Engage();

					GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449962) );

					npc.AddTag('ACS_Spawn_Adds_2');
				} 
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Harpy_Queen'))
		{
			if (playerAttacker)
			{
				npc.SetCanPlayHitAnim(false);

				((CNewNPC)npc).SetUnstoppable( true );

				npc.SignalGameplayEvent('DisableFinisher');

				((CActor)npc).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

				((CActor)npc).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
					}

					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

					movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Harpy_Praetorian'))
		{
			if (playerAttacker)
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
						}
					}

					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

					movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Nekker_Guardian'))
		{
			if (!action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}
				}

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );

				theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

				theSound.SoundEvent("monster_bies_vo_pain_normal");
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Phooca'))
		{
			if (!action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
				}

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
				
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Plumard'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.HasTag('ACS_Plumard_Elder'))
					{

					}
					else
					{
						if (FactsQuerySum("ACS_Darkness_Upon_Us") > 0)
						{

							if (!npc.HasAbility('Flashstep'))
							{
								npc.AddAbility('Flashstep');
							}
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Ungoliant_Spawn'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += npc.GetMaxHealth();
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += npc.GetMaxHealth();
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Nekurat'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (FactsQuerySum("ACS_Darkness_Upon_Us") > 0)
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
						}
					}
					else
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.025;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.025;
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_She_Who_Knows'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
					}

					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

					movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );

					theSound.SoundEvent("monster_bies_vo_pain_normal");
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(
		(
		//npc.HasAbility('WildHunt_Eredin')//|| 
		npc.HasAbility('WildHunt_Imlerith')
		)
		)
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Night_Stalker'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

					movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );

					ACSGetCActor('ACS_Night_Stalker').SetTatgetableByPlayer(true);
					
					if (ACSGetCActor('ACS_Night_Stalker').IsEffectActive('predator_mode', false))
					{
						npc.SetCanPlayHitAnim(true); 
						ACSGetCActor('ACS_Night_Stalker').DestroyEffect('predator_mode');

						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
							}
						}
					}
					else
					{
						npc.SetCanPlayHitAnim(false); 

						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
						}
					}

					ACSGetCActor('ACS_Night_Stalker').DestroyEffect('glow');
					ACSGetCActor('ACS_Night_Stalker').PlayEffectSingle('glow');

					if (!ACSGetCActor('ACS_Night_Stalker').IsEffectActive('demonic_possession', false))
					{
						ACSGetCActor('ACS_Night_Stalker').PlayEffectSingle('demonic_possession');
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Xeno_Tyrant'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					npc.SetCanPlayHitAnim(false); 

					if (ACSGetCActor('ACS_Xeno_Tyrant').HasAbility('mon_kikimore_small'))
					{
						ACSGetCActor('ACS_Xeno_Tyrant').RemoveAbility('mon_kikimore_small');
					}
					else
					{
						ACSGetCActor('ACS_Xeno_Tyrant').AddAbility('mon_kikimore_small');
					}

					if (ACS_ActionDealsDamageType(action, 'fire')
					|| action.HasBuff(EET_Burning))
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 5;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage += action.processedDmg.vitalityDamage * 5;
						}

						action.SetCriticalHit();

						if (!npc.HasBuff(EET_Burning))
						{
							params.effectType = EET_Burning;
							params.creator = playerAttacker;
							params.sourceName = "ACS_Xeno_Swarm_Fire_Damage";
							params.duration = 2.5;

							npc.AddEffectCustom( params );		
						}
					}
					else
					{
						if (npc.HasBuff(EET_Burning))
						{
							if (npc.UsesVitality())
							{
								if( thePlayer.IsDoingSpecialAttack(false))
								{
									action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.0125;
								}
								else
								{
									action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.025;
								}
							}
							else if (npc.UsesEssence())
							{
								if( thePlayer.IsDoingSpecialAttack(false))
								{
									action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.0125;
								}
								else
								{
									action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.025;
								}
							}
						}
						else
						{
							if (npc.UsesVitality())
							{
								if( thePlayer.IsDoingSpecialAttack(false))
								{
									action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
								}
								else
								{
									action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
								}
							}
							else if (npc.UsesEssence())
							{
								if( thePlayer.IsDoingSpecialAttack(false))
								{
									action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
								}
								else
								{
									action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
								}
							}
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Xeno_Soldiers'))
		{
			if (!action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (npc.HasAbility('mon_kikimore_small'))
				{
					if (npc.HasAbility('Burrow'))
					{
						npc.RemoveAbility('Burrow');
					}

					if (npc.HasAbility('mon_kikimora_worker'))
					{
						npc.RemoveAbility('mon_kikimora_worker');
					}

					if (!npc.HasAbility('mon_kikimore_big'))
					{
						npc.AddAbility('mon_kikimore_big');
					}

					if (!npc.HasAbility('mon_kikimora_warrior'))
					{
						npc.AddAbility('mon_kikimora_warrior');
					}

					npc.RemoveAbility('mon_kikimore_small');
				}
				else
				{
					if (!npc.HasAbility('Burrow'))
					{
						npc.AddAbility('Burrow');
					}

					if (!npc.HasAbility('mon_kikimora_worker'))
					{
						npc.AddAbility('mon_kikimora_worker');
					}

					if (npc.HasAbility('mon_kikimore_big'))
					{
						npc.RemoveAbility('mon_kikimore_big');
					}

					if (npc.HasAbility('mon_kikimora_warrior'))
					{
						npc.RemoveAbility('mon_kikimora_warrior');
					}

					npc.AddAbility('mon_kikimore_small');
				}

				if (ACS_ActionDealsDamageType(action, 'fire')
				|| action.HasBuff(EET_Burning))
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 5;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += action.processedDmg.vitalityDamage * 5;
					}

					action.SetCriticalHit();

					if (!npc.HasBuff(EET_Burning))
					{
						params.effectType = EET_Burning;
						params.creator = playerAttacker;
						params.sourceName = "ACS_Xeno_Swarm_Fire_Damage";
						params.duration = 5;

						npc.AddEffectCustom( params );		
					}
				}
				else
				{
					if (npc.HasBuff(EET_Burning))
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.0125;
							}
							else
							{
								action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.025;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.0125;
							}
							else
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.025;
							}
						}
					}
					else
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Xeno_Armored_Workers'))
		{
			if (!action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (RandF() < 0.5)
				{
					if (RandF() < 0.5)
					{
						if (!npc.HasAbility('Venom'))
						{
							npc.AddAbility('Venom');
						}

						if (npc.HasAbility('Charge'))
						{
							npc.RemoveAbility('Charge');
						}

						if (npc.HasAbility('Block'))
						{
							npc.RemoveAbility('Block');
						}

						if (npc.HasAbility('Spikes'))
						{
							npc.RemoveAbility('Spikes');
						}
					}
					else
					{
						if (!npc.HasAbility('Charge'))
						{
							npc.AddAbility('Charge');
						}

						if (npc.HasAbility('Venom'))
						{
							npc.RemoveAbility('Venom');
						}

						if (npc.HasAbility('Block'))
						{
							npc.RemoveAbility('Block');
						}

						if (npc.HasAbility('Spikes'))
						{
							npc.RemoveAbility('Spikes');
						}
					}
				}
				else
				{
					if (RandF() < 0.5)
					{
						if (!npc.HasAbility('Block'))
						{
							npc.AddAbility('Block');
						}

						if (npc.HasAbility('Charge'))
						{
							npc.RemoveAbility('Charge');
						}

						if (npc.HasAbility('Venom'))
						{
							npc.RemoveAbility('Venom');
						}

						if (npc.HasAbility('Spikes'))
						{
							npc.RemoveAbility('Spikes');
						}
					}
					else
					{
						if (!npc.HasAbility('Spikes'))
						{
							npc.AddAbility('Spikes');
						}

						if (npc.HasAbility('Charge'))
						{
							npc.RemoveAbility('Charge');
						}

						if (npc.HasAbility('Block'))
						{
							npc.RemoveAbility('Block');
						}

						if (npc.HasAbility('Venom'))
						{
							npc.RemoveAbility('Venom');
						}
					}
				}

				if (ACS_ActionDealsDamageType(action, 'fire')
				|| action.HasBuff(EET_Burning))
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 5;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += action.processedDmg.vitalityDamage * 5;
					}

					action.SetCriticalHit();

					if (!npc.HasBuff(EET_Burning))
					{
						params.effectType = EET_Burning;
						params.creator = playerAttacker;
						params.sourceName = "ACS_Xeno_Swarm_Fire_Damage";
						params.duration = 5;

						npc.AddEffectCustom( params );		
					}
				}
				else
				{
					if (npc.HasBuff(EET_Burning))
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.0125;
							}
							else
							{
								action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.025;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.0125;
							}
							else
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.025;
							}
						}
					}
					else
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Fire_Bear'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (ACSGetCActor('ACS_Fire_Bear').IsEffectActive('flames', false))
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
					}
					else
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
					}

					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 100 );

					movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );

					theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

					theSound.SoundEvent("monster_bies_vo_pain_normal");
				}	
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

	}
}

function ACS_Enemy_On_Take_Damage_02(action: W3DamageAction)
{
	var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var caranthir_hit_anim_names, anim_names, hit_anim_names																		: array< name >;
	var spawnPos, newSpawnPos																										: Vector;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var droppeditemID 																												: SItemUniqueId;
	var h 																															: float;		
	var l_comp 																														: array< CComponent >;
	var size, j  																													: int;
	var params 																														: SCustomEffectParams;
	var miniHymSize, miniHymSpeed																									: float;
	var ent																															: CACSMonsterSpawner;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	animcomp = (CAnimatedComponent)npc.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npc.GetComponentByClassName('CMeshComponent');

	if 
	(npc)
	{
		if 
		(npc.HasTag('ACS_Ice_Titan'))
		{
			if 
			(playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}

					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 100 );

					movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );

					theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

					theSound.SoundEvent("monster_bies_vo_pain_normal");
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Knightmare_Eternum'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if(RandF() < 0.5)
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.99;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.99;
						}

						ACSGetCEntity('ACS_knightmare_quen_hit').StopEffect('discharge');
						ACSGetCEntity('ACS_knightmare_quen_hit').PlayEffectSingle('discharge');

						ACSGetCEntity('ACS_knightmare_quen').PlayEffectSingle('default_fx');
						ACSGetCEntity('ACS_knightmare_quen').StopEffect('default_fx');
					}
					else
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
						}
					}
					
					ACSGetCEntity('ACS_knightmare_quen_hit').StopEffect('quen_rebound_sphere_bear_abl2');
					//ACSGetCEntity('ACS_knightmare_quen_hit').PlayEffectSingle('quen_rebound_sphere_bear_abl2');

					ACSGetCEntity('ACS_knightmare_quen_hit').StopEffect('quen_rebound_sphere_bear_abl2_copy');
					//ACSGetCEntity('ACS_knightmare_quen_hit').PlayEffectSingle('quen_rebound_sphere_bear_abl2_copy');

					ACSGetCEntity('ACS_knightmare_quen_hit').StopEffect('quen_impulse_explode');
					//ACSGetCEntity('ACS_knightmare_quen').PlayEffectSingle('quen_impulse_explode');
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Blade_Of_The_Unseen'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if (GetACSStorage().unseen_blade_death_count == 0)
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
						}
						else if (GetACSStorage().unseen_blade_death_count == 1)
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
						else if (GetACSStorage().unseen_blade_death_count == 2)
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
					}
					else if (npc.UsesEssence())
					{
						if (GetACSStorage().unseen_blade_death_count == 0)
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
						}
						else if (GetACSStorage().unseen_blade_death_count == 1)
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
						else if (GetACSStorage().unseen_blade_death_count == 2)
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Big_Lizard'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if ( npc.HasTag('ACS_Big_Lizard'))
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
							}
						}

						if (!((CNewNPC)npc).IsFlying()
						&& npc.IsOnGround())
						{
							ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
							movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
							movementAdjustorNPC.CancelAll();

							ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
							movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
							movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

							movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
						}

						theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

						theSound.SoundEvent("monster_bies_vo_pain_normal");
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Rat_Mage'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if(RandF() < 0.5)
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.99;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.99;
						}

						ACSGetCEntity('ACS_rat_mage_quen_hit').StopEffect('discharge');
						ACSGetCEntity('ACS_rat_mage_quen_hit').PlayEffectSingle('discharge');

						ACSGetCEntity('ACS_rat_mage_quen').PlayEffectSingle('default_fx');
						ACSGetCEntity('ACS_rat_mage_quen').StopEffect('default_fx');
					}
					else
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
						}
					}
					
					ACSGetCEntity('ACS_rat_mage_quen_hit').StopEffect('quen_rebound_sphere_bear_abl2');

					ACSGetCEntity('ACS_rat_mage_quen_hit').StopEffect('quen_rebound_sphere_bear_abl2_copy');

					ACSGetCEntity('ACS_rat_mage_quen_hit').StopEffect('quen_impulse_explode');
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Canaris'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				////&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					GetACSCanarisIceSpearSingle().BreakAttachment();
					GetACSCanarisIceSpearSingle().Destroy();

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spear_Single_Fire_Delay_1');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spear_Single_Fire_Delay_2');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spear_Single_Fire_Delay_3');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Summon_Golem_Delay');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Meteorite_Storm_Delay');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spike_Delay_1');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spike_Delay_2');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spike_Delay_3');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Spear_Summon_Delay');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Line_Single_Fire_Delay_1');

					GetACSWatcher().RemoveTimer('ACS_Caranthir_Ice_Line_Single_Fire_Delay_2');

					caranthir_hit_anim_names.Clear();

					if (RandF() < 0.5)
					{
						caranthir_hit_anim_names.PushBack('hit_up_02');
						caranthir_hit_anim_names.PushBack('hit_up_01');
						caranthir_hit_anim_names.PushBack('hit_left_down');
						caranthir_hit_anim_names.PushBack('hit_left_up');
						caranthir_hit_anim_names.PushBack('hit_left_02');
						caranthir_hit_anim_names.PushBack('hit_right_down');
						caranthir_hit_anim_names.PushBack('hit_right_up');
						caranthir_hit_anim_names.PushBack('hit_right_02');
						caranthir_hit_anim_names.PushBack('hit_down_02');
						//caranthir_hit_anim_names.PushBack('hit_back_fall_01');
						//caranthir_hit_anim_names.PushBack('hit_back_fall_02');

						if( ACSGetCActor('ACS_Canaris').IsAlive()) {ACSGetCActor('ACS_Canaris').ACS_ClearAnimationSpeedMultipliers();}	

						ACSGetCActor('ACS_Canaris').ACS_SetAnimationSpeedMultiplier( 1.5  );
																			
						GetACSWatcher().RemoveTimer('ACS_Caranthir_ResetAnimation'); 
						GetACSWatcher().AddTimer('ACS_Caranthir_ResetAnimation', 0.5   , false );

						animatedComponentA.PlaySlotAnimationAsync ( caranthir_hit_anim_names[RandRange(caranthir_hit_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
					}
					else
					{
						caranthir_hit_anim_names.PushBack('hit_back_fall_01');
						caranthir_hit_anim_names.PushBack('hit_back_fall_02');

						if( ACSGetCActor('ACS_Canaris').IsAlive()) {ACSGetCActor('ACS_Canaris').ACS_ClearAnimationSpeedMultipliers();}	

						ACSGetCActor('ACS_Canaris').ACS_SetAnimationSpeedMultiplier( 1.5  );
																			
						GetACSWatcher().RemoveTimer('ACS_Caranthir_ResetAnimation'); 
						GetACSWatcher().AddTimer('ACS_Caranthir_ResetAnimation', 0.5   , false );

						animatedComponentA.PlaySlotAnimationAsync ( caranthir_hit_anim_names[RandRange(caranthir_hit_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));

						ACSGetCActor('ACS_Canaris').DestroyEffect('teleport_short');
						ACSGetCActor('ACS_Canaris').PlayEffectSingle('teleport_short');
						ACSGetCActor('ACS_Canaris').StopEffect('teleport_short');

						ACSGetCActor('ACS_Canaris').DestroyEffect('ice_armor');
						ACSGetCActor('ACS_Canaris').PlayEffectSingle('ice_armor');

						GetACSWatcher().ACS_Caranthir_Teleport_FX();

						spawnPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 15;

						if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
						{
							theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
							spawnPos = newSpawnPos;
						}

						ACSGetCActor('ACS_Canaris').Teleport(ACSFixZAxis(spawnPos));
					}
					
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Fire_Gargoyle'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}

					if (!((CNewNPC)npc).IsFlying()
					&& npc.IsOnGround())
					{
						ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
						movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
						movementAdjustorNPC.CancelAll();

						ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
						movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
						movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

						movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
					}

					theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

					theSound.SoundEvent("monster_bies_vo_pain_normal");
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Lynx_Witcher'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}

					if (npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.5)
					{
						if (!npc.HasTag('ACS_Lynx_Witcher_1st_Stage'))
						{
							if (!npc.HasTag('ACS_Lynx_Witcher_Stealth'))
							{
								ACS_LynxWitcherSmokeScreen(npc, npc.GetWorldPosition());

								npc.PlayEffectSingle('shadowdash');

								theSound.SoundEvent("bomb_dragons_dream_explo");

								npc.AddTag('ACS_Lynx_Witcher_Stealth');

								GetACSWatcher().AddTimer('LynxWitcherRemoveStealth', 20 , false );
							}

							npc.AddTag('ACS_Lynx_Witcher_1st_Stage');
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Elderblood_Assassin'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (!npc.HasTag('ACS_Elderblood_Assassin_Set_Unstoppable'))
					{
						npc.SetCanPlayHitAnim(false);

						((CNewNPC)npc).SetUnstoppable( true );

						npc.AddTag('ACS_Elderblood_Assassin_Set_Unstoppable');
					}
					else
					{
						npc.SetCanPlayHitAnim(true);

						((CNewNPC)npc).SetUnstoppable( false );

						npc.RemoveTag('ACS_Elderblood_Assassin_Set_Unstoppable');
					}

					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
					}

					if (npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.5)
					{
						if (!npc.HasTag('ACS_Elderblood_Assassin_1st_Stage'))
						{
							if (!npc.HasTag('ACS_Elderblood_Assassin_Stealth'))
							{
								ACS_ElderbloodAssassinSmokeScreen(npc, npc.GetWorldPosition());

								theSound.SoundEvent("bomb_dragons_dream_explo");

								npc.AddTag('ACS_Elderblood_Assassin_Stealth');
							}

							npc.AddTag('ACS_Elderblood_Assassin_1st_Stage');
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Elderblood_Assassin_Clone'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (!npc.HasTag('ACS_Elderblood_Assassin_Clone_Set_Unstoppable'))
					{
						npc.SetCanPlayHitAnim(false);

						((CNewNPC)npc).SetUnstoppable( true );

						npc.AddTag('ACS_Elderblood_Assassin_Clone_Set_Unstoppable');
					}
					else
					{
						npc.SetCanPlayHitAnim(true);

						((CNewNPC)npc).SetUnstoppable( false );

						npc.RemoveTag('ACS_Elderblood_Assassin_Clone_Set_Unstoppable');
					}

					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.125;
					}
					else
					{
						action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.25;
					}
				}
			}

			return;
		}

		if (npc.HasTag('ACS_Shadow_Wolf') || npc.HasTag('ACS_Fluffy_Shadow_Wolf'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.05;
						}
						else
						{
							action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.075;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.05;
						}
						else
						{
							action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.075;
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Fluffy_Shadow_Wolf'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Fluffy'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.05;
						}
						else
						{
							action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.075;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.05;
						}
						else
						{
							action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.075;
						}
					}

					if (!((CNewNPC)npc).IsFlying()
					&& npc.IsOnGround())
					{
						ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
						movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
						movementAdjustorNPC.CancelAll();

						ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
						movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
						movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

						movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
					}

					if (npc.GetCurrentHealth() - action.processedDmg.vitalityDamage < npc.GetMaxHealth() * 0.5
					|| npc.GetCurrentHealth() - action.processedDmg.essenceDamage < npc.GetMaxHealth() * 0.5)
					{
						if (!npc.HasTag('ACS_Fluffy_Summon_Adds'))
						{
							theSound.SoundEvent("animals_wolf_howl");

							theSound.SoundEvent("monster_wild_dog_howl");

							if (ACSGetCActor('ACS_Fluffy') && ACSGetCActor('ACS_Fluffy').IsAlive())
							{
								ACS_FluffyShadowWolfSpawn(npc, npc.GetWorldPosition());
							}

							npc.AddTag('ACS_Fluffy_Summon_Adds');
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Botchling'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					((CNewNPC)npc).SetUnstoppable( true );

					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.025;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.025;
					}

					GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

					theSound.SoundEvent("cmb_play_hit_heavy");

					if (!((CNewNPC)npc).IsFlying()
					&& npc.IsOnGround())
					{
						ticket = movementAdjustorNPC.GetRequest( 'ACS_Botchling_Attacked_Rotate');
						movementAdjustorNPC.CancelByName( 'ACS_Botchling_Attacked_Rotate' );
						movementAdjustorNPC.CancelAll();

						ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_Botchling_Attacked_Rotate' );
						movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
						movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 500 );

						movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
					}

					if (npc.HasTag('ACS_Botchling_Wild'))
					{
						if (npc.GetCurrentHealth() - action.processedDmg.vitalityDamage < npc.GetMaxHealth() * 0.5
						|| npc.GetCurrentHealth() - action.processedDmg.essenceDamage < npc.GetMaxHealth() * 0.5)
						{
							if (!npc.HasTag('ACS_Botchling_Wild_Summon_Adds'))
							{
								if (npc && npc.IsAlive())
								{
									ACSGetCActor('ACS_Botchling').PlayEffect('fx_quest_q103');
									ACSGetCActor('ACS_Botchling').StopEffect('fx_quest_q103');

									ACSGetCActor('ACS_Botchling').PlayEffect('appear_fx');
									ACSGetCActor('ACS_Botchling').PlayEffect('morph_fx');

									ACSGetCActor('ACS_Botchling').StopEffect('appear_fx');
									ACSGetCActor('ACS_Botchling').StopEffect('morph_fx');

									ACS_BotchlingWraithSpawn(npc, npc.GetWorldPosition());
								}

								npc.AddTag('ACS_Botchling_Wild_Summon_Adds');
							}
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Mula'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.025;
						}
						else
						{
							action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.05;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.025;
						}
						else
						{
							action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.05;
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Ice_Boar'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if(RandF() < 0.5)
					{
						ACS_Ice_Boar_Explode(npc, npc.GetWorldPosition());
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Fog_Assassin'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}

					if (!((CNewNPC)npc).IsFlying()
					&& npc.IsOnGround())
					{
						ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
						movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
						movementAdjustorNPC.CancelAll();

						ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
						movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
						movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

						movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Forest_God_Shadows'))
		{
			if (playerAttacker)
			{
				if (!action.WasDodged() 
				////&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.025;
				}
				else
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Nimean_Panther'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					theSound.SoundEvent("monster_golem_cmb_block_ADD");
					theSound.SoundEvent("monster_golem_xtra_block_fx");
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Melusine'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (ACSGetCActor('ACS_Melusine_Cloud').HasAbility('DjinnRage'))
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
						}
					}
					else
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
						}
					}

					if (ACSGetCActor('ACS_Melusine_Bossbar').UsesVitality())
					{
						ACSGetCActor('ACS_Melusine_Bossbar').DrainVitality(action.processedDmg.vitalityDamage);
					}
					else if (ACSGetCActor('ACS_Melusine_Bossbar').UsesEssence())
					{
						ACSGetCActor('ACS_Melusine_Bossbar').DrainEssence(action.processedDmg.essenceDamage);
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}
	}
}

function ACS_Enemy_On_Take_Damage_03(action: W3DamageAction)
{
	var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var caranthir_hit_anim_names, anim_names, hit_anim_names																		: array< name >;
	var spawnPos, newSpawnPos																										: Vector;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var droppeditemID 																												: SItemUniqueId;
	var h 																															: float;		
	var l_comp 																														: array< CComponent >;
	var size, j  																													: int;
	var params 																														: SCustomEffectParams;
	var miniHymSize, miniHymSpeed																									: float;
	var ent																															: CACSMonsterSpawner;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	animcomp = (CAnimatedComponent)npc.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npc.GetComponentByClassName('CMeshComponent');

	if 
	(npc)
	{
		if 
		(npc.HasTag('ACS_Melusine_Cloud')
		|| npc.HasTag('ACS_Melusine_Bossbar')
		|| npc.HasTag('ACS_Svalblod_Bossbar')
		|| npc.HasTag('ACS_Vampire_Monster_Boss_Bar')
		)
		{
			if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
			}
			else if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Cultist_Boss'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Cultist'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Cultist_Singer'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					npc.SignalGameplayEvent('DisableFinisher');

					anim_names.Clear();

					anim_names.PushBack('woman_sorceress_hit_front');
					anim_names.PushBack('woman_sorceress_hit_front_down');
					anim_names.PushBack('woman_sorceress_hit_front_left');
					anim_names.PushBack('woman_sorceress_hit_front_left_up');
					anim_names.PushBack('woman_sorceress_hit_front_right');
					anim_names.PushBack('woman_sorceress_hit_front_right_down');
					anim_names.PushBack('woman_sorceress_hit_front_right_up');
					anim_names.PushBack('woman_sorceress_hit_front_up');
					anim_names.PushBack('woman_sorceress_hit_left_down');
					anim_names.PushBack('woman_work_stand_praying_loop_03');
					anim_names.PushBack('woman_work_stand_praying_loop_03');

					animatedComponentA.PlaySlotAnimationAsync ( anim_names[RandRange(anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 500000 );

					movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Pirate_Zombie'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}

					theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

					theSound.SoundEvent("monster_bies_vo_pain_normal");

					if (!npc.HasTag('ACS_Pirate_Zombie_Hit_Anim_Immune'))
					{
						npc.SetCanPlayHitAnim(false);

						npc.AddTag('ACS_Pirate_Zombie_Hit_Anim_Immune');
					}
					else if (npc.HasTag('ACS_Pirate_Zombie_Hit_Anim_Immune'))
					{
						npc.SetCanPlayHitAnim(true);

						if (npc.IsOnGround())
						{
							ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
							movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
							movementAdjustorNPC.CancelAll();

							ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
							movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
							movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 50000000 );

							movementAdjustorNPC.RotateTowards( ticket, npc.GetTarget() );
						}

						npc.RemoveTag('ACS_Pirate_Zombie_Hit_Anim_Immune');
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Svalblod'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (ACSGetCActor('ACS_Svalblod_Bossbar').UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}

						ACSGetCActor('ACS_Svalblod_Bossbar').DrainVitality(action.processedDmg.vitalityDamage / 2);
					}
					else if (ACSGetCActor('ACS_Svalblod_Bossbar').UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}

						ACSGetCActor('ACS_Svalblod_Bossbar').DrainEssence(action.processedDmg.essenceDamage / 2);
					}

					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}

				if (
				ACSGetCActor('ACS_Svalblod_Bossbar').UsesEssence() && ACSGetCActor('ACS_Svalblod_Bossbar').GetCurrentHealth() < ACSGetCActor('ACS_Svalblod_Bossbar').GetMaxHealth() * RandRangeF(0.75, 0.25)
				)
				{
					if ( !npc.HasTag('ACS_Svalblod_Transform'))
					{
						GetACSWatcher().ACS_Svalblod_Bear_Spawn();

						animcomp.FreezePose();

						((CNewNPC)npc).EnableCollisions(false);

						npc.DestroyAfter(1);

						npc.SetImmortalityMode( AIM_Invulnerable, AIC_Default, true ); 

						npc.AddTag('ACS_Svalblod_Transform');
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Svalblod_Bear'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (ACSGetCActor('ACS_Svalblod_Bossbar').UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.875;
						}

						ACSGetCActor('ACS_Svalblod_Bossbar').DrainVitality(action.processedDmg.vitalityDamage / 2);
					}
					else if (ACSGetCActor('ACS_Svalblod_Bossbar').UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.9;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.875;
						}

						ACSGetCActor('ACS_Svalblod_Bossbar').DrainEssence(action.processedDmg.essenceDamage / 2);
					}

					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

					ticket = movementAdjustor.GetRequest( 'ACS_Svalblod_Bear_Rotate');
					movementAdjustor.CancelByName( 'ACS_Svalblod_Bear_Rotate' );
					movementAdjustor.CancelAll();

					ticket = movementAdjustor.CreateNewRequest( 'ACS_Svalblod_Bear_Rotate' );
					movementAdjustor.AdjustmentDuration( ticket, 0.5 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500 );

					movementAdjustor.RotateTowards(ticket, npc.GetTarget());

					theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

					theSound.SoundEvent("monster_bies_vo_pain_normal");
				}

				if (
				ACSGetCActor('ACS_Svalblod_Bossbar').GetCurrentHealth() <= 0.1
				)
				{
					if ( !npc.HasTag('ACS_Svalblod_Bear_Death'))
					{
						ACSGetCActor('ACS_Svalblod_Bossbar').Destroy();

						movementAdjustor.CancelAll();

						if (npc.UsesVitality())
						{
							npc.DrainVitality(npc.GetMaxHealth());
						}
						else if (npc.UsesEssence())
						{
							npc.DrainEssence(npc.GetMaxHealth());
						}

						npc.GetInventory().AddAnItem( 'acs_red_lightning_item' , 1 );

						droppeditemID = npc.GetInventory().GetItemId('acs_red_lightning_item');

						npc.GetInventory().DropItemInBag(droppeditemID, 1);

						((CNewNPC)npc).SetVisibility(false);

						npc.StopAllEffects();

						npc.PlayEffectSingle('ethereal_debuff');
						npc.PlayEffectSingle('ethereal_buff');

						npc.DestroyAfter(5);

						npc.AddTag('ACS_Svalblod_Bear_Death');
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Berserkers_Human'))
		{
			if (playerAttacker)
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.HasTag('ACS_Berserker_Rage'))
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
							}
						}
					}
					else
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.06125;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.06125;
							}
						}
					}
				}

				if (
				(npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= npc.GetMaxHealth() * RandRangeF(0.75, 0.5)
				&& npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage > npc.GetMaxHealth() * 0.25)
				||
				(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= npc.GetMaxHealth() * RandRangeF(0.75, 0.5)
				&& npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage > npc.GetMaxHealth() * 0.25)
				)
				{
					if ( !npc.HasTag('ACS_Berserker_Transform_Stage_1'))
					{
						if (RandF() < RandRangeF(0.75, 0.25))
						{
							ACS_Berserker_Bear_Spawn(npc, npc.GetWorldPosition());
						}
						else
						{
							l_comp = npc.GetComponentsByClassName( 'CMorphedMeshManagerComponent' );
							size = l_comp.Size();

							for ( j=0; j<size; j+= 1 )
							{
								((CMorphedMeshManagerComponent)l_comp[ j ]).SetMorphBlend( 1, 1 );
							}

							h = 1.1875;

							animcomp.SetScale(Vector(h,h,h,1));
							meshcomp.SetScale(Vector(h,h,h,1));	

							npc.AddAbility('BounceBoltsWildhunt');

							npc.ACS_SetAnimationSpeedMultiplier(1.25);

							npc.SetCanPlayHitAnim(false);

							npc.PlayEffectSingle('suck_out');
							npc.PlayEffectSingle('smoke_explosion');

							npc.PlayEffectSingle('demonic_possession_ex');

							npc.PlayEffectSingle('acs_armor_effect_2');

							npc.AddTag('ACS_Berserker_Rage');
						}

						npc.AddTag('ACS_Berserker_Transform_Stage_1');
					}
				}
				else if 
				((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= npc.GetMaxHealth() * 0.25)
				||
				(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= npc.GetMaxHealth() * 0.25))
				{
					if ( !npc.HasTag('ACS_Berserker_Transform_Stage_2'))
					{
						ACS_Berserker_Bear_Spawn(npc, npc.GetWorldPosition());

						npc.AddTag('ACS_Berserker_Transform_Stage_2');
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Berserkers_Bear'))
		{
			if (playerAttacker)
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
					}

					ticket = movementAdjustor.GetRequest( 'ACS_Berserker_Bear_Rotate');
					movementAdjustor.CancelByName( 'ACS_Berserker_Bear_Rotate' );
					movementAdjustor.CancelAll();

					ticket = movementAdjustor.CreateNewRequest( 'ACS_Berserker_Bear_Rotate' );
					movementAdjustor.AdjustmentDuration( ticket, 0.25 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500 );

					movementAdjustor.RotateTowards(ticket, npc.GetTarget());
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Wild_Hunt_Rider'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Duskwraith'))
		{
			if ( playerAttacker)
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (ACSGetCActor('ACS_Duskwraith').IsEffectActive('shadows_form_banshee', false))
					{
						npc.SetCanPlayHitAnim(false); 

						ACSGetCActor('ACS_Duskwraith').StopEffect('shadows_form_banshee');
						ACSGetCActor('ACS_Duskwraith').StopEffect('shadows_form_noonwraith_test');
						ACSGetCActor('ACS_Duskwraith').PlayEffectSingle('shadows_form_noonwraith');

						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
							}
							else
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.9;
							}
							else
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
							}
						}

						GetACSWatcher().RemoveTimer('ACS_Duskwraith_Shadowcloak');

						GetACSWatcher().AddTimer('ACS_Duskwraith_Shadowcloak', 4 , false );
					}
					else
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								npc.SetCanPlayHitAnim(false); 

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
							}
							else
							{
								npc.SetCanPlayHitAnim(true); 

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								npc.SetCanPlayHitAnim(false); 

								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
							}
							else
							{
								npc.SetCanPlayHitAnim(true); 

								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
						}
					}

					ticket = movementAdjustor.GetRequest( 'ACS_Duskwraith_Rotate');
					movementAdjustor.CancelByName( 'ACS_Duskwraith_Rotate' );
					movementAdjustor.CancelAll();

					ticket = movementAdjustor.CreateNewRequest( 'ACS_Duskwraith_Rotate' );
					movementAdjustor.AdjustmentDuration( ticket, 0.125 );
					movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500 );

					movementAdjustor.RotateTowards(ticket, npc.GetTarget());
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Duskwraith_Skeleton'))
		{
			if(playerAttacker)
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					npc.SetCanPlayHitAnim(true); 

					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += npc.GetMaxHealth();
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += npc.GetMaxHealth();
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Incubus'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (!npc.HasTag('ACS_Incubus_Negate_Hit_Anim'))
					{
						npc.SetCanPlayHitAnim(false); 

						npc.AddTag('ACS_Incubus_Negate_Hit_Anim');
					}
					else
					{
						npc.SetCanPlayHitAnim(true); 

						npc.RemoveTag('ACS_Incubus_Negate_Hit_Anim');
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Mage'))
		{
			if (playerAttacker)
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Shades_Crusader'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					npc.PlayEffectSingle('special_attack_break');
					npc.StopEffect('special_attack_break');

					npc.PlayEffectSingle('olgierd_energy_blast');
					npc.StopEffect('olgierd_energy_blast');

					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Shades_Hunter'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Shades_Rogue'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.25;
						}
						else
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.5;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 1.25;
						}
						else
						{
							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 1.5;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.5;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.5;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Shades_Rogue_Enemies'))
		{
			if ( playerAttacker )
			{

			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Draug'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}

					theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

					theSound.SoundEvent("monster_bies_vo_pain_normal");
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Draugir'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.1;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.1;
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage += action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_MegaWraith'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				npc.SetCanPlayHitAnim(false);

				if (!npc.HasAbility('Specter'))
				{
					npc.AddAbility('Specter');

					npc.AddAbility('FlashStep');
				}
				else if (npc.HasAbility('Specter'))
				{
					npc.RemoveAbility('Specter');

					npc.RemoveAbility('FlashStep');
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Fire_Gryphon'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					npc.SetCanPlayHitAnim(false);

					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}

					theSound.SoundEvent("monster_him_vo_pain_ALWAYS");

					theSound.SoundEvent("monster_bies_vo_pain_normal");
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}
	}
}

function ACS_Enemy_On_Take_Damage_04(action: W3DamageAction)
{
	var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var caranthir_hit_anim_names, anim_names, hit_anim_names																		: array< name >;
	var spawnPos, newSpawnPos																										: Vector;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var droppeditemID 																												: SItemUniqueId;
	var h 																															: float;		
	var l_comp 																														: array< CComponent >;
	var size, j  																													: int;
	var params 																														: SCustomEffectParams;
	var miniHymSize, miniHymSpeed																									: float;
	var ent																															: CACSMonsterSpawner;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	animcomp = (CAnimatedComponent)npc.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npc.GetComponentByClassName('CMeshComponent');

	if 
	(npc)
	{
		if 
		(npc.HasTag('ACS_Big_Hym'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				npc.SetCanPlayHitAnim(false);

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					npc.StopEffect('shadowdash_body_blood');

					npc.PlayEffectSingle('shadowdash_body_blood');

					npc.StopEffect('shadowdash');

					npc.PlayEffectSingle('shadowdash');

					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if (npc.HasTag('ACS_Guardian_Blood_Hym_Small') || npc.HasTag('ACS_Guardian_Blood_Hym_Large'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.HasTag('ACS_Guardian_Blood_Hym_Small'))
					{
						npc.DrainEssence(npc.GetStatMax(BCS_Essence) * 0.333);
					}
					else if (npc.HasTag('ACS_Guardian_Blood_Hym_Large'))
					{
						npc.DrainEssence(npc.GetStatMax(BCS_Essence) * 0.2);
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Necrofiend'))
		{
			if ( playerAttacker )
			{
				npc.SignalGameplayEvent('DisableFinisher');

				npc.SetCanPlayHitAnim(false);

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Bumbakvetch'))
		{
			if ( playerAttacker )
			{
				npc.SetCanPlayHitAnim(false);

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Viy_Of_Maribor'))
		{
			if ( playerAttacker )
			{
				npc.SetCanPlayHitAnim(false);

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Giant_Troll'))
		{
			if ( playerAttacker )
			{
				npc.SetCanPlayHitAnim(false);

				((CNewNPC)npc).SetUnstoppable( true );

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
				}
			}

			return;
		}
		
		if 
		(npc.HasTag('ACS_Elemental_Titan'))
		{
			if ( playerAttacker )
			{
				npc.SetCanPlayHitAnim(false);

				((CNewNPC)npc).SetUnstoppable( true );

				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Hellhound'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Dark_Knight')
		)
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Dark_Knight_Calidus')
		)
		{
			((CNewNPC)npc).SetUnstoppable( true );

			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Carduin')
		)
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
					}
				}

				if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
				||
				(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
				{
					if ( !npc.HasTag('ACS_Carduin_Death'))
					{
						GetWitcherPlayer().AddPoints(EExperiencePoint, 1500, false );

						ent = (CACSMonsterSpawner)theGame.CreateEntity( 

						(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_monster_spawner.w2ent", true ), 
						
						npc.GetWorldPosition(), 

						thePlayer.GetWorldRotation() );

						ent.AddTag('ACS_MonsterSpawner_Ifrit');

						ent.AddTag('ACS_MonsterSpawner_Spawn_In_Frame');

						FactsAdd("ACS_Carduin_Killed", 1, -1);

						npc.AddTag('ACS_Carduin_Death');
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Dao')
		)
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
						}
					}
				}

				if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
				||
				(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
				{
					if ( !npc.HasTag('ACS_Dao_Death'))
					{
						GetWitcherPlayer().AddPoints(EExperiencePoint, 1000, false );

						npc.AddTag('ACS_Dao_Death');
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Dwarf'))
		{
			if (npc.UsesVitality())
			{
				if( thePlayer.IsDoingSpecialAttack(false))
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
				}
				else
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
				}
			}
			else if (npc.UsesEssence())
			{
				if( thePlayer.IsDoingSpecialAttack(false))
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
				}
				else
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
				}
			}
			
			hit_anim_names.Clear();
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_down_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_down_lp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_down_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_lp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_up_lp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_up_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_lp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_right_down_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_right_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_right_up_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_up_rp_01');
			hit_anim_names.PushBack('man_npc_2hhammer_effect_stagger');
			hit_anim_names.PushBack('man_npc_2hhammer_effect_stagger_long');

			animatedComponentA.PlaySlotAnimationAsync ( hit_anim_names[RandRange(hit_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125, 0.125));

			return;
		}

		if 
		(npc.HasTag('ACS_Vendigo'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if ( !theSound.SoundIsBankLoaded("animals_deer.bnk") )
					{
						theSound.SoundLoadBank( "animals_deer.bnk", false );
					}

					if (!npc.HasTag('ACS_Vendigo_Set_Unstoppable'))
					{
						theSound.SoundEvent("animals_deer_sniff");
						thePlayer.SoundEvent("animals_deer_sniff");

						theSound.SoundEvent("animals_deer_breath");
						thePlayer.SoundEvent("animals_deer_breath");

						theSound.SoundEvent("animals_deer_sniff");
						thePlayer.SoundEvent("animals_deer_sniff");

						theSound.SoundEvent("animals_deer_breath");
						thePlayer.SoundEvent("animals_deer_breath");

						theSound.SoundEvent("animals_deer_sniff");
						thePlayer.SoundEvent("animals_deer_sniff");

						npc.SetCanPlayHitAnim(false);

						((CNewNPC)npc).SetUnstoppable( true );

						npc.AddTag('ACS_Vendigo_Set_Unstoppable');
					}
					else
					{
						theSound.SoundEvent("animals_deer_hit");
						thePlayer.SoundEvent("animals_deer_hit");

						theSound.SoundEvent("animals_deer_hit");
						thePlayer.SoundEvent("animals_deer_hit");

						theSound.SoundEvent("animals_deer_hit");
						thePlayer.SoundEvent("animals_deer_hit");

						theSound.SoundEvent("animals_deer_hit");
						thePlayer.SoundEvent("animals_deer_hit");

						theSound.SoundEvent("animals_deer_hit");
						thePlayer.SoundEvent("animals_deer_hit");

						npc.SetCanPlayHitAnim(true);

						((CNewNPC)npc).SetUnstoppable( false );

						npc.RemoveTag('ACS_Vendigo_Set_Unstoppable');
					}
				}

				if (ACS_ActionDealsDamageType(action, 'fire')
				|| action.HasBuff(EET_Burning))
				{
					npc.DestroyEffect('critical_frozen_constant');

					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 5;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += action.processedDmg.vitalityDamage * 5;
					}

					action.SetCriticalHit();

					if (npc.HasTag('ACS_Vendigo_Set_Unstoppable'))
					{
						npc.SetCanPlayHitAnim(true);

						((CNewNPC)npc).SetUnstoppable( false );

						npc.RemoveTag('ACS_Vendigo_Set_Unstoppable');
					}

					if (!npc.HasBuff(EET_Burning))
					{
						params.effectType = EET_Burning;
						params.creator = playerAttacker;
						params.sourceName = "ACS_Vendigo_Fire_Damage";
						params.duration = 5;

						npc.AddEffectCustom( params );		
					}
				}
				else
				{
					if (npc.HasBuff(EET_Burning))
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.0125;
							}
							else
							{
								action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.025;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.0125;
							}
							else
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.025;
							}
						}

						npc.DestroyEffect('critical_frozen_constant');
					}
					else
					{
						if (!npc.IsEffectActive('critical_frozen_constant', false))
						{
							npc.DestroyEffect('critical_burning');
							npc.DestroyEffect('igni_cone_hit');
							npc.PlayEffect('critical_frozen_constant');
						}

						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_Swarm_Mother'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if ( !theSound.SoundIsBankLoaded("monster_uma.bnk") )
					{
						theSound.SoundLoadBank( "monster_uma.bnk", false );
					}

					if (!npc.HasTag('ACS_Swarm_Mother_Set_Unstoppable'))
					{
						theSound.SoundEvent("monster_uma_bell_heavy");
						thePlayer.SoundEvent("monster_uma_bell_heavy");

						theSound.SoundEvent("monster_uma_bell_light");
						thePlayer.SoundEvent("monster_uma_bell_light");

						theSound.SoundEvent("monster_uma_dialog_bell_heavy");
						thePlayer.SoundEvent("monster_uma_dialog_bell_heavy");

						theSound.SoundEvent("monster_uma_dialog_bell_light");
						thePlayer.SoundEvent("monster_uma_dialog_bell_light");

						npc.SetCanPlayHitAnim(false);

						((CNewNPC)npc).SetUnstoppable( true );

						npc.AddTag('ACS_Swarm_Mother_Set_Unstoppable');
					}
					else
					{
						theSound.SoundEvent("monster_uma_dialog_vo_excited_pain");
						thePlayer.SoundEvent("monster_uma_dialog_vo_excited_pain");

						theSound.SoundEvent("monster_uma_dialog_vo_pain_extreme");
						thePlayer.SoundEvent("monster_uma_dialog_vo_pain_extreme");

						theSound.SoundEvent("monster_uma_dialog_vo_pain_short");
						thePlayer.SoundEvent("monster_uma_dialog_vo_pain_short");

						theSound.SoundEvent("monster_uma_dialog_vo_pain_medium");
						thePlayer.SoundEvent("monster_uma_dialog_vo_pain_medium");

						npc.SetCanPlayHitAnim(true);

						((CNewNPC)npc).SetUnstoppable( false );

						npc.RemoveTag('ACS_Swarm_Mother_Set_Unstoppable');
					}
				}

				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		( npc.HasTag('ACS_Maerolorn'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 5.5;
						}
						else
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 7.5;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 5.5;
						}
						else
						{
							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 7.5;
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_MonsterHunt_Mourntart'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (npc.HasTag('ACS_Mourntart_Tongue_Disabled'))
					{
						if (npc.UsesVitality())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.5;
							}
							else
							{
								action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage;
							}
						}
						else if (npc.UsesEssence())
						{
							if( thePlayer.IsDoingSpecialAttack(false))
							{
								action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.5;
							}
							else
							{
								action.processedDmg.essenceDamage += action.processedDmg.essenceDamage;
							}
						}
					}
					else
					{
						if (npc.HasTag('ACS_Mourntart_Below_Half_Health_With_Tongue'))
						{
							if (npc.UsesVitality())
							{
								if( thePlayer.IsDoingSpecialAttack(false))
								{
									action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
								}
								else
								{
									action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
								}
							}
							else if (npc.UsesEssence())
							{
								if( thePlayer.IsDoingSpecialAttack(false))
								{
									action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
								}
								else
								{
									action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
								}
							}
						}
						else
						{
							if (npc.UsesVitality())
							{
								if( thePlayer.IsDoingSpecialAttack(false))
								{
									action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;
								}
								else
								{
									action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
								}
							}
							else if (npc.UsesEssence())
							{
								if( thePlayer.IsDoingSpecialAttack(false))
								{
									action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.85;
								}
								else
								{
									action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
								}
							}

							if (
							(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= npc.GetMaxHealth() * 0.33)
							||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= npc.GetMaxHealth() * 0.33)
							)
							{
								if (!npc.HasTag('ACS_Mourntart_Half_Health_Stage'))
								{
									ACS_MonsterBehSwitch('Mourntart_Beh_Switch_Under_Half_Health_With_Tongue_Engage');

									GetACSStorage().acs_deleteOnelinerByTag("ACS_Mourntart_Counter_Oneliner");

									ACS_Oneliner(
									(new ACS_Oneliner_TagBuilder in theGame)
									.tag("font")
									.attr("size", "26")
									.attr("color", "#f00000")
									.text(GetLocStringById(2118449936))
									, npc, "ACS_Mourntart_Counter_Oneliner", Vector(0,0,1.5), 5);

									GetACSStorage().acs_setAlphaForOnelinerByTag("ACS_Mourntart_Counter_Oneliner", 100);

									GetACSStorage().acs_setScaleForOnelinerByTag("ACS_Mourntart_Counter_Oneliner", 100, 100, 100);

									npc.AddTag('ACS_Mourntart_Half_Health_Stage');
								}
							}
						}
					}
				}
			}

			return;
		}

		if 
		(npc.HasTag('ACS_MonsterHunt_Monster'))
		{
			if ( playerAttacker )
			{
				if (!action.WasDodged() 
				//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
				&& !(((W3Action_Attack)action).IsParried())
				)
				{
					if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()) || ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
					{
						if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}

						if (RandF() < 0.75)
						{
							npc.SetCanPlayHitAnim(false);

							((CNewNPC)npc).SetUnstoppable( true );
						}
						else
						{
							npc.SetCanPlayHitAnim(true);

							((CNewNPC)npc).SetUnstoppable( false );
						}
					}
					else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
					{
						if (!npc.HasTag('ACS_MonsterHuntMonster_Set_Unstoppable'))
						{
							npc.SetCanPlayHitAnim(false);

							((CNewNPC)npc).SetUnstoppable( true );

							npc.AddTag('ACS_MonsterHuntMonster_Set_Unstoppable');
						}
						else
						{
							npc.SetCanPlayHitAnim(true);

							((CNewNPC)npc).SetUnstoppable( false );

							npc.RemoveTag('ACS_MonsterHuntMonster_Set_Unstoppable');
						}
					}
				}
			}
			else
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				}
			}

			return;
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_Ghoul_Base_On_Take_Damage(action: W3DamageAction)
{
   	var npc 																														: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var morphedMM																													: CMorphedMeshManagerComponent;


    npc = (CActor)action.victim;
	
	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	if 
	(npc 
	&& npc.HasAbility('mon_ghoul_base')
	&& !npc.HasTag('acs_wildhunt_minion_alpha')
	)
	{
		if ( npc.HasAbility('mon_ghoul_lesser')
		|| npc.HasAbility('mon_ghoul')
		|| npc.HasAbility('mon_ghoul_stronger')
		|| npc.HasAbility('mon_EP2_ghouls')
		|| npc.HasAbility('ghoul_hardcore')
		)
		{
			if (!npc.HasTag('ACS_Ghoul_End_Stage'))
			{
				ACS_Ghoul_Explode(npc, npc.GetWorldPosition());

				if(RandF() < 0.5)
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_front', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_back', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}

				animatedComponentA.FreezePoseFadeIn(2);

				npc.AddTag('ACS_Ghoul_End_Stage');
			}
		}
		else if ( 
		npc.HasAbility('mon_alghoul')
		|| npc.HasAbility('mon_greater_miscreant')
		)
		{
			if (ACS_ActionDealsDamageType(action, 'fire')
			|| action.HasBuff(EET_Burning))
			{
				if (npc && npc.HasAbility('RageActive') 
				)
				{
					npc.StopEffect('morph_fx');
					morphedMM = npc.GetMorphedMeshManagerComponent();
					morphedMM.SetMorphBlend( 0, 0.5f );
					npc.RemoveAbility( 'RageActive' );
					npc.RemoveAbility( 'Thorns' );

					npc.SignalGameplayEvent('StopRage');
				}
			}

			if (!npc.HasTag('ACS_Ghoul_End_Stage'))
			{
				ACS_Alghoul_Explode(npc, npc.GetWorldPosition());

				if(RandF() < 0.5)
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_front', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_back', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}

				animatedComponentA.FreezePoseFadeIn(2);

				npc.AddTag('ACS_Ghoul_End_Stage');
			}
		}
		else if (
		npc.HasAbility('mon_wild_hunt_minionMH')
		|| npc.HasAbility('mon_wild_hunt_minion')
		)
		{
			if (!npc.HasTag('ACS_Ghoul_End_Stage'))
			{
				ACS_Alghoul_Explode(npc, npc.GetWorldPosition());

				ACS_Wildhunt_Minion_Explode(npc, npc.GetWorldPosition());

				if(RandF() < 0.5)
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_front', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}
				else
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'death_back', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}

				animatedComponentA.FreezePoseFadeIn(2);

				npc.AddTag('ACS_Ghoul_End_Stage');
			}
		}
	}
}

function ACS_Siren_Base_On_Take_Damage(action: W3DamageAction)
{
   	var npc 																											: CActor;

    npc = (CActor)action.victim;

	if 
	(npc && npc.HasAbility('mon_siren_base'))
	{
		if(!npc.HasAbility('DisableDismemberment'))
		{
			npc.AddAbility('DisableDismemberment');
		}

		if (!npc.HasTag('ACS_Siren_End_Stage'))
		{
			ACS_Alghoul_Explode(npc, npc.GetWorldPosition());

			npc.AddTag('ACS_Siren_End_Stage');
		}
	}
}

function ACS_Bruxa_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var spawnPos, newSpawnPos																										: Vector;
	var playerRot																													: EulerAngles;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasAbility('mon_vampiress_base'))
	{
		if (playerAttacker)
		{
			if (!npc.HasTag('ACS_Unseen_Blade_Summon_Trigger'))
			{
				if(!ACSGetCActor('ACS_Blade_Of_The_Unseen') && !ACSGetCActor('ACS_Vampire_Monster'))
				{
					GetACSStorage().acs_Number_Of_Bruxae_Slain_Manage(false);
					
					if (GetACSStorage().number_of_bruxae_slain == 1)
					{
						GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449963) );

						GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
						GetACSWatcher().AddTimer('unseen_blade_spawn_delay', 305, true);
					}
					else if (GetACSStorage().number_of_bruxae_slain == 2)
					{
						GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449964) );

						GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
						GetACSWatcher().AddTimer('unseen_blade_spawn_delay', 155, true);
					}
					else if (GetACSStorage().number_of_bruxae_slain == 3)
					{
						GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449965) );

						GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
						GetACSWatcher().AddTimer('unseen_blade_spawn_delay', 5, true);
					}
					else
					{
						GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449965) );

						GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
						GetACSWatcher().AddTimer('unseen_blade_spawn_delay', 5, true);
					}

					npc.AddTag('ACS_Unseen_Blade_Summon_Trigger');
				}
				else if(ACSGetCActor('ACS_Blade_Of_The_Unseen') && ACSGetCActor('ACS_Blade_Of_The_Unseen').IsAlive())
				{
					playerRot = thePlayer.GetWorldRotation();

					playerRot.Yaw += 180;

					spawnPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

					if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.5, 0.5 , newSpawnPos ) )
					{
						theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
						spawnPos = newSpawnPos;
					}

					ACSGetCActor('ACS_Blade_Of_The_Unseen').TeleportWithRotation(ACSFixZAxis(spawnPos), playerRot);

					npc.AddTag('ACS_Unseen_Blade_Summon_Trigger');
				}
			}
		}
	}
}

function ACS_AddItemOnAttack(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && StrContains( npc.GetReadableName(), "sq201_morkvarg" ))
	{
		if ( !npc.HasTag('ACS_Morkvarg_Death'))
		{
			((CActor)npc).GetInventory().AddAnItem( 'acs_wolven_fang', 1 );

			npc.AddTag('ACS_Morkvarg_Death');
		}
	}

	if 
	(npc && StrContains( npc.GetReadableName(), "mq1033_swordsman_shield" ))
	{
		if ( !npc.HasTag('ACS_Ronvid_Death'))
		{
			if (!thePlayer.inv.HasItem('acs_one_mind_item'))
			{
				((CActor)npc).GetInventory().AddAnItem( 'acs_one_mind_item', 1 );
			}

			npc.AddTag('ACS_Ronvid_Death');
		}
	}

	if 
	(npc 
	&& 
	(StrContains( npc.GetReadableName(), "q704_cloud_giant" )
	|| StrContains( npc.GetReadableName(), "q704_ft_giant" )
	)
	)
	{
		if ( !npc.HasTag('ACS_Cloud_Giant_Death'))
		{
			if (!thePlayer.inv.HasItem('acs_spiral_cloud_passage_item'))
			{
				((CActor)npc).GetInventory().AddAnItem( 'acs_spiral_cloud_passage_item', 1 );
			}

			npc.AddTag('ACS_Cloud_Giant_Death');
		}
	}

	if 
	(npc 
	&& (StrContains( npc.GetReadableName(), "mq1060_evil_spirit" )
	|| npc.HasTag('ACS_Ancient_Red_Miasmal')
	)
	)
	{
		if (playerAttacker)
		{
			if ( !npc.HasTag('ACS_Red_Miasmal_Boss_On_Hit'))
			{
				if (!thePlayer.inv.HasItem('acs_red_miasmal_fragment'))
				{
					thePlayer.inv.AddAnItem('acs_red_miasmal_fragment', 1);
				}

				npc.AddTag('ACS_Red_Miasmal_Boss_On_Hit');
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*
function ACS_Shades_Crusader_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin, dmgValSilver, dmgValSteel																				: float;
	var vACS_Shield_Summon 																											: cACS_Shield_Summon;
	var heal, playerVitality, bossbardamagevitality, bossbardamageessence															: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, finisherDist										: float;
	var itemId_r, itemId_l 																											: SItemUniqueId;
	var itemTags_r, itemTags_l, acs_npc_blood_fx 																					: array<name>;
	var tmpName 																													: name;
	var tmpBool 																													: bool;
	var mc 																															: EMonsterCategory;
	var blood 																														: EBloodType;
	var item_steel, item_silver																										: SItemUniqueId;
	var anim_names																													: array< name >;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Shades_Crusader'))
	{
		if ( playerAttacker )
		{
			if (!action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				
				if (!npc.HasTag('ACS_Crusader_Hit_Anim_Immune'))
				{
					npc.SetCanPlayHitAnim(false);

					npc.PlayEffectSingle('special_attack_break');
					npc.StopEffect('special_attack_break');

					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}

					npc.AddTag('ACS_Crusader_Hit_Anim_Immune');
				}
				else if (npc.HasTag('ACS_Crusader_Hit_Anim_Immune'))
				{
					npc.SetCanPlayHitAnim(true);

					if (npc.UsesVitality())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}
					}
					else if (npc.UsesEssence())
					{
						if( thePlayer.IsDoingSpecialAttack(false))
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
						}
						else
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
						}
					}

					npc.RemoveTag('ACS_Crusader_Hit_Anim_Immune');
				}
				

				npc.PlayEffectSingle('special_attack_break');
				npc.StopEffect('special_attack_break');

				npc.PlayEffectSingle('olgierd_energy_blast');
				npc.StopEffect('olgierd_energy_blast');

				if (npc.UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}
				else if (npc.UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.5;
					}
					else
					{
						action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * 0.25;
					}
				}
			}
		}
		else
		{
			if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
			}
			else if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
			}
		}
	}
}
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Red_Blood_Death_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var tmpName 																													: name;
	var tmpBool 																													: bool;
	var mc 																															: EMonsterCategory;
	var targetDistance 																												: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	targetDistance = VecDistanceSquared2D( npc.GetWorldPosition(), playerAttacker.GetWorldPosition() ) ;

	theGame.GetMonsterParamsForActor(npc, mc, tmpName, tmpBool, tmpBool, tmpBool);

	if 
	(npc 
	&& ((CNewNPC)npc).GetBloodType() != BT_Green
	&& ((CNewNPC)npc).GetBloodType() != BT_Yellow
	&& !npc.HasAbility('mon_golem_base')
	&& !npc.HasAbility('mon_djinn')
	&& !npc.HasAbility('mon_gargoyle')
	&& !npc.HasAbility('mon_lessog_base')
	&& !npc.HasAbility('mon_sprigan_base')
	&& !npc.IsHuman()
	&& mc != MC_Specter
	)
	{
		if ( playerAttacker )
		{
			if ( targetDistance <= 4 * 4
			)
			{
				if ( !npc.HasTag('ACS_Red_Blood_Death'))
				{
					ACS_Normal_Death_Explode(npc, npc.GetWorldPosition());

					npc.AddTag('ACS_Red_Blood_Death');
				}
			}
		}
	}
}

function ACS_Add_Weapon_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(playerAttacker && npc)
	{
		if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
		||
		(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
		{
			if ( !npc.HasTag('ACS_NPC_Death_Add_Weapon'))
			{
				GetACSWatcher().ACS_Add_Weapons_To_Inventory(action);

				npc.AddTag('ACS_NPC_Death_Add_Weapon');
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Player_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim																																		: CPlayer;
	var npc, npcAttacker 																																					: CActor;
	var dmg																																									: W3DamageAction;
	var damageMax, damageMin, dmgValSilver, dmgValSteel																														: float;
	var heal, playerVitality 																																				: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, finisherDist, vampireDmgValSteel, vampireDmgValSilver										: float;
	var item_steel, item_silver																																				: SItemUniqueId;
	var animatedComponentA, animatedComponentB 																																: CAnimatedComponent;
	var hitLag, targetDistance																																				: float;
    var ent_1                      																																			: CEntity;
	var rot_1         																																						: EulerAngles;
	var pos_1																																								: Vector;
	var staminaPercentage 																																					: float;
	var electric_fist																																						: CACSElectricFist;
	var vfxEnt																																								: CEntity;
	var grey_health_mult																																					: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	if 
	(playerAttacker 
	&& npc 
	&& !npc.IsInvulnerable()
	&& !npc.IsUsingHorse()
	)
	{
		if(
		((CNewNPC)npc).IsHuman()
		&& ((CNewNPC)npc).UsesVitality()
		&& ((CNewNPC)npc).IsMan()
		&& !((CNewNPC)npc).HasTag('ACS_Rat_Mage')
		&& !((CNewNPC)npc).HasTag('ACS_Dwarf')
		)
		{
			((CNewNPC)npc).AddTimer('ACS_Crawl_Controller_Delay_Spawn', 0.1 , false);
		}

		if (((CNewNPC)npc).GetNPCType() == ENGT_Guard)
		{
			if (npc.GetImmortalityMode() != AIM_None)
			{
				npc.SetImmortalityMode( AIM_None, AIC_Default, true ); 
			}
		}

		if (npc.HasAbility('mon_rotfiend') || npc.HasAbility('mon_rotfiend_large'))
		{
			if (!npc.HasAbility('InstantKillImmune'))
			{
				npc.AddAbility('InstantKillImmune');
			}

			if (!npc.HasAbility('OneShotImmune'))
			{
				npc.AddAbility('OneShotImmune');
			}
		}

		if (!npc.HasAbility('IgnoreLevelDiffForParryTest'))
		{
			npc.AddAbility('IgnoreLevelDiffForParryTest');
		}

		if (npc.HasTag('ACS_Final_Fear_Stack')
		)
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				action.processedDmg.essenceDamage += npc.GetMaxHealth();
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				action.processedDmg.vitalityDamage += npc.GetMaxHealth();
			}

			GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

			if (ACS_Armor_Set_Check('acs_armor', false))
			{
				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_black_exhale");

				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_summon");
			}

			return;
		}

		if (npc.HasTag('ACS_Final_Fear_Stack')
		&& !action.IsActionMelee()
		)
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
				action.processedDmg.essenceDamage += npc.GetMaxHealth();
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				action.processedDmg.vitalityDamage += npc.GetMaxHealth();
			}

			GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

			if (ACS_Armor_Set_Check('acs_armor', false))
			{
				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_black_exhale");

				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_summon");
			}

			return;
		}

		if (action.WasDodged() )
		{
			if (npc.HasTag('ACS_Swapped_To_Shield'))
			{
				theSound.SoundEvent("shield_wood_impact");

				theSound.SoundEvent("grunt_vo_block");
			}

			return;
		}

		ACS_Player_Modifier_Attack(action);

		if (ACS_Armor_Set_Check('acs_armor', false) 
		&& action.IsActionMelee() 
		&& !thePlayer.IsUsingHorse() 
		&& !thePlayer.IsUsingVehicle()
		&& action.WasDodged() 
		)
		{
			if (RandF() < 0.5)
			{
				thePlayer.SoundEvent("monster_caretaker_vo_attack_short", 'head' );
			}
		}

		if (!thePlayer.IsUsingHorse() 
		&& !thePlayer.IsUsingVehicle()
		)
		{
			if (action.WasDodged())
			{
				((CNewNPC)npc).ACS_DealPostureDamage(1);
			}
			else if (
			((W3Action_Attack)action).IsParried()
			)
			{
				((CNewNPC)npc).ACS_DealPostureDamage(10);
			}
			else 
			{
				if (GetAttitudeBetween(npc, playerAttacker) == AIA_Hostile)
				{
					npc.SignalGameplayEventParamObject( 'ForceTarget', playerAttacker );
				}
				
				if (action.IsActionMelee())
				{
					if ( ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
					{
						((CNewNPC)npc).ACS_DealPostureDamage(1);
					}
					else if (playerAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()))
					{
						((CNewNPC)npc).ACS_DealPostureDamage(10);
					}
					else if (playerAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
					{
						((CNewNPC)npc).ACS_DealPostureDamage(20);
					}

					if ( ((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison')
					{
						if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
						}
						else if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
						}
					}

					if ( ((W3Action_Attack)action).GetAttackName() == 'counter_attack_light')
					{
						if (npc.UsesEssence())
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.75;
						}
						else if (npc.UsesVitality())
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
						}
					}

					if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * (GetACSWatcher().combo_counter_damage * 0.1);
					}
					else if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * (GetACSWatcher().combo_counter_damage * 0.1);
					}

					staminaPercentage = 1 - (GetWitcherPlayer().GetStat( BCS_Stamina )/GetWitcherPlayer().GetStatMax( BCS_Stamina ));

					if (staminaPercentage > 0.5)
					{
						staminaPercentage = 0.5;
					}

					if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * staminaPercentage;
					}
					else if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * staminaPercentage;
					}

					if (ACS_Armor_Set_Check('acs_armor', false) )
					{
						thePlayer.SoundEvent("monster_caretaker_fx_drain_energy_player");

						if (npc.UsesEssence())
						{
							GetWitcherPlayer().GainStat(BCS_Vitality, action.processedDmg.essenceDamage * 0.25 );

							GetACSWatcher().ShowHealFloatingValue(action.processedDmg.essenceDamage * 0.25, true);
						}
						else if (npc.UsesVitality())
						{
							GetWitcherPlayer().GainStat(BCS_Vitality, action.processedDmg.vitalityDamage * 0.25 );

							GetACSWatcher().ShowHealFloatingValue(action.processedDmg.vitalityDamage * 0.25, true);
						}

						GetWitcherPlayer().GainStat(BCS_Vitality, (GetWitcherPlayer().GetStatMax(BCS_Vitality) - GetWitcherPlayer().GetStat(BCS_Vitality)) * 0.125 );

						GetACSWatcher().ShowHealFloatingValue( (GetWitcherPlayer().GetStatMax(BCS_Vitality) - GetWitcherPlayer().GetStat(BCS_Vitality)) * 0.125, true);
						
						if ((GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
						|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
						&& thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875
						&& thePlayer.GetStat(BCS_Stamina) == thePlayer.GetStatMax(BCS_Stamina)
						)
						{
							if (RandF() < 0.5)
							{
								theSound.SoundEvent("fx_fire_geralt_fire_hit");

								theSound.SoundEvent("fx_fire_burning_strong_end");
								
								if (!npc.HasBuff(EET_Burning))
								{
									action.AddEffectInfo( EET_Burning, 0.5 );
								}
							}
						}
					}

					GetWitcherPlayer().AddTimer( 'RemoveForceFinisher', 0.0, false );

					if (npc.HasAbility('mon_rotfiend') || npc.HasAbility('mon_rotfiend_large'))
					{
						if (!npc.HasAbility('InstantKillImmune'))
						{
							npc.AddAbility('InstantKillImmune');
						}

						if (!npc.HasAbility('OneShotImmune'))
						{
							npc.AddAbility('OneShotImmune');
						}
					}

					if (!npc.HasAbility('DisableFinishers'))
					{
						npc.AddAbility( 'DisableFinishers', true);
					}

					if (npc.HasAbility('ForceFinisher'))
					{
						npc.RemoveAbility( 'ForceFinisher');
					} 

					npc.SignalGameplayEvent('DisableFinisher');

					targetDistance = VecDistanceSquared2D( npc.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() );

					if (ACS_ChainWeaponCheck() 
					&& thePlayer.IsAnyWeaponHeld()
					&& thePlayer.HasTag('ACS_Chain_Weapon_Expand')
					&& !GetACSWatcher().combatExtraActive
					)
					{
						if (npc.IsAlive() 
						&& action.DealsAnyDamage()
						&& !npc.HasTag('ACS_In_Rage')
						//&& !npc.HasTag('ACS_Counter_Wound_Ready')
						&& ((W3Action_Attack)action).GetAttackName() != 'acs_attack_poison'
						&& ACS_DefaultMovesetCombatAnimationOverrideMode_Enabled()
						)
						{
							animatedComponentA = (CAnimatedComponent)thePlayer.GetComponentByClassName( 'CAnimatedComponent' );

							animatedComponentA.UnfreezePose();

							//animatedComponentA.FreezePose();

							animatedComponentA.FreezePoseFadeIn(0.05);

							thePlayer.AddTag('ACS_Player_Hit_Lag');

							thePlayer.RemoveTimer('ACS_PlayerUnfreezePose');

							thePlayer.AddTimer('ACS_PlayerUnfreezePose', 0.0625f , false );

							if (!npc.HasBuff(EET_Frozen)
							&& !npc.HasBuff(EET_Immobilized)
							)
							{
								animatedComponentB = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

								animatedComponentB.UnfreezePose();

								//animatedComponentB.FreezePose();

								animatedComponentB.FreezePoseFadeIn(0.05);

								npc.AddTag('ACS_Hit_Lag');

								npc.RemoveTimer('ACS_UnfreezePose');

								npc.AddTimer('ACS_UnfreezePose', 0.0625f , false );
							}
						}
						
					}
					else
					{
						if ( thePlayer.IsAnyWeaponHeld()
						//&& !thePlayer.IsWeaponHeld('fist')
						//&& !thePlayer.HasTag('acs_vampire_claws_equipped')
						&& ACS_Settings_Main_Bool('acs_combat_main_settings','acs_hit_lag', true)
						&& targetDistance <= 4 * 4 
						&& !GetWitcherPlayer().IsGuarded()
						&& !GetWitcherPlayer().IsInGuardedState()
						&& !GetACSWatcher().combatExtraActive
						)
						{
							hitLag = 0.1875;

							if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| npc.GetRadius() >= 0.7
							|| npc.HasAbility('Boss')
							|| npc.HasTag('IsBoss')
							|| npc.HasTag('ACS_Big_Boi')
							)
							{
								hitLag += 0.125f;
							}

							if(
							((W3Action_Attack)action).GetAttackName() == 'attack_light_special'
							)
							{
								hitLag -= 0.0625f;
							}

							if(
							((W3Action_Attack)action).GetAttackName() == 'attack_heavy'
							)
							{
								hitLag += 0.0625f;
							}

							if(
							((W3Action_Attack)action).GetAttackName() == 'attack_heavy_special'
							)
							{
								hitLag += 0.125f;
							}

							if (
							thePlayer.HasBuff(EET_EnhancedWeapon)
							|| ACS_Correct_Oil_Used(npc)
							|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' )
							|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' )
							|| ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver')
							//|| ACS_Armor_Set_Check('viper', true)
							|| ACS_Vampire_Claws_Access()
							//|| thePlayer.HasTag('ACS_In_Combat_Art')
							)
							{
								hitLag -= 0.0625f;
							}

							if(thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
							|| thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
							|| thePlayer.HasTag('acs_yrden_sword_equipped') 
							|| thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
							|| thePlayer.HasTag('acs_axii_secondary_sword_equipped')
							|| FactsQuerySum("ACS_Spear_Transform_Toggle_Enabled")
							|| FactsQuerySum("ACS_Dual_Wield_Toggle_Enabled")
							)
							{
								hitLag -= 0.125f;
							}

							if (
							//thePlayer.HasBuff(EET_EnhancedWeapon)
							((W3Action_Attack)action).GetAttackName() == 'acs_attack_poison'
							//|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' )
							//|| thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' )
							//|| ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver')
							//|| ACS_Armor_Set_Check('viper', true)
							//|| ACS_Vampire_Claws_Access()
							|| thePlayer.HasTag('ACS_In_Combat_Art')
							)
							{
								hitLag *= 0;
							}

							if (npc.IsAlive() 
							&& action.DealsAnyDamage()
							&& !npc.HasTag('ACS_In_Rage')
							//&& !npc.HasTag('ACS_Counter_Wound_Ready')
							&& hitLag > 0
							&& ACS_DefaultMovesetCombatAnimationOverrideMode_Enabled()
							)
							{
								animatedComponentA = (CAnimatedComponent)thePlayer.GetComponentByClassName( 'CAnimatedComponent' );

								animatedComponentA.UnfreezePose();

								//animatedComponentA.FreezePose();

								animatedComponentA.FreezePoseFadeIn(0.05);

								thePlayer.AddTag('ACS_Player_Hit_Lag');

								thePlayer.RemoveTimer('ACS_PlayerUnfreezePose');

								thePlayer.AddTimer('ACS_PlayerUnfreezePose', hitLag, false);

								if (!npc.HasBuff(EET_Frozen)
								&& !npc.HasBuff(EET_Immobilized)
								)
								{
									animatedComponentB = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

									animatedComponentB.UnfreezePose();

									//animatedComponentB.FreezePose();

									animatedComponentB.FreezePoseFadeIn(0.05);

									npc.AddTag('ACS_Hit_Lag');

									npc.RemoveTimer('ACS_UnfreezePose');

									npc.AddTimer('ACS_UnfreezePose', 0.0625f , false );

								}

								ACS_Tutorial_Display_Check('ACS_Hit_Lag_Tutorial_Shown');
							}
						}
					}

					if (thePlayer.IsWeaponHeld('fist')
					&& !thePlayer.HasTag('acs_vampire_claws_equipped')
					&& !thePlayer.HasTag('acs_sorc_fists_equipped') 
					)
					{
						if (
						((CNewNPC)npc).HasTag('ACS_Big_Boi')
						|| ((CNewNPC)npc).HasAbility('mon_toad_base')
						|| ((CNewNPC)npc).HasAbility('mon_type_huge')
						|| ((CMovingPhysicalAgentComponent)((npc).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| ((CNewNPC)npc).GetRadius() >= 0.7
						)
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * (ACS_Settings_Main_Float('acs_damage_settings','acs_fist_damage_multiplier', 1) * 0.5);

							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * (ACS_Settings_Main_Float('acs_damage_settings','acs_fist_damage_multiplier', 1) * 0.5);
						}
						else
						{
							action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * ACS_Settings_Main_Float('acs_damage_settings','acs_fist_damage_multiplier', 1);

							action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * ACS_Settings_Main_Float('acs_damage_settings','acs_fist_damage_multiplier', 1);
						}

						if (GetWitcherPlayer().IsAnyQuenActive()
						&& ACS_Settings_Main_Bool('acs_signs_settings','acs_quen_extra_effects_enabled', true)
						)
						{
							electric_fist = (CACSElectricFist)theGame.CreateEntity((CEntityTemplate)LoadResource("dlc\dlc_acs\data\fx\electric_fist\acs_electric_fist.w2ent",true), 
							((npc.GetWorldPosition() + ((npc.GetWorldPosition() + playerAttacker.GetWorldPosition()) * 0.5)) * 0.5) + Vector(0, 0, RandRangeF(1.5f,1.25f)), 
							npc.GetWorldRotation());

							//electric_fist.CreateAttachment(npc,, Vector( 0, 0, RandRangeF(1.5,1.25) ), EulerAngles(RandRangeF(360,0),RandRangeF(360,0),RandRangeF(356,0)));

							electric_fist.DestroyAfter(3);
						}
						else
						{
							vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent", true ), 
							((npc.GetWorldPosition() + ((npc.GetWorldPosition() + playerAttacker.GetWorldPosition()) * 0.5)) * 0.5) + Vector(0, 0, RandRangeF(1.5f,1.25f)), 
							npc.GetWorldRotation() );

							//vfxEnt.CreateAttachment(npc,, Vector(RandRangeF(0.25f,-0.25f), RandRangeF(0.5f,0.25f), RandRangeF(1.5f,1.25f)), EulerAngles(RandRangeF(360,0),RandRangeF(360,0),RandRangeF(360,0)));

							vfxEnt.PlayEffectSingle('fist_hit_indicator');
							vfxEnt.PlayEffectSingle('hit_refraction_red');
							vfxEnt.DestroyAfter(1.5);
						}

						return;
					}

					if (thePlayer.acs_grey_health_current > 0)
					{
						if(thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
						|| thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
						|| thePlayer.HasTag('acs_yrden_sword_equipped') 
						|| thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
						|| thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
						{
							grey_health_mult = 0.5;
						}
						else
						{
							grey_health_mult = 0.25;
						}

						GetWitcherPlayer().GainStat( BCS_Vitality, thePlayer.acs_grey_health_current * grey_health_mult ); 

						GetACSWatcher().ShowHealFloatingValue( thePlayer.acs_grey_health_current * grey_health_mult, true);

						thePlayer.ACS_ManageGreyHealth(false, thePlayer.acs_grey_health_current * grey_health_mult);
					}

					if ((GetWitcherPlayer().HasTag('acs_vampire_claws_equipped')
					&& thePlayer.IsWeaponHeld('fist'))
					|| ACS_Vampire_Claws_Access()
					)
					{
						npc.StopEffect('focus_sound_red_fx');

						if (((CActor)npc).HasAbility('DisableDismemberment'))
						{
							((CActor)npc).RemoveAbility( 'DisableDismemberment');
						}

						if (npc.IsUsingVehicle()) 
						{
							npc.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_shakeOff | DT_fromScript );
						}

						GetWitcherPlayer().SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_large");

						GetWitcherPlayer().IncreaseUninterruptedHitsCount();	

						GetACSWatcher().Passive_Weapon_Effects_Switch();

						if (npc.UsesEssence())
						{
							GetWitcherPlayer().GainStat( BCS_Focus, GetWitcherPlayer().GetStatMax( BCS_Focus) * 0.1 ); 

							if (ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_max_damage', 0) != 0 
							&& ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_min_damage', 0) != 0 )
							{
								maxTargetEssence = npc.GetStatMax( BCS_Essence );

								curTargetEssence = npc.GetStat( BCS_Essence );

								if (ACS_Settings_Main_Int('acs_damage_settings','acs_vampire_claws_damage_max_health_or_current_health', 0) == 0)
								{
									if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
									|| npc.GetRadius() >= 0.7
									|| npc.HasAbility('Boss')
									|| npc.HasTag('IsBoss')
									|| npc.HasTag('ACS_Big_Boi')
									)
									{
										damageMax = maxTargetEssence * (ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_max_damage', 0) * 0.5); 
										
										damageMin = maxTargetEssence * (ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_min_damage', 0) * 0.5);
									}
									else
									{
										damageMax = maxTargetEssence * ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_max_damage', 0); 
										
										damageMin = maxTargetEssence * ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_min_damage', 0);
									}
								}
								else if (ACS_Settings_Main_Int('acs_damage_settings','acs_vampire_claws_damage_max_health_or_current_health', 0) == 1)
								{
									if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
									|| npc.GetRadius() >= 0.7
									|| npc.HasAbility('Boss')
									|| npc.HasTag('IsBoss')
									|| npc.HasTag('ACS_Big_Boi')
									)
									{
										damageMax = curTargetEssence * (ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_max_damage', 0) * 0.5); 
										
										damageMin = curTargetEssence * (ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_min_damage', 0) * 0.5);
									}
									else
									{
										damageMax = curTargetEssence * ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_max_damage', 0); 
										
										damageMin = curTargetEssence * ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_monster_min_damage', 0);
									}
								}

								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

								action.processedDmg.essenceDamage += RandRangeF(damageMax,damageMin);
							}
							else
							{
								if (GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_SilverSword))
								{
									vampireDmgValSilver = GetWitcherPlayer().GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

									if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
									|| npc.GetRadius() >= 0.7
									|| npc.HasAbility('Boss')
									|| npc.HasTag('IsBoss')
									|| npc.HasTag('ACS_Big_Boi')
									)
									{
										action.processedDmg.essenceDamage += vampireDmgValSilver * 0.25;
									}
									else
									{
										action.processedDmg.essenceDamage += vampireDmgValSilver;
									}
								}
								else
								{
									if (GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_SteelSword))
									{
										vampireDmgValSteel = GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_SLASHING, GetInvalidUniqueId()) 
										+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_PIERCING, GetInvalidUniqueId())
										+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_BLUDGEONING, GetInvalidUniqueId());

										if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
										|| npc.GetRadius() >= 0.7
										|| npc.HasAbility('Boss')
										|| npc.HasTag('IsBoss')
										|| npc.HasTag('ACS_Big_Boi')
										)
										{
											action.processedDmg.vitalityDamage += vampireDmgValSteel * 0.25;
										}
										else
										{
											action.processedDmg.vitalityDamage += vampireDmgValSteel;
										}
									}
									else
									{
										if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
										|| npc.GetRadius() >= 0.7
										|| npc.HasAbility('Boss')
										|| npc.HasTag('IsBoss')
										|| npc.HasTag('ACS_Big_Boi')
										)
										{
											action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.025, 0);
										}
										else
										{
											action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.05, 0);
										}
									}
								}
							}

							if ( GetWitcherPlayer().HasTag('ACS_Vampire_Dash_Attack') )
							{
								action.processedDmg.essenceDamage += (npc.GetStatMax(BCS_Essence)  - npc.GetStat(BCS_Essence) ) * 0.15;

								GetWitcherPlayer().RemoveTag('ACS_Vampire_Dash_Attack');
							}
						}
						else if (npc.UsesVitality())
						{
							GetWitcherPlayer().GainStat( BCS_Focus, GetWitcherPlayer().GetStatMax( BCS_Focus) * 0.05 );

							if (ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_human_max_damage', 0) != 0 
							&& ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_human_min_damage', 0) != 0 )
							{
								maxTargetVitality = npc.GetStatMax( BCS_Vitality );

								curTargetVitality = npc.GetStat( BCS_Vitality );

								if (ACS_Settings_Main_Int('acs_damage_settings','acs_vampire_claws_damage_max_health_or_current_health', 0) == 0)
								{
									damageMax = maxTargetVitality * ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_human_max_damage', 0); 
									
									damageMin = maxTargetVitality * ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_human_min_damage', 0); 
								}
								else if (ACS_Settings_Main_Int('acs_damage_settings','acs_vampire_claws_damage_max_health_or_current_health', 0) == 1)
								{
									damageMax = curTargetVitality * ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_human_max_damage', 0); 
									
									damageMin = curTargetVitality * ACS_Settings_Main_Float('acs_damage_settings','acs_vampire_claws_human_min_damage', 0); 
								}

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

								action.processedDmg.vitalityDamage += RandRangeF(damageMax,damageMin);
							}
							else
							{
								if (GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_SteelSword))
								{
									vampireDmgValSteel = GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_SLASHING, GetInvalidUniqueId()) 
									+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_PIERCING, GetInvalidUniqueId())
									+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_BLUDGEONING, GetInvalidUniqueId());

									if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
									|| npc.GetRadius() >= 0.7
									|| npc.HasAbility('Boss')
									|| npc.HasTag('IsBoss')
									|| npc.HasTag('ACS_Big_Boi')
									)
									{
										action.processedDmg.vitalityDamage += vampireDmgValSteel * 0.25;
									}
									else
									{
										action.processedDmg.vitalityDamage += vampireDmgValSteel;
									}
								}
								else
								{
									if (GetWitcherPlayer().IsAnyItemEquippedOnSlot(EES_SilverSword))
									{
										vampireDmgValSilver = GetWitcherPlayer().GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

										if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
										|| npc.GetRadius() >= 0.7
										|| npc.HasAbility('Boss')
										|| npc.HasTag('IsBoss')
										|| npc.HasTag('ACS_Big_Boi')
										)
										{
											action.processedDmg.essenceDamage += vampireDmgValSilver * 0.25;
										}
										else
										{
											action.processedDmg.essenceDamage += vampireDmgValSilver;
										}
									}
									else
									{
										if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
										|| npc.GetRadius() >= 0.7
										|| npc.HasAbility('Boss')
										|| npc.HasTag('IsBoss')
										|| npc.HasTag('ACS_Big_Boi')
										)
										{
											action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.025, 0);
										}
										else
										{
											action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.05, 0);
										}
									}
								}
							}

							if ( GetWitcherPlayer().HasTag('ACS_Vampire_Dash_Attack') )
							{
								action.processedDmg.vitalityDamage += (npc.GetStatMax(BCS_Vitality) - npc.GetStat(BCS_Vitality)) * 0.15;

								GetWitcherPlayer().RemoveTag('ACS_Vampire_Dash_Attack');
							}
						}

						if( !npc.IsImmuneToBuff( EET_Bleeding ) && !npc.HasBuff( EET_Bleeding ) ) 
						{ 
							npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_vampire_claw_effects' );	
						}

						if( !npc.IsImmuneToBuff( EET_BleedingTracking ) && !npc.HasBuff( EET_BleedingTracking ) ) 
						{ 
							npc.AddEffectDefault( EET_BleedingTracking, GetWitcherPlayer(), 'acs_vampire_claw_effects' );	
						}
						
						if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
						{
							if (RandF() < 0.5 )
							{
								ACSGetCEntity('acs_vampire_extra_arms_1').PlayEffectSingle('blood');

								ACSGetCEntity('acs_vampire_extra_arms_1').StopEffect('blood');

								ACSGetCEntity('acs_vampire_extra_arms_2').PlayEffectSingle('blood');

								ACSGetCEntity('acs_vampire_extra_arms_2').StopEffect('blood');

								ACSGetCEntity('acs_vampire_extra_arms_3').PlayEffectSingle('blood');

								ACSGetCEntity('acs_vampire_extra_arms_3').StopEffect('blood');

								ACSGetCEntity('acs_vampire_extra_arms_4').PlayEffectSingle('blood');

								ACSGetCEntity('acs_vampire_extra_arms_4').StopEffect('blood');

								GetWitcherPlayer().PlayEffectSingle('blood_effect_claws');
								GetWitcherPlayer().StopEffect('blood_effect_claws');
							}
						}

						if (GetWitcherPlayer().IsGuarded())
						{
							GetWitcherPlayer().GainStat( BCS_Vitality, heal ); 

							GetACSWatcher().ShowHealFloatingValue( heal, true);
						}
						else
						{
							GetWitcherPlayer().GainStat( BCS_Vitality, heal * 2 ); 

							GetACSWatcher().ShowHealFloatingValue( heal * 2, true);
						}
						
						GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

						GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_hit_claws");

						GetWitcherPlayer().RemoveTag('ACS_Vampire_Dash_Attack');

						return;
					}	

					if (
					GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if (GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active'))
						{
							if (npc.UsesEssence())
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
							else if (npc.UsesVitality())
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}

							action.SetCanPlayHitParticle(false);
							action.SetSuppressHitSounds(true);
							action.SuppressHitSounds();
						}

						if (GetWitcherPlayer().HasTag('ACS_Sparagmos_Active'))
						{
							if (npc.UsesEssence())
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
							else if (npc.UsesVitality())
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}

							action.SetCanPlayHitParticle(false);
							action.SetSuppressHitSounds(true);
							action.SuppressHitSounds();
						}

						if (GetWitcherPlayer().HasTag('ACS_AardPull_Active'))
						{
							GetWitcherPlayer().GainStat( BCS_Stamina, GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.1 );
						}

						if (npc.IsHuman())
						{
							if (
							(npc.GetStat( BCS_Vitality ) <= npc.GetStatMax( BCS_Vitality ) * 0.25)
							&& npc.HasTag('ACS_taunted')
							)
							{
								if (!npc.HasTag('ACS_mettle'))
								{
									((CNewNPC)npc).SetLevel( GetWitcherPlayer().GetLevel() * 2 );
									
									// npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_weapon_effects' );	
									
									npc.AddTag('ContractTarget');
									npc.AddTag('MonsterHuntTarget');

									npc.RemoveBuffImmunity_AllNegative();

									npc.RemoveBuffImmunity_AllCritical();

									if (npc.UsesEssence())
									{
										npc.StartEssenceRegen();
									}
									else
									{
										npc.StartVitalityRegen();
									}
										
									if ( !npc.HasBuff( EET_IgnorePain ) )
									{
										npc.AddEffectDefault( EET_IgnorePain, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WellFed ) )
									{
										npc.AddEffectDefault( EET_WellFed, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WellHydrated ) )
									{
										npc.AddEffectDefault( EET_WellHydrated, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoStaminaRegen ) )
									{
										npc.AddEffectDefault( EET_AutoStaminaRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoEssenceRegen ) )
									{
										npc.AddEffectDefault( EET_AutoEssenceRegen, npc, 'console' );
									}
									
									if ( !npc.HasBuff( EET_AutoMoraleRegen ) )
									{
										npc.AddEffectDefault( EET_AutoMoraleRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoPanicRegen ) )
									{
										npc.AddEffectDefault( EET_AutoPanicRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoVitalityRegen ) )
									{
										npc.AddEffectDefault( EET_AutoVitalityRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_BoostedStaminaRegen ) )
									{
										npc.AddEffectDefault( EET_BoostedStaminaRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WeatherBonus ) )
									{
										npc.AddEffectDefault( EET_WeatherBonus, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_Thunderbolt ) )
									{
										npc.AddEffectDefault( EET_Thunderbolt, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AbilityOnLowHealth ) )
									{
										npc.AddEffectDefault( EET_AbilityOnLowHealth, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_EnhancedArmor ) )
									{
										npc.AddEffectDefault( EET_EnhancedArmor, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_EnhancedWeapon ) )
									{
										npc.AddEffectDefault( EET_EnhancedWeapon, npc, 'console' );
									}
								
									
									npc.AddTag('ACS_mettle');
								}
							}
						}

						return;
					}

					if ( 
					GetWitcherPlayer().HasTag('acs_axii_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
					{
						if (GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active'))
						{
							if (npc.UsesEssence())
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.9;
							}
							else if (npc.UsesVitality())
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
							}

							action.SetCanPlayHitParticle(false);
							action.SetSuppressHitSounds(true);
							action.SuppressHitSounds();
						}

						if (GetWitcherPlayer().HasTag('ACS_Sparagmos_Active'))
						{
							if (npc.UsesEssence())
							{
								action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
							}
							else if (npc.UsesVitality())
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
							}

							action.SetCanPlayHitParticle(false);
							action.SetSuppressHitSounds(true);
							action.SuppressHitSounds();
						}

						if (npc.IsHuman())
						{
							if (
							(npc.GetStat( BCS_Vitality ) <= npc.GetStatMax( BCS_Vitality ) * 0.25)
							&& npc.HasTag('ACS_taunted')
							)
							{	
								if (!npc.HasTag('ACS_mettle'))
								{
									((CNewNPC)npc).SetLevel( GetWitcherPlayer().GetLevel() * 2 );
									
									npc.AddTag('ContractTarget');
									npc.AddTag('MonsterHuntTarget');

									npc.RemoveBuffImmunity_AllNegative();

									npc.RemoveBuffImmunity_AllCritical();

									if (npc.UsesEssence())
									{
										npc.StartEssenceRegen();
									}
									else
									{
										npc.StartVitalityRegen();
									}
										
									if ( !npc.HasBuff( EET_IgnorePain ) )
									{
										npc.AddEffectDefault( EET_IgnorePain, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WellFed ) )
									{
										npc.AddEffectDefault( EET_WellFed, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WellHydrated ) )
									{
										npc.AddEffectDefault( EET_WellHydrated, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoStaminaRegen ) )
									{
										npc.AddEffectDefault( EET_AutoStaminaRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoEssenceRegen ) )
									{
										npc.AddEffectDefault( EET_AutoEssenceRegen, npc, 'console' );
									}
									
									if ( !npc.HasBuff( EET_AutoMoraleRegen ) )
									{
										npc.AddEffectDefault( EET_AutoMoraleRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoPanicRegen ) )
									{
										npc.AddEffectDefault( EET_AutoPanicRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoVitalityRegen ) )
									{
										npc.AddEffectDefault( EET_AutoVitalityRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_BoostedStaminaRegen ) )
									{
										npc.AddEffectDefault( EET_BoostedStaminaRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WeatherBonus ) )
									{
										npc.AddEffectDefault( EET_WeatherBonus, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_Thunderbolt ) )
									{
										npc.AddEffectDefault( EET_Thunderbolt, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AbilityOnLowHealth ) )
									{
										npc.AddEffectDefault( EET_AbilityOnLowHealth, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_EnhancedArmor ) )
									{
										npc.AddEffectDefault( EET_EnhancedArmor, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_EnhancedWeapon ) )
									{
										npc.AddEffectDefault( EET_EnhancedWeapon, npc, 'console' );
									}
									
									npc.AddTag('ACS_mettle');
								}
							}
						}

						return;
					}

					if 
					(
					(GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
					|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped'))
					)
					{
						if (ACS_Armor_Set_Check('griffin', true)
						&& GetWitcherPlayer().HasTag('ACS_Griffin_Special_Attack'))
						{
							if ( GetWitcherPlayer().GetEquippedSign() == ST_Igni )
							{
								npc.AddEffectDefault( EET_Burning, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
							}
							else if ( GetWitcherPlayer().GetEquippedSign() == ST_Axii )
							{
								npc.AddEffectDefault( EET_Confusion, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
							}
							else if ( GetWitcherPlayer().GetEquippedSign() == ST_Aard )
							{
								npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
							}
							else if ( GetWitcherPlayer().GetEquippedSign() == ST_Quen )
							{
								npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
							}
							else if ( GetWitcherPlayer().GetEquippedSign() == ST_Yrden )
							{
								npc.AddEffectDefault( EET_Slowdown, GetWitcherPlayer(), 'ACS_Griffin_Special_Attack' );	
							}
						}

						if (ACS_Armor_Set_Check('bear', true)
						&& GetWitcherPlayer().HasTag('ACS_Bear_Special_Attack'))
						{
							npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Bear_Special_Attack' );
						}

						if (ACS_Armor_Set_Check('viper', true))
						{
							if (GetWitcherPlayer().HasTag('ACS_Viper_Special_Attack')

							)
							{
								npc.AddEffectDefault( EET_Poison, GetWitcherPlayer(), 'ACS_Viper_Special_Attack' );

								thePlayer.RemoveTag('ACS_Viper_Special_Attack');
							}

							if (GetWitcherPlayer().HasTag('ACS_Viper_Dagger_Attack')
							)
							{
								npc.AddEffectDefault( EET_Poison, GetWitcherPlayer(), 'ACS_Viper_Dagger_Attack' );

								thePlayer.RemoveTag('ACS_Viper_Dagger_Attack');
							}
						}

						if (npc.IsHuman())
						{
							if (
							(npc.GetStat( BCS_Vitality ) <= npc.GetStatMax( BCS_Vitality ) * 0.25)
							&& npc.HasTag('ACS_taunted')
							)
							{
								if (!npc.HasTag('ACS_mettle'))
								{
								
									((CNewNPC)npc).SetLevel( (GetWitcherPlayer().GetLevel() * 7 ) / 4 );
									
									npc.AddTag('ContractTarget');
									npc.AddTag('MonsterHuntTarget');
									
									npc.RemoveBuffImmunity_AllNegative();

									npc.RemoveBuffImmunity_AllCritical();

									if (npc.UsesEssence())
									{
										npc.StartEssenceRegen();
									}
									else
									{
										npc.StartVitalityRegen();
									}
										
									if ( !npc.HasBuff( EET_IgnorePain ) )
									{
										npc.AddEffectDefault( EET_IgnorePain, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WellFed ) )
									{
										npc.AddEffectDefault( EET_WellFed, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WellHydrated ) )
									{
										npc.AddEffectDefault( EET_WellHydrated, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoStaminaRegen ) )
									{
										npc.AddEffectDefault( EET_AutoStaminaRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoEssenceRegen ) )
									{
										npc.AddEffectDefault( EET_AutoEssenceRegen, npc, 'console' );
									}
									
									if ( !npc.HasBuff( EET_AutoMoraleRegen ) )
									{
										npc.AddEffectDefault( EET_AutoMoraleRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoPanicRegen ) )
									{
										npc.AddEffectDefault( EET_AutoPanicRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AutoVitalityRegen ) )
									{
										npc.AddEffectDefault( EET_AutoVitalityRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_BoostedStaminaRegen ) )
									{
										npc.AddEffectDefault( EET_BoostedStaminaRegen, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_WeatherBonus ) )
									{
										npc.AddEffectDefault( EET_WeatherBonus, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_Thunderbolt ) )
									{
										npc.AddEffectDefault( EET_Thunderbolt, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_AbilityOnLowHealth ) )
									{
										npc.AddEffectDefault( EET_AbilityOnLowHealth, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_EnhancedArmor ) )
									{
										npc.AddEffectDefault( EET_EnhancedArmor, npc, 'console' );
									}
										
									if ( !npc.HasBuff( EET_EnhancedWeapon ) )
									{
										npc.AddEffectDefault( EET_EnhancedWeapon, npc, 'console' );
									}
								
									
									npc.AddTag('ACS_mettle');
								}
							}
						}

						return;
					}
				}
				else
				{
					((CNewNPC)npc).ACS_DealPostureDamage(1);
				}
			}
		}

		/*
		if (FactsQuerySum("acs_transformation_activated") > 0)
		{
			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Killed_By_Transformed_Entity'))
				{
					npc.DestroyAfter(10);

					npc.AddTag('ACS_Killed_By_Transformed_Entity');
				}
			}
		}
		*/
	}
}

function ACS_Player_Modifier_Attack(action: W3DamageAction)
{
	var playerAttacker, playerVictim																																		: CPlayer;
	var npc, npcAttacker 																																					: CActor;
	var dmg																																									: W3DamageAction;
	var damageMax, damageMin, dmgValSilver, dmgValSteel																														: float;
	var heal, playerVitality 																																				: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence, finisherDist, vampireDmgValSteel, vampireDmgValSilver										: float;
	var item_steel, item_silver																																				: SItemUniqueId;
	var animatedComponentA 																																					: CAnimatedComponent;
	var hitLag, targetDistance																																				: float;
    var ent_1                      																																			: CEntity;
	var rot_1         																																						: EulerAngles;
	var pos_1																																								: Vector;
	var targetPosition																																						: Vector;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	heal = GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.025;

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

	GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

	if(GetWitcherPlayer().IsAnyQuenActive() 
	&& GetWitcherPlayer().GetSignEntity(ST_Igni).IsAlternateCast()
	&& thePlayer.IsCastingSign()
	)
	{
		action.AddDamage( theGame.params.DAMAGE_NAME_SHOCK, 50 );

		action.AddEffectInfo(EET_Paralyzed, 1);
	}

	if (thePlayer.HasTag('ACS_Flammable_Oil_Enabled')
	&& action.IsActionMelee() 
	)
	{
		//ACSCreateGolemGroundFireFX(npc.GetWorldPosition(), npc.GetWorldRotation());

		ACSCreateFireHitFX(npc.GetWorldPosition(), npc.GetWorldRotation());
		
		if (ACS_GetItem_SwordHeldSwitchBasedUponStat('frost_sword'))
		{
			theSound.SoundEvent("ep2_mutations_06_frosty_aard");

			action.AddDamage( theGame.params.DAMAGE_NAME_FROST, 100 + 100 * ACS_SignIntensityPercentage('total') * 0.5 );

			action.AddEffectInfo( EET_Frozen, 1 + 1 * ACS_SignIntensityPercentage('total') );
		}
		else if (ACS_GetItem_SwordHeldSwitchBasedUponStat('poison_sword'))
		{
			if ( !theSound.SoundIsBankLoaded("ep2_mutations_04.bnk") )
			{
				theSound.SoundLoadBank( "ep2_mutations_04.bnk", false );
			}

			theSound.SoundEvent("ep2_mutations_04_poison_blood_spray_enemy");

			action.AddDamage( theGame.params.DAMAGE_NAME_POISON, 100 + 100 * ACS_SignIntensityPercentage('total') * 0.5 );

			action.AddEffectInfo( EET_Poison, 1 + 1 * ACS_SignIntensityPercentage('total') );
		}
		else if (ACS_GetItem_SwordHeldSwitchBasedUponStat('bleed_sword'))
		{
			if ( !theSound.SoundIsBankLoaded("monster_barghest.bnk") )
			{
				theSound.SoundLoadBank( "monster_barghest.bnk", false );
			}

			theSound.SoundEvent("monster_barghest_combat_blood_flames");

			action.AddDamage( theGame.params.DAMAGE_NAME_SLASHING, 100 + 100 * ACS_SignIntensityPercentage('total') * 0.5 );

			action.AddEffectInfo( EET_Bleeding, 1 + 1 * ACS_SignIntensityPercentage('total') );
		}
		else
		{
			theSound.SoundEvent("fx_fire_geralt_fire_hit");

			theSound.SoundEvent("fx_fire_burning_strong_begin");

			theSound.SoundEvent("fx_fire_burning_strong_end");

			action.AddDamage( theGame.params.DAMAGE_NAME_FIRE, 100 + 100 * ACS_SignIntensityPercentage('total') * 0.5 );

			action.AddEffectInfo( EET_Burning, 1 + 1 * ACS_SignIntensityPercentage('total') );
		}	
	}

	if (ACSGetCActor('ACS_Gravehag_Tongue_Weapon_R')
	&& action.IsActionMelee() 
	)
	{
		if (ACSGetCActor('ACS_Gravehag_Tongue_Weapon_R').HasTag('ACS_Mourntart_Tongue'))
		{
			action.AddDamage( theGame.params.DAMAGE_NAME_POISON, 100 + 100 * ACS_SignIntensityPercentage('total') * 0.5 );

			action.AddEffectInfo( EET_Poison, 5 + 1 * ACS_SignIntensityPercentage('total') );

			if ((RandF() < 0.5)
			)
			{
				//action.AddEffectInfo( EET_HeavyKnockdown, 3 );

				npc.AddEffectDefault( EET_HeavyKnockdown, thePlayer, 'ACS_Gravehag_Tongue_Weapon' ); 	

				if (!npc.HasTag('ACS_Gravehag_Tongue_Weapon_R'))
				{
					ACS_CreateMourntartPoisonExplosion(npc.GetWorldPosition(), npc.GetWorldRotation());
				}
			}
		}
		else
		{
			action.AddDamage( theGame.params.DAMAGE_NAME_POISON, 25 + 25 * ACS_SignIntensityPercentage('total') * 0.5 );

			action.AddEffectInfo( EET_Poison, 1 + 1 * ACS_SignIntensityPercentage('total') );
		}
	}

	if (thePlayer.HasTag('ACS_Ghost_Stance_Active')
	&& action.IsActionMelee()
	)
	{
		GetWitcherPlayer().AddTimer( 'RemoveForceFinisher', 0.0, false );

		if (!npc.HasAbility('DisableFinishers'))
		{
			npc.AddAbility( 'DisableFinishers', true);
		}

		if (npc.HasAbility('ForceFinisher'))
		{
			npc.RemoveAbility( 'ForceFinisher');
		} 

		npc.SignalGameplayEvent('DisableFinisher');

		rot_1 = thePlayer.GetWorldRotation();

		pos_1 = thePlayer.GetWorldPosition();
		
		switch ( action.GetSwingType() )
		{
			case AST_Horizontal:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot_1.Roll -= 90;
					break;

					case ASD_RightLeft: 	
						rot_1.Roll += 90;
					break;

					default: 
						if (RandF() < 0.5)
						{
							rot_1.Roll -= 90;
						}
						else
						{
							rot_1.Roll += 90;
						}
					break;
				}
				break;
			
			break;

			case AST_Vertical:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_UpDown: 		
						rot_1.Roll += 0;
					break;

					case ASD_DownUp: 		
						rot_1.Roll += RandRangeF(195,165);	
					break;

					default:
						rot_1.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_DiagonalUp:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot_1.Roll += RandRangeF(150,120);		
					break;

					case ASD_RightLeft: 	
						rot_1.Roll -= RandRangeF(150,120);		
					break;

					default: 
						rot_1.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_DiagonalDown:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot_1.Roll += RandRangeF(60,30);		
					break;

					case ASD_RightLeft: 	
						rot_1.Roll -= RandRangeF(60,30);		
					break;

					default: 
						rot_1.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_Jab:
				
				rot_1.Roll += 0;	
				rot_1.Pitch += RandRangeF(105,75);			
				
			break;

			default :					
				rot_1.Roll += 0;	
			break;
		}

		if ( npc.GetBoneIndex('torso') != -1 )
		{
			targetPosition = npc.GetBoneWorldPosition('torso');

			if (targetPosition.Z > pos_1.Z + RandRangeF(1.5f,1.125f))
			{
				targetPosition.Z = pos_1.Z + RandRangeF(1.5f,1.125f);
			}
			else
			{
				targetPosition.Z += RandRangeF(0.125,-0.125);
			}

			targetPosition.X += RandRangeF(0.125,-0.125);
			targetPosition.Y += RandRangeF(0.125,-0.125);
		}
		else
		{
			if ( npc.GetBoneIndex('k_torso_g') != -1 )
			{
				targetPosition = npc.GetBoneWorldPosition('k_torso_g');

				if (targetPosition.Z > pos_1.Z + RandRangeF(1.5f,1.125f))
				{
					targetPosition.Z = pos_1.Z + RandRangeF(1.5f,1.125f);
				}
				else
				{
					targetPosition.Z += RandRangeF(0.125,-0.125);
				}

				targetPosition.X += RandRangeF(0.125,-0.125);
				targetPosition.Y += RandRangeF(0.125,-0.125);
			}
			else
			{
				targetPosition = npc.GetWorldPosition();
				targetPosition.Z = pos_1.Z + RandRangeF(1.5f,1.125f);
				targetPosition.X += RandRangeF(0.125,-0.125);
				targetPosition.Y += RandRangeF(0.125,-0.125);
			}
		}

		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"

		, true ), targetPosition, rot_1 );

		ent_1.PlayEffectSingle('sword_slash');

		ent_1.PlayEffectSingle('sword_slash_red');

		ent_1.PlayEffectSingle('sword_slash_red_large');

		ent_1.DestroyAfter(2.5);

		if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
		|| npc.GetRadius() >= 0.7
		|| npc.HasAbility('Boss')
		|| npc.HasTag('IsBoss')
		|| npc.HasTag('ACS_Big_Boi')
		)
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

				action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.3;
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.3;
			}
		}
		else
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

				action.processedDmg.essenceDamage += 99999;
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				action.processedDmg.vitalityDamage += 99999;
			}
		}

		if(RandF() < 0.5)
		{
			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");
		}
		else
		{
			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
		}

		GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

		GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

		if (ACS_Armor_Set_Check('acs_armor', false))
		{
			GetWitcherPlayer().SoundEvent("monster_caretaker_fx_black_exhale");

			GetWitcherPlayer().SoundEvent("monster_caretaker_fx_summon");
		}

		thePlayer.DestroyEffect('dodge_acs_armor');
		thePlayer.PlayEffectSingle('dodge_acs_armor');

		thePlayer.DrainFocus( thePlayer.GetStatMax( BCS_Focus ) * 0.33);


		if (GetACSWatcher().ghost_stance_active_kill_count >= 7)
		{
			GetACSWatcher().Ghost_Stance_Kill_Increment(true, 0);
		}
		else
		{
			GetACSWatcher().Ghost_Stance_Kill_Increment(true, 1);
		}

		return;
	}

	if (thePlayer.HasTag('ACS_In_Dance_Of_Wrath')
	&& action.IsActionMelee() 
	)
	{
		GetWitcherPlayer().AddTimer( 'RemoveForceFinisher', 0.0, false );

		if (!npc.HasAbility('DisableFinishers'))
		{
			npc.AddAbility( 'DisableFinishers', true);
		}

		if (npc.HasAbility('ForceFinisher'))
		{
			npc.RemoveAbility( 'ForceFinisher');
		} 

		npc.SignalGameplayEvent('DisableFinisher');

		if(RandF() < 0.5)
		{
			thePlayer.SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_01");
		}
		else
		{
			thePlayer.SoundEvent("monster_dettlaff_monster_combat_geralt_deathblow_02");
		}

		rot_1 = thePlayer.GetWorldRotation();

		pos_1 = thePlayer.GetWorldPosition();
		
		switch ( action.GetSwingType() )
		{
			case AST_Horizontal:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot_1.Roll -= 90;
					break;

					case ASD_RightLeft: 	
						rot_1.Roll += 90;
					break;

					default: 
						if (RandF() < 0.5)
						{
							rot_1.Roll -= 90;
						}
						else
						{
							rot_1.Roll += 90;
						}
					break;
				}
				break;
			
			break;

			case AST_Vertical:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_UpDown: 		
						rot_1.Roll += 0;
					break;

					case ASD_DownUp: 		
						rot_1.Roll += RandRangeF(195,165);	
					break;

					default:
						rot_1.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_DiagonalUp:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot_1.Roll += RandRangeF(150,120);		
					break;

					case ASD_RightLeft: 	
						rot_1.Roll -= RandRangeF(150,120);		
					break;

					default: 
						rot_1.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_DiagonalDown:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot_1.Roll += RandRangeF(60,30);		
					break;

					case ASD_RightLeft: 	
						rot_1.Roll -= RandRangeF(60,30);		
					break;

					default: 
						rot_1.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_Jab:
				
				rot_1.Roll += 0;	
				rot_1.Pitch += RandRangeF(105,75);			
				
			break;

			default :					
				rot_1.Roll += 0;	
			break;
		}

		if ( npc.GetBoneIndex('torso') != -1 )
		{
			targetPosition = npc.GetBoneWorldPosition('torso');

			if (targetPosition.Z > pos_1.Z + RandRangeF(1.5f,1.125f))
			{
				targetPosition.Z = pos_1.Z + RandRangeF(1.5f,1.125f);
			}
			else
			{
				targetPosition.Z += RandRangeF(0.125,-0.125);
			}

			targetPosition.X += RandRangeF(0.125,-0.125);
			targetPosition.Y += RandRangeF(0.125,-0.125);
		}
		else
		{
			if ( npc.GetBoneIndex('k_torso_g') != -1 )
			{
				targetPosition = npc.GetBoneWorldPosition('k_torso_g');

				if (targetPosition.Z > pos_1.Z + RandRangeF(1.5f,1.125f))
				{
					targetPosition.Z = pos_1.Z + RandRangeF(1.5f,1.125f);
				}
				else
				{
					targetPosition.Z += RandRangeF(0.125,-0.125);
				}

				targetPosition.X += RandRangeF(0.125,-0.125);
				targetPosition.Y += RandRangeF(0.125,-0.125);
			}
			else
			{
				targetPosition = npc.GetWorldPosition();
				targetPosition.Z = pos_1.Z + RandRangeF(1.5f,1.125f);
				targetPosition.X += RandRangeF(0.125,-0.125);
				targetPosition.Y += RandRangeF(0.125,-0.125);
			}
		}

		ent_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent"

		, true ), targetPosition, rot_1 );

		ent_1.PlayEffectSingle('sword_slash');

		ent_1.PlayEffectSingle('sword_slash_red');

		ent_1.PlayEffectSingle('sword_slash_red_large');

		ent_1.DestroyAfter(2.5);

		if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
		|| npc.GetRadius() >= 0.7
		|| npc.HasAbility('Boss')
		|| npc.HasTag('IsBoss')
		|| npc.HasTag('ACS_Big_Boi')
		)
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

				if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv1'))
				{
					action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.04125;
				}
				else if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv2'))
				{
					action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.0825;
				}
				else if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv3'))
				{
					action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.165;
				}
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv1'))
				{
					action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.04125;
				}
				else if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv2'))
				{
					action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.0825;
				}
				else if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv3'))
				{
					action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.165;
				}
			}
		}
		else
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

				if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv1'))
				{
					action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.0825;
				}
				else if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv2'))
				{
					action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.165;
				}
				else if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv3'))
				{
					action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.33;
				}
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv1'))
				{
					action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.0825;
				}
				else if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv2'))
				{
					action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.165;
				}
				else if(GetWitcherPlayer().HasTag('ACS_Dance_Of_Wrath_Lv3'))
				{
					action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.33;
				}
			}
		}
	}
}

function ACS_Player_Guard(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var vACS_Shield_Summon 									: cACS_Shield_Summon;
	var hit_anim_names										: array< name >;
	var parry_sound_names									: array< string >;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	if( thePlayer.IsSailing() 
	|| thePlayer.IsUsingHorse() 
	|| thePlayer.IsUsingVehicle() 
	|| ((W3Action_Attack)action).IsCountered()
	)
	{
		return;
	}

    if ( playerVictim
	//&& !playerAttacker
	&& action.GetBuffSourceName() != "vampirism" 
	&& (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().IsInGuardedState() || theInput.GetActionValue('LockAndGuard') > 0.5)
	&& !GetWitcherPlayer().IsPerformingFinisher()
	&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !action.WasDodged()
	&& !GetWitcherPlayer().IsInFistFightMiniGame() 
	&& !GetWitcherPlayer().HasTag('ACS_Camo_Active')
	//&& !GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
	//&& !GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
	)
	{
		if (
		((CNewNPC)npcAttacker).HasTag('ACS_Big_Boi')
		|| ((CNewNPC)npcAttacker).HasAbility('mon_toad_base')
		|| ((CNewNPC)npcAttacker).HasAbility('mon_type_huge')
		|| ((CMovingPhysicalAgentComponent)((npcAttacker).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
		|| ((CNewNPC)npcAttacker).GetRadius() >= 0.7
		)
		{
			thePlayer.ACS_DealPlayerPostureDamage(20, true);
		}
		else
		{
			thePlayer.ACS_DealPlayerPostureDamage(10, true);
		}

		GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_attack_guarded_camera_shake_strength', 0.2), true, thePlayer.GetWorldPosition(), 30 );

		hit_anim_names.Clear();

		if(
		(GetWitcherPlayer().GetStat(BCS_Stamina) >= GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.1)
		)
		{
			if ( GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') 
			|| ACS_Vampire_Claws_Access()
			)
			{
				if (!thePlayer.HasTag('ACS_Dual_Wield_Active') && !ACSGetCEntity('ACS_Viper_Dagger_L')){thePlayer.RaiseEvent('ACS_ForceHandClosedLEnd');}

				action.SetHitReactionType(0, false);
				action.ClearDamage();
				action.ClearEffects();
				action.SuppressHitSounds();
				action.SetWasDodged();
				action.SetCannotReturnDamage(true);

				ticket = movementAdjustor.GetRequest( 'ACS_Vamp_Claws_Parry_Rotate');
				movementAdjustor.CancelByName( 'ACS_Vamp_Claws_Parry_Rotate' );
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Vamp_Claws_Parry_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				GetWitcherPlayer().SetPlayerTarget( npcAttacker );

				GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

				GetWitcherPlayer().UpdateDisplayTarget( true );

				GetWitcherPlayer().UpdateLookAtTarget();

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				if (ACS_Settings_Main_Bool('acs_stamina_settings','acs_parrying_stamina_cost_action', false))
				{
					ACS_Tutorial_Display_Check('ACS_Parry_Tutorial_Shown');

					if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
					{
						if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 0.25), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 4, );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, (GetWitcherPlayer().GetStatMax(BCS_Stamina) * ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1)), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1), );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 2), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.5, );
						}
						else
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 4), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.25, );
						}
					}
					else
					{
						GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 4), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.25, );
					}
				}
	
				if (RandF() < 0.5)
				{
					hit_anim_names.PushBack('bruxa_parry_center_ACS');

					GetWitcherPlayer().StopEffect('left_sparks');
					GetWitcherPlayer().PlayEffectSingle('left_sparks');

					GetWitcherPlayer().StopEffect('right_sparks');
					GetWitcherPlayer().PlayEffectSingle('right_sparks');
				}
				else
				{
					if ( RandF() < 0.5 )
					{
						hit_anim_names.PushBack('bruxa_parry_left_ACS');

						GetWitcherPlayer().StopEffect('left_sparks');
						GetWitcherPlayer().PlayEffectSingle('left_sparks');
					}
					else
					{
						hit_anim_names.PushBack('bruxa_parry_right_ACS');

						GetWitcherPlayer().StopEffect('right_sparks');
						GetWitcherPlayer().PlayEffectSingle('right_sparks');
					}
				}
			
				playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( hit_anim_names[RandRange(hit_anim_names.Size())], 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
			}
			else if ( GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
			{
				vACS_Shield_Summon = new cACS_Shield_Summon in theGame;

				vACS_Shield_Summon.Axii_Persistent_Shield_Summon();

				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				if (ACS_Settings_Main_Bool('acs_stamina_settings','acs_parrying_stamina_cost_action', false))
				{
					ACS_Tutorial_Display_Check('ACS_Parry_Tutorial_Shown');

					if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
					{
						if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 0.25), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 4, );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, (GetWitcherPlayer().GetStatMax(BCS_Stamina) * ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1)), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1), );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 2), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.5, );
						}
						else
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 4), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.25, );
						}
					}
					else
					{
						GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 4), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.25, );
					}
				}

				GetWitcherPlayer().SoundEvent("cmb_imlerith_shield_impact");

				hit_anim_names.PushBack('man_npc_shield_block_rp_03_ACS');
				hit_anim_names.PushBack('man_npc_shield_block_rp_02_ACS');
				hit_anim_names.PushBack('man_npc_shield_block_rp_01_ACS');
				hit_anim_names.PushBack('man_npc_shield_block_lp_03_ACS');
				hit_anim_names.PushBack('man_npc_shield_block_lp_02_ACS');  
				hit_anim_names.PushBack('man_npc_shield_block_lp_01_ACS');

				playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( hit_anim_names[RandRange(hit_anim_names.Size())], 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );

				ACSGetCEntity('ACS_Shield').PlayEffectSingle('aard_cone_hit');
				ACSGetCEntity('ACS_Shield').StopEffect('aard_cone_hit');

				ACSGetCEntity('ACS_Shield').PlayEffectSingle('light_block');
				ACSGetCEntity('ACS_Shield').StopEffect('light_block');

				ACSGetCEntity('ACS_Shield').PlayEffectSingle('heavy_block');
				ACSGetCEntity('ACS_Shield').StopEffect('heavy_block');
			}
			else if ( ACS_Armor_Set_Check('manticore', true) && ACSGetCEntity('ACS_ManticoreShield') )
			{
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				if (ACS_Settings_Main_Bool('acs_stamina_settings','acs_parrying_stamina_cost_action', false))
				{
					ACS_Tutorial_Display_Check('ACS_Parry_Tutorial_Shown');

					GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.05, ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.25, );
				}

				GetWitcherPlayer().SoundEvent("cmb_imlerith_shield_impact");

				hit_anim_names.PushBack('man_npc_shield_block_rp_03_ACS');
				hit_anim_names.PushBack('man_npc_shield_block_rp_02_ACS');
				hit_anim_names.PushBack('man_npc_shield_block_rp_01_ACS');
				hit_anim_names.PushBack('man_npc_shield_block_lp_03_ACS');
				hit_anim_names.PushBack('man_npc_shield_block_lp_02_ACS');  
				hit_anim_names.PushBack('man_npc_shield_block_lp_01_ACS');

				playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( hit_anim_names[RandRange(hit_anim_names.Size())], 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );

				ACSGetCEntity('ACS_ManticoreShield').PlayEffectSingle('aard_cone_hit');
				ACSGetCEntity('ACS_ManticoreShield').StopEffect('aard_cone_hit');

				ACSGetCEntity('ACS_ManticoreShield').PlayEffectSingle('light_block');
				ACSGetCEntity('ACS_ManticoreShield').StopEffect('light_block');

				ACSGetCEntity('ACS_ManticoreShield').PlayEffectSingle('heavy_block');
				ACSGetCEntity('ACS_ManticoreShield').StopEffect('heavy_block');
			}
			else 
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(1.f, 1.f) );

				if (thePlayer.HasTag('ACS_Dual_Wield_Active'))
				{
					thePlayer.RaiseEvent('ACS_CombatExtraHeliotrop');

					if (!GetACSWatcher().combatExtraActive)
					{
						GetACSWatcher().SetCombatExtraStatus(true);
					}

					GetACSWatcher().RemoveTimer('combatExtraReset');
					GetACSWatcher().AddTimer('combatExtraReset', 0.4 , false );
				}

				if (thePlayer.HasTag('ACS_Spear_Transform_Active'))
				{
					if (RandF() < 0.5)
					{
						if (RandF() < 0.5)
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_guard_parry_1_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f) );
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_guard_parry_1_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f) );
						}
					}
					else
					{
						if (RandF() < 0.5)
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_guard_parry_2_lp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f) );
						}
						else
						{
							thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_guard_parry_2_rp_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f) );
						}
					}
				}

				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;


				if (ACS_Settings_Main_Bool('acs_stamina_settings','acs_parrying_stamina_cost_action', false))
				{
					ACS_Tutorial_Display_Check('ACS_Parry_Tutorial_Shown');

					if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
					{
						if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 0.25), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 4, );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, (GetWitcherPlayer().GetStatMax(BCS_Stamina) * ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1)), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1), );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 2), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.5, );
						}
						else
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 4), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.25, );
						}
					}
					else
					{
						GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_cost', 0.1) * 4), ACS_Settings_Main_Float('acs_stamina_settings','acs_parrying_stamina_regen_delay', 1) * 0.25, );
					}
				}
	
				GetWitcherPlayer().SoundEvent("grunt_vo_block");

				if (thePlayer.IsDeadlySwordHeld())
				{
					parry_sound_names.Clear();
					parry_sound_names.PushBack("block_01_sekiro_acs");
					parry_sound_names.PushBack("block_02_sekiro_acs");
					parry_sound_names.PushBack("block_03_sekiro_acs");
					parry_sound_names.PushBack("block_04_sekiro_acs");

					ACSGetCEntity('acs_sword_trail_3').StopEffect('light_block');
					ACSGetCEntity('acs_sword_trail_3').StopEffect('heavy_block');
					ACSGetCEntity('acs_sword_trail_3').StopEffect('counterattack');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_block');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('heavy_block');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('counterattack');

					GetWitcherPlayer().SoundEvent(parry_sound_names[RandRange(parry_sound_names.Size())]);

					thePlayer.SetBehaviorVariable( 'parryType', RandRange(9) );
					thePlayer.RaiseForceEvent( 'PerformParry' );
				}

				/*
				if (
				GetWitcherPlayer().IsGuarded()
				|| GetWitcherPlayer().IsInGuardedState()
				)
				{
					GetWitcherPlayer().SetGuarded(false);
					GetWitcherPlayer().OnGuardedReleased();	
				}
				*/

				movementAdjustor.RotateTowards( ticket, npcAttacker );
			}
		}
		else
		{
			if (ACS_Settings_Main_Bool('acs_stamina_settings','acs_parrying_stamina_cost_action', false))
			{
				if (GetWitcherPlayer().IsGuarded()
				|| GetWitcherPlayer().IsInGuardedState())
				{
					GetWitcherPlayer().SetGuarded(false);
					GetWitcherPlayer().OnGuardedReleased();	
				}
			}
		}

		thePlayer.RaiseEvent('ACS_TW1AnimsReset');
	}
}

function ACS_Create_Red_Quen_Hit_Effect()
{
	var ent, ent_2, ent_3, ent_4 		: CEntity;

	if (GetWitcherPlayer().IsAnyQuenActive())
	{
		if (ACS_Armor_Set_Check('forgotten_wolf', false) || ACS_Armor_Set_Check('acs_armor', false))
		{
			GetWitcherPlayer().PlayEffectSingle('red_quen_lasting_shield_hit');

			GetWitcherPlayer().StopEffect('red_quen_lasting_shield_hit');

			GetWitcherPlayer().PlayEffectSingle('red_lasting_shield_discharge');

			GetWitcherPlayer().StopEffect('red_lasting_shield_discharge');

			ent_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\pc_quen_mq1060.w2ent"
			, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

			ent_3.CreateAttachment( thePlayer, , Vector( 0, 0, 0.75 ), EulerAngles(0,0,0) );

			ent_3.PlayEffect('default_fx');
			ent_3.DestroyAfter(0.5);


			ent_4 = theGame.CreateEntity( (CEntityTemplate)LoadResource( 
			"dlc\dlc_acs\data\fx\pc_quen_hit_mq1060.w2ent"
			, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

			ent_4.CreateAttachment( thePlayer, , Vector( 0, 0, 0.75 ), EulerAngles(0,0,0) );

			ent_4.PlayEffect('discharge');
			ent_4.DestroyAfter(3);
		}
	}
}

function ACS_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																																																								: CPlayer;
	var npc, npcAttacker 																																																											: CActor;
	var movementAdjustor, movementAdjustorWerewolf, movementAdjustorVampiress, movementAdjustorTransformationVampireMonster, movementAdjustorRedMiasmal, movementAdjustorSharley, movementAdjustorBlackWolf															: CMovementAdjustor;
	var ticket, ticketWerewolf, ticketVampiress, ticketTransformationVampireMonster, ticketRedMiasmal, ticketSharley, ticketBlackWolf							 																									: SMovementAdjustmentRequestTicket;
	var item																																																														: SItemUniqueId;
	var dmg																																																															: W3DamageAction;
	var damageMax, damageMin, detonationTimer																																																						: float;
	var animatedComponentA 																																																											: CAnimatedComponent;
	var hitLag 																																																														: float;
    var buffs 																																																														: array<EEffectType>;
    var attackName 																																																													: name;
	var targetDistance																																																												: float;
	var parry_fx_temp																																																												: CEntityTemplate;
	var parry_fx																																																													: CEntity;
	var ent_3, ent_4 																																																												: CEntity;
	var finisher_anim_names																																																											: array< name >;
	var plantedBomb, plantedBombSecondary																																																							: W3Petard;
	var selectedItemId 																																																												: SItemUniqueId;
	var thrownEntity																																																												: CThrowable;
	var thrownEntityPath																																																											: String;
	var bonePosition																																																												: Vector;
	var boneRotation																																																												: EulerAngles;
	var vfxEnt_1, vfxEnt_2, vfxEnt_3																																																								: CEntity;
	var pos 																																																														: Vector;
	var rot 																																																														: EulerAngles;
	var targetPosition_1, targetPosition_2, targetPosition_3																																																		: Vector;
	var headingDiff, tilt_inversion																																																									: float;
	var light_hit_sound_names, heavy_hit_sound_names																																																				: array<string>;
	var light_hit_sound_names_primary, heavy_hit_sound_names_primary																																																: array<string>;
	var animatedComponentB																																																											: CAnimatedComponent;
	var damageSilver, damagePhysical 																																																								: float;
	var stored_grey_health																																																											: float;

	npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	if(
	thePlayer.IsSailing() 
	|| thePlayer.IsUsingHorse() 
	|| thePlayer.IsUsingVehicle() 
	)
	{
		if (thePlayer.IsUsingHorse() 
		&& playerVictim
		&& npcAttacker)
		{
			GetACSWatcher().HorseSpeakController('watch_out');
		}

		return;
	}

	if(
	playerVictim
	&& npcAttacker
	&& GetACSWatcher().stab_hostage_enabled
	&& ACSGetCActor('ACS_Stab_Hostage')
	&& !playerVictim.IsAttackerAtBack(npcAttacker)
	)
	{
		if (npcAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()))
		{
			thePlayer.SoundEvent("cmb_play_hit_light");
		}
		else if (npcAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
		{
			thePlayer.SoundEvent("cmb_play_hit_heavy");
		}

		dmg = new W3DamageAction in theGame.damageMgr;
				
		dmg.Initialize(GetWitcherPlayer(), ACSGetCActor('ACS_Stab_Hostage'), NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
		
		dmg.SetProcessBuffsIfNoDamage(true);
		
		dmg.SetHitReactionType( EHRT_Heavy, true);

		damageMax = action.processedDmg.vitalityDamage; 

		if (npcAttacker.UsesVitality()) 
		{ 
			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, damageMax );
		} 
		else if (npcAttacker.UsesEssence()) 
		{ 
			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, damageMax );
		} 
			
		dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
			
		delete dmg;

		action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

		action.SetHitReactionType(0, false);
		action.ClearDamage();
		action.ClearEffects();
		//action.SuppressHitSounds();
		action.SetWasDodged();
		action.SetCannotReturnDamage(true);

		return;
	}

	if(
	playerVictim
	&& npcAttacker
	&& (
	((W3Action_Attack)action).IsCountered()
	|| thePlayer.HasTag('ACS_In_Heavenly_Strike')
	|| thePlayer.HasTag('ACS_In_Dance_Of_Wrath')
	|| thePlayer.HasTag('ACS_Ghost_Stance_Active')
	|| thePlayer.HasTag('ACS_In_Combat_Art')
	)
	)
	{
		ACS_Sign_Combo_System(action);

		action.SetHitReactionType(0, false);
		action.ClearDamage();
		action.ClearEffects();
		action.SuppressHitSounds();
		action.SetWasDodged();
		action.SetCannotReturnDamage(true);

		GetACSWatcher().SetAdrenalineDrain(false);
		GetACSWatcher().RemoveTimer('AdrenalineDrainResume');
		GetACSWatcher().AddTimer('AdrenalineDrainResume', ACS_Settings_Main_Float('acs_combat_main_settings','acs_adrenaline_drain_delay', 3) , false );

		return;
	}

	if (playerVictim 
	&& !action.WasDodged() 
	&& FactsQuerySum("acs_transformation_activated") <= 0
	&& !(((W3Action_Attack)action).IsCountered())
	&& !(((W3Action_Attack)action).IsParried())
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !thePlayer.IsCurrentlyDodging()
	&& !thePlayer.HasTag('ACS_Is_Currently_Dodging')
	&& !ACS_Active_Parry(action)
	)
	{
		ACSGetCEntity('ACS_Sign_Icon_Anchor').Destroy();
		ACSGetCEntity('ACS_Sign_Icon').Destroy();

		buffs.Clear();
				
		action.GetEffectTypes(buffs);

		attackName = ((W3Action_Attack)action).GetAttackName();

		GetACSWatcher().RemoveTimer('ACS_KickDamage');

		GetACSWatcher().RemoveTimer('ACS_HeadbuttDamage');

		GetACSWatcher().RemoveTimer('CloseRangeAimAssist');

		if(buffs.Contains(EET_Knockdown) 
		|| buffs.Contains(EET_HeavyKnockdown)
		|| buffs.Contains(EET_KnockdownTypeApplicator)
		|| buffs.Contains(EET_Stagger)
		|| buffs.Contains(EET_LongStagger)
		|| attackName == 'attack_heavy_knockdown'
		|| attackName == 'attack_super_heavy'
		)
		{
			ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
			movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
			movementAdjustor.CancelAll();
			ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
			movementAdjustor.AdjustmentDuration( ticket, 0.1 );
			movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

			movementAdjustor.RotateTowards( ticket, npcAttacker );

			GetWitcherPlayer().SetPlayerTarget( npcAttacker );

			GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

			GetWitcherPlayer().UpdateDisplayTarget( true );

			GetWitcherPlayer().UpdateLookAtTarget();

			if (thePlayer.HasTag('ACS_IsSwordWalking')){thePlayer.RemoveTag('ACS_IsSwordWalking');}
			
			GetWitcherPlayer().RaiseEvent( 'AttackInterrupt' );

			if (thePlayer.IsWeaponHeld('fist') || !thePlayer.IsAnyWeaponHeld())
			{
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_knockdown_loop_to_dodge_slide_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f) );
			}
			else
			{	
				thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_ger_idle_sword_knockdown_1', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f) );
			}
		}
	}

    if ( playerVictim
	&& npcAttacker != thePlayer
	&& action.GetBuffSourceName() != "FallingDamage"
	&& !GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Immortal
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Invulnerable
	&& !GetWitcherPlayer().IsDodgeTimerRunning()
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	/*
	&& (GetWitcherPlayer().HasTag('acs_aard_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_axii_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_quen_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') )
	*/
	&& !GetWitcherPlayer().IsInGuardedState()
	&& !GetWitcherPlayer().IsGuarded()
	&& !action.WasDodged()
	&& !GetWitcherPlayer().IsPerformingFinisher()
	&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	&& action.GetBuffSourceName() != "vampirism" 
	)
	{
		if (GetACSWatcher().idleAdditiveExtraActive)
		{
			thePlayer.RaiseEvent('ACS_IdleAdditiveReset');

			GetACSWatcher().SetIdleAdditiveExtraStatus(false);
		}

		if (thePlayer.HasTag('ACS_Dual_Wield_Active'))
		{
			if (action.processedDmg.vitalityDamage != 0)
			{
				action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.1;
			}
		}

		if (GetWitcherPlayer().IsAnyQuenActive())
		{
			ACS_Create_Red_Quen_Hit_Effect();

			dmg = new W3DamageAction in theGame.damageMgr;
				
			dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Heavy, true);

			if (npcAttacker.UsesVitality()) 
			{ 
				damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.025; 
				
				damageMin = npcAttacker.GetStat( BCS_Vitality ) * 0.0125; 
			} 
			else if (npcAttacker.UsesEssence()) 
			{ 
				damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.025; 
				
				damageMin = npcAttacker.GetStat( BCS_Essence ) * 0.0125; 
			} 

			damageMax += damageMax * ACS_SignIntensityPercentage('total') * 0.5;

			damageMin += damageMin * ACS_SignIntensityPercentage('total') * 0.5;

			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + RandRangeF(damageMax,damageMin) );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + RandRangeF(damageMax,damageMin) );
				
			dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;

			return;
		}
		
		if (FactsQuerySum("acs_transformation_activated") > 0)
		{
			ACS_Transformation_OnTakeDamage(action);

			return;
		}

		if (thePlayer.HasTag('ACS_Horse_Dismount_Jump_Attack')
		)
		{
			GetACSWatcher().dodge_timer_actual();

			action.SetAllProcessedDamageAs(0);
			action.SetWasDodged();
			action.ClearEffects();

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

			return;
		}
		
		if (ACS_Active_Parry(action))
		{
			return;
		}

		if (npcAttacker.HasBuff(EET_Stagger)
		|| npcAttacker.HasBuff(EET_HeavyKnockdown)
		|| npcAttacker.HasBuff(EET_Knockdown)
		)
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

			return;
		}

		ACS_Player_Take_Damage_Directional_Attack_VFX(action);
			
		if (thePlayer.IsThrowingItem()
		|| thePlayer.IsThrowingItemWithAim()
		|| thePlayer.IsThrowHold())
		{
			GetWitcherPlayer().BombThrowAbort();

			thePlayer.OnThrowAnimLeave();
		}

		GetACSWatcher().RemoveTimer('RendProjectileSwitchDelay');

		if (npcAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()))
		{
			if (
			((CNewNPC)npcAttacker).HasTag('ACS_Big_Boi')
			|| ((CNewNPC)npcAttacker).HasAbility('mon_toad_base')
			|| ((CNewNPC)npcAttacker).HasAbility('mon_type_huge')
			|| ((CMovingPhysicalAgentComponent)((npcAttacker).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
			|| ((CNewNPC)npcAttacker).GetRadius() >= 0.7
			)
			{
				thePlayer.ACS_DealPlayerPostureDamage(30, true);
			}
			else
			{
				thePlayer.ACS_DealPlayerPostureDamage(22.5, true);
			}

			light_hit_sound_names.PushBack("damage_01_bb_acs");
			light_hit_sound_names.PushBack("damage_02_bb_acs");

			thePlayer.SoundEvent(light_hit_sound_names[RandRange(light_hit_sound_names.Size())]);

			light_hit_sound_names_primary.PushBack("greatsword_meat_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_01_bb_acs");
			light_hit_sound_names_primary.PushBack("kill_02_bb_acs");

			thePlayer.SoundEvent(light_hit_sound_names_primary[RandRange(light_hit_sound_names_primary.Size())]);

			GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_player_light_attack_take_damage_camera_shake_strength', 0.2), true, thePlayer.GetWorldPosition(), 30 );
		}
		else if (npcAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
		{
			if (
			((CNewNPC)npcAttacker).HasTag('ACS_Big_Boi')
			|| ((CNewNPC)npcAttacker).HasAbility('mon_toad_base')
			|| ((CNewNPC)npcAttacker).HasAbility('mon_type_huge')
			|| ((CMovingPhysicalAgentComponent)((npcAttacker).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
			|| ((CNewNPC)npcAttacker).GetRadius() >= 0.7
			)
			{
				thePlayer.ACS_DealPlayerPostureDamage(50, true);
			}
			else
			{
				thePlayer.ACS_DealPlayerPostureDamage(37.5, true);
			}

			heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
			heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

			thePlayer.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

			heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
			heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

			thePlayer.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);

			GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_player_heavy_attack_take_damage_camera_shake_strength', 0.5), true, thePlayer.GetWorldPosition(), 30 );
		}
		

		if (ACS_Armor_Set_Check('acs_armor_omega', false))
		{
			thePlayer.SoundEvent("monster_caretaker_vo_pain");

			if (RandF() < 0.125)
			{
				thePlayer.SoundEvent("monster_caretaker_vo_death");
			}

			GetWitcherPlayer().PlayEffectSingle('ghost_glitch');
			GetWitcherPlayer().StopEffect('ghost_glitch');

			GetWitcherPlayer().SoundEvent("cmb_play_parry");

			GetWitcherPlayer().SetCanPlayHitAnim(false); 

			GetWitcherPlayer().AddBuffImmunity(EET_Stagger , 			'ACS_Armor', true);
			GetWitcherPlayer().AddBuffImmunity(EET_SlowdownFrost , 		'ACS_Armor', true);
			GetWitcherPlayer().AddBuffImmunity(EET_Frozen ,			 	'ACS_Armor', true);
			GetWitcherPlayer().AddBuffImmunity(EET_LongStagger , 		'ACS_Armor', true);
		}
		else if (ACS_Armor_Set_Check('acs_armor_alpha', false))
		{
			thePlayer.SoundEvent("monster_caretaker_vo_pain");

			if (RandF() < 0.125)
			{
				thePlayer.SoundEvent("monster_caretaker_vo_death");
			}

			if (RandF() < 0.5)
			{
				GetWitcherPlayer().PlayEffectSingle('ghost_glitch');
				GetWitcherPlayer().StopEffect('ghost_glitch');

				GetWitcherPlayer().SoundEvent("cmb_play_parry");

				GetWitcherPlayer().SetCanPlayHitAnim(false); 

				GetWitcherPlayer().AddBuffImmunity(EET_Stagger , 			'ACS_Armor', true);
				GetWitcherPlayer().AddBuffImmunity(EET_SlowdownFrost , 		'ACS_Armor', true);
				GetWitcherPlayer().AddBuffImmunity(EET_Frozen ,			 	'ACS_Armor', true);
				GetWitcherPlayer().AddBuffImmunity(EET_LongStagger , 		'ACS_Armor', true);
			}
			else
			{
				GetWitcherPlayer().SetCanPlayHitAnim(true); 

				GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'ACS_Armor');
				GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'ACS_Armor');
				GetWitcherPlayer().RemoveBuffImmunity( EET_HeavyKnockdown,			'ACS_Armor');
				GetWitcherPlayer().RemoveBuffImmunity( EET_Knockdown,				'ACS_Armor');
				GetWitcherPlayer().RemoveBuffImmunity( EET_SlowdownFrost,			'ACS_Armor');
				GetWitcherPlayer().RemoveBuffImmunity( EET_Frozen,			 		'ACS_Armor');
			}
		}
		else
		{
			GetWitcherPlayer().SetCanPlayHitAnim(true); 

			GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'ACS_Armor');
			GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'ACS_Armor');
			GetWitcherPlayer().RemoveBuffImmunity( EET_HeavyKnockdown,			'ACS_Armor');
			GetWitcherPlayer().RemoveBuffImmunity( EET_Knockdown,				'ACS_Armor');
			GetWitcherPlayer().RemoveBuffImmunity( EET_SlowdownFrost,			'ACS_Armor');
			GetWitcherPlayer().RemoveBuffImmunity( EET_Frozen,			 		'ACS_Armor');
		}

		ACS_PlayerHitEffects();

		ACS_Armor_System(action);

		if (ACS_Settings_Main_Float('acs_damage_settings','acs_player_damage_taken_multiplier', 1) != 1 && action.processedDmg.vitalityDamage != 0)
		{
			action.processedDmg.vitalityDamage *= ACS_Settings_Main_Float('acs_damage_settings','acs_player_damage_taken_multiplier', 1);
		}

		if (thePlayer.HasTag('ACS_Player_In_Everstorm_Distance_1') && action.processedDmg.vitalityDamage != 0)
		{
			action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage;

			action.SetCriticalHit();
		}

		if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() 
		&& action.processedDmg.vitalityDamage > 0
		&& ACS_Settings_Main_Bool('acs_hud_settings_main','acs_player_floating_markers_enabled', true)
		&& ACS_Settings_Main_Bool('acs_hud_settings_main','acs_floating_markers_only_show_buffs_enabled', false)
		)
		{
			ACS_Oneliner(
			(new ACS_Oneliner_TagBuilder in theGame)
			.tag("font")
			.attr("size", "22")
			.attr("color", "#FFF0F0")
			.text(FloatToStringPrec(action.processedDmg.vitalityDamage, 0))
			, thePlayer, "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
		}

		stored_grey_health = action.processedDmg.vitalityDamage;

		thePlayer.ACS_ManageGreyHealth(true, stored_grey_health);
	}
}

function ACS_Transformation_OnTakeDamage(action: W3DamageAction)
{
	var playerAttacker, playerVictim																																																								: CPlayer;
	var npc, npcAttacker 																																																											: CActor;
	var movementAdjustor, movementAdjustorWerewolf, movementAdjustorVampiress, movementAdjustorTransformationVampireMonster, movementAdjustorRedMiasmal, movementAdjustorSharley, movementAdjustorBlackWolf															: CMovementAdjustor;
	var ticket, ticketWerewolf, ticketVampiress, ticketTransformationVampireMonster, ticketRedMiasmal, ticketSharley, ticketBlackWolf							 																									: SMovementAdjustmentRequestTicket;
	var item																																																														: SItemUniqueId;
	var dmg																																																															: W3DamageAction;
	var damageMax, damageMin, detonationTimer																																																						: float;
	var animatedComponentA 																																																											: CAnimatedComponent;
	var hitLag 																																																														: float;
    var buffs 																																																														: array<EEffectType>;
    var attackName 																																																													: name;
	var targetDistance																																																												: float;
	var parry_fx_temp																																																												: CEntityTemplate;
	var parry_fx																																																													: CEntity;
	var ent_3, ent_4 																																																												: CEntity;
	var finisher_anim_names																																																											: array< name >;
	var plantedBomb, plantedBombSecondary																																																							: W3Petard;
	var selectedItemId 																																																												: SItemUniqueId;
	var thrownEntity																																																												: CThrowable;
	var thrownEntityPath																																																											: String;
	var bonePosition																																																												: Vector;
	var boneRotation																																																												: EulerAngles;
	var vfxEnt_1, vfxEnt_2, vfxEnt_3																																																								: CEntity;
	var pos 																																																														: Vector;
	var rot 																																																														: EulerAngles;
	var targetPosition_1, targetPosition_2, targetPosition_3																																																		: Vector;
	var headingDiff, tilt_inversion																																																									: float;
	var light_hit_sound_names, heavy_hit_sound_names																																																				: array<string>;
	var light_hit_sound_names_primary, heavy_hit_sound_names_primary																																																: array<string>;
	var animatedComponentB																																																											: CAnimatedComponent;

	npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorWerewolf = ACSGetCActor('ACS_Transformation_Werewolf').GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorVampiress = ACSGetCActor('ACS_Transformation_Vampiress').GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorTransformationVampireMonster = ACSGetCActor('ACS_Transformation_Vampire_Monster').GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorRedMiasmal = ACSGetCActor('ACS_Transformation_Red_Miasmal').GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorSharley = ACSGetCActor('ACS_Transformation_Sharley').GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorBlackWolf = ACSGetCActor('ACS_Transformation_Black_Wolf').GetMovingAgentComponent().GetMovementAdjustor();

	if (FactsQuerySum("acs_wolven_curse_activated") > 0)
	{
		ticketWerewolf = movementAdjustorWerewolf.GetRequest( 'ACS_Transformation_Werewolf_Hit_Rotate');
		movementAdjustorWerewolf.CancelByName( 'ACS_Transformation_Werewolf_Hit_Rotate' );
		movementAdjustorWerewolf.CancelAll();

		ticketWerewolf = movementAdjustorWerewolf.CreateNewRequest( 'ACS_Transformation_Werewolf_Hit_Rotate' );
		movementAdjustorWerewolf.AdjustmentDuration( ticketWerewolf, 0.25 );
		movementAdjustorWerewolf.MaxRotationAdjustmentSpeed( ticketWerewolf, 500000 );

		if (GetCurMoonState() == EMS_Full
		&& (GetCurWeather() == EWE_Clear || GetCurWeather() == EWE_None)
		)
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

			if (!ACSGetCActor('ACS_Transformation_Werewolf').HasTag('ACS_Werewolf_Berserk_Mode'))
			{
				movementAdjustorWerewolf.RotateTowards( ticketWerewolf, npcAttacker);
			}
		}
		else
		{
			if (!ACSGetCActor('ACS_Transformation_Werewolf').HasTag('ACS_Werewolf_Berserk_Mode'))
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;

				movementAdjustorWerewolf.RotateTowards( ticketWerewolf, npcAttacker);
			}
			else
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
			}
		}

		ACS_Transformation_Entity_Hit_Animations('werewolf');
	}
	
	if (FactsQuerySum("acs_vampireess_transformation_activated") > 0)
	{
		ticketVampiress = movementAdjustorVampiress.GetRequest( 'ACS_Transformation_Vampiress_Hit_Rotate');
		movementAdjustorVampiress.CancelByName( 'ACS_Transformation_Vampiress_Hit_Rotate' );
		movementAdjustorVampiress.CancelAll();

		ticketVampiress = movementAdjustorVampiress.CreateNewRequest( 'ACS_Transformation_Vampiress_Hit_Rotate' );
		movementAdjustorVampiress.AdjustmentDuration( ticketVampiress, 0.125 );
		movementAdjustorVampiress.MaxRotationAdjustmentSpeed( ticketVampiress, 500000 );

		if (GetCurMoonState() == EMS_Red
		&& (GetCurWeather() == EWE_Clear || GetCurWeather() == EWE_None)
		)
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
		}
		else
		{
			if (ACSGetCActor('ACS_Transformation_Vampiress').HasTag('ACS_Vampiress_Is_Parrying'))
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
			}
			else
			{
				if (!ACSGetCActor('ACS_Transformation_Vampiress').HasTag('ACS_Vampiress_Sorceress_Mode'))
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
				}
			}
		}

		movementAdjustorVampiress.RotateTowards( ticketVampiress, npcAttacker);

		ACS_Transformation_Entity_Hit_Animations('vampiress');
	}

	if (FactsQuerySum("acs_vampire_monster_transformation_activated") > 0)
	{
		ticketTransformationVampireMonster = movementAdjustorTransformationVampireMonster.GetRequest( 'ACS_Transformation_Vampire_Monster_Hit_Rotate');
		movementAdjustorTransformationVampireMonster.CancelByName( 'ACS_Transformation_Vampire_Monster_Hit_Rotate' );
		movementAdjustorTransformationVampireMonster.CancelAll();

		ticketTransformationVampireMonster = movementAdjustorTransformationVampireMonster.CreateNewRequest( 'ACS_Transformation_Vampire_Monster_Hit_Rotate' );
		movementAdjustorTransformationVampireMonster.AdjustmentDuration( ticketTransformationVampireMonster, 0.125 );
		movementAdjustorTransformationVampireMonster.MaxRotationAdjustmentSpeed( ticketTransformationVampireMonster, 500000 );

		if (GetCurMoonState() == EMS_Red
		&& (GetCurWeather() == EWE_Clear || GetCurWeather() == EWE_None)
		)
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
		}
		else if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Monster_Is_Parrying')
		)
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
		}
		else
		{
			if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Monster_Blood_Armor')
			)
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.975;
			}
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
			}
		}

		if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Vampire_Monster_Ground_Mode'))
		{
			if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Monster_Is_Parrying'))
			{
				movementAdjustorTransformationVampireMonster.RotateTowards( ticketTransformationVampireMonster, npcAttacker);
			}
			else
			{
				if (!ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Monster_Blood_Armor'))
				{
					movementAdjustorTransformationVampireMonster.RotateTowards( ticketTransformationVampireMonster, npcAttacker);
				}
			}

			ACS_Transformation_Entity_Hit_Animations('vampire_monster');
		}
		else
		{
			if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Monster_Blood_Armor'))
			{
				ACSGetCActor('ACS_Transformation_Vampire_Monster').StopEffect('light_hit');
				ACSGetCActor('ACS_Transformation_Vampire_Monster').PlayEffectSingle('light_hit');

				ACSGetCActor('ACS_Transformation_Vampire_Monster').StopEffect('comming_out');
				ACSGetCActor('ACS_Transformation_Vampire_Monster').PlayEffectSingle('comming_out');

				ACSGetCActor('ACS_Transformation_Vampire_Monster').DestroyEffect('body_blood_drip');
				ACSGetCActor('ACS_Transformation_Vampire_Monster').PlayEffectSingle('body_blood_drip');
				ACSGetCActor('ACS_Transformation_Vampire_Monster').StopEffect('body_blood_drip');
			}
			else
			{
				ACSGetCActor('ACS_Transformation_Vampire_Monster').StopEffect('comming_out');
				ACSGetCActor('ACS_Transformation_Vampire_Monster').PlayEffectSingle('comming_out');
			}
		}
	}

	if (FactsQuerySum("acs_toad_transformation_activated") > 0)
	{
		action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
	}

	if (FactsQuerySum("acs_red_miasmal_curse_activated") > 0)
	{
		if (ACSGetCActor('ACS_Transformation_Red_Miasmal').HasTag('ACS_Transformation_Red_Miasmal_Rooted'))
		{
			ACSGetCActor('ACS_Transformation_Red_Miasmal').StopEffect('teleport_roots_1');
			ACSGetCActor('ACS_Transformation_Red_Miasmal').PlayEffectSingle('teleport_roots_1');

			GetACSWatcher().RemoveTimer('RedMiasmalLightAttackDamage360');
			GetACSWatcher().AddTimer('RedMiasmalLightAttackDamage360', 0.1 , false );

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
		}
		else
		{
			if (RandF() < 0.06125)
			{
				ticketRedMiasmal = movementAdjustorRedMiasmal.GetRequest( 'ACS_Transformation_Red_Miasmal_Hit_Rotate');
				movementAdjustorRedMiasmal.CancelByName( 'ACS_Transformation_Red_Miasmal_Hit_Rotate' );
				movementAdjustorRedMiasmal.CancelAll();

				ticketRedMiasmal = movementAdjustorRedMiasmal.CreateNewRequest( 'ACS_Transformation_Red_Miasmal_Hit_Rotate' );
				movementAdjustorRedMiasmal.AdjustmentDuration( ticketRedMiasmal, 0.25 );
				movementAdjustorRedMiasmal.MaxRotationAdjustmentSpeed( ticketRedMiasmal, 500000 );

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;

				movementAdjustorRedMiasmal.RotateTowards( ticketRedMiasmal, npcAttacker);

				ACS_Transformation_Entity_Hit_Animations('red_miasmal');
			}
			else
			{
				ACSGetCActor('ACS_Transformation_Red_Miasmal').StopEffect('teleport_roots_1');
				ACSGetCActor('ACS_Transformation_Red_Miasmal').PlayEffectSingle('teleport_roots_1');

				GetACSWatcher().RemoveTimer('RedMiasmalLightAttackDamage360');
				GetACSWatcher().AddTimer('RedMiasmalLightAttackDamage360', 0.1 , false );

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
			}
		}
	}

	if (FactsQuerySum("acs_sharley_curse_activated") > 0)
	{
		((CNewNPC)ACSGetCActor('ACS_Transformation_Sharley')).SetUnstoppable( true );

		if (ACSGetCActor('ACS_Transformation_Sharley').HasTag('ACS_Sharley_Is_Spinning')
		|| ACSGetCActor('ACS_Transformation_Sharley').HasTag('ACS_Sharley_Roll_Init')
		)
		{
			ACSGetCActor('ACS_Transformation_Sharley').StopEffect('sonar');
			ACSGetCActor('ACS_Transformation_Sharley').PlayEffectSingle('sonar');
			ACSGetCActor('ACS_Transformation_Sharley').StopEffect('sonar');

			GetACSWatcher().SharleyReflectDamage();

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
		}
		else
		{
			if (RandF() < 0.06125)
			{
				ticketSharley = movementAdjustorSharley.GetRequest( 'ACS_Transformation_Sharley_Hit_Rotate');
				movementAdjustorSharley.CancelByName( 'ACS_Transformation_Sharley_Hit_Rotate' );
				movementAdjustorSharley.CancelAll();

				ticketSharley = movementAdjustorSharley.CreateNewRequest( 'ACS_Transformation_Sharley_Hit_Rotate' );
				movementAdjustorSharley.AdjustmentDuration( ticketSharley, 0.25 );
				movementAdjustorSharley.MaxRotationAdjustmentSpeed( ticketSharley, 500000 );

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.8;

				movementAdjustorSharley.RotateTowards( ticketSharley, npcAttacker);

				ACS_Transformation_Entity_Hit_Animations('sharley');
			}
			else
			{
				ACSGetCActor('ACS_Transformation_Sharley').StopEffect('sonar');
				ACSGetCActor('ACS_Transformation_Sharley').PlayEffectSingle('sonar');
				ACSGetCActor('ACS_Transformation_Sharley').StopEffect('sonar');

				GetACSWatcher().SharleyReflectDamage();

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
			}
		}
	}

	if (FactsQuerySum("acs_black_wolf_curse_activated") > 0)
	{
		ticketBlackWolf = movementAdjustorBlackWolf.GetRequest( 'ACS_Transformation_Black_Wolf_Hit_Rotate');
		movementAdjustorBlackWolf.CancelByName( 'ACS_Transformation_Black_Wolf_Hit_Rotate' );
		movementAdjustorBlackWolf.CancelAll();

		ticketBlackWolf = movementAdjustorBlackWolf.CreateNewRequest( 'ACS_Transformation_Black_Wolf_Hit_Rotate' );
		movementAdjustorBlackWolf.AdjustmentDuration( ticketBlackWolf, 0.25 );
		movementAdjustorBlackWolf.MaxRotationAdjustmentSpeed( ticketBlackWolf, 500000 );

		action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;

		movementAdjustorBlackWolf.RotateTowards( ticketBlackWolf, npcAttacker);

		ACS_Transformation_Entity_Hit_Animations('black_wolf');
	}

	if (FactsQuerySum("acs_giant_curse_activated") > 0)
	{
		dmg = new W3DamageAction in theGame.damageMgr;
		
		dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
		
		dmg.SetProcessBuffsIfNoDamage(true);
		
		dmg.SetHitReactionType( EHRT_Light, true);

		if (npcAttacker.UsesVitality()) 
		{ 
			damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.0125; 
			
			damageMin = npcAttacker.GetStat( BCS_Vitality ) * 0.06125; 
		} 
		else if (npcAttacker.UsesEssence()) 
		{ 
			damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.0125; 
			
			damageMin = npcAttacker.GetStat( BCS_Essence ) * 0.06125; 
		} 

		if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
		{
			thePlayer.SoundEvent("magic_sorceress_vfx_hit_electric");

			thePlayer.SoundEvent("magic_sorceress_vfx_lightning_bolt");

			damageMax += damageMax * ACS_SignIntensityPercentage('total') * 0.5;

			damageMin += damageMin * ACS_SignIntensityPercentage('total') * 0.5;

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SHOCK, RandRangeF(50 + damageMax * 0.25,50 + damageMin * 0.25) );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + RandRangeF(damageMax,damageMin) );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + RandRangeF(damageMax,damageMin) );

			if (!ACSGetCActor('ACS_Transformation_Giant').HasTag('ACS_Transformation_Giant_Weapon_Mode'))
			{
				dmg.AddEffectInfo( EET_Paralyzed, 1 );
			}
			else
			{
				dmg.AddEffectInfo( EET_Burning, 3 );

				dmg.AddEffectInfo( EET_Knockdown, 1 );
			}
		}
		else
		{
			damageMax += damageMax * ACS_SignIntensityPercentage('total') * 0.5;

			damageMin += damageMin * ACS_SignIntensityPercentage('total') * 0.5;

			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + RandRangeF(damageMax,damageMin) );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + RandRangeF(damageMax,damageMin) );
		}

		if (ACSGetCActor('ACS_Transformation_Giant').HasTag('ACS_Transformation_Giant_Is_Parrying'))
		{
			if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
			}
			else
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
			}
		}
		else
		{
			if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
			}
			else
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.8;
			}
		}
			
		dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
			
		delete dmg;

		thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus ) * 0.025 );  

		ACSGetCActor('ACS_Transformation_Giant').SoundEvent("cmb_play_parry");

		if (thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875)
		{
			ACSGetCActor('ACS_Transformation_Giant').StopEffect('hit_electric_shock');
			ACSGetCActor('ACS_Transformation_Giant').PlayEffectSingle('hit_electric_shock');
		}
		else
		{
			ACSGetCActor('ACS_Transformation_Giant').StopEffect('hit_electric_shock_normal');
			ACSGetCActor('ACS_Transformation_Giant').PlayEffectSingle('hit_electric_shock_normal');
		}
	}

	if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() 
	&& action.processedDmg.vitalityDamage > 0
	&& ACS_Settings_Main_Bool('acs_hud_settings_main','acs_player_floating_markers_enabled', true)
	&& ACS_Settings_Main_Bool('acs_hud_settings_main','acs_floating_markers_only_show_buffs_enabled', false)
	)
	{
		ACS_Oneliner(
		(new ACS_Oneliner_TagBuilder in theGame)
		.tag("font")
		.attr("size", "22")
		.attr("color", "#FFF0F0")
		.text(FloatToStringPrec(action.processedDmg.vitalityDamage, 0))
		, thePlayer, "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
	}
}

function ACS_Armor_System(action: W3DamageAction)
{
	var playerAttacker, playerVictim																																																								: CPlayer;
	var npc, npcAttacker 																																																											: CActor;
	var movementAdjustor, movementAdjustorWerewolf, movementAdjustorVampiress, movementAdjustorTransformationVampireMonster, movementAdjustorRedMiasmal, movementAdjustorSharley, movementAdjustorBlackWolf															: CMovementAdjustor;
	var ticket, ticketWerewolf, ticketVampiress, ticketTransformationVampireMonster, ticketRedMiasmal, ticketSharley, ticketBlackWolf							 																									: SMovementAdjustmentRequestTicket;
	var item																																																														: SItemUniqueId;
	var dmg																																																															: W3DamageAction;
	var damageMax, damageMin, detonationTimer																																																						: float;
	var animatedComponentA 																																																											: CAnimatedComponent;
	var hitLag 																																																														: float;
    var buffs 																																																														: array<EEffectType>;
    var attackName 																																																													: name;
	var targetDistance																																																												: float;
	var parry_fx_temp																																																												: CEntityTemplate;
	var parry_fx																																																													: CEntity;
	var ent_3, ent_4 																																																												: CEntity;
	var finisher_anim_names																																																											: array< name >;
	var plantedBomb, plantedBombSecondary																																																							: W3Petard;
	var selectedItemId 																																																												: SItemUniqueId;
	var thrownEntity																																																												: CThrowable;
	var thrownEntityPath																																																											: String;
	var bonePosition																																																												: Vector;
	var boneRotation																																																												: EulerAngles;
	var vfxEnt_1, vfxEnt_2, vfxEnt_3																																																								: CEntity;
	var pos 																																																														: Vector;
	var rot 																																																														: EulerAngles;
	var targetPosition_1, targetPosition_2, targetPosition_3																																																		: Vector;
	var headingDiff, tilt_inversion																																																									: float;
	var light_hit_sound_names, heavy_hit_sound_names																																																				: array<string>;
	var light_hit_sound_names_primary, heavy_hit_sound_names_primary																																																: array<string>;
	var animatedComponentB																																																											: CAnimatedComponent;

	npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), npcAttacker.GetWorldPosition() );

	if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) && targetDistance <= 3)
	{
		if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
		{
			if( ( RandF() < 0.775) || GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.1 ) 
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

				if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
				&& !GetWitcherPlayer().IsPerformingFinisher())
				{
					ACS_Hit_Animations(action);
				}
			}
			else
			{
				ACS_Tutorial_Display_Check('ACS_ArmorSystem_Tutorial_Shown');

				if (!GetACSWatcher().combatExtraActive)
				{
					GetACSWatcher().SetCombatExtraStatus(true);
				}

				GetACSWatcher().RemoveTimer('combatExtraReset');
				GetACSWatcher().AddTimer('combatExtraReset', 0.4 , false );

				GetWitcherPlayer().StopEffect('armor_sparks');
				GetWitcherPlayer().PlayEffectSingle('armor_sparks');

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

				GetWitcherPlayer().SoundEvent("grunt_vo_block");
				
				GetWitcherPlayer().SoundEvent("cmb_play_parry");

				dmg = new W3DamageAction in theGame.damageMgr;
	
				dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetHitReactionType( EHRT_Light, true);

				if (npcAttacker.UsesVitality()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.0125; 
					
					damageMin = npcAttacker.GetStat( BCS_Vitality ) * 0.06125; 
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.0125; 
					
					damageMin = npcAttacker.GetStat( BCS_Essence ) * 0.06125; 
				} 

				dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + RandRangeF(damageMax,damageMin) );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + RandRangeF(damageMax,damageMin) );
					
				dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;

				//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.2 );

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.2, 1, );
			}
		}
		else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
		{
			if( ( RandF() < 0.825 ) || GetWitcherPlayer().GetStat( BCS_Stamina )  <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.1 ) 
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;

				if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
				&& !GetWitcherPlayer().IsPerformingFinisher())
				{
					ACS_Hit_Animations(action);
				}
			}
			else
			{
				ACS_Tutorial_Display_Check('ACS_ArmorSystem_Tutorial_Shown');

				if (!GetACSWatcher().combatExtraActive)
				{
					GetACSWatcher().SetCombatExtraStatus(true);
				}

				GetACSWatcher().RemoveTimer('combatExtraReset');
				GetACSWatcher().AddTimer('combatExtraReset', 0.4, false);

				GetWitcherPlayer().StopEffect('armor_sparks');
				GetWitcherPlayer().PlayEffectSingle('armor_sparks');

				GetWitcherPlayer().SoundEvent("grunt_vo_block");

				GetWitcherPlayer().SoundEvent("cmb_play_parry");

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;

				dmg = new W3DamageAction in theGame.damageMgr;
	
				dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetHitReactionType( EHRT_Light, true);

				if (npcAttacker.UsesVitality()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.06125; 
					
					damageMin = npcAttacker.GetStat( BCS_Vitality ) * 0.030625; 
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.06125; 
					
					damageMin = npcAttacker.GetStat( BCS_Essence ) * 0.030625; 
				} 

				dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + RandRangeF(damageMax,damageMin) );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + RandRangeF(damageMax,damageMin) );
					
				dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;

				//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15 );

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.15, 1, );
			}
		}
		else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
		{
			if( ( RandF() < 0.925 ) || GetWitcherPlayer().GetStat( BCS_Stamina )  <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.1 ) 
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.06125;

				if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
				&& !GetWitcherPlayer().IsPerformingFinisher())
				{
					ACS_Hit_Animations(action);
				}
			}
			else
			{
				ACS_Tutorial_Display_Check('ACS_ArmorSystem_Tutorial_Shown');

				if (!GetACSWatcher().combatExtraActive)
				{
					GetACSWatcher().SetCombatExtraStatus(true);
				}

				GetACSWatcher().RemoveTimer('combatExtraReset');
				GetACSWatcher().AddTimer('combatExtraReset', 0.4, false);
				
				GetWitcherPlayer().StopEffect('armor_sparks');
				GetWitcherPlayer().PlayEffectSingle('armor_sparks');

				GetWitcherPlayer().SoundEvent("grunt_vo_block");

				GetWitcherPlayer().SoundEvent("cmb_play_parry");

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.06125;

				dmg = new W3DamageAction in theGame.damageMgr;
	
				dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetHitReactionType( EHRT_Light, true);

				if (npcAttacker.UsesVitality()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.005; 
					
					damageMin = npcAttacker.GetStat( BCS_Vitality ) * 0.0025; 
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.005; 
					
					damageMin = npcAttacker.GetStat( BCS_Essence ) * 0.0025; 
				} 

				dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + RandRangeF(damageMax,damageMin) );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + RandRangeF(damageMax,damageMin) );
					
				dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;

				//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15 );

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.15, 1, );
			}
		}
		else
		{
			GetACSWatcher().RemoveTimer('ACS_Combo_Counter_Reset_Timer'); GetACSWatcher().AddTimer('ACS_Combo_Counter_Reset_Timer', 0.01 , false );

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.06125;

			if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
			&& !GetWitcherPlayer().IsPerformingFinisher())
			{
				ACS_Hit_Animations(action);
			}
		}
	}
	else
	{
		GetACSWatcher().RemoveTimer('ACS_Combo_Counter_Reset_Timer'); GetACSWatcher().AddTimer('ACS_Combo_Counter_Reset_Timer', 0.01 , false );
		
		action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.06125;

		if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
		&& !GetWitcherPlayer().IsPerformingFinisher())
		{
			ACS_Hit_Animations(action);
		}
	}
}

function ACS_Player_Take_Damage_Directional_Attack_VFX(action: W3DamageAction)
{
	var playerAttacker, playerVictim																																																								: CPlayer;
	var npc, npcAttacker 																																																											: CActor;
	var movementAdjustor, movementAdjustorWerewolf, movementAdjustorVampiress, movementAdjustorTransformationVampireMonster, movementAdjustorRedMiasmal, movementAdjustorSharley, movementAdjustorBlackWolf															: CMovementAdjustor;
	var ticket, ticketWerewolf, ticketVampiress, ticketTransformationVampireMonster, ticketRedMiasmal, ticketSharley, ticketBlackWolf							 																									: SMovementAdjustmentRequestTicket;
	var item																																																														: SItemUniqueId;
	var dmg																																																															: W3DamageAction;
	var damageMax, damageMin, detonationTimer																																																						: float;
	var animatedComponentA 																																																											: CAnimatedComponent;
	var hitLag 																																																														: float;
    var buffs 																																																														: array<EEffectType>;
    var attackName 																																																													: name;
	var targetDistance																																																												: float;
	var parry_fx_temp																																																												: CEntityTemplate;
	var parry_fx																																																													: CEntity;
	var ent_3, ent_4 																																																												: CEntity;
	var finisher_anim_names																																																											: array< name >;
	var plantedBomb, plantedBombSecondary																																																							: W3Petard;
	var selectedItemId 																																																												: SItemUniqueId;
	var thrownEntity																																																												: CThrowable;
	var thrownEntityPath																																																											: String;
	var bonePosition																																																												: Vector;
	var boneRotation																																																												: EulerAngles;
	var vfxEnt_1, vfxEnt_2, vfxEnt_3																																																								: CEntity;
	var pos 																																																														: Vector;
	var rot 																																																														: EulerAngles;
	var targetPosition_1, targetPosition_2, targetPosition_3																																																		: Vector;
	var headingDiff, tilt_inversion																																																									: float;
	var light_hit_sound_names, heavy_hit_sound_names																																																				: array<string>;
	var light_hit_sound_names_primary, heavy_hit_sound_names_primary																																																: array<string>;
	var animatedComponentB																																																											: CAnimatedComponent;

	if (ACS_Settings_Main_Bool('acs_visual_main_settings','acs_directional_slash_effects_enabled', true))
	{
		npc = (CActor)action.victim;
	
		npcAttacker = (CActor)action.attacker;
		
		playerAttacker = (CPlayer)action.attacker;
		
		playerVictim = (CPlayer)action.victim;

		headingDiff = AngleDistance( VecHeading( theCamera.GetCameraDirection() ), VecHeading( thePlayer.GetHeadingVector() ) );

		if (headingDiff >= 90 )
		{
			rot = thePlayer.GetWorldRotation();
		}
		else if (headingDiff < -90 )
		{
			rot = thePlayer.GetWorldRotation();
		}
		else
		{
			rot = theCamera.GetCameraRotation();
			rot.Pitch = 0;
			rot.Roll = 0;
		}

		pos = thePlayer.GetWorldPosition();
		
		switch ( action.GetSwingType() )
		{
			case AST_Horizontal:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot.Roll -= 90;
					break;

					case ASD_RightLeft: 	
						rot.Roll += 90;
					break;

					default: 
						if (RandF() < 0.5)
						{
							rot.Roll -= 90;
						}
						else
						{
							rot.Roll += 90;
						}
					break;
				}
				break;
			
			break;

			case AST_Vertical:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_UpDown: 		
						rot.Roll += 0;
					break;

					case ASD_DownUp: 		
						rot.Roll += RandRangeF(195,165);	
					break;

					default:
						rot.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_DiagonalUp:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot.Roll += RandRangeF(150,120);		
					break;

					case ASD_RightLeft: 	
						rot.Roll -= RandRangeF(150,120);		
					break;

					default: 
						rot.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_DiagonalDown:
			
				switch ( action.GetSwingDirection() )
				{
					case ASD_LeftRight: 	
						rot.Roll += RandRangeF(60,30);		
					break;

					case ASD_RightLeft: 	
						rot.Roll -= RandRangeF(60,30);		
					break;

					default: 
						rot.Roll += 0;	
					break;
				}
				break;
			
			break;

			case AST_Jab:
				
				rot.Roll += 0;	
				rot.Pitch += RandRangeF(105,75);			
				
			break;

			default :					
				rot.Roll += 0;	
			break;
		}

		targetPosition_1 = thePlayer.GetWorldPosition();
		targetPosition_1.Z += RandRangeF(1.25,1.125);
		targetPosition_1.X += RandRangeF(0.125,-0.125);
		targetPosition_1.Y += RandRangeF(0.125,-0.125);

		vfxEnt_1 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPosition_1, rot );

		vfxEnt_1.DestroyAfter(0.5);

		if (
		npcAttacker.IsMonster()
		|| npcAttacker.UsesEssence()
		)
		{
			if (
			npcAttacker.GetMovingAgentComponent().GetName() == "wild_hunt_base"
			|| npcAttacker.HasTag( 'mq7017_knight' )
			)
			{
				if (npcAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()))
				{
					vfxEnt_1.PlayEffectSingle('sword_slash_player_hit_singular');
				}
				else if (npcAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
				{
					vfxEnt_1.PlayEffectSingle('sword_slash_player_hit_heavy_singular');
				}
				else
				{
					vfxEnt_1.PlayEffectSingle('sword_slash_player_hit_singular');
				}
			}
			else
			{
				targetPosition_2 = targetPosition_1;

				targetPosition_3 = targetPosition_1;

				if (rot.Roll == 0)
				{
					targetPosition_2.X += 0.25;

					targetPosition_2.Y += 0.25;

					targetPosition_3.X -= 0.25;

					targetPosition_3.Y -= 0.25;
				}
				else
				{
					targetPosition_2.Z += 0.25;

					targetPosition_3.Z -= 0.25;
				}
				

				vfxEnt_2 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPosition_2, rot );

				vfxEnt_3 = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPosition_3, rot );

				vfxEnt_2.DestroyAfter(0.5);

				vfxEnt_3.DestroyAfter(0.5);

				if (npcAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()))
				{
					vfxEnt_1.PlayEffectSingle('sword_slash_player_hit');
					vfxEnt_2.PlayEffectSingle('sword_slash_player_hit');
					vfxEnt_3.PlayEffectSingle('sword_slash_player_hit');
				}
				else if (npcAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
				{
					vfxEnt_1.PlayEffectSingle('sword_slash_player_hit_heavy');
					vfxEnt_2.PlayEffectSingle('sword_slash_player_hit_heavy');
					vfxEnt_3.PlayEffectSingle('sword_slash_player_hit_heavy');
				}
				else
				{
					vfxEnt_1.PlayEffectSingle('sword_slash_player_hit');
					vfxEnt_2.PlayEffectSingle('sword_slash_player_hit');
					vfxEnt_3.PlayEffectSingle('sword_slash_player_hit');
				}
			}
		}
		else
		{
			if (npcAttacker.IsLightAttack(((W3Action_Attack)action).GetAttackName()))
			{
				vfxEnt_1.PlayEffectSingle('sword_slash_player_hit_singular');
			}
			else if (npcAttacker.IsHeavyAttack(((W3Action_Attack)action).GetAttackName()))
			{
				vfxEnt_1.PlayEffectSingle('sword_slash_player_hit_heavy_singular');
			}
			else
			{
				vfxEnt_1.PlayEffectSingle('sword_slash_player_hit_singular');
			}
		}
	}
}

function ACS_Active_Parry(action: W3DamageAction) : bool
{
	var playerAttacker, playerVictim																																																								: CPlayer;
	var npc, npcAttacker 																																																											: CActor;
	var movementAdjustor, movementAdjustorWerewolf, movementAdjustorVampiress, movementAdjustorTransformationVampireMonster, movementAdjustorRedMiasmal, movementAdjustorSharley, movementAdjustorBlackWolf															: CMovementAdjustor;
	var ticket, ticketWerewolf, ticketVampiress, ticketTransformationVampireMonster, ticketRedMiasmal, ticketSharley, ticketBlackWolf							 																									: SMovementAdjustmentRequestTicket;
	var item																																																														: SItemUniqueId;
	var dmg																																																															: W3DamageAction;
	var damageMax, damageMin, detonationTimer																																																						: float;
	var animatedComponentA 																																																											: CAnimatedComponent;
	var hitLag 																																																														: float;
    var buffs 																																																														: array<EEffectType>;
    var attackName 																																																													: name;
	var targetDistance																																																												: float;
	var parry_fx_temp																																																												: CEntityTemplate;
	var parry_fx																																																													: CEntity;
	var ent_3, ent_4 																																																												: CEntity;
	var finisher_anim_names																																																											: array< name >;
	var plantedBomb, plantedBombSecondary																																																							: W3Petard;
	var selectedItemId 																																																												: SItemUniqueId;
	var thrownEntity																																																												: CThrowable;
	var thrownEntityPath																																																											: String;
	var bonePosition																																																												: Vector;
	var boneRotation																																																												: EulerAngles;
	var parry_fx_pos 																																																												: Vector;
	var vACS_Dagger_Summon																																																											: cACS_Dagger_Summon;
	var anim_names																																																													: array< name >;
	var chosen_anim_name																																																											: name;
	var counter_sound_names																																																											: array< string >;
	var wound_fx																																																													: CEntity;
	var bPos 																																																														: Vector;
	var bRot 																																																														: EulerAngles;
	var boneIndex 																																																													: int;

	npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	if (GetACSWatcher().swimmingDodgeCheck
	&& thePlayer.IsDiving()
	)
	{
		action.SetAllProcessedDamageAs(0);
		action.SetWasDodged();
		action.ClearEffects();

		return true;
	}

	if (GetACSWatcher().swimmingCounterCheck
	&& (thePlayer.IsSwimming() || thePlayer.IsDiving())
	)
	{
		movementAdjustor.CancelAll();
		ticket = movementAdjustor.CreateNewRequest( 'ACS_Swimming_Movement_Adjustor' );
		
		movementAdjustor.AdjustmentDuration( ticket, 0.25 );
		movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
		movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );
		movementAdjustor.AdjustLocationVertically( ticket, true );

		movementAdjustor.RotateTowards( ticket, npcAttacker );

		parry_fx_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

		thePlayer.SoundEvent("cmb_play_parry");
		thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_screech");
		thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_shock");
		thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_scrape_sparks_vfx");

		parry_fx_pos = ((npcAttacker.GetWorldPosition() + thePlayer.GetWorldPosition()) * 0.5) + Vector(0, 0, RandRangeF(1.25f,1.125f));

		parry_fx = theGame.CreateEntity( parry_fx_temp, 
		parry_fx_pos, 
		npcAttacker.GetWorldRotation() );

		parry_fx.PlayEffectSingle('light_block');
		parry_fx.PlayEffectSingle('heavy_block');
		parry_fx.PlayEffectSingle('counterattack');

		parry_fx.PlayEffectSingle('parry_fx');

		parry_fx.PlayEffectSingle('parry_fx_secondary');

		parry_fx.DestroyAfter(3);

		action.SetAllProcessedDamageAs(0);
		action.SetWasDodged();
		action.ClearEffects();

		dmg = new W3DamageAction in theGame.damageMgr;
		
		dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
		
		dmg.SetProcessBuffsIfNoDamage(true);
		
		dmg.SetHitReactionType( EHRT_Light, true);

		dmg.SetCanPlayHitParticle(false);

		if (npcAttacker.UsesVitality()) 
		{ 
			damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.01; 
		} 
		else if (npcAttacker.UsesEssence()) 
		{ 
			damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.01; 
		} 

		dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + damageMax );

		dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + damageMax );

		dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
			
		delete dmg;

		if (!ACSGetCEntity('acs_swimming_dagger'))
		{
			vACS_Dagger_Summon = new cACS_Dagger_Summon in theGame;
		
			vACS_Dagger_Summon.ACS_Swimming_Dagger_Summon_Engage();
		}

		GetACSWatcher().RemoveTimer('SwimmingDaggerDestroyProcess');
		GetACSWatcher().AddTimer('SwimmingDaggerDestroyProcess', 3.5 , false );

		thePlayer.RaiseEvent('ACS_ForceHandClosedR');

		anim_names.Clear();

		if (GetACSWatcher().Attack_Directional_Press_Check())
		{
			anim_names.PushBack('ACS_SwordAttackStandaloneSwimAttack03');
			anim_names.PushBack('ACS_SwordAttackStandaloneSwimAttack04');
			anim_names.PushBack('ACS_SwordAttackStandaloneSwimAttack06');
			anim_names.PushBack('ACS_SwordAttackStandaloneSwimAttack07');
		}
		else
		{
			anim_names.PushBack('ACS_SwordAttackStandaloneSwimAttack02');
			anim_names.PushBack('ACS_SwordAttackStandaloneSwimAttack08');
			anim_names.PushBack('ACS_SwordAttackStandaloneSwimAttack09');
		}

		chosen_anim_name = anim_names[RandRange(anim_names.Size())];

		thePlayer.RaiseEvent(chosen_anim_name);

		return true;
	}

	if (
	((action.IsActionMelee() 
	&& thePlayer.HasTag('ACS_Player_Is_Attacking'))
	|| ((GetWitcherPlayer().IsCastingSign() || GetACSWatcher().ACS_Cast_Sign_Process) && !GetWitcherPlayer().IsCurrentSignChanneled())
	|| (thePlayer.rangedWeapon.IsWeaponBeingUsed() && thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponReload' && thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponAim')
	|| ((thePlayer.IsThrowingItem()
	|| thePlayer.IsThrowingItemWithAim()
	|| thePlayer.IsThrowHold()) && thePlayer.HasTag('ACS_Throw_Bomb_Counter_Start')))
	&& thePlayer.GetStat(BCS_Stamina) > 0
	&& !thePlayer.IsAttackerAtBack(npcAttacker)
	&& ACS_Settings_Main_Bool('acs_parry_skills_settings','acs_active_counter_system_enabled', true)
	&& npcAttacker != thePlayer
	&& !thePlayer.HasTag('ACS_Is_Currently_Flipping')
	&& !thePlayer.HasTag('ACS_In_Combat_Art')
	&& !thePlayer.IsInAir()
	&& !thePlayer.IsSwimming()
	&& !thePlayer.IsDiving()
	)
	{
		thePlayer.RemoveTag('ACS_Player_Is_Attacking');

		((CNewNPC)npc).ACS_DealPostureDamage(30);

		if (thePlayer.rangedWeapon.IsWeaponBeingUsed() 
		&& thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponReload' 
		&& thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponAim')
		{
			ACS_Tutorial_Display_Check('ACS_Crossbow_Parry_Tutorial_Shown');

			npcAttacker.AddTag('ACS_CrossbowCounterTarget');

			//thePlayer.OnRangedForceHolster(false, true, false);

			parry_fx_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

			thePlayer.SoundEvent("cmb_play_parry");
			thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_screech");
			thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_shock");
			thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_scrape_sparks_vfx");

			parry_fx_pos = ((npcAttacker.GetWorldPosition() + thePlayer.GetWorldPosition()) * 0.5) + Vector(0, 0, RandRangeF(1.25f,1.125f));

			parry_fx = theGame.CreateEntity( parry_fx_temp, 
			parry_fx_pos, 
			npcAttacker.GetWorldRotation() );

			//thePlayer.SoundEvent("sprj_kill_chance_bb_acs");
			thePlayer.SoundEvent("wall_large_bb_acs");

			if (((CMovingPhysicalAgentComponent)((npcAttacker).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
			|| (npcAttacker).GetRadius() >= 0.7
			|| (npcAttacker).HasAbility('Boss')
			|| (npcAttacker).HasTag('IsBoss')
			|| (npcAttacker).HasTag('ACS_Big_Boi')
			)
			{
				parry_fx.PlayEffectSingle('light_block_large');
				parry_fx.PlayEffectSingle('heavy_block_large');
				parry_fx.PlayEffectSingle('counterattack_large');

				parry_fx.PlayEffectSingle('parry_fx_large');
			}
			else
			{
				parry_fx.PlayEffectSingle('light_block');
				parry_fx.PlayEffectSingle('heavy_block');
				parry_fx.PlayEffectSingle('counterattack');

				parry_fx.PlayEffectSingle('parry_fx');
			}

			GetWitcherPlayer().SoundEvent('wall_a1_bb_acs');

			parry_fx.PlayEffectSingle('parry_fx_secondary');

			parry_fx.DestroyAfter(3);

			action.SetAllProcessedDamageAs(0);
			action.SetWasDodged();
			action.ClearEffects();

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Light, true);

			dmg.SetCanPlayHitParticle(false);

			if (npcAttacker.UsesVitality()) 
			{ 
				damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.01; 
			} 
			else if (npcAttacker.UsesEssence()) 
			{ 
				damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.01; 
			} 

			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + damageMax );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + damageMax );

			dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;

			return true;
		}

		if (((CMovingPhysicalAgentComponent)(npcAttacker.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
		|| npcAttacker.GetRadius() >= 0.7
		|| npcAttacker.HasAbility('Boss')
		|| npcAttacker.HasTag('IsBoss')
		|| npcAttacker.HasTag('ACS_Big_Boi')
		)
		{
			npcAttacker.DrainStamina( ESAT_FixedValue, npcAttacker.GetStatMax(BCS_Stamina) * 0.165, 2 );
		}
		else
		{
			npcAttacker.DrainStamina( ESAT_FixedValue, npcAttacker.GetStatMax(BCS_Stamina) * 0.33, 2 );
		}

		if ((GetWitcherPlayer().IsCastingSign() 
		&& !GetWitcherPlayer().IsCurrentSignChanneled()) 
		&& thePlayer.GetStat(BCS_Stamina) > 0)
		{
			ACS_Tutorial_Display_Check('ACS_Heliotrop_Parry_Tutorial_Shown');

			thePlayer.DrainStamina( ESAT_FixedValue, thePlayer.GetStatMax( BCS_Stamina ) * 0.125, 2 );

			parry_fx = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\sign_icons.w2ent", true ), 
			(thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * 0.75) + Vector(0, 0, 1.5f), 
			thePlayer.GetWorldRotation() );

			parry_fx.PlayEffectSingle('heliotrop_icon');
			parry_fx.ACS_StopEffectAfter('heliotrop_icon', 1.5);

			parry_fx.PlayEffectSingle('heliotrop_fx_01');
			parry_fx.PlayEffectSingle('heliotrop_fx_02');
			parry_fx.PlayEffectSingle('heliotrop_fx_03');
			parry_fx.PlayEffectSingle('heliotrop_explode_01');
			parry_fx.PlayEffectSingle('heliotrop_explode_02');

			//parry_fx.PlayEffectSingle('wave_attack_golem');
			//parry_fx.PlayEffectSingle('attack_special_golem');
			parry_fx.PlayEffectSingle('light_hit_parried_golem');
			parry_fx.PlayEffectSingle('heavy_hit_parried_golem');
			parry_fx.PlayEffectSingle('block_attack_fx_golem');

			parry_fx.CreateAttachment(thePlayer,'drain_energy', Vector(0,0.5,0), EulerAngles(0,0,0));

			parry_fx.DestroyAfter(10);

			//thePlayer.SoundEvent("sprj_kill_chance_bb_acs");
			thePlayer.SoundEvent("deflect_large_01_sekiro_acs");
			thePlayer.SoundEvent("sign_quen_charge_loop");
			thePlayer.SoundEvent("sign_quen_charge_loop_start");
			thePlayer.SoundEvent("sign_quen_charge_loop_stop");
			thePlayer.SoundEvent("sign_quen_discharge_rebound");
			thePlayer.SoundEvent("sign_quen_force_discharge");
			thePlayer.SoundEvent("sign_quen_force_discharge_stop");

			action.SetAllProcessedDamageAs(0);
			action.SetWasDodged();
			action.ClearEffects();

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

			thePlayer.RaiseEvent('ACS_CombatExtraHeliotrop');

			if (!GetACSWatcher().combatExtraActive)
			{
				GetACSWatcher().SetCombatExtraStatus(true);
			}

			GetACSWatcher().RemoveTimer('combatExtraReset');
			GetACSWatcher().AddTimer('combatExtraReset', 0.4 , false );

			GetWitcherPlayer().AbortSign();

			GetWitcherPlayer().SetCurrentlyCastSign( ST_None, NULL );

			GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_attack_countered_camera_shake_strength', 0.5), true, thePlayer.GetWorldPosition(), 30 );

			dmg = new W3DamageAction in theGame.damageMgr;
			
			dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Light, true);

			dmg.SetCanPlayHitParticle(false);

			if (npcAttacker.UsesVitality()) 
			{ 
				damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.01; 
			} 
			else if (npcAttacker.UsesEssence()) 
			{ 
				damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.01; 
			} 

			dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + damageMax );

			dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + damageMax );

			dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;
	
			return true;
		}

		if (thePlayer.IsWeaponHeld('fist')
		&& !thePlayer.HasTag('acs_vampire_claws_equipped')
		&& !thePlayer.HasTag('acs_sorc_fists_equipped') 
		)
		{
			parry_fx_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent" , true );

			thePlayer.SoundEvent("cmb_fistfight_parry");

			parry_fx_pos = ((npcAttacker.GetWorldPosition() + ((npcAttacker.GetWorldPosition() + thePlayer.GetWorldPosition()) * 0.5)) * 0.5) + Vector(0, 0, RandRangeF(1.25f,1.125f));
		}
		else
		{
			if (thePlayer.IsThrowingItem()
			|| thePlayer.IsThrowingItemWithAim()
			|| thePlayer.IsThrowHold())
			{
				parry_fx_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\blood_fx.w2ent" , true );

				thePlayer.SoundEvent("cmb_fistfight_parry");

				parry_fx_pos = ((npcAttacker.GetWorldPosition() + ((npcAttacker.GetWorldPosition() + thePlayer.GetWorldPosition()) * 0.5)) * 0.5) + Vector(0, 0, RandRangeF(1.25f,1.125f));
			}
			else
			{
				parry_fx_temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_trail.w2ent" , true );

				thePlayer.SoundEvent("cmb_play_parry");
				thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_screech");
				thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_shock");
				thePlayer.SoundEvent("monster_dettlaff_vampire_combat_claws_scrape_sparks_vfx");

				parry_fx_pos = ((npcAttacker.GetWorldPosition() + thePlayer.GetWorldPosition()) * 0.5) + Vector(0, 0, RandRangeF(1.25f,1.125f));
			}
		}

		parry_fx = theGame.CreateEntity( parry_fx_temp, 
		parry_fx_pos, 
		npcAttacker.GetWorldRotation() );

		if (((CMovingPhysicalAgentComponent)((npcAttacker).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
		|| (npcAttacker).GetRadius() >= 0.7
		|| (npcAttacker).HasAbility('Boss')
		|| (npcAttacker).HasTag('IsBoss')
		|| (npcAttacker).HasTag('ACS_Big_Boi')
		)
		{
			parry_fx.PlayEffectSingle('light_block_large');
			parry_fx.PlayEffectSingle('heavy_block_large');
			parry_fx.PlayEffectSingle('counterattack_large');

			parry_fx.PlayEffectSingle('parry_fx_large');
		}
		else
		{
			parry_fx.PlayEffectSingle('light_block');
			parry_fx.PlayEffectSingle('heavy_block');
			parry_fx.PlayEffectSingle('counterattack');

			parry_fx.PlayEffectSingle('parry_fx');
		}

		GetWitcherPlayer().SoundEvent('wall_a1_bb_acs');

		parry_fx.PlayEffectSingle('parry_fx_secondary');

		parry_fx.PlayEffectSingle('fist_hit_indicator');
		parry_fx.PlayEffectSingle('hit_refraction_red');

		parry_fx.DestroyAfter(3);

		if ((thePlayer.IsThrowingItem()
		|| thePlayer.IsThrowingItemWithAim()
		|| thePlayer.IsThrowHold())
		&& !thePlayer.IsCrossbowHeld()
		)
		{
			ACS_Tutorial_Display_Check('ACS_Bomb_Parry_Tutorial_Shown');

			action.SetAllProcessedDamageAs(0);
			action.SetWasDodged();
			action.ClearEffects();

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

			GetACSWatcher().dodge_timer_actual();

			if(ACS_Settings_Main_Bool('acs_parry_skills_settings','acs_active_counter_system_slow_motion_enabled', false))
			{
				GetACSWatcher().ACS_SlowMoAdjustable(0.3,0.3);
			}

			thrownEntity = (CThrowable)EntityHandleGet( thePlayer.thrownEntityHandle );

			thrownEntityPath = thrownEntity.GetReadableName();

			GetWitcherPlayer().BombThrowAbort();

			thePlayer.OnThrowAnimLeave();

			if (thePlayer.HasTag('ACS_Throw_Bomb_Counter_Start'))
			{
				GetACSWatcher().RemoveTimer('ACS_Throw_Bomb_Counter_Tag_Remove');

				thePlayer.RemoveTag('ACS_Throw_Bomb_Counter_Start');

				selectedItemId = thePlayer.GetSelectedItemId();

				if(thePlayer.inv.IsItemBomb(selectedItemId))
				{
					thePlayer.inv.SingletonItemRemoveAmmo(selectedItemId, 1);
				}

				if (RandF() < 0.5)
				{
					GetACSWatcher().PlayerPlayAnimation( 'man_npc_sword_1hand_push_2_ACS');
				}
				else
				{
					GetACSWatcher().PlayerPlayAnimation( 'man_npc_sword_1hand_push_1_ACS');	
				}

				//thePlayer.RaiseEvent('ACS_GoPloughYourself');

				detonationTimer = RandRangeF(5,3);

				plantedBomb = (W3Petard)theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				"dlc\dlc_acs\data\entities\projectiles\acs_shrapnel_bomb.w2ent"
				, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );


				plantedBombSecondary = (W3Petard)theGame.CreateEntity( (CEntityTemplate)LoadResource( 
				thrownEntityPath
				, true ), thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );

				theSound.SoundEvent("gui_inventory_bombs_attach");
				theSound.SoundEvent("gui_inventory_other_attach");

				plantedBomb.Init(thePlayer);

				plantedBombSecondary.Init(thePlayer);

				if ( npcAttacker.GetBoneIndex('torso') != -1 )
				{
					npcAttacker.GetBoneWorldPositionAndRotationByIndex( npcAttacker.GetBoneIndex( 'torso' ), bonePosition, boneRotation );

					plantedBomb.CreateAttachmentAtBoneWS(npcAttacker, 'torso', bonePosition, boneRotation);

					plantedBombSecondary.CreateAttachmentAtBoneWS(npcAttacker, 'torso', bonePosition, boneRotation);
				}
				else
				{
					if ( npcAttacker.GetBoneIndex('k_torso_g') != -1 )
					{
						npcAttacker.GetBoneWorldPositionAndRotationByIndex( npcAttacker.GetBoneIndex( 'k_torso_g' ), bonePosition, boneRotation );

						plantedBomb.CreateAttachmentAtBoneWS(npcAttacker, 'k_torso_g', bonePosition, boneRotation);

						plantedBombSecondary.CreateAttachmentAtBoneWS(npcAttacker, 'k_torso_g', bonePosition, boneRotation);
					}
					else
					{
						plantedBomb.CreateAttachment(npcAttacker, 'blood_point', Vector(0,0,0), npcAttacker.GetWorldRotation());

						plantedBombSecondary.CreateAttachment(npcAttacker, 'blood_point', Vector(0,0,0), npcAttacker.GetWorldRotation());
					}
				}

				plantedBomb.RemoveTimer('ACS_DetonationTimer');
				plantedBomb.AddTimer('ACS_DetonationTimer', detonationTimer , false );

				plantedBombSecondary.RemoveTimer('DetonationTimer');
				plantedBombSecondary.AddTimer('DetonationTimer', detonationTimer , false );

				plantedBomb.PlayEffect('fx_trail');
				plantedBomb.PlayEffect('sparks');

				plantedBombSecondary.PlayEffect('fx_trail');
				plantedBombSecondary.PlayEffect('sparks');

				plantedBomb.PlayEffect('tell');

				if (StrContains( thrownEntityPath, "frost" ))
				{
					plantedBomb.AddTag('ACS_Bomb_Add_Frozen');
				}

				if (StrContains( thrownEntityPath, "virus" ))
				{
					plantedBomb.AddTag('ACS_Bomb_Add_Poison');
				}

				if (StrContains( thrownEntityPath, "dancing" ))
				{
					plantedBomb.AddTag('ACS_Bomb_Add_Knockdown');
				}

				if (StrContains( thrownEntityPath, "samum" ))
				{
					plantedBomb.AddTag('ACS_Bomb_Add_Blindness');
				}

				npcAttacker.AddTag('ACS_Bomb_Planted');

				animatedComponentA = (CAnimatedComponent)npcAttacker.GetComponentByClassName( 'CAnimatedComponent' );

				animatedComponentA.UnfreezePose();

				animatedComponentA.FreezePose();

				animatedComponentA.UnfreezePoseFadeOut(1.5f);
				
			}
		}
		else
		{
			ACS_Tutorial_Display_Check('ACS_Active_Counter_Tutorial_Shown');

			action.SetAllProcessedDamageAs(0);
			action.SetWasDodged();
			action.ClearEffects();

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

			GetACSWatcher().dodge_timer_actual();

			if(ACS_Settings_Main_Bool('acs_parry_skills_settings','acs_active_counter_system_slow_motion_enabled', false))
			{
				GetACSWatcher().ACS_SlowMoAdjustable(0.3,0.3);
			}

			npcAttacker.AddTag('ACS_NPC_Ready_For_Mounted_Attack_Attachment');

			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& GetACSWatcher().AnimProgressCheck()
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				thePlayer.SetBehaviorVariable( 'parryType', RandRange(9) );
				thePlayer.RaiseForceEvent( 'PerformParry' );
			}

			if (thePlayer.acs_grey_health_current > 0)
			{
				GetWitcherPlayer().GainStat( BCS_Vitality, thePlayer.acs_grey_health_current ); 

				GetACSWatcher().ShowHealFloatingValue( thePlayer.acs_grey_health_current, true);

				thePlayer.ACS_ManageGreyHealth(false, thePlayer.acs_grey_health_current);
			}

			GetACSWatcher().ShowHealFloatingValue((thePlayer.GetMaxHealth() - thePlayer.GetCurrentHealth()) * 0.5, true);

			thePlayer.GainStat( BCS_Stamina, (thePlayer.GetStatMax( BCS_Stamina) - thePlayer.GetStat( BCS_Stamina)) * 0.5 );

			thePlayer.GainStat( BCS_Focus, (thePlayer.GetStatMax( BCS_Focus) - thePlayer.GetStat( BCS_Focus) ) * 0.33 );
		}

		GCameraShake( ACS_Settings_Main_Float('acs_hud_camera_settings_main','acs_attack_countered_shake_strength', 0.5), true, thePlayer.GetWorldPosition(), 30 );

		dmg = new W3DamageAction in theGame.damageMgr;
			
		dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
		
		dmg.SetProcessBuffsIfNoDamage(true);
		
		dmg.SetHitReactionType( EHRT_Light, true);

		if (npcAttacker 
		&& npcAttacker.IsHuman() 
		&& npcAttacker.IsMan()
		&& npcAttacker != thePlayer
		&& !npcAttacker.HasTag('ACS_man_finisher_dlc_arm_lp_combat_dismember')
		&& !npcAttacker.HasTag('ACS_man_finisher_dlc_arm_rp_combat_dismember')
		&& !npcAttacker.HasTag('ACS_man_finisher_dlc_legs_lp_combat_dismember')
		&& !npcAttacker.HasTag('ACS_man_finisher_dlc_legs_rp_combat_dismember')
		&& !npcAttacker.HasTag('ACS_Swapped_To_Shield')
		&& !npcAttacker.UsesEssence()
		&& thePlayer.IsDeadlySwordHeld()
		&& !thePlayer.IsCastingSign()
		&& !thePlayer.IsThrowingItem()
		&& !thePlayer.IsThrowingItemWithAim()
		&& !thePlayer.IsThrowHold()
		&& !thePlayer.HasTag('ACS_Throw_Bomb_Counter_Start')
		&& !plantedBomb
		&& !plantedBombSecondary
		&& GetAttitudeBetween( npcAttacker, GetWitcherPlayer() ) == AIA_Hostile
		&& VecDistanceSquared2D( npcAttacker.GetWorldPosition(), GetWitcherPlayer().GetWorldPosition() ) <= 4*4
		&& ACS_Settings_Main_Bool('acs_custom_finishers_settings','acs_active_counter_combat_dismemberment_enabled', true)
		&& GetACSWatcher().CanPerformFinisher()
		&& npcAttacker.HasTag('ACS_Final_Combat_Dismember_Check')
		&& !npcAttacker.HasAbility('Boss')
		&& !npcAttacker.HasTag('IsBoss')
		)
		{
			GetACSWatcher().RefreshFinisherCooldown();

			finisher_anim_names.Clear();

			if (GetACSWatcher().CustomFinishersBindTrigger(ACS_GetFinishersBind('stab')))
			{
				if (RandF() < 0.5)
				{
					finisher_anim_names.PushBack('combat_dismember_legs_rp');
				}
				else
				{
					finisher_anim_names.PushBack('combat_dismember_legs_lp');
				}

				finisher_anim_names.PushBack('combat_dismember_arm_lp');
				finisher_anim_names.PushBack('combat_dismember_arm_rp');
			}
			else if (GetACSWatcher().CustomFinishersBindTrigger(ACS_GetFinishersBind('arm_left')))
			{
				finisher_anim_names.PushBack('combat_dismember_arm_lp');
			}
			else if (GetACSWatcher().CustomFinishersBindTrigger(ACS_GetFinishersBind('arm_right')))
			{
				finisher_anim_names.PushBack('combat_dismember_arm_rp');
			}
			else if (GetACSWatcher().CustomFinishersBindTrigger(ACS_GetFinishersBind('leg_left')))
			{
				finisher_anim_names.PushBack('combat_dismember_legs_lp');
			}
			else if (GetACSWatcher().CustomFinishersBindTrigger(ACS_GetFinishersBind('leg_right')))
			{
				finisher_anim_names.PushBack('combat_dismember_legs_rp');
			}
			else
			{
				if (RandF() < 0.5)
				{
					finisher_anim_names.PushBack('combat_dismember_legs_rp');
				}
				else
				{
					finisher_anim_names.PushBack('combat_dismember_legs_lp');
				}

				finisher_anim_names.PushBack('combat_dismember_arm_lp');
				finisher_anim_names.PushBack('combat_dismember_arm_rp');
			}

			GetACSWatcher().ACS_SetupSyncAnimInternalHumanCombatDismember(finisher_anim_names[RandRange(finisher_anim_names.Size())], thePlayer, npcAttacker);

			if (npcAttacker.UsesVitality()) 
			{ 
				damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.33; 
			} 
			else if (npcAttacker.UsesEssence()) 
			{ 
				damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.33; 
			} 

			npcAttacker.RemoveTag('ACS_Final_Combat_Dismember_Check');
		}
		else
		{
			if ( thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& npcAttacker.IsAlive()
			)
			{
				if (RandF() < 0.5)
				{
					//GetACSWatcher().PlayerPlayAnimation('tw2_npc_sword1h_31_ACS');
				}
				else
				{
					//GetACSWatcher().PlayerPlayAnimation('tw2_npc_sword1h_17_ACS');
				}

				//movementAdjustor.CancelAll();
				//ticket = movementAdjustor.CreateNewRequest( 'ACSMovAdj' );

				//movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );
				//movementAdjustor.MaxLocationAdjustmentSpeed( ticket, 50000 );

				//movementAdjustor.AdjustmentDuration( ticket, 0.5f );

				//thePlayer.RaiseEvent('ACS_AimAssistDodgeForwardR');

				//movementAdjustor.SlideTo( ticket, thePlayer.GetWorldPosition() + thePlayer.GetWorldForward() * RandRangeF(-1.5, -3) ); 


				if (!npcAttacker.HasTag('ACS_Final_Combat_Dismember_Check')
				)
				{
					npcAttacker.AddTag('ACS_Final_Combat_Dismember_Check');
				}
			}
		}
		
		dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + damageMax );

		dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + damageMax );

		if (plantedBomb)
		{
			dmg.AddEffectInfo(EET_Stagger, 3);
		}
			
		dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
			
		delete dmg;

		return true;
	}

	return false;
}

/*
function ACS_Death_Animations(action: W3DamageAction)
{
    var npcAttacker 									    : CActor;

	npcAttacker = (CActor)action.attacker;

    if(GetWitcherPlayer().HasTag('acs_vampire_claws_equipped'))
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
        }
        else
        {
           GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_back_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
        }

        GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.5 , false );
    }
    else
    {
        if( RandF() < 0.5 ) 
        { 																		
            if( RandF() < 0.5 ) 
            { 
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1 , false );
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1 , false );
            }
        }
        else
        {	
            if( RandF() < 0.5 ) 
            { 
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_wounded_knockdown_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 0.5 , false );
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1 , false );
            }
        }
    }
}

function ACS_Death_Animations_For_Falling(action: W3DamageAction)
{
    var npcAttacker 									    : CActor;

	npcAttacker = (CActor)action.attacker;

    if( RandF() < 0.5 ) 
	{ 
		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1 , false );
	}
	else
	{
		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1 , false );
	}
}
*/

function ACS_Hit_Animations(action: W3DamageAction)
{
    var npcAttacker 									    : CActor;
	var hit_anim_names										: array< name >;

	if (thePlayer.IsCiri())
	{
		return;
	}

	if (!GetWitcherPlayer())
	{
		return;
	}

	if (!GetWitcherPlayer().IsActionAllowed(EIAB_Movement))
	{
		return;
	}
	
	if (!GetWitcherPlayer().IsActionAllowed(EIAB_LightAttacks))
	{
		return;
	}

	if (GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) 
	&& !GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) 
	&& GetWitcherPlayer().CanUseSkill(S_Sword_s01)
	)
	{
		return;
	}

	if (thePlayer.HasBuff( EET_Mutagen08 ))
	{
		return;
	}

	if (GetWitcherPlayer().HasTag('ACS_Bruxa_Bite_Process')
	|| GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	|| GetWitcherPlayer().HasTag('acs_yrden_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_yrden_sword_equipped')
	|| GetWitcherPlayer().HasTag('ACS_Player_Is_Attacking')
	|| GetWitcherPlayer().HasTag('ACS_Air_Time')
	|| GetWitcherPlayer().IsCurrentlyDodging()
	|| GetWitcherPlayer().GetImmortalityMode() == AIM_Invulnerable
	|| GetWitcherPlayer().IsPerformingFinisher() 
	|| !GetWitcherPlayer().CanPlayHitAnim()
	|| ACS_Armor_Set_Check('acs_armor_omega', false)
	|| ACS_New_Replacers_Female_Active()
	)
	{
		return;
	}

	thePlayer.RaiseEvent('ACS_TW1AnimsReset');

	GetACSWatcher().RemoveTimer('SignIconDelay');

	npcAttacker = (CActor)action.attacker;

	GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor().CancelAll();

	GetWitcherPlayer().ACS_ClearAnimationSpeedMultipliers();	

	hit_anim_names.Clear();
	
    if ( ( GetWitcherPlayer().HasTag('acs_vampire_claws_equipped') 
	&& !GetWitcherPlayer().HasBuff(EET_BlackBlood) ) 
	|| GetWitcherPlayer().HasTag('acs_aard_sword_equipped') 
	|| ACS_Vampire_Claws_Access()
	)
    {
        GetACSWatcher().RemoveTimer('ACS_Dash_Attack_Process'); GetACSWatcher().RemoveTimer('ACS_Vampire_Claws_Sword_Hybrid_Dash'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

		ACS_Bruxa_Camo_Decoy_Deactivate();

		GetWitcherPlayer().StopEffect('shadowdash_ACS');

		GetWitcherPlayer().StopEffect('shadowdash_short');

        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
			hit_anim_names.PushBack('reaction_hit_front_ACS');
			hit_anim_names.PushBack('reaction_hit_front_down_ACS');
			hit_anim_names.PushBack('reaction_hit_front_up_ACS');
			hit_anim_names.PushBack('reaction_hit_front_left_ACS');
			hit_anim_names.PushBack('reaction_hit_front_left_down_ACS');
			hit_anim_names.PushBack('reaction_hit_front_left_up_ACS');
			hit_anim_names.PushBack('reaction_hit_front_right_ACS');
			hit_anim_names.PushBack('reaction_hit_front_right_down_ACS');
			hit_anim_names.PushBack('reaction_hit_front_right_up_ACS');
		}
        else
        {
			hit_anim_names.PushBack('reaction_hit_back_1_ACS');
			hit_anim_names.PushBack('reaction_hit_back_ACS');
        }
    }
    else if(GetWitcherPlayer().HasTag('acs_quen_sword_equipped'))
    {
        if (GetWitcherPlayer().GetStat(BCS_Vitality) <= GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.5)
        {
            if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
            {
				hit_anim_names.PushBack('ethereal_hit_cheast_lp_001_ACS');
				hit_anim_names.PushBack('ethereal_hit_head_lp_ACS');
				hit_anim_names.PushBack('ethereal_hit_head_rp_ACS');
				hit_anim_names.PushBack('ethereal_hit_leg_lp_ACS');
				hit_anim_names.PushBack('ethereal_hit_leg_rp_ACS');      
            }
            else
            {
				hit_anim_names.PushBack('man_ger_sword_hit_back_1'); 
            }
        }
        else
        {
            if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
            {
				hit_anim_names.PushBack('hit_combat_front_down_ACS');
				hit_anim_names.PushBack('hit_combat_front_hips_ACS');
				hit_anim_names.PushBack('hit_down_front_strong_ACS');
				hit_anim_names.PushBack('hit_forward_front_strong_ACS');
				hit_anim_names.PushBack('hit_combat_front_head_left_ACS');  
				hit_anim_names.PushBack('hit_combat_front_head_right_ACS');
				hit_anim_names.PushBack('hit_forward_front_head_left_ACS');
				hit_anim_names.PushBack('hit_forward_front_head_right_ACS');
				hit_anim_names.PushBack('hit_combat_front_heavy_left_ACS');
				hit_anim_names.PushBack('hit_combat_front_heavy_right_ACS');  
				hit_anim_names.PushBack('hit_combat_front_light_left_ACS');
				hit_anim_names.PushBack('hit_combat_front_light_right_ACS');
				hit_anim_names.PushBack('hit_forward_front_light_left_ACS');
				hit_anim_names.PushBack('hit_forward_front_light_right_ACS');
				hit_anim_names.PushBack('hit_down_front_left_ACS');  
				hit_anim_names.PushBack('hit_down_front_right_ACS');
				hit_anim_names.PushBack('hit_down_front_head_ACS');
				hit_anim_names.PushBack('hit_forward_front_head_ACS');
				hit_anim_names.PushBack('hit_down_front_head_down_ACS');
				hit_anim_names.PushBack('hit_down_front_head_down_left_ACS');  
				hit_anim_names.PushBack('hit_down_front_head_left_ACS');
				hit_anim_names.PushBack('hit_down_front_head_right_ACS');
            }	
            else
            {
               hit_anim_names.PushBack('man_ger_sword_hit_back_1'); 
            }
        }    
    }
    else if( GetWitcherPlayer().HasTag('acs_quen_secondary_sword_equipped') || GetWitcherPlayer().HasTag('acs_aard_secondary_sword_equipped') )
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_lp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_right_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_lp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_rp_01_ACS');  
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_up_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_down_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_right_up_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_up_lp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_up_lp_01_ACS');  
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_up_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_right_down_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_down_lp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_front_left_down_rp_01_ACS');
			hit_anim_names.PushBack('hit_down_front_left_ACS');  
			hit_anim_names.PushBack('hit_down_front_right_ACS');
			hit_anim_names.PushBack('hit_down_front_head_ACS');
			hit_anim_names.PushBack('hit_forward_front_head_ACS');
			hit_anim_names.PushBack('hit_down_front_head_down_ACS');
			hit_anim_names.PushBack('hit_down_front_head_down_left_ACS');  
			hit_anim_names.PushBack('hit_down_front_head_left_ACS');
			hit_anim_names.PushBack('hit_down_front_head_right_ACS');
			hit_anim_names.PushBack('hit_forward_front_head_left_ACS');
			hit_anim_names.PushBack('hit_forward_front_head_right_ACS');
        }
        else
        {
			hit_anim_names.PushBack('man_npc_2hhammer_hit_back_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_2hhammer_hit_back_lp_01_ACS');
        }
    }
    else if( GetWitcherPlayer().HasTag('acs_axii_sword_equipped') )
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
			hit_anim_names.PushBack('man_longsword_hit_front_01_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_02_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_03_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_04_ACS');
			hit_anim_names.PushBack('man_npc_longsword_hit_front_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_05_ACS');
			hit_anim_names.PushBack('man_npc_longsword_hit_front_down_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_down_01_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_down_02_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_down_03_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_down_04_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_up_01_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_up_02_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_up_03_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_up_04_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_up_05_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_up_06_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_up_07_ACS');
			hit_anim_names.PushBack('man_npc_longsword_hit_front_up_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_01_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_left_02_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_03_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_04_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_05_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_left_06_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_07_ACS');
			hit_anim_names.PushBack('man_npc_longsword_hit_left_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_right_01_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_right_02_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_right_03_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_right_04_ACS');
			hit_anim_names.PushBack('man_npc_longsword_hit_right_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_left_down_01_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_down_02_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_down_03_ACS');
			hit_anim_names.PushBack('man_npc_longsword_hit_left_down_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_left_down_04_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_down_05_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_right_down_01_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_right_down_02_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_right_down_03_ACS');
			hit_anim_names.PushBack('man_npc_longsword_hit_right_down_ACS');
			hit_anim_names.PushBack('man_npc_longsword_hit_left_up_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_up_01_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_up_02_ACS');  
			hit_anim_names.PushBack('man_longsword_hit_front_left_up_03_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_left_up_04_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_right_up_01_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_right_up_02_ACS');
			hit_anim_names.PushBack('man_longsword_hit_front_right_up_03_ACS');  
			hit_anim_names.PushBack('man_npc_longsword_hit_right_up_ACS');
        }
        else
        {
          	hit_anim_names.PushBack('man_npc_longsword_hit_back_ACS');
        }
    }
    else if( GetWitcherPlayer().HasTag('acs_axii_secondary_sword_equipped') )
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
			hit_anim_names.PushBack('man_npc_sword_1hand_hit_front_lp_01_ACS');
			hit_anim_names.PushBack('man_npc_sword_1hand_hit_front_rp_01_ACS');
			hit_anim_names.PushBack('man_npc_sword_2hand_hit_light_f_1_ACS');
			hit_anim_names.PushBack('man_npc_sword_2hand_hit_light_f_2_ACS');
        }	
        else
        {
            hit_anim_names.PushBack('man_npc_sword_2hand_hit_light_b_1_ACS');
        }
    }
    else if( 
	GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('acs_igni_sword_equipped_TAG')
	|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped_TAG')
	) 
    {
		if (ACS_Armor_Set_Check('bear', true)
		|| ACS_Armor_Set_Check('forgotten_wolf', true)
		|| thePlayer.HasTag('ACS_In_Dance_Of_Wrath')
		|| thePlayer.HasTag('ACS_In_Heavenly_Strike')
		|| thePlayer.HasTag('ACS_In_Ciri_Special_Attack')
		)
		{
			return;
		}

		if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
		{
			hit_anim_names.PushBack('man_geralt_sword_hit_front_rp_01');
			hit_anim_names.PushBack('man_geralt_sword_hit_front_lp_01');

			hit_anim_names.PushBack('man_geralt_sword_hit_front_down_rp_01');
			hit_anim_names.PushBack('man_geralt_sword_hit_front_up_rp_01');
			hit_anim_names.PushBack('man_geralt_sword_hit_front_left_lp_01');  
			hit_anim_names.PushBack('man_geralt_sword_hit_front_right_rp_01');

			hit_anim_names.PushBack('man_geralt_sword_hit_front_right_up_rp_01');
			hit_anim_names.PushBack('man_geralt_sword_hit_front_left_down_lp_01');
			hit_anim_names.PushBack('man_geralt_sword_hit_front_right_down_rp_01');
			hit_anim_names.PushBack('man_geralt_sword_hit_front_left_up_lp_01');  
		}	
		else
		{
			hit_anim_names.PushBack('man_ger_sword_hit_back_1');  
		}
	}
	else
	{
		if (thePlayer.IsWeaponHeld('fist'))
		{
			if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
			{
				hit_anim_names.PushBack('man_fistfight_hit_front_1');
				hit_anim_names.PushBack('man_fistfight_close_hit_front_1');
				hit_anim_names.PushBack('man_fistfight_close_hit_front_2');
				hit_anim_names.PushBack('man_fistfight_hit_right_1');
				hit_anim_names.PushBack('man_fistfight_hit_left_1');
				hit_anim_names.PushBack('man_fistfight_close_hit_left_1');
				hit_anim_names.PushBack('man_fistfight_close_hit_low_front_1');
				hit_anim_names.PushBack('man_fistfight_close_hit_low_left_1');
				hit_anim_names.PushBack('man_fistfight_close_hit_low_right_1');
				hit_anim_names.PushBack('man_fistfight_close_hit_right_1');
			}	
			else
			{
				hit_anim_names.PushBack('man_fistfight_hit_back_1');  
			}
		}
		else
		{
			if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
			{
				hit_anim_names.PushBack('man_geralt_sword_hit_front_rp_01');
				hit_anim_names.PushBack('man_geralt_sword_hit_front_lp_01');

				hit_anim_names.PushBack('man_geralt_sword_hit_front_down_rp_01');
				hit_anim_names.PushBack('man_geralt_sword_hit_front_up_rp_01');
				hit_anim_names.PushBack('man_geralt_sword_hit_front_left_lp_01');  
				hit_anim_names.PushBack('man_geralt_sword_hit_front_right_rp_01');

				hit_anim_names.PushBack('man_geralt_sword_hit_front_right_up_rp_01');
				hit_anim_names.PushBack('man_geralt_sword_hit_front_left_down_lp_01');
				hit_anim_names.PushBack('man_geralt_sword_hit_front_right_down_rp_01');
				hit_anim_names.PushBack('man_geralt_sword_hit_front_left_up_lp_01');  
			}	
			else
			{
				hit_anim_names.PushBack('man_ger_sword_hit_back_1');  
			}
		}
		
	}	

	GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( hit_anim_names[RandRange(hit_anim_names.Size())], 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );	
}

function ACS_Transformation_Entity_Hit_Animations( entity : name )
{
	var hit_anim_names	: array<name>;

	hit_anim_names.Clear();

	switch(entity)
	{
		case'black_wolf':
		ACSGetCActor('ACS_Transformation_Black_Wolf').DestroyEffect('light_hit');

		ACSGetCActor('ACS_Transformation_Black_Wolf').PlayEffectSingle('light_hit');

		hit_anim_names.PushBack('wolf_hit_front');
		hit_anim_names.PushBack('wolf_hit_left');
		hit_anim_names.PushBack('wolf_hit_right');

		GetACSWatcher().ACSTransformationBlackWolfRemoveMoveTimers();

		GetACSWatcher().ACSTransformBlackWolfPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.25f);
		break;

		case'sharley':
		ACSGetCActor('ACS_Transformation_Sharley').DestroyEffect('light_hit');
		ACSGetCActor('ACS_Transformation_Sharley').DestroyEffect('heavy_hit');
		ACSGetCActor('ACS_Transformation_Sharley').DestroyEffect('light_hit_back');
		ACSGetCActor('ACS_Transformation_Sharley').DestroyEffect('heavy_hit_back');
		ACSGetCActor('ACS_Transformation_Sharley').DestroyEffect('blood_spill');

		ACSGetCActor('ACS_Transformation_Sharley').PlayEffectSingle('light_hit');
		ACSGetCActor('ACS_Transformation_Sharley').PlayEffectSingle('heavy_hit');
		ACSGetCActor('ACS_Transformation_Sharley').PlayEffectSingle('light_hit_back');
		ACSGetCActor('ACS_Transformation_Sharley').PlayEffectSingle('heavy_hit_back');
		ACSGetCActor('ACS_Transformation_Sharley').PlayEffectSingle('blood_spill');

		hit_anim_names.PushBack('hit_light_front');
		hit_anim_names.PushBack('hit_light_left');
		hit_anim_names.PushBack('hit_light_right');

		GetACSWatcher().ACSTransformationSharleyRemoveMoveTimers();

		GetACSWatcher().ACSTransformSharleyPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.25f);
		break;

		case'red_miasmal':
		ACSGetCActor('ACS_Transformation_Red_Miasmal').DestroyEffect('light_hit');
		ACSGetCActor('ACS_Transformation_Red_Miasmal').DestroyEffect('heavy_hit');
		ACSGetCActor('ACS_Transformation_Red_Miasmal').DestroyEffect('light_hit_back');
		ACSGetCActor('ACS_Transformation_Red_Miasmal').DestroyEffect('heavy_hit_back');
		ACSGetCActor('ACS_Transformation_Red_Miasmal').DestroyEffect('blood_spill');

		ACSGetCActor('ACS_Transformation_Red_Miasmal').PlayEffectSingle('light_hit');
		ACSGetCActor('ACS_Transformation_Red_Miasmal').PlayEffectSingle('heavy_hit');
		ACSGetCActor('ACS_Transformation_Red_Miasmal').PlayEffectSingle('light_hit_back');
		ACSGetCActor('ACS_Transformation_Red_Miasmal').PlayEffectSingle('heavy_hit_back');
		ACSGetCActor('ACS_Transformation_Red_Miasmal').PlayEffectSingle('blood_spill');

		hit_anim_names.PushBack('monster_lessun_hit_light_f');
		hit_anim_names.PushBack('monster_lessun_hit_light_left');
		hit_anim_names.PushBack('monster_lessun_hit_light_right');
		hit_anim_names.PushBack('monster_lessun_hit_strong_f');
		hit_anim_names.PushBack('monster_lessun_hit_strong_left');
		hit_anim_names.PushBack('monster_lessun_hit_strong_right');

		GetACSWatcher().ACSTransformationRedMiasmalRemoveMoveTimers();

		GetACSWatcher().ACSTransformRedMiasmalPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.25f);
		break;

		case'vampire_monster':
		if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Monster_Is_Parrying'))
		{
			GetACSWatcher().ACSVampireMonsterRemoveAttackTimers();
			
			hit_anim_names.PushBack('dettlaff_construct_parry_right');
			hit_anim_names.PushBack('dettlaff_construct_parry_left');
			//vampire_monster_hit_anim_names.PushBack('dettlaff_construct_parry_double');
			hit_anim_names.PushBack('dettlaff_construct_parry_single');
			hit_anim_names.PushBack('dettlaff_construct_parry_double_last_atk');

			GetACSWatcher().ACSTransformVampireMonsterPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.25f);
		}
		else
		{
			if (ACSGetCActor('ACS_Transformation_Vampire_Monster').HasTag('ACS_Transformation_Vampire_Monster_Blood_Armor'))
			{
				ACSGetCActor('ACS_Transformation_Vampire_Monster').StopEffect('light_hit');
				ACSGetCActor('ACS_Transformation_Vampire_Monster').PlayEffectSingle('light_hit');

				ACSGetCActor('ACS_Transformation_Vampire_Monster').DestroyEffect('body_blood_drip');
				ACSGetCActor('ACS_Transformation_Vampire_Monster').PlayEffectSingle('body_blood_drip');
				ACSGetCActor('ACS_Transformation_Vampire_Monster').StopEffect('body_blood_drip');
			}
			else
			{
				GetACSWatcher().ACSVampireMonsterRemoveAttackTimers();

				hit_anim_names.PushBack('detlaff_biped_hit_up_01');

				hit_anim_names.PushBack('dettlaff_construct_recovery_ACS');

				GetACSWatcher().ACSTransformVampireMonsterPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.25f);
			}
		}
		break;

		case'vampiress':
		GetACSWatcher().ACSVampiressRemoveAttackTimers();

		if (ACSGetCActor('ACS_Transformation_Vampiress').HasTag('ACS_Vampiress_Is_Parrying'))
		{
			hit_anim_names.PushBack('bruxa_parry_center');
			hit_anim_names.PushBack('bruxa_parry_left');
			hit_anim_names.PushBack('bruxa_parry_right');
			hit_anim_names.PushBack('parry_left_01');
			hit_anim_names.PushBack('parry_right_01');
			hit_anim_names.PushBack('parry_left_back_01');
			hit_anim_names.PushBack('parry_right_back_01');
			hit_anim_names.PushBack('parry_left_back_02');
			hit_anim_names.PushBack('parry_right_back_02');

			GetACSWatcher().ACSTransformVampiressPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.5f);
		}
		else
		{
			ACSGetCActor('ACS_Transformation_Vampiress').DestroyEffect('light_hit');
			ACSGetCActor('ACS_Transformation_Vampiress').DestroyEffect('heavy_hit');
			ACSGetCActor('ACS_Transformation_Vampiress').DestroyEffect('light_hit_back');
			ACSGetCActor('ACS_Transformation_Vampiress').DestroyEffect('heavy_hit_back');
			ACSGetCActor('ACS_Transformation_Vampiress').DestroyEffect('blood_spill');

			ACSGetCActor('ACS_Transformation_Vampiress').PlayEffectSingle('light_hit');
			ACSGetCActor('ACS_Transformation_Vampiress').PlayEffectSingle('heavy_hit');
			ACSGetCActor('ACS_Transformation_Vampiress').PlayEffectSingle('light_hit_back');
			ACSGetCActor('ACS_Transformation_Vampiress').PlayEffectSingle('heavy_hit_back');
			ACSGetCActor('ACS_Transformation_Vampiress').PlayEffectSingle('blood_spill');

			if (!ACSGetCActor('ACS_Transformation_Vampiress').HasTag('ACS_Vampiress_Sorceress_Mode'))
			{
				hit_anim_names.PushBack('bruxa_hit_heavy_front');
				hit_anim_names.PushBack('bruxa_hit_light_front');
				hit_anim_names.PushBack('reaction_hit_front');
				hit_anim_names.PushBack('reaction_hit_front_left_down');
				hit_anim_names.PushBack('reaction_hit_front_left_up');
				hit_anim_names.PushBack('reaction_hit_front_down');
				hit_anim_names.PushBack('reaction_hit_front_right_up');
				hit_anim_names.PushBack('reaction_hit_front_left');
				hit_anim_names.PushBack('reaction_hit_front_right');
				hit_anim_names.PushBack('reaction_hit_front_up');
				hit_anim_names.PushBack('reaction_hit_front_right_down');
			}
			else
			{
				hit_anim_names.PushBack('woman_sorceress_hit_front');
				hit_anim_names.PushBack('woman_sorceress_hit_front_down');
				hit_anim_names.PushBack('woman_sorceress_hit_front_left');
				hit_anim_names.PushBack('woman_sorceress_hit_front_left_up');
				hit_anim_names.PushBack('woman_sorceress_hit_front_right');
				hit_anim_names.PushBack('woman_sorceress_hit_front_right_down');
				hit_anim_names.PushBack('woman_sorceress_hit_front_right_up');
				hit_anim_names.PushBack('woman_sorceress_hit_front_up');
				hit_anim_names.PushBack('woman_sorceress_hit_left_down');
			}

			GetACSWatcher().ACSTransformVampiressPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.5f);
		}
		break;

		case'werewolf':
		ACSGetCActor('ACS_Transformation_Werewolf').DestroyEffect('light_hit');
		ACSGetCActor('ACS_Transformation_Werewolf').DestroyEffect('heavy_hit');
		ACSGetCActor('ACS_Transformation_Werewolf').DestroyEffect('light_hit_back');
		ACSGetCActor('ACS_Transformation_Werewolf').DestroyEffect('heavy_hit_back');
		ACSGetCActor('ACS_Transformation_Werewolf').DestroyEffect('blood_spill');

		ACSGetCActor('ACS_Transformation_Werewolf').PlayEffectSingle('light_hit');
		ACSGetCActor('ACS_Transformation_Werewolf').PlayEffectSingle('heavy_hit');
		ACSGetCActor('ACS_Transformation_Werewolf').PlayEffectSingle('light_hit_back');
		ACSGetCActor('ACS_Transformation_Werewolf').PlayEffectSingle('heavy_hit_back');
		ACSGetCActor('ACS_Transformation_Werewolf').PlayEffectSingle('blood_spill');

		if (ACSGetCActor('ACS_Transformation_Werewolf').HasTag('ACS_Werewolf_Berserk_Mode'))
		{
			return;
		}

		GetACSWatcher().ACSWerewolfRemoveAttackTimers();

		hit_anim_names.PushBack('monster_werewolf_hit_light_front_down');
		hit_anim_names.PushBack('monster_werewolf_hit_heavy_front_down');
		hit_anim_names.PushBack('monster_werewolf_hit_heavy_front_right');
		hit_anim_names.PushBack('monster_werewolf_hit_light_front_left');
		hit_anim_names.PushBack('monster_werewolf_hit_light_front_right');
		hit_anim_names.PushBack('monster_werewolf_hit_heavy_front_left');

		GetACSWatcher().ACSTransformWerewolfPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.5f);
		break;

		default:
		break;
	}

}

////////////////////////////////////////////////////////

function ACS_Enemy_Attack_01(action: W3DamageAction)
{
   	var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var size  																														: int;
	var speed 																														: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker 
	&& playerVictim
	&& !(((W3Action_Attack)action).IsParried())
	&& !action.WasDodged() 
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	)
	{
		if(npcAttacker.HasTag('ACS_Forest_God')
		)
		{	
			if (playerVictim)
			{
				if (action.IsActionMelee())
				{
					if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
					{
						if (GetWitcherPlayer().IsGuarded()
						&& GetWitcherPlayer().IsInGuardedState())
						{
							if (!npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Guarded')
							&& !npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Guarded')
							)
							{
								npcAttacker.AddTag('ACS_Forest_God_1st_Hit_Melee_Guarded');
							}
							else if (npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Guarded'))
							{
								npcAttacker.RemoveTag('ACS_Forest_God_1st_Hit_Melee_Guarded');

								npcAttacker.AddTag('ACS_Forest_God_2nd_Hit_Melee_Guarded');
							}
							else if (npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Guarded'))
							{
								npcAttacker.RemoveTag('ACS_Forest_God_2nd_Hit_Melee_Guarded');

								if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
								{
									GetWitcherPlayer().FinishQuen(false);
								}

								movementAdjustor.CancelAll();

								GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449966) );

								//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

								params.effectType = EET_Knockdown;
								params.creator = npc;
								params.sourceName = "acs_HIT_REACTION";
								params.duration = 1;

								playerVictim.AddEffectCustom( params );							
							}
						}
						else
						{
							if (npcAttacker.GetStat(BCS_Essence) <= npcAttacker.GetStatMax(BCS_Essence)/2)
							{
								npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
							}	

							if (!npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded')
							&& !npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded')
							)
							{
								npcAttacker.AddTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');
							}
							else if (npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded'))
							{
								npcAttacker.RemoveTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');

								movementAdjustor.CancelAll();

								playerVictim.AddEffectDefault( EET_Stagger, npcAttacker, 'acs_HIT_REACTION' );				

								npcAttacker.AddTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded');
							}
							else if (npcAttacker.HasTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded'))
							{
								npcAttacker.RemoveTag('ACS_Forest_God_2nd_Hit_Melee_Unguarded');

								if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
								{
									GetWitcherPlayer().FinishQuen(false);
								}

								GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449967) );

								movementAdjustor.CancelAll();
								
								//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

								params.effectType = EET_Knockdown;
								params.creator = npc;
								params.sourceName = "acs_HIT_REACTION";
								params.duration = 1;

								playerVictim.AddEffectCustom( params );							
							}
						}
					}
				}
				else
				{
					if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
					{
						movementAdjustor.CancelAll();

						if( RandF() < 0.5 ) 
						{
							GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449968) );
						}
						else
						{
							GetWitcherPlayer().DisplayHudMessage( GetLocStringById(2118449969) );
						}

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

						params.effectType = EET_Knockdown;
						params.creator = npc;
						params.sourceName = "acs_HIT_REACTION";
						params.duration = 1;

						playerVictim.AddEffectCustom( params );							

						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 		
					}					
				}
			}
			else
			{
				npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.10 );
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Ice_Titan')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (GetWitcherPlayer().IsGuarded()
					&& GetWitcherPlayer().IsInGuardedState())
					{
						if (!npcAttacker.HasTag('ACS_Ice_Titan_1st_Hit_Melee_Guarded')
						&& !npcAttacker.HasTag('ACS_Ice_Titan_2nd_Hit_Melee_Guarded')
						)
						{
							npcAttacker.AddTag('ACS_Ice_Titan_1st_Hit_Melee_Guarded');
						}
						else if (npcAttacker.HasTag('ACS_Ice_Titan_1st_Hit_Melee_Guarded'))
						{
							npcAttacker.RemoveTag('ACS_Ice_Titan_1st_Hit_Melee_Guarded');

							npcAttacker.AddTag('ACS_Ice_Titan_2nd_Hit_Melee_Guarded');
						}
						else if (npcAttacker.HasTag('ACS_Ice_Titan_2nd_Hit_Melee_Guarded'))
						{
							npcAttacker.RemoveTag('ACS_Ice_Titan_2nd_Hit_Melee_Guarded');

							if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
							{
								GetWitcherPlayer().FinishQuen(false);
							}

							playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 			

							movementAdjustor.CancelAll();

							//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

							params.effectType = EET_Knockdown;
							params.creator = npc;
							params.sourceName = "acs_HIT_REACTION";
							params.duration = 1;

							playerVictim.AddEffectCustom( params );					
						}
					}
					else
					{
						if (!npcAttacker.HasTag('ACS_Ice_Titan_1st_Hit_Melee_Unguarded')
						&& !npcAttacker.HasTag('ACS_Ice_Titan_2nd_Hit_Melee_Unguarded')
						)
						{
							playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 					

							npcAttacker.AddTag('ACS_Ice_Titan_1st_Hit_Melee_Unguarded');
						}
						else if (npcAttacker.HasTag('ACS_Ice_Titan_1st_Hit_Melee_Unguarded'))
						{
							npcAttacker.RemoveTag('ACS_Ice_Titan_1st_Hit_Melee_Unguarded');

							playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 			

							movementAdjustor.CancelAll();

							playerVictim.AddEffectDefault( EET_Stagger, npcAttacker, 'acs_HIT_REACTION' ); 					

							npcAttacker.AddTag('ACS_Ice_Titan_2nd_Hit_Melee_Unguarded');
						}
						else if (npcAttacker.HasTag('ACS_Ice_Titan_2nd_Hit_Melee_Unguarded'))
						{
							npcAttacker.RemoveTag('ACS_Ice_Titan_2nd_Hit_Melee_Unguarded');

							if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
							{
								GetWitcherPlayer().FinishQuen(false);
							}

							playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 		

							movementAdjustor.CancelAll();

							//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

							params.effectType = EET_Knockdown;
							params.creator = npc;
							params.sourceName = "acs_HIT_REACTION";
							params.duration = 1;

							playerVictim.AddEffectCustom( params );							
						}
					}
				}
			}
			else
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					movementAdjustor.CancelAll();

					//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

					params.effectType = EET_Knockdown;
					params.creator = npc;
					params.sourceName = "acs_HIT_REACTION";
					params.duration = 1;

					playerVictim.AddEffectCustom( params );							

					playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'acs_HIT_REACTION' ); 		
				}					
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Fire_Bear')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (GetWitcherPlayer().IsGuarded()
					&& GetWitcherPlayer().IsInGuardedState())
					{
						if (!npcAttacker.HasTag('ACS_Fire_Bear_1st_Hit_Melee_Guarded')
						&& !npcAttacker.HasTag('ACS_Fire_Bear_2nd_Hit_Melee_Guarded')
						)
						{
							npcAttacker.AddTag('ACS_Fire_Bear_1st_Hit_Melee_Guarded');
						}
						else if (npcAttacker.HasTag('ACS_Fire_Bear_1st_Hit_Melee_Guarded'))
						{
							npcAttacker.RemoveTag('ACS_Fire_Bear_1st_Hit_Melee_Guarded');

							npcAttacker.AddTag('ACS_Fire_Bear_2nd_Hit_Melee_Guarded');
						}
						else if (npcAttacker.HasTag('ACS_Fire_Bear_2nd_Hit_Melee_Guarded'))
						{
							npcAttacker.RemoveTag('ACS_Fire_Bear_2nd_Hit_Melee_Guarded');

							if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
							{
								GetWitcherPlayer().FinishQuen(false);
							}

							playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'acs_HIT_REACTION' ); 			

							movementAdjustor.CancelAll();

							//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

							params.effectType = EET_Knockdown;
							params.creator = npcAttacker;
							params.sourceName = "acs_HIT_REACTION";
							params.duration = 1;

							playerVictim.AddEffectCustom( params );						
						}
					}
					else
					{
						if (!playerVictim)
						{
							npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.10 );
						}
						else
						{
							npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.0125 );
						}

						playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'acs_HIT_REACTION' ); 		

						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 

						params.effectType = EET_Knockdown;
						params.creator = npcAttacker;
						params.sourceName = "acs_HIT_REACTION";
						params.duration = 1;

						playerVictim.AddEffectCustom( params );	
					}
				}
			}
			else
			{
				if (npc)
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
				}

				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					movementAdjustor.CancelAll();

					//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							

					//playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'acs_HIT_REACTION' ); 		
				}					
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Knightmare_Eternum')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if( !playerVictim.IsImmuneToBuff( EET_Bleeding ) && !playerVictim.HasBuff( EET_Bleeding ) ) 
					{ 	
						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 							
					}
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Eredin')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if( !playerVictim.IsImmuneToBuff( EET_Bleeding ) && !playerVictim.HasBuff( EET_Bleeding ) ) 
					{ 	
						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 							
					}
				}
			}
			else
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Canaris')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					ACSGetCEntity('ACS_Canaris_Melee_Effect').PlayEffectSingle('explode');
					ACSGetCEntity('ACS_Canaris_Melee_Effect').StopEffect('explode');
				}
			}
			else
			{
				ACSGetCEntity('ACS_Canaris_Melee_Effect').PlayEffectSingle('explode');
				ACSGetCEntity('ACS_Canaris_Melee_Effect').StopEffect('explode');
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Night_Stalker')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (playerVictim)
					{
						if (!playerVictim.HasBuff(EET_Poison))
						{
							playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Night_Stalker' );
						}

						if (!npcAttacker.HasTag('ACS_Night_Stalker_1st_Hit_Melee_Guarded')
						&& !npcAttacker.HasTag('ACS_Night_Stalker_2nd_Hit_Melee_Guarded')
						)
						{
							npcAttacker.AddTag('ACS_Night_Stalker_1st_Hit_Melee_Guarded');
						}
						else if (npcAttacker.HasTag('ACS_Night_Stalker_1st_Hit_Melee_Guarded'))
						{
							npcAttacker.RemoveTag('ACS_Night_Stalker_1st_Hit_Melee_Guarded');

							npcAttacker.AddTag('ACS_Night_Stalker_2nd_Hit_Melee_Guarded');
						}
						else if (npcAttacker.HasTag('ACS_Night_Stalker_2nd_Hit_Melee_Guarded'))
						{
							npcAttacker.RemoveTag('ACS_Night_Stalker_2nd_Hit_Melee_Guarded');

							if (!playerVictim.HasBuff(EET_HeavyKnockdown))
							{
								playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'ACS_Night_Stalker' );
							}
						}
					}

					if (npcAttacker.UsesVitality()) 
					{ 
						npcAttacker.GainStat( BCS_Vitality, (npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat(BCS_Vitality)) * 0.0125 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec((npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat(BCS_Vitality)) * 0.0125, 0))
							, npcAttacker, "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
					else if (npcAttacker.UsesEssence()) 
					{ 
						npcAttacker.GainStat( BCS_Essence, (npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat(BCS_Essence))  * 0.0125 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec((npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat(BCS_Essence))  * 0.0125, 0))
							, npcAttacker, "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Xeno_Tyrant')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (playerVictim)
					{
						if (!playerVictim.HasBuff(EET_Poison))
						{
							playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Xeno_Tyrant' );
						}
						
						if (!playerVictim.HasBuff(EET_Bleeding))
						{
							playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Xeno_Tyrant' );
						}

						if (!npcAttacker.HasTag('ACS_Xeno_Tyrant_1st_Hit_Melee_Guarded')
						&& !npcAttacker.HasTag('ACS_Xeno_Tyrant_2nd_Hit_Melee_Guarded')
						)
						{
							npcAttacker.AddTag('ACS_Xeno_Tyrant_1st_Hit_Melee_Guarded');
						}
						else if (npcAttacker.HasTag('ACS_Xeno_Tyrant_1st_Hit_Melee_Guarded'))
						{
							npcAttacker.RemoveTag('ACS_Xeno_Tyrant_1st_Hit_Melee_Guarded');

							npcAttacker.AddTag('ACS_Xeno_Tyrant_2nd_Hit_Melee_Guarded');
						}
						else if (npcAttacker.HasTag('ACS_Xeno_Tyrant_2nd_Hit_Melee_Guarded'))
						{
							npcAttacker.RemoveTag('ACS_Xeno_Tyrant_2nd_Hit_Melee_Guarded');

							if (!playerVictim.HasBuff(EET_HeavyKnockdown))
							{
								playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'ACS_Xeno_Tyrant' );
							}
						}

						if (ACSGetCActor('ACS_Xeno_Tyrant').HasAbility('mon_kikimore_small'))
						{
							ACSGetCActor('ACS_Xeno_Tyrant').RemoveAbility('mon_kikimore_small');
						}
					}

					if (npcAttacker.UsesVitality()) 
					{ 
						npcAttacker.GainStat( BCS_Vitality, (npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat(BCS_Vitality)) * 0.0125 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec((npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat(BCS_Vitality)) * 0.0125, 0))
							, npcAttacker, "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
					else if (npcAttacker.UsesEssence()) 
					{ 
						npcAttacker.GainStat( BCS_Essence, (npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat(BCS_Essence))  * 0.0125 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec((npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat(BCS_Essence))  * 0.0125, 0))
							, npcAttacker, "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Xeno_Soldiers')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (playerVictim)
					{
						if (!playerVictim.HasBuff(EET_Poison))
						{
							playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Xeno_Soldiers' );
						}
						
						if (!playerVictim.HasBuff(EET_Bleeding))
						{
							playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Xeno_Soldiers' );
						}
					}

					if (ACSGetCActor('ACS_Xeno_Tyrant').UsesVitality()) 
					{ 
						ACSGetCActor('ACS_Xeno_Tyrant').GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.025 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec( npcAttacker.GetStatMax(BCS_Vitality) * 0.025, 0))
							, ACSGetCActor('ACS_Xeno_Tyrant'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
					else if (ACSGetCActor('ACS_Xeno_Tyrant').UsesEssence()) 
					{ 
						ACSGetCActor('ACS_Xeno_Tyrant').GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.025 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec(npcAttacker.GetStatMax(BCS_Essence) * 0.025, 0))
							, ACSGetCActor('ACS_Xeno_Tyrant'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Xeno_Workers')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (playerVictim)
					{
						if (!playerVictim.HasBuff(EET_Poison))
						{
							playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Xeno_Workers' );
						}
					}

					if (ACSGetCActor('ACS_Xeno_Tyrant').UsesVitality()) 
					{ 
						ACSGetCActor('ACS_Xeno_Tyrant').GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.05 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec(npcAttacker.GetStatMax(BCS_Vitality) * 0.05, 0))
							, ACSGetCActor('ACS_Xeno_Tyrant'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
					else if (ACSGetCActor('ACS_Xeno_Tyrant').UsesEssence()) 
					{ 
						ACSGetCActor('ACS_Xeno_Tyrant').GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
						
						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec(npcAttacker.GetStatMax(BCS_Essence) * 0.05, 0))
							, ACSGetCActor('ACS_Xeno_Tyrant'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Xeno_Armored_Workers')
		)
		{	
			if (RandF() < 0.5)
			{
				if (RandF() < 0.5)
				{
					if (!npc.HasAbility('Venom'))
					{
						npc.AddAbility('Venom');
					}

					if (npc.HasAbility('Charge'))
					{
						npc.RemoveAbility('Charge');
					}

					if (npc.HasAbility('Block'))
					{
						npc.RemoveAbility('Block');
					}

					if (npc.HasAbility('Spikes'))
					{
						npc.RemoveAbility('Spikes');
					}
				}
				else
				{
					if (!npc.HasAbility('Charge'))
					{
						npc.AddAbility('Charge');
					}

					if (npc.HasAbility('Venom'))
					{
						npc.RemoveAbility('Venom');
					}

					if (npc.HasAbility('Block'))
					{
						npc.RemoveAbility('Block');
					}

					if (npc.HasAbility('Spikes'))
					{
						npc.RemoveAbility('Spikes');
					}


				}
			}
			else
			{
				if (RandF() < 0.5)
				{
					if (!npc.HasAbility('Block'))
					{
						npc.AddAbility('Block');
					}

					if (npc.HasAbility('Charge'))
					{
						npc.RemoveAbility('Charge');
					}

					if (npc.HasAbility('Venom'))
					{
						npc.RemoveAbility('Venom');
					}

					if (npc.HasAbility('Spikes'))
					{
						npc.RemoveAbility('Spikes');
					}
				}
				else
				{
					if (!npc.HasAbility('Spikes'))
					{
						npc.AddAbility('Spikes');
					}

					if (npc.HasAbility('Charge'))
					{
						npc.RemoveAbility('Charge');
					}

					if (npc.HasAbility('Block'))
					{
						npc.RemoveAbility('Block');
					}

					if (npc.HasAbility('Venom'))
					{
						npc.RemoveAbility('Venom');
					}
				}
			}

			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (playerVictim)
					{
						if (!playerVictim.HasBuff(EET_Bleeding))
						{
							playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Xeno_Armored_Workers' );
						}
					}

					if (ACSGetCActor('ACS_Xeno_Tyrant').UsesVitality()) 
					{ 
						ACSGetCActor('ACS_Xeno_Tyrant').GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.05 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec(npcAttacker.GetStatMax(BCS_Vitality) * 0.05, 0))
							, ACSGetCActor('ACS_Xeno_Tyrant'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
					else if (ACSGetCActor('ACS_Xeno_Tyrant').UsesEssence()) 
					{ 
						ACSGetCActor('ACS_Xeno_Tyrant').GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec(npcAttacker.GetStatMax(BCS_Essence) * 0.05, 0))
							, ACSGetCActor('ACS_Xeno_Tyrant'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Vampire_Monster')
		)
		{	
			if (action.IsActionMelee())
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (npcAttacker.UsesVitality()) 
					{ 
						ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GainStat( BCS_Vitality, (ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GetStatMax(BCS_Vitality) - ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GetStat(BCS_Vitality)) * 0.025 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec((ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GetStatMax(BCS_Vitality) - ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GetStat(BCS_Vitality)) * 0.025, 0))
							, ACSGetCActor('ACS_Vampire_Monster'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
					else if (npcAttacker.UsesEssence()) 
					{ 
						ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GainStat( BCS_Essence, (ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GetStatMax(BCS_Essence) - ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GetStat(BCS_Essence))  * 0.025 );

						if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
						{
							ACS_Oneliner(
							(new ACS_Oneliner_TagBuilder in theGame)
							.tag("font")
							.attr("size", "22")
							.attr("color", "#00FF00")
							.text(FloatToStringPrec((ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GetStatMax(BCS_Essence) - ACSGetCActor('ACS_Vampire_Monster_Boss_Bar').GetStat(BCS_Essence))  * 0.025, 0))
							, ACSGetCActor('ACS_Vampire_Monster'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
						}
					} 
				}
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Big_Lizard')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if ( playerVictim)
				{
					if (!playerVictim.HasBuff(EET_Burning))
					{
						playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Big_Lizard' );
					}
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Shadow_Wolf')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if ( playerVictim)
				{
					if (!playerVictim.HasBuff(EET_Bleeding))
					{
						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Shadow_Wolf' );
					}
				}
			}

			return;
		}
	}
}

function ACS_Enemy_Attack_02(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var size  																														: int;
	var speed 																														: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker 
	&& playerVictim
	&& !(((W3Action_Attack)action).IsParried())
	&& !action.WasDodged() 
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	)
	{
		if (npcAttacker.HasTag('ACS_Lynx_Witcher')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_Poison))
				{
					playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Lynx_Witcher' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Fluffy')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_Burning))
				{
					playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Fluffy' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Melusine')
		)
		{	
			if (!playerVictim.HasBuff(EET_Burning))
			{
				playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Melusine' );
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Melusine_Cloud')
		)
		{	
			if ( playerVictim)
			{
				//action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

				if (!GetWitcherPlayer().IsGuarded()
				&& !GetWitcherPlayer().IsInGuardedState())
				{
					if (!npcAttacker.HasTag('ACS_Melusine_1st_Hit')
					&& !npcAttacker.HasTag('ACS_Melusine_2nd_Hit')
					)
					{
						npcAttacker.AddTag('ACS_Melusine_1st_Hit');
					}
					else if (npcAttacker.HasTag('ACS_Melusine_1st_Hit'))
					{
						npcAttacker.RemoveTag('ACS_Melusine_1st_Hit');

						npcAttacker.AddTag('ACS_Melusine_2nd_Hit');
					}
					else if (npcAttacker.HasTag('ACS_Melusine_2nd_Hit'))
					{
						npcAttacker.RemoveTag('ACS_Melusine_2nd_Hit');

						if ( playerVictim && GetWitcherPlayer().IsAnyQuenActive())
						{
							GetWitcherPlayer().FinishQuen(false);
						}

						playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'acs_HIT_REACTION' ); 			

					}
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Pirate_Zombie')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_Burning))
				{
					playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Pirate_Zombie' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Svalblod')
		)
		{	
			if (!npcAttacker.HasTag('ACS_Svalblod_1st_Hit_Melee_Guarded')
			&& !npcAttacker.HasTag('ACS_Svalblod_2nd_Hit_Melee_Guarded')
			)
			{
				npcAttacker.AddTag('ACS_Svalblod_1st_Hit_Melee_Guarded');
			}
			else if (npcAttacker.HasTag('ACS_Svalblod_1st_Hit_Melee_Guarded'))
			{
				npcAttacker.RemoveTag('ACS_Svalblod_1st_Hit_Melee_Guarded');

				npcAttacker.AddTag('ACS_Svalblod_2nd_Hit_Melee_Guarded');
			}
			else if (npcAttacker.HasTag('ACS_Svalblod_2nd_Hit_Melee_Guarded'))
			{
				npcAttacker.RemoveTag('ACS_Svalblod_2nd_Hit_Melee_Guarded');

				if (!playerVictim.HasBuff(EET_HeavyKnockdown))
				{
					playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'ACS_Svalblod' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Svalblod_Bear')
		)
		{	
			if (!npcAttacker.HasTag('ACS_Svalblod_Bear_1st_Hit_Melee_Guarded')
			&& !npcAttacker.HasTag('ACS_Svalblod_Bear_2nd_Hit_Melee_Guarded')
			)
			{
				npcAttacker.AddTag('ACS_Svalblod_Bear_1st_Hit_Melee_Guarded');
			}
			else if (npcAttacker.HasTag('ACS_Svalblod_Bear_1st_Hit_Melee_Guarded'))
			{
				npcAttacker.RemoveTag('ACS_Svalblod_Bear_1st_Hit_Melee_Guarded');

				npcAttacker.AddTag('ACS_Svalblod_Bear_2nd_Hit_Melee_Guarded');
			}
			else if (npcAttacker.HasTag('ACS_Svalblod_Bear_2nd_Hit_Melee_Guarded'))
			{
				npcAttacker.RemoveTag('ACS_Svalblod_Bear_2nd_Hit_Melee_Guarded');

				if (!playerVictim.HasBuff(EET_HeavyKnockdown))
				{
					playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'ACS_Svalblod_Bear' );
				}
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Berserkers_Bear')
		)
		{	
			if( !playerVictim.IsImmuneToBuff( EET_Bleeding ) && !playerVictim.HasBuff( EET_Bleeding ) ) 
			{ 	
				playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 							
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Incubus')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Draug')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				theSound.SoundEvent("monster_cloud_giant_cmb_weapon_hit_add");

				if (!playerVictim.HasBuff(EET_Burning))
				{
					playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Draug' );
				}
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Fire_Gryphon')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_Burning))
				{
					playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Fire_Gryphon' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_MegaWraith')
		)
		{	
			if (!npcAttacker.HasAbility('Specter'))
			{
				npcAttacker.AddAbility('Specter');

				npcAttacker.AddAbility('FlashStep');
			}
			else if (npcAttacker.HasAbility('Specter'))
			{
				npcAttacker.RemoveAbility('Specter');

				npcAttacker.RemoveAbility('FlashStep');
			}

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').StopEffect('light_trail_extended_fx');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').StopEffect('wraith_trail');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').StopEffect('special_trail_fx');

			if (!ACSGetCEntity('ACS_MegaWraith_L_Weapon').IsEffectActive('runeword_igni_green', false))
			{
				ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('runeword_igni_green');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_L_Weapon').IsEffectActive('runeword1_fire_trail_green', false))
			{
				ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_L_Weapon').IsEffectActive('runeword_quen', false))
			{
				ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('runeword_quen');
			}

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('light_trail_extended_fx');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('wraith_trail');

			ACSGetCEntity('ACS_MegaWraith_L_Weapon').PlayEffectSingle('special_trail_fx');



			ACSGetCEntity('ACS_MegaWraith_R_Weapon').StopEffect('light_trail_extended_fx');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').StopEffect('wraith_trail');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').StopEffect('special_trail_fx');

			if (!ACSGetCEntity('ACS_MegaWraith_R_Weapon').IsEffectActive('runeword_igni_green', false))
			{
				ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('runeword_igni_green');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_R_Weapon').IsEffectActive('runeword1_fire_trail_green', false))
			{
				ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('runeword1_fire_trail_green');
			}

			if (!ACSGetCEntity('ACS_MegaWraith_R_Weapon').IsEffectActive('runeword_quen', false))
			{
				ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('runeword_quen');
			}

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('light_trail_extended_fx');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('wraith_trail');

			ACSGetCEntity('ACS_MegaWraith_R_Weapon').PlayEffectSingle('special_trail_fx');

			if ( !action.WasDodged() && !(((W3Action_Attack)action).IsParried()) )
			{
				action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.06125;
				action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.06125;
			}

			GetACSWatcher().ACS_CreateWraithDummy();

			return;
		}
	}
}

function ACS_Enemy_Attack_03(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var size  																														: int;
	var miniHymSize, miniHymSpeed 																									: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker 
	&& playerVictim
	&& !(((W3Action_Attack)action).IsParried())
	&& !action.WasDodged() 
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	)
	{
		if ( npcAttacker.HasTag('ACS_MegaWraith_Minion')
		)
		{	
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;

			return;
		}

		if ( npcAttacker.HasTag('ACS_Big_Hym')
		)
		{	
			//npcAttacker.StopEffect('hand_fx_red');
			//npcAttacker.PlayEffectSingle('hand_fx_red');

			npcAttacker.StopEffect('shadowdash_body_blood');

			npcAttacker.PlayEffectSingle('shadowdash_body_blood');

			npcAttacker.StopEffect('shadowdash');

			npcAttacker.PlayEffectSingle('shadowdash');

			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_hit_claws");

				if (!playerVictim.HasBuff(EET_Bleeding))
				{
					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Big_Hym' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Mini_Hym')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_Bleeding))
				{
					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Mini_Hym' );
				}

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Guardian_Blood_Hym_Small') || npcAttacker.HasTag('ACS_Guardian_Blood_Hym_Large'))
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Knocker')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

				//thePlayer.AddEffectDefault( EET_Knockdown, thePlayer, 'ACS_Knocker' );
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Bumbakvetch')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

				thePlayer.AddEffectDefault( EET_Knockdown, thePlayer, 'ACS_Bumbakvetch' );

				thePlayer.AddEffectDefault( EET_Bleeding, thePlayer, 'ACS_Bumbakvetch' );

				thePlayer.AddEffectDefault( EET_Blindness, thePlayer, 'ACS_Bumbakvetch' );

				action.processedDmg.vitalityDamage += GetWitcherPlayer().GetStat(BCS_Vitality) * 0.1;
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Chironex')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Botchling')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if( !playerVictim.IsImmuneToBuff( EET_Bleeding ) && !playerVictim.HasBuff( EET_Bleeding ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Draugir')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if( !playerVictim.IsImmuneToBuff( EET_Bleeding ) && !playerVictim.HasBuff( EET_Bleeding ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Dullahan')
		)
		{	
			params.effectType = EET_Burning;
			params.creator = npcAttacker;
			params.sourceName = "ACS_Dullahan_Burn";
			params.duration = 5;

			thePlayer.AddEffectCustom( params );

			if (action.IsActionMelee())
			{
				//action.processedDmg.vitalityDamage += GetWitcherPlayer().GetStat(BCS_Vitality) * 0.75f;
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_MonsterHunt_Mourntart')
		)
		{	
			if ((((W3Action_Attack)action).IsCountered()))
			{
				action.SetAllProcessedDamageAs(0);
				action.SetWasDodged();
				action.ClearEffects();

				if (!npcAttacker.HasTag('ACS_Mourntart_Below_Half_Health_With_Tongue'))
				{
					if (!npcAttacker.HasTag('ACS_Mourntart_1st_Hit_Counter')
					&& !npcAttacker.HasTag('ACS_Mourntart_2nd_Hit_Counter')
					)
					{
						GetACSStorage().acs_deleteOnelinerByTag("ACS_Mourntart_Counter_Oneliner");

						ACS_Oneliner(
						(new ACS_Oneliner_TagBuilder in theGame)
						.tag("font")
						.attr("size", "26")
						.attr("color", "#f00000")
						.text(GetLocStringById(2118449937))
						, npcAttacker, "ACS_Mourntart_Counter_Oneliner", Vector(0,0,1.5), 5);

						GetACSStorage().acs_setAlphaForOnelinerByTag("ACS_Mourntart_Counter_Oneliner", 100);

						GetACSStorage().acs_setScaleForOnelinerByTag("ACS_Mourntart_Counter_Oneliner", 100, 100, 100);

						npcAttacker.AddTag('ACS_Mourntart_1st_Hit_Counter');
					}
					else if (npcAttacker.HasTag('ACS_Mourntart_1st_Hit_Counter'))
					{
						GetACSStorage().acs_deleteOnelinerByTag("ACS_Mourntart_Counter_Oneliner");

						ACS_Oneliner(
						(new ACS_Oneliner_TagBuilder in theGame)
						.tag("font")
						.attr("size", "26")
						.attr("color", "#f00000")
						.text(GetLocStringById(2118449938))
						, npcAttacker, "ACS_Mourntart_Counter_Oneliner", Vector(0,0,1.5), 5);

						GetACSStorage().acs_setAlphaForOnelinerByTag("ACS_Mourntart_Counter_Oneliner", 100);

						GetACSStorage().acs_setScaleForOnelinerByTag("ACS_Mourntart_Counter_Oneliner", 100, 100, 100);

						npcAttacker.RemoveTag('ACS_Mourntart_1st_Hit_Counter');

						npcAttacker.AddTag('ACS_Mourntart_2nd_Hit_Counter');
					}
					else if (npcAttacker.HasTag('ACS_Mourntart_2nd_Hit_Counter'))
					{
						GetACSStorage().acs_deleteOnelinerByTag("ACS_Mourntart_Counter_Oneliner");

						ACS_Oneliner(
						(new ACS_Oneliner_TagBuilder in theGame)
						.tag("font")
						.attr("size", "26")
						.attr("color", "#f00000")
						.text(GetLocStringById(2118449939))
						, npcAttacker, "ACS_Mourntart_Counter_Oneliner", Vector(0,0,1.5), 5);

						GetACSStorage().acs_setAlphaForOnelinerByTag("ACS_Mourntart_Counter_Oneliner", 100);

						GetACSStorage().acs_setScaleForOnelinerByTag("ACS_Mourntart_Counter_Oneliner", 100, 100, 100);

						ACS_MonsterBehSwitch('Mourntart_Beh_Switch_Cut_Off_Tongue_Engage');
					}
				}
			}
			else
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

					if (npcAttacker.HasTag('ACS_Mourntart_Tongue_Disabled'))
					{
						params.effectType = EET_Bleeding;
						params.creator = npcAttacker;
						params.sourceName = "ACS_Mourntart_Effect";
						params.duration = 5;

						thePlayer.AddEffectCustom( params );	
					}
					else
					{
						if (npcAttacker.HasTag('ACS_Mourntart_Below_Half_Health_With_Tongue'))
						{
							params.effectType = EET_Poison;
							params.creator = npcAttacker;
							params.sourceName = "ACS_Mourntart_Effect";
							params.duration = 5;

							thePlayer.AddEffectCustom( params );	

							params.effectType = EET_Bleeding;
							params.creator = npcAttacker;
							params.sourceName = "ACS_Mourntart_Effect";
							params.duration = 5;

							thePlayer.AddEffectCustom( params );

							//thePlayer.GainStat(BCS_Toxicity, thePlayer.GetStatMax(BCS_Toxicity) * 0.125 );
						}
						else
						{
							params.effectType = EET_Poison;
							params.creator = npcAttacker;
							params.sourceName = "ACS_Mourntart_Effect";
							params.duration = 3;

							thePlayer.AddEffectCustom( params );	

							params.effectType = EET_Bleeding;
							params.creator = npcAttacker;
							params.sourceName = "ACS_Mourntart_Effect";
							params.duration = 3;

							thePlayer.AddEffectCustom( params );	

							params.effectType = EET_Knockdown;
							params.creator = npcAttacker;
							params.sourceName = "ACS_Mourntart_Effect";
							params.duration = 1;

							thePlayer.AddEffectCustom( params );	

							//thePlayer.GainStat(BCS_Toxicity, thePlayer.GetStatMax(BCS_Toxicity) * 0.1 );
						}
					}
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Viy_Of_Maribor')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

				action.processedDmg.vitalityDamage += GetWitcherPlayer().GetStat(BCS_Vitality) * 0.1;

				thePlayer.AddEffectDefault( EET_Bleeding, thePlayer, 'ACS_Bumbakvetch' );

				thePlayer.AddEffectDefault( EET_Blindness, thePlayer, 'ACS_Bumbakvetch' );

				thePlayer.AddEffectDefault( EET_Poison, ACSGetCActor('ACS_Viy_Of_Maribor'), 'ACS_Viy_Of_Maribor' );

				thePlayer.AddEffectDefault( EET_HeavyKnockdown, ACSGetCActor('ACS_Viy_Of_Maribor'), 'ACS_Viy_Of_Maribor' );
			}

			return;
		}
	}
}

function ACS_Enemy_Attack_04(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var item																														: SItemUniqueId;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var size  																														: int;
	var speed 																														: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker 
	&& playerVictim
	&& !(((W3Action_Attack)action).IsParried())
	&& !action.WasDodged() 
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	)
	{
		if ( npcAttacker.HasTag('ACS_Devourer')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_Poison))
				{
					params.effectType = EET_Poison;
					params.creator = npcAttacker;
					params.sourceName = "ACS_Devourer_Poison";
					params.duration = 3;

					playerVictim.AddEffectCustom( params ); 	
				}

				if (!playerVictim.HasBuff(EET_Bleeding))
				{
					params.effectType = EET_Bleeding;
					params.creator = npcAttacker;
					params.sourceName = "ACS_Devourer_Bleed";
					params.duration = 3;

					playerVictim.AddEffectCustom( params ); 	
				}
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Doppler')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5f;
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Plumard')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (npcAttacker.HasTag('ACS_Plumard_Elder'))
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
				}
				else
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25f;
				}
				

				if (!playerVictim.HasBuff(EET_Bleeding))
				{
					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Plumard' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Vigilosaur') || npcAttacker.HasTag('ACS_Vigilosaur_Alpha')
		)
		{	
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.625f;

			return;
		}

		if ( npcAttacker.HasTag('ACS_Ungoliant_Spawn')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95f;

				if (!playerVictim.HasBuff(EET_Burning))
				{
					params.effectType = EET_Burning;
					params.creator = npcAttacker;
					params.sourceName = "ACS_Ungoliant_Spawn_Burn";
					params.duration = 2;

					playerVictim.AddEffectCustom( params ); 	
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Demonic_Construct')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_SlowdownFrost))
				{
					playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'ACS_Demonic_Construct' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Shades_Rogue')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Dark_Knight_Calidus')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_Burning))
				{
					playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Dark_Knight_Calidus' );
				}
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Carduin')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (!playerVictim.HasBuff(EET_Burning))
				{
					playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Carduin' );
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Fire_Gargoyle')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if ( playerVictim)
				{
					if (!playerVictim.HasBuff(EET_Burning))
					{
						playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Fire_Gargoyle' );
					}
				}
			}

			return;
		}

		if (npcAttacker.HasTag('ACS_Vendigo')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if ( playerVictim)
				{
					theSound.SoundEvent("animals_deer_sniff");
					thePlayer.SoundEvent("animals_deer_sniff");

					theSound.SoundEvent("animals_deer_breath");
					thePlayer.SoundEvent("animals_deer_breath");

					theSound.SoundEvent("animals_deer_sniff");
					thePlayer.SoundEvent("animals_deer_sniff");

					theSound.SoundEvent("animals_deer_breath");
					thePlayer.SoundEvent("animals_deer_breath");

					theSound.SoundEvent("animals_deer_sniff");
					thePlayer.SoundEvent("animals_deer_sniff");

					theSound.SoundEvent("animals_deer_breath");
					thePlayer.SoundEvent("animals_deer_breath");

					theSound.SoundEvent("animals_deer_sniff");
					thePlayer.SoundEvent("animals_deer_sniff");

					theSound.SoundEvent("animals_deer_breath");
					thePlayer.SoundEvent("animals_deer_breath");

					if (!playerVictim.HasBuff(EET_Poison))
					{
						playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Vendigo' );
					}

					if (!playerVictim.HasBuff(EET_Bleeding))
					{
						playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Vendigo' );
					}
				}
			}

			return;
		}

		if ( npcAttacker.HasTag('ACS_Arachne')
		|| npcAttacker.HasTag('ACS_ArachneTorso')
		)
		{	
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;

				if (!playerVictim.HasBuff(EET_Poison))
				{
					params.effectType = EET_Poison;
					params.creator = npcAttacker;
					params.sourceName = "ACS_ArachnePoison";
					params.duration = 5;

					playerVictim.AddEffectCustom( params ); 	
				}
			}

			return;
		}
	}
}

/*
function ACS_Infected_Prime_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;


    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Infected_Prime')
	&& !npc.HasTag('ACS_Infected_Spawn')
	&& !npc.HasTag('ACS_Infected_Prime')
	)
	{	
		if (
		(npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
		||
		(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01)
		|| npc.IsHuman()
		)
		{
			if ( !npc.HasTag('ACS_Spawn_Infected'))
			{
				npc.Kill('ACS_Infected', true);

				ACS_Spawn_Infected(npc, npc.GetWorldPosition());

				npc.AddTag('ACS_Spawn_Infected');
			}
		}
	}
}

function ACS_Infected_Spawn_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;


    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Infected_Spawn')
	&& !npc.HasTag('ACS_Infected_Spawn')
	&& !npc.HasTag('ACS_Infected_Prime')
	)
	{	
		if (
		(npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
		||
		(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01)
		|| npc.IsHuman()
		)
		{
			if ( !npc.HasTag('ACS_Spawn_Infected'))
			{
				npc.Kill('ACS_Infected', true);

				ACS_Spawn_Infected(npc, npc.GetWorldPosition());

				npc.AddTag('ACS_Spawn_Infected');
			}
		}
	}
}
*/

function ACS_Vanilla_Vampires_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& 
	(npcAttacker.GetSfxTag() == 'sfx_katakan'
	|| npcAttacker.HasAbility('mon_ekimma')
	|| npcAttacker.HasAbility('mon_garkain')
	|| npcAttacker.HasAbility('mon_bruxa')
	|| npcAttacker.HasAbility('mon_fleder')
	|| npcAttacker.HasAbility('q704_mon_protofleder')
	|| npcAttacker.HasAbility('mon_alp')
	|| npcAttacker.HasTag('dettlaff_vampire'))
	&& npc
	&& ACS_Settings_Main_Bool('acs_encounters_enhanced_abilities_settings','acs_vampire_healing_enabled', true)
	)
	{	
		if (npcAttacker.HasTag('ACS_Bauk')
		|| npcAttacker.HasTag('ACS_Ungoliant')
		)
		{
			return;
		}
		
		if (!action.WasDodged() && !npc.IsCurrentlyDodging())
		{
			if (npc.HasBuff(EET_BlackBlood))
			{
				if (npcAttacker.UsesEssence())
				{
					npcAttacker.GainStat( BCS_Essence, ( npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat( BCS_Essence ) ) * 0.0125 );

					if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
					{
						ACS_Oneliner(
						(new ACS_Oneliner_TagBuilder in theGame)
						.tag("font")
						.attr("size", "22")
						.attr("color", "#00FF00")
						.text(FloatToStringPrec(( npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat( BCS_Essence ) ) * 0.0125, 0))
						, ACSGetCActor('ACS_Vampire_Monster'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
					}
				}
				else if (npcAttacker.UsesVitality())
				{
					npcAttacker.GainStat( BCS_Vitality, ( npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat( BCS_Vitality ) ) * 0.0125 );

					if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
					{
						ACS_Oneliner(
						(new ACS_Oneliner_TagBuilder in theGame)
						.tag("font")
						.attr("size", "22")
						.attr("color", "#00FF00")
						.text(FloatToStringPrec(( npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat( BCS_Vitality ) ) * 0.0125, 0))
						, ACSGetCActor('ACS_Vampire_Monster'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
					}
				}
			}
			else
			{
				if (npcAttacker.UsesEssence())
				{
					npcAttacker.GainStat( BCS_Essence, ( npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat( BCS_Essence ) ) * 0.025 );

					if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
					{
						ACS_Oneliner(
						(new ACS_Oneliner_TagBuilder in theGame)
						.tag("font")
						.attr("size", "22")
						.attr("color", "#00FF00")
						.text(FloatToStringPrec(( npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat( BCS_Essence ) ) * 0.025, 0))
						, ACSGetCActor('ACS_Vampire_Monster'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
					}
				}
				else if (npcAttacker.UsesVitality())
				{
					npcAttacker.GainStat( BCS_Vitality, ( npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat( BCS_Vitality ) ) * 0.025 );

					if ( ((CR4ScriptedHud)theGame.GetHud()).AreEnabledEnemyHitEffects() )
					{
						ACS_Oneliner(
						(new ACS_Oneliner_TagBuilder in theGame)
						.tag("font")
						.attr("size", "22")
						.attr("color", "#00FF00")
						.text(FloatToStringPrec(( npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat( BCS_Vitality ) ) * 0.025, 0))
						, ACSGetCActor('ACS_Vampire_Monster'), "ACS_Damage_Value", Vector(RandRangeF(0.625, -0.625),RandRangeF(0.625, -0.625),RandRangeF(1.75, 1.25)), 3).run_indicator('popup');
					}
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_SummonedCreatures_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var dmg													: W3DamageAction;
	var damageMax, damageMin								: float;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if ( npcAttacker
	&& (npcAttacker.HasTag('ACS_Companion_Wolf'))
	&& npc
	)
	{	
		if (!action.WasDodged() && !npc.IsCurrentlyDodging())
		{
			if ( npc )
			{
				npc.SignalGameplayEventParamObject( 'ForceTarget', npcAttacker );

				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				dmg = new W3DamageAction in theGame.damageMgr;
					
				dmg.Initialize(GetWitcherPlayer(), npc, NULL, npcAttacker.GetName(), EHRT_None, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);

				dmg.SetCanPlayHitParticle(false);

				dmg.SetSuppressHitSounds(true);

				dmg.SuppressHitSounds();

				if (npc.HasTag('ACS_Final_Fear_Stack') || npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.01)
				{
					damageMax = npc.GetMaxHealth(); 

					if (((CNewNPC)npc).GetNPCType() == ENGT_Guard)
					{
						npc.DestroyAfter(10);
					}
				}
				else
				{
					if (npc.GetCurrentHealth() >= npc.GetMaxHealth() * 0.5)
					{
						damageMax = npc.GetCurrentHealth() * 0.125; 
					}
					else if (npc.GetCurrentHealth() < npc.GetMaxHealth() * 0.5)
					{
						damageMax = (npc.GetMaxHealth() - npc.GetCurrentHealth()) * 0.0125;
					}
				}

				dmg.SetForceExplosionDismemberment();

				damageMax += damageMax * ACS_SignIntensityPercentage('total') * 0.5;

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, 50 + damageMax );

				if(RandF() < 0.5)
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}
					
				dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;
			}
		}
	}

    if ( npcAttacker
	&& 
	(npcAttacker.HasTag('ACS_Revenant') 
	|| npcAttacker.HasTag('ACS_Summoned_Skeleton')
	|| npcAttacker.HasTag('ACS_Summoned_Wolf')
	|| npcAttacker.HasTag('ACS_Summoned_Centipede')
	)
	&& npc
	)
	{	
		if (!action.WasDodged() && !npc.IsCurrentlyDodging())
		{
			if ( npc )
			{
				npc.SignalGameplayEventParamObject( 'ForceTarget', npcAttacker );

				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				dmg = new W3DamageAction in theGame.damageMgr;
					
				dmg.Initialize(GetWitcherPlayer(), npc, NULL, npcAttacker.GetName(), EHRT_Light, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);

				if (npc.HasTag('ACS_Final_Fear_Stack') || npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.01)
				{
					damageMax = npc.GetMaxHealth(); 

					if (((CNewNPC)npc).GetNPCType() == ENGT_Guard)
					{
						npc.DestroyAfter(10);
					}
				}
				else
				{
					if (npc.GetCurrentHealth() >= npc.GetMaxHealth() * 0.5)
					{
						damageMax = npc.GetCurrentHealth() * RandRangeF(0.125, 0.06125);
					}
					else
					{
						damageMax = (npc.GetMaxHealth() - npc.GetCurrentHealth()) * RandRangeF(0.06125, 0.030625);
					}
				}

				dmg.SetForceExplosionDismemberment();

				damageMax += damageMax * ACS_SignIntensityPercentage('total') * 0.5;

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );
					
				dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;
			}
		}
	}

	if ( npcAttacker
	&& (npcAttacker.HasTag('ACS_Summoned_Construct_1') || npcAttacker.HasTag('ACS_Summoned_Construct_2'))
	&& npc
	)
	{	
		if (!action.WasDodged() && !npc.IsCurrentlyDodging())
		{
			if ( npc )
			{
				npc.SignalGameplayEventParamObject( 'ForceTarget', npcAttacker );

				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				dmg = new W3DamageAction in theGame.damageMgr;
					
				dmg.Initialize(GetWitcherPlayer(), npc, NULL, npcAttacker.GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);

				if (npc.HasTag('ACS_Final_Fear_Stack') || npc.GetCurrentHealth() <= npc.GetMaxHealth() * 0.01)
				{
					damageMax = npc.GetMaxHealth(); 

					if (((CNewNPC)npc).GetNPCType() == ENGT_Guard)
					{
						npc.DestroyAfter(10);
					}
				}
				else
				{
					if (npc.GetCurrentHealth() >= npc.GetMaxHealth() * 0.5)
					{
						damageMax = npc.GetCurrentHealth() * 0.125;
					}
					else
					{
						damageMax = (npc.GetMaxHealth() - npc.GetCurrentHealth()) * 0.0125;
					}
				}

				dmg.SetForceExplosionDismemberment();

				damageMax += damageMax * ACS_SignIntensityPercentage('total') * 0.5;

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, 50 + damageMax );

				dmg.SetForceExplosionDismemberment();

				GetWitcherPlayer().GainStat(BCS_Vitality, 50 + damageMax );

				GetACSWatcher().ShowHealFloatingValue( 50 + damageMax, true);
					
				dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;


				if ((npc.UsesVitality() && npc.GetCurrentHealth() <= 0.1)
				||
				(npc.UsesEssence() && npc.GetCurrentHealth() <= 0.1))
				{
					if (!npc.HasTag('ACS_AllBlack_Ability_Spawn_From_Construct'))
					{
						ACS_AllBlack_Ability_Spawn(npc.GetWorldPosition());

						npc.AddTag('ACS_AllBlack_Ability_Spawn_From_Construct');
					}
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Rage_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var dmg																															: W3DamageAction;
	var damageMax, damageMin																										: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var paramsKnockdown, paramsDrunkEffect 																							: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	curTargetVitality = npc.GetStat( BCS_Vitality );

	maxTargetVitality = npc.GetStatMax( BCS_Vitality );

	curTargetEssence = npc.GetStat( BCS_Essence );

	maxTargetEssence = npc.GetStatMax( BCS_Essence );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	if( thePlayer.IsSailing() 
	|| thePlayer.IsUsingHorse() 
	|| thePlayer.IsUsingVehicle() 
	)
	{
		return;
	}

	if (
	npcAttacker
	&& playerVictim
	&& npcAttacker.HasTag('ACS_In_Rage') 
	&& !npcAttacker.HasTag('ACS_Forest_God')
	&& !npcAttacker.HasTag('ACS_Forest_God_Shadows')
	)
	{
		if (action.IsActionMelee())
		{
			((CNewNPC)npcAttacker).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

			if (((W3Action_Attack)action).IsCountered()
			)
			{
				return;
			}

			ACSGetCEntityDestroyAll('ACS_Rage_Marker_1');

			ACSGetCEntityDestroyAll('ACS_Rage_Marker_2');

			ACSGetCEntityDestroyAll('ACS_Rage_Marker_Player_1');

			GetACSWatcher().RemoveTimer('ACS_Rage_Remove');
			GetACSWatcher().Rage_Remove_Actual();
			
			if (GetWitcherPlayer().IsQuenActive(true)
			)
			{
				npcAttacker.RemoveBuffImmunity_AllNegative('ACS_Rage');

				npcAttacker.RemoveBuffImmunity_AllCritical('ACS_Rage');

				npcAttacker.SetImmortalityMode( AIM_None, AIC_Default, true ); 

				npcAttacker.SetCanPlayHitAnim(true); 

				dmg = new W3DamageAction in theGame.damageMgr;
						
				dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
				
				dmg.SetProcessBuffsIfNoDamage(true);
				
				dmg.SetHitReactionType( EHRT_Heavy );

				dmg.SetHitAnimationPlayType(EAHA_ForceYes);

				dmg.SetCanPlayHitParticle(false);

				dmg.SetSuppressHitSounds(true);

				dmg.SuppressHitSounds();

				if (npcAttacker.UsesVitality()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Vitality ) * 0.1; 
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					damageMax = npcAttacker.GetStat( BCS_Essence ) * 0.1; 
				} 

				dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, 50 + RandRangeF(damageMax) );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, 50 + RandRangeF(damageMax) );

				dmg.SetCriticalHit(); theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;

				npcAttacker.RemoveTimer('ACS_AddParalyzedDelay');
				npcAttacker.AddTimer('ACS_AddParalyzedDelay', 0.125 , false );

				return;
			}

			if (
			!action.WasDodged() 
			&& !GetWitcherPlayer().IsCurrentlyDodging()
			&& !GetWitcherPlayer().IsPerformingFinisher()
			&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
			&& !GetWitcherPlayer().IsInAir()
			)
			{
				GetWitcherPlayer().RemoveBuffImmunity( EET_Stagger,					'acs_guard');
				GetWitcherPlayer().RemoveBuffImmunity( EET_LongStagger,				'acs_guard');

				if (GetWitcherPlayer().IsGuarded()
				|| GetWitcherPlayer().IsInGuardedState())
				{
					GetWitcherPlayer().SetGuarded(false);
					GetWitcherPlayer().OnGuardedReleased();	
				}

				if ( GetWitcherPlayer().IsQuenActive(false))
				{
					GetWitcherPlayer().FinishQuen(false);
				}
				
				GetACSWatcher().RemoveTimer('ACS_Shield_Spawn_Delay'); 

				ACS_Axii_Shield_Destroy();
				ACS_Axii_Shield_Destroy_DELAY();
				ACS_Quen_Monsters_Despawn();
				ACS_Bruxa_Camo_Decoy_Deactivate();
				ACS_AardPull_Deactivate();

				ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				thePlayer.ACS_ClearAnimationSpeedMultipliers();

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				GetWitcherPlayer().SetPlayerTarget( npcAttacker );

				GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

				GetWitcherPlayer().UpdateDisplayTarget( true );

				GetWitcherPlayer().UpdateLookAtTarget();

				GetWitcherPlayer().RaiseEvent( 'AttackInterrupt' );

				if (((CMovingPhysicalAgentComponent)(npcAttacker.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| npcAttacker.GetRadius() >= 0.7
				|| npcAttacker.HasAbility('Boss')
				|| npcAttacker.HasTag('IsBoss')
				|| npcAttacker.HasTag('ACS_Big_Boi')
				)
				{
					if( !playerVictim.IsImmuneToBuff( EET_HeavyKnockdown ) && !playerVictim.HasBuff( EET_HeavyKnockdown ) ) 
					{ 	
						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' );

						paramsKnockdown.effectType = EET_HeavyKnockdown;
						paramsKnockdown.creator = npcAttacker;
						paramsKnockdown.sourceName = "ACS_Rage_Effect_Custom";
						paramsKnockdown.duration = 2;

						playerVictim.AddEffectCustom( paramsKnockdown ); 							
					}
				}
				else
				{
					if( !playerVictim.IsImmuneToBuff( EET_Stagger ) && !playerVictim.HasBuff( EET_Stagger ) ) 
					{ 	
						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' );

						paramsKnockdown.effectType = EET_Stagger;
						paramsKnockdown.creator = npcAttacker;
						paramsKnockdown.sourceName = "ACS_Rage_Effect_Custom";
						paramsKnockdown.duration = 0.25;

						playerVictim.AddEffectCustom( paramsKnockdown ); 							
					}
				}
				
				ACS_PlayerHitEffects();

				GetWitcherPlayer().PlayEffectSingle('mutation_7_adrenaline_drop');
				GetWitcherPlayer().StopEffect('mutation_7_adrenaline_drop');

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				action.processedDmg.vitalityDamage += 100 + GetWitcherPlayer().GetStat(BCS_Vitality) * 0.33;

				if (
				((CNewNPC)npcAttacker).HasTag('ACS_Big_Boi')
				|| ((CNewNPC)npcAttacker).HasAbility('mon_toad_base')
				|| ((CNewNPC)npcAttacker).HasAbility('mon_type_huge')
				|| ((CMovingPhysicalAgentComponent)((npcAttacker).GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| ((CNewNPC)npcAttacker).GetRadius() >= 0.7
				)
				{
					thePlayer.ACS_DealPlayerPostureDamage(70, true);
				}
				else
				{
					thePlayer.ACS_DealPlayerPostureDamage(50, true);
				}

				if (thePlayer.acs_grey_health_current > 0
				)
				{
					thePlayer.ACS_ManageGreyHealth(false, thePlayer.acs_grey_health_current);
				}

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStat(BCS_Stamina) * 0.33 );

				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );

				GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

				GetWitcherPlayer().SoundEvent("damage_01_bb_acs");

				GetWitcherPlayer().SoundEvent("damage_02_bb_acs");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				GetWitcherPlayer().PlayEffectSingle('heavy_hit');
				GetWitcherPlayer().StopEffect('heavy_hit');
			}
		}
	}
}

function ACS_NPC_Normal_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var dest, victimPos, newVictimPos																								: Vector;
	var dist																														: float;
	var params 																														: SCustomEffectParams;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if (FactsQuerySum("acs_transformation_activated") > 0)
	{
		return;
	}

	if (
	npcAttacker
	&& playerVictim
	)
	{
		if (thePlayer.IsDodgeTimerRunning()
		|| thePlayer.IsCurrentlyDodging()
		|| thePlayer.HasTag('ACS_Is_Currently_Dodging')
		//|| (((W3Action_Attack)action).IsParried())
		|| (((W3Action_Attack)action).IsCountered())
		|| GetWitcherPlayer().IsQuenActive(true)
		)
		{
			if (ACS_DodgeSlowMo_Enabled())
			{
				ACS_Tutorial_Display_Check('ACS_PerfectDodgesCounters_Tutorial_Shown');
				GetACSWatcher().ACS_SlowMoAdjustable(0.6,0.6);
			}
		}
		else
		{
			if (!(((W3Action_Attack)action).IsParried())
			)
			{
				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) * 0.33 );
			}
		}
	}
}

function ACS_ActionDealsDamageType(action : W3DamageAction, type : name) : bool
{
	var i, size 																													: int;
	var dmgTypes 																													: array< SRawDamage >;

	action.GetDTs( dmgTypes );
	
	size = dmgTypes.Size();

	for(i=0; i<size; i+=1)
	{
		switch(type)
		{
			case 'stamina':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_STAMINA )
				{
					return true;
				}
			break;

			case 'morale':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_MORALE )
				{
					return true;
				}
			break;

			case 'shock':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_SHOCK )
				{
					return true;
				}
			break;

			case 'poison':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_POISON )
				{
					return true;
				}
			break;

			case 'frost':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_FROST )
				{
					return true;
				}
			break;

			case 'force':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_FORCE )
				{
					return true;
				}
			break;

			case 'fire':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_FIRE )
				{
					return true;
				}
			break;

			case 'elemental':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_ELEMENTAL )
				{
					return true;
				}
			break;

			case 'rending':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_RENDING )
				{
					return true;
				}
			break;

			case 'bludgeoning':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_BLUDGEONING )
				{
					return true;
				}
			break;

			case 'piercing':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_PIERCING )
				{
					return true;
				}
			break;

			case 'slashing':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_SLASHING )
				{
					return true;
				}
			break;

			case 'silver':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_SILVER )
				{
					return true;
				}
			break;

			case 'physical':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_PHYSICAL )
				{
					return true;
				}
			break;

			case 'direct':
				if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_DIRECT )
				{
					return true;
				}
			break;

			default:
				return false;
			break;
		}
		
	}
			
	return false;		
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_EnemyBehSwitch
{
	function EnemyBehSwitch()
	{
		this.PushState('EnemyBehSwitch');
	}
}

state EnemyBehSwitch in cACS_EnemyBehSwitch
{
	private var actors		    												: array<CActor>;
	private var i																: int;
	private var npc																: CActor;
	private var sword															: SItemUniqueId;
	private var shield_temp														: CEntityTemplate;
	private var shield															: ACSShieldSpawner;
	private var behGraphNames 													: array< name >;
	private var itemId_r, itemId_l 												: SItemUniqueId;
	private var itemTags_r, itemTags_l 											: array<name>;
	private var voiceTagName 													: name;
	private var voiceTagStr														: string;
	private var npcStorage 														: CBaseAICombatStorage;
	private var targetDistance 													: float;

	event OnEnterState(prevStateName : name)
	{
		EnemyBehSwitch_AllInOne();
	}
	
	entry function EnemyBehSwitch_AllInOne()
	{
		actors.Clear();
		
		actors = GetWitcherPlayer().GetNPCsAndPlayersInRange( 20, 50, , FLAG_ExcludePlayer + FLAG_OnlyAliveActors + FLAG_Attitude_Hostile);

		if( actors.Size() > 0 )
		{
			for( i = 0; i < actors.Size(); i += 1 )
			{
				npc = actors[i];

				voiceTagName =  npc.GetVoicetag();

				voiceTagStr = NameToString( voiceTagName );

				npcStorage = (CBaseAICombatStorage)npc.GetScriptStorageObject('CombatData');

				targetDistance = VecDistanceSquared2D( npc.GetWorldPosition(), thePlayer.GetWorldPosition() );

				if(!theGame.IsDialogOrCutscenePlaying()

				&& targetDistance > 10 * 10
				&& !GetWitcherPlayer().IsUsingHorse() 
				&& !GetWitcherPlayer().IsUsingVehicle()
				&& !npcStorage.GetIsInImportantAnim()
				&& !npcStorage.GetIsAttacking()
				&& !npcStorage.GetIsCharging()
				&& !npcStorage.GetIsTaunting()
				&& !npcStorage.GetIsShooting()
				&& !npcStorage.GetIsAiming()
				&& npc.IsHuman()
				&& ((CNewNPC)npc).GetNPCType() != ENGT_Quest
				&& !npc.HasTag( 'ethereal' )
				&& !npc.HasAbility( 'Boss' )
				&& !npc.HasTag( 'IsBoss' )
				&& !npc.HasTag( 'ACS_Berserkers_Human' )
				&& !npc.HasTag( 'ACS_Shades_Hunter' )
				&& !npc.HasTag( 'ACS_Shades_Crusader' )
				&& !npc.IsUsingHorse()
				&& !npc.IsUsingVehicle()
				&& !npc.HasTag('ACS_In_Rage')
				&& !npc.HasTag('ACS_Currently_In_Grapple_Anim')
				&& !npc.HasTag('ACS_Pre_Rage')
				&& !npc.HasTag('ACS_Bomber')
				&& !npc.HasTag('ACS_Bomb_Planted')
				&& !npc.HasTag('ACS_Throw_Bomb_Init')
				&& !npc.HasTag('ACS_Final_Fear_Stack')

				&& !npc.HasTag('ACS_Currently_In_Beh_Switch_Anim')

				&& !npc.IsRagdolled()

				&& !npc.HasBuff(EET_Knockdown)

				&& !npc.HasBuff(EET_HeavyKnockdown)

				&& !npc.HasBuff(EET_Ragdoll)

				&& !npc.HasBuff(EET_Burning)

				&& !npc.HasBuff(EET_Frozen)

				&& !npc.HasBuff(EET_LongStagger)

				&& !npc.HasBuff(EET_Stagger)

				&& !npc.HasBuff(EET_Weaken)

				&& !npc.HasBuff(EET_Confusion)

				&& !npc.HasBuff(EET_AxiiGuardMe)

				&& !npc.HasBuff(EET_Hypnotized)

				&& !npc.HasBuff(EET_Immobilized)

				&& !npc.HasBuff(EET_Paralyzed)

				&& !npc.HasBuff(EET_Blindness)

				&& !npc.HasBuff(EET_Choking)

				&& !npc.HasBuff(EET_Swarm)

				&& !npc.IsInAir()

				&& npc.IsOnGround()

				&& !npc.GetIsRecoveringFromKnockdown()

				&& !((CNewNPC)npc).IsInFinisherAnim()

				&& GetACSWatcher().ACS_Rage_Process == false

				&& npc.GetBehaviorGraphInstanceName() != 'Shield'

				&& !StrContains( npc.I_GetDisplayName(), "Bandit" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Cannibal" )
				&& !StrContains( npc.I_GetDisplayName(), "Thug" )

				&& !StrContains( npc.I_GetDisplayName(), "Cannibale" )
				&& !StrContains( npc.I_GetDisplayName(), "Voyou" )

				&& !StrContains( npc.I_GetDisplayName(), "Bandito" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Delinquente" )

				&& !StrContains( npc.I_GetDisplayName(), "Kannibale" )
				&& !StrContains( npc.I_GetDisplayName(), "Schurke" )

				&& !StrContains( npc.I_GetDisplayName(), "Bandido" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Caníbal" )
				&& !StrContains( npc.I_GetDisplayName(), "Matón" )

				&& !StrContains( npc.I_GetDisplayName(), "قاطع طريق" ) 
				&& !StrContains( npc.I_GetDisplayName(), "آكلي لحوم البشر" )
				&& !StrContains( npc.I_GetDisplayName(), "سفاح" )

				&& !StrContains( npc.I_GetDisplayName(), "Bandita" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Kanibal" )

				&& !StrContains( npc.I_GetDisplayName(), "Kannibál" )
				&& !StrContains( npc.I_GetDisplayName(), "Orgyilkos" )

				&& !StrContains( npc.I_GetDisplayName(), "山賊" ) 
				&& !StrContains( npc.I_GetDisplayName(), "人食い人種" )
				&& !StrContains( npc.I_GetDisplayName(), "ちんぴら" )

				&& !StrContains( npc.I_GetDisplayName(), "적기" ) 
				&& !StrContains( npc.I_GetDisplayName(), "식인종" )
				&& !StrContains( npc.I_GetDisplayName(), "자객" )

				&& !StrContains( npc.I_GetDisplayName(), "Bandyta" )

				&& !StrContains( npc.I_GetDisplayName(), "Canibal" )

				&& !StrContains( npc.I_GetDisplayName(), "Бандит" ) 
				&& !StrContains( npc.I_GetDisplayName(), "Каннибал" )
				&& !StrContains( npc.I_GetDisplayName(), "бандит" )

				&& !StrContains( npc.I_GetDisplayName(), "土匪" ) 
				&& !StrContains( npc.I_GetDisplayName(), "食人族" )
				&& !StrContains( npc.I_GetDisplayName(), "暴徒" )
				&& !StrContains( npc.GetReadableName(), "bandit" ) 
				&& !StrContains( npc.GetReadableName(), "cannibal" ) 

				&& !StrContains( npc.GetReadableName(), "southerner_son" ) 

				&& !StrContains( npc.GetReadableName(), "sq209" ) 

				&& thePlayer.GetPlayerAction() == PEA_None

				&& !thePlayer.HasTag('ACS_Is_Sneaking')

				&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
				&& !thePlayer.HasTag('ACS_IsPerformingCombatDismember')
				&& !thePlayer.HasTag('ACS_Bruxa_Bite_Process')
				&& !thePlayer.HasTag('ACS_Transformation_Bruxa_Cloaked')
				&& !thePlayer.HasTag('ACS_Ghost_Stance_Active')
				&& !thePlayer.HasTag('ACS_Neutral_Flip')
				&& !thePlayer.HasTag('ACS_In_Heavenly_Strike')
				&& !thePlayer.HasTag('ACS_In_Dance_Of_Wrath')
				&& !thePlayer.HasTag('ACS_In_Combat_Art')

				&& !npc.HasTag('mq1060_witcher')

				&& !npc.HasTag('acs_dual_wield_enemy')

				&& !npc.HasTag('ACS_man_finisher_dlc_arm_lp_combat_dismember')
				&& !npc.HasTag('ACS_man_finisher_dlc_arm_rp_combat_dismember')
				&& !npc.HasTag('ACS_man_finisher_dlc_legs_lp_combat_dismember')
				&& !npc.HasTag('ACS_man_finisher_dlc_legs_rp_combat_dismember')

				&& StrFindFirst(voiceTagStr, "REINALD") < 0

				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Fists
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Undefined
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Crossbow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Bow
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_None
				&& ((CHumanAICombatStorage)npc.GetScriptStorageObject('CombatData')).GetActiveCombatStyle() != EBG_Combat_Shield
				)
				{
					itemId_r = npc.GetInventory().GetItemFromSlot('r_weapon');

					itemId_l = npc.GetInventory().GetItemFromSlot('l_weapon');

					npc.GetInventory().GetItemTags(itemId_r, itemTags_r);

					npc.GetInventory().GetItemTags(itemId_l, itemTags_l);

					if ( 
					itemTags_r.Contains('sword1h') 
					|| itemTags_r.Contains('axe1h')
					|| itemTags_r.Contains('blunt1h')
					|| itemTags_r.Contains('steelsword')
					)
					{
						if ( 
						(
						( npc.GetCurrentHealth() <= npc.GetMaxHealth() * RandRangeF(0.875, 0.625) )
						)
						&& !npc.HasTag('ACS_One_Hand_Swap_Stage_1')
						&& !npc.HasTag('ACS_One_Hand_Swap_Stage_2')
						)
						{
							ACS_Tutorial_Display_Check('ACS_Dynamic_Enemy_Behavior_System_Tutorial_Shown');

							if ( npc.GetBehaviorGraphInstanceName() == 'sword_2handed' )
							{
								npc.AddTag('ACS_sword2h_npc');

								if( RandF() < 0.5 ) 
								{
									Sword1h_Switch(npc);
								}
								else
								{
									Witcher_Switch(npc);
								}
							}
							else if ( npc.GetBehaviorGraphInstanceName() == 'sword_1handed' )
							{
								npc.AddTag('ACS_sword1h_npc');

								if( RandF() < 0.5 ) 
								{
									Sword2h_Switch(npc);
								}
								else
								{
									Witcher_Switch(npc);
								}
							}
							else if ( npc.GetBehaviorGraphInstanceName() == 'Witcher' )
							{
								npc.AddTag('ACS_witcher_npc');

								if( RandF() < 0.5 ) 
								{
									Sword1h_Switch(npc);
								}
								else
								{
									Sword2h_Switch(npc);
								}
							}

							npc.AddTag('ACS_One_Hand_Swap_Stage_1');
						}
						else if 
						(
						( 
						( npc.GetCurrentHealth() <= npc.GetMaxHealth() * RandRangeF(0.5, 0.25) )
						)
						&& npc.HasTag('ACS_One_Hand_Swap_Stage_1')
						&& !npc.HasTag('ACS_One_Hand_Swap_Stage_2')
						)
						{
							if( npc.HasTag('ACS_Swapped_To_Witcher') ) 
							{
								if (
								npc.GetInventory().HasItem('crossbow')
								|| npc.GetInventory().HasItem('bow')
								|| npc.GetInventory().HasItemByTag('crossbow')
								|| npc.GetInventory().HasItemByTag('bow')
								|| ((CNewNPC)npc).GetNPCType() == ENGT_Guard
								|| npc.HasTag('ACS_Wild_Hunt_Rider')
								)
								{
									if( npc.HasTag('ACS_sword1h_npc') )
									{
										Sword2h_Switch(npc);
									}
									else if( npc.HasTag('ACS_sword2h_npc') )
									{
										Sword1h_Switch(npc);
									}
									else
									{
										if( RandF() < 0.33 ) 
										{
											Sword1h_Switch(npc);
										}
										else
										{
											Sword2h_Switch(npc);
										}
									}
								}
								else
								{
									if (GetWitcherPlayer().IsGuarded())
									{
										if( RandF() < 0.75 ) 
										{
											if( RandF() < 0.95 ) 
											{
												if (npc.UsesVitality())
												{
													Shield_Switch(npc);
												}
												else
												{
													Vamp_Switch(npc);
												}
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
										else
										{
											if( npc.HasTag('ACS_sword1h_npc') )
											{
												Sword2h_Switch(npc);
											}
											else if( npc.HasTag('ACS_sword2h_npc') )
											{
												Sword1h_Switch(npc);
											}
											else
											{
												if( RandF() < 0.33 ) 
												{
													Sword1h_Switch(npc);
												}
												else
												{
													Sword2h_Switch(npc);
												}
											}
										}
									}
									else
									{
										if( RandF() < 0.66 ) 
										{
											if( npc.HasTag('ACS_sword1h_npc') )
											{
												Sword2h_Switch(npc);
											}
											else if( npc.HasTag('ACS_sword2h_npc') )
											{
												Sword1h_Switch(npc);
											}
											else
											{
												if( RandF() < 0.33 ) 
												{
													Sword1h_Switch(npc);
												}
												else
												{
													Sword2h_Switch(npc);
												}
											}
										}
										else
										{
											if( RandF() < 0.95 ) 
											{
												if (npc.UsesVitality())
												{
													Shield_Switch(npc);
												}
												else
												{
													Vamp_Switch(npc);
												}
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
									}
								}
							}
							else if (npc.HasTag('ACS_Swapped_To_2h_Sword'))
							{
								if (
								npc.GetInventory().HasItem('crossbow')
								|| npc.GetInventory().HasItem('bow')
								|| npc.GetInventory().HasItemByTag('crossbow')
								|| npc.GetInventory().HasItemByTag('bow')
								|| ((CNewNPC)npc).GetNPCType() == ENGT_Guard
								|| npc.HasTag('ACS_Wild_Hunt_Rider')
								)
								{
									if( npc.HasTag('ACS_sword1h_npc') )
									{
										Witcher_Switch(npc);
									}
									else if( npc.HasTag('ACS_witcher_npc') )
									{
										Sword1h_Switch(npc);
									}
									else
									{
										if( RandF() < 0.33 ) 
										{
											Sword1h_Switch(npc);
										}
										else
										{
											Witcher_Switch(npc);
										}
									}
								}
								else
								{
									if (GetWitcherPlayer().IsGuarded())
									{
										if( RandF() < 0.75 ) 
										{
											if( RandF() < 0.95 ) 
											{
												if (npc.UsesVitality())
												{
													Shield_Switch(npc);
												}
												else
												{
													Vamp_Switch(npc);
												}
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
										else
										{
											if( npc.HasTag('ACS_sword1h_npc') )
											{
												Witcher_Switch(npc);
											}
											else if( npc.HasTag('ACS_witcher_npc') )
											{
												Sword1h_Switch(npc);
											}
											else
											{
												if( RandF() < 0.33 ) 
												{
													Sword1h_Switch(npc);
												}
												else
												{
													Witcher_Switch(npc);
												}
											}
										}
									}
									else
									{
										if( RandF() < 0.66 ) 
										{
											if( npc.HasTag('ACS_sword1h_npc') )
											{
												Witcher_Switch(npc);
											}
											else if( npc.HasTag('ACS_witcher_npc') )
											{
												Sword1h_Switch(npc);
											}
											else
											{
												if( RandF() < 0.33 ) 
												{
													Sword1h_Switch(npc);
												}
												else
												{
													Witcher_Switch(npc);
												}
											}
										}
										else
										{
											if( RandF() < 0.95 ) 
											{
												if (npc.UsesVitality())
												{
													Shield_Switch(npc);
												}
												else
												{
													Vamp_Switch(npc);
												}
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
									}
								}
							}
							else if( npc.HasTag('ACS_Swapped_To_1h_Sword') ) 
							{
								if (
								npc.GetInventory().HasItem('crossbow')
								|| npc.GetInventory().HasItem('bow')
								|| npc.GetInventory().HasItemByTag('crossbow')
								|| npc.GetInventory().HasItemByTag('bow')
								|| ((CNewNPC)npc).GetNPCType() == ENGT_Guard
								|| npc.HasTag('ACS_Wild_Hunt_Rider')
								)
								{
									if( npc.HasTag('ACS_witcher_npc') )
									{
										Sword2h_Switch(npc);
									}
									else if( npc.HasTag('ACS_sword2h_npc') )
									{
										Witcher_Switch(npc);
									}
									else
									{
										if( RandF() < 0.5 ) 
										{
											Sword2h_Switch(npc);
										}
										else
										{
											Witcher_Switch(npc);
										}
									}	
								}
								else
								{
									if (GetWitcherPlayer().IsGuarded())
									{
										if( RandF() < 0.75 ) 
										{
											if( RandF() < 0.95 ) 
											{
												if (npc.UsesVitality())
												{
													Shield_Switch(npc);
												}
												else
												{
													Vamp_Switch(npc);
												}
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
										else
										{
											if( npc.HasTag('ACS_witcher_npc') )
											{
												Sword2h_Switch(npc);
											}
											else if( npc.HasTag('ACS_sword2h_npc') )
											{
												Witcher_Switch(npc);
											}
											else
											{
												if( RandF() < 0.5 ) 
												{
													Sword2h_Switch(npc);
												}
												else
												{
													Witcher_Switch(npc);
												}
											}
										}
									}
									else
									{
										if( RandF() < 0.66 ) 
										{
											if( npc.HasTag('ACS_witcher_npc') )
											{
												Sword2h_Switch(npc);
											}
											else if( npc.HasTag('ACS_sword2h_npc') )
											{
												Witcher_Switch(npc);
											}
											else
											{
												if( RandF() < 0.5 ) 
												{
													Sword2h_Switch(npc);
												}
												else
												{
													Witcher_Switch(npc);
												}
											}
										}
										else
										{
											if( RandF() < 0.95 ) 
											{
												if (npc.UsesVitality())
												{
													Shield_Switch(npc);
												}
												else
												{
													Vamp_Switch(npc);
												}
											}
											else
											{
												Vamp_Switch(npc);
											}
										}
									}
								}
							}

							npc.AddTag('ACS_One_Hand_Swap_Stage_2');
						}
					}
				}
			}
		}
	}

	latent function Sword1h_Switch( npc : CActor )
	{
		var masterDef															: SAnimationSequenceDefinition;
		var masterSequencePart													: SAnimationSequencePartDefinition;
		var syncInstance														: CAnimationManualSlotSyncInstance;
		
		var instanceIndex														: int;
		var sequenceIndex														: int;

		var syncAnimName														: name;
		
		var masterAnim 															: name;
		var syncAnimIndex														: int;
		var currentAnimInstance													: CAnimationManualSlotSyncInstance;

		var markerNPC_1															: CEntity;

		if( !npc.HasTag('ACS_Swapped_To_1h_Sword') )
		{
			//((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.AttachBehavior( 'sword_1handed' );

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			npc.ACS_SetAnimationSpeedMultiplier(1);

			npc.AddTag('ACS_Currently_In_Beh_Switch_Anim');

			npc.ACS_RemoveTagAfter('ACS_Currently_In_Beh_Switch_Anim', 3);

			markerNPC_1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
							
			"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

			, true ), npc.GetWorldPosition() );

			markerNPC_1.CreateAttachment( npc,, Vector(0,0,1.25) );

			markerNPC_1.PlayEffectSingle('mutation_7_buff');

			markerNPC_1.DestroyAfter(1);

			syncInstance 										= theGame.GetSyncAnimManager().CreateNewSyncInstance( instanceIndex );
			syncAnimIndex 										= instanceIndex;
			currentAnimInstance 								= syncInstance;

			masterSequencePart.animation						= 'man_npc_sword_1hand_taunt_3_left';
			masterSequencePart.syncType							= AMST_SyncBeginning;
			masterSequencePart.useRefBone						= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone 		= SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide						= false;
			masterSequencePart.shouldRotate						= false;

			masterSequencePart.blendInTime						= 0.5f;
			masterSequencePart.blendOutTime						= 2.5f;
			masterSequencePart.sequenceIndex					= 0;


			masterDef.parts.PushBack( masterSequencePart );


			masterDef.entity									= npc;
			
			masterDef.manualSlotName							= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd								= false;

			sequenceIndex 										= syncInstance.RegisterMaster( masterDef );

			npc.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			npc.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			npc.SignalGameplayEvent( 'PlaySyncedAnim' );

			npc.AddTag('ACS_Swapped_To_1h_Sword');
		}
	}

	latent function Sword2h_Switch( npc : CActor )
	{
		var masterDef															: SAnimationSequenceDefinition;
		var masterSequencePart													: SAnimationSequencePartDefinition;
		var syncInstance														: CAnimationManualSlotSyncInstance;
		
		var instanceIndex														: int;
		var sequenceIndex														: int;

		var syncAnimName														: name;
		
		var masterAnim 															: name;
		var syncAnimIndex														: int;
		var currentAnimInstance													: CAnimationManualSlotSyncInstance;

		var markerNPC_1															: CEntity;

		if( !npc.HasTag('ACS_Swapped_To_2h_Sword') )
		{
			//((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			if( npc.HasTag('ACS_Swapped_To_Witcher') )
			{
				//npc.DetachBehavior('Witcher');

				//npc.RemoveTag('ACS_Swapped_To_Witcher');
			}

			npc.AttachBehavior( 'sword_2handed' );

			npc.ACS_SetAnimationSpeedMultiplier(1.15);

			npc.AddTag('ACS_Currently_In_Beh_Switch_Anim');

			npc.ACS_RemoveTagAfter('ACS_Currently_In_Beh_Switch_Anim', 3);

			markerNPC_1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
							
			"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

			, true ), npc.GetWorldPosition() );

			markerNPC_1.CreateAttachment( npc,, Vector(0,0,1.25) );

			markerNPC_1.PlayEffectSingle('mutation_7_buff');

			markerNPC_1.DestroyAfter(1);

			syncInstance 										= theGame.GetSyncAnimManager().CreateNewSyncInstance( instanceIndex );
			syncAnimIndex 										= instanceIndex;
			currentAnimInstance 								= syncInstance;

			masterSequencePart.animation						= 'man_npc_sword_2hand_taunt_1';
			masterSequencePart.syncType							= AMST_SyncBeginning;
			masterSequencePart.useRefBone						= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone 		= SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide						= false;
			masterSequencePart.shouldRotate						= false;

			masterSequencePart.blendInTime						= 0.5f;
			masterSequencePart.blendOutTime						= 2.5f;
			masterSequencePart.sequenceIndex					= 0;


			masterDef.parts.PushBack( masterSequencePart );


			masterDef.entity									= npc;
			
			masterDef.manualSlotName							= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd								= false;

			sequenceIndex 										= syncInstance.RegisterMaster( masterDef );

			npc.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			npc.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			npc.SignalGameplayEvent( 'PlaySyncedAnim' );

			npc.AddTag('ACS_Swapped_To_2h_Sword');
		}
	}

	latent function Witcher_Switch( npc : CActor )
	{
		var masterDef															: SAnimationSequenceDefinition;
		var masterSequencePart													: SAnimationSequencePartDefinition;
		var syncInstance														: CAnimationManualSlotSyncInstance;
		
		var instanceIndex														: int;
		var sequenceIndex														: int;

		var syncAnimName														: name;
		
		var masterAnim 															: name;
		var syncAnimIndex														: int;
		var currentAnimInstance													: CAnimationManualSlotSyncInstance;

		var markerNPC_1															: CEntity;

		if( !npc.HasTag('ACS_Swapped_To_Witcher') )
		{
			//((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			if( npc.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				//npc.DetachBehavior('sword_2handed');

				//npc.RemoveTag('ACS_Swapped_To_2h_Sword');
			}

			npc.AttachBehavior( 'Witcher' );

			npc.ACS_SetAnimationSpeedMultiplier(0.875);

			npc.AddTag('ACS_Currently_In_Beh_Switch_Anim');

			npc.ACS_RemoveTagAfter('ACS_Currently_In_Beh_Switch_Anim', 3);

			markerNPC_1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
							
			"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

			, true ), npc.GetWorldPosition() );

			markerNPC_1.CreateAttachment( npc,, Vector(0,0,1.25) );

			markerNPC_1.PlayEffectSingle('mutation_7_buff');

			markerNPC_1.DestroyAfter(1);

			syncInstance 										= theGame.GetSyncAnimManager().CreateNewSyncInstance( instanceIndex );
			syncAnimIndex 										= instanceIndex;
			currentAnimInstance 								= syncInstance;

			masterSequencePart.animation						= 'man_npc_sword_2hand_taunt_2';
			masterSequencePart.syncType							= AMST_SyncBeginning;
			masterSequencePart.useRefBone						= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone 		= SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide						= false;
			masterSequencePart.shouldRotate						= false;

			masterSequencePart.blendInTime						= 0.5f;
			masterSequencePart.blendOutTime						= 2.5f;
			masterSequencePart.sequenceIndex					= 0;


			masterDef.parts.PushBack( masterSequencePart );


			masterDef.entity									= npc;
			
			masterDef.manualSlotName							= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd								= false;

			sequenceIndex 										= syncInstance.RegisterMaster( masterDef );

			npc.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			npc.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			npc.SignalGameplayEvent( 'PlaySyncedAnim' );

			npc.AddTag('ACS_Swapped_To_Witcher');
		}
	}

	latent function Shield_Switch( npc : CActor )
	{
		var masterDef															: SAnimationSequenceDefinition;
		var masterSequencePart													: SAnimationSequencePartDefinition;
		var syncInstance														: CAnimationManualSlotSyncInstance;
		
		var instanceIndex														: int;
		var sequenceIndex														: int;

		var syncAnimName														: name;
		
		var masterAnim 															: name;
		var syncAnimIndex														: int;
		var currentAnimInstance													: CAnimationManualSlotSyncInstance;

		var markerNPC_1															: CEntity;

		if( !npc.HasTag('ACS_Swapped_To_Shield') )
		{
			//((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			if( npc.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				//npc.DetachBehavior('sword_2handed');

				//npc.RemoveTag('ACS_Swapped_To_2h_Sword');
			}

			if( npc.HasTag('ACS_Swapped_To_Witcher') )
			{
				//npc.DetachBehavior('Witcher');

				//npc.RemoveTag('ACS_Swapped_To_Witcher');
			}

			npc.AttachBehavior( 'Shield' );

			npc.ACS_SetAnimationSpeedMultiplier(1.25);

			npc.AddTag('ACS_Currently_In_Beh_Switch_Anim');

			npc.ACS_RemoveTagAfter('ACS_Currently_In_Beh_Switch_Anim', 3);

			markerNPC_1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
							
			"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

			, true ), npc.GetWorldPosition() );

			markerNPC_1.CreateAttachment( npc,, Vector(0,0,1.25) );

			markerNPC_1.PlayEffectSingle('mutation_7_buff');

			markerNPC_1.DestroyAfter(1);

			syncInstance 										= theGame.GetSyncAnimManager().CreateNewSyncInstance( instanceIndex );
			syncAnimIndex 										= instanceIndex;
			currentAnimInstance 								= syncInstance;

			masterSequencePart.animation						= 'man_npc_shield_taunt_rp_01';
			masterSequencePart.syncType							= AMST_SyncBeginning;
			masterSequencePart.useRefBone						= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone 		= SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide						= false;
			masterSequencePart.shouldRotate						= false;

			masterSequencePart.blendInTime						= 0.5f;
			masterSequencePart.blendOutTime						= 2.5f;
			masterSequencePart.sequenceIndex					= 0;


			masterDef.parts.PushBack( masterSequencePart );


			masterDef.entity									= npc;
			
			masterDef.manualSlotName							= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd								= false;

			sequenceIndex 										= syncInstance.RegisterMaster( masterDef );

			npc.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			npc.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			npc.SignalGameplayEvent( 'PlaySyncedAnim' );

			shield_temp = (CEntityTemplate)LoadResource( 
		
			"dlc\dlc_acs\data\entities\other\shield_spawner.w2ent"
			
			, true );

			shield = (ACSShieldSpawner)theGame.CreateEntity( shield_temp, npc.GetBoneWorldPosition('l_weapon') );

			shield.CreateAttachment( npc, 'l_weapon', Vector(0,0,0), EulerAngles(0,0,0) );

			shield.AddTag('ACS_ShieldSpawner');

			npc.AddTag('ACS_Swapped_To_Shield');
		}
	}

	latent function Vamp_Switch( npc : CActor )
	{
		var masterDef															: SAnimationSequenceDefinition;
		var masterSequencePart													: SAnimationSequencePartDefinition;
		var syncInstance														: CAnimationManualSlotSyncInstance;
		
		var instanceIndex														: int;
		var sequenceIndex														: int;

		var syncAnimName														: name;
		
		var masterAnim 															: name;
		var syncAnimIndex														: int;
		var currentAnimInstance													: CAnimationManualSlotSyncInstance;

		var markerNPC_1															: CEntity;

		if( !npc.HasTag('ACS_Swapped_To_Vampire') )
		{
			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			//((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			if( npc.HasTag('ACS_Swapped_To_2h_Sword') )
			{
				//npc.DetachBehavior('sword_2handed');

				//npc.RemoveTag('ACS_Swapped_To_2h_Sword');
			}

			if( npc.HasTag('ACS_Swapped_To_Witcher') )
			{
				//npc.DetachBehavior('Witcher');

				//npc.RemoveTag('ACS_Swapped_To_Witcher');
			}

			npc.AttachBehavior( 'DettlaffVampire_ACS' );

			npc.AddTag('ACS_Currently_In_Beh_Switch_Anim');

			npc.ACS_RemoveTagAfter('ACS_Currently_In_Beh_Switch_Anim', 3);

			markerNPC_1 = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( 
							
			"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

			, true ), npc.GetWorldPosition() );

			markerNPC_1.CreateAttachment( npc,, Vector(0,0,1.25) );

			markerNPC_1.PlayEffectSingle('mutation_7_buff');

			markerNPC_1.DestroyAfter(1);

			syncInstance 										= theGame.GetSyncAnimManager().CreateNewSyncInstance( instanceIndex );
			syncAnimIndex 										= instanceIndex;
			currentAnimInstance 								= syncInstance;

			masterSequencePart.animation						= 'utility_taunt_01';
			masterSequencePart.syncType							= AMST_SyncBeginning;
			masterSequencePart.useRefBone						= 'Reference';
			masterSequencePart.rotationTypeUsingRefBone 		= SRT_TowardsOtherEntity;
			masterSequencePart.shouldSlide						= false;
			masterSequencePart.shouldRotate						= false;

			masterSequencePart.blendInTime						= 0.5f;
			masterSequencePart.blendOutTime						= 2.5f;
			masterSequencePart.sequenceIndex					= 0;


			masterDef.parts.PushBack( masterSequencePart );


			masterDef.entity									= npc;
			
			masterDef.manualSlotName							= 'GAMEPLAY_SLOT';

			masterDef.freezeAtEnd								= false;

			sequenceIndex 										= syncInstance.RegisterMaster( masterDef );

			npc.SignalGameplayEventParamInt( 'SetupSyncInstance', instanceIndex );
			npc.SignalGameplayEventParamInt( 'SetupSequenceIndex', sequenceIndex );
			npc.SignalGameplayEvent( 'PlaySyncedAnim' );

			(npc.GetInventory().GetItemEntityUnsafe( npc.GetInventory().GetItemFromSlot( 'r_weapon' ) )).SetHideInGame(true);

			npc.StopEffect('demonic_possession');
			npc.PlayEffectSingle('demonic_possession');

			npc.AddTag('ACS_Swapped_To_Vampire');
		}
	}
}

/*
// SHIELDS

// LIST OF AVAILABLE SHIELDS TO USE //

// VANILLA GAME SHIELDS
// "items\weapons\shields\bandit_shield_01.w2ent"
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

*/