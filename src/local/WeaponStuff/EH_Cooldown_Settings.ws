struct ACS_Cooldown_Manager 
{
	var last_light_attack_time							: float;
	var last_heavy_attack_time							: float;

	var last_parry_skill_time							: float;
	var parry_skill_doubletap_cooldown					: float;
	var last_parry_skill_doubletap_time					: float;

	var guard_attack_cooldown							: float;
	var last_guard_attack_time							: float;
	var guard_doubletap_attack_cooldown					: float;
	var last_guard_doubletap_attack_time				: float;
	var special_attack_cooldown							: float;
	var last_special_attack_time						: float;
	var bruxa_dash_cooldown								: float;
	var last_bruxa_dash_time							: float;
	var dodge_cooldown									: float;
	var last_dodge_time									: float;
	var special_dodge_cooldown							: float;
	var last_special_dodge_time							: float;
	var beam_attack_cooldown							: float;
	var last_beam_attack_time							: float;

	var bow_stationary_cooldown							: float;
	var last_shoot_bow_stationary_time					: float;

	var bow_moving_cooldown								: float;
	var last_shoot_bow_moving_time						: float;

	var last_shoot_crossbow_time						: float;

	var last_forest_god_shadow_spawn_time 				: float;
	var forest_god_shadow_cooldown						: float;

	var last_rage_marker_spawn_time 					: float;

	var last_ghoul_proj_spawn_time 						: float;

	var last_tentacle_proj_spawn_time 					: float;

	var last_necrofiend_proj_spawn_time					: float;

	var last_nekker_guardian_time 						: float;
	var nekker_guardian_cooldown						: float;

	var last_katakan_time 								: float;
	var katakan_cooldown								: float;

	var last_bat_projectile_time 						: float;
	var bat_projectile_cooldown							: float;

	var last_bear_flame_on_time 						: float;
	var bear_flame_on_cooldown							: float;

	var last_bear_fireball_time 						: float;
	var bear_fireball_cooldown							: float;

	var last_bear_fireline_time 						: float;
	var bear_fireline_cooldown							: float;

	var last_knightmare_shout_time 						: float;
	var knightmare_shout_cooldown						: float;
	
	var last_knightmare_igni_time 						: float;
	var knightmare_igni_cooldown						: float;

	var last_she_who_knows_ability_time					: float;
	var she_who_knows_ability_cooldown					: float;

	var last_vampire_monster_ability_time				: float;
	var vampire_monster_ability_cooldown				: float;

	var last_witch_hunter_throw_bomb_time				: float;
	var witch_hunter_bomb_cooldown						: float;

	var transformation_light_attack_cooldown			: float;
	var last_transformation_light_attack_time			: float;
	var transformation_heavy_attack_cooldown			: float;
	var last_transformation_heavy_attack_time			: float;
	var transformation_special_attack_cooldown			: float;
	var last_transformation_special_attack_time			: float;
	var transformation_dodge_cooldown					: float;
	var last_transformation_dodge_time					: float;

	var last_rat_mage_ability_time						: float;
	var rat_mage_ability_cooldown						: float;

	var last_wild_hunt_warriors_spawn_time				: float;
	var wild_hunt_warriors_spawn_cooldown				: float;

	var last_idle_action_time							: float;
	var idle_action_cooldown							: float;

	var last_blade_projectile_spawn_time				: float;
	var blade_projectile_cooldown						: float;

	var last_npc_push_time								: float;
	var npc_push_cooldown								: float;

	var last_fire_source_time							: float;
	var fire_source_cooldown							: float;

	var last_nightstalker_spawn_time					: float;

	var last_elderblood_assassin_spawn_time				: float;

	var last_blood_spatter_spawn_time					: float;

	var last_xeno_switch_time							: float;
	var xeno_switch_cooldown							: float;

	var last_canaris_melee_time							: float;
	var canaris_melee_cooldown							: float;

	var last_canaris_ability_time						: float;
	var canaris_ability_cooldown						: float;

	var last_canaris_teleport_time						: float;
	var canaris_teleport_cooldown						: float;

	var last_lightning_time								: float;
	var lightning_cooldown								: float;

	var last_fire_gargoyle_ability_time					: float;
	var fire_gargoyle_ability_cooldown					: float;

	var last_fog_ent_spawn_time							: float;
	var fog_ent_spawn_cooldown							: float;

	var last_fish_spawn_time							: float;

	var last_wisp_projectile_time						: float;
	var wisp_projectile_cooldown						: float;

	var last_fluffy_ability_time						: float;
	var fluffy_ability_cooldown							: float;

	var last_fluffy_idle_action_time					: float;
	var fluffy_idle_action_cooldown						: float;

	var last_blood_decal_time							: float;
	var blood_decal_cooldown							: float;

	var last_fogling_spawn_time							: float;
	var fogling_spawn_cooldown							: float;

	var last_event_hack_time							: float;

	var last_melusine_cloud_attack_time					: float;
	var melusine_cloud_attack_cooldown					: float;

	var last_melusine_ability_switch_time				: float;
	var melusine_ability_switch_cooldown				: float;

	var last_cultist_singer_song_time					: float;
	var cultist_singer_song_cooldown					: float;

	var last_duskwraith_ability_time					: float;
	var duskwraith_ability_cooldown						: float;

	var last_duskwraith_yrden_breakout_time				: float;
	var duskwraith_yrden_breakout_cooldown				: float;

	var last_draug_ability_time							: float;

	var last_glide_time									: float;

	var last_aard_time									: float;

	var last_axii_time									: float;

	var last_igni_time									: float;

	var last_quen_time									: float;

	var last_yrden_time									: float;

	var last_whirl_time									: float;

	var last_rend_time									: float;

	var last_eye_search_time							: float;

	var last_quest_marker_distance_refresh_time			: float;

	var last_quest_marker_distance_remove_refresh_time	: float;

	var last_starfall_time								: float;

	var last_guardian_blood_hym_spawn_time				: float;

	var last_wearable_pocket_item_refresh_time			: float;

	// Change the values below to adjust the cooldowns of specific attacks or skills.
	
	default parry_skill_doubletap_cooldown = 0.4;

	default guard_attack_cooldown = 0.4;
	
	default guard_doubletap_attack_cooldown = 0.4;
	
	default special_attack_cooldown = 0.8;

	default bruxa_dash_cooldown = 0.375;	
	
	default dodge_cooldown = 0.375;
	
	default special_dodge_cooldown = 2;	
	
	default beam_attack_cooldown = 0.5;	

	default bow_stationary_cooldown = 1.75;

	default bow_moving_cooldown = 1;


	// Transformation Stuff Cooldown Default

	default transformation_light_attack_cooldown = 0.5;

	default transformation_heavy_attack_cooldown = 0.5;

	default transformation_special_attack_cooldown = 0.8;

	default transformation_dodge_cooldown = 1;



	// Forest God Shadow Cooldown Default

	default forest_god_shadow_cooldown = 420;


	// Nekker Guardian Cooldown Default

	default nekker_guardian_cooldown = 2;

	
	// Novigrad Underground Katakan Spawn Cooldown Default

	default katakan_cooldown = 20;


	// Vampire Bat Projectile Cooldown Default

	default bat_projectile_cooldown = 10;


	// Fire Bear Abilities Cooldown Default

	default bear_flame_on_cooldown = 15;

	default bear_fireball_cooldown = 1.5;

	default bear_fireline_cooldown = 7;

	
	// Knightmare Abilities Cooldown Default

	default knightmare_shout_cooldown = 10;

	default knightmare_igni_cooldown = 7;


	// She Who Knows Abilities Cooldown Default

	default she_who_knows_ability_cooldown	= 10;

	// Vampire Monster Abilities Cooldown Default

	default vampire_monster_ability_cooldown = 10;

	// Witch Hunter Bomb Cooldown Default

	default witch_hunter_bomb_cooldown = 7;

	// Rat Mage Abilities Cooldown Default

	default rat_mage_ability_cooldown	= 3;

	// Wild Hunt Warriors Spawn Cooldown
	default wild_hunt_warriors_spawn_cooldown	= 840;

	// Mage Idle Action Cooldown
	default idle_action_cooldown	= 1;

	// Blade Projectile Cooldown
	default blade_projectile_cooldown	= 0.5;

	// NPC Push Cooldown
	default npc_push_cooldown			= 1;
	
	// Light Or Extinguish Fire Cooldown
	default fire_source_cooldown			= 1;

	// Xeno Switch Cooldown
	default xeno_switch_cooldown		= 15;

	// Canaris Ability Cooldown
	default canaris_melee_cooldown		= 1.5;
	default canaris_ability_cooldown	= 5;
	default canaris_teleport_cooldown	= 1.5;

	// Lightning Cooldown
	default lightning_cooldown			= 30;

	// Fire Gargoyle Cooldown
	default fire_gargoyle_ability_cooldown	= 7;

	// Fog Ent Cooldown
	default fog_ent_spawn_cooldown			= 10;

	// Wisp Projectile Cooldown
	default wisp_projectile_cooldown		= 0.25;

	// Fluffy Cooldown
	default fluffy_ability_cooldown		= 1;

	// Fluffy Idle Cooldown
	default fluffy_idle_action_cooldown = 3;

	// Blood Decal Cooldown
	default blood_decal_cooldown = 25;

	// Fogling Spawn Cooldown
	default fogling_spawn_cooldown = 10;

	// Melusine Cooldown
	default melusine_cloud_attack_cooldown = 0.25;

	default melusine_ability_switch_cooldown = 10;

	// Singer Cooldown
	default cultist_singer_song_cooldown = 5;

	// Duskwraith Cooldown
	default duskwraith_ability_cooldown	 = 35;

	default duskwraith_yrden_breakout_cooldown	 = 10;
}

