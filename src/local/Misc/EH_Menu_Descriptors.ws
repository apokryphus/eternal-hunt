// Credits
//- Based upon code taken from the menu descriptor shared util module by Aeltoth.
//- The discovery of the events this bastardized piece of code relies on was made by [MrCementKnight](https://next.nexusmods.com/profile/MrCementKnight?gameId=952).

@addMethod(CR4IngameMenu) function ACS_onMenuEntered(menu: string, out descriptors: array<ACS_MenuDescriptor>) 
{
	if (

	/// Main Settings ///
	menu == "acs_main_settings"

	/// Combat Settings ///
	|| menu == "acs_combat_main_settings"
	|| menu == "acs_armiger_mode_settings"
	|| menu == "acs_focus_mode_settings"
	|| menu == "acs_hybrid_mode_settings"
	|| menu == "acs_parry_skills_settings"
	|| menu == "acs_target_settings"
	|| menu == "acs_custom_finishers_settings"
	|| menu == "acs_rage_mechanic_settings"
	|| menu == "acs_sign_combo_system_settings"

	/// Movement Settings ///
	|| menu == "acs_movement_main_settings"
	|| menu == "acs_default_geralt_moveset_dodge_and_roll_override_settings"
	|| menu == "acs_dodge_settings"
	|| menu == "acs_jump_settings"
	|| menu == "acs_bruxa_dash_settings"

	/// Stamina Settings ///
	|| menu == "acs_stamina_settings"

	/// Encounters Settings ///
	|| menu == "acs_encounters_enhanced_abilities_settings"
	|| menu == "acs_encounters_drop_rate_settings"
	|| menu == "acs_events_settings"
	|| menu == "acs_additional_world_encounters_settings"

	/// Damage Settings ///
	|| menu == "acs_damage_settings"

	/// Hud Settings ///
	|| menu == "acs_hud_settings_main"
	|| menu == "acs_hud_camera_settings_main"
	|| menu == "acs_hud_settings_focus_mode"
	|| menu == "acs_hud_settings_markers"

	|| menu == "acs_hud_settings_positioning_all"
	|| menu == "acs_hud_settings_positioning_buffs"
	|| menu == "acs_hud_settings_positioning_wolf_medallion"
	|| menu == "acs_hud_settings_positioning_minimap_and_quests"
	|| menu == "acs_hud_settings_positioning_item_info"
	|| menu == "acs_hud_settings_positioning_control_hints_and_action_log"
	|| menu == "acs_hud_settings_positioning_horse_stamina_and_fear_bar"
	|| menu == "acs_hud_settings_positioning_oxygen_bar_and_boat_health"
	|| menu == "acs_hud_settings_positioning_boss_and_comp"
	|| menu == "acs_hud_settings_positioning_enemy"

	/// Visual Settings ///
	|| menu == "acs_visual_main_settings"
	|| menu == "acs_player_equipment_visual_settings"
	|| menu == "acs_world_visual_settings"

	|| menu == "acs_darkness_settings_main"
	|| menu == "acs_darkness_settings_novigrad"
	|| menu == "acs_darkness_settings_skellige"
	|| menu == "acs_darkness_settings_kaer_morhen"
	|| menu == "acs_darkness_settings_white_orchard"
	|| menu == "acs_darkness_settings_wyzima"
	|| menu == "acs_darkness_settings_mist_isle"
	|| menu == "acs_darkness_settings_spiral"
	|| menu == "acs_darkness_settings_winter_white_orchard"
	|| menu == "acs_darkness_settings_toussaint"

	/// Misc Settings ///
	|| menu == "acs_misc_main_settings"
	|| menu == "acs_container_settings"
	|| menu == "acs_cbs_settings"
	|| menu == "acs_firesources_settings"
	|| menu == "acs_horse_settings"
	|| menu == "acs_item_management_settings"
	|| menu == "acs_meditation_settings"
	|| menu == "acs_player_misc_settings"
	|| menu == "acs_signs_settings"

	/// Taunt Settings ///
	|| menu == "acs_taunt_settings"

	/// Bestiary ///
	|| menu == "acs_enhanced_enemies_bestiary"
	|| menu == "acs_additional_random_encounters_bestiary"
	|| menu == "acs_additional_world_encounters_bestiary"
	|| menu == "acs_special_encounters_bestiary"
	
	/// Tutorials ///
	|| menu == "acs_additional_features_tutorials"
	|| menu == "acs_combat_tutorials"
	|| menu == "acs_item_tutorials"
	|| menu == "acs_movement_tutorials"
	|| menu == "acs_combat_arts_tutorials"
	|| menu == "acs_weapon_arts_tutorials"
	|| menu == "acs_witcher_school_tutorials"

	) 
	{
   		descriptors.PushBack(new ACS_MenuDescriptor in this);
  	}
}

class ACS_MenuDescriptor 
{
	private var option_hover_listeners					: array<ACS_MenuDescriptor_OptionDescription>;
	private var menu_scope								: string;
	private var message_fallback						: string;

	public function Main() 
	{
		/// Main Settings ///

		this.onHover(
		'acs_version_control',
		//"Displays the current version of the mod.<br/><br/>Dragging this slider to 0 will reset all of EH's settings back to factory default."
		GetLocStringById(2119545001)
		);

		CombatHover();
		
		ParrySkillsHover();
		
		FinishersHover();
		
		RageMechanicHover();
		
		SignComboHover();
		
		TargetHover();
		
		MovementHover();

		StaminaHover();
		
		EncountersHover();
		
		DamageHover();
		
		HudHover();

		CameraHover();

		TauntHover();
		
		VisualHover();
		
		MiscHover();
		
		BestiaryHover();

		TutorialHover();
	}

	function CombatHover()
	{
		/// Combat Settings ///

		this.onHover(
		'acs_weapon_mode',
		GetLocStringById(2119545002)
		);

		this.onHover(
		'acs_fist_mode',
		GetLocStringById(2119545003)
		);

		this.onHover(
		'acs_default_moveset_combat_animation_override_enabled',
		GetLocStringById(2119545005)
		);

		this.onHover(
		'acs_steel_silver_moveset_switch',
		GetLocStringById(2119545006)
		);

		this.onHover(
		'acs_adrenaline_drain',
		GetLocStringById(2119545007)
		);

		this.onHover(
		'acs_adrenaline_drain_delay',
		GetLocStringById(2119545008)
		);

		this.onHover(
		'acs_enemy_attacking_from_behind_check',
		GetLocStringById(2119545434)
		);

		this.onHover(
		'acs_enemy_attacking_from_behind_slow_mo',
		GetLocStringById(2119545435)
		);

		this.onHover(
		'acs_enable_sword_auto_sheathe',
		GetLocStringById(2119545436)
		);

		this.onHover(
		'acs_combat_stance',
		GetLocStringById(2119545009)
		);

		this.onHover(
		'acs_sneaking',
		GetLocStringById(2119545010)
		);

		this.onHover(
		'acs_hit_lag',
		GetLocStringById(2119545011)
		);

		this.onHover(
		'acs_aim_assist',
		GetLocStringById(2119545012)
		);

		this.onHover(
		'acs_air_time',
		GetLocStringById(2119545013)
		);

		this.onHover(
		'acs_phantom_attack_system',
		GetLocStringById(2118449429)
		);

		this.onHover(
		'acs_light_attack_cooldown',
		GetLocStringById(2119545015)
		);

		this.onHover(
		'acs_heavy_attack_cooldown',
		GetLocStringById(2119545016)
		);

		this.onHover(
		'acs_special_attack_cooldown',
		GetLocStringById(2119545017)
		);

		this.onHover(
		'acs_on_hit_effects',
		GetLocStringById(2119545018)
		);

		this.onHover(
		'acs_elemental_rend',
		GetLocStringById(2119545019)
		);

		/// Armiger Mode Settings ///

		this.onHover(
		'acs_armiger_mode_weapon_type',
		GetLocStringById(2119545020)
		);

		/// Focus Mode Settings ///

		this.onHover(
		'acs_focus_mode_weapon_type',
		GetLocStringById(2119545020)
		);

		/// Hybrid Mode Settings ///

		this.onHover(
		'acs_hybrid_mode_weapon_type',
		GetLocStringById(2119545020)
		);





	}

	function ParrySkillsHover()
	{
		/// Parry Skills Settings ///

		this.onHover(
		'acs_active_counter_system_enabled',
		GetLocStringById(2119545353)
		);

		this.onHover(
		'acs_normal_counter_window_for_red_health',
		GetLocStringById(2119545423)
		);

		this.onHover(
		'acs_normal_counter_window_for_silver_health',
		GetLocStringById(2119545424)
		);

		this.onHover(
		'acs_active_counter_system_slow_motion_enabled',
		GetLocStringById(2119545354)
		);

		this.onHover(
		'acs_parry_skills_enabled',
		GetLocStringById(2119545021)
		);

		this.onHover(
		'acs_counter_attack_cooldown',
		GetLocStringById(2119545022)
		);

		this.onHover(
		'acs_parry_skills_cooldown',
		GetLocStringById(2119545023)
		);

		this.onHover(
		'acs_parry_skills_doubletap_cooldown',
		GetLocStringById(2119545024)
		);

		this.onHover(
		'acs_parry_skills_bind',
		GetLocStringById(2119545566)
		);

		this.onHover(
		'acs_push_skills_bind',
		GetLocStringById(2119545567)
		);

		this.onHover(
		'acs_dagger_bind',
		GetLocStringById(2119545568)
		);

		this.onHover(
		'acs_default_moveset_human_counter_settings',
		GetLocStringById(2119545569)
		);

		this.onHover(
		'acs_default_moveset_monster_counter_settings',
		GetLocStringById(2119545570)
		);
	}

	function FinishersHover()
	{
		/// Custom Finishers Settings ///

		this.onHover(
		'acs_experimental_dismemberment_enabled',
		GetLocStringById(2119545025)
		);

		this.onHover(
		'acs_heavy_attack_always_dismember_enabled',
		GetLocStringById(2119545026)
		);

		this.onHover(
		'acs_burning_always_dismember_enabled',
		GetLocStringById(2119545027)
		);

		this.onHover(
		'acs_non_deadly_weapon_dismemberment_enabled',
		GetLocStringById(2119545413)
		);

		this.onHover(
		'acs_fist_dismemberment_enabled',
		GetLocStringById(2119545414)
		);

		this.onHover(
		'acs_sign_dismemberment_enabled',
		GetLocStringById(2119545528)
		);

		this.onHover(
		'acs_bolt_dismemberment_enabled',
		GetLocStringById(2119545529)
		);

		this.onHover(
		'acs_active_counter_combat_dismemberment_enabled',
		GetLocStringById(2119545355)
		);

		this.onHover(
		'acs_unarmed_finishers_enabled',
		GetLocStringById(2119545415)
		);

		this.onHover(
		'acs_auto_finisher_enabled',
		GetLocStringById(2119545028)
		);

		this.onHover(
		'acs_custom_finishers_enabled',
		GetLocStringById(2119545029)
		);

		this.onHover(
		'acs_custom_finisher_camera_options',
		GetLocStringById(2119545030)
		);

		this.onHover(
		'acs_custom_finisher_slow_mo_scale',
		GetLocStringById(2119545589)
		);

		this.onHover(
		'acs_dismember_slow_mo_scale',
		GetLocStringById(2119545601)
		);

		this.onHover(
		'acs_extra_vfx_on_dismember',
		GetLocStringById(2119545609)
		);

		this.onHover(
		'acs_extra_sfx_on_dismember',
		GetLocStringById(2119545610)
		);

		this.onHover(
		'acs_custom_finishers_sign_finishers_enabled',
		GetLocStringById(2119545531)
		);

		this.onHover(
		'acs_custom_finisher_chance',
		GetLocStringById(2119545031)
		);

		this.onHover(
		'acs_custom_finisher_human_chance',
		GetLocStringById(2119545419)
		);

		this.onHover(
		'acs_custom_finisher_monster_chance',
		GetLocStringById(2119545420)
		);



		this.onHover(
		'acs_custom_finishers_stab_bind',
		GetLocStringById(2119545571)
		);

		this.onHover(
		'acs_custom_finishers_torso_bind',
		GetLocStringById(2119545572)
		);

		this.onHover(
		'acs_custom_finishers_neck_bind',
		GetLocStringById(2119545573)
		);

		this.onHover(
		'acs_custom_finishers_head_left_bind',
		GetLocStringById(2119545574)
		);

		this.onHover(
		'acs_custom_finishers_head_right_bind',
		GetLocStringById(2119545575)
		);

		this.onHover(
		'acs_custom_finishers_arm_left_bind',
		GetLocStringById(2119545576)
		);

		this.onHover(
		'acs_custom_finishers_arm_right_bind',
		GetLocStringById(2119545577)
		);

		this.onHover(
		'acs_custom_finishers_leg_left_bind',
		GetLocStringById(2119545578)
		);

		this.onHover(
		'acs_custom_finishers_leg_right_bind',
		GetLocStringById(2119545579)
		);

	
	}

