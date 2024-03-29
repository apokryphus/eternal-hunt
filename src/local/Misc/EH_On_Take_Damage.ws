function ACS_OnTakeDamage(action: W3DamageAction)
{
	var money 							: float;
	var movementAdjustor				: CMovementAdjustor;
	var ticket 							: SMovementAdjustmentRequestTicket;


	if (GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	|| GetWitcherPlayer().IsPerformingFinisher())
	{
		return;
	}

	if( GetWitcherPlayer().HasBuff( EET_Mutation11Immortal ) )
	{
		ACS_ThingsThatShouldBeRemoved();

		if (ACS_Transformation_Werewolf_Check())
		{
			GetACSWatcher().DisableWerewolf_Actual();
		}

		if (ACS_Transformation_Vampiress_Check())
		{
			GetACSWatcher().DisableVampiress_Actual();
		}

		if (ACS_Transformation_Vampire_Monster_Check())
		{
			GetACSWatcher().DisableTransformationVampireMonster_Actual_No_Teleport();
		}

		if (ACS_Transformation_Toad_Check())
		{
			GetACSWatcher().DisableTransformationToad_Actual();
		}

		if (ACS_Transformation_Red_Miasmal_Check())
		{
			GetACSWatcher().DisableRedMiasmal_Actual();
		}

		if (ACS_Transformation_Sharley_Check())
		{
			GetACSWatcher().DisableSharley_Actual();
		}

		if (ACS_Transformation_Black_Wolf_Check())
		{
			GetACSWatcher().DisableBlackWolf_Actual();
		}

		GetWitcherPlayer().AddTag('ACS_Second_Life_Active');

		return;
	}

	if( GetWitcherPlayer().IsActionBlockedBy(EIAB_Movement, 'Mutation11') && GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) && !GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) && !GetWitcherPlayer().IsInAir() )
	{
		ACS_ThingsThatShouldBeRemoved();

		if (ACS_Transformation_Werewolf_Check())
		{
			GetACSWatcher().DisableWerewolf_Actual();
		}

		if (ACS_Transformation_Vampiress_Check())
		{
			GetACSWatcher().DisableVampiress_Actual();
		}

		if (ACS_Transformation_Vampire_Monster_Check())
		{
			GetACSWatcher().DisableTransformationVampireMonster_Actual_No_Teleport();
		}

		if (ACS_Transformation_Toad_Check())
		{
			GetACSWatcher().DisableTransformationToad_Actual();
		}

		if (ACS_Transformation_Red_Miasmal_Check())
		{
			GetACSWatcher().DisableRedMiasmal_Actual();
		}

		if (ACS_Transformation_Sharley_Check())
		{
			GetACSWatcher().DisableSharley_Actual();
		}

		if (ACS_Transformation_Black_Wolf_Check())
		{
			GetACSWatcher().DisableBlackWolf_Actual();
		}

		GetWitcherPlayer().AddTag('ACS_Second_Life_Active');

		return;
	}

	ACS_Player_Fall_Negate(action);

	ACS_Player_Attack_Steel_Silver_Switch(action);

	ACS_Player_Attack_FX_Switch(action);

	ACS_Player_Attack(action);

    ACS_Player_Guard(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Forest_God_On_Take_Damage(action);

	ACS_Rage_Enemy_On_Take_Damage(action);

	ACS_Nekker_Guardian_On_Take_Damage(action);

	ACS_Phooca_On_Take_Damage(action);

	ACS_Plumard_On_Take_Damage(action);

	ACS_Nekurat_On_Take_Damage(action);

	ACS_Harpy_Queen_On_Take_Damage(action);

	ACS_Harpy_Praetorian_On_Take_Damage(action);

	ACS_Chironex_On_Take_Damage(action);

	ACS_Weaponized_Rabbit_On_Take_Damage(action);

	ACS_She_Who_Knows_On_Take_Damage(action);

	ACS_Wild_Hunt_Bosses_On_Take_Damage(action);

	ACS_Fire_Bear_On_Take_Damage(action);

	ACS_Ice_Titan_On_Take_Damage(action);

	ACS_Knightmare_On_Take_Damage(action);

	ACS_Unseen_Blade_On_Take_Damage(action);

	ACS_Big_Lizard_On_Take_Damage(action);

	ACS_Rat_Mage_On_Take_Damage(action);

	ACS_Canaris_On_Take_Damage(action);

	ACS_NightStalker_On_Take_Damage(action);

	ACS_Fire_Gargoyle_On_Take_Damage(action);

	ACS_Lynx_Witcher_On_Take_Damage(action);

	ACS_Elderblood_Assassin_On_Take_Damage(action);

	ACS_Elderblood_Assassin_Clone_On_Take_Damage(action);

	ACS_XenoTyrant_On_Take_Damage(action);

	ACS_XenoSoldier_On_Take_Damage(action);

	ACS_XenoArmoredWorker_On_Take_Damage(action);

	ACS_Wolf_On_Take_Damage(action);

	ACS_Bruxa_On_Take_Damage(action);

	ACS_ShadowWolf_On_Take_Damage(action);

	ACS_Fluffy_On_Take_Damage(action);

	ACS_Botchling_On_Take_Damage(action);

	ACS_Mula_On_Take_Damage(action);

	ACS_Fog_Assassin_On_Take_Damage(action);

	ACS_Ice_Boar_On_Take_Damage(action);

	ACS_Siren_Base_On_Take_Damage(action);

	ACS_Melusine_On_Take_Damage(action);

	ACS_Melusine_Original_On_Take_Damage(action);

	ACS_Melusine_Cloud_On_Take_Damage(action);

	ACS_Melusine_Bossbar_On_Take_Damage(action);

	ACS_Cultist_Boss_On_Take_Damage(action);

	ACS_Cultist_On_Take_Damage(action);

	ACS_Cultist_Singer_On_Take_Damage(action);

	ACS_Pirate_Zombie_On_Take_Damage(action);

	ACS_Shades_Crusader_On_Take_Damage(action);

	ACS_Shades_Hunter_On_Take_Damage(action);

	ACS_Shades_Rogue_On_Take_Damage(action);

	ACS_Shades_Rogue_Enemies_On_Take_Damage(action);

	ACS_Cursed_Werewolf_On_Take_Damage(action);

	ACS_Red_Miasmal_Boss_On_Take_Damage(action);

	ACS_Forest_God_Shadow_On_Take_Damage(action);

	ACS_Nimean_Panther_On_Take_Damage(action);

	ACS_Svalblod_On_Take_Damage(action);

	ACS_Svalblod_Bear_On_Take_Damage(action);

	ACS_Svalblod_Bossbar_On_Take_Damage(action);

	ACS_Berserker_Human_On_Take_Damage(action);

	ACS_Berserker_Bear_On_Take_Damage(action);

	ACS_Wildhunt_Warriors_On_Take_Damage(action);

	ACS_Duskwraith_On_Take_Damage(action);

	ACS_Duskwraith_Adds_On_Take_Damage(action);

	ACS_Incubus_On_Take_Damage(action);

	ACS_Mage_On_Take_Damage(action);

	ACS_Draug_On_Take_Damage(action);

	ACS_Draugir_On_Take_Damage(action);

	ACS_MegaWraith_On_Take_Damage(action);

	ACS_Fire_Gryphon_On_Take_Damage(action);

	ACS_Big_Hym_On_Take_Damage(action);

	ACS_Mini_Hym_On_Take_Damage(action);

	ACS_Guardian_Hym_On_Take_Damage(action);

	ACS_Necrofiend_On_Take_Damage(action);

	ACS_Bumbakvetch_On_Take_Damage(action);

	ACS_Viy_On_Take_Damage(action);

	ACS_VampireMonsterBossbar_On_Take_Damage(action);

	ACS_Giant_Troll_On_Take_Damage(action);

	ACS_Elemental_Titan_On_Take_Damage(action);

	ACS_Hellhound_On_Take_Damage(action);

	ACS_Dark_Knight_On_Take_Damage(action);

	ACS_Dark_Knight_Calidus_On_Take_Damage(action);

	ACS_Carduin_On_Take_Damage(action);

	ACS_Dao_On_Take_Damage(action);

	ACS_Dao_Turret_On_Take_Damage(action);

	ACS_Knocker_On_Take_Damage(action);

	ACS_Vendigo_On_Take_Damage(action);

	ACS_Swarm_Mother_On_Take_Damage(action);

	ACS_Maerolorn_On_Take_Damage(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Ghoul_Base_On_Take_Damage(action);

	ACS_Red_Blood_Death_On_Take_Damage(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Add_Weapon_On_Take_Damage(action);


	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Enemy_On_Take_Damage_General(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Forest_God_Attack(action);

	ACS_Forest_God_Shadows_Attack(action);

    ACS_Ice_Titan_Attack(action);

	ACS_Fire_Bear_Attack(action);

	ACS_Fire_Gargoyle_Attack(action);

	ACS_Vendigo_Attack(action);

	ACS_Knightmare_Attack(action);

	ACS_Eredin_Attack(action);

	ACS_Canaris_Attack(action);

	ACS_NightStalker_Attack(action);

	ACS_XenoTyrant_Attack(action);

	ACS_XenoSoldier_Attack(action);

	ACS_XenoWorker_Attack(action);

	ACS_XenoArmoredWorker_Attack(action);

	ACS_Unseen_Monster_Attack(action);

	ACS_Big_Lizard_Attack(action);

	ACS_Lynx_Witcher_Attack(action);

	ACS_Fluffy_Attack(action);

	ACS_Melusine_Attack(action);

	ACS_Melusine_Cloud_Attack(action);

	ACS_Pirate_Zombie_Attack(action);

	ACS_Svalblod_Bear_Attack(action);

	ACS_Berserkers_Bear_Attack(action);

	ACS_Svalblod_Attack(action);

	ACS_Incubus_Attack(action);

	ACS_Draug_Attack(action);

	ACS_Fire_Gryphon_Attack(action);

	ACS_MegaWraith_Attack(action);

	ACS_MegaWraithMinion_Attack(action);

	ACS_Big_Hym_Attack(action);

	ACS_Mini_Hym_Attack(action);

	ACS_Guardian_Hym_Attack(action);

	ACS_Knocker_Attack(action);

	ACS_Bumbakvetch_Attack(action);

	ACS_Viy_Attack(action);

	ACS_Plumard_Attack(action);

	ACS_Demonic_Construct_Attack(action);

	ACS_Shades_Rogue_Attack(action);

	ACS_Dark_Knight_Calidus_Attack(action);

	ACS_Vanilla_Vampires_Attack(action);

	ACS_Carduin_Attack(action);

	ACS_Chironex_Attack(action);

	ACS_Botchling_Attack(action);

	ACS_Draugir_Attack(action);

	//ACS_Infected_Prime_Attack(action);

	//ACS_Infected_Spawn_Attack(action);



	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Summoned_Construct_Attack(action);

	ACS_Wolf_Companion_Attack(action);

	ACS_SummonedCreatures_Attack(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	ACS_Rage_Attack(action);

	ACS_NPC_Normal_Attack(action);

	ACS_Take_Damage(action);

	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) 
	|| GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) 
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

	if (
	(CPlayer)action.victim 
	&& action.GetBuffSourceName() != "FallingDamage"
	&& action.GetBuffSourceName() != "ACS_Debug"
	&& action.GetBuffSourceName() != "Debug"
	&& action.GetBuffSourceName() != "Quest"
	&& (GetWitcherPlayer().GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
	) 
	{
		if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) 
		|| GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) 
		|| !GetWitcherPlayer().CanUseSkill(S_Sword_s01)
		)
		{
			if (((CNewNPC)action.attacker).GetNPCType() == ENGT_Guard)
			{
				if (FactsQuerySum("ACS_Enter_Unconscious_Start") <= 0)
				{
					if (ACS_Transformation_Werewolf_Check())
					{
						GetACSWatcher().DisableWerewolf();
					}

					if (ACS_Transformation_Vampiress_Check())
					{
						GetACSWatcher().DisableVampiress();
					}

					if (ACS_Transformation_Vampire_Monster_Check())
					{
						GetACSWatcher().DisableTransformationVampireMonster();
					}

					if (ACS_Transformation_Toad_Check())
					{
						GetACSWatcher().DisableTransformationToad();
					}

					if (ACS_Transformation_Red_Miasmal_Check())
					{
						GetACSWatcher().DisableRedMiasmal_Actual();
					}

					if (ACS_Transformation_Sharley_Check())
					{
						GetACSWatcher().DisableSharley_Actual();
					}

					if (ACS_Transformation_Black_Wolf_Check())
					{
						GetACSWatcher().DisableBlackWolf_Actual();
					}

					ACS_Guards_Tutorial();

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
					
					GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

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
						if (thePlayer.HasTag('vampire_claws_equipped'))
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

					GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

					GetWitcherPlayer().SetCanPlayHitAnim(false);

					GetWitcherPlayer().AddBuffImmunity_AllNegative('god', true);

					GetACSWatcher().ChangeInteractionPriority();

					ACS_GuardCheer();

					GetACSWatcher().RemoveTimer('Gerry_Unconscious_State');

					GetACSWatcher().AddTimer('Gerry_Unconscious_State', 1, false);

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
				}
			}
			else
			{
				if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) 
				|| GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) 
				|| !GetWitcherPlayer().CanUseSkill(S_Sword_s01)
				)
				{
					if(!GetWitcherPlayer().HasTag('ACS_Enter_Death_Scene_Start') 
					&& !ACS_New_Replacers_Female_Active()
					&& !GetWitcherPlayer().IsInFistFightMiniGame()
					&& !((CActor)action.attacker).HasTag('dandelion')
					&& !StrContains( ((CActor)action.attacker).GetReadableName(), "quests\main_npcs\dandelion.w2ent" )
					)
					{
						ACS_ThingsThatShouldBeRemoved();

						if (ACS_Transformation_Werewolf_Check())
						{
							GetACSWatcher().DisableWerewolf_Actual();
						}

						if (ACS_Transformation_Vampiress_Check())
						{
							GetACSWatcher().DisableVampiress_Actual();
						}

						if (ACS_Transformation_Vampire_Monster_Check())
						{
							GetACSWatcher().DisableTransformationVampireMonster_Actual_No_Teleport();
						}

						if (ACS_Transformation_Toad_Check())
						{
							GetACSWatcher().DisableTransformationToad_Actual();
						}

						if (ACS_Transformation_Red_Miasmal_Check())
						{
							GetACSWatcher().DisableRedMiasmal_Actual();
						}

						if (ACS_Transformation_Sharley_Check())
						{
							GetACSWatcher().DisableSharley_Actual();
						}

						if (ACS_Transformation_Black_Wolf_Check())
						{
							GetACSWatcher().DisableBlackWolf_Actual();
						}

						GetWitcherPlayer().EnableCharacterCollisions(true); 

						GetWitcherPlayer().EnableCollisions(true);

						GetWitcherPlayer().SetIsCurrentlyDodging(false);

						if (GetWitcherPlayer().GetStat( BCS_Focus ) != 0)
						{
							GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
						}

						if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
						{
							GetACSWatcher().Grow_Geralt_Immediate_Fast();

							GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
						}

						GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

						GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

						GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

						GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

						GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');

						if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
						&& !GetWitcherPlayer().IsPerformingFinisher())
						{
							ACS_Hit_Animations(action);
						}

						GetWitcherPlayer().DestroyEffect('blood');
						GetWitcherPlayer().DestroyEffect('death_blood');
						GetWitcherPlayer().DestroyEffect('heavy_hit');
						GetWitcherPlayer().DestroyEffect('light_hit');
						GetWitcherPlayer().DestroyEffect('blood_spill');
						GetWitcherPlayer().DestroyEffect('fistfight_heavy_hit');
						GetWitcherPlayer().DestroyEffect('heavy_hit_horseriding');
						GetWitcherPlayer().DestroyEffect('fistfight_hit');
						GetWitcherPlayer().DestroyEffect('critical hit');
						GetWitcherPlayer().DestroyEffect('death_hit');
						GetWitcherPlayer().DestroyEffect('blood_throat_cut');
						GetWitcherPlayer().DestroyEffect('hit_back');
						GetWitcherPlayer().DestroyEffect('standard_hit');
						GetWitcherPlayer().DestroyEffect('critical_bleeding'); 
						GetWitcherPlayer().DestroyEffect('fistfight_hit_back'); 
						GetWitcherPlayer().DestroyEffect('heavy_hit_back'); 
						GetWitcherPlayer().DestroyEffect('light_hit_back'); 

						GetWitcherPlayer().PlayEffectSingle('blood');
						GetWitcherPlayer().PlayEffectSingle('death_blood');
						GetWitcherPlayer().PlayEffectSingle('heavy_hit');
						GetWitcherPlayer().PlayEffectSingle('light_hit');
						GetWitcherPlayer().PlayEffectSingle('blood_spill');
						GetWitcherPlayer().PlayEffectSingle('fistfight_heavy_hit');
						GetWitcherPlayer().PlayEffectSingle('heavy_hit_horseriding');
						GetWitcherPlayer().PlayEffectSingle('fistfight_hit');
						GetWitcherPlayer().PlayEffectSingle('critical hit');
						GetWitcherPlayer().PlayEffectSingle('death_hit');
						GetWitcherPlayer().PlayEffectSingle('blood_throat_cut');
						GetWitcherPlayer().PlayEffectSingle('hit_back');
						GetWitcherPlayer().PlayEffectSingle('standard_hit');
						GetWitcherPlayer().PlayEffectSingle('critical_bleeding'); 
						GetWitcherPlayer().PlayEffectSingle('fistfight_hit_back'); 
						GetWitcherPlayer().PlayEffectSingle('heavy_hit_back'); 
						GetWitcherPlayer().PlayEffectSingle('light_hit_back'); 

						GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Death', true); 

						GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Death', true); 

						GetWitcherPlayer().AddBuffImmunity(EET_Poison , 'ACS_Death', true);

						GetWitcherPlayer().AddBuffImmunity(EET_PoisonCritical , 'ACS_Death', true);

						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

						GetWitcherPlayer().DrainVitality( GetWitcherPlayer().GetStat( BCS_Vitality ) * 0.99 );

						GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );

						if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control')){GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');} 
			
						GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

						GetACSWatcher().RemoveTimer('Gerry_Death_Scene');

						GetACSWatcher().AddTimer('Gerry_Death_Scene', 0.5, false);

						if (((CActor)action.attacker).HasTag('ACS_Blade_Of_The_Unseen'))
						{
							thePlayer.AddTag('ACS_Killed_By_Blade_Of_The_Unseen');
						}
						else
						{
							thePlayer.RemoveTag('ACS_Killed_By_Blade_Of_The_Unseen');
						}

						((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePoseFadeOut(0.1);

						((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePose();
						
						GetWitcherPlayer().AddTag('ACS_Enter_Death_Scene_Start');
					}
				}
			}
		}
		else
		{
			ACS_ThingsThatShouldBeRemoved();

			if (ACS_Transformation_Werewolf_Check())
			{
				GetACSWatcher().DisableWerewolf_Actual();
			}

			if (ACS_Transformation_Vampiress_Check())
			{
				GetACSWatcher().DisableVampiress_Actual();
			}

			if (ACS_Transformation_Vampire_Monster_Check())
			{
				GetACSWatcher().DisableTransformationVampireMonster_Actual_No_Teleport();
			}

			if (ACS_Transformation_Toad_Check())
			{
				GetACSWatcher().DisableTransformationToad_Actual();
			}

			if (ACS_Transformation_Red_Miasmal_Check())
			{
				GetACSWatcher().DisableRedMiasmal_Actual();
			}

			if (ACS_Transformation_Sharley_Check())
			{
				GetACSWatcher().DisableSharley_Actual();
			}

			if (ACS_Transformation_Black_Wolf_Check())
			{
				GetACSWatcher().DisableBlackWolf_Actual();
			}

			thePlayer.AddTag('ACS_Second_Life_Active');
		}
		
		return;
	}
}

