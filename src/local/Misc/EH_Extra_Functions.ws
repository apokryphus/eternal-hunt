// Created and designed by error_noaccess, exclusive to the Wolven Workshop discord server and Github. 
// Not authorized to be distributed elsewhere, unless you ask me nicely.

function ACS_Custom_Attack_Range( data : CPreAttackEventData ) : array< CGameplayEntity >
{
	var targets 					: array<CGameplayEntity>;
	var dist, ang, heightCheck		: float;
	var pos, targetPos				: Vector;
	var i							: int;
	var npc							: CNewNPC;

	npc = (CNewNPC)(thePlayer.GetTarget());
	
	if (!thePlayer.IsPerformingFinisher())
	{
		if ( thePlayer.IsWeaponHeld( 'fist' ) )
		{
			dist = 1.25;
			ang = 45;

			if ( thePlayer.HasTag('acs_vampire_claws_equipped') )
			{
				dist += 0.25;
				ang += 30;

				if ( thePlayer.HasBuff(EET_BlackBlood))
				{
					dist += 1.75;
					ang += 30;
				}

				if ( thePlayer.HasBuff(EET_Mutagen22) || ACS_Armor_Set_Check('acs_armor', false))
				{
					dist += 2.75;
					ang += 60;
				}
			}
		}
		else
		{
			if ( 
			thePlayer.HasTag('acs_igni_sword_equipped_TAG') 
			|| thePlayer.HasTag('acs_igni_sword_equipped') 
			)
			{
				dist = 1.5;
				ang =	70;

				if(  thePlayer.IsDoingSpecialAttack( false ) 
				|| GetACSWatcher().silver_group_stance
				|| GetACSWatcher().steel_group_stance
				)
				{
					dist += 0.5;
					ang +=	290;
				}

				if(  thePlayer.IsDoingSpecialAttack( false ) 
				|| GetACSWatcher().silver_fast_stance
				|| GetACSWatcher().steel_fast_stance
				|| GetACSWatcher().silver_strong_stance
				|| GetACSWatcher().steel_strong_stance
				)
				{
					dist += 0.75;
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
			else if ( thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG') 
			|| thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
			)
			{
				dist = 1.5;
				ang =	70;

				if(  thePlayer.IsDoingSpecialAttack( false ) 
				|| GetACSWatcher().silver_group_stance
				|| GetACSWatcher().steel_group_stance
				)
				{
					dist += 1;
					ang +=	290;
				}

				if(  thePlayer.IsDoingSpecialAttack( false ) 
				|| GetACSWatcher().silver_fast_stance
				|| GetACSWatcher().steel_fast_stance
				|| GetACSWatcher().silver_strong_stance
				|| GetACSWatcher().steel_strong_stance
				)
				{
					dist += 0.75;
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
			else if ( thePlayer.HasTag('acs_axii_sword_equipped') )
			{
				dist = 1.6;
				ang =	70;	

				if (thePlayer.HasTag('ACS_Sparagmos_Active'))
				{
					dist += 10;
					ang +=	30;
				}
			}
			else if ( thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			{
				if ( 
				ACS_GetWeaponMode() == 0
				|| ACS_GetWeaponMode() == 1
				|| ACS_GetWeaponMode() == 2
				)
				{
					dist = 2.25;
					ang =	70;
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{ 
					dist = 1.75;
					ang =	70;
				}
			}
			else if ( thePlayer.HasTag('acs_aard_sword_equipped') )
			{
				if (thePlayer.HasTag('ACS_Chain_Weapon_Expand')) 
				{
					dist = 7.5;
					ang =	90;	
				}
				else
				{
					dist = 2;
					ang =	75;	
				}
			}
			else if ( thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			{
				dist = 2;
				ang = 70;
			}
			else if ( thePlayer.HasTag('acs_yrden_sword_equipped') )
			{
				if ( ACS_GetWeaponMode() == 0 )
				{
					if (ACS_Settings_Main_Int('acs_armiger_mode_settings','acs_armiger_mode_weapon_type', 0) == 0)
					{
						dist = 2.5;
						ang = 70;
					}
					else 
					{
						dist = 2;
						ang = 70;
					}
				}
				else if ( ACS_GetWeaponMode() == 1 )
				{
					if (ACS_Settings_Main_Int('acs_focus_mode_settings','acs_focus_mode_weapon_type', 0) == 0)
					{
						dist = 2.5;
						ang = 70;
					}
					else 
					{
						dist = 2;
						ang = 70;
					}
				}
				else if ( ACS_GetWeaponMode() == 2 )
				{
					if (ACS_Settings_Main_Int('acs_hybrid_mode_settings','acs_hybrid_mode_weapon_type', 0) == 0)
					{
						dist = 2.5;
						ang = 70;
					}
					else 
					{
						dist = 2;
						ang = 70;
					}
				}
				else if ( ACS_GetWeaponMode() == 3 )
				{
					dist = 2.5;
					ang = 70;
				}
			}
			else if ( thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			{
				dist = 3.5;
				ang =	180;
			}
			else if ( thePlayer.HasTag('acs_quen_sword_equipped') )
			{
				dist = 1.6;
				ang =	70;

				if (thePlayer.HasTag('ACS_Shadow_Dash_Empowered'))
				{
					ang +=	320;
				}
			}
			else if ( thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
			{
				if (thePlayer.HasTag('ACS_Storm_Spear_Active'))
				{
					dist = 10;
					ang =	30;
				}
				else
				{
					dist = 2.25;
					ang =	70;
				}
			}
			else 
			{
				dist = 1.25;
				ang = 30;
			}

			if (ACS_Armor_Set_Check('acs_armor', false))
			{
				if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
				{
					if( !thePlayer.IsDoingSpecialAttack( false )
					&& !thePlayer.IsDoingSpecialAttack( true ) )
					{
						dist += 1.5;
					}
				}
				else
				{
					dist += 1.5;
				}
			}
		}

		if ( thePlayer.GetTarget().HasTag('ACS_Big_Boi')
		|| thePlayer.GetTarget().HasAbility('mon_toad_base')
		|| thePlayer.GetTarget().HasAbility('mon_type_huge')
		|| ((CMovingPhysicalAgentComponent)(npc.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
		|| npc.GetRadius() >= 0.7
		)
		{
			dist += 0.5;
			ang += 15;
		}

		if (ACS_Settings_Main_Float('acs_visual_main_settings','acs_player_scale', 1) > 1)
		{
			dist += ACS_Settings_Main_Float('acs_visual_main_settings','acs_player_scale', 1) * 0.75;
		}
		else if (ACS_Settings_Main_Float('acs_visual_main_settings','acs_player_scale', 1) < 1)
		{
			dist -= ACS_Settings_Main_Float('acs_visual_main_settings','acs_player_scale', 1) * 0.5;
		}

		if( thePlayer.HasAbility('Runeword 2 _Stats', true) 
		&& !thePlayer.HasTag('acs_igni_sword_equipped') 
		&& !thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
		&& !ACS_Armor_Set_Check('acs_armor', false))
		{
			dist += 1;
		}

		if (thePlayer.IsUsingHorse()
		) 
		{
			dist += 1.5;

			ang += 270;
		}

		if (thePlayer.HasTag('ACS_Spear_Transform_Active')
		) 
		{
			dist += 1.5;
		}

		if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
		{
			dist += 1.5;

			ang += 315;
		}

		if (thePlayer.HasTag('ACS_In_Dance_Of_Wrath'))
		{
			dist += 1.5;

			ang += 90;
		}

		if (thePlayer.HasTag('ACS_In_Heavenly_Strike'))
		{
			dist += 2.5;

			ang += 365;
		}

		if (ACS_Armor_Set_Check('bear', true))
		{
			dist += 0.5;
			ang +=	15;

			if (thePlayer.HasTag('ACS_Bear_Special_Attack'))
			{
				dist += 1.5;
			}
		}

		if (ACS_Armor_Set_Check('griffin', true)
		&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
		{
			dist += 2;
			ang +=	15;
		}

		if (ACS_Armor_Set_Check('manticore', true))
		{
			dist += 0.5;
		}

		if (ACS_Armor_Set_Check('viper', true))
		{
			if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
			{
				dist += 1.5;
			}
		}

		if (data.attackName == 'counter_attack_light'
		)
		{
			dist += 0.5;
			ACS_Attack_Trail('light_trail_fx');
		}

		if (thePlayer.HasTag('ACS_Air_Time')
		)
		{
			dist += 2;
		}

		if (thePlayer.HasTag('ACS_Feainnewedd_Dance'))
		{
			dist += 2;

			ang +=	90;
		}

		if (thePlayer.HasTag('ACS_Mortal_Draw'))
		{
			dist += 6;

			ang +=	90;
		}

		if (thePlayer.HasTag('ACS_ShadowFall')
		|| thePlayer.HasTag('ACS_Horse_Dismount_Jump_Attack')
		|| ACSGetCEntity('ACS_Horse_Jump_Aim_Entity')
		)
		{
			dist += 2;

			ang +=	90;
		}

		if (
		ACS_GetItem_Sword_IsEquipped('jingubang_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('jingubang_silver', 'silver'))
		{
			if (
			thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus))
			{
				dist += 2;
			}
		}

		if (
		ACS_GetItem_Sword_IsEquipped('longsword_steel', 'steel') || ACS_GetItem_Sword_IsEquipped('longsword_silver', 'silver'))
		{
			dist += 1;

			if (ACSGetCEntity('ACS_SwordExtensionStream'))
			{
				dist += 1;
			}
		}

		if (ACSGetCActor('ACS_Gravehag_Tongue_Weapon_R'))
		{
			dist += 3.5;

			ang +=	60;

			if (ACSGetCActor('ACS_Gravehag_Tongue_Weapon_R').HasTag('ACS_Mourntart_Tongue'))
			{
				dist += 1;

				ang +=	30;
			}
		}

		if ( data.attackName == 'acs_attack_poison')
		{
			dist = 1.25;
			ang =	70;
		}

		if (ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel'))
		{
			dist += 5.5;

			ang +=	60;
		}
	}
	else 
	{
		dist = 1.125;
		ang = 30;
	}

	targets.Clear();

	pos = thePlayer.GetWorldPosition();
	pos.Z += 0.8;

	heightCheck = 2.5;

	if ( FactsQuerySum("ACS_Mounted_Attack_Attachment_Active") > 0 )
	{
		heightCheck += 1;
	}

	if (thePlayer.HasTag('ACS_Feainnewedd_Dance'))
	{
		heightCheck += 7.5;
	}

	if (thePlayer.HasTag('ACS_ShadowFall')
	|| ACSGetCEntity('ACS_Horse_Jump_Aim_Entity')
	|| thePlayer.HasTag('ACS_Horse_Dismount_Jump_Attack')
	)
	{
		heightCheck += 3.5;
	}

	FindGameplayEntitiesInCone( targets, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetWorldForward() ), ang, dist, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
	for( i = targets.Size()-1; i >= 0; i -= 1 ) 
	{	
		targetPos = targets[i].GetWorldPosition();
		if ( AbsF( targetPos.Z - pos.Z ) > heightCheck )
		{
			targets.EraseFast(i);
		}
	}	

	return targets;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Main Settings


function ACSSettingsGetConfigValue(menuName, menuItemName : name) : string
{
	var conf: CInGameConfigWrapper;
	var value: string;
	
	conf = theGame.GetInGameConfigWrapper();
	
	value = conf.GetVarValue(menuName, menuItemName);

	return value;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Settings_Main_Bool( groupName, entryName : name, defaultValue : bool ) : bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue(groupName,entryName);
	configValue =(int) configValueString;
	
	if(configValueString=="" || configValue<0)
	{
		return defaultValue;
	}

	else return (bool)configValueString;
}

function ACS_Settings_Main_Int( groupName, entryName : name, defaultValue : int, optional forceDefaultValue : bool ) : int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue(groupName,entryName);
	configValue =(int) configValueString;

	if(configValueString=="")
	{
		return defaultValue;
	}

	if(forceDefaultValue && configValue<0)
	{
		return defaultValue;
	}
	
	else return configValue;
}

function ACS_Settings_Main_Float( groupName, entryName : name, defaultValue : float, optional forceDefaultValue : bool ): float 
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue(groupName,entryName);
	configValue =(float) configValueString;

	if(configValueString=="")
	{
		return defaultValue;
	}

	if(forceDefaultValue && configValue<0)
	{
		return defaultValue;
	}
	
	else return configValue;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_VersionControl(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_main_settings','acs_version_control');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return ACS_GetVersion();
	}
	
	else return configValue;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_InitializeSettings() 
{
	theGame.GetInGameConfigWrapper().SetVarValue('acs_main_settings', 'acs_mod_enabled', "true");

	theGame.GetInGameConfigWrapper().SetVarValue('acs_main_settings', 'acs_init', "true");

	theGame.GetInGameConfigWrapper().SetVarValue('acs_main_settings', 'acs_version_control', ACS_GetVersion());

	theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'Minimap2Module', "false");

	theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'QuestsModule', "false");

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_combat_main_settings', 3);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_parry_skills_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_target_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_custom_finishers_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_rage_mechanic_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_sign_combo_system_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_armiger_mode_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_focus_mode_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hybrid_mode_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_movement_settings', 1);
	
	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_taunt_settings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_damage_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_movement_main_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_misc_main_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_container_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_cbs_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_firesources_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_horse_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_item_management_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_meditation_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_player_misc_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_signs_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_visual_main_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_player_equipment_visual_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_world_visual_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_main', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_camera_settings_main', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_focus_mode', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_markers', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_all', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_buffs', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_wolf_medallion', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_minimap_and_quests', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_item_info', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_control_hints_and_action_log', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_horse_stamina_and_fear_bar', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_oxygen_bar_and_boat_health', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_boss_and_comp', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_hud_settings_positioning_enemy', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_stamina_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_encounters_enhanced_abilities_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_encounters_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_encounters_drop_rate_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_events_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_additional_world_encounters_settings', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_dodge_settings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_default_geralt_moveset_dodge_and_roll_override_settings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_jump_settings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_bruxa_dash_settings', 1);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_main', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_novigrad', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_skellige', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_kaer_morhen', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_white_orchard', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_wyzima', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_mist_isle', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_spiral', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_winter_white_orchard', 0);

	theGame.GetInGameConfigWrapper().ApplyGroupPreset('acs_darkness_settings_toussaint', 0);

	theGame.SaveUserSettings();
}

// Combat Main Settings

function ACS_GetWeaponMode(): int 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_combat_main_settings','acs_weapon_mode');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return 3;
	}

	if(configValueString=="" || configValue<0)
	{
		return 3;
	}
	
	else return configValue;
}

function ACS_DefaultMovesetCombatAnimationOverrideMode_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_combat_main_settings','acs_default_moveset_combat_animation_override_enabled');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return false;
	}

	if (thePlayer.HasBuff(EET_AirDrain)
	|| thePlayer.HasBuff(EET_Choking)
	|| thePlayer.HasBuff(EET_Drowning)
	)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Counterattack/Parry Skill Settings

function ACS_GetParrySkillsBind( skill_type : name ) : ACS_ParrySkillsBind 
{
	var dagger_bind : int;

	switch(skill_type)
	{
		case 'dagger':
			dagger_bind = ACS_Settings_Main_Int('acs_parry_skills_settings','acs_dagger_bind', 6);
		break;

		case 'push':
			dagger_bind = ACS_Settings_Main_Int('acs_parry_skills_settings','acs_push_skills_bind', 5);
		break;

		case 'parry':
			dagger_bind = ACS_Settings_Main_Int('acs_parry_skills_settings','acs_parry_skills_bind', 1);
		break;

		default:
			dagger_bind = ACS_Settings_Main_Int('acs_parry_skills_settings','acs_parry_skills_bind', 1);
		break;
	}

	return dagger_bind;
}

enum ACS_ParrySkillsBind 
{
	ACS_ParrySkillsBind_Forward = 0,
	ACS_ParrySkillsBind_Backward = 1,
	ACS_ParrySkillsBind_Left = 2,
	ACS_ParrySkillsBind_Right = 3,
	ACS_ParrySkillsBindForwardOrBackward = 4,
	ACS_ParrySkillsBind_LeftOrRight = 5,
	ACS_ParrySkillsBind_LightAttack = 6,
	ACS_ParrySkillsBind_HeavyAttack = 7,
	ACS_ParrySkillsBind_None = 8
}

// Custom Finishers Settings

function ACS_GetFinishersBind( finisher_type : name ): ACS_CustomFinisherBind 
{
	var finisher_bind : int;

	switch(finisher_type)
	{
		case 'leg_right':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_leg_right_bind', 8);
		break;

		case 'leg_left':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_leg_left_bind', 7);
		break;

		case 'arm_right':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_arm_right_bind', 6);
		break;

		case 'arm_left':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_arm_left_bind', 5);
		break;

		case 'head_right':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_head_right_bind', 4);
		break;

		case 'head_left':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_head_left_bind', 3);
		break;

		case 'neck':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_neck_bind', 2);
		break;

		case 'stab':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_stab_bind', 0);
		break;

		case 'torso':
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_torso_bind', 1);
		break;

		default:
			finisher_bind = ACS_Settings_Main_Int('acs_custom_finishers_settings','acs_custom_finishers_torso_bind', 1);
		break;
	}

	return finisher_bind;
}

enum ACS_CustomFinisherBind 
{
	ACS_CustomFinisherBind_None = 0,
	ACS_CustomFinisherBind_Forward = 1,
	ACS_CustomFinisherBind_Backward = 2,
	ACS_CustomFinisherBind_Left = 3,
	ACS_CustomFinisherBind_Right = 4,
	ACS_CustomFinisherBind_ForwardLeft = 5,
	ACS_CustomFinisherBind_ForwardRight = 6,
	ACS_CustomFinisherBind_BackwardLeft = 7,
	ACS_CustomFinisherBind_BackwardRight = 8
}

// Rage Mechanic Settings

function ACS_RageMechanic_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_rage_mechanic_settings','acs_rage_mechanic');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return false;
	}

	if (FactsQuerySum("ACS_Mounted_Attack_Attachment_Active") > 0 )
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_RageMechanicCooldown(): float
{
	var configValue :float;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_rage_mechanic_settings','acs_rage_mechanic_cooldown');
	configValue =(float) configValueString;

	if(configValueString=="" || configValue<0)
	{
		return 14;
	}
	else if (configValue <= 4)
	{
		return 4;
	}
	
	else return configValue;
}

// Sign Combo System Settings

function ACS_SignComboSystem_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_sign_combo_system_settings','acs_sign_combo_system');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Dodge Settings

function ACS_DodgeSlowMo_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_dodge_settings','acs_dodge_slowmo');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_HoldToRoll_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_dodge_settings','acs_hold_to_roll');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_CombatSlide_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_dodge_settings','acs_combat_slide');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return false;
	}

	if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

// Default Geralt Moveset Dodge and Roll Override Settings

function ACS_DefaultGeraltMovesetOverrideModeDodge_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_dodge_enabled');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return false;
	}

	if (thePlayer.HasBuff(EET_AirDrain)
	|| thePlayer.HasBuff(EET_Choking)
	|| thePlayer.HasBuff(EET_Drowning)
	)
	{
		return false;
	}

	else if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

function ACS_DefaultGeraltMovesetOverrideModeRoll_Enabled(): bool 
{
	var configValue :int;
	var configValueString : string;
	
	configValueString = ACSSettingsGetConfigValue('acs_default_geralt_moveset_dodge_and_roll_override_settings','acs_default_moveset_override_roll_enabled');
	configValue =(int) configValueString;

	if( 
	FactsQuerySum("q001_nightmare_ended") <= 0
	&& FactsQuerySum("q001_unlocked_door") > 0
	)
	{
		return false;
	}

	if (thePlayer.HasBuff(EET_AirDrain)
	|| thePlayer.HasBuff(EET_Choking)
	|| thePlayer.HasBuff(EET_Drowning)
	)
	{
		return false;
	}

	else if(configValueString=="" || configValue<0)
	{
		return true;
	}
	
	else return (bool)configValueString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Is_DLC_Installed( dlcName : name ): bool
{
	if (theGame.GetDLCManager().IsDLCAvailable(dlcName) 
	&& theGame.GetDLCManager().IsDLCEnabled(dlcName)
	)
	{
		return true;	
	}

	return false;
}

function ACS_New_Replacers_Female_Active(): bool
{
	if (ACS_Is_DLC_Installed('dlc_newreplacers') 
	&& FactsQuerySum("nr_player_female") > 0
	
	)
	{
		return true;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_SwordHeldSwitchBasedUponStat(stat_name: name): bool
{
	var sword_id 		: SItemUniqueId;
	var poisonChance   	: float;
	var freezingChance  : float;
	var bleedChance   	: float;

	if (thePlayer.IsWeaponHeld('steelsword'))
	{
		thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

		freezingChance = CalculateAttributeValue(thePlayer.GetInventory().GetItemAttributeValue(sword_id, 'desc_freezingchance_mult'));

		poisonChance = CalculateAttributeValue(thePlayer.GetInventory().GetItemAttributeValue(sword_id, 'desc_poinsonchance_mult'));

		bleedChance = CalculateAttributeValue(thePlayer.GetInventory().GetItemAttributeValue(sword_id, 'desc_bleedingchance_mult'));
	}
	else if (thePlayer.IsWeaponHeld('silversword'))
	{
		thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

		freezingChance = CalculateAttributeValue(thePlayer.GetInventory().GetItemAttributeValue(sword_id, 'desc_freezingchance_mult'));

		poisonChance = CalculateAttributeValue(thePlayer.GetInventory().GetItemAttributeValue(sword_id, 'desc_poinsonchance_mult'));

		bleedChance = CalculateAttributeValue(thePlayer.GetInventory().GetItemAttributeValue(sword_id, 'desc_bleedingchance_mult'));
	}

	switch(stat_name)
	{
		case 'bleed_sword':
			if(GetWitcherPlayer().GetEquippedSign() == ST_Igni )
			{
				return false;
			}

			if( 
			(bleedChance > freezingChance && bleedChance > poisonChance)
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}
			
		break;

		case 'poison_sword':

			if(GetWitcherPlayer().GetEquippedSign() == ST_Igni )
			{
				return false;
			}

			if( 
			(poisonChance > freezingChance && poisonChance > bleedChance)
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

		break;

		case 'frost_sword':

			if (ACS_Armor_Set_Check('wh_armor', false)
			|| ACS_Armor_Set_Check('eredin_armor', false)
			|| ACS_Armor_Set_Check('imlerith_armor', false)
			|| ACS_Armor_Set_Check('caranthir_armor', false)
			|| ACS_Armor_Set_Check('vgx_eredin_armor', false))
			{
				return true;
			}

			if(GetWitcherPlayer().GetEquippedSign() == ST_Igni )
			{
				return false;
			}

			if( 
			(thePlayer.GetInventory().GetItemName( sword_id ) == 'q402 Skellige sword 3'
			|| (freezingChance > poisonChance && freezingChance > bleedChance)
			)
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

		break;

		default:
			return false;
		break;
	}
	

	return false;

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_Sword_IsEquipped(sword_name: name, sword_slot : name): bool
{
	var sword_id 						: SItemUniqueId;
	var i								: int;
	var playerHeldWeapons				: array<SItemUniqueId>;

	switch (sword_slot)
	{
		case 'secondary_weapon':
			playerHeldWeapons = thePlayer.GetInventory().GetHeldWeapons();
	
			for( i = 0 ; i < playerHeldWeapons.Size() ; i+=1 )
			{
				if( thePlayer.GetInventory().IsItemSecondaryWeapon( playerHeldWeapons[i] ) )
				{
					sword_id = playerHeldWeapons[i];
				}
			}
			
		break;

		case 'silver':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, sword_id);
		break;

		case 'steel':
			GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, sword_id);
		break;

		default:
			return false;
		break;
	}

	switch (sword_name)
	{
		case 'one_hand_axe_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 2' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Axe'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Hammer'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pickaxe'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Shovel'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Scythe'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Fishingrodx'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kama_silver'
			)
			{
				return true;
			}

			return false;
		break;

		case 'axe_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 2' 	
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Axe'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Q1_ZoltanAxe2hx'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Hammer'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1_Silver' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2_Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Demonic_Construct_Hammer'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa gae bolg silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sotp ardyn'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'aotc ardyn'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'motf ardyn'
			)
			{
				return true;
			}

			return false;
		break;

		case 'hammer_silver':
			if( 

			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'
			
			)
			{
				return true;
			}

			return false;
		break;

		case 'greg_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn 1' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Blade 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Realmdrifter Divider 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Claymore 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Icarus Tears 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hades Grasp 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Graveripper 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oblivion 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Dragonbane 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Crownbreaker 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Beastcutter 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Blackdawn 2' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword1_silver'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword2_silver'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword3_silver'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'maltonge'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gregoire_Sword_Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Zoltan_Axe_Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ares 2' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Mace 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Axe 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Axe'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Dwarven Hammer'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pickaxe'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Shovel'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Scythe'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Fishingrodx'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kama_silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Calidus_Fire_Sword'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sott ardyn'

			)
			{
				return true;
			}

			return false;
		break;

		case 'jingubang_silver':
			if( 
			(thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Silver_Jingubang'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_Of_Destiny')
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'longsword_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'genji blade silver'
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'longsword_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'genji blade steel'
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'spear_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire 1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pitchfork'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Rake'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'naginata_silver'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'glaive_silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa wyvern'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa mythril'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa drain silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa javelin'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa radiant'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'toto ardyn'
			)
			{
				return true;
			}

			return false;
		break;

		case 'claws_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri 1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Knife 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kukri 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger1_silver' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger2_silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger3_silver'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_3'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Chain_Weapon_Silver'
			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_moveset_silver_for_thunking':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Silver'
			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_moveset_silver_for_slicing':
			if( 

			thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe_Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe_Silver'
			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_moveset_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe_Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe_Silver'
			)
			{
				return true;
			}

			return false;
		break;

		case 'katana_silver':
			if( 
			
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Haoma 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Oathblade 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hitokiri Katana 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Ryu Katana 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Thermal Katana Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Black Unicorn Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'fishkatana'

			)
			{
				return true;
			}

			return false;
		break;

		case 'olgierd_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh 1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Rakuyo 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Vulcan 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Flameborn 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodletter 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Eagle Sword 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Lion Sword 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Cursed Khopesh 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'stiletto_silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sickle_silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'talon sabre'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'serrator'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'crescent_silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'rapier_silver'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'hjaven'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'skinner'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Icingdeath'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sparda'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Sparda'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Novalis'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'da elven silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'blade silver rapier'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kotw ardyn'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gravehag_Tongue_Silver'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Mourntart_Silver'
			)
			{
				return true;
			}

			return false;
		break;

		case 'shield_sword_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer 1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Kingslayer 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Bloodshot 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Gorgonslayer 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_q402_item__epic_swordx'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_sq304_powerful_sword'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'soul'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'luani'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'silver roh'

			)
			{
				return true;
			}

			return false;
		break;

		case 'jingubang_steel':
			if( 
			(thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Steel_Jingubang'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_Of_Destiny')
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'axe_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 2' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Lucerne Hammer'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Hammer'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'great baguette'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spoon'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Spoon'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Hammer'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scythe'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa gae bolg steel'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sotp noctis'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'aotc noctis'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'motf noctis'
			)
			{
				return true;
			}

			return false;
		break;

		case 'mjolnir_held':
			if( thePlayer.GetInventory().GetItemName( sword_id ) == 'Mjolnir'  
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'leviathan_held':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Leviathan'
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'knife_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knife' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Crys Knife Steel' 
			)
			{
				return true;
			}

			return false;
		break;

		case 'hammer_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'
			)
			{
				return true;
			}

			return false;
		break;

		case 'greg_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn 1' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Blade 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Realmdrifter Divider 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Claymore 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Icarus Tears 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hades Grasp 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Graveripper 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oblivion 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Dragonbane 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Crownbreaker 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Beastcutter 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Blackdawn 2' 
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'greatsword3'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'orkur'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gregoire_Sword'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Zoltan_Axe'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Axe'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Blackjack'

			//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Leviathan' 

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Mjolnir' 

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sott noctis' 
			)
			{
				return true;
			}

			return false;
		break;

		case 'winters_blade_held':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'q402 Skellige sword 3'
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'aerondight_silver_held':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Aerondight EP2'
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'aerondight_steel_held':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Steel_Aerondight'
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'zireal_silver_held':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Silver_Zireal_Sword'
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				ACS_Tutorial_Display_Check('ACS_Zireal_Tutorial_Shown');
				return true;
			}
			return false;
		break;

		case 'zireal_steel_held':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Steel_Zireal_Sword' 
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				ACS_Tutorial_Display_Check('ACS_Zireal_Tutorial_Shown');
				return true;
			}
			return false;
		break;

		case 'all_black_held':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_AllBlackNecrosword' 
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'dullahan_spear_steel_held':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
			&& thePlayer.GetInventory().IsItemHeld( sword_id )
			)
			{
				return true;
			}

			return false;
		break;

		case 'spear_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire 1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Pitchfork'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Rake'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'naginata'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'glaive'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Pitchfork'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Rake'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Shepherd_Stick'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Lucerne_Hammer'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa dragoon'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa flayer'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa drain steel'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa rapier'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'pa storm'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'toto noctis'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Draupnir Spear'
			)
			{
				return true;
			}

			return false;
		break;

		case 'claws_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri 1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Knife 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kukri 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'dagger3'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_a' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_b'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'gla_c'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Chain_Weapon_Steel'
			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_moveset_steel_for_slicing':
			if( 

			thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe steel'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe'

			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_moveset_steel_for_thunking':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Prime'
			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_moveset_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 3'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe steel'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe'
			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Prime'
			)
			{
				return true;
			}

			return false;
		break;

		case 'caretaker_shovel_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'PC Caretaker Shovel' 
			)
			{
				return true;
			}

			return false;
		break;

		case 'one_handed_axe_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ares 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe01'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe02'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe03'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe04'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe05'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Axe06'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Mace01'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'W_Mace02'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Mace 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Mace 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Axe 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Axe 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dwarven Axe'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dwarven Hammer'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Pickaxe'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shovel'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Scythe'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Fishingrodx'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Axe'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Q1_ZoltanAxe2hx'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kama'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'smol baguette'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Q1_ZoltanAxe2h_crafted'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Knight Mace 3'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Nazairi_Mace'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scoop'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Small_Blackjack'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Club'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Poker'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hatchet'
			)
			{
				return true;
			}

			return false;
		break;
		
		case 'ice_staff_steel':
			if(thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Ice_Staff')
			{
				return true;
			}

			return false;
		break;

		case 'fire_staff_steel':
			if( thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Fire_Staff')
			{
				return true;
			}

			return false;
		break;

		case 'sand_staff_steel':
			if(thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Sand_Staff')
			{
				return true;
			}

			return false;
		break;

		case 'water_staff_steel':
			if(thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Water_Staff')
			{
				return true;
			}

			return false;
		break;

		case 'katana_steel':
			if( 
	
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Sakura Flower'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Haoma 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Oathblade 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hitokiri Katana 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Ryu Katana 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Dragon'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sorrow'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oathblade'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Thermal Katana Steel'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Black Unicorn Steel'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'catkatana'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sq701 Geralt of Rivia sword'

			)
			{
				return true;
			}

			return false;
		break;

		case 'olgierd_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Olgierd Sabre'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_True_Iris'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo 1' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh 1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Rakuyo 2' 
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Vulcan 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Flameborn 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodletter 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Eagle Sword 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Lion Sword 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Cursed Khopesh 2'
			
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'stiletto'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sickle'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'claw sabre'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'jaggat'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'crescent'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'rapier'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'venasolak'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'wrisp'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twinkle'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Sparda'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Sparda'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Crafted Ofir Steel Sword'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Ofir Sabre 2'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Hakland Sabre'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Ofir Sabre 1'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'da elven steel'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'blade steel rapier'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'kotw noctis'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gravehag_Tongue_Steel'

			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Mourntart_Steel'

			)
			{
				return true;
			}

			return false;
		break;

		case 'shield_sword_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot 1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer 1'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Kingslayer 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Bloodshot 2'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Gorgonslayer 2'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'q402_item__epic_swordx'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'sq304_powerful_sword'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'spirit'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'chakram'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'bajinn roh'
			
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NPC Wild Hunt sword 1'
			)
			{
				return true;
			}

			return false;
		break;

		case 'eredin_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Eredin_Sword_Prime'
			)
			{
				return true;
			}

			return false;
		break;

		case 'nithral_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_Prime'
			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Silver'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace Silver'
			)
			{
				return true;
			}

			return false;
		break;

		case 'imlerith_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'
			|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace'
			)
			{
				return true;
			}

			return false;
		break;

		case 'aerondight_silver':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'Aerondight EP2'
			)
			{
				return true;
			}

			return false;
		break;

		case 'aerondight_steel':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Steel_Aerondight'
			)
			{
				return true;
			}

			return false;
		break;

		case 'all_black':
			if( 
			thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_AllBlackNecrosword' 
			)
			{
				return true;
			}

			return false;
		break;

		default:
			return false;
		break;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_DontReplaceScabbard(sword_slot : name) : bool
{
	var sword_id 		: SItemUniqueId;

	if (sword_slot == 'steel')
	{
		thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

		if( 
		StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Sabre" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scoiatael" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Gregoire" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Axe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Spear" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Halberd" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pole" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Hammer" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Club" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Blackjack" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Poker" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Guisarme" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Mace" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Hatchet" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Staff" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Wand" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Oar" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pickaxe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Shovel" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Broom" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Paling" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pitchfork" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Rake" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scoop" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scythe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Stick" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Eredin" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Giant" )
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "sabre" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scoiatael" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "gregoire" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "axe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "spear" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "halberd" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pole" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "hammer" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "club" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "blackjack" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "poker" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "guisarme" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "mace" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "hatchet" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "staff" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "wand" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "oar" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pickaxe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "shovel" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "broom" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "paling" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pitchfork" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "rake" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scoop" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scythe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "stick" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "eredin" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "giant" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Leviathan" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Caretaker" ) 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'mod_origin_ofir') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'Ofir') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'OlgierdSabre') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'NovalisSabre')
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'ironshade') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'Leviathan') 
		)
		{
			return true;
		}

		return false;
	}
	else if (sword_slot == 'silver')
	{
		thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

		if( 
		StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Sabre" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scoiatael" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Gregoire" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Axe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Spear" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Halberd" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pole" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Hammer" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Club" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Blackjack" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Poker" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Guisarme" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Mace" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Hatchet" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Staff" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Wand" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Oar" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pickaxe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Shovel" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Broom" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Paling" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Pitchfork" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Rake" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scoop" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Scythe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Stick" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Eredin" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Giant" )
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "sabre" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scoiatael" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "gregoire" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "axe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "spear" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "halberd" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pole" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "hammer" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "club" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "blackjack" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "poker" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "guisarme" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "mace" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "hatchet" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "staff" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "wand" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "oar" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pickaxe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "shovel" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "broom" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "paling" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "pitchfork" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "rake" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scoop" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "scythe" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "stick" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "eredin" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "giant" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "calidus" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Calidus" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Leviathan" ) 
		|| StrContains( NameToString(thePlayer.GetInventory().GetItemName( sword_id )), "Caretaker" ) 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'mod_origin_ofir') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'Ofir') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'OlgierdSabre') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'NovalisSabre') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'ironshade') 
		|| thePlayer.GetInventory().ItemHasTag(sword_id,'Leviathan') 
		)
		{
			return true;
		}

		return false;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Vampire_Claws_Access(): bool
{
	if ( ACS_GetWeaponMode() == 0 
	|| ACS_GetWeaponMode() == 1 
	|| ACS_GetWeaponMode() == 2 
	)
	{
		if (thePlayer.HasTag('acs_igni_sword_equipped') 
		|| thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
		)
		{
			return false;
		}
		
		if (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1 )
		{
			if (
			!thePlayer.HasTag('acs_aard_sword_equipped') 
			&& !thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
			&& !thePlayer.HasTag('acs_quen_sword_equipped') 
			&& !thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
			&& !thePlayer.HasTag('acs_yrden_sword_equipped') 
			&& !thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
			&& !thePlayer.HasTag('acs_axii_sword_equipped') 
			&& !thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
			&& !thePlayer.HasTag('acs_igni_sword_equipped')
			&& !thePlayer.HasTag('acs_igni_secondary_sword_equipped')
			&& !thePlayer.HasTag('acs_sorc_fists_equipped')
			)
			{
				return true;
			}
		}
	}

	if (ACS_GetWeaponMode() == 3 )
	{
		if (ACS_GetItem_VampClaw('normal') || ACS_GetItem_VampClaw('shades'))
		{
			if (
			!thePlayer.HasTag('acs_aard_sword_equipped') 
			&& !thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
			&& !thePlayer.HasTag('acs_quen_sword_equipped') 
			&& !thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
			&& !thePlayer.HasTag('acs_yrden_sword_equipped') 
			&& !thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
			&& !thePlayer.HasTag('acs_axii_sword_equipped') 
			&& !thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
			&& !thePlayer.HasTag('acs_sorc_fists_equipped')
			)
			{
				return true;
			}
		}
	}

	if (thePlayer.HasTag('acs_aard_sword_equipped') 
	|| thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
	|| thePlayer.HasTag('acs_quen_sword_equipped') 
	|| thePlayer.HasTag('acs_quen_secondary_sword_equipped') 
	|| thePlayer.HasTag('acs_yrden_sword_equipped') 
	|| thePlayer.HasTag('acs_yrden_secondary_sword_equipped') 
	|| thePlayer.HasTag('acs_axii_sword_equipped') 
	|| thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
	|| thePlayer.HasTag('acs_sorc_fists_equipped')
	)
	{
		return false;
	}

	return false;
}