	function RageMechanicHover()
	{
		/// Rage Mechanic Settings ///

		this.onHover(
		'acs_rage_mechanic',
		GetLocStringById(2119545032)
		);

		this.onHover(
		'acs_number_of_enraged_enemies',
		GetLocStringById(2119545033)
		);

		this.onHover(
		'acs_rage_mechanic_cooldown',
		GetLocStringById(2119545034)
		);

		this.onHover(
		'acs_rage_mechanic_radius',
		GetLocStringById(2119545035)
		);

		this.onHover(
		'acs_rage_mechanic_player_visual_indicator_enabled',
		GetLocStringById(2119545584)
		);

		this.onHover(
		'acs_rage_mechanic_enemy_visual_indicator_enabled',
		GetLocStringById(2119545585)
		);

		this.onHover(
		'acs_rage_mechanic_audio_indicator_enabled',
		GetLocStringById(2119545586)
		);
	}

	function SignComboHover()
	{
		/// Sign Combo System Settings ///

		this.onHover(
		'acs_sign_combo_system',
		GetLocStringById(2118449162)
		);

		this.onHover(
		'acs_sign_combo_system_cooldown',
		GetLocStringById(2119545036)
		);

		this.onHover(
		'acs_sign_combo_system_max_health_damage_when_above_half_health',
		GetLocStringById(2119545037)
		);

		this.onHover(
		'acs_sign_combo_system_missing_max_health_damage_when_below_half_health',
		GetLocStringById(2119545038)
		);
	}

	function TargetHover()
	{
		/// Target Settings ///

		this.onHover(
		'acs_target_mode',
		GetLocStringById(2119545039)
		);

		this.onHover(
		'acs_target_in_frame_check',
		GetLocStringById(2119545040)
		);

		this.onHover(
		'acs_disable_camera_lock',
		GetLocStringById(2119545041)
		);

		this.onHover(
		'acs_cast_towards_camera',
		GetLocStringById(2119545042)
		);

		this.onHover(
		'acs_target_distance_max',
		GetLocStringById(2119545043)
		);

		this.onHover(
		'acs_target_distance_min',
		GetLocStringById(2119545044)
		);

		this.onHover(
		'acs_target_distance_interaction',
		GetLocStringById(2119545045)
		);

		this.onHover(
		'acs_target_camera_weight',
		GetLocStringById(2119545046)
		);

		this.onHover(
		'acs_target_movement_weight',
		GetLocStringById(2119545047)
		);

		this.onHover(
		'acs_target_facing_weight',
		GetLocStringById(2119545048)
		);

		this.onHover(
		'acs_target_distance_weight',
		GetLocStringById(2119545049)
		);

		this.onHover(
		'acs_target_hysteresis',
		GetLocStringById(2119545050)
		);
	
	}

	function MovementHover()
	{
		/// Movement Settings ///

		this.onHover(
		'acs_walking_by_default_enabled',
		GetLocStringById(2119545051)
		);

		this.onHover(
		'acs_modular_movement_speed_enabled',
		GetLocStringById(2119545582)
		);

		this.onHover(
		'acs_auto_climb_enabled',
		GetLocStringById(2119545583)
		);

		this.onHover(
		'acs_fast_walk',
		GetLocStringById(2119545052)
		);

		this.onHover(
		'acs_fast_sprint',
		GetLocStringById(2119545053)
		);

		this.onHover(
		'acs_direct_movement_enabled',
		GetLocStringById(2119545054)
		);

		this.onHover(
		'acs_encumbered_enabled',
		GetLocStringById(2119545055)
		);

		this.onHover(
		'acs_motion_leaning_enabled',
		GetLocStringById(2119545056)
		);

		this.onHover(
		'acs_slide_everywhere_enabled',
		GetLocStringById(2119545057)
		);

		///////////////////////////////////////////////////////////////////////

		this.onHover(
		'acs_default_moveset_override_dodge_enabled',
		GetLocStringById(2119545357)
		);
	
		this.onHover(
		'acs_default_moveset_override_roll_enabled',
		GetLocStringById(2119545358)
		);	

		this.onHover(
		'acs_default_moveset_override_dodge_randomized_enabled',
		GetLocStringById(2119545627)
		);

		this.onHover(
		'acs_default_moveset_override_roll_randomized_enabled',
		GetLocStringById(2119545628)
		);

		///////////////////////////////////////////////////////////////////////

		this.onHover(
		'acs_allow_attacking_while_in_dodge_animation',
		GetLocStringById(2119545359)
		);	

		this.onHover(
		'acs_allow_dodging_while_in_attack_animation',
		GetLocStringById(2119545360)
		);	

		this.onHover(
		'acs_dodge_cooldown',
		GetLocStringById(2119545361)
		);	

		this.onHover(
		'acs_slideback_dodge_cooldown',
		GetLocStringById(2119545362)
		);	

		this.onHover(
		'acs_flip_dodge_cooldown',
		GetLocStringById(2119545433)
		);	

		this.onHover(
		'acs_hold_to_roll',
		GetLocStringById(2119545363)
		);	

		this.onHover(
		'acs_exploration_dodge_enabled',
		GetLocStringById(2119545588)
		);

		this.onHover(
		'acs_combat_slide',
		GetLocStringById(2119545432)
		);	

		this.onHover(
		'acs_dodge_slowmo',
		GetLocStringById(2119545364)
		);	

		this.onHover(
		'acs_dodge_effects',
		GetLocStringById(2119545365)
		);	

		this.onHover(
		'acs_bruxa_dodge_slide_back',
		GetLocStringById(2119545367)
		);	

		this.onHover(
		'acs_wild_hunt_blink',
		GetLocStringById(2119545368)
		);	

		this.onHover(
		'acs_bruxa_leap_attack',
		GetLocStringById(2119545384)
		);	

		///////////////////////////////////////////////////////////////////////

		this.onHover(
		'acs_double_jump',
		GetLocStringById(2119545369)
		);	

		this.onHover(
		'acs_jump_extend',
		GetLocStringById(2119545371)
		);	

		this.onHover(
		'acs_jump_extend_effect',
		GetLocStringById(2119545372)
		);	

		this.onHover(
		'acs_jump_extend_normal_height',
		GetLocStringById(2119545373)
		);	

		this.onHover(
		'acs_jump_extend_normal_distance',
		GetLocStringById(2119545374)
		);	

		this.onHover(
		'acs_jump_extend_sprinting_height',
		GetLocStringById(2119545375)
		);	

		this.onHover(
		'acs_jump_extend_sprinting_distance',
		GetLocStringById(2119545376)
		);	

		this.onHover(
		'acs_jump_glide',
		GetLocStringById(2119545377)
		);	

		///////////////////////////////////////////////////////////////////////

		this.onHover(
		'acs_bruxa_dash',
		GetLocStringById(2119545378)
		);

		this.onHover(
		'acs_bruxa_dash_cooldown',
		GetLocStringById(2119545379)
		);

		this.onHover(
		'acs_bruxa_dash_sprint_or_w',
		GetLocStringById(2119545380)
		);

		this.onHover(
		'acs_bruxa_dash_input',
		GetLocStringById(2119545381)
		);

		this.onHover(
		'acs_bruxa_dash_normal_distance',
		GetLocStringById(2119545382)
		);

		this.onHover(
		'acs_bruxa_dash_combat_distance',
		GetLocStringById(2119545383)
		);

	}

	function StaminaHover()
	{
		/// Stamina Settings ///

		this.onHover(
		'acs_fast_sprint_stamina_cost_action',
		GetLocStringById(2119545385)
		);

		this.onHover(
		'acs_fast_sprint_stamina_cost',
		GetLocStringById(2119545386)
		);

		this.onHover(
		'acs_fast_sprint_stamina_regen_delay',
		GetLocStringById(2119545387)
		);

		this.onHover(
		'acs_parrying_stamina_cost_action',
		GetLocStringById(2119545388)
		);

		this.onHover(
		'acs_parrying_stamina_cost',
		GetLocStringById(2119545389)
		);

		this.onHover(
		'acs_parrying_stamina_regen_delay',
		GetLocStringById(2119545390)
		);

		this.onHover(
		'acs_stamina_cost_action',
		GetLocStringById(2119545391)
		);

		this.onHover(
		'acs_stamina_block_action',
		GetLocStringById(2119545392)
		);

		this.onHover(
		'acs_light_attack_stamina_cost',
		GetLocStringById(2119545393)
		);

		this.onHover(
		'acs_light_attack_stamina_regen_delay',
		GetLocStringById(2119545394)
		);

		this.onHover(
		'acs_heavy_attack_stamina_cost',
		GetLocStringById(2119545395)
		);

		this.onHover(
		'acs_heavy_attack_stamina_regen_delay',
		GetLocStringById(2119545396)
		);

		this.onHover(
		'acs_special_attack_stamina_cost',
		GetLocStringById(2119545397)
		);

		this.onHover(
		'acs_special_attack_stamina_regen_delay',
		GetLocStringById(2119545398)
		);

		this.onHover(
		'acs_dodge_stamina_cost',
		GetLocStringById(2119545399)
		);

		this.onHover(
		'acs_dodge_stamina_regen_delay',
		GetLocStringById(2119545400)
		);

		this.onHover(
		'acs_transformation_action_stamina_cost',
		GetLocStringById(2119545401)
		);

		this.onHover(
		'acs_transformation_action_stamina_regen_delay',
		GetLocStringById(2119545402)
		);

		this.onHover(
		'acs_azkar_stamina_cost',
		GetLocStringById(2119545403)
		);

		this.onHover(
		'acs_azkar_stamina_regen_delay',
		GetLocStringById(2119545404)
		);

	}