function ACS_Player_Fall_Negate(action: W3DamageAction)
{
	if (
	(CPlayer)action.victim && action.GetBuffSourceName() == "FallingDamage")
	{
		//action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * ACS_Player_Fall_Damage();

		action.SetCanPlayHitParticle(false);

		action.SetProcessBuffsIfNoDamage(false);

		if (
		(GetWitcherPlayer().GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
		) 
		{
			if (GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) 
			&& !GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) 
			&& GetWitcherPlayer().CanUseSkill(S_Sword_s01)
			)
			{
				return;
			}

			if (!GetWitcherPlayer().IsMutationActive( EPMT_Mutation11 ) || GetWitcherPlayer().HasBuff( EET_Mutation11Debuff ) || !GetWitcherPlayer().CanUseSkill(S_Sword_s01))
			{
				if(!GetWitcherPlayer().HasTag('ACS_Enter_Death_Scene_Start') 
				&& !ACS_New_Replacers_Female_Active()
				&& !GetWitcherPlayer().IsInFistFightMiniGame()
				&& !((CActor)action.attacker).HasTag('dandelion')
				&& !StrContains( ((CActor)action.attacker).GetReadableName(), "quests\main_npcs\dandelion.w2ent" )
				)
				{
					ACS_ThingsThatShouldBeRemoved();

					GetWitcherPlayer().EnableCharacterCollisions(true); 

					GetWitcherPlayer().EnableCollisions(true);

					GetWitcherPlayer().SetIsCurrentlyDodging(false);

					if (ACS_Transformation_Werewolf_Check())
					{
						GetACSWatcher().DisableWerewolf_Actual();
					}

					if (ACS_Transformation_Vampiress_Check())
					{
						GetACSWatcher().DisableVampiress_Actual();
					}

					if (ACS_Transformation_Vampire_Monster_Check())
					{
						GetACSWatcher().DisableTransformationVampireMonster_Actual_No_Teleport();
					}

					if (ACS_Transformation_Toad_Check())
					{
						GetACSWatcher().DisableTransformationToad_Actual();
					}

					if (ACS_Transformation_Red_Miasmal_Check())
					{
						GetACSWatcher().DisableRedMiasmal_Actual();
					}

					if (ACS_Transformation_Sharley_Check())
					{
						GetACSWatcher().DisableSharley_Actual();
					}

					if (ACS_Transformation_Black_Wolf_Check())
					{
						GetACSWatcher().DisableBlackWolf_Actual();
					}

					if (GetWitcherPlayer().GetStat( BCS_Focus ) != 0)
					{
						GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) );
					}

					if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
					{
						GetACSWatcher().Grow_Geralt_Immediate_Fast();

						GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
					}

					GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

					GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

					GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

					GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation');

					GetACSWatcher().RemoveTimer('ACS_ResetAnimation_On_Death');

					if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
					&& !GetWitcherPlayer().IsPerformingFinisher())
					{
						ACS_Hit_Animations(action);
					}

					GetWitcherPlayer().StopEffect('blood');
					GetWitcherPlayer().StopEffect('death_blood');
					GetWitcherPlayer().StopEffect('heavy_hit');
					GetWitcherPlayer().StopEffect('light_hit');
					GetWitcherPlayer().StopEffect('blood_spill');
					GetWitcherPlayer().StopEffect('fistfight_heavy_hit');
					GetWitcherPlayer().StopEffect('heavy_hit_horseriding');
					GetWitcherPlayer().StopEffect('fistfight_hit');
					GetWitcherPlayer().StopEffect('critical hit');
					GetWitcherPlayer().StopEffect('death_hit');
					GetWitcherPlayer().StopEffect('blood_throat_cut');
					GetWitcherPlayer().StopEffect('hit_back');
					GetWitcherPlayer().StopEffect('standard_hit');
					GetWitcherPlayer().StopEffect('critical_bleeding'); 
					GetWitcherPlayer().StopEffect('fistfight_hit_back'); 
					GetWitcherPlayer().StopEffect('heavy_hit_back'); 
					GetWitcherPlayer().StopEffect('light_hit_back'); 

					GetWitcherPlayer().PlayEffectSingle('blood');
					GetWitcherPlayer().PlayEffectSingle('death_blood');
					GetWitcherPlayer().PlayEffectSingle('heavy_hit');
					GetWitcherPlayer().PlayEffectSingle('light_hit');
					GetWitcherPlayer().PlayEffectSingle('blood_spill');
					GetWitcherPlayer().PlayEffectSingle('fistfight_heavy_hit');
					GetWitcherPlayer().PlayEffectSingle('heavy_hit_horseriding');
					GetWitcherPlayer().PlayEffectSingle('fistfight_hit');
					GetWitcherPlayer().PlayEffectSingle('critical hit');
					GetWitcherPlayer().PlayEffectSingle('death_hit');
					GetWitcherPlayer().PlayEffectSingle('blood_throat_cut');
					GetWitcherPlayer().PlayEffectSingle('hit_back');
					GetWitcherPlayer().PlayEffectSingle('standard_hit');
					GetWitcherPlayer().PlayEffectSingle('critical_bleeding'); 
					GetWitcherPlayer().PlayEffectSingle('fistfight_hit_back'); 
					GetWitcherPlayer().PlayEffectSingle('heavy_hit_back'); 
					GetWitcherPlayer().PlayEffectSingle('light_hit_back'); 

					GetWitcherPlayer().AddBuffImmunity_AllNegative('ACS_Death', true); 

					GetWitcherPlayer().AddBuffImmunity_AllCritical('ACS_Death', true); 

					GetWitcherPlayer().AddBuffImmunity(EET_Poison , 'ACS_Death', true);

					GetWitcherPlayer().AddBuffImmunity(EET_PoisonCritical , 'ACS_Death', true);

					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

					GetWitcherPlayer().DrainVitality( GetWitcherPlayer().GetStat( BCS_Vitality ) * 0.99 );

					GetWitcherPlayer().SetImmortalityMode( AIM_Invulnerable, AIC_Default, true );
					GetWitcherPlayer().SetCanPlayHitAnim(false);
					GetWitcherPlayer().AddBuffImmunity_AllNegative('god', true);

					if(GetWitcherPlayer().HasTag('ACS_Manual_Combat_Control')){GetWitcherPlayer().RemoveTag('ACS_Manual_Combat_Control');} 

					((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePoseFadeOut(0.1);

					((CAnimatedComponent)thePlayer.GetComponentByClassName('CAnimatedComponent')).UnfreezePose();

					GetACSWatcher().RemoveTimer('Manual_Combat_Control_Remove');

					GetACSWatcher().RemoveTimer('Gerry_Death_Scene');

					GetACSWatcher().AddTimer('Gerry_Death_Scene', 0.5, false);

					GetWitcherPlayer().AddTag('ACS_Enter_Death_Scene_Start');
				}
			}
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

			if (GetWitcherPlayer().IsOnGround())
			{
				GetWitcherPlayer().PlayEffectSingle('red_quen_lasting_shield_hit');

				GetWitcherPlayer().StopEffect('red_quen_lasting_shield_hit');

				GetWitcherPlayer().PlayEffectSingle('red_lasting_shield_discharge');

				GetWitcherPlayer().StopEffect('red_lasting_shield_discharge');

				ACS_Fall_Aard_Trigger();
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

			if (!npc.HasBuff(EET_HeavyKnockdown))
			{
				npc.AddEffectDefault( EET_HeavyKnockdown, GetWitcherPlayer(), 'ACS_Fall_Shockwave' );
			}

			if (!npc.HasBuff(EET_Stagger))
			{
				npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Fall_Shockwave' );
			}
		}
	}

	rot = GetWitcherPlayer().GetWorldRotation();

	pos = GetWitcherPlayer().GetWorldPosition();

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	"gameplay\templates\signs\pc_aard.w2ent"

	, true ), pos, rot );

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

	ent.PlayEffectSingle('blast_lv3');

	ent.PlayEffectSingle('blast_ground_mutation_6');

	ent.DestroyAfter(3);

	theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( thePlayer, 'CastSignAction', -1, 20.0f, -1.f, -1, true );
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
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
		&& !(((W3Action_Attack)action).IsParried())
		//&& action.DealsAnyDamage()
		)
		{
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
					
					if (ACS_GetItem_Aerondight() || ACS_GetItem_Iris())
					{
						if ( action.GetHitReactionType() == EHRT_Light )
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * 0.025;
						}
						else if ( action.GetHitReactionType() == EHRT_Heavy )
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * 0.05;
						}

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_steel, GetWitcherPlayer().GetInventory().GetItemMaxDurability(item_steel) );
					}
					else
					{
						action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.025, 0);
					}
				}
				else if (npc.UsesVitality())
				{
					if (ACS_GetItem_Aerondight() || ACS_GetItem_Iris())
					{
						if ( action.GetHitReactionType() == EHRT_Light )
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.025;
						}
						else if ( action.GetHitReactionType() == EHRT_Heavy )
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.05;
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

					if (ACS_GetItem_Aerondight() || ACS_GetItem_Iris())
					{
						if ( action.GetHitReactionType() == EHRT_Light )
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.025;
						}
						else if ( action.GetHitReactionType() == EHRT_Heavy )
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Vitality) - npc.GetStat( BCS_Vitality ) ) * 0.05;
						}

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, GetWitcherPlayer().GetInventory().GetItemMaxDurability(item_silver) );
					}
					else
					{
						action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.025, 0);

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) * 0.025)) );
					}
				}
				else if (npc.UsesEssence())
				{
					if (ACS_GetItem_Aerondight() || ACS_GetItem_Iris())
					{
						if ( action.GetHitReactionType() == EHRT_Light )
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * 0.025;
						}
						else if ( action.GetHitReactionType() == EHRT_Heavy )
						{
							action.processedDmg.essenceDamage += ( npc.GetStatMax(BCS_Essence) - npc.GetStat( BCS_Essence ) ) * 0.05;
						}

						GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, GetWitcherPlayer().GetInventory().GetItemMaxDurability(item_silver) );
					}
				}
			}	
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

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(playerAttacker && npc)
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			ACS_Caretaker_Drain_Energy();

			if (action.DealsAnyDamage())
			{
				if ( !GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') && !GetWitcherPlayer().HasTag('ACS_Sparagmos_Active') )
				{
					theGame.GetMonsterParamsForActor(npc, mc, tmpName, tmpBool, tmpBool, tmpBool);

					if( ((CNewNPC)npc).GetBloodType() == BT_Red) 
					{
						if (npc.HasAbility('mon_lessog_base')
						|| npc.HasAbility('mon_sprigan_base')
						)
						{						
							GetACSWatcher().black_weapon_blood_fx();
						} 
						else 
						{
							GetACSWatcher().weapon_blood_fx();
						}
					}
					else if( ((CNewNPC)npc).GetBloodType() == BT_Green) 
					{
						if (npc.HasAbility('mon_kikimore_base')
						|| npc.HasAbility('mon_black_spider_base')
						|| npc.HasAbility('mon_black_spider_ep2_base')
						)
						{						
							GetACSWatcher().black_weapon_blood_fx();
						} 
						else 
						{
							GetACSWatcher().green_weapon_blood_fx();
						}
					}
					else if( ((CNewNPC)npc).GetBloodType() == BT_Yellow) 
					{
						if (npc.HasAbility('mon_archespor_base'))
						{
							GetACSWatcher().yellow_weapon_blood_fx();
						} 
						else 
						{
							GetACSWatcher().weapon_blood_fx();
						}
					}
					else if	( ((CNewNPC)npc).GetBloodType() == BT_Black) 
					{
						if ( mc == MC_Vampire ) 
						{
							GetACSWatcher().weapon_blood_fx();
						}
						else if ( mc == MC_Magicals ) 
						{
							if (npc.HasAbility('mon_golem_base')
							|| npc.HasAbility('mon_djinn')
							|| npc.HasAbility('mon_gargoyle')
							)
							{
								GetACSWatcher().black_weapon_blood_fx();
							}
							else
							{
								GetACSWatcher().weapon_blood_fx();
							}
						}
						else
						{
							GetACSWatcher().black_weapon_blood_fx();
						}
					}
					else
					{
						GetACSWatcher().weapon_blood_fx();
					}

					npc.PlayEffectSingle('blood');
					npc.StopEffect('blood');

					npc.PlayEffectSingle('death_blood');
					npc.StopEffect('death_blood');	

					npc.PlayEffectSingle('blood_spill');
					npc.StopEffect('blood_spill');

					acs_npc_blood_fx.Clear();
					
					acs_npc_blood_fx.PushBack('light_hit');
					acs_npc_blood_fx.PushBack('heavy_hit');
					acs_npc_blood_fx.PushBack('fistfight_heavy_hit');
					acs_npc_blood_fx.PushBack('heavy_hit_horseriding');
					acs_npc_blood_fx.PushBack('fistfight_hit');
					acs_npc_blood_fx.PushBack('critical hit');
					acs_npc_blood_fx.PushBack('death_hit');
					acs_npc_blood_fx.PushBack('blood_throat_cut');
					acs_npc_blood_fx.PushBack('hit_back');
					acs_npc_blood_fx.PushBack('standard_hit');
					acs_npc_blood_fx.PushBack('critical_bleeding'); 
					acs_npc_blood_fx.PushBack('fistfight_hit_back'); 
					acs_npc_blood_fx.PushBack('heavy_hit_back'); 
					acs_npc_blood_fx.PushBack('light_hit_back'); 
					
					npc.PlayEffectSingle(acs_npc_blood_fx[RandRange(acs_npc_blood_fx.Size())]);

					npc.StopEffect('light_hit');
					npc.StopEffect('heavy_hit');
					npc.StopEffect('light_hit_back');
					npc.StopEffect('heavy_hit_back');
					npc.StopEffect('fistfight_heavy_hit');
					npc.StopEffect('heavy_hit_horseriding');
					npc.StopEffect('fistfight_hit');
					npc.StopEffect('critical hit');
					npc.StopEffect('death_hit');
					npc.StopEffect('blood_throat_cut');
					npc.StopEffect('hit_back');
					npc.StopEffect('standard_hit');
					npc.StopEffect('critical_bleeding');
					npc.StopEffect('fistfight_hit_back');
				}

				if ( action.GetHitReactionType() == EHRT_Light )
				{
					//ACS_Light_Attack_Trail();

					if (GetWitcherPlayer().IsDeadlySwordHeld())
					{
						if ( GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') )
						{
							GetWitcherPlayer().SoundEvent("magic_man_sand_gust");
						}
						else
						{
							npc.SoundEvent("cmb_play_hit_light");
							GetWitcherPlayer().SoundEvent("cmb_play_hit_light");
						}
					}
				}
				else if ( action.GetHitReactionType() == EHRT_Heavy )
				{
					//ACS_Heavy_Attack_Trail();
					
					if (GetWitcherPlayer().IsDeadlySwordHeld())
					{
						if ( GetWitcherPlayer().HasTag('ACS_Storm_Spear_Active') )
						{
							GetWitcherPlayer().SoundEvent("magic_man_sand_gust");
						}
						else
						{
							npc.SoundEvent("cmb_play_hit_heavy");
							GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");
						}
					}
				}
			}
			
			if ( action.HasAnyCriticalEffect() 
			|| action.GetIsHeadShot() 
			|| action.HasForceExplosionDismemberment()
			|| action.IsCriticalHit() )
			{
				ACS_Wraith_Attack_Trail();
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

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if (npc)
	{
		if 
		(playerAttacker)
		{
			if (ACS_Player_Damage_Multiplier() != 1)
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage *= ACS_Player_Damage_Multiplier();
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage *= ACS_Player_Damage_Multiplier();
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
			}

			if(ACS_GetItem_MageStaff() && action.IsActionMelee())
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

			ACS_Record_Kill(action);

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if (ACS_Transformation_Red_Miasmal_Check())
				{
					if (!npc.HasTag('ACS_Red_Miasmal_Ability_Spawn_From_Player'))
					{
						ACS_Red_Miasmal_Ability_Spawn(npc.GetWorldPosition());

						npc.AddTag('ACS_Red_Miasmal_Ability_Spawn_From_Player');
					}
				}
			}

			if ( !action.IsDoTDamage() 
			&& !action.IsActionMelee()
			&& thePlayer.IsCrossbowHeld()
			&& !action.IsActionWitcherSign()
			)
			{
				if (ACS_CrossbowDamageMaxHealthOrCurrentHealth() == 0)
				{
					if (npc.UsesVitality())
					{
						if (ACS_Crossbow_Human_Min_Damage() > 0 || ACS_Crossbow_Human_Max_Damage() > 0)
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

							action.processedDmg.vitalityDamage += npc.GetMaxHealth() * RandRangeF(ACS_Crossbow_Human_Max_Damage(), ACS_Crossbow_Human_Min_Damage());
						}
					}
					else if (npc.UsesEssence())
					{
						if (ACS_Crossbow_Monster_Min_Damage() > 0 || ACS_Crossbow_Monster_Max_Damage() > 0)
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

							if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| npc.GetRadius() >= 0.7
							)
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * RandRangeF(ACS_Crossbow_Monster_Max_Damage()/2, ACS_Crossbow_Monster_Min_Damage()/2);
							}
							else
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * RandRangeF(ACS_Crossbow_Monster_Max_Damage(), ACS_Crossbow_Monster_Min_Damage());
							}
						}
					}
				}
				else if (ACS_CrossbowDamageMaxHealthOrCurrentHealth() == 1)
				{
					if (npc.UsesVitality())
					{
						if (ACS_Crossbow_Human_Min_Damage() > 0 || ACS_Crossbow_Human_Max_Damage() > 0)
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

							action.processedDmg.vitalityDamage += npc.GetCurrentHealth() * RandRangeF(ACS_Crossbow_Human_Max_Damage(), ACS_Crossbow_Human_Min_Damage());
						}
					}
					else if (npc.UsesEssence())
					{
						if (ACS_Crossbow_Monster_Min_Damage() > 0 || ACS_Crossbow_Monster_Max_Damage() > 0)
						{
							action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

							if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| npc.GetRadius() >= 0.7
							)
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * RandRangeF(ACS_Crossbow_Monster_Max_Damage()/2, ACS_Crossbow_Monster_Min_Damage()/2);
							}
							else
							{
								action.processedDmg.essenceDamage += npc.GetMaxHealth() * RandRangeF(ACS_Crossbow_Monster_Max_Damage(), ACS_Crossbow_Monster_Min_Damage());
							}
						}
					}
				}

				if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( GetWitcherPlayer() ))
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  

					if (
					npc.GetStat(BCS_Stamina) != npc.GetStatMax( BCS_Stamina ) 
					&& npc.GetBehaviorGraphInstanceName() != 'Shield'
					)	
					{
						if (
						(ACS_W3EE_Installed() && ACS_W3EE_Enabled() )
						||
						(ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled() )
						)
						{
							npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.05 );
						}
						else
						{
							npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.25 );
						}
					}	
				}

				return;
			}

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
				||
				(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
				{
					if (thePlayer.IsWeaponHeld('fist') && !thePlayer.HasTag('vampire_claws_equipped') )
					{
						
					}
					else
					{
						GetACSWatcher().Blood_Spatter_Switch();
					}

					if (ACS_GetItem_AllBlack_Equipped_Held())
					{
						if (!npc.HasTag('ACS_AllBlack_Ability_Spawn_From_Player'))
						{
							ACS_AllBlack_Ability_Spawn(npc.GetWorldPosition());

							npc.AddTag('ACS_AllBlack_Ability_Spawn_From_Player');
						}
					}
				}
				else
				{
					ACS_Sign_Combo_System(action);

					if(action.DealsAnyDamage())
					{
						GetACSWatcher().NPC_BloodCovered_Effect(action);

						if (thePlayer.IsWeaponHeld('fist') && !thePlayer.HasTag('vampire_claws_equipped') )
						{

						}
						else
						{
							if (RandF() < 0.5)
							{
								GetACSWatcher().Blood_Spatter_Switch();
							}
						}
					}

					if (action.GetHitReactionType() != EHRT_Reflect)
					{
						if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( GetWitcherPlayer() ))
						{
							npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0.05 );  

							npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0.05 );  

							if (
							(ACS_W3EE_Installed() && ACS_W3EE_Enabled() )
							||
							(ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled() )
							)
							{
								npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.05 );
							}
							else
							{
								npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.25 );
							}
						}
						else
						{
							npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

							npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
								
							npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.5 );
						}
					}
				}
			}
			else if ( action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !action.IsDoTDamage() )
			{
				if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( GetWitcherPlayer() ))
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  

					npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );  	
				}
				else
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					if (npc.GetStat(BCS_Stamina) != npc.GetStatMax( BCS_Stamina ))	
					{
						npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.5 );
					}
				}
			}
			else if ( ((W3Action_Attack)action).IsParried() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !action.IsDoTDamage() )
			{
				if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( GetWitcherPlayer() ))
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  

					if (
					npc.GetStat(BCS_Stamina) != npc.GetStatMax( BCS_Stamina ) 
					&& npc.GetBehaviorGraphInstanceName() != 'Shield'
					)	
					{
						if (
						(ACS_W3EE_Installed() && ACS_W3EE_Enabled() )
						||
						(ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled() )
						)
						{
							npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.05 );
						}
						else
						{
							npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.25 );
						}
					}	
				}
				else
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					if (npc.GetStat(BCS_Stamina) != npc.GetStatMax( BCS_Stamina ))	
					{
						npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.5 );
					}
				}
			}
			else
			{
				if (npc.IsHuman() && !((CNewNPC)npc).IsShielded( GetWitcherPlayer() ))
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  

					if (
					npc.GetStat(BCS_Stamina) != npc.GetStatMax( BCS_Stamina ) 
					&& npc.GetBehaviorGraphInstanceName() != 'Shield'
					)	
					{
						if (
						(ACS_W3EE_Installed() && ACS_W3EE_Enabled() )
						||
						(ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled() )
						)
						{
							npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.05 );
						}
						else
						{
							npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.25 );
						}
					}	
				}
				else
				{
					npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

					npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
						
					if (npc.GetStat(BCS_Stamina) != npc.GetStatMax( BCS_Stamina ))	
					{
						npc.GainStat( BCS_Stamina, npc.GetStat( BCS_Stamina ) * 0.5 );
					}
				}
			}
		}
		else
		{
			if ((thePlayer.GetAttitude( npc ) == AIA_Friendly 
			|| theGame.GetGlobalAttitude( npc.GetBaseAttitudeGroup(), 'player' ) == AIA_Friendly)
			&& !playerVictim)
			{
				if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.99;
				}
				else if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.99;
				}
			}

			if (npc.HasTag('acs_was_dismembered'))
			{
				npc.SetCanPlayHitAnim(false);

				((CNewNPC)npc).SetUnstoppable( true );

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
	}
}


function ACS_Sign_Combo_System(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var ent 																														: CEntity;
	var attach_rot                        																							: EulerAngles;
	var attach_vec																													: Vector;
   
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if ( !ACS_SignComboSystem_Enabled() )
	{
		return;
	}

	if ( ACS_Transformation_Activated_Check() )
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

	GetACSWatcher().RemoveTimer('RemoveSignComboStuffRepeating');
	GetACSWatcher().RemoveTimer('RemoveSignComboStuff');
	GetACSWatcher().AddTimer('RemoveSignComboStuff', 10, false);

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
		//ACSSignComboIconDestroyAll();

		//ACSSignComboSystemRemoveTags();

		ACS_Sign_Combo_System_Tutorial();

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\sign_icons.w2ent"

		, true ), npc.GetWorldPosition(), npc.GetWorldRotation() );

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

		ent.CreateAttachment( npc, , attach_vec, EulerAngles(0,0,0) );

		if (RandF() < 0.5)
		{
			ent.PlayEffectSingle('igni_icon_small');

			ent.AddTag('ACS_Sign_Combo_Igni_Symbol_Active');

			npc.AddTag('ACS_Sign_Combo_Igni_Ready');
		}
		else
		{
			ent.PlayEffectSingle('aard_icon_small');

			ent.AddTag('ACS_Sign_Combo_Aard_Symbol_Active');

			npc.AddTag('ACS_Sign_Combo_Aard_Ready');
		}

		ent.AddTag('ACS_Sign_Combo_Icon');
	}
	else
	{
		return;
	}
}

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

function ACSSignComboIconCheck()
{	
	var ents 											: array<CEntity>;
	var i												: int;

	var actors_igni 									: array<CActor>;
	var j												: int;

	var actors_aard 									: array<CActor>;
	var k												: int;

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
					ents[i].PlayEffect('igni_icon');
				}
				else if (ents[i].HasTag('ACS_Sign_Combo_Aard_Symbol_Active'))
				{
					ents[i].PlayEffect('aard_icon');
				}

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

function ACSSignComboIconDestroyAll()
{	
	var ents 											: array<CEntity>;
	var i												: int;
	
	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_Sign_Combo_Icon', ents );	
	
	for( i = 0; i < ents.Size(); i += 1 )
	{
		ents[i].Destroy();
	}
}

function ACSSignComboSystemRemoveTags()
{
	var actors_igni 									: array<CActor>;
	var j												: int;

	actors_igni.Clear();

	theGame.GetActorsByTag( 'ACS_Sign_Combo_Attack_1', actors_igni );	

	for( j = 0; j < actors_igni.Size(); j += 1 )
	{
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Attack_1');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Attack_2');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Igni_Ready');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Aard_Ready');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Icon_Ready_To_Activate_NPC_Igni');
		actors_igni[j].RemoveTag('ACS_Sign_Combo_Icon_Ready_To_Activate_NPC_Aard');
	}
}