function ACS_GetItem_VampClaw(glove_type : name): bool
{
	switch(glove_type)
	{
		case 'shades':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Kara Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Gloves')
			) 
			{
				return true;
			}

			return false;
		break;

		case 'acs_armor':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'ACS_Gloves')	
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP_ACS_Gloves')	
			) 
			{
				return true;
			}

			return false;
		break;

		case 'normal':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'q702_vampire_gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'q704_vampire_gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Ezio Gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Ezio Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Ezio Gloves 2')
			) 
			{
				return true;
			}

			return false;
		break;

		case 'default':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'q702_vampire_gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'q704_vampire_gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Ezio Gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Ezio Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Shades Ezio Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'ACS_Gloves')	
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP_ACS_Gloves')	
			) 
			{
				return true;
			}

			return false;
		break;

		default:
			return false;
		break;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetItem_WitcherSet(set_param : name): bool
{
	switch(set_param)
	{
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		case 'forgotten_wolf_steelsword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix steel sword 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'forgotten_wolf_silversword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix silver sword 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'forgotten_wolf_pants':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Pants 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'forgotten_wolf_gloves':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Gloves 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'forgotten_wolf_boots':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Boots 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'forgotten_wolf_armor':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Netflix Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Netflix Armor 2')
			) 
			{
				return true;
			}
			return false;
		break;
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		case 'viper_steelsword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Viper School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Viper School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'EP1 Viper School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Viper School steel sword')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'viper_silversword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Viper School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Viper School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'EP1 Viper School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Viper School silver sword')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'viper_pants':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Pants')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Pants')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'viper_gloves':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Gloves')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Gloves')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'viper_boots':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Boots')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Boots')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'viper_armor':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'EP1 Witcher Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP EP1 Witcher Armor')
			) 
			{
				return true;
			}
			return false;
		break;

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		case 'manticore_steelsword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School steel sword 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'manticore_silversword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf School silver sword 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'manticore_pants':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Pants 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'manticore_gloves':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Gloves 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'manticore_boots':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Boots 2')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'manticore_armor':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Red Wolf Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Red Wolf Armor 2')
			) 
			{
				return true;
			}
			return false;
		break;

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		case 'griffin_steelsword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School steel sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School steel sword 3')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'griffin_silversword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon School silver sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon School silver sword 3')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'griffin_pants':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Pants 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Pants 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'griffin_gloves':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Gloves 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Gloves 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'griffin_boots':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Boots 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Boots 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'griffin_armor':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Gryphon Armor 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Gryphon Armor 4')
			) 
			{
				return true;
			}
			return false;
		break;

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		case 'cat_steelsword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School steel sword 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School steel sword 4')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'cat_silversword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx School silver sword 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx School silver sword 4')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'cat_pants':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Pants 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Pants 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'cat_gloves':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Gloves 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Gloves 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'cat_boots':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Boots 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Boots 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'cat_armor':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Lynx Armor 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Lynx Armor 4')
			) 
			{
				return true;
			}
			return false;
		break;

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		case 'bear_steelsword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School steel sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School steel sword 3')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'bear_silversword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear School silver sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear School silver sword 3')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'bear_pants':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Pants 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Pants 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'bear_gloves':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Gloves 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Gloves 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'bear_boots':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Boots 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Boots 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'bear_armor':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Bear Armor 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Bear Armor 4')
			) 
			{
				return true;
			}
			return false;
		break;
		

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		case 'wolf_steelsword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School steel sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School steel sword 3')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'wolf_silversword':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf School silver sword 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf School silver sword 3')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'wolf_pants':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Pants 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Pants 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'wolf_gloves':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Gloves 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Gloves 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'wolf_boots':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Boots 5')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Boots 5')
			) 
			{
				return true;
			}
			return false;
		break;

		case 'wolf_armor':
			if ( GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'Wolf Armor 4')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 1')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 2')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 3')
			|| GetWitcherPlayer().IsItemEquippedByName( 'NGP Wolf Armor 4')
			) 
			{
				return true;
			}
			return false;
		break;

		////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		default:
			return false;
		break;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Armor_Set_Check(set : name, check_for_style: bool): bool
{
	switch(set)
	{
		case 'caranthir_armor':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if (GetWitcherPlayer().IsItemEquippedByName('ACS_Caranthir_Armor')
				|| GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Caranthir_Armor')
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'imlerith_skirt':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if (GetWitcherPlayer().IsItemEquippedByName('ACS_Imlerith_Pants')
				|| GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Imlerith_Pants')
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'imlerith_armor':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if (GetWitcherPlayer().IsItemEquippedByName('ACS_Imlerith_Armor')
				|| GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Imlerith_Armor')
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'eredin_skirt':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if ((GetWitcherPlayer().IsItemEquippedByName('ACS_Eredin_Pants'))
				|| GetWitcherPlayer().IsItemEquippedByName('ACS_VGX_Eredin_Pants')
				|| (GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Eredin_Pants'))
				|| GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_VGX_Eredin_Pants')
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'vgx_eredin_armor':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if (GetWitcherPlayer().IsItemEquippedByName('ACS_VGX_Eredin_Armor')
				|| GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_VGX_Eredin_Armor')
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'eredin_armor':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if (GetWitcherPlayer().IsItemEquippedByName('ACS_Eredin_Armor')
				|| GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Eredin_Armor')
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'wh_armor':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if (GetWitcherPlayer().IsItemEquippedByName('ACS_WH_Armor')
				|| GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_WH_Armor')
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'acs_armor_omega':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if (
				(GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Omega') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Omega'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Boots') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Pants') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants'))
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'acs_armor_alpha':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if (
				(GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Alpha'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Boots') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Pants') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants'))
				)
				{
					return true;
				}

				return false;
			}
		break;

		case 'acs_armor':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if ( (GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('ACS_Armor_Omega') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Alpha') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Armor_Omega'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Gloves') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Gloves'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Boots') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Boots'))
				&& (GetWitcherPlayer().IsItemEquippedByName('ACS_Pants') || GetWitcherPlayer().IsItemEquippedByName('NGP_ACS_Pants'))
				) 
				{
					return true;
				}

				return false;
			}
		break;

		case 'volhikar':
			if (check_for_style)
			{
				
				return false;
			}
			else
			{
				if ( GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Armor')
				&& GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Gloves')
				&& GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Pants')
				&& GetWitcherPlayer().IsItemEquippedByName( 'Volhikar Boots')
				) 
				{
					return true;
				}

				return false;
			}
		break;

		case 'forgotten_wolf':
			if (check_for_style)
			{
				if ( ACS_GetItem_WitcherSet('forgotten_wolf_armor')
				&& ACS_GetItem_WitcherSet('forgotten_wolf_boots')
				&& ACS_GetItem_WitcherSet('forgotten_wolf_pants')
				&& ACS_GetItem_WitcherSet('forgotten_wolf_gloves')
				&& FactsQuerySum("ACS_ForgottenWolf_Style_Activate") > 0
				) 
				{
					return true;
				}

				return false;
			}
			else
			{
				if ( ACS_GetItem_WitcherSet('forgotten_wolf_armor')
				&& ACS_GetItem_WitcherSet('forgotten_wolf_boots')
				&& ACS_GetItem_WitcherSet('forgotten_wolf_pants')
				&& ACS_GetItem_WitcherSet('forgotten_wolf_gloves')
				) 
				{
					ACS_Tutorial_Display_Check('ACS_ForgottenWolfSchool_Tutorial_Shown');
					
					return true;
				}

				return false;
			}
		break;

		case 'viper':
			if (check_for_style)
			{
				if ( ACS_GetItem_WitcherSet('viper_armor')
				&& ACS_GetItem_WitcherSet('viper_boots')
				&& ACS_GetItem_WitcherSet('viper_pants')
				&& ACS_GetItem_WitcherSet('viper_gloves')
				&& FactsQuerySum("ACS_Viper_Style_Activate") > 0
				) 
				{
					return true;
				}

				return false;
			}
			else
			{
				if ( ACS_GetItem_WitcherSet('viper_armor')
				&& ACS_GetItem_WitcherSet('viper_boots')
				&& ACS_GetItem_WitcherSet('viper_pants')
				&& ACS_GetItem_WitcherSet('viper_gloves')
				) 
				{
					ACS_Tutorial_Display_Check('ACS_ViperSchool_Tutorial_Shown');
					
					return true;
				}

				return false;
			}
		break;

		case 'manticore':
			if (check_for_style)
			{
				if ( ACS_GetItem_WitcherSet('manticore_armor')
				&& ACS_GetItem_WitcherSet('manticore_boots')
				&& ACS_GetItem_WitcherSet('manticore_pants')
				&& ACS_GetItem_WitcherSet('manticore_gloves')
				&& FactsQuerySum("ACS_Manticore_Style_Activate") > 0
				) 
				{
					return true;
				}

				return false;
			}
			else
			{
				if ( ACS_GetItem_WitcherSet('manticore_armor')
				&& ACS_GetItem_WitcherSet('manticore_boots')
				&& ACS_GetItem_WitcherSet('manticore_pants')
				&& ACS_GetItem_WitcherSet('manticore_gloves')
				) 
				{
					ACS_Tutorial_Display_Check('ACS_ManticoreSchool_Tutorial_Shown');
					
					return true;
				}

				return false;
			}
		break;

		case 'griffin':
			if (check_for_style)
			{
				if ( ACS_GetItem_WitcherSet('griffin_armor')
				&& ACS_GetItem_WitcherSet('griffin_boots')
				&& ACS_GetItem_WitcherSet('griffin_pants')
				&& ACS_GetItem_WitcherSet('griffin_gloves')
				&& FactsQuerySum("ACS_Griffin_Style_Activate") > 0
				) 
				{
					return true;
				}

				return false;
			}
			else
			{
				if ( ACS_GetItem_WitcherSet('griffin_armor')
				&& ACS_GetItem_WitcherSet('griffin_boots')
				&& ACS_GetItem_WitcherSet('griffin_pants')
				&& ACS_GetItem_WitcherSet('griffin_gloves')
				) 
				{
					ACS_Tutorial_Display_Check('ACS_GriffinSchool_Tutorial_Shown');
					
					return true;
				}

				return false;
			}
		break;

		case 'cat':
			if (check_for_style)
			{
				if ( ACS_GetItem_WitcherSet('cat_armor')
				&& ACS_GetItem_WitcherSet('cat_boots')
				&& ACS_GetItem_WitcherSet('cat_pants')
				&& ACS_GetItem_WitcherSet('cat_gloves')
				&& FactsQuerySum("ACS_Cat_Style_Activate") > 0
				) 
				{
					return true;
				}

				return false;
			}
			else
			{
				if ( ACS_GetItem_WitcherSet('cat_armor')
				&& ACS_GetItem_WitcherSet('cat_boots')
				&& ACS_GetItem_WitcherSet('cat_pants')
				&& ACS_GetItem_WitcherSet('cat_gloves')
				) 
				{
					ACS_Tutorial_Display_Check('ACS_CatSchool_Tutorial_Shown');
					
					return true;
				}

				return false;
			}
		break;

		case 'bear':
			if (check_for_style)
			{
				if ( ACS_GetItem_WitcherSet('bear_armor')
				&& ACS_GetItem_WitcherSet('bear_boots')
				&& ACS_GetItem_WitcherSet('bear_pants')
				&& ACS_GetItem_WitcherSet('bear_gloves')
				&& FactsQuerySum("ACS_Bear_Style_Activate") > 0
				) 
				{
					return true;
				}

				return false;
			}
			else
			{
				if ( ACS_GetItem_WitcherSet('bear_armor')
				&& ACS_GetItem_WitcherSet('bear_boots')
				&& ACS_GetItem_WitcherSet('bear_pants')
				&& ACS_GetItem_WitcherSet('bear_gloves')
				) 
				{
					ACS_Tutorial_Display_Check('ACS_BearSchool_Tutorial_Shown');
					
					return true;
				}

				return false;
			}
		break;

		case 'wolf':
			if (check_for_style)
			{
				if ( ACS_GetItem_WitcherSet('wolf_armor')
				&& ACS_GetItem_WitcherSet('wolf_boots')
				&& ACS_GetItem_WitcherSet('wolf_pants')
				&& ACS_GetItem_WitcherSet('wolf_gloves')
				&& FactsQuerySum("ACS_Wolf_Style_Activate") > 0
				) 
				{
					return true;
				}

				return false;
			}
			else
			{
				if ( ACS_GetItem_WitcherSet('wolf_armor')
				&& ACS_GetItem_WitcherSet('wolf_boots')
				&& ACS_GetItem_WitcherSet('wolf_pants')
				&& ACS_GetItem_WitcherSet('wolf_gloves')
				) 
				{
					ACS_Tutorial_Display_Check('ACS_WolfSchool_Tutorial_Shown');
					
					return true;
				}

				return false;
			}
		break;

		default:
			return false;
		break;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_CloakCheck ( id : SItemUniqueId ) : bool
{
	if 
	(
	thePlayer.GetInventory().ItemHasTag(id,'AHW') 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cloak" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cape" ) 
	|| thePlayer.GetInventory().GetItemName(id) == 'Traveler Kontusz' 
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP Traveler Kontusz'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Realmdrifter Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Omen Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Yahargul Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Taifeng Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Kara Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Berserker Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Bismarck Armor 2'
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Ezio Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Ezio Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Ezio Armor 2'

	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Lionhunter Armor' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Lionhunter Armor 1' 
	|| thePlayer.GetInventory().GetItemName(id) == 'Shades Lionhunter Armor 2'
	|| GetWitcherPlayer().IsItemEquippedByName('KM Cloak Lowered') 
	|| GetWitcherPlayer().IsItemEquippedByName('KM Cloak') 
	|| GetWitcherPlayer().IsItemEquippedByName('KM Pointy Cloak') 
	|| ACS_AdditionalArmorCheckForSwordsOnHip(id)
	)
	{
		return true; 
	}
	
	return false;
}

function ACS_AdditionalArmorCheckForSwordsOnHip ( id : SItemUniqueId ) : bool
{
	if 
	(ACS_Settings_Main_Bool('acs_player_equipment_visual_settings','acs_swords_on_hip_for_additional_armors', true) &&
	(
	thePlayer.GetInventory().GetItemName(id) == 'ACS_Armor_Omega'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Armor_Omega'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_VGX_Eredin_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_VGX_Eredin_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Eredin_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Eredin_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Imlerith_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Imlerith_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Caranthir_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_Caranthir_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_WH_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP_ACS_WH_Armor'
	|| thePlayer.GetInventory().GetItemName(id) == 'ACS_Artorias_Armor'
	//|| thePlayer.GetInventory().GetItemName(id) == 'Geralt Kontusz R'
	//|| thePlayer.GetInventory().GetItemName(id) == 'Geralt Kontusz'
	
	)
	)
	{
		return true; 
	}
	
	return false;
}

function ACS_IsItemCloak( id : SItemUniqueId ) : bool
{
	if(thePlayer.GetInventory().ItemHasTag(id,'AHW') 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cloak" ) 
	|| StrContains( NameToString(thePlayer.GetInventory().GetItemName(id)), "Cape" ) 
	|| thePlayer.GetInventory().GetItemName(id) == 'Traveler Kontusz' 
	|| thePlayer.GetInventory().GetItemName(id) == 'NGP Traveler Kontusz' 
	)
	{
		return true; 
	}

	return false;
}

function ACS_CloakEquippedCheck() : bool
{
	var equippedItemsId 		: array<SItemUniqueId>;
	var i 						: int;

	if (FactsQuerySum("ACS_Cloak_Equipped") > 0
	|| FactsQuerySum("ACS_Force_Weapons_On_Hips") > 0
	)
	{
		ACS_Tutorial_Display_Check('ACS_CloakWeaponHide_Tutorial_Shown');

		return true;
	} 	
	
	equippedItemsId.Clear();

	equippedItemsId = GetWitcherPlayer().GetEquippedItems();

	for ( i=0; i < equippedItemsId.Size() ; i+=1 ) 
	{
		if (ACS_CloakCheck(equippedItemsId[i])
		)
		{
			ACS_Tutorial_Display_Check('ACS_CloakWeaponHide_Tutorial_Shown');
			return true;
		} 	
	}
	
	return false;
}

function ACS_UnequipCloak()
{
	var equippedItemsId 		: array<SItemUniqueId>;
	var i 						: int;
	
	equippedItemsId.Clear();

	equippedItemsId = GetWitcherPlayer().GetEquippedItems();

	for ( i=0; i < equippedItemsId.Size() ; i+=1 ) 
	{
		if (ACS_IsItemCloak(equippedItemsId[i]))
		{
			if( !thePlayer.GetInventory().ItemHasTag( equippedItemsId[i], 'Unequipped_By_ACS' ))
			{
				thePlayer.GetInventory().AddItemTag( equippedItemsId[i], 'Unequipped_By_ACS' );
			}

			thePlayer.UnequipItem(equippedItemsId[i]);

			if (FactsQuerySum("ACS_Hood_Enabled") > 0)
			{
				FactsRemove("ACS_Hood_Enabled");
			}
		} 	
	}
}

function ACS_EquipCloak()
{
	var itemIds 				: array<SItemUniqueId>;
	var i 						: int;
		
	itemIds = thePlayer.inv.GetItemsByTag( 'Unequipped_By_ACS' );

	if (itemIds.Size() <= 0)
	{
		return;
	}

	if (itemIds.Size() > 0)
	{
		for( i = 0; i < itemIds.Size() ; i+=1 )
		{
			if( thePlayer.GetInventory().ItemHasTag( itemIds[i], 'Unequipped_By_ACS' ) )
			{
				thePlayer.EquipItem(itemIds[i]);

				thePlayer.GetInventory().RemoveItemTag( itemIds[i], 'Unequipped_By_ACS' );
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ShouldHideWeaponCheck(steel_or_silver : name) : bool
{
	var sword_id 		: SItemUniqueId;

	if (steel_or_silver == 'steel')
	{
		thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

		if( 
		thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Broomx' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knife'
		
		/*
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_True_Iris'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Olgierd Sabre'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Crafted Ofir Steel Sword'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Hakland Sabre'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Ofir Sabre 1'
		*/

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gravehag_Tongue_Steel'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Mourntart_Steel'

		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom' 
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'

		)
		{
			return true;
		}

		return false;
	}
	else if (steel_or_silver == 'silver')
	{
		thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

		if( 
		thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knife'
		
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Novalis'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gravehag_Tongue_Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Mourntart_Silver'

		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'

		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'

		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'

		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'

		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'

		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
		//|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'
		)
		{
			return true;
		}

		return false;
	}

	return false;
}

function ACS_DoNotCreateMeshCheck(steel_or_silver : name, sword_id : SItemUniqueId) : bool
{
	if (steel_or_silver == 'steel')
	{
		if( 
		thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire 1'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Heavenspire 2' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Guandao 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Hellspire 2'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Pitchfork'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Rake'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'naginata'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'glaive'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Pitchfork'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Rake'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Shepherd_Stick'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Lucerne_Hammer'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Water_Staff'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Sand_Staff'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Fire_Staff'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Ice_Staff'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe steel'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'PC Caretaker Shovel' 
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Macex'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Imlerith Mace1'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 2' 
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Lucerne Hammer'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Hammer'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'great baguette'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spoon'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Spoon'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Hammer'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scythe'

		)
		{
			return true;
		}

		return false;
	}
	else if (steel_or_silver == 'silver')
	{
		if( 
		thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Imlerith Macex'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'scythe silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Immace Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Imlerith_Mace_Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Bone_Scythe_Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Samurai_Scythe_Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire 1'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Heavenspire 2' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Guandao 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Hellspire 2'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Pitchfork'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Rake'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'naginata_silver'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'glaive_silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 2' 	
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Axe'
		
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Q1_ZoltanAxe2hx'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 1' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 1'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 2'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Hammer'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1_Silver' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2_Silver'

		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer_Silver'
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Demonic_Construct_Hammer'
		)
		{
			return true;
		}

		return false;
	}

	return false;
}

function ACS_ShouldStoreWeaponOnHip(steel_or_silver : name, sword_id : SItemUniqueId) : bool
{
	if (steel_or_silver == 'steel')
	{
		if( 
		thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knife' 
		/*
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_True_Iris' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Olgierd Sabre' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Crafted Ofir Steel Sword' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Hakland Sabre' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Ofir Sabre 1' 
		*/
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gravehag_Tongue_Steel' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Mourntart_Steel' 
		)
		{
			return true;
		}

		return false;
	}
	else if (steel_or_silver == 'silver')
	{
		if( 
		thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knife' 
		/*
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Novalis' 
		*/
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Gravehag_Tongue_Silver' 
		|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Mourntart_Silver' 
		)
		{
			return true;
		}

		return false;
	}

	return false; 
}

function ACS_CheckWeaponShouldExistOnHip( weaponName : name ) : bool
{
	var steelid, silverid 																			: SItemUniqueId;

	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SilverSword, silverid);
	GetWitcherPlayer().GetItemEquippedOnSlot(EES_SteelSword, steelid);

	switch (weaponName)
	{
		case 'silver':
		if (ACS_ShouldStoreWeaponOnHip('silver', silverid)
		)
		{
			return true;
		}
		break;

		case 'steel':
		if (ACS_ShouldStoreWeaponOnHip('steel', steelid)
		)
		{
			return true;
		}
		break;

		case 'both':
		if (ACS_ShouldStoreWeaponOnHip('steel', steelid)
		|| ACS_ShouldStoreWeaponOnHip('silver', silverid)
		)
		{
			return true;
		}
		break;

		default:
		return false;
		break;
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
function ACS_ShouldChangeWeaponWalkOneHandWeaponCheck_Steel() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Halberd 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Guisarme 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Oar' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Broomx' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Caranthil Staffx'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Oar'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Broom' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Ice_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Water_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Sand_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Fire_Staff'
	)
	{
		if (thePlayer.GetInventory().IsItemHeld( sword_id ))
		{
			return true;
		}
	}

	return false;
}

function ACS_ShouldChangeWeaponWalkOneHandWeaponCheck_Silver() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Spear 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Halberd 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Guisarme 2' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Staff'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Oar' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Broomx' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Caranthil Staffx'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Spear_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Spear_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Halberd_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Halberd_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Guisarme_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Hakland_Spear_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Knight_Lance_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dullahan_Spear'
	)
	{
		if (thePlayer.GetInventory().IsItemHeld( sword_id ))
		{
			return true;
		}
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ShouldChangeWeaponWalkTwoHandWeaponCheck_Steel() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SteelSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Lucerne_Hammer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Steel Doomblade 2' 
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Lucerne Hammer'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Wild Hunt Hammer'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'great baguette'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Spoon'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'NGP Spoon'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Dwarven_Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Scythe'

	)
	{
		if (thePlayer.GetInventory().IsItemHeld( sword_id ))
		{
			return true;
		}
	}

	return false;
}

function ACS_ShouldChangeWeaponWalkTwoHandWeaponCheck_Silver() : bool
{
	var sword_id 		: SItemUniqueId;

	thePlayer.GetInventory().GetItemEquippedOnSlot(EES_SilverSword, sword_id);

	if( 
	thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Long_Metal_Pole_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Giant_Weapon_3_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'Shades Silver Doomblade 2' 	
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Axe'
	
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Q1_ZoltanAxe2hx'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 1' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Twohanded Hammer 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 1'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Great Axe 2'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'S_Wild Hunt Hammer'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_1_Silver' 
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Great_Axe_2_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Axe_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_1_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Twohanded_Hammer_2_Silver'

	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Wild_Hunt_Hammer_Silver'
	|| thePlayer.GetInventory().GetItemName( sword_id ) == 'ACS_Demonic_Construct_Hammer'
	)
	{
		if (thePlayer.GetInventory().IsItemHeld( sword_id ))
		{
			return true;
		}
	}

	return false;
}
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_BuffCheck() : bool
{
	if ( thePlayer.HasBuff(EET_HeavyKnockdown) 
	|| thePlayer.HasBuff( EET_Knockdown ) 
	|| thePlayer.HasBuff( EET_Ragdoll ) 
	|| thePlayer.HasBuff( EET_Stagger )
	|| thePlayer.HasBuff( EET_LongStagger )
	|| thePlayer.HasBuff( EET_Pull )
	|| thePlayer.HasBuff( EET_Immobilized )
	|| thePlayer.HasBuff( EET_Hypnotized )
	|| thePlayer.HasBuff( EET_WitchHypnotized )
	|| thePlayer.HasBuff( EET_Frozen )
	|| thePlayer.HasBuff( EET_Paralyzed )
	|| thePlayer.HasBuff( EET_Confusion )
	|| thePlayer.HasBuff( EET_Tangled )
	|| thePlayer.HasBuff( EET_Tornado ) 
	)
	{
		return false;
	}

	return true;
}

function ACS_ThingsThatShouldBeRemoved_BASE( alt : bool )
{
	if (thePlayer.HasTag('ACS_ExplorationDelayTag'))
	{
		thePlayer.RemoveTag('ACS_ExplorationDelayTag');
	}

	if (thePlayer.HasTag('ACS_Counter_Initiated'))
	{
		thePlayer.RaiseEvent('ACS_SwordCounterAdditiveReset');

		thePlayer.RemoveTag('ACS_Counter_Initiated');
	}

	GetACSWatcher().RemoveTimer('ClawDestroyDelay');

	GetACSWatcher().RemoveMageAttackTimers();

	GetWitcherPlayer().GetSignEntity(ST_Axii).OnSignAborted(true);

	thePlayer.RemoveTag('ACS_Griffin_Special_Attack');

	thePlayer.RemoveTag('ACS_Bear_Special_Attack');	

	thePlayer.RemoveTag('ACS_Viper_Special_Attack');

	thePlayer.StopEffect('hand_special_fx');

	thePlayer.StopEffect('special_attack_fx');

	thePlayer.StopEffect('ethereal_debuff');

	thePlayer.StopEffect('shout');

	if (!thePlayer.HasTag('ACS_Camo_Active')
	)
	{
		thePlayer.StopEffect( 'shadowdash' );
	}

	GetACSWatcher().ACS_Teleport_End_Early_Effects();

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');

	GetACSWatcher().AddTimer('ACS_ExplorationDelay', 2 , false);

	GetACSWatcher().RemoveTimer('ACS_shout'); 

	GetACSWatcher().RemoveTimer('ACS_Blood_Spray'); 

	GetACSWatcher().RemoveTimer('ParrySkillsDelayTimer');

	GetACSWatcher().RemoveTimer('ACS_dodge_timer_wildhunt');

	GetACSWatcher().RemoveTimer('ACS_ShootShotgunLight');

	GetACSWatcher().RemoveTimer('ACS_ShootShotgunHeavy');

	thePlayer.RemoveTag('ACS_Shadow_Dash_Empowered');

	thePlayer.RemoveTag('ACS_Shadowstep_Long_Buff');

	if( thePlayer.IsAlive()) 
	{
		//thePlayer.ACS_ClearAnimationSpeedMultipliers(); 
	
		//GetACSWatcher().RemoveTimer('ACS_Death_Delay_Animation'); 
	
	}

	GetACSWatcher().RemoveTimer('RollDelay');

	if ( FactsQuerySum("acs_transformation_activated") <= 0 )
	{
		if( thePlayer.IsAlive() && thePlayer.IsInCombat() ){ thePlayer.SetVisibility( true ); }		 
	}

	thePlayer.RaiseEvent('ACS_SwordCounterAdditiveReset');

	if (alt)
	{

	}
	else
	{
		GetACSWatcher().RemoveTimer('ACS_HeadbuttDamage'); 

		GetACSWatcher().RemoveTimer('ACS_alive_check');

		thePlayer.SetImmortalityMode( AIM_None, AIC_Default, true ); 

		thePlayer.SetCanPlayHitAnim(true); 

		if (!thePlayer.HasTag('ACS_HasPerformedFinisher'))
		{
			thePlayer.EnableCharacterCollisions(true); 
		}

		thePlayer.RemoveBuffImmunity_AllNegative('acs_dodge'); 
		thePlayer.SetIsCurrentlyDodging(false);
	}
}

function ACS_ThingsThatShouldBeRemoved()
{
	ACS_ThingsThatShouldBeRemoved_BASE(false);

	GetACSWatcher().RemoveTimer('ACS_portable_aard'); 

	GetACSWatcher().RemoveTimer('ACS_Dash_Attack_Process'); 

	GetACSWatcher().RemoveTimer('ACS_Vampire_Claws_Sword_Hybrid_Dash');

	//GetACSWatcher().RemoveTimer('ACS_Umbral_Slash_End');
	
	if ( thePlayer.HasTag('ACS_HideWeaponOnDodge') 
	//&& !thePlayer.HasTag('ACS_Bruxa_Bite_Process')
	)
	{
		if (!thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			ACS_Weapon_Respawn();
		}
		
		thePlayer.RemoveTag('ACS_HideWeaponOnDodge');

		thePlayer.RemoveTag('ACS_HideWeaponOnDodge_Claw_Effect');
	}
}

function ACS_DefaultMovesetDrainStamina(i : int)
{
	if( thePlayer.IsDoingSpecialAttack(false)
	|| thePlayer.IsDoingSpecialAttack(true)
	|| ACS_Armor_Set_Check('acs_armor', false)
	|| ACS_Armor_Set_Check('wolf', true)
	|| ACS_Armor_Set_Check('bear', true)
	|| ACS_Armor_Set_Check('cat', true)
	|| ACS_Armor_Set_Check('griffin', true)
	|| ACS_Armor_Set_Check('manticore', true)
	|| ACS_Armor_Set_Check('forgotten_wolf', true)
	|| ACS_Armor_Set_Check('viper', true)
	|| ACS_DefaultMovesetCombatAnimationOverrideMode_Enabled()
	|| (ACS_Is_DLC_Installed('dlc_spectre'))
	)
	{
		return;
	}

	if ((thePlayer.HasTag('acs_igni_secondary_sword_equipped')
	|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG')
	|| thePlayer.HasTag('acs_igni_sword_equipped')
	|| thePlayer.HasTag('acs_igni_sword_equipped_TAG'))
	&& !thePlayer.HasTag('acs_quen_sword_equipped')
	&& !thePlayer.HasTag('acs_axii_sword_equipped')
	&& !thePlayer.HasTag('acs_aard_sword_equipped')
	&& !thePlayer.HasTag('acs_yrden_sword_equipped')
	&& !thePlayer.HasTag('acs_quen_secondary_sword_equipped')
	&& !thePlayer.HasTag('acs_axii_secondary_sword_equipped')
	&& !thePlayer.HasTag('acs_aard_secondary_sword_equipped')
	&& !thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
	&& ACS_Settings_Main_Bool('acs_stamina_settings','acs_stamina_cost_action', false)
	&& !ACS_Is_DLC_Installed('dlc_spectre')
	)
	{
		if (i == 1
		&& ACS_Settings_Main_Float('acs_stamina_settings','acs_light_attack_stamina_cost', 0.05) > 0
		)
		{
			thePlayer.DrainStamina( ESAT_FixedValue,  thePlayer.GetStatMax( BCS_Stamina ) * ACS_Settings_Main_Float('acs_stamina_settings','acs_light_attack_stamina_cost', 0.05) * 0.5, ACS_Settings_Main_Float('acs_stamina_settings','acs_light_attack_stamina_regen_delay', 1) * 0.5 );
		}
		else if (i == 2
		&& ACS_Settings_Main_Float('acs_stamina_settings','acs_heavy_attack_stamina_cost', 0.05) > 0
		)
		{
			thePlayer.DrainStamina( ESAT_FixedValue,  thePlayer.GetStatMax( BCS_Stamina ) * ACS_Settings_Main_Float('acs_stamina_settings','acs_heavy_attack_stamina_cost', 0.1) * 0.5, ACS_Settings_Main_Float('acs_stamina_settings','acs_heavy_attack_stamina_regen_delay', 1) * 0.5 );
		}
	}
}

function ACS_Pre_Attack( animEventName : name, animEventType : EAnimationEventType, data : CPreAttackEventData, animInfo : SAnimationEventAnimInfo  )
{
	var attackName     									: name;
	var targetDistance 									: Float;
	var item_steel, item_silver							: SItemUniqueId;
	var markerNPC_1										: CEntity;
	var itemEntity 										: CEntity;
	var weaponId 										: SItemUniqueId;
	var itemEntityRot									: EulerAngles;


	if (
	!thePlayer.IsSwimming() 
	&& !thePlayer.IsDiving()
	&& !thePlayer.IsUsingHorse()
	&& !thePlayer.IsUsingVehicle()
	&& data.attackName != 'acs_attack_poison'
	&& data.attackName != 'acs_feainnewedd_dance'
	&& !thePlayer.IsDoingSpecialAttack(true)
	&& !thePlayer.IsDoingSpecialAttack(false)
	)
	{
		ACS_ExplorationDelayHack(false, 3);
	}
	

	targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), ((CNewNPC)(thePlayer.GetTarget())).GetWorldPosition() );

	if(animEventType == AET_DurationStart)
	{
		ACS_GravehagTongueWeaponPlayAnim();

		if (ACS_GetItem_Sword_IsEquipped('caretaker_shovel_steel', 'steel'))
		{
			ACSSwordPlayEffects('yrden_small');

			if(data.attackName == 'attack_light'
			|| data.attackName == 'attack_light_special'
			|| data.attackName == 'attack_heavy'
			|| data.attackName == 'attack_heavy_special')
			{
				ACSSwordPlayEffects('yrden_big');
			}
			else
			{
				ACSSwordPlayEffects('yrden_around');
			}
		}

		if (ACS_ChainWeaponCheck())
		{
			ACS_Chain_Weapon_Set_Attack(false);

			if (!thePlayer.HasTag('ACS_Chain_Weapon_Expand'))
			{
				thePlayer.AddTag('ACS_Chain_Weapon_Expand');
			}

			GetACSWatcher().RemoveTimer('RemoveChainWeaponExpandTimer');
			GetACSWatcher().AddTimer('RemoveChainWeaponExpandTimer', 0.1875 , false );
		}

		if ( !thePlayer.HasTag('acs_axii_sword_equipped') 
		&& FactsQuerySum("ACS_Azkar_Aiming") <= 0
		&& data.attackName != 'counter_attack_light'
		)
		{
			thePlayer.SetGuarded(false);
			thePlayer.OnGuardedReleased();
		}

		if (thePlayer.IsAnyWeaponHeld() && !thePlayer.IsWeaponHeld('fist'))
		{
			if (animEventName == 'AttackLight' || data.attackName == 'attack_light' || data.attackName == 'AttackLight' || data.attackName == 'counter_attack_light')
			{
				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					ACSGetEquippedSword().SoundEvent("monster_cloud_giant_weapon_whoosh_fast");
				}
			}

			if (animEventName == 'AttackHeavy' || data.attackName == 'attack_heavy' || data.attackName == 'AttackHeavy' )
			{
				if (ACS_Armor_Set_Check('acs_armor', false))
				{
					ACSGetEquippedSword().SoundEvent("monster_cloud_giant_weapon_whoosh_slow");
				}
			}

			if ( 
			thePlayer.HasTag('acs_igni_sword_equipped_TAG') 
			|| thePlayer.HasTag('acs_igni_sword_equipped') 
			|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG') 
			|| thePlayer.HasTag('acs_igni_secondary_sword_equipped') 
			)
			{
				if (GetACSWatcher().silver_strong_stance || GetACSWatcher().steel_strong_stance) 
				{
					ACSGetCEntity('acs_sword_trail_1').StopEffect('heavy_trail_fx');
					ACSGetCEntity('acs_sword_trail_2').StopEffect('heavy_trail_fx');
					ACSGetCEntity('acs_sword_trail_3').StopEffect('heavy_trail_fx');

					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('heavy_trail_fx');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('heavy_trail_fx');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('heavy_trail_fx');

					ACSGetEquippedSword().SoundEvent("cmb_weapon_swoosh_heavy_slow");

					ACSGetCEntity('acs_sword_trail_3').StopEffect('strong_trail_fx');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('strong_trail_fx');
				}
				else if (GetACSWatcher().silver_group_stance || GetACSWatcher().steel_group_stance) 
				{
					ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_fx');
					ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_fx');
					ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_fx');

					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_fx');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_fx');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_fx');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('group_trail_fx');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('group_trail_fx');
				}
				else if (GetACSWatcher().silver_fast_stance || GetACSWatcher().steel_fast_stance) 
				{
					ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_fx');

					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_fx');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('fast_trail_fx');

					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('fast_trail_fx');
				}
			}
		}

		if (thePlayer.HasTag('ACS_Counter_Initiated'))
		{
			thePlayer.RaiseEvent('ACS_SwordCounterAdditiveReset');

			thePlayer.RemoveTag('ACS_Counter_Initiated');
		}

		GetACSWatcher().RemoveTimer('CloseRangeAimAssist');

		if ( data.attackName != 'acs_attack_poison'
		&& data.attackName != 'acs_feainnewedd_dance'
		)
		{
			GetACSWatcher().AddTimer('CloseRangeAimAssist', 0.05 , false );
		}

		//GetACSWatcher().RemoveTimer('RemoveProcessWeaponCollisionTimerDelay');
		//GetACSWatcher().RemoveTimer('AddProcessWeaponCollisionTimer');

		//GetACSWatcher().AddTimer('AddProcessWeaponCollisionTimer', 0.05f , true);

		//GetACSWatcher().AddTimer('RemoveProcessWeaponCollisionTimerDelay', 3 , false );

		thePlayer.AddTag('ACS_Player_Is_Attacking');

		GetACSWatcher().ShotgunPositioningSwitch('out_of_combat');

		GetACSWatcher().RemoveTimer('RemovePlayerIsAttackingTag');

		GetACSWatcher().AddTimer('RemovePlayerIsAttackingTag', 0.5 , false );

		if(data.attackName == 'attack_light'
		|| data.attackName == 'attack_light_special')
		{
			if ((ACS_Armor_Set_Check('acs_armor', false) || thePlayer.IsWeaponHeld('fist') )
			&& thePlayer.IsHardLockEnabled()
			&& ACS_Settings_Main_Bool('acs_combat_main_settings','acs_phantom_attack_system', true)
			&& !GetACSWatcher().silver_fast_stance
			&& !GetACSWatcher().steel_fast_stance
			&& !GetACSWatcher().silver_group_stance
			&& !GetACSWatcher().steel_group_stance
			&& !GetACSWatcher().silver_strong_stance
			&& !GetACSWatcher().steel_strong_stance
			)
			{
				ACS_Phantom_Create();
			}
		}

		if (ACS_Armor_Set_Check('viper', true) && RandF() < 0.5)
		{
			if(data.attackName == 'acs_attack_poison'
			|| data.rangeName == 'slash_short'
			)
			{
				if(!thePlayer.HasTag('ACS_Viper_Dagger_Attack'))
				{
					if(ACSGetCEntity('ACS_Viper_Dagger_L'))
					{
						ACSGetCEntity('ACS_Viper_Dagger_L').PlayEffectSingle('poison_sword_trail');
						ACSGetCEntity('ACS_Viper_Dagger_L').StopEffect('poison_sword_trail');
					}

					GetACSWatcher().RemoveTimer('RemoveViperDaggerAttackTag');
					GetACSWatcher().AddTimer('RemoveViperDaggerAttackTag', 0.5 , false );

					thePlayer.AddTag('ACS_Viper_Dagger_Attack');
				}
			}
		}

		if (thePlayer.IsSwimming() || thePlayer.IsDiving())
		{
			GetACSWatcher().SwimmingMeleeDealDamage(false);

			ACSGetCEntity('acs_swimming_dagger').DestroyEffect('heavy_trail_fx');
			ACSGetCEntity('acs_swimming_dagger').DestroyEffect('light_trail_fx');
			ACSGetCEntity('acs_swimming_dagger').PlayEffectSingle('light_trail_fx');
		}
	}

	if(animEventType == AET_DurationEnd)
	{
		thePlayer.RemoveTag('ACS_Player_Is_Attacking');

		GetACSWatcher().RemoveTimer('RemovePlayerIsAttackingTag');

		//GetACSWatcher().RemoveTimer('RemoveProcessWeaponCollisionTimerDelay');

		//GetACSWatcher().AddTimer('RemoveProcessWeaponCollisionTimerDelay', 1 , false );

		if(data.attackName == 'attack_light'
		|| data.attackName == 'attack_light_special')
		{
			if (thePlayer.IsHardLockEnabled()
			&& ACS_Settings_Main_Bool('acs_combat_main_settings','acs_phantom_attack_system', true)
			)
			{
				ACS_Phantom_Create();
			}
		}

		if (thePlayer.IsSwimming() || thePlayer.IsDiving())
		{
			GetACSWatcher().SwimmingMeleeDealDamage(true);

			ACSGetCEntity('acs_swimming_dagger').DestroyEffect('heavy_trail_fx');
			ACSGetCEntity('acs_swimming_dagger').DestroyEffect('light_trail_fx');
			ACSGetCEntity('acs_swimming_dagger').PlayEffectSingle('heavy_trail_fx');
		}

		if ( 
		ACS_GetItem_Sword_IsEquipped('eredin_steel', 'steel')
		|| ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel')
		|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel')
		)
		{
			GetACSWatcher().AardDealDamage();

			ACS_Frost_Cone();

			if ( 
			ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel')
			)
			{
				
			}
		}

		if ( 
		thePlayer.IsDoingSpecialAttack(false)
		&& thePlayer.HasTag('ACS_Flammable_Oil_Enabled')
		)
		{
			GetACSWatcher().IgniDealDamage();

			if (ACS_GetItem_SwordHeldSwitchBasedUponStat('frost_sword'))
			{
				if (ACS_GetItem_Sword_IsEquipped('winters_blade_held', 'steel'))
				{
					GetACSWatcher().ACS_Ice_Blast();
				}
				{
					ACS_Frost_Cone();
				}
			}
			else if (ACS_GetItem_SwordHeldSwitchBasedUponStat('poison_sword'))
			{
				ACS_Poison_Cloud();
			}
			else if (ACS_GetItem_SwordHeldSwitchBasedUponStat('bleed_sword'))
			{
				GetACSWatcher().ACS_Blood_Arc();
			} 
			else
			{
				GetACSWatcher().ACS_Igni_Blast_Ent();
			}
		}

		return;
	}

	attackName = data.attackName;

	if (animEventName == 'AttackLight' || data.attackName == 'attack_light' || data.attackName == 'AttackLight' || data.attackName == 'counter_attack_light')
	{
		ACS_DefaultMovesetDrainStamina(1);

		ACS_Attack_Trail('light_trail_fx');

		if ((GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')))
		{
			ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_fx');
			ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_fx');

			ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('light_trail_fx');
			ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('light_trail_fx');
		}
	}
	else if (animEventName == 'AttackHeavy' || data.attackName == 'attack_heavy' || data.attackName == 'AttackHeavy' )
	{
		ACS_DefaultMovesetDrainStamina(2);

		ACS_Attack_Trail('heavy_trail_fx');

		if ((GetWitcherPlayer().HasTag('acs_igni_sword_equipped')
		|| GetWitcherPlayer().HasTag('acs_igni_secondary_sword_equipped')))
		{
			ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('heavy_trail_fx');
			ACSGetCEntity('acs_sword_trail_1').StopEffect('heavy_trail_fx');

			ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('heavy_trail_fx');
			ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('heavy_trail_fx');
		}
	}

	if (thePlayer.HasTag('ACS_Mortal_Draw'))
	{
		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('electric_sword_red_1');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('electric_sword_red_1');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('electric_sword_red_1');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('electric_sword_red_1_1');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('electric_sword_red_1_1');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('electric_sword_red_1_1');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('mortal_draw_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('mortal_draw_fx');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('mortal_draw_fx');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('mortal_draw_fx');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('mortal_draw_fx');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('mortal_draw_fx');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('mortal_draw_fx_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('mortal_draw_fx_trail');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('mortal_draw_fx_trail');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('mortal_draw_fx_trail');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('mortal_draw_fx_trail');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('mortal_draw_fx_trail');
	}

	if (thePlayer.HasTag('ACS_Spiral_Cloud_Passage'))
	{
		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_extended_fx');
	}

	if (thePlayer.HasTag('ACS_Feainnewedd_Dance'))
	{
		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('feainnewedd_dance_trail_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('feainnewedd_dance_trail_fx');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('feainnewedd_dance_trail_fx');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('feainnewedd_dance_trail_fx');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('feainnewedd_dance_trail_fx');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('feainnewedd_dance_trail_fx');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('feainnewedd_dance_sparks_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('feainnewedd_dance_sparks_fx');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('feainnewedd_dance_sparks_fx');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('feainnewedd_dance_sparks_fx');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('feainnewedd_dance_sparks_fx');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('feainnewedd_dance_sparks_fx');
	}

	if (thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'Aerondight' ))
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack')
		&& !ACS_Armor_Set_Check('acs_armor', false))
		{
			GetACSWatcher().aerondight_sword_trail();
		}
	}

	if (thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'OlgierdSabre' ))
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack')
		&& !ACS_Armor_Set_Check('acs_armor', false))
		{
			if (!ACS_Settings_Main_Bool('acs_player_equipment_visual_settings','acs_iconic_sword_vfx', false))
			{
				if (thePlayer.HasTag('acs_quen_sword_equipped'))
				{
					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
				}
				else if (thePlayer.HasTag('acs_axii_sword_equipped'))
				{
					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
				}
				else if (thePlayer.HasTag('acs_aard_sword_equipped'))
				{
					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_aerondight_special_trail');


					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
				}
				else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
				{
					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_aerondight_special_trail');


					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
				}
				else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
				{
					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
				}
				else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
				{
					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_aerondight_special_trail');
				}
				else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
				{
					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_aerondight_special_trail');


					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
				}
				else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
				{
					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_aerondight_special_trail');


					ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
				}
				else if (
				thePlayer.HasTag('acs_igni_secondary_sword_equipped')
				|| thePlayer.HasTag('acs_igni_sword_equipped'))
				{
					//ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('pre_special_attack_iris');
					//ACSGetCEntity('acs_sword_trail_1').StopEffect('pre_special_attack_iris');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');

					ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('red_charge_10');
					ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('red_charge_10');

					ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('red_aerondight_special_trail');
					ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('red_aerondight_special_trail');
				}
			}
		}
	}

	if (ACS_GetItem_Sword_IsEquipped('zireal_steel_held', 'steel') || ACS_GetItem_Sword_IsEquipped('zireal_silver_held', 'silver'))
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack'))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('fury_trail');
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('fury_trail');
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('fury_trail');
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_3').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('fury_trail');
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('fury_trail');
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('fury_trail');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('fury_trail');
			}
			else if (
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
			|| thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_2').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('fury_trail');


				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('fury_trail');
				ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('fury_trail');
			}

			if (thePlayer.HasTag('ACS_In_Ciri_Special_Attack'))
			{
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
				ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

				ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('light_trail_extended_fx');
				ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('light_trail_extended_fx');
			}
		}
	}

	if (thePlayer.HasTag('ACS_In_Heavenly_Strike'))
	{
		if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

			GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_steel, (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) * 0.0125)) );
		}
		else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

			GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) * 0.0125)) );
		}

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');


		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('electric_sword_trail_red');




		ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('red_charge_10');


		ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('electric_sword_trail_red');
	}

	if (thePlayer.HasTag('ACS_In_Dance_Of_Wrath'))
	{
		if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

			GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_steel, (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) * 0.0125)) );
		}
		else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

			GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) * 0.0125)) );
		}

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('lightning_charge_red');




		ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('electric_sword_red_1');
		ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('lightning_charge_red');

		ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('electric_sword_red_1_1');
		ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('lightning_charge_red');
	}

	if (thePlayer.HasTag('ACS_Ghost_Stance_Active'))
	{
		if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

			GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_steel, (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) * 0.0125)) );
		}
		else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

			GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) * 0.0125)) );
		}

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('wraith_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('wraith_trail');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_aerondight_special_trail');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_2').StopEffect('electric_sword_trail_red');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('electric_sword_trail_red');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('electric_sword_trail_red');
	}

	if (ACS_Armor_Set_Check('griffin', true)
	&& thePlayer.HasTag('ACS_Griffin_Special_Attack'))
	{
		if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
		{
			GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

			GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_steel, (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) * 0.0125)) );
		}
		else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
		{
			GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

			GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) * 0.0125)) );
		}

		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

		ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
		ACSGetEquippedSword().StopEffect('wraith_trail');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('wraith_trail');
		ACSGetCEntity('acs_sword_trail_1').StopEffect('wraith_trail');
	}

	if (ACS_Armor_Set_Check('viper', true))
	{
		if (thePlayer.HasTag('ACS_Viper_Special_Attack'))
		{
			if (GetWitcherPlayer().IsWeaponHeld('steelsword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SteelSword, item_steel);

				GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_steel, (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_steel) * 0.0125)) );
			}
			else if (GetWitcherPlayer().IsWeaponHeld('silversword'))
			{
				GetWitcherPlayer().GetInventory().GetItemEquippedOnSlot(EES_SilverSword, item_silver);

				GetWitcherPlayer().GetInventory().SetItemDurabilityScript(item_silver, (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) - (GetWitcherPlayer().GetInventory().GetItemDurability(item_silver) * 0.0125)) );
			}

			ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
			ACSGetEquippedSword().StopEffect('light_trail_extended_fx');

			ACSGetEquippedSword().PlayEffectSingle('wraith_trail');
			ACSGetEquippedSword().StopEffect('wraith_trail');

			ACSGetEquippedSword().PlayEffectSingle('green_blood_trail');
			ACSGetEquippedSword().StopEffect('green_blood_trail');

			ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');
			ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

			ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('wraith_trail');
			ACSGetCEntity('acs_sword_trail_1').StopEffect('wraith_trail');

			ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('poison_sword_trail');
			ACSGetCEntity('acs_sword_trail_1').StopEffect('poison_sword_trail');

			ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('poison_sword_trail');
			ACSGetCEntity('acs_sword_trail_2').StopEffect('poison_sword_trail');

			ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('poison_sword_trail');
			ACSGetCEntity('acs_sword_trail_3').StopEffect('poison_sword_trail');
		}
	}

	if (ACS_Armor_Set_Check('bear', true))
	{
		ACSGetEquippedSword().PlayEffectSingle('light_trail_extended_fx');
		ACSGetEquippedSword().StopEffect('light_trail_extended_fx');
	}

	if( thePlayer.HasAbility('Runeword 2 _Stats', true) )
	{
		ACS_Attack_Trail('light_trail_extended_fx');
		//ACS_Attack_Trail('heavy_trail_extended_fx');
	}

	if(thePlayer.HasTag('acs_aard_sword_equipped'))
	{
		ACSGetEquippedSword().StopAllEffects();
	}

	if (ACS_Armor_Set_Check('acs_armor', false))
	{
		if (!thePlayer.HasTag('ACS_In_Jump_Attack'))
		{
			//thePlayer.SoundEvent( "monster_caretaker_mv_cloth_hard" );

			thePlayer.SoundEvent( "monster_caretaker_cmb_whoosh_heavy2" );
			

			ACS_Armor_Cone();

			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx_red');
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx_red');
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('light_trail_extended_fx_red');


				ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('light_trail_extended_fx_red');


				ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_extended_fx_red');
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('light_trail_extended_fx_red');


				ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('light_trail_extended_fx_red');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('light_trail_extended_fx_red');


				ACSGetCEntity('acs_sword_trail_1').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_3').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_4').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_4').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_5').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_5').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_6').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_6').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_7').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_7').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_8').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_8').PlayEffectSingle('red_charge_10');
			}
			else if (
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
			|| thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				//ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('pre_special_attack_iris');
				//ACSGetCEntity('acs_sword_trail_1').StopEffect('pre_special_attack_iris');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('light_trail_extended_fx_red');


				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('red_charge_10');
				ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('red_charge_10');

				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('light_trail_extended_fx_red');
				ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('light_trail_extended_fx_red');
			}

			//ACSGetCEntity('ACS_Armor_Ether_Sword').StopEffect('fire_sparks_trail');
			//ACSGetCEntity('ACS_Armor_Ether_Sword').PlayEffectSingle('fire_sparks_trail');

			ACSGetCEntity('ACS_Armor_Ether_Sword').StopEffect('special_attack_iris');
			ACSGetCEntity('ACS_Armor_Ether_Sword').PlayEffectSingle('special_attack_iris');

			ACSGetCEntity('ACS_Armor_Ether_Sword').StopEffect('red_fast_attack_buff');
			ACSGetCEntity('ACS_Armor_Ether_Sword').PlayEffectSingle('red_fast_attack_buff');

			ACSGetCEntity('ACS_Armor_Ether_Sword').StopEffect('red_fast_attack_buff_hit');
			ACSGetCEntity('ACS_Armor_Ether_Sword').PlayEffectSingle('red_fast_attack_buff_hit');

			if( thePlayer.IsDoingSpecialAttack(false)
			//&& thePlayer.GetStat(BCS_Focus) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875
			)
			{
				GetACSWatcher().Red_Blade_Projectile_Spawner();
			}
		}
	}

	if(thePlayer.GetInventory().ItemHasTag( thePlayer.GetInventory().GetCurrentlyHeldSword(), 'acsmagestaff' ))
	{
		if (!ACSGetEquippedSword().IsEffectActive('heavy_trail_fx', false))
		{
			ACSGetEquippedSword().PlayEffectSingle( 'heavy_trail_fx' );
		}

		if (!ACSGetEquippedSword().IsEffectActive('light_trail_fx', false))
		{
			ACSGetEquippedSword().PlayEffectSingle( 'light_trail_fx' );
		}

		ACSGetEquippedSword().StopEffect( 'heavy_trail_fx' );
		ACSGetEquippedSword().StopEffect( 'light_trail_fx' );
	}

	if (thePlayer.HasTag('ACS_Ice_Giant_Mode'))
	{
		if (thePlayer.IsAnyWeaponHeld() && !thePlayer.IsWeaponHeld('fist'))
		{
			ACS_Frost_Cone();
		}
	}

	if ( 
	ACS_GetItem_Sword_IsEquipped('eredin_steel', 'steel')
	|| ACS_GetItem_Sword_IsEquipped('imlerith_steel', 'steel')
	|| ACS_GetItem_Sword_IsEquipped('nithral_steel', 'steel')
	)
	{
		ACSGetCEntity('ACS_Fire_Sword_Ent').StopEffect('ice_fire_sparks_trail');
		ACSGetCEntity('ACS_Fire_Sword_Ent').PlayEffect('ice_fire_sparks_trail');

		ACSGetCEntity('acs_sword_trail_1').StopEffect('frost_sword_trail');

		ACSGetCEntity('acs_sword_trail_2').StopEffect('frost_sword_trail');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('frost_sword_trail');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('frost_sword_trail');

		ACSGetCEntity('acs_sword_trail_1').StopEffect('sword_axii_trail');

		ACSGetCEntity('acs_sword_trail_2').StopEffect('sword_axii_trail');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('sword_axii_trail');
		ACSGetCEntity('acs_sword_trail_3').StopEffect('sword_axii_trail');



		ACSGetCEntity('ACS_Fire_Sword_Ent_Dual_Wield').StopEffect('ice_fire_sparks_trail');
		ACSGetCEntity('ACS_Fire_Sword_Ent_Dual_Wield').PlayEffect('ice_fire_sparks_trail');

		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('frost_sword_trail');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('frost_sword_trail');

		ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('frost_sword_trail');
		ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('frost_sword_trail');

		ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('sword_axii_trail');

		ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('sword_axii_trail');

		ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('sword_axii_trail');
		ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('sword_axii_trail');
	}

	if (thePlayer.HasTag('ACS_Flammable_Oil_Enabled'))
	{
		if (thePlayer.IsAnyWeaponHeld() && !thePlayer.IsWeaponHeld('fist'))
		{
			if (ACS_GetItem_SwordHeldSwitchBasedUponStat('frost_sword'))
			{
				ACSGetCEntity('ACS_Fire_Sword_Ent').StopEffect('ice_fire_sparks_trail');
				ACSGetCEntity('ACS_Fire_Sword_Ent').PlayEffect('ice_fire_sparks_trail');

				ACSGetCEntity('acs_sword_trail_1').StopEffect('frost_sword_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('frost_sword_trail');

				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('frost_sword_trail');
				ACSGetCEntity('acs_sword_trail_3').StopEffect('frost_sword_trail');

				ACSGetCEntity('acs_sword_trail_1').StopEffect('sword_axii_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('sword_axii_trail');

				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('sword_axii_trail');
				ACSGetCEntity('acs_sword_trail_3').StopEffect('sword_axii_trail');



				ACSGetCEntity('ACS_Fire_Sword_Ent_Dual_Wield').StopEffect('ice_fire_sparks_trail');
				ACSGetCEntity('ACS_Fire_Sword_Ent_Dual_Wield').PlayEffect('ice_fire_sparks_trail');

				ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('frost_sword_trail');

				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('frost_sword_trail');

				ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('frost_sword_trail');
				ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('frost_sword_trail');

				ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('sword_axii_trail');

				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('sword_axii_trail');

				ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('sword_axii_trail');
				ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('sword_axii_trail');
			}
			else if (ACS_GetItem_SwordHeldSwitchBasedUponStat('poison_sword'))
			{
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('poison_sword_trail');
				ACSGetCEntity('acs_sword_trail_1').StopEffect('poison_sword_trail');

				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('poison_sword_trail');
				ACSGetCEntity('acs_sword_trail_2').StopEffect('poison_sword_trail');

				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('poison_sword_trail');
				ACSGetCEntity('acs_sword_trail_3').StopEffect('poison_sword_trail');


				ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('poison_sword_trail');
				ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('poison_sword_trail');

				ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('poison_sword_trail');
				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('poison_sword_trail');

				ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('poison_sword_trail');
				ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('poison_sword_trail');
			}
			else if (ACS_GetItem_SwordHeldSwitchBasedUponStat('bleed_sword'))
			{
				ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('blood_sword_trail');
				ACSGetCEntity('acs_sword_trail_1').StopEffect('blood_sword_trail');

				ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('blood_sword_trail');
				ACSGetCEntity('acs_sword_trail_2').StopEffect('blood_sword_trail');

				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('blood_sword_trail');
				ACSGetCEntity('acs_sword_trail_3').StopEffect('blood_sword_trail');


				ACSGetCEntity('acs_sword_trail_1_dual_wield').PlayEffectSingle('blood_sword_trail');
				ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('blood_sword_trail');

				ACSGetCEntity('acs_sword_trail_2_dual_wield').PlayEffectSingle('blood_sword_trail');
				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('blood_sword_trail');

				ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('blood_sword_trail');
				ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('blood_sword_trail');
			} 
			else
			{
				ACSGetCEntity('ACS_Fire_Sword_Ent').StopEffect('fire_sparks_trail');
				ACSGetCEntity('ACS_Fire_Sword_Ent').PlayEffect('fire_sparks_trail');

				ACSGetCEntity('acs_sword_trail_1').StopEffect('fire_sword_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('fire_sword_trail');

				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('fire_sword_trail');
				ACSGetCEntity('acs_sword_trail_3').StopEffect('fire_sword_trail');

				ACSGetCEntity('acs_sword_trail_1').StopEffect('sword_igni_trail');

				ACSGetCEntity('acs_sword_trail_2').StopEffect('sword_igni_trail');

				ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('sword_igni_trail');
				ACSGetCEntity('acs_sword_trail_3').StopEffect('sword_igni_trail');


				ACSGetCEntity('ACS_Fire_Sword_Ent_Dual_Wield').StopEffect('fire_sparks_trail');
				ACSGetCEntity('ACS_Fire_Sword_Ent_Dual_Wield').PlayEffect('fire_sparks_trail');		

				ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('fire_sword_trail');

				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('fire_sword_trail');

				ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('fire_sword_trail');
				ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('fire_sword_trail');

				ACSGetCEntity('acs_sword_trail_1_dual_wield').StopEffect('sword_igni_trail');

				ACSGetCEntity('acs_sword_trail_2_dual_wield').StopEffect('sword_igni_trail');

				ACSGetCEntity('acs_sword_trail_3_dual_wield').PlayEffectSingle('sword_igni_trail');
				ACSGetCEntity('acs_sword_trail_3_dual_wield').StopEffect('sword_igni_trail');
			}

			if(RandF() < 0.125)
			{
				//ACSCreateGolemGroundFireFX(thePlayer.GetWorldPosition() + thePlayer.GetWorldForward(), thePlayer.GetWorldRotation());
			}
		}
	}

	ACS_BloodRootsAttach();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_PlayerHitEffects()
{
	//thePlayer.StopAllEffects(); 
	
	if ( ACS_GetWeaponMode() == 0 
	|| ACS_GetWeaponMode() == 1
	|| ACS_GetWeaponMode() == 2 )
	{
		if (thePlayer.HasTag('acs_axii_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			//thePlayer.PlayEffectSingle('ice_armor_cutscene');
			//thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			//thePlayer.PlayEffectSingle('ice_armor_cutscene');
			//thePlayer.StopEffect('ice_armor_cutscene');
		}
		else if ( thePlayer.HasTag('acs_yrden_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('black_trail');
			thePlayer.StopEffect('black_trail');
		}
		else if ( thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('hit_lightning');
			thePlayer.StopEffect('hit_lightning');
		}
		else if ( thePlayer.HasTag('acs_aard_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
		else if ( thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
		else if ( thePlayer.HasTag('acs_quen_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('acs_vampire_claws_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
	}
	else
	{
		if ( thePlayer.HasTag('acs_quen_sword_equipped') )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('olgierd_energy_blast');
			thePlayer.StopEffect('olgierd_energy_blast');
		}
		else if ( thePlayer.HasTag('acs_vampire_claws_equipped' ) )
		{
			thePlayer.PlayEffectSingle('mutation_7_adrenaline_burst');
			thePlayer.StopEffect('mutation_7_adrenaline_burst');

			thePlayer.PlayEffectSingle('weakened');
			thePlayer.StopEffect('weakened');
		}
	}
}

function ACS_AttitudeCheck( actor : CActor, optional no_distance : bool ) : bool
{
	var targetDistance 										: float;

	if ( 
	thePlayer.GetAttitude( actor ) == AIA_Friendly 
	|| !actor.IsAlive()
	|| actor == thePlayer
	|| ((CNewNPC)actor).IsHorse()
	)
	{
		return false;
	}

	if (!no_distance)
	{
		targetDistance = VecDistanceSquared2D( actor.GetWorldPosition(), thePlayer.GetWorldPosition() ) ;

		if ( targetDistance > 50 * 50
		)
		{
			return false;
		}
	}

	if ( 
	(
	thePlayer.GetAttitude( actor ) == AIA_Hostile 
	|| theGame.GetGlobalAttitude( actor.GetBaseAttitudeGroup(), 'player' ) == AIA_Hostile
	|| (actor.IsAttackableByPlayer() && actor.IsTargetableByPlayer())
	|| (thePlayer.IsHardLockEnabled() && thePlayer.GetTarget() && actor == thePlayer.GetDisplayTarget())
	)
	&& actor.IsAlive()
	&& targetDistance <= 50 * 50
	)
	{
		return true;
	}

	return false;
}

function ACS_NoticeboardCheck (radius_check: float): bool 
{
    var entities: array<CGameplayEntity>;

	entities.Clear();

    FindGameplayEntitiesInRange(entities, thePlayer, radius_check, 1, , FLAG_ExcludePlayer, , 'W3NoticeBoard');

    return entities.Size()>0;
}
  
function ACS_GuardCheck (radius_check: float): bool 
{
	var entities: array<CGameplayEntity>;
    var i: int;

	entities.Clear();

    FindGameplayEntitiesInRange(entities, thePlayer, radius_check, 100, , FLAG_ExcludePlayer, , 'CNewNPC');

    for (i = 0; i<entities.Size(); i += 1) 
	{
		if (((CNewNPC)(entities[i])).GetNPCType()==ENGT_Guard) 
		{
			return true;
		}
	}

	return false;
}

function ACS_PlayerSettlementCheck (optional radius_check: float): bool 
{
	var current_area: EAreaName;

	if ( radius_check <= 0 ) 
	{
      radius_check = 50;
    }
    
    current_area = theGame.GetCommonMapManager().GetCurrentArea();

    if ( ACS_NoticeboardCheck( radius_check ) ) 
	{
      return true;
    }
    
    if ( current_area == AN_Skellige_ArdSkellig ) 
	{
      return ACS_GuardCheck( radius_check );
    }
    
    return thePlayer.IsInSettlement() || ACS_GuardCheck (radius_check);
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ExplorationDelayHack(for_guard : bool, delay : float)
{
	if ( FactsQuerySum("acs_transformation_activated") > 0 
	|| theGame.IsDialogOrCutscenePlaying() 
	|| theGame.IsFading()
	|| theGame.IsBlackscreen()
	|| theGame.IsPaused() 
	)
	{
		return;
	}

	if (for_guard)
	{
		if( !thePlayer.IsInCombat() )
		{
			if (thePlayer.HasTag('ACS_IsSwordWalking'))
			{
				thePlayer.RemoveTag('ACS_IsSwordWalking');
			}

			GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
			GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 

			if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
			{
				thePlayer.AddTag('ACS_ExplorationDelayTag');
			}

			if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
			{
				thePlayer.AddTag('ACS_ExplorationDelayTag');
			}
		}

		GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');

		GetACSWatcher().AddTimer('ACS_ExplorationDelay', 5  , false );

		return;
	}

	if( !thePlayer.IsInCombat() )
	{
		if (thePlayer.HasTag('ACS_IsSwordWalking'))
		{
			thePlayer.RemoveTag('ACS_IsSwordWalking');
		}

		GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
		GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 

		if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
		{
			thePlayer.AddTag('ACS_ExplorationDelayTag');
		}

		if ( thePlayer.GetCurrentStateName() != 'Combat' )
		{
			thePlayer.GotoState('Combat');
		}

		if (!thePlayer.HasTag('ACS_ExplorationDelayTag'))
		{
			thePlayer.AddTag('ACS_ExplorationDelayTag');
		}
	}

	GetACSWatcher().RemoveTimer('ACS_ExplorationDelay');

	GetACSWatcher().AddTimer('ACS_ExplorationDelay', delay  , false );
}

function ACS_CombatToExplorationCheck() : bool
{
	if ( thePlayer.HasTag('ACS_ExplorationDelayTag') 
	|| thePlayer.IsGuarded() 
	|| thePlayer.IsInGuardedState() 
	|| theInput.GetActionValue('LockAndGuard') > 0.5 
	|| thePlayer.IsPerformingFinisher()
	|| thePlayer.HasTag('ACS_IsPerformingFinisher')
	|| thePlayer.HasTag('ACS_IsPerformingCombatDismember')
	)
	{
		return false;
	}

	return true;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cACS_Setup_Combat_Action_Vanilla
{
    function Setup_Combat_Action_Light_Engage()
	{
		this.PushState('Setup_Combat_Action_Light_Engage');
	}

	function Setup_Combat_Action_Heavy_Engage()
	{
		this.PushState('Setup_Combat_Action_Heavy_Engage');
	}

	function Setup_Combat_Action_Heavy_Special_Engage()
	{
		this.PushState('Setup_Combat_Action_Heavy_Special_Engage');
	}

	function Setup_Combat_Action_CastSign_Engage()
	{
		this.PushState('Setup_Combat_Action_CastSign_Engage');
	}
}

state Setup_Combat_Action_Light_Engage in cACS_Setup_Combat_Action_Vanilla
{	
	event OnEnterState(prevStateName : name)
	{
		Attack_Light_Entry();
	}
	
	entry function Attack_Light_Entry()
	{
		if (thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG'))
		{
			thePlayer.RemoveTag('acs_igni_secondary_sword_equipped_TAG');	
		}
		
		if (!thePlayer.HasTag('acs_igni_sword_equipped_TAG'))
		{
			thePlayer.AddTag('acs_igni_sword_equipped_TAG');	
		}

		if (thePlayer.HasTag('ACS_IsSwordWalking'))
		{
			thePlayer.RemoveTag('ACS_IsSwordWalking');
		}

		GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
		GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
		 
		 

		if ( GetACSWatcher().AnimProgressCheck() )
		{
			if (!thePlayer.IsOnGround()
			)
			{
				//thePlayer.RaiseEvent('ACS_ForceLegsFloatIdle');
			}
			else
			{
				if (thePlayer.HasTag('ACS_IsSwordWalking'))
				{
					thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RaiseEvent('ACS_CombatTauntEnd');GetACSWatcher().RemoveTimer('CombatTauntDelay');thePlayer.RaiseEvent('ACS_SwordTauntEnd');

					thePlayer.RemoveTag('ACS_IsSwordWalking');
				}
			}
		}

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(1, 1) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_LightAttack, BS_Pressed );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Setup_Combat_Action_Heavy_Engage in cACS_Setup_Combat_Action_Vanilla
{	
	event OnEnterState(prevStateName : name)
	{
		Attack_Heavy_Entry();
	}

	entry function Attack_Heavy_Entry()
	{
		if (thePlayer.HasTag('ACS_IsSwordWalking'))
		{
			thePlayer.RemoveTag('ACS_IsSwordWalking');
		}

		GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
		GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
		 
		 

		if ( GetACSWatcher().AnimProgressCheck() )
		{
			if (!thePlayer.IsOnGround()
			)
			{
				//thePlayer.RaiseEvent('ACS_ForceLegsFloatIdle');
			}
			else
			{
				thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RaiseEvent('ACS_CombatTauntEnd');GetACSWatcher().RemoveTimer('CombatTauntDelay');thePlayer.RaiseEvent('ACS_SwordTauntEnd');
			}
		}

		if (thePlayer.HasTag('acs_igni_sword_equipped_TAG'))
		{
			thePlayer.RemoveTag('acs_igni_sword_equipped_TAG');	
		}
		
		if (!thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG'))
		{
			thePlayer.AddTag('acs_igni_secondary_sword_equipped_TAG');	
		}

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(1, 1) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_HeavyAttack, BS_Released );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Setup_Combat_Action_Heavy_Special_Engage in cACS_Setup_Combat_Action_Vanilla
{	
	event OnEnterState(prevStateName : name)
	{
		Attack_Heavy_Special_Entry();
	}

	entry function Attack_Heavy_Special_Entry()
	{
		if (thePlayer.HasTag('ACS_IsSwordWalking'))
		{
			thePlayer.RemoveTag('ACS_IsSwordWalking');
		}

		GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
		GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
		 

		if ( GetACSWatcher().AnimProgressCheck() )
		{
			if (!thePlayer.IsOnGround()
			)
			{
				//thePlayer.RaiseEvent('ACS_ForceLegsFloatIdle');
			}
			else
			{
				thePlayer.RaiseEvent('ACS_SwordWalkAdditiveEnd');thePlayer.RaiseEvent('ACS_CombatTauntEnd');GetACSWatcher().RemoveTimer('CombatTauntDelay');thePlayer.RaiseEvent('ACS_SwordTauntEnd');
			}
		}

		GetACSWatcher().DeactivateThings();
		
		ACS_ThingsThatShouldBeRemoved();

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(1, 1) );
		}

		Sleep(0.0625);

		thePlayer.PrepareToAttack();
		thePlayer.SetPlayedSpecialAttackMissingResourceSound(false);
		thePlayer.AddTimer( 'IsSpecialHeavyAttackInputHeld', 0.00001 , true );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

state Setup_Combat_Action_CastSign_Engage in cACS_Setup_Combat_Action_Vanilla
{	
	event OnEnterState(prevStateName : name)
	{
		CastSign_Entry();
	}

	entry function CastSign_Entry()
	{
		GetACSWatcher().DeactivateThings();

		ACS_ThingsThatShouldBeRemoved();

		if (thePlayer.IsAlive())
		{
			thePlayer.GetRootAnimatedComponent().PlaySlotAnimationAsync( '', 'PLAYER_SLOT', SAnimatedComponentSlotAnimationSettings(0, 0) );
		}

		Sleep(0.0625);

		thePlayer.SetupCombatAction( EBAT_CastSign, BS_Pressed );
	}
	
	event OnLeaveState( nextStateName : name ) 
	{
		super.OnLeaveState(nextStateName);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetACSWatcher() : W3ACSWatcher
{
	var watcher 			 : W3ACSWatcher;
	
	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	return watcher;
}


function GetACSWatcherSecondary() : W3ACSWatcherSecondary
{
	var watcher 			 : W3ACSWatcherSecondary;
	
	watcher = (W3ACSWatcherSecondary)theGame.GetEntityByTag( 'acswatchersecondary' );

	return watcher;
}

quest function modStartACS() 
{
	var entity						: CEntity;
	var template					: CEntityTemplate;

	template = (CEntityTemplate)LoadResource("dlc\dlc_acs\data\ACS_Mordor.w2ent", true);

	if ( 
	!theGame.GetEntityByTag('acswatcherspawner') 
	)
	{
		entity = theGame.CreateEntity( template, thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation() );
	}

	FactsRemove("acs_started");
   	FactsAdd("acs_started", 1);
}

quest function modIsACSStarted() : bool
{
	return FactsQuerySum("acs_started") > 0;
}

statemachine class W3ACSWatcherSpawner extends CEntity
{
	event OnSpawned( spawnData : SEntitySpawnData )
	{
		this.PushState('ACS_PLAYER_CHECK');
	}
}

state ACS_PLAYER_CHECK in W3ACSWatcherSpawner 
{
	private var ent_watcher 					: W3ACSWatcher;
	private var ent_watcher_secondary 			: W3ACSWatcherSecondary;
	private var ent_storage 					: W3ACSStorage;	
	private var hud 							: CR4ScriptedHud;
	private var onelinersModule 				: CR4HudModuleOneliners;

	event OnEnterState(previous_state_name: name) 
	{
    	super.OnEnterState(previous_state_name);
	
    	ACS_PlayerCheck_ENTRY();
	}

	entry function ACS_PlayerCheck_ENTRY() 
	{
		while (true) 
		{
			ACS_PlayerCheck_LATENT();

      		SleepOneFrame();
    	}
	}

	latent function ACS_PlayerCheck_LATENT() 
	{
		if (thePlayer.IsCiri())
		{
			if (GetACSWatcher())
			{
				if (theGame.GetInGameConfigWrapper().GetVarValue('acs_visual_main_settings', 'DisableBigCameraLights' ) != "false" )
				{
					theGame.GetInGameConfigWrapper().SetVarValue('acs_visual_main_settings', 'DisableBigCameraLights', "false");
				}

				if (theGame.GetInGameConfigWrapper().GetVarValue('acs_visual_main_settings', 'DisableSmallCameraLights' ) != "false" )
				{
					theGame.GetInGameConfigWrapper().SetVarValue('acs_visual_main_settings', 'DisableSmallCameraLights', "false");
				}

				if (theGame.GetInGameConfigWrapper().GetVarValue('acs_visual_main_settings', 'DisableAllCameraLights' ) != "false" )
				{
					theGame.GetInGameConfigWrapper().SetVarValue('acs_visual_main_settings', 'DisableAllCameraLights', "false");
				}

				GetACSStorage().ResetOnelinerIDs();

				GetACSWatcher().HudModulesAutoHide();

				hud = (CR4ScriptedHud)theGame.GetHud();

				theGame.GetInGameConfigWrapper().SetVarValue('Hud', 'OnelinersModule', "false");

				onelinersModule = (CR4HudModuleOneliners)hud.GetHudModule( "OnelinersModule" );
				onelinersModule.SetEnabled(false);

				hud.UpdateHUD();
				thePlayer.inv.AddAnItem('Wolfsbane', 12);
				thePlayer.inv.AddAnItem('Fools parsley leaves', 12);

				GetACSWatcher().Destroy();
			}

			return;
		}

		if ( thePlayer
		&& GetWitcherPlayer()
		)
		{	
			if ( GetACSStorage() 
			&& GetACSWatcher() 
			&& GetACSWatcherSecondary() 
			)
			{
				return;
			}

			if ( !GetACSStorage() )
			{
				ent_storage = (W3ACSStorage)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\ACS_Orodruin.w2ent", true ), thePlayer.GetWorldPosition(), , , , , PM_Persist);
			}

			SleepOneFrame();

			if ( !GetACSWatcher() )
			{
				ent_watcher = (W3ACSWatcher)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\ACS_Baraddur.w2ent", true ), thePlayer.GetWorldPosition() );
			}

			SleepOneFrame();

			if ( !GetACSWatcherSecondary() )
			{
				ent_watcher_secondary = (W3ACSWatcherSecondary)theGame.CreateEntity( (CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\ACS_Orthanc.w2ent", true ), thePlayer.GetWorldPosition() );
			}
		}
	}
}

function ACS_Phantom_Create()
{
	var ent          									: CEntity;
	var rot                      						: EulerAngles;
    var pos												: Vector;
	var targetDistance, targetDistanceActual 			: Float;

	if(thePlayer.IsUsingHorse()
	|| thePlayer.IsUsingVehicle()
	|| thePlayer.HasTag('acs_vampire_claws_equipped')
	|| thePlayer.HasTag('acs_sorc_fists_equipped') 
	)
	{
		return;
	}

	targetDistance = VecDistanceSquared2D( thePlayer.GetWorldPosition(), ((CNewNPC)(thePlayer.GetTarget())).GetWorldPosition() );

	if (ACS_Armor_Set_Check('acs_armor', false)
	)
	{
		targetDistanceActual = 6;
	}
	else
	{
		targetDistanceActual = 4;
	}

	if (thePlayer.IsWeaponHeld('fist') 
	)
	{
		if(thePlayer.GetStat( BCS_Focus ) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875
		&& (thePlayer.IsThreatened() || thePlayer.IsInCombat())
		&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
		&& !thePlayer.HasTag('ACS_IsPerformingCombatDismember')
		&& targetDistance <= targetDistanceActual * targetDistanceActual
		&& thePlayer.GetTarget()
		&& thePlayer.moveTarget
		&& thePlayer.GetTarget() == thePlayer.moveTarget
		&& !((CNewNPC)(thePlayer.GetTarget())).IsFlying()
		&& !thePlayer.IsDodgeTimerRunning()
		&& !thePlayer.IsCurrentlyDodging()
		&& ACS_BuffCheck()
		&& !thePlayer.IsInHitAnim() 
		)
		{
			rot = thePlayer.GetWorldRotation();

			pos = thePlayer.GetWorldPosition();

			ACS_Tutorial_Display_Check('ACS_Phantom_Attack_Tutorial_Shown');

			ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\geralt_phantom.w2ent", true ), pos, rot );

			ent.AddTag('ACS_Phantom_Fists');
		}

		return;
	}

	if((thePlayer.HasTag('acs_igni_sword_equipped')
	|| thePlayer.HasTag('acs_igni_sword_equipped_TAG')
	|| thePlayer.HasTag('acs_igni_secondary_sword_equipped')
	|| thePlayer.HasTag('acs_igni_secondary_sword_equipped_TAG'))
	&& thePlayer.GetStat( BCS_Focus ) >= thePlayer.GetStatMax( BCS_Focus ) * 0.9875
	&& !thePlayer.IsDoingSpecialAttack(false)
	&& !thePlayer.IsDoingSpecialAttack(true)
	&& thePlayer.IsAnyWeaponHeld()
	&& !thePlayer.IsWeaponHeld('fist')
	&& (thePlayer.IsThreatened() || thePlayer.IsInCombat())
	&& !thePlayer.HasTag('ACS_IsPerformingFinisher')
	&& !thePlayer.HasTag('ACS_IsPerformingCombatDismember')
	&& targetDistance <= targetDistanceActual * targetDistanceActual
	&& thePlayer.GetTarget()
	&& thePlayer.moveTarget
	&& thePlayer.GetTarget() == thePlayer.moveTarget
	&& !((CNewNPC)(thePlayer.GetTarget())).IsFlying()
	&& !thePlayer.IsDodgeTimerRunning()
	&& !thePlayer.IsCurrentlyDodging()
	&& ACS_BuffCheck()
	&& !thePlayer.IsInHitAnim() 
	)
	{
		rot = thePlayer.GetWorldRotation();

		pos = thePlayer.GetWorldPosition();

		ACS_Tutorial_Display_Check('ACS_Phantom_Attack_Tutorial_Shown');

		ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\geralt_phantom.w2ent", true ), pos, rot );
	}
}

function ACS_Armor_Cone()
{
	var ent          									: CEntity;
	var rot                      						: EulerAngles;
    var pos, proj_pos, targetPosition					: Vector;
	var proj_1	 										: W3ACSArmorPhysxProjectile;
	var projectileCollision 							: array< name >;

	projectileCollision.Clear();
	projectileCollision.PushBack( 'Projectile' );
	projectileCollision.PushBack( 'Door' );
	projectileCollision.PushBack( 'Static' );		
	projectileCollision.PushBack( 'ParticleCollider' ); 

	//ACSGetCEntity('ACS_Armor_Cone').Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition();

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\pc_aard_mq1060.w2ent", true ), pos, rot );

	ent.AddTag('ACS_Armor_Cone');

	ent.DestroyAfter(1);

	ent.PlayEffectSingle('acs_armor_cone_orig');
	ent.PlayEffectSingle('acs_armor_cone');


	proj_pos = thePlayer.GetWorldPosition();	
	proj_pos.Z += 0.5;		

	targetPosition = thePlayer.GetWorldPosition() + thePlayer.GetHeadingVector() + thePlayer.GetWorldForward() * 15;
			
	proj_1 = (W3ACSArmorPhysxProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\fx\acs_armor_projectile.w2ent"
		
	, true ), proj_pos, rot );
					
	proj_1.Init(thePlayer);
	proj_1.SetAttackRange( theGame.GetAttackRangeForEntity( ent, 'cone' ) );
	proj_1.ShootCakeProjectileAtPosition( 60, 3.5f, 0.0f, 30.0f, targetPosition, 500, projectileCollision );		
	proj_1.DestroyAfter(1);
}

function ACS_Frost_Cone()
{
	var ent          									: CEntity;
	var rot                      						: EulerAngles;
    var pos												: Vector;

	//ACSGetCEntity('ACS_Frost_Cone').Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward();

	pos.Z += 1.5;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), pos, rot );

	ent.AddTag('ACS_Frost_Cone');

	ent.DestroyAfter(5);

	ent.PlayEffectSingle('cone_ground_mutation_6_aard');

	thePlayer.SoundEvent("phx_ice_break_small");

	thePlayer.SoundEvent("phx_ice_break_medium");

	thePlayer.SoundEvent("phx_ice_break_big");

	theGame.GetSurfacePostFX().AddSurfacePostFXGroup( TraceFloor( thePlayer.GetWorldPosition() ), 0.125f, 3, 0.125f, 10.f, 0);
}

function ACS_Poison_Cloud()
{
	var ent          									: CEntity;
	var rot                      						: EulerAngles;
    var pos												: Vector;

	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var i 								: int;
	var dmg								: W3DamageAction;
	var damageMax, damageMin			: float;


	//ACSGetCEntity('ACS_Frost_Cone').Destroy();

	rot = thePlayer.GetWorldRotation();

    pos = thePlayer.GetWorldPosition() + thePlayer.GetWorldForward();

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent", true ), pos, rot );

	ent.AddTag('ACS_Poison_Cloud');

	ent.DestroyAfter(10);

	ent.PlayEffectSingle('poison_cloud');

	ent.SoundEvent("proc_viral_wf_acs");

	ent.SoundEvent("proc_poison_wf_acs");

	ent.SoundEvent("proc_gas_wf_acs");

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 5, 10, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		for ( i=0; i<actors.Size(); i+= 1 )
		{
			dmg = new W3DamageAction in theGame.damageMgr;

			actor = actors[i];
				
			dmg.Initialize(GetWitcherPlayer(), actor, NULL, GetWitcherPlayer().GetName(), EHRT_Heavy, CPS_Undefined, false, false, true, false);
			
			dmg.SetProcessBuffsIfNoDamage(true);
			
			dmg.SetHitReactionType( EHRT_Heavy, true);

			if (actor.UsesVitality()) 
			{ 
				damageMax = actor.GetStat( BCS_Vitality ) * 0.025; 
				
				damageMin = actor.GetStat( BCS_Vitality ) * 0.0125; 
			} 
			else if (actor.UsesEssence()) 
			{ 
				damageMax = actor.GetStat( BCS_Essence ) * 0.025; 
				
				damageMin = actor.GetStat( BCS_Essence ) * 0.0125; 
			} 

			damageMax += damageMax * ACS_SignIntensityPercentage('total') * 0.5;

			damageMin += damageMin * ACS_SignIntensityPercentage('total') * 0.5;

			dmg.AddDamage( theGame.params.DAMAGE_NAME_POISON, RandRangeF(damageMax,damageMin) );

			dmg.AddEffectInfo( EET_Poison, 3 );
				
			theGame.damageMgr.ProcessAction( dmg );
				
			delete dmg;
		}
	}
}


/*
function ACS_RedBladeProjectileActual_old()
{
	var proj_1								: ACSBladeProjectile;
	var initpos, newpos, targetPosition		: Vector;

	thePlayer.SoundEvent("magic_sorceress_vfx_hit_electric");

	thePlayer.SoundEvent("magic_sorceress_vfx_lightning_bolt");

	initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector();	
	initpos.Z += 1.1;

	targetPosition = initpos + GetWitcherPlayer().GetHeadingVector() * 30;
	//targetPosition.Z += 0.25;
	
	proj_1 = (ACSBladeProjectile)theGame.CreateEntity( 
	(CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent"
		
		, true ), initpos );
					
	proj_1.Init(thePlayer);

	proj_1.ShootProjectileAtPosition( 0, 25, targetPosition, 500 );
	proj_1.DestroyAfter(10);
}
*/

/*
function ACS_RedBladeProjectileActual360()
{
	var proj_1, proj_2, proj_3																				: ACSBladeProjectile;
	var initpos, targetPosition_1, targetPosition_2, targetPosition_3										: Vector;
	var temp																								: CEntityTemplate;

	thePlayer.SoundEvent("cmb_wildhunt_boss_weapon_swoosh");

	temp = (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\projectiles\blade_projectile.w2ent", true );

	initpos = GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetHeadingVector();	
	initpos.Z += 1.1;

	targetPosition_1 = initpos + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_1.Z += 0.25;

	proj_1 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_1.Init(thePlayer);

	proj_1.ShootProjectileAtPosition( 0, 25, targetPosition_1, 500 );
	proj_1.DestroyAfter(10);




	targetPosition_2 = initpos  +GetWitcherPlayer().GetWorldRight() * 10 + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_2.Z += 0.25;

	proj_2 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_2.Init(thePlayer);

	proj_2.ShootProjectileAtPosition( 0, 25, targetPosition_2, 500 );
	proj_2.DestroyAfter(10);





	targetPosition_3 = initpos + GetWitcherPlayer().GetWorldRight() * -10 + GetWitcherPlayer().GetHeadingVector() * 30;
	targetPosition_3.Z += 0.25;

	proj_3 = (ACSBladeProjectile)theGame.CreateEntity( temp, initpos );
					
	proj_3.Init(thePlayer);

	proj_3.ShootProjectileAtPosition( 0, 25, targetPosition_3, 500 );
	proj_3.DestroyAfter(10);
}
*/



exec function acsmonsterspawn( optional entTag: name , optional dist : float , optional spawnInFrame : bool )
{
	var ent	: CACSMonsterSpawner;

	if (dist)
	{
		ent = (CACSMonsterSpawner)theGame.CreateEntity( 

		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_monster_spawner.w2ent", true ), 

		theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * dist, 

		thePlayer.GetWorldRotation() );
	}
	else
	{
		ent = (CACSMonsterSpawner)theGame.CreateEntity( 

		(CEntityTemplate)LoadResource( "dlc\dlc_acs\data\entities\other\acs_monster_spawner.w2ent", true ), 

		theCamera.GetCameraPosition() + VecFromHeading(theCamera.GetCameraHeading()) * 15, 

		thePlayer.GetWorldRotation() );
	}

	ent.AddTag(entTag);

	if (spawnInFrame)
	{
		ent.AddTag('ACS_MonsterSpawner_Spawn_In_Frame');
	}
}

exec function acsspawn(optional nam : name, optional quantity : name)
{
	var ent                  					: CEntity;

	var rot : EulerAngles;

	rot = GetWitcherPlayer().GetWorldRotation();

	rot.Yaw += 180;

	ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\entities\other\acs_interaction_switch.w2ent"

	, true ), ACSFixZAxis(GetWitcherPlayer().GetWorldPosition() + GetWitcherPlayer().GetWorldForward() * 3), rot );

	if(nam)
	{
		ent.AddTag(nam);
	}
	
	if(quantity)
	{
		ent.AddTag(quantity);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetQuestPoint() : bool
{
	var i 						: int;
	var pinInstances 			: array<SCommonMapPinInstance>;

	pinInstances.Clear();

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (pinInstances[i].isDiscovered || pinInstances[i].isKnown) 
		{
			if (
			theGame.GetCommonMapManager().IsQuestPinType(pinInstances[i].type)
			)
			{
				if (pinInstances[i].isHighlighted)
				{
					if (pinInstances.Size() > 0)
					return true;
				}
			}
		}
	}

	return false;
}

function ACS_GetQuestPointPosition( out pinPos : Vector ) : bool
{
	var i 						: int;
	var pinInstances 			: array<SCommonMapPinInstance>;

	pinInstances.Clear();

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (pinInstances[i].isDiscovered || pinInstances[i].isKnown) 
		{
			if (
			theGame.GetCommonMapManager().IsQuestPinType(pinInstances[i].type)
			)
			{
				if (pinInstances[i].isHighlighted)
				{
					pinPos = pinInstances[i].position;
					return true;
				}
			}
		}
	}

	return false;
}

enum ACSAreaPositionType
{
	ACSAreaPos_Unknown,		
	ACSAreaPos_Invalid,		
	ACSAreaPos_Valid		
}

struct ACSQuestMapPin
{
	var tag : name;
	var questArea : EAreaName;
	var questObjective : CJournalQuestObjective;
	var position : Vector;
	var areaPosType : ACSAreaPositionType;
	var titleStringId : int;
	var descriptionStringId : int;
	var questLevel  : int;
}

function ACSFixZAxis(pos : Vector, optional water_level_fix_skip : bool ) : Vector
{ 
	var z : float; 

	if(thePlayer.IsInInterior() || thePlayer.IsSwimming() || thePlayer.IsDiving())
	{
		pos = TraceFloor(pos);

		if (water_level_fix_skip)
		{
			return pos;
		}

		if (pos.Z < theGame.GetWorld().GetWaterLevel(pos, true))
		{
			pos.Z = theGame.GetWorld().GetWaterLevel(pos, true);
		}	

		return pos;
	}
	else
	{
		if (theGame.GetWorld().NavigationComputeZ(pos, pos.Z - 128, pos.Z + 128, z)) 
		{ 
			pos.Z = z; 
		} 
		else if (theGame.GetWorld().PhysicsCorrectZ(pos, z)) 
		{ 
			pos.Z = z; 
		}

		if (water_level_fix_skip)
		{
			return pos;
		}

		if (pos.Z < theGame.GetWorld().GetWaterLevel(pos, true))
		{
			pos.Z = theGame.GetWorld().GetWaterLevel(pos, true);
		}	
	}

	return pos;
}

function ACSGetKestralCamera() : ACSKestralCamera
{
	var entity 			 : ACSKestralCamera;

	entity = (ACSKestralCamera)theGame.GetEntityByTag( 'ACS_Kestral_Custom_Camera' );

	return entity;
}

function ACS_GetClosestPOIPointPosition(out pinPos : Vector) : bool
{
	var poi_pins							: array<Vector>;
	var poi_names							: array<String>;
	var all_pins							: array<SEntityMapPinInfo>;
	var i, j								: int;
	var ents 								: array<CEntity>;

	var k, size 							: int;
	var pinToPlayerDistances 				: array< float >;
	var closestPinIndex						: int;

	all_pins.Clear();

	all_pins = theGame.GetCommonMapManager().GetEntityMapPins(theGame.GetWorld().GetDepotPath());

	for (i = 0; i<all_pins.Size(); i += 1) 
	{
		if 
		(
		all_pins[i].entityType =='MonsterNest' 
		|| all_pins[i].entityType =='InfestedVineyard' 
		|| all_pins[i].entityType =='BanditCamp' 
		|| all_pins[i].entityType =='BanditCampfire' 
		|| all_pins[i].entityType =='BossAndTreasure' 
		|| all_pins[i].entityType =='RescuingTown' 
		|| all_pins[i].entityType =='DungeonCrawl' 
		|| all_pins[i].entityType =='Hideout' 
		|| all_pins[i].entityType =='Plegmund' 
		|| all_pins[i].entityType =='KnightErrant' 
		|| all_pins[i].entityType =='WineContract' 
		|| all_pins[i].entityType =='SignalingStake' 
		|| all_pins[i].entityType =='TreasureHuntMappin'
		|| all_pins[i].entityType =='PlaceOfPower' 
		|| all_pins[i].entityType =='SpoilsOfWar' 
		|| all_pins[i].entityType =='Contraband' 
		|| all_pins[i].entityType =='ContrabandShip' 
		|| all_pins[i].entityType =='PointOfInterestMappin' 
		|| all_pins[i].entityType =='QuestAvailable' 
		|| all_pins[i].entityType =='QuestAvailableHoS' 
		|| all_pins[i].entityType =='QuestAvailableBaW'
		|| all_pins[i].entityType =='NotDiscoveredPOI' 
		|| all_pins[i].entityType =='MagicLamp' 
		) 
		{
			if ( theGame.GetCommonMapManager().IsEntityMapPinDisabled(all_pins[i].entityName) )
			{
				continue;
			}

			poi_pins.PushBack(all_pins[i].entityPosition);
		}
	}

	ents.Clear();

	theGame.GetEntitiesByTag( 'ACS_MonsterSpawner_POI_Point', ents );	

	for( j = 0; j < ents.Size(); j += 1 )
	{
		if (ents.Size() > 0)
		{
			poi_pins.PushBack(ents[j].GetWorldPosition());
		}
	}

	pinToPlayerDistances.Resize( poi_pins.Size() );

	if ( poi_pins.Size() > 0 )
	{
		for ( k = 0; k < poi_pins.Size(); k += 1 )
		{
			pinToPlayerDistances[k] = VecDistanceSquared2D( poi_pins[k], thePlayer.GetWorldPosition() );
		}

		closestPinIndex = ArrayFindMinF( pinToPlayerDistances );

		pinPos = poi_pins[ closestPinIndex ];

		return true;
	}

	return false;
}

/*
function ACS_MapPins() : array<SCommonMapPinInstance>
{
	var i 												: int;
	var pinInstances 									: array<SCommonMapPinInstance>;
	var questPins										: array<SCommonMapPinInstance>;

	pinInstances.Clear();

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (
		pinInstances[i].visibleType == 'QuestAvailable'
		|| pinInstances[i].visibleType =='QuestAvailableHoS' 
		|| pinInstances[i].visibleType =='QuestAvailableBaW' 
		|| pinInstances[i].visibleType =='QuestReturn' 
		|| pinInstances[i].visibleType =='MonsterQuest' 
		|| pinInstances[i].visibleType =='TreasureQuest' 
		|| pinInstances[i].visibleType =='StoryQuest' 
		|| pinInstances[i].visibleType =='ChapterQuest' 
		|| pinInstances[i].visibleType =='SideQuest' 
		|| pinInstances[i].visibleType =='QuestBelgard' 
		|| pinInstances[i].visibleType =='QuestCoronata' 
		|| pinInstances[i].visibleType =='QuestVermentino' 
		|| pinInstances[i].visibleType =='HorseRace' 
		|| pinInstances[i].visibleType =='BoatRace' 
		|| pinInstances[i].visibleType =='NoticeBoardFull' 
		//|| pinInstances[i].visibleType =='RoadSign' 
		//|| pinInstances[i].visibleType =='Harbor' 
		|| pinInstances[i].visibleType =='MonsterNest' 
		|| pinInstances[i].visibleType =='InfestedVineyard' 
		|| pinInstances[i].visibleType =='BanditCamp' 
		|| pinInstances[i].visibleType =='BanditCampfire' 
		|| pinInstances[i].visibleType =='BossAndTreasure' 
		|| pinInstances[i].visibleType =='RescuingTown' 
		|| pinInstances[i].visibleType =='DungeonCrawl' 
		|| pinInstances[i].visibleType =='Hideout' 
		|| pinInstances[i].visibleType =='Plegmund' 
		|| pinInstances[i].visibleType =='KnightErrant' 
		|| pinInstances[i].visibleType =='WineContract' 
		|| pinInstances[i].visibleType =='SignalingStake' 
		|| pinInstances[i].visibleType =='TreasureHuntMappin'
		|| pinInstances[i].visibleType =='PlaceOfPower' 
		|| pinInstances[i].visibleType =='SpoilsOfWar' 
		|| pinInstances[i].visibleType =='Contraband' 
		|| pinInstances[i].visibleType =='ContrabandShip' 
		|| pinInstances[i].visibleType =='PointOfInterestMappin' 
		|| pinInstances[i].visibleType =='NotDiscoveredPOI' 
		|| pinInstances[i].visibleType =='MagicLamp' 
		) 
		{
			questPins.PushBack(pinInstances[i]);
		}
	}
	
	return questPins;
}
*/

function ACS_MapPinsCheck() : bool
{
	var pinInstances 				: array<CEntity>;
	var i, size 					: int;
	var pinToPlayerDistances 		: array< float >;
	var closestPinIndex				: int;
	var mappins						: array<CEntity>;
	var pinPos						: Vector;

	if (thePlayer.IsInInterior()
	|| ACS_Settings_Main_Float('acs_hud_settings_markers','acs_compass_or_floating_3d_markers', 0) == 1
	|| FactsQuerySum("q001_nightmare_ended") <= 0
	)
	{
		return false;
	}

	pinInstances.Clear();

	theGame.GetEntitiesByTag('ACS_POI_Trigger_Entity', pinInstances);

	pinToPlayerDistances.Resize( pinInstances.Size() );

	if ( pinInstances.Size() > 0 )
	{
		for ( i = 0; i < pinInstances.Size(); i += 1 )
		{
			pinToPlayerDistances[i] = VecDistanceSquared2D( mappins[i].GetWorldPosition(), thePlayer.GetWorldPosition() );
		}

		closestPinIndex = ArrayFindMinF( pinToPlayerDistances );

		pinPos = mappins[ closestPinIndex ].GetWorldPosition();

		if (VecDistanceSquared2D( pinPos, thePlayer.GetWorldPosition() ) <= ACS_Settings_Main_Float('acs_hud_settings_main','acs_nearby_poi_detection_effect_range', 30) * ACS_Settings_Main_Float('acs_hud_settings_main','acs_nearby_poi_detection_effect_range', 30))
		{
			return true;
		}
	}

	return false;
}

function ACS_GetClosestAvailableQuestPointPosition(out pinPos : Vector) : bool
{
	var i, j 											: int;
	var pinInstances 									: array<SCommonMapPinInstance>;
	var questPins										: array<SCommonMapPinInstance>;
	var journalManager									: CWitcherJournalManager;
	var trackedQuest 									: CJournalQuest;
	var pinToPlayerDistances 							: array< float >;
	var closestPinIndex									: int;

	pinInstances.Clear();

	pinInstances = theGame.GetCommonMapManager().GetMapPinInstances(theGame.GetWorld().GetPath());

	for (i = 0; i < pinInstances.Size(); i += 1) 
	{
		if (
		pinInstances[i].visibleType == 'QuestAvailable'
		|| pinInstances[i].visibleType =='QuestAvailableHoS' 
		|| pinInstances[i].visibleType =='QuestAvailableBaW' 
		|| pinInstances[i].visibleType =='QuestReturn' 
		|| pinInstances[i].visibleType =='MonsterQuest' 
		|| pinInstances[i].visibleType =='TreasureQuest' 
		//|| pinInstances[i].visibleType =='StoryQuest' 
		|| pinInstances[i].visibleType =='ChapterQuest' 
		|| pinInstances[i].visibleType =='SideQuest' 
		|| pinInstances[i].visibleType =='QuestBelgard' 
		|| pinInstances[i].visibleType =='QuestCoronata' 
		|| pinInstances[i].visibleType =='QuestVermentino' 
		|| pinInstances[i].visibleType =='HorseRace' 
		|| pinInstances[i].visibleType =='BoatRace' 
		|| pinInstances[i].visibleType =='NoticeBoardFull' 
		|| pinInstances[i].visibleType =='RoadSign' 
		|| pinInstances[i].visibleType =='Harbor' 
		
		/*
		|| pinInstances[i].visibleType =='MonsterNest' 
		|| pinInstances[i].visibleType =='InfestedVineyard' 
		|| pinInstances[i].visibleType =='BanditCamp' 
		|| pinInstances[i].visibleType =='BanditCampfire' 
		|| pinInstances[i].visibleType =='BossAndTreasure' 
		|| pinInstances[i].visibleType =='RescuingTown' 
		|| pinInstances[i].visibleType =='DungeonCrawl' 
		|| pinInstances[i].visibleType =='Hideout' 
		|| pinInstances[i].visibleType =='Plegmund' 
		|| pinInstances[i].visibleType =='KnightErrant' 
		|| pinInstances[i].visibleType =='WineContract' 
		|| pinInstances[i].visibleType =='SignalingStake' 
		|| pinInstances[i].visibleType =='TreasureHuntMappin'
		|| pinInstances[i].visibleType =='PlaceOfPower' 
		|| pinInstances[i].visibleType =='SpoilsOfWar' 
		|| pinInstances[i].visibleType =='Contraband' 
		|| pinInstances[i].visibleType =='ContrabandShip' 
		|| pinInstances[i].visibleType =='PointOfInterestMappin' 
		|| pinInstances[i].visibleType =='NotDiscoveredPOI' 
		*/
		) 
		{
			if ((pinInstances[i].isDiscovered || pinInstances[i].isKnown)
			&& theGame.GetCommonMapManager().IsQuestPinType(pinInstances[i].type)
			&& pinInstances[i].isHighlighted
			) 
			{
				return false;
			}
			else
			{
				questPins.PushBack(pinInstances[i]);

				pinToPlayerDistances.Resize( questPins.Size() );

				if ( questPins.Size() > 0 )
				{
					for ( j = 0; j < questPins.Size(); j += 1 )
					{
						pinToPlayerDistances[i] = VecDistanceSquared2D( questPins[j].position, thePlayer.GetWorldPosition() );
					}

					closestPinIndex = ArrayFindMinF( pinToPlayerDistances );

					pinPos = questPins[ closestPinIndex ].position;

					return true;
				}
			}
		}
	}

	return false;

}

////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetNearbyEnemyLocation() : Vector
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var i								: int;
	var pos								: Vector;
	var enemy_target 					: CActor;
	var targetDistance 					: float;




	if ((CNewNPC)thePlayer.GetTarget()
	&& ACS_AttitudeCheck ( ((CActor)thePlayer.GetTarget()) ) 
	&& thePlayer.GetAttitude( (CNewNPC)thePlayer.GetTarget() ) == AIA_Hostile 
	)
	{
		pos = ((CActor)thePlayer.GetTarget()).GetWorldPosition();

		targetDistance = VecDistanceSquared2D( pos, GetWitcherPlayer().GetWorldPosition() );

		if (targetDistance > ACS_Settings_Main_Float('acs_hud_settings_markers','acs_enemy_marker_distance_to_display', 50) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_enemy_marker_distance_to_display', 50))
		{
			pos = Vector(0,0,-200);
		}

		return pos;
	}

	thePlayer.FindMoveTarget();

	if (thePlayer.moveTarget
	&& ACS_AttitudeCheck ( thePlayer.moveTarget ) 
	&& thePlayer.GetAttitude( thePlayer.moveTarget ) == AIA_Hostile 
	)
	{
		if (ACS_AttitudeCheck ( thePlayer.moveTarget ) 
		&& thePlayer.GetAttitude( thePlayer.moveTarget ) == AIA_Hostile 
		)
		{
			pos = (thePlayer.moveTarget).GetWorldPosition();

			targetDistance = VecDistanceSquared2D( pos, GetWitcherPlayer().GetWorldPosition() );

			if (targetDistance > ACS_Settings_Main_Float('acs_hud_settings_markers','acs_enemy_marker_distance_to_display', 50) * ACS_Settings_Main_Float('acs_hud_settings_markers','acs_enemy_marker_distance_to_display', 50))
			{
				pos = Vector(0,0,-200);
			}

			return pos;
		}
	}

	/*
	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( ACS_Settings_Main_Float('acs_hud_settings_markers','acs_enemy_marker_distance_to_display', 50), 10, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		for (i = 0; i < actors.Size(); i += 1) 
		{
			if (((CNewNPC)actors[i]).IsHorse())
			{
				continue;
			}

			pos = actors[i].GetWorldPosition();

			return pos;
		}
	}
	*/
	
	pos = Vector(0,0,-200);

	return pos;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetNearbyMerchantLocation( out actor_name : string ) : Vector
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var merchant						: W3MerchantNPC;
	var i								: int;
	var pos								: Vector;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( ACS_Settings_Main_Float('acs_hud_settings_markers','acs_merchant_marker_distance_to_display', 50), 1, 'ShopkeeperEntity', FLAG_OnlyAliveActors + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		for (i = 0; i < actors.Size(); i += 1) 
		{
			actor_name = actors[i].I_GetDisplayName();

			pos = actors[i].GetWorldPosition();
		}
	}
	else
	{
		actor_name = "";

		pos = Vector(0,0,-200);
	}

	return pos;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_GetHostilesCheck() : bool
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var i								: int;
	var npc								: CNewNPC;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 10, 1, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 0 )
	{
		return true;
	}

	return false;
}

function ACS_LastEnemyInCombat() : bool
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var i								: int;
	var npc								: CNewNPC;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 50, 10, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() == 0 )
	{
		return true;
	}

	return false;
}

function ACS_Return_Weapon_Type_If_Allowed(weaponType : EPlayerWeapon) : EPlayerWeapon
{
	if ( thePlayer.IsWeaponActionAllowed( weaponType ) )
	{
		if (weaponType == PW_Silver || weaponType == PW_Steel)
		{
			ACS_Tutorial_Display_Check('ACS_Stance_Switching_Tutorial_Shown');
		}

		return weaponType; 
	}

	return PW_None;
}

function ACS_GetMostConvenientMeleeWeapon(targetToDrawAgainst : CActor) : EPlayerWeapon
{
	var inv : CInventoryComponent;
	var heldItems	: array<name>;
	var mountedItems	: array<name>;
	var hasPhysicalWeapon : bool;
	var i : int;
	var npc : CNewNPC;
	
	if( theGame.GetInGameConfigWrapper().GetVarValue('Gameplay', 'DisableAutomaticSwordSheathe') )
	{
		return PW_None;
	}
	
	if( thePlayer.IsWeaponHeld( 'steelsword' ) )
	{
		return ACS_Return_Weapon_Type_If_Allowed (PW_Steel); 
	}

	if( thePlayer.IsWeaponHeld( 'silversword' ) )
	{
		return ACS_Return_Weapon_Type_If_Allowed (PW_Silver); 
	}

	if (
	(ACS_GetWeaponMode() == 0 && (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1 || ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2))
	||
	(ACS_GetWeaponMode() == 1 && (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1 || ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2))
	||
	(ACS_GetWeaponMode() == 2 && (ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 1 || ACS_Settings_Main_Int('acs_combat_main_settings','acs_fist_mode', 0) == 2))
	||
	(ACS_GetWeaponMode() == 3 && (ACS_GetItem_VampClaw('default') || ACS_GetItem_VampClaw('shades') || GetWitcherPlayer().IsItemEquippedByName( 'ACS_Mage_Gloves')))
	)
	{
		return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
	}

	if (thePlayer.HasTag('acs_vampire_claws_equipped') 
	|| thePlayer.HasTag('acs_sorc_fists_equipped') 
	|| FactsQuerySum("acs_transformation_activated") > 0 
	|| GetACSWatcher().ACS_IS_SNEAKING
	|| thePlayer.HasTag('ACS_Is_Sneaking')
	)
	{
		return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
	}
	
	if ( !targetToDrawAgainst )
	{
		return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
	}

	heldItems.Clear();

	targetToDrawAgainst.GetInventory().GetAllHeldAndMountedItemsCategories( heldItems, mountedItems );

	if ( heldItems.Size() > 0 )
	{
		for ( i = 0; i < heldItems.Size(); i += 1 )
		{
			if ( heldItems[i] != 'fist' )
			{
				hasPhysicalWeapon = true;
				break;
			}
		}
	}
	
	if ( !hasPhysicalWeapon && targetToDrawAgainst.GetInventory().HasHeldOrMountedItemByTag( 'ForceMeleeWeapon' ) )
	{
		hasPhysicalWeapon = true;
	}

	npc = (CNewNPC)targetToDrawAgainst;

	if ( targetToDrawAgainst.IsHuman() && ( !hasPhysicalWeapon || ( targetToDrawAgainst.GetAttitude( thePlayer ) != AIA_Hostile ) ) ) 
	{
		return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
	}

	if ( npc.IsHorse() && !npc.GetHorseComponent().IsDismounted() ) 
	{
		return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
	}
	
	if ( targetToDrawAgainst.UsesVitality() )
	{
		if (thePlayer.inv.IsThereItemOnSlot( EES_SteelSword ) )
		{
			return ACS_Return_Weapon_Type_If_Allowed (PW_Steel); 
		}
		
		if (thePlayer.inv.IsThereItemOnSlot( EES_SilverSword ) )
		{
			return ACS_Return_Weapon_Type_If_Allowed (PW_Silver); 
		}
		
		return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
	}

	if ( targetToDrawAgainst.UsesEssence() )
	{
		if (thePlayer.inv.IsThereItemOnSlot( EES_SilverSword ) )
		{
			return ACS_Return_Weapon_Type_If_Allowed (PW_Silver); 
		}
		
		if (thePlayer.inv.IsThereItemOnSlot( EES_SteelSword ) )
		{
			return ACS_Return_Weapon_Type_If_Allowed (PW_Steel); 
		}
		
		return ACS_Return_Weapon_Type_If_Allowed (PW_Fists); 
	}
	
	return PW_None;
}

function ACS_CanSprint( speed : float ) : bool
{
	if ( !ACS_CanSprintBase( speed ) )
	{
		return false;
	}		

	if ( thePlayer.rangedWeapon && thePlayer.rangedWeapon.GetCurrentStateName() != 'State_WeaponWait' )
	{
		if ( thePlayer.GetPlayerCombatStance() ==  PCS_AlertNear )
		{
			if ( thePlayer.IsSprintActionPressed() )
			{
				thePlayer.OnRangedForceHolster( true, false );
			}
		}
		
		return false;
	}
	
	if ( thePlayer.GetCurrentStateName() != 'Swimming' && thePlayer.GetStat(BCS_Stamina) <= 0 )
	{
		thePlayer.SetSprintActionPressed(false,true);

		return false;
	}
	
	return true;
}

function ACS_CanSprintBase( speed : float ) : bool
{
	if( speed <= 0.8f )
	{
		return false;
	}
	
	if ( thePlayer.GetIsSprintToggled() )
	{

	}
	
	else if (thePlayer.GetLeftStickSprint() && theInput.LastUsedGamepad())
	{		
		if (thePlayer.GetIsSprintToggled() && thePlayer.GetIsSprinting())
		{

		}
		else if (!thePlayer.GetIsSprintToggled())
		{
			return false;
		}
			
	}
	
	else if ( !thePlayer.sprintActionPressed )
	{
		return false;
	}
	else if ( !theInput.IsActionPressed('Sprint') || ( theInput.LastUsedGamepad() && thePlayer.IsInsideInteraction() && thePlayer.GetHowLongSprintButtonWasPressed() < 0.12 ) )
	{
		return false;
	}
	

	if ( !thePlayer.IsSwimming() )
	{
		if ( !thePlayer.GetIsSprinting() && !thePlayer.IsInCombat() && thePlayer.GetStatPercents(BCS_Stamina) <= 0.9 )
		{
			return false;
		}

		if( ( !thePlayer.IsCombatMusicEnabled() || thePlayer.IsInFistFightMiniGame() ) && ( !thePlayer.IsActionAllowed(EIAB_RunAndSprint) || !thePlayer.IsActionAllowed(EIAB_Sprint) )  )
		{
			return false;
		}

		if( thePlayer.IsInCombatAction() )
		{
			return false;
		}

		if( thePlayer.IsInAir() )
		{
			return false;
		}
	}
	
	return true;
}

class W3ACSCustomWingEntity extends CActor
{
	editable var forcedAppearance : string;

	event OnSpawned( spawnData : SEntitySpawnData )
	{	
		super.OnSpawned( spawnData );
		ApplyAppearance( forcedAppearance );

		AddTimer('tag_check', 0.1 , false);
	}

	timer function tag_check(deltaTime : float, id : int) 
	{
		var ent									: CEntity;
		var actor								: CActor; 
		var animatedComponent 					: CAnimatedComponent;
		var meshcomp							: CComponent;
		var animcomp 							: CAnimatedComponent;
		var h 									: float;

		if (this.HasTag('ACS_Owl_Wing_Entity'))
		{
			ent = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

			"dlc\dlc_acs\data\models\owl_crow\acs_owl.w2ent"

			, true ), this.GetWorldPosition(), this.GetWorldRotation() );

			animcomp = (CAnimatedComponent)ent.GetComponentByClassName('CAnimatedComponent');
			meshcomp = ent.GetComponentByClassName('CMeshComponent');
			h = 1.25;
			animcomp.SetScale(Vector(h,h,h,1));
			meshcomp.SetScale(Vector(h,h,h,1));	
			
			ent.CreateAttachment( this, , Vector( 0, -0.3, 0.1 ), EulerAngles(-33.75,0,0) );

			ent.AddTag('ACS_Owl_Body');

			actor = (CActor)( ACSGetCActor('ACS_Owl_Body'));

			animatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );	
		
			animatedComponent.PlaySlotAnimationAsync( 'clapping_wings', 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));

			AddTimer('OwlBodyAnims', 2.5f , true);
		}

		if (this.HasTag('ACS_Ghost_Stance_Wolf'))
		{
			EnableCollisions(false);

			
			PlayEffectSingle('shadow_form');

			PlayEffectSingle('shadow_form_2');

			PlayEffectSingle('demonic_possession');

			PlayEffectSingle('appear');

			AddTimer('GhostStanceWolfDisappear', 3 , false);
		}
    }

	timer function GhostStanceWolfDisappear(deltaTime : float, id : int) 
	{
		SetVisibility(false);

		PlayEffectSingle('disappear');

		DestroyAfter(2);
	}

	timer function OwlBodyAnims(deltaTime : float, id : int) 
	{
		var actor							: CActor; 
		var animatedComponent 				: CAnimatedComponent;
		var anim_names						: array<name>;

		actor = (CActor)( ACSGetCActor('ACS_Owl_Body'));
		
		animatedComponent = (CAnimatedComponent)actor.GetComponentByClassName( 'CAnimatedComponent' );	

		anim_names.Clear();

		anim_names.PushBack('clapping_wings');

		if (RandF() < 0.5)
		{
			//anim_names.PushBack('idle01');
		}
		else
		{
			//anim_names.PushBack('idle02');
		}
		
		
		animatedComponent.PlaySlotAnimationAsync( anim_names[RandRange(anim_names.Size())], 'NPC_ANIM_SLOT', SAnimatedComponentSlotAnimationSettings(0.125f, 0.125f));
	}


	event OnDestroyed()
	{
		ACSGetCActor('ACS_Owl_Body').Destroy();
	}
	
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_ApplyForce(victim : CNewNPC)
{
	var size, i : int;
	var fromPos, toPos : Vector;
	var comps : array<CComponent>;
	var impulse : Vector;

	toPos = victim.GetWorldPosition();
	toPos.Z += 1.0f;
	fromPos = toPos;
	fromPos.Z -= 2.0f;
	impulse = VecNormalize( toPos - fromPos.Z ) * 10;
	
	comps = victim.GetComponentsByClassName('CComponent');
	victim.GetVisualDebug().AddArrow( 'applyForce', fromPos, toPos, 1, 0.2f, 0.2f, true, Color( 0,0,255 ), true, 5.0f );
	size = comps.Size();
	for( i = 0; i < size; i += 1 )
	{
		comps[i].ApplyForceAtPointToPhysicalObject( impulse, impulse );

		comps[i].ApplyLocalImpulseToPhysicalObject( impulse );

		comps[i].ApplyTorqueImpulseToPhysicalObject( impulse );

		comps[i].ApplyTorqueToPhysicalObject( impulse );

		comps[i].SetPhysicalObjectAngularVelocity( Vector(0,0,0) );

		comps[i].SetPhysicalObjectLinearVelocity( Vector(0,0,0) );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACSGetCActor(actorTag : name) : CActor
{
	var ent 			 : CActor;
	
	ent = (CActor)theGame.GetEntityByTag( actorTag );
	return ent;
}

function ACSGetCActorDestroyAll( tag: name )
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( tag , actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].DestroyAllEffects();
		actors[i].BreakAttachment();
		actors[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		actors[i].DestroyAfter(0.125);
		actors[i].RemoveTag(tag);
	}
}

function ACSGetCEntity(entTag: name) : CEntity
{
	var ent 				 : CEntity;
	
	ent = (CEntity)theGame.GetEntityByTag( entTag );
	return ent;
}

function ACSGetCEntityDestroyAll( tag: name )
{	
	var item 											: array<CEntity>;
	var i												: int;
	
	item.Clear();

	theGame.GetEntitiesByTag( tag , item );	

	if (item.Size()<=0)
	{
		return;
	}

	for( i = 0; i < item.Size(); i += 1 )
	{
		item[i].DestroyAllEffects();
		item[i].BreakAttachment();
		item[i].Teleport(thePlayer.GetWorldPosition() + Vector (0,0, -200));
		item[i].DestroyAfter(0.125);
		item[i].RemoveTag(tag);
	}
}

function ACSGetCGameplayEntity(entTag: name) : CGameplayEntity
{
	var ent 				 : CGameplayEntity;
	
	ent = (CGameplayEntity)theGame.GetEntityByTag( entTag );
	return ent;
}

function ACSGetCActorRemoveTag( tag: name )
{	
	var actors 											: array<CActor>;
	var i												: int;
	
	actors.Clear();

	theGame.GetActorsByTag( tag , actors );	

	if (actors.Size() <= 0)
	{
		return;
	}
	
	for( i = 0; i < actors.Size(); i += 1 )
	{
		actors[i].RemoveTag(tag);
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Tutorial_Popup_Display( titleID : int, messageID : int ) 
{
	var msg				: W3TutorialPopupData;
	var Title			: string;
	var Message			: string;

	if( 
	theGame.HasBlackscreenRequested()
	|| theGame.IsFading()
	|| theGame.IsBlackscreen()
	|| theGame.GetTutorialSystem().HasActiveTutorial()
	)
	{
		return;
	}

	Title = GetLocStringById(titleID);

	Message = GetLocStringById(messageID);

	msg = new W3TutorialPopupData in thePlayer;

	msg.managerRef = theGame.GetTutorialSystem();

	msg.messageTitle = Title;

	msg.imagePath = "";

	msg.messageText = Message;

	msg.enableGlossoryLink = true;

	msg.autosize = true;

	msg.blockInput = true;

	msg.pauseGame = true;

	msg.fullscreen = true;

	msg.canBeShownInMenus = true;

	msg.fadeBackground = true;

	msg.duration = -1;

	msg.posX = 0;

	msg.posY = 0;

	msg.enableAcceptButton = true;

	theGame.GetTutorialSystem().ShowTutorialHint(msg);
}

function ACS_PlayerMorph(ratio : float, time : float)
{
	var l_comp : array< CComponent >;
	var i, size : int;

	l_comp = thePlayer.GetComponentsByClassName( 'CMorphedMeshManagerComponent' );

	size = l_comp.Size();

	for ( i=0; i<size; i+= 1 )
	{
		((CMorphedMeshManagerComponent)l_comp[ i ]).SetMorphBlend( ratio, time );
	}
}

latent function ACS_MountedCombatAttack(isHeavyAttack : bool, speed: float, horizontalVal : float)
{
    var victims 									: array<CGameplayEntity>;
    var blade_temp_ent								: CItemEntity;
	var initpos, targetPosition_1					: Vector;
	var meteor_proj_1 								: W3ACSDullahanProjectile;

	ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');

	ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

	if (isHeavyAttack)
	{
		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_1').StopEffect('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_2').StopEffect('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_3').StopEffect('heavy_trail_fx');

		victims.Clear();

		FindGameplayEntitiesInCone( victims, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetHeadingVector()), 90, 5, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );

		ACS_Mounted_Combat_Deal_Damage( true, victims, speed, 250 );

		Sleep( 0.3f );

		victims.Clear();

		FindGameplayEntitiesInCone( victims, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetHeadingVector()), 135, 4, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );

		ACS_Mounted_Combat_Deal_Damage( true, victims, speed, 275 );

		Sleep( 0.3f );

		victims.Clear();

		FindGameplayEntitiesInCone( victims, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetHeadingVector()), 180, 3, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );

		ACS_Mounted_Combat_Deal_Damage( true, victims, speed, 300 );

		return;
	}

	if (ACS_GetItem_Sword_IsEquipped('dullahan_spear_steel_held', 'steel'))
	{
		initpos = GetWitcherPlayer().GetBoneWorldPosition('r_weapon');	

		initpos.Z += 1;			
					
		targetPosition_1 = thePlayer.GetWorldPosition();

		targetPosition_1.Z += 50;

		meteor_proj_1 = (W3ACSDullahanProjectile)theGame.CreateEntity( 
		(CEntityTemplate)LoadResourceAsync( "dlc\dlc_acs\data\entities\projectiles\dullahan_proj_small.w2ent", true ), initpos, thePlayer.GetWorldRotation() );

		meteor_proj_1.Init(thePlayer);
		meteor_proj_1.AddTag('ACS_Dullahan_Spear_Player_Horse_Riding_Proj');
		meteor_proj_1.ShootProjectileAtPosition( 0, 2, targetPosition_1, 500 );
		meteor_proj_1.DestroyAfter(20);
	}

    victims.Clear();

    if( horizontalVal == 0.0 )
    {
		FindGameplayEntitiesInCone( victims, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetHeadingVector()) - 45, 90, 4, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
    }
    else if( horizontalVal == 1.0 )
    {
    	FindGameplayEntitiesInCone( victims, thePlayer.GetWorldPosition(), VecHeading( thePlayer.GetHeadingVector()) + 45, 90, 4, 999, ,FLAG_ExcludePlayer + FLAG_OnlyAliveActors );
    }

    if( thePlayer.GetHorseCombatSlowMo() )
    {
		Sleep( 0.03f );

		ACS_Mounted_Combat_Deal_Damage( false, victims, speed, 125 );

        Sleep( 0.03f );

       	ACS_Mounted_Combat_Deal_Damage( false, victims, speed, 125 );
    }
    else
    {
		Sleep( 0.1f );

		ACS_Mounted_Combat_Deal_Damage( false, victims, speed, 125 );
		
        Sleep( 0.1f );
     
       	ACS_Mounted_Combat_Deal_Damage( false, victims, speed, 125 );
    }
}

function ACS_Mounted_Combat_Deal_Damage(isHeavyAttack : bool, victims : array<CGameplayEntity>, speed : float, baseDamage : float )
{
    var damage 																						: W3Action_Attack;
    var i 																							: int;
    var actor 																						: CActor;
    var horse 																						: CNewNPC;
    var bloodTrailParam 																			: CBloodTrailEffect;
    var weaponId 																					: SItemUniqueId;
    var blade_temp_ent																				: CItemEntity;
	var heavy_hit_sound_names																		: array<string>;
	var heavy_hit_sound_names_primary																: array<string>;
	var light_hit_sound_names_secondary, heavy_hit_sound_names_secondary							: array<string>;
	var tmpName 																					: name;
	var tmpBool 																					: bool;
	var mc 																							: EMonsterCategory;
	var vfxEnt																						: CEntity;
	var rot																							: EulerAngles;
	var targetPosition, pos																			: Vector;
	var headingDiff																					: float;


	if (isHeavyAttack)
	{
		ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_1').StopEffect('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_2').PlayEffectSingle('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_2').StopEffect('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_3').PlayEffectSingle('heavy_trail_fx');

		ACSGetCEntity('acs_sword_trail_3').StopEffect('heavy_trail_fx');
	}

   	ACSGetCEntity('acs_sword_trail_1').PlayEffectSingle('light_trail_extended_fx');

	ACSGetCEntity('acs_sword_trail_1').StopEffect('light_trail_extended_fx');

    horse = (CNewNPC)(thePlayer.GetUsedVehicle());

    for( i = 0 ; i < victims.Size() ; i += 1 )
    {
        actor = (CActor)victims[i];
        
        if ( actor == thePlayer || actor == horse )
		{
			continue;
		}
        
        if( actor )
        {
			actor.StopEffect( 'heavy_hit_horseriding' );

			actor.PlayEffectSingle( 'heavy_hit_horseriding' );

            actor.SoundEvent("cmb_play_hit_heavy");

			theGame.GetBehTreeReactionManager().CreateReactionEventIfPossible( thePlayer, 'AttackAction', -1, 10.0f, -1.f, -1, true );

			damage = new W3Action_Attack in theGame;

            damage.Init( thePlayer, actor ,NULL, thePlayer.GetInventory().GetItemFromSlot( 'r_weapon' ),'attack_heavy',thePlayer.GetName(),EHRT_Heavy, false, false, 'attack_heavy', AST_Jab, ASD_NotSet, true, false, false, false );

			if (((CMovingPhysicalAgentComponent)(actor.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
			|| actor.GetRadius() >= 0.7
			|| actor.HasAbility('Boss')
			|| actor.HasTag('IsBoss')
			|| actor.HasTag('ACS_Big_Boi')
			)
			{
				baseDamage * 0.5;
			}

			if (thePlayer.HasTag('ACS_Flammable_Oil_Enabled')
			)
			{
				if (ACS_GetItem_SwordHeldSwitchBasedUponStat('frost_sword'))
				{
					damage.AddEffectInfo( EET_Frozen, 3 );
				}
				else if (ACS_GetItem_SwordHeldSwitchBasedUponStat('poison_sword'))
				{
					damage.AddEffectInfo( EET_Poison, 3 );
				}
				else if (ACS_GetItem_SwordHeldSwitchBasedUponStat('bleed_sword'))
				{
					damage.AddEffectInfo( EET_Bleeding, 3 );
				} 
				else
				{
					damage.AddEffectInfo( EET_Burning, 3 );
				}
			}

		    if ( speed < 2 )
            {
                damage.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, baseDamage );
            } 
			else
            {
                damage.AddDamage( theGame.params.DAMAGE_NAME_DIRECT, baseDamage * MaxF( 1.1 + speed, 1 ) );
            }

            if( speed >= 4.0 )
			{
				damage.AddEffectInfo( EET_KnockdownTypeApplicator );
			}
               
            damage.SetSoundAttackType('wpn_slice')	;
            
            theGame.damageMgr.ProcessAction( damage );

			delete damage;

			thePlayer.GainStat( BCS_Focus, thePlayer.GetStatMax( BCS_Focus) * 0.15 );

			light_hit_sound_names_secondary.Clear();

			heavy_hit_sound_names.Clear();

			heavy_hit_sound_names_primary.Clear();

			heavy_hit_sound_names_secondary.Clear();

			theGame.GetMonsterParamsForActor(actor, mc, tmpName, tmpBool, tmpBool, tmpBool);

			if( ((CNewNPC)actor).GetBloodType() == BT_Red) 
			{
				if (actor.HasAbility('mon_lessog_base')
				|| actor.HasAbility('mon_sprigan_base')
				)
				{		
					GetACSWatcher().weapon_blood_fx('black');
				} 
				else 
				{
					GetACSWatcher().weapon_blood_fx('red');
				}

				heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

				heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
				heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
				
				if (actor.HasAbility('mon_lessog_base')
				|| actor.HasAbility('mon_sprigan_base')
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
			else if( ((CNewNPC)actor).GetBloodType() == BT_Green) 
			{
				if (actor.HasAbility('mon_kikimore_base')
				|| actor.HasAbility('mon_black_spider_base')
				|| actor.HasAbility('mon_black_spider_ep2_base')
				|| actor.HasTag('ACS_Ungoliant')
				)
				{						
					GetACSWatcher().weapon_blood_fx('black');
				} 
				else 
				{
					GetACSWatcher().weapon_blood_fx('green');
				}

				heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

				heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
				heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);

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
			else if( ((CNewNPC)actor).GetBloodType() == BT_Yellow) 
			{
				if (actor.HasAbility('mon_archespor_base'))
				{
					GetACSWatcher().weapon_blood_fx('yellow');
				} 
				else 
				{
					GetACSWatcher().weapon_blood_fx('red');
				}

				heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

				heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
				heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
			
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

					theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
				}
			}
			else if	( ((CNewNPC)actor).GetBloodType() == BT_Black) 
			{
				if ( mc == MC_Vampire ) 
				{
					GetACSWatcher().weapon_blood_fx('red');
					
					heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
					heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
					heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

					theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

					heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
					heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

					theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);

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

						theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
					}
				}
				else if ( mc == MC_Magicals ) 
				{
					if (actor.HasAbility('mon_golem_base')
					|| actor.HasAbility('mon_djinn')
					|| actor.HasAbility('mon_gargoyle')
					)
					{
						GetACSWatcher().weapon_blood_fx('black');

						if (actor.HasAbility('mon_golem_base')
						|| actor.HasAbility('mon_gargoyle')
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
						GetACSWatcher().weapon_blood_fx('red');

						heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
						heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
						heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

						theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

						heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
						heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

						theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
					}
				}
				else
				{
					GetACSWatcher().weapon_blood_fx('black');

					heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
					heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
					heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

					theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

					heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
					heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

					theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);

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

						theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
					}
				}
			}
			else
			{
				GetACSWatcher().weapon_blood_fx('red');

				heavy_hit_sound_names.PushBack("extreme_hit_01_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_02_bb_acs");
				heavy_hit_sound_names.PushBack("extreme_hit_03_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names[RandRange(heavy_hit_sound_names.Size())]);

				heavy_hit_sound_names_primary.PushBack("large_weapon_hit_bb_acs");
				heavy_hit_sound_names_primary.PushBack("large_weapon_pullout_bb_acs");

				theSound.SoundEvent(heavy_hit_sound_names_primary[RandRange(heavy_hit_sound_names_primary.Size())]);
			
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

					theSound.SoundEvent(light_hit_sound_names_secondary[RandRange(light_hit_sound_names_secondary.Size())]);
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

				rot.Roll += RandRangeF(195,165);	
				//rot.Pitch += RandRangeF(105,75);

				if ( actor.GetBoneIndex('torso') != -1 )
				{
					targetPosition = actor.GetBoneWorldPosition('torso');

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
					if ( actor.GetBoneIndex('k_torso_g') != -1 )
					{
						targetPosition = actor.GetBoneWorldPosition('k_torso_g');

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
						targetPosition = actor.GetWorldPosition();
						targetPosition.Z = pos.Z + RandRangeF(1.5f,1.125f);
						targetPosition.X += RandRangeF(0.125,-0.125);
						targetPosition.Y += RandRangeF(0.125,-0.125);
					}
				}

				vfxEnt = theGame.CreateEntity( (CEntityTemplate)LoadResource( "dlc\dlc_acs\data\fx\acs_sword_slashes.w2ent", true ), targetPosition, rot );

				if (((CMovingPhysicalAgentComponent)(actor.GetMovingAgentComponent())).GetCapsuleHeight() >= 2
				|| actor.GetRadius() >= 0.7
				|| actor.HasAbility('Boss')
				|| actor.HasTag('IsBoss')
				|| actor.HasTag('ACS_Big_Boi')
				)
				{
					vfxEnt.PlayEffectSingle('sword_slash_hit_eff_large_heavy');
				}
				else
				{
					vfxEnt.PlayEffectSingle('sword_slash_hit_eff_heavy');
				}

				vfxEnt.DestroyAfter(0.5);
			}
        }
    }
}

function ACS_Correct_Oil_Used(npc: CActor) : bool
{
	if (npc.GetMovingAgentComponent().GetName() == "woman_base"
	|| npc.GetMovingAgentComponent().GetName() == "man_base"
	)
	{
		if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
		{
			if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hanged Man Venom 1') 
			|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hanged Man Venom 2') 
			|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hanged Man Venom 3') 
			)
			{
				return true;
			}
		}
		else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
		{
			if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hanged Man Venom 1')
			|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hanged Man Venom 2')
			|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hanged Man Venom 3')
			)
			{
				return true;
			}
		}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Beast Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Beast Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Beast Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Beast Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Beast Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Beast Oil 3')
				)
				{
					return true;
				}
			}
		}
		else if 
		(
			npc.HasAbility('mon_lycanthrope')
			|| npc.GetSfxTag() == 'sfx_werewolf'
			|| npc.HasAbility('mon_archespor_base')
			|| npc.HasAbility('mon_q704_ft_wilk')
		)
		{
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Cursed Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Cursed Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Cursed Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Cursed Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Cursed Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Cursed Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Draconide Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Draconide Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Draconide Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Draconide Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Draconide Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Draconide Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Magicals Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Magicals Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Magicals Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Magicals Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Magicals Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Magicals Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hybrid Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hybrid Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Hybrid Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hybrid Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hybrid Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Hybrid Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Insectoid Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Insectoid Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Insectoid Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Insectoid Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Insectoid Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Insectoid Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Necrophage Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Necrophage Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Necrophage Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Necrophage Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Necrophage Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Necrophage Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Ogre Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Ogre Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Ogre Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Ogre Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Ogre Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Ogre Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Relic Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Relic Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Relic Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Relic Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Relic Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Relic Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Specter Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Specter Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Specter Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Specter Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Specter Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Specter Oil 3')
				)
				{
					return true;
				}
			}
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
			if (GetWitcherPlayer().IsWeaponHeld( 'steelsword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Vampire Oil 1') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Vampire Oil 2') 
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(true, 'Vampire Oil 3') 
				)
				{
					return true;
				}
			}
			else if (GetWitcherPlayer().IsWeaponHeld( 'silversword' ))
			{
				if (GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Vampire Oil 1')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Vampire Oil 2')
				|| GetWitcherPlayer().IsEquippedSwordUpgradedWithOil(false, 'Vampire Oil 3')
				)
				{
					return true;
				}
			}
		}
		else 
		{
			return false;
		}
	}

	return false;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_RoachSteelSwordProcess()
{
	var boneIndex 										: int;
	var boneName 										: name;
	var boneRotation									: EulerAngles;
	var bonePosition									: Vector;
	var dummycomp										: CEntity;
	var dummies											: array<CEntity>;
	var i, j 											: Int;

	var itemIds 										: array<SItemUniqueId>;
	var steelid											: SItemUniqueId; 
	var swordsteel										: CEntity; 
	var steelcopy										: CEntity;

	var scabbardscomp 									: CDrawableComponent;
	var items 											: array<SItemUniqueId>;
	var meshComponent 									: CMeshComponent;
	var ent 											: CEntity;

	var steel_pos_x,steel_pos_y,steel_pos_z   									: Float;
	var steel_scab_pos_x,steel_scab_pos_y,steel_scab_pos_z  					: Float;
	var steel_roll, steel_pitch, steel_yaw 										: Float; 
	var steel_scab_roll, steel_scab_pitch, steel_scab_yaw						: Float; 
	var steel_on_roach_position													: Vector;
	var steel_on_roach_rotation 												: EulerAngles;
	var steel_scab_on_roach_position 											: Vector;
	var steel_scab_on_roach_rotation							 				: EulerAngles;
	
	theGame.GetEntitiesByTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment',dummies);
	
	for(i=0; i<dummies.Size(); i+=1)
	{
		dummies[i].Destroy();
	}
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment') )
	{
		if ( ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 2
		)
		{
			boneName = 'spine2';
		}
		else
		{
			boneName = 'spine1';
		}	
		
		boneIndex = thePlayer.GetHorseWithInventory().GetBoneIndex( boneName );	
		thePlayer.GetHorseWithInventory().GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		
		dummycomp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		dummycomp.AddTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment');

		dummycomp.CreateAttachmentAtBoneWS(thePlayer.GetHorseWithInventory(), boneName, bonePosition, boneRotation );
	}


	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Sword_Dummy') )
	{
		steelcopy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\weapons\swords\witcher_steel_swords\witcher_steel_sword_lvl1.w2ent"

		,true ), thePlayer.GetWorldPosition() -100, thePlayer.GetWorldRotation());

		steelcopy.AddTag('ACS_Roach_Stash_Steel_Sword_Dummy');
	}

	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Scabbard_Dummy') )
	{
		ent = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(
			
		"items\weapons\swords\nomansland_scabbards\nomansland_scabbard_lvl1.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		meshComponent = ( CMeshComponent ) ent.GetComponentByClassName( 'CMeshComponent' );

		meshComponent.SetScale( Vector( 1.03, 1.03, 1.03 ) );

		ent.AddTag('ACS_Roach_Stash_Steel_Scabbard_Dummy');
	}

	switch(ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3))
	{
		case 6:
		steel_pos_x = -0.38; 
		steel_pos_y = 0.54; 
		steel_pos_z = 0.10; 

		steel_pitch = -85; 
		steel_roll = -66; 
		steel_yaw = -5;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
		break;

		case 5:
		steel_pos_x = 0.40; 
		steel_pos_y = -0.2; 
		steel_pos_z = 0.25; 

		steel_pitch = -80; 
		steel_roll = 40; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
		break;

		case 4:
		steel_pos_x = 0.42; 
		steel_pos_y = 0.00; 
		steel_pos_z = 0.23; 

		steel_pitch = -85; 
		steel_roll = 10; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
		break;

		case 3:
		steel_pos_x = -0.39; 
		steel_pos_y = 0.06; 
		steel_pos_z = 0.27; 

		steel_pitch = -85; 
		steel_roll = 0; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
		break;

		case 2:
		steel_pos_x = -0.48; 
		steel_pos_y = -0.02; 
		steel_pos_z = 0.32; 

		steel_pitch = 180; 
		steel_roll = 0; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
		break;

		case 1:
		steel_pos_x = 0.25; 
		steel_pos_y = 0.82; 
		steel_pos_z = 0.4; 

		steel_pitch = -110; 
		steel_roll = -1; 
		steel_yaw = 3;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
		break;

		case 0:
		steel_pos_x = -0.17; 
		steel_pos_y = 0.82; 
		steel_pos_z = 0.4; 

		steel_pitch = -62; 
		steel_roll = -1; 
		steel_yaw = 3;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
		break;

		default:
		steel_pos_x = -0.39; 
		steel_pos_y = 0.06; 
		steel_pos_z = 0.27; 

		steel_pitch = -85; 
		steel_roll = 0; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
		break;
	}

	steel_on_roach_position.X = 0;    
	steel_on_roach_position.Y = 0;    
	steel_on_roach_position.Z = 0;     

	steel_on_roach_rotation.Pitch = 0;
	steel_on_roach_rotation.Roll = 0;
	steel_on_roach_rotation.Yaw = 0;
	
	steel_on_roach_position.X += steel_pos_y;
	steel_on_roach_position.Y -= steel_pos_z;
	steel_on_roach_position.Z -= steel_pos_x;

	steel_on_roach_rotation.Pitch += steel_pitch;
	steel_on_roach_rotation.Roll += steel_roll;
	steel_on_roach_rotation.Yaw += steel_yaw;
	
	ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment'),,steel_on_roach_position, steel_on_roach_rotation );

	steel_scab_on_roach_position.X = 0;
	steel_scab_on_roach_position.Y = 0; 
	steel_scab_on_roach_position.Z = 0;

	steel_scab_on_roach_rotation.Pitch = 0;
	steel_scab_on_roach_rotation.Roll = 0;
	steel_scab_on_roach_rotation.Yaw = 0;

	steel_scab_on_roach_position.X += 0.61;
	steel_scab_on_roach_position.Y -= 0.09; 	
	steel_scab_on_roach_position.Z -= -1.71;

	steel_scab_on_roach_rotation.Pitch += 180;       
	steel_scab_on_roach_rotation.Roll += -24.3;      
	steel_scab_on_roach_rotation.Yaw += 14.4 + 0.41;
	
	steel_scab_on_roach_position.X += steel_scab_pos_x;
	steel_scab_on_roach_position.Y -= steel_scab_pos_y;
	steel_scab_on_roach_position.Z -= steel_scab_pos_z;

	steel_scab_on_roach_rotation.Pitch += steel_scab_pitch;
	steel_scab_on_roach_rotation.Roll += steel_scab_roll; 
	steel_scab_on_roach_rotation.Yaw += steel_scab_yaw;   

	ACSGetCEntity('ACS_Roach_Stash_Steel_Scabbard_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy'),,steel_scab_on_roach_position, steel_scab_on_roach_rotation );

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_RoachSilverSwordProcess()
{
	var boneIndex 										: int;
	var boneName 										: name;
	var boneRotation									: EulerAngles;
	var bonePosition									: Vector;
	var dummycomp										: CEntity;
	var dummies											: array<CEntity>;
	var i 												: Int;

	var itemIds 																									: array<SItemUniqueId>;
	var silverid																									: SItemUniqueId; 
	var swordsilver																									: CEntity; 
	var silvercopy																									: CEntity;

	var scabbardscomp_s 								: CDrawableComponent;
	var items 											: array<SItemUniqueId>;
	var meshComponent 									: CMeshComponent;
	var ent_s 											: CEntity;

	var silver_pos_x,silver_pos_y,silver_pos_z   								: Float;
	var silver_scab_pos_x,silver_scab_pos_y,silver_scab_pos_z  					: Float;
	var silver_roll, silver_pitch, silver_yaw 									: Float; 
	var silver_scab_roll,silver_scab_pitch,silver_scab_yaw						: Float; 
	var silver_on_roach_position												: Vector;
	var silver_on_roach_rotation 												: EulerAngles;
	var silver_scab_on_roach_position 											: Vector;
	var silver_scab_on_roach_rotation 											: EulerAngles;
	
	theGame.GetEntitiesByTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment',dummies);
	
	for(i=0; i<dummies.Size(); i+=1)
	{
		dummies[i].Destroy();
	}
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment') )
	{
		if ( ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 2
		)
		{
			boneName = 'spine2';
		}
		else
		{
			boneName = 'spine1';
		}	
		
		boneIndex = thePlayer.GetHorseWithInventory().GetBoneIndex( boneName );	
		thePlayer.GetHorseWithInventory().GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		
		dummycomp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		dummycomp.AddTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment');

		dummycomp.CreateAttachmentAtBoneWS(thePlayer.GetHorseWithInventory(), boneName, bonePosition, boneRotation );
	}

	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Sword_Dummy') )
	{
		silvercopy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\cutscenes\witcher_silver_sword\silver_sword.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		silvercopy.AddTag('ACS_Roach_Stash_Silver_Sword_Dummy');
	}

	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Scabbard_Dummy') )
	{
		ent_s = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\bodyparts\geralt_items\scabbards\silver_scabbards\scabbard_silver_1_01.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		meshComponent = ( CMeshComponent ) ent_s.GetComponentByClassName( 'CMeshComponent' );

		meshComponent.SetScale( Vector( 1.03, 1.03, 1.03 ) );

		ent_s.AddTag('ACS_Roach_Stash_Silver_Scabbard_Dummy');
	}

	switch(ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3))
	{
		case 6:
		silver_pos_x = -0.36; 
		silver_pos_y = 0.53; 
		silver_pos_z = 0.00; 

		silver_pitch = -85; 
		silver_roll = -75; 
		silver_yaw = -4;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
		break;

		case 5:
		silver_pos_x = -0.36; 
		silver_pos_y = -0.18; 
		silver_pos_z = 0.30; 

		silver_pitch = -88; 
		silver_roll = 40; 
		silver_yaw = -5;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
		break;

		case 4:
		silver_pos_x = 0.37; 
		silver_pos_y = -0.01; 
		silver_pos_z = 0.27; 

		silver_pitch = -85; 
		silver_roll = 10; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
		break;

		case 3:
		silver_pos_x = -0.34; 
		silver_pos_y = -0.01; 
		silver_pos_z = 0.32; 

		silver_pitch = -85; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
		break;

		case 2:
		silver_pos_x = -0.35; 
		silver_pos_y = 0.05; 
		silver_pos_z = 0.29; 

		silver_pitch = 180; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
		break;

		case 1:
		silver_pos_x = 0.3; 
		silver_pos_y = 0.70; 
		silver_pos_z = 0.4; 

		silver_pitch = -105; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
		break;

		case 0:
		silver_pos_x = -0.2; 
		silver_pos_y = 0.70; 
		silver_pos_z = 0.4; 

		silver_pitch = -62; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
		break;

		default:
		silver_pos_x = -0.34; 
		silver_pos_y = -0.01; 
		silver_pos_z = 0.32; 

		silver_pitch = -85; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
		break;
	}

	silver_on_roach_position.X = 0;    
	silver_on_roach_position.Y = 0;    
	silver_on_roach_position.Z = 0;     

	silver_on_roach_rotation.Pitch = 0;
	silver_on_roach_rotation.Roll = 0;
	silver_on_roach_rotation.Yaw = 0;
	
	silver_on_roach_position.X += silver_pos_y;
	silver_on_roach_position.Y -= silver_pos_z;
	silver_on_roach_position.Z -= silver_pos_x;

	silver_on_roach_rotation.Pitch += silver_pitch;
	silver_on_roach_rotation.Roll += silver_roll;
	silver_on_roach_rotation.Yaw += silver_yaw;
	
	ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment'),,silver_on_roach_position, silver_on_roach_rotation );

	silver_scab_on_roach_position.X = 0;
	silver_scab_on_roach_position.Y = 0; 
	silver_scab_on_roach_position.Z = 0;

	silver_scab_on_roach_rotation.Pitch = 0;
	silver_scab_on_roach_rotation.Roll = 0;
	silver_scab_on_roach_rotation.Yaw = 0;

	silver_scab_on_roach_position.X += 0.61 + 0.025; 
	silver_scab_on_roach_position.Y -= 0.09 - 0.1;  
	silver_scab_on_roach_position.Z -= -1.71 + 0.07;   

	silver_scab_on_roach_rotation.Pitch += 180 - 1.5;
	silver_scab_on_roach_rotation.Roll += -24.3 - 5.5;
	silver_scab_on_roach_rotation.Yaw += 14.4 + 4;
	
	silver_scab_on_roach_position.X += silver_scab_pos_x;
	silver_scab_on_roach_position.Y -= silver_scab_pos_y;
	silver_scab_on_roach_position.Z -= silver_scab_pos_z;

	silver_scab_on_roach_rotation.Pitch += silver_scab_pitch;
	silver_scab_on_roach_rotation.Roll += silver_scab_roll; 
	silver_scab_on_roach_rotation.Yaw += silver_scab_yaw;   
	
	ACSGetCEntity('ACS_Roach_Stash_Silver_Scabbard_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy'),,silver_scab_on_roach_position, silver_scab_on_roach_rotation );

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*
function ACS_RoachSteelSwordDummy_Container()
{
	var itemIds 																									: array<SItemUniqueId>;
	var i 																											: int;
	var steelid																										: SItemUniqueId; 
	var swordsteel																									: CEntity; 
	var steelcopy																									: CEntity;
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Sword_Dummy') )
	{
		steelcopy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\weapons\swords\witcher_steel_swords\witcher_steel_sword_lvl1.w2ent"

		,true ), thePlayer.GetWorldPosition() -100, thePlayer.GetWorldRotation());

		steelcopy.AddTag('ACS_Roach_Stash_Steel_Sword_Dummy');
	}
}