	function EncountersHover()
	{
		/// Encounters Settings ///

		this.onHover(
		'acs_ghoul_venom_enabled',
		GetLocStringById(2119545058)
		);

		this.onHover(
		'acs_one_handed_sword_behavior_swap_enabled',
		GetLocStringById(2119545059)
		);

		this.onHover(
		'acs_one_handed_sword_bombs_enabled',
		GetLocStringById(2119545060)
		);

		this.onHover(
		'acs_necrophage_tentacles_enabled',
		GetLocStringById(2119545061)
		);

		this.onHover(
		'acs_vampire_healing_enabled',
		GetLocStringById(2119545062)
		);

		this.onHover(
		'acs_werewolf_spawn_adds_enabled',
		GetLocStringById(2119545063)
		);

		this.onHover(
		'acs_get_acorn_spawn_chance',
		GetLocStringById(2119545064)
		);

		this.onHover(
		'acs_get_runes_and_glyph_spawn_chance',
		GetLocStringById(2119545065)
		);

		this.onHover(
		'acs_equipment_mode_steel_weapon_spawn_chance',
		GetLocStringById(2119545066)
		);

		this.onHover(
		'acs_equipment_mode_silver_weapon_spawn_chance',
		GetLocStringById(2119545067)
		);

		this.onHover(
		'acs_allow_simultaenous_events_spawning',
		GetLocStringById(2119545068)
		);

		this.onHover(
		'acs_event_delay_minimum_time_in_seconds',
		GetLocStringById(2119545069)
		);

		this.onHover(
		'acs_event_delay_maximum_time_in_seconds',
		GetLocStringById(2119545070)
		);

		this.onHover(
		'acs_elderblood_assassin_spawn_chances_normal',
		GetLocStringById(2119545071)
		);

		this.onHover(
		'acs_elderblood_assassin_spawn_delay_in_seconds',
		GetLocStringById(2119545072)
		);

		this.onHover(
		'acs_shadows_spawn_chances_normal',
		GetLocStringById(2119545073)
		);

		this.onHover(
		'acs_shadows_spawn_delay_in_seconds',
		GetLocStringById(2119545074)
		);

		this.onHover(
		'acs_night_stalker_spawn_chances_normal',
		GetLocStringById(2119545075)
		);

		this.onHover(
		'acs_night_stalker_spawn_delay_in_seconds',
		GetLocStringById(2119545076)
		);

		this.onHover(
		'acs_wild_hunt_spawn_chances_normal',
		GetLocStringById(2119545077)
		);

		this.onHover(
		'acs_wild_hunt_spawn_delay_in_seconds',
		GetLocStringById(2119545078)
		);

		this.onHover(
		'acs_monster_spawn_in_frame',
		GetLocStringById(2119545079)
		);

		this.onHover(
		'acs_monster_spawn_distance',
		GetLocStringById(2119545080)
		);

		this.onHover(
		'acs_monster_spawn_use_global',
		GetLocStringById(2119545081)
		);

		this.onHover(
		'acs_monster_spawn_global_chance',
		GetLocStringById(2119545082)
		);

		this.onHover(
		'acs_rat_mage_encounter_enabled',
		GetLocStringById(2119545083)
		);

		this.onHover(
		'acs_ancient_red_miasmal_encounter_enabled',
		GetLocStringById(2119545084)
		);

		this.onHover(
		'acs_bauk_encounter_enabled',
		GetLocStringById(2119545085)
		);

		this.onHover(
		'acs_barbegazi_encounter_enabled',
		GetLocStringById(2119545086)
		);

		this.onHover(
		'acs_forest_god_encounter_enabled',
		GetLocStringById(2119545087)
		);

		this.onHover(
		'acs_blood_hym_encounter_enabled',
		GetLocStringById(2119545088)
		);

		this.onHover(
		'acs_botchling_encounter_enabled',
		GetLocStringById(2119545089)
		);

		this.onHover(
		'acs_bumbakvetch_encounter_enabled',
		GetLocStringById(2119545090)
		);

		this.onHover(
		'acs_lynx_witcher_encounter_enabled',
		GetLocStringById(2119545091)
		);

		this.onHover(
		'acs_dracogryph_encounter_enabled',
		GetLocStringById(2119545418)
		);

		this.onHover(
		'acs_doppler_encounter_enabled',
		GetLocStringById(2119545092)
		);

		this.onHover(
		'acs_fire_bear_altar_encounter_enabled',
		GetLocStringById(2119545093)
		);

		this.onHover(
		'acs_manticore_encounter_enabled',
		GetLocStringById(2119545094)
		);

		this.onHover(
		'acs_chironex_encounter_enabled',
		GetLocStringById(2119545095)
		);

		this.onHover(
		'acs_cloaked_vamp_encounter_enabled',
		GetLocStringById(2119545096)
		);

		this.onHover(
		'acs_corpse_lily_encounter_enabled',
		GetLocStringById(2119545097)
		);

		this.onHover(
		'acs_crossbow_dwarves_encounter_enabled',
		GetLocStringById(2119545098)
		);

		this.onHover(
		'acs_cultists_encounter_enabled',
		GetLocStringById(2119545099)
		);

		this.onHover(
		'acs_dao_encounter_enabled',
		GetLocStringById(2119545100)
		);

		this.onHover(
		'acs_dark_knight_encounter_enabled',
		GetLocStringById(2119545101)
		);

		this.onHover(
		'acs_demonic_construct_encounter_enabled',
		GetLocStringById(2119545102)
		);

		this.onHover(
		'acs_draug_encounter_enabled',
		GetLocStringById(2119545103)
		);

		this.onHover(
		'acs_draugir_encounters_enabled',
		GetLocStringById(2119545104)
		);

		this.onHover(
		'acs_dullahan_encounter_enabled',
		GetLocStringById(2119545105)
		);

		this.onHover(
		'acs_duskwraith_encounter_enabled',
		GetLocStringById(2119545106)
		);

		this.onHover(
		'acs_elemental_titan_encounter_enabled',
		GetLocStringById(2119545107)
		);

		this.onHover(
		'acs_big_lizard_encounter_enabled',
		GetLocStringById(2119545108)
		);

		this.onHover(
		'acs_fog_assassin_encounter_enabled',
		GetLocStringById(2119545109)
		);

		this.onHover(
		'acs_vigilosaur_encounter_enabled',
		GetLocStringById(2119545110)
		);

		this.onHover(
		'acs_frost_boar_encounter_enabled',
		GetLocStringById(2119545111)
		);

		this.onHover(
		'acs_ice_titans_encounter_enabled',
		GetLocStringById(2119545112)
		);

		this.onHover(
		'acs_fluffy_encounter_enabled',
		GetLocStringById(2119545113)
		);

		this.onHover(
		'acs_giant_troll_encounter_enabled',
		GetLocStringById(2119545114)
		);

		this.onHover(
		'acs_heart_of_darkness_enabled',
		GetLocStringById(2119545115)
		);

		this.onHover(
		'acs_harpy_queen_encounter_enabled',
		GetLocStringById(2119545116)
		);

		this.onHover(
		'acs_the_beast_encounter_enabled',
		GetLocStringById(2119545117)
		);

		this.onHover(
		'acs_ifrit_encounter_enabled',
		GetLocStringById(2119545118)
		);

		this.onHover(
		'acs_incubus_encounter_enabled',
		GetLocStringById(211954519)
		);

		this.onHover(
		'acs_iridescent_sharley_encounter_enabled',
		GetLocStringById(2119545120)
		);

		this.onHover(
		'acs_kikimore_queen_encounter_enabled',
		GetLocStringById(2119545121)
		);

		this.onHover(
		'acs_knightmare_lesser_encounter_enabled',
		GetLocStringById(2119545122)
		);

		this.onHover(
		'acs_knightmare_encounter_enabled',
		GetLocStringById(2119545123)
		);

		this.onHover(
		'acs_knocker_encounter_enabled',
		GetLocStringById(2119545124)
		);

		this.onHover(
		'acs_she_who_knows_encounter_enabled',
		GetLocStringById(2119545125)
		);

		this.onHover(
		'acs_maerolorn_encounter_enabled',
		GetLocStringById(2119545126)
		);

		this.onHover(
		'acs_melusine_encounter_enabled',
		GetLocStringById(2119545127)
		);

		this.onHover(
		'acs_mimic_encounter_enabled',
		GetLocStringById(2119545128)
		);

		this.onHover(
		'acs_mula_encounter_enabled',
		GetLocStringById(2119545129)
		);

		this.onHover(
		'acs_naga_encounter_enabled',
		GetLocStringById(2119545507)
		);

		this.onHover(
		'acs_fire_gargoyle_encounter_enabled',
		GetLocStringById(2119545130)
		);

		this.onHover(
		'acs_necrofiend_encounter_enabled',
		GetLocStringById(2119545131)
		);

		this.onHover(
		'acs_nekker_guardian_encounter_enabled',
		GetLocStringById(2119545132)
		);

		this.onHover(
		'acs_nekurat_encounter_enabled',
		GetLocStringById(2119545133)
		);

		this.onHover(
		'acs_nimean_panther_encounter_enabled',
		GetLocStringById(2119545134)
		);

		this.onHover(
		'acs_mega_wraith_encounter_enabled',
		GetLocStringById(2119545135)
		);

		this.onHover(
		'acs_fire_gryphon_encounter_enabled',
		GetLocStringById(2119545136)
		);

		this.onHover(
		'acs_kayran_encounter_enabled',
		GetLocStringById(2119545137)
		);

		this.onHover(
		'acs_phooca_encounter_enabled',
		GetLocStringById(2119545138)
		);

		this.onHover(
		'acs_plumard_encounter_enabled',
		GetLocStringById(2119545139)
		);

		this.onHover(
		'acs_shadow_pixies_encounter_enabled',
		GetLocStringById(2119545140)
		);

		this.onHover(
		'acs_rat_king_encounter_enabled',
		GetLocStringById(2119545141)
		);

		this.onHover(
		'acs_mages_encounter_enabled',
		GetLocStringById(2119545142)
		);

		this.onHover(
		'acs_pirate_zombie_encounter_enabled',
		GetLocStringById(2119545143)
		);

		this.onHover(
		'acs_fregenals_triangle_encounter_enabled',
		GetLocStringById(2119545144)
		);

		this.onHover(
		'acs_fungoid_encounter_enabled',
		GetLocStringById(2119545625)
		);

		this.onHover(
		'acs_shade_encounter_enabled',
		GetLocStringById(2119545530)
		);

		this.onHover(
		'acs_dual_wield_elves_encounter_enabled',
		GetLocStringById(2119545542)
		);

		this.onHover(
		'acs_svalblod_encounter_enabled',
		GetLocStringById(2119545145)
		);

		this.onHover(
		'acs_swarm_mother_encounter_enabled',
		GetLocStringById(2119545146)
		);

		this.onHover(
		'acs_wicked_witch_encounter_enabled',
		GetLocStringById(2119545147)
		);

		this.onHover(
		'acs_ungoliant_encounter_enabled',
		GetLocStringById(2119545148)
		);

		this.onHover(
		'acs_vendigo_encounter_enabled',
		GetLocStringById(2119545149)
		);

		this.onHover(
		'acs_berserkers_encounter_enabled',
		GetLocStringById(2119545150)
		);

		this.onHover(
		'acs_viy_of_maribor_encounter_enabled',
		GetLocStringById(2119545151)
		);

		this.onHover(
		'acs_voref_encounter_enabled',
		GetLocStringById(2119545152)
		);

		this.onHover(
		'acs_xeno_tyrant_eggs_encounter_enabled',
		GetLocStringById(2119545153)
		);

		this.onHover(
		'acs_shades_crusaders_encounter_enabled',
		GetLocStringById(2119545154)
		);

		this.onHover(
		'acs_shades_hunters_encounter_enabled',
		GetLocStringById(2119545155)
		);

		this.onHover(
		'acs_shades_rogues_encounter_enabled',
		GetLocStringById(2119545156)
		);

		this.onHover(
		'acs_shades_showdown_encounter_enabled',
		GetLocStringById(2119545157)
		);

		this.onHover(
		'acs_shades_dancer_waxing_encounter_enabled',
		GetLocStringById(2119545158)
		);

		this.onHover(
		'acs_shades_dancer_waning_encounter_enabled',
		GetLocStringById(2119545159)
		);

		this.onHover(
		'acs_shades_kara_encounter_enabled',
		GetLocStringById(2119545160)
		);

		this.onHover(
		'acs_shades_nightmare_incarnate_encounter_enabled',
		GetLocStringById(2119545161)
		);

		this.onHover(
		'acs_bullvore_encounter_enabled',
		GetLocStringById(2119545416)
		);

		this.onHover(
		'acs_arachne_encounter_enabled',
		GetLocStringById(2119545417)
		);

		this.onHover(
		'acs_vodyanoi_encounter_enabled',
		GetLocStringById(2119545524)
		);
		
		this.onHover(
		'acs_night_witch_encounter_enabled',
		GetLocStringById(2119545526)
		);

		this.onHover(
		'acs_strzyga_encounter_enabled',
		GetLocStringById(2119545603)
		);
	}

	function DamageHover()
	{
		/// Damage Settings ///

		this.onHover(
		'acs_player_fall_damage',
		GetLocStringById(2119545162)
		);

		this.onHover(
		'acs_player_damage_multiplier',
		GetLocStringById(2119545163)
		);

		this.onHover(
		'acs_player_damage_taken_multiplier',
		GetLocStringById(2119545164)
		);

		this.onHover(
		'acs_ciri_damage_multiplier',
		GetLocStringById(2119545437)
		);

		this.onHover(
		'acs_ciri_damage_taken_multiplier',
		GetLocStringById(2119545438)
		);

		this.onHover(
		'acs_enemy_health_multiplier',
		GetLocStringById(2119545165)
		);

		this.onHover(
		'acs_crossbow_damage_max_health_or_current_health',
		GetLocStringById(2119545166)
		);

		this.onHover(
		'acs_crossbow_human_max_damage',
		GetLocStringById(2119545167)
		);

		this.onHover(
		'acs_crossbow_human_min_damage',
		GetLocStringById(2119545168)
		);

		this.onHover(
		'acs_crossbow_monster_max_damage',
		GetLocStringById(2119545169)
		);

		this.onHover(
		'acs_crossbow_monster_min_damage',
		GetLocStringById(2119545170)
		);

		this.onHover(
		'acs_vampire_claws_damage_max_health_or_current_health',
		GetLocStringById(2119545171)
		);

		this.onHover(
		'acs_vampire_claws_human_max_damage',
		GetLocStringById(2119545172)
		);

		this.onHover(
		'acs_vampire_claws_human_min_damage',
		GetLocStringById(2119545173)
		);

		this.onHover(
		'acs_vampire_claws_monster_max_damage',
		GetLocStringById(2119545174)
		);

		this.onHover(
		'acs_vampire_claws_monster_min_damage',
		GetLocStringById(2119545175)
		);


		this.onHover(
		'acs_fist_damage_multiplier',
		GetLocStringById(2119545595)
		);

	
	}