function ACS_Record_Kill(action: W3DamageAction)
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
			if(!npc.HasTag('ACS_Death_Recorded'))
			{
				GetACSStorage().Killcount_Increment();

				GetACSWatcher().ACS_Persistent_Killcount();

				ACS_KillCount_Manager(npc);

				npc.AddTag('ACS_Death_Recorded');
			}
		}
	}
}

function ACS_KillCount_Manager( npc : CActor )
{
	if (npc.GetMovingAgentComponent().GetName() == "woman_base"
	|| npc.GetMovingAgentComponent().GetName() == "man_base"
	)
	{
		GetACSStorage().HumanKillcount_Increment();
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
			GetACSStorage().BeastKillcount_Increment();
		}
		else if 
		(
			npc.HasAbility('mon_lycanthrope')
			|| npc.GetSfxTag() == 'sfx_werewolf'
			|| npc.HasAbility('mon_archespor_base')
			|| npc.HasAbility('mon_q704_ft_wilk')
		)
		{
			GetACSStorage().CursedOnesKillcount_Increment();
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
			GetACSStorage().DraconidsKillcount_Increment();
		}
		else if 
		(
			npc.GetSfxTag() == 'sfx_elemental_dao' 	
			|| npc.HasAbility('mon_arachas_armored')
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
			GetACSStorage().ElementaKillcount_Increment();
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
			GetACSStorage().HybridsKillcount_Increment();
		}
		else if 
		(
			npc.HasAbility('mon_arachas_armored')
			|| npc.HasAbility('mon_poison_arachas')
			|| npc.HasAbility('mon_black_spider_base')
			|| npc.HasAbility('mon_arachas_armored')
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
			GetACSStorage().InsectoidsKillcount_Increment();
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
			GetACSStorage().NecrophagesKillcount_Increment();
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
			GetACSStorage().OgroidsKillcount_Increment();
		}
		else if 
		(
			npc.HasAbility('mon_toad_base')
			|| npc.HasAbility('q604_caretaker')
			|| npc.HasAbility('mon_czart')
			|| npc.HasAbility('sfx_bies')
			|| npc.GetSfxTag() == 'sfx_lessog'
			|| npc.HasAbility('mon_sprigan')
			|| npc.HasAbility('mon_sharley_base')
			|| npc.HasAbility('mon_fairytale_witch')
			|| npc.HasTag('witch')
		)
		{
			GetACSStorage().RelictsKillcount_Increment();
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
			GetACSStorage().SpectersKillcount_Increment();
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
			GetACSStorage().VampiresKillcount_Increment();
		}
		else 
		{
			GetACSStorage().OtherKillcount_Increment();
		}
	}
}

function ACS_Forest_God_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Forest_God'))
	{
		if ( playerAttacker )
		{
			if ( (npc.GetStat(BCS_Essence) <= npc.GetStatMax(BCS_Essence) * 0.5)
			&& !npc.HasTag('ACS_Spawn_Adds_1'))
			{
				ACS_Forest_God_Adds_1_Spawner();

				GetWitcherPlayer().DisplayHudMessage( "DID YOU THINK IT WAS THAT EASY?" );

				npc.AddTag('ACS_Spawn_Adds_1');
			}
			else if ( (npc.GetStat(BCS_Essence) <= npc.GetStatMax(BCS_Essence) * 0.25 )
			&& !npc.HasTag('ACS_Spawn_Adds_2'))
			{
				ACS_Forest_God_Adds_2_Spawner();

				GetWitcherPlayer().DisplayHudMessage( "DEATH AND DESTRUCTION TO ALL" );

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
	}
}

function ACS_Rage_Enemy_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc)
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
		&& !(((W3Action_Attack)action).IsParried())
		)
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
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.25 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				if (npc.HasTag('ACS_Swapped_To_Shield'))
				{
					npc.SoundEvent("shield_wood_impact");

					npc.SoundEvent("grunt_vo_block");
				}
			}
		}
	}
}

function ACS_Harpy_Queen_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Harpy_Queen'))
	{
		if (playerAttacker)
		{
			npc.SetCanPlayHitAnim(false);

			((CNewNPC)npc).SetUnstoppable( true );

			npc.SignalGameplayEvent('DisableFinisher');

			((CActor)npc).AddBuffImmunity(EET_Knockdown , 'ACS_Enemy_Buff', true);

			((CActor)npc).AddBuffImmunity(EET_HeavyKnockdown , 'ACS_Enemy_Buff', true);

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
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

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
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
	}
}

function ACS_Harpy_Praetorian_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Harpy_Praetorian'))
	{
		if (playerAttacker)
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
			}
		}
	}
}

function ACS_Chironex_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Chironex'))
	{
		//if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
						action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.1;
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
						action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.1;
					}
				}
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= npc.GetMaxHealth() * 0.05)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= npc.GetMaxHealth() * 0.05))
			{
				if ( !npc.HasTag('ACS_Chironex_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 15, false );

					npc.DestroyEffect('demonic_cast');

					npc.DestroyEffect('ghost');

					npc.DestroyEffect('demon_horse');

					npc.PlayEffectSingle('disappear');

					((CNewNPC)npc).SetVisibility(false);
					
					//npc.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					npc.DestroyAfter(2);

					((CActor)npc).SetInteractionPriority( IP_Prio_0 );

					((CNewNPC)npc).EnableCollisions(false);

					ACS_Chironex_Corpse_Spawn(npc, npc.GetWorldPosition());

					npc.AddTag('ACS_Chironex_Death');
				}
			}
		}
	}
}

function ACS_Weaponized_Rabbit_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_WeaponizedRabbit'))
	{
		if (playerAttacker)
		{
			if ( !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Weaponized_Rabbit_Death'))
				{
					npc.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					npc.DestroyAfter(2);

					ACS_Weaponized_Rabbit_Corpse_Spawn(npc, npc.GetWorldPosition());

					npc.AddTag('ACS_Weaponized_Rabbit_Death');
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
	}
}

function ACS_Nekker_Guardian_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Nekker_Guardian'))
	{
		//if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
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

				ticket = movementAdjustorNPC.GetRequest( 'ACS_NPC_Attacked_Rotate');
				movementAdjustorNPC.CancelByName( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.CancelAll();

				ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_NPC_Attacked_Rotate' );
				movementAdjustorNPC.AdjustmentDuration( ticket, 0.75 );
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Nekker_Guardian_End_Stage'))
				{
					ACS_Ghoul_Explode(npc, npc.GetWorldPosition());

					animatedComponentA.FreezePoseFadeIn(5);

					GetACSWatcher().CanSpawnNekkerGuardian(false);

					GetACSWatcher().AddTimer('Nekker_Guardian_Spawn_Reset', 60, false);

					npc.AddTag('ACS_Nekker_Guardian_End_Stage');
				}
			}
		}
	}
}

function ACS_Phooca_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Phooca'))
	{
		//if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
				movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 125 );

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
			}

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Phooca_End_Stage'))
				{
					ACS_Ghoul_Explode(npc, npc.GetWorldPosition());

					animatedComponentA.FreezePoseFadeIn(5);

					npc.AddTag('ACS_Phooca_End_Stage');
				}
			}
		}
	}
}

function ACS_Plumard_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	if 
	(npc && npc.HasTag('ACS_Plumard'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (ACS_IsNight())
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.2;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.2;
					}

					if (!npc.HasAbility('Flashstep'))
					{
						npc.AddAbility('Flashstep');
					}
				}
				else
				{
					if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.25;
					}
					else if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.25;
					}
				}
			}
		}
	}
}

function ACS_Nekurat_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	if 
	(npc && npc.HasTag('ACS_Nekurat'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (ACS_IsNight())
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
	}
}

function ACS_She_Who_Knows_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_She_Who_Knows'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				npc.SoundEvent("monster_bies_vo_pain_normal");
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
	}
}

function ACS_Wild_Hunt_Bosses_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(
	npc && 
	(
	npc.HasAbility('WildHunt_Eredin')
	|| npc.HasAbility('WildHunt_Imlerith')
	)
	)
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_NightStalker_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Night_Stalker'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				GetACSNightStalker().SetTatgetableByPlayer(true);
				
				if (GetACSNightStalker().IsEffectActive('predator_mode', false))
				{
					npc.SetCanPlayHitAnim(true); 
					GetACSNightStalker().DestroyEffect('predator_mode');

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

				GetACSNightStalker().DestroyEffect('glow');
				GetACSNightStalker().PlayEffectSingle('glow');

				if (!GetACSNightStalker().IsEffectActive('demonic_possession', false))
				{
					GetACSNightStalker().PlayEffectSingle('demonic_possession');
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
	}
}

function ACS_XenoTyrant_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Xeno_Tyrant'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				npc.SetCanPlayHitAnim(false); 

				if (GetACSXenoTyrant().HasAbility('mon_kikimore_small'))
				{
					GetACSXenoTyrant().RemoveAbility('mon_kikimore_small');
				}
				else
				{
					GetACSXenoTyrant().AddAbility('mon_kikimore_small');
				}

				if (ACS_ActionDealsFireDamage(action)
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
	}
}

function ACS_XenoSoldier_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Xeno_Soldiers'))
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
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

			if (ACS_ActionDealsFireDamage(action)
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
	}
}

function ACS_XenoArmoredWorker_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Xeno_Armored_Workers'))
	{
		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
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

			if (ACS_ActionDealsFireDamage(action)
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
	}
}

function ACS_Fire_Bear_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Fire_Bear'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (ACSFireBear().IsEffectActive('flames', false))
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

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
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
	}
}

function ACS_Ice_Titan_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Ice_Titan'))
	{
		if 
		(playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
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
	}
}

function ACS_Knightmare_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Knightmare_Eternum'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

					GetACSKnightmareQuenHit().StopEffect('discharge');
					GetACSKnightmareQuenHit().PlayEffectSingle('discharge');

					GetACSKnightmareQuen().PlayEffectSingle('default_fx');
					GetACSKnightmareQuen().StopEffect('default_fx');
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
				
				GetACSKnightmareQuenHit().StopEffect('quen_rebound_sphere_bear_abl2');
				//GetACSKnightmareQuenHit().PlayEffectSingle('quen_rebound_sphere_bear_abl2');

				GetACSKnightmareQuenHit().StopEffect('quen_rebound_sphere_bear_abl2_copy');
				//GetACSKnightmareQuenHit().PlayEffectSingle('quen_rebound_sphere_bear_abl2_copy');

				GetACSKnightmareQuenHit().StopEffect('quen_impulse_explode');
				//GetACSKnightmareQuen().PlayEffectSingle('quen_impulse_explode');
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
	}
}

function ACS_Unseen_Blade_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Blade_Of_The_Unseen'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (npc.UsesVitality())
				{
					if (GetACSStorage().Unseen_Blade_Death_Count() == 0)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
					}
					else if (GetACSStorage().Unseen_Blade_Death_Count() == 1)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
					else if (GetACSStorage().Unseen_Blade_Death_Count() == 2)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
				}
				else if (npc.UsesEssence())
				{
					if (GetACSStorage().Unseen_Blade_Death_Count() == 0)
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.125;
					}
					else if (GetACSStorage().Unseen_Blade_Death_Count() == 1)
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}
					else if (GetACSStorage().Unseen_Blade_Death_Count() == 2)
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
	}
}

function ACS_Big_Lizard_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Big_Lizard'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

						movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
					}

					npc.SoundEvent("monster_him_vo_pain_ALWAYS");

					npc.SoundEvent("monster_bies_vo_pain_normal");
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
	}
}

function ACS_Rat_Mage_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Rat_Mage'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

					GetACSRatMageQuenHit().StopEffect('discharge');
					GetACSRatMageQuenHit().PlayEffectSingle('discharge');

					GetACSRatMageQuen().PlayEffectSingle('default_fx');
					GetACSRatMageQuen().StopEffect('default_fx');
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
				
				GetACSRatMageQuenHit().StopEffect('quen_rebound_sphere_bear_abl2');

				GetACSRatMageQuenHit().StopEffect('quen_rebound_sphere_bear_abl2_copy');

				GetACSRatMageQuenHit().StopEffect('quen_impulse_explode');
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
	}
}

function ACS_Canaris_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	var caranthir_hit_anim_names																									: array< name >;
	var spawnPos, newSpawnPos																										: Vector;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	if 
	(npc && npc.HasTag('ACS_Canaris'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			////&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				ACSCanaris_RemoveTimers();

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

					if( GetACSCanaris().IsAlive()) {GetACSCanaris().ClearAnimationSpeedMultipliers();}	

					GetACSCanaris().SetAnimationSpeedMultiplier( 1.5  );
																		
					GetACSWatcher().RemoveTimer('ACS_Caranthir_ResetAnimation'); 
					GetACSWatcher().AddTimer('ACS_Caranthir_ResetAnimation', 0.5  , false);

					animatedComponentA.PlaySlotAnimationAsync ( caranthir_hit_anim_names[RandRange(caranthir_hit_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));
				}
				else
				{
					caranthir_hit_anim_names.PushBack('hit_back_fall_01');
					caranthir_hit_anim_names.PushBack('hit_back_fall_02');

					if( GetACSCanaris().IsAlive()) {GetACSCanaris().ClearAnimationSpeedMultipliers();}	

					GetACSCanaris().SetAnimationSpeedMultiplier( 1.5  );
																		
					GetACSWatcher().RemoveTimer('ACS_Caranthir_ResetAnimation'); 
					GetACSWatcher().AddTimer('ACS_Caranthir_ResetAnimation', 0.5  , false);

					animatedComponentA.PlaySlotAnimationAsync ( caranthir_hit_anim_names[RandRange(caranthir_hit_anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.5f, 0.5f));

					GetACSCanaris().DestroyEffect('teleport_short');
					GetACSCanaris().PlayEffectSingle('teleport_short');
					GetACSCanaris().StopEffect('teleport_short');

					GetACSCanaris().DestroyEffect('ice_armor');
					GetACSCanaris().PlayEffectSingle('ice_armor');

					GetACSWatcher().ACS_Caranthir_Teleport_FX();

					spawnPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 15;

					if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 0.3 , newSpawnPos ) )
					{
						theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
						spawnPos = newSpawnPos;
					}

					GetACSCanaris().Teleport(ACSFixZAxis(spawnPos));
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
	}
}

function ACS_Fire_Gargoyle_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(playerAttacker && npc && npc.HasTag('ACS_Fire_Gargoyle'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

					movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
				}

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
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
	}
}

function ACS_Lynx_Witcher_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	( npc && npc.HasTag('ACS_Lynx_Witcher'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

							npc.SoundEvent("bomb_dragons_dream_explo");

							npc.AddTag('ACS_Lynx_Witcher_Stealth');

							GetACSWatcher().AddTimer('LynxWitcherRemoveStealth', 20, false);
						}

						npc.AddTag('ACS_Lynx_Witcher_1st_Stage');
					}
				}
			}

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Lynx_Witcher_End_Stage'))
				{
					npc.DestroyAfter(5);

					npc.AddTag('ACS_Lynx_Witcher_End_Stage');
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
	}
}

function ACS_Elderblood_Assassin_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	( npc && npc.HasTag('ACS_Elderblood_Assassin'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

							npc.SoundEvent("bomb_dragons_dream_explo");

							npc.AddTag('ACS_Elderblood_Assassin_Stealth');
						}

						npc.AddTag('ACS_Elderblood_Assassin_1st_Stage');
					}
				}
			}

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Elderblood_Assassin_End_Stage'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 25, false );

					npc.StopEffect('fury');

					npc.StopEffect('fury_403');

					npc.StopEffect('teleport_glow');

					npc.PlayEffect('fury');

					npc.PlayEffect('fury_403');

					npc.PlayEffect('teleport_glow');

					npc.DestroyAfter(1);

					npc.AddTag('ACS_Elderblood_Assassin_End_Stage');
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
	}
}

function ACS_Elderblood_Assassin_Clone_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	( npc && npc.HasTag('ACS_Elderblood_Assassin_Clone'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Elderblood_Assassin_Clone_End_Stage'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 10, false );

					npc.StopEffect('fury');

					npc.StopEffect('fury_403');

					npc.StopEffect('teleport_glow');

					npc.PlayEffect('fury');

					npc.PlayEffect('fury_403');

					npc.PlayEffect('teleport_glow');

					npc.DestroyAfter(1);

					npc.AddTag('ACS_Elderblood_Assassin_Clone_End_Stage');
				}
			}
		}
	}
}

function ACS_Wolf_On_Take_Damage(action: W3DamageAction)
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
		if (npc.HasAbility('mon_wolf_base')
		&& !npc.HasAbility('mon_wolf_summon_were')
		&& !npc.HasAbility('mon_evil_dog')
		&& ((CNewNPC)npc).GetNPCType() != ENGT_Quest
		&& !((CNewNPC)npc).IsInInterior()
		&& !npc.HasTag('ACS_Shadow_Wolf')
		&& GetACSFluffy() 
		&& GetACSFluffy().IsAlive()
		)
		{
			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Wolf_End_Stage'))
				{
					if (RandF() < 0.5)
					{
						ACS_ShadowWolfSpawn(npc, npc.GetWorldPosition());
					}

					npc.AddTag('ACS_Wolf_End_Stage');
				}
			}
		}
	}
}

function ACS_ShadowWolf_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc 
	&& 
	(npc.HasTag('ACS_Shadow_Wolf') || npc.HasTag('ACS_Fluffy_Shadow_Wolf')))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_ShadowWolf_End_Stage'))
				{
					npc.PlayEffectSingle('appear');
					npc.StopEffect('appear');

					npc.StopAllEffects();

					((CNewNPC)npc).SetVisibility(false);

					npc.AddTag('ACS_ShadowWolf_End_Stage');
				}
			}
		}
	}
}

function ACS_Fluffy_ShadowWolf_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Fluffy_Shadow_Wolf'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_ShadowWolf_End_Stage'))
				{
					npc.PlayEffectSingle('appear');
					npc.StopEffect('appear');

					npc.StopAllEffects();

					((CNewNPC)npc).SetVisibility(false);

					npc.AddTag('ACS_ShadowWolf_End_Stage');
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
	}
}

function ACS_Fluffy_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Fluffy'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

					movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
				}

				if (npc.GetCurrentHealth() - action.processedDmg.vitalityDamage < npc.GetMaxHealth() * 0.5
				|| npc.GetCurrentHealth() - action.processedDmg.essenceDamage < npc.GetMaxHealth() * 0.5)
				{
					if (!npc.HasTag('ACS_Fluffy_Summon_Adds'))
					{
						npc.SoundEvent("animals_wolf_howl");

						npc.SoundEvent("monster_wild_dog_howl");

						if (GetACSFluffy() && GetACSFluffy().IsAlive())
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
	}
}

function ACS_Botchling_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Botchling'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				npc.SoundEvent("cmb_play_hit_heavy");

				if (!((CNewNPC)npc).IsFlying()
				&& npc.IsOnGround())
				{
					ticket = movementAdjustorNPC.GetRequest( 'ACS_Botchling_Attacked_Rotate');
					movementAdjustorNPC.CancelByName( 'ACS_Botchling_Attacked_Rotate' );
					movementAdjustorNPC.CancelAll();

					ticket = movementAdjustorNPC.CreateNewRequest( 'ACS_Botchling_Attacked_Rotate' );
					movementAdjustorNPC.AdjustmentDuration( ticket, 0.5 );
					movementAdjustorNPC.MaxRotationAdjustmentSpeed( ticket, 500 );

					movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
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
								GetACSBotchling().PlayEffect('fx_quest_q103');
								GetACSBotchling().StopEffect('fx_quest_q103');

								GetACSBotchling().PlayEffect('appear_fx');
								GetACSBotchling().PlayEffect('morph_fx');

								GetACSBotchling().StopEffect('appear_fx');
								GetACSBotchling().StopEffect('morph_fx');

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
	}
}

function ACS_Mula_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Mula'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Ice_Boar_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Ice_Boar'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Fog_Assassin_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Fog_Assassin'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

					movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
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
	}
}

function ACS_Ghoul_Base_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	if 
	(npc && npc.HasAbility('mon_ghoul_base'))
	{
		if ( npc.HasAbility('mon_ghoul_lesser')
		|| npc.HasAbility('mon_ghoul')
		|| npc.HasAbility('mon_ghoul_stronger')
		|| npc.HasAbility('mon_EP2_ghouls')
		|| npc.HasAbility('ghoul_hardcore')
		)
		{
			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
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
		}
		else if ( 
		npc.HasAbility('mon_alghoul')
		|| npc.HasAbility('mon_greater_miscreant')
		)
		{
			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
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
		}
		else if (
		npc.HasAbility('mon_wild_hunt_minionMH')
		|| npc.HasAbility('mon_wild_hunt_minion')
		)
		{
			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
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
}

function ACS_Siren_Base_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasAbility('mon_siren_base'))
	{
		if(!npc.HasAbility('DisableDismemberment'))
		{
			npc.AddAbility('DisableDismemberment');
		}

		if (
		(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
		||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
		)
		{
			if (!npc.HasTag('ACS_Siren_End_Stage'))
			{
				ACS_Alghoul_Explode(npc, npc.GetWorldPosition());

				npc.AddTag('ACS_Siren_End_Stage');
			}
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
			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if (!npc.HasTag('ACS_Unseen_Blade_Summon_Trigger'))
				{
					if(!ACS_Blade_Of_The_Unseen() && !ACSVampireMonster())
					{
						GetACSStorage().Number_Of_Bruxae_Slain_Increment();
						
						if (GetACSStorage().Number_Of_Bruxae_Slain() == 1)
						{
							GetWitcherPlayer().DisplayHudMessage( "Ignorance is fatal." );

							GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
							GetACSWatcher().AddTimer('unseen_blade_spawn_delay', 305, true);
						}
						else if (GetACSStorage().Number_Of_Bruxae_Slain() == 2)
						{
							GetWitcherPlayer().DisplayHudMessage( "None escape the shadow of their deeds." );

							GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
							GetACSWatcher().AddTimer('unseen_blade_spawn_delay', 155, true);
						}
						else if (GetACSStorage().Number_Of_Bruxae_Slain() == 3)
						{
							GetWitcherPlayer().DisplayHudMessage( "Prepare yourself, witcher." );

							GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
							GetACSWatcher().AddTimer('unseen_blade_spawn_delay', 5, true);
						}
						else
						{
							GetWitcherPlayer().DisplayHudMessage( "Prepare yourself, witcher." );

							GetACSWatcher().RemoveTimer('unseen_blade_spawn_delay');
							GetACSWatcher().AddTimer('unseen_blade_spawn_delay', 5, true);
						}

						npc.AddTag('ACS_Unseen_Blade_Summon_Trigger');
					}
					else if(ACS_Blade_Of_The_Unseen() && ACS_Blade_Of_The_Unseen().IsAlive())
					{
						playerRot = thePlayer.GetWorldRotation();

						playerRot.Yaw += 180;

						spawnPos = theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 10;

						if( !theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.5, 0.5 , newSpawnPos ) )
						{
							theGame.GetWorld().NavigationFindSafeSpot( spawnPos, 0.3, 10 , newSpawnPos );
							spawnPos = newSpawnPos;
						}

						ACS_Blade_Of_The_Unseen().TeleportWithRotation(ACSFixZAxis(spawnPos), playerRot);

						npc.AddTag('ACS_Unseen_Blade_Summon_Trigger');
					}
				}
			}
		}
	}
}

