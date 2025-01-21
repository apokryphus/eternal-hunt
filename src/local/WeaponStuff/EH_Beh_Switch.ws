latent function ACS_BehSwitch(prevStateName : name)
{
	var stupidArray 	: array< name >;

	stupidArray.Clear();
	
	if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
	{
		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}
	}
	else if (ACS_Is_DLC_Installed('e3arp_dlc') )
	{
		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}
	}
	else
	{
		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
		}
	}

	if ( prevStateName == 'PlayerDialogScene' )
	{
		thePlayer.ActivateAndSyncBehaviors(stupidArray);
	}
	else if ( prevStateName == 'TraverseExploration' )
	{
		ACS_ExplorationBehSwitch();
	}
	else
	{
		if(
		prevStateName=='HorseRiding'
		||prevStateName=='DismountBoat'
		||prevStateName=='DismountHorse'
		||prevStateName=='DismountTheVehicle'
		||prevStateName=='Swimming'
		||prevStateName=='MountBoat'
		||prevStateName=='MountHorse'
		||prevStateName=='MountTheVehicle'
		||prevStateName=='Sailing'
		||prevStateName=='ApproachTheVehicle'
		||prevStateName=='UseVehicle')
		{
			thePlayer.ActivateBehaviors(stupidArray);
		}
		else
		{
			if( thePlayer.IsPerformingFinisher()
			|| thePlayer.HasTag('ACS_IsPerformingFinisher')
			) 
			{
				Sleep(0.75f / theGame.GetTimeScale( false ));
			}

			ACS_ExplorationBehSwitch();
		}
	}
}

function ACS_ExplorationBehSwitch()
{
	GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 
	
	if (GetACSWatcher().swordwalkActive())
	{
		GetACSWatcher().setSwordwalkActive(false);
	}

	if (thePlayer.IsAnyWeaponHeld()
	&& !thePlayer.IsWeaponHeld('fist')
	&& GetACSWatcher().AnimProgressCheck()
	&& !thePlayer.HasTag('acs_aard_sword_equipped')
	)
	{
		//GetACSWatcher().SwordTauntRunningSwitch_Actual();
	}

	if (thePlayer.HasTag('ACS_IsSwordWalking'))
	{
		thePlayer.RemoveTag('ACS_IsSwordWalking');
	}

	if (!thePlayer.IsCiri() 
	&& thePlayer.IsAlive()
	&& !ACS_New_Replacers_Female_Active()
	&& !thePlayer.IsThrowingItemWithAim()
	&& !thePlayer.IsThrowingItem()
	&& !thePlayer.IsThrowHold()
	&& !thePlayer.IsUsingHorse()
	&& !thePlayer.IsUsingVehicle()
	)
	{
		GetACSWatcher().CombatBehSwitch();

		GetACSWatcher().register_extra_inputs();

		GetACSWatcher().SetAdrenalineDrain(true);
		
		if (!thePlayer.IsInCombat() && !thePlayer.IsThreatened())
		{
			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& GetACSWatcher().AnimProgressCheck()
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				GetACSWatcher().SwordTauntRunningSwitch_Actual();
			}

			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				if (thePlayer.HasTag('ACS_HasPerformedFinisher'))
				{
					GetACSWatcher().weapon_blood_fx();

					thePlayer.RemoveTag('ACS_HasPerformedFinisher');
				}
			}

			if (thePlayer.HasTag ('acs_summoned_shades'))
			{
				thePlayer.RemoveTag('acs_summoned_shades');
			}
			
			if (thePlayer.HasTag ('acs_ethereal_shout'))
			{
				thePlayer.RemoveTag('acs_ethereal_shout');
			}

			thePlayer.StopEffect('special_attack_only_black_fx');

			thePlayer.StopEffect('special_attack_fx');

			if ( !ACS_Transformation_Activated_Check() )
			{
				thePlayer.BreakAttachment();
			}

			if (FactsQuerySum("ACS_Rage_Sound_Played") > 0)
			{
				FactsRemove("ACS_Rage_Sound_Played");
			}

			if (GetWitcherPlayer().HasTag ('acs_vampire_claws_equipped'))
			{
				GetACSWatcher().RemoveTimer('ClawDestroyDelay');

				if (thePlayer.HasTag('ACS_HasPerformedFinisher'))
				{
					GetACSWatcher().AddTimer('ClawDestroyDelay', 2, false);
				}
				else
				{
					GetACSWatcher().ClawDestroy();
				}
			}
			
			ACS_Skele_Destroy();

			ACS_Sword_Array_Fire_Override();

			ACS_Revenant_Destroy();

			thePlayer.StopEffect('drain_energy');

			GetACSWatcher().Remove_On_Hit_Tags();

			GetACSWatcher().BerserkMarkDestroy();

			ACS_HybridTagRemoval();

			ACS_Axii_Shield_Destroy_IMMEDIATE();

			ACS_Shield_Destroy();

			ACS_ThingsThatShouldBeRemoved(true);

			ACS_RemoveStabbedEntities();

			ACS_Bruxa_Camo_Decoy_Deactivate();

			ACSGetCActor('ACS_Tentacle_1').Destroy();

			ACSGetCActor('ACS_Tentacle_2').Destroy();

			ACSGetCActor('ACS_Tentacle_3').Destroy();

			ACSGetCEntity('acs_tentacle_anchor').Destroy();

			GetACSWatcher().SetRageProcess(false);

			//thePlayer.RemoveTag('ACS_Has_Summoned_Nekker_Guardian');
			
			//GetACSWatcher().AddTimer('ACS_DetachBehaviorTimer', 2, false);

			ACSSignComboIconDestroyAll();

			ACSSignComboSystemRemoveTags();

			GetACSWatcher().ACS_DestroyAllShields();

			//ACSGetCEntityDestroyAll('ACS_Nekker_Life_Force');

			thePlayer.ClearAnimationSpeedMultipliers();

			GetACSWatcher().RemoveAdditionalSpawnTimers();
			
			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay');

			GetACSWatcher().AddTimer('AdditionalSpawnsDelay', RandRangeF(ACS_Settings_Main_Float('EHmodEventsSettings','EHmodEventDelayMaximumTimeInSeconds', 60), ACS_Settings_Main_Float('EHmodEventsSettings','EHmodEventDelayMinimumTimeInSeconds', 30)), false);
		}
		else
		{
			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& GetACSWatcher().AnimProgressCheck()
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 1, false); 
			}

			if (ACS_Armor_Equipped_Check())
			{
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
			}
		}
	}
}