	function HudHover()
	{
		/// Hud Settings ///

		this.onHover(
		'acs_interaction_module_enabled',
		GetLocStringById(2119545176)
		);

		this.onHover(
		'acs_minimap_simplified',
		GetLocStringById(2119545177)
		);

		///

		this.onHover(
		'acs_wolfs_head_hud_module_enabled',
		GetLocStringById(2119545613)
		);

		this.onHover(
		'acs_minimap_module_enabled',
		GetLocStringById(2119545614)
		);

		this.onHover(
		'acs_item_info_module_enabled',
		GetLocStringById(2119545615)
		);

		this.onHover(
		'acs_controls_hint_module_enabled',
		GetLocStringById(2119545616)
		);
		
		///

		this.onHover(
		'acs_hud_elements_despawn_delay',
		GetLocStringById(2119545178)
		);

		this.onHover(
		'acs_hud_animation_enabled',
		GetLocStringById(2119545179)
		);

		this.onHover(
		'acs_nearby_poi_detection_effect_range',
		GetLocStringById(2119545180)
		);

		this.onHover(
		'acs_player_floating_markers_enabled',
		GetLocStringById(2119545596)
		);

		this.onHover(
		'acs_floating_markers_only_show_buffs_enabled',
		GetLocStringById(2119545619)
		);

		this.onHover(
		'acs_heal_floating_markers_refresh_rate_per_second',
		GetLocStringById(2119545597)
		);

		this.onHover(
		'acs_dot_damage_floating_markers_refresh_rate_per_second',
		GetLocStringById(2119545598)
		);

		this.onHover(
		'acs_guiding_wind_enabled',
		GetLocStringById(2119545425)
		);

		this.onHover(
		'acs_guiding_wind_sound_enabled',
		GetLocStringById(2119545426)
		);

		this.onHover(
		'acs_guiding_wind_reset_delay',
		GetLocStringById(2119545427)
		);

		this.onHover(
		'acs_guiding_wind_particle_type',
		GetLocStringById(2119545428)
		);

		this.onHover(
		'acs_guiding_wind_particle_amount',
		GetLocStringById(2119545429)
		);

		this.onHover(
		'acs_guiding_light_enabled',
		GetLocStringById(2119545181)
		);

		this.onHover(
		'acs_better_icons_compatibility_enabled',
		GetLocStringById(2119545182)
		);

	
		/// 3D Compass & Markers Settings ///

		this.onHover(
		'acs_compass_or_floating_3d_markers',
		GetLocStringById(2119545187)
		);

		this.onHover(
		'acs_compass_bar_size',
		GetLocStringById(2119545563)
		);

		this.onHover(
		'acs_compass_bar_despawn_delay',
		GetLocStringById(2119545189)
		);

		this.onHover(
		'acs_guiding_light_distance_marker_show_only_in_witcher_sense_enabled',
		GetLocStringById(2119545190)
		);

		this.onHover(
		'acs_marker_bubble_enabled',
		GetLocStringById(2119545191)
		);

		this.onHover(
		'acs_clue_icon_enabled',
		GetLocStringById(2119545637)
		);

		this.onHover(
		'acs_quest_marker_despawn_delay',
		GetLocStringById(2119545192)
		);

		this.onHover(
		'acs_quest_marker_distance_to_display',
		GetLocStringById(2119545193)
		);

		this.onHover(
		'acs_untracked_quest_marker_despawn_delay',
		GetLocStringById(2119545194)
		);

		this.onHover(
		'acs_untracked_quest_marker_distance_to_display',
		GetLocStringById(2119545195)
		);

		this.onHover(
		'acs_poi_marker_despawn_delay',
		GetLocStringById(2119545196)
		);

		this.onHover(
		'acs_poi_marker_distance_to_display',
		GetLocStringById(2119545197)
		);

		this.onHover(
		'acs_enemy_marker_despawn_delay',
		GetLocStringById(2119545198)
		);

		this.onHover(
		'acs_enemy_marker_distance_to_display',
		GetLocStringById(2119545199)
		);

		this.onHover(
		'acs_merchant_marker_distance_to_display',
		GetLocStringById(2119545621)
		);

		this.onHover(
		'acs_merchant_marker_despawn_delay',
		GetLocStringById(2119545622)
		);

		this.onHover(
		'acs_horse_marker_despawn_delay',
		GetLocStringById(2119545200)
		);

		this.onHover(
		'acs_horse_marker_distance_to_display',
		GetLocStringById(2119545201)
		);

		this.onHover(
		'acs_user_pin_marker_despawn_delay',
		GetLocStringById(2119545202)
		);

		this.onHover(
		'acs_3D_loot_popups_enabled',
		GetLocStringById(2119545203)
		);

		this.onHover(
		'acs_3D_loot_popups_size',
		GetLocStringById(2119545204)
		);

		this.onHover(
		'acs_3D_loot_popups_coloring_enabled',
		GetLocStringById(2119545205)
		);

		this.onHover(
		'acs_3d_markers_refresh_rate',
		GetLocStringById(2119545602)
		);
	
	}

	function CameraHover()
	{
		/// Camera Settings ///

		this.onHover(
		'acs_custom_camera_positioning_enabled',
		GetLocStringById(2119545464)
		);

		this.onHover(
		'acs_custom_camera_positioning_camera_close_x',
		GetLocStringById(2119545465)
		);

		this.onHover(
		'acs_custom_camera_positioning_camera_close_y',
		GetLocStringById(2119545466)
		);

		this.onHover(
		'acs_custom_camera_positioning_camera_close_z',
		GetLocStringById(2119545467)
		);

		this.onHover(
		'acs_custom_camera_positioning_camera_default_x',
		GetLocStringById(2119545468)
		);

		this.onHover(
		'acs_custom_camera_positioning_camera_default_y',
		GetLocStringById(2119545469)
		);

		this.onHover(
		'acs_custom_camera_positioning_camera_default_z',
		GetLocStringById(2119545470)
		);



		this.onHover(
		'acs_custom_combat_camera_positioning_enabled',
		GetLocStringById(2119545478)
		);

		this.onHover(
		'acs_custom_camera_positioning_combat_camera_close_x',
		GetLocStringById(2119545479)
		);

		this.onHover(
		'acs_custom_camera_positioning_combat_camera_close_y',
		GetLocStringById(2119545480)
		);

		this.onHover(
		'acs_custom_camera_positioning_combat_camera_close_z',
		GetLocStringById(2119545481)
		);

		this.onHover(
		'acs_custom_camera_positioning_combat_camera_default_x',
		GetLocStringById(2119545482)
		);

		this.onHover(
		'acs_custom_camera_positioning_combat_camera_default_y',
		GetLocStringById(2119545483)
		);

		this.onHover(
		'acs_custom_camera_positioning_combat_camera_default_z',
		GetLocStringById(2119545484)
		);



		this.onHover(
		'acs_custom_horse_camera_positioning_enabled',
		GetLocStringById(2119545485)
		);

		this.onHover(
		'acs_custom_camera_positioning_horse_camera_close_x',
		GetLocStringById(2119545486)
		);

		this.onHover(
		'acs_custom_camera_positioning_horse_camera_close_y',
		GetLocStringById(2119545487)
		);

		this.onHover(
		'acs_custom_camera_positioning_horse_camera_close_z',
		GetLocStringById(2119545488)
		);

		this.onHover(
		'acs_custom_camera_positioning_horse_camera_default_x',
		GetLocStringById(2119545489)
		);

		this.onHover(
		'acs_custom_camera_positioning_horse_camera_default_y',
		GetLocStringById(2119545490)
		);

		this.onHover(
		'acs_custom_camera_positioning_horse_camera_default_z',
		GetLocStringById(2119545491)
		);

		this.onHover(
		'acs_custom_camera_x_offset_adjust_strength',
		GetLocStringById(2119545492)
		);

		this.onHover(
		'acs_dynamic_camera_positioning_enabled',
		GetLocStringById(2119545508)
		);

		this.onHover(
		'acs_custom_camera_tilt_strength',
		GetLocStringById(2119545523)
		);

		this.onHover(
		'acs_custom_camera_positioning_vehicle_camera_close_x',
		GetLocStringById(2119545499)
		);

		this.onHover(
		'acs_custom_camera_positioning_vehicle_camera_close_y',
		GetLocStringById(2119545500)
		);

		this.onHover(
		'acs_custom_camera_positioning_vehicle_camera_close_z',
		GetLocStringById(2119545501)
		);

		this.onHover(
		'acs_custom_camera_positioning_vehicle_camera_default_x',
		GetLocStringById(2119545502)
		);

		this.onHover(
		'acs_custom_camera_positioning_vehicle_camera_default_y',
		GetLocStringById(2119545503)
		);

		this.onHover(
		'acs_custom_camera_positioning_vehicle_camera_default_y',
		GetLocStringById(2119545504)
		);


		this.onHover(
		'acs_light_attack_camera_shake_strength',
		GetLocStringById(2116581314)
		);

		this.onHover(
		'acs_heavy_attack_camera_shake_strength',
		GetLocStringById(2116581315)
		);

		this.onHover(
		'acs_player_light_attack_take_damage_camera_shake_strength',
		GetLocStringById(2116581316)
		);

		this.onHover(
		'acs_player_heavy_attack_take_damage_camera_shake_strength',
		GetLocStringById(2116581317)
		);

		this.onHover(
		'acs_attack_guarded_camera_shake_strength',
		GetLocStringById(2116581318)
		);

		this.onHover(
		'acs_attack_countered_camera_shake_strength',
		GetLocStringById(2116581319)
		);



		this.onHover(
		'acs_exploration_fov',
		GetLocStringById(2119545493)
		);

		this.onHover(
		'acs_combat_fov',
		GetLocStringById(2119545494)
		);

		this.onHover(
		'acs_horse_fov',
		GetLocStringById(2119545495)
		);

		this.onHover(
		'acs_vehicle_fov',
		GetLocStringById(2119545497)
		);

		/// Witcher Sense Settings ///

		this.onHover(
		'acs_focus_mode_toggle_enabled',
		GetLocStringById(2119545184)
		);

		this.onHover(
		'acs_focus_mode_intensity',
		GetLocStringById(2119545185)
		);

		this.onHover(
		'acs_custom_focus_env_enabled',
		GetLocStringById(2119545186)
		);

		this.onHover(
		'acs_custom_focus_mode_camera_enabled',
		GetLocStringById(2119545471)
		);

		this.onHover(
		'acs_custom_focus_mode_camera_positioning_close_x',
		GetLocStringById(2119545472)
		);

		this.onHover(
		'acs_custom_focus_mode_camera_positioning_close_y',
		GetLocStringById(2119545473)
		);

		this.onHover(
		'acs_custom_focus_mode_camera_positioning_close_z',
		GetLocStringById(2119545474)
		);

		this.onHover(
		'acs_custom_focus_mode_camera_positioning_default_x',
		GetLocStringById(2119545475)
		);

		this.onHover(
		'acs_custom_focus_mode_camera_positioning_default_y',
		GetLocStringById(2119545476)
		);

		this.onHover(
		'acs_custom_focus_mode_camera_positioning_default_z',
		GetLocStringById(2119545477)
		);

		this.onHover(
		'acs_custom_focus_mode_camera_x_offset_adjust_strength',
		GetLocStringById(2119545492)
		);

		this.onHover(
		'acs_focus_mode_fov',
		GetLocStringById(2119545496)
		);
	}

	function TauntHover()
	{
		/// Taunt Settings ///

		this.onHover(
		'acs_passive_taunt_enabled',
		GetLocStringById(2119545206)
		);

		this.onHover(
		'acs_sword_flair',
		GetLocStringById(2119545207)
		);

		this.onHover(
		'acs_finisher_taunt_chance',
		GetLocStringById(2119545208)
		);

		this.onHover(
		'acs_taunt_system_enabled',
		GetLocStringById(2119545209)
		);

		this.onHover(
		'acs_i_wanna_play_gwent_enabled',
		GetLocStringById(2119545210)
		);

		this.onHover(
		'acs_equip_taunt_enabled',
		GetLocStringById(2119545211)
		);

		this.onHover(
		'acs_combat_taunt_enabled',
		GetLocStringById(2119545212)
		);
	}