function ACS_Cursed_Werewolf_On_Take_Damage(action: W3DamageAction)
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
		if (playerAttacker)
		{
			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Morkvarg_Death'))
				{
					((CActor)npc).GetInventory().AddAnItem( 'acs_wolven_fang', 1 );

					npc.AddTag('ACS_Morkvarg_Death');
				}
			}
		}
	}
}

function ACS_Red_Miasmal_Boss_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && StrContains( npc.GetReadableName(), "mq1060_evil_spirit" ))
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

function ACS_Forest_God_Shadow_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Forest_God_Shadows'))
	{
		if (playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Forest_God_Shadow_Death'))
				{
					((CNewNPC)npc).StopAllEffects();

					((CNewNPC)npc).SetVisibility(false);

					GetWitcherPlayer().DisplayHudMessage( "<b>SHADOW DEFEATED</b>" );

					GetWitcherPlayer().AddPoints(EExperiencePoint, 50, false );

					npc.AddTag('ACS_Forest_God_Shadow_Death');
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
	}
}

function ACS_Nimean_Panther_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var npcPos																														: Vector;
	var animatedComponentA 																											: CAnimatedComponent;
	var anim_names																													: array< name >;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Nimean_Panther'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				npc.SoundEvent("monster_golem_cmb_block_ADD");
				npc.SoundEvent("monster_golem_xtra_block_fx");
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Nimean_Panther_Death'))
				{
					animatedComponentA.FreezePoseFadeIn(5);

					GetWitcherPlayer().AddPoints(EExperiencePoint, 500, false );

					npc.AddTag('ACS_Nimean_Panther_Death');
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
	}
}

function ACS_Melusine_Original_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && StrContains( npc.GetReadableName(), "mh210_lamia" ) && npc.HasAbility('mon_siren_base') )
	{
		if (playerAttacker)
		{
			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Melusine_Original_Death') )
				{
					if (RandF() < ACS_MelusineOfTheStorm_Enabled())
					{
						if (GetWeatherConditionName() != 'WT_Rain_Storm')
						{
							RequestWeatherChangeTo('WT_Rain_Storm', 5.0, false);
						}

						ACS_Lightning_Strike_No_Condition();

						GetACSWatcher().RemoveTimer('MelusineSpawnDelay');
						GetACSWatcher().AddTimer('MelusineSpawnDelay', RandRangeF(10,5), false);
					}
					
					npc.AddTag('ACS_Melusine_Original_Death');
				}
			}
		}
	}
}

function ACS_Melusine_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Melusine'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (GetACSMelusineCloud().HasAbility('DjinnRage'))
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

				if (GetACSMelusineBossbar().UsesVitality())
				{
					GetACSMelusineBossbar().DrainVitality(action.processedDmg.vitalityDamage);
				}
				else if (GetACSMelusineBossbar().UsesEssence())
				{
					GetACSMelusineBossbar().DrainEssence(action.processedDmg.essenceDamage);
				}
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Melusine_Death'))
				{
					GetACSMelusineCloud().Destroy();

					GetACSMelusineBossbar().Destroy();

					GetWitcherPlayer().AddPoints(EExperiencePoint, 500, false );

					ACS_Lightning_Strike_No_Condition_Mult();

					if (GetWeatherConditionName() != 'WT_Clear')
					{
						RequestWeatherChangeTo('WT_Clear', 1.0, false);
					}

					npc.AddTag('ACS_Melusine_Death');
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
	}
}

function ACS_Melusine_Cloud_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Melusine_Cloud'))
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

function ACS_Melusine_Bossbar_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Melusine_Bossbar'))
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

function ACS_Cultist_Boss_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var npcPos																														: Vector;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Cultist_Boss'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Cultist_Boss_Death'))
				{
					ACS_Cultist_Boss_Siren_Spawn();

					if (!thePlayer.inv.HasItem('lore_acs_fucusya_1')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_2')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_3')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_4')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
					)
					{
						thePlayer.inv.AddAnItem('lore_acs_fucusya_1', 1);
					}
					else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_2')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_3')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_4')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
					)
					{
						thePlayer.inv.AddAnItem('lore_acs_fucusya_2', 1);
					}
					else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_3')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_4')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
					)
					{
						thePlayer.inv.AddAnItem('lore_acs_fucusya_3', 1);
					}
					else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_3')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_4')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
					)
					{
						thePlayer.inv.AddAnItem('lore_acs_fucusya_4', 1);
					}
					else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_3')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_4')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_5')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
					)
					{
						thePlayer.inv.AddAnItem('lore_acs_fucusya_5', 1);
					}
					else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_3')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_4')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_5')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_6')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
					)
					{
						thePlayer.inv.AddAnItem('lore_acs_fucusya_6', 1);
					}
					else if (thePlayer.inv.HasItem('lore_acs_fucusya_1')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_2')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_3')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_4')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_5')
					&& thePlayer.inv.HasItem('lore_acs_fucusya_6')
					&& !thePlayer.inv.HasItem('lore_acs_fucusya_7')
					)
					{
						thePlayer.inv.AddAnItem('lore_acs_fucusya_7', 1);
					}

					npc.AddTag('ACS_Cultist_Boss_Death');
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
	}
}

function ACS_Cultist_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var npcPos																														: Vector;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Cultist'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Cultist_Death'))
				{
					ACS_Cultist_Siren_Spawn();

					npc.AddTag('ACS_Cultist_Death');
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
	}
}

function ACS_Cultist_Singer_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var npcPos																														: Vector;
	var animatedComponentA 																											: CAnimatedComponent;
	var anim_names																													: array< name >;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Cultist_Singer'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Cultist_Singer_Death'))
				{
					anim_names.Clear();

					anim_names.PushBack('woman_sorceress_death_front_01');
					anim_names.PushBack('woman_sorceress_death_front_02');

					animatedComponentA.PlaySlotAnimationAsync ( anim_names[RandRange(anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					animatedComponentA.FreezePoseFadeIn(2);

					npc.AddTag('ACS_Cultist_Singer_Death');
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
	}
}

function ACS_Pirate_Zombie_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor, movementAdjustorNPC																						: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorNPC = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Pirate_Zombie'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");

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

						movementAdjustorNPC.RotateTowards( ticket, GetWitcherPlayer() );
					}

					npc.RemoveTag('ACS_Pirate_Zombie_Hit_Anim_Immune');
				}
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Pirate_Zombie_Despawn'))
				{
					npc.PlayEffectSingle('ethereal_buff');
					npc.PlayEffectSingle('ethereal_debuff');

					((CNewNPC)npc).SetVisibility(false);

					GetACSPirateZombieSwordTrail().Destroy();

					GetACSPirateZombieChestBone1().Destroy();

					GetACSPirateZombieChestBone2().Destroy();

					GetACSPirateZombieChestBone3().Destroy();

					GetACSPirateZombieChestBone4().Destroy();

					GetWitcherPlayer().AddPoints(EExperiencePoint, 250, false );

					npc.AddTag('ACS_Pirate_Zombie_Despawn');
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
	}
}

function ACS_Svalblod_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animcomp = (CAnimatedComponent)npc.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npc.GetComponentByClassName('CMeshComponent');

	if 
	(npc && npc.HasTag('ACS_Svalblod'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (GetACSSvalblodBossbar().UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}

					GetACSSvalblodBossbar().DrainVitality(action.processedDmg.vitalityDamage / 2);
				}
				else if (GetACSSvalblodBossbar().UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.5;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}

					GetACSSvalblodBossbar().DrainEssence(action.processedDmg.essenceDamage / 2);
				}

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;
			}

			if (
			GetACSSvalblodBossbar().UsesEssence() && GetACSSvalblodBossbar().GetCurrentHealth() < GetACSSvalblodBossbar().GetMaxHealth() * RandRangeF(0.75, 0.25)
			)
			{
				if ( !npc.HasTag('ACS_Svalblod_Transform'))
				{
					GetACSWatcher().ACS_Svalblod_Bear_Spawn();

					animcomp.FreezePose();

					((CNewNPC)npc).EnableCollisions(false);

					npc.DestroyAfter(1);

					npc.SetImmortalityMode( AIM_Invulnerable, AIC_Combat ); 

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
	}
}

function ACS_Svalblod_Bear_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var droppeditemID 																												: SItemUniqueId;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Svalblod_Bear'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (GetACSSvalblodBossbar().UsesVitality())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.875;
					}

					GetACSSvalblodBossbar().DrainVitality(action.processedDmg.vitalityDamage / 2);
				}
				else if (GetACSSvalblodBossbar().UsesEssence())
				{
					if( thePlayer.IsDoingSpecialAttack(false))
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.9;
					}
					else
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.875;
					}

					GetACSSvalblodBossbar().DrainEssence(action.processedDmg.essenceDamage / 2);
				}

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage;

				ticket = movementAdjustor.GetRequest( 'ACS_Svalblod_Bear_Rotate');
				movementAdjustor.CancelByName( 'ACS_Svalblod_Bear_Rotate' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Svalblod_Bear_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.5 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500 );

				movementAdjustor.RotateTowards(ticket, thePlayer);

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}

			if (
			GetACSSvalblodBossbar().GetCurrentHealth() <= 0.1
			)
			{
				if ( !npc.HasTag('ACS_Svalblod_Bear_Death'))
				{
					GetACSSvalblodBossbar().Destroy();

					movementAdjustor.CancelAll();

					if (npc.UsesVitality())
					{
						npc.DrainVitality(npc.GetMaxHealth());
					}
					else if (npc.UsesEssence())
					{
						npc.DrainEssence(npc.GetMaxHealth());
					}

					npc.GetInventory().AddAnItem( 'acs_bow_item' , 1 );

					droppeditemID = npc.GetInventory().GetItemId('acs_bow_item');

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
	}
}

function ACS_Svalblod_Bossbar_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Svalblod_Bossbar'))
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

function ACS_Berserker_Human_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var meshcomp																													: CComponent;
	var animcomp 																													: CAnimatedComponent;
	var h 																															: float;		
	var l_comp : array< CComponent >;
	var size, j : int;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animcomp = (CAnimatedComponent)npc.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npc.GetComponentByClassName('CMeshComponent');

	if 
	(npc && npc.HasTag('ACS_Berserkers_Human'))
	{
		if (playerAttacker)
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
						}

						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage/2;
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

						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage/2;
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
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;
						}

						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage/2;
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

						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage/2;
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

						npc.SetAnimationSpeedMultiplier(1.25);

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
	}
}

function ACS_Berserker_Bear_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Berserkers_Bear'))
	{
		if (playerAttacker)
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
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

				ticket = movementAdjustor.GetRequest( 'ACS_Berserker_Bear_Rotate');
				movementAdjustor.CancelByName( 'ACS_Berserker_Bear_Rotate' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Berserker_Bear_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500 );

				movementAdjustor.RotateTowards(ticket, thePlayer);
			}
		}
	}
}

function ACS_Wildhunt_Warriors_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Wild_Hunt_Rider'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Duskwraith_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

	if 
	(npc && npc.HasTag('ACS_Duskwraith'))
	{
		if ( playerAttacker)
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (ACSDuskwraith().IsEffectActive('shadows_form_banshee', false))
				{
					npc.SetCanPlayHitAnim(false); 

					ACSDuskwraith().StopEffect('shadows_form_banshee');
					ACSDuskwraith().StopEffect('shadows_form_noonwraith_test');
					ACSDuskwraith().PlayEffectSingle('shadows_form_noonwraith');

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

					GetACSWatcher().AddTimer('ACS_Duskwraith_Shadowcloak', 4, false);
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

				movementAdjustor.RotateTowards(ticket, thePlayer);
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
	}
}

function ACS_Duskwraith_Adds_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Duskwraith_Skeleton'))
	{
		if(playerAttacker)
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Incubus_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Incubus'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Incubus_Despawn'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 250, false );

					npc.StopAllEffects();

					npc.PlayEffect('teleport_in');

					npc.PlayEffect('teleport_out');

					npc.DestroyAfter(5);

					npc.AddTag('ACS_Incubus_Despawn');
				}
			}
		}
	}
}

function ACS_Mage_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Mage'))
	{
		if (playerAttacker)
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Mage_Despawn'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 100, false );

					npc.StopAllEffects();

					npc.PlayEffect('teleport_in');

					npc.PlayEffect('teleport_out');

					npc.DestroyAfter(10);

					npc.AddTag('ACS_Mage_Despawn');
				}
			}
		}
	}
}

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
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				/*
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
				*/

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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= npc.GetMaxHealth() * 0.05)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= npc.GetMaxHealth() * 0.05))
			{
				if ( !npc.HasTag('ACS_Shades_Crusader_Despawn'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 100, false );

					ACS_Alghoul_Explode(npc, npc.GetWorldPosition());

					npc.StopAllEffects();
					
					npc.PlayEffectSingle('ethereal_buff');
					npc.PlayEffectSingle('ethereal_debuff');

					//npc.GetInventory().RemoveAllItems();

					((CNewNPC)npc).SetVisibility(false);

					npc.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					npc.DestroyAfter(0.5);

					npc.AddTag('ACS_Shades_Crusader_Despawn');
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

function ACS_Shades_Hunter_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Shades_Hunter'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Shades_Hunters_Despawn'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 100, false );

					ACS_Ghoul_Explode(npc, npc.GetWorldPosition());

					//npc.GetInventory().RemoveAllItems();

					npc.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					npc.DestroyAfter(0.5);

					npc.AddTag('ACS_Shades_Hunters_Despawn');
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

function ACS_Shades_Rogue_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Shades_Rogue'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Shades_Rogue_Despawn'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 25, false );

					npc.GetInventory().RemoveAllItems();

					npc.AddTag('ACS_Shades_Rogue_Despawn');
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
	}
}

function ACS_Shades_Rogue_Enemies_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Shades_Rogue_Enemies'))
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
	}
}

function ACS_Draug_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var animatedComponentA 																											: CAnimatedComponent;
	var l_comp 																														: array< CComponent >;
	var size, j 																													: int;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	if 
	(npc && npc.HasTag('ACS_Draug'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Draug_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 500, false );

					GetACSWatcher().RemoveTimer('ACS_Draug_Anchor_Respawn');

					((CActor)npc).GetInventory().AddAnItem( 'acs_crossbow_item', 1 );

					GetACSDraugFakeAnchor().BreakAttachment();

					GetACSDraugFakeAnchor().Teleport(ACSDraug().GetWorldPosition() + Vector(0,0,-200));

					GetACSDraugFakeAnchor().DestroyAfter(0.001);

					l_comp = ((CActor)ACSDraug()).GetComponentsByClassName( 'CMorphedMeshManagerComponent' );
					size = l_comp.Size();

					for ( j=0; j<size; j+= 1 )
					{
						((CMorphedMeshManagerComponent)l_comp[ j ]).SetMorphBlend( 0, 0.001 );
					}

					animatedComponentA.PlaySlotAnimationAsync ( 'giant_death_from_lightning_ACS', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					animatedComponentA.FreezePoseFadeIn(25);

					npc.AddTag('ACS_Draug_Death');
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
	}
}

function ACS_Draugir_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Draugir'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Draugir_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 25, false );

					npc.StopAllEffects();

					//((CNewNPC)npc).SetVisibility(false);

					npc.PlayEffectSingle('explode');

					npc.PlayEffectSingle('fire_hit');

					npc.PlayEffectSingle('fire_blowing');

					npc.PlayEffectSingle('fire_blowing_2');

					npc.StopAllEffects();

					npc.AddTag('ACS_Draugir_Death');
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
	}
}

function ACS_MegaWraith_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_MegaWraith'))
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Megawraith_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 500, false );

					GetACSMegaWraithRWeapon().Destroy();

					GetACSMegaWraithLWeapon().Destroy();

					npc.StopEffect('demonic_possession');

					npc.DestroyEffect('critical_burning_green_ex');

					npc.DestroyEffect('critical_burning_green_ex_r');

					npc.AddTag('ACS_Megawraith_Death');
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
	}
}

function ACS_Fire_Gryphon_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Fire_Gryphon'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				npc.SoundEvent("monster_him_vo_pain_ALWAYS");

				npc.SoundEvent("monster_bies_vo_pain_normal");
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Fire_Gryphon_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 500, false );

					npc.AddTag('ACS_Fire_Gryphon_Death');
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
	}
}

function ACS_Big_Hym_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Big_Hym'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			npc.SetCanPlayHitAnim(false);

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Big_Hym_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 500, false );

					npc.StopAllEffects();

					npc.PlayEffect('avatar_death_swollen');

					((CNewNPC)npc).SetVisibility(false);

					GetACSWatcher().MiniHymSizeSpeedReset();

					npc.AddTag('ACS_Big_Hym_Death');
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
	}
}

function ACS_Mini_Hym_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var size, speed											: float;
	var animcomp 											: CAnimatedComponent;
	var meshcomp 											: CComponent;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

	animcomp = (CAnimatedComponent)npc.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npc.GetComponentByClassName('CMeshComponent');	

	if 
	(npc && npc.HasTag('ACS_Mini_Hym'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			npc.SetCanPlayHitAnim(false);

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			////&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				if (GetACSWatcher().MiniHymSizeCheck())
				{
					GetACSWatcher().MiniHymSizeSpeedReset();

					ACS_Spawn_Big_Hym(npc,npc.GetWorldPosition());

					npc.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

					npcAttacker.Destroy();
				}
				else
				{
					size = GetACSWatcher().GetMiniHymSize();

					speed = GetACSWatcher().GetMiniHymSpeed();

					GetACSWatcher().MiniHymSizeSpeedDecrement();
						
					if (size < 1.5)
					{
						animcomp.SetScale(Vector(size,size,size,1));
						meshcomp.SetScale(Vector(size,size,size,1));	
					}
					else
					{
						GetACSWatcher().MiniHymSizeSpeedReset();
							
						ACS_Spawn_Big_Hym(npcAttacker,npcAttacker.GetWorldPosition());

						npcAttacker.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

						npcAttacker.Destroy();
					}
						
					npc.SetAnimationTimeMultiplier(speed);

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
}

function ACS_Guardian_Hym_Death_Spawn_Ability( pos : Vector )
{
	var proj_1																												: W3ACSBloodTentacles;

	proj_1 = (W3ACSBloodTentacles)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blood_tentacles.w2ent", true ), ACSFixZAxis(pos) );
	proj_1.DestroyAfter(10);	
}

function ACS_Guardian_Hym_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var size, speed											: float;
	var animcomp 											: CAnimatedComponent;
	var meshcomp 											: CComponent;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

	animcomp = (CAnimatedComponent)npc.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npc.GetComponentByClassName('CMeshComponent');	

	if 
	(npc 
	&& 
	(
		npc.HasTag('ACS_Guardian_Blood_Hym_Small')
		|| npc.HasTag('ACS_Guardian_Blood_Hym_Large')
	)
	)
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Guardian_Hym_Death'))
				{
					ACS_Guardian_Hym_Death_Spawn_Ability(npc.GetWorldPosition());

					npc.DestroyAfter(0.5);

					npc.AddTag('ACS_Guardian_Hym_Death');
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
	}
}

function ACS_Necrofiend_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Necrofiend'))
	{
		if ( playerAttacker )
		{
			npc.SignalGameplayEvent('DisableFinisher');

			npc.SetCanPlayHitAnim(false);

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Bumbakvetch_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Bumbakvetch'))
	{
		if ( playerAttacker )
		{
			npc.SetCanPlayHitAnim(false);

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Viy_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Viy_Of_Maribor'))
	{
		if ( playerAttacker )
		{
			npc.SetCanPlayHitAnim(false);

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Viy_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 1500, false );

					npc.StopAllEffects();

					npc.AddTag('ACS_Viy_Death');
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
	}
}

function ACS_VampireMonsterBossbar_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Vampire_Monster_Boss_Bar'))
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

function ACS_Giant_Troll_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var animatedComponentA 																											: CAnimatedComponent;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	if 
	(npc && npc.HasTag('ACS_Giant_Troll'))
	{
		if ( playerAttacker )
		{
			npc.SetCanPlayHitAnim(false);

			((CNewNPC)npc).SetUnstoppable( true );

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= npc.GetCurrentHealth() * 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= npc.GetCurrentHealth() * 0.01))
			{
				if ( !npc.HasTag('ACS_Giant_Troll_Death'))
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'monster_cave_troll_death_1', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					animatedComponentA.FreezePoseFadeIn(3);

					npc.AddTag('ACS_Giant_Troll_Death');
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
	}
}

function ACS_Elemental_Titan_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Elemental_Titan'))
	{
		if ( playerAttacker )
		{
			npc.SetCanPlayHitAnim(false);

			((CNewNPC)npc).SetUnstoppable( true );

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Hellhound_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc && npc.HasTag('ACS_Hellhound'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Dark_Knight_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc 
	&& 
	(
		npc.HasTag('ACS_Dark_Knight')
	)
	)
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
			)
			{
				
			}

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Dark_Knight_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 100, false );

					npc.DestroyEffect('ghost');
					npc.DestroyEffect('him_smoke_red');
					npc.DestroyEffect('shadow_form');
					npc.DestroyEffect('smoke_effect_1');
					npc.DestroyEffect('smoke_effect_2');

					npc.PlayEffect('death_vision');

					((CNewNPC)npc).SetVisibility(false);

					npc.AddTag('ACS_Dark_Knight_Death');
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
	}
}

function ACS_Dark_Knight_Calidus_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc 
	&& 
	(
		npc.HasTag('ACS_Dark_Knight_Calidus')
	)
	)
	{
		((CNewNPC)npc).SetUnstoppable( true );

		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Dark_Knight_Calidus_Death'))
				{
					GetWitcherPlayer().AddPoints(EExperiencePoint, 100, false );

					npc.DestroyEffect('lugos_vision_burning_mat');
					npc.DestroyEffect('burning_body');
					npc.DestroyEffect('him_smoke_red');
					npc.DestroyEffect('shadow_form');
					npc.DestroyEffect('lugos_vision_burning');
					npc.DestroyEffect('smoke_effect_1');
					npc.DestroyEffect('smoke_effect_2');

					npc.PlayEffect('death_vision');

					((CNewNPC)npc).SetVisibility(false);

					npc.AddTag('ACS_Dark_Knight_Calidus_Death');
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
	}
}

function ACS_Carduin_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc 
	&& 
	(
		npc.HasTag('ACS_Carduin')
	)
	)
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

					ACS_Carduin_Spawn_Ifrit(npc.GetWorldPosition());

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
	}
}