function ACS_CombatBehSwitch()
{
	GetACSWatcher().RemoveTimer('SwordTauntSwitch'); 
	GetACSWatcher().RemoveTimer('SwordTauntRunningSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkLongWeaponSwitch'); 
	GetACSWatcher().RemoveTimer('SwordWalkSwitch'); 
	
	if (GetACSWatcher().swordwalkActive())
	{
		GetACSWatcher().setSwordwalkActive(false);
	}

	if (thePlayer.IsAnyWeaponHeld()
	&& !thePlayer.IsWeaponHeld('fist')
	&& GetACSWatcher().AnimProgressCheck()
	&& !thePlayer.HasTag('acs_aard_sword_equipped')
	)
	{
		//GetACSWatcher().SwordTauntRunningSwitch_Actual();
	}

	if (thePlayer.HasTag('ACS_IsSwordWalking'))
	{
		thePlayer.RemoveTag('ACS_IsSwordWalking');
	}

	if (!thePlayer.IsCiri() 
	&& thePlayer.IsAlive()
	&& !ACS_New_Replacers_Female_Active()
	&& !thePlayer.IsThrowingItemWithAim()
	&& !thePlayer.IsThrowingItem()
	&& !thePlayer.IsThrowHold()
	&& !thePlayer.IsUsingHorse()
	&& !thePlayer.IsUsingVehicle()
	)
	{
		GetACSWatcher().CombatBehSwitch();

		GetACSWatcher().SetAdrenalineDrain(true);

		GetACSWatcher().register_extra_inputs();
		
		if (!thePlayer.IsInCombat() && !thePlayer.IsThreatened())
		{
			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& GetACSWatcher().AnimProgressCheck()
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				GetACSWatcher().SwordTauntRunningSwitch_Actual();
			}

			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				if (thePlayer.HasTag('ACS_HasPerformedFinisher'))
				{
					GetACSWatcher().weapon_blood_fx();

					thePlayer.RemoveTag('ACS_HasPerformedFinisher');
				}
			}

			if (GetWitcherPlayer().HasTag ('acs_vampire_claws_equipped'))
			{
				GetACSWatcher().RemoveTimer('ClawDestroyDelay');

				if (thePlayer.HasTag('ACS_HasPerformedFinisher'))
				{
					GetACSWatcher().AddTimer('ClawDestroyDelay', 2, false);
				}
				else
				{
					GetACSWatcher().ClawDestroy();
				}
			}

			if (thePlayer.HasTag ('acs_summoned_shades'))
			{
				thePlayer.RemoveTag('acs_summoned_shades');
			}
			
			if (thePlayer.HasTag ('acs_ethereal_shout'))
			{
				thePlayer.RemoveTag('acs_ethereal_shout');
			}

			thePlayer.StopEffect('special_attack_only_black_fx');

			thePlayer.StopEffect('special_attack_fx');

			if ( !ACS_Transformation_Activated_Check() )
			{
				thePlayer.BreakAttachment();
			}

			if (FactsQuerySum("ACS_Rage_Sound_Played") > 0)
			{
				FactsRemove("ACS_Rage_Sound_Played");
			}
			
			ACS_Skele_Destroy();

			ACS_Sword_Array_Fire_Override();

			ACS_Revenant_Destroy();

			thePlayer.StopEffect('drain_energy');

			GetACSWatcher().Remove_On_Hit_Tags();

			GetACSWatcher().BerserkMarkDestroy();

			ACS_HybridTagRemoval();

			ACS_Axii_Shield_Destroy_IMMEDIATE();

			ACS_Shield_Destroy();

			ACS_ThingsThatShouldBeRemoved(true);

			ACS_RemoveStabbedEntities();

			ACS_Bruxa_Camo_Decoy_Deactivate();

			ACSGetCActor('ACS_Tentacle_1').Destroy();

			ACSGetCActor('ACS_Tentacle_2').Destroy();

			ACSGetCActor('ACS_Tentacle_3').Destroy();

			ACSGetCEntity('acs_tentacle_anchor').Destroy();

			GetACSWatcher().SetRageProcess(false);

			//thePlayer.RemoveTag('ACS_Has_Summoned_Nekker_Guardian');
			
			//GetACSWatcher().AddTimer('ACS_DetachBehaviorTimer', 2, false);

			ACSSignComboIconDestroyAll();

			ACSSignComboSystemRemoveTags();

			GetACSWatcher().ACS_DestroyAllShields();

			//ACSGetCEntityDestroyAll('ACS_Nekker_Life_Force');

			thePlayer.ClearAnimationSpeedMultipliers();

			GetACSWatcher().RemoveAdditionalSpawnTimers();
			
			GetACSWatcher().RemoveTimer('AdditionalSpawnsDelay');

			GetACSWatcher().AddTimer('AdditionalSpawnsDelay', RandRangeF(ACS_Settings_Main_Float('EHmodEventsSettings','EHmodEventDelayMaximumTimeInSeconds', 60), ACS_Settings_Main_Float('EHmodEventsSettings','EHmodEventDelayMinimumTimeInSeconds', 30)), false);
		}
		else
		{
			if (thePlayer.IsAnyWeaponHeld()
			&& !thePlayer.IsWeaponHeld('fist')
			&& GetACSWatcher().AnimProgressCheck()
			&& !thePlayer.HasTag('acs_aard_sword_equipped')
			)
			{
				GetACSWatcher().RemoveTimer('SwordTauntRunningSwitchSecondary'); 
				GetACSWatcher().AddTimer('SwordTauntRunningSwitchSecondary', 1, false); 
			}

			if (ACS_Armor_Equipped_Check())
			{
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
				thePlayer.SoundEvent("monster_caretaker_fx_summon");
			}
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ACS_Forest_God_Spawn_Controller()
{
	var currentGameTime : GameTime;
	var hours : int;
	
	currentGameTime = theGame.CalculateTimePlayed();
	hours = GameTimeDays(currentGameTime) * 24 + GameTimeHours(currentGameTime);

	if (ACS_Settings_Main_Float('EHmodEventsSettings','EHmodShadowsSpawnChancesNormal', 0.1) != 0
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !thePlayer.IsInNonGameplayCutscene() 
	&& !thePlayer.IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& !ACS_GetHostilesCheck()
	&& !thePlayer.IsInInterior()
	&& thePlayer.IsOnGround()
	&& !thePlayer.IsCiri()
	&& !thePlayer.GetIsHorseRacing()
	&& !ACS_Player_Near_Quest_Marker()
	&& hours >= 7
	)
	{
		if (
		thePlayer.inv.HasItem('mh204_leshy_trophy')
		|| thePlayer.inv.HasItem('mh302_leshy_trophy')
		|| thePlayer.inv.HasItem('Leshy resin')
		|| thePlayer.inv.HasItem('sq204_leshy_talisman')
		|| thePlayer.inv.HasItem('Ancient Leshy mutagen')
		|| thePlayer.inv.HasItem('Leshy mutagen')
		)
		{
			if( RandF() < ACS_Settings_Main_Float('EHmodEventsSettings','EHmodShadowsSpawnChancesNormal', 0.1) * ACS_Settings_Main_Float('EHmodEventsSettings','EHmodShadowsSpawnChancesNormal', 0.1) ) 
			{
				if( ACS_can_spawn_forest_god_shadows() ) 
				{
					ACS_refresh_forest_god_shadows_cooldown();

					if( RandF() < 0.5 ) 
					{
						thePlayer.DisplayHudMessage( "LESHEN ITEMS DETECTED IN INVENTORY. YOU SHALL NOT ESCAPE ME." );
					}
					else
					{
						thePlayer.DisplayHudMessage( "LESHEN ITEMS DETECTED IN INVENTORY. I WILL FIND YOU." );
					}

					GetACSWatcher().ACS_Forest_God_Shadows_Spawner();
				}
			}
		}
		else
		{
			if( RandF() < ACS_Settings_Main_Float('EHmodEventsSettings','EHmodShadowsSpawnChancesNormal', 0.1) ) 
			{
				if( ACS_can_spawn_forest_god_shadows() ) 
				{
					ACS_refresh_forest_god_shadows_cooldown();

					if( RandF() < 0.5 ) 
					{
						thePlayer.DisplayHudMessage( "I SMELL YOUR FEAR, WITCHER. IT DELIGHTS ME." );
					}
					else
					{
						thePlayer.DisplayHudMessage( "TELL ME, WITCHER. DO YOU FEAR DEATH?" );
					}

					GetACSWatcher().ACS_Forest_God_Shadows_Spawner();
				}
			}
		}
	}
}

function ACS_Wild_Hunt_Spawn_Controller()
{
	if( RandF() < ACS_Settings_Main_Float('EHmodEventsSettings','EHmodWildHuntSpawnChancesNormal', 0.1) 
	&& !ACS_GetHostilesCheck()
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !thePlayer.IsInNonGameplayCutscene() 
	&& !thePlayer.IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& !thePlayer.IsInInterior()
	&& thePlayer.IsOnGround()
	&& !thePlayer.IsCiri()
	&& !thePlayer.GetIsHorseRacing()
	&& !ACS_Player_Near_Quest_Marker()
	&& FactsQuerySum("q002_met_emhyr") > 0
	) 
	{
		if (ACS_can_spawn_wild_hunt_warriors())
		{
			ACS_refresh_wild_hunt_warriors_spawn_cooldown();

			GetACSWatcher().ACS_Wild_Hunt_Riders_Spawner();
		}
	}
}

function ACS_NightStalker_Spawn_Controller()
{
	var currentGameTime : GameTime;
	var hours : int;
	
	currentGameTime = theGame.CalculateTimePlayed();
	hours = GameTimeDays(currentGameTime) * 24 + GameTimeHours(currentGameTime);

	if( RandF() < ACS_Settings_Main_Float('EHmodEventsSettings','EHmodNightStalkerSpawnChancesNormal', 0.1) 
	&& ACS_IsNight()
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !thePlayer.IsInNonGameplayCutscene() 
	&& !thePlayer.IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& thePlayer.IsOnGround()
	&& ACS_NightStalkerAreaCheck()
	&& !thePlayer.IsInInterior()
	&& thePlayer.IsOnGround()
	&& !ACS_GetHostilesCheck()
	&& !thePlayer.IsCiri()
	&& !thePlayer.GetIsHorseRacing()
	&& !ACS_Player_Near_Quest_Marker()
	&& hours >= 15
	)
	{
		if (ACS_can_spawn_nightstalker())
		{
			ACS_refresh_nightstalker_spawn_cooldown();

			GetACSWatcher().ACS_SpawnNightStalker();
		}
	}
}

function ACS_Elderblood_Assassin_Spawn_Controller()
{
	var currentGameTime : GameTime;
	var hours : int;
	
	currentGameTime = theGame.CalculateTimePlayed();
	hours = GameTimeDays(currentGameTime) * 24 + GameTimeHours(currentGameTime);

	if( RandF() < ACS_Settings_Main_Float('EHmodEventsSettings','EHmodElderbloodAssassinSpawnChancesNormal',0.1) 
	&& !theGame.IsDialogOrCutscenePlaying() 
	&& !thePlayer.IsInNonGameplayCutscene() 
	&& !thePlayer.IsInGameplayScene()
	&& !ACS_PlayerSettlementCheck(50)
	&& thePlayer.IsOnGround()
	&& !thePlayer.IsInInterior()
	&& !ACS_GetHostilesCheck()
	&& !thePlayer.IsCiri()
	&& !thePlayer.GetIsHorseRacing()
	&& !ACS_Player_Near_Quest_Marker()
	&& hours >= 10
	)
	{
		if (ACS_can_spawn_elderblood_assassin())
		{
			ACS_refresh_elderblood_assassin_spawn_cooldown();

			GetACSWatcher().ACS_SpawnElderbloodAssassin();
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

statemachine class cBehSwitch
{
    function BehSwitch_Engage()
	{
		this.PushState('BehSwitch_Engage');
	}

	function BehSwitch_Engage_2()
	{
		this.PushState('BehSwitch_Engage_2');
	}

	function BehSwitch_Engage_3()
	{
		this.PushState('BehSwitch_Engage_3');
	}
}

state BehSwitch_Engage_3 in cBehSwitch
{
	var stupidArray : array< name >;

	event OnEnterState(prevStateName : name)
	{
		if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
		{
			BehSwitch_SCAAR_3();
		}
		else if (ACS_Is_DLC_Installed('e3arp_dlc') )
		{
			BehSwitch_E3ARP_3();
		}
		else
		{
			BehSwitch_3();
		}	
	}

	entry function BehSwitch_E3ARP_3()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	entry function BehSwitch_SCAAR_3()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	entry function BehSwitch_3()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}
}

state BehSwitch_Engage_2 in cBehSwitch
{
	private var weapontype 										: EPlayerWeapon;
	private var item 											: SItemUniqueId;
	private var res 											: bool;
	private var inv 											: CInventoryComponent;
	private var stupidArray 									: array< name >;

	event OnEnterState(prevStateName : name)
	{
		defaultBehSwitchEntry();
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (thePlayer.IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (thePlayer.IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (thePlayer.IsWeaponHeld('fist'))
		{
			return PW_Fists;
		}
		else
		{
			return PW_None;
		}
	}

	function UpdateBehGraph( optional init : bool )
	{	
		weapontype = GetCurrentMeleeWeapon();
		
		if ( weapontype == PW_None )
		{
			weapontype = PW_Fists;
		}
		
		thePlayer.SetBehaviorVariable( 'WeaponType', 0);
		
		if ( thePlayer.HasTag('acs_vampire_claws_equipped') || thePlayer.HasTag('acs_sorc_fists_equipped') )
		{
			if (thePlayer.GetBehaviorVariable( 'playerWeapon') != (int) PW_Steel)
			{
				thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			}
			
			if (thePlayer.GetBehaviorVariable( 'playerWeaponForOverlay') != (int) PW_Steel)
			{
				thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
			}
		}
		else
		{
			if (thePlayer.GetBehaviorVariable( 'playerWeapon') != (int) weapontype)
			{
				thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			}
			
			if (thePlayer.GetBehaviorVariable( 'playerWeaponForOverlay') != (int) weapontype)
			{
				thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
			}
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			if (thePlayer.GetBehaviorVariable( 'isOnHorse') != 1.0)
			{
				thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
			}
		}
		else
		{
			if (thePlayer.GetBehaviorVariable( 'isOnHorse') != 0.0)
			{
				thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
			}
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 0, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 1, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			default:
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}

	entry function defaultBehSwitchEntry()
	{
		ACS_WeaponDestroyInit(true);

		ACS_HybridTagRemoval();

		if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}

		RestoreStuff();
	}

	latent function RestoreStuff()
	{
		thePlayer.BreakAttachment();

		thePlayer.SetVisibility(true);

		thePlayer.EnableCollisions(true);

		thePlayer.SetCanPlayHitAnim(true); 

		thePlayer.EnableCharacterCollisions(true);

		thePlayer.RemoveBuffImmunity_AllNegative('ACS_Transformation_Immunity_Negative'); 
		thePlayer.RemoveBuffImmunity_AllCritical('ACS_Transformation_Immunity_Critical'); 
		thePlayer.RemoveBuffImmunity_AllNegative('ACS_Finisher_Immune_Negative'); 
		thePlayer.RemoveBuffImmunity_AllCritical('ACS_Finisher_Immune_Critical'); 

		Sleep(0.0625);

		if ( ACS_GetWeaponMode() == 0 )
		{
			GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (ACS_GetWeaponMode() == 1 )
		{
			GetACSWatcher().PrimaryWeaponSwitch();

			GetACSWatcher().SecondaryWeaponSwitch();
		}
		else if (ACS_GetWeaponMode() == 2 )
		{
			if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 0 )
			{
				if (!thePlayer.HasTag('ACSHybridDefaultWeaponTicket')){thePlayer.AddTag('ACSHybridDefaultWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 1 )
			{
				if (!thePlayer.HasTag('ACSHybridOlgierdWeaponTicket')){thePlayer.AddTag('ACSHybridOlgierdWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 2 )
			{
				if (!thePlayer.HasTag('ACSHybridEredinWeaponTicket')){thePlayer.AddTag('ACSHybridEredinWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 3 )
			{
				if (!thePlayer.HasTag('ACSHybridClawWeaponTicket')){thePlayer.AddTag('ACSHybridClawWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 4 )
			{
				if (!thePlayer.HasTag('ACSHybridImlerithWeaponTicket')){thePlayer.AddTag('ACSHybridImlerithWeaponTicket');}

				GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 5 )
			{
				if (!thePlayer.HasTag('ACSHybridSpearWeaponTicket')){thePlayer.AddTag('ACSHybridSpearWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 6 )
			{
				if (!thePlayer.HasTag('ACSHybridGregWeaponTicket')){thePlayer.AddTag('ACSHybridGregWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 7 )
			{
				if (!thePlayer.HasTag('ACSHybridAxeWeaponTicket')){thePlayer.AddTag('ACSHybridAxeWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
			else if ( ACS_Settings_Main_Int('EHmodHybridModeSettings','EHmodHybridModeLightAttack', 0) == 8 )
			{
				if (!thePlayer.HasTag('ACSHybridGiantWeaponTicket')){thePlayer.AddTag('ACSHybridGiantWeaponTicket');}

				GetACSWatcher().SecondaryWeaponSwitch();
			}
		}
		else if (ACS_GetWeaponMode() == 3 )
		{
			GetACSWatcher().PrimaryWeaponSwitch();
		} 

		if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
		{
			ActivateBehaviors_SCAAR_Default();
		}
		else if (ACS_Is_DLC_Installed('e3arp_dlc') )
		{
			ActivateBehaviors_E3ARP_Default();
		}
		else
		{
			ActivateBehaviors_Default();
		}
	}

	latent function ActivateBehaviors_E3ARP_Default()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_SCAAR_Default()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_Default()
	{
		stupidArray.Clear();

		if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
		}
		else
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
			}
			else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
			}
			else if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}
}
 
state BehSwitch_Engage in cBehSwitch
{
	private var weapontype 										: EPlayerWeapon;
	private var item 											: SItemUniqueId;
	private var res 											: bool;
	private var inv 											: CInventoryComponent;
	private var tags 											: array< name >;
	private var stupidArray 									: array< name >;

	event OnEnterState(prevStateName : name)
	{
		Beh_Switch_Entry();
		
		UpdateBehGraph();
	}

	function GetCurrentMeleeWeapon() : EPlayerWeapon
	{
		if (thePlayer.IsWeaponHeld('silversword'))
		{
			return PW_Silver;
		}
		else if (thePlayer.IsWeaponHeld('steelsword'))
		{
			return PW_Steel;
		}
		else if (thePlayer.IsWeaponHeld('fist'))
		{
			return PW_Fists;
		}
		else
		{
			return PW_None;
		}
	}

	function UpdateBehGraph( optional init : bool )
	{	
		weapontype = GetCurrentMeleeWeapon();
		
		if ( weapontype == PW_None )
		{
			weapontype = PW_Fists;
		}
		
		thePlayer.SetBehaviorVariable( 'WeaponType', 0);
		
		if ( thePlayer.HasTag('acs_vampire_claws_equipped') || thePlayer.HasTag('acs_sorc_fists_equipped') )
		{
			if (thePlayer.GetBehaviorVariable( 'playerWeapon') != (int) PW_Steel)
			{
				thePlayer.SetBehaviorVariable( 'playerWeapon', (int) PW_Steel );
			}
			
			if (thePlayer.GetBehaviorVariable( 'playerWeaponForOverlay') != (int) PW_Steel)
			{
				thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) PW_Steel );
			}
		}
		else
		{
			if (thePlayer.GetBehaviorVariable( 'playerWeapon') != (int) weapontype)
			{
				thePlayer.SetBehaviorVariable( 'playerWeapon', (int) weapontype );
			}
			
			if (thePlayer.GetBehaviorVariable( 'playerWeaponForOverlay') != (int) weapontype)
			{
				thePlayer.SetBehaviorVariable( 'playerWeaponForOverlay', (int) weapontype );
			}
		}
		
		if ( thePlayer.IsUsingHorse() )
		{
			if (thePlayer.GetBehaviorVariable( 'isOnHorse') != 1.0)
			{
				thePlayer.SetBehaviorVariable( 'isOnHorse', 1.0 );
			}
		}
		else
		{
			if (thePlayer.GetBehaviorVariable( 'isOnHorse') != 0.0)
			{
				thePlayer.SetBehaviorVariable( 'isOnHorse', 0.0 );
			}
		}
		
		switch ( weapontype )
		{
			case PW_Steel:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 0, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			case PW_Silver:
				thePlayer.SetBehaviorVariable( 'SelectedWeapon', 1, true);
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 1.0, true );
				if ( init )
					res = thePlayer.RaiseEvent('DrawWeaponInstant');
				break;
			default:
				thePlayer.SetBehaviorVariable( 'isHoldingWeaponR', 0.0, true );
				break;
		}
	}
	
	entry function Beh_Switch_Entry()
	{
		if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
		{
			if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
			{
				BehSwitchPrime_SCAAR_Passive_Taunt();
			}
			else
			{
				BehSwitchPrime_SCAAR();
			}
		}
		else if (ACS_Is_DLC_Installed('e3arp_dlc') )
		{
			if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
			{
				BehSwitchPrime_E3ARP_Passive_Taunt();
			}
			else
			{
				BehSwitchPrime_E3ARP();
			}
		}
		else
		{
			if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
			{
				BehSwitchPrime_Passive_Taunt();
			}
			else
			{
				BehSwitchPrime();
			}
		}
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime()
	{
		ActivateBehaviors();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}

			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}

			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh')
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
						}
					}
						
					else if 
					(
						(ACS_GetItem_MageStaff_Steel() || ACS_GetItem_Imlerith_Steel()) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					ACS_GetItem_SorcFists()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
					}
				}
			}
			
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_Passive_Taunt()
	{
		ActivateBehaviors_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt')
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}


				
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_Passive_Taunt_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt')
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt')
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						(ACS_GetItem_MageStaff_Steel() || ACS_GetItem_Imlerith_Steel()) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					ACS_GetItem_SorcFists()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
				}
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
		}
		else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh' );
		}

		

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_passive_taunt' );
		}

		

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors_SCAAR()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (
		thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}
		else if (
		thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
		}

		

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_SCAAR_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (
		thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
		}

		

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR()
	{
		ActivateBehaviors_SCAAR();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh')
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						(ACS_GetItem_MageStaff_Steel() || ACS_GetItem_Imlerith_Steel()) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					ACS_GetItem_SorcFists()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_SCAAR_Passive_Taunt()
	{
		ActivateBehaviors_SCAAR_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_SCAAR_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_SCAAR_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						(ACS_GetItem_MageStaff_Steel() || ACS_GetItem_Imlerith_Steel()) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_SCAAR_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_SCAAR_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_SCAAR_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					ACS_GetItem_SorcFists()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_SCAAR_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_SCAAR_passive_taunt' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function ActivateBehaviors_E3ARP()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (
		thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}
		else if (
		thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
		}

		

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function ActivateBehaviors_E3ARP_Passive_Taunt()
	{
		stupidArray.Clear();

		if (thePlayer.HasTag('acs_quen_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
		}
		else if (thePlayer.HasTag('acs_vampire_claws_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (thePlayer.HasTag('acs_sorc_fists_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
		}
		else if (
		thePlayer.HasTag('acs_igni_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}
		else if (
		thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
		}
		else
		{
			stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
		}

		

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP()
	{
		ActivateBehaviors_E3ARP();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh')
				{
					stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh')
				{
					stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}

			if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
			{
				//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
				//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
				//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
				//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

				//thePlayer.RaiseForceEvent( 'Climb' );

				thePlayer.ActivateBehaviors(stupidArray);
			}
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						(ACS_GetItem_MageStaff_Steel() || ACS_GetItem_Imlerith_Steel()) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					ACS_GetItem_SorcFists()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
					}
				}
			}
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	latent function BehSwitchPrime_E3ARP_Passive_Taunt()
	{
		ActivateBehaviors_E3ARP_Passive_Taunt();

		if (ACS_GetWeaponMode() == 0)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode();
		}
		else if (ACS_GetWeaponMode() == 1)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_FocusMode();
		}
		else if (ACS_GetWeaponMode() == 2)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_HybridMode();
		}
		else if (ACS_GetWeaponMode() == 3)
		{
			BehSwitchPrime_E3ARP_Passive_Taunt_EquipmentMode();
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode()
	{
		if (thePlayer.IsWeaponHeld( 'silversword' ) || thePlayer.IsWeaponHeld( 'steelsword' ))
		{
			if
			(
				(thePlayer.GetEquippedSign() == ST_Igni)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Igni();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Quen)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Quen();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Aard)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Aard();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Axii)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Axii();
			}
			else if
			(
				(thePlayer.GetEquippedSign() == ST_Yrden)
			)
			{
				BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Yrden();
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Igni()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerIgniSignWeapon', 0) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Quen()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerQuenSignWeapon', 1) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Aard()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAardSignWeapon', 3) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Axii()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerAxiiSignWeapon', 2) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_ArmigerMode_Yrden()
	{
		if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 0)
		{
			if (thePlayer.HasTag('acs_igni_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_igni_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 1)
		{
			if (thePlayer.HasTag('acs_quen_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_quen_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 2)
		{
			if (thePlayer.HasTag('acs_axii_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_axii_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 3)
		{
			if (thePlayer.HasTag('acs_aard_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_aard_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}
		else if (ACS_Settings_Main_Int('EHmodArmigerModeSettings','EHmodArmigerYrdenSignWeapon', 4) == 4)
		{
			if (thePlayer.HasTag('acs_yrden_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (thePlayer.HasTag('acs_yrden_secondary_sword_equipped'))
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
				}
			}
			
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_FocusMode()
	{
		if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}	
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 3 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 7 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 5 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 1 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 0 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_igni_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 4 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_axii_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 8 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_aard_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 6 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_yrden_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSilverWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'silversword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped')  )
			|| ( ACS_Settings_Main_Int('EHmodFocusModeSettings','EHmodFocusModeSteelWeapon', 0) == 2 && thePlayer.IsWeaponHeld( 'steelsword' ) && thePlayer.HasTag('acs_quen_secondary_sword_equipped') )
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_HybridMode()
	{
		if 
		(
			thePlayer.HasTag('acs_igni_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' ); 
			}	
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_igni_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_axii_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_aard_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' ); 
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
			}
		}
			
		else if 
		(
			thePlayer.HasTag('acs_quen_secondary_sword_equipped')
		)
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
			{
				  stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
			}
		}
		else if 
		(
			thePlayer.IsWeaponHeld( 'fist' )
		)
		{
			if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 0)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 1)
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
			else if (ACS_Settings_Main_Int('EHmodCombatMainSettings','EHmodFistMode', 0) == 2 )
			{
				if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
				{
					 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
				}
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}

	latent function BehSwitchPrime_E3ARP_Passive_Taunt_EquipmentMode()
	{
		if (thePlayer.IsAnyWeaponHeld())
		{
			if (!thePlayer.IsWeaponHeld( 'fist' ))
			{
				if (thePlayer.IsWeaponHeld( 'silversword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Silver() && thePlayer.HasTag('acs_axii_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Silver() && thePlayer.HasTag('acs_aard_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Imlerith_Silver() && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Silver() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Silver() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Silver() && thePlayer.HasTag('acs_aard_secondary_sword_equipped') 
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Silver() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Silver() &&  thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
				}
				else if (thePlayer.IsWeaponHeld( 'steelsword' ))
				{
					if 
					(
						ACS_GetItem_Eredin_Steel() && thePlayer.HasTag('acs_axii_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Claws_Steel() && thePlayer.HasTag('acs_aard_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						(ACS_GetItem_MageStaff_Steel() || ACS_GetItem_Imlerith_Steel()) && thePlayer.HasTag('acs_yrden_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_primary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Olgierd_Steel() && thePlayer.HasTag('acs_quen_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_primary_beh_E3ARP_passive_taunt' );
						}
					}

					else if 
					(
						ACS_GetItem_Katana_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Greg_Steel() && thePlayer.HasTag('acs_axii_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'axii_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Axe_Steel() && thePlayer.HasTag('acs_aard_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'aard_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'aard_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Hammer_Steel() && thePlayer.HasTag('acs_yrden_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'yrden_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'yrden_secondary_beh_E3ARP_passive_taunt' );
						}
					}
						
					else if 
					(
						ACS_GetItem_Spear_Steel() && thePlayer.HasTag('acs_quen_secondary_sword_equipped')
					)
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'quen_secondary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'quen_secondary_beh_E3ARP_passive_taunt' );
						}
					}
					else
					{
						if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
						{
							 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
						}
					}
				}
			}
			else
			{
				if 
				(
					ACS_GetItem_VampClaw() || ACS_GetItem_VampClaw_Shades()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'claw_beh_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'claw_beh_passive_taunt' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else if 
				(
					ACS_GetItem_SorcFists()
				)
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'acs_sorc_beh' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'acs_sorc_beh' ); GetACSWatcher().PrimaryWeaponSwitch();
					}
				}
				else
				{
					if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
					{
						 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
					}
				}
			} 
		}
		else
		{
			if ( thePlayer.GetBehaviorGraphInstanceName() != 'igni_primary_beh_E3ARP_passive_taunt' )
			{
				 stupidArray.Clear(); stupidArray.PushBack( 'igni_primary_beh_E3ARP_passive_taunt' );
			}
		}

		if (ACSGetCEntity('ACS_Dual_Wield_L_Sword_Steel')
		|| ACSGetCEntity('ACS_Dual_Wield_L_Sword_Silver')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_dual_wield_beh' );
			}
		}

		if (ACSGetCEntity('ACS_Ghost_Sword_Ent'))
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR_passive_taunt' );
				}
				else
				{
					stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_SCAAR' );
				}
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP_passive_taunt' );
					}
					else
					{
						stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_E3ARP' );
					}
			}
			else
			{
				if (ACS_Settings_Main_Bool('EHmodMiscSettings','EHmodPassiveTauntEnabled', false))
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh_passive_taunt' );
                }
                else
                {
                    stupidArray.Clear(); stupidArray.PushBack( 'axii_secondary_beh' );
                }
			}
		}

		if (FactsQuerySum("ACS_Azkar_Active") > 0
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_bow_beh' );
			}
		}

		if (thePlayer.HasTag('acs_crossbow_active')
		)
		{
			if (ACS_Is_DLC_Installed('scaaraiov_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_SCAAR' );
			}
			else if (ACS_Is_DLC_Installed('e3arp_dlc') )
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh_E3ARP' );
			}
			else
			{
				stupidArray.Clear(); stupidArray.PushBack( 'acs_crossbow_beh' );
			}
		}

		
		if (stupidArray.Size() > 0)
		{
			//thePlayer.SetBehaviorVariable( 'ClimbCanEndMode', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbHeightType', 	1 );
			//thePlayer.SetBehaviorVariable( 'ClimbVaultType', 	0);
			//thePlayer.SetBehaviorVariable( 'ClimbPlatformType', 1 );
			//thePlayer.SetBehaviorVariable( 'ClimbStateType', 	0 );

			//thePlayer.RaiseForceEvent( 'Climb' );

			thePlayer.ActivateBehaviors(stupidArray);
		}
	}
}