	function VisualHover()
	{
		/// Visual Settings ///

		this.onHover(
		'acs_fog_spawn_enabled',
		GetLocStringById(2119545213)
		);

		this.onHover(
		'acs_horse_riders_enabled',
		GetLocStringById(2119545214)
		);

		this.onHover(
		'acs_crow_swarm_enabled',
		GetLocStringById(2119545215)
		);

		this.onHover(
		'acs_everstorm_enabled',
		GetLocStringById(2119545216)
		);

		this.onHover(
		'acs_additional_weather_env_enabled',
		GetLocStringById(2119545410)
		);

		this.onHover(
		'acs_spiral_sky_sun_enabled',
		GetLocStringById(2119545217)
		);

		this.onHover(
		'acs_spiral_sky_moon_enabled',
		GetLocStringById(2119545218)
		);

		this.onHover(
		'acs_spiral_sky_water_enabled',
		GetLocStringById(2119545219)
		);

		this.onHover(
		'acs_spiral_sky_grass_enabled',
		GetLocStringById(2119545220)
		);

		this.onHover(
		'acs_spiral_sky_planets_enabled',
		GetLocStringById(2119545221)
		);

		this.onHover(
		'acs_spiral_sky_bands_enabled',
		GetLocStringById(2119545222)
		);

		this.onHover(
		'acs_spiral_sky_stars_enabled',
		GetLocStringById(2119545223)
		);

		this.onHover(
		'acs_spiral_sky_clouds_enabled',
		GetLocStringById(2119545422)
		);

		this.onHover(
		'acs_lightning_strike_enabled',
		GetLocStringById(2119545560)
		);

		this.onHover(
		'acs_lightning_strike_delay_min',
		GetLocStringById(2119545561)
		);

		this.onHover(
		'acs_lightning_strike_delay_max',
		GetLocStringById(2119545562)
		);

		this.onHover(
		'acs_dof_enabled',
		GetLocStringById(2119545439)
		);

		this.onHover(
		'acs_dof_near_blur_dist',
		GetLocStringById(2119545441)
		);

		this.onHover(
		'acs_dof_near_focus_dist',
		GetLocStringById(2119545442)
		);

		this.onHover(
		'acs_dof_far_blur_dist',
		GetLocStringById(2119545443)
		);

		this.onHover(
		'acs_dof_far_focus_dist',
		GetLocStringById(2119545444)
		);

		this.onHover(
		'acs_dof_activated_sky_threshold_enabled',
		GetLocStringById(2119545445)
		);

		this.onHover(
		'acs_dof_activated_sky_range_enabled',
		GetLocStringById(2119545446)
		);

		this.onHover(
		'acs_dof_sky_range',
		GetLocStringById(2119545447)
		);

		this.onHover(
		'acs_dof_blend',
		GetLocStringById(2119545440)
		);

		this.onHover(
		'acs_spiral_sky_fish_enabled',
		GetLocStringById(2119545224)
		);

		this.onHover(
		'acs_player_scale',
		GetLocStringById(2119545225)
		);

		this.onHover(
		'acs_additional_armor_pieces_enabled',
		GetLocStringById(2119545226)
		);

		this.onHover(
		'acs_swords_on_hip_for_additional_armors',
		GetLocStringById(2119545227)
		);

		this.onHover(
		'acs_swords_positioning_when_cloaked',
		GetLocStringById(2119545228)
		);

		this.onHover(
		'acs_hide_sword_sheathes',
		GetLocStringById(2119545229)
		);

		this.onHover(
		'acs_unequip_cloak_while_in_combat',
		GetLocStringById(2119545230)
		);

		this.onHover(
		'acs_fur_cloak_options',
		GetLocStringById(2119545231)
		);

		this.onHover(
		'acs_player_effects',
		GetLocStringById(2119545232)
		);

		this.onHover(
		'acs_disable_critical_low_health',
		GetLocStringById(2119545233)
		);

		this.onHover(
		'acs_iconic_sword_vfx',
		GetLocStringById(2119545234)
		);

		this.onHover(
		'acs_additional_blood_spatter_enabled',
		GetLocStringById(2119545235)
		);

		this.onHover(
		'acs_directional_slash_effects_enabled',
		GetLocStringById(2119545509)
		);

		this.onHover(
		'acs_additional_blood_covered_effect_enabled',
		GetLocStringById(2119545421)
		);

		this.onHover(
		'acs_gore_spawner_enabled',
		GetLocStringById(2119545236)
		);

		this.onHover(
		'acs_ice_breath_enabled',
		GetLocStringById(2119545564)
		);

		this.onHover(
		'acs_rain_water_droplets_enabled',
		GetLocStringById(2119545565)
		);

		this.onHover(
		'acs_enable_camera_lights_in_cutscenes',
		GetLocStringById(2119545606)
		);




		this.onHover(
		'acs_idd_enabled',
		GetLocStringById(2119545448)
		);

		this.onHover(
		'acs_idd_enable_ultra',
		GetLocStringById(2119545449)
		);

		this.onHover(
		'acs_idd_overall_draw_dist',
		GetLocStringById(2119545450)
		);

		this.onHover(
		'acs_idd_overall_lod_dist',
		GetLocStringById(2119545451)
		);


		this.onHover(
		'acs_idd_arc_override_draw_dist',
		GetLocStringById(2119545452)
		);

		this.onHover(
		'acs_idd_arc_draw_dist',
		GetLocStringById(2119545453)
		);

		this.onHover(
		'acs_idd_arc_override_lod_dist',
		GetLocStringById(2119545454)
		);

		this.onHover(
		'acs_idd_arc_lod_dist',
		GetLocStringById(2119545455)
		);


		this.onHover(
		'acs_idd_deco_override_draw_dist',
		GetLocStringById(2119545456)
		);

		this.onHover(
		'acs_idd_deco_draw_dist',
		GetLocStringById(2119545457)
		);

		this.onHover(
		'acs_idd_deco_override_lod_dist',
		GetLocStringById(2119545458)
		);

		this.onHover(
		'acs_idd_deco_lod_dist',
		GetLocStringById(2119545459)
		);


		this.onHover(
		'acs_idd_veg_override_draw_dist',
		GetLocStringById(2119545460)
		);

		this.onHover(
		'acs_idd_veg_draw_dist',
		GetLocStringById(2119545461)
		);

		this.onHover(
		'acs_idd_veg_override_lod_dist',
		GetLocStringById(2119545462)
		);

		this.onHover(
		'acs_idd_veg_lod_dist',
		GetLocStringById(2119545463)
		);



		this.onHover(
		'acs_wearable_pocket_items_enabled',
		GetLocStringById(2119545237)
		);

		this.onHover(
		'acs_wearable_pocket_items_positioning',
		GetLocStringById(2119545238)
		);

		this.onHover(
		'acs_wearable_bombs_enabled',
		GetLocStringById(2119545239)
		);

		this.onHover(
		'acs_wearable_bombs_positioning',
		GetLocStringById(2119545240)
		);

		this.onHover(
		'acs_swords_on_roach_enabled',
		GetLocStringById(2119545241)
		);

		this.onHover(
		'acs_swords_on_roach_positioning',
		GetLocStringById(2119545242)
		);

		this.onHover(
		'acs_crossbow_on_roach_positioning',
		GetLocStringById(2119545243)
		);

		this.onHover(
		'acs_alternate_scabbard_steel_enabled',
		GetLocStringById(2119545244)
		);

		this.onHover(
		'acs_alternate_scabbard_silver_enabled',
		GetLocStringById(2119545245)
		);

		this.onHover(
		'acs_alternate_scabbard_steel_style',
		GetLocStringById(2119545545)
		);

		this.onHover(
		'acs_alternate_scabbard_silver_style',
		GetLocStringById(2119545546)
		);

		this.onHover(
		'acs_permanent_rune_glow',
		GetLocStringById(2119545544)
		);

		this.onHover(
		'DynamicDecalsLimit',
		GetLocStringById(2119545246)
		);

		this.onHover(
		'DynamicDecalsChunkLimit',
		GetLocStringById(2119545247)
		);

		this.onHover(
		'DecalBudget',
		GetLocStringById(2119545248)
		);

		this.onHover(
		'acs_disable_big_camera_lights',
		GetLocStringById(2119545249)
		);

		this.onHover(
		'acs_disable_small_camera_lights',
		GetLocStringById(2119545250)
		);

		this.onHover(
		'acs_disable_all_camera_lights',
		GetLocStringById(2119545251)
		);


	
	}