function ACS_Carduin_Spawn_Ifrit( pos : Vector )
{
	var ent	: CACSMonsterSpawner;

	ent = (CACSMonsterSpawner)theGame.CreateEntity( 

	(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_monster_spawner.w2ent", true ), 
	
	pos, 

	thePlayer.GetWorldRotation() );

	ent.AddTag('ACS_MonsterSpawner_Ifrit');

	ent.AddTag('ACS_MonsterSpawner_Spawn_In_Frame');
}

function ACS_Dao_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc 
	&& 
	(
		npc.HasTag('ACS_Dao')
	)
	)
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
	}
}

function ACS_Dao_Turret_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	(npc 
	&& 
	(
		npc.HasTag('ACS_Dao_Turret_1')
		|| npc.HasTag('ACS_Dao_Turret_2')
		|| npc.HasTag('ACS_Dao_Turret_3')
	)
	)
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& !(((W3Action_Attack)action).IsParried())
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

			if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
			||
			(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
			{
				if ( !npc.HasTag('ACS_Dao_Turret_Death'))
				{
					if (GetACS_Dao().UsesEssence())
					{
						if (GetACS_Dao().GetStat(BCS_Essence) > GetACS_Dao().GetStatMax(BCS_Essence) * 0.05)
						{
							GetACS_Dao().DrainEssence(GetACS_Dao().GetStatMax(BCS_Essence) * 0.125 );
						}
					}
					else if (GetACS_Dao().UsesVitality())
					{
						if (GetACS_Dao().GetStat(BCS_Vitality) > GetACS_Dao().GetStatMax(BCS_Vitality) * 0.05)
						{
							GetACS_Dao().DrainVitality(GetACS_Dao().GetStatMax(BCS_Vitality) * 0.125 );
						}
					}

					npc.AddTag('ACS_Dao_Turret_Death');
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
	}
}

function ACS_Knocker_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var movementAdjustor																											: CMovementAdjustor;
	var ticket 																														: SMovementAdjustmentRequestTicket;
	var animatedComponentA 																											: CAnimatedComponent;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = npc.GetMovingAgentComponent().GetMovementAdjustor();

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	if 
	(npc && npc.HasTag('ACS_Knocker'))
	{
		//if ( playerAttacker)
		{
			((CNewNPC)npc).SetUnstoppable( true );

			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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

				if 
				(npc.HasTag('ACS_Knocker_Fist'))
				{
					animatedComponentA.PlaySlotAnimationAsync ( 'giant_combat_block_igni', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));
				}

				ticket = movementAdjustor.GetRequest( 'ACS_Knocker_Rotate');
				movementAdjustor.CancelByName( 'ACS_Knocker_Rotate' );
				movementAdjustor.CancelAll();

				ticket = movementAdjustor.CreateNewRequest( 'ACS_Knocker_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.5 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 500000 );

				movementAdjustor.RotateTowards(ticket, thePlayer);
			}

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Knocker_End_Stage'))
				{
					ACS_Ghoul_Explode(npc, npc.GetWorldPosition());

					animatedComponentA.PlaySlotAnimationAsync ( 'giant_combat_death', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.25f));

					animatedComponentA.FreezePoseFadeIn(4);

					//npc.DestroyAfter(10);

					npc.AddTag('ACS_Knocker_End_Stage');
				}
			}
		}
	}
}

function ACS_Vendigo_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	( npc && npc.HasTag('ACS_Vendigo'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
					npc.SoundEvent("animals_deer_sniff");
					thePlayer.SoundEvent("animals_deer_sniff");

					npc.SoundEvent("animals_deer_breath");
					thePlayer.SoundEvent("animals_deer_breath");

					npc.SoundEvent("animals_deer_sniff");
					thePlayer.SoundEvent("animals_deer_sniff");

					npc.SoundEvent("animals_deer_breath");
					thePlayer.SoundEvent("animals_deer_breath");

					npc.SoundEvent("animals_deer_sniff");
					thePlayer.SoundEvent("animals_deer_sniff");

					npc.SetCanPlayHitAnim(false);

					((CNewNPC)npc).SetUnstoppable( true );

					npc.AddTag('ACS_Vendigo_Set_Unstoppable');
				}
				else
				{
					npc.SoundEvent("animals_deer_hit");
					thePlayer.SoundEvent("animals_deer_hit");

					npc.SoundEvent("animals_deer_hit");
					thePlayer.SoundEvent("animals_deer_hit");

					npc.SoundEvent("animals_deer_hit");
					thePlayer.SoundEvent("animals_deer_hit");

					npc.SoundEvent("animals_deer_hit");
					thePlayer.SoundEvent("animals_deer_hit");

					npc.SoundEvent("animals_deer_hit");
					thePlayer.SoundEvent("animals_deer_hit");

					npc.SetCanPlayHitAnim(true);

					((CNewNPC)npc).SetUnstoppable( false );

					npc.RemoveTag('ACS_Vendigo_Set_Unstoppable');
				}
			}

			if (ACS_ActionDealsFireDamage(action)
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

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Vendigo_End_Stage'))
				{
					npc.StopAllEffects();

					npc.SoundEvent("animals_deer_die");
					npc.SoundEvent("animals_deer_die");
					npc.SoundEvent("animals_deer_die");
					npc.SoundEvent("animals_deer_die");
					npc.SoundEvent("animals_deer_die");
					npc.SoundEvent("animals_deer_die");

					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");
					thePlayer.SoundEvent("animals_deer_die");

					ACS_Vendigo_Release_Thralls();

					npc.AddTag('ACS_Vendigo_End_Stage');
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
	}
}