function ACS_can_perform_light_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_light_attack_time > 0.4;
}

function ACS_refresh_light_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_light_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_perform_heavy_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_heavy_attack_time > 0.4;
}

function ACS_refresh_heavy_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_heavy_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_perform_parry_skill(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_parry_skill_time > 0.4;
}

function ACS_refresh_parry_skill_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_parry_skill_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();
}

function ACS_can_perform_parry_skill_doubletap(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_parry_skill_doubletap_time > property.parry_skill_doubletap_cooldown;
}

function ACS_refresh_parry_skill_doubletap_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_parry_skill_doubletap_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();
}

function ACS_can_perform_guard_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_guard_attack_time > property.guard_attack_cooldown;
}

function ACS_refresh_guard_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_guard_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();
}

function ACS_can_perform_guard_doubletap_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_guard_doubletap_attack_time > property.guard_doubletap_attack_cooldown;
}

function ACS_refresh_guard_doubletap_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_guard_doubletap_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();
}

function ACS_can_perform_special_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_special_attack_time > property.special_attack_cooldown;
}

function ACS_refresh_special_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_special_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_bruxa_dash(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bruxa_dash_time > property.bruxa_dash_cooldown;
}

function ACS_refresh_bruxa_dash_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bruxa_dash_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_dodge(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_dodge_time > property.dodge_cooldown;
}