	function MiscHover()
	{
		/// Misc Settings ///

		this.onHover(
		'acs_cbs_apparel',
		GetLocStringById(2119545252)
		);

		this.onHover(
		'acs_cbs_wep',
		GetLocStringById(2119545253)
		);

		this.onHover(
		'acs_cbs_qs',
		GetLocStringById(2119545254)
		);

		this.onHover(
		'acs_cbs_bomb',
		GetLocStringById(2119545255)
		);

		this.onHover(
		'acs_cbs_pot',
		GetLocStringById(2119545256)
		);

		this.onHover(
		'acs_cbs_hair',
		GetLocStringById(2119545257)
		);

		this.onHover(
		'acs_cbs_beard',
		GetLocStringById(2119545258)
		);

		this.onHover(
		'acs_cbs_stash',
		GetLocStringById(2119545259)
		);

		this.onHover(
		'acs_cbs_notif',
		GetLocStringById(2119545260)
		);

		this.onHover(
		'acs_startup_videos_enabled',
		GetLocStringById(2119545261)
		);

		this.onHover(
		'acs_hide_mount_prompt',
		GetLocStringById(2119545534)
		);

		this.onHover(
		'acs_hide_counter_wound_prompt',
		GetLocStringById(2119545535)
		);

		this.onHover(
		'acs_hide_crossbow_aim_marker',
		GetLocStringById(2119545556)
		);

		this.onHover(
		'acs_hide_bomb_aim_marker',
		GetLocStringById(2119545557)
		);

		this.onHover(
		'acs_prologue_vanilla_tut_dialog_option_enabled',
		GetLocStringById(2119545262)
		);

		this.onHover(
		'acs_quick_items_menu_enabled',
		GetLocStringById(2119545263)
		);

		this.onHover(
		'acs_skip_container_popup_enabled',
		GetLocStringById(2119545264)
		);

		this.onHover(
		'acs_herb_container_popup_enabled',
		GetLocStringById(2119545265)
		);

		this.onHover(
		'acs_looting_anim_enabled',
		GetLocStringById(2119545266)
		);

		this.onHover(
		'acs_extended_remains_looting_anim_enabled',
		GetLocStringById(2119545267)
		);

		this.onHover(
		'acs_container_take_all_skip_junk_enabled',
		GetLocStringById(2119545268)
		);

		this.onHover(
		'acs_container_take_all_skip_readable_enabled',
		GetLocStringById(2119545269)
		);

		this.onHover(
		'acs_container_take_all_skip_already_read_enabled',
		GetLocStringById(2119545270)
		);

		this.onHover(
		'acs_container_take_all_skip_herbs_enabled',
		GetLocStringById(2119545271)
		);

		this.onHover(
		'acs_container_take_all_skip_armors_enabled',
		GetLocStringById(2119545272)
		);

		this.onHover(
		'acs_container_take_all_skip_weapon_enabled',
		GetLocStringById(2119545273)
		);

		this.onHover(
		'acs_container_take_all_skip_ingredients_enabled',
		GetLocStringById(2119545274)
		);

		this.onHover(
		'acs_container_take_all_skip_currency_enabled',
		GetLocStringById(2119545275)
		);

		this.onHover(
		'acs_container_take_all_skip_food_enabled',
		GetLocStringById(2119545276)
		);

		this.onHover(
		'acs_container_take_all_skip_upgrade_enabled',
		GetLocStringById(2119545277)
		);

		this.onHover(
		'acs_container_take_all_skip_horse_items_enabled',
		GetLocStringById(2119545278)
		);

		this.onHover(
		'acs_container_take_all_skip_trophies_enabled',
		GetLocStringById(2119545279)
		);

		this.onHover(
		'acs_container_take_all_skip_toolkit_enabled',
		GetLocStringById(2119545280)
		);

		this.onHover(
		'acs_container_take_all_skip_formulas_enabled',
		GetLocStringById(2119545281)
		);

		this.onHover(
		'acs_container_take_all_skip_masks_enabled',
		GetLocStringById(2119545282)
		);

		this.onHover(
		'acs_container_take_all_skip_keys_enabled',
		GetLocStringById(2119545283)
		);

		this.onHover(
		'acs_container_take_all_skip_others_enabled',
		GetLocStringById(2119545284)
		);

		this.onHover(
		'acs_interaction_buffer_enabled',
		GetLocStringById(2119545285)
		);

		this.onHover(
		'acs_reset_tut_popups',
		GetLocStringById(2119545600)
		);

		this.onHover(
		'acs_custom_combat_music_playlist',
		GetLocStringById(2119545541)
		);

		this.onHover(
		'acs_custom_combat_music_volume',
		GetLocStringById(2119545620)
		);

		this.onHover(
		'acs_auto_win_gwent_enabled',
		GetLocStringById(2119545286)
		);

		this.onHover(
		'acs_meditation_style',
		GetLocStringById(2119545288)
		);

		this.onHover(
		'acs_override_meditation_button_enabled',
		GetLocStringById(2119545289)
		);

		this.onHover(
		'acs_unlimited_durability_enabled',
		GetLocStringById(2119545290)
		);

		this.onHover(
		'acs_auto_read_enabled',
		GetLocStringById(2119545291)
		);

		this.onHover(
		'acs_force_open_locked_doors_with_aard',
		GetLocStringById(2119545292)
		);

		this.onHover(
		'acs_fast_travel_camera_enabled',
		GetLocStringById(2119545607)
		);

		this.onHover(
		'acs_fast_travel_camera_transition_speed',
		GetLocStringById(2119545608)
		);

		this.onHover(
		'acs_disable_vanilla_items_autoscale',
		GetLocStringById(2119545293)
		);

		this.onHover(
		'acs_instant_mount_enabled',
		GetLocStringById(2119545294)
		);

		this.onHover(
		'acs_flip_mount_enabled',
		GetLocStringById(2119545626)
		);

		this.onHover(
		'acs_horse_auto_jump_enabled',
		GetLocStringById(2119545587)
		);

		this.onHover(
		'acs_horse_speed_multiplier',
		GetLocStringById(2119545295)
		);

		this.onHover(
		'acs_horse_vibrations_enabled',
		GetLocStringById(2119545407)
		);

		this.onHover(
		'acs_horse_vibrations_high_freq_adjustment',
		GetLocStringById(2119545408)
		);

		this.onHover(
		'acs_horse_vibrations_low_freq_adjustment',
		GetLocStringById(2119545408)
		);


		this.onHover(
		'acs_horse_motion_leaning_enabled',
		GetLocStringById(2119545296)
		);

		this.onHover(
		'acs_horse_rotate_towards_camera_enabled',
		GetLocStringById(2119545297)
		);

		this.onHover(
		'acs_firesources_auto_enabled',
		GetLocStringById(2119545580)
		);

		this.onHover(
		'acs_firesources_enabled',
		GetLocStringById(2119545298) + GetLocStringById(2117035448)
		);

		this.onHover(
		'acs_firesources_range',
		GetLocStringById(2119545299)
		);

		this.onHover(
		'acs_firesources_entities',
		GetLocStringById(2119545300)
		);

		this.onHover(
		'acs_hide_vampire_claws',
		GetLocStringById(2119545301)
		);

		this.onHover(
		'acs_misc_action_animation_enabled',
		GetLocStringById(2119545302)
		);

		this.onHover(
		'acs_additional_sfx_enabled',
		GetLocStringById(2119545527)
		);

		this.onHover(
		'acs_dirt_vfx_enabled',
		GetLocStringById(2119545636)
		);

		this.onHover(
		'acs_vampire_sound_effects',
		GetLocStringById(2119545303)
		);

		this.onHover(
		'acs_mute_player_enabled',
		GetLocStringById(2119545304)
		);

		this.onHover(
		'acs_meditation_start_with_campfire',
		GetLocStringById(2119545411)
		);

		this.onHover(
		'acs_meditation_time_flow_multiplier',
		GetLocStringById(2119545525)
		);

		this.onHover(
		'acs_meditation_camera_positioning_x',
		GetLocStringById(2119545305)
		);

		this.onHover(
		'acs_meditation_camera_positioning_y',
		GetLocStringById(2119545306)
		);

		this.onHover(
		'acs_meditation_camera_positioning_z',
		GetLocStringById(2119545307)
		);

		this.onHover(
		'acs_meditation_camera_x_offset_adjust_strength',
		GetLocStringById(2119545492)
		);

		this.onHover(
		'acs_meditation_items_enabled',
		GetLocStringById(2119545341)
		);

		this.onHover(
		'acs_meditation_base_positioning',
		GetLocStringById(2119545342)
		);

		this.onHover(
		'acs_meditation_book_on_ground_enabled',
		GetLocStringById(2119545343)
		);

		this.onHover(
		'acs_meditation_herbs_on_ground_enabled',
		GetLocStringById(2119545344)
		);

		this.onHover(
		'acs_meditation_potions_on_ground_enabled',
		GetLocStringById(2119545345)
		);

		this.onHover(
		'acs_meditation_bolts_on_ground_enabled',
		GetLocStringById(2119545346)
		);

		this.onHover(
		'acs_meditation_accessories_on_ground_enabled',
		GetLocStringById(2119545347)
		);

		this.onHover(
		'acs_meditation_weapons_on_ground_enabled',
		GetLocStringById(2119545348)
		);

		this.onHover(
		'acs_meditation_steel_sword_positioning',
		GetLocStringById(2119545349)
		);

		this.onHover(
		'acs_meditation_silver_sword_positioning',
		GetLocStringById(2119545350)
		);

		this.onHover(
		'acs_meditation_crossbow_positioning',
		GetLocStringById(2119545351)
		);



		this.onHover(
		'acs_alternate_quickcasting_controls_enabled',
		GetLocStringById(2119545605)
		);


		this.onHover(
		'acs_enhanced_igni_enabled',
		GetLocStringById(2119545287)
		);

		this.onHover(
		'acs_enhanced_axii_enabled',
		GetLocStringById(2119545510)
		);

		this.onHover(
		'acs_enhanced_aard_enabled',
		GetLocStringById(2119545511)
		);

		this.onHover(
		'acs_enhanced_quen_enabled',
		GetLocStringById(2119545512)
		);

		this.onHover(
		'acs_enhanced_yrden_enabled',
		GetLocStringById(2119545513)
		);

		this.onHover(
		'acs_igni_extra_effects_enabled',
		GetLocStringById(2119545514)
		);

		this.onHover(
		'acs_axii_extra_effects_enabled',
		GetLocStringById(2119545515)
		);

		this.onHover(
		'acs_aard_extra_effects_enabled',
		GetLocStringById(2119545516)
		);

		this.onHover(
		'acs_quen_extra_effects_enabled',
		GetLocStringById(2119545517)
		);

		this.onHover(
		'acs_yrden_extra_effects_enabled',
		GetLocStringById(2119545518)
		);

		this.onHover(
		'acs_reverse_aard_enabled',
		GetLocStringById(2119545519)
		);

		this.onHover(
		'acs_quen_body_electricity_enabled',
		GetLocStringById(2119545520)
		);

		this.onHover(
		'acs_quen_electric_discharge_enabled',
		GetLocStringById(2119545521)
		);

		this.onHover(
		'acs_yrden_trap_enabled',
		GetLocStringById(2119545522)
		);

		this.onHover(
		'acs_axii_wraith_finisher_system',
		GetLocStringById(2119545014)
		);





	}

	function BestiaryHover()
	{
		///// Bestiary /////

			///// Enhanced Enemies /////

				this.onHover(
				'acs_enhanced_enemies_overview',
				GetLocStringById(2117035769)
				);

				this.onHover(
				'acs_drowners_bestiary',
				GetLocStringById(2117035427)
				);

				this.onHover(
				'acs_ghouls_bestiary',
				GetLocStringById(2117035430)
				);

				this.onHover(
				'acs_swordsman_bestiary',
				GetLocStringById(2117035483)
				);

				this.onHover(
				'acs_nekker_guardian_bestiary',
				GetLocStringById(2117035435)
				);

				this.onHover(
				'acs_novigrad_vampires_bestiary',
				GetLocStringById(2117035437)
				);

				this.onHover(
				'acs_pixie_guardian_bestiary',
				GetLocStringById(2118449069)
				);

				this.onHover(
				'acs_vampires_lifesteal_bestiary',
				GetLocStringById(2118449112)
				);

				this.onHover(
				'acs_werewolves_bestiary',
				GetLocStringById(2117035446)
				);

				this.onHover(
				'acs_wild_hunt_hounds_bestiary',
				GetLocStringById(2117035440)
				);

			///// Additional Random Encounters /////

				this.onHover(
				'acs_additional_random_encounters_overview',
				GetLocStringById(2117035771)
				);

				this.onHover(
				'acs_elder_blood_assassins_bestiary',
				GetLocStringById(2118449042)
				);

				this.onHover(
				'acs_night_hunter_bestiary',
				GetLocStringById(2117035436)
				);

				this.onHover(
				'acs_shadow_of_the_forest_god_bestiary',
				GetLocStringById(2117035429)
				);

				this.onHover(
				'acs_wild_hunt_warriors_bestiary',
				GetLocStringById(2117035441)
				);


			///// Additional World Encounters /////

				this.onHover(
				'acs_additional_world_encounters_overview',
				GetLocStringById(2117035773)
				);

				this.onHover(
				'acs_alexander_bestiary',
				GetLocStringById(2117035416)
				);

				this.onHover(
				'acs_barbegazi_bestiary',
				GetLocStringById(2118449701)
				);

				this.onHover(
				'acs_bauk_bestiary',
				GetLocStringById(2118449403)
				);

				this.onHover(
				'acs_berstuk_bestiary',
				GetLocStringById(2117035424)
				);

				this.onHover(
				'acs_blood_hym_bestiary',
				GetLocStringById(2117035777)
				);

				this.onHover(
				'acs_bullvore_bestiary',
				GetLocStringById(2118449890)
				);

				this.onHover(
				'acs_bumbakvetch_bestiary',
				GetLocStringById(2118449040)
				);

				this.onHover(
				'acs_lynx_assassin_bestiary',
				GetLocStringById(2117035524)
				);

				this.onHover(
				'acs_dracogryph_bestiary',
				GetLocStringById(2118449982)
				);

				this.onHover(
				'acs_manticore_bestiary',
				GetLocStringById(2118449271)
				);

				this.onHover(
				'acs_arachne_bestiary',
				GetLocStringById(2118449977)
				);

				this.onHover(
				'acs_chironex_bestiary',
				GetLocStringById(2118449143)
				);

				this.onHover(
				'acs_corpse_lily_bestiary',
				GetLocStringById(2118449391)
				);

				this.onHover(
				'acs_cult_of_melusine_bestiary',
				GetLocStringById(2117035658)
				);

				this.onHover(
				'acs_dao_bestiary',
				GetLocStringById(2118449146)
				);

				this.onHover(
				'acs_dark_knight_bestiary',
				GetLocStringById(2118449107)
				);

				this.onHover(
				'acs_demonic_construct_bestiary',
				GetLocStringById(2118449070)
				);

				this.onHover(
				'acs_draug_bestiary',
				GetLocStringById(2117035712)
				);

				this.onHover(
				'acs_draugir_bestiary',
				GetLocStringById(2117035713)
				);

				this.onHover(
				'acs_dullahan_bestiary',
				GetLocStringById(2118449335)
				);

				this.onHover(
				'acs_duskwraith_bestiary',
				GetLocStringById(2117035704)
				);

				this.onHover(
				'acs_elemental_titans_bestiary',
				GetLocStringById(2118449097)
				);

				this.onHover(
				'acs_fog_assassin_bestiary',
				GetLocStringById(2117035564)
				);

				this.onHover(
				'acs_vigilosaur_bestiary',
				GetLocStringById(2118449346)
				);

				this.onHover(
				'acs_fire_wyrm_bestiary',
				GetLocStringById(2117035428)
				);

				this.onHover(
				'acs_frightener_bestiary',
				GetLocStringById(2118449460)
				);

				this.onHover(
				'acs_frost_boar_bestiary',
				GetLocStringById(2118449043)
				);

				this.onHover(
				'acs_fungoid_bestiary',
				GetLocStringById(2119545624)
				);

				this.onHover(
				'acs_ice_titan_bestiary',
				GetLocStringById(2117035431)
				);

				this.onHover(
				'acs_hellhound_bestiary',
				GetLocStringById(2117035562)
				);

				this.onHover(
				'acs_giant_troll_bestiary',
				GetLocStringById(2118449088)
				);

				this.onHover(
				'acs_the_beast_bestiary',
				GetLocStringById(2118449094)
				);

				this.onHover(
				'acs_ifrit_bestiary',
				GetLocStringById(2118449124)
				);

				this.onHover(
				'acs_incubus_bestiary',
				GetLocStringById(2117035708)
				);

				this.onHover(
				'acs_koshchey_bestiary',
				GetLocStringById(2118449469)
				);

				this.onHover(
				'acs_iridescent_sharley_bestiary',
				GetLocStringById(2118449138)
				);

				this.onHover(
				'acs_kikimore_queen_bestiary',
				GetLocStringById(2118449413)
				);

				this.onHover(
				'acs_knightmare_bestiary',
				GetLocStringById(2118449275)
				);

				this.onHover(
				'acs_knightmare_eternum_bestiary',
				GetLocStringById(2117035433)
				);

				this.onHover(
				'acs_knocker_bestiary',
				GetLocStringById(2118449180)
				);

				this.onHover(
				'acs_loviatar_bestiary',
				GetLocStringById(2117035434)
				);

				this.onHover(
				'acs_maerolorn_bestiary',
				GetLocStringById(2118449121)
				);

				this.onHover(
				'acs_mimic_bestiary',
				GetLocStringById(2118449721)
				);

				this.onHover(
				'acs_mula_bestiary',
				GetLocStringById(2117035718)
				);

				this.onHover(
				'acs_naga_bestiary',
				GetLocStringById(2116581151)
				);

				this.onHover(
				'acs_fire_gargoyle_bestiary',
				GetLocStringById(2117035522)
				);

				this.onHover(
				'acs_nimean_panther_bestiary',
				GetLocStringById(2118449045)
				);

				this.onHover(
				'acs_nekurat_bestiary',
				GetLocStringById(2118449187)
				);

				this.onHover(
				'acs_revenant_bestiary',
				GetLocStringById(2117035714)
				);

				this.onHover(
				'acs_opinicus_matriarch_bestiary',
				GetLocStringById(2117035716)
				);

				this.onHover(
				'acs_kayran_bestiary',
				GetLocStringById(2118449714)
				);

				this.onHover(
				'acs_phooca_bestiary',
				GetLocStringById(2118449081)
				);

				this.onHover(
				'acs_plumard_bestiary',
				GetLocStringById(2118449085)
				);

				this.onHover(
				'acs_rat_king_bestiary',
				GetLocStringById(2118449731)
				);

				this.onHover(
				'acs_rioghan_of_the_abyss_bestiary',
				GetLocStringById(2117035660)
				);

				this.onHover(
				'acs_rogue_mages_bestiary',
				GetLocStringById(2117035438)
				);

				this.onHover(
				'acs_shade_bestiary',
				GetLocStringById(2116581191)
				);

				this.onHover(
				'acs_svalblod_bestiary',
				GetLocStringById(2117035702)
				);

				this.onHover(
				'acs_swarm_mother_bestiary',
				GetLocStringById(2118449194)
				);

				this.onHover(
				'acs_wicked_witch_bestiary',
				GetLocStringById(2118449397)
				);

				this.onHover(
				'acs_ungoliant_bestiary',
				GetLocStringById(2118449329)
				);

				this.onHover(
				'acs_vendigo_bestiary',
				GetLocStringById(2118449191)
				);

				this.onHover(
				'acs_vildkaarl_bestiary',
				GetLocStringById(2117035703)
				);

				this.onHover(
				'acs_viy_of_maribor_bestiary',
				GetLocStringById(2118449078)
				);

				this.onHover(
				'acs_vodyanoi_bestiary',
				GetLocStringById(2116581175)
				);

				this.onHover(
				'acs_voref_bestiary',
				GetLocStringById(2118449114)
				);

				this.onHover(
				'acs_xeno_swarm_soldier_bestiary',
				GetLocStringById(2117035442)
				);

				this.onHover(
				'acs_xeno_swarm_tyrant_bestiary',
				GetLocStringById(2117035443)
				);

				this.onHover(
				'acs_xeno_swarm_worker_bestiary',
				GetLocStringById(2117035444)
				);

				this.onHover(
				'acs_night_witch_bestiary',
				GetLocStringById(2116581183)
				);

				this.onHover(
				'acs_strzyga_bestiary',
				GetLocStringById(2116581274)
				);
				

			///// Special Encounters /////

				this.onHover(
				'acs_special_encounters_overview',
				GetLocStringById(2117035775)
				);

				this.onHover(
				'acs_blade_of_the_unseen_bestiary',
				GetLocStringById(2117035425)
				);

				this.onHover(
				'acs_khagmar_bestiary',
				GetLocStringById(2117035432)
				);

				this.onHover(
				'acs_lady_of_the_wood_bestiary',
				GetLocStringById(2119545623)
				);

				this.onHover(
				'acs_melusine_of_the_storm_bestiary',
				GetLocStringById(2117035659)
				);

				this.onHover(
				'acs_volos_bestiary',
				GetLocStringById(2117035439)
				);
	}