function ACS_Swarm_Mother_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	( npc && npc.HasTag('ACS_Swarm_Mother'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
					npc.SoundEvent("monster_uma_bell_heavy");
					thePlayer.SoundEvent("monster_uma_bell_heavy");

					npc.SoundEvent("monster_uma_bell_light");
					thePlayer.SoundEvent("monster_uma_bell_light");

					npc.SoundEvent("monster_uma_dialog_bell_heavy");
					thePlayer.SoundEvent("monster_uma_dialog_bell_heavy");

					npc.SoundEvent("monster_uma_dialog_bell_light");
					thePlayer.SoundEvent("monster_uma_dialog_bell_light");

					npc.SetCanPlayHitAnim(false);

					((CNewNPC)npc).SetUnstoppable( true );

					npc.AddTag('ACS_Swarm_Mother_Set_Unstoppable');
				}
				else
				{
					npc.SoundEvent("monster_uma_dialog_vo_excited_pain");
					thePlayer.SoundEvent("monster_uma_dialog_vo_excited_pain");

					npc.SoundEvent("monster_uma_dialog_vo_pain_extreme");
					thePlayer.SoundEvent("monster_uma_dialog_vo_pain_extreme");

					npc.SoundEvent("monster_uma_dialog_vo_pain_short");
					thePlayer.SoundEvent("monster_uma_dialog_vo_pain_short");

					npc.SoundEvent("monster_uma_dialog_vo_pain_medium");
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

			if (
			(npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.1)
			||(npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.1)
			)
			{
				if (!npc.HasTag('ACS_Swarm_Mother_End_Stage'))
				{
					ACS_SwarmMotherDestroyHives();

					GetWitcherPlayer().AddPoints(EExperiencePoint, 50, false );

					npc.AddTag('ACS_Swarm_Mother_End_Stage');
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
	}
}

function ACS_Maerolorn_On_Take_Damage(action: W3DamageAction)
{
    var playerAttacker, playerVictim																								: CPlayer;
	var npc, npcAttacker 																											: CActor;
	var params 																														: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if 
	( npc && npc.HasTag('ACS_Maerolorn'))
	{
		if ( playerAttacker )
		{
			if ( !action.IsDoTDamage() 
			&& !action.WasDodged() 
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
						action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.1;
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
						action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.1;
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
	}
}

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
			if ( !action.IsDoTDamage() 
			//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
			&& targetDistance <= 4 * 4
			)
			{
				if ((npc.UsesVitality() && npc.GetCurrentHealth() - action.processedDmg.vitalityDamage <= 0.01)
				||
				(npc.UsesEssence() && npc.GetCurrentHealth() - action.processedDmg.essenceDamage <= 0.01))
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
	(playerAttacker && npc)
	{
		if (((CNewNPC)npc).GetNPCType() == ENGT_Guard)
		{
			if (npc.GetImmortalityMode() != AIM_None)
			{
				npc.SetImmortalityMode( AIM_None, AIC_Combat ); 
			}
		}

		if (!npc.HasAbility('InstantKillImmune'))
		{
			npc.AddAbility('InstantKillImmune');
		}

		if (!npc.HasAbility('OneShotImmune'))
		{
			npc.AddAbility('OneShotImmune');
		}

		if (!npc.HasAbility('ablParryHeavyAttacks'))
		{
			npc.AddAbility('ablParryHeavyAttacks');
		}

		if (!npc.HasAbility('ablCounterHeavyAttacks'))
		{
			npc.AddAbility('ablCounterHeavyAttacks');
		}

		if (!npc.HasAbility('IgnoreLevelDiffForParryTest'))
		{
			npc.AddAbility('IgnoreLevelDiffForParryTest');
		}

		if (npc.HasTag('ACS_Final_Fear_Stack')
		&& !action.IsDoTDamage() 
		/*
		&& (
		thePlayer.IsWeaponHeld('fist')
		|| thePlayer.HasTag('aard_sword_equipped')
		|| thePlayer.HasTag('aard_secondary_sword_equipped')
		|| thePlayer.HasTag('yrden_sword_equipped')
		|| thePlayer.HasTag('yrden_secondary_sword_equipped')
		|| thePlayer.HasTag('quen_secondary_sword_equipped')
		|| thePlayer.HasTag('ACS_In_Ciri_Special_Attack')
		|| thePlayer.HasTag('acs_bow_active') 
		|| thePlayer.HasTag('acs_crossbow_active')
		)
		*/
		)
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage += npc.GetMaxHealth();
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage += npc.GetMaxHealth();
			}

			GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

			if (ACS_Armor_Equipped_Check())
			{
				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_black_exhale");

				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_summon");
			}

			return;
		}

		if (npc.HasTag('ACS_Final_Fear_Stack')
		&& !action.IsDoTDamage() 
		&& !action.IsActionMelee()
		)
		{
			if (npc.UsesEssence())
			{
				action.processedDmg.essenceDamage += npc.GetMaxHealth();
			}
			else if (npc.UsesVitality())
			{
				action.processedDmg.vitalityDamage += npc.GetMaxHealth();
			}

			GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

			if (ACS_Armor_Equipped_Check())
			{
				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_black_exhale");

				GetWitcherPlayer().SoundEvent("monster_caretaker_fx_summon");
			}

			return;
		}

		if (action.WasDodged())
		{
			if (npc.HasTag('ACS_Swapped_To_Shield'))
			{
				npc.SoundEvent("shield_wood_impact");

				npc.SoundEvent("grunt_vo_block");
			}

			return;
		}

		if (ACS_Armor_Equipped_Check() 
		&& !action.IsDoTDamage() 
		//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
		&& action.WasDodged() 
		)
		{
			if (RandF() < 0.5)
			{
				thePlayer.SoundEvent("monster_caretaker_vo_attack_short", 'head' );
			}
		}

		if ( !action.IsDoTDamage() 
		&& !action.WasDodged() 
		//&& action.IsActionMelee() && !thePlayer.IsUsingHorse() && !thePlayer.IsUsingVehicle()
		&& !(((W3Action_Attack)action).IsParried())
		)
		{
			if (ACS_Armor_Equipped_Check() )
			{
				thePlayer.SoundEvent("monster_caretaker_fx_drain_energy_player");

				if (npc.UsesEssence())
				{
					GetWitcherPlayer().GainStat(BCS_Vitality, action.processedDmg.essenceDamage * 0.25 );
				}
				else if (npc.UsesVitality())
				{
					GetWitcherPlayer().GainStat(BCS_Vitality, action.processedDmg.vitalityDamage * 0.25 );
				}

				GetWitcherPlayer().GainStat(BCS_Vitality, (GetWitcherPlayer().GetStatMax(BCS_Vitality) - GetWitcherPlayer().GetStat(BCS_Vitality)) * 0.125 );
				
				if ((GetWitcherPlayer().HasTag('igni_sword_equipped')
				|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped'))
				&& thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus)
				&& thePlayer.GetStat(BCS_Stamina) == thePlayer.GetStatMax(BCS_Stamina)
				)
				{
					if (RandF() < 0.5)
					{
						npc.SoundEvent("fx_fire_geralt_fire_hit");

						npc.SoundEvent("fx_fire_burning_strong_end");
						
						dmg = new W3DamageAction in theGame.damageMgr;
					
						dmg.Initialize(GetWitcherPlayer(), npc, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
						
						dmg.SetProcessBuffsIfNoDamage(true);

						dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, 1 );

						if (!npc.HasBuff(EET_Burning))
						{
							dmg.AddEffectInfo( EET_Burning, 0.5 );
						}
							
						theGame.damageMgr.ProcessAction( dmg );
							
						delete dmg;	
					}
				}
			}

			GetWitcherPlayer().AddTimer( 'RemoveForceFinisher', 0.0, false );

			npc.AddAbility( 'InstantKillImmune' );

			if (!npc.HasAbility('DisableFinishers'))
			{
				npc.AddAbility( 'DisableFinishers', true);
			}

			if (npc.HasAbility('ForceFinisher'))
			{
				npc.RemoveAbility( 'ForceFinisher');
			} 

			npc.SignalGameplayEvent('DisableFinisher');

			if (
			GetWitcherPlayer().HasTag('aard_sword_equipped')
			|| GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
			|| GetWitcherPlayer().HasTag('yrden_sword_equipped')
			|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
			|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
			)
			{
				if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * (GetACSWatcher().combo_counter_damage * 0.1);
				}
				else if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * (GetACSWatcher().combo_counter_damage * 0.1);
				}

				if (GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15)
				{
					if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}
					else if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}

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
							if( RandF() < 0.5 ) 
							{
								((CNewNPC)npc).SetLevel( GetWitcherPlayer().GetLevel() * 2 );
								
								// npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
								npc.AddTag('ContractTarget');
								npc.AddTag('MonsterHuntTarget');
							
								npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

								npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
									
								npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
								
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
							}
							else
							{	
								//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

								//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
							
								npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) * 0 );  

								npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) * 0 );  
									
								npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) * 0 );	

								//npc.GetComponent("Finish").SetEnabled( true );
						
								//npc.SignalGameplayEvent( 'Finisher' );
							}
							
							npc.AddTag('ACS_mettle');
						}
					}
				}

				return;
			}
			else if ( 
			GetWitcherPlayer().HasTag('axii_sword_equipped')
			|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
			|| GetWitcherPlayer().HasTag('quen_sword_equipped'))
			{
				if (npc.UsesEssence())
				{
					action.processedDmg.essenceDamage += action.processedDmg.essenceDamage * (GetACSWatcher().combo_counter_damage * 0.1);
				}
				else if (npc.UsesVitality())
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * (GetACSWatcher().combo_counter_damage * 0.1);
				}
				
				if (GetWitcherPlayer().GetStat( BCS_Stamina ) <= GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15)
				{
					if (npc.UsesEssence())
					{
						action.processedDmg.essenceDamage -= action.processedDmg.essenceDamage * 0.25;
					}
					else if (npc.UsesVitality())
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}

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
							if( RandF() < 0.5 ) 
							{
								((CNewNPC)npc).SetLevel( GetWitcherPlayer().GetLevel() * 2 );
								
								npc.AddTag('ContractTarget');
								npc.AddTag('MonsterHuntTarget');
								
								npc.GainStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

								npc.GainStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
									
								npc.GainStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
								
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
							}
							else
							{	
								//npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
								//npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
								//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

								//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
							
								npc.DrainMorale( npc.GetStatMax( BCS_Morale ) );  
									
								npc.DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ) );

								//npc.GetComponent("Finish").SetEnabled( true );
						
								//npc.SignalGameplayEvent( 'Finisher' );
							}
							
							npc.AddTag('ACS_mettle');
						}
					}
				}

				return;
			}
			else if 
			(
			GetWitcherPlayer().HasTag('igni_sword_equipped')
			|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
			)
			{
				if (ACS_Griffin_School_Check()
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

				if (ACS_Manticore_School_Check()
				&& GetWitcherPlayer().HasTag('ACS_Manticore_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Poison, GetWitcherPlayer(), 'ACS_Manticore_Special_Attack' );

					npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'ACS_Manticore_Special_Attack' );	
				}

				if (ACS_Bear_School_Check()
				&& GetWitcherPlayer().HasTag('ACS_Bear_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Bear_Special_Attack' );
				}

				if (ACS_Viper_School_Check()
				&& GetWitcherPlayer().HasTag('ACS_Viper_Special_Attack'))
				{
					npc.AddEffectDefault( EET_Poison, GetWitcherPlayer(), 'ACS_Manticore_Special_Attack' );
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
							if( RandF() < 0.5 ) 
							{
								((CNewNPC)npc).SetLevel( (GetWitcherPlayer().GetLevel() * 7 ) / 4 );
								
								npc.AddTag('ContractTarget');
								npc.AddTag('MonsterHuntTarget');
								
								npc.ForceSetStat( BCS_Morale, npc.GetStatMax( BCS_Morale ) );  

								npc.ForceSetStat( BCS_Focus, npc.GetStatMax( BCS_Focus ) );  
									
								npc.ForceSetStat( BCS_Stamina, npc.GetStatMax( BCS_Stamina ) );
								
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
							}
							else
							{	
								//npc.AddEffectDefault( EET_Paralyzed, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
								//npc.AddEffectDefault( EET_Bleeding, GetWitcherPlayer(), 'acs_weapon_effects' );	
								
								//animatedComponentA.PlaySlotAnimationAsync ( ' ', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));

								//animatedComponentA.PlaySlotAnimationAsync ( 'man_ex_scared_loop_1', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0));
							
								npc.DrainMorale( npc.GetStatMax( BCS_Morale ) );  
									
								npc.DrainStamina( ESAT_FixedValue, npc.GetStatMax( BCS_Stamina ) );

								//npc.GetComponent("Finish").SetEnabled( true );
						
								//npc.SignalGameplayEvent( 'Finisher' );
							}
							
							npc.AddTag('ACS_mettle');
						}
					}
				}

				return;
			}
			else if (GetWitcherPlayer().HasTag('vampire_claws_equipped'))
			{
				npc.StopEffect('focus_sound_red_fx');

				if (((CActor)npc).HasAbility('DisableDismemberment'))
				{
					((CActor)npc).RemoveAbility( 'DisableDismemberment');
				}

				if (npc.IsUsingVehicle()) 
				{
					npc.SignalGameplayEventParamInt( 'RidingManagerDismountHorse', DT_instant | DT_fromScript );
				}

				GetWitcherPlayer().SoundEvent("monster_dettlaff_vampire_movement_whoosh_claws_large");

				GetWitcherPlayer().IncreaseUninterruptedHitsCount();	

				GetACSWatcher().Passive_Weapon_Effects_Switch();

				if (npc.UsesEssence())
				{
					GetWitcherPlayer().GainStat( BCS_Focus, GetWitcherPlayer().GetStatMax( BCS_Focus) * 0.1 ); 

					if (ACS_Vampire_Claws_Monster_Max_Damage() != 0 
					&& ACS_Vampire_Claws_Monster_Min_Damage() != 0 )
					{
						maxTargetEssence = npc.GetStatMax( BCS_Essence );

						curTargetEssence = npc.GetStat( BCS_Essence );

						if (ACS_VampireClawsDamageMaxHealthOrCurrentHealth() == 0)
						{
							if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| npc.GetRadius() >= 0.7
							)
							{
								damageMax = maxTargetEssence * (ACS_Vampire_Claws_Monster_Max_Damage()/2); 
								
								damageMin = maxTargetEssence * (ACS_Vampire_Claws_Monster_Min_Damage()/2);
							}
							else
							{
								damageMax = maxTargetEssence * ACS_Vampire_Claws_Monster_Max_Damage(); 
								
								damageMin = maxTargetEssence * ACS_Vampire_Claws_Monster_Min_Damage();
							}
						}
						else if (ACS_VampireClawsDamageMaxHealthOrCurrentHealth() == 1)
						{
							if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
							|| npc.GetRadius() >= 0.7
							)
							{
								damageMax = curTargetEssence * (ACS_Vampire_Claws_Monster_Max_Damage()/2); 
								
								damageMin = curTargetEssence * (ACS_Vampire_Claws_Monster_Min_Damage()/2);
							}
							else
							{
								damageMax = curTargetEssence * ACS_Vampire_Claws_Monster_Max_Damage(); 
								
								damageMin = curTargetEssence * ACS_Vampire_Claws_Monster_Min_Damage();
							}
						}

						action.processedDmg.essenceDamage += RandRangeF(damageMax,damageMin) - action.processedDmg.essenceDamage;
					}
					else
					{
						vampireDmgValSilver = GetWitcherPlayer().GetTotalWeaponDamage(item_silver, theGame.params.DAMAGE_NAME_SILVER, GetInvalidUniqueId()); 

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							action.processedDmg.essenceDamage += vampireDmgValSilver/2;

							action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.025, 0);
						}
						else
						{
							action.processedDmg.essenceDamage += vampireDmgValSilver;

							action.processedDmg.essenceDamage += npc.GetStat(BCS_Essence) * RandRangeF(0.05, 0);
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

					if (ACS_Vampire_Claws_Human_Max_Damage() != 0 
					&& ACS_Vampire_Claws_Human_Min_Damage() != 0 )
					{
						maxTargetVitality = npc.GetStatMax( BCS_Vitality );

						curTargetVitality = npc.GetStat( BCS_Vitality );

						if (ACS_VampireClawsDamageMaxHealthOrCurrentHealth() == 0)
						{
							damageMax = maxTargetVitality * ACS_Vampire_Claws_Human_Max_Damage(); 
							
							damageMin = maxTargetVitality * ACS_Vampire_Claws_Human_Min_Damage(); 
						}
						else if (ACS_VampireClawsDamageMaxHealthOrCurrentHealth() == 1)
						{
							damageMax = curTargetVitality * ACS_Vampire_Claws_Human_Max_Damage(); 
							
							damageMin = curTargetVitality * ACS_Vampire_Claws_Human_Min_Damage(); 
						}

						action.processedDmg.vitalityDamage += RandRangeF(damageMax,damageMin) - action.processedDmg.vitalityDamage;
					}
					else
					{
						vampireDmgValSteel = GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_SLASHING, GetInvalidUniqueId()) 
						+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_PIERCING, GetInvalidUniqueId())
						+ GetWitcherPlayer().GetTotalWeaponDamage(item_steel, theGame.params.DAMAGE_NAME_BLUDGEONING, GetInvalidUniqueId());

						if (((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
						|| npc.GetRadius() >= 0.7
						)
						{
							action.processedDmg.vitalityDamage += vampireDmgValSteel/2;
							action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.025, 0);
						}
						else
						{
							action.processedDmg.vitalityDamage += vampireDmgValSteel;
							action.processedDmg.vitalityDamage += npc.GetStat(BCS_Vitality) * RandRangeF(0.05, 0);
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
				
				if (GetWitcherPlayer().IsGuarded())
				{
					GetWitcherPlayer().GainStat( BCS_Vitality, heal ); 
				}
				else
				{
					GetWitcherPlayer().GainStat( BCS_Vitality, heal * 2 ); 
				}
				
				if ( GetWitcherPlayer().HasBuff(EET_BlackBlood) )
				{
					if (RandF() < 0.5 )
					{
						ACS_Vampire_Arms_1_Get().PlayEffectSingle('blood');

						ACS_Vampire_Arms_1_Get().StopEffect('blood');

						ACS_Vampire_Arms_2_Get().PlayEffectSingle('blood');

						ACS_Vampire_Arms_2_Get().StopEffect('blood');

						ACS_Vampire_Arms_3_Get().PlayEffectSingle('blood');

						ACS_Vampire_Arms_3_Get().StopEffect('blood');

						ACS_Vampire_Arms_4_Get().PlayEffectSingle('blood');

						ACS_Vampire_Arms_4_Get().StopEffect('blood');

						GetWitcherPlayer().PlayEffectSingle('blood_effect_claws');
						GetWitcherPlayer().StopEffect('blood_effect_claws');
					}
				}

				GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

				GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_hit_claws");

				GetWitcherPlayer().RemoveTag('ACS_Vampire_Dash_Attack');

				return;
			}		
		}

		/*
		if (ACS_Transformation_Activated_Check())
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

function ACS_Player_Guard(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var vACS_Shield_Summon 									: cACS_Shield_Summon;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( playerVictim
	//&& !playerAttacker
	&& action.GetHitReactionType() != EHRT_Reflect
	&& action.GetBuffSourceName() != "vampirism" 
	&& !action.IsDoTDamage()
	&& (GetWitcherPlayer().IsGuarded() || GetWitcherPlayer().IsInGuardedState() || theInput.GetActionValue('LockAndGuard') > 0.5)
	&& !GetWitcherPlayer().IsPerformingFinisher()
	&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	&& !GetWitcherPlayer().IsAnyQuenActive()
	&& !action.WasDodged()
	&& !GetWitcherPlayer().IsInFistFightMiniGame() 
	&& !GetWitcherPlayer().HasTag('ACS_Camo_Active')
	//&& !GetWitcherPlayer().HasTag('igni_sword_equipped')
	//&& !GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
	)
	{
		if(
		(GetWitcherPlayer().GetStat(BCS_Stamina) >= GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.1)
		)
		{
			if ( GetWitcherPlayer().HasTag('vampire_claws_equipped') )
			{
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

				if (ACS_ParryingStaminaCostAction_Enabled())
				{
					ACS_Parry_Tutorial();

					if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
					{
						if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 0.25), ACS_ParryingStaminaRegenDelay() * 4, );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, (GetWitcherPlayer().GetStatMax(BCS_Stamina) * ACS_ParryingStaminaCost()), ACS_ParryingStaminaRegenDelay(), );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 2), ACS_ParryingStaminaRegenDelay() * 0.5, );
						}
						else
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 4), ACS_ParryingStaminaRegenDelay() * 0.25, );
						}
					}
					else
					{
						GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 4), ACS_ParryingStaminaRegenDelay() * 0.25, );
					}
				}
				
				if ( RandF() < 0.5 )
				{
					if ( RandF() < 0.45 )
					{
						if ( RandF() < 0.45 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							GetWitcherPlayer().StopEffect('left_sparks');
							GetWitcherPlayer().PlayEffectSingle('left_sparks');
						}
						else
						{
							if ( RandF() < 0.5 )
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
								GetWitcherPlayer().StopEffect('taunt_sparks');
								GetWitcherPlayer().PlayEffectSingle('taunt_sparks');
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_left_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
								GetWitcherPlayer().StopEffect('left_sparks');
								GetWitcherPlayer().PlayEffectSingle('left_sparks');
							}
						}	
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_back_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_left_back_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}

						GetWitcherPlayer().StopEffect('left_sparks');
						GetWitcherPlayer().PlayEffectSingle('left_sparks');
					}
				}
				else
				{
					if ( RandF() < 0.45 )
					{
						if ( RandF() < 0.45 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							GetWitcherPlayer().StopEffect('right_sparks');
							GetWitcherPlayer().PlayEffectSingle('right_sparks');
						}
						else
						{
							if ( RandF() < 0.5 )
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_center_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
								GetWitcherPlayer().StopEffect('taunt_sparks');
								GetWitcherPlayer().PlayEffectSingle('taunt_sparks');
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_parry_right_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
								GetWitcherPlayer().StopEffect('right_sparks');
								GetWitcherPlayer().PlayEffectSingle('right_sparks');
							}
						}	
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_back_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'parry_right_back_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						GetWitcherPlayer().StopEffect('right_sparks');
						GetWitcherPlayer().PlayEffectSingle('right_sparks');
					}
				}
			}
			else if ( GetWitcherPlayer().HasTag('axii_sword_equipped') )
			{
				vACS_Shield_Summon = new cACS_Shield_Summon in theGame;

				vACS_Shield_Summon.Axii_Persistent_Shield_Summon();

				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				if (ACS_ParryingStaminaCostAction_Enabled())
				{
					ACS_Parry_Tutorial();

					if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
					{
						if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 0.25), ACS_ParryingStaminaRegenDelay() * 4, );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, (GetWitcherPlayer().GetStatMax(BCS_Stamina) * ACS_ParryingStaminaCost()), ACS_ParryingStaminaRegenDelay(), );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 2), ACS_ParryingStaminaRegenDelay() * 0.5, );
						}
						else
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 4), ACS_ParryingStaminaRegenDelay() * 0.25, );
						}
					}
					else
					{
						GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 4), ACS_ParryingStaminaRegenDelay() * 0.25, );
					}
				}

				GetWitcherPlayer().SoundEvent("cmb_imlerith_shield_impact");

				//GetWitcherPlayer().SetPlayerTarget( npcAttacker );

				//GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

				//GetWitcherPlayer().UpdateDisplayTarget( true );

				//GetWitcherPlayer().UpdateLookAtTarget();

				if ( RandF() < 0.5 )
				{
					if ( RandF() < 0.45 )
					{
						if ( RandF() < 0.45 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							if ( RandF() < 0.5 )
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							}
						}	
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_rp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}
				}
				else
				{
					if ( RandF() < 0.45 )
					{
						if ( RandF() < 0.45 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_01_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							if ( RandF() < 0.5 )
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							}
							else
							{
								playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
							}
						}	
					}
					else
					{
						if ( RandF() < 0.5 )
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_02_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
						else
						{
							playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_shield_block_lp_03_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );
						}
					}
				}

				ACS_Shield().PlayEffectSingle('aard_cone_hit');
				ACS_Shield().StopEffect('aard_cone_hit');
			}
			else 
			{
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Parry_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;

				if (ACS_ParryingStaminaCostAction_Enabled())
				{
					ACS_Parry_Tutorial();

					if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
					{
						if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 0.25), ACS_ParryingStaminaRegenDelay() * 4, );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, (GetWitcherPlayer().GetStatMax(BCS_Stamina) * ACS_ParryingStaminaCost()), ACS_ParryingStaminaRegenDelay(), );
						}
						else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 2), ACS_ParryingStaminaRegenDelay() * 0.5, );
						}
						else
						{
							GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 4), ACS_ParryingStaminaRegenDelay() * 0.25, );
						}
					}
					else
					{
						GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * (ACS_ParryingStaminaCost() * 4), ACS_ParryingStaminaRegenDelay() * 0.25, );
					}
				}

				GetWitcherPlayer().SoundEvent("grunt_vo_block");

				if (thePlayer.IsDeadlySwordHeld())
				{
					GetWitcherPlayer().SoundEvent("cmb_play_parry");
				}
	
				if ( theInput.GetActionValue('LockAndGuard') > 0.5
				&& !GetWitcherPlayer().IsInCombat())
				{
					GetWitcherPlayer().SetBehaviorVariable( 'parryType', 7.0 );
					GetWitcherPlayer().RaiseForceEvent( 'PerformParry' );
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
			if (ACS_ParryingStaminaCostAction_Enabled())
			{
				if (GetWitcherPlayer().IsGuarded()
				|| GetWitcherPlayer().IsInGuardedState())
				{
					GetWitcherPlayer().SetGuarded(false);
					GetWitcherPlayer().OnGuardedReleased();	
				}
			}
		}
	}
}

function ACS_Create_Red_Quen_Hit_Effect()
{
	var ent, ent_2, ent_3, ent_4 		: CEntity;

	if (GetWitcherPlayer().IsAnyQuenActive())
	{
		if (ACS_Forgotten_Wolf_Check_For_Item() || ACS_Armor_Equipped_Check())
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
    var playerAttacker, playerVictim																																														: CPlayer;
	var npc, npcAttacker 																																																	: CActor;
	var movementAdjustor, movementAdjustorWerewolf, movementAdjustorVampiress, movementAdjustorTransformationVampireMonster, movementAdjustorRedMiasmal, movementAdjustorSharley, movementAdjustorBlackWolf					: CMovementAdjustor;
	var ticket, ticketWerewolf, ticketVampiress, ticketTransformationVampireMonster, ticketRedMiasmal, ticketSharley, ticketBlackWolf 																						: SMovementAdjustmentRequestTicket;
	var item																																																				: SItemUniqueId;
	var dmg																																																					: W3DamageAction;
	var damageMax, damageMin																																																: float;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorWerewolf = GetACSTransformationWerewolf().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorVampiress = GetACSTransformationVampiress().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorTransformationVampireMonster = GetACSTransformationVampireMonster().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorRedMiasmal = GetACSTransformationRedMiasmal().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorSharley = GetACSTransformationSharley().GetMovingAgentComponent().GetMovementAdjustor();

	movementAdjustorBlackWolf = GetACSTransformationBlackWolf().GetMovingAgentComponent().GetMovementAdjustor();

	if (playerVictim && npcAttacker)
	{
		if (ACS_Player_DamageTaken_Multiplier() != 1)
		{
			action.processedDmg.vitalityDamage *= ACS_Player_DamageTaken_Multiplier();
		}

		if (thePlayer.HasTag('ACS_Player_In_Everstorm_Distance_1'))
		{
			action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage;
		}
	}

    if ( playerVictim
	&& action.GetBuffSourceName() != "FallingDamage"
	&& !GetWitcherPlayer().HasTag('blood_sucking')
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Immortal
	&& GetWitcherPlayer().GetImmortalityMode() != AIM_Invulnerable
	&& !GetWitcherPlayer().IsDodgeTimerRunning()
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	/*
	&& (GetWitcherPlayer().HasTag('aard_sword_equipped')
	|| GetWitcherPlayer().HasTag('aard_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('yrden_sword_equipped')
	|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('quen_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('axii_sword_equipped')
	|| GetWitcherPlayer().HasTag('axii_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('quen_sword_equipped')
	|| GetWitcherPlayer().HasTag('igni_sword_equipped')
	|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('vampire_claws_equipped') )
	*/
	)
	{
		if (
		!action.IsDoTDamage()
		&& action.GetHitReactionType() != EHRT_Reflect
		&& !GetWitcherPlayer().IsInGuardedState()
		&& !GetWitcherPlayer().IsGuarded()
		&& !action.WasDodged()
		&& !GetWitcherPlayer().IsPerformingFinisher()
		&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
		&& action.GetBuffSourceName() != "vampirism" 
		)
		{
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

				dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;

				return;
			}
			
			if (ACS_Transformation_Activated_Check())
			{
				if (ACS_Transformation_Werewolf_Check())
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

						if (!GetACSTransformationWerewolf().HasTag('ACS_Werewolf_Berserk_Mode'))
						{
							movementAdjustorWerewolf.RotateTowards( ticketWerewolf, npcAttacker);
						}
					}
					else
					{
						if (!GetACSTransformationWerewolf().HasTag('ACS_Werewolf_Berserk_Mode'))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;

							movementAdjustorWerewolf.RotateTowards( ticketWerewolf, npcAttacker);
						}
						else
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
						}
					}

					ACS_Transformation_Werewolf_Hit_Animations();
				}
				
				if (ACS_Transformation_Vampiress_Check())
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
						if (GetACSTransformationVampiress().HasTag('ACS_Vampiress_Is_Parrying'))
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
						}
						else
						{
							if (!GetACSTransformationVampiress().HasTag('ACS_Vampiress_Sorceress_Mode'))
							{
								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
							}
						}
					}

					movementAdjustorVampiress.RotateTowards( ticketVampiress, npcAttacker);

					ACS_Transformation_Vampiress_Hit_Animations();
				}

				if (ACS_Transformation_Vampire_Monster_Check())
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
					else if (GetACSTransformationVampireMonster().HasTag('ACS_Transformation_Vampire_Monster_Is_Parrying')
					)
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
					}
					else
					{
						if (GetACSTransformationVampireMonster().HasTag('ACS_Transformation_Vampire_Monster_Blood_Armor')
						)
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.975;
						}
						{
							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
						}
					}

					if (GetACSTransformationVampireMonster().HasTag('ACS_Vampire_Monster_Ground_Mode'))
					{
						if (GetACSTransformationVampireMonster().HasTag('ACS_Transformation_Vampire_Monster_Is_Parrying'))
						{
							movementAdjustorTransformationVampireMonster.RotateTowards( ticketTransformationVampireMonster, npcAttacker);
						}
						else
						{
							if (!GetACSTransformationVampireMonster().HasTag('ACS_Transformation_Vampire_Monster_Blood_Armor'))
							{
								movementAdjustorTransformationVampireMonster.RotateTowards( ticketTransformationVampireMonster, npcAttacker);
							}
						}

						ACS_Transformation_Vampire_Monster_Hit_Animations();
					}
					else
					{
						if (GetACSTransformationVampireMonster().HasTag('ACS_Transformation_Vampire_Monster_Blood_Armor'))
						{
							GetACSTransformationVampireMonster().StopEffect('light_hit');
							GetACSTransformationVampireMonster().PlayEffectSingle('light_hit');

							GetACSTransformationVampireMonster().StopEffect('comming_out');
							GetACSTransformationVampireMonster().PlayEffectSingle('comming_out');

							GetACSTransformationVampireMonster().DestroyEffect('body_blood_drip');
							GetACSTransformationVampireMonster().PlayEffectSingle('body_blood_drip');
							GetACSTransformationVampireMonster().StopEffect('body_blood_drip');
						}
						else
						{
							GetACSTransformationVampireMonster().StopEffect('comming_out');
							GetACSTransformationVampireMonster().PlayEffectSingle('comming_out');
						}
					}
				}

				if (ACS_Transformation_Toad_Check())
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
				}

				if (ACS_Transformation_Red_Miasmal_Check())
				{
					if (GetACSTransformationRedMiasmal().HasTag('ACS_Transformation_Red_Miasmal_Rooted'))
					{
						GetACSTransformationRedMiasmal().StopEffect('teleport_roots_1');
						GetACSTransformationRedMiasmal().PlayEffectSingle('teleport_roots_1');

						GetACSWatcher().RedMiasmalLightAttackDamage360Actual();

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

							ACS_Transformation_Red_Miasmal_Hit_Animations();
						}
						else
						{
							GetACSTransformationRedMiasmal().StopEffect('teleport_roots_1');
							GetACSTransformationRedMiasmal().PlayEffectSingle('teleport_roots_1');

							GetACSWatcher().RedMiasmalLightAttackDamage360Actual();

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
						}
					}
				}

				if (ACS_Transformation_Sharley_Check())
				{
					((CNewNPC)GetACSTransformationSharley()).SetUnstoppable( true );

					if (GetACSTransformationSharley().HasTag('ACS_Sharley_Is_Spinning')
					|| GetACSTransformationSharley().HasTag('ACS_Sharley_Roll_Init')
					)
					{
						GetACSTransformationSharley().StopEffect('sonar');
						GetACSTransformationSharley().PlayEffectSingle('sonar');
						GetACSTransformationSharley().StopEffect('sonar');

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

							ACS_Transformation_Sharley_Hit_Animations();
						}
						else
						{
							GetACSTransformationSharley().StopEffect('sonar');
							GetACSTransformationSharley().PlayEffectSingle('sonar');
							GetACSTransformationSharley().StopEffect('sonar');

							GetACSWatcher().SharleyReflectDamage();

							action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.95;
						}
					}
				}

				if (ACS_Transformation_Black_Wolf_Check())
				{
					ticketBlackWolf = movementAdjustorBlackWolf.GetRequest( 'ACS_Transformation_Black_Wolf_Hit_Rotate');
					movementAdjustorBlackWolf.CancelByName( 'ACS_Transformation_Black_Wolf_Hit_Rotate' );
					movementAdjustorBlackWolf.CancelAll();

					ticketBlackWolf = movementAdjustorBlackWolf.CreateNewRequest( 'ACS_Transformation_Black_Wolf_Hit_Rotate' );
					movementAdjustorBlackWolf.AdjustmentDuration( ticketBlackWolf, 0.25 );
					movementAdjustorBlackWolf.MaxRotationAdjustmentSpeed( ticketBlackWolf, 500000 );

					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.85;

					movementAdjustorBlackWolf.RotateTowards( ticketBlackWolf, npcAttacker);

					ACS_Transformation_Black_Wolf_Hit_Animations();
				}

				return;
			}

			GetACSWatcher().RemoveTimer('RendProjectileSwitchDelay');

			if ( npcAttacker.HasTag('ACS_taunted') )
			{
				ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
				}

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				GetWitcherPlayer().SetPlayerTarget( npcAttacker );

				GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

				GetWitcherPlayer().UpdateDisplayTarget( true );

				GetWitcherPlayer().UpdateLookAtTarget();

				GetWitcherPlayer().RaiseEvent( 'AttackInterrupt' );

				if( !playerVictim.IsImmuneToBuff( EET_Bleeding ) && !playerVictim.HasBuff( EET_Bleeding ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Knockdown ) && !playerVictim.HasBuff( EET_Knockdown ) ) 
				{ 	
					if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

					movementAdjustor.CancelAll();

					playerVictim.AddEffectDefault( EET_Knockdown, npcAttacker, 'acs_HIT_REACTION' ); 							
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Drunkenness ) && !playerVictim.HasBuff( EET_Drunkenness ) ) 
				{ 	
					playerVictim.AddEffectDefault( EET_Drunkenness, npcAttacker, 'acs_HIT_REACTION' ); 							
				}

				ACS_PlayerHitEffects();

				GetWitcherPlayer().PlayEffectSingle('mutation_7_adrenaline_drop');
				GetWitcherPlayer().StopEffect('mutation_7_adrenaline_drop');
			}
			/*
			else if ( GetWitcherPlayer().GetStat(BCS_Focus) >= GetWitcherPlayer().GetStatMax(BCS_Focus) * 0.9
			&& GetWitcherPlayer().GetStat(BCS_Stamina) >= GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.5
			&& GetWitcherPlayer().GetStat(BCS_Vitality) <= GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.5
			)
			{
				if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
				}

				GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax(BCS_Focus) * 0.75 );

				if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
				{
					if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'HeavyArmor') )
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
					else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'MediumArmor') )
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.3;
					}
					else if( GetWitcherPlayer().GetInventory().ItemHasTag(item, 'LightArmor') )
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.4;
					}
					else
					{
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}
				else
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
				}

				ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				ACS_PlayerHitEffects();

				GetWitcherPlayer().PlayEffectSingle('special_attack_break');
				GetWitcherPlayer().StopEffect('special_attack_break');

				GetACSWatcher().ACS_Hit_Reaction();
			}
			*/
			else
			{
				if (ACS_Armor_Omega_Equipped_Check())
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
				else if (ACS_Armor_Alpha_Equipped_Check())
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

				if (npcAttacker.HasBuff(EET_Stagger)
				|| npcAttacker.HasBuff(EET_HeavyKnockdown)
				|| npcAttacker.HasBuff(EET_Knockdown)
				)
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;
				}
				else
				{
					ACS_PlayerHitEffects();

					if( GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_Armor, item) )
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
								ACS_ArmorSystem_Tutorial();

								GetWitcherPlayer().StopEffect('armor_sparks');
								GetWitcherPlayer().PlayEffectSingle('armor_sparks');

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

								GetWitcherPlayer().SoundEvent("grunt_vo_block");
								
								GetWitcherPlayer().SoundEvent("cmb_play_parry");

								dmg = new W3DamageAction in theGame.damageMgr;
					
								dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
								
								dmg.SetProcessBuffsIfNoDamage(true);
								
								dmg.SetHitReactionType( EHRT_Heavy, true);

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

								dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

								dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );
									
								theGame.damageMgr.ProcessAction( dmg );
									
								delete dmg;

								//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.2 );

								GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.2, 1, );

								npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
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
								ACS_ArmorSystem_Tutorial();

								GetWitcherPlayer().StopEffect('armor_sparks');
								GetWitcherPlayer().PlayEffectSingle('armor_sparks');

								GetWitcherPlayer().SoundEvent("grunt_vo_block");

								GetWitcherPlayer().SoundEvent("cmb_play_parry");

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.125;

								dmg = new W3DamageAction in theGame.damageMgr;
					
								dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
								
								dmg.SetProcessBuffsIfNoDamage(true);
								
								dmg.SetHitReactionType( EHRT_Heavy, true);

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

								dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

								dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );
									
								theGame.damageMgr.ProcessAction( dmg );
									
								delete dmg;

								//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15 );

								GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.15, 1, );

								npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
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
								ACS_ArmorSystem_Tutorial();
								
								GetWitcherPlayer().StopEffect('armor_sparks');
								GetWitcherPlayer().PlayEffectSingle('armor_sparks');

								GetWitcherPlayer().SoundEvent("grunt_vo_block");

								GetWitcherPlayer().SoundEvent("cmb_play_parry");

								action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.06125;

								dmg = new W3DamageAction in theGame.damageMgr;
					
								dmg.Initialize(GetWitcherPlayer(), npcAttacker, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
								
								dmg.SetProcessBuffsIfNoDamage(true);
								
								dmg.SetHitReactionType( EHRT_Heavy, true);

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

								dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax,damageMin) );

								dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax,damageMin) );
									
								theGame.damageMgr.ProcessAction( dmg );
									
								delete dmg;

								//GetWitcherPlayer().ForceSetStat( BCS_Stamina, (GetWitcherPlayer().GetStat( BCS_Stamina )) - GetWitcherPlayer().GetStatMax( BCS_Stamina ) * 0.15 );

								GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStatMax(BCS_Stamina) * 0.15, 1, );

								npcAttacker.ForceSetStat( BCS_Morale, npcAttacker.GetStatMax( BCS_Morale ) );
							}
						}
						else
						{
							GetACSWatcher().ACS_Combo_Mode_Reset_Hard();

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
						GetACSWatcher().ACS_Combo_Mode_Reset_Hard();
						
						action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.06125;

						if (!GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
						&& !GetWitcherPlayer().IsPerformingFinisher())
						{
							ACS_Hit_Animations(action);
						}
					}
				}
			}
		}		
	}
}

