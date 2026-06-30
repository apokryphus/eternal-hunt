struct ACS_Cooldown_Manager 
{
	var last_dodge_time									: float;
	var last_special_dodge_time							: float;
	var last_flip_dodge_time							: float;

	var beam_attack_cooldown							: float;
	var last_beam_attack_time							: float;

	var last_forest_god_shadow_spawn_time 				: float;

	//var last_bat_projectile_time 						: float;
	//var bat_projectile_cooldown						: float;

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

	var last_rat_mage_ability_time						: float;
	var rat_mage_ability_cooldown						: float;

	var last_wild_hunt_warriors_spawn_time				: float;

	var last_npc_push_time								: float;
	var npc_push_cooldown								: float;

	var last_nightstalker_spawn_time					: float;

	var last_elderblood_assassin_spawn_time				: float;

	var last_blood_spatter_spawn_time					: float;

	var last_canaris_melee_time							: float;
	var canaris_melee_cooldown							: float;

	var last_canaris_ability_time						: float;
	var canaris_ability_cooldown						: float;

	var last_canaris_teleport_time						: float;
	var canaris_teleport_cooldown						: float;

	var last_fire_gargoyle_ability_time					: float;

	var last_wisp_projectile_time						: float;
	var wisp_projectile_cooldown						: float;

	var last_fluffy_ability_time						: float;
	var fluffy_ability_cooldown							: float;

	var last_fogling_spawn_time							: float;
	var fogling_spawn_cooldown							: float;

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

	var last_guardian_blood_hym_spawn_time				: float;

	var last_sign_combo_system_activation_time			: float;

	var last_apply_oil_activation_time					: float;

	// Change the values below to adjust the cooldowns of specific attacks or skills.

	default beam_attack_cooldown = 0.25;	


	// Vampire Bat Projectile Cooldown Default

	//efault bat_projectile_cooldown = 10;

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

	// Rat Mage Abilities Cooldown Default

	default rat_mage_ability_cooldown	= 3;

	// NPC Push Cooldown
	default npc_push_cooldown			= 1;

	// Canaris Ability Cooldown
	default canaris_melee_cooldown		= 1.5;
	default canaris_ability_cooldown	= 5;
	default canaris_teleport_cooldown	= 1.5;

	// Wisp Projectile Cooldown
	default wisp_projectile_cooldown		= 0.25;

	// Fluffy Cooldown
	default fluffy_ability_cooldown		= 1;

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

function ACS_can_dodge(): bool 
{
	var property: ACS_Cooldown_Manager;
	var cooldown : float;

	cooldown = ACS_Settings_Main_Float('acs_dodge_settings','acs_dodge_cooldown', 0.575);
	
	if( thePlayer.GetStat( BCS_Focus ) < thePlayer.GetStatMax( BCS_Focus )/3) 
	{
		cooldown -= 0;
	}
	else if( thePlayer.GetStat( BCS_Focus ) >= thePlayer.GetStatMax( BCS_Focus )/3
	&& thePlayer.GetStat( BCS_Focus ) < thePlayer.GetStatMax( BCS_Focus ) * 2/3) 
	{	
		cooldown -= 0.1;
	}
	else if( thePlayer.GetStat( BCS_Focus ) >= thePlayer.GetStatMax( BCS_Focus ) * 2/3)
	{	
		cooldown -= 0.2;
	}

	property = GetACSWatcher().vACS_Cooldown_Manager;

	if (!ACS_Settings_Main_Bool('acs_dodge_settings','acs_allow_dodging_while_in_attack_animation', true))
	{
		if (thePlayer.HasTag('ACS_Player_Is_Attacking')
		|| thePlayer.IsDoingSpecialAttack(false)
		|| thePlayer.IsDoingSpecialAttack(true)
		|| thePlayer.IsInCombatAction()
		)
		{
			return false;
		}
	}

	return (theGame.GetEngineTimeAsSeconds() - property.last_dodge_time > cooldown) ;
}

function ACS_refresh_dodge_cooldown() 
{
	var watcher: W3ACSWatcher;
	var animatedComponentA 	: CAnimatedComponent;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_dodge_time = theGame.GetEngineTimeAsSeconds();

	if (GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
	{
		GetWitcherPlayer().RemoveTag('ACS_Special_Dodge');
	}

	if (GetACSWatcher().combatExtraActive)
	{
		GetACSWatcher().RemoveTimer('combatExtraReset');
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');
	
		GetACSWatcher().SetCombatExtraStatus(false);
	}

	if (GetACSWatcher().idleAdditiveExtraActive)
	{
		thePlayer.RaiseEvent('ACS_IdleAdditiveReset');

		GetACSWatcher().SetIdleAdditiveExtraStatus(false);
	}

	if (thePlayer.HasTag('ACS_SwordBuffAnimationPlayed'))
	{
		thePlayer.RaiseEvent('ACS_BothHandsAdditiveEnd');

		thePlayer.RemoveTag('ACS_SwordBuffAnimationPlayed');
	}

	thePlayer.RaiseEvent('ACS_KickAttackReset');

	thePlayer.RaiseEvent('ACS_TW1AnimsReset');

	animatedComponentA = (CAnimatedComponent)thePlayer.GetComponentByClassName( 'CAnimatedComponent' );

	animatedComponentA.UnfreezePose(); animatedComponentA.UnfreezePoseFadeOut(0.01f);
}

function ACS_can_special_dodge(): bool 
{
	var property: ACS_Cooldown_Manager;
	var cooldown : float;

	cooldown = ACS_Settings_Main_Float('acs_dodge_settings','acs_slideback_dodge_cooldown', 2);

	if( thePlayer.GetStat( BCS_Focus ) < thePlayer.GetStatMax( BCS_Focus )/3) 
	{
		cooldown -= 0;
	}
	else if( thePlayer.GetStat( BCS_Focus ) >= thePlayer.GetStatMax( BCS_Focus )/3
	&& thePlayer.GetStat( BCS_Focus ) < thePlayer.GetStatMax( BCS_Focus ) * 2/3) 
	{	
		cooldown -= 0.5;
	}
	else if( thePlayer.GetStat( BCS_Focus ) >= thePlayer.GetStatMax( BCS_Focus ) * 2/3)
	{	
		cooldown -= 1;
	}

	property = GetACSWatcher().vACS_Cooldown_Manager;

	if (!ACS_Settings_Main_Bool('acs_dodge_settings','acs_allow_dodging_while_in_attack_animation', true))
	{
		if (thePlayer.HasTag('ACS_Player_Is_Attacking')
		|| thePlayer.IsDoingSpecialAttack(false)
		|| thePlayer.IsDoingSpecialAttack(true)
		|| thePlayer.IsInCombatAction()
		)
		{
			return false;
		}
	}

	return (theGame.GetEngineTimeAsSeconds() - property.last_special_dodge_time > cooldown) ;
}

function ACS_refresh_special_dodge_cooldown() 
{
	var watcher: W3ACSWatcher;
	var animatedComponentA 	: CAnimatedComponent;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_special_dodge_time = theGame.GetEngineTimeAsSeconds();

	if (GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
	{
		GetWitcherPlayer().RemoveTag('ACS_Special_Dodge');
	}

	if (GetACSWatcher().combatExtraActive)
	{
		GetACSWatcher().RemoveTimer('combatExtraReset');

		thePlayer.RaiseEvent('ACS_CombatExtraReset');

		GetACSWatcher().SetCombatExtraStatus(false);
	}

	if (GetACSWatcher().idleAdditiveExtraActive)
	{
		thePlayer.RaiseEvent('ACS_IdleAdditiveReset');

		GetACSWatcher().SetIdleAdditiveExtraStatus(false);
	}

	if (thePlayer.HasTag('ACS_SwordBuffAnimationPlayed'))
	{
		thePlayer.RaiseEvent('ACS_BothHandsAdditiveEnd');

		thePlayer.RemoveTag('ACS_SwordBuffAnimationPlayed');
	}

	thePlayer.RaiseEvent('ACS_KickAttackReset');

	thePlayer.RaiseEvent('ACS_TW1AnimsReset');

	animatedComponentA = (CAnimatedComponent)thePlayer.GetComponentByClassName( 'CAnimatedComponent' );

	animatedComponentA.UnfreezePose(); animatedComponentA.UnfreezePoseFadeOut(0.01f);
}

function ACS_can_flip_dodge(): bool 
{
	var property: ACS_Cooldown_Manager;
	var cooldown : float;

	cooldown = ACS_Settings_Main_Float('acs_dodge_settings','acs_flip_dodge_cooldown', 4);

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return (theGame.GetEngineTimeAsSeconds() - property.last_flip_dodge_time > cooldown) ;
}

function ACS_refresh_flip_dodge_cooldown() 
{
	var watcher: W3ACSWatcher;
	var animatedComponentA 	: CAnimatedComponent;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_flip_dodge_time = theGame.GetEngineTimeAsSeconds();

	if (GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
	{
		GetWitcherPlayer().RemoveTag('ACS_Special_Dodge');
	}

	if (GetACSWatcher().combatExtraActive)
	{
		GetACSWatcher().RemoveTimer('combatExtraReset');
		
		thePlayer.RaiseEvent('ACS_CombatExtraReset');

		GetACSWatcher().SetCombatExtraStatus(false);
	}

	if (GetACSWatcher().idleAdditiveExtraActive)
	{
		thePlayer.RaiseEvent('ACS_IdleAdditiveReset');

		GetACSWatcher().SetIdleAdditiveExtraStatus(false);
	}

	if (thePlayer.HasTag('ACS_SwordBuffAnimationPlayed'))
	{
		thePlayer.RaiseEvent('ACS_BothHandsAdditiveEnd');

		thePlayer.RemoveTag('ACS_SwordBuffAnimationPlayed');
	}

	thePlayer.RaiseEvent('ACS_KickAttackReset');

	thePlayer.RaiseEvent('ACS_TW1AnimsReset');

	animatedComponentA = (CAnimatedComponent)thePlayer.GetComponentByClassName( 'CAnimatedComponent' );

	animatedComponentA.UnfreezePose(); animatedComponentA.UnfreezePoseFadeOut(0.01f);
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

	if (GetWitcherPlayer().HasTag('ACS_Special_Dodge'))
	{
		GetWitcherPlayer().RemoveTag('ACS_Special_Dodge');
	}
}

function ACS_can_spawn_forest_god_shadows(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_forest_god_shadow_spawn_time > ACS_Settings_Main_Float('acs_events_settings','acs_shadows_spawn_delay_in_seconds', 420);
}

function ACS_refresh_forest_god_shadows_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_forest_god_shadow_spawn_time = theGame.GetEngineTimeAsSeconds();
}

/*
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
*/

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

	return theGame.GetEngineTimeAsSeconds() - property.last_wild_hunt_warriors_spawn_time > ACS_Settings_Main_Float('acs_events_settings','acs_wild_hunt_spawn_delay_in_seconds', 840);
}

function ACS_refresh_wild_hunt_warriors_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_wild_hunt_warriors_spawn_time = theGame.GetEngineTimeAsSeconds();
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

function ACS_can_spawn_nightstalker(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_nightstalker_spawn_time > ACS_Settings_Main_Float('acs_events_settings','acs_night_stalker_spawn_delay_in_seconds',840);
}

function ACS_refresh_nightstalker_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_nightstalker_spawn_time = theGame.GetEngineTimeAsSeconds();
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

function ACS_fire_gargoyle_abilities(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_fire_gargoyle_ability_time > RandRangeF(14, 7);
}

function ACS_refresh_fire_gargoyle_abilities_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_fire_gargoyle_ability_time = theGame.GetEngineTimeAsSeconds();
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

	if (ACSGetCActor('ACS_Melusine_Cloud').HasAbility('DjinnRage'))
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

function ACS_can_spawn_elderblood_assassin(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_elderblood_assassin_spawn_time > ACS_Settings_Main_Float('acs_events_settings','acs_elderblood_assassin_spawn_delay_in_seconds',220);
}

function ACS_refresh_elderblood_assassin_spawn_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_elderblood_assassin_spawn_time = theGame.GetEngineTimeAsSeconds();
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

function ACS_can_activate_sign_combo_system(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_sign_combo_system_activation_time > ACS_Settings_Main_Float('acs_sign_combo_system_settings','acs_sign_combo_system_cooldown', 10);
}

function ACS_refresh_sign_combo_system_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_sign_combo_system_activation_time = theGame.GetEngineTimeAsSeconds();
}

function ACS_can_apply_oil(): bool 
{
	var property: ACS_Cooldown_Manager;

	property = GetACSWatcher().vACS_Cooldown_Manager;

	return theGame.GetEngineTimeAsSeconds() - property.last_apply_oil_activation_time > 1;
}

function ACS_refresh_apply_oil_cooldown() 
{
	var watcher: W3ACSWatcher;

	watcher = (W3ACSWatcher)theGame.GetEntityByTag( 'acswatcher' );

	watcher.vACS_Cooldown_Manager.last_apply_oil_activation_time = theGame.GetEngineTimeAsSeconds();
}