	function TutorialHover()
	{
		///// Tutorial /////

			///// Additional Features /////

				this.onHover(
				'acs_cloak_weapon_hide_tutorial',
				GetLocStringById(2117035479)
				);

				this.onHover(
				'acs_lights_tutorial',
				GetLocStringById(2117035448)
				);

				this.onHover(
				'acs_lightning_tutorial',
				GetLocStringById(2117035516)
				);

				this.onHover(
				'acs_guiding_wind_tutorial',
				GetLocStringById(2119545430)
				);

				this.onHover(
				'acs_horse_controls_tutorial',
				GetLocStringById(2118449688)
				);

				this.onHover(
				'acs_reading_all_items_tutorial',
				GetLocStringById(2117035514)
				);

				this.onHover(
				'acs_night_vision_tutorial',
				GetLocStringById(2118449127)
				);

				this.onHover(
				'acs_quest_tracking_swap_tutorial',
				GetLocStringById(2117035477)
				);

				this.onHover(
				'acs_guards_tutorial',
				GetLocStringById(2117035364)
				);

				this.onHover(
				'acs_durability_tutorial',
				GetLocStringById(2117035512)
				);

				this.onHover(
				'acs_swords_on_roach_tutorial',
				GetLocStringById(2118449294)
				);

				this.onHover(
				'acs_quick_inventory_tutorial',
				GetLocStringById(2118449623)
				);

				this.onHover(
				'acs_quick_meditation_tutorial',
				GetLocStringById(2117035450)
				);

				this.onHover(
				'acs_underwater_aard_tutorial',
				GetLocStringById(2118449621)
				);



			///// Combat /////


				this.onHover(
				'acs_active_counter_tutorial',
				GetLocStringById(2119545352)
				);

				this.onHover(
				'acs_armor_system_tutorial',
				GetLocStringById(2117035454)
				);

				this.onHover(
				'acs_dynamic_enemy_tutorial',
				GetLocStringById(2117035362)
				);

				this.onHover(
				'acs_elemental_combo_system_tutorial',
				GetLocStringById(2117035475)
				);

				this.onHover(
				'acs_finisher_tutorial',
				GetLocStringById(2117035537)
				);

				this.onHover(
				'acs_hit_lag_tutorial',
				GetLocStringById(2118449296)
				);

				this.onHover(
				'acs_leap_strike_tutorial',
				GetLocStringById(2118449762)
				);

				this.onHover(
				'acs_mounted_attack_tutorial',
				GetLocStringById(2119545431)
				);

				this.onHover(
				'acs_marked_phantom_finisher_tutorial',
				GetLocStringById(2118449431)
				);

				this.onHover(
				'acs_parry_tutorial',
				GetLocStringById(2117035747)
				);

				this.onHover(
				'acs_posture_tutorial',
				GetLocStringById(2119545612)
				);

				this.onHover(
				'acs_combat_art_tutorial',
				GetLocStringById(2116581015)
				);

				this.onHover(
				'acs_phantom_attack_tutorial',
				GetLocStringById(2118449429)
				);

				this.onHover(
				'acs_rage_system_tutorial',
				GetLocStringById(2117035360)
				);

				this.onHover(
				'acs_sign_combo_system_tutorial',
				GetLocStringById(2118449162)
				);

				this.onHover(
				'acs_on_hit_switch_tutorial',
				GetLocStringById(2119545591)
				);

				this.onHover(
				'acs_sneaking_tutorial',
				GetLocStringById(2117035927)
				);

				this.onHover(
				'acs_somne_tutorial',
				GetLocStringById(2119545590)
				);

				this.onHover(
				'acs_stance_switching_tutorial',
				GetLocStringById(2119545532)
				);

				this.onHover(
				'acs_counter_wound_tutorial',
				GetLocStringById(2119545533)
				);

				this.onHover(
				'acs_sword_glint_tutorial',
				GetLocStringById(2116581186)
				);

				this.onHover(
				'acs_perfect_dodges_counters_tutorial',
				GetLocStringById(2117035452)
				);

				this.onHover(
				'acs_weapon_arts_tutorial',
				GetLocStringById(2117035856)
				);


				this.onHover(
				'acs_bomb_parry_tutorial',
				GetLocStringById(2119545593)
				);

				this.onHover(
				'acs_crossbow_parry_tutorial',
				GetLocStringById(2119545592)
				);

				this.onHover(
				'acs_heliotrop_parry_tutorial',
				GetLocStringById(2119545594)
				);

				this.onHover(
				'acs_heliotrop_parry_tutorial',
				GetLocStringById(2119545612)
				);


			///// Item /////


				this.onHover(
				'acs_hood_and_mask_tutorial',
				GetLocStringById(2117035706)
				);

				this.onHover(
				'acs_horse_lantern_tutorial',
				GetLocStringById(2118449630)
				);

				this.onHover(
				'acs_allblack_tutorial',
				GetLocStringById(2117035521)
				);

				this.onHover(
				'acs_zireal_tutorial',
				GetLocStringById(2117035501)
				);

				this.onHover(
				'acs_azkar_tutorial',
				GetLocStringById(2118449050)
				);

				this.onHover(
				'acs_phoenix_ashes_tutorial',
				GetLocStringById(2118449225)
				);

				this.onHover(
				'acs_echinops_player_turret_tutorial',
				GetLocStringById(2118449395)
				);

				this.onHover(
				'acs_kestral_skull_tutorial',
				GetLocStringById(2118449185)
				);

				this.onHover(
				'acs_dual_wield_tutorial',
				GetLocStringById(2119545340)
				);

				this.onHover(
				'acs_spear_transform_tutorial',
				GetLocStringById(2116581053)
				);

				this.onHover(
				'acs_grappling_hook_launcher_tutorial',
				GetLocStringById(2118449433)
				);

				this.onHover(
				'acs_wolf_heart_tutorial',
				GetLocStringById(2117035569)
				);

				this.onHover(
				'acs_secondary_weapon_throwing_tutorial',
				GetLocStringById(2119545405)
				);

				this.onHover(
				'acs_slayer_tutorial',
				GetLocStringById(2119545635)
				);

				this.onHover(
				'acs_torch_tutorial',
				GetLocStringById(2119545406)
				);

				this.onHover(
				'acs_throwing_knife_tutorial',
				GetLocStringById(2118449626)
				);

				this.onHover(
				'acs_vampire_claws_tutorial',
				GetLocStringById(2118449442)
				);

				this.onHover(
				'acs_giant_bone_tutorial',
				GetLocStringById(2118449387)
				);

				this.onHover(
				'acs_sharley_shard_tutorial',
				GetLocStringById(2118449141)
				);

				this.onHover(
				'acs_bruxa_fang_tutorial',
				GetLocStringById(2117035892)
				);

				this.onHover(
				'acs_red_miasmal_fragment_tutorial',
				GetLocStringById(2118449105)
				);

				this.onHover(
				'acs_vampire_ring_tutorial',
				GetLocStringById(2117035894)
				);

				this.onHover(
				'acs_vampire_necklace_tutorial',
				GetLocStringById(2117035662)
				);

				this.onHover(
				'acs_black_wolf_pelt_tutorial',
				GetLocStringById(2118449333)
				);

				this.onHover(
				'acs_transformation_werewolf_tutorial',
				GetLocStringById(2117035366)
				);

				this.onHover(
				'acs_toad_prince_venom_tutorial',
				GetLocStringById(2118449054)
				);

				this.onHover(
				'acs_wisp_tutorial',
				GetLocStringById(2117035541)
				);

				this.onHover(
				'acs_wisp_level_05_tutorial',
				GetLocStringById(2117035552)
				);

				this.onHover(
				'acs_wisp_level_10_tutorial',
				GetLocStringById(2117035554)
				);

				this.onHover(
				'acs_wisp_level_15_tutorial',
				GetLocStringById(2117035556)
				);

				this.onHover(
				'acs_wisp_level_20_tutorial',
				GetLocStringById(2117035558)
				);

				this.onHover(
				'acs_wisp_level_25_tutorial',
				GetLocStringById(2117035560)
				);


			///// Movement /////

				this.onHover(
				'acs_bruxa_dash_tutorial',
				GetLocStringById(2117035370)
				);

				this.onHover(
				'acs_double_jump_tutorial',
				GetLocStringById(2118449706)
				);

				this.onHover(
				'acs_glide_tutorial',
				GetLocStringById(2117035368)
				);

				this.onHover(
				'acs_hold_to_roll_tutorial',
				GetLocStringById(2118449075)
				);

				this.onHover(
				'acs_combat_slide_tutorial',
				GetLocStringById(2116581005)
				);

				this.onHover(
				'acs_wraith_mode_tutorial',
				GetLocStringById(2117035372)
				);

			///// Combat Arts /////

				this.onHover(
				'acs_spiral_cloud_passage_tutorial',
				GetLocStringById(2116581030)
				);

				this.onHover(
				'acs_feainnewedd_dance_tutorial',
				GetLocStringById(2116581017)
				);

				this.onHover(
				'acs_mortal_draw_tutorial',
				GetLocStringById(2116581034)
				);

				this.onHover(
				'acs_one_mind_tutorial',
				GetLocStringById(2116581026)
				);

				this.onHover(
				'acs_wolven_cross_tutorial',
				GetLocStringById(2116581038)
				);

				this.onHover(
				'acs_wolven_flash_tutorial',
				GetLocStringById(2116581042)
				);

				this.onHover(
				'acs_shadowfall_tutorial',
				GetLocStringById(2116581046)
				);

			///// Weapon Arts /////

				this.onHover(
				'acs_umbral_slash_tutorial',
				GetLocStringById(2118449303)
				);

				this.onHover(
				'acs_sparagmos_tutorial',
				GetLocStringById(2118449305)
				);

				this.onHover(
				'acs_vampire_bat_swarm_tutorial',
				GetLocStringById(2118449307)
				);

				this.onHover(
				'acs_caressing_moon_tutorial',
				GetLocStringById(2118449309)
				);

				this.onHover(
				'acs_storm_spear_tutorial',
				GetLocStringById(2118449311)
				);

				this.onHover(
				'acs_judgement_tutorial',
				GetLocStringById(2118449313)
				);

				this.onHover(
				'acs_water_pulse_tutorial',
				GetLocStringById(2118449315)
				);

				this.onHover(
				'acs_earthshaker_tutorial',
				GetLocStringById(2118449317)
				);

				this.onHover(
				'acs_bruxa_scream_tutorial',
				GetLocStringById(2118449319)
				);

				this.onHover(
				'acs_way_of_the_flame_tutorial',
				GetLocStringById(2118449321)
				);

				this.onHover(
				'acs_heavenly_strike_tutorial',
				GetLocStringById(2118449323)
				);

				this.onHover(
				'acs_dance_of_wrath_tutorial',
				GetLocStringById(2118449325)
				);

				this.onHover(
				'acs_gwynbleidd_stance_tutorial',
				GetLocStringById(2118449327)
				);



			///// Witcher School /////

				this.onHover(
				'acs_witcher_school_tutorial',
				GetLocStringById(2117035485)
				);

				this.onHover(
				'acs_bear_school_tutorial',
				GetLocStringById(2117035487)
				);

				this.onHover(
				'acs_cat_school_tutorial',
				GetLocStringById(2117035489)
				);

				this.onHover(
				'acs_forgotten_wolf_school_tutorial',
				GetLocStringById(2117035491)
				);

				this.onHover(
				'acs_griffin_school_tutorial',
				GetLocStringById(2117035493)
				);

				this.onHover(
				'acs_manticore_school_tutorial',
				GetLocStringById(2117035495)
				);

				this.onHover(
				'acs_viper_school_tutorial',
				GetLocStringById(2117035497)
				);

				this.onHover(
				'acs_wolf_school_tutorial',
				GetLocStringById(2117035499)
				);
	}