function ACS_RoachSteelScabbardDummy_Container()
{
	var scabbardscomp 									: CDrawableComponent;
	var i 												: int;
	var items 											: array<SItemUniqueId>;
	var meshComponent 									: CMeshComponent;
	var ent 											: CEntity;
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Scabbard_Dummy') )
	{
		ent = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(
			
		"items\weapons\swords\nomansland_scabbards\nomansland_scabbard_lvl1.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		meshComponent = ( CMeshComponent ) ent.GetComponentByClassName( 'CMeshComponent' );

		meshComponent.SetScale( Vector( 1.03, 1.03, 1.03 ) );

		ent.AddTag('ACS_Roach_Stash_Steel_Scabbard_Dummy');
	}
}

function ACS_RoachSteelSwordAttachmentDummy_Container()
{
	var boneIndex 										: int;
	var boneName 										: name;
	var boneRotation									: EulerAngles;
	var bonePosition									: Vector;
	var dummycomp										: CEntity;
	var dummies											: array<CEntity>;
	var i : Int;
	
	theGame.GetEntitiesByTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment',dummies);
	
	for(i=0; i<dummies.Size(); i+=1)
	{
		dummies[i].Destroy();
	}
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment') )
	{
		if ( ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 2
		)
		{
			boneName = 'spine2';
		}
		else
		{
			boneName = 'spine1';
		}	
		
		boneIndex = thePlayer.GetHorseWithInventory().GetBoneIndex( boneName );	
		thePlayer.GetHorseWithInventory().GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		
		dummycomp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		dummycomp.AddTag('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment');

		dummycomp.CreateAttachmentAtBoneWS(thePlayer.GetHorseWithInventory(), boneName, bonePosition, boneRotation );
	}
}

function ACS_ConfigureSteelSwordAttachment_Container()
{
	var steel_pos_x,steel_pos_y,steel_pos_z   									: Float;
	var steel_scab_pos_x,steel_scab_pos_y,steel_scab_pos_z  					: Float;
	var steel_roll, steel_pitch, steel_yaw 										: Float; 
	var steel_scab_roll, steel_scab_pitch, steel_scab_yaw						: Float; 
	var steel_on_roach_position													: Vector;
	var steel_on_roach_rotation 												: EulerAngles;
	var steel_scab_on_roach_position 											: Vector;
	var steel_scab_on_roach_rotation							 				: EulerAngles;

	if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 0)
	{
		steel_pos_x = -0.17; 
		steel_pos_y = 0.82; 
		steel_pos_z = 0.4; 

		steel_pitch = -62; 
		steel_roll = -1; 
		steel_yaw = 3;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 1)
	{
		steel_pos_x = 0.25; 
		steel_pos_y = 0.82; 
		steel_pos_z = 0.4; 

		steel_pitch = -110; 
		steel_roll = -1; 
		steel_yaw = 3;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 2)
	{
		steel_pos_x = -0.48; 
		steel_pos_y = -0.02; 
		steel_pos_z = 0.32; 

		steel_pitch = 180; 
		steel_roll = 0; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 3)
	{
		steel_pos_x = -0.39; 
		steel_pos_y = 0.06; 
		steel_pos_z = 0.27; 

		steel_pitch = -85; 
		steel_roll = 0; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 4)
	{
		steel_pos_x = 0.42; 
		steel_pos_y = 0.00; 
		steel_pos_z = 0.23; 

		steel_pitch = -85; 
		steel_roll = 10; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 5)
	{
		steel_pos_x = 0.40; 
		steel_pos_y = -0.2; 
		steel_pos_z = 0.25; 

		steel_pitch = -80; 
		steel_roll = 40; 
		steel_yaw = 0;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 6)
	{
		steel_pos_x = -0.38; 
		steel_pos_y = 0.54; 
		steel_pos_z = 0.10; 

		steel_pitch = -85; 
		steel_roll = -66; 
		steel_yaw = -5;

		steel_scab_pos_x = 0; 
		steel_scab_pos_y = 0; 
		steel_scab_pos_z = 0; 

		steel_scab_pitch = 0;
		steel_scab_roll = 0; 
		steel_scab_yaw = 0; 
	}

	steel_on_roach_position.X = 0;    
	steel_on_roach_position.Y = 0;    
	steel_on_roach_position.Z = 0;     

	steel_on_roach_rotation.Pitch = 0;
	steel_on_roach_rotation.Roll = 0;
	steel_on_roach_rotation.Yaw = 0;
	
	steel_on_roach_position.X += steel_pos_y;
	steel_on_roach_position.Y -= steel_pos_z;
	steel_on_roach_position.Z -= steel_pos_x;

	steel_on_roach_rotation.Pitch += steel_pitch;
	steel_on_roach_rotation.Roll += steel_roll;
	steel_on_roach_rotation.Yaw += steel_yaw;
	
	ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy_Attachment'),,steel_on_roach_position, steel_on_roach_rotation );

	steel_scab_on_roach_position.X = 0;
	steel_scab_on_roach_position.Y = 0; 
	steel_scab_on_roach_position.Z = 0;

	steel_scab_on_roach_rotation.Pitch = 0;
	steel_scab_on_roach_rotation.Roll = 0;
	steel_scab_on_roach_rotation.Yaw = 0;

	steel_scab_on_roach_position.X += 0.61;
	steel_scab_on_roach_position.Y -= 0.09; 	
	steel_scab_on_roach_position.Z -= -1.71;

	steel_scab_on_roach_rotation.Pitch += 180;       
	steel_scab_on_roach_rotation.Roll += -24.3;      
	steel_scab_on_roach_rotation.Yaw += 14.4 + 0.41;
	
	steel_scab_on_roach_position.X += steel_scab_pos_x;
	steel_scab_on_roach_position.Y -= steel_scab_pos_y;
	steel_scab_on_roach_position.Z -= steel_scab_pos_z;

	steel_scab_on_roach_rotation.Pitch += steel_scab_pitch;
	steel_scab_on_roach_rotation.Roll += steel_scab_roll; 
	steel_scab_on_roach_rotation.Yaw += steel_scab_yaw;   

	ACSGetCEntity('ACS_Roach_Stash_Steel_Scabbard_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Steel_Sword_Dummy'),,steel_scab_on_roach_position, steel_scab_on_roach_rotation );
}