function ACS_refresh_dodge_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_dodge_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_special_dodge(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_special_dodge_time > property.special_dodge_cooldown;
}

function ACS_refresh_special_dodge_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_special_dodge_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_perform_beam_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_beam_attack_time > property.beam_attack_cooldown;
}

function ACS_refresh_beam_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_beam_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_shoot_bow_stationary(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_shoot_bow_stationary_time > property.bow_stationary_cooldown;
}

function ACS_refresh_bow_stationary_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_shoot_bow_stationary_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_shoot_bow_moving(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_shoot_bow_moving_time > property.bow_moving_cooldown;
}

function ACS_refresh_bow_moving_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_shoot_bow_moving_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_shoot_crossbow(): bool 
{
	var property: ACS_Cooldown_Manager;
	var cooldown: float;

	if ( thePlayer.GetStat(BCS_Focus) == thePlayer.GetStatMax(BCS_Focus) )
	{
		cooldown = 0.2;
	}
	else
	{
		cooldown = 0.4;
	}

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_shoot_crossbow_time > cooldown;
}

function ACS_refresh_crossbow_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_shoot_crossbow_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_Size_Revert_And_Enable_Interrupt()
{
	if (GetWitcherPlayer().HasTag('ACS_Size_Adjusted'))
	{
		GetACSWatcher().Grow_Geralt_Immediate_Fast();

		GetWitcherPlayer().RemoveTag('ACS_Size_Adjusted');
	}

	if (GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
	{
		GetWitcherPlayer().RemoveTag('ACS_Special_Dodge');
	}
}

function ACS_can_spawn_forest_god_shadows(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_forest_god_shadow_spawn_time > property.forest_god_shadow_cooldown;
}

function ACS_refresh_forest_god_shadows_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_forest_god_shadow_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_rage_marker(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_rage_marker_spawn_time > ACS_RageMechanicCooldown();
}

function ACS_refresh_rage_marker_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_rage_marker_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_ghoul_proj(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_ghoul_proj_spawn_time > 15;
}

function ACS_refresh_ghoul_proj_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_ghoul_proj_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_tentacle_proj(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_tentacle_proj_spawn_time > 7;
}

function ACS_refresh_tentacle_proj_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_tentacle_proj_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_necrofiend_proj(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_necrofiend_proj_spawn_time > 15;
}

function ACS_refresh_necrofiend_proj_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_necrofiend_proj_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_summon_nekker_guardian(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_nekker_guardian_time > property.nekker_guardian_cooldown;
}

function ACS_refresh_nekker_guardian_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_nekker_guardian_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_summon_katakan(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_katakan_time > property.katakan_cooldown;
}

function ACS_refresh_katakan_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_katakan_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_shoot_bat_projectile(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bat_projectile_time > property.bat_projectile_cooldown;
}

function ACS_refresh_bat_projectile_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bat_projectile_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_bear_can_flame_on(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bear_flame_on_time > property.bear_flame_on_cooldown;
}

function ACS_refresh_bear_flame_on_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bear_flame_on_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_bear_can_throw_fireball(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bear_fireball_time > property.bear_fireball_cooldown;
}

function ACS_refresh_bear_fireball_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bear_fireball_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_bear_can_throw_fireline(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_bear_fireline_time > property.bear_fireline_cooldown;
}

function ACS_refresh_bear_fireline_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_bear_fireline_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_knightmare_shout(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_knightmare_shout_time > property.knightmare_shout_cooldown;
}

function ACS_refresh_knightmare_shout_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_knightmare_shout_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_knightmare_igni(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_knightmare_igni_time > property.knightmare_igni_cooldown;
}

function ACS_refresh_knightmare_igni_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_knightmare_igni_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_she_who_knows_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_she_who_knows_ability_time > property.she_who_knows_ability_cooldown;
}