/*
function ACS_Death_Animations(action: W3DamageAction)
{
    var npcAttacker 									    : CActor;

	npcAttacker = (CActor)action.attacker;

    if(GetWitcherPlayer().HasTag('vampire_claws_equipped'))
    {
        if (GetWitcherPlayer().IsEnemyInCone( npcAttacker, GetWitcherPlayer().GetHeadingVector(), 50, 145, npcAttacker ))
        {
            GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_front_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
        }
        else
        {
           GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'bruxa_death_back_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
        }

        GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.5, false);
    }
    else
    {
        if( RandF() < 0.5 ) 
        { 																		
            if( RandF() < 0.5 ) 
            { 
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_right', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
            }
        }
        else
        {	
            if( RandF() < 0.5 ) 
            { 
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_wounded_knockdown_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 0.5, false);
            }
            else
            {
                GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_npc_sword_1hand_focus_throat_cut_death_ACS', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

                GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
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

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
	}
	else
	{
		GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( 'man_geralt_sword_tornado_left', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );

		GetACSWatcher().AddTimer('ACS_Death_Delay_Animation', 1.1, false);
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

	if (GetWitcherPlayer().HasTag('blood_sucking')
	|| GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
	|| GetWitcherPlayer().HasTag('yrden_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('yrden_sword_equipped')
	|| GetWitcherPlayer().IsCurrentlyDodging()
	|| GetWitcherPlayer().GetImmortalityMode() == AIM_Invulnerable
	|| GetWitcherPlayer().IsPerformingFinisher() 
	|| ACS_Armor_Omega_Equipped_Check()
	|| ACS_New_Replacers_Female_Active()
	)
	{
		return;
	}

	if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate_Fast();

		GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
	}

	GetACSWatcher().RemoveTimer('SignIconDelay');

	npcAttacker = (CActor)action.attacker;

	GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor().CancelAll();

	GetWitcherPlayer().ClearAnimationSpeedMultipliers();	

	hit_anim_names.Clear();
	
    if ( ( GetWitcherPlayer().HasTag('vampire_claws_equipped') && !GetWitcherPlayer().HasBuff(EET_BlackBlood) ) || GetWitcherPlayer().HasTag('aard_sword_equipped') )
    {
        GetACSWatcher().RemoveTimer('ACS_bruxa_tackle'); GetACSWatcher().RemoveTimer('ACS_portable_aard'); GetACSWatcher().RemoveTimer('ACS_shout');

		Bruxa_Camo_Decoy_Deactivate();

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
    else if(GetWitcherPlayer().HasTag('quen_sword_equipped'))
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
    else if( GetWitcherPlayer().HasTag('quen_secondary_sword_equipped') || GetWitcherPlayer().HasTag('aard_secondary_sword_equipped') )
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
    else if( GetWitcherPlayer().HasTag('axii_sword_equipped') )
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
    else if( GetWitcherPlayer().HasTag('axii_secondary_sword_equipped') )
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
	GetWitcherPlayer().HasTag('igni_sword_equipped')
	|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped')
	|| GetWitcherPlayer().HasTag('igni_sword_equipped_TAG')
	|| GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
	) 
    {
		if (ACS_Bear_School_Check()
		|| ACS_Forgotten_Wolf_Check()
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

	GetWitcherPlayer().GetRootAnimatedComponent().PlaySlotAnimationAsync( hit_anim_names[RandRange(hit_anim_names.Size())], 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0.25f, 0.875f) );	
}

function ACS_Transformation_Werewolf_Hit_Animations()
{
	var hit_anim_names	: array<name>;

	hit_anim_names.Clear();

	GetACSTransformationWerewolf().DestroyEffect('light_hit');
	GetACSTransformationWerewolf().DestroyEffect('heavy_hit');
	GetACSTransformationWerewolf().DestroyEffect('light_hit_back');
	GetACSTransformationWerewolf().DestroyEffect('heavy_hit_back');
	GetACSTransformationWerewolf().DestroyEffect('blood_spill');

	GetACSTransformationWerewolf().PlayEffectSingle('light_hit');
	GetACSTransformationWerewolf().PlayEffectSingle('heavy_hit');
	GetACSTransformationWerewolf().PlayEffectSingle('light_hit_back');
	GetACSTransformationWerewolf().PlayEffectSingle('heavy_hit_back');
	GetACSTransformationWerewolf().PlayEffectSingle('blood_spill');

	if (GetACSTransformationWerewolf().HasTag('ACS_Werewolf_Berserk_Mode'))
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
}

function ACS_Transformation_Vampiress_Hit_Animations()
{
	var vampiress_hit_anim_names	: array<name>;

	vampiress_hit_anim_names.Clear();

	GetACSWatcher().ACSVampiressRemoveAttackTimers();

	if (GetACSTransformationVampiress().HasTag('ACS_Vampiress_Is_Parrying'))
	{
		vampiress_hit_anim_names.PushBack('bruxa_parry_center');
		vampiress_hit_anim_names.PushBack('bruxa_parry_left');
		vampiress_hit_anim_names.PushBack('bruxa_parry_right');
		vampiress_hit_anim_names.PushBack('parry_left_01');
		vampiress_hit_anim_names.PushBack('parry_right_01');
		vampiress_hit_anim_names.PushBack('parry_left_back_01');
		vampiress_hit_anim_names.PushBack('parry_right_back_01');
		vampiress_hit_anim_names.PushBack('parry_left_back_02');
		vampiress_hit_anim_names.PushBack('parry_right_back_02');

		GetACSWatcher().ACSTransformVampiressPlayAnim(vampiress_hit_anim_names[RandRange(vampiress_hit_anim_names.Size())], 0.25f, 0.5f);
	}
	else
	{
		GetACSTransformationVampiress().DestroyEffect('light_hit');
		GetACSTransformationVampiress().DestroyEffect('heavy_hit');
		GetACSTransformationVampiress().DestroyEffect('light_hit_back');
		GetACSTransformationVampiress().DestroyEffect('heavy_hit_back');
		GetACSTransformationVampiress().DestroyEffect('blood_spill');

		GetACSTransformationVampiress().PlayEffectSingle('light_hit');
		GetACSTransformationVampiress().PlayEffectSingle('heavy_hit');
		GetACSTransformationVampiress().PlayEffectSingle('light_hit_back');
		GetACSTransformationVampiress().PlayEffectSingle('heavy_hit_back');
		GetACSTransformationVampiress().PlayEffectSingle('blood_spill');

		if (!GetACSTransformationVampiress().HasTag('ACS_Vampiress_Sorceress_Mode'))
		{
			vampiress_hit_anim_names.PushBack('bruxa_hit_heavy_front');
			vampiress_hit_anim_names.PushBack('bruxa_hit_light_front');
			vampiress_hit_anim_names.PushBack('reaction_hit_front');
			vampiress_hit_anim_names.PushBack('reaction_hit_front_left_down');
			vampiress_hit_anim_names.PushBack('reaction_hit_front_left_up');
			vampiress_hit_anim_names.PushBack('reaction_hit_front_down');
			vampiress_hit_anim_names.PushBack('reaction_hit_front_right_up');
			vampiress_hit_anim_names.PushBack('reaction_hit_front_left');
			vampiress_hit_anim_names.PushBack('reaction_hit_front_right');
			vampiress_hit_anim_names.PushBack('reaction_hit_front_up');
			vampiress_hit_anim_names.PushBack('reaction_hit_front_right_down');
		}
		else
		{
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_front');
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_front_down');
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_front_left');
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_front_left_up');
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_front_right');
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_front_right_down');
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_front_right_up');
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_front_up');
			vampiress_hit_anim_names.PushBack('woman_sorceress_hit_left_down');
		}

		GetACSWatcher().ACSTransformVampiressPlayAnim(vampiress_hit_anim_names[RandRange(vampiress_hit_anim_names.Size())], 0.25f, 0.5f);
	}
}

function ACS_Transformation_Vampire_Monster_Hit_Animations()
{
	var vampire_monster_hit_anim_names	: array<name>;

	vampire_monster_hit_anim_names.Clear();

	if (GetACSTransformationVampireMonster().HasTag('ACS_Transformation_Vampire_Monster_Is_Parrying'))
	{
		GetACSWatcher().ACSVampireMonsterRemoveAttackTimers();
		
		vampire_monster_hit_anim_names.PushBack('dettlaff_construct_parry_right');
		vampire_monster_hit_anim_names.PushBack('dettlaff_construct_parry_left');
		//vampire_monster_hit_anim_names.PushBack('dettlaff_construct_parry_double');
		vampire_monster_hit_anim_names.PushBack('dettlaff_construct_parry_single');
		vampire_monster_hit_anim_names.PushBack('dettlaff_construct_parry_double_last_atk');

		GetACSWatcher().ACSTransformVampireMonsterPlayAnim(vampire_monster_hit_anim_names[RandRange(vampire_monster_hit_anim_names.Size())], 0.25f, 0.25f);
	}
	else
	{
		if (GetACSTransformationVampireMonster().HasTag('ACS_Transformation_Vampire_Monster_Blood_Armor'))
		{
			GetACSTransformationVampireMonster().StopEffect('light_hit');
			GetACSTransformationVampireMonster().PlayEffectSingle('light_hit');

			GetACSTransformationVampireMonster().DestroyEffect('body_blood_drip');
			GetACSTransformationVampireMonster().PlayEffectSingle('body_blood_drip');
			GetACSTransformationVampireMonster().StopEffect('body_blood_drip');
		}
		else
		{
			GetACSWatcher().ACSVampireMonsterRemoveAttackTimers();

			vampire_monster_hit_anim_names.PushBack('detlaff_biped_hit_up_01');

			vampire_monster_hit_anim_names.PushBack('dettlaff_construct_recovery_ACS');

			GetACSWatcher().ACSTransformVampireMonsterPlayAnim(vampire_monster_hit_anim_names[RandRange(vampire_monster_hit_anim_names.Size())], 0.25f, 0.25f);
		}
	}
}

function ACS_Transformation_Red_Miasmal_Hit_Animations()
{
	var hit_anim_names	: array<name>;

	hit_anim_names.Clear();

	GetACSTransformationRedMiasmal().DestroyEffect('light_hit');
	GetACSTransformationRedMiasmal().DestroyEffect('heavy_hit');
	GetACSTransformationRedMiasmal().DestroyEffect('light_hit_back');
	GetACSTransformationRedMiasmal().DestroyEffect('heavy_hit_back');
	GetACSTransformationRedMiasmal().DestroyEffect('blood_spill');

	GetACSTransformationRedMiasmal().PlayEffectSingle('light_hit');
	GetACSTransformationRedMiasmal().PlayEffectSingle('heavy_hit');
	GetACSTransformationRedMiasmal().PlayEffectSingle('light_hit_back');
	GetACSTransformationRedMiasmal().PlayEffectSingle('heavy_hit_back');
	GetACSTransformationRedMiasmal().PlayEffectSingle('blood_spill');

	hit_anim_names.PushBack('monster_lessun_hit_light_f');
	hit_anim_names.PushBack('monster_lessun_hit_light_left');
	hit_anim_names.PushBack('monster_lessun_hit_light_right');
	hit_anim_names.PushBack('monster_lessun_hit_strong_f');
	hit_anim_names.PushBack('monster_lessun_hit_strong_left');
	hit_anim_names.PushBack('monster_lessun_hit_strong_right');

	GetACSWatcher().ACSTransformationRedMiasmalRemoveMoveTimers();

	GetACSWatcher().ACSTransformRedMiasmalPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.25f);
	
}

function ACS_Transformation_Sharley_Hit_Animations()
{
	var hit_anim_names	: array<name>;

	hit_anim_names.Clear();

	GetACSTransformationSharley().DestroyEffect('light_hit');
	GetACSTransformationSharley().DestroyEffect('heavy_hit');
	GetACSTransformationSharley().DestroyEffect('light_hit_back');
	GetACSTransformationSharley().DestroyEffect('heavy_hit_back');
	GetACSTransformationSharley().DestroyEffect('blood_spill');

	GetACSTransformationSharley().PlayEffectSingle('light_hit');
	GetACSTransformationSharley().PlayEffectSingle('heavy_hit');
	GetACSTransformationSharley().PlayEffectSingle('light_hit_back');
	GetACSTransformationSharley().PlayEffectSingle('heavy_hit_back');
	GetACSTransformationSharley().PlayEffectSingle('blood_spill');

	hit_anim_names.PushBack('hit_light_front');
	hit_anim_names.PushBack('hit_light_left');
	hit_anim_names.PushBack('hit_light_right');

	GetACSWatcher().ACSTransformationSharleyRemoveMoveTimers();

	GetACSWatcher().ACSTransformSharleyPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.25f);
}

function ACS_Transformation_Black_Wolf_Hit_Animations()
{
	var hit_anim_names	: array<name>;

	hit_anim_names.Clear();

	GetACSTransformationBlackWolf().DestroyEffect('light_hit');

	GetACSTransformationBlackWolf().PlayEffectSingle('light_hit');

	hit_anim_names.PushBack('wolf_hit_front');
	hit_anim_names.PushBack('wolf_hit_left');
	hit_anim_names.PushBack('wolf_hit_right');

	GetACSWatcher().ACSTransformationBlackWolfRemoveMoveTimers();

	GetACSWatcher().ACSTransformBlackWolfPlayAnim(hit_anim_names[RandRange(hit_anim_names.Size())], 0.25f, 0.25f);
}

function ACS_Forest_God_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var movementAdjustor									: CMovementAdjustor;
	var ticket 												: SMovementAdjustmentRequestTicket;
	var item												: SItemUniqueId;
	var dmg													: W3DamageAction;
	var damageMax, damageMin								: float;
	var curTargetVitality, maxTargetVitality, curTargetEssence, maxTargetEssence													: float;
	var params 																														: SCustomEffectParams;
	
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
	&& npcAttacker.HasTag('ACS_Forest_God')
	&& !action.IsDoTDamage()
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

							if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

							movementAdjustor.CancelAll();

							GetWitcherPlayer().DisplayHudMessage( "I SHALL FEAST UPON YOUR FRAGILITY" );

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
							if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}			

							npcAttacker.AddTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');
						}
						else if (npcAttacker.HasTag('ACS_Forest_God_1st_Hit_Melee_Unguarded'))
						{
							npcAttacker.RemoveTag('ACS_Forest_God_1st_Hit_Melee_Unguarded');

							if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

							GetWitcherPlayer().DisplayHudMessage( "I CRAVE THE ESSENCE OF YOUR FLESH" );

							if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
							
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
					if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
					
					movementAdjustor.CancelAll();

					if( RandF() < 0.5 ) 
					{
						GetWitcherPlayer().DisplayHudMessage( "NONE LEAVE THE SLAUGHTERHOUSE. NOT ALIVE." );
					}
					else
					{
						GetWitcherPlayer().DisplayHudMessage( "YOUR FEAR IS DELICIOUS. I WANT MORE." );
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
	}
}

function ACS_Forest_God_Shadows_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Forest_God_Shadows')
	&& !action.IsDoTDamage()
	)
	{	
		if (
			 GetWitcherPlayer().HasTag('igni_sword_equipped_TAG') || !GetWitcherPlayer().HasTag('igni_secondary_sword_equipped_TAG')
		)
		{
			if (playerVictim)
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (action.IsActionMelee())
					{
						npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.0125 );

						npcAttacker.GainStat( BCS_Stamina, npcAttacker.GetStatMax(BCS_Stamina) * 0.25 );

						//action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
					}
				}
			}
			else
			{
				npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.25 );

				npcAttacker.GainStat( BCS_Stamina, npcAttacker.GetStatMax(BCS_Stamina) * 0.5 );

				if (npc.UsesEssence())
				{
					npc.DrainEssence(npc.GetStatMax(BCS_Essence) * 0.25 );
				}
				else if (npc.UsesVitality())
				{
					npc.DrainVitality(npc.GetStatMax(BCS_Vitality) * 0.25 );
				}
			}
		}
		else
		{
			if (playerVictim)
			{
				if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
				{
					if (action.IsActionMelee())
					{
						npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.025 );

						npcAttacker.GainStat( BCS_Stamina, npcAttacker.GetStatMax(BCS_Stamina) * 0.25 );
					}	
				}
			}
			else
			{
				npcAttacker.GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.25 );

				npcAttacker.GainStat( BCS_Stamina, npcAttacker.GetStatMax(BCS_Stamina) * 0.5 );

				if (npc.UsesEssence())
				{
					npc.DrainEssence(npc.GetStatMax(BCS_Essence) * 0.25 );
				}
				else if (npc.UsesVitality())
				{
					npc.DrainVitality(npc.GetStatMax(BCS_Vitality) * 0.25 );
				}
			}
		}
	}
}

function ACS_Ice_Titan_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var animatedComponentA 									: CAnimatedComponent;
	var movementAdjustor									: CMovementAdjustor;
	var params 												: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animatedComponentA = (CAnimatedComponent)npc.GetComponentByClassName( 'CAnimatedComponent' );

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Ice_Titan')
	&& !action.IsDoTDamage()
	&& playerVictim
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

						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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

						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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
				if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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
	}
}

function ACS_Fire_Bear_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var movementAdjustor									: CMovementAdjustor;
	var params 												: SCustomEffectParams;
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	movementAdjustor = GetWitcherPlayer().GetMovingAgentComponent().GetMovementAdjustor();

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Fire_Bear')
	&& !action.IsDoTDamage()
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

						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
						
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

					if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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
				if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}
				
				movementAdjustor.CancelAll();

				//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' ); 							

				//playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'acs_HIT_REACTION' ); 		
			}					
		}
	}
}

function ACS_Knightmare_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Knightmare_Eternum')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (
					(ACS_W3EE_Installed() && ACS_W3EE_Enabled() )
					||
					(ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled() )
					)
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.5;
				}
				else
				{
					action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
				}
			}
		}
	}
}

function ACS_Eredin_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Eredin')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				if (
					(ACS_W3EE_Installed() && ACS_W3EE_Enabled() )
					||
					(ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled() )
					)
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.5;
				}
				else
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.5;
				}
			}
		}
		else
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;
		}
	}
}

function ACS_Canaris_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Canaris')
	&& !action.IsDoTDamage()
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
				GetACSCanarisMeleeEffect().StopEffect('explode');

				//action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.5;
			}
		}
		else
		{
			GetACSCanarisMeleeEffect().PlayEffectSingle('explode');
			GetACSCanarisMeleeEffect().StopEffect('explode');
		}
	}
}

function ACS_NightStalker_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Night_Stalker')
	&& !action.IsDoTDamage()
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
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					npcAttacker.GainStat( BCS_Essence, (npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat(BCS_Essence))  * 0.0125 );
				} 

				if (
					(ACS_W3EE_Installed() && ACS_W3EE_Enabled() )
					||
					(ACS_W3EE_Redux_Installed() && ACS_W3EE_Redux_Enabled() )
					)
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.5;
				}
				else
				{
					action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 2;
				}
			}
		}
	}
}

function ACS_XenoTyrant_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Xeno_Tyrant')
	&& !action.IsDoTDamage()
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

					if (GetACSXenoTyrant().HasAbility('mon_kikimore_small'))
					{
						GetACSXenoTyrant().RemoveAbility('mon_kikimore_small');
					}
				}

				if (npcAttacker.UsesVitality()) 
				{ 
					npcAttacker.GainStat( BCS_Vitality, (npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat(BCS_Vitality)) * 0.0125 );
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					npcAttacker.GainStat( BCS_Essence, (npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat(BCS_Essence)) * 0.0125 );
				} 

				action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.5;
			}
		}
	}
}

function ACS_XenoSoldier_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Xeno_Soldiers')
	&& !action.IsDoTDamage()
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

				if (GetACSXenoTyrant().UsesVitality()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.025 );
				} 
				else if (GetACSXenoTyrant().UsesEssence()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.025 );
				} 
			}
		}
	}
}

function ACS_XenoWorker_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Xeno_Workers')
	&& !action.IsDoTDamage()
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

				if (GetACSXenoTyrant().UsesVitality()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.05 );
				} 
				else if (GetACSXenoTyrant().UsesEssence()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
				} 
			}
		}
	}
}

function ACS_XenoArmoredWorker_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Xeno_Armored_Workers')
	&& !action.IsDoTDamage()
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

				if (GetACSXenoTyrant().UsesVitality()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Vitality, npcAttacker.GetStatMax(BCS_Vitality) * 0.05 );
				} 
				else if (GetACSXenoTyrant().UsesEssence()) 
				{ 
					GetACSXenoTyrant().GainStat( BCS_Essence, npcAttacker.GetStatMax(BCS_Essence) * 0.05 );
				} 
			}
		}
	}
}

function ACS_Unseen_Monster_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Vampire_Monster')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (action.IsActionMelee())
		{
			if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
			{
				action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 2;

				if (npcAttacker.UsesVitality()) 
				{ 
					ACSVampireMonsterBossBar().GainStat( BCS_Vitality, (ACSVampireMonsterBossBar().GetStatMax(BCS_Vitality) - ACSVampireMonsterBossBar().GetStat(BCS_Vitality)) * 0.025 );
				} 
				else if (npcAttacker.UsesEssence()) 
				{ 
					ACSVampireMonsterBossBar().GainStat( BCS_Essence, (ACSVampireMonsterBossBar().GetStatMax(BCS_Essence) - ACSVampireMonsterBossBar().GetStat(BCS_Essence))  * 0.025 );
				} 
			}
		}
	}
}

function ACS_Big_Lizard_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Big_Lizard')
	&& !action.IsDoTDamage()
	&& playerVictim
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
	}
}

function ACS_ShadowWolf_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Shadow_Wolf')
	&& !action.IsDoTDamage()
	&& playerVictim
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

			action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 2;
		}
	}
}

function ACS_Lynx_Witcher_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;


    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Lynx_Witcher')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if (!playerVictim.HasBuff(EET_Poison))
			{
				playerVictim.AddEffectDefault( EET_Poison, npcAttacker, 'ACS_Lynx_Witcher' );
			}
		}
	}
}

function ACS_Fluffy_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;


    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Fluffy')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if (!playerVictim.HasBuff(EET_Burning))
			{
				playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Fluffy' );
			}
		}
	}
}

function ACS_Melusine_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Melusine')
	&& !action.IsDoTDamage()
	&& !(((W3Action_Attack)action).IsParried())
	&& !action.WasDodged() 
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	&& playerVictim
	)
	{	
		if (!playerVictim.HasBuff(EET_Burning))
		{
			playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Melusine' );
		}
	}
}

function ACS_Melusine_Cloud_Attack(action: W3DamageAction)
{
   	var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Melusine_Cloud')
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

					if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}		
				}
			}
		}
	}
}

function ACS_Pirate_Zombie_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;


    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Pirate_Zombie')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if (!playerVictim.HasBuff(EET_Burning))
			{
				playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Pirate_Zombie' );
			}

			action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 0.5;
		}
	}
}

function ACS_Svalblod_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Svalblod')
	&& !action.IsDoTDamage()
	&& !action.WasDodged() 
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	&& playerVictim
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
	}
}


function ACS_Svalblod_Bear_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Svalblod_Bear')
	&& !action.IsDoTDamage()
	&& !action.WasDodged() 
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	&& playerVictim
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

		action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 3;
	}
}

function ACS_Berserkers_Bear_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Berserkers_Bear')
	&& !action.IsDoTDamage()
	&& !action.WasDodged() 
	&& !GetWitcherPlayer().IsCurrentlyDodging()
	&& playerVictim
	)
	{	
		action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage * 1.5;
	}
}

function ACS_Incubus_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Incubus')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
		}
	}
}

function ACS_Draug_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Draug')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			npc.SoundEvent("monster_cloud_giant_cmb_weapon_hit_add", 'head');

			if (!playerVictim.HasBuff(EET_Burning))
			{
				playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Draug' );
			}
		}
	}
}

function ACS_Fire_Gryphon_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Fire_Gryphon')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if (!playerVictim.HasBuff(EET_Burning))
			{
				playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Fire_Gryphon' );
			}
		}
	}
}

function ACS_MegaWraith_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_MegaWraith')
	&& !action.IsDoTDamage()
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

		GetACSMegaWraithLWeapon().StopEffect('light_trail_extended_fx');

		GetACSMegaWraithLWeapon().StopEffect('wraith_trail');

		GetACSMegaWraithLWeapon().StopEffect('special_trail_fx');

		if (!GetACSMegaWraithLWeapon().IsEffectActive('runeword_igni_green', false))
		{
			GetACSMegaWraithLWeapon().PlayEffectSingle('runeword_igni_green');
		}

		if (!GetACSMegaWraithLWeapon().IsEffectActive('runeword1_fire_trail_green', false))
		{
			GetACSMegaWraithLWeapon().PlayEffectSingle('runeword1_fire_trail_green');
		}

		if (!GetACSMegaWraithLWeapon().IsEffectActive('runeword_quen', false))
		{
			GetACSMegaWraithLWeapon().PlayEffectSingle('runeword_quen');
		}

		GetACSMegaWraithLWeapon().PlayEffectSingle('light_trail_extended_fx');

		GetACSMegaWraithLWeapon().PlayEffectSingle('wraith_trail');

		GetACSMegaWraithLWeapon().PlayEffectSingle('special_trail_fx');



		GetACSMegaWraithRWeapon().StopEffect('light_trail_extended_fx');

		GetACSMegaWraithRWeapon().StopEffect('wraith_trail');

		GetACSMegaWraithRWeapon().StopEffect('special_trail_fx');

		if (!GetACSMegaWraithRWeapon().IsEffectActive('runeword_igni_green', false))
		{
			GetACSMegaWraithRWeapon().PlayEffectSingle('runeword_igni_green');
		}

		if (!GetACSMegaWraithRWeapon().IsEffectActive('runeword1_fire_trail_green', false))
		{
			GetACSMegaWraithRWeapon().PlayEffectSingle('runeword1_fire_trail_green');
		}

		if (!GetACSMegaWraithRWeapon().IsEffectActive('runeword_quen', false))
		{
			GetACSMegaWraithRWeapon().PlayEffectSingle('runeword_quen');
		}

		GetACSMegaWraithRWeapon().PlayEffectSingle('light_trail_extended_fx');

		GetACSMegaWraithRWeapon().PlayEffectSingle('wraith_trail');

		GetACSMegaWraithRWeapon().PlayEffectSingle('special_trail_fx');

		if ( !action.WasDodged() && !(((W3Action_Attack)action).IsParried()) )
		{
			action.processedDmg.vitalityDamage += npc.GetMaxHealth() * 0.06125;
			action.processedDmg.essenceDamage += npc.GetMaxHealth() * 0.06125;
		}

		GetACSWatcher().ACS_CreateWraithDummy();
	}
}


function ACS_MegaWraithMinion_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_MegaWraith_Minion')
	&& !action.IsDoTDamage()
	)
	{	
		action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
	}
}

function ACS_Big_Hym_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Big_Hym')
	&& !action.IsDoTDamage()
	&& playerVictim
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
	}
}

function ACS_Mini_Hym_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;
	var size, speed											: float;
	var animcomp 											: CAnimatedComponent;
	var meshcomp 											: CComponent;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	animcomp = (CAnimatedComponent)npcAttacker.GetComponentByClassName('CAnimatedComponent');
	meshcomp = npcAttacker.GetComponentByClassName('CMeshComponent');	

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Mini_Hym')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		npcAttacker.StopEffect('special_attack_tell_r');
		npcAttacker.PlayEffectSingle('special_attack_tell_r');

		npcAttacker.StopEffect('special_attack_tell_l');
		npcAttacker.PlayEffectSingle('special_attack_tell_l');

		npcAttacker.StopEffect('blood');
		npcAttacker.PlayEffectSingle('blood');

		npcAttacker.StopEffect('blood_start');
		npcAttacker.PlayEffectSingle('blood_start');

		npcAttacker.StopEffect('blood_drain_fx2');
		npcAttacker.PlayEffectSingle('blood_drain_fx2');

		npcAttacker.StopEffect('blood_drain');
		npcAttacker.PlayEffectSingle('blood_drain');

		//npcAttacker.StopEffect('hand_fx_red');
		//npcAttacker.PlayEffectSingle('hand_fx_red');

		size = GetACSWatcher().GetMiniHymSize();

		speed = GetACSWatcher().GetMiniHymSpeed();

		GetACSWatcher().MiniHymSizeSpeedIncrement();

		npcAttacker.SetAnimationTimeMultiplier(speed);
			
		if (size < 1.5)
		{
			animcomp.SetScale(Vector(size,size,size,1));
			meshcomp.SetScale(Vector(size,size,size,1));	
		}
		else
		{
			GetACSWatcher().MiniHymSizeSpeedReset();
				
			ACS_Spawn_Big_Hym(npcAttacker,npcAttacker.GetWorldPosition());

			npcAttacker.Teleport(thePlayer.GetWorldPosition() + Vector(0,0,-200));

			npcAttacker.Destroy();
		}

		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_vein_hit_blood");

			GetWitcherPlayer().SoundEvent("monster_dettlaff_monster_combat_geralt_hit_claws");

			if (!playerVictim.HasBuff(EET_Bleeding))
			{
				playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Mini_Hym' );
			}

			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.9;
		}
	}
}

function ACS_Guardian_Hym_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& (npcAttacker.HasTag('ACS_Guardian_Blood_Hym_Small') || npcAttacker.HasTag('ACS_Guardian_Blood_Hym_Large'))
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
		}
	}
}

function ACS_Knocker_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& (npcAttacker.HasTag('ACS_Knocker'))
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.25;

			//thePlayer.AddEffectDefault( EET_Knockdown, thePlayer, 'ACS_Knocker' );
		}
	}
}

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

function ACS_Bumbakvetch_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Bumbakvetch')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

			action.processedDmg.vitalityDamage += GetWitcherPlayer().GetStatMax(BCS_Vitality) * 0.25f;

			thePlayer.AddEffectDefault( EET_Knockdown, thePlayer, 'ACS_Bumbakvetch' );
		}
	}
}

function ACS_Chironex_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Chironex')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.5;
		}
	}
}

function ACS_Botchling_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Botchling')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage;
		}
	}
}

function ACS_Draugir_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Draugir')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			action.processedDmg.vitalityDamage += action.processedDmg.vitalityDamage;
		}
	}
}

function ACS_Viy_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Viy_Of_Maribor')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			GetWitcherPlayer().SoundEvent("cmb_play_dismemberment_gore");

			action.processedDmg.vitalityDamage += GetWitcherPlayer().GetStat(BCS_Vitality) * 0.125f;

			thePlayer.AddEffectDefault( EET_Poison, ACSViyOfMaribor(), 'ACS_Viy_Of_Maribor' );

			thePlayer.AddEffectDefault( EET_HeavyKnockdown, ACSViyOfMaribor(), 'ACS_Viy_Of_Maribor' );
		}
	}
}

function ACS_Plumard_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Plumard')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if (!playerVictim.HasBuff(EET_Bleeding))
			{
				playerVictim.AddEffectDefault( EET_Bleeding, npcAttacker, 'ACS_Plumard' );
			}
		}
	}
}

function ACS_Demonic_Construct_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Demonic_Construct')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if (!playerVictim.HasBuff(EET_SlowdownFrost))
			{
				playerVictim.AddEffectDefault( EET_SlowdownFrost, npcAttacker, 'ACS_Demonic_Construct' );
			}
		}
	}
}


function ACS_Shades_Rogue_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Shades_Rogue')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage * 0.75;
		}
	}
}

function ACS_Dark_Knight_Calidus_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Dark_Knight_Calidus')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if (!playerVictim.HasBuff(EET_Burning))
			{
				playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Dark_Knight_Calidus' );
			}
		}
	}
}

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
	&& !action.IsDoTDamage()
	&& npc
	)
	{	
		if (!action.WasDodged() && !npc.IsCurrentlyDodging())
		{
			if (npc.HasBuff(EET_BlackBlood))
			{
				if (npcAttacker.UsesEssence())
				{
					npcAttacker.GainStat( BCS_Essence, ( npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat( BCS_Essence ) ) * 0.025 );
				}
				else if (npcAttacker.UsesVitality())
				{
					npcAttacker.GainStat( BCS_Vitality, ( npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat( BCS_Vitality ) ) * 0.025 );
				}
			}
			else
			{
				if (npcAttacker.UsesEssence())
				{
					npcAttacker.GainStat( BCS_Essence, ( npcAttacker.GetStatMax(BCS_Essence) - npcAttacker.GetStat( BCS_Essence ) ) * 0.075 );
				}
				else if (npcAttacker.UsesVitality())
				{
					npcAttacker.GainStat( BCS_Vitality, ( npcAttacker.GetStatMax(BCS_Vitality) - npcAttacker.GetStat( BCS_Vitality ) ) * 0.075 );
				}
			}
		}
	}
}

function ACS_Carduin_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Carduin')
	&& !action.IsDoTDamage()
	&& playerVictim
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if (!playerVictim.HasBuff(EET_Burning))
			{
				playerVictim.AddEffectDefault( EET_Burning, npcAttacker, 'ACS_Carduin' );
			}
		}
	}
}

function ACS_Fire_Gargoyle_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Fire_Gargoyle')
	&& !action.IsDoTDamage()
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
	}
}

function ACS_Vendigo_Attack(action: W3DamageAction)
{
    var playerAttacker, playerVictim						: CPlayer;
	var npc, npcAttacker 									: CActor;

    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

    if ( npcAttacker
	&& npcAttacker.HasTag('ACS_Vendigo')
	&& !action.IsDoTDamage()
	)
	{	
		if (!action.WasDodged() && !GetWitcherPlayer().IsCurrentlyDodging())
		{
			if ( playerVictim)
			{
				npc.SoundEvent("animals_deer_sniff");
				thePlayer.SoundEvent("animals_deer_sniff");

				npc.SoundEvent("animals_deer_breath");
				thePlayer.SoundEvent("animals_deer_breath");

				npc.SoundEvent("animals_deer_sniff");
				thePlayer.SoundEvent("animals_deer_sniff");

				npc.SoundEvent("animals_deer_breath");
				thePlayer.SoundEvent("animals_deer_breath");

				npc.SoundEvent("animals_deer_sniff");
				thePlayer.SoundEvent("animals_deer_sniff");

				npc.SoundEvent("animals_deer_breath");
				thePlayer.SoundEvent("animals_deer_breath");

				npc.SoundEvent("animals_deer_sniff");
				thePlayer.SoundEvent("animals_deer_sniff");

				npc.SoundEvent("animals_deer_breath");
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
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Summoned_Construct_Attack(action: W3DamageAction)
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
	&& (npcAttacker.HasTag('ACS_Summoned_Construct_1') || npcAttacker.HasTag('ACS_Summoned_Construct_2'))
	&& !action.IsDoTDamage()
	&& npc
	)
	{	
		if (!action.WasDodged() && !npc.IsCurrentlyDodging())
		{
			if ( npc )
			{
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

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );

				GetWitcherPlayer().GainStat(BCS_Vitality, damageMax );
					
				theGame.damageMgr.ProcessAction( dmg );
					
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

function ACS_Wolf_Companion_Attack(action: W3DamageAction)
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
	&& !action.IsDoTDamage()
	&& npc
	)
	{	
		if (!action.WasDodged() && !npc.IsCurrentlyDodging())
		{
			if ( npc )
			{
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

				dmg.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageMax );

				if(RandF() < 0.5)
				{
					dmg.AddEffectInfo( EET_Burning, 0.5 );
				}
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;
			}
		}
	}
}

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
	&& 
	(npcAttacker.HasTag('ACS_Revenant') 
	|| npcAttacker.HasTag('ACS_Summoned_Skeleton')
	|| npcAttacker.HasTag('ACS_Summoned_Wolf')
	|| npcAttacker.HasTag('ACS_Summoned_Centipede')
	)
	&& !action.IsDoTDamage()
	&& npc
	)
	{	
		if (!action.WasDodged() && !npc.IsCurrentlyDodging())
		{
			if ( npc )
			{
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

				dmg.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, damageMax );
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;
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

	if (
	npcAttacker
	&& playerVictim
	&& npcAttacker.HasTag('ACS_In_Rage') 
	&& !npcAttacker.HasTag('ACS_Forest_God')
	&& !npcAttacker.HasTag('ACS_Forest_God_Shadows')
	&& !action.IsDoTDamage()
	)
	{
		if (action.IsActionMelee())
		{
			ACS_Rage_Markers_Destroy();

			ACS_Rage_Markers_Player_Destroy();

			GetACSWatcher().RemoveTimer('ACS_Rage_Remove');
			GetACSWatcher().Rage_Remove_Actual();

			((CNewNPC)npcAttacker).SetAttitude(GetWitcherPlayer(), AIA_Hostile);

			if (action.WasDodged())
			{
				npcAttacker.RemoveBuffImmunity_AllNegative('ACS_Rage');

				npcAttacker.RemoveBuffImmunity_AllCritical('ACS_Rage');

				npcAttacker.SetImmortalityMode( AIM_None, AIC_Combat ); 

				npcAttacker.SetCanPlayHitAnim(true); 

				npcAttacker.DrainStamina( ESAT_FixedValue, npcAttacker.GetStat(BCS_Stamina)/2 );

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

				dmg.AddDamage( theGame.params.DAMAGE_NAME_PHYSICAL, RandRangeF(damageMax) );

				dmg.AddDamage( theGame.params.DAMAGE_NAME_SILVER, RandRangeF(damageMax) );

				dmg.AddEffectInfo( EET_Stagger, 2 );
					
				theGame.damageMgr.ProcessAction( dmg );
					
				delete dmg;

				return;
			}

			if (
			!GetWitcherPlayer().IsQuenActive(true)
			&& !action.WasDodged() 
			&& !GetWitcherPlayer().IsCurrentlyDodging()
			&& !GetWitcherPlayer().IsPerformingFinisher()
			&& !GetWitcherPlayer().HasTag('ACS_IsPerformingFinisher')
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

				ACS_Shield_Destroy(); 

				ticket = movementAdjustor.GetRequest( 'ACS_Player_Attacked_Rotate');
				movementAdjustor.CancelByName( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.CancelAll();
				ticket = movementAdjustor.CreateNewRequest( 'ACS_Player_Attacked_Rotate' );
				movementAdjustor.AdjustmentDuration( ticket, 0.25 );
				movementAdjustor.MaxRotationAdjustmentSpeed( ticket, 50000 );

				if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
				{
					GetACSWatcher().Grow_Geralt_Immediate_Fast();

					GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
				}

				thePlayer.ClearAnimationSpeedMultipliers();

				movementAdjustor.RotateTowards( ticket, npcAttacker );

				GetWitcherPlayer().SetPlayerTarget( npcAttacker );

				GetWitcherPlayer().SetPlayerCombatTarget( npcAttacker );

				GetWitcherPlayer().UpdateDisplayTarget( true );

				GetWitcherPlayer().UpdateLookAtTarget();

				GetWitcherPlayer().RaiseEvent( 'AttackInterrupt' );

				if (((CMovingPhysicalAgentComponent)(npcAttacker.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| npcAttacker.GetRadius() >= 0.7
				)
				{
					if( !playerVictim.IsImmuneToBuff( EET_HeavyKnockdown ) && !playerVictim.HasBuff( EET_HeavyKnockdown ) ) 
					{ 	
						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

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
						if(GetWitcherPlayer().IsAlive()){playerVictim.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );}

						movementAdjustor.CancelAll();

						//playerVictim.AddEffectDefault( EET_HeavyKnockdown, npcAttacker, 'acs_HIT_REACTION' );

						paramsKnockdown.effectType = EET_Stagger;
						paramsKnockdown.creator = npcAttacker;
						paramsKnockdown.sourceName = "ACS_Rage_Effect_Custom";
						paramsKnockdown.duration = 0.25;

						playerVictim.AddEffectCustom( paramsKnockdown ); 							
					}
				}
				
				if( !playerVictim.IsImmuneToBuff( EET_Drunkenness ) && !playerVictim.HasBuff( EET_Drunkenness ) ) 
				{ 	
					paramsDrunkEffect.effectType = EET_Drunkenness;
					paramsDrunkEffect.creator = npcAttacker;
					paramsDrunkEffect.sourceName = "ACS_Rage_Effect_Custom";
					paramsDrunkEffect.duration = 1;

					playerVictim.AddEffectCustom( paramsDrunkEffect );								
				}

				ACS_PlayerHitEffects();

				GetWitcherPlayer().PlayEffectSingle('mutation_7_adrenaline_drop');
				GetWitcherPlayer().StopEffect('mutation_7_adrenaline_drop');

				action.processedDmg.vitalityDamage -= action.processedDmg.vitalityDamage;

				action.processedDmg.vitalityDamage += GetWitcherPlayer().GetStat(BCS_Vitality) * 0.3;

				//GetWitcherPlayer().DrainVitality((GetWitcherPlayer().GetStat(BCS_Vitality) * 0.3) + 25);

				GetWitcherPlayer().DrainStamina( ESAT_FixedValue, GetWitcherPlayer().GetStat(BCS_Stamina) * 0.3 );

				GetWitcherPlayer().DrainFocus( GetWitcherPlayer().GetStatMax( BCS_Focus ) * 0.3 );

				GetWitcherPlayer().SoundEvent("cmb_play_hit_heavy");

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
	
    npc = (CActor)action.victim;
	
	npcAttacker = (CActor)action.attacker;
	
	playerAttacker = (CPlayer)action.attacker;
	
	playerVictim = (CPlayer)action.victim;

	if (
	npcAttacker
	&& playerVictim
	&& !action.IsDoTDamage()
	)
	{
		if (action.WasDodged()
		//|| (((W3Action_Attack)action).IsParried())
		|| (((W3Action_Attack)action).IsCountered())
		)
		{
			GetACSWatcher().RemoveTimer('RemoveACSSlowmo');

			if (ACS_DodgeSlowMo_Enabled())
			{
				ACS_PerfectDodgesCounters_Tutorial();
				GetACSWatcher().ACS_SlowMo();
			}
		}
	}
}

function ACS_ActionDealsFireDamage(action : W3DamageAction) : bool
{
	var i, size 				: int;
	var dmgTypes 				: array< SRawDamage >;

	action.GetDTs( dmgTypes );
	
	size = dmgTypes.Size();

	for(i=0; i<size; i+=1)
	{
		if( dmgTypes[i].dmgType == theGame.params.DAMAGE_NAME_FIRE )
		{
			return true;
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

				if(!theGame.IsDialogOrCutscenePlaying()
				&& !GetWitcherPlayer().IsUsingHorse() 
				&& !GetWitcherPlayer().IsUsingVehicle()
				&& npc.IsHuman()
				&& ((CNewNPC)npc).GetNPCType() != ENGT_Quest
				&& !npc.HasTag( 'ethereal' )
				&& !npc.HasTag( 'ACS_Berserkers_Human' )
				&& !npc.HasTag( 'ACS_Shades_Hunter' )
				&& !npc.HasTag( 'ACS_Shades_Crusader' )
				&& !npc.IsUsingHorse()
				&& !npc.IsUsingVehicle()
				&& !npc.HasTag('ACS_In_Rage')
				&& !npc.HasTag('ACS_Pre_Rage')
				
				&& !npc.HasTag('ACS_Final_Fear_Stack')

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

				&& !npc.HasTag('mq1060_witcher')

				&& StrFindFirst(voiceTagStr, "REINALD") < 0
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
							ACS_Dynamic_Enemy_Behavior_System_Tutorial();

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
		if( !npc.HasTag('ACS_Swapped_To_1h_Sword') )
		{
			//((CNewNPC)npc).AddBuffImmunity(EET_Knockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_HeavyKnockdown, 'ACS_Beh_Switch_Buff', true);

			//((CNewNPC)npc).AddBuffImmunity(EET_Ragdoll, 'ACS_Beh_Switch_Buff', true);

			npc.AttachBehavior( 'sword_1handed' );

			npc.SignalGameplayEvent( 'InterruptChargeAttack' );

			npc.SetAnimationSpeedMultiplier(1);

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

			npc.AddTag('ACS_Swapped_To_1h_Sword');
		}
	}

	latent function Sword2h_Switch( npc : CActor )
	{
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

			npc.SetAnimationSpeedMultiplier(1.15);

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

			npc.AddTag('ACS_Swapped_To_2h_Sword');
		}
	}

	latent function Witcher_Switch( npc : CActor )
	{
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

			npc.SetAnimationSpeedMultiplier(0.875);

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

			npc.AddTag('ACS_Swapped_To_Witcher');
		}
	}

	latent function Shield_Switch( npc : CActor )
	{
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

			npc.SetAnimationSpeedMultiplier(1.25);

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

			shield_temp = (CEntityTemplate)LoadResourceAsync( 
		
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

			npc.AddEffectDefault( EET_Stagger, GetWitcherPlayer(), 'ACS_Beh_Swich_Effect' ); 

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