function ACS_RoachSilverSwordDummy_Container()
{
	var itemIds 																									: array<SItemUniqueId>;
	var i 																											: int;
	var silverid																									: SItemUniqueId; 
	var swordsilver																									: CEntity; 
	var silvercopy																									: CEntity;
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Sword_Dummy') )
	{
		silvercopy = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\cutscenes\witcher_silver_sword\silver_sword.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		silvercopy.AddTag('ACS_Roach_Stash_Silver_Sword_Dummy');
	}
}

function ACS_RoachSilverScabbardDummy_Container()
{
	var scabbardscomp_s 								: CDrawableComponent;
	var i 												: int;
	var items 											: array<SItemUniqueId>;
	var meshComponent 									: CMeshComponent;
	var ent_s 											: CEntity;
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Scabbard_Dummy') )
	{
		ent_s = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource(

		"items\bodyparts\geralt_items\scabbards\silver_scabbards\scabbard_silver_1_01.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		meshComponent = ( CMeshComponent ) ent_s.GetComponentByClassName( 'CMeshComponent' );

		meshComponent.SetScale( Vector( 1.03, 1.03, 1.03 ) );

		ent_s.AddTag('ACS_Roach_Stash_Silver_Scabbard_Dummy');
	}
}

function ACS_RoachSilverSwordAttachmentDummy_Container()
{
	var boneIndex 										: int;
	var boneName 										: name;
	var boneRotation									: EulerAngles;
	var bonePosition									: Vector;
	var dummycomp										: CEntity;
	var dummies											: array<CEntity>;
	var i : Int;
	
	//boneName = 'r_shoulder';
	//boneName = 'spine3';
	//boneName = 'pelvis';
	
	//boneName = 'spine2';
	//boneName = 'spine1';
	
	theGame.GetEntitiesByTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment',dummies);
	
	for(i=0; i<dummies.Size(); i+=1)
	{
		dummies[i].Destroy();
	}
	
	if ( !theGame.GetEntityByTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment') )
	{
		if ( ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 2
		)
		{
			boneName = 'spine2';
		}
		else
		{
			boneName = 'spine1';
		}	
		
		boneIndex = thePlayer.GetHorseWithInventory().GetBoneIndex( boneName );	
		thePlayer.GetHorseWithInventory().GetBoneWorldPositionAndRotationByIndex( boneIndex, bonePosition, boneRotation );
		
		dummycomp = (CEntity)theGame.CreateEntity( (CEntityTemplate)LoadResource( 

		"dlc\dlc_acs\data\fx\acs_ice_breathe_old.w2ent"

		,true ), thePlayer.GetWorldPosition()-100, thePlayer.GetWorldRotation());

		dummycomp.AddTag('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment');

		dummycomp.CreateAttachmentAtBoneWS(thePlayer.GetHorseWithInventory(), boneName, bonePosition, boneRotation );
	}
}

function ACS_ConfigureSilverSwordAttachment_Container()
{
	var silver_pos_x,silver_pos_y,silver_pos_z   								: Float;
	var silver_scab_pos_x,silver_scab_pos_y,silver_scab_pos_z  					: Float;
	var silver_roll, silver_pitch, silver_yaw 									: Float; 
	var silver_scab_roll,silver_scab_pitch,silver_scab_yaw						: Float; 
	var silver_on_roach_position												: Vector;
	var silver_on_roach_rotation 												: EulerAngles;
	var silver_scab_on_roach_position 											: Vector;
	var silver_scab_on_roach_rotation 											: EulerAngles;

	if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 0)
	{
		silver_pos_x = -0.2; 
		silver_pos_y = 0.70; 
		silver_pos_z = 0.4; 

		silver_pitch = -62; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 1)
	{
		silver_pos_x = 0.3; 
		silver_pos_y = 0.70; 
		silver_pos_z = 0.4; 

		silver_pitch = -105; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 2)
	{
		silver_pos_x = -0.35; 
		silver_pos_y = 0.05; 
		silver_pos_z = 0.29; 

		silver_pitch = 180; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 3)
	{
		silver_pos_x = -0.34; 
		silver_pos_y = -0.01; 
		silver_pos_z = 0.32; 

		silver_pitch = -85; 
		silver_roll = 0; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 4)
	{
		silver_pos_x = 0.37; 
		silver_pos_y = -0.01; 
		silver_pos_z = 0.27; 

		silver_pitch = -85; 
		silver_roll = 10; 
		silver_yaw = 0;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 5)
	{
		silver_pos_x = -0.36; 
		silver_pos_y = -0.18; 
		silver_pos_z = 0.30; 

		silver_pitch = -88; 
		silver_roll = 40; 
		silver_yaw = -5;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}
	else if (ACS_Settings_Main_Int('acs_player_equipment_visual_settings','acs_swords_on_roach_positioning', 3) == 6)
	{
		silver_pos_x = -0.36; 
		silver_pos_y = 0.53; 
		silver_pos_z = 0.00; 

		silver_pitch = -85; 
		silver_roll = -75; 
		silver_yaw = -4;

		silver_scab_pos_x = 0; 
		silver_scab_pos_y = 0; 
		silver_scab_pos_z = 0; 

		silver_scab_pitch = 0;
		silver_scab_roll = 0; 
		silver_scab_yaw = 0; 
	}

	silver_on_roach_position.X = 0;    
	silver_on_roach_position.Y = 0;    
	silver_on_roach_position.Z = 0;     

	silver_on_roach_rotation.Pitch = 0;
	silver_on_roach_rotation.Roll = 0;
	silver_on_roach_rotation.Yaw = 0;
	
	silver_on_roach_position.X += silver_pos_y;
	silver_on_roach_position.Y -= silver_pos_z;
	silver_on_roach_position.Z -= silver_pos_x;

	silver_on_roach_rotation.Pitch += silver_pitch;
	silver_on_roach_rotation.Roll += silver_roll;
	silver_on_roach_rotation.Yaw += silver_yaw;
	
	ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy_Attachment'),,silver_on_roach_position, silver_on_roach_rotation );

	silver_scab_on_roach_position.X = 0;
	silver_scab_on_roach_position.Y = 0; 
	silver_scab_on_roach_position.Z = 0;

	silver_scab_on_roach_rotation.Pitch = 0;
	silver_scab_on_roach_rotation.Roll = 0;
	silver_scab_on_roach_rotation.Yaw = 0;

	silver_scab_on_roach_position.X += 0.61 + 0.025; 
	silver_scab_on_roach_position.Y -= 0.09 - 0.1;  
	silver_scab_on_roach_position.Z -= -1.71 + 0.07;   

	silver_scab_on_roach_rotation.Pitch += 180 - 1.5;
	silver_scab_on_roach_rotation.Roll += -24.3 - 5.5;
	silver_scab_on_roach_rotation.Yaw += 14.4 + 4;
	
	silver_scab_on_roach_position.X += silver_scab_pos_x;
	silver_scab_on_roach_position.Y -= silver_scab_pos_y;
	silver_scab_on_roach_position.Z -= silver_scab_pos_z;

	silver_scab_on_roach_rotation.Pitch += silver_scab_pitch;
	silver_scab_on_roach_rotation.Roll += silver_scab_roll; 
	silver_scab_on_roach_rotation.Yaw += silver_scab_yaw;   
	
	ACSGetCEntity('ACS_Roach_Stash_Silver_Scabbard_Dummy').CreateAttachment( ACSGetCEntity('ACS_Roach_Stash_Silver_Sword_Dummy'),,silver_scab_on_roach_position, silver_scab_on_roach_rotation );
}

*/

function ACS_CheckRoachContainerInventorySteel() : bool
{
	var itemIds 																									: array<SItemUniqueId>;

	itemIds = GetACSRoachStashContainer().GetInventory().GetItemsByTag( 'PlayerSteelWeapon' );

	if (itemIds.Size() > 0)
	{
		return true;
	}

	return false;
}

function ACS_CheckRoachContainerCheckInventorySilver() : bool
{
	var itemIds 																									: array<SItemUniqueId>;

	itemIds = GetACSRoachStashContainer().GetInventory().GetItemsByTag( 'PlayerSilverWeapon' );

	if (itemIds.Size() > 0)
	{
		return true;
	}

	return false;
}

function ACS_CheckRoachContainerCheckInventoryCrossbow() : bool
{
	var itemIds 																									: array<SItemUniqueId>;

	itemIds = GetACSRoachStashContainer().GetInventory().GetItemsByTag( 'crossbow' );

	if (itemIds.Size() > 0)
	{
		return true;
	}

	return false;
}

/*
class ACSHuntModuleDialog extends CR4HudModuleDialog
{
	
	function DialogueSliderDataPopupResult( value : float,  optional isItemReward : bool )
	{
		var current_area : EAreaName;
		
		super.DialogueSliderDataPopupResult(value ,false );
		current_area = theGame.GetCommonMapManager().GetCurrentArea();
		if(current_area == AN_Skellige_ArdSkellig )
		{
			GetACSWatcher().getMonsterHunt().setCurrentBet(value,ACSHA_skellige);
		}
		else if( current_area == AN_Velen || current_area== AN_NMLandNovigrad )
		{
			GetACSWatcher().getMonsterHunt().setCurrentBet(value,ACSHA_novigrad);
		}
		else if( current_area == (EAreaName)AN_Dlc_Bob )
		{
			GetACSWatcher().getMonsterHunt().setCurrentBet(value,ACSHA_toussaint);
		}
	}
}

enum ACSHuntArea
{
	ACSHA_none,
	ACSHA_skellige,
	ACSHA_novigrad,
	ACSHA_toussaint
}

enum ACSHuntStatus
{
	ACSHS_none,
	ACSHS_noticePosted,
	ACSHS_noticeTaken,
	ACSHS_targetSpawned,
	ACSHS_targetKilled
}

struct ACSHunt
{
	var targetTag 		: name;
	var noticeItemName 	: name;
	var maxRewardName 	: name;
	var bet 			: float;
	var spawnCenter		: Vector;
	var spawnPosition 	: Vector;
	var targetEntity 	: CEntity;
	var area 	   		: ACSHuntArea;
	var status 			: ACSHuntStatus;
	var monsterLevel	: int;
}

class ACSMonsterHuntChallenge
{
	var _huntsArray 						: array<ACSHunt>;
	var _SkelligeSpawnCenters 				: array<Vector>;
	var _NovSpawnCenters 					: array<Vector>;
	var _ToussaintSpawnCenters				: array<Vector>;
	var _skelligeBoardsArray				: array<name>;
	var _novBoardsArray 					: array<name>;
	var _toussaintBoardsArray				: array<name>;
	var _skeHunt,_novHunt,_tousHunt 		: ACSHunt;
	var _currentHuntDay 					: int;
	var betDialog 							: ACSHuntModuleDialog;	 
	

	public function init()
	{
		var i : int;
		
		//generating challenges
		_huntsArray.Clear();
		addHuntToArray('acs_monster_hunt_fogling','modEHNotice_1');
		addHuntToArray('acs_monster_hunt_hag_water','modEHNotice_2');
		addHuntToArray('acs_monster_hunt_wyvern','modEHNotice_3');
		addHuntToArray('acs_monster_hunt_archgriffin','modEHNotice_4');
		addHuntToArray('acs_monster_hunt_harpy','modEHNotice_5');
		addHuntToArray('acs_monster_hunt_ekhidna','modEHNotice_6');
		//addHuntToArray("modEHNotice_7",'mon_endriaga_soldier_spikey','modEHNotice_7','modEHNotice_med_reward');
		//addHuntToArray("modEHNotice_8",'mon_endriaga_soldier_tailed','modEHNotice_8','modEHNotice_high_reward');
		addHuntToArray('acs_monster_hunt_bies','modEHNotice_9');
		addHuntToArray('acs_monster_hunt_troll_cave','modEHNotice_10');
		addHuntToArray('acs_monster_hunt_forktail','modEHNotice_11');
		addHuntToArray('acs_monster_hunt_arachas','modEHNotice_12');
		addHuntToArray('acs_monster_hunt_gryphon','modEHNotice_13');
		addHuntToArray('acs_monster_hunt_nightwraith','modEHNotice_14');
		addHuntToArray('acs_monster_hunt_cockatrice','modEHNotice_15');		
		addHuntToArray('acs_monster_hunt_crab','modEHNotice_16');
		addHuntToArray('acs_monster_hunt_czart','modEHNotice_17');
		addHuntToArray('acs_monster_hunt_elemental','modEHNotice_18');
		addHuntToArray('acs_monster_hunt_fugas','modEHNotice_19');
		addHuntToArray('acs_monster_hunt_katakan','modEHNotice_20');
		addHuntToArray('acs_monster_hunt_lessog','modEHNotice_21');		
		addHuntToArray('acs_monster_hunt_nekker','modEHNotice_22');		
		addHuntToArray('acs_monster_hunt_noonwright','modEHNotice_23');		
		addHuntToArray('acs_monster_hunt_siren','modEHNotice_24');		
		addHuntToArray('acs_monster_hunt_him','modEHNotice_25');		


		
		//list of noticeboardes in Skellige
		_skelligeBoardsArray.Clear();
		_skelligeBoardsArray.PushBack('fyresdal_notice_board');
		_skelligeBoardsArray.PushBack('blandare_notice_board');
		_skelligeBoardsArray.PushBack('kaer_trolde_village_notice_board');
		_skelligeBoardsArray.PushBack('rannvaig_noticeboard');
		_skelligeBoardsArray.PushBack('holmstein_notice_board');
		_skelligeBoardsArray.PushBack('brokvar_notice_board');
		_skelligeBoardsArray.PushBack('larvik_notice_board');
		_skelligeBoardsArray.PushBack('arinbjorn_noticeboard');
		
		//list of noticeBoards in velen&novigrad
		_novBoardsArray.Clear();
		_novBoardsArray.PushBack('nilfgaard_camp_notice_board');
		_novBoardsArray.PushBack('borrows_notice_board');
		_novBoardsArray.PushBack('rudnik_notice_board');
		_novBoardsArray.PushBack('mouths_notice_board');
		_novBoardsArray.PushBack('barons_village_notice_board');
		_novBoardsArray.PushBack('midcotts_noticeboard');
		_novBoardsArray.PushBack('inn_crossroads_notice_board');
		_novBoardsArray.PushBack('poppystone_notice_board');
		_novBoardsArray.PushBack('whitebridge_noticeboard');
		_novBoardsArray.PushBack('fat_catch_inn_noticeboard');
		_novBoardsArray.PushBack('toderas_noticeboard');
		_novBoardsArray.PushBack('seven_cats_noticeboard');
		_novBoardsArray.PushBack('southern_farms_notice_board');
		_novBoardsArray.PushBack('farmsvillage_2_noticeboard');
		_novBoardsArray.PushBack('q602_village_noticeboard');
		_novBoardsArray.PushBack('harbor_district_noticeboard');
		_novBoardsArray.PushBack('market_noticeboard');
		_novBoardsArray.PushBack('novigrad_rich_district_noticeboard');
		
		//list of noaticeBoards in Toussaint
		_toussaintBoardsArray.Clear();
		_toussaintBoardsArray.PushBack('trappers_trading_post_noticeboard');
		_toussaintBoardsArray.PushBack('cockatrice_inn_noticeboard');
		_toussaintBoardsArray.PushBack('tufo_vineyard_noticeboard');
		_toussaintBoardsArray.PushBack('quarry_noticeboard_mp');
		_toussaintBoardsArray.PushBack('coronata_vineyard_noticeboard');
		_toussaintBoardsArray.PushBack('castel_ravello_noticeboard');
		_toussaintBoardsArray.PushBack('beauclair_city_noticeboard');
		
		//spawnPoints
		_SkelligeSpawnCenters.Clear();	
		_NovSpawnCenters.Clear();
		_ToussaintSpawnCenters.Clear();

		_NovSpawnCenters.PushBack(Vector(  1925, -435, 200 ));//TODO Water
		_NovSpawnCenters.PushBack(Vector(  1073, -55, 200 ));
		_NovSpawnCenters.PushBack(Vector(  57, 468, 200 ));
		_NovSpawnCenters.PushBack(Vector(  905, 2502, 100 ));//TODO Border
		_NovSpawnCenters.PushBack(Vector(  1300, 700, 120 ));
		_NovSpawnCenters.PushBack(Vector(  1351, -600, 300 ));
		_NovSpawnCenters.PushBack(Vector(  -469, -192, 200 ));
		_NovSpawnCenters.PushBack(Vector(  1709, -350, 150 ));
		_NovSpawnCenters.PushBack(Vector(  1591, 92, 150 ));
		_NovSpawnCenters.PushBack(Vector(  1395, 91, 150 ));
		_NovSpawnCenters.PushBack(Vector(  319, 1472, 100 ));
		_NovSpawnCenters.PushBack(Vector(  532, 1317, 100 ));
		_NovSpawnCenters.PushBack(Vector(  1101, 1516, 100 ));
		_NovSpawnCenters.PushBack(Vector(  773, 642, 100 ));
		_NovSpawnCenters.PushBack(Vector(  255, -195, 150 ));
		_NovSpawnCenters.PushBack(Vector(  2172, 1067, 200 ));
		_NovSpawnCenters.PushBack(Vector(  1865, 1872, 150 ));

		
		_SkelligeSpawnCenters.PushBack(Vector(933,-230,200));
		_SkelligeSpawnCenters.PushBack(Vector(652,-448,100));
		_SkelligeSpawnCenters.PushBack(Vector(-429,-275,100));
		_SkelligeSpawnCenters.PushBack(Vector(819,380,200));
		_SkelligeSpawnCenters.PushBack(Vector(-9,373,80));
		_SkelligeSpawnCenters.PushBack(Vector(369,-45,150));
		_SkelligeSpawnCenters.PushBack(Vector(585,-497,100));
		_SkelligeSpawnCenters.PushBack(Vector(574,619,80));
		_SkelligeSpawnCenters.PushBack(Vector(-1420,1492,80));
		_SkelligeSpawnCenters.PushBack(Vector(-1560,-706,100));

		_ToussaintSpawnCenters.PushBack(Vector(1000,-686,200));
		_ToussaintSpawnCenters.PushBack(Vector(-540,-552,150));
		_ToussaintSpawnCenters.PushBack(Vector(-215,174,150));
		_ToussaintSpawnCenters.PushBack(Vector(-290,363,150));
		_ToussaintSpawnCenters.PushBack(Vector(453,-616,150));
		_ToussaintSpawnCenters.PushBack(Vector(911,-1000,150));
		_ToussaintSpawnCenters.PushBack(Vector(484,-1500,150));
		_ToussaintSpawnCenters.PushBack(Vector(277,-1931,150));
		_ToussaintSpawnCenters.PushBack(Vector(-378,-1897,150));
		
		if(  !FactsDoesExist("ACS_Version_" + FloatToString(ACS_GetVersion())) ) 
		{	
			update();
			FactsAdd("ACS_Version_" + FloatToString(ACS_GetVersion()));
		}
	
		if( _skeHunt.status == ACSHS_targetSpawned && !_skeHunt.targetEntity)
		{
			_skeHunt.targetEntity = theGame.GetEntityByTag(_skeHunt.targetTag);
			 ((CNewNPC)_skeHunt.targetEntity).SetLevel(_skeHunt.monsterLevel);
		}
		if(_novHunt.status == ACSHS_targetSpawned && !_novHunt.targetEntity)
		{
			_novHunt.targetEntity = theGame.GetEntityByTag(_novHunt.targetTag);
			((CNewNPC)_novHunt.targetEntity).SetLevel(_novHunt.monsterLevel);
		}
		if(_tousHunt.status == ACSHS_targetSpawned && !_tousHunt.targetEntity)
		{
			_tousHunt.targetEntity = theGame.GetEntityByTag(_tousHunt.targetTag);
			((CNewNPC)_tousHunt.targetEntity).SetLevel(_tousHunt.monsterLevel);
		}
				
	}

	private function addHuntToArray(targetTag : name, noticeItemName : name,optional canFly : bool )
	{
		var hunt : ACSHunt;
		
		//hunt.locName = locName;
		hunt.targetTag = targetTag; 
		hunt.noticeItemName = noticeItemName;
		hunt.maxRewardName = 'modEHMonsterHunt_high_reward';
		hunt.area = ACSHA_none;
		hunt.status = ACSHS_none;

		_huntsArray.PushBack(hunt);
	}
	
	public function refreshHunt()
	{
		var area : EAreaName ;
		var dist : float;
		
		//refresh
		if( FactsQuerySum("ACS_Monster_Hunt_Active") <= 0 )
		{
		
			clearAll();

			//##### Skellige #####
		
			_skeHunt.spawnCenter = Vector(0,0,0);
			_skeHunt.spawnPosition = Vector(0,0,0);
			//reset bet
			_skeHunt.bet = 0;
			//add  new one
			postNewNotice(ACSHA_skellige);
			
			//##### Novigrad #####

			_novHunt.spawnCenter = Vector(0,0,0);
			_novHunt.spawnPosition = Vector(0,0,0);
			//reset bet
			_novHunt.bet = 0;
			//add  new one
			postNewNotice(ACSHA_novigrad);
			
			//##### Toussaint #####


			_tousHunt.spawnCenter = Vector(0,0,0);
			_tousHunt.spawnPosition = Vector(0,0,0);
			//reset bet
			_tousHunt.bet = 0;
			//add  new one
			postNewNotice(ACSHA_toussaint);
			
			
			_currentHuntDay = GameTimeDays(theGame.GetGameTime());
			
		}
		
		//spawn monsters if needed
		area = theGame.GetCommonMapManager().GetCurrentArea();
		
		if(area == AN_Skellige_ArdSkellig &&_skeHunt.status == ACSHS_noticeTaken )
		{
			dist = VecDistance2D(thePlayer.GetWorldPosition(),_skeHunt.spawnPosition);
			if(dist<=400)
			{
				_spawnHunt(ACSHA_skellige);
				//status changed inside the function
			}
		}
		if(area == AN_NMLandNovigrad && _novHunt.status == ACSHS_noticeTaken)
		{
			dist = VecDistance2D(thePlayer.GetWorldPosition(),_novHunt.spawnPosition);
			if(dist<=400)
			{
				_spawnHunt(ACSHA_novigrad);
				//status changed inside the function
			}
		}
		if(area == (EAreaName)AN_Dlc_Bob && _tousHunt.status == ACSHS_noticeTaken)
		{
			dist = VecDistance2D(thePlayer.GetWorldPosition(),_tousHunt.spawnPosition);
			if(dist<=400)
			{
				_spawnHunt(ACSHA_toussaint);
				//status changed inside the function
			}
		}
	
	}
	
	public function  update()
	{
		var rawHunt : ACSHunt;
	
		clearAll();

		_currentHuntDay = 0;
		_skeHunt = rawHunt;
		_novHunt = rawHunt;
		_tousHunt = rawHunt;
	}

	public function clearAll()
	{
		var i,j 	: int;
		var ents	: array<CEntity>;
		var bookFactName:  string;
		
		//notices in skellige
		clearAllNotices(ACSHA_skellige);	
		
		//notices in novigrad
		clearAllNotices(ACSHA_novigrad);
		
		//notices in toussaint
		clearAllNotices(ACSHA_toussaint);
		
		//inventory items
		thePlayer.GetInventory().RemoveItemByTag('eh_notice',-1);
		//books
		for(j=0;j<_huntsArray.Size();j+=1)
		{
			bookFactName = "BookReadState_"+_huntsArray[j].noticeItemName;
			bookFactName = StrReplace(bookFactName," ","_");		
			FactsSubstract( bookFactName, 1 );
		}
		
		//target monsters
		theGame.GetEntitiesByTag('acs_monster_hunt',ents);
		for(i=0;i<ents.Size();i+=1)
		{
			ents[i].Destroy();
		}
		
		
	}
	
	public function clearAllNotices(area : ACSHuntArea)
	{
		var i,j : int;
		
		if(area == ACSHA_skellige)
		{
			for( i=0; i< _skelligeBoardsArray.Size(); i+=1 )
			{
				for( j=0; j<_huntsArray.Size(); j+=1 )
				{
					RemoveErrandsFromNoticeboard(_skelligeBoardsArray[i],NameToString(_huntsArray[j].noticeItemName) );
				}
			}
		}
		else if(area == ACSHA_novigrad)
		{
			for( i=0; i< _novBoardsArray.Size(); i+=1 )
			{
				for( j=0; j<_huntsArray.Size(); j+=1 )
				{
					RemoveErrandsFromNoticeboard(_novBoardsArray[i],NameToString(_huntsArray[j].noticeItemName) );
				}
			}
		}
		else
		{
			for( i=0; i< _toussaintBoardsArray.Size(); i+=1 )
			{
				for( j=0; j<_huntsArray.Size(); j+=1 )
				{
					RemoveErrandsFromNoticeboard(_toussaintBoardsArray[i],NameToString(_huntsArray[j].noticeItemName) );
				}
			}
		}
	
	}

	public function noticeTaken()
	{
		//var scene : CStoryScene;
		
		theGame.GetGuiManager().GetRootMenu().CloseMenu();
		
		//scene = (CStoryScene)LoadResource( "dlc\dlc_acs\data\scenes\eh_bet_scene.w2scene", true);
		//theGame.GetStorySceneSystem().PlayScene(scene, "Input");
		startHunt();
	}

	public function startHunt()
	{
		var current_area : EAreaName;

		clearAll();

		current_area = theGame.GetCommonMapManager().GetCurrentArea();
		
		if(current_area == AN_Skellige_ArdSkellig )
		{
			_skeHunt.status = ACSHS_noticeTaken;
			thePlayer.GetInventory().AddAnItem(_skeHunt.noticeItemName,1,false);
			betDialog = new ACSHuntModuleDialog in this;
			betDialog.OpenBetPopup(_skeHunt.maxRewardName,0);
			_prepareSpawn(ACSHA_skellige);
		}
		else if( current_area == AN_Velen || current_area== AN_NMLandNovigrad )
		{
			_novHunt.status =  ACSHS_noticeTaken;
			thePlayer.GetInventory().AddAnItem(_novHunt.noticeItemName,1,false);
			betDialog = new ACSHuntModuleDialog in this;
			betDialog.OpenBetPopup(_novHunt.maxRewardName,0);
			_prepareSpawn(ACSHA_novigrad);

		}
		else if( current_area == (EAreaName)AN_Dlc_Bob )
		{
			_tousHunt.status =  ACSHS_noticeTaken;
			thePlayer.GetInventory().AddAnItem(_tousHunt.noticeItemName,1,false);
			betDialog = new ACSHuntModuleDialog in this;
			betDialog.OpenBetPopup(_tousHunt.maxRewardName,0);
			_prepareSpawn(ACSHA_toussaint);

		}
			
		theSound.SoundEvent("gui_ingame_quest_active");

		if ( FactsQuerySum("ACS_Monster_Hunt_Active") <= 0 )
		{
			FactsAdd("ACS_Monster_Hunt_Active", 1, -1);
		}
	}
	
	public function npcKilled( npc : CNewNPC )
	{
		if( ( _skeHunt.status != ACSHS_targetSpawned ) && (_novHunt.status != ACSHS_targetSpawned ) && (_tousHunt.status != ACSHS_targetSpawned) )
		 return;
		 
		if( ! npc.HasTag('acs_monster_hunt'))
		 return;

		if(  _skeHunt.status == ACSHS_targetSpawned && npc.HasTag(_skeHunt.targetTag) )
		{ 
			
			_skeHunt.status = ACSHS_targetKilled;
			removeCurrentItem(ACSHA_skellige);//TODO change this
			
			//giveReward
			if(_skeHunt.bet != 0)
			{
				thePlayer.GetInventory().AddMoney(RoundF(_skeHunt.bet * 2));
			}
			
			thePlayer.DisplayHudMessage(GetLocStringByKeyExt("modACSMonsterHuntChallenge_success"));
			theSound.SoundEvent("gui_ingame_quest_success");
			theGame.GetGuiManager().ShowNotification("+ "+FloatToString(_skeHunt.bet * 2)+" Gold");

			
		}
		else if(_novHunt.status == ACSHS_targetSpawned && npc.HasTag(_novHunt.targetTag))
		{
			_novHunt.status = ACSHS_targetKilled;
			removeCurrentItem(ACSHA_novigrad);
			
			if(_novHunt.bet != 0)
			{
				thePlayer.GetInventory().AddMoney(RoundF(_novHunt.bet * 2));
			}
			
			thePlayer.DisplayHudMessage(GetLocStringByKeyExt("modACSMonsterHuntChallenge_success"));
			theSound.SoundEvent("gui_ingame_quest_success");
			theGame.GetGuiManager().ShowNotification("+ "+FloatToString(_novHunt.bet * 2)+" Gold");
		
		}
		else if(  _tousHunt.status == ACSHS_targetSpawned && npc.HasTag(_tousHunt.targetTag) )
		{ 
			
			_tousHunt.status = ACSHS_targetKilled;
			removeCurrentItem(ACSHA_toussaint);
			
			if(_tousHunt.bet != 0)
			{
				thePlayer.GetInventory().AddMoney(RoundF(_tousHunt.bet * 2));
			}
			
			thePlayer.DisplayHudMessage(GetLocStringByKeyExt("modACSMonsterHuntChallenge_success"));
			theSound.SoundEvent("gui_ingame_quest_success");
			theGame.GetGuiManager().ShowNotification("+ "+FloatToString(_tousHunt.bet * 2)+" Gold");

			
		}

		if (FactsQuerySum("ACS_Monster_Hunt_Active") > 0)
		{
			FactsRemove("ACS_Monster_Hunt_Active");
		}
	}
	
	private function getNewHunt() : ACSHunt
	{
		var rand : int;
		
		rand = RandRange(_huntsArray.Size(),0);
		return _huntsArray[rand];
	}
	
	private function newErrandList(errandLocName : string) :  array < ErrandDetailsList >
	{
		var errandDetails : array < ErrandDetailsList >;
		var details : ErrandDetailsList;
		
		
		details.errandStringKey = errandLocName;
		details.newQuestFact = "ACS_Version_" + FloatToString(ACS_GetVersion());
		details.errandPosition = 0;
		errandDetails.PushBack( details);
		
		return errandDetails;
	}

	private function postNewNotice(area : ACSHuntArea)
	{
		var newHunt 			: ACSHunt;
		var errandDetails 		: array < ErrandDetailsList >;
		var i 					: int;
		
		if(area == ACSHA_skellige)
		{
			newHunt = getNewHunt();

			while
			(	
				newHunt.targetTag == _skeHunt.targetTag 
				|| 	newHunt.targetTag == _novHunt.targetTag
				||	newHunt.targetTag == _tousHunt.targetTag
			)
			{
				newHunt = getNewHunt();
			}
			
			
			_skeHunt = newHunt;
			_skeHunt.status = ACSHS_noticePosted;
			_skeHunt.area = ACSHA_skellige;
			errandDetails = newErrandList(_skeHunt.noticeItemName);

			for( i=0; i< _skelligeBoardsArray.Size(); i+=1 )
			{
				AddErrandsToTheNoticeBoard(_skelligeBoardsArray[i],errandDetails, true );
			}
		}
		else if(area == ACSHA_novigrad )
		{
			newHunt = getNewHunt();

			while
			(	
				newHunt.targetTag == _skeHunt.targetTag 
				|| 	newHunt.targetTag == _novHunt.targetTag
				||	newHunt.targetTag == _tousHunt.targetTag
			)
			{
				newHunt = getNewHunt();
			}

			
			_novHunt = newHunt;
			_novHunt.status = ACSHS_noticePosted;
			_novHunt.area = ACSHA_novigrad;
			errandDetails = newErrandList(_novHunt.noticeItemName);

			for( i=0; i< _novBoardsArray.Size(); i+=1 )
			{
				AddErrandsToTheNoticeBoard(_novBoardsArray[i],errandDetails, true );
			}
		}	
		else
		{
			
			newHunt = getNewHunt();
			while
			(	
				newHunt.targetTag == _skeHunt.targetTag 
				|| 	newHunt.targetTag == _novHunt.targetTag
				||	newHunt.targetTag == _tousHunt.targetTag
			)
			{
				newHunt = getNewHunt();
			}
			
			
			_tousHunt = newHunt;
			_tousHunt.status = ACSHS_noticePosted;
			_tousHunt.area = ACSHA_toussaint;
			errandDetails = newErrandList(_tousHunt.noticeItemName);

			for( i=0; i< _toussaintBoardsArray.Size(); i+=1 )
			{
				AddErrandsToTheNoticeBoard(_toussaintBoardsArray[i],errandDetails, true );
			}
		}
			
	}
	
	private function _calculateSpawnPositon(area : ACSHuntArea) : Vector
	{
		var SpawnPointsArray : array<Vector>;
		var spawnPoint : Vector;
		var rand : int;
		
		if(area == ACSHA_skellige )
			SpawnPointsArray = _SkelligeSpawnCenters;	
		
		if(area == ACSHA_novigrad )
			SpawnPointsArray = _NovSpawnCenters;	
		if(area == ACSHA_toussaint )
			SpawnPointsArray = _ToussaintSpawnCenters;
		
		rand = RandRange(SpawnPointsArray.Size());
		
		if(area == ACSHA_skellige)
		{
			_skeHunt.spawnCenter = SpawnPointsArray[rand];
			return getRandomPositionInRadius(_skeHunt.spawnCenter,RoundF(_skeHunt.spawnCenter.Z) );
		}
		else if(area == ACSHA_novigrad)
		{
			_novHunt.spawnCenter = SpawnPointsArray[rand];
			return getRandomPositionInRadius(_novHunt.spawnCenter ,RoundF(_novHunt.spawnCenter.Z) );
		}else
		{
			_tousHunt.spawnCenter = SpawnPointsArray[rand];
			return getRandomPositionInRadius(_tousHunt.spawnCenter ,RoundF(_tousHunt.spawnCenter.Z) );
		}
	}
	
	private function _calculateSpawnLevel() : int
	{
		var pLevel,lvl : int;
		
		pLevel = thePlayer.GetLevel();
		
		return RandRange(pLevel+5,pLevel);
	}
	
	private function _getTemplateFromTarget(targetTag : name) : CEntityTemplate
	{
		var path : string;
		
		path = "dlc/dlc_acs/data/entities/monsters/"+ NameToString(targetTag) + ".w2ent";

		return (CEntityTemplate)LoadResource(path,true);
	}
	
	private function getRandomPositionInRadius(Center : Vector , Radius : int):Vector
	{
		var pos : Vector;
		
		pos.X  = Center.X + RandRange(Radius/2,-Radius/2);
		pos.Y  = Center.Y + RandRange(Radius/2,-Radius/2);
		pos.Z  = 0;
		return pos;
	}
	
	private function _prepareSpawn(area : ACSHuntArea)
	{
		var spawnedEntity : CEntity;
		var npc	:	CNewNPC;
		var spawnPosition : Vector;
		var SpawnLevel  : int;
		var template : CEntityTemplate;

		if(area == ACSHA_skellige)
		{
			_skeHunt.spawnPosition = _calculateSpawnPositon(area);
		}
		else if (area == ACSHA_novigrad)
		{
			_novHunt.spawnPosition = _calculateSpawnPositon(area);
		}
		else
		{
			_tousHunt.spawnPosition = _calculateSpawnPositon(area);		
		}
		
	}
	
	private function _spawnHunt(area : ACSHuntArea )
	{
		var spawnedEntity : CEntity;
		var npc	:	CNewNPC;
		var spawnPosition : Vector;
		var SpawnLevel  : int;
		var template : CEntityTemplate;
		
		if( area == ACSHA_skellige)
		{
			template = _getTemplateFromTarget(_skeHunt.targetTag);
			spawnPosition = _skeHunt.spawnPosition;

		}
		else if(area == ACSHA_novigrad)
		{
			template = _getTemplateFromTarget(_novHunt.targetTag);
			spawnPosition = _novHunt.spawnPosition;
		}
		else
		{
			template = _getTemplateFromTarget(_tousHunt.targetTag);
			spawnPosition = _tousHunt.spawnPosition;
		}

		SpawnLevel = _calculateSpawnLevel();
		
		if(!theGame.GetWorld().NavigationComputeZ(spawnPosition,spawnPosition.Z-100,spawnPosition.Z+100,spawnPosition.Z) )
		{
			return;
		}
		
		spawnedEntity = theGame.CreateEntity(template,spawnPosition, EulerAngles(0,0,0));
		npc = (CNewNPC)spawnedEntity;
		npc.SetLevel(SpawnLevel);
		npc.AddTag('acs_monster_hunt');

		
		if(area == ACSHA_skellige)
		{
			_skeHunt.status = ACSHS_targetSpawned;
			_skeHunt.targetEntity = spawnedEntity;
			_skeHunt.monsterLevel = SpawnLevel;
		}
		else if(area == ACSHA_novigrad)
		{
			_novHunt.status = ACSHS_targetSpawned;
			_novHunt.targetEntity = spawnedEntity;
			_novHunt.monsterLevel = SpawnLevel;
		}
		else
		{
			_tousHunt.status = ACSHS_targetSpawned;
			_tousHunt.targetEntity = spawnedEntity;
			_tousHunt.monsterLevel = SpawnLevel;
		}

		
	}
	
	private function _despawnMonster(area : ACSHuntArea)
	{
		if(area == ACSHA_skellige )
		{
			_skeHunt.targetEntity.Destroy();
		}
		else if(area == ACSHA_novigrad )
		{
			_novHunt.targetEntity.Destroy();
		}
		else
		{
			_tousHunt.targetEntity.Destroy();
		}

	}
	
	public function removeCurrentItem(area : ACSHuntArea)
	{
		var bookFactName		: string;
		if( area == ACSHA_skellige )
		{
			thePlayer.GetInventory().RemoveItemByName(_skeHunt.noticeItemName,1);
			bookFactName = "BookReadState_"+_skeHunt.noticeItemName;
			bookFactName = StrReplace(bookFactName," ","_");		
			FactsSubstract( bookFactName, 1 );
		}
		else if( area == ACSHA_novigrad )
		{
			thePlayer.GetInventory().RemoveItemByName(_novHunt.noticeItemName,1);
			bookFactName = "BookReadState_"+_novHunt.noticeItemName;
			bookFactName = StrReplace(bookFactName," ","_");		
			FactsSubstract( bookFactName, 1 );
		}	
		else
		{
			thePlayer.GetInventory().RemoveItemByName(_tousHunt.noticeItemName,1);
			bookFactName = "BookReadState_"+_tousHunt.noticeItemName;
			bookFactName = StrReplace(bookFactName," ","_");		
			FactsSubstract( bookFactName, 1 );
		}
	}
	
	public function setCurrentBet(value : float,area : ACSHuntArea)
	{
		if( area == ACSHA_skellige)
		{
			_skeHunt.bet = value;	
		}
		else if( area == ACSHA_novigrad )
		{
			_novHunt.bet = value;	
		}
		else
		{
			_tousHunt.bet = value;
		}
	}
	
	public function getcurrentSpawn(area : ACSHuntArea): CEntity
	{
		if(area == ACSHA_skellige )
		{
			return _skeHunt.targetEntity;
		}
		else if(area == ACSHA_novigrad)
		{
			return _novHunt.targetEntity;
		}
		else
		{
			return _tousHunt.targetEntity;
		}
	}
	
	 
	public function _getCurrentHuntStatus(where : ACSHuntArea) : ACSHuntStatus
	{
		if(where == ACSHA_skellige)
		{
			return _skeHunt.status;
		}
		else if(where == ACSHA_novigrad)
		{
			return _novHunt.status;
		}
		else
		{
			return _tousHunt.status;
		}

	}
	
	public function _getCurrentCenter(where : ACSHuntArea) : Vector
	{
		if(where == ACSHA_skellige )
		{
			return _skeHunt.spawnCenter;
		}
		else if(where == ACSHA_novigrad)
		{
			return _novHunt.spawnCenter;
		}
		else
		{
			return _tousHunt.spawnCenter;
		}
	}
	
	public function _getCurrentPos(where : ACSHuntArea) : Vector
	{
		if(where == ACSHA_skellige )
		{
			return _skeHunt.spawnPosition;
		}
		else if(where == ACSHA_novigrad)
		{
			return _novHunt.spawnPosition;
		}	
		else
		{
			return _tousHunt.spawnPosition;
		}		
	}
	
	public function getCurrentHunt(area : ACSHuntArea) : ACSHunt
	{
		switch (area)
		{
			case ACSHA_skellige: return _skeHunt;
			case ACSHA_novigrad: return _novHunt ;
			case ACSHA_toussaint: return _tousHunt;
			default : return _novHunt ;
		}
		
	}
}

storyscene function acs_monster_hunt_beginHunt(player: CStoryScenePlayer)
{
	GetACSWatcher().getMonsterHunt().startHunt();
}
*/

function ACS_Add_Shades_Keys()
{
	var i			: int;
	var names 		: array<name>;

	names.PushBack('key_revenant_set');
	names.PushBack('key_ares');
	names.PushBack('key_beastcutter');
	names.PushBack('key_fallen_set');
	names.PushBack('key_bloodshot');
	names.PushBack('key_claymore');
	names.PushBack('key_doomblade');
	names.PushBack('key_aquila');
	names.PushBack('key_frostmourne');
	names.PushBack('key_rakuyo');
	names.PushBack('key_gorgonslayer');
	names.PushBack('key_faraam_set');
	names.PushBack('key_kukri');
	names.PushBack('key_bloodhunter_set');
	names.PushBack('key_oldhunter_set');
	names.PushBack('key_berserker_set');
	names.PushBack('key_bismarck_set');
	names.PushBack('key_heavenspire');
	names.PushBack('key_haoma');
	names.PushBack('key_hellspire');
	names.PushBack('key_knife');
	names.PushBack('key_lionhunter_sword');
	names.PushBack('key_oathblade');
	names.PushBack('key_pridefall');
	names.PushBack('key_stalker_set');
	names.PushBack('key_ikari');
	names.PushBack('key_oblivion');
	names.PushBack('key_sinner');
	names.PushBack('key_rd_set');
	names.PushBack('key_voidblade');
	names.PushBack('key_rddivider');
	names.PushBack('key_rdblade');
	names.PushBack('key_flameborn');
	names.PushBack('key_blackdawn');
	names.PushBack('key_blooddusk');
	names.PushBack('key_lionhunter_set');
	names.PushBack('key_bloodletter');
	names.PushBack('key_crownbreaker');
	names.PushBack('key_dragonbane');
	names.PushBack('key_kingslayer');
	names.PushBack('key_ejder');
	names.PushBack('key_graveripper');
	names.PushBack('key_hades');
	names.PushBack('key_icarus');
	names.PushBack('key_peacekeeper');
	names.PushBack('key_khopesh');
	names.PushBack('key_vulcan');
	names.PushBack('key_ezio_set');
	names.PushBack('key_headtaker_set');
	names.PushBack('key_hitokiri_set');
	names.PushBack('key_eileen_set');
	names.PushBack('key_yahargul_set');
	names.PushBack('key_taifeng_set');
	names.PushBack('key_kara_set');
	names.PushBack('key_sithis_blade');
	names.PushBack('key_sithis_armor');
	
	
	for ( i = 0; i <= names.Size() ; i += 1 )
	{
		if( !thePlayer.inv.HasItem( names[i] ) )
		{
			thePlayer.inv.AddAnItem( names[i], 1);
		}
	}
}

function ACS_Player_Near_Quest_Marker(): bool
{
  	var player_position: Vector;

  	player_position = thePlayer.GetWorldPosition();

	if (VecDistanceSquared2D(player_position, ACSGetCEntity('ACS_Guiding_Light_Marker').GetWorldPosition()) <= 35 * 35
	|| VecDistanceSquared2D(player_position, ACSGetCEntity('ACS_Guiding_Light_Available_Quest_Marker').GetWorldPosition()) <= 35 * 35
	) 
	{
		return true;
	}

  	return false;
}

function ACS_PlayerSurroundedCheck() : bool
{
	var actor							: CActor; 
	var actors		    				: array<CActor>;
	var enemyAnimatedComponent 			: CAnimatedComponent;
	var i								: int;
	var npc								: CNewNPC;

	actors.Clear();

	actors = thePlayer.GetNPCsAndPlayersInRange( 10, 10, , FLAG_OnlyAliveActors + FLAG_Attitude_Hostile + FLAG_ExcludePlayer);

	if( actors.Size() > 1 )
	{
		return true;
	}

	return false;
}

exec function acskillall()
{
	GetACSWatcher().DestroyCustomMonsters();
}

function ACS_SignIntensityPercentage( sign : name ) : float
{
	var sp, sp1, sp2, sp3, sp4, sp5 : SAbilityAttributeValue;
	var witcher : W3PlayerWitcher;
	var total : float;

	witcher = GetWitcherPlayer();

	switch(sign)
	{
		case 'aard' :
		sp = witcher.GetTotalSignSpellPower(S_Magic_1);
		
		total = sp.valueMultiplicative;
		break;

		case 'igni' :
		sp = witcher.GetTotalSignSpellPower(S_Magic_2);

		total = sp.valueMultiplicative;
		break;

		case 'yrden' :
		sp = witcher.GetTotalSignSpellPower(S_Magic_3);

		total = sp.valueMultiplicative;
		break;

		case 'quen' :
		sp = witcher.GetTotalSignSpellPower(S_Magic_4);

		total = sp.valueMultiplicative;
		break;

		case 'axii' :
		sp = witcher.GetTotalSignSpellPower(S_Magic_5);

		total = sp.valueMultiplicative;
		break;

		case 'all' :
		sp1 = witcher.GetTotalSignSpellPower(S_Magic_1);
		sp2 = witcher.GetTotalSignSpellPower(S_Magic_2);
		sp3 = witcher.GetTotalSignSpellPower(S_Magic_3);
		sp4 = witcher.GetTotalSignSpellPower(S_Magic_4);
		sp5 = witcher.GetTotalSignSpellPower(S_Magic_5);

		total = (sp1.valueMultiplicative 
		+ sp2.valueMultiplicative
		+ sp3.valueMultiplicative
		+ sp4.valueMultiplicative
		+ sp5.valueMultiplicative)/5;
		break;

		default :
		sp1 = witcher.GetTotalSignSpellPower(S_Magic_1);
		sp2 = witcher.GetTotalSignSpellPower(S_Magic_2);
		sp3 = witcher.GetTotalSignSpellPower(S_Magic_3);
		sp4 = witcher.GetTotalSignSpellPower(S_Magic_4);
		sp5 = witcher.GetTotalSignSpellPower(S_Magic_5);

		total = (sp1.valueMultiplicative 
		+ sp2.valueMultiplicative
		+ sp3.valueMultiplicative
		+ sp4.valueMultiplicative
		+ sp5.valueMultiplicative)/5;
		break;
	}

	return total;
}

function ACSCreateBurningFX( targetNPC : CNewNPC )
{
	var ent_ground_fx									          	  	: CEntity;
	var pos																: Vector;

	if (targetNPC.GetAttitude( thePlayer ) != AIA_Hostile)
	{
		return;
	}

	if (!targetNPC.HasTag('ACS_Killed_By_Fire'))
	{
		return;
	}

	pos = targetNPC.GetWorldPosition() + targetNPC.GetWorldForward() * -2 + targetNPC.GetWorldRight() * 2.5;
	
	ent_ground_fx = theGame.CreateEntity( (CEntityTemplate)LoadResource( 

	"dlc\dlc_acs\data\fx\acs_sword_trail.w2ent"

	, true ), ACSFixZAxis(pos), targetNPC.GetWorldRotation() );

	//ent_ground_fx.PlayEffectSingle('golem_fire_fx');

	ent_ground_fx.PlayEffectSingle('golem_ground_fire_fx');

	//ent_ground_fx.CreateAttachment(targetNPC, , Vector(0,0,1));

	ent_ground_fx.DestroyAfter(300);

	ent_ground_fx.AddTag('ACS_Killed_By_Fire_Burning_FX_Ground_Fire');
}

struct ACS_SAttackAnimation
{
	var animName : name;
	var isStanceSwitched : bool;
	var stance, linkedAnimIndex : int;
}

class ACS_W3ComboSystemExtender
{
	protected var fastAttacks, strongAttacks, fastAttacksFist, strongAttacksFist, secondaryAttacks : array<ACS_SAttackAnimation>;
	private var isActive : bool;
	
	default isActive = true;
	
	public function GetIsActive() : bool
	{
		return isActive;
	}
	
	public function SetIsActive( b : bool )
	{
		isActive = b;
	}
	
	public function Init()
	{
		var animArray : array<ACS_SAttackAnimation>;
		
		// ----- Light Attacks ----- //
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_5_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_1_rp_40ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_6_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_4_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_2_rp_40ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_1_rp_40ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_5_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_4_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_6_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_5_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_1_rp_40ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_6_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_2_rp_40ms', false, 1, -1));
		
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_3_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_2_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_1_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_5_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_1_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_2_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_3_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_fast_5_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_3_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_2_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_1_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_2_lp_40ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_fast_1_lp_40ms', false, 0, -1));
		CreateComboArray(animArray, fastAttacks);
		
		CreateLink(0, 13, fastAttacks);
		CreateLink(1, 14, fastAttacks);
		CreateLink(2, 15, fastAttacks);
		CreateLink(3, 16, fastAttacks);
		CreateLink(4, 17, fastAttacks);
		CreateLink(5, 18, fastAttacks);
		CreateLink(6, 19, fastAttacks);
		CreateLink(7, 20, fastAttacks);
		CreateLink(8, 21, fastAttacks);
		CreateLink(9, 22, fastAttacks);
		CreateLink(10, 23, fastAttacks);
		CreateLink(11, 24, fastAttacks);
		CreateLink(12, 25, fastAttacks);
		
		CreateLink(13, 1, fastAttacks);
		CreateLink(14, 2, fastAttacks);
		CreateLink(15, 3, fastAttacks);
		CreateLink(16, 4, fastAttacks);
		CreateLink(17, 5, fastAttacks);
		CreateLink(18, 6, fastAttacks);
		CreateLink(19, 7, fastAttacks);
		CreateLink(20, 8, fastAttacks);
		CreateLink(21, 9, fastAttacks);
		CreateLink(22, 10, fastAttacks);
		CreateLink(23, 11, fastAttacks);
		CreateLink(24, 12, fastAttacks);
		CreateLink(25, 0, fastAttacks);
		
		animArray.Clear();
		
		// ----- Strong Attacks ----- //
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_5_rp_ACS', true, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_4_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_4_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_2_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_3_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_4_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_3_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_4_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_1_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_4_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_5_rp_ACS', true, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_4_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_2_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_3_rp_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_4_rp_70ms', false, 1, -1));
		
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_3_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_2_lp_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_2_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_10_lp_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_1_lp_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_3_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_3_lp_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_2_lp_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_2_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_10_lp_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_3_lp_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_3_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_1_lp_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('geralt_attack_strong_2_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_geralt_sword_attack_strong_3_lp_70ms', false, 0, -1));
		CreateComboArray(animArray, strongAttacks);
		
		CreateLink(0, 15, strongAttacks);
		CreateLink(1, 16, strongAttacks);
		CreateLink(2, 17, strongAttacks);
		CreateLink(3, 18, strongAttacks);
		CreateLink(4, 19, strongAttacks);
		CreateLink(5, 20, strongAttacks);
		CreateLink(6, 21, strongAttacks);
		CreateLink(7, 22, strongAttacks);
		CreateLink(8, 23, strongAttacks);
		CreateLink(9, 24, strongAttacks);
		CreateLink(10, 25, strongAttacks);
		CreateLink(11, 26, strongAttacks);
		CreateLink(12, 27, strongAttacks);
		CreateLink(13, 28, strongAttacks);
		CreateLink(14, 29, strongAttacks);
		
		CreateLink(15, 1, strongAttacks);
		CreateLink(16, 2, strongAttacks);
		CreateLink(17, 3, strongAttacks);
		CreateLink(18, 4, strongAttacks);
		CreateLink(19, 5, strongAttacks);
		CreateLink(20, 6, strongAttacks);
		CreateLink(21, 7, strongAttacks);
		CreateLink(22, 8, strongAttacks);
		CreateLink(23, 9, strongAttacks);
		CreateLink(24, 10, strongAttacks);
		CreateLink(25, 11, strongAttacks);
		CreateLink(26, 12, strongAttacks);
		CreateLink(27, 13, strongAttacks);
		CreateLink(28, 14, strongAttacks);
		CreateLink(29, 0, strongAttacks);
		
		animArray.Clear();
		
		// ----- Fast Fist Attacks ----- //
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_close_combo_attack_5', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_close_combo_attack_2', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_close_combo_attack_5', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_close_combo_attack_2', false, 1, -1));
		
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_close_combo_attack_4', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_close_combo_attack_1', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_close_combo_attack_6', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_close_combo_attack_3', false, 0, -1));
		CreateComboArray(animArray, fastAttacksFist);
		
		CreateLink(0, 4, fastAttacksFist);
		CreateLink(1, 5, fastAttacksFist);
		CreateLink(2, 6, fastAttacksFist);
		CreateLink(3, 7, fastAttacksFist);
		
		CreateLink(4, 1, fastAttacksFist);
		CreateLink(5, 2, fastAttacksFist);
		CreateLink(6, 3, fastAttacksFist);
		CreateLink(7, 0, fastAttacksFist);
		
		animArray.Clear();
		
		// ----- Strong Fist Attacks ----- //
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_attack_heavy_2_rh_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_attack_heavy_1_rh_70ms', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_attack_heavy_2_rh_70ms', false, 0, -1));
		
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_attack_heavy_1_lh_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_attack_heavy_4_ll_70ms', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_fistfight_attack_heavy_2_lh_70ms', false, 1, -1));
		CreateComboArray(animArray, strongAttacksFist);
		
		CreateLink(0, 3, strongAttacksFist);
		CreateLink(1, 4, strongAttacksFist);
		CreateLink(2, 5, strongAttacksFist);
		
		CreateLink(3, 1, strongAttacksFist);
		CreateLink(4, 2, strongAttacksFist);
		CreateLink(5, 0, strongAttacksFist);
		
		animArray.Clear();
		
		// ----- Secondary Weapon Attacks ----- //
		animArray.PushBack((ACS_SAttackAnimation)('man_npc_2haxe_attack_01_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_npc_2haxe_attack_02_rp_ACS', false, 1, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_npc_2haxe_attack_03_rp_ACS', true, 1, -1));
		
		animArray.PushBack((ACS_SAttackAnimation)('man_npc_2haxe_attack_01_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_npc_2haxe_attack_02_lp_ACS', false, 0, -1));
		animArray.PushBack((ACS_SAttackAnimation)('man_npc_2haxe_attack_03_lp_ACS', false, 0, -1));
		CreateComboArray(animArray, secondaryAttacks);
		
		CreateLink(0, 3, secondaryAttacks);
		CreateLink(1, 4, secondaryAttacks);
		CreateLink(2, 5, secondaryAttacks);
		
		CreateLink(3, 1, secondaryAttacks);
		CreateLink(4, 2, secondaryAttacks);
		CreateLink(5, 0, secondaryAttacks);
		
		animArray.Clear();
	}
	
	protected var isStanceSwitched : bool; default isStanceSwitched = false;
	public function SetStanceSwitched( b : bool )
	{
		isStanceSwitched = b;
	}
	
	private var currIdx : int;
	protected function ChooseAttack( out currAttack : ACS_SAttackAnimation, arrayIndex : int )
	{
		var stance : float = thePlayer.GetCombatIdleStance();
		var arrayHandle : array<ACS_SAttackAnimation>;
		
		switch(arrayIndex)
		{
			case 1:	arrayHandle = fastAttacks;		 		break;
			case 2:	arrayHandle = strongAttacks;	 		break;
			case 3:	arrayHandle = fastAttacksFist;	 		break;
			case 4:	arrayHandle = strongAttacksFist;		break;
			case 5:	arrayHandle = secondaryAttacks;			break;
		}
		
		if( isStanceSwitched )
		{
			if( stance == 1 )
				stance = 0;
			else
				stance = 1;
		}
		
		if( IsValidAttack(currAttack) && HasLink(currAttack) )
		{
			currIdx = currAttack.linkedAnimIndex;
			currAttack = arrayHandle[currAttack.linkedAnimIndex];
			if( currAttack.stance != stance && arrayIndex != 4 )
			{
				currIdx = currAttack.linkedAnimIndex;
				currAttack = arrayHandle[currAttack.linkedAnimIndex];
			}
		}
		else currAttack = arrayHandle[RandRange(arrayHandle.Size(), 0)];
		isStanceSwitched = currAttack.isStanceSwitched;
	}
	
	protected function ResetAttack( out attack : ACS_SAttackAnimation )
	{
		attack.animName = '';
		attack.linkedAnimIndex = -1;
	}
	
	private function IsValidAttack( attack : ACS_SAttackAnimation ) : bool
	{
		return attack.animName != '';
	}
	
	private function HasLink( attack : ACS_SAttackAnimation ) : bool
	{
		return attack.linkedAnimIndex > -1;
	}
	
	private function CreateComboArray( animArray : array<ACS_SAttackAnimation>, out arrayHandle : array<ACS_SAttackAnimation> )
	{
		var attackAnim : ACS_SAttackAnimation;
		var i : int;
		
		for(i=0; i<animArray.Size(); i+=1)
		{
			attackAnim.animName = animArray[i].animName;
			attackAnim.isStanceSwitched = animArray[i].isStanceSwitched;
			attackAnim.stance = animArray[i].stance;
			attackAnim.linkedAnimIndex = -1;
			arrayHandle.PushBack(attackAnim);
		}
	}
	
	private function CreateLink( animIndex1, animIndex2 : int, out arrayHandle : array<ACS_SAttackAnimation> )
	{
		arrayHandle[animIndex1].linkedAnimIndex = animIndex2;
	}
}