function ACS_refresh_she_who_knows_abilities_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_she_who_knows_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_vampire_monster_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_vampire_monster_ability_time > property.vampire_monster_ability_cooldown;
}

function ACS_refresh_vampire_monster_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_vampire_monster_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_witch_hunter_proj(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_witch_hunter_throw_bomb_time > property.witch_hunter_bomb_cooldown;
}

function ACS_refresh_witch_hunter_proj_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_witch_hunter_throw_bomb_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_perform_transformation_light_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_transformation_light_attack_time > property.transformation_light_attack_cooldown;
}

function ACS_refresh_transformation_light_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_transformation_light_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_perform_transformation_heavy_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_transformation_heavy_attack_time > property.transformation_heavy_attack_cooldown;
}

function ACS_refresh_transformation_heavy_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_transformation_heavy_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_perform_transformation_special_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_transformation_special_attack_time > property.transformation_special_attack_cooldown;
}

function ACS_refresh_transformation_special_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_transformation_special_attack_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_can_transformation_dodge(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_transformation_dodge_time > property.transformation_dodge_cooldown;
}

function ACS_refresh_transformation_dodge_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_transformation_dodge_time = theGame.GetEngineTimeAsSeconds();

	ACS_Size_Revert_And_Enable_Interrupt();

	
}

function ACS_rat_mage_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_rat_mage_ability_time > property.rat_mage_ability_cooldown;
}