	protected function dynamicDescription( menu: string, option: name, description: string): string 
	{
		var value					: float;

		switch(option)
		{
			case 'acs_version_control':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_main_settings', option));

				if (value == 0) 
				{
					return description + GetLocStringById(2119545308);
				}
			break;

			case 'acs_weapon_mode':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_combat_main_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035008) + ":" + "</b><br/><br/>" + GetLocStringById(2119545309);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035009) + ":" + "</b><br/><br/>" + GetLocStringById(2119545310);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035010) + ":" + "</b><br/><br/>" + GetLocStringById(2119545311);
				}
				else if (value == 3) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035011) + ":" + "</b><br/><br/>" + GetLocStringById(2119545312);
				}
			break;

			case 'acs_fist_mode':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_combat_main_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035019) + ":" + "</b><br/><br/>" + GetLocStringById(2119545313);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035020) + ":" + "</b><br/><br/>" + GetLocStringById(2119545314);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035021) + ":" + "</b><br/><br/>" + GetLocStringById(2119545315);
				}
			break;

			case 'acs_steel_silver_moveset_switch':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_combat_main_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449746) + ":" + "</b><br/><br/>" + GetLocStringById(2119545318);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449747) + ":" + "</b><br/><br/>" + GetLocStringById(2119545319);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449748) + ":" + "</b><br/><br/>" + GetLocStringById(2119545320);
				}
				else if (value == 3) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449749) + ":" + "</b><br/><br/>" + GetLocStringById(2119545321);
				}
			break;

			case 'acs_armiger_mode_weapon_type':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_armiger_mode_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035049) + ":" + "</b><br/><br/>" + GetLocStringById(2119545322);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035050) + ":" + "</b><br/><br/>" + GetLocStringById(2119545323);
				}
			break;

			case 'acs_focus_mode_weapon_type':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_focus_mode_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035068) + ":" + "</b><br/><br/>" + GetLocStringById(2119545322);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035069) + ":" + "</b><br/><br/>" + GetLocStringById(2119545323);
				}
			break;

			case 'acs_hybrid_mode_weapon_type':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_hybrid_mode_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035097) + ":" + "</b><br/><br/>" + GetLocStringById(2119545322);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035098) + ":" + "</b><br/><br/>" + GetLocStringById(2119545323);
				}
			break;

			case 'acs_crossbow_damage_max_health_or_current_health':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_damage_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035974) + ":" + "</b><br/><br/>" + GetLocStringById(2119545324);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035975) + ":" + "</b><br/><br/>" + GetLocStringById(2119545325);
				}
			break;

			case 'acs_compass_or_floating_3d_markers':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_hud_settings_markers', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449803) + ":" + "</b><br/><br/>" + GetLocStringById(2119545326);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449804) + ":" + "</b><br/><br/>" + GetLocStringById(2119545327);
				}
			break;

			case 'acs_fur_cloak_options':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_player_equipment_visual_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449617) + ":" + "</b><br/><br/>" + GetLocStringById(2119545328);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449618) + ":" + "</b><br/><br/>" + GetLocStringById(2119545329);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449619) + ":" + "</b><br/><br/>" + GetLocStringById(2119545330);
				}
			break;

			case 'acs_sword_flair':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_taunt_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449406) + ":" + "</b><br/><br/>" + GetLocStringById(2119545331);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449407) + ":" + "</b><br/><br/>" + GetLocStringById(2119545332);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2118449408) + ":" + "</b><br/><br/>" + GetLocStringById(2119545333);
				}
			break;

			case 'acs_custom_finisher_camera_options':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_custom_finishers_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035988) + ":" + "</b><br/><br/>" + GetLocStringById(2119545334);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035989) + ":" + "</b><br/><br/>" + GetLocStringById(2119545335);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035990) + ":" + "</b><br/><br/>" + GetLocStringById(2119545336);
				}
			break;

			case 'acs_target_mode':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_target_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035023) + ":" + "</b><br/><br/>" + GetLocStringById(2119545337);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035024) + ":" + "</b><br/><br/>" + GetLocStringById(2119545338);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035025) + ":" + "</b><br/><br/>" + GetLocStringById(2119545339);
				}
			break;

			case 'acs_horse_speed_multiplier':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_horse_settings', option));

				if (value >= 2) 
				{
					return description + "<br/><br/>" + GetLocStringById(2119545412);
				}
			break;

			case 'acs_swords_positioning_when_cloaked':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_player_equipment_visual_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581145) + ":" + "</b><br/><br/>" + GetLocStringById(2119545505);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581146) + ":" + "</b><br/><br/>" + GetLocStringById(2119545506);
				}
			break;

			case 'acs_custom_combat_music_playlist':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_misc_main_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581205) + ":" + "</b><br/><br/>" + GetLocStringById(2119545536);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581206) + ":" + "</b><br/><br/>" + GetLocStringById(2119545537);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581208) + ":" + "</b><br/><br/>" + GetLocStringById(2119545538);
				}
				else if (value == 3) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581293) + ":" + "</b><br/><br/>" + GetLocStringById(2119545617);
				}
				else if (value == 4) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581294) + ":" + "</b><br/><br/>" + GetLocStringById(2119545618);
				}
				else if (value == 5) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581207) + ":" + "</b><br/><br/>" + GetLocStringById(2119545539);
				}
				else if (value == 6) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581209) + ":" + "</b><br/><br/>" + GetLocStringById(2119545540);
				}
			break;

			case 'acs_alternate_scabbard_steel_style':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_player_equipment_visual_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581219) + ":" + "</b><br/><br/>" + GetLocStringById(2119545547);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581220) + ":" + "</b><br/><br/>" + GetLocStringById(2119545548);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581221) + ":" + "</b><br/><br/>" + GetLocStringById(2119545549);
				}
				else if (value == 3) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581222) + ":" + "</b><br/><br/>" + GetLocStringById(2119545550);
				}
				else if (value == 4) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581223) + ":" + "</b><br/><br/>" + GetLocStringById(2119545551);
				}
				else if (value == 5) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581224) + ":" + "</b><br/><br/>" + GetLocStringById(2119545552);
				}
				else if (value == 6) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581225) + ":" + "</b><br/><br/>" + GetLocStringById(2119545553);
				}
				else if (value == 7) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581226) + ":" + "</b><br/><br/>" + GetLocStringById(2119545554);
				}
				else if (value == 8) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581227) + ":" + "</b><br/><br/>" + GetLocStringById(2119545555);
				}
			break;

			case 'acs_alternate_scabbard_silver_style':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('acs_player_equipment_visual_settings', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581219) + ":" + "</b><br/><br/>" + GetLocStringById(2119545547);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581220) + ":" + "</b><br/><br/>" + GetLocStringById(2119545548);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581221) + ":" + "</b><br/><br/>" + GetLocStringById(2119545549);
				}
				else if (value == 3) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581222) + ":" + "</b><br/><br/>" + GetLocStringById(2119545550);
				}
				else if (value == 4) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581223) + ":" + "</b><br/><br/>" + GetLocStringById(2119545551);
				}
				else if (value == 5) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581224) + ":" + "</b><br/><br/>" + GetLocStringById(2119545552);
				}
				else if (value == 6) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581225) + ":" + "</b><br/><br/>" + GetLocStringById(2119545553);
				}
				else if (value == 7) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581226) + ":" + "</b><br/><br/>" + GetLocStringById(2119545554);
				}
				else if (value == 8) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2116581227) + ":" + "</b><br/><br/>" + GetLocStringById(2119545555);
				}
			break;

			/*
			case 'option_value':
				value = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('options_menu', option));

				if (value == 0) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035008) + ":" + "</b><br/><br/>" + GetLocStringById(2119545540);
				}
				else if (value == 1) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035008) + ":" + "</b><br/><br/>" + GetLocStringById(2119545540);
				}
				else if (value == 2) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035008) + ":" + "</b><br/><br/>" + GetLocStringById(2119545540);
				}
				else if (value == 3) 
				{
					return description + "<br/><br/><b>" + GetLocStringById(2117035008) + ":" + "</b><br/><br/>" + GetLocStringById(2119545540);
				}
			break;
			*/

			default:
			return description;
			break;
		}

		return description;
	}

	////////////////////////////////////////////////////////////////////////////////
	
	public final function enteredAt(menu: string) 
	{
		this.menu_scope = menu;
		this.option_hover_listeners.Clear();
	}

	public final function didEnterAt(menu: string): bool 
	{
		return this.menu_scope == menu;
	}

	public final function onOptionHovered(menu: string, option: name): string 
	{
		var output				: string;
		var dynamic				: bool;
		var i					: int;

		for (i = 0; i < this.option_hover_listeners.Size(); i += 1) 
		{
			if (this.option_hover_listeners[i].option_id != option) 
			{
				continue;
			}

			if (this.option_hover_listeners[i].description_loc_key != "") 
			{
				output += GetLocStringByKey(this.option_hover_listeners[i].description_loc_key);
			}
			else 
			{
				output += this.option_hover_listeners[i].description;
			}

			dynamic = dynamic
			|| this.option_hover_listeners[i].dynamic_description;
		}

		if (dynamic) 
		{
			output = this.dynamicDescription(menu,option,output);
		}

		return output;
	}

	public final function onOptionValueChanged(menu: string, option: name): string 
	{
		var output				: string;
		var i					: int;

		for (i = 0; i < this.option_hover_listeners.Size(); i += 1) 
		{
			if (this.option_hover_listeners[i].option_id != option) 
			{
				continue;
			}

			if (!this.option_hover_listeners[i].dynamic_description) 
			{
				continue;
			}

			if (this.option_hover_listeners[i].description_loc_key != "") 
			{
				output += GetLocStringByKey(this.option_hover_listeners[i].description_loc_key);
			}
			else 
			{
				output += this.option_hover_listeners[i].description;
			}
		}

		output = this.dynamicDescription(menu,option,output);

		return output;
	}

	public final function getMessageFallback(): string 
	{
		return this.message_fallback;
	}

	protected final function onHover( option_id: name, optional description: string, optional description_loc_key: string) 
	{
		this.option_hover_listeners.PushBack(ACS_MenuDescriptor_OptionDescription(option_id,description,description_loc_key,true));
	}

	protected final function withFallbackMessage(optional description: string,optional description_loc_key: string) 
	{
		if (description_loc_key != "") 
		{
			this.message_fallback = GetLocStringByKey(description_loc_key);
		}
		else 
		{
			this.message_fallback = description;
		}
	}
}

// Credits
//- Based upon code taken from the menu descriptor shared util module by Aeltoth.
//- The discovery of the events this bastardized piece of code relies on was made by [MrCementKnight](https://next.nexusmods.com/profile/MrCementKnight?gameId=952).