class ACS_W3ComboDefinition extends ACS_W3ComboSystemExtender
{
	protected var currentLightAttack : ACS_SAttackAnimation;
	protected var currentHeavyAttack : ACS_SAttackAnimation;
	protected var currentLightAttackFist : ACS_SAttackAnimation;
	protected var currentHeavyAttackFist : ACS_SAttackAnimation;
	protected var currentSecondaryAttack : ACS_SAttackAnimation;
	protected var comboDefinition : CComboDefinition;
	
	public function Init()
	{
		super.Init();
		super.SetIsActive(true);
		comboDefinition = new CComboDefinition in this;
	}
	
	public function GetComboDefinition() : CComboDefinition
	{
		return comboDefinition;
	}
	
	public function SetStanceSwitched( b : bool )
	{
		super.SetStanceSwitched(b); 
	}
	
	public function ShouldSwitchIdleAnim( wasLightAttack : bool ) : bool
	{
		return false;
		if( wasLightAttack )
		{
			switch(currentLightAttack.animName)
			{
				case 'geralt_attack_fast_4_rp_ACS':
				case 'geralt_attack_fast_5_rp_ACS':
				case 'geralt_attack_fast_6_rp_ACS':
				case 'geralt_attack_fast_5_lp_ACS':
				case 'geralt_attack_fast_7_lp_ACS':
				case 'geralt_attack_fast_7_rp_ACS':
				case 'geralt_attack_fast_5_rp_ACS':
					return true;
				
				default : return false;
			}
		}
		
		return false;
	}
	