function ACS_refresh_rat_mage_abilities_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_rat_mage_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_wild_hunt_warriors(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_wild_hunt_warriors_spawn_time > property.wild_hunt_warriors_spawn_cooldown;
}

function ACS_refresh_wild_hunt_warriors_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_wild_hunt_warriors_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_play_idle_action(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_idle_action_time > property.idle_action_cooldown;
}

function ACS_refresh_idle_action_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_idle_action_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_blade_projectile(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_blade_projectile_spawn_time > property.blade_projectile_cooldown;
}

function ACS_refresh_blade_projectile_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_blade_projectile_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_push_npc(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_npc_push_time > property.npc_push_cooldown;
}

function ACS_refresh_npc_push_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_npc_push_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_fire_source(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_fire_source_time > property.fire_source_cooldown;
}

function ACS_refresh_fire_source_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_fire_source_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_nightstalker(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_nightstalker_spawn_time > 840;
}

function ACS_refresh_nightstalker_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_nightstalker_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_xeno_switch(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_xeno_switch_time > property.xeno_switch_cooldown;
}

function ACS_refresh_xeno_switch_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_xeno_switch_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_canaris_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_canaris_ability_time > property.canaris_ability_cooldown;
}

function ACS_refresh_canaris_abilities_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_canaris_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_canaris_melee(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_canaris_melee_time > property.canaris_melee_cooldown;
}

function ACS_refresh_canaris_melee_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_canaris_melee_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_canaris_teleport(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_canaris_teleport_time > property.canaris_teleport_cooldown;
}

function ACS_refresh_canaris_teleport_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_canaris_teleport_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_lightning(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_lightning_time > property.lightning_cooldown;
}

function ACS_refresh_lightning_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_lightning_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_fire_gargoyle_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_fire_gargoyle_ability_time > property.fire_gargoyle_ability_cooldown;
}

function ACS_refresh_fire_gargoyle_abilities_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_fire_gargoyle_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_fog_ent_spawn(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_fog_ent_spawn_time > property.fog_ent_spawn_cooldown;
}

function ACS_refresh_fog_ent_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_fog_ent_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_fish_spawn(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_fish_spawn_time > 5;
}

function ACS_refresh_fish_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_fish_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_wisp_projectile_spawn(): bool 
{
	var property							: ACS_Cooldown_Manager;
	var cooldownAdjusted 					: float;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	cooldownAdjusted = property.wisp_projectile_cooldown;

	if (thePlayer.GetLevel() <= 5)
	{
		cooldownAdjusted += 1.5;
	}
	else if (thePlayer.GetLevel() > 5 && thePlayer.GetLevel() <= 10)
	{
		cooldownAdjusted += 1.25;
	}
	else if (thePlayer.GetLevel() > 10 && thePlayer.GetLevel() <= 15)
	{
		cooldownAdjusted += 1;
	}
	else if (thePlayer.GetLevel() > 15 && thePlayer.GetLevel() <= 20)
	{
		cooldownAdjusted += 0.75;
	}
	else if (thePlayer.GetLevel() > 20 && thePlayer.GetLevel() <= 25)
	{
		cooldownAdjusted += 0.5;
	}
	else if (thePlayer.GetLevel() > 25 && thePlayer.GetLevel() <= 30)
	{
		cooldownAdjusted += 0.25;
	}
	else if (thePlayer.GetLevel() > 30)
	{
		cooldownAdjusted += 0;
	}

	return theGame.GetEngineTimeAsSeconds() - property.last_wisp_projectile_time > cooldownAdjusted;
}

function ACS_refresh_wisp_projectile_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_wisp_projectile_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_fluffy_ability(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_fluffy_ability_time > property.fluffy_ability_cooldown;
}

function ACS_refresh_fluffy_ability_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_fluffy_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_play_fluffy_idle_action(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_fluffy_idle_action_time > property.fluffy_idle_action_cooldown;
}

function ACS_refresh_fluffy_idle_action_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_fluffy_idle_action_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_play_blood_decal(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_blood_decal_time > property.blood_decal_cooldown;
}