	private function CreateRealisticAttackAspectLight()
	{
		var aspect 		: CComboAspect;
		var str 		: CComboString;
		
		ChooseAttack(currentLightAttack, 1);
		
		aspect = comboDefinition.CreateComboAspect('AttackLightReal');
		{
			str = aspect.CreateComboString(false);
			
			str.AddDirAttack( currentLightAttack.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_back_1_rp_40ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_1_rp_40ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_2_rp_40ms', AD_Right, ADIST_Small );			
			
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_2_rp_50ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_1_rp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_2_rp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_3_rp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_forward_1_rp_50ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_1_rp_50ms', AD_Right, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_2_rp_50ms', AD_Right, ADIST_Medium );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_2_rp_50ms_mod_ACS', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_1_rp_50ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_2_rp_50ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_3_rp_50ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_forward_1_rp_50ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_1_rp_50ms_mod_ACS', AD_Right, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_2_rp_50ms', AD_Right, ADIST_Large );				
			
			str.AddAttack( currentLightAttack.animName, ADIST_Small );
		}
		{
			str = aspect.CreateComboString(true);
			
			str.AddDirAttack( currentLightAttack.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_back_1_lp_40ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_2_lp_40ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_right_1_lp_40ms', AD_Right, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_1_lp_50ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_1_lp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_2_lp_50ms', AD_Back, ADIST_Medium );			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_2_lp_50ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_1_lp_50ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_2_lp_50ms', AD_Right, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_1_lp_50ms', AD_Right, ADIST_Medium );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_1_lp_50ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_1_rp_50ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_2_rp_50ms_mod_ACS', AD_Back, ADIST_Large );			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_2_lp_50ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_1_lp_50ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_2_lp_50ms', AD_Right, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_1_lp_50ms', AD_Right, ADIST_Large );
			
			str.AddAttack( currentLightAttack.animName, ADIST_Small );
		}
	}
	
	private function CreateRealisticAttackAspectHeavy()
	{
		var aspect : CComboAspect;
		var str : CComboString;
		
		ChooseAttack(currentHeavyAttack, 2);
		
		aspect = comboDefinition.CreateComboAspect('AttackHeavyReal');
		{
			str = aspect.CreateComboString(false);
			
			str.AddDirAttack( currentHeavyAttack.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_strong_10_rp_70ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_left_1_lp_70ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_right_1_rp_70ms', AD_Right, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_left_1_rp_80ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_back_1_rp_80ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_forward_1_rp_80ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_right_1_rp_80ms', AD_Right, ADIST_Medium );			
			
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_left_1_rp_80ms_mod_ACS', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_back_1_rp_80ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_forward_1_rp_80ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_right_1_rp_80ms_mod_ACS', AD_Right, ADIST_Large );			
			
			str.AddAttack( currentHeavyAttack.animName, ADIST_Small );
		}
		{
			str = aspect.CreateComboString(true);
			
			str.AddDirAttack( currentHeavyAttack.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_strong_8_lp_70ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_left_1_lp_70ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_right_1_lp_70ms', AD_Right, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_forward_1_lp_80ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_back_1_lp_80ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_left_1_lp_80ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_right_1_lp_80ms', AD_Right, ADIST_Medium );			
			
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_forward_1_lp_80ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_back_1_lp_80ms', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_left_1_lp_80ms_mod_ACS', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_strong_far_right_1_lp_80ms', AD_Right, ADIST_Large );			
			
			str.AddAttack( currentHeavyAttack.animName, ADIST_Small );
		}
	}
	
	private function CreateRealisticAttackAspectFistLight()
	{
		var aspect : CComboAspect;
		var str : CComboString;
		
		ChooseAttack(currentLightAttackFist, 3);
		
		aspect = comboDefinition.CreateComboAspect('AttackFistFast');
		{
			str = aspect.CreateComboString(false);
			
			str.AddDirAttack( currentLightAttackFist.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_fistfight_attack_fast_2_rh_40ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_fistfight_attack_fast_left_1_rh_40ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_fistfight_attack_fast_right_1_rh_40ms', AD_Right, ADIST_Small );
			
			str.AddDirAttack( 'man_fistfight_attack_fast_far_forward_1_rh_50ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_forward_2_rh_50ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_back_1_rh_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_left_1_rh_50ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_right_1_rh_50ms', AD_Right, ADIST_Medium );			
			
			str.AddDirAttack( 'man_fistfight_attack_fast_far_forward_1_rh_50ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_forward_2_rh_50ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_back_1_rh_50ms', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_left_1_rh_50ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_right_1_rh_50ms', AD_Right, ADIST_Large );			
			
			str.AddAttack( currentLightAttackFist.animName, ADIST_Small );
		}
		{
			str = aspect.CreateComboString(true);
			
			str.AddDirAttack( currentLightAttackFist.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_fistfight_attack_fast_2_rh_40ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_fistfight_attack_fast_left_1_rh_40ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_fistfight_attack_fast_right_1_rh_40ms', AD_Right, ADIST_Small );
			
			str.AddDirAttack( 'man_fistfight_attack_fast_far_forward_2_rh_50ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_forward_1_rh_50ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_back_1_rh_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_left_1_rh_50ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_right_1_rh_50ms', AD_Right, ADIST_Medium );			
			
			str.AddDirAttack( 'man_fistfight_attack_fast_far_forward_2_rh_50ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_forward_1_rh_50ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_back_1_rh_50ms', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_left_1_rh_50ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_fast_far_right_1_rh_50ms', AD_Right, ADIST_Large );			
			
			str.AddAttack( currentLightAttackFist.animName, ADIST_Small );
		}
	}
	
	private function CreateRealisticAttackAspectFistHeavy()
	{
		var aspect : CComboAspect;
		var str : CComboString;
		
		ChooseAttack(currentHeavyAttackFist, 4);
		
		aspect = comboDefinition.CreateComboAspect('AttackFistHeavy');
		{
			str = aspect.CreateComboString(false);
			
			str.AddDirAttack( currentHeavyAttackFist.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_fistfight_attack_heavy_back_1_rh_70ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_fistfight_attack_heavy_left_1_rh_70ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_fistfight_attack_heavy_right_1_lh_70ms', AD_Right, ADIST_Small );
			
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_2_ll_80ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_1_rh_80ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_back_1_rh_80ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_left_1_rh_80ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_right_1_rh_80ms', AD_Right, ADIST_Medium );		
			
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_2_ll_80ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_1_rh_80ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_back_1_rh_80ms', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_left_1_rh_80ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_right_1_rh_80ms', AD_Right, ADIST_Large );		
			
			str.AddAttack( currentHeavyAttackFist.animName, ADIST_Small );
		}
		{
			str = aspect.CreateComboString(true);
			
			str.AddDirAttack( currentHeavyAttackFist.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_fistfight_attack_heavy_back_1_rh_70ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_fistfight_attack_heavy_left_1_rh_70ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_fistfight_attack_heavy_right_1_lh_70ms', AD_Right, ADIST_Small );
			
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_1_rh_80ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_2_ll_80ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_back_1_rh_80ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_left_1_rh_80ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_right_1_rh_80ms', AD_Right, ADIST_Medium );
			
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_1_rh_80ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_2_ll_80ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_back_1_rh_80ms', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_left_1_rh_80ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_fistfight_attack_heavy_far_right_1_rh_80ms', AD_Right, ADIST_Large );
			
			str.AddAttack( currentHeavyAttackFist.animName, ADIST_Small );
		}
	}
	
	private function CreateAttackAspectSecondaryLight()
	{
		var aspect 		: CComboAspect;
		var str 		: CComboString;
		
		ChooseAttack(currentSecondaryAttack, 5);
		
		aspect = comboDefinition.CreateComboAspect('AttackLightSecondary');
		{
			str = aspect.CreateComboString(false);
			
			str.AddDirAttack( currentSecondaryAttack.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_back_1_lp_40ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_1_rp_40ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_2_rp_40ms', AD_Right, ADIST_Small );
			
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_forward_1_rp_50ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_1_rp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_2_rp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_3_rp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_2_rp_50ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_1_rp_50ms', AD_Right, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_2_rp_50ms', AD_Right, ADIST_Medium );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_forward_1_rp_50ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_1_rp_50ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_2_rp_50ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_3_rp_50ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_2_rp_50ms_mod_ACS', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_1_rp_50ms_mod_ACS', AD_Right, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_2_rp_50ms', AD_Right, ADIST_Large );		
			
			str.AddAttack( currentSecondaryAttack.animName, ADIST_Small );
		}
		{
			str = aspect.CreateComboString(true);
			
			str.AddDirAttack( currentSecondaryAttack.animName, AD_Front, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_back_1_lp_40ms', AD_Back, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_2_lp_40ms', AD_Left, ADIST_Small );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_right_1_lp_40ms', AD_Right, ADIST_Small );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_forward_1_lp_50ms', AD_Front, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_1_lp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_2_lp_50ms', AD_Back, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_2_lp_50ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_1_lp_50ms', AD_Left, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_1_lp_50ms', AD_Right, ADIST_Medium );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_2_lp_50ms', AD_Right, ADIST_Medium );
			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_forward_1_lp_50ms', AD_Front, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_1_rp_50ms_mod_ACS', AD_Back, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_back_2_rp_50ms_mod_ACS', AD_Back, ADIST_Large );			
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_2_lp_50ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_left_1_lp_50ms', AD_Left, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_1_lp_50ms_mod_ACS', AD_Right, ADIST_Large );
			str.AddDirAttack( 'man_geralt_sword_attack_fast_far_right_2_lp_50ms', AD_Right, ADIST_Large );
			
			str.AddAttack( currentSecondaryAttack.animName, ADIST_Small );
		}
	}
	
	public function Update( attackType : name, fistAnim : bool )
	{
		if( attackType == theGame.params.ATTACK_NAME_LIGHT )
		{
			if( !fistAnim )
			{
				if( IsUsingSecondaryWeapon() )
				{
					comboDefinition.DeleteComboAspect('AttackLightSecondary');
					CreateAttackAspectSecondaryLight();
				}
				else
				{
					comboDefinition.DeleteComboAspect('AttackLightReal');
					CreateRealisticAttackAspectLight();
				}
			}
			else
			{
				comboDefinition.DeleteComboAspect('AttackFistFast');
				CreateRealisticAttackAspectFistLight();
			}
		}
		else
		{
			if( !fistAnim )
			{
				comboDefinition.DeleteComboAspect('AttackHeavyReal');
				CreateRealisticAttackAspectHeavy();
			}
			else
			{
				comboDefinition.DeleteComboAspect('AttackFistHeavy');
				CreateRealisticAttackAspectFistHeavy();
			}
		}
	}
	
	public function IsUsingSecondaryWeapon() : bool
	{
		var inv : CInventoryComponent = GetWitcherPlayer().GetInventory();
		
		return inv.ItemHasTag(inv.GetItemFromSlot('r_weapon'), 'SecondaryWeapon');
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////////

struct acslootconfig
{
	var global_range			: float;
	var plant_range				: float;
	var remains_range			: float;
	var clutter_range			: float;
	var max_results				: int;
	var allow_theft				: bool;
	var los_scan				: bool;
	var segregate_types			: bool;
	var no_reactions			: bool;
}

class acsAoELoot
{	
	public var inventories	 			: array<CInventoryComponent>;   
	public var sorted_inventories		: array<CInventoryComponent>;	
	private var _containers 			: array<W3Container>;           
	private var opts					: acslootconfig;
	private const var obstacles			: array<name>;	default obstacles = {'Terrain', 'Static'};

	public function initialize (container : W3Container)
	{
		var config : CInGameConfigWrapper = theGame.GetInGameConfigWrapper();
		
		opts.los_scan = config.GetVarValue('spectreLootingOptions', 'spectreLootLos');
		opts.segregate_types = true;
		opts.allow_theft =  config.GetVarValue('spectreLootingOptions', 'spectreLootTheft');
		opts.no_reactions = config.GetVarValue('spectreLootingOptions', 'spectreLootReactions');
		opts.global_range = StringToFloat(config.GetVarValue('spectreLootingOptions', 'spectreLootGlobalRange') );
		opts.plant_range = StringToFloat(config.GetVarValue('spectreLootingOptions', 'spectreLootPlantRange') );
		opts.remains_range = StringToFloat(config.GetVarValue('spectreLootingOptions', 'spectreLootRemainsRange') );
		opts.clutter_range = StringToFloat(config.GetVarValue('spectreLootingOptions', 'spectreLootClutterRange') );
		opts.max_results = StringToInt(config.GetVarValue('spectreLootingOptions', 'spectreLootMaxResults') );

		getInventoriesInRange(container, inventories);
		obtainContainers();
	}

	public function takeAllItems() : void
	{	
		var idx : int = _containers.Size();

		for (idx = idx - (int)(bool)idx; idx >= 0; idx -= 1)
		{	
			_containers[idx].TakeAllItems();
			
			if (_containers[idx].IsEmpty())
			{
				_containers[idx].OnContainerClosed();
				_containers[idx].Enable(false);
			}
		}
	}

    public function getContainersItemCount (containers : array<CInventoryComponent>) : int
	{	
		var contents			: array<SItemUniqueId>;
		var idx					: int;
		var item_count, i		: int;

		for (idx = containers.Size() - 1; idx >= 0; idx -= 1)
		{	
			containers[idx].GetAllItems(contents);

			for(i = contents.Size() - 1; i >= 0; i -= 1)
			{
				item_count += (int)(!containers[idx].ItemHasTag(contents[i], theGame.params.TAG_DONT_SHOW) );
			}	
		}
		return (item_count);
	}
	
	private function obtainContainers()
	{	
		var idx : int;

		_containers.Resize(inventories.Size() );

		for (idx = inventories.Size() - 1; idx >= 0; idx -= 1)
		{
			_containers[idx] = ((W3Container)inventories[idx].GetEntity() );
		}
			
	}

	private function getContainerType (container : CEntity) : name
	{
		if (!opts.segregate_types)
		{
			return ('W3Container');
		}	
		else if ((W3Herb)container)
		{
			return ('W3Herb');
		}
		else if ((W3ActorRemains)container)
		{
			return ('W3ActorRemains');
		}
		else if ((W3AnimatedContainer)container)
		{
			return ('W3AnimatedContainer');
		}
		else if ((CBeehiveEntity)container)
		{
			return ('CBeehiveEntity');
		}
		else 
		{
			return ('');
		}
	}	
	
	private function getScanRange (type : name) : float
	{
		if (!opts.segregate_types)
		{
			return (opts.global_range);
		}
			
		switch (type)
		{	
			case 'W3Herb':
			return (opts.plant_range);

			case 'W3ActorRemains':
			return (opts.remains_range);

			case 'W3AnimatedContainer':
			return (opts.clutter_range);

			default:
			return (opts.global_range);
		}
	}

	private function getInventoriesInRange (initial : W3Container, out container_inventories : array<CInventoryComponent>) : void
	{	
		var entities			: array<CGameplayEntity>;
		var container_inventory	: CInventoryComponent;
		var container_entity	: CEntity;
		var container			: W3Container;
		var cont_type			: name = getContainerType(initial);
		var i					: int;

		if ((bool)cont_type && opts.max_results > 1)
		{	
			FindGameplayEntitiesInRange(entities, thePlayer, getScanRange(cont_type), opts.max_results,, FLAG_ExcludePlayer,, cont_type);
			
			for (i = entities.Size() - 1; i >= 0; i -= 1)
			{	
				container_entity = (CEntity)entities[i];
				
				container = (W3Container)container_entity;

				if ((!opts.allow_theft && !container.disableStealing) || container.lockedByKey ||
				container.focusModeHighlight == FMV_Clue || container.factOnContainerOpened != "" ||
				container.HasQuestItem() ||	container.disableLooting ||	!container.GetComponent('Loot').IsEnabled() ||
				(opts.los_scan && !getLos(container) ) )
				{
					continue;
				}
						
				container_inventory = entities[i].GetInventory();

				if (container_inventory.GetItemCount() > 0)
				{
					container_inventories.PushBack(container_inventory);

					if (cont_type == 'W3Herb')
					{
						((W3Herb)entities[i]).OnInteractionActivated("", thePlayer);
					}
				}
					
			}
		}

		container_inventory = initial.GetInventory();

		i = container_inventories.FindLast(container_inventory);

		if (i != container_inventories.Size() -1 || i == -1)
		{	
			container_inventories.Erase(i * (int)(i > 0) );
			container_inventories.PushBack(container_inventory);
		}
	}

	private function getLos (target : CEntity) : bool
	{
		var origin		: Vector = thePlayer.GetWorldPosition();
		var destination	: Vector = target.GetWorldPosition();
		var unused		: Vector;
		var obstructed	: bool;
		var collision	: CComponent;
		var mat			: name;
		var z_increment	: float;
		var bbox		: Box;

		origin.Z += ((CMovingPhysicalAgentComponent)thePlayer.GetMovingAgentComponent() ).GetCapsuleHeight() * 0.9f;

		destination.Z += (float)(int)(bool)((W3Herb)target);

		obstructed = theGame.GetWorld().StaticTraceWithAdditionalInfo(origin, destination, unused, unused, mat, collision, obstacles);

		if (obstructed)
		{	
			obstructed = (!collision || collision.GetEntity() != target);

			if (obstructed)
			{	
				target.CalcBoundingBox(bbox);

				z_increment = (bbox.Max.Z - bbox.Min.Z) * 0.25f;

				if (z_increment)
				{
					while (obstructed && destination.Z < bbox.Max.Z)
					{	destination.Z += z_increment;
						obstructed = theGame.GetWorld().StaticTrace(origin, destination, unused, unused, obstacles);
					}
				}
			}
		}

		return (!obstructed);
	}
}

function ACS_VladShowJournalUpdate(m_fxShowJournalUpdateSFF : CScriptedFlashFunction, isTrackableQuest : bool, journalUpdates : array< SJournalUpdate>)
{
	var padCode, label : string;
	var outKeys, outKeysPC : array<EInputKey>;
	
	label = "";
	padCode = "";
	
	if( isTrackableQuest && ( theInput.GetContext() != 'Scene' ) && ( journalUpdates[0].journalEntry || IsNameValid( journalUpdates[0].entryTag ) && !thePlayer.IsCiri() ) )
	{				
		label = "[[panel_button_journal_track]]";
		padCode = "gamepad_R_Hold";
		
		theInput.GetPadKeysForAction( 'TrackQuest' ,outKeys );
		theInput.GetPCKeysForAction( 'TrackQuest' ,outKeysPC );
	}
	
	if (outKeysPC.Size() <= 0)
	{
		outKeysPC.PushBack(-1);
	}
	
	m_fxShowJournalUpdateSFF.InvokeSelfEightArgs( 
	FlashArgString("<font size='20' letterSpacing='0.000000' kerning='0'>" + journalUpdates[0].text + "</font>"), 
	FlashArgString("<font size='18' letterSpacing='0.000000' kerning='0'>"+ journalUpdates[0].title + "</font>"), 
	FlashArgNumber(journalUpdates[0].displayTime),
	FlashArgString(label),
	FlashArgString(padCode),
	FlashArgInt(outKeysPC[0]),
	FlashArgBool( (CJournalQuest)journalUpdates[0].journalEntry ),
	FlashArgBool( theGame.GetInGameConfigWrapper().GetVarValue('vlad', 'lvlupinfo') )
	);
}

function ACS_ReplacingBetterIcons(optional itemName : name, optional effectType : EEffectType, optional buffLevel : int, optional withNames : bool):string
{
	var iconPath : string;
	var noLevelsItem, DDSIcon, noTW2icon : bool;
	
	noLevelsItem = false;
	DDSIcon = false;
	noTW2icon = false;
	
	//Potions
	if(theGame.GetDefinitionsManager().GetItemCategory(itemName) == 'potion'
	|| theGame.GetDefinitionsManager().ItemHasTag(itemName, 'Potion')
	|| ((CBaseGameplayEffect)GetWitcherPlayer().GetBuff(effectType)).IsPotionEffect())
	{
		if(StrContains(itemName, "Black Blood") || effectType == EET_BlackBlood)
			iconPath = "bettericons/potions/black_blood";
		
		if(StrContains(itemName, "Blizzard") || effectType == EET_Blizzard)
			iconPath = "bettericons/potions/blizzard";
		
		if(StrContains(itemName, "Cat") || effectType == EET_Cat)
			iconPath = "bettericons/potions/cat";
		
		if(StrContains(itemName, "Full Moon") || effectType == EET_FullMoon)
			iconPath = "bettericons/potions/full_moon";
		
		if(StrContains(itemName, "Golden Oriole") || effectType == EET_GoldenOriole)
			iconPath = "bettericons/potions/golden_oriole";

		if(StrContains(itemName, "Killer Whale") || effectType == EET_KillerWhale)
			iconPath = "bettericons/potions/tiara";
		
		if(StrContains(itemName, "Maribor Forest") || effectType == EET_MariborForest)
			iconPath = "bettericons/potions/maribor_forest";
			
		if(StrContains(itemName, "Petri Philtre") || effectType == EET_PetriPhiltre)
			iconPath = "bettericons/potions/petris_philtre";

		if(StrContains(itemName, "Pheromone Potion Bear") || effectType == EET_PheromoneBear)
			iconPath = "bettericons/potions/pheromone_bear";

		if(StrContains(itemName, "Pheromone Potion Drowner") || effectType == EET_PheromoneDrowner)
			iconPath = "bettericons/potions/pheromone_drowner";

		if(StrContains(itemName, "Pheromone Potion Nekker") || effectType == EET_PheromoneNekker)
			iconPath = "bettericons/potions/pheromone_nekker";
		
		if(StrContains(itemName, "Swallow") || effectType == EET_Swallow)
			iconPath = "bettericons/potions/healing_potion";
		
		if(StrContains(itemName, "Tawny Owl") || effectType == EET_TawnyOwl)
			iconPath = "bettericons/potions/tawny_owl";
		
		if(StrContains(itemName, "Thunderbolt") || effectType == EET_Thunderbolt)
			iconPath = "bettericons/potions/thunderbolt";
		
		if(StrContains(itemName, "White Honey") || effectType == EET_WhiteHoney)
			iconPath = "bettericons/potions/white_honey";

		if(StrContains(itemName, "White Raffards Decoction") || effectType == EET_WhiteRaffardDecoction)
			iconPath = "bettericons/potions/white_raffard";


		//Restored Content - Additional Potions
		if(StrContains(itemName, "Devries"))
			iconPath = "bettericons/potions/de_vries_extract";

		if(StrContains(itemName, "Tiara"))
			iconPath = "bettericons/potions/tiara_new";

		if(StrContains(itemName, "Virga"))
			iconPath = "bettericons/potions/ico_healing_potion";

		if(StrContains(itemName, "Willow"))
			iconPath = "bettericons/potions/florence_flask_with_water";
	}
	
	//Potions  (no levels)
	if(itemName == 'Pops Antidote')
		{iconPath = "bettericons/potions/pop_mold_antidote"; noLevelsItem = true;}

	if(itemName == 'Clearing Potion')
		{iconPath = "bettericons/potions/ico_mutagen_potion_20"; noLevelsItem = true;}

	if(itemName == 'Restoring Potion')
		{iconPath = "bettericons/potions/restoring_potion"; noLevelsItem = true;}

	if(itemName == 'Signs Enhancement' || itemName == 'ReinaldsPhiltre')
		{iconPath = "bettericons/potions/reinalds_philtre_potion"; noLevelsItem = true;}

	if(itemName == 'Wolf Hour')
		{iconPath = "bettericons/potions/stats_elixir"; noLevelsItem = true;}

	//Restored Content - Additional Potions (no levels)
	if(itemName == 'Tirnalia potion')
		{iconPath = "bettericons/potions/tir_na_lia_potion"; noLevelsItem = true;}
	
	
	//Bombs
	if(theGame.GetDefinitionsManager().GetItemCategory(itemName) == 'petard')
	{
		if(StrContains(itemName, "Dancing Star"))
			iconPath = "bettericons/bombs/dancing_star_bomb";
		
		if(StrContains(itemName, "Devils Puffball"))
			iconPath = "bettericons/bombs/devils_puffball_bomb";
		
		if(StrContains(itemName, "Dragons Dream"))
			iconPath = "bettericons/bombs/dragons_dream_bomb";
		
		if(StrContains(itemName, "Grapeshot"))
			iconPath = "bettericons/bombs/grapeshot_bomb";
		
		if(StrContains(itemName, "Samum"))
			iconPath = "bettericons/bombs/samun_bomb";
		
		if(StrContains(itemName, "Silver Dust Bomb"))
			iconPath = "bettericons/bombs/silver_dust_bomb";
		
		if(StrContains(itemName, "White Frost"))
			iconPath = "bettericons/bombs/white_frost_bomb";
		
		if(StrContains(itemName, "Dwimeritium Bomb"))
			iconPath = "bettericons/bombs/dwimeritium_bomb";

		//Ard Bombs
		if(StrContains(itemName, "Fungi Bomb"))
			iconPath = "bettericons/bombs/fungi_bomb";
		
		if(StrContains(itemName, "Glue Bomb"))
			iconPath = "bettericons/bombs/glue_bomb";
		
		if(StrContains(itemName, "Salt Bomb"))
			iconPath = "bettericons/bombs/salt_bomb";
		
		if(StrContains(itemName, "Shrapnel Bomb"))
			iconPath = "bettericons/bombs/shrapnel_bomb";

		if(StrContains(itemName, "Virus Bomb"))
			iconPath = "bettericons/bombs/virus_bomb";
	}
	
	
	//Oils
	if(theGame.GetDefinitionsManager().GetItemCategory(itemName) == 'oil')
	{
		if(StrContains(itemName, "Beast Oil"))
			iconPath = "bettericons/oils/beast_oil";

		if(StrContains(itemName, "Cursed Oil"))
			iconPath = "bettericons/oils/cursed_oil";

		if(StrContains(itemName, "Draconide Oil"))
			iconPath = "bettericons/oils/draconide_oil";

		if(StrContains(itemName, "Hanged Man Venom"))
			iconPath = "bettericons/oils/hanged_man's_venom";

		if(StrContains(itemName, "Hybrid Oil"))
			iconPath = "bettericons/oils/hybrid_oil";

		if(StrContains(itemName, "Insectoid Oil"))
			iconPath = "bettericons/oils/insectoid_oil";

		if(StrContains(itemName, "Magicals Oil"))
			iconPath = "bettericons/oils/magicals_oil";

		if(StrContains(itemName, "Necrophage Oil"))
			iconPath = "bettericons/oils/necrophage_oil";

		if(StrContains(itemName, "Ogre Oil"))
			iconPath = "bettericons/oils/ogre_oil";

		if(StrContains(itemName, "Relic Oil"))
			iconPath = "bettericons/oils/relic_oil";

		if(StrContains(itemName, "Specter Oil"))
			iconPath = "bettericons/oils/specter_oil";

		if(StrContains(itemName, "Vampire Oil"))
			iconPath = "bettericons/oils/vampire_oil";
	}
		
		
	//Decoctions
	if(itemName == 'Mutagen 1')
		iconPath = "bettericons/mutagen_potions/katakan_mutagen";

	if(itemName == 'Mutagen 2')
		iconPath = "bettericons/mutagen_potions/arachas_mutagen";

	if(itemName == 'Mutagen 3')
		iconPath = "bettericons/mutagen_potions/cockatrice_mutagen";

	if(itemName == 'Mutagen 4')
		iconPath = "bettericons/mutagen_potions/volcanic_gryphon";

	if(itemName == 'Mutagen 5')
		iconPath = "bettericons/mutagen_potions/water_hag_mutagen";

	if(itemName == 'Mutagen 6')
		iconPath = "bettericons/mutagen_potions/nightwraith_mutagen";

	if(itemName == 'Mutagen 7')
		iconPath = "bettericons/mutagen_potions/ekimma_mutagen";

	if(itemName == 'Mutagen 8')
		iconPath = "bettericons/mutagen_potions/czart_mutagen";

	if(itemName == 'Mutagen 9')
		iconPath = "bettericons/mutagen_potions/fogling_mutagen";

	if(itemName == 'Mutagen 10')
		iconPath = "bettericons/mutagen_potions/wyvern_mutagen";

	if(itemName == 'Mutagen 11')
		iconPath = "bettericons/mutagen_potions/doppler_mutagen";

	if(itemName == 'Mutagen 12')
		iconPath = "bettericons/mutagen_potions/troll_mutagen";

	if(itemName == 'Mutagen 13')
		iconPath = "bettericons/mutagen_potions/noonwraith_mutagen";

	if(itemName == 'Mutagen 14')
		iconPath = "bettericons/mutagen_potions/succubus_mutagen";

	if(itemName == 'Mutagen 15')
		iconPath = "bettericons/mutagen_potions/alghoul_mutagen";

	if(itemName == 'Mutagen 16')
		iconPath = "bettericons/mutagen_potions/fiend_mutagen";

	if(itemName == 'Mutagen 17')
		iconPath = "bettericons/mutagen_potions/forktail_mutagen";

	if(itemName == 'Mutagen 18')
		iconPath = "bettericons/mutagen_potions/grave_hag_mutagen";

	if(itemName == 'Mutagen 19')
		iconPath = "bettericons/mutagen_potions/wraith_mutagen";

	if(itemName == 'Mutagen 20')
		iconPath = "bettericons/mutagen_potions/d'ao_mutagen";

	if(itemName == 'Mutagen 21')
		iconPath = "bettericons/mutagen_potions/lamia_ekimma_mutagen";

	if(itemName == 'Mutagen 22')
		iconPath = "bettericons/mutagen_potions/ancient_leshy_mutagen";

	if(itemName == 'Mutagen 23')
		iconPath = "bettericons/mutagen_potions/basilisk_mutagen";

	if(itemName == 'Mutagen 24')
		iconPath = "bettericons/mutagen_potions/werewolf_mutagen";

	if(itemName == 'Mutagen 25')
		iconPath = "bettericons/mutagen_potions/nekker_warrior_mutagen";

	if(itemName == 'Mutagen 26')
		iconPath = "bettericons/mutagen_potions/leshy_mutagen";

	if(itemName == 'Mutagen 27')
		iconPath = "bettericons/mutagen_potions/griphon_mutagen";

	if(itemName == 'Mutagen 28')
		iconPath = "bettericons/mutagen_potions/quest_anti_spectre_mutagen";
	
	
	//Decoctions - Additional Alchemy
	if(itemName == 'Mutagen 29')
		iconPath = "bettericons/mutagen_potions/kikimore_mutagen";

	if(itemName == 'Mutagen 30')
		iconPath = "bettericons/mutagen_potions/wight_mutagen";

	if(itemName == 'Mutagen 31')
		iconPath = "bettericons/mutagen_potions/giant_centipede_mutagen";

	if(itemName == 'Mutagen 32')
		iconPath = "bettericons/mutagen_potions/slyzard_mutagen";

	if(itemName == 'Mutagen 33')
		iconPath = "bettericons/mutagen_potions/fleder_mutagen";

	if(itemName == 'Mutagen 34')
		iconPath = "bettericons/mutagen_potions/alp_mutagen";

	if(itemName == 'Mutagen 35')
		iconPath = "bettericons/mutagen_potions/barghest_mutagen";

	if(itemName == 'Mutagen 36')
		iconPath = "bettericons/mutagen_potions/spriggan_mutagen";

	if(itemName == 'Mutagen 37')
		iconPath = "bettericons/mutagen_potions/garkain_mutagen";

	if(itemName == 'Mutagen 38')
		iconPath = "bettericons/mutagen_potions/bruxa_mutagen";

	if(itemName == 'Mutagen 39')
		iconPath = "bettericons/mutagen_potions/archespore_mutagen";

	if(itemName == 'Mutagen 40')
		iconPath = "bettericons/mutagen_potions/shaelmaar_mutagen";

	if(itemName == 'Mutagen 41')
		iconPath = "bettericons/mutagen_potions/kayran_mutagen";

	if(itemName == 'Mutagen 42')
		iconPath = "bettericons/mutagen_potions/aguara_mutagen";

	if(itemName == 'Mutagen 43')
		iconPath = "bettericons/mutagen_potions/zeugl_mutagen";

	if(itemName == 'Mutagen 44')
		iconPath = "bettericons/mutagen_potions/manticore_mutagen";

	if(itemName == 'Mutagen 45')
		iconPath = "bettericons/mutagen_potions/frightener_mutagen";

	if(itemName == 'Mutagen 46')
		iconPath = "bettericons/mutagen_potions/ifrit_mutagen";

	if(itemName == 'Mutagen 47')
		iconPath = "bettericons/mutagen_potions/vran_mutagen";

	if(itemName == 'Mutagen 48')
		iconPath = "bettericons/mutagen_potions/vigilosaur_mutagen";

	if(itemName == 'Mutagen 49')
		iconPath = "bettericons/mutagen_potions/vodyanoi_mutagen";

	if(itemName == 'Mutagen 50')
		iconPath = "bettericons/mutagen_potions/striga_mutagen";

	if(itemName == 'Mutagen 51')
		iconPath = "bettericons/mutagen_potions/dragon_mutagen";

	if(itemName == 'Mutagen 52')
		iconPath = "bettericons/mutagen_potions/arachnomorph_mutagen";

	if(itemName == 'Mutagen 53')
		iconPath = "bettericons/mutagen_potions/sylvan_mutagen";

	if(itemName == 'Mutagen 54')
		iconPath = "bettericons/mutagen_potions/siren_mutagen";

	if(itemName == 'Mutagen 55')
		iconPath = "bettericons/mutagen_potions/harpy_mutagen";

	if(itemName == 'Mutagen 56')
		iconPath = "bettericons/mutagen_potions/erynia_mutagen";

	if(itemName == 'Mutagen 57')
		iconPath = "bettericons/mutagen_potions/gargoyle_mutagen";

	if(itemName == 'Mutagen 58')
		iconPath = "bettericons/mutagen_potions/cyclops_mutagen";

	if(itemName == 'Mutagen 59')
		iconPath = "bettericons/mutagen_potions/endrega_mutagen";
	
	
	//Upgrades - Runes & Glyphs
	if(theGame.GetDefinitionsManager().GetItemCategory(itemName) == 'upgrade')
	{
		if(StrContains(itemName, "Rune dazhbog"))
			iconPath = "bettericons/runes/rune_dazhbog";

		if(StrContains(itemName, "Rune devana"))
			iconPath = "bettericons/runes/rune_devana";

		if(StrContains(itemName, "Rune elemental"))
			iconPath = "bettericons/runes/rune_elemental";

		if(StrContains(itemName, "Rune morana"))
			iconPath = "bettericons/runes/rune_morana";

		if(StrContains(itemName, "Rune perun"))
			iconPath = "bettericons/runes/rune_perun";

		if(StrContains(itemName, "Rune stribog"))
			iconPath = "bettericons/runes/rune_stribog";

		if(StrContains(itemName, "Rune svarog"))
			iconPath = "bettericons/runes/rune_svarog";

		if(StrContains(itemName, "Rune triglav"))
			iconPath = "bettericons/runes/rune_triglav";

		if(StrContains(itemName, "Rune veles"))
			iconPath = "bettericons/runes/rune_veles";

		if(StrContains(itemName, "Rune zoria"))
			iconPath = "bettericons/runes/rune_zoria";

		if(StrContains(itemName, "Glyph aard"))
			iconPath = "bettericons/glyphs/glyph_aard";

		if(StrContains(itemName, "Glyph axii"))
			iconPath = "bettericons/glyphs/glyph_axii";

		if(StrContains(itemName, "Glyph binding"))
			iconPath = "bettericons/glyphs/glyph_binding";

		if(StrContains(itemName, "Glyph igni"))
			iconPath = "bettericons/glyphs/glyph_igni";

		if(StrContains(itemName, "Glyph mending"))
			iconPath = "bettericons/glyphs/glyph_mending";

		if(StrContains(itemName, "Glyph quen"))
			iconPath = "bettericons/glyphs/glyph_quen";

		if(StrContains(itemName, "Glyph reinforcement"))
			iconPath = "bettericons/glyphs/glyph_reinforcement";

		if(StrContains(itemName, "Glyph warding"))
			iconPath = "bettericons/glyphs/glyph_warding";

		if(StrContains(itemName, "Glyph yrden"))
			iconPath = "bettericons/glyphs/glyph_yrden";

	}
	
	//Upgrades - Runes & Glyphs - no levels
	if(itemName == 'Rune pierog')
		{iconPath = "bettericons/runes/runestone_pierog"; noLevelsItem = true;}
	
	if(itemName == 'Rune tvarog')
		{iconPath = "bettericons/runes/runestone_vatrog"; noLevelsItem = true;}
	
	
	//Signs
	if(itemName == 'Yrden')
		iconPath = "bettericons/signs/yrden";

	if(itemName == 'Quen')
		iconPath = "bettericons/signs/quen";

	if(itemName == 'Igni')
		iconPath = "bettericons/signs/igni";

	if(itemName == 'Axii')
		iconPath = "bettericons/signs/axii";

	if(itemName == 'Aard')
		iconPath = "bettericons/signs/aard";
	
	
	//Trophies
	if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActive') != "1"
	&& theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActiveTrophies') != "1")
	{
		if(itemName == 'mh301_gryphon_trophy')
			return "bettericons/trophies/trophy_gryphon_3_64x64.dds";
		
		if(itemName == 'sq108_griffin_trophy')
			return "bettericons/trophies/trophy_gryphon_2_64x64.dds";
		
		if(itemName == 'mh308_noonwraith_trophy')
			return "bettericons/trophies/trophy_noonwraith_2_64x64.dds";
		
		if(itemName == 'mh204_leshy_trophy')
			return "bettericons/trophies/trophy_lessun_2_64x64.dds";
		
		if(itemName == 'mq1051_wyvern_trophy')
			return "bettericons/trophies/trophy_wyvern_2_64x64.dds";
		
		if(itemName == 'mh304_katakan_trophy')
			return "bettericons/trophies/trophy_katakan_64x64.dds";
	}
	
	
	if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActive') != "1" &&
	((theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActivePotions') != "1" && StrContains(iconPath, "/potions/"))
	|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActiveBombs') != "1" && StrContains(iconPath, "/bombs/"))
	|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActiveOils') != "1" && StrContains(iconPath, "/oils/"))
	|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActiveDecoctions') != "1" && StrContains(iconPath, "/mutagen_potions/"))
	|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActiveRunes') != "1" && StrContains(iconPath, "/runes/"))
	|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActiveGlyphs') != "1" && StrContains(iconPath, "/glyphs/"))
	|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsGeneral', 'BetterIconsActiveSigns') != "1" && StrContains(iconPath, "/signs/"))
	))
	{
		if(!noLevelsItem && !StrContains(iconPath, "/mutagen_potions/") && !((W3Mutagen_Effect)GetWitcherPlayer().GetBuff(effectType)))
		{	
			if((theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSBombs') == "1" && StrContains(iconPath, "/bombs/"))
			|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSOils') == "1" && StrContains(iconPath, "/oils/"))
			|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSPotions') == "1" && StrContains(iconPath, "/potions/"))
			)
				{}
			else if((theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSBombs') == "2" && StrContains(iconPath, "/bombs/"))
			|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSOils') == "2" && StrContains(iconPath, "/oils/"))
			|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSPotions') == "2" && StrContains(iconPath, "/potions/"))
			)
				iconPath += "_enhanced";
			else if((theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSBombs') == "3" && StrContains(iconPath, "/bombs/"))
			|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSOils') == "3" && StrContains(iconPath, "/oils/"))
			|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'TIERSPotions') == "3" && StrContains(iconPath, "/potions/"))
			)
				iconPath += "_superior";
			else
			{
				if(StrContains(itemName, "2") || buffLevel == 2)
					iconPath += "_enhanced";
				if(StrContains(itemName, "3") || buffLevel == 3)
					iconPath += "_superior";
			}
			
			if((StrContains(iconPath, "/glyphs/") || StrContains(iconPath, "/runes/")))
			{
				if(StrContains(itemName, "greater"))
					iconPath += "_greater";
				if(StrContains(itemName, "lesser"))
					iconPath += "_lesser";
			}
		}
		
		if(withNames &&
		((theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsNames', 'WithNamesPotions') && StrContains(iconPath, "/potions/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsNames', 'WithNamesBombs') && StrContains(iconPath, "/bombs/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsNames', 'WithNamesOils') && StrContains(iconPath, "/oils/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsNames', 'WithNamesDecoctions') && StrContains(iconPath, "/mutagen_potions/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsNames', 'WithNamesRunes') && StrContains(iconPath, "/runes/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsNames', 'WithNamesGlyphs') && StrContains(iconPath, "/glyphs/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsNames', 'WithNamesSigns') && StrContains(iconPath, "/signs/"))
		))
		{
			if(GetCurrentTextLocCode() == "AR")
			{
				iconPath += "_AR_Almarai";
			}
			else if(GetCurrentTextLocCode() == "BR")
			{
				iconPath += "_BR_DINPro";
			}
			else if(GetCurrentTextLocCode() == "CN")
			{
				iconPath += "_CN_Heiti";
			}
			else if(GetCurrentTextLocCode() == "CZ")
			{
				iconPath += "_CZ_DINPro";
			}
			else if(GetCurrentTextLocCode() == "DE")
			{
				iconPath += "_DE_DINPro";
			}
			else if(GetCurrentTextLocCode() == "ES" || GetCurrentTextLocCode() == "ESMX")
			{
				iconPath += "_ES";
				if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsFonts', 'SpanishFonts') == "1")
					iconPath += "_Nosferatu_HeP";
				else if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsFonts', 'SpanishFonts') == "2")
					iconPath += "_Original";
				else if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsFonts', 'SpanishFonts') == "3")
					iconPath += "_Original_HeP";
				else
					iconPath += "_Nosferatu";
			}
			else if(GetCurrentTextLocCode() == "FR")
			{
				iconPath += "_FR_DINPro";
			}
			else if(GetCurrentTextLocCode() == "HU")
			{
				iconPath += "_HU_DINPro";
			}
			else if(GetCurrentTextLocCode() == "IT")
			{
				iconPath += "_IT_DINPro";
			}
			else if(GetCurrentTextLocCode() == "JP")
			{
				iconPath += "_JP_Heiti";
			}
			else if(GetCurrentTextLocCode() == "KR")
			{
				iconPath += "_KR_Malgun";
			}
			else if(GetCurrentTextLocCode() == "PL")
			{
				iconPath += "_PL_DINPro";
			}
			else if(GetCurrentTextLocCode() == "RU")
			{
				iconPath += "_RU_DINPro";
			}
			else if(GetCurrentTextLocCode() == "TR")
			{
				iconPath += "_TR_DINPro";
			}
			else
			{
				iconPath += "_EN";
				if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsFonts', 'EnglishFonts') == "1")
					iconPath += "_Nosferatu";
				else if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsFonts', 'EnglishFonts') == "2")
					iconPath += "_Original";
				else
					iconPath += "_DINPro";
			}
		}

		if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsAddons', 'OilsReflect') && StrContains(iconPath, "/oils/"))
			iconPath += "_OilsReflect";
		
		if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsAddons', 'GlyphsReflect') && StrContains(iconPath, "/glyphs/"))
			iconPath += "_GlyphsReflect";
		
		if(StrContains(iconPath, "/bombs/"))
		{
			if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsAddons', 'ArdBombs')) iconPath += "_ArdBombs";
			else if(theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsAddons', 'TW2Bombs')) iconPath += "_TW2Bombs";
		}

		if((StrContains(iconPath, "_superior") || StrContains(iconPath, "_greater")) &&
		((theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'LessBrightBombs') && StrContains(iconPath, "/bombs/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'LessBrightOils') && StrContains(iconPath, "/oils/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'LessBrightPotions') && StrContains(iconPath, "/potions/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'LessBrightRunes') && StrContains(iconPath, "/glyphs/"))
		|| (theGame.GetInGameConfigWrapper().GetVarValue('modBetterIconsTIERS', 'LessBrightGlyphs') && StrContains(iconPath, "/runes/"))
		))
			iconPath += "_LessBright";
		
		if(DDSIcon) iconPath += ".dds";
		else iconPath += ".png";
	}
	else if(itemName == 'Yrden')
		iconPath = "hud/radialmenu/mcyrden.png";
	else if(itemName == 'Quen')
		iconPath = "hud/radialmenu/mcquen.png";
	else if(itemName == 'Igni')
		iconPath = "hud/radialmenu/mcigni.png";
	else if(itemName == 'Axii')
		iconPath = "hud/radialmenu/mcaxii.png";
	else if(itemName == 'Aard')
		iconPath = "hud/radialmenu/mcaard.png";
	else if(itemName != '')
		iconPath = theGame.GetDefinitionsManager().GetItemIconPath(itemName);
	else
		iconPath = ((CBaseGameplayEffect)GetWitcherPlayer().GetBuff(effectType)).GetIcon();
	
	return iconPath;
}

class ACSNotifcationPopupMissingDlc extends ConfirmationPopupData
{
	protected  function DefineDefaultButtons():void
	{
		AddButtonDef("fake_key_933c4yf", "escape-gamepad_B", IK_Escape);
	}

	protected function OnUserDecline()
	{
		theGame.RequestExit();
	}
}

class ACSNotifcationDisabledDlc extends ConfirmationPopupData
{
	protected  function DefineDefaultButtons():void
	{
		AddButtonDef("fake_key_933c4yf", "escape-gamepad_B", IK_Escape);
	}

	protected function OnUserDecline()
	{
		theGame.RequestEndGame();
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_NPC_Custom_Attack_Range( owner : CActor, data : CPreAttackEventData ) : array< CGameplayEntity >
{
	var targets 									: array<CGameplayEntity>;
	var dist, ang, heightCheck, headingModifier		: float;
	var pos, targetPos								: Vector;
	var i											: int;
	var rangeNameString								: string;

	if (
	(((CNewNPC)owner).GetSfxTag() == 'sfx_ice_giant'
	|| ((CNewNPC)owner).HasAbility('mon_cyclops'))
	&& data.rangeName != 'useCollisionFromItem'
	) 
	{
		dist = 3.5;

		ang = 60;
	}
	else if (
	( 
	 ((CNewNPC)owner).HasAbility('mon_lessog_base')
	|| ((CNewNPC)owner).HasAbility('mon_sprigan_base')
	|| ((CNewNPC)owner).GetSfxTag() == 'sfx_lessog'
	)
	) 
	{
		dist = 4;

		ang = 90;
	}
	else if (
	( 
	((CNewNPC)owner).GetSfxTag() == 'sfx_golem'
	|| ((CNewNPC)owner).GetSfxTag() == 'sfx_elemental_ifryt'
	|| ((CNewNPC)owner).HasAbility('mon_ice_golem')
	
	|| ((CNewNPC)owner).HasAbility('mon_czart')
	|| ((CNewNPC)owner).GetSfxTag() == 'sfx_bies'
	)
	) 
	{
		dist = 3.5;

		ang = 90;
	}
	else if (((CNewNPC)owner).GetSfxTag() == 'sfx_gryphon'
	|| ((CNewNPC)owner).HasAbility('mon_basilisk')
	|| ((CNewNPC)owner).GetSfxTag() == 'sfx_cockatrice'
	|| ((CNewNPC)owner).HasAbility('mon_mq7018_basilisk')
	) 
	{
		dist = 4;

		ang = 180;

		if (((CNewNPC)owner).IsFlying())
		{
			ang += 180;
		}
	}
	else if ((((CNewNPC)owner).HasAbility('mon_forktail')
	|| ((CNewNPC)owner).HasAbility('mon_forktail_mh')
	|| ((CNewNPC)owner).GetSfxTag() == 'sfx_wyvern'
	|| ((CNewNPC)owner).HasAbility('mon_mq7010_dracolizard')
	|| ((CNewNPC)owner).HasAbility('mon_draco_base'))
	//&& data.rangeName != 'useCollisionFromItem'
	) 
	{
		if (((CNewNPC)owner).HasTag('ACS_Vigilosaur_Alpha'))
		{
			dist = 2;
		}
		else if (((CNewNPC)owner).HasTag('ACS_Vigilosaur'))
		{
			dist = 1.75;
		}
		else
		{
			dist = 3;
		}

		ang = 270;
	}
	else if (((CNewNPC)owner).HasAbility('mon_evil_dog') 
	|| ((CNewNPC)owner).GetSfxTag() == 'sfx_wild_dog'
	|| ((CNewNPC)owner).HasAbility('mon_wolf_base')
	|| ((CNewNPC)owner).HasAbility('mon_wolf_summon_were')
	) 
	{
		dist = 2.5;

		ang = 60;
	}
	else if 
	(
		((CNewNPC)owner).HasAbility('mon_arachas_base')
		|| ((CNewNPC)owner).HasAbility('mon_poison_arachas')
		|| ((CNewNPC)owner).HasAbility('mon_black_spider_base')
		|| ((CNewNPC)owner).GetSfxTag() == 'sfx_arachas'
		|| ((CNewNPC)owner).GetSfxTag() == 'sfx_endriaga'
		|| ((CNewNPC)owner).HasAbility('mon_endriaga_soldier_tailed')
		|| ((CNewNPC)owner).HasAbility('mon_endriaga_worker')
		|| ((CNewNPC)owner).HasAbility('mon_kikimora_warrior')
		|| ((CNewNPC)owner).HasAbility('mon_kikimora_worker')
		|| ((CNewNPC)owner).HasAbility('mon_black_spider_ep2_base')
	)
	{
		dist = 2.5;

		ang = 60;
	}
	else if 
	(
		((CNewNPC)owner).HasTag('ACS_Stryzga')
	)
	{
		if (
		data.rangeName == 'wideAreaOfEffect' 
		)
		{
			dist = 1.75;

			ang = 30;
		}
		else if (
		data.rangeName == 'acs_run_attack_striga' 
		)
		{
			dist = 2.25;

			ang = 270;
		}
		else if (
		data.rangeName == 'acs_jump_attack_striga' 
		)
		{
			dist = 2.25;

			ang = 90;
		}
		else
		{
			dist = 1.75;

			ang = 60;
		}
		
	}
	else if 
	(
		((CNewNPC)owner).HasTag('ACS_WitchOfTheWood_MonsterForm')
	)
	{
		dist = 3.5;

		ang = 60;
		
	}
	else if (((CNewNPC)owner).HasAbility('mon_wild_hunt_default') 
	) 
	{
		if (((CNewNPC)owner).HasAbility('SkillTwoHanded') 
		) 
		{
			dist = 3.5;
		}
		else
		{
			dist = 2.5;
		}

		ang = 60;
	}
	else if (
	((CHumanAICombatStorage)((CNewNPC)owner).GetScriptStorageObject('CombatData')).GetActiveCombatStyle() == EBG_Combat_2Handed_Hammer
	|| ((CHumanAICombatStorage)((CNewNPC)owner).GetScriptStorageObject('CombatData')).GetActiveCombatStyle() == EBG_Combat_2Handed_Axe
	|| ((CHumanAICombatStorage)((CNewNPC)owner).GetScriptStorageObject('CombatData')).GetActiveCombatStyle() == EBG_Combat_2Handed_Halberd
	|| ((CHumanAICombatStorage)((CNewNPC)owner).GetScriptStorageObject('CombatData')).GetActiveCombatStyle() == EBG_Combat_2Handed_Spear
	|| ((CHumanAICombatStorage)((CNewNPC)owner).GetScriptStorageObject('CombatData')).GetActiveCombatStyle() == EBG_Combat_2Handed_Staff
	) 
	{
		if (((CNewNPC)owner).HasTag('ACS_2HandWeaponDestroyed'))
		{
			dist = 2;

			ang = 30;
		}
		else
		{
			dist = 2.5;

			ang = 60;
		}
	}
	else
	{
		dist = 1.125;
		ang = 30;
	}

	targets.Clear();

	pos = owner.GetWorldPosition();
	pos.Z += 0.8;

	heightCheck = 2.5;

	rangeNameString = NameToString(data.rangeName);
	
	if (StrContains( rangeNameString, "right" )
	)
	{
		headingModifier = -45;
	}
	else if (StrContains( rangeNameString, "left" )
	)
	{
		headingModifier = 45;
	}
	else
	{
		headingModifier = 0;
	}

	FindGameplayEntitiesInCone( targets, owner.GetWorldPosition(), VecHeading( owner.GetWorldForward() ) + headingModifier, ang, dist, 999, , FLAG_OnlyAliveActors );
	for( i = targets.Size()-1; i >= 0; i -= 1 ) 
	{	
		targetPos = targets[i].GetWorldPosition();
		if ( AbsF( targetPos.Z - pos.Z ) > heightCheck )
		{
			targets.EraseFast(i);
		}
	}	

	return targets;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function ACS_MagicDetected() : bool
{
	var i, j: int;
	var entities: array<CGameplayEntity>;
	var entity : CMajorPlaceOfPowerEntity;
	var lactor : CActor;
	var area : CTriggerAreaComponent;
	var pos: Vector;
	var ic: CInteractionComponent;
	var components:array<CComponent>;

	pos = thePlayer.GetWorldPosition();
	pos.Z += 1.8f;

	FindGameplayEntitiesInSphere( entities, thePlayer.GetWorldPosition(), ACS_Settings_Main_Float('acs_hud_settings_main','acs_nearby_poi_detection_effect_range', 30), 100, '', FLAG_ExcludePlayer );

	for (i=0; i<entities.Size(); i+=1)
	{
		lactor = (CActor)entities[i];

		if (lactor.IsMonster() 
		&& lactor.IsAlive() 
		&& (lactor.GetVisibility() || lactor.IsInCombat()) 
		&& !StrContains(lactor.GetAppearance(), "gregoire")
		)
		{
			return true;
		}

		if((lactor.HasAbility('SkillSorceress') || lactor.HasAbility('HaklandMage')) && lactor.GetVisibility())
		{
			return true;
		}
		
		if(lactor.GetAppearance() == 'regis_vampire_morph' && lactor.GetVisibility())
		{
			return true;
		}

		if(StrContains(lactor.GetAppearance(), "godling") && lactor.GetVisibility())
		{
			return true;
		}

		if((StrContains(entities[i].GetReadableName(), "mq7017_fx_tomb")&& FactsQuerySum('mq7017_fact_spirit_fought') == 0 && FactsQuerySum('mq7017_fact_spirit_fought') == 0) || StrContains(entities[i].GetReadableName(),"mq7017_spirit"))//Equine Phantom
		{
			return true;
		}

		if(lactor.GetVoicetag() == 'VIVIENNE' && lactor.GetVisibility() && (FactsQuerySum('sq701_night_falls') == 0 && FactsQuerySum('am_vivienne') == 0))
		{
			return true;
		}

		if ((W3IllusionaryObstacle)entities[i])
		{
			return true;
		}

		if ((CRiftEntity)entities[i])
		{
			return true;
		}

		if ((CTeleportEntity)entities[i])
		{
			return true;
		}

		if (entities[i].IsEffectActive('teleport') || entities[i].IsEffectActive('teleport_fx'))
		{
			return true;
		}

		if((W3MagicLampEntity)entities[i])
		{
			//return true;
		}

		if((CGhost)entities[i] && ((CDrawableComponent)entities[i].GetComponentByClassName( 'CDrawableComponent' )).IsVisible())
		{
			return true;
		}
		
		if (lactor.HasTag('sq107_pig') || lactor.HasTag('sq107_vault_pig'))
		{
			return true;
		}

		if ( lactor.GetVoicetag() == 'GHOST IN THE TREE' )
		{
			return true;
		}

		if ( lactor.GetVoicetag() == 'CELINA' )
		{
			return true;
		}

		if((W3MonsterClue)entities[i]
		&& ((W3MonsterClue)entities[i]).GetIsVisible()
		&& (((W3MonsterClue)entities[i]).GetFocusModeVisibility() == FMV_Interactive || ((W3MonsterClue)entities[i]).GetFocusModeVisibility() == FMV_Clue)
		)
		{
			return true;
		}

		if((W3CiriPhantom)entities[i])
		{
			return true;
		}

		if(StrContains(lactor.GetAppearance(), "megascope"))
		{
			return true;
		}

		if(StrContains(lactor.GetAppearance(), "avallach") && lactor.GetVisibility())
		{
			return true;
		}

		if(StrContains((LoadResource( lactor.GetReadableName(), true ).GetPath()), "q106_keira_metz_voice"))
		{
			return true;
		}

		if(entities[i].HasTag('mh106_angel'))
		{
			return true;
		}

		if(StrContains(entities[i].ToString(), "mq7004_clue_whispers"))
		{
			return true;
		}

		if(((W3MonsterClue)entities[i]).isAvailable && entities[i].HasTag('mh308_clue_suicide'))
		{
			return true;
		}

		if(StrContains(lactor.GetVoicetag(), "EVERC ") && lactor.GetVisibility() )
		{
			return true;
		}

		if((StrContains(entities[i].ToString(), "wisp") || StrContains(entities[i].ToString(), "whisp"))&& lactor.GetVisibility())
		{
			return true;
		}
		
		if(StrContains(entities[i].ToString(), "mq1060_blood_drag"))
		{
			return true;
		}

		if ( lactor.GetVoicetag() == 'REINALD' && lactor.GetVisibility())
		{
			return true;
		}

		if ( (CGhost)entities[i] && lactor.IsSpeaking())
		{
			return true;
		}

		if ( StrContains(lactor.GetVoicetag(), 'DEAMON' ))
		{
			return true;
		}

		return false;
	}

	return false;
}
	
function ACS_PlaceOfPowerDetected() : bool
{
	var i, j: int;
	var entities: array<CGameplayEntity>;
	var entity : CMajorPlaceOfPowerEntity;

	FindGameplayEntitiesInSphere( entities, thePlayer.GetWorldPosition(), ACS_Settings_Main_Float('acs_hud_settings_main','acs_nearby_poi_detection_effect_range', 30), 5, '', , ,'CMajorPlaceOfPowerEntity' );
	
	if( entities.Size() > 0)
	{
		entity = (CMajorPlaceOfPowerEntity) entities[ i ];
		
		if(entity.isPlaceOfPowerInIdle)
		{
			return true;
		}	
	}

	return false;
}