function ACS_refresh_blood_decal_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_blood_decal_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_fogling(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_fogling_spawn_time > property.fogling_spawn_cooldown;
}

function ACS_refresh_fogling_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_fogling_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_use_event_hack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_event_hack_time > 1;
}

function ACS_refresh_event_hack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_event_hack_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_melusine_cloud_can_attack(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_melusine_cloud_attack_time > property.melusine_cloud_attack_cooldown;
}

function ACS_refresh_melusine_cloud_attack_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_melusine_cloud_attack_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_melusine_ability_switch(): bool 
{
	var property							: ACS_Cooldown_Manager;
	var cooldownAdjusted 					: float;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	cooldownAdjusted = property.melusine_ability_switch_cooldown;

	if (GetACSMelusineCloud().HasAbility('DjinnRage'))
	{
		cooldownAdjusted += 20;
	}

	return theGame.GetEngineTimeAsSeconds() - property.last_melusine_ability_switch_time > cooldownAdjusted;
}

function ACS_refresh_melusine_ability_switch_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_melusine_ability_switch_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_cultist_singer_can_sing(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_cultist_singer_song_time > property.cultist_singer_song_cooldown;
}

function ACS_refresh_cultist_singer_song_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_cultist_singer_song_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_duskwraith_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_duskwraith_ability_time > property.duskwraith_ability_cooldown;
}

function ACS_refresh_duskwraith_abilities_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_duskwraith_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_duskwraith_break_yrden(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_duskwraith_yrden_breakout_time > property.duskwraith_yrden_breakout_cooldown;
}

function ACS_refresh_duskwraith_break_yrden_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_duskwraith_yrden_breakout_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_draug_ability(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_draug_ability_time > 7;
}

function ACS_refresh_draug_ability_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_draug_ability_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_glide(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_glide_time > 1;
}

function ACS_refresh_glide_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_glide_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_use_aard(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_aard_time > ACS_SignCooldown();
}

function ACS_refresh_aard_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_aard_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_use_axii(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_axii_time > ACS_SignCooldown();
}

function ACS_refresh_axii_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_axii_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_use_igni(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_igni_time > ACS_SignCooldown();
}

function ACS_refresh_igni_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_igni_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_use_quen(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_quen_time > ACS_SignCooldown();
}

function ACS_refresh_quen_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_quen_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_use_yrden(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_yrden_time > ACS_SignCooldown();
}

function ACS_refresh_yrden_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_yrden_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_use_whirl(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_whirl_time > ACS_MeleeSpecialCooldown();
}

function ACS_refresh_whirl_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_whirl_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_use_rend(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_rend_time > ACS_MeleeSpecialCooldown();
}

function ACS_refresh_rend_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_rend_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_eye_can_search_for_ents(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_eye_search_time > 0.1;
}

function ACS_refresh_eye_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_eye_search_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_elderblood_assassin(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_elderblood_assassin_spawn_time > 220;
}

function ACS_refresh_elderblood_assassin_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_elderblood_assassin_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_blood_spatter(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_blood_spatter_spawn_time > 0.5;
}

function ACS_refresh_blood_spatter_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_blood_spatter_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_refresh_quest_marker_distance(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_quest_marker_distance_refresh_time > 0.25;
}

function ACS_refresh_quest_marker_distance_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_quest_marker_distance_refresh_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_refresh_quest_marker_distance_remove(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_quest_marker_distance_remove_refresh_time > 0.25;
}

function ACS_refresh_quest_marker_distance_remove_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_quest_marker_distance_remove_refresh_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_refresh_starfall(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_starfall_time > RandRangeF(60,36);
}

function ACS_refresh_starfall_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_starfall_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_spawn_guardian_blood_hym(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_guardian_blood_hym_spawn_time > 10;
}

function ACS_refresh_guardian_blood_hym_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_guardian_blood_hym_spawn_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_wearable_pocket_items_cooldown(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_wearable_pocket_item_refresh_time > 0.5;
}

function ACS_refresh_wearable_pocket_items_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_wearable_pocket_item_refresh_time = theGame.GetEngineTimeAsSeconds();
}